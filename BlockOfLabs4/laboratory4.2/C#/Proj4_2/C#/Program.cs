enum IOChoose : Int32
{
    FILE,
    CONSOLE
}
class Proj4_2
{
    const int FILE_VALUE = (int)IOChoose.FILE;
    const int CONSOLE_VALUE = (int)IOChoose.CONSOLE;
    const int MIN_INT_NUM = -2_000_000;
    const int MAX_INT_NUM = +2_000_000;
    const int MIN_N = 1;
    const int MAX_N = 20;
    const int MIN_FILE_WAY_SIZE = 4;
    static void outputTextAboutIOSelection(string IOTextInfo)
    {
        Console.WriteLine($"Select how you will {IOTextInfo} data:");
        Console.WriteLine($"    {IOChoose.FILE}: {FILE_VALUE}    {IOChoose.CONSOLE}: {CONSOLE_VALUE}");
        Console.Write("Your option: ");
    }
    /// <summary>
    /// Here you can write a file for what purposes you are using (input|output)
    /// </summary>
    /// <param name="IOTextInfo"></param>
    /// <returns></returns>
    static IOChoose chooseIOWay(string IOTextInfo)
    {
        outputTextAboutIOSelection(IOTextInfo);

        IOChoose result = 0;
        int ChosenPath = 0;
        bool isCorrect = true;

        do
        {
            isCorrect = true;
            try
            {
                ChosenPath = Convert.ToInt32(Console.ReadLine());
            }
            catch
            {
                isCorrect = false;
            }

            switch (ChosenPath)
            {
                case 0: result = IOChoose.FILE; break;
                case 1: result = IOChoose.CONSOLE; break;
                default: isCorrect = false; break;
            }
            
            if (!isCorrect) Console.Write($"You should write one natural number({CONSOLE_VALUE}|{FILE_VALUE}): ");
            else Console.WriteLine();
        } while (!isCorrect);

        return result;
    }
    static bool pathCondition(string filePath)
    {
        if (filePath.Length < MIN_FILE_WAY_SIZE)
        {
            Console.Write("The path is too short. Try again: ");
            return false;
        }

        string bufstr = filePath.Substring(filePath.Length - MIN_FILE_WAY_SIZE);
        if (!bufstr.Equals(".txt"))
        {
            Console.Write("Write .txt file. Try again: ");
            return false;
        }

        return true;
    }


    static string inputFilePath()
    {
        string filePath = string.Empty;
        bool isCorrect = true;

        do
        {
            filePath = Console.ReadLine() ?? string.Empty;
            isCorrect = pathCondition(filePath);
        } while (!isCorrect);

        return filePath;
    }

    static bool isCanOpenFile(string filePath)
    {
        FileInfo fileInfo = new FileInfo(filePath);
        return fileInfo.Exists;
    }

    static bool isCanWrite(string filePath)
    {
        try
        {
            using (StreamWriter writer = new StreamWriter(filePath))
                writer.WriteLine(string.Empty);
           
            return true;
        }
        catch
        {
            return false;
        }
    }

    static bool isCanRead(string filePath)
    {
        try
        {
            FileAttributes attributes = File.GetAttributes(filePath);
            return (attributes & FileAttributes.ReadOnly) == FileAttributes.ReadOnly;
        }
        catch
        {
            return false;
        }
    }

    static bool accessModifierControl(string accessModifier, string filePath)
    {
        bool resultModifier = true;

        switch (accessModifier){
            case "input": resultModifier = isCanRead(filePath); break;
            case "output": resultModifier = isCanWrite(filePath); break;
        }

        return resultModifier;
    }
    /// <summary>
    /// Write "input" if you want to get the file path for input.
    /// Write "output" if you want to get the path to the output file.
    /// </summary>
    /// <param name="accessModifier"></param>
    /// <returns></returns>
    static string inputPathToTheFile(string accessModifier)
    {
        string filePath = string.Empty;
        bool isCorrect = true;
        do
        {
            filePath = inputFilePath();
            isCorrect = accessModifierControl(accessModifier, filePath) && isCanOpenFile(filePath);

            if (!isCorrect)
                Console.Write("Can't open a file. Try write another way: ");
            
        } while (!isCorrect);

        return filePath;
    }

    static int inputNumberFromFile(StreamReader inputReader, ref bool isCorrectInput, int MIN_NUM, int MAX_NUM)
    {
        int num = 0;
        bool isCorrect = true;
        int character, bufChar = 0;

        while (isCorrect && isCorrectInput && (character = inputReader.Read()) != -1)
        {
            if (!(character == ' ' || character == 13 || character == 10 || !(character > '9' && character < '0')))
                isCorrectInput = false;

            if (character != ' ' && character != 13 && character != 10 && isCorrectInput)
                num = num * 10 + character - 48;

            if (bufChar != 0 && isCorrectInput && (character == ' ' || character == 13 || character == 10))
                isCorrect = false;

            if (num > MAX_NUM)
                isCorrect = false;
            
            bufChar = character;
        }

        if (isCorrectInput && (num > MAX_NUM || num < MIN_NUM || bufChar == 0))
            isCorrectInput = false;

        return num;
    }

    static void inputVectorFromFile(StreamReader inputReader, ref int[] Vector, ref bool isCorrectInput)
    {
        for (int i = 0; i < Vector.Length && isCorrectInput; ++i)
            Vector[i] = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT_NUM, MAX_INT_NUM);
    }

    static bool isProcesOfFileInputCorrect(ref int A, ref int[] B_Vector, ref int[] C_Vector, string filePath, ref int N)
    {
        bool isCorrectInput = true;

        using (StreamReader inputReader = new StreamReader(filePath))
        {
            A = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT_NUM, MAX_INT_NUM);
            N = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_N, MAX_N);
            B_Vector = new int[N];
            C_Vector = new int[N];

            inputVectorFromFile(inputReader, ref B_Vector, ref isCorrectInput);
            inputVectorFromFile(inputReader, ref C_Vector, ref isCorrectInput);

            isCorrectInput = isCorrectInput && inputReader.EndOfStream ? true : false;
            if (!isCorrectInput) Console.WriteLine("Error in reading. Try again.");
        }

        return isCorrectInput;
    }

    static void InputFormFile(ref int A, ref int[] B_Vector, ref int[] C_Vector, ref int N)
    {
        bool isCorrect = true;
        do
        {
            Console.Write("Write way to your file (*.txt): ");
            string filePath = inputPathToTheFile("input");

            isCorrect = isProcesOfFileInputCorrect(ref A, ref B_Vector, ref C_Vector, filePath, ref N);
        } while (!isCorrect);
    }
    static int InputNumberFromConsole(int MIN_NUM, int MAX_NUM)
    {
        int num = 0;
        bool isCorrect = true;

        do
        {
            isCorrect = true;
            try
            {
                num = Convert.ToInt32(Console.ReadLine());
            } catch
            {
                isCorrect = false;
            }

            isCorrect = isCorrect && !(num < MIN_NUM) && !(num > MAX_NUM) ? true : false;

            if (!isCorrect) Console.Write($"Number must be from {MIN_NUM} to {MAX_NUM}: ");
        } while (!isCorrect);

        return num;
    }
    static void InputVectorFromConsole(ref int[] Vector)
    {
        for (int i = 0; i < Vector.Length; ++i)
        {
            Console.Write($"Write your {i+1} coordinate: ");
            Vector[i] = InputNumberFromConsole(MIN_INT_NUM, MAX_INT_NUM);
        }
    }
    static void InputFromConsole(ref int A, ref int[] B_Vector, ref int[] C_Vector, ref int N)
    {
        Console.Write("Write A: ");
        A = InputNumberFromConsole(MIN_INT_NUM, MAX_INT_NUM);
        Console.Write("Write N - size of vectors: ");
        N = InputNumberFromConsole(MIN_N, MAX_N);
        B_Vector = new int[N];
        C_Vector = new int[N];
        Console.WriteLine("\nWrite vector B.");
        InputVectorFromConsole(ref B_Vector);
        Console.WriteLine("\nWrite vector C.");
        InputVectorFromConsole(ref C_Vector);
    }
    static void inputData(ref int A, ref int[] B_Vector, ref int[] C_Vector, ref int N)
    {
        IOChoose path = chooseIOWay("input");

        switch (path)
        {
            case IOChoose.FILE: InputFormFile(ref A, ref B_Vector, ref C_Vector, ref N); break;
            case IOChoose.CONSOLE: InputFromConsole(ref A, ref B_Vector, ref C_Vector, ref N); break;
        }
    }
    static void treatmentData(int A, int[] B_Vector, int[] C_Vector, int N, ref HashSet<int> I)
    {
        
    }
    static string createStringWithVector(int[] Vector)
    {
        string vectorStr = string.Empty;
        for (int i = 0; i < Vector.Length; i++)
            vectorStr += Vector[i] + " ";

        return vectorStr;
    }
    static string createStringWithSet(HashSet<int> I)
    {
        if (I.Count == 0)
            return "empty set...";

        string setStr = string.Empty;
        foreach (int i in I)
            setStr += i + " ";

        return setStr;
    }
    static string createResultString(int A, int[] B_Vector, int[] C_Vector, int N, HashSet<int> I)
    {
        string resultStr = string.Empty;
        resultStr += $"A: {A};\nN: {N};\nvector B: ";
        resultStr += createStringWithVector(B_Vector);
        resultStr += "\nvector C: ";
        resultStr += createStringWithVector(C_Vector);
        resultStr += "\nresult set I: ";
        resultStr += createStringWithSet(I);
        return resultStr;
    }
    static bool isProcesOfFileOutputCorrect(string filePath, string resultStr)
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
            Console.WriteLine("Error in writing. Try again.");
            return false;
        }
    }
    static void OutputFormFile(string resultStr)
    {
        bool isCorrect = true;
        do
        {
            Console.Write("Write way to your file (*.txt): ");
            string filePath = inputPathToTheFile("output");

            isCorrect = isProcesOfFileOutputCorrect(filePath, resultStr);
        } while (!isCorrect);
    }
    static void OutputFromConsole(string resultStr)
    {
        Console.WriteLine("\nresultStr");
    }
    static void outputData(int A, int[] B_Vector, int[] C_Vector, int N, HashSet<int> I)
    {
        string resultStr = createResultString(A, B_Vector, C_Vector, N, I);
        IOChoose path = chooseIOWay("output");

        switch (path)
        {
            case IOChoose.FILE: OutputFormFile(resultStr); break;
            case IOChoose.CONSOLE: OutputFromConsole(resultStr); break;
        }
    }
    public static void Main(string[] args)
    {
        int A = 0;
        int N = 0;
        int[] B_Vector = { };
        int[] C_Vector = { };
        HashSet<int> I = new HashSet<int>();
        
        inputData(ref A, ref B_Vector, ref C_Vector, ref N);
        treatmentData(A, B_Vector, C_Vector, N, ref I);
        outputData(A, B_Vector, C_Vector, N, I);
    }
}