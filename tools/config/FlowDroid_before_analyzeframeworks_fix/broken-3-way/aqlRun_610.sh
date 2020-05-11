#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 7 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo SPARK --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 2 --maxcallbacksdepth 1 --nocallbacks  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
