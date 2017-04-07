Examples.ttl : RDF_Guide.md
	notangle -RExamples RDF_Guide.md > Examples.ttl

OpenBiodiv.ttl : RDF_Guide.md
	notangle -R"OpenBiodiv Ontology" RDF_Guide.md > OpenbBiodiv.ttl

Rules.sparql : RDF_Guide.md
	notangle -R"Rules" RDF_Guide.md > Rules.sparql


.PHONY: ontology
ontology: OpenBiodiv.ttl

.PHONY: examples
examples: Examples.ttl

.PHONY: rules
rules: Rules.sparql



.PHONY: all
all: ontology examples

