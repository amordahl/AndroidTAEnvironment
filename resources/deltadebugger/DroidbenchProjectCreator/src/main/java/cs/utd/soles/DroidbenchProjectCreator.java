package cs.utd.soles;


/*
* All this program does it take in the name of a droidbench project and the filepath to create it in
* use it as a library in the delta debugger
* */


import org.apache.commons.io.FileUtils;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DroidbenchProjectCreator {
    static final String PREFIXW="D:\\Local_androidTAEnvironment\\Droidbench_projects\\";
    static final String PREFIXL="/home/dakota/AndroidTA/AndroidTAEnvironment/resources/droidbench_android_projects/";
    static String projName;
    static File pathFile;
    public static void createProject(String[] args){

        //handle the args
        handleArgs(args);

        //which project are we copying
        findAndCopyProject();

        Logger.getGlobal().log(Level.INFO, "Project Creation: Success");
    }

    private static void findAndCopyProject() {
        if(System.getProperty("os.name").toLowerCase().contains("win")){
            createCopy(Paths.get(PREFIXW+projName).toFile());
        }else{
            createCopy(Paths.get(PREFIXL+projName).toFile());
        }

    }

    private static void handleArgs(String[] args) {
        projName=args[0];
        pathFile= Paths.get(args[1]).toFile();
        if(pathFile.exists()) {
            Logger.getGlobal().log(Level.INFO, "Project Creation: Failure: Selected File Already Exists");
            System.exit(-1);
        }

    }

    //which file we are copying
    private static void createCopy(File projectFile){

        if(!projectFile.exists()) {
            Logger.getGlobal().log(Level.INFO, "Project Creation: Failure");
            System.exit(-1);
            return;
        }
        try {
            FileUtils.copyDirectory(projectFile,pathFile);


        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
