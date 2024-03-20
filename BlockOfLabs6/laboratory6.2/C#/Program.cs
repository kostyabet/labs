using System;
using System.Collections.Specialized;
using System.Reflection.Metadata;
using System.Runtime.CompilerServices;

namespace Proj6_2 {
    class Combinator {
        static int MAX_SIZE = 10;
        static int MIN_SIZE = 1;
        static int MAX_INT = +1_000_000;
        static int MIN_INT = -1_000_000;

        static int InputNumber(ref int MAX, ref int MIN){
            int val = 0;
            bool isCorrect;
            do {
                try {
                    val = Convert.ToInt32(Console.ReadLine());
                    isCorrect = true;
                } catch {
                    isCorrect = false;
                }
                isCorrect = isCorrect && !(val > MAX || val < MIN);
                if (!isCorrect) Console.Write("Error! Try again: ");
            } while (!isCorrect);
            return val;
        }
        static void InputMatrixSize(out int m, out int n) {
            Console.WriteLine("Input your matrix size (m x n)");
            Console.Write("M: ");
            m = InputNumber(ref MAX_SIZE, ref MIN_SIZE);
            Console.Write("N: ");
            n = InputNumber(ref MAX_SIZE, ref MIN_SIZE);
        }
        static void ChangeMatrixSize(ref int[][] matrix, int m, int n) {
            matrix = new int[m][];
            for (int i = 0; i < matrix.Length; i++)
                matrix[i] = new int[n];
        }
        static void InputMatrixElements(ref int[][] matrix) {
            Console.WriteLine("Input matrix elements.");
            for (int i = 0; i < matrix.Length; i++)
                for (int j = 0; j < matrix[i].Length; j++){
                    Console.Write($"Write arr[{i};{j}]: ");
                    matrix[i][j] = InputNumber(ref MAX_INT, ref MIN_INT);
                }
        }
        static void InputProcess(ref int[][] matrix)
        {
            InputMatrixSize(out int m, out int n);
            ChangeMatrixSize(ref matrix, m, n);
            InputMatrixElements(ref matrix);
        }
        static void SearchLongestWayInMatrix(ref int[][] matrix)
        {
            int f[0][0] = matrix[0][0];
            for (int i = 0; i < n; i++)
                for (int j = 0; j < n; j++)
                {
                    if (i + 1 < n - 1)
                        f[i + 1][j] += max(f[i][j] + matrix[i + 1][j], f[i + 1][j]);
                    if (i - 1 >= 0)
                        f[i - 1][j] += max(f[i][j] + matrix[i - 1][j], f[i - 1][j]);
                    if (j + 1 < m - 1)
                        f[i][j + 1] += max(f[i][j] + matrix[i][j + 1], f[i][j + 1]);
                    if (j - 1 >= 0)
                        f[i][j - 1] += max(f[i][j] + matrix[i][j - 1], f[i][j - 1]);
                }
            // ans ---- in f[n][n]
        }
        public static void Main(String[] args) {
            int[][] matrix = new int [0][];
            InputProcess(ref matrix);
            SearchLongestWayInMatrix(ref matrix);
        }
    }
}