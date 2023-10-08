Program labt2;

Uses
    System.SysUtils;

Const
    MAXN = 100000;
    MAXK = 10000;
    MINK = 3;

Var
    K, Sum: Integer;

Function Input(Max: Integer; Min: Integer): Integer;
Var
    K: Integer;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Try
            Readln(K);
        Except
            Writeln('Invalid numeric input.');
            IsCorrect := False;
        End;
        If (K < Min) Or (K > Max) Then
        Begin
            Writeln('Number should be from ', Min, ' to ', Max, '.');
            IsCorrect := False;
        End;

    Until IsCorrect;

    Input := K;
End;

Function SumOfDigits(Num: Integer): Integer;
Var
    Sum: Integer;
Begin
    Sum := 0;
    While (Num >= 1) Do
    Begin
        Sum := Sum + (Num Mod 10);
        Num := Num Div 10;
    End;
    SumOfDigits := Sum;
End;

Function CheackSum(Sum: Integer; K: Integer; NutNumb: Integer): Boolean;
Begin
    If K * Sum = NutNumb Then
        CheackSum := True
    Else
        CheackSum := False;
End;

Procedure SearchNum(Max: Integer; K: Integer);
Var
    Sum, NutNumb: Integer;
Begin
    NutNumb := 1;
    While (NutNumb <= Max) Do
    Begin
        Sum := SumOfDigits(NutNumb);
        If (CheackSum(Sum, K, NutNumb)) Then
            Write(NutNumb, ' ');
        NutNumb := NutNumb + 1;
    End;
End;

Begin
    Writeln('The program finds all natural numbers that are k times the sum of their digits.');

    Writeln('Write K number from ', MINK, ' to ', MAXK, ':');
    K := Input(MAXK, MINK);

    SearchNum(MAXN, K);
    Readln;

End.
