package lab3;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.Scanner;

public class Lab1
{
    static final int FILE_KEY = 1;
    static final int CONSOLE_KEY = 2;
    static final int MIN_K = 1;
    static final int MIN_FILE_WAY_SIZE = 5;
    static void conditionOutput()
    {
        System.out.println("""
                The program determines the position number K
                of the occurrence of the first line in the second.
                If there are no matches, returns -1.
                """);
    }
    static void pathConditionOutput()
    {
        System.out.printf("Where will we work through: \n\tFile: %d Console: %d\n\n", FILE_KEY, CONSOLE_KEY);
    }
    static void fileRestriction()
    {
        System.out.println("\n*the first number in the file\n\t should be a number, followed by 2 lines*");
    }
    static int choosingAPath(Scanner in)
    {
        pathConditionOutput();
        int path = 0;
        boolean isIncorrect = true;
        System.out.print("Please write were we should work: ");
        do
        {
            boolean isCorrect = false;
            try
            {
                path = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch (NumberFormatException error)
            {
                System.err.print("Error. You should write a number. Try again: ");
            }
            if (path != CONSOLE_KEY && path != FILE_KEY && isCorrect)
            {
                System.err.print("Error method. Try again: ");
            }
            else if (isCorrect)
            {
                isIncorrect = false;
            }
        } while (isIncorrect);
        return path;
    }
    // input way
    static boolean wayCondition(String way)
    {
        if (way.length() < MIN_FILE_WAY_SIZE)
        {
            System.out.println("The path is too short. Try again: ");
            return false;
        }
        String bufstr = way.substring(way.length() - 4);
        if (!bufstr.equals(".txt"))
        {
            System.err.print("Write .txt file. Try again: ");
            return false;
        }
        return true;
    }
    static String inputWayToTheFile(Scanner in)
    {
        String way;
        boolean isIncorrect;
        do
        {
            way = in.nextLine();
            isIncorrect = !wayCondition(way);
        } while (isIncorrect);
        return way;
    }
    /// input from file
    static boolean isCanOpenFile(String way)
    {
        File file = new File(way);
        return file.canRead();
    }
    static String inputFile(Scanner in)
    {
        String fileWay;
        boolean isIncorrect = true;
        do
        {
            fileWay = inputWayToTheFile(in);
            if (!isCanOpenFile(fileWay))
            {
                System.err.print("Can't open a file. Try write another way: ");
            } else
            {
                isIncorrect = false;
            }
        } while (isIncorrect);
        return fileWay;
    }
    static boolean afterReadingCheck(Scanner in, boolean isCorrect, String str1, String str2)
    {
        if ((str1 == null || str2 == null) && isCorrect)
        {
            isCorrect = false;
            System.out.print("There cannot be empty lines. Try again: ");
        }
        if (in.hasNext() && isCorrect)
        {
            isCorrect = false;
            System.out.print("The file should only contain 1 number and 2 lines. Try again: ");
        }
        return isCorrect;
    }
    /// input from console
    static boolean checkKCondition(int k)
    {
        boolean isIncorrect = true;
        if (k < MIN_K)
        {
            System.err.printf("Min position number is %d. Try again: ", MIN_K);
        }
        else
        {
            isIncorrect = false;
        }
        return isIncorrect;
    }
    static int inputKFromConsole(Scanner in)
    {
        int k = 0;
        System.out.print("The position numbers of which occurrence you want to find: ");
        boolean isIncorrect = true;
        do
        {
            try
            {
                k = Integer.parseInt(in.next());
                isIncorrect = false;
            } catch(NumberFormatException error)
            {
                System.err.print("You should write a number. Try again: ");
            }
            if (!isIncorrect)
            {
                isIncorrect = checkKCondition(k);
            }
        } while (isIncorrect);
        return k;
    }
    /// check condition
    static int calculationOfTheResult(int k, String str1, String str2)
    {
        for (int i = 0; i < str2.length(); i++)
        {
            if (str1.charAt(0) == str2.charAt(i))
            {
                boolean isCorrect = true;
                for (int j = 1; j < str1.length(); j++)
                {
                    if (str2.charAt(i + j) != str1.charAt(j))
                    {
                        isCorrect = false;
                    }
                }
                if (--k == 0 && isCorrect)
                {
                    return i + 1;
                }
            }
        }
        return -1;
    }
    /// output from file
    static void outputFromFile(int result, Scanner in)
    {
        boolean isIncorrect = true;
        System.out.print("Write way to your file: ");
        do
        {
            String fileWay = inputWayToTheFile(in);
            File file = new File(fileWay);
            StringBuilder builder;
            if (file.canWrite())
            {
                try
                {
                    FileWriter writer = new FileWriter(fileWay);
                    builder = new StringBuilder();
                    builder.append(result);
                    writer.write(builder.toString());
                    writer.close();
                    System.out.print("Check your file.");
                    isIncorrect = false;
                } catch (Exception error)
                {
                    System.err.print("Can't write in this file. Try again: ");
                }
            }
            else
            {
                System.err.print("Can't open a file. Try write another way: ");
            }
        } while (isIncorrect);
    }
    /// output from console
    static void outputFromConsole(int result)
    {
        System.out.println(result);
    }
    /// block of main void-s
    static void resultOutput(int result, Scanner in)
    {
        System.out.println("You need to choose where to write information from.");
        int path = choosingAPath(in);
        if (path == CONSOLE_KEY)
        {
            outputFromConsole(result);
        } else
        {
            outputFromFile(result, in);
        }
    }
    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);
        conditionOutput();
        int k = 0;
        String str1 = null, str2 = null;
        System.out.println("\nYou need to choose where to read information from.");
        int path = choosingAPath(in);
        if (path == CONSOLE_KEY)
        {
            k = inputKFromConsole(in);
            System.out.print("Write your first string: ");
            str1 = in.nextLine();
            System.out.print("Write your second string: ");
            str2 = in.nextLine();
            in.close();
        }
        else
        {
            boolean isIncorrect = false;
            fileRestriction();
            System.out.print("Write way to your file: ");
            do
            {
                boolean isCorrect = true;
                String fileWay = inputFile(in);
                try
                {
                    Scanner fileScanner = new Scanner(new File(fileWay));
                    if (!fileScanner.hasNextInt())
                    {
                        isCorrect = false;
                    } else
                    {
                        try
                        {
                            k = fileScanner.nextInt();
                            str1 = fileScanner.next();
                            str2 = fileScanner.next();
                        } catch (NumberFormatException error)
                        {
                            isCorrect = false;
                            System.err.print("Error in reading. Try another file: ");
                        }
                        if (k < MIN_K && isIncorrect)
                        {
                            isCorrect = false;
                            System.err.printf("Number should be %d and higher.", MIN_K);
                        }
                    }
                    isIncorrect = !afterReadingCheck(fileScanner, isCorrect, str1, str2);
                    fileScanner.close();
                } catch (FileNotFoundException error)
                {
                    System.err.print("File not found. Try again: ");
                }
            } while (isIncorrect);
        }
        assert str2 != null;
        int result = calculationOfTheResult(k, str1, str2);
        resultOutput(result, in);
        in.close();
    }
}