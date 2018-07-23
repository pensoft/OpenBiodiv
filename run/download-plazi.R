# Download new Plazi treatments as XML files.

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

todays_plazi_feed = plazi_feed()
plazi_info = as.data.frame(todays_plazi_feed)
aria_file_contents = generate_aria2c_input(plazi_info$id, corpus_dir = configuration$plazi_download)
aria_filename = paste0("/tmp/", uuid::UUIDgenerate(), ".aria2c")
writeLines(text = aria_file_contents, con = aria_filename)

aria_cmd = paste0("aria2c --input-file=", aria_filename)
print("New treatments have been identified and a download job has been created in")
print(aria_filename)
print("Downloading will commence with:")
print(aria_cmd)
print(paste("From directory", configuration$plazi_download))

# This doesn't work for some reason?
#setwd(configuration$plazi_download)
#system2(aria_cmd)
#sh: 1: aria2c --input-file=/tmp/9ce796de-e6d1-49e4-b84d-843e4bb8ef3a.aria2c: not found
