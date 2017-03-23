Examples.ttl : RDF_Guide.md
	notangle -RExamples RDF_Guide.md > Examples.ttl

.PHONY: ontology
ontology: imports/openbiodiv.ttl

imports/openbiodiv.ttl : RDF_Guide.md
	notangle -R"OpenBiodiv Ontology" RDF_Guide.md > imports/openbiodiv.ttl
