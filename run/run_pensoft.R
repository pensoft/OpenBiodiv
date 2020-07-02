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

#last_modified = read.table("/home/backend/OpenBiodiv/last_modified_pensoft", stringsAsFactors = FALSE)
#last_modified = last_modified[nrow(last_modified), ]
#last_xml = xml2::read_xml(last_modified)
#if the last modified file was fully processed proceed
#if (length(xml2::xml_find_all(last_xml, "//@obkms_id")) > 1){


general_collection =  mongolite::mongo(collection = "new_collection", db = "test")
inst_collection = mongolite::mongo(collection = "institutions", db = "test")
checklistCol = mongolite::mongo(collection = "checklist", db = "openbiodiv")# Process Pensoft
xmls= mongolite::mongo(collection = "xmls", db = "test")
pensoft_files = list.files(
  configuration$pjsupload,
  full.names = TRUE,
  pattern = "*.xml"
)

#pp = pensoft_files[1:(length(pensoft_files)/2)]


#pp = sort(pp, decreasing = TRUE)


#processed = read.table("/home/backend/OpenBiodiv/truly_processed.txt")
for (filename in pensoft_files){

	print(filename)
	tryCatch(
	{
        xml = xml2::read_xml(filename)
        processing_status = processing_status(xml)
        if (processing_status==FALSE){
          

          query = sprintf("{\"%s\":\"%s\"}", "filename", filename)
          mongo_xml = xmls$find(query)$xml
          if (!(is.null(mongo_xml))){
              #check graph?
              mongo_xml = xml2::as_xml_document(mongo_xml)
              xml2::write_xml(mongo_xml, file = filename)
          }else{
            print(filename)
            proc = paste(filename, "\n")
            xml2rdf(filename, xml_schema = material_schema, access_options = obkms, serialization_dir = "/opt/data/obkms/pensoft_serializations", reprocess = FALSE, dry = configuration$dry_run, grbio = "/home/backend/OpenBiodiv/tests/grbio/grbio_institutions_05_29_18.csv", taxon_discovery = "/home/backend/OpenBiodiv/tests/status_vocab_abbrev/taxon_discovery.txt")
            cat(proc, file ="/home/backend/OpenBiodiv/truly_processed.txt", append = TRUE)
            print(warnings())  
        }
}},
error = function(e)
{
 cat(paste(filename, "\n"), file = "/home/backend/OpenBiodiv/skipped.txt", append = TRUE)
})
  }
 # }else {
#	print("last file was not modified")
#	cat(last_modified, file = "/home/backend/OpenBiodiv/failed_processing", append = TRUE)
#	}
