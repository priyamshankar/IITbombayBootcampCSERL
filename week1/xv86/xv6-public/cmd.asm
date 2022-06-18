
_cmd:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 71 04             	mov    0x4(%ecx),%esi
    if (argc <= 1)
  19:	83 ff 01             	cmp    $0x1,%edi
  1c:	7e 07                	jle    25 <main+0x25>
        printf(1, "please enter any existing argument like ls , echo and wc etc\n");
        printf(1, "example cmd ls or cmd echo priyam or cmd wc ls\n");
        exit();
    }
    char **args = argv;
    for (int i = 1; i < argc; i++)
  1e:	b8 01 00 00 00       	mov    $0x1,%eax
  23:	eb 3c                	jmp    61 <main+0x61>
        printf(1, "not any argument exititng the program\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 e8 06 00 00       	push   $0x6e8
  2d:	6a 01                	push   $0x1
  2f:	e8 07 04 00 00       	call   43b <printf>
        printf(1, "please enter any existing argument like ls , echo and wc etc\n");
  34:	83 c4 08             	add    $0x8,%esp
  37:	68 10 07 00 00       	push   $0x710
  3c:	6a 01                	push   $0x1
  3e:	e8 f8 03 00 00       	call   43b <printf>
        printf(1, "example cmd ls or cmd echo priyam or cmd wc ls\n");
  43:	83 c4 08             	add    $0x8,%esp
  46:	68 50 07 00 00       	push   $0x750
  4b:	6a 01                	push   $0x1
  4d:	e8 e9 03 00 00       	call   43b <printf>
        exit();
  52:	e8 ff 01 00 00       	call   256 <exit>
    {
        args[i - 1] = argv[i];
  57:	8b 14 86             	mov    (%esi,%eax,4),%edx
  5a:	89 54 86 fc          	mov    %edx,-0x4(%esi,%eax,4)
    for (int i = 1; i < argc; i++)
  5e:	83 c0 01             	add    $0x1,%eax
  61:	39 f8                	cmp    %edi,%eax
  63:	7c f2                	jl     57 <main+0x57>
    }
    args[argc - 1] = NULL;
  65:	c7 44 be fc 00 00 00 	movl   $0x0,-0x4(%esi,%edi,4)
  6c:	00 

    // Implement your code here
    for (int i = 0; i < argc; i++)
  6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  72:	eb 2c                	jmp    a0 <main+0xa0>
        {
            exit();
        }
        else
        {
            int reaped_pid = wait();
  74:	e8 e5 01 00 00       	call   25e <wait>
  79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            exec(argv[i], args);
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	56                   	push   %esi
  80:	ff 34 9e             	push   (%esi,%ebx,4)
  83:	e8 06 02 00 00       	call   28e <exec>
            printf(1, "%d", reaped_pid);
  88:	83 c4 0c             	add    $0xc,%esp
  8b:	ff 75 e4             	push   -0x1c(%ebp)
  8e:	68 80 07 00 00       	push   $0x780
  93:	6a 01                	push   $0x1
  95:	e8 a1 03 00 00       	call   43b <printf>
    for (int i = 0; i < argc; i++)
  9a:	83 c3 01             	add    $0x1,%ebx
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	39 fb                	cmp    %edi,%ebx
  a2:	7d 0e                	jge    b2 <main+0xb2>
        int ret = fork();
  a4:	e8 a5 01 00 00       	call   24e <fork>
        if (ret <= 0)
  a9:	85 c0                	test   %eax,%eax
  ab:	7f c7                	jg     74 <main+0x74>
            exit();
  ad:	e8 a4 01 00 00       	call   256 <exit>
        }
    }
    //
    // getppid(7);
    exit();
  b2:	e8 9f 01 00 00       	call   256 <exit>

000000b7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	56                   	push   %esi
  bb:	53                   	push   %ebx
  bc:	8b 75 08             	mov    0x8(%ebp),%esi
  bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c2:	89 f0                	mov    %esi,%eax
  c4:	89 d1                	mov    %edx,%ecx
  c6:	83 c2 01             	add    $0x1,%edx
  c9:	89 c3                	mov    %eax,%ebx
  cb:	83 c0 01             	add    $0x1,%eax
  ce:	0f b6 09             	movzbl (%ecx),%ecx
  d1:	88 0b                	mov    %cl,(%ebx)
  d3:	84 c9                	test   %cl,%cl
  d5:	75 ed                	jne    c4 <strcpy+0xd>
    ;
  return os;
}
  d7:	89 f0                	mov    %esi,%eax
  d9:	5b                   	pop    %ebx
  da:	5e                   	pop    %esi
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    

000000dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  e6:	eb 06                	jmp    ee <strcmp+0x11>
    p++, q++;
  e8:	83 c1 01             	add    $0x1,%ecx
  eb:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  ee:	0f b6 01             	movzbl (%ecx),%eax
  f1:	84 c0                	test   %al,%al
  f3:	74 04                	je     f9 <strcmp+0x1c>
  f5:	3a 02                	cmp    (%edx),%al
  f7:	74 ef                	je     e8 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  f9:	0f b6 c0             	movzbl %al,%eax
  fc:	0f b6 12             	movzbl (%edx),%edx
  ff:	29 d0                	sub    %edx,%eax
}
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    

00000103 <strlen>:

uint
strlen(const char *s)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 109:	b8 00 00 00 00       	mov    $0x0,%eax
 10e:	eb 03                	jmp    113 <strlen+0x10>
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 117:	75 f7                	jne    110 <strlen+0xd>
    ;
  return n;
}
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <memset>:

void*
memset(void *dst, int c, uint n)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	57                   	push   %edi
 11f:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 122:	89 d7                	mov    %edx,%edi
 124:	8b 4d 10             	mov    0x10(%ebp),%ecx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	fc                   	cld    
 12b:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 12d:	89 d0                	mov    %edx,%eax
 12f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 13e:	eb 03                	jmp    143 <strchr+0xf>
 140:	83 c0 01             	add    $0x1,%eax
 143:	0f b6 10             	movzbl (%eax),%edx
 146:	84 d2                	test   %dl,%dl
 148:	74 06                	je     150 <strchr+0x1c>
    if(*s == c)
 14a:	38 ca                	cmp    %cl,%dl
 14c:	75 f2                	jne    140 <strchr+0xc>
 14e:	eb 05                	jmp    155 <strchr+0x21>
      return (char*)s;
  return 0;
 150:	b8 00 00 00 00       	mov    $0x0,%eax
}
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <gets>:

char*
gets(char *buf, int max)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	57                   	push   %edi
 15b:	56                   	push   %esi
 15c:	53                   	push   %ebx
 15d:	83 ec 1c             	sub    $0x1c,%esp
 160:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 163:	bb 00 00 00 00       	mov    $0x0,%ebx
 168:	89 de                	mov    %ebx,%esi
 16a:	83 c3 01             	add    $0x1,%ebx
 16d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 170:	7d 2e                	jge    1a0 <gets+0x49>
    cc = read(0, &c, 1);
 172:	83 ec 04             	sub    $0x4,%esp
 175:	6a 01                	push   $0x1
 177:	8d 45 e7             	lea    -0x19(%ebp),%eax
 17a:	50                   	push   %eax
 17b:	6a 00                	push   $0x0
 17d:	e8 ec 00 00 00       	call   26e <read>
    if(cc < 1)
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	7e 17                	jle    1a0 <gets+0x49>
      break;
    buf[i++] = c;
 189:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 18d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 190:	3c 0a                	cmp    $0xa,%al
 192:	0f 94 c2             	sete   %dl
 195:	3c 0d                	cmp    $0xd,%al
 197:	0f 94 c0             	sete   %al
 19a:	08 c2                	or     %al,%dl
 19c:	74 ca                	je     168 <gets+0x11>
    buf[i++] = c;
 19e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1a0:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1a4:	89 f8                	mov    %edi,%eax
 1a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a9:	5b                   	pop    %ebx
 1aa:	5e                   	pop    %esi
 1ab:	5f                   	pop    %edi
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	56                   	push   %esi
 1b2:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	6a 00                	push   $0x0
 1b8:	ff 75 08             	push   0x8(%ebp)
 1bb:	e8 d6 00 00 00       	call   296 <open>
  if(fd < 0)
 1c0:	83 c4 10             	add    $0x10,%esp
 1c3:	85 c0                	test   %eax,%eax
 1c5:	78 24                	js     1eb <stat+0x3d>
 1c7:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	ff 75 0c             	push   0xc(%ebp)
 1cf:	50                   	push   %eax
 1d0:	e8 d9 00 00 00       	call   2ae <fstat>
 1d5:	89 c6                	mov    %eax,%esi
  close(fd);
 1d7:	89 1c 24             	mov    %ebx,(%esp)
 1da:	e8 9f 00 00 00       	call   27e <close>
  return r;
 1df:	83 c4 10             	add    $0x10,%esp
}
 1e2:	89 f0                	mov    %esi,%eax
 1e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e7:	5b                   	pop    %ebx
 1e8:	5e                   	pop    %esi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    
    return -1;
 1eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f0:	eb f0                	jmp    1e2 <stat+0x34>

000001f2 <atoi>:

int
atoi(const char *s)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	53                   	push   %ebx
 1f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1f9:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1fe:	eb 10                	jmp    210 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 200:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 203:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 206:	83 c1 01             	add    $0x1,%ecx
 209:	0f be c0             	movsbl %al,%eax
 20c:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 210:	0f b6 01             	movzbl (%ecx),%eax
 213:	8d 58 d0             	lea    -0x30(%eax),%ebx
 216:	80 fb 09             	cmp    $0x9,%bl
 219:	76 e5                	jbe    200 <atoi+0xe>
  return n;
}
 21b:	89 d0                	mov    %edx,%eax
 21d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	56                   	push   %esi
 226:	53                   	push   %ebx
 227:	8b 75 08             	mov    0x8(%ebp),%esi
 22a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 22d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 230:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 232:	eb 0d                	jmp    241 <memmove+0x1f>
    *dst++ = *src++;
 234:	0f b6 01             	movzbl (%ecx),%eax
 237:	88 02                	mov    %al,(%edx)
 239:	8d 49 01             	lea    0x1(%ecx),%ecx
 23c:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 23f:	89 d8                	mov    %ebx,%eax
 241:	8d 58 ff             	lea    -0x1(%eax),%ebx
 244:	85 c0                	test   %eax,%eax
 246:	7f ec                	jg     234 <memmove+0x12>
  return vdst;
}
 248:	89 f0                	mov    %esi,%eax
 24a:	5b                   	pop    %ebx
 24b:	5e                   	pop    %esi
 24c:	5d                   	pop    %ebp
 24d:	c3                   	ret    

0000024e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 24e:	b8 01 00 00 00       	mov    $0x1,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <exit>:
SYSCALL(exit)
 256:	b8 02 00 00 00       	mov    $0x2,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <wait>:
SYSCALL(wait)
 25e:	b8 03 00 00 00       	mov    $0x3,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <pipe>:
SYSCALL(pipe)
 266:	b8 04 00 00 00       	mov    $0x4,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <read>:
SYSCALL(read)
 26e:	b8 05 00 00 00       	mov    $0x5,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <write>:
SYSCALL(write)
 276:	b8 10 00 00 00       	mov    $0x10,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <close>:
SYSCALL(close)
 27e:	b8 15 00 00 00       	mov    $0x15,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <kill>:
SYSCALL(kill)
 286:	b8 06 00 00 00       	mov    $0x6,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <exec>:
SYSCALL(exec)
 28e:	b8 07 00 00 00       	mov    $0x7,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <open>:
SYSCALL(open)
 296:	b8 0f 00 00 00       	mov    $0xf,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <mknod>:
SYSCALL(mknod)
 29e:	b8 11 00 00 00       	mov    $0x11,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <unlink>:
SYSCALL(unlink)
 2a6:	b8 12 00 00 00       	mov    $0x12,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <fstat>:
SYSCALL(fstat)
 2ae:	b8 08 00 00 00       	mov    $0x8,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <link>:
SYSCALL(link)
 2b6:	b8 13 00 00 00       	mov    $0x13,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <mkdir>:
SYSCALL(mkdir)
 2be:	b8 14 00 00 00       	mov    $0x14,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <chdir>:
SYSCALL(chdir)
 2c6:	b8 09 00 00 00       	mov    $0x9,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <dup>:
SYSCALL(dup)
 2ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <getpid>:
SYSCALL(getpid)
 2d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <sbrk>:
SYSCALL(sbrk)
 2de:	b8 0c 00 00 00       	mov    $0xc,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <sleep>:
SYSCALL(sleep)
 2e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <uptime>:
SYSCALL(uptime)
 2ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <hello>:
SYSCALL(hello)
 2f6:	b8 16 00 00 00       	mov    $0x16,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <helloYou>:
SYSCALL(helloYou)
 2fe:	b8 17 00 00 00       	mov    $0x17,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <getppid>:
SYSCALL(getppid)
 306:	b8 18 00 00 00       	mov    $0x18,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <get_siblings_info>:
SYSCALL(get_siblings_info)
 30e:	b8 19 00 00 00       	mov    $0x19,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <signalProcess>:
SYSCALL(signalProcess)
 316:	b8 1a 00 00 00       	mov    $0x1a,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <numvp>:
SYSCALL(numvp)
 31e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <numpp>:
SYSCALL(numpp)
 326:	b8 1c 00 00 00       	mov    $0x1c,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <init_counter>:

SYSCALL(init_counter)
 32e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <update_cnt>:
SYSCALL(update_cnt)
 336:	b8 1e 00 00 00       	mov    $0x1e,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <display_count>:
SYSCALL(display_count)
 33e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <init_counter_1>:
SYSCALL(init_counter_1)
 346:	b8 20 00 00 00       	mov    $0x20,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <update_cnt_1>:
SYSCALL(update_cnt_1)
 34e:	b8 21 00 00 00       	mov    $0x21,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <display_count_1>:
SYSCALL(display_count_1)
 356:	b8 22 00 00 00       	mov    $0x22,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <init_counter_2>:
SYSCALL(init_counter_2)
 35e:	b8 23 00 00 00       	mov    $0x23,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <update_cnt_2>:
SYSCALL(update_cnt_2)
 366:	b8 24 00 00 00       	mov    $0x24,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <display_count_2>:
SYSCALL(display_count_2)
 36e:	b8 25 00 00 00       	mov    $0x25,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <init_mylock>:
SYSCALL(init_mylock)
 376:	b8 26 00 00 00       	mov    $0x26,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <acquire_mylock>:
SYSCALL(acquire_mylock)
 37e:	b8 27 00 00 00       	mov    $0x27,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <release_mylock>:
SYSCALL(release_mylock)
 386:	b8 28 00 00 00       	mov    $0x28,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <holding_mylock>:
 38e:	b8 29 00 00 00       	mov    $0x29,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 1c             	sub    $0x1c,%esp
 39c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 39f:	6a 01                	push   $0x1
 3a1:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3a4:	52                   	push   %edx
 3a5:	50                   	push   %eax
 3a6:	e8 cb fe ff ff       	call   276 <write>
}
 3ab:	83 c4 10             	add    $0x10,%esp
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 2c             	sub    $0x2c,%esp
 3b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3bc:	89 d0                	mov    %edx,%eax
 3be:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3c4:	0f 95 c1             	setne  %cl
 3c7:	c1 ea 1f             	shr    $0x1f,%edx
 3ca:	84 d1                	test   %dl,%cl
 3cc:	74 44                	je     412 <printint+0x62>
    neg = 1;
    x = -xx;
 3ce:	f7 d8                	neg    %eax
 3d0:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3d2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3de:	89 c8                	mov    %ecx,%eax
 3e0:	ba 00 00 00 00       	mov    $0x0,%edx
 3e5:	f7 f6                	div    %esi
 3e7:	89 df                	mov    %ebx,%edi
 3e9:	83 c3 01             	add    $0x1,%ebx
 3ec:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
 3f3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3f7:	89 ca                	mov    %ecx,%edx
 3f9:	89 c1                	mov    %eax,%ecx
 3fb:	39 d6                	cmp    %edx,%esi
 3fd:	76 df                	jbe    3de <printint+0x2e>
  if(neg)
 3ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 403:	74 31                	je     436 <printint+0x86>
    buf[i++] = '-';
 405:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 40a:	8d 5f 02             	lea    0x2(%edi),%ebx
 40d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 410:	eb 17                	jmp    429 <printint+0x79>
    x = xx;
 412:	89 c1                	mov    %eax,%ecx
  neg = 0;
 414:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 41b:	eb bc                	jmp    3d9 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 41d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 422:	89 f0                	mov    %esi,%eax
 424:	e8 6d ff ff ff       	call   396 <putc>
  while(--i >= 0)
 429:	83 eb 01             	sub    $0x1,%ebx
 42c:	79 ef                	jns    41d <printint+0x6d>
}
 42e:	83 c4 2c             	add    $0x2c,%esp
 431:	5b                   	pop    %ebx
 432:	5e                   	pop    %esi
 433:	5f                   	pop    %edi
 434:	5d                   	pop    %ebp
 435:	c3                   	ret    
 436:	8b 75 d0             	mov    -0x30(%ebp),%esi
 439:	eb ee                	jmp    429 <printint+0x79>

0000043b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	57                   	push   %edi
 43f:	56                   	push   %esi
 440:	53                   	push   %ebx
 441:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 444:	8d 45 10             	lea    0x10(%ebp),%eax
 447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 44a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 44f:	bb 00 00 00 00       	mov    $0x0,%ebx
 454:	eb 14                	jmp    46a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 456:	89 fa                	mov    %edi,%edx
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	e8 36 ff ff ff       	call   396 <putc>
 460:	eb 05                	jmp    467 <printf+0x2c>
      }
    } else if(state == '%'){
 462:	83 fe 25             	cmp    $0x25,%esi
 465:	74 25                	je     48c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 467:	83 c3 01             	add    $0x1,%ebx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 471:	84 c0                	test   %al,%al
 473:	0f 84 20 01 00 00    	je     599 <printf+0x15e>
    c = fmt[i] & 0xff;
 479:	0f be f8             	movsbl %al,%edi
 47c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 47f:	85 f6                	test   %esi,%esi
 481:	75 df                	jne    462 <printf+0x27>
      if(c == '%'){
 483:	83 f8 25             	cmp    $0x25,%eax
 486:	75 ce                	jne    456 <printf+0x1b>
        state = '%';
 488:	89 c6                	mov    %eax,%esi
 48a:	eb db                	jmp    467 <printf+0x2c>
      if(c == 'd'){
 48c:	83 f8 25             	cmp    $0x25,%eax
 48f:	0f 84 cf 00 00 00    	je     564 <printf+0x129>
 495:	0f 8c dd 00 00 00    	jl     578 <printf+0x13d>
 49b:	83 f8 78             	cmp    $0x78,%eax
 49e:	0f 8f d4 00 00 00    	jg     578 <printf+0x13d>
 4a4:	83 f8 63             	cmp    $0x63,%eax
 4a7:	0f 8c cb 00 00 00    	jl     578 <printf+0x13d>
 4ad:	83 e8 63             	sub    $0x63,%eax
 4b0:	83 f8 15             	cmp    $0x15,%eax
 4b3:	0f 87 bf 00 00 00    	ja     578 <printf+0x13d>
 4b9:	ff 24 85 8c 07 00 00 	jmp    *0x78c(,%eax,4)
        printint(fd, *ap, 10, 1);
 4c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c3:	8b 17                	mov    (%edi),%edx
 4c5:	83 ec 0c             	sub    $0xc,%esp
 4c8:	6a 01                	push   $0x1
 4ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	e8 d9 fe ff ff       	call   3b0 <printint>
        ap++;
 4d7:	83 c7 04             	add    $0x4,%edi
 4da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4dd:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e0:	be 00 00 00 00       	mov    $0x0,%esi
 4e5:	eb 80                	jmp    467 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ea:	8b 17                	mov    (%edi),%edx
 4ec:	83 ec 0c             	sub    $0xc,%esp
 4ef:	6a 00                	push   $0x0
 4f1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
 4f9:	e8 b2 fe ff ff       	call   3b0 <printint>
        ap++;
 4fe:	83 c7 04             	add    $0x4,%edi
 501:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 504:	83 c4 10             	add    $0x10,%esp
      state = 0;
 507:	be 00 00 00 00       	mov    $0x0,%esi
 50c:	e9 56 ff ff ff       	jmp    467 <printf+0x2c>
        s = (char*)*ap;
 511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 514:	8b 30                	mov    (%eax),%esi
        ap++;
 516:	83 c0 04             	add    $0x4,%eax
 519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 51c:	85 f6                	test   %esi,%esi
 51e:	75 15                	jne    535 <printf+0xfa>
          s = "(null)";
 520:	be 83 07 00 00       	mov    $0x783,%esi
 525:	eb 0e                	jmp    535 <printf+0xfa>
          putc(fd, *s);
 527:	0f be d2             	movsbl %dl,%edx
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	e8 64 fe ff ff       	call   396 <putc>
          s++;
 532:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 535:	0f b6 16             	movzbl (%esi),%edx
 538:	84 d2                	test   %dl,%dl
 53a:	75 eb                	jne    527 <printf+0xec>
      state = 0;
 53c:	be 00 00 00 00       	mov    $0x0,%esi
 541:	e9 21 ff ff ff       	jmp    467 <printf+0x2c>
        putc(fd, *ap);
 546:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 549:	0f be 17             	movsbl (%edi),%edx
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	e8 42 fe ff ff       	call   396 <putc>
        ap++;
 554:	83 c7 04             	add    $0x4,%edi
 557:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 55a:	be 00 00 00 00       	mov    $0x0,%esi
 55f:	e9 03 ff ff ff       	jmp    467 <printf+0x2c>
        putc(fd, c);
 564:	89 fa                	mov    %edi,%edx
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	e8 28 fe ff ff       	call   396 <putc>
      state = 0;
 56e:	be 00 00 00 00       	mov    $0x0,%esi
 573:	e9 ef fe ff ff       	jmp    467 <printf+0x2c>
        putc(fd, '%');
 578:	ba 25 00 00 00       	mov    $0x25,%edx
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	e8 11 fe ff ff       	call   396 <putc>
        putc(fd, c);
 585:	89 fa                	mov    %edi,%edx
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	e8 07 fe ff ff       	call   396 <putc>
      state = 0;
 58f:	be 00 00 00 00       	mov    $0x0,%esi
 594:	e9 ce fe ff ff       	jmp    467 <printf+0x2c>
    }
  }
}
 599:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59c:	5b                   	pop    %ebx
 59d:	5e                   	pop    %esi
 59e:	5f                   	pop    %edi
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret    

000005a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	57                   	push   %edi
 5a5:	56                   	push   %esi
 5a6:	53                   	push   %ebx
 5a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5aa:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ad:	a1 90 0a 00 00       	mov    0xa90,%eax
 5b2:	eb 02                	jmp    5b6 <free+0x15>
 5b4:	89 d0                	mov    %edx,%eax
 5b6:	39 c8                	cmp    %ecx,%eax
 5b8:	73 04                	jae    5be <free+0x1d>
 5ba:	39 08                	cmp    %ecx,(%eax)
 5bc:	77 12                	ja     5d0 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5be:	8b 10                	mov    (%eax),%edx
 5c0:	39 c2                	cmp    %eax,%edx
 5c2:	77 f0                	ja     5b4 <free+0x13>
 5c4:	39 c8                	cmp    %ecx,%eax
 5c6:	72 08                	jb     5d0 <free+0x2f>
 5c8:	39 ca                	cmp    %ecx,%edx
 5ca:	77 04                	ja     5d0 <free+0x2f>
 5cc:	89 d0                	mov    %edx,%eax
 5ce:	eb e6                	jmp    5b6 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5d6:	8b 10                	mov    (%eax),%edx
 5d8:	39 d7                	cmp    %edx,%edi
 5da:	74 19                	je     5f5 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5dc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5df:	8b 50 04             	mov    0x4(%eax),%edx
 5e2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5e5:	39 ce                	cmp    %ecx,%esi
 5e7:	74 1b                	je     604 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5e9:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5eb:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 5f0:	5b                   	pop    %ebx
 5f1:	5e                   	pop    %esi
 5f2:	5f                   	pop    %edi
 5f3:	5d                   	pop    %ebp
 5f4:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5f5:	03 72 04             	add    0x4(%edx),%esi
 5f8:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5fb:	8b 10                	mov    (%eax),%edx
 5fd:	8b 12                	mov    (%edx),%edx
 5ff:	89 53 f8             	mov    %edx,-0x8(%ebx)
 602:	eb db                	jmp    5df <free+0x3e>
    p->s.size += bp->s.size;
 604:	03 53 fc             	add    -0x4(%ebx),%edx
 607:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 60a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 60d:	89 10                	mov    %edx,(%eax)
 60f:	eb da                	jmp    5eb <free+0x4a>

00000611 <morecore>:

static Header*
morecore(uint nu)
{
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	53                   	push   %ebx
 615:	83 ec 04             	sub    $0x4,%esp
 618:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 61a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 61f:	77 05                	ja     626 <morecore+0x15>
    nu = 4096;
 621:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 626:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 62d:	83 ec 0c             	sub    $0xc,%esp
 630:	50                   	push   %eax
 631:	e8 a8 fc ff ff       	call   2de <sbrk>
  if(p == (char*)-1)
 636:	83 c4 10             	add    $0x10,%esp
 639:	83 f8 ff             	cmp    $0xffffffff,%eax
 63c:	74 1c                	je     65a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 63e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 641:	83 c0 08             	add    $0x8,%eax
 644:	83 ec 0c             	sub    $0xc,%esp
 647:	50                   	push   %eax
 648:	e8 54 ff ff ff       	call   5a1 <free>
  return freep;
 64d:	a1 90 0a 00 00       	mov    0xa90,%eax
 652:	83 c4 10             	add    $0x10,%esp
}
 655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 658:	c9                   	leave  
 659:	c3                   	ret    
    return 0;
 65a:	b8 00 00 00 00       	mov    $0x0,%eax
 65f:	eb f4                	jmp    655 <morecore+0x44>

00000661 <malloc>:

void*
malloc(uint nbytes)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	53                   	push   %ebx
 665:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	8d 58 07             	lea    0x7(%eax),%ebx
 66e:	c1 eb 03             	shr    $0x3,%ebx
 671:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 674:	8b 0d 90 0a 00 00    	mov    0xa90,%ecx
 67a:	85 c9                	test   %ecx,%ecx
 67c:	74 04                	je     682 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67e:	8b 01                	mov    (%ecx),%eax
 680:	eb 4a                	jmp    6cc <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 682:	c7 05 90 0a 00 00 94 	movl   $0xa94,0xa90
 689:	0a 00 00 
 68c:	c7 05 94 0a 00 00 94 	movl   $0xa94,0xa94
 693:	0a 00 00 
    base.s.size = 0;
 696:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 69d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6a0:	b9 94 0a 00 00       	mov    $0xa94,%ecx
 6a5:	eb d7                	jmp    67e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6a7:	74 19                	je     6c2 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6a9:	29 da                	sub    %ebx,%edx
 6ab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6ae:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6b1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6b4:	89 0d 90 0a 00 00    	mov    %ecx,0xa90
      return (void*)(p + 1);
 6ba:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	89 11                	mov    %edx,(%ecx)
 6c6:	eb ec                	jmp    6b4 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c8:	89 c1                	mov    %eax,%ecx
 6ca:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	39 da                	cmp    %ebx,%edx
 6d1:	73 d4                	jae    6a7 <malloc+0x46>
    if(p == freep)
 6d3:	39 05 90 0a 00 00    	cmp    %eax,0xa90
 6d9:	75 ed                	jne    6c8 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6db:	89 d8                	mov    %ebx,%eax
 6dd:	e8 2f ff ff ff       	call   611 <morecore>
 6e2:	85 c0                	test   %eax,%eax
 6e4:	75 e2                	jne    6c8 <malloc+0x67>
 6e6:	eb d5                	jmp    6bd <malloc+0x5c>
