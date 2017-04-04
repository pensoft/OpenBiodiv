# OpenBiodiv RDF Guide

This is the Open Biodiversity Knowledge Management System (OpenBiodiv,
formerly known as OBKMS) RDF Guide. The guide is intended to explain to humans
and to define for computers the data model of OpenBiodiv and aid its users in
generating OpenBiodiv-compatible RDF and in creating useful SPARQL queries or
other useful extensions.

This guide is a [literate
programming](https://en.wikipedia.org/wiki/Literate_programming) document.
Literate programming is the act of including source code within documentation.
In usual software development practice the reverse holds true. By virtual of
this programming paradigm, in this document the formal description of the data
model, i.e. the [RDF](https://www.w3.org/RDF/) statements that form the
ontology and the vocabularies, are found within the document itself and are
extracted from it with the program `noweb`. `noweb` can be easily obtained for
GNU Linux.

## Introduction

**Motivation.** The raison d'être of the OpenBiodiv Data Model is to enable
the operation of a semantic database as part of OpenBiodiv. The data model
consists of:

1. A formal computer ontology expressed as RDF, called from here on OpenBiodiv
Ontology, introducing the entities that our knowledge base holds and giving
axioms that restrict the ways in which they can be combined.

2. Formal vocabularies specified in RDF for particular application areas.

2. Natural language descriptions of the meaning (semantics) of the concepts
from (1) and (2) in our conceptualization of the universe of discourse.

3. Examples and recommendations that illustrate and describe the intended
model to human users as the formal ontology necessarily will be more lax than
the intended model.

Viewing the data model from another angle it

(a) describes a view of the universe of discourse (biodiversity information),
which we call conceptualization, and

(b) introduces a formal way to store biodiversity information in a database.

We do not believe other data providers ought to use the same formal way to
store biodiversity information in their databases, as they might be using a
different database application, or even paradigm. However, we do believe that
should information exchange between OpenBiodiv and these other data providers
occur, biodiversity information ought to at least follow the same conceptual
model presented herein.

For a discussion see
[Specification of Conceptualization](https://www.obitko.com/tutorials/ontologies-semantic-web/specification-of-conceptualization.html), as well as the article by
[Guarino et al. (2009)](http://iaoa.org/isc2012/docs/Guarino2009_What_is_an_Ontology.pdf).

**Def. (OpenBiodiv Ontology):** In the following code-chunk that will be
extracted by `notangle` (you can use the `Makefile` for this purpose), the
top-level structure of the ontology is defined:

```
<<OpenBiodiv Ontology>>=

<<Prefixes>>
<<Ontology Metadata>>
<<Model of the Publishing Domain>>
<<Model of Biological Systematics>>
<<Vocabulary of Taxonomic Statuses>>
<<Borrowed Parts from External Ontology>>
@
```

**Def. (Ontology Metadata):**

```
<<Ontology Metadata>>=

: rdf:type owl:Ontology ;
  owl:versionInfo "0.2" ;
  rdfs:comment "Open Biodiversity Knowledge Management System Core Ontology" ;
  dc:title "OpenBiodiv Core Ontology" ;
  dc:subject "OpenBiodiv Core Ontology" ;
  rdfs:label "OpenBiodiv Core Ontology" ;
  dc:creator "Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev" ;
  dc:rights "CCBY" ;
  owl:imports <http://phylodiversity.net/dsw/dsw.rdf> .
@
```

TODO: Authors list needs to be emended.

**Note:** We've just defined our *root chunk*, `Ontology`. In the `noweb` way
of doing literate programming, we write our source in chunks. Each chunk has a
name that is found between the `@<<` (TODO: not sure how to escape this
character) and `>>` and ends in `@`. Chunks can contain other chunks and thus
the writing of the source code becomes hierarchical and non-linear. In the
root chunk, we've listed other chunks that we'll introduce later and some
verbatim code. In order to create the ontology we use the `notangle` command
from `noweb`.

**Command to extract the Core Ontology.**

```
notangle -R"OpenBiodiv Ontology" RDF_Guide.md > OpenbBodiv.ttl
```

**Examples.** This document also contains some examples.

```
<<Examples>>=

# These are the examples for the OpenBiodiv data model.
@
```

**Command to build the examples.** 

```
notangle -RExamples RDF_Guide.md > Examples.ttl
```

TODO: check for prefix consistency for all imported ontologies.


**Incorporated external ontologies.** Our data model is a natural extension of
existing data models. Therefore, we incorporate several external ontologies or
parts of existing ontologies into ours. We try to include these ontologies via
`owl:imports`. Where a URL does not resolve, or we want to import only a specific
subset of an ontology or a specific version, we directly introduce the needed
RDF into our model in the code-chunk `Borrowed Parts from External Ontologies`.
In addition to that we've downloaded the RDF for everything that we've borrowed
in the `imports` sub-subdirectory in case the URL's become unavailable in the
future. There is a catalog of this directory under
[Catalog of imported ontologies](imports/Catalog.md), which is, however,
still a work in progress.

**Prefixes.** In OpenBiodiv prefixes are stored in a YAML configuration file
called

[`prefix_db.yml`](../R/obkms/inst/prefix_db.yml)

The following Turtle code can be extracted from the prefix database with
`obkms::prefix_ttl()` command:

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
@prefix : <http://openbiodiv.net/> .
@
```
TODO: add base prefix to YAML database


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

### The Publishing Domain

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

<<Changes to SPAR>>
<<Treatment>>
<<Taxonomic Name Usage>>

@
```

#### Changes to SPAR

`po:contains` is a transitive property.

```
<<Changes to SPAR>>=

po:contains rdf:type owl:TransitiveProperty ;
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
<<Examples>>=

:biodiversity-data-journal rdf:type fabio:Journal ;
  skos:prefLabel "Biodiversity Data Journal" ;
  skos:altLabel  "BDJ" ;
  fabio:issn     "1314-2836" ;
  fabio:eIssn    "1314-2828" ;
  dcterms:publisher "Pensoft Publishers" ;
  frbr:hasPart :article . 

<http://dx.doi.org/10.3897/BDJ.4.e10095> a fabio:JournalArticle ;
  skos:prefLabel "10.3897/BDJ.4.e10095" ;
  prism:doi "10.3897/BDJ.4.e10095" ;
  fabio:hasPublicationYear "2016"^^xsd:gYear ;
  dcterms:title "A new spider species, Heser stoevi sp. nov., from Turkmenistan (Araneae: Gnaphosidae)"@en-us .

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
<<Examples>>=

:heser-stoevi-treatment
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
<<Examples>>=

:heser-stoevi-article po:contains :heser-stoevi-treatment . 
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

trt:NomenclatureHeading a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Treatment Title"@en ;
  rdfs:comment "Inside the taxonomic nomenclature section, we have the treatment title."@en .

trt:NomenclatureCitationList a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Taxonomic Nomenclature Citation List"@en ;
  rdfs:comment "Inside the taxonomic nomenclature section, we have a list
                of citations."@en .                  
@
```

**Example (Nomenclature).**

```
<<Examples>>=

:heser-stoevi-treatment
  po:contains :heser-stoevi-nomenclature ;

:heser-stoevi-nomenclature a Doco:Section, trt:Nomenclature ;
  po:contains :heser-stoevi-nomenclature-heading .

:heser-stoevi-nomenclature-heading a trt:NomenclatureHeading ;
  cnt:chars 
  "Heser stoevi urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 Deltshev sp. n." .
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

**Def. (Taxonomic Name Usage):** *A taxonomic name usage is the mentioning of a
biological taxonomic name in a text. A taxon concept label is a taxonomic name
usage accompanied by an additional part, consisting of "sec." + an identifier
or a literature reference of a work containing the expression of a taxon concept
(treatment).*

```
<<Taxonomic Name Usage>>=

:TaxonomicNameUsage rdf:type owl:Class ;
  rdfs:subClassOf  pext:Mention ;
  rdfs:comment "A string within a document that can be considered a mention of a
                  biological name."@en ;
  rdfs:label "Taxonomic Name Usage"@en . 

:TaxonConceptLabel rdf:type owl:Class ;
	rdfs:subClassOf :TaxonomicNameUsage ;
	rdfs:label "Taxon Concept Label"@en ;
	rdfs:comment "A taxon concept label is a taxonomic name
usage accompanied by an additional part, consisting of "sec." + an identifier
or a literature reference of a work containing the expression of a taxon concept
(treatment)." @en .
@
```

**Important note.** or the logic of our algorithms, it is very important that
TNU's are dated with `dc:date`.

**Rule:** *All TNU's that are in nomenclatural headings are taxon concept
labels and they should be linked to the taxon concept coming about through the
treatment of which they are the headings.*

```

<<SPARQL Rules>>=

INSERT {
    ?a rdf:type :TaxonConceptLabel . 
}
WHERE {
	?a rdf:type :TaxonomicNameUsage .
	[] rdf:type :NomenclatureHeading ;
	   po:contains ?a .
}
@
```

**Example.** In the following example, we express in RDF a TNU which is the
nomenclature heading of a treatment (treatment title). This automatically
make the TNU into a taxon concept label. The connection to the
nomenclature heading is via `po:contains`; `cnt:chars` is used  to dump the
full string of the usage; and DwC properties are used to encode more granular
information in addition to the dump.

In the second step of RDF-ization, we use `dwciri` properties to link the TNU
to semantic entities. `dwciri:taxonomicStatus` is used to link the TNU to an
item in the
[OpenBiodiv Taxonomic Status Vocabulary](taxonomic_status_vocabulary/taxonomic_status_vocabulary.md)
and `dwciri:taxonId` is used to link the TNU to an external taxon concept.
Also, during the second step, the TNU is linked to the reified scientific name
*Heser stoevi* Deltshev and to the taxon concept *Heser stoevi* sec Deltshev
(2016) as even though the text-content of TNU does not contain a "sec.",
we know for certain which concept the author is invoking as we are in the
treatment title. The link between the TNU and the local taxon concept is
also made via `pkm:mentions`.

```
<<Examples>>=

:heser-stoevi-nomenclature-heading po:contains :heser-stoevi-tnu .

:heser-stoevi-tnu a :TaxonConceptLabel .
  dc:date "2016-08-31"^^xsd:date ;
  cnt:chars
  "Heser stoevi urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 Deltschev sp. n." ;
  dwc:genus "Heser" ;
  dwc:species "stoevi" ;
  dwc:taxonId "urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 (ZooBank)" ;
  dwc:scientificNameAuthorship "Deltschev" ;
  dwc:taxonomicStatus "sp. n." ;
  dwc:nameAccordingToId "10.3897/BDJ.4.e10095" ;

  dwciri:taxonomicStatus :TaxonDiscovery ;
  dwciri:nameAccordingToId <http://dx.doi.org/10.3897/BDJ.4.e10095> ;

  pkm:mentions :heser-stoevi-deltshev, <http://zoobank.org/urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8> ,
  				:Heser-Stoevi-sec-Deltshev .
@
     
```

### Biological Taxonomy and Systematics

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

**Def. (Biological Name, Scientific Name, Vernacular Name):**

```
<<Biological Names>>=

:BiologicalName rdf:type owl:Class ;
    rdfs:label "Biological Name"@en ;
    owl:sameAs nomen:NOMEN_0000030 .

:ScientificName rdf:type owl:Class ;
    rdfs:subClassOf :biologicalName ;
    rdfs:label "Scientific Name"@en ;
    owl:sameAs nomen:NOMEN_0000036 .
    
:VernacularName a owl:Class ;
  rdfs:subClassOf :biologicalName ;
  rdfs:label "Vernacular Name"@en ;
  ownl:sameAs nomen:NOMEN_0000037 .
@
```

Again, as in the taxonomic statuses example, we do not model scientific names
down to the level of the Codes as NOMEN does. We also use different sets of
properties to define relationships between biological names and for their data
properties.

For the data properties we use DwC terms. We also use `dwciri:scientificName`
to connect different biological objects such as taxon concepts or occurrences
to a scientific name. However, even though `dwciri:scientificName` is defined 
in spirit in <http://rs.tdwg.org/dwc/terms/guides/rdf/index.htm#2.5_Terms_in_the_dwciri:_namespace>, we couldn't actually find
a formal definition in RDF, that's why we're introducing it here together
with a super-property to refer to a more broader class of names.

**Def. (has biological name, has scientific name, has vernacular name):**.

```
<<Biological Names>>=

:biologicalName rdf:type owl:ObjectProperty ;
	rdfs:label "has biological name" @en ;
	rdfs:range :BiologicalName .

:scientificName rdf:type owl:ObjectProperty ;
	rdfs:label "has scientific name" @en ;
	owl:sameAs dwciri:scientificName ;
	rdfs:range :ScientificName .

:nameAccordingTo rdf:type owl:ObjectProperty ;
  rdfs:label "sec" ;
  owl:sameAs dwciri:nameAccordingTo ;
  rfs:range frbr:Expression .

:vernacularName rdf:type owl:ObjectProperty ;
	rdfs:label "has vernacular name" @en ;
	rdfs:range :VernacularName .
@
```

For object properties, have two types of relationships: unidirectional and
bidirectional.

**Def. (has related name):** 'has related name' is an object property that we
use in order to indicate that two biological names are related somehow. This
relationship is purposely vague as to encompass all situations where two
biological names co-occur in a text. It is transitive and reflexive.

```
<<Biological Names>>=

:relatedName rdf:type owl:ObjectProperty, owl:TransitiveProperty, owl:ReflexiveProperty ;
  rdfs:label "has related name"@en ;
  rdfs:domain :BiologicalName ;
  rdfs:range :BiologicalName ;
  rdfs:comment "'has related name' is an object property that we
use in order to indicate that two biological names are related somehow. This
relationship is purposely vague as to encompass all situations where two
biological names co-occur in a text. It is transitive and reflexive."@en.
@
```

**Def. (has replacement name):** This is a uni-directional property. Its meaning
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
  rdfs:label "has replacement name"@en ;
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

**Rule 1 for Names:** For a scientific name X, if there doesn't exist a TNU
mentioning X, which has the taxon status of `:UnavailableName`, or if there
does exist a TNU Y mentioning X with the status of `:UnavailableName`, but
there also exists a TNU Z mentioning X with a later date than Y, which has the
status of `:AvailableName` or `:ReplacementName`, then X has the taxon status
of `:AvailableName`.

TODO: write this rule in SPARQL

```
<<SPARQL Rules>>=

 # rules need to be evaluated in the order here
 # 1. set all names that have not been made unavailabel to available
INSERT {
  ?a dwciri:taxonomicStatus :AvailableName .
}
WHERE {
  ?a rdf:type :ScientificName .
  ?tnu pkm:mentions ?a .
  UNSAID { ?tnu dwciri:taxonomicStatus :UnavailableName .}
}

 # note the date here refers to when was the taxonomic status of the name last determined
 # 2. set all names that were made unavailable at one point to unavailable and copy the
 # date
INSERT {
  ?a dwciri:taxonomicStatus :UnavailableName .
  ?a dc:date ?d .
}
WHERE {
  ?a rdf:type :ScientificName .
  ?tnu pkm:mentions ?a ;
       dwciri:taxonomicStatus :UnavailableName ;
       dc:date ?d .
}
@

 # 3. set names to :Available back 
DELETE {
  ?a dwciri:taxonomicStatus :UnavailableName ;
  ?a dc:date ?d0 .
}
INSERT {
  ?a dwciri:taxonomicStatus :AvailableName .
  ?a dc:date ?d1 .
}
WHERE {
  ?a rdf:type :ScientificName ;
     dc:date ?d0 .
  ?tnu1 pkm:mentions ?a ;
        dwciri:taxonomicStatus :AvailableName ;
        dc:date ?d1 .
  FILTER ( ?d1 > ?d0 )
}

DELETE {
  ?a dwciri:taxonomicStatus :UnavailableName ;
  ?a dc:date ?d0 .
}
INSERT {
  ?a dwciri:taxonomicStatus :AvailableName .
  ?a dc:date ?d1 .
}
WHERE {
  ?a rdf:type :ScientificName ;
     dc:date ?d0 .
  ?tnu1 rdf:type :TaxonomicNameUsage ;
        pkm:mentions ?a ;
        dwciri:taxonomicStatus :ReplacementName ;
        dc:date ?d1 .
  FILTER ( ?d1 > ?d0 )
}
```

TODO: test that the rules work OK in a local GraphDB installation!

**Rule 2 for Names:** For a scientific name X, if it is mentioned in the heading of a nomenclature section (treatment title) in a TNU Y with status `:ReplacementName`, then
every name Z_i, mentioned in the nomenclatural citation list in TNU's with status
`:UnavailableName` is linked to X via `:replacementName`.

```
<<SPARQL Rules>>=

INSERT {
    ?a trt:replacementName ?b .
}
WHERE {
	?a a :ScientificName .
	?b a :ScientificName .
	[] a trt:Nomenclature ;
	 	   po:contains [ a :TaxonomicNameUsage ;
	 	   				 pkm:mentions ?a ;
	 	   				 dwciri:taxonomicStatus :ReplacementName ] ,
		      	   	   [ a :TaxonomicNameUsage ;
		      	         pkm:mentions ?b ;
		      	         dwciri:taxonomicStatus :UnavailableName ].
}
@
```

**Rule 3 for Names:** All names in the nomenclature section are linked via `:relatedName`.

```
<<SPARQL Rules>>=

 # if two names are mentioned in the same nomenclature
 # section then they are related

INSERT {
    ?a trt:relatedName ?b .
}
WHERE {
	?a a :ScientificName .
	?b a :ScientificName .
	?c a trt:Nomenclature ;
  	   po:contains [ pkm:mentions ?a ];
		      	   [ pkm:mentions ?b ].
}
@
```

**Rule 4 for Names:** If for a name X, there exists a TNU Y If a TNU is marked
as `:Conserved`, then the name is also marked as `:Conserved`. A conserved
name should not be made `:Unavailable`!


```
<<SPARQL Rules>>=

 # if two names are mentioned in the same nomenclature
 # section then they are related

INSERT {
    ?a dwciri:taxonomicStatus :ConservedName .
}
WHERE {
  ?a a :ScientificName .
  ?t a :TaxonomicNameUsage ;
     pkm:mentions ?a
     dwciri:taxonomicStatus :ConservedName .
@
```

**Example** We go back to the example of 
*Heser stoevi*. The meaning of the date property here is to indicate
when was the taxonomic status assumed.

```
<<Examples>>= 

:tnu pkm:mentions :heser-stovi-deltschev .

:heser-stoevi-deltshev a :ScientificName ;
	skos:prefLabel "Heser stoevi Deltshev" ;
    dwc:species "stoevi" ;
    dwc:genus "Heser" ;
    dwc:taxonRank "species" ;
    dwciri:taxonomicStatus <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
    dwc:scientificNameAuthorship "Deltschev" 
    dc:date "2016-08-31"^xsd:date .

@
```

**Example.**
Let's take another example,
the paper <http://bdj.pensoft.net/articles.php?id=8030&instance_id=2809105>.
From it, we can say:

```
<<Examples>>= 

:nomenclature-bdje8030 a trt:Nomenclature ;
  po:contains :nomenclature-heading-bdje8030, :cit-list-bdje8030 .

:nomenclature-heading-bdje8030 a :NomenclatureHeading ;
  po:contains :harmonia-manillana-tnu-heading .

:cit-list-bdje8030 a trt:NomenclatureCitationList ;
  po:contains :leis-papuensis-tnu-citation .

:harmonia-manillana-tnu-heading a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^xsd:date ;
  cnt:chars "Harmonia manillana (Mulsant, 1866)" .

:leis-papuensis-tnu-citation a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^xsd:date ;
  cnt:chars "Leis papuensis var. suffusa Crotch 1874 121 (Lectotype, UCCC). Korschefsky 1932 : 275.- Gordon 1987 : 14 (lectotype designation). Syn. nov." ;
  dwc:taxonomicStatus "var. suffusa Crotch 1874 121 (Lectotype, UCCC). Korschefsky 1932 : 275.- Gordon 1987 : 14 (lectotype designation). Syn. nov." ;
  dwciri:taxonomicStatus :Unavailable .

:harmonia-manillana-mulsant-1866 a :ScientificName ;
  skos:prefLabel "Harmonia manillana (Mulsant, 1866)" ;
  skos:altLabel "Harmonia manillana" ;
  dwc:species "manillana" ;
  dwc:genus "Harmonia" ;
  dwc:taxonRank "species" ;
  dwc:scientificNameAuthorship "(Mulsant, 1866)" ;
  dc:date "2016-08-16"^xsd:date ; 
  dwc:taxonomicStatus :Available ;
  :relatedName :leis-papuensis .

:leis-papuensis a :ScientificName ;
  skos:prefLabel "Leis papuensis" ;
  dwc:species "papuensis" ;
  dwc:genus "Leis" ;
  dwc:taxonRank "species" ;
  dc:date "2016-08-16"^xsd:date ; 
  dwciri:taxonomicStatus :Unavailable ;
  :replacementName :harmonia-manillana-mulsant-1866 ;
  :relatedName :harmonia-manillana-mulsant-1866 .
@
```

#### Taxon Concepts

**Discussion.** Our view of taxon concepts is based on [Berendsohn
(1995)](http://www.jstor.org/stable/1222443) and [Franz et al
(2008)](http://dx.doi.org/10.1201/9781420008562.ch5). We consider any given
taxon concept to be a scientific theory (concept) about a class of biological
organisms (taxon). The class description, as in "as in all spiders have
spinnerets (silk-producing glands)" (Nico Franz, personal correspondence), is
called *intensional meaning,* whereas the group of organisms in nature
conforming with the intensional meaning is called the class *extension.* In our
view the words "taxon" and "taxon concept" are the two sides of the same coin:
taxon concept stresses the intensional meaning

As we do want to model both the intensional meaning (traits of taxa) and the
extension  of taxon concepts (occurrences of taxa)

and the
extensions being organisms that are considered to be members of the class.

As we do want to talk both about the taxon concepts themselves, i.e. to
explicitly specify their intensional meaning 
This necessitates the view that taxon concepts are both instances
of a Taxon Concept class and are classes of ogranisms of each individual
organisms may be instances. Later, we will show that this means that
we model Taxon Concepts with OWL Full.

Taxon concepts can be expressed as works of human thought (`frbr:Work`), for
instance as treatments in scientific articles or as a group of records in a
database.

Thus, OpenBiodiv taxon concepts are instances of `dwc:Taxon` and vice versa
(*"A group of organisms [sic] considered by taxonomists to form a homogeneous
unit."*).

Also, taxon concepts are instances of `frbr:Work` as well, but not vice
versa (*"A distinct intellectual or artistic creation. A work is an abstract entity;
there is no single material object one can point to as the work. We recognize
the work through individual realizations or expressions of the work, but the
work itself exists only in the commonality of content between and among the
various expressions of the work. When we speak of Homer's Iliad as a work, our
point of reference is not a particular recitation or text of the work, but the
intellectual creation that lies behind all the various expressions of the
work."*).

Furthermore, taxon concepts can also be modeled as `skos:Concept`, but not
vice versa(*"A SKOS concept can be viewed as an idea or notion; a unit of
thought. However, what constitutes a unit of thought is subjective, and this
definition is meant to be suggestive, rather than restrictive."*).

All three classes represent a distinctive view that we want to adopt in
modeling different features of taxon concepts. First, the biodiversity
informatics community heavily relies on the DwC standard for sharing
occurrence data (TODO cite Baskauf). Secondly, to link taxon concepts to the
scientific works they were expressed in requires taking the view that they are
instances of `frbr:Work`. Third, to model some of relationships between taxon
concepts, we view them as SKOS concepts.

Holding the views of Berendsohn and of Franz, we require that each taxon
concept is linked to both a biological name and to a work (i.e. publication,
database, etc.), where the circumscription is properly defined.

**Def. (Taxon Concept):**

TODO: add comment here

```
<<Biological Systematics Model>>= 

:TaxonConcept rdf:type owl:Class ;
  owl:sameAs dwc:Taxon ;
  rdfs:subClassof frbr:Work ,
                  skos:Concept ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty dwciri:scientificName ;
                    owl:minCardinality "1" ] ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty dwciri:nameAccordingTo ;
                    owl:minCardinality "1" ] .
@
```

**Example.** In the next example we introduce the concept of *Heser stoevi*
according to the article published by Deltshev in 2016. First, we introduce an
instance of `:TaxonConcept` and link this instance to the scientific name
*Heser stoevi* via the appropriate DwC term. Next, we establish a link between
the significant bibliographic unit (in this case journal article) containing
the treatment, which is the realization of the taxon concept. The last point we
would like to make is that the taxon concept label, which is in this case
`Heser stoevi sec. 10.3897/BDJ.4.e100095` is constructed by pasting together
the label of the biological name and the expression that are assigned to the
concept glued together by `sec.`.

```
<<Examples>>=

:heser-stoevi-sec-deltshev-2016 a :TaxonConcept ;
  skos:prefLabel "Heser stoevi sec. 10.3897/BDJ.4.e10095" ;
  dwciri:scientificName :heser-stoevi-deltshev ;
  dwciri:nameAccordingTo <http://dx.doi.org/10.3897/BDJ.4.e10095> .

:heser-stoevi-sec-gbif20170323 a :TaxonConcept ;
  skos:prefLabel "Heser stoevi sec. doi:10.15468/39omei" ;
  dwciri:scientificName :heser-stoevi-deltshev ;
  dwciri:nameAccordingTo :gbif20170323 .

<http://dx.doi.org/doi:10.15468/39omei> a fabio:Database ;
  skos:prefLabel "GBIF Backbone Taxonomy" ;
  skos:altLabel "doi:10.15468/39omei" ;
  prism:doi "doi:10.15468/39omei" ; 
  dc:date "2017-03-23"^^xsd:date ;
  rdfs:comment "A dump of GBIF's backbone taxonomy on 23 Mar 2017."@en ;
  po:contains [ a :TaxonConceptLabel ;
                dc:date ""2017-03-23"^^xsd:date ;
                dwc:scientificName "Heser stoevi Deltshev, 2016" ;
                dwc:nameAccordingTo "GBIF Backbone Taxonomy" ;
                dwciri:nameAccordingTo <http://dx.doi.org/doi:10.15468/39omei> ;
                dwciri:scientificName :heser-stoevi-deltshev ;
                pkm:mentions :heser-stoevi-sec-gbif20170323 . ] .
@
```

Note that in the above example one scientific name, *Heser stoevi*, is
linked to two different taxon concepts, as one taxon concept comes
from the article and another one comes from the GBIF database.

It is possible to express that these are the same thing, that one is a
subconcept of the other, or even more granular relationships.

#### Taxon Concept Relationships

**Example of congruent concepts.** We model sameness of taxon concepts with `skos:exactMatch` as we
do not want the inferenetial consequences of `owl:sameAs`. For example, if two
taxon concepts have different scientific names but are considered to be the
same, the use of `owl:sameAs` would imply copying the scientific name property
from one concept to the other, which we do not want. Or the labels will get copied.
Note that we can always gather the properties later in SPARQL.
[SKOS primer](https://www.w3.org/TR/skos-primer/).


```
<<Examples>>=

:heser-stoevi-sec-deltschev owl:equivalentClass :heser-stoevi-sec-gbif20170323 .
@

```

**Example of contained concepts.** Again we opt for `skos:narrower` rather than
`rdfs:subClassOf` even if we do consider taxon concepts classes.


```
<<Examples>>=

[] a :TaxonConceptLabel ;
  dc:date "2017-03-23"^^xsd:date ;
  pkm:mentions :animalia-sec-gbif20170323 ;
  dwciri:scientificName :animalia ;
  dwc:taxonomicStatus "Accepted" ;
  dwciri:taxonomicStatus :Available .

:animalia a :ScientificName ;
  dwc:scientificName "Animalia" ;
  dwc:taxonRank "kingdom" ;
  dc:date "2017-03-23"^^xsd:date ;
  dwciri:taxonomicStatus :Available .

:animalia-sec-gbif20170323 a :TaxonCocept ;
  skos:prefLabel "Animalia sec. GBIF Backbone Taxonomy" ;
  dwciri:scientificName :animalia ;
  dwciri:nameAccordingTo <http://dx.doi.org/doi:10.15468/39omei> ;
  dwc:taxonId "1 (GBIF)" .

:heser-stoevi-sec-gbif20170323 skos:narrower :animlia-sec-gbif20170323
@


:animal-folk-name a :VernacularName ;
  dwc:vernacularName "animal"@en ;
  dwc:vernacularName "Tier"@de ;
  dwc:vernacularName "животно"@bg .

:animal a :TaxonConcept;
  skos:prefLabel "animal sec. <https://www.w3.org/TR/skos-primer/#sechierarchy>"@en;
  dwciri:vernacularName :animal-folk-name ;
  frbr:realization <https://www.w3.org/TR/skos-primer/#sechierarchy> .

:heser-stoevi-deltschev-sec-deltschev skos:narrower :animal .

@
```

**Example (relatedness)**


```
<<eg_taxon_concept>>=

:heser-nicola a :ScientificName ;
  dwc:scientificName "Heser nilicola (O. P.-Cambridge, 1874)" ;
  skos:prefLabel "Heser nilicola" ;
  dwc:genus "Heser" ;
  dwc:species "nilicola" ;
  dwc:taxonRank "species" .

:heser-nicola-sec-unibe a :TaxonConcept ;
  dwciri:scientificName :heser-nicola ;
  frbr:realization <http://www.araneae.unibe.ch/data/3301> .

:heser-stoevi-deltschev-sec-deltschev skos:related :heser-nicola-sec-unibe .

@
```

##### simple Taxon Concept Relationships with OWL

Another way to model simple taxon concept relationships is to use OWL Full because of

NOTE: In OWL Lite and OWL DL an individual can never be at the same time a class: classes and individuals form disjoint domains (as do properties and data values). OWL Full allows the freedom of RDF Schema: a class may act as an instance of another (meta)class.

1. `owl:sameAs`
2. `rdfs:subClassOf` or `rdf:type` chains
TODO : Question does `rdf:type` imply owl:Class for range? yes.
3. We still need to use SKOS here.


#### Complex Relationships with RCC-5

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

## Vocabulary of taxonomic statuses

# Vocabulary of Taxonomic Statuses

### What is a taxonomic status?

[Taxonomic name usages](#taxonomic-name-usage) (TNU's) in taxonomic articles
may be accompanied by strings such as "new. comb.", "new syn.", "new record
for Cuba", and many others. These postfixes to a taxonomic name usage are
called in our model taxonomic statuses and have taxonomic as well
nomenclatural meaning. For example, if we are describing a species new to
science, we may write "n. sp." after the species name, e.g. "*Heser stoevi*
Deltchev sp. n." This particular example is also a nomenclatural act in the
sense of the Codes of zoological or botanical nomenclature.

Not all statuses are necessarily nomenclatural in nature. Sometimes the status
is more of a note to the reader and conveys taxonomic rather than
nomenclatural information. E.g. when a previously known species is recorded in
a new location.

Here we take the road of modeling statuses from the bottom-up, i.e. based on
their actual use in three of the most successful journals in biological
systematics - ZooKeys, Biodiversity Data Journal, and PhytoKeys. We have
analyzed about 4,000 articles from these journals and have come up with a
vocabulary of statuses described below. The terms in this vocabulary refer to
broad concepts and encompass both specific cases of botanical or zoological
nomenclature as well as purely taxonomic or informative use. We believe these
concepts to be adequately granular for the purposes of reasoning in OpenBiodiv
(see the paragraphs on rules in [biological names](#biological-names).

## Extraction of 4,000 TNU suffixes

1. The first step we took in creating this vocabulary is to extract the actual
real-world taxonomic statuses as found almost 4,000 Pensoft articles. The
script to achieve this is found under [mine_tnu.R](R/mine_tnu.R). The output of
the script is a list of taxonomic status abbreviations as a text file,
[taxonomic_statuses.txt](status_abbrev/all.txt), in total 253 distinct
usages.

2. The second step we took is to normalize these statuses manually: clean up
parts of abbreviations that are not part of the status (such as particular
taxon names) or remove irrelevant statuses (such as geological information).

3. After cleaning up the usages we came up with the terms in the next section
and assigned each of remaining status abbreviations to one of the terms. The
assignments can be seen in text files with correspondning names.

For a similar attempt, see
<http://rs.gbif.org/vocabulary/gbif/taxonomic_status.xml>. We do map our
statuses to the GBIF statuses to the best of our knowledge but we have more
statuses.

## Formal Vocabulary


```
<<Vocabulary Taxonomic Statuses>>=

:TaxonomicStatus rdf:type owl:Class ;
  rdfs:subClassOf [ rdf:type owl:Restriction ;
                    owl:onProperty <http://www.w3.org/2004/02/skos/core#inScheme> ;
                    owl:someValuesFrom :TaxonomicStatusTerms ] ;
  rdfs:label "Taxonomic Status"@en ;
  rdfs:comment "The status following a taxonomic name usage in a taxonomic
                manuscript, i.e. 'n. sp.',
                                 'comb. new',
                                 'sec. Franz (2017)', etc"@en .

:TaxonomicStatusTerms rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :TaxonomicStatus] ;
  rdfs:label "OpenBiodiv Vocabulary of Taxonomic Statuses"@en ;
  fabio:hasDiscipline dbpedia:Taxonomy_(biology) .

  <<Taxonomic Uncertainty>>
  <<Taxon Discovery>>
  <<Replacement Name>>
  <<Unavailable Name>>
  <<Available Name>
  <<Type Specimen Designation>>
  <<Type Species Designation>>
  <<New Occurrence Record>>
  <<Taxon Concept Label>>

@
```

### Taxonomic Uncertainty

When a TNU is followed by the term `:TaxonomicUncertainty`, the implication is
that the taxon concept identified by the name has an uncertain placement in
the biological taxonomy, or if we are talking about a specimen or a sample of
some kind that we are unable to identify the taxon down to its rank. This
is related to <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted>

```
<<Taxonomic Uncertainty>>=

:TaxonomicUncertainty a :TaxonomicStatus ;
  rdfs:label "Taxonomic Uncertainty"@en ;
  skos:inScheme :TaxonomicStatusTerms ;
  skos:related <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
 
  rdfs:comment "The implication of this term that the taxon concept identified
by a name has an uncertain placement in the biological taxonomy, or if we
are talking about a specimen or a sample of some kind that we are unable to
identify the taxon down to its rank. "@en .

@
```

Here're some ways in which it can be abbreivated:

[taxonomic_uncertainty.txt](status_abbrev/taxonomic_uncertainty.txt)

#### Taxon Discovery

When a TNU is followed by the term `:TaxonDiscovery`, the implication is that
the present context in which the TNU is used is circumscribing a new taxon
concept (a taxon concept of a taxon new to science), and simultaneously
assigning it a new name.

```
<<Taxon Discovery>>=

:TaxonDiscovery a :TaxonomicStatus ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:label "Taxon Discovery"@en ;

  rdfs:comment "When a TNU is followed by the term `:TaxonDiscovery`, the
implication is that the present context in which the TNU is used is
circumscribing a new taxon concept (a taxon concept of a taxon new to
science), and simultaneously assigning it a new name."@en .

@
```

Here're some ways in which it can be abbreivated:

[taxon_discovery.txt](R/taxon_discovery.txt)

#### Replacement Name

When a TNU is followed by the term `:ReplacementName`, the implication is that
the name that is referred to by the TNU is replacing another name for various
reasons, and thus becoming the preferred/accepted/available way of refering to
whatever taxon concepts the now replaced name had been referring to. Cases
include changes of rank, new combinations, spelling mistakes, etc.

```
<<Replacement Name>>=

:ReplacementName a :TaxonomicStatus ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:label "Replacement Name"@en ;
  rdfs:comment "When a TNU is followed by the term `:ReplacementName`, the implication is that
the name that is referred to by the TNU is replacing another name for various
reasons, and thus becoming the preferred/accepted/available way of refering to
whatever taxon concepts the now replaced name had been referring to. Cases
include changes of rank, new combinations, spelling mistakes, etc.
"@en .

@
```
Here're some ways in which it can be abbreivated:

[replacement_name.txt](R/replacement_name.txt)

#### Unavailable Name

When a TNU is followed by the term `:UnavailableName`, the implication is that
the name that is being referred to by the TNU is no longer or has never been
available for use due to the fact that it has either been replaced or it has
been determined that the name has been improperly coined or published, or the
name contains any general error rendering it unfit for use. This is the
same as <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/synonym>

```
<<Unavailable Name>>=

:UnavailabeName a :TaxonomicStatus ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:label "UnavailableName"@en ;
  skos:exactMatch  <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/synonym> ;
  rdfs:comment "When a TNU is followed by the term `:UnavailableName`, the implication is that
the name that is being referred to by the TNU is no longer or has never been
available for use due to the fact that it has either been replaced or it has
been determined that the name has been improperly coined or published, or the
name contains any general error rendering it unfit for use."@en .


@
```

Here're some ways in which it can be abbreivated:

[unavaible_name.txt](R/unavavaible_name.txt)

#### Available Name

When a TNU is followed by the term `:AvailableName`, the implication is that
the name that is being referred to by the TNU has been determined to be fit
for use either by revoking an older act rendering the name unavailable or by
fixing other issues with the name or finding out that other issues with the
name had been fixed, or just stating the fact that the name shall be used or
even conserving it, so that the name can be freely used from then on in
compliance with all Codes and practices. This is the same as
<http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted>

```
<<Available Name>>=

:AvailableName a :TaxonomicStatus ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:Label :Available Name"@en ;
  skos:exactMatch <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
  rdfs:comment "When a TNU is followed by the term `:AvailableName`, the
implication is that the name that is being referred to by the TNU has been
determined to be fit for use either by revoking an older act rendering the
name unavailable or by fixing other issues with the name or finding out that
other issues with the name had been fixed, or just stating the fact that the
name shall be used or even conserving it, so that the name can be freely used
from then on in compliance with all Codes and practices."@en.

@
```

[available_name.txt](R/available_name.txt)

#### Type Species Designation

When a TNU is followed by the term `:TypeSpeciesDesignation`, the implication
is that the taxon concept of the name in the TNU as understood by the author
should be considered the type species of a higher taxon as understood by the
author.

```
<<Type Species Designation>>=

:TypeSpeciesDesignation a :TaxonomicStatus ;
  rdfs:label "Type Species Designation" @en ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:comment "When a TNU is followed by the term `:TypeSpeciesDesignation`, the implication
is that the taxon concept of the name in the TNU as understood by the author
should be considered the type species of a higher taxon as understood by the
author."@en.

@
```

[type_species_desgination.txt](R/type_species_designation.txt)

#### Type Specimen Designation

When a TNU is followed by the term `:TypeSpecimenDesignation`, the implication
is that the specimen identified by the name in TNU should be considered a type
of the taxon concept identified by the name as understood by the author of
TNU.

```
<<Type Specimen Designation>>=

:TypeSpecimenDesignation a :TaxonomicStatus ;
  rdfs:label "Type Specimen Designation" @en ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:comment "When a TNU is followed by the term `:TypeSpecimenDesignation`, the implication
is that the specimen identified by the name in TNU should be considered a type
of the taxon concept identified by the name as understood by the author of
TNU."@en.

@

```

[type_specimen_desgination.txt](R/type_specimen_designation.txt)

#### New Record

When a TNU is followed by the term `:NewRecord`, the implication is that the
description of taxon concept of the name as understood by the author is being
extended with new occurrences (for a given locality).


```
<<New Occurrence Record>>=

:NewOccurrenceRecord a :TaxonomicStatus ;
  rdfs:label "New Occurrence Record" @en ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:comment "When a TNU is followed by the term `:NewRecord`, the implication is that the
description of taxon concept of the name as understood by the author is being
extended with new occurrences (for a given locality).
"@en.

@
```

[new_occurrence_record.txt](R/new_occurrence_record.txt)

#### Taxon Concept Label

Sometimes, incorrectly a taxon concept label (sec. Author (year) may be
misunderstood and marked up) as a taxonomic status. This term has been created
to indicate that a particular TNU is taxonomic concept label.

```
<<Taxon Concept Label>>=

:TaxonConceptLabel a :TaxonomicStatus ;
  skos:inScheme :TaxonomicStatusTerms ;
  rdfs:label "Taxon Concept Label"@en ;
  rdfs:comment "Sometimes, incorrectly a taxon concept label (sec. Author (year) may be
misunderstood and marked up) as a taxonomic status. This term has been created
to indicate that a particular TNU is taxonomic concept label.
"@en .
              
@
```

[taxon_concept_label.txt](R/taxon_concept_label.txt)

## Directly imported external ontologies

Some third party ontologies cannot be imported via `owl:imports` for various
reasons (updated versions that we don't use, broken links, etc.) We add the
objects that we borrow from them here.

```
<<External Ontology>>=

# Parts of PROTON

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

pkm:mentions
      rdf:type owl:ObjectProperty ;
      rdfs:comment """
    A direct link between an information resource, like a document or a section and an entity.
  """ ;
      rdfs:domain ptop:InformationResource ;
      rdfs:label "mentions" ;
      rdfs:range psys:Entity .

pext:Mention rdf:type owl:Class ;
             rdfs:subClassOf ptop:InformationResource ;
             rdfs:comment "An area of a document that can be considered a mention of something."@en ;
             rdfs:label "Section" .
@
```

## TODO's


TODO: Need to add proton prefixes to the YAML database `pext`, `ptop`, etc.
