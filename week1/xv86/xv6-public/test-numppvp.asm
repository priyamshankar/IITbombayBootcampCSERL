
_test-numppvp:     file format elf32-i386


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
  // sbrk(8192);
  // int nvpages = numvp();
  // int nppages = numpp();
  // printf(1, "Total user virtual pages now: %d \n", nvpages);
  // printf(1, "Total user physical pages now: %d \n", nppages);
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
 26a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 1c             	sub    $0x1c,%esp
 278:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 27b:	6a 01                	push   $0x1
 27d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 280:	52                   	push   %edx
 281:	50                   	push   %eax
 282:	e8 43 ff ff ff       	call   1ca <write>
}
 287:	83 c4 10             	add    $0x10,%esp
 28a:	c9                   	leave  
 28b:	c3                   	ret    

0000028c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	57                   	push   %edi
 290:	56                   	push   %esi
 291:	53                   	push   %ebx
 292:	83 ec 2c             	sub    $0x2c,%esp
 295:	89 45 d0             	mov    %eax,-0x30(%ebp)
 298:	89 d0                	mov    %edx,%eax
 29a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 29c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2a0:	0f 95 c1             	setne  %cl
 2a3:	c1 ea 1f             	shr    $0x1f,%edx
 2a6:	84 d1                	test   %dl,%cl
 2a8:	74 44                	je     2ee <printint+0x62>
    neg = 1;
    x = -xx;
 2aa:	f7 d8                	neg    %eax
 2ac:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ba:	89 c8                	mov    %ecx,%eax
 2bc:	ba 00 00 00 00       	mov    $0x0,%edx
 2c1:	f7 f6                	div    %esi
 2c3:	89 df                	mov    %ebx,%edi
 2c5:	83 c3 01             	add    $0x1,%ebx
 2c8:	0f b6 92 24 06 00 00 	movzbl 0x624(%edx),%edx
 2cf:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2d3:	89 ca                	mov    %ecx,%edx
 2d5:	89 c1                	mov    %eax,%ecx
 2d7:	39 d6                	cmp    %edx,%esi
 2d9:	76 df                	jbe    2ba <printint+0x2e>
  if(neg)
 2db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 2df:	74 31                	je     312 <printint+0x86>
    buf[i++] = '-';
 2e1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2e6:	8d 5f 02             	lea    0x2(%edi),%ebx
 2e9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 2ec:	eb 17                	jmp    305 <printint+0x79>
    x = xx;
 2ee:	89 c1                	mov    %eax,%ecx
  neg = 0;
 2f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 2f7:	eb bc                	jmp    2b5 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 2f9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2fe:	89 f0                	mov    %esi,%eax
 300:	e8 6d ff ff ff       	call   272 <putc>
  while(--i >= 0)
 305:	83 eb 01             	sub    $0x1,%ebx
 308:	79 ef                	jns    2f9 <printint+0x6d>
}
 30a:	83 c4 2c             	add    $0x2c,%esp
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    
 312:	8b 75 d0             	mov    -0x30(%ebp),%esi
 315:	eb ee                	jmp    305 <printint+0x79>

00000317 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	57                   	push   %edi
 31b:	56                   	push   %esi
 31c:	53                   	push   %ebx
 31d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 320:	8d 45 10             	lea    0x10(%ebp),%eax
 323:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 326:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 32b:	bb 00 00 00 00       	mov    $0x0,%ebx
 330:	eb 14                	jmp    346 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 332:	89 fa                	mov    %edi,%edx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	e8 36 ff ff ff       	call   272 <putc>
 33c:	eb 05                	jmp    343 <printf+0x2c>
      }
    } else if(state == '%'){
 33e:	83 fe 25             	cmp    $0x25,%esi
 341:	74 25                	je     368 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 343:	83 c3 01             	add    $0x1,%ebx
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 34d:	84 c0                	test   %al,%al
 34f:	0f 84 20 01 00 00    	je     475 <printf+0x15e>
    c = fmt[i] & 0xff;
 355:	0f be f8             	movsbl %al,%edi
 358:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 35b:	85 f6                	test   %esi,%esi
 35d:	75 df                	jne    33e <printf+0x27>
      if(c == '%'){
 35f:	83 f8 25             	cmp    $0x25,%eax
 362:	75 ce                	jne    332 <printf+0x1b>
        state = '%';
 364:	89 c6                	mov    %eax,%esi
 366:	eb db                	jmp    343 <printf+0x2c>
      if(c == 'd'){
 368:	83 f8 25             	cmp    $0x25,%eax
 36b:	0f 84 cf 00 00 00    	je     440 <printf+0x129>
 371:	0f 8c dd 00 00 00    	jl     454 <printf+0x13d>
 377:	83 f8 78             	cmp    $0x78,%eax
 37a:	0f 8f d4 00 00 00    	jg     454 <printf+0x13d>
 380:	83 f8 63             	cmp    $0x63,%eax
 383:	0f 8c cb 00 00 00    	jl     454 <printf+0x13d>
 389:	83 e8 63             	sub    $0x63,%eax
 38c:	83 f8 15             	cmp    $0x15,%eax
 38f:	0f 87 bf 00 00 00    	ja     454 <printf+0x13d>
 395:	ff 24 85 cc 05 00 00 	jmp    *0x5cc(,%eax,4)
        printint(fd, *ap, 10, 1);
 39c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 39f:	8b 17                	mov    (%edi),%edx
 3a1:	83 ec 0c             	sub    $0xc,%esp
 3a4:	6a 01                	push   $0x1
 3a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	e8 d9 fe ff ff       	call   28c <printint>
        ap++;
 3b3:	83 c7 04             	add    $0x4,%edi
 3b6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3b9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3bc:	be 00 00 00 00       	mov    $0x0,%esi
 3c1:	eb 80                	jmp    343 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3c6:	8b 17                	mov    (%edi),%edx
 3c8:	83 ec 0c             	sub    $0xc,%esp
 3cb:	6a 00                	push   $0x0
 3cd:	b9 10 00 00 00       	mov    $0x10,%ecx
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	e8 b2 fe ff ff       	call   28c <printint>
        ap++;
 3da:	83 c7 04             	add    $0x4,%edi
 3dd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3e0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3e3:	be 00 00 00 00       	mov    $0x0,%esi
 3e8:	e9 56 ff ff ff       	jmp    343 <printf+0x2c>
        s = (char*)*ap;
 3ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3f0:	8b 30                	mov    (%eax),%esi
        ap++;
 3f2:	83 c0 04             	add    $0x4,%eax
 3f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3f8:	85 f6                	test   %esi,%esi
 3fa:	75 15                	jne    411 <printf+0xfa>
          s = "(null)";
 3fc:	be c4 05 00 00       	mov    $0x5c4,%esi
 401:	eb 0e                	jmp    411 <printf+0xfa>
          putc(fd, *s);
 403:	0f be d2             	movsbl %dl,%edx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	e8 64 fe ff ff       	call   272 <putc>
          s++;
 40e:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 411:	0f b6 16             	movzbl (%esi),%edx
 414:	84 d2                	test   %dl,%dl
 416:	75 eb                	jne    403 <printf+0xec>
      state = 0;
 418:	be 00 00 00 00       	mov    $0x0,%esi
 41d:	e9 21 ff ff ff       	jmp    343 <printf+0x2c>
        putc(fd, *ap);
 422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 425:	0f be 17             	movsbl (%edi),%edx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	e8 42 fe ff ff       	call   272 <putc>
        ap++;
 430:	83 c7 04             	add    $0x4,%edi
 433:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 436:	be 00 00 00 00       	mov    $0x0,%esi
 43b:	e9 03 ff ff ff       	jmp    343 <printf+0x2c>
        putc(fd, c);
 440:	89 fa                	mov    %edi,%edx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	e8 28 fe ff ff       	call   272 <putc>
      state = 0;
 44a:	be 00 00 00 00       	mov    $0x0,%esi
 44f:	e9 ef fe ff ff       	jmp    343 <printf+0x2c>
        putc(fd, '%');
 454:	ba 25 00 00 00       	mov    $0x25,%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	e8 11 fe ff ff       	call   272 <putc>
        putc(fd, c);
 461:	89 fa                	mov    %edi,%edx
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	e8 07 fe ff ff       	call   272 <putc>
      state = 0;
 46b:	be 00 00 00 00       	mov    $0x0,%esi
 470:	e9 ce fe ff ff       	jmp    343 <printf+0x2c>
    }
  }
}
 475:	8d 65 f4             	lea    -0xc(%ebp),%esp
 478:	5b                   	pop    %ebx
 479:	5e                   	pop    %esi
 47a:	5f                   	pop    %edi
 47b:	5d                   	pop    %ebp
 47c:	c3                   	ret    

0000047d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 47d:	55                   	push   %ebp
 47e:	89 e5                	mov    %esp,%ebp
 480:	57                   	push   %edi
 481:	56                   	push   %esi
 482:	53                   	push   %ebx
 483:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 486:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 489:	a1 bc 08 00 00       	mov    0x8bc,%eax
 48e:	eb 02                	jmp    492 <free+0x15>
 490:	89 d0                	mov    %edx,%eax
 492:	39 c8                	cmp    %ecx,%eax
 494:	73 04                	jae    49a <free+0x1d>
 496:	39 08                	cmp    %ecx,(%eax)
 498:	77 12                	ja     4ac <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 49a:	8b 10                	mov    (%eax),%edx
 49c:	39 c2                	cmp    %eax,%edx
 49e:	77 f0                	ja     490 <free+0x13>
 4a0:	39 c8                	cmp    %ecx,%eax
 4a2:	72 08                	jb     4ac <free+0x2f>
 4a4:	39 ca                	cmp    %ecx,%edx
 4a6:	77 04                	ja     4ac <free+0x2f>
 4a8:	89 d0                	mov    %edx,%eax
 4aa:	eb e6                	jmp    492 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ac:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4af:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4b2:	8b 10                	mov    (%eax),%edx
 4b4:	39 d7                	cmp    %edx,%edi
 4b6:	74 19                	je     4d1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4b8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4bb:	8b 50 04             	mov    0x4(%eax),%edx
 4be:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4c1:	39 ce                	cmp    %ecx,%esi
 4c3:	74 1b                	je     4e0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4c5:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4c7:	a3 bc 08 00 00       	mov    %eax,0x8bc
}
 4cc:	5b                   	pop    %ebx
 4cd:	5e                   	pop    %esi
 4ce:	5f                   	pop    %edi
 4cf:	5d                   	pop    %ebp
 4d0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4d1:	03 72 04             	add    0x4(%edx),%esi
 4d4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4d7:	8b 10                	mov    (%eax),%edx
 4d9:	8b 12                	mov    (%edx),%edx
 4db:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4de:	eb db                	jmp    4bb <free+0x3e>
    p->s.size += bp->s.size;
 4e0:	03 53 fc             	add    -0x4(%ebx),%edx
 4e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4e6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4e9:	89 10                	mov    %edx,(%eax)
 4eb:	eb da                	jmp    4c7 <free+0x4a>

000004ed <morecore>:

static Header*
morecore(uint nu)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	53                   	push   %ebx
 4f1:	83 ec 04             	sub    $0x4,%esp
 4f4:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 4f6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 4fb:	77 05                	ja     502 <morecore+0x15>
    nu = 4096;
 4fd:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 502:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 509:	83 ec 0c             	sub    $0xc,%esp
 50c:	50                   	push   %eax
 50d:	e8 20 fd ff ff       	call   232 <sbrk>
  if(p == (char*)-1)
 512:	83 c4 10             	add    $0x10,%esp
 515:	83 f8 ff             	cmp    $0xffffffff,%eax
 518:	74 1c                	je     536 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 51a:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 51d:	83 c0 08             	add    $0x8,%eax
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	50                   	push   %eax
 524:	e8 54 ff ff ff       	call   47d <free>
  return freep;
 529:	a1 bc 08 00 00       	mov    0x8bc,%eax
 52e:	83 c4 10             	add    $0x10,%esp
}
 531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 534:	c9                   	leave  
 535:	c3                   	ret    
    return 0;
 536:	b8 00 00 00 00       	mov    $0x0,%eax
 53b:	eb f4                	jmp    531 <morecore+0x44>

0000053d <malloc>:

void*
malloc(uint nbytes)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	53                   	push   %ebx
 541:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	8d 58 07             	lea    0x7(%eax),%ebx
 54a:	c1 eb 03             	shr    $0x3,%ebx
 54d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 550:	8b 0d bc 08 00 00    	mov    0x8bc,%ecx
 556:	85 c9                	test   %ecx,%ecx
 558:	74 04                	je     55e <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 55a:	8b 01                	mov    (%ecx),%eax
 55c:	eb 4a                	jmp    5a8 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 55e:	c7 05 bc 08 00 00 c0 	movl   $0x8c0,0x8bc
 565:	08 00 00 
 568:	c7 05 c0 08 00 00 c0 	movl   $0x8c0,0x8c0
 56f:	08 00 00 
    base.s.size = 0;
 572:	c7 05 c4 08 00 00 00 	movl   $0x0,0x8c4
 579:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 57c:	b9 c0 08 00 00       	mov    $0x8c0,%ecx
 581:	eb d7                	jmp    55a <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 583:	74 19                	je     59e <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 585:	29 da                	sub    %ebx,%edx
 587:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 58a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 58d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 590:	89 0d bc 08 00 00    	mov    %ecx,0x8bc
      return (void*)(p + 1);
 596:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 59c:	c9                   	leave  
 59d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 59e:	8b 10                	mov    (%eax),%edx
 5a0:	89 11                	mov    %edx,(%ecx)
 5a2:	eb ec                	jmp    590 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a4:	89 c1                	mov    %eax,%ecx
 5a6:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5a8:	8b 50 04             	mov    0x4(%eax),%edx
 5ab:	39 da                	cmp    %ebx,%edx
 5ad:	73 d4                	jae    583 <malloc+0x46>
    if(p == freep)
 5af:	39 05 bc 08 00 00    	cmp    %eax,0x8bc
 5b5:	75 ed                	jne    5a4 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5b7:	89 d8                	mov    %ebx,%eax
 5b9:	e8 2f ff ff ff       	call   4ed <morecore>
 5be:	85 c0                	test   %eax,%eax
 5c0:	75 e2                	jne    5a4 <malloc+0x67>
 5c2:	eb d5                	jmp    599 <malloc+0x5c>
