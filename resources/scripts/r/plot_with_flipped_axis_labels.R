## Adjust some graphical parameters.
par(mar = c(6.1, 4.1, 4.1, 4.1), # change the margins
    lwd = 1, # increase the line thickness
    cex.axis = 1.2 # increase default axis label size
)

dataset = results_t
## Draw boxplot with no axes.
boxplot(dataset[c(1,2,3),], xaxt = "n", xaxt = "n",
        ylab="p-value",
        main="completed")

## Draw x-axis without labels.
#axis(side = 1, labels = FALSE)

# ## Draw the x-axis labels.
# text(x = 1:length(colnames(dataset)),
#      ## Move labels to just below bottom of chart.
#      y = par("usr")[3]-0.05,
#      ## Use names from the data list.
#      labels = colnames(dataset),
#      ## Change the clipping region.
#      xpd = NA,
#      ## Rotate the labels by 35 degrees.
#      srt = 90,
#      ## Adjust the labels to almost 100% right-justified.
#      adj = 1,
#      ## Increase label size.
#    #  cex = 1.2,)
# )

#abline(h=0.05, lty=2, col="orange") ## p < 0.05
