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
    enum IoChoose
    {
        File = 1,
        Console
    }


    public static class Program {
        private const int FileValue = (int)IoChoose.File;
        private const int ConsoleValue = (int)IoChoose.Console;
        private static Node? _root;
        private static int _exit = (int)WriteMenu.Exit;
        private static int _continue = (int)WriteMenu.Continue;
        private const int MaxInt = +1_000_000;
        private const int MinInt = -1_000_000;
        private const int MaxKnots = 50;
        private static Node? _longestPoint = _root;
        private static int _longWayCost;
        private static readonly HashSet<int> ExistPoints = new HashSet<int>();
        const int MinFileWaySize = 4;
        private static void PrintTree(Node? node, ref string outputString, string prefix = "", bool isLeft = false)
        {
            if (node == null) return;
            outputString += prefix + (isLeft ? "├── " : "└── ") + node.Data + '\n';
            PrintTree(node.Left, ref outputString, prefix + (isLeft ? "│   " : "    "), true);
            PrintTree(node.Right, ref outputString, prefix + (isLeft ? "│   " : "    "));
        }

        private static bool IsProcessOfFileOutputCorrect(string filePath, string resultStr)
        {
            try
            {
                using (StreamWriter writerOutput = new StreamWriter(filePath))
                    writerOutput.WriteLine(resultStr);

                Console.WriteLine("Data successfully written to file.");
                return true;
            }
            catch
            {
                Console.Error.WriteLine("Error in writing. Try again.");
                return false;
            }
        }
        static void OutputFormFile(string resultStr)
        {
            Console.Clear();
            string filePath;

            do
            {
                Console.Write("Write way to your file (*.txt): ");
                filePath = InputPathToTheFile("output");
            } while (!IsProcessOfFileOutputCorrect(filePath, resultStr));
        }

        private static void OutputFromConsole(string resultStr)
        {
            Console.WriteLine();
            Console.WriteLine(resultStr);
        }
        private static void OutputTree()
        {
            string resultStr = "Your result tree: \n";
            PrintTree(_root, ref resultStr);
            IoChoose path = ChooseIoWay("output");

            switch (path) {
                case IoChoose.File: OutputFormFile(resultStr); break;
                case IoChoose.Console: OutputFromConsole(resultStr); break;
            }
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

        private static void InputBranch(out int child, out int cost) {
            child = 0;
            cost = 0;
            bool isCorrect;
            do
            {
                string[] parameters = new string[] { };
                try {
                    string input = Console.ReadLine() ?? string.Empty;
                    parameters = input.Split(' ');
                    child = int.Parse(parameters[0]);
                    if (ExistPoints.Count != 0) cost = int.Parse(parameters[1]);
                    isCorrect = true;
                }
                catch {
                    isCorrect = false;
                }
                if (ExistPoints.Count != 0) isCorrect = isCorrect && !(parameters.Length > 2);
                else isCorrect = isCorrect && !(parameters.Length > 1);
                isCorrect = isCorrect && !ExistPoints.Contains(child);
                isCorrect = isCorrect && !(child > MaxInt || child < MinInt);
                isCorrect = isCorrect && !(cost > MaxInt || cost < MinInt);
                if (!isCorrect) Console.Write("Bad input! Try again: ");
            } while (!isCorrect);
        }

        private static void InputFromConsole()
        {
            Console.Clear();
            do {
                switch (ExistPoints.Count) {
                    case MaxKnots: Console.WriteLine("You write maximum count of knots!"); return;
                    case 0: Console.WriteLine("It is your first knot, write only kid."); break;
                    case 1: Console.WriteLine("Write kid and after write cost of new branch."); break;
                }
                Console.Write("Input: ");
                InputBranch(out int child, out int cost);
                InsertNewBranch(child,cost);
            } while (IsWriterWantContinue());
        }

        private static void OutputTextAboutIoSelection(string ioTextInfo)
        {
            string outputString = $"""
            Select how you will {ioTextInfo} data:
                  {IoChoose.File}: {FileValue}    {IoChoose.Console}: {ConsoleValue}
            Your option: 
            """;
            Console.Write(outputString);
        }
        /// <summary>
        /// Here you can write a file for what purposes you are using (input|output)
        /// </summary>
        /// <param name="ioTextInfo"></param>
        /// <returns></returns>
        private static IoChoose ChooseIoWay(string ioTextInfo)
        {
            OutputTextAboutIoSelection(ioTextInfo);

            IoChoose result = 0;
            int chosenPath = 0;
            bool isCorrect;

            do
            {
                isCorrect = true;
                try
                {
                    chosenPath = Convert.ToInt32(Console.ReadLine());
                }
                catch
                {
                    isCorrect = false;
                }

                switch (chosenPath)
                {
                    case FileValue: result = IoChoose.File; break;
                    case ConsoleValue: result = IoChoose.Console; break;
                    default: isCorrect = false; break;
                }

                if (!isCorrect) Console.Error.Write($"You should write one natural number({FileValue}|{ConsoleValue}): ");
                else Console.WriteLine();
            } while (!isCorrect);

            return result;
        }

        private static bool PathCondition(string filePath)
        {
            if (filePath.Length < MinFileWaySize)
            {
                Console.Error.Write("The path is too short. Try again: ");
                return false;
            }

            string buffer = filePath.Substring(filePath.Length - MinFileWaySize);
            if (!buffer.Equals(".txt"))
            {
                Console.Error.Write("Write .txt file. Try again: ");
                return false;
            }

            return true;
        }

        private static string InputFilePath()
        {
            string filePath = Console.ReadLine() ?? string.Empty;

            while (!PathCondition(filePath))
                filePath = Console.ReadLine() ?? string.Empty;

            return filePath;
        }

        private static bool IsCanOpenFile(string filePath)
        {
            FileInfo fileInfo = new FileInfo(filePath);
            return fileInfo.Exists;
        }

        private static bool IsWriteable(string filePath)
        {
            try
            {
                using StreamWriter writer = new StreamWriter(filePath);
                writer.WriteLine(string.Empty);
                writer.Close();
                return true;
            }
            catch
            {
                return false;
            }
        }

        private static bool IsReadable(string filePath)
        {
            try
            {
                using StreamReader reader = new StreamReader(filePath);
                reader.Read();
                reader.Close();
                return true;
            }
            catch
            {
                return false;
            }
        }

        private static bool AccessModifierControl(string accessModifier, string filePath)
        {
            bool resultModifier = true;

            switch (accessModifier) {
                case "input": resultModifier = IsReadable(filePath); break;
                case "output": resultModifier = IsWriteable(filePath); break;
            }

            return resultModifier;
        }
        /// <summary>
        /// Write "input" if you want to get the file path for input.
        /// Write "output" if you want to get the path to the output file.
        /// </summary>
        /// <param name="accessModifier"></param>
        /// <returns></returns>
        private static string InputPathToTheFile(string accessModifier)
        {
            string filePath;
            bool isCorrect;
            do
            {
                filePath = InputFilePath();
                isCorrect = AccessModifierControl(accessModifier, filePath) && IsCanOpenFile(filePath);

                if (!isCorrect)
                    Console.Error.Write("Can't open a file. Try write another way: ");

            } while (!isCorrect);

            return filePath;
        }
        private static bool IsProcessOfFileInputCorrect(string filePath)
        {
            bool isCorrectInput = true;

            using StreamReader inputReader = new StreamReader(filePath);
            //ACount = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT_NUM, MAX_INT_NUM);
            isCorrectInput = isCorrectInput && inputReader.EndOfStream;
            if (!isCorrectInput) Console.Error.WriteLine("Error in reading. Try again.");
            inputReader.Close();
            
            return isCorrectInput;
        }
        static void InputFormFile()
        {
            Console.Clear();
            string filePath;
            do {
                Console.Write("Write way to your file (*.txt): ");
                filePath = InputPathToTheFile("input");
            } while (!IsProcessOfFileInputCorrect(filePath));
        }
        private static void InputTree() {
            IoChoose path = ChooseIoWay("input");

            switch (path)
            {
                case IoChoose.File: InputFormFile(); break;
                case IoChoose.Console: InputFromConsole(); break;
            }
            Console.Clear();
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
            if (temp == null) return;
            _longestPoint!.Right = _longestPoint.Left;
            _longestPoint.Left = temp;
        }
        private static void TreatmentTree() {
            SearchLongestWay(_root, 0);
            ToMirrorTree();
        }
        public static void Main() {
            ExistPoints.Clear();
            InputTree();
            TreatmentTree();
            OutputTree();
        }
    }
}