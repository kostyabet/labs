#include <iostream>
#include <iomanip>

int main()
{
    const float MINCOORDINATE = -1000.0, MAXCOORDINATE = 1000.0;
    const short MINNUMBEROFSIDE = 3, MAXNUMBEROFSIDE = 20;
    int index;
    short numberOfSides, limitForAmount;
    float area, slopeFactor, yInterception;
    bool isInCorrect, isInCorrectCoordinate;
    //inicialization
    numberOfSides = 0;
    area = 0.0;
    limitForAmount = 0;
    index = 0;
    slopeFactor = 0;
    yInterception = 0;
    isInCorrect = true;
    isInCorrectCoordinate = true;
    //information about task
    std::cout << "  This program calculates the area of\ a polygon. The number of sides of the polygon is selected by the user.\n"
        "You also need to enter the coordinates of the polygon vertices.\n\n"
        "Restrictions: \n\t1. The number of sides of a polygon is an integer from " << MINNUMBEROFSIDE << " to " << MAXNUMBEROFSIDE << ";\n"
        "\t2. Coordinates - floating point numbers from " << MINCOORDINATE << " to " << MAXCOORDINATE << "; \n"
        "\t3. The vertices of the polygon should be listed in traversal order (clockwise / counterclockwise).\n\n";

    std::cout << std::setprecision(3) << std::fixed;
    //input number of sides
    do
    {
        std::cout << "Write number of sides of a polygon:\n";
        std::cin >> numberOfSides;
        //cheack "Numeric input"
        if (std::cin.get() != '\n')
        {
            std::cin.clear();
            std::cin.ignore(30000, '\n');
            std::cout << "Error. Try again.\n";
        }
        //cheack restrictions
        else if (numberOfSides < MINNUMBEROFSIDE || numberOfSides > MAXNUMBEROFSIDE)
        {
            std::cout << "Error. The number of sides of a polygon is an integer from " << MINNUMBEROFSIDE << " to " << MAXNUMBEROFSIDE << ". Try again.\n";
        }
        else
            isInCorrect = false;
    } while (isInCorrect);

    //cin x and y
    float** coordinateMatrix = new float* [numberOfSides];
    for (int i = 0; i < numberOfSides; i++)
    {
        index = i + 1;
        coordinateMatrix[i] = new float[2];
        isInCorrectCoordinate = true;
        do
        {
            isInCorrect = true;
            //cin x
            do
            {
                std::cout << "Write x" << index << ":\n";
                std::cin >> coordinateMatrix[i][0];
                if (std::cin.get() != '\n')
                {
                    std::cin.clear();
                    std::cin.ignore(30000, '\n');
                    std::cout << "Error. Try again.\n";
                }
                else
                    isInCorrect = false;
            } while (isInCorrect);
            //cin y
            isInCorrect = true;
            do
            {
                std::cout << "Write y" << index << ":\n";
                std::cin >> coordinateMatrix[i][1];
                if (std::cin.get() != '\n')
                {
                    std::cin.clear();
                    std::cin.ignore(30000, '\n');
                    std::cout << "Error. Try again.\n";
                }
                else
                    isInCorrect = false;
            } while (isInCorrect);
            if (i > 1)
            {
                slopeFactor = (coordinateMatrix[i - 1][1] - coordinateMatrix[i - 2][1]) / (coordinateMatrix[i - 1][0] - coordinateMatrix[i - 2][0]);
                yInterception = coordinateMatrix[i - 1][1] - coordinateMatrix[i - 1][0] * slopeFactor;
                if (coordinateMatrix[i][1] == slopeFactor * coordinateMatrix[i][0] + yInterception)
                {
                    std::cout << "Three points cannot be on the same line. Try again.\n";
                }
                else
                    isInCorrectCoordinate = false;
            }
            else
                isInCorrectCoordinate = false;

        } while (isInCorrectCoordinate);
    }
    //main block
    limitForAmount = numberOfSides - 1;
    for (int i = 0; i < limitForAmount; i++)
    {
        area = area + (coordinateMatrix[i][0] * coordinateMatrix[i + 1][1]) - (coordinateMatrix[i + 1][0] * coordinateMatrix[i][1]);
    }
    area = abs(area + (coordinateMatrix[numberOfSides - 1][0] * coordinateMatrix[0][1]) - (coordinateMatrix[numberOfSides - 1][1] * coordinateMatrix[0][0]));
    area = area / 2;
    //cleaning the memory  
    for (int i = 0; i < numberOfSides; i++) {
        delete[] coordinateMatrix[i];
        coordinateMatrix[i] = nullptr;
    }
    delete[] coordinateMatrix;
    coordinateMatrix = nullptr;
    //cout area
    std::cout << "\nYour area is: " << area << ".\n";
    return 0;
}