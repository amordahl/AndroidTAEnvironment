import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Scanner;

/*
* Simple program with methods and main class used to test JavaParser
* This program will throw a ArithmeticException
* the other part of the program counts the number of yellow balls in a file
* */
public class Main {

    public static void main(String[] args) {
        System.out.println("hello world!");
        String fileContents = "";
        UselessClass bob = new UselessClass();
        ErrorClass error = new ErrorClass();
        int yellowCount = countYellow(fileContents);
        System.out.println(yellowCount);
        System.out.println("Divide Yellow by 0");
    }

    public static int countYellow(String fileContents) {
        int numOfYellow = 0;
        String[] contents = fileContents.split(" ");
        for (int i = 0; i < contents.length - 1; i++) {
            if (contents[i + 1].equals("y")) {
                numOfYellow += Integer.parseInt(contents[i]);
            }
        }
        return numOfYellow;
    }
}

class UselessClass {

    public UselessClass() {
        System.out.println("Wow that was useless");
    }
}
