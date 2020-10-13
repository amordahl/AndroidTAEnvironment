## This file contains the code to plot the p-values
## for the tests produced by one-way-interactions.

## Assumes the existence of a dataset, results_t, which is the transpose of
## results that is obtained by adding columns for each p-value test in one_way_interactions


library(reshape2)
library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)
library(ggpubr)

dataset <- results_t

googleplay <- c(1,2,3)
fossdroid <- c(4,5,6)
droidbench <-c(7,8,10)
completed <- c(1,4,7)
num_flows <- c(2,5,10)
time <- c(3,6,8)

plots <- list()

results_completed <- dataset[completed,]
results_completed <- melt(results_completed)
colnames(results_completed) <- c('feature', 'pval')
results_completed$benchmark <- rep(c('googleplay', 'fossdroid', 'droidbench'),21)
p1 <- ggplot(results_completed, aes(x=feature, y=pval, fill=benchmark)) +
  geom_bar(stat='identity',position=position_dodge()) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none") + xlab("completed") +
  geom_abline(intercept=0.05, slope=0)

results_time <- dataset[time,]
results_time <- melt(results_time)
colnames(results_time) <- c('feature', 'pval')
results_time$benchmark <- rep(c('googleplay', 'fossdroid', 'droidbench'),21)
p2 <- ggplot(results_time, aes(x=feature, y=pval, fill=benchmark)) +
  geom_bar(stat='identity',position=position_dodge()) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none") + xlab("time") +
  geom_abline(intercept=0.05, slope=0)


results_num_flows <- dataset[num_flows,]
results_num_flows <- melt(results_num_flows)
colnames(results_num_flows) <- c('feature', 'pval')
results_num_flows$benchmark <- rep(c('googleplay', 'fossdroid', 'droidbench'),21)
p3 <- ggplot(results_num_flows, aes(x=feature, y=pval, fill=benchmark)) +
  geom_bar(stat='identity',position=position_dodge()) +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position="none") + xlab("num_flows") +
  geom_abline(intercept=0.05, slope=0)


ggarrange(p1, p2, p3, ncol=2, nrow=2, common.legend=TRUE)
# 
# results_googleplay <- dataset[googleplay,]
# results_googleplay <- melt(results_googleplay)
# colnames(results_googleplay) <- c('feature', 'pval')
# results_googleplay$characteristic <- rep(c('completed', 'num_flows', 'time'),21)
# p1 <- ggplot(results_googleplay, aes(x=feature, y=pval, fill=characteristic)) + 
#   geom_bar(stat='identity',position=position_dodge()) +
#   theme(axis.ticks.x = element_blank(),
#         axis.text.x = element_blank(),
#         legend.position = "none") + xlab("googleplay")  +
#         geom_abline(intercept=0.05, slope=0)
# 
# results_fossdroid <- dataset[fossdroid,]
# results_fossdroid <- melt(results_fossdroid)
# colnames(results_fossdroid) <- c('feature', 'pval')
# results_fossdroid$characteristic <- rep(c('completed', 'num_flows', 'time'),21)
# p2 <- ggplot(results_fossdroid, aes(x=feature, y=pval, fill=characteristic)) + 
#   geom_bar(stat='identity',position=position_dodge()) +
#   theme(axis.ticks.x = element_blank(),
#         axis.text.x = element_blank(),
#         legend.position = "none") + xlab("fossdroid") +
#         geom_abline(intercept=0.05, slope=0)
# 
# 
# results_droidbench <- dataset[droidbench,]
# results_droidbench <- melt(results_droidbench)
# colnames(results_droidbench) <- c('feature', 'pval')
# results_droidbench$characteristic <- rep(c('completed', 'time', 'num_flows'),21)
# p3 <- ggplot(results_droidbench, aes(x=feature, y=pval, fill=characteristic)) + 
#   geom_bar(stat='identity',position=position_dodge()) +
#   theme(axis.ticks.x = element_blank(),
#         axis.text.x = element_blank(),
#         legend.position = "none") + xlab("droidbench") +
#         geom_abline(intercept=0.05, slope=0)
# 
# 
# ggarrange(p1, p2, p3, ncol=2, nrow=2, common.legend=TRUE)
# 
