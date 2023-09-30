package lab2;

import java.util.Scanner;

import static java.lang.Math.abs;

public class lab1 {
    public static void main(String[] args)
    {
        Scanner in = new Scanner(System.in);

        final float MINCOORDINATE = (float) -1000.0,
                MAXCOORDINATE = (float) 1000.0;
        float area, slopeFactor, slopeFactor1, slopeFactor2, yInterception,
                yInterception1, yInterception2, intersectionPoint;
        final short MINNUMBEROFSIDE = 3, MAXNUMBEROFSIDE = 20;
        short numberOfSides, limitForAmount;
        int index;
        boolean isInCorrect, isInCorrectCoordinate, isInCorrectAll, isInCorrectPolygon,
                isInCorrectPoints;

        //inicialization
        area = 0.0F;
        slopeFactor = 0.0F;//y = rx + b => slopefactor = r
        yInterception = 0.0F;//y = fx + b => slopefactor = b
        slopeFactor1 = 0.0F;
        yInterception1 = 0.0F;
        slopeFactor2 = 0.0F;
        yInterception2 = 0.0F;
        intersectionPoint = 0.0F;
        limitForAmount = 0;//high in main block
        index = 0;//x(index) and y(index)
        numberOfSides = 0;
        isInCorrect = true;//for input
        isInCorrectCoordinate = true;//for coordinate cheack
        isInCorrectAll = false;//for all block
        isInCorrectPolygon = false;//for poligon
        isInCorrectPoints = false;//for points cheack

        System.out.printf("""
                            This program calculates the area of a polygon. The number of sides of the polygon is selected by the user.
                            You also need to enter the coordinates of the polygon vertices.
        
                            *The Gauss formula is used for calculations*
                            
                            Restrictions:\s
                                    1. The number of sides of a polygon is an integer from %d to %d;
                                    2. Coordinates - floating point numbers from %.1f to %.1f;
                                    3. All points must be unique (not repeated);
                                    4. The vertices of the polygon should be listed in traversal order (clockwise / counterclockwise).";
                                    
                            """, MINNUMBEROFSIDE, MAXNUMBEROFSIDE, MINCOORDINATE, MAXCOORDINATE);

        //input number of sides
        do
        {
            System.out.print("Write number of sides of a polygon:\n");
            //cheack "Numeric input"
            try
            {
                numberOfSides = Short.parseShort(in.nextLine());
            }
            catch (NumberFormatException error)
            {
                System.err.print("Error.\n");
            }
            finally {
                //cheack restrictions
                if (numberOfSides < MINNUMBEROFSIDE || numberOfSides > MAXNUMBEROFSIDE)
                {
                    System.err.printf("The number of sides of a polygon is an integer from %d to %d. Try again.\n", MINNUMBEROFSIDE, MAXNUMBEROFSIDE);
                }
                else
                    isInCorrect = false;
            }
        } while (isInCorrect);

        //cin x and y
        float[][] coordinateMatrix = new float[numberOfSides][2];
        do
        {
            isInCorrectAll = false;
            for (int i = 0; i < numberOfSides; i++)
            {
                index = i + 1;
                isInCorrectCoordinate = true;
                do
                {
                    isInCorrect = true;
                    //cin x
                    do
                    {
                        System.out.printf("\nWrite x%d:\n", index);
                        try
                        {
                            coordinateMatrix[i][0] = Float.parseFloat(in.nextLine());
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
                        System.out.printf("Write y%d:\n", index);
                        try
                        {
                            coordinateMatrix[i][1] = Float.parseFloat(in.nextLine());
                            isInCorrect = false;
                        }
                        catch (NumberFormatException error)
                        {
                            System.out.print("Error. Try again.\n");
                        }
                    } while (isInCorrect);

                    // we check the points to see if they are on the same line
                    if (i > 1)
                    {
                        slopeFactor = (coordinateMatrix[i - 1][1] - coordinateMatrix[i - 2][1]) / (coordinateMatrix[i - 1][0] - coordinateMatrix[i - 2][0]);
                        yInterception = coordinateMatrix[i - 1][1] - coordinateMatrix[i - 1][0] * slopeFactor;
                        if (coordinateMatrix[i][1] == slopeFactor * coordinateMatrix[i][0] + yInterception)
                        {
                            System.out.print("Three points cannot be on the same line. Try again.\n");
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
                    if (!isInCorrectPoints && coordinateMatrix[i][0] == coordinateMatrix[j][0] && coordinateMatrix[i][1] == coordinateMatrix[j][1])
                    {
                        System.out.print("Points must be unique. Try again.\n");
                        isInCorrectAll = true;
                        isInCorrectPoints = true;
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
                        if (((yInterception1 > coordinateMatrix[j][1] && yInterception1 < coordinateMatrix[j-1][1]) ||
                                (yInterception1 < coordinateMatrix[j][1] && yInterception1 > coordinateMatrix[j-1][1])) &&
                                ((intersectionPoint > coordinateMatrix[j][0] && intersectionPoint < coordinateMatrix[j-1][0]) ||
                                        (intersectionPoint < coordinateMatrix[j][0] && intersectionPoint > coordinateMatrix[j-1][0])))
                            isInCorrectPolygon = true;
                    }
                }
                else
                {
                    slopeFactor1 = (coordinateMatrix[i][1] - coordinateMatrix[i - 1][1]) / (coordinateMatrix[i][0] - coordinateMatrix[i - 1][0]);
                    yInterception1 = coordinateMatrix[i][1] - coordinateMatrix[i][0] * slopeFactor1;
                    for(int j = i + 2; j < numberOfSides; j++)
                    {
                        slopeFactor2 = (coordinateMatrix[j][1] - coordinateMatrix[j - 1][1]) / (coordinateMatrix[j][0] - coordinateMatrix[j - 1][0]);
                        yInterception2 = coordinateMatrix[j][1] - coordinateMatrix[j][0] * slopeFactor2;
                        intersectionPoint = (yInterception2 - yInterception1) / (slopeFactor1 - slopeFactor2);
                        if (((intersectionPoint > coordinateMatrix[j][0] && intersectionPoint < coordinateMatrix[j-1][0]) ||
                                (intersectionPoint < coordinateMatrix[j][0] && intersectionPoint > coordinateMatrix[j-1][0])) &&
                                (coordinateMatrix[i][0] - coordinateMatrix[i-1][0] == coordinateMatrix[j][0] - coordinateMatrix[j-1][0]) &&
                                (coordinateMatrix[i][1] - coordinateMatrix[i-1][1] == coordinateMatrix[j][1] - coordinateMatrix[j-1][1]))
                            isInCorrectPolygon = true;
                    }
                }
            }

            // determine the test result
            if (isInCorrectPolygon)
            {
                isInCorrectAll = true;
                System.out.print("The rectangle must not be self-intersecting. Try again.\n");
            }
            // main block
            // we consider the result to be the Gauss formula
            if (!isInCorrectAll)
            {
                limitForAmount = (short) (numberOfSides - 1);
                for (int i = 0; i < limitForAmount; i++)
                {
                    // we calculate two amounts at once, taking into account the sign (+/-)
                    area = area + (coordinateMatrix[i][0] * coordinateMatrix[i + 1][1]) - (coordinateMatrix[i + 1][0] * coordinateMatrix[i][1]);
                }
                // transfer half the modulus of the available amount
                area = abs(area + (coordinateMatrix[numberOfSides - 1][0] * coordinateMatrix[0][1]) - (coordinateMatrix[numberOfSides - 1][1] * coordinateMatrix[0][0]));
                area = area / 2;
                // cout resoult
                System.out.printf("\nYour area is: %.3f.\n", area);
                in.close();
            }
        } while (isInCorrectAll);
    }
}