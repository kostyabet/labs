#include <iostream>
#include <string>
#include <fstream>
using namespace std;
const int FILE_KEY = 1;
const int MIN_ARR_SIZE = 1;
const int CONSOLE_KEY = 2;
const int MIN_FILE_WAY_SIZE = 5;



/// text blocks
void conditionOutput()
{
	cout << "The program is designed to sort an array\n\tusing the simple insertion method.\n\n";
}
void pathConditionOutput()
{
	cout << "Where will we work through:\n\tFile: " << FILE_KEY << " Console: " << CONSOLE_KEY << endl << endl;
}
void fileRestriction()
{
	cout << "\n*The first number is the number of elements\nof the array, and subsequent numbers of this array*\n";
}



/// is can open
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, mode);
	file.close();
	return file.good();
}



/// input way of work
int choosingAPath()
{
	int path = 0;
	bool isIncorrect = true;

	pathConditionOutput();
	cout << "Please write were we should work: ";
	do
	{
		cin >> path;

		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Error. You should write a one natural number. Try again: ";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
		{
			if (path == CONSOLE_KEY || path == FILE_KEY)
				isIncorrect = false;
			else cerr << "Error method. Try again: ";
		}
	} while (isIncorrect);

	return path;
}



/// input way to the file
bool pathCondition(string way)
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
string inputPath()
{
	string way;
	bool isIncorrect;
	do
	{
		cin >> way;
		isIncorrect = !pathCondition(way);
	} while (isIncorrect);
	return way;
}
string inputPathToTheFile()
{
	string fileWay;
	bool isIncorrect = true;
	do
	{
		bool isCorrect = true;
		fileWay = inputPath();
		if (!isCanOpenFile(fileWay, ios::in))
			cout << "Can't open a file. Try write another way: ";
		else
			isIncorrect = false;
	} while (isIncorrect);
	return fileWay;
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
			cout << "Minimal arr size is: " << MIN_ARR_SIZE <<
			". Try again: ";
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
bool isCorrectArrOfNumbInputFromConsole(int arrSize, int*& arrOfNumb)
{
	for (int i = 0; i < arrSize; i++)
	{
		cout << "Write your " << i + 1 << " number: ";
		arrOfNumb[i] = inputCurrentNumbFromConsole();
	}

	return false;
}



/// input from file
int arrSizeInputFromFile(string fileWay)
{
	int arrSize;
	ifstream file(fileWay, ios::in);
	file >> arrSize;

	if (file.fail() || file.get() != '\n')
	{
		cout << "Error in input size of massive. Try again: ";
		arrSize = -1;
	}
	else if (arrSize < MIN_ARR_SIZE)
	{
		cout << "Minimal arr size is " << MIN_ARR_SIZE << ". Try again: ";
		arrSize = -1;
	}

	file.close();

	return arrSize;
}
bool isIncorrectArrOfNumbInputFromFile(int arrSize, int*& arrOfNumb, string fileWay)
{
	if (arrSize == -1)
		return true;

	ifstream file(fileWay, ios::in);
	for (int i = 0; i < arrSize; i++)
	{
		file >> arrOfNumb[i];
		if (file.fail())
		{
			file.close();
			cout << "Error in reading massive elements. Try again: ";
			return true;
		}
	}
	file.close();


	return false;
}



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



/// output block
void outputFromFile(int* arrOfNumb, int arrSize)
{
	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputPath();
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
void outputFromConsole(int* arrOfNumb, int arrSize)
{
	for (int i = 0; i < arrSize; i++)
		cout << arrOfNumb[i] << " ";
}
void resultOutput(int* arrOfNumb, int arrSize)
{
	cout << "You need to choose where to write information from.\n";
	int path = choosingAPath();

	path == FILE_KEY ? outputFromFile(arrOfNumb, arrSize) : outputFromConsole(arrOfNumb, arrSize);
}



int arrSizeInput(int path, string fileWay) {
	return path == FILE_KEY ? arrSizeInputFromFile(fileWay) : arrSizeInputFromConsole();
}

bool inputArrOfNumb(int arrSize, int*& arrOfNumb, int path, string fileWay) {
	return path == FILE_KEY ? isIncorrectArrOfNumbInputFromFile(arrSize, arrOfNumb, fileWay) : isCorrectArrOfNumbInputFromConsole(arrSize, arrOfNumb);
}

int main() {
	int arrSize;
	int* arrOfNumb;

	conditionOutput();

	cout << "\nYou need to choose where to read information from.\n";
	int path = choosingAPath();

	bool isIncorrect;
	do {
		string fileWay = path == FILE_KEY ? inputPathToTheFile() : "";

		arrSize = arrSizeInput(path, fileWay);
		arrOfNumb = new int[arrSize];
		isIncorrect = inputArrOfNumb(arrSize, arrOfNumb, path, fileWay);
	} while (isIncorrect);

	sortMassive(arrOfNumb, arrSize);

	resultOutput(arrOfNumb, arrSize);

	delete[] arrOfNumb;
	arrOfNumb = nullptr;

	return 0;
}