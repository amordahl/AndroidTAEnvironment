#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 20 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode NONE --maxcallbackspercomponent 6 --maxcallbacksdepth 9 --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults --enablereflection --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
