#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 1 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo VTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode PWD --maxcallbackspercomponent 7 --maxcallbacksdepth 3 --nocallbacks  --noexceptions  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --staticmode NONE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
