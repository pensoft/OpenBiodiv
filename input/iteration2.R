#' Iteration 2

# needed libraries
library(obkms)
library(rdf4jr)
library(parallel)

# configure access to graphdb server
configuration_file = "/home/viktor/Work/OBKMS/etc/graphdb8_i2.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options)

# BDJ
# update from last iteration from 08 of June 2017
bdj_dumper( journal = "BDJ", fromdate = "08/06/2017") # dump all of the BDJ
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) )
dump_list =
  list.files( path = "/media/obkms/XML2",
              pattern = "10.3897_zookeys.223.3572.xml",
              full.names = TRUE) # debugging
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

intersect( which( sapply( obkms$gazetteer$Institutions$city, grepl,  x = "Department of Entomology, North Carolina State University, Campus Box 7613, 2301 Gardner Hall, Raleigh, NC 27695-7613 USA") ) , which( sapply( obkms$gazetteer$Institutions$label, grepl,  x = "Department of Entomology, North Carolina State University, Campus Box 7613, 2301 Gardner Hall, Raleigh, NC 27695-7613 USA") ) )

