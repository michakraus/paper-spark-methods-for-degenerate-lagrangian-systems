
using Documenter
using Latexify
using Markdown
using Markdown: MD, Paragraph, LineBreak
using Plots

using GeometricProblems.Diagnostics
using GeometricProblems.PlotRecipes

using GeometricIntegrators
using GeometricIntegrators.Integrators.SPARK
using GeometricIntegrators.Integrators.SPARK: get_ã_vspark_primary,
                                                get_α_vspark_primary,
                                                compute_ã_vspark_primary,
                                                compute_α_vspark_primary



function Integrators.integrate!(int::Union{IntegratorSPARK{DT,TT,D,S,R},IntegratorVSPARKprimary{DT,TT,D,S,R}}, sol::Solution{DT,TT}) where {DT,TT,D,S,R}
    asol = AtomicSolution(int)

    Qi = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:S]
    Pi = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:S]
    Vi = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:S]
    Φi = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:S]

    Qp = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:R]
    Pp = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:R]
    Λp = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:R]
    Φp = [SDataSeries(DT, D, ntime(sol), nsamples(sol)) for i in 1:R]

    # loop over initial conditions showing progress bar
    for m in eachsample(sol)
        # get cache from solution
        get_initial_conditions!(sol, asol, m, 1)
        initialize!(int, asol)

        # loop over time steps
        n = 0
        try
            for outer n in eachtimestep(sol)
                integrate!(int, sol, asol, m, n)

                for i in eachindex(Qi,Pi,Vi,Φi)
                    set_data!(Qi[i], asol.internal.Qi[i], n, m)
                    set_data!(Pi[i], asol.internal.Pi[i], n, m)
                    set_data!(Vi[i], asol.internal.Vi[i], n, m)
                    set_data!(Φi[i], asol.internal.Φi[i], n, m)
                end

                for i in eachindex(Qp,Pp,Λp,Φp)
                    set_data!(Qp[i], asol.internal.Qp[i], n, m)
                    set_data!(Pp[i], asol.internal.Pp[i], n, m)
                    set_data!(Λp[i], asol.internal.Λp[i], n, m)
                    set_data!(Φp[i], asol.internal.Φp[i], n, m)
                end
            end
        catch ex
            tstr = " in time step " * string(n)
        
            if nsamples(sol) > 1
                tstr *= " for initial condition " * string(m)
            end
            
            tstr *= "."
            
            if isa(ex, DomainError)
                show(stdout, "text/markdown", Markdown.parse("DOMAIN ERROR: Simulation crashed" * tstr))
                @warn("DOMAIN ERROR: Simulation crashed" * tstr)
            elseif isa(ex, NonlinearSolverException)
                show(stdout, "text/markdown", Markdown.parse("SOLVER ERROR: Simulation crashed" * tstr))
                show(stdout, "text/markdown", Markdown.parse(ex.msg))
                @warn("SOLVER ERROR: Simulation crashed" * tstr)
                @warn(ex.msg)
            else
                show(stdout, "text/markdown", Markdown.parse("ERROR: Simulation crashed with $(typeof(ex)) " * tstr))
                show(stdout, "text/markdown", Markdown.parse(ex.msg))
                @warn("ERROR: Simulation crashed with $(typeof(ex)) " * tstr)
                @warn(ex.msg)
                # showerror(stdout, ex, catch_backtrace())
            end
        end
    end

    (Qi=Qi, Pi=Pi, Vi=Vi, Φi=Φi, Qp=Qp, Pp=Pp, Λp=Λp, Φp=Φp)
end


# function _arr_str(a)
#     # io = IOBuffer()
#     # show(io, "text/plain", a)
#     # String(take!(io))

#     # astr = latexify(a; env=:array)
#     # astr = replace(astr, "\\begin{equation}" => "\$")
#     # astr = replace(astr, "\\end{equation}" => "\$")
#     # Markdown.parse(astr)
# end

_arr_str(a) = latexify(a; env=:mdtable, latex=false, side=collect(axes(a,1)), head=collect(axes(a,2)))
_linebreak(io) = show(io, "text/markdown", MD(Paragraph([LineBreak()])))


function write_symplecticity(tab, dir, file, name)
    if !isdir(dir)
        mkdir(dir)
    end

    symp_file = dir * "/" * file * ".md"

    symp_cond = symplecticity_conditions(tab)
    symp_arrs = check_symplecticity(tab)

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


function write_plots(tab, dir, file, name, fig_suff)

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


function _plot(sol, stages, equ, dir, file, fig_suff)
    H, ΔH = compute_energy_error(sol.t, sol.q, equ.parameters)
    plotenergyerror(sol.t, ΔH; nt=lastentry(sol), fmt=:png)
    savefig(dir * "/" * file * "_energy_error" * fig_suff)

    plotenergydrift(compute_error_drift(sol.t, ΔH, div(ntime(sol), 10))...; nt=lastentry(sol))
    savefig(dir * "/" * file * "_energy_drift" * fig_suff)

    plotconstrainterror(sol.t, compute_momentum_error(sol.t, sol.q, sol.p, (t,q,k)->ϑ(t,q,equ.parameters,k)); nt=lastentry(sol), fmt=:png)
    savefig(dir * "/" * file * "_constraint_error" * fig_suff)

    plotlagrangemultiplier(sol.t, sol.λ; nt=lastentry(sol), fmt=:png)
    savefig(dir * "/" * file * "_lambda" * fig_suff)

    if stages !== nothing
        for i in eachindex(stages.Φi)
            plotconstrainterror(sol.t, stages.Φi[i]; nt=lastentry(sol), fmt=:png, plot_title="Φi,$(i)")
            savefig(dir * "/" * file * "_constraint_error_phi_i$(i)" * fig_suff)
        end

        for i in eachindex(stages.Φp)
            plotconstrainterror(sol.t, stages.Φp[i]; nt=lastentry(sol), fmt=:png, plot_title="Φp,$(i)")
            savefig(dir * "/" * file * "_constraint_error_phi_p$(i)" * fig_suff)
        end

        for i in eachindex(stages.Λp)
            plotlagrangemultiplier(sol.t, stages.Λp[i]; nt=lastentry(sol), fmt=:png, plot_title="Λp,$(i)")
            savefig(dir * "/" * file * "_lambda_p$(i)" * fig_suff)
        end
    end
end


function run_spark(idae, tab, nt, dir, file, fig_suff, phi_average)
    sol = Solution(idae, Δt, nt)
    int = Integrator(idae, tab, Δt)

    stages = integrate!(int, sol)

    if phi_average !== nothing
        push!(stages.Φp, SDataSeries(phi_average([parent(stages.Φp[i]) for i in eachindex(stages.Φp)])))
    end

    # if length(stages.Φp) == 2
    #     push!(stages.Φp, SDataSeries(parent(stages.Φp[1]) .+ parent(stages.Φp[2])))
    #     push!(stages.Φp, SDataSeries(parent(stages.Φp[1]) .- parent(stages.Φp[2])))
    # end

    try
        plot(sol, stages, idae, dir, file, fig_suff)
    catch ex
        if isa(ex, DomainError)
            show(stdout, "text/markdown", Markdown.parse("DOMAIN ERROR: Diagnostics crashed."))
            @warn("DOMAIN ERROR: Diagnostics crashed.")
        else
            show(stdout, "text/markdown", Markdown.parse("ERROR: Plot crashed with $(typeof(ex))"))
            show(stdout, "text/markdown", Markdown.parse(ex.msg))
            @warn("ERROR: Plot crashed with $(typeof(ex))")
            @warn(ex.msg)
            showerror(stdout, ex, catch_backtrace())
        end
    end
end


function run_list(idae, name, list, plot_dir = PLOT_DIR, symp_dir = SYMP_DIR;
                    fig_suff = ".png", phi_average = nothing)

    for run in list
        tab, file = run

        write_plots(tab, plot_dir, file, name, fig_suff)
        write_symplecticity(tab, symp_dir, file, name)

        show(stdout, "text/markdown", Markdown.parse("### $(tab.name)"))
        _linebreak(stdout)

        show(stdout, "text/markdown", Markdown.parse("[Plots]($file.md)"))
        show(stdout, "text/markdown", Markdown.parse(" • "))
        show(stdout, "text/markdown", Markdown.parse("[Symplecticity]($symp_dir/$file.md)"))
        show(stdout, "text/markdown", Markdown.parse(" • Tableau: "))
        show(stdout, "text/markdown", Markdown.parse("[`$name`](@ref)"))

        _linebreak(stdout)

        run_spark(idae, tab, length(run) ≥ 3 ? run[3] : nt, plot_dir, file, fig_suff, phi_average)
        show(stdout, "text/markdown", Markdown.parse("![$name]($plot_dir/$file$fig_suff)"))
    end

    nothing
end
