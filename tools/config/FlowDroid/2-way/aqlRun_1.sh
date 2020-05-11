#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 3 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo VTA --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit ALL --maxcallbackspercomponent 50 --maxcallbacksdepth 0 --nocallbacks --noexceptions --nothischainreduction --pathalgo SOURCESONLY --onesourceatatime --onecomponentatatime --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
