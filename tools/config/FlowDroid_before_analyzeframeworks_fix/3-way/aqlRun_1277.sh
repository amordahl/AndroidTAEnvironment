#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 6 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 20 --maxcallbacksdepth 3 --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
