#' Dumps all of the BDJ up to the present date in a predefined directory
#' @export
bdj_dumper = function ( journal = "BDJ", fromdate ) {
  if ( missing( fromdate ) ) fromdate = c( "01/01/2010" )
  log_event ( paste( "begin dumping of", journal, "from date", fromdate ) )
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
  dump_date = as.character( format( Sys.Date(), "%d/%m/%y" ) )
  save( dump_date, dump_list, file = rdata )
  log_event ( paste( "found", length( dump_list ), "new files" ) )
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

#' Store graph database access data in an environment.
#'
#' In order not to have to parameterize each function with the database access
#' information, the access options are stored in an environment, which is then
#' utilzed by the individual package functions. It also enriches the options
#'
#' @export
init_env = function ( server_access_options,
                      dbpedia_access_options = paste0( path.package ( 'obkms' ) , "/", "dbpedia_access_options.yml" ) ,
                      prefix_db = paste0( path.package ( 'obkms' ) , "/", "prefix_db.yml" ),
                      #entities_db =  paste0( path.package ( 'obkms' ) , "/", "semantic_entities_db.yml" ),
                      properties_db =  paste0( path.package ( 'obkms' ) , "/", "properties_db.yml" ),
                      classes_db =  paste0( path.package ( 'obkms' ) , "/", "classes_db.yml" ),
                     # vocabulary_db =  paste0( path.package ( 'obkms' ) , "/", "vocabulary_db.yml" ),
                      parameters_db =  paste0( path.package ( 'obkms' ) , "/", "parameters_db.yml" ),
                      literals_db_xpath = paste0( path.package ( 'obkms' ) , "/", "literals_db_xpath.yml" ),
                      non_literals_db_xpath = paste0( path.package ( 'obkms' ) , "/", "non_literals_db_xpath.yml" ),
                      initial_dump_configuration = paste0( path.package ( 'obkms' ) , "/", "initial_dump_configuration.yml") ,
                      authors_db_xpath =  paste0( path.package ( 'obkms' ) , "/", "authors_db_xpath.yml" ),
                      country_names = paste0( path.package ( 'obkms' ) , "/", "country_names.csv" ) ,
                      city_names = paste0( path.package ( 'obkms' ) , "/", "city_names.csv" ) ,
                      xml_source = "file",
                      xml_type = "taxpub" ) {
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
 # obkms$entities = yaml::yaml.load_file ( entities_db )
  obkms$properties = yaml::yaml.load_file ( properties_db )
  obkms$classes = yaml::yaml.load_file ( classes_db )
  #obkms$vocabulary = yaml::yaml.load_file ( vocabulary_db )

  obkms$parameters = yaml::yaml.load_file ( parameters_db )

  obkms$config = list()
  obkms$config['literals_db_xpath'] = literals_db_xpath
  obkms$config['non_literals_db_xpath'] = non_literals_db_xpath
  obkms$config['prefix_db'] = prefix_db
  #obkms$config['entities_db'] = entities_db
  obkms$config['properties_db'] = properties_db
  obkms$config['classes_db'] = classes_db
  obkms$config['authors_db_xpath'] = authors_db_xpath

  obkms$xml_source = xml_source
  obkms$xml_type = xml_type

  obkms$gazetteer$countries =
    read.delim (  obkms$initial_dump_configuration$gazetteer$countries , header = FALSE, sep = "\t", comment.char = "~", stringsAsFactors = FALSE)
  names( obkms$gazetteer$countries ) = c( "ISO", "ISO3", "ISO-Numeric", "fips", "Country" , "Capital", "Area(in sq km)", "Population",	"Continent", "tld", "CurrencyCode", "CurrencyName", "Phone", "Postal Code Format", "Regex", "Languages", "geonameid", "neighbours", "EquivalentFipsCode")

  # http://download.geonames.org/export/dump/readme.txt
  obkms$gazetteer$cities = read.delim ( obkms$initial_dump_configuration$gazetteer$cities , header = FALSE, sep = "\t", comment.char = "#", stringsAsFactors = FALSE)
  names ( obkms$gazetteer$cities ) = c( "geonameid", "name", "asciiname", "alternatenames", "latitude", "longitude", "feature class", "feature code", "country code", "cc2", "admin1 code", "admin2 code", "admin3 code", "admin4 code", "population",
                                       "elevation", "dem", "timezone", "modification date")

  # options to be used with the xml2::read_xml funciton
  obkms$xml_options = c()

  obkms$log$number_of_events = 0
  obkms$log$events = list()
  obkms$log$current_context = c("initialized")


  init_cluster()
  init_authors_db()
  init_institution_db( fromFile = TRUE )
  log_event( "completed initialization", "init_env" )
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
    SELECT ?id ?author ?is_person ?first_name ?family_name ?mbox ?institution ?affiliation
    WHERE { [] rdf:type fabio:ResearchPaper ;
           dcterms:creator ?id .
           ?id  a foaf:Agent ;
                skos:prefLabel ?author .
    OPTIONAL {
        FILTER NOT EXISTS { ?id rdf:type foaf:Person }
        BIND (\"FALSE\" as ?is_person )
    }
    OPTIONAL {
        ?id rdf:type foaf:Person ;
            foaf:firstName ?first_name ;
            foaf:surname ?family_name ;
            foaf:mbox ?email .
            BIND (\"TRUE\" as ?is_person )
    }
    OPTIONAL {
        ?id rdf:type foaf:Person ;
            foaf:surname ?family_name ;
            foaf:firstName ?first_name ;
            org:memberOf ?institution .
            BIND (\"TRUE\" as ?is_person )
    }
    OPTIONAL {
        ?id rdf:type foaf:Person ;
            foaf:surname ?family_name ;
            foaf:firstName ?first_name ;
            :affiliation ?affiliation .
            BIND (\"TRUE\" as ?is_person )
    }
}"
  # prefixes
  query = do.call( paste0, as.list( c( turtle_prepend_prefixes(t = c("SPARQL")), query) ) )
  # execution
  retval = rdf4jr::POST_query( obkms$server_access_options, obkms$server_access_options$repository, query     )
  obkms$authors = retval[ !duplicated( retval ), ]
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
    queries$label = "Institutions_Cities"
    queries$institutions_cities$count =
          "SELECT COUNT (?institution as ?num_of_sol) WHERE { SELECT ?institution ?label ?city WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label ;
                         dbo:city/rdfs:label ?city .
          } ORDER BY ?institution }"

    queries$institutions_cities$query = "SELECT  ?institution ?label ?city WHERE { SELECT  ?institution ?label ?city WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label ;
                         dbo:city/rdfs:label ?city .
          } ORDER BY ?institution }
          LIMIT %offsetSize
          OFFSET %index"


    # institutions without city names
    queries$institutions_only$label = "Institutions_Only"
    queries$institutions_only$count =
      "SELECT  COUNT (?institution as ?num_of_sol)  WHERE { SELECT  ?institution ?label WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label .
          } ORDER BY ?institution }"

    queries$institutions_only$query = "SELECT ?institution ?label WHERE { SELECT  ?institution ?label WHERE {
            ?institution a dbo:EducationalInstitution;
                         rdfs:label ?label .
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
                                                         query = Q )
      j = j + 1
    }

    obkms$gazetteer$Institutions[[ q$label ]] = do.call ( rbind, Institutions )
    obkms$gazetteer$Institutions[[ q$label ]] =
      obkms$gazetteer$Institutions[[ q$label ]][ !duplicated( obkms$gazetteer$Institutions[[ q$label ]] ) , ]

    }

  # At this point we have two tables - one where institutions are matched with
    # cities and one when they aren't. We will try to enrich the table
    # where institutions are not matched with cities with cities through the
    # gazeteteer and then merge the two tables together

    institutions_with_unknown_cities =
      setdiff( obkms$gazetteer$Institutions$Institutions_Only$institution ,
               obkms$gazetteer$Institutions$Institutions_Cities$institution )

    nocity_index = which( as.character(obkms$gazetteer$Institutions$Institutions_Only$institution) %in% as.character( institutions_with_unknown_cities) )

    # subset of the original only cities data from of only those instituions
    # for which there is no information
    obkms$gazetteer$Institutions$MoreCities = obkms$gazetteer$Institutions$Institutions_Only[ nocity_index, ]

    matched_institution = function( city_name , true_name ) {
      if (missing(true_name)) {true_name = city_name}
      indices = grepl( city_name, obkms$gazetteer$Institutions$MoreCities$label )
      returnval =
        obkms$gazetteer$Institutions$MoreCities[
          indices, ]
      cbind(returnval, rep(true_name, nrow (returnval)))
    }

    #try to enrich from gazetteer
    clusterExport(cl=obkms$cluster, varlist=c("obkms"))
    Institutions = parLapply( obkms$cluster, obkms$gazetteer$cities$name, matched_institution)


    obkms$gazetteer$Institutions$MoreCities = do.call(rbind, Institutions)
    names(  obkms$gazetteer$Institutions$MoreCities ) = (c( "institution", "label", "city"))

    obkms$gazetteer$Institutions$Institutions_Cities =
      rbind (obkms$gazetteer$Institutions$Institutions_Cities ,  obkms$gazetteer$Institutions$MoreCities)

    obkms$gazetteer$Institutions$Institutions_Cities =
      obkms$gazetteer$Institutions$Institutions_Cities[ !duplicated( obkms$gazetteer$Institutions$Institutions_Cities ) , ]

    write.table( obkms$gazetteer$Institutions$Institutions_Cities,
                 file = obkms$initial_dump_configuration$gazetteer$institutions )

    write.table( obkms$gazetteer$Institutions$Institutions_Only,
                 file = obkms$initial_dump_configuration$gazetteer$institutions_no_city )

    obkms$gazetteer$Institutions$MoreCities = NULL
  }
  else {
    obkms$gazetteer$Institutions$Institutions_Cities =
      read.table( obkms$initial_dump_configuration$gazetteer$institutions , stringsAsFactors = FALSE)

    obkms$gazetteer$Institutions$Institutions_Only =
      read.table( obkms$initial_dump_configuration$gazetteer$institutions_no_city , stringsAsFactors = FALSE)

  }
}
