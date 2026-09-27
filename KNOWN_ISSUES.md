# Known issues

### K1 · The tableau tests count a `DomainError` as a pass

- **Location:** `test/tableau_lists.jl:39`
- **Evidence:** Each `@test` in `test_tableaus` integrates one method for one step. It returns
  `true` when `integrate` throws a `DomainError`, and it checks nothing about the result when
  `integrate` returns. A method that always leaves the domain of the logarithm therefore passes.
  ```julia
  @test begin
      try
          integrate(problem, method; f_abstol = 1E-14, f_reltol = 1E-14,
                                     verbosity = 0)
      catch ex
          isa(ex, DomainError) || rethrow(ex)
      end
      true
  end
  ```
- **Kind:** missing test
- **Found:** 2026-09-27

### K2 · `[sources]` in `test/Project.toml` is unverified on Julia 1.10

- **Location:** `test/Project.toml`
- **Evidence:** Julia 1.10 ignores `[sources]`. `Pkg.test` still adds the package under test, so the
  entry is expected to be harmless there. RungeKutta has the same form in `test/Project.toml` and a
  Julia floor of 1.10, and its three `Julia min` jobs pass in CI run 36240608082 at commit
  `36cc803`. This repository's suite has no run on Julia 1.10; the `1.10` jobs of
  `.github/workflows/CI.yml` decide it.
- **Kind:** not verified
- **Found:** 2026-09-27
