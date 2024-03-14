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
    Vcl.ExtCtrls,
    Vcl.Menus,
    Vcl.Buttons,
    DateUtils, Vcl.MPlayer;

Type
    TClockForm = Class(TForm)
        MainMenu: TMainMenu;
        SecondTimer: TTimer;
        ClockStartSpeedButton: TSpeedButton;
        N1: TMenuItem;
        Exit: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
    MediaPlayer1: TMediaPlayer;
        Procedure ClockStartSpeedButtonClick(Sender: TObject);
        Procedure SecondTimerTimer(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    ClockForm: TClockForm;
    SecAngle, MinAngle, HourAngle: Double;
    MinSleep: Integer = 0;
    
Implementation

{$R *.dfm}

Procedure TClockForm.ClockStartSpeedButtonClick(Sender: TObject);
Begin
    SecondTimer.Enabled := True;
    ClockStartSpeedButton.Enabled := False;
    SecAngle := -Pi / 2;
    MinAngle := -Pi / 2;
    HourAngle := -Pi / 2;
    MediaPlayer1.Open;
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

Procedure TClockForm.SecondTimerTimer(Sender: TObject);
Var
    BitMap: TBitmap;
    X, Y, LenMinute, LenSec, LenHour: Integer;
    I: Integer;
    Angle: Real;
Begin
    X := ClockForm.ClientWidth Div 2;
    LenSec := 180;
    LenMinute := 150;
    LenHour := 120;
    Y := ClockForm.ClientHeight Div 2;
    BitMap := TBitmap.Create();
    BitMap.Height := ClockForm.ClientHeight;
    BitMap.Width := ClockForm.ClientWidth;

    BitMap.Canvas.Pen.Width := 6;
    BitMap.Canvas.MoveTo(X, Y);
    BitMap.Canvas.Ellipse(X - 215, Y - 215, X + 215, Y + 215);

    Angle := -Pi / 2;
    For I := 1 To 12 Do
    Begin
        BitMap.Canvas.Pen.Width := 15;
        Angle := Angle + Pi / 6;
        BitMap.Canvas.MoveTo(X + Trunc(210 * Cos(Angle)), Y + Trunc(210 * Sin(Angle)));
        BitMap.Canvas.LineTo(X + Trunc(210 * Cos(Angle)), Y + Trunc(210 * Sin(Angle)));
    End;

    BitMap.Canvas.MoveTo(X, Y);

    BitMap.Canvas.Pen.Color := ClBlack;
    BitMap.Canvas.Pen.Width := 20;
    BitMap.Canvas.LineTo(X + Trunc(LenHour * Cos(HourAngle)), Y + Trunc(LenHour * Sin(HourAngle)));

    BitMap.Canvas.MoveTo(X, Y);

    BitMap.Canvas.Pen.Color := ClGray;
    BitMap.Canvas.Pen.Width := 12;
    BitMap.Canvas.LineTo(X + Trunc(LenMinute * Cos(MinAngle)), Y + Trunc(LenMinute * Sin(MinAngle)));

    BitMap.Canvas.MoveTo(X, Y);

    BitMap.Canvas.Pen.Color := ClRed;
    BitMap.Canvas.Pen.Width := 5;
    BitMap.Canvas.LineTo(X + Trunc(LenSec * Cos(SecAngle)), Y + Trunc(LenSec * Sin(SecAngle)));

    SecAngle := SecAngle + Pi / 180 * 6;
    MediaPlayer1.Play;
    If CompareFirstFourDigits(SecAngle, (3 * Pi) / 2) Then
        SecAngle := -Pi / 2;

    If CompareFirstFourDigits(SecAngle, MinAngle) And (MinSleep <> 1) Then
    begin
        MinAngle := MinAngle + Pi / 180 * 6;
        Inc(MinSleep);
    end
    else MinSleep := 0;
    
    If CompareFirstFourDigits(MinAngle, (3 * Pi) / 2) Then
        MinAngle := - Pi / 2;
        
    If CompareFirstFourDigits(SecAngle, HourAngle) Then
        HourAngle := HourAngle + Pi / 180 * 360 / 12 / 60;
    If CompareFirstFourDigits(HourAngle, (3 * Pi) / 2) Then
        MinAngle := - Pi / 2;

    ClockForm.Canvas.Draw(0, 0, BitMap);
    BitMap.Free();
End;

End.
