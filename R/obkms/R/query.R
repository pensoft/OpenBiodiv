#     ____    _    _   ______   _____   __     __
#    / __ \  | |  | | |  ____| |  __ \  \ \   / /
#   | |  | | | |  | | | |__    | |__) |  \ \_/ /
#   | |  | | | |  | | |  __|   |  _  /    \   /
#   | |__| | | |__| | | |____  | | \ \     | |
#    \___\_\  \____/  |______| |_|  \_\    |_|
#
#
# OBKMS Query Functions
#

#' Given a label, tries to get the GUID of the node that has that label in OBKMS
#'
#' We need a helper function to get or create an node (id) for the network given a preferred label (`skos:prefLabel`)
#'

#' @param options           a list returned by \code{create_server_options}.
#' @param explicit_node_id  when we already know the node id (for example from the XML)
#'
#' @examples
#' \dontrun{}
#' @export

get_nodeid = function( label = "", explicit_node_id = "", allow_multiple = FALSE) {
  # this trimming should probably not happen here!!!, it should happen before the function
  # is called,
  # i will leave them because of bug but need to be removed
  label = gsub("[\t]+", " ", label)
  label = gsub("[\n]+", " ", label)
  label = gsub("[ ]+", " ", label)
  if ( is.character(explicit_node_id) && explicit_node_id != "" ) {
    return ( paste( "http://id.pensoft.net/", explicit_node_id , sep = "") )
  }

  stopifnot( exists( "obkms", mode = "environment" ) )
 # attach(obkms, warn.conflicts = FALSE)

  query.template =
    "PREFIX skos: %skosns
    SELECT ?id
    WHERE {
      ?id skos:prefLabel %label .
    }"

  if ( is.character( label) && label != "" ) {
      query.template = gsub( "%label", paste( '\"', label, '\"', sep = "" ), query.template )
      query = gsub( "%skosns", obkms$prefixes$skos, query.template )
      res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
      # check for non-emptiness
      if (!( is.data.frame( res ) && nrow ( res ) == 0 )) {
        # what TODO if ambigious?
        stopifnot(!( allow_multiple == FALSE && length( res$id ) > 1 ))
        return ( as.character( res$id ) )
      }
  }
  # we couldn't match label or label was FALSE, generate a new node
  #detach ( obkms )
  return ( paste( "http://id.pensoft.net/", uuid::UUIDgenerate() , sep = "") )
}


#' Lookup an Identifier in OBKMS
#'
#' This function is similar to `get_nodeid`, but allows more flexibility.
#' Its most basic form is when the user specifies a `preferred_label`
#' and the system searches for all entities in the graph database that match
#' this preferred label exactly.
#'
#' @param label a vector of labels for which to look , the first one is preferred, all other ones are alternative;
#' doesn't have to specified. lookup can done only thru the ...
#' @param trim if TRUE reduces multiple table, new lines, spaces to just one space
#' @param ignore_case if TRUE lowercases everything
#' @param best_match if TRUE will return only one best match
#' @param generate_on_fail if TRUE if no match is found, a new ID is generated
#' @param ... a list of additional things that can be used for look-up . read documentaiton carefully
#'
#' @return a vector of ID's that match, NULL if nothing has matched
#'
#' @examples
#' \dontrun{}
#' @export

lookup_id = function( label, lang = "English", trim = TRUE, ignore_case = TRUE, best_match = TRUE, generate_on_fail = TRUE, concept_type = FALSE, ...)
{
  stopifnot( exists( "obkms", mode = "environment" ) )

        # now start iterating along the labels to look for solution
  if ( !missing( label ) && is.character( label ) && ( length( label ) > 0 ) )
  {
    if ( trim )
    {
      label = gsub("[\t]+", " ", label)
      label = gsub("[\n]+", " ", label)
      label = gsub("[ ]+", " ", label)
    }
    if ( ignore_case )
    {
      # TODO will implement later
    }
    for ( l in label )
    {
      query.template =
        "SELECT ?id WHERE
        { ?id skos:prefLabel %label .
          ?id rdf:type %concept_type .
        }"

      # query substitution
      if ( lang == "English" ) {
        query.template = gsub( "%label", paste( '\"', l, '\"@en', sep = "" ), query.template  )
      }
      else {
        query.template = gsub( "%label", paste( '\"', l, '\"', sep = "" ), query.template  )
      }
      if ( concept_type == "Taxon Keyword" ) {
        query.template = gsub( "%concept_type", paste( '\"', l, '\"@en', sep = "" ), query.template  )
      }
      else {
        query.template = gsub( "%concept_type", qname( obkms$classes$Thing$uri ), query.template  )
      }

      query = gsub( "%skosns", obkms$prefixes$skos, query.template )
      # query execution
      query = c( turtle_prepend_prefixes(t = "SPARQL"), query )
      query = do.call ( paste0, as.list(query))
      res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
      # we want the results to be a list (data frame), we hava a match (multiple matches)
      if ( is.data.frame( res ) && nrow ( res ) > 0 )
      {
        log_event ( paste(  "found matching id for", label ) )
        if (best_match) return ( as.character( res$id )[1] )
        else return(  as.character( res$id ) )
      }
    }
  }
  if ( generate_on_fail ) {
    log_event ( paste( "failed lookup, generating a new id for ", label) )
    return ( qname( paste0( strip_angle( obkms$prefixes$`_base` ), uuid::UUIDgenerate( ) ) ) )
  }
}

#' Gets the graph name of an article of it exists
#' TODO needs review
#' @param doi the DOI of the article the context of which we are looking for
#' @export
get_context_of = function ( doi ) {
  stopifnot( exists( "obkms", mode = "environment" ) )
  query.template =
    "PREFIX skos: %skosns
    SELECT ?g
    WHERE {
      GRAPH ?g {
        ?id skos:prefLabel %label .
      }
    }"
    if ( is.character( doi ) && doi != "" ) {
      query.template = gsub( "%label", paste( '\"', doi, '\"', sep = "" ), query.template )
      query = gsub( "%skosns", obkms$prefixes$skos, query.template )
      res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
      # check for non-emptiness
      if (!( is.data.frame( res ) && nrow ( res ) == 0 )) {
        return ( as.character( res$g ) )
      }
  }
  # we couldn't match label or label was FALSE, generate a new node
  #detach ( obkms )
  return ( paste( "http://id.pensoft.net/", uuid::UUIDgenerate() , sep = "") )
}



#' Submits RDF string (in Turtle syntax) to OBKMS
#' @param rdf the RDF string
#' @export

submit_turtle = function ( rdf ) {
  res = rdf4jr::add_data( obkms$server_access_options,
                          obkms$server_access_options$repository, do.call(paste, as.list(rdf) ))
}

#' Deletes a named graph named context
#' @param context graph name
#' @return status of query
#' @export
clear_context = function ( context ) {
  query.template = "DROP GRAPH %context"
  query = gsub( "%context", context, query.template )
  res = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, query )
  return ( res )
}

#' Remove the default graph
#' @return status of query
clear_default_graph = function() {
  query = "DROP DEFAULT"
  res = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, query )
  return ( res )
}

#' Remove named graphs
#' @return status of query
clear_named_graph = function() {
  query = "DROP NAMED"
  res = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, query )
  return ( res )
}

#' Remove all graphs
#' @return status of query
#' @export
clear_all = function() {
  query = "DROP ALL"
  res = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, query )
  return ( res )
}

#' Delete all triples where a given node is a subject or object
#' @param node_id id of the node to remove
#' @return whatever the update call returns
#' TODO how to return the number of statements
#' @export
delete_node_data = function ( node_id ) {
  # as subject
  q.t = "DELETE {
    %node_id ?P ?O .
}
WHERE {
    %node_id ?P ?O .
}"
  q = gsub( "%node_id", node_id, q.t )
  r1 = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, q )
  q.t = "DELETE {
    ?S ?P %node_id .
}
WHERE {
    ?S ?P %node_id .
}"
  q = gsub( "%node_id", node_id, q.t )
  r2 = rdf4jr::update_repository( obkms$server_access_options , obkms$server_access_options$repository, q )
  return( c( httr::content(r1, as = "text"),  httr::content(r2, as = "text") ) )
}

#' How many statements do we have
#' @param graph from which graph
#' @return number of triples in the graph
#' @export
count_triples = function ( graph ="" ) {
  if ( graph == "" ) {
    query.template = "SELECT (COUNT(*) as ?count)
WHERE {
   ?s ?p ?o .
}"
  }
  else{
    query.template = "SELECT (COUNT(*) as ?count)
FROM %graph
WHERE {
   ?s ?p ?o .
}"
  }
  query = gsub( "%graph", graph, query.template )
  res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
  return ( res )
}

#' Count how many distinct names there are
#' @return number of names
#' @export
count_scientific_names = function() {
  # TODO use the entity for sceintific name instead of hardcoding it!!!
  query = "PREFIX trt: <http://plazi.org/treatment#>
SELECT (COUNT(*) as ?count)
WHERE {
  GRAPH <http://id.pensoft.net/Nomenclature> {
   ?s ?p trt:ScientificName .
  }
}"
  res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
  return ( res )
}

#' Finds all related names to a given name
#' TODO : modify prepend_prefixes function to do both turtle and SPARQL
#' @param sci_name_label the scientific name (label) for which to look for related names
#' @return \emph{list} of related name-ids and their labels
#' @export
find_related_names = function ( sci_name_label ) {
  sci_name = qname( get_nodeid ( sci_name_label ) )
  q.template = "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX trt: <http://plazi.org/treatment#>
PREFIX pensoft: <http://id.pensoft.net/>
PREFIX dwc: <http://rs.tdwg.org/dwc/terms/>
SELECT ?id ?label ?rank
WHERE {
?id trt:relatedName %sci_name ;
    dwc:rank        ?rank ;
   skos:prefLabel   ?label ;
}"
  q = gsub( "%sci_name",  sci_name , q.template )
  r = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, q, "CSV" )
  r$id = sapply( r$id, qname )
  return( r )
}

#' Looks up the id of a concept in dbpedia
#' @export
dbpedia_lookup = function ( label, concept_type = "none", best_match = TRUE , lang = "English")
  {
  # trim
  label = gsub("[\t]+", " ", label)
  label = gsub("[\n]+", " ", label)
  label = gsub("[ ]+", " ", label)

  # process type
  stopifnot( concept_type %in% c( "Taxon", "none" ) )
  if ( concept_type == "Taxon" ) {
      concept_type = obkms$classes$DbpediaBiologicalThing$uri
  }
  else {
      concept_type = obkms$classes$Thing$uri
  }

  #construct query
  query.template =

"SELECT ?resource
WHERE {
  ?resource %rdf_type %concept_type .
  ?resource %label_property %label .
}"

  query.template = gsub( "%rdf_type", obkms$properties$type$uri, query.template )
  query.template = gsub( "%concept_type", concept_type, query.template )
  query.template = gsub( "%label_property", obkms$properties$label$uri, query.template )
  query.template = gsub( "%label", squote( label, lang = lang),  query.template )

  query = query.template

  # now start iterating along the labels to look for solution
  for ( l in label )
  {
    res = rdf4jr::POST_query( obkms$dbpedia_access_options , obkms$dbpedia_access_options$repository, query, "CSV" )
    # we want the results to be a list (data frame), we hava a match (multiple matches)
    if ( is.data.frame( res ) && nrow ( res ) > 0 )
    {
      if (best_match) return ( as.character( res$resource )[1] ) #need to use the variable name to index columns
      else return(  as.character( res$resource ) )
    }
  }
}


#' @export
describe_resource = function( uri )
{

 query.template = "DESCRIBE %uri"
 query.template = gsub( "%uri", uri , query.template )
 query = query.template
 res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
 return ( res )
}

#' Trims a label of extraneous white space characters
#' @param label what to trim
#' @return the "label" with traling or leading whitespace removed, and any
#' extra white space within is removed
#' @export

trim_label = function ( label , removeLeadingDigits = FALSE, removeLeadingWs = TRUE) {
  # trimws takes care of traling and leading spaces, but what about extra ws in
  # the middle?
  label = base::trimws( label , which = "both" )
  # the next should take care of it
  label = gsub("[[:space:]]+", " ", label)
  label = gsub("[ ]+", " ", label)
  if (removeLeadingDigits == TRUE) {
    label = gsub("^[0-9]+", "", label)
  }
  if (removeLeadingWs == TRUE){
    label = gsub("^\\W+", "", label)
  }
  return ( label )
}

#' Looks up an author, given a list of literals
#'
#' @param literals a list of literals associated with the author
#' @param identifiers a list of identifiers associated with the author
#'
#' @return a URI of an author if it already exists, or mints new one
#' @export
lookup_author = function ( literals, identifiers )
{
  # (1) check to see whether it is a collaborative author
  if ( ! is.null( literals$collab ) ) {
    non_persons = obkms$authors[ obkms$authors$is_person == FALSE ]
    # yes, do a fuzzy match of author and exact match of email
    best_match = grep ( literals$collab, non_persons$author )
    obkms$authors$id [ best_match ]

    # TODO not DRY
    if ( length( best_match ) > 0 ) {

      resulting = obkms$authors[ best_match, ]
      aggregated_result =
        aggregate( resulting, by = list( resulting$id ) , length )

      ret_value  = resulting[ which( max (aggregated_result$id) == aggregated_result$id ), 1]
      log_event( paste( "collab author match found", do.call ( paste, as.list( ret_value ) )) )
      return ( ret_value )
    }
  }

  # (2) check if it is a person with an email
  # (a) fuzzy match of last name
  # (b) match beginning of first name
  # and (c) exact match of email
  else if ( !is.null ( literals$email ) ) {
    mbox_match = grep( literals$email, obkms$authors$mbox )
    first_letter = substring( literals$given_name, 1, 1 )
    fname_match = grep ( paste0( "^", first_letter ), obkms$authors$first_name )
    lname_match = agrep( literals$surname, obkms$authors$family_name )
    best_match = intersect ( intersect( fname_match, lname_match), mbox_match )
    # TODO not DRY
    if ( length( best_match ) > 0 ) {
      resulting = obkms$authors[ best_match, ]
      aggregated_result =
        aggregate( resulting, by = list( resulting$id ) , length )
      ret_value = resulting[ which( max (aggregated_result$id) == aggregated_result$id ), 1]
      log_event( paste( "author + mail match found", do.call ( paste, as.list( ret_value ) )) )
      return ( ret_value )
    }
  }

  # (3) match with institution - replace exact match of mailbox with exact match of institution URI
  else if ( !is.null( identifiers$institution) ) {
    institution_match =sapply ( unlist( expand_qname( identifiers$institution ) ), grep, x = obkms$authors$institution )
    first_letter = substring( literals$given_name, 1, 1 )
    fname_match = grep( paste0( "^", first_letter ), obkms$authors$first_name )
    lname_match = agrep( literals$surname, obkms$authors$family_name )
    best_match = intersect ( intersect( fname_match, lname_match ),  institution_match )

    # TODO : definitely not DRY
    if ( length( best_match ) > 0 ) {
      resulting = obkms$authors[ best_match, ]
      aggregated_result =
        aggregate( resulting, by = list( resulting$id ) , length )
      ret_value = resulting[ which( max (aggregated_result$id) == aggregated_result$id ), 1]
      log_event( paste( "author + institution match found", do.call ( paste, as.list( ret_value ) )) )
      return ( ret_value )
    }
  }

  # no match, also updates the local authors database
  log_event( paste( "no match, local db will be updated" , literals$surname) )
  authid = ( paste0( strip_angle( obkms$prefixes$`_base`) , uuid::UUIDgenerate() ) )

  if ( ! is.null( literals$collab ) ) {
    literals =  lapply ( literals, function ( el) {
      if (is.null ( el )) return(NA)
      else return( el )
    })
    for ( instid in unlist ( identifiers$institution ) ) {
      obkms$authors = rbind( obkms$authors,
                             data.frame (id = authid,
                             author = literals$collab,
                             is_person = FALSE,
                             first_name = NA,
                             family_name = NA,
                             mbox = literals$email,
                             institution = expand_qname ( instid ) ) )
    }
  }
  else {
    literals =  lapply ( literals, function ( el) {
      if (is.null ( el )) return(NA)
      else return( el )
    })
    for ( instid in unlist ( identifiers$institution ) ) {
      obkms$authors = rbind( obkms$authors,
                             data.frame (id = authid,
                                         author = paste(literals$given_name, literals$surname),
                                         is_person = TRUE,
                                         first_name = literals$given_name,
                                         family_name = literals$surname,
                                         mbox = literals$email,
                                         institution = expand_qname ( instid ) ) )
    }
  }
  return ( authid )
}

#' Parses an affiliation string
#' @param current_affiliation unparsed affiliation string as found in the XML
#' @return a list of three - institution, city, and country
#' @export
parse_affiliation = function ( current_affiliation ) {
  # break down the affiliation in (potential) institution
  # citt and potential country
  pattern = "^([^,]*),(.*),([^,]*),([^,]*)$"
  parsed_content = regmatches(current_affiliation, regexec( pattern, current_affiliation ) )[[1]]
  potential_institution = trim_label( parsed_content[2], removeLeadingDigits = FALSE )
  potential_address = trim_label( parsed_content[3], removeLeadingDigits = FALSE )
  potential_city = trim_label ( parsed_content[4],  removeLeadingDigits = TRUE )
  potential_country = trim_label( parsed_content[5],  removeLeadingDigits = TRUE )

  return ( list ( institution = potential_institution, city = potential_city, country = potential_country, address = potential_address))
}

# parse_country = function( current_affiliation ) {
#   pattern = "^(.*),([^,]*)([^,]*)$"
#   potential_country_name = regmatches(current_affiliation, regexec( pattern, current_affiliation ) )[[1]][2]
#   # first try to do an exact match against a list of abbreviations
#   mysplit = strsplit( potential_country_name, "\\s+")[[1]]
#   potential_abbrev = mysplit[length(mysplit)]
#   potential_match = which ( grepl( potential_abbrev, obkms$gazeteer$countries$ISO) )
#   if ( length( potential_match ) > 0 ) {
#     return( country = obkms$gazeteer$countries$Country,
#     country_geonameid = obkms$gazeteer$countries$geonameid )
#   }
#   # 1.2 attempt to fuzzy match
#   potential_match = stringdist::amatch(potential_country_name, obkms$gazeteer$countries$Country, maxDist = 11 )
#   if ( ! is.na( potential_match ) ) {
#     country = obkms$gazeteer$countries$Country
#     country_geonameid = obkms$gazeteer$countries$geonameid
#   }
#   else {
#     # if the first match fails, get the very last token and try to use it
#     mysplit = strsplit( potential_country_name, "\\s+")[[1]]
#     potential_abbrev = mysplit[length(mysplit)]
#     # match against ISO abbreviation
#     country_match = which ( grepl( potential_abbrev, obkms$gazeteer$countries$ISO) )
#     if ( length( country_match) > 0 ) # we have a match!
#   }
# }


#' Lookup a URI of an institution given an affiliation string.
#'
#' Args:
#'   @param affiliation string to use to find the id of the organization
#'   @param cluster needed for the computation
#'
#' @return URI of the institution if lookup was successful, NULL otherwise
#' @export
#'
lookup_institution = function ( affiliation, cluster ) {
  # (1) look for an exact match in the affiliation strings
  exact_matches = integer( length = 0 )
  exact_matches = which ( parSapply( cluster, obkms$gazetteer$Institutions$Institutions_Only$label,
  function(pattern, y ) {grepl( pattern, x = y)}, y = affiliation) )
  if ( length( exact_matches ) > 0 ) {
    log_event( paste( "exact match in affiliation", affiliation))
    resulting = obkms$gazetteer$Institutions$Institutions_Only[ exact_matches, ]
    aggregated_result =
       aggregate( resulting, by = list( resulting$institution ) , length )
    return ( resulting[ which( max (aggregated_result$institution) == aggregated_result$institution ), 1] )
  }
  # (2) look for an approxiamte match in the affiliation string:
  # (a) approximate match of the institution name and
  # (b) exact match of the city
  fuzzy_matches = integer( length = 0 )
  inst_matches = which ( parSapply(cluster, obkms$gazetteer$Institutions$Institutions_Cities$label,
                                   function(pattern, y ) {agrepl( pattern, x = y)}, y = affiliation) )
  city_matches = which ( parSapply(cluster, obkms$gazetteer$Institutions$Institutions_Cities$city,
                                   function(pattern, y ) {grepl( pattern, x = y)}, y = affiliation) )
  fuzzy_matches = intersect( inst_matches, city_matches )
  if ( length( fuzzy_matches ) > 0 ) {
    log_event( paste( "fuzzy match in affiliation", affiliation))
    resulting = obkms$gazetteer$Institutions$Institutions_Cities[ fuzzy_matches, ]
    aggregated_result =
      aggregate( resulting, by = list( resulting$institution ) , length )
    return ( resulting[ which( max (aggregated_result$institution) == aggregated_result$institution ), 1] )
  }
  log_event( paste( "no match for affiliation" , affiliation ) )
  return ( NULL )
}
