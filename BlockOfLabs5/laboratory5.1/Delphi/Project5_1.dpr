Program Project5_1;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  DoubleLinkedList in 'DoubleLinkedList.pas',
  AddValueUnit in 'AddValueUnit.pas' {AddValueForm},
  FrontendUnit in 'FrontendUnit.pas',
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
