#' Dumps all of the BDJ up to the present date in a predefined directory
#' @export
bdj_dumper = function ( journal = "BDJ", fromdate ) {
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
#'@export

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

  obkms$gazeteer$countries = read.delim (  "/home/viktor/R/x86_64-pc-linux-gnu-library/3.4/obkms/country_names.csv" , header = FALSE, sep = "\t", comment.char = "~")
  names( obkms$gazeteer$countries ) = c( "ISO", "ISO3", "ISO-Numeric", "fips", "Country" , "Capital", "Area(in sq km)", "Population",	"Continent", "tld", "CurrencyCode", "CurrencyName", "Phone", "Postal Code Format", "Regex", "Languages", "geonameid", "neighbours", "EquivalentFipsCode")

  # http://download.geonames.org/export/dump/readme.txt
  obkms$gazeteer$cities = read.delim (  "/home/viktor/R/x86_64-pc-linux-gnu-library/3.4/obkms/city_names.csv" , header = FALSE, sep = "\t", comment.char = "#")
  names ( obkms$gazeteer$cities ) = c( "geonameid", "name", "asciiname", "alternatenames", "latitude", "longitude", "feature class", "feature code", "country code", "cc2", "admin1 code", "admin2 code", "admin3 code", "admin4 code", "population",
                                       "elevation", "dem", "timezone", "modification date")

  # options to be used with the xml2::read_xml funciton
  obkms$xml_options = c()
  update_authors_db()
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
update_authors_db = function() {
  # template
  query = "
    SELECT ?id ?author ?is_person ?first_name ?family_name ?mbox ?institution
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
          #  vcard:hasOrganizationName ?institution .
            BIND (\"TRUE\" as ?is_person )
    }
}"
  # prefixes
  query = do.call( paste0, as.list( c( turtle_prepend_prefixes(t = c("SPARQL")), query) ) )
  # execution
  obkms$authors = rdf4jr::POST_query( obkms$server_access_options, obkms$server_access_options$repository, query )
}

