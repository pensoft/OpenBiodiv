configuration_file = "/openbiodiv/etc/config_opendata.yml"
server_access_options = yaml::yaml.load_file( configuration_file )
server_access_options$userpwd = Sys.getenv("OBKMS_SECRET")
init_env(server_access_options, prefix_db = paste0( path.package ( 'obkms' ) , "/", "prefix_db_opendata.yml" ))
procurement_data = read.csv("/opendata/case_opendatabg/data/2016/contracts_fhalf2016_clear.csv", encoding = "UTF-8", stringsAsFactors = FALSE)

names(procurement_data) = c( "", "documentId",
                          "procurementDate",
                          "documentType",
                          "procurementId",
                          "principleId",
                          "principleUac",
                          "principleName",
                          "procurementObjective",
                          "procurementType",
                          "underEuTreshold",
                          "EuFinancing",
                          "financialComments",
                          "participants",
                          "contractObjective",
                          "contractId",
                          "contractDate",
                          "contractorId",
                          "contractorUac",
                          "contractorName",
                          "currencyValue",
                          "currency")

procurement_data$procurementDate = as.Date(procurement_data$procurementDate, format = "%m/%d/%Y" )
procurement_data$procurementDate = gsub("-", "/", procurement_data$procurementDate)
procurement_data$contractDate = as.Date(procurement_data$contractDate, format = "%m/%d/%Y" )
procurement_data$contractDate = gsub("-", "/", procurement_data$contractDate)

# TODO: dates in Bulgarian format
reify_procurement = function( proc_row ) {
  if ( proc_row$procurementId != "") {
    proc_uri = paste0 (":Procurement_", proc_row$procurementId)
  }
  else {
    proc_uri = NULL
    return (NULL)
  }
  if ( proc_row$principleUac != "" ) {
    principle_uri = paste0 (":Company_", proc_row$principleUac)
  }
  else {
    principle_uri = NULL
  }
  if ( proc_row$contractorUac != "") {
    contractor_uri = paste0 (":Company_", proc_row$contractorUac)
  }
  else {
    contractor_uri = NULL
  }
  triples = list ( triple2( proc_uri, "a", ":GovernmentProcurement" ),
                   triple2( proc_uri, ":principle", principle_uri),
                   triple2( proc_uri, ":contractor", contractor_uri),
                   triple2( proc_uri, ":documentId", squote( proc_row$documentId) ),
                   triple2( proc_uri, "procurementDate", squote( proc_row$'dc:date', '^^xsd:date' ) ),
                   triple2( proc_uri, ":documentType", squote( proc_row$documentType) ) ,
                   triple2( proc_uri, ":procurementId", squote( proc_row$procurementId) ) ,
                   triple2( proc_uri, ":principleId", squote( proc_row$principleId) ),
                   triple2( proc_uri, ":principleUac", squote( proc_row$principleUac) ),
                   triple2( proc_uri, ":principleName", squote( proc_row$principleName) ) ,
                   triple2( proc_uri, ":procurementObjective", squote( proc_row$procurementObjective) ),
                   triple2( proc_uri, ":procurementType", squote( proc_row$procurementType) ),
                   triple2( proc_uri, ":underEuTreshold", squote( proc_row$underEuTreshold) ),
                   triple2( proc_uri, ":EuFinancing",squote( proc_row$EuFinancing) ),
                   triple2( proc_uri, ":financialComments", squote( proc_row$financialComments) ),
                   triple2( proc_uri, ":participants", squote( proc_row$participants) ) ,
                   triple2( proc_uri, ":contractObjective", squote( proc_row$contractObjective) ),
                   triple2( proc_uri, ":contractId", squote( proc_row$contractId) ),
                   triple2( proc_uri, ":contractDate", squote( proc_row$contractDate, '^^xsd:date' ) )  ,
                   triple2( proc_uri, ":contractorId", squote( proc_row$contractorId) ) ,
                   triple2( proc_uri, ":contractorUac", squote( proc_row$contractorUac) ) ,
                   triple2( proc_uri, ":contractorName", squote( proc_row$contractorName) ),
                   triple2( proc_uri, ":currencyValue", squote( proc_row$currencyValue) ),
                   triple2( proc_uri, ":currency", squote( proc_row$currency) ) )
  triples = rlist::list.clean( triples )
  return (triples)
}

triples = list()
serialization = character()
for ( i in 1: 2 ) {
  serialization = character()
  triples = c( triples, reify_procurement( procurement_data[i , ] ) )
  serialization = c ( "@prefix : <http://datathon.com#> .",
                      turtle_prepend_prefixes(),
                      triples2turtle2 ( ":Procurement", triples ), "\n\n" )
  r = rdf4jr::add_data(server_access_options, server_access_options$repository,
                       do.call(paste, as.list( serialization )))
  cat(httr::content(r))
}


