#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins  --aplength 9 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo GEOM --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 6 --maxcallbacksdepth 9 --nocallbacks  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
