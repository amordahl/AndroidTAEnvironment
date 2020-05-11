#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 10 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit ALL --maxcallbackspercomponent 100 --maxcallbacksdepth 90 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
