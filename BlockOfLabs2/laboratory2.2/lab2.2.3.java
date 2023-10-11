package lab2;

import java.util.Scanner;

public class lab2 {
    static final int MAX_N = 1000000;
    static final int MAX_K = 100000;
    static final int MIN_K = 1;


    static int input() {
        Scanner in = new Scanner(System.in);
        int k = 0;
        boolean isIncorrect = true;
        do {
            try {
                k = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException error) {
                System.err.print("Invalid numeric input.\n");
            }
            if (k < MIN_K || k > MAX_K)
                System.err.printf("Number should be from %d to %d.\n", MIN_K, MAX_K);
            else
                isIncorrect = false;
        } while (isIncorrect);
        in.close();

        return k;
    }


    static int sumOfDigits(int num) {
        int sum = 0;
        while (num >= 1) {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }


    static boolean checkSum(int Sum, int k, int nutNumb) {
        return k * Sum == nutNumb;
    }


    static void searchNum(int k) {
        int nutNumb = k;
        while (nutNumb <= MAX_N){
            int Sum = sumOfDigits(nutNumb);
            if(checkSum(Sum, k, nutNumb)) {
                System.out.printf("%d ", nutNumb);
            }
            nutNumb += k;
        }
    }


    public static void main(String[] args) {
        System.out.print("The program finds all natural numbers that are k times the sum of their digits.\n");

        System.out.printf("Write K number from %d to %d:\n", MIN_K, MAX_K);
        int k = input();

        searchNum(k);
    }
}