namespace Proj5_2 {
    public class Node {
        public readonly int Data;
        public int LCost;
        public int RCost;
        public Node? Left;
        public Node? Right;

        public Node(int data) {
            Data = data;
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
        private static readonly bool[] IsParentExist = new bool[MaxPointsCount];
        private static void InorderTraversal() {
            InorderTraversal(_root, 0);
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

        static void Search(ref Node? root, int value) {
            if (root != null) {
                if (root.Data == value)
                    _root = root;
                Search(ref root.Left, value);
                if (root.Data == value)
                    _root = root;
                Search(ref root.Right, value);
            }
        }
        
        static void Insert(int parent, int child, int cost) {
            Node? temp = _root;
            Search(ref temp, parent);
            _root = InsertNode(_root, child, cost);
        }

        private static Node InsertNode(Node? root, int child, int cost) {
            if (root == null) {
                IsParentExist[child] = true;
                root = new Node(child);
                return root;
            }

            if (root.Left == null) {
                root.LCost = cost;
                root.Left = InsertNode(root.Left, child, cost);   
            }
            else {
                root.RCost = cost;
                root.Right = InsertNode(root.Right, child, cost);
            }

            return root;
        }

        static int InputParentNum() {
            Console.Write("Input parent index: ");
            int num;
            bool isCorrect;
            do {
                num = InputNum(ref _maxParent, ref _minParent);
                isCorrect = IsParentExist[num];
                if (!isCorrect) Console.Write("Error. You should write parent index that exist: ");
            } while (!isCorrect);

            return num;
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

        static bool IsPersonWantContinue()
        {
            Console.WriteLine("1 - exit; 2 - write new branch;");
            Console.Write("Do you want write one more branch: ");
            var num = InputNum(ref _continue, ref _exit);
            return num switch {
                (int)WriteMenu.Continue => true,
                _ => false
            };
        }

        private static void InputProcess()
        {
            IsParentExist[1] = true;
            _root = new Node(1);
            Node temp = _root;
            do {
                var parent = InputParentNum();
                var child = InputChildNum();
                Console.Write("Write cost ofo this branch: ");
                var cost = InputNum(ref _maxCost, ref _minCost);
                Insert(parent,child,cost);
                _root = temp;
            } while (IsPersonWantContinue());
        }

        public static void Main()
        {
            InputProcess();
            Console.WriteLine("Inorder Traversal:"); 
            InorderTraversal();
            Console.WriteLine();
        }
    }
}