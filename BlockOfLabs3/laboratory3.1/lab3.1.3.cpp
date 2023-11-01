#include <iostream>
#include <string> // for work with string
#include <fstream> // for work with file (.txt)


using namespace std;


const int MIN_K = 1;
const int MIN_FILE_WAY_SIZE = 5;
const int CONSOLE_KEY = 1;
const int FILE_KEY = 0;


/// text information
void conditionOutput()
{
	cout << "The program determines the position number K \n"
		<< "of the occurrence of the first line in the second.\n"
		<< "If there are no matches, returns -1.\n\n";
}


void pathConditionOutput()
{
	cout << "Where will we work through: \n\tFile: " << FILE_KEY << " Console: "
		<< CONSOLE_KEY << endl << endl;
}


void fileRestriction()
{
	cout << "\n*the first number in the file\n\t should be a number, followed by 2 lines*\n";
}


/// writing a path
int checkPathCondition()
{
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
			if (path == CONSOLE_KEY || path == FILE_KEY) isIncorrect = false;
			else cerr << "Error method. Try again.\n";
		}
	} while (isIncorrect);

	return path;
}


int choosingAPath()
{
	pathConditionOutput();

	return checkPathCondition();
}


/// input way to the file 
bool wayCondition(string way)
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


string inputWayToTheFile()
{
	string way;
	bool isIncorrect = true;

	do
	{
		cin >> way;

		isIncorrect = !wayCondition(way);
	} while (isIncorrect);

	return way;
}


/// input from file
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, ios::in);
	file.close();

	return file.good();
}


bool checkEndOfLine(ifstream& file)
{
	char currentChar;
	int startPos = file.tellg();
	while ((currentChar = file.get()) != '\n')
	{
		if (!isspace(currentChar))
		{
			file.seekg(startPos);
			return false;
		}
	}

	return true;
}


string inputFile() {
	fileRestriction();
	string fileWay;
	bool isIncorrect = true;

	ifstream file;
	cout << "Write way to your file: ";
	do {
		bool isCorrect = true;
		fileWay = inputWayToTheFile();
		if (!isCanOpenFile(fileWay, ios::in))
			cout << "Can't open a file. Try write another way: ";
	} while (isIncorrect);

	file.close();

	return fileWay;
}


bool afterReadingCheck(ifstream& file, bool isCorrect) {
	bool isIncorrect = true;
	if (!checkEndOfLine(file) && isCorrect)
		isCorrect = false;

	if (!isCorrect)
		cout << "Error in file reading. Try again: ";
	else
		isIncorrect = false;

	return isIncorrect;
}


/// input from console
bool checkKCondition(int k)
{
	bool isIncorrect = true;
	if (cin.fail() && cin.get() != '\n')
	{
		cerr << "You should write a number. Try again: ";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (k < MIN_K)
	{
		cerr << "Min position number is " << MIN_K << ". Try again: ";
	}
	else
		isIncorrect = false;

	return isIncorrect;
}


int inputKFromConsole() {
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


/// cheack condition 
int calculationOfTheResult(int k, string str1, string str2)
{
	for (int i = 0; i < str2.size(); i++)
		if (str2[i] == str1[0])
			if (str2.substr(i, str1.size()) == str1)
				if (--k == 0)
					return i + 1;

	return -1;
}


/// output from file
void outputFromFile(int result)
{
	ofstream file;

	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputWayToTheFile();

		if (isCanOpenFile(fileWay, ios::out) && file.is_open())
		{
			file.open(fileWay, ios::out);

			file << result;
			cout << "Check your file.";

			isIncorrect = false;
		}
		else
			cerr << "Can't open a file. Try write another way: ";
	} while (isIncorrect);

	file.close();
}


/// outputfrom console
void outputFromConsole(int result)
{
	cout << result << endl;
}


/// block of main void-s
void resultOutput(int result)
{
	cout << "You need to choose where to write information from.\n";
	int path = choosingAPath();

	path ? outputFromConsole(result) : outputFromFile(result);
}


int main()
{
	conditionOutput();

	int k = 0;
	string str1, str2;

	cout << "\nYou need to choose where to read information from.\n";
	int path = choosingAPath();

	if (path == CONSOLE_KEY) {
		k = inputKFromConsole();
		cout << "Write your first string: ";
		cin >> str1;
		cout << "Write your second string: ";
		cin >> str2;
	}
	else {
		bool isIncorrect;
		do {
			bool isCorrect = true;
			string fileWay = inputFile();
			ifstream file(fileWay, ios::in);
			file >> k;
			if ((file.fail() && file.get() != '\n') || (k < MIN_K))
				isCorrect = false;

			file >> str1 >> str2;

			isIncorrect = afterReadingCheck(file, isCorrect);
		} while (isIncorrect);
	}

	int resultOfProg = calculationOfTheResult(k, str1, str2);

	resultOutput(resultOfProg);

	return 0;
}