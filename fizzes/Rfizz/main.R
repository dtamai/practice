library("plyr")
library("dplyr")

limit <- 100

source("answer.R")
source("cyclic.R")
source("parallel.R")

cy <- cyclic()
print(paste("Cyclic: ", check.answer(cy)))

pa <- parallel()
print(paste("Parallel: ", check.answer(pa)))
