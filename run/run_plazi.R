#devtools::install_github("mdmtrv/rdf4r")
devtools::install_github("mdmtrv/ropenbio", force = TRUE)

library(methods)
library(rdf4r)
library(ropenbio)
library(tictoc)

# Connect to OBKMS

configuration = yaml::yaml.load_file("/home/backend/OpenBiodiv/local/deployment.yml")
obkms = basic_triplestore_access(
  server_url = configuration$server_url,
  repository = configuration$repository,
  user = configuration$user,
  password = configuration$password
)

obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")
prefix = obkms$prefix

general_collection =  mongolite::mongo(collection = "new_collection", db = "test")
inst_collection = mongolite::mongo(collection = "institutions", db = "test")
checklistCol = mongolite::mongo(collection = "checklist", db = "openbiodiv")# Process Pensoft
xmls= mongolite::mongo(collection = "xmls", db = "test")
plazi_files= list.files(
  configuration$plazi_download,
  full.names = TRUE,
  pattern = "*.plazixml"
)

for (filename in plazi_files) {
	print(filename)
	tryCatch(
	{
        xml = xml2::read_xml(filename)
        processing_status = processing_status(xml)
        if (processing_status==FALSE){
            xml2rdf(filename, xml_schema = plazi_schema, access_options = obkms, serialization_dir = configuration$plazi_serialization_dir, reprocess = FALSE, dry = configuration$dry_run, grbio = "/home/backend/OpenBiodiv/tests/grbio/grbio_institutions_05_29_18.csv", taxon_discovery = "/home/backend/OpenBiodiv/tests/status_vocab_abbrev/taxon_discovery.txt")
            cat(proc, file ="/home/backend/OpenBiodiv/truly_processed.txt", append = TRUE)
            print(warnings())  
        }
},
error = function(e)
{
 cat(paste(filename, "\n"), file = "/home/backend/OpenBiodiv/skipped.txt", append = TRUE)
})
  }
