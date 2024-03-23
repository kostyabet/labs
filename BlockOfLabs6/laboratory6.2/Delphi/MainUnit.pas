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
    Vcl.Buttons,
    Vcl.Grids,
    Clipbrd;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TMainForm = Class(TForm)
        MainMenu: TMainMenu;
        FileBox: TMenuItem;
        OpenFromFile: TMenuItem;
        SaveInFile: TMenuItem;
        Line: TMenuItem;
        CloseButton: TMenuItem;
        Instraction: TMenuItem;
        AboutEditor: TMenuItem;
        TaskLabel: TLabel;
        MatrixSizeLabel: TLabel;
        MRowsLEdit: TLabeledEdit;
        NColsLEdit: TLabeledEdit;
        MassiveStGrid: TStringGrid;
        IStartPointLEdit: TLabeledEdit;
        JStartPointLEdit: TLabeledEdit;
        StartPointLabel: TLabel;
        IEndPointLEdit: TLabeledEdit;
        JEndPointLEdit: TLabeledEdit;
        EndPointLabel: TLabel;
        InputElemButton: TButton;
        ResultSpButton: TButton;
        ViewWayButton: TButton;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        Procedure FormCreate(Sender: TObject);
        Procedure MRowsLEditChange(Sender: TObject);
        Procedure NColsLEditChange(Sender: TObject);
        Procedure MRowsLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure NColsLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure MRowsLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NColsLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure InputElemButtonClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
        Procedure IStartPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure JStartPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure IEndPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure JEndPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure IStartPointLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure JStartPointLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure JEndPointLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure IEndPointLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure MRowsLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NColsLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure IStartPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure JStartPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure JEndPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure IEndPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure MassiveStGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure MassiveStGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure IStartPointLEditChange(Sender: TObject);
        Procedure IEndPointLEditChange(Sender: TObject);
        Procedure JStartPointLEditChange(Sender: TObject);
        Procedure JEndPointLEditChange(Sender: TObject);
        Procedure MassiveStGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure ResultSpButtonClick(Sender: TObject);
        Procedure ViewWayButtonClick(Sender: TObject);
        Procedure OpenFromFileClick(Sender: TObject);
        Procedure SaveInFileClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Private
        Procedure WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
    Public
        { Public declarations }
    End;

Const
    MIN_SIZE: Integer = 1;
    MAX_SIZE: Integer = 6;
    MIN_INT: Integer = -1_000_000;
    MAX_INT: Integer = +1_000_000;
    STRGRID_CASE = ['0' .. '9', '-'];
    NULL_POINT: Char = #0;
    ZERO_KEY: Char = '0';
    MINUS_KEY: Char = '-';

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    BackendUnit,
    ResMatrixUnit;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;

    If (ResultKey = ID_YES) And Not IfDataSavedInFile And ViewWayButton.Enabled Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
            SaveInFileClick(Sender);
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    MRowsLEdit.EditLabel.Caption := '';
    NColsLEdit.EditLabel.Caption := '';
    IStartPointLEdit.EditLabel.Caption := '';
    JStartPointLEdit.EditLabel.Caption := '';
    IEndPointLEdit.EditLabel.Caption := '';
    JEndPointLEdit.EditLabel.Caption := '';

    MRowsLEdit.Hint := '[' + IntToStr(MIN_SIZE) + '; ' + IntToStr(MAX_SIZE) + ']';
    NColsLEdit.Hint := '[' + IntToStr(MIN_SIZE) + '; ' + IntToStr(MAX_SIZE) + ']';
End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;

Procedure TMainForm.IEndPointLEditChange(Sender: TObject);
Begin
    ResultSpButton.Enabled := IsAllInput(MassiveStGrid, IStartPointLEdit.Text, JStartPointLEdit.Text, IEndPointLEdit.Text,
        JEndPointLEdit.Text);
End;

Procedure TMainForm.IEndPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.IEndPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.IEndPointLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, 1, StrToInt(MRowsLEdit.Text));
End;

Procedure TMainForm.InputElemButtonClick(Sender: TObject);
Begin
    ChangeMassiveStGridSize(MassiveStGrid, StrToInt(MRowsLEdit.Text), StrToInt(NColsLEdit.Text));
    MassiveStGrid.ColCount := StrToInt(NColsLEdit.Text);
    ClearElAndPoints();
    ChangeHint(MRowsLEdit.Text, NColsLEdit.Text);
    ChangeVisible(True);
End;

Procedure TMainForm.IStartPointLEditChange(Sender: TObject);
Begin
    ResultSpButton.Enabled := IsAllInput(MassiveStGrid, IStartPointLEdit.Text, JStartPointLEdit.Text, IEndPointLEdit.Text,
        JEndPointLEdit.Text);
End;

Procedure TMainForm.IStartPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.IStartPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.IStartPointLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, 1, StrToInt(MRowsLEdit.Text));
End;

Procedure TMainForm.JEndPointLEditChange(Sender: TObject);
Begin
    ResultSpButton.Enabled := IsAllInput(MassiveStGrid, IStartPointLEdit.Text, JStartPointLEdit.Text, IEndPointLEdit.Text,
        JEndPointLEdit.Text);
End;

Procedure TMainForm.JEndPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.JEndPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.JEndPointLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, 1, StrToInt(NColsLEdit.Text));
End;

Procedure TMainForm.JStartPointLEditChange(Sender: TObject);
Begin
    ResultSpButton.Enabled := IsAllInput(MassiveStGrid, IStartPointLEdit.Text, JStartPointLEdit.Text, IEndPointLEdit.Text,
        JEndPointLEdit.Text);
End;

Procedure TMainForm.JStartPointLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.JStartPointLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.JStartPointLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, 1, StrToInt(NColsLEdit.Text));
End;

Procedure TMainForm.MassiveStGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    StringGridVkBack(Key, MassiveStGrid);

    If ((Shift = [SsCtrl]) And (Key = Ord('V'))) Or ((Shift = [SsShift]) And (Key = VK_INSERT)) Then
        StGridAddClipboard(MassiveStGrid.Cells[MassiveStGrid.Col, MassiveStGrid.Row] + Clipboard.AsText, MassiveStGrid, MassiveStGrid.Col,
            MassiveStGrid.Row);

    If (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);
End;

Procedure TMainForm.MassiveStGridKeyPress(Sender: TObject; Var Key: Char);
Const
    NULL_POINT: Char = #0;
Var
    Col, Row: Integer;
Begin
    Col := MassiveStGrid.Col;
    Row := MassiveStGrid.Row;
    Key := StringGridKeyPress(MassiveStGrid, Key, Col, Row);

    If (Key <> NULL_POINT) Then
        MassiveStGrid.Cells[Col, Row] := MassiveStGrid.Cells[Col, Row] + Key;
End;

Procedure TMainForm.MassiveStGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    ResultSpButton.Enabled := IsAllInput(MassiveStGrid, IStartPointLEdit.Text, JStartPointLEdit.Text, IEndPointLEdit.Text,
        JEndPointLEdit.Text);
End;

Procedure TMainForm.MRowsLEditChange(Sender: TObject);
Begin
    InputElemButton.Enabled := ChangeMNControl(MRowsLEdit.Text, NColsLEdit.Text);
    ChangeVisible(False);
End;

Procedure TMainForm.MRowsLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.MRowsLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.MRowsLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, MIN_SIZE, MAX_SIZE);
End;

Procedure TMainForm.NColsLEditChange(Sender: TObject);
Begin
    InputElemButton.Enabled := ChangeMNControl(MRowsLEdit.Text, NColsLEdit.Text);
    ChangeVisible(False);
End;

Procedure TMainForm.NColsLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TMainForm.NColsLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NColsLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckKey(Key, MRowsLEdit.Text, MIN_SIZE, MAX_SIZE);
End;

Procedure TMainForm.OpenFromFileClick(Sender: TObject);
Var
    IsCorrect: Boolean;
Begin
    Repeat
        If OpenDialog.Execute() Then
        Begin
            IsCorrect := IsReadable(OpenDialog.FileName);
            ReadFromFile(IsCorrect, OpenDialog.FileName);
            If Not IsCorrect Then
                MessageBox(0, 'Невозможен ввод из файла!', 'Ошибка', MB_ICONERROR)
        End
        Else
            IsCorrect := True;
    Until IsCorrect;
End;

Procedure TMainForm.ResultSpButtonClick(Sender: TObject);
Var
    Matrix: TMatrix;
    ResWayCoords: TResCoords;
    I, J, I1, J1, I2, J2: Integer;
Begin
    SetLength(Matrix, StrToInt(MRowsLEdit.Text));
    For I := 0 To StrToInt(MRowsLEdit.Text) - 1 Do
    Begin
        SetLength(Matrix[I], StrToInt(NColsLEdit.Text));
        For J := 0 To StrToInt(NColsLEdit.Text) - 1 Do
            Matrix[I][J] := StrToInt(MassiveStGrid.Cells[I, J]);
    End;

    I1 := StrToInt(IStartPointLEdit.Text) - 1;
    J1 := StrToInt(JStartPointLEdit.Text) - 1;
    I2 := StrToInt(IEndPointLEdit.Text) - 1;
    J2 := StrToInt(JEndPointLEdit.Text) - 1;

    SearchLongestWay(Matrix, I1, J1, I2, J2, ResWayCoords);

    CreateResultWindow(ResWayCoords);

    ViewWayButton.Visible := True;
End;

Procedure TMainForm.SaveInFileClick(Sender: TObject);
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

Procedure TMainForm.ViewWayButtonClick(Sender: TObject);
Begin
    Form1.ShowModal;
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
            If (MainForm.ActiveControl = MainForm.MRowsLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.MRowsLEdit, MAX_INT,
                MIN_INT) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.NColsLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.NColsLEdit, MAX_INT,
                MIN_INT) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.IStartPointLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.IStartPointLEdit,
                1, StrToInt(MainForm.MRowsLEdit.Text)) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.JStartPointLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.JStartPointLEdit,
                1, StrToInt(MainForm.NColsLEdit.Text)) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.IEndPointLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.IEndPointLEdit, 1,
                StrToInt(MainForm.MRowsLEdit.Text)) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.JEndPointLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.JEndPointLEdit, 1,
                StrToInt(MainForm.NColsLEdit.Text)) Then
                Raise Exception.Create('Некорректная цифра :(');
        Except
            On E: Exception Do
            Begin
                MessageBox(0, PWideChar(E.Message), 'Ошибка', MB_ICONERROR);
                Exit;
            End;
        End;
    End;
    Inherited;
End;

End.
