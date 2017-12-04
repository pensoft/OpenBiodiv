#' Iteration 4

# needed libraries
library(ropenbio)
library(parallel)

configuration_file = "/home/viktor2/Work/PhD/openbiodiv/test/agris/config.yml"
server_access_options = yaml::yaml.load_file(configuration_file)
init_env(server_access_options)

dump_list = list.files( path = "/media/obkms/XML3/inbox", pattern = "*", full.names = TRUE)
dump_list = dump_list[-c(which(grepl("1014", dump_list)), which(grepl("1069", dump_list)), which(grepl("1099", dump_list)), which(grepl("1165", dump_list)), which(grepl("4597", dump_list)))]
# bugs
response_bdj = process_dump_list(dump_list)

logs = write_log( toFile = TRUE, append = FALSE, iteration_name = "Iteration_3")
Statistics = compute_statistics_from_log( logs )



#zookeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "zookeys"), full.names = TRUE)
dump_list = setdiff( dump_list, unique(logs$Context))
response_phytokeys = process_dump_list ( dump_list )

# phytokeys

dump_list = list.files( path = "/media/obkms/XML2", pattern = c(  "*.xml"), full.names = TRUE)
response_phytokeys = process_dump_list ( dump_list )

