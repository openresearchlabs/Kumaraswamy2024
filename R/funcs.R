read_data <- function (f) {

  x <- read_excel(f)
  rownams <- unname(unlist(x[,1]))
  x <- x[, -1]
  x <- as.matrix(x)
  rownames(x) <- rownams
  x
  
}