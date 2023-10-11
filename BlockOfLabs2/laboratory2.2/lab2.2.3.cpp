#include <iostream>
using namespace std;


const int MAX_N = 1000000;
const int MAX_K = 100000;
const int MIN_K = 1;


int input() {
	int k;
	bool isIncorrect = true;
	do
	{
		cin >> k;
		if (cin.fail() || cin.get() != '\n') {
			cout << "Invalid numeric input.\n";
			cin.clear();
			while (cin.get() != '\n');
		}
		else if (k < MIN_K || k > MAX_K)
			cout << "Number should be from " << MIN_K << " to " << MAX_K << ".\n";
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


bool checkSum(int Sum, int k, int nutNumb) {
	return k * Sum == nutNumb;
}


void searchNum(int k) {
	int nutNumb = k;
	while (nutNumb <= MAX_N) {
		int sum = sumOfDigits(nutNumb);
		if (checkSum(sum, k, nutNumb))
			cout << nutNumb << " ";
		nutNumb += k;
	}
}


int main()
{
	cout << "The program finds all natural numbers that are k times the sum of their digits.\n";

	cout << "Write K number from " << MIN_K << " to " << MAX_K << ":\n";
	int k = input();

	searchNum(k);
	return 0;
}