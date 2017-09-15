#' Iteration 5: we want to add TNU's etc

# needed libraries
library(ropenbio)
library(parallel)

# Manual:
#   Repository creation: done
#   Import ontologies: skos, foaf, fabio, dcterms, dcelements: done
#   Fix namespace problems: done

# configure access to graphdb server
configuration_file = "/home/viktor2/Work/PhD/openbiodiv/iteration/5/config.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options )

get_protocol_version( obkms$server_access_options )

# load dump list so far
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) )

# BDJ
bdj_new_files = article_dumper( journal = "BDJ", fromdate = dump_date )

response_bdj = process_dump_list( dump_list )





logs = write_log( toFile = TRUE, append = FALSE, iteration_name = "Iteration 5")
Statistics = compute_statistics_from_log( logs )



#zookeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "zookeys"), full.names = TRUE)
dump_list = setdiff( dump_list, unique(logs$Context))
response_phytokeys = process_dump_list ( dump_list )

# phytokeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "*.xml"), full.names = TRUE)
response_phytokeys = process_dump_list ( dump_list )

