#include <iostream>
#include <string>
using namespace std;


int CinPalindrome() {
	int num;
	bool isCorrect = true;
	do {
		std::cin >> num;
		if (cin.fail() || cin.get() != '\n') {
			std::cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else
			isCorrect = false;
	} while (isCorrect);

	return num;
}


int CinN() {
	int num;
	bool isCorrect = true;
	do {
		std::cin >> num;
		if (cin.fail() || cin.get() != '\n') {
			std::cout << "Invalid numeric input.\nTry again.\n";
			cin.clear();
			cin.ignore(30000, '\n');
		}
		else if (num != 0 && num != 1)
			std::cout << "choose only 1 or 2.\n";
		else
			isCorrect = false;
	} while (isCorrect);

	return num;
}


int PalinSize(int n) {
	int size = 0;
	while (n) {
		size++;
		n /= 10;
	}

	return size;
}


bool isPalindrom(int palindrom) {
	int size = PalinSize(palindrom);


}


string ConsoleWork() {
	cout << "\nWrite your number: ";
	int palindrom = CinPalindrome();
	if (isPalindrom(palindrom))
		return "Palindrom";
	else
		return "Not a palindrom";
}


int main() {
	const int File = 1;
	const int Console = 0;
	std::cout << "What will you choose: \n\tConsole: " << Console << "\tFile: " << File << "\n\n";
	int n = CinN();

	string resoult;
	if (n) {}
	//resoult = FileWork();
	else
		resoult = ConsoleWork();

	cout << "Your number is " << resoult;
	return 0;
}