using System;

enum IOChoose : Byte
{
    FILE = 1,
    CONSOLE
}
class Proj4_2
{
    const int FILE_VALUE = (int)IOChoose.FILE;
    const int CONSOLE_VALUE = (int)IOChoose.CONSOLE;
    const int MIN_INT_NUM = -20_000_000;
    const int MAX_INT_NUM = +20_000_000;
    const int MIN_N = 1;
    const int MAX_N = 15;
    const int MIN_FILE_WAY_SIZE = 4;

    static void taskInfoOutput()
    {
        string outputString = $"""
            The program determines a subset(I) of expenses {"{1..N}"}.
            Where N is the number of coordinate vectors B and C.

            The sum of the elements of vector B with numbers from 
            subset I is maximum, provided that the sum of the 
            elements from set C with the same numbers is not greater 
            than the integer A.

            Restrictions:
                1. A belongs to the interval [{MIN_INT_NUM}; {MAX_INT_NUM}];
                2. N belongs to the interval [{MIN_N}; {MAX_N}];
                3. Vector coordinates are in the interval [{MIN_INT_NUM}; {MAX_INT_NUM}];
                                
            """;
        Console.WriteLine(outputString);
    }

    static void outputTextAboutIOSelection(string IOTextInfo)
    {
        string outputString = $"""
            Select how you will {IOTextInfo} data:
                  {IOChoose.FILE}: {FILE_VALUE}    {IOChoose.CONSOLE}: {CONSOLE_VALUE}
            Your option: 
            """;
        Console.Write(outputString);
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
                case FILE_VALUE: result = IOChoose.FILE; break;
                case CONSOLE_VALUE: result = IOChoose.CONSOLE; break;
                default: isCorrect = false; break;
            }

            if (!isCorrect) Console.Error.Write($"You should write one natural number({FILE_VALUE}|{CONSOLE_VALUE}): ");
            else Console.WriteLine();
        } while (!isCorrect);

        return result;
    }

    static bool pathCondition(string filePath)
    {
        if (filePath.Length < MIN_FILE_WAY_SIZE)
        {
            Console.Error.Write("The path is too short. Try again: ");
            return false;
        }

        string bufstr = filePath.Substring(filePath.Length - MIN_FILE_WAY_SIZE);
        if (!bufstr.Equals(".txt"))
        {
            Console.Error.Write("Write .txt file. Try again: ");
            return false;
        }

        return true;
    }

    static string inputFilePath()
    {
        string filePath = Console.ReadLine() ?? string.Empty;

        while (!pathCondition(filePath))
            filePath = Console.ReadLine() ?? string.Empty;

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
            using (StreamReader reader = new StreamReader(filePath))
                reader.Read();

            return true;
        }
        catch
        {
            return false;
        }
    }

    static bool accessModifierControl(string accessModifier, string filePath)
    {
        bool resultModifier = true;

        switch (accessModifier) {
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
                Console.Error.Write("Can't open a file. Try write another way: ");

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
            bool isServiceSymbol = character == ' ' || character == '\r' || character == '\n';
            
            if (!(isServiceSymbol || !(character > '9' && character < '0')))
                isCorrectInput = false;

            if (!isServiceSymbol && isCorrectInput)
                num = num * 10 + character - 48;

            if (bufChar != 0 && isCorrectInput && isServiceSymbol)
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

    static bool isProcesOfFileInputCorrect(ref int ACount, ref int[] BVector, ref int[] CVector, string filePath, ref int NSize)
    {
        bool isCorrectInput = true;

        using (StreamReader inputReader = new StreamReader(filePath))
        {
            ACount = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_INT_NUM, MAX_INT_NUM);
            NSize = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_N, MAX_N);
            BVector = new int[NSize];
            CVector = new int[NSize];

            inputVectorFromFile(inputReader, ref BVector, ref isCorrectInput);
            inputVectorFromFile(inputReader, ref CVector, ref isCorrectInput);

            isCorrectInput = isCorrectInput && inputReader.EndOfStream ? true : false;
            if (!isCorrectInput) Console.Error.WriteLine("Error in reading. Try again.");
        }

        return isCorrectInput;
    }

    static void InputFormFile(ref int ACount, ref int[] BVector, ref int[] CVector, ref int NSize)
    {
        string filePath = string.Empty;

        do
        {
            Console.Write("Write way to your file (*.txt): ");
            filePath = inputPathToTheFile("input");
        } while (!isProcesOfFileInputCorrect(ref ACount, ref BVector, ref CVector, filePath, ref NSize));
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

            if (!isCorrect) Console.Error.Write($"Number must be from {MIN_NUM} to {MAX_NUM}: ");
        } while (!isCorrect);

        return num;
    }
    static void InputVectorFromConsole(ref int[] Vector)
    {
        for (int i = 0; i < Vector.Length; ++i)
        {
            Console.Write($"Write your {i + 1} coordinate: ");
            Vector[i] = InputNumberFromConsole(MIN_INT_NUM, MAX_INT_NUM);
        }
    }

    static void InputFromConsole(ref int ACount, ref int[] BVector, ref int[] CVector, ref int NSize)
    {
        Console.Write("Write A: ");
        ACount = InputNumberFromConsole(MIN_INT_NUM, MAX_INT_NUM);

        Console.Write("Write N - size of vectors: ");
        NSize = InputNumberFromConsole(MIN_N, MAX_N);
        
        BVector = new int[NSize];
        Console.WriteLine("\nWrite vector B.");
        InputVectorFromConsole(ref BVector);
        
        CVector = new int[NSize];
        Console.WriteLine("\nWrite vector C.");
        InputVectorFromConsole(ref CVector);
        Console.WriteLine();
    }

    static void inputData(ref int ACount, ref int[] BVector, ref int[] CVector, ref int NSize)
    {
        IOChoose path = chooseIOWay("input");

        switch (path)
        {
            case IOChoose.FILE: InputFormFile(ref ACount, ref BVector, ref CVector, ref NSize); break;
            case IOChoose.CONSOLE: InputFromConsole(ref ACount, ref BVector, ref CVector, ref NSize); break;
        }
    }
    
    static int[][] AddToArray(int[][] array, int[] item, int NSize, int curentSum)
    {
        int[] newItem = new int[NSize + 1];
        for (int i = 0; i < item.Length; ++i)
            newItem[i + 1] = item[i] + 1;
        newItem[0] = curentSum;

        int[][] newArray = new int[array.Length + 1][];
        Array.Copy(array, newArray, array.Length);
        newArray[array.Length] = newItem;

        return newArray;
    }

    static void checkingCVectorCondition(int[] currentPath, int[] CVector, int ACount, ref int[][] results, int NSize)
    {
        int curentSum = 0;
        foreach (int i in currentPath)
            curentSum += CVector[i];

        if (curentSum <= ACount)
            results = AddToArray(results, currentPath, NSize, curentSum);
    }

    static int[][] calculateSums(int[] BVector, int[] CVector, int ACount, int NSize)
    {
        int[][] results = new int[0][];

        void searchSuitableAmo(int[] subArray, int[] currentPath)
        {
            if (subArray.Length == 0)
                checkingCVectorCondition(currentPath, CVector, ACount, ref results, NSize);
            else
            {
                int[] newPath1 = new int[currentPath.Length + 1];
                Array.Copy(currentPath, newPath1, currentPath.Length);
                newPath1[currentPath.Length] = Array.IndexOf(BVector, subArray[0]);
                searchSuitableAmo(subArray[1..], newPath1);

                int[] newPath2 = new int[currentPath.Length];
                Array.Copy(currentPath, newPath2, currentPath.Length);
                searchSuitableAmo(subArray[1..], newPath2);
            }
        }

        searchSuitableAmo(BVector, new int[0]);
        return results;
    }

    static void swap(int[][] array, int i, int j)
    {
        int temp0 = array[i][0];
        int temp1 = array[i][1];
        array[i][0] = array[j][0];
        array[i][1] = array[j][1];
        array[j][0] = temp0;
        array[j][1] = temp1;
    }

    static int partition(int[][] array, int left, int right)
    {
        int pivot = array[left][0];
        int i = left + 1;

        for (int j = left + 1; j <= right; j++)
        {
            if (array[j][0] > pivot)
            {
                swap(array, i, j);
                i++;
            }
        }

        swap(array, left, i - 1);
        return i - 1;
    }

    static void quickSort(int[][] array, int left, int right)
    {
        if (left < right)
        {
            int pivotIndex = partition(array, left, right);
            quickSort(array, left, pivotIndex - 1);
            quickSort(array, pivotIndex + 1, right);
        }
    }

    static void addResToSubset(int[][] sums, ref HashSet<int> ISubset)
    {
        for (int i = 1; sums.Length != 0 && i < sums[0].Length; i++)
            if (sums[0][i] != 0)
                ISubset.Add(sums[0][i]);
    }

    static void treatmentData(int ACount, int[] BVector, int[] CVector, int NSize, ref HashSet<int> ISubset)
    {
        int[][] sums = calculateSums(BVector, CVector, ACount, NSize);
        quickSort(sums, 0, sums.Length - 1);
        addResToSubset(sums, ref ISubset);
    }

    static string createStringWithVector(int[] Vector)
    {
        string vectorStr = string.Empty;
        for (int i = 0; i < Vector.Length; i++)
            vectorStr += Vector[i] + " ";

        return vectorStr;
    }

    static string createStringWithSet(HashSet<int> ISubset)
    {
        if (ISubset.Count == 0)
            return " empty set...";

        string setStr = string.Empty;
        foreach (int i in ISubset)
            setStr += " " + i;

        return setStr;
    }

    static string createResultString(int ACount, int[] BVector, int[] CVector, int NSize, HashSet<int> ISubset)
    {
        string resultStr = $"""
            A: {ACount};
            N: {NSize};
            Vector B: {createStringWithVector(BVector)}
            Vector C: {createStringWithVector(CVector)}
            Result set I:{createStringWithSet(ISubset)}
            """;
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
            Console.Error.WriteLine("Error in writing. Try again.");
            return false;
        }
    }

    static void OutputFormFile(string resultStr)
    {
        string filePath = string.Empty;

        do
        {
            Console.Write("Write way to your file (*.txt): ");
            filePath = inputPathToTheFile("output");
        } while (!isProcesOfFileOutputCorrect(filePath, resultStr));
    }

    static void OutputFromConsole(string resultStr)
    {
        Console.WriteLine($"{resultStr}");
    }

    static void outputData(int ACount, int[] BVector, int[] CVector, int NSize, HashSet<int> ISubset)
    {
        string resultStr = createResultString(ACount, BVector, CVector, NSize, ISubset);
        IOChoose path = chooseIOWay("output");

        switch (path)
        {
            case IOChoose.FILE: OutputFormFile(resultStr); break;
            case IOChoose.CONSOLE: OutputFromConsole(resultStr); break;
        }
    }

    public static void Main(string[] args)
    {
        int ACount = 0;
        int NSize = 0;
        int[] BVector = { };
        int[] CVector = { };
        HashSet<int> ISubset = new HashSet<int>();

        taskInfoOutput();
        inputData(ref ACount, ref BVector, ref CVector, ref NSize);
        treatmentData(ACount, BVector, CVector, NSize, ref ISubset);
        outputData(ACount, BVector, CVector, NSize, ISubset);
    }
}