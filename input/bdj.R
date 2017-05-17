#' Load BDJ Data Into OBKMS

# needed libraries
library(obkms)
library(rdf4jr)

# configure access to graphdb server
configuration_file = Sys.getenv("OBKMS_CONFIGURATION_FILE")
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options)

# load some sample articles
harmonia_manillana_article = "/home/viktor/Work/OBKMS/ontology/sample_articles/Harmonia_manillana.xml"
heser_stoevi_article = "/home/viktor/Work/OBKMS/ontology/sample_articles/Heser_stoevi.xml"

# run taxpub extractor on them
xml2rdf(harmonia_manillana_article)
