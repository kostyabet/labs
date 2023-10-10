#include <iostream>
#include <string> // for write palindrom and way to the file
#include <fstream> // for work with files
using namespace std;


string CinPalindrome() {
	string palindrom;
	bool isCorrect = true;
	do {
		cin >> palindrom;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else
			isCorrect = false;
	} while (isCorrect);

	return palindrom;
}


string inputWay() {
	string palindrom;
	bool isInCorrect = true;
	do {
		cin >> palindrom;
		if (palindrom.size() > 4) {
			string bufstr = palindrom.substr(palindrom.size() - 4, palindrom.size() - 1);
			if (bufstr == ".txt")
				return palindrom;
			else
				cout << "Write .txt file";
		}
		else
			cout << "short string";
	} while (isInCorrect);

	return palindrom;
}


int choosingAPath(const int Console, const int File) {
	cout << "Your choice: ";
	int num;
	bool isCorrect = true;
	do {
		cin >> num;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else if (num != Console && num != File)
			cout << "Choose only 1 or 2.\n";
		else
			isCorrect = false;
	} while (isCorrect);

	return num;
}


bool isPalindrom(string palindrom) {
	for (int i = 0; i < palindrom.size() / 2; i++) {
		if (palindrom[i] != palindrom[palindrom.size() - (i + 1)])
			return false;
	}

	return true;
}


string workWithPalin(string palindrom) {
	if (isPalindrom(palindrom))
		return "palindrom(" + palindrom + ").";
	else
		return "not a palindrom(" + palindrom + ").";
}


string viaConsole() {
	cout << "Write your string: ";
	string palindrom = CinPalindrome();
	if (isPalindrom(palindrom))
		return "palindrom";
	else
		return "not a palindrom";
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
	const int FILENUM = 1;
	const int CONSNUM = 0;

	std::cout << "The program determines whether\n\t the entered string is a palindrome.\n\n";
	std::cout << "Where will we work through: \n\tConsole: " << CONSNUM << "\tFile: " << FILENUM << "\n\n";
	int option = choosingAPath(CONSNUM, FILENUM);

	string resoult = (option ? viaFile() : viaConsole());
	cout << "It is " << resoult << "\n";

	return 0;
}