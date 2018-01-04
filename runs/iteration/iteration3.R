#' Iteration 2

# needed libraries
library(obkms)
library(rdf4jr)
library(parallel)

# configure access to graphdb server
configuration_file = "/home/viktor/Work/OBKMS/etc/graphdb8_i3.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options, iteration = "Iteration_3")

  # BDJ
# update from last iteration
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) )
dump_list = bdj_dumper( journal = "BDJ", fromdate = "13/06/2017" ) # dump all of the BDJ
dump_list = list.files( path = "/media/obkms/XML2", pattern = "BDJ", full.names = TRUE)
dump_list = sample(dump_list, 10)

response_bdj = process_dump_list( dump_list )

logs = write_log( toFile = TRUE, append = FALSE, iteration_name = "Iteration_3")
Statistics = compute_statistics_from_log( logs )



#zookeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "zookeys"), full.names = TRUE)
dump_list = setdiff( dump_list, unique(logs$Context))
response_phytokeys = process_dump_list ( dump_list )

# phytokeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "phytokeys"), full.names = TRUE)
response_phytokeys = process_dump_list ( dump_list )

