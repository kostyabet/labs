#include <iostream>
#include <set> // for work with set
using namespace std;
const int MIN_SIZE = 1;
const int MAX_SIZE = 4000000;
const int FILE_KEY = 1;
const int CONSOLE_KEY = 2;
void taskOutput() {
	cout << "...\n\n";
}
void pathConditionOutput() {
	cout << "Where will we work through: \n\tFile: " <<
		FILE_KEY << " Console: " << CONSOLE_KEY << endl << endl;
}
void sizeConditionOutput() {
	cout << "How much ellements do you write: ";
}
int choosingAPath()
{
	pathConditionOutput();
	int path = 0;
	bool isIncorrect = true;
	do
	{
		cout << "Please write were we should work: ";
		cin >> path;
		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Error. You should write a number. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
		{
			if (path == CONSOLE_KEY || path == FILE_KEY)
				isIncorrect = false;
			else cerr << "Error method. Try again.\n";
		}
	} while (isIncorrect);
	return path;
}
int inputSizeSystem() {
	int size;
	sizeConditionOutput();
	bool isIncorrect = true;
	do {
		cin >> size;
		if (cin.fail() || cin.get() != '\n') {
			cout << "";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (size < MIN_SIZE || size > MAX_SIZE)
			cout << "Number should be from " << MIN_SIZE << " to " << MAX_SIZE;
		else
			isIncorrect = false;
	} while (isIncorrect);

	return size;
}
set<char> inputSetSystem(int size) {
	set<char> setOfElements;
	char currentEllement;
	cout << "Write your simbols: ";
	for (int i = 0; i < size; i++) {
		cin >> currentEllement;
		setOfElements.insert(currentEllement);
	}
	return setOfElements;
}
set<char> renderingSet(set<char> setOfElements) {
	set<char> newSet;
	for (char currentEllement : setOfElements) {
		if (!(currentEllement >= '0' && currentEllement <= '9')) {
			newSet.insert(currentEllement);
		}
	}
	return newSet;
}
void resultOutputSystem(set<char> newSet) {
	cout << "The result is: ";
	if (!newSet.empty())
		for (auto currentEllement : newSet)
			cout << currentEllement << "  ";
	else
		cout << "\nYour result is empty set.";
}
int main() {
	taskOutput();
	int path = choosingAPath();
	set<char> setOfElements;
	if (path == FILE_KEY) {

	}
	else {
		int size = inputSizeSystem();
		setOfElements = inputSetSystem(size);
	}
	set<char> newSet = renderingSet(setOfElements);
	resultOutputSystem(newSet);
	return 0;
}