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

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    ReadStatus: Boolean;
    BufA, BufN, BufCoord, I: Integer;
Begin
    BufA := ;

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
