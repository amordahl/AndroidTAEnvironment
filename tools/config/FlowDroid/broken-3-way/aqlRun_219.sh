#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 3 --callbackanalyzer FAST --codeelimination PROPAGATECONST --cgalgo RTA --callbacksourcemode ALL --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode NONE --maxcallbackspercomponent 2 --maxcallbacksdepth 10 --nocallbacks  --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
