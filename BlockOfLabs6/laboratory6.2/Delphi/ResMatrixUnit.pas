Unit ResMatrixUnit;

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
    Vcl.StdCtrls,
    Vcl.ExtCtrls;

Type
    TForm1 = Class(TForm)
        ResultLabel: TLabel;
        ResWayPBox: TPaintBox;
        Procedure ResWayPBoxPaint(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Form1: TForm1;

Implementation

{$R *.dfm}

Uses
    BackendUnit;

Procedure TForm1.ResWayPBoxPaint(Sender: TObject);
Const
    StartX1: Integer = 50;
    StartY1: Integer = 50;
    StartX2: Integer = 150;
    StartY2: Integer = 150;
    BorderLength: Integer = 100;
Var
    I, J, X1, Y1, X2, Y2: Integer;
    BitMap: TBitmap;
    K: Integer;
Begin
    BitMap := TBitmap.Create();
    BitMap.Height := Form1.ClientHeight;
    BitMap.Width := Form1.ClientWidth;
    For I := Low(Matrix) To High(Matrix) Do
        For J := Low(Matrix[I]) To High(Matrix[I]) Do
        Begin
            X1 := I * BorderLength;
            Y1 := J * BorderLength;
            X2 := I * BorderLength;
            Y2 := J * BorderLength;

            Canvas.Brush.Color := ClWhite;
            For K := Low(ResWayCoords) To High(ResWayCoords) Do
                If (ResWayCoords[K][0] = I) And (ResWayCoords[K][1] = J) Then
                    Canvas.Brush.Color := ClSkyBlue;

            Canvas.Rectangle(StartX1 + X1, StartY1 + Y1, StartX2 + X2, StartY2 + Y2);

            Canvas.Font.Size := 14;
            Canvas.TextOut(StartX1 + X1 + BorderLength Div 2 - (Canvas.Font.Size Div 2) *
                (Length(IntToStr(Matrix[I][J])) - Ord(Not(Length(IntToStr(Matrix[I][J])) = 1))),
                StartY1 + Y1 + BorderLength Div 2 - Canvas.Font.Size, IntToStr(Matrix[I][J]));
        End;

    Canvas.Brush.Color := ClSkyBlue;
    Canvas.Font.Size := 10;
    For I := Low(Matrix) To High(Matrix) Do
        For J := Low(Matrix[I]) To High(Matrix[I]) Do
            For K := Low(ResWayCoords) To High(ResWayCoords) - 1 Do
                If (ResWayCoords[K][0] = I) And (ResWayCoords[K][1] = J) Then
                Begin
                    X1 := I * BorderLength;
                    Y1 := J * BorderLength;
                    X2 := I * BorderLength;
                    Y2 := J * BorderLength;

                    If (ResWayCoords[K][0] - ResWayCoords[K + 1][0] = 1) Then
                        Canvas.TextOut(StartX1 + X1 - 6, StartY1 + Y1 + 10, '←');
                    If (ResWayCoords[K][0] - ResWayCoords[K + 1][0] = -1) Then
                        Canvas.TextOut(StartX2 + X2 - 6, StartY1 + Y1 + 10, '→');
                    If (ResWayCoords[K][1] - ResWayCoords[K + 1][1] = 1) Then
                        Canvas.TextOut(StartX2 + X2 - 20, StartY1 + Y1 - 12, '↑');
                    If (ResWayCoords[K][1] - ResWayCoords[K + 1][1] = -1) Then
                        Canvas.TextOut(StartX2 + X2 - 20, StartY2 + Y2 - 12, '↓');
                End;
    BitMap.Free();
End;

End.
