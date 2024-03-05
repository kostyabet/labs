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
    Vcl.Buttons,
    Vcl.Menus,
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    System.ImageList,
    Vcl.ImgList,
    Vcl.Grids;

Type
    TMainForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMM: TMenuItem;
        InstractionMM: TMenuItem;
        AboutEditorMM: TMenuItem;
        Line: TMenuItem;
        ExitMM: TMenuItem;
        AddTailButton: TSpeedButton;
        DeleteButton: TSpeedButton;
        NavPanel: TPanel;
        SpButImgList: TImageList;
        MMImgList: TImageList;
        ExitButton: TSpeedButton;
        LinkedListStrGrid: TStringGrid;
        OpenButton: TMenuItem;
        SaveButton: TMenuItem;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        AddHeadButton: TSpeedButton;
        Procedure AddTailButtonClick(Sender: TObject);
        Procedure AboutEditorMMClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure ExitButtonClick(Sender: TObject);
        Procedure ExitMMClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
        Procedure DeleteButtonClick(Sender: TObject);
        Procedure InstractionMMClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure LinkedListStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure SaveButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure OpenButtonClick(Sender: TObject);
        Procedure AddHeadButtonClick(Sender: TObject);
    Private
        Procedure WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    IfDataSavedInFile: Boolean = False;
    AddInTail: Boolean;

Implementation

{$R *.dfm}

Uses
    AddValueUnit,
    FrontendUnit;

Procedure DeleteFromList(Num: Integer); External 'DoubleLinkedList.dll';
Procedure PrintList(Var LinkedListStrGrid: TStringGrid); External 'DoubleLinkedList.dll';

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;

    If (ResultKey = ID_YES) And Not IfDataSavedInFile And (LinkedListStrGrid.RowCount > 1) Then
    Begin
        ResultKey := Application.Messagebox('Вы не сохранили результат. Хотите сделать это?', 'Сохранение',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
            SaveButtonClick(Sender);
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    AddTailButton.Caption := 'Добавить'#13#10'в конец';
    AddHeadButton.Caption := 'Добавить'#13#10'в начало';
    DeleteButton.Caption := 'Удалить'#13#10'элемент';
    LinkedListStrGrid.Cells[0, 0] := '№';
    LinkedListStrGrid.Cells[1, 0] := 'Значение';

    LinkedListStrGrid.ColWidths[0] := (LinkedListStrGrid.Width * 19) Div 100;
    LinkedListStrGrid.ColWidths[1] := (LinkedListStrGrid.Width * 79) Div 100;
End;

Function TMainForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;

Procedure TMainForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_INSERT) Then
        AddTailButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.InstractionMMClick(Sender: TObject);
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
    CreateModalForm('Инструкция', OutputStr, Screen.Width * 29 Div 100, Screen.Height * 43 Div 100);
End;

Procedure TMainForm.LinkedListStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_INSERT) Then
        AddTailButton.Click;

    If (Key = VK_DELETE) Then
        DeleteButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
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

Procedure TMainForm.AboutEditorMMClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 22 Div 100,
        Screen.Height * 8 Div 100);
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

Procedure TMainForm.AddHeadButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TAddValueForm, AddValueForm);
    AddInTail := False;
    AddValueForm.ShowModal;
End;

Procedure TMainForm.AddTailButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TAddValueForm, AddValueForm);
    AddInTail := True;
    AddValueForm.ShowModal;
End;

Procedure TMainForm.DeleteButtonClick(Sender: TObject);
Const
    MAX_SEEN_RECORDS: Integer = 11;
Var
    ResultKey, CurentRow: Integer;
Begin
    CurentRow := MainForm.LinkedListStrGrid.Row;

    If (CurentRow <> 0) Then
    Begin
        ResultKey := Application.Messagebox('Вы уверены, что хотите удалить запись?', 'Удаление записи',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
        Begin
            DeleteFromList(LinkedListStrGrid.RowCount - CurentRow);
            ClearStringGrid;
            LinkedListStrGrid.RowCount := LinkedListStrGrid.RowCount - 1;
            PrintList(LinkedListStrGrid);
            If LinkedListStrGrid.RowCount < 17 Then
                LinkedListStrGrid.ColWidths[1] := (LinkedListStrGrid.Width * 79) Div 100;

            If MainForm.LinkedListStrGrid.RowCount > 1 Then
                MainForm.SaveButton.Enabled := True
            Else
                MainForm.SaveButton.Enabled := False;
            IfDataSavedInFile := False;
        End;
    End
    Else
        MessageBox(0, 'Необходимо выбрать строку для удаления!', 'Ошибка', MB_ICONERROR);
End;

Procedure TMainForm.ExitButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.ExitMMClick(Sender: TObject);
Begin
    MainForm.Close;
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

End.
