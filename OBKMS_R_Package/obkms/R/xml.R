# __   ____  __ _
# \ \ / /  \/  | |
#  \ V /| \  / | |
#   > < | |\/| | |
#  / . \| |  | | |____
# /_/ \_\_|  |_|______|
#
#
# Functions to work with XML
#

#' taxpub2rdf: Given an XML filename of a file with TaxPub XML, it converts it to RDF
#'
#' Design:
#'
#' The function needs access to OBKMS for minting identifiers. First, the function
#' reads the XML file. Then it relies on a number of other functions that it calls
#' successively to generate the triples.
#'
#' @param xml_filename           character, containing the name of the TaxPub XML file
#' @param obkms_access_options   list with access information
#'
#' @examples
#' \dontrun{}
#' @export

taxpub2rdf = function( xml_filename, obkms_access_options ) {
  # OPEN XML FILE
  taxpub_xml = xml2::read_xml( xml_filename )

  # INITIALIZE
  prefixes = c()
  rdf_body = c()

  # EXTRACT PUBLISHER INFORMATION
 # prefixes = c(prefixes, extract_publisher( taxpub_xml, obkms_access_options, prefix = TRUE) )
  rdf_body = c(rdf_body, extract_publisher( taxpub_xml, obkms_access_options, prefix = FALSE ) )

  # CONSTRUCT TURTLE
  rdf_head = prefix_ttl( unique ( prefixes ) )
  rdf = c( rdf_head, rdf_body )

  return ( rdf )
}


#' A function to extract the publisher information from XML
#'

extract_publisher_info = function( xml ) {
  # Xpath
  x = list()
  x[['publisher_name']] = "/article/front/journal-meta/publisher/publisher-name"
  x[['journal_title']] = "/article/front/journal-meta/journal-title-group/journal-title"

  # Entities and literals
  local = list()
  literals = list()
  literals[['publisher_name']] =  xml2::xml_text( xml2::xml_find_all(
                                            xml, x$publisher_name)[[1]])
  literals[['journal_title']] =  xml2::xml_text( xml2::xml_find_all(
                                            xml, x$journal_title)[[1]])

 # literals[['publisher_name']] = XML::xmlValue ( XML::getNodeSet( xml , x$publisher_name )[[1]] )
#  literals[['journal_title']] = XML::xmlValue ( XML::getNodeSet( xml , x$journal_title )[[1]] )
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))

  # Triples
  stopifnot( exists( 'entities', obkms ))
  #attach(obkms, warn.conflicts = FALSE)
  triples = matrix (nrow = 0, ncol = 4, dimnames =  list(c(), c("graph", "subject", "predicate", "object")))
  triples = rbind( triples,
                   c( "", local$publisher, obkms$entities$a, obkms$entities$agent ) )
  triples = rbind( triples,
                   c( "", local$publisher, obkms$entities$pref_label, squote ( literals$publisher_name ) ) )
  triples = rbind( triples,
                   c( "", local$publisher, obkms$entities$holds_role_in_time, local$publisher_role ) )
  triples = rbind( triples,
                   c( "", local$publisher_role, obkms$entities$with_role, obkms$entities$publisher ) )
  triples = rbind( triples,
                   c( "", local$publisher_role, obkms$entities$relates_to_document, local$journal ) )
  triples = rbind( triples,
                   c( "", local$journal, obkms$entities$relates_to_document, squote ( literals$journal_title ) ) )
  #detach(obkms)


  # journal_name = xml_text(xml_find_all(taxpub_xml, "/article/front/journal-meta/journal-id")[[1]])
  # journal_id = get_or_create_node_by_label( obkms_opts, journal_name)
  #
  #
  # rdf = "
  # prefix fabio: <fdfsdsfsdfs> .
  # %journal_id a fabio:Journal"
  return( triples )
}

