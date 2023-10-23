package lab2;

import java.io.*;
import java.util.Scanner;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

class ImportDate{
    private boolean isIncorrect;
    private int palindrome;

    public ImportDate(){

    }

    public ImportDate(boolean isIncorrect, int palindrome){
        this.palindrome = palindrome;
        this.isIncorrect = isIncorrect;
    }

    public boolean isIncorrect() {
        return isIncorrect;
    }

    public void setIncorrect(boolean incorrect) {
        isIncorrect = incorrect;
    }

    public int getPalindrome() {
        return palindrome;
    }

    public void setPalindrome(int palindrome) {
        this.palindrome = palindrome;
    }
}

public class lab3 {
    static final int CONS_NUM = 1;
    static final int FILE_NUM = 2;
    static final int PALIN_OUTPUT_CONTROL = -1;


    static void printStatement(){
        System.out.print("The program determines whether\n\tthe entered natural number is a palindrome.\n\n");
    }


    static void wayCondition(String way, ImportDate Date) {
        if (way.length() > 4) {
            String bufstr = way.substring(way.length() - 4);
            if (bufstr.equals(".txt"))
                Date.setIncorrect(false);
            else
                System.out.print("Write .txt file.\n");
        }
        else
            System.out.print("The path is too short.\n");
    }


    static String inputWay(Scanner in) {
        System.out.print("Write way to your file: ");
        String way;
        ImportDate Date = new ImportDate(true, 0);
        do {
            way = in.nextLine();
            wayCondition(way, Date);
        } while (Date.isIncorrect());

        return way;
    }

    static int pathCondition(ImportDate Date, Scanner in) {
        int num = 0;
        try {
            num = Integer.parseInt(in.nextLine());
        } catch (NumberFormatException error) {
            System.out.print("Invalid numeric input. Try again.\n");
        }
        if (num != CONS_NUM && num != FILE_NUM)
            System.out.printf("Choose only %d or %d. Try again.\n", CONS_NUM, FILE_NUM);
        else Date.setIncorrect(false);
        return num;
    }

    static int choosingAPath(Scanner in) {
        System.out.printf("Where will we work through: \n\tConsole: %d \tFile: %d\n\n", CONS_NUM, FILE_NUM);
        ImportDate Date = new ImportDate(true, 0);
        int result;
        do {
            System.out.print("Your choice: ");
            result = pathCondition(Date, in);
        } while (Date.isIncorrect());

        return result;
    }

    static void palinCondition(ImportDate Date, Scanner in) {
        try{
            Date.setPalindrome(Integer.parseInt(in.nextLine()));
        } catch (NumberFormatException error) {
            System.out.print("Invalid numeric input.Try again.\n");
        }
        if (Date.getPalindrome() < 1)
            System.out.print("Number should be natural.\n");
        else
            Date.setIncorrect(false);
    }


    static int inputPalin(Scanner in) {
        ImportDate Date = new ImportDate(true, 0);
        do {
            System.out.print("Write your number: ");
            palinCondition(Date, in);
        } while (Date.isIncorrect());

        return Date.getPalindrome();
    }


    static int lengthOfPalin(int palindrome) {
        int palinLen = 0;
        while (palindrome > 0) {
            palinLen++;
            palindrome /= 10;
        }

        return palinLen;
    }


    static void putInMassive(int[] arrPalin, int palindrome) {
        int i = 0;
        while (palindrome > 0) {
            arrPalin[i] = palindrome % 10;
            i++;
            palindrome = palindrome / 10;
        }
    }


    static boolean palinIsPalin(int[] arrPalin, int palinLen, int palindrome) {
        boolean isCorrect = true;
        for (int i = 0; i < palinLen / 2; i++) {
            if (arrPalin[i] != arrPalin[palinLen - i - 1])
                isCorrect = false;
        }
        if (palindrome < 0)
            isCorrect = false;

        return isCorrect;
    }


    static boolean palinCheack(int palindrome) {
        int palinLen = lengthOfPalin(palindrome);
        int[] arrPalin = new int[palinLen];
        putInMassive(arrPalin, palindrome);

        return palinIsPalin(arrPalin, palinLen, palindrome);
    }


    static int viaConsole(Scanner in) {
        int palindrome = inputPalin(in);
        if (palinCheack(palindrome) && palindrome > PALIN_OUTPUT_CONTROL)
            return 1;
        else
            return 0;
    }



    static int inputPalinFile(BufferedReader bufferedReader) throws IOException {
        int palindrome = 0;
        String line = bufferedReader.readLine();
        if (line != null)
            palindrome = Integer.parseInt(line);

        if (palindrome < 0) {
            System.out.print("Number should be > 0.");
            palindrome = -1;
        }
        return palindrome;
    }

    static int outputPalin(int palindrome){
        if (palindrome == PALIN_OUTPUT_CONTROL) {
            System.out.print("ERROR.");
            return -1;
        }
        else if (palinCheack(palindrome))
            return 1;
        else return 0;
    }

    static int workWithFile(String fileWay, Scanner in){
        assert fileWay != null;
        File file = new File(fileWay);
        try {
            FileReader fileReader = new FileReader(file);
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            int palindrome = inputPalinFile(bufferedReader);
            bufferedReader.close();
            return outputPalin(palindrome);
        } catch (IOException error) {
            System.err.println("Bad File.");
            return -1;
        }
    }


    static int viaFile(Scanner in) {
        String fileWay;
        fileWay = inputWay(in);
        return workWithFile(fileWay, in);
    }


    static void outputViaConsole(int result) {
        if (result == 1)
            System.out.print("Palindrome.");
        else
            System.out.print("Not a palidrome.");
    }


    static String fileCorrectOutput(int result) {
        if (result == 1)
            return "\nPalindrome.";
        else
            return "\nNot a palindrome.";
    }


    static void outputViaFile(int result, Scanner in) throws IOException {
        String fileWay = inputWay(in);
        File file = new File(fileWay);
        try {
            FileWriter writer = new FileWriter(fileWay, true);
            writer.write(fileCorrectOutput(result));
            writer.close();
            System.out.print("Cheack your file.");
        } catch (IOException error) {
            System.err.println("\nBad output file.");
        }
    }

    private static void output(int option, int result, Scanner in) throws IOException {
        if (result != -1) {
            System.out.print("\n\nYou need to choose where to output the result.\n");
            option = choosingAPath(in);

            if (option == FILE_NUM) {
                outputViaFile(result, in);
            } else {
                outputViaConsole(result);
            }
        }
    }


    public static void main(String[] args) throws IOException {
        Scanner in = new Scanner(System.in);
        printStatement();
        int option = choosingAPath(in);

        int result = option == FILE_NUM ? viaFile(in) : viaConsole(in);

        output(option, result, in);

        in.close();
    }
}