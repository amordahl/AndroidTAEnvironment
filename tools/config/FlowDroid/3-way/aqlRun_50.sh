#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 1 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo RTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 6 --maxcallbacksdepth 1 --nocallbacks  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --enablereflection  --singlejoinpointabstraction  --staticmode NONE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
