#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 20 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo VTA --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit ALL --maxcallbackspercomponent 200 --maxcallbacksdepth 80 --nocallbacks --nothischainreduction --pathalgo SOURCESONLY --onesourceatatime --onecomponentatatime --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
