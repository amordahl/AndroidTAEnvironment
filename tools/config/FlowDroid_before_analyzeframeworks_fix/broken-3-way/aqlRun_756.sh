#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 8 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo RTA --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 6 --maxcallbacksdepth 7 --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
