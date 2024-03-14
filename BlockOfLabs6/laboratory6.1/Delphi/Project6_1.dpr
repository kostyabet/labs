program Project6_1;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {ClockForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TClockForm, ClockForm);
  Application.Run;
end.
