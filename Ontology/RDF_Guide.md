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

**Note on capitalization, cases, etc.** Our ontology strives be a formal
specification of a conceptualization. In our mental model we have some
concepts of some things. When we talk about these concepts in the abstract, we
will make use of Capitalization. For example, we say Thing for the top-level
concept and we say Treatment when we refer to the concept (introduced later)
of a taxon circumscription. We also have concepts for relations (in our
conceptualization only binary relations are allowed). To denote these
relations in the abstract we use verbal phrases and we might or might not use
quotes (we will use quotes only if adds to the clarity of exposion). For
example, Treatment is a Thing as opposed to Treatment "is a" Thing. We also
have individual instances of these concepts. To refer to those we might use
improper or proper nouns or phrases whereever appropriate. For example "the
treatment on page 5," or "a treatment," or "John".

When we formally define a concept in OWL, i.e. issue an URI to it, we shall
refer to the URI, as we refer to all URI's in the text with `typewriter font`.
URI's of classes and vocabularies will be in `CamelCaseWithStartingCaps`.
URI's of relationships will be in `thisKindOfCamelCase`. URI's of individuals
`will-be-hyphenated`. This seems to generally in accordance with WWW practice.

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

#### Taxonomic Treatment

See [Plazi](http://plazi.org/) for an explanation of what a treatment is in
the taxonomic sense of the word.

**Def. (Taxonomic Treatment):** In OpenBiodiv/OBKMS, we consider Taxonomic
Treatment, or simply Treatment, to be a rhetorical element of a taxonomic
publication akin to Introduction, Methods, etc. Thus, we derive the class
`trt:Treatment` from `deo:DiscourseElement`. We also consider Treatment to be
an of expression of a theory about a taxon. That's why we also derive
`trt:Treamtent` from `frbr:Expression`.

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
    rdfs:subClassOf deo:DiscourseElement , frbr:Expression .
@
```

**Remark and example 1** (linking treatments to taxonomic concepts): Treatments
are closely linked to taxonomic concepts (defined later). They are the
expression of the theory that a taxon concept carries. Thus the link between
treatments and taxon concepts is `frbr:realizationOf`. I.e. the treatment is
the realization of the taxon concept and the taxon concept has a treatment as
its realization. Taxon concepts are introduced later in this document:

```
:treatment
  a doco:Section, trt:Treatment ;
  frbr:realizationOf :taxon-concept .

:taxon-concept
  a dwc:Taxon ;
  frbr:hasRealization :treatment .

```

Note that we type `:treatment` both as `trt:Treatment` (i.e. the rhetorical
element Treatment) and as `doco:Section` as in the cases we look at Treatment
is also a section of the document.

**Remark and example 2** (linking treatments to the articles they reside in):
Every article is represented in RDF using the
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
   dcterms:title "Casuarinicola australis Taylor, 2010 (Hemiptera: Triozidae), newly recorded from New Zealand"@en-us ;
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

**Example and remark:** We give an example of a paper with only one taxonomic
treatment. These paper types are not part of the Core Ontology but are
imported in the Knowledge Base during the population phase. We also show how
to say that a paper has as its type the aforementioned type.

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

### of the Taxonomic Domain

#### Taxon Concept

#### Scientific Name

### of the Ecological Domain

### of General Ideas

#### "preferred label"

The individual entities in OpenBiodiv/OBKMS all have unique identifiers (in
the `pensoft:` and in other namespaces). In addition to those identifiers, the
objects have labels that are there primarily for human consumption. Labels can
be things like the DOI (in the case of an article), the Latin name of a taxon.
This preferred label is encoded with the property `skos:prefLabel`.
Furthermore, an object can have secondary (alternative) labels such as a
different spelling of a scientific name, or a vernacular name of a taxon. In
this case we use `skos:altLabel`.



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
<<Paper Types>>
<<Taxon Classification>>
<<Chronological Classification>>
@
```