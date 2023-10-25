Program labt4;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Const
    CONS_NUM: Integer = 1;
    FILE_NUM: Integer = 2;
    MIN_ARR_SIZE: Integer = 2;

Procedure PrintStatement();
Begin
    Writeln('The program calculates whether the entered', #13#10#9, 'natural number sequence is increasing.', #13#10);
End;

//work with way to the file
Function PathCheck(Var IsIncorrect: Boolean): Integer;
Var
    Path: Integer;
    IsCorrect: boolean;
Begin
    IsCorrect := false;
    Try
        Read(Path);
        IsCorrect := true;
    Except
        Write('Invalid numeric input. Try again.', #13#10);
    End;
    If (Path <> CONS_NUM) And (Path <> FILE_NUM) And IsCorrect Then
        Write('Choose only ', CONS_NUM, ' or ', FILE_NUM, ' Try again.', #13#10)
    Else if IsCorrect then
        IsIncorrect := True;

    PathCheck := Path;
End;

Function ChoosingAPath(): Integer;
Var
    Path: Integer;
    IsIncorrect: Boolean;
Begin
    Writeln('Where will we work throught: ', #13#10#9, 'Console: ', CONS_NUM, #9, 'File: ', FILE_NUM, #13#10);
    IsIncorrect := False;
    Repeat
        Write('Your choise: ');
        Path := PathCheck(IsIncorrect);
    Until IsIncorrect;

    ChoosingAPath := Path;
End;

//block of condition cheack
Function IsArrIncreasing(Var ArrOfNumb: Array Of Real): Boolean;
Var
    I: Integer;
    IsConditionYes: Boolean;
Begin
    IsConditionYes := True;

    For I := 1 To High(ArrOfNumb) Do
        If ArrOfNumb[I] > ArrOfNumb[I - 1] Then
        Else
            IsConditionYes := False;

    IsArrIncreasing := IsConditionYes;
End;

Function ResultOfArrChecking(IsIncreas: Boolean): Integer;
Begin
    If IsIncreas Then
        ResultOfArrChecking := 1
    Else
        ResultOfArrChecking := 0;
End;

///work in console
Function InputArrSize(): Integer;
Var
    IsCorrect: Boolean;
    ArrSize: Integer;
Begin
    IsCorrect := False;

    Repeat
        Write('How much number in massive: ');
        Try
            Read(ArrSize);
        Except
            Writeln('Invalid numeric input. Try again.');
        End;
        If (ArrSize < MIN_ARR_SIZE) Then
            Writeln('Min num is ', MIN_ARR_SIZE, '. Try again.')
        Else
            IsCorrect := True;
    Until IsCorrect;

    InputArrSize := ArrSize;
End;

Function EnteringTheCurrentNumber(I: Integer): Real;
Var
    CurrentNum: Real;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;

    Repeat
        Write('Write your ', I + 1, ' number: ');
        Try
            Read(CurrentNum);
            IsCorrect := True;
        Except
            Writeln('Invalid numeric input. Try again.');
        End;
    Until IsCorrect;

    EnteringTheCurrentNumber := CurrentNum;
End;

Procedure InputArr(Var ArrOfNumb: Array Of Real);
Var
    I: Integer;
Begin
    For I := 0 To High(ArrOfNumb) Do
        ArrOfNumb[I] := EnteringTheCurrentNumber(I);
End;

Function ViaConsole(): Integer;
Var
    ArrSize, Res: Integer;
    ArrOfNumb: Array Of Real;
    IsIncreasing: Boolean;
Begin
    ArrSize := InputArrSize;
    SetLength(ArrOfNumb, ArrSize);

    InputArr(ArrOfNumb);
    IsIncreasing := IsArrIncreasing(ArrOfNumb);

    Res := ResultOfArrChecking(IsIncreasing);

    ArrOfNumb := Nil;

    ViaConsole := Res;
End;

///work with file
Procedure FileRestriction();
Begin
    Writeln(#13#10, 'Rules for storing information in a file: ', #13#10#9, '1.  The first line contains an integer: ', #13#10#9#9,
        'the number of array elements;', #13#10#9, '2.  The second line is real nuber', #13#10#9#9, 'entered separated by spaces.', #13#10);
End;

Procedure WayCondition(Way: String; Var IsCorrect: Boolean);
Begin
    If ExtractFileExt(Way) <> '.txt' Then
        Writeln('Write .txt file.')
    Else
        IsCorrect := True;
End;

Function InputWayToTheFile(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Write('Write way to the file: ');
    Readln;
    Repeat
        Read(Way);
        WayCondition(Way, IsCorrect);
        Readln;
    Until IsCorrect;

    InputWayToTheFile := Way;
End;

Function IsFileIntegrity(FileWay: String): Boolean;
Var
    MyFile: TextFile;
    IsIntegrity: Boolean;
Begin
    IsIntegrity := False;
    If FileExists(FileWay) Then
        IsIntegrity := True;

    IsFileIntegrity := IsIntegrity;
End;

Function WorkWithArr(ArrSize: Integer; Var ArrOfNumb: Array Of Real): Integer;
Var
    IsIncreasin: Boolean;
Begin
    IsIncreasin := IsArrIncreasing(ArrOfNumb);
    WorkWithArr := ResultOfArrChecking(IsIncreasin);
End;

Function ResultOfReading(IsCorrect: Boolean; ArrSize: Integer; Var ArrOfNumb: Array Of Real): Integer;
Var
    Res: Integer;

Begin
    If IsCorrect Then
        Res := WorkWithArr(ArrSize, ArrOfNumb)
    Else
    Begin
        Write('ERROR in file.');
        Res := -1;
    End;

    ResultOfReading := Res;
End;

Function IsCorrectInputFromFile(Var MyFile: TextFile; Var ArrSize: Integer): Integer;
Var
    IsCorrect: Boolean;
    ArrOfNumb: Array Of Real;
    I: Integer;
Begin
    IsCorrect := True;
    Try
        Read(MyFile, ArrSize);
    Except
        IsCorrect := False;
    End;
    If (ArrSize < MIN_ARR_SIZE) And IsCorrect Then
        IsCorrect := False;

    If IsCorrect Then
    Begin
        SetLength(ArrOfNumb, ArrSize);
        For I := 0 To High(ArrOfNumb) Do
            Try
                Read(MyFile, ArrOfNumb[I]);
            Except
                IsCorrect := False;
            End;
    End;

    If SeekEof(MyFile) <> True Then
        IsCorrect := False;

    IsCorrectInputFromFile := ResultOfReading(IsCorrect, ArrSize, ArrOfNumb);
End;

Function IsReadingCorrect(FileWay: String; ArrSize: Integer): Integer;
Var
    Res: Integer;
    MyFile: TextFile;
Begin
    AssignFile(MyFile, FileWay);
    Try
        Reset(MyFile);
        Res := IsCorrectInputFromFile(MyFile, ArrSize);
    Except
        Begin
            Write('Bad File.', #13#10);
            Res := -1;
        End;
    End;

    IsReadingCorrect := Res;
End;

Function WorkWithFile(FileWay: String): Integer;
Var
    ArrSize, Res: Integer;
Begin
    Res := IsReadingCorrect(FileWay, ArrSize);

    WorkWithFile := Res;
End;

Function WorkWithIntergrityResoult(IsIntergrity: Boolean; FileWay: String): Integer;
Begin
    If IsIntergrity Then
        WorkWithIntergrityResoult := WorkWithFile(FileWay)
    Else
    Begin
        Write('Bad File.');

        WorkWithIntergrityResoult := -1;
    End;
End;

Function ViaFile(): Integer;
Var
    FileWay: String;
    IsIntegrity: Boolean;
Begin
    FileRestriction();

    FileWay := InputWayToTheFile();
    IsIntegrity := IsFileIntegrity(FileWay);

    ViaFile := WorkWithIntergrityResoult(IsIntegrity, FileWay);
End;

///output console
Procedure OutputViaConsole(Result: Integer);
Begin
    If Result = 1 Then
        Write('Increase.')
    Else
        Write('Uncreased.');
End;

///output file
Function FileCorrectOutput(Res: Integer): String;
Begin
    If (Res = 1) Then
        FileCorrectOutput := 'Increase.'
    Else
        FileCorrectOutput := 'Uncreased.';
End;

Procedure OutputViaFile(Result: Integer);
Var
    FileWay: String;
    MyFile: TextFile;
Begin
    FileWay := InputWayToTheFile();
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
    If (Result <> -1) Then
    Begin
        Writeln(#13#10#10, 'You need to choose where to output the result.');
        Option := ChoosingAPath();

        If Option = FILE_NUM Then
            OutputViaFile(Result)
        Else
            OutputViaConsole(Result);
    End;
End;

Var
    Option, Result: Integer;

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
