#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 10 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo GEOM --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 1 --maxcallbacksdepth 6 --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults  --enablereflection  --staticmode NONE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
