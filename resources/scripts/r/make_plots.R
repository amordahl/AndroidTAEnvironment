library(ggplot2)
library(gridExtra)
library(scales)

# Create boxplot
stacked_medians <- stack(median_across_all_tools)
p <- ggplot(stacked_medians, aes(x=ind, y=values, fill=ind)) + 
  geom_boxplot() + 
  theme(legend.position = "none") + 
  labs(x = "Tools", y = "DroidBench F-Measure") + 
  theme(text = element_text(size = 14)) + 
  theme(axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p

update_geom_defaults("point", list(size = 4))
update_geom_defaults("boxplot", list(outlier.size = 3))
# Create plots
data <- flowdroid_fossdroid_all
data$precision <- data$tp / (data$tp + data$fp)
data <- data[!is.nan(data$precision),]
data$time <- data$time / 1000 / 60 / 60
data$dataflowsolver <- gsub('CONTEXTFLOWSENSITIVE', 'CFS', data$dataflowsolver)
data$dataflowsolver <- gsub('FLOWINSENSITIVE', 'FI', data$dataflowsolver)
p1 <- ggplot(data, aes(x=pathalgo, y=precision)) + 
  geom_boxplot(outlier.size=2) +
  labs(x="setting", y="precision") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.text.x = element_text(margin=unit(c(3,0,0,0), 'mm')),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')),
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm'))) +
  guides(color = guide_legend(nrow = 2)) #+
  #scale_x_discrete(labels=c("CI","CS","SO"))
p2 <- ggplot(data, aes(x=time, y=precision)) + 
  geom_point(aes(color = dataflowsolver, shape=dataflowsolver)) +
  labs(x="total run time (hours)", y="precision") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.box = "vertical",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')),
        plot.margin = unit(c(0,5,0,0), "mm"))
p10 <- ggplot(data, aes(x=time, y=precision)) + 
  geom_jitter(width = 0.1, aes(color = enablereflection, shape=enablereflection)) +
  labs(x="total run time (hours)", y="precision") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.box = "vertical",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')),
        plot.margin = unit(c(0,5,0,0), "mm"))
p3 <- ggplot(data, aes(x=completed, y=time)) + 
  geom_jitter(width = 0.1, aes(color = nocallbacks, shape=nocallbacks)) +
  labs(x="number of completed APKs", y="total run time (hours)") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p41 <- ggplot(data, aes(x=onecomponentatatime, y=completed)) + 
  geom_boxplot(outlier.size = 2) +
  labs(x="settings", y="completed apps") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.text.x = element_text(margin=unit(c(3,0,0,0), 'mm')),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')),
        plot.margin = unit(c(5,5,5,5), 'mm'))
p42 <- ggplot(data, aes(x=onecomponentatatime, y=time)) + 
  geom_boxplot(outlier.size = 2) +
  labs(x="settings", y="total run time (hours)") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.text.x = element_text(margin=unit(c(3,0,0,0), 'mm')),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')),
        plot.margin = unit(c(5,5,5,5), 'mm'))
p5 <- ggplot(data, aes(x=completed, y=time)) + 
  geom_jitter(width = 0.1, aes(color = onesourceatatime, shape=onesourceatatime)) +
  labs(title="d) onesourceatatime", x="number of completed APKs", y="total run time (hours)") +
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p11 <- ggplot(data, aes(x=completed, y=time)) + 
  geom_jitter(aes(color = codeelimination, shape=codeelimination)) +
  labs(title="codeelimination", x="number of completed APKs", y="total run time (hours)") +
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
# droidsafe
data <- droidsafe_fossdroid_all
data$precision <- data$tp / (data$tp + data$fp)
data <- data[!is.nan(data$precision),]
data$time <- data$time / 1000 / 60 / 60
p6 <- ggplot(data, aes(x=kobjsens, y=precision)) + 
  geom_boxplot(aes(group=kobjsens), outlier.size = 2) +
  labs(x="setting", y="precision") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.text.x = element_text(margin=unit(c(3,0,0,0), 'mm')),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm'))) +
  scale_x_continuous(trans = 'log2')
p72 <- ggplot(data, aes(x=limitcontextforcomplex, y=time)) + 
  geom_boxplot()+
  labs(x="setting", y="total run time (hours)") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p71 <- ggplot(data, aes(x=limitcontextforcomplex, y=completed)) + 
  geom_boxplot()+
  labs(x="setting", y="number of completed APKs") +
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p8 <- ggplot(data, aes(x=nofallback, y=time)) + 
  geom_boxplot(aes(group=nofallback)) +
  labs(title="nofallback", x="nofallback setting", y="total run time (hours)") +
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p9 <- ggplot(data, aes(x=completed, y=time)) + 
  geom_jitter(width=0.1, aes(color=nova, shape=nova)) +
  labs(title="nova", x="number of completed APKs", y="total run time (hours)") + 
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p92 <- ggplot(data, aes(y=nova, x=time)) + 
  geom_boxplot()+
  labs(y="setting", x="total run time (hours)") +
  theme(plot.title = element_blank(),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
p91 <- ggplot(data, aes(y=nova, x=completed)) + 
  geom_boxplot()+
  labs(title="nova", y="setting", x="number of completed APKs") +
  theme(plot.title = element_text(hjust=0.5),
        text = element_text(size = 24),
        legend.text = element_text(size = 8, margin = unit(c(0,0,0,0), 'mm')), 
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(margin = unit(c(3,0,0,0), 'mm')), 
        axis.title.y = element_text(margin = unit(c(0,3,0,0),'mm')))
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol=3, nrow=3)