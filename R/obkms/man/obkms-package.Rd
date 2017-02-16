\name{obkms-package}
\alias{obkms-package}
\alias{obkms}
\docType{package}
\title{
\packageTitle{obkms}
}
\description{
\packageDescription{obkms}
}
\details{

The DESCRIPTION file:
\packageDESCRIPTION{obkms}
\packageIndices{obkms}

~~ An overview of how to use the package, including the most ~~
~~ important functions ~~

The functions in this package are separated into the following categories:

\enumerate{
  \item{Initialization functions:
    \itemize{
      \item{\link{init_env} creates a new environment with the access data for the graph database}
      \item{\link{load_yaml_database} Loads a package database from a yaml file (needs review)}
    }
  }
  \item{Quering functions:
    \itemize{
      \item{\link{get_nodeid} returns the URI('s) of a node matching a given label from the Knowledge Base}
      \item{\link{get_context_of} gets the graph name of an article of it exists}
      \item{\link{submit_turtle} submits the RDF string (in Turtle syntax) to OpenBiodiv}
      \item{\link{clear_context} deletes a named graph from the Knowledge Base}
      \item{\link{clear_default_graph} deletes the default graph Knowledge Base}
      \item{\link{clear_named_graph} deletes all named graphs from the Knowledge Base}
      \item{\link{clear_all} removes all graphs}
      \item{\link{delete_node_data} deletes all triples where a given node is a subject or object}
      \item{\link{count_triples} How many statements do we have}
      \item{\link{count_scientific_names} Count how many distinct names there are}
      \item{\link{find_related_names} Finds all related names to a given name}
      }
    }
  \item{RDF-specific functions:
    \itemize{
      \item{\link{prefix_ttl} Returns a prefix string in Turtle}
      \item{\link{qname} inimizes a URI to a Qname.}
      \item{\link{strip_angle} A function to strip the angle brackets}
      \item{\link{squote} Semantic quote. Function to quote literals for use in RDF}
      \item{\link{turtle_prepend_prefixes} Use the prefix database to create Turtle statements}
     \item{\link{triples2turtle} Converts a matrix of triple to Turtle statements, given a context.}
      \item{\link{write_couplet} Writes a single couplet for the given subejct}
     \item{\link{write_predicate_stanza} Writes the predicate-object stanza after a subject has been written}
      \item{\link{triples2turtle2} works with lists of triples instead of data frames}
     \item{\link{write_couplet2} Writes a single couplet for the given subejct with triples in a list}
     \item{\link{write_predicate_stanza2} takes care of the predicates, but with the triple structure a list}
     \item{\link{write_end_stanza}}
      \item{\link{write_end_stanza2}}
  }}
  \item{XML functions:
    TODO: Probably a lot of these functions do not have to be exported
  \itemize{
    \item{\link{xml2rdf} Converts an XML document to RDF}
    \item{\link{extract_information} Top level extractor}
    \item{\link{construct_tnu_triples} Connects one local entity, to a list of the names that have been used via an intermediate class TNU}
    \item{\link{construct_nomen_triples} Construct the nomen triples by creating a NomenclaturalAct}
    \item{\link{extract_scientific_names_used} Extract taxonomic name usages from an XML nodeset}
    \item{\link{extract_valid_name} Extract the valid name (first citation) from a nomenclatural section in the XML}
    \item{\link{extract_nomen_citations} Extract nomenclature citations (next citations) from a nomenclatural section in the XML}
    \item{\link{extract_single_scientific_name} Extracts only one scientific name from an XML node}
    \item{\link{find_literals} Find literals}
    \item{\link{find_local_xml}  Finds the XML nodes corresponding to semantic entities}
    \item{\link{find_document_component_entities}  Finds document components id and xml nodes}
    \item{\link{triple} Ensure correctness of a triple}
  }}
}
}

\author{
\packageAuthor{obkms}

Maintainer: \packageMaintainer{obkms}
}
\references{
~~ Literature or other references for background information ~~
}
~~ Optionally other standard keywords, one per line, from file ~~
~~ KEYWORDS in the R documentation directory ~~
\keyword{ package }
\seealso{
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
~~ simple examples of the most important functions ~~
}
