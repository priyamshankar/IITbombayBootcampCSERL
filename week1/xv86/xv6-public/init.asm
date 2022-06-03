
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 98 06 00 00       	push   $0x698
  19:	e8 9e 02 00 00       	call   2bc <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 1b                	js     40 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 c5 02 00 00       	call   2f4 <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 b9 02 00 00       	call   2f4 <dup>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb 58                	jmp    98 <main+0x98>
    mknod("console", 1, 1);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	6a 01                	push   $0x1
  45:	6a 01                	push   $0x1
  47:	68 98 06 00 00       	push   $0x698
  4c:	e8 73 02 00 00       	call   2c4 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 98 06 00 00       	push   $0x698
  5b:	e8 5c 02 00 00       	call   2bc <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 b3 06 00 00       	push   $0x6b3
  6d:	6a 01                	push   $0x1
  6f:	e8 75 03 00 00       	call   3e9 <printf>
      exit();
  74:	e8 03 02 00 00       	call   27c <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 df 06 00 00       	push   $0x6df
  81:	6a 01                	push   $0x1
  83:	e8 61 03 00 00       	call   3e9 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 f4 01 00 00       	call   284 <wait>
  90:	85 c0                	test   %eax,%eax
  92:	78 04                	js     98 <main+0x98>
  94:	39 c3                	cmp    %eax,%ebx
  96:	75 e1                	jne    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 a0 06 00 00       	push   $0x6a0
  a0:	6a 01                	push   $0x1
  a2:	e8 42 03 00 00       	call   3e9 <printf>
    pid = fork();
  a7:	e8 c8 01 00 00       	call   274 <fork>
  ac:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	78 b0                	js     65 <main+0x65>
    if(pid == 0){
  b5:	75 d4                	jne    8b <main+0x8b>
      exec("sh", argv);
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 ec 09 00 00       	push   $0x9ec
  bf:	68 c6 06 00 00       	push   $0x6c6
  c4:	e8 eb 01 00 00       	call   2b4 <exec>
      printf(1, "init: exec sh failed\n");
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	68 c9 06 00 00       	push   $0x6c9
  d1:	6a 01                	push   $0x1
  d3:	e8 11 03 00 00       	call   3e9 <printf>
      exit();
  d8:	e8 9f 01 00 00       	call   27c <exit>

000000dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	56                   	push   %esi
  e1:	53                   	push   %ebx
  e2:	8b 75 08             	mov    0x8(%ebp),%esi
  e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	89 f0                	mov    %esi,%eax
  ea:	89 d1                	mov    %edx,%ecx
  ec:	83 c2 01             	add    $0x1,%edx
  ef:	89 c3                	mov    %eax,%ebx
  f1:	83 c0 01             	add    $0x1,%eax
  f4:	0f b6 09             	movzbl (%ecx),%ecx
  f7:	88 0b                	mov    %cl,(%ebx)
  f9:	84 c9                	test   %cl,%cl
  fb:	75 ed                	jne    ea <strcpy+0xd>
    ;
  return os;
}
  fd:	89 f0                	mov    %esi,%eax
  ff:	5b                   	pop    %ebx
 100:	5e                   	pop    %esi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    

00000103 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10c:	eb 06                	jmp    114 <strcmp+0x11>
    p++, q++;
 10e:	83 c1 01             	add    $0x1,%ecx
 111:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 114:	0f b6 01             	movzbl (%ecx),%eax
 117:	84 c0                	test   %al,%al
 119:	74 04                	je     11f <strcmp+0x1c>
 11b:	3a 02                	cmp    (%edx),%al
 11d:	74 ef                	je     10e <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 11f:	0f b6 c0             	movzbl %al,%eax
 122:	0f b6 12             	movzbl (%edx),%edx
 125:	29 d0                	sub    %edx,%eax
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret    

00000129 <strlen>:

uint
strlen(const char *s)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb 03                	jmp    139 <strlen+0x10>
 136:	83 c0 01             	add    $0x1,%eax
 139:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 13d:	75 f7                	jne    136 <strlen+0xd>
    ;
  return n;
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <memset>:

void*
memset(void *dst, int c, uint n)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	57                   	push   %edi
 145:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 148:	89 d7                	mov    %edx,%edi
 14a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 153:	89 d0                	mov    %edx,%eax
 155:	8b 7d fc             	mov    -0x4(%ebp),%edi
 158:	c9                   	leave  
 159:	c3                   	ret    

0000015a <strchr>:

char*
strchr(const char *s, char c)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 164:	eb 03                	jmp    169 <strchr+0xf>
 166:	83 c0 01             	add    $0x1,%eax
 169:	0f b6 10             	movzbl (%eax),%edx
 16c:	84 d2                	test   %dl,%dl
 16e:	74 06                	je     176 <strchr+0x1c>
    if(*s == c)
 170:	38 ca                	cmp    %cl,%dl
 172:	75 f2                	jne    166 <strchr+0xc>
 174:	eb 05                	jmp    17b <strchr+0x21>
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	57                   	push   %edi
 181:	56                   	push   %esi
 182:	53                   	push   %ebx
 183:	83 ec 1c             	sub    $0x1c,%esp
 186:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 189:	bb 00 00 00 00       	mov    $0x0,%ebx
 18e:	89 de                	mov    %ebx,%esi
 190:	83 c3 01             	add    $0x1,%ebx
 193:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 196:	7d 2e                	jge    1c6 <gets+0x49>
    cc = read(0, &c, 1);
 198:	83 ec 04             	sub    $0x4,%esp
 19b:	6a 01                	push   $0x1
 19d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1a0:	50                   	push   %eax
 1a1:	6a 00                	push   $0x0
 1a3:	e8 ec 00 00 00       	call   294 <read>
    if(cc < 1)
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	85 c0                	test   %eax,%eax
 1ad:	7e 17                	jle    1c6 <gets+0x49>
      break;
    buf[i++] = c;
 1af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b3:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1b6:	3c 0a                	cmp    $0xa,%al
 1b8:	0f 94 c2             	sete   %dl
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	0f 94 c0             	sete   %al
 1c0:	08 c2                	or     %al,%dl
 1c2:	74 ca                	je     18e <gets+0x11>
    buf[i++] = c;
 1c4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1c6:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1ca:	89 f8                	mov    %edi,%eax
 1cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5f                   	pop    %edi
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    

000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	56                   	push   %esi
 1d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	6a 00                	push   $0x0
 1de:	ff 75 08             	push   0x8(%ebp)
 1e1:	e8 d6 00 00 00       	call   2bc <open>
  if(fd < 0)
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	85 c0                	test   %eax,%eax
 1eb:	78 24                	js     211 <stat+0x3d>
 1ed:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1ef:	83 ec 08             	sub    $0x8,%esp
 1f2:	ff 75 0c             	push   0xc(%ebp)
 1f5:	50                   	push   %eax
 1f6:	e8 d9 00 00 00       	call   2d4 <fstat>
 1fb:	89 c6                	mov    %eax,%esi
  close(fd);
 1fd:	89 1c 24             	mov    %ebx,(%esp)
 200:	e8 9f 00 00 00       	call   2a4 <close>
  return r;
 205:	83 c4 10             	add    $0x10,%esp
}
 208:	89 f0                	mov    %esi,%eax
 20a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 20d:	5b                   	pop    %ebx
 20e:	5e                   	pop    %esi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
    return -1;
 211:	be ff ff ff ff       	mov    $0xffffffff,%esi
 216:	eb f0                	jmp    208 <stat+0x34>

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	53                   	push   %ebx
 21c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 21f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 224:	eb 10                	jmp    236 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 226:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 229:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 22c:	83 c1 01             	add    $0x1,%ecx
 22f:	0f be c0             	movsbl %al,%eax
 232:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 236:	0f b6 01             	movzbl (%ecx),%eax
 239:	8d 58 d0             	lea    -0x30(%eax),%ebx
 23c:	80 fb 09             	cmp    $0x9,%bl
 23f:	76 e5                	jbe    226 <atoi+0xe>
  return n;
}
 241:	89 d0                	mov    %edx,%eax
 243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	56                   	push   %esi
 24c:	53                   	push   %ebx
 24d:	8b 75 08             	mov    0x8(%ebp),%esi
 250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 253:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 256:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 258:	eb 0d                	jmp    267 <memmove+0x1f>
    *dst++ = *src++;
 25a:	0f b6 01             	movzbl (%ecx),%eax
 25d:	88 02                	mov    %al,(%edx)
 25f:	8d 49 01             	lea    0x1(%ecx),%ecx
 262:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 265:	89 d8                	mov    %ebx,%eax
 267:	8d 58 ff             	lea    -0x1(%eax),%ebx
 26a:	85 c0                	test   %eax,%eax
 26c:	7f ec                	jg     25a <memmove+0x12>
  return vdst;
}
 26e:	89 f0                	mov    %esi,%eax
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    

00000274 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 274:	b8 01 00 00 00       	mov    $0x1,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <exit>:
SYSCALL(exit)
 27c:	b8 02 00 00 00       	mov    $0x2,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <wait>:
SYSCALL(wait)
 284:	b8 03 00 00 00       	mov    $0x3,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <pipe>:
SYSCALL(pipe)
 28c:	b8 04 00 00 00       	mov    $0x4,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <read>:
SYSCALL(read)
 294:	b8 05 00 00 00       	mov    $0x5,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <write>:
SYSCALL(write)
 29c:	b8 10 00 00 00       	mov    $0x10,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <close>:
SYSCALL(close)
 2a4:	b8 15 00 00 00       	mov    $0x15,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <kill>:
SYSCALL(kill)
 2ac:	b8 06 00 00 00       	mov    $0x6,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <exec>:
SYSCALL(exec)
 2b4:	b8 07 00 00 00       	mov    $0x7,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <open>:
SYSCALL(open)
 2bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <mknod>:
SYSCALL(mknod)
 2c4:	b8 11 00 00 00       	mov    $0x11,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <unlink>:
SYSCALL(unlink)
 2cc:	b8 12 00 00 00       	mov    $0x12,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <fstat>:
SYSCALL(fstat)
 2d4:	b8 08 00 00 00       	mov    $0x8,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <link>:
SYSCALL(link)
 2dc:	b8 13 00 00 00       	mov    $0x13,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mkdir>:
SYSCALL(mkdir)
 2e4:	b8 14 00 00 00       	mov    $0x14,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <chdir>:
SYSCALL(chdir)
 2ec:	b8 09 00 00 00       	mov    $0x9,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <dup>:
SYSCALL(dup)
 2f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <getpid>:
SYSCALL(getpid)
 2fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sbrk>:
SYSCALL(sbrk)
 304:	b8 0c 00 00 00       	mov    $0xc,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <sleep>:
SYSCALL(sleep)
 30c:	b8 0d 00 00 00       	mov    $0xd,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <uptime>:
SYSCALL(uptime)
 314:	b8 0e 00 00 00       	mov    $0xe,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <hello>:
SYSCALL(hello)
 31c:	b8 16 00 00 00       	mov    $0x16,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <helloYou>:
SYSCALL(helloYou)
 324:	b8 17 00 00 00       	mov    $0x17,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <getppid>:
SYSCALL(getppid)
 32c:	b8 18 00 00 00       	mov    $0x18,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <get_siblings_info>:
SYSCALL(get_siblings_info)
 334:	b8 19 00 00 00       	mov    $0x19,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <signalProcess>:
 33c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 1c             	sub    $0x1c,%esp
 34a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 34d:	6a 01                	push   $0x1
 34f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 352:	52                   	push   %edx
 353:	50                   	push   %eax
 354:	e8 43 ff ff ff       	call   29c <write>
}
 359:	83 c4 10             	add    $0x10,%esp
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	57                   	push   %edi
 362:	56                   	push   %esi
 363:	53                   	push   %ebx
 364:	83 ec 2c             	sub    $0x2c,%esp
 367:	89 45 d0             	mov    %eax,-0x30(%ebp)
 36a:	89 d0                	mov    %edx,%eax
 36c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 372:	0f 95 c1             	setne  %cl
 375:	c1 ea 1f             	shr    $0x1f,%edx
 378:	84 d1                	test   %dl,%cl
 37a:	74 44                	je     3c0 <printint+0x62>
    neg = 1;
    x = -xx;
 37c:	f7 d8                	neg    %eax
 37e:	89 c1                	mov    %eax,%ecx
    neg = 1;
 380:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 387:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 38c:	89 c8                	mov    %ecx,%eax
 38e:	ba 00 00 00 00       	mov    $0x0,%edx
 393:	f7 f6                	div    %esi
 395:	89 df                	mov    %ebx,%edi
 397:	83 c3 01             	add    $0x1,%ebx
 39a:	0f b6 92 48 07 00 00 	movzbl 0x748(%edx),%edx
 3a1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a5:	89 ca                	mov    %ecx,%edx
 3a7:	89 c1                	mov    %eax,%ecx
 3a9:	39 d6                	cmp    %edx,%esi
 3ab:	76 df                	jbe    38c <printint+0x2e>
  if(neg)
 3ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3b1:	74 31                	je     3e4 <printint+0x86>
    buf[i++] = '-';
 3b3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b8:	8d 5f 02             	lea    0x2(%edi),%ebx
 3bb:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3be:	eb 17                	jmp    3d7 <printint+0x79>
    x = xx;
 3c0:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3c2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c9:	eb bc                	jmp    387 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3cb:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3d0:	89 f0                	mov    %esi,%eax
 3d2:	e8 6d ff ff ff       	call   344 <putc>
  while(--i >= 0)
 3d7:	83 eb 01             	sub    $0x1,%ebx
 3da:	79 ef                	jns    3cb <printint+0x6d>
}
 3dc:	83 c4 2c             	add    $0x2c,%esp
 3df:	5b                   	pop    %ebx
 3e0:	5e                   	pop    %esi
 3e1:	5f                   	pop    %edi
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e7:	eb ee                	jmp    3d7 <printint+0x79>

000003e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	57                   	push   %edi
 3ed:	56                   	push   %esi
 3ee:	53                   	push   %ebx
 3ef:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f2:	8d 45 10             	lea    0x10(%ebp),%eax
 3f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f8:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3fd:	bb 00 00 00 00       	mov    $0x0,%ebx
 402:	eb 14                	jmp    418 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 404:	89 fa                	mov    %edi,%edx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	e8 36 ff ff ff       	call   344 <putc>
 40e:	eb 05                	jmp    415 <printf+0x2c>
      }
    } else if(state == '%'){
 410:	83 fe 25             	cmp    $0x25,%esi
 413:	74 25                	je     43a <printf+0x51>
  for(i = 0; fmt[i]; i++){
 415:	83 c3 01             	add    $0x1,%ebx
 418:	8b 45 0c             	mov    0xc(%ebp),%eax
 41b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 41f:	84 c0                	test   %al,%al
 421:	0f 84 20 01 00 00    	je     547 <printf+0x15e>
    c = fmt[i] & 0xff;
 427:	0f be f8             	movsbl %al,%edi
 42a:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 42d:	85 f6                	test   %esi,%esi
 42f:	75 df                	jne    410 <printf+0x27>
      if(c == '%'){
 431:	83 f8 25             	cmp    $0x25,%eax
 434:	75 ce                	jne    404 <printf+0x1b>
        state = '%';
 436:	89 c6                	mov    %eax,%esi
 438:	eb db                	jmp    415 <printf+0x2c>
      if(c == 'd'){
 43a:	83 f8 25             	cmp    $0x25,%eax
 43d:	0f 84 cf 00 00 00    	je     512 <printf+0x129>
 443:	0f 8c dd 00 00 00    	jl     526 <printf+0x13d>
 449:	83 f8 78             	cmp    $0x78,%eax
 44c:	0f 8f d4 00 00 00    	jg     526 <printf+0x13d>
 452:	83 f8 63             	cmp    $0x63,%eax
 455:	0f 8c cb 00 00 00    	jl     526 <printf+0x13d>
 45b:	83 e8 63             	sub    $0x63,%eax
 45e:	83 f8 15             	cmp    $0x15,%eax
 461:	0f 87 bf 00 00 00    	ja     526 <printf+0x13d>
 467:	ff 24 85 f0 06 00 00 	jmp    *0x6f0(,%eax,4)
        printint(fd, *ap, 10, 1);
 46e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 471:	8b 17                	mov    (%edi),%edx
 473:	83 ec 0c             	sub    $0xc,%esp
 476:	6a 01                	push   $0x1
 478:	b9 0a 00 00 00       	mov    $0xa,%ecx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 d9 fe ff ff       	call   35e <printint>
        ap++;
 485:	83 c7 04             	add    $0x4,%edi
 488:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 48b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 48e:	be 00 00 00 00       	mov    $0x0,%esi
 493:	eb 80                	jmp    415 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 498:	8b 17                	mov    (%edi),%edx
 49a:	83 ec 0c             	sub    $0xc,%esp
 49d:	6a 00                	push   $0x0
 49f:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	e8 b2 fe ff ff       	call   35e <printint>
        ap++;
 4ac:	83 c7 04             	add    $0x4,%edi
 4af:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b5:	be 00 00 00 00       	mov    $0x0,%esi
 4ba:	e9 56 ff ff ff       	jmp    415 <printf+0x2c>
        s = (char*)*ap;
 4bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c2:	8b 30                	mov    (%eax),%esi
        ap++;
 4c4:	83 c0 04             	add    $0x4,%eax
 4c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4ca:	85 f6                	test   %esi,%esi
 4cc:	75 15                	jne    4e3 <printf+0xfa>
          s = "(null)";
 4ce:	be e8 06 00 00       	mov    $0x6e8,%esi
 4d3:	eb 0e                	jmp    4e3 <printf+0xfa>
          putc(fd, *s);
 4d5:	0f be d2             	movsbl %dl,%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 64 fe ff ff       	call   344 <putc>
          s++;
 4e0:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4e3:	0f b6 16             	movzbl (%esi),%edx
 4e6:	84 d2                	test   %dl,%dl
 4e8:	75 eb                	jne    4d5 <printf+0xec>
      state = 0;
 4ea:	be 00 00 00 00       	mov    $0x0,%esi
 4ef:	e9 21 ff ff ff       	jmp    415 <printf+0x2c>
        putc(fd, *ap);
 4f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f7:	0f be 17             	movsbl (%edi),%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 42 fe ff ff       	call   344 <putc>
        ap++;
 502:	83 c7 04             	add    $0x4,%edi
 505:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 508:	be 00 00 00 00       	mov    $0x0,%esi
 50d:	e9 03 ff ff ff       	jmp    415 <printf+0x2c>
        putc(fd, c);
 512:	89 fa                	mov    %edi,%edx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	e8 28 fe ff ff       	call   344 <putc>
      state = 0;
 51c:	be 00 00 00 00       	mov    $0x0,%esi
 521:	e9 ef fe ff ff       	jmp    415 <printf+0x2c>
        putc(fd, '%');
 526:	ba 25 00 00 00       	mov    $0x25,%edx
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	e8 11 fe ff ff       	call   344 <putc>
        putc(fd, c);
 533:	89 fa                	mov    %edi,%edx
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	e8 07 fe ff ff       	call   344 <putc>
      state = 0;
 53d:	be 00 00 00 00       	mov    $0x0,%esi
 542:	e9 ce fe ff ff       	jmp    415 <printf+0x2c>
    }
  }
}
 547:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54a:	5b                   	pop    %ebx
 54b:	5e                   	pop    %esi
 54c:	5f                   	pop    %edi
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret    

0000054f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54f:	55                   	push   %ebp
 550:	89 e5                	mov    %esp,%ebp
 552:	57                   	push   %edi
 553:	56                   	push   %esi
 554:	53                   	push   %ebx
 555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 558:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55b:	a1 f4 09 00 00       	mov    0x9f4,%eax
 560:	eb 02                	jmp    564 <free+0x15>
 562:	89 d0                	mov    %edx,%eax
 564:	39 c8                	cmp    %ecx,%eax
 566:	73 04                	jae    56c <free+0x1d>
 568:	39 08                	cmp    %ecx,(%eax)
 56a:	77 12                	ja     57e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56c:	8b 10                	mov    (%eax),%edx
 56e:	39 c2                	cmp    %eax,%edx
 570:	77 f0                	ja     562 <free+0x13>
 572:	39 c8                	cmp    %ecx,%eax
 574:	72 08                	jb     57e <free+0x2f>
 576:	39 ca                	cmp    %ecx,%edx
 578:	77 04                	ja     57e <free+0x2f>
 57a:	89 d0                	mov    %edx,%eax
 57c:	eb e6                	jmp    564 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 57e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 581:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 584:	8b 10                	mov    (%eax),%edx
 586:	39 d7                	cmp    %edx,%edi
 588:	74 19                	je     5a3 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 58a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 58d:	8b 50 04             	mov    0x4(%eax),%edx
 590:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 593:	39 ce                	cmp    %ecx,%esi
 595:	74 1b                	je     5b2 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 597:	89 08                	mov    %ecx,(%eax)
  freep = p;
 599:	a3 f4 09 00 00       	mov    %eax,0x9f4
}
 59e:	5b                   	pop    %ebx
 59f:	5e                   	pop    %esi
 5a0:	5f                   	pop    %edi
 5a1:	5d                   	pop    %ebp
 5a2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5a3:	03 72 04             	add    0x4(%edx),%esi
 5a6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a9:	8b 10                	mov    (%eax),%edx
 5ab:	8b 12                	mov    (%edx),%edx
 5ad:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5b0:	eb db                	jmp    58d <free+0x3e>
    p->s.size += bp->s.size;
 5b2:	03 53 fc             	add    -0x4(%ebx),%edx
 5b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5bb:	89 10                	mov    %edx,(%eax)
 5bd:	eb da                	jmp    599 <free+0x4a>

000005bf <morecore>:

static Header*
morecore(uint nu)
{
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	53                   	push   %ebx
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5cd:	77 05                	ja     5d4 <morecore+0x15>
    nu = 4096;
 5cf:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5d4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5db:	83 ec 0c             	sub    $0xc,%esp
 5de:	50                   	push   %eax
 5df:	e8 20 fd ff ff       	call   304 <sbrk>
  if(p == (char*)-1)
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ea:	74 1c                	je     608 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5ec:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ef:	83 c0 08             	add    $0x8,%eax
 5f2:	83 ec 0c             	sub    $0xc,%esp
 5f5:	50                   	push   %eax
 5f6:	e8 54 ff ff ff       	call   54f <free>
  return freep;
 5fb:	a1 f4 09 00 00       	mov    0x9f4,%eax
 600:	83 c4 10             	add    $0x10,%esp
}
 603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 606:	c9                   	leave  
 607:	c3                   	ret    
    return 0;
 608:	b8 00 00 00 00       	mov    $0x0,%eax
 60d:	eb f4                	jmp    603 <morecore+0x44>

0000060f <malloc>:

void*
malloc(uint nbytes)
{
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	53                   	push   %ebx
 613:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	8d 58 07             	lea    0x7(%eax),%ebx
 61c:	c1 eb 03             	shr    $0x3,%ebx
 61f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 622:	8b 0d f4 09 00 00    	mov    0x9f4,%ecx
 628:	85 c9                	test   %ecx,%ecx
 62a:	74 04                	je     630 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62c:	8b 01                	mov    (%ecx),%eax
 62e:	eb 4a                	jmp    67a <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 630:	c7 05 f4 09 00 00 f8 	movl   $0x9f8,0x9f4
 637:	09 00 00 
 63a:	c7 05 f8 09 00 00 f8 	movl   $0x9f8,0x9f8
 641:	09 00 00 
    base.s.size = 0;
 644:	c7 05 fc 09 00 00 00 	movl   $0x0,0x9fc
 64b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 64e:	b9 f8 09 00 00       	mov    $0x9f8,%ecx
 653:	eb d7                	jmp    62c <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 655:	74 19                	je     670 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 657:	29 da                	sub    %ebx,%edx
 659:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 65c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 65f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 662:	89 0d f4 09 00 00    	mov    %ecx,0x9f4
      return (void*)(p + 1);
 668:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 66b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66e:	c9                   	leave  
 66f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 670:	8b 10                	mov    (%eax),%edx
 672:	89 11                	mov    %edx,(%ecx)
 674:	eb ec                	jmp    662 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 676:	89 c1                	mov    %eax,%ecx
 678:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 67a:	8b 50 04             	mov    0x4(%eax),%edx
 67d:	39 da                	cmp    %ebx,%edx
 67f:	73 d4                	jae    655 <malloc+0x46>
    if(p == freep)
 681:	39 05 f4 09 00 00    	cmp    %eax,0x9f4
 687:	75 ed                	jne    676 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 689:	89 d8                	mov    %ebx,%eax
 68b:	e8 2f ff ff ff       	call   5bf <morecore>
 690:	85 c0                	test   %eax,%eax
 692:	75 e2                	jne    676 <malloc+0x67>
 694:	eb d5                	jmp    66b <malloc+0x5c>
