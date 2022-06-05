
_test-mmap:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  //   addr[8000] = 'a';

  //   printf(1, "After access of second page: memory usage in pages: virtual: %d, physical %d\n", numvp(), numpp());
  // }

  exit();
   6:	e8 9f 01 00 00       	call   1aa <exit>

0000000b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   b:	55                   	push   %ebp
   c:	89 e5                	mov    %esp,%ebp
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	8b 75 08             	mov    0x8(%ebp),%esi
  13:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  16:	89 f0                	mov    %esi,%eax
  18:	89 d1                	mov    %edx,%ecx
  1a:	83 c2 01             	add    $0x1,%edx
  1d:	89 c3                	mov    %eax,%ebx
  1f:	83 c0 01             	add    $0x1,%eax
  22:	0f b6 09             	movzbl (%ecx),%ecx
  25:	88 0b                	mov    %cl,(%ebx)
  27:	84 c9                	test   %cl,%cl
  29:	75 ed                	jne    18 <strcpy+0xd>
    ;
  return os;
}
  2b:	89 f0                	mov    %esi,%eax
  2d:	5b                   	pop    %ebx
  2e:	5e                   	pop    %esi
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    

00000031 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  37:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  3a:	eb 06                	jmp    42 <strcmp+0x11>
    p++, q++;
  3c:	83 c1 01             	add    $0x1,%ecx
  3f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  42:	0f b6 01             	movzbl (%ecx),%eax
  45:	84 c0                	test   %al,%al
  47:	74 04                	je     4d <strcmp+0x1c>
  49:	3a 02                	cmp    (%edx),%al
  4b:	74 ef                	je     3c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  4d:	0f b6 c0             	movzbl %al,%eax
  50:	0f b6 12             	movzbl (%edx),%edx
  53:	29 d0                	sub    %edx,%eax
}
  55:	5d                   	pop    %ebp
  56:	c3                   	ret    

00000057 <strlen>:

uint
strlen(const char *s)
{
  57:	55                   	push   %ebp
  58:	89 e5                	mov    %esp,%ebp
  5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  5d:	b8 00 00 00 00       	mov    $0x0,%eax
  62:	eb 03                	jmp    67 <strlen+0x10>
  64:	83 c0 01             	add    $0x1,%eax
  67:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  6b:	75 f7                	jne    64 <strlen+0xd>
    ;
  return n;
}
  6d:	5d                   	pop    %ebp
  6e:	c3                   	ret    

0000006f <memset>:

void*
memset(void *dst, int c, uint n)
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	57                   	push   %edi
  73:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  76:	89 d7                	mov    %edx,%edi
  78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  7e:	fc                   	cld    
  7f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  81:	89 d0                	mov    %edx,%eax
  83:	8b 7d fc             	mov    -0x4(%ebp),%edi
  86:	c9                   	leave  
  87:	c3                   	ret    

00000088 <strchr>:

char*
strchr(const char *s, char c)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  92:	eb 03                	jmp    97 <strchr+0xf>
  94:	83 c0 01             	add    $0x1,%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	84 d2                	test   %dl,%dl
  9c:	74 06                	je     a4 <strchr+0x1c>
    if(*s == c)
  9e:	38 ca                	cmp    %cl,%dl
  a0:	75 f2                	jne    94 <strchr+0xc>
  a2:	eb 05                	jmp    a9 <strchr+0x21>
      return (char*)s;
  return 0;
  a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <gets>:

char*
gets(char *buf, int max)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	57                   	push   %edi
  af:	56                   	push   %esi
  b0:	53                   	push   %ebx
  b1:	83 ec 1c             	sub    $0x1c,%esp
  b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  bc:	89 de                	mov    %ebx,%esi
  be:	83 c3 01             	add    $0x1,%ebx
  c1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  c4:	7d 2e                	jge    f4 <gets+0x49>
    cc = read(0, &c, 1);
  c6:	83 ec 04             	sub    $0x4,%esp
  c9:	6a 01                	push   $0x1
  cb:	8d 45 e7             	lea    -0x19(%ebp),%eax
  ce:	50                   	push   %eax
  cf:	6a 00                	push   $0x0
  d1:	e8 ec 00 00 00       	call   1c2 <read>
    if(cc < 1)
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	85 c0                	test   %eax,%eax
  db:	7e 17                	jle    f4 <gets+0x49>
      break;
    buf[i++] = c;
  dd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  e1:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
  e4:	3c 0a                	cmp    $0xa,%al
  e6:	0f 94 c2             	sete   %dl
  e9:	3c 0d                	cmp    $0xd,%al
  eb:	0f 94 c0             	sete   %al
  ee:	08 c2                	or     %al,%dl
  f0:	74 ca                	je     bc <gets+0x11>
    buf[i++] = c;
  f2:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
  f4:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
  f8:	89 f8                	mov    %edi,%eax
  fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  fd:	5b                   	pop    %ebx
  fe:	5e                   	pop    %esi
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <stat>:

int
stat(const char *n, struct stat *st)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	56                   	push   %esi
 106:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	6a 00                	push   $0x0
 10c:	ff 75 08             	push   0x8(%ebp)
 10f:	e8 d6 00 00 00       	call   1ea <open>
  if(fd < 0)
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	78 24                	js     13f <stat+0x3d>
 11b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	ff 75 0c             	push   0xc(%ebp)
 123:	50                   	push   %eax
 124:	e8 d9 00 00 00       	call   202 <fstat>
 129:	89 c6                	mov    %eax,%esi
  close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 9f 00 00 00       	call   1d2 <close>
  return r;
 133:	83 c4 10             	add    $0x10,%esp
}
 136:	89 f0                	mov    %esi,%eax
 138:	8d 65 f8             	lea    -0x8(%ebp),%esp
 13b:	5b                   	pop    %ebx
 13c:	5e                   	pop    %esi
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    
    return -1;
 13f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 144:	eb f0                	jmp    136 <stat+0x34>

00000146 <atoi>:

int
atoi(const char *s)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	53                   	push   %ebx
 14a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 14d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 152:	eb 10                	jmp    164 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 154:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 157:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 15a:	83 c1 01             	add    $0x1,%ecx
 15d:	0f be c0             	movsbl %al,%eax
 160:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 164:	0f b6 01             	movzbl (%ecx),%eax
 167:	8d 58 d0             	lea    -0x30(%eax),%ebx
 16a:	80 fb 09             	cmp    $0x9,%bl
 16d:	76 e5                	jbe    154 <atoi+0xe>
  return n;
}
 16f:	89 d0                	mov    %edx,%eax
 171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	56                   	push   %esi
 17a:	53                   	push   %ebx
 17b:	8b 75 08             	mov    0x8(%ebp),%esi
 17e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 181:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 184:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 186:	eb 0d                	jmp    195 <memmove+0x1f>
    *dst++ = *src++;
 188:	0f b6 01             	movzbl (%ecx),%eax
 18b:	88 02                	mov    %al,(%edx)
 18d:	8d 49 01             	lea    0x1(%ecx),%ecx
 190:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 193:	89 d8                	mov    %ebx,%eax
 195:	8d 58 ff             	lea    -0x1(%eax),%ebx
 198:	85 c0                	test   %eax,%eax
 19a:	7f ec                	jg     188 <memmove+0x12>
  return vdst;
}
 19c:	89 f0                	mov    %esi,%eax
 19e:	5b                   	pop    %ebx
 19f:	5e                   	pop    %esi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1a2:	b8 01 00 00 00       	mov    $0x1,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <exit>:
SYSCALL(exit)
 1aa:	b8 02 00 00 00       	mov    $0x2,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <wait>:
SYSCALL(wait)
 1b2:	b8 03 00 00 00       	mov    $0x3,%eax
 1b7:	cd 40                	int    $0x40
 1b9:	c3                   	ret    

000001ba <pipe>:
SYSCALL(pipe)
 1ba:	b8 04 00 00 00       	mov    $0x4,%eax
 1bf:	cd 40                	int    $0x40
 1c1:	c3                   	ret    

000001c2 <read>:
SYSCALL(read)
 1c2:	b8 05 00 00 00       	mov    $0x5,%eax
 1c7:	cd 40                	int    $0x40
 1c9:	c3                   	ret    

000001ca <write>:
SYSCALL(write)
 1ca:	b8 10 00 00 00       	mov    $0x10,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <close>:
SYSCALL(close)
 1d2:	b8 15 00 00 00       	mov    $0x15,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <kill>:
SYSCALL(kill)
 1da:	b8 06 00 00 00       	mov    $0x6,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <exec>:
SYSCALL(exec)
 1e2:	b8 07 00 00 00       	mov    $0x7,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <open>:
SYSCALL(open)
 1ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <mknod>:
SYSCALL(mknod)
 1f2:	b8 11 00 00 00       	mov    $0x11,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <unlink>:
SYSCALL(unlink)
 1fa:	b8 12 00 00 00       	mov    $0x12,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <fstat>:
SYSCALL(fstat)
 202:	b8 08 00 00 00       	mov    $0x8,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <link>:
SYSCALL(link)
 20a:	b8 13 00 00 00       	mov    $0x13,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <mkdir>:
SYSCALL(mkdir)
 212:	b8 14 00 00 00       	mov    $0x14,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <chdir>:
SYSCALL(chdir)
 21a:	b8 09 00 00 00       	mov    $0x9,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <dup>:
SYSCALL(dup)
 222:	b8 0a 00 00 00       	mov    $0xa,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <getpid>:
SYSCALL(getpid)
 22a:	b8 0b 00 00 00       	mov    $0xb,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <sbrk>:
SYSCALL(sbrk)
 232:	b8 0c 00 00 00       	mov    $0xc,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <sleep>:
SYSCALL(sleep)
 23a:	b8 0d 00 00 00       	mov    $0xd,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <uptime>:
SYSCALL(uptime)
 242:	b8 0e 00 00 00       	mov    $0xe,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <hello>:
SYSCALL(hello)
 24a:	b8 16 00 00 00       	mov    $0x16,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <helloYou>:
SYSCALL(helloYou)
 252:	b8 17 00 00 00       	mov    $0x17,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <getppid>:
SYSCALL(getppid)
 25a:	b8 18 00 00 00       	mov    $0x18,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <get_siblings_info>:
SYSCALL(get_siblings_info)
 262:	b8 19 00 00 00       	mov    $0x19,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <signalProcess>:
SYSCALL(signalProcess)
 26a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <numvp>:
SYSCALL(numvp)
 272:	b8 1b 00 00 00       	mov    $0x1b,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <numpp>:
 27a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 1c             	sub    $0x1c,%esp
 288:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 28b:	6a 01                	push   $0x1
 28d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 290:	52                   	push   %edx
 291:	50                   	push   %eax
 292:	e8 33 ff ff ff       	call   1ca <write>
}
 297:	83 c4 10             	add    $0x10,%esp
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	57                   	push   %edi
 2a0:	56                   	push   %esi
 2a1:	53                   	push   %ebx
 2a2:	83 ec 2c             	sub    $0x2c,%esp
 2a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2a8:	89 d0                	mov    %edx,%eax
 2aa:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2b0:	0f 95 c1             	setne  %cl
 2b3:	c1 ea 1f             	shr    $0x1f,%edx
 2b6:	84 d1                	test   %dl,%cl
 2b8:	74 44                	je     2fe <printint+0x62>
    neg = 1;
    x = -xx;
 2ba:	f7 d8                	neg    %eax
 2bc:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2be:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ca:	89 c8                	mov    %ecx,%eax
 2cc:	ba 00 00 00 00       	mov    $0x0,%edx
 2d1:	f7 f6                	div    %esi
 2d3:	89 df                	mov    %ebx,%edi
 2d5:	83 c3 01             	add    $0x1,%ebx
 2d8:	0f b6 92 34 06 00 00 	movzbl 0x634(%edx),%edx
 2df:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2e3:	89 ca                	mov    %ecx,%edx
 2e5:	89 c1                	mov    %eax,%ecx
 2e7:	39 d6                	cmp    %edx,%esi
 2e9:	76 df                	jbe    2ca <printint+0x2e>
  if(neg)
 2eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 2ef:	74 31                	je     322 <printint+0x86>
    buf[i++] = '-';
 2f1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2f6:	8d 5f 02             	lea    0x2(%edi),%ebx
 2f9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 2fc:	eb 17                	jmp    315 <printint+0x79>
    x = xx;
 2fe:	89 c1                	mov    %eax,%ecx
  neg = 0;
 300:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 307:	eb bc                	jmp    2c5 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 309:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 30e:	89 f0                	mov    %esi,%eax
 310:	e8 6d ff ff ff       	call   282 <putc>
  while(--i >= 0)
 315:	83 eb 01             	sub    $0x1,%ebx
 318:	79 ef                	jns    309 <printint+0x6d>
}
 31a:	83 c4 2c             	add    $0x2c,%esp
 31d:	5b                   	pop    %ebx
 31e:	5e                   	pop    %esi
 31f:	5f                   	pop    %edi
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    
 322:	8b 75 d0             	mov    -0x30(%ebp),%esi
 325:	eb ee                	jmp    315 <printint+0x79>

00000327 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	57                   	push   %edi
 32b:	56                   	push   %esi
 32c:	53                   	push   %ebx
 32d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 330:	8d 45 10             	lea    0x10(%ebp),%eax
 333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 336:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 33b:	bb 00 00 00 00       	mov    $0x0,%ebx
 340:	eb 14                	jmp    356 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 342:	89 fa                	mov    %edi,%edx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	e8 36 ff ff ff       	call   282 <putc>
 34c:	eb 05                	jmp    353 <printf+0x2c>
      }
    } else if(state == '%'){
 34e:	83 fe 25             	cmp    $0x25,%esi
 351:	74 25                	je     378 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 353:	83 c3 01             	add    $0x1,%ebx
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 35d:	84 c0                	test   %al,%al
 35f:	0f 84 20 01 00 00    	je     485 <printf+0x15e>
    c = fmt[i] & 0xff;
 365:	0f be f8             	movsbl %al,%edi
 368:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 36b:	85 f6                	test   %esi,%esi
 36d:	75 df                	jne    34e <printf+0x27>
      if(c == '%'){
 36f:	83 f8 25             	cmp    $0x25,%eax
 372:	75 ce                	jne    342 <printf+0x1b>
        state = '%';
 374:	89 c6                	mov    %eax,%esi
 376:	eb db                	jmp    353 <printf+0x2c>
      if(c == 'd'){
 378:	83 f8 25             	cmp    $0x25,%eax
 37b:	0f 84 cf 00 00 00    	je     450 <printf+0x129>
 381:	0f 8c dd 00 00 00    	jl     464 <printf+0x13d>
 387:	83 f8 78             	cmp    $0x78,%eax
 38a:	0f 8f d4 00 00 00    	jg     464 <printf+0x13d>
 390:	83 f8 63             	cmp    $0x63,%eax
 393:	0f 8c cb 00 00 00    	jl     464 <printf+0x13d>
 399:	83 e8 63             	sub    $0x63,%eax
 39c:	83 f8 15             	cmp    $0x15,%eax
 39f:	0f 87 bf 00 00 00    	ja     464 <printf+0x13d>
 3a5:	ff 24 85 dc 05 00 00 	jmp    *0x5dc(,%eax,4)
        printint(fd, *ap, 10, 1);
 3ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3af:	8b 17                	mov    (%edi),%edx
 3b1:	83 ec 0c             	sub    $0xc,%esp
 3b4:	6a 01                	push   $0x1
 3b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	e8 d9 fe ff ff       	call   29c <printint>
        ap++;
 3c3:	83 c7 04             	add    $0x4,%edi
 3c6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3c9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3cc:	be 00 00 00 00       	mov    $0x0,%esi
 3d1:	eb 80                	jmp    353 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d6:	8b 17                	mov    (%edi),%edx
 3d8:	83 ec 0c             	sub    $0xc,%esp
 3db:	6a 00                	push   $0x0
 3dd:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	e8 b2 fe ff ff       	call   29c <printint>
        ap++;
 3ea:	83 c7 04             	add    $0x4,%edi
 3ed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
 3f8:	e9 56 ff ff ff       	jmp    353 <printf+0x2c>
        s = (char*)*ap;
 3fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 400:	8b 30                	mov    (%eax),%esi
        ap++;
 402:	83 c0 04             	add    $0x4,%eax
 405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 408:	85 f6                	test   %esi,%esi
 40a:	75 15                	jne    421 <printf+0xfa>
          s = "(null)";
 40c:	be d4 05 00 00       	mov    $0x5d4,%esi
 411:	eb 0e                	jmp    421 <printf+0xfa>
          putc(fd, *s);
 413:	0f be d2             	movsbl %dl,%edx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 64 fe ff ff       	call   282 <putc>
          s++;
 41e:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 421:	0f b6 16             	movzbl (%esi),%edx
 424:	84 d2                	test   %dl,%dl
 426:	75 eb                	jne    413 <printf+0xec>
      state = 0;
 428:	be 00 00 00 00       	mov    $0x0,%esi
 42d:	e9 21 ff ff ff       	jmp    353 <printf+0x2c>
        putc(fd, *ap);
 432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 435:	0f be 17             	movsbl (%edi),%edx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 42 fe ff ff       	call   282 <putc>
        ap++;
 440:	83 c7 04             	add    $0x4,%edi
 443:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 446:	be 00 00 00 00       	mov    $0x0,%esi
 44b:	e9 03 ff ff ff       	jmp    353 <printf+0x2c>
        putc(fd, c);
 450:	89 fa                	mov    %edi,%edx
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	e8 28 fe ff ff       	call   282 <putc>
      state = 0;
 45a:	be 00 00 00 00       	mov    $0x0,%esi
 45f:	e9 ef fe ff ff       	jmp    353 <printf+0x2c>
        putc(fd, '%');
 464:	ba 25 00 00 00       	mov    $0x25,%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 11 fe ff ff       	call   282 <putc>
        putc(fd, c);
 471:	89 fa                	mov    %edi,%edx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	e8 07 fe ff ff       	call   282 <putc>
      state = 0;
 47b:	be 00 00 00 00       	mov    $0x0,%esi
 480:	e9 ce fe ff ff       	jmp    353 <printf+0x2c>
    }
  }
}
 485:	8d 65 f4             	lea    -0xc(%ebp),%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    

0000048d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	57                   	push   %edi
 491:	56                   	push   %esi
 492:	53                   	push   %ebx
 493:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 496:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 499:	a1 cc 08 00 00       	mov    0x8cc,%eax
 49e:	eb 02                	jmp    4a2 <free+0x15>
 4a0:	89 d0                	mov    %edx,%eax
 4a2:	39 c8                	cmp    %ecx,%eax
 4a4:	73 04                	jae    4aa <free+0x1d>
 4a6:	39 08                	cmp    %ecx,(%eax)
 4a8:	77 12                	ja     4bc <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4aa:	8b 10                	mov    (%eax),%edx
 4ac:	39 c2                	cmp    %eax,%edx
 4ae:	77 f0                	ja     4a0 <free+0x13>
 4b0:	39 c8                	cmp    %ecx,%eax
 4b2:	72 08                	jb     4bc <free+0x2f>
 4b4:	39 ca                	cmp    %ecx,%edx
 4b6:	77 04                	ja     4bc <free+0x2f>
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	eb e6                	jmp    4a2 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4bc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4bf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4c2:	8b 10                	mov    (%eax),%edx
 4c4:	39 d7                	cmp    %edx,%edi
 4c6:	74 19                	je     4e1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4c8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4cb:	8b 50 04             	mov    0x4(%eax),%edx
 4ce:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4d1:	39 ce                	cmp    %ecx,%esi
 4d3:	74 1b                	je     4f0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4d5:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4d7:	a3 cc 08 00 00       	mov    %eax,0x8cc
}
 4dc:	5b                   	pop    %ebx
 4dd:	5e                   	pop    %esi
 4de:	5f                   	pop    %edi
 4df:	5d                   	pop    %ebp
 4e0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4e1:	03 72 04             	add    0x4(%edx),%esi
 4e4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4e7:	8b 10                	mov    (%eax),%edx
 4e9:	8b 12                	mov    (%edx),%edx
 4eb:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4ee:	eb db                	jmp    4cb <free+0x3e>
    p->s.size += bp->s.size;
 4f0:	03 53 fc             	add    -0x4(%ebx),%edx
 4f3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4f6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4f9:	89 10                	mov    %edx,(%eax)
 4fb:	eb da                	jmp    4d7 <free+0x4a>

000004fd <morecore>:

static Header*
morecore(uint nu)
{
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	53                   	push   %ebx
 501:	83 ec 04             	sub    $0x4,%esp
 504:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 506:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 50b:	77 05                	ja     512 <morecore+0x15>
    nu = 4096;
 50d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 512:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 519:	83 ec 0c             	sub    $0xc,%esp
 51c:	50                   	push   %eax
 51d:	e8 10 fd ff ff       	call   232 <sbrk>
  if(p == (char*)-1)
 522:	83 c4 10             	add    $0x10,%esp
 525:	83 f8 ff             	cmp    $0xffffffff,%eax
 528:	74 1c                	je     546 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 52a:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 52d:	83 c0 08             	add    $0x8,%eax
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	50                   	push   %eax
 534:	e8 54 ff ff ff       	call   48d <free>
  return freep;
 539:	a1 cc 08 00 00       	mov    0x8cc,%eax
 53e:	83 c4 10             	add    $0x10,%esp
}
 541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 544:	c9                   	leave  
 545:	c3                   	ret    
    return 0;
 546:	b8 00 00 00 00       	mov    $0x0,%eax
 54b:	eb f4                	jmp    541 <morecore+0x44>

0000054d <malloc>:

void*
malloc(uint nbytes)
{
 54d:	55                   	push   %ebp
 54e:	89 e5                	mov    %esp,%ebp
 550:	53                   	push   %ebx
 551:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	8d 58 07             	lea    0x7(%eax),%ebx
 55a:	c1 eb 03             	shr    $0x3,%ebx
 55d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 560:	8b 0d cc 08 00 00    	mov    0x8cc,%ecx
 566:	85 c9                	test   %ecx,%ecx
 568:	74 04                	je     56e <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 56a:	8b 01                	mov    (%ecx),%eax
 56c:	eb 4a                	jmp    5b8 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 56e:	c7 05 cc 08 00 00 d0 	movl   $0x8d0,0x8cc
 575:	08 00 00 
 578:	c7 05 d0 08 00 00 d0 	movl   $0x8d0,0x8d0
 57f:	08 00 00 
    base.s.size = 0;
 582:	c7 05 d4 08 00 00 00 	movl   $0x0,0x8d4
 589:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 58c:	b9 d0 08 00 00       	mov    $0x8d0,%ecx
 591:	eb d7                	jmp    56a <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 593:	74 19                	je     5ae <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 595:	29 da                	sub    %ebx,%edx
 597:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 59a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 59d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5a0:	89 0d cc 08 00 00    	mov    %ecx,0x8cc
      return (void*)(p + 1);
 5a6:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ac:	c9                   	leave  
 5ad:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5ae:	8b 10                	mov    (%eax),%edx
 5b0:	89 11                	mov    %edx,(%ecx)
 5b2:	eb ec                	jmp    5a0 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b4:	89 c1                	mov    %eax,%ecx
 5b6:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5b8:	8b 50 04             	mov    0x4(%eax),%edx
 5bb:	39 da                	cmp    %ebx,%edx
 5bd:	73 d4                	jae    593 <malloc+0x46>
    if(p == freep)
 5bf:	39 05 cc 08 00 00    	cmp    %eax,0x8cc
 5c5:	75 ed                	jne    5b4 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5c7:	89 d8                	mov    %ebx,%eax
 5c9:	e8 2f ff ff ff       	call   4fd <morecore>
 5ce:	85 c0                	test   %eax,%eax
 5d0:	75 e2                	jne    5b4 <malloc+0x67>
 5d2:	eb d5                	jmp    5a9 <malloc+0x5c>
