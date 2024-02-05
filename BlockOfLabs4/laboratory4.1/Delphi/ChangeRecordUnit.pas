Unit ChangeRecordUnit;

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
    Clipbrd;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TChangeRecordForm = Class(TForm)
        MainMenu: TMainMenu;
        RefferenceButton: TMenuItem;
        CountryLabel: TLabel;
        TeamNameLabel: TLabel;
        CoachLabel: TLabel;
        PointsLabel: TLabel;
        CountryLabeledEdit: TLabeledEdit;
        TeamNameLabeledEdit: TLabeledEdit;
        CoachLabeledEdit: TLabeledEdit;
        PointsLabeledEdit: TLabeledEdit;
        ChangeButton: TButton;
        Procedure CountryLabeledEditChange(Sender: TObject);
        Procedure TeamNameLabeledEditChange(Sender: TObject);
        Procedure CoachLabeledEditChange(Sender: TObject);
        Procedure PointsLabeledEditChange(Sender: TObject);
        Procedure CountryLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure TeamNameLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure PointsLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure CoachLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure CountryLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure TeamNameLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure CoachLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure PointsLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure PointsLabeledEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormCreate(Sender: TObject);
        Procedure ChangeButtonClick(Sender: TObject);
        Procedure RefferenceButtonClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    ChangeRecordForm: TChangeRecordForm;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    BackendUnit,
    MainFormUnit;

Procedure TChangeRecordForm.ChangeButtonClick(Sender: TObject);
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
        InputDataInMassive(ConvertStringToWideChar(CountryLabeledEdit.Text), ConvertStringToWideChar(TeamNameLabeledEdit.Text),
            ConvertStringToWideChar(CoachLabeledEdit.Text), StrToint(PointsLabeledEdit.Text), CurentRow - 1);
        SortFootballStats();
        InputMassiveInTableGrid();

        ChangeRecordForm.Close;
    End;
End;

Procedure TChangeRecordForm.CoachLabeledEditChange(Sender: TObject);
Begin
    ChangeButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TChangeRecordForm.CoachLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TChangeRecordForm.CoachLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TChangeRecordForm.CountryLabeledEditChange(Sender: TObject);
Begin
    ChangeButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TChangeRecordForm.CountryLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TChangeRecordForm.CountryLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TChangeRecordForm.FormCreate(Sender: TObject);

Begin
    CountryLabeledEdit.EditLabel.Caption := '';
    TeamNameLabeledEdit.EditLabel.Caption := '';
    CoachLabeledEdit.EditLabel.Caption := '';
    PointsLabeledEdit.EditLabel.Caption := '';
End;

Procedure TChangeRecordForm.PointsLabeledEditChange(Sender: TObject);
Begin
    ChangeButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TChangeRecordForm.PointsLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TChangeRecordForm.PointsLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TChangeRecordForm.PointsLabeledEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckInput(Key, PointsLabeledEdit);
End;

Procedure TChangeRecordForm.RefferenceButtonClick(Sender: TObject);
Var
    InstractionTest: String;
Begin
    InstractionTest := ' - В первых трёх полях ограничений на ввод нет за исключением' + #13#10 +
        'того, что максимальная длина записи 20 символов. Опасайтесь' + #13#10 + 'пробелов, они не видны в турнирной таблице.' + #13#10 +
        ' - У поля итогового рейтинга команды есть ограничения: ' + #13#10 + 'Там можно писать только натуральные числа в диапазоне от 0' +
        #13#10 + 'до 100.' + #13#10 + ' - После того как все поля изменены нажимайте на кнопку' + #13#10 + '''' +
        ChangeButton.Caption + ''';';

    CreateModalForm('Справка', InstractionTest, 490, 210);
End;

Procedure TChangeRecordForm.TeamNameLabeledEditChange(Sender: TObject);
Begin
    ChangeButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TChangeRecordForm.TeamNameLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TChangeRecordForm.TeamNameLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (ChangeRecordForm.ActiveControl = ChangeRecordForm.PointsLabeledEdit) And
                Not IsCorrectPointsClipboard(Clipboard.AsText, ChangeRecordForm.PointsLabeledEdit) Then
                Raise Exception.Create('Некорректное количество очков!'#13#10'Максимальное кол-во очков 100 :(');

            If (ChangeRecordForm.ActiveControl = ChangeRecordForm.CoachLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, ChangeRecordForm.CoachLabeledEdit) Then
                Raise Exception.Create('Некорректная фамилия главного тренера!'#13#10'Давайте уместимся в 20 символов.');

            If (ChangeRecordForm.ActiveControl = ChangeRecordForm.TeamNameLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, ChangeRecordForm.TeamNameLabeledEdit) Then
                Raise Exception.Create('Некорректное название команды!'#13#10'Нужно более корокое название.');

            If (ChangeRecordForm.ActiveControl = ChangeRecordForm.CountryLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, ChangeRecordForm.CountryLabeledEdit) Then
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
