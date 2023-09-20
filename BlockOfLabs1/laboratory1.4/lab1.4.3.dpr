Program Lab4;

Uses
    System.SysUtils;
    
Var
    Arr: Array Of Double;
    NumberInMassive, I: integer;
    SumNumb: Double;
    IsCorrect: Boolean;

Begin 
    NumberInMassive := 0;
    SumNumb := 0;
    IsCorrect := true;

    Writeln('  The program calculates the sum of all odd elements entered by the user.', #10,
        '*Please note that the numbering of the entered numbers starts from zero.*', #10, #10,
        'Restrictions: The number of all elements is an integer;', #10,
        '              Numbers can be any: both integers and reals.', #10);

    REPEAT
        Try
            Writeln('How many numbers will you write?');
            Readln(NumberInMassive);
            IsCorrect := True;
        Except
            IsCorrect := False;
            Writeln('Number entered incorrectly.');
        End;
    UNTIL IsCorrect; 

    SetLength(Arr, NumberInMassive);

    REPEAT
        TRY
        For I := 0 To NumberInMassive - 1 Do
        Begin
            Writeln('Write your ', I + 1, ' number.');
            Read(Arr[i]);
            IsCorrect := true;
        End;
        except
            IsCorrect := false;
            Writeln('Number entered incorrectly.');
        END;
    UNTIL IsCorrect;

    For I := 1 To NumberInMassive - 1 Do
    Begin
        If I Mod 2 <> 0 Then
        Begin
            SumNumb := SumNumb + Arr[I];
        End;
    End;
    SetLength(Arr, 0);
    Writeln('Sum of all odd numbers - ', SumNumb:3:3);
    Readln;
    Readln;
End.
