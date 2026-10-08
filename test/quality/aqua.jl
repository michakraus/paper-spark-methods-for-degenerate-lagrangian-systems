using Aqua
using SparkMethodsForDegenerateLagrangianSystems
using Test

Aqua.test_all(
    SparkMethodsForDegenerateLagrangianSystems;
    stale_deps = false,                    # issue #1: run as @test_broken below
    # CairoMakie is a direct dependency, so on Julia 1.11 the wrapper's `Pkg.precompile` also
    # builds the Makie extensions of PoincareInvariants and GeometricProblems after the package
    # loads. Measured on 1.11.9: `tmax = 30` timed out after 46.1 s, `tmax = 300` returned `false`
    # after 88.8 s. A real persistent task blocks forever, so the larger `tmax` hides none.
    persistent_tasks = (; tmax = 300)
)

# `Documenter` and `Weave` are in `[deps]` for the `docs/` and `weave/` drivers, not for `src/`.
# `test_stale_deps` takes no `broken` keyword, so its check is run here directly.
@testset "Stale dependencies" begin
    @test_broken isempty(Aqua.find_stale_deps(Base.PkgId(SparkMethodsForDegenerateLagrangianSystems)))  # issue #1
end
