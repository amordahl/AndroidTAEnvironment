#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 8 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo RTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode ALL --maxcallbackspercomponent 1 --maxcallbacksdepth 4 --nocallbacks  --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
