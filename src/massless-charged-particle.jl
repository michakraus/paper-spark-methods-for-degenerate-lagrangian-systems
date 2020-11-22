module MasslessChargedParticleSPARK

    const Δt = 0.1
    const nt = 100000

    const PLOT_DIR = "figures"
    const SYMP_DIR = "symplecticity"

    using GeometricIntegrators
    using GeometricProblems.MasslessChargedParticle

    set_config(:nls_atol, 1E-14)
    set_config(:nls_rtol, 1E-14)
    set_config(:nls_atol_break, 1E6)
    set_config(:nls_rtol_break, 1E6)
    set_config(:nls_stol_break, 1E6)
    set_config(:nls_nmax, 100);

    include("common.jl")
    include("tableau_lists.jl")
 

    function plot(sol, stages, equ, dir, file, fig_suff)
        if !isdir(dir)
            mkdir(dir)
        end

        plot_massless_charged_particle(sol, equ; nt=lastentry(sol), fmt=:png)
        savefig(dir * "/" * file * fig_suff)

        plot_massless_charged_particle_solution(sol, equ; nt=lastentry(sol), fmt=:png)
        savefig(dir * "/" * file * "_solution" * fig_suff)

        plot_massless_charged_particle_traces(sol, equ; nt=lastentry(sol), fmt=:png)
        savefig(dir * "/" * file * "_traces" * fig_suff)

        _plot(sol, stages, equ, dir, file, fig_suff)
    end
   
end
