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
found between the `@<<` and `>>` and ends in `@`. Chunks can contain other
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

#### Article, Journal, Publisher

The main objects of information extraction and retrieval of OpenBiodiv in the
first stage of its developments are scientific journal articles from the
journals [Biodiversity Data Journal](http://bdj.pensoft.net/) and [ZooKeys]
(http://zookeys.pensoft.net/). We model the bibliographic objects around
Journal Article, such as Publisher, and Journal using SPAR.

**Example 1 (modeling Journal Article).**

```
<<eg1>>=
:pensoft-publishers rdf:type foaf:Agent ;
  skos:prefLabel "Pensoft Publishers" ;
  pro:holdsRoleInTime :pensoft-publishes-bdj . 

:pensoft-publishes-bdj rdf:type pro:RoleInTime ;
  pro:relatesToDocument :biodiversity-data-journal . 

:biodiversity-data-journal rdf:type fabio:Journal ;
  skos:prefLabel "Biodiversity Data Journal" ;
  skos:altLabel  "BDJ" ;
  fabio:issn     "1314-2836" ;
  fabio:eIssn    "1314-2828" ;
  dcterms:publisher "Pensoft Publishers" ;
  frbr:hasPart :article . 

:article a fabio:JournalArticle ;
  skos:prefLabel "10.0000/BDJ.0.e000" ;
  prism:doi "10.0000/BDJ.0.e000" ;
  fabio:hasPublicationYear "2017"^^xsd:gYear ;
  dcterms:title "Aus bus Senderov, 2017, newly recorded from Bulgaria"@en-us ;
  po:contains :treatment .
@
```

#### Treatment

See [Plazi](http://plazi.org/) for a theoretical discussion of Treatment.

**Def. 2 (Treatment):** *Taxonomic Treatment, or simply Treatment, is
a rhetorical element of a taxonomic publication:*

```
<<Treatment>>=
:Treatment a owl:Class ;
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

Thus, Treatment is defined akin to Introduction, Methods, etc. from [DEO]
(http://www.sparontologies.net/ontologies/deo/source.html).

**Example 3 (instantiating a treatment).**

```
<<eg3>>=
:treatment
  a doco:Section, :Treatment .
@
```

Note that we type `:treatment` both as `trt:Treatment` (i.e. the rhetorical
element Treatment) and as `doco:Section` because we view this particular 
treatment to also be a structural section of the document.

**Remark and example 3 (linking treatments to the articles they reside in).**
Key here is that an article is linked to different sub-article level elements
such as treatments via the use of the "contains" property in the [Pattern
Ontology](http://www.essepuntato.it/2008/12/pattern).

```
<<eg3-2>>=
:article
   po:contains :treatment . 
@
```

##### Nomenclature

The nomenclature is a special subsection of treatment where nomenclatural acts
are published. We define it similar to Treatment, but proper modeling entails
that for each Nomenclature section there ought to be a Treatment that contains
it.

**Def. 4 (Nomenclature):** *Nomenclature is a specialized section of a
taxonomic publication, usually a subsection of Treatment, where nomenclatural
acts take place.*

```
<<Nomenclature>>=
:Nomenclature a owl:Class ;
  rdfs:label "Taxonomic Nomenclature Section"@en ;
  rdfs:comment "A taxonomic nomenclature section, or simply a nomenclature, 
                  is a rhetorical element of a taxonomic publication, i.e. a 
                  specialized section, where nomenclatural acts are published."@en ;
    
  rdfs:subClassOf deo:DiscourseElement .
@
```

**Example 5: contecting a nomenclatural section to a treatment section.**

```
<<eg5>>=
:nomenclature a Doco:Section, :Nomenclature .
:treatment po:contains :nomenclature.
@
```

#### Taxonomic Name Usage

In the text of taxonomic articles we find strings like "*Aus bus*". We call
these strings *taxonomic name usages* as they refer to published scientific
names from the domain of biological systematics. Semantically, we consider
these to be specialized instances of Mention from the [PROTON Extensions
module] (http://ontotext.com/proton/).

Furthermore, taxonomic name usages may be accompanied by strings such as "new.
comb.", "new syn." and so on. These taxon statuses have taxonomic or 
nomenclatural meaning and further specialize the usage. For example, if a
taxonomic name is used for the first time - e.g. when for example we are 
describing a new species for science - then we write "n. sp." after the 
species time. This is also a nomenclatural act in the sense of the Codes of
zoological or botanical nomenclature.

Not all taxon statuses necessarily are government by the codes. Sometimes the
taxon status is more of a note to the reader and conveys taxonomic rather than
nomenclatural information. E.g. when a previously known species is recorded in
a new location.

Here we take the road of modeling taxonomic name usages from the bottom-up,
i.e. based on their actual use in three of the most successful journals in
biological systematics - ZooKeys, Biodiversity Data Journal, and PhytoKeys. We
have analyzed about 4,000 articles from these journals and came up with the
concepts below. The concepts below are broad concepts and encompass both
specific cases of botanical or zoological nomenclature as well as purely
taxonomic and informative use. More specific code-based concepts can be 
derived from our usage-based concepts.

**Def. 6 (Taxonomic Name Usage):** *A taxonomic name usage is the mentioning
of a biological taxonomic name in a text.*

```
<<Taxonomic Name Usage>>=

top:Entity rdf:type owl:Class ;
            rdfs:comment "Any sort of an entity of interest, usually something existing, happening, or purely abstract. Entities may have several - more than one - names or aliases."@en ;
            rdfs:label "Entity"@en .

ptop:Object rdf:type owl:Class ;
            rdfs:subClassOf ptop:Entity ;
            rdfs:comment "Objects are entities that could be claimed to exist - in some sense of existence. An object can play a certain role in some happenings. Objects could be substantially real - as the Buckingham Palace or a hardcopy book - or substantially imperceptible - for instance, an electronic document that exists only virtually, one cannot touch it."@en ;
            rdfs:label "Object"@en .

ptop:Statement rdf:type owl:Class ;
               rdfs:subClassOf ptop:Object ;
               rdfs:comment "A message that is stated or declared; a communication (oral or written), setting forth particulars or facts, etc; \"according to his statement he was in London on that day\". WordNet 1.7.1"@en ;
               rdfs:label "Statement"@en .

ptop:InformationResource rdf:type owl:Class ;
                         rdfs:subClassOf ptop:Statement ;
                         rdfs:comment "InformationResource denotes an information resource with identity, as defined in Dublin Core (DC2003ISO). InformationResource is considered any communication or message that is delivered or produced, taking into account the specific intention of its originator, and also the supposition (and anticipation) for a particular audience or counter-agent in the process of communication (i.e. passive or active feed-back)."@en ;
                         rdfs:label "Information Resource"@en .

pext:Mention rdf:type owl:Class ;
             rdfs:subClassOf ptop:InformationResource ;
             rdfs:comment "An area of a document that can be considered a mention of something."@en ;
             rdfs:label "Section" .

:ТaxonоmicNameUsage a owl:Class ;
  rdfs:subClassOf  pext:Mention ;
  rdfs:comment "A string within a document that can be considered a mention of a
                  biological taxonomic name."@en;
  rdfs:label "Taxonomic Name Usage"@en;

@
```

**Example 7.**
Taxonomic name usage:
```
<<eg7>>=
:taxonomic-name-usage a :TaxonomicNameUsage ;
  cnt:chars "Aus bus" .

:taxonomic-concept-label a :TaxonomicConceptLabel ;
  cnt:chars "Aus bus sec Senderov (2017)"

:treatment po:contains :taxonomic-name-usage .
@
```

Now we describe more specific taxonomic name usages.

##### Taxonomic Concept Label

Taxonomic concept label is a taxonomic name usage accompanied by a status
referring to the scientific work that circumscribes the mentioned taxon.
Thus taxonomic concept labels can be linked directly to Taxon Concepts and
not just to Taxonomic Names.

**Def.**

```
<<Taxonomic Concept Label>>=

:TaxonomicConceptLabel a owl:Class ;
  rdfs:subClassOf :TaxonomicName ;
  rdfs:comment "A string that can be unambiguously unambiguously resolved as
                refering a taxonomic concept either by the usage 'sensu',
                'sec' or by the usage some other unique form of identification."@en .

@
```

##### Uncertain Placement

Sometimes taxonomic name usages are accompanied by a status indicating that
the placement of the name in the taxonomy is uncertain.

**Def.**

```
<<Uncertain Placement>>=

:UncertainPlacement a owl:Class ;
  rdfs:subClassOf :TaxonomicNameUsage ;
  rdfs:comment "Sometimes taxonomic name usages are accompanied by a status indicating that
                the placement of the name in the taxonomy is uncertain.
                E.g.: 'incertae sedis'"@en .

@

```

##### Taxon Discovery

When a taxon is believed to have been discovered, a new taxonomic name is
coined. This encompasses: new species, new genus, new family,  etc.

```
<<New Taxonomic Name>>=

:NewTaxon a owl:Class ;
  rdfs:subClassOf :TaxonomicNameUsage ;
  rdfs:comment "A class to denote the different types of situations where
                a new taxon is discovered"@en .


:NewSpecies a owl:Class ;
  rdfs:subClassOf :NewTaxon ;
  rdfs:comment "E.g.: sp. n."@en .

:NewSubspecies a owl:Class ;
  rdfs:subClassOf :NewSpecies ;
  rdfs:comment "E.g.: subsp. n."@en .


@

```

##### Changed Name

Often an old name is changed to a new one for a variety of reasons. This means
that probably parts of the underlying taxon concept circumscription is
carried over to the new name and there is an old name that is being
invalidated. Algorithms have to be written to locate the old name.
Situations include

- changed rank (e.g.: stat. nov.)
- new spelling (e.g.: nomen novum)
- placement in a new genus (e.g.: new comb.)
- 

##### Extinct Species

Sometimes in taxonomic articles there will be a status indicating the
taxonomic name being used refers to a fossilized or extinct species.


##### Invalidated Name


Often a name has problems and it should not be used any more. It can be
the old variant of a changed name, a misspelling, insufficiently described name, synonimized or otherwise invalidated:



- nomen dubium
- nomen inquirendum
- nom. inval.
- syn. nov.

##### Revalidated Name 

Sometimes a name that has been changed, synonimized or otherwise marked as
invalid can be revalidated.

- genus bona
- nom rest.
- comb. rev.

##### Conserved Name

  - nom. cons.
  - nomen protectum
  - nom. et orth. cons.

##### Type designation

Sometimes a name is used to designate a type specimen or a type species.

##### Record

Sometimes a name is used to indicate that some species has been described
for the first time in a given location.

#### Paper Types

**Def. 8 of controlled vocabulary (Paper Types):** Pensoft's journals have some
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

**Example 9.** We give an example of a paper with only one
taxonomic treatment. These paper types are not part of the Core Ontology but
are imported in the Knowledge Base during the population phase. We also show
how to say that a paper has as its type the aforementioned type.

```
<<eg9>>=
:single-taxon-treatment
  a fabio:SubjectTerm ;
  rdfs:label "Single Taxon Treatment"@en; 
  rdfs:comment "A type of paper with only one taxonomic treatment"@en ;
  skos:inScheme pensoft:PaperTypes .

:paper
  a fabio:JournalArticle ;
  fabio:hasSubjectTerm :single-taxon-treatment .
@
```

TODO: Extract paper types.

#### Taxon Classification

**Def. 10 of controlled vocabulary (Taxon Classification):** Pensoft, in its
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

**Def. 11 of controlled vocabulary (Taxon Classification):**
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

#### Taxonomic Names

In our conceptual view of the world taxonomic names are symbols (Symbol) for
real world taxa in the language of the [semiotic triangle]
(https://de.wikipedia.org/wiki/Semiotisches_Dreieck). Taxonomic names play a
dual role in our system as they are also references (Begriff) of taxonomic
name usages.

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

Taxon concepts have a few defining characteristics:

1. They may be linked to a scientific name (e.g. **Aus bus**) that acts as a

1. They are linked to an article, book chapter, database or any other form
of expression realizing the taxon concepts.

**Remark and example 12 (linking treatments to taxon concepts).**  We view
Treatment to be an expression of a theory about a taxon. Therefore, we may
establish a link between the significant bibliographic unit (be it Journal 
Article, Book Chapter, or any other Expression) containing the treatment and
the taxon concept, whose realization the treatment is.


This comment in FRBR means that taxon concepts can have different realizations
(`frbr:Expression`) such as a treatment or a database entry. Linking to
treatments is explained in Remark and example 1 under [Taxonomic Treatment
](#taxonomic-treatment). Here's another example of how to link a taxon concept
to an online database.


```
<<eg12>>=

:gbif2017 a fabio:Database ;
  skos:prefLabel "GBIF Backbone Taxonomy 20170301"@en ; 
  rdfs:comment "A dump of GBIF's backbone taxonomy on 2 Mar 2017."@en ;
  frbr:realizationOf :taxon-concept2 .

:taxon-concept2
  a dwc:Taxon ;
  frbr:realization :gbif2017 .

@
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


**Remark and example 13.** Note that 

Taxon concepts are related to one another via simple relationships and
via RCC-5 properties.

#### Simple Taxon Concept Relationships

- is_a (this can be used when you refine a concept, or when 
a higher rank subsumes a lower rank)
- relatedTo (when you have two overlaping but different concepts)
- congruent (when two concepts are exactly the same)

#### RCC-5 Relationships

Complex RCC 5 relationships will be modeled as separate entities.

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


## Build the examples

```
<<Examples>>=
<<eg1>>>
<<eg3>>>
<<eg3-2>>
<<eg5>>>
<<eg9>>>
<<eg12>>
@
```

```
notangle -RExamples RDF_Guide.md > Examples.ttl
```

TODO: check for prefix consistency for all imported ontologies.
