#' A callback for writing the output as JSON content.
#'
#' @param r. The raw response from the httr call.
#' @export
write_json_callback <- function(r) {
  httr::content(r, as = "text", encoding = "UTF-8")
}
