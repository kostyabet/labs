Unit DoubleLinkedList;

Interface

Uses
    System.SysUtils;

Type
    PNode = ^TNode;

    TNode = Record
        Data: Integer;
        Prev: PNode;
        Next: PNode;
    End;

Procedure InsertInList(Value: Integer);
Procedure DeleteFromList(Num: Integer);
Procedure PrintList;

Var
    Tail: PNode = Nil;
    Head: PNode = Nil;

Implementation

Uses
    MainFormUnit;

Procedure InsertInList(Value: Integer);
Var
    NewNode: PNode;
Begin
    New(NewNode);
    NewNode.Data := Value;
    NewNode.Prev := Tail;
    NewNode.Next := Nil;
    if Head = nil then
        Head := NewNode
    else
        Tail.Next := NewNode;
    Tail := NewNode;
End;

Procedure DeleteFromList(Num: Integer);
Var
    CurrentNode, PreviousNode, NextNode: PNode;
    Count: Integer;
Begin
    CurrentNode := Head;
    Count := 1;

    While (Count < Num) Do
    Begin
        CurrentNode := CurrentNode^.Next;
        Inc(Count);
    End;

    PreviousNode := CurrentNode^.Prev;
    NextNode := CurrentNode^.Next;

    If PreviousNode <> Nil Then
        PreviousNode^.Next := NextNode
    Else
        Head := NextNode;

    If NextNode <> Nil Then
        NextNode^.Prev := PreviousNode
    else
        Tail := CurrentNode.Prev;

    Dispose(CurrentNode);
End;

Procedure PrintList;
Var
    CurrentNode: PNode;
    Counter: Integer;
    HighI, I: Integer;
Begin
    CurrentNode := Tail;
    HighI := 1;
    While CurrentNode <> Nil Do
    Begin
        MainForm.LinkedListStrGrid.Cells[1, HighI] := IntToStr(CurrentNode.Data);
        CurrentNode := CurrentNode.Prev;
        Inc(HighI);
    End;
    Dec(HighI);
    For I := HighI DownTo 1 Do
        MainForm.LinkedListStrGrid.Cells[0, HighI - I + 1] := IntToStr(I);
End;

End.
