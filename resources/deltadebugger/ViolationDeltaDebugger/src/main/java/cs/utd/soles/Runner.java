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
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;




public class Runner {



    public static void main(String[] args)throws IOException {


        //TODO:: dont do this, give it a directory or something and have it grab all the java files inside it, probably a config file in future when we know what it needs
        String absFilePath1=args[0];
        String absFilePath2=args[1];
        File f = new File(absFilePath1);
        File f2 = new File(absFilePath2);
        CompilationUnit cu = StaticJavaParser.parse(f);
        CompilationUnit cu2 = StaticJavaParser.parse(f2);
        //this list will hold all the files we need to minimize/compile for this project
        programFileNames.add("Main");
        programFileNames.add("ErrorClass");
        bestCUList.add(cu.clone());
        bestCUList.add(cu2.clone());
        //usually this would be built more automatically but since this is a test just hardcode a little bit
        //we also need their names
        /*for(int i=0;i<(number of files);i++){
            cuList.add(new StaticJavaParser.parse(f);
        }*/


        //start the delta debugging process
        while(!minimized){
            //this is set here because if a change is made to ANY file we want to say it isnt minimized yet
            minimized=true;
            for (CompilationUnit compilationUnit : bestCUList) {
                depthFirstTraverse(compilationUnit);
            }
            System.out.println("Done with 1 rotation");
        }



        String filePathName = "src/differentComps/BestCu";
        for(int i=0;i<bestCUList.size();i++){
            File file = new File(filePathName+(i+1)+".java");
            FileWriter fw = new FileWriter(file);
            if(file.exists())
                file.delete();
            file.createNewFile();
            fw.write(LexicalPreservingPrinter.print(bestCUList.get(i)));
            fw.flush();
            fw.close();
        }

    }

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

        for(int i=list.size();i>0;i/=2){
            for(int j=0;j<list.size();j+=i){
                NodeList<BodyDeclaration<?>> subList = new NodeList<>(list.subList(j,j+i));
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

        TesterUtil tester = new TesterUtil("TestProgram");
        if(tester.compileAndRunProject(bestCUList, programFileNames)){
            returnVal=true;
            System.out.println(n.findCompilationUnit().get());
            //bestCu = StaticJavaParser.parse(n.findCompilationUnit().get().toString());

            minimized=false;
            System.out.println("Scuessful One\n\n------------------------------------\n\n\n");
            for(CompilationUnit x: bestCUList){
                System.out.println(x);
            }
        }
        return returnVal;
    }


}
