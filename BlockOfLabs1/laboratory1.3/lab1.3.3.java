import java.text.DecimalFormat;
import java.util.Scanner;

public class lab_3
{
    public static void main(String[] args)
    {
        final double MinEPS = 0; // minimum EPS
        final double MaxEPS = 0.1; // maximum EPS
        double EPS = MaxEPS, X = 0;
        double Y = 0; // current element
        double Y0 = 1; // previous element
        int Number = 0; // operation counter
        int Coefficient = 1; // stores the sign of the entered X
        boolean IsCorrect = true;

        // condition
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
                // input X
                System.out.println("Write the cube root of which number you want to find?");
                X = in.nextDouble();

                // EPS input
                System.out.println("With what EPS must the calculations be made?");
                EPS = in.nextDouble();

                // EPS check
                // for EPS more than 0,1
                if (EPS > MaxEPS)
                {
                    //passing the error
                    throw new Exception("EPS is too high. EPS must be less than 0.1.");
                }
                // for EPS = 0,1
                if (EPS == MaxEPS)
                {
                    throw new Exception("EPS must be less than 0.1.");
                }
                // for EPS less than 0
                else if (EPS < MinEPS)
                {
                    //passing the error
                    throw new Exception("EPS cannot be less than 0");
                }
                // for EPS = 0
                else if (EPS == MinEPS)
                {
                    //passing the error
                    throw new Exception("EPS cannot be 0");
                }

                //display current information about EPS and X
                System.out.println("\nYour X: " + dF.format(X) + "\nYour EPS: " + dF.format(EPS));

                // check the sign
                if (X < 0)
                {
                    // change of sign
                    Coefficient = -1;
                    X = -X;
                }

                // conclusion
                if (X == 0)
                {
                    // at X = 0
                    Y = X;
                    Number = 1;
                }
                // for number from -1 to 1, except zero
                else if (X < 1)
                {
                    // first operation
                    Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number++;
                    // checking for the possibility of the next operation
                    if (Y0 - Y > EPS)
                    {
                        Y0 = Y;
                        Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number++;
                        // since the difference between A and A0 is small,
                        // then you can do a complete search of all the remaining numbers
                        while (Y0 - Y > EPS)
                        {
                            Y0 = Y;
                            Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number++;
                        }
                    }
                }
                // for all numbers except the range from -1 to 1
                else
                {
                    // first operation
                    Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number++;
                    // checking for the possibility of the next operation
                    if (Y - Y0 > EPS)
                    {
                        Y0 = Y;
                        Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number++;
                        // since the difference between A and A0 is small,
                        // then you can do a complete search of all the remaining numbers
                        while (Y0 - Y > EPS)
                        {
                            Y0 = Y;
                            Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number++;
                        }
                    }
                }

                // output of final information
                // cube root output
                System.out.println("\nCube root of " + dF.format(X) + " = " + dF.format(Coefficient * Y));
                // number of operations to achieve accuracy
                System.out.println("Number of operations for which accuracy was achieved - " + Number);
                IsCorrect = false;
                in.close();
            } catch (Exception error) {
                // catching a mistake
                if (error.getMessage() == null)
                {
                    System.out.println("Invalid type!!!");
                }
                else
                {
                    System.out.println(error.getMessage());
                }
            }
        } while (IsCorrect);
    }
}