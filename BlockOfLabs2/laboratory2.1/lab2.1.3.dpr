Program lab1;

Uses
    System.SysUtils;

Const
    MINSIDES = 3;
    MAXSIDES = 20;

Var
    CoordMat: Array Of Array Of Real;
    Area, SlpFact, SlpFact1, SlpFact2, YInter, YInter1, YInter2, IntPoint: Real;
    SidesNumb, LimForAmt, Ind, I, J, HighXY, JOnI: Integer;
    IsCorrect: Boolean;

Begin
    //inicialization
    Area := 0.0;
    SlpFact := 0.0; //y = rx + b => slopefactor = r
    YInter := 0.0; //y = fx + b => slopefactor = b
    SlpFact1 := 0.0;
    YInter1 := 0.0;
    SlpFact2 := 0.0;
    YInter2 := 0.0;
    IntPoint := 0.0;
    HighXY := 0;
    JOnI := 0;
    LimForAmt := 0; //high in main block
    Ind := 0; //x(index) and y(index)
    SidesNumb := 0;
    IsCorrect := False; //for input

    Write('This program calculates the area of a polygon.', #13#10, 'The number of sides of the polygon is selected by the user.', #13#10,
        'You also need to enter the coordinates of the polygon vertices.', #13#10, #13#10, '*The Gauss formula is used for calculations*',
        #13#10, #13#10, 'Restrictions:', #13#10#9, '1. The number of sides of a polygon', ' is an integer from 3 to 20;', #13#10#9,
        '2. Coordinates - floating point', ' numbers from -1000.0 to 1000.0;', #13#10#9, '3. All points must be unique (not ', 'repeated);',
        #13#10#9, '4. The vertices of the polygon should be listed', ' in traversal order.', #13#10#9#9#9#9#9,
        '(clockwise / counterclockwise)', #13#10, #13#10);

    //input number of sides
    Repeat
        Write('Write number of sides of a polygon:', #13#10);
        //cheack "Numeric input"
        Try
            Readln(SidesNumb);
        Except
            Write('Error.', #13#10);
        End;
        //cheack restrictions
        If (SidesNumb < MINSIDES) Or (SidesNumb > MAXSIDES) Then
            Write('The number of sides of a polygon is an integer from ', MINSIDES, ' to ', MAXSIDES, '. Try again.', #13#10)
        Else
            IsCorrect := True;
    Until IsCorrect;

    //cin x and y
    Setlength(CoordMat, SidesNumb, 2);
    Repeat
        HighXY := SidesNumb - 1;
        For I := 0 To HighXY Do
        Begin
            Ind := I + 1;
            IsCorrect := False;
            Repeat
                //cin x
                IsCorrect := False;
                Repeat
                    Write('Write x', Ind, ':', #13#10);
                    Try
                        Readln(CoordMat[I][0]);
                        IsCorrect := True;
                    Except
                        Write('Error. Try again', #13#10);
                    End;
                Until IsCorrect;
                //cin y
                IsCorrect := False;
                Repeat
                    Write('Write y', Ind, ':', #13#10);
                    Try
                        Readln(CoordMat[I][1]);
                        IsCorrect := True;
                    Except
                        Write('Error. Try again.', #13#10);
                    End;
                Until IsCorrect;

                IsCorrect := False;
                //we check the points to see if they are on the same line
                If (I > 1) And (CoordMat[I - 1][0] - CoordMat[I - 2][0] <> 0) Then
                Begin
                    If (CoordMat[I - 1][0] - CoordMat[I - 2][0] = 0) Then
                    Else
                    Begin
                        SlpFact := (CoordMat[I - 1][1] - CoordMat[I - 2][1]) / (CoordMat[I - 1][0] - CoordMat[I - 2][0]);
                        YInter := CoordMat[I - 1][1] - CoordMat[I - 1][0] * SlpFact;
                        If (CoordMat[I][1] = SlpFact * CoordMat[I][0] + YInter) Then
                            Write('Three points cannot be on the same line. Try again.', #13#10)
                        Else
                            IsCorrect := True;
                    End;
                End
                Else
                    IsCorrect := True;
            Until IsCorrect;
        End;

        //cheack that points cannot be repeated
        For I := 0 To HighXY Do
        Begin
            JOnI := I + 1;
            For J := JOnI To HighXY Do
            Begin
                If IsCorrect = False And (CoordMat[I][0] = CoordMat[J][0]) And (CoordMat[I][1] = CoordMat[J][1]) Then
                Begin
                    Write('Points must be unique. Try again.', #13#10);
                    IsCorrect := True;
                End;
            End;
        End;

        //the main block of checking that there are no self-intersections
        For I := 1 To HighXY Do
        Begin
            JOnI := I + 2;
            If CoordMat[I][0] - CoordMat[I - 1][0] = 0 Then
            Begin
                YInter1 := CoordMat[I][0];
                For J := JOnI To HighXY Do
                Begin
                    If CoordMat[J][0] - CoordMat[J - 1][0] = 0 Then
                    Begin
                        YInter2 := CoordMat[J][0];
                        If (YInter1 = YInter2) Then
                        Begin
                            If ((((CoordMat[J][1] > CoordMat[I][1]) And (CoordMat[J][1] > CoordMat[I - 1][1])) And
                                ((CoordMat[J - 1][1] > CoordMat[I][1]) And (CoordMat[J - 1][1] > CoordMat[I - 1][1]))) Or
                                (((CoordMat[J][1] < CoordMat[I][1]) And (CoordMat[J][1] < CoordMat[I - 1][1])) And
                                ((CoordMat[J - 1][1] < CoordMat[I][1]) And (CoordMat[J - 1][1] < CoordMat[I - 1][1])))) Then
                            Else
                                IsCorrect := False;
                        End

                    End
                    Else
                    Begin
                        SlpFact2 := (CoordMat[J][1] - CoordMat[J - 1][1]) / (CoordMat[J][0] - CoordMat[J - 1][0]);
                        YInter2 := CoordMat[J][1] - CoordMat[J][0] * SlpFact2;
                        IntPoint := (YInter2 - YInter1) / (SlpFact1 - SlpFact2);
                        If (((YInter1 > CoordMat[J][0]) And (YInter1 < CoordMat[J - 1][0])) Or
                            ((YInter1 < CoordMat[J][0]) And (YInter1 > CoordMat[J - 1][0])) And
                            (((IntPoint > CoordMat[J][1]) And (IntPoint < CoordMat[J - 1][1])) Or ((IntPoint < CoordMat[J][1]) And
                            (IntPoint > CoordMat[J - 1][1])))) Then
                            IsCorrect := False;
                    End;
                End;
            End
            Else
                If CoordMat[I][1] - CoordMat[I - 1][1] = 0 Then
                Begin
                    YInter1 := CoordMat[I][1];
                    For J := JOnI To HighXY Do
                    Begin
                        If CoordMat[J][0] - CoordMat[J - 1][0] = 0 Then
                        Begin
                            YInter2 := CoordMat[I][1];
                            If (YInter1 = YInter2) Then
                            Begin
                                If ((((CoordMat[I][0] < CoordMat[J][0]) And (CoordMat[I][0] < CoordMat[J - 1][0])) And
                                    ((CoordMat[I - 1][0] < CoordMat[J][0]) And (CoordMat[I - 1][0] < CoordMat[J - 1][0]))) Or
                                    (((CoordMat[I][0] > CoordMat[J][0]) And (CoordMat[I][0] > CoordMat[J - 1][0])) And
                                    ((CoordMat[I - 1][0] > CoordMat[J][0]) And (CoordMat[I - 1][0] > CoordMat[J - 1][0])))) Then
                                Else
                                    IsCorrect := False;
                            End;
                        End
                        Else
                        Begin
                            SlpFact2 := (CoordMat[J][1] - CoordMat[J - 1][1]) / (CoordMat[J][0] - CoordMat[J - 1][0]);
                            YInter2 := CoordMat[J][1] - CoordMat[J][0] * SlpFact2;
                            IntPoint := (YInter2 - YInter1) / (SlpFact1 - SlpFact2);
                            If ((((YInter1 > CoordMat[J][1]) And (YInter1 < CoordMat[J - 1][1])) Or ((YInter1 < CoordMat[J][1]) And
                                (YInter1 > CoordMat[J - 1][1]))) And (((IntPoint > CoordMat[J][0]) And (IntPoint < CoordMat[J - 1][0])) Or
                                ((IntPoint < CoordMat[J][0]) And (IntPoint > CoordMat[J - 1][0])))) Then
                                IsCorrect := False;
                        End;
                    End;
                End
                Else
                Begin
                    SlpFact1 := (CoordMat[I][1] - CoordMat[I - 1][1]) / (CoordMat[I][0] - CoordMat[I - 1][0]);
                    YInter1 := CoordMat[I][1] - CoordMat[I][0] * SlpFact1;
                    For J := JOnI To HighXY Do
                    Begin
                        If (CoordMat[J][0] - CoordMat[J - 1][0] = 0) Then
                        Begin
                            YInter2 := CoordMat[J][0];
                            IntPoint := SlpFact1 * YInter2 + YInter1;
                            If (((IntPoint > CoordMat[J][1]) And (IntPoint > CoordMat[J - 1][1])) Or
                                ((IntPoint < CoordMat[J][1]) And (IntPoint < CoordMat[J - 1][1]))) Then
                            Else
                                IsCorrect := False;
                        End
                        Else
                        Begin
                            SlpFact2 := (CoordMat[J][1] - CoordMat[J - 1][1]) / (CoordMat[J][0] - CoordMat[J - 1][0]);
                            YInter2 := CoordMat[J][1] - CoordMat[J][0] * SlpFact2;
                            IntPoint := (YInter2 - YInter1) / (SlpFact1 - SlpFact2);
                            If ((((IntPoint > CoordMat[J][0]) And (IntPoint < CoordMat[J - 1][0])) Or ((IntPoint < CoordMat[J][0]) And
                                (IntPoint > CoordMat[J - 1][0]))) And (CoordMat[I][0] - CoordMat[I - 1][0] = CoordMat[J][0] -
                                CoordMat[J - 1][0]) And (CoordMat[I][1] - CoordMat[I - 1][1] = CoordMat[J][1] - CoordMat[J - 1][1])) Then
                                IsCorrect := False;
                        End;
                    End;
                End;
        End;
        //determine the test result
        If (IsCorrect <> True) Then
        Begin
            Write('The rectangle must not be self-intersecting. Try again.', #13#10);
        End;

    Until IsCorrect;
    //main block
    //we consider the result to be the Gauss formula
    LimForAmt := SidesNumb - 2;
    For I := 0 To LimForAmt Do
    Begin
        //we calculate two amounts at once, taking into account the sign (+/-)
        Area := Area + (CoordMat[I][0] * CoordMat[I + 1][1]) - (CoordMat[I + 1][0] * CoordMat[I][1]);
    End;
    //transfer half the modulus of the available amount
    Area := Abs(Area + (CoordMat[SidesNumb - 1][0] * CoordMat[0][1]) - (CoordMat[SidesNumb - 1][1] * CoordMat[0][0]));
    Area := Area / 2;
    //cout resoult
    Write(#13#10, 'Your area is: ', Area:7:3, '.', #13#10);
    Writeln('Press any key to continue.');
    Readln;

End.
