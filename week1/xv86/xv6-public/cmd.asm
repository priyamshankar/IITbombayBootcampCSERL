
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
  28:	68 c8 06 00 00       	push   $0x6c8
  2d:	6a 01                	push   $0x1
  2f:	e8 e7 03 00 00       	call   41b <printf>
        printf(1, "please enter any existing argument like ls , echo and wc etc\n");
  34:	83 c4 08             	add    $0x8,%esp
  37:	68 f0 06 00 00       	push   $0x6f0
  3c:	6a 01                	push   $0x1
  3e:	e8 d8 03 00 00       	call   41b <printf>
        printf(1, "example cmd ls or cmd echo priyam or cmd wc ls\n");
  43:	83 c4 08             	add    $0x8,%esp
  46:	68 30 07 00 00       	push   $0x730
  4b:	6a 01                	push   $0x1
  4d:	e8 c9 03 00 00       	call   41b <printf>
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
  8e:	68 60 07 00 00       	push   $0x760
  93:	6a 01                	push   $0x1
  95:	e8 81 03 00 00       	call   41b <printf>
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
 36e:	b8 25 00 00 00       	mov    $0x25,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	83 ec 1c             	sub    $0x1c,%esp
 37c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 37f:	6a 01                	push   $0x1
 381:	8d 55 f4             	lea    -0xc(%ebp),%edx
 384:	52                   	push   %edx
 385:	50                   	push   %eax
 386:	e8 eb fe ff ff       	call   276 <write>
}
 38b:	83 c4 10             	add    $0x10,%esp
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 2c             	sub    $0x2c,%esp
 399:	89 45 d0             	mov    %eax,-0x30(%ebp)
 39c:	89 d0                	mov    %edx,%eax
 39e:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a4:	0f 95 c1             	setne  %cl
 3a7:	c1 ea 1f             	shr    $0x1f,%edx
 3aa:	84 d1                	test   %dl,%cl
 3ac:	74 44                	je     3f2 <printint+0x62>
    neg = 1;
    x = -xx;
 3ae:	f7 d8                	neg    %eax
 3b0:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3be:	89 c8                	mov    %ecx,%eax
 3c0:	ba 00 00 00 00       	mov    $0x0,%edx
 3c5:	f7 f6                	div    %esi
 3c7:	89 df                	mov    %ebx,%edi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	0f b6 92 c4 07 00 00 	movzbl 0x7c4(%edx),%edx
 3d3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3d7:	89 ca                	mov    %ecx,%edx
 3d9:	89 c1                	mov    %eax,%ecx
 3db:	39 d6                	cmp    %edx,%esi
 3dd:	76 df                	jbe    3be <printint+0x2e>
  if(neg)
 3df:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3e3:	74 31                	je     416 <printint+0x86>
    buf[i++] = '-';
 3e5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ea:	8d 5f 02             	lea    0x2(%edi),%ebx
 3ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f0:	eb 17                	jmp    409 <printint+0x79>
    x = xx;
 3f2:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3fb:	eb bc                	jmp    3b9 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3fd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 402:	89 f0                	mov    %esi,%eax
 404:	e8 6d ff ff ff       	call   376 <putc>
  while(--i >= 0)
 409:	83 eb 01             	sub    $0x1,%ebx
 40c:	79 ef                	jns    3fd <printint+0x6d>
}
 40e:	83 c4 2c             	add    $0x2c,%esp
 411:	5b                   	pop    %ebx
 412:	5e                   	pop    %esi
 413:	5f                   	pop    %edi
 414:	5d                   	pop    %ebp
 415:	c3                   	ret    
 416:	8b 75 d0             	mov    -0x30(%ebp),%esi
 419:	eb ee                	jmp    409 <printint+0x79>

0000041b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	57                   	push   %edi
 41f:	56                   	push   %esi
 420:	53                   	push   %ebx
 421:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 424:	8d 45 10             	lea    0x10(%ebp),%eax
 427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 42a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 42f:	bb 00 00 00 00       	mov    $0x0,%ebx
 434:	eb 14                	jmp    44a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 436:	89 fa                	mov    %edi,%edx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 36 ff ff ff       	call   376 <putc>
 440:	eb 05                	jmp    447 <printf+0x2c>
      }
    } else if(state == '%'){
 442:	83 fe 25             	cmp    $0x25,%esi
 445:	74 25                	je     46c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 447:	83 c3 01             	add    $0x1,%ebx
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 451:	84 c0                	test   %al,%al
 453:	0f 84 20 01 00 00    	je     579 <printf+0x15e>
    c = fmt[i] & 0xff;
 459:	0f be f8             	movsbl %al,%edi
 45c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 45f:	85 f6                	test   %esi,%esi
 461:	75 df                	jne    442 <printf+0x27>
      if(c == '%'){
 463:	83 f8 25             	cmp    $0x25,%eax
 466:	75 ce                	jne    436 <printf+0x1b>
        state = '%';
 468:	89 c6                	mov    %eax,%esi
 46a:	eb db                	jmp    447 <printf+0x2c>
      if(c == 'd'){
 46c:	83 f8 25             	cmp    $0x25,%eax
 46f:	0f 84 cf 00 00 00    	je     544 <printf+0x129>
 475:	0f 8c dd 00 00 00    	jl     558 <printf+0x13d>
 47b:	83 f8 78             	cmp    $0x78,%eax
 47e:	0f 8f d4 00 00 00    	jg     558 <printf+0x13d>
 484:	83 f8 63             	cmp    $0x63,%eax
 487:	0f 8c cb 00 00 00    	jl     558 <printf+0x13d>
 48d:	83 e8 63             	sub    $0x63,%eax
 490:	83 f8 15             	cmp    $0x15,%eax
 493:	0f 87 bf 00 00 00    	ja     558 <printf+0x13d>
 499:	ff 24 85 6c 07 00 00 	jmp    *0x76c(,%eax,4)
        printint(fd, *ap, 10, 1);
 4a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a3:	8b 17                	mov    (%edi),%edx
 4a5:	83 ec 0c             	sub    $0xc,%esp
 4a8:	6a 01                	push   $0x1
 4aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	e8 d9 fe ff ff       	call   390 <printint>
        ap++;
 4b7:	83 c7 04             	add    $0x4,%edi
 4ba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4bd:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c0:	be 00 00 00 00       	mov    $0x0,%esi
 4c5:	eb 80                	jmp    447 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ca:	8b 17                	mov    (%edi),%edx
 4cc:	83 ec 0c             	sub    $0xc,%esp
 4cf:	6a 00                	push   $0x0
 4d1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	e8 b2 fe ff ff       	call   390 <printint>
        ap++;
 4de:	83 c7 04             	add    $0x4,%edi
 4e1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e7:	be 00 00 00 00       	mov    $0x0,%esi
 4ec:	e9 56 ff ff ff       	jmp    447 <printf+0x2c>
        s = (char*)*ap;
 4f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f4:	8b 30                	mov    (%eax),%esi
        ap++;
 4f6:	83 c0 04             	add    $0x4,%eax
 4f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4fc:	85 f6                	test   %esi,%esi
 4fe:	75 15                	jne    515 <printf+0xfa>
          s = "(null)";
 500:	be 63 07 00 00       	mov    $0x763,%esi
 505:	eb 0e                	jmp    515 <printf+0xfa>
          putc(fd, *s);
 507:	0f be d2             	movsbl %dl,%edx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	e8 64 fe ff ff       	call   376 <putc>
          s++;
 512:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 515:	0f b6 16             	movzbl (%esi),%edx
 518:	84 d2                	test   %dl,%dl
 51a:	75 eb                	jne    507 <printf+0xec>
      state = 0;
 51c:	be 00 00 00 00       	mov    $0x0,%esi
 521:	e9 21 ff ff ff       	jmp    447 <printf+0x2c>
        putc(fd, *ap);
 526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 529:	0f be 17             	movsbl (%edi),%edx
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	e8 42 fe ff ff       	call   376 <putc>
        ap++;
 534:	83 c7 04             	add    $0x4,%edi
 537:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 53a:	be 00 00 00 00       	mov    $0x0,%esi
 53f:	e9 03 ff ff ff       	jmp    447 <printf+0x2c>
        putc(fd, c);
 544:	89 fa                	mov    %edi,%edx
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	e8 28 fe ff ff       	call   376 <putc>
      state = 0;
 54e:	be 00 00 00 00       	mov    $0x0,%esi
 553:	e9 ef fe ff ff       	jmp    447 <printf+0x2c>
        putc(fd, '%');
 558:	ba 25 00 00 00       	mov    $0x25,%edx
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	e8 11 fe ff ff       	call   376 <putc>
        putc(fd, c);
 565:	89 fa                	mov    %edi,%edx
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	e8 07 fe ff ff       	call   376 <putc>
      state = 0;
 56f:	be 00 00 00 00       	mov    $0x0,%esi
 574:	e9 ce fe ff ff       	jmp    447 <printf+0x2c>
    }
  }
}
 579:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57c:	5b                   	pop    %ebx
 57d:	5e                   	pop    %esi
 57e:	5f                   	pop    %edi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret    

00000581 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	57                   	push   %edi
 585:	56                   	push   %esi
 586:	53                   	push   %ebx
 587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 58a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 58d:	a1 70 0a 00 00       	mov    0xa70,%eax
 592:	eb 02                	jmp    596 <free+0x15>
 594:	89 d0                	mov    %edx,%eax
 596:	39 c8                	cmp    %ecx,%eax
 598:	73 04                	jae    59e <free+0x1d>
 59a:	39 08                	cmp    %ecx,(%eax)
 59c:	77 12                	ja     5b0 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59e:	8b 10                	mov    (%eax),%edx
 5a0:	39 c2                	cmp    %eax,%edx
 5a2:	77 f0                	ja     594 <free+0x13>
 5a4:	39 c8                	cmp    %ecx,%eax
 5a6:	72 08                	jb     5b0 <free+0x2f>
 5a8:	39 ca                	cmp    %ecx,%edx
 5aa:	77 04                	ja     5b0 <free+0x2f>
 5ac:	89 d0                	mov    %edx,%eax
 5ae:	eb e6                	jmp    596 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5b6:	8b 10                	mov    (%eax),%edx
 5b8:	39 d7                	cmp    %edx,%edi
 5ba:	74 19                	je     5d5 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5bc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5bf:	8b 50 04             	mov    0x4(%eax),%edx
 5c2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c5:	39 ce                	cmp    %ecx,%esi
 5c7:	74 1b                	je     5e4 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5c9:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5cb:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 5d0:	5b                   	pop    %ebx
 5d1:	5e                   	pop    %esi
 5d2:	5f                   	pop    %edi
 5d3:	5d                   	pop    %ebp
 5d4:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5d5:	03 72 04             	add    0x4(%edx),%esi
 5d8:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5db:	8b 10                	mov    (%eax),%edx
 5dd:	8b 12                	mov    (%edx),%edx
 5df:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5e2:	eb db                	jmp    5bf <free+0x3e>
    p->s.size += bp->s.size;
 5e4:	03 53 fc             	add    -0x4(%ebx),%edx
 5e7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ed:	89 10                	mov    %edx,(%eax)
 5ef:	eb da                	jmp    5cb <free+0x4a>

000005f1 <morecore>:

static Header*
morecore(uint nu)
{
 5f1:	55                   	push   %ebp
 5f2:	89 e5                	mov    %esp,%ebp
 5f4:	53                   	push   %ebx
 5f5:	83 ec 04             	sub    $0x4,%esp
 5f8:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5fa:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5ff:	77 05                	ja     606 <morecore+0x15>
    nu = 4096;
 601:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 606:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 60d:	83 ec 0c             	sub    $0xc,%esp
 610:	50                   	push   %eax
 611:	e8 c8 fc ff ff       	call   2de <sbrk>
  if(p == (char*)-1)
 616:	83 c4 10             	add    $0x10,%esp
 619:	83 f8 ff             	cmp    $0xffffffff,%eax
 61c:	74 1c                	je     63a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 61e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 621:	83 c0 08             	add    $0x8,%eax
 624:	83 ec 0c             	sub    $0xc,%esp
 627:	50                   	push   %eax
 628:	e8 54 ff ff ff       	call   581 <free>
  return freep;
 62d:	a1 70 0a 00 00       	mov    0xa70,%eax
 632:	83 c4 10             	add    $0x10,%esp
}
 635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 638:	c9                   	leave  
 639:	c3                   	ret    
    return 0;
 63a:	b8 00 00 00 00       	mov    $0x0,%eax
 63f:	eb f4                	jmp    635 <morecore+0x44>

00000641 <malloc>:

void*
malloc(uint nbytes)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	53                   	push   %ebx
 645:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	8d 58 07             	lea    0x7(%eax),%ebx
 64e:	c1 eb 03             	shr    $0x3,%ebx
 651:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 654:	8b 0d 70 0a 00 00    	mov    0xa70,%ecx
 65a:	85 c9                	test   %ecx,%ecx
 65c:	74 04                	je     662 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 65e:	8b 01                	mov    (%ecx),%eax
 660:	eb 4a                	jmp    6ac <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 662:	c7 05 70 0a 00 00 74 	movl   $0xa74,0xa70
 669:	0a 00 00 
 66c:	c7 05 74 0a 00 00 74 	movl   $0xa74,0xa74
 673:	0a 00 00 
    base.s.size = 0;
 676:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 67d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 680:	b9 74 0a 00 00       	mov    $0xa74,%ecx
 685:	eb d7                	jmp    65e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 687:	74 19                	je     6a2 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 689:	29 da                	sub    %ebx,%edx
 68b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 68e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 691:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 694:	89 0d 70 0a 00 00    	mov    %ecx,0xa70
      return (void*)(p + 1);
 69a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 69d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a0:	c9                   	leave  
 6a1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	89 11                	mov    %edx,(%ecx)
 6a6:	eb ec                	jmp    694 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	89 c1                	mov    %eax,%ecx
 6aa:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	39 da                	cmp    %ebx,%edx
 6b1:	73 d4                	jae    687 <malloc+0x46>
    if(p == freep)
 6b3:	39 05 70 0a 00 00    	cmp    %eax,0xa70
 6b9:	75 ed                	jne    6a8 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6bb:	89 d8                	mov    %ebx,%eax
 6bd:	e8 2f ff ff ff       	call   5f1 <morecore>
 6c2:	85 c0                	test   %eax,%eax
 6c4:	75 e2                	jne    6a8 <malloc+0x67>
 6c6:	eb d5                	jmp    69d <malloc+0x5c>
