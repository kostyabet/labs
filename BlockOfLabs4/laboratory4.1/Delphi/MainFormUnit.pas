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
        NavImageList: TImageList;
        MainMenu: TMainMenu;
        FileButton: TMenuItem;
        InstractionButton: TMenuItem;
        AboutEditorButton: TMenuItem;
        OpenButton: TMenuItem;
        SaveButton: TMenuItem;
        CupImage: TImage;
        AboutCupLabel: TLabel;
        PointTabelStrGrid: TStringGrid;
        BestFormLabel: TLabel;
        ExposureLabel: TLabel;
        StGridInfo: TLabel;
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure CloseButtonClick(Sender: TObject);
        Procedure StartButtonClick(Sender: TObject);
        Procedure ExitSpButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure AboutEditorButtonClick(Sender: TObject);
        Procedure InstractionButtonClick(Sender: TObject);
        Procedure AddSpButtonClick(Sender: TObject);
    Private
        { Private declarations }
        Procedure WMGetMinMaxInfo(Var Msg: TWMGetMinMaxInfo);
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;

Implementation

{$R *.dfm}

Uses
    WorkFormUnit,
    FrontendUnit,
    AddRecordUnit,
    BackendUnit;

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
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин', 410, 70);
End;

Procedure TMainForm.AddSpButtonClick(Sender: TObject);
Begin
    AddRecordForm.ShowModal;
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

    If ResultKey = ID_NO Then
        CanClose := False
    Else
        CanClose := True;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    PointTabelStrGrid.Cells[0, 0] := 'Место';
    PointTabelStrGrid.Cells[1, 0] := 'Страна';
    PointTabelStrGrid.Cells[2, 0] := 'Название команды';
    PointTabelStrGrid.Cells[3, 0] := 'Главный тренер';
    PointTabelStrGrid.Cells[4, 0] := 'Итоговый рейтинг';
    PointTabelStrGrid.Cells[0, 1] := '0';
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Begin
    CreateModalForm('Инструкция', 'Выполнил студент группы 351005 Бетеня Константин', 410, 700);
End;

Procedure TMainForm.StartButtonClick(Sender: TObject);
Begin
    WorkForm.ShowModal;
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
