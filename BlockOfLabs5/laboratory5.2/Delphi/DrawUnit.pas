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
        TreeScrlB: TScrollBox;
        TreePBox: TPaintBox;
        Procedure TreePBoxPaint(Sender: TObject);
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
    TreeUnit;

Procedure TDrawForm.TreePBoxPaint(Sender: TObject);
Begin
    DrawTree(TreePBox);
End;

End.
