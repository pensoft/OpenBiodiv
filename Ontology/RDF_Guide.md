# OpenBiodiv RDF Guide

This is the OpenBiodiv/OBKMS knowledge system RDF guide. It is intended to
explain to human users and define for computers the data model of
OpenBiodiv/OBKMS and aid users in generating OpenBiodiv/OBKMS-compatible RDF
and in creating  working SPARQL queries or other extensions for
OpenBiodiv/OBKMS.

This guide is a [literate programming
document](https://en.wikipedia.org/wiki/Literate_programming) document.
**Literate programming** is the act of including source code within
documentation. In usual software development practice the reverse hold true.
Thus, the formal description of the data model, i.e. the
[OWL](https://www.w3.org/OWL/) statems that form the ontology are found within
the document  itself and are extracted from it with the program (`noweb`).
`noweb` can be easily obtained for GNU Linux.

## Introduction

**Motivation** The raison d'être of the OpenBiodiv/OBKMS data model is to enable the
operation of a semantic database as part of OpenBiodiv/OBKMS. The data model
consists of:

1. A formal OWL ontology introducing the entities that our knowledge base
holds and giving axioms that restrict the ways in which they can be combined.

2. Natural language descriptions of the meaning of these concepts in our
conceptualization of the world.

3. Examples and recommendations that illustrate and describe the intended
model to human users as the formal ontology necessarily will be more lax than
the intented model.

As this is a literate programming document, we take the approach of explaining
the data model to in human-form, and defining the Core Ontology where it is
needed for the explanations.

**Incorporated external ontologies** Our data model is a natural extension of
existing data models. Therefore, we incorporate several external ontologies
into ours. All ontologies from the directory `~/Ontology/imports/` are
imported. In addition to that we import the OpenBiodiv/OBKMS Core Ontology,
`~/Ontology/openbiodiv.ttl` described herein. Here’s a catalog of the imported
ontologies:

[Catalog of imported ontologies](Ontology/imports/Catalog.md)

**Prefixes** In OpenBiodiv/OBKMS prefixes are stored in a YAML configuration
file called

[Prefixes database](R/obkms/inst/prefix_db.yml)

Of these three namespaces have special meaning:

1. `pensoft:` is used to issue identifiers for Pensoft-specific objects;

2. `openbiodiv:` is used to issue identifiers to the ontology classes and 
properties of the OpenBiodiv/OBKMS Core Ontology;

3. `trt:` is used to refer to the tightly-linked Treatment Ontology classes
and  properties.

**Types of entities that OpenBiodiv manages**  There are two ways to look at
the types of entities that the OpenBiodiv knowledge system manages. The first
way is to look at the application domain. The OpenBiodiv/OBKMS application
domain is the semantic publishing of taxonomic, systematic, biodiversity, and
related information. Therefore, the entities that OpenBiodiv manages are
separated into these domains.

Another way to look at the entities that OpenBiodiv/OBKMS manages is the
structural way. As the main sources of information for OpenBiodiv/OBKMS are
scientific articles, we can separate the entities that are extracted in
entities which are structural parts of the articles such as articles,
paragraphs, sections, tables, figures, etc. and entities which are talked
about - the actual (domain-specific) information contained in the articles.

Here we will split the description of the model on domains.

## RDF Model

### of the Publishing Domain
The publishing domain is described in our model using the Semantic Publishing
and Referencing Ontologies, a.k.a. [SPAR
Ontologies](http://www.sparontologies.net/). We do import several of these
ontologies (please consult the paragraph "Incorporated external ontologies").
Refer to the documentation on the SPAR Ontologies' site for an exhaustive
treatment.

In the reset of this section we describe the modeling entities of the
publishing domain that are not found in the spar ontologies. The central 
new class in OpenBiodiv not found in SPAR is the `Treatment` class, borrowed
from the [Treatment Ontologies](https://github.com/plazi/TreatmentOntologies).

#### Treatments

**What is a taxonomic treatment?** See [Plazi](http://plazi.org) for an
explanation of what a treatment is in the taxonomic sense of the word.

**Def. Treatment** In OpenBiodiv/OBKMS, we consider Treatment to be a
rhetorical element of a taxonomic publication akin to Introduction, Methods,
etc. Thus, we derive the RDF type Treatment from
`http://purl.org/spar/deo/DiscourseElement`:

```
<<Treatment>>=
trt:Treatment a owl:Class ;
    rdfs:label "treatment"@en ;
    rdfs:comment "A treatment is rhetorical element of a taxonomic
      publication, i.e. a specialized section, where a taxon circumscription
      takes place.!"@en ;
    rdfs:subClassOf deo:DiscourseElement .
@
```

**Remark: Linking Treatments to Taxon Concepts.** Note that this definition of
Treatment makes it into a FRBR expression. TODO: verify in SPARQL that this
actually holds. Treatments are closely  linked to taxon concepts. Treatments
are the expressions of taxon concepts


<br />

bla

### Modeling the taxonomic domain



## OpenBiodiv Core Ontology

## Imported ontologies

We start the description of the data model by specifying the external ontologies
that the model imports. 



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

#### Class for taxon concepts

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

#### Biological names

In OpenBiodiv/OBKMS, we reify scientific names.
[NOMEN](https://github.com/SpeciesFileGroup/nomen) does provide classes for
scientific names. For example, the identifier for class "biological name" is
`NOMEN_0000030`. However, the identifiers that NOMEN uses are meaningless. This
is justified in some cases (TODO citation needed), however, in our workflow both
RDF generation and debugging would be severely hampered by this convention.
That's why we have defined names in OpenBiodiv and mapped them to their NOMEN
equivalents.

```
<<Biological names>>=
openbiodiv:scientificName a owl:Class ;
    rdfs:label "scientific name"@en ;
    owl:sameAs nomen:NOMEN_0000036 .
    
openbiodiv:vernacularName a owl:Class ;
  rdfs:label "vernacular name"@en ;
  ownl:sameAs nomen:NOMEN_0000037 .
@
```

##### Example usage of biological names

```
pensoft:exampleTaxonConcept1 a dwc:Taxon ; 
  dwciri:scientificName :exampleName1 ;
  dwc:nameAccordingTo "Susy Fuentes-Bazan, Pertti Uotila, Thomas Borsch: A novel phylogeny-based generic classification for Chenopodium sensu lato, and a tribal rearrangement of Chenopodioideae (Chenopodiaceae). In: Willdenowia. Vol. 42, No. 1, 2012, p. 14." ;
  dwciri:vernacularName :exampleName2 ; 
  
  "Mauer-Gänsefuss"@de,
                                                           "Nettle-leaved Goosefoot"@en ;
                         .

:taxonName a trt:ScientificName ;
                    dwc:species "murale" ;
                    dwc:genus "Chenopodium"
```


## Putting the pieces together in an Ontology

```
<<OpenBiodiv Core Ontology>>=

@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix openbiodiv: <http://openbiodiv.net/> .
@prefix pensoft: <http://id.pensoft.net/> .

openbiodiv:
  rdf:type owl:Ontology ;
  owl:versionInfo "0.2" ;
  rdfs:comment "OpenBiodiv Core Ontology" ;
  dc:title "OpenBiodiv Core Ontology" ;
  dc:subject "OpenBiodiv Core Ontology" ;
  rdfs:label "OpenBiodiv Core Ontology" ;
  dc:creator "Pensoft/Plazi/Bulgarian Academy of Sciences
  (Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev)" ;
  dc:rights "CCBY" .

<<Treatment>>
@
```