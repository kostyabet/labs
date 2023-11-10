#include <iostream>
#include <string>
#include <fstream>

using namespace std;

const int FILE_KEY = 1;
const int MIN_K = 1;
const int CONSOLE_KEY = 2;
const int MIN_FILE_WAY_SIZE = 5;

void conditionOutput()
{
	cout << "The program determines the position number K \n"
		<< "of the occurrence of the first line in the second.\n"
		<< "If there are no matches, returns -1.\n\n";
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

/// input from file
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, mode);
	file.close();

	return file.good();
}

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
				isIncorrect = false;
			else cerr << "Error method. Try again.\n";
		}
	} while (isIncorrect);

	return path;
}

// input way to the file
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
string inputPathToTheFile()
{
	string fileWay;
	bool isIncorrect = true;

	do
	{
		bool isCorrect = true;
		fileWay = inputPath();
		if (!isCanOpenFile(fileWay, ios::in))
			cerr << "Can't open a file. Try write another way: ";
		else
			isIncorrect = false;
	} while (isIncorrect);
	return fileWay;
}


bool afterReadingCheck(ifstream& file, bool isCorrect, string str1, string str2)
{
	if ((str1 == "" || str2 == "") && isCorrect)
	{
		isCorrect = false;
		cout << "There cannot be empty lines. Try again: ";
	}
	if (!file.eof() && isCorrect)
	{
		isCorrect = false;
		cout << "The file should only contain 1 number and 2 lines. Try again: ";
	}

	return isCorrect;
}

/// input from console
int inputKFromFile(string fileWay)
{
	int k;
	ifstream file(fileWay, ios::in);
	file >> k;
	if (file.fail())
	{
		cerr << "First string is natural number. Try again: ";
		k = -1;
	}
	else if (k < MIN_K)
	{
		cerr << "Min position number is " << MIN_K << ". Try again: ";
		k = -1;
	}
	file.close();
	return k;
}

bool checkKCondition(int k) {
	bool isIncorrect = true;
	if (cin.fail() || cin.get() != '\n') {
		cerr << "First string is natural number. Try again: ";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (k < MIN_K)
		cerr << "Min position number is " << MIN_K << ". Try again: ";
	else
		isIncorrect = false;

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

string inputStringFromFile(ifstream& file) {
	string str;
	file >> str;
	file.close();
	return str;
}

string inputStringFromConsole() {
	string str;
	cin >> str;
	return str;
}

/// check condition 
int calculationOfTheResult(int k, string str1, string str2)
{
	for (int i = 0; i < str2.size(); i++)
		if (str2[i] == str1[0])
		{
			bool isCorrect = true;
			for (int j = 1; j < str1.size(); j++)
				if (str2[i + j] != str1[j])
					isCorrect = false;
			if (isCorrect)
				k--;
			if (!k && isCorrect)
				return i + 1;
		}

	return -1;
}

/// output from file
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
			cerr << "Can't open a file. Try write another way: ";
	} while (isIncorrect);
}

/// output from console
void outputFromConsole(int result)
{
	cout << result << endl;
}

/// block of main void-s
void resultOutput(int result)
{
	cout << "You need to choose where to write information from.\n";
	int path = choosingAPath();
	path == CONSOLE_KEY ? outputFromConsole(result) : outputFromFile(result);
}

string inputFileWay(int path) {
	return path == CONSOLE_KEY ? "" : inputPathToTheFile();
}

int kInput(int path, string fileWay) {
	return path == CONSOLE_KEY ? inputKFromConsole() : inputKFromFile(fileWay);
}

void settingTheCursor(ifstream& file, string str1, string str2) {
	int bufferInt;
	file >> bufferInt;

	if (str1 == "" && str2 == "")
	{
		string bufferStr;
		file >> bufferStr;
		file >> bufferStr;
	}
}

void settingTheCursor(ifstream& file, string str1) {
	int bufferInt;
	file >> bufferInt;

	if (str1 != "")
	{
		string bufferStr;
		file >> bufferStr;
	}
}

string stringInput(int path, string fileWay, string str1, int k) {
	string res = "";
	if (path == CONSOLE_KEY && k != -1)
	{
		cout << "Write your first string: ";
		res = inputStringFromConsole();
	}
	else if (k != -1)
	{
		ifstream file(fileWay, ios::in);
		settingTheCursor(file, str1);
		res = inputStringFromFile(file);
		file.close();
	}

	return res;
}

bool checkEndOfFile(string fileWay) {
	bool isEOF = true;
	ifstream file(fileWay, ios::in);
	settingTheCursor(file, "", "");
	isEOF = file.eof();
	file.close();

	return isEOF;
}

bool isCorrectInput(int path, string fileWay, int k, string str1, string str2) {
	if (path == FILE_KEY)
	{
		if (k == -1)
			return false;

		if (str1 == "" || str2 == "")
		{
			cerr << "Bad strings input. Try again: ";
			return false;
		}

		if (!checkEndOfFile(fileWay))
		{
			cerr << "In file should be only 1 number and 2 strings. Try again: ";
			return false;
		}
	}

	return true;
}

int main()
{
	int k = 0;
	string str1 = "";
	string str2 = "";
	conditionOutput();

	cout << "\nYou need to choose where to read information from.\n";
	int path = choosingAPath();

	bool isIncorrect = true;
	if (path == FILE_KEY)
		fileRestriction();

	do {
		string fileWay = inputFileWay(path);

		k = kInput(path, fileWay);
		str1 = stringInput(path, fileWay, str1, k);
		str2 = stringInput(path, fileWay, str1, k);
		isIncorrect = !isCorrectInput(path, fileWay, k, str1, str2);
	} while (isIncorrect);

	int result = calculationOfTheResult(k, str1, str2);

	resultOutput(result);

	return 0;
}