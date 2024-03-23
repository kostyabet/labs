#include <iostream>
#include <string>

int main() {
    int m, n;
    std::cin >> m >> n;
    int** inputArr = new int* [m];
    int counter = 0;
    for (int i = 0; i < m; ++i) {
        inputArr[i] = new int[n];
        for (int j = 0; j < n; ++j) {
            std::cin >> inputArr[i][j];
            if (inputArr[i][j] > counter) counter = inputArr[i][j];
        }
    }
    
    int** numbersInfoArr = new int* [counter];
    int** tempNumbersInfo = new int* [counter];
    for (int i = 0; i < counter; i++)
    {
        numbersInfoArr[i] = new int[2];
        numbersInfoArr[i][0] = 0;
        numbersInfoArr[i][1] = 0;
        tempNumbersInfo[i] = new int[2];
        tempNumbersInfo[i][0] = 0;
        tempNumbersInfo[i][1] = 0;
        // 0 - vert sum
        // 1 - griz sum
    }

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            tempNumbersInfo[inputArr[i][j] - 1][0] = 1;
            tempNumbersInfo[inputArr[i][j] - 1][1]++;
        }
        for (int j = 0; j < counter; ++j) {
            numbersInfoArr[j][0] += tempNumbersInfo[j][0];
            if (numbersInfoArr[j][1] == 0) numbersInfoArr[j][1] = tempNumbersInfo[j][1];
            tempNumbersInfo[j][0] = 0;
            tempNumbersInfo[j][1] = 0;
        }
    }
    
    int** resArr = new int*[counter];
    for (int i = 0; i < counter; i++) {
        resArr[i] = new int[5];
        resArr[i][0] = 0; // 0 - number of block
        resArr[i][1] = 0; // 1 - rows count
        resArr[i][2] = 0; // 2 - cols count
        resArr[i][3] = 0; // 3 - left coord
        resArr[i][4] = 0; // 4 - right coord
    }

    // first block
    resArr[0][0] = 1;
    resArr[0][1] = 4;
    resArr[0][2] = 5;

    std::string resStr = "";
    int pointsCount = 0;
    int curMax = 1;
    for (int i = 0; i < counter; ++i) {

    }

    return 0;
}