Program Project5_1;

Uses
    Vcl.Forms,
    MainFormUnit In 'MainFormUnit.pas' {MainForm} ,
    AddValueUnit In 'AddValueUnit.pas' {AddValueForm} ,
    FrontendUnit In 'FrontendUnit.pas',
    Vcl.Themes,
    Vcl.Styles;

{$R *.res}

Begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Silver');
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;

End.
