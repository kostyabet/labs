Unit BackendUnit;

Interface

Uses
    Vcl.Grids,
    System.SysUtils;

Type
    TMassive = Array Of Integer;
    TMatrix = Array Of Array Of Integer;
    TByteSet = Set Of Byte;

Function TryReadNum(Var TestFile: TextFile; Var ReadStatus: Boolean; MAX_NUM: Integer; EndOfNums: Boolean): Integer;
Function CheckNum(Num, Max, Min: Integer): Boolean;
Function TryRead(Var TestFile: TextFile): Boolean;
Function IsReadable(FilePath: String): Boolean;
Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Function IsWriteable(FilePath: String): Boolean;
Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Procedure InputVectorFromGrid(Var Vector: TMassive; StringGrid: TStringGrid; N: Integer);
Procedure AddToArray(Var Results: TMatrix; CurrentPath: TMassive; NSize, CurentSum: Integer);
Procedure CheckingCVectorCondition(CurrentPath, CVector: TMassive; ACount, NSize: Integer; Var Results: TMatrix);
Function IndexOf(BVector: TMassive; Count: Integer): Integer;
Procedure SearchSuitableAmo(SubArray, BVector, CVector: TMassive; ACount, NSize: Integer; Var Results: TMatrix;
    CurrentPath: Tmassive = Nil);
Procedure Swap(Var Matrix: TMatrix; I, J: Integer);
Function Partition(Var Matrix: TMatrix; Left, Right: Integer): Integer;
Procedure QuickSort(Var Matrix: TMatrix; Left, Right: Integer);
Procedure AddResToSubset(Sums: TMatrix; Var ISubset: TByteSet);
Procedure TreatmentData(BVector, CVector: TMassive; ACount, NSize: Integer; Var Sums: TMatrix; Var ISubset: TByteSet);
Function CreateStringWithVector(Vector: TMassive): String;
Function CreateStringWithSet(ISubset: TByteSet): String;
Function CreateResultString(ACount, NSize: Integer; BVector, CVector: TMassive; ISubset: TByteSet): String;

Implementation

Uses
    MainUnit,
    FrontendUnit;

Function TryReadNum(Var TestFile: TextFile; Var ReadStatus: Boolean; MAX_NUM: Integer; EndOfNums: Boolean): Integer;
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

    ReadStatus := ReadStatus And Not(EOF(TestFile) And Not EndOfNums);

    If ReadStatus Then
        Num := MinCount * Num;

    TryReadNum := Num;
End;

Function CheckNum(Num, Max, Min: Integer): Boolean;
Begin
    CheckNum := Not((Num > MAX) Or (Num < MIN));
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    BufA, BufN, BufCoord, I: Integer;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    BufA := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM, False);
    ReadStatus := CheckNum(BufA, MAX_INT_NUM, MIN_INT_NUM);
    BufN := TryReadNum(TestFile, ReadStatus, MAX_N, False);
    ReadStatus := CheckNum(BufN, MAX_N, MIN_N);

    For I := 1 To BufN Do
    Begin
        BufCoord := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM, False);
        ReadStatus := CheckNum(BufCoord, MAX_INT_NUM, MIN_INT_NUM);
    End;

    For I := 1 To BufN Do
    Begin
        BufCoord := TryReadNum(TestFile, ReadStatus, MAX_INT_NUM, I = BufN);
        ReadStatus := CheckNum(BufCoord, MAX_INT_NUM, MIN_INT_NUM);
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
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath);
        Try
            Reset(MyFile);
            Try
                ReadingProcess(IsCorrect, MyFile);
            Finally
                Close(MyFile);
            End;
        Except
            IsCorrect := False;
        End;
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
                Writeln(MyFile, ResultString);
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            IsCorrect := False;
        End;

    End;
End;

Procedure InputVectorFromGrid(Var Vector: TMassive; StringGrid: TStringGrid; N: Integer);
Var
    I: Integer;
Begin
    SetLength(Vector, N);

    For I := 1 To N Do
        Vector[I - 1] := StrToInt(StringGrid.Cells[I, 1]);
End;

Procedure AddToArray(Var Results: TMatrix; CurrentPath: TMassive; NSize, CurentSum: Integer);
Var
    I: Integer;
Begin
    SetLength(Results, Length(Results) + 1, NSize + 1);

    For I := 0 To High(CurrentPath) Do
        Results[High(Results)][I + 1] := CurrentPath[I] + 1;
    Results[High(Results)][0] := CurentSum;
End;

Procedure CheckingCVectorCondition(CurrentPath, CVector: TMassive; ACount, NSize: Integer; Var Results: TMatrix);
Var
    CurentSum, I: Integer;
Begin
    CurentSum := 0;
    For I := 0 To High(CurrentPath) Do
        CurentSum := CurentSum + CVector[CurrentPath[I]];

    If (CurentSum <= ACount) Then
        AddToArray(Results, CurrentPath, NSize, CurentSum);
End;

Function IndexOf(BVector: TMassive; Count: Integer): Integer;
Var
    I, IndexNum: Integer;
Begin
    IndexNum := -1;
    For I := Low(BVector) To High(BVector) Do
        If (BVector[I] = Count) And (IndexNum = -1) Then
            IndexNum := I;

    IndexOf := IndexNum;
End;

Procedure SearchSuitableAmo(SubArray, BVector, CVector: TMassive; ACount, NSize: Integer; Var Results: TMatrix;
    CurrentPath: Tmassive = Nil);
Var
    CurrentPath2, CurrentPath1: TMassive;
    I: Integer;
Begin
    If (Length(SubArray) = 0) Then
        CheckingCVectorCondition(CurrentPath, CVector, ACount, NSize, Results)
    Else
    Begin
        SetLength(CurrentPath1, Length(CurrentPath) + 1);
        For I := 0 To High(CurrentPath) Do
            CurrentPath1[I] := CurrentPath[I];
        CurrentPath1[Length(CurrentPath)] := IndexOf(BVector, SubArray[0]);
        SearchSuitableAmo(Copy(SubArray, 1, Length(SubArray) - 1), BVector, CVector, ACount, NSize, Results, CurrentPath1);

        SetLength(CurrentPath2, Length(CurrentPath));
        For I := 0 To High(CurrentPath) Do
            CurrentPath2[I] := CurrentPath[I];
        SearchSuitableAmo(Copy(SubArray, 1, Length(SubArray) - 1), BVector, CVector, ACount, NSize, Results, CurrentPath2);
    End;
End;

Procedure Swap(Var Matrix: TMatrix; I, J: Integer);
Var
    Temp0, Temp1: Integer;
Begin
    Temp0 := Matrix[I][0];
    Temp1 := Matrix[I][1];
    Matrix[I][0] := Matrix[J][0];
    Matrix[I][1] := Matrix[J][1];
    Matrix[J][0] := Temp0;
    Matrix[J][1] := Temp1;
End;

Function Partition(Var Matrix: TMatrix; Left, Right: Integer): Integer;
Var
    I, J, Pivot: Integer;
Begin
    Pivot := Matrix[Left][0];
    I := Left + 1;

    For J := Left + 1 To Right Do
        If (Matrix[J][0] > Pivot) Then
        Begin
            Swap(Matrix, I, J);
            Inc(I);
        End;

    Swap(Matrix, Left, I - 1);
    Partition := I - 1;
End;

Procedure QuickSort(Var Matrix: TMatrix; Left, Right: Integer);
Var
    PivotIndex: Integer;
Begin
    If Left < Right Then
    Begin
        PivotIndex := Partition(Matrix, Left, Right);
        QuickSort(Matrix, Left, PivotIndex - 1);
        QuickSort(Matrix, PivotIndex + 1, Right);
    End;
End;

Procedure AddResToSubset(Sums: TMatrix; Var ISubset: TByteSet);
Var
    I: Integer;
Begin
    For I := 1 To High(Sums[0]) Do
        If Sums[0][I] <> 0 Then
            Include(ISubset, Sums[0][I]);
End;

Procedure TreatmentData(BVector, CVector: TMassive; ACount, NSize: Integer; Var Sums: TMatrix; Var ISubset: TByteSet);
Begin
    SearchSuitableAmo(BVector, BVector, CVector, ACount, NSize, Sums);
    QuickSort(Sums, 0, Length(Sums) - 1);
    If Sums <> Nil Then
        AddResToSubset(Sums, ISubset);
End;

Function CreateStringWithVector(Vector: TMassive): String;
Var
    VectorStr: String;
    I: Integer;
Begin
    VectorStr := '';
    For I := 0 To High(Vector) Do
        VectorStr := VectorStr + IntToStr(Vector[I]) + ' ';

    CreateStringWithVector := VectorStr;
End;

Function CreateStringWithSet(ISubset: TByteSet): String;
Var
    SetStr: String;
    Curent: Byte;
Begin
    SetStr := 'Подмножество I:';
    If ISubset = [] Then
        SetStr := SetStr + ' пустое множество...'
    Else
    Begin
        For Curent In ISubset Do
            SetStr := SetStr + ' ' + IntToStr(Curent);
    End;
    CreateStringWithSet := SetStr;
End;

Function CreateResultString(ACount, NSize: Integer; BVector, CVector: TMassive; ISubset: TByteSet): String;
Var
    ResultStr: String;
    OutputStr: String;
Begin
    ResultStr := 'A: ' + IntToStr(ACount) + ';'#13#10'N: ' + IntToStr(NSize) + ';'#13#10;
    ResultStr := ResultStr + 'Вектор B: ' + CreateStringWithVector(BVector) + #13#10;
    ResultStr := ResultStr + 'Вектор C: ' + CreateStringWithVector(CVector) + #13#10;
    OutputStr := CreateStringWithSet(ISubset);
    ResultStr := ResultStr + OutputStr;

    ResultString := ResultStr;

    CreateResultString := OutputStr;
End;

End.
