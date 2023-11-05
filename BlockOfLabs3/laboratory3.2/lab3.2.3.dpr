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
    IsCorrect := True;
    Repeat
        IsCorrectPath := False;
        Write('Please write were we should work: ');
        Try
            Readln(Path);
            IsCorrectPath := True;
        Except
            Writeln('Error. You should write a number. Try again.');
        End;
        If (((Path <> CONSOLE_KEY) Or (Path <> FILE_KEY)) And IsCorrectPath) Then
            IsCorrect := True
        Else
            If (IsCorrectPath) Then
                Writeln('Error method. Try again.');
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
        IsCorrect := Not WayCondition(Way);
    Until IsCorrect;
    InputWayToTheFile := Way;
End;

///input from file
Function IsCanOpenFile(Way: String): Boolean;
Var
    MyFile: TextFile;
Begin
    IsCanOpenFile := FileExists(Way);
End;

Function InputFile(): String;
Var
    FileWay: String;
    IsCorrect, IsCorrectFileInput: Boolean;
Begin
    IsCorrect := False;
    Repeat
        IsCorrectFileInput := True;
        FileWay := InputWayToTheFile();
        If (IsCanOpenFile(FileWay)) Then
            Write('Can not open a file. Try write another way: ')
        Else
            IsCorrect := True;
    Until IsCorrect;
    InputFile := FileWay;
End;

Function AfterReadingCheck(Var MyFile: TextFile; IsCorrect: Boolean; Str1, Str2: String): Boolean;
Begin
    If ((Str1 = '') Or (Str2 = '')) And IsCorrect Then
    Begin
        IsCorrect := False;
        Write('There cannot be empty lines. Try again: ');
    End;
    If (SeekEof(MyFile) And IsCorrect) Then
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
End;

Function InputKFromConsole(): Integer;
Var
    K: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Write('The position numbers of which occurrence you want to find: ');
    Repeat
        Try
            Readln(K);
        Except
            Write('You should write a number. Try again: ');
        End;
        IsCorrect := Not CheckKCondition(K);
    Until IsCorrect;
    InputKFromConsole := K;
End;

///check condition
Function CalculationOfTheResult(K: Integer; Str1, Str2: String): Integer;
Var
    Res, I, J: Integer;
    IsCorrect: Boolean;
Begin
    Res := -1;
    For I := 1 To Length(Str2) Do
        If (Str2[I] = Str1[1]) Then
        Begin
            Write(Str2[I]);
            IsCorrect := True;
            For J := 2 To Length(Str1) Do
                If (Str2[I + J] <> Str1[J]) Then
                    IsCorrect := False;
            K := K - 1;
            If ((K = 0) And IsCorrect) Then
                Res := I + 1;
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
        FileWay := InputWayToTheFile();
        AssignFile(MyFile, FileWay);
        If (IsCanOpenFile(FileWay)) Then
        Begin
            Try
                Try
                    ReWrite(MyFile);
                    Write(MyFile, Result);
                    Write('Cheack your file.');
                Finally
                    CloseFile(MyFile);
                End;
            Except
                Write(#13#10, 'Bad output file.');
            End;
        End
        Else
            Write('Ca not open a file. Try write another way: ');
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
    ConditionOutput();
    Writeln(#13#10, 'You need to choose where to read information from.');
    Path := ChoosingAPath();
    If (Path = CONSOLE_KEY) Then
    Begin
        K := InputKFromConsole();
        Write('Write your first string: ');
        Readln(Str1);
        Write('Write your second string: ');
        Readln(Str2);
    End
    Else
    Begin
        IsCorrect := False;
        FileWay := InputFile();
        AssignFile(MyFile, FileWay);
        Try
            Try
                Reset(MyFile);
                Try
                    Readln(K);
                Except
                    IsCorrect := False;
                    Write('Error in k reading. Try again: ');
                End;
                Readln(Str1, Str2);
                IsCorrect := Not AfterReadingCheck(MyFile, IsCorrect, Str1, Str2);
            Finally
                Close(MyFile);
            End;
        Except
            Write('Bad output file. Try again: ');
        End;
    End;
    Result := CalculationOfTheResult(K, Str1, Str2);
    ResultOutput(Result);
    Readln;

End.
