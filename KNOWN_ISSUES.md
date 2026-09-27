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
