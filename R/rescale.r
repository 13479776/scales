#' Rescale numeric vector to have specified minimum and maximum.
#'
#' @param x data to rescale
#' @param to range to scale to
#' @param from range to scale from, defaults to range of data
#' @param clip should values be clipped to specified range?
#' @keywords manip
rescale <- function(x, to=c(0,1), from=range(x, na.rm=TRUE), clip = TRUE) {
  # If to range is (FP) 0, use that point
  if (length(to) == 1 || isTRUE(all.equal(to[1], to[2]))) {
    return(rep(to[1], length(x))
  }
  # If from range is (FP) 0, use middle of to range
  if (length(from) == 1 || isTRUE(all.equal(from[1], from[2]))) {
    return(rep(mean(to), length(x)))
  } 

  if (is.factor(x)) {
    warning("Categorical variable automatically converted to continuous", call.=FALSE)
    x <- as.numeric(x)
  }
  scaled <- (x - from[1]) / diff(from) * diff(to) + to[1]

  if (clip) {
    ifelse(!is.finite(scaled) | scaled %inside% to, scaled, NA) 
  } else {
    scaled
  }
}

"%inside%" <- function(x, interval) {
  x >= interval[1] & x <= interval[2]
}

# Trim non-finite numbers to specified range
trim_infinite <- function(x, range = c(0, 1)) {
  x[x == -Inf] <- range[1]
  x[x == Inf] <- range[2]
  x
}
