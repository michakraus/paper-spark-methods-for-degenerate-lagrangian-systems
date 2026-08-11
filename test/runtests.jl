
using Test
using GeometricIntegrators
using GeometricProblems.LotkaVolterra2dSingular
using GeometricProblems.LotkaVolterra2dSingular: Δt
using SparkMethodsForDegenerateLagrangianSystems

const nt = 1
const idae      = idaeproblem(; timestep = Δt, timespan = (0.0, nt * Δt))
const idaespark = idaeproblem_spark(; timestep = Δt, timespan = (0.0, nt * Δt))

# SPARK methods integrate the SPARK-split IDAE, VSPARK (primary projection) methods
# the variational IDAE.
const spark_tableaus = (
    tableaus_spark_glvprk(),
    tableaus_spark_glrk(),
    tableaus_spark_lobatto(),
)

const vspark_tableaus = (
    tableaus_vspark_internal_projection(),
    tableaus_vspark_modified_internal_projection(),
    tableaus_vspark_lobatto_IIIAIIIB_projection(),
    tableaus_vspark_lobatto_IIIBIIIA_projection(),
    tableaus_vspark_modified_lobatto_IIIAIIIB_projection(),
    tableaus_vspark_modified_lobatto_IIIBIIIA_projection(),
    tableaus_vspark_midpoint_projection(),
    tableaus_vspark_modified_midpoint_projection(),
    tableaus_vspark_symmetric_projection(),
)

# A `DomainError` is a legitimate outcome for these degenerate Lagrangians – a stage value
# may leave the domain of the logarithm – and is tolerated; every other exception propagates
# and fails the test. The suite runs the diverging methods on purpose and only asks whether
# they raise, so `verbosity = 0` keeps the line search from reporting its failures here.
function test_tableaus(problem, tableaus)
    for list in tableaus
        for run in list
            method = run[1]
            @test begin
                try
                    integrate(problem, method; f_abstol = 1E-14, f_reltol = 1E-14,
                                               verbosity = 0)
                catch ex
                    isa(ex, DomainError) || rethrow(ex)
                end
                true
            end
        end
    end
end

test_tableaus(idaespark, spark_tableaus)
test_tableaus(idae, vspark_tableaus)


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
