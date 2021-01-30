package cs.utd.soles;

import com.github.javaparser.ast.CompilationUnit;
import com.utdallas.cs.alps.flows.AQLFlowFileReader;
import com.utdallas.cs.alps.flows.Flow;
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
    String configFileName =null;

    public TesterUtil(String targetFile, String xmlSchemaFile, String configFileName){
        this.targetFile=targetFile;
        this.xmlSchemaFile=xmlSchemaFile;
        this.configFileName=configFileName;
        handleTargetFile();
    }


    //this method sets up the target file so we know what to aim at
    private void handleTargetFile() {
        JSONParser parser = new JSONParser();
        try(FileReader reader = new FileReader(Paths.get(targetFile).toFile())) {
            JSONObject obj = (JSONObject) parser.parse(reader);

            soundness = (boolean) obj.get("flow_type");
            String aqlString = (String) obj.get("aql_string");
            targetFlow = handleTargetXMLString(aqlString,configFileName);

        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }
    }


    //this saves the compilation units to the correct files
    public static void saveCompilationUnits(ArrayList<CompilationUnit> list, ArrayList<File> files, int positionChanged, CompilationUnit changedUnit) throws IOException {
        int i=0;
        for(File x: files){

            FileWriter fw = new FileWriter(x);
            if(Runner.LOG_MESSAGES) {

                if(i==positionChanged)
                    System.out.println(changedUnit.toString());
                //else
                    //System.out.println("CompilationUnit: " + list.get(i).toString());
            }

            if(i==positionChanged){
                fw.write(changedUnit.toString());
            }else {
                fw.write(list.get(i).toString());
            }
            fw.flush();
            fw.close();
            i++;
        }
    }


    //this just calls gradlew assembleDebug in the right directory
    //this needs the gradlew file path and the root directory of the project
    public boolean createApk(String gradlewFilePath, String rootDir, ArrayList<CompilationUnit> list, ArrayList<File> javaFiles, int positionChanged, CompilationUnit changedUnit){
        PerfTimer.startOneCompileRun();
        String[] command = {gradlewFilePath, "assembleDebug", "-p", rootDir};
        try {
            saveCompilationUnits(list,javaFiles,positionChanged, changedUnit);
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
                if(Runner.LOG_MESSAGES)
                    System.out.println(out);
                PerfTimer.endOneCompileRun();
                return false;
            }
        }catch(IOException | InterruptedException e){
            e.printStackTrace();
        }
        PerfTimer.endOneCompileRun();
        return true;
    }

    public boolean runAQL(String apk, String generatingConfig1, String generatingConfig2, String programConfigString) throws IOException {
        PerfTimer.startOneAQLRun();
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

        File output1 = handleOutput(Long.toHexString(System.currentTimeMillis()), command1Out,programConfigString);
        File output2 = handleOutput(Long.toHexString(System.currentTimeMillis()), command2Out,programConfigString);
        PerfTimer.endOneAQLRun();
        return handleAQL(output1, output2);

    }


    private Flow handleTargetXMLString(String xmlString, String uniqueTargetConfig){
        String fp = "debugger/tempfiles/aqlfiles/"+uniqueTargetConfig+".xml";
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


    private File handleOutput(String id, String outString, String programConfigString) throws IOException {

        String fp = "debugger/tempfiles/aqlfiles/"+programConfigString+id+"out.xml";

        File f = Paths.get(fp).toFile();
        f.mkdirs();
        if(f.exists())
            f.delete();
        f.createNewFile();
        String xmlString ="";
        if(outString.contains("<answer/>")){
            xmlString ="<answer>\n</answer>";
        }else if(outString.contains("<answer>")){
            xmlString = outString.substring(outString.indexOf("<answer>"), outString.indexOf("</answer>") + 9);
        }else{
            return null;
        }
        String header = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>\n";

        FileWriter fw = new FileWriter(f);
        fw.write(header);
        fw.write(xmlString);
        fw.flush();
        fw.close();

        return f;
    }

    private boolean handleAQL(File o1, File o2){

        if(o1==null||o2==null)
            return false;
        ArrayList<Flow> flowList = new ArrayList<>();


        //depending on if it is a precision or soundness error
        if(soundness){
            flowList.addAll(getFlowStrings(o1));
            flowList.removeAll(getFlowStrings(o2));
        }else{
            flowList.addAll(getFlowStrings(o2));
            flowList.removeAll(getFlowStrings(o1));
        }
        boolean returnVal=false;
        for(Flow x: flowList){
            if(Runner.LOG_MESSAGES) {
                System.out.println("Flow Source: " + x.getSource().toString() + "  Flow Sink: " + x.getSink().toString());
                System.out.println("Target Flow Source: " + targetFlow.getSource().toString() + "  Flow Sink: " + targetFlow.getSink().toString());
            }
            if(x.equals(targetFlow)){
                returnVal=true;
            }

        }

        //in the case of soundness, the first list has a flow the second does not (so we recreate the violation if we remove all the common flows AND the targetflow is still in the list)
        //same for precision except we remove from the second
        return returnVal;
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
        //System.out.println("Output of AQL: "+output);
        return output;
    }







}
