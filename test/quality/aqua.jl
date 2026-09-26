using Aqua
using SparkMethodsForDegenerateLagrangianSystems
using Test

# `Documenter` and `Weave` are in `[deps]` for the `docs/` and `weave/` drivers, not for `src/`
# (issue #1). Aqua's `stale_deps` takes no `broken` option, so the two are ignored by name there,
# which keeps any other stale dependency a failure, and the check on them runs as `@test_broken`.
Aqua.test_all(
    SparkMethodsForDegenerateLagrangianSystems;
    stale_deps = (; ignore = [:Documenter, :Weave]),
)

@testset "Stale dependencies" begin
    @test_broken isempty(Aqua.find_stale_deps(Base.PkgId(SparkMethodsForDegenerateLagrangianSystems)))  # issue #1
end
