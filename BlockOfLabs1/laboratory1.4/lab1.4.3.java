import java.text.DecimalFormat;
import java.util.Scanner;

public class lab_4 {
    public static void main(String[] args) {

        // variables
        int NumberInMassive = 0; // number of digits in array
        double SumNumb = 0; // will be the sum of odd numbers
        boolean IsCorrect = true; // to check for input

        // condition
        System.out.println("  The program calculates the sum of all odd elements entered by the user.\n" +
                            "*Please note that the numbering of the entered numbers starts from zero.*\n\n" +
                            "Restrictions: The number of all elements is an integer;\n" +
                            "              Numbers can be any: both integers and reals.\n");

        do {
            try {
                DecimalFormat dF = new DecimalFormat( "0.###" );
                Scanner in = new Scanner(System.in);

                // reading the size of the array and creating it
                System.out.println("How many numbers will you write?");
                NumberInMassive = in.nextInt();
                double[] arr = new double[NumberInMassive];

                // read all numbers into an array
                System.out.println("Enter numbers using 'Space' or 'Enter'.");
                for (int i = 0; i < NumberInMassive; i++) {
                    double buffer = 0; // buffer for reading a number
                    buffer = in.nextDouble();
                    arr[i] = buffer;
                }

                // count the amount
                for (int i = 1; i < NumberInMassive; i = i + 2) {
                    SumNumb = SumNumb + arr[i];
                }

                // output of final information
                System.out.println("Sum of all odd numbers - " + dF.format(SumNumb));

                in.close();
                IsCorrect = false;
            } catch (Exception error) // catching a mistake
            {
                System.out.println("Error.");
            }
        } while (IsCorrect);
    }
}