#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins --aplength 40 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 3 --maxcallbacksdepth 3 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults --singlejoinpointabstraction --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
