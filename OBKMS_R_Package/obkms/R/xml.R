# __   ____  __ _
# \ \ / /  \/  | |
#  \ V /| \  / | |
#   > < | |\/| | |
#  / . \| |  | | |____
# /_/ \_\_|  |_|______|
#
# Functions to work with XML
#
#
#
#' Convert an XML document to RDF
#' @author Viktor Senderov
#'
#' @param resource_locator
#'        address/ location of the XML resource
#' @param resouce_type
#'        type of location of the XML resource;
#'        one of "FILE"
#' @param resource_format
#'        XML schema of the XML resource;
#'        one of "TAXPUB"
#' @param serialization_format
#'        output serialization format of the RDF;
#'        one of "TURTLE"
#' @export
xml2rdf = function( resource_locator, resource_type = "FILE",
                    resource_format = "TAXPUB", serialization_format = "TURTLE")
{
  # checks
  stopifnot ( is.character(resource_type), resource_type == "FILE" )
  stopifnot ( is.character(resource_format), resource_format == "TAXPUB" )
  stopifnot ( is.character(serialization_format), serialization_format
              == "TURTLE" )

  # load XML
  if ( resource_type == "FILE" ){
    xml = xml2::read_xml( resource )
  }

  # load xpath
  if ( resource_format == "TAXPUB" ) {
    # load xpath for taxpub XML format
    x = yaml::yaml.load_file( obkms$config$xpath_taxpub_db )
  }

  # entities, triples and literals
  triples = list()
  local = list()
  literals = list()

  # find all the literals
  literals[['publisher_name']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$publisher_name ) [[1]] )
  literals[['journal_title']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$journal_title ) [[1]] )
  literals[['abbrev_journal_title']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$abbrev_journal_title ) [[1]] )
  literals[['issn']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$issn ) [[1]] )
  literals[['eissn']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$eissn ) [[1]] )
  literals[['doi']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$doi ) [[1]] )

  # first, metadata
  #triples[['metadata']] = data.frame(extract_publisher_info( xml ), stringsAsFactors = FALSE)

  # before we serialize, we need the contaxt (graph name)
  doi = xml2::xml_text( xml2::xml_find_all( xml, x$doi ) [[1]] )
  context = get_context_of ( doi )
  turtle = prepend_prefixes()
  turtle = c(turtle, triples2turtle ( context, triples$publisher ) )

  return ( do.call(paste, as.list(turtle )))
}
#
#
#
#' A function to extract the publisher information from XML
#' @export
extract_publisher_info = function( xml ) {
  # Xpath
  x = list()
  x[['publisher_name']] = "/article/front/journal-meta/publisher/publisher-name"
  x[['journal_title']] = "/article/front/journal-meta/journal-title-group/journal-title"
  x[['abbrev_journal_title']] = "/article/front/journal-meta/journal-title-group/abbrev-journal-title"
  x[['issn']] = "/article/front/journal-meta/issn[@pub-type='ppub']"
  x[['eissn']] = "/article/front/journal-meta/issn[@pub-type='epub']"
  x[['doi']] = "/article/front/article-meta/article-id[@pub-id-type='doi']"

  # Entities and literals
  local = list()
  literals = list()
  literals[['publisher_name']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$publisher_name ) [[1]] )
  literals[['journal_title']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$journal_title ) [[1]] )
  literals[['abbrev_journal_title']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$abbrev_journal_title ) [[1]] )
  literals[['issn']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$issn ) [[1]] )
  literals[['eissn']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$eissn ) [[1]] )
  literals[['doi']] =
    xml2::xml_text( xml2::xml_find_all( xml, x$doi ) [[1]] )

# literals[['publisher_name']] = XML::xmlValue ( XML::getNodeSet( xml , x$publisher_name )[[1]] )
#  literals[['journal_title']] = XML::xmlValue ( XML::getNodeSet( xml , x$journal_title )[[1]] )
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))
  local[['article']] = qname ( get_nodeid ( literals$doi ) )

  # Triples
  stopifnot( exists( 'entities', obkms ))
  #attach(obkms, warn.conflicts = FALSE)
  triples = matrix (nrow = 0, ncol = 3, dimnames =  list(c(), c("subject", "predicate", "object")))
  triples = rbind( triples,
                   c( local$publisher, obkms$entities$a, obkms$entities$agent ) )
  triples = rbind( triples,
                   c( local$publisher, obkms$entities$pref_label, squote ( literals$publisher_name ) ) )
  triples = rbind( triples,
                   c( local$publisher, obkms$entities$holds_role_in_time, local$publisher_role ) )
  triples = rbind( triples,
                   c( local$publisher_role, obkms$entities$a, obkms$entities$role_in_time ) )
  triples = rbind( triples,
                   c( local$publisher_role, obkms$entities$with_role, obkms$entities$publisher ) )
  triples = rbind( triples,
                   c( local$publisher_role, obkms$entities$relates_to_document, local$journal ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$a, obkms$entities$journal ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$pref_label, squote ( literals$journal_title ) ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$alt_label, squote ( literals$abbrev_journal_title ) ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$issn, squote ( literals$issn ) ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$eissn, squote ( literals$eissn ) ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$dcpublisher, squote ( literals$publisher_name ) ) )
  triples = rbind( triples,
                   c( local$journal, obkms$entities$frbr_haspart, local$article ) )
  triples = rbind( triples,
                   c( local$article, obkms$entities$a, obkms$entities$journal_article ) )
  triples = rbind( triples,
                   c( local$article, obkms$entities$pref_label, squote( literals$doi ) ) )
  triples = rbind( triples,
                   c( local$article, obkms$entities$prism_doi, squote( literals$doi ) ) )

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

