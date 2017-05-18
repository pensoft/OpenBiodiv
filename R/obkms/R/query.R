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

lookup_id = function( label, trim = TRUE, ignore_case = TRUE, best_match = TRUE, generate_on_fail = TRUE, ...)
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
        "PREFIX skos: %skosns SELECT ?id WHERE { ?id skos:prefLabel %label . }"
      # query substitution
      query.template = gsub( "%label", paste( '\"', l, '\"', sep = "" ), query.template )
      query = gsub( "%skosns", obkms$prefixes$skos, query.template )
      # query execution
      res = rdf4jr::POST_query( obkms$server_access_options , obkms$server_access_options$repository, query, "CSV" )
      # we want the results to be a list (data frame), we hava a match (multiple matches)
      if ( is.data.frame( res ) && nrow ( res ) > 0 )
      {
        if (best_match) return ( as.character( res$id )[1] )
        else return(  as.character( res$id ) )
      }
    }
  }
  if ( generate_on_fail ) {
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
