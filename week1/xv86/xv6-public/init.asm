
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
  14:	68 10 07 00 00       	push   $0x710
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
  47:	68 10 07 00 00       	push   $0x710
  4c:	e8 73 02 00 00       	call   2c4 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 10 07 00 00       	push   $0x710
  5b:	e8 5c 02 00 00       	call   2bc <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 2b 07 00 00       	push   $0x72b
  6d:	6a 01                	push   $0x1
  6f:	e8 ed 03 00 00       	call   461 <printf>
      exit();
  74:	e8 03 02 00 00       	call   27c <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 57 07 00 00       	push   $0x757
  81:	6a 01                	push   $0x1
  83:	e8 d9 03 00 00       	call   461 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 f4 01 00 00       	call   284 <wait>
  90:	85 c0                	test   %eax,%eax
  92:	78 04                	js     98 <main+0x98>
  94:	39 c3                	cmp    %eax,%ebx
  96:	75 e1                	jne    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 18 07 00 00       	push   $0x718
  a0:	6a 01                	push   $0x1
  a2:	e8 ba 03 00 00       	call   461 <printf>
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
  ba:	68 64 0a 00 00       	push   $0xa64
  bf:	68 3e 07 00 00       	push   $0x73e
  c4:	e8 eb 01 00 00       	call   2b4 <exec>
      printf(1, "init: exec sh failed\n");
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	68 41 07 00 00       	push   $0x741
  d1:	6a 01                	push   $0x1
  d3:	e8 89 03 00 00       	call   461 <printf>
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
SYSCALL(numpp)
 34c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <init_counter>:

SYSCALL(init_counter)
 354:	b8 1d 00 00 00       	mov    $0x1d,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <update_cnt>:
SYSCALL(update_cnt)
 35c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <display_count>:
SYSCALL(display_count)
 364:	b8 1f 00 00 00       	mov    $0x1f,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <init_counter_1>:
SYSCALL(init_counter_1)
 36c:	b8 20 00 00 00       	mov    $0x20,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <update_cnt_1>:
SYSCALL(update_cnt_1)
 374:	b8 21 00 00 00       	mov    $0x21,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <display_count_1>:
SYSCALL(display_count_1)
 37c:	b8 22 00 00 00       	mov    $0x22,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <init_counter_2>:
SYSCALL(init_counter_2)
 384:	b8 23 00 00 00       	mov    $0x23,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <update_cnt_2>:
SYSCALL(update_cnt_2)
 38c:	b8 24 00 00 00       	mov    $0x24,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <display_count_2>:
SYSCALL(display_count_2)
 394:	b8 25 00 00 00       	mov    $0x25,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <init_mylock>:
SYSCALL(init_mylock)
 39c:	b8 26 00 00 00       	mov    $0x26,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <acquire_mylock>:
SYSCALL(acquire_mylock)
 3a4:	b8 27 00 00 00       	mov    $0x27,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <release_mylock>:
SYSCALL(release_mylock)
 3ac:	b8 28 00 00 00       	mov    $0x28,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <holding_mylock>:
 3b4:	b8 29 00 00 00       	mov    $0x29,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	83 ec 1c             	sub    $0x1c,%esp
 3c2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3c5:	6a 01                	push   $0x1
 3c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3ca:	52                   	push   %edx
 3cb:	50                   	push   %eax
 3cc:	e8 cb fe ff ff       	call   29c <write>
}
 3d1:	83 c4 10             	add    $0x10,%esp
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	57                   	push   %edi
 3da:	56                   	push   %esi
 3db:	53                   	push   %ebx
 3dc:	83 ec 2c             	sub    $0x2c,%esp
 3df:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ea:	0f 95 c1             	setne  %cl
 3ed:	c1 ea 1f             	shr    $0x1f,%edx
 3f0:	84 d1                	test   %dl,%cl
 3f2:	74 44                	je     438 <printint+0x62>
    neg = 1;
    x = -xx;
 3f4:	f7 d8                	neg    %eax
 3f6:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3f8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 404:	89 c8                	mov    %ecx,%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 f6                	div    %esi
 40d:	89 df                	mov    %ebx,%edi
 40f:	83 c3 01             	add    $0x1,%ebx
 412:	0f b6 92 c0 07 00 00 	movzbl 0x7c0(%edx),%edx
 419:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 41d:	89 ca                	mov    %ecx,%edx
 41f:	89 c1                	mov    %eax,%ecx
 421:	39 d6                	cmp    %edx,%esi
 423:	76 df                	jbe    404 <printint+0x2e>
  if(neg)
 425:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 429:	74 31                	je     45c <printint+0x86>
    buf[i++] = '-';
 42b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 430:	8d 5f 02             	lea    0x2(%edi),%ebx
 433:	8b 75 d0             	mov    -0x30(%ebp),%esi
 436:	eb 17                	jmp    44f <printint+0x79>
    x = xx;
 438:	89 c1                	mov    %eax,%ecx
  neg = 0;
 43a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 441:	eb bc                	jmp    3ff <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 443:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 448:	89 f0                	mov    %esi,%eax
 44a:	e8 6d ff ff ff       	call   3bc <putc>
  while(--i >= 0)
 44f:	83 eb 01             	sub    $0x1,%ebx
 452:	79 ef                	jns    443 <printint+0x6d>
}
 454:	83 c4 2c             	add    $0x2c,%esp
 457:	5b                   	pop    %ebx
 458:	5e                   	pop    %esi
 459:	5f                   	pop    %edi
 45a:	5d                   	pop    %ebp
 45b:	c3                   	ret    
 45c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 45f:	eb ee                	jmp    44f <printint+0x79>

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	57                   	push   %edi
 465:	56                   	push   %esi
 466:	53                   	push   %ebx
 467:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 46a:	8d 45 10             	lea    0x10(%ebp),%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 470:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 475:	bb 00 00 00 00       	mov    $0x0,%ebx
 47a:	eb 14                	jmp    490 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 47c:	89 fa                	mov    %edi,%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 36 ff ff ff       	call   3bc <putc>
 486:	eb 05                	jmp    48d <printf+0x2c>
      }
    } else if(state == '%'){
 488:	83 fe 25             	cmp    $0x25,%esi
 48b:	74 25                	je     4b2 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 48d:	83 c3 01             	add    $0x1,%ebx
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 497:	84 c0                	test   %al,%al
 499:	0f 84 20 01 00 00    	je     5bf <printf+0x15e>
    c = fmt[i] & 0xff;
 49f:	0f be f8             	movsbl %al,%edi
 4a2:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4a5:	85 f6                	test   %esi,%esi
 4a7:	75 df                	jne    488 <printf+0x27>
      if(c == '%'){
 4a9:	83 f8 25             	cmp    $0x25,%eax
 4ac:	75 ce                	jne    47c <printf+0x1b>
        state = '%';
 4ae:	89 c6                	mov    %eax,%esi
 4b0:	eb db                	jmp    48d <printf+0x2c>
      if(c == 'd'){
 4b2:	83 f8 25             	cmp    $0x25,%eax
 4b5:	0f 84 cf 00 00 00    	je     58a <printf+0x129>
 4bb:	0f 8c dd 00 00 00    	jl     59e <printf+0x13d>
 4c1:	83 f8 78             	cmp    $0x78,%eax
 4c4:	0f 8f d4 00 00 00    	jg     59e <printf+0x13d>
 4ca:	83 f8 63             	cmp    $0x63,%eax
 4cd:	0f 8c cb 00 00 00    	jl     59e <printf+0x13d>
 4d3:	83 e8 63             	sub    $0x63,%eax
 4d6:	83 f8 15             	cmp    $0x15,%eax
 4d9:	0f 87 bf 00 00 00    	ja     59e <printf+0x13d>
 4df:	ff 24 85 68 07 00 00 	jmp    *0x768(,%eax,4)
        printint(fd, *ap, 10, 1);
 4e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4e9:	8b 17                	mov    (%edi),%edx
 4eb:	83 ec 0c             	sub    $0xc,%esp
 4ee:	6a 01                	push   $0x1
 4f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 d9 fe ff ff       	call   3d6 <printint>
        ap++;
 4fd:	83 c7 04             	add    $0x4,%edi
 500:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 503:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 506:	be 00 00 00 00       	mov    $0x0,%esi
 50b:	eb 80                	jmp    48d <printf+0x2c>
        printint(fd, *ap, 16, 0);
 50d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 510:	8b 17                	mov    (%edi),%edx
 512:	83 ec 0c             	sub    $0xc,%esp
 515:	6a 00                	push   $0x0
 517:	b9 10 00 00 00       	mov    $0x10,%ecx
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	e8 b2 fe ff ff       	call   3d6 <printint>
        ap++;
 524:	83 c7 04             	add    $0x4,%edi
 527:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 52a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52d:	be 00 00 00 00       	mov    $0x0,%esi
 532:	e9 56 ff ff ff       	jmp    48d <printf+0x2c>
        s = (char*)*ap;
 537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53a:	8b 30                	mov    (%eax),%esi
        ap++;
 53c:	83 c0 04             	add    $0x4,%eax
 53f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 542:	85 f6                	test   %esi,%esi
 544:	75 15                	jne    55b <printf+0xfa>
          s = "(null)";
 546:	be 60 07 00 00       	mov    $0x760,%esi
 54b:	eb 0e                	jmp    55b <printf+0xfa>
          putc(fd, *s);
 54d:	0f be d2             	movsbl %dl,%edx
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	e8 64 fe ff ff       	call   3bc <putc>
          s++;
 558:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 55b:	0f b6 16             	movzbl (%esi),%edx
 55e:	84 d2                	test   %dl,%dl
 560:	75 eb                	jne    54d <printf+0xec>
      state = 0;
 562:	be 00 00 00 00       	mov    $0x0,%esi
 567:	e9 21 ff ff ff       	jmp    48d <printf+0x2c>
        putc(fd, *ap);
 56c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 56f:	0f be 17             	movsbl (%edi),%edx
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	e8 42 fe ff ff       	call   3bc <putc>
        ap++;
 57a:	83 c7 04             	add    $0x4,%edi
 57d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 580:	be 00 00 00 00       	mov    $0x0,%esi
 585:	e9 03 ff ff ff       	jmp    48d <printf+0x2c>
        putc(fd, c);
 58a:	89 fa                	mov    %edi,%edx
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	e8 28 fe ff ff       	call   3bc <putc>
      state = 0;
 594:	be 00 00 00 00       	mov    $0x0,%esi
 599:	e9 ef fe ff ff       	jmp    48d <printf+0x2c>
        putc(fd, '%');
 59e:	ba 25 00 00 00       	mov    $0x25,%edx
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	e8 11 fe ff ff       	call   3bc <putc>
        putc(fd, c);
 5ab:	89 fa                	mov    %edi,%edx
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	e8 07 fe ff ff       	call   3bc <putc>
      state = 0;
 5b5:	be 00 00 00 00       	mov    $0x0,%esi
 5ba:	e9 ce fe ff ff       	jmp    48d <printf+0x2c>
    }
  }
}
 5bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    

000005c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	57                   	push   %edi
 5cb:	56                   	push   %esi
 5cc:	53                   	push   %ebx
 5cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d3:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 5d8:	eb 02                	jmp    5dc <free+0x15>
 5da:	89 d0                	mov    %edx,%eax
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	73 04                	jae    5e4 <free+0x1d>
 5e0:	39 08                	cmp    %ecx,(%eax)
 5e2:	77 12                	ja     5f6 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e4:	8b 10                	mov    (%eax),%edx
 5e6:	39 c2                	cmp    %eax,%edx
 5e8:	77 f0                	ja     5da <free+0x13>
 5ea:	39 c8                	cmp    %ecx,%eax
 5ec:	72 08                	jb     5f6 <free+0x2f>
 5ee:	39 ca                	cmp    %ecx,%edx
 5f0:	77 04                	ja     5f6 <free+0x2f>
 5f2:	89 d0                	mov    %edx,%eax
 5f4:	eb e6                	jmp    5dc <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	8b 10                	mov    (%eax),%edx
 5fe:	39 d7                	cmp    %edx,%edi
 600:	74 19                	je     61b <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 602:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 605:	8b 50 04             	mov    0x4(%eax),%edx
 608:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60b:	39 ce                	cmp    %ecx,%esi
 60d:	74 1b                	je     62a <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 60f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 611:	a3 6c 0a 00 00       	mov    %eax,0xa6c
}
 616:	5b                   	pop    %ebx
 617:	5e                   	pop    %esi
 618:	5f                   	pop    %edi
 619:	5d                   	pop    %ebp
 61a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 61b:	03 72 04             	add    0x4(%edx),%esi
 61e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 621:	8b 10                	mov    (%eax),%edx
 623:	8b 12                	mov    (%edx),%edx
 625:	89 53 f8             	mov    %edx,-0x8(%ebx)
 628:	eb db                	jmp    605 <free+0x3e>
    p->s.size += bp->s.size;
 62a:	03 53 fc             	add    -0x4(%ebx),%edx
 62d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 630:	8b 53 f8             	mov    -0x8(%ebx),%edx
 633:	89 10                	mov    %edx,(%eax)
 635:	eb da                	jmp    611 <free+0x4a>

00000637 <morecore>:

static Header*
morecore(uint nu)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	53                   	push   %ebx
 63b:	83 ec 04             	sub    $0x4,%esp
 63e:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 640:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 645:	77 05                	ja     64c <morecore+0x15>
    nu = 4096;
 647:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 64c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	50                   	push   %eax
 657:	e8 a8 fc ff ff       	call   304 <sbrk>
  if(p == (char*)-1)
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	83 f8 ff             	cmp    $0xffffffff,%eax
 662:	74 1c                	je     680 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 664:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 667:	83 c0 08             	add    $0x8,%eax
 66a:	83 ec 0c             	sub    $0xc,%esp
 66d:	50                   	push   %eax
 66e:	e8 54 ff ff ff       	call   5c7 <free>
  return freep;
 673:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 678:	83 c4 10             	add    $0x10,%esp
}
 67b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67e:	c9                   	leave  
 67f:	c3                   	ret    
    return 0;
 680:	b8 00 00 00 00       	mov    $0x0,%eax
 685:	eb f4                	jmp    67b <morecore+0x44>

00000687 <malloc>:

void*
malloc(uint nbytes)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	53                   	push   %ebx
 68b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	8d 58 07             	lea    0x7(%eax),%ebx
 694:	c1 eb 03             	shr    $0x3,%ebx
 697:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 69a:	8b 0d 6c 0a 00 00    	mov    0xa6c,%ecx
 6a0:	85 c9                	test   %ecx,%ecx
 6a2:	74 04                	je     6a8 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a4:	8b 01                	mov    (%ecx),%eax
 6a6:	eb 4a                	jmp    6f2 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 6a8:	c7 05 6c 0a 00 00 70 	movl   $0xa70,0xa6c
 6af:	0a 00 00 
 6b2:	c7 05 70 0a 00 00 70 	movl   $0xa70,0xa70
 6b9:	0a 00 00 
    base.s.size = 0;
 6bc:	c7 05 74 0a 00 00 00 	movl   $0x0,0xa74
 6c3:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6c6:	b9 70 0a 00 00       	mov    $0xa70,%ecx
 6cb:	eb d7                	jmp    6a4 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6cd:	74 19                	je     6e8 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6cf:	29 da                	sub    %ebx,%edx
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6d4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6d7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6da:	89 0d 6c 0a 00 00    	mov    %ecx,0xa6c
      return (void*)(p + 1);
 6e0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6e8:	8b 10                	mov    (%eax),%edx
 6ea:	89 11                	mov    %edx,(%ecx)
 6ec:	eb ec                	jmp    6da <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ee:	89 c1                	mov    %eax,%ecx
 6f0:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	39 da                	cmp    %ebx,%edx
 6f7:	73 d4                	jae    6cd <malloc+0x46>
    if(p == freep)
 6f9:	39 05 6c 0a 00 00    	cmp    %eax,0xa6c
 6ff:	75 ed                	jne    6ee <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 701:	89 d8                	mov    %ebx,%eax
 703:	e8 2f ff ff ff       	call   637 <morecore>
 708:	85 c0                	test   %eax,%eax
 70a:	75 e2                	jne    6ee <malloc+0x67>
 70c:	eb d5                	jmp    6e3 <malloc+0x5c>
