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
    Vcl.ExtCtrls,
    Vcl.Grids,
    Clipbrd;

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
        BVectorStringGrid: TStringGrid;
        CVectorStringGrid: TStringGrid;
        ResultButton: TButton;
        ResultLabel: TLabel;
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
        Procedure ALabeledEditChange(Sender: TObject);
        Procedure NLabeledEditChange(Sender: TObject);
        Procedure BVectorStringGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure BVectorStringGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure CVectorStringGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CVectorStringGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure OpenButtonClick(Sender: TObject);
        Procedure SaveButtonClick(Sender: TObject);
    procedure ResultButtonClick(Sender: TObject);
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
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
    MAX_N_LENGTH: Integer = 2;
    MAX_A_LENGTH: Integer = 9;
    MAX_COORD_LENGTH: Integer = 9;
    NULL_POINT: Char = #0;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;

Implementation

{$R *.dfm}

Uses
    AboutEditorUnit,
    InstractionUnit,
    BackendUnit,
    FrontendUnit;

Procedure TMainForm.ALabeledEditChange(Sender: TObject);
Begin
    LabelEditChange(ALabeledEdit, NLabeledEdit, BVectorStringGrid, CVectorStringGrid);
End;

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
Var
    MinCount: Integer;
Begin
    MinCount := 0;

    If (ALabeledEdit.Text = '0') And (ALabeledEdit.SelText = '') And (ALabeledEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (ALabeledEdit.SelText <> '') And Not(CheckSelText(ALabeledEdit, Key, MAX_INT_NUM, MIN_INT_NUM)) Then
        Key := NULL_POINT;

    If ((Length(ALabeledEdit.Text) <> 0) And (ALabeledEdit.Text[1] = '-')) Or (Key = '-') Then
        MinCount := 1;

    If (Length(ALabeledEdit.Text) > 1) And (ALabeledEdit.SelText = '') And
        Not(TryToAdd(Key, ALabeledEdit.Text, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM)) Then
        Key := NULL_POINT;

    Key := CheckMinus(Key, NULL_POINT, ALabeledEdit);
    Key := CheckZero(Key, NULL_POINT, ALabeledEdit);

    If (ALabeledEdit.SelText <> '') And (Key <> NULL_POINT) Then
        ALabeledEdit.ClearSelection
    Else
        If Not(Length(ALabeledEdit.Text) < MAX_A_LENGTH + MinCount) Then
            Key := NULL_POINT;
End;

Procedure TMainForm.BVectorStringGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    StringGridVkBack(Key, BVectorStringGrid);

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    ResultsVisible(VectorStringGridChange(StrToInt(NLabeledEdit.Text)));
End;

Procedure TMainForm.BVectorStringGridKeyPress(Sender: TObject; Var Key: Char);
Var
    Col, Row: Integer;
Begin
    Col := BVectorStringGrid.Col;
    Row := BVectorStringGrid.Row;
    Key := StringGridKeyPress(BVectorStringGrid, Key, Col, Row);

    If (Key <> NULL_POINT) Then
    Begin
        BVectorStringGrid.Cells[Col, Row] := BVectorStringGrid.Cells[Col, Row] + Key;
        ResultsVisible(VectorStringGridChange(StrToInt(NLabeledEdit.Text)));
    End;
End;

Procedure TMainForm.CVectorStringGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    StringGridVkBack(Key, CVectorStringGrid);

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    ResultsVisible(VectorStringGridChange(StrToInt(NLabeledEdit.Text)));
End;

Procedure TMainForm.CVectorStringGridKeyPress(Sender: TObject; Var Key: Char);
Var
    Col, Row: Integer;
Begin
    Col := CVectorStringGrid.Col;
    Row := CVectorStringGrid.Row;
    Key := StringGridKeyPress(CVectorStringGrid, Key, Col, Row);

    If (Key <> NULL_POINT) Then
    Begin
        CVectorStringGrid.Cells[Col, Row] := CVectorStringGrid.Cells[Col, Row] + Key;
        ResultsVisible(VectorStringGridChange(StrToInt(NLabeledEdit.Text)));
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    ALabeledEdit.EditLabel.Caption := '';
    ALabeledEdit.Hint := '[' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + ']';
    NLabeledEdit.EditLabel.Caption := '';
    NLabeledEdit.Hint := '[' + IntToStr(MIN_N) + '; ' + IntToStr(MAX_N) + ']';

    BVectorStringGrid.Hint := '[' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + ']';
    CVectorStringGrid.Hint := '[' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + ']';

    ResultLabel.Caption := '';
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

Procedure TMainForm.NLabeledEditChange(Sender: TObject);
Begin
    LabelEditChange(ALabeledEdit, NLabeledEdit, BVectorStringGrid, CVectorStringGrid);
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
Begin
    If (NLabeledEdit.SelText <> '') And Not(CheckSelText(NLabeledEdit, Key, MAX_N, MIN_N)) Then
        Key := NULL_POINT;

    If (ALabeledEdit.SelText = '') And Not(TryToAdd(Key, NLabeledEdit.Text, NLabeledEdit.SelStart, MAX_N, MIN_N)) Then
        Key := NULL_POINT;

    Key := CheckZero(Key, NULL_POINT, NLabeledEdit);

    If (NLabeledEdit.SelText <> '') And (Key <> NULL_POINT) Then
        NLabeledEdit.ClearSelection
    Else
        If Not(Length(NLabeledEdit.Text) < MAX_A_LENGTH) Then
            Key := NULL_POINT;
End;

Procedure TMainForm.OpenButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsReadable(OpenDialog.FileName);
            ReadFromFile(IsCorrect, OpenDialog.FileName);
            If Not IsCorrect Then
                MessageBox(0, 'Невозможен ввод из файл!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

procedure TMainForm.ResultButtonClick(Sender: TObject);
begin
    //ResultLabel.Caption := CreateResultMessage();
end;

Procedure TMainForm.SaveButtonClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If SaveDialog.Execute Then
        Begin
            IsCorrect := IsWriteable(SaveDialog.FileName);
            InputInFile(IsCorrect, SaveDialog.FileName);
            If Not IsCorrect Then
                MessageBox(0, 'Невозможна запись в файл!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TMainForm.AboutEditorButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
