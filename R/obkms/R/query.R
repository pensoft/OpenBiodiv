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


#' Lookup an Identifier (URI) for a Resource in OBKMS
#'
#' Given a label (and a few optional arguments) this function locates the URI
#' or URI's that match this label (and optional arguments) in OBKMS. If no
#' match is found, a unique ID (UUID) is generated.
#'
#' Args:
#'   @param label label for which to look
#'   @param article_id what article is this label related to
#'     (used as a context in the graph patttern), if no article id is supplied,
#'     will look in the default graph
#'   @param language default is English
#'   @param ignore_case if TRUE lowercases everything
#'   @param generate_on_fail if TRUE if no match is found, a new ID is generated,
#'     if FALSE, NULL is returned
#'   @param trim if TRUE whitespace will be trimmed inside and before and after
#'     the label
#'
#' @return matching ID's or NULL
#'
#' @examples
#'
#' lookup_id( "10.3897/BDJ.1.e1000" )
#'
#' @export
lookup_id = function( label,
                      article_id = "?context",
                      language = NULL,
                      resource_type = obkms$classes$Thing,
                      ignore_case = FALSE,
                      generate_on_fail = TRUE,
                      trim = TRUE,
                      show_query = FALSE)
{
  stopifnot( resource_type$uri %in% sapply( obkms$classes , '[[', i = "uri" ) )

  if ( trim ) { label  = trim_label ( label ) }
  if ( ignore_case ) { label = tolower( label ) }

  query =
    "SELECT ?id WHERE {
        ?id rdf:type %concept_type .
        GRAPH %context {
          ?id rdfs:label %label .
        }
    }"

  query = gsub( "%label", squote( label, language = language ), query  )
  query = gsub( "%concept_type", resource_type$uri, query )
  query = gsub( "%context", article_id, query )
  query = c( turtle_prepend_prefixes(t = "SPARQL"), query )
  query = do.call ( paste0, as.list(query))
  if ( show_query ) cat( query )
  res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )

  # we want the results to be a list (data frame), we hava a match (multiple matches)
  if ( is.data.frame( res ) && nrow ( res ) > 0 )
  {
    id = res$id
    log_event ( "successful lookup", "lookup_id", do.call( paste, as.list( id ) ) )
    return ( id )
  }

  if ( generate_on_fail ) {
    log_event ( "failed lookup, generating new id", "lookup id", "" )
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
  query.template = gsub( "%label", squote( label, language = lang),  query.template )
###
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

#' Most Frequent Id in a Dataframe
#'
#' Args:
#'   @param aMatch a numeric of rows matching in the data frame
#'   @param aFrame the data frame where the matches are sought
#'   @param idField what is the name of the column where the id's are stored
#'
#' @return the URI (id) that matched the most rows or NULL if it is impossible
#' to calculate
#'
#' @export
majority_id = function ( aMatch, aFrame, idField = "id" )
{
  resulting =  aFrame[ aMatch, , drop = FALSE ]
  aggregated_result = aggregate( resulting, by = list( resulting[[ idField ]] ) , length )
  ret_value  = resulting[ which( max (aggregated_result[[idField]]) == aggregated_result[[ idField ]]), 1]
  if ( length( ret_value == 1) ) return ( ret_value )
  else return ( NULL )
}

#' Author Disambiguation
#'
#' This is a rule-based function. The function starts by looking at the most
#' effective rules and working itself to least effective rules.
#'
#' Rule 1: If it is a collaborative author, the function does a direct match
#' of the author string.
#'
#' Rule 2: For persons:
#'    2.a. fuzzy match of last name, and
#'    2.b. match beginning of first name,
#'    2.c. exact match of email.
#'
#' Rule 3: match with institution - replace exact match of mailbox with exact match of institution URI
#'
#' Rule 4: match with affiliation string
#'
#' Args:
#'   @param Literal a list of literals associated with the author
  #' @param Identifier a list of URI's associated with the author
#'
#' @return a URI of an author if it already exists, or mints new one if it
#' doesn't or there are multiple matches and thus an ambiguity.
#'
#' @export
disambig_author = function ( Literal, Identifier )
{
  ## Rule 1 ##
  if ( !is.null( Literal$collab ) )
  {
    non_persons = obkms$authors[ obkms$authors$is_person == FALSE ]
    best_match = pgrep ( cluster, Literal$collab, non_persons )
    if ( length( best_match ) > 0 )
    {
      id = majority_id ( best_match, non_persons )
      if ( !is.null( id ) ) {
        log_event( "Rule 1 match (collaborative author)", "disambig_author", id )
        return ( id )
      }
      else {
        log_event( "Rule 1 fail (collaborative author)", "disambig_author", "multiple matches" )
      }
    }
    else {
      log_event( "Rule 1 fail (collaborative author)", "disambig_author", "no matches" )

    }
  }

  ## Rule 2 ##
  else if ( !is.null ( Literal$email ) ) {
    mbox_match = grep( Literal$email, obkms$authors$mbox )
    first_letter = substring( Literal$given_name, 1, 1 )
    fname_match = grep ( paste0( "^", first_letter ), obkms$authors$first_name )
    lname_match = agrep( Literal$surname, obkms$authors$family_name )
    best_match = intersect ( intersect( fname_match, lname_match), mbox_match )
    if ( length( best_match ) > 0 ) {
      id =  majority_id( best_match, obkms$authors )
      if ( !is.null( id ) ) {
        log_event( "Rule 2 match (email) ", "disambig_author", id )
        return ( id )
      }
      else {
        log_event( "Rule 2 fail (email) ", "disambig_author", "multiple matches" )

      }
    }
    else {
      log_event( "Rule 2 fail (email)", "disambig_author", "no matches" )

    }
  }

  ## Rule 3 ##
  else if ( !is.null( Identifier$institution) ) {
    institution_match =sapply ( unlist( expand_qname( Identifier$institution ) ), grep, x = obkms$authors$institution )
    first_letter = substring( Literal$given_name, 1, 1 )
    fname_match = grep( paste0( "^", first_letter ), obkms$authors$first_name )
    lname_match = agrep( Literal$surname, obkms$authors$family_name )
    best_match = intersect ( intersect( fname_match, lname_match ),  institution_match )

    if ( length( best_match ) > 0 ) {
      id =  majority_id( best_match, obkms$authors )
      if ( !is.null( id ) ) {
        log_event( "Rule 3 match (institution id)", "disambig_author", id )
        return ( id )
      }
      else {
        log_event( "Rule 3 fail (institution id)", "disambig_author", "multiple matches" )
        return ( NULL )
      }
    }
    else {
      log_event( "Rule 3 fail (institution id)", "disambig_author", "no matches" )

    }
  }

  ## Rule 4 (affiliation string) ##

  else if ( !is.null( Literal$affiliation ) ) {
    for ( aff in unlist( Literal$affiliation ) ) {
      # TODO grab also affiliation strings
      aff_matches = agrep( aff, obkms$authors$affiliation )
      first_letter = substring( Literal$given_name, 1, 1 )
      fname_match = grep( paste0( "^", first_letter ), obkms$authors$first_name )
      lname_match = agrep( Literal$surname, obkms$authors$family_name )
      best_match = intersect ( intersect( fname_match, lname_match ),  aff_matches )

      if ( length( best_match ) > 0 ) {
        id =  majority_id( best_match, obkms$authors )
        if ( !is.null( id ) ) {
          log_event( "Rule 4 match (fuzzy affiliation)", "disambig_author", id )
          return ( id )
        }
        else {
          log_event( "Rule 4 fail (fuzzy affiliation) ", "disambig_author", "multiple matches" )

        }
      }
      else {
        log_event( "Rule 4 fail (fuzzy affiliation)", "disambig_author", "no matches" )

      }
     }
  }

  # no match, also updates the local authors database
  log_event( "invoking direct lookup", "disambig_author", paste( Literal$surname, Literal$collab ) )
  if ( !is.null( Literal$collab ) ) {
    authlab = Literal$collab
  }
  else {
    authlab = paste( Literal$given_name, Literal$surname )
  }
  authid = lookup_id( authlab,
                      article_id = Identifier$article )

  null2na = function ( My_List, columns  ) {
    l = lapply( columns , function ( c ) {
      if ( is.null(  My_List[[ c ]] ) ) return( NA )
      else return( c = My_List [[ c ]] )
    })
    names( l ) = columns
    return ( l )
  }

  Literal = null2na ( Literal, columns = c("collab", "surname", "given_name", "email", "affiliation") )
  Identifier = null2na ( Identifier, columns = "institution")

  if ( !is.na( Literal$collab ) )
  {
    update_authors_db( expand.grid( id = authid,
                 author = authlab,
                 is_person = FALSE,
                 first_name = NA,
                 family_name = NA,
                 mbox = as.factor ( unlist( Literal$email ) ),
                 institution =  as.factor( unlist ( Identifier$institution ) ),
                 affilition = as.factor( unlist( Literal$affiliation ) ) ,
                 stringsAsFactors = FALSE ) )
  }
  else {
    update_authors_db ( expand.grid( id = authid,
                 author = authlab,
                 is_person = TRUE,
                 first_name = Literal$given_name,
                 family_name = Literal$surname,
                 mbox = as.factor ( unlist( Literal$email ) ),
                 as.factor( unlist ( Identifier$institution ) ),
                 affilition = as.factor( unlist( Literal$affiliation ) ),
                 stringsAsFactors = FALSE) )
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
lookup_institution = function ( affiliation, cluster ) {
  # (1) look for an exact match in the affiliation strings
  exact_matches = integer( length = 0 )
  exact_matches = which ( parSapply( cluster, obkms$gazetteer$Institutions$Institutions_Only$label,
  function(pattern, y ) {grepl( pattern, x = y)}, y = affiliation) )
  if ( length( exact_matches ) > 0 ) {
    id = majority_id ( exact_matches, obkms$gazetteer$Institutions$Institutions_Only, "institution" )
    if ( !is.null ( id ) ) {
      log_event( "Rule 1 match (exact match)", "lookup_institution", id)
      return ( id )
    }
    else {
      log_event( "Rule 1 fail (exact match)", "lookup_institution", "multiple matches")
    }
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
    id = majority_id( fuzzy_matches, obkms$gazetteer$Institutions$Institutions_Cities, "institution" )
    if ( !is.null ( id ) ) {
      log_event( "Rule 2 match (fuzzy match with city)", "lookup_institution", id)
      return ( id )
    }
    else {
      log_event( "rule 2 fail (fuzzy match with city)", "lookup_institution", "multiple matches")
    }
  }
  log_event( "no match" , "lookup_institution", affiliation  )
  return ( NULL )
}
