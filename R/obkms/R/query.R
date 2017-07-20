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
#' TODO: should have a more functional name
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
#'   @param in_scheme if we are looking for a vocab term, put the vocab URI here, default NA
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
                      show_query = FALSE ,
                      in_scheme = NA)
{
  if ( is.na( label ) || length( label ) == 0 || label == "" ) return ( NA )
  stopifnot( resource_type$uri %in% sapply( obkms$classes , '[[', i = "uri" ) )

  if ( trim ) { label  = trim_label ( label ) }
  if ( ignore_case ) { label = tolower( label ) }

  query =
    "SELECT DISTINCT ?id WHERE {
        ?id rdf:type %concept_type .
        GRAPH %context {
          ?id rdfs:label|skos:altLabel|skos:prefLabel %label
          %in_scheme
        }
    }"

  query = gsub( "%label", squote( label, language = language ), query  )
  query = gsub( "%concept_type", resource_type$uri, query )
  query = gsub( "%context", article_id, query )
  if ( !is.na( in_scheme ) ) {
    query = gsub( "%in_scheme", paste0( "\r; skos:inScheme ", in_scheme$uri ) , query)
  }
  else {
    query = gsub( "%in_scheme", "", query )
  }
  query = c( turtle_prepend_prefixes(t = "SPARQL"), query )
  query = do.call ( paste0, as.list(query))
  if ( show_query ) cat( query )

  # TODO: need to vectorize this for multiple labels
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
  else {
    return( NA )
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

#' Looks up the URI of a Resource in DBPedia
#'
#' @param label the label of the resource
#' @param label_property the type of label (i.e. rdfs:label, skos:prefLabel,
#'   skos:altLabel that we are looking for) needs to have a `uri` fields
#'   as in obkms$properties. Default is `rdfs:label`
#' @param resource_type the type of the resource as specified by OBKMS classes,
#'   needs to be a list with a named field called URI. Default is Thing.
#' @param language of the label as per obkms$parameters$Language Needs to have a
#'   `semantic_code` field. Default is English.
#' @param print_query prints out the query to the console for debugging purposes
#'   Default is FALSE.
#'
#' @return one or more matches of the search criteria, NULL if nothing is matched
#'
#' @examples
#'
#' dbpedia_lookup("Abraham Lincoln")
#'
#' BiologicalThing = obkms$classes$DbpediaBiologicalThing
#' dbpedia_lookup("Panthera", resource_type = BiologicalThing )
#'
#' @export
dbpedia_lookup = function ( label,
                            label_property = obkms$properties$label ,
                            resource_type = obkms$classes$Thing,
                            language = obkms$parameters$Language$English,
                            print_query = FALSE )
{
  if ( is.na( label ) || length( label ) == 0 || label == "" ) return ( NA )
  label = trim_label( label )

  query =
    "SELECT ?resource
    WHERE {
      ?resource rdf:type %resource_type .
      ?resource %label_property %label .
    }"

  query = gsub( "%resource_type", resource_type$uri, query )
  query = gsub( "%label_property", label_property$uri, query )
  query = gsub( "%label", squote( label, language = language),  query )

  ### TODO Vectorize over label with lapply
  res = rdf4jr::POST_query( obkms$dbpedia_access_options ,
                            obkms$dbpedia_access_options$repository,
                            query,
                            "CSV" )

  if ( is.data.frame( res ) && nrow ( res ) > 0 ) {
    log_event( "found resrouce", "dbpedia_lookup", do.call( paste, as.list ( res$resource )))
    return(  as.character( res$resource ) )
  }
  else {
    log_event( "not match found for ", "dbpedia_lookup",  label )
    return ( NULL )
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
  if ( length( ret_value ) == 1 ) return ( ret_value )
  else return ( NULL )
}

#' @export
longest_match_length = function ( exact_matches, a_data_frame , column ) {
  resulting =  a_data_frame[ exact_matches, , drop = FALSE ]
  lengths =  nchar ( resulting[[ column ]] )
  ret_value = resulting[ lengths == max(lengths), column ]
  if ( length( ret_value ) == 1 ) return ( ret_value )
  else return ( NULL )
}

#' Generic Lookup Function
#'
#' TODO this has nothing to do with Lucene, the name needs to be generic
#'
#' @param lookup_parameter.lst a list of lookup parameters to be passed to the rules
#' @param rule a character vector of rules to be applied in sequential order until
#'   one succeeds
#'
#' @export
rule_based_lookup = function ( parameter.lst, rule )
{
  uri = NA
  i = 1
  while( is.na( uri ) && i <= length( rule ) ) {
    p_match = do.call( rule[ i ], parameter.lst )
    if ( nrow( p_match ) > 0 ) {
      uri = p_match[ order(p_match$score, decreasing =TRUE)  , ][1, 1]
      log_event( rule [ i ], "rule_based_lookup", "success")
    }
    else {
      log_event( rule [ i ], "rule_based_lookup", "fail" )
    }
    i = i + 1
  }
  return( uri )
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
#' @return URI of the institution if lookup was successful, NA otherwise
#' @export
lookup_institution = function ( affiliation, cluster = obkms$cluster )
{
  uri = NA
  rule = c( "institution_rule2", "institution_rule1" )
  i = 1
  while( is.na( uri ) && i <= length( rule ) ) {
    potential_match = do.call( rule[ i ], as.list( affiliation ))
    if ( nrow( potential_match ) > 0 ) {
      uri = potential_match[ order(potential_match$score, decreasing =TRUE)  , ][1, 1]
      log_event( rule [ i ], "lookup_institution", "success")
    }
    else {
      log_event( rule [ i ], "lookup_institution", "fail" )
    }
    i = i + 1
  }
  return( uri )
}


## Rule 1 ##
disambig_collab_author =  function ( Literal , Identifier ) {
  if ( !is.na( Literal$collab ) )
  {
    non_persons = obkms$authors[ obkms$authors$is_person == FALSE ]
    best_match = pgrep ( obkms$cluster, Literal$collab, non_persons )
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
  return ( NA )
}

## Rule 2 ##
dismabig_author_by_email = function ( Literal, Identifier ) {
  if ( !is.na ( Literal$email ) ) {
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
  return ( NA )
}

## Rule 3 ##
disambig_author_by_institution_id = function ( Literal, Identifier ) {
  for ( inst_id in Identifier$institution ) {
    if ( !is.na( inst_id ) ) {
      institution_match =sapply ( unlist( expand_qname( inst_id ) ), grep, x = obkms$authors$institution )
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
        }
      }
      else {
        log_event( "Rule 3 fail (institution id)", "disambig_author", "no matches" )
      }
    }
  }
  return ( NA )
}

## Rule 4 (affiliation string) ##
disambig_author_by_affiliation_string = function ( Literal, Identifier ) {
  for ( aff in Literal$affiliation) {
    if ( !is.na( aff ) ) {
      for ( aff in unlist( aff ) ) {
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
  }
  return( NA )
}


null2na = function ( My_List, columns  ) {
  l = lapply( columns , function ( c ) {
    if ( is.null(  My_List[[ c ]] ) ) return( NA )
    else return( c = My_List [[ c ]] )
  })
  names( l ) = columns
  return ( l )
}


#' Query the Lucene Index for a Specific Phrase
#'
#' TODO need lucene prefix
#'
#' @param phrase the exact phrase to look for (string)
#' @param field which field to query, default is label
#' @param resource_type the URI of the class to which you want to restrict your queries
#'
#' @return a list of hits and scores
#' @export
lucene_phrase_query = function( phrase,
                                field = "label",
                                resource_type = "<http://www.w3.org/2002/07/owl#Thing>" )
{
  lucene_query =  paste0( field, ":\\\\\"",  phrase , "\\\\\"" )
  lucene_connector = "<http://www.ontotext.com/connectors/lucene/instance#PhraseSearch>"
  query = "SELECT ?entity ?score ?label
WHERE {
  ?search rdf:type %lucene_connector ;
    lucene:query %lucene_query ;
    lucene:entities ?entity .
  ?entity lucene:score ?score ;
    rdfs:label ?label ;
    rdf:type %resource_type .
} ORDER BY DESC (?score)"
  query = gsub("%lucene_connector", lucene_connector, gsub("%lucene_query", paste0 ("\"", lucene_query, "\"" ), query))
  query = gsub("%resource_type", resource_type, query)
  query = do.call( paste, as.list( c( turtle_prepend_prefixes( t = "SPARQL" ), query )))
  result = rdf4jr::POST_query(
    obkms$server_access_options,
    obkms$server_access_options$repository,
    query, "CSV" )
}

#' Rule1 for Institution Disambiguation
#'
#' TODO unexport that for production
#'
#' @param affiliation the affiliation string
#' @return a URI with the match if found, NA if nothing is found
#' @export
institution_rule1 = function( affiliation )
{
  # split affiliation string by ","
  potential_institution = unlist( strsplit(affiliation, ",") )
  potential_matches = lapply( potential_institution, lucene_phrase_query, resource_type = "<http://dbpedia.org/ontology/EducationalInstitution>")
  potential_matches = do.call( rbind, potential_matches )
  return ( potential_matches )

}

#' (2) look for an approxiamte match in the affiliation string:
#' (a) approximate match of the institution name and
#' (b) exact match of the city
#' @param affiliation the affiliation string
#' @return URI or NA
#' @export
institution_rule2 = function( affiliation )
{
  lucene_query = character(2)
  lucene_connector = character(2)
  # housekeeping
  lucene = vector( mode = "list", length = 2 )

  # split affiliation string in words and add ~
  word = unlist ( strsplit(affiliation, "\\W") )
  word = unique( word[ which( word != "" ) ] )
  word = paste0( word, "~")

  lucene1 = lucene_query_creator.fuzzy_label( affiliation )

  lucene_query[1] = lucene1[[1]]
  lucene_connector[1] = lucene1[[2]]

  potential_institution = trim_label( unlist( strsplit(affiliation, "," )))
  potential_institution = paste0("\\\\\"", potential_institution, "\\\\\"")

  lucene_query[2] = do.call( paste , as.list( c( "label:", potential_institution )))
  # TODO make this an OBKMS parameter
  lucene_connector[2] = "<http://www.ontotext.com/connectors/lucene/instance#PhraseSearch>"

  query = "SELECT ?entity ?score ?label
WHERE {
  ?search a %lucene_connector1 ;
    lucene:query %lucene_query1 ;
    lucene:entities ?entity .
  ?entity lucene:score ?score ;
    rdfs:label ?label ;
    a dbo:EducationalInstitution ;
    vcard:hasLocality ?locality .

  ?search2 a %lucene_connector2 ;
    lucene:query %lucene_query2 ;
    lucene:entities ?locality .
} ORDER BY DESC (?score)"

  query = gsub("%lucene_connector1", lucene_connector[1],  query)
  query = gsub("%lucene_query1", paste0( "\"", lucene_query[1], "\""), query)
  query = gsub("%lucene_connector2", lucene_connector[2],  query)
  query = gsub("%lucene_query2", paste0( "\"", lucene_query[2], "\""), query)

  query = do.call( paste, as.list( c( turtle_prepend_prefixes( t = "SPARQL" ), query )))

  potential_match = rdf4jr::POST_query(
    obkms$server_access_options,
    obkms$server_access_options$repository,
    query, "CSV" )

  return( potential_match )
}


#' Person Matches According to Author Rule 1
#'
#' Looks up an author's ID by his or her email.
#'
#' Idea: first letter of first name AND
#'       exact match of email AND
#'       fuzzy match of last name
#'
#' @param collab, surname, given_name, email, reference, affiliation
#'
#' @return a data.frame with person matches of class SearchResult
#'
#' @export
author_rule.1 = function( collab, surname, given_name, email, reference, affiliation, label )
{
  if ( is.na( given_name) || is.na( email ) || is.na( surname ) ) return ( data.frame())
  query = "SELECT ?entity ?score ?label
  WHERE {

  ?search a <http://www.ontotext.com/connectors/lucene/instance#PhraseSearch> ;
    lucene:query %lucene_query1 ;
    lucene:entities ?entity1 .

  ?search2 a <http://www.ontotext.com/connectors/lucene/instance#WordSearch>;
    lucene:query %lucene_query2 ;
    lucene:entities ?entity2 .

 FILTER ( ?entity1 = ?entity2 )
  BIND ( ?entity1 as ?entity )

  ?entity lucene:score ?score ;
    rdfs:label ?label ;
    foaf:mbox ?email .


  } ORDER BY DESC (?score)"

  lucene_query = character(2)
  lucene_query[1] = lucene_author_query( first_name = given_name,
                                                         email  = email)
  lucene_query[2] = lucene_author_query( last_name = surname )


  query = gsub("%lucene_query1", paste0( "\"", lucene_query[1], "\""), query)
  query = gsub("%lucene_query2", paste0( "\"", lucene_query[2], "\""), query)
  query = do.call( paste, as.list( c( turtle_prepend_prefixes( t = "SPARQL" ), query )))

  result = rdf4jr::POST_query(
    obkms$server_access_options,
    obkms$server_access_options$repository,
    query, "CSV" )

  class(result) = c( class( result ), "SearchResult" )

  return( result )
}

#' Person Matches According to Author Rule 2
#'
#' Match against existing affiliations.
#' Note: one author may have multiple affiliations.
#'
#' Idea: first letter of first name AND
#'       fuzzy-and-match of last name AND
#'       fuzzy-and-match of affiliation AND
#'
#' @param collab, surname, given_name, email, reference, affiliation
#'
#' @return a data.frame with person matches of class SearchResult
#'
#' @export
author_rule.2 = function( collab, surname, given_name, email, reference, affiliation, label )
{
  r = lapply( affiliation, function ( a ) {
    if ( is.na( given_name) || is.na( surname ) || is.na( a ) ) return ( data.frame())
    query = "SELECT ?entity ?score ?label
  WHERE {
  ?search a <http://www.ontotext.com/connectors/lucene/instance#PhraseSearch> ;
    lucene:query %lucene_query1 ;
    lucene:entities ?entity1 .

  ?search2 a <http://www.ontotext.com/connectors/lucene/instance#WordSearch> ;
    lucene:query %lucene_query2 ;
    lucene:entities ?entity2 .

  ?search3 a <http://www.ontotext.com/connectors/lucene/instance#WordSearch> ;
    lucene:query %lucene_query3 ;
    lucene:entities ?entity3 .

  FILTER ( ?entity1 = ?entity2 && ?entity2 = ?entity3 )
  BIND ( ?entity1 as ?entity )

?entity   lucene:score ?score ;
    rdfs:label ?label .

  } ORDER BY DESC (?score)"

    lucene_query = character(3)
    lucene_query[1] = lucene_author_query( first_name = given_name )
    lucene_query[2] = lucene_author_query( last_name = surname )
    lucene_query[3] = lucene_author_query( affiliation = a )

    query = gsub("%lucene_query1", paste0( "\"", lucene_query[1], "\""), query)
    query = gsub("%lucene_query2", paste0( "\"", lucene_query[2], "\""), query)
    query = gsub("%lucene_query3", paste0( "\"", lucene_query[3], "\""), query)
    query = do.call( paste, as.list( c( turtle_prepend_prefixes( t = "SPARQL" ), query )))

    result = rdf4jr::POST_query(
      obkms$server_access_options,
      obkms$server_access_options$repository,
      query, "CSV" )

    class(result) = c( class( result ), "SearchResult" )

    return( result )
  })
  return ( do.call( rbind, r) )
}

#' Person Matches According to Author Rule 3
#'
#' For collaborative authors, match the label
#'
#' @param collab
#' @param surname
#' @param given_name
#' @param email
#' @param reference
#' @param affiliation
#'
#' @return a data.frame with person matches of class SearchResult
#'
#' @export
author_rule.3 = function( collab, surname, given_name, email, reference, affiliation, label )
{
  if ( is.na( collab ) ) return (data.frame () )
  query = "SELECT ?entity ?score ?label
  WHERE {
  ?search a <http://www.ontotext.com/connectors/lucene/instance#PhraseSearch> ;
    lucene:query %lucene_query1 ;
    lucene:entities ?entity .

  ?entity a foaf:Agent .

  } ORDER BY DESC (?score)"

  lucene_query = c( lucene_label_query( collab ) )

  query = gsub("%lucene_query1", paste0( "\"", lucene_query[1], "\""), query)
  query = do.call( paste, as.list( c( turtle_prepend_prefixes( t = "SPARQL" ), query )))

  result = rdf4jr::POST_query(
    obkms$server_access_options,
    obkms$server_access_options$repository,
    query, "CSV" )

  class(result) = c( class( result ), "SearchResult" )

  return( result )
}


#' Lucene Query Creator: Fuzzy Label Query
#'
#' Takes a string, a creates a fuzzy label query out of it.
#'
#' @param label the label to be parsed
#' @return the query string and the needed connector (a vector of two)
#'
#' @export
lucene_query_creator.fuzzy_label = function ( label )
{
  # first, convert the label several phrases
  phrase = trim_label( unlist( strsplit( label, ",") ) )

  # then, process each phrase as an Fuzzy-AND-Phrase
  phrase = phrase2FuzzyAnd( phrase )

  # the glue the phrases together, after each but the last phrase you want an OR
  phrase = c( paste(phrase[1: length(phrase ) - 1], "OR"), phrase[ length( phrase ) ] )
  lucene_query = do.call( paste, as.list( c( "label:", phrase )))
  lucene_connector = "<http://www.ontotext.com/connectors/lucene/instance#WordSearch>"
  return ( list( lucene_query, lucene_connector ))
}


#' Convert a Literal Phrase to a Fuzzy-AND-Phrase
#'
#' Puts qunituple quotes around the phrase, removes special
#' characters, adds tilde after the words and AND between
#' the words of a phrase
#'
#' @param phrase
#' @return improved phrase
#' @export
phrase2FuzzyAnd = function( phrase )
{
  word = sapply (phrase, function( p ) {
    p = tm::removeWords(p, tm::stopwords( "SMART" ) )
    # split affiliation string in words and add ~
    word = unlist ( strsplit(p, "\\W") )
    word = unique( word[ which( word != "" ) ] )
    word = paste0( word, "~")
    word = c( paste(word[1: length(word ) - 1], "AND"), word[ length( word ) ] )
    do.call( paste, as.list( c( "(\\\\\"", word , "\\\\\")")))
  })
}


#' Lucene Query String to Search For Authors
#'
#' Depending of what arguments are supplied, different queries are returned
#' (generic behavior)
#'
#' @param first_name the first name
#' @param last_name the last name
#' @param email author's email
#'
#' @return the lucene query string
#'
#' @export
lucene_author_query = function( first_name, last_name, email, affiliation )
{
  # "first_name:L* AND email:penev@pensoft.net"
  if ( !missing( first_name ) && !missing( email ) && missing( last_name ) ) {
    first_letter = substring( first_name, 1, 1 )
    query = paste0("first_name:", first_letter, "* AND email:", email )
    return ( query )
  }
  else if (!missing( first_name ) && missing( email ) && missing( last_name ) && missing( affiliation)  ) {
    first_letter = substring( first_name, 1, 1 )
    query = paste0("first_name:", first_letter, "*" )
    return ( query )
  }
  # "last_name:Penev~"
  else if ( missing( first_name ) && missing( email ) && !missing( last_name ) ) {
    return ( lucene_fuzzy_and_query( "last_name", last_name , remove_stop = FALSE) )
  }
  # "affiliation_string:School~ AND Biological~ AND Sciences~ AND Tamaki~
  # AND Campus~ AND University~ AND Auckland~ AND New~ AND Zealand~"
  else if ( missing( first_name ) && missing ( last_name ) && missing ( email )
            && !missing ( affiliation ) ) {
    return ( lucene_fuzzy_and_query( "affiliation", affiliation ) )
  }
}

#' Lucene Fuzzy AND Query
#'
#' @param field_name the field name to query against
#' @param label label to converted into a fuzzy and clause
#'
#' @return lucene query string
#'
#' @examples
#'
#' lucene_fuzzy_and_query( "last_name", "van Basten")
#'
#' @export
lucene_fuzzy_and_query = function ( field_name, label, remove_stop = TRUE) {
  stopwords = c( "the", tm::stopwords())
  word = sapply (label, function( p ) {
    p = tolower( p )
    if ( remove_stop ) p = tm::removeWords(p, stopwords )
    # split affiliation string in words and add ~
    word = unlist ( strsplit(p, "\\W") )
    word = unique( word[ which( word != "" ) ] )
  })
  word = paste0( word, "~" )
  if ( length( word ) > 1 ) {
    word[ 1: (length( word ) - 1)] = paste0( word[ 1: (length( word ) - 1)] , " AND")
  }
  paste0(  field_name, ": ", do.call(paste, as.list( word ) ) )
}

#' Lucene Label Query
#'
#' @param label the label text that needs to be investigated
#'
#' @return the Lucene query string
#'
#' @examples
#'
#' lucene_label_query("Pensoft Publishers")
#'
#' @export
lucene_label_query = function ( label ) {
  paste0( "label: \\\\\"", label, "\\\\\"")
}

#' Lucene Query Creator: Fuzzy Label Query
#'
#' Takes a string, a creates a fuzzy label query out of it.
#'
#' @param label the label to be parsed
#' @return the query string and the needed connector (a vector of two)
#'
#' @export
lucene_query_creator.fuzzy_field = function ( field_name,  label )
{
  label = sapply (phrase, function( p ) {
    p = tm::removeWords(p, tm::stopwords( "SMART" ) )
    # split affiliation string in words and add ~
    word = unlist ( strsplit(p, "\\W") )
    word = unique( word[ which( word != "" ) ] )
    word = paste0( word, "~")
    word = c( paste(word[1: length(word ) - 1], "AND"), word[ length( word ) ] )
    do.call( paste, as.list( c( "(\\\\\"", word , "\\\\\")")))
  })

  # the glue the phrases together, after each but the last phrase you want an OR
  phrase = c( paste(phrase[1: length(phrase ) - 1], "AND"), phrase[ length( phrase ) ] )
  lucene_query = do.call( paste, as.list( c( "label:", phrase )))
  lucene_connector = "<http://www.ontotext.com/connectors/lucene/instance#WordSearch>"
  return ( list ( query = lucene_query, connector = lucene_connector ))
}



