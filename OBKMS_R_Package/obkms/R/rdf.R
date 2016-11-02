# _____  _____  ______
# |  __ \|  __ \|  ____|
# | |__) | |  | | |__
# |  _  /| |  | |  __|
# | | \ \| |__| | |
# |_|  \_\_____/|_|
#
#
# RDF Functions
#

#' Returns a prefix string in Turtle
#'
#' @param reqd_prefixes  a list of needed prefixes

prefix_ttl = function( reqd_prefixes, prefix_db = paste0( path.package ("obkms") ,"/prefix_db.yml" ) ) {

  if (prefix_db != paste0( path.package ("obkms") ,"/prefix_db.yml" ) ) {
    warning( paste0( "You are overriding the prefix database path with the value \"", prefix_db , "\"!") )
  }

  all_prefixes = yaml::yaml.load_file( prefix_db )

  ttl = sapply ( reqd_prefixes, function ( p ) {
    paste( "PREFIX", p, all_prefixes[[p]], "\n" )
 #   if ( is.null( all_prefixes[[p]] ) ) {
 #      warning( paste0( "Prefix ", p, "is not found in the database!") )
 #   }
  })

  return ( ttl )
}

#' Try to minimize a URI to a qname using a list of prefixes
#'
#' @param uri        the full URI
#' @param prefixes   the needed prefixes
#' @export

qname = function( uri, prefix_db = paste0( path.package ("obkms") ,"/prefix_db.yml" ) ) {
  # first strip angle brackets if there are
  uri = strip_angle ( uri )
  # the idea is to try each of the prefixes
  all_prefixes = yaml::yaml.load_file( prefix_db )

  r = sapply( all_prefixes , function ( p ) {
    grepl( paste0( "^", p ) , uri )
  } )
  # if found
  if ( sum( r ) > 0) {
    p = all_prefixes[r]
    n = names(all_prefixes)[r]
    uri = gsub( paste0("^", p), paste0( n, ":" ), uri )
    return( list(prefix = n, uri = uri) )
  }
  else
    return ( list( prefix = NULL, uri = uri))
}

#' A function to strip the angle brackets
strip_angle = function ( uri ) {
  if ( grepl("^<.*>$", uri) ) {
    return ( substr(uri, 2, nchar(uri) - 1) )
  }
  else
    return (uri)
}

#' a function to start an rdf couplet

begin_couplet = function( subject, predicate, object ) {
  return( paste( subject, predicate, object ) )
}

end_couplet = function () {
  return ( " ." )
}

add_po = function ( predicate, obj, literal = FALSE) {
  if(literal) {
    return( paste0( " ;\n ", predicate, " \"", obj, "\"") )
  }
  else {
    paste( " ;\n ", predicate,  obj)
  }
}
