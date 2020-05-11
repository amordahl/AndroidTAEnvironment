#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins  --aplength 9 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo VTA --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode PWD --maxcallbackspercomponent 2 --maxcallbacksdepth 5 --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --enablereflection  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
