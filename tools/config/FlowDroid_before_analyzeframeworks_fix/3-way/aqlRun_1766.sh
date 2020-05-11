#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 8 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 40 --maxcallbacksdepth 30 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
