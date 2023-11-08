package lab3;

import java.io.File;
import java.io.FileNotFoundException;
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
        System.out.println("""
        
        *The first number is the number of elements
        of the array, and subsequent numbers of this array*
        """);
    }

    static int choosingAPath(Scanner in)
    {
        int path = 0;
        boolean isIncorrect = true;

        pathConditionOutput();

        do
        {
            boolean isCorrect = false;

            System.out.print("Please write were we should work: ");
            try
            {
                path = Integer.parseInt(in.nextLine());
                isCorrect = true;
            } catch(Exception error)
            {
                System.err.println("Error. You should write a one natural number. Try again.");
            }

            if (path == CONSOLE_KEY || path == FILE_KEY)
            {
                isIncorrect = false;
            }
            else if (isCorrect)
            {
                System.err.println("Error method. Try again.");
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
                System.out.print("Invalid numeric input. Try again: ");
            }

            if (arrSize < MIN_ARR_SIZE && isCorrect)
            {
                System.out.printf("Minimal arr size is: %d. Try again: ", MIN_ARR_SIZE);
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
                System.out.print("Invalid numeric input. Try again: ");
            }

        } while (isIncorrect);

        return currentNumb;
    }

    static void arrOfNumbInputFromConsole(int arrSize, int[] arrOfNumb, Scanner in)
    {
        for (int i = 0; i < arrSize; i++)
        {
            System.out.printf("Write your %d number: ", i + 1);
            arrOfNumb[i] = inputCurrentNumbFromConsole(in);
        }
    }

    static boolean isCanOpenFile(String way)
    {
        File file = new File(way);

        return file.canRead();
    }

    static boolean wayCondition(String way)
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
            }
            else
            {
                isIncorrect = false;
            }
        } while (isIncorrect);

        return fileWay;
    }

    static boolean arrSizeInputFromFile(int arrSize)
    {
        boolean isIncorrect = true;

        if (arrSize < MIN_ARR_SIZE)
        {
            System.out.printf("Minimal arr size is %d. Try again: ", MIN_ARR_SIZE);
        }
        else
        {
            isIncorrect = false;
        }

        return isIncorrect;
    }

    static boolean isIncorrectArrOfNumbInputFromFile(Scanner fileScanner, int[] arrOfNumb, int arrSize)
    {
        boolean isIncorrect = false;

        for (int i = 0; i < arrSize; i++)
        {
            try
            {
                arrOfNumb[i] = fileScanner.nextInt();
            } catch(Exception error)
            {
                isIncorrect = true;
            }
        }

        return isIncorrect;
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
            String fileWay = inputWayToTheFile(in);
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

    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);

        int arrSize = 0;
        int[] arrOfNumb = new int[0];

        conditionOutput();

        System.out.println("\nYou need to choose where to read information from.");

        int path = choosingAPath(in);
        if (path == CONSOLE_KEY)
        {
            arrSize = arrSizeInputFromConsole(in);

            arrOfNumb = new int[arrSize];
            arrOfNumbInputFromConsole(arrSize, arrOfNumb, in);
        }
        else {
            boolean isIncorrect = true;
            fileRestriction();
            System.out.print("Write way to your file: ");
            do
            {
                String fileWay = inputFile(in);
                try
                {
                    Scanner fileScanner = new Scanner(new File(fileWay));
                    if (fileScanner.hasNextLine())
                    {
                        try {
                            arrSize = fileScanner.nextInt();
                            isIncorrect = false;
                        } catch(Exception error){
                            System.err.print("Error in input size of massive. Try again: ");
                        }
                        if (!isIncorrect)
                            isIncorrect = arrSizeInputFromFile(arrSize);
                        if (!isIncorrect)
                        {
                            arrOfNumb = new int[arrSize];
                            isIncorrect = isIncorrectArrOfNumbInputFromFile(fileScanner, arrOfNumb, arrSize);
                            if (isIncorrect)
                                System.err.print("Invalid massive elements input. Try again: ");
                        }
                    }
                    else
                    {
                        System.err.print("Empty file. Try again: ");
                    }
                    fileScanner.close();
                } catch (FileNotFoundException error)
                {
                    System.err.print("File not found. Try again: ");
                }
            } while (isIncorrect);
        }

        sortMassive(arrOfNumb, arrSize);

        resultOutput(arrOfNumb, arrSize, in);

        in.close();
    }
}