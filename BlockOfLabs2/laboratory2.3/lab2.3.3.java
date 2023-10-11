package lab2;

import java.io.*;
import java.util.Scanner;

public class lab3 {
    static final int CONS_NUM = 1;
    static final int FILE_NUM = 2;
    static int choosingAPath(Scanner in) {
        System.out.print("Your choice: ");
        int num = 0;
        boolean isIncorrect = true;
        do {
            try {
                num = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException error) {
                System.err.print("Invalid numeric input. Try again.\n");
            } if (num != CONS_NUM && num != FILE_NUM)
                System.err.printf("Choose only %d or %d.\n", CONS_NUM, FILE_NUM);
            else
                isIncorrect = false;
        } while (isIncorrect);

        return num;
    }


    static String inputWay(Scanner in) {
        String way = null;
        boolean isIncorrect = true;
        do {
            way = in.nextLine();
            if (way.length() > 4) {
                String bufstr = way.substring(way.length() - 4);
                if (bufstr.equals(".txt"))
                    return way;
                else
                    System.err.print("Write .txt file.\n");
            }
            else
                System.err.print("The path is too short.\n");
        } while (isIncorrect);

        return null;
    }


    static boolean isPalindrome(String palindrome) {
        for (int i = 0; i < palindrome.length() / 2; i++) {
            if (palindrome.charAt(i) != palindrome.charAt(palindrome.length() - (i + 1)))
                return false;
        }

        return true;
    }


    static String viaConsole(Scanner in) {
        System.out.print("Write your string: ");
        String palindrome;
        palindrome = in.nextLine();
        if (isPalindrome(palindrome))
            return "palindrome";
        else
            return "not a palindrome";
    }


    static String workWithPalin(String palindrome) {
        if (isPalindrome(palindrome))
            return "palindrome(" + palindrome + ").";
        else
            return "not a palindrome(" + palindrome + ").";
    }

    static String viaFile(Scanner in) {
        String fileWay;
        boolean isIncorrect = true;
        do {
            System.out.print("Write way to your file: ");
            fileWay = inputWay(in);
            assert fileWay != null;
            File file = new File(fileWay);
            try {
                FileReader fileReader = new FileReader(file);
                BufferedReader bufferedReader = new BufferedReader(fileReader);
                String palindrome;
                palindrome = bufferedReader.readLine();
                System.out.print(palindrome);
                bufferedReader.close();
                return workWithPalin(palindrome);
            } catch (IOException error) {
                System.err.println("Bad File. Try again.\n");
            }
        } while (isIncorrect);
        return null;
    }


    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);

        System.out.print("The program determines whether\n\t the entered string is a palindrome.\n\n");
        System.out.printf("Where will we work through: \n\tConsole: %d \tFile: %d \n\n", CONS_NUM, FILE_NUM);
        int option = choosingAPath(in);

        String result = (option == FILE_NUM ? viaFile(in) : viaConsole(in));
        System.out.printf("It is %s", result);
        in.close();
    }
}