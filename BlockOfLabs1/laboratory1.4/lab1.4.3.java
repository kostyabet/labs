import java.text.DecimalFormat;
import java.util.Scanner;

public class lab_4 {
    public static void main(String[] args){
        DecimalFormat dF = new DecimalFormat( "0.###" );
        Scanner in = new Scanner(System.in);

        int arraySize = 0;
        double sumNumb = 0.0;
        boolean isCorrect = true;

        System.out.print("""
                            The program calculates the sum of all odd elements entered by the user.
                          *Please note that the numbering of the entered numbers starts from zero.*
                          
                          Restrictions: The number of all elements is an integer and > 0;
                                        Numbers can be any: both integers and reals.
                           
                          """);

        do {
            try {
                System.out.println("How many numbers will you write?");
                arraySize = Integer.parseInt(in.nextLine());
                if (arraySize < 1)
                {
                    System.err.println("Number should be > 0. Try again.");
                }
                else
                {
                    isCorrect = false;
                }
            } catch (NumberFormatException error) {
                System.err.println("Number entered incorrectly. Try again.");
            }
        } while (isCorrect);

        double[] arrayOfNumbers = new double[arraySize];

        isCorrect = true;
        do
        {
            try
            {
                for (int i = 0; i < arraySize; i++) {
                    System.out.printf("Write your %d number.\n", i + 1);
                    arrayOfNumbers[i] = Double.parseDouble(in.nextLine());
                }
                isCorrect = false;
            } catch (NumberFormatException error) {
                System.err.println("Number entered incorrectly. Try again.");
            }
        } while(isCorrect);

        in.close();

        for (int i = 0; i < arraySize; i = i + 2) {
            sumNumb = sumNumb + arrayOfNumbers[i];
        }

        System.out.printf("Sum of all odd numbers - %.3f", sumNumb);
    }
}
