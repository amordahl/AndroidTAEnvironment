package cs.utd.soles;

import com.utdallas.cs.alps.flows.AQLFlowFileReader;
import com.utdallas.cs.alps.flows.Flow;
import org.apache.commons.lang3.SystemUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


import java.io.*;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;



/**
 * This is used to test the AST against the target, it also parses the target file so it can be compared
 * */




public class TesterUtil {

    boolean soundness;
    String targetFile=null;
    String xmlSchemaFile=null;
    Flow targetFlow=null;

    public TesterUtil(String targetFile, String xmlSchemaFile){
        this.targetFile=targetFile;
        this.xmlSchemaFile=xmlSchemaFile;

        handleTargetFile();
    }


    //this method sets up the target file so we know what to aim at
    private void handleTargetFile() {
        JSONParser parser = new JSONParser();
        try(FileReader reader = new FileReader(Paths.get(targetFile).toFile())) {
            JSONObject obj = (JSONObject) parser.parse(reader);

            soundness = (boolean) obj.get("flow_type");
            String aqlString = (String) obj.get("aql_string");
            handleTargetXMLString(aqlString);

        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }
    }


    //compiles a project then calls runProgram and then return whether the program we just ran contains "Failure", to simulate a bug in a program
   /* boolean compileAndRunProject(ArrayList<CompilationUnit> list, ArrayList<String> names) {
        //new Thread(() -> {
            try {
                //what index we are on
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
    }*/


    //runs program
    /*boolean runProgram(ArrayList<String> fileNames){

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

    }*/

    //this just calls gradlew assembleDebug in the right directory
    //this needs the gradlew file path and the root directory of the project

    public boolean createApk(String gradlewFilePath, String rootDir){
        String[] command = {gradlewFilePath, "assembleDebug", "-p", rootDir};
        try {
            Process p = Runtime.getRuntime().exec(command);
            p.waitFor();
            BufferedReader stream = new BufferedReader(new InputStreamReader(p.getErrorStream()));

            String out="";
            String s="";
            while( (s = stream.readLine())!=null){
                out+=s;
            }
            if(out.length()>0){
                //assembling project failed we don't care why
                return false;
            }
        }catch(IOException | InterruptedException e){
            e.printStackTrace();
        }

        return true;
    }

    public boolean runAQL(String apk, String generatingConfig1, String generatingConfig2) throws IOException {

        //this bit runs and captures the output of the aql script
        String command1 = "python3 runaql.py "+generatingConfig1+" "+apk+" -f";
        String command2 = "python3 runaql.py "+generatingConfig2+" "+apk+" -f";
        Process command1Run = Runtime.getRuntime().exec(command1);
        try {
            command1Run.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        String command1Out =catchOutput(command1Run);


        Process command2Run = Runtime.getRuntime().exec(command2);
        try {
            command2Run.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        String command2Out =catchOutput(command2Run);

        File output1 = handleOutput(1, command1Out);
        File output2 = handleOutput(2, command2Out);

        return handleAQL(output1, output2);

    }


    private Flow handleTargetXMLString(String xmlString){
        String fp = "debugger/tempfiles/aqlfiles/target";
        File f = Paths.get(fp).toFile();
        try {

            f.mkdirs();
            if(f.exists())
                f.delete();
            f.createNewFile();


            FileWriter fw = new FileWriter(f);
            String header = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>\n";
            fw.write(header);
            fw.write(xmlString);
            fw.flush();
            fw.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        //there is only one flow
        return getFlowStrings(f).get(0);
    }


    private File handleOutput(int id, String outString) throws IOException {

        String fp = "debugger/tempfiles/aqlfiles/"+id+"out.xml";

        File f = Paths.get(fp).toFile();
        f.mkdirs();
        if(f.exists())
            f.delete();
        f.createNewFile();

        String xmlString = outString.substring(outString.indexOf("<answer>"), outString.indexOf("</answer>")+9);
        String header = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>\n";

        FileWriter fw = new FileWriter(f);
        fw.write(header);
        fw.write(xmlString);
        fw.flush();
        fw.close();

        return f;
    }

    private boolean handleAQL(File o1, File o2){

        ArrayList<Flow> flowList = new ArrayList<>();


        //depending on if it is a precision or soundness error
        if(soundness){
            flowList.addAll(getFlowStrings(o1));
            flowList.removeAll(getFlowStrings(o2));
        }else{
            flowList.addAll(getFlowStrings(o2));
            flowList.removeAll(getFlowStrings(o1));
        }
        System.out.println("Flow List: "+flowList);

        //in the case of soundness, the first list has a flow the second does not (so we recreate the violation if we remove all the common flows AND the targetflow is still in the list)
        //same for precision except we remove from the second
        return flowList.contains(targetFlow);
    }

    public ArrayList<Flow> getFlowStrings(File xmlFile){
        AQLFlowFileReader aff = new AQLFlowFileReader(xmlSchemaFile);
        Iterator<Flow> flowIt = aff.getFlows(xmlFile);
        ArrayList<Flow> out = new ArrayList<Flow>();
        while(flowIt.hasNext()){
            out.add(flowIt.next());

        }
        return out;
    }

    private String catchOutput(Process p) throws IOException {
        //this just reads the output of the command we just ran
        BufferedReader  input = new BufferedReader(new InputStreamReader(p.getInputStream()));
        BufferedReader  error = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        String output="";
        String s;
        while((s=input.readLine())!=null){

            output+=s+"\n";
        }

        output+="\n\nError Messages from AQL:\n";
        while((s=error.readLine())!=null){

            output+=s+"\n";
        }
        return output;
    }





}
