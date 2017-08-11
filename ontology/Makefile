example.ttl : rdf-guide.md
	notangle -RExamples rdf-guide.md > example.ttl

openbiodiv.ttl : rdf-guide.md
	notangle -R"OpenBiodiv Ontology" rdf-guide.md > openbiodiv.ttl
	cp openbiodiv.ttl "../../jbs-article/additional-file-1.ttl"

Rules.sparql : RDF_Guide.md
	notangle -R"Rules" RDF_Guide.md > Rules.sparql


.PHONY: Ontology
ontology: openbiodiv.ttl

.PHONY: examples
examples: Examples.ttl

.PHONY: rules
rules: Rules.sparql



.PHONY: all
all: ontology examples

