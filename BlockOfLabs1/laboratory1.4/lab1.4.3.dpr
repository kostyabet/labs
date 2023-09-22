Program Lab4;

Uses
    System.SysUtils;

Var
    ArrayOfNumbers: Array Of Real;
    NumberInMassive, I, High: Integer;
    SumNumb: Real;
    IsCorrect: Boolean;

Begin
    NumberInMassive := 0;
    SumNumb := 0;
    IsCorrect := False;
    High := 0;

    Writeln('  The program calculates the sum of all odd elements entered by the user.', #10,
        '*Please note that the numbering of the entered numbers starts from zero.*', #10, #10,
        'Restrictions: The number of all elements is an integer;', #10,
        'Restrictions: Numbers can be any: both integers and reals.', #10);

    Repeat
        Try
            Writeln('How many numbers will you write?');
            Readln(NumberInMassive);
            If NumberInMassive < 1 Then
            Begin
                Writeln('Number should be > 0. Try again.');
            End
            Else
            Begin
                IsCorrect := True;
            End;
        Except
            Writeln('Number entered incorrectly.');
        End;
    Until IsCorrect;

    SetLength(ArrayOfNumbers, NumberInMassive);
    High := NumberInMassive - 1;
    IsCorrect := False;
    Repeat
        Try
            For I := 0 To High Do
            Begin
                Writeln('Write your ', I + 1, ' number.');
                Read(ArrayOfNumbers[I]);
            End;
            IsCorrect := True;
        Except
            Writeln('Number entered incorrectly.');
        End;
    Until IsCorrect;

    For I := 1 To High Do
    Begin
        If I Mod 2 <> 0 Then
        Begin
            SumNumb := SumNumb + ArrayOfNumbers[I];
        End;
    End;

    ArrayOfNumbers := Nil;

    Writeln('Sum of all odd numbers - ', SumNumb:3:3);
    Readln;
    Readln;

End.
