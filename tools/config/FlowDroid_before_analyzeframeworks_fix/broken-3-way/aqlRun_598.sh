#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 6 --callbackanalyzer FAST --codeelimination PROPAGATECONST --cgalgo GEOM --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ALL --layoutmode ALL --maxcallbackspercomponent 10 --maxcallbacksdepth 9 --noexceptions  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
