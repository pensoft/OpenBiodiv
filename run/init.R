# Repository Initialization

# Manual Step:
# 1. Create new repository
#  ruleset OWL2-RL
#

configuration = yaml::yaml.load_file("local/deployment.yml")

# Connect to OBKMS
library(rdf4r)
obkms = basic_triplestore_access(
  server_url = configuration$server_url,
  repository = configuration$repository,
  user = configuration$user,
  password = Sys.getenv("OBKMS")
)

# Importing of ontologies
ontologies = lapply(
  list.files(
    configuration$ontology_imports,
    pattern = "*.ttl",
    full.names =  TRUE
    ),
  readLines
)

sapply(ontologies, add_data, access_options = obkms)

# Import Lucene Connectors
connectors = lapply(
  list.files(
    configuration$connectors,
    pattern = "*.sparql",
    full.names = TRUE
  ),
  readLines
)

sapply(connectors, submit_sparql_update, access_options = obkms)

