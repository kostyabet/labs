package lab2;

import java.util.Scanner;

import static java.lang.Math.abs;

public class lab1 {
    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);
        final int MINSIDES = 3,
                MAXSIDES = 20;
        double area, slpFact, slpFact1, slpFact2, yInter,
                yInter1, yInter2, intPoint;
        int sidesNumb, limForAmt;
        boolean isIncorrect;

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
        sidesNumb = 0;
        isIncorrect = true;//for input

        System.out.print("""
                            This program calculates the area of a polygon. 
                            The number of sides of the polygon is selected by the user.
                            You also need to enter the coordinates of the polygon vertices.
        
                            *The Gauss formula is used for calculations*
                            
                            Restrictions:\s
                                    1. The number of sides of a polygon is an integer from 3 to 20;
                                    2. Coordinates - floating point numbers from -1000.0 to 1000.0;
                                    3. All points must be unique (not repeated);
                                    4. The vertices of the polygon should be listed in traversal order. 
                                                                    (clockwise / counterclockwise)
                                    
                            """);

        //input number of sides
        do
        {
            System.out.print("Write number of sides of a polygon:\n");
            //cheack "Numeric input"
            try
            {
                sidesNumb = Short.parseShort(in.nextLine());
            }
            catch (NumberFormatException error)
            {
                System.err.print("Error.\n");
            }
            //cheack restrictions
            if (sidesNumb < MINSIDES || sidesNumb > MAXSIDES)
            {
                System.err.printf("The number of sides of a polygon is an integer from %d to %d. Try again.\n", MINSIDES, MAXSIDES);
            }
            else
                isIncorrect = false;
        } while (isIncorrect);

        //cin x and y
        float[][] coordMat = new float[sidesNumb][2];
        do
        {
            for (int i = 0; i < sidesNumb; i++)
            {
                do
                {
                    isIncorrect = true;
                    //cin x
                    do
                    {
                        System.out.printf("Write x%d:\n", i + 1);
                        try
                        {
                            coordMat[i][0] = Float.parseFloat(in.nextLine());
                            isIncorrect = false;
                        } catch (NumberFormatException error)
                        {
                            System.out.print("Error. Try again.\n");
                        }
                    } while (isIncorrect);
                    //cin y
                    isIncorrect = true;
                    do
                    {
                        System.out.printf("Write y%d:\n", i + 1);
                        try
                        {
                            coordMat[i][1] = Float.parseFloat(in.nextLine());
                            isIncorrect = false;
                        }
                        catch (NumberFormatException error)
                        {
                            System.out.print("Error. Try again.\n");
                        }
                    } while (isIncorrect);

                    isIncorrect = true;
                    // we check the points to see if they are on the same line
                    if (i > 1 && coordMat[i - 1][0] - coordMat[i - 2][0] != 0)
                    {
                        slpFact = (coordMat[i - 1][1] - coordMat[i - 2][1]) / (coordMat[i - 1][0] - coordMat[i - 2][0]);
                        yInter = coordMat[i - 1][1] - coordMat[i - 1][0] * slpFact;
                        if (coordMat[i][1] == slpFact * coordMat[i][0] + yInter)
                        {
                            System.out.print("Three points cannot be on the same line. Try again.\n");
                        }
                        else
                            isIncorrect = false;
                    }
                    else if (i > 1 && coordMat[i][0] == coordMat[i - 1][0] && coordMat[i][0] == coordMat[i - 2][0])
                        System.out.print("Three points cannot be on the same line. Try again.\n");
                    else
                        isIncorrect = false;
                } while (isIncorrect);
            }
            // check that points cannot be repeated
            for (int i = 0; i < sidesNumb; i++)
            {
                for (int j = i + 1; j < sidesNumb; j++)
                {
                    if (coordMat[i][0] == coordMat[j][0] && coordMat[i][1] == coordMat[j][1])
                    {
                        isIncorrect = true;
                    }
                }
            }

            if (isIncorrect)
            {
                System.out.print("Points must be unique. Try again.\n");
            }
            else
            {
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
                                        isIncorrect = true;
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
                                    isIncorrect = true;
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
                                    if (((coordMat[i][0] < coordMat[j][0] && coordMat[i][0] < coordMat[j-1][0]) &&
                                            (coordMat[i-1][0] < coordMat[j][0] && coordMat[i - 1][0] < coordMat[j-1][0])) ||
                                            ((coordMat[i][0] > coordMat[j][0] && coordMat[i][0] > coordMat[j-1][0]) &&
                                                    (coordMat[i-1][0] > coordMat[j][0] && coordMat[i - 1][0] > coordMat[j-1][0])))
                                    {

                                    }
                                    else
                                        isIncorrect = true;
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
                                    isIncorrect = true;
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
                                    isIncorrect = true;
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
                                    isIncorrect = true;
                            }
                        }
                    }
                }
                // determine the test result
                if (isIncorrect)
                {
                    System.out.print("The rectangle must not be self-intersecting. Try again.\n");
                }
            }

        } while (isIncorrect);
        // main block
        // we consider the result to be the Gauss formula
        limForAmt = (short) (sidesNumb - 1);
        for (int i = 0; i < limForAmt; i++)
        {
            // we calculate two amounts at once, taking into account the sign (+/-)
            area = area + (coordMat[i][0] * coordMat[i + 1][1]) - (coordMat[i + 1][0] * coordMat[i][1]);
        }
        // transfer half the modulus of the available amount
        area = abs(area + (coordMat[sidesNumb - 1][0] * coordMat[0][1]) - (coordMat[sidesNumb - 1][1] * coordMat[0][0]));
        area = area / 2;
        // cout resoult
        System.out.printf("\nYour area is: %.3f.\n", area);
        in.close();
    }
}