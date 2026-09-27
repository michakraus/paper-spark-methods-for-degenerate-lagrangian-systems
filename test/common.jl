using Test
using GeometricProblems.LotkaVolterra2dSingular
using GeometricProblems.LotkaVolterra2dSingular: Δt
using SparkMethodsForDegenerateLagrangianSystems

# The Poincaré invariants of `run_poincare`, with a handful of sample points over a handful of
# time steps: what is asserted here is the wiring — that `pi_ensemble` builds an ensemble the
# SPARK integrators accept, that it is advected and evaluated, that both figures are written where
# the woven page expects them, and that both index-2 problems of this package work, the
# variational IDAE of the VSPARK methods and the SPARK-split one of the SPARK methods. The physics
# is asserted upstream, in the GeometricProblems test suite, where the invariant error is checked
# to converge at the order of the method.
#
# `NSURFACE_TEST` is 45 = 9·10/2, the next Padua number below the production 231; the Chebyshev
# plan rounds any other count up to one anyway.
import SparkMethodsForDegenerateLagrangianSystems as SPARK
using GeometricProblems.LotkaVolterra2dSingular: f_loop, f_surface,
                                                 poincare_invariant_1st, poincare_invariant_2nd

const PI_SPEC_TEST = (loop    = f_loop,
                      surface = f_surface,
                      first   = poincare_invariant_1st,
                      second  = poincare_invariant_2nd)

const NLOOP_TEST = 16
const NSURFACE_TEST = 45
const NT_TEST = 3

const pi_problems = (
    "variational IDAE" => (idaeproblem(; timestep = Δt, timespan = (0.0, NT_TEST * Δt)),
                           tableaus_vspark_midpoint_projection()[1]),
    "SPARK-split IDAE" => (idaeproblem_spark(; timestep = Δt, timespan = (0.0, NT_TEST * Δt)),
                           tableaus_spark_glrk()[1]),
)

@testset "Poincaré invariants — $(label)" for (label, (problem, run)) in pi_problems
    method = run[1]

    mktempdir() do dir
        SPARK.run_poincare(PI_SPEC_TEST, problem, :test, (run,), dir;
                           nloop = NLOOP_TEST, nsurface = NSURFACE_TEST)

        @test isfile(joinpath(dir, run[2] * "_poincare_1st.png"))
        @test isfile(joinpath(dir, run[2] * "_poincare_2nd.png"))
    end

    # `invariant_error` is what carries the partial-result contract: it returns the invariant over
    # as many time steps as every member of the ensemble survived.
    pinv = PI_SPEC_TEST.first(NLOOP_TEST)
    ts, Is, last_good, ntotal = SPARK.invariant_error(pinv, problem, method, PI_SPEC_TEST.loop)

    @test last_good == ntotal == NT_TEST
    @test length(ts) == length(Is) == NT_TEST + 1
    @test all(isfinite, Is)
    @test !iszero(Is[begin])
end
