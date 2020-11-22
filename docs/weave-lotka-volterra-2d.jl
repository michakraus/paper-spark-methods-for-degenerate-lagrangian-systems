using GeometricIntegrators
using Weave

GeometricIntegrators.set_config(:verbosity, 0)

Weave.set_chunk_defaults!(:echo => false, :results => "raw")

include("../src/lotka-volterra-2d.jl")

weave("../weave/lotka-volterra-2d-spark-pinternal.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-pmidpoint.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-psymmetric.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-plobatto.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-glvprk.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-glspark.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)

weave("../weave/lotka-volterra-2d-spark-lobspark.jmd",
         out_path = "src/lotka-volterra-2d",
         doctype = "github",
         mod = LotkaVolterra2dSingularSPARK)
