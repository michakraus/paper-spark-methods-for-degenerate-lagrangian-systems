
.PHONY: documenter weave

PROBLEMS  := lotka-volterra-2d massless-charged-particle
DOCUMENTS := glvprk glspark lobspark pinternal plobatto pmidpoint psymmetric

all: weave documenter

documenter: weave
	julia --color=yes --project=.. make.jl

# One Julia process per document, matching what the Documentation workflow runs in
# parallel; see the comment at the top of weave-document.jl.
weave:
	@for problem in $(PROBLEMS); do \
		for document in $(DOCUMENTS); do \
			julia --color=yes --project=.. weave-document.jl $$problem $$document || exit 1; \
		done; \
	done

clean:
	rm -Rf build
	rm -Rf src/*.html
	rm -Rf src/lotka-volterra-2d
	rm -Rf src/massless-charged-particle
