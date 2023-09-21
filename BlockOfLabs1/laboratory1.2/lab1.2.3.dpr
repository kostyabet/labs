Program Lab2;

Uses
    System.SysUtils;

Const
    ONEKILOCOST = 280; // weight one kilogram
    TABLESTEP = 50; // table step
    ENDOFTABLE = 1000; // top table border
    GRAMINKILO = 1000; // number of grams in a kilogram

Var
    I: Integer;
    Cost: Integer;

Begin
    Cost := 0;
    For I := TABLESTEP To ENDOFTABLE Do
    Begin
        // current price calculation
        Cost := I * ONEKILOCOST Div GRAMINKILO;
        If (I Mod 50 = 0) Then
        Begin
            // conclusion
            If I < 99 Then
            Begin
                Writeln(I, '   gram of cheese - cost: ', Cost, '  rubles.');
            End
            Else
            If (I < 999) And (Cost < 100) Then
            Begin
                Writeln(I, '  gram of cheese - cost: ', Cost, '  rubles.');
            End
            Else
            If I < 999 Then
            Begin
                Writeln(I, '  gram of cheese - cost: ', Cost, ' rubles.');
            End
            Else
            Begin
                Writeln(I, ' gram of cheese - cost: ', Cost, ' rubles.');
            End;
        End;
    End;
    Readln;

End.
