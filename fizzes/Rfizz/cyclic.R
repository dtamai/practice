
cyclic <- function() {
  seq.base <- as.character(seq(limit))
  seq.fizz <- rep(c(NA, NA, "Fizz"), len=limit)
  seq.buzz <- rep(c(NA, NA, NA, NA, "Buzz"), len=limit)

  df <- data.frame(base=seq.base, fizz=seq.fizz, buzz=seq.buzz, stringsAsFactors=FALSE)

  df <- cbind(df, mult = apply(df, 1, function(x) { length(na.omit(x)) }))
  df[is.na(df)] <- ""

  mutate(df, answer = ifelse(mult == 1,
                             base,
                             paste0(fizz, buzz)
                             )
  )$answer
}
