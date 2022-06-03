
_manSyCall:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "stddef.h"

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc <= 1)
  12:	83 39 01             	cmpl   $0x1,(%ecx)
  15:	7e 15                	jle    2c <main+0x2c>
    {
        printf(1, "not any argument exititng the program\n");
        printf(1, "manSyCall + any string to print the system call\n");
        exit();
    }
    hello();
  17:	e8 72 02 00 00       	call   28e <hello>
    helloYou(argv[1]);
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	ff 73 04             	push   0x4(%ebx)
  22:	e8 6f 02 00 00       	call   296 <helloYou>
    //
    exit();
  27:	e8 c2 01 00 00       	call   1ee <exit>
        printf(1, "not any argument exititng the program\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 08 06 00 00       	push   $0x608
  34:	6a 01                	push   $0x1
  36:	e8 20 03 00 00       	call   35b <printf>
        printf(1, "manSyCall + any string to print the system call\n");
  3b:	83 c4 08             	add    $0x8,%esp
  3e:	68 30 06 00 00       	push   $0x630
  43:	6a 01                	push   $0x1
  45:	e8 11 03 00 00       	call   35b <printf>
        exit();
  4a:	e8 9f 01 00 00       	call   1ee <exit>

0000004f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  52:	56                   	push   %esi
  53:	53                   	push   %ebx
  54:	8b 75 08             	mov    0x8(%ebp),%esi
  57:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 f0                	mov    %esi,%eax
  5c:	89 d1                	mov    %edx,%ecx
  5e:	83 c2 01             	add    $0x1,%edx
  61:	89 c3                	mov    %eax,%ebx
  63:	83 c0 01             	add    $0x1,%eax
  66:	0f b6 09             	movzbl (%ecx),%ecx
  69:	88 0b                	mov    %cl,(%ebx)
  6b:	84 c9                	test   %cl,%cl
  6d:	75 ed                	jne    5c <strcpy+0xd>
    ;
  return os;
}
  6f:	89 f0                	mov    %esi,%eax
  71:	5b                   	pop    %ebx
  72:	5e                   	pop    %esi
  73:	5d                   	pop    %ebp
  74:	c3                   	ret    

00000075 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7e:	eb 06                	jmp    86 <strcmp+0x11>
    p++, q++;
  80:	83 c1 01             	add    $0x1,%ecx
  83:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  86:	0f b6 01             	movzbl (%ecx),%eax
  89:	84 c0                	test   %al,%al
  8b:	74 04                	je     91 <strcmp+0x1c>
  8d:	3a 02                	cmp    (%edx),%al
  8f:	74 ef                	je     80 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  91:	0f b6 c0             	movzbl %al,%eax
  94:	0f b6 12             	movzbl (%edx),%edx
  97:	29 d0                	sub    %edx,%eax
}
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strlen>:

uint
strlen(const char *s)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a1:	b8 00 00 00 00       	mov    $0x0,%eax
  a6:	eb 03                	jmp    ab <strlen+0x10>
  a8:	83 c0 01             	add    $0x1,%eax
  ab:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  af:	75 f7                	jne    a8 <strlen+0xd>
    ;
  return n;
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	57                   	push   %edi
  b7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ba:	89 d7                	mov    %edx,%edi
  bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	fc                   	cld    
  c3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c5:	89 d0                	mov    %edx,%eax
  c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ca:	c9                   	leave  
  cb:	c3                   	ret    

000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d6:	eb 03                	jmp    db <strchr+0xf>
  d8:	83 c0 01             	add    $0x1,%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	84 d2                	test   %dl,%dl
  e0:	74 06                	je     e8 <strchr+0x1c>
    if(*s == c)
  e2:	38 ca                	cmp    %cl,%dl
  e4:	75 f2                	jne    d8 <strchr+0xc>
  e6:	eb 05                	jmp    ed <strchr+0x21>
      return (char*)s;
  return 0;
  e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <gets>:

char*
gets(char *buf, int max)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	57                   	push   %edi
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	83 ec 1c             	sub    $0x1c,%esp
  f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 100:	89 de                	mov    %ebx,%esi
 102:	83 c3 01             	add    $0x1,%ebx
 105:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 108:	7d 2e                	jge    138 <gets+0x49>
    cc = read(0, &c, 1);
 10a:	83 ec 04             	sub    $0x4,%esp
 10d:	6a 01                	push   $0x1
 10f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 112:	50                   	push   %eax
 113:	6a 00                	push   $0x0
 115:	e8 ec 00 00 00       	call   206 <read>
    if(cc < 1)
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	85 c0                	test   %eax,%eax
 11f:	7e 17                	jle    138 <gets+0x49>
      break;
    buf[i++] = c;
 121:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 125:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	0f 94 c2             	sete   %dl
 12d:	3c 0d                	cmp    $0xd,%al
 12f:	0f 94 c0             	sete   %al
 132:	08 c2                	or     %al,%dl
 134:	74 ca                	je     100 <gets+0x11>
    buf[i++] = c;
 136:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 138:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13c:	89 f8                	mov    %edi,%eax
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    

00000146 <stat>:

int
stat(const char *n, struct stat *st)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	56                   	push   %esi
 14a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	6a 00                	push   $0x0
 150:	ff 75 08             	push   0x8(%ebp)
 153:	e8 d6 00 00 00       	call   22e <open>
  if(fd < 0)
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	78 24                	js     183 <stat+0x3d>
 15f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	ff 75 0c             	push   0xc(%ebp)
 167:	50                   	push   %eax
 168:	e8 d9 00 00 00       	call   246 <fstat>
 16d:	89 c6                	mov    %eax,%esi
  close(fd);
 16f:	89 1c 24             	mov    %ebx,(%esp)
 172:	e8 9f 00 00 00       	call   216 <close>
  return r;
 177:	83 c4 10             	add    $0x10,%esp
}
 17a:	89 f0                	mov    %esi,%eax
 17c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17f:	5b                   	pop    %ebx
 180:	5e                   	pop    %esi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
    return -1;
 183:	be ff ff ff ff       	mov    $0xffffffff,%esi
 188:	eb f0                	jmp    17a <stat+0x34>

0000018a <atoi>:

int
atoi(const char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	53                   	push   %ebx
 18e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 191:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 196:	eb 10                	jmp    1a8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 198:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19b:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 19e:	83 c1 01             	add    $0x1,%ecx
 1a1:	0f be c0             	movsbl %al,%eax
 1a4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a8:	0f b6 01             	movzbl (%ecx),%eax
 1ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ae:	80 fb 09             	cmp    $0x9,%bl
 1b1:	76 e5                	jbe    198 <atoi+0xe>
  return n;
}
 1b3:	89 d0                	mov    %edx,%eax
 1b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	56                   	push   %esi
 1be:	53                   	push   %ebx
 1bf:	8b 75 08             	mov    0x8(%ebp),%esi
 1c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ca:	eb 0d                	jmp    1d9 <memmove+0x1f>
    *dst++ = *src++;
 1cc:	0f b6 01             	movzbl (%ecx),%eax
 1cf:	88 02                	mov    %al,(%edx)
 1d1:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d4:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d7:	89 d8                	mov    %ebx,%eax
 1d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1dc:	85 c0                	test   %eax,%eax
 1de:	7f ec                	jg     1cc <memmove+0x12>
  return vdst;
}
 1e0:	89 f0                	mov    %esi,%eax
 1e2:	5b                   	pop    %ebx
 1e3:	5e                   	pop    %esi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e6:	b8 01 00 00 00       	mov    $0x1,%eax
 1eb:	cd 40                	int    $0x40
 1ed:	c3                   	ret    

000001ee <exit>:
SYSCALL(exit)
 1ee:	b8 02 00 00 00       	mov    $0x2,%eax
 1f3:	cd 40                	int    $0x40
 1f5:	c3                   	ret    

000001f6 <wait>:
SYSCALL(wait)
 1f6:	b8 03 00 00 00       	mov    $0x3,%eax
 1fb:	cd 40                	int    $0x40
 1fd:	c3                   	ret    

000001fe <pipe>:
SYSCALL(pipe)
 1fe:	b8 04 00 00 00       	mov    $0x4,%eax
 203:	cd 40                	int    $0x40
 205:	c3                   	ret    

00000206 <read>:
SYSCALL(read)
 206:	b8 05 00 00 00       	mov    $0x5,%eax
 20b:	cd 40                	int    $0x40
 20d:	c3                   	ret    

0000020e <write>:
SYSCALL(write)
 20e:	b8 10 00 00 00       	mov    $0x10,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <close>:
SYSCALL(close)
 216:	b8 15 00 00 00       	mov    $0x15,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <kill>:
SYSCALL(kill)
 21e:	b8 06 00 00 00       	mov    $0x6,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <exec>:
SYSCALL(exec)
 226:	b8 07 00 00 00       	mov    $0x7,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <open>:
SYSCALL(open)
 22e:	b8 0f 00 00 00       	mov    $0xf,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <mknod>:
SYSCALL(mknod)
 236:	b8 11 00 00 00       	mov    $0x11,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <unlink>:
SYSCALL(unlink)
 23e:	b8 12 00 00 00       	mov    $0x12,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <fstat>:
SYSCALL(fstat)
 246:	b8 08 00 00 00       	mov    $0x8,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <link>:
SYSCALL(link)
 24e:	b8 13 00 00 00       	mov    $0x13,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <mkdir>:
SYSCALL(mkdir)
 256:	b8 14 00 00 00       	mov    $0x14,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <chdir>:
SYSCALL(chdir)
 25e:	b8 09 00 00 00       	mov    $0x9,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <dup>:
SYSCALL(dup)
 266:	b8 0a 00 00 00       	mov    $0xa,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <getpid>:
SYSCALL(getpid)
 26e:	b8 0b 00 00 00       	mov    $0xb,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <sbrk>:
SYSCALL(sbrk)
 276:	b8 0c 00 00 00       	mov    $0xc,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <sleep>:
SYSCALL(sleep)
 27e:	b8 0d 00 00 00       	mov    $0xd,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <uptime>:
SYSCALL(uptime)
 286:	b8 0e 00 00 00       	mov    $0xe,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <hello>:
SYSCALL(hello)
 28e:	b8 16 00 00 00       	mov    $0x16,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <helloYou>:
SYSCALL(helloYou)
 296:	b8 17 00 00 00       	mov    $0x17,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <getppid>:
SYSCALL(getppid)
 29e:	b8 18 00 00 00       	mov    $0x18,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2a6:	b8 19 00 00 00       	mov    $0x19,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <signalProcess>:
 2ae:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b6:	55                   	push   %ebp
 2b7:	89 e5                	mov    %esp,%ebp
 2b9:	83 ec 1c             	sub    $0x1c,%esp
 2bc:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2bf:	6a 01                	push   $0x1
 2c1:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c4:	52                   	push   %edx
 2c5:	50                   	push   %eax
 2c6:	e8 43 ff ff ff       	call   20e <write>
}
 2cb:	83 c4 10             	add    $0x10,%esp
 2ce:	c9                   	leave  
 2cf:	c3                   	ret    

000002d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	53                   	push   %ebx
 2d6:	83 ec 2c             	sub    $0x2c,%esp
 2d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2dc:	89 d0                	mov    %edx,%eax
 2de:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e4:	0f 95 c1             	setne  %cl
 2e7:	c1 ea 1f             	shr    $0x1f,%edx
 2ea:	84 d1                	test   %dl,%cl
 2ec:	74 44                	je     332 <printint+0x62>
    neg = 1;
    x = -xx;
 2ee:	f7 d8                	neg    %eax
 2f0:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2f2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2fe:	89 c8                	mov    %ecx,%eax
 300:	ba 00 00 00 00       	mov    $0x0,%edx
 305:	f7 f6                	div    %esi
 307:	89 df                	mov    %ebx,%edi
 309:	83 c3 01             	add    $0x1,%ebx
 30c:	0f b6 92 c0 06 00 00 	movzbl 0x6c0(%edx),%edx
 313:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 317:	89 ca                	mov    %ecx,%edx
 319:	89 c1                	mov    %eax,%ecx
 31b:	39 d6                	cmp    %edx,%esi
 31d:	76 df                	jbe    2fe <printint+0x2e>
  if(neg)
 31f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 323:	74 31                	je     356 <printint+0x86>
    buf[i++] = '-';
 325:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32a:	8d 5f 02             	lea    0x2(%edi),%ebx
 32d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 330:	eb 17                	jmp    349 <printint+0x79>
    x = xx;
 332:	89 c1                	mov    %eax,%ecx
  neg = 0;
 334:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 33b:	eb bc                	jmp    2f9 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 33d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 342:	89 f0                	mov    %esi,%eax
 344:	e8 6d ff ff ff       	call   2b6 <putc>
  while(--i >= 0)
 349:	83 eb 01             	sub    $0x1,%ebx
 34c:	79 ef                	jns    33d <printint+0x6d>
}
 34e:	83 c4 2c             	add    $0x2c,%esp
 351:	5b                   	pop    %ebx
 352:	5e                   	pop    %esi
 353:	5f                   	pop    %edi
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    
 356:	8b 75 d0             	mov    -0x30(%ebp),%esi
 359:	eb ee                	jmp    349 <printint+0x79>

0000035b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	56                   	push   %esi
 360:	53                   	push   %ebx
 361:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 364:	8d 45 10             	lea    0x10(%ebp),%eax
 367:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 36f:	bb 00 00 00 00       	mov    $0x0,%ebx
 374:	eb 14                	jmp    38a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 376:	89 fa                	mov    %edi,%edx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	e8 36 ff ff ff       	call   2b6 <putc>
 380:	eb 05                	jmp    387 <printf+0x2c>
      }
    } else if(state == '%'){
 382:	83 fe 25             	cmp    $0x25,%esi
 385:	74 25                	je     3ac <printf+0x51>
  for(i = 0; fmt[i]; i++){
 387:	83 c3 01             	add    $0x1,%ebx
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 391:	84 c0                	test   %al,%al
 393:	0f 84 20 01 00 00    	je     4b9 <printf+0x15e>
    c = fmt[i] & 0xff;
 399:	0f be f8             	movsbl %al,%edi
 39c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 39f:	85 f6                	test   %esi,%esi
 3a1:	75 df                	jne    382 <printf+0x27>
      if(c == '%'){
 3a3:	83 f8 25             	cmp    $0x25,%eax
 3a6:	75 ce                	jne    376 <printf+0x1b>
        state = '%';
 3a8:	89 c6                	mov    %eax,%esi
 3aa:	eb db                	jmp    387 <printf+0x2c>
      if(c == 'd'){
 3ac:	83 f8 25             	cmp    $0x25,%eax
 3af:	0f 84 cf 00 00 00    	je     484 <printf+0x129>
 3b5:	0f 8c dd 00 00 00    	jl     498 <printf+0x13d>
 3bb:	83 f8 78             	cmp    $0x78,%eax
 3be:	0f 8f d4 00 00 00    	jg     498 <printf+0x13d>
 3c4:	83 f8 63             	cmp    $0x63,%eax
 3c7:	0f 8c cb 00 00 00    	jl     498 <printf+0x13d>
 3cd:	83 e8 63             	sub    $0x63,%eax
 3d0:	83 f8 15             	cmp    $0x15,%eax
 3d3:	0f 87 bf 00 00 00    	ja     498 <printf+0x13d>
 3d9:	ff 24 85 68 06 00 00 	jmp    *0x668(,%eax,4)
        printint(fd, *ap, 10, 1);
 3e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3e3:	8b 17                	mov    (%edi),%edx
 3e5:	83 ec 0c             	sub    $0xc,%esp
 3e8:	6a 01                	push   $0x1
 3ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	e8 d9 fe ff ff       	call   2d0 <printint>
        ap++;
 3f7:	83 c7 04             	add    $0x4,%edi
 3fa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3fd:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 400:	be 00 00 00 00       	mov    $0x0,%esi
 405:	eb 80                	jmp    387 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40a:	8b 17                	mov    (%edi),%edx
 40c:	83 ec 0c             	sub    $0xc,%esp
 40f:	6a 00                	push   $0x0
 411:	b9 10 00 00 00       	mov    $0x10,%ecx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 b2 fe ff ff       	call   2d0 <printint>
        ap++;
 41e:	83 c7 04             	add    $0x4,%edi
 421:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 424:	83 c4 10             	add    $0x10,%esp
      state = 0;
 427:	be 00 00 00 00       	mov    $0x0,%esi
 42c:	e9 56 ff ff ff       	jmp    387 <printf+0x2c>
        s = (char*)*ap;
 431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 434:	8b 30                	mov    (%eax),%esi
        ap++;
 436:	83 c0 04             	add    $0x4,%eax
 439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 43c:	85 f6                	test   %esi,%esi
 43e:	75 15                	jne    455 <printf+0xfa>
          s = "(null)";
 440:	be 61 06 00 00       	mov    $0x661,%esi
 445:	eb 0e                	jmp    455 <printf+0xfa>
          putc(fd, *s);
 447:	0f be d2             	movsbl %dl,%edx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 64 fe ff ff       	call   2b6 <putc>
          s++;
 452:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 455:	0f b6 16             	movzbl (%esi),%edx
 458:	84 d2                	test   %dl,%dl
 45a:	75 eb                	jne    447 <printf+0xec>
      state = 0;
 45c:	be 00 00 00 00       	mov    $0x0,%esi
 461:	e9 21 ff ff ff       	jmp    387 <printf+0x2c>
        putc(fd, *ap);
 466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 469:	0f be 17             	movsbl (%edi),%edx
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	e8 42 fe ff ff       	call   2b6 <putc>
        ap++;
 474:	83 c7 04             	add    $0x4,%edi
 477:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 47a:	be 00 00 00 00       	mov    $0x0,%esi
 47f:	e9 03 ff ff ff       	jmp    387 <printf+0x2c>
        putc(fd, c);
 484:	89 fa                	mov    %edi,%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	e8 28 fe ff ff       	call   2b6 <putc>
      state = 0;
 48e:	be 00 00 00 00       	mov    $0x0,%esi
 493:	e9 ef fe ff ff       	jmp    387 <printf+0x2c>
        putc(fd, '%');
 498:	ba 25 00 00 00       	mov    $0x25,%edx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	e8 11 fe ff ff       	call   2b6 <putc>
        putc(fd, c);
 4a5:	89 fa                	mov    %edi,%edx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	e8 07 fe ff ff       	call   2b6 <putc>
      state = 0;
 4af:	be 00 00 00 00       	mov    $0x0,%esi
 4b4:	e9 ce fe ff ff       	jmp    387 <printf+0x2c>
    }
  }
}
 4b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bc:	5b                   	pop    %ebx
 4bd:	5e                   	pop    %esi
 4be:	5f                   	pop    %edi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    

000004c1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	57                   	push   %edi
 4c5:	56                   	push   %esi
 4c6:	53                   	push   %ebx
 4c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ca:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4cd:	a1 64 09 00 00       	mov    0x964,%eax
 4d2:	eb 02                	jmp    4d6 <free+0x15>
 4d4:	89 d0                	mov    %edx,%eax
 4d6:	39 c8                	cmp    %ecx,%eax
 4d8:	73 04                	jae    4de <free+0x1d>
 4da:	39 08                	cmp    %ecx,(%eax)
 4dc:	77 12                	ja     4f0 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4de:	8b 10                	mov    (%eax),%edx
 4e0:	39 c2                	cmp    %eax,%edx
 4e2:	77 f0                	ja     4d4 <free+0x13>
 4e4:	39 c8                	cmp    %ecx,%eax
 4e6:	72 08                	jb     4f0 <free+0x2f>
 4e8:	39 ca                	cmp    %ecx,%edx
 4ea:	77 04                	ja     4f0 <free+0x2f>
 4ec:	89 d0                	mov    %edx,%eax
 4ee:	eb e6                	jmp    4d6 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f6:	8b 10                	mov    (%eax),%edx
 4f8:	39 d7                	cmp    %edx,%edi
 4fa:	74 19                	je     515 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4fc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4ff:	8b 50 04             	mov    0x4(%eax),%edx
 502:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 505:	39 ce                	cmp    %ecx,%esi
 507:	74 1b                	je     524 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 509:	89 08                	mov    %ecx,(%eax)
  freep = p;
 50b:	a3 64 09 00 00       	mov    %eax,0x964
}
 510:	5b                   	pop    %ebx
 511:	5e                   	pop    %esi
 512:	5f                   	pop    %edi
 513:	5d                   	pop    %ebp
 514:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 515:	03 72 04             	add    0x4(%edx),%esi
 518:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 51b:	8b 10                	mov    (%eax),%edx
 51d:	8b 12                	mov    (%edx),%edx
 51f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 522:	eb db                	jmp    4ff <free+0x3e>
    p->s.size += bp->s.size;
 524:	03 53 fc             	add    -0x4(%ebx),%edx
 527:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 52a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 52d:	89 10                	mov    %edx,(%eax)
 52f:	eb da                	jmp    50b <free+0x4a>

00000531 <morecore>:

static Header*
morecore(uint nu)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	53                   	push   %ebx
 535:	83 ec 04             	sub    $0x4,%esp
 538:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 53a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 53f:	77 05                	ja     546 <morecore+0x15>
    nu = 4096;
 541:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 546:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 54d:	83 ec 0c             	sub    $0xc,%esp
 550:	50                   	push   %eax
 551:	e8 20 fd ff ff       	call   276 <sbrk>
  if(p == (char*)-1)
 556:	83 c4 10             	add    $0x10,%esp
 559:	83 f8 ff             	cmp    $0xffffffff,%eax
 55c:	74 1c                	je     57a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 55e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 561:	83 c0 08             	add    $0x8,%eax
 564:	83 ec 0c             	sub    $0xc,%esp
 567:	50                   	push   %eax
 568:	e8 54 ff ff ff       	call   4c1 <free>
  return freep;
 56d:	a1 64 09 00 00       	mov    0x964,%eax
 572:	83 c4 10             	add    $0x10,%esp
}
 575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 578:	c9                   	leave  
 579:	c3                   	ret    
    return 0;
 57a:	b8 00 00 00 00       	mov    $0x0,%eax
 57f:	eb f4                	jmp    575 <morecore+0x44>

00000581 <malloc>:

void*
malloc(uint nbytes)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	53                   	push   %ebx
 585:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	8d 58 07             	lea    0x7(%eax),%ebx
 58e:	c1 eb 03             	shr    $0x3,%ebx
 591:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 594:	8b 0d 64 09 00 00    	mov    0x964,%ecx
 59a:	85 c9                	test   %ecx,%ecx
 59c:	74 04                	je     5a2 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 59e:	8b 01                	mov    (%ecx),%eax
 5a0:	eb 4a                	jmp    5ec <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5a2:	c7 05 64 09 00 00 68 	movl   $0x968,0x964
 5a9:	09 00 00 
 5ac:	c7 05 68 09 00 00 68 	movl   $0x968,0x968
 5b3:	09 00 00 
    base.s.size = 0;
 5b6:	c7 05 6c 09 00 00 00 	movl   $0x0,0x96c
 5bd:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5c0:	b9 68 09 00 00       	mov    $0x968,%ecx
 5c5:	eb d7                	jmp    59e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c7:	74 19                	je     5e2 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c9:	29 da                	sub    %ebx,%edx
 5cb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5ce:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5d1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d4:	89 0d 64 09 00 00    	mov    %ecx,0x964
      return (void*)(p + 1);
 5da:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e0:	c9                   	leave  
 5e1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e2:	8b 10                	mov    (%eax),%edx
 5e4:	89 11                	mov    %edx,(%ecx)
 5e6:	eb ec                	jmp    5d4 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e8:	89 c1                	mov    %eax,%ecx
 5ea:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5ec:	8b 50 04             	mov    0x4(%eax),%edx
 5ef:	39 da                	cmp    %ebx,%edx
 5f1:	73 d4                	jae    5c7 <malloc+0x46>
    if(p == freep)
 5f3:	39 05 64 09 00 00    	cmp    %eax,0x964
 5f9:	75 ed                	jne    5e8 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5fb:	89 d8                	mov    %ebx,%eax
 5fd:	e8 2f ff ff ff       	call   531 <morecore>
 602:	85 c0                	test   %eax,%eax
 604:	75 e2                	jne    5e8 <malloc+0x67>
 606:	eb d5                	jmp    5dd <malloc+0x5c>
