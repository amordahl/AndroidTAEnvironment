#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 4 --callbackanalyzer FAST --codeelimination NONE --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode NONE --maxcallbackspercomponent 10 --maxcallbacksdepth 40 --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
