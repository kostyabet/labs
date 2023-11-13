// 2.	Дана непустая последовательность символов, требуется построить и напечатать множество, 
// элементами которого являются встречающиеся в последовательности знаки арифметических операций и числа. 
#include <iostream>
#include <fstream>
#include <string>
#include <set>
using namespace std;
const int FILE_KEY = 1;
const int CONSOLE_KEY = 2;
const int MIN_FILE_WAY_SIZE = 5;
const int MIN_SIZE = 1;
const int ERR_VALUE_OF_SIZE = 0;
void taskOutput() {
	cout << "...\n\n";
}
void workWayConditionOutput() {
	cout << "Where will we work through: \n\tFile: " <<
		FILE_KEY << " Console: " << CONSOLE_KEY << endl << endl;
}
void sizeConditionOutput() {
	cout << "How much ellements do you write: ";
}
// choice of direction
int choosingWorkWay()
{
	workWayConditionOutput();

	int path = 0;
	bool isIncorrect = true;
	cout << "Please write were we should work: ";
	do
	{
		cin >> path;
		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Error. You should write a natural number. Try again: ";
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
				cerr << "Error method. Try again: ";
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
set<char> inputSetSystem(int size) {
	set<char> setOfElements;
	char currentEllement;
	cout << "Write your simbols: ";
	for (int i = 0; i < size; i++) {
		cin >> currentEllement;
		setOfElements.insert(currentEllement);
	}
	return setOfElements;
}

/// input from console
bool checkSizeCondition(int size)
{
	if (cin.fail() || cin.get() != '\n')
	{
		cerr << "First string is natural number. Try again: ";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (size < MIN_SIZE)
	{
		cerr << "Min position number is " << MIN_SIZE << ". Try again: ";
	}
	else
	{
		return false;
	}

	return true;
}
int inputSizeFromConsole()
{
	int size;
	cout << "The position numbers of which occurrence you want to find: ";
	bool isIncorrect;
	do
	{
		cin >> size;
		isIncorrect = checkSizeCondition(size);
	} while (isIncorrect);

	return size;
}
//
int inputSizeFromFile(string fileWay)
{
	int size;
	ifstream file(fileWay, ios::in);
	file >> size;
	if (file.fail())
	{
		cerr << "First string is natural number. Try again: ";
		size = ERR_VALUE_OF_SIZE;
	}
	else if (size < MIN_SIZE)
	{
		cerr << "Min position number is " << MIN_SIZE << ". Try again: ";
		size = ERR_VALUE_OF_SIZE;
	}
	file.close();

	return size;
}
// 
char* inputSetFromConsole(int*& arrSize) {
	int size = inputSizeFromConsole();
	char* arrOfElements = new char[size];
	cout << "Write your " << size << " elements: ";
	arrSize[0] = size;
	bool isIncorrect = true;
	do {
		for (int i = 0; i < size; i++) {
			cin >> arrOfElements[i];
		}
		if (cin.peek() != '\n')
		{
			cout << "Error. More than " << size << " elements. Try again: ";
			cin.clear();
			cin.ignore(numeric_limits<streamsize>::max(), '\n');
		}
		else
		{
			isIncorrect = false;
		}
	} while (isIncorrect);
	return arrOfElements;
}
bool inputSetFromFile(char*& arrOfElements, int size, ifstream& file) {
	if (size == ERR_VALUE_OF_SIZE) {
		return true;
	}

	int bufferint;
	file >> bufferint;

	char counter;
	int i = 0;
	while (file.get(counter))
	{
		if (counter != '\n')
		{
			if (i <= size)
			{
				arrOfElements[i] = counter;
			}
			i++;
		}
	}

	if (i != size) {
		cout << "You should write " << size << " elements in this file. Try again: ";
		return true;
	}

	if (!file.eof()) {
		cout << "More than " << size << " elements. Try again: ";
		return true;
	}

	return false;
}
bool isCorrectSetInput(char*& arrOfElements, int size, string fileWay) {
	ifstream file(fileWay, ios::in);
	bool isIncorrect = inputSetFromFile(arrOfElements, size, file);
	file.close();

	return isIncorrect;
}
char* inputStringFromFile(int*& arrSize) {
	cout << "Write way to your file: ";
	char* arrOfElements = new char[0];
	bool isIncorrect;
	do {
		string fileWay = inputPathToTheFile();
		int size = inputSizeFromFile(fileWay);
		char* arrOfElements = new char[size];
		arrSize[0] = size;
		isIncorrect = isCorrectSetInput(arrOfElements, size, fileWay);
		if (!isIncorrect)
			return arrOfElements;
	} while (isIncorrect);
}
void renderingSet(char* arrOfElements, int size, set<char>& resultSet) {
	for (int i = 0; i <= size; i++) {
		if ((arrOfElements[i] >= '0' && arrOfElements[i] <= '9') ||
			(arrOfElements[i] >= '*' && arrOfElements[i] <= '+') ||
			(arrOfElements[i] == '-') || (arrOfElements[i] == '/'))
		{
			resultSet.insert(arrOfElements[i]);
		}
	}
}
void inputResInFile(set<char> resultSet, ofstream& file) {
	file << "The result is: { ";
	for (auto currentEllement : resultSet)
	{
		file << currentEllement << " ";
	}
	file << "}";
}
void outputFromFile(set<char> resultSet) {
	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputPathToTheFile();
		if (isCanOpenFile(fileWay, ios::out))
		{
			ofstream file(fileWay, ios::out);
			inputResInFile(resultSet, file);
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
void outputFromConsole(set<char> resultSet) {
	cout << "The result is: { ";
	for (auto currentEllement : resultSet)
	{
		cout << currentEllement << " ";
	}
	cout << "}";
}
void resultOutputSystem(set<char> resultSet) {
	cout << "\nYou need to choose where to write information from.\n";
	int path = choosingWorkWay();
	path == CONSOLE_KEY ? outputFromConsole(resultSet) : outputFromFile(resultSet);

}
char* inputSystem(int*& arrSize) {
	int path = choosingWorkWay();
	return path == CONSOLE_KEY ? inputSetFromConsole(arrSize)
		: inputStringFromFile(arrSize);
}
void clearMemory(int*& arrSize, char*& arrOfElements, set<char> resultSet) {
	delete[] arrSize;
	delete[] arrOfElements;
	arrOfElements = nullptr;
	arrSize = nullptr;
	resultSet.clear();
}
int main() {
	taskOutput();

	int* arrSize = new int[1];
	char* arrOfElements = inputSystem(arrSize);

	set<char> resultSet;
	renderingSet(arrOfElements, arrSize[0], resultSet);
	resultOutputSystem(resultSet);
	clearMemory(arrSize, arrOfElements, resultSet);
	return 0;
}