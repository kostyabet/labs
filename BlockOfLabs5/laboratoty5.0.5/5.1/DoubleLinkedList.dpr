Library DoubleLinkedList;

Uses
    System.SysUtils,
    Vcl.Grids;

Type
    PNode = ^TNode;

    TNode = Record
        Data: Integer;
        Prev: PNode;
        Next: PNode;
    End;

Var
    Tail: PNode = Nil;
    Head: PNode = Nil;

Procedure InsertInTail(Value: Integer);
Var
    NewNode: PNode;
Begin
    New(NewNode);
    NewNode.Data := Value;
    NewNode.Prev := Tail;
    NewNode.Next := Nil;
    If Head = Nil Then
        Head := NewNode
    Else
        Tail^.Next := NewNode;
    Tail := NewNode;
End;

Procedure InsertInHead(Value: Integer);
Var
    NewNode: PNode;
Begin
    New(NewNode);
    NewNode.Data := Value;
    NewNode.Prev := Nil;
    NewNode.Next := Head;
    If (Head <> Nil) Then
        Head.Prev := NewNode;
    Head := NewNode;
End;

Procedure DeleteFromList(Num: Integer);
Var
    CurrentNode, PreviousNode, NextNode: PNode;
    Count: Integer;
Begin
    CurrentNode := Head;
    Count := 1;

    While Count < Num Do
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
    Else
        Tail := CurrentNode^.Prev;

    Dispose(CurrentNode);
End;

Procedure PrintList(Var LinkedListStrGrid: TStringGrid);
Var
    CurrentNode: PNode;
    HighI, I: Integer;
Begin
    CurrentNode := Tail;
    HighI := 1;
    While CurrentNode <> Nil Do
    Begin
        LinkedListStrGrid.Cells[1, HighI] := IntToStr(CurrentNode.Data);
        CurrentNode := CurrentNode.Prev;
        Inc(HighI);
    End;
    Dec(HighI);
    For I := HighI DownTo 1 Do
        LinkedListStrGrid.Cells[0, HighI - I + 1] := IntToStr(I);
End;

Exports
    InsertInTail,
    InsertInHead,
    DeleteFromList,
    PrintList;

{$R *.res}

Begin

End.
