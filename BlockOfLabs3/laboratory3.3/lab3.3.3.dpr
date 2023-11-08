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
    Write(#13#10, '*The first number is the number of elements ', #13#10, 'of the array, and subsequent numbers of this array*', #13#10);
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

Procedure ArrOfNumbInputFromConsole(Var ArrOfNumb: Array Of Integer);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
    Begin
        Write('Write your ', I + 1, ' numbers: ');
        ArrOfNumb[I] := InputCurrentNumbFromConsole();
    End;

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

Function ArrSizeInputFromFile(ArrSize: Integer): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If ArrSize < MIN_ARR_SIZE Then
        Write('Minimal arr size is ', MIN_ARR_SIZE, '. Try again:')
    Else
        IsCorrect := True;

    ArrSizeInputFromFile := IsCorrect;
End;

Function IsIncorrectArrOfNumbInputFromFile(Var ArrOfNumb: Array Of Integer; ArrSize: Integer; Var MyFile: TextFile): Boolean;
Var
    IsCorrect: Boolean;
    I: Integer;
Begin
    IsCorrect := True;

    For I := 0 To ArrSize - 1 Do
    Begin
        Try
            Read(MyFile, ArrOfNumb[I]);
        Except
            IsCorrect := False;
        End;
    End;

    IsIncorrectArrOfNumbInputFromFile := IsCorrect;
End;

Procedure SortMassive(Var ArrOfNumb: Array Of Integer);
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

Procedure OutputFromFile(Var ArrOfNumb: Array Of Integer);
Var
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
    I: Integer;
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

Procedure OutputFromConsole(Var ArrOfNumb: Array Of Integer);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
        Write(ArrOfNumb[I], ' ');
End;

Procedure ResultOutput(Var ArrOfNumb: Array Of Integer);
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

Var
    IsCorrect: Boolean;
    ArrSize, Path: Integer;
    ArrOfNumb: Array Of Integer;
    FileWay: String;
    MyFile: TextFile;

Begin
    ArrSize := 0;

    ConditionOutput();

    Writeln(#13#10, 'You need to choose where to read information from.');

    Path := ChoosingAPath();
    If Path = CONSOLE_KEY Then
    Begin
        ArrSize := ArrSizeInputFromConsole();

        SetLength(ArrOfNumb, ArrSize);
        ArrOfNumbInputFromConsole(ArrOfNumb);
    End
    Else
    Begin
        FileRestriction();
        Write('Write way to your file: ');
        Repeat
            IsCorrect := True;
            FileWay := InputFileWay();
            AssignFile(MyFile, FileWay);
            Try
                Try
                    Reset(MyFile);
                    If Not Eof(MyFile) Then
                    Begin
                        Try
                            Readln(MyFile, ArrSize);
                        Except
                            Write('Error in array size reading. Try again: ');
                            IsCorrect := False;
                        End;
                        If IsCorrect Then
                            IsCorrect := ArrSizeInputFromFile(ArrSize);
                        If IsCorrect Then
                        Begin
                            SetLength(ArrOfNumb, ArrSize);
                            IsCorrect := IsIncorrectArrOfNumbInputFromFile(ArrOfNumb, ArrSize, MyFile);
                            If not IsCorrect Then
                                Write('Invalid massive elements input. Try again: ');
                        End;
                    End
                    Else
                        Write('mpty file. Try again: ');
                Finally
                    Close(MyFile);
                End;
            Except
                Write('Bad input file. Try again: ');
            End;
        Until IsCorrect;
    End;

    SortMassive(ArrOfNumb);

    ResultOutput(ArrOfNumb);

    ArrOfNumb := Nil;
    Readln;

End.
