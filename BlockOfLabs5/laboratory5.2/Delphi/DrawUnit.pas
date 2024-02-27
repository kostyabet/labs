Unit DrawUnit;

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
    Vcl.ExtCtrls;

Type
    TDrawForm = Class(TForm)
        PaintBox1: TPaintBox;
        ScrollBox1: TScrollBox;
        Procedure PaintBox1Paint(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    DrawForm: TDrawForm;

Implementation

{$R *.dfm}

Uses
    BinaryTreeUnit;

Procedure DrawBinaryTree(Root: Node; X, Y, XOffset: Integer);
Const
    NodeRadius = 25;
Begin
    If Root = Nil Then Exit;
    DrawForm.PaintBox1.Canvas.Font.Size := 7;
    If Root.Left <> Nil Then Begin
        DrawForm.PaintBox1.Canvas.MoveTo(X, Y);
        DrawForm.PaintBox1.Canvas.LineTo(X - XOffset, Y + 60);
    End;
    DrawBinaryTree(Root.Left, X - XOffset, Y + 55, XOffset Div 2);
    If Root.Right <> Nil Then Begin
        DrawForm.PaintBox1.Canvas.MoveTo(X, Y);
        DrawForm.PaintBox1.Canvas.LineTo(X + XOffset, Y + 60);
    End;
    DrawForm.PaintBox1.Canvas.Ellipse(X - NodeRadius, Y - NodeRadius, X + NodeRadius, Y + NodeRadius);
    DrawForm.PaintBox1.Canvas.TextOut(X - 17, Y - 7, IntToStr(Root.Data));
    DrawBinaryTree(Root.Right, X + XOffset, Y + 60, XOffset Div 2);
End;

Procedure TDrawForm.PaintBox1Paint(Sender: TObject);
Var
    StartX, StartY: Integer;
Begin
    StartX := PaintBox1.Width Div 2;
    StartY := 30;
    DrawBinaryTree(BinaryTree, StartX, StartY, PaintBox1.Width Div 5);
End;

End.
