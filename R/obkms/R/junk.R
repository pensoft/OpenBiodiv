# subfunction to do a parallel grep
#' @export
pgrep = function ( cluster, pattern, x )
{
  which ( parSapply( cluster, x, function ( y, pattern ) {
    grepl( pattern, x = y )
  }, pattern = pattern) )
}
