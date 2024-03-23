using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Proj6_2 {
    internal enum IOChoose {
        FILE = 1,
        CONSOLE
    }
    class Combinator {
        private const int FILE_VALUE = (int)IOChoose.FILE;
        private const int CONSOLE_VALUE = (int)IOChoose.CONSOLE;
        private const int MAX_SIZE = 6;
        private const int MIN_SIZE = 1;
        private const int MAX_INT = +1_000_000;
        private const int MIN_INT = -1_000_000;
        private const int STEPS_COUNT = 4;
        private const int SPACE_LIMITS = 4;
        private const int MIN_FILE_WAY_SIZE = 4;
        private static void conditionOutput() {
            Console.WriteLine($"""
                Combinatorics. 
                    The user enters the matrix arr(m,n). 
                    The program finds in it the path from the arr[i1,j1] element to the arr[i2,j2] 
                    element with the maximum amount. The algorithm moves horizontally and vertically. 
                    Each element of the matrix enters the path no more than once. 
                    When displaying the result, the path in the matrix is highlighted!

                Limitations:
                    1. The dimensions of the matrix are within [{MIN_SIZE}; {MAX_SIZE}];
                    2. The elements of the matrix are within [{MIN_INT}; {MAX_INT}];
                    3. When entering/outputting through a file, only the extension can be used.txt!
                        3.1 First, there are 2 numbers M and N in the file:
                            • M - row count;
                            • N - col count;
                        3.2 Then there are numbers, the number of which M x N;
                        3.3 Then there should be coordinates of 2 points: i1, j1, i2, j2;

                """);
        }
        static int InputNumberFromConsole(int MAX, int MIN) {
            int val = 0;
            bool isCorrect;
            do {
                try {
                    val = Convert.ToInt32(Console.ReadLine());
                    isCorrect = true;
                } catch {
                    isCorrect = false;
                }
                isCorrect = isCorrect && !(val > MAX || val < MIN);
                if (!isCorrect) Console.Write("Error! Try again: ");
            } while (!isCorrect);
            return val;
        }
        static int inputNumberFromFile(StreamReader inputReader, ref bool isCorrectInput, int minNum, int maxNum) {
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
                isCorrectInput = isCorrectInput && !((bufChar == 0) && character is > '/' and < ':');
                isCorrectInput = isCorrectInput && !(num > maxNum);
            }
            isCorrectInput = isCorrectInput && !(num > maxNum || num < minNum);
            if (isCorrectInput) num = minCount * num;
            return num;
        }
        static void InputMatrixSize(out int m, out int n) {
            Console.WriteLine("Input your matrix size (m x n)");
            Console.Write("M: ");
            m = InputNumberFromConsole(MAX_SIZE, MIN_SIZE);
            Console.Write("N: ");
            n = InputNumberFromConsole(MAX_SIZE, MIN_SIZE);
        }
        static void ChangeMatrixSize(out int[][] matrix, int m, int n) {
            matrix = new int[m][];
            for (int i = 0; i < matrix.Length; i++)
                matrix[i] = new int[n];
        }
        static void InputMatrixElements(ref int[][] matrix) {
            Console.WriteLine("Input matrix elements.");
            for (int i = 0; i < matrix.Length; i++)
                for (int j = 0; j < matrix[i].Length; j++) {
                    Console.Write($"Write arr[{i};{j}]: ");
                    matrix[i][j] = InputNumberFromConsole(MAX_INT, MIN_INT);
                }
        }
        static void InputPoint(int maxm, int maxn, out int i, out int j, char pointer) {
            int min = 0;
            Console.WriteLine($"Input i{pointer}, j{pointer}.");
            Console.Write($"Input i{pointer}: ");
            i = InputNumberFromConsole(maxm, min);
            Console.Write($"Input j{pointer}: ");
            j = InputNumberFromConsole(maxn, min);
        }
        static void InputFromConsole(out int[][] matrix, out int i1, out int j1, out int i2, out int j2) {
            Console.Clear();
            InputMatrixSize(out int m, out int n);
            ChangeMatrixSize(out matrix, m, n);
            InputMatrixElements(ref matrix);
            InputPoint(m - 1, n - 1, out i1, out j1, '1');
            InputPoint(m - 1, n - 1, out i2, out j2, '2');
        }
        static void outputTextAboutIoSelection(string ioTextInfo) {
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
        static IOChoose chooseIoWay(string ioTextInfo) {
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
        static bool isWriteable(string filePath) {
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
        static bool isReadable(string filePath) {
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
        static bool pathCondition(string filePath) {
            if (filePath.Length < MIN_FILE_WAY_SIZE) {
                Console.Error.Write("The path is too short. Try again: ");
                return false;
            }
            string buffer = filePath.Substring(filePath.Length - MIN_FILE_WAY_SIZE);
            if (buffer.Equals(".txt")) return true;
            Console.Error.Write("Write .txt file. Try again: ");
            return false;
        }
        static string inputFilePath() {
            string filePath = Console.ReadLine() ?? string.Empty;
            while (!pathCondition(filePath)) filePath = Console.ReadLine() ?? string.Empty;
            return filePath;
        }
        static bool accessModifierControl(string accessModifier, string filePath) {
            bool resultModifier = true;
            switch (accessModifier) {
                case "input": resultModifier = isReadable(filePath); break;
                case "output": resultModifier = isWriteable(filePath); break;
            }
            return resultModifier;
        }
        static bool isCanOpenFile(string filePath) {
            FileInfo fileInfo = new FileInfo(filePath);
            return fileInfo.Exists;
        }
        /// <summary>
        /// Write "input" if you want to get the file path for input.
        /// Write "output" if you want to get the path to the output file.
        /// </summary>
        /// <param name="accessModifier"></param>
        /// <returns></returns>
        static string inputPathToTheFile(string accessModifier) {
            string filePath;
            bool isCorrect;
            do {
                filePath = inputFilePath();
                isCorrect = accessModifierControl(accessModifier, filePath) && isCanOpenFile(filePath);
                if (!isCorrect) Console.Error.Write("Can't open a file. Try write another way: ");
            } while (!isCorrect);
            return filePath;
        }
        static bool isProcessOfFileInputCorrect(string filePath, out int[][] matrix, out int i1, out int j1, out int i2, out int j2) {
            bool isCorrectInput = true;
            using StreamReader inputReader = new StreamReader(filePath);
            int m = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_SIZE, MAX_SIZE);
            int n = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_SIZE, MAX_SIZE);
            ChangeMatrixSize(out matrix, m, n);
            for (int i = 0; i < matrix.Length && isCorrectInput; ++i)
                for (int j = 0; j < matrix[i].Length && isCorrectInput; ++j)
                    matrix[i][j] = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_SIZE, MAX_SIZE);
            i1 = inputNumberFromFile(inputReader, ref isCorrectInput, m, n);
            j1 = inputNumberFromFile(inputReader, ref isCorrectInput, m, n);
            i2 = inputNumberFromFile(inputReader, ref isCorrectInput, m, n);
            j2 = inputNumberFromFile(inputReader, ref isCorrectInput, m, n);
            isCorrectInput = isCorrectInput && inputReader.EndOfStream;
            if (!isCorrectInput) Console.Error.WriteLine("Error in reading. Try again.");
            inputReader.Close();
            return isCorrectInput;
        }
        static void InputFormFile(out int[][] matrix, out int i1, out int j1, out int i2, out int j2) {
            Console.Clear();
            string filePath;
            do {
                Console.Write("Write way to your file (*.txt): ");
                filePath = inputPathToTheFile("input");
            } while (!isProcessOfFileInputCorrect(filePath, out matrix, out i1, out j1, out i2, out j2));
        }
        static void InputProcess(out int[][] matrix, out int i1, out int j1, out int i2, out int j2) {
            IOChoose path = chooseIoWay("input");
            switch (path) {
                case IOChoose.FILE: InputFormFile(out matrix, out i1, out j1, out i2, out j2); break;
                default: InputFromConsole(out matrix, out i1, out j1, out i2, out j2); break;
            }
        }
        static void SearchLongestWay(int[][] matrix, int i1, int j1, int i2, int j2, List<int[]> resWayCoords) {
            int[,] st = {{0, 1}, {1, 0}, {-1, 0}, {0, -1}};  
            int ans = -int.MaxValue;
            bool[,] used = new bool[matrix.Length, matrix[0].Length];
            int[] start = { i1, j1 };
            List<int[]> TempList = [];
            TempList.Add(start);
            used[i1, j1] = true;
            rec(i1, j1, i2, j2, matrix[i1][j1]);
            void rec(int sx, int sy, int fx, int fy, int sum) {
                for (int i = 0; i < STEPS_COUNT; i++) {
                    int x = sx + st[i, 0];
                    int y = sy + st[i, 1];
                    if (!(x < 0 || y < 0 || x >= matrix.Length || y >= matrix[0].Length || used[x, y])) {
                        if (x == fx && y == fy && sum + matrix[x][y] > ans)  {
                            ans = sum + matrix[x][y];
                            resWayCoords.Clear();
                            resWayCoords.AddRange(TempList);
                        }
                        int[] add = { x, y };
                        TempList.Add(add);
                        used[x, y] = true;
                        rec(x, y, fx, fy, sum + matrix[x][y]);
                        used[x, y] = false;
                        TempList.RemoveAt(TempList.Count - 1);
                    }
                }
            }
            int[] end = { i2, j2 };
            resWayCoords.Add(end);
        }
        static void outputFromConsole(string resultStr) {
            Console.WriteLine(resultStr);
        }
        static bool isProcessOfFileOutputCorrect(string filePath, string resultStr) {
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
        static void outputFormFile(string resultStr) {
            Console.Clear();
            string filePath;
            do {
                Console.Write("Write way to your file (*.txt): ");
                filePath = inputPathToTheFile("output");
            } while (!isProcessOfFileOutputCorrect(filePath, resultStr));
        }
        static void InputMatrixInRes(ref int[][] matrix, ref List<int[]> resWayCoords, ref string resultStr) {
            for (int i = 0; i < matrix.Length; i++) {
                for (int j = 0; j < matrix[i].Length; j++) {
                    resultStr += matrix[i][j].ToString().PadLeft(6);
                }
                resultStr += "\n";
            }
        }
        static void InputLongestWayInRes(ref int[][] matrix, ref List<int[]> resWayCoords, ref string resultStr) {
            for (int i = 0; i < matrix.Length; i++) {
                for (int j = 0; j < matrix[i].Length; j++) {
                    string outputVal = ".";
                    for (int k = 0; k < resWayCoords.Count; k++)
                        if (resWayCoords[k][0] == i && resWayCoords[k][1] == j) 
                            outputVal = k.ToString().PadLeft(6);
                    resultStr += outputVal + " ";
                }
                resultStr += "\n";
            }
        }
        static void outputMatrix(ref int[][] matrix, ref List<int[]> resWayCoords, ref string resultStr) {
            resultStr += "Input Matrix: \n";
            InputMatrixInRes(ref matrix, ref resWayCoords, ref resultStr);
            resultStr += "Longest Way: \n";
            InputLongestWayInRes(ref matrix, ref resWayCoords, ref resultStr);
        }
        static void OutputResult(ref int[][] matrix, ref List<int[]> resWayCoords) {
            Console.Clear();
            string resultStr = "Result longest way: \n";
            outputMatrix(ref matrix, ref resWayCoords, ref resultStr);
            IOChoose path = chooseIoWay("output");
            switch (path) {
                case IOChoose.FILE: outputFormFile(resultStr); break;
                case IOChoose.CONSOLE: outputFromConsole(resultStr); break;
            }
        }
        public static void Main(string[] args) {
            List<int[]> resWayCoords = [];
            conditionOutput();
            InputProcess(out int[][] matrix, out int i1, out int j1, out int i2, out int j2);
            SearchLongestWay(matrix, i1, j1, i2, j2, resWayCoords);
            OutputResult(ref matrix, ref resWayCoords);
        }
    }
}