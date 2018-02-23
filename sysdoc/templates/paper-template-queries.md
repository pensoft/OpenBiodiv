# Paper Template

## Id

We have a resource whose identifier is denoted by`id`.

This template should be invoked, whenever the type of the resource is one of

```
 fabio:JournalArticle
 fabio:ResearchPaper
 :TaxonomicPaper
 ```

If the type is `fabio:JournalArticle`, then you must obtain the corresponding paper resource id before continuing.

```
... 
SELECT ?paper
WHERE { 
     ?paper rdf:type fabio:ResearchPaper ;
            frbr:realization <id> .
}
```

## Title and Type

This will be modified in the future when the `:TaxonomicPaper` type arrives.

```
...
SELECT ?paper ?title ?paper_type
WHERE { 
     ?paper rdf:type fabio:ResearchPaper ;
            frbr:realization ?article .
      BIND("Research Paper" as ?paper_type)
      ?article dc:title ?title .
}
```

## Reference

For one paper, we can have multiple articles. Each row in the table represents one reference that needs to be formatted.

```
...
SELECT (GROUP_CONCAT(?name; separator = " and ") AS ?authors_string) (SAMPLE(?year) AS ?year) (SAMPLE(?publisher) AS ?publisher) (SAMPLE(?doi) AS ?doi) (SAMPLE(?title) AS ?title)
WHERE { 
    :905f17cf-23b1-4562-a11a-c861c96c4fd2  frbr:realization ?article ;
           dc:creator ?author .
    ?author foaf:surname ?surname ;
            foaf:firstName ?first_name.
    BIND(CONCAT(STR(?surname), ", ", STR(?first_name)) AS ?name)
    ?article fabio:hasPublicationYear ?year ;
                 prism:doi ?doi;
                 dc:title ?title.
    ?article dc:publisher/skos:prefLabel ?publisher .
    
} GROUP BY ?article

```

## Authors

```
...
SELECT ?name ?author_id
WHERE { 
   <id> dc:creator ?author_id .
   ?author_id rdfs:label ?name .
} 
```

## Taxa

```
...
SELECT ?taxonomic_name ?taxonomic_name_id
WHERE { 
	?article frbr:realizationOf <id> ;
    	  po:contains ?taxonomic_name_usage .
    
    ?taxonomic_name_usage rdf:type :TaxonomicNameUsage ;
    	pkm:mentions ?taxonomic_name_id .
    
    ?taxonomic_name_id rdfs:label ?taxonomic_name .
}
```
