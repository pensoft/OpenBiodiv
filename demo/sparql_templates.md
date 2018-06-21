# SPARQL Templates/ OBKMS Prototype Demo

## Diagnostic Queries

Count the number of triples in the graph.

SELECT (COUNT (*) AS ?count)
WHERE {
?s ?p ?o . 
}

Count the number of sub-graphs in the graph.

SELECT (COUNT(DISTINCT ?g ) as ?numberOfGraphs)
WHERE {
   GRAPH ?g { ?s ?p ?o .}
}

Count the number of journals in the archive:

PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

PREFIX fabio: <http://purl.org/spar/fabio/>
SELECT ?journal_name
WHERE {
    ?j a               fabio:Journal ;
       skos:prefLabel  ?journal_name .
}

Count articles per journal:
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX fabio: <http://purl.org/spar/fabio/>
SELECT ?journal_name (COUNT(?g) AS ?count) where
  {
    GRAPH ?g {
        ?j a                  fabio:Journal ;
           skos:prefLabel  ?journal_name .     
  } 
  }
GROUP BY ?journal_name ORDER BY DESC(COUNT(*))

Count the number of names in the nomenclature graph:

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
SELECT (COUNT (DISTINCT ?name) AS ?number_of_names)
FROM pensoft:Nomenclature 
WHERE {
    ?name a trt:ScientificName.
}


## Name Related Queries

List all names (@Kiril: HOW TO IMPROVE THIS QUERI\??):

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
SELECT DISTINCT ?literal
FROM pensoft:Nomenclature 
WHERE {
    ?name a trt:ScientificName .
    ?name skos:prefLabel ?literal .
}

Give me all the names of rank order:

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
SELECT ?name ?literal
FROM pensoft:Nomenclature 
WHERE {
    ?name a trt:ScientificName;
        dwc:rank ?order .
    FILTER(lcase(str(?order)) = "order" || lcase(str(?order)) = "ordo")
    ?name skos:prefLabel ?literal .
} ORDER BY ?literal

Give me all names of rank kingdom:

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
SELECT DISTINCT ?literal
FROM pensoft:Nomenclature 
WHERE {
    ?name a trt:ScientificName;
        dwc:rank ?order .
    FILTER(lcase(str(?order)) = "kingdom" || lcase(str(?order)) = "regnum")
    ?name skos:prefLabel ?literal .
}



List all names in figures

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX frbr: <http://purl.org/spar/frbr/>
PREFIX po: <http://www.essepuntato.it/2008/12/pattern#>
PREFIX c4o: <http://purl.org/spar/c4o/>
PREFIX doco: <http://purl.org/spar/doco/>
SELECT ?fig ?l1 ?l2 ?tnu
WHERE {
    ?name a                       trt:ScientificName ;
          skos:prefLabel ?l1 .
    ?tnu  a                       trt:TaxonNameUsage;
          dwciri:scientificName   ?name .
    ?fig  frbr:realizationOf      ?tnu ;
          a                       doco:Figure ;
          po:contains             ?caption .
    ?caption c4o:hasContent       ?l2 .
  
}

List all names contained in figures, which indicate voucher specimens

PREFIX pensoft: <http://id.pensoft.net/>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX dwciri: <http://rs.tdwg.org/dwc/iri/>
PREFIX frbr: <http://purl.org/spar/frbr/>
PREFIX po: <http://www.essepuntato.it/2008/12/pattern#>
PREFIX c4o: <http://purl.org/spar/c4o/>
PREFIX doco: <http://purl.org/spar/doco/>
SELECT ?fig ?l1 ?l2
WHERE {
    ?name a                       trt:ScientificName ;
          skos:prefLabel ?l1 .
    ?tnu  a                       trt:TaxonNameUsage;
          dwciri:scientificName   ?name .
    ?fig  frbr:realizationOf      ?tnu ;
          a                       doco:Figure ;
          po:contains             ?caption .
    ?caption c4o:hasContent       ?l2 .
    FILTER (regex(?l2, "voucher") || regex(?l2, "type"))
}

Give me the article of a given figure (beware of prefixes)
PREFIX po: <http://www.essepuntato.it/2008/12/pattern#>
PREFIX fabio: <http://purl.org/spar/fabio/> 
PREFIX pensoft: <http://id.pensoft.net/>
PREFIX doco: <http://purl.org/spar/doco/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT *
WHERE {
    ?x a fabio:JournalArticle ;
       skos:prefLabel ?l .
    ?x po:contains pensoft:F288676 .
    
}

Show FactForge

http://ldsr.ontotext.com/sparql

UNIX DEMO

========================================

## PREFIX PROBLEMS @Kiril)

frbr -wrong prefix
po - wrong prefix
pensoft -does not autocomplete
fabio - does not contract in display

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
	

### Related Names

	
PREFIX trt: <http://plazi.org/treatment#>
INSERT {
    ?a trt:relatedName ?b .
    ?b trt:relatedName ?a .
}
WHERE {
?a a trt:ScientificName .
?b a trt:ScientificName .
?c a trt:NomenclaturalAct .
?c trt:ValidName ?a ;
   trt:NomenclaturalCitation ?b .
}
	

Find related names

Lygistorrhina austroafricana

PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX trt: <http://plazi.org/treatment#>
SELECT ?label
WHERE {
?a a trt:ScientificName ;
    skos:prefLabel "Xanthichthys greenei" .
?b trt:relatedName ?a ;
   skos:prefLabel ?label ;
}


Prune extra names --- THIS DOESN'T WORK!!!

PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX trt: <http://plazi.org/treatment#> 
PREFIX pensoft: <http://id.pensoft.net/>

DELETE {
   ?a skos:prefLabel ?l2 .
}

INSERT {
GRAPH pensoft:Nomenclature {
    ?a dwc:species ?sp ;
       dwc:genus ?g .
	?a skos:prefLabel CONCAT(?sp, " ", ) .
}
}
WHERE {
?a a trt:ScientificName ;
   skos:prefLabel "Arotes albicinctus" ;
   skos:prefLabel ?l1 ;
   skos:prefLabel ?l2 ;
}


> find_related_names("Arotes albicinctus")
                                                           b                                 label
1 http://id.pensoft.net/2c5d44b3-23fa-4bb9-9102-03c6f1e3b5db                   Arotes annulicornis
2 http://id.pensoft.net/eb9e609f-d1b5-42a0-8a6a-2e1f9072c4c0                    Arotes albicinctus
3 http://id.pensoft.net/d5a275bf-078f-450a-a0cd-7fb003668350                                Arotes