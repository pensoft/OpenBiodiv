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

Here we will introduce formally and informally all new classes and properties
used in the OpenBiodiv Core Ontology, as well as informally describe borrowed
classes and properties from existing ontologies.

### Bibliographic concepts

OpenBiodiv/OBKMS contains information extracted from scientific articles. As 
such system, OpenBiodiv/OBKMS needs allows users to express the bibliographic 
information stored in the articles, along with the scientific knowledge. To 
express bibliographic information OpenBiodiv/OBKMS uses the [Semantic Publishing
and Referencing Ontologies, a.k.a SPAR 
Ontologies](http://www.sparontologies.net/) and builds on top of them.

#### class JournalArticle

Every article is represented in RDF using the FaBiO ontology as
`fabio:JournalArticle`. For additional information refer to [the FaBiO
documentation](http://www.sparontologies.net/ontologies/fabio).

##### Example instantiation of an article

```
pensoft:exampleArticle1 rdf:type fabio:JournalArticle ;
	 skos:prefLabel "10.3897/BDJ.1.e953" ;
	 prism:doi "10.3897/BDJ.1.e953" ;
	 fabio:hasPublicationYear "2013"^^xsd:gYear ;
	 dcterms:title "Casuarinicola australis Taylor, 2010 (Hemiptera: Triozidae), newly recorded from New Zealand"@en-us ;
	 po:contains pensoft:exampleTreatment1 . 
```

Except for the usages of `skos:prefLabel` all other properties as used as in the
SPAR Ontologies. Key here is that the article is linked to different sub-article
level elements such as treatments (e.g. `pensoft:treatment1`) via `po:contains`.

#### class Treatment

In OBKMS, we consider Treatment to be a rhetorical element of a taxonomic 
publication akin to Introduction, Methods, etc. Treatment is originally defined 
in the [Treatment
Ontology](https://github.com/plazi/TreatmentOntologies/blob/master/treatment.owl),
however this definition of Treatment as a discourse element is slightly more 
complex. We derive the class Treatment from
<http://purl.org/spar/deo/DiscourseElement>:

```
<<treatment_definition>>=
trt:Treatment a owl:Class ;
    rdfs:label "treatment"@en ;
    rdfs:comment "A species discussion done for taxonomic purposes TODO: Needs rewriting!"@en ;
    rdfs:subClassOf deo:DiscourseElement .
@
```

#### Example instantiation of a treatment

Usually, what we do is that we have an instance of a document section which is
also an instance of the treatment rhetorical element:

```
pensoft:exampleTreatment1 a doco:Section , trt:Treatment .
```

### Taxonomic Concepts

In this subsection we introduce all classes and properties which are used to
convey taxonomic/ systematic information.

#### class Taxon Concept

For all practical purposes the semantics of <http://rs.tdwg.org/dwc/terms/Taxon>
are compatible with the notion of a taxon concepts (TODO cite Nico Franz, Berensohn).

We import

https://github.com/darwin-sw/dsw/blob/master/dsw.owl

in order to be able to instantiate taxon concepts.

#### Connection between a treatment and a taxon concept

We consider treatments to be FRBR expressions and taxon concepts to be the
corresponding FRBR works. Therefore  link treatments to taxon concepts
like this:

```
pensoft:exampleTaxonConcept1 a dwc:Taxon.
pensoft:exampleTreatment1 frbr:realizationOf pensoft:exampleTaxonConcept1.
```

#### class biologicalName

In OpenBiodiv/OBKMS, we reify scientific names. [NOMEN](https://github.com/SpeciesFileGroup/nomen)
does provide classes for scientific names. However, the identifiers that 
NOMEN uses are not human readable. For example, the identifier for
class "biological name" is `NOMEN_0000030`, which is highly inscrutable for humans.
That's why we have defined names in OpenBiodiv and mapped them to their 
NOMEN equivalents.

```
<<scientific_name_defintion>>=
openbiodiv:scientificName a owl:Class ;
    rdfs:label "scientific name"@en ;
    rdfs:comment "A species discussion done for taxonomic purposes TODO: Needs rewriting!"@en ;
    rdfs:subClassOf deo:DiscourseElement .
@
```
