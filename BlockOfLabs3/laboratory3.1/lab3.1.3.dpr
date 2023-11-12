Program Lab1;
{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    MIN_K = 1;
    ERR_VALUE_OF_K = -1;
    VALUE_OF_DEFAULT_RESULT = -1;
    STANDARD_NUMBER_OF_STRINGS = 1;
    MIN_FILE_WAY_SIZE = 5;
    FILE_KEY = 1;
    CONSOLE_KEY = 2;

Type
    TMassive = Array [0 .. STANDARD_NUMBER_OF_STRINGS] Of String;

    //text information output block
Procedure ConditionOutput();
Begin
    Writeln('The program determines the position number K ', #13#10, 'of the occurrence of the first line in the second.', #13#10,
        'If there are no matches, returns -1.', #13#10);
End;

Procedure WorkWayConditionOutput();
Begin
    Writeln('Where will we work through: ', #13#10#9, 'File: ', FILE_KEY, ' Console: ', CONSOLE_KEY, #13#10);
End;

Procedure FileRestriction();
Begin
    Write(#13#10, '*the first number in the file is the number ', #13#10, 'of the occurrence the index of which you want to find,', #13#10,
        'and after that the substring and the string*', #13#10, 'Write way to your file: ');
End;

//choice of direction
Function ChoosingWorkWay(): Integer;
Var
    Path: Integer;
    IsCorrect: Boolean;
    IsCorrectPath: Boolean;
Begin
    WorkWayConditionOutput();
    Path := 0;
    IsCorrect := False;
    Write('Please write were we should work: ');
    Repeat
        IsCorrectPath := False;
        Try
            Readln(Path);
            IsCorrectPath := True;
        Except
            Writeln('Error. You should write a number. Try again: ');
        End;
        If (Path <> CONSOLE_KEY) And (Path <> FILE_KEY) Then
            Writeln('Error method. Try again: ')
        Else
            If (IsCorrectPath) Then
                IsCorrect := True;
    Until IsCorrect;
    ChoosingWorkWay := Path;
End;

//input and check path to the file
Function PathCondition(Way: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If ExtractFileExt(Way) <> '.txt' Then
        Write('Write .txt file. Try again: ')
    Else
        IsCorrect := True;
    PathCondition := IsCorrect;
End;

Function InputPath(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Readln(Way);
        IsCorrect := PathCondition(Way);
    Until IsCorrect;
    InputPath := Way;
End;

Function InputPathToTheFile(): String;
Var
    FileWay: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    FileWay := '';
    Repeat
        FileWay := InputPath();
        If (Not FileExists(FileWay)) Then
            Write('Can not open a file. Try write another way: ')
        Else
            IsCorrect := True;
    Until IsCorrect;
    InputPathToTheFile := FileWay;
End;

//input from file
Function InputKFromFile(FileWay: String): Integer;
Var
    K: Integer;
    MyFile: TextFile;
Begin
    Try
        AssignFile(MyFile, FileWay);
        Try
            Reset(MyFile);
            Readln(MyFile, K);
            If K < MIN_K Then
            Begin
                Write('Min position number is ', MIN_K, '. Try again: ');
                K := ERR_VALUE_OF_K;
            End;
        Finally
            Close(MyFile);
        End;
    Except
        Write('First string is natural number. Try again: ');
        K := ERR_VALUE_OF_K;
    End;

    InputKFromFile := K;
End;

Procedure InputStringFromFile(Var MyFile: TextFile; Var Str: TMassive);
Var
    Counter: Char;
    I: Integer;
Begin
    I := 0;

    While Not EOF(MyFile) Do
    Begin
        Read(MyFile, Counter);
        If Counter <> #$D Then
            Str[I] := Str[I] + Counter
        Else
        Begin
            Inc(I);
            Read(MyFile, Counter);
        End;
    End;
End;

Procedure SettingTheCursor(Var MyFile: TextFile);
Var
    BufferInt: Integer;
    BufferChar: Char;
Begin
    Read(MyFile, BufferInt);
End;

Function CheckEndOfFile(Var MyFile: TextFile): Boolean;
Var
    Res: Boolean;
Begin
    If Not SeekEOF(MyFile) Then
    Begin
        Write('In file should be only 1 number and 2 strings. Try again: ');
        Res := False;
    End
    Else
        Res := True;
    CheckEndOfFile := Res;
End;

Procedure SysOfInputStringsFromFile(Var MyFile: TextFile; Var Str: TMassive);
Begin
    SettingTheCursor(MyFile);
    InputStringFromFile(MyFile, Str);
End;

//input from console
Function CheckKCondition(K: Integer; IsCorrectInput: Boolean): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    If Not IsCorrectInput Then
        IsCorrect := False;

    If (K < MIN_K) And (IsCorrect) Then
    Begin
        Write('Min position number is ', MIN_K, '. Try again: ');
        IsCorrect := False;
    End;
    CheckKCondition := IsCorrect;
End;

Function InputKFromConsole(): Integer;
Var
    K: Integer;
    IsCorrect, IsCorrectInput: Boolean;
Begin
    K := 0;
    Repeat
        IsCorrectInput := False;
        Try
            Readln(K);
            IsCorrectInput := True;
        Except
            Write('First string is natural number. Try again: ');
        End;
        IsCorrect := CheckKCondition(K, IsCorrectInput);
    Until IsCorrect;
    InputKFromConsole := K;
End;

Function InputStringFromConsole(): String;
Var
    Str: String;
    Current: Char;
    IsCorrect: Boolean;
Begin
    Str := '';
    IsCorrect := True;
    While EOLN And IsCorrect Do
    Begin
        Read(Current);
        Str := Str + Current;
    End;
    InputStringFromConsole := Str;
End;

Function IsCorrectInput(Str1, Str2: String; IsItEndOfFile: Boolean): Boolean;
Begin
    If (Str1 = '') And (Str2 = '') Then
    Begin
        Write('Bad strings input. Try again: ');
        IsCorrectInput := False;
    End
    Else
        IsCorrectInput := IsItEndOfFile;
End;

Procedure SysOfInputStringsFromConsole(Var Str: TMassive);
Begin
    Write('Write your first string: ');
    Str[0] := InputStringFromConsole();
    Write('Write your second string: ');
    Str[1] := InputStringFromConsole();
End;

//search for result
Function IsStringsEqual(Str1, Str2: String; I: Integer): Boolean;
Var
    J: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    For J := 2 To Length(Str1) - 1 Do
        If ((Str2[I + J - 1] <> Str1[J]) And IsCorrect) Then
            IsCorrect := False;
    IsStringsEqual := IsCorrect;
End;

Function CalculationOfTheResult(K: Integer; Str1, Str2: String): Integer;
Var
    Res, I: Integer;
    IsCorrect: Boolean;
Begin
    Res := -1;
    For I := 1 To Length(Str2) - 1 Do
        If (Str2[I] = Str1[1]) Then
        Begin
            IsCorrect := IsStringsEqual(Str1, Str2, I);
            If IsCorrect Then
                K := K - 1;
            If ((K = 0) And IsCorrect) Then
                Res := I;
        End;
    CalculationOfTheResult := Res;
End;

//output systeme
Procedure OutputFromFile(Result: Integer);
Var
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
Begin
    IsCorrect := False;
    Write('Write way to your file: ');
    Repeat
        FileWay := InputPathToTheFile();
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

Procedure OutputFromConsole(Result: Integer);
Begin
    Write(Result, #13#10);
End;

Procedure ResultOutput(Result: Integer);
Var
    Path: Integer;
Begin
    Writeln('You need to choose where to write information from.');
    Path := ChoosingWorkWay();
    If (Path = CONSOLE_KEY) Then
        OutputFromConsole(Result)
    Else
        OutputFromFile(Result);
End;

//block of distributive functions
Function InputFileWay(Path: Integer): String;
Begin
    If Path = CONSOLE_KEY Then
        InputFileWay := ''
    Else
        InputFileWay := InputPathToTheFile();
End;

Function KInput(Path: Integer; FileWay: String): Integer;
Begin
    If Path = CONSOLE_KEY Then
        KInput := InputKFromConsole()
    Else
        KInput := InputKFromFile(FileWay);
End;

Function IsCorrectStringsInput(Path: Integer; FileWay: String; Var Str: TMassive; K: Integer): Boolean;
Var
    IsCorrect: Boolean;
    IsItEndOfFile: Boolean;
    MyFile: TextFile;
Begin
    IsCorrect := False;
    If K = ERR_VALUE_OF_K Then
        IsCorrect := True;

    If (Path = CONSOLE_KEY) And IsCorrect Then
    Begin
        SysOfInputStringsFromConsole(Str);
        IsCorrect := False;
    End
    Else
        If IsCorrect Then
        Begin
            IsItEndOfFile := True;
            Try
                AssignFile(MyFile, FileWay);
                Try
                    Reset(MyFile);
                    SysOfInputStringsFromFile(MyFile, Str);
                    IsItEndOfFile := CheckEndOfFile(MyFile);
                Finally
                    Close(MyFile);
                End;
            Except
                Write('Bad strings input from file. Try again: ');
            End;
            IsCorrect := IsCorrectInput(Str[0], Str[1], IsItEndOfFile);
        End;
    IsCorrectStringsInput := IsCorrect;
End;

Function InputSystem(Var Str: TMassive): Integer;
Var
    Path, K: Integer;
    IsCorrect: Boolean;
    FileWay: String;
Begin
    Writeln(#13#10, 'You need to choose where to read information from.');
    Path := ChoosingWorkWay();

    If Path = FILE_KEY Then
        FileRestriction();

    Repeat
        FileWay := InputFileWay(Path);

        K := KInput(Path, FileWay);
        IsCorrect := Not IsCorrectStringsInput(Path, FileWay, Str, K);
    Until IsCorrect;

    InputSystem := K;
End;

Var
    Str: TMassive;
    K, Path, Result: Integer;
    FileWay: String;
    IsCorrect: Boolean;
    MyFile: TextFile;

Begin
    ConditionOutput();
    K := InputSystem(Str);
    Result := CalculationOfTheResult(K, Str[0], Str[1]);
    ResultOutput(Result);
    Readln;

End.
