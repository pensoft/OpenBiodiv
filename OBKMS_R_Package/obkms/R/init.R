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
                      prefix_db = paste0( path.package ( 'obkms' ) , "/", "prefix_db.yml" ),
                      entities_db =  paste0( path.package ( 'obkms' ) , "/", "semantic_entities_db.yml" ),
                      literals_db_xpath = paste0( path.package ( 'obkms' ) , "/", "literals_db_xpath.yml" ),
                      xml_source = "file",
                      xml_type = "taxpub" ) {

    stopifnot ( is.character( server_access_options$userpwd)  )

  if (!exists('obkms')) {
    obkms <<- new.env()
  }
  obkms$server_access_options = server_access_options

  obkms$prefixes = yaml::yaml.load_file(prefix_db)
  obkms$entities = yaml::yaml.load_file ( entities_db )

  obkms$config = list()
  obkms$config['literals_db_xpath'] = literals_db_xpath
  obkms$config['prefix_db'] = prefix_db
  obkms$config['entities_db'] = entities_db

  obkms$xml_source = xml_source
  obkms$xml_type = xml_type
}

#' Loads a package database from a yaml file
#'
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
