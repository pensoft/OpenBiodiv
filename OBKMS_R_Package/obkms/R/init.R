#' Initialize package parameters upon loading.
#'
#' The package contains a database of prefixes, stored in YML. The prefixes are
#' stored in a database  the `inst/` folder.
#'
.onLoad = function (libname, pkgname) {

  assign("db_prefix", "prefix_db.yml", envir = parent.env( environment() ) )

}
