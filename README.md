# OpenBiodiv PhD Project

Hi! Welcome to the OpenBiodiv PhD project by [Viktor Senderov](https://github.com/vsenderov/) at [Pensoft](http://pensoft.net) as part of the Marie-Curie training network for genomics, bioinformatics, and systematics of the [BIG 4](http://big4-project.eu) insect groups.

## What is OpenBiodiv

OpenBiodiv is a knowledge management system of biodiversity data. Its components are 

- the ontology [OpenBiodiv-O](https://github.com/vsenderov/openbiodiv-o)
- a [semantic graph database storing a LOD dataset](http://graph.openbiodiv.net) (linked open data) populated with informationfrom three sources:

  - [Pensoft's journals](https://pensoft.net/browse_journals)
  - [Plazi's Treatment Bank](http://plazi.org/resources/treatmentbank/)
  - [GBIF Taxonomic Backbone](https://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c)

- a [web-portal](http://openbiodiv.net) providing a semantic search-and-browse as well as user applications to access the LOD.
- the [RDF4R](http://github.com/vsenderov/rdf4r) R package for RDF generation
- [this repository](http://github.com/vsenderov/openbiodiv) containing the documentation and bootstrap scripts needed to run an OpenBiodiv instance

More information on what OpenBiodiv is can be found in the draft text of a chapter of my [dissertation](https://www.overleaf.com/read/nhwfffwpvzwb) (Chapter 3).

## Papers that have been published on OpenBiodiv

Please use 2 for citing.

1. Senderov, Viktor, Kiril Simov, Nico Franz, Pavel Stoev, Terry Catapano, Donat Agosti, Guido Sautter, Robert A. Morris, and Lyubomir Penev. “OpenBiodiv-O: Ontology of the OpenBiodiv Knowledge Management System.” Journal of Biomedical Semantics 9, no. 1 (January 2018). https://doi.org/10.1186/s13326-017-0174-5.
2. Senderov, Viktor, and Lyubomir Penev. “The Open Biodiversity Knowledge Management System in Scholarly Publishing.” Research Ideas and Outcomes 2 (January 11, 2016): e7757. https://doi.org/10.3897/rio.2.e7757.
3. Senderov, Viktor, Teodor Georgiev, and Lyubomir Penev. “Online Direct Import of Specimen Records into Manuscripts and Automatic Creation of Data Papers from Biological Databases.” Research Ideas and Outcomes 2 (September 23, 2016): e10617. https://doi.org/10.3897/rio.2.e10617.
4. Cardoso, Pedro, Pavel Stoev, Teodor Georgiev, Viktor Senderov, and Lyubomir Penev. “Species Conservation Profiles Compliant with the IUCN Red List of Threatened Species.” Biodiversity Data Journal 4 (September 1, 2016): e10356. https://doi.org/10.3897/BDJ.4.e10356.
5. Arriaga-Varela, Emmanuel, Matthias Seidel, Albert Deler-Hernández, Viktor Senderov, and Martin Fikácek. “A Review of the Cercyon Leach (Coleoptera, Hydrophilidae, Sphaeridiinae) of the Greater Antilles.” ZooKeys 681 (June 21, 2017): 39–93. https://doi.org/10.3897/zookeys.681.12522.
6. Penev, Lyubomir, Teodor Georgiev, Peter Geshev, Seyhan Demirov, Viktor Senderov, Iliyana Kuzmova, Iva Kostadinova, Slavena Peneva, and Pavel Stoev. “ARPHA-BioDiv: A Toolbox for Scholarly Publication and Dissemination of Biodiversity Data Based on the ARPHA Publishing Platform.” Research Ideas and Outcomes 3 (April 5, 2017): e13088. https://doi.org/10.3897/rio.3.e13088.
7. Penev, Lyubomir, Daniel Mietchen, Vishwas Chavan, Gregor Hagedorn, Vincent Smith, David Shotton, Éamonn Ó Tuama, et al. “Strategies and Guidelines for Scholarly Publishing of Biodiversity Data.” Research Ideas and Outcomes 3 (February 28, 2017): e12431. https://doi.org/10.3897/rio.3.e12431.

## Presentations

All presentations given are stored


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
