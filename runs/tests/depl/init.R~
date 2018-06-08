# Iteration Initialization

# Manual Step:
# 1. Create new repository
# 1.a ruleset OWL2-RL
# -------> obkms_i8

# Connect to OBKMS
library(rdf4r)
obkms = basic_triplestore_access(
  server_url = "192.168.83.16:7777",
  repository = "obkms_i8",
  user = "admin",
  password = Sys.getenv("OBKMS")
)
#list_repositories(obkms)
obkms$repository = "obkms_i8"

# Importing of ontologies
ontologies = lapply(
  list.files(
    "/home/viktor2/Work/PhD/openbiodiv/ontology/imports",
    pattern = "*.ttl",
    full.names =  TRUE
    ),
  readLines
)

sapply(ontologies, add_data, access_options = obkms)

# Import Lucene Connectors
connectors = lapply(
  list.files(
    "/home/viktor2/Work/PhD/openbiodiv/lucene",
    pattern = "*.sparql",
    full.names = TRUE
  ),
  readLines
)

sapply(connectors, submit_sparql_update, access_options = obkms)

