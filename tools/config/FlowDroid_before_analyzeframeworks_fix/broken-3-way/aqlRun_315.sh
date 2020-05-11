#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 4 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo VTA --callbacksourcemode SOURCELIST --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode PWD --maxcallbackspercomponent 2 --maxcallbacksdepth 6 --noexceptions  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults  --singlejoinpointabstraction  --staticmode NONE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
