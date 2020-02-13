#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 50 --callbackanalyzer FAST --codeelimination NONE --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 9 --maxcallbacksdepth 4 --nocallbacks --noexceptions --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
