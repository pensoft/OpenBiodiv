library(foreach)

# Produce a Text Corpus from Pensoft
corpus_files = (list.files("/media/obkms/pensoft-corpus.xml", full.names = TRUE))
plain_text_directory = c("/media/obkms/nactem/pensoft")
names_file = c("/media/obkms/nactem/pensoft-taxonomic-names.txt")

# TaxPub Markup
TNU_markup = "tp:taxon-name"
PTNU_markup = "tp:taxon-name-part"
regPTNU_markup = "./@reg"


produce_nactem_text_corpus_proc = function(corpus, plain_text_dir, names_file,  xmlschema, ...)
{
  for(test_file in corpus)
  {
    response = xml2nactem(test_file, xmlschema = xmlschema, ...)

    if (!is.error(response)) {
      names_con = file(names_file, open = "at")
      plain_txt_file_con = file(paste0(plain_text_dir, "/", strip_filename_extension(last_token(test_file, "/")), ".txt"), open = "at")
      cat(response$text, file = plain_txt_file_con)
      writeLines(unlist(response$names), names_con)
      close(plain_txt_file_con)
      close(names_con)
    }

    else {
      print(as.character(response))
    }
  }
}


produce_nactem_text_corpus_proc(xmlschema ="taxpub")

# Plazi

corpus_files = list.files("/media/obkms/plazi-corpus2.xml", full.names = TRUE)
TNU_markup = "tax:name"
PTNU_markup = NA
regPTNU_markup = NA
plain_text_directory = c("/media/obkms/nactem/plazi")
names_file = c("/media/obkms/nactem/plazi-taxonomic-names.txt")
statuses = character(length(corpus_files))

produce_nactem_text_corpus_proc(corpus = corpus_files, plain_text_dir = plain_text_directory, names_file = names_file, xmlschema = "taxonx", TNU_markup = TNU_markup, PTNU_markup = NA, regPTNU_markup = regPTNU_markup)
