package cs.utd.soles;

import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.Node;
import com.github.javaparser.ast.NodeList;
import com.github.javaparser.ast.body.BodyDeclaration;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;
import com.github.javaparser.ast.stmt.BlockStmt;
import com.github.javaparser.ast.stmt.Statement;
import com.github.javaparser.printer.lexicalpreservation.LexicalPreservingPrinter;
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
        //testerForThis.createApk(gradlew_path,project_root_path);
        //start the delta debugging process
        while(!minimized){
            //this is set here because if a change is made to ANY file we want to say it isnt minimized yet
            minimized=true;
            for (CompilationUnit compilationUnit : bestCUList) {
                depthFirstTraverse(compilationUnit);
            }
            System.out.println("Done with 1 rotation");
        }


        try {
            String filePathName = "debugger/java_files/bestCU";
            for (int i = 0; i < bestCUList.size(); i++) {
                File file = new File(filePathName + (i + 1) + ".java");
                file.mkdirs();
                FileWriter fw = new FileWriter(file);
                if (file.exists())
                    file.delete();
                file.createNewFile();
                fw.write(LexicalPreservingPrinter.print(bestCUList.get(i)));
                fw.flush();
                fw.close();
            }
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

    //main recursion that loops through all nodes
    //we process parents before children
    public static void depthFirstTraverse(Node currentNode){


        process(currentNode);

        List<Node> nodeChildren = currentNode.getChildNodes();
        for(Node n: nodeChildren){

            depthFirstTraverse(n);
        }

    }
    //matches the currentNode to what type it is and handles appropriately
    public static void process(Node currentNode){

        if(!currentNode.getParentNode().isPresent()&&!(currentNode instanceof CompilationUnit)){
            return;
        }
        if(currentNode instanceof ClassOrInterfaceDeclaration){
            handleNodeListBodyDec(((ClassOrInterfaceDeclaration) currentNode).getMembers());

            //method call that gives error
            //handleNodeList(((ClassOrInterfaceDeclaration) currentNode).getMembers());
        }

        if(currentNode instanceof BlockStmt) {

            handleNodeListState(((BlockStmt) currentNode).getStatements());
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
        System.out.println("Before loop: "+list);
        for(int i=list.size();i>0;i/=2){
            for(int j=0;j<list.size();j+=i){
                NodeList<BodyDeclaration<?>> subList = new NodeList<>(list.subList(j,Math.min((j + i), list.size())));
                list.removeAll(subList);
                System.out.println("After remove: "+list);
                if(!checkChanges(list.getParentNodeForChildren())){
                    list.addAll(j, subList);
                    System.out.println("After add back: "+list);
                }else{
                    //restart the search from the top (something might have changed so we can remove it now)

                    j=list.size();
                    i=list.size();
                }

            }
        }
        System.out.println("After loop: "+list);


    }


    //Method that we want to replace to handle all types of node lists
    private static void handleNodeList(NodeList<Node> list){

        for(int i=list.size();i>0;i/=2){
            for(int j=0;j<list.size();j+=i){
                NodeList<Node> subList = new NodeList<>(list.subList(j,j+i));
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
        if(list.size()==0){
            list.getParentNodeForChildren().remove();
        }

    }

    //this method is run our ast and see if the changes we made are good or bad (returning true or false) depending
    private static boolean checkChanges(Node n) {

        boolean returnVal=false;

        try {
            if(testerForThis.createApk(gradlew_path,project_root_path)&& testerForThis.runAQL(apk_path,generating_config1_path,generating_config2_path)){
                returnVal=true;
                System.out.println(n.findCompilationUnit().get());
                //bestCu = StaticJavaParser.parse(n.findCompilationUnit().get().toString());

                minimized=false;
                System.out.println("Successful One\n\n------------------------------------\n\n\n");
                for(CompilationUnit x: bestCUList){
                    System.out.println(x);
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
