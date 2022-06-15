
_manSyCall:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "stddef.h"

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc <= 1)
  12:	83 39 01             	cmpl   $0x1,(%ecx)
  15:	7e 15                	jle    2c <main+0x2c>
    {
        printf(1, "not any argument exititng the program\n");
        printf(1, "manSyCall + any string to print the system call\n");
        exit();
    }
    hello();
  17:	e8 72 02 00 00       	call   28e <hello>
    helloYou(argv[1]);
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	ff 73 04             	push   0x4(%ebx)
  22:	e8 6f 02 00 00       	call   296 <helloYou>
    //
    exit();
  27:	e8 c2 01 00 00       	call   1ee <exit>
        printf(1, "not any argument exititng the program\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 60 06 00 00       	push   $0x660
  34:	6a 01                	push   $0x1
  36:	e8 78 03 00 00       	call   3b3 <printf>
        printf(1, "manSyCall + any string to print the system call\n");
  3b:	83 c4 08             	add    $0x8,%esp
  3e:	68 88 06 00 00       	push   $0x688
  43:	6a 01                	push   $0x1
  45:	e8 69 03 00 00       	call   3b3 <printf>
        exit();
  4a:	e8 9f 01 00 00       	call   1ee <exit>

0000004f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  52:	56                   	push   %esi
  53:	53                   	push   %ebx
  54:	8b 75 08             	mov    0x8(%ebp),%esi
  57:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 f0                	mov    %esi,%eax
  5c:	89 d1                	mov    %edx,%ecx
  5e:	83 c2 01             	add    $0x1,%edx
  61:	89 c3                	mov    %eax,%ebx
  63:	83 c0 01             	add    $0x1,%eax
  66:	0f b6 09             	movzbl (%ecx),%ecx
  69:	88 0b                	mov    %cl,(%ebx)
  6b:	84 c9                	test   %cl,%cl
  6d:	75 ed                	jne    5c <strcpy+0xd>
    ;
  return os;
}
  6f:	89 f0                	mov    %esi,%eax
  71:	5b                   	pop    %ebx
  72:	5e                   	pop    %esi
  73:	5d                   	pop    %ebp
  74:	c3                   	ret    

00000075 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7e:	eb 06                	jmp    86 <strcmp+0x11>
    p++, q++;
  80:	83 c1 01             	add    $0x1,%ecx
  83:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  86:	0f b6 01             	movzbl (%ecx),%eax
  89:	84 c0                	test   %al,%al
  8b:	74 04                	je     91 <strcmp+0x1c>
  8d:	3a 02                	cmp    (%edx),%al
  8f:	74 ef                	je     80 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  91:	0f b6 c0             	movzbl %al,%eax
  94:	0f b6 12             	movzbl (%edx),%edx
  97:	29 d0                	sub    %edx,%eax
}
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strlen>:

uint
strlen(const char *s)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a1:	b8 00 00 00 00       	mov    $0x0,%eax
  a6:	eb 03                	jmp    ab <strlen+0x10>
  a8:	83 c0 01             	add    $0x1,%eax
  ab:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  af:	75 f7                	jne    a8 <strlen+0xd>
    ;
  return n;
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	57                   	push   %edi
  b7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ba:	89 d7                	mov    %edx,%edi
  bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	fc                   	cld    
  c3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c5:	89 d0                	mov    %edx,%eax
  c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ca:	c9                   	leave  
  cb:	c3                   	ret    

000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d6:	eb 03                	jmp    db <strchr+0xf>
  d8:	83 c0 01             	add    $0x1,%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	84 d2                	test   %dl,%dl
  e0:	74 06                	je     e8 <strchr+0x1c>
    if(*s == c)
  e2:	38 ca                	cmp    %cl,%dl
  e4:	75 f2                	jne    d8 <strchr+0xc>
  e6:	eb 05                	jmp    ed <strchr+0x21>
      return (char*)s;
  return 0;
  e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <gets>:

char*
gets(char *buf, int max)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	57                   	push   %edi
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	83 ec 1c             	sub    $0x1c,%esp
  f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fb:	bb 00 00 00 00       	mov    $0x0,%ebx
 100:	89 de                	mov    %ebx,%esi
 102:	83 c3 01             	add    $0x1,%ebx
 105:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 108:	7d 2e                	jge    138 <gets+0x49>
    cc = read(0, &c, 1);
 10a:	83 ec 04             	sub    $0x4,%esp
 10d:	6a 01                	push   $0x1
 10f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 112:	50                   	push   %eax
 113:	6a 00                	push   $0x0
 115:	e8 ec 00 00 00       	call   206 <read>
    if(cc < 1)
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	85 c0                	test   %eax,%eax
 11f:	7e 17                	jle    138 <gets+0x49>
      break;
    buf[i++] = c;
 121:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 125:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	0f 94 c2             	sete   %dl
 12d:	3c 0d                	cmp    $0xd,%al
 12f:	0f 94 c0             	sete   %al
 132:	08 c2                	or     %al,%dl
 134:	74 ca                	je     100 <gets+0x11>
    buf[i++] = c;
 136:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 138:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13c:	89 f8                	mov    %edi,%eax
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    

00000146 <stat>:

int
stat(const char *n, struct stat *st)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	56                   	push   %esi
 14a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	6a 00                	push   $0x0
 150:	ff 75 08             	push   0x8(%ebp)
 153:	e8 d6 00 00 00       	call   22e <open>
  if(fd < 0)
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	78 24                	js     183 <stat+0x3d>
 15f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	ff 75 0c             	push   0xc(%ebp)
 167:	50                   	push   %eax
 168:	e8 d9 00 00 00       	call   246 <fstat>
 16d:	89 c6                	mov    %eax,%esi
  close(fd);
 16f:	89 1c 24             	mov    %ebx,(%esp)
 172:	e8 9f 00 00 00       	call   216 <close>
  return r;
 177:	83 c4 10             	add    $0x10,%esp
}
 17a:	89 f0                	mov    %esi,%eax
 17c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17f:	5b                   	pop    %ebx
 180:	5e                   	pop    %esi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
    return -1;
 183:	be ff ff ff ff       	mov    $0xffffffff,%esi
 188:	eb f0                	jmp    17a <stat+0x34>

0000018a <atoi>:

int
atoi(const char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	53                   	push   %ebx
 18e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 191:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 196:	eb 10                	jmp    1a8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 198:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19b:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 19e:	83 c1 01             	add    $0x1,%ecx
 1a1:	0f be c0             	movsbl %al,%eax
 1a4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a8:	0f b6 01             	movzbl (%ecx),%eax
 1ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ae:	80 fb 09             	cmp    $0x9,%bl
 1b1:	76 e5                	jbe    198 <atoi+0xe>
  return n;
}
 1b3:	89 d0                	mov    %edx,%eax
 1b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	56                   	push   %esi
 1be:	53                   	push   %ebx
 1bf:	8b 75 08             	mov    0x8(%ebp),%esi
 1c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c8:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ca:	eb 0d                	jmp    1d9 <memmove+0x1f>
    *dst++ = *src++;
 1cc:	0f b6 01             	movzbl (%ecx),%eax
 1cf:	88 02                	mov    %al,(%edx)
 1d1:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d4:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d7:	89 d8                	mov    %ebx,%eax
 1d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1dc:	85 c0                	test   %eax,%eax
 1de:	7f ec                	jg     1cc <memmove+0x12>
  return vdst;
}
 1e0:	89 f0                	mov    %esi,%eax
 1e2:	5b                   	pop    %ebx
 1e3:	5e                   	pop    %esi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e6:	b8 01 00 00 00       	mov    $0x1,%eax
 1eb:	cd 40                	int    $0x40
 1ed:	c3                   	ret    

000001ee <exit>:
SYSCALL(exit)
 1ee:	b8 02 00 00 00       	mov    $0x2,%eax
 1f3:	cd 40                	int    $0x40
 1f5:	c3                   	ret    

000001f6 <wait>:
SYSCALL(wait)
 1f6:	b8 03 00 00 00       	mov    $0x3,%eax
 1fb:	cd 40                	int    $0x40
 1fd:	c3                   	ret    

000001fe <pipe>:
SYSCALL(pipe)
 1fe:	b8 04 00 00 00       	mov    $0x4,%eax
 203:	cd 40                	int    $0x40
 205:	c3                   	ret    

00000206 <read>:
SYSCALL(read)
 206:	b8 05 00 00 00       	mov    $0x5,%eax
 20b:	cd 40                	int    $0x40
 20d:	c3                   	ret    

0000020e <write>:
SYSCALL(write)
 20e:	b8 10 00 00 00       	mov    $0x10,%eax
 213:	cd 40                	int    $0x40
 215:	c3                   	ret    

00000216 <close>:
SYSCALL(close)
 216:	b8 15 00 00 00       	mov    $0x15,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <kill>:
SYSCALL(kill)
 21e:	b8 06 00 00 00       	mov    $0x6,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <exec>:
SYSCALL(exec)
 226:	b8 07 00 00 00       	mov    $0x7,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <open>:
SYSCALL(open)
 22e:	b8 0f 00 00 00       	mov    $0xf,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <mknod>:
SYSCALL(mknod)
 236:	b8 11 00 00 00       	mov    $0x11,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <unlink>:
SYSCALL(unlink)
 23e:	b8 12 00 00 00       	mov    $0x12,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <fstat>:
SYSCALL(fstat)
 246:	b8 08 00 00 00       	mov    $0x8,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <link>:
SYSCALL(link)
 24e:	b8 13 00 00 00       	mov    $0x13,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <mkdir>:
SYSCALL(mkdir)
 256:	b8 14 00 00 00       	mov    $0x14,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <chdir>:
SYSCALL(chdir)
 25e:	b8 09 00 00 00       	mov    $0x9,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <dup>:
SYSCALL(dup)
 266:	b8 0a 00 00 00       	mov    $0xa,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <getpid>:
SYSCALL(getpid)
 26e:	b8 0b 00 00 00       	mov    $0xb,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <sbrk>:
SYSCALL(sbrk)
 276:	b8 0c 00 00 00       	mov    $0xc,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <sleep>:
SYSCALL(sleep)
 27e:	b8 0d 00 00 00       	mov    $0xd,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <uptime>:
SYSCALL(uptime)
 286:	b8 0e 00 00 00       	mov    $0xe,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <hello>:
SYSCALL(hello)
 28e:	b8 16 00 00 00       	mov    $0x16,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <helloYou>:
SYSCALL(helloYou)
 296:	b8 17 00 00 00       	mov    $0x17,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <getppid>:
SYSCALL(getppid)
 29e:	b8 18 00 00 00       	mov    $0x18,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2a6:	b8 19 00 00 00       	mov    $0x19,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <signalProcess>:
SYSCALL(signalProcess)
 2ae:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <numvp>:
SYSCALL(numvp)
 2b6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <numpp>:
SYSCALL(numpp)
 2be:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <init_counter>:

SYSCALL(init_counter)
 2c6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <update_cnt>:
SYSCALL(update_cnt)
 2ce:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <display_count>:
SYSCALL(display_count)
 2d6:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <init_counter_1>:
SYSCALL(init_counter_1)
 2de:	b8 20 00 00 00       	mov    $0x20,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2e6:	b8 21 00 00 00       	mov    $0x21,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <display_count_1>:
SYSCALL(display_count_1)
 2ee:	b8 22 00 00 00       	mov    $0x22,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <init_counter_2>:
SYSCALL(init_counter_2)
 2f6:	b8 23 00 00 00       	mov    $0x23,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <update_cnt_2>:
SYSCALL(update_cnt_2)
 2fe:	b8 24 00 00 00       	mov    $0x24,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <display_count_2>:
 306:	b8 25 00 00 00       	mov    $0x25,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 1c             	sub    $0x1c,%esp
 314:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 317:	6a 01                	push   $0x1
 319:	8d 55 f4             	lea    -0xc(%ebp),%edx
 31c:	52                   	push   %edx
 31d:	50                   	push   %eax
 31e:	e8 eb fe ff ff       	call   20e <write>
}
 323:	83 c4 10             	add    $0x10,%esp
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	57                   	push   %edi
 32c:	56                   	push   %esi
 32d:	53                   	push   %ebx
 32e:	83 ec 2c             	sub    $0x2c,%esp
 331:	89 45 d0             	mov    %eax,-0x30(%ebp)
 334:	89 d0                	mov    %edx,%eax
 336:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 33c:	0f 95 c1             	setne  %cl
 33f:	c1 ea 1f             	shr    $0x1f,%edx
 342:	84 d1                	test   %dl,%cl
 344:	74 44                	je     38a <printint+0x62>
    neg = 1;
    x = -xx;
 346:	f7 d8                	neg    %eax
 348:	89 c1                	mov    %eax,%ecx
    neg = 1;
 34a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 351:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 356:	89 c8                	mov    %ecx,%eax
 358:	ba 00 00 00 00       	mov    $0x0,%edx
 35d:	f7 f6                	div    %esi
 35f:	89 df                	mov    %ebx,%edi
 361:	83 c3 01             	add    $0x1,%ebx
 364:	0f b6 92 18 07 00 00 	movzbl 0x718(%edx),%edx
 36b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 36f:	89 ca                	mov    %ecx,%edx
 371:	89 c1                	mov    %eax,%ecx
 373:	39 d6                	cmp    %edx,%esi
 375:	76 df                	jbe    356 <printint+0x2e>
  if(neg)
 377:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 37b:	74 31                	je     3ae <printint+0x86>
    buf[i++] = '-';
 37d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 382:	8d 5f 02             	lea    0x2(%edi),%ebx
 385:	8b 75 d0             	mov    -0x30(%ebp),%esi
 388:	eb 17                	jmp    3a1 <printint+0x79>
    x = xx;
 38a:	89 c1                	mov    %eax,%ecx
  neg = 0;
 38c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 393:	eb bc                	jmp    351 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 395:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 39a:	89 f0                	mov    %esi,%eax
 39c:	e8 6d ff ff ff       	call   30e <putc>
  while(--i >= 0)
 3a1:	83 eb 01             	sub    $0x1,%ebx
 3a4:	79 ef                	jns    395 <printint+0x6d>
}
 3a6:	83 c4 2c             	add    $0x2c,%esp
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5f                   	pop    %edi
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    
 3ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b1:	eb ee                	jmp    3a1 <printint+0x79>

000003b3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	57                   	push   %edi
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
 3b9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3bc:	8d 45 10             	lea    0x10(%ebp),%eax
 3bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3c2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3c7:	bb 00 00 00 00       	mov    $0x0,%ebx
 3cc:	eb 14                	jmp    3e2 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3ce:	89 fa                	mov    %edi,%edx
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	e8 36 ff ff ff       	call   30e <putc>
 3d8:	eb 05                	jmp    3df <printf+0x2c>
      }
    } else if(state == '%'){
 3da:	83 fe 25             	cmp    $0x25,%esi
 3dd:	74 25                	je     404 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3df:	83 c3 01             	add    $0x1,%ebx
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	0f 84 20 01 00 00    	je     511 <printf+0x15e>
    c = fmt[i] & 0xff;
 3f1:	0f be f8             	movsbl %al,%edi
 3f4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3f7:	85 f6                	test   %esi,%esi
 3f9:	75 df                	jne    3da <printf+0x27>
      if(c == '%'){
 3fb:	83 f8 25             	cmp    $0x25,%eax
 3fe:	75 ce                	jne    3ce <printf+0x1b>
        state = '%';
 400:	89 c6                	mov    %eax,%esi
 402:	eb db                	jmp    3df <printf+0x2c>
      if(c == 'd'){
 404:	83 f8 25             	cmp    $0x25,%eax
 407:	0f 84 cf 00 00 00    	je     4dc <printf+0x129>
 40d:	0f 8c dd 00 00 00    	jl     4f0 <printf+0x13d>
 413:	83 f8 78             	cmp    $0x78,%eax
 416:	0f 8f d4 00 00 00    	jg     4f0 <printf+0x13d>
 41c:	83 f8 63             	cmp    $0x63,%eax
 41f:	0f 8c cb 00 00 00    	jl     4f0 <printf+0x13d>
 425:	83 e8 63             	sub    $0x63,%eax
 428:	83 f8 15             	cmp    $0x15,%eax
 42b:	0f 87 bf 00 00 00    	ja     4f0 <printf+0x13d>
 431:	ff 24 85 c0 06 00 00 	jmp    *0x6c0(,%eax,4)
        printint(fd, *ap, 10, 1);
 438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43b:	8b 17                	mov    (%edi),%edx
 43d:	83 ec 0c             	sub    $0xc,%esp
 440:	6a 01                	push   $0x1
 442:	b9 0a 00 00 00       	mov    $0xa,%ecx
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	e8 d9 fe ff ff       	call   328 <printint>
        ap++;
 44f:	83 c7 04             	add    $0x4,%edi
 452:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 455:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 458:	be 00 00 00 00       	mov    $0x0,%esi
 45d:	eb 80                	jmp    3df <printf+0x2c>
        printint(fd, *ap, 16, 0);
 45f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 462:	8b 17                	mov    (%edi),%edx
 464:	83 ec 0c             	sub    $0xc,%esp
 467:	6a 00                	push   $0x0
 469:	b9 10 00 00 00       	mov    $0x10,%ecx
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	e8 b2 fe ff ff       	call   328 <printint>
        ap++;
 476:	83 c7 04             	add    $0x4,%edi
 479:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 47c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 47f:	be 00 00 00 00       	mov    $0x0,%esi
 484:	e9 56 ff ff ff       	jmp    3df <printf+0x2c>
        s = (char*)*ap;
 489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48c:	8b 30                	mov    (%eax),%esi
        ap++;
 48e:	83 c0 04             	add    $0x4,%eax
 491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 494:	85 f6                	test   %esi,%esi
 496:	75 15                	jne    4ad <printf+0xfa>
          s = "(null)";
 498:	be b9 06 00 00       	mov    $0x6b9,%esi
 49d:	eb 0e                	jmp    4ad <printf+0xfa>
          putc(fd, *s);
 49f:	0f be d2             	movsbl %dl,%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 64 fe ff ff       	call   30e <putc>
          s++;
 4aa:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4ad:	0f b6 16             	movzbl (%esi),%edx
 4b0:	84 d2                	test   %dl,%dl
 4b2:	75 eb                	jne    49f <printf+0xec>
      state = 0;
 4b4:	be 00 00 00 00       	mov    $0x0,%esi
 4b9:	e9 21 ff ff ff       	jmp    3df <printf+0x2c>
        putc(fd, *ap);
 4be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c1:	0f be 17             	movsbl (%edi),%edx
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	e8 42 fe ff ff       	call   30e <putc>
        ap++;
 4cc:	83 c7 04             	add    $0x4,%edi
 4cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4d2:	be 00 00 00 00       	mov    $0x0,%esi
 4d7:	e9 03 ff ff ff       	jmp    3df <printf+0x2c>
        putc(fd, c);
 4dc:	89 fa                	mov    %edi,%edx
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	e8 28 fe ff ff       	call   30e <putc>
      state = 0;
 4e6:	be 00 00 00 00       	mov    $0x0,%esi
 4eb:	e9 ef fe ff ff       	jmp    3df <printf+0x2c>
        putc(fd, '%');
 4f0:	ba 25 00 00 00       	mov    $0x25,%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 11 fe ff ff       	call   30e <putc>
        putc(fd, c);
 4fd:	89 fa                	mov    %edi,%edx
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	e8 07 fe ff ff       	call   30e <putc>
      state = 0;
 507:	be 00 00 00 00       	mov    $0x0,%esi
 50c:	e9 ce fe ff ff       	jmp    3df <printf+0x2c>
    }
  }
}
 511:	8d 65 f4             	lea    -0xc(%ebp),%esp
 514:	5b                   	pop    %ebx
 515:	5e                   	pop    %esi
 516:	5f                   	pop    %edi
 517:	5d                   	pop    %ebp
 518:	c3                   	ret    

00000519 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 519:	55                   	push   %ebp
 51a:	89 e5                	mov    %esp,%ebp
 51c:	57                   	push   %edi
 51d:	56                   	push   %esi
 51e:	53                   	push   %ebx
 51f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 522:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 525:	a1 bc 09 00 00       	mov    0x9bc,%eax
 52a:	eb 02                	jmp    52e <free+0x15>
 52c:	89 d0                	mov    %edx,%eax
 52e:	39 c8                	cmp    %ecx,%eax
 530:	73 04                	jae    536 <free+0x1d>
 532:	39 08                	cmp    %ecx,(%eax)
 534:	77 12                	ja     548 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 536:	8b 10                	mov    (%eax),%edx
 538:	39 c2                	cmp    %eax,%edx
 53a:	77 f0                	ja     52c <free+0x13>
 53c:	39 c8                	cmp    %ecx,%eax
 53e:	72 08                	jb     548 <free+0x2f>
 540:	39 ca                	cmp    %ecx,%edx
 542:	77 04                	ja     548 <free+0x2f>
 544:	89 d0                	mov    %edx,%eax
 546:	eb e6                	jmp    52e <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 548:	8b 73 fc             	mov    -0x4(%ebx),%esi
 54b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 54e:	8b 10                	mov    (%eax),%edx
 550:	39 d7                	cmp    %edx,%edi
 552:	74 19                	je     56d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 554:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 557:	8b 50 04             	mov    0x4(%eax),%edx
 55a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 55d:	39 ce                	cmp    %ecx,%esi
 55f:	74 1b                	je     57c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 561:	89 08                	mov    %ecx,(%eax)
  freep = p;
 563:	a3 bc 09 00 00       	mov    %eax,0x9bc
}
 568:	5b                   	pop    %ebx
 569:	5e                   	pop    %esi
 56a:	5f                   	pop    %edi
 56b:	5d                   	pop    %ebp
 56c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 56d:	03 72 04             	add    0x4(%edx),%esi
 570:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 573:	8b 10                	mov    (%eax),%edx
 575:	8b 12                	mov    (%edx),%edx
 577:	89 53 f8             	mov    %edx,-0x8(%ebx)
 57a:	eb db                	jmp    557 <free+0x3e>
    p->s.size += bp->s.size;
 57c:	03 53 fc             	add    -0x4(%ebx),%edx
 57f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 582:	8b 53 f8             	mov    -0x8(%ebx),%edx
 585:	89 10                	mov    %edx,(%eax)
 587:	eb da                	jmp    563 <free+0x4a>

00000589 <morecore>:

static Header*
morecore(uint nu)
{
 589:	55                   	push   %ebp
 58a:	89 e5                	mov    %esp,%ebp
 58c:	53                   	push   %ebx
 58d:	83 ec 04             	sub    $0x4,%esp
 590:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 592:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 597:	77 05                	ja     59e <morecore+0x15>
    nu = 4096;
 599:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 59e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	50                   	push   %eax
 5a9:	e8 c8 fc ff ff       	call   276 <sbrk>
  if(p == (char*)-1)
 5ae:	83 c4 10             	add    $0x10,%esp
 5b1:	83 f8 ff             	cmp    $0xffffffff,%eax
 5b4:	74 1c                	je     5d2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5b6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b9:	83 c0 08             	add    $0x8,%eax
 5bc:	83 ec 0c             	sub    $0xc,%esp
 5bf:	50                   	push   %eax
 5c0:	e8 54 ff ff ff       	call   519 <free>
  return freep;
 5c5:	a1 bc 09 00 00       	mov    0x9bc,%eax
 5ca:	83 c4 10             	add    $0x10,%esp
}
 5cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d0:	c9                   	leave  
 5d1:	c3                   	ret    
    return 0;
 5d2:	b8 00 00 00 00       	mov    $0x0,%eax
 5d7:	eb f4                	jmp    5cd <morecore+0x44>

000005d9 <malloc>:

void*
malloc(uint nbytes)
{
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
 5dc:	53                   	push   %ebx
 5dd:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e0:	8b 45 08             	mov    0x8(%ebp),%eax
 5e3:	8d 58 07             	lea    0x7(%eax),%ebx
 5e6:	c1 eb 03             	shr    $0x3,%ebx
 5e9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ec:	8b 0d bc 09 00 00    	mov    0x9bc,%ecx
 5f2:	85 c9                	test   %ecx,%ecx
 5f4:	74 04                	je     5fa <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f6:	8b 01                	mov    (%ecx),%eax
 5f8:	eb 4a                	jmp    644 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5fa:	c7 05 bc 09 00 00 c0 	movl   $0x9c0,0x9bc
 601:	09 00 00 
 604:	c7 05 c0 09 00 00 c0 	movl   $0x9c0,0x9c0
 60b:	09 00 00 
    base.s.size = 0;
 60e:	c7 05 c4 09 00 00 00 	movl   $0x0,0x9c4
 615:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 618:	b9 c0 09 00 00       	mov    $0x9c0,%ecx
 61d:	eb d7                	jmp    5f6 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 61f:	74 19                	je     63a <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 621:	29 da                	sub    %ebx,%edx
 623:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 626:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 629:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 62c:	89 0d bc 09 00 00    	mov    %ecx,0x9bc
      return (void*)(p + 1);
 632:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 638:	c9                   	leave  
 639:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 63a:	8b 10                	mov    (%eax),%edx
 63c:	89 11                	mov    %edx,(%ecx)
 63e:	eb ec                	jmp    62c <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 640:	89 c1                	mov    %eax,%ecx
 642:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 644:	8b 50 04             	mov    0x4(%eax),%edx
 647:	39 da                	cmp    %ebx,%edx
 649:	73 d4                	jae    61f <malloc+0x46>
    if(p == freep)
 64b:	39 05 bc 09 00 00    	cmp    %eax,0x9bc
 651:	75 ed                	jne    640 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 653:	89 d8                	mov    %ebx,%eax
 655:	e8 2f ff ff ff       	call   589 <morecore>
 65a:	85 c0                	test   %eax,%eax
 65c:	75 e2                	jne    640 <malloc+0x67>
 65e:	eb d5                	jmp    635 <malloc+0x5c>
