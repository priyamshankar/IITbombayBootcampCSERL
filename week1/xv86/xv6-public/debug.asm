
_debug:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx

  int ret = fork();
   f:	e8 e3 01 00 00       	call   1f7 <fork>
  14:	89 c3                	mov    %eax,%ebx
  int st = getpid();
  16:	e8 64 02 00 00       	call   27f <getpid>
  printf(1, "pid =%d", st);
  1b:	83 ec 04             	sub    $0x4,%esp
  1e:	50                   	push   %eax
  1f:	68 2c 06 00 00       	push   $0x62c
  24:	6a 01                	push   $0x1
  26:	e8 51 03 00 00       	call   37c <printf>
  if (ret == 0)
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	85 db                	test   %ebx,%ebx
  30:	75 14                	jne    46 <main+0x46>
  {
    printf(1, "In child\n");
  32:	83 ec 08             	sub    $0x8,%esp
  35:	68 34 06 00 00       	push   $0x634
  3a:	6a 01                	push   $0x1
  3c:	e8 3b 03 00 00       	call   37c <printf>

    exit();
  41:	e8 b9 01 00 00       	call   1ff <exit>
  }
  else
  {
    int reaped_pid = wait();
  46:	e8 bc 01 00 00       	call   207 <wait>
    printf(1, "Child with pid %d reaped\n", reaped_pid);
  4b:	83 ec 04             	sub    $0x4,%esp
  4e:	50                   	push   %eax
  4f:	68 3e 06 00 00       	push   $0x63e
  54:	6a 01                	push   $0x1
  56:	e8 21 03 00 00       	call   37c <printf>
  }

  exit();
  5b:	e8 9f 01 00 00       	call   1ff <exit>

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6b:	89 f0                	mov    %esi,%eax
  6d:	89 d1                	mov    %edx,%ecx
  6f:	83 c2 01             	add    $0x1,%edx
  72:	89 c3                	mov    %eax,%ebx
  74:	83 c0 01             	add    $0x1,%eax
  77:	0f b6 09             	movzbl (%ecx),%ecx
  7a:	88 0b                	mov    %cl,(%ebx)
  7c:	84 c9                	test   %cl,%cl
  7e:	75 ed                	jne    6d <strcpy+0xd>
    ;
  return os;
}
  80:	89 f0                	mov    %esi,%eax
  82:	5b                   	pop    %ebx
  83:	5e                   	pop    %esi
  84:	5d                   	pop    %ebp
  85:	c3                   	ret    

00000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8f:	eb 06                	jmp    97 <strcmp+0x11>
    p++, q++;
  91:	83 c1 01             	add    $0x1,%ecx
  94:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  97:	0f b6 01             	movzbl (%ecx),%eax
  9a:	84 c0                	test   %al,%al
  9c:	74 04                	je     a2 <strcmp+0x1c>
  9e:	3a 02                	cmp    (%edx),%al
  a0:	74 ef                	je     91 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  a2:	0f b6 c0             	movzbl %al,%eax
  a5:	0f b6 12             	movzbl (%edx),%edx
  a8:	29 d0                	sub    %edx,%eax
}
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b2:	b8 00 00 00 00       	mov    $0x0,%eax
  b7:	eb 03                	jmp    bc <strlen+0x10>
  b9:	83 c0 01             	add    $0x1,%eax
  bc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c0:	75 f7                	jne    b9 <strlen+0xd>
    ;
  return n;
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  cb:	89 d7                	mov    %edx,%edi
  cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  d3:	fc                   	cld    
  d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d6:	89 d0                	mov    %edx,%eax
  d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  db:	c9                   	leave  
  dc:	c3                   	ret    

000000dd <strchr>:

char*
strchr(const char *s, char c)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e7:	eb 03                	jmp    ec <strchr+0xf>
  e9:	83 c0 01             	add    $0x1,%eax
  ec:	0f b6 10             	movzbl (%eax),%edx
  ef:	84 d2                	test   %dl,%dl
  f1:	74 06                	je     f9 <strchr+0x1c>
    if(*s == c)
  f3:	38 ca                	cmp    %cl,%dl
  f5:	75 f2                	jne    e9 <strchr+0xc>
  f7:	eb 05                	jmp    fe <strchr+0x21>
      return (char*)s;
  return 0;
  f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 1c             	sub    $0x1c,%esp
 109:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10c:	bb 00 00 00 00       	mov    $0x0,%ebx
 111:	89 de                	mov    %ebx,%esi
 113:	83 c3 01             	add    $0x1,%ebx
 116:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 119:	7d 2e                	jge    149 <gets+0x49>
    cc = read(0, &c, 1);
 11b:	83 ec 04             	sub    $0x4,%esp
 11e:	6a 01                	push   $0x1
 120:	8d 45 e7             	lea    -0x19(%ebp),%eax
 123:	50                   	push   %eax
 124:	6a 00                	push   $0x0
 126:	e8 ec 00 00 00       	call   217 <read>
    if(cc < 1)
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	85 c0                	test   %eax,%eax
 130:	7e 17                	jle    149 <gets+0x49>
      break;
    buf[i++] = c;
 132:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 136:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 139:	3c 0a                	cmp    $0xa,%al
 13b:	0f 94 c2             	sete   %dl
 13e:	3c 0d                	cmp    $0xd,%al
 140:	0f 94 c0             	sete   %al
 143:	08 c2                	or     %al,%dl
 145:	74 ca                	je     111 <gets+0x11>
    buf[i++] = c;
 147:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 149:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 14d:	89 f8                	mov    %edi,%eax
 14f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 152:	5b                   	pop    %ebx
 153:	5e                   	pop    %esi
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <stat>:

int
stat(const char *n, struct stat *st)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	56                   	push   %esi
 15b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	6a 00                	push   $0x0
 161:	ff 75 08             	push   0x8(%ebp)
 164:	e8 d6 00 00 00       	call   23f <open>
  if(fd < 0)
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	78 24                	js     194 <stat+0x3d>
 170:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 172:	83 ec 08             	sub    $0x8,%esp
 175:	ff 75 0c             	push   0xc(%ebp)
 178:	50                   	push   %eax
 179:	e8 d9 00 00 00       	call   257 <fstat>
 17e:	89 c6                	mov    %eax,%esi
  close(fd);
 180:	89 1c 24             	mov    %ebx,(%esp)
 183:	e8 9f 00 00 00       	call   227 <close>
  return r;
 188:	83 c4 10             	add    $0x10,%esp
}
 18b:	89 f0                	mov    %esi,%eax
 18d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
    return -1;
 194:	be ff ff ff ff       	mov    $0xffffffff,%esi
 199:	eb f0                	jmp    18b <stat+0x34>

0000019b <atoi>:

int
atoi(const char *s)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	53                   	push   %ebx
 19f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1a2:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a7:	eb 10                	jmp    1b9 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a9:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1ac:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1af:	83 c1 01             	add    $0x1,%ecx
 1b2:	0f be c0             	movsbl %al,%eax
 1b5:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b9:	0f b6 01             	movzbl (%ecx),%eax
 1bc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bf:	80 fb 09             	cmp    $0x9,%bl
 1c2:	76 e5                	jbe    1a9 <atoi+0xe>
  return n;
}
 1c4:	89 d0                	mov    %edx,%eax
 1c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1db:	eb 0d                	jmp    1ea <memmove+0x1f>
    *dst++ = *src++;
 1dd:	0f b6 01             	movzbl (%ecx),%eax
 1e0:	88 02                	mov    %al,(%edx)
 1e2:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e5:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e8:	89 d8                	mov    %ebx,%eax
 1ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1ed:	85 c0                	test   %eax,%eax
 1ef:	7f ec                	jg     1dd <memmove+0x12>
  return vdst;
}
 1f1:	89 f0                	mov    %esi,%eax
 1f3:	5b                   	pop    %ebx
 1f4:	5e                   	pop    %esi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f7:	b8 01 00 00 00       	mov    $0x1,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <exit>:
SYSCALL(exit)
 1ff:	b8 02 00 00 00       	mov    $0x2,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <wait>:
SYSCALL(wait)
 207:	b8 03 00 00 00       	mov    $0x3,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <pipe>:
SYSCALL(pipe)
 20f:	b8 04 00 00 00       	mov    $0x4,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <read>:
SYSCALL(read)
 217:	b8 05 00 00 00       	mov    $0x5,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <write>:
SYSCALL(write)
 21f:	b8 10 00 00 00       	mov    $0x10,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <close>:
SYSCALL(close)
 227:	b8 15 00 00 00       	mov    $0x15,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <kill>:
SYSCALL(kill)
 22f:	b8 06 00 00 00       	mov    $0x6,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <exec>:
SYSCALL(exec)
 237:	b8 07 00 00 00       	mov    $0x7,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <open>:
SYSCALL(open)
 23f:	b8 0f 00 00 00       	mov    $0xf,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <mknod>:
SYSCALL(mknod)
 247:	b8 11 00 00 00       	mov    $0x11,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <unlink>:
SYSCALL(unlink)
 24f:	b8 12 00 00 00       	mov    $0x12,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <fstat>:
SYSCALL(fstat)
 257:	b8 08 00 00 00       	mov    $0x8,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <link>:
SYSCALL(link)
 25f:	b8 13 00 00 00       	mov    $0x13,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mkdir>:
SYSCALL(mkdir)
 267:	b8 14 00 00 00       	mov    $0x14,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <chdir>:
SYSCALL(chdir)
 26f:	b8 09 00 00 00       	mov    $0x9,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <dup>:
SYSCALL(dup)
 277:	b8 0a 00 00 00       	mov    $0xa,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <getpid>:
SYSCALL(getpid)
 27f:	b8 0b 00 00 00       	mov    $0xb,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <sbrk>:
SYSCALL(sbrk)
 287:	b8 0c 00 00 00       	mov    $0xc,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <sleep>:
SYSCALL(sleep)
 28f:	b8 0d 00 00 00       	mov    $0xd,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <uptime>:
SYSCALL(uptime)
 297:	b8 0e 00 00 00       	mov    $0xe,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <hello>:
SYSCALL(hello)
 29f:	b8 16 00 00 00       	mov    $0x16,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <helloYou>:
SYSCALL(helloYou)
 2a7:	b8 17 00 00 00       	mov    $0x17,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <getppid>:
SYSCALL(getppid)
 2af:	b8 18 00 00 00       	mov    $0x18,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b7:	b8 19 00 00 00       	mov    $0x19,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <signalProcess>:
SYSCALL(signalProcess)
 2bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <numvp>:
SYSCALL(numvp)
 2c7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <numpp>:
 2cf:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 1c             	sub    $0x1c,%esp
 2dd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2e0:	6a 01                	push   $0x1
 2e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e5:	52                   	push   %edx
 2e6:	50                   	push   %eax
 2e7:	e8 33 ff ff ff       	call   21f <write>
}
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	57                   	push   %edi
 2f5:	56                   	push   %esi
 2f6:	53                   	push   %ebx
 2f7:	83 ec 2c             	sub    $0x2c,%esp
 2fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 305:	0f 95 c1             	setne  %cl
 308:	c1 ea 1f             	shr    $0x1f,%edx
 30b:	84 d1                	test   %dl,%cl
 30d:	74 44                	je     353 <printint+0x62>
    neg = 1;
    x = -xx;
 30f:	f7 d8                	neg    %eax
 311:	89 c1                	mov    %eax,%ecx
    neg = 1;
 313:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 31a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 31f:	89 c8                	mov    %ecx,%eax
 321:	ba 00 00 00 00       	mov    $0x0,%edx
 326:	f7 f6                	div    %esi
 328:	89 df                	mov    %ebx,%edi
 32a:	83 c3 01             	add    $0x1,%ebx
 32d:	0f b6 92 b8 06 00 00 	movzbl 0x6b8(%edx),%edx
 334:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 338:	89 ca                	mov    %ecx,%edx
 33a:	89 c1                	mov    %eax,%ecx
 33c:	39 d6                	cmp    %edx,%esi
 33e:	76 df                	jbe    31f <printint+0x2e>
  if(neg)
 340:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 344:	74 31                	je     377 <printint+0x86>
    buf[i++] = '-';
 346:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 34b:	8d 5f 02             	lea    0x2(%edi),%ebx
 34e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 351:	eb 17                	jmp    36a <printint+0x79>
    x = xx;
 353:	89 c1                	mov    %eax,%ecx
  neg = 0;
 355:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 35c:	eb bc                	jmp    31a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 35e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 363:	89 f0                	mov    %esi,%eax
 365:	e8 6d ff ff ff       	call   2d7 <putc>
  while(--i >= 0)
 36a:	83 eb 01             	sub    $0x1,%ebx
 36d:	79 ef                	jns    35e <printint+0x6d>
}
 36f:	83 c4 2c             	add    $0x2c,%esp
 372:	5b                   	pop    %ebx
 373:	5e                   	pop    %esi
 374:	5f                   	pop    %edi
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    
 377:	8b 75 d0             	mov    -0x30(%ebp),%esi
 37a:	eb ee                	jmp    36a <printint+0x79>

0000037c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	57                   	push   %edi
 380:	56                   	push   %esi
 381:	53                   	push   %ebx
 382:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 385:	8d 45 10             	lea    0x10(%ebp),%eax
 388:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 38b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 390:	bb 00 00 00 00       	mov    $0x0,%ebx
 395:	eb 14                	jmp    3ab <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 397:	89 fa                	mov    %edi,%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	e8 36 ff ff ff       	call   2d7 <putc>
 3a1:	eb 05                	jmp    3a8 <printf+0x2c>
      }
    } else if(state == '%'){
 3a3:	83 fe 25             	cmp    $0x25,%esi
 3a6:	74 25                	je     3cd <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3a8:	83 c3 01             	add    $0x1,%ebx
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3b2:	84 c0                	test   %al,%al
 3b4:	0f 84 20 01 00 00    	je     4da <printf+0x15e>
    c = fmt[i] & 0xff;
 3ba:	0f be f8             	movsbl %al,%edi
 3bd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3c0:	85 f6                	test   %esi,%esi
 3c2:	75 df                	jne    3a3 <printf+0x27>
      if(c == '%'){
 3c4:	83 f8 25             	cmp    $0x25,%eax
 3c7:	75 ce                	jne    397 <printf+0x1b>
        state = '%';
 3c9:	89 c6                	mov    %eax,%esi
 3cb:	eb db                	jmp    3a8 <printf+0x2c>
      if(c == 'd'){
 3cd:	83 f8 25             	cmp    $0x25,%eax
 3d0:	0f 84 cf 00 00 00    	je     4a5 <printf+0x129>
 3d6:	0f 8c dd 00 00 00    	jl     4b9 <printf+0x13d>
 3dc:	83 f8 78             	cmp    $0x78,%eax
 3df:	0f 8f d4 00 00 00    	jg     4b9 <printf+0x13d>
 3e5:	83 f8 63             	cmp    $0x63,%eax
 3e8:	0f 8c cb 00 00 00    	jl     4b9 <printf+0x13d>
 3ee:	83 e8 63             	sub    $0x63,%eax
 3f1:	83 f8 15             	cmp    $0x15,%eax
 3f4:	0f 87 bf 00 00 00    	ja     4b9 <printf+0x13d>
 3fa:	ff 24 85 60 06 00 00 	jmp    *0x660(,%eax,4)
        printint(fd, *ap, 10, 1);
 401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 404:	8b 17                	mov    (%edi),%edx
 406:	83 ec 0c             	sub    $0xc,%esp
 409:	6a 01                	push   $0x1
 40b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	e8 d9 fe ff ff       	call   2f1 <printint>
        ap++;
 418:	83 c7 04             	add    $0x4,%edi
 41b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 421:	be 00 00 00 00       	mov    $0x0,%esi
 426:	eb 80                	jmp    3a8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42b:	8b 17                	mov    (%edi),%edx
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	6a 00                	push   $0x0
 432:	b9 10 00 00 00       	mov    $0x10,%ecx
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	e8 b2 fe ff ff       	call   2f1 <printint>
        ap++;
 43f:	83 c7 04             	add    $0x4,%edi
 442:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 445:	83 c4 10             	add    $0x10,%esp
      state = 0;
 448:	be 00 00 00 00       	mov    $0x0,%esi
 44d:	e9 56 ff ff ff       	jmp    3a8 <printf+0x2c>
        s = (char*)*ap;
 452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 455:	8b 30                	mov    (%eax),%esi
        ap++;
 457:	83 c0 04             	add    $0x4,%eax
 45a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45d:	85 f6                	test   %esi,%esi
 45f:	75 15                	jne    476 <printf+0xfa>
          s = "(null)";
 461:	be 58 06 00 00       	mov    $0x658,%esi
 466:	eb 0e                	jmp    476 <printf+0xfa>
          putc(fd, *s);
 468:	0f be d2             	movsbl %dl,%edx
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	e8 64 fe ff ff       	call   2d7 <putc>
          s++;
 473:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 476:	0f b6 16             	movzbl (%esi),%edx
 479:	84 d2                	test   %dl,%dl
 47b:	75 eb                	jne    468 <printf+0xec>
      state = 0;
 47d:	be 00 00 00 00       	mov    $0x0,%esi
 482:	e9 21 ff ff ff       	jmp    3a8 <printf+0x2c>
        putc(fd, *ap);
 487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48a:	0f be 17             	movsbl (%edi),%edx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	e8 42 fe ff ff       	call   2d7 <putc>
        ap++;
 495:	83 c7 04             	add    $0x4,%edi
 498:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 49b:	be 00 00 00 00       	mov    $0x0,%esi
 4a0:	e9 03 ff ff ff       	jmp    3a8 <printf+0x2c>
        putc(fd, c);
 4a5:	89 fa                	mov    %edi,%edx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	e8 28 fe ff ff       	call   2d7 <putc>
      state = 0;
 4af:	be 00 00 00 00       	mov    $0x0,%esi
 4b4:	e9 ef fe ff ff       	jmp    3a8 <printf+0x2c>
        putc(fd, '%');
 4b9:	ba 25 00 00 00       	mov    $0x25,%edx
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	e8 11 fe ff ff       	call   2d7 <putc>
        putc(fd, c);
 4c6:	89 fa                	mov    %edi,%edx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	e8 07 fe ff ff       	call   2d7 <putc>
      state = 0;
 4d0:	be 00 00 00 00       	mov    $0x0,%esi
 4d5:	e9 ce fe ff ff       	jmp    3a8 <printf+0x2c>
    }
  }
}
 4da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4dd:	5b                   	pop    %ebx
 4de:	5e                   	pop    %esi
 4df:	5f                   	pop    %edi
 4e0:	5d                   	pop    %ebp
 4e1:	c3                   	ret    

000004e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e2:	55                   	push   %ebp
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	57                   	push   %edi
 4e6:	56                   	push   %esi
 4e7:	53                   	push   %ebx
 4e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4eb:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ee:	a1 5c 09 00 00       	mov    0x95c,%eax
 4f3:	eb 02                	jmp    4f7 <free+0x15>
 4f5:	89 d0                	mov    %edx,%eax
 4f7:	39 c8                	cmp    %ecx,%eax
 4f9:	73 04                	jae    4ff <free+0x1d>
 4fb:	39 08                	cmp    %ecx,(%eax)
 4fd:	77 12                	ja     511 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ff:	8b 10                	mov    (%eax),%edx
 501:	39 c2                	cmp    %eax,%edx
 503:	77 f0                	ja     4f5 <free+0x13>
 505:	39 c8                	cmp    %ecx,%eax
 507:	72 08                	jb     511 <free+0x2f>
 509:	39 ca                	cmp    %ecx,%edx
 50b:	77 04                	ja     511 <free+0x2f>
 50d:	89 d0                	mov    %edx,%eax
 50f:	eb e6                	jmp    4f7 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 511:	8b 73 fc             	mov    -0x4(%ebx),%esi
 514:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 517:	8b 10                	mov    (%eax),%edx
 519:	39 d7                	cmp    %edx,%edi
 51b:	74 19                	je     536 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 51d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 520:	8b 50 04             	mov    0x4(%eax),%edx
 523:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 526:	39 ce                	cmp    %ecx,%esi
 528:	74 1b                	je     545 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 52a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 52c:	a3 5c 09 00 00       	mov    %eax,0x95c
}
 531:	5b                   	pop    %ebx
 532:	5e                   	pop    %esi
 533:	5f                   	pop    %edi
 534:	5d                   	pop    %ebp
 535:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 536:	03 72 04             	add    0x4(%edx),%esi
 539:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 53c:	8b 10                	mov    (%eax),%edx
 53e:	8b 12                	mov    (%edx),%edx
 540:	89 53 f8             	mov    %edx,-0x8(%ebx)
 543:	eb db                	jmp    520 <free+0x3e>
    p->s.size += bp->s.size;
 545:	03 53 fc             	add    -0x4(%ebx),%edx
 548:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 54b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 54e:	89 10                	mov    %edx,(%eax)
 550:	eb da                	jmp    52c <free+0x4a>

00000552 <morecore>:

static Header*
morecore(uint nu)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	53                   	push   %ebx
 556:	83 ec 04             	sub    $0x4,%esp
 559:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 55b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 560:	77 05                	ja     567 <morecore+0x15>
    nu = 4096;
 562:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 567:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 56e:	83 ec 0c             	sub    $0xc,%esp
 571:	50                   	push   %eax
 572:	e8 10 fd ff ff       	call   287 <sbrk>
  if(p == (char*)-1)
 577:	83 c4 10             	add    $0x10,%esp
 57a:	83 f8 ff             	cmp    $0xffffffff,%eax
 57d:	74 1c                	je     59b <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 57f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 582:	83 c0 08             	add    $0x8,%eax
 585:	83 ec 0c             	sub    $0xc,%esp
 588:	50                   	push   %eax
 589:	e8 54 ff ff ff       	call   4e2 <free>
  return freep;
 58e:	a1 5c 09 00 00       	mov    0x95c,%eax
 593:	83 c4 10             	add    $0x10,%esp
}
 596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 599:	c9                   	leave  
 59a:	c3                   	ret    
    return 0;
 59b:	b8 00 00 00 00       	mov    $0x0,%eax
 5a0:	eb f4                	jmp    596 <morecore+0x44>

000005a2 <malloc>:

void*
malloc(uint nbytes)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	53                   	push   %ebx
 5a6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	8d 58 07             	lea    0x7(%eax),%ebx
 5af:	c1 eb 03             	shr    $0x3,%ebx
 5b2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5b5:	8b 0d 5c 09 00 00    	mov    0x95c,%ecx
 5bb:	85 c9                	test   %ecx,%ecx
 5bd:	74 04                	je     5c3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5bf:	8b 01                	mov    (%ecx),%eax
 5c1:	eb 4a                	jmp    60d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5c3:	c7 05 5c 09 00 00 60 	movl   $0x960,0x95c
 5ca:	09 00 00 
 5cd:	c7 05 60 09 00 00 60 	movl   $0x960,0x960
 5d4:	09 00 00 
    base.s.size = 0;
 5d7:	c7 05 64 09 00 00 00 	movl   $0x0,0x964
 5de:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5e1:	b9 60 09 00 00       	mov    $0x960,%ecx
 5e6:	eb d7                	jmp    5bf <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5e8:	74 19                	je     603 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ea:	29 da                	sub    %ebx,%edx
 5ec:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5ef:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5f2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5f5:	89 0d 5c 09 00 00    	mov    %ecx,0x95c
      return (void*)(p + 1);
 5fb:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 601:	c9                   	leave  
 602:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 603:	8b 10                	mov    (%eax),%edx
 605:	89 11                	mov    %edx,(%ecx)
 607:	eb ec                	jmp    5f5 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 609:	89 c1                	mov    %eax,%ecx
 60b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 60d:	8b 50 04             	mov    0x4(%eax),%edx
 610:	39 da                	cmp    %ebx,%edx
 612:	73 d4                	jae    5e8 <malloc+0x46>
    if(p == freep)
 614:	39 05 5c 09 00 00    	cmp    %eax,0x95c
 61a:	75 ed                	jne    609 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 61c:	89 d8                	mov    %ebx,%eax
 61e:	e8 2f ff ff ff       	call   552 <morecore>
 623:	85 c0                	test   %eax,%eax
 625:	75 e2                	jne    609 <malloc+0x67>
 627:	eb d5                	jmp    5fe <malloc+0x5c>
