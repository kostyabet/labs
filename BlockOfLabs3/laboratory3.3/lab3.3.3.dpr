Program lab3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    FILE_KEY: Integer = 1;
    MIN_ARR_SIZE: Integer = 1;
    CONSOLE_KEY: Integer = 2;
    MIN_FILE_WAY_SIZE: Integer = 5;

Type
    TMassive = Array Of Integer;

Procedure ConditionOutput();
Begin
    Write('The program is designed to sort an array', #13#10#9, 'using the simple insertion method.', #13#10#10);
End;

Procedure PathConditionOutput();
Begin
    Write('Where will we work through: ', #13#10#9, 'File: ', FILE_KEY, ' Console: ', CONSOLE_KEY, #13#10#10);
End;

Procedure FileRestriction();
Begin
    Write(#13#10, '*The first number is the number of elements ', #13#10, 'of the array, and subsequent numbers of this array*', #13#10,
        'Write way to your file: ');
End;

Function ChoosingAPath(): Integer;
Var
    Path: Integer;
    IsCorrect, IsCorrectInput: Boolean;
Begin
    Path := 0;
    IsCorrect := False;
    IsCorrectInput := False;

    PathConditionOutput();
    Write('Please write were we should work: ');
    Repeat
        Try
            Readln(Path);
            IsCorrectInput := True;
        Except
            Write('Error. You should write a one natural number. Try again: ');
        End;

        If (Path = CONSOLE_KEY) Or (Path = FILE_KEY) Then
            IsCorrect := True
        Else
            If IsCorrectInput Then
                Write('Error method. Try again: ');
    Until IsCorrect;

    ChoosingAPath := Path;
End;

Function ArrSizeInputFromConsole(): Integer;
Var
    ArrSize: Integer;
    IsCorrect, IsCorrectInput: Boolean;
Begin
    IsCorrect := False;
    IsCorrectInput := False;
    ArrSize := 0;

    Write('Write your arr size: ');
    Repeat
        Try
            Readln(ArrSize);
            IsCorrectInput := True;
        Except
            Write('Invalid numeric input. Try again: ');
        End;

        If (ArrSize < MIN_ARR_SIZE) And IsCorrectInput Then
            Write('Minimal arr size is: ', MIN_ARR_SIZE, '. Try again: ')
        Else
            If IsCorrectInput Then
                IsCorrect := True;
    Until IsCorrect;

    ArrSizeInputFromConsole := ArrSize;
End;

Function InputCurrentNumbFromConsole(): Integer;
Var
    CurrentNumb: Integer;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    CurrentNumb := 0;

    Repeat
        Try
            Readln(CurrentNumb);
            IsCorrect := True;
        Except
            Write('Invalid numeric input. Try again: ');
        End;
    Until IsCorrect;

    InputCurrentNumbFromConsole := CurrentNumb;
End;

Function IsCorrectArrOfNumbInputFromConsole(ArrSize: Integer; ArrOfNumb: TMassive): Boolean;
Var
    I: Integer;
Begin
    SetLength(ArrOfNumb, ArrSize);
    For I := 0 To High(ArrOfNumb) Do
    Begin
        Write('Write your ', I + 1, ' numbers: ');
        ArrOfNumb[I] := InputCurrentNumbFromConsole();
    End;

    IsCorrectArrOfNumbInputFromConsole := True;
End;

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

Function ArrSizeInputFromFile(FileWay: String): Integer;
Var
    MyFile: TextFile;
    ArrSize: Integer;
Begin

    Try
        AssignFile(MyFile, FileWay);
        Try
            Reset(MyFile);
            Readln(MyFile, ArrSize);
        Finally
            Close(MyFile);
        End;
        If ArrSize < MIN_ARR_SIZE Then
        Begin
            Write('Minimal arr size is ', MIN_ARR_SIZE, '. Try again: ');
            ArrSize := -1;
        End;
    Except
        Write('Error in input size of massive. Try again: ');
        ArrSize := -1;
    End;

    ArrSizeInputFromFile := ArrSize;
End;

Function IsCorrectArrOfNumbInputFromFile(ArrSize: Integer; Var ArrOfNumb: TMassive; FileWay: String): Boolean;
Var
    IsCorrect: Boolean;
    I: Integer;
    MyFile: TextFile;
Begin
    IsCorrect := True;

    If ArrSize = -1 Then
        IsCorrect := False
    Else
    Begin
        SetLength(ArrOfNumb, ArrSize);
        Try
            AssignFile(MyFile, FileWay);
            Try
                Reset(MyFile);
                Readln(MyFile);
                For I := 0 To ArrSize - 1 Do
                    Read(MyFile, ArrOfNumb[I]);
                If (Not Seekeof(MyFile)) Then
                Begin
                    IsCorrect := False;
                    Write('More then ', ArrSize, ' elements in massive. Try again: ');
                End;
            Finally
            End;
        Except
            IsCorrect := False;
            Write('Error in reading massive elements. Try again: ');
        End;
    End;

    IsCorrectArrOfNumbInputFromFile := IsCorrect;
End;

Procedure SortMassive(Var ArrOfNumb: TMassive);
Var
    Temp, I, J: Integer;
Begin
    For I := 1 To High(ArrOfNumb) Do
    Begin
        Temp := ArrOfNumb[I];

        J := I - 1;
        While (J >= 0) And (ArrOfNumb[J] > Temp) Do
        Begin
            ArrOfNumb[J + 1] := ArrOfNumb[J];
            ArrOfNumb[J] := Temp;
            Dec(J);
        End;
    End;
End;

Procedure OutputFromFile(Var ArrOfNumb: TMassive);
Var
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
    I: Integer;
Begin
    IsCorrect := False;
    Write('Write way to your file: ');
    Repeat
        FileWay := InputPathToTheFile();
        AssignFile(MyFile, FileWay);
        Try
            Try
                ReWrite(MyFile);
                For I := 0 To High(ArrOfNumb) Do
                Begin
                    Write(MyFile, ArrOfNumb[I]);
                    Write(MyFile, ' ');
                End;
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

Procedure OutputFromConsole(Var ArrOfNumb: TMassive);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
        Write(ArrOfNumb[I], ' ');
End;

Procedure ResultOutput(Var ArrOfNumb: TMassive);
Var
    Path: Integer;
Begin
    Writeln('You need to choose where to write information from.');
    Path := ChoosingAPath();
    If Path = CONSOLE_KEY Then
        OutputFromConsole(ArrOfNumb)
    Else
        OutputFromFile(ArrOfNumb);
End;

Function InputFileWay(Path: Integer): String;
Var
    Res: String;
Begin
    If Path = FILE_KEY Then
        Res := InputPathToTheFile()
    Else
        Res := '';

    InputFileWay := Res;
End;

Function ArrSizeInput(Path: Integer; FileWay: String): Integer;
Var
    Res: Integer;
Begin
    If Path = FILE_KEY Then
        Res := ArrSizeInputFromFile(FileWay)
    Else
        Res := ArrSizeInputFromConsole();
    ArrSizeInput := Res;
End;

Function InputArrOfNumb(ArrSize: Integer; Var ArrOfNumb: TMassive; Path: Integer; FileWay: String): Boolean;
Var
    Res: Boolean;
Begin
    If Path = FILE_KEY Then
        Res := IsCorrectArrOfNumbInputFromFile(ArrSize, ArrOfNumb, FileWay)
    Else
        Res := IsCorrectArrOfNumbInputFromConsole(ArrSize, ArrOfNumb);
    InputArrOfNumb := Res;
End;

Var
    IsCorrect: Boolean;
    ArrSize, Path: Integer;
    ArrOfNumb: TMassive;
    FileWay: String;

Begin
    ConditionOutput();

    Writeln(#13#10, 'You need to choose where to read information from.');
    Path := ChoosingAPath();

    If Path = FILE_KEY Then
        FileRestriction();

    Repeat
        FileWay := InputFileWay(Path);

        ArrSize := ArrSizeInput(Path, FileWay);
        IsCorrect := InputArrOfNumb(ArrSize, ArrOfNumb, Path, FileWay);
    Until IsCorrect;

    SortMassive(ArrOfNumb);

    ResultOutput(ArrOfNumb);

    ArrOfNumb := Nil;
    Readln;

End.
