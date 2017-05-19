#' Load BDJ Data Into OBKMS

# needed libraries
library(obkms)
library(rdf4jr)

# configure access to graphdb server
configuration_file = "/home/viktor/Work/OBKMS/etc/graphdb8_test.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
init_env(server_access_options)

# load some sample articles
harmonia_manillana_article = "/home/viktor/Work/OBKMS/ontology/sample_articles/Harmonia_manillana.xml"
heser_stoevi_article = "/home/viktor/Work/OBKMS/ontology/sample_articles/Heser_stoevi.xml"

# some debugging
xml = xml2::read_xml( harmonia_manillana_article , options = c())
#article_id = xml2::xml_text( xml2::xml_find_all( xml, "//@obkms_id" ) [[1]] )
article_id = xml2::xml_text( xml2::xml_find_all( xml, "//@obkms_id" )  )

# run taxpub extractor on them
xml2rdf(harmonia_manillana_article)

# Initial population with a new journal or source
bdj_dumper() # dump all of the BDJ
load (  paste0( obkms$initial_dump_configuration$initial_dump_directory, ".Rdata" ) ) # now dump_list is loaded from the dump directory
dump_list = sample ( dump_list, 2 ) # downsampling for debugging purposes
xml2rdf
