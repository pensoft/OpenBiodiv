#' ---
#' title: "Downloader for BDJ TaxPub XML"
#' author: "Viktor Senderov"
#' ---

#' ## Libraries

library(RCurl)
library(XML)

#' ## Code
#' This script uses the RSS feed of BDJ to download the XML of
#' the papers from it. The address of the RSS feed is

bdjRssFeed = "http://bdj.pensoft.net/rss.php"

#' We will be putting the XML's in the following folder

targetDir = "BdjTaxpub/"

#' We need to use `RCurl` to download the RSS feed as an XML file:

rssXml = getURL(bdjRssFeed)

#' We need to use the `XML` package to parse this character
#' vector into a XML structure:

doc = xmlParse(rssXml)

#' We can now use the different functions from the `XML` package to
#' extract the XML elements that we need. A textual description (in HTML)
#' containing the address of the TaxPub
#' of each article is to be found under the following XPATH:

descriptionXPath = "//channel/item/description"

#' We extract a list of description items using:

descriptions = xpathSApply(doc, descriptionXPath, xmlValue)

#' Since the description is an incomplete HTML document
#' (HTML code chunk), we use the
#' `htmlTreeParse` on each description to create a list of parsed
#' descriptions.

parsedDescriptions = lapply(descriptions, htmlTreeParse)

#' The HTML document is under `$children$html`. The URL of the TaxPub
#' XML is found in the `href` attribute in the `a` element of
#' the 6-th paragraph in the HTML document.
#' *Note:* this does not work always, as the TaxPub is not always the
#' 6-th paragraph. A better way to match this would be the paragraph
#' which has "XML" in the text.

taxPubUrls = sapply(parsedDescriptions, function ( pd ) {
  ns = getNodeSet(pd$children$html, "//body/p[6]/a")
  attrs = xmlAttrs(ns[[1]])
  return( attrs["href"] )
})

#' We now have the URL's of the documents we want to download. The 
#' next step is to download them in the target direcory. Again,
#' we will use the `getURL` function. To names of the files will be
#' of the form `item_id.xml`, where `item_id` is read from the GET-style
#' URL argument.

writeFiles = function(taxPubUrls, targetDir) {
  for (url in taxPubUrls) {
    print(url)
    # to extract the name of the file
    filename = paste( strsplit(url, "=")[[1]][3], ".xml", sep = "" )
    doc = getURL(url)
    writeLines( doc, paste( targetDir, filename, sep = "" ) )
    print(paste( "Saving", filename ) )
  }
}

writeFiles(taxPubUrls, targetDir)
