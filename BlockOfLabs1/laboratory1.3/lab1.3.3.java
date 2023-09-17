import java.text.DecimalFormat;
import java.util.Scanner;

public class lab_3
{
    public static void main(String[] args)
    {
        final double MinEPS = 0;
        final double MaxEPS = 0.1;
        double EPS = MaxEPS, X = 0;
        double Y = 0;
        double Y0 = 1;
        int Number = 0;
        int Coefficient = 1;
        boolean IsCorrect = true;
        System.out.println("  The program calculates the value of the cube root \n"
                + "from the number X entered by a person.\n"
                + "With accuracy up to the number EPS entered by the user.\n\n"
                + "Restrictions X: No restrictions.\n"
                + "Restrictions EPS: (0; 0,1).\n\n");
        do
        {
            try {
                DecimalFormat dF = new DecimalFormat( "0.###" );
                Scanner in = new Scanner(System.in);
                System.out.println("Write the cube root of which number you want to find?");
                X = in.nextDouble();
                System.out.println("With what EPS must the calculations be made?");
                EPS = in.nextDouble();
                if (EPS > MaxEPS)
                {
                    throw new Exception("EPS is too high. EPS must be less than 0.1.");
                }
                if (EPS == MaxEPS)
                {
                    throw new Exception("EPS must be less than 0.1.");
                }
                else if (EPS < MinEPS)
                {
                    throw new Exception("EPS cannot be less than 0");
                }
                else if (EPS == MinEPS)
                {
                    throw new Exception("EPS cannot be 0");
                }
                System.out.println("\nYour X: " + dF.format(X) + "\nYour EPS: " + dF.format(EPS));
                if (X < 0)
                {
                    Coefficient = -1;
                    X = -X;
                }
                if (X == 0)
                {
                    Y = X;
                    Number = 1;
                }
                else
                {
                    Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number++;
                    if (Math.abs(Y - Y0) > EPS)
                    {
                        Y0 = Y;
                        Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number++;
                        while (Math.abs(Y - Y0) > EPS)
                        {
                            Y0 = Y;
                            Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number++;
                        }
                    }
                }
                System.out.println("\nCube root of " + dF.format(X) + " = " + dF.format(Coefficient * Y));
                System.out.println("Number of operations for which accuracy was achieved - " + Number);
                IsCorrect = false;
                in.close();
            } catch (Exception error) {
                if (error.getMessage() == null)
                {
                    System.out.println("You must write the number.");
                }
                else
                {
                    System.out.println(error.getMessage());
                }
            }
        } while (IsCorrect);
    }
}