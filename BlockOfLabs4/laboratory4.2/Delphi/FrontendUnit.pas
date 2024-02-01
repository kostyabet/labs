Unit FrontendUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    Vcl.ExtCtrls,
    Vcl.Grids;

Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Function TryToDelete(Key: Word; Str: String; SelPos: Integer; LabeledEdit: TLabeledEdit): Word;
Function CheckMinus(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Function CheckZero(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Function CheckSelText(LabeledEdit: TLabeledEdit; Key: Char; Const MAX_NUM, MIN_NUM: Integer): Boolean;
Procedure VectorGridPrepearing(ArrayGrid: TStringGrid; NumOfCols: Integer);
Procedure ResettingArray(ArrayGrid: TStringGrid; NumOfCols: Integer);
Procedure VectorsVisible(Appearance: Boolean);
Procedure ResultsVisible(Appearance: Boolean);
Function CheckСhanges(IntLabEdit: TLabeledEdit): Boolean;
Procedure LabelEditChange(ALabeledEdit, NLabeledEdit: TLabeledEdit; BVectorStringGrid, CVectorStringGrid: TStringGrid);
Procedure StringGridVkBack(Key: Word; Var VectorStringGrid: TStringGrid);
Function StringGridKeyPress(Var VectorStringGrid: TStringGrid; Key: Char; Col, Row: Integer): Char;
Function VectorStringGridChange(NSize: Integer): Boolean;
Procedure TryToAddClipboard(ClipboardText: String; Const MaxPoint, MinPoint: Integer; Var LabeledEdit: TLabeledEdit);
Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);

Implementation

Uses
    MainUnit;

Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Begin
    Insert(Key, Str, SelPos + 1);

    Try
        If (StrToInt(Str) > MaxPoint) Or (StrToInt(Str) < MinPoint) Then
            TryToAdd := False
        Else
            TryToAdd := True;
    Except
        TryToAdd := False;
    End;
End;

Function TryToDelete(Key: Word; Str: String; SelPos: Integer; LabeledEdit: TLabeledEdit): Word;
Begin
    If (LabeledEdit.SelText = '') And (Length(Str) > 0) Then
        Delete(Str, SelPos + Ord(Key = VK_DELETE), 1)
    Else
        If (Length(Str) > 0) Then
        Begin
            Delete(Str, SelPos + 1, Length(LabeledEdit.SelText));
            Inc(SelPos);
        End;

    Try
        If (Str <> '0') And (LabeledEdit.Text = MainForm.NLabeledEdit.Text) Then
            LabeledEdit.Text := Str;

        If Not((Str[1] = '0') And (Length(Str) > 1)) And (Str <> '-0') And (LabeledEdit.Text = MainForm.ALabeledEdit.Text) Then
            LabeledEdit.Text := Str;
    Except
        LabeledEdit.Text := LabeledEdit.Text;
    End;

    If (Str = '') Or (Str = '-') Then
        LabeledEdit.Text := Str;

    If (Key = VK_BACK) And (LabeledEdit.Text = Str) Then
        SelPos := SelPos - 1;
    LabeledEdit.SelStart := SelPos;

    TryToDelete := 0;
End;

Function CheckMinus(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Key = '-') And (LabeledEdit.SelStart <> 0) Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    CheckMinus := Key;
End;

Function CheckZero(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Length(LabeledEdit.Text) <> 0) And (LabeledEdit.Text[1] = '0') And (Key = '0') Then
        Key := NULL_POINT;

    If (Key = '0') And (LabeledEdit.SelStart = 0) And (Length(LabeledEdit.Text) <> 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (LabeledEdit.SelStart = 1) And (LabeledEdit.Text[1] = '-') Then
        Key := NULL_POINT;

    CheckZero := Key;
End;

Function CheckSelText(LabeledEdit: TLabeledEdit; Key: Char; Const MAX_NUM, MIN_NUM: Integer): Boolean;
Var
    PastStr: String;
    PastSelStart: Integer;
    IsCorrect: Boolean;
Begin
    PastStr := LabeledEdit.Text;
    PastSelStart := LabeledEdit.SelStart;
    LabeledEdit.ClearSelection;

    IsCorrect := TryToAdd(Key, LabeledEdit.Text, LabeledEdit.SelStart, MAX_NUM, MIN_NUM);
    Key := CheckMinus(Key, NULL_POINT, LabeledEdit);
    Key := CheckZero(Key, NULL_POINT, LabeledEdit);

    If Not(IsCorrect) Or (Key = NULL_POINT) Then
    Begin
        LabeledEdit.Text := PastStr;
        LabeledEdit.SelStart := PastSelStart;
    End;

    CheckSelText := IsCorrect;
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

Function CheckСhanges(IntLabEdit: TLabeledEdit): Boolean;
Begin
    Try
        StrToInt(IntLabEdit.Text);

        CheckСhanges := True;
    Except
        CheckСhanges := False;
    End;
End;

Procedure LabelEditChange(ALabeledEdit, NLabeledEdit: TLabeledEdit; BVectorStringGrid, CVectorStringGrid: TStringGrid);
Var
    IsVisible: Boolean;
Begin
    IsVisible := CheckСhanges(ALabeledEdit) And CheckСhanges(NLabeledEdit);
    VectorsVisible(IsVisible);

    If IsVisible Then
    Begin
        ResettingArray(BVectorStringGrid, StrToInt(NLabeledEdit.Text));
        ResettingArray(CVectorStringGrid, StrToInt(NLabeledEdit.Text));
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
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (VectorStringGrid.Cells[Col, Row] = '0') Then
        Key := NULL_POINT;

    If (VectorStringGrid.Cells[Col, Row] <> '') And (VectorStringGrid.Cells[Col, Row] <> '-') And
        (StrToInt(VectorStringGrid.Cells[Col, Row]) = 0) And (Key = '0') Then
        Key := NULL_POINT;

    If (Key = '-') And (VectorStringGrid.Cells[Col, Row] <> '') Then
        Key := NULL_POINT;

    If (Key = '0') And (VectorStringGrid.Cells[Col, Row] = '-') Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (VectorStringGrid.Cells[Col, Row] <> '') And
        Not(TryToAdd(Key, VectorStringGrid.Cells[Col, Row], Length(VectorStringGrid.Cells[Col, Row]), MAX_INT_NUM, MIN_INT_NUM)) Then
        Key := NULL_POINT;

    If ((VectorStringGrid.Cells[Col, Row] <> '') And (VectorStringGrid.Cells[Col, Row][1] = '-')) Or (Key = '-') Then
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

Procedure TryToAddClipboard(ClipboardText: String; Const MaxPoint, MinPoint: Integer; Var LabeledEdit: TLabeledEdit);
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    Try
        If (StrToInt(ClipboardText) > MaxPoint) Or (StrToInt(ClipboardText) < MinPoint) Then
            IsCorrect := False;

        If ClipboardText[1] = ' ' Then
            IsCorrect := False;

        If ClipboardText[Length(ClipBoardText)] = ' ' Then
            IsCorrect := False;
    Except
        IsCorrect := False;
    End;

    If IsCorrect Then
        LabeledEdit.Text := IntToStr(StrToInt(ClipboardText));
End;

Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    Try
        If (StrToInt(ClipboardText) > MAX_INT_NUM) Or (StrToInt(ClipboardText) < MIN_INT_NUM) Then
            IsCorrect := False;

        If ClipboardText[1] = ' ' Then
            IsCorrect := False;

        If ClipboardText[Length(ClipBoardText)] = ' ' Then
            IsCorrect := False;
    Except
        IsCorrect := False;
    End;

    If IsCorrect Then
        StGrid.Cells[Col, Row] := IntToStr(StrToInt(ClipboardText));
End;

End.
