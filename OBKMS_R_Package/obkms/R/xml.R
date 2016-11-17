#                 _ ____          _  __
# __  ___ __ ___ | |___ \ _ __ __| |/ _|
# \ \/ / '_ ` _ \| | __) | '__/ _` | |_
#  >  <| | | | | | |/ __/| | | (_| |  _|
# /_/\_\_| |_| |_|_|_____|_|  \__,_|_|
#
#' Convert an XML document to RDF
#' @author Viktor Senderov
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
    xml = xml2::read_xml( resource_locator , options = c())
    # doi of the article: needed to set the context later
    doi = xml2::xml_text( xml2::xml_find_all( xml, xlit$doi ) [[1]] )
    context = qname( get_context_of ( doi ) )
  }
  # load xpath
  if ( resource_format == "TAXPUB" ) {
    # load xpath for taxpub XML format
    xlit = yaml::yaml.load_file( obkms$config$literals_db_xpath )
    xnonlit = yaml::yaml.load_file( obkms$config$non_literals_db_xpath )
  }
  # construct list of triples lists
  triples = extract_information( xml, xlit, xnonlit )
  # serialize
  serialization = c()
  if (serialization_format == "TURTLE") {
    serialization = turtle_prepend_prefixes()
    serialization = c ( serialization, triples2turtle2 ( context, triples$article ), "\n" )
    serialization = c( serialization, triples2turtle2( "pensoft:Nomenclature", triples$nomenclature))
  }
  # return the return string as a string
  return ( do.call(paste, as.list( serialization )))
}
#===============================================================================
#            _                  _       _        __                            _   _
#   _____  _| |_ _ __ __ _  ___| |_    (_)_ __  / _| ___  _ __ _ __ ___   __ _| |_(_) ___  _ __
#  / _ \ \/ / __| '__/ _` |/ __| __|   | | '_ \| |_ / _ \| '__| '_ ` _ \ / _` | __| |/ _ \| '_ \
# |  __/>  <| |_| | | (_| | (__| |_    | | | | |  _| (_) | |  | | | | | | (_| | |_| | (_) | | | |
#  \___/_/\_\\__|_|  \__,_|\___|\__|___|_|_| |_|_|  \___/|_|  |_| |_| |_|\__,_|\__|_|\___/|_| |_|
#                                 |_____|
#' Top level extractor
#' @param xml \emph{XML2} object
#' @param xlit \emph{list} of XPATH locations of literals entities
#' @return \emph{list} of named triples lists, the name corresponds to the
#' context
#' @export
extract_information = function( xml, xlit, xnonlit ) {
  # all the entity generating functions can return NULL
  # in this case the triple constructing function will return an empty triple
  # Literals
  literals = as.list( find_literals( xml, xlit ) )
  # Entities
  local = list()
  local[['article']] = qname ( get_nodeid ( literals$doi ) )
  local[['front_matter']] = qname ( get_nodeid(  ) )
  local[['title']] = qname ( get_nodeid() )
  local[['abstract']] = qname ( get_nodeid() )
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))
  # Triples
  # we have several contexts: article related triples
  # and nomenclature_triples
  nomenclature_triples = list()
  attach(obkms, warn.conflicts = FALSE)
  triples = list(
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
    #TODO fabio:hasSubjectTerm
    #TODO fabio:hasDiscipline
    #TODO dcterms:creator
    triple( local$article,        entities$a,                   entities$journal_article ),
    triple( local$article,        entities$pref_label,          squote( literals$doi ) ),
    triple( local$article,        entities$prism_doi,           squote( literals$doi ) ),
    triple( local$article,        entities$has_publication_year, squote( literals$pub_date, "^^xsd:gYear" ) ) ,
    triple( local$article,        entities$title,               squote(literals$article_title, "@en-us")),
    triple( local$article,           entities$contains, local$front_matter),
    triple( local$front_matter,      entities$a,        entities$front_matter ),
    triple( local$front_matter,      entities$contains, local$title),
    triple( local$front_matter,      entities$contains, local$abstract),
    triple( local$front_matter,      entities$first_item,
                                      list( triple("", entities$item_content, local$title),
                                            triple("", entities$next_item,
                                                list( triple( "", entities$item_content, local$abstract))))),
    triple( local$title,         entities$a,                      entities$doco_title),
    triple( local$title,         entities$has_content,            squote(literals$article_title, "@en-us"   )),
    triple( local$abstract,    entities$a,               entities$sro_abstract))
  # Process taxa in different parts of the manuscript
  # look for taxa in the title and attach them
  title_nodeset = xml2::xml_find_all( xml, xlit$article_title )
  new_triples =
              construct_tnu_triples( title_nodeset , local$title)
  triples = c( triples, new_triples$article)
  nomenclature_triples = c(nomenclature_triples, new_triples$nomenclature)

  # look for taxa in the abstract
  abstract_nodeset = xml2::xml_find_all( xml, xlit$article_abstract )
  new_triples =
    construct_tnu_triples( abstract_nodeset , local$abstract )
  triples = c( triples, new_triples$article)
  nomenclature_triples = c(nomenclature_triples, new_triples$nomenclature)
  #look for taxa in figures
  # this includes figs in captions
  #a figure is something tagged by <fig></fig>
  #it may or may not be wrapped in a figure group
  #xpath expressions must be stored in another group (non-literal)
  #non-literals ideally already have an id in the XML
  #start with free standing figs
  #local_figs is a list of the new fig entitites
  #fig_tnus are the Taxon Name Usages (taxa and rdf) per fig
  local[['figures']] = list()
    free_standing_figs_ns = xml2::xml_find_all( xml, xnonlit$free_standing_figs)
  j = 1
  for ( figure_node in free_standing_figs_ns ) {
    id = xml2::xml_text( xml2::xml_find_all ( figure_node, xnonlit$rel_figid ) )
    local$figures[[j]] = qname( get_nodeid( "", id ) )
    triples = c(triples,
               list( triple ( local$article, entities$contains, local$figures[[j]] )))
    triples = c(triples,
                   list(  triple( local$figures[[j]], entities$a, entities$figure) ))
    new_triples =
                construct_tnu_triples( figure_node, local$figures[[j]] )
    triples = c( triples, new_triples$article)
    nomenclature_triples = c(nomenclature_triples, new_triples$nomenclature)
  }
  # look for taxa in plates captions
  # ...

  # prep return values
  triples = list(article = triples, nomenclature = nomenclature_triples)
  detach( obkms )
  return(  triples )
}

#' Extract TNU's from a XML nodeset, and construct triples, attaching them
#' to a given semantic entity
#' @param xml the XML document
#' @param nodeset_xpath where in the XML do we look for TNU's
#' @param attachment_entity the node it to which we ought to attach the new

#' TNU's triples
#' @return \emph{list} of triples
construct_tnu_triples = function ( working_nodeset, attachment_entity) {
  new_tnus = extract_tnu ( working_nodeset )
  triples = list()
  i = 1
  for ( t in new_tnus$tnu ) {
    new_tnu = qname ( get_nodeid() )
    triples[[i ]] = triple( attachment_entity, entities$realization_of, new_tnu)
    i = i + 1
    triples[[i ]] = triple( new_tnu, entities$a, entities$tnu)
    i = i + 1
    triples[[i ]] = triple( new_tnu, entities$dwciri_scientific_name, t)
    i = i + 1
  }
  return( list( article = triples, nomenclature = new_tnus$rdf ) )
}

#' Extract taxonomic name usages from an XML nodeset
#' It also looks into descendant nodes thanks to the // in Xpath
#' Actually we want to submit nomenclature right away to OBKMS
#' so as not have duplicates.
#' @param nodeset \emph{xml_nodeset} to check for TNU's
#' @return \emph{list} of scientific name id's and triples with information
#' @export
extract_tnu = function ( xml_ns ) {
  ret_value = list() # triples and names
  # look for the TNU tag
  x = list()
  x[['tnu']] = ".//tp:taxon-name"
  x[['taxon_name_part']] = ".//tp:taxon-name-part" # counting from taxon-name
  x[['dwc_rank']] = "./tp:taxon-name-part/@taxon-name-part-type" # counting from taxon-name
  # entities
  tnu_xml = xml2::xml_find_all( xml_ns, x$tnu )
  # triples
  triples = list()
  tnu = list()
  attach(obkms, warn.conflicts = FALSE)
  # for each of the scientific names we will get or create a node a network
  i = 1
  for( t in tnu_xml ) {
    # there are two kinds: binomial and monomial
    # construct the label of the scientific name with which to query OBKMS
    label = xml2::xml_text( t )
    scientific_name = qname( get_nodeid( label ) )
    tnu = c( tnu, scientific_name )
    triples[[ i ]] = triple( scientific_name, entities$a, entities$scientific_name )
    i = i + 1
    triples[[ i ]] = triple( scientific_name, entities$pref_label, squote( label ) )
    i = i + 1
    # rank
    rank = xml2::xml_text( xml2::xml_find_all( t, x$dwc_rank) )
    if ( length( rank ) > 1 ) rank = "species"
    triples[[i]] = triple( scientific_name, entities$rank, squote( rank ) )
    i = i + 1
    # literal scientifc name
    literal_scientific_name = xml2::xml_text( xml2::xml_find_all( t, x$taxon_name_part ) )
    # depending on the rank, we do different things with the literal
    # species, binomial case, xml_text has returned two things
    if ( rank == "species" ) {
      triples[[i]] = triple(scientific_name, entities$species, squote( literal_scientific_name[2] ) )
      i = i + 1
      triples[[i]] = triple(scientific_name, entities$genus, squote( literal_scientific_name[1] ) )
      i = i + 1
    }
    else {
      triples[[i]] =
                   triple(scientific_name, entities[[rank]], squote( literal_scientific_name ) )
      i = i + 1
    }
    # now triple
  }
  detach(obkms)
  return ( list( tnu = tnu, rdf = triples ) )
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
  # this has not been tested yet, probably needs a list around the return anyway
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

#      _ _   _ _   _ _  __
#   | | | | | \ | | |/ /
#  _  | | | | |  \| | ' /
# | |_| | |_| | |\  | . \
#  \___/ \___/|_| \_|_|\_\

#
#' Extract info from the front-matter, data frame based
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

#===============================================================================

#
#' Extract metadata from an XML document but return value is a list
#' @inheritParams extract.front_matter
#' @return \emph{list} of triples
extract.metadata = function( xml, xlit ) {
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
  triples = list(
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
  return(  triples  )
}
