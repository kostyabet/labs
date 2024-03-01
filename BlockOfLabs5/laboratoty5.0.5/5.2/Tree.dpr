Library Tree;

Uses
    System.SysUtils,
    Vcl.Graphics,
    Vcl.ExtCtrls,
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

Procedure CreateTree();
Const
    MIN_INT_VALUE: Integer = -4_000_000;
Begin
    ExistPoints := TList<Integer>.Create;
    LongWayCost := MIN_INT_VALUE;
    LongestPoint := Nil;
End;

Function GetExistPointsCount(): Integer;
Begin
    GetExistPointsCount := ExistPoints.Count;
End;

Function GetExistPoints(Value: Integer): Integer;
Begin
    GetExistPoints := ExistPoints.IndexOf(Value);
End;

Function InsertProcess(Root, Parent: Node; Child, Cost: Integer): Node;
Begin
    If (Root = Nil) Then
    Begin
        New(Root);
        If (ExistPoints.Count = 0) Then
            Head := Root
        Else
            Root.Parent := Parent;
        ExistPoints.Add(Child);
        Root.Data := Child;
        Root.LCost := 0;
        Root.RCost := 0;
        Root.Left := Nil;
        Root.Right := Nil;
    End;

    If (ExistPoints.IndexOf(Child) = -1) And (Root.Data > Child) Then
    Begin
        If (Root.Left = Nil) Then
            Root.LCost := Cost;
        Root.Left := InsertProcess(Root.Left, Root, Child, Cost);
    End
    Else
        If (ExistPoints.IndexOf(Child) = -1) Then
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

Procedure LongestWay(Root: Node; Cost: Integer);
Begin
    If Root <> Nil Then
    Begin
        LongestWay(Root.Left, Cost + Root.LCost);
        If Cost > LongWayCost Then
        Begin
            LongWayCost := Cost;
            LongestPoint := Root;
        End;
        LongestWay(Root.Right, Cost + Root.RCost);
    End;
End;

Procedure SearchLongestWay();
Begin
    LongestWay(BinaryTree, 0);
    BinaryTree := Head;
End;

Procedure ToMirrorTree();
Var
    Temp, LHead: Node;
Begin
    LHead := LongestPoint;
    While LongestPoint <> Nil Do
    Begin
        Temp := LongestPoint.Right;
        LongestPoint.Right := LongestPoint.Left;
        LongestPoint.Left := Temp;
        LongestPoint := LongestPoint.Parent;
    End;
    LongestPoint := LHead;
End;

Procedure ConsoleTree(Node: Node; Var OutputString: String; Prefix: String; IsLeft: Boolean);
Var
    TreeEl: String;
Begin
    If (Node = Nil) Then
        Exit;
    If IsLeft Then
        TreeEl := '├── '
    Else
        TreeEl := '└── ';
    OutputString := OutputString + Prefix + TreeEl + IntToStr(Node.Data) + #13#10;
    If IsLeft Then
        TreeEl := '│   '
    Else
        TreeEl := '    ';
    ConsoleTree(Node.Left, OutputString, Prefix + TreeEl, True);
    If IsLeft Then
        TreeEl := '│   '
    Else
        TreeEl := '    ';
    ConsoleTree(Node.Right, OutputString, Prefix + TreeEl, False);
End;

Function PrintConsoleTree(): String;
Var
    ResultStr: String;
Begin
    ResultStr := '';
    BinaryTree := Head;
    ConsoleTree(BinaryTree, ResultStr, '', False);
    BinaryTree := Head;
    PrintConsoleTree := ResultStr;
End;

Function CheckCurentElipsColor(Root: Node): TColor;
Const
    CustomColor: TColor = $00FFC8B0;
Var
    LHead: Node;
    ResColor: TColor;
Begin
    LHead := LongestPoint;
    ResColor := ClWhite;
    While (LongestPoint <> Nil) Do
    Begin
        If (LongestPoint.Data = Root.Data) Then
            ResColor := CustomColor;
        LongestPoint := LongestPoint.Parent;
    End;
    LongestPoint := LHead;

    CheckCurentElipsColor := ResColor;
    LHead := Nil;
End;

Procedure PrintDrawTree(Root: Node; PBox: TPaintBox; X, Y, XOffset: Integer);
Begin
    If Root = Nil Then
        Exit;
    PBox.Canvas.Font.Size := 7;
    PBox.Canvas.Brush.Color := CheckCurentElipsColor(Root);
    If Root.Left <> Nil Then
    Begin
        PBox.Canvas.MoveTo(X, Y);
        PBox.Canvas.LineTo(X - XOffset, Y + 100);
        PrintDrawTree(Root.Left, PBox, X - XOffset, Y + 100, XOffset Div 2);
    End;
    PBox.Canvas.Brush.Color := CheckCurentElipsColor(Root);
    If Root.Right <> Nil Then
    Begin
        PBox.Canvas.MoveTo(X, Y);
        PBox.Canvas.LineTo(X + XOffset, Y + 100);
        PrintDrawTree(Root.Right, PBox, X + XOffset, Y + 100, XOffset Div 2);
    End;
    PBox.Canvas.Ellipse(X - 25, Y - 25, X + 25, Y + 25);
    PBox.Canvas.TextOut(X - 17, Y - 7, IntToStr(Root.Data));
End;

Procedure ClearTreeMemory(Root: Node);
Begin
    If Root = Nil Then
        Exit;
    ClearTreeMemory(Root.Left);
    ClearTreeMemory(Root.Right);
    Dispose(Root);
End;

Procedure FreeTree();
Begin
    BinaryTree := Head;
    ClearTreeMemory(BinaryTree);
    Head := Nil;
    LongestPoint := Nil;
End;

Procedure DrawTree(PaintBox: TPaintBox);
Begin
    PrintDrawTree(Head, PaintBox, PaintBox.Width Div 2, 30, PaintBox.Width Div 4);
    BinaryTree := Head;
End;

Exports
    CreateTree,
    GetExistPointsCount,
    GetExistPoints,
    PrintDrawTree,
    InsertNewBranch,
    SearchLongestWay,
    ToMirrorTree,
    PrintConsoleTree,
    DrawTree,
    FreeTree;

{$R *.res}

Begin

End.
