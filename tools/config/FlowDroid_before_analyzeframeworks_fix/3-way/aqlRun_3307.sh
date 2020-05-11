#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 100 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo CHA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode ALL --maxcallbackspercomponent 20 --maxcallbacksdepth 8 --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
