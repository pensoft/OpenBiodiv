library(tm)
library(tidytext)
txt <- "/media/obkms/nactem/pensoft/"

# Corpus preparation
pensoft <- VCorpus(DirSource(txt, encoding = "UTF-8"), readerControl = list(language = "eng")) # reads a volatile (persists until object is there) corpus
pensoft <- tm_map(pensoft, FUN = stripWhitespace) # removes whitespace
pensoft <- tm_map(pensoft, FUN = content_transformer(FUN = tolower)) # converts to lower case
pensoft <- tm_map(pensoft, FUN = removeWords, words = stopwords("english")) # removes stopwords
pensoft <- tm_map(pensoft, FUN = stemDocument) # stemming (takes time)

inspect(pensoft[[1]])

# Document-term matrix

dtm <- DocumentTermMatrix(pensoft) # takes time

# Latent Dirichlet Allocation (model fitting stage)

pen_lda <- LDA(dtm, k = 2, control = list(seed = 1234)) # 2 topics, takes lots of time
