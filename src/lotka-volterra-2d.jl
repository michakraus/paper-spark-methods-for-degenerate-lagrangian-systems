module LotkaVolterra2dSingularSPARK

    const Δt = 0.1
    const nt = 100000

    const PLOT_DIR = "figures"
    const SYMP_DIR = "symplecticity"

    using GeometricIntegrators

    using GeometricProblems.LotkaVolterra2dSingular
    using GeometricProblems.LotkaVolterra2d: plot_solution, plot_phase_portrait, plot_traces

    include("common.jl")
    include("tableau_lists.jl")


    function make_plots(sol, stages, equ, dir, file, fig_suff, last_good)
        if !isdir(dir)
            mkdir(dir)
        end

        ntplot = last_good ≥ ntime(sol) ? (:auto) : last_good

        CairoMakie.save(dir * "/" * file * fig_suff, plot_solution(sol, equ; latex=false, nt=ntplot))
        CairoMakie.save(dir * "/" * file * "_solution" * fig_suff, plot_phase_portrait(sol; latex=false, nt=ntplot))
        CairoMakie.save(dir * "/" * file * "_traces" * fig_suff, plot_traces(sol, equ; latex=false, nt=ntplot))

        _plot(sol, stages, equ, dir, file, fig_suff, last_good)
    end

    export run_list

end
