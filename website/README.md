# Round 1

### With Exact Match

Query is sent from the search form to GraphDB. Response is then parsed for round 2.

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX owl: <http://www.w3.org/2002/07/owl#>

CONSTRUCT {
    ?resource rdf:type ?class;
        owl:sameAs ?synonym.
}
where {  	
    ?resource rdfs:label "Lyubomir Penev";        
              rdf:type ?class .
   OPTIONAL{ ?resource owl:sameAs ?synonym .
    FILTER (?resource != ?synonym ) }
}
```

### Round one with fuzzy Match

This query uses the Lucene index:

```
PREFIX lucene: <http://www.ontotext.com/connectors/lucene#>
PREFIX inst: <http://www.ontotext.com/connectors/lucene/instance#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

CONSTRUCT {
    ?resource rdf:type ?class;
              lucene:score ?score ;
              owl:sameAs ?synonym.
}
WHERE {
  ?search a inst:WordSearch ;
      lucene:query "label:Lyubomir~ Penev~" ;
      lucene:entities ?resource .
  ?resource lucene:score ?score ;
    rdf:type ?class .
  OPTIONAL {
    ?resource owl:sameAs ?synonym .
    FILTER (?resource != ?synonym )
  }
} ORDER BY DESC (?score)
```

# Round 2

## Generic

Given an untemplated type and just an id, you can use the following query to get the properties

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?property ?value WHERE { 
	<http://openbiodiv.net/382b63f2-6351-4b7f-bb91-80aa71c6dae4> ?property ?value .
    
} 
```

Make sure you replace <http://openbiodiv.net/382b63f2-6351-4b7f-bb91-80aa71c6dae4> with appropriate URI. I would also drop blank nodes (beginning with _) from displaying.


## Person

[Design - Slide 1](person-template/Slide1.PNG)
[Design - Slide 2](person-template/Slide2.PNG)

### Query 1 

Fetches information about a person.

Replace the UUID with your person UUID.

```
PREFIX : <http://openbiodiv.net/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

CONSTRUCT {
    ?person :fullName ?full_name ;
            :firstName ?first_name ;
            :lastName  ?last_name ; 
            :affiliation ?institution ;
    		:email ?email .
}
WHERE {
  BIND ( URI("http://openbiodiv.net/f207793c-dcc8-4718-8ff5-8b5cb51534ae") as ?person )  
  ?person rdfs:label ?full_name .
  
  OPTIONAL { ?person :affiliation ?institution . }
  OPTIONAL { ?person foaf:mbox ?email . }
  OPTIONAL { ?person foaf:firstName ?first_name . }
  OPTIONAL { ?person foaf:surname  ?last_name . }

}
```

### Query 2

Fetches info about articles that a person has written.

```
PREFIX : <http://openbiodiv.net/> 
PREFIX dcterms: <http://purl.org/dc/terms/> 
PREFIX frbr: <http://purl.org/vocab/frbr/core#> 
PREFIX prism: <http://prismstandard.org/namespaces/basic/2.0/> 
PREFIX dc: <http://purl.org/dc/elements/1.1/> 
PREFIX fabio: <http://purl.org/spar/fabio/> 
CONSTRUCT {
    ?article :doi ?doi ;
             :publicationDate ?publication_date ;
             :keyword ?keyword ;
             :title ?title ;
             :publicationYear ?publicationYear .
}
WHERE {
  BIND ( URI("http://openbiodiv.net/8990d866-a346-46b4-b935-8d84b7856fc3") as ?person )  
  ?paper dcterms:creator   ?person .
  ?article frbr:realizationOf  ?paper .  
  OPTIONAL { ?paper prism:keywords ?keyword . } 
  OPTIONAL { ?article prism:publicationDate ?publication_date . }
  OPTIONAL { ?article prism:doi ?doi . }
  OPTIONAL { ?article dc:publisher ?publisher . }
  OPTIONAL { ?article dc:title ?title . }
  OPTIONAL { ?article fabio:hasPublicationYear ?publicationYear . }
}
```

### Query 3

Top collaborators

```
PREFIX : <http://openbiodiv.net/> 
PREFIX dcterms: <http://purl.org/dc/terms/> 
PREFIX frbr: <http://purl.org/vocab/frbr/core#> 
PREFIX prism: <http://prismstandard.org/namespaces/basic/2.0/> 
PREFIX dc: <http://purl.org/dc/elements/1.1/> 
PREFIX fabio: <http://purl.org/spar/fabio/> 
PREFIX owl: <http://www.w3.org/2002/07/owl#>

SELECT ?person (SAMPLE(?name) as ?name_p1) ?person2 (SAMPLE(?name2) as ?name_p2) (COUNT(?paper) as ?num_of_papers )
WHERE {
  BIND ( URI("http://openbiodiv.net/8990d866-a346-46b4-b935-8d84b7856fc3") as ?person )  
  ?paper dcterms:creator   ?person ;
         dcterms:creator   ?person2 .
    ?person rdfs:label ?name .
    ?person2 rdfs:label ?name2.
  ?article frbr:realizationOf  ?paper .  
  FILTER( ?person != ?person2)
    FILTER NOT EXISTS{?person owl:sameAs ?person2}
} GROUP BY ?person ?person2 
ORDER BY DESC(?num_of_papers)
```

## Taxonomic Name Usage

coming

# ISSUES

- [ ] rewrite round 2 URI's to fit W3C schema, i.e. http://openbiodiv.net/UUID
- [ ] Interpretaion should appear as first section in round 2, as well
- [ ] Interpretation should have a click-thingie to go to round 2
- [ ] discuss design suggestion for further implementation
- [ ] discuss auto-complete or fuzzy match in round 1
- [ ] discuss a generic template that dumps the atoms in a generic way when no template is present!!
- [ ] figure out a better place for this file! this is not a good place, as attaching pictures, etc. polutes the subdirectory. also this is not the readme of datascience package for PJS, but readme for the openbiodiv project. I would like to move it to the openbiodiv package, please everyone let me know if you are allright.
- [ ] write about etc...
