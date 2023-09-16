Program Lab_3;

Uses
    System.SysUtils;

Const
    MinEPS = 0; // minimum EPS
    MaxEPS = 0.1; // maximum EPS

Var
    X: Double = 0;
    EPS: Double = MaxEPS;  
    Y: Double = 0; // current element 
    Y0: Double = 1; // previous element
    Number: Integer = 0; // operation counter
    Coefficient: Integer = 1; // stores the sign of the entered X
    IsCorrect: Boolean = True;

Begin
    // condition
    Writeln('  The program calculates the value of the cube root ', #13#10,
            'from the number X entered by a person.', #13#10,
            'With accuracy up to the number EPS entered by the user.', #13#10, #13#10,
            'Restrictions X: No restrictions.', #13#10,
            'Restrictions EPS: (0; 0.1).', #13#10, #13#10);

    Repeat
        Try
            Begin
                IsCorrect := False;
                
                // input X
                Writeln('Write the cube root of which number you want to find?');
                Read(X);

                // EPS input
                Writeln('With what EPS must the calculations be made?');
                Read(EPS);

                // EPS check
                // for EPS more than 0.1
                If (EPS > MaxEPS) Then
                Begin
                    // passing the error
                    Raise Exception.Create('EPS is too high. EPS must be less than 0.1.');
                End
                Else
                // for EPS less than 0
                If (EPS < MinEPS) Then
                Begin
                    // passing the error
                    Raise Exception.Create('EPS cannot be less than 0');
                End
                Else
                // for EPS = 0
                If (EPS = MinEPS) Then
                Begin
                    // passing the error
                    Raise Exception.Create('EPS cannot be 0');
                End;


                // display current information about EPS and X
                Writeln(#13#10, 'Your X: ', FormatFloat('0.###',X),
                        #13#10, 'Your EPS: ', FormatFloat('0.###',EPS), 
                        #13#10);

                // checking the sign
                If (X < 0) Then
                Begin
                    // change of sign 
                    Coefficient := -1;
                    X := -X;
                End;

                // conclusion
                If (X = 0) Then
                Begin
                    // at X = 0
                    Y := X;
                    Number := 1;
                End
                Else
                // for numbers from -1 to 1, except zero
                If (X < 1) Then
                Begin
                    // first operation 
                    Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number := Number + 1;
                    // checking for the possibility of the next operation
                    If (Y0 - Y > EPS) Then
                    Begin
                        Y0 := Y;
                        Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number := Number + 1;
                        // since the difference between A and A0 is small, 
                        // then you can do a complete search of all the remaining numbers
                        While (Y0 - Y > EPS) Do
                        Begin
                            Y0 := Y;
                            Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number := Number + 1;
                        End;
                    End;
                    End
                // for all numbers except the range from -1 to 1
                Else
                Begin
                    // first operation 
                    Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                    Number := Number + 1;
                    // checking for the possibility of the next operation
                    If (Y - Y0 > EPS) Then
                    Begin
                        Y0 := Y;
                        Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                        Number := Number + 1;
                        // since the difference between A and A0 is small,
                        // then you can do a complete search of all the remaining numbers
                        While (Y0 - Y > EPS) Do
                        Begin
                            Y0 := Y;
                            Y := ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
                            Number := Number + 1;
                        End;
                    End;
                End;

                // output of final information
                // cube root output
                Writeln('Cube root of ', FormatFloat('0.###',X), ' = ', FormatFloat('0.###', Coefficient * Y));
                // number of operations to achieve accuracy
                Writeln('Number of operations for which EPS was achieved - ', Number);
            End;
        Except
            // catching a mistake
            On Error: Exception Do
            Begin
                Writeln(Error.Message);
            End;
        End;
    Until (IsCorrect);
    Readln;
    Readln;

End.