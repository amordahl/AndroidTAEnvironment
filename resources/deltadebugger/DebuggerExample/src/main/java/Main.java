import java.util.ArrayList;
import java.util.Arrays;

/*
* Simple program with methods and main class used to test the ViolationDeltaDebugger
* This program will print out "failure" which we are trying to preserve
*
* */
public class Main {


    public static void main(String[] args){

        //Very readable and pretty writable

        UselessClass x = new UselessClass();
        int hello =1;
        boolean booleanGuy=true;

        //form of most variables/classes
        //var var_name = something;

        //if static then UselessClass.staticMethod();
        UselessClass.staticMethod();
        //if not static then x.method();
        String returnVar = x.helloMethod();

        //Reliability is bit constrictive
        int[] arr = new int[5];
        Arrays.fill(arr,1);
        hello=arr[6];


        //sometimes hard to read and write
        (new ArrayList<Integer>(10)).forEach(integer->{
            System.out.println(integer);
        });
        //also this does the same thing as above
        (new ArrayList<Integer>(10)).forEach(System.out::println);
    }



}
class UselessClass{
    public UselessClass(){
        System.out.println("Wow that was useless");
    }

    static void staticMethod(){}
    String helloMethod(){return "hello";}
}