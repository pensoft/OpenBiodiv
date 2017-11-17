#' Update Script For Pensoft XML Corpus
#'
#'


#' settings
 library(foreach)
pensoft_xml_corpus_dir = "/media/obkms/pensoft-corpus.xml"
endpoints = c(BDJ = "http://bdj.pensoft.net/lib/journal_archive.php?journal=bdj",
              ZooKeys = "http://zookeys.pensoft.net/lib/journal_archive.php?journal=zookeys",
              PhytoKeys = "http://phytokeys.pensoft.net/lib/journal_archive.php?journal=phytokeys")

#' determine latest article's date
corpus_files = list.files(pensoft_xml_corpus_dir, full.names = TRUE)
corpus_datestring = sapply(corpus_files, article_publication_date.filename)
corpus_dates = as.Date(corpus_datestring)
max_date = max(corpus_dates, na.rm = TRUE)

#' download new articles

zip_raw_data = lapply(endpoints, new_pensoft_articles, fromdate = max_date + 1)

new_articles = foreach (journal = names(zip_raw_data), zip = zip_raw_data) %do% {
  new_articles_zipfile = paste0(pensoft_xml_corpus_dir, "/new-", journal, "-from-", format.Date(max_date + 1), ".zip")
  writeBin(zip, new_articles_zipfile)
  new_articles = unzip(new_articles_zipfile, exdir = pensoft_xml_corpus_dir)
  file.remove(new_articles_zipfile)
  return(new_articles)
}
