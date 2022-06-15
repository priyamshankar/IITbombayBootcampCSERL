
_my_siblings:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#define MAX_SZ 1000

int main(int argc, const char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 24             	sub    $0x24,%esp
  14:	8b 79 04             	mov    0x4(%ecx),%edi
	int n;
	n = atoi(argv[1]);
  17:	ff 77 04             	push   0x4(%edi)
  1a:	e8 4e 02 00 00       	call   26d <atoi>
  1f:	89 c6                	mov    %eax,%esi
	int procType[n];
  21:	8d 04 85 0f 00 00 00 	lea    0xf(,%eax,4),%eax
  28:	83 e0 f0             	and    $0xfffffff0,%eax
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	29 c4                	sub    %eax,%esp
  30:	89 65 e4             	mov    %esp,-0x1c(%ebp)
	int pids[n];
  33:	29 c4                	sub    %eax,%esp
  35:	89 65 e0             	mov    %esp,-0x20(%ebp)
	int pid = getpid();
  38:	e8 14 03 00 00       	call   351 <getpid>
  3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i;
	// Set the Process types
	for(i=0; i<n; i++)
  40:	bb 00 00 00 00       	mov    $0x0,%ebx
  45:	eb 18                	jmp    5f <main+0x5f>
	{
		procType[i] = atoi(argv[i+2]);
  47:	83 ec 0c             	sub    $0xc,%esp
  4a:	ff 74 9f 08          	push   0x8(%edi,%ebx,4)
  4e:	e8 1a 02 00 00       	call   26d <atoi>
  53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  56:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
	for(i=0; i<n; i++)
  59:	83 c3 01             	add    $0x1,%ebx
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	39 f3                	cmp    %esi,%ebx
  61:	7c e4                	jl     47 <main+0x47>
	}
	// Execute the children programmes
	for(i=0;i<n;i++)
  63:	bb 00 00 00 00       	mov    $0x0,%ebx
  68:	8b 7d e0             	mov    -0x20(%ebp),%edi
  6b:	eb 43                	jmp    b0 <main+0xb0>
	{
		int ret;
		ret = fork();
		if(ret == 0)
		{
			if(procType[i] == 0)
  6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  70:	8b 04 98             	mov    (%eax,%ebx,4),%eax
  73:	85 c0                	test   %eax,%eax
  75:	74 0a                	je     81 <main+0x81>
			{
				sleep(10000);
			}
			else if (procType[i] == 1)
  77:	83 f8 01             	cmp    $0x1,%eax
  7a:	74 17                	je     93 <main+0x93>
			{
				while(1){}
			}
			exit();
  7c:	e8 50 02 00 00       	call   2d1 <exit>
				sleep(10000);
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	68 10 27 00 00       	push   $0x2710
  89:	e8 d3 02 00 00       	call   361 <sleep>
  8e:	83 c4 10             	add    $0x10,%esp
  91:	eb e9                	jmp    7c <main+0x7c>
				while(1){}
  93:	eb fe                	jmp    93 <main+0x93>
		}
		else if(ret>0) pids[i] = ret;

	printf(1,"ppid is %d\n",getppid());
  95:	e8 e7 02 00 00       	call   381 <getppid>
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	50                   	push   %eax
  9e:	68 44 07 00 00       	push   $0x744
  a3:	6a 01                	push   $0x1
  a5:	e8 ec 03 00 00       	call   496 <printf>
	for(i=0;i<n;i++)
  aa:	83 c3 01             	add    $0x1,%ebx
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	39 f3                	cmp    %esi,%ebx
  b2:	7d 10                	jge    c4 <main+0xc4>
		ret = fork();
  b4:	e8 10 02 00 00       	call   2c9 <fork>
		if(ret == 0)
  b9:	85 c0                	test   %eax,%eax
  bb:	74 b0                	je     6d <main+0x6d>
		else if(ret>0) pids[i] = ret;
  bd:	7e d6                	jle    95 <main+0x95>
  bf:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
  c2:	eb d1                	jmp    95 <main+0x95>

	}

	int ret;
	ret = fork();
  c4:	e8 00 02 00 00       	call   2c9 <fork>
	if(ret == 0)
  c9:	85 c0                	test   %eax,%eax
  cb:	75 0f                	jne    dc <main+0xdc>
	{
		sleep(100);
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	6a 64                	push   $0x64
  d2:	e8 8a 02 00 00       	call   361 <sleep>
		exit();
  d7:	e8 f5 01 00 00       	call   2d1 <exit>
	}
	get_siblings_info(pid);
  dc:	83 ec 0c             	sub    $0xc,%esp
  df:	ff 75 dc             	push   -0x24(%ebp)
  e2:	e8 a2 02 00 00       	call   389 <get_siblings_info>

	// Wait for the last child
	sleep(200);
  e7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  ee:	e8 6e 02 00 00       	call   361 <sleep>
	wait();
  f3:	e8 e1 01 00 00       	call   2d9 <wait>

	for (i = 0; i < n; i++)
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 100:	8b 7d e0             	mov    -0x20(%ebp),%edi
 103:	eb 11                	jmp    116 <main+0x116>
	{
		kill(pids[i]);
 105:	83 ec 0c             	sub    $0xc,%esp
 108:	ff 34 9f             	push   (%edi,%ebx,4)
 10b:	e8 f1 01 00 00       	call   301 <kill>
	for (i = 0; i < n; i++)
 110:	83 c3 01             	add    $0x1,%ebx
 113:	83 c4 10             	add    $0x10,%esp
 116:	39 f3                	cmp    %esi,%ebx
 118:	7c eb                	jl     105 <main+0x105>
	}

	for(i = 0; i< n; i++)
 11a:	bb 00 00 00 00       	mov    $0x0,%ebx
 11f:	eb 08                	jmp    129 <main+0x129>
		wait();
 121:	e8 b3 01 00 00       	call   2d9 <wait>
	for(i = 0; i< n; i++)
 126:	83 c3 01             	add    $0x1,%ebx
 129:	39 f3                	cmp    %esi,%ebx
 12b:	7c f4                	jl     121 <main+0x121>

	exit();
 12d:	e8 9f 01 00 00       	call   2d1 <exit>

00000132 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	56                   	push   %esi
 136:	53                   	push   %ebx
 137:	8b 75 08             	mov    0x8(%ebp),%esi
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13d:	89 f0                	mov    %esi,%eax
 13f:	89 d1                	mov    %edx,%ecx
 141:	83 c2 01             	add    $0x1,%edx
 144:	89 c3                	mov    %eax,%ebx
 146:	83 c0 01             	add    $0x1,%eax
 149:	0f b6 09             	movzbl (%ecx),%ecx
 14c:	88 0b                	mov    %cl,(%ebx)
 14e:	84 c9                	test   %cl,%cl
 150:	75 ed                	jne    13f <strcpy+0xd>
    ;
  return os;
}
 152:	89 f0                	mov    %esi,%eax
 154:	5b                   	pop    %ebx
 155:	5e                   	pop    %esi
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    

00000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 161:	eb 06                	jmp    169 <strcmp+0x11>
    p++, q++;
 163:	83 c1 01             	add    $0x1,%ecx
 166:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 169:	0f b6 01             	movzbl (%ecx),%eax
 16c:	84 c0                	test   %al,%al
 16e:	74 04                	je     174 <strcmp+0x1c>
 170:	3a 02                	cmp    (%edx),%al
 172:	74 ef                	je     163 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 174:	0f b6 c0             	movzbl %al,%eax
 177:	0f b6 12             	movzbl (%edx),%edx
 17a:	29 d0                	sub    %edx,%eax
}
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    

0000017e <strlen>:

uint
strlen(const char *s)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 184:	b8 00 00 00 00       	mov    $0x0,%eax
 189:	eb 03                	jmp    18e <strlen+0x10>
 18b:	83 c0 01             	add    $0x1,%eax
 18e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 192:	75 f7                	jne    18b <strlen+0xd>
    ;
  return n;
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	57                   	push   %edi
 19a:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19d:	89 d7                	mov    %edx,%edi
 19f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	fc                   	cld    
 1a6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a8:	89 d0                	mov    %edx,%eax
 1aa:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <strchr>:

char*
strchr(const char *s, char c)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1b9:	eb 03                	jmp    1be <strchr+0xf>
 1bb:	83 c0 01             	add    $0x1,%eax
 1be:	0f b6 10             	movzbl (%eax),%edx
 1c1:	84 d2                	test   %dl,%dl
 1c3:	74 06                	je     1cb <strchr+0x1c>
    if(*s == c)
 1c5:	38 ca                	cmp    %cl,%dl
 1c7:	75 f2                	jne    1bb <strchr+0xc>
 1c9:	eb 05                	jmp    1d0 <strchr+0x21>
      return (char*)s;
  return 0;
 1cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    

000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	57                   	push   %edi
 1d6:	56                   	push   %esi
 1d7:	53                   	push   %ebx
 1d8:	83 ec 1c             	sub    $0x1c,%esp
 1db:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e3:	89 de                	mov    %ebx,%esi
 1e5:	83 c3 01             	add    $0x1,%ebx
 1e8:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1eb:	7d 2e                	jge    21b <gets+0x49>
    cc = read(0, &c, 1);
 1ed:	83 ec 04             	sub    $0x4,%esp
 1f0:	6a 01                	push   $0x1
 1f2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1f5:	50                   	push   %eax
 1f6:	6a 00                	push   $0x0
 1f8:	e8 ec 00 00 00       	call   2e9 <read>
    if(cc < 1)
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	85 c0                	test   %eax,%eax
 202:	7e 17                	jle    21b <gets+0x49>
      break;
    buf[i++] = c;
 204:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 208:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 20b:	3c 0a                	cmp    $0xa,%al
 20d:	0f 94 c2             	sete   %dl
 210:	3c 0d                	cmp    $0xd,%al
 212:	0f 94 c0             	sete   %al
 215:	08 c2                	or     %al,%dl
 217:	74 ca                	je     1e3 <gets+0x11>
    buf[i++] = c;
 219:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 21b:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 21f:	89 f8                	mov    %edi,%eax
 221:	8d 65 f4             	lea    -0xc(%ebp),%esp
 224:	5b                   	pop    %ebx
 225:	5e                   	pop    %esi
 226:	5f                   	pop    %edi
 227:	5d                   	pop    %ebp
 228:	c3                   	ret    

00000229 <stat>:

int
stat(const char *n, struct stat *st)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	56                   	push   %esi
 22d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	6a 00                	push   $0x0
 233:	ff 75 08             	push   0x8(%ebp)
 236:	e8 d6 00 00 00       	call   311 <open>
  if(fd < 0)
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	85 c0                	test   %eax,%eax
 240:	78 24                	js     266 <stat+0x3d>
 242:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 244:	83 ec 08             	sub    $0x8,%esp
 247:	ff 75 0c             	push   0xc(%ebp)
 24a:	50                   	push   %eax
 24b:	e8 d9 00 00 00       	call   329 <fstat>
 250:	89 c6                	mov    %eax,%esi
  close(fd);
 252:	89 1c 24             	mov    %ebx,(%esp)
 255:	e8 9f 00 00 00       	call   2f9 <close>
  return r;
 25a:	83 c4 10             	add    $0x10,%esp
}
 25d:	89 f0                	mov    %esi,%eax
 25f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 262:	5b                   	pop    %ebx
 263:	5e                   	pop    %esi
 264:	5d                   	pop    %ebp
 265:	c3                   	ret    
    return -1;
 266:	be ff ff ff ff       	mov    $0xffffffff,%esi
 26b:	eb f0                	jmp    25d <stat+0x34>

0000026d <atoi>:

int
atoi(const char *s)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	53                   	push   %ebx
 271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 274:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 279:	eb 10                	jmp    28b <atoi+0x1e>
    n = n*10 + *s++ - '0';
 27b:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 27e:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 281:	83 c1 01             	add    $0x1,%ecx
 284:	0f be c0             	movsbl %al,%eax
 287:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 28b:	0f b6 01             	movzbl (%ecx),%eax
 28e:	8d 58 d0             	lea    -0x30(%eax),%ebx
 291:	80 fb 09             	cmp    $0x9,%bl
 294:	76 e5                	jbe    27b <atoi+0xe>
  return n;
}
 296:	89 d0                	mov    %edx,%eax
 298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	56                   	push   %esi
 2a1:	53                   	push   %ebx
 2a2:	8b 75 08             	mov    0x8(%ebp),%esi
 2a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2a8:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2ab:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2ad:	eb 0d                	jmp    2bc <memmove+0x1f>
    *dst++ = *src++;
 2af:	0f b6 01             	movzbl (%ecx),%eax
 2b2:	88 02                	mov    %al,(%edx)
 2b4:	8d 49 01             	lea    0x1(%ecx),%ecx
 2b7:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2ba:	89 d8                	mov    %ebx,%eax
 2bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2bf:	85 c0                	test   %eax,%eax
 2c1:	7f ec                	jg     2af <memmove+0x12>
  return vdst;
}
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <exit>:
SYSCALL(exit)
 2d1:	b8 02 00 00 00       	mov    $0x2,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <wait>:
SYSCALL(wait)
 2d9:	b8 03 00 00 00       	mov    $0x3,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <pipe>:
SYSCALL(pipe)
 2e1:	b8 04 00 00 00       	mov    $0x4,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <read>:
SYSCALL(read)
 2e9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <write>:
SYSCALL(write)
 2f1:	b8 10 00 00 00       	mov    $0x10,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <close>:
SYSCALL(close)
 2f9:	b8 15 00 00 00       	mov    $0x15,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <kill>:
SYSCALL(kill)
 301:	b8 06 00 00 00       	mov    $0x6,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <exec>:
SYSCALL(exec)
 309:	b8 07 00 00 00       	mov    $0x7,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <open>:
SYSCALL(open)
 311:	b8 0f 00 00 00       	mov    $0xf,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mknod>:
SYSCALL(mknod)
 319:	b8 11 00 00 00       	mov    $0x11,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <unlink>:
SYSCALL(unlink)
 321:	b8 12 00 00 00       	mov    $0x12,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <fstat>:
SYSCALL(fstat)
 329:	b8 08 00 00 00       	mov    $0x8,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <link>:
SYSCALL(link)
 331:	b8 13 00 00 00       	mov    $0x13,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mkdir>:
SYSCALL(mkdir)
 339:	b8 14 00 00 00       	mov    $0x14,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <chdir>:
SYSCALL(chdir)
 341:	b8 09 00 00 00       	mov    $0x9,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <dup>:
SYSCALL(dup)
 349:	b8 0a 00 00 00       	mov    $0xa,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <getpid>:
SYSCALL(getpid)
 351:	b8 0b 00 00 00       	mov    $0xb,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sbrk>:
SYSCALL(sbrk)
 359:	b8 0c 00 00 00       	mov    $0xc,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <sleep>:
SYSCALL(sleep)
 361:	b8 0d 00 00 00       	mov    $0xd,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <uptime>:
SYSCALL(uptime)
 369:	b8 0e 00 00 00       	mov    $0xe,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <hello>:
SYSCALL(hello)
 371:	b8 16 00 00 00       	mov    $0x16,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <helloYou>:
SYSCALL(helloYou)
 379:	b8 17 00 00 00       	mov    $0x17,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <getppid>:
SYSCALL(getppid)
 381:	b8 18 00 00 00       	mov    $0x18,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <get_siblings_info>:
SYSCALL(get_siblings_info)
 389:	b8 19 00 00 00       	mov    $0x19,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <signalProcess>:
SYSCALL(signalProcess)
 391:	b8 1a 00 00 00       	mov    $0x1a,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <numvp>:
SYSCALL(numvp)
 399:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <numpp>:
SYSCALL(numpp)
 3a1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <init_counter>:

SYSCALL(init_counter)
 3a9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <update_cnt>:
SYSCALL(update_cnt)
 3b1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <display_count>:
SYSCALL(display_count)
 3b9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <init_counter_1>:
SYSCALL(init_counter_1)
 3c1:	b8 20 00 00 00       	mov    $0x20,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <update_cnt_1>:
SYSCALL(update_cnt_1)
 3c9:	b8 21 00 00 00       	mov    $0x21,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <display_count_1>:
SYSCALL(display_count_1)
 3d1:	b8 22 00 00 00       	mov    $0x22,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <init_counter_2>:
SYSCALL(init_counter_2)
 3d9:	b8 23 00 00 00       	mov    $0x23,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <update_cnt_2>:
SYSCALL(update_cnt_2)
 3e1:	b8 24 00 00 00       	mov    $0x24,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <display_count_2>:
 3e9:	b8 25 00 00 00       	mov    $0x25,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f1:	55                   	push   %ebp
 3f2:	89 e5                	mov    %esp,%ebp
 3f4:	83 ec 1c             	sub    $0x1c,%esp
 3f7:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3fa:	6a 01                	push   $0x1
 3fc:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3ff:	52                   	push   %edx
 400:	50                   	push   %eax
 401:	e8 eb fe ff ff       	call   2f1 <write>
}
 406:	83 c4 10             	add    $0x10,%esp
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	57                   	push   %edi
 40f:	56                   	push   %esi
 410:	53                   	push   %ebx
 411:	83 ec 2c             	sub    $0x2c,%esp
 414:	89 45 d0             	mov    %eax,-0x30(%ebp)
 417:	89 d0                	mov    %edx,%eax
 419:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 41f:	0f 95 c1             	setne  %cl
 422:	c1 ea 1f             	shr    $0x1f,%edx
 425:	84 d1                	test   %dl,%cl
 427:	74 44                	je     46d <printint+0x62>
    neg = 1;
    x = -xx;
 429:	f7 d8                	neg    %eax
 42b:	89 c1                	mov    %eax,%ecx
    neg = 1;
 42d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 434:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 439:	89 c8                	mov    %ecx,%eax
 43b:	ba 00 00 00 00       	mov    $0x0,%edx
 440:	f7 f6                	div    %esi
 442:	89 df                	mov    %ebx,%edi
 444:	83 c3 01             	add    $0x1,%ebx
 447:	0f b6 92 b0 07 00 00 	movzbl 0x7b0(%edx),%edx
 44e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 452:	89 ca                	mov    %ecx,%edx
 454:	89 c1                	mov    %eax,%ecx
 456:	39 d6                	cmp    %edx,%esi
 458:	76 df                	jbe    439 <printint+0x2e>
  if(neg)
 45a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 45e:	74 31                	je     491 <printint+0x86>
    buf[i++] = '-';
 460:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 465:	8d 5f 02             	lea    0x2(%edi),%ebx
 468:	8b 75 d0             	mov    -0x30(%ebp),%esi
 46b:	eb 17                	jmp    484 <printint+0x79>
    x = xx;
 46d:	89 c1                	mov    %eax,%ecx
  neg = 0;
 46f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 476:	eb bc                	jmp    434 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 478:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 47d:	89 f0                	mov    %esi,%eax
 47f:	e8 6d ff ff ff       	call   3f1 <putc>
  while(--i >= 0)
 484:	83 eb 01             	sub    $0x1,%ebx
 487:	79 ef                	jns    478 <printint+0x6d>
}
 489:	83 c4 2c             	add    $0x2c,%esp
 48c:	5b                   	pop    %ebx
 48d:	5e                   	pop    %esi
 48e:	5f                   	pop    %edi
 48f:	5d                   	pop    %ebp
 490:	c3                   	ret    
 491:	8b 75 d0             	mov    -0x30(%ebp),%esi
 494:	eb ee                	jmp    484 <printint+0x79>

00000496 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 496:	55                   	push   %ebp
 497:	89 e5                	mov    %esp,%ebp
 499:	57                   	push   %edi
 49a:	56                   	push   %esi
 49b:	53                   	push   %ebx
 49c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 49f:	8d 45 10             	lea    0x10(%ebp),%eax
 4a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4a5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4aa:	bb 00 00 00 00       	mov    $0x0,%ebx
 4af:	eb 14                	jmp    4c5 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b1:	89 fa                	mov    %edi,%edx
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	e8 36 ff ff ff       	call   3f1 <putc>
 4bb:	eb 05                	jmp    4c2 <printf+0x2c>
      }
    } else if(state == '%'){
 4bd:	83 fe 25             	cmp    $0x25,%esi
 4c0:	74 25                	je     4e7 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 4c2:	83 c3 01             	add    $0x1,%ebx
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4cc:	84 c0                	test   %al,%al
 4ce:	0f 84 20 01 00 00    	je     5f4 <printf+0x15e>
    c = fmt[i] & 0xff;
 4d4:	0f be f8             	movsbl %al,%edi
 4d7:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4da:	85 f6                	test   %esi,%esi
 4dc:	75 df                	jne    4bd <printf+0x27>
      if(c == '%'){
 4de:	83 f8 25             	cmp    $0x25,%eax
 4e1:	75 ce                	jne    4b1 <printf+0x1b>
        state = '%';
 4e3:	89 c6                	mov    %eax,%esi
 4e5:	eb db                	jmp    4c2 <printf+0x2c>
      if(c == 'd'){
 4e7:	83 f8 25             	cmp    $0x25,%eax
 4ea:	0f 84 cf 00 00 00    	je     5bf <printf+0x129>
 4f0:	0f 8c dd 00 00 00    	jl     5d3 <printf+0x13d>
 4f6:	83 f8 78             	cmp    $0x78,%eax
 4f9:	0f 8f d4 00 00 00    	jg     5d3 <printf+0x13d>
 4ff:	83 f8 63             	cmp    $0x63,%eax
 502:	0f 8c cb 00 00 00    	jl     5d3 <printf+0x13d>
 508:	83 e8 63             	sub    $0x63,%eax
 50b:	83 f8 15             	cmp    $0x15,%eax
 50e:	0f 87 bf 00 00 00    	ja     5d3 <printf+0x13d>
 514:	ff 24 85 58 07 00 00 	jmp    *0x758(,%eax,4)
        printint(fd, *ap, 10, 1);
 51b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 51e:	8b 17                	mov    (%edi),%edx
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	6a 01                	push   $0x1
 525:	b9 0a 00 00 00       	mov    $0xa,%ecx
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	e8 d9 fe ff ff       	call   40b <printint>
        ap++;
 532:	83 c7 04             	add    $0x4,%edi
 535:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 538:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	eb 80                	jmp    4c2 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 542:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 545:	8b 17                	mov    (%edi),%edx
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	6a 00                	push   $0x0
 54c:	b9 10 00 00 00       	mov    $0x10,%ecx
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	e8 b2 fe ff ff       	call   40b <printint>
        ap++;
 559:	83 c7 04             	add    $0x4,%edi
 55c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 55f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 562:	be 00 00 00 00       	mov    $0x0,%esi
 567:	e9 56 ff ff ff       	jmp    4c2 <printf+0x2c>
        s = (char*)*ap;
 56c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56f:	8b 30                	mov    (%eax),%esi
        ap++;
 571:	83 c0 04             	add    $0x4,%eax
 574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 577:	85 f6                	test   %esi,%esi
 579:	75 15                	jne    590 <printf+0xfa>
          s = "(null)";
 57b:	be 50 07 00 00       	mov    $0x750,%esi
 580:	eb 0e                	jmp    590 <printf+0xfa>
          putc(fd, *s);
 582:	0f be d2             	movsbl %dl,%edx
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	e8 64 fe ff ff       	call   3f1 <putc>
          s++;
 58d:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 590:	0f b6 16             	movzbl (%esi),%edx
 593:	84 d2                	test   %dl,%dl
 595:	75 eb                	jne    582 <printf+0xec>
      state = 0;
 597:	be 00 00 00 00       	mov    $0x0,%esi
 59c:	e9 21 ff ff ff       	jmp    4c2 <printf+0x2c>
        putc(fd, *ap);
 5a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5a4:	0f be 17             	movsbl (%edi),%edx
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	e8 42 fe ff ff       	call   3f1 <putc>
        ap++;
 5af:	83 c7 04             	add    $0x4,%edi
 5b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5b5:	be 00 00 00 00       	mov    $0x0,%esi
 5ba:	e9 03 ff ff ff       	jmp    4c2 <printf+0x2c>
        putc(fd, c);
 5bf:	89 fa                	mov    %edi,%edx
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	e8 28 fe ff ff       	call   3f1 <putc>
      state = 0;
 5c9:	be 00 00 00 00       	mov    $0x0,%esi
 5ce:	e9 ef fe ff ff       	jmp    4c2 <printf+0x2c>
        putc(fd, '%');
 5d3:	ba 25 00 00 00       	mov    $0x25,%edx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	e8 11 fe ff ff       	call   3f1 <putc>
        putc(fd, c);
 5e0:	89 fa                	mov    %edi,%edx
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	e8 07 fe ff ff       	call   3f1 <putc>
      state = 0;
 5ea:	be 00 00 00 00       	mov    $0x0,%esi
 5ef:	e9 ce fe ff ff       	jmp    4c2 <printf+0x2c>
    }
  }
}
 5f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    

000005fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	57                   	push   %edi
 600:	56                   	push   %esi
 601:	53                   	push   %ebx
 602:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 605:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 608:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 60d:	eb 02                	jmp    611 <free+0x15>
 60f:	89 d0                	mov    %edx,%eax
 611:	39 c8                	cmp    %ecx,%eax
 613:	73 04                	jae    619 <free+0x1d>
 615:	39 08                	cmp    %ecx,(%eax)
 617:	77 12                	ja     62b <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 619:	8b 10                	mov    (%eax),%edx
 61b:	39 c2                	cmp    %eax,%edx
 61d:	77 f0                	ja     60f <free+0x13>
 61f:	39 c8                	cmp    %ecx,%eax
 621:	72 08                	jb     62b <free+0x2f>
 623:	39 ca                	cmp    %ecx,%edx
 625:	77 04                	ja     62b <free+0x2f>
 627:	89 d0                	mov    %edx,%eax
 629:	eb e6                	jmp    611 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 62b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 631:	8b 10                	mov    (%eax),%edx
 633:	39 d7                	cmp    %edx,%edi
 635:	74 19                	je     650 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 637:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63a:	8b 50 04             	mov    0x4(%eax),%edx
 63d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 640:	39 ce                	cmp    %ecx,%esi
 642:	74 1b                	je     65f <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 644:	89 08                	mov    %ecx,(%eax)
  freep = p;
 646:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 650:	03 72 04             	add    0x4(%edx),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 12                	mov    (%edx),%edx
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 65d:	eb db                	jmp    63a <free+0x3e>
    p->s.size += bp->s.size;
 65f:	03 53 fc             	add    -0x4(%ebx),%edx
 662:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 665:	8b 53 f8             	mov    -0x8(%ebx),%edx
 668:	89 10                	mov    %edx,(%eax)
 66a:	eb da                	jmp    646 <free+0x4a>

0000066c <morecore>:

static Header*
morecore(uint nu)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
 66f:	53                   	push   %ebx
 670:	83 ec 04             	sub    $0x4,%esp
 673:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 675:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 67a:	77 05                	ja     681 <morecore+0x15>
    nu = 4096;
 67c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 681:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 688:	83 ec 0c             	sub    $0xc,%esp
 68b:	50                   	push   %eax
 68c:	e8 c8 fc ff ff       	call   359 <sbrk>
  if(p == (char*)-1)
 691:	83 c4 10             	add    $0x10,%esp
 694:	83 f8 ff             	cmp    $0xffffffff,%eax
 697:	74 1c                	je     6b5 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 699:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 69c:	83 c0 08             	add    $0x8,%eax
 69f:	83 ec 0c             	sub    $0xc,%esp
 6a2:	50                   	push   %eax
 6a3:	e8 54 ff ff ff       	call   5fc <free>
  return freep;
 6a8:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 6ad:	83 c4 10             	add    $0x10,%esp
}
 6b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    
    return 0;
 6b5:	b8 00 00 00 00       	mov    $0x0,%eax
 6ba:	eb f4                	jmp    6b0 <morecore+0x44>

000006bc <malloc>:

void*
malloc(uint nbytes)
{
 6bc:	55                   	push   %ebp
 6bd:	89 e5                	mov    %esp,%ebp
 6bf:	53                   	push   %ebx
 6c0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	8d 58 07             	lea    0x7(%eax),%ebx
 6c9:	c1 eb 03             	shr    $0x3,%ebx
 6cc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6cf:	8b 0d 5c 0a 00 00    	mov    0xa5c,%ecx
 6d5:	85 c9                	test   %ecx,%ecx
 6d7:	74 04                	je     6dd <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d9:	8b 01                	mov    (%ecx),%eax
 6db:	eb 4a                	jmp    727 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 6dd:	c7 05 5c 0a 00 00 60 	movl   $0xa60,0xa5c
 6e4:	0a 00 00 
 6e7:	c7 05 60 0a 00 00 60 	movl   $0xa60,0xa60
 6ee:	0a 00 00 
    base.s.size = 0;
 6f1:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 6f8:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6fb:	b9 60 0a 00 00       	mov    $0xa60,%ecx
 700:	eb d7                	jmp    6d9 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 702:	74 19                	je     71d <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 704:	29 da                	sub    %ebx,%edx
 706:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 709:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 70c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 70f:	89 0d 5c 0a 00 00    	mov    %ecx,0xa5c
      return (void*)(p + 1);
 715:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 71b:	c9                   	leave  
 71c:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 71d:	8b 10                	mov    (%eax),%edx
 71f:	89 11                	mov    %edx,(%ecx)
 721:	eb ec                	jmp    70f <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	89 c1                	mov    %eax,%ecx
 725:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 727:	8b 50 04             	mov    0x4(%eax),%edx
 72a:	39 da                	cmp    %ebx,%edx
 72c:	73 d4                	jae    702 <malloc+0x46>
    if(p == freep)
 72e:	39 05 5c 0a 00 00    	cmp    %eax,0xa5c
 734:	75 ed                	jne    723 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 736:	89 d8                	mov    %ebx,%eax
 738:	e8 2f ff ff ff       	call   66c <morecore>
 73d:	85 c0                	test   %eax,%eax
 73f:	75 e2                	jne    723 <malloc+0x67>
 741:	eb d5                	jmp    718 <malloc+0x5c>
