package cs.utd.soles;

import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.Node;
import com.github.javaparser.ast.body.BodyDeclaration;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;
import com.github.javaparser.ast.stmt.BlockStmt;
import com.github.javaparser.ast.stmt.Statement;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.apache.commons.io.FileUtils;
import org.json.simple.parser.ParseException;

import java.io.*;
import java.nio.file.StandardCopyOption;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;


public class Runner {


    static File intermediateJavaDir=null;
    public static boolean LOG_MESSAGES=false;
    static TesterUtil testerForThis=null;
    static String configFileName="";
    public static void main(String[] args){
        PerfTimer.startProgramRunTime();
        try {
            configFileName=readConfig(args[0]);
            if(args.length==2){
                if(args[1].equals("-l")){
                    LOG_MESSAGES=true;
                }
            }
            SchemaGenerator.generateSchema();
        }catch(Exception e){
            e.printStackTrace();
            System.exit(-1);
        }

        testerForThis = new TesterUtil(targetFilePath, SchemaGenerator.SCHEMA_PATH, configFileName);

        try{
            handleSrcDirectory(java_directory_path);
            if(LOG_MESSAGES) {
                String filePathName = "debugger/java_files/" + configFileName + "/intermediate_java/";
                File f = new File(filePathName);
                f.mkdirs();
                intermediateJavaDir=f;

            }
        }catch(IOException e){
            e.printStackTrace();
        }
        //start the delta debugging process

        while(!minimized){

            PerfTimer.startOneRotation();
            //this is set here because if a change is made to ANY ast we want to say we haven't minimized yet
            minimized=true;
            int i=0;
            //TODO:: Test if this method actually works
            //if(bestCUList.size()>1)
                //handleCUList(bestCUList);
            for (CompilationUnit compilationUnit : bestCUList) {
                traverseTree(i, compilationUnit);
                i++;
            }
            System.out.println("Done with 1 rotation");
            PerfTimer.endOneRotation();
        }

        //log a bunch of information
        try {
            String filePathName = "debugger/java_files/"+configFileName+"/";
            for (int i = 0; i < bestCUList.size(); i++) {
                File file = new File(filePathName +programFileNames.get(i) + ".java");
                file.mkdirs();
                if (file.exists())
                    file.delete();
                file.createNewFile();
                FileWriter fw = new FileWriter(file);
                fw.write(bestCUList.get(i).toString());
                fw.flush();
                fw.close();
            }

            filePathName = "debugger/"+configFileName+"_time.txt";
            File file = new File(filePathName);

            if (file.exists())
                file.delete();
            file.createNewFile();
            FileWriter fw = new FileWriter(file);
            long finalRunTimeVar= PerfTimer.getProgramRunTime()/1000;
            fw.write("program_runtime: "+finalRunTimeVar+"\n"+"\n");
            fw.write("average_of_rotations: " + PerfTimer.getAverageOfRotations()/1000+"\n");
            fw.write("total_rotations: "+ PerfTimer.getTotalRotations()+"\n"+"\n");
            fw.write("average_runtime_aql: " + PerfTimer.getAverageOfAQLRuns()/1000+"\n");
            fw.write("total_aql_runs: "+PerfTimer.getTotalAQLRuns()+"\n"+"\n");
            fw.write("average_runtime_compile: " +PerfTimer.getAverageOfCompileRuns()/1000+"\n");
            fw.write("total_compile_runs: "+ PerfTimer.getTotalCompileRuns()+"\n"+"\n");
            fw.write("total_proposed_node_changes: " + PerfTimer.proposedChangesCount);
            fw.write("total_complete_node_changes: " + PerfTimer.totalChangesCount);
            fw.write("num_candidate_ast: " + testerForThis.candidateCountJava);
            fw.write("Percentages:\n"+PerfTimer.getPercentages());
            fw.write("compilation_failed: "+testerForThis.compilationFailedCount);


            fw.flush();
            fw.close();


            //revert program to it's original form
            testerForThis.saveCompilationUnits(originalCUnits,unchangedJavaFiles, originalCUnits.size()+1,null);
        }catch(IOException e){
            e.printStackTrace();
        }
    }
    //this method handles the filepath to the fileconfig.json which is what we are going to be reading for our config
    private static String readConfig(String path)throws Exception {
        JSONParser parser = new JSONParser();
        System.out.println(path);
        try(FileReader reader = new FileReader(Paths.get(path).toFile())) {

            JSONObject obj = (JSONObject) parser.parse(reader);
            targetFilePath= (String) obj.get("target_path");
            java_directory_path= (String) obj.get("java_directory_path");
            gradlew_path= (String) obj.get("gradlew_path");
            project_root_path= (String) obj.get("project_root_path");
            apk_path= (String) obj.get("apk_path");
            generating_config1_path= (String) obj.get("generating_config1");
            generating_config2_path= (String) obj.get("generating_config2");

        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }
        if(targetFilePath==null|java_directory_path==null|gradlew_path==null|project_root_path==null|apk_path==null|generating_config1_path==null|generating_config2_path==null){
            throw new Exception("Config file incomplete");
        }
        return Paths.get(path).toFile().getName().replace(".json","");
    }


    static String targetFilePath=null;
    static String java_directory_path=null;
    static String gradlew_path = null;
    static String project_root_path =null;
    static String apk_path =null;
    static String generating_config1_path=null;
    static String generating_config2_path=null;

    static boolean minimized=false;
    static ArrayList<CompilationUnit> bestCUList = new ArrayList<>();
    static ArrayList<CompilationUnit> originalCUnits = new ArrayList();
    static ArrayList<String> programFileNames= new ArrayList<>();
    static ArrayList<File> javaFiles = new ArrayList<>();
    static ArrayList<File> unchangedJavaFiles = new ArrayList<>();
    //main recursion that loops through all nodes
    //we process parents before children

    public static void traverseTree(int currentCU, Node currentNode){

        if(!currentNode.getParentNode().isPresent()&&!(currentNode instanceof CompilationUnit)||currentNode==null){
            return;
        }
        //process node
        process(currentCU, currentNode);
        //traverse children
        for(Node x: currentNode.getChildNodes()){
            traverseTree(currentCU, x);
        }

    }

    public static void handleNodeList(int compPosition, Node currentNode, List<Node> childList){

        //make a copy of the tree

        CompilationUnit copiedUnit = bestCUList.get(compPosition).clone();
        Node copiedNode = findCurrentNode(currentNode, compPosition, copiedUnit);
        ArrayList<Node> alterableList = new ArrayList<Node>(childList);
        ArrayList<Node> copiedList = getCurrentNodeList(copiedNode, alterableList);


        //change the copy
        for(int i=copiedList.size();i>0;i/=2){
            for(int j=0;j<copiedList.size();j+=i){
                List<Node> subList = new ArrayList<>(copiedList.subList(j,Math.min((j+i),copiedList.size())));

                List<Node> removedNodes = new ArrayList<>();
                List<Node> alterableRemoves = new ArrayList<>();
                int index=j;
                for(Node x: subList){
                    if(copiedList.contains(x)){
                        copiedNode.remove(x);
                        removedNodes.add(x);
                        alterableRemoves.add(alterableList.get(index));
                        PerfTimer.addToProposedChanges(1);
                    }
                    index++;
                }

                if(checkChanges(compPosition, copiedUnit,false,null)){
                    //if changed remove the nodes we removed from the original ast
                    for(Node x:alterableRemoves){
                        currentNode.remove(x);
                        PerfTimer.addToTotalChanges(1);
                    }


                    copiedList.removeAll(removedNodes);
                    alterableList.removeAll(alterableRemoves);


                    //make another copy and try to run the loop again
                    copiedUnit = bestCUList.get(compPosition).clone();
                    copiedNode = findCurrentNode(currentNode, compPosition, copiedUnit);
                    copiedList = getCurrentNodeList(copiedNode, alterableList);
                    i=copiedList.size()/2;
                    break;
                } else{
                    copiedUnit = bestCUList.get(compPosition).clone();
                    copiedNode = findCurrentNode(currentNode, compPosition, copiedUnit);
                    copiedList = getCurrentNodeList(copiedNode, alterableList);
                }
            }
        }
        //check changes
        //if they worked REMOVE THE SAME NODES FROM ORIGINAL DONT COPY ANYTHING
    }

    //this method trys to remove entire CompilationUnits from the list
    public static void handleCUList(List<CompilationUnit> childList){

        ArrayList<CompilationUnit> copiedList = new ArrayList<>();
        for(CompilationUnit x: childList){
            copiedList.add(x.clone());
        }
        for(int i=copiedList.size();i>0;i/=2){
            for(int j=0;j<copiedList.size();j+=i){
                List<CompilationUnit> subList = new ArrayList<>(copiedList.subList(j,Math.min((j+i),copiedList.size())));
                copiedList.removeAll(subList);
                if(checkChanges(childList.size()+1,null,true,copiedList)){
                    //the copied list worked, update regular list to reflect changes
                    childList=copiedList;
                    //we also need to remove the javafiles associated with the compilationUnits from the list of files
                    for(int h=0;h<subList.size();h++){
                        javaFiles.remove(j);
                    }
                    //restart the loop
                    copiedList = new ArrayList<>();
                    for(CompilationUnit x: childList){
                        copiedList.add(x.clone());
                    }
                    i=copiedList.size()/2;
                }else{
                    //the copied list didn't work, set it back to normal
                    copiedList.addAll(j,subList);
                }
            }
        }

    }


    //matches the currentNode to what type it is and handles appropriately
    //this returns the currentNode (could be the node we gave it or it's equivalent copy whenever we copied and killed tons of trees)
    public static void process(int currentCUPos, Node currentNode){

        if(!currentNode.getParentNode().isPresent()&&!(currentNode instanceof CompilationUnit)){
            return;
        }
        if(currentNode instanceof ClassOrInterfaceDeclaration){
            ClassOrInterfaceDeclaration node = (ClassOrInterfaceDeclaration) currentNode;

            List<Node> childList = new ArrayList<Node>();
            for(Node x: node.getChildNodes()){
                if(x instanceof BodyDeclaration<?>){
                    childList.add(x);
                }
            }
            handleNodeList(currentCUPos,currentNode, childList);

        }

        if(currentNode instanceof BlockStmt) {

            BlockStmt node = ((BlockStmt) currentNode);
            List<Node> childList = new ArrayList<>();
            for(Node x: node.getChildNodes()){
                if(x instanceof  Statement){
                    childList.add(x);
                }
            }
            handleNodeList(currentCUPos,currentNode, childList);
        }


    }


    //finds an equivalent node in an equivalent tree
    public static Node findCurrentNode(Node currentNode, int compPosition, CompilationUnit copiedUnit){

        Node curNode = currentNode;
        List<Node> traverseList = new ArrayList<>();
        traverseList.add(curNode);
        while(!(curNode instanceof CompilationUnit)){
            curNode = curNode.getParentNode().get();
            traverseList.add(0, curNode);
        }

        curNode = copiedUnit;
        traverseList.remove(0);

        while(!traverseList.isEmpty()){
            for(Node x: curNode.getChildNodes()){
                if(x.equals(traverseList.get(0))){
                    if(traverseList.size()==1){
                        return x;
                    }
                    curNode=x;
                    //System.out.println("Found matching: "+ x.getClass().toGenericString()+"      "+traverseList.get(0).getClass().toGenericString());
                    break;
                }
            }
            traverseList.remove(0);
        }

        return null;

    }

    //just like how with currentNode we have to find it in the ast, we have to find the children we were working on as well
    public static ArrayList<Node> getCurrentNodeList(Node currentNode, List<Node> list){

        //if(LOG_MESSAGES){
           // System.out.println("Current Node in gCNL: " + currentNode);
      //  }
        List<Node> cloneList = currentNode.getChildNodes();

        ArrayList<Node> childrenWeCareAbout = new ArrayList<>(cloneList);

        childrenWeCareAbout.retainAll(list);
        return childrenWeCareAbout;

    }


    //this method is run our ast and see if the changes we made are good or bad (returning true or false) depending
    private static boolean checkChanges(int compPosition, CompilationUnit copiedu, boolean replaceCU, ArrayList<CompilationUnit> cuList) {

        boolean returnVal=false;

        try {
            if(!replaceCU) {
                if (testerForThis.createApk(gradlew_path, project_root_path, bestCUList, javaFiles, compPosition, copiedu)) {

                    if (testerForThis.runAQL(apk_path, generating_config1_path, generating_config2_path, configFileName)) {

                        returnVal = true;
                        minimized = false;

                        System.out.println("Successful One\n\n------------------------------------\n\n\n");
                        for (CompilationUnit x : bestCUList) {
                            System.out.println(x);
                        }
                        System.out.println("CopiedUnit:" + copiedu);
                    }
                }
            }else{
                if (testerForThis.createApk(gradlew_path, project_root_path, cuList, javaFiles, compPosition, copiedu)) {

                    if (testerForThis.runAQL(apk_path, generating_config1_path, generating_config2_path, configFileName)) {

                        returnVal = true;
                        minimized = false;

                        System.out.println("Successful One\n\n------------------------------------\n\n\n");
                        for (CompilationUnit x : bestCUList) {
                            System.out.println(x);
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return returnVal;
    }

    //this method should take in our java directory and feed all the .java files to our static java parser so we can modify their ASTs
    //it also saves the filenames so we can re-save the files
    //this also calls createInPlaceCopy so we can create an unmodified copy of the original files
    private static boolean handleSrcDirectory(String javadirpath) throws IOException {
        File f = Paths.get(javadirpath).toFile();

        if(!f.exists()){
            throw new FileNotFoundException(javadirpath + "not found");
        }

        String[] extensions = {"java"};
        List<File> allJFiles = ((List<File>) FileUtils.listFiles(f, extensions, true));

        ArrayList<CompilationUnit> returnList = new ArrayList<>();
        ArrayList<CompilationUnit> cloneList = new ArrayList<>();
        ArrayList<String> nameList = new ArrayList<>();
        int i=0;
        for(File x: allJFiles){
            //don't add the unmodified source files cause they will just duplicate endlessly
            if(!x.getAbsolutePath().contains("unmodified_src")) {
                nameList.add(x.getName().substring(0, x.getName().length() - 5));
                returnList.add(StaticJavaParser.parse(x.getAbsoluteFile()));
                cloneList.add(returnList.get(i).clone());
                i++;
                javaFiles.add(x.getAbsoluteFile());
                unchangedJavaFiles.add(x.getAbsoluteFile());
            }
            createInPlaceCopy(x, f);
        }
        bestCUList = returnList;
        programFileNames = nameList;
        originalCUnits = cloneList;


        return true;
    }
    //creates a copy of the unmodified source files because we are going to modify them in-place
    private static boolean createInPlaceCopy(File f, File javaDir) throws IOException {
        String javaDirPathString = javaDir.getPath();
        String filePathString = f.getPath();

        String javaDirParentPathString = javaDir.getParentFile().getAbsolutePath();
        String correctRelativePath = filePathString.substring(filePathString.indexOf(javaDirPathString)+javaDirPathString.length());
        File inPlaceCopy = new File(javaDirParentPathString+File.separator+"unmodified_src"+File.separator+correctRelativePath);
        if(inPlaceCopy.exists())
            inPlaceCopy.delete();
        inPlaceCopy.mkdirs();
        inPlaceCopy.createNewFile();
        Files.copy(f.toPath(),inPlaceCopy.toPath(), StandardCopyOption.REPLACE_EXISTING);

        return true;
    }


}
