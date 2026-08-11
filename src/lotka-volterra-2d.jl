module LotkaVolterra2dSingularSPARK

    const Δt = 0.1
    const nt = 100000

    # The Poincaré invariants advect a few hundred trajectories per method instead of one, so they
    # run over a correspondingly shorter time interval — at the same time step.
    const nt_poincare = 1000

    const PLOT_DIR = "figures"
    const SYMP_DIR = "symplecticity"

    using GeometricIntegrators

    using GeometricProblems.LotkaVolterra2dSingular
    using GeometricProblems.LotkaVolterra2d: plot_solution, plot_phase_portrait, plot_traces

    # Phase space parameterisations and invariant constructors, all supplied by GeometricProblems:
    # `f_loop`/`f_surface` are the curve and the surface the invariants are taken over,
    # `poincare_invariant_1st`/`_2nd` build them over this gauge's own one- and two-form. Read by
    # the `run_poincare_*` wrappers of `tableau_lists.jl`.
    const PI_SPEC = (loop    = LotkaVolterra2dSingular.f_loop,
                     surface = LotkaVolterra2dSingular.f_surface,
                     first   = LotkaVolterra2dSingular.poincare_invariant_1st,
                     second  = LotkaVolterra2dSingular.poincare_invariant_2nd)

    include("common.jl")
    include("tableau_lists.jl")


    function make_plots(sol, stages, equ, dir, file, fig_suff, last_good)
        if !isdir(dir)
            mkdir(dir)
        end

        ntplot = last_good ≥ ntime(sol) ? (:auto) : last_good

        _save_plot(() -> plot_solution(sol, equ; latex=false, nt=ntplot), dir, file, "", fig_suff)
        _save_plot(() -> plot_phase_portrait(sol; latex=false, nt=ntplot), dir, file, "_solution", fig_suff)
        _save_plot(() -> plot_traces(sol, equ; latex=false, nt=ntplot), dir, file, "_traces", fig_suff)

        _plot(sol, stages, equ, dir, file, fig_suff, last_good)
    end

    export run_list

end
