
#' Minimizes a URI to a Qname.
#'
#' E.g. qname("http://openbiodiv.net/leis-papuensis") minimizes to
#' ":leis-papuensis". The special case here is the `_base` prefixes, as
#' it minimizes to nothing.
#'
#' if the prefix is _base, it is shortened to :
#'
#' @param uri        the full URI to minimize
#' @export
qname = function( uri )
{
  if ( missing (uri) || is.null( uri ) ) return ( NA )

  unlist ( sapply( uri, function( uri)  {

    if ( is.na( uri ) ) return( NA )

    if ( grepl( "^#" , uri )  ) {
      log_event( "URI will be forced to null", "qname", uri )
      return ( NULL ) # clean-up dbpedia shit
    }
    if ( grepl( ",", uri )) {
      # if the thing has a comma, it cannot be shortened, as it will
      # break turtle, so just put angle brackets
      return ( strip_angle( uri, reverse = TRUE ) )
    }
    if ( missing (uri) || is.null( uri ) || uri == "" ) return (NULL)
    stopifnot( exists( 'obkms', mode = 'environment' ))
    # strip brackets from the uri and from the OBKMS databases of prefixes
    uri = strip_angle ( uri )
    stripped_prefixes = sapply ( obkms$prefixes, strip_angle )

    # try each of the prefixes, r is logical vector of where the beginning of the
    # uri matches any of the prefix
    r = sapply( stripped_prefixes , function ( p ) {
      grepl( paste0( "^",  p  ) , uri )
    } )
    # if found, replace the beginning of the uri with the prefix
    if ( sum( r ) > 0) {
      p = stripped_prefixes[r]

      n = names(stripped_prefixes)[r]
      if ( names(p) == "_base")  # special case of the "_base"
      {
        uri = gsub( paste0("^", p), ":" , uri )
      }
      else {
        uri = gsub( paste0("^", p), paste0( n, ":" ), uri )
      }
    }
    return (uri)
  }) )

}

#' @export
expand_qname = function ( shortname ) {
  stripped_prefixes = sapply ( obkms$prefixes, strip_angle )
  r = sapply( names( stripped_prefixes ) , function ( p ) {
    grepl( p , shortname )
  } )

  gsub( "^.*:", paste0( stripped_prefixes[r] ), shortname)
}


#' Strips Angular Brackets from a URI if Present
#'
#' @param uri the URI to strip angular brackets from
#' @param reverse FALSE, if true will put angular brakcets instead
#'
#' @return URI with stripped angular brackets around it
#' TODO this function should not be exported
#' @export
strip_angle = function ( uri , reverse = FALSE ) {
  if ( grepl("^<.*>$", uri) ) {
    uri = ( substr(uri, 2, nchar(uri) - 1) )
  }
  if ( !reverse ) return (uri)
  else return( gsub( "^(.*)$", "<\\1>", uri ) )
}

#' Properly Quote Literals for use in RDF Serializations
#'
#' Information:
#'   http://iswc2011.semanticweb.org/fileadmin/iswc/Papers/Workshops/SSWS/Emmons-et-all-SSWS2011.pdf
#'
#' @param literal the string that needs to be quoted
#' @param language the language (needs to be a list having the element `semantic_code`)
#'   If left missing, no language will be assumed.
#' @param literal_type for non-strings such as year, date, etc. (one of the names in
#'     obkms$parameters$literal_type). The default is empty, i.e. string.
#'
#' @examples
#'
#' English = obkms$parameters$Language$English
#' squote("Pensoft Publishers", language = English )
#'
#' Year = obkms$paramters$literal_type$Year
#' squote("2017", Year)
#'
#' @export
squote = function ( literal, language, literal_type = "" )
{
  if ( !missing( language ) && !is.null( language)  && literal_type != "" ) {
    stop("Language is set and literal_type is not empty.")
  }
  if ( !missing ( literal_type ) ) {
    stopifnot ( literal_type %in%  unlist( obkms$parameters$literal_type ) )
  }
  if ( !missing(language) && !is.null( language )) {
    stopifnot ( language$label %in% sapply( obkms$parameters$Language , '[[', i = "label" ) )
  }
  if ( is.null ( literal ) || is.na(literal) || literal == "") return ( NULL )

  literal = gsub("\"", "", literal  )
  literal = gsub("\\\\", "", literal  )

  if ( !missing( language ) && !is.null( language) ) { postfix = paste0("@", language$semantic_code ) }
  else { postfix = literal_type }

  paste0 ("\"", literal, "\"", postfix)
}

#' Use the prefix database to create Turtle statements
#' @param t the syntax
#' @export
turtle_prepend_prefixes = function ( t = c("Turtle") ) {
  stopifnot( exists( 'obkms', mode = 'environment' ) )

  if ( t == "Turtle" )
  sapply ( obkms$prefixes, function( p ) {
    name = names(obkms$prefixes)[obkms$prefixes == p]
    name =  sub ( "_base", "" , name )
    paste0("@prefix " , name, ": ", p, " .\n")
  } )
  else if (t == "SPARQL") {
    #type is SPARQL
    sapply ( obkms$prefixes, function( p ) {
      name = names(obkms$prefixes)[obkms$prefixes == p]
      name =  sub ( "_base", "" , name )
      paste0("PREFIX " , name, ": ", p, " \n")
    } )
  }
}

#' Converts a matrix of triple to Turtle statements, given a context.
#'
#' Uses the Trig syntax.
#'
#' @export
triples2turtle = function ( context, triples ) {
  turtle = c( paste( context, "{\n" ) )
  # for each unique subject
  next_object = FALSE
  for ( s in unique( triples$subject ) ) {
    couplet = write_couplet ( s, triples )
    if (next_object == FALSE) {
      turtle = c( turtle, couplet )
      next_object = TRUE
    }
    else{
      turtle = c( turtle, ". \n", couplet)
    }

  }
  turtle = c( turtle, ". }")
  return (turtle)
}

#' works with lists of triples instead of data frames
#' TODO "list of triples" should probably be made into a S3 object
#' @export
triples2turtle2 = function ( context, triples ) {
  turtle = c( paste( context, "{\n" ) )
  # for each unique subject
  next_object = FALSE
  subjects = sapply( triples, function (t) {
    t[[1]]
  })
  subjects = subjects[!sapply(subjects,is.null)]
  for ( s in unique( subjects ) ) {
    couplet = write_couplet2 ( s, triples )
    if (next_object == FALSE) {
      turtle = c( turtle, couplet )
      next_object = TRUE
    }
    else{
      turtle = c( turtle, ". \n", couplet)
    }

  }
  turtle = c( turtle, ". }")
  return (turtle)
}

#' Writes a single couplet for the given subejct
write_couplet = function( subject, triples ) {
  turtle = c( subject, " " )
  # subset the triples with only this subject
  triples = triples[triples$subject == subject, ]
  # find the unique predicates
  next_object = FALSE
  for (p in unique( triples$predicate ) ) {
    predicate_stanza = write_predicate_stanza ( p, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, predicate_stanza )
      next_object = TRUE
    }
    else{
      turtle = c(turtle, ";\n\t", predicate_stanza )
    }

  }
  return ( turtle )
}

#' Writes a single couplet for the given subejct
#' with triples in a list
write_couplet2 = function( subject, triples ) {
  turtle = c( subject, " " )
  # subset the triples with only this subject

  triples = lapply( triples, function (t) {

    if ( !is.null(t) && t[[1]] == subject )
      return (t)

  })
  triples = triples[!sapply(triples,is.null)]
  # find the unique predicates
  predicates = sapply( triples, function (t) {
    t[[2]]
  })
  next_object = FALSE
  for (p in unique( predicates ) ) {
    predicate_stanza = write_predicate_stanza2 ( p, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, predicate_stanza )
      next_object = TRUE
    }
    else{
      turtle = c(turtle, ";\n\t", predicate_stanza )
    }

  }
  return ( turtle )
}

#' Writes the predicate-object stanza after a subject has been written

write_predicate_stanza = function( predicate, triples ){
  turtle = c(predicate, " ")
  # subset only for this predicate
  triples = triples[triples$predicate == predicate, ]
  next_object = FALSE
  # TODO We don't really care about non-uniqueness of objects!!!
  for ( o in unique (triples$object) ) {
    end_stanza = write_end_stanza( o, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, end_stanza)
      next_object = TRUE
    }
    else {
      turtle = c(turtle, ",", end_stanza)
    }
  }
  return ( turtle )
}

#' takes care of the predicates, but with the triple structure a list
write_predicate_stanza2 = function( predicate, triples ){
  turtle = c(predicate, " ")
  # subset only for this predicate
  triples = lapply( triples, function (t) {
    if (t[[2]] == predicate) return (t)
  })
  triples = triples[!sapply(triples,is.null)]
  # We fucking do care about uniqueness of objects!!!!!!!
  objects = lapply( triples, function (t) {
    t[[3]]
  })
  next_object = FALSE
  for ( o in unique(objects) ) {
    end_stanza = write_end_stanza2( o, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, end_stanza)
      next_object = TRUE
    }
    else {
      turtle = c(turtle, ",", end_stanza)
    }
  }
  return ( turtle )
}

write_end_stanza = function ( object, triples ) {
  turtle = c(object)
  return (turtle)
}

#' does it with lists
write_end_stanza2 = function ( object, triples ) {
  if (is.character( object )) {
    turtle = c(object)
    return (turtle)
  }
  else {
    # object is a triples list
    turtle = c( " [ ", write_couplet2( "", object ), " ] " )
  }
}


#' Probably junk
#'
#' #' a function to start an rdf couplet

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

#' Return prefixes serialized as Turtle
#'
#'#' If `reqd_prefixes` is left missing, all prefixes will be returned.
#' The individual prefixes may or may not end with ":". If they don't,
#' it will be added during function execution.
#'
#' @param reqd_prefixes a character vector of needed prefixes, can be missing
#' @param prefix_db path to YAML prefix database, has a default
#' @export
prefix_ttl = function( reqd_prefixes,
  prefix_db = paste0( path.package ("obkms") ,"/prefix_db.yml" ))
{
 prefix_serializer( reqd_prefixes, prefix_db, "Turtle")
}


#' Serializes the prefix database in a language
#'
#' #' If `reqd_prefixes` is left missing, all prefixes will be returned.
#' The individual prefixes may or may not end with ":". If they don't,
#' it will be added during function execution.
#'
#' @param reqd_prefixes a character vector of needed prefixes, can be missing
#' @param prefix_db path to a YAML prefix database, has a default from the pkg
#' @param prefix_lang whether you want SPARQL or Turtle, the default is SPARQL
#' @export
prefix_serializer = function ( reqd_prefixes,
             prefix_db = paste0( path.package ("obkms") ,"/prefix_db.yml" ),
             prefix_lang = "Turtle")
{
  # if the prefix language is missing, default to SPARQL
  if ( missing( prefix_lang ) || !( prefix_lang %in% c( "Turtle", "SPARQL" ) ) )
  {
    warning("Unknown or unsupported prefix language, defaulting to SPARQL...")
    prefix_lang = "SPARQL"
  }
  # sub-function to format a single prefix line as SPARQL
  prefix_sparql_line = function( prefix, uri ) {
    if ( ! prefix == "_base" ) {
      paste0( "PREFIX ", prefix, ": ", uri, " \n" )
    }
    # base prefix case:
    else {
      paste0( "PREFIX ", ": ", uri, " \n" )
    }
  }
  # sub-function to format a sing prefix line as Turtle
  prefix_turtle_line = function( prefix, uri ) {
    if ( ! prefix == "_base" ) {
      paste0( "@prefix ", prefix, ": ", uri, " .\n" )
    }
    # base prefix case:
    else {
      paste0( "@prefix ", ": ", uri, " .\n" )
    }
  }
  # db load
  if (prefix_db != paste0( path.package ("obkms") ,"/prefix_db.yml" ) ) {
    warning( paste0( "You are overriding the prefix database path with the value \"", prefix_db , "\"!") )
  }
  all_prefixes = yaml::yaml.load_file( prefix_db )
  # process
  serialization = character()
  if ( missing( reqd_prefixes ) )
    {
    serialization = sapply ( names(all_prefixes), function ( p ) {
      if ( prefix_lang == "SPARQL" ) {
        paste0( serialization, prefix_sparql_line( p, all_prefixes[[p]] ) )
      }
      else {
        paste0( serialization, prefix_turtle_line( p, all_prefixes[[p]] ) )
      }
    })
  }
  else {
    # we want to strip the colon if we have one, as it will be added later
    reqd_prefixes = sapply ( reqd_prefixes, function (p) {
        sub( ":$", "", p )
    })
    serialization = sapply ( reqd_prefixes, function ( p ) {
      if ( is.null( all_prefixes[[p]] ) ) {
        return("")
      }
      else {
        if ( prefix_lang == "SPARQL" ) {
          paste0(serialization, prefix_sparql_line( p, all_prefixes[[p]] ) )
        }
        else {
          paste0( serialization, prefix_turtle_line( p, all_prefixes[[p]] ) )
        }
      }
    })
  }

  return ( serialization )
  }






#' Converts a matrix of triple to Turtle statements, given a context.
#'
#' Uses the Trig syntax.
#'
#' @export

triples2turtle = function ( context, triples ) {
  turtle = c( paste( context, "{\n" ) )
  # for each unique subject
  next_object = FALSE
  for ( s in unique( triples$subject ) ) {
    couplet = write_couplet ( s, triples )
    if (next_object == FALSE) {
      turtle = c( turtle, couplet )
      next_object = TRUE
    }
    else{
      turtle = c( turtle, ". \n", couplet)
    }

  }
  turtle = c( turtle, ". }")
  return (turtle)
}

#' works with lists of triples instead of data frames
#' TODO "list of triples" should probably be made into a S3 object
#' @export
triples2turtle2 = function ( context, triples ) {
  turtle = c( paste( context, "{\n" ) )
  # for each unique subject
  next_object = FALSE
  subjects = sapply( triples, function (t) {
    t[[1]]
  })
  subjects = subjects[!sapply(subjects,is.null)]
  for ( s in unique( subjects ) ) {
    couplet = write_couplet2 ( s, triples )
    if (next_object == FALSE) {
      turtle = c( turtle, couplet )
      next_object = TRUE
    }
    else{
      turtle = c( turtle, ". \n", couplet)
    }

  }
  turtle = c( turtle, ". }")
  return (turtle)
}

#' Writes a single couplet for the given subejct
write_couplet = function( subject, triples ) {
  turtle = c( subject, " " )
  # subset the triples with only this subject
  triples = triples[triples$subject == subject, ]
  # find the unique predicates
  next_object = FALSE
  for (p in unique( triples$predicate ) ) {
    predicate_stanza = write_predicate_stanza ( p, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, predicate_stanza )
      next_object = TRUE
    }
    else{
      turtle = c(turtle, ";\n\t", predicate_stanza )
    }

  }
  return ( turtle )
}

#' Writes a single couplet for the given subejct
#' with triples in a list
write_couplet2 = function( subject, triples ) {
  turtle = c( subject, " " )
  # subset the triples with only this subject

  triples = lapply( triples, function (t) {

    if ( !is.null(t) && t[[1]] == subject )
      return (t)

  })
  triples = triples[!sapply(triples,is.null)]
  # find the unique predicates
  predicates = sapply( triples, function (t) {
    t[[2]]
  })
  next_object = FALSE
  for (p in unique( predicates ) ) {
    predicate_stanza = write_predicate_stanza2 ( p, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, predicate_stanza )
      next_object = TRUE
    }
    else{
      turtle = c(turtle, ";\n\t", predicate_stanza )
    }

  }
  return ( turtle )
}

#' Writes the predicate-object stanza after a subject has been written

write_predicate_stanza = function( predicate, triples ){
  turtle = c(predicate, " ")
  # subset only for this predicate
  triples = triples[triples$predicate == predicate, ]
  next_object = FALSE
  # TODO We don't really care about non-uniqueness of objects!!!
  for ( o in unique (triples$object) ) {
    end_stanza = write_end_stanza( o, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, end_stanza)
      next_object = TRUE
    }
    else {
      turtle = c(turtle, ",", end_stanza)
    }
  }
  return ( turtle )
}

#' takes care of the predicates, but with the triple structure a list
write_predicate_stanza2 = function( predicate, triples ){
  turtle = c(predicate, " ")
  # subset only for this predicate
  triples = lapply( triples, function (t) {
    if (t[[2]] == predicate) return (t)
  })
  triples = triples[!sapply(triples,is.null)]
  # We fucking do care about uniqueness of objects!!!!!!!
  objects = lapply( triples, function (t) {
    t[[3]]
  })
  next_object = FALSE
  for ( o in unique(objects) ) {
    end_stanza = write_end_stanza2( o, triples )
    if (next_object == FALSE) {
      turtle = c(turtle, end_stanza)
      next_object = TRUE
    }
    else {
      turtle = c(turtle, ",", end_stanza)
    }
  }
  return ( turtle )
}

write_end_stanza = function ( object, triples ) {
  turtle = c(object)
  return (turtle)
}

#' does it with lists
write_end_stanza2 = function ( object, triples ) {
  if (is.character( object )) {
    turtle = c(object)
    return (turtle)
  }
  else {
    # object is a triples list
    turtle = c( " [ ", write_couplet2( "", object ), " ] " )
  }
}


#' Probably junk
#'
#' #' a function to start an rdf couplet

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

