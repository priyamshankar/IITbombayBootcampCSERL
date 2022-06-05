
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
  23:	68 14 06 00 00       	push   $0x614
  28:	6a 01                	push   $0x1
  2a:	e8 35 03 00 00       	call   364 <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	eb e2                	jmp    16 <main+0x16>
        printf(2, "usage: pname pid...\n");
  34:	83 ec 08             	sub    $0x8,%esp
  37:	68 30 06 00 00       	push   $0x630
  3c:	6a 02                	push   $0x2
  3e:	e8 21 03 00 00       	call   364 <printf>
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
SYSCALL(signalProcess)
 2a7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <numvp>:
SYSCALL(numvp)
 2af:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <numpp>:
 2b7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	83 ec 1c             	sub    $0x1c,%esp
 2c5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c8:	6a 01                	push   $0x1
 2ca:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2cd:	52                   	push   %edx
 2ce:	50                   	push   %eax
 2cf:	e8 33 ff ff ff       	call   207 <write>
}
 2d4:	83 c4 10             	add    $0x10,%esp
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	57                   	push   %edi
 2dd:	56                   	push   %esi
 2de:	53                   	push   %ebx
 2df:	83 ec 2c             	sub    $0x2c,%esp
 2e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2e5:	89 d0                	mov    %edx,%eax
 2e7:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2ed:	0f 95 c1             	setne  %cl
 2f0:	c1 ea 1f             	shr    $0x1f,%edx
 2f3:	84 d1                	test   %dl,%cl
 2f5:	74 44                	je     33b <printint+0x62>
    neg = 1;
    x = -xx;
 2f7:	f7 d8                	neg    %eax
 2f9:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2fb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 302:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 307:	89 c8                	mov    %ecx,%eax
 309:	ba 00 00 00 00       	mov    $0x0,%edx
 30e:	f7 f6                	div    %esi
 310:	89 df                	mov    %ebx,%edi
 312:	83 c3 01             	add    $0x1,%ebx
 315:	0f b6 92 a4 06 00 00 	movzbl 0x6a4(%edx),%edx
 31c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 320:	89 ca                	mov    %ecx,%edx
 322:	89 c1                	mov    %eax,%ecx
 324:	39 d6                	cmp    %edx,%esi
 326:	76 df                	jbe    307 <printint+0x2e>
  if(neg)
 328:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 32c:	74 31                	je     35f <printint+0x86>
    buf[i++] = '-';
 32e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 333:	8d 5f 02             	lea    0x2(%edi),%ebx
 336:	8b 75 d0             	mov    -0x30(%ebp),%esi
 339:	eb 17                	jmp    352 <printint+0x79>
    x = xx;
 33b:	89 c1                	mov    %eax,%ecx
  neg = 0;
 33d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 344:	eb bc                	jmp    302 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 346:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 34b:	89 f0                	mov    %esi,%eax
 34d:	e8 6d ff ff ff       	call   2bf <putc>
  while(--i >= 0)
 352:	83 eb 01             	sub    $0x1,%ebx
 355:	79 ef                	jns    346 <printint+0x6d>
}
 357:	83 c4 2c             	add    $0x2c,%esp
 35a:	5b                   	pop    %ebx
 35b:	5e                   	pop    %esi
 35c:	5f                   	pop    %edi
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    
 35f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 362:	eb ee                	jmp    352 <printint+0x79>

00000364 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 36d:	8d 45 10             	lea    0x10(%ebp),%eax
 370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 373:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 378:	bb 00 00 00 00       	mov    $0x0,%ebx
 37d:	eb 14                	jmp    393 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 37f:	89 fa                	mov    %edi,%edx
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	e8 36 ff ff ff       	call   2bf <putc>
 389:	eb 05                	jmp    390 <printf+0x2c>
      }
    } else if(state == '%'){
 38b:	83 fe 25             	cmp    $0x25,%esi
 38e:	74 25                	je     3b5 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 390:	83 c3 01             	add    $0x1,%ebx
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 39a:	84 c0                	test   %al,%al
 39c:	0f 84 20 01 00 00    	je     4c2 <printf+0x15e>
    c = fmt[i] & 0xff;
 3a2:	0f be f8             	movsbl %al,%edi
 3a5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a8:	85 f6                	test   %esi,%esi
 3aa:	75 df                	jne    38b <printf+0x27>
      if(c == '%'){
 3ac:	83 f8 25             	cmp    $0x25,%eax
 3af:	75 ce                	jne    37f <printf+0x1b>
        state = '%';
 3b1:	89 c6                	mov    %eax,%esi
 3b3:	eb db                	jmp    390 <printf+0x2c>
      if(c == 'd'){
 3b5:	83 f8 25             	cmp    $0x25,%eax
 3b8:	0f 84 cf 00 00 00    	je     48d <printf+0x129>
 3be:	0f 8c dd 00 00 00    	jl     4a1 <printf+0x13d>
 3c4:	83 f8 78             	cmp    $0x78,%eax
 3c7:	0f 8f d4 00 00 00    	jg     4a1 <printf+0x13d>
 3cd:	83 f8 63             	cmp    $0x63,%eax
 3d0:	0f 8c cb 00 00 00    	jl     4a1 <printf+0x13d>
 3d6:	83 e8 63             	sub    $0x63,%eax
 3d9:	83 f8 15             	cmp    $0x15,%eax
 3dc:	0f 87 bf 00 00 00    	ja     4a1 <printf+0x13d>
 3e2:	ff 24 85 4c 06 00 00 	jmp    *0x64c(,%eax,4)
        printint(fd, *ap, 10, 1);
 3e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ec:	8b 17                	mov    (%edi),%edx
 3ee:	83 ec 0c             	sub    $0xc,%esp
 3f1:	6a 01                	push   $0x1
 3f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	e8 d9 fe ff ff       	call   2d9 <printint>
        ap++;
 400:	83 c7 04             	add    $0x4,%edi
 403:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 406:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 409:	be 00 00 00 00       	mov    $0x0,%esi
 40e:	eb 80                	jmp    390 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 413:	8b 17                	mov    (%edi),%edx
 415:	83 ec 0c             	sub    $0xc,%esp
 418:	6a 00                	push   $0x0
 41a:	b9 10 00 00 00       	mov    $0x10,%ecx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	e8 b2 fe ff ff       	call   2d9 <printint>
        ap++;
 427:	83 c7 04             	add    $0x4,%edi
 42a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 42d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 430:	be 00 00 00 00       	mov    $0x0,%esi
 435:	e9 56 ff ff ff       	jmp    390 <printf+0x2c>
        s = (char*)*ap;
 43a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43d:	8b 30                	mov    (%eax),%esi
        ap++;
 43f:	83 c0 04             	add    $0x4,%eax
 442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 445:	85 f6                	test   %esi,%esi
 447:	75 15                	jne    45e <printf+0xfa>
          s = "(null)";
 449:	be 45 06 00 00       	mov    $0x645,%esi
 44e:	eb 0e                	jmp    45e <printf+0xfa>
          putc(fd, *s);
 450:	0f be d2             	movsbl %dl,%edx
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	e8 64 fe ff ff       	call   2bf <putc>
          s++;
 45b:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 45e:	0f b6 16             	movzbl (%esi),%edx
 461:	84 d2                	test   %dl,%dl
 463:	75 eb                	jne    450 <printf+0xec>
      state = 0;
 465:	be 00 00 00 00       	mov    $0x0,%esi
 46a:	e9 21 ff ff ff       	jmp    390 <printf+0x2c>
        putc(fd, *ap);
 46f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 472:	0f be 17             	movsbl (%edi),%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	e8 42 fe ff ff       	call   2bf <putc>
        ap++;
 47d:	83 c7 04             	add    $0x4,%edi
 480:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 483:	be 00 00 00 00       	mov    $0x0,%esi
 488:	e9 03 ff ff ff       	jmp    390 <printf+0x2c>
        putc(fd, c);
 48d:	89 fa                	mov    %edi,%edx
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	e8 28 fe ff ff       	call   2bf <putc>
      state = 0;
 497:	be 00 00 00 00       	mov    $0x0,%esi
 49c:	e9 ef fe ff ff       	jmp    390 <printf+0x2c>
        putc(fd, '%');
 4a1:	ba 25 00 00 00       	mov    $0x25,%edx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	e8 11 fe ff ff       	call   2bf <putc>
        putc(fd, c);
 4ae:	89 fa                	mov    %edi,%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 07 fe ff ff       	call   2bf <putc>
      state = 0;
 4b8:	be 00 00 00 00       	mov    $0x0,%esi
 4bd:	e9 ce fe ff ff       	jmp    390 <printf+0x2c>
    }
  }
}
 4c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c5:	5b                   	pop    %ebx
 4c6:	5e                   	pop    %esi
 4c7:	5f                   	pop    %edi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    

000004ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ca:	55                   	push   %ebp
 4cb:	89 e5                	mov    %esp,%ebp
 4cd:	57                   	push   %edi
 4ce:	56                   	push   %esi
 4cf:	53                   	push   %ebx
 4d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d3:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d6:	a1 48 09 00 00       	mov    0x948,%eax
 4db:	eb 02                	jmp    4df <free+0x15>
 4dd:	89 d0                	mov    %edx,%eax
 4df:	39 c8                	cmp    %ecx,%eax
 4e1:	73 04                	jae    4e7 <free+0x1d>
 4e3:	39 08                	cmp    %ecx,(%eax)
 4e5:	77 12                	ja     4f9 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e7:	8b 10                	mov    (%eax),%edx
 4e9:	39 c2                	cmp    %eax,%edx
 4eb:	77 f0                	ja     4dd <free+0x13>
 4ed:	39 c8                	cmp    %ecx,%eax
 4ef:	72 08                	jb     4f9 <free+0x2f>
 4f1:	39 ca                	cmp    %ecx,%edx
 4f3:	77 04                	ja     4f9 <free+0x2f>
 4f5:	89 d0                	mov    %edx,%eax
 4f7:	eb e6                	jmp    4df <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f9:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4fc:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ff:	8b 10                	mov    (%eax),%edx
 501:	39 d7                	cmp    %edx,%edi
 503:	74 19                	je     51e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 505:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 508:	8b 50 04             	mov    0x4(%eax),%edx
 50b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 50e:	39 ce                	cmp    %ecx,%esi
 510:	74 1b                	je     52d <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 512:	89 08                	mov    %ecx,(%eax)
  freep = p;
 514:	a3 48 09 00 00       	mov    %eax,0x948
}
 519:	5b                   	pop    %ebx
 51a:	5e                   	pop    %esi
 51b:	5f                   	pop    %edi
 51c:	5d                   	pop    %ebp
 51d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 51e:	03 72 04             	add    0x4(%edx),%esi
 521:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 524:	8b 10                	mov    (%eax),%edx
 526:	8b 12                	mov    (%edx),%edx
 528:	89 53 f8             	mov    %edx,-0x8(%ebx)
 52b:	eb db                	jmp    508 <free+0x3e>
    p->s.size += bp->s.size;
 52d:	03 53 fc             	add    -0x4(%ebx),%edx
 530:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 533:	8b 53 f8             	mov    -0x8(%ebx),%edx
 536:	89 10                	mov    %edx,(%eax)
 538:	eb da                	jmp    514 <free+0x4a>

0000053a <morecore>:

static Header*
morecore(uint nu)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	53                   	push   %ebx
 53e:	83 ec 04             	sub    $0x4,%esp
 541:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 543:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 548:	77 05                	ja     54f <morecore+0x15>
    nu = 4096;
 54a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 54f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 556:	83 ec 0c             	sub    $0xc,%esp
 559:	50                   	push   %eax
 55a:	e8 10 fd ff ff       	call   26f <sbrk>
  if(p == (char*)-1)
 55f:	83 c4 10             	add    $0x10,%esp
 562:	83 f8 ff             	cmp    $0xffffffff,%eax
 565:	74 1c                	je     583 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 567:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 56a:	83 c0 08             	add    $0x8,%eax
 56d:	83 ec 0c             	sub    $0xc,%esp
 570:	50                   	push   %eax
 571:	e8 54 ff ff ff       	call   4ca <free>
  return freep;
 576:	a1 48 09 00 00       	mov    0x948,%eax
 57b:	83 c4 10             	add    $0x10,%esp
}
 57e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 581:	c9                   	leave  
 582:	c3                   	ret    
    return 0;
 583:	b8 00 00 00 00       	mov    $0x0,%eax
 588:	eb f4                	jmp    57e <morecore+0x44>

0000058a <malloc>:

void*
malloc(uint nbytes)
{
 58a:	55                   	push   %ebp
 58b:	89 e5                	mov    %esp,%ebp
 58d:	53                   	push   %ebx
 58e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	8d 58 07             	lea    0x7(%eax),%ebx
 597:	c1 eb 03             	shr    $0x3,%ebx
 59a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 59d:	8b 0d 48 09 00 00    	mov    0x948,%ecx
 5a3:	85 c9                	test   %ecx,%ecx
 5a5:	74 04                	je     5ab <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a7:	8b 01                	mov    (%ecx),%eax
 5a9:	eb 4a                	jmp    5f5 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5ab:	c7 05 48 09 00 00 4c 	movl   $0x94c,0x948
 5b2:	09 00 00 
 5b5:	c7 05 4c 09 00 00 4c 	movl   $0x94c,0x94c
 5bc:	09 00 00 
    base.s.size = 0;
 5bf:	c7 05 50 09 00 00 00 	movl   $0x0,0x950
 5c6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5c9:	b9 4c 09 00 00       	mov    $0x94c,%ecx
 5ce:	eb d7                	jmp    5a7 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d0:	74 19                	je     5eb <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5d2:	29 da                	sub    %ebx,%edx
 5d4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5d7:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5da:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5dd:	89 0d 48 09 00 00    	mov    %ecx,0x948
      return (void*)(p + 1);
 5e3:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e9:	c9                   	leave  
 5ea:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5eb:	8b 10                	mov    (%eax),%edx
 5ed:	89 11                	mov    %edx,(%ecx)
 5ef:	eb ec                	jmp    5dd <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	89 c1                	mov    %eax,%ecx
 5f3:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5f5:	8b 50 04             	mov    0x4(%eax),%edx
 5f8:	39 da                	cmp    %ebx,%edx
 5fa:	73 d4                	jae    5d0 <malloc+0x46>
    if(p == freep)
 5fc:	39 05 48 09 00 00    	cmp    %eax,0x948
 602:	75 ed                	jne    5f1 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 604:	89 d8                	mov    %ebx,%eax
 606:	e8 2f ff ff ff       	call   53a <morecore>
 60b:	85 c0                	test   %eax,%eax
 60d:	75 e2                	jne    5f1 <malloc+0x67>
 60f:	eb d5                	jmp    5e6 <malloc+0x5c>
