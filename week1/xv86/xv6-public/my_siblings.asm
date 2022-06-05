
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
  9e:	68 fc 06 00 00       	push   $0x6fc
  a3:	6a 01                	push   $0x1
  a5:	e8 a4 03 00 00       	call   44e <printf>
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
 3a1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	83 ec 1c             	sub    $0x1c,%esp
 3af:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3b2:	6a 01                	push   $0x1
 3b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3b7:	52                   	push   %edx
 3b8:	50                   	push   %eax
 3b9:	e8 33 ff ff ff       	call   2f1 <write>
}
 3be:	83 c4 10             	add    $0x10,%esp
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	57                   	push   %edi
 3c7:	56                   	push   %esi
 3c8:	53                   	push   %ebx
 3c9:	83 ec 2c             	sub    $0x2c,%esp
 3cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3cf:	89 d0                	mov    %edx,%eax
 3d1:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3d7:	0f 95 c1             	setne  %cl
 3da:	c1 ea 1f             	shr    $0x1f,%edx
 3dd:	84 d1                	test   %dl,%cl
 3df:	74 44                	je     425 <printint+0x62>
    neg = 1;
    x = -xx;
 3e1:	f7 d8                	neg    %eax
 3e3:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3f1:	89 c8                	mov    %ecx,%eax
 3f3:	ba 00 00 00 00       	mov    $0x0,%edx
 3f8:	f7 f6                	div    %esi
 3fa:	89 df                	mov    %ebx,%edi
 3fc:	83 c3 01             	add    $0x1,%ebx
 3ff:	0f b6 92 68 07 00 00 	movzbl 0x768(%edx),%edx
 406:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 40a:	89 ca                	mov    %ecx,%edx
 40c:	89 c1                	mov    %eax,%ecx
 40e:	39 d6                	cmp    %edx,%esi
 410:	76 df                	jbe    3f1 <printint+0x2e>
  if(neg)
 412:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 416:	74 31                	je     449 <printint+0x86>
    buf[i++] = '-';
 418:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 41d:	8d 5f 02             	lea    0x2(%edi),%ebx
 420:	8b 75 d0             	mov    -0x30(%ebp),%esi
 423:	eb 17                	jmp    43c <printint+0x79>
    x = xx;
 425:	89 c1                	mov    %eax,%ecx
  neg = 0;
 427:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 42e:	eb bc                	jmp    3ec <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 430:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 435:	89 f0                	mov    %esi,%eax
 437:	e8 6d ff ff ff       	call   3a9 <putc>
  while(--i >= 0)
 43c:	83 eb 01             	sub    $0x1,%ebx
 43f:	79 ef                	jns    430 <printint+0x6d>
}
 441:	83 c4 2c             	add    $0x2c,%esp
 444:	5b                   	pop    %ebx
 445:	5e                   	pop    %esi
 446:	5f                   	pop    %edi
 447:	5d                   	pop    %ebp
 448:	c3                   	ret    
 449:	8b 75 d0             	mov    -0x30(%ebp),%esi
 44c:	eb ee                	jmp    43c <printint+0x79>

0000044e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	57                   	push   %edi
 452:	56                   	push   %esi
 453:	53                   	push   %ebx
 454:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 457:	8d 45 10             	lea    0x10(%ebp),%eax
 45a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 45d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 462:	bb 00 00 00 00       	mov    $0x0,%ebx
 467:	eb 14                	jmp    47d <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 469:	89 fa                	mov    %edi,%edx
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	e8 36 ff ff ff       	call   3a9 <putc>
 473:	eb 05                	jmp    47a <printf+0x2c>
      }
    } else if(state == '%'){
 475:	83 fe 25             	cmp    $0x25,%esi
 478:	74 25                	je     49f <printf+0x51>
  for(i = 0; fmt[i]; i++){
 47a:	83 c3 01             	add    $0x1,%ebx
 47d:	8b 45 0c             	mov    0xc(%ebp),%eax
 480:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 484:	84 c0                	test   %al,%al
 486:	0f 84 20 01 00 00    	je     5ac <printf+0x15e>
    c = fmt[i] & 0xff;
 48c:	0f be f8             	movsbl %al,%edi
 48f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 492:	85 f6                	test   %esi,%esi
 494:	75 df                	jne    475 <printf+0x27>
      if(c == '%'){
 496:	83 f8 25             	cmp    $0x25,%eax
 499:	75 ce                	jne    469 <printf+0x1b>
        state = '%';
 49b:	89 c6                	mov    %eax,%esi
 49d:	eb db                	jmp    47a <printf+0x2c>
      if(c == 'd'){
 49f:	83 f8 25             	cmp    $0x25,%eax
 4a2:	0f 84 cf 00 00 00    	je     577 <printf+0x129>
 4a8:	0f 8c dd 00 00 00    	jl     58b <printf+0x13d>
 4ae:	83 f8 78             	cmp    $0x78,%eax
 4b1:	0f 8f d4 00 00 00    	jg     58b <printf+0x13d>
 4b7:	83 f8 63             	cmp    $0x63,%eax
 4ba:	0f 8c cb 00 00 00    	jl     58b <printf+0x13d>
 4c0:	83 e8 63             	sub    $0x63,%eax
 4c3:	83 f8 15             	cmp    $0x15,%eax
 4c6:	0f 87 bf 00 00 00    	ja     58b <printf+0x13d>
 4cc:	ff 24 85 10 07 00 00 	jmp    *0x710(,%eax,4)
        printint(fd, *ap, 10, 1);
 4d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d6:	8b 17                	mov    (%edi),%edx
 4d8:	83 ec 0c             	sub    $0xc,%esp
 4db:	6a 01                	push   $0x1
 4dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	e8 d9 fe ff ff       	call   3c3 <printint>
        ap++;
 4ea:	83 c7 04             	add    $0x4,%edi
 4ed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f3:	be 00 00 00 00       	mov    $0x0,%esi
 4f8:	eb 80                	jmp    47a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4fd:	8b 17                	mov    (%edi),%edx
 4ff:	83 ec 0c             	sub    $0xc,%esp
 502:	6a 00                	push   $0x0
 504:	b9 10 00 00 00       	mov    $0x10,%ecx
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	e8 b2 fe ff ff       	call   3c3 <printint>
        ap++;
 511:	83 c7 04             	add    $0x4,%edi
 514:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 517:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51a:	be 00 00 00 00       	mov    $0x0,%esi
 51f:	e9 56 ff ff ff       	jmp    47a <printf+0x2c>
        s = (char*)*ap;
 524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 527:	8b 30                	mov    (%eax),%esi
        ap++;
 529:	83 c0 04             	add    $0x4,%eax
 52c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 52f:	85 f6                	test   %esi,%esi
 531:	75 15                	jne    548 <printf+0xfa>
          s = "(null)";
 533:	be 08 07 00 00       	mov    $0x708,%esi
 538:	eb 0e                	jmp    548 <printf+0xfa>
          putc(fd, *s);
 53a:	0f be d2             	movsbl %dl,%edx
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	e8 64 fe ff ff       	call   3a9 <putc>
          s++;
 545:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 548:	0f b6 16             	movzbl (%esi),%edx
 54b:	84 d2                	test   %dl,%dl
 54d:	75 eb                	jne    53a <printf+0xec>
      state = 0;
 54f:	be 00 00 00 00       	mov    $0x0,%esi
 554:	e9 21 ff ff ff       	jmp    47a <printf+0x2c>
        putc(fd, *ap);
 559:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 55c:	0f be 17             	movsbl (%edi),%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	e8 42 fe ff ff       	call   3a9 <putc>
        ap++;
 567:	83 c7 04             	add    $0x4,%edi
 56a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 56d:	be 00 00 00 00       	mov    $0x0,%esi
 572:	e9 03 ff ff ff       	jmp    47a <printf+0x2c>
        putc(fd, c);
 577:	89 fa                	mov    %edi,%edx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	e8 28 fe ff ff       	call   3a9 <putc>
      state = 0;
 581:	be 00 00 00 00       	mov    $0x0,%esi
 586:	e9 ef fe ff ff       	jmp    47a <printf+0x2c>
        putc(fd, '%');
 58b:	ba 25 00 00 00       	mov    $0x25,%edx
 590:	8b 45 08             	mov    0x8(%ebp),%eax
 593:	e8 11 fe ff ff       	call   3a9 <putc>
        putc(fd, c);
 598:	89 fa                	mov    %edi,%edx
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	e8 07 fe ff ff       	call   3a9 <putc>
      state = 0;
 5a2:	be 00 00 00 00       	mov    $0x0,%esi
 5a7:	e9 ce fe ff ff       	jmp    47a <printf+0x2c>
    }
  }
}
 5ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    

000005b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5bd:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c0:	a1 14 0a 00 00       	mov    0xa14,%eax
 5c5:	eb 02                	jmp    5c9 <free+0x15>
 5c7:	89 d0                	mov    %edx,%eax
 5c9:	39 c8                	cmp    %ecx,%eax
 5cb:	73 04                	jae    5d1 <free+0x1d>
 5cd:	39 08                	cmp    %ecx,(%eax)
 5cf:	77 12                	ja     5e3 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	39 c2                	cmp    %eax,%edx
 5d5:	77 f0                	ja     5c7 <free+0x13>
 5d7:	39 c8                	cmp    %ecx,%eax
 5d9:	72 08                	jb     5e3 <free+0x2f>
 5db:	39 ca                	cmp    %ecx,%edx
 5dd:	77 04                	ja     5e3 <free+0x2f>
 5df:	89 d0                	mov    %edx,%eax
 5e1:	eb e6                	jmp    5c9 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	39 d7                	cmp    %edx,%edi
 5ed:	74 19                	je     608 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ef:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f2:	8b 50 04             	mov    0x4(%eax),%edx
 5f5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f8:	39 ce                	cmp    %ecx,%esi
 5fa:	74 1b                	je     617 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5fc:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5fe:	a3 14 0a 00 00       	mov    %eax,0xa14
}
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 608:	03 72 04             	add    0x4(%edx),%esi
 60b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 10                	mov    (%eax),%edx
 610:	8b 12                	mov    (%edx),%edx
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
 615:	eb db                	jmp    5f2 <free+0x3e>
    p->s.size += bp->s.size;
 617:	03 53 fc             	add    -0x4(%ebx),%edx
 61a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 61d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 620:	89 10                	mov    %edx,(%eax)
 622:	eb da                	jmp    5fe <free+0x4a>

00000624 <morecore>:

static Header*
morecore(uint nu)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	53                   	push   %ebx
 628:	83 ec 04             	sub    $0x4,%esp
 62b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 62d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 632:	77 05                	ja     639 <morecore+0x15>
    nu = 4096;
 634:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 639:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	50                   	push   %eax
 644:	e8 10 fd ff ff       	call   359 <sbrk>
  if(p == (char*)-1)
 649:	83 c4 10             	add    $0x10,%esp
 64c:	83 f8 ff             	cmp    $0xffffffff,%eax
 64f:	74 1c                	je     66d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 651:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 654:	83 c0 08             	add    $0x8,%eax
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	50                   	push   %eax
 65b:	e8 54 ff ff ff       	call   5b4 <free>
  return freep;
 660:	a1 14 0a 00 00       	mov    0xa14,%eax
 665:	83 c4 10             	add    $0x10,%esp
}
 668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66b:	c9                   	leave  
 66c:	c3                   	ret    
    return 0;
 66d:	b8 00 00 00 00       	mov    $0x0,%eax
 672:	eb f4                	jmp    668 <morecore+0x44>

00000674 <malloc>:

void*
malloc(uint nbytes)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	53                   	push   %ebx
 678:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	8d 58 07             	lea    0x7(%eax),%ebx
 681:	c1 eb 03             	shr    $0x3,%ebx
 684:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 687:	8b 0d 14 0a 00 00    	mov    0xa14,%ecx
 68d:	85 c9                	test   %ecx,%ecx
 68f:	74 04                	je     695 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 691:	8b 01                	mov    (%ecx),%eax
 693:	eb 4a                	jmp    6df <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 695:	c7 05 14 0a 00 00 18 	movl   $0xa18,0xa14
 69c:	0a 00 00 
 69f:	c7 05 18 0a 00 00 18 	movl   $0xa18,0xa18
 6a6:	0a 00 00 
    base.s.size = 0;
 6a9:	c7 05 1c 0a 00 00 00 	movl   $0x0,0xa1c
 6b0:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6b3:	b9 18 0a 00 00       	mov    $0xa18,%ecx
 6b8:	eb d7                	jmp    691 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6ba:	74 19                	je     6d5 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6bc:	29 da                	sub    %ebx,%edx
 6be:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6c1:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6c4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6c7:	89 0d 14 0a 00 00    	mov    %ecx,0xa14
      return (void*)(p + 1);
 6cd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6d5:	8b 10                	mov    (%eax),%edx
 6d7:	89 11                	mov    %edx,(%ecx)
 6d9:	eb ec                	jmp    6c7 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6db:	89 c1                	mov    %eax,%ecx
 6dd:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6df:	8b 50 04             	mov    0x4(%eax),%edx
 6e2:	39 da                	cmp    %ebx,%edx
 6e4:	73 d4                	jae    6ba <malloc+0x46>
    if(p == freep)
 6e6:	39 05 14 0a 00 00    	cmp    %eax,0xa14
 6ec:	75 ed                	jne    6db <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6ee:	89 d8                	mov    %ebx,%eax
 6f0:	e8 2f ff ff ff       	call   624 <morecore>
 6f5:	85 c0                	test   %eax,%eax
 6f7:	75 e2                	jne    6db <malloc+0x67>
 6f9:	eb d5                	jmp    6d0 <malloc+0x5c>
