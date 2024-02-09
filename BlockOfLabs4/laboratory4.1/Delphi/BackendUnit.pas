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

    TFootStatsRecord = Record
        Country: TString;
        Team: TString;
        Coach: TString;
        Points: Integer;
    End;

Const
    TEAMS_COUNT = 48;

Type
    TMassive = Array Of Integer;
    TFootballMassive = Array [0 .. TEAMS_COUNT] Of TFootStatsRecord;
    TFileLoader = File Of TFootStatsRecord;

Function GetRecordFromFile(CurentRow: Integer): TFootStatsRecord;
Procedure ChangeRecordInFile(Country, Team, Coach: TString; Points, CurentRow: Integer);
Procedure InputRecordInFile(Country, Team, Coach: TString; Points: Integer);
Procedure InputRecordsInTableGrid();
Procedure SortRecords();
Procedure DeleteRow(DelRow: Integer);
Function IndexRecord(I: Integer; CurentStr: TString): Integer;
Function CreateResultGrid(StrIndex: Integer): String;
Procedure CreateCorrectionFile();
Procedure LoadRecordsInFile();
Procedure LoadRecordsFromFile();
Function StrToWideChar(SourceString: String): TString;
Function WideCharToStr(SourceWideChar: TString): String;
Function IfRecordExist(Country, Coach, Team, Points: String): Boolean;

Var
    CurentRecordsCount: Integer = 0;
    MainFile: TFileLoader;
    CorrectionFile: TFileLoader;

Const
    MainFilePath: String = 'MainFile.txt';
    CorrectionFilePath: String = 'CorrectionFile.txt';
    TempFilePath: String = 'TempFile.txt';

Implementation

Uses
    MainFormUnit,
    FrontendUnit;

Function GetRecordFromFile(CurentRow: Integer): TFootStatsRecord;
Var
    TempRecord: TFootStatsRecord;
    I: Integer;
Begin
    I := 0;
    AssignFile(CorrectionFile, CorrectionFilePath);
    Try
        Reset(CorrectionFile);
        While Not EOF(CorrectionFile) And (I <> CurentRow) Do
        Begin
            Read(CorrectionFile, TempRecord);
            Inc(I);
        End;
    Finally
        Close(CorrectionFile);
    End;

    GetRecordFromFile := TempRecord;
End;

Procedure ChangeRecordInFile(Country, Team, Coach: TString; Points, CurentRow: Integer);
Var
    TempRecord: TFootStatsRecord;
    TempFile: TFileLoader;
    I: Integer;
Begin
    I := 1;
    AssignFile(CorrectionFile, CorrectionFilePath);
    AssignFile(TempFile, TempFilePath);
    Try
        Rewrite(TempFile);
        Reset(CorrectionFile);
        While Not EOF(CorrectionFile) Do
        Begin
            Read(CorrectionFile, TempRecord);
            If (I = CurentRow) Then
            Begin
                TempRecord.Country := Country;
                TempRecord.Team := Team;
                TempRecord.Coach := Coach;
                TempRecord.Points := Points;
                Write(TempFile, TempRecord);
            End
            Else
                Write(TempFile, TempRecord);
            Inc(I);
        End;
    Finally
        Close(CorrectionFile);
        Close(TempFile);
    End;
    DeleteFile(CorrectionFilePath);

    RenameFile(TempFilePath, CorrectionFilePath);
End;

Procedure InputRecordInFile(Country, Team, Coach: TString; Points: Integer);
Var
    TempRecord: TFootStatsRecord;
    TempFile: TFileLoader;
Begin
    AssignFile(CorrectionFile, CorrectionFilePath);
    AssignFile(TempFile, TempFilePath);
    Try
        Rewrite(TempFile);
        Reset(CorrectionFile);
        While Not EOF(CorrectionFile) Do
        Begin
            Read(CorrectionFile, TempRecord);
            Write(TempFile, TempRecord);
        End;
        TempRecord.Country := Country;
        TempRecord.Team := Team;
        TempRecord.Coach := Coach;
        TempRecord.Points := Points;
        Write(TempFile, TempRecord);
    Finally
        Close(CorrectionFile);
        Close(TempFile);
    End;
    DeleteFile(CorrectionFilePath);

    RenameFile(TempFilePath, CorrectionFilePath);
End;

Procedure InputRecordsInTableGrid();
Var
    TempRecord: TFootStatsRecord;
    I: Integer;
Begin
    AssignFile(CorrectionFile, CorrectionFilePath);
    Try
        Reset(CorrectionFile);

        MainForm.PointTabelStrGrid.RowCount := CurentRecordsCount + 1;
        If CurentRecordsCount > 11 Then
            MainForm.PointTabelStrGrid.ColWidths[4] := (MainForm.PointTabelStrGrid.Width * 19) div 100;
        I := 0;
        While Not EOF(CorrectionFile) Do
        Begin
            Read(CorrectionFile, TempRecord);
            InputInCurentRow(I + 1, WideCharToStr(TempRecord.Country), WideCharToStr(TempRecord.Team), WideCharToStr(TempRecord.Coach),
                TempRecord.Points);
            Inc(I);
        End;
    Finally
        Close(CorrectionFile);
    End;
End;

Procedure InputFTInRecords(FootballTable: TFootballMassive);
Var
    I: Integer;
Begin
    AssignFile(CorrectionFile, CorrectionFilePath);
    Rewrite(CorrectionFile);
    Try
        For I := 0 To CurentRecordsCount - 1 Do
            Write(CorrectionFile, FootballTable[I]);
    Finally
        Close(CorrectionFile);
    End;
End;

Procedure InputRecordsInFT(Var FootballTable: TFootballMassive);
Var
    I: Integer;
Begin
    I := 0;
    AssignFile(CorrectionFile, CorrectionFilePath);
    Reset(CorrectionFile);
    Try
        While Not EOF(CorrectionFile) Do
        Begin
            Read(CorrectionFile, FootballTable[I]);
            Inc(I);
        End;
    Finally
        Close(CorrectionFile);
    End;
End;

Procedure SortRecords();
Var
    FootballTable: TFootballMassive;
    TempP, I, J: Integer;
    TempT, TempCh, TempCy: TString;
Begin
    InputRecordsInFT(FootballTable);

    For I := 1 To CurentRecordsCount - 1 Do
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

    InputFTInRecords(FootballTable);
End;

Procedure DeleteRow(DelRow: Integer);
Var
    TempRecord: TFootStatsRecord;
    TempFile: TFileLoader;
    I: Integer;
Begin
    I := 1;
    AssignFile(CorrectionFile, CorrectionFilePath);
    AssignFile(TempFile, TempFilePath);
    Try
        Rewrite(TempFile);
        Reset(CorrectionFile);
        While Not EOF(CorrectionFile) Do
        Begin
            Read(CorrectionFile, TempRecord);
            If (I <> DelRow) Then
                Write(TempFile, TempRecord);
            Inc(I);
        End;
    Finally
        Close(CorrectionFile);
        Close(TempFile);
    End;
    DeleteFile(CorrectionFilePath);

    RenameFile(TempFilePath, CorrectionFilePath);
End;

Function IndexRecord(I: Integer; CurentStr: TString): Integer;
Var
    FootballTable: TFootballMassive;
    J: Integer;
Begin
    InputRecordsInFT(FootballTable);

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
    TempRecord: TFootStatsRecord;
    ResStr: String;
Begin
    TempRecord := GetRecordFromFile(StrIndex);

    ResStr := 'Страна: ' + WideCharToStr(TempRecord.Country) + ';'#13#10;
    ResStr := ResStr + 'Название команды: ' + WideCharToStr(TempRecord.Team) + ';'#13#10;
    ResStr := ResStr + 'Главный Тренер: ' + WideCharToStr(TempRecord.Coach) + ';'#13#10;
    ResStr := ResStr + 'Итоговый результат:' + IntToStr(TempRecord.Points);

    CreateResultGrid := ResStr;
End;

Procedure CreateCorrectionFile();
Begin
    AssignFile(CorrectionFile, CorrectionFilePath);
    Rewrite(CorrectionFile);
    Close(CorrectionFile);
End;

Procedure LoadRecordsInFile();
Begin
    If FileExists(MainFilePath) Then
        DeleteFile(MainFilePath);

    RenameFile(CorrectionFilePath, MainFilePath);
End;

Procedure LoadRecordsFromFile();
Var
    TempRecord: TFootStatsRecord;
Begin
    CreateCorrectionFile;

    CurentRecordsCount := 0;
    AssignFile(MainFile, MainFilePath);
    AssignFile(CorrectionFile, CorrectionFilePath);
    Try
        Reset(MainFile);
        ReWrite(CorrectionFile);
        While Not EOF(MainFile) Do
        Begin
            Read(MainFile, TempRecord);
            Write(CorrectionFile, TempRecord);
            Inc(CurentRecordsCount);
        End;
        CloseFile(MainFile);
        CloseFile(CorrectionFile);
    Except
        Rewrite(MainFile);
        Close(MainFile);
    End;

    SortRecords();
    InputRecordsInTableGrid();
End;

Function StrToWideChar(SourceString: String): TString;
Var
    DestArray: TString;
    NumCharsToCopy, I: Integer;
Begin
    NumCharsToCopy := Min(Length(SourceString), SizeOf(DestArray) Div SizeOf(WideChar) - 1);

    For I := 1 To NumCharsToCopy Do
        DestArray[I] := WideChar(SourceString[I]);
    For I := NumCharsToCopy + 1 To High(DestArray) Do
        DestArray[I] := WideChar(#0);

    StrToWideChar := DestArray;
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

Function IfRecordExist(Country, Coach, Team, Points: String): Boolean;
Var
    TempRecord: TFootStatsRecord;
    I: Integer;
Begin
    For I := 1 To CurentRecordsCount Do
    Begin
        TempRecord := GetRecordFromFile(I);

        If (TempRecord.Country = StrToWideChar(Country)) And (TempRecord.Coach = StrToWideChar(Coach)) And
            (TempRecord.Team = StrToWideChar(Team)) And (IntToStr(TempRecord.Points) = Points) Then
        Begin
            IfRecordExist := True;
            Exit;
        End;
    End;

    IfRecordExist := False;
End;

End.
