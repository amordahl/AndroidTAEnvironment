#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 8 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 20 --nocallbacks --noexceptions --pathalgo SOURCESONLY --pathreconstructionmode NONE --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
