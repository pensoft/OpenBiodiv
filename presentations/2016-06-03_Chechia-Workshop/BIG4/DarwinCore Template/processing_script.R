big4data = read.csv(file = "./BIG4_Template.csv")

# get rid of comas in the coordinate string
big4data$verbatimCoordinates = gsub(",", "", as.character(big4data$verbatimCoordinates))

# separate latitude from longitude
decimalLatitude =  unlist(strsplit(as.character(big4data$verbatimCoordinates), " ")) [2*(1:length(big4data$verbatimCoordinates))-1]
decimalLongitude = unlist(strsplit(as.character(big4data$verbatimCoordinates), " ")) [2*(1:length(big4data$verbatimCoordinates))]

#which strings still have "°" in them > they need to be replaced
degrees = grep("°", decimalLatitude)
dmsList = (sapply(decimalLatitude[degrees], char2dms, chd = "°", chm="'"))
decimals = sapply(dmsList, as.numeric)
decimalLatitude[degrees] = decimals

# get rid of remaining letters and assign back
big4data$decimalLatitude = gsub("N", "", decimalLatitude)

# do the same for longitude (WARNING NOT DRY!!!!!!!!)
degrees = grep("°", decimalLongitude)
dmsList = (sapply(decimalLongitude[degrees], char2dms, chd = "°", chm="'"))
decimals = sapply(dmsList, as.numeric)
decimalLongitude[degrees] = decimals

# get rid of remaining letters and assign back
big4data$decimalLongitude= gsub("E", "", decimalLongitude)

# remove 'sp' where specific epithet
big4data$specificEpithet

# counts per order

for (order in levels(big4data$order)){
  print(order)
  print(sum(big4data$individualCount[big4data$order == order]))
}

# distincts 




