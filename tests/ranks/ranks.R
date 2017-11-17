# searches for special types of taxonomic name usages in ZooKeys and in BDJ

bdj = "/media/obkms/XML/BDJ"
zookeys = "/media/obkms/XML/zookeys"
phytokeys = "/media/obkms/XML/phytokeys"

bdj.articles = paste0( bdj, "/", list.files( bdj ) )
zookeys.articles =   paste0(zookeys, "/", list.files( zookeys ) )
phytokeys.articles = paste0(phytokeys, "/", list.files( phytokeys ) )

length( bdj.articles )
length( zookeys.articles )
length( phytokeys.articles )

length( bdj.articles ) +  length( zookeys.articles ) +length( phytokeys.articles )

extract_taxon_status = function ( article ) {
  xml = xml2::read_xml( article )
  taxon_status =  xml2::xml_text( xml2::xml_find_all( xml, ".//tp:taxon-name-part/@taxon-name-part-type" ) )
  return ( taxon_status )
}

bdj.statuses = sapply ( bdj.articles, extract_taxon_status )
zookeys.statuses = sapply ( zookeys.articles, extract_taxon_status )
phytokeys.statuses = sapply ( phytokeys.articles, extract_taxon_status )

all.factors = as.factor ( unlist ( c( bdj.statuses, zookeys.statuses, phytokeys.statuses ) ) )
statuses = levels(all.factors)

writeLines( statuses, "/home/viktor/Work/OBKMS/Ontology/taxonomic_statuses.txt")

gbif = "/media/obkms/GBIF_Backbone/Taxon.tsv"

backbone = read.delim(gbif)
