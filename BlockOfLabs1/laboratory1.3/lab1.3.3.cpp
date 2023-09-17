#include <iostream>
#include <iomanip>

int main()
{
	const double MinEPS = 0;
	const double MaxEPS = 0.1;
	double EPS = MaxEPS, X = 0;
	double Y = 0;
	double Y0 = 1;
	int Number = 0;
	int Сoefficient = 1;
	bool IsCorrectX = false, IsCorrectEPS = false;
	std::cout << std::setprecision(3) << std::fixed;
	std::cout << "  The program calculates the value of the cube root \n"
		<< "from the number X entered by a person.\n"
		<< "With accuracy up to the number EPS entered by the user.\n\n"
		<< "Restrictions X: No restrictions.\n"
		<< "Restrictions EPS: (0; 0.1).\n\n\n";
	do
	{
		IsCorrectX = false;
		std::cout << "Write the cube root of which number you want to find?\n";
		std::cin >> X;
		if (std::cin.get() != '\n')
		{
			std::cout << "X entered incorrectly.\n";
			IsCorrectX = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
	} while (IsCorrectX);
	do {
		IsCorrectEPS = false;
		std::cout << "With what EPS must the calculations be made?\n";
		std::cin >> EPS;
		if (std::cin.get() != '\n')
		{
			std::cout << "EPS entered incorrectly.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		else if (EPS > MaxEPS)
		{
			std::cout << "EPS is too high. EPS must be less than 0.1.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		else if (EPS == MaxEPS)
		{
			std::cout << "EPS must be less than 0.1.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		else if (EPS < MinEPS)
		{
			std::cout << "EPS cannot be less than 0.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		else if (EPS == MinEPS)
		{
			std::cout << "EPS entered incorrectly.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}

	} while (IsCorrectEPS);
	std::cout << "\n\nYour X: " << X << "\nYour EPS: " << EPS;
	if (X < 0)
	{
		Сoefficient = -1;
		X = -X;
	}
	if (X == 0)
	{
		Y = X;
		Number = 1;
	}
	else
	{
		Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
		Number++;
		if (abs(Y - Y0) > EPS)
		{
			Y0 = Y;
			Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
			Number++;
			while (abs(Y - Y0) > EPS)
			{
				Y0 = Y;
				Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
				Number++;
			}
		}
	}
	std::cout << "\nCube root of " << X << " = " << Сoefficient * Y;
	std::cout << "\nNumber of operations for which accuracy was achieved - " << Number;
	std::cout << "\n\n";
	return 0;
}