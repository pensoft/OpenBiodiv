#' Dumps all of the BDJ up to the present date in a predefined directory
#' @export
bdj_dumper = function ( journal = "BDJ", fromdate ) {
  if ( missing( fromdate ) ) fromdate = c( "01/01/2010" )
  archive = paste0( obkms$initial_dump_configuration$initial_dump_directory, "archive.zip")
  rdata = paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata")
  if ( journal == "BDJ" ) {
    command = paste0( obkms$initial_dump_configuration$bdj_endpoint, "&date=", URLencode( fromdate ) )
    response = httr::GET( command )
  }
  else if ( journal == "ZooKeys" ) {
    command = paste0( obkms$initial_dump_configuration$zookeys_endpoint, "&date=", URLencode( fromdate ) )
    response = httr::GET( command )
  }

  zip = httr::content(response, "raw")
  writeBin( zip, archive)
  unzip(archive, exdir = obkms$initial_dump_configuration$initial_dump_directory )
  dump_list = unzip(archive, exdir = obkms$initial_dump_configuration$initial_dump_directory, list = TRUE )$Name
  dump_list = paste( obkms$initial_dump_configuration$initial_dump_directory, dump_list, sep = "/")
  dump_date = as.character( format( Sys.Date(), "%d/%m/%Y" ) )
  save( dump_date, dump_list, file = rdata )
  log_event ( "found new files", "bdj_dumper", paste( "found", length( dump_list ), "new files" ) )
  file.remove ( archive )
  return( dump_list )
  # TODO but this doesnot work save( Sys.Date(), file = date_file )
}



#' Initialize package parameters upon loading.
#'
#' The package contains a database of semantic web prefixes, stored in a yaml
#' database in the `inst/` folder. The name of the database file is assigned to
#' the package environment when the package is loaded.
# DOESN'T WORK NOW EVEN THOUGH IT WORKED BEFORE!!!
#.onLoad = function (libname, pkgname) {
#  print ("on load")
#  assign("PREFIX.DB", "prefix_db.yml", envir = parent.env( environment() ) )
#  assign("ENTITY.DB", "semantic_entities_db.yml", envir = parent.env( environment() ) )
#}

#' Initialize OpenBiodiv Environment
#'
#' TODO: the parameter vocabulary can probably be made as instances of something in RDF
#'
#' TODO: literals and non_literals (including keywords) probably need not be here
#'
#' @param server_access_options list with graphdb access configuration as needed by the 'rdf4j' package, can be loaded from yaml
#' @param dbpedia_access_options access options for dbpedia, has default
#' @param prefix_db prefix database, has default
#' @param properties_db database of properties, has default
#' @param classes_db database for classes, has default
#' @param parameters_db databse of different parameters, has default
#' @param literals_db_xpath XPATHS for top-level literals
#' @param non_literals_db_xpath xpaths for top-level document components
#' @param initial_dump_configuration
#' @param keywords_db_xpath the xpaths for the keywords document entity
#' @param xml_source defaults to "file"
#' @param xml_type defaults to "taxpub"
#' @param iteration defaults to NA
#'
#' @export
init_env = function ( server_access_options,
                      dbpedia_access_options = paste0( path.package ( 'obkms' ) , "/", "dbpedia_access_options.yml" ) ,
                      prefix_db = paste0( path.package ( 'obkms' ) , "/", "prefix_db.yml" ),
                      properties_db =  paste0( path.package ( 'obkms' ) , "/", "properties_db.yml" ),
                      classes_db =  paste0( path.package ( 'obkms' ) , "/", "classes_db.yml" ),
                      parameters_db =  paste0( path.package ( 'obkms' ) , "/", "parameters_db.yml" ),
                      literals_db_xpath = paste0( path.package ( 'obkms' ) , "/", "literals_db_xpath.yml" ),
                      non_literals_db_xpath = paste0( path.package ( 'obkms' ) , "/", "non_literals_db_xpath.yml" ),
                      initial_dump_configuration = paste0( path.package ( 'obkms' ) , "/", "initial_dump_configuration.yml") ,
                      authors_db_xpath = paste0( path.package ( 'obkms' ) , "/", "authors_db_xpath.yml" ),
                      keywords_db_xpath = paste0( path.package ( 'obkms' ) , "/", "keywords_db_xpath.yml" ) ,
                      xml_source = "file",
                      xml_type = "taxpub" ,
                      iteration = NA)
{
  # TODO probably don't need vocabulary
  if (! is.character( server_access_options$userpwd )  ) {
    server_access_options$userpwd = Sys.getenv( c("OBKMS_SECRTET") )
    warning ( "Trying to read password from system variable...")
  }

  if (!exists('obkms')) {
    obkms <<- new.env()
  }
  obkms$server_access_options = server_access_options
  obkms$dbpedia_access_options = yaml::yaml.load_file ( dbpedia_access_options )
  obkms$initial_dump_configuration = yaml::yaml.load_file ( initial_dump_configuration )

  obkms$prefixes = yaml::yaml.load_file(prefix_db)
  obkms$properties = yaml::yaml.load_file ( properties_db )
  obkms$classes = yaml::yaml.load_file ( classes_db )

  obkms$parameters = yaml::yaml.load_file ( parameters_db )

  obkms$config = list()
  obkms$config['literals_db_xpath'] = literals_db_xpath
  obkms$config['non_literals_db_xpath'] = non_literals_db_xpath
  obkms$config['prefix_db'] = prefix_db
  obkms$config['properties_db'] = properties_db
  obkms$config['classes_db'] = classes_db
  obkms$config['authors_db_xpath'] = authors_db_xpath
  obkms$config['keywords_db_xpath'] = keywords_db_xpath

  obkms$xml_source = xml_source
  obkms$xml_type = xml_type


  # options to be used with the xml2::read_xml funciton
  obkms$xml_options = c()

  if ( is.na( iteration ) ) {
    obkms$log$number_of_events = 0
    obkms$log$events = list()
    obkms$log$current_context = "initialized"
  }
  else {
    obkms$log$number_of_events = 1
    logframe = read.table(paste0( obkms$initial_dump_configuration$initial_dump_directory,
                               iteration,
                               ".log" ) )
    obkms$log$events = list( data.frame( Time = paste(logframe$V2, logframe$V3),
                                         Type = logframe$V4,
                                         Context = logframe$V5,
                                         Function = logframe$V6,
                                         Name = logframe$V7,
                                         Message = logframe$V8))
    obkms$log$current_context = "initialized"
  }


  init_cluster()

  log_event( "completed initialization", "init_env", eventContext = "init")
}


#' @export
init_cluster = function ()
{
  #initialize cluster
  # Calculate the number of cores
  no_cores <- detectCores() - 1
  # Initiate cluster
  obkms$cluster <- makeCluster(no_cores)

}

#' Loads a package database from a yaml file
#' TODO needs review
#' @param database_path path to the database
#' @param   internal_name      is the path to internal database to be used if none supplied
#' @export
load_yaml_database = function ( database_path, internal_name ) {
  pkgname = "obkms"
  if ( is.character( database_path ) && database_path != "" ) {
    # we use the supplied path and return the array
    return( yaml::yaml.load_file( prefix_db ) )
  }
  else {
    # we read from the package settings
    yaml::yaml.load_file(
      paste0( path.package ( pkgname ) , "/",
              as.environment( paste0 ( "package:" , pkgname ) )[[internal_name]] ) )
  }
}

#' Puts author information in the OBKMS environment
#' @export
init_authors_db = function() {
  # template
  query = "
    SELECT ?id ?author ?is_person ?first_name ?family_name ?email ?institution ?affiliation
    WHERE { [] rdf:type fabio:ResearchPaper ;
           dcterms:creator ?id .
           ?id  a foaf:Agent ;
                skos:prefLabel ?author .

    OPTIONAL { ?id foaf:firstName ?first_name }
    OPTIONAL { ?id foaf:surname ?family_name }
    OPTIONAL { ?id foaf:mbox ?email }
    OPTIONAL { ?id org:memberOf ?institution }
    OPTIONAL { ?id :affiliation ?affiliation }

    OPTIONAL {
        FILTER NOT EXISTS { ?id rdf:type foaf:Person }
        BIND (\"FALSE\" as ?is_person )
    }

}"
  # prefixes
  query = do.call( paste0, as.list( c( turtle_prepend_prefixes(t = c("SPARQL")), query) ) )
  # execution
  retval = rdf4jr::POST_query( obkms$server_access_options, obkms$server_access_options$repository, query     )
  obkms$authors = retval[ !duplicated( retval ), ]
}

#' Updates Local Authors Store
#'
#' @param aId author URI
#' @param aAuthor author label
#' @param isPerson is it a person or an agent
#' @param firstName
#' @param familyName
#' @param eMail
#' @param aInst author's institution URI
#' @param aAff author's affiliation string
#' @export
update_authors_db = function ( frame_row ) {
  if ( nrow(obkms$authors) == 0 ) {
    obkms$authors = frame_row
  }
  else {
    obkms$authors = rbind ( frame_row, obkms$authors )
    }
}

#' Initializes the educational institutions gazetteer from dbpedia
#'
#' Args:
#'   @param fromFile if TRUE will read from a local file that has been given in
#'   the initial dump configuraiton
#'
#' @return nothing
#' @export
init_institution_db = function ( fromFile = FALSE, offsetSize = 10000 ) {
  if ( !fromFile ) {
    queries = list()
    # queries$label = "Institutions_Cities"
    # queries$institutions_cities$count =
    #       "SELECT COUNT (?institution as ?num_of_sol) WHERE { SELECT ?institution ?label ?city WHERE {
    #         ?institution a dbo:EducationalInstitution;
    #                      rdfs:label ?label ;
    #                      dbo:city/rdfs:label ?city .
    #       } ORDER BY ?institution }"
    #
    # queries$institutions_cities$query = "SELECT  ?institution ?label ?city WHERE { SELECT  ?institution ?label ?city WHERE {
    #         ?institution a dbo:EducationalInstitution;
    #                      rdfs:label ?label ;
    #                      dbo:city/rdfs:label ?city .
    #       } ORDER BY ?institution }
    #       LIMIT %offsetSize
    #       OFFSET %index"
    #
    #
    #
    # # institutions without city names
    # queries$institutions_only$label = "Institutions_Only"
    # queries$institutions_only$count =
    #   "SELECT  COUNT (?institution as ?num_of_sol)  WHERE { SELECT  ?institution ?label WHERE {
    #         ?institution a dbo:EducationalInstitution;
    #                      rdfs:label ?label .
    #       } ORDER BY ?institution }"
    #
    # queries$institutions_only$query = "SELECT ?institution ?label WHERE { SELECT  ?institution ?label WHERE {
    #         ?institution a dbo:EducationalInstitution;
    #                      rdfs:label ?label .
    #       } ORDER BY ?institution }
    #       LIMIT %offsetSize
    #       OFFSET %index"

    # institutions with cities as triples
    queries$institutions_cities_triples$label  = "Institutions_with_Cities"
    queries$institutions_cities_triples$count = "
    SELECT  COUNT (?institution as ?num_of_sol)
    WHERE {
SELECT  * WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label .
OPTIONAL { ?institution     dbo:city ?cityid .
                  ?cityid rdfs:label ?city . }
          } ORDER BY ?institution
    }"
    queries$institutions_cities_triples$query = "prefix org: <http://www.w3.org/ns/org#>
prefix vcard: <http://www.w3.org/2006/vcard/ns#>

CONSTRUCT
{
  ?institution a org:Organization , dbo:EducationalInstitution;
               rdfs:label ?label ;
               vcard:hasLocality ?cityid .
  ?cityid a vcard:Location ;
          vcard:locality ?city;
          rdfs:label ?city .}
 WHERE { SELECT  * WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label .
OPTIONAL { ?institution                         dbo:city ?cityid .
                  ?cityid rdfs:label ?city . }
          } ORDER BY ?institution }
          LIMIT %offsetSize
          OFFSET %index"


    obkms$gazetteer$Institutions = list()

    for ( q in queries ) {
      inst_count = as.numeric ( rdf4jr::POST_query( obkms$dbpedia_access_options,
                                                    obkms$dbpedia_access_options$repository,
                                                    query = q$count ) )

      cat("Instances are ")
      cat( inst_count )
      cat("\n")

      j  = 1
      Institutions = vector( mode = 'list', length = ceiling ( inst_count / offsetSize ) )

      for ( index in seq( from = 0, to = inst_count, by = offsetSize ) ) {
        cat( "index  = ")
        cat( index )
        cat( "\n" )

        # nested Q needed because of
        # https://stackoverflow.com/questions/20937556/how-to-get-all-companies-from-dbpedia

      Q = gsub( "%offsetSize", offsetSize, q$query )
      Q = gsub( "%index", index, Q )

      Institutions[[j]] = rdf4jr::POST_query( obkms$dbpedia_access_options,
                                                         obkms$dbpedia_access_options$repository,
                                                         query = Q , results_format = "XML")
      j = j + 1
    }
    obkms$gazetteer$Institutions = Institutions
   # okms$gazetteer$Institutions[[ q$label ]] = do.call ( rbind, Institutions )
  #  obkms$gazetteer$Institutions[[ q$label ]] =
  #    obkms$gazetteer$Institutions[[ q$label ]][ !duplicated( obkms$gazetteer$Institutions[[ q$label ]] ) , ]

    }

  # At this point we have two tables - one where institutions are matched with
    # cities and one when they aren't. We will try to enrich the table
    # where institutions are not matched with cities with cities through the
    # gazeteteer and then merge the two tables together

   # institutions_with_unknown_cities =
  #    setdiff( obkms$gazetteer$Institutions$Institutions_Only$institution ,
  #             obkms$gazetteer$Institutions$Institutions_Cities$institution )

#    nocity_index = which( as.character(obkms$gazetteer$Institutions$Institutions_Only$institution) %in% as.character( institutions_with_unknown_cities) )

    # subset of the original only cities data from of only those instituions
    # for which there is no information
 #   obkms$gazetteer$Institutions$MoreCities = obkms$gazetteer$Institutions$Institutions_Only[ nocity_index, ]

#    matched_institution = function( city_name , true_name ) {
 #     if (missing(true_name)) {true_name = city_name}
#      indices = grepl( city_name, obkms$gazetteer$Institutions$MoreCities$label )
#      returnval =
#        obkms$gazetteer$Institutions$MoreCities[
#          indices, ]
#      cbind(returnval, rep(true_name, nrow (returnval)))
#    }

    #try to enrich from gazetteer
#    clusterExport(cl=obkms$cluster, varlist=c("obkms"))
 #   Institutions = parLapply( obkms$cluster, obkms$gazetteer$cities$name, matched_institution)


  #  obkms$gazetteer$Institutions$MoreCities = do.call(rbind, Institutions)
  #  names(  obkms$gazetteer$Institutions$MoreCities ) = (c( "institution", "label", "city"))

#    obkms$gazetteer$Institutions$Institutions_Cities =
 #     rbind (obkms$gazetteer$Institutions$Institutions_Cities ,  obkms$gazetteer$Institutions$MoreCities)

  #  obkms$gazetteer$Institutions$Institutions_Cities =
  #    obkms$gazetteer$Institutions$Institutions_Cities[ !duplicated( obkms$gazetteer$Institutions$Institutions_Cities ) , ]

#    write.table( obkms$gazetteer$Institutions$Institutions_Cities,
#                 file = obkms$initial_dump_configuration$gazetteer$institutions )

#    write.table( obkms$gazetteer$Institutions$Institutions_Only,
#                 file = obkms$initial_dump_configuration$gazetteer$institutions_no_city )

#    obkms$gazetteer$Institutions$MoreCities = NULL
   }
   else {
     obkms$gazetteer$Institutions$Institutions_Cities =
       read.table( obkms$initial_dump_configuration$gazetteer$institutions , stringsAsFactors = FALSE)

     obkms$gazetteer$Institutions$Institutions_Only =
       read.table( obkms$initial_dump_configuration$gazetteer$institutions_no_city , stringsAsFactors = FALSE)

 }
}


# Turtle generation
#' @export
process_dump_list = function ( dump_list ) {
  for ( d in dump_list ) {
    cat(d)
    obkms$log$current_context = d
    spl = strsplit(d, "/")[[1]]
    filename = spl[length(spl)]
    filename = paste0( obkms$initial_dump_configuration$turtle_directory, "/", filename, ".ttl" )
    log_event( "new context", "process_dump_list", filename )
    turtle = xml2rdf( d )
    writeLines( turtle,  filename )
    r = rdf4jr::add_data( obkms$server_access_options, obkms$server_access_options$repository, turtle )
    log_event(  "submission to server", "process_dump_list", httr::content(r, as = 'text') )
  }
}

#' Compute Various Iteration Statistics
#' @param Log a log data.frame to work with
#' @return a \emph{list} of statistics
#' @export
compute_statistics_from_log = function ( Log )
{
  Statistics = list( 10 )

  function_name = list(c("lookup_id", "lookup id"),
                       "lookup_institution",
                       "dbpedia_lookup",
                       "disambig_author",
                       "qname" )

  return( lapply( function_name, comp_func_stats, Log = Log ) )

}

#' Compute Statistics For a Particular Function
#'
#' Computes:
#'   Total calls
#'   percentage of different statuses of the particular type
#'
#' @param Log
#' @param fname the name of the function for which you want to compute statistics
#' @return a list of statistics
comp_func_stats = function ( fname, Log  )
{
  index = as.logical ( match ( Log$Function, fname ) )
  total_call = sum( index, na.rm = TRUE )
  status = factor( Log[index, "Name"] )
  status_rate = sapply( levels( status ), function( s, Log ) {
    sum ( Log$Name == s )
  }, Log = Log)
  return_value = c(  total_call, status_rate / total_call)
  names( return_value )[1] = do.call( paste, as.list( fname ) )
  return (  return_value )
}
