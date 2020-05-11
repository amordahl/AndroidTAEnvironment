#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 6 --callbackanalyzer FAST --codeelimination NONE --cgalgo CHA --callbacksourcemode SOURCELIST --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode PWD --maxcallbackspercomponent 1 --maxcallbacksdepth 5 --nocallbacks  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
