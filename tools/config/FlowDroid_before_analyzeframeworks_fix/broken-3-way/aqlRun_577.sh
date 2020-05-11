#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 6 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo AUTO --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode NONE --maxcallbackspercomponent 8 --maxcallbacksdepth 8 --nocallbacks  --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults  --singlejoinpointabstraction  --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
