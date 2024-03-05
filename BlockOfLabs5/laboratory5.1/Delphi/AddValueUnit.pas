Unit AddValueUnit;

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
    Vcl.ExtCtrls,
    Vcl.Buttons,
    Vcl.Grids;

Type
    TLabeledEdit = Class(Vcl.ExtCtrls.TLabeledEdit)
    Public
        Procedure WMPaste(Var Msg: TMessage); Message WM_PASTE;
    End;

    TAddValueForm = Class(TForm)
        MainMenu: TMainMenu;
        Instraction: TMenuItem;
        Label1: TLabel;
        ValueLabEdit: TLabeledEdit;
        ResultButton: TSpeedButton;
        Procedure FormCreate(Sender: TObject);
        Procedure ResultButtonClick(Sender: TObject);
        Procedure InstractionClick(Sender: TObject);
        Procedure ValueLabEditChange(Sender: TObject);
        Procedure ValueLabEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
        Procedure ValueLabEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure ValueLabEditKeyPress(Sender: TObject; Var Key: Char);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    NULL_POINT: Char = #0;
    DELETE_KEY: Char = #127;
    BACK_SPACE: Char = #08;
    MINUS_KEY: Char = '-';

Var
    AddValueForm: TAddValueForm;

Implementation

{$R *.dfm}

Uses
    MainFormUnit,
    FrontendUnit;

Procedure InsertInTail(Value: Integer); External 'DoubleLinkedList.dll';
Procedure InsertInHead(Value: Integer); External 'DoubleLinkedList.dll';
Procedure DeleteFromList(Num: Integer); External 'DoubleLinkedList.dll';
Procedure PrintList(Var LinkedListStrGrid: TStringGrid); External 'DoubleLinkedList.dll';

Procedure TAddValueForm.FormCreate(Sender: TObject);
Begin
    ValueLabEdit.EditLabel.Caption := '';
End;

Procedure TAddValueForm.InstractionClick(Sender: TObject);
Var
    OutputStr: String;
Begin
    OutputStr := 'Справка:' + #13#10'1. Введите число в диапазоне (-1000000000; 1000000000);' + #13#10'2. Нажмите на кнопку ''' +
        ResultButton.Caption + '''.';
    CreateModalForm('О разработчике', OutputStr, Screen.Width * 23 Div 100, Screen.Height * 11 Div 100);
End;

Procedure TAddValueForm.ResultButtonClick(Sender: TObject);
Begin
    MainForm.LinkedListStrGrid.RowCount := MainForm.LinkedListStrGrid.RowCount + 1;
    If (AddInTail) Then
        InsertInTail(StrToInt(ValueLabEdit.Text))
    Else
        InsertInHead(StrToInt(ValueLabEdit.Text));
    ClearStringGrid;
    PrintList(MainForm.LinkedListStrGrid);
    MainForm.LinkedListStrGrid.FixedRows := 1;
    If MainForm.LinkedListStrGrid.RowCount > 16 Then
        MainForm.LinkedListStrGrid.ColWidths[1] := (MainForm.LinkedListStrGrid.Width * 70) Div 100;
    If MainForm.LinkedListStrGrid.RowCount > 1 Then
        MainForm.SaveButton.Enabled := True
    Else
        MainForm.SaveButton.Enabled := False;
    IfDataSavedInFile := False;
    AddValueForm.Close;
End;

Procedure TAddValueForm.ValueLabEditChange(Sender: TObject);
Begin
    Try
        StrToInt(ValueLabEdit.Text);

        ResultButton.Enabled := True;
    Except
        ResultButton.Enabled := False;
    End;

End;

Procedure TAddValueForm.ValueLabEditContextPopup(Sender: TObject; MousePos: TPoint; Var Handled: Boolean);
Begin
    Handled := False;
End;

Procedure TAddValueForm.ValueLabEditKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    CurKey: Char;
Begin
    If Not Clipboard.HasFormat(CF_TEXT) And (Key = VK_INSERT) Then
        Key := 0;

    If (Key = VK_DELETE) And (ValueLabEdit.SelText = '') Then
    Begin
        CurKey := IsCorrectDelete(DELETE_KEY, ValueLabEdit.Text, ValueLabEdit.SelStart + 1);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DELETE) And (ValueLabEdit.SelText <> '') Then
    Begin
        CurKey := IsCorrectSelDelete(DELETE_KEY, ValueLabEdit.Text, ValueLabEdit.SelText, ValueLabEdit.SelStart);

        If CurKey = NULL_POINT Then
            Key := 0;
    End;

    If (Key = VK_DOWN) Or (Key = VK_RETURN) Then
        SelectNext(ActiveControl, True, True);

    If Key = VK_UP Then
        SelectNext(ActiveControl, False, True);

    If (Key = VK_ESCAPE) Then
        AddValueForm.Close;
End;

Procedure TAddValueForm.ValueLabEditKeyPress(Sender: TObject; Var Key: Char);
Const
    GOOD_VALUES = ['0' .. '9', #08, #$16, '-'];
    NUMB_VAL = ['0' .. '9', '-'];
    REF_NUM: String = '10';
Begin
    If Not CharInSet(Key, GOOD_VALUES) Then
        Key := NULL_POINT;

    If (ValueLabEdit.SelText <> '') Then
        Key := IsCorrectSelTextInputWithKey(Key, ValueLabEdit.Text, ValueLabEdit.SelText, ValueLabEdit.SelStart);
    If (ValueLabEdit.SelText = '') And (ValueLabEdit.Text <> '') And CharInSet(Key, NUMB_VAL) Then
        Key := IsCorrectInput(Key, ValueLabEdit.Text, ValueLabEdit.SelStart);

    If (Key = BACK_SPACE) And (ValueLabEdit.SelText = '') Then
        Key := IsCorrectDelete(Key, ValueLabEdit.Text, ValueLabEdit.SelStart);

    If (Key = BACK_SPACE) And (ValueLabEdit.SelText <> '') Then
        Key := IsCorrectSelDelete(Key, ValueLabEdit.Text, ValueLabEdit.SelText, ValueLabEdit.SelStart);
End;

Procedure TLabeledEdit.WMPaste(Var Msg: TMessage);
Begin
    If Clipboard.HasFormat(CF_TEXT) Then
    Begin
        Try
            If (AddValueForm.ActiveControl = AddValueForm.ValueLabEdit) And Not IsCorrectPointsClipboard(Clipboard.AsText,
                AddValueForm.ValueLabEdit) Then
                Raise Exception.Create('Некорректная цифра :(');
        Except
            On E: Exception Do
            Begin
                MessageBox(0, PWideChar(E.Message), 'Ошибка', MB_ICONERROR);
                Exit;
            End;
        End;
    End;
    Inherited;
End;

End.
