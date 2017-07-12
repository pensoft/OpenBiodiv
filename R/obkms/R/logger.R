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
log_event = function( eventName,
                      callingFunction,
                      eventNotes = "",
                      eventType = c( "NOTE" ),
                      eventTime = Sys.time(),
                      eventContext = obkms$log$current_context )
{
  stopifnot( eventType %in% c('NOTE', 'WARNING', 'ERROR', 'DEBUG') )

  obkms$log$events[[ obkms$log$number_of_events + 1 ]] = data.frame(
    Time = eventTime, Type = eventType,Context = eventContext, Function = callingFunction , Name = eventName,
     Message = eventNotes)

  obkms$log$number_of_events = obkms$log$number_of_events + 1
}

#' @export
set_context = function ( context )
{
  obkms$log$current_context = context
}

#' Write an OBKMS Iteration Log
#'
#' This function both writes the log to a file and returns it as a data.frame
#'
#' @param toFile \emph{logical}: if this parameter is TRUE, then the log is
#'   written in a text-file
#' @param append \emph{logical}: if this parameter is TRUE the log will be
#'   appended to the file
#' @param iteration_name this string will be last part of the filename
#'
#' @return a data.frame with the log
#'
#' @export
write_log = function( toFile = FALSE, append = TRUE, iteration_name = "")
{
  value = do.call( rbind, obkms$log$events )
  if ( toFile ) {
    write.table( value,
                 file = paste0( obkms$initial_dump_configuration$initial_dump_directory,
                                iteration_name,
                                ".log" ),
                 append = append )
    }
  return( value )
}
