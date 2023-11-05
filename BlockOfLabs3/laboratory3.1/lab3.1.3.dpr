Program Lab1;
{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    FILE_KEY: Integer = 1;
    CONSOLE_KEY: Integer = 2;
    MIN_K: Integer = 1;
    MIN_FILE_WAY_SIZE: Integer = 5;

Procedure ConditionOutput();
Begin
    Writeln('The program determines the position number K ', #13#10, 'of the occurrence of the first line in the second.', #13#10,
        'If there are no matches, returns -1.', #13#10);
End;

Procedure PathConditionOutput();
Begin
    Writeln('Where will we work through: ', #13#10#9, 'File: ', FILE_KEY, ' Console: ', CONSOLE_KEY, #13#10);
End;

Procedure FileRestriction();
Begin
    Write(#13#10, '*the first number in the file', #13#10#9, ' should be a number, followed by 2 lines*', #13#10);
End;

Function ChoosingAPath(): Integer;
Var
    Path: Integer;
    IsCorrect: Boolean;
    IsCorrectPath: Boolean;
Begin
    PathConditionOutput();
    Path := 0;
    IsCorrect := False;
    Repeat
        IsCorrectPath := False;
        Write('Please write were we should work: ');
        Try
            Readln(Path);
            IsCorrectPath := True;
        Except
            Writeln('Error. You should write a number. Try again.');
        End;
        If (((Path <> CONSOLE_KEY) And (Path <> FILE_KEY)) And IsCorrectPath) Then
            Writeln('Error method. Try again.')
        Else
            If (IsCorrectPath) Then
                IsCorrect := True;
    Until IsCorrect;
    ChoosingAPath := Path;
End;

Function WayCondition(Way: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If ExtractFileExt(Way) <> '.txt' Then
        Write('Write .txt file. Try again: ')
    Else
        IsCorrect := True;
    WayCondition := IsCorrect;
End;

Function InputWayToTheFile(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Readln(Way);
        IsCorrect := WayCondition(Way);
    Until IsCorrect;
    InputWayToTheFile := Way;
End;

///input from file
Function InputFileWay(): String;
Var
    FileWay: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    FileWay := '';
    Repeat
        FileWay := InputWayToTheFile();
        If (Not FileExists(FileWay)) Then
            Write('Can not open a file. Try write another way: ')
        Else
            IsCorrect := True;
    Until IsCorrect;
    InputFileWay := FileWay;
End;

Function AfterReadingCheck(Var MyFile: TextFile; IsCorrect: Boolean; Str1, Str2: String; K: Integer): Boolean;
Begin
    IsCorrect := True;
    If ((K < MIN_K) And IsCorrect) Then
    Begin
        IsCorrect := False;
        Write('Minimal k in file is ', MIN_K, '. Try again: ');
    End;
    If ((Str1 = '') Or (Str2 = '')) And IsCorrect Then
    Begin
        IsCorrect := False;
        Write('There can not be empty lines. Try again: ');
    End;
    If (Not SeekEof(MyFile) And IsCorrect) Then
    Begin
        IsCorrect := False;
        Write('The file should only contain 1 number and 2 lines. Try again: ');
    End;
    AfterReadingCheck := IsCorrect;
End;

///input from console
Function CheckKCondition(K: Integer): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If K < MIN_K Then
        Write('Min position number is ', MIN_K, '. Try again: ')
    Else
        IsCorrect := True;

    CheckKCondition := IsCorrect;
End;

Function InputKFromConsole(): Integer;
Var
    K: Integer;
    IsCorrect, IsCorrectReading: Boolean;
Begin
    IsCorrect := False;
    K := 0;
    Write('The position numbers of which occurrence you want to find: ');
    Repeat
        IsCorrectReading := True;
        Try
            Readln(K);
        Except
            Write('You should write a natural number. Try again: ');
            IsCorrectReading := False;
        End;
        If IsCorrectReading Then
            IsCorrect := CheckKCondition(K);
    Until IsCorrect;
    InputKFromConsole := K;
End;

Function StrInput(): String;
Var
    Str: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Readln(Str);
        If Str = '' Then
            Write('String can not be empty. Try again: ')
        Else
            IsCorrect := True;
    Until IsCorrect;
    StrInput := Str;
End;

Function FileStrInput(Var MyFile: TextFile): String;
Var
    Str: String;
    Current: Char;
Begin
    Str := '';
    Read(MyFile, Current);
    If Current = ' ' Then
        Read(MyFile, Current);
    If Current = #$D Then
    Begin
        Read(MyFile, Current);
        Read(MyFile, Current);
    End;

    While (Not Eof(MyFile) And (Current <> ' ') And (Current <> #$D)) Do
    Begin
        Str := Str + Current;
        Read(MyFile, Current)
    End;
    If Current <> #$D Then
        Str := Str + Current
    Else
        Read(MyFile, Current);

    FileStrInput := Str;
End;

///check condition
Function CalculationOfTheResult(K: Integer; Str1, Str2: String): Integer;
Var
    Res, I, J: Integer;
    IsCorrect: Boolean;
Begin
    Res := -1;
    For I := 1 To Length(Str2) - 1 Do
        If (Str2[I] = Str1[1]) Then
        Begin
            IsCorrect := True;
            For J := 2 To Length(Str1) - 1 Do
                If (Str2[I + J - 1] <> Str1[J]) Then
                    IsCorrect := False;
            If IsCorrect Then
                K := K - 1;
            If ((K = 0) And IsCorrect) Then
                Res := I;
        End;
    CalculationOfTheResult := Res;
End;

///output from file
Procedure OutputFromFile(Result: Integer);
Var
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
Begin
    IsCorrect := False;
    Write('Write way to your file: ');
    Repeat
        FileWay := InputFileWay();
        AssignFile(MyFile, FileWay);
        Try
            Try
                Append(MyFile);
                ReWrite(MyFile);
                Writeln(MyFile, Result);
                Write('Cheack your file.');
                IsCorrect := True;
            Finally
                Close(MyFile);
            End;
        Except
            Write('Bad output file. Try again: ');
        End;
    Until IsCorrect;
End;

///output from console
Procedure OutputFromConsole(Result: Integer);
Begin
    Write(Result, #13#10);
End;

///block of main void-s
Procedure ResultOutput(Result: Integer);
Var
    Path: Integer;
Begin
    Writeln('You need to choose where to write information from.');
    Path := ChoosingAPath();
    If (Path = CONSOLE_KEY) Then
        OutputFromConsole(Result)
    Else
        OutputFromFile(Result);
End;

Var
    K, Path, Result: Integer;
    Str1, Str2, FileWay: String;
    IsCorrect: Boolean;
    MyFile: TextFile;

Begin
    K := 0;
    Str1 := '';
    Str2 := '';
    ConditionOutput();
    Writeln(#13#10, 'You need to choose where to read information from.');
    Path := ChoosingAPath();
    If (Path = CONSOLE_KEY) Then
    Begin
        K := InputKFromConsole();
        Write('Write your first string: ');
        Str1 := StrInput();
        Write('Write your second string: ');
        Str2 := StrInput();
    End
    Else
    Begin
        IsCorrect := False;
        Write('Write way to your file: ');
        Repeat
            FileWay := InputFileWay();
            AssignFile(MyFile, FileWay);
            Try
                Try
                    Reset(MyFile);
                    Try
                        Read(MyFile, K);
                        Str1 := FileStrInput(MyFile);
                        Str2 := FileStrInput(MyFile);
                    Except
                        IsCorrect := False;
                        Write('Error in k reading. Try again: ');
                    End;
                    IsCorrect := AfterReadingCheck(MyFile, IsCorrect, Str1, Str2, K);
                Finally
                    Close(MyFile);
                End;
            Except
                Write('Bad input file. Try again: ');
            End;
        Until IsCorrect;
    End;
    Result := CalculationOfTheResult(K, Str1, Str2);
    ResultOutput(Result);
    Readln;

End.
