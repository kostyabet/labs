#include <iostream>
#include <string> // for write palindrom and way to the file
#include <fstream> // for work with files
using namespace std;


string inputWay() {
	string way;
	bool isInCorrect = true;
	do {
		cin >> way;
		if (way.size() > 4) {
			string bufstr = way.substr(way.size() - 4, way.size() - 1);
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


int choosingAPath(const int CONSOLE, const int FILE) {
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
		else if (num != CONSOLE && num != FILE)
			cout << "Choose only " << CONSOLE << " or " << FILE << ". Try again.\n";
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
		return "palindrome";
	else
		return "not a palindrome";
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
			string palindrome;
			getline(file, palindrome);
			return workWithPalin(palindrome);
		}
		else
			cout << "Bad File. Try again.\n";
		file.close();
	} while (isIncorrect);
}


int main() {
	const int CONSNUM = 1;
	const int FILENUM = 2;

	std::cout << "The program determines whether\n\t the entered string is a palindrome.\n\n";
	std::cout << "Where will we work through: \n\tConsole: " << CONSNUM << "\tFile: " << FILENUM << "\n\n";
	int option = choosingAPath(CONSNUM, FILENUM);

	string result = (option == FILENUM ? viaFile() : viaConsole());
	cout << "It is " << result << "\n";

	return 0;
}