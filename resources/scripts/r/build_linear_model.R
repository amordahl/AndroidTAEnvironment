library(plyr)
library(devtools)
library(broom)

# select the data
data <- amandroid_googleplay_master
#data <- data[data$flows > 0
# flag for which tool we're analyzing
tool <- "amandroid"
# reset model to null
tidy_model <- NULL
model <- NULL


# compute precision and completed columns
data$precision = data$tp / (data$fp+data$tp)
#data$completed <- data$time
#data[is.na(data)] <- 0
# set regression target
target = data$completed

if (tool == "flowdroid") {
  # reorganize factors so that default level is on top
  data$aliasalgo <- factor(data$aliasalgo, levels=c('FLOWSENSITIVE', 'LAZY', 'PTSBASED', 'NONE'))
  data$callbackanalyzer <- factor(data$callbackanalyzer, levels = c('DEFAULT', 'FAST'))
  data$cgalgo <- factor(data$cgalgo, levels=c('SPARK', 'AUTO', 'GEOM', 'CHA', 'RTA', 'VTA'))
  data$cgalgo <- revalue(data$cgalgo, c("AUTO"="SPARK")) #auto and spark are the same level
  data$codeelimination <- factor(data$codeelimination, levels = c('PROPAGATECONSTS', 'NONE', 'REMOVECODE'))
  data$dataflowsolver <- factor(data$dataflowsolver, levels=c('CONTEXTFLOWSENSITIVE', 'FLOWINSENSITIVE'))
  data$implicit <- factor(data$implicit, levels=c('NONE', 'ALL', 'ARRAYONLY'))
  data$pathalgo <- factor(data$pathalgo, levels=c('CONTEXTSENSITIVE', 'CONTEXTINSENSITIVE', 'SOURCESONLY'))
  data$staticmode <- factor(data$staticmode, levels=c('CONTEXTFLOWSENSITIVE', 'CONTEXTFLOWINSENSITIVE', 'NONE'))
  data$taintwrapper <- factor(data$taintwrapper, levels=c('DEFAULT', 'DEFAULTFALLBACK', 'EASY', 'NONE'))
  model <- lm(target ~ data$aliasalgo + data$aplength + data$callbackanalyzer + data$codeelimination + data$cgalgo + 
              data$dataflowsolver + data$implicit + data$maxcallbacksdepth + data$maxcallbackspercomponent + data$pathalgo + 
              data$staticmode + data$taintwrapper + data$aliasflowins + data$analyzeframeworks + data$nocallbacks + data$noexceptions + 
              data$nothischainreduction + data$onesourceatatime + data$onecomponentatatime + data$pathspecificresults + data$enablereflection + 
              data$singlejoinpointabstraction)
  summary(model)
} else if (tool == "droidsafe") {
  data$pta <- factor(data$pta, levels=c('spark', 'paddle', 'geo'))
  model <- lm(target ~ data$apicalldepth + data$kobjsens + data$pta + data$analyzestrings_unfiltered + data$filetransforms + data$ignoreexceptionflows +
                  data$ignorenocontextflows + data$implicitflow + data$imprecisestrings + data$limitcontextforcomplex + data$limitcontextforgui +
                  data$limitcontextforstrings + data$multipassfb + data$noarrayindex + data$noclinitcontext + data$noclonestatics +
                  data$nofallback + data$nojsa + data$noscalaropts + data$nova + data$preciseinfoflow + data$transfertaintfield + data$typesforcontext)
  summary(model)
} else { #amandroid
  model <- lm(target ~ data$kcontext)
  summary(model)
}

tidy_model <- tidy(model)
