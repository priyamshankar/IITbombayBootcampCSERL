
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
  1f:	68 1c 06 00 00       	push   $0x61c
  24:	6a 01                	push   $0x1
  26:	e8 41 03 00 00       	call   36c <printf>
  if (ret == 0)
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	85 db                	test   %ebx,%ebx
  30:	75 14                	jne    46 <main+0x46>
  {
    printf(1, "In child\n");
  32:	83 ec 08             	sub    $0x8,%esp
  35:	68 24 06 00 00       	push   $0x624
  3a:	6a 01                	push   $0x1
  3c:	e8 2b 03 00 00       	call   36c <printf>

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
  4f:	68 2e 06 00 00       	push   $0x62e
  54:	6a 01                	push   $0x1
  56:	e8 11 03 00 00       	call   36c <printf>
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
 2bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 1c             	sub    $0x1c,%esp
 2cd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2d0:	6a 01                	push   $0x1
 2d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d5:	52                   	push   %edx
 2d6:	50                   	push   %eax
 2d7:	e8 43 ff ff ff       	call   21f <write>
}
 2dc:	83 c4 10             	add    $0x10,%esp
 2df:	c9                   	leave  
 2e0:	c3                   	ret    

000002e1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	57                   	push   %edi
 2e5:	56                   	push   %esi
 2e6:	53                   	push   %ebx
 2e7:	83 ec 2c             	sub    $0x2c,%esp
 2ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2ed:	89 d0                	mov    %edx,%eax
 2ef:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f5:	0f 95 c1             	setne  %cl
 2f8:	c1 ea 1f             	shr    $0x1f,%edx
 2fb:	84 d1                	test   %dl,%cl
 2fd:	74 44                	je     343 <printint+0x62>
    neg = 1;
    x = -xx;
 2ff:	f7 d8                	neg    %eax
 301:	89 c1                	mov    %eax,%ecx
    neg = 1;
 303:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 30a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 30f:	89 c8                	mov    %ecx,%eax
 311:	ba 00 00 00 00       	mov    $0x0,%edx
 316:	f7 f6                	div    %esi
 318:	89 df                	mov    %ebx,%edi
 31a:	83 c3 01             	add    $0x1,%ebx
 31d:	0f b6 92 a8 06 00 00 	movzbl 0x6a8(%edx),%edx
 324:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 328:	89 ca                	mov    %ecx,%edx
 32a:	89 c1                	mov    %eax,%ecx
 32c:	39 d6                	cmp    %edx,%esi
 32e:	76 df                	jbe    30f <printint+0x2e>
  if(neg)
 330:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 334:	74 31                	je     367 <printint+0x86>
    buf[i++] = '-';
 336:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33b:	8d 5f 02             	lea    0x2(%edi),%ebx
 33e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 341:	eb 17                	jmp    35a <printint+0x79>
    x = xx;
 343:	89 c1                	mov    %eax,%ecx
  neg = 0;
 345:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 34c:	eb bc                	jmp    30a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 34e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 353:	89 f0                	mov    %esi,%eax
 355:	e8 6d ff ff ff       	call   2c7 <putc>
  while(--i >= 0)
 35a:	83 eb 01             	sub    $0x1,%ebx
 35d:	79 ef                	jns    34e <printint+0x6d>
}
 35f:	83 c4 2c             	add    $0x2c,%esp
 362:	5b                   	pop    %ebx
 363:	5e                   	pop    %esi
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	8b 75 d0             	mov    -0x30(%ebp),%esi
 36a:	eb ee                	jmp    35a <printint+0x79>

0000036c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	57                   	push   %edi
 370:	56                   	push   %esi
 371:	53                   	push   %ebx
 372:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 375:	8d 45 10             	lea    0x10(%ebp),%eax
 378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 37b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 380:	bb 00 00 00 00       	mov    $0x0,%ebx
 385:	eb 14                	jmp    39b <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 387:	89 fa                	mov    %edi,%edx
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	e8 36 ff ff ff       	call   2c7 <putc>
 391:	eb 05                	jmp    398 <printf+0x2c>
      }
    } else if(state == '%'){
 393:	83 fe 25             	cmp    $0x25,%esi
 396:	74 25                	je     3bd <printf+0x51>
  for(i = 0; fmt[i]; i++){
 398:	83 c3 01             	add    $0x1,%ebx
 39b:	8b 45 0c             	mov    0xc(%ebp),%eax
 39e:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3a2:	84 c0                	test   %al,%al
 3a4:	0f 84 20 01 00 00    	je     4ca <printf+0x15e>
    c = fmt[i] & 0xff;
 3aa:	0f be f8             	movsbl %al,%edi
 3ad:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3b0:	85 f6                	test   %esi,%esi
 3b2:	75 df                	jne    393 <printf+0x27>
      if(c == '%'){
 3b4:	83 f8 25             	cmp    $0x25,%eax
 3b7:	75 ce                	jne    387 <printf+0x1b>
        state = '%';
 3b9:	89 c6                	mov    %eax,%esi
 3bb:	eb db                	jmp    398 <printf+0x2c>
      if(c == 'd'){
 3bd:	83 f8 25             	cmp    $0x25,%eax
 3c0:	0f 84 cf 00 00 00    	je     495 <printf+0x129>
 3c6:	0f 8c dd 00 00 00    	jl     4a9 <printf+0x13d>
 3cc:	83 f8 78             	cmp    $0x78,%eax
 3cf:	0f 8f d4 00 00 00    	jg     4a9 <printf+0x13d>
 3d5:	83 f8 63             	cmp    $0x63,%eax
 3d8:	0f 8c cb 00 00 00    	jl     4a9 <printf+0x13d>
 3de:	83 e8 63             	sub    $0x63,%eax
 3e1:	83 f8 15             	cmp    $0x15,%eax
 3e4:	0f 87 bf 00 00 00    	ja     4a9 <printf+0x13d>
 3ea:	ff 24 85 50 06 00 00 	jmp    *0x650(,%eax,4)
        printint(fd, *ap, 10, 1);
 3f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f4:	8b 17                	mov    (%edi),%edx
 3f6:	83 ec 0c             	sub    $0xc,%esp
 3f9:	6a 01                	push   $0x1
 3fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	e8 d9 fe ff ff       	call   2e1 <printint>
        ap++;
 408:	83 c7 04             	add    $0x4,%edi
 40b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 40e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 411:	be 00 00 00 00       	mov    $0x0,%esi
 416:	eb 80                	jmp    398 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41b:	8b 17                	mov    (%edi),%edx
 41d:	83 ec 0c             	sub    $0xc,%esp
 420:	6a 00                	push   $0x0
 422:	b9 10 00 00 00       	mov    $0x10,%ecx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	e8 b2 fe ff ff       	call   2e1 <printint>
        ap++;
 42f:	83 c7 04             	add    $0x4,%edi
 432:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 435:	83 c4 10             	add    $0x10,%esp
      state = 0;
 438:	be 00 00 00 00       	mov    $0x0,%esi
 43d:	e9 56 ff ff ff       	jmp    398 <printf+0x2c>
        s = (char*)*ap;
 442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 445:	8b 30                	mov    (%eax),%esi
        ap++;
 447:	83 c0 04             	add    $0x4,%eax
 44a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 44d:	85 f6                	test   %esi,%esi
 44f:	75 15                	jne    466 <printf+0xfa>
          s = "(null)";
 451:	be 48 06 00 00       	mov    $0x648,%esi
 456:	eb 0e                	jmp    466 <printf+0xfa>
          putc(fd, *s);
 458:	0f be d2             	movsbl %dl,%edx
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	e8 64 fe ff ff       	call   2c7 <putc>
          s++;
 463:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 466:	0f b6 16             	movzbl (%esi),%edx
 469:	84 d2                	test   %dl,%dl
 46b:	75 eb                	jne    458 <printf+0xec>
      state = 0;
 46d:	be 00 00 00 00       	mov    $0x0,%esi
 472:	e9 21 ff ff ff       	jmp    398 <printf+0x2c>
        putc(fd, *ap);
 477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47a:	0f be 17             	movsbl (%edi),%edx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 42 fe ff ff       	call   2c7 <putc>
        ap++;
 485:	83 c7 04             	add    $0x4,%edi
 488:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 48b:	be 00 00 00 00       	mov    $0x0,%esi
 490:	e9 03 ff ff ff       	jmp    398 <printf+0x2c>
        putc(fd, c);
 495:	89 fa                	mov    %edi,%edx
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	e8 28 fe ff ff       	call   2c7 <putc>
      state = 0;
 49f:	be 00 00 00 00       	mov    $0x0,%esi
 4a4:	e9 ef fe ff ff       	jmp    398 <printf+0x2c>
        putc(fd, '%');
 4a9:	ba 25 00 00 00       	mov    $0x25,%edx
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
 4b1:	e8 11 fe ff ff       	call   2c7 <putc>
        putc(fd, c);
 4b6:	89 fa                	mov    %edi,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	e8 07 fe ff ff       	call   2c7 <putc>
      state = 0;
 4c0:	be 00 00 00 00       	mov    $0x0,%esi
 4c5:	e9 ce fe ff ff       	jmp    398 <printf+0x2c>
    }
  }
}
 4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5f                   	pop    %edi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    

000004d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	57                   	push   %edi
 4d6:	56                   	push   %esi
 4d7:	53                   	push   %ebx
 4d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4db:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4de:	a1 4c 09 00 00       	mov    0x94c,%eax
 4e3:	eb 02                	jmp    4e7 <free+0x15>
 4e5:	89 d0                	mov    %edx,%eax
 4e7:	39 c8                	cmp    %ecx,%eax
 4e9:	73 04                	jae    4ef <free+0x1d>
 4eb:	39 08                	cmp    %ecx,(%eax)
 4ed:	77 12                	ja     501 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ef:	8b 10                	mov    (%eax),%edx
 4f1:	39 c2                	cmp    %eax,%edx
 4f3:	77 f0                	ja     4e5 <free+0x13>
 4f5:	39 c8                	cmp    %ecx,%eax
 4f7:	72 08                	jb     501 <free+0x2f>
 4f9:	39 ca                	cmp    %ecx,%edx
 4fb:	77 04                	ja     501 <free+0x2f>
 4fd:	89 d0                	mov    %edx,%eax
 4ff:	eb e6                	jmp    4e7 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 501:	8b 73 fc             	mov    -0x4(%ebx),%esi
 504:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 507:	8b 10                	mov    (%eax),%edx
 509:	39 d7                	cmp    %edx,%edi
 50b:	74 19                	je     526 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 50d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 510:	8b 50 04             	mov    0x4(%eax),%edx
 513:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 516:	39 ce                	cmp    %ecx,%esi
 518:	74 1b                	je     535 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 51a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 51c:	a3 4c 09 00 00       	mov    %eax,0x94c
}
 521:	5b                   	pop    %ebx
 522:	5e                   	pop    %esi
 523:	5f                   	pop    %edi
 524:	5d                   	pop    %ebp
 525:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 526:	03 72 04             	add    0x4(%edx),%esi
 529:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 52c:	8b 10                	mov    (%eax),%edx
 52e:	8b 12                	mov    (%edx),%edx
 530:	89 53 f8             	mov    %edx,-0x8(%ebx)
 533:	eb db                	jmp    510 <free+0x3e>
    p->s.size += bp->s.size;
 535:	03 53 fc             	add    -0x4(%ebx),%edx
 538:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 53b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 53e:	89 10                	mov    %edx,(%eax)
 540:	eb da                	jmp    51c <free+0x4a>

00000542 <morecore>:

static Header*
morecore(uint nu)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	53                   	push   %ebx
 546:	83 ec 04             	sub    $0x4,%esp
 549:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 54b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 550:	77 05                	ja     557 <morecore+0x15>
    nu = 4096;
 552:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 557:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 55e:	83 ec 0c             	sub    $0xc,%esp
 561:	50                   	push   %eax
 562:	e8 20 fd ff ff       	call   287 <sbrk>
  if(p == (char*)-1)
 567:	83 c4 10             	add    $0x10,%esp
 56a:	83 f8 ff             	cmp    $0xffffffff,%eax
 56d:	74 1c                	je     58b <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 56f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 572:	83 c0 08             	add    $0x8,%eax
 575:	83 ec 0c             	sub    $0xc,%esp
 578:	50                   	push   %eax
 579:	e8 54 ff ff ff       	call   4d2 <free>
  return freep;
 57e:	a1 4c 09 00 00       	mov    0x94c,%eax
 583:	83 c4 10             	add    $0x10,%esp
}
 586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 589:	c9                   	leave  
 58a:	c3                   	ret    
    return 0;
 58b:	b8 00 00 00 00       	mov    $0x0,%eax
 590:	eb f4                	jmp    586 <morecore+0x44>

00000592 <malloc>:

void*
malloc(uint nbytes)
{
 592:	55                   	push   %ebp
 593:	89 e5                	mov    %esp,%ebp
 595:	53                   	push   %ebx
 596:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	8d 58 07             	lea    0x7(%eax),%ebx
 59f:	c1 eb 03             	shr    $0x3,%ebx
 5a2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a5:	8b 0d 4c 09 00 00    	mov    0x94c,%ecx
 5ab:	85 c9                	test   %ecx,%ecx
 5ad:	74 04                	je     5b3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5af:	8b 01                	mov    (%ecx),%eax
 5b1:	eb 4a                	jmp    5fd <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5b3:	c7 05 4c 09 00 00 50 	movl   $0x950,0x94c
 5ba:	09 00 00 
 5bd:	c7 05 50 09 00 00 50 	movl   $0x950,0x950
 5c4:	09 00 00 
    base.s.size = 0;
 5c7:	c7 05 54 09 00 00 00 	movl   $0x0,0x954
 5ce:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5d1:	b9 50 09 00 00       	mov    $0x950,%ecx
 5d6:	eb d7                	jmp    5af <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d8:	74 19                	je     5f3 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5da:	29 da                	sub    %ebx,%edx
 5dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5df:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5e2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e5:	89 0d 4c 09 00 00    	mov    %ecx,0x94c
      return (void*)(p + 1);
 5eb:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f1:	c9                   	leave  
 5f2:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f3:	8b 10                	mov    (%eax),%edx
 5f5:	89 11                	mov    %edx,(%ecx)
 5f7:	eb ec                	jmp    5e5 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f9:	89 c1                	mov    %eax,%ecx
 5fb:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fd:	8b 50 04             	mov    0x4(%eax),%edx
 600:	39 da                	cmp    %ebx,%edx
 602:	73 d4                	jae    5d8 <malloc+0x46>
    if(p == freep)
 604:	39 05 4c 09 00 00    	cmp    %eax,0x94c
 60a:	75 ed                	jne    5f9 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 60c:	89 d8                	mov    %ebx,%eax
 60e:	e8 2f ff ff ff       	call   542 <morecore>
 613:	85 c0                	test   %eax,%eax
 615:	75 e2                	jne    5f9 <malloc+0x67>
 617:	eb d5                	jmp    5ee <malloc+0x5c>
