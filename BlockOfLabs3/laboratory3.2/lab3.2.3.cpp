#include <iostream>
#include <fstream> // for work with .txt file
#include <string> // for file way reading
#include <set> // for making the result
using namespace std;
const int MIN_FILE_WAY_SIZE = 5;
const int MIN_SIZE = 1;
const int GOOD_SIZE = 1;
const int BAD_SIZE = 2;
const int FILE_KEY = 1;
const int CONSOLE_KEY = 2;
const set<char> Entitlements =
{
	'0', '1', '2', '3', '4', '5', '6',
	'7', '8', '9', '+', '-', '=', '/'
};
// block of work with errors
enum IOError
{
	INVALID_PATH,
	METHOD_ERROR,
	SHORT_PATH_ERROR,
	TXT_ERROR,
	OPEN_FILE_ERROR,
	MIN_SIZE_ERROR,
	FIRST_STR_ERROR,
	EL_ERROR,
	TRY_AGAIN
};
const string ERRORS[]
{
	"Error. You should write a natural number.",
	"Error method.",
	"The path is too short.",
	"Write .txt file.",
	"Can't open a file.",
	"Min number of elements is " + to_string(MIN_SIZE) + ".",
	"First string is natural number.",
	"Enter a specific number of characters.",
	" Try again: "
};
void printError(string IOErrorMethod)
{
	cerr << IOErrorMethod << ERRORS[(int)IOError::TRY_AGAIN];
}
// block of text output
void taskOutput()
{
	cout << "the program builds and prints a set, the elements\n"
		"of which are the signs of arithmetic operations and\n"
		"numbers occurring in the sequence.\n\n";
}
void workWayConditionOutput()
{
	cout << "Where will we work through: \n\tFile: " << FILE_KEY <<
		"\n\tConsole: " << CONSOLE_KEY << endl << endl;
}
void fileRestriction()
{
	cout << "\n1.  The first line in the file is a natural number -\n"
		"N characters of the second line;\n"
		"2.  The second line is N characters entered by the user.\n"
		"Write way to your file: ";
}
// choice of direction
int choosingWorkWay()
{
	workWayConditionOutput();

	int path = 0;
	bool isIncorrect = true;
	cout << "Please write were we should work: ";
	do
	{
		cin >> path;
		if (cin.fail() || cin.get() != '\n')
		{
			printError(ERRORS[(int)IOError::INVALID_PATH]);
			cin.clear();
			while (cin.get() != '\n');
		}
		else
		{
			if (path == CONSOLE_KEY || path == FILE_KEY)
			{
				isIncorrect = false;
			}
			else
			{
				printError(ERRORS[(int)IOError::METHOD_ERROR]);
			}
		}
	} while (isIncorrect);

	return path;
}
// input and check path to the file
bool pathCondition(string way)
{
	if (way.size() < MIN_FILE_WAY_SIZE)
	{
		printError(ERRORS[(int)IOError::SHORT_PATH_ERROR]);
		return false;
	}
	string bufstr = way.substr(way.size() - 4);
	if (bufstr != ".txt")
	{
		printError(ERRORS[(int)IOError::TXT_ERROR]);
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
bool isCanOpenFile(string way, ios_base::openmode mode)
{
	fstream file(way, mode);
	file.close();

	return file.good();
}
string inputPathToTheFile()
{
	string fileWay;
	bool isIncorrect = true;

	do
	{
		fileWay = inputPath();
		if (!isCanOpenFile(fileWay, ios::in))
		{
			printError(ERRORS[(int)IOError::OPEN_FILE_ERROR]);
		}
		else
		{
			isIncorrect = false;
		}
	} while (isIncorrect);

	return fileWay;
}
/// input from console
bool checkSizeCondition(int size)
{
	if (cin.fail() || cin.get() != '\n')
	{
		printError(ERRORS[(int)IOError::INVALID_PATH]);
		cin.clear();
		while (cin.get() != '\n');
	}
	else if (size < MIN_SIZE)
	{
		printError(ERRORS[(int)IOError::MIN_SIZE_ERROR]);
	}
	else
	{
		return false;
	}

	return true;
}
int inputSizeFromConsole()
{
	int size;
	bool isIncorrect;

	cout << "How many characters do you want to enter: ";
	do
	{
		cin >> size;
		isIncorrect = checkSizeCondition(size);
	} while (isIncorrect);

	return size;
}
bool isCorrectElementsInputFromConsole()
{
	if (cin.peek() != '\n')
	{
		printError(ERRORS[(int)IOError::EL_ERROR]);
		cin.clear();
		cin.ignore(numeric_limits<streamsize>::max(), '\n');
	}
	else
	{
		return false;
	}

	return true;
}
char* inputStringFromConsole(int*& arrSize)
{
	bool isIncorrect;
	int size = inputSizeFromConsole();
	char* arrOfElements = new char[size];
	arrSize[0] = size;

	cout << "Write your " << size << " elements: ";
	do
	{
		for (int i = 0; i < size; i++)
		{
			cin >> arrOfElements[i];
		}
		isIncorrect = isCorrectElementsInputFromConsole();
	} while (isIncorrect);

	return arrOfElements;
}
// input from file
int checkSizeInputFromFile(ifstream& file, int size)
{
	if (file.fail())
	{
		printError(ERRORS[(int)IOError::FIRST_STR_ERROR]);
		return BAD_SIZE;
	}
	else if (size < MIN_SIZE)
	{
		printError(ERRORS[(int)IOError::MIN_SIZE_ERROR]);
		return BAD_SIZE;
	}

	return GOOD_SIZE;
}
int inputSizeFromFile(ifstream& file, int& arrSize)
{
	int size;
	file >> size;
	arrSize = checkSizeInputFromFile(file, size);

	return size;
}
bool isCorrectElInputFromFile(int i, int size)
{
	if (i != size)
	{
		printError(ERRORS[(int)IOError::EL_ERROR]);
		return true;
	}

	return false;
}
bool inputSetFromFile(char*& arrOfElements, int size, ifstream& file)
{
	char counter;
	int i = 0;
	while (file.get(counter))
	{
		if (counter != '\n')
		{
			if (i <= size)
			{
				arrOfElements[i] = counter;
			}
			i++;
		}
	}

	return isCorrectElInputFromFile(i, size);
}
char* inputStringFromFile(int*& arrSize)
{
	fileRestriction();
	char* arrOfElements = new char[0];
	bool isIncorrect = true;
	do
	{
		string fileWay = inputPathToTheFile();
		ifstream file(fileWay, ios::in);
		arrSize[0] = inputSizeFromFile(file, arrSize[1]);
		if (arrSize[1]) {
			arrOfElements = new char[arrSize[0]];
			isIncorrect = inputSetFromFile(arrOfElements, arrSize[0], file);
		}
		file.close();
	} while (isIncorrect);

	return arrOfElements;
}
// making the set
void renderingSet(char* arrOfElements, int size, set<char>& resultSet)
{
	for (int i = 0; i < size; i++)
	{
		for (char current : Entitlements)
		{
			if (arrOfElements[i] == current)
			{
				resultSet.insert(arrOfElements[i]);
			}
		}
	}
}
// output from file
void outputSetInFile(set<char> resultSet, ofstream& file)
{
	for (auto currentElement : resultSet)
	{
		file << " '" << currentElement << "';";
	}
}
void outputResInFile(set<char> resultSet, string fileWay)
{
	ofstream file(fileWay, ios::out);

	file << "The result is:";
	if (resultSet.empty())
	{
		file << " empty set.";
	}
	else
	{
		outputSetInFile(resultSet, file);
	}

	file.close();
}
void outputFromFile(set<char> resultSet)
{
	bool isIncorrect = true;
	cout << "Write way to your file: ";
	do
	{
		string fileWay = inputPathToTheFile();
		if (isCanOpenFile(fileWay, ios::out))
		{
			outputResInFile(resultSet, fileWay);
			cout << "Check your file.";
			isIncorrect = false;
		}
		else
		{
			printError(ERRORS[(int)IOError::OPEN_FILE_ERROR]);
		}
	} while (isIncorrect);
}
// output from console
void outputSetFromConsole(set<char> resultSet)
{
	for (auto currentElement : resultSet)
	{
		cout << " '" << currentElement << "';";
	}
}
void outputFromConsole(set<char> resultSet)
{
	cout << "The result is:";
	if (resultSet.empty())
	{
		cout << " empty set.";
	}
	else
	{
		outputSetFromConsole(resultSet);
	}
}
// distributive output
void resultOutputSystem(set<char> resultSet)
{
	cout << "\nYou need to choose where to write information from.\n";
	int path = choosingWorkWay();
	path == CONSOLE_KEY ? outputFromConsole(resultSet)
		: outputFromFile(resultSet);

}
// main distributive func
char* inputSystem(int*& arrSize)
{
	int path = choosingWorkWay();
	return path == CONSOLE_KEY ? inputStringFromConsole(arrSize)
		: inputStringFromFile(arrSize);
}
// cleaning func
void clearMemory(int*& arrSize, char*& arrOfElements, set<char> resultSet)
{
	arrOfElements = nullptr;

	delete[] arrSize;
	arrSize = nullptr;

	resultSet.clear();
}
//main
int main()
{
	taskOutput();

	int* arrSize = new int[2];
	char* arrOfElements = inputSystem(arrSize);

	set<char> resultSet;
	renderingSet(arrOfElements, arrSize[0], resultSet);

	resultOutputSystem(resultSet);

	clearMemory(arrSize, arrOfElements, resultSet);

	return 0;
}