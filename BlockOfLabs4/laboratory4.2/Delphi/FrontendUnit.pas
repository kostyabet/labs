Unit FrontendUnit;

Interface

Uses
    Winapi.Windows,
    System.SysUtils,
    Vcl.Grids;

Function IsCorrectAddInNum(Key: Char; CurentStr: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Function IsCorrectNumClipboard(ClipbrdText: String; Cursor: Integer; Const MAX, MIN: Integer): Boolean;
Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Procedure VectorGridPrepearing(ArrayGrid: TStringGrid; NumOfCols: Integer);
Procedure ResettingArray(ArrayGrid: TStringGrid; NumOfCols: Integer);
Procedure VectorsVisible(Appearance: Boolean);
Procedure ResultsVisible(Appearance: Boolean);
Procedure LabelEditChange(ALabeledEdit, NLabeledEdit: String; BVectorStringGrid, CVectorStringGrid: TStringGrid);
Procedure StringGridVkBack(Key: Word; Var VectorStringGrid: TStringGrid);
Function StringGridKeyPress(Var VectorStringGrid: TStringGrid; Key: Char; Col, Row: Integer): Char;
Function VectorStringGridChange(NSize: Integer): Boolean;
Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);

Implementation

Uses
    MainUnit;

Function IsCorrectAddInNum(Key: Char; CurentStr: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Begin
    Insert(Key, CurentStr, SelStart + 1);

    Try
        If (StrToInt(CurentStr) > MAX) Or (StrToInt(CurentStr) < MIN) Then
            Key := NULL_POINT;

        If (Length(CurentStr) > 1) And (CurentStr[1] = ZERO_KEY) Then
            Key := NULL_POINT;

        If (Length(CurentStr) > 1) And (CurentStr[1] = MINUS_KEY) And (CurentStr[2] = ZERO_KEY) Then
            Key := NULL_POINT;
    Except
        Key := NULL_POINT;
    End;

    IsCorrectAddInNum := Key;
End;

Function IsCorrectNumClipboard(ClipbrdText: String; Cursor: Integer; Const MAX, MIN: Integer): Boolean;
Var
    IsCorrect: Boolean;
    BufStr, WorkStr: String;
Begin
    If (MainForm.ActiveControl = MainForm.ALabeledEdit) Then
    Begin
        BufStr := MainForm.ALabeledEdit.Text;
        MainForm.ALabeledEdit.ClearSelection;
        WorkStr := MainForm.ALabeledEdit.Text;
    End
    Else
    Begin
        BufStr := MainForm.NLabeledEdit.Text;
        MainForm.NLabeledEdit.ClearSelection;
        WorkStr := MainForm.NLabeledEdit.Text;
    End;
    Insert(ClipbrdText, WorkStr, Cursor + 1);

    Try
        IsCorrect := Not((StrToInt(WorkStr) > MAX) Or (StrToInt(WorkStr) < MIN));

        IsCorrect := IsCorrect And (Length(WorkStr) > 1) And (WorkStr[1] = ZERO_KEY);
    Except
        IsCorrect := False;
    End;

    If Not IsCorrect And (MainForm.ActiveControl = MainForm.ALabeledEdit) Then
        MainForm.ALabeledEdit.Text := BufStr;

    If Not IsCorrect And (MainForm.ActiveControl = MainForm.NLabeledEdit) Then
        MainForm.NLabeledEdit.Text := BufStr;

    IsCorrectNumClipboard := IsCorrect;
End;

Function CheckKeyCondition(CurentText: String; Key: Char; Const MAX, MIN: Integer): Char;
Begin
    If (CurentText = '-') Then
    Begin
        CheckKeyCondition := Key;
        Exit;
    End;

    Try
        If CurentText <> '' Then
            If (StrToInt(CurentText) > MAX) Or (StrToInt(CurentText) < MIN) Then
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

Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Begin
    Delete(CurentText, SelStart, 1);

    IsCorrectDelete := CheckKeyCondition(CurentText, Key, MAX, MIN);
End;

Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Begin
    Delete(CurentText, SelStart + 1, Length(SelText));

    IsCorrectSelDelete := CheckKeyCondition(CurentText, Key, MAX, MIN);
End;

Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer; Const MAX, MIN: Integer): Char;
Begin
    Delete(CurentText, SelStart + 1, Length(SelText));
    Insert(Key, CurentText, SelStart + 1);

    IsCorrectSelTextInputWithKey := CheckKeyCondition(CurentText, Key, MAX, MIN);
End;

Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Begin
    Insert(Key, Str, SelPos + 1);

    Try
        TryToAdd := Not((StrToInt(Str) > MaxPoint) Or (StrToInt(Str) < MinPoint))
    Except
        TryToAdd := False;
    End;
End;

Procedure VectorGridPrepearing(ArrayGrid: TStringGrid; NumOfCols: Integer);
Var
    I: Integer;
Begin
    ArrayGrid.Cells[0, 0] := '№';
    ArrayGrid.Cells[0, 1] := 'Число';

    For I := 1 To NumOfCols Do
    Begin
        ArrayGrid.Cells[I, 0] := IntToStr(I);
        ArrayGrid.Cells[I, 1] := '';
    End;
End;

Procedure ResettingArray(ArrayGrid: TStringGrid; NumOfCols: Integer);
Begin
    ArrayGrid.ColCount := NumOfCols + 1;

    VectorGridPrepearing(ArrayGrid, NumOfCols)
End;

Procedure VectorsVisible(Appearance: Boolean);
Begin
    MainForm.BVectorStringGrid.Visible := Appearance;
    MainForm.BVectorLabel.Visible := Appearance;
    MainForm.CVectorStringGrid.Visible := Appearance;
    MainForm.CVectorLabel.Visible := Appearance;
    MainForm.ResultButton.Visible := Appearance;

    MainForm.ResultButton.Enabled := False;
    MainForm.ResultLabel.Visible := False;
    MainForm.SaveButton.Enabled := False;
    IfDataSavedInFile := False;

    If Appearance And (StrToInt(MainForm.NLabeledEdit.Text) > 4) Then
    Begin
        MainForm.BVectorStringGrid.Height := 88;
        MainForm.CVectorStringGrid.Height := 88;
    End;

    If Appearance And Not(StrToInt(MainForm.NLabeledEdit.Text) > 4) Then
    Begin
        MainForm.BVectorStringGrid.Height := 68;
        MainForm.CVectorStringGrid.Height := 68;
    End;
End;

Procedure ResultsVisible(Appearance: Boolean);
Begin
    MainForm.ResultButton.Enabled := Appearance;

    If Not Appearance Then
    Begin
        MainForm.ResultLabel.Visible := Appearance;
        MainForm.SaveButton.Enabled := Appearance;
        IfDataSavedInFile := False;
    End;
End;

Function CheckСhanges(IntLabEdit: String): Boolean;
Begin
    Try
        StrToInt(IntLabEdit);

        CheckСhanges := True;
    Except
        CheckСhanges := False;
    End;
End;

Procedure LabelEditChange(ALabeledEdit, NLabeledEdit: String; BVectorStringGrid, CVectorStringGrid: TStringGrid);
Var
    IsVisible: Boolean;
Begin
    IsVisible := CheckСhanges(ALabeledEdit) And CheckСhanges(NLabeledEdit);
    VectorsVisible(IsVisible);

    If IsVisible Then
    Begin
        ResettingArray(BVectorStringGrid, StrToInt(NLabeledEdit));
        ResettingArray(CVectorStringGrid, StrToInt(NLabeledEdit));
    End;
End;

Procedure StringGridVkBack(Key: Word; Var VectorStringGrid: TStringGrid);
Var
    Col, Row: Integer;
Begin
    Col := VectorStringGrid.Col;
    Row := VectorStringGrid.Row;

    If (Key = VK_BACK) Then
        VectorStringGrid.Cells[Col, Row] := Copy(VectorStringGrid.Cells[Col, Row], 1, Length(VectorStringGrid.Cells[Col, Row]) - 1);
End;

Function StringGridKeyPress(Var VectorStringGrid: TStringGrid; Key: Char; Col, Row: Integer): Char;
Const
    MAX_COORD_LENGTH: Integer = 8;
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (VectorStringGrid.Cells[Col, Row] = ZERO_KEY) Then
        Key := NULL_POINT;

    If (VectorStringGrid.Cells[Col, Row] <> '') And (VectorStringGrid.Cells[Col, Row] <> '-') And
        (StrToInt(VectorStringGrid.Cells[Col, Row]) = 0) And (Key = ZERO_KEY) Then
        Key := NULL_POINT;

    If (Key = MINUS_KEY) And (VectorStringGrid.Cells[Col, Row] <> '') Then
        Key := NULL_POINT;

    If (Key = ZERO_KEY) And (VectorStringGrid.Cells[Col, Row] = MINUS_KEY) Then
        Key := NULL_POINT;

    If Not CharInSet(Key, STRGRID_CASE) Then
        Key := NULL_POINT;

    If (VectorStringGrid.Cells[Col, Row] <> '') And
        Not(TryToAdd(Key, VectorStringGrid.Cells[Col, Row], Length(VectorStringGrid.Cells[Col, Row]), MAX_INT_NUM, MIN_INT_NUM)) Then
        Key := NULL_POINT;

    If ((VectorStringGrid.Cells[Col, Row] <> '') And (VectorStringGrid.Cells[Col, Row][1] = MINUS_KEY)) Or (Key = MINUS_KEY) Then
        MinCount := 1;

    If Length(VectorStringGrid.Cells[Col, Row]) = MAX_COORD_LENGTH + MinCount Then
        Key := NULL_POINT;

    StringGridKeyPress := Key;
End;

Function VectorStringGridChange(NSize: Integer): Boolean;
Var
    I: Integer;
Begin
    Try
        For I := 1 To NSize Do
        Begin
            StrToInt(MainForm.BVectorStringGrid.Cells[I, 1]);
            StrToInt(MainForm.CVectorStringGrid.Cells[I, 1]);

            If (MainForm.BVectorStringGrid.Cells[I, 1] = '') Or (MainForm.CVectorStringGrid.Cells[I, 1] = '') Then
                Raise Exception.Create('Clear Cell.');
        End;

        VectorStringGridChange := True;
    Except
        VectorStringGridChange := False;
    End;

End;

Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);
Var
    IsCorrect: Boolean;
Begin
    Try
        IsCorrect := Not((StrToInt(ClipboardText) > MAX_INT_NUM) Or (StrToInt(ClipboardText) < MIN_INT_NUM));

        IsCorrect := IsCorrect And (ClipboardText[1] <> ' ');

        IsCorrect := IsCorrect And (ClipboardText[Length(ClipBoardText)] <> ' ');
    Except
        IsCorrect := False;
    End;

    If IsCorrect Then
        StGrid.Cells[Col, Row] := IntToStr(StrToInt(ClipboardText));
End;

End.
