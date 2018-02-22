# Update the Plazi XML Corpus
library(ropenbio)
plazi_corpus_dir = "/media/obkms/plazi-corpus-xml"
plazi_corpus_dir_image = "/media/obkms/plazi-corpus-image"
logdir = "/media/obkms/log"

# Fetch the feed
todays_plazi_feed = plazi_feed()

# Create a data.frame from the feed
treatments = as.data.frame(todays_plazi_feed)

# Create an aria2 unput file for what's missing
aria_input_lines = generate_aria2c_input(treatments$id, corpus_dir = plazi_corpus_dir)

# Write the file to a temporary location
ctime = format(Sys.time(), "%y%m%d%H%M")
input_file = paste0(logdir, "/download-", ctime, ".input")
writeLines(aria_input_lines, input_file)
log_file = paste0(logdir, "/download-", ctime, ".log")
command = paste0('aria2c ', '--input-file=', input_file, " --log=", log_file, ' --split=16 ', '--dir=', plazi_corpus_dir)

# Execute
system(command)

# Get Treatment languages
treatments$lang = treatment_language(treatments$id, directory = plazi_corpus_dir)

# Write the datafrane to the log
write.table(treatments, file = paste0(logdir, "/treatments-", ctime, ".csv"))


# Images
aria_input_lines_image = generate_aria2c_input_images(plazi_images(treatments$id, directory = plazi_corpus_dir))

# Write
input_file_image = paste0(logdir, "/download-images-", ctime, ".input")
writeLines(aria_input_lines_image, input_file_image)
log_file_image = paste0(logdir, "/download-images", ctime, ".log")
command = paste0('aria2c ', '--input-file=', input_file_image, " --log=", log_file_image, ' --split=16 ', '--dir=', plazi_corpus_dir_image)


# Text Corpus
