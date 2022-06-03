
_tes:     file format elf32-i386


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
    // int ret =fork();
    // printf(1, "hello pid is %d\n", getpid());
    int ret = fork();
   f:	e8 03 02 00 00       	call   217 <fork>
  14:	89 c3                	mov    %eax,%ebx
    get_siblings_info(getpid());
  16:	e8 84 02 00 00       	call   29f <getpid>
  1b:	83 ec 0c             	sub    $0xc,%esp
  1e:	50                   	push   %eax
  1f:	e8 b3 02 00 00       	call   2d7 <get_siblings_info>
    if (ret == 0)
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 db                	test   %ebx,%ebx
  29:	74 21                	je     4c <main+0x4c>
        printf(1, "child's pid %d\n", getpid());
        while (1)
        {
        }
    }
    else if (ret < 0)
  2b:	78 4e                	js     7b <main+0x7b>
    {
        exit();
    }
    else
    {
        printf(1, "parent %d\n", getpid());
  2d:	e8 6d 02 00 00       	call   29f <getpid>
  32:	83 ec 04             	sub    $0x4,%esp
  35:	50                   	push   %eax
  36:	68 63 06 00 00       	push   $0x663
  3b:	6a 01                	push   $0x1
  3d:	e8 4a 03 00 00       	call   38c <printf>
        wait();
  42:	e8 e0 01 00 00       	call   227 <wait>
    // printf(1,"fork no.: %d\n",ret);
    // get_siblings_info();
    // printf(1, "pid= %d and ppid is = %d\n", getpid(), getppid());
    // printf(1, "fork ret = %d", ret);
    // wait();
    exit();
  47:	e8 d3 01 00 00       	call   21f <exit>
        printf(1, "child's parent pid %d\n", getppid());
  4c:	e8 7e 02 00 00       	call   2cf <getppid>
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	68 3c 06 00 00       	push   $0x63c
  5a:	6a 01                	push   $0x1
  5c:	e8 2b 03 00 00       	call   38c <printf>
        printf(1, "child's pid %d\n", getpid());
  61:	e8 39 02 00 00       	call   29f <getpid>
  66:	83 c4 0c             	add    $0xc,%esp
  69:	50                   	push   %eax
  6a:	68 53 06 00 00       	push   $0x653
  6f:	6a 01                	push   $0x1
  71:	e8 16 03 00 00       	call   38c <printf>
  76:	83 c4 10             	add    $0x10,%esp
        while (1)
  79:	eb fe                	jmp    79 <main+0x79>
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
 2df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	83 ec 1c             	sub    $0x1c,%esp
 2ed:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2f0:	6a 01                	push   $0x1
 2f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2f5:	52                   	push   %edx
 2f6:	50                   	push   %eax
 2f7:	e8 43 ff ff ff       	call   23f <write>
}
 2fc:	83 c4 10             	add    $0x10,%esp
 2ff:	c9                   	leave  
 300:	c3                   	ret    

00000301 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	57                   	push   %edi
 305:	56                   	push   %esi
 306:	53                   	push   %ebx
 307:	83 ec 2c             	sub    $0x2c,%esp
 30a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 30d:	89 d0                	mov    %edx,%eax
 30f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 315:	0f 95 c1             	setne  %cl
 318:	c1 ea 1f             	shr    $0x1f,%edx
 31b:	84 d1                	test   %dl,%cl
 31d:	74 44                	je     363 <printint+0x62>
    neg = 1;
    x = -xx;
 31f:	f7 d8                	neg    %eax
 321:	89 c1                	mov    %eax,%ecx
    neg = 1;
 323:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 32a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 32f:	89 c8                	mov    %ecx,%eax
 331:	ba 00 00 00 00       	mov    $0x0,%edx
 336:	f7 f6                	div    %esi
 338:	89 df                	mov    %ebx,%edi
 33a:	83 c3 01             	add    $0x1,%ebx
 33d:	0f b6 92 d0 06 00 00 	movzbl 0x6d0(%edx),%edx
 344:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 348:	89 ca                	mov    %ecx,%edx
 34a:	89 c1                	mov    %eax,%ecx
 34c:	39 d6                	cmp    %edx,%esi
 34e:	76 df                	jbe    32f <printint+0x2e>
  if(neg)
 350:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 354:	74 31                	je     387 <printint+0x86>
    buf[i++] = '-';
 356:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 35b:	8d 5f 02             	lea    0x2(%edi),%ebx
 35e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 361:	eb 17                	jmp    37a <printint+0x79>
    x = xx;
 363:	89 c1                	mov    %eax,%ecx
  neg = 0;
 365:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 36c:	eb bc                	jmp    32a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 36e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 373:	89 f0                	mov    %esi,%eax
 375:	e8 6d ff ff ff       	call   2e7 <putc>
  while(--i >= 0)
 37a:	83 eb 01             	sub    $0x1,%ebx
 37d:	79 ef                	jns    36e <printint+0x6d>
}
 37f:	83 c4 2c             	add    $0x2c,%esp
 382:	5b                   	pop    %ebx
 383:	5e                   	pop    %esi
 384:	5f                   	pop    %edi
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	8b 75 d0             	mov    -0x30(%ebp),%esi
 38a:	eb ee                	jmp    37a <printint+0x79>

0000038c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	57                   	push   %edi
 390:	56                   	push   %esi
 391:	53                   	push   %ebx
 392:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 395:	8d 45 10             	lea    0x10(%ebp),%eax
 398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 39b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3a0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3a5:	eb 14                	jmp    3bb <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3a7:	89 fa                	mov    %edi,%edx
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	e8 36 ff ff ff       	call   2e7 <putc>
 3b1:	eb 05                	jmp    3b8 <printf+0x2c>
      }
    } else if(state == '%'){
 3b3:	83 fe 25             	cmp    $0x25,%esi
 3b6:	74 25                	je     3dd <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3b8:	83 c3 01             	add    $0x1,%ebx
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3c2:	84 c0                	test   %al,%al
 3c4:	0f 84 20 01 00 00    	je     4ea <printf+0x15e>
    c = fmt[i] & 0xff;
 3ca:	0f be f8             	movsbl %al,%edi
 3cd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3d0:	85 f6                	test   %esi,%esi
 3d2:	75 df                	jne    3b3 <printf+0x27>
      if(c == '%'){
 3d4:	83 f8 25             	cmp    $0x25,%eax
 3d7:	75 ce                	jne    3a7 <printf+0x1b>
        state = '%';
 3d9:	89 c6                	mov    %eax,%esi
 3db:	eb db                	jmp    3b8 <printf+0x2c>
      if(c == 'd'){
 3dd:	83 f8 25             	cmp    $0x25,%eax
 3e0:	0f 84 cf 00 00 00    	je     4b5 <printf+0x129>
 3e6:	0f 8c dd 00 00 00    	jl     4c9 <printf+0x13d>
 3ec:	83 f8 78             	cmp    $0x78,%eax
 3ef:	0f 8f d4 00 00 00    	jg     4c9 <printf+0x13d>
 3f5:	83 f8 63             	cmp    $0x63,%eax
 3f8:	0f 8c cb 00 00 00    	jl     4c9 <printf+0x13d>
 3fe:	83 e8 63             	sub    $0x63,%eax
 401:	83 f8 15             	cmp    $0x15,%eax
 404:	0f 87 bf 00 00 00    	ja     4c9 <printf+0x13d>
 40a:	ff 24 85 78 06 00 00 	jmp    *0x678(,%eax,4)
        printint(fd, *ap, 10, 1);
 411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 414:	8b 17                	mov    (%edi),%edx
 416:	83 ec 0c             	sub    $0xc,%esp
 419:	6a 01                	push   $0x1
 41b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	e8 d9 fe ff ff       	call   301 <printint>
        ap++;
 428:	83 c7 04             	add    $0x4,%edi
 42b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 42e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 431:	be 00 00 00 00       	mov    $0x0,%esi
 436:	eb 80                	jmp    3b8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43b:	8b 17                	mov    (%edi),%edx
 43d:	83 ec 0c             	sub    $0xc,%esp
 440:	6a 00                	push   $0x0
 442:	b9 10 00 00 00       	mov    $0x10,%ecx
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	e8 b2 fe ff ff       	call   301 <printint>
        ap++;
 44f:	83 c7 04             	add    $0x4,%edi
 452:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 455:	83 c4 10             	add    $0x10,%esp
      state = 0;
 458:	be 00 00 00 00       	mov    $0x0,%esi
 45d:	e9 56 ff ff ff       	jmp    3b8 <printf+0x2c>
        s = (char*)*ap;
 462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 465:	8b 30                	mov    (%eax),%esi
        ap++;
 467:	83 c0 04             	add    $0x4,%eax
 46a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 46d:	85 f6                	test   %esi,%esi
 46f:	75 15                	jne    486 <printf+0xfa>
          s = "(null)";
 471:	be 6e 06 00 00       	mov    $0x66e,%esi
 476:	eb 0e                	jmp    486 <printf+0xfa>
          putc(fd, *s);
 478:	0f be d2             	movsbl %dl,%edx
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	e8 64 fe ff ff       	call   2e7 <putc>
          s++;
 483:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 486:	0f b6 16             	movzbl (%esi),%edx
 489:	84 d2                	test   %dl,%dl
 48b:	75 eb                	jne    478 <printf+0xec>
      state = 0;
 48d:	be 00 00 00 00       	mov    $0x0,%esi
 492:	e9 21 ff ff ff       	jmp    3b8 <printf+0x2c>
        putc(fd, *ap);
 497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49a:	0f be 17             	movsbl (%edi),%edx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	e8 42 fe ff ff       	call   2e7 <putc>
        ap++;
 4a5:	83 c7 04             	add    $0x4,%edi
 4a8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ab:	be 00 00 00 00       	mov    $0x0,%esi
 4b0:	e9 03 ff ff ff       	jmp    3b8 <printf+0x2c>
        putc(fd, c);
 4b5:	89 fa                	mov    %edi,%edx
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	e8 28 fe ff ff       	call   2e7 <putc>
      state = 0;
 4bf:	be 00 00 00 00       	mov    $0x0,%esi
 4c4:	e9 ef fe ff ff       	jmp    3b8 <printf+0x2c>
        putc(fd, '%');
 4c9:	ba 25 00 00 00       	mov    $0x25,%edx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	e8 11 fe ff ff       	call   2e7 <putc>
        putc(fd, c);
 4d6:	89 fa                	mov    %edi,%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 07 fe ff ff       	call   2e7 <putc>
      state = 0;
 4e0:	be 00 00 00 00       	mov    $0x0,%esi
 4e5:	e9 ce fe ff ff       	jmp    3b8 <printf+0x2c>
    }
  }
}
 4ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ed:	5b                   	pop    %ebx
 4ee:	5e                   	pop    %esi
 4ef:	5f                   	pop    %edi
 4f0:	5d                   	pop    %ebp
 4f1:	c3                   	ret    

000004f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	57                   	push   %edi
 4f6:	56                   	push   %esi
 4f7:	53                   	push   %ebx
 4f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4fb:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fe:	a1 74 09 00 00       	mov    0x974,%eax
 503:	eb 02                	jmp    507 <free+0x15>
 505:	89 d0                	mov    %edx,%eax
 507:	39 c8                	cmp    %ecx,%eax
 509:	73 04                	jae    50f <free+0x1d>
 50b:	39 08                	cmp    %ecx,(%eax)
 50d:	77 12                	ja     521 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50f:	8b 10                	mov    (%eax),%edx
 511:	39 c2                	cmp    %eax,%edx
 513:	77 f0                	ja     505 <free+0x13>
 515:	39 c8                	cmp    %ecx,%eax
 517:	72 08                	jb     521 <free+0x2f>
 519:	39 ca                	cmp    %ecx,%edx
 51b:	77 04                	ja     521 <free+0x2f>
 51d:	89 d0                	mov    %edx,%eax
 51f:	eb e6                	jmp    507 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 521:	8b 73 fc             	mov    -0x4(%ebx),%esi
 524:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 527:	8b 10                	mov    (%eax),%edx
 529:	39 d7                	cmp    %edx,%edi
 52b:	74 19                	je     546 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 52d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 530:	8b 50 04             	mov    0x4(%eax),%edx
 533:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 536:	39 ce                	cmp    %ecx,%esi
 538:	74 1b                	je     555 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 53a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 53c:	a3 74 09 00 00       	mov    %eax,0x974
}
 541:	5b                   	pop    %ebx
 542:	5e                   	pop    %esi
 543:	5f                   	pop    %edi
 544:	5d                   	pop    %ebp
 545:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 546:	03 72 04             	add    0x4(%edx),%esi
 549:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54c:	8b 10                	mov    (%eax),%edx
 54e:	8b 12                	mov    (%edx),%edx
 550:	89 53 f8             	mov    %edx,-0x8(%ebx)
 553:	eb db                	jmp    530 <free+0x3e>
    p->s.size += bp->s.size;
 555:	03 53 fc             	add    -0x4(%ebx),%edx
 558:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 55e:	89 10                	mov    %edx,(%eax)
 560:	eb da                	jmp    53c <free+0x4a>

00000562 <morecore>:

static Header*
morecore(uint nu)
{
 562:	55                   	push   %ebp
 563:	89 e5                	mov    %esp,%ebp
 565:	53                   	push   %ebx
 566:	83 ec 04             	sub    $0x4,%esp
 569:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 56b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 570:	77 05                	ja     577 <morecore+0x15>
    nu = 4096;
 572:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 577:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 57e:	83 ec 0c             	sub    $0xc,%esp
 581:	50                   	push   %eax
 582:	e8 20 fd ff ff       	call   2a7 <sbrk>
  if(p == (char*)-1)
 587:	83 c4 10             	add    $0x10,%esp
 58a:	83 f8 ff             	cmp    $0xffffffff,%eax
 58d:	74 1c                	je     5ab <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 58f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 592:	83 c0 08             	add    $0x8,%eax
 595:	83 ec 0c             	sub    $0xc,%esp
 598:	50                   	push   %eax
 599:	e8 54 ff ff ff       	call   4f2 <free>
  return freep;
 59e:	a1 74 09 00 00       	mov    0x974,%eax
 5a3:	83 c4 10             	add    $0x10,%esp
}
 5a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a9:	c9                   	leave  
 5aa:	c3                   	ret    
    return 0;
 5ab:	b8 00 00 00 00       	mov    $0x0,%eax
 5b0:	eb f4                	jmp    5a6 <morecore+0x44>

000005b2 <malloc>:

void*
malloc(uint nbytes)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	53                   	push   %ebx
 5b6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	8d 58 07             	lea    0x7(%eax),%ebx
 5bf:	c1 eb 03             	shr    $0x3,%ebx
 5c2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c5:	8b 0d 74 09 00 00    	mov    0x974,%ecx
 5cb:	85 c9                	test   %ecx,%ecx
 5cd:	74 04                	je     5d3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5cf:	8b 01                	mov    (%ecx),%eax
 5d1:	eb 4a                	jmp    61d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5d3:	c7 05 74 09 00 00 78 	movl   $0x978,0x974
 5da:	09 00 00 
 5dd:	c7 05 78 09 00 00 78 	movl   $0x978,0x978
 5e4:	09 00 00 
    base.s.size = 0;
 5e7:	c7 05 7c 09 00 00 00 	movl   $0x0,0x97c
 5ee:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f1:	b9 78 09 00 00       	mov    $0x978,%ecx
 5f6:	eb d7                	jmp    5cf <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5f8:	74 19                	je     613 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5fa:	29 da                	sub    %ebx,%edx
 5fc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5ff:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 602:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 605:	89 0d 74 09 00 00    	mov    %ecx,0x974
      return (void*)(p + 1);
 60b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 60e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 611:	c9                   	leave  
 612:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 613:	8b 10                	mov    (%eax),%edx
 615:	89 11                	mov    %edx,(%ecx)
 617:	eb ec                	jmp    605 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 619:	89 c1                	mov    %eax,%ecx
 61b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	39 da                	cmp    %ebx,%edx
 622:	73 d4                	jae    5f8 <malloc+0x46>
    if(p == freep)
 624:	39 05 74 09 00 00    	cmp    %eax,0x974
 62a:	75 ed                	jne    619 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 62c:	89 d8                	mov    %ebx,%eax
 62e:	e8 2f ff ff ff       	call   562 <morecore>
 633:	85 c0                	test   %eax,%eax
 635:	75 e2                	jne    619 <malloc+0x67>
 637:	eb d5                	jmp    60e <malloc+0x5c>
