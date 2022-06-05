
_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 28 06 00 00       	push   $0x628
  1f:	6a 02                	push   $0x2
  21:	e8 52 03 00 00       	call   378 <printf>
    exit();
  26:	e8 d0 01 00 00       	call   1fb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	push   0x8(%ebx)
  31:	ff 73 04             	push   0x4(%ebx)
  34:	e8 22 02 00 00       	call   25b <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 b6 01 00 00       	call   1fb <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	push   0x8(%ebx)
  48:	ff 73 04             	push   0x4(%ebx)
  4b:	68 3b 06 00 00       	push   $0x63b
  50:	6a 02                	push   $0x2
  52:	e8 21 03 00 00       	call   378 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	56                   	push   %esi
  60:	53                   	push   %ebx
  61:	8b 75 08             	mov    0x8(%ebp),%esi
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  67:	89 f0                	mov    %esi,%eax
  69:	89 d1                	mov    %edx,%ecx
  6b:	83 c2 01             	add    $0x1,%edx
  6e:	89 c3                	mov    %eax,%ebx
  70:	83 c0 01             	add    $0x1,%eax
  73:	0f b6 09             	movzbl (%ecx),%ecx
  76:	88 0b                	mov    %cl,(%ebx)
  78:	84 c9                	test   %cl,%cl
  7a:	75 ed                	jne    69 <strcpy+0xd>
    ;
  return os;
}
  7c:	89 f0                	mov    %esi,%eax
  7e:	5b                   	pop    %ebx
  7f:	5e                   	pop    %esi
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  88:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8b:	eb 06                	jmp    93 <strcmp+0x11>
    p++, q++;
  8d:	83 c1 01             	add    $0x1,%ecx
  90:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  93:	0f b6 01             	movzbl (%ecx),%eax
  96:	84 c0                	test   %al,%al
  98:	74 04                	je     9e <strcmp+0x1c>
  9a:	3a 02                	cmp    (%edx),%al
  9c:	74 ef                	je     8d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	29 d0                	sub    %edx,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ae:	b8 00 00 00 00       	mov    $0x0,%eax
  b3:	eb 03                	jmp    b8 <strlen+0x10>
  b5:	83 c0 01             	add    $0x1,%eax
  b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  bc:	75 f7                	jne    b5 <strlen+0xd>
    ;
  return n;
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	89 d7                	mov    %edx,%edi
  c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strchr>:

char*
strchr(const char *s, char c)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e3:	eb 03                	jmp    e8 <strchr+0xf>
  e5:	83 c0 01             	add    $0x1,%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	84 d2                	test   %dl,%dl
  ed:	74 06                	je     f5 <strchr+0x1c>
    if(*s == c)
  ef:	38 ca                	cmp    %cl,%dl
  f1:	75 f2                	jne    e5 <strchr+0xc>
  f3:	eb 05                	jmp    fa <strchr+0x21>
      return (char*)s;
  return 0;
  f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	56                   	push   %esi
 101:	53                   	push   %ebx
 102:	83 ec 1c             	sub    $0x1c,%esp
 105:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	bb 00 00 00 00       	mov    $0x0,%ebx
 10d:	89 de                	mov    %ebx,%esi
 10f:	83 c3 01             	add    $0x1,%ebx
 112:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 115:	7d 2e                	jge    145 <gets+0x49>
    cc = read(0, &c, 1);
 117:	83 ec 04             	sub    $0x4,%esp
 11a:	6a 01                	push   $0x1
 11c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 11f:	50                   	push   %eax
 120:	6a 00                	push   $0x0
 122:	e8 ec 00 00 00       	call   213 <read>
    if(cc < 1)
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	7e 17                	jle    145 <gets+0x49>
      break;
    buf[i++] = c;
 12e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 132:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 135:	3c 0a                	cmp    $0xa,%al
 137:	0f 94 c2             	sete   %dl
 13a:	3c 0d                	cmp    $0xd,%al
 13c:	0f 94 c0             	sete   %al
 13f:	08 c2                	or     %al,%dl
 141:	74 ca                	je     10d <gets+0x11>
    buf[i++] = c;
 143:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 145:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 149:	89 f8                	mov    %edi,%eax
 14b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14e:	5b                   	pop    %ebx
 14f:	5e                   	pop    %esi
 150:	5f                   	pop    %edi
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    

00000153 <stat>:

int
stat(const char *n, struct stat *st)
{
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	56                   	push   %esi
 157:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 158:	83 ec 08             	sub    $0x8,%esp
 15b:	6a 00                	push   $0x0
 15d:	ff 75 08             	push   0x8(%ebp)
 160:	e8 d6 00 00 00       	call   23b <open>
  if(fd < 0)
 165:	83 c4 10             	add    $0x10,%esp
 168:	85 c0                	test   %eax,%eax
 16a:	78 24                	js     190 <stat+0x3d>
 16c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	ff 75 0c             	push   0xc(%ebp)
 174:	50                   	push   %eax
 175:	e8 d9 00 00 00       	call   253 <fstat>
 17a:	89 c6                	mov    %eax,%esi
  close(fd);
 17c:	89 1c 24             	mov    %ebx,(%esp)
 17f:	e8 9f 00 00 00       	call   223 <close>
  return r;
 184:	83 c4 10             	add    $0x10,%esp
}
 187:	89 f0                	mov    %esi,%eax
 189:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    
    return -1;
 190:	be ff ff ff ff       	mov    $0xffffffff,%esi
 195:	eb f0                	jmp    187 <stat+0x34>

00000197 <atoi>:

int
atoi(const char *s)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	53                   	push   %ebx
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 19e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a3:	eb 10                	jmp    1b5 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a5:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1a8:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1ab:	83 c1 01             	add    $0x1,%ecx
 1ae:	0f be c0             	movsbl %al,%eax
 1b1:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 01             	movzbl (%ecx),%eax
 1b8:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bb:	80 fb 09             	cmp    $0x9,%bl
 1be:	76 e5                	jbe    1a5 <atoi+0xe>
  return n;
}
 1c0:	89 d0                	mov    %edx,%eax
 1c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	56                   	push   %esi
 1cb:	53                   	push   %ebx
 1cc:	8b 75 08             	mov    0x8(%ebp),%esi
 1cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d2:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d5:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1d7:	eb 0d                	jmp    1e6 <memmove+0x1f>
    *dst++ = *src++;
 1d9:	0f b6 01             	movzbl (%ecx),%eax
 1dc:	88 02                	mov    %al,(%edx)
 1de:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e1:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e4:	89 d8                	mov    %ebx,%eax
 1e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1e9:	85 c0                	test   %eax,%eax
 1eb:	7f ec                	jg     1d9 <memmove+0x12>
  return vdst;
}
 1ed:	89 f0                	mov    %esi,%eax
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f3:	b8 01 00 00 00       	mov    $0x1,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <exit>:
SYSCALL(exit)
 1fb:	b8 02 00 00 00       	mov    $0x2,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <wait>:
SYSCALL(wait)
 203:	b8 03 00 00 00       	mov    $0x3,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <pipe>:
SYSCALL(pipe)
 20b:	b8 04 00 00 00       	mov    $0x4,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <read>:
SYSCALL(read)
 213:	b8 05 00 00 00       	mov    $0x5,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <write>:
SYSCALL(write)
 21b:	b8 10 00 00 00       	mov    $0x10,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <close>:
SYSCALL(close)
 223:	b8 15 00 00 00       	mov    $0x15,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <kill>:
SYSCALL(kill)
 22b:	b8 06 00 00 00       	mov    $0x6,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <exec>:
SYSCALL(exec)
 233:	b8 07 00 00 00       	mov    $0x7,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <open>:
SYSCALL(open)
 23b:	b8 0f 00 00 00       	mov    $0xf,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <mknod>:
SYSCALL(mknod)
 243:	b8 11 00 00 00       	mov    $0x11,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <unlink>:
SYSCALL(unlink)
 24b:	b8 12 00 00 00       	mov    $0x12,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <fstat>:
SYSCALL(fstat)
 253:	b8 08 00 00 00       	mov    $0x8,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <link>:
SYSCALL(link)
 25b:	b8 13 00 00 00       	mov    $0x13,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <mkdir>:
SYSCALL(mkdir)
 263:	b8 14 00 00 00       	mov    $0x14,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <chdir>:
SYSCALL(chdir)
 26b:	b8 09 00 00 00       	mov    $0x9,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <dup>:
SYSCALL(dup)
 273:	b8 0a 00 00 00       	mov    $0xa,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <getpid>:
SYSCALL(getpid)
 27b:	b8 0b 00 00 00       	mov    $0xb,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <sbrk>:
SYSCALL(sbrk)
 283:	b8 0c 00 00 00       	mov    $0xc,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <sleep>:
SYSCALL(sleep)
 28b:	b8 0d 00 00 00       	mov    $0xd,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <uptime>:
SYSCALL(uptime)
 293:	b8 0e 00 00 00       	mov    $0xe,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <hello>:
SYSCALL(hello)
 29b:	b8 16 00 00 00       	mov    $0x16,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <helloYou>:
SYSCALL(helloYou)
 2a3:	b8 17 00 00 00       	mov    $0x17,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <getppid>:
SYSCALL(getppid)
 2ab:	b8 18 00 00 00       	mov    $0x18,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b3:	b8 19 00 00 00       	mov    $0x19,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <signalProcess>:
SYSCALL(signalProcess)
 2bb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <numvp>:
SYSCALL(numvp)
 2c3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <numpp>:
 2cb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 1c             	sub    $0x1c,%esp
 2d9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2dc:	6a 01                	push   $0x1
 2de:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e1:	52                   	push   %edx
 2e2:	50                   	push   %eax
 2e3:	e8 33 ff ff ff       	call   21b <write>
}
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	57                   	push   %edi
 2f1:	56                   	push   %esi
 2f2:	53                   	push   %ebx
 2f3:	83 ec 2c             	sub    $0x2c,%esp
 2f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2f9:	89 d0                	mov    %edx,%eax
 2fb:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 301:	0f 95 c1             	setne  %cl
 304:	c1 ea 1f             	shr    $0x1f,%edx
 307:	84 d1                	test   %dl,%cl
 309:	74 44                	je     34f <printint+0x62>
    neg = 1;
    x = -xx;
 30b:	f7 d8                	neg    %eax
 30d:	89 c1                	mov    %eax,%ecx
    neg = 1;
 30f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 316:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 31b:	89 c8                	mov    %ecx,%eax
 31d:	ba 00 00 00 00       	mov    $0x0,%edx
 322:	f7 f6                	div    %esi
 324:	89 df                	mov    %ebx,%edi
 326:	83 c3 01             	add    $0x1,%ebx
 329:	0f b6 92 b0 06 00 00 	movzbl 0x6b0(%edx),%edx
 330:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 334:	89 ca                	mov    %ecx,%edx
 336:	89 c1                	mov    %eax,%ecx
 338:	39 d6                	cmp    %edx,%esi
 33a:	76 df                	jbe    31b <printint+0x2e>
  if(neg)
 33c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 340:	74 31                	je     373 <printint+0x86>
    buf[i++] = '-';
 342:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 347:	8d 5f 02             	lea    0x2(%edi),%ebx
 34a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 34d:	eb 17                	jmp    366 <printint+0x79>
    x = xx;
 34f:	89 c1                	mov    %eax,%ecx
  neg = 0;
 351:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 358:	eb bc                	jmp    316 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 35a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 35f:	89 f0                	mov    %esi,%eax
 361:	e8 6d ff ff ff       	call   2d3 <putc>
  while(--i >= 0)
 366:	83 eb 01             	sub    $0x1,%ebx
 369:	79 ef                	jns    35a <printint+0x6d>
}
 36b:	83 c4 2c             	add    $0x2c,%esp
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5f                   	pop    %edi
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8b 75 d0             	mov    -0x30(%ebp),%esi
 376:	eb ee                	jmp    366 <printint+0x79>

00000378 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	57                   	push   %edi
 37c:	56                   	push   %esi
 37d:	53                   	push   %ebx
 37e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 381:	8d 45 10             	lea    0x10(%ebp),%eax
 384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 387:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 38c:	bb 00 00 00 00       	mov    $0x0,%ebx
 391:	eb 14                	jmp    3a7 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 393:	89 fa                	mov    %edi,%edx
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	e8 36 ff ff ff       	call   2d3 <putc>
 39d:	eb 05                	jmp    3a4 <printf+0x2c>
      }
    } else if(state == '%'){
 39f:	83 fe 25             	cmp    $0x25,%esi
 3a2:	74 25                	je     3c9 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3a4:	83 c3 01             	add    $0x1,%ebx
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3ae:	84 c0                	test   %al,%al
 3b0:	0f 84 20 01 00 00    	je     4d6 <printf+0x15e>
    c = fmt[i] & 0xff;
 3b6:	0f be f8             	movsbl %al,%edi
 3b9:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3bc:	85 f6                	test   %esi,%esi
 3be:	75 df                	jne    39f <printf+0x27>
      if(c == '%'){
 3c0:	83 f8 25             	cmp    $0x25,%eax
 3c3:	75 ce                	jne    393 <printf+0x1b>
        state = '%';
 3c5:	89 c6                	mov    %eax,%esi
 3c7:	eb db                	jmp    3a4 <printf+0x2c>
      if(c == 'd'){
 3c9:	83 f8 25             	cmp    $0x25,%eax
 3cc:	0f 84 cf 00 00 00    	je     4a1 <printf+0x129>
 3d2:	0f 8c dd 00 00 00    	jl     4b5 <printf+0x13d>
 3d8:	83 f8 78             	cmp    $0x78,%eax
 3db:	0f 8f d4 00 00 00    	jg     4b5 <printf+0x13d>
 3e1:	83 f8 63             	cmp    $0x63,%eax
 3e4:	0f 8c cb 00 00 00    	jl     4b5 <printf+0x13d>
 3ea:	83 e8 63             	sub    $0x63,%eax
 3ed:	83 f8 15             	cmp    $0x15,%eax
 3f0:	0f 87 bf 00 00 00    	ja     4b5 <printf+0x13d>
 3f6:	ff 24 85 58 06 00 00 	jmp    *0x658(,%eax,4)
        printint(fd, *ap, 10, 1);
 3fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 400:	8b 17                	mov    (%edi),%edx
 402:	83 ec 0c             	sub    $0xc,%esp
 405:	6a 01                	push   $0x1
 407:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	e8 d9 fe ff ff       	call   2ed <printint>
        ap++;
 414:	83 c7 04             	add    $0x4,%edi
 417:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 41d:	be 00 00 00 00       	mov    $0x0,%esi
 422:	eb 80                	jmp    3a4 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 424:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 427:	8b 17                	mov    (%edi),%edx
 429:	83 ec 0c             	sub    $0xc,%esp
 42c:	6a 00                	push   $0x0
 42e:	b9 10 00 00 00       	mov    $0x10,%ecx
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	e8 b2 fe ff ff       	call   2ed <printint>
        ap++;
 43b:	83 c7 04             	add    $0x4,%edi
 43e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 441:	83 c4 10             	add    $0x10,%esp
      state = 0;
 444:	be 00 00 00 00       	mov    $0x0,%esi
 449:	e9 56 ff ff ff       	jmp    3a4 <printf+0x2c>
        s = (char*)*ap;
 44e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 451:	8b 30                	mov    (%eax),%esi
        ap++;
 453:	83 c0 04             	add    $0x4,%eax
 456:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 459:	85 f6                	test   %esi,%esi
 45b:	75 15                	jne    472 <printf+0xfa>
          s = "(null)";
 45d:	be 4f 06 00 00       	mov    $0x64f,%esi
 462:	eb 0e                	jmp    472 <printf+0xfa>
          putc(fd, *s);
 464:	0f be d2             	movsbl %dl,%edx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	e8 64 fe ff ff       	call   2d3 <putc>
          s++;
 46f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 472:	0f b6 16             	movzbl (%esi),%edx
 475:	84 d2                	test   %dl,%dl
 477:	75 eb                	jne    464 <printf+0xec>
      state = 0;
 479:	be 00 00 00 00       	mov    $0x0,%esi
 47e:	e9 21 ff ff ff       	jmp    3a4 <printf+0x2c>
        putc(fd, *ap);
 483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 486:	0f be 17             	movsbl (%edi),%edx
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	e8 42 fe ff ff       	call   2d3 <putc>
        ap++;
 491:	83 c7 04             	add    $0x4,%edi
 494:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 497:	be 00 00 00 00       	mov    $0x0,%esi
 49c:	e9 03 ff ff ff       	jmp    3a4 <printf+0x2c>
        putc(fd, c);
 4a1:	89 fa                	mov    %edi,%edx
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	e8 28 fe ff ff       	call   2d3 <putc>
      state = 0;
 4ab:	be 00 00 00 00       	mov    $0x0,%esi
 4b0:	e9 ef fe ff ff       	jmp    3a4 <printf+0x2c>
        putc(fd, '%');
 4b5:	ba 25 00 00 00       	mov    $0x25,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 11 fe ff ff       	call   2d3 <putc>
        putc(fd, c);
 4c2:	89 fa                	mov    %edi,%edx
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	e8 07 fe ff ff       	call   2d3 <putc>
      state = 0;
 4cc:	be 00 00 00 00       	mov    $0x0,%esi
 4d1:	e9 ce fe ff ff       	jmp    3a4 <printf+0x2c>
    }
  }
}
 4d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5f                   	pop    %edi
 4dc:	5d                   	pop    %ebp
 4dd:	c3                   	ret    

000004de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	57                   	push   %edi
 4e2:	56                   	push   %esi
 4e3:	53                   	push   %ebx
 4e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ea:	a1 54 09 00 00       	mov    0x954,%eax
 4ef:	eb 02                	jmp    4f3 <free+0x15>
 4f1:	89 d0                	mov    %edx,%eax
 4f3:	39 c8                	cmp    %ecx,%eax
 4f5:	73 04                	jae    4fb <free+0x1d>
 4f7:	39 08                	cmp    %ecx,(%eax)
 4f9:	77 12                	ja     50d <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4fb:	8b 10                	mov    (%eax),%edx
 4fd:	39 c2                	cmp    %eax,%edx
 4ff:	77 f0                	ja     4f1 <free+0x13>
 501:	39 c8                	cmp    %ecx,%eax
 503:	72 08                	jb     50d <free+0x2f>
 505:	39 ca                	cmp    %ecx,%edx
 507:	77 04                	ja     50d <free+0x2f>
 509:	89 d0                	mov    %edx,%eax
 50b:	eb e6                	jmp    4f3 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 50d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 510:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 513:	8b 10                	mov    (%eax),%edx
 515:	39 d7                	cmp    %edx,%edi
 517:	74 19                	je     532 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 519:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 51c:	8b 50 04             	mov    0x4(%eax),%edx
 51f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 522:	39 ce                	cmp    %ecx,%esi
 524:	74 1b                	je     541 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 526:	89 08                	mov    %ecx,(%eax)
  freep = p;
 528:	a3 54 09 00 00       	mov    %eax,0x954
}
 52d:	5b                   	pop    %ebx
 52e:	5e                   	pop    %esi
 52f:	5f                   	pop    %edi
 530:	5d                   	pop    %ebp
 531:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 532:	03 72 04             	add    0x4(%edx),%esi
 535:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 538:	8b 10                	mov    (%eax),%edx
 53a:	8b 12                	mov    (%edx),%edx
 53c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 53f:	eb db                	jmp    51c <free+0x3e>
    p->s.size += bp->s.size;
 541:	03 53 fc             	add    -0x4(%ebx),%edx
 544:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 547:	8b 53 f8             	mov    -0x8(%ebx),%edx
 54a:	89 10                	mov    %edx,(%eax)
 54c:	eb da                	jmp    528 <free+0x4a>

0000054e <morecore>:

static Header*
morecore(uint nu)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	53                   	push   %ebx
 552:	83 ec 04             	sub    $0x4,%esp
 555:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 557:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 55c:	77 05                	ja     563 <morecore+0x15>
    nu = 4096;
 55e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 563:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 56a:	83 ec 0c             	sub    $0xc,%esp
 56d:	50                   	push   %eax
 56e:	e8 10 fd ff ff       	call   283 <sbrk>
  if(p == (char*)-1)
 573:	83 c4 10             	add    $0x10,%esp
 576:	83 f8 ff             	cmp    $0xffffffff,%eax
 579:	74 1c                	je     597 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 57b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 57e:	83 c0 08             	add    $0x8,%eax
 581:	83 ec 0c             	sub    $0xc,%esp
 584:	50                   	push   %eax
 585:	e8 54 ff ff ff       	call   4de <free>
  return freep;
 58a:	a1 54 09 00 00       	mov    0x954,%eax
 58f:	83 c4 10             	add    $0x10,%esp
}
 592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 595:	c9                   	leave  
 596:	c3                   	ret    
    return 0;
 597:	b8 00 00 00 00       	mov    $0x0,%eax
 59c:	eb f4                	jmp    592 <morecore+0x44>

0000059e <malloc>:

void*
malloc(uint nbytes)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	53                   	push   %ebx
 5a2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	8d 58 07             	lea    0x7(%eax),%ebx
 5ab:	c1 eb 03             	shr    $0x3,%ebx
 5ae:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b1:	8b 0d 54 09 00 00    	mov    0x954,%ecx
 5b7:	85 c9                	test   %ecx,%ecx
 5b9:	74 04                	je     5bf <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5bb:	8b 01                	mov    (%ecx),%eax
 5bd:	eb 4a                	jmp    609 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5bf:	c7 05 54 09 00 00 58 	movl   $0x958,0x954
 5c6:	09 00 00 
 5c9:	c7 05 58 09 00 00 58 	movl   $0x958,0x958
 5d0:	09 00 00 
    base.s.size = 0;
 5d3:	c7 05 5c 09 00 00 00 	movl   $0x0,0x95c
 5da:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5dd:	b9 58 09 00 00       	mov    $0x958,%ecx
 5e2:	eb d7                	jmp    5bb <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5e4:	74 19                	je     5ff <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5e6:	29 da                	sub    %ebx,%edx
 5e8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5eb:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5ee:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f1:	89 0d 54 09 00 00    	mov    %ecx,0x954
      return (void*)(p + 1);
 5f7:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fd:	c9                   	leave  
 5fe:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5ff:	8b 10                	mov    (%eax),%edx
 601:	89 11                	mov    %edx,(%ecx)
 603:	eb ec                	jmp    5f1 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 605:	89 c1                	mov    %eax,%ecx
 607:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 609:	8b 50 04             	mov    0x4(%eax),%edx
 60c:	39 da                	cmp    %ebx,%edx
 60e:	73 d4                	jae    5e4 <malloc+0x46>
    if(p == freep)
 610:	39 05 54 09 00 00    	cmp    %eax,0x954
 616:	75 ed                	jne    605 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 618:	89 d8                	mov    %ebx,%eax
 61a:	e8 2f ff ff ff       	call   54e <morecore>
 61f:	85 c0                	test   %eax,%eax
 621:	75 e2                	jne    605 <malloc+0x67>
 623:	eb d5                	jmp    5fa <malloc+0x5c>
