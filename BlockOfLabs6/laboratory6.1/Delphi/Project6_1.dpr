program Project6_1;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
