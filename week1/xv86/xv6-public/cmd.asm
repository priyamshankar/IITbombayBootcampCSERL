
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
  28:	68 70 06 00 00       	push   $0x670
  2d:	6a 01                	push   $0x1
  2f:	e8 8f 03 00 00       	call   3c3 <printf>
        printf(1, "please enter any existing argument like ls , echo and wc etc\n");
  34:	83 c4 08             	add    $0x8,%esp
  37:	68 98 06 00 00       	push   $0x698
  3c:	6a 01                	push   $0x1
  3e:	e8 80 03 00 00       	call   3c3 <printf>
        printf(1, "example cmd ls or cmd echo priyam or cmd wc ls\n");
  43:	83 c4 08             	add    $0x8,%esp
  46:	68 d8 06 00 00       	push   $0x6d8
  4b:	6a 01                	push   $0x1
  4d:	e8 71 03 00 00       	call   3c3 <printf>
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
  8e:	68 08 07 00 00       	push   $0x708
  93:	6a 01                	push   $0x1
  95:	e8 29 03 00 00       	call   3c3 <printf>
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
 316:	b8 1a 00 00 00       	mov    $0x1a,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 1c             	sub    $0x1c,%esp
 324:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 327:	6a 01                	push   $0x1
 329:	8d 55 f4             	lea    -0xc(%ebp),%edx
 32c:	52                   	push   %edx
 32d:	50                   	push   %eax
 32e:	e8 43 ff ff ff       	call   276 <write>
}
 333:	83 c4 10             	add    $0x10,%esp
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	57                   	push   %edi
 33c:	56                   	push   %esi
 33d:	53                   	push   %ebx
 33e:	83 ec 2c             	sub    $0x2c,%esp
 341:	89 45 d0             	mov    %eax,-0x30(%ebp)
 344:	89 d0                	mov    %edx,%eax
 346:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 34c:	0f 95 c1             	setne  %cl
 34f:	c1 ea 1f             	shr    $0x1f,%edx
 352:	84 d1                	test   %dl,%cl
 354:	74 44                	je     39a <printint+0x62>
    neg = 1;
    x = -xx;
 356:	f7 d8                	neg    %eax
 358:	89 c1                	mov    %eax,%ecx
    neg = 1;
 35a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 361:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 366:	89 c8                	mov    %ecx,%eax
 368:	ba 00 00 00 00       	mov    $0x0,%edx
 36d:	f7 f6                	div    %esi
 36f:	89 df                	mov    %ebx,%edi
 371:	83 c3 01             	add    $0x1,%ebx
 374:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
 37b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 37f:	89 ca                	mov    %ecx,%edx
 381:	89 c1                	mov    %eax,%ecx
 383:	39 d6                	cmp    %edx,%esi
 385:	76 df                	jbe    366 <printint+0x2e>
  if(neg)
 387:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 38b:	74 31                	je     3be <printint+0x86>
    buf[i++] = '-';
 38d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 392:	8d 5f 02             	lea    0x2(%edi),%ebx
 395:	8b 75 d0             	mov    -0x30(%ebp),%esi
 398:	eb 17                	jmp    3b1 <printint+0x79>
    x = xx;
 39a:	89 c1                	mov    %eax,%ecx
  neg = 0;
 39c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3a3:	eb bc                	jmp    361 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3a5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3aa:	89 f0                	mov    %esi,%eax
 3ac:	e8 6d ff ff ff       	call   31e <putc>
  while(--i >= 0)
 3b1:	83 eb 01             	sub    $0x1,%ebx
 3b4:	79 ef                	jns    3a5 <printint+0x6d>
}
 3b6:	83 c4 2c             	add    $0x2c,%esp
 3b9:	5b                   	pop    %ebx
 3ba:	5e                   	pop    %esi
 3bb:	5f                   	pop    %edi
 3bc:	5d                   	pop    %ebp
 3bd:	c3                   	ret    
 3be:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3c1:	eb ee                	jmp    3b1 <printint+0x79>

000003c3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	57                   	push   %edi
 3c7:	56                   	push   %esi
 3c8:	53                   	push   %ebx
 3c9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3cc:	8d 45 10             	lea    0x10(%ebp),%eax
 3cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3d2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3d7:	bb 00 00 00 00       	mov    $0x0,%ebx
 3dc:	eb 14                	jmp    3f2 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3de:	89 fa                	mov    %edi,%edx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	e8 36 ff ff ff       	call   31e <putc>
 3e8:	eb 05                	jmp    3ef <printf+0x2c>
      }
    } else if(state == '%'){
 3ea:	83 fe 25             	cmp    $0x25,%esi
 3ed:	74 25                	je     414 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3ef:	83 c3 01             	add    $0x1,%ebx
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	0f 84 20 01 00 00    	je     521 <printf+0x15e>
    c = fmt[i] & 0xff;
 401:	0f be f8             	movsbl %al,%edi
 404:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 407:	85 f6                	test   %esi,%esi
 409:	75 df                	jne    3ea <printf+0x27>
      if(c == '%'){
 40b:	83 f8 25             	cmp    $0x25,%eax
 40e:	75 ce                	jne    3de <printf+0x1b>
        state = '%';
 410:	89 c6                	mov    %eax,%esi
 412:	eb db                	jmp    3ef <printf+0x2c>
      if(c == 'd'){
 414:	83 f8 25             	cmp    $0x25,%eax
 417:	0f 84 cf 00 00 00    	je     4ec <printf+0x129>
 41d:	0f 8c dd 00 00 00    	jl     500 <printf+0x13d>
 423:	83 f8 78             	cmp    $0x78,%eax
 426:	0f 8f d4 00 00 00    	jg     500 <printf+0x13d>
 42c:	83 f8 63             	cmp    $0x63,%eax
 42f:	0f 8c cb 00 00 00    	jl     500 <printf+0x13d>
 435:	83 e8 63             	sub    $0x63,%eax
 438:	83 f8 15             	cmp    $0x15,%eax
 43b:	0f 87 bf 00 00 00    	ja     500 <printf+0x13d>
 441:	ff 24 85 14 07 00 00 	jmp    *0x714(,%eax,4)
        printint(fd, *ap, 10, 1);
 448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 44b:	8b 17                	mov    (%edi),%edx
 44d:	83 ec 0c             	sub    $0xc,%esp
 450:	6a 01                	push   $0x1
 452:	b9 0a 00 00 00       	mov    $0xa,%ecx
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	e8 d9 fe ff ff       	call   338 <printint>
        ap++;
 45f:	83 c7 04             	add    $0x4,%edi
 462:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 465:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 468:	be 00 00 00 00       	mov    $0x0,%esi
 46d:	eb 80                	jmp    3ef <printf+0x2c>
        printint(fd, *ap, 16, 0);
 46f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 472:	8b 17                	mov    (%edi),%edx
 474:	83 ec 0c             	sub    $0xc,%esp
 477:	6a 00                	push   $0x0
 479:	b9 10 00 00 00       	mov    $0x10,%ecx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 b2 fe ff ff       	call   338 <printint>
        ap++;
 486:	83 c7 04             	add    $0x4,%edi
 489:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 48c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48f:	be 00 00 00 00       	mov    $0x0,%esi
 494:	e9 56 ff ff ff       	jmp    3ef <printf+0x2c>
        s = (char*)*ap;
 499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49c:	8b 30                	mov    (%eax),%esi
        ap++;
 49e:	83 c0 04             	add    $0x4,%eax
 4a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4a4:	85 f6                	test   %esi,%esi
 4a6:	75 15                	jne    4bd <printf+0xfa>
          s = "(null)";
 4a8:	be 0b 07 00 00       	mov    $0x70b,%esi
 4ad:	eb 0e                	jmp    4bd <printf+0xfa>
          putc(fd, *s);
 4af:	0f be d2             	movsbl %dl,%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	e8 64 fe ff ff       	call   31e <putc>
          s++;
 4ba:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4bd:	0f b6 16             	movzbl (%esi),%edx
 4c0:	84 d2                	test   %dl,%dl
 4c2:	75 eb                	jne    4af <printf+0xec>
      state = 0;
 4c4:	be 00 00 00 00       	mov    $0x0,%esi
 4c9:	e9 21 ff ff ff       	jmp    3ef <printf+0x2c>
        putc(fd, *ap);
 4ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d1:	0f be 17             	movsbl (%edi),%edx
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
 4d7:	e8 42 fe ff ff       	call   31e <putc>
        ap++;
 4dc:	83 c7 04             	add    $0x4,%edi
 4df:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4e2:	be 00 00 00 00       	mov    $0x0,%esi
 4e7:	e9 03 ff ff ff       	jmp    3ef <printf+0x2c>
        putc(fd, c);
 4ec:	89 fa                	mov    %edi,%edx
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	e8 28 fe ff ff       	call   31e <putc>
      state = 0;
 4f6:	be 00 00 00 00       	mov    $0x0,%esi
 4fb:	e9 ef fe ff ff       	jmp    3ef <printf+0x2c>
        putc(fd, '%');
 500:	ba 25 00 00 00       	mov    $0x25,%edx
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	e8 11 fe ff ff       	call   31e <putc>
        putc(fd, c);
 50d:	89 fa                	mov    %edi,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 07 fe ff ff       	call   31e <putc>
      state = 0;
 517:	be 00 00 00 00       	mov    $0x0,%esi
 51c:	e9 ce fe ff ff       	jmp    3ef <printf+0x2c>
    }
  }
}
 521:	8d 65 f4             	lea    -0xc(%ebp),%esp
 524:	5b                   	pop    %ebx
 525:	5e                   	pop    %esi
 526:	5f                   	pop    %edi
 527:	5d                   	pop    %ebp
 528:	c3                   	ret    

00000529 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	57                   	push   %edi
 52d:	56                   	push   %esi
 52e:	53                   	push   %ebx
 52f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 532:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 535:	a1 18 0a 00 00       	mov    0xa18,%eax
 53a:	eb 02                	jmp    53e <free+0x15>
 53c:	89 d0                	mov    %edx,%eax
 53e:	39 c8                	cmp    %ecx,%eax
 540:	73 04                	jae    546 <free+0x1d>
 542:	39 08                	cmp    %ecx,(%eax)
 544:	77 12                	ja     558 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 546:	8b 10                	mov    (%eax),%edx
 548:	39 c2                	cmp    %eax,%edx
 54a:	77 f0                	ja     53c <free+0x13>
 54c:	39 c8                	cmp    %ecx,%eax
 54e:	72 08                	jb     558 <free+0x2f>
 550:	39 ca                	cmp    %ecx,%edx
 552:	77 04                	ja     558 <free+0x2f>
 554:	89 d0                	mov    %edx,%eax
 556:	eb e6                	jmp    53e <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 558:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55e:	8b 10                	mov    (%eax),%edx
 560:	39 d7                	cmp    %edx,%edi
 562:	74 19                	je     57d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 564:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 567:	8b 50 04             	mov    0x4(%eax),%edx
 56a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56d:	39 ce                	cmp    %ecx,%esi
 56f:	74 1b                	je     58c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 571:	89 08                	mov    %ecx,(%eax)
  freep = p;
 573:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 578:	5b                   	pop    %ebx
 579:	5e                   	pop    %esi
 57a:	5f                   	pop    %edi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 57d:	03 72 04             	add    0x4(%edx),%esi
 580:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 583:	8b 10                	mov    (%eax),%edx
 585:	8b 12                	mov    (%edx),%edx
 587:	89 53 f8             	mov    %edx,-0x8(%ebx)
 58a:	eb db                	jmp    567 <free+0x3e>
    p->s.size += bp->s.size;
 58c:	03 53 fc             	add    -0x4(%ebx),%edx
 58f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 592:	8b 53 f8             	mov    -0x8(%ebx),%edx
 595:	89 10                	mov    %edx,(%eax)
 597:	eb da                	jmp    573 <free+0x4a>

00000599 <morecore>:

static Header*
morecore(uint nu)
{
 599:	55                   	push   %ebp
 59a:	89 e5                	mov    %esp,%ebp
 59c:	53                   	push   %ebx
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5a2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5a7:	77 05                	ja     5ae <morecore+0x15>
    nu = 4096;
 5a9:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5ae:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5b5:	83 ec 0c             	sub    $0xc,%esp
 5b8:	50                   	push   %eax
 5b9:	e8 20 fd ff ff       	call   2de <sbrk>
  if(p == (char*)-1)
 5be:	83 c4 10             	add    $0x10,%esp
 5c1:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c4:	74 1c                	je     5e2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5c6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5c9:	83 c0 08             	add    $0x8,%eax
 5cc:	83 ec 0c             	sub    $0xc,%esp
 5cf:	50                   	push   %eax
 5d0:	e8 54 ff ff ff       	call   529 <free>
  return freep;
 5d5:	a1 18 0a 00 00       	mov    0xa18,%eax
 5da:	83 c4 10             	add    $0x10,%esp
}
 5dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e0:	c9                   	leave  
 5e1:	c3                   	ret    
    return 0;
 5e2:	b8 00 00 00 00       	mov    $0x0,%eax
 5e7:	eb f4                	jmp    5dd <morecore+0x44>

000005e9 <malloc>:

void*
malloc(uint nbytes)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	53                   	push   %ebx
 5ed:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	8d 58 07             	lea    0x7(%eax),%ebx
 5f6:	c1 eb 03             	shr    $0x3,%ebx
 5f9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5fc:	8b 0d 18 0a 00 00    	mov    0xa18,%ecx
 602:	85 c9                	test   %ecx,%ecx
 604:	74 04                	je     60a <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 606:	8b 01                	mov    (%ecx),%eax
 608:	eb 4a                	jmp    654 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 60a:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 611:	0a 00 00 
 614:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 61b:	0a 00 00 
    base.s.size = 0;
 61e:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 625:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 628:	b9 1c 0a 00 00       	mov    $0xa1c,%ecx
 62d:	eb d7                	jmp    606 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 62f:	74 19                	je     64a <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 631:	29 da                	sub    %ebx,%edx
 633:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 636:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 639:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 63c:	89 0d 18 0a 00 00    	mov    %ecx,0xa18
      return (void*)(p + 1);
 642:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 648:	c9                   	leave  
 649:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 64a:	8b 10                	mov    (%eax),%edx
 64c:	89 11                	mov    %edx,(%ecx)
 64e:	eb ec                	jmp    63c <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	89 c1                	mov    %eax,%ecx
 652:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 654:	8b 50 04             	mov    0x4(%eax),%edx
 657:	39 da                	cmp    %ebx,%edx
 659:	73 d4                	jae    62f <malloc+0x46>
    if(p == freep)
 65b:	39 05 18 0a 00 00    	cmp    %eax,0xa18
 661:	75 ed                	jne    650 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 663:	89 d8                	mov    %ebx,%eax
 665:	e8 2f ff ff ff       	call   599 <morecore>
 66a:	85 c0                	test   %eax,%eax
 66c:	75 e2                	jne    650 <malloc+0x67>
 66e:	eb d5                	jmp    645 <malloc+0x5c>
