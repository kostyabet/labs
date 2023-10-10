#include <iostream>
#include <string> // for write palindrom and way to the file
#include <fstream> // for work with files
using namespace std;


string CinPalindrome() {
	string str;
	bool isCorrect = true;
	do {
		cin >> str;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else
			isCorrect = false;
	} while (isCorrect);

	return str;
}


string CinPalindromeTxt() {
	string str = "";
	getline(cin, str);
	cout << endl << str << endl;
	return str;
}


string CinTxt() {
	string str;
	bool isInCorrect = true;
	do {
		cin >> str;
		if (str.size() > 4) {
			string bufstr = str.substr(str.size() - 4, str.size() - 1);
			if (bufstr == ".txt")
				return str;
			else
				cout << "Write .txt file";
		}
		else
			cout << "short string";
	} while (isInCorrect);

	return str;
}


int CinN() {
	cout << "Your varient is: ";
	int num;
	bool isCorrect = true;
	do {
		cin >> num;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else if (num != 0 && num != 1)
			cout << "choose only 1 or 2.\n";
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


string WorkWithTxt(string str) {
	if (isPalindrom(str))
		return "palindrom";
	else
		return "not a palindrom";
}


string ConsoleWork() {
	cout << "\nWrite your string: ";
	string palindrom = CinPalindrome();
	if (isPalindrom(palindrom))
		return "palindrom";
	else
		return "not a palindrom";
}


string FileWork() {
	string fileway;
	bool isCorrect = true;
	do {
		cout << "Write way to your file: ";
		fileway = CinTxt();
		ifstream file;
		file.open(fileway);
		if (file.is_open()) {
			string str;
			getline(file, str);
			return WorkWithTxt(str);
		}
		else
			cout << "Bad File. Try again.\n";
		file.close();
	} while (isCorrect);
}

int main() {
	const int File = 1;
	const int Console = 0;
	std::cout << "What will you choose: \n\tConsole: " << Console << "\tFile: " << File << "\n\n";
	int n = CinN();

	string resoult;
	if (n)
		resoult = FileWork();
	else
		resoult = ConsoleWork();

	cout << "It is " << resoult;

	return 0;
}