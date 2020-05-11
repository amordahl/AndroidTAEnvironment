#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 10 --callbackanalyzer FAST --codeelimination NONE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 2 --maxcallbacksdepth 100 --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
