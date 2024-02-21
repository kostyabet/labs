using System.Text;
class Proj4_2 {
    class Node {
        public int Data { get; set; }
        public Node? Previous { get; set; }
        public Node? Next { get; set; }
    }
    enum MainMenu {
        DISPLAY,
        ADD,
        REMOVE,
        FILESAVE,
        LOADFILE,
        REFERENCE,
        EXIT
    }
    const int MIN_FILE_WAY_SIZE = 4;
    const int MIN_NUM_OF_VALUES = 0;
    const int MAX_NUM = 1_000_000_000;
    const int MIN_NUM = -1_000_000_000;
    static Node? head;
    static Node? tail;
    static string[] mainOptions = { " < Просмотреть список > ", " < Добавить значение > ", " < Удалить значение > ", " < Сохранить список в файл > ", " < Загрузить значение из файла > ", " < Справка > ", " < Выход > " };
    static string[] exitOption = { "<- Вернуться" };
    static void showReference() {
        Console.Clear();
        string prompt = $"""
                Инструкция:
                  1. Чтобы просмотреть список в обратном порядке выберите 
                     {mainOptions[0]};
                  2. Добавить новое значение можно выбрав {mainOptions[1]};
                  3. Выберите {mainOptions[2]}, чтобы удалить какое-то значение;
                  4. Просмотрите инструкцию выбрав {mainOptions[3]};
                  5. Чтобы выйти выбирайте вариант {mainOptions[4]}.

                Значения в массиве находятся в диапазоне от {MIN_NUM} до {MAX_NUM};

                Работа с файлами:
                    Файл строго формата .txt!
                    При вводе числа через файл в файле находится только новое значение.
                    При сохранении в файл помещается та же таблица, что и в пункте
                    {mainOptions[0]}

                При прсомотре списка он выводится в виде таблицы и в обратном порядке
                в соответствии с условием задания.
                """;
        getSelectedIndex(prompt, exitOption);
    }
    static void addValueInList(int data) {
        Node newNode = new Node();
        newNode.Data = data;
        if (head == null) {
            head = newNode;
            tail = newNode;
        } else {
            newNode.Previous = tail;
            #pragma warning disable CS8602 // Разыменование вероятной пустой ссылки.
            tail.Next = newNode;
            tail = newNode;
        }
    }
    static void removeValueFromList(int numOfValue) {
        if (head == null) return;
        Node? currentNode = head;
        for (int i = 1; i < numOfValue; ++i)
            currentNode = currentNode.Next ?? currentNode;
        if (currentNode.Previous != null)
            currentNode.Previous.Next = currentNode.Next;
        else head = currentNode.Next;
        if (currentNode.Next != null)
            currentNode.Next.Previous = currentNode.Previous;    
        else tail = currentNode.Previous;
    }

    static string ReversePrint() {
        string prompt = string.Empty;
        prompt = "Список отображён в обратном порядке: ";
        Node? currentNode = tail;
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
            case (int)MainMenu.DISPLAY: return MainMenu.DISPLAY;
            case (int)MainMenu.ADD: return MainMenu.ADD;
            case (int)MainMenu.REMOVE: return MainMenu.REMOVE;
            case (int)MainMenu.FILESAVE: return MainMenu.FILESAVE;
            case (int)MainMenu.LOADFILE: return MainMenu.LOADFILE;
            case (int)MainMenu.REFERENCE: return MainMenu.REFERENCE;
            default: return MainMenu.EXIT;
        }
    }
    static int inputNumber(int MAX, int MIN) {
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
            if ((num > MAX || num < MIN) && !isIncorrect) {
                Console.Error.Write($"Ошибка!!! Диапазон числа от {MIN} до {MAX}: ");
                isIncorrect = true;
            }
        } while (isIncorrect);
        return num;
    }
    static void addValueProc() {
        Console.Clear();
        Console.Write("Введите новое значение: ");
        int num = inputNumber(MAX_NUM, MIN_NUM);
        addValueInList(num);
        string prompt = "Новое значение добавлено в список: " + num;
        getSelectedIndex(prompt, exitOption);
    }
    static void printProc() {
        Console.Clear();
        string prompt = ReversePrint();
        getSelectedIndex(prompt, exitOption);
    }
    static int findNumbOfValues() {
        int numOfEl = 0;
        Node? currentNode = tail;
        while (currentNode != null) {
            numOfEl++;
            currentNode = currentNode.Previous;
        }
        return numOfEl;
    }
    static void removeProc() {
        Console.Clear();
        string prompt = string.Empty;
        int valCounter = findNumbOfValues();
        if (valCounter == 0) {
            prompt = "У вас нет ниодного значения...";
            getSelectedIndex(prompt, exitOption);
            return;
        }
        string allElements = ReversePrint();
        Console.WriteLine(allElements);
        Console.Write($"{MIN_NUM_OF_VALUES} - покинуть удаление;\n");
        Console.Write("Введите номер удаляемого элемента: ");
        int num = inputNumber(valCounter, MIN_NUM_OF_VALUES);
        if (num == MIN_NUM_OF_VALUES) return;
        removeValueFromList(num);
        prompt = ReversePrint();
        getSelectedIndex(prompt, exitOption);
    }
    static bool pathCondition(string filePath) {
        if (filePath.Length < MIN_FILE_WAY_SIZE) {
            Console.Error.Write("Путь слишком котороткий. Попробуйте снова: ");
            return false;
        }
        string bufstr = filePath.Substring(filePath.Length - MIN_FILE_WAY_SIZE);
        if (!bufstr.Equals(".txt")) {
            Console.Error.Write("Введите .txt файл. Попробуйте снова: ");
            return false;
        }
        return true;
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
    static bool accessModifierControl(string accessModifier, string filePath) {
        bool resultModifier = true;
        switch (accessModifier) {
            case "input": resultModifier = isCanRead(filePath); break;
            case "output": resultModifier = isCanWrite(filePath); break;
        }
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
        string filePath = string.Empty;
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
        string prompt = string.Empty;
        int valCounter = findNumbOfValues();
        if (valCounter == 0) {
            prompt = "У вас нет ниодного значения...";
            getSelectedIndex(prompt, exitOption);
            return;
        }
        string filePath = string.Empty;
        do {
            Console.Write("Введите путь к файлу (*.txt): ");
            filePath = inputPathToTheFile("output");
        } while (!isProcesOfFileOutputCorrect(filePath, ReversePrint()));
        prompt = "Список успешно сохранён в файл.";
        getSelectedIndex(prompt, exitOption);
    }
    static int inputNumberFromFile(StreamReader inputReader, ref bool isCorrectInput, int MIN_NUM, int MAX_NUM) {
        int num = 0;
        bool isCorrect = true;
        int character, bufChar = 0;
        while (isCorrect && isCorrectInput && (character = inputReader.Read()) != -1) {
            bool isServiceSymbol = character == ' ' || character == '\r' || character == '\n';
            isCorrectInput = (isServiceSymbol || !(character > '9' && character < '0'));
            if (!isServiceSymbol && isCorrectInput) 
                num = num * 10 + character - 48;
            isCorrect = !(bufChar != 0 && isCorrectInput && isServiceSymbol);
            isCorrect = isCorrect && !(num > MAX_NUM);
            bufChar = character;
        }
        isCorrectInput = !(isCorrectInput && (num > MAX_NUM || num < MIN_NUM || bufChar == 0));
        return num;
    }
    static bool isProcesOfFileInputCorrect(ref int num, ref string filePath) {
        bool isCorrectInput = true;
        string prompt = string.Empty;
        using (StreamReader inputReader = new StreamReader(filePath)) {
            num = inputNumberFromFile(inputReader, ref isCorrectInput, MIN_NUM, MAX_NUM);
            isCorrectInput = isCorrectInput && inputReader.EndOfStream ? true : false;
            addValueInList(num);
            if (!isCorrectInput) Console.WriteLine("Ошибка при чтении. Попробуйте снова.");
        }
        return isCorrectInput;
    }
    static void loadFromFileProc() {
        Console.Clear();
        string filePath = string.Empty;
        int num = 0;
        do {
            Console.Write("Введите путь к вашему файлу (*.txt): ");
            filePath = inputPathToTheFile("input");
        } while (!isProcesOfFileInputCorrect(ref num, ref filePath));
        string prompt = "Число успешно считано из файла.";
        getSelectedIndex(prompt, exitOption);
    }
    static void workWithMethod(MainMenu curentMethod) {
        switch (curentMethod) {
            case MainMenu.DISPLAY: printProc(); break;
            case MainMenu.ADD: addValueProc(); break;
            case MainMenu.REMOVE: removeProc(); break;
            case MainMenu.FILESAVE: saveInFileProc(); break;
            case MainMenu.LOADFILE: loadFromFileProc(); break;
            case MainMenu.REFERENCE: showReference(); break;
        }
    }

    static void mainWorkBlock() {
        MainMenu curentMethod = 0;
        do {
            string prompt = "Выберите, что хотите сделать: ";
            curentMethod = searchQurentMainMethod(getSelectedIndex(prompt, mainOptions));
            workWithMethod(curentMethod);
        } while (curentMethod != MainMenu.EXIT);
    }
    static void Main(String[] args) {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
        Console.OutputEncoding = Encoding.GetEncoding(1251);
        Console.InputEncoding = Encoding.GetEncoding(1251);
        Console.Title = "Двусвязный список™";
        mainWorkBlock();
        Environment.Exit(0);
    }
}