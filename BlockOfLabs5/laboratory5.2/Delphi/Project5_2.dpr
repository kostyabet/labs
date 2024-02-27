program Project5_2;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  FrontendUnit in 'FrontendUnit.pas',
  BackendUnit in 'BackendUnit.pas',
  BinaryTreeUnit in 'BinaryTreeUnit.pas',
  Vcl.Themes,
  Vcl.Styles,
  DrawUnit in 'DrawUnit.pas' {DrawForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDrawForm, DrawForm);
  Application.Run;
end.
