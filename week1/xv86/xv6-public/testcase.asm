
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
  11:	68 44 06 00 00       	push   $0x644
  16:	6a 01                	push   $0x1
  18:	e8 7a 03 00 00       	call   397 <printf>
  hello(); // this is a manually made systemcall
  1d:	e8 50 02 00 00       	call   272 <hello>
  helloYou("pri");
  22:	c7 04 24 53 06 00 00 	movl   $0x653,(%esp)
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
SYSCALL(signalProcess)
 292:	b8 1a 00 00 00       	mov    $0x1a,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <numvp>:
SYSCALL(numvp)
 29a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <numpp>:
SYSCALL(numpp)
 2a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <init_counter>:

SYSCALL(init_counter)
 2aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <update_cnt>:
SYSCALL(update_cnt)
 2b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <display_count>:
SYSCALL(display_count)
 2ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <init_counter_1>:
SYSCALL(init_counter_1)
 2c2:	b8 20 00 00 00       	mov    $0x20,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <update_cnt_1>:
SYSCALL(update_cnt_1)
 2ca:	b8 21 00 00 00       	mov    $0x21,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <display_count_1>:
SYSCALL(display_count_1)
 2d2:	b8 22 00 00 00       	mov    $0x22,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <init_counter_2>:
SYSCALL(init_counter_2)
 2da:	b8 23 00 00 00       	mov    $0x23,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <update_cnt_2>:
SYSCALL(update_cnt_2)
 2e2:	b8 24 00 00 00       	mov    $0x24,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <display_count_2>:
 2ea:	b8 25 00 00 00       	mov    $0x25,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 1c             	sub    $0x1c,%esp
 2f8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2fb:	6a 01                	push   $0x1
 2fd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 300:	52                   	push   %edx
 301:	50                   	push   %eax
 302:	e8 eb fe ff ff       	call   1f2 <write>
}
 307:	83 c4 10             	add    $0x10,%esp
 30a:	c9                   	leave  
 30b:	c3                   	ret    

0000030c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	57                   	push   %edi
 310:	56                   	push   %esi
 311:	53                   	push   %ebx
 312:	83 ec 2c             	sub    $0x2c,%esp
 315:	89 45 d0             	mov    %eax,-0x30(%ebp)
 318:	89 d0                	mov    %edx,%eax
 31a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 31c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 320:	0f 95 c1             	setne  %cl
 323:	c1 ea 1f             	shr    $0x1f,%edx
 326:	84 d1                	test   %dl,%cl
 328:	74 44                	je     36e <printint+0x62>
    neg = 1;
    x = -xx;
 32a:	f7 d8                	neg    %eax
 32c:	89 c1                	mov    %eax,%ecx
    neg = 1;
 32e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 335:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 33a:	89 c8                	mov    %ecx,%eax
 33c:	ba 00 00 00 00       	mov    $0x0,%edx
 341:	f7 f6                	div    %esi
 343:	89 df                	mov    %ebx,%edi
 345:	83 c3 01             	add    $0x1,%ebx
 348:	0f b6 92 b8 06 00 00 	movzbl 0x6b8(%edx),%edx
 34f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 353:	89 ca                	mov    %ecx,%edx
 355:	89 c1                	mov    %eax,%ecx
 357:	39 d6                	cmp    %edx,%esi
 359:	76 df                	jbe    33a <printint+0x2e>
  if(neg)
 35b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 35f:	74 31                	je     392 <printint+0x86>
    buf[i++] = '-';
 361:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 366:	8d 5f 02             	lea    0x2(%edi),%ebx
 369:	8b 75 d0             	mov    -0x30(%ebp),%esi
 36c:	eb 17                	jmp    385 <printint+0x79>
    x = xx;
 36e:	89 c1                	mov    %eax,%ecx
  neg = 0;
 370:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 377:	eb bc                	jmp    335 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 379:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 37e:	89 f0                	mov    %esi,%eax
 380:	e8 6d ff ff ff       	call   2f2 <putc>
  while(--i >= 0)
 385:	83 eb 01             	sub    $0x1,%ebx
 388:	79 ef                	jns    379 <printint+0x6d>
}
 38a:	83 c4 2c             	add    $0x2c,%esp
 38d:	5b                   	pop    %ebx
 38e:	5e                   	pop    %esi
 38f:	5f                   	pop    %edi
 390:	5d                   	pop    %ebp
 391:	c3                   	ret    
 392:	8b 75 d0             	mov    -0x30(%ebp),%esi
 395:	eb ee                	jmp    385 <printint+0x79>

00000397 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	57                   	push   %edi
 39b:	56                   	push   %esi
 39c:	53                   	push   %ebx
 39d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3a0:	8d 45 10             	lea    0x10(%ebp),%eax
 3a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3a6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3ab:	bb 00 00 00 00       	mov    $0x0,%ebx
 3b0:	eb 14                	jmp    3c6 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3b2:	89 fa                	mov    %edi,%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	e8 36 ff ff ff       	call   2f2 <putc>
 3bc:	eb 05                	jmp    3c3 <printf+0x2c>
      }
    } else if(state == '%'){
 3be:	83 fe 25             	cmp    $0x25,%esi
 3c1:	74 25                	je     3e8 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3c3:	83 c3 01             	add    $0x1,%ebx
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3cd:	84 c0                	test   %al,%al
 3cf:	0f 84 20 01 00 00    	je     4f5 <printf+0x15e>
    c = fmt[i] & 0xff;
 3d5:	0f be f8             	movsbl %al,%edi
 3d8:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3db:	85 f6                	test   %esi,%esi
 3dd:	75 df                	jne    3be <printf+0x27>
      if(c == '%'){
 3df:	83 f8 25             	cmp    $0x25,%eax
 3e2:	75 ce                	jne    3b2 <printf+0x1b>
        state = '%';
 3e4:	89 c6                	mov    %eax,%esi
 3e6:	eb db                	jmp    3c3 <printf+0x2c>
      if(c == 'd'){
 3e8:	83 f8 25             	cmp    $0x25,%eax
 3eb:	0f 84 cf 00 00 00    	je     4c0 <printf+0x129>
 3f1:	0f 8c dd 00 00 00    	jl     4d4 <printf+0x13d>
 3f7:	83 f8 78             	cmp    $0x78,%eax
 3fa:	0f 8f d4 00 00 00    	jg     4d4 <printf+0x13d>
 400:	83 f8 63             	cmp    $0x63,%eax
 403:	0f 8c cb 00 00 00    	jl     4d4 <printf+0x13d>
 409:	83 e8 63             	sub    $0x63,%eax
 40c:	83 f8 15             	cmp    $0x15,%eax
 40f:	0f 87 bf 00 00 00    	ja     4d4 <printf+0x13d>
 415:	ff 24 85 60 06 00 00 	jmp    *0x660(,%eax,4)
        printint(fd, *ap, 10, 1);
 41c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41f:	8b 17                	mov    (%edi),%edx
 421:	83 ec 0c             	sub    $0xc,%esp
 424:	6a 01                	push   $0x1
 426:	b9 0a 00 00 00       	mov    $0xa,%ecx
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	e8 d9 fe ff ff       	call   30c <printint>
        ap++;
 433:	83 c7 04             	add    $0x4,%edi
 436:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 439:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 43c:	be 00 00 00 00       	mov    $0x0,%esi
 441:	eb 80                	jmp    3c3 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 446:	8b 17                	mov    (%edi),%edx
 448:	83 ec 0c             	sub    $0xc,%esp
 44b:	6a 00                	push   $0x0
 44d:	b9 10 00 00 00       	mov    $0x10,%ecx
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	e8 b2 fe ff ff       	call   30c <printint>
        ap++;
 45a:	83 c7 04             	add    $0x4,%edi
 45d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 460:	83 c4 10             	add    $0x10,%esp
      state = 0;
 463:	be 00 00 00 00       	mov    $0x0,%esi
 468:	e9 56 ff ff ff       	jmp    3c3 <printf+0x2c>
        s = (char*)*ap;
 46d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 470:	8b 30                	mov    (%eax),%esi
        ap++;
 472:	83 c0 04             	add    $0x4,%eax
 475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 478:	85 f6                	test   %esi,%esi
 47a:	75 15                	jne    491 <printf+0xfa>
          s = "(null)";
 47c:	be 57 06 00 00       	mov    $0x657,%esi
 481:	eb 0e                	jmp    491 <printf+0xfa>
          putc(fd, *s);
 483:	0f be d2             	movsbl %dl,%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	e8 64 fe ff ff       	call   2f2 <putc>
          s++;
 48e:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 491:	0f b6 16             	movzbl (%esi),%edx
 494:	84 d2                	test   %dl,%dl
 496:	75 eb                	jne    483 <printf+0xec>
      state = 0;
 498:	be 00 00 00 00       	mov    $0x0,%esi
 49d:	e9 21 ff ff ff       	jmp    3c3 <printf+0x2c>
        putc(fd, *ap);
 4a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a5:	0f be 17             	movsbl (%edi),%edx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	e8 42 fe ff ff       	call   2f2 <putc>
        ap++;
 4b0:	83 c7 04             	add    $0x4,%edi
 4b3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4b6:	be 00 00 00 00       	mov    $0x0,%esi
 4bb:	e9 03 ff ff ff       	jmp    3c3 <printf+0x2c>
        putc(fd, c);
 4c0:	89 fa                	mov    %edi,%edx
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	e8 28 fe ff ff       	call   2f2 <putc>
      state = 0;
 4ca:	be 00 00 00 00       	mov    $0x0,%esi
 4cf:	e9 ef fe ff ff       	jmp    3c3 <printf+0x2c>
        putc(fd, '%');
 4d4:	ba 25 00 00 00       	mov    $0x25,%edx
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	e8 11 fe ff ff       	call   2f2 <putc>
        putc(fd, c);
 4e1:	89 fa                	mov    %edi,%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 07 fe ff ff       	call   2f2 <putc>
      state = 0;
 4eb:	be 00 00 00 00       	mov    $0x0,%esi
 4f0:	e9 ce fe ff ff       	jmp    3c3 <printf+0x2c>
    }
  }
}
 4f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f8:	5b                   	pop    %ebx
 4f9:	5e                   	pop    %esi
 4fa:	5f                   	pop    %edi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    

000004fd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	57                   	push   %edi
 501:	56                   	push   %esi
 502:	53                   	push   %ebx
 503:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 506:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 509:	a1 58 09 00 00       	mov    0x958,%eax
 50e:	eb 02                	jmp    512 <free+0x15>
 510:	89 d0                	mov    %edx,%eax
 512:	39 c8                	cmp    %ecx,%eax
 514:	73 04                	jae    51a <free+0x1d>
 516:	39 08                	cmp    %ecx,(%eax)
 518:	77 12                	ja     52c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 51a:	8b 10                	mov    (%eax),%edx
 51c:	39 c2                	cmp    %eax,%edx
 51e:	77 f0                	ja     510 <free+0x13>
 520:	39 c8                	cmp    %ecx,%eax
 522:	72 08                	jb     52c <free+0x2f>
 524:	39 ca                	cmp    %ecx,%edx
 526:	77 04                	ja     52c <free+0x2f>
 528:	89 d0                	mov    %edx,%eax
 52a:	eb e6                	jmp    512 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 52c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 52f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 532:	8b 10                	mov    (%eax),%edx
 534:	39 d7                	cmp    %edx,%edi
 536:	74 19                	je     551 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 538:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 53b:	8b 50 04             	mov    0x4(%eax),%edx
 53e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 541:	39 ce                	cmp    %ecx,%esi
 543:	74 1b                	je     560 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 545:	89 08                	mov    %ecx,(%eax)
  freep = p;
 547:	a3 58 09 00 00       	mov    %eax,0x958
}
 54c:	5b                   	pop    %ebx
 54d:	5e                   	pop    %esi
 54e:	5f                   	pop    %edi
 54f:	5d                   	pop    %ebp
 550:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 551:	03 72 04             	add    0x4(%edx),%esi
 554:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 557:	8b 10                	mov    (%eax),%edx
 559:	8b 12                	mov    (%edx),%edx
 55b:	89 53 f8             	mov    %edx,-0x8(%ebx)
 55e:	eb db                	jmp    53b <free+0x3e>
    p->s.size += bp->s.size;
 560:	03 53 fc             	add    -0x4(%ebx),%edx
 563:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 566:	8b 53 f8             	mov    -0x8(%ebx),%edx
 569:	89 10                	mov    %edx,(%eax)
 56b:	eb da                	jmp    547 <free+0x4a>

0000056d <morecore>:

static Header*
morecore(uint nu)
{
 56d:	55                   	push   %ebp
 56e:	89 e5                	mov    %esp,%ebp
 570:	53                   	push   %ebx
 571:	83 ec 04             	sub    $0x4,%esp
 574:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 576:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 57b:	77 05                	ja     582 <morecore+0x15>
    nu = 4096;
 57d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 582:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 589:	83 ec 0c             	sub    $0xc,%esp
 58c:	50                   	push   %eax
 58d:	e8 c8 fc ff ff       	call   25a <sbrk>
  if(p == (char*)-1)
 592:	83 c4 10             	add    $0x10,%esp
 595:	83 f8 ff             	cmp    $0xffffffff,%eax
 598:	74 1c                	je     5b6 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 59a:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 59d:	83 c0 08             	add    $0x8,%eax
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	50                   	push   %eax
 5a4:	e8 54 ff ff ff       	call   4fd <free>
  return freep;
 5a9:	a1 58 09 00 00       	mov    0x958,%eax
 5ae:	83 c4 10             	add    $0x10,%esp
}
 5b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    
    return 0;
 5b6:	b8 00 00 00 00       	mov    $0x0,%eax
 5bb:	eb f4                	jmp    5b1 <morecore+0x44>

000005bd <malloc>:

void*
malloc(uint nbytes)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	53                   	push   %ebx
 5c1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	8d 58 07             	lea    0x7(%eax),%ebx
 5ca:	c1 eb 03             	shr    $0x3,%ebx
 5cd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5d0:	8b 0d 58 09 00 00    	mov    0x958,%ecx
 5d6:	85 c9                	test   %ecx,%ecx
 5d8:	74 04                	je     5de <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5da:	8b 01                	mov    (%ecx),%eax
 5dc:	eb 4a                	jmp    628 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5de:	c7 05 58 09 00 00 5c 	movl   $0x95c,0x958
 5e5:	09 00 00 
 5e8:	c7 05 5c 09 00 00 5c 	movl   $0x95c,0x95c
 5ef:	09 00 00 
    base.s.size = 0;
 5f2:	c7 05 60 09 00 00 00 	movl   $0x0,0x960
 5f9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5fc:	b9 5c 09 00 00       	mov    $0x95c,%ecx
 601:	eb d7                	jmp    5da <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 603:	74 19                	je     61e <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 605:	29 da                	sub    %ebx,%edx
 607:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 60a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 60d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 610:	89 0d 58 09 00 00    	mov    %ecx,0x958
      return (void*)(p + 1);
 616:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 61c:	c9                   	leave  
 61d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 61e:	8b 10                	mov    (%eax),%edx
 620:	89 11                	mov    %edx,(%ecx)
 622:	eb ec                	jmp    610 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 624:	89 c1                	mov    %eax,%ecx
 626:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 628:	8b 50 04             	mov    0x4(%eax),%edx
 62b:	39 da                	cmp    %ebx,%edx
 62d:	73 d4                	jae    603 <malloc+0x46>
    if(p == freep)
 62f:	39 05 58 09 00 00    	cmp    %eax,0x958
 635:	75 ed                	jne    624 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 637:	89 d8                	mov    %ebx,%eax
 639:	e8 2f ff ff ff       	call   56d <morecore>
 63e:	85 c0                	test   %eax,%eax
 640:	75 e2                	jne    624 <malloc+0x67>
 642:	eb d5                	jmp    619 <malloc+0x5c>
