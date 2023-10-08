package lab2;

import java.util.Scanner;

public class lab2 {
    static int input(final int max,final int min, Scanner in) {
        int k = 0;
        boolean isIncorrect = true;
        do {
            try {
                k = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException error) {
                System.err.print("Invalid numeric input.\n");
            }
            if (k < min || k > max)
                System.out.printf("Number should be from %d to %d.\n", min, max);
            else
                isIncorrect = false;
        } while (isIncorrect);
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


    static void searchNum(final int max, int k) {
        int nutNumb = k;
        while (nutNumb <= max){
            int Sum = sumOfDigits(nutNumb);
            if(checkSum(Sum, k, nutNumb)) {
                System.out.printf("%d ", nutNumb);
            }
            nutNumb += k;
        }
    }


    public static void main(String[] args) {
        final int MAXN = 1000000;
        final int MAXK = 100000;
        final int MINK = 3;

        Scanner in = new Scanner(System.in);

        System.out.print("The program finds all natural numbers that are k times the sum of their digits.\n");

        System.out.printf("Write K number from %d to %d:\n", MINK, MAXK);
        int k = input(MAXK, MINK, in);

        in.close();

        searchNum(MAXN, k);
    }
}