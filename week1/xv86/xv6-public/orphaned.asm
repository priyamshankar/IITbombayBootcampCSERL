
_orphaned:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main() 
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    // printf(1,"overall parent pid: %d\n",getpid());
	int ret = fork();
   f:	e8 4e 02 00 00       	call   262 <fork>
	if (ret == 0) 
  14:	85 c0                	test   %eax,%eax
  16:	75 68                	jne    80 <main+0x80>
	{
		printf(1, "\nchild: pid %d\n", getpid());
  18:	e8 cd 02 00 00       	call   2ea <getpid>
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	50                   	push   %eax
  21:	68 94 06 00 00       	push   $0x694
  26:	6a 01                	push   $0x1
  28:	e8 ba 03 00 00       	call   3e7 <printf>
		printf(1, "child: parent pid %d\n", getppid());
  2d:	e8 e8 02 00 00       	call   31a <getppid>
  32:	83 c4 0c             	add    $0xc,%esp
  35:	50                   	push   %eax
  36:	68 a4 06 00 00       	push   $0x6a4
  3b:	6a 01                	push   $0x1
  3d:	e8 a5 03 00 00       	call   3e7 <printf>

		sleep(200);
  42:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  49:	e8 ac 02 00 00       	call   2fa <sleep>

		printf(1, "\nchild: pid %d\n", getpid());
  4e:	e8 97 02 00 00       	call   2ea <getpid>
  53:	83 c4 0c             	add    $0xc,%esp
  56:	50                   	push   %eax
  57:	68 94 06 00 00       	push   $0x694
  5c:	6a 01                	push   $0x1
  5e:	e8 84 03 00 00       	call   3e7 <printf>
		printf(1, "child: parent pid %d\n", getppid());
  63:	e8 b2 02 00 00       	call   31a <getppid>
  68:	83 c4 0c             	add    $0xc,%esp
  6b:	50                   	push   %eax
  6c:	68 a4 06 00 00       	push   $0x6a4
  71:	6a 01                	push   $0x1
  73:	e8 6f 03 00 00       	call   3e7 <printf>
  78:	83 c4 10             	add    $0x10,%esp
		printf(1, "parent: parent pid %d \n", getppid());
		printf(1, "parent: child pid %d\n", ret);
	}
	// printf(1,"after the else\n");
	
	exit();
  7b:	e8 ea 01 00 00       	call   26a <exit>
  80:	89 c3                	mov    %eax,%ebx
		sleep(100);
  82:	83 ec 0c             	sub    $0xc,%esp
  85:	6a 64                	push   $0x64
  87:	e8 6e 02 00 00       	call   2fa <sleep>
		printf(1, "\nparent: pid %d\n", getpid());
  8c:	e8 59 02 00 00       	call   2ea <getpid>
  91:	83 c4 0c             	add    $0xc,%esp
  94:	50                   	push   %eax
  95:	68 ba 06 00 00       	push   $0x6ba
  9a:	6a 01                	push   $0x1
  9c:	e8 46 03 00 00       	call   3e7 <printf>
		printf(1, "parent: parent pid %d \n", getppid());
  a1:	e8 74 02 00 00       	call   31a <getppid>
  a6:	83 c4 0c             	add    $0xc,%esp
  a9:	50                   	push   %eax
  aa:	68 cb 06 00 00       	push   $0x6cb
  af:	6a 01                	push   $0x1
  b1:	e8 31 03 00 00       	call   3e7 <printf>
		printf(1, "parent: child pid %d\n", ret);
  b6:	83 c4 0c             	add    $0xc,%esp
  b9:	53                   	push   %ebx
  ba:	68 e3 06 00 00       	push   $0x6e3
  bf:	6a 01                	push   $0x1
  c1:	e8 21 03 00 00       	call   3e7 <printf>
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	eb b0                	jmp    7b <main+0x7b>

000000cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	56                   	push   %esi
  cf:	53                   	push   %ebx
  d0:	8b 75 08             	mov    0x8(%ebp),%esi
  d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	89 f0                	mov    %esi,%eax
  d8:	89 d1                	mov    %edx,%ecx
  da:	83 c2 01             	add    $0x1,%edx
  dd:	89 c3                	mov    %eax,%ebx
  df:	83 c0 01             	add    $0x1,%eax
  e2:	0f b6 09             	movzbl (%ecx),%ecx
  e5:	88 0b                	mov    %cl,(%ebx)
  e7:	84 c9                	test   %cl,%cl
  e9:	75 ed                	jne    d8 <strcpy+0xd>
    ;
  return os;
}
  eb:	89 f0                	mov    %esi,%eax
  ed:	5b                   	pop    %ebx
  ee:	5e                   	pop    %esi
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  fa:	eb 06                	jmp    102 <strcmp+0x11>
    p++, q++;
  fc:	83 c1 01             	add    $0x1,%ecx
  ff:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 102:	0f b6 01             	movzbl (%ecx),%eax
 105:	84 c0                	test   %al,%al
 107:	74 04                	je     10d <strcmp+0x1c>
 109:	3a 02                	cmp    (%edx),%al
 10b:	74 ef                	je     fc <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 10d:	0f b6 c0             	movzbl %al,%eax
 110:	0f b6 12             	movzbl (%edx),%edx
 113:	29 d0                	sub    %edx,%eax
}
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    

00000117 <strlen>:

uint
strlen(const char *s)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 11d:	b8 00 00 00 00       	mov    $0x0,%eax
 122:	eb 03                	jmp    127 <strlen+0x10>
 124:	83 c0 01             	add    $0x1,%eax
 127:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 12b:	75 f7                	jne    124 <strlen+0xd>
    ;
  return n;
}
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    

0000012f <memset>:

void*
memset(void *dst, int c, uint n)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	57                   	push   %edi
 133:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 136:	89 d7                	mov    %edx,%edi
 138:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13b:	8b 45 0c             	mov    0xc(%ebp),%eax
 13e:	fc                   	cld    
 13f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 141:	89 d0                	mov    %edx,%eax
 143:	8b 7d fc             	mov    -0x4(%ebp),%edi
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 152:	eb 03                	jmp    157 <strchr+0xf>
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	74 06                	je     164 <strchr+0x1c>
    if(*s == c)
 15e:	38 ca                	cmp    %cl,%dl
 160:	75 f2                	jne    154 <strchr+0xc>
 162:	eb 05                	jmp    169 <strchr+0x21>
      return (char*)s;
  return 0;
 164:	b8 00 00 00 00       	mov    $0x0,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <gets>:

char*
gets(char *buf, int max)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	57                   	push   %edi
 16f:	56                   	push   %esi
 170:	53                   	push   %ebx
 171:	83 ec 1c             	sub    $0x1c,%esp
 174:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 177:	bb 00 00 00 00       	mov    $0x0,%ebx
 17c:	89 de                	mov    %ebx,%esi
 17e:	83 c3 01             	add    $0x1,%ebx
 181:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 184:	7d 2e                	jge    1b4 <gets+0x49>
    cc = read(0, &c, 1);
 186:	83 ec 04             	sub    $0x4,%esp
 189:	6a 01                	push   $0x1
 18b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18e:	50                   	push   %eax
 18f:	6a 00                	push   $0x0
 191:	e8 ec 00 00 00       	call   282 <read>
    if(cc < 1)
 196:	83 c4 10             	add    $0x10,%esp
 199:	85 c0                	test   %eax,%eax
 19b:	7e 17                	jle    1b4 <gets+0x49>
      break;
    buf[i++] = c;
 19d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a1:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1a4:	3c 0a                	cmp    $0xa,%al
 1a6:	0f 94 c2             	sete   %dl
 1a9:	3c 0d                	cmp    $0xd,%al
 1ab:	0f 94 c0             	sete   %al
 1ae:	08 c2                	or     %al,%dl
 1b0:	74 ca                	je     17c <gets+0x11>
    buf[i++] = c;
 1b2:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1b4:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1b8:	89 f8                	mov    %edi,%eax
 1ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1bd:	5b                   	pop    %ebx
 1be:	5e                   	pop    %esi
 1bf:	5f                   	pop    %edi
 1c0:	5d                   	pop    %ebp
 1c1:	c3                   	ret    

000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	56                   	push   %esi
 1c6:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c7:	83 ec 08             	sub    $0x8,%esp
 1ca:	6a 00                	push   $0x0
 1cc:	ff 75 08             	push   0x8(%ebp)
 1cf:	e8 d6 00 00 00       	call   2aa <open>
  if(fd < 0)
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	85 c0                	test   %eax,%eax
 1d9:	78 24                	js     1ff <stat+0x3d>
 1db:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1dd:	83 ec 08             	sub    $0x8,%esp
 1e0:	ff 75 0c             	push   0xc(%ebp)
 1e3:	50                   	push   %eax
 1e4:	e8 d9 00 00 00       	call   2c2 <fstat>
 1e9:	89 c6                	mov    %eax,%esi
  close(fd);
 1eb:	89 1c 24             	mov    %ebx,(%esp)
 1ee:	e8 9f 00 00 00       	call   292 <close>
  return r;
 1f3:	83 c4 10             	add    $0x10,%esp
}
 1f6:	89 f0                	mov    %esi,%eax
 1f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1fb:	5b                   	pop    %ebx
 1fc:	5e                   	pop    %esi
 1fd:	5d                   	pop    %ebp
 1fe:	c3                   	ret    
    return -1;
 1ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
 204:	eb f0                	jmp    1f6 <stat+0x34>

00000206 <atoi>:

int
atoi(const char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	53                   	push   %ebx
 20a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 20d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 212:	eb 10                	jmp    224 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 214:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 217:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 21a:	83 c1 01             	add    $0x1,%ecx
 21d:	0f be c0             	movsbl %al,%eax
 220:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 224:	0f b6 01             	movzbl (%ecx),%eax
 227:	8d 58 d0             	lea    -0x30(%eax),%ebx
 22a:	80 fb 09             	cmp    $0x9,%bl
 22d:	76 e5                	jbe    214 <atoi+0xe>
  return n;
}
 22f:	89 d0                	mov    %edx,%eax
 231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	56                   	push   %esi
 23a:	53                   	push   %ebx
 23b:	8b 75 08             	mov    0x8(%ebp),%esi
 23e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 241:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 244:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 246:	eb 0d                	jmp    255 <memmove+0x1f>
    *dst++ = *src++;
 248:	0f b6 01             	movzbl (%ecx),%eax
 24b:	88 02                	mov    %al,(%edx)
 24d:	8d 49 01             	lea    0x1(%ecx),%ecx
 250:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 253:	89 d8                	mov    %ebx,%eax
 255:	8d 58 ff             	lea    -0x1(%eax),%ebx
 258:	85 c0                	test   %eax,%eax
 25a:	7f ec                	jg     248 <memmove+0x12>
  return vdst;
}
 25c:	89 f0                	mov    %esi,%eax
 25e:	5b                   	pop    %ebx
 25f:	5e                   	pop    %esi
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 262:	b8 01 00 00 00       	mov    $0x1,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <exit>:
SYSCALL(exit)
 26a:	b8 02 00 00 00       	mov    $0x2,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <wait>:
SYSCALL(wait)
 272:	b8 03 00 00 00       	mov    $0x3,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <pipe>:
SYSCALL(pipe)
 27a:	b8 04 00 00 00       	mov    $0x4,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <read>:
SYSCALL(read)
 282:	b8 05 00 00 00       	mov    $0x5,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <write>:
SYSCALL(write)
 28a:	b8 10 00 00 00       	mov    $0x10,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <close>:
SYSCALL(close)
 292:	b8 15 00 00 00       	mov    $0x15,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <kill>:
SYSCALL(kill)
 29a:	b8 06 00 00 00       	mov    $0x6,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exec>:
SYSCALL(exec)
 2a2:	b8 07 00 00 00       	mov    $0x7,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <open>:
SYSCALL(open)
 2aa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <mknod>:
SYSCALL(mknod)
 2b2:	b8 11 00 00 00       	mov    $0x11,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <unlink>:
SYSCALL(unlink)
 2ba:	b8 12 00 00 00       	mov    $0x12,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <fstat>:
SYSCALL(fstat)
 2c2:	b8 08 00 00 00       	mov    $0x8,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <link>:
SYSCALL(link)
 2ca:	b8 13 00 00 00       	mov    $0x13,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <mkdir>:
SYSCALL(mkdir)
 2d2:	b8 14 00 00 00       	mov    $0x14,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <chdir>:
SYSCALL(chdir)
 2da:	b8 09 00 00 00       	mov    $0x9,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <dup>:
SYSCALL(dup)
 2e2:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <getpid>:
SYSCALL(getpid)
 2ea:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <sbrk>:
SYSCALL(sbrk)
 2f2:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <sleep>:
SYSCALL(sleep)
 2fa:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <uptime>:
SYSCALL(uptime)
 302:	b8 0e 00 00 00       	mov    $0xe,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <hello>:
SYSCALL(hello)
 30a:	b8 16 00 00 00       	mov    $0x16,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <helloYou>:
SYSCALL(helloYou)
 312:	b8 17 00 00 00       	mov    $0x17,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <getppid>:
SYSCALL(getppid)
 31a:	b8 18 00 00 00       	mov    $0x18,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <get_siblings_info>:
SYSCALL(get_siblings_info)
 322:	b8 19 00 00 00       	mov    $0x19,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <signalProcess>:
SYSCALL(signalProcess)
 32a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <numvp>:
SYSCALL(numvp)
 332:	b8 1b 00 00 00       	mov    $0x1b,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <numpp>:
 33a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
 345:	83 ec 1c             	sub    $0x1c,%esp
 348:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 34b:	6a 01                	push   $0x1
 34d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 350:	52                   	push   %edx
 351:	50                   	push   %eax
 352:	e8 33 ff ff ff       	call   28a <write>
}
 357:	83 c4 10             	add    $0x10,%esp
 35a:	c9                   	leave  
 35b:	c3                   	ret    

0000035c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 2c             	sub    $0x2c,%esp
 365:	89 45 d0             	mov    %eax,-0x30(%ebp)
 368:	89 d0                	mov    %edx,%eax
 36a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 370:	0f 95 c1             	setne  %cl
 373:	c1 ea 1f             	shr    $0x1f,%edx
 376:	84 d1                	test   %dl,%cl
 378:	74 44                	je     3be <printint+0x62>
    neg = 1;
    x = -xx;
 37a:	f7 d8                	neg    %eax
 37c:	89 c1                	mov    %eax,%ecx
    neg = 1;
 37e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 385:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 38a:	89 c8                	mov    %ecx,%eax
 38c:	ba 00 00 00 00       	mov    $0x0,%edx
 391:	f7 f6                	div    %esi
 393:	89 df                	mov    %ebx,%edi
 395:	83 c3 01             	add    $0x1,%ebx
 398:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 39f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a3:	89 ca                	mov    %ecx,%edx
 3a5:	89 c1                	mov    %eax,%ecx
 3a7:	39 d6                	cmp    %edx,%esi
 3a9:	76 df                	jbe    38a <printint+0x2e>
  if(neg)
 3ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3af:	74 31                	je     3e2 <printint+0x86>
    buf[i++] = '-';
 3b1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b6:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3bc:	eb 17                	jmp    3d5 <printint+0x79>
    x = xx;
 3be:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3c0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c7:	eb bc                	jmp    385 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3ce:	89 f0                	mov    %esi,%eax
 3d0:	e8 6d ff ff ff       	call   342 <putc>
  while(--i >= 0)
 3d5:	83 eb 01             	sub    $0x1,%ebx
 3d8:	79 ef                	jns    3c9 <printint+0x6d>
}
 3da:	83 c4 2c             	add    $0x2c,%esp
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5f                   	pop    %edi
 3e0:	5d                   	pop    %ebp
 3e1:	c3                   	ret    
 3e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e5:	eb ee                	jmp    3d5 <printint+0x79>

000003e7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	57                   	push   %edi
 3eb:	56                   	push   %esi
 3ec:	53                   	push   %ebx
 3ed:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f0:	8d 45 10             	lea    0x10(%ebp),%eax
 3f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 400:	eb 14                	jmp    416 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 402:	89 fa                	mov    %edi,%edx
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	e8 36 ff ff ff       	call   342 <putc>
 40c:	eb 05                	jmp    413 <printf+0x2c>
      }
    } else if(state == '%'){
 40e:	83 fe 25             	cmp    $0x25,%esi
 411:	74 25                	je     438 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 413:	83 c3 01             	add    $0x1,%ebx
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 41d:	84 c0                	test   %al,%al
 41f:	0f 84 20 01 00 00    	je     545 <printf+0x15e>
    c = fmt[i] & 0xff;
 425:	0f be f8             	movsbl %al,%edi
 428:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 42b:	85 f6                	test   %esi,%esi
 42d:	75 df                	jne    40e <printf+0x27>
      if(c == '%'){
 42f:	83 f8 25             	cmp    $0x25,%eax
 432:	75 ce                	jne    402 <printf+0x1b>
        state = '%';
 434:	89 c6                	mov    %eax,%esi
 436:	eb db                	jmp    413 <printf+0x2c>
      if(c == 'd'){
 438:	83 f8 25             	cmp    $0x25,%eax
 43b:	0f 84 cf 00 00 00    	je     510 <printf+0x129>
 441:	0f 8c dd 00 00 00    	jl     524 <printf+0x13d>
 447:	83 f8 78             	cmp    $0x78,%eax
 44a:	0f 8f d4 00 00 00    	jg     524 <printf+0x13d>
 450:	83 f8 63             	cmp    $0x63,%eax
 453:	0f 8c cb 00 00 00    	jl     524 <printf+0x13d>
 459:	83 e8 63             	sub    $0x63,%eax
 45c:	83 f8 15             	cmp    $0x15,%eax
 45f:	0f 87 bf 00 00 00    	ja     524 <printf+0x13d>
 465:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
        printint(fd, *ap, 10, 1);
 46c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46f:	8b 17                	mov    (%edi),%edx
 471:	83 ec 0c             	sub    $0xc,%esp
 474:	6a 01                	push   $0x1
 476:	b9 0a 00 00 00       	mov    $0xa,%ecx
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	e8 d9 fe ff ff       	call   35c <printint>
        ap++;
 483:	83 c7 04             	add    $0x4,%edi
 486:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 489:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 48c:	be 00 00 00 00       	mov    $0x0,%esi
 491:	eb 80                	jmp    413 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 496:	8b 17                	mov    (%edi),%edx
 498:	83 ec 0c             	sub    $0xc,%esp
 49b:	6a 00                	push   $0x0
 49d:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 b2 fe ff ff       	call   35c <printint>
        ap++;
 4aa:	83 c7 04             	add    $0x4,%edi
 4ad:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b3:	be 00 00 00 00       	mov    $0x0,%esi
 4b8:	e9 56 ff ff ff       	jmp    413 <printf+0x2c>
        s = (char*)*ap;
 4bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c0:	8b 30                	mov    (%eax),%esi
        ap++;
 4c2:	83 c0 04             	add    $0x4,%eax
 4c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c8:	85 f6                	test   %esi,%esi
 4ca:	75 15                	jne    4e1 <printf+0xfa>
          s = "(null)";
 4cc:	be f9 06 00 00       	mov    $0x6f9,%esi
 4d1:	eb 0e                	jmp    4e1 <printf+0xfa>
          putc(fd, *s);
 4d3:	0f be d2             	movsbl %dl,%edx
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	e8 64 fe ff ff       	call   342 <putc>
          s++;
 4de:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4e1:	0f b6 16             	movzbl (%esi),%edx
 4e4:	84 d2                	test   %dl,%dl
 4e6:	75 eb                	jne    4d3 <printf+0xec>
      state = 0;
 4e8:	be 00 00 00 00       	mov    $0x0,%esi
 4ed:	e9 21 ff ff ff       	jmp    413 <printf+0x2c>
        putc(fd, *ap);
 4f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f5:	0f be 17             	movsbl (%edi),%edx
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	e8 42 fe ff ff       	call   342 <putc>
        ap++;
 500:	83 c7 04             	add    $0x4,%edi
 503:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 506:	be 00 00 00 00       	mov    $0x0,%esi
 50b:	e9 03 ff ff ff       	jmp    413 <printf+0x2c>
        putc(fd, c);
 510:	89 fa                	mov    %edi,%edx
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	e8 28 fe ff ff       	call   342 <putc>
      state = 0;
 51a:	be 00 00 00 00       	mov    $0x0,%esi
 51f:	e9 ef fe ff ff       	jmp    413 <printf+0x2c>
        putc(fd, '%');
 524:	ba 25 00 00 00       	mov    $0x25,%edx
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	e8 11 fe ff ff       	call   342 <putc>
        putc(fd, c);
 531:	89 fa                	mov    %edi,%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 07 fe ff ff       	call   342 <putc>
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	e9 ce fe ff ff       	jmp    413 <printf+0x2c>
    }
  }
}
 545:	8d 65 f4             	lea    -0xc(%ebp),%esp
 548:	5b                   	pop    %ebx
 549:	5e                   	pop    %esi
 54a:	5f                   	pop    %edi
 54b:	5d                   	pop    %ebp
 54c:	c3                   	ret    

0000054d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54d:	55                   	push   %ebp
 54e:	89 e5                	mov    %esp,%ebp
 550:	57                   	push   %edi
 551:	56                   	push   %esi
 552:	53                   	push   %ebx
 553:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 556:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 559:	a1 fc 09 00 00       	mov    0x9fc,%eax
 55e:	eb 02                	jmp    562 <free+0x15>
 560:	89 d0                	mov    %edx,%eax
 562:	39 c8                	cmp    %ecx,%eax
 564:	73 04                	jae    56a <free+0x1d>
 566:	39 08                	cmp    %ecx,(%eax)
 568:	77 12                	ja     57c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56a:	8b 10                	mov    (%eax),%edx
 56c:	39 c2                	cmp    %eax,%edx
 56e:	77 f0                	ja     560 <free+0x13>
 570:	39 c8                	cmp    %ecx,%eax
 572:	72 08                	jb     57c <free+0x2f>
 574:	39 ca                	cmp    %ecx,%edx
 576:	77 04                	ja     57c <free+0x2f>
 578:	89 d0                	mov    %edx,%eax
 57a:	eb e6                	jmp    562 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 57c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 582:	8b 10                	mov    (%eax),%edx
 584:	39 d7                	cmp    %edx,%edi
 586:	74 19                	je     5a1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 588:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 58b:	8b 50 04             	mov    0x4(%eax),%edx
 58e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 591:	39 ce                	cmp    %ecx,%esi
 593:	74 1b                	je     5b0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 595:	89 08                	mov    %ecx,(%eax)
  freep = p;
 597:	a3 fc 09 00 00       	mov    %eax,0x9fc
}
 59c:	5b                   	pop    %ebx
 59d:	5e                   	pop    %esi
 59e:	5f                   	pop    %edi
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5a1:	03 72 04             	add    0x4(%edx),%esi
 5a4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a7:	8b 10                	mov    (%eax),%edx
 5a9:	8b 12                	mov    (%edx),%edx
 5ab:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5ae:	eb db                	jmp    58b <free+0x3e>
    p->s.size += bp->s.size;
 5b0:	03 53 fc             	add    -0x4(%ebx),%edx
 5b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b9:	89 10                	mov    %edx,(%eax)
 5bb:	eb da                	jmp    597 <free+0x4a>

000005bd <morecore>:

static Header*
morecore(uint nu)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	53                   	push   %ebx
 5c1:	83 ec 04             	sub    $0x4,%esp
 5c4:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5cb:	77 05                	ja     5d2 <morecore+0x15>
    nu = 4096;
 5cd:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5d2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d9:	83 ec 0c             	sub    $0xc,%esp
 5dc:	50                   	push   %eax
 5dd:	e8 10 fd ff ff       	call   2f2 <sbrk>
  if(p == (char*)-1)
 5e2:	83 c4 10             	add    $0x10,%esp
 5e5:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e8:	74 1c                	je     606 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5ea:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ed:	83 c0 08             	add    $0x8,%eax
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	50                   	push   %eax
 5f4:	e8 54 ff ff ff       	call   54d <free>
  return freep;
 5f9:	a1 fc 09 00 00       	mov    0x9fc,%eax
 5fe:	83 c4 10             	add    $0x10,%esp
}
 601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 604:	c9                   	leave  
 605:	c3                   	ret    
    return 0;
 606:	b8 00 00 00 00       	mov    $0x0,%eax
 60b:	eb f4                	jmp    601 <morecore+0x44>

0000060d <malloc>:

void*
malloc(uint nbytes)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	53                   	push   %ebx
 611:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	8d 58 07             	lea    0x7(%eax),%ebx
 61a:	c1 eb 03             	shr    $0x3,%ebx
 61d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 620:	8b 0d fc 09 00 00    	mov    0x9fc,%ecx
 626:	85 c9                	test   %ecx,%ecx
 628:	74 04                	je     62e <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62a:	8b 01                	mov    (%ecx),%eax
 62c:	eb 4a                	jmp    678 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 62e:	c7 05 fc 09 00 00 00 	movl   $0xa00,0x9fc
 635:	0a 00 00 
 638:	c7 05 00 0a 00 00 00 	movl   $0xa00,0xa00
 63f:	0a 00 00 
    base.s.size = 0;
 642:	c7 05 04 0a 00 00 00 	movl   $0x0,0xa04
 649:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 64c:	b9 00 0a 00 00       	mov    $0xa00,%ecx
 651:	eb d7                	jmp    62a <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 653:	74 19                	je     66e <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 655:	29 da                	sub    %ebx,%edx
 657:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 65a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 65d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 660:	89 0d fc 09 00 00    	mov    %ecx,0x9fc
      return (void*)(p + 1);
 666:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66c:	c9                   	leave  
 66d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 66e:	8b 10                	mov    (%eax),%edx
 670:	89 11                	mov    %edx,(%ecx)
 672:	eb ec                	jmp    660 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 674:	89 c1                	mov    %eax,%ecx
 676:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 678:	8b 50 04             	mov    0x4(%eax),%edx
 67b:	39 da                	cmp    %ebx,%edx
 67d:	73 d4                	jae    653 <malloc+0x46>
    if(p == freep)
 67f:	39 05 fc 09 00 00    	cmp    %eax,0x9fc
 685:	75 ed                	jne    674 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 687:	89 d8                	mov    %ebx,%eax
 689:	e8 2f ff ff ff       	call   5bd <morecore>
 68e:	85 c0                	test   %eax,%eax
 690:	75 e2                	jne    674 <malloc+0x67>
 692:	eb d5                	jmp    669 <malloc+0x5c>
