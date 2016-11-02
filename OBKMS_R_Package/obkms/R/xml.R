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


#' A function to extract the publisher information
extract_publisher = function( taxpub_xml, obkms_opts, prefix = FALSE ) {
  # XPATH's
  publisher_name_xpath = "/article/front/journal-meta/publisher/publisher-name"

  # PREFIXES
  prefixes = c("pensoft", "skos", "foaf", "pro")

  # ID's
  publisher_name = xml2::xml_text(xml2::xml_find_all(taxpub_xml, publisher_name_xpath)[[1]])
  publisher_id = get_nodeid( obkms_opts, publisher_name )
  # try to convert to Qname
  pqname = qname( publisher_id )
  if ( !is.null( pqname$prefix ) ) {
    publisher_id = pqname$uri
    prefixes = c( prefixes, pqname$prefix )
  }

  # RDF
  rdf = c()
  rdf = c(rdf, begin_couplet ( publisher_id, "a", "foaf:Agent" ))
  rdf = c(rdf, add_po( "skos:prefLabel", publisher_name, literal = TRUE))
  rdf = c(rdf, add_po( "pro:holdsRoleInTime", ))
  rdf = c(rdf, end_couplet())
  rdf = do.call( paste0, as.list( rdf ) )

    paste( publisher_id, "skos:prefLabel", publisher_name )

  # journal_name = xml_text(xml_find_all(taxpub_xml, "/article/front/journal-meta/journal-id")[[1]])
  # journal_id = get_or_create_node_by_label( obkms_opts, journal_name)
  #
  #
  # rdf = "
  # prefix fabio: <fdfsdsfsdfs> .
  # %journal_id a fabio:Journal"
  return(rdf)
}

