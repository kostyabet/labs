import java.util.Scanner;

public class lab1
{
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        final int MAXYEAR = 120, MINYEAR = 18;
        boolean IsCorrectGender = true, IsCorrectYear = true;
        int year = 0;
        char gender = '\0';

        System.out.println("  You need to enter what gender you are, Man(M) or Woman(W).\n"
                + "After that, enter your age ranging from 18 to 120.");
        try
        {
            System.out.println("\nSelect your gender. If you are a man, then (M), if you are a woman, then (W).");
            gender = in.next().charAt(0);
            if (gender != 'M' && gender  != 'm' && gender != 'W' && gender != 'w') {
                System.out.println("Wrong gender selected.");
                IsCorrectGender = false;
            }
            System.out.println("How old are you?");
            year = in.nextInt();
            if (year > MAXYEAR)
            {
                System.out.println("Age is great.");
                IsCorrectYear = false;
            }
            if (year < MINYEAR)
            {
                System.out.println("Age is young.");
                IsCorrectYear = false;
            }
        } catch (Exception error)
        {
            if (error.getMessage() == null)
            {
                System.out.println("Invalid type!!!");
                IsCorrectGender = false;
            } else
            {
                System.out.println(error.getMessage());
                IsCorrectYear = false;
            }
        }

        if (IsCorrectYear && IsCorrectGender && gender == 'M' || gender == 'm')
        {
            if ((year / 2) + 7 < MINYEAR)
            {
                System.out.println("The age of your significant other is below the acceptable norm (18). Her " +
                                   ((year / 2) + 7));
            } else
            {
                System.out.println("You are a man and you " + year + ", and to your soulmate " +
                                   ((year / 2) + 7) + ".");
            }
        } else if (IsCorrectYear && IsCorrectGender && gender == 'W' || gender == 'w')
        {
            if ((year * 2) - 14 > MAXYEAR)
            {
                System.out.println("The age of your significant other has exceeded the maximum norm (120). Her " +
                                   ((year * 2) - 14));
            } else
            {
                System.out.println("You are a woman and you " + year + ", and to your soulmate " + ((year * 2) - 14) +
                                   ".");
            }
        }
    }
}
