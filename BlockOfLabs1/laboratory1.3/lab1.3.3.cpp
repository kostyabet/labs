#include <iostream>
#include <iomanip>

int main()
{
	const double MinEPS = 0; // minimum EPS
	const double MaxEPS = 0.1; // maximum EPS
	double EPS = MaxEPS, X = 0; 
	double Y = 0; // current element 
	double Y0 = 1; // previous element
	int Number = 0; // operation counter
	int Сoefficient = 1; // stores the sign of the entered X
	bool IsCorrectX = false, IsCorrectEPS = false;

	// formatted output
	std::cout << std::setprecision(3) << std::fixed;

	// condition
	std::cout << "  The program calculates the value of the cube root \n"
		<< "from the number X entered by a person.\n"
		<< "With accuracy up to the number EPS entered by the user.\n\n"
		<< "Restrictions X: No restrictions.\n"
		<< "Restrictions EPS: (0; 0.1).\n\n\n";
		
	do
	{
		IsCorrectX = false;
		// input X
		std::cout << "Write the cube root of which number you want to find?\n";
		std::cin >> X;
		// X check
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
		// EPS input
		std::cout << "With what EPS must the calculations be made?\n";
		std::cin >> EPS;
		// EPS check
		// for EPS more than 0.1
		if (EPS > MaxEPS)
		{
			// error
			std::cout << "EPS is too high. EPS must be less than 0.1.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		// EPS = 0.1
		if (EPS == MaxEPS)
		{
			// error
			std::cout << "EPS must be less than 0.1.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		// for EPS less than 0
		else if (EPS < MinEPS)
		{
			// error
			std::cout << "EPS cannot be less than 0.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		// for EPS = 0 
		else if (EPS == MinEPS) 
		{
			// error
			std::cout << "EPS cannot be 0.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
		// special case
		else if (std::cin.get() != '\n')
		{
			// error
			std::cout << "EPS entered incorrectly.\n";
			IsCorrectEPS = true;
			std::cin.clear();
			while (std::cin.get() != '\n') {}
		}
	} while (IsCorrectEPS);

	// display current information about EPS and X
	std::cout << "\n\nYour X: " << X << "\nYour EPS: " << EPS;

	// checking the sign
	if (X < 0)
	{
		// change of sign 
		Сoefficient = -1;
		X = -X;
	}

	// conclusion
	if (X == 0)
	{
		// at X = 0
		Y = X;
		Number = 1;
	}
	// for numbers from -1 to 1, except zero
	else if (X < 1)
	{
		// first operation 
		Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
		Number++;
		// checking for the possibility of the next operation
		if (Y0 - Y > EPS)
		{
			Y0 = Y;
			Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
			Number++;
			// since the difference between A and A0 is small, 
			// then you can do a complete search of all the remaining numbers
			while (Y0 - Y > EPS)
			{
				Y0 = Y;
				Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
				Number++;
			}
		}
	}
	// for all numbers except the range from -1 to 1
	else
	{
		// first operation 
		Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
		Number++;
		// checking for the possibility of the next operation
		if (Y - Y0 > EPS)
		{
			Y0 = Y;
			Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
			Number++;
			// since the difference between A and A0 is small,
			// then you can do a complete search of all the remaining numbers
			while (Y0 - Y > EPS)
			{
				Y0 = Y;
				Y = ((Y0 * 2) + (X / (Y0 * Y0))) / 3;
				Number++;
			}
		}
	}

	// output of final information
	// cube root output
	std::cout << "\nCube root of " << X << " = " << Сoefficient * Y;
	// number of operations to achieve accuracy
	std::cout << "\nNumber of operations for which accuracy was achieved - " << Number;
	std::cout << "\n\n";
	return 0;
}