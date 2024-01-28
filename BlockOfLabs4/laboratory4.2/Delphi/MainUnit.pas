Unit MainUnit;

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
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.ExtCtrls;

Type
    TMainForm = Class(TForm)
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        MainMenu: TMainMenu;
        TaskLabel: TLabel;
        FileButton: TMenuItem;
        OpenButton: TMenuItem;
        SaveButton: TMenuItem;
        ExitButton: TMenuItem;
        InstractionButton: TMenuItem;
        AboutEditorButton: TMenuItem;
        DemarcationLine: TMenuItem;
        ALabeledEdit: TLabeledEdit;
        NLabeledEdit: TLabeledEdit;
        ALabel: TLabel;
        NLabel: TLabel;
    BVectorLabel: TLabel;
    CVectorLabel: TLabel;
    ResultButton: TButton;
        Procedure AboutEditorButtonClick(Sender: TObject);
        Procedure InstractionButtonClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure FormCreate(Sender: TObject);
        Procedure ALabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure ALabeledEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure ALabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NLabeledEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure NLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    MIN_INT_NUM = -200_000_000;
    MAX_INT_NUM = +200_000_000;
    MIN_N = 1;
    MAX_N = 20;

Var
    MainForm: TMainForm;

Implementation

{$R *.dfm}

Uses
    AboutEditorUnit,
    InstractionUnit,
    BackendUnit;

Procedure TMainForm.ALabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.ALabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) Or (Key = VK_DELETE) Then
        Key := TryToDelete(Key, ALabeledEdit.Text, ALabeledEdit.SelStart, ALabeledEdit);

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.ALabeledEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_A_LENGTH: Integer = 9;
    NULL_POINT: Char = #0;
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If ((Length(ALabeledEdit.Text) <> 0) And (ALabeledEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If (Length(ALabeledEdit.Text) > 1) And Not(TryToAdd(Key, ALabeledEdit.Text, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM)) Then
        Key := NULL_POINT;

    Key := CheckMinus(Key, NULL_POINT, ALabeledEdit);
    Key := CheckZero(Key, NULL_POINT, ALabeledEdit);

    If (ALabeledEdit.SelText <> '') And (Key <> NULL_POINT) Then
        ALabeledEdit.ClearSelection
    Else
        If Not(Length(ALabeledEdit.Text) < MAX_A_LENGTH + MinCount) Then
            Key := NULL_POINT;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    ALabeledEdit.EditLabel.Caption := '';
    ALabeledEdit.Hint := '[' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + ']';
    NLabeledEdit.EditLabel.Caption := '';
    NLabeledEdit.Hint := '[' + IntToStr(MIN_N) + '; ' + IntToStr(MAX_N) + ']';
End;

Procedure TMainForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If Key = VK_F1 Then
        Instraction.ShowModal;
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.NLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.NLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    TEdit(Sender).ReadOnly := (SsShift In Shift) Or (SsCtrl In Shift);

    If (Key = VK_BACK) Or (Key = VK_DELETE) Then
        Key := TryToDelete(Key, NLabeledEdit.Text, NLabeledEdit.SelStart, NLabeledEdit);

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NLabeledEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_A_LENGTH: Integer = 2;
    NULL_POINT: Char = #0;
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If ((Length(NLabeledEdit.Text) <> 0) And (NLabeledEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If Not(TryToAdd(Key, NLabeledEdit.Text, NLabeledEdit.SelStart, MAX_N, MIN_N)) Then
        Key := NULL_POINT;

    Key := CheckZero(Key, NULL_POINT, NLabeledEdit);

    If (NLabeledEdit.SelText <> '') And (Key <> NULL_POINT) Then
        NLabeledEdit.ClearSelection
    Else
        If Not(Length(NLabeledEdit.Text) < MAX_A_LENGTH + MinCount) Then
            Key := NULL_POINT;
End;

Procedure TMainForm.AboutEditorButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
