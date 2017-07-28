# Open Biodiversity Knowledge Management System

Hi! Welcome to the Open Biodiversity Knowledge Management System: a PhD
project project by [Viktor Senderov](#viktor-senderov).

The system is called *OpenBiodiv* or *OBKMS*. OBKMS is the older name, but we
prefer to call it OpenBiodiv recently.

This reposititory contains the architecture, documentation, deployment
scripts, papers, and otherwise all material that will go into my dissertation.
In addition to that there is R package,
[ropenbio](https://github.com/pensoft/ropenbio) that contains the source code
doing the heavy lifting.

The system itself is deployed at [openbiodiv.net](http://openbiodiv.net/).

## Papers

- [OpenBiodiv PhD Proposal](https://doi.org/10.3897/rio.2.e7757)
- [An early paper on occurrence records](https://riojournal.com/article/10617/)
- [Taxonomic paper with scripts illustrating convestion of DwC data to the BOLD format](https://zookeys.pensoft.net/articles.php?id=12522)

## Viktor Senderov

If you want to email me, you are more than welcome to, but you have to pass
the following reverse turing test. There is a new sexy name for statistics
today. You could think of it as the science of data. My email is this name
(one word) and the domain is the domain of [Pensoft](http://pensoft.net/)

## Contents of this repository



## Data sources

As a database, the OBKMS draws information from other previously published information, mainly XML's of scientific articles.

Here I will list the sources


### Biodiversity Data Journal

It has an RSS feed

* http://bdj.pensoft.net/rss.php

and script that allows you to grab articles from a specific date on

* http://bdj.pensoft.net/lib/journal_archive.php?journal=bdj&date=26%2F3%2F2015

where {date} is a urlencoded date in format day/month/year 
(e.g. 26/3/2014)

### Zookeys

* http://zookeys.pensoft.net/lib/journal_archive.php?journal=zookeys&date=26%2F12%2F2016

In practice the system is populated from files. 

1. When doing an initial population, you download all articles up to the current date in a predifined directory. Where this directory is, is set-up in a configuration file. The configuration is part of the OBKMS R package contained in the system. The file is `/home/viktor/Work/OBKMS/R/obkms/inst/dump_directory.yml`.

Please run this in your R shell, befire running any of the OpenBiodivScripts. The configuration files contains the directory where all harvested journals will be dumped during an initial dump.

2. To run the OBKMS functions, you need access to the a GraphDB (or other compatible) database. The GraphDB access credentials can be read from a YAML file. At the moment this file is:

```{r}
Sys.setenv("OBKMS_CONFIGURATION_FILE = "/home/viktor/Work/OBKMS/etc/graphdb8_test.yml"
```

and initialization goes like this:

```{r}
configuration_file = Sys.getenv("OBKMS_CONFIGURATION_FILE")
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options)
```

This initialization also adds the dump directory mentioned above to the OBKMS environment and additional variables needed for the normal operation of the database.

## Data model

The data model for generating RDF is found in the

* [OpenBiodiv RDF Guide](ontology/RDF_Guide.md)

## RDF-ization

[BDJ RDF-izer](input/bdj.R)
