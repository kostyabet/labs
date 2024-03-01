Unit BackendUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Menus,
    System.ImageList,
    Vcl.ImgList,
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.ExtCtrls,
    Vcl.Buttons,
    Clipbrd;

Function IsWriteable(FilePath: String): Boolean;
Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Function IsReadable(FilePath: String): Boolean;
Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);

Implementation

Uses
    MainFormUnit,
    FrontendUnit,
    TreeUnit;

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
                Write(MyFile, PrintConsoleTree());
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            IsCorrect := False;
        End;

    End;
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
    If ((Count Mod 2 = 1) And (GetExistPoints(Num) <> -1)) Then
        CheckNum := False;
End;

Function TryRead(Var TestFile: TextFile): Boolean;
Var
    Buf, Count: Integer;
    ReadStatus: Boolean;
Begin
    Count := 0;
    ReadStatus := True;
    Buf := TryReadNum(TestFile, ReadStatus, MAX_INT);
    ReadStatus := CheckNum(Buf, MAX_INT, MIN_INT, 0);
    While Not(EOF(TestFile)) Do
    Begin
        Buf := TryReadNum(TestFile, ReadStatus, MAX_INT);
        ReadStatus := CheckNum(Buf, MAX_INT, MIN_INT, Count);
        Inc(Count);
    End;
    ReadStatus := ReadStatus And SeekEOF(TestFile);
    ReadStatus := Not((Count = 0) Or (Count Mod 2 = 1));

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
    Child, Cost: Integer;
Begin
    Try
        CreateTree();
        Cost := 0;
        Read(MyFile, Child);
        InsertNewBranch(Child, Cost);
        While Not(EOF(MyFile)) Do
        Begin
            Read(MyFile, Child);
            Read(MyFile, Cost);
            InsertNewBranch(Child, Cost);
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
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath);
        Try
            Reset(MyFile);
            Try
                ReadingProcess(IsCorrect, MyFile);
                MainForm.EndSpButton.Click;
            Finally
                Close(MyFile);
            End;
        Except
            IsCorrect := False;
        End;
    End;
End;

End.
