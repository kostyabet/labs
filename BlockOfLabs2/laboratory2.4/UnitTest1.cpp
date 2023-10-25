#include "pch.h"
#include "CppUnitTest.h"
#include "..\..\lab4.cpp"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{
	TEST_CLASS(UnitTest1)
	{
	public:
		
		TEST_METHOD(TestMethod1)
		{
			int arrSize = 3;
			double* arrOfNumb = new double[0.0, 0.0, 0.0];

			Assert::AreEqual(isArrIncreasing(arrOfNumb, arrSize), false);
		}

		TEST_METHOD(TestMethod2)
		{
			int arrSize = 3;
			double* arrOfNumb = new double[0.000010, 0.000011, 0.000009];
			
			Assert::AreEqual(isArrIncreasing(arrOfNumb, arrSize), false);
		}

		TEST_METHOD(TestMethod3)
		{
			int arrSize = 3;
			double* arrOfNumb = new double[1E+1 + 1,1E+1 + 2,1E+1 - 1];

			Assert::AreEqual(isArrIncreasing(arrOfNumb, arrSize), false);
		}
	};
}