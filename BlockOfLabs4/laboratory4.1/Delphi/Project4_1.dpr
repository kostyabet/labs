Program Project4_1;

Uses
    Windows,
    Vcl.ExtCtrls,
    Vcl.Forms,
    MainFormUnit In 'MainFormUnit.pas' {MainForm} ,
    Vcl.Themes,
    Vcl.Styles,
    LoadingScreenUnit In 'LoadingScreenUnit.pas' {LoadingScreen} ,
    FrontendUnit In 'FrontendUnit.pas',
    AddRecordUnit In 'AddRecordUnit.pas' {AddRecordForm} ,
    BackendUnit In 'BackendUnit.pas' {/ChangeRecordUnit in 'ChangeRecordUnit.pas' {ChangeRecordForm} ,
    ChangeRecordUnit In 'ChangeRecordUnit.pas' {ChangeRecordForm} ,
    SearchRecordUnit In 'SearchRecordUnit.pas' {SearchRecordForm};

{$R *.res}

Begin
    Application.Initialize;
    Application.MainFormOnTaskbar := False;
    TStyleManager.TrySetStyle('Silver');
    Application.CreateForm(TMainForm, MainForm);
    MainForm.Visible := False;

    LoadingScreen := TLoadingScreen.Create(Application);
    LoadingScreen.Show;
    While LoadingScreen.EndLoadingScreen.Enabled Do
        Application.ProcessMessages;
    LoadingScreen.Hide;
    LoadingScreen.Free;

    MainForm.Visible := True;
    Application.Run;

End.
