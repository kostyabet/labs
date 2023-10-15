#include <iostream>
#include <fstream>
using namespace std;
const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int PALIN_OUTPUT_CONTROL = -1;


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
		cout << "Choose only " << CONS_NUM << " or " << FILE_NUM <<
		". Try again.\n";
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


void palinCondition(bool& isIncorrect, int& palindrome) {
	cin >> palindrome;
	if (cin.fail() || cin.get() != '\n') {
		cout << "Invalid numeric input.Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else
		isIncorrect = false;
}


int inputPalin() {
	bool isIncorrect = true;
	int palindrome;
	do {
		cout << "Write your number: ";
		palinCondition(isIncorrect, palindrome);
	} while (isIncorrect);

	return palindrome;
}


void conditionCheack(char sim, bool isCorrect, int& palindrome, int& n, int& k) {
	if (sim == '-' && !isCorrect)
		k = PALIN_OUTPUT_CONTROL;
	else if (sim < '0' || sim > '9')
		palindrome = PALIN_OUTPUT_CONTROL;
	else {
		palindrome += (sim - 48) * n;
		n *= 10;
	}
}


void cheackForOneString(bool isCorrect, int& palindrome) {
	if (!isCorrect)
		palindrome = PALIN_OUTPUT_CONTROL;
}


int inputPalinFile(fstream& file) {
	int palindrome = 0, n = 1, k = 1;
	char sim;
	bool isCorrect = false;
	while (file.get(sim) && palindrome != -1) {
		conditionCheack(sim, isCorrect, palindrome, n, k);
		isCorrect = true;
	}
	palindrome *= k;
	cheackForOneString(isCorrect, palindrome);

	return palindrome;
}


int lengthOfPalin(int palindrome) {
	int palinLen = 0;
	while (palindrome) {
		palinLen++;
		palindrome /= 10;
	}

	return palinLen;
}


void putInMassive(char*& arrPalin, int palindrome) {
	int i = 0;
	while (palindrome > 0) {
		arrPalin[i] = palindrome % 10;
		i++;
		palindrome = palindrome / 10;
	}
}


bool palinIsPalin(char*& arrPalin, int palinLen, int palindrome) {
	bool isCorrect = true;
	for (int i = 0; i < palinLen / 2; i++) {
		if (arrPalin[i] != arrPalin[palinLen - i - 1])
			isCorrect = false;
	}
	if (palindrome < 0)
		isCorrect = false;

	return isCorrect;
}


bool palinCheack(int palindrome) {
	int palinLen = lengthOfPalin(abs(palindrome));
	char* arrPalin = new char[palinLen];
	putInMassive(arrPalin, abs(palindrome));

	return palinIsPalin(arrPalin, palinLen, palindrome);
}


void viaConsole() {
	int palindrome = inputPalin();
	if (palinCheack(palindrome) && palindrome > -1)
		cout << "It is palindrome.";
	else
		cout << "It is not a palindrome.";
}


void outputPalin(int palindrome, fstream& file) {
	file.seekg(0, ios::end);
	if (palindrome == PALIN_OUTPUT_CONTROL)
		file << "\nERROR.";
	else if (palinCheack(palindrome))
		file << "\nIt is palindrome.";
	else if (palindrome != PALIN_OUTPUT_CONTROL)
		file << "\nIt is not a palindrome.";
}


void workWithFile(fstream& file) {
	if (file.is_open()) {
		int palindrome = inputPalinFile(file);
		file.clear();
		outputPalin(palindrome, file);
		cout << "Cheack your file.";
	}
	else
		cout << "Bad File.";
}


void viaFile() {
	string fileWay;
	cout << "Write way to your file: ";
	fileWay = inputWay();
	fstream file;
	file.open(fileWay);
	workWithFile(file);
	file.close();
}


int main() {
	std::cout << "The program determines whether\n\t"
		"the entered number is a palindrome.\n\n";
	std::cout << "Where will we work through: \n\tConsole: " << CONS_NUM <<
		"\tFile: " << FILE_NUM << "\n\n";
	int option = choosingAPath();

	option == FILE_NUM ? viaFile() : viaConsole();

	return 0;
}