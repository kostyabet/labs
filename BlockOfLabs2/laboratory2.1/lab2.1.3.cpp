#include <iostream>
#include <iomanip> // for setprecision

int main()
{
    const int MINSIDES = 3, MAXSIDES = 20;
    float area, slpFact, slpFact1, slpFact2, yInter,
        yInter1, yInter2, intPoint;
    int sidesNumb, limForAmt, ind, jOnI;
    bool isInCorrect;

    //inicialization
    area = 0.0;
    slpFact = 0.0;//y = rx + b => slopefactor = r
    yInter = 0.0;//y = fx + b => slopefactor = b
    slpFact1 = 0.0;
    yInter1 = 0.0;
    slpFact2 = 0.0;
    yInter2 = 0.0;
    intPoint = 0.0;
    limForAmt = 0;//high in main block
    ind = 0;//x(index) and y(index)
    sidesNumb = 0;
    jOnI = 0;
    isInCorrect = true;//for input

    //information about task
    std::cout << "This program calculates the area of\ a polygon.\n"
        "The number of sides of the polygon is selected by the user.\n"
        "You also need to enter the coordinates of the polygon vertices.\n\n"
        "*The Gauss formula is used for calculations*\n\n"
        "Restrictions: \n\t1. The number of sides of a polygon is an integer from 3 to 20;\n"
        "\t2. Coordinates - floating point numbers from -1000.0 to 1000.0;\n"
        "\t3. All points must be unique (not repeated);\n"
        "\t4. The vertices of the polygon should be listed in traversal order.\n"
        "\t\t\t\t\t(clockwise / counterclockwise)\n\n";

    //formatted output
    std::cout << std::setprecision(3) << std::fixed;

    //input number of sides
    do
    {
        std::cout << "Write number of sides of a polygon:\n";
        std::cin >> sidesNumb;
        //cheack "Numeric input"
        if (std::cin.get() != '\n')
        {
            std::cin.clear();
            std::cin.ignore(30000, '\n');
            std::cout << "Error. Try again.\n";
        }
        //cheack restrictions
        else if (sidesNumb < MINSIDES || sidesNumb > MAXSIDES)
        {
            std::cout << "Error. The number of sides of a polygon is an integer from " << MINSIDES << " to " << MAXSIDES << ". Try again.\n";
        }
        else
            isInCorrect = false;
    } while (isInCorrect);

    //cin x and y
    float** coordMat = new float* [sidesNumb];
    do
    {
        for (int i = 0; i < sidesNumb; i++)
        {
            ind = i + 1;
            coordMat[i] = new float[2];
            do
            {
                isInCorrect = true;
                //cin x
                do
                {
                    std::cout << "Write x" << ind << ":\n";
                    std::cin >> coordMat[i][0];
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
                    std::cout << "Write y" << ind << ":\n";
                    std::cin >> coordMat[i][1];
                    if (std::cin.get() != '\n')
                    {
                        std::cin.clear();
                        std::cin.ignore(30000, '\n');
                        std::cout << "Error. Try again.\n";
                    }
                    else
                        isInCorrect = false;
                } while (isInCorrect);

                isInCorrect = true;
                // we check the points to see if they are on the same line
                if (i > 1 && coordMat[i - 1][0] - coordMat[i - 2][0] != 0)
                {
                    if (coordMat[i - 1][0] - coordMat[i - 2][0] == 0)
                    {

                    }
                    else
                    {
                        slpFact = (coordMat[i - 1][1] - coordMat[i - 2][1]) / (coordMat[i - 1][0] - coordMat[i - 2][0]);
                        yInter = coordMat[i - 1][1] - coordMat[i - 1][0] * slpFact;
                        if (coordMat[i][1] == slpFact * coordMat[i][0] + yInter)
                        {
                            std::cout << "Three points cannot be on the same line. Try again.\n";
                        }
                        else
                            isInCorrect = false;
                    }
                }
                else
                    isInCorrect = false;

            } while (isInCorrect);
        }

        // check that points cannot be repeated
        for (int i = 0; i < sidesNumb; i++)
        {
            jOnI = i + 1;
            for (int j = jOnI; j < sidesNumb; j++)
            {
                if (isInCorrect = false && coordMat[i][0] == coordMat[j][0] && coordMat[i][1] == coordMat[j][1])
                {
                    std::cout << "Points must be unique. Try again.\n";
                    isInCorrect = true;
                }
            }
        }

        // the main block of checking that there are no self-intersections
        for (int i = 1; i < sidesNumb; i++)
        {
            if (coordMat[i][0] - coordMat[i - 1][0] == 0)
            {
                yInter1 = coordMat[i][0];
                for (int j = i + 2; j < sidesNumb; j++)
                {
                    if (coordMat[j][0] - coordMat[j - 1][0] == 0)
                    {
                        yInter2 = coordMat[j][0];
                        if (yInter1 == yInter2)
                        {
                            if (((coordMat[j][1] > coordMat[i][1] && coordMat[j][1] > coordMat[i - 1][1]) &&
                                (coordMat[j - 1][1] > coordMat[i][1] && coordMat[j - 1][1] > coordMat[i - 1][1])) ||
                                ((coordMat[j][1] < coordMat[i][1] && coordMat[j][1] < coordMat[i - 1][1]) &&
                                    (coordMat[j - 1][1] < coordMat[i][1] && coordMat[j - 1][1] < coordMat[i - 1][1])))
                            {

                            }
                            else
                                isInCorrect = true;
                        }
                    }
                    else
                    {
                        slpFact2 = (coordMat[j][1] - coordMat[j - 1][1]) / (coordMat[j][0] - coordMat[j - 1][0]);
                        yInter2 = coordMat[j][1] - coordMat[j][0] * slpFact2;
                        intPoint = (yInter2 - yInter1) / (slpFact1 - slpFact2);
                        if ((yInter1 > coordMat[j][0] && yInter1 < coordMat[j - 1][0]) ||
                            (yInter1 < coordMat[j][0] && yInter1 > coordMat[j - 1][0]) &&
                            ((intPoint > coordMat[j][1] && intPoint < coordMat[j - 1][1]) ||
                                (intPoint < coordMat[j][1] && intPoint > coordMat[j - 1][1])))
                            isInCorrect = true;
                    }
                }
            }
            else if (coordMat[i][1] - coordMat[i - 1][1] == 0)
            {
                yInter1 = coordMat[i][1];
                for (int j = i + 2; j < sidesNumb; j++)
                {
                    if (coordMat[j][0] - coordMat[j - 1][0] == 0)
                    {
                        yInter2 = coordMat[i][1];
                        if (yInter1 == yInter2)
                        {
                            if (((coordMat[i][0] < coordMat[j][0] && coordMat[i][0] < coordMat[j - 1][0]) &&
                                (coordMat[i - 1][0] < coordMat[j][0] && coordMat[i - 1][0] < coordMat[j - 1][0])) ||
                                ((coordMat[i][0] > coordMat[j][0] && coordMat[i][0] > coordMat[j - 1][0]) &&
                                    (coordMat[i - 1][0] > coordMat[j][0] && coordMat[i - 1][0] > coordMat[j - 1][0])))
                            {

                            }
                            else
                                isInCorrect = true;
                        }
                    }
                    else
                    {
                        slpFact2 = (coordMat[j][1] - coordMat[j - 1][1]) / (coordMat[j][0] - coordMat[j - 1][0]);
                        yInter2 = coordMat[j][1] - coordMat[j][0] * slpFact2;
                        intPoint = (yInter2 - yInter1) / (slpFact1 - slpFact2);
                        if (((yInter1 > coordMat[j][1] && yInter1 < coordMat[j - 1][1]) ||
                            (yInter1 < coordMat[j][1] && yInter1 > coordMat[j - 1][1])) &&
                            ((intPoint > coordMat[j][0] && intPoint < coordMat[j - 1][0]) ||
                                (intPoint < coordMat[j][0] && intPoint > coordMat[j - 1][0])))
                            isInCorrect = true;
                    }
                }
            }
            else
            {
                slpFact1 = (coordMat[i][1] - coordMat[i - 1][1]) / (coordMat[i][0] - coordMat[i - 1][0]);
                yInter1 = coordMat[i][1] - coordMat[i][0] * slpFact1;
                for (int j = i + 2; j < sidesNumb; j++)
                {
                    if (coordMat[j][0] - coordMat[j - 1][0] == 0)
                    {
                        yInter2 = coordMat[j][0];
                        intPoint = slpFact1 * yInter2 + yInter1;
                        if ((intPoint > coordMat[j][1] && intPoint > coordMat[j - 1][1]) ||
                            (intPoint < coordMat[j][1] && intPoint < coordMat[j - 1][1]))
                        {

                        }
                        else
                            isInCorrect = true;
                    }
                    else
                    {
                        slpFact2 = (coordMat[j][1] - coordMat[j - 1][1]) / (coordMat[j][0] - coordMat[j - 1][0]);
                        yInter2 = coordMat[j][1] - coordMat[j][0] * slpFact2;
                        intPoint = (yInter2 - yInter1) / (slpFact1 - slpFact2);
                        if (((intPoint > coordMat[j][0] && intPoint < coordMat[j - 1][0]) ||
                            (intPoint < coordMat[j][0] && intPoint > coordMat[j - 1][0])) &&
                            (coordMat[i][0] - coordMat[i - 1][0] == coordMat[j][0] - coordMat[j - 1][0]) &&
                            (coordMat[i][1] - coordMat[i - 1][1] == coordMat[j][1] - coordMat[j - 1][1]))
                            isInCorrect = true;
                    }
                }
            }
        }

        // determine the test result
        if (isInCorrect)
        {
            std::cout << "The rectangle must not be self-intersecting. Try again.\n";
        }

    } while (isInCorrect);

    // main block
    // we consider the result to be the Gauss formula
    limForAmt = sidesNumb - 1;
    for (int i = 0; i < limForAmt; i++)
    {
        // we calculate two amounts at once, taking into account the sign (+/-)
        area = area + (coordMat[i][0] * coordMat[i + 1][1]) - (coordMat[i + 1][0] * coordMat[i][1]);
    }
    // transfer half the modulus of the available amount
    area = abs(area + (coordMat[sidesNumb - 1][0] * coordMat[0][1]) - (coordMat[sidesNumb - 1][1] * coordMat[0][0]));
    area = area / 2;
    // cout resoult
    std::cout << "\nYour area is: " << area << ".\n";

    //cleaning the memory
    for (int i = 0; i < sidesNumb; i++) {
        delete[] coordMat[i];
        coordMat[i] = nullptr;
    }
    delete[] coordMat;
    coordMat = nullptr;

    return 0;
}