import java.util.Scanner;pimport java.util.Scanner;

public class lab_1
{
    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);

        final int MAXYEAR = 120; // minimum age
        final int MINYEAR = 18; // maximum age
        boolean IsCorrect = true;
        int year = MINYEAR;
        char gender = '\0';

        // condition
        System.out.println("  The program will ask the user for their gender and age.\n" +
                "The age of your significant other will be calculated using the formulas!!!\n\n" +
                "Age restrictions: from " +  MINYEAR + " to " + MAXYEAR + ".\n");

        while (true) {
            // entering gender
            System.out.println("\nSelect your gender. If you are a man, then (M), if you are a woman, then (W).");
            gender = in.next().charAt(0);
            // gender verification
            if (gender != 'M' && gender != 'm' && gender != 'W' && gender != 'w') {
                System.out.println("Wrong gender selected.");
                IsCorrect = false;
            }

            if (IsCorrect) {
                // entering age
                System.out.println("Write your age in years.");
                year = in.nextInt();
            }

            // age verification
            if (IsCorrect && year > MAXYEAR) {
                IsCorrect = false;
                System.out.println("The age is great. The permissible maximum age for the program is 120 years.");
            }

            if (IsCorrect && year < MINYEAR) {
                IsCorrect = false;
                System.out.println("Age is small. The acceptable minimum age for the program is 18 years.");
            }

            // conclusion
            if (IsCorrect && gender == 'M' || gender == 'm') {
                // checking your significant other's age
                if ((year / 2) + 7 < MINYEAR) {
                    System.out.println("The age of your significant other is below the acceptable norm (18). Her " + ((year / 2) + 7));
                }
                // main conclusion
                else {
                    System.out.println("You are a man and you " + year + ", and to your soulmate " + ((year / 2) + 7) + ".");
                }
                // if it's a girl
            } else if (IsCorrect) {
                // checking your significant other's age
                if ((year * 2) - 14 > MAXYEAR) {
                    System.out.println("The age of your significant other has exceeded the maximum norm (120). Her " + ((year * 2) - 14));
                }
                // main conclusion
                else {
                    System.out.println("You are a woman and you " + year + ", and to your soulmate " + ((year * 2) - 14) + ".");
                }
            }
            in.close();
        }
    }
}