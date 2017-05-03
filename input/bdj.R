#' LOAD BIODIVERSITY DATA JOURNAL ARTICLES INTO OBKMS
#'

library(obkms)
library(rdf4jr)

configuration_file = "/home/viktor/Work/OBKMS/etc/graphdb8_test.yml"
server_access_options = yaml::yaml.load_file( configuration_file )

