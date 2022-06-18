
_pri:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp

    printf(1,"hello priyam");
  11:	68 5c 06 00 00       	push   $0x65c
  16:	6a 01                	push   $0x1
  18:	e8 91 03 00 00       	call   3ae <printf>
    return 0;
  1d:	b8 00 00 00 00       	mov    $0x0,%eax
  22:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  25:	c9                   	leave  
  26:	8d 61 fc             	lea    -0x4(%ecx),%esp
  29:	c3                   	ret    

0000002a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	56                   	push   %esi
  2e:	53                   	push   %ebx
  2f:	8b 75 08             	mov    0x8(%ebp),%esi
  32:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  35:	89 f0                	mov    %esi,%eax
  37:	89 d1                	mov    %edx,%ecx
  39:	83 c2 01             	add    $0x1,%edx
  3c:	89 c3                	mov    %eax,%ebx
  3e:	83 c0 01             	add    $0x1,%eax
  41:	0f b6 09             	movzbl (%ecx),%ecx
  44:	88 0b                	mov    %cl,(%ebx)
  46:	84 c9                	test   %cl,%cl
  48:	75 ed                	jne    37 <strcpy+0xd>
    ;
  return os;
}
  4a:	89 f0                	mov    %esi,%eax
  4c:	5b                   	pop    %ebx
  4d:	5e                   	pop    %esi
  4e:	5d                   	pop    %ebp
  4f:	c3                   	ret    

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  56:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  59:	eb 06                	jmp    61 <strcmp+0x11>
    p++, q++;
  5b:	83 c1 01             	add    $0x1,%ecx
  5e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  61:	0f b6 01             	movzbl (%ecx),%eax
  64:	84 c0                	test   %al,%al
  66:	74 04                	je     6c <strcmp+0x1c>
  68:	3a 02                	cmp    (%edx),%al
  6a:	74 ef                	je     5b <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  6c:	0f b6 c0             	movzbl %al,%eax
  6f:	0f b6 12             	movzbl (%edx),%edx
  72:	29 d0                	sub    %edx,%eax
}
  74:	5d                   	pop    %ebp
  75:	c3                   	ret    

00000076 <strlen>:

uint
strlen(const char *s)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  7c:	b8 00 00 00 00       	mov    $0x0,%eax
  81:	eb 03                	jmp    86 <strlen+0x10>
  83:	83 c0 01             	add    $0x1,%eax
  86:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8a:	75 f7                	jne    83 <strlen+0xd>
    ;
  return n;
}
  8c:	5d                   	pop    %ebp
  8d:	c3                   	ret    

0000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	57                   	push   %edi
  92:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  95:	89 d7                	mov    %edx,%edi
  97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	fc                   	cld    
  9e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a0:	89 d0                	mov    %edx,%eax
  a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  a5:	c9                   	leave  
  a6:	c3                   	ret    

000000a7 <strchr>:

char*
strchr(const char *s, char c)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	8b 45 08             	mov    0x8(%ebp),%eax
  ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  b1:	eb 03                	jmp    b6 <strchr+0xf>
  b3:	83 c0 01             	add    $0x1,%eax
  b6:	0f b6 10             	movzbl (%eax),%edx
  b9:	84 d2                	test   %dl,%dl
  bb:	74 06                	je     c3 <strchr+0x1c>
    if(*s == c)
  bd:	38 ca                	cmp    %cl,%dl
  bf:	75 f2                	jne    b3 <strchr+0xc>
  c1:	eb 05                	jmp    c8 <strchr+0x21>
      return (char*)s;
  return 0;
  c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c8:	5d                   	pop    %ebp
  c9:	c3                   	ret    

000000ca <gets>:

char*
gets(char *buf, int max)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  cd:	57                   	push   %edi
  ce:	56                   	push   %esi
  cf:	53                   	push   %ebx
  d0:	83 ec 1c             	sub    $0x1c,%esp
  d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  db:	89 de                	mov    %ebx,%esi
  dd:	83 c3 01             	add    $0x1,%ebx
  e0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e3:	7d 2e                	jge    113 <gets+0x49>
    cc = read(0, &c, 1);
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	6a 01                	push   $0x1
  ea:	8d 45 e7             	lea    -0x19(%ebp),%eax
  ed:	50                   	push   %eax
  ee:	6a 00                	push   $0x0
  f0:	e8 ec 00 00 00       	call   1e1 <read>
    if(cc < 1)
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	85 c0                	test   %eax,%eax
  fa:	7e 17                	jle    113 <gets+0x49>
      break;
    buf[i++] = c;
  fc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 100:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 103:	3c 0a                	cmp    $0xa,%al
 105:	0f 94 c2             	sete   %dl
 108:	3c 0d                	cmp    $0xd,%al
 10a:	0f 94 c0             	sete   %al
 10d:	08 c2                	or     %al,%dl
 10f:	74 ca                	je     db <gets+0x11>
    buf[i++] = c;
 111:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 113:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 117:	89 f8                	mov    %edi,%eax
 119:	8d 65 f4             	lea    -0xc(%ebp),%esp
 11c:	5b                   	pop    %ebx
 11d:	5e                   	pop    %esi
 11e:	5f                   	pop    %edi
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    

00000121 <stat>:

int
stat(const char *n, struct stat *st)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	56                   	push   %esi
 125:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 126:	83 ec 08             	sub    $0x8,%esp
 129:	6a 00                	push   $0x0
 12b:	ff 75 08             	push   0x8(%ebp)
 12e:	e8 d6 00 00 00       	call   209 <open>
  if(fd < 0)
 133:	83 c4 10             	add    $0x10,%esp
 136:	85 c0                	test   %eax,%eax
 138:	78 24                	js     15e <stat+0x3d>
 13a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	ff 75 0c             	push   0xc(%ebp)
 142:	50                   	push   %eax
 143:	e8 d9 00 00 00       	call   221 <fstat>
 148:	89 c6                	mov    %eax,%esi
  close(fd);
 14a:	89 1c 24             	mov    %ebx,(%esp)
 14d:	e8 9f 00 00 00       	call   1f1 <close>
  return r;
 152:	83 c4 10             	add    $0x10,%esp
}
 155:	89 f0                	mov    %esi,%eax
 157:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15a:	5b                   	pop    %ebx
 15b:	5e                   	pop    %esi
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    
    return -1;
 15e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 163:	eb f0                	jmp    155 <stat+0x34>

00000165 <atoi>:

int
atoi(const char *s)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	53                   	push   %ebx
 169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 16c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 171:	eb 10                	jmp    183 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 173:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 176:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 179:	83 c1 01             	add    $0x1,%ecx
 17c:	0f be c0             	movsbl %al,%eax
 17f:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 183:	0f b6 01             	movzbl (%ecx),%eax
 186:	8d 58 d0             	lea    -0x30(%eax),%ebx
 189:	80 fb 09             	cmp    $0x9,%bl
 18c:	76 e5                	jbe    173 <atoi+0xe>
  return n;
}
 18e:	89 d0                	mov    %edx,%eax
 190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
 19a:	8b 75 08             	mov    0x8(%ebp),%esi
 19d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1a0:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1a3:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1a5:	eb 0d                	jmp    1b4 <memmove+0x1f>
    *dst++ = *src++;
 1a7:	0f b6 01             	movzbl (%ecx),%eax
 1aa:	88 02                	mov    %al,(%edx)
 1ac:	8d 49 01             	lea    0x1(%ecx),%ecx
 1af:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1b2:	89 d8                	mov    %ebx,%eax
 1b4:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1b7:	85 c0                	test   %eax,%eax
 1b9:	7f ec                	jg     1a7 <memmove+0x12>
  return vdst;
}
 1bb:	89 f0                	mov    %esi,%eax
 1bd:	5b                   	pop    %ebx
 1be:	5e                   	pop    %esi
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    

000001c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1c1:	b8 01 00 00 00       	mov    $0x1,%eax
 1c6:	cd 40                	int    $0x40
 1c8:	c3                   	ret    

000001c9 <exit>:
SYSCALL(exit)
 1c9:	b8 02 00 00 00       	mov    $0x2,%eax
 1ce:	cd 40                	int    $0x40
 1d0:	c3                   	ret    

000001d1 <wait>:
SYSCALL(wait)
 1d1:	b8 03 00 00 00       	mov    $0x3,%eax
 1d6:	cd 40                	int    $0x40
 1d8:	c3                   	ret    

000001d9 <pipe>:
SYSCALL(pipe)
 1d9:	b8 04 00 00 00       	mov    $0x4,%eax
 1de:	cd 40                	int    $0x40
 1e0:	c3                   	ret    

000001e1 <read>:
SYSCALL(read)
 1e1:	b8 05 00 00 00       	mov    $0x5,%eax
 1e6:	cd 40                	int    $0x40
 1e8:	c3                   	ret    

000001e9 <write>:
SYSCALL(write)
 1e9:	b8 10 00 00 00       	mov    $0x10,%eax
 1ee:	cd 40                	int    $0x40
 1f0:	c3                   	ret    

000001f1 <close>:
SYSCALL(close)
 1f1:	b8 15 00 00 00       	mov    $0x15,%eax
 1f6:	cd 40                	int    $0x40
 1f8:	c3                   	ret    

000001f9 <kill>:
SYSCALL(kill)
 1f9:	b8 06 00 00 00       	mov    $0x6,%eax
 1fe:	cd 40                	int    $0x40
 200:	c3                   	ret    

00000201 <exec>:
SYSCALL(exec)
 201:	b8 07 00 00 00       	mov    $0x7,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	ret    

00000209 <open>:
SYSCALL(open)
 209:	b8 0f 00 00 00       	mov    $0xf,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	ret    

00000211 <mknod>:
SYSCALL(mknod)
 211:	b8 11 00 00 00       	mov    $0x11,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	ret    

00000219 <unlink>:
SYSCALL(unlink)
 219:	b8 12 00 00 00       	mov    $0x12,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <fstat>:
SYSCALL(fstat)
 221:	b8 08 00 00 00       	mov    $0x8,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <link>:
SYSCALL(link)
 229:	b8 13 00 00 00       	mov    $0x13,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <mkdir>:
SYSCALL(mkdir)
 231:	b8 14 00 00 00       	mov    $0x14,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <chdir>:
SYSCALL(chdir)
 239:	b8 09 00 00 00       	mov    $0x9,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <dup>:
SYSCALL(dup)
 241:	b8 0a 00 00 00       	mov    $0xa,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <getpid>:
SYSCALL(getpid)
 249:	b8 0b 00 00 00       	mov    $0xb,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <sbrk>:
SYSCALL(sbrk)
 251:	b8 0c 00 00 00       	mov    $0xc,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <sleep>:
SYSCALL(sleep)
 259:	b8 0d 00 00 00       	mov    $0xd,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <uptime>:
SYSCALL(uptime)
 261:	b8 0e 00 00 00       	mov    $0xe,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <hello>:
SYSCALL(hello)
 269:	b8 16 00 00 00       	mov    $0x16,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <helloYou>:
SYSCALL(helloYou)
 271:	b8 17 00 00 00       	mov    $0x17,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <getppid>:
SYSCALL(getppid)
 279:	b8 18 00 00 00       	mov    $0x18,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <get_siblings_info>:
SYSCALL(get_siblings_info)
 281:	b8 19 00 00 00       	mov    $0x19,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <signalProcess>:
SYSCALL(signalProcess)
 289:	b8 1a 00 00 00       	mov    $0x1a,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <numvp>:
SYSCALL(numvp)
 291:	b8 1b 00 00 00       	mov    $0x1b,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <numpp>:
SYSCALL(numpp)
 299:	b8 1c 00 00 00       	mov    $0x1c,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <init_counter>:

SYSCALL(init_counter)
 2a1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <update_cnt>:
SYSCALL(update_cnt)
 2a9:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <display_count>:
SYSCALL(display_count)
 2b1:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <init_counter_1>:
SYSCALL(init_counter_1)
 2b9:	b8 20 00 00 00       	mov    $0x20,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2c1:	b8 21 00 00 00       	mov    $0x21,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <display_count_1>:
SYSCALL(display_count_1)
 2c9:	b8 22 00 00 00       	mov    $0x22,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <init_counter_2>:
SYSCALL(init_counter_2)
 2d1:	b8 23 00 00 00       	mov    $0x23,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <update_cnt_2>:
SYSCALL(update_cnt_2)
 2d9:	b8 24 00 00 00       	mov    $0x24,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <display_count_2>:
SYSCALL(display_count_2)
 2e1:	b8 25 00 00 00       	mov    $0x25,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <init_mylock>:
SYSCALL(init_mylock)
 2e9:	b8 26 00 00 00       	mov    $0x26,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <acquire_mylock>:
SYSCALL(acquire_mylock)
 2f1:	b8 27 00 00 00       	mov    $0x27,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <release_mylock>:
SYSCALL(release_mylock)
 2f9:	b8 28 00 00 00       	mov    $0x28,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <holding_mylock>:
 301:	b8 29 00 00 00       	mov    $0x29,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 1c             	sub    $0x1c,%esp
 30f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 312:	6a 01                	push   $0x1
 314:	8d 55 f4             	lea    -0xc(%ebp),%edx
 317:	52                   	push   %edx
 318:	50                   	push   %eax
 319:	e8 cb fe ff ff       	call   1e9 <write>
}
 31e:	83 c4 10             	add    $0x10,%esp
 321:	c9                   	leave  
 322:	c3                   	ret    

00000323 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	57                   	push   %edi
 327:	56                   	push   %esi
 328:	53                   	push   %ebx
 329:	83 ec 2c             	sub    $0x2c,%esp
 32c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 32f:	89 d0                	mov    %edx,%eax
 331:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 337:	0f 95 c1             	setne  %cl
 33a:	c1 ea 1f             	shr    $0x1f,%edx
 33d:	84 d1                	test   %dl,%cl
 33f:	74 44                	je     385 <printint+0x62>
    neg = 1;
    x = -xx;
 341:	f7 d8                	neg    %eax
 343:	89 c1                	mov    %eax,%ecx
    neg = 1;
 345:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 34c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 351:	89 c8                	mov    %ecx,%eax
 353:	ba 00 00 00 00       	mov    $0x0,%edx
 358:	f7 f6                	div    %esi
 35a:	89 df                	mov    %ebx,%edi
 35c:	83 c3 01             	add    $0x1,%ebx
 35f:	0f b6 92 c8 06 00 00 	movzbl 0x6c8(%edx),%edx
 366:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 36a:	89 ca                	mov    %ecx,%edx
 36c:	89 c1                	mov    %eax,%ecx
 36e:	39 d6                	cmp    %edx,%esi
 370:	76 df                	jbe    351 <printint+0x2e>
  if(neg)
 372:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 376:	74 31                	je     3a9 <printint+0x86>
    buf[i++] = '-';
 378:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 37d:	8d 5f 02             	lea    0x2(%edi),%ebx
 380:	8b 75 d0             	mov    -0x30(%ebp),%esi
 383:	eb 17                	jmp    39c <printint+0x79>
    x = xx;
 385:	89 c1                	mov    %eax,%ecx
  neg = 0;
 387:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 38e:	eb bc                	jmp    34c <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 390:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 395:	89 f0                	mov    %esi,%eax
 397:	e8 6d ff ff ff       	call   309 <putc>
  while(--i >= 0)
 39c:	83 eb 01             	sub    $0x1,%ebx
 39f:	79 ef                	jns    390 <printint+0x6d>
}
 3a1:	83 c4 2c             	add    $0x2c,%esp
 3a4:	5b                   	pop    %ebx
 3a5:	5e                   	pop    %esi
 3a6:	5f                   	pop    %edi
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3ac:	eb ee                	jmp    39c <printint+0x79>

000003ae <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	57                   	push   %edi
 3b2:	56                   	push   %esi
 3b3:	53                   	push   %ebx
 3b4:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3b7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3bd:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3c2:	bb 00 00 00 00       	mov    $0x0,%ebx
 3c7:	eb 14                	jmp    3dd <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3c9:	89 fa                	mov    %edi,%edx
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	e8 36 ff ff ff       	call   309 <putc>
 3d3:	eb 05                	jmp    3da <printf+0x2c>
      }
    } else if(state == '%'){
 3d5:	83 fe 25             	cmp    $0x25,%esi
 3d8:	74 25                	je     3ff <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3da:	83 c3 01             	add    $0x1,%ebx
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3e4:	84 c0                	test   %al,%al
 3e6:	0f 84 20 01 00 00    	je     50c <printf+0x15e>
    c = fmt[i] & 0xff;
 3ec:	0f be f8             	movsbl %al,%edi
 3ef:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3f2:	85 f6                	test   %esi,%esi
 3f4:	75 df                	jne    3d5 <printf+0x27>
      if(c == '%'){
 3f6:	83 f8 25             	cmp    $0x25,%eax
 3f9:	75 ce                	jne    3c9 <printf+0x1b>
        state = '%';
 3fb:	89 c6                	mov    %eax,%esi
 3fd:	eb db                	jmp    3da <printf+0x2c>
      if(c == 'd'){
 3ff:	83 f8 25             	cmp    $0x25,%eax
 402:	0f 84 cf 00 00 00    	je     4d7 <printf+0x129>
 408:	0f 8c dd 00 00 00    	jl     4eb <printf+0x13d>
 40e:	83 f8 78             	cmp    $0x78,%eax
 411:	0f 8f d4 00 00 00    	jg     4eb <printf+0x13d>
 417:	83 f8 63             	cmp    $0x63,%eax
 41a:	0f 8c cb 00 00 00    	jl     4eb <printf+0x13d>
 420:	83 e8 63             	sub    $0x63,%eax
 423:	83 f8 15             	cmp    $0x15,%eax
 426:	0f 87 bf 00 00 00    	ja     4eb <printf+0x13d>
 42c:	ff 24 85 70 06 00 00 	jmp    *0x670(,%eax,4)
        printint(fd, *ap, 10, 1);
 433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 436:	8b 17                	mov    (%edi),%edx
 438:	83 ec 0c             	sub    $0xc,%esp
 43b:	6a 01                	push   $0x1
 43d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	e8 d9 fe ff ff       	call   323 <printint>
        ap++;
 44a:	83 c7 04             	add    $0x4,%edi
 44d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 450:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 453:	be 00 00 00 00       	mov    $0x0,%esi
 458:	eb 80                	jmp    3da <printf+0x2c>
        printint(fd, *ap, 16, 0);
 45a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 45d:	8b 17                	mov    (%edi),%edx
 45f:	83 ec 0c             	sub    $0xc,%esp
 462:	6a 00                	push   $0x0
 464:	b9 10 00 00 00       	mov    $0x10,%ecx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 b2 fe ff ff       	call   323 <printint>
        ap++;
 471:	83 c7 04             	add    $0x4,%edi
 474:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 477:	83 c4 10             	add    $0x10,%esp
      state = 0;
 47a:	be 00 00 00 00       	mov    $0x0,%esi
 47f:	e9 56 ff ff ff       	jmp    3da <printf+0x2c>
        s = (char*)*ap;
 484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 487:	8b 30                	mov    (%eax),%esi
        ap++;
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 48f:	85 f6                	test   %esi,%esi
 491:	75 15                	jne    4a8 <printf+0xfa>
          s = "(null)";
 493:	be 69 06 00 00       	mov    $0x669,%esi
 498:	eb 0e                	jmp    4a8 <printf+0xfa>
          putc(fd, *s);
 49a:	0f be d2             	movsbl %dl,%edx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	e8 64 fe ff ff       	call   309 <putc>
          s++;
 4a5:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4a8:	0f b6 16             	movzbl (%esi),%edx
 4ab:	84 d2                	test   %dl,%dl
 4ad:	75 eb                	jne    49a <printf+0xec>
      state = 0;
 4af:	be 00 00 00 00       	mov    $0x0,%esi
 4b4:	e9 21 ff ff ff       	jmp    3da <printf+0x2c>
        putc(fd, *ap);
 4b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4bc:	0f be 17             	movsbl (%edi),%edx
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	e8 42 fe ff ff       	call   309 <putc>
        ap++;
 4c7:	83 c7 04             	add    $0x4,%edi
 4ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4cd:	be 00 00 00 00       	mov    $0x0,%esi
 4d2:	e9 03 ff ff ff       	jmp    3da <printf+0x2c>
        putc(fd, c);
 4d7:	89 fa                	mov    %edi,%edx
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	e8 28 fe ff ff       	call   309 <putc>
      state = 0;
 4e1:	be 00 00 00 00       	mov    $0x0,%esi
 4e6:	e9 ef fe ff ff       	jmp    3da <printf+0x2c>
        putc(fd, '%');
 4eb:	ba 25 00 00 00       	mov    $0x25,%edx
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	e8 11 fe ff ff       	call   309 <putc>
        putc(fd, c);
 4f8:	89 fa                	mov    %edi,%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 07 fe ff ff       	call   309 <putc>
      state = 0;
 502:	be 00 00 00 00       	mov    $0x0,%esi
 507:	e9 ce fe ff ff       	jmp    3da <printf+0x2c>
    }
  }
}
 50c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50f:	5b                   	pop    %ebx
 510:	5e                   	pop    %esi
 511:	5f                   	pop    %edi
 512:	5d                   	pop    %ebp
 513:	c3                   	ret    

00000514 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	57                   	push   %edi
 518:	56                   	push   %esi
 519:	53                   	push   %ebx
 51a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 51d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 520:	a1 70 09 00 00       	mov    0x970,%eax
 525:	eb 02                	jmp    529 <free+0x15>
 527:	89 d0                	mov    %edx,%eax
 529:	39 c8                	cmp    %ecx,%eax
 52b:	73 04                	jae    531 <free+0x1d>
 52d:	39 08                	cmp    %ecx,(%eax)
 52f:	77 12                	ja     543 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 531:	8b 10                	mov    (%eax),%edx
 533:	39 c2                	cmp    %eax,%edx
 535:	77 f0                	ja     527 <free+0x13>
 537:	39 c8                	cmp    %ecx,%eax
 539:	72 08                	jb     543 <free+0x2f>
 53b:	39 ca                	cmp    %ecx,%edx
 53d:	77 04                	ja     543 <free+0x2f>
 53f:	89 d0                	mov    %edx,%eax
 541:	eb e6                	jmp    529 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 543:	8b 73 fc             	mov    -0x4(%ebx),%esi
 546:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 549:	8b 10                	mov    (%eax),%edx
 54b:	39 d7                	cmp    %edx,%edi
 54d:	74 19                	je     568 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 54f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 552:	8b 50 04             	mov    0x4(%eax),%edx
 555:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 558:	39 ce                	cmp    %ecx,%esi
 55a:	74 1b                	je     577 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 55c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 55e:	a3 70 09 00 00       	mov    %eax,0x970
}
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 568:	03 72 04             	add    0x4(%edx),%esi
 56b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 56e:	8b 10                	mov    (%eax),%edx
 570:	8b 12                	mov    (%edx),%edx
 572:	89 53 f8             	mov    %edx,-0x8(%ebx)
 575:	eb db                	jmp    552 <free+0x3e>
    p->s.size += bp->s.size;
 577:	03 53 fc             	add    -0x4(%ebx),%edx
 57a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 57d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 580:	89 10                	mov    %edx,(%eax)
 582:	eb da                	jmp    55e <free+0x4a>

00000584 <morecore>:

static Header*
morecore(uint nu)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	53                   	push   %ebx
 588:	83 ec 04             	sub    $0x4,%esp
 58b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 58d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 592:	77 05                	ja     599 <morecore+0x15>
    nu = 4096;
 594:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 599:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	50                   	push   %eax
 5a4:	e8 a8 fc ff ff       	call   251 <sbrk>
  if(p == (char*)-1)
 5a9:	83 c4 10             	add    $0x10,%esp
 5ac:	83 f8 ff             	cmp    $0xffffffff,%eax
 5af:	74 1c                	je     5cd <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5b1:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b4:	83 c0 08             	add    $0x8,%eax
 5b7:	83 ec 0c             	sub    $0xc,%esp
 5ba:	50                   	push   %eax
 5bb:	e8 54 ff ff ff       	call   514 <free>
  return freep;
 5c0:	a1 70 09 00 00       	mov    0x970,%eax
 5c5:	83 c4 10             	add    $0x10,%esp
}
 5c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    
    return 0;
 5cd:	b8 00 00 00 00       	mov    $0x0,%eax
 5d2:	eb f4                	jmp    5c8 <morecore+0x44>

000005d4 <malloc>:

void*
malloc(uint nbytes)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	53                   	push   %ebx
 5d8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	8d 58 07             	lea    0x7(%eax),%ebx
 5e1:	c1 eb 03             	shr    $0x3,%ebx
 5e4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5e7:	8b 0d 70 09 00 00    	mov    0x970,%ecx
 5ed:	85 c9                	test   %ecx,%ecx
 5ef:	74 04                	je     5f5 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	8b 01                	mov    (%ecx),%eax
 5f3:	eb 4a                	jmp    63f <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5f5:	c7 05 70 09 00 00 74 	movl   $0x974,0x970
 5fc:	09 00 00 
 5ff:	c7 05 74 09 00 00 74 	movl   $0x974,0x974
 606:	09 00 00 
    base.s.size = 0;
 609:	c7 05 78 09 00 00 00 	movl   $0x0,0x978
 610:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 613:	b9 74 09 00 00       	mov    $0x974,%ecx
 618:	eb d7                	jmp    5f1 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 61a:	74 19                	je     635 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 61c:	29 da                	sub    %ebx,%edx
 61e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 621:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 624:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 627:	89 0d 70 09 00 00    	mov    %ecx,0x970
      return (void*)(p + 1);
 62d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 633:	c9                   	leave  
 634:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 635:	8b 10                	mov    (%eax),%edx
 637:	89 11                	mov    %edx,(%ecx)
 639:	eb ec                	jmp    627 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63b:	89 c1                	mov    %eax,%ecx
 63d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 63f:	8b 50 04             	mov    0x4(%eax),%edx
 642:	39 da                	cmp    %ebx,%edx
 644:	73 d4                	jae    61a <malloc+0x46>
    if(p == freep)
 646:	39 05 70 09 00 00    	cmp    %eax,0x970
 64c:	75 ed                	jne    63b <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 64e:	89 d8                	mov    %ebx,%eax
 650:	e8 2f ff ff ff       	call   584 <morecore>
 655:	85 c0                	test   %eax,%eax
 657:	75 e2                	jne    63b <malloc+0x67>
 659:	eb d5                	jmp    630 <malloc+0x5c>
