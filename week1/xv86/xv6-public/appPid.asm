
_appPid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 19                	mov    (%ecx),%ebx
    int i;
    if (argc <= 1)
  11:	83 fb 01             	cmp    $0x1,%ebx
  14:	7e 0a                	jle    20 <main+0x20>
    {
        printf(1, "enter any value at runtime\n");
    }

    if (argc < 2)
  16:	83 fb 01             	cmp    $0x1,%ebx
  19:	7e 19                	jle    34 <main+0x34>
        printf(2, "usage: pname pid...\n");
        exit();
    }
    for (i = 1; i < argc; i++)
        // getppid(atoi(argv[i]));
    exit();
  1b:	e8 c7 01 00 00       	call   1e7 <exit>
        printf(1, "enter any value at runtime\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 04 06 00 00       	push   $0x604
  28:	6a 01                	push   $0x1
  2a:	e8 25 03 00 00       	call   354 <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	eb e2                	jmp    16 <main+0x16>
        printf(2, "usage: pname pid...\n");
  34:	83 ec 08             	sub    $0x8,%esp
  37:	68 20 06 00 00       	push   $0x620
  3c:	6a 02                	push   $0x2
  3e:	e8 11 03 00 00       	call   354 <printf>
        exit();
  43:	e8 9f 01 00 00       	call   1e7 <exit>

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	56                   	push   %esi
  4c:	53                   	push   %ebx
  4d:	8b 75 08             	mov    0x8(%ebp),%esi
  50:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  53:	89 f0                	mov    %esi,%eax
  55:	89 d1                	mov    %edx,%ecx
  57:	83 c2 01             	add    $0x1,%edx
  5a:	89 c3                	mov    %eax,%ebx
  5c:	83 c0 01             	add    $0x1,%eax
  5f:	0f b6 09             	movzbl (%ecx),%ecx
  62:	88 0b                	mov    %cl,(%ebx)
  64:	84 c9                	test   %cl,%cl
  66:	75 ed                	jne    55 <strcpy+0xd>
    ;
  return os;
}
  68:	89 f0                	mov    %esi,%eax
  6a:	5b                   	pop    %ebx
  6b:	5e                   	pop    %esi
  6c:	5d                   	pop    %ebp
  6d:	c3                   	ret    

0000006e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6e:	55                   	push   %ebp
  6f:	89 e5                	mov    %esp,%ebp
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  77:	eb 06                	jmp    7f <strcmp+0x11>
    p++, q++;
  79:	83 c1 01             	add    $0x1,%ecx
  7c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  7f:	0f b6 01             	movzbl (%ecx),%eax
  82:	84 c0                	test   %al,%al
  84:	74 04                	je     8a <strcmp+0x1c>
  86:	3a 02                	cmp    (%edx),%al
  88:	74 ef                	je     79 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8a:	0f b6 c0             	movzbl %al,%eax
  8d:	0f b6 12             	movzbl (%edx),%edx
  90:	29 d0                	sub    %edx,%eax
}
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    

00000094 <strlen>:

uint
strlen(const char *s)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  9a:	b8 00 00 00 00       	mov    $0x0,%eax
  9f:	eb 03                	jmp    a4 <strlen+0x10>
  a1:	83 c0 01             	add    $0x1,%eax
  a4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  a8:	75 f7                	jne    a1 <strlen+0xd>
    ;
  return n;
}
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b3:	89 d7                	mov    %edx,%edi
  b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	fc                   	cld    
  bc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  be:	89 d0                	mov    %edx,%eax
  c0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strchr>:

char*
strchr(const char *s, char c)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  cf:	eb 03                	jmp    d4 <strchr+0xf>
  d1:	83 c0 01             	add    $0x1,%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	84 d2                	test   %dl,%dl
  d9:	74 06                	je     e1 <strchr+0x1c>
    if(*s == c)
  db:	38 ca                	cmp    %cl,%dl
  dd:	75 f2                	jne    d1 <strchr+0xc>
  df:	eb 05                	jmp    e6 <strchr+0x21>
      return (char*)s;
  return 0;
  e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
  ec:	56                   	push   %esi
  ed:	53                   	push   %ebx
  ee:	83 ec 1c             	sub    $0x1c,%esp
  f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  f9:	89 de                	mov    %ebx,%esi
  fb:	83 c3 01             	add    $0x1,%ebx
  fe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 101:	7d 2e                	jge    131 <gets+0x49>
    cc = read(0, &c, 1);
 103:	83 ec 04             	sub    $0x4,%esp
 106:	6a 01                	push   $0x1
 108:	8d 45 e7             	lea    -0x19(%ebp),%eax
 10b:	50                   	push   %eax
 10c:	6a 00                	push   $0x0
 10e:	e8 ec 00 00 00       	call   1ff <read>
    if(cc < 1)
 113:	83 c4 10             	add    $0x10,%esp
 116:	85 c0                	test   %eax,%eax
 118:	7e 17                	jle    131 <gets+0x49>
      break;
    buf[i++] = c;
 11a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11e:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 121:	3c 0a                	cmp    $0xa,%al
 123:	0f 94 c2             	sete   %dl
 126:	3c 0d                	cmp    $0xd,%al
 128:	0f 94 c0             	sete   %al
 12b:	08 c2                	or     %al,%dl
 12d:	74 ca                	je     f9 <gets+0x11>
    buf[i++] = c;
 12f:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 131:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 135:	89 f8                	mov    %edi,%eax
 137:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13a:	5b                   	pop    %ebx
 13b:	5e                   	pop    %esi
 13c:	5f                   	pop    %edi
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    

0000013f <stat>:

int
stat(const char *n, struct stat *st)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	56                   	push   %esi
 143:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 144:	83 ec 08             	sub    $0x8,%esp
 147:	6a 00                	push   $0x0
 149:	ff 75 08             	push   0x8(%ebp)
 14c:	e8 d6 00 00 00       	call   227 <open>
  if(fd < 0)
 151:	83 c4 10             	add    $0x10,%esp
 154:	85 c0                	test   %eax,%eax
 156:	78 24                	js     17c <stat+0x3d>
 158:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15a:	83 ec 08             	sub    $0x8,%esp
 15d:	ff 75 0c             	push   0xc(%ebp)
 160:	50                   	push   %eax
 161:	e8 d9 00 00 00       	call   23f <fstat>
 166:	89 c6                	mov    %eax,%esi
  close(fd);
 168:	89 1c 24             	mov    %ebx,(%esp)
 16b:	e8 9f 00 00 00       	call   20f <close>
  return r;
 170:	83 c4 10             	add    $0x10,%esp
}
 173:	89 f0                	mov    %esi,%eax
 175:	8d 65 f8             	lea    -0x8(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret    
    return -1;
 17c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 181:	eb f0                	jmp    173 <stat+0x34>

00000183 <atoi>:

int
atoi(const char *s)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	53                   	push   %ebx
 187:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 18a:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 18f:	eb 10                	jmp    1a1 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 191:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 194:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 197:	83 c1 01             	add    $0x1,%ecx
 19a:	0f be c0             	movsbl %al,%eax
 19d:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a7:	80 fb 09             	cmp    $0x9,%bl
 1aa:	76 e5                	jbe    191 <atoi+0xe>
  return n;
}
 1ac:	89 d0                	mov    %edx,%eax
 1ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	8b 75 08             	mov    0x8(%ebp),%esi
 1bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1be:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c1:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1c3:	eb 0d                	jmp    1d2 <memmove+0x1f>
    *dst++ = *src++;
 1c5:	0f b6 01             	movzbl (%ecx),%eax
 1c8:	88 02                	mov    %al,(%edx)
 1ca:	8d 49 01             	lea    0x1(%ecx),%ecx
 1cd:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d0:	89 d8                	mov    %ebx,%eax
 1d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1d5:	85 c0                	test   %eax,%eax
 1d7:	7f ec                	jg     1c5 <memmove+0x12>
  return vdst;
}
 1d9:	89 f0                	mov    %esi,%eax
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1df:	b8 01 00 00 00       	mov    $0x1,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <exit>:
SYSCALL(exit)
 1e7:	b8 02 00 00 00       	mov    $0x2,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <wait>:
SYSCALL(wait)
 1ef:	b8 03 00 00 00       	mov    $0x3,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <pipe>:
SYSCALL(pipe)
 1f7:	b8 04 00 00 00       	mov    $0x4,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <read>:
SYSCALL(read)
 1ff:	b8 05 00 00 00       	mov    $0x5,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <write>:
SYSCALL(write)
 207:	b8 10 00 00 00       	mov    $0x10,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <close>:
SYSCALL(close)
 20f:	b8 15 00 00 00       	mov    $0x15,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <kill>:
SYSCALL(kill)
 217:	b8 06 00 00 00       	mov    $0x6,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <exec>:
SYSCALL(exec)
 21f:	b8 07 00 00 00       	mov    $0x7,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <open>:
SYSCALL(open)
 227:	b8 0f 00 00 00       	mov    $0xf,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <mknod>:
SYSCALL(mknod)
 22f:	b8 11 00 00 00       	mov    $0x11,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <unlink>:
SYSCALL(unlink)
 237:	b8 12 00 00 00       	mov    $0x12,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <fstat>:
SYSCALL(fstat)
 23f:	b8 08 00 00 00       	mov    $0x8,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <link>:
SYSCALL(link)
 247:	b8 13 00 00 00       	mov    $0x13,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <mkdir>:
SYSCALL(mkdir)
 24f:	b8 14 00 00 00       	mov    $0x14,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <chdir>:
SYSCALL(chdir)
 257:	b8 09 00 00 00       	mov    $0x9,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <dup>:
SYSCALL(dup)
 25f:	b8 0a 00 00 00       	mov    $0xa,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <getpid>:
SYSCALL(getpid)
 267:	b8 0b 00 00 00       	mov    $0xb,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <sbrk>:
SYSCALL(sbrk)
 26f:	b8 0c 00 00 00       	mov    $0xc,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <sleep>:
SYSCALL(sleep)
 277:	b8 0d 00 00 00       	mov    $0xd,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <uptime>:
SYSCALL(uptime)
 27f:	b8 0e 00 00 00       	mov    $0xe,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <hello>:
SYSCALL(hello)
 287:	b8 16 00 00 00       	mov    $0x16,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <helloYou>:
SYSCALL(helloYou)
 28f:	b8 17 00 00 00       	mov    $0x17,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <getppid>:
SYSCALL(getppid)
 297:	b8 18 00 00 00       	mov    $0x18,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <get_siblings_info>:
SYSCALL(get_siblings_info)
 29f:	b8 19 00 00 00       	mov    $0x19,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <signalProcess>:
 2a7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 1c             	sub    $0x1c,%esp
 2b5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2b8:	6a 01                	push   $0x1
 2ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2bd:	52                   	push   %edx
 2be:	50                   	push   %eax
 2bf:	e8 43 ff ff ff       	call   207 <write>
}
 2c4:	83 c4 10             	add    $0x10,%esp
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	57                   	push   %edi
 2cd:	56                   	push   %esi
 2ce:	53                   	push   %ebx
 2cf:	83 ec 2c             	sub    $0x2c,%esp
 2d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2d5:	89 d0                	mov    %edx,%eax
 2d7:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2dd:	0f 95 c1             	setne  %cl
 2e0:	c1 ea 1f             	shr    $0x1f,%edx
 2e3:	84 d1                	test   %dl,%cl
 2e5:	74 44                	je     32b <printint+0x62>
    neg = 1;
    x = -xx;
 2e7:	f7 d8                	neg    %eax
 2e9:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2eb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f7:	89 c8                	mov    %ecx,%eax
 2f9:	ba 00 00 00 00       	mov    $0x0,%edx
 2fe:	f7 f6                	div    %esi
 300:	89 df                	mov    %ebx,%edi
 302:	83 c3 01             	add    $0x1,%ebx
 305:	0f b6 92 94 06 00 00 	movzbl 0x694(%edx),%edx
 30c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 310:	89 ca                	mov    %ecx,%edx
 312:	89 c1                	mov    %eax,%ecx
 314:	39 d6                	cmp    %edx,%esi
 316:	76 df                	jbe    2f7 <printint+0x2e>
  if(neg)
 318:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 31c:	74 31                	je     34f <printint+0x86>
    buf[i++] = '-';
 31e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 323:	8d 5f 02             	lea    0x2(%edi),%ebx
 326:	8b 75 d0             	mov    -0x30(%ebp),%esi
 329:	eb 17                	jmp    342 <printint+0x79>
    x = xx;
 32b:	89 c1                	mov    %eax,%ecx
  neg = 0;
 32d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 334:	eb bc                	jmp    2f2 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 336:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 33b:	89 f0                	mov    %esi,%eax
 33d:	e8 6d ff ff ff       	call   2af <putc>
  while(--i >= 0)
 342:	83 eb 01             	sub    $0x1,%ebx
 345:	79 ef                	jns    336 <printint+0x6d>
}
 347:	83 c4 2c             	add    $0x2c,%esp
 34a:	5b                   	pop    %ebx
 34b:	5e                   	pop    %esi
 34c:	5f                   	pop    %edi
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    
 34f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 352:	eb ee                	jmp    342 <printint+0x79>

00000354 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 35d:	8d 45 10             	lea    0x10(%ebp),%eax
 360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 363:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 368:	bb 00 00 00 00       	mov    $0x0,%ebx
 36d:	eb 14                	jmp    383 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 36f:	89 fa                	mov    %edi,%edx
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	e8 36 ff ff ff       	call   2af <putc>
 379:	eb 05                	jmp    380 <printf+0x2c>
      }
    } else if(state == '%'){
 37b:	83 fe 25             	cmp    $0x25,%esi
 37e:	74 25                	je     3a5 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 380:	83 c3 01             	add    $0x1,%ebx
 383:	8b 45 0c             	mov    0xc(%ebp),%eax
 386:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 38a:	84 c0                	test   %al,%al
 38c:	0f 84 20 01 00 00    	je     4b2 <printf+0x15e>
    c = fmt[i] & 0xff;
 392:	0f be f8             	movsbl %al,%edi
 395:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 398:	85 f6                	test   %esi,%esi
 39a:	75 df                	jne    37b <printf+0x27>
      if(c == '%'){
 39c:	83 f8 25             	cmp    $0x25,%eax
 39f:	75 ce                	jne    36f <printf+0x1b>
        state = '%';
 3a1:	89 c6                	mov    %eax,%esi
 3a3:	eb db                	jmp    380 <printf+0x2c>
      if(c == 'd'){
 3a5:	83 f8 25             	cmp    $0x25,%eax
 3a8:	0f 84 cf 00 00 00    	je     47d <printf+0x129>
 3ae:	0f 8c dd 00 00 00    	jl     491 <printf+0x13d>
 3b4:	83 f8 78             	cmp    $0x78,%eax
 3b7:	0f 8f d4 00 00 00    	jg     491 <printf+0x13d>
 3bd:	83 f8 63             	cmp    $0x63,%eax
 3c0:	0f 8c cb 00 00 00    	jl     491 <printf+0x13d>
 3c6:	83 e8 63             	sub    $0x63,%eax
 3c9:	83 f8 15             	cmp    $0x15,%eax
 3cc:	0f 87 bf 00 00 00    	ja     491 <printf+0x13d>
 3d2:	ff 24 85 3c 06 00 00 	jmp    *0x63c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3dc:	8b 17                	mov    (%edi),%edx
 3de:	83 ec 0c             	sub    $0xc,%esp
 3e1:	6a 01                	push   $0x1
 3e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	e8 d9 fe ff ff       	call   2c9 <printint>
        ap++;
 3f0:	83 c7 04             	add    $0x4,%edi
 3f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3f9:	be 00 00 00 00       	mov    $0x0,%esi
 3fe:	eb 80                	jmp    380 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 403:	8b 17                	mov    (%edi),%edx
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 00                	push   $0x0
 40a:	b9 10 00 00 00       	mov    $0x10,%ecx
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	e8 b2 fe ff ff       	call   2c9 <printint>
        ap++;
 417:	83 c7 04             	add    $0x4,%edi
 41a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 420:	be 00 00 00 00       	mov    $0x0,%esi
 425:	e9 56 ff ff ff       	jmp    380 <printf+0x2c>
        s = (char*)*ap;
 42a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 42d:	8b 30                	mov    (%eax),%esi
        ap++;
 42f:	83 c0 04             	add    $0x4,%eax
 432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 435:	85 f6                	test   %esi,%esi
 437:	75 15                	jne    44e <printf+0xfa>
          s = "(null)";
 439:	be 35 06 00 00       	mov    $0x635,%esi
 43e:	eb 0e                	jmp    44e <printf+0xfa>
          putc(fd, *s);
 440:	0f be d2             	movsbl %dl,%edx
 443:	8b 45 08             	mov    0x8(%ebp),%eax
 446:	e8 64 fe ff ff       	call   2af <putc>
          s++;
 44b:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 44e:	0f b6 16             	movzbl (%esi),%edx
 451:	84 d2                	test   %dl,%dl
 453:	75 eb                	jne    440 <printf+0xec>
      state = 0;
 455:	be 00 00 00 00       	mov    $0x0,%esi
 45a:	e9 21 ff ff ff       	jmp    380 <printf+0x2c>
        putc(fd, *ap);
 45f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 462:	0f be 17             	movsbl (%edi),%edx
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	e8 42 fe ff ff       	call   2af <putc>
        ap++;
 46d:	83 c7 04             	add    $0x4,%edi
 470:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 473:	be 00 00 00 00       	mov    $0x0,%esi
 478:	e9 03 ff ff ff       	jmp    380 <printf+0x2c>
        putc(fd, c);
 47d:	89 fa                	mov    %edi,%edx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	e8 28 fe ff ff       	call   2af <putc>
      state = 0;
 487:	be 00 00 00 00       	mov    $0x0,%esi
 48c:	e9 ef fe ff ff       	jmp    380 <printf+0x2c>
        putc(fd, '%');
 491:	ba 25 00 00 00       	mov    $0x25,%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	e8 11 fe ff ff       	call   2af <putc>
        putc(fd, c);
 49e:	89 fa                	mov    %edi,%edx
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	e8 07 fe ff ff       	call   2af <putc>
      state = 0;
 4a8:	be 00 00 00 00       	mov    $0x0,%esi
 4ad:	e9 ce fe ff ff       	jmp    380 <printf+0x2c>
    }
  }
}
 4b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b5:	5b                   	pop    %ebx
 4b6:	5e                   	pop    %esi
 4b7:	5f                   	pop    %edi
 4b8:	5d                   	pop    %ebp
 4b9:	c3                   	ret    

000004ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	57                   	push   %edi
 4be:	56                   	push   %esi
 4bf:	53                   	push   %ebx
 4c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c3:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c6:	a1 38 09 00 00       	mov    0x938,%eax
 4cb:	eb 02                	jmp    4cf <free+0x15>
 4cd:	89 d0                	mov    %edx,%eax
 4cf:	39 c8                	cmp    %ecx,%eax
 4d1:	73 04                	jae    4d7 <free+0x1d>
 4d3:	39 08                	cmp    %ecx,(%eax)
 4d5:	77 12                	ja     4e9 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4d7:	8b 10                	mov    (%eax),%edx
 4d9:	39 c2                	cmp    %eax,%edx
 4db:	77 f0                	ja     4cd <free+0x13>
 4dd:	39 c8                	cmp    %ecx,%eax
 4df:	72 08                	jb     4e9 <free+0x2f>
 4e1:	39 ca                	cmp    %ecx,%edx
 4e3:	77 04                	ja     4e9 <free+0x2f>
 4e5:	89 d0                	mov    %edx,%eax
 4e7:	eb e6                	jmp    4cf <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e9:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ec:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ef:	8b 10                	mov    (%eax),%edx
 4f1:	39 d7                	cmp    %edx,%edi
 4f3:	74 19                	je     50e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4f5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4f8:	8b 50 04             	mov    0x4(%eax),%edx
 4fb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4fe:	39 ce                	cmp    %ecx,%esi
 500:	74 1b                	je     51d <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 502:	89 08                	mov    %ecx,(%eax)
  freep = p;
 504:	a3 38 09 00 00       	mov    %eax,0x938
}
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5f                   	pop    %edi
 50c:	5d                   	pop    %ebp
 50d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 50e:	03 72 04             	add    0x4(%edx),%esi
 511:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 514:	8b 10                	mov    (%eax),%edx
 516:	8b 12                	mov    (%edx),%edx
 518:	89 53 f8             	mov    %edx,-0x8(%ebx)
 51b:	eb db                	jmp    4f8 <free+0x3e>
    p->s.size += bp->s.size;
 51d:	03 53 fc             	add    -0x4(%ebx),%edx
 520:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 523:	8b 53 f8             	mov    -0x8(%ebx),%edx
 526:	89 10                	mov    %edx,(%eax)
 528:	eb da                	jmp    504 <free+0x4a>

0000052a <morecore>:

static Header*
morecore(uint nu)
{
 52a:	55                   	push   %ebp
 52b:	89 e5                	mov    %esp,%ebp
 52d:	53                   	push   %ebx
 52e:	83 ec 04             	sub    $0x4,%esp
 531:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 533:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 538:	77 05                	ja     53f <morecore+0x15>
    nu = 4096;
 53a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 53f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 546:	83 ec 0c             	sub    $0xc,%esp
 549:	50                   	push   %eax
 54a:	e8 20 fd ff ff       	call   26f <sbrk>
  if(p == (char*)-1)
 54f:	83 c4 10             	add    $0x10,%esp
 552:	83 f8 ff             	cmp    $0xffffffff,%eax
 555:	74 1c                	je     573 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 557:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 55a:	83 c0 08             	add    $0x8,%eax
 55d:	83 ec 0c             	sub    $0xc,%esp
 560:	50                   	push   %eax
 561:	e8 54 ff ff ff       	call   4ba <free>
  return freep;
 566:	a1 38 09 00 00       	mov    0x938,%eax
 56b:	83 c4 10             	add    $0x10,%esp
}
 56e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 571:	c9                   	leave  
 572:	c3                   	ret    
    return 0;
 573:	b8 00 00 00 00       	mov    $0x0,%eax
 578:	eb f4                	jmp    56e <morecore+0x44>

0000057a <malloc>:

void*
malloc(uint nbytes)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	53                   	push   %ebx
 57e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	8d 58 07             	lea    0x7(%eax),%ebx
 587:	c1 eb 03             	shr    $0x3,%ebx
 58a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 58d:	8b 0d 38 09 00 00    	mov    0x938,%ecx
 593:	85 c9                	test   %ecx,%ecx
 595:	74 04                	je     59b <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 597:	8b 01                	mov    (%ecx),%eax
 599:	eb 4a                	jmp    5e5 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 59b:	c7 05 38 09 00 00 3c 	movl   $0x93c,0x938
 5a2:	09 00 00 
 5a5:	c7 05 3c 09 00 00 3c 	movl   $0x93c,0x93c
 5ac:	09 00 00 
    base.s.size = 0;
 5af:	c7 05 40 09 00 00 00 	movl   $0x0,0x940
 5b6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5b9:	b9 3c 09 00 00       	mov    $0x93c,%ecx
 5be:	eb d7                	jmp    597 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c0:	74 19                	je     5db <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5c2:	29 da                	sub    %ebx,%edx
 5c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5c7:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5ca:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5cd:	89 0d 38 09 00 00    	mov    %ecx,0x938
      return (void*)(p + 1);
 5d3:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d9:	c9                   	leave  
 5da:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5db:	8b 10                	mov    (%eax),%edx
 5dd:	89 11                	mov    %edx,(%ecx)
 5df:	eb ec                	jmp    5cd <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e1:	89 c1                	mov    %eax,%ecx
 5e3:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5e5:	8b 50 04             	mov    0x4(%eax),%edx
 5e8:	39 da                	cmp    %ebx,%edx
 5ea:	73 d4                	jae    5c0 <malloc+0x46>
    if(p == freep)
 5ec:	39 05 38 09 00 00    	cmp    %eax,0x938
 5f2:	75 ed                	jne    5e1 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5f4:	89 d8                	mov    %ebx,%eax
 5f6:	e8 2f ff ff ff       	call   52a <morecore>
 5fb:	85 c0                	test   %eax,%eax
 5fd:	75 e2                	jne    5e1 <malloc+0x67>
 5ff:	eb d5                	jmp    5d6 <malloc+0x5c>
