#include <stdio.h>
#include <string.h>

extern int oblicz(char* str,int len);

char text[50];

int main()
{
	scanf("%s",text);
	printf("%d",oblicz(text,strlen(text)));

	return 0;
}
