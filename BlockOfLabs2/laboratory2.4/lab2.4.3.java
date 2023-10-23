package lab2;

import java.util.Scanner;

class SaveData{
    private boolean isCorrect;

    public SaveData(){

    }

    public SaveData(boolean isCorrect){
        this.isCorrect = isCorrect;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
}
public class lab4 {
    static final int CONS_NUM = 1;
    static final int FILE_NUM = 2;
    static final int MIN_ARR_SIZE = 2;

    static void printStatement(){
        System.out.print("""
                         The program calculates whether the entered
                                 natural number sequence is increasing.
                         """);
    }


    // work with way to the file
    static int pathCheck(SaveData SD, Scanner in){
        int path = 0;
        try{
            path = Integer.getInteger(in.nextLine());
        } catch(Exception error){
            System.out.print("Invalid numeric input. Try again.\n");
        }
        if (path != CONS_NUM && path != FILE_NUM)
            System.out.printf("Choose only %d or %d. Try again.\n", CONS_NUM, FILE_NUM);
        else
            SD.setCorrect(false);

        return path;
    }


    static int choosingAPath(Scanner in){
        System.out.printf("Where will we work through: \n\t\tConsole: " +
                "%d\t\tFile: %d\n\n", CONS_NUM, FILE_NUM);

        int path;
        SaveData SD = new SaveData(true);
        do{
            System.out.print("Your choice: ");
            path = pathCheck(SD, in);
        } while (SD.isCorrect());

        return path;
    }


    // block of condition check
    static boolean isArrIncreasing(double[] arrOfNumb, int arrSize){
        boolean isConditionYes = true;

        for (int i = 1; i < arrSize; i++) {
            if (arrOfNumb[i] > arrOfNumb[i - 1]);
            else
                isConditionYes = false;
        }

        return isConditionYes;
    }


    static int resultOfArrChecking(boolean isIncreas){
        if (isIncreas)
            return 1;
        else
            return 0;
    }


    /// work in console
    static int inputArrSize(Scanner in){
        boolean isIncorrect = true;
        int arrSize = 0;

        do {
            System.out.print("How much number in massive: ");
            try {
                arrSize = Integer.getInteger(in.nextLine());
            } catch(Exception error){
                System.out.print("Invalid numeric input. Try again.\n");
            }
            if (arrSize < MIN_ARR_SIZE)
                System.out.printf("Min num is %d. Try again.\n", MIN_ARR_SIZE);
            else
                isIncorrect = false;
        } while (isIncorrect);

        return arrSize;
    }


    static double enteringTheCurrentNumber(int i, Scanner in){
        boolean isIncorret = true;
        double currentNum = 0.0;

        do{
            System.out.printf("Write your %d number: ", i + 1);
            try{
                currentNum = Double.parseDouble(in.nextLine());
                isIncorret = false;
            } catch(Exception error){
                System.out.print("Invalid numeric input. Try again.\n");
            }
        } while (isIncorret);

        return currentNum;
    }


    static void inputArr(double[] arrOfNumb, int arrSize, Scanner in){
        for (int i = 0; i < arrSize; i++){
            arrOfNumb[i] = enteringTheCurrentNumber(i, in);
        }
    }


    static int viaConsole(Scanner in){
        int arrSize = inputArrSize(in);
        double[] arrOfNumb = new double[arrSize];

        inputArr(arrOfNumb, arrSize, in);
        boolean isIncreasing = isArrIncreasing(arrOfNumb, arrSize);

        return resultOfArrChecking(isIncreasing);
    }


    /// work with file
    static void fileRestriction(){
        System.out.print("""
                         Rules for storing information in a file:
                                1.  The first line contains an integer:
                		                the number of array elements;
                			    2.  The second line is real number
                			            entered separated by spaces.
                         """);
    }


    static void wayCondition(String way, SaveData SD){
        if (way.length() > 4) {
            String bufstr = way.substring(way.length() - 4);
            if (bufstr.equals(".txt"))
                SD.setCorrect(false);
            else
                System.out.print("Write .txt file.\n");
        }
        else
            System.out.print("The path is too short.\n");
    }


    static String inputWayToTheFile(Scanner in){
        String way;
        SaveData SD = new SaveData(true);

        do{
            System.out.print("Write way to your file: ");
            way = in.nextLine();

            wayCondition(way, SD);
        } while (SD.isCorrect());

        return way;
    }


    // isCorrectInputFromFile... to be continued.


    public static void main(String[] args){
        Scanner in = new Scanner(System.in);

        printStatement();

    }
}