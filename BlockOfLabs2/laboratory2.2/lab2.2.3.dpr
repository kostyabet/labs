Program labt2;

Uses
    System.SysUtils;

Const
    MAX_N = 1000000;
    MAX_K = 100000;
    MIN_K = 1;

Var
    K, Sum: Integer;

Function Input(): Integer;
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
        If (K < MIN_K) Or (K > MAX_K) Then
        Begin
            Writeln('Number should be from ', MIN_K, ' to ', MAX_K, '.');
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

Function CheckSum(Sum: Integer; K: Integer; NutNumb: Integer): Boolean;
Begin
    If K * Sum = NutNumb Then
        CheckSum := True
    Else
        CheckSum := False;
End;

Procedure SearchNum(K: Integer);
Var
    Sum, NutNumb: Integer;
Begin
    NutNumb := k;
    While (NutNumb <= MAX_N) Do
    Begin
        Sum := SumOfDigits(NutNumb);
        If (CheckSum(Sum, K, NutNumb)) Then
            Write(NutNumb, ' ');
        NutNumb := NutNumb + k;
    End;
End;

Begin
    Writeln('The program finds all natural numbers that are k times the sum of their digits.');

    Writeln('Write K number from ', MIN_K, ' to ', MAX_K, ':');
    K := Input();

    SearchNum(K);
    Readln;

End.
