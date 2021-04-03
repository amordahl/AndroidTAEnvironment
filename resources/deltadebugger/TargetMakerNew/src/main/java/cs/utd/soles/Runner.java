package cs.utd.soles;

import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;
import com.utdallas.cs.alps.flows.AQLFlowFileReader;
import com.utdallas.cs.alps.flows.Flow;
import com.utdallas.cs.alps.flows.Statement;
import cs.utd.soles.SchemaGenerator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.io.*;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Scanner;

public class Runner {

    public static final String groundTruthDir="/home/dakota/AndroidTA/benchmarks/DroidBench30/benchmark/groundtruth";
    public static final String groundTruthWinDir="D:\\Local_androidTAEnvironment\\Droidbench\\DroidBench30\\DroidBench30\\benchmark\\groundtruth";
    //1 args -> the file
    public static void main(String[] args) {
        //get all the files

        ArrayList<LineObj> lineObjs = makeFiles(args);
        try {
            SchemaGenerator.generateSchema();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //for(cs.utd.soles.LineObj x: lineObjs)
        //    System.out.println(x);
        //slurp up

        //construct ground truths
        ArrayList<APKObj> groundTruths = new ArrayList<>();

        File[] category = Paths.get(groundTruthDir).toFile().listFiles();

        for(File x: category){
            if(!x.isDirectory())
                continue;
            File[] xmlFiles = x.listFiles();

            for(File gt: xmlFiles){
                if(!gt.getName().endsWith(".xml")){
                    continue;
                }
                String ending = gt.getName();
                String apkName= ending.substring(ending.lastIndexOf("_")+1,ending.indexOf(".xml"));
                boolean type= ending.substring(ending.indexOf("_")+1,ending.lastIndexOf("_")).equals("tp");

                //eat file, make a list of classified flows, add to apkObj that has name or make new
                APKObj checker = new APKObj(apkName);
                APKObj apkObj = groundTruths.contains(checker)? groundTruths.get(groundTruths.indexOf(checker)):checker;
                if(checker==apkObj)
                    groundTruths.add(apkObj);
                ArrayList<Flow> flowsForThis = getFlowStrings(gt);
                for(Flow f:flowsForThis){
                    apkObj.addFlow(new ClassifiedFlow(f,type));
                }


            }

        }



        //run aql and analyze
        for(LineObj x: lineObjs){

            try {
                ArrayList<Flow> violationFlows =runAQL(x);
                //once we have all the flows, we need to classify these ones

                //find the apkObj we need to look at
                APKObj compare = new APKObj(x.apkName);
                APKObj apkObj = groundTruths.contains(compare)?groundTruths.get(groundTruths.indexOf(compare)):null;
                if(apkObj==null){
                    System.out.println("NO APK FOR THIS????");
                    continue;
                }

                ArrayList<ClassifiedFlow> classifiedViolationFlows = new ArrayList<>();
                for(Flow f: violationFlows){
                    ClassifiedFlow found = apkObj.classifyFlow(f);
                    if(found==null){
                        System.out.println("THIS FLOW HAS NO CLASSIFICATION!");
                        continue;
                    }
                    classifiedViolationFlows.add(found);
                }


                //if we replicate the violation then we good

                int numOfFalse=0;
                int numOfTrue=0;

                for(ClassifiedFlow l:classifiedViolationFlows) {
                    int i = (l.type ? numOfTrue++ : numOfFalse++);
                }
                if(x.type){
                    if(numOfTrue>0)
                        x.replicated=true;
                }else{
                    if(numOfFalse>0)
                        x.replicated=true;
                }
                x.flows=classifiedViolationFlows;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }




        //generate input

        //our input is literally, a apk and 2 config files and the type of violation or if is not a violation. plus a json file of the flows we target

        File outPutFile= new File("targetmaker/output.txt");
        if(outPutFile.exists())
            outPutFile.delete();
        try {
            outPutFile.createNewFile();
            FileWriter fw = new FileWriter(outPutFile);
            for(LineObj x: lineObjs){
                System.out.println(x);
                if(x.replicated){

                    File file = writeFlowsToJson(x);

                    //the last false will be replaced when we generate non-violations
                    fw.write(x.apkPath+" "+x.config1+" "+x.config2+" "+x.type +" "+"false"+" "/*the name of the file*/+file.getAbsolutePath()+"\n");

                }
            }
            fw.flush();
            fw.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    private static File writeFlowsToJson(LineObj x) throws IOException {


        File fil= new File("targetmaker/targetfiles/"+x.apkName+"_"+x.configName1+"_"+x.configName2+".json");
        fil.mkdirs();
        if(fil.exists())fil.delete();
        fil.createNewFile();

        JSONArray arr = new JSONArray();
        for(ClassifiedFlow f: x.flows){
            JSONObject obj = turnFlowToJSONObj(f.f);
            arr.add(obj);
        }

        String formatJson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create().toJson(new JsonParser().parse(arr.toJSONString()));
        FileWriter fw = new FileWriter(fil);
        fw.write(formatJson);
        fw.flush();
        fw.close();
        return fil;
    }

    private static JSONObject turnFlowToJSONObj(Flow f) {
        JSONObject obj=new JSONObject();

        obj.put("sink",turnStatementTOJSONObj(f.getSink()));
        obj.put("source",turnStatementTOJSONObj(f.getSource()));


        return obj;
    }
    private static JSONObject turnStatementTOJSONObj(Statement s){
        JSONObject obj=new JSONObject();

        obj.put("statement", s.getStatement());
        obj.put("classname",s.getClassname());
        obj.put("method",s.getMethod());

        return obj;
    }

    private static ArrayList<LineObj> makeFiles(String[] args) {
        //seperated by commas in args[0] file
        ArrayList<LineObj> returnList = new ArrayList<>();
        try{
            File f = Paths.get(args[0]).toFile();
            Scanner sc = new Scanner(f);
            String inFull="";
            while(sc.hasNextLine()){
                inFull+=sc.nextLine();
            }

            //we got it now break it up

            String[] lines = inFull.split(",");
            ArrayList<String> noDupes=new ArrayList<>();
            for(String x: lines){
                if(!noDupes.contains(x))
                    noDupes.add(x);
            }
            //each thing in lines is one violation

            //make lin objects for them

            //System.out.println(noDupes);
            int i=0;
            for(String x: noDupes){
                String[] trash=x.substring(10).split(" ");
                //0 type, 2+4 genconfig1, 1+3 genconfig2, 5 apkpath

                returnList.add(new LineObj(trash[0], (trash[1]+trash[3]).toLowerCase(),trash[2].equals("values")? (trash[1]+trash[4]).toLowerCase():(trash[2]+trash[3]).toLowerCase() ,trash[5]));

                if(!Paths.get(returnList.get(i).config1).toFile().exists()||!Paths.get(returnList.get(i).config2).toFile().exists()){

                    System.out.println(!Paths.get(returnList.get(i).config1).toFile().exists()? returnList.get(i).config1 : returnList.get(i).config2);

                }

                i++;
            }




        }catch(Exception e){
            e.printStackTrace();
        }
        return returnList;
    }

    private static ArrayList<Flow> runAQL(LineObj x) throws IOException {

        String command1 = "python3 runaql.py "+x.config1+" "+x.apkPath+" -f";
        String command2 = "python3 runaql.py "+x.config2+" "+x.apkPath+" -f";
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

        File o1 = handleOutput(command1Out,x.configName1+x.apkName);
        File o2 = handleOutput(command2Out,x.configName2+x.apkName);
        x.AQLconfig1=o1;
        x.AQLconfig2=o2;
        return handleAQL(x,o1,o2);
    }

    private static ArrayList<Flow> handleAQL(LineObj x, File o1, File o2) {

        //check if we got the right type of violation

        ArrayList<Flow> flowMapTarget= new ArrayList<>();
        if(x.type){
            //soundness
            flowMapTarget.addAll(getFlowStrings(o1));
            flowMapTarget.removeAll(getFlowStrings(o2));


        }else{
            //precision
            flowMapTarget.addAll(getFlowStrings(o2));
            flowMapTarget.removeAll(getFlowStrings(o1));
        }

        return flowMapTarget;
    }

    private static File handleOutput(String outString, String programConfigString) throws IOException {

        String fp = "targetmaker/aqlfiles/"+programConfigString+"out.xml";

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

    private static String catchOutput(Process p) throws IOException {
        //this just reads the output of the command we just ran
        BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
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
        System.out.println("Output of AQL: "+output);
        return output;
    }
    private static ArrayList<Flow> getFlowStrings(File xmlFile){
        AQLFlowFileReader aff = new AQLFlowFileReader(SchemaGenerator.SCHEMA_PATH);
        Iterator<Flow> flowIt = aff.getFlows(xmlFile);
        ArrayList<Flow> out = new ArrayList<Flow>();
        while(flowIt.hasNext()){
            out.add(flowIt.next());

        }
        return out;
    }
}
