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
plazi_files = list.files(
  configuration$plazi_download,
  full.names = TRUE,
  pattern = "*\\.xml"
)

plazi_processing_results = sapply(plazi_files, xml2rdf, xml_schema = taxonx, access_options = obkms, serialization_dir = configuration$plazi_serialization_dir, reproces = configuration$reprocess, dry = configuration$dry_run)

# fails
writeLines(paste(names(plazi_processing_results), plazi_processing_results), con = paste0(configuration$log, "/", Sys.Date(), "-plazi-status.log"))

