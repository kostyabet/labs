// Найти все натуральные числа, которые в k раз больше суммы своих цифр.
#include <iostream>

const int MAXN = 100000, MAXK = 10000, MINK = 3;

void condition()
{
	std::cout << "The program finds all natural numbers that are k times the sum of their digits.\n"
		<< "*Natural numbers are taken only in the range from 1 to 100000*\n\n"
		<< "Restrictions:\n\t- K is a number from 3 to 10000;\n\n";
}

void Cheackingloop(int& k, bool& isCorrect)
{
	if (std::cin.get() != '\n')
	{
		std::cin.clear();
		std::cin.ignore(30000, '\n');
		std::cout << "Error. Try again.\n";
		isCorrect = true;
	}
	else if (k < MINK || k > MAXK)
	{
		std::cout << "Number should be N. Try again.\n";
		isCorrect = true;
	}
	else
		isCorrect = false;
}

void SumOfNumbers(int buffer, int& Sum)
{
	while (buffer > 1)
	{
		Sum += buffer % 10;
		buffer = buffer / 10;
	}
}

void MainConst(int k, int number, int& Sum)
{

	if (k * Sum == number)
	{
		std::cout << number << " ";
	}
	else
		Sum = 0;
}

void numbers(bool isCorrect, int k, int Sum, int number, int buffer)
{
	while (number < MAXN)
	{
		buffer = number;
		SumOfNumbers(buffer, Sum);
		MainConst(k, number, Sum);
		number += 1;
	}
}

int main()
{
	int k, sum, natNumb, buffer;
	bool isIncorrect;
	k = 0;
	buffer = 0;
	sum = 0;
	natNumb = 1;
	isIncorrect = true;

	condition();

	do
	{
		std::cout << "Enter K:\n";
		std::cin >> k;
		Cheackingloop(k, isIncorrect);
	} while (isIncorrect);

	numbers(isIncorrect, k, sum, natNumb, buffer);

	return 0;
}