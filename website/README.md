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

## Taxonomic Name

This template should be invoked whenever the response is of type `:LatinName` or `:TaxonomicConceptLabel`, both subclasses of `:TaxonomicName` in the ontology!

### Query 1: Basic Information

This query dumps the basic name information:

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
PREFIX : <http://openbiodiv.net/>
CONSTRUCT
{
  ?name rdfs:label ?name_string.
  ?name rdf:type ?class.
  ?name dwc:verbatimTaxonRank ?verbatim_rank.
  ?name dwc:taxonomicRank ?rank.
  ?name dwc:scientificNameAuthorship ?author.
  ?name dwc:genus ?genus.
  ?name dwc:subgenus ?subgenus.
  ?name dwc:specificEpithet ?species.
  ?name dwc:infraSpecificEpithet ?subspecies.
  ?name dwc:order ?order.
  ?name dwc:family ?family.
  ?name :nameAccordingToId ?sec.
}
WHERE {
 BIND(URI("http://openbiodiv.net/8f572c9b-7b75-44e0-b383-e5eb429621dd") as ?name )  
 {	
   ?name rdfs:label ?name_string.
   ?name rdf:type ?class.
 }
 UNION {
   ?name dwc:verbatimTaxonRank ?verbatim_rank.
 }
 UNION {
   ?name ?dwciri:taxonRank ?rank .
 }
  UNION {
   ?name dwciri:scientificNameAuthorship ?author .
 }
 UNION {
   ?name dwc:genus ?genus.
 }
 UNION {
   ?name dwc:subgenus ?subgenus.
 }
 UNION {
   ?name dwc:specificEpithet ?species.
 }
 UNION {
   ?name dwc:infraSpecificEpithet ?subspecies.
 }
 UNION {
   ?name dwc:order ?order.
 }
 UNION {
   ?name dwc:family ?family.
 }
 UNION {
   ?name :nameAccordingToId ?sec.
 }
}  
```

Display

(1) (2) (3)

(2) -> ?author
(3) -> sec. ?sec

(1) depending on ?rank
if rank is not one of `:Genus`,`:Subgenus`, `:Species`, or `:Subspecies` display normally.
Otherwise display in cursive
?genus (?subgenus) ?species ?subspecies

Note: subgenus is in parenthesis


# Query 2: Statistics

Given the identfier of a name (e.g. http://openbiodiv.net/8f572c9b-7b75-44e0-b383-e5eb429621dd), this returns statistics of where the name has been used.

```
PREFIX po: <http://www.essepuntato.it/2008/12/pattern#>
PREFIX pkm: <http://proton.semanticweb.org/protonkm#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?tnu (group_concat(?class) as ?classes)
WHERE {
 BIND(URI("http://openbiodiv.net/097bc254-8408-4a4e-8219-debf8b276ce5") as ?name)
 ?tnu pkm:mentions ?name.
 ?component po:contains ?tnu.
 ?component rdf:type ?class.
} GROUP BY ?tnu
```

The query will return a table with two columns: the first one are the different usages of the name, and the second a list of space-separated types of the components who contain the usage.

The following types are of interest:

- `doco:Title`
- `sro:Abstract`
- `doco:FrontMatter`
- `:Treatment`
- `fabio:JournalArticle`

Here's how this particular example ought to be displayed:



Hyleoglomeris mentions in abstract: 1
Hyleoglomeris mentions in front title: 1
Hyleoglomeris mentions in front matter: 2
and so on..

### Query 3: Related Names

```
PREFIX : <http://openbiodiv.net/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
CONSTRUCT {
 ?name :relatedName ?name2
 ?name2 rdfs:label ?label.
}
WHERE {
  BIND(URI("http://openbiodiv.net/7c70d3ed-277e-4165-b6ab-09fa56586526") as ?name)
  ?name :relatedName ?name2.
  ?name2 rdfs:label ?label .
  FILTER (?name != ?name2)
    FILTER NOT EXISTS {?name owl:sameAs ?name2}
}
```

Display: display the related names as clickable links.

Here's how the find the label of a given ID.

```
PREFIX : <http://openbiodiv.net/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
CONSTRUCT {
    ?name rdfs:label ?lab .
}

where { 
    BIND (URI("http://openbiodiv.net/584ac692-79b6-4adc-8348-5d51aa43202c") as ?name)
	?name rdfs:label ?lab .
} 
```

## Person

[Design - Slide 1](person-template/Slide1.PNG)
[Design - Slide 2](person-template/Slide2.PNG)

Text for the graphics:

Title: Articles per Year for <name of person>
labels may be swapped if we decide to do the graphic horizontally
X axis label: Year
Y axis label: Number of Articles

If we decide to include most popular keyword for the year, we need to add an additional 

Legend: 
The length of the bars corresponds to the number of articles per year. The text next to the bar is the most popular topic that the author has published on based on his or her papers' keywords.

### Query 1 

Fetches information about a person.

Replace the UUID with your person UUID.

TODO: ruined this query during one of the commits. Need to restore/rewrite it.

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

Top 2 collaborators

```


PREFIX : <http://openbiodiv.net/> 
PREFIX dcterms: <http://purl.org/dc/terms/> 
PREFIX frbr: <http://purl.org/vocab/frbr/core#> 
PREFIX prism: <http://prismstandard.org/namespaces/basic/2.0/> 
PREFIX dc: <http://purl.org/dc/elements/1.1/> 
PREFIX fabio: <http://purl.org/spar/fabio/> 
PREFIX owl: <http://www.w3.org/2002/07/owl#>

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT (sample(?name1) as ?n1) (count(DISTINCT ?paper1) as ?num_of_col_with1)  (sample(?name2) as ?n2) (count(DISTINCT ?paper2) as ?num_of_col_with2)  ((?num_of_col_with1+ ?num_of_col_with2) as ?solsize)
WHERE {
  BIND ( URI( "http://openbiodiv.net/17b0887c-5c14-46c6-9d42-159fb9312770") as ?person )  
    
  ?paper1 dcterms:creator   ?person ;
         dcterms:creator   ?collab1 .
  ?collab1 rdfs:label ?name1 .
    FILTER( ?person != ?collab1 )
     FILTER NOT EXISTS { ?person owl:sameAs ?collab1 .}

  ?paper2 dcterms:creator ?person ;
          dcterms:creator ?collab2 .
    ?collab2 rdfs:label ?name2 .
    FILTER(?person != ?collab2)
    FILTER NOT EXISTS{?person owl:sameAs ?collab2}
    FILTER(?collab2 != ?collab1)
    FILTER NOT EXISTS{?collab2 owl:sameAs ?collab1}

} GROUP BY ?collab1 ?collab2 ORDER BY DESC (?solsize) LIMIT 1```

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
