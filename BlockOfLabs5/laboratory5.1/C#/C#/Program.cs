using System.Text;

namespace C_;

class Proj42 {
    class Node {
        public int Data { get; set; }
        public Node? Previous { get; set; }
        public Node? Next { get; set; }
    }
    enum MainMenu {
        Display, 
        Add,
        Remove,
        Filesave,
        Loadfile,
        Reference,
        Exit
    }
    const int MinFileWaySize = 4;
    const int MinNumOfValues = 0;
    const int MaxNum = 1_000_000_000;
    const int MinNum = -1_000_000_000;
    const int SPACE_LIMIT = 5;
    static Node? _head;
    static Node? _tail;
    static readonly string[] _mainOptions = { " < Просмотреть список > ", " < Добавить значение > ", " < Удалить значение > ", " < Сохранить список в файл > ", " < Загрузить значение из файла > ", " < Справка > ", " < Выход > " };
    static readonly string[] _exitOption = { "<- Вернуться" };
    static void showReference() {
        Console.Clear();
        string prompt = $"""
                Инструкция:
                  1. Чтобы просмотреть список в обратном порядке выберите 
                     {_mainOptions[0]};
                  2. Добавить новое значение можно выбрав {_mainOptions[1]};
                  3. Выберите {_mainOptions[2]}, чтобы удалить какое-то значение;
                  4. Просмотрите инструкцию выбрав {_mainOptions[3]};
                  5. Чтобы выйти выбирайте вариант {_mainOptions[4]}.

                Значения в массиве находятся в диапазоне от {MinNum} до {MaxNum};

                Работа с файлами:
                    Файл строго формата .txt!
                    При вводе числа через файл в файле находится только новое значение.
                    При сохранении в файл помещается та же таблица, что и в пункте
                    {_mainOptions[0]}

                При прсомотре списка он выводится в виде таблицы и в обратном порядке
                в соответствии с условием задания.
                """;
        getSelectedIndex(prompt, _exitOption);
    }
    static void addValueInList(int data) {
        Node newNode = new Node();
        newNode.Data = data;
        if (_head == null) {
            _head = newNode;
            _tail = newNode;
        } else {
            newNode.Previous = _tail;
#pragma warning disable CS8602 // Разыменование вероятной пустой ссылки.
            _tail.Next = newNode;
            _tail = newNode;
        }
    }
    static void removeValueFromList(int numOfValue) {
        if (_head == null) return;
        Node? currentNode = _head;
        for (int i = 1; i < numOfValue; ++i)
            currentNode = currentNode.Next ?? currentNode;
        if (currentNode.Previous != null)
            currentNode.Previous.Next = currentNode.Next;
        else _head = currentNode.Next;
        if (currentNode.Next != null)
            currentNode.Next.Previous = currentNode.Previous;    
        else _tail = currentNode.Previous;
    }

    static string reversePrint() {
        string prompt;
        prompt = "Список отображён в обратном порядке: ";
        Node? currentNode = _tail;
        if (currentNode == null) return prompt += "список пуст.";
        int valCounter = 0;
        string[] values = new string[1];
        string[] bufferVal = new string[1];
        prompt += '\n';
        prompt += " __________________________________ \n";
        prompt += "| Номер      | Значение            |\n";
        prompt += "|------------|---------------------|\n";
        while (currentNode != null) {
            values[valCounter] = currentNode.Data.ToString();
            bufferVal = new string[values.Length];
            for (int i = 0; i < values.Length; ++i)
                bufferVal[i] = values[i];
            values = new string[values.Length + 1];
            for (int i = 0; i < bufferVal.Length; ++i)
                values[i] = bufferVal[i];
            valCounter++;
            currentNode = currentNode.Previous;
        }
        for (int i = valCounter; i > 0; --i)
            prompt += "| " + i.ToString().PadLeft(10) + " | " + values[valCounter - i].PadLeft(19) + " |\n";
        prompt += "|____________|_____________________|";
        return prompt;
    }
    static void displayOptions(string prompt, string[] options, int selectedIndex = 0) {
        Console.WriteLine(prompt);
        for (int i = 0; i < options.Length; ++i) {
            string curentOption = options[i];
            string prefix;
            if (i == selectedIndex) {
                prefix = "*";
                Console.ForegroundColor = ConsoleColor.Black;
                Console.BackgroundColor = ConsoleColor.White;
            }
            else {
                prefix = " ";
                Console.ForegroundColor = ConsoleColor.White;
                Console.BackgroundColor = ConsoleColor.Black;
            }
            Console.WriteLine($"{prefix} {curentOption}");
        }
        Console.ResetColor();
    }
    static int getSelectedIndex(string prompt, string[] options, int selectedIndex = 0) {
        ConsoleKey keyPressed;
        do {
            Console.Clear();
            displayOptions(prompt, options, selectedIndex);
            ConsoleKeyInfo keyInfo = Console.ReadKey(true);
            keyPressed = keyInfo.Key;
            if (keyPressed == ConsoleKey.UpArrow)
                if (--selectedIndex == -1) selectedIndex = options.Length - 1;
            if (keyPressed == ConsoleKey.DownArrow)
                if (++selectedIndex == options.Length) selectedIndex = 0;
        } while (keyPressed != ConsoleKey.Enter);
        return selectedIndex;
    }
    static MainMenu searchQurentMainMethod(int curentIndex) {
        switch (curentIndex) {
            case (int)MainMenu.Display: return MainMenu.Display;
            case (int)MainMenu.Add: return MainMenu.Add;
            case (int)MainMenu.Remove: return MainMenu.Remove;
            case (int)MainMenu.Filesave: return MainMenu.Filesave;
            case (int)MainMenu.Loadfile: return MainMenu.Loadfile;
            case (int)MainMenu.Reference: return MainMenu.Reference;
            default: return MainMenu.Exit;
        }
    }
    static int inputNumber(int max, int min) {
        int num = 0;
        bool isIncorrect = true;
        do {
            try {
                num = Convert.ToInt32(Console.ReadLine());
                isIncorrect = false;
            }
            catch {
                Console.Error.Write("Ошибка!!! Введите целое число: ");
                isIncorrect = true;
            }
            if ((num > max || num < min) && !isIncorrect) {
                Console.Error.Write($"Ошибка!!! Диапазон числа от {min} до {max}: ");
                isIncorrect = true;
            }
        } while (isIncorrect);
        return num;
    }
    static void addValueProc() {
        Console.Clear();
        Console.Write("Введите новое значение: ");
        int num = inputNumber(MaxNum, MinNum);
        addValueInList(num);
        string prompt = "Новое значение добавлено в список: " + num;
        getSelectedIndex(prompt, _exitOption);
    }
    static void printProc() {
        Console.Clear();
        string prompt = reversePrint();
        getSelectedIndex(prompt, _exitOption);
    }
    static int findNumbOfValues() {
        int numOfEl = 0;
        Node? currentNode = _tail;
        while (currentNode != null) {
            numOfEl++;
            currentNode = currentNode.Previous;
        }
        return numOfEl;
    }
    static void removeProc() {
        Console.Clear();
        string prompt;
        int valCounter = findNumbOfValues();
        if (valCounter == 0) {
            prompt = "У вас нет ниодного значения...";
            getSelectedIndex(prompt, _exitOption);
            return;
        }
        string allElements = reversePrint();
        Console.WriteLine(allElements);
        Console.Write($"{MinNumOfValues} - покинуть удаление;\n");
        Console.Write("Введите номер удаляемого элемента: ");
        int num = inputNumber(valCounter, MinNumOfValues);
        if (num == MinNumOfValues) return;
        removeValueFromList(num);
        prompt = reversePrint();
        getSelectedIndex(prompt, _exitOption);
    }
    static bool pathCondition(string filePath) {
        if (filePath.Length < MinFileWaySize) {
            Console.Error.Write("Путь слишком котороткий. Попробуйте снова: ");
            return false;
        }
        string bufstr = filePath.Substring(filePath.Length - MinFileWaySize);
        if (bufstr.Equals(".txt")) return true;
        Console.Error.Write("Введите .txt файл. Попробуйте снова: ");
        return false;
    }
    static string inputFilePath() {
        string filePath = Console.ReadLine() ?? string.Empty;
        while (!pathCondition(filePath))
            filePath = Console.ReadLine() ?? string.Empty;
        return filePath;
    }
    static bool isCanWrite(string filePath) {
        try {
            using (StreamWriter writer = new StreamWriter(filePath))
                writer.WriteLine(string.Empty);
            return true;
        }
        catch {
            return false;
        }
    }

    static bool isCanRead(string filePath)
    {
        try {
            using (StreamReader reader = new StreamReader(filePath))
                reader.Read();
            return true;
        } catch {
            return false;
        }
    }
    static bool accessModifierControl(string accessModifier, string filePath)
    {
        bool resultModifier = accessModifier switch
        {
            "input" => isCanRead(filePath),
            "output" => isCanWrite(filePath),
            _ => true
        };
        return resultModifier;
    }
    static bool isCanOpenFile(string filePath)
    {
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
        bool isCorrect = true;
        do {
            filePath = inputFilePath();
            isCorrect = accessModifierControl(accessModifier, filePath) && isCanOpenFile(filePath);
            if (!isCorrect) Console.Error.Write("Невозможно открыть файл. Попробуйте другой путь: ");
        } while (!isCorrect);
        return filePath;
    }
    static bool isProcesOfFileOutputCorrect(string filePath, string resultStr) {
        string prompt = string.Empty;
        try {
            using (StreamWriter writerOutput = new StreamWriter(filePath))
                writerOutput.WriteLine(resultStr);
            return true;
        } catch {
            Console.WriteLine("Ошибка при записи. Попробуйте снова.");
            return false;
        }
    }
    static void saveInFileProc() {
        Console.Clear();
        string prompt;
        int valCounter = findNumbOfValues();
        if (valCounter == 0) {
            prompt = "У вас нет ниодного значения...";
            getSelectedIndex(prompt, _exitOption);
            return;
        }
        string filePath;
        do {
            Console.Write("Введите путь к файлу (*.txt): ");
            filePath = inputPathToTheFile("output");
        } while (!isProcesOfFileOutputCorrect(filePath, reversePrint()));
        prompt = "Список успешно сохранён в файл.";
        getSelectedIndex(prompt, _exitOption); 
    }
    static int inputNumberFromFile(StreamReader inputReader, ref bool isCorrectInput, int minNum, int maxNum) {
        int num = 0;
        bool endOfNum = false;
        int spaceCounter = 0;
        int character;
        int minCount = 1;
        while (isCorrectInput && !(endOfNum) && (character = inputReader.Read()) != -1) {
            var bufChar = character;
            isCorrectInput = isCorrectInput && !((character != ' ') && !((character > '/') && (character < ':')) &&
                                                 (character != '\n') && (character != '\r') && (character != '-'));
            if (character == ' ') ++spaceCounter;
            else spaceCounter = 0;
            isCorrectInput = !(spaceCounter == SPACE_LIMIT);
            if ((character > '/') && (character < ':'))
                num = num * 10 + character - 48;
            if (character == '-') minCount = -1;
            isCorrectInput = isCorrectInput && !((character == '-') && (minCount != -1));
            endOfNum = ((character == ' ') || (character == '\n')) && ((bufChar > '/') && (bufChar < ':'));
            isCorrectInput = isCorrectInput && !((num == 0) && (character > '/') && (character <':'));
            isCorrectInput = isCorrectInput && !(num > maxNum);
        }

        isCorrectInput = isCorrectInput && !endOfNum;

        if (isCorrectInput) num = minCount * num;

        return num;
    }
    static bool isProcesOfFileInputCorrect(ref int num, ref string filePath) {
        bool isCorrectInput = true;
        string prompt = string.Empty;
        using StreamReader inputReader = new StreamReader(filePath);
            num = inputNumberFromFile(inputReader, ref isCorrectInput, MinNum, MaxNum);
        isCorrectInput = isCorrectInput && inputReader.EndOfStream ? true : false;
        addValueInList(num);
        if (!isCorrectInput) Console.WriteLine("Ошибка при чтении. Попробуйте снова.");
        return isCorrectInput;
    } 
    static void loadFromFileProc() {
        Console.Clear();
        string filePath;
        int num = 0;
        do {
            Console.Write("Введите путь к вашему файлу (*.txt): ");
            filePath = inputPathToTheFile("input");
        } while (!isProcesOfFileInputCorrect(ref num, ref filePath));
        string prompt = "Число успешно считано из файла.";
        getSelectedIndex(prompt, _exitOption);
    }
    static void workWithMethod(MainMenu curentMethod) {
        switch (curentMethod) {
            case MainMenu.Display: printProc(); break;
            case MainMenu.Add: addValueProc(); break;
            case MainMenu.Remove: removeProc(); break;
            case MainMenu.Filesave: saveInFileProc(); break;
            case MainMenu.Loadfile: loadFromFileProc(); break;
            case MainMenu.Reference: showReference(); break;
        }
    }

    static void mainWorkBlock() {
        MainMenu currentMethod = 0;
        do {
            string prompt = "Выберите, что хотите сделать: ";
            currentMethod = searchQurentMainMethod(getSelectedIndex(prompt, _mainOptions));
            workWithMethod(currentMethod);
        } while (currentMethod != MainMenu.Exit);
    }
    public static void Main(String[] args) {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
        Console.OutputEncoding = Encoding.GetEncoding(1251);
        Console.InputEncoding = Encoding.GetEncoding(1251);
        Console.Title = "Двусвязный список™";
        mainWorkBlock();
    } 
}