#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 3 --callbackanalyzer FAST --codeelimination NONE --cgalgo VTA --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode ALL --maxcallbackspercomponent 10 --maxcallbacksdepth 1 --noexceptions  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode NONE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
