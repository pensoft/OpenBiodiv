---
author:
- 'Viktor <span style="font-variant:small-caps;">Senderov</span>'
bibliography:
- 'openbiodiv.bib'
---

<span style="font-variant:small-caps;">Doctoral Thesis</span>\
\

****

\

*Author:*\
[](http://www.johnsmith.com)

*Supervisor:*\
[](http://www.jamessmith.com)

\

*A thesis submitted in fulfillment of the requirements\
for the degree of*\
*in the*\
\
\

\

\[part-introduction\]

Introduction {#chapter-introduction}
============

Importance of the Topic
-----------------------

The desire for an integrated information system serving the needs of the
biodiversity community dates at least as far back as 1985 when the
Taxonomy Database Working Group (TDWG)—later renamed to Biodiversity
Informatics Standards but retaining the abbreviation—was
established[^1]. In 1999, the Global Biodiversity Information Facility
(GBIF) was created[^2] after the Organization for Economic Cooperation
and Development (OECD) had arrived at the conclusion that “an
international mechanism is needed to make biodiversity data and
information accessible worldwide”. The Bouchout declaration[^3] crowned
the results of the E.U.-funded project pro-iBiosphere[^4] (2012 - 2014)
dedicated to the task of creating an integrated biodiversity information
system. The Bouchout declaration proposes to make scholarly biodiversity
knowledge freely available as Linked Open Data. A parallel process in
the U.S.A. started even earlier with the establishment of the Global
Names Architecture ([@patterson_names_2010; @pyle_towards_2016]).

Overview of the Main Results in the Area
----------------------------------------

In the biomedical domain there are well-established efforts to extract
information and discover knowledge from literature
([@momtchev_expanding_2009; @williams_open_2012; @rebholz-schuhmann_facts_2005]).
The biodiversity domain, and in particular biological systematics and
taxonomy (from here on in this thesis referred to as *taxonomy*), is
also moving in the direction of semantization of its research outputs
([@kennedy_scientific_2005; @penev_fast_2010; @tzitzikas_integrating_2013]).
The publishing domain has been modeled through the Semantic Publishing
and Referencing Ontologies (SPAR Ontologies) ([@peroni_semantic_2014]).
The SPAR Ontologies are a collection of ontologies incorporating—amongst
others—FaBiO, the FRBR-aligned Bibliographic Ontology
([@peroni_fabio_2012]), and DoCO, the Document Component Ontology
([@constantin_document_2016]). The SPAR Ontologies provide a set of
classes and properties for the description of general-purpose journal
articles, their components, and related publishing resources. Taxonomic
articles and their components, on the other hand, have been modeled
through the TaxPub XML Document Type Definition (DTD) (also referred to
loosely as XML schema) and the Treatment Ontologies
([@catapano_taxpub:_2010; @catapano_treatment_nodate]). While TaxPub is
the XML-schema of taxonomic publishing for several important taxonomic
journals (e.g. ZooKeys, Biodiversity Data Journal), the Treatment
Ontologies are still in development and have served as a conceptual
template for OpenBiodiv-O (discussed in Chapter \[chapter-ontology\]).

Taxonomic nomenclature is a discipline with a very long tradition. It
transitioned to its modern form with the publication of the Linnaean
System ([@linnaeus_systema_1758]). Already by the beginning of the last
century, there were hundreds of vocabulary terms (e.g. *types*)
([@witteveen_naming_2015]). At present the naming of organismal groups
is governed by by the International Code of Zoological Nomenclature
(ICZN)
([@the_international_trust_for_zoological_nomenclature_london_uk_international_1999])
and by the International Code of Nomenclature for algae, fungi, and
plants (Melbourne Code) ([@mcneill_international_2012]). Due to their
complexity (e.g. ICZN has 18 chapters and 3 appendices), it proved
challenging to create a top-down ontology of biological nomenclature.
Example attempts include the relatively complete NOMEN ontology
([@dmitriev_nomen_nodate]) and the somewhat less complete Taxonomic
Nomenclatural Status Terms (TNSS, [@morris_taxonomic_nodate]).

There are several projects that are aimed at modeling the broader
biodiversity domain conceptually. Darwin Semantic Web (Darwin-SW)
([@baskauf_darwin-sw:_2016]) adapts the previously existing Darwin Core
(DwC) terms ([@wieczorek_darwin_2012]) as RDF. These models deal
primarily with organismal occurrence data.

Modeling and formalization of the strictly taxonomic domain has been
discussed by Berendsohn ([@berendsohn_concept_1995]) and later, e.g., in
([@franz_perspectives:_2009; @sterner_taxonomy_2017]). Noteworthy
efforts are the XML-based Taxonomic Concept Transfer Schema
([@taxonomic_names_and_concepts_interest_group_taxonomic_2006]) and a
now defunct Taxon Concept ontology ([@devries_taxon_nodate]).

By the time the OpenBiodiv project started in June 2015, a number of
articles had been previously published on the topics of linking data and
sharing identifiers in the biodiversity knowledge space
([@page_biodiversity_2008]), unifying phylogenetic knowledge
([@parr_evolutionary_2012]), taxonomic names and their relation to the
Semantic Web ([@page_taxonomic_2006; @patterson_names_2010]), and
aggregating and tagging biodiversity research
([@mindell_aggregating_2011]). Some partial discussion of OBKMS was to
be found in the science blog
[iPhylo](http://iphylo.blogspot.bg)[^5]$^{,}$[^6]. The legal aspects of
the OBKMS had been discussed by [@egloff_open_2014].

Furthermore, several tools and systems that deal with the integration of
biodiversity and biodiversity data had been developed by different
groups. Some of the most important ones are UBio[^7], Global Names[^8],
BioGuid[^9], BioNames[^10], Pensoft Taxon Profile[^11], and the Plazi
Treatment Repository[^12].

The key findings from the papers cited in the previous paragraphs can be
summarized as follows:

1.  [Biodiversity science deals with disparate types of data:
    taxonomic[^13], biogeographic, phylogenetic, visual, descriptive,
    and others. These data are siloed in unlinked data repositories.]{}

2.  [Biodiversity databases need a universal system of naming concepts
    due to the obsolesce of Linnaean names for modern taxonomy.
    Taxonomic concept labels have been proposed as a human-readable
    solution and stable globally unique identifiers of taxonomic
    concepts had been proposed as a machine-readable solution.]{}

3.  [There is a base of digitized semi-structured biodiversity
    information on-line with appropriate licenses waiting to be
    integrated.]{}

Goal
----

Given the huge international interest in OBKMS, this dissertation
started the OpenBiodiv project, the goal of which is to contribute to
OBKMS by creating an open knowledge-based system of biodiversity
information extracted from scholarly literature. OpenBiodiv
([@senderov_open_2016]) “lifts” biodiversity information from scholarly
publications and academic databases into a computable semantic form.
OpenBiodiv will then serve as the central part of OBKMS to which other
components may be added.

Contributions of the Thesis
---------------------------

In the course of the investigative effort, we have made several
significant contributions. The two equally important key contributions
of the thesis are the creation of an ontology, OpenBiodiv-O (see
Chapter \[chapter-ontology\]), enabling the linking of biodiversity
knowledge on the basis of scholarly publications, and a linked open
dataset, OpenBiodiv LOD (see Chapter \[chapter-lod\]) consisting of a
transformation to Resource Description Framework (RDF) and integration
in a single store of information from three major repositories of
biodiversity data: the journal databases of Pensoft Publishers and
Plazi, and GBIF’s taxonomic backbone.

OpenBiodiv-O, serves as the basis of OpenBiodiv-LOD. By developing an
ontology focusing on biological taxonomy, our intent is to provide an
ontology that fills in the gaps between ontologies for biodiversity
resources such as Darwin-SW and semantic publishing ontologies such as
the ontologies comprising the SPAR Ontologies. Moreover, we take the
view that it is advantageous to model the taxonomic process itself
rather than any particular state of knowledge.

After the populating the ontology, we have developed a web-site (see
Chapter \[chapter-openbiodiv\],
[&lt;http://openbiodiv.net&gt;](http://openbiodiv.net), containing a
semantic search engine and apps running on top of OpenBiodiv LOD.

Furthermore, we have developed two automated workflows—automatic data
paper generation and automatic occurrence record import, see
Chapter \[chapter-case-study\]—between external repositories and the
Pensoft database of biodiversity data.

Last but not least is the creation of a framework for transforming XML
and CSV files to RDF in the R programming language (RDF4R, see
Chapter \[chapter-rdf4r\]).

Structure of the Thesis
-----------------------

The thesis is subdivided into three parts, each containing several
chapters: Introduction, Ontology, and Software. In this chapter, we have
given the raison d’etre of the thesis and outlined its goal and
contributions. In the next chapter, we give a definition of the research
problem and break down the goal into actionable objectives.
Chapter \[chapter-openbiodiv\], in which we define the OpenBiodiv system
as the answer to the research problem, concludes the Introduction part.
In the following two parts, we discuss the implementation of various
parts of the system.

Part \[part-data\], Ontology, is where we introduce the domain, its
existing data models, and develop additional data models where needed.
In Chapter \[chapter-ontology\] we give an conceptualization of the
domain of scientific taxonomic publishing in English and we formalize it
by introducing the central result of this thesis, the OpenBiodiv
Ontology (OpenBiodiv-O) in the Web Ontology Language (OWL). In
Chapter \[chapter-lod\] we describe the Linked Open Dataset that we’ve
generated based on the ontology.

Part \[part-programming\], Software, documents the tools and
infrastructure that we have used to create the dataset and the website
that hosts applications making use of the dataset. In
Chapter \[chapter-case-study\], we discuss two case-studies for
importing data into OpenBiodiv from important international
repositories. In Chapter \[chapter-rdf4r\] we describe in detail the
RDF4R software package, an R package for working with RDF, which was
used to create the LOD.

Problem Definition {#chapter-problem-defintion}
==================

As stated in Chapter \[chapter-introduction\], the goal of the Ph.D.
effort is “to create an open knowledge-based system of biodiversity
information extracted from scholarly literature.” As biodiversity data
is quite heterogeneous and comes from many sources (see the domain
conceptualization in Chapter \[chapter-ontology\]), the scope of the
OpenBiodiv system developed as part of this Ph.D. effort is limited to
providing a base for the more general Open Biodiversity Knowledge
Management System (OBKMS) by creating the models and infrastructure
needed for processing scholarly publications of biological systematics
and taxonomy.

As per the “Principles of OBKMS” from [@pro-ibiosphere_open_2014], the
larger OBKMS ought to meet criteria such as providing “a consistent
biodiversity information space,” “new formats to support novel and
diverse uses,” “linkages with other resources,” “accreditation for
researcher’s work,” and others. Considerations for OBKMS were published
in in the pro-iBiosphere final report
([@soraya_sierra_coordination_2014]). The language of the report is
high-level and does not provide a formal definition for the system but
rather a set of recommendations on the features and implementation of
the system.

In 2016, based on the outcomes of pro-iBiosphere and on the main results
in the area (see Chapter \[chapter-introduction\]), we published the
Ph.D. plan for this thesis as a design specification for the system
([@senderov_open_2016]). However, in the course of developing the
system, its design was changed iteratively through a feedback loop from
collaborators from the BIG4 project consortium[^14], of which the author
is a member of, and various international collaborators. We view this
positively and in the spirit of both open Science (a discussion of open
science follows later in the chapter) and the Manifesto for Agile
Software Development[^15].

Therefore, this chapter should serve as an updated version the Ph. D.
project plan published in 2016 ([@senderov_open_2016]) and as a
birds-eye of the OpenBiodiv system; subsequent chapters contain
discussions of the particular components of the system.

Definition of the OpenBiodiv Knowledge-Based System
---------------------------------------------------

The OpenBiodiv knowledge-based system is a semantic database where
resources is stored in an interlinked format allowing the user of the
system to ask complicated queries. As a blueprint for the type queries
in the domain of biodiversity science that should be answerable with the
help of the system, we have looked at the list compiled in
[@pro-ibiosphere_competency_2013]. Examples include: “Is X a valid
taxonomic name (in a nomenclatorial sense)?” “Which treatments use
different names for the same taxon concepts?” “Which treatments are
nomenclatorially linked (including homonyms!) to another treatment?”

In order to answer such queries present-day search engines make use of a
knowledge graph (TODO cite a paper about Google Knowledge Graph). In the
case of OpenBiodiv, we are going to talk about a biodiversity knowledge
graph. Therefore, we chose a graph database as a data model to represent
biodiversity knowledge. We considered Neo4J and RDF-based triple-stores
and settled on the latter due to the fact that there were already
multiple existing ontologies and RDF datasets in the biodiversity domain
(see Chapter \[chapter-domain-conceptualization\] for a detailed
discussion).

Choice of Information Sources
-----------------------------

According to [@soraya_sierra_coordination_2014], biodiversity and
biodiversity-related data have two different “life-cycles.” In the past,
after an observation had been made, it was recorded on paper and then
it, or a summary of it, was published in paper-based form. In order for
biodiversity data to be available to the modern scientist, efforts are
made nowadays to digitize those paper-based publications by Plazi and
the Biodiversity Heritage Library (Agosti et al. 2007, Miller et al.
2012). For this purpose, several dedicated XML schemas have been
developed (see Penev et al. 2011 for a review), of which TaxPub and
TaxonX seem to be the most widely used (Catapano 2010, Penev et al.
2012). The digitization of those publications contains several steps.
After their scanning and OCR, text mining is combined with a search for
particular kinds of data, which leaves a trace in the form of marked-up
(tagged) elements that can then be extracted and made available for
future use and reuse (Miller et al. 2015).

At the time of writing, biodiversity data and publications are mostly
“born digital” as semantically Enhanced Publications (EP’s,
[@claerbout_electronic_1992; @godtsenhoven_van_emerging_2009; @shotton_semantic_2009]).
According to the first source, “an EP is a publication that is enhanced
with research data, extra materials, post publication data and database
records. It has an object-based structure with explicit links between
the objects. An object can be (part of) an article, a data set, an
image, a movie, a comment, a module or a link to information in a
database.”

Thus, the act of publishing in a digital, enhanced format, differs from
the ground up from a paper-based publication. The main difference is
that the document can be structured in such a format as to be suitable
for machine processing and to the human eye. In the sphere of
biodiversity science, journals of Pensoft Publishers such as ZooKeys,
PhytoKeys, and the Biodiversity Data Journal (BDJ) already function by
providing EP’s ([@penev_semantic_2010]).

Given the fact that Pensoft Publishers’ and Plazi’s publications cover a
large part of taxonomic literature both in volume and also in temporal
span, and the fact that the publications of those two publishers are
available as semantic EP’s, we’ve chosesn Pensoft’s journals and Plazi’s
treatments as our main sources of information.

Choice of Programming Environment
---------------------------------

In recent years the R programming language has been used widely in the
field of data science (TODO some citation). R has a rich library of
software packages including XML (XML2) processing packages and API
access packages (RCurl, [httr]{}) (TODO cite CRAN) and focuses on Open
Science (TODO cite rOpenSci).

As one of the main tasks of the project is to transform semi-structured
data from XML in the framework of open science, we have chosen the R
software environment as the main programming environment.

Consideration of Open Science
-----------------------------

We are of the opinion that the OpenBiodiv needs to be addressed from the
point of view of open science. According to [@kraker_case_2011] and to
“Was ist Open Science?”[^16], the six principles of open science are
open methodology, open source, open data, open access, open peer review,
and open educational resources. It is our belief that the aim of open
science is to ensure access to the whole research product: data,
discoveries, hypotheses, and so on. This opening-up will ensure that the
scientific product is reproducible and verifiable by other scientists
([@mietchen_transformative_2014]). There is a very high interest in
development of processes and instruments enabling reproducibility and
verifiability, as can be evidenced for example by a special issue in
Nature dedicated to reproducible research ([@noauthor_challenges_2010]).
Therefore, the source code, data, and publications of OpenBiodiv will be
published openly.

Objectives
----------

Now that we’ve defined the goal and the scope of the project, we can
formally introduce the objectives of OpenBiodiv.

1.  [Study the domain of biodiversity informatics and semantic taxonomic
    publishing and develop an ontology allowing data integration from
    diverse sources.]{}

2.  [Develop methods for converting semi-structured XML-based EP’s into
    the RDF model of the ontology with the R programming environment.]{}

3.  [With the developed tools, create a linked open dataset on the basis
    of Pensoft Publishers’ and Plazi’s articles.]{}

4.  [Create example applications on top of the linked open dataset and
    investigate it.]{}

Overview of OpenBiodiv {#chapter-openbiodiv}
======================

In the course of the dissertation work, we have developed the OpenBiodiv
system in order to answer the challenge described in the previous
chapters. In this chapter break up OpenBiodiv into components that will
be treated in detail in subsequent chapters.

Architecture
------------

OpenBiodiv is a publicly-accessible production-stage semantic system
running on top of a reasonably-sized biodiversity knowledge graph. It
stores biodiversity data in a semantic interlinked format and offers
facilities for working with it. It is a dynamic system that continuously
updates its database as new biodiversity information becomes available
by connecting to several international biodiversity data publishers. It
also allows its users to ask complex queries via SPARQL (a query
language for semantic graph databases) and a simplified semantic search
interface.

OpenBiodiv consists of (1) a semantic graph database, (2) codebase
running on the backend, and (3) a frontend consisting of several
websites and apps (Fig. \[fig:openbiodiv-components\]). OpenBiodiv
enables the flow of information between international repositories for
biodiversity data to Biodiversity Data Journal (BDJ) and other journals
that use the ARPHA-BioDiv toolkit ([@penev_arpha-biodiv:_2017]). As a
second step, knowledge is extracted from the journals using ARPHA-BioDiv
and utilizing the TaxPub XML schema[^17] ([@catapano_taxpub:_2010]).
Examples include ZooKeys[^18], BDJ[^19], PhytoKeys[^20], MycoKeys[^21],
and so on. Also, knowledge is extracted from Plazi’s treatment bank, an
archive of legacy biodiversity literature published between TODO xxx and
yyy and containing around 200,000 treatments (TODO footnote define
treatmt) and updated every day. The extracted knowledge is then stored
in a GraphDB database and added to the biodiversity knowledge graph
(Fig. \[fig:openbiodiv-sources\]).

![The components of
OpenBiodiv.[]{data-label="fig:openbiodiv-components"}](Figures/components-openbiodiv){width="\textwidth"}

![Flow of information in the biodiversity data space until it reaches
the OpenBiodiv triple-store. Dashed lines are components that have not
been implemented yet.
[]{data-label="fig:openbiodiv-sources"}](Figures/openbiodiv-sources){width="\textwidth"}

### Graph Database

A primary output of the OpenBiodiv effort is the creation of a semantic
database based on knowledge extracted from the archives of Pensoft and
Plazi. The semantic database is online as beta[^22].

#### The OpenBiodiv Ontology (OpenBiodiv-O)

The central result of the OpenBiodiv effort is the creation of a formal
domain model of biodiversity publishing, the OpenBiodiv Ontology
(OpenBiodiv-O, [@senderov_openbiodiv_2017]). We discuss it in detail in
Chapter \[chapter-ontology\].

#### OpenBiodiv Linked Open Dataset (OpenBiodiv-LOD)

Using OpenBiodiv-O and the infrastructure described in the next
subsection a dataset incorporating approximately two hundred thousand
Plazi treatments, five thousand Pensoft articles, as well as GBIF’s
taxonomic backbone (over a million names) has been created. The dataset
is available online[^23] and will be published as a data paper. It is
discussed in Chapter \[chapter-linked-open-dataset\].

### Backend

In order to populate a semantic database it is necessary to create the
infrastructure that converts raw data (text, images, data tables, etc.)
into a structured semantic format allowing the interlinking of resource
records and the answering of complex queries. OpenBiodiv creates new
infrastructure and extends existing infrastructure for transforming
biodiversity scholarly publications into Resource Description Format
(RDF) statements with the help of the components described in this
section.

#### Workflow for Converting Ecological Ecological Metadata into a Manuscript

Ecological Metadata Language (EML) is a popular format for describing
ecological datasets (Michener et al. 1997). Biodiversity repositories
such as GBIF and DataOne make use of this format to describe the
datasets that they store. An import pipeline for importing an EML file
as a data paper ([@chavan_data_2011]) in BDJ has been developed as part
of OpenBiodiv ([@senderov_online_2016]). We describe this workflow in
detail in Chapter  \[chapter-case-study\].

#### Workflow for Importing Specimen Data into BDJ

One of the important types of biodiversity data is occurrence data—data
that documents the presence of a properly taxonomically identified
organism at a given location and time. Such data is stored at
international repositories such as BOLD, GBIF, PlutoF, and iDigBio. In
order to facilitate data publishing, as well as to act as an entry point
into OpenBiodiv, a pipeline for importing any occurrence record from
these databases into a taxonomic paper in BDJ have been developed
([@senderov_online_2016]). We describe this workflow in detail in
Chapter  \[chapter-case-study\].

#### RDF4R Package

One of the greater technical challenges for OpenBiodiv is the
transformation of biodiversity information (taxonomic names, authors of
papers, figures, etc.) stored as semi-structured XML into
fully-structured semantic knowledge in the form of RDF. In order to
solve this challenge, an R package has been developed that enables the
creation, manipulation, and submission and retrieval to and from a
database, of RDF statements in the R programming language. This package
is in the process of being published in an academic journal, as well as
pushed to one of the main repositories for R packages (CRAN and/or
ROpenSci) and can already be found openly accessible under an open
source license on GitHub[^24]. We describe the package in
Chapter \[chapter-rdf4r\].

#### OpenBiodiv Base

In combination with the RDF4R package, two further packages have been
developed as part of the code-base. The ROpenBio package utilizes the
RDF4R package to convert semi-structured XML published by Pensoft and
Plazi in the formats TaxPub (Catapano 2010), whereas the base package
coordinates the invokation of ROpenBio, contains scripts for the
automatic import of new resources, and other housekeeping details. An
overview of the remaining code-base is a provided a supplement to this
thesis.

### Frontend

In addition to providing a searchable database endpoint, a website
allowing semantic search and containing specific tasks packaged as apps
is being developed (http://openbiodiv.net). The development of the site
extends beyond the scope of the dissertation thesis and is driven by the
Pensoft development team. A beta version is already operational
Fig. \[fig:website\].

![Beta version of the OpenBiodiv website together with sample app
icons.[]{data-label="fig:website"}](Figures/openbiodiv-webpage){width="\textwidth"}

\[chapter-openbiodiv\]

\[part-data\]

The OpenBiodiv Ontology {#chapter-ontology}
=======================

OpenBiodiv lifts biodiversity information from scholarly publications
and academic databases into a computable semantic form. In this chapter,
we introduce OpenBiodiv-O ([@senderov_openbiodiv-o:_2018]), the ontology
forming the knowledge and inferencing model of OpenBiodiv. OpenBiodiv-O
provides a conceptual model of the structure of a biodiversity
publication and the development of related taxonomic concepts. We first
introduce the modeled domain in Domain Conceptualization and then
formalize it in Results.

By developing an ontology focusing on biological taxonomy, our intent is
to provide an ontology that fills in the gaps between ontologies for
biodiversity resources such as Darwin-SW and semantic publishing
ontologies such as the ontologies comprising the SPAR Ontologies. We
take the view that it is advantageous to model the taxonomic process
itself rather than any particular state of knowledge.

The source code and documentation are available under the CC BY
license[^25] from GitHub[^26]. We start by introducing the domain of
biological taxonomy and the related biodiversity sciences.

Domain Conceptualization
------------------------

Biological taxonomy is a very old discipline dating back possibly to
Aristotle, whose fundamental insight was to group living things in a
hierarchy ([@manktelow_history_2010]). The discipline took its modern
form after Carl Linnaeus (1707 - 1778). In his *Systema Naturae*
Linnaeus proposed to group organisms into *kingdoms, classes, orders,
genera*, and *species* bearing latinized scientific names with a
strictly prescribed syntax. Linnaeus listed possible alternative names
and gave a characteristic description of the groups
([@linnaeus_systema_1758]). These groups are called *taxa*, which is a
Greek word for *arrangement*. The hierarchy that taxa form is called
taxonomy. The etymology of the word is Greek and roughly translates to
*method of arranging*. Note the polysemy here: the science of biological
taxonomy is called taxonomy as is the arrangement of taxa itself. We
believe, however, that it is sufficiently clear from context what is
meant by “taxonomy” in any particular usage throughout this thesis.

Even though Linnaeus and his colleagues may have hoped to describe life
on Earth during their lifetimes, we now know that there are millions of
species still undiscovered and undescribed ([@trontelj_cryptic_2009]).
On the other hand, our understanding of species and higher-rank
taxonomic concepts changes as evolutionary biology advances
([@mallet_species_2001]). Therefore, an accurate and evolutionarily
reliable description of life on Earth is a perpetual process and cannot
be completed with a single project that can be converted into an
ontology. Thus, our aim is not to create an ontology capturing a fixed
view of biological taxonomy, but to create an ontology of the taxonomic
process. The ongoing use of this ontology will enable the formal
description of taxonomic biodiversity knowledge at any given point in
time. In the following paragraphs, we introduce what the taxonomic
process entails and reflect on the resources that need modeling.

An examination of the taxonomic process reveals that taxonomy works by
employing the scientific method: researchers examine specimens and,
based on the phenotypic and genetic variation that they observe, form a
hypothesis ([@deans_time_2012]). This hypothesis may be called a
taxonomic concept, a potential taxon, a species hypothesis
([@berendsohn_concept_1995]), or an operational taxonomic unit (OTU,
[@sokal_principles_1963]) in the case of a numerically delimited taxon.

A taxonomic concept describes the allowable phenotypic, genomic, or
other variation within a taxon by designating type specimens and
describing characters explicitly. It is a valid falsifiable scientific
claim as it needs to fulfill certain verifiable evolutionary
requirements. For example, a species-rank taxonomic hypothesis needs to
fit our current understanding of species (species concept,
[@mallet_species_2001]). More generally, the aspiration is that species
concepts are adequate and give certain tangible criteria for species
delimitation. However, valid scientific discussions continue about
concept adequacy. The discussions are nuanced because they often draw on
different conceptions of the relative weight of certain evolutionary
phenomena. This leads to having quite a few different species
concepts—morphological, ecological, phylogenetic, genomic, biological,
etc. ([@mallet_species_2001]). Nevertheless, if we fix a species
concept—let us say we take the biological species concept—we can falsify
any given species-rank taxonomic hypothesis against our fixed species
concept.

Similarly, hypotheses of higher rank (representing upper levels of the
taxonomic hierarchy) also need to fulfill certain evolutionary
requirements. For example, a modern genus concept requires all species
assigned to it to be descendants of a separate lineage and to form a
monophyletic clade.

The ranks (taxonomy hierarchy levels) are not completely fixed. The
usage of lower ranks (species, genus, family, order) is governed by
international Codes
([@international_commission_on_zoological_nomenclature_international_1999; @mcneill_international_2012]).
In the example of Linnaeus’ ranks, each organism is first a member of
its species, then genus, then order, then class, and finally kingdom.
Which specific ranks a given taxonomic study employs is dependent on the
field (e.g. botany vs. zoology), on the particular author, on the level
of taxonomic resolution required, as well as on the history of
classifying in that particular group.

Once the researchers have formed their concept, it must be published in
a scientific outlet (journal or book). The biological Codes put some
requirements and recommendations aimed at ensuring the quality of
published research but ultimately it is a democratic process
guaranteeing that everyone may publish taxonomic concepts provided they
follow the rules of the Codes. This means that in order to create a
knowledge base of biodiversity, we need to be able to mine taxonomic
papers from legacy and modern journals and books.

As a first good approximation, a taxonomic concept is based on a number
of specimens or occurrences that are listed in a section usually called
“Materials Examined.” In general terms, we can say that a sighting of a
living thing, i.e. an organism, at a given location and at a given time
is referred to as an occurrence, and a voucher for this occurrence (e.g.
the sampling of the organism itself) is referred to as a specimen
([@baskauf_darwin-sw:_2016]). Moreover, a taxonomic article may include
other specialized sections such as the Checklist section, where one may
list all taxa (in fact: the taxonomic concepts for those taxa) for
organisms observed in a given region.

Typically, the information content of a treatment consists of several
units. First, we have the aforementioned nomenclatural information that
pertains to the scientific name—its authorship, etymology, related
names, etc. Then, we have the taxonomic concept information that can be
considered to have two components, as well: the first one is the
intensional component of the taxonomic concept made up mostly of
*traits* or *characters*. Traits are an explicit definition of the
allowable variation (e.g. phenotypic, genomic, or ecological) of the
organisms that make up the taxon. For example, we can define the order
of spiders, Araneae, to be the class of organisms that have specialized
appendages used for sperm transfer called pedipalps
([@platnick_cladograms_2001]). Knowledge of this kind is found in the
Diagnosis, Description, Distribution and other subsections of the
treatment.

Non-traditionally delimited taxonomic hypotheses are called *operational
taxonomic units* (OTU’s). In the case of genomic delimitation, sometimes
the concepts are published directly as database entries and not as
Code-compliant taxonomic articles ([@page_dna_2016]). A genomic
delimitation can, for example, be based on a barcode sequence and on a
statistical clustering algorithm specifying the allowable sequence
variability that an organism can possess in order to be considered part
of the barcode sequence-bearing operational taxonomic unit. However, as,
in the general case, we don’t have a Linnaean name or a morphological
description for an operational taxonomic unit, we refer to it as a *dark
taxon* ([@page_dna_2016]). The term “dark” is, however, usually reserved
for concepts at lower ranks. Operational taxonomic units are published,
for example, in the form of *barcode identification numbers* (BIN’s) in
the Barcode of Life Data Systems (BOLD, [@ratnasingham_dna-based_2013]),
or as *species hypotheses* in Unified system for the DNA based fungal
species linked to the classification (UNITE, [@koljalg_towards_2013]).

The second part of the information content of a taxonomic concept is the
ostensive component: a listing of some (but not necessarily all) of the
organisms that belong to the taxonomic concept. This information is
found in the Materials Examined subsection of the treatment.

Finally, the relationships between taxonomic concepts—simple
hierarchical (*is a*) or more fine-grained Region Connection Calculus 5
(RCC-5, [@franz_perspectives:_2009; @franz_two_2016])—can be both
intensionally defined in the nomenclature section or ostensively
inferred from the Materials Examined. However, given the customary
idiosyncrasies of biological descriptions, providing an initial set of
RCC-5 relationships for a machine reasoner to work with often requires
expert assessment and cannot be easily lifted from the text.

Thus, in order to model the taxonomic process, our ontology models
scholarly taxonomic papers, database entries, agents responsible for
their creation, treatments, taxonomic concepts, scientific names,
occurrence and specimen information, other entities (e.g. ecological,
geographical) part-taking in the taxonomic process, as well as
relationships among these.

### Previous work {#previous-work .unnumbered}

In the biomedical domain there are well-established efforts to extract
information and discover knowledge from literature
([@momtchev_expanding_2009; @williams_open_2012; @rebholz-schuhmann_facts_2005]).
The biodiversity domain, and in particular biological systematics and
taxonomy (from here on in this thesis referred to as *taxonomy*), is
also moving in the direction of semantization of its research outputs
([@kennedy_scientific_2005; @penev_fast_2010; @tzitzikas_integrating_2013]).
The publishing domain has been modeled through the Semantic Publishing
and Referencing Ontologies (SPAR Ontologies, [@peroni_semantic_2014]).
The SPAR Ontologies are a collection of ontologies incorporating—amongst
others—FaBiO, the FRBR-aligned Bibliographic Ontology
([@peroni_fabio_2012]), and DoCO, the Document Component Ontology
([@constantin_document_2016]). The SPAR Ontologies provide a set of
classes and properties for the description of general-purpose journal
articles, their components, and related publishing resources. Taxonomic
articles and their components, on the other hand, have been modeled
through the TaxPub XML Document Type Definition (DTD, also referred to
loosely as XML schema) and the Treatment Ontologies
([@catapano_taxpub:_2010; @catapano_treatment_2016]). While TaxPub is
the XML-schema of taxonomic publishing for several important taxonomic
journals (e.g. ZooKeys, Biodiversity Data Journal), the Treatment
Ontologies are still in development and have served as a conceptual
template for OpenBiodiv-O.

Taxonomic nomenclature is a discipline with a very long tradition. It
transitioned to its modern form with the publication of the Linnaean
System ([@linnaeus_systema_1758]). Already by the beginning of the last
century, there were hundreds of vocabulary terms (e.g. *types*)
([@witteveen_naming_2015]). At present the naming of organismal groups
is governed by by the International Code of Zoological Nomenclature
(ICZN,
[@international_commission_on_zoological_nomenclature_international_1999])
and by the International Code of Nomenclature for algae, fungi, and
plants (Melbourne Code, [@mcneill_international_2012]). Due to their
complexity (e.g. ICZN has 18 chapters and 3 appendices), it proved
challenging to create a top-down ontology of biological nomenclature.
Example attempts include the relatively complete NOMEN ontology
([@dmitriev_nomen_2017]) and the somewhat less complete Taxonomic
Nomenclatural Status Terms (TNSS, [@morris_taxonomic_nodate]).

There are several projects that are aimed at modeling the broader
biodiversity domain conceptually. Darwin Semantic Web (Darwin-SW,
[@baskauf_darwin-sw:_2016]) adapts the previously existing Darwin Core
(DwC) terms ([@wieczorek_darwin_2012]) as RDF. These models deal
primarily with organismal occurrence data.

Modeling and formalization of the strictly taxonomic domain has been
discussed by [@berendsohn_concept_1995] and later, e.g., in
[@franz_perspectives:_2009; @sterner_taxonomy_2017]. Noteworthy efforts
are the XML-based Taxonomic Concept Transfer Schema
([@taxonomic_names_and_concepts_interest_group_taxonomic_2006]) and a
now defunct Taxon Concept ontology ([@devries_taxon_nodate]).

Methods
-------

OpenBiodiv-O is expressed in Resource Description Framework (RDF). At
the onset of the project, a consideration was made to use RDF in favor
of a more complex data model such as Neo4J’s ([@senderov_open_2016]).
The choice of RDF was made in order to be able to incorporate the
multitude of existing domain ontologies into the overall model.

To develop the conceptualization of the taxonomic process and then the
ontology we utilized the following process: (1) domain analysis and
identification of important resources and their relationships; (2)
analysis of existing data models and ontologies and identification of
missing classes and properties for the successful formalization of the
domain.

The formal structure of the ontology is specified by employing the RDF
Schema (RDFS) and the Web Ontology Language (OWL). It is encoded as a
part of a literate programming ([@knuth_literate_1984]) document in
RMarkdown format titled “OpenBiodiv Ontology and Guide”[^27]. The
statements have been extracted from the RMarkdown file via *knitr* and
are provided here as an appendix. It is also possible to request the
ontology via Curl from its endpoint with the indication of
[content-type: application/rdf+xml]{}. The vocabularies can be found as
additional appendices, Taxonomic Statuses and RCC-5, and on the GitHub
page[^28].

A dataset (OpenBiodiv-LOD, will be described in detail in the next
Chapter) from Pensoft’s journals, Plazi’s treatments, and GBIF’s
taxonomic backbone has been generated with and can be found at the
SPARQL Endpoint [^29]. The endpoint is also accessible from the
website[^30], under “SPARQL Endpoint.” Demos are available as “Saved
Queries” from the workbench.

Results
-------

We understand OpenBiodiv-O to be the *shared formal specification of the
conceptualization*
([@gruber_translation_1993; @obitko_translations_2007; @staab_handbook_2009])
that we have introduced in Background. OpenBiodiv-O describes the
structure of this conceptualization, not any particular state of it.

There are several domains in which the modeled resources fall. The first
one is the scholarly biodiversity publishing domain. The second domain
is that of taxonomic nomenclature. The third domain is that of broader
taxonomic (biodiversity) resources (e.g. taxonomic concepts and their
relationships, species occurrences, traits). To combine such disparate
resources together we rely on SKOS [@miles_skos_nodate]. Unless
otherwise noted, the default namespace of the classes and properties for
this paper is
[&lt;http://openbiodiv.net/&gt;](<http://openbiodiv.net/>). The prefixes
discussed here are listed at the beginning of the ontology source code.

### Semantic Modeling of the Biodiversity Publishing Domain

An article as such may be represented by a set of metadata, while its
content consists of article components such as sections, tables, figures
and so on ([@peroni_example_2015]).

To accommodate the specific needs of scholarly biodiversity publishing,
we introduce a new class for taxonomic articles, Taxonomic Article
([:TaxonomicArticle]{}), new classes for specific subsections of the
taxonomic article such as Taxonomic Treatment, Taxonomic Key, and
Taxonomic Checklist, and a new class, Taxonomic Name Usage
([:TaxonomicNameUsage]{}), for the mentioning of a taxonomic name (see
next subsection) in an article. These new classes are summarized in
Table \[bibliographic\_classes\].

            Class QName                            Comment
  ------------------------------- ------------------------------------------
          [:Treatment]{}                section of a taxonomic article
     [:NomenclatureSection]{}              subsection of Treatment
     [:NomenclatureHeading]{}            contains a nomenclatural act
   [:NomenclatureCitationList]{}    list of citations of related concepts
      [:MaterialsExamined]{}              list of examined specimens
        [:BiologySection]{}                subsection of Treatment
      [:DescriptionSection]{}              subsection of Treatment
         [:TaxonomicKey]{}            section with an identification key
      [:TaxonomicChecklist]{}      section with a list of taxa for a region
      [:TaxonomicNameUsage]{}            mention of a taxonomic name

  : New biodiversity publishing classes introduced.

\[bibliographic\_classes\]

The classes from this subsection are based on the TaxPub XML Document
Type Definition (DTD, also referred to loosely as XML schema,
[@catapano_taxpub:_2010]), on the structure of Biodiversity Data
Journal’s taxonomic paper ([@smith_beyond_2013]), and and on the
Treatment Ontologies ([@catapano_treatment_2016]).

Furthermore, we introduce two properties: *contains* ([:contains]{}) and
*mentions* ([:mentions]{}). *contains* is used to link parts of the
article together and *mentions* links parts of the article to other
concepts.

A graphical representation of the relationships between instances of the
publishing-related classes that OpenBiodiv introduces is to be found in
the diagram in Fig. \[taxonomic-article-diagram\].

![A graphical representation of the relationships between instances of
the publishing-related classes that OpenBiodiv
introduces.[]{data-label="taxonomic-article-diagram"}](Figures/taxonomic-article-diagram){width="\textwidth"}

#### Semantics, alignment, and usage

Our bibliographic model has the Semantic Publishing and Referencing
Ontologies (SPAR Ontologies) at its core with a few extensions that we
have written to accommodate for taxonomic elements. The SPAR Ontologies’
FRBR-aligned Bibliographic Ontology (FaBiO) uses the Functional
Requirements for Bibliographic Records (FRBR,
[@tillett_conceptual_2003]) model to separate publishable items into
less or more abstract classes. We deal primarily with the Work class,
i.e. the conceptual idea behind a publishable item (e.g. the story of
“War and Peace” as thought up by Leo Tolstoy), and the Expression class,
i.e. a version of record of a Work (e.g. “War and Peace,” paperback
edition by Wordsworth Classics).

Taxonomic Article is a subclass of FaBiO’s Journal Article. Furthermore
Journal Article is a FRBR Expression. This implies that taxonomic
articles are FRBR expressions as well. This has important implications
later on when discussing taxonomic concept labels. Also, it means that
we separate the abstract properties of an article (in a FaBiO Research
Paper instance, which is a Work) from the version of record (in a
Taxonomic Article, an Expression).

The taxonomic-specific section and subsection classes are introduced as
subclasses of Discourse Element Ontology’s (DEO) Discourse Element
([deo:DiscourseElement]{}, [@constantin_document_2016]). So is the class
Mention ([:Mention]{}), meant to represent an area of a document that
can be considered a mention of something. This class, and the
corresponding property, *mentions*, are inspired by [pext:Mention]{} and
its corresponding property from PROTON ([@damova_mapping_2010]). The
redefinition is necessary by the fact in OpenBiodiv-O they possess a
slightly different semantics and a different placement in the
upper-level hierarchy. We then introduce Taxonomic Name Usage as a
subclass of Mention.

This placement of the document component classes that we’ve introduced
in Discourse Element means that they ought to be used exactly in the
same way as one would use the other discourse elements from DEO and DoCO
(analogous to e.g. [deo:Introduction]{}). Note: DEO is imported by DoCO.
Figs. \[example-article-metadata\] and \[example-article-structure\]
give example usage in Turtle illustrating these ideas. A caveat here is
that while the SPAR Ontologies use [po:contains]{} in their examples, we
use *contains*, which is a subproperty of [po:contains]{} with the
additional property of being transitive. We believe this definition is
sensible as surely a sub-subcomponent is contained in a component. All
other aspects of expressing a taxonomic article in RDF according to
OpenBiodiv-O are exactly the same as according to the SPAR Ontologies.

![This example shows how to express the metadata of a taxonomic article
with the SPAR Ontologies’ model and the classes that OpenBiodiv defines.
The code is in
Turtle.[]{data-label="example-article-metadata"}](Figures/example-article-metadata){width="\textwidth"}

![This examples shows how to express the article structure with the help
of [:contains]{}. The code is in
Turtle.[]{data-label="example-article-structure"}](Figures/example-article-structure){width="\textwidth"}

### Semantic modeling of biological nomenclature

While NOMEN and TNSS (introduced in subsection “Previous work”) take a
top-down approach of modeling the nomenclatural Codes, OpenBiodiv-O
takes a bottom-up approach of modeling the use of taxonomic names in
articles. Where possible we align OpenBiodiv-O classes to NOMEN.

Based on the need to accommodate taxonomic concepts, we have defined the
class hierarchy of taxonomic names found in Fig.
\[taxonomic-name-class-hierarchy-diagram\]. Furthermore, we have
introduced the class Taxonomic Name Usage ([:TaxonomicNameUsage]{}).
Taxonomic name usages have been discussed widely in the community (e.g.
in [@pyle_taxonomic_2016]); however, the meaning of term remains vague.
The abbreviation TNU is used interchangeably for “taxon name usage” and
for “taxonomic name usage.” In OpenBiodiv-O, a taxonomic name usage is
the mentioning of a taxonomic name in the text, optionally followed by a
taxonomic status.

![We created this class hierarchy to accommodate both traditional
taxonomic name usages and the usage of taxonomic concept labels and
operational taxonomic
units.[]{data-label="taxonomic-name-class-hierarchy-diagram"}](Figures/taxonomic-name-class-hierarchy-diagram){width="\textwidth"}

For example, “*Heser stoevi* Deltschev 2016, sp. n.” is a taxonomic name
usage. The cursive text followed by the author and year of the original
species description is the latinized scientific name. The abbreviation
“sp. n.” stands for the Latin *species novum*, indicating the discovery
of a new taxon.

We also introduce the class Taxonomic Concept Label
([:TaxonomicConceptLabel]{}). A taxonomic concept label (TCL) is a
Linnaean name plus a reference to a publication, where the discussed
taxon is circumscribed. The link is via the keyword “sec.” (Latin for
(*secundum*, [@berendsohn_concept_1995]). An example would be
“*Andropogon virginicus* var. *tenuispatheus* sec.
[@blomquist_grasses_1948]”. Here, [@blomquist_grasses_1948] is a valid
bibliographic reference to the publication where the concept is
circumscribed.

We extracted taxonomic status abbreviations from about 4,000 articles
across four taxonomic journals (ZooKeys, Biodiversity Data Journal,
PhytoKeys, and MycoKeys) in order to create a taxonomic status
vocabulary (see appendices) that covers the eight most common cases
(Table \[taxonomic-status-vocabulary\]). The Latin abbreviations that
have been classified into these classes can be found on the OpenBiodiv-O
GitHub page. (See Methods for more details).

    Vocabulary Instance QName         Example Abbrev                     Comment
  ------------------------------ ------------------------- ------------------------------------
    [:TaxonomicUncertainty]{}        *incertae sedis*             Taxonomic Uncertainty
       [:TaxonDiscovery]{}               *sp. n.*                  Taxonomic Discovery
       [:ReplacementName]{}             *comb. n.*                   Replacement Name
       [:UnavailableName]{}           *nomen dubium*                 Unavailable Name
        [:AvailableName]{}             *stat. rev.*                   Available Name
   [:TypeSpecimenDesignation]{}   *lectotype designation*       Type Specimen Designation
   [:TypeSpeciesDesignation]{}        *type species*             Type Species Designation
     [:NewOccurrenceRecord]{}      *new country record*     New Occurrence Record (for region)

  : OpenBiodiv Taxonomic Status Vocabulary.

\[taxonomic-status-vocabulary\]

Based on our analysis of taxonomic statuses, we have identified two
Code-compliant patterns of relationship between latinized scientific
names (Fig. \[scientific-name-patterns\]). The pattern *replacement
name*, implemented via the property [:replacementName]{}, indicates that
a certain Linnaean name should be used instead of another Linnaean name.
It covers a wide variety of cases in the Codes, such as, for example,
the placement of one species taxon in a new genus (“comb. n.”), the
correction of a name for nomenclatural reasons (“nomen novum”), or the
application of the Principle of Priority for the discovery of synonyms
(“syn. nov.”,
[@international_commission_on_zoological_nomenclature_official_2017]).

![ Chains of *replacement names* can be followed to find the currently
used name. *Related name* indicates that two names are related somehow,
but not which one is
preferable.[]{data-label="scientific-name-patterns"}](Figures/scientific-name-patterns){width="\textwidth"}

The other pattern is that of *related names* ([:relatedName]{}). It is a
broader pattern, indicating that two names are somehow related. For
example, they may be synonyms, with one replacing the other, or they may
point to taxonomically related taxonomic concepts. For example,
*Harmonia manillana* ([@mulsant_monographie_1866]) is related to *Caria
manillana* [@mulsant_monographie_1866] since, as per
[@poorani_harmonia_2016], a name-bearing type (lectotype) of *Harmonia
manillana* ([@mulsant_monographie_1866]) sec. Poorani
[@poorani_harmonia_2016] is named *Caria manillana*
[@mulsant_monographie_1866].

#### Semantics, alignment and usage {#semantics-alignment-and-usage-1 .unnumbered}

As evident from Fig. \[taxonomic-name-class-hierarchy-diagram\],
OpenBiodiv-O taxonomic names are aligned to NOMEN names.

The linking between text and taxonomic names must pass through the
intermediary class Taxonomic Name Usage. As parts of the manuscript,
taxonomic name usages link document components to taxonomic names.
Taxonomic name usages are *contained* in sections such as Treatment, and
*mention* a taxonomic name as illustrated in the example in Fig.
\[example-taxonomic-name-usage\].

![ This examples shows how taxonomic name usages link document
components to taxonomic names. The code is in
Turtle.[]{data-label="example-taxonomic-name-usage"}](Figures/example-taxonomic-name-usage){width="\textwidth"}

### Semantic Modeling of the Taxonomic Concepts

In OpenBiodiv-O taxonomic names are not the carriers of semantic
information about taxa. This task is accomplished by a new class,
Taxonomic Concept ([:TaxonomicConcept]{}). A taxonomic concept is the
theory that a taxonomist forms about a taxon in a scholarly biological
taxonomic publication and thus always has a taxonomic concept label. We
also introduce a more general class, Operational Taxonomic Unit
([:OperationalTaxonomicUnit]{}) that can be used for all kinds of
taxonomic hypotheses, including ones that don’t have a proper taxonomic
concept label. The class hierarchy has been illustrated in
Fig. \[taxonomic-concept-diagram\].

![ A taxonomic concept is a [skos:Concept]{}, a [frbr:Work]{}, a
[dwc:Taxon]{} and has at least one taxonomic concept
label.[]{data-label="taxonomic-concept-diagram"}](Figures/taxonomic-concept-diagram){width="\textwidth"}

Taxonomic concepts are related to taxonomic names—including taxonomic
concept labels—via the property *has taxonomic name*
([:taxonomicName]{}) and its sub-properties mimicking in their range the
hierarchy of taxonomic names that we introduced earlier. We have defined
a property specifically to link taxonomic concepts to taxonomic concept
labels, *has taxonomic concept label* ([:taxonomicConceptLabel]{}). The
property hierarchy diagram is shown in Fig. \[name-property-hierarchy\].

![Property hierarchy is aligned with the taxonomic name class hierarchy
and with
DarwinCore.[]{data-label="name-property-hierarchy"}](Figures/name-property-hierarchy){width="\textwidth"}

There are two ways to relate taxonomic concepts to each other (Fig.
\[taxonomic-concept-relationships-diagram\]). As we pointed out earlier,
historically taxonomic concepts form the hierarchy known as biological
taxonomy. To express such simple semantic relations, it is fully
sufficient to use the SKOS semantic vocabulary [@miles_skos_nodate].

![In order to express an RCC-5 relationship between concepts, create an
[:RCC5Sgtatement]{} and use the corresponding properties to link two
taxonomic concepts via it. Further, taxonomic concepts are linked to
traits (e.g. ecology in ENVO), occurrences (e.g. Darwin-SW) and realize
treatments.[]{data-label="taxonomic-concept-relationships-diagram"}](Figures/taxonomic-concept-relationships-diagram){width="\textwidth"}

However, these simple relationships are not well suited for machine
reasoning. This is why Franz and Peet [@franz_perspectives:_2009]
suggested, building on previous work by e.g.
[@koperski_referenzliste_2000], to use the RCC-5 language to express
relationships between taxonomic concepts. Furthermore, the Euler
([@chen_euler/x:_2014]) program was developed, which uses Answer Set
Programming (ASP) to reason over RCC-5 taxonomic relationships. An
answer set reasoner is not part of OpenBiodiv as this task can be
accomplished by Euler; however, we have provided an RCC-5 dictionary
class ([:RCC5Dictionary]{}), an RCC-5 relation term class
([:RCC5Relation]{}), a vocabulary of such terms to express the RCC-5
relationships in RDF (see appendices), as well as a class and properties
to express RCC-5 statements ([:RCC5Statement]{}, [:rcc5Property]{}, and
subproperties).

#### Semantics and alignment

We introduce Taxonomic Concept as equivalent ([owl:equivalentClass]{})
to the DwC term Taxon ([dwc:Taxon]{}) [@noauthor_darwincore_nodate].
However, by including “concept” in the class’ name, we highlight the
fact that the semantics it carries reflect the scientific theory of a
given author about a taxon in nature. As we mentioned earlier, our
ontology models the ongoing still unfinished process of taxonomic
discovery. For this reason, we also derive Taxonomic Concept from Work.
This derivation fits the definition of Work in FRBR/FaBiO, which is *“a
distinct intellectual or artistic creation.”* Finally, as we use SKOS to
connect taxonomic concepts to each other, we derive Taxonomic Concept
from SKOS Concept.

As with other semantic publishing-related aspects of the ontology, the
creation of the RCC-5 vocabulary follows the SPAR Ontologies’ model.
Thus OpenBiodiv RCC-5 Vocabulary ([:RCC5RelationshipTerms]{}) is a SKOS
concept scheme and every RCC-5 Relation is a SKOS concept. This allows
to seamlessly share this vocabulary with other publishers of
biodiversity information that also follow the SPAR Ontologies’ model.

It is important to note that we have aligned the subproperty of *has
taxonomic name*, *has scientific name* ([:scientificName]{}), to the DwC
property [dwciri:scientificName]{}. The difference is that while the DwC
property is unbound and provides more flexibility, the property has the
domain Taxonomic Concept and the range Scientific Name and provides for
inference. Furthermore, *has taxonomic concept label* is an
inverse-functional property with the domain Taxonomic Concept. This
means that a given taxonomic concept label uniquely determines its
taxonomic concept. This is accomplished by a minimum cardinality
restriction on the property.

Together with the declaration of *has taxonomic concept label* to be an
inverse functional property, we can now list what types of relationships
between names and taxonomic concepts are allowed: (1) The relationship
between a taxonomic concept and a name that is not a taxonomic concept
label is many-to-many—i.e. one Linnaean name can be a mention of
multiple taxonomic concepts, and one taxonomic concept may have multiple
Linnaean names. (2) The relationship between a taxonomic concept and a
taxonomic concept label is one-to-many: while a taxonomic concept may
have more than one (at least one is needed) labels, every label uniquely
identifies a concept. These logical restrictions make taxonomic concept
labels into unique identifiers to taxonomic concepts, something that
Linnaean names are not.

#### Usage

For an example of linking two taxonomic concepts to each other, let us
look at the species-rank concept *Casuarinicola australis*
[@taylor_casuarinicola_2010] sec. [@thorpe_casuarinicola_2013]. It is a
narrower concept than the genus-rank concept of *Casuarinicola*
[@taylor_casuarinicola_2010] sec. [@taylor_casuarinicola_2010]. As we
have aligned our concepts to SKOS, we can use its vocabulary to express
this statement as seen in the example in Fig.
\[example-simple-taxonomic-concept-relationships\]. A further example of
how to utilize the OpenBiodiv RCC-5 vocabulary is found in
Fig. \[example-rcc5-taxonomic-concept-relationships\].

![We can use SKOS semantic properties to illustrate simple relationships
between taxonomic
concepts.[]{data-label="example-simple-taxonomic-concept-relationships"}](Figures/example-simple-taxonomic-concept-relationships){width="\textwidth"}

![In order to express an RCC-5 relationship between concepts, create an
[:RCC5Sgtatement]{} and use the corresponding properties to link two
taxonomic concepts via it. SKOS relations relate concepts
directly.[]{data-label="example-rcc5-taxonomic-concept-relationships"}](Figures/example-rcc5-taxonomic-concept-relationships){width="\textwidth"}

Furthermore, thanks to the alignment to DwC, we treat instances of our
class Taxonomic Concept as functionally equivalent to DwC Taxa. This
makes linking to other biodiversity ontologies possible. For example,
the Open Biomedical Ontologies’ (OBO) Population and Community Ontology
(PCO, [@walls_semantics_2014]) has a class “collection of organisms”
(<http://purl.obolibrary.org/obo/PCO_000000>) that can be considered a
superclass of DwC Taxon. Therefore, every taxonomic concept is a
collection of organisms and the application of OBO properties on it is
allowed.

In the paper that inspired our *Casuarinicola* example
([@thorpe_casuarinicola_2013]), we read: *“On 26 February 2013, the
species was found to be fairly common on Casuarina trees at Thomas
Bloodworth Park, Auckland.”* This statement can be interpreted (in ENVO)
as meaning that the taxonomic concept that the author formulated implies
that it includes the habitat “forest biome”
(<http://purl.obolibrary.org/obo/RO_0002303>). The RDF example is shown
in Fig. \[example-envo\].

![We create a shortcut for *has habitat* and instance of the “forest
biome” and link them to our taxonomic concept in order to express the
fact that specimens of it have been found to live in *Casuarina*
trees.[]{data-label="example-envo"}](Figures/example-envo){width="\textwidth"}

As we pointed out earlier, taxonomic concepts have an intensional
component (traits or characters) and an ostensive component (a list of
occurrences belonging to the concept). The ostensive component can be
expressed by linking occurrences to the taxonomic concepts via
Darwin-SW. This is possible as we have aligned the Taxon Concept class
to DwC Taxon used by Darwin-SW. For an example refer to
[@baskauf_darwin-sw:_2016].

Lastly, describing traits is an active area of ontological research
([@huang_oto:_2015]). Due to the very complex language used to describe
morphological characteristics, the Ontology Term Organizer (OTO,
[@huang_oto:_2015]) software was developed to allow for user-created
vocabularies. An avenue for a follow-up project is to work with OTU to
express traits and trait equivalences (in the taxonomic sense) during
the population of OpenBiodiv with triples ([@hong_explorer_2018]).

Last, the interpretation of Taxonomic Concepts as Work means that they
are realized by taxonomic treatments (e.g.
Fig \[example-treatment-concept\]).

![A treatment is the realization of a taxonomic
concept.[]{data-label="example-treatment-concept"}](Figures/example-treatment-concept){width="\textwidth"}

Discussion
----------

OpenBiodiv-O is—together with the Treatment Ontologies
[@catapano_treatment_2016]—the first effort to model taxonomic articles
as RDF. It introduces classes and properties in the domains of
biodiversity publishing and biological taxonomy and aligns them with the
SPAR Ontologies, the Treatment Ontologies, the Open Biomedical
Ontologies (OBO), TaxPub, NOMEN, and DarwinCore. We believe this
introduction bridges the ontological gap that we had outlined in our
aims and allows for the creation of a Linked Open Dataset (LOD) of
biodiversity information (biodiversity knowledge graph,
[@senderov_open_2016; @page_towards_2016]).

Furthermore, this biodiversity knowledge graph, together with this
ontology, additional semantic rules, and user software will form the
OpenBiodiv Knowledge Management System. This system, as any taxonomic
information system should, has taxonomic names as a key building block.
For any given taxonomic name, the user will be able to rely on two
patterns—*replacement name* and *related name*—to get answers to two
questions of high importance to the working taxonomist. First: what is
the current and historical usage of any given Linnaean name? Second:
given a particular name, what other related names ought to be considered
in a taxonomic discussion?

Both may be useful in building semantic search applications and the
latter, in particular, is actively being researched by a group at the
National Center for Text Mining in the UK (NaCTeM,
[@nguyen_constructing_2017]). proper does not include a mechanism for
inferring replacement names and related names; however, such mechanisms
are part of the OpenBiodiv knowledge system via SPARQL rules using
information encoded in the document structure (Nomenclature section).
Another way to infer related names is via a machine learning approach to
obtain feature vectors of taxonomic names. Note that the ontology can
describe related names independent of the process of their generation
and will enable the comparison of both approaches in a future work.

On the other hand, by using , a knowledge-based system does not have to
have a backbone name-based taxonomy. A backbone taxonomy is a single,
monolithic hierarchy in which any and all conflicts or ambiguities have
been pragmatically (socially, algorithmically) resolved, even if there
is no clear consensus in the greater taxonomic domain. Such backbone
taxonomies are used in systems that rely solely on taxonomic names (and
not concepts) as bearers of information. They are needed as it is
impossible, in such a system, to express two different sets of
statements for a single name.

In OpenBiodiv, however, multiple hierarchies of taxonomic concepts may
exist. For example, large synthetic taxonomies such as GBIF’s backbone
taxonomy ([@gbif_secretariat_gbif_2017]) or Catalogue of Life[^31] may
not agree or may have some issues [@page_gbif_2012]. With OpenBiodiv-O,
we may, in fact, incorporate both these taxonomies at the same time! It
is possible according to the ontology to have two sets of taxonomic
concepts (even with the same taxonomic names) with a different
hierarchical arrangement. By allowing this, we leave some room for human
interpretation as an additional architectural layer. Thus, we delay the
decision of which hierarchy to use to the user of the system (e.g. a
practicing taxonomist) and not to the system’s architect. Due to this
design feature, it is likely that our system stands a better chance to
be trusted as a science process-enabling platform as the system
architects don’t force a taxonomic opinion on the practicing taxonomist.

It should be noted that a successful concept-based system exists for the
taxonomic order Aves (birds, [@lepage_avibase_2014]). The main issue
that we will face is to develop tools to enable expert users to annotate
taxonomic concepts with the proper relationships as only recently
individual articles utilizing concept taxonomy in addition to
nomenclature have been published
([@franz_two_2016; @jansen_phylogenetic_2015; @franz_three_2017]). We do
believe that their numbers will rise driven by the realization that
there are some problems with relying solely on Linnaean names for the
identification of taxonomic concepts
([@patterson_names_2010; @remsen_use_2016; @franz_names_2016]). Concept
taxonomy may, in fact, become even more important in the future as
conservation efforts face challenges due to unresolved taxonomies
([@garnett_taxonomy_2017]). Properly aligning taxonomic concepts to
nomenclature across revisions ([@franz_logic_2016-1]) may be the
solution.

Together with taxonomic information, the ontology allows modeling the
source information in a knowledge base. This will be useful for
meta-studies, for the purposes of reproducible research, and other
scholarly purposes. Moreover, it will be an expert system as the
knowledge extracted will come from scholarly publications. We envision
the system to be able to address a wide variety of taxonomic competency
questions raised by researchers ([@pro-ibiosphere_competency_2013]).
Examples include: “Is X a valid taxonomic name (in a nomenclatorial
sense)?” “Which treatments use different names for the same taxon
concepts?” “Which treatments are nomenclatorially linked (including
homonyms!) to another treatment?”

In the next Chapter we will show how we populated the ontology with
triples extracted from Pensoft journals, legacy journals text-mined by
Plazi, as well as databases such as GBIF’s taxonomic backbone
([@gbif_secretariat_gbif_2017]). Special effort will be made to link the
dataset to the Linked Open Data cloud via resources such as geographic
or institution names. In terms of extending the ontological model, more
research needs to go into modeling the taxonomic concept
circumscription—creating ontologies for morphological, genomic, or
ecological traits.

Conclusions
-----------

The chapter provides an informal conceptualization of the taxonomic
process and a formalization in OpenBiodiv-O. It introduces classes and
properties in the domains of biodiversity publishing and biological
systematics and aligns them with the important domain-specific
ontologies. By bridging the ontological gap between the publishing and
the biodiversity domains, it will enable the creation of Open
Biodiversity Knowledge Management System, consisting of (1) the ontology
itself; (2) a Linked Open Dataset (LOD) of biodiversity information
(biodiversity knowledge graph); and (3) user interface components aimed
at searching, browsing and discovering knowledge in big corpora of
previously dispersed scholarly publications. Through the usage of
taxonomic concepts, we have included mechanisms for democratization of
the scholarly process and not forcing a taxonomic opinion on the users.

OpenBiodiv Linked Open Dataset {#chapter-lod}
==============================

At the onset of the OBKMS project, no universal system linking
biodiversity information had been adopted ([@guralnick_community_2015]).
Using the tools for RDF generation described in this thesis, widely
adopted community ontologies, as well as our own OpenBiodiv-O ontology,
we have created the OpenBiodiv LOD (linked open dataset) uniting three
important international sources of biodiversity data: the Global
Biodiversity Information Facility (GBIF) Backbone Taxonomy
([@gbif_secretariat_gbif_2017]), taxonomic information published in
Pensoft’s journals, and taxonomic information stored in Plazi Treatment
Bank[^32]. We propose to the biodiversity informatics community to use
OpenBiodiv LOD as the central point for a biodiversity knowledge graph.

General Description
-------------------

In this section, we describe in the detail the type of data present in
the OpenBiodiv LOD.

### GBIF Backbone Taxonomy

GBIF is the largest international repository of occurrence data. GBIF
allows its users to do searches on its occurrence data utilizing a
taxonomic hierarchy. For example, it is possible to look for occurrences
of organisms belonging to a specific genus according to its database; a
search for the beetle genus *Harmonia* sec.
[@gbif_secretariat_gbif_2017-1] on 30 June 2018 returned 575,376
results. This search is possible thanks to the GBIF Backbone Taxonomy
also known as Nub ([@gbif_secretariat_gbif_2017-1]). Nub is a database
organizing taxonomic concepts in a hierarchicy covering all names used
in occurrence records harvested by GBIF. It is a single synthetic
(algorithmically generated) management classification with the goal of
covering all names present in GBIF’s datasets. Thus, the GBIF backbone
does not represent an expert consensus on how taxa are hierarchically
arranged according to evolutionary criteria in Nature.

Keeping in mind this critique, it is evident how the backbone taxonomy
allows GBIF to integrate name based information from diverse sources
such as Encyclopedia of Life (EOL), Genbank or the International Union
of TODO (IUCN) and provides a facility for taxonomic searching and
browsing.

In order to grant the same capabilities to OpenBiodiv, we have imported
Nub as instances of [openbiodiv:TaxonomicConcept]{} according to
OpenBiodiv-O. Each GBIF taxonomic concept is linked to an instance of
[openbiodiv:ScientificName]{} and to its parent taxonomic concept via
SKOS and RCC-5 (TODO reference example). Thus, even though users of
OpenBiodiv-LOD have the opportunity of taxonomic search using Nub, we
have decoupled scientific names from a single hierarchical
representation allowing the future evolution of OpenBiodiv-LOD to
incorporate other simultaneous views of taxonomic alignment.

Furthermore, as the GBIF backbone taxonomy is updated regularly through
an automated process from over 56 sources, future updates may be
ingested as different versions into OpenBiodiv-LOD without affecting
existing records.

—-

One of the main challenges of the OBKMS is to develop a system for
robust and universal identification of biodiversity and
biodiversity-related objects, such as taxon names, taxon name usages,
museum specimens, occurrence records, taxon treatments, genomic
sequences, organism traits, bibliographic citations, figures,
multi-media files, etc. Historically, many such systems have been
proposed and utilized. For example, Darwin Core Triplets, the de facto
standard for occurrence-type data are discussed in
[@guralnick_trouble_2014]. Globally Unique Identifiers (GUID’s) such as
Life Science Identifiers (LSID’s) are defined and discussed in
[@page_biodiversity_2008; @pereira_tdwg_2009]. Universal Resource Names
(URN’s), Universal Resource Identifiers (HTTP-URI’s), and Digital Object
Identifiers (DOI’s), are all discussed in [@guralnick_community_2015]
and others.

Moreover, for systems that have been more widely adopted, such as Darwin
Core Triplets for occurrence and specimen data,
[@guralnick_trouble_2014] observed significant difficulties in
cross-linking the same specimen across different databases. Therefore,
one of the tasks of this work will be to propose and implement a system
for the robust identification and access of biodiversity-related data in
a taxonomic or a bioinformatics publication. Furthermore, we aim at
creating a data model of these data objects that allows researchers to
address important scientific questions.

RDF Generation in R
-------------------

### redland, rdflib, and other

### rdf4r

### Processing XML in R

### ropenbio

XML Standards for Biodiversity Data
-----------------------------------

### TaxPub

### TaxonX

Sources for XML Biodiversity Data
---------------------------------

### Pensoft

### Plazi

Creation and Storage of the LOD
-------------------------------

Applications
============

Discovering Hidden Facts via SPARQL
-----------------------------------

Search and Browse
-----------------

Summarization of the Main Results and Outlook
=============================================

\[part-programming\]

Biodiversity Informatics Case Studis {#chapter-case-study}
====================================

This Chapter servers to give an in-depth introduction to the domain of
biodiversity informatics

Junk
----

### Turbo-Taxonomy

The large number of dark taxa is due to the fact that genomic
technologies are very effective and allow for the generation of SH or
OTU’s with a speed much higher than the speed with which taxonomists
manage to publish morphological descriptions and name them. . The
solution for this problem may come if modern systems are created that
enable the semi-automatic generation of taxonomic manuscripts in which
authors are able to rapidly publish species descriptions and link them
to OTU’s. Such approaches are known as “turbo-taxonomy”
([@butcher_turbo-taxonomic_2012]).

RDF4R {#chapter-rdf4r}
=====

[^1]: TDWG Past Meetings
    [&lt;http://www.tdwg.org/past-meetings/&gt;](http://www.tdwg.org/past-meetings/)

[^2]: What is GBIF?
    [&lt;https://www.gbif.org/what-is-gbif&gt;](https://www.gbif.org/what-is-gbif)

[^3]: Bouchout Declaraiton
    [&lt;http://bouchoutdeclaration.org/&gt;](http://bouchoutdeclaration.org/)

[^4]: E.U. pro-iBiosphere project
    [&lt;http://wiki.pro-ibiosphere.eu/&gt;](http://wiki.pro-ibiosphere.eu/)

[^5]: The vision thing - it’s all about the links (2014)
    [&lt;http://iphylo.blogspot.bg/2014/06/the-vision-thing-it-all-about-links.html&gt;](http://iphylo.blogspot.bg/2014/06/the-vision-thing-it-all-about-links.html)

[^6]: Putting some bite into the Bouchout Declaration (2015)
    [&lt;http://iphylo.blogspot.bg/2015/05/putting-some-bite-into-bouchout.html&gt;](http://iphylo.blogspot.bg/2015/05/putting-some-bite-into-bouchout.html)

[^7]: UBio, [&lt;http://ubio.org/&gt;](http://ubio.org/)

[^8]: Global Names
    [&lt;http://globalnames.org/&gt;](http://globalnames.org/)

[^9]: BioGuid [&lt;http://bioguid.org/&gt;](http://bioguid.org/)

[^10]: BioNames [&lt;http://bionames.org/&gt;](http://bionames.org/)

[^11]: Pensoft Taxon
    Profile[&lt;http://ptp.pensoft.eu/&gt;](http://ptp.pensoft.eu/)

[^12]: Plazi Treatment Repository
    [&lt;http://plazi.org/wiki/&gt;](http://plazi.org/wiki/)

[^13]: Please refer to Chapter \[chapter-domain-conceptualization\] for
    a discussion of the term taxonomy, which is slightly different to
    its interpretation in computer science.

[^14]: The BIG4 project,
    [&lt;http://big4-project.eu&gt;](http://big4-project.eu).

[^15]: Manifesto for Agile Software Development
    [,](http://agilemanifesto.org/)[&lt;http://agilemanifesto.org/&gt;]{}.

[^16]: [&lt;http://openscienceasap.org/open-science/&gt;](http://openscienceasap.org/open-science/>)

[^17]: Strictly speaking a Document Type Definition (DTD).

[^18]: <http://zookeys.pensoft.net>

[^19]: <http://bdj.pensoft.net>

[^20]: <http://phytokeys.pensoft.net>

[^21]: <http://mycokeys.pensoft.net>

[^22]: <http://graph.openbiodiv.net/>

[^23]: <http://graph.openbiodiv.net/>

[^24]: <https://github.com/vsenderov/rdf4r>

[^25]: Creative Commons Attribution 4.0 International Public License.

[^26]: [https://github.com/vsenderov/openbiodiv-o](https://github.com/vsenderov/openbiodiv-o/blob/master/LICENSE.md)

[^27]: <http://openbiodiv.net/ontology>

[^28]: <https://github.com/vsenderov/openbiodiv-o>

[^29]: <http://graph.openbiodiv.net/>

[^30]: <http://openbiodiv.net/>

[^31]: <http://www.catalogueoflife.org/>

[^32]: Plazi Treatment Bank
    [&lt;http://plazi.org/resources/treatmentbank/&gt;](http://plazi.org/resources/treatmentbank/)
