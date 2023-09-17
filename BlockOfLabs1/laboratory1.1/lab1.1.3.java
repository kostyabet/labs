import java.util.Scanner;

public class lab_1
{
    public static void main(String[] args)
    {
        final int MAXYEAR = 120;
        final int MINYEAR = 18;
        boolean IsCorrect = false;
        boolean Flag = true;
        int year = MINYEAR;
        char gender = '\0';
        System.out.println("  The program will ask the user for their gender and age.\n" +
                "The age of your significant other will be calculated using the formulas!!!\n\n" +
                "Age restrictions: from " +  MINYEAR + " to " + MAXYEAR + ".\n");
        do {
            try
            {
                Scanner in = new Scanner(System.in);
                System.out.println("Select your gender. If you are a man, then (M), if you are a woman, then (W).");
                gender = in.next().charAt(0);
                if (gender != 'M' && gender != 'w' && gender != 'W' && gender != 'm')
                {
                    throw new Exception("Wrong gender selection.");
                }
                System.out.println("Write your age in years.");
                year = in.nextInt();
                if (year > MAXYEAR)
                {
                    throw new Exception("The age is great. The permissible maximum age for the program is 120 years.");
                }
                else if (year < MINYEAR)
                {
                    throw new Exception("Age is small.  The acceptable minimum age for the program is 18 years.");
                }
                in.close();
                IsCorrect = false;
            } catch (Exception error) {
                if (error.getMessage() == null)
                {
                    IsCorrect = true;
                    System.out.println("You must write the number.");
                }
                else
                {
                    IsCorrect = true;
                    System.out.println(error.getMessage());
                }
            }
        } while (IsCorrect);

        if (gender == 'M' || gender == 'm')
        {
            if ((year / 2) + 7 < MINYEAR)
            {
                System.out.println("The age of your significant other is below the acceptable norm(18). " + ((year / 2) + 7));
            }
            else
            {
                System.out.println("You are a man and you " + year + ", and to your soulmate " + ((year / 2) + 7) + ".");
            }
        }
        else
        {
            if ((year * 2) - 14 > MAXYEAR)
            {
                System.out.println("The age of your significant other has exceeded the maximum norm(120). " + ((year * 2) - 14));
            }
            else
            {
                System.out.println("You are a woman and you " + year + ", and to your soulmate " + ((year * 2) - 14) + ".");
            }
        }
    }
}