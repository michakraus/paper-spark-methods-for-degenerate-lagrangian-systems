# Tableaus

## Variational Partitioned Runge-Kutta Methods

```@docs
TableauSPARKGLVPRK
```

## Gauss-Legendre SPARK Methods

```@docs
TableauSPARKGLRK
```

## Lobatto SPARK Methods

```@docs
TableauSPARKLobatto
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
TableauVSPARKLobIIIAIIIBProjection
```

## Lobatto-IIIB-IIIA Projection • Definition 1

```@docs
TableauVSPARKLobIIIBIIIAProjection
```

## Lobatto-IIIA-IIIB Projection • Definition 2

```@docs
TableauVSPARKModifiedLobIIIAIIIBProjection
```

## Lobatto-IIIB-IIIA Projection • Definition 2

```@docs
TableauVSPARKModifiedLobIIIBIIIAProjection
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

The above constructions should result in identical schemes (up to roundoff error):

```@example
using GeometricIntegrators

for s in 1:4
    println("GLRK($s):        ", isapprox(TableauVSPARKGLRKpMidpoint(s), TableauVSPARKGLRKpModifiedMidpoint(s); atol=1E-14), "\n")
end
for s in 2:5
    println("LobIIIAIIIB($s): ", isapprox(TableauVSPARKLobIIIAIIIBpMidpoint(s), TableauVSPARKLobIIIAIIIBpModifiedMidpoint(s); atol=1E-14), "\n")
end
for s in 2:5
    println("LobIIIBIIIA($s): ", isapprox(TableauVSPARKLobIIIBIIIApMidpoint(s), TableauVSPARKLobIIIBIIIApModifiedMidpoint(s); atol=1E-14), "\n")
end
```

## Symmetric Projection

```@docs
TableauVSPARKSymmetricProjection
```
