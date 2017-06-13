#' Iteration 1

# needed libraries
library(obkms)
library(rdf4jr)

# configure access to graphdb server
configuration_file = "/home/viktor/Work/OBKMS/etc/graphdb8_test.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options)

# bdj
# Initial population with a new journal or source
bdj_dumper() # dump all of the BDJ
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) ) # now dump_list is loaded from the dump directory
#dump_list = list.files( path = "/media/obkms/XML2", pattern = "BDJ", full.names = TRUE)
response_bdj = process_dump_list( dump_list )
writeLines( response_bdj, file = "iteration1.log")

# Turtle generation

process_dump_list = function ( dump_list ) {
  responses = c()
  for ( d in dump_list ) {
    spl = strsplit(d, "/")[[1]]
    filename = spl[length(spl)]
    filename = paste0( obkms$initial_dump_configuration$turtle_directory, "/", filename, ".ttl" )
    message = paste( "Processing", d, "as", filename)
    turtle = xml2rdf( d )
    writeLines( turtle,  filename )
    r = rdf4jr::add_data( obkms$server_access_options, obkms$server_access_options$repository, turtle )
    responses = c( responses, message, httr::text_content(r) )
  }
  return( responses )
}

# zookeys
bdj_dumper(journal = "ZooKeys", fromdate = "1/1/2017") # dump all of the BDJ
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) ) # now dump_list is loaded from the dump directory
#dump_list = list.files( path = "/media/obkms/XML2", pattern = "zookeys", full.names = TRUE)
response_zookeys = process_dump_list ( dump_list )
