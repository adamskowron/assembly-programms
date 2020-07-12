movq len,%r8   #dlugosc ciagu do r8
  movq len,%r11  #dlugosc do r11
  xorq %rcx,%rcx   #zerowanie rejestrow rcx rbx r10
  xorq %rbx,%rbx 
  xorq %r10,%r10 
  xorq %rsi,%rsi 
  movq $7,%r12    #stala 7 do r12
 
  wpiszliczbe: 
  movq %r8,%r9  #w r8 i r9 jest dlugosc

  cmpq $1,%r9  
  je potega0 
  cmpq $2,%r9  
  je potega1 

  movq $7,%rax 

  potega:         #funkcja ma zaladowac do rax odpowiedni mnoznik dla danej pozycji 10^i
  mulq %r12      #rax razy 10 i wynik w rax       
  decq %r9 
  cmpq $2,%r9     
  jg potega       

  pominpotegowanie: 

  movb text(,%rsi,1),%bl 
  subb $'0',%bl   #zamienienie wczytanego znaku ascii na cyfre
  mulq %rbx  #pomnozenie rax i rbx czyli wczytanego znaku wynik w rax wartosc*10^i
  addq %rax,var   #liczba wczytana ostatecznie w rcx bylo %0
  incq %rsi 
  decq %r8 
  cmpq %rsi,%r11 
  jg wpiszliczbe 

  potega0:
  movq $1,%rax 
  jmp pominpotegowanie 

  potega1: 
  movq $7,%rax 
  jmp pominpotegowanie 
