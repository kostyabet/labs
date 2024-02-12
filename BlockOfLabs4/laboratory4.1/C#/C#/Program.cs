using System;
using System.Text;
using System.Xml;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Proj4_2 {
    enum PanelFunctions {
        ADD,
        CHANGE,
        SEARCH,
        DELETE,
        REFERENCE,
        EXIT
    }
    enum recordPoints {
        COUNTRY,
        TEAM,
        COACH,
        POINTS,
        REFERENCE,
        EXIT
    }
    class MainClass() {
        record struct TFootballRecord(string Country, string Team, string Coach, int Points);
        static TFootballRecord[] recordArray = new TFootballRecord[0];
        const int MAX_STR_LENGTH = 20;
        const int MAX_N = 100;
        const int MIN_N = 0;
        const int MAX_RECORDS = 32;
        static string MainFilePath = "MainFile.txt";
        static string CorrectionFilePath = "CorrectionFile.txt";
        static string TempFilePath = "TempFile.txt";
        static string[] mainOptions = { " < Добавить запись > ", " < Изменить запись > ", " < Найти запись > ", " < Удалить запись > ", " < Справка >", " < Выход > " };
        static string[] changeRecordOptions = { "Страна", "Команда", "Тренер", "Рейтинг", "Справка", "<- Вернуться" };
        static string[] exitOption = { "<- Вернуться" };
        static void showReference() {
            Console.Clear();
            string prompt = $"""
                Инструкция:
                  1. Чтобы добавить новую запись выберите кнопку {mainOptions[0]};
                  2. Если вы хотите изменить какую-то запись выберите {mainOptions[1]};
                  3. Если у вас много записей и вы потерялись, выберите {mainOptions[2]};
                  4. Если запись необходимо убрать из таблицы, выберите {mainOptions[3]};
                  5. Чтобы выйти выбирайте вариант {mainOptions[5]}.

                Ограничения по вводу:
                  1. Поля: {changeRecordOptions[0]}, {changeRecordOptions[1]}, {changeRecordOptions[2]} это 
                     строки максимальной длиной в {MAX_STR_LENGTH} символов;
                  2. Поле {changeRecordOptions[3]} имеет ограничение [{MIN_N}; {MAX_N}].

                Работа с файлами:
                    В форме автоматически реализованы типизированный файл и файл
                    корректур. Если вы сделали запись и закрыли форму, то всё
                    сохранится автоматически и при запуске будет выгружено.
                
                Максимальное колличество команд, которые можно записать в таблицу: {MAX_RECORDS}.

                В турнирной таблице записи упорядочены по убыванию рейтинга команд.

                В случае когда набрано одинаковое кол-во очков, первой будет идти
                команда, которая была записана в таблицу раньше.
                """;
            getSelectedIndex(prompt, exitOption);
        }
        static void importRecordsForSort() {
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    Array.Resize(ref recordArray, recordArray.Length + 1);
                    recordArray[recordArray.Length - 1].Country = temp.Country;
                    recordArray[recordArray.Length - 1].Team = temp.Team;
                    recordArray[recordArray.Length - 1].Coach = temp.Coach;
                    recordArray[recordArray.Length - 1].Points = temp.Points;
                }
            }
        }
        static void importSortRecInFile() {
            using (BinaryWriter writer = new BinaryWriter(File.Open(CorrectionFilePath, FileMode.OpenOrCreate)))
                for (int i = 0; i < recordArray.Length; ++i) {
                    writer.Write(recordArray[i].Country);
                    writer.Write(recordArray[i].Team);
                    writer.Write(recordArray[i].Coach);
                    writer.Write(recordArray[i].Points);
                }
        }
        static void sortRecords() { 
            int j, points;
            TFootballRecord[] temp = new TFootballRecord[1];
            recordArray = new TFootballRecord[0];
            importRecordsForSort();
            for (int I = 1; I < recordArray.Length; I++) {
                temp[0] = recordArray[I];
                points = recordArray[I].Points;
                j = I - 1;
                while (j >= 0 && recordArray[j].Points < points) {
                    recordArray[j + 1] = recordArray[j];
                    recordArray[j] = temp[0];
                    j--;
                }
            }
            importSortRecInFile();
            recordArray = new TFootballRecord[0];
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
        static PanelFunctions searchQurentMainMethod(int curentIndex) {
            switch (curentIndex) {
                case (int)PanelFunctions.ADD: return PanelFunctions.ADD;
                case (int)PanelFunctions.CHANGE: return PanelFunctions.CHANGE;
                case (int)PanelFunctions.SEARCH: return PanelFunctions.SEARCH;
                case (int)PanelFunctions.DELETE: return PanelFunctions.DELETE;
                case (int)PanelFunctions.REFERENCE: return PanelFunctions.REFERENCE;
                default: return PanelFunctions.EXIT;
            }
        }
        static string outputTable() {
            int columnWidth = 20;
            string formatString = "  {0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string prompt = string.Format(formatString, "Место", "Страна", "Команда", "Тренер", "Рейтинг");
            prompt += '\n' + new string('-', (columnWidth + 1) * 5);
            int i = 1;
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    prompt += '\n' + string.Format(formatString, i++, temp.Country, temp.Team, temp.Coach, temp.Points);
                }
            }
            return prompt;
        }
        static string inputString(string prompt, in int maxLength) {
            Console.Write(prompt);
            bool isCorrect = false;
            string curentStr = string.Empty;
            do {
                curentStr = Console.ReadLine() ?? string.Empty;
                isCorrect = !((curentStr.Length > maxLength) || (curentStr == string.Empty));
                if (!isCorrect) Console.Error.Write($"Ошибка! Попробуйте снова (максимальная длина {maxLength} символов): ");
            } while (!isCorrect);
            return curentStr;
        }
        static int inputNum(string prompt, in int max, in int min) {
            Console.Write(prompt);
            bool isCorrect = true;
            int num = 0;
            do {
                try {
                    num = Convert.ToInt32(Console.ReadLine());
                    isCorrect = true;
                } 
                catch { 
                    isCorrect = false; 
                }
                isCorrect = isCorrect && !(num > max) && !(num < min);
                if (!isCorrect) Console.Error.Write($"Ошибка! Попробуйте снова [{min}; {max}]: ");
            } while (!isCorrect);
            return num;
        }
        static void addRecordInFile(TFootballRecord newRecord) {
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate)))
                using (BinaryWriter writer = new BinaryWriter(File.Open(TempFilePath, FileMode.CreateNew)))  {
                    TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                    while (reader.BaseStream.Position < reader.BaseStream.Length) {
                        temp.Country = reader.ReadString();
                        temp.Team = reader.ReadString();
                        temp.Coach = reader.ReadString();
                        temp.Points = reader.ReadInt32();
                        writer.Write(temp.Country);
                        writer.Write(temp.Team);
                        writer.Write(temp.Coach);
                        writer.Write(temp.Points);
                    }
                    writer.Write(newRecord.Country);
                    writer.Write(newRecord.Team);
                    writer.Write(newRecord.Coach);
                    writer.Write(newRecord.Points);
                }
            File.Delete(CorrectionFilePath);
            File.Move(TempFilePath, CorrectionFilePath);
        }
        static void addNewRecord() {
            string prompt = string.Empty;
            Console.Clear();
            if (recordArray.Length == MAX_RECORDS) prompt = "Вы достигли максимального колличесвта команд.";
            else {
                TFootballRecord newRecord = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                Console.WriteLine("Давайте создадим новую запись.");
                string country = inputString("Страна: ", MAX_STR_LENGTH);
                newRecord.Country = country;
                string team = inputString("Название команда: ", MAX_STR_LENGTH);
                newRecord.Team = team;
                string coach = inputString("Фамилия гл. тренера: ", MAX_STR_LENGTH);
                newRecord.Coach = coach;
                int points = inputNum("Рейтинг команды (кол-во очков): ", MAX_N, MIN_N);
                newRecord.Points = points;
                addRecordInFile(newRecord);
                sortRecords();
                prompt = $"""
                    Страна: {country};
                    Команда: {team};
                    Тренер: {coach};
                    Рейтинг: {points};
                    """;
            }
            getSelectedIndex(prompt, exitOption);
        }
        static string[] createRecordsOptions(int columnWidth, string formatString) {
            string[] result = new string[0];
            int i = 1;
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    Array.Resize(ref result, result.Length + 1);
                    result[i - 1] += string.Format(formatString, i++, temp.Country, temp.Team, temp.Coach, temp.Points);
                }
            }
            Array.Resize(ref result, result.Length + 1);
            result[i - 1] = exitOption[0];
            return result;
        }
        static int getSelectedRow() {
            int columnWidth = 20;
            string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string[] recordsOption = createRecordsOptions(columnWidth, formatString);
            formatString = "  {0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string prompt = string.Format(formatString, "Место", "Страна", "Команда", "Тренер", "Рейтинг");
            prompt += "\n" + new string('-', (columnWidth + 1) * 5);
            return getSelectedIndex(prompt, recordsOption);
        }
        static recordPoints qurentPoint(int selectedIndex) {
            switch (selectedIndex) {
                case (int)recordPoints.COUNTRY: return recordPoints.COUNTRY;
                case (int)recordPoints.TEAM: return recordPoints.TEAM;
                case (int)recordPoints.COACH: return recordPoints.COACH;
                case (int)recordPoints.POINTS: return recordPoints.POINTS;
                case (int)recordPoints.REFERENCE: return recordPoints.REFERENCE;
                default: return recordPoints.EXIT;
            }
        }
        static void workWithPoint(recordPoints selectedRecordPoint,ref TFootballRecord curentRow) {
            switch (selectedRecordPoint) {
                case recordPoints.COUNTRY:
                    string countrty = inputString("Страна: ", MAX_STR_LENGTH);
                    curentRow.Country = countrty;
                    break;
                case recordPoints.TEAM:
                    string team = inputString("Название команды: ", MAX_STR_LENGTH);
                    curentRow.Team = team;
                    break;
                case recordPoints.COACH:
                    string coach = inputString("Фамилия гл. тренера: ", MAX_STR_LENGTH);
                    curentRow.Coach = coach;
                    break;
                case recordPoints.POINTS:
                    int points = inputNum("Рейтинг команды (кол-во очков): ", MAX_N, MIN_N);
                    curentRow.Points = points;
                    break;
                case recordPoints.REFERENCE: 
                    showReference(); 
                    break;
            }
        }
        static void searchCurentRowInFile(int selectedRow, ref TFootballRecord curentRow, ref int recordCounter) {
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    if (recordCounter == selectedRow) {
                        curentRow.Country = temp.Country;
                        curentRow.Team = temp.Team;
                        curentRow.Coach = temp.Coach;
                        curentRow.Points = temp.Points;
                    }
                    recordCounter++;
                }
            }
        }
        static void inputChangeRowInFile(int selectedRow, TFootballRecord curentRow) {
            int recordCounter = 0;
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate)))
            using (BinaryWriter writer = new BinaryWriter(File.Open(TempFilePath, FileMode.CreateNew))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    if (recordCounter == selectedRow) {
                        writer.Write(curentRow.Country);
                        writer.Write(curentRow.Team);
                        writer.Write(curentRow.Coach);
                        writer.Write(curentRow.Points);
                    }
                    else {
                        writer.Write(temp.Country);
                        writer.Write(temp.Team);
                        writer.Write(temp.Coach);
                        writer.Write(temp.Points);
                    }
                    recordCounter++;
                }
            }
            File.Delete(CorrectionFilePath);
            File.Move(TempFilePath, CorrectionFilePath);
        }
        static void workWithSelectedRow(int selectedRow) {
            int recordsCounter = 0;
            TFootballRecord curentRow = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
            searchCurentRowInFile(selectedRow, ref curentRow, ref recordsCounter);
            if (selectedRow == recordsCounter) return;
            recordPoints selectedRecordPoint = recordPoints.EXIT;
            do {
                int columnWidth = 20;
                string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
                string prompt = string.Format(formatString, "Место", "Страна", "Команда", "Тренер", "Рейтинг");
                prompt += "\n" + new string('-', columnWidth * 5);
                prompt += '\n' + string.Format(formatString, 1, curentRow.Country, curentRow.Team, curentRow.Coach, curentRow.Points);
                prompt += "\nЧто вы хотите изменить:";
                selectedRecordPoint = qurentPoint(getSelectedIndex(prompt, changeRecordOptions));
                workWithPoint(selectedRecordPoint,ref curentRow);    
            } while (selectedRecordPoint != recordPoints.EXIT);
            inputChangeRowInFile(selectedRow, curentRow);
            sortRecords();
        }
        static void changeRecord() {
            int selectedRow = 0;
            do {
                Console.Clear();
                selectedRow = getSelectedRow();
                workWithSelectedRow(selectedRow);
            } while (selectedRow != recordArray.Length);
        }
        static int returnRow(recordPoints selectedRecordPoint) {
            importRecordsForSort();
            switch (selectedRecordPoint) {
                case recordPoints.POINTS:
                    int points = inputNum("Введите рейтинг команды (кол-во очков): ", MAX_N, MIN_N);
                    for (int i = 0; i < recordArray.Length; ++i)
                        if (recordArray[i].Points == points)
                        { return i; }
                    break;
                case recordPoints.COUNTRY:
                    string country = inputString("Введите страну: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                        if (recordArray[i].Country == country)
                        { return i; }
                    break;
                case recordPoints.TEAM:
                    string team = inputString("Введите название команды: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                        if (recordArray[i].Team == team)
                        { return i; }
                    break;
                case recordPoints.COACH:
                    string coach = inputString("Введите фамилию гл. тренера: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                        if (recordArray[i].Coach == coach)
                        { return i; }
                    break;
            }
            return -1;
        }
        static void workWithSearchPoint(recordPoints selectedRecordPoint) {
            string prompt = string.Empty;
            recordArray = new TFootballRecord[0];
            importRecordsForSort();
            int recordIndex = returnRow(selectedRecordPoint);
            switch (selectedRecordPoint) { 
                case recordPoints.EXIT: break;
                case recordPoints.REFERENCE: showReference(); break;
                default:
                    if (recordIndex == -1) prompt = "Не нашлось записис по заданному параметру...";
                    else {
                        int columnWidth = 20;
                        string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
                        prompt = string.Format(formatString, "Место", "Страна", "Команда", "Тренер", "Рейтинг");
                        prompt += "\n" + new string('-', columnWidth * 5);
                        prompt += '\n' + string.Format(formatString, 1, recordArray[recordIndex].Country, recordArray[recordIndex].Team, recordArray[recordIndex].Coach, recordArray[recordIndex].Points);
                    }
                    getSelectedIndex(prompt, exitOption);
                    break;
            }
            recordArray = new TFootballRecord[0];
        }
        static void searchRecord() {
            Console.Clear();
            recordPoints selectedRecordPoint = recordPoints.EXIT;
            do {
                string prompt = "Какой параметр выберем: ";
                selectedRecordPoint = qurentPoint(getSelectedIndex(prompt, changeRecordOptions));
                workWithSearchPoint(selectedRecordPoint);
            } while (selectedRecordPoint != recordPoints.EXIT);
        }
        static void tryDeleteRow(int deleteRow, ref int upperLimit) {        
            int i = 0;
            using (BinaryReader reader = new BinaryReader(File.Open(CorrectionFilePath, FileMode.OpenOrCreate)))
                using (BinaryWriter writer = new BinaryWriter(File.Open(TempFilePath, FileMode.CreateNew))) {
                    TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                    while (reader.BaseStream.Position < reader.BaseStream.Length) {
                        temp.Country = reader.ReadString();
                        temp.Team = reader.ReadString();
                        temp.Coach = reader.ReadString();
                        temp.Points = reader.ReadInt32();
                        if (i++ != deleteRow) {
                            writer.Write(temp.Country);
                            writer.Write(temp.Team);
                            writer.Write(temp.Coach);
                            writer.Write(temp.Points);
                        }
                    }
                }
            File.Delete(CorrectionFilePath);
            File.Move(TempFilePath, CorrectionFilePath);
            upperLimit = i;
        }
        static void deleteRecord() {
            int deleteRow = 0;
            int upperLimit = 0;
            do {
                Console.Clear();
                deleteRow = getSelectedRow();
                tryDeleteRow(deleteRow, ref upperLimit);
            } while (deleteRow != upperLimit);
        }
        static void workWithMethod(PanelFunctions curentMethod) {
            switch (curentMethod) {
                case PanelFunctions.ADD: addNewRecord(); break;
                case PanelFunctions.CHANGE: changeRecord(); break;
                case PanelFunctions.SEARCH: searchRecord(); break;
                case PanelFunctions.DELETE: deleteRecord(); break;
                case PanelFunctions.REFERENCE: showReference(); break;
            }
        }
        static void importRecordsFromFile() {
            if (!File.Exists(MainFilePath)) using (FileStream fs = File.Create(MainFilePath));

            using (BinaryReader reader = new BinaryReader(File.Open(MainFilePath, FileMode.Open)))
            using (BinaryWriter writer = new BinaryWriter(File.Open(CorrectionFilePath, FileMode.OpenOrCreate))) {
                TFootballRecord temp = new TFootballRecord(string.Empty, string.Empty, string.Empty, 0);
                while (reader.BaseStream.Position < reader.BaseStream.Length) {
                    temp.Country = reader.ReadString();
                    temp.Team = reader.ReadString();
                    temp.Coach = reader.ReadString();
                    temp.Points = reader.ReadInt32();
                    writer.Write(temp.Country);
                    writer.Write(temp.Team);
                    writer.Write(temp.Coach);
                    writer.Write(temp.Points);
                }
            }
        }
        static void exportRecordsInFile() {
            File.Delete(MainFilePath);
            File.Move(CorrectionFilePath, MainFilePath);
        }
        static void programBlock() {
            importRecordsFromFile();
            PanelFunctions curentMethod = 0;
            do {
                string prompt = outputTable();
                prompt += '\n';
                curentMethod = searchQurentMainMethod(getSelectedIndex(prompt, mainOptions));
                workWithMethod(curentMethod);
            } while (curentMethod != PanelFunctions.EXIT);
            exportRecordsInFile();
            Environment.Exit(0);
        }
        public static void Main(string[] args) {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            Console.OutputEncoding = Encoding.GetEncoding(1251);
            Console.InputEncoding = Encoding.GetEncoding(1251);
            Console.Title = "Футбольный справочник™";
            programBlock();
            Console.ReadKey(true);
        }
    }
}