#include <iostream>
using namespace std;


int input(const int max, const int min) {
	int k;
	bool isIncorrect = true;
	do
	{
		cin >> k;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\n";
			cin.clear();
			cin.ignore();
		}
		else if (k < min || k > max)
			cout << "Number should be from " << min << " to " << max << ".\n";
		else
			isIncorrect = false;
	} while (isIncorrect);

	return k;
}


int sumOfDigits(int num) {
	int sum = 0;
	while (num) {
		sum += num % 10;
		num /= 10;
	}
	return sum;
}


bool cheackSum(int Sum, int k, int nutNumb) {
	return k * Sum == nutNumb;
}


void searchNum(const int max, int k) {
	int nutNumb = 1;
	while (nutNumb <= max) {
		int Sum = sumOfDigits(nutNumb);
		if (cheackSum(Sum, k, nutNumb))
			cout << nutNumb << " ";
		nutNumb++;
	}
}


int main()
{
	const int MAXN = 100000;
	const int MAXK = 10000;
	const int MINK = 3;

	cout << "The program finds all natural numbers that are k times the sum of their digits.\n";

	cout << "Write K number from " << MINK << " to " << MAXK << ":\n";
	int k = input(MAXK, MINK);

	searchNum(MAXN, k);
	return 0;
}