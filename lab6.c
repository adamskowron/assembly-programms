#include <stdio.h>
#include <stdlib.h>

extern void wektor(short* tab1,short* tab2,short* tab3,int lenght);
extern int startpomiar();
extern int koniecpomiar(int start);

int main()
{


	const int len = 100;
	short tab1[len];
	short tab2[len];
	short tab3[len];
	short tab4[len];

	for(int i=0;i<len;i++)
	{
	tab1[i] = rand() % 50;
	tab2[i] = rand() % 50;
	}
	int start1 = startpomiar();

	wektor(tab1,tab2,tab3,len/4);

	printf("pomiar wynosi: %d\n",koniecpomiar(start1));

	for(int i=0;i<len;i++)
	{
	printf("wynik asm = %d\n",*(tab3+i));
	}

	printf("--------------------------------------------\n");

	int start2 = startpomiar();

	for(int i=0;i<len;i++)
	{
	tab4[i] = tab1[i] + tab2[i];
	tab4[i] *= 2;
	printf("wynik c = %d\n",*(tab4+i));
	}

	printf("pomiar wynosi: %d\n",koniecpomiar(start2));

	return 0;
}
