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
    xml = xml2::read_xml( resource_locator )
  }

  # load xpath
  if ( resource_format == "TAXPUB" ) {
    # load xpath for taxpub XML format
    xlit = yaml::yaml.load_file( obkms$config$literals_db_xpath )
  }

  # first, metadata
  triples = list()
  #triples[['metadata']] = data.frame(extract_publisher_info( xml ), stringsAsFactors = FALSE)
  triples[['metadata']] = extract_metadata( xml, xlit )
  triples[['front_matter']] = extract_front_matter ( xml, xlit )

  # before we serialize, we need the contaxt (graph name)
  doi = xml2::xml_text( xml2::xml_find_all( xml, xlit$doi ) [[1]] )
  context = get_context_of ( doi )
  turtle = prepend_prefixes()
  turtle = c(turtle, triples2turtle ( context, triples$metadata ) )
  turtle = c(turtle, triples2turtle ( context, triples$front_matter ) )

  return ( do.call(paste, as.list(turtle )))
}
#
#
#' Extract metadata from an XML2 object
#' @param xml \emph{XML2} object
#' @param xlit \emph{list} of XPATH locations of literals entities
#' @export
extract_front_matter = function( xml, xlit ) {
  # all the entity generating functions can return NULL
  # in this case the triple constructing function will return an empty triple
  # literals
  literals = as.list( find_literals( xml, xlit ) )

  # local entities
  local = list()
  local[['front_matter']] = qname ( get_nodeid(  ) )
  local[['title']] = qname ( get_nodeid() )
  local[['abstract']] = qname ( get_nodeid() )

  # triples
  attach(obkms, warn.conflicts = FALSE)

  triples = list(
    triple( local$front_matter,      entities$a,        entities$front_matter ),
    triple( local$front_matter,      entities$contains, local$title),
    triple( local$front_matter,      entities$contains, local$abstract),
    triple( local$front_matter,      entities$first_item,
                                      list( triple("", entities$item_content, local$title),
                                            triple("", entities$next_item,
                                                list( triple( "", entities$item_content, local$abstract))))))

       #TODO fabio:hasSubjectTerm
       #TODO fabio:hasDiscipline
       #TODO dcterms:creator
  detach(obkms)

  return(  triples )
}
#
#
#' Extract info from the front-matter
#'
extract_metadata = function( xml, xlit ) {
  # all the entity generating functions can return NULL
  # in this case the triple constructing function will return an empty triple
  # literals
  literals = as.list( find_literals( xml, xlit ) )

  # local entities
  local = list()
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))
  local[['article']] = qname ( get_nodeid ( literals$doi ) )

  # triples
  attach(obkms, warn.conflicts = FALSE)
  triples = matrix (nrow= 0, ncol = 3, byrow = TRUE,
                    dimnames =  list(c(), c("subject", "predicate", "object")))
  triples = rbind(triples,
                  triple( local$publisher,      entities$a,                   entities$agent ),
                  triple( local$publisher,      entities$pref_label,          squote ( literals$publisher_name ) ) ,
                  triple( local$publisher,      entities$holds_role_in_time,  local$publisher_role ),
                  triple( local$publisher_role, entities$a,                   entities$role_in_time ),
                  triple( local$publisher_role, entities$with_role,           entities$publisher ),
                  triple( local$publisher_role, entities$relates_to_document, local$journal ),
                  triple( local$journal,        entities$a,                   entities$journal ),
                  triple( local$journal,        entities$pref_label,          squote ( literals$journal_title ) ),
                  triple( local$journal,        entities$alt_label,           squote ( literals$abbrev_journal_title ) ),
                  triple( local$journal,        entities$issn,                squote ( literals$issn ) ),
                  triple( local$journal,        entities$eissn,               squote ( literals$eissn ) ),
                  triple( local$journal,        entities$dcpublisher,         squote ( literals$publisher_name ) ),
                  triple( local$journal,        entities$frbr_haspart,        local$article ),
                  triple( local$article,        entities$a,                   entities$journal_article ),
                  triple( local$article,        entities$pref_label,          squote( literals$doi ) ),
                  triple( local$article,        entities$prism_doi,           squote( literals$doi ) ),
                  triple( local$article,        entities$has_publication_year, squote( literals$pub_date, "^^xsd:gYear" ) ) ,
                  triple( local$article,        entities$title,               squote(literals$article_title, "@en-us")))
  #TODO fabio:hasSubjectTerm
  #TODO fabio:hasDiscipline
  #TODO dcterms:creator
  detach(obkms)

  return( as.data.frame( triples ) )
}

#' Find literals

find_literals = function( xml, x  ) {
  r =
    sapply( names(x), function( l ) {
      ns = xml2::xml_find_all( xml, x[[l]] )
      # ns is a list
      if ( length( ns ) == 0) return ( NULL )
      else return ( xml2::xml_text( ns[[1]] ) )
    })
}

#' Ensure correctness of a triple
#' @param S \emph{character} subject
#' @param P \emph{character} predicate
#' @param O \emph{character OR list} object
#' @return NULL, if one of the values is missing, a character of length 3 otherwise
#' unless blank is TRUE, then S = ""
triple = function(S, P, O, blank = FALSE) {
  if ( blank == TRUE ) {
    S = c("")
    if ( is.null(P) || is.null(O) ) return ( NULL )
    if ( is.list (O) ) return ( list( S, P, O ) )
    else return ( c( S,P,O))
  }
  if ( is.null(S) || is.null(P) || is.null(O) ) return ( NULL )
  if ( is.list (O) ) return( list(S, P, O) )
  else return ( c(S,P,O))
}
