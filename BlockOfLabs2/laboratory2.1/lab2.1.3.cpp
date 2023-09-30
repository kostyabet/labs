#include <iostream>
#include <iomanip> // for setprecision

int main()
{
    const float MINCOORDINATE = -1000.0, MAXCOORDINATE = 1000.0;
    float area, slopeFactor, slopeFactor1, slopeFactor2, yInterception,
        yInterception1, yInterception2, productOfVectors1, productOfVectors2,
        intersectionPoint;
    const short MINNUMBEROFSIDE = 3, MAXNUMBEROFSIDE = 20;
    short numberOfSides, limitForAmount;
    int index;
    bool isInCorrect, isInCorrectCoordinate, isInCorrectAll, isCorrectInput,
        isInCorrectPolygon;

    //inicialization
    area = 0.0;
    slopeFactor = 0.0;//y = rx + b => slopefactor = r
    yInterception = 0.0;//y = fx + b => slopefactor = b
    slopeFactor1 = 0.0;
    yInterception1 = 0.0;
    slopeFactor2 = 0.0;
    yInterception2 = 0.0;
    intersectionPoint = 0.0;//
    productOfVectors1 = 0.0;//vector1;
    productOfVectors2 = 0.0;//vector2;
    limitForAmount = 0;//high in main block
    index = 0;//x(index) and y(index)
    numberOfSides = 0;
    isInCorrect = true;//for input
    isInCorrectCoordinate = true;//for coordinate cheack
    isInCorrectAll = false;//for all block
    isCorrectInput = false;//vector
    isInCorrectPolygon = false;//for poligon

    //information about task
    std::cout << "  This program calculates the area of\ a polygon. The number of sides of the polygon is selected by the user.\n"
        "You also need to enter the coordinates of the polygon vertices.\n\n"
        "*The Gauss formula is used for calculations*\n\n"
        "Restrictions: \n\t1. The number of sides of a polygon is an integer from " << MINNUMBEROFSIDE << " to " << MAXNUMBEROFSIDE << ";\n"
        "\t2. Coordinates - floating point numbers from " << MINCOORDINATE << " to " << MAXCOORDINATE << ";\n"
        "\t3. All points must be unique (not repeated);\n"
        "\t4. The vertices of the polygon should be listed in traversal order (clockwise / counterclockwise).\n\n";

    //formatted output
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
    do
    {
        isInCorrectAll = false;
        isCorrectInput = false;
        isInCorrect = false;
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
                    std::cout << "\nWrite x" << index << ":\n";
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

                // we check the points to see if they are on the same line
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

        // check that points cannot be repeated
        for (int i = 0; i < numberOfSides; i++)
        {
            for (int j = i + 1; j < numberOfSides; j++)
            {
                if (coordinateMatrix[i][0] == coordinateMatrix[j][0] && coordinateMatrix[i][1] == coordinateMatrix[j][1])
                {
                    std::cout << "Points must be unique. Try again.\n";
                    isInCorrectAll = true;
                }
            }
        }

        // the main block of checking that there are no self-intersections
        for (int i = 1; i < numberOfSides; i++)
        {
            if (coordinateMatrix[i][0] - coordinateMatrix[i - 1][0] == 0)
            {
                yInterception1 = coordinateMatrix[i][0];
                for (int j = i + 2; j < numberOfSides; j++)
                {
                    slopeFactor2 = (coordinateMatrix[j][1] - coordinateMatrix[j - 1][1]) / (coordinateMatrix[j][0] - coordinateMatrix[j - 1][0]);
                    yInterception2 = coordinateMatrix[j][1] - coordinateMatrix[j][0] * slopeFactor2;
                    intersectionPoint = (yInterception2 - yInterception1) / (slopeFactor1 - slopeFactor2);
                    if ((yInterception1 > coordinateMatrix[j][0] && yInterception1 < coordinateMatrix[j - 1][0]) ||
                        (yInterception1 < coordinateMatrix[j][0] && yInterception1 > coordinateMatrix[j - 1][0]) &&
                        ((intersectionPoint > coordinateMatrix[j][1] && intersectionPoint < coordinateMatrix[j - 1][1]) ||
                            (intersectionPoint < coordinateMatrix[j][1] && intersectionPoint > coordinateMatrix[j - 1][1])))
                        isInCorrectPolygon = true;
                }
            }
            else if (coordinateMatrix[i][1] - coordinateMatrix[i - 1][1] == 0)
            {
                slopeFactor1 = 0;
                yInterception1 = coordinateMatrix[i][1];
                for (int j = i + 2; j < numberOfSides; j++)
                {
                    slopeFactor2 = (coordinateMatrix[j][1] - coordinateMatrix[j - 1][1]) / (coordinateMatrix[j][0] - coordinateMatrix[j - 1][0]);
                    yInterception2 = coordinateMatrix[j][1] - coordinateMatrix[j][0] * slopeFactor2;
                    intersectionPoint = (yInterception2 - yInterception1) / (slopeFactor1 - slopeFactor2);
                    if (((yInterception1 > coordinateMatrix[j][1] && yInterception1 < coordinateMatrix[j - 1][1]) ||
                        (yInterception1 < coordinateMatrix[j][1] && yInterception1 > coordinateMatrix[j - 1][1])) &&
                        ((intersectionPoint > coordinateMatrix[j][0] && intersectionPoint < coordinateMatrix[j - 1][0]) ||
                            (intersectionPoint < coordinateMatrix[j][0] && intersectionPoint > coordinateMatrix[j - 1][0])))
                        isInCorrectPolygon = true;
                }
            }
            else
            {
                slopeFactor1 = (coordinateMatrix[i][1] - coordinateMatrix[i - 1][1]) / (coordinateMatrix[i][0] - coordinateMatrix[i - 1][0]);
                yInterception1 = coordinateMatrix[i][1] - coordinateMatrix[i][0] * slopeFactor1;
                for (int j = i + 2; j < numberOfSides; j++)
                {
                    slopeFactor2 = (coordinateMatrix[j][1] - coordinateMatrix[j - 1][1]) / (coordinateMatrix[j][0] - coordinateMatrix[j - 1][0]);
                    yInterception2 = coordinateMatrix[j][1] - coordinateMatrix[j][0] * slopeFactor2;
                    intersectionPoint = (yInterception2 - yInterception1) / (slopeFactor1 - slopeFactor2);
                    if (((intersectionPoint > coordinateMatrix[j][0] && intersectionPoint < coordinateMatrix[j - 1][0]) ||
                        (intersectionPoint < coordinateMatrix[j][0] && intersectionPoint > coordinateMatrix[j - 1][0])) &&
                        (coordinateMatrix[i][0] - coordinateMatrix[i - 1][0] == coordinateMatrix[j][0] - coordinateMatrix[j - 1][0]) &&
                        (coordinateMatrix[i][1] - coordinateMatrix[i - 1][1] == coordinateMatrix[j][1] - coordinateMatrix[j - 1][1]))
                        isInCorrectPolygon = true;
                }
            }
        }

        // determine the test result
        if (isInCorrectPolygon)
        {
            isInCorrectAll = true;
            std::cout << "The rectangle must not be self-intersecting. Try again.\n";
        }
        // main block
        // we consider the result to be the Gauss formula
        if (isInCorrectAll == false)
        {
            limitForAmount = numberOfSides - 1;
            for (int i = 0; i < limitForAmount; i++)
            {
                // we calculate two amounts at once, taking into account the sign (+/-)
                area = area + (coordinateMatrix[i][0] * coordinateMatrix[i + 1][1]) - (coordinateMatrix[i + 1][0] * coordinateMatrix[i][1]);
            }
            // transfer half the modulus of the available amount
            area = abs(area + (coordinateMatrix[numberOfSides - 1][0] * coordinateMatrix[0][1]) - (coordinateMatrix[numberOfSides - 1][1] * coordinateMatrix[0][0]));
            area = area / 2;
            // cout resoult
            std::cout << "\nYour area is: " << area << ".\n";
        }
    } while (isInCorrectAll);

    //cleaning the memory  
    for (int i = 0; i < numberOfSides; i++) {
        delete[] coordinateMatrix[i];
        coordinateMatrix[i] = nullptr;
    }
    delete[] coordinateMatrix;
    coordinateMatrix = nullptr;

    return 0;
}