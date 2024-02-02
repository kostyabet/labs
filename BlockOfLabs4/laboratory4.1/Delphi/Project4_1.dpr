program Project4_1;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  WorkFormUnit in 'WorkFormUnit.pas' {WorkForm},
  FrontendUnit in 'FrontendUnit.pas',
  AddRecordUnit in 'AddRecordUnit.pas' {AddRecordForm},
  BackendUnit in 'BackendUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWorkForm, WorkForm);
  Application.CreateForm(TAddRecordForm, AddRecordForm);
  Application.Run;
end.
