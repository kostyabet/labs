﻿Program labt3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    CONS_NUM: Integer = 1;
    FILE_NUM: Integer = 2;
    PALIN_OUTPUT_CONTROL: Integer = -1;

Procedure PrintStatement();
Begin
    Writeln('The program determines whether', #13#10#9, 'the entered natural number is a palindrome.', #13#10);
End;

Function PathCondition(Var IsCorrect: Boolean): Integer;
Var
    Num: Integer;
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

    PathCondition := Num;
End;

Function ChoosingAPath(): Integer;
Var
    Res: Integer;
    IsCorrect: Boolean;
Begin
    Writeln('Where will we work through: ', #13#10#9, 'Console: ', CONS_NUM, #9, 'File: ', FILE_NUM, #13#10);
    IsCorrect := False;
    Repeat
        Write('Your choice: ');
        Res := PathCondition(IsCorrect);
    Until IsCorrect;

    ChoosingAPath := Res;
End;

Procedure PalinCondition(Var IsCorrect: Boolean; Var Palindrome: Integer);
Begin
    Try
        Readln(Palindrome);
    Except
        Writeln('Invalid numeric input. Try again.');
    End;
    If Palindrome < 1 Then
        Writeln('Number should be natural.')
    Else
        IsCorrect := True;
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
    Res: Boolean;
    ArrPalin: Array Of Integer;
Begin
    PalinLen := LengthOfPalin(Abs(Palindrome));
    SetLength(ArrPalin, PalinLen);
    PutInMassive(ArrPalin, Abs(Palindrome));

    Res := PalinIsPalin(ArrPalin, PalinLen, Palindrome);

    ArrPalin := Nil;

    PalinCheack := Res;
End;

Function ViaConsole(): Integer;
Var
    Palindrome, Res: Integer;
Begin
    Palindrome := InputPalin();
    If PalinCheack(Palindrome) And (Palindrome > PALIN_OUTPUT_CONTROL) Then
        Res := 1
    Else
        Res := 0;

    ViaConsole := Res;
End;

Function InputPalinFile(Var MyFile: TextFile): Integer;
Var
    Palindrome: Integer;
Begin
    Reset(MyFile);
    Try
        Readln(MyFile, Palindrome);
    Except
        Write('Bad number in file.');
        Palindrome := -1;
    End;

    If Palindrome < 0 Then
    Begin
        Write('Number should be > 0.');
        Palindrome := -1;
    End
    Else
        If Not SeekEof(MyFile) Then
        Begin
            Write('Should be only one num.');
            Palindrome := -1;
        End;
    InputPalinFile := Palindrome;
End;

Function OutputPalin(Palindrome: Integer): Integer;
Var
    Res: Integer;
Begin
    If Palindrome = PALIN_OUTPUT_CONTROL Then
        Res := -1
    Else
        If (PalinCheack(Palindrome)) Then
            Res := 1
        Else
            If (Palindrome <> PALIN_OUTPUT_CONTROL) Then
                Res := 0;

    OutputPalin := Res;
End;

Function WorkWithFile(Var MyFile: TextFile): Integer;
Var
    Palindrome, Res: Integer;
Begin
    Palindrome := InputPalinFile(MyFile);
    Res := OutputPalin(Palindrome);

    WorkWithFile := Res;
End;

Procedure WayCondition(Way: String; Var IsCorrect: Boolean);
Var
    Bufstr: String;
Begin
    If ExtractFileExt(Way) <> '.txt' Then
        Writeln('Write .txt file.')
    Else
        IsCorrect := True;
End;

Function InputWay(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    Write('Write way to your file: ');
    Repeat
        IsCorrect := False;
        Read(Way);
        WayCondition(Way, IsCorrect);
        Readln;
    Until IsCorrect;

    InputWay := Way;
End;

Function ViaFile(): Integer;
Var
    FileWay: String;
    MyFIle: TextFile;
    Res: Integer;
Begin
    FileWay := InputWay();
    AssignFile(MyFile, FileWay);
    Try
        Reset(MyFile);
        Res := WorkWithFile(MyFile);
    Except
        Begin
            Write('Bad File.', #13#10);
            Res := -1;
        End;
    End;

    ViaFile := Res;
End;

Procedure OutputViaConsole(Result: Integer);
Begin
    If Result = 1 Then
        Writeln('Palindrome.')
    Else
        Writeln('Not a palindrome.');
End;

Function FileCorrectOutput(Res: Integer): String;
Var
    Resstr: String;
Begin
    If Res = 1 Then
        Resstr := 'Palindrome.'
    Else
        Resstr := 'Not a palindrome';
    FileCorrectOutput := Resstr;
End;

Procedure OutputViaFile(Result: Integer);
Var
    FileWay: String;
    MyFile: TextFile;
Begin
    FileWay := InputWay();
    AssignFile(MyFile, FileWay);
    Try
        Try
            Reset(MyFile);
            Append(MyFile);
            Write(MyFile, FileCorrectOutput(Result));
            Write('Cheack your file.');
        Finally
            CloseFile(MyFile);
        End;
    Except
        Write(#13#10, 'Bad output file.');
    End;
End;

Procedure Output(Option, Result: Integer);
Begin
    If Result <> -1 Then
    Begin
        Writeln(#13#10#10, 'You need to choose where to output the result.');
        Option := ChoosingAPath();

        If (Option = File_NUM) Then
            OutputViaFile(Result)
        Else
            OutputViaConsole(Result);
    End;
End;

Var
    Option, Result: Integer;
    Resoult: String;

Begin
    PrintStatement();

    Option := ChoosingAPath();

    If Option = FILE_NUM Then
        Result := ViaFile()
    Else
        Result := ViaConsole();

    Output(Option, Result);

    Readln;
    Readln;

End.
