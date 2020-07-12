#include <stdio.h>

extern void zmien(int);

int main()
{
	int wybor;
	
	
	printf("1 - Invalid operation exception mask\n2 - Denormal operand exception mask\n3 - Zero divide exception mask\n4 - overflow exception mask\n5 - Underflow exception mask\n6 - Prec- - Precision exception mask\n");
	scanf("%d",&wybor);
	if(wybor == 1)
	{
	zmien(1);
	}
	else if(wybor == 2)
	{
	zmien(2);
	}
	else if(wybor == 3)
        {
        zmien(3);
        }
	else if(wybor == 4)
        {
        zmien(4);
        }
	else if(wybor == 5)
        {
        zmien(5);
        }
	else if(wybor == 6)
	{
	zmien(6);
	}
	else
	{
	printf("zla wartosc");
	}
	
}
