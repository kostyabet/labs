Program Lab3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    MIN_FILE_WAY_SIZE = 5;
    MIN_SIZE = 1;
    GOOD_SIZE = 1;
    BAD_SIZE = 2;
    FILE_KEY = 1;
    CONSOLE_KEY = 2;

Type
    TIOError = (INVALID_PATH, METHOD_ERROR, SHORT_PATH_ERROR, TXT_ERROR, OPEN_FILE_ERROR, MIN_SIZE_ERROR, FIRST_STR_ERROR, EL_ERROR,
        TRY_AGAIN);
    TArrSize = Array Of Integer;
    TArrOfElements = Array Of Char;
    TAnsiChar = Set Of AnsiChar;

Const
    Entitlements: TAnsiChar = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '*', '/'];

Const
    ERRORS: Array [TIOError] Of String = ('Error. You should write a natural number.', 'Error method.', 'The path is too short.',
        'Write .txt file.', 'Can not open a file.', 'Min number of elements is 1.', 'First string is natural number.',
        'Enter a specific number of characters.', ' Try again: ');

Procedure PrintError(IOErrorMethod: String);
Begin
    Write(IOErrorMethod + ERRORS[TRY_AGAIN]);
End;

//block of text output
Procedure TaskOutput();
Begin
    Writeln('the program builds and prints a set, the elements', #13#10, 'of which are the signs of arithmetic operations and', #13#10,
        'numbers occurring in the sequence.', #13#10);
End;

Procedure WorkWayConditionOutput();
Begin
    Writeln('Where will we work through: ', #13#10#9, 'File: ', FILE_KEY, #10#13#9, 'Console: ', CONSOLE_KEY, #13#10);
End;

Procedure FileRestriction();
Begin
    Write(#13#10, '1.  The first line in the file is a natural number -', #13#10, 'N characters of the second line;', #13#10,
        '2.  The second line is N characters entered by the user.', #13#10, 'Write way to your file: ');
End;

//choice of direction
Function ChoosingWorkWay(): Integer;
Var
    Path: Integer;
    IsCorrect, IsCorrectInput: Boolean;
Begin
    WorkWayConditionOutput();

    Path := 0;
    IsCorrect := False;
    Write('Please write were we should work: ');
    Repeat
        IsCorrectInput := False;
        Try
            Readln(Path);
            IsCorrectInput := True;
        Except
            PrintError(ERRORS[INVALID_PATH]);
        End;
        If ((Path = CONSOLE_KEY) Or (Path = FILE_KEY)) And IsCorrectInput Then
        Begin
            IsCorrect := True;
        End
        Else
            If IsCorrectInput Then
            Begin
                PrintError(ERRORS[METHOD_ERROR]);
            End;
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
    Begin
        Write('Write .txt file. Try again: ');
    End
    Else
    Begin
        IsCorrect := True;
    End;
    PathCondition := IsCorrect;
End;

Function InputPath(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
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

///input from console
Function CheckSizeCondition(Size: Integer; IsCorrectInput: Boolean): Boolean;
Begin
    If (Size < MIN_SIZE) And (IsCorrectInput) Then
    Begin
        PrintError(ERRORS[MIN_SIZE_ERROR]);
        IsCorrectInput := False;
    End;

    CheckSizeCondition := IsCorrectInput;
End;

Function InputSizeFromConsole(): Integer;
Var
    Size: Integer;
    IsCorrect, IsCorrectInput: Boolean;
Begin
    Size := 0;
    Write('How many characters do you want to enter: ');
    Repeat
        IsCorrectInput := False;
        Try
            Readln(Size);
            IsCorrectInput := True;
        Except
            PrintError(ERRORS[INVALID_PATH])
        End;
        IsCorrect := CheckSizeCondition(Size, IsCorrectInput);
    Until IsCorrect;

    InputSizeFromConsole := Size;
End;

Function IsCorrectElementsInputFromConsole(Size: Integer; Str: String): Boolean;
Var
    Res: Boolean;
Begin
    Res := False;
    If Size = Str.Length Then
    Begin
        Res := True;
    End;

    IsCorrectElementsInputFromConsole := Res;
End;

Function InputStringFromConsole(ArrSize: TArrSize): TArrOfElements;
Var
    Size, I: Integer;
    IsCorrect: Boolean;
    ArrOfElements: TArrOfElements;
    Str: String;
Begin
    Size := InputSizeFromConsole;
    ArrSize[0] := Size;
    SetLength(ArrOfElements, Size);

    Write('Write your ', Size, ' elements: ');
    Repeat
        Readln(Str);
        If Str.Length = Size Then
            For I := 1 To Size Do
                ArrOfElements[I - 1] := Str[I]
        Else
            PrintError(ERRORS[EL_ERROR]);
        IsCorrect := IsCorrectElementsInputFromConsole(Size, Str);
    Until IsCorrect;

    InputStringFromConsole := ArrOfElements;
End;

//input from file
Function CheckSizeInputFromFile(Var MyFile: TextFile; Size: Integer): Integer;
Var
    Res: Integer;
Begin
    Res := GOOD_SIZE;
    If Size < MIN_SIZE Then
    Begin
        PrintError(ERRORS[MIN_SIZE_ERROR]);
        Res := BAD_SIZE;
    End;

    CheckSizeInputFromFile := Res;
End;

Function InputSizeFromFile(Var MyFile: TextFile; Var ArrSize: TArrSize): Integer;
Var
    Size: Integer;
Begin
    Readln(MyFile, Size);
    ArrSize[1] := CheckSizeInputFromFile(MyFile, Size);

    InputSizeFromFile := Size;
End;

Function IsCorrectElInputFromFile(Str: String; Size: Integer): Boolean;
Var
    Res: Boolean;
Begin
    Res := True;
    If (Str.Length <> Size) Then
    Begin
        PrintError(ERRORS[EL_ERROR]);
        Res := False;
    End;

    IsCorrectElInputFromFile := Res;
End;

Function InputSetFromFile(Var ArrOfElements: TArrOfElements; Size: Integer; Var MyFile: TextFile): Boolean;
Var
    Counter: Char;
    Str: String;
    I: Integer;
Begin
    Str := '';
    Repeat
        Read(MyFile, Counter);
        If (Counter <> #$D) And (Counter <> #$1A) Then
        Begin
            Str := Str + Counter;
        End
        Else
        Begin
            Read(MyFile, Counter);
        End;
    Until (Counter = #$A) Or (Counter = #$1A);

    If Str.Length = Size Then
        For I := 1 To Size Do
            ArrOfElements[I - 1] := Str[I];

    InputSetFromFile := IsCorrectElInputFromFile(Str, Size);
End;

Function InputStringFromFile(Var ArrSize: TArrSize): TArrOfElements;
Var
    ArrOfElements: TArrOfElements;
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
Begin
    FileRestriction();

    IsCorrect := False;
    Repeat
        FileWay := InputPathToTheFile();
        Try
            AssignFile(MyFile, FileWay);
            Try
                Reset(MyFile);
                ArrSize[0] := InputSizeFromFile(MyFile, ArrSize);
                If (ArrSize[1] = GOOD_SIZE) Then
                Begin
                    SetLength(ArrOfElements, ArrSize[0]);
                    IsCorrect := InputSetFromFile(ArrOfElements, ArrSize[0], MyFile);
                End;
            Finally
                Close(MyFile);
            End;
        Except
            Write('Bad strings input from file. Try again: ');
        End;
    Until IsCorrect;

    InputStringFromFile := ArrOfElements;
End;

//making the set
Procedure RenderingSet(ArrOfElements: TArrOfElements; Var ResultSet: TAnsiChar);
Var
    I: Integer;
    Current: Char;
Begin
    For I := 0 To High(ArrOfElements) Do
        For Current In Entitlements Do
            If (Current = ArrOfElements[I]) Then
                Include(ResultSet, AnsiChar(ArrOfElements[I]));
End;

//output from file
Function OutputSetInFile(ResultSet: TAnsiChar): String;
Var
    Str: String;
    Current: Char;
Begin
    Str := '';
    For Current In ResultSet Do
        Str := '''' + Current + ''';';

    OutputSetInFile := Str;
End;

Function OutputResInFile(ResultSet: TAnsiChar): String;
Var
    Res: String;
Begin
    Res := 'Your result is: ';
    If ResultSet = [] Then
        Res := Res + ' empty set.'
    Else
        Res := Res + OutputSetInFile(ResultSet);

    OutputResInFile := Res;
End;

Procedure OutputFromFile(ResultSet: TAnsiChar);
Var
    IsCorrect: Boolean;
    FileWay, Result: String;
    MyFile: TextFile;
Begin
    IsCorrect := False;
    Write('Write way to your file: ');
    Repeat
        FileWay := InputPathToTheFile();
        Try
            AssignFile(MyFile, FileWay);
            Try
                Append(MyFile);
                ReWrite(MyFile);
                Result := OutputResInFile(ResultSet);
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

//output from console
Procedure OutputSetFromConsole(Var ResultSet: TAnsiChar);
Var
    Current: AnsiChar;
Begin
    For Current In ResultSet Do
        Write('''', Current, ''';');

End;

Procedure OutputFromConsole(Var ResultSet: TAnsiChar);
Begin
    Write('The result is: ');
    If ResultSet = [] Then
        Write(' empty set.')
    Else
        OutputSetFromConsole(ResultSet);
End;

//distributive output
Procedure ResultOutputSystem(ResultSet: TAnsiChar);
Var
    Path: Integer;
Begin
    Writeln(#13#10, 'You need to choose where to write information from.');
    Path := ChoosingWorkWay();
    If Path = CONSOLE_KEY Then
        OutputFromConsole(ResultSet)
    Else
        OutputFromFile(ResultSet);
End;

//main dustributive func
Function InputSystem(Var ArrSize: TArrSize): TArrOfElements;
Var
    Path: Integer;
Begin
    Path := ChoosingWorkWay();
    If Path = CONSOLE_KEY Then
        InputSystem := InputStringFromConsole(ArrSize)
    Else
        InputSystem := InputStringFromFile(ArrSize);
End;

//cleaning func
Procedure ClearMemory(Var ArrSize: TArrSize; Var ArrOfElements: TArrOfElements);
Begin
    ArrSize := Nil;
    ArrOfElements := Nil;
End;

Var
    ArrSize: TArrSize;
    ArrOfElements: TArrOfElements;
    ResultSet: TAnsiChar;

Begin
    TaskOutput();

    SetLength(ArrSize, 2);
    SetLength(ArrOfElements, 0);

    ArrOfElements := InputSystem(ArrSize);

    RenderingSet(ArrOfElements, ResultSet);

    ResultOutputSystem(ResultSet);

    ClearMemory(ArrSize, ArrOfElements);

    Readln;

End.
