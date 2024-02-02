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

Const
    MAX_STR_LENGTH: Integer = 20;

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
Const
    MIN_POINTS: Integer = 0;
    MAX_POINTS: Integer = 100;
Var
    Cursor: Integer;
    WorkStr: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    PointsLabeledEdit.ClearSelection;
    Cursor := PointsLabeledEdit.SelStart;
    WorkStr := PointsLabeledEdit.Text;
    Insert(ClipbrdText, WorkStr, Cursor);

    Try
        If (StrToInt(WorkStr) > MAX_POINTS) Or (StrToInt(WorkStr) < MIN_POINTS) Then
            IsCorrect := False;
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
    IsCorrect := True;
    LabeledEdit.ClearSelection;
    Cursor := LabeledEdit.SelStart;
    WorkStr := LabeledEdit.Text;
    Insert(ClipbrdText, WorkStr, Cursor);

    Try
        If Length(WorkStr) > MAX_STR_LENGTH Then
            IsCorrect := False;
    Except
        IsCorrect := False;
    End;

    IsCorrectStrings := IsCorrect;
End;

Function IsVisibleAddOnChange(CountryLEdit, CoachLEdit, PointsLEdit, TeamNameLEdit: TLabeledEdit): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Try
        IsCorrect := (CountryLEdit.Text <> '') And (CoachLEdit.Text <> '') And (PointsLEdit.Text <> '') And (TeamNameLEdit.Text <> '');
    Except
        IsCorrect := False;
    End;

    IsVisibleAddOnChange := IsCorrect;
End;

End.
