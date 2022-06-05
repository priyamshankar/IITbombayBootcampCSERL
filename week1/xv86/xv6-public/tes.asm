
_tes:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define MAX_SZ 1000000
#define SIGNAL_PAUSE "PAUSE"
#define SIGNAL_CONTINUE "CONTINUE"
#define SIGNAL_KILL "KILL"
int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    //     printf(1, "parent %d\n", getpid());
    //     wait();
    // }

	// signalProcess(ret, SIGNAL_PAUSE);
    int ret = fork();
  11:	e8 c1 01 00 00       	call   1d7 <fork>
	if(ret == 0) 
  16:	85 c0                	test   %eax,%eax
  18:	75 13                	jne    2d <main+0x2d>
		// for (int i = 0; i < MAX_SZ; ++i)
		// {
		// 	sleep(5e1);
		// 	printf(1, "child: Not_paused\n");
		// }
	signalProcess(ret, SIGNAL_PAUSE);
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 0c 06 00 00       	push   $0x60c
  22:	50                   	push   %eax
  23:	e8 77 02 00 00       	call   29f <signalProcess>

		exit();
  28:	e8 b2 01 00 00       	call   1df <exit>
	}
	signalProcess(ret, SIGNAL_KILL);
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 12 06 00 00       	push   $0x612
  35:	50                   	push   %eax
  36:	e8 64 02 00 00       	call   29f <signalProcess>
    // printf(1,"fork no.: %d\n",ret);
    // get_siblings_info();
    // printf(1, "pid= %d and ppid is = %d\n", getpid(), getppid());
    // printf(1, "fork ret = %d", ret);
    // wait();
    exit();
  3b:	e8 9f 01 00 00       	call   1df <exit>

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  45:	8b 75 08             	mov    0x8(%ebp),%esi
  48:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4b:	89 f0                	mov    %esi,%eax
  4d:	89 d1                	mov    %edx,%ecx
  4f:	83 c2 01             	add    $0x1,%edx
  52:	89 c3                	mov    %eax,%ebx
  54:	83 c0 01             	add    $0x1,%eax
  57:	0f b6 09             	movzbl (%ecx),%ecx
  5a:	88 0b                	mov    %cl,(%ebx)
  5c:	84 c9                	test   %cl,%cl
  5e:	75 ed                	jne    4d <strcpy+0xd>
    ;
  return os;
}
  60:	89 f0                	mov    %esi,%eax
  62:	5b                   	pop    %ebx
  63:	5e                   	pop    %esi
  64:	5d                   	pop    %ebp
  65:	c3                   	ret    

00000066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  66:	55                   	push   %ebp
  67:	89 e5                	mov    %esp,%ebp
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  6f:	eb 06                	jmp    77 <strcmp+0x11>
    p++, q++;
  71:	83 c1 01             	add    $0x1,%ecx
  74:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  77:	0f b6 01             	movzbl (%ecx),%eax
  7a:	84 c0                	test   %al,%al
  7c:	74 04                	je     82 <strcmp+0x1c>
  7e:	3a 02                	cmp    (%edx),%al
  80:	74 ef                	je     71 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  82:	0f b6 c0             	movzbl %al,%eax
  85:	0f b6 12             	movzbl (%edx),%edx
  88:	29 d0                	sub    %edx,%eax
}
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  92:	b8 00 00 00 00       	mov    $0x0,%eax
  97:	eb 03                	jmp    9c <strlen+0x10>
  99:	83 c0 01             	add    $0x1,%eax
  9c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  a0:	75 f7                	jne    99 <strlen+0xd>
    ;
  return n;
}
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    

000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	57                   	push   %edi
  a8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ab:	89 d7                	mov    %edx,%edi
  ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  b3:	fc                   	cld    
  b4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b6:	89 d0                	mov    %edx,%eax
  b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strchr>:

char*
strchr(const char *s, char c)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c7:	eb 03                	jmp    cc <strchr+0xf>
  c9:	83 c0 01             	add    $0x1,%eax
  cc:	0f b6 10             	movzbl (%eax),%edx
  cf:	84 d2                	test   %dl,%dl
  d1:	74 06                	je     d9 <strchr+0x1c>
    if(*s == c)
  d3:	38 ca                	cmp    %cl,%dl
  d5:	75 f2                	jne    c9 <strchr+0xc>
  d7:	eb 05                	jmp    de <strchr+0x21>
      return (char*)s;
  return 0;
  d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <gets>:

char*
gets(char *buf, int max)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	83 ec 1c             	sub    $0x1c,%esp
  e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  f1:	89 de                	mov    %ebx,%esi
  f3:	83 c3 01             	add    $0x1,%ebx
  f6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  f9:	7d 2e                	jge    129 <gets+0x49>
    cc = read(0, &c, 1);
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	6a 01                	push   $0x1
 100:	8d 45 e7             	lea    -0x19(%ebp),%eax
 103:	50                   	push   %eax
 104:	6a 00                	push   $0x0
 106:	e8 ec 00 00 00       	call   1f7 <read>
    if(cc < 1)
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	85 c0                	test   %eax,%eax
 110:	7e 17                	jle    129 <gets+0x49>
      break;
    buf[i++] = c;
 112:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 116:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 119:	3c 0a                	cmp    $0xa,%al
 11b:	0f 94 c2             	sete   %dl
 11e:	3c 0d                	cmp    $0xd,%al
 120:	0f 94 c0             	sete   %al
 123:	08 c2                	or     %al,%dl
 125:	74 ca                	je     f1 <gets+0x11>
    buf[i++] = c;
 127:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 129:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 12d:	89 f8                	mov    %edi,%eax
 12f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 132:	5b                   	pop    %ebx
 133:	5e                   	pop    %esi
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    

00000137 <stat>:

int
stat(const char *n, struct stat *st)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 08             	push   0x8(%ebp)
 144:	e8 d6 00 00 00       	call   21f <open>
  if(fd < 0)
 149:	83 c4 10             	add    $0x10,%esp
 14c:	85 c0                	test   %eax,%eax
 14e:	78 24                	js     174 <stat+0x3d>
 150:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 152:	83 ec 08             	sub    $0x8,%esp
 155:	ff 75 0c             	push   0xc(%ebp)
 158:	50                   	push   %eax
 159:	e8 d9 00 00 00       	call   237 <fstat>
 15e:	89 c6                	mov    %eax,%esi
  close(fd);
 160:	89 1c 24             	mov    %ebx,(%esp)
 163:	e8 9f 00 00 00       	call   207 <close>
  return r;
 168:	83 c4 10             	add    $0x10,%esp
}
 16b:	89 f0                	mov    %esi,%eax
 16d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 170:	5b                   	pop    %ebx
 171:	5e                   	pop    %esi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
    return -1;
 174:	be ff ff ff ff       	mov    $0xffffffff,%esi
 179:	eb f0                	jmp    16b <stat+0x34>

0000017b <atoi>:

int
atoi(const char *s)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	53                   	push   %ebx
 17f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 182:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 187:	eb 10                	jmp    199 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 189:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 18c:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 18f:	83 c1 01             	add    $0x1,%ecx
 192:	0f be c0             	movsbl %al,%eax
 195:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 199:	0f b6 01             	movzbl (%ecx),%eax
 19c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 19f:	80 fb 09             	cmp    $0x9,%bl
 1a2:	76 e5                	jbe    189 <atoi+0xe>
  return n;
}
 1a4:	89 d0                	mov    %edx,%eax
 1a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	56                   	push   %esi
 1af:	53                   	push   %ebx
 1b0:	8b 75 08             	mov    0x8(%ebp),%esi
 1b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1b6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1b9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1bb:	eb 0d                	jmp    1ca <memmove+0x1f>
    *dst++ = *src++;
 1bd:	0f b6 01             	movzbl (%ecx),%eax
 1c0:	88 02                	mov    %al,(%edx)
 1c2:	8d 49 01             	lea    0x1(%ecx),%ecx
 1c5:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1c8:	89 d8                	mov    %ebx,%eax
 1ca:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1cd:	85 c0                	test   %eax,%eax
 1cf:	7f ec                	jg     1bd <memmove+0x12>
  return vdst;
}
 1d1:	89 f0                	mov    %esi,%eax
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    

000001d7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1d7:	b8 01 00 00 00       	mov    $0x1,%eax
 1dc:	cd 40                	int    $0x40
 1de:	c3                   	ret    

000001df <exit>:
SYSCALL(exit)
 1df:	b8 02 00 00 00       	mov    $0x2,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <wait>:
SYSCALL(wait)
 1e7:	b8 03 00 00 00       	mov    $0x3,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <pipe>:
SYSCALL(pipe)
 1ef:	b8 04 00 00 00       	mov    $0x4,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <read>:
SYSCALL(read)
 1f7:	b8 05 00 00 00       	mov    $0x5,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <write>:
SYSCALL(write)
 1ff:	b8 10 00 00 00       	mov    $0x10,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <close>:
SYSCALL(close)
 207:	b8 15 00 00 00       	mov    $0x15,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <kill>:
SYSCALL(kill)
 20f:	b8 06 00 00 00       	mov    $0x6,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <exec>:
SYSCALL(exec)
 217:	b8 07 00 00 00       	mov    $0x7,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <open>:
SYSCALL(open)
 21f:	b8 0f 00 00 00       	mov    $0xf,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <mknod>:
SYSCALL(mknod)
 227:	b8 11 00 00 00       	mov    $0x11,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <unlink>:
SYSCALL(unlink)
 22f:	b8 12 00 00 00       	mov    $0x12,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <fstat>:
SYSCALL(fstat)
 237:	b8 08 00 00 00       	mov    $0x8,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <link>:
SYSCALL(link)
 23f:	b8 13 00 00 00       	mov    $0x13,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <mkdir>:
SYSCALL(mkdir)
 247:	b8 14 00 00 00       	mov    $0x14,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <chdir>:
SYSCALL(chdir)
 24f:	b8 09 00 00 00       	mov    $0x9,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <dup>:
SYSCALL(dup)
 257:	b8 0a 00 00 00       	mov    $0xa,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <getpid>:
SYSCALL(getpid)
 25f:	b8 0b 00 00 00       	mov    $0xb,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <sbrk>:
SYSCALL(sbrk)
 267:	b8 0c 00 00 00       	mov    $0xc,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <sleep>:
SYSCALL(sleep)
 26f:	b8 0d 00 00 00       	mov    $0xd,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <uptime>:
SYSCALL(uptime)
 277:	b8 0e 00 00 00       	mov    $0xe,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <hello>:
SYSCALL(hello)
 27f:	b8 16 00 00 00       	mov    $0x16,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <helloYou>:
SYSCALL(helloYou)
 287:	b8 17 00 00 00       	mov    $0x17,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <getppid>:
SYSCALL(getppid)
 28f:	b8 18 00 00 00       	mov    $0x18,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <get_siblings_info>:
SYSCALL(get_siblings_info)
 297:	b8 19 00 00 00       	mov    $0x19,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <signalProcess>:
SYSCALL(signalProcess)
 29f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <numvp>:
SYSCALL(numvp)
 2a7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <numpp>:
 2af:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	83 ec 1c             	sub    $0x1c,%esp
 2bd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c0:	6a 01                	push   $0x1
 2c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c5:	52                   	push   %edx
 2c6:	50                   	push   %eax
 2c7:	e8 33 ff ff ff       	call   1ff <write>
}
 2cc:	83 c4 10             	add    $0x10,%esp
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	57                   	push   %edi
 2d5:	56                   	push   %esi
 2d6:	53                   	push   %ebx
 2d7:	83 ec 2c             	sub    $0x2c,%esp
 2da:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2dd:	89 d0                	mov    %edx,%eax
 2df:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e5:	0f 95 c1             	setne  %cl
 2e8:	c1 ea 1f             	shr    $0x1f,%edx
 2eb:	84 d1                	test   %dl,%cl
 2ed:	74 44                	je     333 <printint+0x62>
    neg = 1;
    x = -xx;
 2ef:	f7 d8                	neg    %eax
 2f1:	89 c1                	mov    %eax,%ecx
    neg = 1;
 2f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ff:	89 c8                	mov    %ecx,%eax
 301:	ba 00 00 00 00       	mov    $0x0,%edx
 306:	f7 f6                	div    %esi
 308:	89 df                	mov    %ebx,%edi
 30a:	83 c3 01             	add    $0x1,%ebx
 30d:	0f b6 92 78 06 00 00 	movzbl 0x678(%edx),%edx
 314:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 318:	89 ca                	mov    %ecx,%edx
 31a:	89 c1                	mov    %eax,%ecx
 31c:	39 d6                	cmp    %edx,%esi
 31e:	76 df                	jbe    2ff <printint+0x2e>
  if(neg)
 320:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 324:	74 31                	je     357 <printint+0x86>
    buf[i++] = '-';
 326:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32b:	8d 5f 02             	lea    0x2(%edi),%ebx
 32e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 331:	eb 17                	jmp    34a <printint+0x79>
    x = xx;
 333:	89 c1                	mov    %eax,%ecx
  neg = 0;
 335:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 33c:	eb bc                	jmp    2fa <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 33e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 343:	89 f0                	mov    %esi,%eax
 345:	e8 6d ff ff ff       	call   2b7 <putc>
  while(--i >= 0)
 34a:	83 eb 01             	sub    $0x1,%ebx
 34d:	79 ef                	jns    33e <printint+0x6d>
}
 34f:	83 c4 2c             	add    $0x2c,%esp
 352:	5b                   	pop    %ebx
 353:	5e                   	pop    %esi
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	8b 75 d0             	mov    -0x30(%ebp),%esi
 35a:	eb ee                	jmp    34a <printint+0x79>

0000035c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 365:	8d 45 10             	lea    0x10(%ebp),%eax
 368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 370:	bb 00 00 00 00       	mov    $0x0,%ebx
 375:	eb 14                	jmp    38b <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 377:	89 fa                	mov    %edi,%edx
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	e8 36 ff ff ff       	call   2b7 <putc>
 381:	eb 05                	jmp    388 <printf+0x2c>
      }
    } else if(state == '%'){
 383:	83 fe 25             	cmp    $0x25,%esi
 386:	74 25                	je     3ad <printf+0x51>
  for(i = 0; fmt[i]; i++){
 388:	83 c3 01             	add    $0x1,%ebx
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 392:	84 c0                	test   %al,%al
 394:	0f 84 20 01 00 00    	je     4ba <printf+0x15e>
    c = fmt[i] & 0xff;
 39a:	0f be f8             	movsbl %al,%edi
 39d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a0:	85 f6                	test   %esi,%esi
 3a2:	75 df                	jne    383 <printf+0x27>
      if(c == '%'){
 3a4:	83 f8 25             	cmp    $0x25,%eax
 3a7:	75 ce                	jne    377 <printf+0x1b>
        state = '%';
 3a9:	89 c6                	mov    %eax,%esi
 3ab:	eb db                	jmp    388 <printf+0x2c>
      if(c == 'd'){
 3ad:	83 f8 25             	cmp    $0x25,%eax
 3b0:	0f 84 cf 00 00 00    	je     485 <printf+0x129>
 3b6:	0f 8c dd 00 00 00    	jl     499 <printf+0x13d>
 3bc:	83 f8 78             	cmp    $0x78,%eax
 3bf:	0f 8f d4 00 00 00    	jg     499 <printf+0x13d>
 3c5:	83 f8 63             	cmp    $0x63,%eax
 3c8:	0f 8c cb 00 00 00    	jl     499 <printf+0x13d>
 3ce:	83 e8 63             	sub    $0x63,%eax
 3d1:	83 f8 15             	cmp    $0x15,%eax
 3d4:	0f 87 bf 00 00 00    	ja     499 <printf+0x13d>
 3da:	ff 24 85 20 06 00 00 	jmp    *0x620(,%eax,4)
        printint(fd, *ap, 10, 1);
 3e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3e4:	8b 17                	mov    (%edi),%edx
 3e6:	83 ec 0c             	sub    $0xc,%esp
 3e9:	6a 01                	push   $0x1
 3eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	e8 d9 fe ff ff       	call   2d1 <printint>
        ap++;
 3f8:	83 c7 04             	add    $0x4,%edi
 3fb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3fe:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 401:	be 00 00 00 00       	mov    $0x0,%esi
 406:	eb 80                	jmp    388 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40b:	8b 17                	mov    (%edi),%edx
 40d:	83 ec 0c             	sub    $0xc,%esp
 410:	6a 00                	push   $0x0
 412:	b9 10 00 00 00       	mov    $0x10,%ecx
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	e8 b2 fe ff ff       	call   2d1 <printint>
        ap++;
 41f:	83 c7 04             	add    $0x4,%edi
 422:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 425:	83 c4 10             	add    $0x10,%esp
      state = 0;
 428:	be 00 00 00 00       	mov    $0x0,%esi
 42d:	e9 56 ff ff ff       	jmp    388 <printf+0x2c>
        s = (char*)*ap;
 432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 435:	8b 30                	mov    (%eax),%esi
        ap++;
 437:	83 c0 04             	add    $0x4,%eax
 43a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 43d:	85 f6                	test   %esi,%esi
 43f:	75 15                	jne    456 <printf+0xfa>
          s = "(null)";
 441:	be 17 06 00 00       	mov    $0x617,%esi
 446:	eb 0e                	jmp    456 <printf+0xfa>
          putc(fd, *s);
 448:	0f be d2             	movsbl %dl,%edx
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	e8 64 fe ff ff       	call   2b7 <putc>
          s++;
 453:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 456:	0f b6 16             	movzbl (%esi),%edx
 459:	84 d2                	test   %dl,%dl
 45b:	75 eb                	jne    448 <printf+0xec>
      state = 0;
 45d:	be 00 00 00 00       	mov    $0x0,%esi
 462:	e9 21 ff ff ff       	jmp    388 <printf+0x2c>
        putc(fd, *ap);
 467:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46a:	0f be 17             	movsbl (%edi),%edx
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	e8 42 fe ff ff       	call   2b7 <putc>
        ap++;
 475:	83 c7 04             	add    $0x4,%edi
 478:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 47b:	be 00 00 00 00       	mov    $0x0,%esi
 480:	e9 03 ff ff ff       	jmp    388 <printf+0x2c>
        putc(fd, c);
 485:	89 fa                	mov    %edi,%edx
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	e8 28 fe ff ff       	call   2b7 <putc>
      state = 0;
 48f:	be 00 00 00 00       	mov    $0x0,%esi
 494:	e9 ef fe ff ff       	jmp    388 <printf+0x2c>
        putc(fd, '%');
 499:	ba 25 00 00 00       	mov    $0x25,%edx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 11 fe ff ff       	call   2b7 <putc>
        putc(fd, c);
 4a6:	89 fa                	mov    %edi,%edx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	e8 07 fe ff ff       	call   2b7 <putc>
      state = 0;
 4b0:	be 00 00 00 00       	mov    $0x0,%esi
 4b5:	e9 ce fe ff ff       	jmp    388 <printf+0x2c>
    }
  }
}
 4ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bd:	5b                   	pop    %ebx
 4be:	5e                   	pop    %esi
 4bf:	5f                   	pop    %edi
 4c0:	5d                   	pop    %ebp
 4c1:	c3                   	ret    

000004c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	57                   	push   %edi
 4c6:	56                   	push   %esi
 4c7:	53                   	push   %ebx
 4c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4cb:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ce:	a1 18 09 00 00       	mov    0x918,%eax
 4d3:	eb 02                	jmp    4d7 <free+0x15>
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	39 c8                	cmp    %ecx,%eax
 4d9:	73 04                	jae    4df <free+0x1d>
 4db:	39 08                	cmp    %ecx,(%eax)
 4dd:	77 12                	ja     4f1 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4df:	8b 10                	mov    (%eax),%edx
 4e1:	39 c2                	cmp    %eax,%edx
 4e3:	77 f0                	ja     4d5 <free+0x13>
 4e5:	39 c8                	cmp    %ecx,%eax
 4e7:	72 08                	jb     4f1 <free+0x2f>
 4e9:	39 ca                	cmp    %ecx,%edx
 4eb:	77 04                	ja     4f1 <free+0x2f>
 4ed:	89 d0                	mov    %edx,%eax
 4ef:	eb e6                	jmp    4d7 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4f1:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4f4:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f7:	8b 10                	mov    (%eax),%edx
 4f9:	39 d7                	cmp    %edx,%edi
 4fb:	74 19                	je     516 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4fd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 500:	8b 50 04             	mov    0x4(%eax),%edx
 503:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 506:	39 ce                	cmp    %ecx,%esi
 508:	74 1b                	je     525 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 50a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 50c:	a3 18 09 00 00       	mov    %eax,0x918
}
 511:	5b                   	pop    %ebx
 512:	5e                   	pop    %esi
 513:	5f                   	pop    %edi
 514:	5d                   	pop    %ebp
 515:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 516:	03 72 04             	add    0x4(%edx),%esi
 519:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 51c:	8b 10                	mov    (%eax),%edx
 51e:	8b 12                	mov    (%edx),%edx
 520:	89 53 f8             	mov    %edx,-0x8(%ebx)
 523:	eb db                	jmp    500 <free+0x3e>
    p->s.size += bp->s.size;
 525:	03 53 fc             	add    -0x4(%ebx),%edx
 528:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 52b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 52e:	89 10                	mov    %edx,(%eax)
 530:	eb da                	jmp    50c <free+0x4a>

00000532 <morecore>:

static Header*
morecore(uint nu)
{
 532:	55                   	push   %ebp
 533:	89 e5                	mov    %esp,%ebp
 535:	53                   	push   %ebx
 536:	83 ec 04             	sub    $0x4,%esp
 539:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 53b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 540:	77 05                	ja     547 <morecore+0x15>
    nu = 4096;
 542:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 547:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 54e:	83 ec 0c             	sub    $0xc,%esp
 551:	50                   	push   %eax
 552:	e8 10 fd ff ff       	call   267 <sbrk>
  if(p == (char*)-1)
 557:	83 c4 10             	add    $0x10,%esp
 55a:	83 f8 ff             	cmp    $0xffffffff,%eax
 55d:	74 1c                	je     57b <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 55f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 562:	83 c0 08             	add    $0x8,%eax
 565:	83 ec 0c             	sub    $0xc,%esp
 568:	50                   	push   %eax
 569:	e8 54 ff ff ff       	call   4c2 <free>
  return freep;
 56e:	a1 18 09 00 00       	mov    0x918,%eax
 573:	83 c4 10             	add    $0x10,%esp
}
 576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 579:	c9                   	leave  
 57a:	c3                   	ret    
    return 0;
 57b:	b8 00 00 00 00       	mov    $0x0,%eax
 580:	eb f4                	jmp    576 <morecore+0x44>

00000582 <malloc>:

void*
malloc(uint nbytes)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	53                   	push   %ebx
 586:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	8d 58 07             	lea    0x7(%eax),%ebx
 58f:	c1 eb 03             	shr    $0x3,%ebx
 592:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 595:	8b 0d 18 09 00 00    	mov    0x918,%ecx
 59b:	85 c9                	test   %ecx,%ecx
 59d:	74 04                	je     5a3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 59f:	8b 01                	mov    (%ecx),%eax
 5a1:	eb 4a                	jmp    5ed <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5a3:	c7 05 18 09 00 00 1c 	movl   $0x91c,0x918
 5aa:	09 00 00 
 5ad:	c7 05 1c 09 00 00 1c 	movl   $0x91c,0x91c
 5b4:	09 00 00 
    base.s.size = 0;
 5b7:	c7 05 20 09 00 00 00 	movl   $0x0,0x920
 5be:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5c1:	b9 1c 09 00 00       	mov    $0x91c,%ecx
 5c6:	eb d7                	jmp    59f <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5c8:	74 19                	je     5e3 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ca:	29 da                	sub    %ebx,%edx
 5cc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5cf:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5d2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5d5:	89 0d 18 09 00 00    	mov    %ecx,0x918
      return (void*)(p + 1);
 5db:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e1:	c9                   	leave  
 5e2:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5e3:	8b 10                	mov    (%eax),%edx
 5e5:	89 11                	mov    %edx,(%ecx)
 5e7:	eb ec                	jmp    5d5 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e9:	89 c1                	mov    %eax,%ecx
 5eb:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5ed:	8b 50 04             	mov    0x4(%eax),%edx
 5f0:	39 da                	cmp    %ebx,%edx
 5f2:	73 d4                	jae    5c8 <malloc+0x46>
    if(p == freep)
 5f4:	39 05 18 09 00 00    	cmp    %eax,0x918
 5fa:	75 ed                	jne    5e9 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 5fc:	89 d8                	mov    %ebx,%eax
 5fe:	e8 2f ff ff ff       	call   532 <morecore>
 603:	85 c0                	test   %eax,%eax
 605:	75 e2                	jne    5e9 <malloc+0x67>
 607:	eb d5                	jmp    5de <malloc+0x5c>
