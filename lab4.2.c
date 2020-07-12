#include <stdio.h>
#include <string.h>

long long var = 0;
char text[30];
int len;

int main()
{
  scanf("%s",text);
  len = strlen(text);

  asm(
  "xorq %rax,%rax \n"
  "movl len,%eax \n"
  "movq %rax,%r8 \n"
  "movq %r8,%r11 \n" //dlugosc do r11
  "xorq %rcx,%rcx \n"  //zerowanie rejestrow rcx rbx r10
  "xorq %rbx,%rbx \n"
  "xorq %r10,%r10 \n"
  "xorq %rsi,%rsi \n"
  "movq $7,%r12 \n"   //stala 7 do r12
 
  "wpiszliczbe: \n"
  "movq %r8,%r9 \n" //w r8 i r9 jest dlugosc

  "cmpq $1,%r9 \n" 
  "je potega0 \n"
  "cmpq $2,%r9 \n" 
  "je potega1 \n"

  "movq $7,%rax \n"

  "potega:\n"         //funkcja ma zaladowac do rax odpowiedni mnoznik dla danej pozycji 7^i
  "mulq %r12 \n"     //rax razy 7 i wynik w rax       
  "decq %r9 \n"
  "cmpq $2,%r9 \n"    
  "jg potega \n"      

  "pominpotegowanie: \n"
  
  "movb text(,%rsi,1),%bl \n"
  "subb $'0',%bl \n"  //zamienienie wczytanego znaku ascii na cyfre
  "mulq %rbx \n" //pomnozenie rax i rbx czyli wczytanego znaku wynik w rax wartosc*7^i
  "movq var,%r15 \n"
  "addq %rax,%r15 \n"  //liczba wczytana ostatecznie w rcx bylo
  "movq %r15,var \n"
  "incq %rsi \n"
  "decq %r8 \n"
  "cmpq %rsi,%r11 \n"
  "jg wpiszliczbe \n"

  "potega0:\n"
  "movq $1,%rax \n"
  "cmpq $0,%r8 \n"
  "jg pominpotegowanie \n"
  "jle koniec \n"

  "potega1: \n"
  "movq $7,%rax \n"
  "cmpq $0,%r8 \n"
  "jg pominpotegowanie \n"
  "koniec: \n"
  
  );
	
	printf("%lld",var);
}
