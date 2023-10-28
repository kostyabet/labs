#include <iostream>
#include <string>
#include <fstream>


using namespace std;


const int MIN_K = 1;
const int MIN_FILE_WAY_SIZE = 5;


enum class IOMethod {
	FILE,
	CONSOLE
};


/// text information 
void conditionOutput() {
	cout << "The program determines the position number K \n"
		<< "of the occurrence of the first line in the second\n"
		<< "If there are no matches, returns -1.\n\n";
}


void pathConditionOutput() {
	cout << "Where will we work through: \n\tFile: " << (int)IOMethod::FILE << " Console: "
		<< (int)IOMethod::CONSOLE << endl << endl;
}


void fileRestriction() {
	cout << "\n*the first number in the file\n\t should be a number, followed by 2 lines*\n";
}


/// writing a path
bool cheackPathCondition(int path) {
	IOMethod result = (IOMethod)path;
	if (cin.fail() || cin.get() != '\n')
	{
		cerr << "Error. You should write a number. Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else
	{
		switch (result) {
		case IOMethod::CONSOLE: return false;
		case IOMethod::FILE: return false;

		default: cerr << "Error method. Try again.\n";
		}
	}

	return true;
}


int choosingAPath() {
	int path = 0;
	bool isIncorrect = true;

	pathConditionOutput();

	do {
		cout << "Please write were we should work: ";
		cin >> path;

		isIncorrect = cheackPathCondition(path);
	} while (isIncorrect);

	return path;
}


/// input way to the file 
bool wayCondition(string way)
{
	if (way.size() < MIN_FILE_WAY_SIZE) {
		cerr << "The path is too short. Try again: ";

		return false;
	}

	string bufstr = way.substr(way.size() - 4);
	if (bufstr != ".txt") {
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
bool isCanOpenFile(string way, ios_base::openmode mode) {
	fstream file(way, ios::in);
	file.close();

	return file.good();
}


bool workWithFileInput(int& k, string& str1, string& str2, ifstream& file) {
	file >> k;
	if (file.fail() && file.get() != '\n')
		return false;

	if (k < MIN_K)
		return false;

	file >> str1 >> str2;

	if (!file.eof())
		return false;

	return true;
}


void inputFromFile(int& k, string& str1, string& str2) {
	fileRestriction();

	ifstream file;
	bool isIncorrect = true;

	cout << "Write way to your file: ";
	do {
		string fileWay = inputWayToTheFile();
		if (isCanOpenFile(fileWay, ios::in)) {
			file.open(fileWay, ios::in);

			if (!workWithFileInput(k, str1, str2, file))
				cout << "Error in file reading. Try again: ";
			else
				isIncorrect = false;
		}
		else
			cout << "Can't open a file. Try write another way: ";
	} while (isIncorrect);

	file.close();
}


/// input from console
void checkKCondition(int k, bool& isIncorrect) {
	if (cin.fail() && cin.get() != '\n') {
		cout << "You should write a number. Try again: ";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (k < MIN_K) {
		cout << "Min position number is " << MIN_K << ". Try again: ";
	}
	else
		isIncorrect = false;
}


void inputFromConsole(int& k, string& str1, string& str2) {
	cout << "The position numbers of which occurrence you want to find: ";
	bool isIncorrect = true;
	do {
		cin >> k;

		checkKCondition(k, isIncorrect);
	} while (isIncorrect);

	cout << "Write your first string: ";
	cin >> str1;

	cout << "Write your second string: ";
	cin >> str2;
}


/// cheack 
int calculationOfTheResult(int k, string str1, string str2) {
	for (int i = 0; i < str2.size(); i++)
		if (str2[i] == str1[0])
			if (str2.substr(i, str1.size()) == str1)
				if (--k == 0)
					return i + 1;

	return -1;
}


/// output from file
void outputFromFile(int result) {
	ofstream file;

	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do {
		string fileWay = inputWayToTheFile();

		if (isCanOpenFile(fileWay, ios::out) && file.is_open()) {
			file.open(fileWay, ios::out);

			file << result;
			cout << "Check your file.";

			isIncorrect = false;
		}
		else
			cout << "Can't open a file. Try write another way: ";
	} while (isIncorrect);

	file.close();
}


/// outputfrom console
void outputFromConsole(int result) {
	cout << result << endl;
}


/// block of main void-s
void dataInput(int& k, string& str1, string& str2) {
	cout << "\nYou need to choose where to read information from.\n";
	int path = choosingAPath();

	path ? inputFromConsole(k, str1, str2) : inputFromFile(k, str1, str2);
}


void resultOutput(int result) {
	cout << "You need to choose where to write information from.\n";
	int path = choosingAPath();

	path ? outputFromConsole(result) : outputFromFile(result);
}


int main() {
	conditionOutput();

	int k;
	string str1, str2;
	dataInput(k, str1, str2);

	int result = calculationOfTheResult(k, str1, str2);

	resultOutput(result);

	return 0;
}