unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileBox: TMenuItem;
    OpenFromFile: TMenuItem;
    SaveInFile: TMenuItem;
    Line: TMenuItem;
    CloseButton: TMenuItem;
    Instraction: TMenuItem;
    AboutEditor: TMenuItem;
    TaskLabel: TLabel;
    MatrixSizeLabel: TLabel;
    MRowsLEdit: TLabeledEdit;
    NColsLEdit: TLabeledEdit;
    SpeedButton1: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

end.
