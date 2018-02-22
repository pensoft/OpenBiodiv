# Iteration 7
# Adding collection codes
# needed libraries
library(ropenbio)
library(parallel)

# Manual step
# Create repository
# Import ontologies and exisiting data
# import connectors
# download XML data

# configure access to graphdb server
configuration_file = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/7/config.yml"
server_access_options = yaml::yaml.load_file(configuration_file)
init_env(server_access_options)

dump_list = paste0("/media/obkms/pensoft-corpus-xml/", readLines("../openbiodiv/runs/iteration/7/dump_list.txt"))
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

