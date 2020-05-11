#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins --aplength 4 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit ALL --maxcallbackspercomponent 110 --maxcallbacksdepth 110 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --onesourceatatime --onecomponentatatime --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
