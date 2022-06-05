
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba 1e 06 00 00       	mov    $0x61e,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	push   (%edi,%eax,4)
  29:	68 20 06 00 00       	push   $0x620
  2e:	6a 01                	push   $0x1
  30:	e8 38 03 00 00       	call   36d <printf>
  35:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba 1c 06 00 00       	mov    $0x61c,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit();
  4c:	e8 9f 01 00 00       	call   1f0 <exit>

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	56                   	push   %esi
  55:	53                   	push   %ebx
  56:	8b 75 08             	mov    0x8(%ebp),%esi
  59:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5c:	89 f0                	mov    %esi,%eax
  5e:	89 d1                	mov    %edx,%ecx
  60:	83 c2 01             	add    $0x1,%edx
  63:	89 c3                	mov    %eax,%ebx
  65:	83 c0 01             	add    $0x1,%eax
  68:	0f b6 09             	movzbl (%ecx),%ecx
  6b:	88 0b                	mov    %cl,(%ebx)
  6d:	84 c9                	test   %cl,%cl
  6f:	75 ed                	jne    5e <strcpy+0xd>
    ;
  return os;
}
  71:	89 f0                	mov    %esi,%eax
  73:	5b                   	pop    %ebx
  74:	5e                   	pop    %esi
  75:	5d                   	pop    %ebp
  76:	c3                   	ret    

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  80:	eb 06                	jmp    88 <strcmp+0x11>
    p++, q++;
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  88:	0f b6 01             	movzbl (%ecx),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 04                	je     93 <strcmp+0x1c>
  8f:	3a 02                	cmp    (%edx),%al
  91:	74 ef                	je     82 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  93:	0f b6 c0             	movzbl %al,%eax
  96:	0f b6 12             	movzbl (%edx),%edx
  99:	29 d0                	sub    %edx,%eax
}
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    

0000009d <strlen>:

uint
strlen(const char *s)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a3:	b8 00 00 00 00       	mov    $0x0,%eax
  a8:	eb 03                	jmp    ad <strlen+0x10>
  aa:	83 c0 01             	add    $0x1,%eax
  ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  b1:	75 f7                	jne    aa <strlen+0xd>
    ;
  return n;
}
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bc:	89 d7                	mov    %edx,%edi
  be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	fc                   	cld    
  c5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c7:	89 d0                	mov    %edx,%eax
  c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strchr>:

char*
strchr(const char *s, char c)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d8:	eb 03                	jmp    dd <strchr+0xf>
  da:	83 c0 01             	add    $0x1,%eax
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	84 d2                	test   %dl,%dl
  e2:	74 06                	je     ea <strchr+0x1c>
    if(*s == c)
  e4:	38 ca                	cmp    %cl,%dl
  e6:	75 f2                	jne    da <strchr+0xc>
  e8:	eb 05                	jmp    ef <strchr+0x21>
      return (char*)s;
  return 0;
  ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <gets>:

char*
gets(char *buf, int max)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	57                   	push   %edi
  f5:	56                   	push   %esi
  f6:	53                   	push   %ebx
  f7:	83 ec 1c             	sub    $0x1c,%esp
  fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fd:	bb 00 00 00 00       	mov    $0x0,%ebx
 102:	89 de                	mov    %ebx,%esi
 104:	83 c3 01             	add    $0x1,%ebx
 107:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 10a:	7d 2e                	jge    13a <gets+0x49>
    cc = read(0, &c, 1);
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	6a 01                	push   $0x1
 111:	8d 45 e7             	lea    -0x19(%ebp),%eax
 114:	50                   	push   %eax
 115:	6a 00                	push   $0x0
 117:	e8 ec 00 00 00       	call   208 <read>
    if(cc < 1)
 11c:	83 c4 10             	add    $0x10,%esp
 11f:	85 c0                	test   %eax,%eax
 121:	7e 17                	jle    13a <gets+0x49>
      break;
    buf[i++] = c;
 123:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 127:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 12a:	3c 0a                	cmp    $0xa,%al
 12c:	0f 94 c2             	sete   %dl
 12f:	3c 0d                	cmp    $0xd,%al
 131:	0f 94 c0             	sete   %al
 134:	08 c2                	or     %al,%dl
 136:	74 ca                	je     102 <gets+0x11>
    buf[i++] = c;
 138:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 13a:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13e:	89 f8                	mov    %edi,%eax
 140:	8d 65 f4             	lea    -0xc(%ebp),%esp
 143:	5b                   	pop    %ebx
 144:	5e                   	pop    %esi
 145:	5f                   	pop    %edi
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    

00000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	6a 00                	push   $0x0
 152:	ff 75 08             	push   0x8(%ebp)
 155:	e8 d6 00 00 00       	call   230 <open>
  if(fd < 0)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	85 c0                	test   %eax,%eax
 15f:	78 24                	js     185 <stat+0x3d>
 161:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 163:	83 ec 08             	sub    $0x8,%esp
 166:	ff 75 0c             	push   0xc(%ebp)
 169:	50                   	push   %eax
 16a:	e8 d9 00 00 00       	call   248 <fstat>
 16f:	89 c6                	mov    %eax,%esi
  close(fd);
 171:	89 1c 24             	mov    %ebx,(%esp)
 174:	e8 9f 00 00 00       	call   218 <close>
  return r;
 179:	83 c4 10             	add    $0x10,%esp
}
 17c:	89 f0                	mov    %esi,%eax
 17e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
    return -1;
 185:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18a:	eb f0                	jmp    17c <stat+0x34>

0000018c <atoi>:

int
atoi(const char *s)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	53                   	push   %ebx
 190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 193:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 198:	eb 10                	jmp    1aa <atoi+0x1e>
    n = n*10 + *s++ - '0';
 19a:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19d:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1a0:	83 c1 01             	add    $0x1,%ecx
 1a3:	0f be c0             	movsbl %al,%eax
 1a6:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 01             	movzbl (%ecx),%eax
 1ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e5                	jbe    19a <atoi+0xe>
  return n;
}
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ba:	c9                   	leave  
 1bb:	c3                   	ret    

000001bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	8b 75 08             	mov    0x8(%ebp),%esi
 1c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ca:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1cc:	eb 0d                	jmp    1db <memmove+0x1f>
    *dst++ = *src++;
 1ce:	0f b6 01             	movzbl (%ecx),%eax
 1d1:	88 02                	mov    %al,(%edx)
 1d3:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d6:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d9:	89 d8                	mov    %ebx,%eax
 1db:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1de:	85 c0                	test   %eax,%eax
 1e0:	7f ec                	jg     1ce <memmove+0x12>
  return vdst;
}
 1e2:	89 f0                	mov    %esi,%eax
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e8:	b8 01 00 00 00       	mov    $0x1,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <exit>:
SYSCALL(exit)
 1f0:	b8 02 00 00 00       	mov    $0x2,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <wait>:
SYSCALL(wait)
 1f8:	b8 03 00 00 00       	mov    $0x3,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <pipe>:
SYSCALL(pipe)
 200:	b8 04 00 00 00       	mov    $0x4,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <read>:
SYSCALL(read)
 208:	b8 05 00 00 00       	mov    $0x5,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <write>:
SYSCALL(write)
 210:	b8 10 00 00 00       	mov    $0x10,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <close>:
SYSCALL(close)
 218:	b8 15 00 00 00       	mov    $0x15,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <kill>:
SYSCALL(kill)
 220:	b8 06 00 00 00       	mov    $0x6,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <exec>:
SYSCALL(exec)
 228:	b8 07 00 00 00       	mov    $0x7,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <open>:
SYSCALL(open)
 230:	b8 0f 00 00 00       	mov    $0xf,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <mknod>:
SYSCALL(mknod)
 238:	b8 11 00 00 00       	mov    $0x11,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <unlink>:
SYSCALL(unlink)
 240:	b8 12 00 00 00       	mov    $0x12,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <fstat>:
SYSCALL(fstat)
 248:	b8 08 00 00 00       	mov    $0x8,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <link>:
SYSCALL(link)
 250:	b8 13 00 00 00       	mov    $0x13,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <mkdir>:
SYSCALL(mkdir)
 258:	b8 14 00 00 00       	mov    $0x14,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <chdir>:
SYSCALL(chdir)
 260:	b8 09 00 00 00       	mov    $0x9,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <dup>:
SYSCALL(dup)
 268:	b8 0a 00 00 00       	mov    $0xa,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <getpid>:
SYSCALL(getpid)
 270:	b8 0b 00 00 00       	mov    $0xb,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <sbrk>:
SYSCALL(sbrk)
 278:	b8 0c 00 00 00       	mov    $0xc,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <sleep>:
SYSCALL(sleep)
 280:	b8 0d 00 00 00       	mov    $0xd,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <uptime>:
SYSCALL(uptime)
 288:	b8 0e 00 00 00       	mov    $0xe,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <hello>:
SYSCALL(hello)
 290:	b8 16 00 00 00       	mov    $0x16,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <helloYou>:
SYSCALL(helloYou)
 298:	b8 17 00 00 00       	mov    $0x17,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <getppid>:
SYSCALL(getppid)
 2a0:	b8 18 00 00 00       	mov    $0x18,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2a8:	b8 19 00 00 00       	mov    $0x19,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <signalProcess>:
SYSCALL(signalProcess)
 2b0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <numvp>:
SYSCALL(numvp)
 2b8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <numpp>:
 2c0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	83 ec 1c             	sub    $0x1c,%esp
 2ce:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2d1:	6a 01                	push   $0x1
 2d3:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 33 ff ff ff       	call   210 <write>
}
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	57                   	push   %edi
 2e6:	56                   	push   %esi
 2e7:	53                   	push   %ebx
 2e8:	83 ec 2c             	sub    $0x2c,%esp
 2eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2ee:	89 d0                	mov    %edx,%eax
 2f0:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f6:	0f 95 c1             	setne  %cl
 2f9:	c1 ea 1f             	shr    $0x1f,%edx
 2fc:	84 d1                	test   %dl,%cl
 2fe:	74 44                	je     344 <printint+0x62>
    neg = 1;
    x = -xx;
 300:	f7 d8                	neg    %eax
 302:	89 c1                	mov    %eax,%ecx
    neg = 1;
 304:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 30b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 310:	89 c8                	mov    %ecx,%eax
 312:	ba 00 00 00 00       	mov    $0x0,%edx
 317:	f7 f6                	div    %esi
 319:	89 df                	mov    %ebx,%edi
 31b:	83 c3 01             	add    $0x1,%ebx
 31e:	0f b6 92 84 06 00 00 	movzbl 0x684(%edx),%edx
 325:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 329:	89 ca                	mov    %ecx,%edx
 32b:	89 c1                	mov    %eax,%ecx
 32d:	39 d6                	cmp    %edx,%esi
 32f:	76 df                	jbe    310 <printint+0x2e>
  if(neg)
 331:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 335:	74 31                	je     368 <printint+0x86>
    buf[i++] = '-';
 337:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33c:	8d 5f 02             	lea    0x2(%edi),%ebx
 33f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 342:	eb 17                	jmp    35b <printint+0x79>
    x = xx;
 344:	89 c1                	mov    %eax,%ecx
  neg = 0;
 346:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 34d:	eb bc                	jmp    30b <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 34f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 354:	89 f0                	mov    %esi,%eax
 356:	e8 6d ff ff ff       	call   2c8 <putc>
  while(--i >= 0)
 35b:	83 eb 01             	sub    $0x1,%ebx
 35e:	79 ef                	jns    34f <printint+0x6d>
}
 360:	83 c4 2c             	add    $0x2c,%esp
 363:	5b                   	pop    %ebx
 364:	5e                   	pop    %esi
 365:	5f                   	pop    %edi
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    
 368:	8b 75 d0             	mov    -0x30(%ebp),%esi
 36b:	eb ee                	jmp    35b <printint+0x79>

0000036d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	57                   	push   %edi
 371:	56                   	push   %esi
 372:	53                   	push   %ebx
 373:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 376:	8d 45 10             	lea    0x10(%ebp),%eax
 379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 37c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 381:	bb 00 00 00 00       	mov    $0x0,%ebx
 386:	eb 14                	jmp    39c <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 388:	89 fa                	mov    %edi,%edx
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	e8 36 ff ff ff       	call   2c8 <putc>
 392:	eb 05                	jmp    399 <printf+0x2c>
      }
    } else if(state == '%'){
 394:	83 fe 25             	cmp    $0x25,%esi
 397:	74 25                	je     3be <printf+0x51>
  for(i = 0; fmt[i]; i++){
 399:	83 c3 01             	add    $0x1,%ebx
 39c:	8b 45 0c             	mov    0xc(%ebp),%eax
 39f:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3a3:	84 c0                	test   %al,%al
 3a5:	0f 84 20 01 00 00    	je     4cb <printf+0x15e>
    c = fmt[i] & 0xff;
 3ab:	0f be f8             	movsbl %al,%edi
 3ae:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3b1:	85 f6                	test   %esi,%esi
 3b3:	75 df                	jne    394 <printf+0x27>
      if(c == '%'){
 3b5:	83 f8 25             	cmp    $0x25,%eax
 3b8:	75 ce                	jne    388 <printf+0x1b>
        state = '%';
 3ba:	89 c6                	mov    %eax,%esi
 3bc:	eb db                	jmp    399 <printf+0x2c>
      if(c == 'd'){
 3be:	83 f8 25             	cmp    $0x25,%eax
 3c1:	0f 84 cf 00 00 00    	je     496 <printf+0x129>
 3c7:	0f 8c dd 00 00 00    	jl     4aa <printf+0x13d>
 3cd:	83 f8 78             	cmp    $0x78,%eax
 3d0:	0f 8f d4 00 00 00    	jg     4aa <printf+0x13d>
 3d6:	83 f8 63             	cmp    $0x63,%eax
 3d9:	0f 8c cb 00 00 00    	jl     4aa <printf+0x13d>
 3df:	83 e8 63             	sub    $0x63,%eax
 3e2:	83 f8 15             	cmp    $0x15,%eax
 3e5:	0f 87 bf 00 00 00    	ja     4aa <printf+0x13d>
 3eb:	ff 24 85 2c 06 00 00 	jmp    *0x62c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f5:	8b 17                	mov    (%edi),%edx
 3f7:	83 ec 0c             	sub    $0xc,%esp
 3fa:	6a 01                	push   $0x1
 3fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	e8 d9 fe ff ff       	call   2e2 <printint>
        ap++;
 409:	83 c7 04             	add    $0x4,%edi
 40c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 40f:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 412:	be 00 00 00 00       	mov    $0x0,%esi
 417:	eb 80                	jmp    399 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41c:	8b 17                	mov    (%edi),%edx
 41e:	83 ec 0c             	sub    $0xc,%esp
 421:	6a 00                	push   $0x0
 423:	b9 10 00 00 00       	mov    $0x10,%ecx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	e8 b2 fe ff ff       	call   2e2 <printint>
        ap++;
 430:	83 c7 04             	add    $0x4,%edi
 433:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 436:	83 c4 10             	add    $0x10,%esp
      state = 0;
 439:	be 00 00 00 00       	mov    $0x0,%esi
 43e:	e9 56 ff ff ff       	jmp    399 <printf+0x2c>
        s = (char*)*ap;
 443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 446:	8b 30                	mov    (%eax),%esi
        ap++;
 448:	83 c0 04             	add    $0x4,%eax
 44b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 44e:	85 f6                	test   %esi,%esi
 450:	75 15                	jne    467 <printf+0xfa>
          s = "(null)";
 452:	be 25 06 00 00       	mov    $0x625,%esi
 457:	eb 0e                	jmp    467 <printf+0xfa>
          putc(fd, *s);
 459:	0f be d2             	movsbl %dl,%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	e8 64 fe ff ff       	call   2c8 <putc>
          s++;
 464:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 467:	0f b6 16             	movzbl (%esi),%edx
 46a:	84 d2                	test   %dl,%dl
 46c:	75 eb                	jne    459 <printf+0xec>
      state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
 473:	e9 21 ff ff ff       	jmp    399 <printf+0x2c>
        putc(fd, *ap);
 478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47b:	0f be 17             	movsbl (%edi),%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 42 fe ff ff       	call   2c8 <putc>
        ap++;
 486:	83 c7 04             	add    $0x4,%edi
 489:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 48c:	be 00 00 00 00       	mov    $0x0,%esi
 491:	e9 03 ff ff ff       	jmp    399 <printf+0x2c>
        putc(fd, c);
 496:	89 fa                	mov    %edi,%edx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	e8 28 fe ff ff       	call   2c8 <putc>
      state = 0;
 4a0:	be 00 00 00 00       	mov    $0x0,%esi
 4a5:	e9 ef fe ff ff       	jmp    399 <printf+0x2c>
        putc(fd, '%');
 4aa:	ba 25 00 00 00       	mov    $0x25,%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	e8 11 fe ff ff       	call   2c8 <putc>
        putc(fd, c);
 4b7:	89 fa                	mov    %edi,%edx
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	e8 07 fe ff ff       	call   2c8 <putc>
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 ce fe ff ff       	jmp    399 <printf+0x2c>
    }
  }
}
 4cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ce:	5b                   	pop    %ebx
 4cf:	5e                   	pop    %esi
 4d0:	5f                   	pop    %edi
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    

000004d3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d3:	55                   	push   %ebp
 4d4:	89 e5                	mov    %esp,%ebp
 4d6:	57                   	push   %edi
 4d7:	56                   	push   %esi
 4d8:	53                   	push   %ebx
 4d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4dc:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4df:	a1 30 09 00 00       	mov    0x930,%eax
 4e4:	eb 02                	jmp    4e8 <free+0x15>
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	39 c8                	cmp    %ecx,%eax
 4ea:	73 04                	jae    4f0 <free+0x1d>
 4ec:	39 08                	cmp    %ecx,(%eax)
 4ee:	77 12                	ja     502 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f0:	8b 10                	mov    (%eax),%edx
 4f2:	39 c2                	cmp    %eax,%edx
 4f4:	77 f0                	ja     4e6 <free+0x13>
 4f6:	39 c8                	cmp    %ecx,%eax
 4f8:	72 08                	jb     502 <free+0x2f>
 4fa:	39 ca                	cmp    %ecx,%edx
 4fc:	77 04                	ja     502 <free+0x2f>
 4fe:	89 d0                	mov    %edx,%eax
 500:	eb e6                	jmp    4e8 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 502:	8b 73 fc             	mov    -0x4(%ebx),%esi
 505:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 508:	8b 10                	mov    (%eax),%edx
 50a:	39 d7                	cmp    %edx,%edi
 50c:	74 19                	je     527 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 50e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 511:	8b 50 04             	mov    0x4(%eax),%edx
 514:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 517:	39 ce                	cmp    %ecx,%esi
 519:	74 1b                	je     536 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 51b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 51d:	a3 30 09 00 00       	mov    %eax,0x930
}
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5f                   	pop    %edi
 525:	5d                   	pop    %ebp
 526:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 527:	03 72 04             	add    0x4(%edx),%esi
 52a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 52d:	8b 10                	mov    (%eax),%edx
 52f:	8b 12                	mov    (%edx),%edx
 531:	89 53 f8             	mov    %edx,-0x8(%ebx)
 534:	eb db                	jmp    511 <free+0x3e>
    p->s.size += bp->s.size;
 536:	03 53 fc             	add    -0x4(%ebx),%edx
 539:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 53c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 53f:	89 10                	mov    %edx,(%eax)
 541:	eb da                	jmp    51d <free+0x4a>

00000543 <morecore>:

static Header*
morecore(uint nu)
{
 543:	55                   	push   %ebp
 544:	89 e5                	mov    %esp,%ebp
 546:	53                   	push   %ebx
 547:	83 ec 04             	sub    $0x4,%esp
 54a:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 54c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 551:	77 05                	ja     558 <morecore+0x15>
    nu = 4096;
 553:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 558:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 55f:	83 ec 0c             	sub    $0xc,%esp
 562:	50                   	push   %eax
 563:	e8 10 fd ff ff       	call   278 <sbrk>
  if(p == (char*)-1)
 568:	83 c4 10             	add    $0x10,%esp
 56b:	83 f8 ff             	cmp    $0xffffffff,%eax
 56e:	74 1c                	je     58c <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 570:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 573:	83 c0 08             	add    $0x8,%eax
 576:	83 ec 0c             	sub    $0xc,%esp
 579:	50                   	push   %eax
 57a:	e8 54 ff ff ff       	call   4d3 <free>
  return freep;
 57f:	a1 30 09 00 00       	mov    0x930,%eax
 584:	83 c4 10             	add    $0x10,%esp
}
 587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 58a:	c9                   	leave  
 58b:	c3                   	ret    
    return 0;
 58c:	b8 00 00 00 00       	mov    $0x0,%eax
 591:	eb f4                	jmp    587 <morecore+0x44>

00000593 <malloc>:

void*
malloc(uint nbytes)
{
 593:	55                   	push   %ebp
 594:	89 e5                	mov    %esp,%ebp
 596:	53                   	push   %ebx
 597:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	8d 58 07             	lea    0x7(%eax),%ebx
 5a0:	c1 eb 03             	shr    $0x3,%ebx
 5a3:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a6:	8b 0d 30 09 00 00    	mov    0x930,%ecx
 5ac:	85 c9                	test   %ecx,%ecx
 5ae:	74 04                	je     5b4 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b0:	8b 01                	mov    (%ecx),%eax
 5b2:	eb 4a                	jmp    5fe <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5b4:	c7 05 30 09 00 00 34 	movl   $0x934,0x930
 5bb:	09 00 00 
 5be:	c7 05 34 09 00 00 34 	movl   $0x934,0x934
 5c5:	09 00 00 
    base.s.size = 0;
 5c8:	c7 05 38 09 00 00 00 	movl   $0x0,0x938
 5cf:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5d2:	b9 34 09 00 00       	mov    $0x934,%ecx
 5d7:	eb d7                	jmp    5b0 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d9:	74 19                	je     5f4 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5db:	29 da                	sub    %ebx,%edx
 5dd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5e0:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5e3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e6:	89 0d 30 09 00 00    	mov    %ecx,0x930
      return (void*)(p + 1);
 5ec:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f2:	c9                   	leave  
 5f3:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f4:	8b 10                	mov    (%eax),%edx
 5f6:	89 11                	mov    %edx,(%ecx)
 5f8:	eb ec                	jmp    5e6 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fa:	89 c1                	mov    %eax,%ecx
 5fc:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fe:	8b 50 04             	mov    0x4(%eax),%edx
 601:	39 da                	cmp    %ebx,%edx
 603:	73 d4                	jae    5d9 <malloc+0x46>
    if(p == freep)
 605:	39 05 30 09 00 00    	cmp    %eax,0x930
 60b:	75 ed                	jne    5fa <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 60d:	89 d8                	mov    %ebx,%eax
 60f:	e8 2f ff ff ff       	call   543 <morecore>
 614:	85 c0                	test   %eax,%eax
 616:	75 e2                	jne    5fa <malloc+0x67>
 618:	eb d5                	jmp    5ef <malloc+0x5c>
