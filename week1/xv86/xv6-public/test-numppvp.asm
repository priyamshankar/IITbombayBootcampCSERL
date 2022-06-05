
_test-numppvp:     file format elf32-i386


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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  int vpages = numvp();
  13:	e8 cf 02 00 00       	call   2e7 <numvp>
  18:	89 c6                	mov    %eax,%esi
  int ppages = numpp();
  1a:	e8 d0 02 00 00       	call   2ef <numpp>
  1f:	89 c3                	mov    %eax,%ebx
  printf(1, "Total user virtual pages: %d \n", vpages);
  21:	83 ec 04             	sub    $0x4,%esp
  24:	56                   	push   %esi
  25:	68 4c 06 00 00       	push   $0x64c
  2a:	6a 01                	push   $0x1
  2c:	e8 6b 03 00 00       	call   39c <printf>
  printf(1, "Total user physical pages: %d \n", ppages);
  31:	83 c4 0c             	add    $0xc,%esp
  34:	53                   	push   %ebx
  35:	68 6c 06 00 00       	push   $0x66c
  3a:	6a 01                	push   $0x1
  3c:	e8 5b 03 00 00       	call   39c <printf>
  sbrk(8192);
  41:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
  48:	e8 5a 02 00 00       	call   2a7 <sbrk>
  int nvpages = numvp();
  4d:	e8 95 02 00 00       	call   2e7 <numvp>
  52:	89 c6                	mov    %eax,%esi
  int nppages = numpp();
  54:	e8 96 02 00 00       	call   2ef <numpp>
  59:	89 c3                	mov    %eax,%ebx
  printf(1, "Total user virtual pages now: %d \n", nvpages);
  5b:	83 c4 0c             	add    $0xc,%esp
  5e:	56                   	push   %esi
  5f:	68 8c 06 00 00       	push   $0x68c
  64:	6a 01                	push   $0x1
  66:	e8 31 03 00 00       	call   39c <printf>
  printf(1, "Total user physical pages now: %d \n", nppages);
  6b:	83 c4 0c             	add    $0xc,%esp
  6e:	53                   	push   %ebx
  6f:	68 b0 06 00 00       	push   $0x6b0
  74:	6a 01                	push   $0x1
  76:	e8 21 03 00 00       	call   39c <printf>
  exit();
  7b:	e8 9f 01 00 00       	call   21f <exit>

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	56                   	push   %esi
  84:	53                   	push   %ebx
  85:	8b 75 08             	mov    0x8(%ebp),%esi
  88:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8b:	89 f0                	mov    %esi,%eax
  8d:	89 d1                	mov    %edx,%ecx
  8f:	83 c2 01             	add    $0x1,%edx
  92:	89 c3                	mov    %eax,%ebx
  94:	83 c0 01             	add    $0x1,%eax
  97:	0f b6 09             	movzbl (%ecx),%ecx
  9a:	88 0b                	mov    %cl,(%ebx)
  9c:	84 c9                	test   %cl,%cl
  9e:	75 ed                	jne    8d <strcpy+0xd>
    ;
  return os;
}
  a0:	89 f0                	mov    %esi,%eax
  a2:	5b                   	pop    %ebx
  a3:	5e                   	pop    %esi
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    

000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  af:	eb 06                	jmp    b7 <strcmp+0x11>
    p++, q++;
  b1:	83 c1 01             	add    $0x1,%ecx
  b4:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b7:	0f b6 01             	movzbl (%ecx),%eax
  ba:	84 c0                	test   %al,%al
  bc:	74 04                	je     c2 <strcmp+0x1c>
  be:	3a 02                	cmp    (%edx),%al
  c0:	74 ef                	je     b1 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  c2:	0f b6 c0             	movzbl %al,%eax
  c5:	0f b6 12             	movzbl (%edx),%edx
  c8:	29 d0                	sub    %edx,%eax
}
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d2:	b8 00 00 00 00       	mov    $0x0,%eax
  d7:	eb 03                	jmp    dc <strlen+0x10>
  d9:	83 c0 01             	add    $0x1,%eax
  dc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  e0:	75 f7                	jne    d9 <strlen+0xd>
    ;
  return n;
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
  e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  eb:	89 d7                	mov    %edx,%edi
  ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	fc                   	cld    
  f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f6:	89 d0                	mov    %edx,%eax
  f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <strchr>:

char*
strchr(const char *s, char c)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 107:	eb 03                	jmp    10c <strchr+0xf>
 109:	83 c0 01             	add    $0x1,%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	84 d2                	test   %dl,%dl
 111:	74 06                	je     119 <strchr+0x1c>
    if(*s == c)
 113:	38 ca                	cmp    %cl,%dl
 115:	75 f2                	jne    109 <strchr+0xc>
 117:	eb 05                	jmp    11e <strchr+0x21>
      return (char*)s;
  return 0;
 119:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
 125:	53                   	push   %ebx
 126:	83 ec 1c             	sub    $0x1c,%esp
 129:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	bb 00 00 00 00       	mov    $0x0,%ebx
 131:	89 de                	mov    %ebx,%esi
 133:	83 c3 01             	add    $0x1,%ebx
 136:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 139:	7d 2e                	jge    169 <gets+0x49>
    cc = read(0, &c, 1);
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	6a 01                	push   $0x1
 140:	8d 45 e7             	lea    -0x19(%ebp),%eax
 143:	50                   	push   %eax
 144:	6a 00                	push   $0x0
 146:	e8 ec 00 00 00       	call   237 <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 17                	jle    169 <gets+0x49>
      break;
    buf[i++] = c;
 152:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 156:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 159:	3c 0a                	cmp    $0xa,%al
 15b:	0f 94 c2             	sete   %dl
 15e:	3c 0d                	cmp    $0xd,%al
 160:	0f 94 c0             	sete   %al
 163:	08 c2                	or     %al,%dl
 165:	74 ca                	je     131 <gets+0x11>
    buf[i++] = c;
 167:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 169:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 16d:	89 f8                	mov    %edi,%eax
 16f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 172:	5b                   	pop    %ebx
 173:	5e                   	pop    %esi
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    

00000177 <stat>:

int
stat(const char *n, struct stat *st)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
 17a:	56                   	push   %esi
 17b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	6a 00                	push   $0x0
 181:	ff 75 08             	push   0x8(%ebp)
 184:	e8 d6 00 00 00       	call   25f <open>
  if(fd < 0)
 189:	83 c4 10             	add    $0x10,%esp
 18c:	85 c0                	test   %eax,%eax
 18e:	78 24                	js     1b4 <stat+0x3d>
 190:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 192:	83 ec 08             	sub    $0x8,%esp
 195:	ff 75 0c             	push   0xc(%ebp)
 198:	50                   	push   %eax
 199:	e8 d9 00 00 00       	call   277 <fstat>
 19e:	89 c6                	mov    %eax,%esi
  close(fd);
 1a0:	89 1c 24             	mov    %ebx,(%esp)
 1a3:	e8 9f 00 00 00       	call   247 <close>
  return r;
 1a8:	83 c4 10             	add    $0x10,%esp
}
 1ab:	89 f0                	mov    %esi,%eax
 1ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
    return -1;
 1b4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b9:	eb f0                	jmp    1ab <stat+0x34>

000001bb <atoi>:

int
atoi(const char *s)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	53                   	push   %ebx
 1bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1c2:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c7:	eb 10                	jmp    1d9 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1c9:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1cc:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1cf:	83 c1 01             	add    $0x1,%ecx
 1d2:	0f be c0             	movsbl %al,%eax
 1d5:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1d9:	0f b6 01             	movzbl (%ecx),%eax
 1dc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1df:	80 fb 09             	cmp    $0x9,%bl
 1e2:	76 e5                	jbe    1c9 <atoi+0xe>
  return n;
}
 1e4:	89 d0                	mov    %edx,%eax
 1e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	8b 75 08             	mov    0x8(%ebp),%esi
 1f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1fb:	eb 0d                	jmp    20a <memmove+0x1f>
    *dst++ = *src++;
 1fd:	0f b6 01             	movzbl (%ecx),%eax
 200:	88 02                	mov    %al,(%edx)
 202:	8d 49 01             	lea    0x1(%ecx),%ecx
 205:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 208:	89 d8                	mov    %ebx,%eax
 20a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 20d:	85 c0                	test   %eax,%eax
 20f:	7f ec                	jg     1fd <memmove+0x12>
  return vdst;
}
 211:	89 f0                	mov    %esi,%eax
 213:	5b                   	pop    %ebx
 214:	5e                   	pop    %esi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    

00000217 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <exit>:
SYSCALL(exit)
 21f:	b8 02 00 00 00       	mov    $0x2,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <wait>:
SYSCALL(wait)
 227:	b8 03 00 00 00       	mov    $0x3,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <pipe>:
SYSCALL(pipe)
 22f:	b8 04 00 00 00       	mov    $0x4,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <read>:
SYSCALL(read)
 237:	b8 05 00 00 00       	mov    $0x5,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <write>:
SYSCALL(write)
 23f:	b8 10 00 00 00       	mov    $0x10,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <close>:
SYSCALL(close)
 247:	b8 15 00 00 00       	mov    $0x15,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <kill>:
SYSCALL(kill)
 24f:	b8 06 00 00 00       	mov    $0x6,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <exec>:
SYSCALL(exec)
 257:	b8 07 00 00 00       	mov    $0x7,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <open>:
SYSCALL(open)
 25f:	b8 0f 00 00 00       	mov    $0xf,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mknod>:
SYSCALL(mknod)
 267:	b8 11 00 00 00       	mov    $0x11,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <unlink>:
SYSCALL(unlink)
 26f:	b8 12 00 00 00       	mov    $0x12,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <fstat>:
SYSCALL(fstat)
 277:	b8 08 00 00 00       	mov    $0x8,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <link>:
SYSCALL(link)
 27f:	b8 13 00 00 00       	mov    $0x13,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <mkdir>:
SYSCALL(mkdir)
 287:	b8 14 00 00 00       	mov    $0x14,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <chdir>:
SYSCALL(chdir)
 28f:	b8 09 00 00 00       	mov    $0x9,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <dup>:
SYSCALL(dup)
 297:	b8 0a 00 00 00       	mov    $0xa,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <getpid>:
SYSCALL(getpid)
 29f:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <sbrk>:
SYSCALL(sbrk)
 2a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <sleep>:
SYSCALL(sleep)
 2af:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <uptime>:
SYSCALL(uptime)
 2b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <hello>:
SYSCALL(hello)
 2bf:	b8 16 00 00 00       	mov    $0x16,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <helloYou>:
SYSCALL(helloYou)
 2c7:	b8 17 00 00 00       	mov    $0x17,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <getppid>:
SYSCALL(getppid)
 2cf:	b8 18 00 00 00       	mov    $0x18,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2d7:	b8 19 00 00 00       	mov    $0x19,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <signalProcess>:
SYSCALL(signalProcess)
 2df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <numvp>:
SYSCALL(numvp)
 2e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <numpp>:
 2ef:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp
 2fa:	83 ec 1c             	sub    $0x1c,%esp
 2fd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 300:	6a 01                	push   $0x1
 302:	8d 55 f4             	lea    -0xc(%ebp),%edx
 305:	52                   	push   %edx
 306:	50                   	push   %eax
 307:	e8 33 ff ff ff       	call   23f <write>
}
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	57                   	push   %edi
 315:	56                   	push   %esi
 316:	53                   	push   %ebx
 317:	83 ec 2c             	sub    $0x2c,%esp
 31a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 31d:	89 d0                	mov    %edx,%eax
 31f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 325:	0f 95 c1             	setne  %cl
 328:	c1 ea 1f             	shr    $0x1f,%edx
 32b:	84 d1                	test   %dl,%cl
 32d:	74 44                	je     373 <printint+0x62>
    neg = 1;
    x = -xx;
 32f:	f7 d8                	neg    %eax
 331:	89 c1                	mov    %eax,%ecx
    neg = 1;
 333:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 33a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 33f:	89 c8                	mov    %ecx,%eax
 341:	ba 00 00 00 00       	mov    $0x0,%edx
 346:	f7 f6                	div    %esi
 348:	89 df                	mov    %ebx,%edi
 34a:	83 c3 01             	add    $0x1,%ebx
 34d:	0f b6 92 34 07 00 00 	movzbl 0x734(%edx),%edx
 354:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 358:	89 ca                	mov    %ecx,%edx
 35a:	89 c1                	mov    %eax,%ecx
 35c:	39 d6                	cmp    %edx,%esi
 35e:	76 df                	jbe    33f <printint+0x2e>
  if(neg)
 360:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 364:	74 31                	je     397 <printint+0x86>
    buf[i++] = '-';
 366:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 36b:	8d 5f 02             	lea    0x2(%edi),%ebx
 36e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 371:	eb 17                	jmp    38a <printint+0x79>
    x = xx;
 373:	89 c1                	mov    %eax,%ecx
  neg = 0;
 375:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 37c:	eb bc                	jmp    33a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 37e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 383:	89 f0                	mov    %esi,%eax
 385:	e8 6d ff ff ff       	call   2f7 <putc>
  while(--i >= 0)
 38a:	83 eb 01             	sub    $0x1,%ebx
 38d:	79 ef                	jns    37e <printint+0x6d>
}
 38f:	83 c4 2c             	add    $0x2c,%esp
 392:	5b                   	pop    %ebx
 393:	5e                   	pop    %esi
 394:	5f                   	pop    %edi
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	8b 75 d0             	mov    -0x30(%ebp),%esi
 39a:	eb ee                	jmp    38a <printint+0x79>

0000039c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	57                   	push   %edi
 3a0:	56                   	push   %esi
 3a1:	53                   	push   %ebx
 3a2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3a5:	8d 45 10             	lea    0x10(%ebp),%eax
 3a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3ab:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3b0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3b5:	eb 14                	jmp    3cb <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3b7:	89 fa                	mov    %edi,%edx
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	e8 36 ff ff ff       	call   2f7 <putc>
 3c1:	eb 05                	jmp    3c8 <printf+0x2c>
      }
    } else if(state == '%'){
 3c3:	83 fe 25             	cmp    $0x25,%esi
 3c6:	74 25                	je     3ed <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3c8:	83 c3 01             	add    $0x1,%ebx
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3d2:	84 c0                	test   %al,%al
 3d4:	0f 84 20 01 00 00    	je     4fa <printf+0x15e>
    c = fmt[i] & 0xff;
 3da:	0f be f8             	movsbl %al,%edi
 3dd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3e0:	85 f6                	test   %esi,%esi
 3e2:	75 df                	jne    3c3 <printf+0x27>
      if(c == '%'){
 3e4:	83 f8 25             	cmp    $0x25,%eax
 3e7:	75 ce                	jne    3b7 <printf+0x1b>
        state = '%';
 3e9:	89 c6                	mov    %eax,%esi
 3eb:	eb db                	jmp    3c8 <printf+0x2c>
      if(c == 'd'){
 3ed:	83 f8 25             	cmp    $0x25,%eax
 3f0:	0f 84 cf 00 00 00    	je     4c5 <printf+0x129>
 3f6:	0f 8c dd 00 00 00    	jl     4d9 <printf+0x13d>
 3fc:	83 f8 78             	cmp    $0x78,%eax
 3ff:	0f 8f d4 00 00 00    	jg     4d9 <printf+0x13d>
 405:	83 f8 63             	cmp    $0x63,%eax
 408:	0f 8c cb 00 00 00    	jl     4d9 <printf+0x13d>
 40e:	83 e8 63             	sub    $0x63,%eax
 411:	83 f8 15             	cmp    $0x15,%eax
 414:	0f 87 bf 00 00 00    	ja     4d9 <printf+0x13d>
 41a:	ff 24 85 dc 06 00 00 	jmp    *0x6dc(,%eax,4)
        printint(fd, *ap, 10, 1);
 421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 424:	8b 17                	mov    (%edi),%edx
 426:	83 ec 0c             	sub    $0xc,%esp
 429:	6a 01                	push   $0x1
 42b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	e8 d9 fe ff ff       	call   311 <printint>
        ap++;
 438:	83 c7 04             	add    $0x4,%edi
 43b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 43e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 441:	be 00 00 00 00       	mov    $0x0,%esi
 446:	eb 80                	jmp    3c8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 44b:	8b 17                	mov    (%edi),%edx
 44d:	83 ec 0c             	sub    $0xc,%esp
 450:	6a 00                	push   $0x0
 452:	b9 10 00 00 00       	mov    $0x10,%ecx
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	e8 b2 fe ff ff       	call   311 <printint>
        ap++;
 45f:	83 c7 04             	add    $0x4,%edi
 462:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 465:	83 c4 10             	add    $0x10,%esp
      state = 0;
 468:	be 00 00 00 00       	mov    $0x0,%esi
 46d:	e9 56 ff ff ff       	jmp    3c8 <printf+0x2c>
        s = (char*)*ap;
 472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 475:	8b 30                	mov    (%eax),%esi
        ap++;
 477:	83 c0 04             	add    $0x4,%eax
 47a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 47d:	85 f6                	test   %esi,%esi
 47f:	75 15                	jne    496 <printf+0xfa>
          s = "(null)";
 481:	be d4 06 00 00       	mov    $0x6d4,%esi
 486:	eb 0e                	jmp    496 <printf+0xfa>
          putc(fd, *s);
 488:	0f be d2             	movsbl %dl,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 64 fe ff ff       	call   2f7 <putc>
          s++;
 493:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 496:	0f b6 16             	movzbl (%esi),%edx
 499:	84 d2                	test   %dl,%dl
 49b:	75 eb                	jne    488 <printf+0xec>
      state = 0;
 49d:	be 00 00 00 00       	mov    $0x0,%esi
 4a2:	e9 21 ff ff ff       	jmp    3c8 <printf+0x2c>
        putc(fd, *ap);
 4a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4aa:	0f be 17             	movsbl (%edi),%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	e8 42 fe ff ff       	call   2f7 <putc>
        ap++;
 4b5:	83 c7 04             	add    $0x4,%edi
 4b8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4bb:	be 00 00 00 00       	mov    $0x0,%esi
 4c0:	e9 03 ff ff ff       	jmp    3c8 <printf+0x2c>
        putc(fd, c);
 4c5:	89 fa                	mov    %edi,%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 28 fe ff ff       	call   2f7 <putc>
      state = 0;
 4cf:	be 00 00 00 00       	mov    $0x0,%esi
 4d4:	e9 ef fe ff ff       	jmp    3c8 <printf+0x2c>
        putc(fd, '%');
 4d9:	ba 25 00 00 00       	mov    $0x25,%edx
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	e8 11 fe ff ff       	call   2f7 <putc>
        putc(fd, c);
 4e6:	89 fa                	mov    %edi,%edx
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
 4eb:	e8 07 fe ff ff       	call   2f7 <putc>
      state = 0;
 4f0:	be 00 00 00 00       	mov    $0x0,%esi
 4f5:	e9 ce fe ff ff       	jmp    3c8 <printf+0x2c>
    }
  }
}
 4fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fd:	5b                   	pop    %ebx
 4fe:	5e                   	pop    %esi
 4ff:	5f                   	pop    %edi
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    

00000502 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	57                   	push   %edi
 506:	56                   	push   %esi
 507:	53                   	push   %ebx
 508:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 50b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 50e:	a1 dc 09 00 00       	mov    0x9dc,%eax
 513:	eb 02                	jmp    517 <free+0x15>
 515:	89 d0                	mov    %edx,%eax
 517:	39 c8                	cmp    %ecx,%eax
 519:	73 04                	jae    51f <free+0x1d>
 51b:	39 08                	cmp    %ecx,(%eax)
 51d:	77 12                	ja     531 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 51f:	8b 10                	mov    (%eax),%edx
 521:	39 c2                	cmp    %eax,%edx
 523:	77 f0                	ja     515 <free+0x13>
 525:	39 c8                	cmp    %ecx,%eax
 527:	72 08                	jb     531 <free+0x2f>
 529:	39 ca                	cmp    %ecx,%edx
 52b:	77 04                	ja     531 <free+0x2f>
 52d:	89 d0                	mov    %edx,%eax
 52f:	eb e6                	jmp    517 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 531:	8b 73 fc             	mov    -0x4(%ebx),%esi
 534:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 537:	8b 10                	mov    (%eax),%edx
 539:	39 d7                	cmp    %edx,%edi
 53b:	74 19                	je     556 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 53d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 540:	8b 50 04             	mov    0x4(%eax),%edx
 543:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 546:	39 ce                	cmp    %ecx,%esi
 548:	74 1b                	je     565 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 54a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 54c:	a3 dc 09 00 00       	mov    %eax,0x9dc
}
 551:	5b                   	pop    %ebx
 552:	5e                   	pop    %esi
 553:	5f                   	pop    %edi
 554:	5d                   	pop    %ebp
 555:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 556:	03 72 04             	add    0x4(%edx),%esi
 559:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 55c:	8b 10                	mov    (%eax),%edx
 55e:	8b 12                	mov    (%edx),%edx
 560:	89 53 f8             	mov    %edx,-0x8(%ebx)
 563:	eb db                	jmp    540 <free+0x3e>
    p->s.size += bp->s.size;
 565:	03 53 fc             	add    -0x4(%ebx),%edx
 568:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 56b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 56e:	89 10                	mov    %edx,(%eax)
 570:	eb da                	jmp    54c <free+0x4a>

00000572 <morecore>:

static Header*
morecore(uint nu)
{
 572:	55                   	push   %ebp
 573:	89 e5                	mov    %esp,%ebp
 575:	53                   	push   %ebx
 576:	83 ec 04             	sub    $0x4,%esp
 579:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 57b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 580:	77 05                	ja     587 <morecore+0x15>
    nu = 4096;
 582:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 587:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 58e:	83 ec 0c             	sub    $0xc,%esp
 591:	50                   	push   %eax
 592:	e8 10 fd ff ff       	call   2a7 <sbrk>
  if(p == (char*)-1)
 597:	83 c4 10             	add    $0x10,%esp
 59a:	83 f8 ff             	cmp    $0xffffffff,%eax
 59d:	74 1c                	je     5bb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 59f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5a2:	83 c0 08             	add    $0x8,%eax
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	50                   	push   %eax
 5a9:	e8 54 ff ff ff       	call   502 <free>
  return freep;
 5ae:	a1 dc 09 00 00       	mov    0x9dc,%eax
 5b3:	83 c4 10             	add    $0x10,%esp
}
 5b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    
    return 0;
 5bb:	b8 00 00 00 00       	mov    $0x0,%eax
 5c0:	eb f4                	jmp    5b6 <morecore+0x44>

000005c2 <malloc>:

void*
malloc(uint nbytes)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	53                   	push   %ebx
 5c6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	8d 58 07             	lea    0x7(%eax),%ebx
 5cf:	c1 eb 03             	shr    $0x3,%ebx
 5d2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5d5:	8b 0d dc 09 00 00    	mov    0x9dc,%ecx
 5db:	85 c9                	test   %ecx,%ecx
 5dd:	74 04                	je     5e3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5df:	8b 01                	mov    (%ecx),%eax
 5e1:	eb 4a                	jmp    62d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5e3:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 5ea:	09 00 00 
 5ed:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 5f4:	09 00 00 
    base.s.size = 0;
 5f7:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 5fe:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 601:	b9 e0 09 00 00       	mov    $0x9e0,%ecx
 606:	eb d7                	jmp    5df <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 608:	74 19                	je     623 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 60a:	29 da                	sub    %ebx,%edx
 60c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 60f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 612:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 615:	89 0d dc 09 00 00    	mov    %ecx,0x9dc
      return (void*)(p + 1);
 61b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 61e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 621:	c9                   	leave  
 622:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 623:	8b 10                	mov    (%eax),%edx
 625:	89 11                	mov    %edx,(%ecx)
 627:	eb ec                	jmp    615 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 629:	89 c1                	mov    %eax,%ecx
 62b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 62d:	8b 50 04             	mov    0x4(%eax),%edx
 630:	39 da                	cmp    %ebx,%edx
 632:	73 d4                	jae    608 <malloc+0x46>
    if(p == freep)
 634:	39 05 dc 09 00 00    	cmp    %eax,0x9dc
 63a:	75 ed                	jne    629 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 63c:	89 d8                	mov    %ebx,%eax
 63e:	e8 2f ff ff ff       	call   572 <morecore>
 643:	85 c0                	test   %eax,%eax
 645:	75 e2                	jne    629 <malloc+0x67>
 647:	eb d5                	jmp    61e <malloc+0x5c>
