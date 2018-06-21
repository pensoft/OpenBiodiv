# Iteration 8
library(rdf4r)
library(ropenbio)
library(parallel)
obkms = basic_triplestore_access(
  server_url = "192.168.83.16:7777",
  repository = "obkms_i8",
  user = "admin",
  password = Sys.getenv("OBKMS")
)

#list_repositories(obkms)
obkms$repository = "obkms_i8"
obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")

# Process Plazi
taxonx_files = list.files(
  "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/plazi-test",
  full.names = TRUE,
  pattern = "*.xml"
)

processing_results = sapply(taxonx_files, xml2rdf, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reprocess = TRUE, dry = TRUE)

# Process Plazi
pensoft_files = list.files(
  "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/pensoft-test",
  full.names = TRUE,
  pattern = "*.xml"
)

# Calculate the number of cores
no_cores <- 2

# Initiate cluster
cl <- makeCluster(no_cores, type = "FORK")

pensoft_processing_results = parSapply(cl = cl, pensoft_files, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reproces = TRUE)

stopCluster(cl)

# fails
writeLines(names(failed_processing[failed_processing == FALSE]), con =
            "../openbiodiv/runs/iteration/8/fails.txt")


failed_processing = sapply(, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reproces = TRUE)
