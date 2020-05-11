#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 100 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo GEOM --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 100 --maxcallbacksdepth 6 --nocallbacks --noexceptions --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --enablereflection --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
