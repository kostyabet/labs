Program Project4_2;

Uses
    Vcl.Forms,
    MainUnit In 'MainUnit.pas' {MainForm} ,
    AboutEditorUnit In 'AboutEditorUnit.pas' {AboutEditor} ,
    InstractionUnit In 'InstractionUnit.pas' {Instraction} ,
    BackendUnit In 'BackendUnit.pas',
    FrontendUnit In 'FrontendUnit.pas';

{$R *.res}

Begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;

End.
