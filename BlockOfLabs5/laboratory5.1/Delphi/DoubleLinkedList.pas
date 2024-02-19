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

    TDoublyLinkedList = Class
    Private
        FHead: PNode;
        FTail: PNode;
    Public
        Constructor Create;
        Procedure Insert(Value: Integer);
        Procedure PrintList;
    End;

Implementation

Constructor TDoublyLinkedList.Create;
Begin
    FHead := Nil;
    FTail := Nil;
End;

Procedure TDoublyLinkedList.Insert(Value: Integer);
Var
    NewNode: PNode;
Begin
    New(NewNode);
    NewNode.Data := Value;
    NewNode.Prev := Nil;
    NewNode.Next := FHead;

    If FHead <> Nil Then
        FHead.Prev := NewNode
    Else
        FTail := NewNode;

    FHead := NewNode;
End;

Procedure TDoublyLinkedList.PrintList;
Var
    CurrentNode: PNode;
Begin
    CurrentNode := FHead;
    While CurrentNode <> Nil Do
    Begin
        Write(CurrentNode.Data, ' ');
        CurrentNode := CurrentNode.Next;
    End;
End;

End.                        
