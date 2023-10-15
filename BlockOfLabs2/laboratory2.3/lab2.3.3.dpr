Program labt3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    CONS_NUM: Integer = 1;
    FILE_NUM: Integer = 2;
    PALIN_OUTPUT_CONTROL: Integer = -1;

Procedure PathCondition(Var Num: Integer; Var IsCorrect: Boolean);
Begin
    Try
        Readln(Num);
    Except
        Writeln('Invalid numeric input. Try again.');
    End;
    If (Num <> CONS_NUM) And (Num <> FILE_NUM) Then
        Writeln('Choose only ', CONS_NUM, ' or ', FILE_NUM, '. Try again.')
    Else
        IsCorrect := True;
End;

Function ChoosingAPath(): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Write('Your choice: ');
        PathCondition(Num, IsCorrect);
    Until IsCorrect;

    ChoosingAPath := Num;
End;

Procedure PalinCondition(Var IsCorrect: Boolean; Var Palindrome: Integer);
Begin
    Try
        Readln(Palindrome);
        IsCorrect := True;
    Except
        Writeln('Invalid numeric input.Try again.');
    End;
End;

Function InputPalin(): Integer;
Var
    Palindrome: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Write('Write your number: ');
        PalinCondition(IsCorrect, Palindrome);
    Until IsCorrect;

    InputPalin := Palindrome;
End;

Function LengthOfPalin(Palindrome: Integer): Integer;
Var
    PalinLen: Integer;
Begin
    PalinLen := 0;
    While (Palindrome > 0) Do
    Begin
        Inc(PalinLen);
        Palindrome := Palindrome Div 10;
    End;

    LengthOfPalin := PalinLen;
End;

Procedure PutInMassive(Var ArrPalin: Array Of Integer; Palindrome: Integer);
Var
    I: Integer;
Begin
    I := 0;
    While Palindrome > 0 Do
    Begin
        ArrPalin[I] := Palindrome Mod 10;
        Inc(I);
        Palindrome := Palindrome Div 10;
    End;
End;

Function PalinIsPalin(Var ArrPalin: Array Of Integer; PalinLen: Integer; Palindrome: Integer): Boolean;
Var
    IsCorrect: Boolean;
    I: Integer;
Begin
    IsCorrect := True;
    For I := 0 To PalinLen Div 2 Do
        If (ArrPalin[I] <> ArrPalin[PalinLen - I - 1]) Then
            IsCorrect := False;
    If Palindrome < 0 Then
        IsCorrect := False;

    PalinIsPalin := IsCorrect;
End;

Function PalinCheack(Palindrome: Integer): Boolean;
Var
    PalinLen: Integer;
    ArrPalin: Array Of Integer;
Begin
    PalinLen := LengthOfPalin(Abs(Palindrome));
    SetLength(ArrPalin, PalinLen);
    PutInMassive(ArrPalin, Abs(Palindrome));

    PalinCheack := PalinIsPalin(ArrPalin, PalinLen, Palindrome);
End;

Procedure ViaConsole();
Var
    Palindrome: Integer;
Begin
    Palindrome := InputPalin();
    If (PalinCheack(Palindrome) And (Palindrome > PALIN_OUTPUT_CONTROL)) Then
        Write('It is palindrome.')
    Else
        Write('It is not a palindrome.');
End;

Procedure ConditionCheack(Sim: Char; IsCorrect: Boolean; Var Palindrome, N, K: Integer);
Begin
    If (Sim = '-') And (IsCorrect = False) And (Sim <> #0) Then
        K := PALIN_OUTPUT_CONTROL
    Else
        If ((Sim < '0') Or (Sim > '9')) And (Sim <> #0) Then
            Palindrome := PALIN_OUTPUT_CONTROL
        Else
        Begin
            Palindrome := Palindrome + Ord(Sim) * N;
            N := N * 10;
        End;
End;

Procedure CheackForOneString(IsCorrect: Boolean; Var Palindrome: Integer);
Begin
    If (IsCorrect = False) Then
        Palindrome := PALIN_OUTPUT_CONTROL;
End;

Function InputPalinFile(Var MyFile: TextFile): Integer;
Var
    Palindrome, N, K: Integer;
    Sim: Char;
    IsCorrect: Boolean;
Begin
    Palindrome := 0;
    N := 1;
    K := 1;
    Sim := '0';
    While (Sim <> #0) Do
    Begin
        Read(MyFile, Sim);
        ConditionCheack(Sim, IsCorrect, Palindrome, N, K); 
        IsCorrect := True;
    End;
    Palindrome := Palindrome * K;
    CheackForOneString(IsCorrect, Palindrome);

    InputPalinFile := Palindrome;
End;

Procedure OutputPalin(Palindrome: Integer; Var MyFile: TextFile);
Begin
    Append(MyFile);
    If Palindrome = PALIN_OUTPUT_CONTROL Then
        Write(MyFile, #13#10, 'ERROR.')
    Else
        If (PalinCheack(Palindrome)) Then
            Write(MyFile, #13#10, 'It is palindrome.')
        Else
            If (Palindrome <> PALIN_OUTPUT_CONTROL) Then
                Write(MyFile, #13#10, 'It is not a palindrome.');
    CloseFile(MyFile);
End;

Procedure WorkWithFile(Var MyFile: TextFile);
Var
    Palindrome: Integer;
Begin
    Palindrome := InputPalinFile(MyFile);
    OutputPalin(Palindrome, MyFile);
    Write('Cheack your file.');
End;

Procedure WayCondition(Way: String; Var IsCorrect: Boolean);
Var
    Bufstr: String;
Begin
    If Way.Length > 4 Then
    Begin
        Bufstr := Way.Substring(Way.Length - 4);
        If Bufstr = '.txt' Then
            IsCorrect := True
        Else
            Writeln('Write .txt file.');
    End
    Else
        Writeln('The path is too short.');
End;

Function InputWay(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Read(Way);
        WayCondition(Way, IsCorrect);
    Until IsCorrect;

    InputWay := Way;
End;

Procedure ViaFile();
Var
    FileWay: String;
    MyFIle: TextFile;
Begin
    Write('Write way to your file: ');
    FileWay := InputWay();
    Try
        AssignFile(MyFile, FileWay);
        //Reset(MyFile);
        WorkWithFile(MyFile);
        //CloseFile(MyFile);
    Except
        Write('Bad File.');
    End;

End;

Var
    Option: Integer;
    Resoult: String;

Begin
    Writeln('The program determines whether', #13#10#9, 'the entered number is a palindrome.', #13#10);
    Writeln('Where will we work through: ', #13#10#9, 'Console: ', CONS_NUM, #9, 'File: ', FILE_NUM, #13#10);
    Option := ChoosingAPath();

    If Option = FILE_NUM Then
        ViaFile()
    Else
        ViaConsole();
    Readln;
    Readln;

End.
