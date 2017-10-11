snapshot_tape <- function(expr, tape, method = httr::GET) {
    record(expr = expr, method = method, callback = identity, file = tape, snapshot = TRUE)
}

play_tape <- function(expr, tape, method = httr::GET) {
    testthat::with_mock(`httr::GET` = function(...) readRDS(paste0(tape, ".RDS")), expr) #TODO: method
}
