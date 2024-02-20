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
    Vcl.ImgList;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Function IsCorrectPointsClipboard(ClipbrdText: String; NumLabEd: TLabeledEdit): Boolean;
Procedure ClearStringGrid();
Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer): Char;
Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function IsCorrectSelTextInputWithKey(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;
Function IsCorrectInput(Key: Char; CurentText: String; SelStart: Integer): Char;

Const
    MIN_POINTS: Integer = -1_000_000_000;
    MAX_POINTS: Integer = +1_000_000_000;
    NULL_POINT: Char = #0;
    ZERO_KEY: Char = '0';
    MINUS_KEY: Char = '-';

Implementation

Uses
    MainFormUnit;

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
        If (CurentText = ZERO_KEY) Then
            Key := NULL_POINT;

        If CurentText <> '' Then
            If (StrToInt(CurentText) > MAX_POINTS) Or (StrToInt(CurentText) < MIN_POINTS) Then
                Key := NULL_POINT;

        If (Length(CurentText) > 0) And (CurentText[1] = ZERO_KEY) Then
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

End.
