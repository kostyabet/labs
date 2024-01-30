Unit BackendUnit;

Interface

Uses
    System.SysUtils;

Function TryRead(Var TestFile: TextFile): Boolean;
Function IsReadable(FilePath: String): Boolean;
Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Function IsWriteable(FilePath: String): Boolean;
Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);

Implementation

Uses
    MainUnit,
    FrontendUnit;

Function TryReadNum(Var TestFile: TextFile; Var ReadStatus: Boolean; MAX_NUM: Integer): Integer;
Const
    SPACE_LIMIT: Integer = 4;
Var
    EndOfNum: Boolean;
    Character, BufChar: Char;
    SpaceCounter, Num: Integer;
Begin
    Num := 0;
    EndOfNum := False;
    SpaceCounter := 0;
    Character := #0;
    BufChar := Character;
    While ReadStatus And Not(EndOfNum) And Not(EOF(TestFile)) Do
    Begin
        BufChar := Character;
        Read(TestFile, Character);

        If (Character <> ' ') And Not((Character > Pred('0')) And (Character < Succ('9'))) And (Character <> #13) And
            (Character <> #10) Then
            ReadStatus := False;

        If (Character = ' ') Then
            Inc(SpaceCounter)
        Else
            SpaceCounter := 0;

        If SpaceCounter = SPACE_LIMIT Then
            ReadStatus := False;

        If (Character > Pred('0')) And (Character < Succ('9')) Then
            Num := Num * 10 + Ord(Character) - 48;

        If (Character = ' ') And ((BufChar > Pred('0')) And (BufChar < Succ('9'))) Then
            EndOfNum := True;

        If (Num > MAX_NUM) Then
            ReadStatus := False;
    End;

    TryReadNum := Num;
End;

Function CheckNum(ReadStatus: Boolean; Num, Max, Min: Integer): Boolean;
Begin
    If (Num > MAX) Or (Num < MIN) Then
        ReadStatus := False;

    CheckNum := ReadStatus;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufA, BufN, BufCoord, I: Integer;
    ReadStatus: Boolean;
Begin
    BufA := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM);
    ReadStatus := CheckNum(ReadStatus, BufA, MAX_INT_NUM, MIN_INT_NUM);
    BufN := TryReadNum(TestFile, ReadStatus, MAX_N);
    ReadStatus := CheckNum(ReadStatus, BufN, MAX_N, MIN_N);

    For I := 1 To BufN Do
    Begin
        BufCoord := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM);
        ReadStatus := CheckNum(ReadStatus, BufCoord, MAX_INT_NUM, MIN_INT_NUM);
    End;

    For I := 1 To BufN Do
    Begin
        BufCoord := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM);
        ReadStatus := CheckNum(ReadStatus, BufCoord, MAX_INT_NUM, MIN_INT_NUM);
    End;

    ReadStatus := ReadStatus And SeekEOF(TestFile);

    TryRead := ReadStatus;
End;

Function IsReadable(FilePath: String): Boolean;
Var
    TestFile: TextFile;
Begin
    Try
        AssignFile(TestFile, FilePath, CP_UTF8);
        Try
            Reset(TestFile);
            IsReadable := TryRead(TestFile);
        Finally
            Close(TestFile);
        End;
    Except
        IsReadable := False;
    End;
End;

Procedure ReadingProcess(Var IsCorrect: Boolean; Var MyFile: TextFile);
Var
    I, A, N, Coord: Integer;
Begin
    Try
        Read(MyFile, A);
        MainForm.ALabeledEdit.Text := IntToStr(A);
        Read(MyFile, N);
        MainForm.NLabeledEdit.Text := IntToStr(N);
        VectorsVisible(True);

        For I := 1 To N Do
        Begin
            Read(MyFile, Coord);
            MainForm.BVectorStringGrid.Cells[I, 1] := IntToStr(Coord);
        End;
        For I := 1 To N Do
        Begin
            Read(MyFile, Coord);
            MainForm.CVectorStringGrid.Cells[I, 1] := IntToStr(Coord);
        End;

        IsCorrect := True;
    Except
        IsCorrect := False;
    End;
    ResultsVisible(VectorStringGridChange(StrToInt(MainForm.NLabeledEdit.Text)));

    IsCorrect := IsCorrect And SeekEOF(MyFile);
End;

Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    AssignFile(MyFile, FilePath);
    Try
        Reset(MyFile);
        Try
            ReadingProcess(IsCorrect, MyFile);
        Finally
            Close(MyFile);
        End;

        IsCorrect := True;
    Except
        IsCorrect := False;
    End;
End;

Function IsWriteable(FilePath: String): Boolean;
Var
    TestFile: TextFile;
Begin
    Try
        AssignFile(TestFile, FilePath);
        Try
            Rewrite(TestFile);
            IsWriteable := True;
        Finally
            CloseFile(TestFile);
        End;
    Except
        IsWriteable := False;
    End;
End;

Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
        Try
            ReWrite(MyFile);
            Try
                Writeln(MyFile, MainForm.ResultLabel.Caption);
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            IsCorrect := False;
        End;

    End;
End;

End.
