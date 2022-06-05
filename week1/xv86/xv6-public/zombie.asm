
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 af 01 00 00       	call   1c5 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 ae 01 00 00       	call   1cd <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 34 02 00 00       	call   25d <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	56                   	push   %esi
  32:	53                   	push   %ebx
  33:	8b 75 08             	mov    0x8(%ebp),%esi
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  39:	89 f0                	mov    %esi,%eax
  3b:	89 d1                	mov    %edx,%ecx
  3d:	83 c2 01             	add    $0x1,%edx
  40:	89 c3                	mov    %eax,%ebx
  42:	83 c0 01             	add    $0x1,%eax
  45:	0f b6 09             	movzbl (%ecx),%ecx
  48:	88 0b                	mov    %cl,(%ebx)
  4a:	84 c9                	test   %cl,%cl
  4c:	75 ed                	jne    3b <strcpy+0xd>
    ;
  return os;
}
  4e:	89 f0                	mov    %esi,%eax
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    

00000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  5d:	eb 06                	jmp    65 <strcmp+0x11>
    p++, q++;
  5f:	83 c1 01             	add    $0x1,%ecx
  62:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  65:	0f b6 01             	movzbl (%ecx),%eax
  68:	84 c0                	test   %al,%al
  6a:	74 04                	je     70 <strcmp+0x1c>
  6c:	3a 02                	cmp    (%edx),%al
  6e:	74 ef                	je     5f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  70:	0f b6 c0             	movzbl %al,%eax
  73:	0f b6 12             	movzbl (%edx),%edx
  76:	29 d0                	sub    %edx,%eax
}
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <strlen>:

uint
strlen(const char *s)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  80:	b8 00 00 00 00       	mov    $0x0,%eax
  85:	eb 03                	jmp    8a <strlen+0x10>
  87:	83 c0 01             	add    $0x1,%eax
  8a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8e:	75 f7                	jne    87 <strlen+0xd>
    ;
  return n;
}
  90:	5d                   	pop    %ebp
  91:	c3                   	ret    

00000092 <memset>:

void*
memset(void *dst, int c, uint n)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  99:	89 d7                	mov    %edx,%edi
  9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	fc                   	cld    
  a2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a4:	89 d0                	mov    %edx,%eax
  a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  a9:	c9                   	leave  
  aa:	c3                   	ret    

000000ab <strchr>:

char*
strchr(const char *s, char c)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  b5:	eb 03                	jmp    ba <strchr+0xf>
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	0f b6 10             	movzbl (%eax),%edx
  bd:	84 d2                	test   %dl,%dl
  bf:	74 06                	je     c7 <strchr+0x1c>
    if(*s == c)
  c1:	38 ca                	cmp    %cl,%dl
  c3:	75 f2                	jne    b7 <strchr+0xc>
  c5:	eb 05                	jmp    cc <strchr+0x21>
      return (char*)s;
  return 0;
  c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <gets>:

char*
gets(char *buf, int max)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	57                   	push   %edi
  d2:	56                   	push   %esi
  d3:	53                   	push   %ebx
  d4:	83 ec 1c             	sub    $0x1c,%esp
  d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  da:	bb 00 00 00 00       	mov    $0x0,%ebx
  df:	89 de                	mov    %ebx,%esi
  e1:	83 c3 01             	add    $0x1,%ebx
  e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e7:	7d 2e                	jge    117 <gets+0x49>
    cc = read(0, &c, 1);
  e9:	83 ec 04             	sub    $0x4,%esp
  ec:	6a 01                	push   $0x1
  ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
  f1:	50                   	push   %eax
  f2:	6a 00                	push   $0x0
  f4:	e8 ec 00 00 00       	call   1e5 <read>
    if(cc < 1)
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	85 c0                	test   %eax,%eax
  fe:	7e 17                	jle    117 <gets+0x49>
      break;
    buf[i++] = c;
 100:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 104:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 107:	3c 0a                	cmp    $0xa,%al
 109:	0f 94 c2             	sete   %dl
 10c:	3c 0d                	cmp    $0xd,%al
 10e:	0f 94 c0             	sete   %al
 111:	08 c2                	or     %al,%dl
 113:	74 ca                	je     df <gets+0x11>
    buf[i++] = c;
 115:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 117:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 11b:	89 f8                	mov    %edi,%eax
 11d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 120:	5b                   	pop    %ebx
 121:	5e                   	pop    %esi
 122:	5f                   	pop    %edi
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <stat>:

int
stat(const char *n, struct stat *st)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 12a:	83 ec 08             	sub    $0x8,%esp
 12d:	6a 00                	push   $0x0
 12f:	ff 75 08             	push   0x8(%ebp)
 132:	e8 d6 00 00 00       	call   20d <open>
  if(fd < 0)
 137:	83 c4 10             	add    $0x10,%esp
 13a:	85 c0                	test   %eax,%eax
 13c:	78 24                	js     162 <stat+0x3d>
 13e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	ff 75 0c             	push   0xc(%ebp)
 146:	50                   	push   %eax
 147:	e8 d9 00 00 00       	call   225 <fstat>
 14c:	89 c6                	mov    %eax,%esi
  close(fd);
 14e:	89 1c 24             	mov    %ebx,(%esp)
 151:	e8 9f 00 00 00       	call   1f5 <close>
  return r;
 156:	83 c4 10             	add    $0x10,%esp
}
 159:	89 f0                	mov    %esi,%eax
 15b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    
    return -1;
 162:	be ff ff ff ff       	mov    $0xffffffff,%esi
 167:	eb f0                	jmp    159 <stat+0x34>

00000169 <atoi>:

int
atoi(const char *s)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	53                   	push   %ebx
 16d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 170:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 175:	eb 10                	jmp    187 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 177:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 17a:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 17d:	83 c1 01             	add    $0x1,%ecx
 180:	0f be c0             	movsbl %al,%eax
 183:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 187:	0f b6 01             	movzbl (%ecx),%eax
 18a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 18d:	80 fb 09             	cmp    $0x9,%bl
 190:	76 e5                	jbe    177 <atoi+0xe>
  return n;
}
 192:	89 d0                	mov    %edx,%eax
 194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	8b 75 08             	mov    0x8(%ebp),%esi
 1a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1a7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1a9:	eb 0d                	jmp    1b8 <memmove+0x1f>
    *dst++ = *src++;
 1ab:	0f b6 01             	movzbl (%ecx),%eax
 1ae:	88 02                	mov    %al,(%edx)
 1b0:	8d 49 01             	lea    0x1(%ecx),%ecx
 1b3:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1b6:	89 d8                	mov    %ebx,%eax
 1b8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1bb:	85 c0                	test   %eax,%eax
 1bd:	7f ec                	jg     1ab <memmove+0x12>
  return vdst;
}
 1bf:	89 f0                	mov    %esi,%eax
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    

000001c5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1c5:	b8 01 00 00 00       	mov    $0x1,%eax
 1ca:	cd 40                	int    $0x40
 1cc:	c3                   	ret    

000001cd <exit>:
SYSCALL(exit)
 1cd:	b8 02 00 00 00       	mov    $0x2,%eax
 1d2:	cd 40                	int    $0x40
 1d4:	c3                   	ret    

000001d5 <wait>:
SYSCALL(wait)
 1d5:	b8 03 00 00 00       	mov    $0x3,%eax
 1da:	cd 40                	int    $0x40
 1dc:	c3                   	ret    

000001dd <pipe>:
SYSCALL(pipe)
 1dd:	b8 04 00 00 00       	mov    $0x4,%eax
 1e2:	cd 40                	int    $0x40
 1e4:	c3                   	ret    

000001e5 <read>:
SYSCALL(read)
 1e5:	b8 05 00 00 00       	mov    $0x5,%eax
 1ea:	cd 40                	int    $0x40
 1ec:	c3                   	ret    

000001ed <write>:
SYSCALL(write)
 1ed:	b8 10 00 00 00       	mov    $0x10,%eax
 1f2:	cd 40                	int    $0x40
 1f4:	c3                   	ret    

000001f5 <close>:
SYSCALL(close)
 1f5:	b8 15 00 00 00       	mov    $0x15,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <kill>:
SYSCALL(kill)
 1fd:	b8 06 00 00 00       	mov    $0x6,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <exec>:
SYSCALL(exec)
 205:	b8 07 00 00 00       	mov    $0x7,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <open>:
SYSCALL(open)
 20d:	b8 0f 00 00 00       	mov    $0xf,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <mknod>:
SYSCALL(mknod)
 215:	b8 11 00 00 00       	mov    $0x11,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <unlink>:
SYSCALL(unlink)
 21d:	b8 12 00 00 00       	mov    $0x12,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <fstat>:
SYSCALL(fstat)
 225:	b8 08 00 00 00       	mov    $0x8,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <link>:
SYSCALL(link)
 22d:	b8 13 00 00 00       	mov    $0x13,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <mkdir>:
SYSCALL(mkdir)
 235:	b8 14 00 00 00       	mov    $0x14,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <chdir>:
SYSCALL(chdir)
 23d:	b8 09 00 00 00       	mov    $0x9,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <dup>:
SYSCALL(dup)
 245:	b8 0a 00 00 00       	mov    $0xa,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <getpid>:
SYSCALL(getpid)
 24d:	b8 0b 00 00 00       	mov    $0xb,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <sbrk>:
SYSCALL(sbrk)
 255:	b8 0c 00 00 00       	mov    $0xc,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <sleep>:
SYSCALL(sleep)
 25d:	b8 0d 00 00 00       	mov    $0xd,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <uptime>:
SYSCALL(uptime)
 265:	b8 0e 00 00 00       	mov    $0xe,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <hello>:
SYSCALL(hello)
 26d:	b8 16 00 00 00       	mov    $0x16,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <helloYou>:
SYSCALL(helloYou)
 275:	b8 17 00 00 00       	mov    $0x17,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <getppid>:
SYSCALL(getppid)
 27d:	b8 18 00 00 00       	mov    $0x18,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <get_siblings_info>:
SYSCALL(get_siblings_info)
 285:	b8 19 00 00 00       	mov    $0x19,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <signalProcess>:
SYSCALL(signalProcess)
 28d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <numvp>:
SYSCALL(numvp)
 295:	b8 1b 00 00 00       	mov    $0x1b,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <numpp>:
 29d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 1c             	sub    $0x1c,%esp
 2ab:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ae:	6a 01                	push   $0x1
 2b0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b3:	52                   	push   %edx
 2b4:	50                   	push   %eax
 2b5:	e8 33 ff ff ff       	call   1ed <write>
}
 2ba:	83 c4 10             	add    $0x10,%esp
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	57                   	push   %edi
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
 2c5:	83 ec 2c             	sub    $0x2c,%esp
 2c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2cb:	89 d0                	mov    %edx,%eax
 2cd:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d3:	0f 95 c1             	setne  %cl
 2d6:	c1 ea 1f             	shr    $0x1f,%edx
 2d9:	84 d1                	test   %dl,%cl
 2db:	74 44                	je     321 <printint+0x62>
    neg = 1;
    x = -xx;
 2dd:	f7 d8                	neg    %eax
 2df:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2e1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ed:	89 c8                	mov    %ecx,%eax
 2ef:	ba 00 00 00 00       	mov    $0x0,%edx
 2f4:	f7 f6                	div    %esi
 2f6:	89 df                	mov    %ebx,%edi
 2f8:	83 c3 01             	add    $0x1,%ebx
 2fb:	0f b6 92 58 06 00 00 	movzbl 0x658(%edx),%edx
 302:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 306:	89 ca                	mov    %ecx,%edx
 308:	89 c1                	mov    %eax,%ecx
 30a:	39 d6                	cmp    %edx,%esi
 30c:	76 df                	jbe    2ed <printint+0x2e>
  if(neg)
 30e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 312:	74 31                	je     345 <printint+0x86>
    buf[i++] = '-';
 314:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 319:	8d 5f 02             	lea    0x2(%edi),%ebx
 31c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 31f:	eb 17                	jmp    338 <printint+0x79>
    x = xx;
 321:	89 c1                	mov    %eax,%ecx
  neg = 0;
 323:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 32a:	eb bc                	jmp    2e8 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 32c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 331:	89 f0                	mov    %esi,%eax
 333:	e8 6d ff ff ff       	call   2a5 <putc>
  while(--i >= 0)
 338:	83 eb 01             	sub    $0x1,%ebx
 33b:	79 ef                	jns    32c <printint+0x6d>
}
 33d:	83 c4 2c             	add    $0x2c,%esp
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    
 345:	8b 75 d0             	mov    -0x30(%ebp),%esi
 348:	eb ee                	jmp    338 <printint+0x79>

0000034a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	57                   	push   %edi
 34e:	56                   	push   %esi
 34f:	53                   	push   %ebx
 350:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 353:	8d 45 10             	lea    0x10(%ebp),%eax
 356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 359:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 35e:	bb 00 00 00 00       	mov    $0x0,%ebx
 363:	eb 14                	jmp    379 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 365:	89 fa                	mov    %edi,%edx
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	e8 36 ff ff ff       	call   2a5 <putc>
 36f:	eb 05                	jmp    376 <printf+0x2c>
      }
    } else if(state == '%'){
 371:	83 fe 25             	cmp    $0x25,%esi
 374:	74 25                	je     39b <printf+0x51>
  for(i = 0; fmt[i]; i++){
 376:	83 c3 01             	add    $0x1,%ebx
 379:	8b 45 0c             	mov    0xc(%ebp),%eax
 37c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 380:	84 c0                	test   %al,%al
 382:	0f 84 20 01 00 00    	je     4a8 <printf+0x15e>
    c = fmt[i] & 0xff;
 388:	0f be f8             	movsbl %al,%edi
 38b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 38e:	85 f6                	test   %esi,%esi
 390:	75 df                	jne    371 <printf+0x27>
      if(c == '%'){
 392:	83 f8 25             	cmp    $0x25,%eax
 395:	75 ce                	jne    365 <printf+0x1b>
        state = '%';
 397:	89 c6                	mov    %eax,%esi
 399:	eb db                	jmp    376 <printf+0x2c>
      if(c == 'd'){
 39b:	83 f8 25             	cmp    $0x25,%eax
 39e:	0f 84 cf 00 00 00    	je     473 <printf+0x129>
 3a4:	0f 8c dd 00 00 00    	jl     487 <printf+0x13d>
 3aa:	83 f8 78             	cmp    $0x78,%eax
 3ad:	0f 8f d4 00 00 00    	jg     487 <printf+0x13d>
 3b3:	83 f8 63             	cmp    $0x63,%eax
 3b6:	0f 8c cb 00 00 00    	jl     487 <printf+0x13d>
 3bc:	83 e8 63             	sub    $0x63,%eax
 3bf:	83 f8 15             	cmp    $0x15,%eax
 3c2:	0f 87 bf 00 00 00    	ja     487 <printf+0x13d>
 3c8:	ff 24 85 00 06 00 00 	jmp    *0x600(,%eax,4)
        printint(fd, *ap, 10, 1);
 3cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d2:	8b 17                	mov    (%edi),%edx
 3d4:	83 ec 0c             	sub    $0xc,%esp
 3d7:	6a 01                	push   $0x1
 3d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	e8 d9 fe ff ff       	call   2bf <printint>
        ap++;
 3e6:	83 c7 04             	add    $0x4,%edi
 3e9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3ec:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3ef:	be 00 00 00 00       	mov    $0x0,%esi
 3f4:	eb 80                	jmp    376 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f9:	8b 17                	mov    (%edi),%edx
 3fb:	83 ec 0c             	sub    $0xc,%esp
 3fe:	6a 00                	push   $0x0
 400:	b9 10 00 00 00       	mov    $0x10,%ecx
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	e8 b2 fe ff ff       	call   2bf <printint>
        ap++;
 40d:	83 c7 04             	add    $0x4,%edi
 410:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 413:	83 c4 10             	add    $0x10,%esp
      state = 0;
 416:	be 00 00 00 00       	mov    $0x0,%esi
 41b:	e9 56 ff ff ff       	jmp    376 <printf+0x2c>
        s = (char*)*ap;
 420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 423:	8b 30                	mov    (%eax),%esi
        ap++;
 425:	83 c0 04             	add    $0x4,%eax
 428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 42b:	85 f6                	test   %esi,%esi
 42d:	75 15                	jne    444 <printf+0xfa>
          s = "(null)";
 42f:	be f8 05 00 00       	mov    $0x5f8,%esi
 434:	eb 0e                	jmp    444 <printf+0xfa>
          putc(fd, *s);
 436:	0f be d2             	movsbl %dl,%edx
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	e8 64 fe ff ff       	call   2a5 <putc>
          s++;
 441:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 444:	0f b6 16             	movzbl (%esi),%edx
 447:	84 d2                	test   %dl,%dl
 449:	75 eb                	jne    436 <printf+0xec>
      state = 0;
 44b:	be 00 00 00 00       	mov    $0x0,%esi
 450:	e9 21 ff ff ff       	jmp    376 <printf+0x2c>
        putc(fd, *ap);
 455:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 458:	0f be 17             	movsbl (%edi),%edx
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	e8 42 fe ff ff       	call   2a5 <putc>
        ap++;
 463:	83 c7 04             	add    $0x4,%edi
 466:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 469:	be 00 00 00 00       	mov    $0x0,%esi
 46e:	e9 03 ff ff ff       	jmp    376 <printf+0x2c>
        putc(fd, c);
 473:	89 fa                	mov    %edi,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	e8 28 fe ff ff       	call   2a5 <putc>
      state = 0;
 47d:	be 00 00 00 00       	mov    $0x0,%esi
 482:	e9 ef fe ff ff       	jmp    376 <printf+0x2c>
        putc(fd, '%');
 487:	ba 25 00 00 00       	mov    $0x25,%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 11 fe ff ff       	call   2a5 <putc>
        putc(fd, c);
 494:	89 fa                	mov    %edi,%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	e8 07 fe ff ff       	call   2a5 <putc>
      state = 0;
 49e:	be 00 00 00 00       	mov    $0x0,%esi
 4a3:	e9 ce fe ff ff       	jmp    376 <printf+0x2c>
    }
  }
}
 4a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    

000004b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4b9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4bc:	a1 f8 08 00 00       	mov    0x8f8,%eax
 4c1:	eb 02                	jmp    4c5 <free+0x15>
 4c3:	89 d0                	mov    %edx,%eax
 4c5:	39 c8                	cmp    %ecx,%eax
 4c7:	73 04                	jae    4cd <free+0x1d>
 4c9:	39 08                	cmp    %ecx,(%eax)
 4cb:	77 12                	ja     4df <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4cd:	8b 10                	mov    (%eax),%edx
 4cf:	39 c2                	cmp    %eax,%edx
 4d1:	77 f0                	ja     4c3 <free+0x13>
 4d3:	39 c8                	cmp    %ecx,%eax
 4d5:	72 08                	jb     4df <free+0x2f>
 4d7:	39 ca                	cmp    %ecx,%edx
 4d9:	77 04                	ja     4df <free+0x2f>
 4db:	89 d0                	mov    %edx,%eax
 4dd:	eb e6                	jmp    4c5 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4df:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4e2:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4e5:	8b 10                	mov    (%eax),%edx
 4e7:	39 d7                	cmp    %edx,%edi
 4e9:	74 19                	je     504 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4eb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4ee:	8b 50 04             	mov    0x4(%eax),%edx
 4f1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4f4:	39 ce                	cmp    %ecx,%esi
 4f6:	74 1b                	je     513 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4f8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4fa:	a3 f8 08 00 00       	mov    %eax,0x8f8
}
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 504:	03 72 04             	add    0x4(%edx),%esi
 507:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 50a:	8b 10                	mov    (%eax),%edx
 50c:	8b 12                	mov    (%edx),%edx
 50e:	89 53 f8             	mov    %edx,-0x8(%ebx)
 511:	eb db                	jmp    4ee <free+0x3e>
    p->s.size += bp->s.size;
 513:	03 53 fc             	add    -0x4(%ebx),%edx
 516:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 519:	8b 53 f8             	mov    -0x8(%ebx),%edx
 51c:	89 10                	mov    %edx,(%eax)
 51e:	eb da                	jmp    4fa <free+0x4a>

00000520 <morecore>:

static Header*
morecore(uint nu)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	83 ec 04             	sub    $0x4,%esp
 527:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 529:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 52e:	77 05                	ja     535 <morecore+0x15>
    nu = 4096;
 530:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 535:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 53c:	83 ec 0c             	sub    $0xc,%esp
 53f:	50                   	push   %eax
 540:	e8 10 fd ff ff       	call   255 <sbrk>
  if(p == (char*)-1)
 545:	83 c4 10             	add    $0x10,%esp
 548:	83 f8 ff             	cmp    $0xffffffff,%eax
 54b:	74 1c                	je     569 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 54d:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 550:	83 c0 08             	add    $0x8,%eax
 553:	83 ec 0c             	sub    $0xc,%esp
 556:	50                   	push   %eax
 557:	e8 54 ff ff ff       	call   4b0 <free>
  return freep;
 55c:	a1 f8 08 00 00       	mov    0x8f8,%eax
 561:	83 c4 10             	add    $0x10,%esp
}
 564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 567:	c9                   	leave  
 568:	c3                   	ret    
    return 0;
 569:	b8 00 00 00 00       	mov    $0x0,%eax
 56e:	eb f4                	jmp    564 <morecore+0x44>

00000570 <malloc>:

void*
malloc(uint nbytes)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	8d 58 07             	lea    0x7(%eax),%ebx
 57d:	c1 eb 03             	shr    $0x3,%ebx
 580:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 583:	8b 0d f8 08 00 00    	mov    0x8f8,%ecx
 589:	85 c9                	test   %ecx,%ecx
 58b:	74 04                	je     591 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 58d:	8b 01                	mov    (%ecx),%eax
 58f:	eb 4a                	jmp    5db <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 591:	c7 05 f8 08 00 00 fc 	movl   $0x8fc,0x8f8
 598:	08 00 00 
 59b:	c7 05 fc 08 00 00 fc 	movl   $0x8fc,0x8fc
 5a2:	08 00 00 
    base.s.size = 0;
 5a5:	c7 05 00 09 00 00 00 	movl   $0x0,0x900
 5ac:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5af:	b9 fc 08 00 00       	mov    $0x8fc,%ecx
 5b4:	eb d7                	jmp    58d <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5b6:	74 19                	je     5d1 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5b8:	29 da                	sub    %ebx,%edx
 5ba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5bd:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5c0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5c3:	89 0d f8 08 00 00    	mov    %ecx,0x8f8
      return (void*)(p + 1);
 5c9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	89 11                	mov    %edx,(%ecx)
 5d5:	eb ec                	jmp    5c3 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d7:	89 c1                	mov    %eax,%ecx
 5d9:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5db:	8b 50 04             	mov    0x4(%eax),%edx
 5de:	39 da                	cmp    %ebx,%edx
 5e0:	73 d4                	jae    5b6 <malloc+0x46>
    if(p == freep)
 5e2:	39 05 f8 08 00 00    	cmp    %eax,0x8f8
 5e8:	75 ed                	jne    5d7 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5ea:	89 d8                	mov    %ebx,%eax
 5ec:	e8 2f ff ff ff       	call   520 <morecore>
 5f1:	85 c0                	test   %eax,%eax
 5f3:	75 e2                	jne    5d7 <malloc+0x67>
 5f5:	eb d5                	jmp    5cc <malloc+0x5c>
