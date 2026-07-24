#
# Weave the documentation pages of one problem into `docs/src/<problem>/`.
#
#   julia --project=.. weave.jl <problem> [<page> ...]
#
# With no page arguments all method families of `<problem>` are woven; naming individual
# pages allows the CI workflow to build them as parallel matrix jobs.
#
# Examples:
#
#   julia --project=.. weave.jl lotka-volterra-2d
#   julia --project=.. weave.jl lotka-volterra-2d plobatto psymmetric
#
# One page per process, rather than one process for all seven pages of a problem: the full
# build runs 216 simulations over 100000 time steps each and writes some 2900 figures,
# which is more than a CI runner can hold in a single Julia session.
#

using GeometricIntegrators
using Weave


# problem name (in `src/`, `weave/` and `docs/src/`) → module defined by `src/<problem>.jl`
const PROBLEMS = (
    "lotka-volterra-2d"         => :LotkaVolterra2dSingularSPARK,
    "massless-charged-particle" => :MasslessChargedParticleSPARK,
)

# page name → `weave/<problem>-spark-<page>.jmd`
const PAGES = ("glvprk", "glspark", "lobspark", "pinternal", "plobatto", "pmidpoint", "psymmetric")

source_path(problem, page) = joinpath(@__DIR__, "..", "weave", "$(problem)-spark-$(page).jmd")


# Returns `(problem, module name, pages)` for the command line arguments.
function parse_arguments(args)
    isempty(args) && error("usage: julia --project=.. weave.jl <problem> [<page> ...]\n" *
                           "problems: " * join(first.(PROBLEMS), ", ") * "\n" *
                           "pages: " * join(PAGES, ", "))

    problem = args[1]
    pages   = length(args) > 1 ? args[2:end] : collect(PAGES)

    i = findfirst(p -> first(p) == problem, PROBLEMS)
    i === nothing && error("unknown problem \"$problem\"; expected one of " *
                           join(first.(PROBLEMS), ", "))

    for page in pages
        page in PAGES || error("unknown page \"$page\"; expected one of " * join(PAGES, ", "))
        isfile(source_path(problem, page)) || error("no such document: $(source_path(problem, page))")
    end

    (problem, last(PROBLEMS[i]), pages)
end

const problem, modname, pages = parse_arguments(ARGS)


Weave.set_chunk_defaults!(:echo => false, :results => "raw")

include(joinpath(@__DIR__, "../src/$(problem).jl"))

# resolved at top level, i.e. after the world of the `include` above
const mod = getfield(Main, modname)

# Drop the repetitive line search and tick warnings, which otherwise make up 99% of the
# build log; see `quiet_solver_warnings!` in src/common.jl.
mod.quiet_solver_warnings!()

for page in pages
    weave(source_path(problem, page),
             out_path = "src/$(problem)",
             doctype = "github",
             mod = mod)
end
