#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins  --aplength 5 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo AUTO --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode NONE --maxcallbackspercomponent 1 --maxcallbacksdepth 10 --nocallbacks  --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
