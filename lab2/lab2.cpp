#include <iostream>

int main()
{
    const int ONEKILOCOST = 280, TABLESTEP = 50, ENDOFTABLE = 1000, GRAMINKILO = 1000;
    int Cost = 0;
    for (int i = TABLESTEP; i < ENDOFTABLE + 1; i += TABLESTEP)
    {
        Cost = (i * ONEKILOCOST) / GRAMINKILO;
        if (i < 99)
        {
            std::cout << i << "   gram of cheese - cost: " << Cost << "  rubles.\n";
        }
        else if (i < 999 && Cost < 100)
        {
            std::cout << i << "  gram of cheese - cost: " << Cost << "  rubles.\n";
        }
        else if (i < 999)
        {
            std::cout << i << "  gram of cheese - cost: " << Cost << " rubles.\n";
        }
        else
        {
            std::cout << i << " gram of cheese - cost: " << Cost << " rubles.\n";
        }
    }
    return 0;
}