
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
  14:	68 a8 06 00 00       	push   $0x6a8
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
  47:	68 a8 06 00 00       	push   $0x6a8
  4c:	e8 73 02 00 00       	call   2c4 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 a8 06 00 00       	push   $0x6a8
  5b:	e8 5c 02 00 00       	call   2bc <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 c3 06 00 00       	push   $0x6c3
  6d:	6a 01                	push   $0x1
  6f:	e8 85 03 00 00       	call   3f9 <printf>
      exit();
  74:	e8 03 02 00 00       	call   27c <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 ef 06 00 00       	push   $0x6ef
  81:	6a 01                	push   $0x1
  83:	e8 71 03 00 00       	call   3f9 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 f4 01 00 00       	call   284 <wait>
  90:	85 c0                	test   %eax,%eax
  92:	78 04                	js     98 <main+0x98>
  94:	39 c3                	cmp    %eax,%ebx
  96:	75 e1                	jne    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 b0 06 00 00       	push   $0x6b0
  a0:	6a 01                	push   $0x1
  a2:	e8 52 03 00 00       	call   3f9 <printf>
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
  ba:	68 fc 09 00 00       	push   $0x9fc
  bf:	68 d6 06 00 00       	push   $0x6d6
  c4:	e8 eb 01 00 00       	call   2b4 <exec>
      printf(1, "init: exec sh failed\n");
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	68 d9 06 00 00       	push   $0x6d9
  d1:	6a 01                	push   $0x1
  d3:	e8 21 03 00 00       	call   3f9 <printf>
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
SYSCALL(signalProcess)
 33c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <numvp>:
SYSCALL(numvp)
 344:	b8 1b 00 00 00       	mov    $0x1b,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <numpp>:
 34c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 1c             	sub    $0x1c,%esp
 35a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 35d:	6a 01                	push   $0x1
 35f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 362:	52                   	push   %edx
 363:	50                   	push   %eax
 364:	e8 33 ff ff ff       	call   29c <write>
}
 369:	83 c4 10             	add    $0x10,%esp
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	57                   	push   %edi
 372:	56                   	push   %esi
 373:	53                   	push   %ebx
 374:	83 ec 2c             	sub    $0x2c,%esp
 377:	89 45 d0             	mov    %eax,-0x30(%ebp)
 37a:	89 d0                	mov    %edx,%eax
 37c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 382:	0f 95 c1             	setne  %cl
 385:	c1 ea 1f             	shr    $0x1f,%edx
 388:	84 d1                	test   %dl,%cl
 38a:	74 44                	je     3d0 <printint+0x62>
    neg = 1;
    x = -xx;
 38c:	f7 d8                	neg    %eax
 38e:	89 c1                	mov    %eax,%ecx
    neg = 1;
 390:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 397:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 39c:	89 c8                	mov    %ecx,%eax
 39e:	ba 00 00 00 00       	mov    $0x0,%edx
 3a3:	f7 f6                	div    %esi
 3a5:	89 df                	mov    %ebx,%edi
 3a7:	83 c3 01             	add    $0x1,%ebx
 3aa:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 3b1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3b5:	89 ca                	mov    %ecx,%edx
 3b7:	89 c1                	mov    %eax,%ecx
 3b9:	39 d6                	cmp    %edx,%esi
 3bb:	76 df                	jbe    39c <printint+0x2e>
  if(neg)
 3bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3c1:	74 31                	je     3f4 <printint+0x86>
    buf[i++] = '-';
 3c3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c8:	8d 5f 02             	lea    0x2(%edi),%ebx
 3cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3ce:	eb 17                	jmp    3e7 <printint+0x79>
    x = xx;
 3d0:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3d9:	eb bc                	jmp    397 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3db:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e0:	89 f0                	mov    %esi,%eax
 3e2:	e8 6d ff ff ff       	call   354 <putc>
  while(--i >= 0)
 3e7:	83 eb 01             	sub    $0x1,%ebx
 3ea:	79 ef                	jns    3db <printint+0x6d>
}
 3ec:	83 c4 2c             	add    $0x2c,%esp
 3ef:	5b                   	pop    %ebx
 3f0:	5e                   	pop    %esi
 3f1:	5f                   	pop    %edi
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f7:	eb ee                	jmp    3e7 <printint+0x79>

000003f9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	57                   	push   %edi
 3fd:	56                   	push   %esi
 3fe:	53                   	push   %ebx
 3ff:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 402:	8d 45 10             	lea    0x10(%ebp),%eax
 405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 408:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 40d:	bb 00 00 00 00       	mov    $0x0,%ebx
 412:	eb 14                	jmp    428 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 414:	89 fa                	mov    %edi,%edx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 36 ff ff ff       	call   354 <putc>
 41e:	eb 05                	jmp    425 <printf+0x2c>
      }
    } else if(state == '%'){
 420:	83 fe 25             	cmp    $0x25,%esi
 423:	74 25                	je     44a <printf+0x51>
  for(i = 0; fmt[i]; i++){
 425:	83 c3 01             	add    $0x1,%ebx
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 42f:	84 c0                	test   %al,%al
 431:	0f 84 20 01 00 00    	je     557 <printf+0x15e>
    c = fmt[i] & 0xff;
 437:	0f be f8             	movsbl %al,%edi
 43a:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 43d:	85 f6                	test   %esi,%esi
 43f:	75 df                	jne    420 <printf+0x27>
      if(c == '%'){
 441:	83 f8 25             	cmp    $0x25,%eax
 444:	75 ce                	jne    414 <printf+0x1b>
        state = '%';
 446:	89 c6                	mov    %eax,%esi
 448:	eb db                	jmp    425 <printf+0x2c>
      if(c == 'd'){
 44a:	83 f8 25             	cmp    $0x25,%eax
 44d:	0f 84 cf 00 00 00    	je     522 <printf+0x129>
 453:	0f 8c dd 00 00 00    	jl     536 <printf+0x13d>
 459:	83 f8 78             	cmp    $0x78,%eax
 45c:	0f 8f d4 00 00 00    	jg     536 <printf+0x13d>
 462:	83 f8 63             	cmp    $0x63,%eax
 465:	0f 8c cb 00 00 00    	jl     536 <printf+0x13d>
 46b:	83 e8 63             	sub    $0x63,%eax
 46e:	83 f8 15             	cmp    $0x15,%eax
 471:	0f 87 bf 00 00 00    	ja     536 <printf+0x13d>
 477:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
        printint(fd, *ap, 10, 1);
 47e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 481:	8b 17                	mov    (%edi),%edx
 483:	83 ec 0c             	sub    $0xc,%esp
 486:	6a 01                	push   $0x1
 488:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	e8 d9 fe ff ff       	call   36e <printint>
        ap++;
 495:	83 c7 04             	add    $0x4,%edi
 498:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 49b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 49e:	be 00 00 00 00       	mov    $0x0,%esi
 4a3:	eb 80                	jmp    425 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a8:	8b 17                	mov    (%edi),%edx
 4aa:	83 ec 0c             	sub    $0xc,%esp
 4ad:	6a 00                	push   $0x0
 4af:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	e8 b2 fe ff ff       	call   36e <printint>
        ap++;
 4bc:	83 c7 04             	add    $0x4,%edi
 4bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c5:	be 00 00 00 00       	mov    $0x0,%esi
 4ca:	e9 56 ff ff ff       	jmp    425 <printf+0x2c>
        s = (char*)*ap;
 4cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d2:	8b 30                	mov    (%eax),%esi
        ap++;
 4d4:	83 c0 04             	add    $0x4,%eax
 4d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4da:	85 f6                	test   %esi,%esi
 4dc:	75 15                	jne    4f3 <printf+0xfa>
          s = "(null)";
 4de:	be f8 06 00 00       	mov    $0x6f8,%esi
 4e3:	eb 0e                	jmp    4f3 <printf+0xfa>
          putc(fd, *s);
 4e5:	0f be d2             	movsbl %dl,%edx
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
 4eb:	e8 64 fe ff ff       	call   354 <putc>
          s++;
 4f0:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f3:	0f b6 16             	movzbl (%esi),%edx
 4f6:	84 d2                	test   %dl,%dl
 4f8:	75 eb                	jne    4e5 <printf+0xec>
      state = 0;
 4fa:	be 00 00 00 00       	mov    $0x0,%esi
 4ff:	e9 21 ff ff ff       	jmp    425 <printf+0x2c>
        putc(fd, *ap);
 504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 507:	0f be 17             	movsbl (%edi),%edx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	e8 42 fe ff ff       	call   354 <putc>
        ap++;
 512:	83 c7 04             	add    $0x4,%edi
 515:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 518:	be 00 00 00 00       	mov    $0x0,%esi
 51d:	e9 03 ff ff ff       	jmp    425 <printf+0x2c>
        putc(fd, c);
 522:	89 fa                	mov    %edi,%edx
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	e8 28 fe ff ff       	call   354 <putc>
      state = 0;
 52c:	be 00 00 00 00       	mov    $0x0,%esi
 531:	e9 ef fe ff ff       	jmp    425 <printf+0x2c>
        putc(fd, '%');
 536:	ba 25 00 00 00       	mov    $0x25,%edx
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	e8 11 fe ff ff       	call   354 <putc>
        putc(fd, c);
 543:	89 fa                	mov    %edi,%edx
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	e8 07 fe ff ff       	call   354 <putc>
      state = 0;
 54d:	be 00 00 00 00       	mov    $0x0,%esi
 552:	e9 ce fe ff ff       	jmp    425 <printf+0x2c>
    }
  }
}
 557:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55a:	5b                   	pop    %ebx
 55b:	5e                   	pop    %esi
 55c:	5f                   	pop    %edi
 55d:	5d                   	pop    %ebp
 55e:	c3                   	ret    

0000055f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 55f:	55                   	push   %ebp
 560:	89 e5                	mov    %esp,%ebp
 562:	57                   	push   %edi
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 568:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56b:	a1 04 0a 00 00       	mov    0xa04,%eax
 570:	eb 02                	jmp    574 <free+0x15>
 572:	89 d0                	mov    %edx,%eax
 574:	39 c8                	cmp    %ecx,%eax
 576:	73 04                	jae    57c <free+0x1d>
 578:	39 08                	cmp    %ecx,(%eax)
 57a:	77 12                	ja     58e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57c:	8b 10                	mov    (%eax),%edx
 57e:	39 c2                	cmp    %eax,%edx
 580:	77 f0                	ja     572 <free+0x13>
 582:	39 c8                	cmp    %ecx,%eax
 584:	72 08                	jb     58e <free+0x2f>
 586:	39 ca                	cmp    %ecx,%edx
 588:	77 04                	ja     58e <free+0x2f>
 58a:	89 d0                	mov    %edx,%eax
 58c:	eb e6                	jmp    574 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 58e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 591:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 594:	8b 10                	mov    (%eax),%edx
 596:	39 d7                	cmp    %edx,%edi
 598:	74 19                	je     5b3 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 59d:	8b 50 04             	mov    0x4(%eax),%edx
 5a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a3:	39 ce                	cmp    %ecx,%esi
 5a5:	74 1b                	je     5c2 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a9:	a3 04 0a 00 00       	mov    %eax,0xa04
}
 5ae:	5b                   	pop    %ebx
 5af:	5e                   	pop    %esi
 5b0:	5f                   	pop    %edi
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b3:	03 72 04             	add    0x4(%edx),%esi
 5b6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b9:	8b 10                	mov    (%eax),%edx
 5bb:	8b 12                	mov    (%edx),%edx
 5bd:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c0:	eb db                	jmp    59d <free+0x3e>
    p->s.size += bp->s.size;
 5c2:	03 53 fc             	add    -0x4(%ebx),%edx
 5c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5c8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5cb:	89 10                	mov    %edx,(%eax)
 5cd:	eb da                	jmp    5a9 <free+0x4a>

000005cf <morecore>:

static Header*
morecore(uint nu)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	53                   	push   %ebx
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5d8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5dd:	77 05                	ja     5e4 <morecore+0x15>
    nu = 4096;
 5df:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5e4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5eb:	83 ec 0c             	sub    $0xc,%esp
 5ee:	50                   	push   %eax
 5ef:	e8 10 fd ff ff       	call   304 <sbrk>
  if(p == (char*)-1)
 5f4:	83 c4 10             	add    $0x10,%esp
 5f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5fa:	74 1c                	je     618 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ff:	83 c0 08             	add    $0x8,%eax
 602:	83 ec 0c             	sub    $0xc,%esp
 605:	50                   	push   %eax
 606:	e8 54 ff ff ff       	call   55f <free>
  return freep;
 60b:	a1 04 0a 00 00       	mov    0xa04,%eax
 610:	83 c4 10             	add    $0x10,%esp
}
 613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 616:	c9                   	leave  
 617:	c3                   	ret    
    return 0;
 618:	b8 00 00 00 00       	mov    $0x0,%eax
 61d:	eb f4                	jmp    613 <morecore+0x44>

0000061f <malloc>:

void*
malloc(uint nbytes)
{
 61f:	55                   	push   %ebp
 620:	89 e5                	mov    %esp,%ebp
 622:	53                   	push   %ebx
 623:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 626:	8b 45 08             	mov    0x8(%ebp),%eax
 629:	8d 58 07             	lea    0x7(%eax),%ebx
 62c:	c1 eb 03             	shr    $0x3,%ebx
 62f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 632:	8b 0d 04 0a 00 00    	mov    0xa04,%ecx
 638:	85 c9                	test   %ecx,%ecx
 63a:	74 04                	je     640 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63c:	8b 01                	mov    (%ecx),%eax
 63e:	eb 4a                	jmp    68a <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 640:	c7 05 04 0a 00 00 08 	movl   $0xa08,0xa04
 647:	0a 00 00 
 64a:	c7 05 08 0a 00 00 08 	movl   $0xa08,0xa08
 651:	0a 00 00 
    base.s.size = 0;
 654:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 65b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 65e:	b9 08 0a 00 00       	mov    $0xa08,%ecx
 663:	eb d7                	jmp    63c <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 665:	74 19                	je     680 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 667:	29 da                	sub    %ebx,%edx
 669:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 66c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 66f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 672:	89 0d 04 0a 00 00    	mov    %ecx,0xa04
      return (void*)(p + 1);
 678:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 67b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67e:	c9                   	leave  
 67f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 680:	8b 10                	mov    (%eax),%edx
 682:	89 11                	mov    %edx,(%ecx)
 684:	eb ec                	jmp    672 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 686:	89 c1                	mov    %eax,%ecx
 688:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	39 da                	cmp    %ebx,%edx
 68f:	73 d4                	jae    665 <malloc+0x46>
    if(p == freep)
 691:	39 05 04 0a 00 00    	cmp    %eax,0xa04
 697:	75 ed                	jne    686 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 699:	89 d8                	mov    %ebx,%eax
 69b:	e8 2f ff ff ff       	call   5cf <morecore>
 6a0:	85 c0                	test   %eax,%eax
 6a2:	75 e2                	jne    686 <malloc+0x67>
 6a4:	eb d5                	jmp    67b <malloc+0x5c>
