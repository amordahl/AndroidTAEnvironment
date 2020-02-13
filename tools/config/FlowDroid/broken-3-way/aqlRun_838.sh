#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 9 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo RTA --callbacksourcemode SOURCELIST --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode PWD --maxcallbackspercomponent 4 --maxcallbacksdepth 9 --nocallbacks  --noexceptions  --pathalgo SOURCESONLY --pathreconstructionmode NONE --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
