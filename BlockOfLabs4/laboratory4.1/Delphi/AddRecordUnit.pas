Unit AddRecordUnit;

Interface

Uses
    Clipbrd,
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
    System.Math,
    Vcl.ExtCtrls;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TAddRecordForm = Class(TForm)
        MainMenu: TMainMenu;
        ReferenceButton: TMenuItem;
        CountryLabel: TLabel;
        TeamNameLabel: TLabel;
        CoachLabel: TLabel;
        PointsLabel: TLabel;
        CountryLabeledEdit: TLabeledEdit;
        TeamNameLabeledEdit: TLabeledEdit;
        CoachLabeledEdit: TLabeledEdit;
        PointsLabeledEdit: TLabeledEdit;
        AddButton: TButton;
        Procedure FormCreate(Sender: TObject);
        Procedure ReferenceButtonClick(Sender: TObject);
        Procedure CountryLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure CountryLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CoachLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure TeamNameLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure PointsLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure TeamNameLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure CoachLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure PointsLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure PointsLabeledEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure CountryLabeledEditChange(Sender: TObject);
        Procedure PointsLabeledEditChange(Sender: TObject);
        Procedure CoachLabeledEditChange(Sender: TObject);
        Procedure TeamNameLabeledEditChange(Sender: TObject);
        Procedure AddButtonClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    MAX_STR_LENGTH: Integer = 20;
    MIN_POINTS: Integer = 0;
    MAX_POINTS: Integer = 100;

Var
    AddRecordForm: TAddRecordForm;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    MainFormUnit,
    BackendUnit;

Procedure TAddRecordForm.AddButtonClick(Sender: TObject);
Var
    ResultKey: Integer;
Begin
    If Not IfRecordExist(CountryLabeledEdit.Text, CoachLabeledEdit.Text, TeamNameLabeledEdit.Text, PointsLabeledEdit.Text) Then
        ResultKey := ID_YES
    Else
        ResultKey := Application.Messagebox
            ('Подобная запись уже существует в таблице результатов, вы уверенны, что хотите создать дубликат?', 'Выход',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If (ResultKey = ID_YES) Then
    Begin
        InputRecordInFile(StrToWideChar(CountryLabeledEdit.Text), StrToWideChar(CoachLabeledEdit.Text),
            StrToWideChar(TeamNameLabeledEdit.Text), StrToint(PointsLabeledEdit.Text));
        Inc(CurentRecordsCount);
        SortRecords();
        InputRecordsInTableGrid();
        MainForm.PointTabelStrGrid.FixedRows := 1;

        CountryLabeledEdit.Text := '';
        TeamNameLabeledEdit.Text := '';
        CoachLabeledEdit.Text := '';
        PointsLabeledEdit.Text := '';
        AddRecordForm.Close;
    End;
End;

Procedure TAddRecordForm.CoachLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.CoachLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TAddRecordForm.CoachLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        AddRecordForm.Close;
End;

Procedure TAddRecordForm.CountryLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.CountryLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TAddRecordForm.CountryLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        AddRecordForm.Close;
End;

Procedure TAddRecordForm.FormCreate(Sender: TObject);
Begin
    CountryLabeledEdit.EditLabel.Caption := '';
    TeamNameLabeledEdit.EditLabel.Caption := '';
    CoachLabeledEdit.EditLabel.Caption := '';
    PointsLabeledEdit.EditLabel.Caption := '';
End;

Procedure TAddRecordForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_ESCAPE) Then
        AddRecordForm.Close;
End;

Procedure TAddRecordForm.PointsLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.PointsLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TAddRecordForm.PointsLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (PointsLabeledEdit.SelText = '') Then
    Begin
        CurKey := IsCorrectDelete(#127, PointsLabeledEdit.Text, PointsLabeledEdit.SelStart + 1);

        If CurKey = #0 Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (PointsLabeledEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(#127, PointsLabeledEdit.Text, PointsLabeledEdit.SelText, PointsLabeledEdit.SelStart);

        If CurKey = #0 Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        AddRecordForm.Close;
End;

Procedure TAddRecordForm.PointsLabeledEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckInput(Key, PointsLabeledEdit);
End;

Procedure TAddRecordForm.ReferenceButtonClick(Sender: TObject);
Var
    InstractionTest: String;
Begin
    InstractionTest := ' - В первых трёх полях ограничений на ввод нет за исключением' + #13#10 +
        'того, что максимальная длина записи 20 символов. Опасайтесь' + #13#10 + 'пробелов, они не видны в турнирной таблице.' + #13#10 +
        ' - У поля итогового рейтинга команды есть ограничения: ' + #13#10 + 'Там можно писать только натуральные числа в диапазоне от 0' +
        #13#10 + 'до 100.' + #13#10 + ' - После того как все поля заполнены нажимайте на кнопку' + #13#10 + '''' +
        AddButton.Caption + ''';';

    CreateModalForm('Справка', InstractionTest, Screen.Width * 27 Div 100, Screen.Height * 21 Div 100);
End;

Procedure TAddRecordForm.TeamNameLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.TeamNameLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := True;
End;

Procedure TAddRecordForm.TeamNameLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        AddRecordForm.Close;
End;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (AddRecordForm.ActiveControl = AddRecordForm.PointsLabeledEdit) And
                Not IsCorrectPointsClipboard(Clipboard.AsText, AddRecordForm.PointsLabeledEdit) Then
                Raise Exception.Create('Некорректное количество очков!'#13#10'Максимальное кол-во очков 100 :(');

            If (AddRecordForm.ActiveControl = AddRecordForm.CoachLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, AddRecordForm.CoachLabeledEdit) Then
                Raise Exception.Create('Некорректная фамилия главного тренера!'#13#10'Давайте уместимся в 20 символов.');

            If (AddRecordForm.ActiveControl = AddRecordForm.TeamNameLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, AddRecordForm.TeamNameLabeledEdit) Then
                Raise Exception.Create('Некорректное название команды!'#13#10'Нужно более короткое название.');

            If (AddRecordForm.ActiveControl = AddRecordForm.CountryLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, AddRecordForm.CountryLabeledEdit) Then
                Raise Exception.Create('Слишком длинное название страны!'#13#10'Используйте сокращения :)');
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
