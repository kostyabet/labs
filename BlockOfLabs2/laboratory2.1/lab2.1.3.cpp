#include <iostream>

int main()
{
    const float MINCOORDINATE = -10000;
    float MAXCOORDINATE = 10000;
    short MINNUMBEROFSIDE = 3;
    short MAXNUMBEROFSIDE = 127;
    short numberOfSides;
    short limitForAmount;
    float area;
    bool isCorrect;
    //inicialization
    numberOfSides = 0;
    isCorrect = true;
    area = 0;
    limitForAmount = 0;
    //information about task
    printf("  This program calculates the area of\ a polygon. The number of sides of the polygon is selected by the user.\n"
        "You also need to enter the coordinates of the polygon vertices.\n\n"
        "Restrictions: \n\t1. The number of sides of a polygon is an integer from %d to %d;\n"
        "\t2. Coordinates - floating point numbers from %.1f to %.1f;\n"
        "\t3. The vertices of the polygon should be listed in traversal order (clockwise / counterclockwise).\n\n", MINNUMBEROFSIDE, MAXNUMBEROFSIDE, MINCOORDINATE, MAXCOORDINATE);

    //input number of sides
    printf("Write number of sides of a polygon:\n");
    do
    {
        std::cin >> numberOfSides;
        //cheack "Numeric input"
        if (std::cin.get() != '\n')
        {
            std::cin.clear();
            std::cin.ignore(30000, '\n');
            printf("Error. Try again.\n");
        }
        //cheack restrictions
        else if (numberOfSides < MINNUMBEROFSIDE || numberOfSides > MAXNUMBEROFSIDE)
        {
            printf("Error. The number of sides of a polygon is an integer from %d to %d. Try again.\n", MINNUMBEROFSIDE, MAXNUMBEROFSIDE);
        }
        else
            isCorrect = false;
    } while (isCorrect);

    //cin x and y
    float** coordinateMatrix = new float* [numberOfSides];
    for (int i = 0; i < numberOfSides; i++)
    {
        coordinateMatrix[i] = new float[2];
        isCorrect = true;
        //cin x
        do
        {
            printf("Write x%d:\n", i + 1);
            std::cin >> coordinateMatrix[i][0];
            if (std::cin.get() != '\n')
            {
                std::cin.clear();
                std::cin.ignore(30000, '\n');
                printf("Error. Try again.\n");
            }
            else
                isCorrect = false;
        } while (isCorrect);
        //cin y
        isCorrect = true;
        do
        {
            printf("Write y%d:\n", i + 1);
            std::cin >> coordinateMatrix[i][1];
            if (std::cin.get() != '\n')
            {
                std::cin.clear();
                std::cin.ignore(30000, '\n');
                printf("Error. Try again.\n");
            }
            else
                isCorrect = false;
        } while (isCorrect);
    }
    //main block
    limitForAmount = numberOfSides - 1;
    for (int i = 0; i < limitForAmount; i++)
    {
        area = area + (coordinateMatrix[i][0] * coordinateMatrix[i + 1][1]) - (coordinateMatrix[i + 1][0] * coordinateMatrix[i][1]);
    }

    area = abs(area + (coordinateMatrix[numberOfSides - 1][0] * coordinateMatrix[0][1]) - (coordinateMatrix[numberOfSides - 1][1] * coordinateMatrix[0][0]));
    area = area / 2;
    //cout area
    printf("Your area is: %.3f.", area);
    return 0;
}