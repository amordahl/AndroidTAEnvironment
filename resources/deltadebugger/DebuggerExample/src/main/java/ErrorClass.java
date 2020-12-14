public class ErrorClass {


    public ErrorClass(){
        throwsError(1, "");
    }

    public void throwsError(int i, String unusedMethodParam){
        System.out.println(unusedMethodParam);
        System.out.println("Failure");
    }
}
