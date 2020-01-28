#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins  --aplength 7 --callbackanalyzer FAST --codeelimination NONE --cgalgo RTA --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 2 --maxcallbacksdepth 6 --nocallbacks  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
