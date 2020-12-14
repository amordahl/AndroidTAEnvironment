package cs.utd.soles;

import com.github.javaparser.ast.CompilationUnit;
import java.io.*;
import java.util.ArrayList;


/**
 * Simple class for compiling and running java projects so we can delta debug them
 * needs to be changed to support android projects and the violationclassifier program
 * */


public class TesterUtil {
    String programName;


    TesterUtil(String programName){
        this.programName=programName;
    }

    //TODO:: It seems filepaths are going to be an issue when we compile/run programs (if the program requires an input file in a relative directory) so maybe we have to mirror the entire project... investigate
    // modify project inplace (save previous version) (worth a look)


    //compiles a project then calls runProgram and then return whether the program we just ran contains "Failure", to simulate a bug in a program
    boolean compileAndRunProject(ArrayList<CompilationUnit> list, ArrayList<String> names) {
        //new Thread(() -> {
            try {
                //what index we are on
                //TODO:: Investigate how best to compile our java program because right now it's easy because there is just two files but once we add more
                // each with their own dependencies stuff will get complicated
                // maven build script??
                boolean compilationFailed=false;
                for(int i=list.size()-1;i>-1;i--){
                    //make new file
                    File f = new File("src/differentComps/inProgress/"+names.get(i)+".java");
                    f.mkdirs();
                    if(f.exists())
                        f.delete();
                    f.createNewFile();
                    //delete old class file

                    //write current compilation units to own .java file
                    FileWriter fw = new FileWriter(f);
                    fw.write(list.get(i).toString());
                    fw.flush();
                    fw.close();

                   // System.out.println(list.get(i));
                    //compile our .java files
                    Process p =null;
                    String[] command = {"javac","-cp","src/differentComps/inProgress", "src/differentComps/inProgress/"+names.get(i)+".java"};
                    p = Runtime.getRuntime().exec(command);
                    //System.out.println(Arrays.toString(command));
                    p.waitFor();

                    BufferedReader stream = new BufferedReader(new InputStreamReader(p.getErrorStream()));

                    String out="";
                    String s="";
                    while( (s = stream.readLine())!=null){
                        out+=s;
                    }
                    if(out.length()>0){
                        //our compilation failed we dont care why
                        compilationFailed=true;
                        System.out.println(out);
                    }

                }


                if(!compilationFailed){
                    //if compilation was successful run the program
                    return runProgram(names);
                }


            } catch (IOException | InterruptedException e) {
                e.printStackTrace();
            }

        //}).run();

        return false;
    }


    //runs program
    //TODO this needs to be removed and add the flowdroid tool support
    boolean runProgram(ArrayList<String> fileNames){

        //new Thread(()->{
            try{


                //it doesnt matter cause this part is getting removed but this needs to know what is the main class (for now its just fileNames.get(0))
                String[] command = new String[]{"java", "-cp", "C:\\Users\\dakot\\Desktop\\College Job stuff very important\\Code Gremlin job\\work things\\Newer Stuff\\Programs\\JavaParserExp\\src\\differentComps\\inProgress", "Main"};
                Process p= Runtime.getRuntime().exec(command);
                p.waitFor();
                BufferedReader stream = new BufferedReader(new InputStreamReader(p.getInputStream()));
                String out="";
                String s="";
                while( (s = stream.readLine())!=null){
                    out+=s;
                }
                //returns whether this run maintained an error or not

                return catchThreadOut(out);
            }catch (IOException | InterruptedException e) {
                e.printStackTrace();
            }

        //}).run();


        throw new RuntimeException();

    }
    private boolean catchThreadOut(String s){
        //System.out.println(s);
        return s.contains("Failure");

    }
}
