Program Lab1;

Uses
    System.SysUtils;

Const
    MINYEAR = 18;
    MAXYEAR = 120;

Var
    Gender: Char = '0';
    Year: Integer = 0;
    IsCorrect: Boolean = True;
    Flag: Boolean = True;

Begin
    Writeln('  The program will ask the user for their gender and age.', #13#10,
        'The age of your significant other will be calculated using the formulas!!!', #13#10, #13#10, 'Age restrictions: from ', MINYEAR,
        ' to ', MAXYEAR, '.', #13#10, #13#10);
    Repeat
        Try
            IsCorrect := False;
            Writeln('Select your gender. If you are a man, then (M), if you are a woman, then (W).');
            Readln(Gender);
            If (Gender <> 'M') And (Gender <> 'm') And (Gender <> 'W') And (Gender <> 'w') Then
            Begin
                Raise Exception.Create('Wrong gender selection.');
            End;
            Writeln('Write your age in years.');
            Readln(Year);
            If (Year > MAXYEAR) Then
            Begin
                Raise Exception.Create('The age is great. The permissible maximum age for the program is 120 years.');
            End
            Else
                If (Year < MINYEAR) Then
                Begin
                    Raise Exception.Create('Age is small.  The acceptable minimum age for the program is 18 years.');
                End;
            If (Gender = 'M') Or (Gender = 'm') Then
            Begin
                If ((Year Div 2) + 7 < MinYear) Then
                Begin
                    Write('The age of your significant other is below the acceptable norm (18). ', FormatFloat('#', (Year / 2) + 7));
                End
                Else
                Begin
                    Write('You are a man and you ', Year, ', and to your soulmate ', FormatFloat('#', (Year / 2) + 7), '.');
                End;
            End
            Else
                If (Gender = 'W') Or (Gender = 'w') Then
                Begin
                    If ((Year * 2) - 14 > MaxYear) Then
                    Begin
                        Write('The age of your significant other has exceeded the maximum norm (120). ', (Year * 2) - 14);
                    End
                    Else
                    Begin
                        Write('You are a woman and you ', Year, ', and to your soulmate ', (Year * 2) - 14, '.');
                    End;
                End;
            Readln;
            Readln;
            IsCorrect := True;
        Except
            On Error: Exception Do
            Begin
                Writeln(Error.Message);
            End;
        End;
    Until IsCorrect;

End.