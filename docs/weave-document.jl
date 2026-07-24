# Weave a single document.
#
# Usage, from the docs directory:
#
#     julia --project=.. weave-document.jl <problem> <document>
#     julia --project=.. weave-document.jl lotka-volterra-2d plobatto
#
# where <problem> is one of the keys of PROBLEM_MODULES below and <document> is the
# suffix of a file weave/<problem>-spark-<document>.jmd.
#
# One document per process, rather than one process for all seven documents of a
# problem: the full build runs 216 simulations over 100000 time steps each and writes
# some 2900 figures, which is more than a CI runner can hold in a single Julia session.

using Weave


const PROBLEM_MODULES = Dict(
    "lotka-volterra-2d"         => :LotkaVolterra2dSingularSPARK,
    "massless-charged-particle" => :MasslessChargedParticleSPARK,
)


if length(ARGS) != 2
    error("Usage: julia --project=.. weave-document.jl <problem> <document>")
end

const PROBLEM, DOCUMENT = ARGS

haskey(PROBLEM_MODULES, PROBLEM) ||
    error("Unknown problem \"$PROBLEM\", expected one of $(join(sort(collect(keys(PROBLEM_MODULES))), ", ")).")

const SOURCE = joinpath("..", "weave", "$(PROBLEM)-spark-$(DOCUMENT).jmd")

isfile(SOURCE) || error("No such document: $SOURCE.")


Weave.set_chunk_defaults!(:echo => false, :results => "raw")

include(joinpath("..", "src", "$(PROBLEM).jl"))

const MODULE = getfield(Main, PROBLEM_MODULES[PROBLEM])

# Drop the repetitive line search and tick warnings, which otherwise make up 99% of the
# build log; see `quiet_solver_warnings!` in src/common.jl.
MODULE.quiet_solver_warnings!()

weave(SOURCE,
         out_path = joinpath("src", PROBLEM),
         doctype = "github",
         mod = MODULE)
