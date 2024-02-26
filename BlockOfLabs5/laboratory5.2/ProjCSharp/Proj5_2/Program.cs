namespace Proj5_2 {
    public class Node {
        public readonly int Data;
        public readonly Node? Parent;
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
        private static Node? _root = null;
        private static int _exit = (int)WriteMenu.Exit;
        private static int _continue = (int)WriteMenu.Continue;
        private static int _maxInt = +1_000_000;
        private static int _minInt = -1_000_000;
        private static Node? _longestPoint = _root;
        private static int _longWayCost = 0;
        private static readonly HashSet<int> ExistPoints = new HashSet<int>();
        private static void PrintTree(Node? root,  string indent = "") {
            if (root == null) return;
            Console.WriteLine(indent + root.Data);
            indent += "    ";

            PrintTree(root.Left, indent);
            PrintTree(root.Right, indent);
        }
        private static void OutputTree()
        {
            if (_root != null) PrintTree(_root);
        }

        private static int InputNum(ref int max, ref int min) {
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

        private static void InsertNewBranch(int child, int cost) {
            _root = InsertProcess(_root, _root, child, cost);
        }
        private static Node InsertProcess(Node? root, Node? parent, int child, int cost) {
            if (root == null) {
                ExistPoints.Add(child);
                root = new Node(child, parent);
                return root;
            }

            if (root.Data > child) {
                if (root.Left?.Data == null)
                    root.LCost = cost;
                root.Left = InsertProcess(root.Left, root, child, cost);   
            }
            else {
                if (root.Right?.Data == null) 
                    root.RCost = cost;
                root.Right = InsertProcess(root.Right, root, child, cost);
            }

            return root;
        }
        private static int InputChildNum() {
            Console.Write("Write child index: ");
            int num;
            bool isCorrect;
            do {
                num = InputNum(ref _maxInt, ref _minInt);
                isCorrect = !ExistPoints.Contains(num);
                if (!isCorrect) Console.Write("Error. You should write child index that correct: ");
            } while (!isCorrect);
            return num;
        }

        private static bool IsWriterWantContinue()
        {
            Console.WriteLine("1 - exit; 2 - write new branch;");
            Console.Write("Do you want write one more branch: ");
            var num = InputNum(ref _continue, ref _exit);
            return num switch {
                (int)WriteMenu.Continue => true,
                _ => false
            };
        }

        private static void InputBranch(out int child, out int cost)
        {
            child = InputChildNum();
            cost = 0;
            if (ExistPoints.Count == 0) return;
            Console.Write("How much this branch cost: ");
            cost = InputNum(ref _maxInt, ref _minInt);
        }
        private static void InputTree()
        {
            do {
                InputBranch(out int child, out int cost);
                InsertNewBranch(child,cost);
            } while (IsWriterWantContinue());
        }

        private static void SearchLongestWay(Node? root, int cost)
        {
            if (root == null) return;
            SearchLongestWay(root.Left, cost + root.LCost);
            if (cost > _longWayCost) {
                _longWayCost = cost;
                _longestPoint = root;
            }
            SearchLongestWay(root.Right, cost + root.RCost);
        }

        private static void ToMirrorTree() {
            while (_longestPoint?.Parent != null) 
                _longestPoint = _longestPoint.Parent;
            
            Node? temp = _longestPoint?.Right;
            _longestPoint!.Right = _longestPoint.Left;
            _longestPoint.Left = temp;
        }
        private static void TreatmentTree() {
            SearchLongestWay(_root, 0);
            //ToMirrorTree();
        }
        public static void Main() {
            ExistPoints.Clear();
            InputTree();
            TreatmentTree();
            OutputTree();
        }
    }
}