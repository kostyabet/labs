Program lab1;

Uses
    System.SysUtils;

Const
    MINCOORDINATE = -1000.0;
    MAXCOORDINATE = 1000.0;
    MINNUMBEROFSIDES = 3;
    MAXNUMBEROFSIDES = 20;

Var
    CoordinateMatrix: Array Of Array Of Real;
    Area, SlopeFactor, Slopefactor1, Slopefactor2, YInterception, YInterception1, YInterception2, IntersectionPoint: Real;
    NumberOfSides, LimitforAmount, Index, I, J, HighXY, JOnI: Integer;
    IsCorrect, IsCorrectCoordinate, IsCorrectAll, IsCorrectPolygon, IsCorrectPoints: Boolean;

Begin
    //inicialization
    Area := 0.0;
    SlopeFactor := 0.0; //y = rx + b => slopefactor = r
    YInterception := 0.0; //y = fx + b => slopefactor = b
    SlopeFactor1 := 0.0;
    YInterception1 := 0.0;
    SlopeFactor2 := 0.0;
    YInterception2 := 0.0;
    IntersectionPoint := 0.0;
    HighXY := 0;
    JOnI := 0;
    LimitForAmount := 0; //high in main block
    Index := 0; //x(index) and y(index)
    NumberOfSides := 0;
    IsCorrect := False; //for input
    IsCorrectCoordinate := True; //for coordinate cheack
    IsCorrectAll := True; //for all block
    IsCorrectPolygon := True; //for poligon
    IsCorrectPoints := True; //for points cheack

    Write('This program calculates the area of a polygon.',#13#10, 
          'The number of sides of the polygon is selected by the user.', #13#10,
          'You also need to enter the coordinates of the polygon vertices.', #13#10, 
          #13#10, '*The Gauss formula is used for calculations*',
          #13#10, #13#10, 'Restrictions:', #13#10#9, '1. The number of sides of a polygon', 
          ' is an integer from 3 to 20;', #13#10#9,
          '2. Coordinates - floating point', ' numbers from -1000.0 to 1000.0;', #13#10#9, 
          '3. All points must be unique (not ', 'repeated);',
          #13#10#9, '4. The vertices of the polygon should be listed', ' in traversal order.',
           #13#10#9#9#9#9#9,'(clockwise / counterclockwise)', #13#10, #13#10);

    //input number of sides
    Repeat
        Write('Write number of sides of a polygon:', #13#10);
        //cheack "Numeric input"
        Try
            Readln(NumberOfSides);
        Except
            Write('Error.', #13#10);
        End;
        //cheack restrictions
        If (NumberOfSides < MINNUMBEROFSIDES) Or (NumberOfSides > MAXNUMBEROFSIDES) Then
            Write('The number of sides of a polygon is an integer from ', MINNUMBEROFSIDES, ' to ', MAXNUMBEROFSIDES,
                '. Try again.', #13#10)
        Else
            IsCorrect := True;
    Until IsCorrect;

    //cin x and y
    Setlength(CoordinateMatrix, NumberOfSides, 2);
    Repeat
        IsCorrectAll := True;
        HighXY := NumberOfSides - 1;
        For I := 0 To HighXY Do
        Begin
            Index := I + 1;
            IsCorrectCoordinate := False;
            Repeat
                //cin x
                IsCorrect := False;
                Repeat
                    Write('Write x', Index, ':', #13#10);
                    Try
                        Readln(CoordinateMatrix[I][0]);
                        IsCorrect := True;
                    Except
                        Write('Error. Try again', #13#10);
                    End;
                Until IsCorrect;
                //cin y
                IsCorrect := False;
                Repeat
                    Write('Write y', Index, ':', #13#10);
                    Try
                        Readln(CoordinateMatrix[I][1]);
                        IsCorrect := True;
                    Except
                        Write('Error. Try again.', #13#10);
                    End;
                Until IsCorrect;
                //we check the points to see if they are on the same line
                If (I > 1) And (CoordinateMatrix[I - 1][0] - CoordinateMatrix[I - 2][0] <> 0) Then
                Begin
                    If (CoordinateMatrix[I - 1][0] - CoordinateMatrix[I - 2][0] = 0) Then
                    Else
                    Begin
                        SlopeFactor := (CoordinateMatrix[I - 1][1] - CoordinateMatrix[I - 2][1]) /
                            (CoordinateMatrix[I - 1][0] - CoordinateMatrix[I - 2][0]);
                        YInterception := CoordinateMatrix[I - 1][1] - CoordinateMatrix[I - 1][0] * SlopeFactor;
                        If (CoordinateMatrix[I][1] = SlopeFactor * CoordinateMatrix[I][0] + YInterception) Then
                            Write('Three points cannot be on the same line. Try again.', #13#10)
                        Else
                            IsCorrectCoordinate := True;
                    End;
                End
                Else
                    IsCorrectCoordinate := True;
            Until IsCorrectCoordinate;
        End;

        //cheack that points cannot be repeated
        For I := 0 To HighXY Do
        Begin
            JOnI := I + 1;
            For J := JOnI To HighXY Do
            Begin
                If IsCorrectPoints And (CoordinateMatrix[I][0] = CoordinateMatrix[J][0]) And
                    (CoordinateMatrix[I][1] = CoordinateMatrix[J][1]) Then
                Begin
                    Write('Points must be unique. Try again.', #13#10);
                    IsCorrectAll := False;
                    IsCorrectPoints := False;
                End;
            End;
        End;

        //the main block of checking that there are no self-intersections
        For I := 1 To HighXY Do
        Begin
            JOnI := I + 2;
            If CoordinateMatrix[I][0] - CoordinateMatrix[I - 1][0] = 0 Then
            Begin
                YInterception1 := CoordinateMatrix[I][0];
                For J := JOnI To HighXY Do
                Begin
                    If CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0] = 0 Then
                    Begin
                        YInterception2 := CoordinateMatrix[J][0];
                        If (YInterception1 = YInterception2) Then
                        Begin
                            If ((((CoordinateMatrix[J][1] > CoordinateMatrix[I][1]) And (CoordinateMatrix[J][1] > CoordinateMatrix[I - 1][1]
                                )) And ((CoordinateMatrix[J - 1][1] > CoordinateMatrix[I][1]) And
                                (CoordinateMatrix[J - 1][1] > CoordinateMatrix[I - 1][1]))) Or
                                (((CoordinateMatrix[J][1] < CoordinateMatrix[I][1]) And (CoordinateMatrix[J][1] < CoordinateMatrix[I - 1][1]
                                )) And ((CoordinateMatrix[J - 1][1] < CoordinateMatrix[I][1]) And
                                (CoordinateMatrix[J - 1][1] < CoordinateMatrix[I - 1][1])))) Then
                            Else
                                IsCorrectPolygon := False;
                        End

                    End
                    Else
                    Begin
                        SlopeFactor2 := (CoordinateMatrix[J][1] - CoordinateMatrix[J - 1][1]) /
                            (CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0]);
                        YInterception2 := CoordinateMatrix[J][1] - CoordinateMatrix[J][0] * SlopeFactor2;
                        IntersectionPoint := (YInterception2 - YInterception1) / (SlopeFactor1 - SlopeFactor2);
                        If (((YInterception1 > CoordinateMatrix[J][0]) And (YInterception1 < CoordinateMatrix[J - 1][0])) Or
                            ((YInterception1 < CoordinateMatrix[J][0]) And (YInterception1 > CoordinateMatrix[J - 1][0])) And
                            (((IntersectionPoint > CoordinateMatrix[J][1]) And (IntersectionPoint < CoordinateMatrix[J - 1][1])) Or
                            ((IntersectionPoint < CoordinateMatrix[J][1]) And (IntersectionPoint > CoordinateMatrix[J - 1][1])))) Then
                            IsCorrectPolygon := False;
                    End;
                End;
            End
            Else
                If CoordinateMatrix[I][1] - CoordinateMatrix[I - 1][1] = 0 Then
                Begin
                    YInterception1 := CoordinateMatrix[I][1];
                    For J := JOnI To HighXY Do
                    Begin
                        If CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0] = 0 Then
                        Begin
                            YInterception2 := CoordinateMatrix[I][1];
                            If (YInterception1 = YInterception2) Then
                            Begin
                                If ((((CoordinateMatrix[I][0] < CoordinateMatrix[J][0]) And
                                    (CoordinateMatrix[I][0] < CoordinateMatrix[J - 1][0])) And
                                    ((CoordinateMatrix[I - 1][0] < CoordinateMatrix[J][0]) And
                                    (CoordinateMatrix[I - 1][0] < CoordinateMatrix[J - 1][0]))) Or
                                    (((CoordinateMatrix[I][0] > CoordinateMatrix[J][0]) And
                                    (CoordinateMatrix[I][0] > CoordinateMatrix[J - 1][0])) And
                                    ((CoordinateMatrix[I - 1][0] > CoordinateMatrix[J][0]) And
                                    (CoordinateMatrix[I - 1][0] > CoordinateMatrix[J - 1][0])))) Then
                                Else
                                    IsCorrectPolygon := False;
                            End;
                        End
                        Else
                        Begin
                            SlopeFactor2 := (CoordinateMatrix[J][1] - CoordinateMatrix[J - 1][1]) /
                                (CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0]);
                            YInterception2 := CoordinateMatrix[J][1] - CoordinateMatrix[J][0] * SlopeFactor2;
                            IntersectionPoint := (YInterception2 - YInterception1) / (SlopeFactor1 - SlopeFactor2);
                            If ((((YInterception1 > CoordinateMatrix[J][1]) And (YInterception1 < CoordinateMatrix[J - 1][1])) Or
                                ((YInterception1 < CoordinateMatrix[J][1]) And (YInterception1 > CoordinateMatrix[J - 1][1]))) And
                                (((IntersectionPoint > CoordinateMatrix[J][0]) And (IntersectionPoint < CoordinateMatrix[J - 1][0])) Or
                                ((IntersectionPoint < CoordinateMatrix[J][0]) And (IntersectionPoint > CoordinateMatrix[J - 1][0])))) Then
                                IsCorrectPolygon := False;
                        End;
                    End;
                End
                Else
                Begin
                    SlopeFactor1 := (CoordinateMatrix[I][1] - CoordinateMatrix[I - 1][1]) /
                        (CoordinateMatrix[I][0] - CoordinateMatrix[I - 1][0]);
                    YInterception1 := CoordinateMatrix[I][1] - CoordinateMatrix[I][0] * SlopeFactor1;
                    For J := JOnI To HighXY Do
                    Begin
                        If (CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0] = 0) Then
                        Begin
                            YInterception2 := CoordinateMatrix[J][0];
                            IntersectionPoint := SlopeFactor1 * YInterception2 + YInterception1;
                            If (((IntersectionPoint > CoordinateMatrix[J][1]) And (IntersectionPoint > CoordinateMatrix[J - 1][1])) Or
                                ((IntersectionPoint < CoordinateMatrix[J][1]) And (IntersectionPoint < CoordinateMatrix[J - 1][1]))) Then
                            Else
                                IsCorrectPolygon := False;
                        End
                        Else
                        Begin
                            SlopeFactor2 := (CoordinateMatrix[J][1] - CoordinateMatrix[J - 1][1]) /
                                (CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0]);
                            YInterception2 := CoordinateMatrix[J][1] - CoordinateMatrix[J][0] * SlopeFactor2;
                            IntersectionPoint := (YInterception2 - YInterception1) / (SlopeFactor1 - SlopeFactor2);
                            If ((((IntersectionPoint > CoordinateMatrix[J][0]) And (IntersectionPoint < CoordinateMatrix[J - 1][0])) Or
                                ((IntersectionPoint < CoordinateMatrix[J][0]) And (IntersectionPoint > CoordinateMatrix[J - 1][0]))) And
                                (CoordinateMatrix[I][0] - CoordinateMatrix[I - 1][0] = CoordinateMatrix[J][0] - CoordinateMatrix[J - 1][0])
                                And (CoordinateMatrix[I][1] - CoordinateMatrix[I - 1][1] = CoordinateMatrix[J][1] -
                                CoordinateMatrix[J - 1][1])) Then
                                IsCorrectPolygon := False;
                        End;
                    End;
                End;
        End;
        //determine the test result
        If (IsCorrectPolygon <> True) Then
        Begin
            IsCorrectAll := False;
            IsCorrectPolygon := True;
            Write('The rectangle must not be self-intersecting. Try again.', #13#10);
        End;

    Until IsCorrectAll;        
    //main block
    //we consider the result to be the Gauss formula
    LimitForAmount := NumberOfSides - 2;
    For I := 0 To LimitForAmount Do
    Begin
        //we calculate two amounts at once, taking into account the sign (+/-)
        Area := Area + (CoordinateMatrix[I][0] * CoordinateMatrix[I + 1][1]) -
            (CoordinateMatrix[I + 1][0] * CoordinateMatrix[I][1]);
    End;
    //transfer half the modulus of the available amount
    Area := Abs(Area + (CoordinateMatrix[NumberOfSides - 1][0] * CoordinateMatrix[0][1]) -
        (CoordinateMatrix[NumberOfSides - 1][1] * CoordinateMatrix[0][0]));
    Area := Area / 2;
    //cout resoult
    Write(#13#10, 'Your area is: ', Area:7:3, '.', #13#10);
    Writeln('Press any key to continue.');
    Readln;

End.
