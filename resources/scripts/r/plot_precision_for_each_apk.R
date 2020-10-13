fossdroid <- droidsafe_twoway[droidsafe_twoway$time<7200000,]

plots = list()
for (a in levels(fossdroid$apk)) {
  p <- ggplot(fossdroid[fossdroid$apk==a,], aes(x=config_number, precision)) +
    geom_point() + xlab(a)
  plots[[a]] <- p
}

require(gridExtra)
do.call("grid.arrange", c(plots, nrow=6, ncol=6))