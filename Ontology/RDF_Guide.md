# OpenBiodiv RDF Guide

This is the Open Biodiversity Knowledge Management System (OpenBiodiv/ OBKMS) 
RDF Guide. It is intended to fully describe the data model of OpenBiodiv/ OBKMS 
and aid users in generating OpenBiodiv/ OBKMS-compatible RDF and in creating 
working SPARQL queries or other extensions for OpenBiodiv/ OBKMS.

This is a **literate programming document**. This means that the formal 
description of the data model (i.e. ontology) is found within the document 
itself and is extracted from it with a program (`noweb`).

## Imported ontologies

We start the description of the data model by specifying the external ontologies
that the model imports. All ontologies from directory `~/Ontology/imports/` are 
imported. In addition to that we have the OpenBiodiv/ OBKMS Core Ontology, 
`~/Ontology/openbiodiv.ttl`, described in this document is imported. Here’s a 
table of the imporeted ontologies:

[Catalog of imported ontologies](Ontology/imports/Catalog.md)

## Prefixes

In OpenBiodiv/ OBKMS prefixes are stored in a YAML configuration file called

[Prefixes database](R/obkms/inst/prefix_db.yml)

Of these three namespaces have special meaning:

1. `pensoft:` is used to issue identifiers for Pensoft-specific objects;

2. `openbiodiv:` is used to issue identifiers to the ontology classes and 
properties of the OpenBiodiv/ OBKMS ontology;

3. `trt:` is used to refer to the tightly-linked Treatment Ontology classes and 
properties.

## General ideas

#### Usage of `skos:prefLabel`

The objects in OBKMS all have unique identifiers (currently in the `pensoft:` 
namespace). In addition to those identifiers, the objects have labels that are 
there primarily for human consumption. Labels can be things like the DOI (in the
case of an article), the Latin name of a taxon (in the case of scientific 
names). This preferred label is encoded with the property `skos:prefLabel`. 
Furthermore, an object can have secondary (alternative) labels such as a 
different spelling of a scientific name, or a vernacular name of a taxon. In 
this case we use `skos:altLabel`.

## Concepts

### Bibliographic concepts

OpenBiodiv/OBKMS contains information extracted from scientific articles. As 
such system, OpenBiodiv/OBKMS needs allows users to express the bibliographic 
information stored in the articles, along with the scientific knowledge. To 
express bibliographic information OpenBiodiv/OBKMS uses the [Semantic Publishing
and Referencing Ontologies, a.k.a SPAR 
Ontologies](http://www.sparontologies.net/) and builds on top of them.

### Journal Article

Every article is represented in RDF using the FaBiO ontology as
`fabio:JournalArticle`.

#### Example instantiation of an article

```
pensoft:080ba99b-f6c6-4a7f-9ed6-0b0c7c8a7b82 rdf:type fabio:JournalArticle ;
	 skos:prefLabel "10.3897/BDJ.1.e953" ;
	 prism:doi "10.3897/BDJ.1.e953" ;
	 fabio:hasPublicationYear "2013"^^xsd:gYear ;
	 dcterms:title "Casuarinicola australis Taylor, 2010 (Hemiptera: Triozidae), newly recorded from New Zealand"@en-us ;
	 po:contains pensoft:c298e00c-e27a-46e1-bc9d-be4c7a1121cb , pensoft:16dbd5c5-e21f-4f76-a964-f58385ee4ccb , pensoft:treatment1 . 
```

Except for the usages of `skos:prefLabel` all other properties as used as in the
SPAR Ontologies. Key here is that the article is linked to different sub-article
level elements such as treatments (e.g. `pensoft:treatment1`) via `po:contains`.