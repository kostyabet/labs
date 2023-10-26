#include <iostream>
#include <string>
#include <fstream>


using namespace std;


const int CONS_NUM = 1;
const int FILE_NUM = 2;
const int MIN_ARR_SIZE = 2;


void printStatement()
{
	cout << "The program calculates whether the entered\n\t"
		"natural number sequence is increasing.\n\n";
}


// work with way to the file
int pathСheck(bool& isIncorrect)
{
	int path;
	cin >> path;

	if (cin.fail() || cin.get() != '\n')
	{
		cerr << "Invalid numeric input. Try again.\n";
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (path != CONS_NUM && path != FILE_NUM)
		cerr << "Choose only " << CONS_NUM << " or "
		<< FILE_NUM << ". Try again.\n";
	else
		isIncorrect = false;

	return path;
}


int choosingAPath()
{
	cout << "Where will we work through: \n\tConsole: "
		<< CONS_NUM << "\tFile: " << FILE_NUM << "\n\n";

	int path;
	bool isIncorrect = true;
	do
	{
		cout << "Your choice: ";
		path = pathСheck(isIncorrect);
	} while (isIncorrect);

	return path;
}


// block of conditon check
bool isArrIncreasing(double*& arrOfNumb, int arrSize)
{
	for (int i = 1; i < arrSize; i++) {
		if (!(arrOfNumb[i] <= arrOfNumb[i - 1])) {
			return false;
		}
	}

	return true;
}


int resultOfArrChecking(bool isIncrease)
{
	if (isIncrease)
		return 1;
	else
		return 0;
}


/// work in console
int inputArrSize()
{
	bool isIncorrect = true;
	int arrSize;

	do
	{
		cout << "How much number in massive: ";
		cin >> arrSize;

		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Invalid numeric input. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (arrSize < MIN_ARR_SIZE)
			cerr << "Min num is " << MIN_ARR_SIZE << ". Try again.\n";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return arrSize;
}


double enteringTheCurrentNumber(int i)
{
	bool isIncorrect = true;
	double currentNum;

	do
	{
		cout << "Write your " << i + 1 << " number: ";
		cin >> currentNum;

		if (cin.fail() || cin.get() != '\n')
		{
			cerr << "Invalid numeric input. Try again.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else
			isIncorrect = false;
	} while (isIncorrect);

	return currentNum;
}


void inputArr(double*& arrOfNumb, int arrSize)
{
	for (int i = 0; i < arrSize; i++)
		arrOfNumb[i] = enteringTheCurrentNumber(i);
}


double viaConsole(double*& arrOfNumb)
{
	int arrSize = inputArrSize();

	inputArr(arrOfNumb, arrSize);

	return arrSize;
}


/// work with file
void fileRestriction()
{
	cout << "\nRules for storing information in a file:\n\t"
		"1.  The first line contains an integer: \n\t\t"
		"the number of array elements;\n\t"
		"2.  The second line is real number\n\t\t"
		"entered separated by spaces.\n\n";
}


void wayCondition(string way, bool& isIncorrect)
{
	if (way.size() > 4)
	{
		string bufstr = way.substr(way.size() - 4);
		if (bufstr == ".txt")
			isIncorrect = false;
		else
			cerr << "Write .txt file.\n";
	}
	else
		cerr << "The path is too short.\n";
}


string inputWayToTheFile()
{
	string way;
	bool isIncorrect = true;

	cout << "Write way to your file: ";
	do
	{
		cin >> way;

		wayCondition(way, isIncorrect);
	} while (isIncorrect);

	return way;
}


bool isFileIntegrity(string fileWay)
{
	bool isIntegrity = false;

	fstream file;
	file.open(fileWay);

	if (file.is_open())
		isIntegrity = true;

	file.clear();
	file.close();

	return isIntegrity;
}


int resultOfReading(bool isCorrect, int arrSize, double*& arrOfNumb)
{
	if (isCorrect) {
		arrOfNumb = NULL;
		return arrSize;
	}
	else {
		cerr << "ERROR in file.";

		return -1;
	}
}


int isCorrectInputFromFile(ifstream& file, int& arrSize, double*& arrOfNumb)
{
	bool isCorrect = true;
	file >> arrSize;
	if (file.fail() || file.get() != '\n')
		isCorrect = false;

	if (arrSize < MIN_ARR_SIZE && isCorrect)
		isCorrect = false;

	if (isCorrect) {
		arrOfNumb = new double[arrSize];
		for (int i = 0; i < arrSize; i++)
		{
			file >> arrOfNumb[i];
			if (file.fail())
				isCorrect = false;
		}
	}

	if (!file.eof() && isCorrect)
		isCorrect = false;

	return resultOfReading(isCorrect, arrSize, arrOfNumb);
}


int isReadingCorrect(string fileWay, int arrSize, double*& arrOfNumb)
{
	ifstream file(fileWay, ios::in);

	int result = isCorrectInputFromFile(file, arrSize, arrOfNumb);

	file.clear();
	file.close();

	return result;
}


int workWithFile(string fileWay, double*& arrOfNumb)
{
	int arrSize = 0;

	int result = isReadingCorrect(fileWay, arrSize, arrOfNumb);

	return result;
}


int workWithIntergrityResoult(bool isIntegrity, string fileWay, double*& arrOfNumb)
{
	if (isIntegrity)
		return workWithFile(fileWay, arrOfNumb);
	else
	{
		cerr << "Bad File.";

		return -1;
	}
}


int viaFile(double*& arrOfNumb)
{
	fileRestriction();

	string fileWay = inputWayToTheFile();
	bool isIntegrity = isFileIntegrity(fileWay);

	return workWithIntergrityResoult(isIntegrity, fileWay, arrOfNumb);
}


/// output console
void outputViaConsole(int result)
{
	if (result)
		cout << "Increase.";
	else
		cout << "Uncreased.";
}


/// output file
string fileCorrectOutput(int result)
{
	if (result)
		return "\nIncrease.";
	else
		return "\nUncreased.";
}


void outputViaFile(int result)
{
	string fileWay = inputWayToTheFile();
	ofstream file(fileWay, ios::app);

	if (file.is_open())
	{
		file << fileCorrectOutput(result);
		cout << "Check your file.";
	}
	else
		cerr << "\nBad output file.";

	file.clear();
	file.close();
}


/// output
void output(int result)
{
	if (result != -1)
	{
		cout << "\n\nYou need to choose where to output the result.\n";
		int option = choosingAPath();

		option == FILE_NUM ? outputViaFile(result) : outputViaConsole(result);
	}
}


/// main block
int main()
{
	printStatement();

	int option = choosingAPath();
	double* arrOfNumb;
	int arrSize = option == FILE_NUM ? viaFile(arrOfNumb) : viaConsole(arrOfNumb);

	if (arrOfNumb != NULL) {
		bool isIncreasing = isArrIncreasing(arrOfNumb, arrSize);
		int result = resultOfArrChecking(isIncreasing);
		output(result);
	}

	delete[] arrOfNumb;
	arrOfNumb = nullptr;
	return 0;
}