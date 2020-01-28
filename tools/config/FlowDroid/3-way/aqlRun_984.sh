#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 10 --callbackanalyzer FAST --codeelimination NONE --cgalgo SPARK --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 5 --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
