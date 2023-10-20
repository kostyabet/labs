// 4.	Проверить является ли данная числовая последовательность а1, a2,..., an  невозрастающей.
#include <iostream>
#include <string>
#include <fstream>
using namespace std;
const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int MIN_ARR_SIZE = 2;


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
	int num;
	bool isIncorrect = true;
	do {
		cout << "Your choice: ";
		pathCondition(num, isIncorrect);
	} while (isIncorrect);

	return num;
}


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


void restrictCheack(int element, int lastElement, bool& isConditionYes, int i) {
	if (element > lastElement && i > 0)
		isConditionYes = true;
	else if (i > 0)
		isConditionYes = false;
}


bool arrayFilling(int*& arrOfNumb, int arrNumb) {
	bool isConditionYes = true;
	for (int i = 0; i < arrNumb; i++) {
		arrOfNumb[i] = massiveElement(i);
		restrictCheack(arrOfNumb[i], arrOfNumb[i - 1], isConditionYes, i);
	}
	return isConditionYes;
}


int inputArrNumb(fstream& file) {
	int arrNumb = 0;
	bool isCorrect = true, isWhile = false;
	char ell;
	while (file.get(ell) && isCorrect && ell != '\n') {
		if (ell < '0' || ell > '9')
			isCorrect = false;
		arrNumb *= 10;
		arrNumb += ell - 48;
		isWhile = true;
	}

	if (arrNumb < MIN_ARR_SIZE && isCorrect && !isWhile) {
		file << "\tERROR.";
		file.clear();
		arrNumb = 0;
	}

	return arrNumb;
}


void workWithArr(int arrNumb, fstream& file) {
	int* arrOfNumb = new int[arrNumb];
	bool isCorrect = true, isConditionYes = true, whileTrue = true;
	char ell;
	int size = 0;
	for (int i = 0; i < arrNumb; i++) {
		arrOfNumb[i] = 0;
		whileTrue = true;

		while (isCorrect && whileTrue && file.get(ell)) {
			if ((ell < '0' || ell > '9') && ell != ' ')
				isCorrect = false;
			else if (ell != ' ') {
				arrOfNumb[i] = arrOfNumb[i] * 10 + ell;
				size++;
			}
			else
				whileTrue = false;
		}
		if (arrOfNumb[i] > arrOfNumb[i - 1] && i > 0 && isCorrect);
		else if (i > 0 && isCorrect)
			isConditionYes = false;
	}
	if (file.get(ell) || size != arrNumb)
		isCorrect = false;

	file.seekg(0, ios::end);
	file.clear();
	if (!isCorrect)
		file << "\nERROR.";
	else if (isConditionYes)
		file << "\nVozrost";
	else
		file << "\nNe vozroct";
}


void workWithFile(fstream& file) {
	if (file.is_open()) {
		int arrNumb = inputArrNumb(file);
		if (arrNumb != 0)
			workWithArr(arrNumb, file);
		cout << "Cheack your file.";
	}
	else
		cout << "Bad File.";
}


void viaConsole() {
	int arrNumb = numInMassive();
	int* arrOfNumb = new int[arrNumb];
	if (arrayFilling(arrOfNumb, arrNumb))
		cout << "Vozroct.";
	else
		cout << "Ne vozroct.";
}


void viaFile() {
	fileRestrict();
	string fileWay = inputWay();
	fstream file;
	file.open(fileWay);
	workWithFile(file);
	file.close();
}


int main() {
	cout << "The program calculates whether the entered\n\t"
		"natural number sequence is increasing.\n\n";
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";
	int option = choosingAPath();

	option == FILE_NUM ? viaFile() : viaConsole();
	return 0;
}