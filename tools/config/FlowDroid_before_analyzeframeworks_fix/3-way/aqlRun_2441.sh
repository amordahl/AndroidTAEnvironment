#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins --aplength 20 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo AUTO --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 40 --maxcallbacksdepth 30 --nocallbacks --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --enablereflection --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
