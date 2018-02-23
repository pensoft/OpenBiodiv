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
    {
    SELECT (SAMPLE(?article) AS ?article) (MAX(?name) AS ?name) {
    :905f17cf-23b1-4562-a11a-c861c96c4fd2  frbr:realization ?article ;
           dc:creator ?author .
      ?author foaf:surname ?surname ;
            foaf:firstName ?first_name.
    BIND(CONCAT(STR(?surname), ", ", STR(?first_name)) AS ?name)    
    } GROUP BY ?author    
    }
    
    ?article fabio:hasPublicationYear ?year ;
                 prism:doi ?doi;
                 dc:title ?title.
    ?article dc:publisher/skos:prefLabel ?publisher .
    
} GROUP BY ?article ?author


```

## Authors

```
SELECT (MAX(?name) AS ?NAME) ?author_id
WHERE { 
    :905f17cf-23b1-4562-a11a-c861c96c4fd2 dc:creator ?author_id .
   ?author_id rdfs:label ?name .
}  GROUP BY(?author_id)
```

## Taxa

```
...
SELECT (MAX(?taxonomic_name) AS ?taxonomic_name) ?taxonomic_name_id
WHERE { 
   :905f17cf-23b1-4562-a11a-c861c96c4fd2 pkm:mentions ?taxonomic_name_id .
    ?taxonomic_name_id rdfs:label ?taxonomic_name .
} GROUP BY ?taxonomic_name_id

```
