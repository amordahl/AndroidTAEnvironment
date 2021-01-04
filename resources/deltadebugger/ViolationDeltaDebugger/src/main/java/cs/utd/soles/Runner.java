package cs.utd.soles;

import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.Node;
import com.github.javaparser.ast.NodeList;
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


    static TesterUtil testerForThis=null;
    public static void main(String[] args){
        PerfTimer.startProgramRunTime();
        try {
            readConfig(args[0]);
            SchemaGenerator.generateSchema();
        }catch(Exception e){
            e.printStackTrace();
            System.exit(-1);
        }

        testerForThis = new TesterUtil(targetFilePath, SchemaGenerator.SCHEMA_PATH);

        try{
            handleSrcDirectory(java_directory_path);
        }catch(IOException e){
            e.printStackTrace();
        }
        //start the delta debugging process

        while(!minimized){
            //this is set here because if a change is made to ANY ast we want to say we haven't minimized yet
            PerfTimer.startOneRotation();
            minimized=true;
            int i=0;
            for (CompilationUnit compilationUnit : bestCUList) {
                depthFirstTraverse(i, compilationUnit);
                i++;
            }
            System.out.println("Done with 1 rotation");
            PerfTimer.endOneRotation();
        }


        try {
            String filePathName = "debugger/java_files/";
            for (int i = 0; i < bestCUList.size(); i++) {
                File file = new File(filePathName +programFileNames.get(i) + ".java");

                if (file.exists())
                    file.delete();
                file.createNewFile();
                FileWriter fw = new FileWriter(file);
                fw.write(bestCUList.get(i).toString());
                fw.flush();
                fw.close();
            }

            filePathName = "debugger/"+testerForThis.targetFlow.getApk()+"_time.txt";
            File file = new File(filePathName);

            if (file.exists())
                file.delete();
            file.createNewFile();
            FileWriter fw = new FileWriter(file);
            long finalRunTimeVar= PerfTimer.getProgramRunTime();
            fw.write("Total Program Runtime: "+finalRunTimeVar+"\n"+"\n");
            fw.write("Average Of Rotations: " + PerfTimer.getAverageOfRotations()+"\n");
            fw.write("Total Rotations: "+ PerfTimer.getTotalRotations()+"\n"+"\n");
            fw.write("Average Of AST Changes: "+ PerfTimer.getAverageOfASTChanges()+"\n");
            fw.write("Total AST Changes: " + PerfTimer.getTotalASTChanges()+"\n"+"\n");
            fw.write("Average Of AQL Runs: " + PerfTimer.getAverageOfAQLRuns()+"\n");
            fw.write("Total AQL Runs: "+PerfTimer.getTotalAQLRuns()+"\n"+"\n");
            fw.write("Average Of Compile Runs: " +PerfTimer.getAverageOfCompileRuns()+"\n");
            fw.write("Total Compiles: "+ PerfTimer.getTotalCompileRuns()+"\n"+"\n");
            fw.write("Percentages:\n"+PerfTimer.getPercentages());


            fw.flush();
            fw.close();



        }catch(IOException e){
            e.printStackTrace();
        }
    }
    //this method handles the filepath to the fileconfig.json which is what we are going to be reading for our config
    private static void readConfig(String path)throws Exception {
        JSONParser parser = new JSONParser();
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
    static ArrayList<String> programFileNames= new ArrayList<>();
    static ArrayList<File> javaFiles = new ArrayList<>();
    //main recursion that loops through all nodes
    //we process parents before children
    public static void depthFirstTraverse(int currentCU, Node currentNode){

        if(!currentNode.getParentNode().isPresent()&&!(currentNode instanceof CompilationUnit)){
            return;
        }

        process(currentCU, currentNode);

        List<Node> nodeChildren = currentNode.getChildNodes();
        for(Node n: nodeChildren){

            depthFirstTraverse(currentCU, n);
        }

    }
    //matches the currentNode to what type it is and handles appropriately
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

            BlockStmt node = ((BlockStmt) currentNode).asBlockStmt();
            handleNodeList(currentCUPos,node, node.getChildNodes());
        }


    }
    //handles NodeLists<Statements>
    //all these methods just remove things by cutting the list in half each time
    //once it finds something to remove it then restarts the loop and does it until it can remove anything
    private static void handleNodeListState(NodeList<Statement> list){


        for(int i=list.size();i>0;i/=2){
            for(int j=0;j<list.size();j+=i){
                NodeList<Statement> subList = new NodeList<>(list.subList(j, Math.min((j + i), list.size())));
                list.removeAll(subList);
                //System.out.println(list);
                if(!checkChanges(list.getParentNodeForChildren())){
                    list.addAll(j, subList);
                }else{
                    //restart the search from the top (something might have changed so we can remove it now)

                    j=list.size();
                    i=list.size();
                }

            }
        }

    }
    //handles NodeList<BodyDeclaration<?>>
    private static void handleNodeListBodyDec(NodeList<BodyDeclaration<?>> list){
       // System.out.println("Before loop: "+list);
        for(int i=list.size();i>0;i/=2){
            for(int j=0;j<list.size();j+=i){
                NodeList<BodyDeclaration<?>> subList = new NodeList<>(list.subList(j,Math.min((j + i), list.size())));
                list.removeAll(subList);
                //System.out.println("After remove: "+list);
                if(!checkChanges(list.getParentNodeForChildren())){
                    list.addAll(j, subList);
                   // System.out.println("After add back: "+list);
                }else{
                    //restart the search from the top (something might have changed so we can remove it now)

                    j=list.size();
                    i=list.size();
                }

            }
        }
        //System.out.println("After loop: "+list);


    }


    /**
     * OK, so this method is required because when we remove something from an ast the way we "reset" the ast to it's pre-removal form is by replacing that ast with a copied ast, turns out
     * the "currentNode" object is an object that is in the first tree (the tree we removed something from). So when we replace the entire tree we need to save our position. This method just finds the
     * currentNode that we were working on in the copied tree and then returns it. If we don't do this then the only time we would ever change the tree would be the first time we complete a change-then-replace cycle.
     *
     *
     */

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

                    System.out.println("Found matching: "+ x.getClass().toGenericString()+"      "+traverseList.get(0).getClass().toGenericString());
                    break;
                }
            }
            traverseList.remove(0);
        }

        return null;

    }

    //just like how with currentNode we have to find it in the ast, we have to find the children we were working on as well
    public static ArrayList<Node> getCurrentNodeList(Node currentNode, List<Node> list){

        List<Node> cloneList = currentNode.getChildNodes();
        ArrayList<Node> childrenWeCareAbout = new ArrayList<>(cloneList);

        childrenWeCareAbout.retainAll(list);
        return childrenWeCareAbout;

    }


    private static void handleNodeList(int compPosition, Node currentNode, List<Node> list){



        //save this compilationUnit so we can replace it
        CompilationUnit copiedUnit = bestCUList.get(compPosition).clone();

        Node copiedNode = findCurrentNode(currentNode, compPosition, copiedUnit);
        ArrayList<Node> alterableList = new ArrayList<Node>(list);
        ArrayList<Node> copiedList = getCurrentNodeList(copiedNode, alterableList);


        for(int i=alterableList.size();i>0;i/=2){
            for(int j=0;j<alterableList.size();j+=i){
                PerfTimer.startOneASTChange();
                List<Node> subList = new ArrayList<>(alterableList.subList(j,Math.min((j + i), alterableList.size())));
                //System.out.println("before remove: "+bestCUList.get(compPosition).toString());

                for(Node x: subList){
                    if(alterableList.contains(x)){
                        currentNode.remove(x);
                    }
                }
                //System.out.println("after remove: "+bestCUList.get(compPosition).toString());

                if(!checkChanges(currentNode)){
                    //our changes didnt work so just replace unit with unaltered unit
                    //we also update currentNode and alterableList  with the correct objects for the new ast
                    bestCUList.set(compPosition, copiedUnit);
                    currentNode=copiedNode;
                    alterableList = copiedList;

                    copiedUnit = bestCUList.get(compPosition).clone();
                    copiedNode = findCurrentNode(currentNode, compPosition, copiedUnit);
                    copiedList = getCurrentNodeList(copiedNode, alterableList);


                }else{
                    //restart the search from the top (something might have changed so we can remove it now)
                    //update the copied unit to reflect the most recent ast
                    copiedUnit = bestCUList.get(compPosition).clone();
                    copiedNode = findCurrentNode(currentNode, compPosition,copiedUnit);
                    copiedList = getCurrentNodeList(copiedNode, alterableList);
                    j=alterableList.size();
                    i=alterableList.size()/2;
                }
                PerfTimer.endOneASTChange();

            }
        }


    }





    //this method is run our ast and see if the changes we made are good or bad (returning true or false) depending
    private static boolean checkChanges(Node n) {

        boolean returnVal=false;

        try {

            if(testerForThis.createApk(gradlew_path,project_root_path,bestCUList,javaFiles)) {

                if (testerForThis.runAQL(apk_path, generating_config1_path, generating_config2_path)) {

                    returnVal = true;
                    minimized = false;

                    System.out.println("Successful One\n\n------------------------------------\n\n\n");
                    for (CompilationUnit x : bestCUList) {
                        System.out.println(x);
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
        ArrayList<String> nameList = new ArrayList<>();
        for(File x: allJFiles){
            //don't add the unmodified source files cause they will just duplicate endlessly
            if(!x.getAbsolutePath().contains("unmodified_src")) {
                nameList.add(x.getName().substring(0, x.getName().length() - 5));
                returnList.add(StaticJavaParser.parse(x.getAbsoluteFile()));
                javaFiles.add(x.getAbsoluteFile());
            }
            createInPlaceCopy(x, f);
        }
        bestCUList = returnList;
        programFileNames = nameList;



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
