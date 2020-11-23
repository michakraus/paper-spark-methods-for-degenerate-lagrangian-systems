
all: lv2d mcp

lv2d:
	julia --color=yes --project weave/lotka-volterra-2d.jl

mcp:
	julia --color=yes --project weave/massless-charged-particle.jl

clean:
	rm -Rf build
