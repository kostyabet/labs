using System.Text;

namespace Proj4_2
{
    enum PanelFunctions
    {
        ADD,
        CHANGE,
        SEARCH,
        DELETE,
        EXIT
    }
    enum recordPoints
    {
        COUNTRY,
        TEAM,
        COACH,
        POINTS,
        EXIT
    }
    class MainClass()
    {
        record MyRecord(string country, string team, string coach, int points);
        static MyRecord[] recordArray = new MyRecord[0];
        const int MAX_STR_LENGTH = 20;
        const int MAX_N = 100;
        const int MIN_N = 0;
        static string[] mainOptions = { " < Add Record > ", " < Change Record > ", " < Search Record > ", " < Delete Record > ", " < Exit > " };
        static string[] changeRecordOptions = { "Country", "Team", "Coach", "Points", "<- Go Back" };

        static void sortRecords() { 
            int TempP, J;
            string TempT, TempCh, TempCy;

            for (int I = 1; I < recordArray.Length; I++)
            {
            TempP = recordArray[I].points;
            TempT = recordArray[I].team;
            TempCh = recordArray[I].coach;
            TempCy = recordArray[I].country;

            J = I - 1;
                while (J >= 0 && recordArray[J].points < TempP)
                {
                    recordArray[J + 1] = recordArray[J + 1] with { points = recordArray[J].points };
                    recordArray[J + 1] = recordArray[J + 1] with { team = recordArray[J].team };
                    recordArray[J + 1] = recordArray[J + 1] with { coach = recordArray[J].coach };
                    recordArray[J + 1] = recordArray[J + 1] with { country = recordArray[J].country };

                    recordArray[J] = recordArray[J] with { points = TempP };
                    recordArray[J] = recordArray[J] with { team = TempT };
                    recordArray[J] = recordArray[J] with { coach = TempCh };
                    recordArray[J] = recordArray[J] with { country = TempCy };

                    J--;
                }
            }
        }

        static void displayOptions(string prompt, string[] options, int selectedIndex = 0)
        {
            Console.WriteLine(prompt);
            for (int i = 0; i < options.Length; ++i)
            {
                string curentOption = options[i];
                string prefix;

                if (i == selectedIndex)
                {
                    prefix = "*";
                    Console.ForegroundColor = ConsoleColor.Black;
                    Console.BackgroundColor = ConsoleColor.White;
                }
                else
                {
                    prefix = " ";
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.BackgroundColor = ConsoleColor.Black;
                }

                Console.WriteLine($"{prefix} {curentOption}");
            }
            Console.ResetColor();
        }
        static int getSelectedIndex(string prompt, string[] options, int selectedIndex = 0)
        {
            ConsoleKey keyPressed;
            do
            {
                Console.Clear();
                displayOptions(prompt, options, selectedIndex);

                ConsoleKeyInfo keyInfo = Console.ReadKey(true);
                keyPressed = keyInfo.Key;

                if (keyPressed == ConsoleKey.UpArrow)
                {
                    selectedIndex--;
                    if (selectedIndex == -1)
                        selectedIndex = options.Length - 1;
                }

                if (keyPressed == ConsoleKey.DownArrow)
                {
                    selectedIndex++;
                    if (selectedIndex == options.Length)
                        selectedIndex = 0;
                }
            } while (keyPressed != ConsoleKey.Enter);

            return selectedIndex;
        }

        static PanelFunctions searchQurentMainMethod(int curentIndex)
        {
            switch (curentIndex)
            {
                case (int)PanelFunctions.ADD: return PanelFunctions.ADD;
                case (int)PanelFunctions.CHANGE: return PanelFunctions.CHANGE;
                case (int)PanelFunctions.SEARCH: return PanelFunctions.SEARCH;
                case (int)PanelFunctions.DELETE: return PanelFunctions.DELETE;
                default: return PanelFunctions.EXIT;
            }
        }

        static string outputTable()
        {
            int columnWidth = 20;

            string formatString = "  {0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string prompt = string.Format(formatString, "Position", "Country", "Team", "Coach", "Points");
            prompt += '\n' + new string('-', (columnWidth + 1) * 5);

            int i = 1;
            foreach (MyRecord record in recordArray)
                prompt += '\n' + string.Format(formatString, i++, record.country, record.team, record.coach, record.points);

            return prompt;
        }
        static string inputString(string prompt, in int maxLength)
        {
            Console.Write(prompt);

            bool isCorrect = false;
            string curentStr = string.Empty;
            do
            {
                curentStr = Console.ReadLine() ?? string.Empty;
                isCorrect = !((curentStr.Length > maxLength) || (curentStr == string.Empty));
                if (!isCorrect)
                    Console.Error.Write("Error. Try again (max length 20 symbols): ");
            } while (!isCorrect);

            return curentStr;
        }

        static int inputNum(string prompt, in int max, in int min)
        {
            Console.Write(prompt);

            bool isCorrect = true;
            int num = 0;
            do
            {
                try {
                    num = Convert.ToInt32(Console.ReadLine());

                    isCorrect = true;
                } catch {
                    isCorrect = false;
                }

                isCorrect = isCorrect && !(num > max) && !(num < min);
                if (!isCorrect)
                    Console.Error.Write($"Error. Try again [{min}; {max}]: ");
            } while (!isCorrect);

            return num;
        }
        static void addRecordInMassive(MyRecord rec)
        {
            Array.Resize(ref recordArray, recordArray.Length + 1);
            recordArray[recordArray.Length - 1] = rec;
        }
        static void addNewRecord()
        {
            Console.Clear();
            MyRecord rec = new MyRecord(string.Empty, string.Empty, string.Empty, 0);
            Console.WriteLine("Let's go to add new record.");

            string Countrty = inputString("Input Country: ", MAX_STR_LENGTH);
            rec = rec with { country = Countrty };

            string Team = inputString("Input Team name: ", MAX_STR_LENGTH);
            rec = rec with { team = Team };

            string Coach = inputString("Input Coach surname: ", MAX_STR_LENGTH);
            rec = rec with { coach = Coach };

            int Points = inputNum("Input numbers of Points: ", MAX_N, MIN_N);
            rec = rec with { points = Points };

            addRecordInMassive(rec);
            sortRecords();

            string prompt = $"""
                Country: {Countrty};
                Team: {Team};
                Coach: {Coach};
                Points: {Points};
                """;
            string[] options = { " <- Go Back" };
            getSelectedIndex(prompt, options);
        }

        static string[] createRecordsOptions(int columnWidth, string formatString)
        {
            string[] result = new string[recordArray.Length + 1];
            int i = 1;

            foreach (MyRecord record in recordArray)
                result[i - 1] = string.Format(formatString, i++, record.country, record.team, record.coach, record.points);

            result[i - 1] = "<- Go Back";

            return result;
        }

        static int getSelectedRow()
        {
            int columnWidth = 20;

            string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string[] recordsOption = createRecordsOptions(columnWidth, formatString);

            formatString = "  {0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
            string prompt = string.Format(formatString, "Position", "Country", "Team", "Coach", "Points");
            prompt += "\n" + new string('-', (columnWidth + 1) * 5);

            return getSelectedIndex(prompt, recordsOption);
        }

        static recordPoints qurentPoint(int selectedIndex)
        {
            switch (selectedIndex)
            {
                case (int)recordPoints.COUNTRY: return recordPoints.COUNTRY;
                case (int)recordPoints.TEAM: return recordPoints.TEAM;
                case (int)recordPoints.COACH: return recordPoints.COACH;
                case (int)recordPoints.POINTS: return recordPoints.POINTS;
                default: return recordPoints.EXIT;
            }
        }

        static void changeCountry(int selectedRow)
        {
            string Countrty = inputString("Input Country: ", MAX_STR_LENGTH);
            recordArray[selectedRow] = recordArray[selectedRow] with { country = Countrty };
        }
        static void changeTeam(int selectedRow)
        {
            string Team = inputString("Input Team name: ", MAX_STR_LENGTH);
            recordArray[selectedRow] = recordArray[selectedRow] with { team = Team };
        }
        static void changeCoach(int selectedRow)
        {
            string Coach = inputString("Input Coach surname: ", MAX_STR_LENGTH);
            recordArray[selectedRow] = recordArray[selectedRow] with { coach = Coach };
        }
        static void changePoints(int selectedRow)
        {
            int Points = inputNum("Input numbers of Points: ", MAX_N, MIN_N);
            recordArray[selectedRow] = recordArray[selectedRow] with { points = Points };
        }

        static void workWithPoint(recordPoints selectedRecordPoint, int selectedRow)
        {
            switch (selectedRecordPoint)
            {
                case recordPoints.COUNTRY: changeCountry(selectedRow); break;
                case recordPoints.TEAM: changeTeam(selectedRow); break;
                case recordPoints.COACH: changeCoach(selectedRow); break;
                case recordPoints.POINTS: changePoints(selectedRow); break;
            }
        }
        static void workWithSelectedRow(int selectedRow)
        {
            if (selectedRow == recordArray.Length)
                return;

            recordPoints selectedRecordPoint = recordPoints.EXIT;
            do
            {
                int columnWidth = 20;
                string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
                string prompt = string.Format(formatString, "Position", "Country", "Team", "Coach", "Points");
                prompt += "\n" + new string('-', columnWidth * 5);
                prompt += '\n' + string.Format(formatString, 0, recordArray[selectedRow].country, recordArray[selectedRow].team, recordArray[selectedRow].coach, recordArray[selectedRow].points);
                prompt += "\nWhat would you like to change:";
                selectedRecordPoint = qurentPoint(getSelectedIndex(prompt, changeRecordOptions));
                workWithPoint(selectedRecordPoint, selectedRow);
                sortRecords();
            } while (selectedRecordPoint != recordPoints.EXIT);
        }

        static void changeRecord()
        {
            int selectedRow = 0;
            do
            {
                Console.Clear();
                selectedRow = getSelectedRow();
                workWithSelectedRow(selectedRow);
            } while (selectedRow != recordArray.Length);
        }
        static int returnRow(recordPoints selectedRecordPoint)
        {
            switch (selectedRecordPoint)
            {
                case recordPoints.POINTS:
                    int Points = inputNum("Input numbers of Points: ", MAX_N, MIN_N);
                    for (int i = 0; i < recordArray.Length; ++i)
                    {
                        if (recordArray[i].points == Points)
                            return i;
                    }
                    break;
                case recordPoints.COUNTRY:
                    string Country = inputString("Input Country name: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                    {
                        if (recordArray[i].country == Country)
                            return i;
                    }
                    break;
                case recordPoints.TEAM:
                    string Team = inputString("Input Team name: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                    {
                        if (recordArray[i].team == Team)
                            return i;
                    }
                    break;
                case recordPoints.COACH:
                    string Coach = inputString("Input Coach name: ", MAX_STR_LENGTH);
                    for (int i = 0; i < recordArray.Length; ++i)
                    {
                        if (recordArray[i].coach == Coach)
                            return i;
                    }
                    break;
            }
            return -1;
        }
        static void workWithSearchPoint(recordPoints selectedRecordPoint)
        {
            string prompt = string.Empty;
            string[] options = { "<- Go Back" };
            int recordIndex = returnRow(selectedRecordPoint);
            if (recordIndex == -1 && selectedRecordPoint != recordPoints.EXIT)
            {
                prompt = "No suitable entry found...";
            }
            else if (selectedRecordPoint != recordPoints.EXIT)
            {
                int columnWidth = 20;
                string formatString = "{0,-" + columnWidth + "} {1,-" + columnWidth + "} {2,-" + columnWidth + "} {3,-" + columnWidth + "} {4,-" + columnWidth + "}";
                prompt = string.Format(formatString, "Position", "Country", "Team", "Coach", "Points");
                prompt += "\n" + new string('-', columnWidth * 5);
                prompt += '\n' + string.Format(formatString, 0, recordArray[recordIndex].country, recordArray[recordIndex].team, recordArray[recordIndex].coach, recordArray[recordIndex].points);
            }

            if (selectedRecordPoint != recordPoints.EXIT)
                getSelectedIndex(prompt, options);
        }
        static void searchRecord()
        {
            Console.Clear();
            recordPoints selectedRecordPoint = recordPoints.EXIT;
            do
            {
                string prompt = "What parameter will we search for: ";
                selectedRecordPoint = qurentPoint(getSelectedIndex(prompt, changeRecordOptions));
                workWithSearchPoint(selectedRecordPoint);
            } while (selectedRecordPoint != recordPoints.EXIT);
        }
        static void tryDeleteRow(int deleteRow)
        {
            if (deleteRow == recordArray.Length)
                return;

            for (int i = deleteRow; i < recordArray.Length - 1; i++)
                recordArray[i] = recordArray[i + 1];

            Array.Resize(ref recordArray, recordArray.Length - 1);
        }
        static void deleteRecord()
        {
            int deleteRow = 0;
            int upperLimit = 0;
            do
            {
                upperLimit = recordArray.Length;
                Console.Clear();
                deleteRow = getSelectedRow();
                tryDeleteRow(deleteRow);
            } while (deleteRow != upperLimit);
        }

        static void workWithMethod(PanelFunctions curentMethod)
        {
            switch (curentMethod)
            {
                case PanelFunctions.ADD: addNewRecord(); break;
                case PanelFunctions.CHANGE: changeRecord(); break;
                case PanelFunctions.SEARCH: searchRecord(); break;
                case PanelFunctions.DELETE: deleteRecord(); break;
            }
        }

        static void programBlock()
        {
            PanelFunctions curentMethod = 0;
            do
            {
                string prompt = outputTable();
                prompt += '\n';
                curentMethod = searchQurentMainMethod(getSelectedIndex(prompt, mainOptions));
                workWithMethod(curentMethod);
            } while (curentMethod != PanelFunctions.EXIT);
            Environment.Exit(0);
        }

        public static void Main(string[] args)
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            Console.OutputEncoding = Encoding.GetEncoding(1251);
            Console.InputEncoding = Encoding.GetEncoding(1251);
            Console.Title = "Football derictory";
            programBlock();
            Console.ReadKey(true);
        }
    }
}