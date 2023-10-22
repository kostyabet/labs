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
			int arrNumb = 3;
			double** arrOfNumb{ 
				new double* [4] { 
					new double [arrNumb] {1.0, 2.0, 3.0},
					new double [arrNumb] {2.0, 2.0, 3.0},
					new double [arrNumb] {3.0, 2.0, 3.0},
					new double [arrNumb] {1.0, 1.0, 1.0}
				} 
			};
			Assert::AreEqual(arrayFilling(arrOfNumb[0], arrNumb), true);
			Assert::AreEqual(arrayFilling(arrOfNumb[1], arrNumb), false);
			Assert::AreEqual(arrayFilling(arrOfNumb[2], arrNumb), false);
			Assert::AreEqual(arrayFilling(arrOfNumb[3], arrNumb), false);
		}
	};
}
