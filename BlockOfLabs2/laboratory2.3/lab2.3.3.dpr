﻿Program labt3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    CONS_NUM = 1;

Const
    FILE_NUM = 2;

Function ChoosingAPath(): Integer;
Var
    Num: Integer;
    IsCorrect: Boolean;
Begin
    Write('Your choice: ');
    Num := 0;
    IsCorrect := False;
    Repeat
        Try
            Readln(Num);
        Except
            Writeln('Invalid numeric input. Try again.', #13#10);
        End;
        If (Num <> CONS_NUM) And (Num <> FILE_NUM) Then
            Writeln('Choose only ', CONS_NUM, ' or ', FILE_NUM)
        Else
            IsCorrect := True;
    Until IsCorrect;
    ChoosingAPath := Num;
End;

Function InputWay(): String;
Var
    Way, Bufstr: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Readln(Way);
        If (Way.Length > 4) Then
        Begin
            Bufstr := Way.Substring(Way.Length - 4);
            If Bufstr = '.txt' Then
                InputWay := Way
            Else
                Writeln('Write .txt file');
        End
        Else
            Writeln('Tge path is too short');
    Until IsCorrect;
End;

Function IsPalindrome(Palindrome: String): Boolean;
Var
    I, HighI: Integer;
Begin
    HighI := Palindrome.Length Div 2;
    For I := 0 To HighI Do
    Begin
        If Palindrome[I] <> Palindrome[Palindrome.Length - (I + 1)] Then
            IsPalindrome := False;
    End;
    IsPalindrome := True;
End;

Function ViaConsole(): String;
Var
    Palindrome: String;
Begin
    Write('Write your string: ');
    Readln(Palindrome);
    If (IsPalindrome(Palindrome)) Then
        ViaConsole := 'palindrome'
    Else
        ViaConsole := 'not a palindrome';
End;

Function WorkWithPalin(Palindrome: String): String;
Begin
    If IsPalindrome(Palindrome) Then
        WorkWithPalin := 'palindrome(' + Palindrome + ').'
    Else
        WorkWithPalin := 'not a palindrome(' + Palindrome + ').';
End;

Function ViaFile(): String;
Var
    FileWay, Palindrome: String;
    MyFile: TextFile;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Write('Write way to your file: ');
        Readln(FileWay);
        AssignFile(MyFile, FileWay);
        Reset(MyFile);
        Try
            Readln(MyFile, Palindrome);
        Except
            Writeln('Bad File. Try again.');
        End;
        ViaFile := WorkWithPalin(Palindrome);
        CloseFile(MyFile);
    Until IsCorrect;
End;

Var
    Option: Integer;
    Resoult: String;

Begin
    Writeln('The program determines whether', #13#10#9, 'the entered string is a palindrome.', #13#10);
    Writeln('Where will we work through: ', #13#10#9, 'Console: ', CONS_NUM, #9, 'File: ', FILE_NUM, #13#10);
    Option := ChoosingAPath();


    If Option = FILE_NUM Then
        Resoult := ViaFile()
    Else
        Resoult := ViaConsole();
    Writeln('It is ', Resoult);

    Writeln('Press any buttom to close the console.');
    Readln;
    readln;
End.
