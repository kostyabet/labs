Unit BackendUnit;

Interface

Uses
    System.SysUtils,
    Vcl.ExtCtrls,
    Winapi.Windows;

Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Function TryToDelete(Key: Word; Str: String; SelPos: Integer; LabeledEdit: TLabeledEdit): Word;
Function CheckMinus(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Function CheckZero(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;

Implementation

Uses
    MainUnit;

////////////////////////////////////////////////////////////////////////////////

Function TryToAdd(Key: Char; Str: String; SelPos: Integer; Const MaxPoint, MinPoint: Integer): Boolean;
Begin
    Insert(Key, Str, SelPos + 1);

    Try
        If (StrToInt(Str) > MaxPoint) Or (StrToInt(Str) < MinPoint) Then
            TryToAdd := False
        Else
            TryToAdd := True;
    Except
        TryToAdd := False
    End;
End;

Function TryToDelete(Key: Word; Str: String; SelPos: Integer; LabeledEdit: TLabeledEdit): Word;
Begin
    If Length(Str) > 0 Then
        Delete(Str, SelPos + Ord(Key = VK_DELETE), 1);

    Try
        If Not((Str[1] = '0') Or ((Str[1] = '-') And (Str[2] = '0'))) Then
            LabeledEdit.Text := Str;
    Except
        LabeledEdit.Text := LabeledEdit.Text;
    End;

    If (Str = '') Or (Str = '-') Then
        LabeledEdit.Text := Str;

    If (Key = VK_BACK) And (LabeledEdit.Text = Str) Then
        SelPos := SelPos - 1;
    LabeledEdit.SelStart := SelPos;

    TryToDelete := 0;
End;

Function CheckMinus(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    If (Key = '-') And (LabeledEdit.SelStart <> 0) Then
        Key := NULL_POINT;

    If Not((Key In GOOD_VALUES) Or (Key = '-')) Then
        Key := NULL_POINT;

    CheckMinus := Key;
End;

Function CheckZero(Key: Char; Const NULL_POINT: Char; LabeledEdit: TLabeledEdit): Char;
Const
    GOOD_VALUES: Set Of Char = ['0' .. '9'];
Begin
    If (Key = '0') And (LabeledEdit.SelStart = 0) Then
        Key := NULL_POINT;

    If (Key = '0') And (LabeledEdit.SelStart = 1) And (LabeledEdit.Text[1] = '-') Then
        Key := NULL_POINT;

    CheckZero := Key;
End;

End.
