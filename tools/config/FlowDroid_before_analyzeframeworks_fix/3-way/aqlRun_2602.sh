#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 30 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 9 --maxcallbacksdepth 8 --nothischainreduction --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
