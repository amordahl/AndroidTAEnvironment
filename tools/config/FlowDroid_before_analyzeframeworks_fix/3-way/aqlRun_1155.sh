#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 6 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 3 --maxcallbacksdepth 1 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
