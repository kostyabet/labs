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
        AddButton: TSpeedButton;
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
        Procedure AddButtonClick(Sender: TObject);
        Procedure SpeedButton1Click(Sender: TObject);
        Procedure AboutEditorMMClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure ExitButtonClick(Sender: TObject);
        Procedure ExitMMClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
        Procedure DeleteButtonClick(Sender: TObject);
        Procedure InstractionMMClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure LinkedListStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;

Implementation

{$R *.dfm}

Uses
    AddValueUnit,
    FrontendUnit,
    DoubleLinkedList;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    AddButton.Caption := 'Добавить'#13#10'элемент';
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
        AddButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.InstractionMMClick(Sender: TObject);
Var
    OutputStr: String;
Begin
    OutputStr := 'Инструкция:' + #13#10'1. Добавить новый элемент можно нажав на кнопку ''Добавить элемент'';' +
        #13#10'2. Удалить элемент можно выбрав нужный элемент слева и нажав на' + #13#10'    кнопку ''Удалить элемент''.'#13#10 +
        #13#10'Все элемент двусвяного списка выводятся в обратном порядке в' + #13#10'соответствии с условием задания.'#13#10;
    CreateModalForm('О разработчике', OutputStr, Screen.Width * 29 Div 100, Screen.Height * 50 Div 100);
End;

Procedure TMainForm.LinkedListStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_INSERT) Then
        AddButton.Click;

    If (Key = VK_DELETE) Then
        DeleteButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.AboutEditorMMClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 22 Div 100,
        Screen.Height * 8 Div 100);
End;

Procedure TMainForm.SpeedButton1Click(Sender: TObject);
Begin
    CreateModalForm('Создание списка', 'fdfsd', Screen.Width * 20 Div 100, Screen.Height * 20 Div 100);
End;

Procedure TMainForm.AddButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TAddValueForm, AddValueForm);
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
            PrintList;
            If LinkedListStrGrid.RowCount < 17 Then
                LinkedListStrGrid.ColWidths[1] := (LinkedListStrGrid.Width * 79) Div 100;
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

End.
