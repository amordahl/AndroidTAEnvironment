#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 8 --callbackanalyzer FAST --codeelimination NONE --cgalgo RTA --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 10 --maxcallbacksdepth 4 --noexceptions  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode NONE --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
