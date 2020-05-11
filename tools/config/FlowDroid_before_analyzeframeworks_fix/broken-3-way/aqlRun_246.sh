#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 3 --callbackanalyzer FAST --codeelimination NONE --cgalgo CHA --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 5 --maxcallbacksdepth 7 --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --pathspecificresults  --enablereflection  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
