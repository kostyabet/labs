Unit SearchRecordUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Classes,
    Vcl.Forms,
    Vcl.Menus,
    Vcl.StdCtrls,
    Vcl.ExtCtrls,
    Clipbrd,
    Vcl.Mask,
    Vcl.Controls;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TItemsList = (Country, Team, Coach, Points);

    TItems = Array [Low(TItemsList) .. High(TItemsList)] Of String;

    TSearchRecordForm = Class(TForm)
        MainMenu: TMainMenu;
        ReferenceButton: TMenuItem;
        CBox: TComboBox;
        CBoxLabel: TLabel;
        SearchStrLabel: TLabel;
        SearchStrLEdit: TLabeledEdit;
        SearchButton: TButton;
        ResultLabel: TLabel;
        ChangeRecordButton: TButton;
        Procedure ReferenceButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure CBoxCloseUp(Sender: TObject);
        Procedure SearchStrLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure SearchStrLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SearchStrLEditChange(Sender: TObject);
        Procedure SearchButtonClick(Sender: TObject);
        Procedure ChangeRecordButtonClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CBoxKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    SearchRecordForm: TSearchRecordForm;
    StrIndex: Integer;
    ItemsList: TItemsList;
    Items: TItems = ('по стране', 'по названию команды', 'по фамилии гл. тренера', 'по итоговому рейтингу');

Const
    NULL_POINT: Char = #0;

Implementation

{$R *.dfm}

Uses
    MainFormUnit,
    FrontendUnit,
    BackendUnit,
    ChangeRecordUnit;

Procedure TSearchRecordForm.CBoxKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_ESCAPE) Then
        SearchRecordForm.Close;
End;

Procedure TSearchRecordForm.ChangeRecordButtonClick(Sender: TObject);
Var
    TempRecord: TFootStatsRecord;
Begin
    Application.CreateForm(TChangeRecordForm, ChangeRecordForm);
    CurentRow := StrIndex + 1;
    TempRecord := GetRecordFromFile(CurentRow);
    ChangeRecordForm.CountryLabeledEdit.Text := TempRecord.Country;
    ChangeRecordForm.TeamNameLabeledEdit.Text := TempRecord.Team;
    ChangeRecordForm.CoachLabeledEdit.Text := TempRecord.Coach;
    ChangeRecordForm.PointsLabeledEdit.Text := IntToStr(TempRecord.Points);
    ChangeRecordForm.Showmodal;
    SearchRecordForm.Close;
End;

Procedure TSearchRecordForm.CBoxCloseUp(Sender: TObject);
Const
    POINTS_HINT: String = '0..100';
    STRING_HINT: String = 'строка для поиска';
Begin
    SearchStrLEdit.Text := '';
    SearchButton.Enabled := False;
    ResultLabel.Caption := '';
    ChangeRecordButton.Visible := False;

    If (CBox.ItemIndex = Integer(Points)) Then
    Begin
        SearchStrLEdit.MaxLength := Length(IntToStr(MAX_POINTS));
        SearchStrLEdit.TextHint := POINTS_HINT;
    End
    Else
    Begin
        SearchStrLEdit.MaxLength := MAX_STR_LENGTH;
        SearchStrLEdit.TextHint := STRING_HINT;
    End;
End;

Procedure TSearchRecordForm.FormCreate(Sender: TObject);
Begin
    CBox.Items.AddStrings(Items);
    SearchStrLEdit.EditLabel.Caption := '';
End;

Procedure TSearchRecordForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_ESCAPE) Then
        SearchRecordForm.Close;
End;

Procedure TSearchRecordForm.ReferenceButtonClick(Sender: TObject);
Var
    InstractionTest: String;
Begin
    InstractionTest := ' - В первых трёх вариантах поиска ограничений на ввод нет за' + #13#10 +
        'исключением того, что максимальная длина записи 20 символов.' + #13#10 + ' - У поля итогового рейтинга команды есть ограничения: '
        + #13#10 + 'Там можно писать только натуральные числа в диапазоне от 0' + #13#10 + 'до 100.' + #13#10 +
        ' - После того как все поля заполнены нажимайте на кнопку' + #13#10 + '''' + SearchButton.Caption + ''';' + #13#10 + #13#10 +
        'Если вы хотите изменить данные этой строки, то нажмите' + #13#10 + 'на кнопку ''' + ChangeRecordButton.Caption + '''.';

    CreateModalForm('Справка', InstractionTest, Screen.Width * 27 Div 100, Screen.Height * 24 Div 100);
End;

Procedure TSearchRecordForm.SearchButtonClick(Sender: TObject);
Begin
    StrIndex := IndexRecord(CBox.ItemIndex, StrToWideChar(SearchStrLEdit.Text));
    If StrIndex <> -1 Then
    Begin
        ResultLabel.Caption := CreateResultGrid(StrIndex + 1);
        ChangeRecordButton.Visible := True;
    End
    Else
        MessageBox(0, 'Запись по вашему параметру не найдена!', 'Ошибка', MB_ICONERROR);

End;

Procedure TSearchRecordForm.SearchStrLEditChange(Sender: TObject);
Begin
    ResultLabel.Caption := '';
    ChangeRecordButton.Visible := False;
    SearchButton.Enabled := SearchStrLEdit.Text <> '';
End;

Procedure TSearchRecordForm.SearchStrLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        SearchRecordForm.Close;
End;

Procedure TSearchRecordForm.SearchStrLEditKeyPress(Sender: TObject; Var Key: Char);

Begin
    If CBox.Text = '' Then
        Key := NULL_POINT;

    If CBox.ItemIndex = Integer(Points) Then
        Key := CheckInput(Key, SearchStrLEdit);
End;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (SearchRecordForm.CBox.ItemIndex = 3) And Not IsCorrectPointsClipboard(Clipboard.AsText,
                SearchRecordForm.SearchStrLEdit) Then
                Raise Exception.Create('Некорректное количество очков!'#13#10'Максимальное кол-во очков 100 :(');

            If (SearchRecordForm.CBox.ItemIndex = 2) And Not IsCorrectStrings(Clipboard.AsText, SearchRecordForm.SearchStrLEdit) Then
                Raise Exception.Create('Некорректная фамилия главного тренера!'#13#10'Давайте уместимся в 20 символов.');

            If (SearchRecordForm.CBox.ItemIndex = 1) And Not IsCorrectStrings(Clipboard.AsText, SearchRecordForm.SearchStrLEdit) Then
                Raise Exception.Create('Некорректное название команды!'#13#10'Нужно более корокое название.');

            If (SearchRecordForm.CBox.ItemIndex = 0) And Not IsCorrectStrings(Clipboard.AsText, SearchRecordForm.SearchStrLEdit) Then
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
