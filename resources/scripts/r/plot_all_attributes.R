## Plot all of the features

library(reshape2)
library(ggplot2)
library(scales)

#fossdroid <- flowdroid_fossdroid_2way[flowdroid_fossdroid_2way$completed==TRUE,]
fossdroid <- flowdroid_fossdroid_2way[flowdroid_fossdroid_2way$time<7200000,]
droidbench <- droidbench_data[droidbench_data$completed==TRUE,]
googleplay <- flowdroid_googleplay_2way[flowdroid_googleplay_2way$completed==TRUE,]
# 
# fossdroid <- fossdroid[fossdroid$num_flows>0,]
# droidbench <- droidbench[droidbench$num_flows>0,]
# googleplay <- googleplay[googleplay$num_flows>0,]

datasets = list(list(fossdroid, "fossdroid"))

features = rownames(results)
plots = list()

characteristic = 'precision'
for (f in features) {
  a = data.frame()
  for (d in datasets) {
    # get the relevant data using melt
    ag <- melt(d[1], id.vars=c(f), measure.vars=c(characteristic),
               variable.name="characteristic",
               value.name=characteristic)
    # add the benchmark name as an attribute
    ag$benchmark <- rep(c(paste(d[2])), nrow(ag))
    a <- rbind(a, ag)
  }
  # now, a should be one table with all of the data from the feature
  # so, let's plot it
  a[[f]] <- as.factor(a[[f]])
  a[[characteristic]] <- a[[characteristic]] + 1
  p <- ggplot(a, aes_string(x=f, y=characteristic, fill="benchmark")) +
    geom_boxplot() +
    theme(axis.text.y = element_blank()) + 
    theme(axis.text.x = element_blank()) +
    theme(axis.ticks.x = element_blank()) +
    theme(axis.ticks.y = element_blank()) +
    theme(axis.title.y = element_blank()) +
    theme(legend.position = 'none') +
    scale_y_continuous(trans='log10')
  
  plots[[f]] <- p
}

require(gridExtra)
do.call("grid.arrange", c(plots, nrow=5, ncol=5))

