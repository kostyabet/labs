#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
	string str;
	cin >> str;
	for (int i = 0; i < str.length(); i++) {
		char s = str[i];
		if (islower(s))
			cout << "low";
	}
	return 0;
}