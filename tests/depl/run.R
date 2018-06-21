# Testing the deployment
library(rdf4r)
library(ropenbio)

obkms = basic_triplestore_access(
  server_url = "192.168.90.23:7200",
  repository = "depl2018",
  user = "admin",
  password = Sys.getenv("OBKMS")
)

list_repositories(obkms)
obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")





# Process Plazi
taxonx_files = list.files(
  "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/plazi-test",
  full.names = TRUE,
  pattern = "*.xml"
)

processing_results = sapply(taxonx_files, xml2rdf, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reprocess = TRUE)

# Process Plazi
pensoft_files = list.files(
  "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/pensoft-test",
  full.names = TRUE,
  pattern = "*.xml"
)


pensoft_processing_results = sapply(pensoft_files, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/tests/depl/ttl-test", reproces = TRUE, dry = TRUE)


# fails
writeLines(names(failed_processing[failed_processing == FALSE]), con =
            "../openbiodiv/runs/iteration/8/fails.txt")


failed_processing = sapply(, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reproces = TRUE)
