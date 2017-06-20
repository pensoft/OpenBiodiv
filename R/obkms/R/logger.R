#' OBKMS Internal Logging Function
#'
#' Args:
#'   @param message    the event message, i.e. what is going on
#'   @param ctime      current time, defaults to `Sys.time()`
#'   @param event_type type of event, one of
#'                       `c('NOTE', 'WARNING', 'ERROR', 'DEBUG')`
#'   @param context    the context in which the event is logged. For example it
#'                     could be the name of the function, or the name of the
#'                     workflow that is being run. Defaults to the current
#'                     context as found in `obkms$log$current_context`
#'
#' @return does not return anything, only sets the `log` list in the `OBKMS`
#'   environment
#'
#' @export
log_event = function( message, ctime = Sys.time(),
                      event_type = c( 'NOTE' ),
                      context = obkms$log$current_context )
{
  stopifnot( event_type %in% c('NOTE', 'WARNING', 'ERROR', 'DEBUG') )

  obkms$log$events[[ obkms$log$number_of_events + 1 ]] = data.frame(
    Time = ctime, Type = event_type, Context = context, Message = message)

  obkms$log$number_of_events = obkms$log$number_of_events + 1
}

#' @export
set_context = function ( context )
{
  obkms$log$current_context = context
}

#' Write the OBKMS to log to a file
#'
#' Args:
#'   @param toFile if this parameter is TRUE, then the log is also appended
#'                 to a text file
#'
#' @return the dataframe of the log
#'
#' @export
write_log = function( toFile = FALSE )
{
  value = do.call( rbind, obkms$log$events )
  if ( toFile ) {
    write.table( x,
                 file = paste0( obkms$initial_dump_configuration$initial_dump_directory, "/log.txt" ),
                 append = TRUE )
    }
  return( value )
}
