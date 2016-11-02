## ---- purl=TRUE----------------------------------------------------------
library(xml2)
library(rdf4jr)

## ---- purl=TRUE----------------------------------------------------------
command_line_args = commandArgs(trailingOnly = TRUE)

## ---- purl=TRUE----------------------------------------------------------
stopifnot( length( command_line_args ) >= 2 )

## ---- purl=TRUE----------------------------------------------------------
configuration_file = command_line_args[ 1 ]
taxpubs = command_line_args[ 2:length( command_line_args ) ]
obkms_options = yaml::yaml.load_file( configuration_file )

## ---- purl=TRUE----------------------------------------------------------
obkms_options$userpwd = Sys.getenv("OBKMS_SECRET")

