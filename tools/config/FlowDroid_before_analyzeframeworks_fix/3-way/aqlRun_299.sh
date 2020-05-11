#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 2 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 5 --maxcallbacksdepth 100 --noexceptions --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --singlejoinpointabstraction --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
