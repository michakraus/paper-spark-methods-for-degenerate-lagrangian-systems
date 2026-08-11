
using Latexify
using Logging
using Markdown
using Markdown: MD, Paragraph, LineBreak
using CairoMakie

using GeometricIntegrators
using GeometricIntegrators.SPARK
import GeometricIntegratorsBase
const GIB = GeometricIntegratorsBase
using SimpleSolvers: NonlinearSolverException

using GeometricProblems.Diagnostics: plot_energy_error, plot_energy_drift,
                                     plot_constraint_error, plot_lagrange_multiplier

using PoincareInvariants


# Number of points at which the loop and the surface of the Poincaré invariants are sampled.
# `FirstFourierPlan` takes any number of loop points; the surface's `SecondChebyshevPlan` samples
# at Padua points and rounds the count up to the next Padua number, of which 231 = 21·22/2 is one.
const NLOOP = 200
const NSURFACE = 231


# Shared Makie plotting style (kept identical to the SRK companion package). Larger
# fonts and thicker lines than the Makie defaults, tuned for the fixed figure sizes of
# the GeometricProblems plot recipes. Unicode axis labels are selected via `latex=false`
# on every plot call below.
const PLOT_THEME = Theme(
    fontsize = 18,
    Lines    = (linewidth = 2,),
    Scatter  = (markersize = 10,),
    Axis     = (
        xlabelsize     = 22,
        ylabelsize     = 22,
        xticklabelsize = 16,
        yticklabelsize = 16,
        titlesize      = 20,
    ),
)

set_theme!(PLOT_THEME)


# The degenerate Lagrangians make some of the methods diverge, and the Newton solver then
# fails its line search in every iteration of every time step — the last CI run to see them
# drowned in 173000 such warnings, 99% of a 174583-line log. They are turned off at the
# source through `SOLVER_VERBOSITY`, which `SimpleSolvers` shares with its line search. The
# plotting stack offers no such switch: `PlotUtils` emits one unthrottled `No strict ticks
# found` per degenerate axis, so its warnings are dropped on the logging side instead and
# only their count is reported, by `run_list`.
const QUIET_LOG_MODULES = (:PlotUtils, :Makie)
const QUIET_LOG_COUNT = Ref(0)

# Solver verbosity used by `integrate_spark`; `quiet_solver_warnings!` drops it to 0 for the
# weave builds. Interactive sessions keep the default, where the warnings are worth having:
# `SimpleSolvers` rate-limits them to a handful per session.
const SOLVER_VERBOSITY = Ref(1)

struct QuietLogger{L<:AbstractLogger} <: AbstractLogger
    parent::L
end

function Logging.shouldlog(logger::QuietLogger, level, _module, group, id)
    if level < Logging.Error && nameof(_module) ∈ QUIET_LOG_MODULES
        QUIET_LOG_COUNT[] += 1
        return false
    end
    Logging.shouldlog(logger.parent, level, _module, group, id)
end

Logging.min_enabled_level(logger::QuietLogger) = Logging.min_enabled_level(logger.parent)
Logging.catch_exceptions(logger::QuietLogger) = Logging.catch_exceptions(logger.parent)
Logging.handle_message(logger::QuietLogger, args...; kwargs...) =
    Logging.handle_message(logger.parent, args...; kwargs...)

# Turn off the solver warnings and install the filter for the plotting ones. Called by the
# weave driver, not on load, so that interactive sessions keep the warnings unless they ask
# for quiet.
function quiet_solver_warnings!()
    SOLVER_VERBOSITY[] = 0
    global_logger(QuietLogger(global_logger()))
end


# Integrate an IDAE with a SPARK/VSPARK method, collecting the internal and
# projection stage variables (Qi,Pi,Vi,Φi,Qp,Pp,Λp,Φp) alongside the solution.
# The plain `integrate` does not persist these, so we drive the integrator
# step-by-step and read them off the solution step (mirrors GeometricIntegratorsBase's
# own integration loop). A crash (solver failure, singular matrix, NaNs, …) does not
# discard the run: we keep the solution and stages up to the last successful step.
# Returns `(sol, stages, last_good, err)` where `last_good` is the index of the last
# completed step and `err` is `nothing`, `:nan`, or the caught exception.
#
# No iteration cap is imposed on the solver: a non-convergent solve is bounded by the
# stagnation detector of `SimpleSolvers`, which gives up after two consecutive steps that
# leave the iterate unmoved while the residual is still large. `warn_iterations = 0` drops
# the bare iteration-count warning, the one solver message that `verbosity` does not gate.
function integrate_spark(idae, method)
    int     = GIB.GeometricIntegrator(idae, method; f_abstol=1E-14, f_reltol=1E-14,
                                      verbosity=SOLVER_VERBOSITY[], warn_iterations=0)
    sol     = GIB.Solution(idae)
    solstep = GIB.solutionstep(int, sol[0])
    state   = GIB.current(solstep)

    internal = GIB.internal(solstep)
    S  = length(internal.Qi)
    R  = length(internal.Qp)
    D  = length(sol.q[0])
    nt = GIB.ntime(sol)

    series() = DataSeries(zeros(D), nt)
    Qi = [series() for _ in 1:S]; Pi = [series() for _ in 1:S]
    Vi = [series() for _ in 1:S]; Φi = [series() for _ in 1:S]
    Qp = [series() for _ in 1:R]; Pp = [series() for _ in 1:R]
    Λp = [series() for _ in 1:R]; Φp = [series() for _ in 1:R]

    last_good = 0
    err = nothing

    try
        for n in 1:nt
            GIB.reset!(solstep, GIB.timesteps(sol)[n])
            GIB.integrate!(solstep, int)

            if isnan(state)
                err = :nan
                break
            end

            ii = GIB.internal(solstep)
            for i in 1:S
                Qi[i][n] = copy(ii.Qi[i]); Pi[i][n] = copy(ii.Pi[i])
                Vi[i][n] = copy(ii.Vi[i]); Φi[i][n] = copy(ii.Φi[i])
            end
            for i in 1:R
                Qp[i][n] = copy(ii.Qp[i]); Pp[i][n] = copy(ii.Pp[i])
                Λp[i][n] = copy(ii.Λp[i]); Φp[i][n] = copy(ii.Φp[i])
            end

            copy!(sol, state, n)
            last_good = n
        end
    catch ex
        err = ex
    end

    # pad the state after the last good step so downstream invariant computations
    # (energy / momentum error over the full solution) never see uninitialized data
    for n in (last_good+1):nt
        sol.q[n] = copy(sol.q[last_good])
        sol.p[n] = copy(sol.p[last_good])
    end

    (sol, (Qi=Qi, Pi=Pi, Vi=Vi, Φi=Φi, Qp=Qp, Pp=Pp, Λp=Λp, Φp=Φp), last_good, err)
end


# Integrate an IDAE step by step *without* recording the stage variables, for the Poincaré
# invariants below. `integrate_spark` keeps eight `DataSeries` of stages per run, which is what the
# per-run diagnostics need and what an ensemble of a few hundred members cannot afford. Otherwise
# identical to it, down to the partial-result contract: a crash keeps the solution up to the last
# successful time step, and the steps after it are padded with the last good state.
function integrate_partial(idae, method)
    int     = GIB.GeometricIntegrator(idae, method; f_abstol=1E-14, f_reltol=1E-14,
                                      verbosity=SOLVER_VERBOSITY[], warn_iterations=0)
    sol     = GIB.Solution(idae)
    solstep = GIB.solutionstep(int, sol[0])
    state   = GIB.current(solstep)
    nt      = GIB.ntime(sol)

    last_good = 0
    err = nothing

    try
        for n in 1:nt
            GIB.reset!(solstep, GIB.timesteps(sol)[n])
            GIB.integrate!(solstep, int)

            if isnan(state)
                err = :nan
                break
            end

            copy!(sol, state, n)
            last_good = n
        end
    catch ex
        err = ex
    end

    for n in (last_good+1):nt
        sol.q[n] = copy(sol.q[last_good])
        sol.p[n] = copy(sol.p[last_good])
    end

    (sol, last_good, err)
end


# Short, human-readable one-line description of a crash (no stack trace).
function _failure_message(err)
    err === :nan                      && return "NaNs detected in the solution"
    err isa NonlinearSolverException  && return "solver error – " * err.msg
    err isa DomainError               && return "domain error"
    return string(nameof(typeof(err)))
end


# Save the figure produced by `plot` as `<dir>/<file><suffix><fig_suff>`. A failure is
# reported but not propagated: one diagnostic that cannot be plotted (which happens for
# runs that crash after very few time steps) must not cost us the remaining figures.
function _save_plot(plot, dir, file, suffix, fig_suff)
    try
        save(dir * "/" * file * suffix * fig_suff, plot())
    catch ex
        show(stdout, "text/markdown",
             Markdown.parse("**Plotting $(file)$(suffix) failed: $(_failure_message(ex)).**"))
        _linebreak(stdout)
        @warn("Plotting $(file)$(suffix) failed: $(_failure_message(ex))")
    end
end


_arr_str(a) = latexify(a; env=:mdtable, latex=false, side=collect(axes(a,1)), head=collect(axes(a,2)))
_linebreak(io) = show(io, "text/markdown", MD(Paragraph([LineBreak()])))


function write_symplecticity(method, dir, file, name)
    if !isdir(dir)
        mkdir(dir)
    end

    symp_file = dir * "/" * file * ".md"

    tab       = tableau(method)
    symp_cond = GIB.symplecticity_conditions(tab)
    symp_arrs = SPARK.check_symplecticity(tab)

    open(symp_file, "w") do f
        show(f, "text/markdown", Markdown.parse("# $name"))
        _linebreak(f)
        show(f, "text/markdown", Markdown.parse("## Symplecticity Conditions"))
        _linebreak(f)

        for i in eachindex(symp_arrs, symp_cond)
            show(f, "text/markdown", Markdown.parse(symp_cond[i]))
            _linebreak(f)
            show(f, "text/markdown", _arr_str(symp_arrs[i]))
            _linebreak(f)
        end
    end

end


# Reference a figure, but only if it was actually produced: a run that crashed early has no
# energy drift data, and one that crashed on the very first step has no figures at all.
# Referencing them regardless leaves broken images on the page and one `invalid local
# link/image` warning per figure in the Documenter build. Returns whether it wrote one.
function _plot_figure_md(file, name, filename)
    isfile(filename) || return false

    show(file, "text/markdown", Markdown.parse("![$name]($filename)"))
    _linebreak(file)

    true
end


# Write the page collecting all figures of one run. Must be called *after* `run_spark`,
# so that the figures it references already exist on disk.
function write_plots(method, dir, file, name, fig_suff)

    tab = tableau(method)
    plot_file = file * ".md"
    omitted = 0

    open(plot_file, "w") do f
        figure(suffix) = _plot_figure_md(f, name, "$(dir)/$(file)$(suffix)$(fig_suff)") || (omitted += 1)

        show(f, "text/markdown", Markdown.parse("# $name"))
        _linebreak(f)

        figure("_solution")
        figure("_traces")

        show(f, "text/markdown", Markdown.parse("## Energy Error"))
        _linebreak(f)

        figure("_energy_error")
        figure("_energy_drift")

        show(f, "text/markdown", Markdown.parse("## Constraint"))
        _linebreak(f)

        figure("_constraint_error")

        for i in 1:tab.s
            figure("_constraint_error_phi_i$(i)")
        end

        for i in 1:tab.r
            figure("_constraint_error_phi_p$(i)")
        end

        figure("_lambda")

        for i in 1:tab.r
            figure("_lambda_p$(i)")
        end
    end

    omitted > 0 && @warn("Omitted $(omitted) figures from $(plot_file) that were not produced")

    nothing
end


function _plot(sol, stages, equ, dir, file, fig_suff, last_good)
    nt     = ntime(sol)
    ntplot = last_good ≥ nt ? (:auto) : last_good

    # All GeometricProblems recipes set their own x-limits to the plotted time range.
    _save_plot(() -> plot_energy_error(sol; latex=false, nt=ntplot), dir, file, "_energy_error", fig_suff)

    # Drift is an interval-based diagnostic: `plot_energy_drift` splits the solution into ten
    # intervals and its `nt` counts those, not time steps. Show only the intervals completed
    # before a crash, and skip the plot below two of them: a single point has no drift to
    # show and its degenerate x-range throws. Solutions shorter than ten steps have no
    # intervals at all and make the recipe divide by zero (which happens in local tests only).
    interval = max(div(nt, 10), 1)
    ntdrift  = last_good ≥ nt ? (:auto) : div(last_good, interval)

    if nt ≥ 10 && (ntdrift === :auto || ntdrift ≥ 2)
        _save_plot(() -> plot_energy_drift(sol; latex=false, nt=ntdrift), dir, file, "_energy_drift", fig_suff)
    end

    _save_plot(() -> plot_constraint_error(sol; latex=false, nt=ntplot), dir, file, "_constraint_error", fig_suff)

    _save_plot(() -> plot_lagrange_multiplier(sol; latex=false, nt=ntplot), dir, file, "_lambda", fig_suff)

    if stages !== nothing
        for i in eachindex(stages.Φi)
            _save_plot(() -> plot_constraint_error(sol.t, stages.Φi[i]; latex=false, nt=ntplot, plot_title="Φi,$(i)"),
                       dir, file, "_constraint_error_phi_i$(i)", fig_suff)
        end

        for i in eachindex(stages.Φp)
            _save_plot(() -> plot_constraint_error(sol.t, stages.Φp[i]; latex=false, nt=ntplot, plot_title="Φp,$(i)"),
                       dir, file, "_constraint_error_phi_p$(i)", fig_suff)
        end

        for i in eachindex(stages.Λp)
            _save_plot(() -> plot_lagrange_multiplier(sol.t, stages.Λp[i]; latex=false, nt=ntplot, plot_title="Λp,$(i)"),
                       dir, file, "_lambda_p$(i)", fig_suff)
        end
    end
end


function run_spark(idae, method, dir, file, fig_suff, phi_average)
    if !isdir(dir)
        mkdir(dir)
    end

    sol, stages, last_good, err = integrate_spark(idae, method)

    if err !== nothing
        show(stdout, "text/markdown",
             Markdown.parse("**Simulation crashed after $(last_good) of $(ntime(sol)) time steps: $(_failure_message(err)).**"))
        _linebreak(stdout)
        @warn("Simulation crashed after $(last_good) of $(ntime(sol)) time steps: $(_failure_message(err))")
    end

    if phi_average !== nothing && stages !== nothing
        push!(stages.Φp, DataSeries(phi_average([parent(stages.Φp[i]) for i in eachindex(stages.Φp)])))
    end

    # Plot whatever was computed (the trajectory and stages up to the last good step).
    if last_good ≥ 1
        try
            make_plots(sol, stages, idae, dir, file, fig_suff, last_good)
        catch ex
            show(stdout, "text/markdown", Markdown.parse("**Plotting failed: $(_failure_message(ex)).**"))
            _linebreak(stdout)
            @warn("Plotting failed: $(_failure_message(ex))")
        end
    end
end


function run_list(idae, name, list, plot_dir = PLOT_DIR, symp_dir = SYMP_DIR;
                    fig_suff = ".png", phi_average = nothing)

    for run in list
        method = run[1]
        file   = run[2]

        write_symplecticity(method, symp_dir, file, name)

        show(stdout, "text/markdown", Markdown.parse("### $(tableau(method).name)"))
        _linebreak(stdout)

        show(stdout, "text/markdown", Markdown.parse("[Plots]($file.md)"))
        show(stdout, "text/markdown", Markdown.parse(" • "))
        show(stdout, "text/markdown", Markdown.parse("[Symplecticity]($symp_dir/$file.md)"))

        _linebreak(stdout)

        run_spark(idae, method, plot_dir, file, fig_suff, phi_average)

        # The page of figures is written only now, so that it can leave out the ones this
        # run did not produce; same for the overview figure embedded here.
        write_plots(method, plot_dir, file, name, fig_suff)

        overview = "$plot_dir/$file$fig_suff"
        isfile(overview) && show(stdout, "text/markdown", Markdown.parse("![$name]($overview)"))

        # Each run leaves a couple of dozen Makie figures and a full set of stage data
        # series behind; collecting them here keeps the peak footprint of a whole method
        # family within what a CI runner can hold.
        GC.gc()
    end

    if QUIET_LOG_COUNT[] > 0
        @info("Suppressed $(QUIET_LOG_COUNT[]) plotting warnings so far (see QUIET_LOG_MODULES)")
    end

    nothing
end


# The ensemble of trajectories that advects the sampled loop or surface.
#
# `PoincareInvariants.PIEnsembleProblem`, which the SRK and DVI companion packages use, covers
# ODE/PODE/HODE/IODE/LODE only; it has no method for the index-2 DAEs the SPARK integrators solve.
# Its IODE method cannot be reused either, because an `IDAE` initial condition also carries a
# multiplier, whose dimension the equation alone does not determine — it is read off the problem's
# own λ₀ here. Everything else is as upstream: the parameterisation is sampled at the points the
# invariant's plan prescribes, and each member's momentum is seeded from the equation's own
# one-form, which is what a degenerate Lagrangian needs — the momentum is not free, it is ϑ(q).
function pi_ensemble(idae, pinv, init)
    points = getpoints(init, pinv)
    equ    = equation(idae)
    t₀     = timespan(idae)[begin]
    par    = parameters(idae)
    nλ     = length(idae.ics.λ)

    ics = map(axes(points, 1)) do i
        q = collect(view(points, i, :))
        p = zero(q)
        v = zero(q)
        equ.ϑ(p, t₀, q, v, par)
        (q = q, p = p, λ = zeros(eltype(q), nλ))
    end

    EnsembleProblem(equ, timespan(idae), timestep(idae), ics, par)
end


# Advect the sampled loop or surface and evaluate the Poincaré invariant along the way.
#
# The ensemble is integrated one member at a time through `integrate_partial` rather than with
# `integrate(::EnsembleProblem, …)`: the methods studied here diverge on purpose, and a single
# diverging member must cost only its own trajectory, not the whole figure. The result is
# truncated to the first member that failed, so that no padded state enters the invariant.
#
# Returns `(ts, Is, last_good, nt)`, or `nothing` if not one member survived its first step.
function invariant_error(pinv, idae, method, init)
    ensemble = pi_ensemble(idae, pinv, init)

    sols = Vector{Any}(undef, nsamples(ensemble))
    last_good = typemax(Int)

    for (i, prob) in enumerate(ensemble)
        sols[i], lg, _ = integrate_partial(prob, method)
        last_good = min(last_good, lg)
    end

    last_good ≥ 1 || return nothing

    # `compute!` takes one trajectory per sample point, each a vector of phase space points. These
    # Lagrangians are degenerate, so the loop and the surface live in the two-dimensional
    # configuration space alone and only `q` enters; neither the momentum nor the multiplier does.
    ts = [sols[begin].t[n] for n in 0:last_good]
    trajectories = [[sol.q[n] for n in 0:last_good] for sol in sols]

    (ts, compute!(pinv, trajectories, ts, parameters(idae)), last_good, ntime(sols[begin]))
end


# Relative error of a Poincaré invariant over time, in the style of
# `PoincareInvariants.plot_invariant`: linear axes, scatter, dashed zero line. That function
# cannot be used directly, as it takes an `EnsembleSolution`, which the per-member integration
# above deliberately does not build.
function plot_invariant_error(ts, Is, symbol, title)
    fig = Figure()
    ax  = Axis(fig[1, 1]; xlabel = "t", title = title,
               ylabel = "Relative Error ($(symbol)(t)-$(symbol)(0))/$(symbol)(0)")

    hlines!(ax, [0.0]; color = :gray, linestyle = :dash)
    scatter!(ax, ts, (Is .- Is[begin]) ./ Is[begin])
    xlims!(ax, first(ts), last(ts))

    fig
end


# The first and second Poincaré invariant of every method in `list`, over the same time step as
# the trajectory diagnostics of `run_list` but a much shorter time interval: one run advects a
# few hundred trajectories instead of one, so the time span is set by the problem module's
# `nt_poincare` rather than its `nt`.
#
# `spec` is a named tuple `(loop, surface, first, second)` of the problem's phase space
# parameterisations and invariant constructors, all four supplied by GeometricProblems, and bound
# by the problem modules in `src/<problem>.jl`.
function run_poincare(spec, idae, name, list, plot_dir = PLOT_DIR;
                        fig_suff = ".png", nloop = NLOOP, nsurface = NSURFACE)

    isdir(plot_dir) || mkpath(plot_dir)

    # One invariant object for the whole list: it depends on the problem's one- or two-form and on
    # the number of sample points only, not on the method that advects those points.
    invariants = (("_poincare_1st", "I₁", spec.first(nloop),     spec.loop),
                  ("_poincare_2nd", "I₂", spec.second(nsurface), spec.surface))

    for run in list
        method = run[1]
        file   = run[2]

        headline = tableau(method).name

        # One level below the `### Poincaré Invariants` heading the page puts above this call,
        # which in turn sits beside the `###` sections `run_list` writes for the same methods.
        show(stdout, "text/markdown", Markdown.parse("#### $(headline)"))
        _linebreak(stdout)

        for (suffix, symbol, pinv, init) in invariants
            result = invariant_error(pinv, idae, method, init)

            if result === nothing
                show(stdout, "text/markdown",
                     Markdown.parse("**No $(symbol): the ensemble crashed on its first time step.**"))
                _linebreak(stdout)
                continue
            end

            ts, Is, last_good, nt = result

            if last_good < nt
                show(stdout, "text/markdown",
                     Markdown.parse("**$(symbol) shown over the first $(last_good) of $(nt) time steps: " *
                                    "at least one member of the ensemble crashed.**"))
                _linebreak(stdout)
            end

            _save_plot(() -> plot_invariant_error(ts, Is, symbol, string(headline)),
                       plot_dir, file, suffix, fig_suff)

            _plot_figure_md(stdout, name, "$plot_dir/$file$suffix$fig_suff")
        end

        # One ensemble of a few hundred solutions per method, plus two figures; collecting them
        # here keeps the peak footprint within what a CI runner can hold.
        GC.gc()
    end

    nothing
end
