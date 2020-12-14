import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args);

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
