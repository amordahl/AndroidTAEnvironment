import subprocess
import os
import argparse
p = argparse.ArgumentParser('Utility to run all of the benchmarks.')
p.add_argument('files', help='List of files.', nargs='+')
p.add_argument('--force', '-f', help='Overwrite existing files.',
               action='store_true')
args = p.parse_args()

configs = [('default', ''),
           ('codeeliminationrc', '--codeelimination REMOVECODE'),
           ('cgalgo_cha', '--cgalgo CHA'),
           ('cgalgo_rta', '--cgalgo RTA'),
           ('aliasflowins', '--aliasflowins'),
           ('callbackanalyzerfast', '--callbackanalyzer FAST'),
           ('analyzeframeworks', '--analyzeframeworks'),
           ('taintwrappereasy', '--taintwrapper EASY -t /Users/austin/git/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt'),
           ('taintwrapperdefaultfallback', '--taintwrapper DEFAULTFALLBACK'),
           ('taintwrappernone', '--taintwrapper NONE'),
           ('dataflowsolverflowinsensitive', '--dataflowsolver FLOWINSENSITIVE'),
           ('onecomponentatatime', '--onecomponentatatime'),
           ('pathalgocontextinsensitive', '--pathalgo CONTEXTINSENSITIVE')
]

base_cmd = "/Users/austin/Library/Java/JavaVirtualMachines/openjdk-14.0.1/Contents/Home/bin/java -Dfile.encoding=UTF-8 -classpath /Users/austin/git/FlowDroid/soot-infoflow-cmd/build/testclasses:/Users/austin/git/FlowDroid/soot-infoflow-cmd/build/classes:/Users/austin/.p2/pool/plugins/org.junit_4.13.0.v20200204-1500.jar:/Users/austin/.p2/pool/plugins/org.hamcrest.core_1.3.0.v20180420-1519.jar:/Users/austin/git/FlowDroid/soot-infoflow-android/build/classes:/Users/austin/git/soot/target/classes:/Users/austin/git/soot/target/test-classes:/Users/austin/.m2/repository/commons-io/commons-io/2.6/commons-io-2.6.jar:/Users/austin/.m2/repository/org/smali/dexlib2/2.2.5/dexlib2-2.2.5.jar:/Users/austin/.m2/repository/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar:/Users/austin/.m2/repository/com/google/guava/guava/18.0/guava-18.0.jar:/Users/austin/.m2/repository/org/ow2/asm/asm-debug-all/5.2/asm-debug-all-5.2.jar:/Users/austin/.m2/repository/org/javassist/javassist/3.18.2-GA/javassist-3.18.2-GA.jar:/Users/austin/.m2/repository/xmlpull/xmlpull/1.1.3.4d_b4_min/xmlpull-1.1.3.4d_b4_min.jar:/Users/austin/.m2/repository/org/apache/ant/ant/1.10.1/ant-1.10.1.jar:/Users/austin/.m2/repository/org/apache/ant/ant-launcher/1.10.1/ant-launcher-1.10.1.jar:/Users/austin/.m2/repository/pxb/android/axml/2.0.0/axml-2.0.0.jar:/Users/austin/.m2/repository/ca/mcgill/sable/polyglot/2006/polyglot-2006.jar:/Users/austin/.m2/repository/heros/heros/1.1.0/heros-1.1.0.jar:/Users/austin/.m2/repository/org/functionaljava/functionaljava/4.2/functionaljava-4.2.jar:/Users/austin/.m2/repository/ca/mcgill/sable/jasmin/3.0.1/jasmin-3.0.1.jar:/Users/austin/.m2/repository/ca/mcgill/sable/java_cup/0.9.2/java_cup-0.9.2.jar:/Users/austin/.m2/repository/org/slf4j/slf4j-api/1.7.5/slf4j-api-1.7.5.jar:/Users/austin/.m2/repository/org/slf4j/slf4j-simple/1.7.5/slf4j-simple-1.7.5.jar:/Users/austin/.m2/repository/junit/junit/4.11/junit-4.11.jar:/Users/austin/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar:/Users/austin/.m2/repository/org/hamcrest/hamcrest-all/1.3/hamcrest-all-1.3.jar:/Users/austin/.m2/repository/org/mockito/mockito-all/1.10.8/mockito-all-1.10.8.jar:/Users/austin/.m2/repository/org/powermock/powermock-core/1.6.1/powermock-core-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-api-mockito/1.6.1/powermock-api-mockito-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4-common/1.6.1/powermock-module-junit4-common-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4/1.6.1/powermock-module-junit4-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4-legacy/1.6.1/powermock-module-junit4-legacy-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit3/1.6.1/powermock-module-junit3-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-reflect/1.6.1/powermock-reflect-1.6.1.jar:/Users/austin/.m2/repository/org/objenesis/objenesis/2.1/objenesis-2.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-api-support/1.6.1/powermock-api-support-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-testng/1.6.1/powermock-module-testng-1.6.1.jar:/Users/austin/.m2/repository/org/testng/testng/6.8.13/testng-6.8.13.jar:/Users/austin/.m2/repository/org/beanshell/bsh/2.0b4/bsh-2.0b4.jar:/Users/austin/.m2/repository/com/beust/jcommander/1.27/jcommander-1.27.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-testng-common/1.6.1/powermock-module-testng-common-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-classloading-base/1.6.1/powermock-classloading-base-1.6.1.jar:/Users/austin/.m2/repository/org/powermock/powermock-core/1.6.1/powermock-core-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-api-mockito/1.6.1/powermock-api-mockito-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4-common/1.6.1/powermock-module-junit4-common-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4/1.6.1/powermock-module-junit4-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit4-legacy/1.6.1/powermock-module-junit4-legacy-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-junit3/1.6.1/powermock-module-junit3-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-module-testng/1.6.1/powermock-module-testng-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-reflect/1.6.1/powermock-reflect-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-api-support/1.6.1/powermock-api-support-1.6.1-sources.jar:/Users/austin/.m2/repository/org/powermock/powermock-classloading-base/1.6.1/powermock-classloading-base-1.6.1-sources.jar:/Users/austin/.m2/repository/com/google/android/android/4.1.1.4/android-4.1.1.4.jar:/Users/austin/.m2/repository/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar:/Users/austin/.m2/repository/org/apache/httpcomponents/httpclient/4.0.1/httpclient-4.0.1.jar:/Users/austin/.m2/repository/org/apache/httpcomponents/httpcore/4.0.1/httpcore-4.0.1.jar:/Users/austin/.m2/repository/commons-codec/commons-codec/1.3/commons-codec-1.3.jar:/Users/austin/.m2/repository/org/khronos/opengl-api/gl1.1-android-2.1_r1/opengl-api-gl1.1-android-2.1_r1.jar:/Users/austin/.m2/repository/xerces/xmlParserAPIs/2.6.2/xmlParserAPIs-2.6.2.jar:/Users/austin/.m2/repository/xpp3/xpp3/1.1.4c/xpp3-1.1.4c.jar:/Users/austin/.m2/repository/org/json/json/20080701/json-20080701.jar:/Users/austin/git/FlowDroid/soot-infoflow/build/classes:/Users/austin/git/FlowDroid/soot-infoflow/build/testclasses:/Users/austin/git/heros/bin:/Users/austin/git/FlowDroid/soot-infoflow/lib/cos.jar:/Users/austin/git/FlowDroid/soot-infoflow/lib/j2ee.jar:/Users/austin/git/FlowDroid/soot-infoflow-android/lib/protobuf-java-2.5.0.jar:/Users/austin/.m2/repository/net/sf/trove4j/trove4j/3.0.3/trove4j-3.0.3.jar:/Users/austin/.m2/repository/ca/mcgill/sable/jasmin/2.5.0-SNAPSHOT/jasmin-2.5.0-SNAPSHOT.jar:/Users/austin/.m2/repository/pxb/android/axml/2.0.0-SNAPSHOT/axml-2.0.0-SNAPSHOT.jar:/Users/austin/.m2/repository/ca/mcgill/sable/axmlprinter/2016-07-27/axmlprinter-2016-07-27.jar:/Users/austin/.m2/repository/com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar:/Users/austin/git/FlowDroid/soot-infoflow-summaries/build/classes:/Users/austin/.m2/repository/com/google/guava/guava/25.1-jre/guava-25.1-jre.jar:/Users/austin/.m2/repository/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar:/Users/austin/.m2/repository/org/checkerframework/checker-qual/2.0.0/checker-qual-2.0.0.jar:/Users/austin/.m2/repository/com/google/errorprone/error_prone_annotations/2.1.3/error_prone_annotations-2.1.3.jar:/Users/austin/.m2/repository/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.jar:/Users/austin/.m2/repository/org/codehaus/mojo/animal-sniffer-annotations/1.14/animal-sniffer-annotations-1.14.jar:/Users/austin/.m2/repository/heros/heros/1.0.1-SNAPSHOT/heros-1.0.1-SNAPSHOT.jar:/Users/austin/.m2/repository/commons-cli/commons-cli/1.4/commons-cli-1.4.jar -XX:+ShowCodeDetailsInExceptionMessages soot.jimple.infoflow.cmd.MainClass -p /Users/austin/Library/Android/sdk/platforms -s /Users/austin/git/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt -a".split(' ')

cmds = list()
for name, cmd_string in configs:
    for f in args.files:
        if not args.force:
            if os.path.exists(f'./{name}/{os.path.basename(f)}.log'):
                continue
        if not os.path.exists(f'./{name}'):
            os.mkdir(f'./{name}')
        cmd = base_cmd.copy()
        cmd.append(os.path.abspath(f))
        if cmd_string is not '':
            cmd.append(cmd_string)
        cmd.extend(['&>', os.path.abspath(f'./{name}/{os.path.basename(f)}.log')])
        cmds.append(cmd)

for cmd in cmds:
    print(' '.join(cmd))
    



