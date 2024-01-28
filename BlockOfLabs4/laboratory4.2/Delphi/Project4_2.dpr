program Project4_2;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  AboutEditorUnit in 'AboutEditorUnit.pas' {AboutEditor},
  InstractionUnit in 'InstractionUnit.pas' {Instraction},
  BackendUnit in 'BackendUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutEditor, AboutEditor);
  Application.CreateForm(TInstraction, Instraction);
  Application.Run;
end.
