# Tableaus

## Variational Partitioned Runge-Kutta Methods

```@docs
SPARKGLVPRK
```

## Gauss-Legendre SPARK Methods

```@docs
SPARKGLRK
```

## Lobatto SPARK Methods

```@docs
SPARKLobABC
SPARKLobABD
```

## Internal Projection • Definition 1

```@docs
TableauVSPARKInternalProjection
```

## Internal Projection • Definition 2

```@docs
TableauVSPARKModifiedInternalProjection
```

## Lobatto-IIIA-IIIB Projection • Definition 1

```@docs
TableauVSPARKGLRKpLobattoIIIAIIIB
```

## Lobatto-IIIB-IIIA Projection • Definition 1

```@docs
TableauVSPARKGLRKpLobattoIIIBIIIA
```

## Lobatto-IIIA-IIIB Projection • Definition 2

```@docs
TableauVSPARKGLRKpModifiedLobattoIIIAIIIB
```

## Lobatto-IIIB-IIIA Projection • Definition 2

```@docs
TableauVSPARKGLRKpModifiedLobattoIIIBIIIA
```

## Midpoint Projection • Definition 1

```@docs
TableauVSPARKMidpointProjection
```

## Midpoint Projection • Definition 2

```@docs
TableauVSPARKModifiedMidpointProjection
```

## Midpoint Projection • Verification

The above constructions should result in identical schemes (up to roundoff error).
The following check compares the tableaus of the two constructions (note that
`isapprox` for these tableaus requires a GeometricIntegrators version in which the
comparison of the optional null vector is supported):

```julia
using GeometricIntegrators
using GeometricIntegrators.SPARK

for s in 1:4
    println("GLRK($s):        ", isapprox(tableau(TableauVSPARKGLRKpMidpoint(s)), tableau(TableauVSPARKGLRKpModifiedMidpoint(s)); atol=1E-14), "\n")
end
for s in 2:5
    println("LobIIIAIIIB($s): ", isapprox(tableau(TableauVSPARKLobattoIIIAIIIBpMidpoint(s)), tableau(TableauVSPARKLobattoIIIAIIIBpModifiedMidpoint(s)); atol=1E-14), "\n")
end
for s in 2:5
    println("LobIIIBIIIA($s): ", isapprox(tableau(TableauVSPARKLobattoIIIBIIIApMidpoint(s)), tableau(TableauVSPARKLobattoIIIBIIIApModifiedMidpoint(s)); atol=1E-14), "\n")
end
```

## Symmetric Projection

```@docs
TableauVSPARKSymmetricProjection
```
