using Aqua
using SparkMethodsForDegenerateLagrangianSystems
using Test

Aqua.test_all(
    SparkMethodsForDegenerateLagrangianSystems;
    stale_deps = false,                    # issue #1: run as @test_broken below
)

# `Documenter` and `Weave` are in `[deps]` for the `docs/` and `weave/` drivers, not for `src/`.
# `test_stale_deps` takes no `broken` keyword, so its check is run here directly.
@testset "Stale dependencies" begin
    @test_broken isempty(Aqua.find_stale_deps(Base.PkgId(SparkMethodsForDegenerateLagrangianSystems)))  # issue #1
end
