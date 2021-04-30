library(plyr)
library(devtools)
library(broom)
library(glmnet)
library(mlbench)
library(caret)
library(randomForest) # for rfFuncs
library(klaR) # for nbFuncs
library(ggplot2)

set.seed(1223)
rfeFuncs=rfFuncs
# select the data
input <- flowdroid_fossdroid_all
data <- input
# flag for which tool we're analyzing
tool <- "flowdroid"
# reset model to null
tidy_model <- NULL
model <- NULL

# Code to rank features based on Pearson correlation


# compute precision and completed columns
data$precision = data$tp / (data$fp+data$tp)
#data <- data[!is.nan(data$precision),]
#data$completed <- data$time
#data[is.na(data)] <- 0
# # # set regression target
# # number of completed tasks
# target = data$completed

# # total runtime
# target = data$time

# precision
data <- data[!is.nan(data$precision),]
target = data$precision

# # f-measure
# target = data$`f-measure`


if (tool == "flowdroid") {
  # reorganize factors so that default level is on top
  data$aliasalgo <- factor(data$aliasalgo, levels=c('NONE', 'PTSBASED', 'LAZY', 'FLOWSENSITIVE'))
  data$callbackanalyzer <- factor(data$callbackanalyzer, levels = c('FAST', 'DEFAULT'))
  data$cgalgo <- factor(data$cgalgo, levels=c('CHA', 'RTA', 'VTA', 'GEOM','SPARK', 'AUTO'))
  data$cgalgo <- revalue(data$cgalgo, c("AUTO"="SPARK")) #auto and spark are the same level
  data$codeelimination <- factor(data$codeelimination, levels = c('NONE', 'PROPAGATECONSTS', 'REMOVECODE'))
  data$dataflowsolver <- factor(data$dataflowsolver, levels=c('FLOWINSENSITIVE', 'CONTEXTFLOWSENSITIVE'))
  data$implicit <- factor(data$implicit, levels=c('NONE', 'ALL', 'ARRAYONLY'))
  data$pathalgo <- factor(data$pathalgo, levels=c('SOURCESONLY', 'CONTEXTINSENSITIVE', 'CONTEXTSENSITIVE'))
  data$staticmode <- factor(data$staticmode, levels=c('NONE', 'CONTEXTFLOWINSENSITIVE', 'CONTEXTFLOWSENSITIVE'))
  data$taintwrapper <- factor(data$taintwrapper, levels=c('DEFAULT', 'DEFAULTFALLBACK', 'EASY', 'NONE'))
  
  x <- data.matrix(data[,c('aliasalgo', 'aplength', 'callbackanalyzer', 'cgalgo', 'codeelimination',
                           'dataflowsolver', 'implicit', 'maxcallbacksdepth', 'maxcallbackspercomponent',
                           'pathalgo', 'staticmode', 'taintwrapper', 'aliasflowins', 'analyzeframeworks',
                           'nocallbacks', 'noexceptions', 'nothischainreduction', 'onesourceatatime', 'onecomponentatatime',
                           'pathspecificresults', 'enablereflection', 'singlejoinpointabstraction')])
  y <- target
  # control <- rfeControl(functions=lmFuncs, method='repeatedcv', number=10)
  # print('RECURSIVE FEATURE SELECTION')
  # rfe_model <- rfe(x,y,rfeControl=control)
  # plot(rfs_model)
  # #Compute pearson coefficient
  # print(rfs_model)
  # 
  # plain_model <- lm(target ~ data$aliasalgo + data$aplength + data$callbackanalyzer + data$codeelimination + data$cgalgo + 
  #             data$dataflowsolver + data$implicit + data$maxcallbacksdepth + data$maxcallbackspercomponent + data$pathalgo + 
  #             data$staticmode + data$taintwrapper + data$aliasflowins + data$analyzeframeworks + data$nocallbacks + data$noexceptions + 
  #             data$nothischainreduction + data$onesourceatatime + data$onecomponentatatime + data$pathspecificresults + data$enablereflection + 
  #             data$singlejoinpointabstraction)
  
  print('LASSO REGRESSION')
  lasso_model <- cv.glmnet(x, target, alpha=1)
  plot(lasso_model)
  # lasso_model <- glmnet(x, y, alpha=1, lambda=lasso_model$lambda.min)
  # coef(lasso_model)
  # print(rfe_model)
  # print('GENETIC ALGORITHM')
  # ga_ctrl <- gafsControl(functions = caretGA,
  #                        method = "repeatedcv",
  #                        repeats = 5)
  # ga_model <- gafs(x = x, 
  #             y = y,
  #             iters = 100,
  #             gafsControl = ga_ctrl,
  #             ## Now pass options to `train`
  #             method = "lm")
  # print(ga_model)
  # print('SIMULATED ANNEALING')
  # sa_ctrl <- safsControl(functions = rfSA,
  #                        method = "repeatedcv",
  #                        repeats = 5,
  #                        improve = 50)
  # model <- safs(x=x, y=y, iters=100,
  #               safsControl=sa_ctrl,
  #               method='lm')
  # print(model)
  
} else if (tool == "droidsafe") {
  data$pta <- factor(data$pta, levels=c('spark', 'paddle', 'geo'))
  x <- data.matrix(data[,c('apicalldepth', 'kobjsens', 'pta', 'analyzestrings_unfiltered', 'filetransforms', 'ignoreexceptionflows',
                           'ignorenocontextflows', 'implicitflow', 'imprecisestrings', 'limitcontextforcomplex',
                           'limitcontextforgui', 'limitcontextforstrings', 'multipassfb', 'noarrayindex', 'noclinitcontext',
                           'noclonestatics', 'nofallback', 'nojsa', 'noscalaropts', 'nova', 'preciseinfoflow', 'transfertaintfield',
                           'typesforcontext')])
  # plain_model <- lm(target ~ data$apicalldepth + data$kobjsens + + data$pta + data$analyzestrings_unfiltered + data$filetransforms + data$ignoreexceptionflows +
  #                 data$ignorenocontextflows + data$implicitflow + data$imprecisestrings + data$limitcontextforcomplex + data$limitcontextforgui +
  #                 data$limitcontextforstrings + data$multipassfb + data$noarrayindex + data$noclinitcontext + data$noclonestatics +
  #                 data$nofallback + data$nojsa + data$noscalaropts + data$nova + data$preciseinfoflow + data$transfertaintfield + data$typesforcontext)
  y <- target
  # control <- rfeControl(functions=rfFuncs, method='repeatedcv', number=10)
  # rfe_model <- rfe(x,y,rfeControl=control)
  # #Compute pearson coefficient
  # print('RECURSIVE FEATURE SELECTION')
  # print(model)
  
  lasso_model <- cv.glmnet(x, target, alpha=1)
  plot(lasso_model)
  print('LASSO REGRESSION')
  # lasso_model <- glmnet(x,y,alpha=1, lambda=model$lambda.min)
  # coef(lasso_model)
  # print(rfe_model)
  # print('SIMULATED ANNEALING')
  # model <- safs(x, y, iters=100, safsControl=safsControl(functions=rfeFuncs))
} else { #amandroid
  model <- lm(target ~ data$kcontext)
  summary(model)
}

tidy_model <- tidy(model)
