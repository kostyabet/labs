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
    MainUnit;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    ReadStatus: Boolean;
    BufA, BufN, BufCoord, I: Integer;
Begin
    Try
        Read(TestFile, BufA);
        If (BufA > MAX_INT_NUM) Or (BufA < MIN_INT_NUM) Then
            Raise Exception.Create('A out of range');

        Read(TestFile, BufN);
        If (BufN > MAX_N) Or (BufN < MIN_N) Then
            Raise Exception.Create('N out of range');

        For I := 1 To 2 * BufN Do
        Begin
            Read(TestFile, BufCoord);

            If (BufCoord > MAX_INT_NUM) Or (BufCoord < MIN_INT_NUM) Then
                Raise Exception.Create('Coordinates out of range');
        End;

        ReadStatus := True;
    Except
        ReadStatus := False;
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

Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);
Var
    MyFile: TextFile;
    BufferInt: Integer;
    BufferStr: String;
Begin
    AssignFile(MyFile, FilePath);
    Try
        Reset(MyFile);
        Try

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
