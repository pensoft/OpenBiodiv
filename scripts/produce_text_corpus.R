# Produce a Text Corpus

corpus_directory = c("/media/obkms/pensoft-corpus.xml")
corpus_files = list.files(corpus_directory)
plain_text_directory = c("/media/obkms/pensoft-corpus.txt")
names_file = c("taxonomic-names.txt")

names_con = file(paste(plain_text_directory, names_file, sep = "/"), open = "at")

for (test_file in corpus_files) {
  response = xml2nactem(paste(corpus_directory, test_file, sep = "/"), obkms$xpath$taxpub)
  writeLines(response$names, names_con)
  plain_txt_file_con = file(paste0(plain_text_directory, "/", strip_filename_extension(test_file), ".txt"), open = "at")
  cat(response$text, file = plain_txt_file_con)
  close(plain_txt_file_con)
}

close(names_con)
