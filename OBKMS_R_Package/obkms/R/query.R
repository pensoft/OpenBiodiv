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

#' Given a label, tries to get the GUID of the node that has that label
#'
#' We need a helper function to get or create an node (id) for the network given a preferred label (`skos:prefLabel`)
#'

#' @param options           a list returned by \code{create_server_options}.
#' @param repo_id           a
#'
#' @examples
#' \dontrun{}
#' @export

get_nodeid = function( label = "" ) {

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
        return ( as.character( res$id ) )
      }
  }
  # we couldn't match label or label was FALSE, generate a new node
  #detach ( obkms )
  return ( paste( "http://id.pensoft.net/", uuid::UUIDgenerate() , sep = "") )
}

#' Submits a set of triples (quads) in matrix form to OBKMS

put_triples = function ( triples ) {

}
