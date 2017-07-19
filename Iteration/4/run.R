#' Iteration 4

# needed libraries
library(obkms)
library(rdf4jr)
library(parallel)

# Manual step
# Create repository
# Import ontologies and exisiting data
# import connectors

# configure access to graphdb server
configuration_file = "/home/viktor/Work/openbiodiv/Iteration/4/config.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options )

# load dump list so far
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) )
# download all new bdj_articles from the dump_date
new_files_list = bdj_dumper( journal = "BDJ", fromdate = dump_date )

# subsample some files for debuging purposes
dump_list = list.files( path = "/media/obkms/XML2", pattern = "BDJ", full.names = TRUE)
dump_list = sample(dump_list, 10)

response_bdj = process_dump_list( dump_list[1] )

logs = write_log( toFile = TRUE, append = FALSE, iteration_name = "Iteration_3")
Statistics = compute_statistics_from_log( logs )



#zookeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "zookeys"), full.names = TRUE)
dump_list = setdiff( dump_list, unique(logs$Context))
response_phytokeys = process_dump_list ( dump_list )

# phytokeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "phytokeys"), full.names = TRUE)
response_phytokeys = process_dump_list ( dump_list )

