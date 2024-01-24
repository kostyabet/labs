program Proj4_2;

uses
  Vcl.Forms,
  Project4_2 in 'Project4_2.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
