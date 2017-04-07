Examples/Examples.ttl : RDF_Guide.md
	notangle -RExamples RDF_Guide.md > Examples/Examples.ttl

OpenBiodiv.ttl : RDF_Guide.md
	notangle -R"OpenBiodiv Ontology" RDF_Guide.md > OpenbBiodiv.ttl

.PHONY: ontology
ontology: OpenBiodiv.ttl

.PHONY: examples
examples: Examples/Examples.ttl

.PHONY: all
all: ontology examples

