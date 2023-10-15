package lab2;

import java.io.*;
import java.util.Scanner;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import static java.lang.Math.abs;

public class lab3 {
    static final int CONS_NUM = 1;
    static final int FILE_NUM = 2;
    static final int PALIN_OUTPUT_CONTROL = -1;

    static void wayCondition(String way, AtomicBoolean isIncorrect) {
        if (way.length() > 4) {
            String bufstr = way.substring(way.length() - 4);
            if (bufstr.equals(".txt"))
                isIncorrect.set(false);
            else
                System.out.print("Write .txt file.\n");
        }
        else
            System.out.print("The path is too short.\n");
    }


    static String inputWay(Scanner in) {
        String way;
        AtomicBoolean isIncorrect = new AtomicBoolean(true);
        do {
            way = in.nextLine();
            wayCondition(way, isIncorrect);
        } while (isIncorrect.get());

        return way;
    }

    static void pathCondition(AtomicInteger num, AtomicBoolean isIncorrect, Scanner in) {
        try {
            num.set(Integer.parseInt(in.nextLine()));
        } catch (NumberFormatException error) {
            System.out.print("Invalid numeric input. Try again.\n");
        }
        if (num.get() != CONS_NUM && num.get() != FILE_NUM)
            System.out.printf("Choose only %d or %d. Try again.\n", CONS_NUM, FILE_NUM);
        else isIncorrect.set(false);
    }

    static int choosingAPath(Scanner in) {
        AtomicInteger num = new AtomicInteger(0);
        AtomicBoolean isIncorrect = new AtomicBoolean(true);
        do {
            System.out.print("Your choice: ");
            pathCondition(num, isIncorrect, in);
        } while (isIncorrect.get());

        return num.get();
    }

    static void palinCondition(AtomicBoolean isIncorrect, AtomicInteger palindrome, Scanner in) {
        try{
            palindrome.set(Integer.parseInt(in.nextLine()));
            isIncorrect.set(false);
        } catch (NumberFormatException error) {
            System.out.print("Invalid numeric input.Try again.\n");
        }
    }


    static int inputPalin(Scanner in) {
        AtomicBoolean isIncorrect = new AtomicBoolean(true);
        AtomicInteger palindrome = new AtomicInteger(0);
        do {
            System.out.print("Write your number: ");
            palinCondition(isIncorrect, palindrome, in);
        } while (isIncorrect.get());

        return palindrome.get();
    }


    static int lengthOfPalin(int palindrome) {
        int palinLen = 0;
        while (palindrome > 0) {
            palinLen++;
            palindrome /= 10;
        }

        return palinLen;
    }


    static void putInMassive(char[] arrPalin, int palindrome) {
        int i = 0;
        while (palindrome > 0) {
            arrPalin[i] = (char) (palindrome % 10);
            i++;
            palindrome = palindrome / 10;
        }
    }


    static boolean palinIsPalin(char[] arrPalin, int palinLen, int palindrome) {
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
        int palinLen = lengthOfPalin(abs(palindrome));
        char[] arrPalin = new char[palinLen];
        putInMassive(arrPalin, abs(palindrome));

        return palinIsPalin(arrPalin, palinLen, palindrome);
    }


    static void viaConsole(Scanner in) {
        int palindrome = inputPalin(in);
        if (palinCheack(palindrome) && palindrome > -1)
            System.out.print("It is palindrome.");
        else
            System.out.print("It is not a palindrome.");
    }


    static void conditionCheack(char sim, boolean isCorrect, AtomicInteger palindrome, AtomicInteger n, AtomicInteger k) {
        if (sim == '-' && !isCorrect)
            k.set(PALIN_OUTPUT_CONTROL);
        else if (sim < '0' || sim > '9')
            palindrome.set(PALIN_OUTPUT_CONTROL);
        else {
            palindrome.set(palindrome.get() + (sim - 48) * n.get());
            n.set(n.get() * 10);
        }
    }


    static void cheackForOneString(boolean isCorrect, AtomicInteger palindrome) {
        if (!isCorrect)
            palindrome.set(PALIN_OUTPUT_CONTROL);
    }

    static int inputPalinFile(FileReader fileReader) throws IOException {
        AtomicInteger palindrome = new AtomicInteger(0);
        AtomicInteger n = new AtomicInteger(1);
        AtomicInteger k = new AtomicInteger(1);
        int cs;
        char sim;
        boolean isCorrect = false;
        while ((cs = fileReader.read()) != -1 && palindrome.get() != -1) {
            sim = (char) cs;
            conditionCheack(sim, isCorrect, palindrome, n, k);
            isCorrect = true;
        }
        palindrome.set(palindrome.get() * k.get());
        cheackForOneString(isCorrect, palindrome);

        return palindrome.get();
    }

    static void outputPalin(int palindrome,File fileWay) throws IOException {
        FileWriter writer = new FileWriter(fileWay, true);
        if (palindrome == PALIN_OUTPUT_CONTROL) {
            writer.write("\nERROR.");
        }
        else if (palinCheack(palindrome))
            writer.write("\nIt is palindrome.");
        else writer.write("\nIt is not a palindrome.");
        writer.close();
    }

    static void workWithFile(String fileWay, Scanner in){
        assert fileWay != null;
        File file = new File(fileWay);
        try {
            FileReader fileReader = new FileReader(file);
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            int palindrome = inputPalinFile(fileReader);
            bufferedReader.close();
            outputPalin(palindrome, new File(fileWay));
            System.out.print("Cheack your file.");
        } catch (IOException error) {
            System.err.println("Bad File.");
        }
    }


    static void viaFile(Scanner in) {
        String fileWay;
        System.out.print("Write way to your file: ");
        fileWay = inputWay(in);
        workWithFile(fileWay, in);
    }


    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.print("The program determines whether\n\tthe entered number is a palindrome.\n\n");
        System.out.printf("Where will we work through: \n\tConsole: %d \tFile: %d\n\n", CONS_NUM, FILE_NUM);
        int option = choosingAPath(in);

        if (option == FILE_NUM) {
            viaFile(in);
        } else {
            viaConsole(in);
        }

        in.close();
    }
}
