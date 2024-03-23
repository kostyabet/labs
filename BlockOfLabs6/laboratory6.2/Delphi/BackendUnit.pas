Unit BackendUnit;

Interface

Uses
    System.SysUtils;

Type
    TMatrix = Array Of Array Of Integer;
    TResCoords = Array Of Array [0 .. 1] Of Integer;
    TSteps = Array [0 .. 3] Of Array [0 .. 1] Of Integer;
    TUsed = Array Of Array Of Boolean;

Const
    Steps: TSteps = ((0, 1), (1, 0), (-1, 0), (0, -1));

Procedure SearchLongestWay(Matrix: TMatrix; I1, J1, I2, J2: Integer; Var ResWayCoords: TResCoords);
Procedure CreateResultWindow(ResWayCoords: TResCoords);
Function IsWriteable(FilePath: String): Boolean;
Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Function IsReadable(FilePath: String): Boolean;
Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);

Implementation

Uses
    ResMatrixUnit,
    MainUnit,
    FrontendUnit;

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
                Write(MyFile, 'Ваше дерево:'#13#10);
                //Write(MyFile, PrintConsoleTree());
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            IsCorrect := False;
        End;

    End;
End;

Procedure CoordsRemove(Var Coords: TResCoords);
Var
    NewCoords: TResCoords;
    Counter: Integer;
Begin
    SetLength(NewCoords, Length(Coords) - 1);
    For Counter := Low(Coords) To High(Coords) - 1 Do
        NewCoords[Counter] := Coords[Counter];

    SetLength(Coords, Length(Coords) - 1);
    Coords := Copy(NewCoords);
End;

Procedure CoordsAdd(I, J: Integer; Var Coords: TResCoords);
Var
    NewCoords: TResCoords;
    Counter: Integer;
Begin
    SetLength(NewCoords, Length(Coords));
    For Counter := Low(Coords) To High(Coords) Do
        NewCoords[Counter] := Coords[Counter];

    SetLength(Coords, Length(Coords) + 1);
    For Counter := Low(NewCoords) To High(NewCoords) Do
        Coords[Counter] := NewCoords[Counter];

    Coords[Length(Coords) - 1][0] := I;
    Coords[Length(Coords) - 1][1] := J;
End;

Procedure Rec(Sx, Sy, Fx, Fy, Sum: Integer; Ans: Integer; Matrix: TMatrix; Used: TUsed; TempCoords: TResCoords;
    Var ResWayCoords: TResCoords);
Const
    STEPS_COUNT: Integer = 4;
Var
    I, X, Y: Integer;
Begin
    For I := 0 To STEPS_COUNT - 1 Do
    Begin
        X := SX + Steps[I, 0];
        Y := SY + Steps[I, 1];
        If Not((X < 0) Or (Y < 0) Or (X >= Length(Matrix)) Or (Y >= Length(Matrix[0])) Or (Used[X, Y])) Then
        Begin
            If (X = Fx) And (Y = Fy) And (Sum + Matrix[X][Y] > Ans) Then
            Begin
                Ans := Sum + Matrix[X][Y];
                ResWayCoords := Copy(TempCoords);
            End;
            CoordsAdd(X, Y, TempCoords);
            Used[X, Y] := True;
            Rec(X, Y, Fx, Fy, Sum + Matrix[X][Y], Ans, Matrix, Used, TempCoords, ResWayCoords);
            Used[X, Y] := False;
            CoordsRemove(TempCoords);
        End;
    End;
End;

Procedure SearchLongestWay(Matrix: TMatrix; I1, J1, I2, J2: Integer; Var ResWayCoords: TResCoords);
Var
    Used: TUsed;
    TempCoords: TResCoords;
    Ans: Integer;
    I: Integer;
    J: Integer;
Begin
    Ans := -2_000_000_000;
    SetLength(Used, Length(Matrix));
    For I := Low(Matrix) To High(Matrix) Do
    Begin
        SetLength(Used[I], Length(Matrix[I]));
        For J := Low(Matrix[I]) To High(Matrix[I]) Do
            Used[I][J] := False;
    End;
    CoordsAdd(I1, J1, TempCoords);
    Used[I1, J1] := True;
    Rec(I1, J1, I2, J2, Matrix[I1][J1], Ans, Matrix, Used, TempCoords, ResWayCoords);
    CoordsAdd(I2, J2, ResWayCoords);
End;

Procedure CreateResultWindow(ResWayCoords: TResCoords);
Var
    I: Integer;
Begin
    Form1.Label1.Caption := '';
    For I := Low(ResWayCoords) To High(ResWayCoords) Do
        Form1.Label1.Caption := Form1.Label1.Caption + IntToStr(ResWayCoords[I][0]) + ' : ' + IntToStr(ResWayCoords[I][1]) + #13#10;
End;

Function TryReadNum(Var TestFile: TextFile; Var ReadStatus: Boolean; MAX_NUM: Integer): Integer;
Const
    SPACE_LIMIT: Integer = 4;
Var
    EndOfNum: Boolean;
    Character, BufChar: Char;
    SpaceCounter, Num, MinCount: Integer;
Begin
    Num := 0;
    EndOfNum := False;
    SpaceCounter := 0;
    Character := NULL_POINT;
    BufChar := Character;
    MinCount := 1;
    While ReadStatus And Not(EndOfNum) And Not(EOF(TestFile)) Do
    Begin
        BufChar := Character;
        Read(TestFile, Character);

        ReadStatus := ReadStatus And Not((Character <> ' ') And Not((Character > Pred('0')) And (Character < Succ('9'))) And
            (Character <> #13) And (Character <> #10) And (Character <> '-'));

        If (Character = ' ') Then
            Inc(SpaceCounter)
        Else
            SpaceCounter := 0;

        ReadStatus := Not(SpaceCounter = SPACE_LIMIT);

        If (Character > Pred('0')) And (Character < Succ('9')) Then
            Num := Num * 10 + Ord(Character) - 48;

        If (Character = '-') Then
            MinCount := -1;

        ReadStatus := ReadStatus And Not((Character = '-') And (BufChar <> ' ') And (BufChar <> #0));

        ReadStatus := ReadStatus And Not((Character = '-') And (MinCount <> -1));

        EndOfNum := ((Character = ' ') Or (Character = #13)) And ((BufChar > Pred('0')) And (BufChar < Succ('9')));

        ReadStatus := ReadStatus And Not((Num = 0) And (Character > Pred('0')) And (Character < Succ('9')));

        ReadStatus := ReadStatus And Not(Num > MAX_NUM);
    End;

    If ReadStatus Then
        Num := MinCount * Num;

    TryReadNum := Num;
End;

Function CheckNum(Num, Max, Min, Count: Integer): Boolean;
Begin
    CheckNum := Not((Num > MAX) Or (Num < MIN));
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    M, N, ArrEl, Count, I, J: Integer;
    I1, J1, I2, J2: Integer;
    ReadStatus: Boolean;
Begin
    Count := 0;
    ReadStatus := True;
    M := TryReadNum(TestFile, ReadStatus, MAX_INT);
    ReadStatus := CheckNum(M, MAX_INT, MIN_INT, 0);
    N := TryReadNum(TestFile, ReadStatus, MAX_INT);
    ReadStatus := CheckNum(N, MAX_INT, MIN_INT, 0);
    For I := 0 To M - 1 Do
        For J := 0 To N - 1 Do
        Begin
            ArrEl := TryReadNum(TestFile, ReadStatus, MAX_INT);
            ReadStatus := CheckNum(ArrEl, MAX_INT, MIN_INT, Count);
            Inc(Count);
        End;
    I1 := TryReadNum(TestFile, ReadStatus, M);
    J1 := TryReadNum(TestFile, ReadStatus, N);
    I2 := TryReadNum(TestFile, ReadStatus, M);
    J2 := TryReadNum(TestFile, ReadStatus, N);
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
    M, N, I, J, El, I1, J1, I2, J2: Integer;
    Sender: TObject;
Begin
    Try
        While Not(EOF(MyFile)) Do
        Begin
            Read(MyFile, M);
            MainForm.MRowsLEdit.Text := IntToStr(M);
            Read(MyFile, N);
            MainForm.NColsLEdit.Text := IntToStr(N);
            ChangeMassiveStGridSize(MainForm.MassiveStGrid, M, N);
            MainForm.MassiveStGrid.ColCount := N;
            ClearElAndPoints();
            ChangeHint(IntToStr(M), IntToStr(N));
            ChangeVisible(True);
            For I := 0 To M - 1 Do
                For J := 0 To N - 1 Do
                Begin
                    Read(MyFile, El);
                    MainForm.MassiveStGrid.Cells[I, J] := IntToStr(El);
                End;
            Read(MyFile, I1);
            MainForm.IStartPointLEdit.Text := IntToStr(I1);
            Read(MyFile, J1);
            MainForm.JStartPointLEdit.Text := IntToStr(J1);
            Read(MyFile, I2);
            MainForm.IEndPointLEdit.Text := IntToStr(I2);
            Read(MyFile, J2);
            MainForm.JEndPointLEdit.Text := IntToStr(J2);
        End;
        IsCorrect := True;
    Except
        IsCorrect := False;
    End;

    IsCorrect := IsCorrect And SeekEOF(MyFile);
End;

Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
    Sender: TObject;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath);
        Try
            Reset(MyFile);
            Try
                ReadingProcess(IsCorrect, MyFile);
                MainForm.ResultSpButton.Enabled := True;
            Finally
                Close(MyFile);
            End;
        Except
            IsCorrect := False;
        End;
    End;
End;

End.
