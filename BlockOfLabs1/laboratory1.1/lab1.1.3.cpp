#include <iostream>

int main()
{
    const int MINYEAR = 18;
    const int MAXYEAR = 120;
    char gender = '\0';
    int year = 0;
    bool IsCorrect = true, Flag = true, IsCorrectGender = false, IsCorrectYear = false;
    std::cout << "  The program will ask the user for their gender and age.\n"
        << "The age of your significant other will be calculated using the formulas!!!\n\n"
        << "Age restrictions: from " << MINYEAR << " to " << MAXYEAR << ".\n\n\n";
    do
    {
        IsCorrectGender = false;
        std::cout << "Select your gender. If you are a man, then (M), if you are a woman, then (W).\n";
        std::cin >> gender;
        if (gender != 'M' && gender != 'w' && gender != 'W' && gender != 'm')
        {
            std::cout << "Wrong gender selection.\n";
            IsCorrectGender = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
        else if (std::cin.get() != '\n')
        {
            std::cout << "ERROR.\n";
            IsCorrectGender = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }


    } while (IsCorrectGender);

    do
    {
        std::cout << "Write your age in years.\n";
        std::cin >> year;

        IsCorrectYear = false;
        if (std::cin.get() != '\n')
        {
            std::cout << "ERROR.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
        else if (year > MAXYEAR)
        {
            std::cout << "The age is great. The permissible maximum age for the program is 120 years.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
        else if (year < MINYEAR)
        {
            std::cout << "Age is small.  The acceptable minimum age for the program is 18 years.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }

    } while (IsCorrectYear);

    if (IsCorrect && (gender == 'M' || gender == 'm'))
    {
        if ((year / 2) + 7 < MINYEAR)
        {
            std::cout << "The age of your significant other is below the acceptable norm(18). " << (year / 2) + 7;
        }
        else
        {
            std::cout << "You are a man and you " << year << ", and to your soulmate " << (year / 2) + 7 << ".";
        }
    }
    else if (IsCorrect)
    {
        if ((year * 2) - 14 > MAXYEAR)
        {
            std::cout << "The age of your significant other has exceeded the maximum norm(120). " << (year * 2) - 14;
        }
        else
        {
            std::cout << "You are a woman and you " << year << ", and to your soulmate " << (year * 2) - 14 << ".";
        }
    }
    return 0;
}