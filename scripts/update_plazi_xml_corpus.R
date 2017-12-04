# Update the Plazi XML Corpus

# This gets everyfile in puts in the plazi-corpus.xml directory
plazi_corpus_dir = "/media/obkms/plazi-corpus2.xml"
plazi_info = plazi_treatment_info()
new_files = get_plazi_treatments(as.character(plazi_info$link), dir = plazi_corpus_dir)
