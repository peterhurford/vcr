record <- function(expr, method = httr::GET, file = "vcr.txt", snapshot = FALSE,
                   callback = function(r) capture.output(dput(r))) {
  original_method <- method
  verb <- strsplit(deparse(substitute(method)), "::")[[1]][[2]]
  stubbed_method <- function(..., vcr_callback = callback, vcr_file = file) {
    unlink(vcr_file)
    response <- original_method(...)
    if (isTRUE(snapshot)) {
      saveRDS(vcr_callback(response), paste0(vcr_file, ".RDS"))
    } else {
      cat(vcr_callback(response), file = vcr_file)
    }
    response
  }
  unlockBinding(getNamespace("httr"), sym = verb)
  assign(verb, stubbed_method, envir = getNamespace("httr"))
  response <- eval(expr)
  assign(verb, original_method, envir = getNamespace("httr"))
  response
}
