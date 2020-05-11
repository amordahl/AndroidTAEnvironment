#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 1 --callbackanalyzer FAST --codeelimination NONE --cgalgo RTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 2 --noexceptions  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --enablereflection  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
