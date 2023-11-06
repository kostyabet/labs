// метод простых вставок
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

const int FILE_KEY = 1;
const int CONSOLE_KEY = 2;
const int MIN_ARR_SIZE = 1;
const int MIN_FILE_WAY_SIZE = 5;

void conditionOutput()
{
	cout << "The program is designed to sort an array\n\t"
		"using the simple insertion method.\n\n";
}

void pathConditionOutput()
{
	cout << "Where will we work through: \n\tFile: " <<
		FILE_KEY << " Console: " << CONSOLE_KEY << endl << endl;
}

void fileRestriction()
{
	cout << "\n*The first number is the number of elements \n"
		"of the array, and subsequent numbers of this array*\n";
}

int choosingAPath()
{
	int path = 0;
	bool isIncorrect = true;

	pathConditionOutput();

	do
	{
		cout << "Please write were we should work: ";
		cin >> path;

		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Error. You should write a one natural number. Try again.\n";
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

/// input from console
int arrSizeInputFromConsole()
{
	int arrSize;
	bool isIncorrect = true;

	cout << "Write your arr size: ";
	do
	{
		cin >> arrSize;
		if (cin.fail() || cin.get() != '\n')
		{
			cout << "Invalid numeric input. Try again: ";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (arrSize < MIN_ARR_SIZE)
			cout << "Minimal arr size is: " << MIN_ARR_SIZE << ". Try again: ";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return arrSize;
}

int inputCurrentNumbFromConsole()
{
	int currentNumb;
	bool isIncorrect = true;
	do
	{
		cin >> currentNumb;
		if (cin.fail() || cin.get() != '\n')
		{
			cout << "Invalid numeric input. Try again: ";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
			isIncorrect = false;
	} while (isIncorrect);

	return currentNumb;
}

void arrOfNumbInputFromConsole(int arrSize, int*& arrOfNumb)
{
	for (int i = 0; i < arrSize; i++)
	{
		cout << "Write your " << i + 1 << " number: ";
		arrOfNumb[i] = inputCurrentNumbFromConsole();
	}
}

/// input from file
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, mode);
	file.close();
	return file.good();
}

bool wayCondition(string way)
{
	if (way.size() < MIN_FILE_WAY_SIZE)
	{
		cerr << "The path is too short. Try again: ";
		return false;
	}
	string bufstr = way.substr(way.size() - 4);
	if (bufstr != ".txt")
	{
		cerr << "Write .txt file. Try again: ";
		return false;
	}
	return true;
}

string inputWayToTheFile()
{
	string way;
	bool isIncorrect;
	do
	{
		cin >> way;
		isIncorrect = !wayCondition(way);
	} while (isIncorrect);
	return way;
}


string inputFile()
{
	string fileWay;
	bool isIncorrect = true;
	do
	{
		bool isCorrect = true;
		fileWay = inputWayToTheFile();
		if (!isCanOpenFile(fileWay, ios::in))
			cout << "Can't open a file. Try write another way: ";
		else
			isIncorrect = false;
	} while (isIncorrect);
	return fileWay;
}

bool arrSizeInputFromFile(ifstream& file, int arrSize)
{
	bool isIncorrect = true;
	if (file.fail() || file.get() != '\n')
		cout << "Error in input size of massive. Try again: ";
	else if (arrSize < MIN_ARR_SIZE)
		cout << "Minimal arr size is " << MIN_ARR_SIZE << ". Try again: ";
	else
		isIncorrect = false;

	return isIncorrect;
}

bool isIncorrectInputCurrentNumbFromFile(ifstream& file)
{
	bool isIncorrect = false;
	if (file.fail())
		isIncorrect = true;

	return isIncorrect;
}

bool isIncorrectArrOfNumbInputFromFile(ifstream& file, int*& arrOfNumb, int arrSize)
{
	bool isIncorrect = false;
	for (int i = 0; i < arrSize; i++)
	{
		file >> arrOfNumb[i];
		isIncorrect = isIncorrectInputCurrentNumbFromFile(file);
	}

	return isIncorrect;
}

/// result calc.. 
void sortMassive(int*& arrOfNumb, int arrSize)
{
	int temp; // временная переменная для хранения значения элемента сортируемого массива

	for (int i = 1; i < arrSize; i++)
	{
		temp = arrOfNumb[i]; // инициализируем временную переменную текущим значением элемента массива

		int j = i - 1; // запоминаем индекс предыдущего элемента массива
		while (j >= 0 && arrOfNumb[j] > temp) // пока индекс не равен 0 и предыдущий элемент массива больше текущего
		{
			arrOfNumb[j + 1] = arrOfNumb[j]; // перестановка элементов массива
			arrOfNumb[j] = temp;
			j--;
		}
	}
}

/// output from file
void outputFromFile(int* arrOfNumb, int arrSize)
{
	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputWayToTheFile();
		if (isCanOpenFile(fileWay, ios::out))
		{
			ofstream file(fileWay, ios::out);
			for (int i = 0; i < arrSize; i++)
				file << arrOfNumb[i] << " ";
			cout << "Check your file.";
			file.close();
			isIncorrect = false;
		}
		else
			cerr << "Can't open a file. Try write another way: ";
	} while (isIncorrect);
}

/// output from console
void outputFromConsole(int* arrOfNumb, int arrSize)
{
	for (int i = 0; i < arrSize; i++)
		cout << arrOfNumb[i] << " ";
}

/// output
void resultOutput(int* arrOfNumb, int arrSize)
{
	cout << "You need to choose where to write information from.\n";
	int path = choosingAPath();
	path == CONSOLE_KEY ? outputFromConsole(arrOfNumb, arrSize) : outputFromFile(arrOfNumb, arrSize);
}

int main() {
	int arrSize = 0;
	int* arrOfNumb = new int[0];

	conditionOutput();

	cout << "\nYou need to choose where to read information from.\n";

	int path = choosingAPath();
	if (path == CONSOLE_KEY) {
		arrSize = arrSizeInputFromConsole();

		arrOfNumb = new int[arrSize];
		arrOfNumbInputFromConsole(arrSize, arrOfNumb);
	}
	else {
		bool isIncorrect = true;
		fileRestriction();
		cout << "Write way to your file: ";
		do
		{
			string fileWay = inputFile();
			ifstream file(fileWay, ios::in);
			file >> arrSize;
			isIncorrect = arrSizeInputFromFile(file, arrSize);
			if (!isIncorrect) {
				arrOfNumb = new int[arrSize];
				isIncorrect = isIncorrectArrOfNumbInputFromFile(file, arrOfNumb, arrSize);
			}
			if (isIncorrect)
				cout << "Invalid massive elements input. Try again: ";
			file.close();
		} while (isIncorrect);
	}

	sortMassive(arrOfNumb, arrSize);

	resultOutput(arrOfNumb, arrSize);

	delete[] arrOfNumb;
	arrOfNumb = nullptr;

	return 0;
}