package lab2;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.Scanner;

class SaveData{
    private boolean isCorrect;
    private int arrSize;

    public SaveData(boolean isCorrect, int arrSize){
        this.isCorrect = isCorrect;
        this.arrSize = arrSize;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    public int getArrSize() {
        return arrSize;
    }

    public void setArrSize(int arrSize) {
        this.arrSize = arrSize;
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
            path = Integer.parseInt(in.nextLine());
        } catch(Exception error){
            System.err.print("Invalid numeric input. Try again.\n");
        }
        if (path != CONS_NUM && path != FILE_NUM)
            System.err.printf("Choose only %d or %d. Try again.\n", CONS_NUM, FILE_NUM);
        else
            SD.setCorrect(false);

        return path;
    }


    static int choosingAPath(Scanner in){
        System.out.printf("""
                Where will we work through:\s
                \t\tConsole: %d\t\tFile: %d

                """, CONS_NUM, FILE_NUM);

        int path;
        SaveData SD = new SaveData(true, 0);
        do{
            System.out.print("Your choice: ");
            path = pathCheck(SD, in);
        } while (SD.isCorrect());

        return path;
    }


    // block of condition check
    static boolean isArrIncreasing(double[] arrOfNumb) {
        for (int i = 1; i < arrOfNumb.length; i++) {
            if (!(arrOfNumb[i] <= arrOfNumb[i - 1])) {
                return false;
            }
        }

        return true;
    }


    static int resultOfArrChecking(boolean isIncrease){
        if (isIncrease)
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
                arrSize = Integer.parseInt(in.nextLine());
            } catch(Exception error){
                System.err.print("Invalid numeric input. Try again.\n");
            }
            if (arrSize < MIN_ARR_SIZE)
                System.err.printf("Min num is %d. Try again.\n", MIN_ARR_SIZE);
            else
                isIncorrect = false;
        } while (isIncorrect);

        return arrSize;
    }


    static double enteringTheCurrentNumber(int i, Scanner in){
        boolean isIncorrect = true;
        double currentNum = 0.0;

        do{
            System.out.printf("Write your %d number: ", i + 1);
            try{
                currentNum = Double.parseDouble(in.nextLine());
                isIncorrect = false;
            } catch(Exception error){
                System.err.print("Invalid numeric input. Try again.\n");
            }
        } while (isIncorrect);

        return currentNum;
    }


    static void inputArr(double[] arrOfNumb, int arrSize, Scanner in){
        for (int i = 0; i < arrSize; i++){
            arrOfNumb[i] = enteringTheCurrentNumber(i, in);
        }
    }


    static double[] viaConsole(Scanner in){
        SaveData SD = new SaveData(true, 0);
        SD.setArrSize(inputArrSize(in));
        double[] arrOfNumb = new double[SD.getArrSize()];

        inputArr(arrOfNumb, SD.getArrSize(), in);
        //boolean isIncreasing = isArrIncreasing(arrOfNumb);

        return arrOfNumb;//resultOfArrChecking(isIncreasing);
    }


    /// work with file
    static void fileRestriction(){
        System.out.print("""
                \nRules for storing information in a file:
                \t1.  The first line contains an integer:
                \t\tthe number of array elements;
                \t2.  The second line is real number
                \t\tentered separated by spaces.
                
                """);
    }


    static void wayCondition(String way, SaveData SD){
        if (way.length() > 4) {
            String bufstr = way.substring(way.length() - 4);
            if (bufstr.equals(".txt"))
                SD.setCorrect(false);
            else
                System.err.print("Write .txt file.\n");
        }
        else
            System.err.print("The path is too short.\n");
    }


    static String inputWayToTheFile(Scanner in){
        String way;
        SaveData SD = new SaveData(true, 0);

        System.out.print("Write way to your file: ");
        do{
            way = in.nextLine();

            wayCondition(way, SD);
        } while (SD.isCorrect());

        return way;
    }


    static boolean isFileIntegrity(String fileWay)
    {
        boolean isIntegrity = false;

        File file = new File(fileWay);
        if (file.canRead())
            isIntegrity = true;

        return isIntegrity;
    }

    static double[] resultOfReading(boolean isCorrect, double[] arrOfNumb)
    {
        if (isCorrect)
            return arrOfNumb;
        else {
            System.err.print("ERROR in file.");

            return null;
        }
    }


    static double[] isCorrectInputFromFile(Scanner in, SaveData SD){
        boolean isCorrect = true;
        double[] arrOfNumb = new double[0];
        if (!in.hasNextInt())
            isCorrect = false;
        else {
            int arrSize = in.nextInt();
            SD.setArrSize(arrSize);
            if (arrSize < MIN_ARR_SIZE)
                isCorrect = false;

            arrOfNumb = new double[arrSize];
            for (int i = 0; i < arrSize; i++) {
                if (!in.hasNextDouble())
                    isCorrect = false;
                try{
                    arrOfNumb[i] = in.nextDouble();
                } catch(Exception error) {
                    isCorrect = false;
                }
            }

            if (in.hasNext())
                isCorrect = false;
        }
        return resultOfReading (isCorrect, arrOfNumb);
    }


    static double[] isReadingCorrect(String fileWay, SaveData SD)  {
        try {
            Scanner fileScanner = new Scanner(new File(fileWay));
            return isCorrectInputFromFile(fileScanner, SD);
        } catch(FileNotFoundException error) {
            System.err.print("File not found.\n");
            return null;
        }
    }

    static double[] workWithFile(String fileWay) {
        SaveData SD = new SaveData(true, 0);

        return isReadingCorrect(fileWay, SD);
    }


    static double[] workWithIntegrityResult(boolean isIntegrity, String fileWay) {
        if (isIntegrity)
            return workWithFile(fileWay);
        else
        {
            System.err.print("Bad File.");

            return null;
        }
    }


    static double[] viaFile(Scanner in){
        fileRestriction();

        String fileWay = inputWayToTheFile(in);
        boolean isIntegrity = isFileIntegrity(fileWay);

        return workWithIntegrityResult(isIntegrity, fileWay);
    }


    /// output console
    static void outputViaConsole(int result){
        if (result == 1)
            System.out.print("Uncreased.");
        else
            System.out.print("Increasing.");
    }


    // output file
    static String fileCorrectOutput(int result){
        if (result == 1)
            return "\nUncreased.";
        else
            return "\nIncrease.";
    }


    static void outputViaFile(int result, Scanner in)
    {
        String fileWay = inputWayToTheFile(in);
        File file = new File(fileWay);
        StringBuilder builder;
        if (file.canWrite())
        {
            try{
                FileWriter writer = new FileWriter(fileWay);
                builder = new StringBuilder();
                builder.append(fileCorrectOutput(result));
                writer.write(builder.toString());
                writer.close();
                System.out.print("Check your file.");
            } catch (Exception error){
                System.err.print("Can't write in this file.");
            }
        }
        else
            System.err.print("\nBad output file.");
    }


    /// output
    static void output(int result, Scanner in)
    {
        if (result != -1)
        {
            System.out.print("\n\nYou need to choose where to output the result.\n");
            int option = choosingAPath(in);

            if (option == FILE_NUM) {
                outputViaFile(result, in);
            } else {
                outputViaConsole(result);
            }
        }
    }


    public static void main(String[] args){
        Scanner in = new Scanner(System.in);

        printStatement();

        int option = choosingAPath(in);
        double[] arrOfNumb = option == FILE_NUM ? viaFile(in) : viaConsole(in);

        if (arrOfNumb != null) {
            boolean isIncreasing = isArrIncreasing(arrOfNumb);
            int result = resultOfArrChecking(isIncreasing);
            output(result, in);
        }

        in.close();
    }
}