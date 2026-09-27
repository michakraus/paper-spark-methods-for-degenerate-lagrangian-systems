# Known issues

## KI-1 · The tableau tests count a `DomainError` as a pass

- **Kind:** test
- **Where:** `test/tableau_lists.jl:35-50`, `test_tableaus`
- **Claim:** Each `@test` integrates one method for one step. It returns `true` when `integrate`
  throws a `DomainError`, and it checks nothing about the result when `integrate` returns. A method
  that always leaves the domain of the logarithm therefore passes.
- **Evidence:** The code was moved verbatim from the old `test/runtests.jl`. Two independent reviews
  of the test-suite migration found it.

## KI-2 · `[sources]` in `test/Project.toml` on Julia 1.10

- **Kind:** not verified
- **Where:** `test/Project.toml`, the `[sources]` table
- **Claim:** Julia 1.10 ignores `[sources]`. `Pkg.test` still adds the package under test, so the
  entry is expected to be harmless there. The same form is merged in RungeKutta and
  NeuralNetworkParameters.
- **Evidence:** No local run on Julia 1.10: the sandbox refused the artifact download. The 1.10 CI
  jobs decide it.
