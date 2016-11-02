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

get_nodeid = function( obkms_access_options, label ) {

  prefixes = "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"
  query =
    "SELECT ?id
    WHERE {
      ?id skos:prefLabel %label .
    }"
  query = paste(prefixes, gsub("%label", paste('\"', label, '\"', sep = ""), query), sep = "\n")
  res = rdf4jr::POST_query( obkms_access_options, obkms_access_options$repository, query, "CSV" )
  if ( dim ( res )[1] == 0 ) {
    return ( paste( "http://id.pensoft.net/", uuid::UUIDgenerate() , sep = "") )
  }
  else {
    return ( as.character( res[1, 1]))
  }

}
