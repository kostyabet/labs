Unit FrontendUnit;

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
    Vcl.Buttons,
    Vcl.Menus,
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    System.ImageList,
    Vcl.ImgList,
    Vcl.Grids;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Function IsCorrectPointsClipboard(ClipbrdText: String; NumLabEd: TLabeledEdit): Boolean;
Procedure ClearStringGrid();
Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer): Char;
Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function IsCorrectInput(Key: Char; CurentText: String; SelStart: Integer): Char;
Function IsWriteable(FilePath: String): Boolean;
Procedure InputInFile(Var IsCorrect: Boolean; FilePath: String);
Function IsReadable(FilePath: String): Boolean;
Procedure ReadFromFile(Var IsCorrect: Boolean; FilePath: String);

Const
    MIN_POINTS: Integer = -1_000_000_000;
    MAX_POINTS: Integer = +1_000_000_000;
    NULL_POINT: Char = #0;
    ZERO_KEY: Char = '0';
    MINUS_KEY: Char = '-';

Implementation

Uses
    MainFormUnit;

Procedure InsertInList(Value: Integer); Stdcall; External 'DoubleLinkedList.dll';
Procedure DeleteFromList(Num: Integer); Stdcall; External 'DoubleLinkedList.dll';
Procedure PrintList(Var LinkedListStrGrid: TStringGrid); Stdcall; External 'DoubleLinkedList.dll';

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Const
    LEFT_MARGIN: Integer = 10;
    TOP_MARGIN: Integer = 5;
Var
    ModalForm: TForm;
    ModalLabel: TLAbel;
Begin
    ModalForm := TForm.Create(Nil);
    Try
        ModalForm.Caption := CaptionText;
        ModalForm.Width := ModalWidth;
        ModalForm.Height := ModalHeight;
        ModalForm.Position := PoScreenCenter;
        ModalForm.BorderStyle := BsSingle;
        ModalForm.BorderIcons := [BiSystemMenu];
        ModalForm.FormStyle := FsStayOnTop;
        ModalForm.Icon := MainForm.Icon;
        ModalLabel := TLabel.Create(ModalForm);
        ModalLabel.Parent := ModalForm;
        ModalLabel.Caption := LabelText;
        ModalLabel.Left := LEFT_MARGIN;
        ModalLabel.Top := TOP_MARGIN;
        ModalForm.ShowModal;
    Finally
        ModalForm.Free;
    End;
End;

Function IsCorrectPointsClipboard(ClipbrdText: String; NumLabEd: TLabeledEdit): Boolean;
Var
    Cursor: Integer;
    WorkStr: String;
    IsCorrect: Boolean;
Begin
    NumLabEd.ClearSelection;
    Cursor := NumLabEd.SelStart;
    WorkStr := NumLabEd.Text;
    Insert(ClipbrdText, WorkStr, Cursor);

    Try
        IsCorrect := Not((StrToInt(WorkStr) > MAX_POINTS) Or (StrToInt(WorkStr) < MIN_POINTS));

        IsCorrect := IsCorrect And (Length(WorkStr) > 1) And (WorkStr[1] = ZERO_KEY);
    Except
        IsCorrect := False;
    End;

    IsCorrectPointsClipboard := IsCorrect;
End;

Procedure ClearStringGrid();
Var
    I: Integer;
Begin
    For I := 1 To MainForm.LinkedListStrGrid.RowCount Do
    Begin
        MainForm.LinkedListStrGrid.Cells[0, I] := '';
        MainForm.LinkedListStrGrid.Cells[1, I] := '';
    End;
End;

Function CheckKeyCondition(CurentText: String; Key: Char): Char;
Begin
    Try
        If (CurentText <> '') And (CurentText <> '-') Then
            If (StrToInt(CurentText) > MAX_POINTS) Or (StrToInt(CurentText) < MIN_POINTS) Then
                Key := NULL_POINT;

        If (Length(CurentText) > 1) And (CurentText[1] = ZERO_KEY) Then
            Key := NULL_POINT;

        If (Length(CurentText) > 1) And (CurentText[1] = MINUS_KEY) And (CurentText[2] = ZERO_KEY) Then
            Key := NULL_POINT;
    Except
        Key := NULL_POINT;
    End;

    CheckKeyCondition := Key;
End;

Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer): Char;
Begin
    Delete(CurentText, SelStart, 1);

    IsCorrectDelete := CheckKeyCondition(CurentText, Key);
End;

Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Begin
    Delete(CurentText, SelStart + 1, Length(SelText));

    IsCorrectSelDelete := CheckKeyCondition(CurentText, Key);
End;

Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Begin
    Delete(CurentText, SelStart + 1, Length(SelText));
    Insert(Key, CurentText, SelStart + 1);

    IsCorrectSelTextInputWithKey := CheckKeyCondition(CurentText, Key);
End;

Function IsCorrectInput(Key: Char; CurentText: String; SelStart: Integer): Char;
Begin
    Insert(Key, CurentText, SelStart + 1);

    IsCorrectInput := CheckKeyCondition(CurentText, Key);
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
    I: Integer;
Begin
    If IsCorrect Then
    Begin
        AssignFile(MyFile, FilePath, CP_UTF8);
        Try
            ReWrite(MyFile);
            Try
                Writeln(MyFile, 'Список в обратном порядке: ');
                Writeln(MyFile, ' _____________________________________');
                Writeln(MyFile, '|   №  |           Значение          |');
                Writeln(MyFile, '|-------|-----------------------------|');
                For I := 1 To MainForm.LinkedListStrGrid.RowCount - 1 Do
                    Writeln(MyFile, '|', MainForm.LinkedListStrGrid.Cells[0, I]:6, ' |', MainForm.LinkedListStrGrid.Cells[1, I]:28, ' |');
                Writeln(MyFile, '|_______|_____________________________|');
            Finally
                Close(MyFile);
            End;
            IfDataSavedInFile := True;
        Except
            IsCorrect := False;
        End;

    End;
End;

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
    BufA: Integer;
    ReadStatus: Boolean;
Begin
    ReadStatus := True;
    BufA := TryReadNum(TestFile, ReadStatus, MAX_POINTS, False);
    ReadStatus := CheckNum(BufA, MAX_POINTS, MIN_POINTS);

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
    Num: Integer;
Begin
    Try
        Read(MyFile, Num);
        InsertInList(Num);
        MainForm.LinkedListStrGrid.RowCount := MainForm.LinkedListStrGrid.RowCount + 1;
        PrintList(MainForm.LinkedListStrGrid);
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
                MainForm.SaveButton.Enabled := True;
            Finally
                Close(MyFile);
            End;
        Except
            IsCorrect := False;
        End;
    End;
End;

End.
