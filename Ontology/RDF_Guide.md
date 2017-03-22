# OpenBiodiv RDF Guide

This is the Open Biodiversity Knowledge Management System (OBKMS) RDF Guide.
In the rest of this document this discussed knowledge management system will
also be referred to as OpenBiodiv. The guide is intended to explain to human
users and define for computers the data model of OpenBiodiv and aid users in
generating OpenBiodiv compatible RDF and in creating working SPARQL queries or
other extensions.

This guide is a
[literate programming](https://en.wikipedia.org/wiki/Literate_programming)
document. *Literate programming* is the act of including source code within
documentation. In usual software development practice the reverse holds true.
Thus, the formal description of the data model, i.e. the
[RDF](https://www.w3.org/RDF/) statements that form the ontology and the vocabularies, are found
within the document itself and are extracted from it with the program
`noweb`. `noweb` can be easily obtained for GNU Linux.

## Introduction

**Motivation.** The raison d'être of the OpenBiodiv data model is to enable
the operation of a semantic database as part of OpenBiodiv. The data model
consists of:

1. A formal ontology, called from here on *OpenBiodiv Ontology*, introducing
the entities that our knowledge base holds and giving axioms that restrict the
ways in which they can be combined.

2. Formal vocabularies specified in RDF for particular application areas.

2. Natural language descriptions of the meaning (semantics) of the concepts
from (1) and (2) in our conceptualization of the universe of discourse.

3. Examples and recommendations that illustrate and describe the intended
model to human users as the formal ontology necessarily will be more lax than
the intended model.

For a discussion see
[Specification of Conceptualization](https://www.obitko.com/tutorials/ontologies-semantic-web/specification-of-conceptualization.html),
as well as the article by
[Guarino et al. (2009)](http://iaoa.org/isc2012/docs/Guarino2009_What_is_an_Ontology.pdf).

As this is a literate programming document, we take the approach of explaining
the data model to humans, and defining the OpenBiodiv Ontology as we progress
with our explanations.

```
<<OpenBiodiv Ontology>>=

<<Prefixes>>
<<Ontology Title>>
<<Publishing Domain Model>>
<<Systematics Domain Model>>

@

<<Ontology Title>>=

openbiodiv:
  rdf:type owl:Ontology ;
  owl:versionInfo "0.2" ;
  rdfs:comment "Open Biodiversity Knowledge Management System Core Ontology" ;
  dc:title "OpenBiodiv Core Ontology" ;
  dc:subject "OpenBiodiv Core Ontology" ;
  rdfs:label "OpenBiodiv Core Ontology" ;
  dc:creator "Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev" ;
  dc:rights "CCBY" .

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

 # These are the examples for the OpenBiodiv data model.
@
```

**Command to build the examples.** 

```
notangle -RExamples RDF_Guide.md > Examples.ttl
```

TODO: check for prefix consistency for all imported ontologies.

**Commands to extract the vocabularies.**

```
notangle -R"Vocabulary Taxonomic Statuses" RDF_Guide.md > TaxonomicStatuses.ttl
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

:heser-stoevi-article a fabio:JournalArticle ;
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

:ТaxonоmicNameUsage a owl:Class ;
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
  dc:date "2016-08-31"^xsd:date ;
  cnt:chars
  "Heser stoevi urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 Deltschev sp. n." ;
  dwc:genus "Heser" ;
  dwc:species "stoevi" ;
  dwc:taxonId "urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 (ZooBank)" ;
  dwc:scientificNameAuthorship "Deltschev" ;
  dwc:taxonomicStatus "sp. n." ;

  dwciri:taxonomicStatus :TaxonDiscovery ;

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

:relatedName rdf:type owl:ObjectProperty,
						owl:TransitiveProperty,
						owl:ReflexiveProperty ;
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

# if two names are mentioned in the same nomenclature
# section then they are related
@
```

**Rule 6 for Names:** If for a name X, there exists a TNU Y

If a TNU is marked as `:Conserved`, then the name is
also marked as `:Conserved`. A conserved name cannot be invalidated with
`:Synonym` or `:Invalid` (some kind of error must be produced if this is
attempted).

TODO: Can I express this in OWL or SPARQL?

**Example usage of biological names.** We go back to the example of 
*Heser stoevi*. The meaning of the date property here is to indicate
when was the taxonomic status assumed.

```
<<eg_biological_names>>= 

:tnu pkm:mentions :heser-stovi-deltschev .

:heser-stoevi-deltshev a :ScientificName ;
	skos:prefLabel "Heser stoevi Deltshev" ;
    dwc:species "stoevi" ;
    dwc:genus "Heser" ;
    dwc:taxonRank "species" ;
    dwciri:taxonomicStatus <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
    dwc:scientificNameAuthorship "Deltschev" 
    dc:date "2016-08-31"^xsd:date .

```

Let's take for example,
the paper <http://bdj.pensoft.net/articles.php?id=8030&instance_id=2809105>.
From it, we can say:

```
<<eg_biological_names>>= 

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

TODO : derive a property biologicalName as a superproperty of vernacularName and scientificName

#### Taxon Concepts

**Discussion.** Our view of taxon concepts is based on
[Berendsohn (1995)](http://www.jstor.org/stable/1222443)
and
[Franz et al (2008)](http://dx.doi.org/10.1201/9781420008562.ch5).
We consider a taxon concept to be a scientific theory about a group of
biological organisms. Taxon concepts can be expressed as treatments in
scientific articles or as a group of records in a database.

Thus, taxon concepts are instances of `dwc:Taxon`, the definition of which
from TDWG reads:

"A group of organisms [sic] considered by taxonomists to form a homogeneous
unit."

Also, taxon concepts are instances of `frbr:Work` as well, the defintion of
which is:

"A distinct intellectual or artistic creation. A work is an abstract entity;
there is no single material object one can point to as the work. We recognize
the work through individual realizations or expressions of the work, but the
work itself exists only in the commonality of content between and among the
various expressions of the work. When we speak of Homer's Iliad as a work, our
point of reference is not a particular recitation or text of the work, but the
intellectual creation that lies behind all the various expressions of the
work."

Furthermore, taxon concepts can also be modeled as `skos:concept`, which are
defined as follows:

"A SKOS concept can be viewed as an idea or notion; a unit of thought.
However, what constitutes a unit of thought is subjective, and this definition
is meant to be suggestive, rather than restrictive."

All three classes represent a distinctive view that we want to adopt in
modeling different features of taxon concepts. First, the biodiversity
informatics community heavily relies on the DwC standard for sharing
occurrence data (TODO cite Baskauf). Secondly, to link taxon concepts to the
scientific works they were expressed in requires taking the view that they are
instances of `frbr:Work`. Third, to model some of relationships between taxon
concepts, we view them as SKOS concepts as well.

Holding the views of Berendsohn and of Franz, we require that each taxon
concept is linked to both a biological name and to a work (i.e. publication,
database, etc.), where the circumscriptio is properly defined.

**Def. (Taxon Concept):**

```
<<Biological Systematics Model>>= 

:TaxonConcept rdf:type owl:Class ;
  rdfs:subClassOf dwc:Taxon ,
                  frbr:Work ,
                  skos:Concept ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty frbr:realization ;
                    owl:minCardinality "1" ] ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty :biologicalName ;
                    owl:minCardinality "1" ] .

@
```

**Example.** In the next example we introduce the concept of *Heser stoevi*
according to the article published by Deltshev in 2016. First, we introduce an
instance of `:TaxonConcept` and link this instance to the scientific name
*Heser stoevi* via the appropriate DwC term. Next, we establish a link between
the significant bibliographic unit (in this case journal article) containing
the treatment, which is the realizatio of the taxon concept. The last point we
would like to make is that the taxon concept label, which is in this case,
`Heser stoevi sec. 10.3897/BDJ.4.e100095` is constructed by pasting together
the label of the biological name and the expression that are assigned to the
concept glued together by `sec.`.

```
<<eg_taxon_concept>>=

:heser-stoevi-sec-deltshev-2016 a :TaxonConcept ;
  dwciri:biologicalName :heser-stoevi-deltschev ;
  frbr:realization :artcile ;
  skos:prefLabel "Heser stoevi sec. 10.3897/BDJ.4.e10095" .

:tcl pkm:mentions :heser-stoevi-deltschev-sec-deltschev .

:gbif2017 a fabio:Database ;
  skos:prefLabel "GBIF Backbone Taxonomy 20170301"@en ; 
  rdfs:comment "A dump of GBIF's backbone taxonomy on 2 Mar 2017."@en .

:taxon-concept2 a :TaxonConcept ;
  dwciri:scientificName :heser-stoevi-deltschev ;
  frbr:realization :gbif2017 ;
  skos:prefLabel "Heser stoevi sec. GBIF Backbone Taxonomy 20170301"

@
```

Note that in the above example one scientific name, *Heser stoevi*, is
linked to two different taxon concepts, as one taxon concept comes
from the article and another one comes from the GBIF database.

It is possible to express that these are the same thing, that one
is a subconcept of the other, or even more granular relationships.


#### Taxon Concept Relationships

##### Simple Taxon Concept Relationships with SKOS

One way to model taxon concept relationships is with SKOS. This has
no inferential concequences and is suitable for data integration
purposes.

**Example (two taxon concepts are the same).**

```
<<eg_taxon_concept>>=

:heser-stoevi-deltschev-sec-deltschev skos:exactMatch :taxon-concept2 .

@
```

This has no inferenetial consequences unlike `owl:sameAs`. Note from the
[SKOS primer](https://www.w3.org/TR/skos-primer/):

"Note on skos:exactMatch vs. owl:sameAs: SKOS provides skos:exactMatch to map concepts with equivalent meaning, and intentionally does not use owl:sameAs from the OWL ontology language [OWL]. When two resources are linked with owl:sameAs they are considered to be the same resource, and triples involving these resources are merged. This does not fit what is needed in most SKOS applications. In the above example, ex1:animal is said to be equivalent to ex2:animals. If this equivalence relation were represented using owl:sameAs, the following statements would hold for ex:animal:

ex1:animal rdf:type skos:Concept;
   skos:prefLabel "animal"@en;
   skos:inScheme ex1:referenceAnimalScheme.
   skos:prefLabel "animals"@en;
   skos:inScheme ex2:eggSellerScheme.

This would make ex:animal inconsistent, as a concept cannot possess two different preferred labels in the same language. Had the concepts been assigned other information, such as semantic relationships to other concepts, or notes, these would be merged as well, causing these concepts to acquire new meanings."

**Example (one taxon concept is included in the other).**

```
<<eg_taxon_concept>>=

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
## TODO's


TODO: Need to add proton prefixes to the YAML database `pext`, `ptop`, etc.
