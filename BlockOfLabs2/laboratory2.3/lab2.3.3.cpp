#include <iostream>
#include <string> // for write palindrom and way to the file
#include <fstream> // for work with files
using namespace std;
const int CONS_NUM = 1;
const int FILE_NUM = 2;


string inputWay() {
	string way;
	bool isInCorrect = true;
	do {
		cin >> way;
		if (way.size() > 4) {
			string bufstr = way.substr(way.size() - 4);
			if (bufstr == ".txt")
				return way;
			else
				cout << "Write .txt file.\n";
		}
		else
			cout << "The path is too short.\n";
	} while (isInCorrect);

	return way;
}


int choosingAPath() {
	cout << "Your choice: ";
	int num;
	bool isIncorrect = true;
	do {
		cin >> num;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input. Try again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else if (num != CONS_NUM && num != FILE_NUM)
			cout << "Choose only " << CONS_NUM << " or " << FILE_NUM << ". Try again.\n";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return num;
}


bool isPalindrome(string palindrome) {
	for (int i = 0; i < palindrome.size() / 2; i++) {
		if (palindrome[i] != palindrome[palindrome.size() - (i + 1)])
			return false;
	}

	return true;
}


string workWithPalin(string palindrome) {
	if (isPalindrome(palindrome))
		return "palindrome(" + palindrome + ").";
	else
		return "not a palindrome(" + palindrome + ").";
}


string viaConsole() {
	cout << "Write your string: ";
	string palindrome;
	std::cin >> palindrome;
	if (isPalindrome(palindrome))
		return "palindrome.";
	else
		return "not a palindrome.";
}


string viaFile() {
	string fileWay;
	bool isIncorrect = true;
	do {
		cout << "Write way to your file: ";
		fileWay = inputWay();
		ifstream file;
		file.open(fileWay);
		if (file.is_open()) {
			string palindrome, nextStr;
			getline(file, palindrome);
			if (getline(file, nextStr))
				cout << "File should be only with one string.\n";
			else
				return workWithPalin(palindrome);
		}
		else
			cout << "Bad File. Try again.\n";
		file.close();
	} while (isIncorrect);
}


int main() {
	std::cout << "The program determines whether\n\t the entered string is a palindrome.\n\n";
	std::cout << "Where will we work through: \n\tConsole: " << CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";
	int option = choosingAPath();

	string result = (option == FILE_NUM ? viaFile() : viaConsole());
	cout << "It is " << result << "\n";

	return 0;
}