#' Record an httr method.
#'
#' @param expr call. The expression to evaluate and record.
#' @param method function. The function in httr to run recording for.
#' @param file character. A path to the file where the recording should be written.
#' @param snapshot logical. If snapshot is true, an RDS tape of the response will be written.
#' @param callback function. A function to process the response prior to recording to a file.
#' @examples
#' \dontrun{
#'     # Record the JSON from an API call
#'     record(mypackage::MyAPICall(), callback = function(r) jsonlite::toJSON(httr::content(r), pretty = TRUE))
#' }
#' @export
record <- function(expr, method = httr::GET, file = "vcr.txt", snapshot = FALSE,
                   callback = function(r) capture.output(dput(r))) {
  original_method <- method
  verb <- strsplit(deparse(substitute(method)), "::")[[1]][[2]]

  stubbed_method <- function(..., vcr_callback = callback, vcr_file = file, is_snapshot = snapshot) {

    # Sometimes the stubbed HTTR method never gets unassigned...
    if (!("callback" %in% ls(parent.frame()))) {
      stop("VCR has entered a stuck state. Please restart your R session.")
    }

    unlink(vcr_file)
    response <- original_method(...)
    if (isTRUE(is_snapshot)) {
      saveRDS(vcr_callback(response), vcr_file)
    } else {
      cat(vcr_callback(response), file = vcr_file)
      cat("\n", file = vcr_file, append = TRUE)
    }
    response
  }
  unlockBinding(getNamespace("httr"), sym = verb)
  assign(verb, stubbed_method, envir = getNamespace("httr"))
  response <- eval(expr)

  # TODO: on.exit to ensure it happens?
  assign(verb, original_method, envir = getNamespace("httr"))

  response
}
