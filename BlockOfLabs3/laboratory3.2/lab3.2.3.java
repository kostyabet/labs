package lab3;

import java.io.File;
import java.io.FileWriter;
import java.util.*;

public class Lab2 {
    static Scanner in = new Scanner(System.in);
    static final int MIN_FILE_WAY_SIZE = 5;
    static final int MIN_SIZE = 1;
    static final int GOOD_SIZE = 1;
    static final int BAD_SIZE = 2;
    static final int FILE_KEY = 1;
    static final int CONSOLE_KEY = 2;

    // block of work with errors
    public enum IOError
    {
        INVALID_PATH,
        METHOD_ERROR,
        SHORT_PATH_ERROR,
        TXT_ERROR,
        OPEN_FILE_ERROR,
        MIN_SIZE_ERROR,
        FIRST_STR_ERROR,
        EL_ERROR,
        TRY_AGAIN
    }
    static final String[] ERRORS =
            {
                    "Error. You should write a natural number.",
                    "Error method.",
                    "The path is too short.",
                    "Write .txt file.",
                    "Can't open a file.",
                    "Min number of elements is " + MIN_SIZE + ".",
                    "First string is natural number.",
                    "Enter a specific number of characters.",
                    " Try again: "
            };
    static void printError(String IOErrorMethod)
    {
        System.err.print(IOErrorMethod + ERRORS[lab3.Lab2.IOError.TRY_AGAIN.ordinal()]);
    }
    // block of text output
    static void taskOutput()
    {
        System.out.println("""
                the program builds and prints a set, the elements
                of which are the signs of arithmetic operations and
                numbers occurring in the sequence.
                """);
    }
    static void workWayConditionOutput()
    {
        System.out.printf("""
                Where will we work through:
                        File: %d
                        Console: %d
                        
                """, FILE_KEY, CONSOLE_KEY);
    }
    static void fileRestriction()
    {
        System.out.print("""
            
            1.  The first line in the file is a natural number -
            N characters of the second line;
            2.  The second line is N characters entered by the user.
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
            boolean isCorrectInput = false;
            try {
                path = Integer.parseInt(in.nextLine());
                isCorrectInput = true;
            } catch(Exception error){
                printError(ERRORS[lab3.Lab2.IOError.INVALID_PATH.ordinal()]);
            }
            if (path == CONSOLE_KEY || path == FILE_KEY)
            {
                isIncorrect = false;
            }
            else if (isCorrectInput)
            {
                printError(ERRORS[lab3.Lab2.IOError.METHOD_ERROR.ordinal()]);
            }
        } while (isIncorrect);

        return path;
    }
    // input and check path to the file
    static boolean pathCondition(String way)
    {
        if (way.length() < MIN_FILE_WAY_SIZE)
        {
            printError(ERRORS[lab3.Lab2.IOError.SHORT_PATH_ERROR.ordinal()]);
            return false;
        }
        String bufstr = way.substring(way.length() - 4);
        if (!bufstr.equals(".txt"))
        {
            printError(ERRORS[lab3.Lab2.IOError.TXT_ERROR.ordinal()]);
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
                printError(ERRORS[lab3.Lab2.IOError.MIN_SIZE_ERROR.ordinal()]);
            }
            else
            {
                isIncorrect = false;
            }
        } while (isIncorrect);

        return fileWay;
    }
    /// input from console
    static boolean checkSizeCondition(int size, boolean isIncorrectInput)
    {
        if (size < MIN_SIZE && !isIncorrectInput)
        {
            printError(ERRORS[lab3.Lab2.IOError.MIN_SIZE_ERROR.ordinal()]);
            return true;
        }

        return isIncorrectInput;
    }
    static int inputSizeFromConsole()
    {
        int size = 0;
        boolean isIncorrect;

        System.out.print("How many characters do you want to enter: ");
        do
        {
            boolean isIncorrectInput = true;
            try {
                size = Integer.parseInt(in.nextLine());
                isIncorrectInput = false;
            } catch (Exception error){
                printError(ERRORS[lab3.Lab2.IOError.INVALID_PATH.ordinal()]);
            }
            isIncorrect = checkSizeCondition(size, isIncorrectInput);
        } while (isIncorrect);

        return size;
    }
    static boolean isCorrectElementsInputFromConsole(int size, String str)
    {
        if (size != str.length())
        {
            printError(ERRORS[lab3.Lab2.IOError.EL_ERROR.ordinal()]);
        }
        else
        {
            return false;
        }

        return true;
    }
    static char[] inputStringFromConsole(int[] arrSize)
    {
        boolean isIncorrect;
        int size = inputSizeFromConsole();
        char[] arrOfElements = new char[size];
        arrSize[0] = size;

        System.out.printf("Write your %d elements: ", size);
        do
        {
            String str = in.nextLine();
            for (int i = 0; i < size && size == str.length(); i++)
            {
                arrOfElements[i] = str.charAt(i);
            }
            isIncorrect = isCorrectElementsInputFromConsole(size, str);
        } while (isIncorrect);

        return arrOfElements;
    }
    // input from file
    static int checkSizeInputFromFile(int size, int[] arrSize)
    {
        if (size < MIN_SIZE && arrSize[1] != BAD_SIZE)
        {
            printError(ERRORS[lab3.Lab2.IOError.MIN_SIZE_ERROR.ordinal()]);
            return BAD_SIZE;
        }

        return GOOD_SIZE;
    }
    static int inputSizeFromFile(Scanner fileScanner, int[] arrSize)
    {
        int size = 0;
        try {
            size = Integer.parseInt(fileScanner.nextLine());
        } catch(Exception error) {
            printError(ERRORS[lab3.Lab2.IOError.FIRST_STR_ERROR.ordinal()]);
            arrSize[1] = BAD_SIZE;
        }
        arrSize[1] = checkSizeInputFromFile(size, arrSize);

        return size;
    }
    static boolean isCorrectElInputFromFile(int size, String str)
    {
        if (size != str.length())
        {
            printError(ERRORS[lab3.Lab2.IOError.EL_ERROR.ordinal()]);
            return true;
        }

        return false;
    }
    static boolean inputSetFromFile(char[] arrOfElements, int size, int sizeSignal,Scanner fileScanner)
    {
        if (sizeSignal == BAD_SIZE)
        {
            return true;
        }

        String str = fileScanner.nextLine();
        for (int i = 0; i < size && size == str.length(); i++){
            arrOfElements[i] = str.charAt(i);
        }

        return isCorrectElInputFromFile(size, str);
    }
    static char[] inputStringFromFile(int[] arrSize)
    {
        fileRestriction();
        char[] arrOfElements = new char[0];
        boolean isIncorrect = true;
        do
        {
            String fileWay = inputPathToTheFile();
            try (Scanner fileScanner = new Scanner(new File(fileWay))){
                arrSize[0] = inputSizeFromFile(fileScanner, arrSize);
                if (arrSize[1] == GOOD_SIZE) {
                    arrOfElements = new char[arrSize[0]];
                }
                isIncorrect = inputSetFromFile(arrOfElements, arrSize[0], arrSize[1], fileScanner);
            } catch (Exception error) {
                printError(ERRORS[lab3.Lab2.IOError.OPEN_FILE_ERROR.ordinal()]);
            }
        } while (isIncorrect);

        return arrOfElements;
    }
    // making the set
    static void addEntitlements(Set<Character> Entitlements){
        Collection<Character> AddList = Arrays.asList('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '/', '*');
        Entitlements. addAll(AddList);
    }
    static void renderingSet(char[] arrOfElements, int size, Set<Character> resultSet, Set<Character> Entitlements)
    {
        for (int i = 0; i < size; i++)
        {
            for (char current : Entitlements)
            {
                if (arrOfElements[i] == current)
                {
                    resultSet.add(arrOfElements[i]);
                }
            }
        }
    }
    // output from file
    static String outputSetInFile(Set<Character> resultSet)
    {
        StringBuilder res = new StringBuilder();
        for (char currentElement : resultSet)
        {
            res.append(" '").append(currentElement).append("';");
        }

        return res.toString();
    }
    static String outputResInFile(Set<Character> resultSet)
    {

        String res = "The result is:";
        if (resultSet.isEmpty())
        {
            res += " empty set.";
        }
        else
        {
            res += outputSetInFile(resultSet);
        }

        return res;
    }
    static void outputFromFile(Set<Character> resultSet)
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
                    String result = outputResInFile(resultSet);
                    builder.append(result);
                    writer.write(builder.toString());
                    writer.close();
                    System.out.print("Check your file.");
                    isIncorrect = false;
                } catch (Exception error)
                {
                    printError(ERRORS[lab3.Lab2.IOError.OPEN_FILE_ERROR.ordinal()]);
                }
            }
            else
            {
                System.err.print("Can't open a file. Try write another way: ");
            }
        } while (isIncorrect);
        //
    }
    // output from console
    static void outputSetFromConsole(Set<Character> resultSet)
    {
        for (char currentElement : resultSet)
        {
            System.out.printf(" '%c';", currentElement);
        }
    }
    static void outputFromConsole(Set<Character> resultSet)
    {
        System.out.print("The result is:");
        if (resultSet.isEmpty())
        {
            System.out.print(" empty set.");
        }
        else
        {
            outputSetFromConsole(resultSet);
        }
    }
    // distributive output
    static void resultOutputSystem(Set<Character> resultSet)
    {
        System.out.print("\nYou need to choose where to write information from.\n");
        int path = choosingWorkWay();
        if (path == CONSOLE_KEY) {
            outputFromConsole(resultSet);
        } else {
            outputFromFile(resultSet);
        }
    }
    // main distributive func
    static char[] inputSystem(int[] arrSize)
    {
        int path = choosingWorkWay();
        return path == CONSOLE_KEY ? inputStringFromConsole(arrSize)
                : inputStringFromFile(arrSize);
    }
    //main
    public static void main(String[] args)
    {
        taskOutput();

        int[] arrSize = new int[2];
        char[] arrOfElements = inputSystem(arrSize);

        Set<Character> resultSet = new HashSet<>();
        Set<Character> Entitlements = new HashSet<>();
        addEntitlements(Entitlements);
        renderingSet(arrOfElements, arrSize[0], resultSet, Entitlements);

        resultOutputSystem(resultSet);

        in.close();
    }
}