
using Latexify
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


function _plot_figure_md(file, name, filename)
    # if isfile(filename)
        show(file, "text/markdown", Markdown.parse("![$name]($filename)"))
        _linebreak(file)
    # else
    #     show(stdout, "text/markdown", Markdown.parse("ERROR: Plot output $filename does not exist!"))
    #     @warn("Plot output $filename does not exist!")
    # end
end


function write_plots(method, dir, file, name, fig_suff)

    tab = tableau(method)
    plot_file = file * ".md"

    open(plot_file, "w") do f
        show(f, "text/markdown", Markdown.parse("# $name"))
        _linebreak(f)

        _plot_figure_md(f, name, "$(dir)/$(file)_solution$(fig_suff)")
        _plot_figure_md(f, name, "$(dir)/$(file)_traces$(fig_suff)")

        show(f, "text/markdown", Markdown.parse("## Energy Error"))
        _linebreak(f)

        _plot_figure_md(f, name, "$(dir)/$(file)_energy_error$(fig_suff)")
        _plot_figure_md(f, name, "$(dir)/$(file)_energy_drift$(fig_suff)")

        show(f, "text/markdown", Markdown.parse("## Constraint"))
        _linebreak(f)

        _plot_figure_md(f, name, "$(dir)/$(file)_constraint_error$(fig_suff)")

        for i in 1:tab.s
            _plot_figure_md(f, name, "$(dir)/$(file)_constraint_error_phi_i$(i)$(fig_suff)")
        end

        for i in 1:tab.r
            _plot_figure_md(f, name, "$(dir)/$(file)_constraint_error_phi_p$(i)$(fig_suff)")
        end

        _plot_figure_md(f, name, "$(dir)/$(file)_lambda$(fig_suff)")

        for i in 1:tab.r
            _plot_figure_md(f, name, "$(dir)/$(file)_lambda_p$(i)$(fig_suff)")
        end
    end

end


function _plot(sol, stages, equ, dir, file, fig_suff, last_good)
    nt     = ntime(sol)
    ntplot = last_good ≥ nt ? (:auto) : last_good

    # All GeometricProblems recipes set their own x-limits to the plotted time range.
    save(dir * "/" * file * "_energy_error" * fig_suff, plot_energy_error(sol; latex=false, nt=ntplot))

    # Drift is an interval-based diagnostic; only show the intervals before the crash.
    ntdrift = last_good ≥ nt ? (:auto) : div(last_good, div(nt, 10))
    save(dir * "/" * file * "_energy_drift" * fig_suff, plot_energy_drift(sol; latex=false, nt=ntdrift))

    save(dir * "/" * file * "_constraint_error" * fig_suff, plot_constraint_error(sol; latex=false, nt=ntplot))

    save(dir * "/" * file * "_lambda" * fig_suff, plot_lagrange_multiplier(sol; latex=false, nt=ntplot))

    if stages !== nothing
        for i in eachindex(stages.Φi)
            save(dir * "/" * file * "_constraint_error_phi_i$(i)" * fig_suff,
                 plot_constraint_error(sol.t, stages.Φi[i]; latex=false, nt=ntplot, plot_title="Φi,$(i)"))
        end

        for i in eachindex(stages.Φp)
            save(dir * "/" * file * "_constraint_error_phi_p$(i)" * fig_suff,
                 plot_constraint_error(sol.t, stages.Φp[i]; latex=false, nt=ntplot, plot_title="Φp,$(i)"))
        end

        for i in eachindex(stages.Λp)
            save(dir * "/" * file * "_lambda_p$(i)" * fig_suff,
                 plot_lagrange_multiplier(sol.t, stages.Λp[i]; latex=false, nt=ntplot, plot_title="Λp,$(i)"))
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

        write_plots(method, plot_dir, file, name, fig_suff)
        write_symplecticity(method, symp_dir, file, name)

        show(stdout, "text/markdown", Markdown.parse("### $(tableau(method).name)"))
        _linebreak(stdout)

        show(stdout, "text/markdown", Markdown.parse("[Plots]($file.md)"))
        show(stdout, "text/markdown", Markdown.parse(" • "))
        show(stdout, "text/markdown", Markdown.parse("[Symplecticity]($symp_dir/$file.md)"))

        _linebreak(stdout)

        run_spark(idae, method, plot_dir, file, fig_suff, phi_average)
        show(stdout, "text/markdown", Markdown.parse("![$name]($plot_dir/$file$fig_suff)"))
    end

    nothing
end
