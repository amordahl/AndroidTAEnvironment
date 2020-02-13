#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 6 --callbackanalyzer FAST --codeelimination NONE --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 8 --maxcallbacksdepth 30 --nocallbacks --nothischainreduction --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults --enablereflection --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
