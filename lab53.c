#include <stdio.h>

extern double taylor(int index,double x);

int main()
{
	int index;
	double x;

	printf("podaj liczbe iteracji\n");
	scanf("%d",&index);
	printf("podaj x: (ln(1 + x))\n");
        scanf("%lf",&x);

	printf("wynik ln(1 + x) = %lf\n",taylor(index,x));
}
