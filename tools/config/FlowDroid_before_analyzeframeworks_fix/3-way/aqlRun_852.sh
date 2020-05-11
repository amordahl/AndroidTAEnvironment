#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 4 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo CHA --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode ALL --maxcallbackspercomponent 30 --maxcallbacksdepth 40 --nocallbacks --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
