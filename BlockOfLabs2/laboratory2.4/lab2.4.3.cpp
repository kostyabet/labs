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
void pathСheck(int& path, bool& isIncorrect) {
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
}


int choosingAPath() {
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";

	int path;
	bool isIncorrect = true;
	do {
		cout << "Your choice: ";
		pathСheck(path, isIncorrect);
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


string resoultOfArrChecking(bool isIncreas) {
	if (isIncreas)
		return "\nIncreasing.\n";
	else
		return "\nNot increasing.\n";
}


/// work in console
int inputArrSize() {
	bool isIncorrect = true;
	int arrSize;

	do {
		cout << "How much number in massive: ";
		cin >> arrSize;

		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again. \n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (arrSize < MIN_ARR_SIZE)
			cout << "Min num is " << MIN_ARR_SIZE << ". Try again. \n";
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


void viaConsole() {
	int arrSize = inputArrSize();
	double* arrOfNumb = new double[arrSize];
	inputArr(arrOfNumb, arrSize);
	bool isIncreasing = isArrIncreasing(arrOfNumb, arrSize);
	cout << resoultOfArrChecking(isIncreasing);
}


/// work with file
void fileRestriction() {
	cout << "\nRules for storing information in a file:\n\t"
		"1.  The first line contains an integer: \n\t\t"
		"the number of array elements;\n\t"
		"2.  The second line is real number\n\t\t"
		"sentered separated by spaces.\n\n";
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


void workWithArr(int arrSize, double*& arrOfNumb, string fileWay) {
	ofstream file(fileWay, ios::app);

	bool isIncreasin = isArrIncreasing(arrOfNumb, arrSize);
	file << resoultOfArrChecking(isIncreasin);

	file.clear();
	file.close();
}


bool isReadingCorrect(string fileWay, int arrSize, double*& arrOfNumb) {
	ifstream file(fileWay, ios::in);

	bool isCorrect = isCorrectInputFromFile(file, arrSize, arrOfNumb);

	file.clear();
	file.close();

	return isCorrect;
}


void resultOfReading(bool isCorrect, int arrSize, double*& arrOfNumb,
	string fileWay) {
	if (isCorrect) {
		workWithArr(arrSize, arrOfNumb, fileWay);
		cout << "Cheack yout file.";
	}
	else
		cout << "ERROR in file.";
}


void workWithFile(string fileWay) {
	int arrSize = 0;
	double* arrOfNumb;

	bool isCorrect = isReadingCorrect(fileWay, arrSize, arrOfNumb);
	resultOfReading(isCorrect, arrSize, arrOfNumb, fileWay);
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


void workWithIntergrityResoult(bool isIntegrity, string fileWay) {
	if (isIntegrity)
		workWithFile(fileWay);
	else
		cout << "Bad File.";
}


void viaFile() {
	fileRestriction();

	string fileWay = inputWayToTheFile();
	bool isIntegrity = isFileIntegrity(fileWay);
	workWithIntergrityResoult(isIntegrity, fileWay);
}


/// main block
int main() {
	printStatement();

	int option = choosingAPath();

	option == FILE_NUM ? viaFile() : viaConsole();
	return 0;
}