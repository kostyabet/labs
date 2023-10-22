#include <iostream>
#include <string>
#include <fstream>


using namespace std;


const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int MIN_ARR_SIZE = 2;


void condition() {
	cout << "The program calculates whether the entered\n\t"
		"natural number sequence is increasing.\n\n";
}


// work with way to the file
void pathCondition(int& num, bool& isIncorrect) {
	cin >> num;

	if (cin.fail() || cin.get() != '\n') {
		cout << "Invalid numeric input. Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (num != CONS_NUM && num != FILE_NUM)
		cout << "Choose only " << CONS_NUM << " or "
		<< FILE_NUM << ". Try again.\n";
	else
		isIncorrect = false;
}


int choosingAPath() {
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";

	int num;
	bool isIncorrect = true;
	do {
		cout << "Your choice: ";
		pathCondition(num, isIncorrect);
	} while (isIncorrect);

	return num;
}


// block of conditon check
bool arrayFilling(double*& arrOfNumb, int arrNumb) {
	bool isConditionYes = true;

	for (int i = 1; i < arrNumb; i++) {
		if (arrOfNumb[i] > arrOfNumb[i - 1]);
		else
			isConditionYes = false;
	}

	return isConditionYes;
}


string resoultOfChecking(bool isConditionYes) {
	if (isConditionYes)
		return "Vozroct.";
	else
		return "Ne vozroct.";
}


/// work in console
int numInMassive() {
	bool isIncorrect = true;
	int arrNumb;

	do {
		cout << "How much number in massive: ";
		cin >> arrNumb;

		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again. \n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (arrNumb < MIN_ARR_SIZE)
			cout << "Min num is " << MIN_ARR_SIZE << ". Try again. \n";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return arrNumb;
}


double massiveElement(int i) {
	bool isIncorrect = true;
	double element;

	do {
		cout << "Write your " << i + 1 << " number: ";
		cin >> element;

		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
			isIncorrect = false;
	} while (isIncorrect);

	return element;
}


void inputArr(double*& arrOfNumb, int arrNumb) {
	for (int i = 0; i < arrNumb; i++) {
		arrOfNumb[i] = massiveElement(i);
	}
}



void viaConsole() {
	int arrNumb = numInMassive();
	double* arrOfNumb = new double[arrNumb];
	inputArr(arrOfNumb, arrNumb);
	bool isConditionYes = arrayFilling(arrOfNumb, arrNumb);
	cout << resoultOfChecking(isConditionYes);
}

/// work with file
void fileRestrict() {
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


string inputWay() {
	string way;
	bool isIncorrect = true;

	do {
		cout << "Write way to your file: ";
		cin >> way;
		wayCondition(way, isIncorrect);
	} while (isIncorrect);

	return way;
}


bool inputFromFile(ifstream& file, int& sizeOfAllEllements, double*& arr) {
	file >> sizeOfAllEllements;
	if (file.fail() || file.get() != '\n')
		return false;

	if (sizeOfAllEllements < MIN_ARR_SIZE)
		return false;

	arr = new double[sizeOfAllEllements];
	for (int i = 0; i < sizeOfAllEllements; i++) {
		file >> arr[i];
		if (file.fail())
			return false;
	}

	if (!file.eof()) {
		return false;
	}

	return true;
}


void workWithArr(int sizeOfAllEllements, double*& arr, string fileWay) {
	ofstream file(fileWay, ios::app);

	bool isIncorrect = arrayFilling(arr, sizeOfAllEllements);
	file << resoultOfChecking(isIncorrect);

	file.clear();
	file.close();
}


bool readingProcess(string fileWay, int sizeOfAllEllements, double*& arr) {
	ifstream file(fileWay, ios::in);

	bool isIncorrect = inputFromFile(file, sizeOfAllEllements, arr);

	file.clear();
	file.close();
	return isIncorrect;
}


void resoultOfReading(bool isIncorrect, int sizeOfAllEllements, double*& arr, string fileWay) {
	if (isIncorrect) {
		workWithArr(sizeOfAllEllements, arr, fileWay);
		cout << "Cheack yout file.";
	}
	else
		cout << "ERROR in file.";
}


void workWithFile(string fileWay) {
	int sizeOfAllEllements = 0;
	double* arr;

	bool isIncorrect = readingProcess(fileWay, sizeOfAllEllements, arr);
	resoultOfReading(isIncorrect, sizeOfAllEllements, arr, fileWay);
}


bool fileIntegrityCheck(string fileWay) {
	bool isFileGood = false;

	fstream file;
	file.open(fileWay);

	if (file.is_open())
		isFileGood = true;

	file.clear();
	file.close();

	return isFileGood;
}


void intergrityResoult(bool isFileGood, string fileWay) {
	if (isFileGood)
		workWithFile(fileWay);
	else
		cout << "\nBad File.";
}


void viaFile() {
	fileRestrict();

	string fileWay = inputWay();
	bool isFileGood = fileIntegrityCheck(fileWay);
	intergrityResoult(isFileGood, fileWay);
}


/// main block
int main() {
	condition();

	int option = choosingAPath();

	option == FILE_NUM ? viaFile() : viaConsole();
	return 0;
}