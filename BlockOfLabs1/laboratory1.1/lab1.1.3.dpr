Program Lab1;

Uses
    System.SysUtils;

Const
    MINYEAR = 18; //minimum age
    MAXYEAR = 120; //maximum age
    Flag = True;

Var
    Gender: Char = '0';
    Year: Integer = 0;
    IsCorrect: Boolean = True;

Begin
    //condition
    Writeln('  The program will ask the user for their gender and age.');
    Writeln('The age of your significant other will be calculated using the formulas!!!');
    Writeln('');
    Writeln('Age restrictions: from ', MINYEAR, ' to ', MAXYEAR, '.');

    While Flag Do
    Begin
        IsCorrect := True;
        //entering gender
        Writeln('');
        Writeln('');
        Writeln('Select your gender. If you are a man, then (M), if you are a woman, then (W).');
        Readln(Gender);
        //gender verification
        If (Gender <> 'M') And (Gender <> 'm') And (Gender <> 'W') And (Gender <> 'w') Then
        Begin
            Writeln('Wrong gender selected.');
            IsCorrect := False;
        End;

        If IsCorrect = True Then
        Begin
            //entering age
            Writeln('Write your age in years.');
            Readln(Year);
        End;

        //age verification
        If (IsCorrect = True) And (Year > MaxYear) Then
        Begin
            IsCorrect := False;
            Writeln('The age is great. The permissible maximum age for the program is 120 years.');
        End;

        If (IsCorrect = True) And (Year < MINYEAR) Then
        Begin
            IsCorrect := False;
            Writeln('Age is small.  The acceptable minimum age for the program is 18 years.');
        End;

        //conclusion
        If (IsCorrect = True) And ((Gender = 'M') Or (Gender = 'm')) Then
        Begin
            //checking your significant other's age
            If ((Year Div 2) + 7 < MinYear) Then
            Begin
                Write('The age of your significant other is below the acceptable norm (18). ', FormatFloat('#', (Year / 2) + 7));
            End
            //main conclusion
            Else
            Begin
                Write('You are a man and you ', Year, ', and to your soulmate ', FormatFloat('#', (Year / 2) + 7), '.');
            End;
        End
        //if it's a girl
        Else
            If (Gender = 'W') Or (Gender = 'w') Then
            Begin
                //checking your significant other's age
                If ((Year * 2) - 14 > MaxYear) Then
                Begin
                    Write('The age of your significant other has exceeded the maximum norm (120). ', (Year * 2) - 14);
                End
                //main conclusion
                Else
                Begin
                    Write('You are a woman and you ', Year, ', and to your soulmate ', (Year * 2) - 14, '.');
                End;
            End;
    End;
    Readln;

End.