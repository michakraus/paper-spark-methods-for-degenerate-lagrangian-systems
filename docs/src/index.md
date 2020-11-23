# SPARK Methods for Degenerate Lagrangian Systems

This packages serves to document the examples from the paper *SPARK Methods for Degenerate Lagrangian Systems*. The integrators are implemented in [GeometricIntegrators.jl](https://github.com/JuliaGNI/GeometricIntegrators.jl) in the module `GeometricIntegrators.Integrators.SPARK` and the example problems in [GeometricProblems.jl](https://github.com/JuliaGNI/GeometricProblems.jl).

> The numerical integration of degenerate Lagrangian systems with Specialised Partitioned Additive Runge-Kutta (SPARK) methods is discussed. By introducing conjugate momenta, the Euler-Lagrange equations of degenerate Lagrangians can be recast in the form of index-two differential-algebraic equations subject to a primary constraint in the sense of Dirac. Variational integrators, which solve discrete Euler-Lagrange equations obtained from a variational procedure, might appear to be the natural choice for numerically integrating such systems, but in fact do not preserve the primary constraint and are thus in general unstable. SPARK methods for index-two differential-algebraic equations do preserve the constraint, but in general do not preserve symplecticity and the variational structure of the equations, thus violating important structural properties of Lagrangian systems.
> 
> In this work, existing variational partitioned Runge-Kutta methods for degenerate Lagrangians and SPARK methods for index-two differential-algebraic equations are generalised to fit a common framework. It is shown how these methods fail to either preserve the primary constraint or the noncanonical symplectic structure of the equations. A new family of SPARK methods, projecting on the primary constraint, is presented and conditions for the conservation of the noncanonical symplectic structure are derived. Numerical experiments highlight the favourable properties of the proposed integrators.

## Integrators

The integrators are defined as

```math
\begin{aligned}
P_{n,i} &= p_{n} + h \sum \limits_{j=1}^{s} a^{p}_{ij} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \alpha^{p}_{ij} \tilde{G}_{n,j} && i = 1, \, ... , \, s , \\
Q_{n,i} &= q_{n} + h \sum \limits_{j=1}^{s} a^{q}_{ij} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \alpha^{q}_{ij} \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, s , \\
\tilde{P}_{n,i} &= p_{n} + h \sum \limits_{j=1}^{s} \tilde{a}^{p}_{ij} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{\alpha}^{p}_{ij} \tilde{G}_{n,j} && i = 1, \, ... , \, \tilde{s} , \\
\tilde{Q}_{n,i} &= q_{n} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{a}^{q}_{ij} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{\alpha}^{q}_{ij} \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, \tilde{s} , \\
p_{n+1} &= p_{n} + h \sum \limits_{j=1}^{s} b^{p}_{j} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \beta^{p}_{j} \tilde{G}_{n,j} , \\
q_{n+1} &= q_{n} + h \sum \limits_{j=1}^{s} b^{q}_{j} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \beta^{q}_{j} \tilde{\Lambda}_{n,j} , \\
0 &= \phi(Q_{n,i}, P_{n,i}) && i = 1, \, ... , \, s , \\
0 &= \sum \limits_{j=1}^{\tilde{s}} \omega_{ij} \, \phi ( \tilde{P}_{n,j}, \tilde{Q}_{n,j}) + \omega_{i\tilde{s}+1} \, \phi (q_{n+1}, p_{n+1}) && i = 1, \, ... , \, \tilde{s}-\rho , \\
0 &= \sum \limits_{j=1}^{\tilde{s}} \delta_{ij} \, \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, \rho ,
\end{aligned}
```

with Symplecticity Conditions

```math
\begin{aligned}
b^{p}_{i} b^{q}_{j} &= b^{p}_{i} a^{q}_{ij} + b^{q}_{j} a^{p}_{ji} && i = 1, \, ... , \, s, \; j = 1, \, ... , \, s ,
\\
\beta^{p}_{i} \beta^{q}_{j} &= \beta^{p}_{i} \tilde{\alpha}^{q}_{ij} + \beta^{q}_{j} \tilde{\alpha}^{p}_{ji}  && i = 1, \, ... , \, \tilde{s}, \; j = 1, \, ... , \, \tilde{s} ,
\\
b^{p}_{i} \beta^{q}_{j} &= b^{p}_{i} \alpha^{q}_{ij} + \beta^{q}_{j} \tilde{a}^{p}_{ji}  && i = 1, \, ... , \, s, \; j = 1, \, ... , \, \tilde{s} ,
\\
b^{q}_{i} \beta^{p}_{j} &= b^{q}_{i} \alpha^{p}_{ij} + \beta^{p}_{j} \tilde{a}^{q}_{ji} && i = 1, \, ... , \, s, \; j = 1, \, ... , \, \tilde{s} ,
\\
b^{q}_{i} &= b^{p}_{i} && i = 1, \, ... , \, s ,
\\
\beta^{q}_{i} &= \beta^{p}_{i}  && i = 1, \, ... , \, \tilde{s} ,
\\
0 &= \mathrm{d} \sum \limits_{i=1}^{\tilde{s}} ( \beta^{q}_{i} \, \tilde{P}_{n,i} - \beta^{p}_{i} \, \vartheta (\tilde{Q}_{n,i}) ) \wedge \mathrm{d} \Lambda_{n,i} .
\end{aligned}
```

## Numerical Examples

### Lotka-Volterra 2d

* [Gauss-Legendre VPRK Methods](lotka-volterra-2d/lotka-volterra-2d-spark-glvprk.md)
* [Gauss-Legendre SPARK Methods](lotka-volterra-2d/lotka-volterra-2d-spark-glspark.md)
* [Gauss-Lobatto SPARK Methods](lotka-volterra-2d/lotka-volterra-2d-spark-lobspark.md)
* [Internal Stage Projection](lotka-volterra-2d/lotka-volterra-2d-spark-pinternal.md)
* [Lobatto-IIIA-IIIB Projection](lotka-volterra-2d/lotka-volterra-2d-spark-plobatto.md)
* [Midpoint Projection](lotka-volterra-2d/lotka-volterra-2d-spark-pmidpoint.md)
* [Symmetric Projection](lotka-volterra-2d/lotka-volterra-2d-spark-psymmetric.md)

### Massless Charged Particle

* [Gauss-Legendre VPRK Methods](massless-charged-particle/massless-charged-particle-spark-glvprk.md)
* [Gauss-Legendre SPARK Methods](massless-charged-particle/massless-charged-particle-spark-glspark.md)
* [Gauss-Lobatto SPARK Methods](massless-charged-particle/massless-charged-particle-spark-lobspark.md)
* [Internal Stage Projection](massless-charged-particle/massless-charged-particle-spark-pinternal.md)
* [Lobatto-IIIA-IIIB Projection](massless-charged-particle/massless-charged-particle-spark-plobatto.md)
* [Midpoint Projection](massless-charged-particle/massless-charged-particle-spark-pmidpoint.md)
* [Symmetric Projection](massless-charged-particle/massless-charged-particle-spark-psymmetric.md)

## References

* Michael Kraus. SPARK Methods for Degenerate Lagrangian Systems.

If you use the integrators described in the article above, please cite GeometricIntegrators.jl as

```
@misc{Kraus:2020:GeometricIntegrators,
  title={GeometricIntegrators.jl: A Julia library of geometric integrators for ordinary differential equations and differential algebraic equations},
  author={Kraus, Michael},
  year={2020},
  howpublished={\url{https://github.com/JuliaGNI/GeometricIntegrators.jl}},
  doi={10.5281/zenodo.3648325}
}
```

If you use the figures or implementations provided here, please cite this repository as

```
@misc{Kraus:2020:SPARKMethodsRepo,
  title={Companion Repository to ``{SPARK} Methods for Degenerate {L}agrangian Systems''},
  author={Kraus, Michael},
  year={2020},
  month={11},
  howpublished={\url{https://github.com/michakraus/paper-spark-methods-for-degenerate-lagrangian-systems}},
  doi={10.5281/zenodo.4285904}
}
```

All figures are licensed under the Creative Commons [CC BY-NC-SA 4.0 License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
