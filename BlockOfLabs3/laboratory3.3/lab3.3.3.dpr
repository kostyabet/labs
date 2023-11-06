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
begin

end;

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
    arrSize, path:integer;
    ArrOfNumb:Array Of Integer;

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
    
    end;

    sortMassive(arrOfNumb);

    resultOutput(arrOfNumb);

    arrOfNumb := nil;
    Readln;
End.