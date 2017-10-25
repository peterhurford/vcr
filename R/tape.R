#' Snapshot a call to a tape.
#'
#' @param expr call. The expression to evaluate and record.
#' @param tape character. A path to the file to write.
#' @param method function. The function in httr to add recording to.
#' @export
snapshot_tape <- function(expr, tape, method = httr::GET) {
    record(expr = expr, method = method, callback = identity, file = tape, snapshot = TRUE)
}

#' Play back a recorded tape.
#'
#' @param expr call. The expression to evaluate with the recorded tape.
#' @param tape character. A path to the tape with data to play back.
#' @param method function. The function in httr to replace with the tape.
#' @export
play_tape <- function(expr, tape, method = httr::GET) {
    testthat::with_mock(`httr::GET` = function(...) readRDS(paste0(tape, ".RDS")), expr) #TODO: method
}
