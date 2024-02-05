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
    Vcl.Imaging.Jpeg,
    Vcl.Imaging.Pngimage,
    System.ImageList,
    Vcl.ImgList,
    Vcl.BaseImageCollection,
    Vcl.ImageCollection,
    Vcl.Menus,
    Vcl.Grids;

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
        SaveButton: TMenuItem;
        CupImage: TImage;
        AboutCupLabel: TLabel;
        PointTabelStrGrid: TStringGrid;
        BestFormLabel: TLabel;
        ExposureLabel: TLabel;
        StGridInfo: TLabel;
        N1: TMenuItem;
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
        Procedure PointTabelStrGridClick(Sender: TObject);
        Procedure RemoveSpButtonClick(Sender: TObject);
        Procedure SearchSpButtonClick(Sender: TObject);
    Private
        { Private declarations }
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

Procedure CreateFrmCustomInfo(Var FrmCustomInfo: TForm);
Begin
    FrmCustomInfo := TForm.Create(Nil);
    FrmCustomInfo.Caption := '';
    FrmCustomInfo.BorderStyle := BsSingle;
    FrmCustomInfo.BorderIcons := [BiSystemMenu];
    FrmCustomInfo.Position := PoScreenCenter;
    FrmCustomInfo.FormStyle := FsStayOnTop;
    FrmCustomInfo.Width := 1301;
    FrmCustomInfo.Height := 992;
End;

Procedure TMainForm.AboutEditorButtonClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин', 405, 60);
End;

Procedure TMainForm.AddSpButtonClick(Sender: TObject);
Begin
    Application.CreateForm(TAddRecordForm, AddRecordForm);
    AddRecordForm.ShowModal;
End;

Procedure TMainForm.ChangeSpButtonClick(Sender: TObject);
Begin
    CurentRow := MainForm.PointTabelStrGrid.Row;

    If (CurentRow <> 0) Then
    Begin
        Application.CreateForm(TChangeRecordForm, ChangeRecordForm);

        ChangeRecordForm.CountryLabeledEdit.Text := FootballTable[CurentRow - 1].Country;
        ChangeRecordForm.TeamNameLabeledEdit.Text := FootballTable[CurentRow - 1].Team;
        ChangeRecordForm.CoachLabeledEdit.Text := FootballTable[CurentRow - 1].Coach;
        ChangeRecordForm.PointsLabeledEdit.Text := IntToStr(FootballTable[CurentRow - 1].Points);

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
        CanClose := True
    Else
        CanClose := False;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    PointTabelStrGrid.Cells[0, 0] := 'Место';
    PointTabelStrGrid.Cells[1, 0] := 'Страна';
    PointTabelStrGrid.Cells[2, 0] := 'Название команды';
    PointTabelStrGrid.Cells[3, 0] := 'Главный тренер';
    PointTabelStrGrid.Cells[4, 0] := 'Итоговый рейтинг';
    PointTabelStrGridClick(Sender);
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Var
    InstractionText: String;
Begin
    InstractionText := 'Инструкция:' + 
    #13#10 + '1. Чтобы добавить новую запись нажмите на кнопку ' + 
    #13#10 + '    ''' + AddSpButton.Caption + ''';' +
    #13#10 + '2. Если вы хотите изменить какую-то запись, то' + 
    #13#10 + '    выберите необходимую строку для изменения и' +
    #13#10 + '    нажимайте на кнопку ''' + ChangeSpButton.Caption + ''';' + 
    #13#10 + '3. Если у вас много записей и вы потерялись, то' + 
    #13#10 + '    нажмите на кнопку ''' + SearchSpButton.Caption + '''. Там вы можете выбрать' +
    #13#10 + '    удобный вам критерий для поиска и даже сразу' +
    #13#10 + '    изменить эту запись;' +
    #13#10 + '4. Если запись необходимо убрать из турнирной' +
    #13#10 + '    таблицы, то нажмите на кнопку ''' + RemoveSpButton.Caption + '''. Для этого' + 
    #13#10 + '    так же необходимо заранее выбрать нужную строку.' + #13#10 +
    #13#10 + 'Если вы хотите выйти, то у вас есть много' + 
    #13#10 + 'вариантов, как это сделать:' +
    #13#10 + ' - Сочетание клавишь Alt + F4;' +
    #13#10 + ' - Сочетание клавишь Ctrl + Q;' +
    #13#10 + ' - Выбрать кнопку ''' + ExitSpButton.Caption + ''' в левом меню;' +
    #13#10 + ' - Во вкладке ' + FileButton.Caption + ' пункт ''' + CloseButton.Caption + ''';' +
    #13#10 + #13#10 + 'Работа с файлами: ' +
    #13#10 + '  временно отсутствует информация...' + #13#10 +
    #13#10 + 'В любой форме вы можете обратится к справке' +
    #13#10 + 'нажав клавишу F1 или выбрав её в верхем меню.' +
    #13#10 + #13#10 + 'В турнирной таблице записи упорядочены по' + 
    #13#10 + 'убыванию рейтинга команд. В случае когда набрано' + 
    #13#10 + 'одинаковое кол-во очков, первой будет идти'+
    #13#10 + 'команда, которая была записана в таблицу раньше.';

    
    CreateModalForm('Инструкция', InstractionText, 420, 665);
End;

Procedure TMainForm.PointTabelStrGridClick(Sender: TObject);
Begin
    PointTabelStrGrid.Selection := TGridRect(Rect(0, PointTabelStrGrid.Row, PointTabelStrGrid.ColCount, PointTabelStrGrid.Row));
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
            DeleteRow(CurentRow - 1);
    End
    Else
        MessageBox(0, 'Выберите строку для удаления!', 'Ошибка', MB_ICONERROR);
End;

Procedure TMainForm.SearchSpButtonClick(Sender: TObject);
Begin
    If (Length(FootballTable) <> 0) Then
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
