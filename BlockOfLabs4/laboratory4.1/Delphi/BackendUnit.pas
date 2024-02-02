Unit BackendUnit;

Interface

Uses
    System.SysUtils,
    Vcl.Grids;

Type
    TFootballStats = Record
        Country: String;
        Team: String;
        Coach: String;
        Points: Integer;
    End;

    TFootballMassive = Array Of TFootballStats;

Procedure InputDataInMassive(Country, Team, Coach, Points: String);
Procedure InputMassiveInTableGrid(FootballTable: TFootballMassive; Var PointTabelStrGrid: TStringGrid);

Var
    FootballTable: TFootballMassive;

Implementation

Procedure InputDataInMassive(Country, Team, Coach, Points: String);
Begin
    SetLength(FootballTable, Length(FootballTable) + 1);
    FootballTable[High(FootballTable)].Country := Country;
    FootballTable[High(FootballTable)].Team := Team;
    FootballTable[High(FootballTable)].Coach := Coach;
    FootballTable[High(FootballTable)].Points := StrToInt(Points);
End;

Procedure InputMassiveInTableGrid(FootballTable: TFootballMassive; Var PointTabelStrGrid: TStringGrid);
Var
    I, J: Integer;
Begin
    PointTabelStrGrid.RowCount := High(FootballTable) + 2;

    Try
        For I := 1 To High(FootballTable) + 2 Do
        Begin
            PointTabelStrGrid.Cells[0, I] := IntToStr(I);
            PointTabelStrGrid.Cells[1, I] := FootballTable[I - 1].Country;
            PointTabelStrGrid.Cells[2, I] := FootballTable[I - 1].Team;
            PointTabelStrGrid.Cells[3, I] := FootballTable[I - 1].Coach;
            PointTabelStrGrid.Cells[4, I] := IntToStr(FootballTable[I - 1].Points);
        End;
    Except

    End;
End;

End.
