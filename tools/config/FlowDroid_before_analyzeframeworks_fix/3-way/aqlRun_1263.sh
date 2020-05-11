#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 6 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 10 --maxcallbacksdepth 4 --nocallbacks --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode FAST --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
