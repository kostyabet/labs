package lab3;

import java.io.File;
import java.io.FileWriter;
import java.util.Scanner;

public class Lab3 {
    static final int FILE_KEY = 1;
    static final int CONSOLE_KEY = 2;
    static final  int MIN_ARR_SIZE = 1;
    static final int MIN_FILE_WAY_SIZE = 5;

    static void conditionOutput()
    {
        System.out.println("""
        The program is designed to sort an array
                using the simple insertion method.
        """);
    }

    static void pathConditionOutput()
    {
        System.out.printf("""
                Where will we work through:\s
                        File: %d Console: %d
                        
                """, FILE_KEY, CONSOLE_KEY);
    }

    static void fileRestriction()
    {
        System.out.print("""
                        
                *The first number is the number of elements
                of the array, and subsequent numbers of this array*
                Write way to your file:\s""");
    }

    static int choosingAPath(Scanner in)
    {
        int path = 0;
        boolean isIncorrect = true;

        pathConditionOutput();

        System.out.print("Please write were we should work: ");
        do
        {
            boolean isCorrect = false;

            try
            {
                path = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch(Exception error)
            {
                System.err.print("Error. You should write a one natural number. Try again: ");
            }

            if (path == CONSOLE_KEY || path == FILE_KEY)
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

    static int arrSizeInputFromConsole(Scanner in)
    {
        int arrSize = 0;
        boolean isIncorrect = true;

        System.out.print("Write your arr size: ");
        do
        {
            boolean isCorrect = false;

            try
            {
                arrSize = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch(Exception error)
            {
                System.err.print("Invalid numeric input. Try again: ");
            }

            if (arrSize < MIN_ARR_SIZE && isCorrect)
            {
                System.err.printf("Minimal arr size is: %d. Try again: ", MIN_ARR_SIZE);
            }
            else if (isCorrect)
            {
                isIncorrect = false;
            }
        } while (isIncorrect);

        return arrSize;
    }

    static int inputCurrentNumbFromConsole(Scanner in)
    {
        int currentNumb = 0;
        boolean isIncorrect = true;

        do
        {
            try
            {
                currentNumb = Integer.parseInt(in.nextLine());
                isIncorrect = false;
            } catch(Exception error)
            {
                System.err.print("Invalid numeric input. Try again: ");
            }

        } while (isIncorrect);

        return currentNumb;
    }

    static boolean isCorrectArrOfNumbInputFromConsole(int arrSize, int[] arrOfNumb, Scanner in)
    {
        for (int i = 0; i < arrSize; i++)
        {
            System.out.printf("Write your %d number: ", i + 1);
            arrOfNumb[i] = inputCurrentNumbFromConsole(in);
        }

        return false;
    }

    static boolean isCanOpenFile(String way)
    {
        File file = new File(way);

        return file.canRead();
    }

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

    static String inputPath(Scanner in)
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


    static String inputPathToTheFile(Scanner in)
    {
        String fileWay;
        boolean isIncorrect = true;

        do
        {
            fileWay = inputPath(in);

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

    static int arrSizeInputFromFile(String fileWay)
    {
        int arrSize;
        try (Scanner fileScanner = new Scanner(new File(fileWay))){
            arrSize = Integer.parseInt(fileScanner.nextLine());
        } catch(Exception error){
            System.err.print("Error in input size of massive. Try again: ");
            arrSize = -1;
        }
        if (arrSize < MIN_ARR_SIZE)
        {
            System.err.printf("Minimal arr size is %d. Try again: ", MIN_ARR_SIZE);
            arrSize = -1;
        }

        return arrSize;
    }

    static boolean isCorrectArrOfNumbInputFromFile(int arrSize,int[] arrOfNumb,String fileWay)
    {
        if (arrSize == -1)
            return true;

        try (Scanner fileScanner = new Scanner(new File(fileWay)))
        {
            fileScanner.nextInt();
            for (int i = 0; i < arrSize; i++)
            {
                arrOfNumb[i] = fileScanner.nextInt();
            }

            if (fileScanner.hasNext())
                return true;

        } catch(Exception error)
        {
            System.err.print("Error in reading massive elements. Try again: ");
            return true;
        }

        return false;
    }

    static void sortMassive(int[] arrOfNumb, int arrSize)
    {
        int temp;

        for (int i = 1; i < arrSize; i++)
        {
            temp = arrOfNumb[i];

            int j = i - 1;
            while (j >= 0 && arrOfNumb[j] > temp)
            {
                arrOfNumb[j + 1] = arrOfNumb[j];
                arrOfNumb[j] = temp;
                j--;
            }
        }
    }

    static void outputFromFile(int[] arrOfNumb, int arrSize, Scanner in)
    {
        boolean isIncorrect = true;

        System.out.print("Write way to your file: ");
        do
        {
            String fileWay = inputPath(in);
            File file = new File(fileWay);
            StringBuilder builder;
            if (file.canWrite())
            {
                try
                {
                    FileWriter writer = new FileWriter(fileWay);
                    builder = new StringBuilder();
                    for (int i = 0 ; i < arrSize; i++)
                        builder.append(arrOfNumb[i]).append(" ");
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

    static void outputFromConsole(int[] arrOfNumb, int arrSize)
    {
        for (int i = 0; i < arrSize; i++)
        {
            System.out.printf("%d ", arrOfNumb[i]);
        }
    }

    static void resultOutput(int[] arrOfNumb, int arrSize, Scanner in)
    {
        System.out.println("You need to choose where to write information from.");
        int path = choosingAPath(in);
        if (path == CONSOLE_KEY)
        {
            outputFromConsole(arrOfNumb, arrSize);
        }
        else
        {
            outputFromFile(arrOfNumb, arrSize, in);
        }
    }

    static String inputFileWay(Scanner in, int path){
        return path == FILE_KEY ? inputPathToTheFile(in) : "";
    }

    static int arrSizeInput(Scanner in, int path, String fileWay){
        return path == FILE_KEY ? arrSizeInputFromFile(fileWay) : arrSizeInputFromConsole(in);
    }

    static boolean inputArrOfNumb(int arrSize,int[] arrOfNumb,int path,String fileWay,Scanner in){
        return path == FILE_KEY ? isCorrectArrOfNumbInputFromFile(arrSize, arrOfNumb, fileWay) : isCorrectArrOfNumbInputFromConsole(arrSize, arrOfNumb, in);
    }

    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);

        int arrSize;
        int[] arrOfNumb = new int[0];

        conditionOutput();

        System.out.println("\nYou need to choose where to read information from.");

        int path = choosingAPath(in);

        boolean isIncorrect;
        if (path == FILE_KEY)
            fileRestriction();

        do {
            String fileWay = inputFileWay(in, path);
            arrSize = arrSizeInput(in, path, fileWay);
            if (arrSize != -1)
                arrOfNumb = new int [arrSize];
            isIncorrect = inputArrOfNumb(arrSize, arrOfNumb, path, fileWay, in);
        } while (isIncorrect);

        sortMassive(arrOfNumb, arrSize);

        resultOutput(arrOfNumb, arrSize, in);

        in.close();
    }
}