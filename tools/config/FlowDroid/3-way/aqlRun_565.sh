#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 6 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo AUTO --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode PWD --maxcallbackspercomponent 7 --maxcallbacksdepth 6 --noexceptions  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
