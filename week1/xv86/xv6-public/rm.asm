
_rm:     file format elf32-i386


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
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 17                	jmp    3f <main+0x3f>
    printf(2, "Usage: rm files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 3c 06 00 00       	push   $0x63c
  30:	6a 02                	push   $0x2
  32:	e8 58 03 00 00       	call   38f <printf>
    exit();
  37:	e8 d6 01 00 00       	call   212 <exit>
  for(i = 1; i < argc; i++){
  3c:	83 c3 01             	add    $0x1,%ebx
  3f:	39 fb                	cmp    %edi,%ebx
  41:	7d 2b                	jge    6e <main+0x6e>
    if(unlink(argv[i]) < 0){
  43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  46:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	ff 36                	push   (%esi)
  4e:	e8 0f 02 00 00       	call   262 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 e2                	jns    3c <main+0x3c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	ff 36                	push   (%esi)
  5f:	68 50 06 00 00       	push   $0x650
  64:	6a 02                	push   $0x2
  66:	e8 24 03 00 00       	call   38f <printf>
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
SYSCALL(signalProcess)
 2d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <numvp>:
SYSCALL(numvp)
 2da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <numpp>:
 2e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 1c             	sub    $0x1c,%esp
 2f0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2f3:	6a 01                	push   $0x1
 2f5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2f8:	52                   	push   %edx
 2f9:	50                   	push   %eax
 2fa:	e8 33 ff ff ff       	call   232 <write>
}
 2ff:	83 c4 10             	add    $0x10,%esp
 302:	c9                   	leave  
 303:	c3                   	ret    

00000304 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	56                   	push   %esi
 309:	53                   	push   %ebx
 30a:	83 ec 2c             	sub    $0x2c,%esp
 30d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 310:	89 d0                	mov    %edx,%eax
 312:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 318:	0f 95 c1             	setne  %cl
 31b:	c1 ea 1f             	shr    $0x1f,%edx
 31e:	84 d1                	test   %dl,%cl
 320:	74 44                	je     366 <printint+0x62>
    neg = 1;
    x = -xx;
 322:	f7 d8                	neg    %eax
 324:	89 c1                	mov    %eax,%ecx
    neg = 1;
 326:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 32d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 332:	89 c8                	mov    %ecx,%eax
 334:	ba 00 00 00 00       	mov    $0x0,%edx
 339:	f7 f6                	div    %esi
 33b:	89 df                	mov    %ebx,%edi
 33d:	83 c3 01             	add    $0x1,%ebx
 340:	0f b6 92 c8 06 00 00 	movzbl 0x6c8(%edx),%edx
 347:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 34b:	89 ca                	mov    %ecx,%edx
 34d:	89 c1                	mov    %eax,%ecx
 34f:	39 d6                	cmp    %edx,%esi
 351:	76 df                	jbe    332 <printint+0x2e>
  if(neg)
 353:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 357:	74 31                	je     38a <printint+0x86>
    buf[i++] = '-';
 359:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 35e:	8d 5f 02             	lea    0x2(%edi),%ebx
 361:	8b 75 d0             	mov    -0x30(%ebp),%esi
 364:	eb 17                	jmp    37d <printint+0x79>
    x = xx;
 366:	89 c1                	mov    %eax,%ecx
  neg = 0;
 368:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 36f:	eb bc                	jmp    32d <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 371:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 376:	89 f0                	mov    %esi,%eax
 378:	e8 6d ff ff ff       	call   2ea <putc>
  while(--i >= 0)
 37d:	83 eb 01             	sub    $0x1,%ebx
 380:	79 ef                	jns    371 <printint+0x6d>
}
 382:	83 c4 2c             	add    $0x2c,%esp
 385:	5b                   	pop    %ebx
 386:	5e                   	pop    %esi
 387:	5f                   	pop    %edi
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 38d:	eb ee                	jmp    37d <printint+0x79>

0000038f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	57                   	push   %edi
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
 395:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 398:	8d 45 10             	lea    0x10(%ebp),%eax
 39b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 39e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3a3:	bb 00 00 00 00       	mov    $0x0,%ebx
 3a8:	eb 14                	jmp    3be <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3aa:	89 fa                	mov    %edi,%edx
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	e8 36 ff ff ff       	call   2ea <putc>
 3b4:	eb 05                	jmp    3bb <printf+0x2c>
      }
    } else if(state == '%'){
 3b6:	83 fe 25             	cmp    $0x25,%esi
 3b9:	74 25                	je     3e0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3bb:	83 c3 01             	add    $0x1,%ebx
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3c5:	84 c0                	test   %al,%al
 3c7:	0f 84 20 01 00 00    	je     4ed <printf+0x15e>
    c = fmt[i] & 0xff;
 3cd:	0f be f8             	movsbl %al,%edi
 3d0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3d3:	85 f6                	test   %esi,%esi
 3d5:	75 df                	jne    3b6 <printf+0x27>
      if(c == '%'){
 3d7:	83 f8 25             	cmp    $0x25,%eax
 3da:	75 ce                	jne    3aa <printf+0x1b>
        state = '%';
 3dc:	89 c6                	mov    %eax,%esi
 3de:	eb db                	jmp    3bb <printf+0x2c>
      if(c == 'd'){
 3e0:	83 f8 25             	cmp    $0x25,%eax
 3e3:	0f 84 cf 00 00 00    	je     4b8 <printf+0x129>
 3e9:	0f 8c dd 00 00 00    	jl     4cc <printf+0x13d>
 3ef:	83 f8 78             	cmp    $0x78,%eax
 3f2:	0f 8f d4 00 00 00    	jg     4cc <printf+0x13d>
 3f8:	83 f8 63             	cmp    $0x63,%eax
 3fb:	0f 8c cb 00 00 00    	jl     4cc <printf+0x13d>
 401:	83 e8 63             	sub    $0x63,%eax
 404:	83 f8 15             	cmp    $0x15,%eax
 407:	0f 87 bf 00 00 00    	ja     4cc <printf+0x13d>
 40d:	ff 24 85 70 06 00 00 	jmp    *0x670(,%eax,4)
        printint(fd, *ap, 10, 1);
 414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 417:	8b 17                	mov    (%edi),%edx
 419:	83 ec 0c             	sub    $0xc,%esp
 41c:	6a 01                	push   $0x1
 41e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	e8 d9 fe ff ff       	call   304 <printint>
        ap++;
 42b:	83 c7 04             	add    $0x4,%edi
 42e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 431:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 434:	be 00 00 00 00       	mov    $0x0,%esi
 439:	eb 80                	jmp    3bb <printf+0x2c>
        printint(fd, *ap, 16, 0);
 43b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43e:	8b 17                	mov    (%edi),%edx
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 00                	push   $0x0
 445:	b9 10 00 00 00       	mov    $0x10,%ecx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 b2 fe ff ff       	call   304 <printint>
        ap++;
 452:	83 c7 04             	add    $0x4,%edi
 455:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 458:	83 c4 10             	add    $0x10,%esp
      state = 0;
 45b:	be 00 00 00 00       	mov    $0x0,%esi
 460:	e9 56 ff ff ff       	jmp    3bb <printf+0x2c>
        s = (char*)*ap;
 465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 468:	8b 30                	mov    (%eax),%esi
        ap++;
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 470:	85 f6                	test   %esi,%esi
 472:	75 15                	jne    489 <printf+0xfa>
          s = "(null)";
 474:	be 69 06 00 00       	mov    $0x669,%esi
 479:	eb 0e                	jmp    489 <printf+0xfa>
          putc(fd, *s);
 47b:	0f be d2             	movsbl %dl,%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 64 fe ff ff       	call   2ea <putc>
          s++;
 486:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 489:	0f b6 16             	movzbl (%esi),%edx
 48c:	84 d2                	test   %dl,%dl
 48e:	75 eb                	jne    47b <printf+0xec>
      state = 0;
 490:	be 00 00 00 00       	mov    $0x0,%esi
 495:	e9 21 ff ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, *ap);
 49a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49d:	0f be 17             	movsbl (%edi),%edx
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	e8 42 fe ff ff       	call   2ea <putc>
        ap++;
 4a8:	83 c7 04             	add    $0x4,%edi
 4ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ae:	be 00 00 00 00       	mov    $0x0,%esi
 4b3:	e9 03 ff ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, c);
 4b8:	89 fa                	mov    %edi,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 28 fe ff ff       	call   2ea <putc>
      state = 0;
 4c2:	be 00 00 00 00       	mov    $0x0,%esi
 4c7:	e9 ef fe ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, '%');
 4cc:	ba 25 00 00 00       	mov    $0x25,%edx
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	e8 11 fe ff ff       	call   2ea <putc>
        putc(fd, c);
 4d9:	89 fa                	mov    %edi,%edx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 07 fe ff ff       	call   2ea <putc>
      state = 0;
 4e3:	be 00 00 00 00       	mov    $0x0,%esi
 4e8:	e9 ce fe ff ff       	jmp    3bb <printf+0x2c>
    }
  }
}
 4ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    

000004f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	57                   	push   %edi
 4f9:	56                   	push   %esi
 4fa:	53                   	push   %ebx
 4fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 501:	a1 74 09 00 00       	mov    0x974,%eax
 506:	eb 02                	jmp    50a <free+0x15>
 508:	89 d0                	mov    %edx,%eax
 50a:	39 c8                	cmp    %ecx,%eax
 50c:	73 04                	jae    512 <free+0x1d>
 50e:	39 08                	cmp    %ecx,(%eax)
 510:	77 12                	ja     524 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 512:	8b 10                	mov    (%eax),%edx
 514:	39 c2                	cmp    %eax,%edx
 516:	77 f0                	ja     508 <free+0x13>
 518:	39 c8                	cmp    %ecx,%eax
 51a:	72 08                	jb     524 <free+0x2f>
 51c:	39 ca                	cmp    %ecx,%edx
 51e:	77 04                	ja     524 <free+0x2f>
 520:	89 d0                	mov    %edx,%eax
 522:	eb e6                	jmp    50a <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 524:	8b 73 fc             	mov    -0x4(%ebx),%esi
 527:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52a:	8b 10                	mov    (%eax),%edx
 52c:	39 d7                	cmp    %edx,%edi
 52e:	74 19                	je     549 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 530:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 533:	8b 50 04             	mov    0x4(%eax),%edx
 536:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 539:	39 ce                	cmp    %ecx,%esi
 53b:	74 1b                	je     558 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 53d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 53f:	a3 74 09 00 00       	mov    %eax,0x974
}
 544:	5b                   	pop    %ebx
 545:	5e                   	pop    %esi
 546:	5f                   	pop    %edi
 547:	5d                   	pop    %ebp
 548:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 549:	03 72 04             	add    0x4(%edx),%esi
 54c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54f:	8b 10                	mov    (%eax),%edx
 551:	8b 12                	mov    (%edx),%edx
 553:	89 53 f8             	mov    %edx,-0x8(%ebx)
 556:	eb db                	jmp    533 <free+0x3e>
    p->s.size += bp->s.size;
 558:	03 53 fc             	add    -0x4(%ebx),%edx
 55b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 561:	89 10                	mov    %edx,(%eax)
 563:	eb da                	jmp    53f <free+0x4a>

00000565 <morecore>:

static Header*
morecore(uint nu)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 04             	sub    $0x4,%esp
 56c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 56e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 573:	77 05                	ja     57a <morecore+0x15>
    nu = 4096;
 575:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 57a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 581:	83 ec 0c             	sub    $0xc,%esp
 584:	50                   	push   %eax
 585:	e8 10 fd ff ff       	call   29a <sbrk>
  if(p == (char*)-1)
 58a:	83 c4 10             	add    $0x10,%esp
 58d:	83 f8 ff             	cmp    $0xffffffff,%eax
 590:	74 1c                	je     5ae <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 592:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 595:	83 c0 08             	add    $0x8,%eax
 598:	83 ec 0c             	sub    $0xc,%esp
 59b:	50                   	push   %eax
 59c:	e8 54 ff ff ff       	call   4f5 <free>
  return freep;
 5a1:	a1 74 09 00 00       	mov    0x974,%eax
 5a6:	83 c4 10             	add    $0x10,%esp
}
 5a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ac:	c9                   	leave  
 5ad:	c3                   	ret    
    return 0;
 5ae:	b8 00 00 00 00       	mov    $0x0,%eax
 5b3:	eb f4                	jmp    5a9 <morecore+0x44>

000005b5 <malloc>:

void*
malloc(uint nbytes)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	53                   	push   %ebx
 5b9:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	8d 58 07             	lea    0x7(%eax),%ebx
 5c2:	c1 eb 03             	shr    $0x3,%ebx
 5c5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c8:	8b 0d 74 09 00 00    	mov    0x974,%ecx
 5ce:	85 c9                	test   %ecx,%ecx
 5d0:	74 04                	je     5d6 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d2:	8b 01                	mov    (%ecx),%eax
 5d4:	eb 4a                	jmp    620 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5d6:	c7 05 74 09 00 00 78 	movl   $0x978,0x974
 5dd:	09 00 00 
 5e0:	c7 05 78 09 00 00 78 	movl   $0x978,0x978
 5e7:	09 00 00 
    base.s.size = 0;
 5ea:	c7 05 7c 09 00 00 00 	movl   $0x0,0x97c
 5f1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f4:	b9 78 09 00 00       	mov    $0x978,%ecx
 5f9:	eb d7                	jmp    5d2 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5fb:	74 19                	je     616 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5fd:	29 da                	sub    %ebx,%edx
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 602:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 605:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 608:	89 0d 74 09 00 00    	mov    %ecx,0x974
      return (void*)(p + 1);
 60e:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 614:	c9                   	leave  
 615:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 616:	8b 10                	mov    (%eax),%edx
 618:	89 11                	mov    %edx,(%ecx)
 61a:	eb ec                	jmp    608 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61c:	89 c1                	mov    %eax,%ecx
 61e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 620:	8b 50 04             	mov    0x4(%eax),%edx
 623:	39 da                	cmp    %ebx,%edx
 625:	73 d4                	jae    5fb <malloc+0x46>
    if(p == freep)
 627:	39 05 74 09 00 00    	cmp    %eax,0x974
 62d:	75 ed                	jne    61c <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 62f:	89 d8                	mov    %ebx,%eax
 631:	e8 2f ff ff ff       	call   565 <morecore>
 636:	85 c0                	test   %eax,%eax
 638:	75 e2                	jne    61c <malloc+0x67>
 63a:	eb d5                	jmp    611 <malloc+0x5c>
