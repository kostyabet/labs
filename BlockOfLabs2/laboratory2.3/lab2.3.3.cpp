#include <iostream>
#include <fstream>
using namespace std;
const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int PALIN_OUTPUT_CONTROL = -1;


void printStatement() {
	cout << "The program determines whether\n\t"
		<< "the entered natural number is a palindrome.\n\n";
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
	cout << "Write way to your file: ";
	string way;
	bool isIncorrect = true;
	do {
		cin >> way;
		wayCondition(way, isIncorrect);
	} while (isIncorrect);

	return way;
}


int pathCondition(bool& isIncorrect) {
	int num = 0;
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
	return num;
}


int choosingAPath() {
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";
	int result;
	bool isIncorrect = true;
	do {
		cout << "Your choice: ";
		result = pathCondition(isIncorrect);
	} while (isIncorrect);

	return result;
}


void palinCondition(bool& isIncorrect, int& palindrome) {
	cin >> palindrome;
	if (cin.fail() || cin.get() != '\n') {
		cout << "Invalid numeric input.Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (palindrome < 1)
		cout << "Number should be natural.\n";
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


int inputPalinFile(fstream& file) {
	int palindrome = 0;
	file >> palindrome;
	if (file.fail()) {
		cout << "Bad number in file.";
		palindrome = -1;
		file.clear();
	}

	char sim;
	if (palindrome < 0) {
		cout << "Number should be > 0.";
		palindrome = -1;
	}
	else if (file.get(sim) && sim != ' ' && sim != '\n') {
		palindrome = -1;
		cout << "Should be only one num.";
	}


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


void putInMassive(int*& arrPalin, int palindrome) {
	int i = 0;
	while (palindrome) {
		arrPalin[i] = palindrome % 10;
		i++;
		palindrome = palindrome / 10;
	}
}


bool palinIsPalin(int*& arrPalin, int palinLen, int palindrome) {
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
	int palinLen = lengthOfPalin(palindrome);
	int* arrPalin = new int[palinLen];
	putInMassive(arrPalin, palindrome);

	bool result = palinIsPalin(arrPalin, palinLen, palindrome);

	delete[] arrPalin;
	arrPalin = nullptr;

	return result;
}


int viaConsole() {
	int palindrome = inputPalin();
	if (palinCheack(palindrome) && palindrome > PALIN_OUTPUT_CONTROL)
		return 1;
	else
		return 0;
}


int outputPalin(int palindrome) {
	if (palindrome == PALIN_OUTPUT_CONTROL) {
		cout << "ERROR.";
		return -1;
	}
	else if (palinCheack(palindrome))
		return 1;
	else if (palindrome != PALIN_OUTPUT_CONTROL)
		return 0;
}


int workWithFile(fstream& file) {
	if (file.is_open()) {
		int palindrome = inputPalinFile(file);
		return outputPalin(palindrome);
	}
	else {
		cout << "Bad File.";
		return -1;
	}
}


int viaFile() {
	string fileWay;
	fileWay = inputWay();
	fstream file;
	file.open(fileWay);
	int result = workWithFile(file);
	file.clear();
	file.close();

	return result;
}


void outputViaConsole(int result) {
	if (result)
		cout << "Palindrome.";
	else
		cout << "Not a palidrome.";
}


string fileCorrectOutput(int result) {
	if (result)
		return "\nPalindrome.";
	else
		return "\nNot a palindrome.";
}


void outputViaFile(int result) {
	string fileWay = inputWay();
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


void output(int option, int result) {
	if (result != -1) {
		cout << "\n\nYou need to choose where to output the result.\n";
		option = choosingAPath();

		option == FILE_NUM ? outputViaFile(result) : outputViaConsole(result);
	}
}


int main() {
	printStatement();
	int option = choosingAPath();

	int result = option == FILE_NUM ? viaFile() : viaConsole();

	output(option, result);

	return 0;
}