﻿Unit BinaryTreeUnit;

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

Procedure CreateTree();
Procedure InsertNewBranch(Child, Cost: Integer);
Procedure SearchLongestWay();
Procedure ToMirrorTree();
Procedure PrintDrawTree(PBox: TPaintBox);
Function PrintConsoleTree(): String;

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
    While LongestPoint.Parent <> Nil Do
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
    If (Node <> Nil) Then
    Begin
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
End;

Function PrintConsoleTree(): String;
Var
    ResultStr: String;
Begin
    ResultStr := '';
    ConsoleTree(BinaryTree, ResultStr, '', False);
    PrintConsoleTree := ResultStr;
End;

Procedure DrawBinaryTree(Root: Node; X, Y, XOffset: Integer; PBox: TPaintBox);
Const
    NodeRadius: Integer = 25;
    MyColor: TColor = $00FFC8B0;
Var
    LHead: Node;
Begin
    If Root = Nil Then
        Exit;
    PBox.Canvas.Font.Size := 7;
    LHead := LongestPoint;
    PBox.Canvas.Brush.Color := ClWhite;
    While (LongestPoint.Parent <> Nil) Do
    Begin
        If (LongestPoint.Data = Root.Data) Then
            PBox.Canvas.Brush.Color := MyColor;
        LongestPoint := LongestPoint.Parent;
    End;
    If (LongestPoint.Data = Root.Data) Then
        PBox.Canvas.Brush.Color := MyColor;
    LongestPoint := LHead;
    If Root.Left <> Nil Then
    Begin
        PBox.Canvas.MoveTo(X, Y);
        PBox.Canvas.LineTo(X - XOffset, Y + 100);
    End;
    DrawBinaryTree(Root.Left, X - XOffset, Y + 100, XOffset Div 2, PBox);
    LHead := LongestPoint;
    PBox.Canvas.Brush.Color := ClWhite;
    While (LongestPoint.Parent <> Nil) Do
    Begin
        If (LongestPoint.Data = Root.Data) Then
            PBox.Canvas.Brush.Color := MyColor;
        LongestPoint := LongestPoint.Parent;
    End;
    If (LongestPoint.Data = Root.Data) Then
        PBox.Canvas.Brush.Color := MyColor;
    LongestPoint := LHead;
    If Root.Right <> Nil Then
    Begin
        PBox.Canvas.MoveTo(X, Y);
        PBox.Canvas.LineTo(X + XOffset, Y + 100);
    End;
    PBox.Canvas.Ellipse(X - NodeRadius, Y - NodeRadius, X + NodeRadius, Y + NodeRadius);
    PBox.Canvas.TextOut(X - 17, Y - 7, IntToStr(Root.Data));
    DrawBinaryTree(Root.Right, X + XOffset, Y + 100, XOffset Div 2, PBox);
End;

Procedure PrintDrawTree(PBox: TPaintBox);
Var
    StartX, StartY: Integer;
Begin
    StartX := PBox.Width Div 2;
    StartY := 30;
    DrawBinaryTree(BinaryTree, StartX, StartY, PBox.Width Div 4, PBox);
End;

End.
