#' Imports a DarwinCore-Archive
#' Occurrences are matched to taxa based on 'scientificName' and
#' 'identificationRemarks' . If no match is found, a new taxon
#' is created.
#' @param dirname path to where the DwC-A is found
#' @param sec the identification remarks to use, if you want to override
#' @param context URI (or QNAME) of the context graph to use
#' the file (maybe database name?)
#' @return rdf in the turtle format, ready to be imported in the OBKMS
import_dwc_a = function ( dirname, sec = NULL, context ) {

   occurrences = read.csv( paste0( dirname, "occurrences.csv" ) )
  if ( !is.null ( sec ) ) {
    # extend the occurrences dataframe with sec information
    # secs must be the preferred label of the work e.g. DOI
    occurrences$idenficationRemarks = rep ( sec, nrow( occurrences ) )
  }
    # now each row of the dataframe needs to be transformed into RDF
    # the context of the RDF needs to be dataset somehow?
    # a function to return taxon concept turtle
    # then basically concatenate them and put them in the concept graph
  ttl = list ()
  for ( i in nrow ( occurrences ) ) {
    ttl[[i]] = rdfize_occurrence_record ( occurrences[i, ] )
  }
  ttl = do.call( paste, ttl )
  ttl = paste0 ( context, " {\n", ttl, "\n}")
  return ( ttl )
}

#' Rdfizes a single tabular occurrence record
#' @param occ an occurrence record as list (data.frame)
#' @return rdf in turtle format
rdfize_occurrence_record = function ( occ ) {

}

#' A function to read frbr:Works from a Yaml file (modeled after Bibtex)
#' and input them into OBKMS. Then the labels of this works
#' can be used to taxon concepts. TODO when properly implementing
#' this function, effort should be made to first look for the
#' work in OBKMS if say DOI or ISBN/ ISSN is present, or if the
#' same label is already present. If the same label is used, there
#' should also be a match in the title.
#' @param bibtex_yaml file-path of where a Yaml file (modeled after Bibtex) is found with the works
#' @return success status of what happened during the import
input_works = function ( bibtex_yaml ) {
  works = yaml::yaml.load_file( bibtex_yaml )
  for ( w in works ) {
    local = list() # local semantic entities
    local$work = qname( get_nodeid( get_now$prefLabel ) )
    # now we need to start writing RDF about the work_entity
    triples = list(
      #publisher
      triple( local$work,           entities$a,                   entities$work ),
      triple( local$work,           entities$creator,             squote ( w$creator ) ) ,
      triple( local$work,           entities)
  }
}
