Unit MainUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    System.ImageList,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Menus,
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.ExtCtrls,
    Vcl.Grids,
    Vcl.ImgList,
    Clipbrd;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

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
        MainMenuImageList: TImageList;
        Procedure AboutEditorButtonClick(Sender: TObject);
        Procedure InstractionButtonClick(Sender: TObject);
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
        Procedure ResultButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitButtonClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
    Private
        Procedure WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
    Public
        { Public declarations }
    End;

Const
    MAIN_CASE = ['0' .. '9', #08, #$16, '-'];
    N_MAIN_CASE = ['0' .. '9', #08, #$16];
    SERVICE_CASE = [#08, #$16];
    STRGRID_CASE = ['0' .. '9', '-'];
    DELETE_KEY: Char = #127;
    BACKSPACE_KEY: Char = #08;
    NULL_POINT: Char = #0;
    ZERO_KEY: Char = '0';
    MINUS_KEY: Char = '-';
    MIN_INT_NUM = -20_000_000;
    MAX_INT_NUM = +20_000_000;
    MIN_N = 1;
    MAX_N = 13;
    MAX_COORD_LENGTH: Integer = 9;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    ResultString: String = #0;

Implementation

{$R *.dfm}

Uses
    AboutEditorUnit,
    InstractionUnit,
    BackendUnit,
    FrontendUnit;

Procedure TMainForm.ALabeledEditChange(Sender: TObject);
Begin
    LabelEditChange(ALabeledEdit.Text, NLabeledEdit.Text, BVectorStringGrid, CVectorStringGrid);
End;

Procedure TMainForm.ALabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.ALabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (ALabeledEdit.SelText = '') Then
    Begin
        CurKey := IsCorrectDelete(DELETE_KEY, ALabeledEdit.Text, ALabeledEdit.SelStart + 1, MAX_INT_NUM, MIN_INT_NUM);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (ALabeledEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(DELETE_KEY, ALabeledEdit.Text, ALabeledEdit.SelText, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.ALabeledEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = #$16) Then
        Key := NULL_POINT;

    If Not CharInSet(Key, MAIN_CASE) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 0) And (ALabeledEdit.Text[1] = MINUS_KEY) And (ALabeledEdit.SelStart = 0) And
        CharInSet(Key, STRGRID_CASE) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 0) And (ALabeledEdit.Text[1] = ZERO_KEY) And (ALabeledEdit.SelStart = 0) And (Key = MINUS_KEY) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 0) And (ALabeledEdit.Text[1] = MINUS_KEY) And (ALabeledEdit.SelStart = 1) And (Key = ZERO_KEY) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 0) And (ALabeledEdit.Text[1] = MINUS_KEY) And (Key = MINUS_KEY) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 0) And (ALabeledEdit.SelStart = 0) And (Key = ZERO_KEY) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 1) And (ALabeledEdit.Text = MINUS_KEY) And (ALabeledEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 1) And (ALabeledEdit.Text[1] = MINUS_KEY) And (Key = ZERO_KEY) And (ALabeledEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (ALabeledEdit.Text = ZERO_KEY) And (ALabeledEdit.SelStart = 1) Then
        Key := NULL_POINT;

    If (Length(ALabeledEdit.Text) > 2) And Not CharInSet(Key, SERVICE_CASE) And (ALabeledEdit.SelText = '') Then
        Key := IsCorrectAddInNum(Key, ALabeledEdit.Text, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM);

    If (Key = BACKSPACE_KEY) And (ALabeledEdit.SelText = '') Then
        Key := IsCorrectDelete(Key, ALabeledEdit.Text, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM);

    If (Key = BACKSPACE_KEY) And (ALabeledEdit.SelText <> '') Then
        Key := IsCorrectSelDelete(Key, ALabeledEdit.Text, ALabeledEdit.SelText, ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM);
End;

Procedure TMainForm.BVectorStringGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    StringGridVkBack(Key, BVectorStringGrid);

    If ((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT)) Then
        StGridAddClipboard(Clipboard.AsText, BVectorStringGrid, BVectorStringGrid.Col, BVectorStringGrid.Row);

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

    If ((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT)) Then
        StGridAddClipboard(Clipboard.AsText, CVectorStringGrid, CVectorStringGrid.Col, CVectorStringGrid.Row);

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

Procedure TMainForm.ExitButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;

    If ResultLabel.Visible And (ResultKey = ID_YES) And Not IfDataSavedInFile Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
            SaveButtonClick(Sender);
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

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TInstraction, Instraction);
    Instraction.ShowModal;
End;

Procedure TMainForm.NLabeledEditChange(Sender: TObject);
Begin
    LabelEditChange(ALabeledEdit.Text, NLabeledEdit.Text, BVectorStringGrid, CVectorStringGrid);
End;

Procedure TMainForm.NLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.NLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (NLabeledEdit.SelText = '') Then
    Begin

        CurKey := IsCorrectDelete(DELETE_KEY, NLabeledEdit.Text, NLabeledEdit.SelStart + 1, MAX_INT_NUM, MIN_INT_NUM, 'N');

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (NLabeledEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(DELETE_KEY, NLabeledEdit.Text, NLabeledEdit.SelText, NLabeledEdit.SelStart, MAX_INT_NUM,
            MIN_INT_NUM, 'N');

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NLabeledEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_SECOND_VALUE = ['0' .. '3'];
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = #$16) Then
        Key := NULL_POINT;

    If (NLabeledEdit.SelText <> '') And Not CharInSet(Key, SERVICE_CASE) Then
        Key := IsCorrectSelTextInputWithKey(Key, NLabeledEdit.Text, NLabeledEdit.SelText, NLabeledEdit.SelStart, MAX_N, MIN_N);

    If Not CharInSet(Key, N_MAIN_CASE) Then
        Key := NULL_POINT;

    If (Length(NLabeledEdit.Text) <> 0) And (NLabeledEdit.SelStart = 0) And (NLabeledEdit.SelText = '') And (Key = '1') And
        Not CharInSet(NLabeledEdit.Text[1], GOOD_SECOND_VALUE) Then
        Key := NULL_POINT;

    If (NLabeledEdit.Text = '1') And Not(CharInSet(Key, GOOD_SECOND_VALUE) Or CharInSet(Key, SERVICE_CASE)) And
        (NLabeledEdit.SelText = '') Then
        Key := NULL_POINT;

    If (NLabeledEdit.Text <> '1') And (NLabeledEdit.SelStart = 1) And (Length(NLabeledEdit.Text) <> 0) And (Key <> BACKSPACE_KEY) And
        (NLabeledEdit.SelText = '') Then
        Key := NULL_POINT;

    If (NLabeledEdit.Text = '') And (Key = ZERO_KEY) And (NLabeledEdit.SelText = '') Then
        Key := NUll_POINT;

    If (NLabeledEdit.Text <> '') And (NLabeledEdit.SelStart = 0) And Not(CharInSet(Key, SERVICE_CASE) Or (Key = '1')) And
        (NLabeledEdit.SelText = '') Then
        Key := NULL_POINT;

    If (Key = BACKSPACE_KEY) And (NLabeledEdit.SelText = '') Then
        Key := IsCorrectDelete(Key, NLabeledEdit.Text, NLabeledEdit.SelStart, MAX_N, MIN_N);

    If (Key = BACKSPACE_KEY) And (NLabeledEdit.SelText <> '') Then
        Key := IsCorrectSelDelete(Key, NLabeledEdit.Text, NLabeledEdit.SelText, NLabeledEdit.SelStart, MAX_N, MIN_N);
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
                MessageBox(0, 'Невозможен ввод из файла!', 'Ошибка', MB_ICONERROR);
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TMainForm.ResultButtonClick(Sender: TObject);
Var
    ACount, NSize: Integer;
    BVector, CVector: TMassive;
    Sums: TMatrix;
    ISubset: TByteSet;
Begin
    SetLength(Sums, 0, 0);
    ISubset := [];

    ACount := StrToInt(ALabeledEdit.Text);
    NSize := StrToInt(NLabeledEdit.Text);
    InputVectorFromGrid(BVector, BVectorStringGrid, NSize);
    InputVectorFromGrid(CVector, CVectorStringGrid, NSize);

    TreatmentData(BVector, CVector, ACount, NSize, Sums, ISubset);

    ResultLabel.Caption := CreateResultString(ACount, NSize, BVector, CVector, ISubset);
    ResultLabel.Visible := True;
    SaveButton.Enabled := True;
End;

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
    Application.CreateForm(TAboutEditor, AboutEditor);
    AboutEditor.ShowModal;
End;

Procedure TMainForm.WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
Begin
    Msg.MinMaxInfo.PtMaxSize.X := Width;
    Msg.MinMaxInfo.PtMaxSize.Y := Height;
    Msg.MinMaxInfo.PtMaxTrackSize.X := Width;
    Msg.MinMaxInfo.PtMaxTrackSize.Y := Height;

    Left := (Screen.Width - Width) Div 2;
    Top := (Screen.Height - Height) Div 2;
End;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (MainForm.ActiveControl = MainForm.ALabeledEdit) And Not IsCorrectNumClipboard(Clipboard.AsText,
                MainForm.ALabeledEdit.SelStart, MAX_INT_NUM, MIN_INT_NUM) Then
                Raise Exception.Create('A Clipboard Error!');

            If (MainForm.ActiveControl = MainForm.NLabeledEdit) And Not IsCorrectNumClipboard(Clipboard.AsText,
                MainForm.NLabeledEdit.SelStart, MAX_N, MIN_N) Then
                Raise Exception.Create('N Clipboard Error!');
        Except
            Exit;
        End;
    End;
    Inherited;
End;

End.
