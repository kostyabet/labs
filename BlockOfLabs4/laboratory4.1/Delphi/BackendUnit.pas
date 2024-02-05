Unit BackendUnit;

Interface

Uses
    System.Math,
    Clipbrd,
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
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.Grids,
    Vcl.ExtCtrls;

Type
    TString = Array [1 .. 20] Of WideChar;

    TFootballStats = Record
        Country: TString;
        Team: TString;
        Coach: TString;
        Points: Integer;
    End;

Const
    TEAMS_COUNT = 48;

Type
    TMassive = Array Of Integer;
    TFootballMassive = Array [0 .. TEAMS_COUNT] Of TFootballStats;
    TFStatsFile = File Of TFootballStats;

Procedure InputDataInMassive(Country, Team, Coach: TString; Points: Integer; CurentRow: Integer);
Procedure InputMassiveInTableGrid();
Procedure InputInfoFromGrid(Var CountryLabeledEdit, TeamNameLabeledEdit, CoachLabeledEdit, PointsLabeledEdit: TLabeledEdit; I: Integer);
Procedure SortFootballStats();
Procedure DeleteRow(I: Integer);
Function IndexRecord(I: Integer; CurentStr: TString): Integer;
Function CreateResultGrid(StrIndex: Integer): String;
Procedure LoadRecordsInFile();
Procedure LoadRecordsFromFile();
Function ConvertStringToWideChar(SourceString: String): TString;
Function WideCharToStr(SourceWideChar: TString): String;

Var
    FootballTable: TFootballMassive;
    CurentRecordsCount: Integer = 0;
    StatsFile: TFStatsFile;

Implementation

Uses
    MainFormUnit,
    FrontendUnit;

Procedure InputDataInMassive(Country, Team, Coach: TString; Points: Integer; CurentRow: Integer);
Begin
    FootballTable[CurentRow].Country := Country;
    FootballTable[CurentRow].Team := Team;
    FootballTable[CurentRow].Coach := Coach;
    FootballTable[CurentRow].Points := Points;
End;

Procedure InputMassiveInTableGrid();
Var
    I: Integer;
Begin
    MainForm.PointTabelStrGrid.RowCount := CurentRecordsCount + 1;

    For I := 1 To High(FootballTable) + 2 Do
        If Not(I - 1 > High(FootballTable)) Then
            InputInCurentRow(I, FootballTable[I - 1].Country, FootballTable[I - 1].Team, FootballTable[I - 1].Coach,
                FootballTable[I - 1].Points);
End;

Procedure InputInfoFromGrid(Var CountryLabeledEdit, TeamNameLabeledEdit, CoachLabeledEdit, PointsLabeledEdit: TLabeledEdit; I: Integer);
Begin
    If Not(I - 1 > High(FootballTable)) Then
    Begin
        CountryLabeledEdit.Text := FootballTable[I - 1].Country;
        TeamNameLabeledEdit.Text := FootballTable[I - 1].Team;
        CoachLabeledEdit.Text := FootballTable[I - 1].Coach;
        PointsLabeledEdit.Text := IntToStr(FootballTable[I - 1].Points);
    End;
End;

Procedure SortFootballStats();
Var
    TempP, I, J: Integer;
    TempT, TempCh, TempCy: TString;
Begin
    For I := 1 To High(FootballTable) Do
    Begin
        TempP := FootballTable[I].Points;
        TempT := FootballTable[I].Team;
        TempCh := FootballTable[I].Coach;
        TempCy := FootballTable[I].Country;

        J := I - 1;
        While (J >= 0) And (FootballTable[J].Points < TempP) Do
        Begin
            FootballTable[J + 1].Points := FootballTable[J].Points;
            FootballTable[J + 1].Team := FootballTable[J].Team;
            FootballTable[J + 1].Coach := FootballTable[J].Coach;
            FootballTable[J + 1].Country := FootballTable[J].Country;

            FootballTable[J].Points := TempP;
            FootballTable[J].Team := TempT;
            FootballTable[J].Coach := TempCh;
            FootballTable[J].Country := TempCy;

            Dec(J);
        End;
    End;
End;

Procedure DeleteRow(I: Integer);
Begin
    Dec(CurentRecordsCount);
    While Not(I > High(FootballTable) - 1) Do
    Begin
        FootballTable[I].Country := FootballTable[I + 1].Country;
        FootballTable[I].Team := FootballTable[I + 1].Team;
        FootballTable[I].Coach := FootballTable[I + 1].Coach;
        FootballTable[I].Points := FootballTable[I + 1].Points;
        Inc(I);
    End;
    InputMassiveInTableGrid();
End;

Function IndexRecord(I: Integer; CurentStr: TString): Integer;
Var
    J: Integer;
Begin
    IndexRecord := -1;
    Case I Of
        0:
            Begin
                For J := Low(FootballTable) To High(FootballTable) Do
                    If (FootballTable[J].Country = CurentStr) Then
                    Begin
                        IndexRecord := J;
                        Exit;
                    End;
            End;
        1:
            Begin
                For J := Low(FootballTable) To High(FootballTable) Do
                    If (FootballTable[J].Team = CurentStr) Then
                    Begin
                        IndexRecord := J;
                        Exit;
                    End;
            End;
        2:
            Begin
                For J := Low(FootballTable) To High(FootballTable) Do
                    If (FootballTable[J].Coach = CurentStr) Then
                    Begin
                        IndexRecord := J;
                        Exit;
                    End;
            End;
        3:
            Begin
                For J := Low(FootballTable) To High(FootballTable) Do
                    If (IntToStr(FootballTable[J].Points) = WideCharToStr(CurentStr)) Then
                    Begin
                        IndexRecord := J;
                        Exit;
                    End;
            End;
    End;
End;

Function CreateResultGrid(StrIndex: Integer): String;
Var
    ResStr: String;
Begin
    ResStr := 'Страна: ' + WideCharToStr(FootballTable[StrIndex].Country) + ';'#13#10;
    ResStr := ResStr + 'Название команды: ' + WideCharToStr(FootballTable[StrIndex].Team) + ';'#13#10;
    ResStr := ResStr + 'Главный Тренер: ' + WideCharToStr(FootballTable[StrIndex].Coach) + ';'#13#10;
    ResStr := ResStr + 'Итоговый результат:' + IntToStr(FootballTable[StrIndex].Points);

    CreateResultGrid := ResStr;
End;

Procedure LoadRecordsInFile();
Var
    FileStream: TFileStream;
    I: Integer;
Begin
    AssignFile(StatsFile, 'myFile.txt');

    Rewrite(StatsFile);

    For I := 0 To CurentRecordsCount - 1 Do
    Begin
        Write(StatsFile, FootballTable[I]);
    End;

    CloseFile(StatsFile);
End;

Procedure LoadRecordsFromFile();
Var
    I: Integer;
Begin
    I := 0;
    AssignFile(StatsFile, 'myFile.txt');
    Reset(StatsFile);
    While Not EOF(StatsFile) Do
    Begin
        Read(StatsFile, FootballTable[I]);
        Inc(I);
    End;
    CloseFile(StatsFile);

    CurentRecordsCount := I;
    SortFootballStats();
    InputMassiveInTableGrid();
End;

Function ConvertStringToWideChar(SourceString: String): TString;
Var
    DestArray: TString;
    NumCharsToCopy, I: Integer;
Begin
    NumCharsToCopy := Min(Length(SourceString), SizeOf(DestArray) Div SizeOf(WideChar) - 1);

    For I := 1 To NumCharsToCopy Do
        DestArray[I] := WideChar(SourceString[I]);
    For I := NumCharsToCopy + 1 To High(DestArray) Do
        DestArray[I] := WideChar(#0);

    ConvertStringToWideChar := DestArray;
End;

Function WideCharToStr(SourceWideChar: TString): String;
Var
    ResStr: String;
    I: Integer;
Begin
    ResStr := '';
    For I := Low(SourceWideChar) To High(SourceWideChar) Do
    Begin
        If SourceWideChar[I] <> #0 Then
            ResStr := ResStr + String(SourceWideChar[I]);
    End;

    WideCharToStr := ResStr;
End;

End.
