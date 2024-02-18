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
        LoadImage: TImage;
        Procedure EndLoadingScreenTimer(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure AlphaBlendChangingTimer(Sender: TObject);
    End;

Const
    SIRCLE_HEIGHT: Integer = 500;
    SIRCLE_WIDTH: Integer = 500;

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
    HRgn := CreateEllipticRgn(0, 0, SIRCLE_HEIGHT, SIRCLE_WIDTH);
    SetWindowRgn(Handle, HRgn, False);

    EndLoadingScreen.Enabled := True;
    AlphaBlendChanging.Enabled := True;

    Left := (Screen.Width - Width) Div 2;
    Top := (Screen.Height - Height) Div 2;
End;

Procedure TLoadingScreen.AlphaBlendChangingTimer(Sender: TObject);
Const
    GROUGHT_ABV: Integer = 2;
    MAX_ALPHA_BLEND: Integer = 253;
Begin
    If LoadingScreen.AlphaBlendValue > MAX_ALPHA_BLEND Then
        AlphaBlendChanging.Enabled := False
    Else
        LoadingScreen.AlphaBlendValue := LoadingScreen.AlphaBlendValue + GROUGHT_ABV;
End;

Procedure TLoadingScreen.EndLoadingScreenTimer(Sender: TObject);
Begin
    EndLoadingScreen.Enabled := False;
End;

End.
