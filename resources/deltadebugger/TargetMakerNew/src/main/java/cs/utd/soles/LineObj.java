package cs.utd.soles;

import java.io.File;

public class LineObj {

    final String configFilePath="/home/dakota/AndroidTA/AndroidTAEnvironment/configurations/FlowDroid/1-way/";
    final String configPrefix="config_FlowDroid_";

    boolean type;
    String config1;
    String config2;
    String apkPath;
    File AQLconfig1;
    File AQLconfig2;
    boolean replicated=false;

    @Override
    public String toString() {
        return "cs.utd.soles.LineObj{" +
                "type='" + type + '\'' +
                ", config1='" + config1 + '\'' +
                ", config2='" + config2 + '\'' +
                ", apkPath='" + apkPath + '\'' +
                '}';
    }

    public LineObj(String type, String config1, String config2, String apkPath) {
        this.type = !type.equals("precision");
        this.apkPath = apkPath;
        this.config1=tryFix(config1);
        this.config2=tryFix(config2);



    }

    private String tryFix(String config) {
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


        return configFilePath+configPrefix+config+".xml";
    }
}
