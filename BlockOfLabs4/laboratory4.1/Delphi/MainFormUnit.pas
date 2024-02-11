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
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Menus,
    Vcl.Grids,
    System.ImageList,
    Vcl.ImgList,
    Vcl.Imaging.Pngimage;

Type
    TMainForm = Class(TForm)
        TMLabel: TLabel;
        NavPanel: TPanel;
        AddSpButton: TSpeedButton;
        ChangeSpButton: TSpeedButton;
        SearchSpButton: TSpeedButton;
        RemoveSpButton: TSpeedButton;
        ExitSpButton: TSpeedButton;
        NavImgList: TImageList;
        MainMenu: TMainMenu;
        FileButton: TMenuItem;
        InstractionButton: TMenuItem;
        AboutEditorButton: TMenuItem;
        CupImage: TImage;
        AboutCupLabel: TLabel;
        PointTabelStrGrid: TStringGrid;
        BestFormLabel: TLabel;
        ExposureLabel: TLabel;
        StGridInfo: TLabel;
        CloseButton: TMenuItem;
        MMIconImgList: TImageList;
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseButtonClick(Sender: TObject);
        Procedure ExitSpButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure AboutEditorButtonClick(Sender: TObject);
        Procedure InstractionButtonClick(Sender: TObject);
        Procedure AddSpButtonClick(Sender: TObject);
        Procedure ChangeSpButtonClick(Sender: TObject);
        Procedure RemoveSpButtonClick(Sender: TObject);
        Procedure SearchSpButtonClick(Sender: TObject);
        Procedure PointTabelStrGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure PointTabelStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure PointTabelStrGridDblClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        Procedure WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    CurentRow: Integer;

Implementation

{$R *.dfm}

Uses
    FrontendUnit,
    AddRecordUnit,
    BackendUnit,
    ChangeRecordUnit,
    SearchRecordUnit;

Procedure TMainForm.AboutEditorButtonClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 21 Div 100,
        Screen.Height * 7 Div 100);
End;

Procedure TMainForm.AddSpButtonClick(Sender: TObject);
Begin
    If (CurentRecordsCount = TEAMS_COUNT) Then
        MessageBox(0, 'Вы достигли максимального колличества команд!', 'Ошибка', MB_ICONERROR)
    Else
    Begin
        Application.CreateForm(TAddRecordForm, AddRecordForm);
        AddRecordForm.ShowModal;
    End;
End;

Procedure TMainForm.ChangeSpButtonClick(Sender: TObject);
Var
    TempRecord: TFootStatsRecord;
Begin
    CurentRow := MainForm.PointTabelStrGrid.Row;

    If (CurentRow <> 0) Then
    Begin
        Application.CreateForm(TChangeRecordForm, ChangeRecordForm);

        TempRecord := GetRecordFromFile(CurentRow);
        ChangeRecordForm.CountryLabeledEdit.Text := TempRecord.Country;
        ChangeRecordForm.TeamNameLabeledEdit.Text := TempRecord.Team;
        ChangeRecordForm.CoachLabeledEdit.Text := TempRecord.Coach;
        ChangeRecordForm.PointsLabeledEdit.Text := IntToStr(TempRecord.Points);

        ChangeRecordForm.Showmodal;
    End
    Else
        MessageBox(0, 'Выберите строку записи!', 'Ошибка', MB_ICONERROR);
End;

Procedure TMainForm.CloseButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.ExitSpButtonClick(Sender: TObject);
Begin
    MainForm.Close;
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_YES Then
    Begin
        CanClose := True;
        LoadRecordsInFile;
    End
    Else
        CanClose := False;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    PointTabelStrGrid.ColWidths[0] := (PointTabelStrGrid.Width * 9) Div 100;
    PointTabelStrGrid.ColWidths[1] := (PointTabelStrGrid.Width * 23) Div 100;
    PointTabelStrGrid.ColWidths[2] := (PointTabelStrGrid.Width * 23) Div 100;
    PointTabelStrGrid.ColWidths[3] := (PointTabelStrGrid.Width * 23) Div 100;
    PointTabelStrGrid.ColWidths[4] := (PointTabelStrGrid.Width * 21) Div 100;
    PointTabelStrGrid.Cells[0, 0] := 'Место';
    PointTabelStrGrid.Cells[1, 0] := 'Страна';
    PointTabelStrGrid.Cells[2, 0] := 'Название команды';
    PointTabelStrGrid.Cells[3, 0] := 'Главный тренер';
    PointTabelStrGrid.Cells[4, 0] := 'Итоговый рейтинг';

    LoadRecordsFromFile();

    If (CurentRecordsCount <> 0) Then
        PointTabelStrGrid.FixedRows := 1;
End;

Procedure TMainForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_INSERT) Then
        AddSPButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Var
    InstractionText: String;
Begin
    InstractionText := 'Инструкция:' + #13#10 + '1. Чтобы добавить новую запись нажмите на кнопку ''' + AddSpButton.Caption + ''';' + #13#10
        + '2. Если вы хотите изменить какую-то запись, то выберите необходимую' + #13#10 +
        '    строку для изменения и нажимайте на кнопку ''' + ChangeSpButton.Caption + ''';' + #13#10 +
        '3. Если у вас много записей и вы потерялись, то нажмите на кнопку' + #13#10 + '    ''' + SearchSpButton.Caption +
        '''. Там вы можете выбрать удобный вам критерий для поиска' + #13#10 + '    и даже сразу изменить эту запись;' + #13#10 +
        '4. Если запись необходимо убрать из турнирной таблицы, то нажмите' + #13#10 + '    на кнопку ''' + RemoveSpButton.Caption +
        '''. Для этого так же необходимо заранее выбрать' + #13#10 + '    нужную строку.' + #13#10 + #13#10 +
        'Если вы хотите выйти, то у вас есть много вариантов, как это сделать:' + #13#10 + '   - Сочетание клавишь Alt + F4;' + #13#10 +
        '   - Сочетание клавишь Ctrl + Q;' + #13#10 + '   - Нажать ESCape (работает, как способ закрытия любого окна);' + #13#10 +
        '   - Выбрать кнопку ''' + ExitSpButton.Caption + ''' в левом меню;' + #13#10 + '   - Во вкладке ' + FileButton.Caption +
        ' пункт ''' + CloseButton.Caption + '''.' + #13#10 + #13#10 + 'Работа с файлами: ' + #13#10 +
        '    В форме автоматически реализованы типизированный файл и файл' + #13#10 +
        '    корректур. Если вы сделали запись и закрыли форму, то всё' + #13#10 +
        '    сохранится автоматически и при запуске будет выгружено. ' + #13#10 + #13#10 +
        'В любой форме вы можете обратится к справке нажав клавишу F1 или' + #13#10 + 'выбрав её в верхем меню.' + #13#10 + #13#10 +
        'В турнирной таблице записи упорядочены по убыванию рейтинга команд.' + #13#10 + #13#10 +
        'В случае когда набрано одинаковое кол-во очков, первой будет идти' + #13#10 + 'команда, которая была записана в таблицу раньше.' +
        #13#10 + 'Горячие клавиши:' + #13#10 + '   - Двойное нажатие вызовет изменения выбранной записи;' + #13#10 +
        '   - Нажатие Delete вызовет удаление выбранной записи;' + #13#10 + '   - Нажатие Insert вызовет добавление новой записи;' + #13#10
        + '   - Нажатие ESCape закрывает текущую форму.';

    CreateModalForm('Инструкция', InstractionText, Screen.Width * 29 Div 100, Screen.Height * 70 Div 100);
End;

Procedure TMainForm.PointTabelStrGridDblClick(Sender: TObject);
Begin
    ChangeSPButton.Click;
End;

Procedure TMainForm.PointTabelStrGridKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_INSERT) Then
        AddSPButton.Click;

    If (Key = VK_DELETE) Then
        RemoveSPButton.Click;

    If (Key = VK_ESCAPE) Then
        MainForm.Close;
End;

Procedure TMainForm.PointTabelStrGridKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (CurentRecordsCount <> 0) Then
        PointTabelStrGrid.FixedRows := 1
    Else
        PointTabelStrGrid.FixedRows := 0;
End;

Procedure TMainForm.RemoveSpButtonClick(Sender: TObject);
Var
    ResultKey: Integer;
Begin
    CurentRow := MainForm.PointTabelStrGrid.Row;

    If (CurentRow <> 0) Then
    Begin
        ResultKey := Application.Messagebox('Вы уверены, что хотите удалить запись?', 'Удаление записи',
            MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

        If ResultKey = ID_YES Then
        Begin
            DeleteRow(CurentRow);
            Dec(CurentRecordsCount);
            If CurentRecordsCount > 11 Then
                PointTabelStrGrid.ColWidths[4] := (PointTabelStrGrid.Width * 19) Div 100
            Else
                MainForm.PointTabelStrGrid.ColWidths[4] := (MainForm.PointTabelStrGrid.Width * 21) Div 100;
            SortRecords();
            InputRecordsInTableGrid();
        End;
    End
    Else
        MessageBox(0, 'Необходимо выбрать строку для удаления!', 'Ошибка', MB_ICONERROR);
End;

Procedure TMainForm.SearchSpButtonClick(Sender: TObject);
Begin
    If (CurentRecordsCount <> 0) Then
    Begin
        Application.CreateForm(TSearchRecordForm, SearchRecordForm);
        SearchRecordForm.ShowModal;
    End
    Else
        MessageBox(0, 'Для поиска необходимо создать хотя-бы одну запись!', 'Ошибка', MB_ICONERROR);
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
