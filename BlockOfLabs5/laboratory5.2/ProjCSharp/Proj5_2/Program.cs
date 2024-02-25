namespace Proj5_2
{
    class Program
    {
        const int MAX_INT = 1_000_000;
        const int MIN_INT = -MAX_INT;
        static void OutputCondition()
        {
            Console.WriteLine("");
        }

        static int InputNum()
        {
            int num = 0;
            bool isCorrect;
            do
            {
                isCorrect = true;
                try
                {
                    num = Convert.ToInt32(Console.ReadLine());
                    if (num > MAX_INT || num < MIN_INT)
                        throw new Exception("Num out of range");
                }
                catch
                {
                    Console.Write("Error! Try again: ");
                    isCorrect = false;
                }
            } while (!isCorrect);

            return num;
        }

        public static void Main()
        {
            Console.Write("Write numbers ob branches: ");
            int numOfBranches = InputNum();
            
        }
    }
}