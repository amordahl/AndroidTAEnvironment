#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 1 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo GEOM --callbacksourcemode SOURCELIST --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode NONE --maxcallbackspercomponent 4 --maxcallbacksdepth 5 --nocallbacks  --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --enablereflection  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
