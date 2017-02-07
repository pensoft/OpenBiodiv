% Open Biodiversity Knowledge Management System Programmer’s and User’s Guide (The OpenBiodiv Guide)

# Introduction

This is the Open Biodiversity Knowledge Management System (OpenBiodiv/ OBKMS) Guide. It is intended to fully describe the RDF model and other features that OpenBiodiv/ OBKMS possesses and aid users in generating OpenBiodiv/ OBKMS-compatible RDF and in creating working SPARQL queries for OpenBiodiv/ OBKMS.

*Proposal*:

http://riojournal.com/articles.php?id=7757

## This is a literate programming document

In the following sections this document will describe the OpenBiodiv/ OBKMS data model and at the same define the ontology that is used in OpenBiodiv. This feat is accomplished via *literate programming*. In a nutshell, the source code for the ontology is found within this document and is extracted with `notangle`.

## Makefile

In order to create the ontology, we need to run `notangle`. We also have different build instructions that we put in the `Makefile`.

```
<<Makefile>>=
Makefile: README.md
	notangle -RMakefile README.md > Makefile
  
@
```

## Directory Structure

Needs to be filled out.

## Data Model

## RSS feed with the last 100 BDJ articles

 http://bdj.pensoft.net/rss.php




