#include <iostream>
#include <Windows.h>

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	int numberInMassive = 0;
	double sumNumb = 0.0;
	bool isCorrect = false;

	printf("  The program calculates the sum of all odd elements entered by the user.\n"
		"*Please note that the numbering of the entered numbers starts from zero.*\n\n"
		"Restrictions: The number of all elements is an integer;\n"
		"              Numbers can be any: both integers and reals.\n\n");

	do
	{
		printf("How many numbers will you write?\n");
		std::cin >> numberInMassive;
		if (std::cin.get() != '\n')
		{
			std::cin.clear();
			std::cin.ignore(30000, '\n');
			printf("Number entered incorrectly. Try again.\n");
		}
		else if (numberInMassive < 1)
		{
			std::cout << "Number should be > 0. Try again.\n";
		}
		else
		{
			isCorrect = true;
		}
	} while (!isCorrect);

	double* arrayOfNumbers = new double[numberInMassive];

	do
	{
		isCorrect = true;
		for (int i = 0; i < numberInMassive; i++)
		{
			printf("Write your %d number.\n", i + 1);
			std::cin >> arrayOfNumbers[i];
			if (std::cin.get() != '\n')
			{
				std::cin.clear();
				std::cin.ignore(35000, '\n');
				isCorrect = false;
				printf("Number entered incorrectly. Try again.\n");
			}
		}
	} while (!isCorrect);

	for (int i = 1; i < numberInMassive; i = i + 2) {
		sumNumb = sumNumb + arrayOfNumbers[i];
	}
	delete[] arrayOfNumbers;
	arrayOfNumbers = nullptr;
	printf("\nSum of all odd numbers - %.3f", sumNumb);
	return 0;
}