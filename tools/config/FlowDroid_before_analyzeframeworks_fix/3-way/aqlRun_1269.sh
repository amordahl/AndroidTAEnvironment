#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins --aplength 6 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode PWD --maxcallbackspercomponent 10 --maxcallbacksdepth 10 --nocallbacks --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
