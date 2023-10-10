package lab2;

import java.io.*;
import java.util.Scanner;

public class lab3 {
    static int choosingAPath(Scanner in, final int CONSOLE, final int FILE){
        System.out.print("Your choice: ");
        int num = 0;
        boolean isIncorrect = true;
        do{
            try{
                num = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException error){
                System.err.print("Invalid numeric input.\nTry again.\n");
            }
            if (num != CONSOLE && num != FILE)
                System.out.printf("Choose only %d or %d.\n", CONSOLE, FILE);
            else
                isIncorrect = false;
        } while (isIncorrect);

        return num;
    }


    static String inputWay(Scanner in){
        String way = null;
        boolean isIncorrect = true;
        do{
            way = in.nextLine();
            if (way.length() > 4) {
                String bufstr = way.substring(way.length() - 4, way.length() - 1);
                if (bufstr.equals(".txt"))
                    return way;
                else
                    System.out.print("Write .txt file");
            }
            else
                System.out.print("short string");
        } while (isIncorrect);

        return way;
    }


    static boolean isPalindrome(String palindrome){
        for (int i = 0; i < palindrome.length() / 2; i++) {
            if (palindrome.charAt(i) != palindrome.charAt(palindrome.length() - (i + 1)))
                return false;
        }

        return true;
    }


    static String viaConsole(Scanner in){
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

    static String viaFile(Scanner in){
        String fileWay;
        boolean isIncorrect = true;
        do{
            System.out.print("Write way to your file: ");
            fileWay = inputWay(in);
            File file = new File("example.txt");

            try {
                FileReader fileReader = new FileReader(file); // Создание объекта FileReader
                BufferedReader bufferedReader = new BufferedReader(fileReader); // Создание объекта BufferedReader
                String palindrome;
                palindrome = bufferedReader.readLine();
                bufferedReader.close();
                return workWithPalin(palindrome);
            } catch (IOException error) {
                System.err.println("Bad File. Try again.\n");
            }
        } while (isIncorrect);
        return null;
    }


    public static void main(String[] args){
        final int CONSNUM = 1;
        final int FILENUM = 2;

        Scanner in = new Scanner(System.in);

        System.out.print("The program determines whether\n\t the entered string is a palindrome.\n\n");
        System.out.printf("Where will we work through: \n\tConsole: %d \tFile: %d \n\n", CONSNUM, FILENUM);
        int option = choosingAPath(in, CONSNUM, FILENUM);

        String result = (option == FILENUM ? viaFile(in) : viaConsole(in));
        System.out.printf("It is %d", result);
        in.close();
    }
}
