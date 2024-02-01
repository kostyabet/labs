Unit WorkFormUnit;

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
    Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

Type
    TWorkForm = Class(TForm)
    WellComeLabel: TLabel;
    CupImage: TImage;
    TMLabel: TLabel;
    GoalkeeperImage: TImage;
    StartButton: TButton;
    ReferenceButton: TButton;
    CloseButton: TButton;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    WorkForm: TWorkForm;

Implementation

{$R *.dfm}

End.
