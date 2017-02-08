% The OpenBiodiv Guide

Open Biodiversity Knowledge Management System Programmer’s and User’s Guide

# Introduction

This is the Open Biodiversity Knowledge Management System (OpenBiodiv/ OBKMS) Guide. It is intended to fully describe the RDF model and other features that OpenBiodiv/ OBKMS possesses and aid users in generating OpenBiodiv/ OBKMS-compatible RDF and in creating working SPARQL queries for OpenBiodiv/ OBKMS.

## Proposal

http://riojournal.com/articles.php?id=7757

## This is a literate programming document

In the following sections this document will describe the OpenBiodiv/ OBKMS data model and at the same define the ontology that is used in OpenBiodiv. This feat is accomplished via *literate programming*. In a nutshell, the source code for the ontology is found within this document and is extracted with `notangle`.

## Directory structure

Needs to be filled out.

# Technical specification

## RSS feed with the last 100 BDJ articles##

http://bdj.pensoft.net/rss.php
 
## Imported ontologies

All ontologies from directory `~/Ontology/imports/` are imported. In addition to that the OpenBiodiv/ OBKMS core ontology `~/Ontology/openbiodiv.ttl` is imported. Here’s a table of the contents of the `imports/` directory:

[Catalog.md](Ontology/imports/Catalog.md)

## Prefixes

In OpenBiodiv/ OBKMS prefixes are stored in a YAML configuration file called

[prefix_db.yml](R/obkms/inst/prefix_db.yml)

Of these three namespaces have special meaning:
1. pensoft: is used to issue identifiers for Pensoft-specific objects;
2. openbiodiv: is used to issue identifiers to the ontology classes and properties of the OpenBiodiv/ OBKMS ontology;
3. trt: is used to refer to the tightly-linked Treatment Ontology classes and properties.

## General ideas

### Usage of `skos:prefLabel`

The objects in OBKMS all have unique identifiers (currently in the `pensoft:` namespace). In addition to those identifiers, the objects have labels that are there primarily for human consumption. Labels can be things like the DOI (in the case of an article), the Latin name of a taxon (in the case of scientific names). This preferred label is encoded with the property `skos:prefLabel`. Furthermore, an object can have secondary (alternative) labels such as a different spelling of a scientific name, or a vernacular name of a taxon. In this case we use `skos:altLabel`.


