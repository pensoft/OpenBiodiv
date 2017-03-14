# OpenBiodiv RDF Guide

This is the Open Biodiversity Knowledge Management System (OBKMS) RDF Guide.
In the rest of this document the discussed knowledge managements system will
also be referred to as OpenBiodiv. The guide is intended to explain to human
users and define for computers the data model of OpenBiodiv and aid users in
generating OpenBiodiv compatible RDF and in creating working SPARQL queries or
other extensions.

This guide is a
[literate programming](https://en.wikipedia.org/wiki/Literate_programming)
document. *Literate programming* is the act of including source code within
documentation. In usual software development practice the reverse holds true.
Thus, the formal description of the data model, i.e. the
[RDF](https://www.w3.org/RDF/) statements that form the ontology are found
within the document  itself and are extracted from it with the program
(`noweb`). `noweb` can be easily obtained for GNU Linux.

## Introduction

**Motivation.** The raison d'être of the OpenBiodiv data model is to enable
the operation of a semantic database as part of OpenBiodiv. The data model
consists of:

1. A formal ontology, called from here on *OpenBiodiv Core Ontology*,
introducing the entities that our knowledge base holds and giving axioms that
restrict the ways in which they can be combined.

2. Natural language descriptions of the meaning of these concepts in our
conceptualization of the world.

3. Examples and recommendations that illustrate and describe the intended
model to human users as the formal ontology necessarily will be more lax than
the intended model.

For a discussion see
[Specification of Conceptualization](https://www.obitko.com/tutorials/ontologies-semantic-web/specification-of-conceptualization.html),
as well as the article by
[Guarino et al. (2009)](http://iaoa.org/isc2012/docs/Guarino2009_What_is_an_Ontology.pdf).

As this is a literate programming document, we take the approach of explaining
the data model to humans, and defining the Core Ontology as we progress with
our explanations.

```
<<Ontology>>=

<<Prefixes>>

openbiodiv:
  rdf:type owl:Ontology ;
  owl:versionInfo "0.2" ;
  rdfs:comment "Open Biodiversity Knowledge Management System Core Ontology" ;
  dc:title "OpenBiodiv Core Ontology" ;
  dc:subject "OpenBiodiv Core Ontology" ;
  rdfs:label "OpenBiodiv Core Ontology" ;
  dc:creator "Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev" ;
  dc:rights "CCBY" .

<<Publishing Domain Model>>
<<Biological Systematics Model>>
<<Vocabulary Taxonomic Statuses>>


@
```

TODO: Authors list needs to be emended.

We've just defined our *root chunk*, `Ontology`. In the `noweb` way of doing
literate programming, we write our source in chunks. Each chunk has a name
that is found between the `@<<` (TODO: not sure how to escape this character)
and `>>` and ends in `@`. Chunks can contain other chunks and thus the writing
of the source code becomes hierarchical and non- linear. In the root chunk,
we've listed other chunks that we'll introduce later and some verbatim code.
In order to create the ontology we use the `notangle` command from `noweb`.

**Command to extract the Core Ontology.**

```
notangle -ROntology RDF_Guide.md > nowebonto.ttl
```

**Examples.** This document also contains some examples.

```
<<Examples>>=

<<eg_metadata>>>
<<eg_treatment>>>
<<eg_contains>>
<<eg_tnu>>

@
```

**Command to build the examples.** 

```
notangle -RExamples RDF_Guide.md > Examples.ttl
```

TODO: check for prefix consistency for all imported ontologies.

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
identifiers and into cross-linking. This will be the subject matter of a later
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

Both ways of looking at the entities are compatible with each other. The
following information should probably go into "OpenBiodiv Extension and
Linking Guide" but for the sake of completeness we will present it here, as
well.

Entity extraction from taxonomic articles can happen in two phases:

1. Conversion of XML elements into RDF triples following the structure of the
XML. In this stage key XML elements are transformed into bibliographic
elements. XML elements denoting sections become `doco:Section`'s, figures
become `doco:Figure`'s, etc. Here no information extraction is taking place
and no additional semantics are added. This step can be completed linearly
without any external lookups.

2. Named entity recognition, coreferencing, and named entity identification.
During this step, non-structural entities are extracted from the informaiton
presented in the structural elements in the form of text or attributes that
have been transformed into properties. The details of how this done are beyond
the scope of this guide but it is important to note that an attempt is made to
coreference - i.e. match multiple bibliographic elements to the same non-
bibliographic entity, if they do in fact refer to the same entity in the sense
of Frege's semiotic triangle. Another attempt is made to properly manage
identifiers. This stage cannot be completed without external look-ups.


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
relationships will be in `minorCamelCase`. URI's of individuals `will-be-hyphenated`.
This seems to generally in accordance with WWW practice.

## RDF Model

### of the Publishing Domain

The publishing domain is described in our model using the Semantic Publishing
and Referencing Ontologies, a.k.a. [SPAR Ontologies](http://www.sparontologies.net/).
We do import several of these ontologies (please consult the paragraph
"Incorporated external ontologies"). Refer to the documentation on the SPAR
Ontologies' site for an exhaustive treatment.

In the rest of this section we describe the modeling of entities in the
publishing domain that are not found in the SPAR ontologies. The central  new
class in OpenBiodiv not found in SPAR is the `trt:Treatment` class, borrowed
from the

[Treatment Ontologies](https://github.com/plazi/TreatmentOntologies).

```
<<Publishing Domain Model>>=

<<Treatment>>
<<Vocabulary of Paper Types>>
<<Vocabulary of Taxon Classification>>
<<Vocabulary of Chronological Classification>>

@
```

#### Article Metadata

The main objects of information extraction and retrieval of OpenBiodiv in the
first stage of its developments are scientific journal articles from the
journals [Biodiversity Data Journal](http://bdj.pensoft.net/) and
[ZooKeys](http://zookeys.pensoft.net/).
We model the bibliographic objects around Journal Article, such as Publisher,
and Journal using SPAR.

**Example (modeling article metadata).**

```
<<eg_metadata>>=

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
  dcterms:title "Aus bus Senderov, 2017, newly recorded from Bulgaria"@en-us .

:pensoft-publishers rdf:type foaf:Agent ;
  skos:prefLabel "Pensoft Publishers" ;
  pro:holdsRoleInTime :pensoft-publishes-bdj . 

:pensoft-publishes-bdj rdf:type pro:RoleInTime ;
  pro:relatesToDocument :biodiversity-data-journal . 

@
```

TODO: keywords

TODO Note: In this example `:biodiversity-data-journal` is non-structural
entity, as it doesn't denote part of the manuscript, but rather something
external, i.e. a journal. This means that creating it, requires of the step of
named entity identification.

#### Taxonomic Treatment

See [Plazi](http://plazi.org/) for a theoretical discussion of Treatment.

**Def. (Treatment):** Taxonomic Treatment, or simply Treatment, is
a rhetorical element of a taxonomic publication:

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

Thus, Treatment is defined akin to Introduction, Methods, etc. from 
[DEO](http://www.sparontologies.net/ontologies/deo/source.html).

**Example (instantiating a treatment).**

```
<<eg_treatment>>=

:treatment
  a doco:Section, trt:Treatment .

@
```

Note that we type `:treatment` both as `trt:Treatment` (i.e. the rhetorical
element Treatment) and as s `doco:Section` because we view this particular
treatment to also be a structural section of the document.

**Linking treatments to the articles they reside in.** Key here is that an
article is linked to different sub-article level elements such as treatments
via the use of the "contains" property in the
[Pattern Ontology](http://www.essepuntato.it/2008/12/pattern).

```
<<eg_contains>>=

:article po:contains :treatment . 

@
```

##### Taxonomic Nomenclature Section

Nomenclature is a special subsection of Treatment where nomenclatural acts are
published. We define it similar to Treatment, but proper modeling entails that
for each Nomenclature there ought to be a Treatment that contains it.

**Def. (Nomenclature):** Nomenclature is a specialized section of a taxonomic
publication, a subsection of Treatment, where nomenclatural acts take place.

```
<<Nomenclature>>=

trt:Nomenclature a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Taxonomic Nomenclature Section"@en ;
  rdfs:comment "A taxonomic nomenclature section, or simply a nomenclature, 
                is a rhetorical element of a taxonomic publication, i.e. a 
                specialized section, where nomenclatural acts are published."@en .


trt:NomenclatureCitationList a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Taxonomic Nomenclature Citation List"@en ;
  rdfs:comment "Inside the taxonomic nomenclature section, we have a list
                of citations."@en .                  

trt:TreatmentTitle a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Treatment Title"@en ;
  rdfs:comment "Inside the taxonomic nomenclature section, we have the treatment title."@en .                  


@
```

**Example (Nomenclature).**

```
<<eg_nomenclature>>=

:nomenclature a Doco:Section, trt:Nomenclature .
:treatment po:contains :nomenclature.

@
```

TODO: All the other subsections of trt:Treatment, Description, etc.

#### Taxonomic Name Usage

In the text of taxonomic articles we find strings like "*Heser stoevi*
Deltschev, sp. n.". We choose to call these strings *taxonomic name usages*
(TNU's) as they refer to published scientific names from the domain of
biological systematics. The taxonomic name usage consists of three parts:

1. One or more words identifying the taxon (these can be Latinized or take the form
of an identifier).

2. The name-and-year of the author(s) of the taxon.

3. Taxonomic name status containing information about the type of the taxonomic
name usage.

In the example, "*Heser stoevi*" is the binomial Latinized species name,
"Deltschev" is the name of the person who described the taxon and "sp. n."
bears taxonomic (and nomenclatural) information indicating that this is a
species new to science.

Modeling-wise, we consider TNU's to be specialized instances of Mention from
the [PROTON Extensions module] (http://ontotext.com/proton/). Furthermore we
link the TNU's to the scientific name they are symbolizing via `pkm:mentions`.

**Def. (Taxonomic Name Usage):** A taxonomic name usage is the mentioning of a
biological taxonomic name in a text.

```
<<Taxonomic Name Usage>>=

:ТaxonоmicNameUsage a owl:Class ;
  rdfs:subClassOf  pext:Mention ;
  rdfs:comment "A string within a document that can be considered a mention of a
                  biological taxonomic name."@en;
  rdfs:label "Taxonomic Name Usage"@en;

@
```

TODO: Need to add proton prefixes to the YAML database `pext`, `ptop`, etc.

**Example (TNU).** In this example we define a TNU, connect it to a
nomenclature section via `po:contains`, use `cnt:chars` to dump the full
string of the usage, and use DwC properties to encode more granular
information in addition to the dump. Note that we do use
`dwciri:taxonomicStatus` to link to named entity from a vocabulary. This step
does require an external lookup (type 2 step). Vocabularies are given in
the (appendix)[#vocabulary-of-taxonomic-name-statuses] of this guide.

```
<<eg_tnu>>=

:tnu a :TaxonomicNameUsage .

:nomenclature po:contains :tnu .

:tnu
  dc:date "2016-08-31"^xsd:date ;
  cnt:chars "Heser stoevi Deltschev sp. n." ;
  dwc:scientificNameAuthorship "Deltschev" ;
  dwc:taxonRank "species" ;
  
  dwc:taxonomicStatus "sp. n." ;
  dwciri:taxonomicStatus :TaxonDiscovery .

@
     
```

**Example (Taxon Concept Label)**

```
<<eg_tnu>>=

:tcl a :TaxonomicNameUsage ;
  cnt:chars "Heser stoevi sec. <https://doi.org/10.3897/BDJ.4.e10095>" .
  dwc:taxonomicStatus "sec <https://doi.org/10.3897/BDJ.4.e10095>" ;
  dwciri:taxonomicStatus :TaxonConceptLabel ;

@

```

### Model of the Biological Systematics Domain

In this subsection we introduce  classes and properties which are used to
convey information from the domain of biological systematics.

```
<<Biological Systematics Model>>=

<<Biological Names>>

@
```

#### Biological Names

In OpenBiodiv, we reify biological names.

In our conceptual view of the world biological names are symbols (Ger.
"Symbol") for real world taxa in the language of the
[semiotic triangle](https://de.wikipedia.org/wiki/Semiotisches_Dreieck).
Biological names play a dual role in our system as they are also references
(Ger. "Begriff") of taxonomic name usages. In this system we model biological
names as separate concepts from the taxon concepts that they may symbolize.

Biological names have been modelled elsewhere such as for example in
(NOMEN)[TODO link to the NOMEN Ontology]. However, NOMEN takes the approach
of using non-human-readable identifiers and only relying on labels to
identify classes of taxonomic names, which we do not espose.

For example, the identifier for class "biological name" is `NOMEN_0000030`. In
our workflow both RDF generation and debugging would be severely hampered by
this convention. That's why we have defined names in OpenBiodiv and mapped
them to their NOMEN equivalents.

**Def. (Biological Name):**

```
<<Biological Names>>=

:BiologicalName rdf:type owl:Class ;
    rdfs:label "biological name"@en ;
    owl:sameAs nomen:NOMEN_0000030 .

:ScientificName rdf:type owl:Class ;
    rdfs:subClassOf :biologicalName ;
    rdfs:label "scientific name"@en ;
    owl:sameAs nomen:NOMEN_0000036 .
    
:VernacularName a owl:Class ;
  rdfs:subClassOf :biologicalName ;
  rdfs:label "vernacular name"@en ;
  ownl:sameAs nomen:NOMEN_0000037 .

@
```

Again, as in the taxonomic statuses example, we do not model scientific names
down to the level of the Codes as NOMEN does. We also use different sets of
properties to define relationships between biological names and for their
data properties.

For the data properties we use DwC terms.

For object properties, have two types of relationships: unidirectional and
bidirectional.

**Def. (Related name):** Related name is an object property that we use in
order to indicate that two biological names are related somehow. This
relationship is purposely vague as to encompass all situations where two
biological names co-occur in a text. Related name is transitive and reflexive.

```
<<Biological Names>>=

:relatedName rdf:type owl:ObjectProperty,
                      owl:TransitiveProperty,
                      owl:ReflexiveProperty ;
            rdfs:label "related biological name"@en ;
            rdfs:domain :BiologicalName ;
            rdfs:range :BiologicalName ;
            rdfs:comment "Related name is a property relationship that
we use in order to indicate that two biological names are related
somehow. This relationship is purposely vague as to encompass all 
situations where two biological names co-occur in a text. Related
name is transitive and reflexive."@en.

@
```

**Def. (Replacement name):** This is a uni-directional property. Its meaning
is that one one biological name links to a different biological name via the
usage of this property, then the object of the triple is the form of the
biological name the use of which is more accurate and should be preferred
given the information that system currently holds. This property is only
defined for scientific names.

```
<<Biological Names>>=

:replacementName rdf:type owl:ObjectProperty ,
                          owl:TransitiveProperty ,
                          owl:ReflexiveProperty ;
                 rdfs:label "replacement scientific name"@en ;
                 rdfs:domain :ScientificName ;
                 rdfs:range :ScientificName ;
                 rdfs:comment "This is a uni-directional property. Its meaning
is that one one biological name links to a different biological name via the
usage of this property, then the object of the triple is the form of the
biological name the use of which is more accurate and should be preferred
given the information that system currently holds. This property is only
defined for scientific names."@en.

@
```

Names in our Knowledge Base follow certain rules:

**Rule 1 for Names:** If a name has never been invalidated by a TNU with
status `:Synonym` or `:Invalid`, or invalidated and then restored by
`:Restored` then it is `:Accepted`. Otherwise it is `:Synonym` or `:Ivalid`.

**Rule 2 for Names:** If a name is mentioned in the title of a nomenclature
section of a treatment with TNU `:Replacement` and if names are being 
invalidated in the nomenclature citation list with `:Synonym` or `:Invalid`,
then the invalidated names are linked to the replacement name via
`:replacementName`.

**Rule 3 for Names:** All names in the nomenclature section are related.

**Rule 4 for Names:** If the last usage of a name has the mark `:Uncertain`,
then the name is `:Uncertain`.

**Rule 5 for Names:** If the latest TNU of a name in a treatment title,
has the `:New` status, then the name is marked as `:New`. Note, this can
be combined with other statuses. If the name has more than one treatment,
then the status `:New` is revoked.

TODO: Can I express this in OWL or SPARQL?

**Example usage of biological names.** We go back to the example of 
*Heser stoevi*. The meaning of the date property here is to indicate
when was the taxonomic status assumed.

```
<<eg_biological_names>> = 

:tnu pkm:mentions :heser-stovi-deltschev .

:heser-stoevi-deltschev a :ScientificName ;
                    dwc:species "stoevi" ;
                    dwc:genus "Heser" ;
                    dwc:taxonRank "species" ;
                    dwciri:taxonomicStatus <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
                    dc:date "2016-08-31"^xsd:date .

```

Let's take for example,
the paper <http://bdj.pensoft.net/articles.php?id=8030&instance_id=2809105>.
From it, we can say:

```
<<eg_biological_names>> = 

:nomenclature-bdje8030 a trt:Nomenclature ;
  po:contains :treatment-title-bdje8030, :cit-list-bdje8030 .

:treatment-title-bdje8030 a trt:TreatmentTitle ;
  po:contains :tnu1 .

:cit-list-bdje8030 a trt:NomenclatureCitationList ;
  po:contains :tnu2 .

:tnu1 a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^xsd:date ;
  cnt:chars "Harmonia manillana (Mulsant, 1866)" .

:tnu2 a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^xsd:date ;
  cnt:chars "Leis papuensis var. suffusa Crotch 1874 121 (Lectotype, UCCC). Korschefsky 1932 : 275.- Gordon 1987 : 14 (lectotype designation). Syn. nov." ;
  dwc:taxonomicStatus "var. suffusa Crotch 1874 121 (Lectotype, UCCC). Korschefsky 1932 : 275.- Gordon 1987 : 14 (lectotype designation). Syn. nov." ;
  dwciri:taxonomicStatus :Synonym .

:harmonia-manillana-mulsant-1866 a :ScientificName ;
  dwc:species "manillana" ;
  dwc:genus "Harmonia" ;
  dwc:taxonRank "species" ;
  dwc:scientificNameAuthorship "(Mulsant, 1866)" ;
  dc:date "2016-08-16"^xsd:date ; 
  dwc:taxonomicStatus :Accepted ;
  :relatedName :leis-papuensis .

:leis-papuensis a :ScientificName ;
  dwc:species "papuensis" ;
  dwc:genus "Leis" ;
  dwc:taxonRank "species" ;
  dc:date "2016-08-16"^xsd:date ; 
  dwciri:taxonomicStatus :Synonym ;
  :replacementName :harmonia-manillana-mulsant-1866 ;
  :relatedName :harmonia-manillana-mulsant-1866 .

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

```
:TaxonConcept rdf:type owl:Class;
  rdfs:subClassOf [ rdf:type owl:Restriction ;
                    owl:onProperty frbr:realization ;
                    owl:someValuesFrom frbr:Expression ] ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty frbr:realization ;
                    owl:minCardinality "1" ] .
```

all individuals of the taxonconcept class ha

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





## Apendicies

### Vocabulary of Taxonomic Statuses

Taxonomic name usages (TNU's) may be accompanied by strings such as "new.
comb.", "new syn.", "new record for Cuba", and many others. These "extensions"
are called in our model taxonomic statuses and have taxonomic as well
nomenclatural meaning. For example, if we are describing a new species for
science, we may write "n. sp." after the species name. This particular example
is also a nomenclatural act in the sense of the Codes of zoological or
botanical nomenclature. Taxonomic statuses can be applied to TNU's and to
scientific names.

Not all statuses are necessarily nomenclatural in nature. Sometimes the status
is more of a note to the reader and conveys taxonomic rather than
nomenclatural information. E.g. when a previously known species is recorded in
a new location.

Here we take the road of modeling statuses from the bottom-up, i.e. based on
their actual use in three of the most successful journals in biological
systematics - ZooKeys, Biodiversity Data Journal, and PhytoKeys. We have
analyzed about 4,000 articles from these journals and came up with a
vocabulary of statuses described below. The concepts in this vocabulary are
broad concepts and encompass both specific cases of botanical or zoological
nomenclature as well as purely taxonomic and informative use. We believe these
concepts to be adequately granular for the purposes of reasoning in
OpenBiodiv (see the (Rules)[#biological-names]. The main objective we want to achieve is to encode information
about the preferred name to use for a given taxonomic concept lineage.

See for a similar attempt <http://rs.gbif.org/vocabulary/gbif/taxonomic_status.xml>.

```
<<Vocabulary Taxonomic Statuses>>=

:TaxonomicNameStatus rdf:type owl:Class ;
  rdfs:subClassOf [ rdf:type owl:Restriction ;
                    owl:onProperty <http://www.w3.org/2004/02/skos/core#inScheme> ;
                    owl:someValuesFrom :TaxonomicStatusVocabulary ] ;
  rdfs:label "Taxonomic Name Status"@en ;
  rdfs:comment "The status following a taxonomic name usage in a taxonomic
                manuscript, i.e. 'n. sp.',
                                 'comb. new',
                                 'sec. Franz (2017)', etc"@en .

:TaxonomicNameStatusVocabulary rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :Taxonomic Status] ;
  rdfs:label "OpenBiodiv Vocabulary of Taxonomic Name Statuses"@en ;
  fabio:hasDiscipline dbpedia:Taxonomy_(biology) .

  <<Taxonomic Uncertainty>>
  <<Taxon Discovery>>
  <<Replacement Name>>
  <<Synonym>>
  <<Restored Name>>
  <<Conserved Name>>
  <<Type Species Designation>>
  <<Record>>
  <<Taxon Concept Label>>

@
```

#### Taxonomic Uncertainty

Sometimes taxonomic name usages are accompanied by a status indicating that
the placement of the name in the taxonomy is uncertain.

**Def. (Taxonomic Uncertainty)** This status is used after a name when
there is some sort of ambiguity related to the name.

```
<<Taxonomic Uncertainty>>=

:TaxonomicUncertaitanty a :TaxonomicStatus ;
  rdfs:label "Taxonomic Uncertainty"@en ;
  rdfs:comment "This term indicates when applied to a taxonomic name
                 that there is some uncertainty about the name:
                either in the placement of the name in the hierarchy
                (e.g. incertae sedis), or in the description of the name
                (e.g. nomen dubium)."@en .
@

```

Here're some ways in which taxonomic uncertainty can be abbreivated:

-  incertae sedis
-  Incertae Sedis
-  indet.
-  ? indeterminate

#### Taxon Discovery


When a taxon is believed to have been discovered, a new taxonomic name is
coined. This encompasses: new species, new genus, new family,  etc.

**Def. (Taxon Discovery):**

```
<<Taxon Discovery>>=

:TaxonomicDiscovery a :TaxonomicStatus ;
  rdfs:label "Taxon Discovery"@en ;
  rdfs:comment "This term when applied to a taxonomic name indicates
                that this name denotes a taxon that is being described in
                the present context. E.g.:
                n. sp., gen. nov., n. trib., etc."@en .

@
```

- sp. n.
- subsp. n.
- subsp. nov.
- ssp. n.
- ssp.n.
- subtrib. n.
- subtr. n.
- sp. n.
- gen. et sp. n.
- gen et sp. nov.
- gen. n. and sp. n.
- gen. n., comb. n.
- gen. n., sp. n.
- n. sp.
- p. n.
- spec. nov.
- sp .n.
- sp. n.
- sp.n.
- sp. nov.
- sp.nov.
- sp. n., variety
- subgen. n.
- subg. n.
- subg. nov.
- en. n.
- gen. et sp. n.
- gen et sp. nov.
- gen n.
- gen. n.
- gen. n. and sp. n.
- gen nov.
- gen. nov.
- gen. n., sp. n.
- subfam. n.
- var. nov.
- fam. n.
- new clade
- hybr. nov.
- sect. nov.

#### Replacement Name

Often an old name is changed to a new one for a variety of reasons. This means
that probably parts of the underlying taxon concept circumscription is
carried over to the new name and there is an old name that is being
invalidated. Algorithms have to be written to locate the old name.
Situations include

- changed rank (e.g.: stat. nov.)
- new spelling (e.g.: nomen novum)
- placement in a new genus (e.g.: new comb.)
- 

**Def. (Replacement Name):**

```
<<Replacement Name>>=

:ReplacementName a :TaxonomicStatus ;
  rdfs:label "Replacement Name"@en ;
  rdfs:comment "This term when applied to a taxonomic name indicates
                that the name it is being applied to is an updated version
                of a different name. This update may come about through
                changes in rank (stat. n.) when the endings change (e.g.
                -ini -> -idae), through changes in genus placement
                (new comb.), through updates needed purely for nomenclatural
                reasons such as to avoid homonymy or correct grammatical
                or spelling mistakes (nomen nov.), or anything else."@en 

@
```

- comb. et stat. nov.
- comb. et. stat. nov.
- (comb. n.)
- comb. n.
- comb.n.
- comb. n. (misplaced)
- comb. nov.
- comb. n., re-instated
- comb. n., stat. rev.
- comb. r.
- comb. rest.
- comb. restored
- comb. rev.
- comb. r., stat. r. & stat. n.
- comb. & stat. nov.
- gen. n., comb. n.
- new combination
- new comb., new subfamily assignment
- resurrected combination
- revalidated, comb. n.
- stat. & comb. nov.
- stat. prom. & comb. n.
- comb. et stat. nov.
- comb. et. stat. nov.
- comb. n., stat. rev.
- comb. r., stat. r. & stat. n.
- comb. & stat. nov.
- new comb., new subfamily assignment
- new familial and subfamilial assignment
- new family assignment
- new rank
- new status
- NEW STATUS
- new subfamilial assignment
- new subfamily assignment
- new subgeneric assignment
- nom. n. et stat. rev.
- nom. n. & stat. rev.
- revised status, lectotype designation
- rev. placement
- rev. stat.
- rev. status
- stat. & comb. nov.
- tat. n.
- stat. n.: invalid genus
- stat. nov.
- stat. n.: restored name
- stat. prom.
- stat. prom. & comb. n.
- stat. rev., stat. n.
- emended
- (name emended by Wüster et al. 2001)
- nomen novum
- nomen revivisco
- nom. n.
- nom. n. et stat. rev.
- nom. nov.
- nom. n. & stat. rev.
- replacement name

#### Synonym

```
<<Synonym>>=
:Synonym a :TaxonomicStatus .
@
```

#### Restored Name

Sometimes a name that has been changed, synonimized or otherwise marked as
invalid can be revalidated.

```
<<Restored Name>>=
:AcceptedName a :TaxonomicStatus .
@
```

#### Conserved Name

```
:ConservedName a :TaxonomicStatus .
```

  - nom. cons.
  - nomen protectum
  - nom. et orth. cons.


#### Type Species Designation

```
:TypeSpeciesDesignation a :TaxonomicStatus .
```

#### Type Specimen Designation

#### New Record

Sometimes a name is used to indicate that some species has been described
for the first time in a given location.

```
:Record a :TaxonomicStatus .
```

#### Taxon Concept Label

Taxonomic concept label is a taxonomic name usage accompanied by a status
referring to the scientific work that circumscribes the mentioned taxon.
Thus taxonomic concept labels can be linked directly to Taxon Concepts and
not just to Taxonomic Names.

```
:TaxonConceptLabel a :TaxonomicStatus ;
                refering a taxonomic concept either by the usage 'sensu',
                'sec' or by the usage some other unique form of identification."@en .

@
```

### Vocabulary of Paper Types

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

### Vocabulary of Taxon Classification

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

### Vocabulary of Chronological Classification

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
