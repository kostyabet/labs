package lab3;

import java.io.File;
import java.io.FileWriter;
import java.util.Scanner;

public class Lab1 {
    static Scanner in = new Scanner(System.in);
    static final int MIN_K = 1;
    static final int ERR_VALUE_OF_K = -1;
    static final int VALUE_OF_DEFAULT_RESULT = -1;
    static final int STANDARD_NUMBER_OF_STRINGS = 2;
    static final int MIN_FILE_WAY_SIZE = 5;
    static final int FILE_KEY = 1;
    static final int CONSOLE_KEY = 2;
    //text information output block
    static void conditionOutput()
    {
        System.out.println("""
                The program determines the position number K
                of the occurrence of the first line in the second.
                If there are no matches, returns -1.
                """);
    }
    static void workWayConditionOutput()
    {
        System.out.printf("""
                Where will we work through:
                        File: %d Console: %d
                
                """, FILE_KEY, CONSOLE_KEY);
    }
    static void fileRestriction()
    {
        System.out.print("""
        
                *the first number in the file is the number
                of the occurrence the index of which you want to find,
                and after that the substring and the string*
                Write way to your file:\s""");
    }
    // choice of direction
    static int choosingWorkWay()
    {
        workWayConditionOutput();

        int path = 0;
        boolean isIncorrect = true;
        System.out.print("Please write were we should work: ");
        do
        {
            boolean isCorrect = false;
            try {
                path = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch (Exception error) {
                System.err.print("Error. You should write a natural number. Try again: ");
            }
            if ((path == CONSOLE_KEY || path == FILE_KEY))
            {
                isIncorrect = false;
            }
            else if (isCorrect)
            {
                System.err.print("Error method. Try again: ");
            }
        } while (isIncorrect);

        return path;
    }
    // input and check path to the file
    static boolean pathCondition(String way)
    {
        if (way.length() < MIN_FILE_WAY_SIZE)
        {
            System.err.print("The path is too short. Try again: ");
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
    static String inputPath()
    {
        String way;
        boolean isIncorrect;
        do
        {
            way = in.nextLine();
            isIncorrect = !pathCondition(way);
        } while (isIncorrect);

        return way;
    }
    static boolean isCanOpenFile(String way)
    {
        File file = new File(way);
        return file.canRead();
    }
    static String inputPathToTheFile()
    {
        String fileWay;
        boolean isIncorrect = true;

        do
        {
            fileWay = inputPath();
            if (!isCanOpenFile(fileWay))
            {
                System.err.print("Can't open a file. Try write another way: ");
            }
            else
            {
                isIncorrect = false;
            }
        } while (isIncorrect);

        return fileWay;
    }
    // input from file
    static int inputKFromFile(String fileWay) {
        int k = 0;
        boolean isCorrect = false;

        try (Scanner fileScanner = new Scanner(new File(fileWay))){
            k = Integer.parseInt(fileScanner.nextLine());
            isCorrect = true;
        } catch(Exception error)
        {
            System.err.print("First string is natural number. Try again: ");
        }

        if (k < MIN_K && isCorrect)
        {
            System.err.printf("Min position number is %d. Try again: ", MIN_K);
            k = ERR_VALUE_OF_K;
        }

        return k;
    }
    static void inputStringFromFile(Scanner fileScanner, String[] str)
    {
        str[0] = fileScanner.nextLine();
        str[1] = fileScanner.nextLine();
    }
    static void settingTheCursor(Scanner fileScanner)
    {
        fileScanner.nextLine();
    }
    static boolean checkEndOfFile(Scanner fileScanner)
    {
        if (fileScanner.hasNextLine()) {
            System.err.print("In file should be only 1 number and 2 strings. Try again: ");
            return false;
        }

        return true;
    }
    static void sysOfInputStringsFromFile(Scanner fileScanner, String[] str)
    {
        settingTheCursor(fileScanner);
        inputStringFromFile(fileScanner, str);
    }
    /// input from console
    static boolean checkKCondition(int k, boolean isCorrect)
    {
        if (!isCorrect)
            return true;

        if (k < MIN_K)
        {
            System.err.printf("Min position number is %d. Try again: ", MIN_K);
        }
        else
        {
            return false;
        }

        return true;
    }
    static int inputKFromConsole()
    {
        int k = 0;
        System.out.print("The position numbers of which occurrence you want to find: ");
        boolean isIncorrect;
        do
        {
            boolean isCorrect = false;
            try {
                k = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch(Exception error){
                System.err.print("First string is natural number. Try again: ");
            }
            isIncorrect = checkKCondition(k, isCorrect);
        } while (isIncorrect);

        return k;
    }
    static String inputStringFromConsole() {
        return in.nextLine();
    }
    static boolean isCorrectInput(String str1, String str2, boolean isItEndOfFile)
    {
        if (str1.isEmpty() || str2.isEmpty())
        {
            System.err.print("Bad strings input. Try again: ");
            return false;
        }

        return isItEndOfFile;
    }
    static void sysOfInputStringsFromConsole(String[] str) {
        System.out.print("Write your first string: ");
        str[0] = inputStringFromConsole();
        System.out.print("Write your second string: ");
        str[1] = inputStringFromConsole();
    }
    /// search for result
    static boolean isStringsEqual(String str1, String str2, int i) {
        for (int j = 1; j < str1.length(); j++)
        {
            if (str2.charAt(i + j) != str1.charAt(j))
            {
                return false;
            }
        }

        return true;
    }
    static int calculationOfTheResult(int k, String str1, String str2)
    {
        if (str2.length() < str1.length())
        {
            return VALUE_OF_DEFAULT_RESULT;
        }

        for (int i = 0; i < str2.length(); i++)
        {
            if (str1.charAt(0) == str2.charAt(i))
            {
                boolean isCorrect = isStringsEqual(str1, str2, i);
                if (--k == 0 && isCorrect)
                {
                    return i + 1;
                }
            }
        }

        return VALUE_OF_DEFAULT_RESULT;
    }
    /// output
    static void outputFromFile(int result)
    {
        boolean isIncorrect = true;
        System.out.print("Write way to your file: ");
        do
        {
            String fileWay = inputPathToTheFile();
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
    static void outputFromConsole(int result)
    {
        System.out.println(result);
    }
    static void resultOutput(int result)
    {
        System.out.println("You need to choose where to write information from.");
        int path = choosingWorkWay();
        if (path == CONSOLE_KEY)
        {
            outputFromConsole(result);
        } else
        {
            outputFromFile(result);
        }
    }
    // block of distributive functions
    static String inputFileWay(int path)
    {
        return path == CONSOLE_KEY ? "" : inputPathToTheFile();
    }
    static int kInput(int path, String fileWay)
    {
        return path == CONSOLE_KEY ? inputKFromConsole() : inputKFromFile(fileWay);
    }
    static boolean isCorrectStringsInput(int path, String fileWay, String[] str, int k) {
        if (k == ERR_VALUE_OF_K)
        {
            return false;
        }

        if (path == CONSOLE_KEY)
        {
            sysOfInputStringsFromConsole(str);
            return true;
        }
        else
        {
            boolean isItEndOfFile = true;
            try (Scanner fileScanner = new Scanner(new File(fileWay))){
                sysOfInputStringsFromFile(fileScanner, str);
                isItEndOfFile = checkEndOfFile(fileScanner);
            } catch(Exception error){
                System.err.print("Error file read opening. Try again: ");
            }
            return isCorrectInput(str[0], str[1], isItEndOfFile);
        }
    }
    // input distributive
    static int inputSystem(String[] str)
    {
        System.out.println("You need to choose where to read information from.");
        int path = choosingWorkWay();

        if (path == FILE_KEY)
        {
            fileRestriction();
        }

        int k;
        boolean isIncorrect;
        do
        {
            String fileWay = inputFileWay(path);
            for (int i = 0; i < STANDARD_NUMBER_OF_STRINGS; i++)
                str[i] = "";
            k = kInput(path, fileWay);
            isIncorrect = !isCorrectStringsInput(path, fileWay, str, k);
        } while (isIncorrect);

        return k;
    }
    // main
    public static void main(String[] args)
    {
        conditionOutput();

        String[] str = new String[STANDARD_NUMBER_OF_STRINGS];
        int k = inputSystem(str);

        int result = calculationOfTheResult(k, str[0], str[1]);

        resultOutput(result);

        in.close();
    }
}