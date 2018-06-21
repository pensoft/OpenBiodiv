# Testing the deployment
library(rdf4r)
library(ropenbio)

configuration = yaml::yaml.load_file("local/deployment.yml")

obkms = basic_triplestore_access(
  server_url = configuration$server_url,
  repository = configuration$repository,
  user = configuration$user,
  password = Sys.getenv("OBKMS")
)

obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")

# Process Pensoft
pensoft_files = list.files(
  configuration$pjsupload,
  full.names = TRUE,
  pattern = "*.xml"
)

pensoft_processing_results = sapply(pensoft_files, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = configuration$serialization_dir, reproces = configuration$reprocess, dry = configuration$dry_run)

# fails
writeLines(paste(names(pensoft_processing_results), pensoft_processing_results), con = paste0(configuration$log, "/status.log"))

