#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 100 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo AUTO --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 1 --nocallbacks --noexceptions --nothischainreduction --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults --singlejoinpointabstraction --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
