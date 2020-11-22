
.PHONY: documenter weave

all: weave documenter

documenter: weave
	julia --color=yes --project=.. make.jl

weave:
	julia --color=yes --project=.. weave-lotka-volterra-2d.jl
	julia --color=yes --project=.. weave-massless-charged-particle.jl

clean:
	rm -Rf build
	rm -Rf src/*.html
	rm -Rf src/lotka-volterra-2d
	rm -Rf src/massless-charged-particle
