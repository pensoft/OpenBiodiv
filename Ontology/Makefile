.PHONY: ontology
ontology: OpenBiodiv.ttl

.PHONY: examples
examples: Examples.ttl

.PHONY: all
all: ontology examples

Examples.ttl : RDF_Guide.md
	notangle -RExamples RDF_Guide.md > Examples.ttl

OpenBiodiv.ttl : RDF_Guide.md
	notangle -R"OpenBiodiv Ontology" RDF_Guide.md > OpenbBodiv.ttl

