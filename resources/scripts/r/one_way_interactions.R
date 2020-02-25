# need to change data set
dataset <- fossdroid31_flowdroid_2way_notimedout
dependent <- dataset$time
begin_column_independent <- 5
end_column_independent <- ncol(dataset) - 1
tests = list()
sort_by_p_val = FALSE

perform_test <- function(x, y) {
  if (class(y) == "integer" || class(y) == "numeric") {
    if (length(levels(x)) == 2) {
      return(list(wilcox.test(y~x)))
    } else {
      return(list(kruskal.test(y~x)))
    }
  } else {
    print(paste("DEBUG: y=", y, " x=", x))
      tbl <- table(y, x)
      return(list(chisq.test(tbl)))
  }
  return(l)
}

for (i in seq(begin_column_independent, end_column_independent)) {
  tests[names(dataset)[i]] <- perform_test(dataset[,i], dependent)
  if (sort_by_p_val) tests <- tests[order(sapply(tests, "[[", "p.value"))]
}

for (n in names(tests)) { print(paste(n, ",", tests[[n]]$p.value)) }