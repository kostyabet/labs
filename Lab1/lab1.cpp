#include <iostream>

int main()
{
    const int MINYEAR = 18, MAXYEAR = 120;
    char gender = '\0';
    int year = 0;
    bool IsCorrectGender = false, IsCorrectYear = false;

    std::cout << "  You need to enter what gender you are, Man(M) or Woman(W). \n"
        << "After that, enter your age ranging from 18 to 120.\n\n";
    do
    {
        IsCorrectGender = false;
        std::cout << "Write your gender(M or W)?\n";
        std::cin >> gender;
        if (gender != 'M' && gender != 'w' && gender != 'W' && gender != 'm')
        {
            std::cout << "Wrong gender selected.\n";
            IsCorrectGender = true;
        }
    } while (IsCorrectGender);

    do
    {
        IsCorrectYear = false;
        std::cout << "How old are you?\n";
        std::cin >> year;
        if (year < MINYEAR)
        {
            std::cout << "Age is young.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
        else if (year > MAXYEAR)
        {
            std::cout << "Age is great.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
        else if (std::cin.get() != '\n')
        {
            std::cout << "Year entered incorrectly.\n";
            IsCorrectYear = true;
            std::cin.clear();
            while (std::cin.get() != '\n') {}
        }
    } while (IsCorrectYear);


    if (gender == 'M' || gender == 'm')
    {
        if ((year / 2) + 7 < MINYEAR)
        {
            std::cout << "The age of your significant other is below the acceptable norm (18). " << (year / 2) + 7;
        }
        else
        {
            std::cout << "You are a man and you " << year << ", and to your soulmate " << (year / 2) + 7 << ".";
        }
        std::cout << std::endl;
    }
    else if (gender == 'W' || gender == 'w')
    {
        if ((year * 2) - 14 > MAXYEAR)
        {
            std::cout << "The age of your significant other has exceeded the maximum norm (120). " << (year * 2) - 14;
        }
        else
        {
            std::cout << "You are a woman and you " << year << ", and to your soulmate " << (year * 2) - 14 << ".";
        }
        std::cout << std::endl;
    }
    std::cout << "\n";
}