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
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    AddRecordForm: TAddRecordForm;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    MainFormUnit,
    BackendUnit;

Procedure TAddRecordForm.AddButtonClick(Sender: TObject);
Begin
    InputDataInMassive(CountryLabeledEdit.Text, TeamNameLabeledEdit.Text, CoachLabeledEdit.Text, PointsLabeledEdit.Text);

    InputMassiveInTableGrid(FootballTable, MainForm.PointTabelStrGrid);

    CountryLabeledEdit.Text := '';
    TeamNameLabeledEdit.Text := '';
    CoachLabeledEdit.Text := '';
    PointsLabeledEdit.Text := '';
    AddRecordForm.Close;
End;

Procedure TAddRecordForm.CoachLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.CoachLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TAddRecordForm.CoachLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TAddRecordForm.CountryLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.CountryLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TAddRecordForm.CountryLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TAddRecordForm.FormCreate(Sender: TObject);
Begin
    CountryLabeledEdit.EditLabel.Caption := '';
    TeamNameLabeledEdit.EditLabel.Caption := '';
    CoachLabeledEdit.EditLabel.Caption := '';
    PointsLabeledEdit.EditLabel.Caption := '';
End;

Procedure TAddRecordForm.PointsLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.PointsLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TAddRecordForm.PointsLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TAddRecordForm.PointsLabeledEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9', #08];
Begin
    If Not(Key In GOOD_VALUES) Then
        Key := #0;

    If (PointsLabeledEdit.Text = '10') And ((Key <> '0') And (Key <> #08)) Then
        Key := #0;

    If (Length(PointsLabeledEdit.Text) = PointsLabeledEdit.MaxLength - 1) And (PointsLabeledEdit.Text <> '10') And (Key <> #08) Then
        Key := #0;

    If (PointsLabeledEdit.Text = '0') And (Key <> #08) Then
        Key := #0;
End;

Procedure TAddRecordForm.ReferenceButtonClick(Sender: TObject);
Begin
    CreateModalForm('Справка', 'Справка', 410, 300);
End;

Procedure TAddRecordForm.TeamNameLabeledEditChange(Sender: TObject);
Begin
    AddButton.Enabled := IsVisibleAddOnChange(CountryLabeledEdit, CoachLabeledEdit, PointsLabeledEdit, TeamNameLabeledEdit);
End;

Procedure TAddRecordForm.TeamNameLabeledEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TAddRecordForm.TeamNameLabeledEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
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
            If (AddRecordForm.ActiveControl = AddRecordForm.PointsLabeledEdit) And
                Not IsCorrectPointsClipboard(Clipboard.AsText, AddRecordForm.PointsLabeledEdit) Then
                Raise Exception.Create('Некорректное количество очков!');

            If (AddRecordForm.ActiveControl = AddRecordForm.CoachLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, AddRecordForm.CoachLabeledEdit) Then
                Raise Exception.Create('Некорректная фамилия главного тренера!');

            If (AddRecordForm.ActiveControl = AddRecordForm.TeamNameLabeledEdit) And
                Not IsCorrectStrings(Clipboard.AsText, AddRecordForm.TeamNameLabeledEdit) Then
                Raise Exception.Create('Некорректное название команды!'#13#10'Нужно более корокое название.');

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
