Unit MainFormUnit;

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
    Vcl.Buttons,
    Clipbrd;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TMainForm = Class(TForm)
        TaskLabel: TLabel;
        MainMenu: TMainMenu;
        MMImgList: TImageList;
        FileScroll: TMenuItem;
        Open: TMenuItem;
        Save: TMenuItem;
        Line: TMenuItem;
        Exit: TMenuItem;
        Instraction: TMenuItem;
        AboutEditor: TMenuItem;
        CreateTreeSpButton: TSpeedButton;
        WatchTreeSpButton: TSpeedButton;
        NewTrickLEdit: TLabeledEdit;
        NewTrickLabel: TLabel;
        BranchCostLEdit: TLabeledEdit;
        BranchCostLabel: TLabel;
        EndSpButton: TSpeedButton;
        MBImgList: TImageList;
        AddSpButton: TSpeedButton;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        Procedure FormCreate(Sender: TObject);
        Procedure CreateTreeSpButtonClick(Sender: TObject);
        Procedure NewTrickLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure NewTrickLEditChange(Sender: TObject);
        Procedure AddSpButtonClick(Sender: TObject);
        Procedure EndSpButtonClick(Sender: TObject);
        Procedure BranchCostLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure BranchCostLEditChange(Sender: TObject);
        Procedure BranchCostLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NewTrickLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure NewTrickLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure BranchCostLEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure InstractionClick(Sender: TObject);
        Procedure AboutEditorClick(Sender: TObject);
        Procedure SaveClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitClick(Sender: TObject);
    procedure WatchTreeSpButtonClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;

Const
    NULL_POINT: Char = #08;
    DELETE_KEY: Char = #127;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    BackendUnit,
    BinaryTreeUnit, DrawUnit;

Procedure TMainForm.AboutEditorClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 22 Div 100,
        Screen.Height * 8 Div 100);
End;

Procedure TMainForm.AddSpButtonClick(Sender: TObject);
Var
    Cost, Kid: Integer;
Begin
    Cost := 0;
    If (ExistPoints.Count <> 0) Then
        Cost := StrToInt(BranchCostLEdit.Text);
    Kid := StrToInt(NewTrickLEdit.Text);
    If (ExistPoints.IndexOf(Kid) <> -1) Then
        Application.Messagebox('Такой узел уже существует', 'Ошибка', MB_ICONERROR + MB_DEFBUTTON2)
    Else
    Begin
        InsertNewBranch(Kid, Cost);
        BranchCostLEdit.Visible := True;
        BranchCostLabel.Visible := True;
        NewTrickLEdit.Text := '';
        BranchCostLEdit.Text := '';
        EndSpButton.Enabled := True;
    End;
End;

Procedure TMainForm.BranchCostLEditChange(Sender: TObject);
Begin
    If (BranchCostLEdit.Visible = False) Then
        AddSpButton.Enabled := CheckInput(NewTrickLEdit.Text)
    Else
        AddSpButton.Enabled := CheckInput(NewTrickLEdit.Text) And CheckInput(BranchCostLEdit.Text);
End;

Procedure TMainForm.BranchCostLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.BranchCostLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (BranchCostLEdit.SelText = '') Then
    Begin
        CurKey := IsCorrectDelete(DELETE_KEY, BranchCostLEdit.Text, BranchCostLEdit.SelStart + 1);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (BranchCostLEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(DELETE_KEY, BranchCostLEdit.Text, BranchCostLEdit.SelText, BranchCostLEdit.SelStart);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.BranchCostLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckInputKey(BranchCostLEdit, Key);
End;

Procedure TMainForm.CreateTreeSpButtonClick(Sender: TObject);
Begin
    CreateTreeSpButton.Enabled := False;
    Open.Enabled := True;
    NewTrickLEdit.Visible := True;
    NewTrickLabel.Visible := True;
    EndSpButton.Visible := True;
    AddSpButton.Visible := True;
End;

Procedure TMainForm.EndSpButtonClick(Sender: TObject);
var
    OutputString: String;
Begin
    SearchLongestWay(BinaryTree, 0);
    BinaryTree := Head;
    //ToMirrorTree;
    //PrintTree(BinaryTree, OutputString, '', false);
    //BinaryTree := Head;
    //TaskLabel.Caption := OutputString;
    BranchCostLEdit.Visible := False;
    BranchCostLabel.Visible := False;
    NewTrickLEdit.Visible := False;
    NewTrickLabel.Visible := False;
    AddSpButton.Visible := False;
    Open.Enabled := False;
    Save.Enabled := True;
    EndSpButton.Visible := False;
    WatchTreeSpButton.Enabled := True;
End;

Procedure TMainForm.ExitClick(Sender: TObject);
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

    If (ResultKey = ID_YES) And Not IfDataSavedInFile And WatchTreeSpButton.Enabled Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
            SaveClick(Sender);
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    NewTrickLEdit.EditLabel.Caption := '';
    BranchCostLEdit.EditLabel.Caption := '';
    CreateTree();
End;

Procedure TMainForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.InstractionClick(Sender: TObject);
Begin
    Var
        OutputStr: String;
    Begin
        OutputStr := 'Инструкция:' + #13#10'1. Добавить новый элемент можно нажав на кнопку ''Добавить элемент'';' +
            #13#10'2. Удалить элемент можно выбрав его слева и нажав на' + #13#10'    кнопку ''Удалить элемент''.'#13#10 +
            #13#10'Все элемент двусвяного списка выводятся в обратном порядке в' + #13#10'соответствии с условием задания.'#13#10 +
            #13#10'Нажать DEL в таблице - удаление выбранного элемента;' + #13#10'Нажать INS в таблице - добавить новый элемент.'#13#10 +
            #13#10'Вы можете выйти из формы нажам ESCape/DELete/Alt+F4.'#13#10 + #13#10'Вы можете открыть справку на F1.'#13#10 +
            #13#10'Ctrl + O - Открыть файл;' + #13#10'Ctrl + S - Сохранить в файл.' + #13#10'Инструкция для файла:' +
            #13#10'  - Файл формата .txt!!!' + #13#10'  - В файле должно быть записано только одно число.';
        CreateModalForm('О разработчике', OutputStr, Screen.Width * 29 Div 100, Screen.Height * 43 Div 100);
    End;
End;

Procedure TMainForm.NewTrickLEditChange(Sender: TObject);
Begin
    If (BranchCostLEdit.Visible = False) Then
        AddSpButton.Enabled := CheckInput(NewTrickLEdit.Text)
    Else
        AddSpButton.Enabled := CheckInput(NewTrickLEdit.Text) And CheckInput(BranchCostLEdit.Text);
End;

Procedure TMainForm.NewTrickLEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TMainForm.NewTrickLEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (NewTrickLEdit.SelText = '') Then
    Begin
        CurKey := IsCorrectDelete(DELETE_KEY, NewTrickLEdit.Text, NewTrickLEdit.SelStart + 1);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (NewTrickLEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(DELETE_KEY, NewTrickLEdit.Text, NewTrickLEdit.SelText, NewTrickLEdit.SelStart);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);
End;

Procedure TMainForm.NewTrickLEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := CheckInputKey(NewTrickLEdit, Key);
End;

Procedure TMainForm.SaveClick(Sender: TObject);
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

procedure TMainForm.WatchTreeSpButtonClick(Sender: TObject);
begin
    DrawForm.ShowModal;
end;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (MainForm.ActiveControl = MainForm.NewTrickLEdit) And Not IsCorrectClipboard(Clipboard.AsText, MainForm.NewTrickLEdit) Then
                Raise Exception.Create('Некорректная цифра :(');

            If (MainForm.ActiveControl = MainForm.BranchCostLEdit) And
                Not IsCorrectClipboard(Clipboard.AsText, MainForm.BranchCostLEdit) Then
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
