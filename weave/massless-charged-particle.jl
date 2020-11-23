
using Weave

Weave.set_chunk_defaults!(:echo => false, :results => "raw")

include("../src/massless-charged-particle.jl")


weave("weave/massless-charged-particle-spark-glvprk.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-glspark.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-lobspark.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-pinternal.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-pmidpoint.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-psymmetric.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)

weave("weave/massless-charged-particle-spark-plobatto.jmd",
         out_path = "build/massless-charged-particle-spark",
         doctype = "github",
         mod = MasslessChargedParticleSPARK)
