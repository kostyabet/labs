#include <iostream>

int main()
{
    const int ONEKILOCOST = 280; // weight one kilogram
    const int TABLESTEP = 50; // table step
    const int ENDOFTABLE = 1000; // top table border
    const int GRAMINKILO = 1000; // number of grams in a kilogram
    int cost = 0;

    for (int i = TABLESTEP; i < ENDOFTABLE + 1; i += TABLESTEP)
    {
        // current price calculation
        cost = (i * ONEKILOCOST) / GRAMINKILO;
        // conclusion
        if (i < 99)
        {
            std::cout << i << "   gram of cheese - cost: " << cost << "  rubles.\n";
        }
        else if (i < 999 && cost < 100)
        {
            std::cout << i << "  gram of cheese - cost: " << cost << "  rubles.\n";
        }
        else if (i < 999)
        {
            std::cout << i << "  gram of cheese - cost: " << cost << " rubles.\n";
        }
        else
        {
            std::cout << i << " gram of cheese - cost: " << cost << " rubles.\n";
        }
    }
    return 0;
}
