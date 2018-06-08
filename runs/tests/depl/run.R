# Test Deployment
library(rdf4r)
library(ropenbio)

obkms = basic_triplestore_access(
  server_url = "192.168.90.23:7200",
  repository = "depl_test",
  user = "admin",
  password = Sys.getenv("OBKMS")
)

list_repositories(obkms)
obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")

# Process Pensoft Test
pensoft_files = list.files(
  "~/OpenBiodiv/runs/tests/depl/pensoft-test",
  full.names = TRUE,
  pattern = "*.xml"
)


proc_res = sapply(pensoft_files, xml2rdf, xml_schema = taxpub, access_options = obkms,
serialization_dir = "~/OpenBiodiv/runs/tests/depl/ttl-test", reproces = TRUE)


# fails
writeLines(names(failed_processing[failed_processing == FALSE]), con =
            "../openbiodiv/runs/iteration/8/fails.txt")


failed_processing = sapply(, xml2rdf, xml_schema = taxpub, access_options = obkms, serialization_dir = "/home/viktor2/Work/PhD/openbiodiv/runs/iteration/8/ttl-test", reproces = TRUE)
