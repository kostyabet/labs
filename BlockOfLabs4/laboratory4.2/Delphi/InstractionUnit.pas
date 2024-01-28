Unit InstractionUnit;

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
    Vcl.Dialogs, Vcl.StdCtrls;

Type
    TInstraction = Class(TForm)
    InstractionLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    Instraction: TInstraction;

Implementation

{$R *.dfm}

uses MainUnit;

procedure TInstraction.FormCreate(Sender: TObject);
begin
    InstractionLabel.Caption := 'Ограничения: ' + #13#10 + 
    '  1. A находится в промежутке [' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + '];' + #13#10 +
    '  2. N находится в промежутке [' + IntToStr(MIN_N) + '; ' + IntToStr(MAX_N) + '];' + #13#10 +
    '  3. Координаты векторов находятся в промежутке ' + #13#10 + 
    '      [' + IntToStr(MIN_INT_NUM) + '; ' + IntToStr(MAX_INT_NUM) + '];' + #13#10;

    InstractionLabel.Caption := InstractionLabel.Caption + #13#10 +
    'Порядок работы: ' + #13#10 +
    '  1. Введите А - целое число для сравнения;' + #13#10 +
    '  2. Введите N - кол-во координат векторов;' + #13#10 +
    '  3. Введите координаты вектора B;' + #13#10 +
    '  4. Введите координаты вектора C.' + #13#10 + 
    '  5. Нажимайте кнопку ''Рассчитать'';' + #13#10 +
    'Результат можно сохранить в файл (*.txt)' + #13#10 + #13#10 + 
    'Все необходимые данные можно ввести через файл: ' + #13#10 +
    '  1. В файле всё идёт в таком же порядке, как указано выше' + #13#10 + 
    '  2. Файл должен быть строго формата *.txt!';
     
end;

End.
