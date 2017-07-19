# Open Biodiversity Knowledge Management System

Hello, dear friend! Welcome to the Open Biodiversity Knowledge Management System: you one-stop-shop for all your biodiversity needs. We hope you like it here and come back often! We call it OpenBiodiv. We used to call it OBKMS.

This reposititory contains the source code and documentation for OpenBiodiv. The system itself will soon be deployed at

http://openbiodiv.net/

Here, you can read all about it, and having this knowledge you will be able to deploy it (or a clone of it), or maintain it.

There is a PhD proposal for OBKMS, read here:

* https://doi.org/10.3897/rio.2.e7757

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
