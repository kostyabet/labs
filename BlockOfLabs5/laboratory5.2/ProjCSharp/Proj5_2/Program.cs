namespace Proj5_2 {
    public class Node {
        public readonly int Data;
        public Node? Parent;
        public int LCost;
        public int RCost;
        public Node? Left;
        public Node? Right;

        public Node(int data, Node? parent) {
            Data = data;
            Parent = parent;
            Left = null;
            LCost = 0;
            RCost = 0;
            Right = null;
        }
    }

    enum WriteMenu {
        Exit = 1,
        Continue
    }

    public static class Program {
        private static Node? _root;
        private static int _exit = (int)WriteMenu.Exit;
        private static int _continue = (int)WriteMenu.Continue;
        private static int _maxCost = +1_000_000;
        private static int _minCost = -1_000_000;
        private static int _maxParent = 20;
        private static int _minParent = 1;
        private static int _minChild = 1;
        private static int _maxChild = 39;
        private const int MaxPointsCount = 40;
        private static Node? _longestPoint = _root;
        private static int _longWayCost = 0;
        private static readonly bool[] IsParentExist = new bool[MaxPointsCount];
        private static void PrintTree(Node root, string prefix = "", bool isLeft = false)
        {
            if (root == null)
                return;

            Console.WriteLine(prefix + (isLeft ? "├── " : "└── ") + root.Data);

            PrintTree(root.Left, prefix + (isLeft ? "│   " : "    "), true);

            PrintTree(root.Right, prefix + (isLeft ? "│   " : "    "), false);
        }
        private static void OutputTree()
        {
            PrintTree(_root);
            //InorderTraversal(_root, 0);
        }

        static void InorderTraversal(Node? root, int cost)
        {
            if (root == null) return;
            InorderTraversal(root.Left, cost + root.LCost);
            Console.Write(root.Data + " " + cost + '\n');
            InorderTraversal(root.Right, cost + root.RCost);
        }

        static int InputNum(ref int max, ref int min) {
            var num = 0;
            bool isCorrect;
            do {
                try {
                    num = Convert.ToInt32(Console.ReadLine());
                    isCorrect = true;
                } catch {
                    isCorrect = false; 
                }
                isCorrect = isCorrect && !(num > max || num < min);
                if (!isCorrect) Console.Write("Error. Number out of range: ");
            } while (!isCorrect);

            return num;
        }

        static void Search(ref Node? root, int value)
        {
            if (root == null) return;
            if (root.Data == value)
                _root = root;
            Search(ref root.Left, value);
            if (root.Data == value)
                _root = root;
            Search(ref root.Right, value);
        }
        
        static void InsertNewBranch(int parent, int child, int cost) {
            Node? temp = _root;
            Search(ref temp, parent);
            _root = InsertProcess(_root, _root, child, cost);
        }

        private static Node InsertProcess(Node? root, Node? parent, int child, int cost) {
            if (root == null) {
                IsParentExist[child] = true;
                root = new Node(child, parent);
                return root;
            }

            if (root.Left == null) {
                root.LCost = cost;
                root.Left = InsertProcess(root.Left, root, child, cost);   
            }
            else {
                root.RCost = cost;
                root.Right = InsertProcess(root.Right, root, child, cost);
            }

            return root;
        }

        private static int InputParentNum() {
            Console.Write("Input parent index: ");
            int parent;
            bool isCorrect;
            do {
                parent = InputNum(ref _maxParent, ref _minParent);
                Node? temp = _root;
                Search(ref temp, parent);
                isCorrect = IsParentExist[parent] && !(_root is { Left: not null, Right: not null });
                _root = temp;
                if (!isCorrect) Console.Write("Error. You should write parent index that exist: ");
            } while (!isCorrect);

            return parent;
        }

        private static int InputChildNum() {
            Console.Write("Write child index: ");
            int num;
            bool isCorrect;
            do {
                num = InputNum(ref _maxChild, ref _minChild);
                isCorrect = !IsParentExist[num];
                if (!isCorrect) Console.Write("Error. You should write child index that correct: ");
            } while (!isCorrect);
            return num;
        }

        static bool IsWriterWantContinue()
        {
            Console.WriteLine("1 - exit; 2 - write new branch;");
            Console.Write("Do you want write one more branch: ");
            var num = InputNum(ref _continue, ref _exit);
            return num switch {
                (int)WriteMenu.Continue => true,
                _ => false
            };
        }

        private static void InputBranch(out int parent, out int child, out int cost)
        {
            parent = InputParentNum();
            child = InputChildNum();
            Console.Write("How much this branch cost: ");
            cost = InputNum(ref _maxCost, ref _minCost);
        }
        private static void InputTree()
        {
            IsParentExist[1] = true;
            _root = new Node(1, null);
            Node head = _root;
            do {
                InputBranch(out int parent, out int child, out int cost);
                InsertNewBranch(parent,child,cost);
                _root = head;
            } while (IsWriterWantContinue());
        }

        private static void SearchLongestWay(Node? root, Node? pastRoot, int cost)
        {
            if (root == null) return;
            SearchLongestWay(root.Left, root, cost + root.LCost);
            if (cost > _longWayCost) {
                _longWayCost = cost;
                _longestPoint = root;
            }
            SearchLongestWay(root.Right, root, cost + root.RCost);
        }

        static void ToMirrorTree() {
            while (_longestPoint?.Parent != null) 
                _longestPoint = _longestPoint.Parent;
            
            Node temp = _longestPoint.Right;
            _longestPoint.Right = _longestPoint.Left;
            _longestPoint.Left = temp;
        }
        private static void TreatmentTree() {
            SearchLongestWay(_root, _root, 0);
            ToMirrorTree();
        }
        public static void Main() {
            InputTree();
            TreatmentTree();
            OutputTree();
        }
    }
}