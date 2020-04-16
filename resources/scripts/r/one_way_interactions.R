# parameters to change
datasets <- list(list(droidbench_data[droidbench_data$completed & droidbench_data$total_apk_flows>0,], 'droidbench'),
                 list(flowdroid_fossdroid_2way[flowdroid_fossdroid_2way$completed & flowdroid_fossdroid_2way$total_apk_flows>0,], 'fossdroid'),
                 list(flowdroid_googleplay_2way[flowdroid_googleplay_2way$completed & flowdroid_googleplay_2way$total_apk_flows>0,], 'googleplay'))

datasets <- list(list(droidbench_data[droidbench_data$completed,], "droidbench"))
dependent <- 'apk_precision' # target variable
tests = list()
sort_by_p_val = FALSE
do_all_pairs = FALSE

flowdroid_features <- c('aliasalgo', 'aplength', 'callbackanalyzer', 'codeelimination', 'cgalgo',
                        'dataflowsolver', 'implicit', 'maxcallbackspercomponent', 'maxcallbacksdepth',
                        'pathalgo', 'staticmode', 'taintwrapper', 'aliasflowins', 'nocallbacks',
                        'noexceptions', 'nothischainreduction', 'onesourceatatime', 'onecomponentatatime',
                        'pathspecificresults', 'enablereflection', 'singlejoinpointabstraction')

# # redefine for the subset of features that appears in the single-conf results
# flowdroid_features <- c('aliasalgo', 'aplength', 'callbackanalyzer', 'codeelimination', 'cgalgo',
#                         'dataflowsolver', 'implicit', 'maxcallbackspercomponent', 'maxcallbacksdepth',
#                         'pathalgo', 'staticmode', 'taintwrapper', 'aliasflowins', 'nocallbacks',
#                         'noexceptions', 'enablereflection', 'singlejoinpointabstraction')

features <- flowdroid_features
perform_test <- function(x, y) {
  # if y is all one class, return -1
  if (length(unique(y)) == 1) {
    r <- list()
    r[["p.value"]] = -1
    return(r)
  }
  if (length(unique(x)) == 1) {
    r <- list()
    r[["p.value"]] = -1
    return(r)
  }
  else if (class(y) == "integer" || class(y) == "numeric") {
    if (length(levels(x)) == 2) {
      return(wilcox.test(y~x))
    } else {
      return(kruskal.test(y~x))
    }
  } else {
      tbl <- table(y, x)
      return(chisq.test(tbl))
  }
}


run_tests <- function(ds, fs) {
  results <- NULL
for (d in ds) {
  tests <- list()
  for (i in fs) {
    fac = as.factor(d[[1]][[i]])
    if (length(levels(fac)) > 2 && do_all_pairs) {
      # get all pairs
      pairs = combn(levels(fac), 2, simplify = FALSE)
      for (p in pairs) {
        fd <- d[[1]][d[[1]][[i]] == p[1] | d[[1]][[i]] == p[2],]
        # perform test
        tests[[paste(i, p[1], p[2], sep="_")]] <- perform_test(fd[[i]], fd[[dependent]])
      }
    }
    else {
      tests[[i]] <- perform_test(d[[1]][[i]], d[[1]][[dependent]])
    }
  }
  if (is.null(results)) {
    results <- data.frame(row.names = names(tests))
  }
  results[[ d[[2]] ]] <- unlist(lapply(tests, `[`, "p.value"))
}
  return(results)
}

results <- run_tests(datasets, features)
# for (n in names(tests)) { print(paste(n, ",", tests[[n]]$p.value)) }