#include <iostream>
#include <string>
#include <fstream>
using namespace std;
const int MIN_K = 1;
const int ERR_VALUE_OF_K = -1;
const int VALUE_OF_DEFAULT_RESULT = -1;
const int STANDARD_NUMBER_OF_STRINGS = 2;
const int MIN_FILE_WAY_SIZE = 5;
const int FILE_KEY = 1;
const int CONSOLE_KEY = 2;
//text information output block
void conditionOutput()
{
	cout << "The program determines the position number K \n"
		"of the occurrence of the first line in the second.\n"
		"If there are no matches, returns -1.\n\n";
}
void pathConditionOutput()
{
	cout << "Where will we work through: \n\tFile: " <<
		FILE_KEY << " Console: " << CONSOLE_KEY << endl << endl;
}
void fileRestriction()
{
	cout << "\n*the first number in the file is the number\n"
		"of the occurrence the index of which you want to find,\n"
		"and after that the substring and the string*\n"
		"Write way to your file: ";
}
// choice of direction
int choosingAPath()
{
	pathConditionOutput();

	int path = 0;
	bool isIncorrect = true;
	do
	{
		cout << "Please write were we should work: ";
		cin >> path;
		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Error. You should write a number. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
		{
			if (path == CONSOLE_KEY || path == FILE_KEY)
			{
				isIncorrect = false;
			}
			else
			{
				cerr << "Error method. Try again.\n";
			}
		}
	} while (isIncorrect);

	return path;
}
// input and check path to the file
bool pathCondition(string way)
{
	if (way.size() < MIN_FILE_WAY_SIZE)
	{
		cerr << "The path is too short. Try again: ";
		return false;
	}
	string bufstr = way.substr(way.size() - 4);
	if (bufstr != ".txt")
	{
		cerr << "Write .txt file. Try again: ";
		return false;
	}
	return true;
}
string inputPath()
{
	string way;
	bool isIncorrect;
	do
	{
		cin >> way;
		isIncorrect = !pathCondition(way);
	} while (isIncorrect);

	return way;
}
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, mode);
	file.close();

	return file.good();
}
string inputPathToTheFile()
{
	string fileWay;
	bool isIncorrect = true;

	do
	{
		fileWay = inputPath();
		if (!isCanOpenFile(fileWay, ios::in))
		{
			cerr << "Can't open a file. Try write another way: ";
		}
		else
		{
			isIncorrect = false;
		}
	} while (isIncorrect);

	return fileWay;
}
// input from file
int inputKFromFile(string fileWay)
{
	int k;
	ifstream file(fileWay, ios::in);
	file >> k;
	if (file.fail())
	{
		cerr << "First string is natural number. Try again: ";
		k = ERR_VALUE_OF_K;
	}
	else if (k < MIN_K)
	{
		cerr << "Min position number is " << MIN_K << ". Try again: ";
		k = ERR_VALUE_OF_K;
	}
	file.close();

	return k;
}
void inputStringFromFile(ifstream& file, string*& str)
{
	char counter;
	int i = 0;
	while (file.get(counter))
	{
		if (counter != '\n')
		{
			str[i] += counter;
		}
		else
		{
			i++;
		}
	}
}
void settingTheCursor(ifstream& file)
{
	int bufferInt;
	char nextString;
	file >> bufferInt;
	file.get(nextString);
}
bool checkEndOfFile(ifstream& file)
{
	if (!file.eof()) {
		cerr << "In file should be only 1 number and 2 strings. Try again: ";
		return false;
	}

	return true;
}
void sysOfInputStringsFromFile(ifstream& file, string*& str)
{
	settingTheCursor(file);
	inputStringFromFile(file, str);
}
/// input from console
bool checkKCondition(int k)
{
	bool isIncorrect = true;
	if (cin.fail() || cin.get() != '\n')
	{
		cerr << "First string is natural number. Try again: ";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (k < MIN_K)
	{
		cerr << "Min position number is " << MIN_K << ". Try again: ";
	}
	else
	{
		isIncorrect = false;
	}

	return isIncorrect;
}
int inputKFromConsole()
{
	int k;
	cout << "The position numbers of which occurrence you want to find: ";
	bool isIncorrect = true;
	do
	{
		cin >> k;
		isIncorrect = checkKCondition(k);
	} while (isIncorrect);

	return k;
}
string inputStringFromConsole() {
	string str = "";
	char current;
	bool isCorrect = true;
	while (isCorrect && cin.get(current))
	{
		if (current != '\n')
		{
			str += current;
		}
		else
		{
			isCorrect = false;
		}
	}
	return str;
}
bool isCorrectInput(string str1, string str2, bool isItEndOfFile)
{
	if (str1 == "" || str2 == "")
	{
		cerr << "Bad strings input. Try again: ";
		return false;
	}

	return isItEndOfFile;
}
void sysOfInputStringsFromConsole(string*& str) {
	cout << "Write your first string: ";
	str[0] = inputStringFromConsole();
	cout << "Write your second string: ";
	str[1] = inputStringFromConsole();
}
/// search for result 
int calculationOfTheResult(int k, string str1, string str2)
{
	if (str2.size() < str1.size())
	{
		return VALUE_OF_DEFAULT_RESULT;
	}

	for (int i = 0; i < str2.size(); i++)
	{
		if (str2[i] == str1[0])
		{
			bool isCorrect = true;
			for (int j = 1; j < str1.size(); j++)
			{
				if ((str2[i + j] != str1[j]) && isCorrect)
				{
					isCorrect = false;
				}
			}
			if (isCorrect)
			{
				k--;
				if (!k)
				{
					return i + 1;
				}
			}
		}
	}

	return VALUE_OF_DEFAULT_RESULT;
}
/// output systeme
void outputFromFile(int result)
{
	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputPathToTheFile();
		if (isCanOpenFile(fileWay, ios::out))
		{
			ofstream file(fileWay, ios::out);
			file << result;
			file.close();

			cout << "Check your file.";
			isIncorrect = false;
		}
		else
		{
			cerr << "Can't open a file. Try write another way: ";
		}
	} while (isIncorrect);
}
void outputFromConsole(int result)
{
	cout << result << endl;
}
void resultOutput(int result)
{
	cout << "\nYou need to choose where to write information from.\n";
	int path = choosingAPath();
	path == CONSOLE_KEY ? outputFromConsole(result) : outputFromFile(result);
}
/// block of distributive functions
string inputFileWay(int path)
{
	return path == CONSOLE_KEY ? "" : inputPathToTheFile();
}
int kInput(int path, string fileWay)
{
	return path == CONSOLE_KEY ? inputKFromConsole() : inputKFromFile(fileWay);
}
bool isCorrectStringsInput(int path, string fileWay, string*& str, int k) {
	if (k == ERR_VALUE_OF_K)
	{
		return false;
	}

	if (path == CONSOLE_KEY)
	{
		sysOfInputStringsFromConsole(str);
		return true;
	}
	else
	{
		ifstream file(fileWay, ios::in);
		sysOfInputStringsFromFile(file, str);
		bool isItEndOfFile = checkEndOfFile(file);
		file.close();
		return isCorrectInput(str[0], str[1], isItEndOfFile);
	}
}
// input distributive
int inputSystem(string*& str)
{
	cout << "\nYou need to choose where to read information from.\n";
	int path = choosingAPath();

	if (path == FILE_KEY)
	{
		fileRestriction();
	}

	int k;
	bool isIncorrect = true;
	do
	{
		string fileWay = inputFileWay(path);

		k = kInput(path, fileWay);
		isIncorrect = !isCorrectStringsInput(path, fileWay, str, k);
	} while (isIncorrect);

	return k;
}
// main
int main()
{
	conditionOutput();

	string* str = new string[STANDARD_NUMBER_OF_STRINGS];
	int k = inputSystem(str);

	int result = calculationOfTheResult(k, str[0], str[1]);
	delete[] str;

	resultOutput(result);

	return 0;
}