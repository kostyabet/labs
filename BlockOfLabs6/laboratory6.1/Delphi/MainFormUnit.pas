Unit MainFormUnit;

Interface

Uses
    Winapi.Windows,
    System.SysUtils,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.ExtCtrls,
    Vcl.Menus,
    Vcl.Buttons,
    Vcl.MPlayer,
    Vcl.StdCtrls,
    DateUtils;

Type
    TClockForm = Class(TForm)
        MainMenu: TMainMenu;
        SecondTimer: TTimer;
        ClockStartSpeedButton: TSpeedButton;
        FileList: TMenuItem;
        Exit: TMenuItem;
        Instraction: TMenuItem;
        AboutEditor: TMenuItem;
        PickPlayer: TMediaPlayer;
        Procedure ClockStartSpeedButtonClick(Sender: TObject);
        Procedure SecondTimerTimer(Sender: TObject);
        Procedure InstractionClick(Sender: TObject);
        Procedure AboutEditorClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    StartAngle: Double = -Pi / 2;
    ThrowOffAngle: Double = 3 * Pi / 2;
    LenSec: Integer = 180;
    LenMinute: Integer = 150;
    LenHour: Integer = 120;

Var
    ClockForm: TClockForm;
    SecAngle, MinAngle, HourAngle: Double;
    MinSleep: Integer = 0;
    X, Y: Integer;

Implementation

{$R *.dfm}

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Const
    LEFT_MARGIN: Integer = 10;
    TOP_MARGIN: Integer = 5;
Var
    ModalForm: TForm;
    ModalLabel: TLAbel;
Begin
    ModalForm := TForm.Create(Nil);
    Try
        ModalForm.Caption := CaptionText;
        ModalForm.Width := ModalWidth;
        ModalForm.Height := ModalHeight;
        ModalForm.Position := PoScreenCenter;
        ModalForm.BorderStyle := BsSingle;
        ModalForm.BorderIcons := [BiSystemMenu];
        ModalForm.FormStyle := FsStayOnTop;
        ModalForm.Icon := ClockForm.Icon;
        ModalLabel := TLabel.Create(ModalForm);
        ModalLabel.Parent := ModalForm;
        ModalLabel.Caption := LabelText;
        ModalLabel.Left := LEFT_MARGIN;
        ModalLabel.Top := TOP_MARGIN;
        ModalForm.ShowModal;
    Finally
        ModalForm.Free;
    End;
End;

Procedure TClockForm.ExitClick(Sender: TObject);
Begin
    ClockForm.Close;
End;

Procedure TClockForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ResultKey: Integer;
Begin
    ResultKey := Application.Messagebox('Вы уверены, что хотите закрыть оконное приложение?', 'Выход',
        MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);

    If ResultKey = ID_NO Then
        CanClose := False;
End;

Procedure TClockForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If (Key = VK_RETURN) Then
        ClockStartSpeedButtonClick(Sender);
End;

Procedure TClockForm.InstractionClick(Sender: TObject);
Var
    InstractionText: String;
Begin
    InstractionText := 'Нажмите на кнопку ''' + ClockStartSpeedButton.Caption + '''.';
    CreateModalForm('Инструкция', InstractionText, Screen.Width * 18 Div 100, Screen.Height * 8 Div 100);
End;

Procedure TClockForm.AboutEditorClick(Sender: TObject);
Begin
    CreateModalForm('О разработчике', 'Выполнил студент группы 351005 Бетеня Константин.', Screen.Width * 22 Div 100,
        Screen.Height * 8 Div 100);
End;

Procedure TClockForm.ClockStartSpeedButtonClick(Sender: TObject);
Begin
    SecondTimer.Enabled := True;
    ClockStartSpeedButton.Enabled := False;
    SecAngle := Pi / 180 * (SecondOf(Now) + 2) * 6 - Pi / 2;
    MinAngle := Pi / 180 * MinuteOf(Now) * 6 - Pi / 2;
    HourAngle := Pi / 180 * HourOf(Now) * 360 / 12 - Pi / 2;
    PickPlayer.Open;
    X := ClockForm.ClientWidth Div 2;
    Y := ClockForm.ClientHeight Div 2;
End;

Function CompareFirstFourDigits(Num1, Num2: Extended): Boolean;
Var
    Str1, Str2: String;
Begin
    Str1 := FloatToStr(Num1);
    Str2 := FloatToStr(Num2);

    If Pos('.', Str1) > 0 Then
        Str1 := Copy(Str1, 1, Pos('.', Str1) - 1);
    If Pos('.', Str2) > 0 Then
        Str2 := Copy(Str2, 1, Pos('.', Str2) - 1);

    Result := Copy(Str1, 1, 4) = Copy(Str2, 1, 4);
End;

Procedure DrawClock(Canvas: TCanvas);
Const
    DotsRadius: Integer = 198;
    OuterRadius: Integer = 215;
    OuterWidth: Integer = 6;
    InnerRadius: Integer = 205;
    InnerWidth: Integer = 4;
    HourCounter: Integer = 12;
    IncAngle: Double = Pi / 6;
    AngleWidth: Integer = 5;
Var
    Angle: Real;
    I: Integer;
Begin
    Canvas.Pen.Color := ClBlue;
    Canvas.Pen.Width := OuterWidth;
    Canvas.MoveTo(X, Y);
    Canvas.Ellipse(X - OuterRadius, Y - OuterRadius, X + OuterRadius, Y + OuterRadius);

    Canvas.Pen.Color := ClBlack;
    Canvas.Pen.Width := InnerWidth;
    Canvas.MoveTo(X, Y);
    Canvas.Ellipse(X - InnerRadius, Y - InnerRadius, X + InnerRadius, Y + InnerRadius);

    Canvas.Pen.Color := ClBlue;
    Angle := StartAngle;
    For I := 1 To HourCounter Do
    Begin
        Canvas.Pen.Width := AngleWidth;
        Angle := Angle + IncAngle;
        Canvas.MoveTo(X + Trunc(DotsRadius * Cos(Angle)), Y + Trunc(DotsRadius * Sin(Angle)));
        Canvas.LineTo(X + Trunc(DotsRadius * Cos(Angle)), Y + Trunc(DotsRadius * Sin(Angle)));
    End;
End;

Procedure DrawArrows(Canvas: TCanvas);
Const
    HourWidth: Integer = 10;
    MinWidth: Integer = 5;
    SecWidth: Integer = 2;
    RivetRadius: Integer = 5;
Begin
    Canvas.Pen.Color := ClBlack;
    Canvas.Pen.Width := HourWidth;
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(X + Trunc(LenHour * Cos(HourAngle)), Y + Trunc(LenHour * Sin(HourAngle)));

    Canvas.Pen.Color := ClBlack;
    Canvas.Pen.Width := MinWidth;
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(X + Trunc(LenMinute * Cos(MinAngle)), Y + Trunc(LenMinute * Sin(MinAngle)));

    Canvas.Pen.Color := ClRed;
    Canvas.Pen.Width := SecWidth;
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(X + Trunc(LenSec * Cos(SecAngle)), Y + Trunc(LenSec * Sin(SecAngle)));

    Canvas.Pen.Color := ClBlue;
    Canvas.MoveTo(X, Y);
    Canvas.Ellipse(X - RivetRadius, Y - RivetRadius, X + RivetRadius, Y + RivetRadius);
End;

Procedure ChangeTheTurnsOfTheArrow();
Const
    IncSecMinAngle: Double = Pi / 180 * 6;
    HourSecAngle: Double = Pi / 180 * 360 / 12 / 60;
Var
    RealComparisonStatus: Boolean;
Begin
    SecAngle := SecAngle + IncSecMinAngle;
    ClockForm.PickPlayer.Play;
    RealComparisonStatus := CompareFirstFourDigits(SecAngle, ThrowOffAngle);
    If RealComparisonStatus Then
        SecAngle := StartAngle;

    RealComparisonStatus := CompareFirstFourDigits(SecAngle, MinAngle);
    If RealComparisonStatus And (MinSleep <> 1) Then
    Begin
        MinAngle := MinAngle + IncSecMinAngle;
        Inc(MinSleep);
    End
    Else
        MinSleep := 0;
    RealComparisonStatus := CompareFirstFourDigits(MinAngle, ThrowOffAngle);
    If RealComparisonStatus Then
        MinAngle := StartAngle;

    RealComparisonStatus := CompareFirstFourDigits(SecAngle, HourAngle);
    If RealComparisonStatus Then
        HourAngle := HourAngle + HourSecAngle;
    RealComparisonStatus := CompareFirstFourDigits(HourAngle, ThrowOffAngle);
    If RealComparisonStatus Then
        MinAngle := StartAngle;
End;

Procedure TClockForm.SecondTimerTimer(Sender: TObject);
Var
    BitMap: TBitmap;
Begin
    BitMap := TBitmap.Create();
    BitMap.Height := ClockForm.ClientHeight;
    BitMap.Width := ClockForm.ClientWidth;
    DrawClock(BitMap.Canvas);
    DrawArrows(BitMap.Canvas);
    ChangeTheTurnsOfTheArrow();
    ClockForm.Canvas.Draw(0, 0, BitMap);
    BitMap.Free();
End;

End.
