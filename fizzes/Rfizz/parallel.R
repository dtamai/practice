library("foreach")
library("doMC")

registerDoMC()

FB.MAP <- data.frame(
                     key=  c(0,          3,      5,      6,      9,      10,     12),
                     value=c("FizzBuzz", "Fizz", "Buzz", "Fizz", "Fizz", "Buzz", "Fizz"),
                     stringsAsFactors=FALSE)

map.fizzbuzz <- function(numbers) {
  foreach(n=numbers, .combine=c, .inorder=TRUE) %do% {
    m <- n %% 15
    ifelse(length(which(FB.MAP$key==m)) > 0,
           FB.MAP[FB.MAP$key==m, ]$value,
           n)
  }
}

parallel <- function() {
  part.size <- 10
  nparts <- seq(from=0, length.out=10)

  foreach(i=nparts, .combine=c) %dopar% {
    min <- i*part.size + 1
    max <- min + part.size - 1
    part <- min:max
    map.fizzbuzz(part)
  }
}
