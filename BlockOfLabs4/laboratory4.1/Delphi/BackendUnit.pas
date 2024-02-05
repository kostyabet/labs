Unit BackendUnit;

Interface

Uses
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
    TFootballStats = Record
        Country: String;
        Team: String;
        Coach: String;
        Points: Integer;
    End;

    TMassive = Array Of Integer;
    TFootballMassive = Array Of TFootballStats;

Procedure InputDataInMassive(Country, Team, Coach, Points: String; CurentRow: Integer);
Procedure InputMassiveInTableGrid();
Procedure InputInfoFromGrid(Var CountryLabeledEdit, TeamNameLabeledEdit, CoachLabeledEdit, PointsLabeledEdit: TLabeledEdit; I: Integer);
Procedure SortFootballStats();
Procedure DeleteRow(I: Integer);
Function IndexRecord(I: Integer; CurentStr: String): Integer;
Function CreateResultGrid(StrIndex: Integer): String;

Var
    FootballTable: TFootballMassive;

Implementation

Uses
    MainFormUnit,
    FrontendUnit;

Procedure InputDataInMassive(Country, Team, Coach, Points: String; CurentRow: Integer);
Begin
    FootballTable[CurentRow].Country := Country;
    FootballTable[CurentRow].Team := Team;
    FootballTable[CurentRow].Coach := Coach;
    FootballTable[CurentRow].Points := StrToInt(Points);
End;

Procedure InputMassiveInTableGrid();
Var
    I: Integer;
Begin
    MainForm.PointTabelStrGrid.RowCount := High(FootballTable) + 2;

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
    TempT, TempCh, TempCy: String;
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
    While Not(I > High(FootballTable) - 1) Do
    Begin
        FootballTable[I].Country := FootballTable[I + 1].Country;
        FootballTable[I].Team := FootballTable[I + 1].Team;
        FootballTable[I].Coach := FootballTable[I + 1].Coach;
        FootballTable[I].Points := FootballTable[I + 1].Points;
        Inc(I);
    End;
    SetLength(FootballTable, Length(FootballTable) - 1);
    InputMassiveInTableGrid();
End;

Function IndexRecord(I: Integer; CurentStr: String): Integer;
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
                    If (IntToStr(FootballTable[J].Points) = CurentStr) Then
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
    ResStr := 'Страна: ' + FootballTable[StrIndex].Country + #13#10;
    ResStr := ResStr + 'Название команды: ' + FootballTable[StrIndex].Team + #13#10;
    ResStr := ResStr + 'Гл. Тренер: ' + FootballTable[StrIndex].Coach + #13#10;
    ResStr := ResStr + 'Итоговый результат:' + IntToStr(FootballTable[StrIndex].Points);

    CreateResultGrid := ResStr;
End;

End.
