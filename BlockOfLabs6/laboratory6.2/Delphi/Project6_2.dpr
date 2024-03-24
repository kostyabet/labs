Program Project6_2;

Uses
    Vcl.Forms,
    MainUnit In 'MainUnit.pas' {MainForm} ,
    Vcl.Themes,
    Vcl.Styles,
    FrontendUnit In 'FrontendUnit.pas',
    BackendUnit In 'BackendUnit.pas',
    ResMatrixUnit In 'ResMatrixUnit.pas' {Form1};

{$R *.res}

Begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Silver');
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;

End.
