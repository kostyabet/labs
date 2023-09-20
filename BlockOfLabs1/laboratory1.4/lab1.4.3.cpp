#include <iostream>
#include <Windows.h>

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	int numberInMassive = 0;
	double sumNumb = 0;
	bool isCorrect = false;
	
	printf("  The program calculates the sum of all odd elements entered by the user.\n"
		   "*Please note that the numbering of the entered numbers starts from zero.*\n\n"
		   "Restrictions: The number of all elements is an integer;\n"
		   "              Numbers can be any : both integers and reals.\n\n");
	
	do
	{
		isCorrect = true;
		printf("How many numbers will you write?\n");
		std::cin >> numberInMassive;
		if (std::cin.get() != '\n')
		{
			isCorrect = false;
			std::cin.clear();
			std::cin.ignore(30000, '\n');
			printf("Number entered incorrectly.\n");
		}
	} while (!isCorrect);

	double* arr = new double[numberInMassive];
	isCorrect = false;

	bool IsCorrectCin = true;
	do 
	{
		isCorrect = true;
		IsCorrectCin = true;
		for (int i = 0; i < numberInMassive; i++) 
		{
			if (IsCorrectCin)
			{
				printf("Write your %d number.\n", i + 1);
				std::cin >> arr[i];
				if (std::cin.get() != '\n')
				{
					std::cin.clear();
					std::cin.ignore(35000, '\n');
					isCorrect = false;
					printf("Number entered incorrectly.\n");
					IsCorrectCin = false;
				}
			}
		}
	} while (!isCorrect);

	for (int i = 1; i < numberInMassive; i = i + 2) {
		sumNumb = sumNumb + arr[i];
	}
	delete[] arr;
	arr = nullptr;
	printf("\nSum of all odd numbers - %.3f", sumNumb);
	return 0;
}
