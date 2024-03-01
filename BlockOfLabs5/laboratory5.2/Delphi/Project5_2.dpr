Program Project5_2;

Uses
    Vcl.Forms,
    MainFormUnit In 'MainFormUnit.pas' {MainForm} ,
    FrontendUnit In 'FrontendUnit.pas',
    BackendUnit In 'BackendUnit.pas',
    Vcl.Themes,
    Vcl.Styles,
    DrawUnit In 'DrawUnit.pas' {DrawForm} ,
    TreeUnit In 'TreeUnit.pas';

{$R *.res}

Begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TDrawForm, DrawForm);
    Application.Run;

End.
