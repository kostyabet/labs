Program lab3;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

const 
    FILE_KEY : integer = 1;
    MIN_ARR_SIZE : integer = 1;
    CONSOLE_KEY : integer = 2;
    MIN_FILE_WAY_SIZE : integer = 5;

procedure conditionOutput();
begin
    Write('The program is designed to sort an array', #13#10#9,
          'using the simple insertion method.', #13#10#10);
end;

procedure pathConditionOutput();
begin
    Write('Where will we work through: ', #13#10#9, 'File: ',
          FILE_KEY, ' Console: ', CONSOLE_KEY, #13#10#10);
end;

procedure fileRestriction();
begin
    Write(#13#10, '*The first number is the number of elements ', #13#10,
          'of the array, and subsequent numbers of this array*', #13#10);
end;

function choosingAPath():integer;
var
    path:integer;
    isCorrect, isCorrectInput:boolean;
begin
    path := 0;
    isCorrect := false;
    isCorrectInput := false;

    pathConditionOutput();

    repeat
        Write('Please write were we should work: ');
        try
            Readln(Path);
            isCorrectInput := true;
        except
            Writeln('Error. You should write a one natural number. Try again.');
        end;

        if (path = CONSOLE_KEY) or (path = FILE_KEY) then
            isCorrect := true
        else if isCorrectInput then
            Writeln('Error method. Try again.');
    until isCorrect;

    choosingAPath := Path;
end;

function arrSizeInputFromConsole():integer;
var
    arrSize:integer;
    isCorrect, isCorrectInput : boolean;
begin
    isCorrect := false;
    isCorrectInput := false;
    arrSize := 0;
    
    Write('Write your arr size: ');
    repeat
        try
            Readln(arrSize);
            isCorrectInput := true;
        except
            Write('Invalid numeric input. Try again: ');
        end;

        if (arrSize < MIN_ARR_SIZE) and isCorrectInput then
            Write('Minimal arr size is: ', MIN_ARR_SIZE, 
                  '. Try again: ')
        else if isCorrectInput then
            isCorrect := true;
    until isCorrect;

    arrSizeInputFromConsole := arrSize;
end;

function inputCurrentNumbFromConsole():integer;
var
    currentNumb:integer;
    isCorrect :boolean;
begin
    isCorrect := false;
    currentNumb := 0;
    
    repeat
        try
            Readln(currentNumb);
            isCorrect := true;
        except
            Write('Invalid numeric input. Try again: ');
        end;
    until isCorrect;

    inputCurrentNumbFromConsole := currentNumb;
end;

procedure arrOfNumbInputFromConsole(var arrOfNumb:Array of Integer);
var
    i:integer;
begin
    for I := 0 to High(ArrOfNumb) do
    begin
        Write('Write your ', i + 1, ' numbers: ');
        arrOfNumb[i] := inputCurrentNumbFromConsole();
    end;

end;

Function WayCondition(Way: String): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    If ExtractFileExt(Way) <> '.txt' Then
        Write('Write .txt file. Try again: ')
    Else
        IsCorrect := True;
    WayCondition := IsCorrect;
End;

Function InputWayToTheFile(): String;
Var
    Way: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    Repeat
        Readln(Way);
        IsCorrect := WayCondition(Way);
    Until IsCorrect;
    InputWayToTheFile := Way;
End;

Function InputFileWay(): String;
Var
    FileWay: String;
    IsCorrect: Boolean;
Begin
    IsCorrect := False;
    FileWay := '';
    Repeat
        FileWay := InputWayToTheFile();
        If (Not FileExists(FileWay)) Then
            Write('Can not open a file. Try write another way: ')
        Else
            IsCorrect := True;
    Until IsCorrect;
    InputFileWay := FileWay;
End;

function arrSizeInputFromFile(arrSize:integer):boolean;
var
    isCorrect:boolean;
begin
    isCorrect := false;
    if arrSize < MIN_ARR_SIZE then
        Write('Minimal arr size is ',  MIN_ARR_SIZE, '. Try again:')
    else
        isCorrect := true;

    arrSizeInputFromFile := isCorrect;
end;

function isIncorrectArrOfNumbInputFromFile(var arrOfNumb:Array Of Integer; 
                                  arrSize:integer;var MyFile:TextFile):boolean;
var
    isCorrect:boolean;
    i:integer;
begin
    isCorrect := true;

    for I := 0 to arrSize - 1 do
    begin
        try    
            Read(MyFile, arrOfNumb[i]);
        except
            isCorrect := false;
        end;
    end;

    isIncorrectArrOfNumbInputFromFile := isCorrect;
end;

procedure sortMassive(var arrOfNumb: Array Of Integer);
var
    temp, I, J:integer;
begin        
    for I := 1 to High(ArrOfNumb) do
    begin
        temp := arrOfNumb[i];

        j := i - 1;
        while (j >= 0) And (arrOfNumb[j] > temp) do
        begin
            arrOfNumb[j + 1] := arrOfNumb[j];
            arrOfNumb[j] := temp;
            dec(j);
        end;
    end;
end;

procedure outputFromFile(var arrOfNumb: Array Of integer);
Var
    IsCorrect: Boolean;
    FileWay: String;
    MyFile: TextFile;
    I:Integer;
Begin
    IsCorrect := False;
    Write('Write way to your file: ');
    Repeat
        FileWay := InputFileWay();
        AssignFile(MyFile, FileWay);
        Try
            Try
                Append(MyFile);
                ReWrite(MyFile);
                for I := 0 to High(ArrOfNumb) do
                begin
                    Write(MyFile, ArrOfNumb[i]);
                    Write(MyFile, ' ');
                end;
                Write('Cheack your file.');
                IsCorrect := True;
            Finally
                Close(MyFile);
            End;
        Except
            Write('Bad output file. Try again: ');
        End;
    Until IsCorrect;
End;

procedure outputFromConsole(var arrOfNumb: Array Of Integer);
var
  I: Integer;
begin
    for I := 0 to High(arrOfNumb) do
        Write(arrOfNumb[i], ' ');
end;

procedure resultOutput(var arrOfNumb: Array of integer);
var
    path:integer;    
begin
    Writeln('You need to choose where to write information from.');
    path := choosingAPath();
    if Path = CONSOLE_KEY then
        outputFromConsole(arrOfNumb)
    else
        outputFromFile(arrOfNumb);
end;

var
    isCorrect:boolean;
    arrSize, path:integer;
    ArrOfNumb:Array Of Integer;
    FileWay:string;
    MyFile:TextFile;
    
Begin
    arrSize := 0;
    
    conditionOutput();

    Writeln(#13#10, 'You need to choose where to read information from.');

    path := choosingAPath();
    if path = CONSOLE_KEY then
    begin
        arrSize := arrSizeInputFromConsole();

        SetLength(arrOfNumb, arrSize);
        arrOfNumbInputFromConsole(arrOfNumb);
    end
    else
    begin
        IsCorrect := True;
        fileRestriction();
        Write('Write way to your file: ');
        Repeat
            FileWay := InputFileWay();
            AssignFile(MyFile, FileWay);
            Try
                Try
                    Reset(MyFile);
                    Try
                        Readln(MyFile, arrSize);    
                    Except
                        Write('Error in array size reading. Try again: ');
                        IsCorrect := False;
                    End;
                    if isCorrect then
                        isCorrect := arrSizeInputFromFile(arrSize);
                    if isCorrect then
                    begin
                        SetLength(ArrOfNumb, arrSize);
                        isCorrect := isIncorrectArrOfNumbInputFromFile(arrOfNumb, arrSize, MyFile);
                        if not isCorrect then
                            Write('Invalid massive elements input. Try again: ');
                    end;
                Finally
                    Close(MyFile);
                End;
            Except
                Write('Bad input file. Try again: ');
            End;
        Until IsCorrect;
    end;

    sortMassive(arrOfNumb);

    resultOutput(arrOfNumb);

    arrOfNumb := nil;
    Readln;
End.
