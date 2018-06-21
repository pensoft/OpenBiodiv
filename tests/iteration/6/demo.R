library(ropenbio)
library(parallel)

# configure access to graphdb server
configuration_file = "/home/viktor2/Work/PhD/openbiodiv/iteration/6/config.yml"
server_access_options = yaml::yaml.load_file(configuration_file)
init_env(server_access_options)

get_protocol_version(server_access_options)


dump_list = c("/media/obkms/XML3/processed/10.3897_BDJ.2.e1053.xml")

xml2rdf(dump_list)
