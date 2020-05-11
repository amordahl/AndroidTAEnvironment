#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 7 --callbackanalyzer FAST --codeelimination NONE --cgalgo SPARK --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 3 --maxcallbacksdepth 9 --nocallbacks  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
