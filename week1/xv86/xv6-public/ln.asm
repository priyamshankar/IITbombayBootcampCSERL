
_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 90 06 00 00       	push   $0x690
  1f:	6a 02                	push   $0x2
  21:	e8 ba 03 00 00       	call   3e0 <printf>
    exit();
  26:	e8 d0 01 00 00       	call   1fb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	push   0x8(%ebx)
  31:	ff 73 04             	push   0x4(%ebx)
  34:	e8 22 02 00 00       	call   25b <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 b6 01 00 00       	call   1fb <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	push   0x8(%ebx)
  48:	ff 73 04             	push   0x4(%ebx)
  4b:	68 a3 06 00 00       	push   $0x6a3
  50:	6a 02                	push   $0x2
  52:	e8 89 03 00 00       	call   3e0 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	56                   	push   %esi
  60:	53                   	push   %ebx
  61:	8b 75 08             	mov    0x8(%ebp),%esi
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  67:	89 f0                	mov    %esi,%eax
  69:	89 d1                	mov    %edx,%ecx
  6b:	83 c2 01             	add    $0x1,%edx
  6e:	89 c3                	mov    %eax,%ebx
  70:	83 c0 01             	add    $0x1,%eax
  73:	0f b6 09             	movzbl (%ecx),%ecx
  76:	88 0b                	mov    %cl,(%ebx)
  78:	84 c9                	test   %cl,%cl
  7a:	75 ed                	jne    69 <strcpy+0xd>
    ;
  return os;
}
  7c:	89 f0                	mov    %esi,%eax
  7e:	5b                   	pop    %ebx
  7f:	5e                   	pop    %esi
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  88:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8b:	eb 06                	jmp    93 <strcmp+0x11>
    p++, q++;
  8d:	83 c1 01             	add    $0x1,%ecx
  90:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  93:	0f b6 01             	movzbl (%ecx),%eax
  96:	84 c0                	test   %al,%al
  98:	74 04                	je     9e <strcmp+0x1c>
  9a:	3a 02                	cmp    (%edx),%al
  9c:	74 ef                	je     8d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	29 d0                	sub    %edx,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ae:	b8 00 00 00 00       	mov    $0x0,%eax
  b3:	eb 03                	jmp    b8 <strlen+0x10>
  b5:	83 c0 01             	add    $0x1,%eax
  b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  bc:	75 f7                	jne    b5 <strlen+0xd>
    ;
  return n;
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	89 d7                	mov    %edx,%edi
  c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	89 d0                	mov    %edx,%eax
  d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strchr>:

char*
strchr(const char *s, char c)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e3:	eb 03                	jmp    e8 <strchr+0xf>
  e5:	83 c0 01             	add    $0x1,%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	84 d2                	test   %dl,%dl
  ed:	74 06                	je     f5 <strchr+0x1c>
    if(*s == c)
  ef:	38 ca                	cmp    %cl,%dl
  f1:	75 f2                	jne    e5 <strchr+0xc>
  f3:	eb 05                	jmp    fa <strchr+0x21>
      return (char*)s;
  return 0;
  f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	56                   	push   %esi
 101:	53                   	push   %ebx
 102:	83 ec 1c             	sub    $0x1c,%esp
 105:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	bb 00 00 00 00       	mov    $0x0,%ebx
 10d:	89 de                	mov    %ebx,%esi
 10f:	83 c3 01             	add    $0x1,%ebx
 112:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 115:	7d 2e                	jge    145 <gets+0x49>
    cc = read(0, &c, 1);
 117:	83 ec 04             	sub    $0x4,%esp
 11a:	6a 01                	push   $0x1
 11c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 11f:	50                   	push   %eax
 120:	6a 00                	push   $0x0
 122:	e8 ec 00 00 00       	call   213 <read>
    if(cc < 1)
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	7e 17                	jle    145 <gets+0x49>
      break;
    buf[i++] = c;
 12e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 132:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 135:	3c 0a                	cmp    $0xa,%al
 137:	0f 94 c2             	sete   %dl
 13a:	3c 0d                	cmp    $0xd,%al
 13c:	0f 94 c0             	sete   %al
 13f:	08 c2                	or     %al,%dl
 141:	74 ca                	je     10d <gets+0x11>
    buf[i++] = c;
 143:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 145:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 149:	89 f8                	mov    %edi,%eax
 14b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14e:	5b                   	pop    %ebx
 14f:	5e                   	pop    %esi
 150:	5f                   	pop    %edi
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    

00000153 <stat>:

int
stat(const char *n, struct stat *st)
{
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	56                   	push   %esi
 157:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 158:	83 ec 08             	sub    $0x8,%esp
 15b:	6a 00                	push   $0x0
 15d:	ff 75 08             	push   0x8(%ebp)
 160:	e8 d6 00 00 00       	call   23b <open>
  if(fd < 0)
 165:	83 c4 10             	add    $0x10,%esp
 168:	85 c0                	test   %eax,%eax
 16a:	78 24                	js     190 <stat+0x3d>
 16c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	ff 75 0c             	push   0xc(%ebp)
 174:	50                   	push   %eax
 175:	e8 d9 00 00 00       	call   253 <fstat>
 17a:	89 c6                	mov    %eax,%esi
  close(fd);
 17c:	89 1c 24             	mov    %ebx,(%esp)
 17f:	e8 9f 00 00 00       	call   223 <close>
  return r;
 184:	83 c4 10             	add    $0x10,%esp
}
 187:	89 f0                	mov    %esi,%eax
 189:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    
    return -1;
 190:	be ff ff ff ff       	mov    $0xffffffff,%esi
 195:	eb f0                	jmp    187 <stat+0x34>

00000197 <atoi>:

int
atoi(const char *s)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	53                   	push   %ebx
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 19e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a3:	eb 10                	jmp    1b5 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a5:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1a8:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1ab:	83 c1 01             	add    $0x1,%ecx
 1ae:	0f be c0             	movsbl %al,%eax
 1b1:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 01             	movzbl (%ecx),%eax
 1b8:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bb:	80 fb 09             	cmp    $0x9,%bl
 1be:	76 e5                	jbe    1a5 <atoi+0xe>
  return n;
}
 1c0:	89 d0                	mov    %edx,%eax
 1c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	56                   	push   %esi
 1cb:	53                   	push   %ebx
 1cc:	8b 75 08             	mov    0x8(%ebp),%esi
 1cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d2:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d5:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1d7:	eb 0d                	jmp    1e6 <memmove+0x1f>
    *dst++ = *src++;
 1d9:	0f b6 01             	movzbl (%ecx),%eax
 1dc:	88 02                	mov    %al,(%edx)
 1de:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e1:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e4:	89 d8                	mov    %ebx,%eax
 1e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1e9:	85 c0                	test   %eax,%eax
 1eb:	7f ec                	jg     1d9 <memmove+0x12>
  return vdst;
}
 1ed:	89 f0                	mov    %esi,%eax
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f3:	b8 01 00 00 00       	mov    $0x1,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <exit>:
SYSCALL(exit)
 1fb:	b8 02 00 00 00       	mov    $0x2,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <wait>:
SYSCALL(wait)
 203:	b8 03 00 00 00       	mov    $0x3,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <pipe>:
SYSCALL(pipe)
 20b:	b8 04 00 00 00       	mov    $0x4,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <read>:
SYSCALL(read)
 213:	b8 05 00 00 00       	mov    $0x5,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <write>:
SYSCALL(write)
 21b:	b8 10 00 00 00       	mov    $0x10,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <close>:
SYSCALL(close)
 223:	b8 15 00 00 00       	mov    $0x15,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <kill>:
SYSCALL(kill)
 22b:	b8 06 00 00 00       	mov    $0x6,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <exec>:
SYSCALL(exec)
 233:	b8 07 00 00 00       	mov    $0x7,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <open>:
SYSCALL(open)
 23b:	b8 0f 00 00 00       	mov    $0xf,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <mknod>:
SYSCALL(mknod)
 243:	b8 11 00 00 00       	mov    $0x11,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <unlink>:
SYSCALL(unlink)
 24b:	b8 12 00 00 00       	mov    $0x12,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <fstat>:
SYSCALL(fstat)
 253:	b8 08 00 00 00       	mov    $0x8,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <link>:
SYSCALL(link)
 25b:	b8 13 00 00 00       	mov    $0x13,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <mkdir>:
SYSCALL(mkdir)
 263:	b8 14 00 00 00       	mov    $0x14,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <chdir>:
SYSCALL(chdir)
 26b:	b8 09 00 00 00       	mov    $0x9,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <dup>:
SYSCALL(dup)
 273:	b8 0a 00 00 00       	mov    $0xa,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <getpid>:
SYSCALL(getpid)
 27b:	b8 0b 00 00 00       	mov    $0xb,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <sbrk>:
SYSCALL(sbrk)
 283:	b8 0c 00 00 00       	mov    $0xc,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <sleep>:
SYSCALL(sleep)
 28b:	b8 0d 00 00 00       	mov    $0xd,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <uptime>:
SYSCALL(uptime)
 293:	b8 0e 00 00 00       	mov    $0xe,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <hello>:
SYSCALL(hello)
 29b:	b8 16 00 00 00       	mov    $0x16,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <helloYou>:
SYSCALL(helloYou)
 2a3:	b8 17 00 00 00       	mov    $0x17,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <getppid>:
SYSCALL(getppid)
 2ab:	b8 18 00 00 00       	mov    $0x18,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b3:	b8 19 00 00 00       	mov    $0x19,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <signalProcess>:
SYSCALL(signalProcess)
 2bb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <numvp>:
SYSCALL(numvp)
 2c3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <numpp>:
SYSCALL(numpp)
 2cb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <init_counter>:

SYSCALL(init_counter)
 2d3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <update_cnt>:
SYSCALL(update_cnt)
 2db:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <display_count>:
SYSCALL(display_count)
 2e3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <init_counter_1>:
SYSCALL(init_counter_1)
 2eb:	b8 20 00 00 00       	mov    $0x20,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2f3:	b8 21 00 00 00       	mov    $0x21,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <display_count_1>:
SYSCALL(display_count_1)
 2fb:	b8 22 00 00 00       	mov    $0x22,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <init_counter_2>:
SYSCALL(init_counter_2)
 303:	b8 23 00 00 00       	mov    $0x23,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <update_cnt_2>:
SYSCALL(update_cnt_2)
 30b:	b8 24 00 00 00       	mov    $0x24,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <display_count_2>:
SYSCALL(display_count_2)
 313:	b8 25 00 00 00       	mov    $0x25,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <init_mylock>:
SYSCALL(init_mylock)
 31b:	b8 26 00 00 00       	mov    $0x26,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <acquire_mylock>:
SYSCALL(acquire_mylock)
 323:	b8 27 00 00 00       	mov    $0x27,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <release_mylock>:
SYSCALL(release_mylock)
 32b:	b8 28 00 00 00       	mov    $0x28,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <holding_mylock>:
 333:	b8 29 00 00 00       	mov    $0x29,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 1c             	sub    $0x1c,%esp
 341:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 344:	6a 01                	push   $0x1
 346:	8d 55 f4             	lea    -0xc(%ebp),%edx
 349:	52                   	push   %edx
 34a:	50                   	push   %eax
 34b:	e8 cb fe ff ff       	call   21b <write>
}
 350:	83 c4 10             	add    $0x10,%esp
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	56                   	push   %esi
 35a:	53                   	push   %ebx
 35b:	83 ec 2c             	sub    $0x2c,%esp
 35e:	89 45 d0             	mov    %eax,-0x30(%ebp)
 361:	89 d0                	mov    %edx,%eax
 363:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 365:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 369:	0f 95 c1             	setne  %cl
 36c:	c1 ea 1f             	shr    $0x1f,%edx
 36f:	84 d1                	test   %dl,%cl
 371:	74 44                	je     3b7 <printint+0x62>
    neg = 1;
    x = -xx;
 373:	f7 d8                	neg    %eax
 375:	89 c1                	mov    %eax,%ecx
    neg = 1;
 377:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 383:	89 c8                	mov    %ecx,%eax
 385:	ba 00 00 00 00       	mov    $0x0,%edx
 38a:	f7 f6                	div    %esi
 38c:	89 df                	mov    %ebx,%edi
 38e:	83 c3 01             	add    $0x1,%ebx
 391:	0f b6 92 18 07 00 00 	movzbl 0x718(%edx),%edx
 398:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 39c:	89 ca                	mov    %ecx,%edx
 39e:	89 c1                	mov    %eax,%ecx
 3a0:	39 d6                	cmp    %edx,%esi
 3a2:	76 df                	jbe    383 <printint+0x2e>
  if(neg)
 3a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3a8:	74 31                	je     3db <printint+0x86>
    buf[i++] = '-';
 3aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3af:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b5:	eb 17                	jmp    3ce <printint+0x79>
    x = xx;
 3b7:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c0:	eb bc                	jmp    37e <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3c7:	89 f0                	mov    %esi,%eax
 3c9:	e8 6d ff ff ff       	call   33b <putc>
  while(--i >= 0)
 3ce:	83 eb 01             	sub    $0x1,%ebx
 3d1:	79 ef                	jns    3c2 <printint+0x6d>
}
 3d3:	83 c4 2c             	add    $0x2c,%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    
 3db:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3de:	eb ee                	jmp    3ce <printint+0x79>

000003e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3e9:	8d 45 10             	lea    0x10(%ebp),%eax
 3ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3ef:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f4:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f9:	eb 14                	jmp    40f <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3fb:	89 fa                	mov    %edi,%edx
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	e8 36 ff ff ff       	call   33b <putc>
 405:	eb 05                	jmp    40c <printf+0x2c>
      }
    } else if(state == '%'){
 407:	83 fe 25             	cmp    $0x25,%esi
 40a:	74 25                	je     431 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 40c:	83 c3 01             	add    $0x1,%ebx
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 416:	84 c0                	test   %al,%al
 418:	0f 84 20 01 00 00    	je     53e <printf+0x15e>
    c = fmt[i] & 0xff;
 41e:	0f be f8             	movsbl %al,%edi
 421:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 424:	85 f6                	test   %esi,%esi
 426:	75 df                	jne    407 <printf+0x27>
      if(c == '%'){
 428:	83 f8 25             	cmp    $0x25,%eax
 42b:	75 ce                	jne    3fb <printf+0x1b>
        state = '%';
 42d:	89 c6                	mov    %eax,%esi
 42f:	eb db                	jmp    40c <printf+0x2c>
      if(c == 'd'){
 431:	83 f8 25             	cmp    $0x25,%eax
 434:	0f 84 cf 00 00 00    	je     509 <printf+0x129>
 43a:	0f 8c dd 00 00 00    	jl     51d <printf+0x13d>
 440:	83 f8 78             	cmp    $0x78,%eax
 443:	0f 8f d4 00 00 00    	jg     51d <printf+0x13d>
 449:	83 f8 63             	cmp    $0x63,%eax
 44c:	0f 8c cb 00 00 00    	jl     51d <printf+0x13d>
 452:	83 e8 63             	sub    $0x63,%eax
 455:	83 f8 15             	cmp    $0x15,%eax
 458:	0f 87 bf 00 00 00    	ja     51d <printf+0x13d>
 45e:	ff 24 85 c0 06 00 00 	jmp    *0x6c0(,%eax,4)
        printint(fd, *ap, 10, 1);
 465:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 468:	8b 17                	mov    (%edi),%edx
 46a:	83 ec 0c             	sub    $0xc,%esp
 46d:	6a 01                	push   $0x1
 46f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	e8 d9 fe ff ff       	call   355 <printint>
        ap++;
 47c:	83 c7 04             	add    $0x4,%edi
 47f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 482:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 485:	be 00 00 00 00       	mov    $0x0,%esi
 48a:	eb 80                	jmp    40c <printf+0x2c>
        printint(fd, *ap, 16, 0);
 48c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48f:	8b 17                	mov    (%edi),%edx
 491:	83 ec 0c             	sub    $0xc,%esp
 494:	6a 00                	push   $0x0
 496:	b9 10 00 00 00       	mov    $0x10,%ecx
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	e8 b2 fe ff ff       	call   355 <printint>
        ap++;
 4a3:	83 c7 04             	add    $0x4,%edi
 4a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ac:	be 00 00 00 00       	mov    $0x0,%esi
 4b1:	e9 56 ff ff ff       	jmp    40c <printf+0x2c>
        s = (char*)*ap;
 4b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b9:	8b 30                	mov    (%eax),%esi
        ap++;
 4bb:	83 c0 04             	add    $0x4,%eax
 4be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c1:	85 f6                	test   %esi,%esi
 4c3:	75 15                	jne    4da <printf+0xfa>
          s = "(null)";
 4c5:	be b7 06 00 00       	mov    $0x6b7,%esi
 4ca:	eb 0e                	jmp    4da <printf+0xfa>
          putc(fd, *s);
 4cc:	0f be d2             	movsbl %dl,%edx
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	e8 64 fe ff ff       	call   33b <putc>
          s++;
 4d7:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4da:	0f b6 16             	movzbl (%esi),%edx
 4dd:	84 d2                	test   %dl,%dl
 4df:	75 eb                	jne    4cc <printf+0xec>
      state = 0;
 4e1:	be 00 00 00 00       	mov    $0x0,%esi
 4e6:	e9 21 ff ff ff       	jmp    40c <printf+0x2c>
        putc(fd, *ap);
 4eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ee:	0f be 17             	movsbl (%edi),%edx
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	e8 42 fe ff ff       	call   33b <putc>
        ap++;
 4f9:	83 c7 04             	add    $0x4,%edi
 4fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ff:	be 00 00 00 00       	mov    $0x0,%esi
 504:	e9 03 ff ff ff       	jmp    40c <printf+0x2c>
        putc(fd, c);
 509:	89 fa                	mov    %edi,%edx
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	e8 28 fe ff ff       	call   33b <putc>
      state = 0;
 513:	be 00 00 00 00       	mov    $0x0,%esi
 518:	e9 ef fe ff ff       	jmp    40c <printf+0x2c>
        putc(fd, '%');
 51d:	ba 25 00 00 00       	mov    $0x25,%edx
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	e8 11 fe ff ff       	call   33b <putc>
        putc(fd, c);
 52a:	89 fa                	mov    %edi,%edx
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	e8 07 fe ff ff       	call   33b <putc>
      state = 0;
 534:	be 00 00 00 00       	mov    $0x0,%esi
 539:	e9 ce fe ff ff       	jmp    40c <printf+0x2c>
    }
  }
}
 53e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 541:	5b                   	pop    %ebx
 542:	5e                   	pop    %esi
 543:	5f                   	pop    %edi
 544:	5d                   	pop    %ebp
 545:	c3                   	ret    

00000546 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	57                   	push   %edi
 54a:	56                   	push   %esi
 54b:	53                   	push   %ebx
 54c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 552:	a1 bc 09 00 00       	mov    0x9bc,%eax
 557:	eb 02                	jmp    55b <free+0x15>
 559:	89 d0                	mov    %edx,%eax
 55b:	39 c8                	cmp    %ecx,%eax
 55d:	73 04                	jae    563 <free+0x1d>
 55f:	39 08                	cmp    %ecx,(%eax)
 561:	77 12                	ja     575 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 563:	8b 10                	mov    (%eax),%edx
 565:	39 c2                	cmp    %eax,%edx
 567:	77 f0                	ja     559 <free+0x13>
 569:	39 c8                	cmp    %ecx,%eax
 56b:	72 08                	jb     575 <free+0x2f>
 56d:	39 ca                	cmp    %ecx,%edx
 56f:	77 04                	ja     575 <free+0x2f>
 571:	89 d0                	mov    %edx,%eax
 573:	eb e6                	jmp    55b <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 575:	8b 73 fc             	mov    -0x4(%ebx),%esi
 578:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57b:	8b 10                	mov    (%eax),%edx
 57d:	39 d7                	cmp    %edx,%edi
 57f:	74 19                	je     59a <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 581:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 584:	8b 50 04             	mov    0x4(%eax),%edx
 587:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58a:	39 ce                	cmp    %ecx,%esi
 58c:	74 1b                	je     5a9 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 58e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 590:	a3 bc 09 00 00       	mov    %eax,0x9bc
}
 595:	5b                   	pop    %ebx
 596:	5e                   	pop    %esi
 597:	5f                   	pop    %edi
 598:	5d                   	pop    %ebp
 599:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59a:	03 72 04             	add    0x4(%edx),%esi
 59d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a0:	8b 10                	mov    (%eax),%edx
 5a2:	8b 12                	mov    (%edx),%edx
 5a4:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a7:	eb db                	jmp    584 <free+0x3e>
    p->s.size += bp->s.size;
 5a9:	03 53 fc             	add    -0x4(%ebx),%edx
 5ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5af:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b2:	89 10                	mov    %edx,(%eax)
 5b4:	eb da                	jmp    590 <free+0x4a>

000005b6 <morecore>:

static Header*
morecore(uint nu)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	53                   	push   %ebx
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5bf:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c4:	77 05                	ja     5cb <morecore+0x15>
    nu = 4096;
 5c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5cb:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d2:	83 ec 0c             	sub    $0xc,%esp
 5d5:	50                   	push   %eax
 5d6:	e8 a8 fc ff ff       	call   283 <sbrk>
  if(p == (char*)-1)
 5db:	83 c4 10             	add    $0x10,%esp
 5de:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e1:	74 1c                	je     5ff <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e3:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5e6:	83 c0 08             	add    $0x8,%eax
 5e9:	83 ec 0c             	sub    $0xc,%esp
 5ec:	50                   	push   %eax
 5ed:	e8 54 ff ff ff       	call   546 <free>
  return freep;
 5f2:	a1 bc 09 00 00       	mov    0x9bc,%eax
 5f7:	83 c4 10             	add    $0x10,%esp
}
 5fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fd:	c9                   	leave  
 5fe:	c3                   	ret    
    return 0;
 5ff:	b8 00 00 00 00       	mov    $0x0,%eax
 604:	eb f4                	jmp    5fa <morecore+0x44>

00000606 <malloc>:

void*
malloc(uint nbytes)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	53                   	push   %ebx
 60a:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	8d 58 07             	lea    0x7(%eax),%ebx
 613:	c1 eb 03             	shr    $0x3,%ebx
 616:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 619:	8b 0d bc 09 00 00    	mov    0x9bc,%ecx
 61f:	85 c9                	test   %ecx,%ecx
 621:	74 04                	je     627 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 623:	8b 01                	mov    (%ecx),%eax
 625:	eb 4a                	jmp    671 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 627:	c7 05 bc 09 00 00 c0 	movl   $0x9c0,0x9bc
 62e:	09 00 00 
 631:	c7 05 c0 09 00 00 c0 	movl   $0x9c0,0x9c0
 638:	09 00 00 
    base.s.size = 0;
 63b:	c7 05 c4 09 00 00 00 	movl   $0x0,0x9c4
 642:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 645:	b9 c0 09 00 00       	mov    $0x9c0,%ecx
 64a:	eb d7                	jmp    623 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 64c:	74 19                	je     667 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64e:	29 da                	sub    %ebx,%edx
 650:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 653:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 656:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 659:	89 0d bc 09 00 00    	mov    %ecx,0x9bc
      return (void*)(p + 1);
 65f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 665:	c9                   	leave  
 666:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 667:	8b 10                	mov    (%eax),%edx
 669:	89 11                	mov    %edx,(%ecx)
 66b:	eb ec                	jmp    659 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66d:	89 c1                	mov    %eax,%ecx
 66f:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	39 da                	cmp    %ebx,%edx
 676:	73 d4                	jae    64c <malloc+0x46>
    if(p == freep)
 678:	39 05 bc 09 00 00    	cmp    %eax,0x9bc
 67e:	75 ed                	jne    66d <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 680:	89 d8                	mov    %ebx,%eax
 682:	e8 2f ff ff ff       	call   5b6 <morecore>
 687:	85 c0                	test   %eax,%eax
 689:	75 e2                	jne    66d <malloc+0x67>
 68b:	eb d5                	jmp    662 <malloc+0x5c>
