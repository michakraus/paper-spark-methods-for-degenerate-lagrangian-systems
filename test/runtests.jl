
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
