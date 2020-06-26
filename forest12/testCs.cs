using System;
using System.Collections.Generic;
using System.Text;

namespace ReadLine
{
    class Program
    {
        static void Main(string[] args)
        {
            string Name, sAge;
            int Age;
            Console.Write("이름을 입력하세요: ");
            Name = Console.ReadLine();
            Console.WriteLine(Name);

            Console.Write("나이를 입력하세요: ");
            sAge = Console.ReadLine();
            Age = Convert.ToInt32(sAge);

            //Age = int.Parse(sAge);    // 위의 라인과 동일한 효과
            Console.WriteLine(Age);
        }
    }
}