
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


# The degenerate Lagrangians make some of the methods diverge. The Newton solver then
# fails its line search in every iteration of every time step and `SimpleSolvers` emits
# one warning per failure: the last CI run drowned in 173000 of them, 99% of a
# 174583-line log. The warning cannot be switched off through the solver interface —
# `NewtonSolver` builds its `Linesearch` without forwarding the option keywords, so the
# line search always ends up with a default `Options` and `verbosity = 1` — hence we
# filter it out on the logging side instead, and likewise the equally repetitive tick
# warnings from the plotting stack. Only the count is reported, by `run_list`.
const QUIET_LOG_MODULES = (:SimpleSolvers, :PlotUtils, :Makie)
const QUIET_LOG_COUNT = Ref(0)

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

# Install the filter. Called by the weave driver, not on load, so that interactive
# sessions keep the warnings unless they ask for quiet.
quiet_solver_warnings!() = global_logger(QuietLogger(global_logger()))


# Integrate an IDAE with a SPARK/VSPARK method, collecting the internal and
# projection stage variables (Qi,Pi,Vi,Φi,Qp,Pp,Λp,Φp) alongside the solution.
# The plain `integrate` does not persist these, so we drive the integrator
# step-by-step and read them off the solution step (mirrors GeometricIntegratorsBase's
# own integration loop). A crash (solver failure, singular matrix, NaNs, …) does not
# discard the run: we keep the solution and stages up to the last successful step.
# Returns `(sol, stages, last_good, err)` where `last_good` is the index of the last
# completed step and `err` is `nothing`, `:nan`, or the caught exception.
function integrate_spark(idae, method)
    int     = GIB.GeometricIntegrator(idae, method; f_abstol=1E-14, f_reltol=1E-14, max_iterations=100)
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


# Short, human-readable one-line description of a crash (no stack trace).
function _failure_message(err)
    err === :nan                      && return "NaNs detected in the solution"
    err isa NonlinearSolverException  && return "solver error – " * err.msg
    err isa DomainError               && return "domain error"
    return string(nameof(typeof(err)))
end


# Save one figure, reporting but not propagating a failure: a diagnostic that cannot be
# plotted for a crashed run must not take the remaining figures of that run down with it.
function _save(path, makefigure)
    try
        save(path, makefigure())
    catch ex
        @warn("Plotting $(basename(path)) failed: $(_failure_message(ex))")
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


# Reference a figure, but only if it was actually produced: a run that crashed early has
# no energy drift data, and one that crashed on the very first step has no figures at
# all. Referencing them regardless leaves broken images on the page and one
# `invalid local link/image` warning per figure in the Documenter build. Returns whether
# the reference was written.
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
    _save(dir * "/" * file * "_energy_error" * fig_suff, () -> plot_energy_error(sol; latex=false, nt=ntplot))

    # Drift is an interval-based diagnostic: `plot_energy_drift` bins the run into
    # `div(nt, 10)`-step intervals, so a run that crashed before completing the first
    # interval has no drift data at all and must be skipped — passing `nt = 0` makes the
    # recipe index into an empty range.
    ntdrift = last_good ≥ nt ? (:auto) : div(last_good, div(nt, 10))
    if ntdrift === :auto || ntdrift ≥ 1
        _save(dir * "/" * file * "_energy_drift" * fig_suff, () -> plot_energy_drift(sol; latex=false, nt=ntdrift))
    end

    _save(dir * "/" * file * "_constraint_error" * fig_suff, () -> plot_constraint_error(sol; latex=false, nt=ntplot))

    _save(dir * "/" * file * "_lambda" * fig_suff, () -> plot_lagrange_multiplier(sol; latex=false, nt=ntplot))

    if stages !== nothing
        for i in eachindex(stages.Φi)
            _save(dir * "/" * file * "_constraint_error_phi_i$(i)" * fig_suff,
                  () -> plot_constraint_error(sol.t, stages.Φi[i]; latex=false, nt=ntplot, plot_title="Φi,$(i)"))
        end

        for i in eachindex(stages.Φp)
            _save(dir * "/" * file * "_constraint_error_phi_p$(i)" * fig_suff,
                  () -> plot_constraint_error(sol.t, stages.Φp[i]; latex=false, nt=ntplot, plot_title="Φp,$(i)"))
        end

        for i in eachindex(stages.Λp)
            _save(dir * "/" * file * "_lambda_p$(i)" * fig_suff,
                  () -> plot_lagrange_multiplier(sol.t, stages.Λp[i]; latex=false, nt=ntplot, plot_title="Λp,$(i)"))
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

        # Each run leaves some thirty Makie figures and a full set of stage data series
        # behind; collecting them here keeps the peak footprint of a list of up to fifty
        # methods within what a CI runner can hold.
        GC.gc()
    end

    if QUIET_LOG_COUNT[] > 0
        @info("Suppressed $(QUIET_LOG_COUNT[]) solver/plotting warnings so far (see QUIET_LOG_MODULES)")
    end

    nothing
end
