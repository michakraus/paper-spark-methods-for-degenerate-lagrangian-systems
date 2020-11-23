# SPARK Methods for Degenerate Lagrangian Systems

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://michakraus.github.io/paper-spark-methods-for-degenerate-lagrangian-systems/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://michakraus.github.io/paper-spark-methods-for-degenerate-lagrangian-systems/dev)
[![DOI](https://zenodo.org/badge/310285877.svg)](https://zenodo.org/badge/latestdoi/310285877)

This packages serves to document the examples from the paper *SPARK Methods for Degenerate Lagrangian Systems*.

The integrators are implemented in [GeometricIntegrators.jl](https://github.com/JuliaGNI/GeometricIntegrators.jl) in the module `GeometricIntegrators.Integrators.SPARK` and the example problems in [GeometricProblems.jl](https://github.com/JuliaGNI/GeometricProblems.jl).
The corresponding plots can be found in the [documentation](https://michakraus.github.io/paper-spark-methods-for-degenerate-lagrangian-systems/stable).

## References

* Michael Kraus. SPARK Methods for Degenerate Lagrangian Systems. 2020.

> The numerical integration of degenerate Lagrangian systems with Specialised Partitioned Additive Runge--Kutta (SPARK) methods is discussed. By introducing conjugate momenta, the Euler--Lagrange equations of degenerate Lagrangians can be recast in the form of index-two differential-algebraic equations subject to a primary constraint in the sense of Dirac. Variational integrators, which solve discrete Euler--Lagrange equations obtained from a variational procedure, might appear to be the natural choice for numerically integrating such systems, but in fact do not preserve the primary constraint and are thus in general unstable.  SPARK methods for index-two differential-algebraic equations do preserve the constraint, but in general do not preserve symplecticity and the variational structure of the equations, thus violating important structural properties of Lagrangian systems.
> 
> In this work, existing variational partitioned Runge--Kutta methods for degenerate Lagrangians and SPARK methods for index-two differential-algebraic equations are generalised to fit a common framework. It is shown how these methods fail to either preserve the primary constraint or the noncanonical symplectic structure of the equations. A new family of SPARK methods, projecting on the primary constraint, is presented and conditions for the conservation of the noncanonical symplectic structure are derived. Numerical experiments highlight the favourable properties of the proposed integrators.

If you use the figures or implementations provided here, please cite this repository as

```
@misc{Kraus:2020:SPARKMethodsRepo,
  title={{paper-spark-methods-for-degenerate-lagrangian-systems}.
         SPARK Methods for Degenerate Lagrangian Systems},
  author={Kraus, Michael},
  year={2020},
  month={11},
  howpublished={\url{https://github.com/michakraus/paper-spark-methods-for-degenerate-lagrangian-systems}},
  doi={10.5281/zenodo.4285905}
}
```

## Licenses

This package is licensed under the [MIT "Expat" License](LICENSE.md).
All figures are licensed under the Creative Commons [CC BY-NC-SA 4.0 License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
