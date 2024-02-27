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
    internal enum WRITE_MENU {
        EXIT = 1,
        CONTINUE
    }
    internal enum IOChoose {
        FILE = 1,
        CONSOLE
    }
    public static class Program {
        private const int FILE_VALUE = (int)IOChoose.FILE;
        private const int CONSOLE_VALUE = (int)IOChoose.CONSOLE;
        private const int EXIT = (int)WRITE_MENU.EXIT;
        private const int CONTINUE = (int)WRITE_MENU.CONTINUE;
        private static Node? root;
        private static Node? longestPoint = root;
        private const int MAX_INT = +1_000_000;
        private const int MIN_INT = -1_000_000;
        private const int MAX_KNOTS = 50;
        private const int SPACE_LIMITS = 4;
        private const int MIN_FILE_WAY_SIZE = 4;
        private static int longWayCost;
        private static readonly HashSet<int> existPoints = new HashSet<int>();
        private static void conditionOutput(){
            Console.WriteLine($"""
                Binary search trees.
                    1. Initially, you enter, either through a file or through the console, the nodes of 
                       your tree, as well as the weight of the branch at this node. 
                    2. The first node cannot have weight as a branch, because there is no other value.
                    3. Both price and weight are limited in the range from {MIN_INT} to {MAX_INT}.
                    4. When entering/outputting through a file, only the extension can be used.txt!

                """);
        }
        private static bool isProcessOfFileOutputCorrect(string filePath, string resultStr) {
            try {
                using (StreamWriter writerOutput = new StreamWriter(filePath))
                    writerOutput.WriteLine(resultStr);
                Console.WriteLine("Data successfully written to file.");
                return true;
            }
            catch {
                Console.Error.WriteLine("Error in writing. Try again.");
                return false;
            }
        }
        private static Node insertProcess(Node? root, Node? parent, int child, int cost) {
            if (root == null) {
                existPoints.Add(child);
                root = new Node(child, parent);
                return root;
            }
            if (root.Data > child) {
                if (root.Left?.Data == null) root.LCost = cost;
                root.Left = insertProcess(root.Left, root, child, cost);   
            }
            else {
                if (root.Right?.Data == null) root.RCost = cost;
                root.Right = insertProcess(root.Right, root, child, cost);
            }
            return root;
        }
        private static void insertNewBranch(int child, int cost, int exitCode = CONTINUE) {
            if (exitCode != EXIT) root = insertProcess(root, root, child, cost);
        }
        private static void outputTextAboutIoSelection(string ioTextInfo) {
            string outputString = $"""
            Select how you will {ioTextInfo} data:
                  {IOChoose.FILE}: {FILE_VALUE}    {IOChoose.CONSOLE}: {CONSOLE_VALUE}
            Your option: 
            """;
            Console.Write(outputString);
        }
        /// <summary>
        /// Here you can write a file for what purposes you are using (input|output)
        /// </summary>
        /// <param name="ioTextInfo"></param>
        /// <returns></returns>
        private static IOChoose chooseIoWay(string ioTextInfo) {
            outputTextAboutIoSelection(ioTextInfo);
            IOChoose result = 0;
            int chosenPath = 0;
            bool isCorrect;
            do {
                isCorrect = true;
                try {
                    chosenPath = Convert.ToInt32(Console.ReadLine());
                }
                catch {
                    isCorrect = false;
                }
                switch (chosenPath) {
                    case FILE_VALUE: result = IOChoose.FILE; break;
                    case CONSOLE_VALUE: result = IOChoose.CONSOLE; break;
                    default: isCorrect = false; break;
                }
                if (!isCorrect) Console.Error.Write($"You should write one natural number({FILE_VALUE}|{CONSOLE_VALUE}): ");
                else Console.WriteLine();
            } while (!isCorrect);
            return result;
        }
        private static bool pathCondition(string filePath) {
            if (filePath.Length < MIN_FILE_WAY_SIZE) {
                Console.Error.Write("The path is too short. Try again: ");
                return false;
            }
            string buffer = filePath.Substring(filePath.Length - MIN_FILE_WAY_SIZE);
            if (buffer.Equals(".txt")) return true;
            Console.Error.Write("Write .txt file. Try again: ");
            return false;
        }
        private static string inputFilePath() {
            string filePath = Console.ReadLine() ?? string.Empty;
            while (!pathCondition(filePath)) filePath = Console.ReadLine() ?? string.Empty;
            return filePath;
        }
        private static bool isCanOpenFile(string filePath) {
            FileInfo fileInfo = new FileInfo(filePath);
            return fileInfo.Exists;
        }
        private static bool isWriteable(string filePath) {
            try {
                using StreamWriter writer = new StreamWriter(filePath);
                writer.WriteLine(string.Empty);
                writer.Close();
                return true;
            }
            catch {
                return false;
            }
        }
        private static bool isReadable(string filePath) {
            try {
                using StreamReader reader = new StreamReader(filePath);
                reader.Read();
                reader.Close();
                return true;
            }
            catch {
                return false;
            }
        }
        private static bool accessModifierControl(string accessModifier, string filePath) {
            bool resultModifier = true;
            switch (accessModifier) {
                case "input": resultModifier = isReadable(filePath); break;
                case "output": resultModifier = isWriteable(filePath); break;
            }
            return resultModifier;
        }
        /// <summary>
        /// Write "input" if you want to get the file path for input.
        /// Write "output" if you want to get the path to the output file.
        /// </summary>
        /// <param name="accessModifier"></param>
        /// <returns></returns>
        private static string inputPathToTheFile(string accessModifier) {
            string filePath;
            bool isCorrect;
            do {
                filePath = inputFilePath();
                isCorrect = accessModifierControl(accessModifier, filePath) && isCanOpenFile(filePath);
                if (!isCorrect) Console.Error.Write("Can't open a file. Try write another way: ");
            } while (!isCorrect);
            return filePath;
        }
        private static int inputNumberFromFile(StreamReader inputReader, ref bool isCorrectInput, int minNum, int maxNum) {
            int num = 0, minCount = 1, spaceCounter = 0, character;
            bool endOfNum = false;
            while (isCorrectInput && !(endOfNum) && (character = inputReader.Read()) != -1) {
                int bufChar = character;
                isCorrectInput = isCorrectInput && !((character != ' ') && !(character is > '/' and < ':') &&
                                                     (character != '\n') && (character != '\r') && (character != '-'));
                if (character == ' ') ++spaceCounter;
                else spaceCounter = 0;
                isCorrectInput = spaceCounter != SPACE_LIMITS;
                if (character is > '/' and < ':')
                    num = num * 10 + character - 48;
                if (character == '-') minCount = -1;
                isCorrectInput = isCorrectInput && !((character == '-') && (minCount != -1));
                endOfNum = (character == ' ' || character == '\n') && (bufChar > '/' || bufChar < ':');
                isCorrectInput = isCorrectInput && !((num == 0) && character is > '/' and < ':');
                isCorrectInput = isCorrectInput && !(num > maxNum);
            }
            isCorrectInput = isCorrectInput && (endOfNum || inputReader.EndOfStream);
            isCorrectInput = isCorrectInput && !(num > maxNum || num < minNum);
            if (isCorrectInput) num = minCount * num;
            return num;
        }
        private static int[,] inputBranchesFromFile(StreamReader inputReader, ref bool isCorrectInput)
        {
            existPoints.Clear();
            int[,] parameters = new int[MAX_KNOTS,2];
            parameters[0, 0] = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT, MAX_INT);
            existPoints.Add(parameters[0, 0]);
            parameters[0, 1] = 0;
            int counter = 1;
            while (!inputReader.EndOfStream && isCorrectInput) {
                parameters[counter, 0] = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT, MAX_INT);
                if (isCorrectInput) isCorrectInput = !existPoints.Contains(parameters[counter, 0]);
                existPoints.Add(parameters[counter, 0]);
                isCorrectInput = isCorrectInput && !inputReader.EndOfStream;
                parameters[counter, 1] = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT, MAX_INT);
                counter++;
            }
            int[,] resultArr = new int[counter, 2];
            for (int j = 0; j < counter && isCorrectInput; ++j) {
                resultArr[j, 0] = parameters[j, 0];
                resultArr[j, 1] = parameters[j, 1];
            }
            existPoints.Clear();
            return resultArr;
        }
        private static bool isProcessOfFileInputCorrect(string filePath) {
            bool isCorrectInput = true;
            using StreamReader inputReader = new StreamReader(filePath);
            int[,] parameters = inputBranchesFromFile(inputReader, ref isCorrectInput);
            for (int i = 0; i < parameters.Length / 2 && isCorrectInput; ++i)
                insertNewBranch(parameters[i,0], i == 0 ? 0 : parameters[i,1]);
            isCorrectInput = isCorrectInput && inputReader.EndOfStream;
            if (!isCorrectInput) Console.Error.WriteLine("Error in reading. Try again.");
            inputReader.Close();
            return isCorrectInput;
        }
        private static void inputFormFile() {
            Console.Clear();
            string filePath;
            do {
                Console.Write("Write way to your file (*.txt): ");
                filePath = inputPathToTheFile("input");
            } while (!isProcessOfFileInputCorrect(filePath));
        }
        private static void inputBranch(out int child, out int cost, ref int exitCode) {
            child = 0;
            cost = 0;
            bool isCorrect;
            do {
                string[] parameters = { };
                try {
                    string input = Console.ReadLine() ?? string.Empty;
                    parameters = input.Split(' ');
                    child = int.Parse(parameters[0]);
                    if (existPoints.Count != 0) cost = int.Parse(parameters[1]);
                    isCorrect = true;
                }
                catch {
                    isCorrect = false;
                }
                if (existPoints.Count != 0 && parameters is ["exit"]) { exitCode = EXIT; return; } 
                if (existPoints.Count != 0) isCorrect = isCorrect && !(parameters.Length > 2);
                else isCorrect = isCorrect && !(parameters.Length > 1);
                isCorrect = isCorrect && !existPoints.Contains(child);
                isCorrect = isCorrect && child is <= MAX_INT and >= MIN_INT;
                isCorrect = isCorrect && cost is <= MAX_INT and >= MIN_INT;
                if (!isCorrect) Console.Write("Bad input! Try again: ");
            } while (!isCorrect);
        }
        private static void inputFromConsole() {
            int exitCode = CONTINUE;
            Console.Clear();
            do {
                switch (existPoints.Count) {
                    case MAX_KNOTS: Console.WriteLine("You write maximum count of knots!"); return;
                    case 0: Console.WriteLine("It is your first knot, write only kid."); break;
                    case 1: Console.WriteLine("\nWrite 'exit' for stop writing.\nWrite kid and after write cost of new branch."); break;
                }
                Console.Write("Input: ");
                inputBranch(out int child, out int cost, ref exitCode);
                insertNewBranch(child, cost, exitCode);
            } while (exitCode == CONTINUE);
        }
        private static void inputTree() {
            IOChoose path = chooseIoWay("input");
            switch (path)
            {
                case IOChoose.FILE: inputFormFile(); break;
                case IOChoose.CONSOLE: inputFromConsole(); break;
            }
            Console.Clear();
        }
        private static void searchLongestWay(Node? root, int cost) {
            if (root == null) return;
            searchLongestWay(root.Left, cost + root.LCost);
            if (cost > longWayCost) {
                longWayCost = cost;
                longestPoint = root;
            }
            searchLongestWay(root.Right, cost + root.RCost);
        }
        private static void toMirrorTree() {
            while (longestPoint?.Parent != null) longestPoint = longestPoint.Parent;
            Node? temp = longestPoint?.Right;
            if (temp == null) return;
            longestPoint!.Right = longestPoint.Left;
            longestPoint.Left = temp;
        }
        private static void treatmentTree() {
            searchLongestWay(root, 0);
            toMirrorTree();
        }
        private static void printTree(Node? node, ref string outputString, string prefix = "", bool isLeft = false) {
            if (node == null) return;
            outputString += prefix + (isLeft ? "├── " : "└── ") + node.Data + '\n';
            printTree(node.Left, ref outputString, prefix + (isLeft ? "│   " : "    "), true);
            printTree(node.Right, ref outputString, prefix + (isLeft ? "│   " : "    "));
        }
        private static void outputFromConsole(string resultStr) {
            Console.WriteLine(resultStr);
        }
        static void outputFormFile(string resultStr) {
            Console.Clear();
            string filePath;
            do {
                Console.Write("Write way to your file (*.txt): ");
                filePath = inputPathToTheFile("output");
            } while (!isProcessOfFileOutputCorrect(filePath, resultStr));
        }
        private static void outputTree() {
            string resultStr = "Your result tree: \n";
            printTree(root, ref resultStr);
            IOChoose path = chooseIoWay("output");
            switch (path) {
                case IOChoose.FILE: outputFormFile(resultStr); break;
                default: outputFromConsole(resultStr); break;
            }
        }
        public static void Main() {
            existPoints.Clear();
            conditionOutput();
            inputTree();
            treatmentTree();
            outputTree();
        }
    }
}