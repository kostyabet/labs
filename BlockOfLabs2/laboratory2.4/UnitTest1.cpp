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
			double** arrOfNumb{ 
				new double* [4] { 
					new double [arrSize] {0.0, 0.0, 0.0},
					new double [arrSize] {0.000010, 0.000011, 0.000009},
					new double [arrSize] {-12345, -12344, -12343},
					new double [arrSize] {1e+10, 1e+10 + 1, 1e+10 + 2}
				} 
			};
			Assert::AreEqual(isArrIncreasing(arrOfNumb[0], arrSize), false);
			Assert::AreEqual(isArrIncreasing(arrOfNumb[1], arrSize), false);
			Assert::AreEqual(isArrIncreasing(arrOfNumb[2], arrSize), true);
			Assert::AreEqual(isArrIncreasing(arrOfNumb[3], arrSize), true);
		}
	};
}