# Vocabulary of Taxonomic Statuses

This document introduces the OpenBiodiv taxonomic status vocabulary both in a
formal way (RDF compatible with SKOS) and in an informal way. To compile:

```
notangle -R"Vocabulary Taxonomic Statuses" taxonomic_statuses_vocabulary.md > taxonomic_status_vocab.ttl
```

## What is a taxonomic status?

[Taxonomic name usages](RDF_Guide.md) (TNU's) in taxonomic articles may be
accompanied by strings such as "new. comb.", "new syn.", "new record for
Cuba", and many others. These postfixes to a taxonomic name usage are called
in our model taxonomic statuses and have taxonomic as well nomenclatural
meaning. For example, if we are describing a species new to science, we may
write "n. sp." after the species name, e.g. "*Heser stoevi* Deltchev sp. n."
This particular example is also a nomenclatural act in the sense of the Codes
of zoological or botanical nomenclature.

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
(see section Rules in [RDF guide](RDF_Guide.md)).

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

@prefix : <http://openbiodiv.net/> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

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

rdfs:label "Taxon Concept Label"@en ;

rdfs:comment "Sometimes, incorrectly a taxon concept label (sec. Author (year) may be
misunderstood and marked up) as a taxonomic status. This term has been created
to indicate that a particular TNU is taxonomic concept label.
"@en .
              
@
```

[taxon_concept_label.txt](R/taxon_concept_label.txt)