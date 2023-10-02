package lab2;

import java.util.Scanner;

import static java.lang.Math.abs;

public class lab1 {
    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);
        final int MINSIDES = 3,
                MAXSIDES = 20;
        float area, slpFact, slpFact1, slpFact2, yInter,
                yInter1, yInter2, intPoint;
        int sidesNumb, limForAmt, ind, jOnI;
        boolean isInCorrect;

        //inicialization
        area = 0.0F;
        slpFact = 0.0F;//y = rx + b => slopefactor = r
        yInter = 0.0F;//y = fx + b => slopefactor = b
        slpFact1 = 0.0F;
        yInter1 = 0.0F;
        slpFact2 = 0.0F;
        yInter2 = 0.0F;
        intPoint = 0.0F;
        limForAmt = 0;//high in main block
        ind = 0;//x(index) and y(index)
        sidesNumb = 0;
        jOnI = 0;
        isInCorrect = true;//for input

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
                isInCorrect = false;
        } while (isInCorrect);

        //cin x and y
        float[][] coordMat = new float[sidesNumb][2];
        do
        {
            for (int i = 0; i < sidesNumb; i++)
            {
                ind = i + 1;
                do
                {
                    isInCorrect = true;
                    //cin x
                    do
                    {
                        System.out.printf("Write x%d:\n", ind);
                        try
                        {
                            coordMat[i][0] = Float.parseFloat(in.nextLine());
                            isInCorrect = false;
                        } catch (NumberFormatException error)
                        {
                            System.out.print("Error. Try again.\n");
                        }
                    } while (isInCorrect);
                    //cin y
                    isInCorrect = true;
                    do
                    {
                        System.out.printf("Write y%d:\n", ind);
                        try
                        {
                            coordMat[i][1] = Float.parseFloat(in.nextLine());
                            isInCorrect = false;
                        }
                        catch (NumberFormatException error)
                        {
                            System.out.print("Error. Try again.\n");
                        }
                    } while (isInCorrect);

                    isInCorrect = true;
                    // we check the points to see if they are on the same line
                    if (i > 1)
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
                                System.out.print("Three points cannot be on the same line. Try again.\n");
                            }
                            else
                            {
                                isInCorrect = false;
                            }
                        }
                    }
                    else
                    {
                        isInCorrect = false;
                    }
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
                        System.out.print("Points must be unique. Try again.\n");
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
                                if (((coordMat[i][0] < coordMat[j][0] && coordMat[i][0] < coordMat[j-1][0]) &&
                                        (coordMat[i-1][0] < coordMat[j][0] && coordMat[i - 1][0] < coordMat[j-1][0])) ||
                                        ((coordMat[i][0] > coordMat[j][0] && coordMat[i][0] > coordMat[j-1][0]) &&
                                                (coordMat[i-1][0] > coordMat[j][0] && coordMat[i - 1][0] > coordMat[j-1][0])))
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
                System.out.print("The rectangle must not be self-intersecting. Try again.\n");
            }
            in.close();
        } while (isInCorrect);
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
    }
}