#include <iostream>

int main()
{
    const int MINYEAR = 18; // minimum age
    const int MAXYEAR = 120; // maximum age

    char gender = '\0';
    int year = 0;
    bool IsCorrect = true;

    // condition
    std::cout << "  The program will ask the user for their gender and age.\n"
        << "The age of your significant other will be calculated using the formulas!!!\n\n"
        << "Age restrictions: from " << MINYEAR << " to " << MAXYEAR << ".\n";
    while (true)
    {
        IsCorrect = true;
        // entering gender 
        std::cout << "\n\nSelect your gender. If you are a man, then (M), if you are a woman, then(W).\n";
        std::cin >> gender;
        // gender verification
        if (gender != 'M' && gender != 'w' && gender != 'W' && gender != 'm')
        {
            std::cout << "Wrong gender selected.";
            IsCorrect = false;
        }

        if (IsCorrect) {
            // entering age
            std::cout << "Write your age in years.\n";
            std::cin >> year;
        }

        // age verification
        if (IsCorrect && year > MAXYEAR)
        {
            IsCorrect = false;
            std::cout << "The age is great. The permissible maximum age for the program is 120 years.";
        }

        if (IsCorrect && year < MINYEAR)
        {
            IsCorrect = false;
            std::cout << "Age is small. The acceptable minimum age for the program is 18 years.";
        }

        // conclusion
        if (IsCorrect && (gender == 'M' || gender == 'm'))
        {
            // checking your significant other's age
            if ((year / 2) + 7 < MINYEAR)
            {
                std::cout << "The age of your significant other is below the acceptable norm(18). " << (year / 2) + 7;
            }
            // main conclusion
            else
            {
                std::cout << "You are a man and you " << year << ", and to your soulmate " << (year / 2) + 7 << ".";
            }
        }
        // if it's a girl
        else if (IsCorrect)
        {
            // checking your significant other's age
            if ((year * 2) - 14 > MAXYEAR)
            {
                std::cout << "The age of your significant other has exceeded the maximum norm(120). " << (year * 2) - 14;
            }
            // main conclusion
            else
            {
                std::cout << "You are a woman and you " << year << ", and to your soulmate " << (year * 2) - 14 << ".";
            }
        }
    }
    return 0;
}