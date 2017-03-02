# OpenBiodiv RDF Guide

This is the Open Biodiversity Knowledge Management System (OBKMS) RDF Guide.
In the rest of this document OBKMS will be more compactly referred to as the
OpenBiodiv Knowledge System, or simply OpenBiodiv. The guide is intended to
explain to human users and define for computers the data model of OpenBiodiv
and aid users in generating OpenBiodiv compatible RDF and in creating working
SPARQL queries or other extensions for OpenBiodiv.

This guide is a [literate programming
](https://en.wikipedia.org/wiki/Literate_programming) document. *Literate
programming* is the act of including source code within documentation. In
usual software development practice the reverse holds true. Thus, the formal
description of the data model, i.e. the [OWL](https://www.w3.org/OWL/)
statements that form the ontology are found within the document  itself and
are extracted from it with the program (`noweb`). `noweb` can be easily
obtained for GNU Linux.

## Introduction

**Motivation.** The raison d'être of the OpenBiodiv data model is to enable
the operation of a semantic database as part of OpenBiodiv. The data model
consists of:

1. A formal OWL ontology, called from here on *OpenBiodiv Core Ontology*,
introducing the entities that our knowledge base holds and giving axioms that
restrict the ways in which they can be combined.

2. Natural language descriptions of the meaning of these concepts in our
conceptualization of the world.

3. Examples and recommendations that illustrate and describe the intended
model to human users as the formal ontology necessarily will be more lax than
the intended model.

For a discussion see [Specification of Conceptualization](https://www.obitko.com/tutorials/ontologies-semantic-web/specification-of-conceptualization.html), as well as the article by [Guarino et al. (2009)](http://iaoa.org/isc2012/docs/Guarino2009_What_is_an_Ontology.pdf).

As this is a literate programming document, we take the approach of explaining
the data model to human-like intelligence, and defining the Core Ontology as
we progress with our explanations.

```
<<Ontology>>=
<<Prefixes>>

openbiodiv:
  rdf:type owl:Ontology ;
  owl:versionInfo "0.2" ;
  rdfs:comment "Open Biodiversity Knowledge Management System Ontology" ;
  dc:title "OpenBiodiv Core Ontology" ;
  dc:subject "OpenBiodiv Core Ontology" ;
  rdfs:label "OpenBiodiv Core Ontology" ;
  dc:creator "Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev" ;
  dc:rights "CCBY" .

<<Publishing Domain>>
<<Systematics>>
@
```

We've just defined our *root chunk*. In the `noweb` way of doing literate
programming, we write our source in chunks. Each chunk has a name that is
found between the `<<` and `>>` and ends in `@`. Chunks can contain other
chunks and thus the writing of the source code becomes hierarchical and non-
linear. In the root chunk, we've listed other chunks that we'll introduce
later and some verbatim code. In order to create the ontology we use
the `notangle` command from `noweb`:

```
notangle -ROntology RDF_Guide.md > nowebonto.ttl
```

**Incorporated external ontologies.** Our data model is a natural extension of
existing data models. Therefore, we incorporate several external ontologies
into ours. All ontologies from the directory `~/Ontology/imports/*.ttl` are
loaded into the Knowledge System. In addition to that we load the OpenBiodiv
Core Ontology, `~/Ontology/openbiodiv.ttl` described herein. Here’s a catalog
of the imported ontologies:

[Catalog of imported ontologies](imports/Catalog.md)

**Prefixes.** In OpenBiodiv prefixes are stored in a YAML configuration file
called

[`prefix_db.yml`](../R/obkms/inst/prefix_db.yml)

This guide will not go into the question of the meaning of the prefixes, into
identifiers and into cross-linking. This will be the subject matter of later
"OpenBiodiv Extension and Linking Guide".

```
<<Prefixes>>=
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .
@prefix pensoft: <http://id.pensoft.net/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix pro: <http://purl.org/spar/pro/> .
@prefix scoro: <http://purl.org/spar/scoro/> .
@prefix ti: <http://www.ontologydesignpatterns.org/cp/owl/timeinterval.owl#> .
@prefix tvc: <http://www.essepuntato.it/2012/04/tvc/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix fabio: <http://purl.org/spar/fabio/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix frbr: <http://purl.org/spar/frbr/> .
@prefix prism: <http://prismstandard.org/namespaces/basic/2.0> .
@prefix doco: <http://purl.org/spar/doco/> .
@prefix po: <http://www.essepuntato.it/2008/12/pattern#> .
@prefix co: <http://purl.org/co/> .
@prefix trt: <http://plazi.org/treatment#> .
@prefix c4o: <http://purl.org/spar/c4o/> .
@prefix dwciri: <http://rs.tdwg.org/dwc/iri/> .
@prefix nomen: <http://www.semanticweb.org/dmitriev/ontologies/2013/8/untitled-ontology-6#> .
@prefix dwc: <http://rs.tdwg.org/dwc/terms/> .
@prefix sro: <http://salt.semanticauthoring.org/ontologies/sro#> .
@prefix deo: <http://purl.org/spar/deo/> .
@
```

**Types of entities that OpenBiodiv manages.** There are two ways to look at
the types of entities that OpenBiodiv manages. The first way is to look at the
application domain. OpenBiodiv's application domain is the semantic publishing
of taxonomic, systematic, biodiversity, and related information. Therefore,
the entities that OpenBiodiv manages are separated into these domains.

Another way to look at the entities that OpenBiodiv manages is the structural
way. As the main sources of information for OpenBiodiv are scientific
articles, we can separate the entities that are extracted in entities which
are structural parts of the articles such as articles, paragraphs, sections,
tables, figures, etc. and entities which are talked about - the actual
(domain-specific) information contained in the articles.

Here we will split the description of the model on domains.

**Note on Capitalization.** Our ontology strives be a formal specification of
a conceptualization. In our mental model we have some concepts of some things.
When we talk about these concepts in the abstract, we will make use of
Capitalization. For example, we say Thing for the top-level concept and we say
Treatment when we refer to the concept (introduced later) of a taxon
circumscription. We also have concepts for relations (in our conceptualization
only binary relations are allowed). To denote these relations in the abstract
we use verbal phrases and we might or might not use quotes (we will use quotes
only if it adds to the clarity of exposition). For example, Treatment is a
Thing as opposed to Treatment "is a" Thing. We also have individual instances
of these concepts. To refer to those we might use improper or proper nouns or
phrases wherever appropriate. For example, "the treatment on page 5," or "a
treatment," or "John."

When we formally define a concept in OWL, i.e. issue an URI to it, we shall
refer to the URI, as we refer to all URI's in the text with `typewriter font`.
URI's of classes and vocabularies will be in `MajorCamelCase`. URI's of
relationships will be in `minorCamelCase`. URI's of individuals `will-be-hyphenated`. This seems to generally in accordance with WWW practice.

## RDF Model

### of the Publishing Domain

The publishing domain is described in our model using the Semantic Publishing
and Referencing Ontologies, a.k.a. [SPAR
Ontologies](http://www.sparontologies.net/). We do import several of these
ontologies (please consult the paragraph "Incorporated external ontologies").
Refer to the documentation on the SPAR Ontologies' site for an exhaustive
treatment.

In the rest of this section we describe the modeling of entities in the
publishing domain that are not found in the SPAR ontologies. The central  new
class in OpenBiodiv not found in SPAR is the `Treatment` class, borrowed from
the [Treatment Ontologies](https://github.com/plazi/TreatmentOntologies).

```
<<Publishing Domain>>=
<<Treatment>>

<<Paper Types>>

<<Taxon Classification>>

<<Chronological Classification>>
@
```

#### Taxonomic Treatment

See [Plazi](http://plazi.org/) for an explanation of what a treatment is in
the taxonomic sense of the word.

***Def. (Treatment):** Taxonomic Treatment (or simply Treatment) is
a rhetorical element of a taxonomic publication:*

```
<<Treatment>>=
trt:Treatment a owl:Class ;
    rdfs:label "Taxonomic Treatment"@en ;
    rdfs:label "Taxonomische Abhandlung"@de ;
    rdfs:label "Таксономично пояснение"@bg ;
    rdfs:comment "A taxonomic treatment, or simply a treatment, is a 
                  rhetorical element of a taxonomic publication, i.e. a 
                  specialized section, where taxon circumscription  
                  takes place."@en ;
    rdfs:comment "Eine taxonomische Abhandlung, oder nur Abhandlung, ist 
                  ein rhetorisches Element eines wissenschaftlichen 
                  taxomischen Artikels, d.h. ein spezialisierter Abschnitt,
                  wo die Umschreibung eines taxonomischen Konzeptes
                  stattfindet."@de ;
    rdfs:comment "Таксономично пояснение или само Пояснение е риторчна част
                  от таксономичната статия, където се случва описанието
                  на дадена таксономична концепция."@bg ;                  
    rdfs:subClassOf deo:DiscourseElement .
@
```



akin to Introduction,
Methods, etc. Thus, we derive the class `trt:Treatment` from
`deo:DiscourseElement`. We model this derivation on the way `deo:Introduction`
is defined.

We also consider Treatment to be an of expression of a theory about a taxon
aka Taxon Concept, sometimes just Taxon. In order to  link Treatment to Taxon
Concept we connect the Journal Article or Book Chapter or whatever


**Remark and example 1.** _How to link treatments to taxonomic concepts?_
Treatments are closely linked to taxonomic concepts (defined later). They are
the expression of the theory that a taxon concept carries. Thus the link
between treatments and taxon concepts is `frbr:realizationOf`. I.e. the
treatment is the realization of the taxon concept and the taxon concept has a
treatment as its realization. Taxon concepts are introduced later in this
document:

```
:treatment
  a doco:Section, trt:Treatment ;
  frbr:realizationOf :taxon-concept .

:taxon-concept
  a dwc:Taxon ;
  frbr:realization :treatment .

```

Note that we type `:treatment` both as `trt:Treatment` (i.e. the rhetorical
element Treatment) and as `doco:Section` as in the cases we look at Treatment
is also a section of the document.

**Remark and example 2.** _How to link treatments to the articles they reside
in?_ Every article is represented in RDF using the
[FaBiO](http://www.sparontologies.net/ontologies/fabio) ontology as
`fabio:JournalArticle`. Key here is that the article is linked to different
sub-article level elements such as treatments (see later) via the use of the
"contains" property in the [Pattern
Ontology](http://www.essepuntato.it/2008/12/pattern).


```
:article
   rdf:type fabio:JournalArticle ;
   skos:prefLabel "10.3897/BDJ.1.e953" ;
   prism:doi "10.3897/BDJ.1.e953" ;
   fabio:hasPublicationYear "2013"^^xsd:gYear ;
   dcterms:title "Casuarinicola australis Taylor, 2010 (Hemiptera: Triozidae),
                  newly recorded from New Zealand"@en-us ;
   po:contains :treatment . 
```



#### Paper Types

**Def. of controlled vocabulary (Paper Types):** Pensoft's journals have some
paper types, which we define herein. First of all, we introduce Paper Types as
a Term Dictionary in the discipline of Bibliography. Then we introduce the
different paper types as Subject Term's in the scheme of Paper Types. See the
SPAR ontologies for more info on this this.

```
<<Paper Types>>=
pensoft:PaperTypes
  a fabio:TermDictionary ;
  rdfs:label "Paper Types"@en ;
  rdfs:comment "A list of paper (article) types published in Pensoft's
                journals"@en ;
  fabio:hasDiscipline dbpedia:Bibliography .
@
```

**Example and remark 3.** We give an example of a paper with only one
taxonomic treatment. These paper types are not part of the Core Ontology but
are imported in the Knowledge Base during the population phase. We also show
how to say that a paper has as its type the aforementioned type.

```
:single-taxon-treatment
  a fabio:SubjectTerm ;
  rdfs:label "Single Taxon Treatment"@en; 
  rdfs:comment "A type of paper with only one taxonomic treatment"@en ;
  skos:inScheme pensoft:PaperTypes .

:paper
  a fabio:JournalArticle ;
  fabio:hasSubjectTerm :single-taxon-treatment .
```

TODO: Extract paper types.

#### Taxon Classification

**Def. of controlled vocabulary (Taxon Classification):** Pensoft, in its
Keywords uses certain taxon names for the classification of its papers. These
taxon names are borrowed from GBIF. Here we define a term dictionary
analogously to paper types:

```
<<Taxon Classification>>=
pensoft:TaxonClassification 
  a fabio:TermDictionary ;
  rdfs:label "Taxonomic Classification"@en ;
  rdfs:comment "A list of taxon names borrowed for GBIF for the 
                classification of papers."@en ;
  fabio:hasDiscipline dbpedia:Taxonomy .
@
```

### Chronological Classification

**Def. of controlled vocabulary (Taxon Classification):**
```
<<Chronological Classification>>=
openbiodiv:ChronologicalClassification
  a fabio:TermDictionary ;
  rdfs:label "Chronological Classification"@en ;
  rdfs:comment "A vocabulary of chronological eras that can be used in
                Pensoft's journals"@en ; 
  fabio:hasDiscipline dbpedia:Paleontology .
@
```

### of the Biological Systematics Domain

In this subsection we introduce  classes and properties which are used to
convey information from the domain of biological systematics.

```
<<Systematics>>=
<<RCC5>>
@
```
#### Taxon Concepts

In a nutshell a taxon concept is a scientific theory about a taxon. In our
data model scientific theories are represented by `frbr:Work`. Here are the
comments on Work from FRBR:

"A distinct intellectual or artistic creation. A work is an abstract entity;
there is no single material object one can point to as the work. We recognize
the work through individual realizations or expressions of the work, but the
work itself exists only in the commonality of content between and among the
various expressions of the work. When we speak of Homer's Iliad as a work, our
point of reference is not a particular recitation or text of the work, but the
intellectual creation that lies behind all the various expressions of the
work."

##### 1. Taxon concepts are linked to their expression

This comment in FRBR means that taxon concepts can have different realizations
(`frbr:Expression`) such as a treatment or a database entry. Linking to
treatments is explained in Remark and example 1 under [Taxonomic Treatment
](#taxonomic-treatment). Here's another example of how to link a taxon concept
to an online database.


```
:gbif2017 a fabio:Database ;
  skos:prefLabel "GBIF Backbone Taxonomy 20170301"@en ; 
  rdfs:comment "A dump of GBIF's backbone taxonomy on 2 Mar 2017."@en ;
  frbr:realizationOf :taxon-concept2 .

:taxon-concept2
  a dwc:Taxon ;
  frbr:realization :gbif2017 .

```

In our understanding of the domain every taxon concepts needs to have at least
one expression.

TODO Is this possible to express this OWL? It would be simpler to express it
in SPARQL.

##### 2. Taxon concepts may be linked to a scientific name

Linnaean names are an attempt to label taxa. In most cases taxon concepts will
be linked to exactly one scientific name

For all practical purposes the semantics of
<http://rs.tdwg.org/dwc/terms/Taxon> are compatible with the notion of a taxon
concepts. Our understanding of taxon concepts is based on [Franz et al.
(2016)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4911943/).
In order to be able to instantiate taxon concepts, we import "Darwin Semantic
Web, version 1.0", where `dwc:Taxon` is defined. 


**Remark and example 1.** Note that 

Taxon concepts are related to one another via simple relationships and
via RCC-5 properties.

#### Simple Taxon Concept Relationships

- subconceptOf (this can be used when you refine a concept, or when 
a higher rank subsumes a lower rank)
- relatedTo (when you have two overlaping but different concepts)
- congruent (when two concepts are exactly the same)

#### RCC-5 Relationships

```
openbiodiv:EQ_INT rdf:type owl:ObjectProperty ;
  rdfs:label "Equals (INT)" ;
  rdfs:comment "= EQ(x,y) Equals (intensional)"@en . 

openbiodiv:PP_INT rdf:type owl:ObjectProperty ;
  rdfs:label "Proper Part (INT)" ;
  rdfs:comment "< PP(x,y) Proper Part of (intensional)"@en .

openbiodiv:iPP_INT rdf:type owl:ObjectProperty ;
  owl:inverseOf openbiodiv:PP_INT ;
  rdfs:label "Inverse Proper Part (INT)" ;
  rdfs:comment "iPP(x, y) Inverse Proper Part (intensional)"@en .

openbiodiv:PO rdf:type owl:ObjectProperty ;
  rdfs:label "Partially Overlaps" ;
  rdfs:comment "o PO(x,y) Partially Overlaps"@en .

openbiodiv:DR rdf:type owl:ObjectProperty ;
    rdfs:label "Disjoint" ;
    rdfs:comment "! DR(x,y) Disjoint from."@en .
```

#### Scientific Name

### of the Ecological Domain

### of General Ideas

#### "preferred label"

The individual entities in OpenBiodiv all have unique identifiers. In addition
to those identifiers, the objects have labels that are there primarily for
human consumption. Labels can be things like the DOI (in the case of an
article), the Latin name of a taxon. This preferred label is encoded with the
property `skos:prefLabel`. Furthermore, an object can have secondary
(alternative) labels such as a different spelling of a scientific name, or a
vernacular name of a taxon. In this case we use `skos:altLabel`.


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




TODO: check for prefix consistency for all imported ontologies.
