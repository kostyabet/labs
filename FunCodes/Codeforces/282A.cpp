#include <iostream>
#include <string>
int main() {
	int n, x = 0;
	std::cin >> n;
	while (n--) {
		std::string str;
		std::cin >> str;
		if (str.size() == 3 && (str[0] == 'X' || str[2] == 'X') && str[1] == '-')
			x--;
		else if (str.size() == 3 && (str[0] == 'X' || str[2] == 'X') && str[1] == '+')
			x++;
	}
	std::cout << x;
	return 0;
}