Program Lab4;

Uses
    System.SysUtils;

Var
    Arr: Array Of Double;

Var
    NumberInMassive: Integer = 0;
    Buffer: Double = 0;
    SumNumb: Double = 0;
    IsCorrect: Boolean = True;
    I: Integer;

Begin
    Writeln('  The program calculates the sum of all odd elements entered by the user.', #13#10,
        '*Please note that the numbering of the entered numbers starts from zero.*', #13#10, #13#10,
        'Restrictions: The number of all elements is an integer;', #13#10,
        '              Numbers can be any: both integers and reals.', #13#10);

    REPEAT
        Try
            Writeln('How many numbers will you write?');
            Readln(NumberInMassive);
            SetLength(Arr, NumberInMassive);

            Writeln('Enter numbers using "Space" or "Enter".');
            For I := 0 To NumberInMassive - 1 Do
            Begin
                Read(Buffer);
                Arr[I] := Buffer;
            End;

            For I := 1 To NumberInMassive Do
            Begin
                If I Mod 2 <> 0 Then
                Begin
                    SumNumb := SumNumb + Arr[I];
                End;
            End;

            Writeln('Sum of all odd numbers - ', FormatFloat('#.###',SumNumb));
            IsCorrect := False;
        Except
            On Error: Exception Do
            Begin
                Writeln(Error.Message);
            End;
        End;
    UNTIL IsCorrect;
End.