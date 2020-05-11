#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 5 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo VTA --callbacksourcemode SOURCELIST --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 1 --maxcallbacksdepth 6 --nocallbacks  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults  --enablereflection  --staticmode NONE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
