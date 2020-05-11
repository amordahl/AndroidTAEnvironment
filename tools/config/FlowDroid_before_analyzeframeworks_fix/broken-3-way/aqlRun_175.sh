#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 2 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo CHA --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 8 --maxcallbacksdepth 6 --nocallbacks  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode NONE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
