
_tes:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define MAX_SZ 1000000
#define SIGNAL_PAUSE "PAUSE"
#define SIGNAL_CONTINUE "CONTINUE"
#define SIGNAL_KILL "KILL"
int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    //     printf(1, "parent %d\n", getpid());
    //     wait();
    // }

	// signalProcess(ret, SIGNAL_PAUSE);
    int ret = fork();
  11:	e8 c1 01 00 00       	call   1d7 <fork>
	if(ret == 0) 
  16:	85 c0                	test   %eax,%eax
  18:	75 13                	jne    2d <main+0x2d>
		// for (int i = 0; i < MAX_SZ; ++i)
		// {
		// 	sleep(5e1);
		// 	printf(1, "child: Not_paused\n");
		// }
	signalProcess(ret, SIGNAL_PAUSE);
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 54 06 00 00       	push   $0x654
  22:	50                   	push   %eax
  23:	e8 77 02 00 00       	call   29f <signalProcess>

		exit();
  28:	e8 b2 01 00 00       	call   1df <exit>
	}
	signalProcess(ret, SIGNAL_KILL);
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 5a 06 00 00       	push   $0x65a
  35:	50                   	push   %eax
  36:	e8 64 02 00 00       	call   29f <signalProcess>
    // printf(1,"fork no.: %d\n",ret);
    // get_siblings_info();
    // printf(1, "pid= %d and ppid is = %d\n", getpid(), getppid());
    // printf(1, "fork ret = %d", ret);
    // wait();
    exit();
  3b:	e8 9f 01 00 00       	call   1df <exit>

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  45:	8b 75 08             	mov    0x8(%ebp),%esi
  48:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4b:	89 f0                	mov    %esi,%eax
  4d:	89 d1                	mov    %edx,%ecx
  4f:	83 c2 01             	add    $0x1,%edx
  52:	89 c3                	mov    %eax,%ebx
  54:	83 c0 01             	add    $0x1,%eax
  57:	0f b6 09             	movzbl (%ecx),%ecx
  5a:	88 0b                	mov    %cl,(%ebx)
  5c:	84 c9                	test   %cl,%cl
  5e:	75 ed                	jne    4d <strcpy+0xd>
    ;
  return os;
}
  60:	89 f0                	mov    %esi,%eax
  62:	5b                   	pop    %ebx
  63:	5e                   	pop    %esi
  64:	5d                   	pop    %ebp
  65:	c3                   	ret    

00000066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  66:	55                   	push   %ebp
  67:	89 e5                	mov    %esp,%ebp
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  6f:	eb 06                	jmp    77 <strcmp+0x11>
    p++, q++;
  71:	83 c1 01             	add    $0x1,%ecx
  74:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  77:	0f b6 01             	movzbl (%ecx),%eax
  7a:	84 c0                	test   %al,%al
  7c:	74 04                	je     82 <strcmp+0x1c>
  7e:	3a 02                	cmp    (%edx),%al
  80:	74 ef                	je     71 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  82:	0f b6 c0             	movzbl %al,%eax
  85:	0f b6 12             	movzbl (%edx),%edx
  88:	29 d0                	sub    %edx,%eax
}
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  92:	b8 00 00 00 00       	mov    $0x0,%eax
  97:	eb 03                	jmp    9c <strlen+0x10>
  99:	83 c0 01             	add    $0x1,%eax
  9c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  a0:	75 f7                	jne    99 <strlen+0xd>
    ;
  return n;
}
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    

000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	57                   	push   %edi
  a8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ab:	89 d7                	mov    %edx,%edi
  ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  b3:	fc                   	cld    
  b4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b6:	89 d0                	mov    %edx,%eax
  b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strchr>:

char*
strchr(const char *s, char c)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c7:	eb 03                	jmp    cc <strchr+0xf>
  c9:	83 c0 01             	add    $0x1,%eax
  cc:	0f b6 10             	movzbl (%eax),%edx
  cf:	84 d2                	test   %dl,%dl
  d1:	74 06                	je     d9 <strchr+0x1c>
    if(*s == c)
  d3:	38 ca                	cmp    %cl,%dl
  d5:	75 f2                	jne    c9 <strchr+0xc>
  d7:	eb 05                	jmp    de <strchr+0x21>
      return (char*)s;
  return 0;
  d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <gets>:

char*
gets(char *buf, int max)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	83 ec 1c             	sub    $0x1c,%esp
  e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  f1:	89 de                	mov    %ebx,%esi
  f3:	83 c3 01             	add    $0x1,%ebx
  f6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  f9:	7d 2e                	jge    129 <gets+0x49>
    cc = read(0, &c, 1);
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	6a 01                	push   $0x1
 100:	8d 45 e7             	lea    -0x19(%ebp),%eax
 103:	50                   	push   %eax
 104:	6a 00                	push   $0x0
 106:	e8 ec 00 00 00       	call   1f7 <read>
    if(cc < 1)
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	85 c0                	test   %eax,%eax
 110:	7e 17                	jle    129 <gets+0x49>
      break;
    buf[i++] = c;
 112:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 116:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 119:	3c 0a                	cmp    $0xa,%al
 11b:	0f 94 c2             	sete   %dl
 11e:	3c 0d                	cmp    $0xd,%al
 120:	0f 94 c0             	sete   %al
 123:	08 c2                	or     %al,%dl
 125:	74 ca                	je     f1 <gets+0x11>
    buf[i++] = c;
 127:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 129:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 12d:	89 f8                	mov    %edi,%eax
 12f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 132:	5b                   	pop    %ebx
 133:	5e                   	pop    %esi
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    

00000137 <stat>:

int
stat(const char *n, struct stat *st)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 08             	push   0x8(%ebp)
 144:	e8 d6 00 00 00       	call   21f <open>
  if(fd < 0)
 149:	83 c4 10             	add    $0x10,%esp
 14c:	85 c0                	test   %eax,%eax
 14e:	78 24                	js     174 <stat+0x3d>
 150:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 152:	83 ec 08             	sub    $0x8,%esp
 155:	ff 75 0c             	push   0xc(%ebp)
 158:	50                   	push   %eax
 159:	e8 d9 00 00 00       	call   237 <fstat>
 15e:	89 c6                	mov    %eax,%esi
  close(fd);
 160:	89 1c 24             	mov    %ebx,(%esp)
 163:	e8 9f 00 00 00       	call   207 <close>
  return r;
 168:	83 c4 10             	add    $0x10,%esp
}
 16b:	89 f0                	mov    %esi,%eax
 16d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 170:	5b                   	pop    %ebx
 171:	5e                   	pop    %esi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
    return -1;
 174:	be ff ff ff ff       	mov    $0xffffffff,%esi
 179:	eb f0                	jmp    16b <stat+0x34>

0000017b <atoi>:

int
atoi(const char *s)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	53                   	push   %ebx
 17f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 182:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 187:	eb 10                	jmp    199 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 189:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 18c:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 18f:	83 c1 01             	add    $0x1,%ecx
 192:	0f be c0             	movsbl %al,%eax
 195:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 199:	0f b6 01             	movzbl (%ecx),%eax
 19c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 19f:	80 fb 09             	cmp    $0x9,%bl
 1a2:	76 e5                	jbe    189 <atoi+0xe>
  return n;
}
 1a4:	89 d0                	mov    %edx,%eax
 1a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	56                   	push   %esi
 1af:	53                   	push   %ebx
 1b0:	8b 75 08             	mov    0x8(%ebp),%esi
 1b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1b6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1b9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1bb:	eb 0d                	jmp    1ca <memmove+0x1f>
    *dst++ = *src++;
 1bd:	0f b6 01             	movzbl (%ecx),%eax
 1c0:	88 02                	mov    %al,(%edx)
 1c2:	8d 49 01             	lea    0x1(%ecx),%ecx
 1c5:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1c8:	89 d8                	mov    %ebx,%eax
 1ca:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1cd:	85 c0                	test   %eax,%eax
 1cf:	7f ec                	jg     1bd <memmove+0x12>
  return vdst;
}
 1d1:	89 f0                	mov    %esi,%eax
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    

000001d7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1d7:	b8 01 00 00 00       	mov    $0x1,%eax
 1dc:	cd 40                	int    $0x40
 1de:	c3                   	ret    

000001df <exit>:
SYSCALL(exit)
 1df:	b8 02 00 00 00       	mov    $0x2,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <wait>:
SYSCALL(wait)
 1e7:	b8 03 00 00 00       	mov    $0x3,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <pipe>:
SYSCALL(pipe)
 1ef:	b8 04 00 00 00       	mov    $0x4,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <read>:
SYSCALL(read)
 1f7:	b8 05 00 00 00       	mov    $0x5,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <write>:
SYSCALL(write)
 1ff:	b8 10 00 00 00       	mov    $0x10,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <close>:
SYSCALL(close)
 207:	b8 15 00 00 00       	mov    $0x15,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <kill>:
SYSCALL(kill)
 20f:	b8 06 00 00 00       	mov    $0x6,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <exec>:
SYSCALL(exec)
 217:	b8 07 00 00 00       	mov    $0x7,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <open>:
SYSCALL(open)
 21f:	b8 0f 00 00 00       	mov    $0xf,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <mknod>:
SYSCALL(mknod)
 227:	b8 11 00 00 00       	mov    $0x11,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <unlink>:
SYSCALL(unlink)
 22f:	b8 12 00 00 00       	mov    $0x12,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <fstat>:
SYSCALL(fstat)
 237:	b8 08 00 00 00       	mov    $0x8,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <link>:
SYSCALL(link)
 23f:	b8 13 00 00 00       	mov    $0x13,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <mkdir>:
SYSCALL(mkdir)
 247:	b8 14 00 00 00       	mov    $0x14,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <chdir>:
SYSCALL(chdir)
 24f:	b8 09 00 00 00       	mov    $0x9,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <dup>:
SYSCALL(dup)
 257:	b8 0a 00 00 00       	mov    $0xa,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <getpid>:
SYSCALL(getpid)
 25f:	b8 0b 00 00 00       	mov    $0xb,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <sbrk>:
SYSCALL(sbrk)
 267:	b8 0c 00 00 00       	mov    $0xc,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <sleep>:
SYSCALL(sleep)
 26f:	b8 0d 00 00 00       	mov    $0xd,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <uptime>:
SYSCALL(uptime)
 277:	b8 0e 00 00 00       	mov    $0xe,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <hello>:
SYSCALL(hello)
 27f:	b8 16 00 00 00       	mov    $0x16,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <helloYou>:
SYSCALL(helloYou)
 287:	b8 17 00 00 00       	mov    $0x17,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <getppid>:
SYSCALL(getppid)
 28f:	b8 18 00 00 00       	mov    $0x18,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <get_siblings_info>:
SYSCALL(get_siblings_info)
 297:	b8 19 00 00 00       	mov    $0x19,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <signalProcess>:
SYSCALL(signalProcess)
 29f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <numvp>:
SYSCALL(numvp)
 2a7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <numpp>:
SYSCALL(numpp)
 2af:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <init_counter>:

SYSCALL(init_counter)
 2b7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <update_cnt>:
SYSCALL(update_cnt)
 2bf:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <display_count>:
SYSCALL(display_count)
 2c7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <init_counter_1>:
SYSCALL(init_counter_1)
 2cf:	b8 20 00 00 00       	mov    $0x20,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2d7:	b8 21 00 00 00       	mov    $0x21,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <display_count_1>:
SYSCALL(display_count_1)
 2df:	b8 22 00 00 00       	mov    $0x22,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <init_counter_2>:
SYSCALL(init_counter_2)
 2e7:	b8 23 00 00 00       	mov    $0x23,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <update_cnt_2>:
SYSCALL(update_cnt_2)
 2ef:	b8 24 00 00 00       	mov    $0x24,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <display_count_2>:
 2f7:	b8 25 00 00 00       	mov    $0x25,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ff:	55                   	push   %ebp
 300:	89 e5                	mov    %esp,%ebp
 302:	83 ec 1c             	sub    $0x1c,%esp
 305:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 308:	6a 01                	push   $0x1
 30a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 30d:	52                   	push   %edx
 30e:	50                   	push   %eax
 30f:	e8 eb fe ff ff       	call   1ff <write>
}
 314:	83 c4 10             	add    $0x10,%esp
 317:	c9                   	leave  
 318:	c3                   	ret    

00000319 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 319:	55                   	push   %ebp
 31a:	89 e5                	mov    %esp,%ebp
 31c:	57                   	push   %edi
 31d:	56                   	push   %esi
 31e:	53                   	push   %ebx
 31f:	83 ec 2c             	sub    $0x2c,%esp
 322:	89 45 d0             	mov    %eax,-0x30(%ebp)
 325:	89 d0                	mov    %edx,%eax
 327:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 32d:	0f 95 c1             	setne  %cl
 330:	c1 ea 1f             	shr    $0x1f,%edx
 333:	84 d1                	test   %dl,%cl
 335:	74 44                	je     37b <printint+0x62>
    neg = 1;
    x = -xx;
 337:	f7 d8                	neg    %eax
 339:	89 c1                	mov    %eax,%ecx
    neg = 1;
 33b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 342:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 347:	89 c8                	mov    %ecx,%eax
 349:	ba 00 00 00 00       	mov    $0x0,%edx
 34e:	f7 f6                	div    %esi
 350:	89 df                	mov    %ebx,%edi
 352:	83 c3 01             	add    $0x1,%ebx
 355:	0f b6 92 c0 06 00 00 	movzbl 0x6c0(%edx),%edx
 35c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 360:	89 ca                	mov    %ecx,%edx
 362:	89 c1                	mov    %eax,%ecx
 364:	39 d6                	cmp    %edx,%esi
 366:	76 df                	jbe    347 <printint+0x2e>
  if(neg)
 368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 36c:	74 31                	je     39f <printint+0x86>
    buf[i++] = '-';
 36e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 373:	8d 5f 02             	lea    0x2(%edi),%ebx
 376:	8b 75 d0             	mov    -0x30(%ebp),%esi
 379:	eb 17                	jmp    392 <printint+0x79>
    x = xx;
 37b:	89 c1                	mov    %eax,%ecx
  neg = 0;
 37d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 384:	eb bc                	jmp    342 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 386:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 38b:	89 f0                	mov    %esi,%eax
 38d:	e8 6d ff ff ff       	call   2ff <putc>
  while(--i >= 0)
 392:	83 eb 01             	sub    $0x1,%ebx
 395:	79 ef                	jns    386 <printint+0x6d>
}
 397:	83 c4 2c             	add    $0x2c,%esp
 39a:	5b                   	pop    %ebx
 39b:	5e                   	pop    %esi
 39c:	5f                   	pop    %edi
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    
 39f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3a2:	eb ee                	jmp    392 <printint+0x79>

000003a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	57                   	push   %edi
 3a8:	56                   	push   %esi
 3a9:	53                   	push   %ebx
 3aa:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ad:	8d 45 10             	lea    0x10(%ebp),%eax
 3b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3b3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3b8:	bb 00 00 00 00       	mov    $0x0,%ebx
 3bd:	eb 14                	jmp    3d3 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3bf:	89 fa                	mov    %edi,%edx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	e8 36 ff ff ff       	call   2ff <putc>
 3c9:	eb 05                	jmp    3d0 <printf+0x2c>
      }
    } else if(state == '%'){
 3cb:	83 fe 25             	cmp    $0x25,%esi
 3ce:	74 25                	je     3f5 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3d0:	83 c3 01             	add    $0x1,%ebx
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3da:	84 c0                	test   %al,%al
 3dc:	0f 84 20 01 00 00    	je     502 <printf+0x15e>
    c = fmt[i] & 0xff;
 3e2:	0f be f8             	movsbl %al,%edi
 3e5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3e8:	85 f6                	test   %esi,%esi
 3ea:	75 df                	jne    3cb <printf+0x27>
      if(c == '%'){
 3ec:	83 f8 25             	cmp    $0x25,%eax
 3ef:	75 ce                	jne    3bf <printf+0x1b>
        state = '%';
 3f1:	89 c6                	mov    %eax,%esi
 3f3:	eb db                	jmp    3d0 <printf+0x2c>
      if(c == 'd'){
 3f5:	83 f8 25             	cmp    $0x25,%eax
 3f8:	0f 84 cf 00 00 00    	je     4cd <printf+0x129>
 3fe:	0f 8c dd 00 00 00    	jl     4e1 <printf+0x13d>
 404:	83 f8 78             	cmp    $0x78,%eax
 407:	0f 8f d4 00 00 00    	jg     4e1 <printf+0x13d>
 40d:	83 f8 63             	cmp    $0x63,%eax
 410:	0f 8c cb 00 00 00    	jl     4e1 <printf+0x13d>
 416:	83 e8 63             	sub    $0x63,%eax
 419:	83 f8 15             	cmp    $0x15,%eax
 41c:	0f 87 bf 00 00 00    	ja     4e1 <printf+0x13d>
 422:	ff 24 85 68 06 00 00 	jmp    *0x668(,%eax,4)
        printint(fd, *ap, 10, 1);
 429:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42c:	8b 17                	mov    (%edi),%edx
 42e:	83 ec 0c             	sub    $0xc,%esp
 431:	6a 01                	push   $0x1
 433:	b9 0a 00 00 00       	mov    $0xa,%ecx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 d9 fe ff ff       	call   319 <printint>
        ap++;
 440:	83 c7 04             	add    $0x4,%edi
 443:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 446:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 449:	be 00 00 00 00       	mov    $0x0,%esi
 44e:	eb 80                	jmp    3d0 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 453:	8b 17                	mov    (%edi),%edx
 455:	83 ec 0c             	sub    $0xc,%esp
 458:	6a 00                	push   $0x0
 45a:	b9 10 00 00 00       	mov    $0x10,%ecx
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	e8 b2 fe ff ff       	call   319 <printint>
        ap++;
 467:	83 c7 04             	add    $0x4,%edi
 46a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 46d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 470:	be 00 00 00 00       	mov    $0x0,%esi
 475:	e9 56 ff ff ff       	jmp    3d0 <printf+0x2c>
        s = (char*)*ap;
 47a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47d:	8b 30                	mov    (%eax),%esi
        ap++;
 47f:	83 c0 04             	add    $0x4,%eax
 482:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 485:	85 f6                	test   %esi,%esi
 487:	75 15                	jne    49e <printf+0xfa>
          s = "(null)";
 489:	be 5f 06 00 00       	mov    $0x65f,%esi
 48e:	eb 0e                	jmp    49e <printf+0xfa>
          putc(fd, *s);
 490:	0f be d2             	movsbl %dl,%edx
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	e8 64 fe ff ff       	call   2ff <putc>
          s++;
 49b:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 49e:	0f b6 16             	movzbl (%esi),%edx
 4a1:	84 d2                	test   %dl,%dl
 4a3:	75 eb                	jne    490 <printf+0xec>
      state = 0;
 4a5:	be 00 00 00 00       	mov    $0x0,%esi
 4aa:	e9 21 ff ff ff       	jmp    3d0 <printf+0x2c>
        putc(fd, *ap);
 4af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b2:	0f be 17             	movsbl (%edi),%edx
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	e8 42 fe ff ff       	call   2ff <putc>
        ap++;
 4bd:	83 c7 04             	add    $0x4,%edi
 4c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4c3:	be 00 00 00 00       	mov    $0x0,%esi
 4c8:	e9 03 ff ff ff       	jmp    3d0 <printf+0x2c>
        putc(fd, c);
 4cd:	89 fa                	mov    %edi,%edx
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	e8 28 fe ff ff       	call   2ff <putc>
      state = 0;
 4d7:	be 00 00 00 00       	mov    $0x0,%esi
 4dc:	e9 ef fe ff ff       	jmp    3d0 <printf+0x2c>
        putc(fd, '%');
 4e1:	ba 25 00 00 00       	mov    $0x25,%edx
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	e8 11 fe ff ff       	call   2ff <putc>
        putc(fd, c);
 4ee:	89 fa                	mov    %edi,%edx
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	e8 07 fe ff ff       	call   2ff <putc>
      state = 0;
 4f8:	be 00 00 00 00       	mov    $0x0,%esi
 4fd:	e9 ce fe ff ff       	jmp    3d0 <printf+0x2c>
    }
  }
}
 502:	8d 65 f4             	lea    -0xc(%ebp),%esp
 505:	5b                   	pop    %ebx
 506:	5e                   	pop    %esi
 507:	5f                   	pop    %edi
 508:	5d                   	pop    %ebp
 509:	c3                   	ret    

0000050a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 50a:	55                   	push   %ebp
 50b:	89 e5                	mov    %esp,%ebp
 50d:	57                   	push   %edi
 50e:	56                   	push   %esi
 50f:	53                   	push   %ebx
 510:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 513:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 516:	a1 60 09 00 00       	mov    0x960,%eax
 51b:	eb 02                	jmp    51f <free+0x15>
 51d:	89 d0                	mov    %edx,%eax
 51f:	39 c8                	cmp    %ecx,%eax
 521:	73 04                	jae    527 <free+0x1d>
 523:	39 08                	cmp    %ecx,(%eax)
 525:	77 12                	ja     539 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 527:	8b 10                	mov    (%eax),%edx
 529:	39 c2                	cmp    %eax,%edx
 52b:	77 f0                	ja     51d <free+0x13>
 52d:	39 c8                	cmp    %ecx,%eax
 52f:	72 08                	jb     539 <free+0x2f>
 531:	39 ca                	cmp    %ecx,%edx
 533:	77 04                	ja     539 <free+0x2f>
 535:	89 d0                	mov    %edx,%eax
 537:	eb e6                	jmp    51f <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 539:	8b 73 fc             	mov    -0x4(%ebx),%esi
 53c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 53f:	8b 10                	mov    (%eax),%edx
 541:	39 d7                	cmp    %edx,%edi
 543:	74 19                	je     55e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 545:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 548:	8b 50 04             	mov    0x4(%eax),%edx
 54b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 54e:	39 ce                	cmp    %ecx,%esi
 550:	74 1b                	je     56d <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 552:	89 08                	mov    %ecx,(%eax)
  freep = p;
 554:	a3 60 09 00 00       	mov    %eax,0x960
}
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5f                   	pop    %edi
 55c:	5d                   	pop    %ebp
 55d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 55e:	03 72 04             	add    0x4(%edx),%esi
 561:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 564:	8b 10                	mov    (%eax),%edx
 566:	8b 12                	mov    (%edx),%edx
 568:	89 53 f8             	mov    %edx,-0x8(%ebx)
 56b:	eb db                	jmp    548 <free+0x3e>
    p->s.size += bp->s.size;
 56d:	03 53 fc             	add    -0x4(%ebx),%edx
 570:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 573:	8b 53 f8             	mov    -0x8(%ebx),%edx
 576:	89 10                	mov    %edx,(%eax)
 578:	eb da                	jmp    554 <free+0x4a>

0000057a <morecore>:

static Header*
morecore(uint nu)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	53                   	push   %ebx
 57e:	83 ec 04             	sub    $0x4,%esp
 581:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 583:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 588:	77 05                	ja     58f <morecore+0x15>
    nu = 4096;
 58a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 58f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 596:	83 ec 0c             	sub    $0xc,%esp
 599:	50                   	push   %eax
 59a:	e8 c8 fc ff ff       	call   267 <sbrk>
  if(p == (char*)-1)
 59f:	83 c4 10             	add    $0x10,%esp
 5a2:	83 f8 ff             	cmp    $0xffffffff,%eax
 5a5:	74 1c                	je     5c3 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5a7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5aa:	83 c0 08             	add    $0x8,%eax
 5ad:	83 ec 0c             	sub    $0xc,%esp
 5b0:	50                   	push   %eax
 5b1:	e8 54 ff ff ff       	call   50a <free>
  return freep;
 5b6:	a1 60 09 00 00       	mov    0x960,%eax
 5bb:	83 c4 10             	add    $0x10,%esp
}
 5be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    
    return 0;
 5c3:	b8 00 00 00 00       	mov    $0x0,%eax
 5c8:	eb f4                	jmp    5be <morecore+0x44>

000005ca <malloc>:

void*
malloc(uint nbytes)
{
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	53                   	push   %ebx
 5ce:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	8d 58 07             	lea    0x7(%eax),%ebx
 5d7:	c1 eb 03             	shr    $0x3,%ebx
 5da:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5dd:	8b 0d 60 09 00 00    	mov    0x960,%ecx
 5e3:	85 c9                	test   %ecx,%ecx
 5e5:	74 04                	je     5eb <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e7:	8b 01                	mov    (%ecx),%eax
 5e9:	eb 4a                	jmp    635 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5eb:	c7 05 60 09 00 00 64 	movl   $0x964,0x960
 5f2:	09 00 00 
 5f5:	c7 05 64 09 00 00 64 	movl   $0x964,0x964
 5fc:	09 00 00 
    base.s.size = 0;
 5ff:	c7 05 68 09 00 00 00 	movl   $0x0,0x968
 606:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 609:	b9 64 09 00 00       	mov    $0x964,%ecx
 60e:	eb d7                	jmp    5e7 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 610:	74 19                	je     62b <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 612:	29 da                	sub    %ebx,%edx
 614:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 617:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 61a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 61d:	89 0d 60 09 00 00    	mov    %ecx,0x960
      return (void*)(p + 1);
 623:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 629:	c9                   	leave  
 62a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 62b:	8b 10                	mov    (%eax),%edx
 62d:	89 11                	mov    %edx,(%ecx)
 62f:	eb ec                	jmp    61d <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 631:	89 c1                	mov    %eax,%ecx
 633:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	39 da                	cmp    %ebx,%edx
 63a:	73 d4                	jae    610 <malloc+0x46>
    if(p == freep)
 63c:	39 05 60 09 00 00    	cmp    %eax,0x960
 642:	75 ed                	jne    631 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 644:	89 d8                	mov    %ebx,%eax
 646:	e8 2f ff ff ff       	call   57a <morecore>
 64b:	85 c0                	test   %eax,%eax
 64d:	75 e2                	jne    631 <malloc+0x67>
 64f:	eb d5                	jmp    626 <malloc+0x5c>
