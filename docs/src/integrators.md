# SPARK Methods for Degenerate Lagrangian Systems

One step of a projective $(s, \tilde{s})$-SPARK method applied to a degenerate Lagrangian system
```math
L (q, v) = \vartheta (q) \cdot v - H(q) ,
```
in the form of an index-two DAE with primary constraints
```math
\begin{aligned}
\dot{q} &= v , \\
\dot{p} &= \nabla \vartheta (q) \cdot v - \nabla H (q) , \\
\phi(q,p) &= p - \vartheta (q) = 0,
\end{aligned}
```
with consistent initial values $(q_{n}, \, p_{n} = \vartheta (q_{n}))$ and step size $h$ is given by
```math
\begin{aligned}
P_{n,i} &= p_{n} + h \sum \limits_{j=1}^{s} a^{p}_{ij} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \alpha^{p}_{ij} \tilde{G}_{n,j} && i = 1, \, ... , \, s , \\
Q_{n,i} &= q_{n} + h \sum \limits_{j=1}^{s} a^{q}_{ij} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \alpha^{q}_{ij} \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, s , \\
\tilde{P}_{n,i} &= p_{n} + h \sum \limits_{j=1}^{s} \tilde{a}^{p}_{ij} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{\alpha}^{p}_{ij} \tilde{G}_{n,j} && i = 1, \, ... , \, \tilde{s} , \\
\tilde{Q}_{n,i} &= q_{n} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{a}^{q}_{ij} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \tilde{\alpha}^{q}_{ij} \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, \tilde{s} , \\
p_{n+1} &= p_{n} + h \sum \limits_{j=1}^{s} b^{p}_{j} F_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \beta^{p}_{j} \tilde{G}_{n,j} , \\
q_{n+1} &= q_{n} + h \sum \limits_{j=1}^{s} b^{q}_{j} V_{n,j} + h \sum \limits_{j=1}^{\tilde{s}} \beta^{q}_{j} \tilde{\Lambda}_{n,j} ,
\end{aligned}
```
with constraints
```math
\begin{aligned}
0 &= \phi(Q_{n,i}, P_{n,i}) && i = 1, \, ... , \, s , \\
0 &= \sum \limits_{j=1}^{\tilde{s}} \omega_{ij} \, \phi ( \tilde{P}_{n,j}, \tilde{Q}_{n,j}) + \omega_{i\tilde{s}+1} \, \phi (q_{n+1}, p_{n+1}) && i = 1, \, ... , \, \tilde{s}-\rho , \\
0 &= \sum \limits_{j=1}^{\tilde{s}} \delta_{ij} \, \tilde{\Lambda}_{n,j} && i = 1, \, ... , \, \rho ,
\end{aligned}
```
where $0 \le \rho \le \tilde{s}$.
The force fields $F_{n,i}$ are evaluated at the internal stages $(Q_{n,i}, V_{n,i}, P_{n,i})$,
```math
F_{n,i} = \nabla \vartheta (Q_{n,i}) \cdot V_{n,i} - \nabla H (Q_{n,i}) .
```
The projective force field $\tilde{G}_{n,i}$ is evaluated at the projective stages $(\tilde{Q}_{n,i}, \tilde{P}_{n,i})$,
```math
\tilde{G}_{n,i} = \nabla \vartheta (\tilde{Q}_{n,i}) \cdot \tilde{\Lambda}_{n,i} ,
```
where $\tilde{\Lambda}_{n,i}$ are Lagrange multipliers.

Such methods preserve the noncanonical symplectic two-form $\omega = \mathsf{d} \vartheta$, where $\mathsf{d}$ denotes the exterior derivative, if they satisfy the following symplecticity conditions,
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
0 &= \mathsf{d} \sum \limits_{i=1}^{\tilde{s}} ( \beta^{q}_{i} \, \tilde{P}_{n,i} - \beta^{p}_{i} \, \vartheta (\tilde{Q}_{n,i}) ) \wedge \mathsf{d} \Lambda_{n,i} .
\end{aligned}
```
Note that the last condition is sufficient but not necessary.
