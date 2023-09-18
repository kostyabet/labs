Program Lab_3;

Uses
    System.SysUtils;

Const
    MINEPS = 0.0;
    MAXEPS = 0.1;

Var
    X: Double = 0.0;
    EPS: Double = MaxEPS;
    Y: Double = 0.0;
    Y0: Double = 1.0;
    Number: Integer = 0;
    Coefficient: Integer = 1;
    IsCorrect: Boolean = True;

Begin
    Writeln('  The program calculates the value of the cube root ', #13#10, 'from the number X entered by a person.', #13#10,
        'With accuracy up to the number EPS entered by the user.', #13#10, #13#10, 'Restrictions X: No restrictions.', #13#10,
        'Restrictions EPS: (0; 0.1).', #13#10, #13#10);
    Repeat
        Try
            Begin
                IsCorrect := False;
                Writeln('Write the cube root of which number you want to find?');
                Read(X);
                Writeln('With what EPS must the calculations be made?');
                Read(EPS);
                If (EPS > MAXEPS) Then
                Begin
                    Raise Exception.Create('EPS is too high. EPS must be less than 0.1.');
                End
                Else
                    If (EPS < MINEPS) Then
                    Begin
                        Raise Exception.Create('EPS cannot be less than 0');
                    End
                    Else
                        If (EPS = MINEPS) Then
                        Begin
                            Raise Exception.Create('EPS cannot be 0');
                        End;
                Writeln(#13#10, 'Your X: ', FormatFloat('0.###', X), #13#10, 'Your EPS: ', FormatFloat('0.###', EPS), #13#10);
                If (X < 0) Then
                Begin
                    Coefficient := -1;
                    X := -X;
                End;
                If (X = 0) Then
                Begin
                    Y := X;
                    Number := 1;
                End
                Else
                Begin
                    Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number := Number + 1;
                    If (Abs(Y - Y0) > EPS) Then
                    Begin
                        Y0 := Y;
                        Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number := Number + 1;
                        While (Abs(Y - Y0) > EPS) Do
                        Begin
                            Y0 := Y;
                            Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number := Number + 1;
                        End;
                    End;
                End;
                Writeln('Cube root of ', FormatFloat('0.###', X), ' = ', FormatFloat('0.###', Coefficient * Y));
                Writeln('Number of operations for which EPS was achieved - ', Number);
            End;
            IsCorrect := True;
        Except
            On Error: Exception Do
            Begin
                Writeln(Error.Message);
            End;
        End;
    Until (IsCorrect);
    Readln;
    Readln;

End.
