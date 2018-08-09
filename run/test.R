
# Repository Initialization

# Manual Step:
# 1. Create new repository
#  ruleset OWL2-RL
#

configuration = yaml::yaml.load_file("local/deployment.yml")

spec = matrix(c(
  'reprocess', 'r', 2, "logical"),
  byrow=TRUE, ncol=4);


# Connect to OBKMS
library(rdf4r)
library(getopt)

opt=getopt(spec)

if ( is.null(opt$reprocess) ){ opt$reprocess = FALSE }

print(opt)

obkms = basic_triplestore_access(
  server_url = configuration$server_url,
  repository = configuration$repository,
  user = configuration$user,
  password = Sys.getenv("OBKMS")
)

get_protocol_version(obkms)
list_repositories(obkms)
