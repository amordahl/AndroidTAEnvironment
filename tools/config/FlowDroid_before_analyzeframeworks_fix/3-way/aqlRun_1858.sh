#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins --aplength 9 --callbackanalyzer FAST --codeelimination NONE --cgalgo GEOM --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 4 --maxcallbacksdepth 50 --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
