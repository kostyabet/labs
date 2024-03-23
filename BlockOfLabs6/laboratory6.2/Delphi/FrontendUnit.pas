Unit FrontendUnit;

Interface

Uses
    Winapi.Windows,
    System.SysUtils,
    Vcl.Grids,
    Vcl.ExtCtrls;

Function ChangeMNControl(M, N: String): Boolean;
Function CheckKey(Key: Char; LEditText: String; Const MIN, MAX: Integer): Char;
Procedure ChangeVisible(InputElements: Boolean);
Procedure ClearElAndPoints();
Procedure ChangeHint(M, N: String);
Procedure ChangeMassiveStGridSize(MassiveStGrid: TStringGrid; M, N: Integer);
Procedure StringGridVkBack(Key: Word; Var VectorStringGrid: TStringGrid);
Function StringGridKeyPress(Var VectorStringGrid: TStringGrid; Key: Char; Col, Row: Integer): Char;
Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);
Function IsAllInput(MassiveStGrid: TStringGrid; IStart, JStart, IEnd, JEnd: String): Boolean;
Function IsCorrectClipboard(ClipbrdText: String; NumLabEd: Vcl.ExtCtrls.TLabeledEdit; MAX, MIN: Integer): Boolean;

Implementation

Uses
    MainUnit;

Function ChangeMNControl(M, N: String): Boolean;
Begin
    Try
        StrToInt(M);
        StrToInt(N);

        ChangeMNControl := True;
    Except
        ChangeMNControl := False;
    End;
End;

Function CheckKey(Key: Char; LEditText: String; Const MIN, MAX: Integer): Char;
Const
    NULL_POINT: Char = #00;
    BACK_SPACE: Char = #08;
    GOOD_KEYS = ['0' .. '9', #08, #$16];
Begin
    If Not CharInSet(Key, GOOD_KEYS) Then
        Key := #0;

    If (Key <> #08) And (Key <> #0) And (Key <> #$16) And ((StrToInt(Key) > MAX) Or (StrToInt(Key) < MIN)) Then
        Key := #0;

    CheckKey := Key;
End;

Procedure ChangeVisible(InputElements: Boolean);
Begin
    MainForm.MassiveStGrid.Visible := InputElements;

    MainForm.StartPointLabel.Visible := InputElements;
    MainForm.IStartPointLEdit.Visible := InputElements;
    MainForm.JStartPointLEdit.Visible := InputElements;

    MainForm.EndPointLabel.Visible := InputElements;
    MainForm.IEndPointLEdit.Visible := InputElements;
    MainForm.JEndPointLEdit.Visible := InputElements;

    MainForm.ResultSpButton.Visible := InputElements;
End;

Procedure ClearElAndPoints();
Var
    I, J: Integer;
Begin
    MainForm.IStartPointLEdit.Text := '';
    MainForm.JStartPointLEdit.Text := '';
    MainForm.IEndPointLEdit.Text := '';
    MainForm.JEndPointLEdit.Text := '';

    For I := 0 To MainForm.MassiveStGrid.ColCount - 1 Do
        For J := 0 To MainForm.MassiveStGrid.RowCount - 1 Do
            MainForm.MassiveStGrid.Cells[I, J] := '';
End;

Procedure ChangeHint(M, N: String);
Begin
    MainForm.IStartPointLEdit.Hint := '[1; ' + M + ']';
    MainForm.JStartPointLEdit.Hint := '[1; ' + N + ']';
    MainForm.IEndPointLEdit.Hint := '[1; ' + M + ']';
    MainForm.JEndPointLEdit.Hint := '[1; ' + N + ']';
End;

Procedure ChangeMassiveStGridSize(MassiveStGrid: TStringGrid; M, N: Integer);
Var
    GrowthRow, GrowthCol: Integer;
Begin
    MassiveStGrid.RowCount := M;
    GrowthRow := M + 3;
    MassiveStGrid.Height := MassiveStGrid.DefaultRowHeight * M + GrowthRow;
    MassiveStGrid.ColCount := N;
    GrowthCol := N + 3;
    MassiveStGrid.Width := MassiveStGrid.DefaultColWidth * N + GrowthCol;
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
        Not(TryToAdd(Key, VectorStringGrid.Cells[Col, Row], Length(VectorStringGrid.Cells[Col, Row]), MAX_INT, MIN_INT)) Then
        Key := NULL_POINT;

    If ((VectorStringGrid.Cells[Col, Row] <> '') And (VectorStringGrid.Cells[Col, Row][1] = MINUS_KEY)) Or (Key = MINUS_KEY) Then
        MinCount := 1;

    If Length(VectorStringGrid.Cells[Col, Row]) = MAX_COORD_LENGTH + MinCount Then
        Key := NULL_POINT;

    StringGridKeyPress := Key;
End;

Procedure StGridAddClipboard(ClipBoardText: String; Var StGrid: TStringGrid; Const Col, Row: Integer);
Var
    IsCorrect: Boolean;
Begin
    ClipBoardText := Trim(ClipBoardText);
    Try
        IsCorrect := Not((StrToInt(ClipboardText) > MAX_INT) Or (StrToInt(ClipboardText) < MIN_INT));
    Except
        IsCorrect := False;
    End;

    If IsCorrect Then
        StGrid.Cells[Col, Row] := IntToStr(StrToInt(ClipboardText));
End;

Function IsAllInput(MassiveStGrid: TStringGrid; IStart, JStart, IEnd, JEnd: String): Boolean;
Var
    I, J: Integer;
Begin
    Try
        StrToInt(IStart);
        StrToInt(JStart);
        StrToInt(IEnd);
        StrToInt(JEnd);

        For I := 0 To MainForm.MassiveStGrid.ColCount - 1 Do
            For J := 0 To MainForm.MassiveStGrid.RowCount - 1 Do
                StrToInt(MainForm.MassiveStGrid.Cells[I, J]);

        IsAllInput := True;
    Except
        IsAllInput := False;
    End;
End;

Function IsCorrectClipboard(ClipbrdText: String; NumLabEd: Vcl.ExtCtrls.TLabeledEdit; MAX, MIN: Integer): Boolean;
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
        IsCorrect := Not((StrToInt(WorkStr) > MAX) Or (StrToInt(WorkStr) < MIN));

        IsCorrect := IsCorrect And (Length(WorkStr) > 1) And (WorkStr[1] = ZERO_KEY);
    Except
        IsCorrect := False;
    End;

    IsCorrectClipboard := IsCorrect;
End;

End.
