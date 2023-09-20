import java.text.DecimalFormat;
import java.util.Scanner;

public class lab_4 {
    public static void main(String[] args) {
        DecimalFormat dF = new DecimalFormat( "0.###" );
        Scanner in = new Scanner(System.in);

        int numberInMassive = 0;
        double sumNumb = 0;
        boolean isCorrect = true;

        System.out.print("""
                            The program calculates the sum of all odd elements entered by the user.
                          *Please note that the numbering of the entered numbers starts from zero.*
                          
                          Restrictions: The number of all elements is an integer;
                                        Numbers can be any: both integers and reals.
                           
                           """);

        do {
            try {
                System.out.println("How many numbers will you write?");
                numberInMassive = Integer.parseInt(in.nextLine());
                isCorrect = false;
            } catch (Exception error) {
                System.out.print("Number entered incorrectly.\n");
            }
        } while (isCorrect);

        double[] arr = new double[numberInMassive];

        isCorrect = true;
        do
        {
            try
            {
                for (int i = 0; i < numberInMassive; i++) {
                    System.out.printf("Write your %d number.\n", i + 1);
                    double buffer = Double.parseDouble(in.nextLine());
                    arr[i] = buffer;
                }
                isCorrect = false;
            } catch (Exception error) {
                System.out.print("Number entered incorrectly.\n");
            }
        } while(isCorrect);

        in.close();

        for (int i = 1; i < numberInMassive; i = i + 2) {
            sumNumb = sumNumb + arr[i];
        }
        System.out.printf("Sum of all odd numbers - %.3f", sumNumb);
    }
}