---
title: "TaxPub XML to Turtle RDF Converter"
author: "Viktor Senderov"
date: "2016-10-06"
---

# Specification

## Making the scripts

```
knitr::knit('exec/taxpub2rdf.Rmd', output = 'exec/taxpub2rdf.R', tangle = TRUE)
```

## Summary

`taxpub2rdf` is a command-line tool, written in the [R programming language](https://cran.r-project.org/), which RDF-izes, i.e. converts to [Resource Description Framework](https://www.w3.org/RDF/) (RDF) taxonomic papers, encoded in the [TaxPub XML schema](http://htmlpreview.github.io/?https://github.com/tcatapano/TaxPub/blob/master/documentation/tp-taxon-treatment.html). It is designed to be used together with the [Open Biodiversity Knowledge Management System](http://openbkms.blogspot.com) (OBKMS) graph database, as before it generates new identifiers for things in the network, it tries to look them up in OBKMS.

## Usage and requirements

`taxpub2rdf` requires two parameter-sets for successful operation:

1. Access details for OBKMS, which are stored as a Yaml file, except for the username-password combination, which is stored in the environment variable OBKMS_PASSWORD.
2. A set of input XML files in the TaxPub format.

E.g.:

`Rscript taxpub2rdf config.yml paper1.xml paper2.xml ...`

The first argument is the Yaml configuration file. The next n arguments are the TaxPub XML files, that will be RDF-ized. The output will be n Turtle files with the same filenames but the `.ttl` extension.


# Design and Implementation

## Initialization

The script relies on the `xml2` library for XML processing and on the `rdf4jr` library for communication with the GraphDB server:

```
library(xml2)
library(rdf4jr)
```

Processing the command-line arguments:

```
options = commandArgs(trailingOnly = TRUE)
cat( options )
stop("options")
```

```
taxpub_file = "../../TaxPub2RDF/Standard_Model_Conversions/10.3897-BDJ.4.e10095.xml"
obkms_opts = create_server_options(protocol = "http://", server_add = "213.191.204.69:7777/graphdb", authentication = "basic_http", userpwd = "obkms:1obkms")
repo = "OBKMS"
```

Test GraphDB connectivity:
```
get_protocol_version(obkms_opts)
get_repositories( obkms_opts )
```

Read in the XML file:
```
taxpub_xml = read_xml(taxpub_file)
```
Now, we will write different functions to extract different features of the XML.

We need a helper function to get or create an node (id) for the network given a preferred label (`skos:prefLabel`):
```
get_or_create_node_by_label = function( options, label ) {
  prefixes = "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
  query = 
    "SELECT ?id
    WHERE {
      ?id skos:prefLabel %label .
    }"
  query = paste(prefixes, gsub("%label", paste('\"', label, '\"', sep = ""), query), sep = "\n")
  res = POST_query( options, repo, query, "CSV" )
  if ( dim ( res )[1] == 0 ) {
    return ( paste( "http://id.pensoft.net/", uuid::UUIDgenerate() , sep = "") )
  }
  else {
    return ( as.character( res[1, 1]))
  }
  
}
```

We write a function that returns RDF about the publisher. RDF will be returned as strings in Turtle Syntax.
```
get_publisher_rdf = function(taxpub_xml) {
  publisher_name = xml_text(xml_find_all(taxpub_xml, "/article/front/journal-meta/publisher/publisher-name")[[1]])
  publisher_id = get_or_create_node_by_label( obkms_opts, publisher_name) 
  if (publisher_id == null) publisher_id = mint_new_pensoft_id()
  
  journal_name = xml_text(xml_find_all(taxpub_xml, "/article/front/journal-meta/journal-id")[[1]])
  journal_id = get_or_create_node_by_label( obkms_opts, journal_name)
  
  
  rdf = "
  prefix fabio: <fdfsdsfsdfs> .
  %journal_id a fabio:Journal"
  return(rdf)
}
```

# this is in semi pseudo code
extract_journal_metadata = function(y_document) {
  journal_name = get_xml_value("/article/front/journal-meta/journal-id")
}
