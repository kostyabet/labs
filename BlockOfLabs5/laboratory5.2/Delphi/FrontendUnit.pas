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
    Vcl.Menus,
    System.ImageList,
    Vcl.ImgList,
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.ExtCtrls,
    Vcl.Buttons;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);    
Function IsCorrectClipboard(ClipbrdText: String; NumLabEd: Vcl.ExtCtrls.TLabeledEdit): Boolean;
Function CheckInput(Text: String): Boolean;
Function CheckInputKey(LEdit: Vcl.ExtCtrls.TLabeledEdit; Key: Char): Char;
Function IsCorrectDelete(Key: Char; CurentText: String; SelStart: Integer): Char;
Function IsCorrectSelDelete(Key: Char; CurentText, SelText: String; SelStart: Integer): Char;

Implementation

uses MainFormUnit;

Const
    ZERO_KEY: Char = '0';
    NULL_POINT: Char = #0;
    DELETE_KEY: Char = #127;
    BACK_SPACE: Char = #08;
    MINUS_KEY: Char = '-';
    MAX_INT: Integer = +1_000_000;
    MIN_INT: Integer = -1_000_000;

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

Function IsCorrectClipboard(ClipbrdText: String; NumLabEd: Vcl.ExtCtrls.TLabeledEdit): Boolean;
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
        IsCorrect := Not((StrToInt(WorkStr) > MAX_INT) Or (StrToInt(WorkStr) < MIN_INT));

        IsCorrect := IsCorrect And (Length(WorkStr) > 1) And (WorkStr[1] = ZERO_KEY);
    Except
        IsCorrect := False;
    End;

    IsCorrectClipboard := IsCorrect;
End;

Function CheckInput(Text: String): Boolean;
Begin
    Try
        StrToInt(Text);

        CheckInput := True;
    Except
        CheckInput := False;
    End;
End;

Function CheckKeyCondition(CurentText: String; Key: Char): Char;
Begin
    Try
        If (CurentText <> '') And (CurentText <> '-') Then
            If (StrToInt(CurentText) > MAX_INT) Or (StrToInt(CurentText) < MIN_INT) Then
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

Function CheckInputKey(LEdit: Vcl.ExtCtrls.TLabeledEdit; Key: Char): Char;
Const
    GOOD_VALUES = ['0' .. '9', #08, #$16, '-'];
    NUMB_VAL = ['0' .. '9', '-'];
    REF_NUM: String = '10';
Begin
    If Not CharInSet(Key, GOOD_VALUES) Then
        Key := NULL_POINT;

    If (LEdit.SelText <> '') Then
        Key := IsCorrectSelTextInputWithKey(Key, LEdit.Text, LEdit.SelText, LEdit.SelStart);
    If (LEdit.SelText = '') And (LEdit.Text <> '') And CharInSet(Key, NUMB_VAL) Then
        Key := IsCorrectInput(Key, LEdit.Text, LEdit.SelStart);

    If (Key = BACK_SPACE) And (LEdit.SelText = '') Then
        Key := IsCorrectDelete(Key, LEdit.Text, LEdit.SelStart);

    If (Key = BACK_SPACE) And (LEdit.SelText <> '') Then
        Key := IsCorrectSelDelete(Key, LEdit.Text, LEdit.SelText, LEdit.SelStart);

    CheckInputKey := Key;
End;

End.
