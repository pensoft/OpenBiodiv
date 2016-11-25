# SPARQL Templates

## Rename Template

First, select all triples with source as subject, and replace triples with target as subject

```
PREFIX pensoft: <http://id.pensoft.net/>
WITH <http://id.pensoft.net/a1149cb2-3bd2-46c5-a357-1af2f42b639f>

INSERT {
	pensoft:biodiversity-data-journal ?p ?o
}
WHERE {
	pensoft:cb83581c-60fe-415e-92cb-7ef0ffe2862e ?p ?o
}
```

Do it for the object as well

```
PREFIX pensoft: <http://id.pensoft.net/>
WITH <http://id.pensoft.net/a1149cb2-3bd2-46c5-a357-1af2f42b639f>

DELETE { 
?s ?p  pensoft:cb83581c-60fe-415e-92cb-7ef0ffe2862e
}
INSERT {
	?s ?p pensoft:biodiversity-data-journal
}
WHERE {
	?s ?p  pensoft:cb83581c-60fe-415e-92cb-7ef0ffe2862e
}
```

## Select everything from graph

```
SELECT ?s ?p ?o
WHERE {
	GRAPH <http://id.pensoft.net/a1149cb2-3bd2-46c5-a357-1af2f42b639f> {
	?s ?p ?o
	}

} 
```

## Insert data into a graph

```
INSERT DATA
{
	GRAPH pensoft:yourcon {
	pensoft:80a4450d-ee39-4cda-8b64-8753bae85a4d   rdf:type   nomen:ScientificName ;
	 skos:prefLabel   "Heser stoevi" ;
	 dwc:rank   "species" ;
	 dwc:species   "stoevi" ;
	 dwc:genus   "Heser" . 
	}
}
```

## Scientific names used in figures

```
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX frbr: <http://purl.org/spar/frbr/>
PREFIX doco: <http://purl.org/spar/doco/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
SELECT ?name ?figure
WHERE {
    ?sci_name_id skos:prefLabel ?name .
    ?tnu dwciri:scientificName ?sci_name_id .
    ?figure frbr:realizationOf ?tnu .
    ?figure a doco:Figure .
}
```
	