Unit BinaryTreeUnit;

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
    Vcl.Dialogs,
    Vcl.Menus,
    System.ImageList,
    Vcl.ImgList,
    Vcl.StdCtrls,
    Vcl.Mask,
    Vcl.ExtCtrls,
    Vcl.Buttons,
    Clipbrd,
    System.Generics.Collections;

Type
    Node = ^TBinTree;

    TBinTree = Record
        Data: Integer;
        Parent: Node;
        LCost: Integer;
        RCost: Integer;
        Left: Node;
        Right: Node;
    End;

Var
    BinaryTree: Node;
    Head: Node;
    ExistPoints: TList<Integer>;
    LongWayCost: Integer;
    LongestPoint: Node;

Const
    MIN_INT: Integer = -1_000_000;

Procedure CreateTree();
Procedure InsertNewBranch(Child, Cost: Integer);
Procedure SearchLongestWay(Root: Node; Cost: Integer);
Procedure ToMirrorTree();
Procedure PrintTree(Node: Node; Var OutputString: String; Prefix: String; IsLeft: Boolean);

Implementation

Uses
    MainFormUnit,
    FrontendUnit,
    BackendUnit;

Procedure CreateTree();
Begin
    ExistPoints := TList<Integer>.Create;
    LongWayCost := MIN_INT;
    LongestPoint := Nil;
End;

Function InsertProcess(Root, Parent: Node; Child, Cost: Integer): Node;
Begin
    If (Root = Nil) Then
    Begin
        New(Root);
        If (ExistPoints.Count = 0) Then
            Head := Root
        else
            Root.Parent := Parent;
        ExistPoints.Add(Child);
        Root.Data := Child;
        Root.LCost := 0;
        Root.RCost := 0;
        Root.Left := Nil;
        Root.Right := Nil;
        InsertProcess := Root;
    End;

    If (ExistPoints.IndexOf(Child) = -1) And (Root.Data > Child) Then
    Begin
        If (Root.Left = Nil) Then
            Root.LCost := Cost;
        Root.Left := InsertProcess(Root.Left, Root, Child, Cost);
    End
    Else If (ExistPoints.IndexOf(Child) = -1) Then
    Begin
        If (Root.Right = Nil) Then
            Root.RCost := Cost;
        Root.Right := InsertProcess(Root.Right, Root, Child, Cost);
    End;
    InsertProcess := Root;
End;

Procedure InsertNewBranch(Child, Cost: Integer);
Begin
    BinaryTree := InsertProcess(BinaryTree, BinaryTree, Child, Cost);
End;

Procedure SearchLongestWay(Root: Node; Cost: Integer);
Begin
    If Root <> Nil Then
    Begin
        SearchLongestWay(Root.Left, Cost + Root.LCost);
        If Cost > LongWayCost Then
        Begin
            LongWayCost := Cost;
            LongestPoint := Root;
        End;
        SearchLongestWay(Root.Right, Cost + Root.RCost);
    End;
End;

Procedure ToMirrorTree();
Var
    Temp: Node;
Begin
    While LongestPoint.Parent <> Nil Do
        LongestPoint := LongestPoint.Parent;
    Temp := LongestPoint.Right;
    If (Temp <> Nil) Then
    Begin
        LongestPoint.Right := LongestPoint.Left;
        LongestPoint.Left := Temp;
    End;
End;

Procedure PrintTree(Node: Node; Var OutputString: String; Prefix: String; IsLeft: Boolean);
Var
    TreeEl: String;
Begin
    If (Node <> Nil) Then
    Begin
        If IsLeft Then
            TreeEl := '├── '
        Else
            TreeEl := '└── ';
        OutputString := OutputString + Prefix + TreeEl + IntToStr(Node.Data) + #13#10;
        PrintTree(Node.Left, OutputString, Prefix + TreeEl, True);
        PrintTree(Node.Right, OutputString, Prefix + TreeEl, False);
    End;
End;

End.
