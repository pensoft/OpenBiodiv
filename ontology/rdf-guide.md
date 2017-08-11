# OpenBiodiv RDF Guide

## Citation

Senderov, Viktor, Daniel Mietchen, and Kiril Simov. “The Open Biodiversity Knowledge Management System RDF Guide,” n.d. https://github.com/pensoft/OpenBiodiv/blob/master/ontology/RDF_Guide.md.

## Preliminaries

This is the Open Biodiversity Knowledge Management System (OpenBiodiv,
formerly known as OBKMS) RDF Guide. The guide is intended to explain to humans
and to define for computers the data model of OpenBiodiv and aid its users in
generating OpenBiodiv-compatible RDF and in creating useful SPARQL queries or
other useful extensions.

This guide is a
[literate programming](https://en.wikipedia.org/wiki/Literate_programming)
document. Literate programming is the act of including source code within
documentation. In usual software development practice the reverse holds true.
By virtue of this programming paradigm the formal description of the data
model, i.e. the [RDF](https://www.w3.org/RDF/) statements that form the
ontology and the vocabularies, are found within the document itself and are
extracted from it with the program `noweb`. `noweb` can be easily obtained for
GNU Linux.

We've hidden the `noweb` intricacies inside a [`Makefile`](./Makefile). In
order to make the ontology one types:

```
make ontology
```

In order to make the examples, one types

```
make examples
```

And, in order to create the ruleset, one types

```
make rules
```

These command invoke the necessary `noweb` commands and generate
respectively the following files [`OpenBiodiv.ttl`](./openbiodiv.ttl),
[`Examples.ttl`](./Examples.ttl), and [`Rules.sparql`](./Rules.sparql).

## Introduction

TODO: NMF: Include in Guide a Reference section, with a few essential refs. to
connect to relevant prior efforts?

The purpose of this paper is to introduce a data model for taxonomic and
biodiversity publications, and a work-flow for generating data according to
the data model (TODO second item under construction).

The data model consists of:

1. A formal computer ontology expressed as RDF (TODO link to RDF info), called
from here on OpenBiodiv Ontology, introducing the entities that our knowledge
base holds and giving axioms that restrict the ways in which they can be
combined.

2. Formal vocabularies, also also expressed as RDF, for particular application
areas.

3. Examples illustrate and describe the intended model to human users as the
formal ontology necessarily will be more lax than the intended model (TODO
link).

4. A discussion of the concepts that gives further clarification of the
intended model and the reasoning behind our design choices of the ontology and
the vocabularies.

Thus, the data model

(a) describes a view of the universe of discourse (in our case taxonomic and
biodiversity information), which we call conceptualization, and

(b) introduces a formal way to store biodiversity information in a database.

We do not believe other data providers ought to use the same implementation of
the data model to store biodiversity information in their databases (in our
case RDF optimized for GraphDB), as they might be using a different database
application, or even paradigm. However, we do believe that should information
exchange between OpenBiodiv and these other data providers occur, biodiversity
information ought to at least follow the same conceptual model presented
herein.

### Previous work

A lot of research has gone into ontologies, knowledge bases in general and
into biodiversity knowledge representation in particular. This gives us a vast
amount of publications, ontologies, vocabularies, and datasets to draw from
while implementing our model and database. In this section we list these
sources of inspiration.

#### What is an ontology

1. Obitko (2007) defines an ontology as a
[Specification of Conceptualization](https://www.obitko.com/tutorials/ontologies-semantic-web/specification-of-conceptualization.html)

2. Guarino et al. (2009) define an ontology a
[Ga shared formal, explicit specification of a conceptualization](http://iaoa.org/isc2012/docs/Guarino2009_What_is_an_Ontology.pdf).
This article goes into set-theoretic details of what is conceptualization and
formalisms are in order to properly write down a conceptualization in a
mathematical form.

#### Data models

3. A very important data model that we are drawing from is the
[Semantic Publishing and Referencing Ontologies][http://http://www.sparontologies.net/ontologies/]
by Peroni (2014). We use it to model scientific articles, their structure, and related
entities. As part of SPAR we use individual ontologies such as
[FaBiO](http://www.sparontologies.net/ontologies/fabio),
[DOCO](http://www.sparontologies.net/ontologies/fabio) and so on.

4. Another very important data model that we drawing from is the
[Darwin-SW](http://www.semantic-web-journal.net/system/files/swj635.pdf)
by Baskauf and Web (2014).

5. Furthermore we use the [Darwin Core RDF Guide](http://rs.tdwg.org/dwc/terms/guides/rdf/).

6. As a top-level ontologies we use [PROTON](http://ontotext.com/proton/) and
[SKOS](https://www.w3.org/2004/02/skos/).

7. For modeling scientific names we draw inspiration from [NOMEN](https://github.com/SpeciesFileGroup/nomen) 
and the 
[Taxonomic Nomenclatural Status Terms](https://github.com/plazi/TreatmentOntologies/blob/master/ontologies/taxonomic_nomenclatural_status_terms.owl_).

8. A specific part of a taxonomic manuscript called
["treatment" is modeled by Plazi](https://github.com/plazi/TreatmentOntologies).

9. An attempt to model taxon concepts has previously been made in the
[Taxon Concept Ontology](http://lod.taxonconcept.org/ontology/doc/index.html).

#### Concepts

10. [Open Biodiversity Knowledge Management System](http://riojournal.com/browse_user_collection_documents.php?collection_id=1&journal_id=17) is a PhD
project by Viktor Senderov. Rod Page
[has also published an article](http://riojournal.com/articles.php?id=8767)
on the same topic.

11. It is an attempt to model
[Taxonomic and Biodiversity Information for Computers](https://link.springer.com/article/10.1007/s13752-017-0259-5).

12. [Names ultimately have a limited use in informatics](http://zookeys.pensoft.net/articles.php?id=6234),
also [challenges](http://bdj.pensoft.net/articles.php?id=8080).
Original research in this work models them names and their relationships

13. It models
[potential taxa](https://link.springer.com/article/10.1007/s13752-017-0259-5)
as taxon concepts. Taxon concepts are also treated in 
[Two Influential Primate Classifications Aligned](https://academic.oup.com/sysbio/article/65/4/561/1753624/Two-Influential-Primate-Classifications-Logically) and 
[the phylogentic revision of the genus *Minyomerus*](http://zookeys.pensoft.net/articles.php?id=6001)
by Franz et. al (2015, 2016).

14. Taxon concepts can have both an intensional meaning and a class
extension. Some examples come from
[From Cladograms to Classifications](http://www.systass.org/archive/events-archive/2001/platnick.pdf)
by Platnick (2001).

14. The Codes of [Zoological](http://www.iczn.org/iczn/index.jsp) and
[Botanical](http://www.iapt-taxon.org/nomen/main.php) Nomenclature ought also
to be mentioned as a source of albeit too granular in some cases inspiration
for the data models.

#### Semiotics

14. When we model the real world we always run up against the sign theories
of [Frege](https://en.wikipedia.org/wiki/Triangle_of_reference) and of
[Pierce](https://plato.stanford.edu/entries/peirce-semiotics/).


### Types of entities that OpenBiodiv manages

There are two ways to look at the types of entities that OpenBiodiv manages.
The first way is to look at the application domain. OpenBiodiv's application
domain is the semantic publishing of taxonomic, systematic, biodiversity,
genomic, ecologic, and related information. Therefore, the entities that
OpenBiodiv manages are separated across these domains.

Another way to look at the entities that OpenBiodiv manages is the structural
way. As the main sources of information for OpenBiodiv are scientific
articles, we can separate the entities that are extracted in entities that
are structural parts of the articles such as articles, paragraphs, sections,
tables, figures, etc., and entities that are talked about -- the actual
(domain-specific) information contained in the articles.

Both ways of looking at the entities are compatible with each other. The
following information should probably go into "OpenBiodiv Extension and
Linking Guide" but for the sake of completeness we will present it here, as
well.

Entity extraction from taxonomic articles can happen in two phases:

1. Conversion of XML elements into RDF triples following the structure of the
XML. In this stage, key XML elements are transformed into bibliographic
elements. E.g., XML elements denoting sections become `doco:Section`'s, figures
become `doco:Figure`'s, etc. Here no information extraction is taking place
and no additional semantics are added. This step can be completed linearly
without any external lookups. Key here is that the XML-hierachy is preserved
in RDF via, for example, `po:contains`.

2. Named entity recognition, co-referencing, and named entity identification.
During this step, non-structural entities are extracted from the information
present in the structural elements in the form of text or attributes. The details of how this done are beyond
the scope of this guide but it is important to note that an attempt is made to
coreference -- i.e. match multiple bibliographic elements to the same non-
bibliographic entity, if they do in fact refer to the same entity in the sense
of Frege's semiotic triangle. Another attempt is made to properly manage
identifiers. This stage cannot be completed without external look-ups.

TODO NMF: Or Peirce's ? https://plato.stanford.edu/entries/peirce-semiotics/

Answer: I am not immediately familiar with the work of Pierce, but I am adding
it to my reading list.

**Note on Capitalization.** Our ontology strives be a formal specification of
a conceptualization. In our mental model we have some concepts of some things.
When we talk about these concepts in the abstract, we will make use of
Capitalization. For example let's suppose we want to name the top-level
concept, i.e. the concept which encompasses all  concepts. For this we write
Thing. In another example, let's suppose we want to name a part of a
manuscript where taxon circumscription takes place. We say Treatment when we
refer to that concept. We also have concepts for relations (in our
conceptualization only binary relations are allowed). To denote these
relations in the abstract we use verbal phrases and we might or might not use
quotes (we will use quotes only if it adds to the clarity of exposition). For
example, Treatment is a Thing as opposed to Treatment "is a" Thing. We also
have individual instances of these concepts. To refer to those we might use
improper or proper nouns or phrases wherever appropriate. For example, "the
treatment on page 5," or "a treatment," or "John."

When we formally define a concept in OWL and issue an URI to it, we shall
refer to the URI, as we refer to all URI's in the text with `typewriter font`.
URI's of classes and vocabularies will be in `MajorCamelCase`. URI's of
relationships will be in `minorCamelCase`. URI's of individuals `will-be-
hyphenated`. This seems to generally in accordance with WWW practice.



## RDF Model

### Ontology Metadata

#### Discussion

The following code snippet, `OpenBiodiv`, is called a *chunk*. In the `noweb` way
of doing literate programming, we write our source code in chunks. Each chunk
has a name that is found between the &lt;&lt; and &gt;&gt; and ends in `@`.
Chunks can contain other chunks and thus the writing of the source code
becomes hierarchical and non- linear. In this root chunk, we've listed other
chunks that we'll introduce later and some verbatim code. In order to create
the ontology we use the `notangle` command from `noweb`.

##### Definition: OpenBiodiv Ontology

```
<<OpenBiodiv Ontology>>=
<<Prefixes>>

: rdf:type owl:Ontology ;
  owl:versionInfo "0.9" ;
  rdfs:comment "Open Biodiversity Knowledge Management System Ontology" ;
  dc:title "OpenBiodiv Ontology" ;
  dc:subject "OpenBiodiv Ontology" ;
  rdfs:label "OpenBiodiv Ontology" ;
  dc:creator "Viktor Senderov, Terry Catapano, Kiril Simov, Lyubomir Penev" ;
  dc:rights "CCBY" .

<<Model>>
<<Vocabulary of Taxonomic Statuses>>
@
```

##### Prefixes

Our data model is a natural extension of existing data models (see
[previous section](#data-models)). Therefore, we incorporate several external ontologies
or parts of existing ontologies into ours. We try to include these ontologies
via `owl:imports`. Where a URL does not resolve, or we want to import only a
specific subset of an ontology or a specific version, we directly introduce
the needed RDF into our model in the code-chunk `Borrowed Parts from External
Ontologies`. In addition to that we've downloaded the RDF for everything that
we've borrowed in the `imports` sub-subdirectory in case the URL's become
unavailable in the future. There is a catalog of this directory under
[Catalog of imported ontologies](imports/Catalog.md), which is, however, still a work
in progress.

Here, we list all the prefixes which are needed for those data models. In
OpenBiodiv prefixes are stored in a YAML configuration file called

[`prefix_db.yml`](../R/obkms/inst/prefix_db.yml)

The following Turtle code can be extracted from the prefix database with
`obkms::prefix_ttl()` command:

```
<<Prefixes>>=
@prefix : <http://openbiodiv.net/> .
@prefix skos: <http://www.w3.org/2008/05/skos#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix pro: <http://purl.org/spar/pro/> .
@prefix scoro: <http://purl.org/spar/scoro/> .
@prefix ti: <http://www.ontologydesignpatterns.org/cp/owl/timeinterval.owl#> .
@prefix tvc: <http://www.essepuntato.it/2012/04/tvc/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix fabio: <http://purl.org/spar/fabio/> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix frbr: <http://purl.org/vocab/frbr/core#> .
@prefix prism: <http://prismstandard.org/namespaces/basic/2.0/> .
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
@prefix pext: <http://proton.semanticweb.org/protonue#> .
@prefix ptop: <http://proton.semanticweb.org/protont#> .
@prefix pkm: <http://proton.semanticweb.org/protonkm#> .
@prefix vcard: <http://www.w3.org/2006/vcard/ns#> .
@prefix dbr: <http://dbpedia.org/resource/> .
@prefix org: <http://www.w3.org/ns/org#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix lucene: <http://www.ontotext.com/connectors/lucene#> .
@prefix inst: <http://www.ontotext.com/connectors/lucene/instance#> .
@prefix dbo: <http://dbpedia.org/ontology/> .
@
```

##### Examples


```
<<Examples>>=
<<Prefixes>>
<<Article Metadata>>
<<Article Structure>>
@
```

### Semantic Model of the Publishing Domain

#### Discussion 

The publishing domain is described in our model using the Semantic Publishing
and Referencing Ontologies, a.k.a. [SPAR Ontologies](http://www.sparontologies.net/).
We do import several of these ontologies (please consult the paragraph
"Incorporated external ontologies"). Refer to the documentation on the SPAR
Ontologies' site for an exhaustive treatment.

In the rest of this section we describe the modeling of entities in the
publishing domain that are *not found* in the SPAR ontologies. The central new
class in OpenBiodiv not found in SPAR is the `trt:Treatment` class, borrowed
from the [Treatment Ontologies](https://github.com/plazi/TreatmentOntologies).

#### Property Definition: *contains*

We have mentioned before that when we extract bibliographic elements from the XML,
we make use of the `po:contains` SPAR property. For example, an article can 
`po:contain` a secion and this section can `po:contain` another (sub-)section.
In our view, this means that also the article contains the (sub-)section. Thefore
we define `po:contains` as a transitive property.

```
<<Model>>=

po:contains rdf:type owl:TransitiveProperty .
@
```

#### Class Definition: *Publisher*

The publisher of a journal, a type of `foaf:Agent`.

```
<<Model>>=

:Publisher rdf:type owl:Class ;
  rdfs:label "Publisher"@en ;
  rdfs:comment "The publisher of a journal, a type of `foaf:Agent`."@en ;
  rdfs:subClassOf foaf:Agent .
@
```

#### Class Definition: *Taxonomic Article*

`:TaxonomicArticle` is a specialized journal article for publishing taxonomic findings.

```
<<Model>>=

:TaxonomicPaper rdf:type owl:Class;
  rdfs:subClassOf fabio:JournalArticle;
  rdfs:label "Taxonomic Paper"@en .
@
```

#### Example: *Article Metadata*

The main objects of information extraction and retrieval of OpenBiodiv in the
first stage of its development are scientific journal articles from the
journals [Biodiversity Data Journal](http://bdj.pensoft.net/) and
[ZooKeys](http://zookeys.pensoft.net/) and other Pensoft journals.
We model the bibliographic objects around Journal Article, such as Publisher,
and Journal using SPAR.

Note that we type `:treatment` both as `trt:Treatment` (i.e. the rhetorical
element Treatment) and as s `doco:Section` because we view this particular
treatment to also be a structural section of the document.




```
<<Article Metadata>>=

# Example: Article Metadata

:biodiversity-data-journal   rdf:type   fabio:Journal ;
	 skos:prefLabel   "Biodiversity Data Journal"@en ;
	 skos:altLabel   "BDJ"@en ;
	 fabio:issn   "1314-2836" ;
	 fabio:eIssn   "1314-2828" ;
	 frbr:part   :b90f6933-ab5e-4ce1-9379-12de9ef4eaa6 . 

 <http://dx.doi.org/10.3897/BDJ.1.e953>   rdf:type   fabio:TaxonomicArticle ;
	 skos:prefLabel   "10.3897/BDJ.1.e953" ;
	 dc:title   "Casuarinicola australis Taylor, 2010 (Hemiptera: Triozidae),
	   newly recorded from New Zealand"@en ;
	 prism:doi   "10.3897/BDJ.1.e953" ;
	 dc:publisher   "Pensoft Publishers"@en ;
	 fabio:hasPublicationYear   "2013"^^xsd:gYear ;
	 prism:publicationDate   "2013-9-16"^^xsd:date ;
	 dcterms:publisher   :pensoft-publishers ;
	 frbr:realizationOf   :thorpe-2013 .

 :thorpe-2013   rdf:type   :ResearchPaper ;
 	 skos:prefLabel	"Thorpe 2013"
	 skos:altLabel   "paper10.3897/BDJ.1.e953" ;
	 dcterms:creator   :stephen-e-thorpe ;
	 prism:keywords   "Casuarinicola australis"@en ;
	 fabio:hasSubjectTerm   :a2ee4929-90dd-4a7a-aa5c-08836f49d549 . 

 :pensoft-publishers   rdf:type   :Publisher ;
	 skos:prefLabel   "Pensoft Publishers"@en . 

 :stephen-e-thorpe   rdf:type   foaf:Person ;
	 skos:prefLabel   "Stephen E. Thorpe" ;
	 foaf:firstName   "Stephen E." ;
	 foaf:surname   "Thorpe" ;
	 foaf:mbox   "stephen_thorpe@yahoo.co.nz" ;
	 :affiliation   "School of Biological Sciences (Tamaki Campus),
	   University of Auckland, Auckland, New Zealand"@en . 

 :a2ee4929-90dd-4a7a-aa5c-08836f49d549   rdf:type   fabio:SubjectTerm ;
	 rdfs:label   "Casuarinicola australis"@en ;
	 skos:inScheme   :Subject_Classification_Vocabulary . 
@
```

#### Class Definition: *Taxonomic Treatment*

See [Plazi](http://plazi.org/) for a theoretical discussion of Treatment.

A treatment is a rhetorical element of a taxonomic article. Thus, Treatment is defined akin
to Introduction, Methods, etc. from
[DEO, The Discourse Elements Ontology](http://www.sparontologies.net/ontologies/deo/source.html).

```
<<Model>>=

:Treatment a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement , trt:Treatment,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom :TaxonomicArticle ] ;
  rdfs:label "Taxonomic Treatment"@en ;
  rdfs:comment "A rhetorical element of a taxonomic publication, where taxon
    			circumscription takes place."@en ;
  rdfs:comment "Таксономично пояснение или само Пояснение е риторчна част
                от таксономичната статия, където се случва описанието
                на дадена таксономична концепция."@bg .
@
```

#### Example: *Article Structure*


```
<<Article Structure>>=

# Example: Article Structure

<http://dx.doi.org/10.3897/BDJ.1.e953>
  po:contains :casuarinicola-australis-treatment .

:casuarinicola-australis-treatment 
  a doco:Section, trt:Treatment ;
  po:contains :casuarinicola-australis-nomenclature .

:casuarinicola-australis-nomenclature
  a doco:Section, :NomenclatureHeading ;
  po:contains :casuarinicola-australis-nomenclature-heading .

:casuarinicola-australis-nomenclature-heading a trt:TreatmentTitle ;
  cnt:chars "Casuarinicola australis Taylor, 2010" .
@
```

#### Class Definition: *Nomenclature*

A taxonomic nomenclature section, or simply a nomenclature, is a rhetorical
element of a taxonomic publication where nomenclatural acts are published and
nomenclatural statements are made. Nomenclature is a subsection of Treatment.

```
<<Model>>=

:Nomenclature a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement , trt:Nomenclature ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Treatment Nomenclature Section"@en ;
  rdfs:comment "A section of a taxonomic treatment, containing the scientific
    name of the taxon described by the treatment, and citations to previous
    descriptions, designations of type-genus, and type-species,
    and other information."@en .
@
```

#### Class Definition: *Treatment Taxon Name*

Inside the taxonomic nomenclature section, we have the treatment title.

```
<<Model>>=

:NomenclatureHeading a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Nomenclature Heading"@en ;
  rdfs:comment "Inside the taxonomic nomenclature section, we have the treatment
    title (name of the taxon)."@en .
@
```

#### Class Definition: *Taxonomic Treatment Citation List*

Inside the taxonomic nomenclature section, we have a list of citations.

```
<<Model>>=

:NomenclatureCitationList a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement , tp:nomenclature-citation-list ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Nomenclature ] ;
                  rdfs:label "Taxonomic Treatent Citation List"@en ;
  rdfs:comment "A section in a treatment that includes the citation of one or
    several previous treatments of the taxon."@en .                  
@
```
#### Class Definition: *Biology*

Subsection of treatment.
```
<<Model>>=

:Biology a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement, trt:Biology,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Biology Section"@en .
@
```


#### Class Definition: *Description*

Subsection of treatment.

```
<<Model>>=

:Description a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement, trt:Description,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Description Section"@en .
@
```
#### Class Definition: *Diagnosis*

Subsection of treatment.

```
<<Model>>=

:Diagnosis a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement, trt:Diagnosis,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Diagnosis Section"@en .
@
```


#### Class Definition: *Distribution*

Subsection of treatment.

```
<<Model>>=

:Distribution a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement, trt:Distribution ,
                  [ rdf:type owl:Restriction;
                    owl:onProperty po:isContainedBy;
                    owl:someValuesFrom trt:Treatment ];
  rdfs:label "Distribution Section"@en.
@
```


#### Class Definition: *Etymology*

Subsection of treatment.

```
<<Model>>=

:Etymology a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement, trt:Etymology,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Distribution Section"@en .
@
```

#### Class Definition: *Key*

Subsection of treatment.

```
<<Model>>=

:Key a owl:Class;
  rdfs:subClassOf deo:DiscourseElement, trt:Key,
                  [ rdf:type owl:Restriction;
                    owl:onProperty po:isContainedBy;
                    owl:someValuesFrom :TaxonomicArticle ];
  rdfs:label "Identificiation Key"@en.
@
```

#### Class Definition: *MaterialsExamined*

Subsection of treatment.

```
<<Model>>=

:MaterialsExamined a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom trt:Treatment ] ;
  rdfs:label "Materials Examined Section"@en .
@
```


#### Class Definition: *Taxonomic Checklist*

A section in a taxonomic article.

```
<<Model>>=

:Checklist a owl:Class ;
  rdfs:subClassOf deo:DiscourseElement ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
                    owl:someValuesFrom :TaxonomicArticle ] ;
  rdfs:label "Taxonomic Checklist"@en ;
  [ rdf:type owl:Restriction ;
                    owl:onProperty po:isContainedBy ;
  rdfs:comment "A section in a taxonomic article."@en.
@
```

#### Example

In this example, we show how to define a nomenclature section:

```
<<Examples>>=


@
```












### Semantic Model of Biological Nomenclature





#### Class Defintion: *Taxonomic Name Usage*

In the text of taxonomic articles we find strings like "*Heser stoevi*
Deltschev, sp. n.". In our conceptualization these are called *taxonomic name
usages* (TNU's) as they refer to  published scientific names from the domain
of biological systematics. The taxonomic name usage consists of three parts:

1. Taxonomic name: one or more words identifying the taxon (a purported
evolutionary entity in nature). These can be Latinized or take the form of an
identifier.

2. Taxonomic name author. The name-and-year of the author(s) of the taxonomic name.

3. Taxonomic name status containing information about the type of the taxonomic
name usage.

In the example, "*Heser stoevi*" is the binomial Latinized species name,
"Deltschev" is the name of the person who newly coined the name describing the
taxon , and "sp. n." bears taxonomic (and nomenclatural) information
indicating that this is a species new to science.

Modeling-wise, we consider TNU's to be specialized instances of `pext:Mention`
from the [PROTON Extensions module](http://ontotext.com/proton/). Furthermore,
we link the TNU's to the scientific name they are symbolizing via
`pkm:mentions`.

A taxon name usage is the mentioning of a taxon name or a taxon concept label
(see later) in a text, together with possibly an taxonomic status.

```
<<Model>>=

:TaxonomicNameUsage rdf:type owl:Class ;
  rdfs:subClassOf  pext:Mention ;
  rdfs:comment "A taxonomic name usage is the mentioning of a taxonomic name
    (scientific name, taxonomic concept label, etc.), optionally with 
    a taxonomic status."@en ;
  rdfs:label "Taxonomic Name Usage"@en .

dwciri:taxonomicStatus rdf:type owl:ObjectProperty ; 
  rdfs:label "taxonomic status"@en ;
  rdfs:comment "the IRI version of the DwC term taxonmic status"@en .
@
```

In the logic of our algorithms, it is very important that TNU's are
dated with `dc:date`.

#### Example

In the following example, we express in RDF a TNU that is in the
nomenclature heading of a treatment (treatment title). Structurally, the TNU
is connected to the containing section via `po:contains`; `cnt:chars` is used
to dump the full string of the usage and DwC properties are used to encode
more granular information in addition to the dump.

In the second step of RDF-ization, we use `dwciri` properties to link the TNU
to semantic entities. `dwciri:taxonomicStatus` is used to link the TNU to an
item in the
[OpenBiodiv Taxonomic Status Vocabulary](#vocabulary-of-taxon-classification).
`:scientificName` is used to link the TNU to the IRI of the name that
the TNU is mentioning. Note, we have introduced `:scientificName` as
a sub-property of `pext:Mention`. In this example it is linked both to local
name and to a remote name. This implies that the names are the same (see Rule
later).

Also, during the second step, the TNU is linked to the reified taxon concept
label *Heser stoevi* sec. 10.3897/BDJ.4.e10095 via `:taxonConceptLabel` as
even though the character content of the TNU does not contain an "according
to" (usually abbreviated as "sec."), we know for certain which concept the
author is invoking as we are in the treatment title (current concept/ *this*
concept).

```
<<Taxonomic Name Usage>>=

:casuarinicola-australis-nomenclature-heading
  po:contains :casuarinicola-australis-TNU .

:casuarinicola-australis-TNU a :TaxonomicNameUsage ;
  dc:date "2013-9-16"^^:xsd:date ;
  cnt:chars "Casuarinicola australis Taylor, 2010" ;
  dwc:genus "Casuarinicola" ;
  dwc:specificEpithet "australis" ;
  dwc:scientificNameAuthorship "Taylor, 2010" ;
  # we can infer the following because we are in the treatment heading
  dwc:nameAccordingToId "doi: 10.3897/BDJ.1.e953" ;
  pkm:mentions :casuarinicola-australis-taylor, 
  			   :casuarinicola-australis-taylor-sec-thorpe-2013 .

:casuarinicola-australis-taylor a :ScientificName ;
  rdfs:label "Casuarinicola australis Taylor, 2010" ;
  dwc:genus "Casuarinicola" ;
  dwc:specificEpithet "australis" ;
  dwc:scientificNameAuthorship "Taylor, 2010" .

:casuarinicola-australis-taylor-sec-thorpe-2013 a :TaxonomicConceptLabel ;
  rdfs:label "Casuarinicola australis Taylor, 2010 sec. Thorpe 2013" ;
  dwc:genus "Casuarinicola" ;
  dwc:specificEpithet "australis" ;
  dwc:scientificNameAuthorship "Taylor, 2010" .
  dwc:nameAccordingToId "doi: 10.3897/BDJ.1.e953" ;

  # we link to the paper! not the article
  :nameAccordingTo :thorpe-2013 .
@
```


```
<<Examples>>=

:heser-stoevi-nomenclature-heading po:contains :heser-stoevi-TNU .

:heser-stoevi-TNU a :TaxonomicNameUsage ;
  dc:date "2016-08-31"^^xsd:date ;
  cnt:chars
  "Heser stoevi urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 Deltschev sp. n." ;
  dwc:genus "Heser" ;
  dwc:species "stoevi" ;
  dwc:scientificNameId "urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8 (ZooBank)" ;
  dwc:scientificNameAuthorship "Deltschev" ;
  dwc:taxonomicStatus "sp. n." ; dwciri:taxonomicStatus :TaxonDiscovery ;
  dwc:nameAccordingToId "10.3897/BDJ.4.e10095" ;

  :scientificName :heser-stoevi-deltshev ;
  :nameAccordingTo <http://dx.doi.org/10.3897/BDJ.4.e10095> ;
  :taxonConceptLabel :heser-stoevi-sec-deltshev ;

  :scientificName <http://zoobank.org/urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8> .

:heser-stoevi-deltshev owl:sameAs <http://zoobank.org/urn:lsid:zoobank.org:act:E4D7D5A0-D649-4F5E-9360-D0488D73EEE8> .
@
     
```



#### Class Defintion: *Taxonomic Name*

```
<<Model>>=

:TaxonomicName rdf:type owl:Class ;
	skos:prefLabel "Taxonomic Name"@en ;
    skos:altLabel "Biological Name"@en ;
    owl:equivalentClass nomen:NOMEN_0000030 .
@
```

In OpenBiodiv, we reify biological names.

In our conceptualization, taxa in nature are things (referents) that are
refered to by our thoughts, theories and concepts (references) that are
labeled or symbolized by by  biological names
([semiotic triangle](https://de.wikipedia.org/wiki/Semiotisches_Dreieck)).

Biological names play a dual role, however, in our system as they are also
concepts, i.e. references of taxonomic name usages. A biological name may
symbolize more than one taxon concept. It is useful to think of biological
names then as taxon concept lineages. More about taxon concepts later.
 
Biological names have been modeled elsewhere such as for example in
[NOMEN](https://github.com/SpeciesFileGroup/nomen). However, NOMEN takes the
approach of using non-human-readable identifiers and only relying on labels to
identify classes of taxonomic names, which does not fit our workflow. For
example, the identifier for the class "biological name" is `NOMEN_0000030`. In
our workflow both RDF generation and debugging would be severely hampered by
this convention. Therefore, OpenBiodiv names use human-readable identifiers.


#### Class Definition: *Scientific Name*

```
<<Model>>=

:ScientificName rdf:type owl:Class ;
    rdfs:subClassOf :TaxonomicName ;
    rdfs:label "Scientific Name"@en ;
    owl:equivalentClass  nomen:NOMEN_0000036 .
@
```

#### Class Definition: *Latinized Scientific Name*

```
<<Model>>=

:LatinName rdf:type owl:Class ;
    rdfs:subClassOf :ScientificName ;
    skos:prefLabel "Latinized Scientific Name"@en ;
    skos:altLabel "Linnaean Name"@en .
@
```

#### Class Definition: *Taxon Concept Label*

We further introduce the class of taxon
concept labels, unknown to NOMEN that is a biological name plus a reference to
its description, i.e. it is the label of taxon concept. A taxon concept label
is a taxonomic name usage accompanied by an additional part, consisting of
"sec." + an identifier or a literature reference of a work containing the
expression of a taxon concept (for example a treatment).*


```
<<Model>>=

:TaxonConceptLabel rdf:type owl:Class ;
  rdfs:subClassOf :LatinName ;
  rdfs:label "Taxon Concept Label"@en ;
  rdfs:comment "A taxon concept label is a taxonomic name
    usage accompanied by an additional part, consisting of 'sec.' + an identifier
    or a literature reference of a work containing the expression of a taxon concept
    (treatment)."@en .
@
```


```
<<Model>>=

:OTU_Id rdf:type owl:Class ;
  rdfs:subClassOf :ScientificName ;
  rdfs:label "Operatational Taxonomic Unit Id"@en ;
  rdfs:comment "The identifier of an Operational Taxonomic Unit, such as
    BOLD BIN or a Unite SH ID"@en .
@
```


#### Class Definition: *Vernacular Name*

```
<<Model>>=

:VernacularName a owl:Class ;
  rdfs:subClassOf :TaxonomicName ;
  rdfs:label "Vernacular Name"@en ;
  owl:equivalentClass nomen:NOMEN_0000037 .
@
```


We do not model scientific names down to the level of the Codes as NOMEN does.
For example we do not make a distinction between a zoological and a botanical
name. Nothing prevents us, however, from creating derived classes later on.
This means that our model is somewhat less granular but compatible with NOMEN.

For properties of biological names we take a different path from NOMEN. We
also use different sets of properties to define relationships between
biological names and for their data properties.

For data properties we use DwC terms.

To connect different biological objects such as taxon concepts or occurrences
to a scientific name we use `:scientificName`, which is derived from
`dwciri:scientificName`. Even though `dwciri:scientificName` is defined  in
spirit in
<http://rs.tdwg.org/dwc/terms/guides/rdf/index.htm#2.5_Terms_in_the_dwciri:_namespace>,

To the best of our knowledge, no formal definition of `dwciri:scientificName` exists in RDF.
Therefore, it has been introduced it here together with a super-property to refer to a more broader
class of names.

#### Property Definition: *has taxonomic name*

```
<<Model>>=

:taxonomicName rdf:type owl:ObjectProperty ;
  	rdfs:label "has taxonomic name"@en ;
	rdfs:range :TaxonomicName .
@
```


#### Property Definition: *has scientific name*
```
<<Model>>=

dwciri:scientificName rdf:type owl:ObjectProperty ;
  rdfs:label "scientific name"@en;
  rdfs:comment "the IRI version of dwc:scientificName"@en .

dwciri:nameAccordingTo rdf:type owl:ObjectProperty ;
  rdfs:label "name according to"@en .

:scientificName rdf:type owl:ObjectProperty ;
  rdfs:subPropertyOf :taxonomicName, dwciri:scientificName ;
  rdfs:label "has scientific name"@en ; 
  rdfs:range :ScientificName .

:nameAccordingTo rdf:type owl:ObjectProperty ;
  rdfs:subClassOf dwciri:nameAccordingTo, po:isContainedBy ;
  skos:prefLabel "secundum"@en ; 
  skos:altLabel "sensu"@en
  rdfs:range frbr:Expression ;
  rdfs:comment "The reference to the source in which the specific taxononimic 
    concept circumscription is defined or implied - traditionally signified by
    the Latin 'sensu' or 'sec.'' (from secundum, meaning 'according to').
    For taxa that are relevantly circumscribed by identifications, a reference
    to the keys, monographs, experts and other sources should be given. Should
    only be used with IRI's"@en .
@
```

#### Property Definition: *has vernacular name*

```
<<Model>>=

:vernacularName rdf:type owl:ObjectProperty ;
  rdfs:subPropertyOf :taxonomicName ;
	rdfs:label "has vernacular name" @en ;
	rdfs:range :VernacularName .
@
```

#### Property Definition: *has vernacular name*
```
<<Model>>=

:taxonomicConceptLabel rdf:type owl:ObjectProperty ;
  rdfs:subPropertyOf :scientificName ;
  rdfs:label "has taxon concept label"@en ;
  rdfs:range :TaxonomicConceptLabel .
@
```

```
<<Model>>=

:has_OTU_Id rdf:type owl:ObjectProperty ;
  rdfs:subPropertyOf :scientificName ;
  rdfs:label "has OTU Id"@en ;
  rdfs:range :OTU_Id .
@
```

For relationships between names we introduce two types of relationships:
unidirectional and bidirectional.

#### Property Definition: *has related name'*

 is an object property that we
use in order to indicate that two biological names are related somehow. This
relationship is purposefully vague as to encompass all situations where two
biological names co-occur in a text. It is transitive and reflexive.*

```
<<Model>>=

:relatedName rdf:type owl:ObjectProperty, owl:TransitiveProperty, owl:ReflexiveProperty ;
  rdfs:label "has related name"@en ;
  rdfs:domain :TaxonomicName ;
  rdfs:range :TaxonomicName ;
  rdfs:comment "'has related name' is an object property that we
    use in order to indicate that two taxnomic names are related somehow. This
    relationship is purposely vague as to encompass all situations where two
    taxonomic names co-occur in a text. It is transitive and reflexive."@en.
@
```

#### Property Definition: *has replacement name*

This is a uni-directional property. Its meaning
is that one one biological name links to a different biological name via the
usage of this property, then the object of the triple is the form of the
biological name the use of which is more accurate and should be preferred
given the information that system currently holds. This property is only
defined for scientific names.*

```
<<Model>>=

:replacementName rdf:type owl:ObjectProperty ,
                          owl:TransitiveProperty ;
  rdfs:label "has replacement name"@en ;
  rdfs:domain :LatinName ;
  rdfs:range :LatinName ;
  rdfs:comment "This is a uni-directional property. Its meaning
    is that one Linnaean name links to a different Linnaean name via the
    usage of this property, then the object name is more accurate and should be
    preferred given the information that system currently holds. This property is only
    defined for Linnaean names."@en.
@
```

#### Rules for Names

TODO: create example for the rules
TODO: Above nesting with 5-hashesh is wrong

**Rule 1 for Names:** *If there is no taxonomic name usage with the status
`:UnavailableName` mentioning a taxonomic name X, or there does exist a TNU Y
mentioning X with the status of `:UnavailableName`, but there also exists a
TNU Z mentioning X with a later date than Y, which has the status of
`:AvailableName` or `:ReplacementName`, then X has the taxon status of
`:AvailableName`.*

```
<<Rules>>=

# rules need to be evaluated in the order here
# I. set all names that have not been made unavailable to available
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
@
```

**Rule 2 for Names:** *For a scientific name X, if it is mentioned in the
heading of a nomenclature section (treatment title) in a TNU Y with status
`:ReplacementName`, then every name Z_i, mentioned in the nomenclatural
citation list in TNU's with status `:UnavailableName` is linked to X via
`:replacementName`.*

```
<<Rules>>=

 # II. Link replacement names
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

**Rule 3 for Names:** *All names in the nomenclature section are linked via `:relatedName`.*

```
<<Rules>>=

 # III. if two names are mentioned in the same nomenclature
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

**Rule 4 for Names:** *If for a name X, there exists a TNU Y If a TNU is
marked as `:Conserved`, then the name is also marked as `:Conserved`. A
conserved name should not be made `:Unavailable`!*


```
<<Rules>>=

 # IV. Conserved names

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

TODO: As an aside, I'll send you the current ASP nomenclature manuscript galley proof. (and code..) Nico

**Rule 5 for Names:** *If a TNU points to two different names with `dwciri:scientificName`, then
they are the same:*


```
<<Rules>>=

 # V. Conserved names

INSERT {
    ?name1 owl:sameAs ?name2 .
}
WHERE {
  ?name1 a :ScientificName .
  ?name2 a :ScientificName .
  ?t a :TaxonomicNameUsage ;
   t dwciri:scientificName ?name1, ?name2 .
  FILTER( ?name1 != ?name2 ) .
@
```

**Example** We go back to the example of  *Heser stoevi*. The meaning of the
date property here is to indicate when was the taxonomic status assumed.

```
<<Examples>>= 

:heser-stoevi-deltshev a :ScientificName ;
	skos:prefLabel "Heser stoevi Deltshev" ;
    dwc:species "stoevi" ;
    dwc:genus "Heser" ;
    dwc:taxonRank "species" ;
    dwciri:taxonomicStatus <http://rs.gbif.org/vocabulary/gbif/taxonomicStatus/accepted> ;
    dwc:scientificNameAuthorship "Deltschev" ;
    dc:date "2016-08-31"^^xsd:date .
@
```

**Example.** Let's take another example, the paper
<http://bdj.pensoft.net/articles.php?id=8030&instance_id=2809105>. From it, we
can say:

```
<<Examples>>= 

:nomenclature-bdje8030 a trt:Nomenclature ;
  po:contains :nomenclature-heading-bdje8030, :cit-list-bdje8030 .

:nomenclature-heading-bdje8030 a :NomenclatureHeading ;
  po:contains :harmonia-manillana-tnu-heading .

:cit-list-bdje8030 a trt:NomenclatureCitationList ;
  po:contains :leis-papuensis-tnu-citation .

:harmonia-manillana-tnu-heading a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^^xsd:date ;
  cnt:chars "Harmonia manillana (Mulsant, 1866)" .

:leis-papuensis-tnu-citation a :TaxonomicNameUsage ;
  dc:date "2016-08-16"^^xsd:date ;
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
  dc:date "2016-08-16"^^xsd:date ; 
  dwc:taxonomicStatus :Available ;
  :relatedName :leis-papuensis .

:leis-papuensis a :ScientificName ;
  skos:prefLabel "Leis papuensis" ;
  dwc:species "papuensis" ;
  dwc:genus "Leis" ;
  dwc:taxonRank "species" ;
  dc:date "2016-08-16"^^xsd:date ; 
  dwciri:taxonomicStatus :Unavailable ;
  :replacementName :harmonia-manillana-mulsant-1866 ;
  :relatedName :harmonia-manillana-mulsant-1866 .
@
```

### Taxonomic Concepts

#### Class Definition: *Taxonomic Concept*

Our view of taxon concepts is based on
[Berendsohn (1995)](http://www.jstor.org/stable/1222443) and
[Franz et al (2008)](http://dx.doi.org/10.1201/9781420008562.ch5).

We consider any given taxon concept to be a scientific theory (concept) about
a class of biological organisms (taxon). The class description, as in "as in
all spiders have spinnerets (silk-producing glands)" (Nico Franz, personal
correspondence), is called *intensional meaning,* whereas the group of
organisms in nature conforming with the intensional meaning is called the
class *extension.*

We want to model both the intensional meaning (which traits do organisms
belonging to a taxon have) and the extension of taxon concepts (which
organisms belong to a taxon) and the extensions being organisms that are
considered to be members of the class.

This necessitates the view that taxon concepts are both instances of a taxon
concept class and are classes of ogranisms. Later, we will show that this
means that we model Taxon Concepts with OWL Full.

OpenBiodiv taxon concepts are instances of `dwc:Taxon` and vice versa (*"A
group of organisms [sic] considered by taxonomists to form a homogeneous
unit."*).

Also, taxon concepts are instances of `frbr:Work` as well, but not vice versa
(*"A distinct intellectual or artistic creation. A work is an abstract entity;
there is no single material object one can point to as the work. We recognize
the work through individual realizations or expressions of the work, but the
work itself exists only in the commonality of content between and among the
various expressions of the work. When we speak of Homer's Iliad as a work, our
point of reference is not a particular recitation or text of the work, but the
intellectual creation that lies behind all the various expressions of the
work."*).

Furthermore, taxon concepts can also be modeled as `skos:Concept`, but not
vice versa (*"A SKOS concept can be viewed as an idea or notion; a unit of
thought. However, what constitutes a unit of thought is subjective, and this
definition is meant to be suggestive, rather than restrictive."*).

All three classes represent a distinctive view that we want to adopt in
modeling different features of taxon concepts.

Holding the views of Berendsohn and of Franz, we require that each taxon
concept is linked to both a biological name and to a work (i.e. publication,
database, etc.), where the circumscription is properly defined.

```
<<Model>>=

:OperationalTaxonomicUnit rdf:type owl:Class ;
  rdfs:subClassOf skos:Concept, frbr:Work , 
  rdfs:label "Operational Taxonomic Unit"@en;
  rdfs:commnet "A superclass for all kinds of taxonomic hypothesis"@en .

:TaxonomicConcept rdf:type owl:Class ;
  owl:equivalentClass dwc:Taxon ;
  rdfs:subClassof :OperationalTaxonomicUnit ,
                  [ rdf:type owl:Restriction ;
                    owl:onProperty :taxonomicConceptLabel ;
                    owl:minCardinality "1" ] ;
  rdfs:comment "A taxonomic concept in the sense of Berendsohn"@en .
@
```

**Example.** In the next example we introduce the concept of *Heser stoevi*
according to the article published by Deltshev in 2016. First, we introduce an
instance of `:TaxonConcept` and link this instance to the scientific name
*Heser stoevi* via the appropriate DwC term. Next, we establish a link between
the significant bibliographic unit (in this case journal article) containing
the treatment, which is the realization of the taxon concept. The last point
we would like to make is that the taxon concept label, which is in this case
`Heser stoevi sec. 10.3897/BDJ.4.e100095` is constructed by pasting together
the label of the biological name and the expression that are assigned to the
concept glued together by `sec.`.

```
<<Examples>>=

:heser-stoevi-sec-deltshev a :TaxonConceptLabel ;
   skos:prefLabel "Heser stoevi Deltshev sec. 10.3897/BDJ.4.e10095" ;
   dwc:species "stoevi" ;
   dwc:genus "Heser" ;
   dwc:taxonRank "species" ;
   dwc:scientificNameAuthorship "Deltschev" ;
   ::nameAccordingTo <http://dx.doi.org/10.3897/BDJ.4.e10095> .
  
:concept-deltshev-2016 a :TaxonConcept ;
  :taxonConceptLabel :heser-stoevi-sec-deltshev .

:heser-stoevi-sec-gbif20170323 a :TaxonConceptLabel ;
  skos:prefLabel "Heser stoevi sec. doi:10.15468/39omei" ;
  dwciri:scientificName :heser-stoevi-deltshev ;
  dwciri:nameAccordingTo :gbif20170323 .

:concept-gbif a :TaxonConcept ;
  :taxonConceptLabel :heser-stoevi-sec-gbif20170323 .

<http://dx.doi.org/doi:10.15468/39omei> a fabio:Database ;
  skos:prefLabel "GBIF Backbone Taxonomy" ;
  skos:altLabel "doi:10.15468/39omei" ;
  prism:doi "doi:10.15468/39omei" ; 
  dc:date "2017-03-23"^^xsd:date ;
  rdfs:comment "A dump of GBIF's backbone taxonomy on 23 Mar 2017."@en ;
  po:contains [ a :TaxonConceptLabel ;
                dc:date "2017-03-23"^^xsd:date ;
                dwc:scientificName "Heser stoevi Deltshev, 2016" ;
                dwc:nameAccordingTo "GBIF Backbone Taxonomy" ;
                dwciri:nameAccordingTo <http://dx.doi.org/doi:10.15468/39omei> ;
                dwciri:scientificName :heser-stoevi-deltshev ;
                pkm:mentions :heser-stoevi-sec-gbif20170323  ] .
@
```

Note that in the above example one scientific name, *Heser stoevi*, is linked
to two different taxon concept labels, as one taxon concept label denotes the
concept coming from the article and the other one comes from the GBIF
database.

It is possible to express that these are the same thing, that one is a
subconcept of the other, or even more granular relationships.

#### Taxon Concept Relationships

**Example congruence 1.** If we want to express that two concepts
are exactly the same both intensionally and ostensively, then we use `owl:sameAs`.
However, if we want to express that the taxon concepts have the same extension
without being equal intensionally (as in the spider example), then we use
`owl:equivalentClass`.

```
<<Examples>>=

:heser-stoevi-sec-deltschev owl:sameAs :heser-stoevi-sec-gbif20170323 .
@
```

Note that this will copy both taxon concept labels both ways, but this is OK
as the different taxon concept labels refer to the same class.

**Example congruence 2.** Let's define the two spider concepts here.

```
<<Examples>>=

:haveSpinnerets rdf:type owl:DatatypeProperty ;
  rdfs:domain :TaxonConcept ; 
  rdfs:comment "This property if true, indicates that some taxon has spinnertes." .

:havePedipals rdf:type owl:DataTypeProperty ;
  rdfs:domain :TaxonConcept ;
  rdfs:comment "If this property is true, that the taxon has pedipals" .

:spiders-with-spinnerets-sec-rdfguide a :TaxonConceptLabel ;
  dwc:order "Araneae" ;
  skos:prefLabel "Araneae sec. OpenBiodiv RDF Guide" ;
  :nameAccordingTo <https://github.com/pensoft/OpenBiodiv/blob/master/Ontology/RDF_Guide.md> .

:spiders-with-pedipals-sec-rdfguide a :TaxonConceptLabel ;
  dwc:order "Aranea" ;
  skos:prefLabel "Araneae sec. OpenBiodiv RDF Guide" ;
  :nameAccordingTo <https://github.com/pensoft/OpenBiodiv/blob/master/Ontology/RDF_Guide.md> .

:concept-spinnerets a :TaxonConcept ;
  :taxonConceptLabel :spiders-with-spinnerets-sec-rdfguide ;
  :haveSpinnerrets "true"^^xsd:boolean .

:concept-pedipals a :TaxonConcept ;
  :taxonConceptLabel :spiders-with-pedipals-sec-rdfguide ;
  :havePedipals "true"^^xsd:boolean .

:spider1 a :concept-spinnerts .
:spider2 a :concept-pedipals .

:concept-spinnerts owl:equivalentClass :concept-pedipals .
@
```

Here, the implication is that although the intensional meaning of the two concepts
is different, they have the same class extension. I.e. we will infer

```
:spider1 a :concept-pedipals;
:spider2 a :concept-spinnerts'
```

but we will not copy any of the `:havePedipals` or `:haveSpinnerts` to the other concept.

**Example of contained concepts.** For contained concept we use `rdfs:subClassOf`:

```
<<Examples>>=

:animalia-sec-gbif a :TaxonConceptLabel ;
  skos:prefLabel "Animalia sec. GBIF Backbone Taxonomy" ;
  dwciri:scientificName :animalia ;
  :nameAccordingTo <http://dx.doi.org/doi:10.15468/39omei> .

:animalia a :ScientificName ;
  dwc:scientificName "Animalia" ;
  dwc:taxonRank "kingdom" ;
  dc:date "2017-03-23"^^xsd:date ;
  dwciri:taxonomicStatus :Available .

:concept-animalia-gbif a :TaxonConcept ;
  dwciri:scientificName :animalia ;
  dwc:taxonId "1 (GBIF)" .

:heser-stoevi-sec-gbif20170323 rdfs:subClassOf :animlia-sec-gbif20170323 .
@
```

**Example (Relatedness)** If two taxon concepts are related we can use `skos:related`.

```
<<Examples>>=

:heser-nicola a :ScientificName ;
  dwc:scientificName "Heser nilicola (O. P.-Cambridge, 1874)" ;
  skos:prefLabel "Heser nilicola" ;
  dwc:genus "Heser" ;
  dwc:species "nilicola" ;
  dwc:taxonRank "species" .

:heser-nicola-sec-unibe a :TaxonConceptLabel ;
  skos:prefLabel "Heser nilicola (O. P.-Cambridge, 1874) sec. Unibe" ;
  dwciri:scientificName :heser-nicola ;
  frbr:realization <http://www.araneae.unibe.ch/data/3301> .

:concept-heser-nicola-unibe a :TaxonConcept ;
  :taxonConceptLabel :heser-nicola-sec-unibe .

:heser-stoevi-deltschev-sec-deltschev skos:related :heser-nicola-sec-unibe .
@
```


#### Complex Relationships with RCC-5

**Def.: *A set of properties describing RCC-5 relations.*

```
<<Model>>=

:RCC5Statement rdf:type owl:Class ;
  rdfs:label "RCC5 Statement" ;
  rdfs:comment "A statemnt of RCC-5 relationship" .

:rcc5Property rdf:Type owl:ObjectProperty ;
  rdfs:domain :RCC5Statement .

:rcc5fromRegion rdf:type owl:ObjectProperty ;
  rdfs:subPropertyOf :rcc5Property ;
  rdfs:label "from region" ;
  rdfs:comment "Connects to the RCC5 statement to the originating region"@en .

:rcc5toRegion rdf:type owl:ObjectProperty ;
  rdfs:label "to region" ;
  rdfs:subPropertyOf :rcc5Property ;
  rdfs:comment "Connects to the RCC5 statement to the target region"@en .

:rcc5RelationType rdf:type owl:ObjectProperty ;
  rdfs:label "relation type" ;
  rdfs:subPropertyOf :rcc5Property ;
  rdfs:range :RCC5Relation ;
  rdfs:comment "Connects an RCC-5 statement to the type of RCC-5 relation between the regions."@en .

<<Vocabulary of RCC5 Terms>>
@
```

In order to model complex RCC-5 statements such as those made in
[Jansen & Franz 2015](https://doi.org/10.3897/zookeys.528.6001) we use 
the above defitions and the RCC5 Vocabulary described in the Appendix.

We model the following exceprt here:

"Minyomerus microps (Say, 1831: 9) sec. Jansen & Franz (2015), stat. n.  ==
(INT) AND > (OST) AND = Minyomerus innocuus Horn, 1876: 18 sec. Horn (1876) (type, designated by Pierce 1913: 400), syn. n."

```
<<Examples>>=

:jansen-franz-2015 a fabio:JournalArticle ;
  skos:prefLabel "10.3897/zookeys.528.6001" . 

:concept-minyomerus-microps-jansen-franz a :TaxonConcept .

:concept-minyomerus-innocuus-horn a :TaxonConcept .

:microps-innocuus-relation-int a :RCC5Stament ;
  :rcc5FromRegion :concept-minyomerus-microps-jansen-franz ;
  :rcc5ToRegion :concept-minyomerus-innocuus-horn ;
  :rcc5RelationType :Equals_INT ;
  frbr:expression :jansen-franz-2015 .

:microps-innocuus-relation-ost a :RCC5Stament ;
  :rcc5FromRegion :concept-minyomerus-microps-jansen-franz ;
  :rcc5ToRegion :concept-minyomerus-innocuus-horn ;
  :rcc5RelationType :InverseProperPart_OST ;
  frbr:expression :jansen-franz-2015 .
@
```

#### The rest of Biodiversity Sysmtematics

We follow the Darwin-SW model.

## Apendicies

### Vocabulary of Taxonomic Statuses

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
<<Vocabulary of Taxonomic Statuses>>=

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
  fabio:hasDiscipline <http://dbpedia.org/page/Taxonomy_(biology)> .

<<Taxonomic Uncertainty>>
<<Taxon Discovery>>
<<Replacement Name>>
<<Unavailable Name>>
<<Available Name>>
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
  rdfs:Label "Available Name"@en ;
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

[type_species_designation.txt](R/type_species_designation.txt)

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

[type_specimen_designation.txt](R/type_specimen_designation.txt)

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


### Vocabulary of RCC5 Terms

 
```
<<Vocabulary of RCC5 Terms>>=
:RCC5Relation rdf:type owl:Class ;
  rdfs:subClassOf [ rdf:type owl:Restriction ;
                    owl:onProperty <http://www.w3.org/2004/02/skos/core#inScheme> ;
                    owl:someValuesFrom :RCC5RelationTerms ] ;
  rdfs:label "RCC5 Relation"@en ;
  rdfs:comment "The of RCC 5 relation, e.g. 'partially overlaps'"@en .

:RCC5RelationTerms rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :RCC5Relation] ;
  rdfs:label "OpenBiodiv Vocabulary of RCC5 Relations"@en .

:Equals_INT rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Equals (INT)" ;
  rdfs:comment "= EQ(x,y) Equals (intensional)"@en . 

:ProperPart_INT rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Proper Part (INT)" ;
  rdfs:comment "< PP(x,y) Proper Part of (intensional)"@en .

:InverseProperPart_INT rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Inverse Proper Part (INT)" ;
  rdfs:comment "iPP(x, y) Inverse Proper Part (intensional)"@en .

:PartiallyOverlaps_INT rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Partially Overlaps (INT)" ;
  rdfs:comment "o PO(x,y) Partially Overlaps (intensional)"@en .

:Disjoint_INT rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Disjoint (INT)" ;
  rdfs:comment "! DR(x,y) Disjoint from (intensional)."@en .

:Equals_OST rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Equals (OST)" ;
  rdfs:comment "= EQ(x,y) Equals (ostensive)"@en . 

:ProperPart_OST rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Proper Part (OST)" ;
  rdfs:comment "< PP(x,y) Proper Part of (ostensive)"@en .

:InverseProperPart_OST rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Inverse Proper Part (OST)" ;
  rdfs:comment "iPP(x, y) Inverse Proper Part (ostensive)"@en .

:PartiallyOverlaps_OST rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Partially Overlaps (OST)" ;
  rdfs:comment "o PO(x,y) Partially Overlaps (ostensive)"@en .

:Disjoint_OST rdf:type :RCC5Relation ;
  skos:inScheme :RCC5RelationTerms ;
  rdfs:label "Disjoint (OST)" ;
  rdfs:comment "! DR(x,y) Disjoint from (ostensive)."@en .
@
```

### Vocabulary of Paper Types

TODO: Future work

**Def.:** Pensoft's journals have some
paper types, which we define herein. First of all, we introduce Paper Types as
a Term Dictionary in the discipline of Bibliography. Then we introduce the
different paper types as Subject Term's in the scheme of Paper Types. See the
SPAR ontologies for more info on this this.

```
<<Vocabulary Paper Types>>=


:PaperTypeTerms rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :PaperType] ;
  rdfs:label "Paper Types Vocabulary"@en ;
  rdfs:comment "A list of paper (article) types published in Pensoft's
                journals"@en ;
  fabio:hasDiscipline dbpedia:Bibliography .

:PaperType rdf:type owl:Class ;
  rdfs:subClassOf [ rdf:type owl:Restriction ;
                    owl:onProperty <http://www.w3.org/2004/02/skos/core#inScheme> ;
                    owl:someValuesFrom :PaperTypeTerms ] ;
  rdfs:label "Paper Type"@en ;
  rdfs:comment "A Specific Type Of Paper"@en .

:SingleTaxonTreatment a PaperType ;
  rdfs:label "Single Taxon Treatment"@en; 
  rdfs:comment "A type of paper with only one taxonomic treatment"@en ;
  skos:inScheme pensoft:PaperTypes .
@
```

TODO: Extract paper types.

### Vocabulary of Taxon Classification

TODO: Future work

**Def. 10 of controlled vocabulary (Taxon Classification):** Pensoft, in its
Keywords uses certain taxon names for the classification of its papers. These
taxon names are borrowed from GBIF. Here we define a term dictionary
analogously to paper types:

```
<<Vocabulary of Taxon Classification>>=

:TaxonClassificationTerms rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :TaxonClassification] ; 
  rdfs:label "Taxonomic Classification"@en ;
  rdfs:comment "A list of taxon names borrowed for GBIF for the 
                classification of papers."@en ;
  fabio:hasDiscipline dbpedia:Taxonomy .
@
```

### Vocabulary of Chronological Classification
TODO: Future work

```
<<Vocabulary of Chronological Classification>>=
:ChronologicalClassificationTerms rdf:type owl:Class ;
  rdfs:subClassOf <http://www.w3.org/2004/02/skos/core#ConceptScheme> ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty fabio:isSchemeOf ;
                                  owl:allValuesFrom :ChronologicalClassigication] ; 
  rdfs:label "Chronological Classification"@en ;
  rdfs:comment "A vocabulary of chronological eras that can be used in
                Pensoft's journals"@en ; 
  fabio:hasDiscipline dbpedia:Paleontology .
@
```


## Directly imported external ontologies

Some third party ontologies cannot be imported via `owl:imports` for various
reasons (updated versions that we don't use, broken links, etc.) We add the
objects that we borrow from them here.


# Parts of PROTON

```
<<Borrowed Parts from External Ontology>>= 

ptop:Entity rdf:type owl:Class ;
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
      rdfs:comment "A direct link between an information resource, like a document or a section and an entity." ;
      rdfs:domain ptop:InformationResource ;
      rdfs:label "mentions" ;
      rdfs:range ptop:Entity .

pext:Mention rdf:type owl:Class ;
             rdfs:subClassOf ptop:InformationResource ;
             rdfs:comment "An area of a document that can be considered a mention of something."@en ;
             rdfs:label "Section" .
@
```
