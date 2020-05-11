#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins  --aplength 3 --callbackanalyzer FAST --codeelimination NONE --cgalgo GEOM --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 6 --maxcallbacksdepth 1 --noexceptions  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
