imported_files <- function(statistics_file, number_of_files)
{
  readLines(statistics_file)[4*1:number_of_files + 1]
}

seconds <- function(statistics_file, number_of_files)
{
  as.integer(gsub("s", "", (gsub("[0-9]+m", "", gsub("[0-9]+h", "", gsub("\\.", "", sapply(strsplit(readLines(statistics_file)[4*1:number_of_files + 2], "in "),
         function(list_elem) {
           list_elem[2]
         })))))))
}

minutes <- function(statistics_file, number_of_files)
{
  as.integer(gsub("m", "", (gsub("[0-9]+s", "", gsub("[0-9]+h", "", gsub("\\.", "", sapply(strsplit(readLines(statistics_file)[4*1:number_of_files + 2], "in "),
                                                                                           function(list_elem) {
                                                                                             list_elem[2]
                                                                                           })))))))
}

hours <- function(statistics_file, number_of_files)
{
  hh <- as.integer(gsub("h", "", (gsub("[0-9]+m", "", gsub("[0-9]+s", "", gsub("\\.", "", sapply(strsplit(readLines(statistics_file)[4*1:number_of_files + 2], "in "),
                                                                                           function(list_elem) {
                                                                                             list_elem[2]
                                                                                           })))))))
  hh[is.na(hh)] <- 0
  return(hh)
}


elapsed_time <- function(hours, minutes, seconds)
{
  hours*3600 + minutes*60 + seconds
}

png("performance-degradation.png")
plot(1:193*150, elapsed_time(hours("import-statistics.txt", 193), minutes("import-statistics.txt", 193), seconds("import-statistics.txt", 193)), xlab = "MBytes", ylab = "Time in seconds for the import of 150 MBytes")
title(main = "Performance degradation as a function of database size in MBytes")
dev.off()

png("performance-degradation-lite.png")
plot(1:193*150, elapsed_time(hours("import-statistics-lite.txt", 193), minutes("import-statistics.txt", 193), seconds("import-statistics.txt", 193)), xlab = "MBytes", ylab = "Time in seconds for the import of 150 MBytes")
title(main = "Performance degradation as a function of database size in MBytes")
dev.off()

png("performance-degradation-both.png")
plot(1:193*150, elapsed_time(hours("import-statistics.txt", 193), minutes("import-statistics.txt", 193), seconds("import-statistics.txt", 193)), xlab = "MBytes", ylab = "Time in seconds for the import of 150 MBytes", col = "red", pch = "+")
title(main = "Performance degradation as a function of database size in MBytes")
points(1:193*150, elapsed_time(hours("import-statistics-lite.txt", 193), minutes("import-statistics.txt", 193), seconds("import-statistics.txt", 193)), col = "green", pch = "x")
legend(100,17000, # places a legend at the appropriate place
       c("OWL2 RL","RDF-Plus Optimized"), # puts text in the legend
       pch = c("+", "x"),
       col=c("red","green")) # gives the legend lines the correct color and width
dev.off()
