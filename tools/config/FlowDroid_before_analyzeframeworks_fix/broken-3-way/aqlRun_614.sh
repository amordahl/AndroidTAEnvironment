#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins  --aplength 7 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo VTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 2 --maxcallbacksdepth 5 --noexceptions  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
