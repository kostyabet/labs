Unit MainUnit;

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
    Vcl.Menus,
    Vcl.StdCtrls;

Type
    TMainForm = Class(TForm)
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        MainMenu: TMainMenu;
        TaskLabel: TLabel;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        Procedure N7Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    MIN_INT_NUM = -200_000_000;
    MAX_INT_NUM = +200_000_000;
    MIN_N = 1;
    MAX_N = 20;

Var
    MainForm: TMainForm;

Implementation

{$R *.dfm}

Uses
    AboutEditorUnit,
    InstractionUnit;

Procedure TMainForm.N6Click(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

Procedure TMainForm.N7Click(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
