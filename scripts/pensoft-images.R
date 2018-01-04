dir <- "/media/obkms/pensoft-corpus.xml/"
files <- list.files(path = dir, pattern = "BDJ", full.names = TRUE)
links <- unlist(sapply(files, function(f) {
  images = gsub("F", "", pensoft_images(f))
  elocs = gsub("e", "", pensoft_article_eloc(f))
  return(paste0(rep(x = "https://bdj.pensoft.net/article/", length(images)), rep(elocs, length(images)), rep(x = "/download/fig/", length(images)), images))
}))
writeLines(text = links, con = "~/tmp/bdj-imgs.txt")


https://bdj.pensoft.net/article/21715/download/fig/3809617/
