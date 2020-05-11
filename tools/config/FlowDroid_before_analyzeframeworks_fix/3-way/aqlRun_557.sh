#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 3 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo SPARK --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 8 --maxcallbacksdepth 3 --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
