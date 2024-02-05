Unit SearchRecordUnit;

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
    TItems = Array [1 .. 4] Of String;

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
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    SearchRecordForm: TSearchRecordForm;
    StrIndex: Integer;
    Items: TItems = ('по стране', 'по названию команды', 'по фамилии гл. тренера', 'по итоговому рейтингу');

Implementation

{$R *.dfm}

Uses
    MainFormUnit,
    FrontendUnit,
    BackendUnit,
    ChangeRecordUnit;

Procedure TSearchRecordForm.ChangeRecordButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TChangeRecordForm, ChangeRecordForm);
    CurentRow := StrIndex + 1;

    ChangeRecordForm.CountryLabeledEdit.Text := FootballTable[StrIndex].Country;
    ChangeRecordForm.TeamNameLabeledEdit.Text := FootballTable[StrIndex].Team;
    ChangeRecordForm.CoachLabeledEdit.Text := FootballTable[StrIndex].Coach;
    ChangeRecordForm.PointsLabeledEdit.Text := IntToStr(FootballTable[StrIndex].Points);

    ChangeRecordForm.Showmodal;
    SearchRecordForm.Close;
End;

Procedure TSearchRecordForm.CBoxCloseUp(Sender: TObject);
Begin
    SearchStrLEdit.Text := '';
    SearchButton.Enabled := False;
    ResultLabel.Caption := '';
    ChangeRecordButton.Visible := False;

    If (CBox.ItemIndex In [0 .. 2]) Then
    Begin
        SearchStrLEdit.MaxLength := 20;
        SearchStrLEdit.TextHint := 'строка для поиска';
    End
    Else
    Begin
        SearchStrLEdit.MaxLength := 3;
        SearchStrLEdit.TextHint := '0..100';
    End;
End;

Procedure TSearchRecordForm.FormCreate(Sender: TObject);
Begin
    CBox.Items.AddStrings(Items);
    SearchStrLEdit.EditLabel.Caption := '';
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

    CreateModalForm('Справка', InstractionTest, 490, 240);
End;

Procedure TSearchRecordForm.SearchButtonClick(Sender: TObject);
Begin
    StrIndex := IndexRecord(CBox.ItemIndex, SearchStrLEdit.Text);
    If StrIndex <> -1 Then
    Begin
        ResultLabel.Caption := CreateResultGrid(StrIndex);
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
End;

Procedure TSearchRecordForm.SearchStrLEditKeyPress(Sender: TObject; Var Key: Char);

Begin
    If CBox.Text = '' Then
        Key := #0;

    If CBox.ItemIndex = 4 Then
        Key := CheckInput(Key, SearchStrLEdit);
End;

End.
