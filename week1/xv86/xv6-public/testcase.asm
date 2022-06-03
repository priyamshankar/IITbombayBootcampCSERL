
_testcase:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "Hello, world!\n");
  11:	68 ec 05 00 00       	push   $0x5ec
  16:	6a 01                	push   $0x1
  18:	e8 22 03 00 00       	call   33f <printf>
  hello(); // this is a manually made systemcall
  1d:	e8 50 02 00 00       	call   272 <hello>
  helloYou("pri");
  22:	c7 04 24 fb 05 00 00 	movl   $0x5fb,(%esp)
  29:	e8 4c 02 00 00       	call   27a <helloYou>
  // getpid();
  exit();
  2e:	e8 9f 01 00 00       	call   1d2 <exit>

00000033 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	56                   	push   %esi
  37:	53                   	push   %ebx
  38:	8b 75 08             	mov    0x8(%ebp),%esi
  3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	89 f0                	mov    %esi,%eax
  40:	89 d1                	mov    %edx,%ecx
  42:	83 c2 01             	add    $0x1,%edx
  45:	89 c3                	mov    %eax,%ebx
  47:	83 c0 01             	add    $0x1,%eax
  4a:	0f b6 09             	movzbl (%ecx),%ecx
  4d:	88 0b                	mov    %cl,(%ebx)
  4f:	84 c9                	test   %cl,%cl
  51:	75 ed                	jne    40 <strcpy+0xd>
    ;
  return os;
}
  53:	89 f0                	mov    %esi,%eax
  55:	5b                   	pop    %ebx
  56:	5e                   	pop    %esi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  62:	eb 06                	jmp    6a <strcmp+0x11>
    p++, q++;
  64:	83 c1 01             	add    $0x1,%ecx
  67:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  6a:	0f b6 01             	movzbl (%ecx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	74 04                	je     75 <strcmp+0x1c>
  71:	3a 02                	cmp    (%edx),%al
  73:	74 ef                	je     64 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  75:	0f b6 c0             	movzbl %al,%eax
  78:	0f b6 12             	movzbl (%edx),%edx
  7b:	29 d0                	sub    %edx,%eax
}
  7d:	5d                   	pop    %ebp
  7e:	c3                   	ret    

0000007f <strlen>:

uint
strlen(const char *s)
{
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  85:	b8 00 00 00 00       	mov    $0x0,%eax
  8a:	eb 03                	jmp    8f <strlen+0x10>
  8c:	83 c0 01             	add    $0x1,%eax
  8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  93:	75 f7                	jne    8c <strlen+0xd>
    ;
  return n;
}
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    

00000097 <memset>:

void*
memset(void *dst, int c, uint n)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  9a:	57                   	push   %edi
  9b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  9e:	89 d7                	mov    %edx,%edi
  a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	fc                   	cld    
  a7:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a9:	89 d0                	mov    %edx,%eax
  ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ae:	c9                   	leave  
  af:	c3                   	ret    

000000b0 <strchr>:

char*
strchr(const char *s, char c)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ba:	eb 03                	jmp    bf <strchr+0xf>
  bc:	83 c0 01             	add    $0x1,%eax
  bf:	0f b6 10             	movzbl (%eax),%edx
  c2:	84 d2                	test   %dl,%dl
  c4:	74 06                	je     cc <strchr+0x1c>
    if(*s == c)
  c6:	38 ca                	cmp    %cl,%dl
  c8:	75 f2                	jne    bc <strchr+0xc>
  ca:	eb 05                	jmp    d1 <strchr+0x21>
      return (char*)s;
  return 0;
  cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    

000000d3 <gets>:

char*
gets(char *buf, int max)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	57                   	push   %edi
  d7:	56                   	push   %esi
  d8:	53                   	push   %ebx
  d9:	83 ec 1c             	sub    $0x1c,%esp
  dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  df:	bb 00 00 00 00       	mov    $0x0,%ebx
  e4:	89 de                	mov    %ebx,%esi
  e6:	83 c3 01             	add    $0x1,%ebx
  e9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  ec:	7d 2e                	jge    11c <gets+0x49>
    cc = read(0, &c, 1);
  ee:	83 ec 04             	sub    $0x4,%esp
  f1:	6a 01                	push   $0x1
  f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
  f6:	50                   	push   %eax
  f7:	6a 00                	push   $0x0
  f9:	e8 ec 00 00 00       	call   1ea <read>
    if(cc < 1)
  fe:	83 c4 10             	add    $0x10,%esp
 101:	85 c0                	test   %eax,%eax
 103:	7e 17                	jle    11c <gets+0x49>
      break;
    buf[i++] = c;
 105:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 109:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 10c:	3c 0a                	cmp    $0xa,%al
 10e:	0f 94 c2             	sete   %dl
 111:	3c 0d                	cmp    $0xd,%al
 113:	0f 94 c0             	sete   %al
 116:	08 c2                	or     %al,%dl
 118:	74 ca                	je     e4 <gets+0x11>
    buf[i++] = c;
 11a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 11c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 120:	89 f8                	mov    %edi,%eax
 122:	8d 65 f4             	lea    -0xc(%ebp),%esp
 125:	5b                   	pop    %ebx
 126:	5e                   	pop    %esi
 127:	5f                   	pop    %edi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <stat>:

int
stat(const char *n, struct stat *st)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	56                   	push   %esi
 12e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	6a 00                	push   $0x0
 134:	ff 75 08             	push   0x8(%ebp)
 137:	e8 d6 00 00 00       	call   212 <open>
  if(fd < 0)
 13c:	83 c4 10             	add    $0x10,%esp
 13f:	85 c0                	test   %eax,%eax
 141:	78 24                	js     167 <stat+0x3d>
 143:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 145:	83 ec 08             	sub    $0x8,%esp
 148:	ff 75 0c             	push   0xc(%ebp)
 14b:	50                   	push   %eax
 14c:	e8 d9 00 00 00       	call   22a <fstat>
 151:	89 c6                	mov    %eax,%esi
  close(fd);
 153:	89 1c 24             	mov    %ebx,(%esp)
 156:	e8 9f 00 00 00       	call   1fa <close>
  return r;
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	89 f0                	mov    %esi,%eax
 160:	8d 65 f8             	lea    -0x8(%ebp),%esp
 163:	5b                   	pop    %ebx
 164:	5e                   	pop    %esi
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
    return -1;
 167:	be ff ff ff ff       	mov    $0xffffffff,%esi
 16c:	eb f0                	jmp    15e <stat+0x34>

0000016e <atoi>:

int
atoi(const char *s)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	53                   	push   %ebx
 172:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 175:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 17a:	eb 10                	jmp    18c <atoi+0x1e>
    n = n*10 + *s++ - '0';
 17c:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 17f:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 182:	83 c1 01             	add    $0x1,%ecx
 185:	0f be c0             	movsbl %al,%eax
 188:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 18c:	0f b6 01             	movzbl (%ecx),%eax
 18f:	8d 58 d0             	lea    -0x30(%eax),%ebx
 192:	80 fb 09             	cmp    $0x9,%bl
 195:	76 e5                	jbe    17c <atoi+0xe>
  return n;
}
 197:	89 d0                	mov    %edx,%eax
 199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	56                   	push   %esi
 1a2:	53                   	push   %ebx
 1a3:	8b 75 08             	mov    0x8(%ebp),%esi
 1a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ac:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ae:	eb 0d                	jmp    1bd <memmove+0x1f>
    *dst++ = *src++;
 1b0:	0f b6 01             	movzbl (%ecx),%eax
 1b3:	88 02                	mov    %al,(%edx)
 1b5:	8d 49 01             	lea    0x1(%ecx),%ecx
 1b8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1bb:	89 d8                	mov    %ebx,%eax
 1bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7f ec                	jg     1b0 <memmove+0x12>
  return vdst;
}
 1c4:	89 f0                	mov    %esi,%eax
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    

000001ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ca:	b8 01 00 00 00       	mov    $0x1,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <exit>:
SYSCALL(exit)
 1d2:	b8 02 00 00 00       	mov    $0x2,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <wait>:
SYSCALL(wait)
 1da:	b8 03 00 00 00       	mov    $0x3,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <pipe>:
SYSCALL(pipe)
 1e2:	b8 04 00 00 00       	mov    $0x4,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <read>:
SYSCALL(read)
 1ea:	b8 05 00 00 00       	mov    $0x5,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <write>:
SYSCALL(write)
 1f2:	b8 10 00 00 00       	mov    $0x10,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <close>:
SYSCALL(close)
 1fa:	b8 15 00 00 00       	mov    $0x15,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <kill>:
SYSCALL(kill)
 202:	b8 06 00 00 00       	mov    $0x6,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <exec>:
SYSCALL(exec)
 20a:	b8 07 00 00 00       	mov    $0x7,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <open>:
SYSCALL(open)
 212:	b8 0f 00 00 00       	mov    $0xf,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <mknod>:
SYSCALL(mknod)
 21a:	b8 11 00 00 00       	mov    $0x11,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <unlink>:
SYSCALL(unlink)
 222:	b8 12 00 00 00       	mov    $0x12,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <fstat>:
SYSCALL(fstat)
 22a:	b8 08 00 00 00       	mov    $0x8,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <link>:
SYSCALL(link)
 232:	b8 13 00 00 00       	mov    $0x13,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <mkdir>:
SYSCALL(mkdir)
 23a:	b8 14 00 00 00       	mov    $0x14,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <chdir>:
SYSCALL(chdir)
 242:	b8 09 00 00 00       	mov    $0x9,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <dup>:
SYSCALL(dup)
 24a:	b8 0a 00 00 00       	mov    $0xa,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <getpid>:
SYSCALL(getpid)
 252:	b8 0b 00 00 00       	mov    $0xb,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <sbrk>:
SYSCALL(sbrk)
 25a:	b8 0c 00 00 00       	mov    $0xc,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <sleep>:
SYSCALL(sleep)
 262:	b8 0d 00 00 00       	mov    $0xd,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <uptime>:
SYSCALL(uptime)
 26a:	b8 0e 00 00 00       	mov    $0xe,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <hello>:
SYSCALL(hello)
 272:	b8 16 00 00 00       	mov    $0x16,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <helloYou>:
SYSCALL(helloYou)
 27a:	b8 17 00 00 00       	mov    $0x17,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <getppid>:
SYSCALL(getppid)
 282:	b8 18 00 00 00       	mov    $0x18,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <get_siblings_info>:
SYSCALL(get_siblings_info)
 28a:	b8 19 00 00 00       	mov    $0x19,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <signalProcess>:
 292:	b8 1a 00 00 00       	mov    $0x1a,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 1c             	sub    $0x1c,%esp
 2a0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2a3:	6a 01                	push   $0x1
 2a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2a8:	52                   	push   %edx
 2a9:	50                   	push   %eax
 2aa:	e8 43 ff ff ff       	call   1f2 <write>
}
 2af:	83 c4 10             	add    $0x10,%esp
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	57                   	push   %edi
 2b8:	56                   	push   %esi
 2b9:	53                   	push   %ebx
 2ba:	83 ec 2c             	sub    $0x2c,%esp
 2bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2c0:	89 d0                	mov    %edx,%eax
 2c2:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2c8:	0f 95 c1             	setne  %cl
 2cb:	c1 ea 1f             	shr    $0x1f,%edx
 2ce:	84 d1                	test   %dl,%cl
 2d0:	74 44                	je     316 <printint+0x62>
    neg = 1;
    x = -xx;
 2d2:	f7 d8                	neg    %eax
 2d4:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2d6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2e2:	89 c8                	mov    %ecx,%eax
 2e4:	ba 00 00 00 00       	mov    $0x0,%edx
 2e9:	f7 f6                	div    %esi
 2eb:	89 df                	mov    %ebx,%edi
 2ed:	83 c3 01             	add    $0x1,%ebx
 2f0:	0f b6 92 60 06 00 00 	movzbl 0x660(%edx),%edx
 2f7:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2fb:	89 ca                	mov    %ecx,%edx
 2fd:	89 c1                	mov    %eax,%ecx
 2ff:	39 d6                	cmp    %edx,%esi
 301:	76 df                	jbe    2e2 <printint+0x2e>
  if(neg)
 303:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 307:	74 31                	je     33a <printint+0x86>
    buf[i++] = '-';
 309:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 30e:	8d 5f 02             	lea    0x2(%edi),%ebx
 311:	8b 75 d0             	mov    -0x30(%ebp),%esi
 314:	eb 17                	jmp    32d <printint+0x79>
    x = xx;
 316:	89 c1                	mov    %eax,%ecx
  neg = 0;
 318:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 31f:	eb bc                	jmp    2dd <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 321:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 326:	89 f0                	mov    %esi,%eax
 328:	e8 6d ff ff ff       	call   29a <putc>
  while(--i >= 0)
 32d:	83 eb 01             	sub    $0x1,%ebx
 330:	79 ef                	jns    321 <printint+0x6d>
}
 332:	83 c4 2c             	add    $0x2c,%esp
 335:	5b                   	pop    %ebx
 336:	5e                   	pop    %esi
 337:	5f                   	pop    %edi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 33d:	eb ee                	jmp    32d <printint+0x79>

0000033f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	57                   	push   %edi
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
 345:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 348:	8d 45 10             	lea    0x10(%ebp),%eax
 34b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 34e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 353:	bb 00 00 00 00       	mov    $0x0,%ebx
 358:	eb 14                	jmp    36e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 35a:	89 fa                	mov    %edi,%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	e8 36 ff ff ff       	call   29a <putc>
 364:	eb 05                	jmp    36b <printf+0x2c>
      }
    } else if(state == '%'){
 366:	83 fe 25             	cmp    $0x25,%esi
 369:	74 25                	je     390 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 36b:	83 c3 01             	add    $0x1,%ebx
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 375:	84 c0                	test   %al,%al
 377:	0f 84 20 01 00 00    	je     49d <printf+0x15e>
    c = fmt[i] & 0xff;
 37d:	0f be f8             	movsbl %al,%edi
 380:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 383:	85 f6                	test   %esi,%esi
 385:	75 df                	jne    366 <printf+0x27>
      if(c == '%'){
 387:	83 f8 25             	cmp    $0x25,%eax
 38a:	75 ce                	jne    35a <printf+0x1b>
        state = '%';
 38c:	89 c6                	mov    %eax,%esi
 38e:	eb db                	jmp    36b <printf+0x2c>
      if(c == 'd'){
 390:	83 f8 25             	cmp    $0x25,%eax
 393:	0f 84 cf 00 00 00    	je     468 <printf+0x129>
 399:	0f 8c dd 00 00 00    	jl     47c <printf+0x13d>
 39f:	83 f8 78             	cmp    $0x78,%eax
 3a2:	0f 8f d4 00 00 00    	jg     47c <printf+0x13d>
 3a8:	83 f8 63             	cmp    $0x63,%eax
 3ab:	0f 8c cb 00 00 00    	jl     47c <printf+0x13d>
 3b1:	83 e8 63             	sub    $0x63,%eax
 3b4:	83 f8 15             	cmp    $0x15,%eax
 3b7:	0f 87 bf 00 00 00    	ja     47c <printf+0x13d>
 3bd:	ff 24 85 08 06 00 00 	jmp    *0x608(,%eax,4)
        printint(fd, *ap, 10, 1);
 3c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3c7:	8b 17                	mov    (%edi),%edx
 3c9:	83 ec 0c             	sub    $0xc,%esp
 3cc:	6a 01                	push   $0x1
 3ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	e8 d9 fe ff ff       	call   2b4 <printint>
        ap++;
 3db:	83 c7 04             	add    $0x4,%edi
 3de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3e1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3e4:	be 00 00 00 00       	mov    $0x0,%esi
 3e9:	eb 80                	jmp    36b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ee:	8b 17                	mov    (%edi),%edx
 3f0:	83 ec 0c             	sub    $0xc,%esp
 3f3:	6a 00                	push   $0x0
 3f5:	b9 10 00 00 00       	mov    $0x10,%ecx
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	e8 b2 fe ff ff       	call   2b4 <printint>
        ap++;
 402:	83 c7 04             	add    $0x4,%edi
 405:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 408:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40b:	be 00 00 00 00       	mov    $0x0,%esi
 410:	e9 56 ff ff ff       	jmp    36b <printf+0x2c>
        s = (char*)*ap;
 415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 418:	8b 30                	mov    (%eax),%esi
        ap++;
 41a:	83 c0 04             	add    $0x4,%eax
 41d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 420:	85 f6                	test   %esi,%esi
 422:	75 15                	jne    439 <printf+0xfa>
          s = "(null)";
 424:	be ff 05 00 00       	mov    $0x5ff,%esi
 429:	eb 0e                	jmp    439 <printf+0xfa>
          putc(fd, *s);
 42b:	0f be d2             	movsbl %dl,%edx
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	e8 64 fe ff ff       	call   29a <putc>
          s++;
 436:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 439:	0f b6 16             	movzbl (%esi),%edx
 43c:	84 d2                	test   %dl,%dl
 43e:	75 eb                	jne    42b <printf+0xec>
      state = 0;
 440:	be 00 00 00 00       	mov    $0x0,%esi
 445:	e9 21 ff ff ff       	jmp    36b <printf+0x2c>
        putc(fd, *ap);
 44a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 44d:	0f be 17             	movsbl (%edi),%edx
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	e8 42 fe ff ff       	call   29a <putc>
        ap++;
 458:	83 c7 04             	add    $0x4,%edi
 45b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 45e:	be 00 00 00 00       	mov    $0x0,%esi
 463:	e9 03 ff ff ff       	jmp    36b <printf+0x2c>
        putc(fd, c);
 468:	89 fa                	mov    %edi,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	e8 28 fe ff ff       	call   29a <putc>
      state = 0;
 472:	be 00 00 00 00       	mov    $0x0,%esi
 477:	e9 ef fe ff ff       	jmp    36b <printf+0x2c>
        putc(fd, '%');
 47c:	ba 25 00 00 00       	mov    $0x25,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	e8 11 fe ff ff       	call   29a <putc>
        putc(fd, c);
 489:	89 fa                	mov    %edi,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 07 fe ff ff       	call   29a <putc>
      state = 0;
 493:	be 00 00 00 00       	mov    $0x0,%esi
 498:	e9 ce fe ff ff       	jmp    36b <printf+0x2c>
    }
  }
}
 49d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    

000004a5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4a5:	55                   	push   %ebp
 4a6:	89 e5                	mov    %esp,%ebp
 4a8:	57                   	push   %edi
 4a9:	56                   	push   %esi
 4aa:	53                   	push   %ebx
 4ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b1:	a1 00 09 00 00       	mov    0x900,%eax
 4b6:	eb 02                	jmp    4ba <free+0x15>
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	39 c8                	cmp    %ecx,%eax
 4bc:	73 04                	jae    4c2 <free+0x1d>
 4be:	39 08                	cmp    %ecx,(%eax)
 4c0:	77 12                	ja     4d4 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4c2:	8b 10                	mov    (%eax),%edx
 4c4:	39 c2                	cmp    %eax,%edx
 4c6:	77 f0                	ja     4b8 <free+0x13>
 4c8:	39 c8                	cmp    %ecx,%eax
 4ca:	72 08                	jb     4d4 <free+0x2f>
 4cc:	39 ca                	cmp    %ecx,%edx
 4ce:	77 04                	ja     4d4 <free+0x2f>
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	eb e6                	jmp    4ba <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4d4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4d7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4da:	8b 10                	mov    (%eax),%edx
 4dc:	39 d7                	cmp    %edx,%edi
 4de:	74 19                	je     4f9 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4e3:	8b 50 04             	mov    0x4(%eax),%edx
 4e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4e9:	39 ce                	cmp    %ecx,%esi
 4eb:	74 1b                	je     508 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4ed:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4ef:	a3 00 09 00 00       	mov    %eax,0x900
}
 4f4:	5b                   	pop    %ebx
 4f5:	5e                   	pop    %esi
 4f6:	5f                   	pop    %edi
 4f7:	5d                   	pop    %ebp
 4f8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4f9:	03 72 04             	add    0x4(%edx),%esi
 4fc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4ff:	8b 10                	mov    (%eax),%edx
 501:	8b 12                	mov    (%edx),%edx
 503:	89 53 f8             	mov    %edx,-0x8(%ebx)
 506:	eb db                	jmp    4e3 <free+0x3e>
    p->s.size += bp->s.size;
 508:	03 53 fc             	add    -0x4(%ebx),%edx
 50b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 50e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 511:	89 10                	mov    %edx,(%eax)
 513:	eb da                	jmp    4ef <free+0x4a>

00000515 <morecore>:

static Header*
morecore(uint nu)
{
 515:	55                   	push   %ebp
 516:	89 e5                	mov    %esp,%ebp
 518:	53                   	push   %ebx
 519:	83 ec 04             	sub    $0x4,%esp
 51c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 51e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 523:	77 05                	ja     52a <morecore+0x15>
    nu = 4096;
 525:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 52a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 531:	83 ec 0c             	sub    $0xc,%esp
 534:	50                   	push   %eax
 535:	e8 20 fd ff ff       	call   25a <sbrk>
  if(p == (char*)-1)
 53a:	83 c4 10             	add    $0x10,%esp
 53d:	83 f8 ff             	cmp    $0xffffffff,%eax
 540:	74 1c                	je     55e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 542:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 545:	83 c0 08             	add    $0x8,%eax
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	50                   	push   %eax
 54c:	e8 54 ff ff ff       	call   4a5 <free>
  return freep;
 551:	a1 00 09 00 00       	mov    0x900,%eax
 556:	83 c4 10             	add    $0x10,%esp
}
 559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 55c:	c9                   	leave  
 55d:	c3                   	ret    
    return 0;
 55e:	b8 00 00 00 00       	mov    $0x0,%eax
 563:	eb f4                	jmp    559 <morecore+0x44>

00000565 <malloc>:

void*
malloc(uint nbytes)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	8d 58 07             	lea    0x7(%eax),%ebx
 572:	c1 eb 03             	shr    $0x3,%ebx
 575:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 578:	8b 0d 00 09 00 00    	mov    0x900,%ecx
 57e:	85 c9                	test   %ecx,%ecx
 580:	74 04                	je     586 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 582:	8b 01                	mov    (%ecx),%eax
 584:	eb 4a                	jmp    5d0 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 586:	c7 05 00 09 00 00 04 	movl   $0x904,0x900
 58d:	09 00 00 
 590:	c7 05 04 09 00 00 04 	movl   $0x904,0x904
 597:	09 00 00 
    base.s.size = 0;
 59a:	c7 05 08 09 00 00 00 	movl   $0x0,0x908
 5a1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5a4:	b9 04 09 00 00       	mov    $0x904,%ecx
 5a9:	eb d7                	jmp    582 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ab:	74 19                	je     5c6 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ad:	29 da                	sub    %ebx,%edx
 5af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5b2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5b5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5b8:	89 0d 00 09 00 00    	mov    %ecx,0x900
      return (void*)(p + 1);
 5be:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c4:	c9                   	leave  
 5c5:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5c6:	8b 10                	mov    (%eax),%edx
 5c8:	89 11                	mov    %edx,(%ecx)
 5ca:	eb ec                	jmp    5b8 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5cc:	89 c1                	mov    %eax,%ecx
 5ce:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5d0:	8b 50 04             	mov    0x4(%eax),%edx
 5d3:	39 da                	cmp    %ebx,%edx
 5d5:	73 d4                	jae    5ab <malloc+0x46>
    if(p == freep)
 5d7:	39 05 00 09 00 00    	cmp    %eax,0x900
 5dd:	75 ed                	jne    5cc <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5df:	89 d8                	mov    %ebx,%eax
 5e1:	e8 2f ff ff ff       	call   515 <morecore>
 5e6:	85 c0                	test   %eax,%eax
 5e8:	75 e2                	jne    5cc <malloc+0x67>
 5ea:	eb d5                	jmp    5c1 <malloc+0x5c>
