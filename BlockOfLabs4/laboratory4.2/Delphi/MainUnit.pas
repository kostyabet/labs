Unit MainUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Menus,
    Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

Type
    TMainForm = Class(TForm)
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        MainMenu: TMainMenu;
        TaskLabel: TLabel;
    FileButton: TMenuItem;
    OpenButton: TMenuItem;
    SaveButton: TMenuItem;
    ExitButton: TMenuItem;
    InstractionButton: TMenuItem;
    AboutEditorButton: TMenuItem;
    DemarcationLine: TMenuItem;
    ALabeledEdit: TLabeledEdit;
    NLabeledEdit: TLabeledEdit;
    ALabel: TLabel;
    NLabel: TLabel;
        Procedure AboutEditorButtonClick(Sender: TObject);
        Procedure InstractionButtonClick(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ALabeledEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure NLabeledEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    MIN_INT_NUM = -200_000_000;
    MAX_INT_NUM = +200_000_000;
    MIN_N = 1;
    MAX_N = 20;

Var
    MainForm: TMainForm;

Implementation

{$R *.dfm}

Uses
    AboutEditorUnit,
    InstractionUnit, BackendUnit;

procedure TMainForm.ALabeledEditContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    Handled := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    ALabeledEdit.EditLabel.Caption := '';
    ALabeledEdit.Hint := '[' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + ']';
    NLabeledEdit.EditLabel.Caption := '';
    NLabeledEdit.Hint := '[' + IntToStr(MIN_N) + '; ' + IntToStr(MAX_N) + ']';
end;

Procedure TMainForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
    If Key = VK_F1 Then
        Instraction.ShowModal;
End;

Procedure TMainForm.InstractionButtonClick(Sender: TObject);
Begin
    Instraction.ShowModal;
End;

procedure TMainForm.NLabeledEditContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    Handled := False;
end;

Procedure TMainForm.AboutEditorButtonClick(Sender: TObject);
Begin
    AboutEditor.ShowModal;
End;

End.
