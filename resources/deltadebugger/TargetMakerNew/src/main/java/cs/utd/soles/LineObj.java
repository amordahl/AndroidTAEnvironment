package cs.utd.soles;

import java.io.File;
import java.util.ArrayList;

public class LineObj {

    final String configFilePath="/home/dakota/AndroidTA/AndroidTAEnvironment/configurations/FlowDroid/1-way/";
    final String configPrefix="config_FlowDroid_";

    boolean type;
    String configName1;
    String configName2;
    String apkName;
    String config1;
    String config2;
    String apkPath;
    File AQLconfig1;
    File AQLconfig2;
    boolean replicated=false;


    ArrayList<ClassifiedFlow> flows;

    @Override
    public String toString() {
        return "LineObj{" +
                "configFilePath='" + configFilePath + '\'' +
                ", configPrefix='" + configPrefix + '\'' +
                ", type=" + type +
                ", configName1='" + configName1 + '\'' +
                ", configName2='" + configName2 + '\'' +
                ", apkName='" + apkName + '\'' +
                ", config1='" + config1 + '\'' +
                ", config2='" + config2 + '\'' +
                ", apkPath='" + apkPath + '\'' +
                ", AQLconfig1=" + AQLconfig1 +
                ", AQLconfig2=" + AQLconfig2 +
                ", replicated=" + replicated +
                '}';
    }

    public LineObj(String type, String config1, String config2, String apkPath) {
        this.type = !type.equals("precision");
        this.apkPath = apkPath.substring(1,apkPath.length()-2);
        this.config1=tryFix(config1,1);
        this.config2=tryFix(config2,2);
        this.apkName=apkPath.substring(apkPath.lastIndexOf("/")+1,apkPath.lastIndexOf(".apk"));

        flows = new ArrayList<ClassifiedFlow>();
    }

    private String tryFix(String config, int one) {
        switch(config){
            case "aliasalgoflowsensitive":
                config="aliasalgofs";
                break;
            case "callbackanalyzerdefault":
                config="callbackanalyzerdef";
                break;
            case "aliasflowinstrue":
                config="aliasflowins";
                break;
            case "taintwrapperdefault":

            case "aliasflowinsfalse":
            case "analyzeframeworksfalse":
            case "onecomponentatatimefalse":
                config="aplength5";
                break;
            case "analyzeframeworkstrue":
                config="analyzeframeworks";
                break;
            case "codeeliminationremovecode":
                config="codeeliminationrc";
                break;
            case "codeeliminationpropagateconsts":
                config="codeeliminationpc";
                break;
            case "dataflowsolvercontextflowsensitive":
                config="dataflowsolvercsfs";
                break;
            case "dataflowsolverflowinsensitive":
                config="dataflowsolverfins";
                break;
            case "onecomponentatatimetrue":
                config="onecomponentatatime";
                break;
            default:
                break;
        }
        if(one==1)
            configName1=config;
        else
            configName2=config;
        return configFilePath+configPrefix+config+".xml";
    }
}
