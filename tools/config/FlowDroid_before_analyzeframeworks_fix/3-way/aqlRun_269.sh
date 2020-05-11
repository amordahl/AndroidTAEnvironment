#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 2 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo AUTO --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode ALL --maxcallbackspercomponent 3 --maxcallbacksdepth 100 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
