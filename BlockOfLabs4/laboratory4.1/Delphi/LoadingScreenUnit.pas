Unit LoadingScreenUnit;

Interface

Uses
    Winapi.Windows,
    Vcl.Forms,
    Vcl.ExtCtrls,
    Vcl.Imaging.Jpeg,
    System.Classes,
    Vcl.Controls;

Type
    TLoadingScreen = Class(TForm)
        EndLoadingScreen: TTimer;
        AlphaBlendChanging: TTimer;
        Image1: TImage;
        Procedure EndLoadingScreenTimer(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure AlphaBlendChangingTimer(Sender: TObject);
    End;

Var
    LoadingScreen: TLoadingScreen;

Implementation

{$R *.dfm}

Uses
    MainFormUnit;

Procedure TLoadingScreen.FormCreate(Sender: TObject);
Var
    HRgn: Cardinal;
Begin
    HRgn := CreateEllipticRgn(0, 0, 500, 500);
    SetWindowRgn(Handle, HRgn, False);

    EndLoadingScreen.Enabled := True;
    AlphaBlendChanging.Enabled := True;

    Left := (Screen.Width - Width) Div 2;
    Top := (Screen.Height - Height) Div 2;
End;

Procedure TLoadingScreen.AlphaBlendChangingTimer(Sender: TObject);
Begin
    If LoadingScreen.AlphaBlendValue > 253 Then
        AlphaBlendChanging.Enabled := False
    Else
        LoadingScreen.AlphaBlendValue := LoadingScreen.AlphaBlendValue + 2;
End;

Procedure TLoadingScreen.EndLoadingScreenTimer(Sender: TObject);
Begin
    EndLoadingScreen.Enabled := False;
End;

End.
