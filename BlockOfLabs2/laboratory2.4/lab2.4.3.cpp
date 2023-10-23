#include <iostream>
#include <string>
#include <fstream>


using namespace std;


const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int MIN_ARR_SIZE = 2;


void printStatement() {
	cout << "The program calculates whether the entered\n\t"
		"natural number sequence is increasing.\n\n";
}


// work with way to the file
int pathСheck(bool& isIncorrect) {
	int path;
	cin >> path;

	if (cin.fail() || cin.get() != '\n') {
		cout << "Invalid numeric input. Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (path != CONS_NUM && path != FILE_NUM)
		cout << "Choose only " << CONS_NUM << " or "
		<< FILE_NUM << ". Try again.\n";
	else
		isIncorrect = false;

	return path;
}


int choosingAPath() {
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";

	int path;
	bool isIncorrect = true;
	do {
		cout << "Your choice: ";
		path = pathСheck(isIncorrect);
	} while (isIncorrect);

	return path;
}


// block of conditon check
bool isArrIncreasing(double*& arrOfNumb, int arrSize) {
	bool isConditionYes = true;

	for (int i = 1; i < arrSize; i++) {
		if (arrOfNumb[i] > arrOfNumb[i - 1]);
		else
			isConditionYes = false;
	}

	return isConditionYes;
}


int resoultOfArrChecking(bool isIncreas) {
	if (isIncreas)
		return 1;
	else
		return 0;
}


/// work in console
int inputArrSize() {
	bool isIncorrect = true;
	int arrSize;

	do {
		cout << "How much number in massive: ";
		cin >> arrSize;

		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (arrSize < MIN_ARR_SIZE)
			cout << "Min num is " << MIN_ARR_SIZE << ". Try again.\n";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return arrSize;
}


double enteringTheCurrentNumber(int i) {
	bool isIncorrect = true;
	double currentNum;

	do {
		cout << "Write your " << i + 1 << " number: ";
		cin >> currentNum;

		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
			isIncorrect = false;
	} while (isIncorrect);

	return currentNum;
}


void inputArr(double*& arrOfNumb, int arrSize) {
	for (int i = 0; i < arrSize; i++) {
		arrOfNumb[i] = enteringTheCurrentNumber(i);
	}
}


int viaConsole() {
	int arrSize = inputArrSize();
	double* arrOfNumb = new double[arrSize];

	inputArr(arrOfNumb, arrSize);
	bool isIncreasing = isArrIncreasing(arrOfNumb, arrSize);

	int result = resoultOfArrChecking(isIncreasing);

	delete[] arrOfNumb;
	arrOfNumb = nullptr;

	return result;
}


/// work with file
void fileRestriction() {
	cout << "\nRules for storing information in a file:\n\t"
		"1.  The first line contains an integer: \n\t\t"
		"the number of array elements;\n\t"
		"2.  The second line is real number\n\t\t"
		"entered separated by spaces.\n\n";
}


void wayCondition(string way, bool& isIncorrect) {
	if (way.size() > 4) {
		string bufstr = way.substr(way.size() - 4);
		if (bufstr == ".txt")
			isIncorrect = false;
		else
			cout << "Write .txt file.\n";
	}
	else
		cout << "The path is too short.\n";
}


string inputWayToTheFile() {
	string way;
	bool isIncorrect = true;

	do {
		cout << "Write way to your file: ";
		cin >> way;

		wayCondition(way, isIncorrect);
	} while (isIncorrect);

	return way;
}


bool isCorrectInputFromFile(ifstream& file, int& arrSize, double*& arrOfNumb) {
	file >> arrSize;
	if (file.fail() || file.get() != '\n')
		return false;

	if (arrSize < MIN_ARR_SIZE)
		return false;

	arrOfNumb = new double[arrSize];
	for (int i = 0; i < arrSize; i++) {
		file >> arrOfNumb[i];
		if (file.fail())
			return false;
	}

	if (!file.eof()) {
		return false;
	}

	return true;
}


int workWithArr(int arrSize, double*& arrOfNumb) {
	bool isIncreasin = isArrIncreasing(arrOfNumb, arrSize);
	int result = resoultOfArrChecking(isIncreasin);

	return result;
}


bool isReadingCorrect(string fileWay, int arrSize, double*& arrOfNumb) {
	ifstream file(fileWay, ios::in);

	bool isCorrect = isCorrectInputFromFile(file, arrSize, arrOfNumb);

	file.clear();
	file.close();

	return isCorrect;
}


int resultOfReading(bool isCorrect, int arrSize, double*& arrOfNumb,
	string fileWay) {
	if (isCorrect) {
		return workWithArr(arrSize, arrOfNumb);
	}
	else {
		cout << "ERROR in file.";

		return -1;
	}
}


int workWithFile(string fileWay) {
	int arrSize = 0;
	double* arrOfNumb;

	bool isCorrect = isReadingCorrect(fileWay, arrSize, arrOfNumb);
	int result = resultOfReading(isCorrect, arrSize, arrOfNumb, fileWay);

	delete[] arrOfNumb;
	arrOfNumb = nullptr;

	return result;
}


bool isFileIntegrity(string fileWay) {
	bool isIntegrity = false;

	fstream file;
	file.open(fileWay);

	if (file.is_open())
		isIntegrity = true;

	file.clear();
	file.close();

	return isIntegrity;
}


int workWithIntergrityResoult(bool isIntegrity, string fileWay) {
	if (isIntegrity)
		return workWithFile(fileWay);
	else {
		cout << "Bad File.";

		return -1;
	}
}


int viaFile() {
	fileRestriction();

	string fileWay = inputWayToTheFile();
	bool isIntegrity = isFileIntegrity(fileWay);

	return workWithIntergrityResoult(isIntegrity, fileWay);
}


/// output console
void outputViaConsole(int result) {
	if (result)
		cout << "Increase.";
	else
		cout << "Unincrease.";
}


/// output file
string fileCorrectOutput(int result) {
	if (result)
		return "\nIncrease.";
	else
		return "\nUnincrease.";
}


void outputViaFile(int result) {
	string fileWay = inputWayToTheFile();
	ofstream file(fileWay, ios::app);

	if (file.is_open()) {
		file << fileCorrectOutput(result);
		cout << "Check your file.";
	}
	else
		cout << "\nBad output file.";

	file.clear();
	file.close();
}


/// output
void output(int option, int result) {
	if (result != -1) {
		cout << "\n\nYou need to choose where to output the result.\n";
		option = choosingAPath();

		option == FILE_NUM ? outputViaFile(result) : outputViaConsole(result);
	}
}


/// main block
int main() {
	printStatement();

	int option = choosingAPath();
	int result = option == FILE_NUM ? viaFile() : viaConsole();

	output(option, result);

	return 0;
}