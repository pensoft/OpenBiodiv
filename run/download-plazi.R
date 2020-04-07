library(rdf4r)
library(ropenbio)

configuration = yaml::yaml.load_file("/home/backend/OpenBiodiv/local/deployment.yml")

#setting the working dir
setwd(configuration$plazi_download)
obkms = basic_triplestore_access(
  server_url = configuration$server_url,
  repository = configuration$repository,
  user = configuration$user,
  password = configuration$password
)

obkms$prefix = c(openbiodiv = "http://openbiodiv.net/")

todays_plazi_feed = plazi_feed()
plazi_info = as.data.frame(todays_plazi_feed)

#what is the last file which was saved?
last_plazi_file = read.table("/opt/data/obkms/last_plazi_file.txt")
last_plazi_file = as.character(last_plazi_file$V1)
last_row_of_df = row.names(plazi_info)[which(plazi_info$id==last_plazi_file)]
last_row_of_df = as.numeric(last_row_of_df)
#subset the plazi data frame to include xmls from most recent to last file which was downloaded to file system - 1
plazi_info = plazi_info[1:last_row_of_df-1,]
new_last_file = plazi_info[1,]$id

aria_file_contents = generate_aria2c_input(plazi_info$id, corpus_dir = configuration$plazi_download)
aria_filename = paste0("/tmp/", "plazi-download-missing-xml", ".aria2c")
writeLines(text = aria_file_contents, con = aria_filename)

aria_cmd = paste0("aria2c --input-file=", aria_filename)
print("New treatments have been identified and a download job has been created in")
print(aria_filename)
print("Downloading will commence with:")
print(aria_cmd)
print(paste("From directory", configuration$plazi_download))


# This doesn't work for some reason?
#setwd(configuration$plazi_download)
system(aria_cmd)
#write back to file which is the last downloaded xml
cat(new_last_file, file="/opt/data/obkms/last_plazi_file.txt")
