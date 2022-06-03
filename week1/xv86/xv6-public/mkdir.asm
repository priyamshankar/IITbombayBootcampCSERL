
_mkdir:     file format elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 41 04             	mov    0x4(%ecx),%eax
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  1c:	83 ff 01             	cmp    $0x1,%edi
  1f:	7e 07                	jle    28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 17                	jmp    3f <main+0x3f>
    printf(2, "Usage: mkdir files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 2c 06 00 00       	push   $0x62c
  30:	6a 02                	push   $0x2
  32:	e8 48 03 00 00       	call   37f <printf>
    exit();
  37:	e8 d6 01 00 00       	call   212 <exit>
  for(i = 1; i < argc; i++){
  3c:	83 c3 01             	add    $0x1,%ebx
  3f:	39 fb                	cmp    %edi,%ebx
  41:	7d 2b                	jge    6e <main+0x6e>
    if(mkdir(argv[i]) < 0){
  43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  46:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	ff 36                	push   (%esi)
  4e:	e8 27 02 00 00       	call   27a <mkdir>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 e2                	jns    3c <main+0x3c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	ff 36                	push   (%esi)
  5f:	68 43 06 00 00       	push   $0x643
  64:	6a 02                	push   $0x2
  66:	e8 14 03 00 00       	call   37f <printf>
      break;
  6b:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  6e:	e8 9f 01 00 00       	call   212 <exit>

00000073 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	56                   	push   %esi
  77:	53                   	push   %ebx
  78:	8b 75 08             	mov    0x8(%ebp),%esi
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	89 f0                	mov    %esi,%eax
  80:	89 d1                	mov    %edx,%ecx
  82:	83 c2 01             	add    $0x1,%edx
  85:	89 c3                	mov    %eax,%ebx
  87:	83 c0 01             	add    $0x1,%eax
  8a:	0f b6 09             	movzbl (%ecx),%ecx
  8d:	88 0b                	mov    %cl,(%ebx)
  8f:	84 c9                	test   %cl,%cl
  91:	75 ed                	jne    80 <strcpy+0xd>
    ;
  return os;
}
  93:	89 f0                	mov    %esi,%eax
  95:	5b                   	pop    %ebx
  96:	5e                   	pop    %esi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  a2:	eb 06                	jmp    aa <strcmp+0x11>
    p++, q++;
  a4:	83 c1 01             	add    $0x1,%ecx
  a7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  aa:	0f b6 01             	movzbl (%ecx),%eax
  ad:	84 c0                	test   %al,%al
  af:	74 04                	je     b5 <strcmp+0x1c>
  b1:	3a 02                	cmp    (%edx),%al
  b3:	74 ef                	je     a4 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  b5:	0f b6 c0             	movzbl %al,%eax
  b8:	0f b6 12             	movzbl (%edx),%edx
  bb:	29 d0                	sub    %edx,%eax
}
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    

000000bf <strlen>:

uint
strlen(const char *s)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c5:	b8 00 00 00 00       	mov    $0x0,%eax
  ca:	eb 03                	jmp    cf <strlen+0x10>
  cc:	83 c0 01             	add    $0x1,%eax
  cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  d3:	75 f7                	jne    cc <strlen+0xd>
    ;
  return n;
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	57                   	push   %edi
  db:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  de:	89 d7                	mov    %edx,%edi
  e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	fc                   	cld    
  e7:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e9:	89 d0                	mov    %edx,%eax
  eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ee:	c9                   	leave  
  ef:	c3                   	ret    

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  fa:	eb 03                	jmp    ff <strchr+0xf>
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	84 d2                	test   %dl,%dl
 104:	74 06                	je     10c <strchr+0x1c>
    if(*s == c)
 106:	38 ca                	cmp    %cl,%dl
 108:	75 f2                	jne    fc <strchr+0xc>
 10a:	eb 05                	jmp    111 <strchr+0x21>
      return (char*)s;
  return 0;
 10c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <gets>:

char*
gets(char *buf, int max)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x49>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 ec 00 00 00       	call   22a <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x49>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x11>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	56                   	push   %esi
 16e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16f:	83 ec 08             	sub    $0x8,%esp
 172:	6a 00                	push   $0x0
 174:	ff 75 08             	push   0x8(%ebp)
 177:	e8 d6 00 00 00       	call   252 <open>
  if(fd < 0)
 17c:	83 c4 10             	add    $0x10,%esp
 17f:	85 c0                	test   %eax,%eax
 181:	78 24                	js     1a7 <stat+0x3d>
 183:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 185:	83 ec 08             	sub    $0x8,%esp
 188:	ff 75 0c             	push   0xc(%ebp)
 18b:	50                   	push   %eax
 18c:	e8 d9 00 00 00       	call   26a <fstat>
 191:	89 c6                	mov    %eax,%esi
  close(fd);
 193:	89 1c 24             	mov    %ebx,(%esp)
 196:	e8 9f 00 00 00       	call   23a <close>
  return r;
 19b:	83 c4 10             	add    $0x10,%esp
}
 19e:	89 f0                	mov    %esi,%eax
 1a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a3:	5b                   	pop    %ebx
 1a4:	5e                   	pop    %esi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
    return -1;
 1a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ac:	eb f0                	jmp    19e <stat+0x34>

000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	53                   	push   %ebx
 1b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b5:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ba:	eb 10                	jmp    1cc <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1bc:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1bf:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c2:	83 c1 01             	add    $0x1,%ecx
 1c5:	0f be c0             	movsbl %al,%eax
 1c8:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1cc:	0f b6 01             	movzbl (%ecx),%eax
 1cf:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d2:	80 fb 09             	cmp    $0x9,%bl
 1d5:	76 e5                	jbe    1bc <atoi+0xe>
  return n;
}
 1d7:	89 d0                	mov    %edx,%eax
 1d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	8b 75 08             	mov    0x8(%ebp),%esi
 1e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1e9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ec:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ee:	eb 0d                	jmp    1fd <memmove+0x1f>
    *dst++ = *src++;
 1f0:	0f b6 01             	movzbl (%ecx),%eax
 1f3:	88 02                	mov    %al,(%edx)
 1f5:	8d 49 01             	lea    0x1(%ecx),%ecx
 1f8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1fb:	89 d8                	mov    %ebx,%eax
 1fd:	8d 58 ff             	lea    -0x1(%eax),%ebx
 200:	85 c0                	test   %eax,%eax
 202:	7f ec                	jg     1f0 <memmove+0x12>
  return vdst;
}
 204:	89 f0                	mov    %esi,%eax
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20a:	b8 01 00 00 00       	mov    $0x1,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <exit>:
SYSCALL(exit)
 212:	b8 02 00 00 00       	mov    $0x2,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <wait>:
SYSCALL(wait)
 21a:	b8 03 00 00 00       	mov    $0x3,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <pipe>:
SYSCALL(pipe)
 222:	b8 04 00 00 00       	mov    $0x4,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <read>:
SYSCALL(read)
 22a:	b8 05 00 00 00       	mov    $0x5,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <write>:
SYSCALL(write)
 232:	b8 10 00 00 00       	mov    $0x10,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <close>:
SYSCALL(close)
 23a:	b8 15 00 00 00       	mov    $0x15,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <kill>:
SYSCALL(kill)
 242:	b8 06 00 00 00       	mov    $0x6,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <exec>:
SYSCALL(exec)
 24a:	b8 07 00 00 00       	mov    $0x7,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <open>:
SYSCALL(open)
 252:	b8 0f 00 00 00       	mov    $0xf,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mknod>:
SYSCALL(mknod)
 25a:	b8 11 00 00 00       	mov    $0x11,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <unlink>:
SYSCALL(unlink)
 262:	b8 12 00 00 00       	mov    $0x12,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <fstat>:
SYSCALL(fstat)
 26a:	b8 08 00 00 00       	mov    $0x8,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <link>:
SYSCALL(link)
 272:	b8 13 00 00 00       	mov    $0x13,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <mkdir>:
SYSCALL(mkdir)
 27a:	b8 14 00 00 00       	mov    $0x14,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <chdir>:
SYSCALL(chdir)
 282:	b8 09 00 00 00       	mov    $0x9,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <dup>:
SYSCALL(dup)
 28a:	b8 0a 00 00 00       	mov    $0xa,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <getpid>:
SYSCALL(getpid)
 292:	b8 0b 00 00 00       	mov    $0xb,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <sbrk>:
SYSCALL(sbrk)
 29a:	b8 0c 00 00 00       	mov    $0xc,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <sleep>:
SYSCALL(sleep)
 2a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <uptime>:
SYSCALL(uptime)
 2aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <hello>:
SYSCALL(hello)
 2b2:	b8 16 00 00 00       	mov    $0x16,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <helloYou>:
SYSCALL(helloYou)
 2ba:	b8 17 00 00 00       	mov    $0x17,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <getppid>:
SYSCALL(getppid)
 2c2:	b8 18 00 00 00       	mov    $0x18,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <get_siblings_info>:
SYSCALL(get_siblings_info)
 2ca:	b8 19 00 00 00       	mov    $0x19,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <signalProcess>:
 2d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 1c             	sub    $0x1c,%esp
 2e0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2e3:	6a 01                	push   $0x1
 2e5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e8:	52                   	push   %edx
 2e9:	50                   	push   %eax
 2ea:	e8 43 ff ff ff       	call   232 <write>
}
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	57                   	push   %edi
 2f8:	56                   	push   %esi
 2f9:	53                   	push   %ebx
 2fa:	83 ec 2c             	sub    $0x2c,%esp
 2fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 300:	89 d0                	mov    %edx,%eax
 302:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 308:	0f 95 c1             	setne  %cl
 30b:	c1 ea 1f             	shr    $0x1f,%edx
 30e:	84 d1                	test   %dl,%cl
 310:	74 44                	je     356 <printint+0x62>
    neg = 1;
    x = -xx;
 312:	f7 d8                	neg    %eax
 314:	89 c1                	mov    %eax,%ecx
    neg = 1;
 316:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 31d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 322:	89 c8                	mov    %ecx,%eax
 324:	ba 00 00 00 00       	mov    $0x0,%edx
 329:	f7 f6                	div    %esi
 32b:	89 df                	mov    %ebx,%edi
 32d:	83 c3 01             	add    $0x1,%ebx
 330:	0f b6 92 c0 06 00 00 	movzbl 0x6c0(%edx),%edx
 337:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 33b:	89 ca                	mov    %ecx,%edx
 33d:	89 c1                	mov    %eax,%ecx
 33f:	39 d6                	cmp    %edx,%esi
 341:	76 df                	jbe    322 <printint+0x2e>
  if(neg)
 343:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 347:	74 31                	je     37a <printint+0x86>
    buf[i++] = '-';
 349:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 34e:	8d 5f 02             	lea    0x2(%edi),%ebx
 351:	8b 75 d0             	mov    -0x30(%ebp),%esi
 354:	eb 17                	jmp    36d <printint+0x79>
    x = xx;
 356:	89 c1                	mov    %eax,%ecx
  neg = 0;
 358:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 35f:	eb bc                	jmp    31d <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 361:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 366:	89 f0                	mov    %esi,%eax
 368:	e8 6d ff ff ff       	call   2da <putc>
  while(--i >= 0)
 36d:	83 eb 01             	sub    $0x1,%ebx
 370:	79 ef                	jns    361 <printint+0x6d>
}
 372:	83 c4 2c             	add    $0x2c,%esp
 375:	5b                   	pop    %ebx
 376:	5e                   	pop    %esi
 377:	5f                   	pop    %edi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    
 37a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 37d:	eb ee                	jmp    36d <printint+0x79>

0000037f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	57                   	push   %edi
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 388:	8d 45 10             	lea    0x10(%ebp),%eax
 38b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 38e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 393:	bb 00 00 00 00       	mov    $0x0,%ebx
 398:	eb 14                	jmp    3ae <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 39a:	89 fa                	mov    %edi,%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	e8 36 ff ff ff       	call   2da <putc>
 3a4:	eb 05                	jmp    3ab <printf+0x2c>
      }
    } else if(state == '%'){
 3a6:	83 fe 25             	cmp    $0x25,%esi
 3a9:	74 25                	je     3d0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3ab:	83 c3 01             	add    $0x1,%ebx
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	0f 84 20 01 00 00    	je     4dd <printf+0x15e>
    c = fmt[i] & 0xff;
 3bd:	0f be f8             	movsbl %al,%edi
 3c0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3c3:	85 f6                	test   %esi,%esi
 3c5:	75 df                	jne    3a6 <printf+0x27>
      if(c == '%'){
 3c7:	83 f8 25             	cmp    $0x25,%eax
 3ca:	75 ce                	jne    39a <printf+0x1b>
        state = '%';
 3cc:	89 c6                	mov    %eax,%esi
 3ce:	eb db                	jmp    3ab <printf+0x2c>
      if(c == 'd'){
 3d0:	83 f8 25             	cmp    $0x25,%eax
 3d3:	0f 84 cf 00 00 00    	je     4a8 <printf+0x129>
 3d9:	0f 8c dd 00 00 00    	jl     4bc <printf+0x13d>
 3df:	83 f8 78             	cmp    $0x78,%eax
 3e2:	0f 8f d4 00 00 00    	jg     4bc <printf+0x13d>
 3e8:	83 f8 63             	cmp    $0x63,%eax
 3eb:	0f 8c cb 00 00 00    	jl     4bc <printf+0x13d>
 3f1:	83 e8 63             	sub    $0x63,%eax
 3f4:	83 f8 15             	cmp    $0x15,%eax
 3f7:	0f 87 bf 00 00 00    	ja     4bc <printf+0x13d>
 3fd:	ff 24 85 68 06 00 00 	jmp    *0x668(,%eax,4)
        printint(fd, *ap, 10, 1);
 404:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 407:	8b 17                	mov    (%edi),%edx
 409:	83 ec 0c             	sub    $0xc,%esp
 40c:	6a 01                	push   $0x1
 40e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	e8 d9 fe ff ff       	call   2f4 <printint>
        ap++;
 41b:	83 c7 04             	add    $0x4,%edi
 41e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 421:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 424:	be 00 00 00 00       	mov    $0x0,%esi
 429:	eb 80                	jmp    3ab <printf+0x2c>
        printint(fd, *ap, 16, 0);
 42b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42e:	8b 17                	mov    (%edi),%edx
 430:	83 ec 0c             	sub    $0xc,%esp
 433:	6a 00                	push   $0x0
 435:	b9 10 00 00 00       	mov    $0x10,%ecx
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	e8 b2 fe ff ff       	call   2f4 <printint>
        ap++;
 442:	83 c7 04             	add    $0x4,%edi
 445:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 448:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44b:	be 00 00 00 00       	mov    $0x0,%esi
 450:	e9 56 ff ff ff       	jmp    3ab <printf+0x2c>
        s = (char*)*ap;
 455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 458:	8b 30                	mov    (%eax),%esi
        ap++;
 45a:	83 c0 04             	add    $0x4,%eax
 45d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 460:	85 f6                	test   %esi,%esi
 462:	75 15                	jne    479 <printf+0xfa>
          s = "(null)";
 464:	be 5f 06 00 00       	mov    $0x65f,%esi
 469:	eb 0e                	jmp    479 <printf+0xfa>
          putc(fd, *s);
 46b:	0f be d2             	movsbl %dl,%edx
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	e8 64 fe ff ff       	call   2da <putc>
          s++;
 476:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 479:	0f b6 16             	movzbl (%esi),%edx
 47c:	84 d2                	test   %dl,%dl
 47e:	75 eb                	jne    46b <printf+0xec>
      state = 0;
 480:	be 00 00 00 00       	mov    $0x0,%esi
 485:	e9 21 ff ff ff       	jmp    3ab <printf+0x2c>
        putc(fd, *ap);
 48a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48d:	0f be 17             	movsbl (%edi),%edx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	e8 42 fe ff ff       	call   2da <putc>
        ap++;
 498:	83 c7 04             	add    $0x4,%edi
 49b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 49e:	be 00 00 00 00       	mov    $0x0,%esi
 4a3:	e9 03 ff ff ff       	jmp    3ab <printf+0x2c>
        putc(fd, c);
 4a8:	89 fa                	mov    %edi,%edx
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	e8 28 fe ff ff       	call   2da <putc>
      state = 0;
 4b2:	be 00 00 00 00       	mov    $0x0,%esi
 4b7:	e9 ef fe ff ff       	jmp    3ab <printf+0x2c>
        putc(fd, '%');
 4bc:	ba 25 00 00 00       	mov    $0x25,%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	e8 11 fe ff ff       	call   2da <putc>
        putc(fd, c);
 4c9:	89 fa                	mov    %edi,%edx
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	e8 07 fe ff ff       	call   2da <putc>
      state = 0;
 4d3:	be 00 00 00 00       	mov    $0x0,%esi
 4d8:	e9 ce fe ff ff       	jmp    3ab <printf+0x2c>
    }
  }
}
 4dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e0:	5b                   	pop    %ebx
 4e1:	5e                   	pop    %esi
 4e2:	5f                   	pop    %edi
 4e3:	5d                   	pop    %ebp
 4e4:	c3                   	ret    

000004e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	57                   	push   %edi
 4e9:	56                   	push   %esi
 4ea:	53                   	push   %ebx
 4eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f1:	a1 6c 09 00 00       	mov    0x96c,%eax
 4f6:	eb 02                	jmp    4fa <free+0x15>
 4f8:	89 d0                	mov    %edx,%eax
 4fa:	39 c8                	cmp    %ecx,%eax
 4fc:	73 04                	jae    502 <free+0x1d>
 4fe:	39 08                	cmp    %ecx,(%eax)
 500:	77 12                	ja     514 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 502:	8b 10                	mov    (%eax),%edx
 504:	39 c2                	cmp    %eax,%edx
 506:	77 f0                	ja     4f8 <free+0x13>
 508:	39 c8                	cmp    %ecx,%eax
 50a:	72 08                	jb     514 <free+0x2f>
 50c:	39 ca                	cmp    %ecx,%edx
 50e:	77 04                	ja     514 <free+0x2f>
 510:	89 d0                	mov    %edx,%eax
 512:	eb e6                	jmp    4fa <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 514:	8b 73 fc             	mov    -0x4(%ebx),%esi
 517:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51a:	8b 10                	mov    (%eax),%edx
 51c:	39 d7                	cmp    %edx,%edi
 51e:	74 19                	je     539 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 520:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 523:	8b 50 04             	mov    0x4(%eax),%edx
 526:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 529:	39 ce                	cmp    %ecx,%esi
 52b:	74 1b                	je     548 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 52d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 52f:	a3 6c 09 00 00       	mov    %eax,0x96c
}
 534:	5b                   	pop    %ebx
 535:	5e                   	pop    %esi
 536:	5f                   	pop    %edi
 537:	5d                   	pop    %ebp
 538:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 539:	03 72 04             	add    0x4(%edx),%esi
 53c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 53f:	8b 10                	mov    (%eax),%edx
 541:	8b 12                	mov    (%edx),%edx
 543:	89 53 f8             	mov    %edx,-0x8(%ebx)
 546:	eb db                	jmp    523 <free+0x3e>
    p->s.size += bp->s.size;
 548:	03 53 fc             	add    -0x4(%ebx),%edx
 54b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 54e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 551:	89 10                	mov    %edx,(%eax)
 553:	eb da                	jmp    52f <free+0x4a>

00000555 <morecore>:

static Header*
morecore(uint nu)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	53                   	push   %ebx
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 55e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 563:	77 05                	ja     56a <morecore+0x15>
    nu = 4096;
 565:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 56a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 571:	83 ec 0c             	sub    $0xc,%esp
 574:	50                   	push   %eax
 575:	e8 20 fd ff ff       	call   29a <sbrk>
  if(p == (char*)-1)
 57a:	83 c4 10             	add    $0x10,%esp
 57d:	83 f8 ff             	cmp    $0xffffffff,%eax
 580:	74 1c                	je     59e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 582:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 585:	83 c0 08             	add    $0x8,%eax
 588:	83 ec 0c             	sub    $0xc,%esp
 58b:	50                   	push   %eax
 58c:	e8 54 ff ff ff       	call   4e5 <free>
  return freep;
 591:	a1 6c 09 00 00       	mov    0x96c,%eax
 596:	83 c4 10             	add    $0x10,%esp
}
 599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 59c:	c9                   	leave  
 59d:	c3                   	ret    
    return 0;
 59e:	b8 00 00 00 00       	mov    $0x0,%eax
 5a3:	eb f4                	jmp    599 <morecore+0x44>

000005a5 <malloc>:

void*
malloc(uint nbytes)
{
 5a5:	55                   	push   %ebp
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	53                   	push   %ebx
 5a9:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	8d 58 07             	lea    0x7(%eax),%ebx
 5b2:	c1 eb 03             	shr    $0x3,%ebx
 5b5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b8:	8b 0d 6c 09 00 00    	mov    0x96c,%ecx
 5be:	85 c9                	test   %ecx,%ecx
 5c0:	74 04                	je     5c6 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c2:	8b 01                	mov    (%ecx),%eax
 5c4:	eb 4a                	jmp    610 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5c6:	c7 05 6c 09 00 00 70 	movl   $0x970,0x96c
 5cd:	09 00 00 
 5d0:	c7 05 70 09 00 00 70 	movl   $0x970,0x970
 5d7:	09 00 00 
    base.s.size = 0;
 5da:	c7 05 74 09 00 00 00 	movl   $0x0,0x974
 5e1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5e4:	b9 70 09 00 00       	mov    $0x970,%ecx
 5e9:	eb d7                	jmp    5c2 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5eb:	74 19                	je     606 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ed:	29 da                	sub    %ebx,%edx
 5ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5f2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5f5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f8:	89 0d 6c 09 00 00    	mov    %ecx,0x96c
      return (void*)(p + 1);
 5fe:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 604:	c9                   	leave  
 605:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 606:	8b 10                	mov    (%eax),%edx
 608:	89 11                	mov    %edx,(%ecx)
 60a:	eb ec                	jmp    5f8 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60c:	89 c1                	mov    %eax,%ecx
 60e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 610:	8b 50 04             	mov    0x4(%eax),%edx
 613:	39 da                	cmp    %ebx,%edx
 615:	73 d4                	jae    5eb <malloc+0x46>
    if(p == freep)
 617:	39 05 6c 09 00 00    	cmp    %eax,0x96c
 61d:	75 ed                	jne    60c <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 61f:	89 d8                	mov    %ebx,%eax
 621:	e8 2f ff ff ff       	call   555 <morecore>
 626:	85 c0                	test   %eax,%eax
 628:	75 e2                	jne    60c <malloc+0x67>
 62a:	eb d5                	jmp    601 <malloc+0x5c>
