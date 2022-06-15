
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 af 01 00 00       	call   1c5 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 ae 01 00 00       	call   1cd <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 34 02 00 00       	call   25d <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	56                   	push   %esi
  32:	53                   	push   %ebx
  33:	8b 75 08             	mov    0x8(%ebp),%esi
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  39:	89 f0                	mov    %esi,%eax
  3b:	89 d1                	mov    %edx,%ecx
  3d:	83 c2 01             	add    $0x1,%edx
  40:	89 c3                	mov    %eax,%ebx
  42:	83 c0 01             	add    $0x1,%eax
  45:	0f b6 09             	movzbl (%ecx),%ecx
  48:	88 0b                	mov    %cl,(%ebx)
  4a:	84 c9                	test   %cl,%cl
  4c:	75 ed                	jne    3b <strcpy+0xd>
    ;
  return os;
}
  4e:	89 f0                	mov    %esi,%eax
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    

00000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  5d:	eb 06                	jmp    65 <strcmp+0x11>
    p++, q++;
  5f:	83 c1 01             	add    $0x1,%ecx
  62:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  65:	0f b6 01             	movzbl (%ecx),%eax
  68:	84 c0                	test   %al,%al
  6a:	74 04                	je     70 <strcmp+0x1c>
  6c:	3a 02                	cmp    (%edx),%al
  6e:	74 ef                	je     5f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  70:	0f b6 c0             	movzbl %al,%eax
  73:	0f b6 12             	movzbl (%edx),%edx
  76:	29 d0                	sub    %edx,%eax
}
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <strlen>:

uint
strlen(const char *s)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  80:	b8 00 00 00 00       	mov    $0x0,%eax
  85:	eb 03                	jmp    8a <strlen+0x10>
  87:	83 c0 01             	add    $0x1,%eax
  8a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8e:	75 f7                	jne    87 <strlen+0xd>
    ;
  return n;
}
  90:	5d                   	pop    %ebp
  91:	c3                   	ret    

00000092 <memset>:

void*
memset(void *dst, int c, uint n)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  99:	89 d7                	mov    %edx,%edi
  9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	fc                   	cld    
  a2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a4:	89 d0                	mov    %edx,%eax
  a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  a9:	c9                   	leave  
  aa:	c3                   	ret    

000000ab <strchr>:

char*
strchr(const char *s, char c)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  b5:	eb 03                	jmp    ba <strchr+0xf>
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	0f b6 10             	movzbl (%eax),%edx
  bd:	84 d2                	test   %dl,%dl
  bf:	74 06                	je     c7 <strchr+0x1c>
    if(*s == c)
  c1:	38 ca                	cmp    %cl,%dl
  c3:	75 f2                	jne    b7 <strchr+0xc>
  c5:	eb 05                	jmp    cc <strchr+0x21>
      return (char*)s;
  return 0;
  c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <gets>:

char*
gets(char *buf, int max)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	57                   	push   %edi
  d2:	56                   	push   %esi
  d3:	53                   	push   %ebx
  d4:	83 ec 1c             	sub    $0x1c,%esp
  d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  da:	bb 00 00 00 00       	mov    $0x0,%ebx
  df:	89 de                	mov    %ebx,%esi
  e1:	83 c3 01             	add    $0x1,%ebx
  e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e7:	7d 2e                	jge    117 <gets+0x49>
    cc = read(0, &c, 1);
  e9:	83 ec 04             	sub    $0x4,%esp
  ec:	6a 01                	push   $0x1
  ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
  f1:	50                   	push   %eax
  f2:	6a 00                	push   $0x0
  f4:	e8 ec 00 00 00       	call   1e5 <read>
    if(cc < 1)
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	85 c0                	test   %eax,%eax
  fe:	7e 17                	jle    117 <gets+0x49>
      break;
    buf[i++] = c;
 100:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 104:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 107:	3c 0a                	cmp    $0xa,%al
 109:	0f 94 c2             	sete   %dl
 10c:	3c 0d                	cmp    $0xd,%al
 10e:	0f 94 c0             	sete   %al
 111:	08 c2                	or     %al,%dl
 113:	74 ca                	je     df <gets+0x11>
    buf[i++] = c;
 115:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 117:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 11b:	89 f8                	mov    %edi,%eax
 11d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 120:	5b                   	pop    %ebx
 121:	5e                   	pop    %esi
 122:	5f                   	pop    %edi
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <stat>:

int
stat(const char *n, struct stat *st)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 12a:	83 ec 08             	sub    $0x8,%esp
 12d:	6a 00                	push   $0x0
 12f:	ff 75 08             	push   0x8(%ebp)
 132:	e8 d6 00 00 00       	call   20d <open>
  if(fd < 0)
 137:	83 c4 10             	add    $0x10,%esp
 13a:	85 c0                	test   %eax,%eax
 13c:	78 24                	js     162 <stat+0x3d>
 13e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	ff 75 0c             	push   0xc(%ebp)
 146:	50                   	push   %eax
 147:	e8 d9 00 00 00       	call   225 <fstat>
 14c:	89 c6                	mov    %eax,%esi
  close(fd);
 14e:	89 1c 24             	mov    %ebx,(%esp)
 151:	e8 9f 00 00 00       	call   1f5 <close>
  return r;
 156:	83 c4 10             	add    $0x10,%esp
}
 159:	89 f0                	mov    %esi,%eax
 15b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    
    return -1;
 162:	be ff ff ff ff       	mov    $0xffffffff,%esi
 167:	eb f0                	jmp    159 <stat+0x34>

00000169 <atoi>:

int
atoi(const char *s)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	53                   	push   %ebx
 16d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 170:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 175:	eb 10                	jmp    187 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 177:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 17a:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 17d:	83 c1 01             	add    $0x1,%ecx
 180:	0f be c0             	movsbl %al,%eax
 183:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 187:	0f b6 01             	movzbl (%ecx),%eax
 18a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 18d:	80 fb 09             	cmp    $0x9,%bl
 190:	76 e5                	jbe    177 <atoi+0xe>
  return n;
}
 192:	89 d0                	mov    %edx,%eax
 194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	8b 75 08             	mov    0x8(%ebp),%esi
 1a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1a7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1a9:	eb 0d                	jmp    1b8 <memmove+0x1f>
    *dst++ = *src++;
 1ab:	0f b6 01             	movzbl (%ecx),%eax
 1ae:	88 02                	mov    %al,(%edx)
 1b0:	8d 49 01             	lea    0x1(%ecx),%ecx
 1b3:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1b6:	89 d8                	mov    %ebx,%eax
 1b8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1bb:	85 c0                	test   %eax,%eax
 1bd:	7f ec                	jg     1ab <memmove+0x12>
  return vdst;
}
 1bf:	89 f0                	mov    %esi,%eax
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    

000001c5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1c5:	b8 01 00 00 00       	mov    $0x1,%eax
 1ca:	cd 40                	int    $0x40
 1cc:	c3                   	ret    

000001cd <exit>:
SYSCALL(exit)
 1cd:	b8 02 00 00 00       	mov    $0x2,%eax
 1d2:	cd 40                	int    $0x40
 1d4:	c3                   	ret    

000001d5 <wait>:
SYSCALL(wait)
 1d5:	b8 03 00 00 00       	mov    $0x3,%eax
 1da:	cd 40                	int    $0x40
 1dc:	c3                   	ret    

000001dd <pipe>:
SYSCALL(pipe)
 1dd:	b8 04 00 00 00       	mov    $0x4,%eax
 1e2:	cd 40                	int    $0x40
 1e4:	c3                   	ret    

000001e5 <read>:
SYSCALL(read)
 1e5:	b8 05 00 00 00       	mov    $0x5,%eax
 1ea:	cd 40                	int    $0x40
 1ec:	c3                   	ret    

000001ed <write>:
SYSCALL(write)
 1ed:	b8 10 00 00 00       	mov    $0x10,%eax
 1f2:	cd 40                	int    $0x40
 1f4:	c3                   	ret    

000001f5 <close>:
SYSCALL(close)
 1f5:	b8 15 00 00 00       	mov    $0x15,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <kill>:
SYSCALL(kill)
 1fd:	b8 06 00 00 00       	mov    $0x6,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <exec>:
SYSCALL(exec)
 205:	b8 07 00 00 00       	mov    $0x7,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <open>:
SYSCALL(open)
 20d:	b8 0f 00 00 00       	mov    $0xf,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <mknod>:
SYSCALL(mknod)
 215:	b8 11 00 00 00       	mov    $0x11,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <unlink>:
SYSCALL(unlink)
 21d:	b8 12 00 00 00       	mov    $0x12,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <fstat>:
SYSCALL(fstat)
 225:	b8 08 00 00 00       	mov    $0x8,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <link>:
SYSCALL(link)
 22d:	b8 13 00 00 00       	mov    $0x13,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <mkdir>:
SYSCALL(mkdir)
 235:	b8 14 00 00 00       	mov    $0x14,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <chdir>:
SYSCALL(chdir)
 23d:	b8 09 00 00 00       	mov    $0x9,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <dup>:
SYSCALL(dup)
 245:	b8 0a 00 00 00       	mov    $0xa,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <getpid>:
SYSCALL(getpid)
 24d:	b8 0b 00 00 00       	mov    $0xb,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <sbrk>:
SYSCALL(sbrk)
 255:	b8 0c 00 00 00       	mov    $0xc,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <sleep>:
SYSCALL(sleep)
 25d:	b8 0d 00 00 00       	mov    $0xd,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <uptime>:
SYSCALL(uptime)
 265:	b8 0e 00 00 00       	mov    $0xe,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <hello>:
SYSCALL(hello)
 26d:	b8 16 00 00 00       	mov    $0x16,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <helloYou>:
SYSCALL(helloYou)
 275:	b8 17 00 00 00       	mov    $0x17,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <getppid>:
SYSCALL(getppid)
 27d:	b8 18 00 00 00       	mov    $0x18,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <get_siblings_info>:
SYSCALL(get_siblings_info)
 285:	b8 19 00 00 00       	mov    $0x19,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <signalProcess>:
SYSCALL(signalProcess)
 28d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <numvp>:
SYSCALL(numvp)
 295:	b8 1b 00 00 00       	mov    $0x1b,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <numpp>:
SYSCALL(numpp)
 29d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <init_counter>:

SYSCALL(init_counter)
 2a5:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <update_cnt>:
SYSCALL(update_cnt)
 2ad:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <display_count>:
SYSCALL(display_count)
 2b5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <init_counter_1>:
SYSCALL(init_counter_1)
 2bd:	b8 20 00 00 00       	mov    $0x20,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2c5:	b8 21 00 00 00       	mov    $0x21,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <display_count_1>:
SYSCALL(display_count_1)
 2cd:	b8 22 00 00 00       	mov    $0x22,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <init_counter_2>:
SYSCALL(init_counter_2)
 2d5:	b8 23 00 00 00       	mov    $0x23,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <update_cnt_2>:
SYSCALL(update_cnt_2)
 2dd:	b8 24 00 00 00       	mov    $0x24,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <display_count_2>:
 2e5:	b8 25 00 00 00       	mov    $0x25,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 1c             	sub    $0x1c,%esp
 2f3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2f6:	6a 01                	push   $0x1
 2f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2fb:	52                   	push   %edx
 2fc:	50                   	push   %eax
 2fd:	e8 eb fe ff ff       	call   1ed <write>
}
 302:	83 c4 10             	add    $0x10,%esp
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	57                   	push   %edi
 30b:	56                   	push   %esi
 30c:	53                   	push   %ebx
 30d:	83 ec 2c             	sub    $0x2c,%esp
 310:	89 45 d0             	mov    %eax,-0x30(%ebp)
 313:	89 d0                	mov    %edx,%eax
 315:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 317:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 31b:	0f 95 c1             	setne  %cl
 31e:	c1 ea 1f             	shr    $0x1f,%edx
 321:	84 d1                	test   %dl,%cl
 323:	74 44                	je     369 <printint+0x62>
    neg = 1;
    x = -xx;
 325:	f7 d8                	neg    %eax
 327:	89 c1                	mov    %eax,%ecx
    neg = 1;
 329:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 330:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 335:	89 c8                	mov    %ecx,%eax
 337:	ba 00 00 00 00       	mov    $0x0,%edx
 33c:	f7 f6                	div    %esi
 33e:	89 df                	mov    %ebx,%edi
 340:	83 c3 01             	add    $0x1,%ebx
 343:	0f b6 92 a0 06 00 00 	movzbl 0x6a0(%edx),%edx
 34a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 34e:	89 ca                	mov    %ecx,%edx
 350:	89 c1                	mov    %eax,%ecx
 352:	39 d6                	cmp    %edx,%esi
 354:	76 df                	jbe    335 <printint+0x2e>
  if(neg)
 356:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 35a:	74 31                	je     38d <printint+0x86>
    buf[i++] = '-';
 35c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 361:	8d 5f 02             	lea    0x2(%edi),%ebx
 364:	8b 75 d0             	mov    -0x30(%ebp),%esi
 367:	eb 17                	jmp    380 <printint+0x79>
    x = xx;
 369:	89 c1                	mov    %eax,%ecx
  neg = 0;
 36b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 372:	eb bc                	jmp    330 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 374:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 379:	89 f0                	mov    %esi,%eax
 37b:	e8 6d ff ff ff       	call   2ed <putc>
  while(--i >= 0)
 380:	83 eb 01             	sub    $0x1,%ebx
 383:	79 ef                	jns    374 <printint+0x6d>
}
 385:	83 c4 2c             	add    $0x2c,%esp
 388:	5b                   	pop    %ebx
 389:	5e                   	pop    %esi
 38a:	5f                   	pop    %edi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 390:	eb ee                	jmp    380 <printint+0x79>

00000392 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	57                   	push   %edi
 396:	56                   	push   %esi
 397:	53                   	push   %ebx
 398:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 39b:	8d 45 10             	lea    0x10(%ebp),%eax
 39e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3a1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3a6:	bb 00 00 00 00       	mov    $0x0,%ebx
 3ab:	eb 14                	jmp    3c1 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3ad:	89 fa                	mov    %edi,%edx
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	e8 36 ff ff ff       	call   2ed <putc>
 3b7:	eb 05                	jmp    3be <printf+0x2c>
      }
    } else if(state == '%'){
 3b9:	83 fe 25             	cmp    $0x25,%esi
 3bc:	74 25                	je     3e3 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3be:	83 c3 01             	add    $0x1,%ebx
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3c8:	84 c0                	test   %al,%al
 3ca:	0f 84 20 01 00 00    	je     4f0 <printf+0x15e>
    c = fmt[i] & 0xff;
 3d0:	0f be f8             	movsbl %al,%edi
 3d3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3d6:	85 f6                	test   %esi,%esi
 3d8:	75 df                	jne    3b9 <printf+0x27>
      if(c == '%'){
 3da:	83 f8 25             	cmp    $0x25,%eax
 3dd:	75 ce                	jne    3ad <printf+0x1b>
        state = '%';
 3df:	89 c6                	mov    %eax,%esi
 3e1:	eb db                	jmp    3be <printf+0x2c>
      if(c == 'd'){
 3e3:	83 f8 25             	cmp    $0x25,%eax
 3e6:	0f 84 cf 00 00 00    	je     4bb <printf+0x129>
 3ec:	0f 8c dd 00 00 00    	jl     4cf <printf+0x13d>
 3f2:	83 f8 78             	cmp    $0x78,%eax
 3f5:	0f 8f d4 00 00 00    	jg     4cf <printf+0x13d>
 3fb:	83 f8 63             	cmp    $0x63,%eax
 3fe:	0f 8c cb 00 00 00    	jl     4cf <printf+0x13d>
 404:	83 e8 63             	sub    $0x63,%eax
 407:	83 f8 15             	cmp    $0x15,%eax
 40a:	0f 87 bf 00 00 00    	ja     4cf <printf+0x13d>
 410:	ff 24 85 48 06 00 00 	jmp    *0x648(,%eax,4)
        printint(fd, *ap, 10, 1);
 417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41a:	8b 17                	mov    (%edi),%edx
 41c:	83 ec 0c             	sub    $0xc,%esp
 41f:	6a 01                	push   $0x1
 421:	b9 0a 00 00 00       	mov    $0xa,%ecx
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	e8 d9 fe ff ff       	call   307 <printint>
        ap++;
 42e:	83 c7 04             	add    $0x4,%edi
 431:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 434:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 437:	be 00 00 00 00       	mov    $0x0,%esi
 43c:	eb 80                	jmp    3be <printf+0x2c>
        printint(fd, *ap, 16, 0);
 43e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 441:	8b 17                	mov    (%edi),%edx
 443:	83 ec 0c             	sub    $0xc,%esp
 446:	6a 00                	push   $0x0
 448:	b9 10 00 00 00       	mov    $0x10,%ecx
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	e8 b2 fe ff ff       	call   307 <printint>
        ap++;
 455:	83 c7 04             	add    $0x4,%edi
 458:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 45b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 45e:	be 00 00 00 00       	mov    $0x0,%esi
 463:	e9 56 ff ff ff       	jmp    3be <printf+0x2c>
        s = (char*)*ap;
 468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46b:	8b 30                	mov    (%eax),%esi
        ap++;
 46d:	83 c0 04             	add    $0x4,%eax
 470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 473:	85 f6                	test   %esi,%esi
 475:	75 15                	jne    48c <printf+0xfa>
          s = "(null)";
 477:	be 40 06 00 00       	mov    $0x640,%esi
 47c:	eb 0e                	jmp    48c <printf+0xfa>
          putc(fd, *s);
 47e:	0f be d2             	movsbl %dl,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	e8 64 fe ff ff       	call   2ed <putc>
          s++;
 489:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 48c:	0f b6 16             	movzbl (%esi),%edx
 48f:	84 d2                	test   %dl,%dl
 491:	75 eb                	jne    47e <printf+0xec>
      state = 0;
 493:	be 00 00 00 00       	mov    $0x0,%esi
 498:	e9 21 ff ff ff       	jmp    3be <printf+0x2c>
        putc(fd, *ap);
 49d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a0:	0f be 17             	movsbl (%edi),%edx
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	e8 42 fe ff ff       	call   2ed <putc>
        ap++;
 4ab:	83 c7 04             	add    $0x4,%edi
 4ae:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4b1:	be 00 00 00 00       	mov    $0x0,%esi
 4b6:	e9 03 ff ff ff       	jmp    3be <printf+0x2c>
        putc(fd, c);
 4bb:	89 fa                	mov    %edi,%edx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 28 fe ff ff       	call   2ed <putc>
      state = 0;
 4c5:	be 00 00 00 00       	mov    $0x0,%esi
 4ca:	e9 ef fe ff ff       	jmp    3be <printf+0x2c>
        putc(fd, '%');
 4cf:	ba 25 00 00 00       	mov    $0x25,%edx
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
 4d7:	e8 11 fe ff ff       	call   2ed <putc>
        putc(fd, c);
 4dc:	89 fa                	mov    %edi,%edx
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	e8 07 fe ff ff       	call   2ed <putc>
      state = 0;
 4e6:	be 00 00 00 00       	mov    $0x0,%esi
 4eb:	e9 ce fe ff ff       	jmp    3be <printf+0x2c>
    }
  }
}
 4f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    

000004f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	57                   	push   %edi
 4fc:	56                   	push   %esi
 4fd:	53                   	push   %ebx
 4fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 501:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 504:	a1 40 09 00 00       	mov    0x940,%eax
 509:	eb 02                	jmp    50d <free+0x15>
 50b:	89 d0                	mov    %edx,%eax
 50d:	39 c8                	cmp    %ecx,%eax
 50f:	73 04                	jae    515 <free+0x1d>
 511:	39 08                	cmp    %ecx,(%eax)
 513:	77 12                	ja     527 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 515:	8b 10                	mov    (%eax),%edx
 517:	39 c2                	cmp    %eax,%edx
 519:	77 f0                	ja     50b <free+0x13>
 51b:	39 c8                	cmp    %ecx,%eax
 51d:	72 08                	jb     527 <free+0x2f>
 51f:	39 ca                	cmp    %ecx,%edx
 521:	77 04                	ja     527 <free+0x2f>
 523:	89 d0                	mov    %edx,%eax
 525:	eb e6                	jmp    50d <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 527:	8b 73 fc             	mov    -0x4(%ebx),%esi
 52a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52d:	8b 10                	mov    (%eax),%edx
 52f:	39 d7                	cmp    %edx,%edi
 531:	74 19                	je     54c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 533:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 536:	8b 50 04             	mov    0x4(%eax),%edx
 539:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 53c:	39 ce                	cmp    %ecx,%esi
 53e:	74 1b                	je     55b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 540:	89 08                	mov    %ecx,(%eax)
  freep = p;
 542:	a3 40 09 00 00       	mov    %eax,0x940
}
 547:	5b                   	pop    %ebx
 548:	5e                   	pop    %esi
 549:	5f                   	pop    %edi
 54a:	5d                   	pop    %ebp
 54b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 54c:	03 72 04             	add    0x4(%edx),%esi
 54f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 552:	8b 10                	mov    (%eax),%edx
 554:	8b 12                	mov    (%edx),%edx
 556:	89 53 f8             	mov    %edx,-0x8(%ebx)
 559:	eb db                	jmp    536 <free+0x3e>
    p->s.size += bp->s.size;
 55b:	03 53 fc             	add    -0x4(%ebx),%edx
 55e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 561:	8b 53 f8             	mov    -0x8(%ebx),%edx
 564:	89 10                	mov    %edx,(%eax)
 566:	eb da                	jmp    542 <free+0x4a>

00000568 <morecore>:

static Header*
morecore(uint nu)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	53                   	push   %ebx
 56c:	83 ec 04             	sub    $0x4,%esp
 56f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 571:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 576:	77 05                	ja     57d <morecore+0x15>
    nu = 4096;
 578:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 57d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 584:	83 ec 0c             	sub    $0xc,%esp
 587:	50                   	push   %eax
 588:	e8 c8 fc ff ff       	call   255 <sbrk>
  if(p == (char*)-1)
 58d:	83 c4 10             	add    $0x10,%esp
 590:	83 f8 ff             	cmp    $0xffffffff,%eax
 593:	74 1c                	je     5b1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 595:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 598:	83 c0 08             	add    $0x8,%eax
 59b:	83 ec 0c             	sub    $0xc,%esp
 59e:	50                   	push   %eax
 59f:	e8 54 ff ff ff       	call   4f8 <free>
  return freep;
 5a4:	a1 40 09 00 00       	mov    0x940,%eax
 5a9:	83 c4 10             	add    $0x10,%esp
}
 5ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5af:	c9                   	leave  
 5b0:	c3                   	ret    
    return 0;
 5b1:	b8 00 00 00 00       	mov    $0x0,%eax
 5b6:	eb f4                	jmp    5ac <morecore+0x44>

000005b8 <malloc>:

void*
malloc(uint nbytes)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	53                   	push   %ebx
 5bc:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	8d 58 07             	lea    0x7(%eax),%ebx
 5c5:	c1 eb 03             	shr    $0x3,%ebx
 5c8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5cb:	8b 0d 40 09 00 00    	mov    0x940,%ecx
 5d1:	85 c9                	test   %ecx,%ecx
 5d3:	74 04                	je     5d9 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d5:	8b 01                	mov    (%ecx),%eax
 5d7:	eb 4a                	jmp    623 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5d9:	c7 05 40 09 00 00 44 	movl   $0x944,0x940
 5e0:	09 00 00 
 5e3:	c7 05 44 09 00 00 44 	movl   $0x944,0x944
 5ea:	09 00 00 
    base.s.size = 0;
 5ed:	c7 05 48 09 00 00 00 	movl   $0x0,0x948
 5f4:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f7:	b9 44 09 00 00       	mov    $0x944,%ecx
 5fc:	eb d7                	jmp    5d5 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5fe:	74 19                	je     619 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 600:	29 da                	sub    %ebx,%edx
 602:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 605:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 608:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 60b:	89 0d 40 09 00 00    	mov    %ecx,0x940
      return (void*)(p + 1);
 611:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 617:	c9                   	leave  
 618:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 619:	8b 10                	mov    (%eax),%edx
 61b:	89 11                	mov    %edx,(%ecx)
 61d:	eb ec                	jmp    60b <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61f:	89 c1                	mov    %eax,%ecx
 621:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 623:	8b 50 04             	mov    0x4(%eax),%edx
 626:	39 da                	cmp    %ebx,%edx
 628:	73 d4                	jae    5fe <malloc+0x46>
    if(p == freep)
 62a:	39 05 40 09 00 00    	cmp    %eax,0x940
 630:	75 ed                	jne    61f <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 632:	89 d8                	mov    %ebx,%eax
 634:	e8 2f ff ff ff       	call   568 <morecore>
 639:	85 c0                	test   %eax,%eax
 63b:	75 e2                	jne    61f <malloc+0x67>
 63d:	eb d5                	jmp    614 <malloc+0x5c>
