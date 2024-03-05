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
        ToMirrorTreeButton: TSpeedButton;
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
        Procedure WatchTreeSpButtonClick(Sender: TObject);
        Procedure OpenClick(Sender: TObject);
        Procedure ToMirrorTreeButtonClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;

Const
    ZERO_KEY: Char = '0';
    NULL_POINT: Char = #0;
    DELETE_KEY: Char = #127;
    BACK_SPACE: Char = #08;
    MINUS_KEY: Char = '-';
    MIN_INT: Integer = -1_000_000;
    MAX_INT: Integer = +1_000_000;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    BackendUnit,
    DrawUnit,
    TreeUnit;

Procedure TMainForm.AboutEditorClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 22 Div 100,
        Screen.Height * 8 Div 100);
End;

Procedure TMainForm.AddSpButtonClick(Sender: TObject);
Const
    MAX_KNOTS: Integer = 30;
Var
    Cost, Child: Integer;
Begin
    Cost := 0;
    If (GetExistPointsCount() <> 0) Then
        Cost := StrToInt(BranchCostLEdit.Text);
    Child := StrToInt(NewTrickLEdit.Text);
    If (GetExistPoints(Child) <> -1) Then
        Application.Messagebox('Такой узел уже существует!', 'Ошибка', MB_ICONERROR + MB_DEFBUTTON2)
    Else
        If (GetExistPointsCount = MAX_KNOTS) Then
            Application.Messagebox('Вы достигли максимального количества узлов!', 'Ошибка', MB_ICONERROR + MB_DEFBUTTON2)
        Else
        Begin
            InsertNewBranch(Child, Cost);
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
    Handled := True;
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
Begin
    SearchLongestWay();
    BranchCostLEdit.Visible := False;
    BranchCostLabel.Visible := False;
    NewTrickLEdit.Visible := False;
    NewTrickLabel.Visible := False;
    AddSpButton.Visible := False;
    Open.Enabled := False;
    Save.Enabled := True;
    EndSpButton.Visible := False;
    WatchTreeSpButton.Enabled := True;
    ToMirrorTreeButton.Enabled := True;
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
        FreeTree();
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
        OutputStr := 'Инструкция:' + #13#10 + '1. Изначально вы вводите, или через файл, или через консоль,'#13#10 +
            '   узлы вашего дерева, а также вес ветки при этом узле.'#13#10 +
            '2. Первый узел не может иметь вес как ветку, ибо нет другого значения.'#13#10 + '3. И цена и вес ограничены в диапазоне от ' +
            IntToStr(MIN_INT) + ' до ' + IntToStr(MAX_INT) + '.'#13#10 +
            '4. При вводе/выводе через файл использовать только расширение .txt!'#13#10#13#10 +
            'По условию дерево отражается относительно самого длинного пути,'#13#10 +
            'при графическом просмотре дерева узлы длинного пути выделены.';
        CreateModalForm('Инструкция', OutputStr, Screen.Width * 29 Div 100, Screen.Height * 23 Div 100);
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
    Handled := True;
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

Procedure TMainForm.OpenClick(Sender: TObject);
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

Procedure TMainForm.ToMirrorTreeButtonClick(Sender: TObject);
Begin
    ToMirrorTree();
    ToMirrorTreeButton.Enabled := False;
End;

Procedure TMainForm.WatchTreeSpButtonClick(Sender: TObject);
Begin
    DrawForm.ShowModal;
End;

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
