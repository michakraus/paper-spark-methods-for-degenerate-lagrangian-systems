using Documenter
using GeometricIntegrators

makedocs(;
    authors="Michael Kraus",
    sitename="SPARK Methods for Degenerate Lagrangian Systems",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://michakraus.github.io/papers-spark-methods-for-degenerate-lagrangian-systems",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Integrators" => "integrators.md",
        "Tableaus" => "tableaus.md",

        "Lotka-Volterra 2d" => [
            "Gauss-Legendre VPRK Methods" => "lotka-volterra-2d/lotka-volterra-2d-spark-glvprk.md",
            "Gauss-Legendre SPARK Methods" => "lotka-volterra-2d/lotka-volterra-2d-spark-glspark.md",
            "Gauss-Lobatto SPARK Methods" => "lotka-volterra-2d/lotka-volterra-2d-spark-lobspark.md",
            "Internal Stage Projection"  => "lotka-volterra-2d/lotka-volterra-2d-spark-pinternal.md",
            "Lobatto-IIIA-IIIB Projection"  => "lotka-volterra-2d/lotka-volterra-2d-spark-plobatto.md",
            "Midpoint Projection"  => "lotka-volterra-2d/lotka-volterra-2d-spark-pmidpoint.md",
            "Symmetric Projection" => "lotka-volterra-2d/lotka-volterra-2d-spark-psymmetric.md",
        ],

        "Massless Charged Particle" => [
            "Gauss-Legendre VPRK Methods" => "massless-charged-particle/massless-charged-particle-spark-glvprk.md",
            "Gauss-Legendre SPARK Methods" => "massless-charged-particle/massless-charged-particle-spark-glspark.md",
            "Gauss-Lobatto SPARK Methods" => "massless-charged-particle/massless-charged-particle-spark-lobspark.md",
            "Internal Stage Projection"  => "massless-charged-particle/massless-charged-particle-spark-pinternal.md",
            "Lobatto-IIIA-IIIB Projection"  => "massless-charged-particle/massless-charged-particle-spark-plobatto.md",
            "Midpoint Projection"  => "massless-charged-particle/massless-charged-particle-spark-pmidpoint.md",
            "Symmetric Projection" => "massless-charged-particle/massless-charged-particle-spark-psymmetric.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/michakraus/paper-spark-methods-for-degenerate-lagrangian-systems",
    devbranch="main"
)
