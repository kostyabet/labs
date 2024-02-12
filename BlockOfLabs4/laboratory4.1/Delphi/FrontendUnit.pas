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
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Imaging.Jpeg,
    Vcl.Imaging.Pngimage,
    System.ImageList,
    Vcl.ImgList,
    Vcl.BaseImageCollection,
    Vcl.ImageCollection,
    Vcl.Menus,
    Vcl.Grids;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Function IsCorrectPointsClipboard(ClipbrdText: String; PointsLabeledEdit: TLabeledEdit): Boolean;
Function IsCorrectStrings(ClipbrdText: String; LabeledEdit: TLabeledEdit): Boolean;
Function IsVisibleAddOnChange(CountryLEdit, CoachLEdit, PointsLEdit, TeamNameLEdit: TLabeledEdit): Boolean;
Procedure InputInCurentRow(I: Integer; Country, Team, Coach: String; Points: Integer);
Function CheckKeyCondition(CurentText: String; Key: Char): Char;
Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer): Char;
Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function CheckInput(Key: Char; PointsLabeledEdit: TLabeledEdit): Char;

Const
    MAX_STR_LENGTH: Integer = 20;
    MIN_POINTS: Integer = 0;
    MAX_POINTS: Integer = 100;

Implementation

Uses
    MainFormUnit,
    BackendUnit;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
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
        ModalLabel.Left := 10;
        ModalLabel.Top := 5;

        ModalForm.ShowModal;
    Finally
        ModalForm.Free;
    End;
End;

Function IsCorrectPointsClipboard(ClipbrdText: String; PointsLabeledEdit: TLabeledEdit): Boolean;
Var
    Cursor: Integer;
    WorkStr, BufStr: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    PointsLabeledEdit.ClearSelection;
    Cursor := PointsLabeledEdit.SelStart;
    WorkStr := PointsLabeledEdit.Text;
    Insert(ClipbrdText, WorkStr, Cursor);

    Try
        IsCorrect := Not((StrToInt(WorkStr) > MAX_POINTS) Or (StrToInt(WorkStr) < MIN_POINTS));

        IsCorrect := IsCorrect And (Length(WorkStr) > 1) And (WorkStr[1] = '0');
    Except
        IsCorrect := False;
    End;

    IsCorrectPointsClipboard := IsCorrect;
End;

Function IsCorrectStrings(ClipbrdText: String; LabeledEdit: TLabeledEdit): Boolean;
Var
    Cursor: Integer;
    WorkStr: String;
    IsCorrect: Boolean;
Begin
    LabeledEdit.ClearSelection;
    Cursor := LabeledEdit.SelStart;
    WorkStr := LabeledEdit.Text;
    Insert(ClipbrdText, WorkStr, Cursor);

    Try
        IsCorrect := Not(Length(WorkStr) > MAX_STR_LENGTH);
    Except
        IsCorrect := False;
    End;

    IsCorrectStrings := IsCorrect;
End;

Function IsVisibleAddOnChange(CountryLEdit, CoachLEdit, PointsLEdit, TeamNameLEdit: TLabeledEdit): Boolean;
Var
    IsCorrect: Boolean;
Begin
    Try
        IsCorrect := (CountryLEdit.Text <> '') And (CoachLEdit.Text <> '') And (PointsLEdit.Text <> '') And (TeamNameLEdit.Text <> '');
    Except
        IsCorrect := False;
    End;

    IsVisibleAddOnChange := IsCorrect;
End;

Procedure InputInCurentRow(I: Integer; Country, Team, Coach: String; Points: Integer);
Begin
    MainForm.PointTabelStrGrid.Cells[0, I] := IntToStr(I);
    MainForm.PointTabelStrGrid.Cells[1, I] := Country;
    MainForm.PointTabelStrGrid.Cells[2, I] := Team;
    MainForm.PointTabelStrGrid.Cells[3, I] := Coach;
    MainForm.PointTabelStrGrid.Cells[4, I] := IntToStr(Points);
End;

Function CheckKeyCondition(CurentText: String; Key: Char): Char;
Begin
    Try
        If CurentText <> '' Then
            If (StrToInt(CurentText) > MAX_POINTS) Or (StrToInt(CurentText) < MIN_POINTS) Then
                Key := #0;

        If (Length(CurentText) > 0) And (CurentText[1] = '0') Then
            Key := #0;

        If (Length(CurentText) > 1) And (CurentText[1] = '-') And (CurentText[2] = '0') Then
            Key := #0;
    Except
        Key := #0;
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

Function CheckInput(Key: Char; PointsLabeledEdit: TLabeledEdit): Char;
Const
    GOOD_VALUES = ['0' .. '9', #08, #$16];
Begin
    If Not CharInSet(Key, GOOD_VALUES) Then
        Key := #0;

    If (PointsLabeledEdit.SelText <> '') Then
        Key := IsCorrectSelTextInputWithKey(Key, PointsLabeledEdit.Text, PointsLabeledEdit.SelText, PointsLabeledEdit.SelStart);

    If (PointsLabeledEdit.Text = '10') And ((Key <> '0') And (Key <> #08)) Then
        Key := #0;

    If (Length(PointsLabeledEdit.Text) = PointsLabeledEdit.MaxLength - 1) And (PointsLabeledEdit.Text <> '10') And (Key <> #08) Then
        Key := #0;

    If (Length(PointsLabeledEdit.Text) > 0) And (PointsLabeledEdit.Text[1] = '0') And (PointsLabeledEdit.SelStart = 0) And (Key = '0') Then
        Key := #0;

    If (PointsLabeledEdit.Text = '0') And (Key <> #08) And (PointsLabeledEdit.SelStart = 1) Then
        Key := #0;

    If (Key = #08) And (PointsLabeledEdit.SelText = '') Then
        Key := IsCorrectDelete(Key, PointsLabeledEdit.Text, PointsLabeledEdit.SelStart);

    If (Key = #08) And (PointsLabeledEdit.SelText <> '') Then
        Key := IsCorrectSelDelete(Key, PointsLabeledEdit.Text, PointsLabeledEdit.SelText, PointsLabeledEdit.SelStart);

    CheckInput := Key;
End;

End.
