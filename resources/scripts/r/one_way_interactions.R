# need to change data set
attach(output_flowdroid_twoway_db30)

dataset <- output_flowdroid_twoway_db30
dependent <- dataset$timedout
begin_column_independent <- 13
end_column_independent <- ncol(dataset) - 1
tests = list()

perform_test <- function(x, y) {
  if (class(y) == "integer" || class(y) == "numeric") {
    if (length(levels(x)) == 2) {
      return(list(wilcox.test(y~x)))
    } else {
      return(list(kruskal.test(y~x)))
    }
  } else {
      tbl <- table(y, x)
      return(list(chisq.test(tbl)))
  }
  return(l)
}

for (i in seq(begin_column_independent, end_column_independent)) {
  tests[names(dataset)[i]] <- perform_test(dataset[,i], dependent)
  tests <- tests[order(sapply(tests, "[[", "p.value"))]
}
