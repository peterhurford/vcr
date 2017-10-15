write_json <- function(r) {
  httr::content(r, as = "text", encoding = "UTF-8")
}
