
_echo:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba 66 06 00 00       	mov    $0x666,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	push   (%edi,%eax,4)
  29:	68 68 06 00 00       	push   $0x668
  2e:	6a 01                	push   $0x1
  30:	e8 80 03 00 00       	call   3b5 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba 64 06 00 00       	mov    $0x664,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit();
  4c:	e8 9f 01 00 00       	call   1f0 <exit>

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	56                   	push   %esi
  55:	53                   	push   %ebx
  56:	8b 75 08             	mov    0x8(%ebp),%esi
  59:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5c:	89 f0                	mov    %esi,%eax
  5e:	89 d1                	mov    %edx,%ecx
  60:	83 c2 01             	add    $0x1,%edx
  63:	89 c3                	mov    %eax,%ebx
  65:	83 c0 01             	add    $0x1,%eax
  68:	0f b6 09             	movzbl (%ecx),%ecx
  6b:	88 0b                	mov    %cl,(%ebx)
  6d:	84 c9                	test   %cl,%cl
  6f:	75 ed                	jne    5e <strcpy+0xd>
    ;
  return os;
}
  71:	89 f0                	mov    %esi,%eax
  73:	5b                   	pop    %ebx
  74:	5e                   	pop    %esi
  75:	5d                   	pop    %ebp
  76:	c3                   	ret    

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  80:	eb 06                	jmp    88 <strcmp+0x11>
    p++, q++;
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  88:	0f b6 01             	movzbl (%ecx),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 04                	je     93 <strcmp+0x1c>
  8f:	3a 02                	cmp    (%edx),%al
  91:	74 ef                	je     82 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  93:	0f b6 c0             	movzbl %al,%eax
  96:	0f b6 12             	movzbl (%edx),%edx
  99:	29 d0                	sub    %edx,%eax
}
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    

0000009d <strlen>:

uint
strlen(const char *s)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a3:	b8 00 00 00 00       	mov    $0x0,%eax
  a8:	eb 03                	jmp    ad <strlen+0x10>
  aa:	83 c0 01             	add    $0x1,%eax
  ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  b1:	75 f7                	jne    aa <strlen+0xd>
    ;
  return n;
}
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  bc:	89 d7                	mov    %edx,%edi
  be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	fc                   	cld    
  c5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c7:	89 d0                	mov    %edx,%eax
  c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strchr>:

char*
strchr(const char *s, char c)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d8:	eb 03                	jmp    dd <strchr+0xf>
  da:	83 c0 01             	add    $0x1,%eax
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	84 d2                	test   %dl,%dl
  e2:	74 06                	je     ea <strchr+0x1c>
    if(*s == c)
  e4:	38 ca                	cmp    %cl,%dl
  e6:	75 f2                	jne    da <strchr+0xc>
  e8:	eb 05                	jmp    ef <strchr+0x21>
      return (char*)s;
  return 0;
  ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <gets>:

char*
gets(char *buf, int max)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	57                   	push   %edi
  f5:	56                   	push   %esi
  f6:	53                   	push   %ebx
  f7:	83 ec 1c             	sub    $0x1c,%esp
  fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fd:	bb 00 00 00 00       	mov    $0x0,%ebx
 102:	89 de                	mov    %ebx,%esi
 104:	83 c3 01             	add    $0x1,%ebx
 107:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 10a:	7d 2e                	jge    13a <gets+0x49>
    cc = read(0, &c, 1);
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	6a 01                	push   $0x1
 111:	8d 45 e7             	lea    -0x19(%ebp),%eax
 114:	50                   	push   %eax
 115:	6a 00                	push   $0x0
 117:	e8 ec 00 00 00       	call   208 <read>
    if(cc < 1)
 11c:	83 c4 10             	add    $0x10,%esp
 11f:	85 c0                	test   %eax,%eax
 121:	7e 17                	jle    13a <gets+0x49>
      break;
    buf[i++] = c;
 123:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 127:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 12a:	3c 0a                	cmp    $0xa,%al
 12c:	0f 94 c2             	sete   %dl
 12f:	3c 0d                	cmp    $0xd,%al
 131:	0f 94 c0             	sete   %al
 134:	08 c2                	or     %al,%dl
 136:	74 ca                	je     102 <gets+0x11>
    buf[i++] = c;
 138:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 13a:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 13e:	89 f8                	mov    %edi,%eax
 140:	8d 65 f4             	lea    -0xc(%ebp),%esp
 143:	5b                   	pop    %ebx
 144:	5e                   	pop    %esi
 145:	5f                   	pop    %edi
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    

00000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	6a 00                	push   $0x0
 152:	ff 75 08             	push   0x8(%ebp)
 155:	e8 d6 00 00 00       	call   230 <open>
  if(fd < 0)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	85 c0                	test   %eax,%eax
 15f:	78 24                	js     185 <stat+0x3d>
 161:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 163:	83 ec 08             	sub    $0x8,%esp
 166:	ff 75 0c             	push   0xc(%ebp)
 169:	50                   	push   %eax
 16a:	e8 d9 00 00 00       	call   248 <fstat>
 16f:	89 c6                	mov    %eax,%esi
  close(fd);
 171:	89 1c 24             	mov    %ebx,(%esp)
 174:	e8 9f 00 00 00       	call   218 <close>
  return r;
 179:	83 c4 10             	add    $0x10,%esp
}
 17c:	89 f0                	mov    %esi,%eax
 17e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
    return -1;
 185:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18a:	eb f0                	jmp    17c <stat+0x34>

0000018c <atoi>:

int
atoi(const char *s)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	53                   	push   %ebx
 190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 193:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 198:	eb 10                	jmp    1aa <atoi+0x1e>
    n = n*10 + *s++ - '0';
 19a:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 19d:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1a0:	83 c1 01             	add    $0x1,%ecx
 1a3:	0f be c0             	movsbl %al,%eax
 1a6:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 01             	movzbl (%ecx),%eax
 1ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e5                	jbe    19a <atoi+0xe>
  return n;
}
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ba:	c9                   	leave  
 1bb:	c3                   	ret    

000001bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	8b 75 08             	mov    0x8(%ebp),%esi
 1c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1c7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ca:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1cc:	eb 0d                	jmp    1db <memmove+0x1f>
    *dst++ = *src++;
 1ce:	0f b6 01             	movzbl (%ecx),%eax
 1d1:	88 02                	mov    %al,(%edx)
 1d3:	8d 49 01             	lea    0x1(%ecx),%ecx
 1d6:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d9:	89 d8                	mov    %ebx,%eax
 1db:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1de:	85 c0                	test   %eax,%eax
 1e0:	7f ec                	jg     1ce <memmove+0x12>
  return vdst;
}
 1e2:	89 f0                	mov    %esi,%eax
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e8:	b8 01 00 00 00       	mov    $0x1,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <exit>:
SYSCALL(exit)
 1f0:	b8 02 00 00 00       	mov    $0x2,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <wait>:
SYSCALL(wait)
 1f8:	b8 03 00 00 00       	mov    $0x3,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <pipe>:
SYSCALL(pipe)
 200:	b8 04 00 00 00       	mov    $0x4,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <read>:
SYSCALL(read)
 208:	b8 05 00 00 00       	mov    $0x5,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <write>:
SYSCALL(write)
 210:	b8 10 00 00 00       	mov    $0x10,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <close>:
SYSCALL(close)
 218:	b8 15 00 00 00       	mov    $0x15,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <kill>:
SYSCALL(kill)
 220:	b8 06 00 00 00       	mov    $0x6,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <exec>:
SYSCALL(exec)
 228:	b8 07 00 00 00       	mov    $0x7,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <open>:
SYSCALL(open)
 230:	b8 0f 00 00 00       	mov    $0xf,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <mknod>:
SYSCALL(mknod)
 238:	b8 11 00 00 00       	mov    $0x11,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <unlink>:
SYSCALL(unlink)
 240:	b8 12 00 00 00       	mov    $0x12,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <fstat>:
SYSCALL(fstat)
 248:	b8 08 00 00 00       	mov    $0x8,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <link>:
SYSCALL(link)
 250:	b8 13 00 00 00       	mov    $0x13,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <mkdir>:
SYSCALL(mkdir)
 258:	b8 14 00 00 00       	mov    $0x14,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <chdir>:
SYSCALL(chdir)
 260:	b8 09 00 00 00       	mov    $0x9,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <dup>:
SYSCALL(dup)
 268:	b8 0a 00 00 00       	mov    $0xa,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <getpid>:
SYSCALL(getpid)
 270:	b8 0b 00 00 00       	mov    $0xb,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <sbrk>:
SYSCALL(sbrk)
 278:	b8 0c 00 00 00       	mov    $0xc,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <sleep>:
SYSCALL(sleep)
 280:	b8 0d 00 00 00       	mov    $0xd,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <uptime>:
SYSCALL(uptime)
 288:	b8 0e 00 00 00       	mov    $0xe,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <hello>:
SYSCALL(hello)
 290:	b8 16 00 00 00       	mov    $0x16,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <helloYou>:
SYSCALL(helloYou)
 298:	b8 17 00 00 00       	mov    $0x17,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <getppid>:
SYSCALL(getppid)
 2a0:	b8 18 00 00 00       	mov    $0x18,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2a8:	b8 19 00 00 00       	mov    $0x19,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <signalProcess>:
SYSCALL(signalProcess)
 2b0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <numvp>:
SYSCALL(numvp)
 2b8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <numpp>:
SYSCALL(numpp)
 2c0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <init_counter>:

SYSCALL(init_counter)
 2c8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <update_cnt>:
SYSCALL(update_cnt)
 2d0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <display_count>:
SYSCALL(display_count)
 2d8:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <init_counter_1>:
SYSCALL(init_counter_1)
 2e0:	b8 20 00 00 00       	mov    $0x20,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2e8:	b8 21 00 00 00       	mov    $0x21,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <display_count_1>:
SYSCALL(display_count_1)
 2f0:	b8 22 00 00 00       	mov    $0x22,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <init_counter_2>:
SYSCALL(init_counter_2)
 2f8:	b8 23 00 00 00       	mov    $0x23,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <update_cnt_2>:
SYSCALL(update_cnt_2)
 300:	b8 24 00 00 00       	mov    $0x24,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <display_count_2>:
 308:	b8 25 00 00 00       	mov    $0x25,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 1c             	sub    $0x1c,%esp
 316:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 319:	6a 01                	push   $0x1
 31b:	8d 55 f4             	lea    -0xc(%ebp),%edx
 31e:	52                   	push   %edx
 31f:	50                   	push   %eax
 320:	e8 eb fe ff ff       	call   210 <write>
}
 325:	83 c4 10             	add    $0x10,%esp
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	57                   	push   %edi
 32e:	56                   	push   %esi
 32f:	53                   	push   %ebx
 330:	83 ec 2c             	sub    $0x2c,%esp
 333:	89 45 d0             	mov    %eax,-0x30(%ebp)
 336:	89 d0                	mov    %edx,%eax
 338:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 33a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 33e:	0f 95 c1             	setne  %cl
 341:	c1 ea 1f             	shr    $0x1f,%edx
 344:	84 d1                	test   %dl,%cl
 346:	74 44                	je     38c <printint+0x62>
    neg = 1;
    x = -xx;
 348:	f7 d8                	neg    %eax
 34a:	89 c1                	mov    %eax,%ecx
    neg = 1;
 34c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 353:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 358:	89 c8                	mov    %ecx,%eax
 35a:	ba 00 00 00 00       	mov    $0x0,%edx
 35f:	f7 f6                	div    %esi
 361:	89 df                	mov    %ebx,%edi
 363:	83 c3 01             	add    $0x1,%ebx
 366:	0f b6 92 cc 06 00 00 	movzbl 0x6cc(%edx),%edx
 36d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 371:	89 ca                	mov    %ecx,%edx
 373:	89 c1                	mov    %eax,%ecx
 375:	39 d6                	cmp    %edx,%esi
 377:	76 df                	jbe    358 <printint+0x2e>
  if(neg)
 379:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 37d:	74 31                	je     3b0 <printint+0x86>
    buf[i++] = '-';
 37f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 384:	8d 5f 02             	lea    0x2(%edi),%ebx
 387:	8b 75 d0             	mov    -0x30(%ebp),%esi
 38a:	eb 17                	jmp    3a3 <printint+0x79>
    x = xx;
 38c:	89 c1                	mov    %eax,%ecx
  neg = 0;
 38e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 395:	eb bc                	jmp    353 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 397:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 39c:	89 f0                	mov    %esi,%eax
 39e:	e8 6d ff ff ff       	call   310 <putc>
  while(--i >= 0)
 3a3:	83 eb 01             	sub    $0x1,%ebx
 3a6:	79 ef                	jns    397 <printint+0x6d>
}
 3a8:	83 c4 2c             	add    $0x2c,%esp
 3ab:	5b                   	pop    %ebx
 3ac:	5e                   	pop    %esi
 3ad:	5f                   	pop    %edi
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    
 3b0:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b3:	eb ee                	jmp    3a3 <printint+0x79>

000003b5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	57                   	push   %edi
 3b9:	56                   	push   %esi
 3ba:	53                   	push   %ebx
 3bb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3be:	8d 45 10             	lea    0x10(%ebp),%eax
 3c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3c4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3c9:	bb 00 00 00 00       	mov    $0x0,%ebx
 3ce:	eb 14                	jmp    3e4 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3d0:	89 fa                	mov    %edi,%edx
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	e8 36 ff ff ff       	call   310 <putc>
 3da:	eb 05                	jmp    3e1 <printf+0x2c>
      }
    } else if(state == '%'){
 3dc:	83 fe 25             	cmp    $0x25,%esi
 3df:	74 25                	je     406 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3e1:	83 c3 01             	add    $0x1,%ebx
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3eb:	84 c0                	test   %al,%al
 3ed:	0f 84 20 01 00 00    	je     513 <printf+0x15e>
    c = fmt[i] & 0xff;
 3f3:	0f be f8             	movsbl %al,%edi
 3f6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3f9:	85 f6                	test   %esi,%esi
 3fb:	75 df                	jne    3dc <printf+0x27>
      if(c == '%'){
 3fd:	83 f8 25             	cmp    $0x25,%eax
 400:	75 ce                	jne    3d0 <printf+0x1b>
        state = '%';
 402:	89 c6                	mov    %eax,%esi
 404:	eb db                	jmp    3e1 <printf+0x2c>
      if(c == 'd'){
 406:	83 f8 25             	cmp    $0x25,%eax
 409:	0f 84 cf 00 00 00    	je     4de <printf+0x129>
 40f:	0f 8c dd 00 00 00    	jl     4f2 <printf+0x13d>
 415:	83 f8 78             	cmp    $0x78,%eax
 418:	0f 8f d4 00 00 00    	jg     4f2 <printf+0x13d>
 41e:	83 f8 63             	cmp    $0x63,%eax
 421:	0f 8c cb 00 00 00    	jl     4f2 <printf+0x13d>
 427:	83 e8 63             	sub    $0x63,%eax
 42a:	83 f8 15             	cmp    $0x15,%eax
 42d:	0f 87 bf 00 00 00    	ja     4f2 <printf+0x13d>
 433:	ff 24 85 74 06 00 00 	jmp    *0x674(,%eax,4)
        printint(fd, *ap, 10, 1);
 43a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43d:	8b 17                	mov    (%edi),%edx
 43f:	83 ec 0c             	sub    $0xc,%esp
 442:	6a 01                	push   $0x1
 444:	b9 0a 00 00 00       	mov    $0xa,%ecx
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	e8 d9 fe ff ff       	call   32a <printint>
        ap++;
 451:	83 c7 04             	add    $0x4,%edi
 454:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 457:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 45a:	be 00 00 00 00       	mov    $0x0,%esi
 45f:	eb 80                	jmp    3e1 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 464:	8b 17                	mov    (%edi),%edx
 466:	83 ec 0c             	sub    $0xc,%esp
 469:	6a 00                	push   $0x0
 46b:	b9 10 00 00 00       	mov    $0x10,%ecx
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	e8 b2 fe ff ff       	call   32a <printint>
        ap++;
 478:	83 c7 04             	add    $0x4,%edi
 47b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 47e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 481:	be 00 00 00 00       	mov    $0x0,%esi
 486:	e9 56 ff ff ff       	jmp    3e1 <printf+0x2c>
        s = (char*)*ap;
 48b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48e:	8b 30                	mov    (%eax),%esi
        ap++;
 490:	83 c0 04             	add    $0x4,%eax
 493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 496:	85 f6                	test   %esi,%esi
 498:	75 15                	jne    4af <printf+0xfa>
          s = "(null)";
 49a:	be 6d 06 00 00       	mov    $0x66d,%esi
 49f:	eb 0e                	jmp    4af <printf+0xfa>
          putc(fd, *s);
 4a1:	0f be d2             	movsbl %dl,%edx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	e8 64 fe ff ff       	call   310 <putc>
          s++;
 4ac:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4af:	0f b6 16             	movzbl (%esi),%edx
 4b2:	84 d2                	test   %dl,%dl
 4b4:	75 eb                	jne    4a1 <printf+0xec>
      state = 0;
 4b6:	be 00 00 00 00       	mov    $0x0,%esi
 4bb:	e9 21 ff ff ff       	jmp    3e1 <printf+0x2c>
        putc(fd, *ap);
 4c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c3:	0f be 17             	movsbl (%edi),%edx
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	e8 42 fe ff ff       	call   310 <putc>
        ap++;
 4ce:	83 c7 04             	add    $0x4,%edi
 4d1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4d4:	be 00 00 00 00       	mov    $0x0,%esi
 4d9:	e9 03 ff ff ff       	jmp    3e1 <printf+0x2c>
        putc(fd, c);
 4de:	89 fa                	mov    %edi,%edx
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	e8 28 fe ff ff       	call   310 <putc>
      state = 0;
 4e8:	be 00 00 00 00       	mov    $0x0,%esi
 4ed:	e9 ef fe ff ff       	jmp    3e1 <printf+0x2c>
        putc(fd, '%');
 4f2:	ba 25 00 00 00       	mov    $0x25,%edx
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	e8 11 fe ff ff       	call   310 <putc>
        putc(fd, c);
 4ff:	89 fa                	mov    %edi,%edx
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	e8 07 fe ff ff       	call   310 <putc>
      state = 0;
 509:	be 00 00 00 00       	mov    $0x0,%esi
 50e:	e9 ce fe ff ff       	jmp    3e1 <printf+0x2c>
    }
  }
}
 513:	8d 65 f4             	lea    -0xc(%ebp),%esp
 516:	5b                   	pop    %ebx
 517:	5e                   	pop    %esi
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret    

0000051b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 51b:	55                   	push   %ebp
 51c:	89 e5                	mov    %esp,%ebp
 51e:	57                   	push   %edi
 51f:	56                   	push   %esi
 520:	53                   	push   %ebx
 521:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 524:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 527:	a1 78 09 00 00       	mov    0x978,%eax
 52c:	eb 02                	jmp    530 <free+0x15>
 52e:	89 d0                	mov    %edx,%eax
 530:	39 c8                	cmp    %ecx,%eax
 532:	73 04                	jae    538 <free+0x1d>
 534:	39 08                	cmp    %ecx,(%eax)
 536:	77 12                	ja     54a <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 538:	8b 10                	mov    (%eax),%edx
 53a:	39 c2                	cmp    %eax,%edx
 53c:	77 f0                	ja     52e <free+0x13>
 53e:	39 c8                	cmp    %ecx,%eax
 540:	72 08                	jb     54a <free+0x2f>
 542:	39 ca                	cmp    %ecx,%edx
 544:	77 04                	ja     54a <free+0x2f>
 546:	89 d0                	mov    %edx,%eax
 548:	eb e6                	jmp    530 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 54a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 54d:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 550:	8b 10                	mov    (%eax),%edx
 552:	39 d7                	cmp    %edx,%edi
 554:	74 19                	je     56f <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 556:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 559:	8b 50 04             	mov    0x4(%eax),%edx
 55c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 55f:	39 ce                	cmp    %ecx,%esi
 561:	74 1b                	je     57e <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 563:	89 08                	mov    %ecx,(%eax)
  freep = p;
 565:	a3 78 09 00 00       	mov    %eax,0x978
}
 56a:	5b                   	pop    %ebx
 56b:	5e                   	pop    %esi
 56c:	5f                   	pop    %edi
 56d:	5d                   	pop    %ebp
 56e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 56f:	03 72 04             	add    0x4(%edx),%esi
 572:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 575:	8b 10                	mov    (%eax),%edx
 577:	8b 12                	mov    (%edx),%edx
 579:	89 53 f8             	mov    %edx,-0x8(%ebx)
 57c:	eb db                	jmp    559 <free+0x3e>
    p->s.size += bp->s.size;
 57e:	03 53 fc             	add    -0x4(%ebx),%edx
 581:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 584:	8b 53 f8             	mov    -0x8(%ebx),%edx
 587:	89 10                	mov    %edx,(%eax)
 589:	eb da                	jmp    565 <free+0x4a>

0000058b <morecore>:

static Header*
morecore(uint nu)
{
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp
 58e:	53                   	push   %ebx
 58f:	83 ec 04             	sub    $0x4,%esp
 592:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 594:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 599:	77 05                	ja     5a0 <morecore+0x15>
    nu = 4096;
 59b:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5a0:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5a7:	83 ec 0c             	sub    $0xc,%esp
 5aa:	50                   	push   %eax
 5ab:	e8 c8 fc ff ff       	call   278 <sbrk>
  if(p == (char*)-1)
 5b0:	83 c4 10             	add    $0x10,%esp
 5b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5b6:	74 1c                	je     5d4 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5bb:	83 c0 08             	add    $0x8,%eax
 5be:	83 ec 0c             	sub    $0xc,%esp
 5c1:	50                   	push   %eax
 5c2:	e8 54 ff ff ff       	call   51b <free>
  return freep;
 5c7:	a1 78 09 00 00       	mov    0x978,%eax
 5cc:	83 c4 10             	add    $0x10,%esp
}
 5cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d2:	c9                   	leave  
 5d3:	c3                   	ret    
    return 0;
 5d4:	b8 00 00 00 00       	mov    $0x0,%eax
 5d9:	eb f4                	jmp    5cf <morecore+0x44>

000005db <malloc>:

void*
malloc(uint nbytes)
{
 5db:	55                   	push   %ebp
 5dc:	89 e5                	mov    %esp,%ebp
 5de:	53                   	push   %ebx
 5df:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	8d 58 07             	lea    0x7(%eax),%ebx
 5e8:	c1 eb 03             	shr    $0x3,%ebx
 5eb:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ee:	8b 0d 78 09 00 00    	mov    0x978,%ecx
 5f4:	85 c9                	test   %ecx,%ecx
 5f6:	74 04                	je     5fc <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f8:	8b 01                	mov    (%ecx),%eax
 5fa:	eb 4a                	jmp    646 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5fc:	c7 05 78 09 00 00 7c 	movl   $0x97c,0x978
 603:	09 00 00 
 606:	c7 05 7c 09 00 00 7c 	movl   $0x97c,0x97c
 60d:	09 00 00 
    base.s.size = 0;
 610:	c7 05 80 09 00 00 00 	movl   $0x0,0x980
 617:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 61a:	b9 7c 09 00 00       	mov    $0x97c,%ecx
 61f:	eb d7                	jmp    5f8 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 621:	74 19                	je     63c <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 623:	29 da                	sub    %ebx,%edx
 625:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 628:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 62b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 62e:	89 0d 78 09 00 00    	mov    %ecx,0x978
      return (void*)(p + 1);
 634:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 63a:	c9                   	leave  
 63b:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 63c:	8b 10                	mov    (%eax),%edx
 63e:	89 11                	mov    %edx,(%ecx)
 640:	eb ec                	jmp    62e <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 642:	89 c1                	mov    %eax,%ecx
 644:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 646:	8b 50 04             	mov    0x4(%eax),%edx
 649:	39 da                	cmp    %ebx,%edx
 64b:	73 d4                	jae    621 <malloc+0x46>
    if(p == freep)
 64d:	39 05 78 09 00 00    	cmp    %eax,0x978
 653:	75 ed                	jne    642 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 655:	89 d8                	mov    %ebx,%eax
 657:	e8 2f ff ff ff       	call   58b <morecore>
 65c:	85 c0                	test   %eax,%eax
 65e:	75 e2                	jne    642 <malloc+0x67>
 660:	eb d5                	jmp    637 <malloc+0x5c>
