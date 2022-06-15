
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
  11:	68 3c 06 00 00       	push   $0x63c
  16:	6a 01                	push   $0x1
  18:	e8 71 03 00 00       	call   38e <printf>
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
 2e1:	b8 25 00 00 00       	mov    $0x25,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 1c             	sub    $0x1c,%esp
 2ef:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2f2:	6a 01                	push   $0x1
 2f4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2f7:	52                   	push   %edx
 2f8:	50                   	push   %eax
 2f9:	e8 eb fe ff ff       	call   1e9 <write>
}
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	c9                   	leave  
 302:	c3                   	ret    

00000303 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 303:	55                   	push   %ebp
 304:	89 e5                	mov    %esp,%ebp
 306:	57                   	push   %edi
 307:	56                   	push   %esi
 308:	53                   	push   %ebx
 309:	83 ec 2c             	sub    $0x2c,%esp
 30c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 30f:	89 d0                	mov    %edx,%eax
 311:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 313:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 317:	0f 95 c1             	setne  %cl
 31a:	c1 ea 1f             	shr    $0x1f,%edx
 31d:	84 d1                	test   %dl,%cl
 31f:	74 44                	je     365 <printint+0x62>
    neg = 1;
    x = -xx;
 321:	f7 d8                	neg    %eax
 323:	89 c1                	mov    %eax,%ecx
    neg = 1;
 325:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 32c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 331:	89 c8                	mov    %ecx,%eax
 333:	ba 00 00 00 00       	mov    $0x0,%edx
 338:	f7 f6                	div    %esi
 33a:	89 df                	mov    %ebx,%edi
 33c:	83 c3 01             	add    $0x1,%ebx
 33f:	0f b6 92 a8 06 00 00 	movzbl 0x6a8(%edx),%edx
 346:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 34a:	89 ca                	mov    %ecx,%edx
 34c:	89 c1                	mov    %eax,%ecx
 34e:	39 d6                	cmp    %edx,%esi
 350:	76 df                	jbe    331 <printint+0x2e>
  if(neg)
 352:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 356:	74 31                	je     389 <printint+0x86>
    buf[i++] = '-';
 358:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 35d:	8d 5f 02             	lea    0x2(%edi),%ebx
 360:	8b 75 d0             	mov    -0x30(%ebp),%esi
 363:	eb 17                	jmp    37c <printint+0x79>
    x = xx;
 365:	89 c1                	mov    %eax,%ecx
  neg = 0;
 367:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 36e:	eb bc                	jmp    32c <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 370:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 375:	89 f0                	mov    %esi,%eax
 377:	e8 6d ff ff ff       	call   2e9 <putc>
  while(--i >= 0)
 37c:	83 eb 01             	sub    $0x1,%ebx
 37f:	79 ef                	jns    370 <printint+0x6d>
}
 381:	83 c4 2c             	add    $0x2c,%esp
 384:	5b                   	pop    %ebx
 385:	5e                   	pop    %esi
 386:	5f                   	pop    %edi
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    
 389:	8b 75 d0             	mov    -0x30(%ebp),%esi
 38c:	eb ee                	jmp    37c <printint+0x79>

0000038e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	57                   	push   %edi
 392:	56                   	push   %esi
 393:	53                   	push   %ebx
 394:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 397:	8d 45 10             	lea    0x10(%ebp),%eax
 39a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 39d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3a2:	bb 00 00 00 00       	mov    $0x0,%ebx
 3a7:	eb 14                	jmp    3bd <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3a9:	89 fa                	mov    %edi,%edx
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	e8 36 ff ff ff       	call   2e9 <putc>
 3b3:	eb 05                	jmp    3ba <printf+0x2c>
      }
    } else if(state == '%'){
 3b5:	83 fe 25             	cmp    $0x25,%esi
 3b8:	74 25                	je     3df <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3ba:	83 c3 01             	add    $0x1,%ebx
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3c4:	84 c0                	test   %al,%al
 3c6:	0f 84 20 01 00 00    	je     4ec <printf+0x15e>
    c = fmt[i] & 0xff;
 3cc:	0f be f8             	movsbl %al,%edi
 3cf:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3d2:	85 f6                	test   %esi,%esi
 3d4:	75 df                	jne    3b5 <printf+0x27>
      if(c == '%'){
 3d6:	83 f8 25             	cmp    $0x25,%eax
 3d9:	75 ce                	jne    3a9 <printf+0x1b>
        state = '%';
 3db:	89 c6                	mov    %eax,%esi
 3dd:	eb db                	jmp    3ba <printf+0x2c>
      if(c == 'd'){
 3df:	83 f8 25             	cmp    $0x25,%eax
 3e2:	0f 84 cf 00 00 00    	je     4b7 <printf+0x129>
 3e8:	0f 8c dd 00 00 00    	jl     4cb <printf+0x13d>
 3ee:	83 f8 78             	cmp    $0x78,%eax
 3f1:	0f 8f d4 00 00 00    	jg     4cb <printf+0x13d>
 3f7:	83 f8 63             	cmp    $0x63,%eax
 3fa:	0f 8c cb 00 00 00    	jl     4cb <printf+0x13d>
 400:	83 e8 63             	sub    $0x63,%eax
 403:	83 f8 15             	cmp    $0x15,%eax
 406:	0f 87 bf 00 00 00    	ja     4cb <printf+0x13d>
 40c:	ff 24 85 50 06 00 00 	jmp    *0x650(,%eax,4)
        printint(fd, *ap, 10, 1);
 413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 416:	8b 17                	mov    (%edi),%edx
 418:	83 ec 0c             	sub    $0xc,%esp
 41b:	6a 01                	push   $0x1
 41d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	e8 d9 fe ff ff       	call   303 <printint>
        ap++;
 42a:	83 c7 04             	add    $0x4,%edi
 42d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 430:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 433:	be 00 00 00 00       	mov    $0x0,%esi
 438:	eb 80                	jmp    3ba <printf+0x2c>
        printint(fd, *ap, 16, 0);
 43a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43d:	8b 17                	mov    (%edi),%edx
 43f:	83 ec 0c             	sub    $0xc,%esp
 442:	6a 00                	push   $0x0
 444:	b9 10 00 00 00       	mov    $0x10,%ecx
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	e8 b2 fe ff ff       	call   303 <printint>
        ap++;
 451:	83 c7 04             	add    $0x4,%edi
 454:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 457:	83 c4 10             	add    $0x10,%esp
      state = 0;
 45a:	be 00 00 00 00       	mov    $0x0,%esi
 45f:	e9 56 ff ff ff       	jmp    3ba <printf+0x2c>
        s = (char*)*ap;
 464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 467:	8b 30                	mov    (%eax),%esi
        ap++;
 469:	83 c0 04             	add    $0x4,%eax
 46c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 46f:	85 f6                	test   %esi,%esi
 471:	75 15                	jne    488 <printf+0xfa>
          s = "(null)";
 473:	be 49 06 00 00       	mov    $0x649,%esi
 478:	eb 0e                	jmp    488 <printf+0xfa>
          putc(fd, *s);
 47a:	0f be d2             	movsbl %dl,%edx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 64 fe ff ff       	call   2e9 <putc>
          s++;
 485:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 488:	0f b6 16             	movzbl (%esi),%edx
 48b:	84 d2                	test   %dl,%dl
 48d:	75 eb                	jne    47a <printf+0xec>
      state = 0;
 48f:	be 00 00 00 00       	mov    $0x0,%esi
 494:	e9 21 ff ff ff       	jmp    3ba <printf+0x2c>
        putc(fd, *ap);
 499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49c:	0f be 17             	movsbl (%edi),%edx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 42 fe ff ff       	call   2e9 <putc>
        ap++;
 4a7:	83 c7 04             	add    $0x4,%edi
 4aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ad:	be 00 00 00 00       	mov    $0x0,%esi
 4b2:	e9 03 ff ff ff       	jmp    3ba <printf+0x2c>
        putc(fd, c);
 4b7:	89 fa                	mov    %edi,%edx
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	e8 28 fe ff ff       	call   2e9 <putc>
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 ef fe ff ff       	jmp    3ba <printf+0x2c>
        putc(fd, '%');
 4cb:	ba 25 00 00 00       	mov    $0x25,%edx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	e8 11 fe ff ff       	call   2e9 <putc>
        putc(fd, c);
 4d8:	89 fa                	mov    %edi,%edx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	e8 07 fe ff ff       	call   2e9 <putc>
      state = 0;
 4e2:	be 00 00 00 00       	mov    $0x0,%esi
 4e7:	e9 ce fe ff ff       	jmp    3ba <printf+0x2c>
    }
  }
}
 4ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ef:	5b                   	pop    %ebx
 4f0:	5e                   	pop    %esi
 4f1:	5f                   	pop    %edi
 4f2:	5d                   	pop    %ebp
 4f3:	c3                   	ret    

000004f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	56                   	push   %esi
 4f9:	53                   	push   %ebx
 4fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4fd:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 500:	a1 50 09 00 00       	mov    0x950,%eax
 505:	eb 02                	jmp    509 <free+0x15>
 507:	89 d0                	mov    %edx,%eax
 509:	39 c8                	cmp    %ecx,%eax
 50b:	73 04                	jae    511 <free+0x1d>
 50d:	39 08                	cmp    %ecx,(%eax)
 50f:	77 12                	ja     523 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 511:	8b 10                	mov    (%eax),%edx
 513:	39 c2                	cmp    %eax,%edx
 515:	77 f0                	ja     507 <free+0x13>
 517:	39 c8                	cmp    %ecx,%eax
 519:	72 08                	jb     523 <free+0x2f>
 51b:	39 ca                	cmp    %ecx,%edx
 51d:	77 04                	ja     523 <free+0x2f>
 51f:	89 d0                	mov    %edx,%eax
 521:	eb e6                	jmp    509 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 523:	8b 73 fc             	mov    -0x4(%ebx),%esi
 526:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 529:	8b 10                	mov    (%eax),%edx
 52b:	39 d7                	cmp    %edx,%edi
 52d:	74 19                	je     548 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 52f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 532:	8b 50 04             	mov    0x4(%eax),%edx
 535:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 538:	39 ce                	cmp    %ecx,%esi
 53a:	74 1b                	je     557 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 53c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 53e:	a3 50 09 00 00       	mov    %eax,0x950
}
 543:	5b                   	pop    %ebx
 544:	5e                   	pop    %esi
 545:	5f                   	pop    %edi
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 548:	03 72 04             	add    0x4(%edx),%esi
 54b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54e:	8b 10                	mov    (%eax),%edx
 550:	8b 12                	mov    (%edx),%edx
 552:	89 53 f8             	mov    %edx,-0x8(%ebx)
 555:	eb db                	jmp    532 <free+0x3e>
    p->s.size += bp->s.size;
 557:	03 53 fc             	add    -0x4(%ebx),%edx
 55a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 560:	89 10                	mov    %edx,(%eax)
 562:	eb da                	jmp    53e <free+0x4a>

00000564 <morecore>:

static Header*
morecore(uint nu)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	53                   	push   %ebx
 568:	83 ec 04             	sub    $0x4,%esp
 56b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 56d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 572:	77 05                	ja     579 <morecore+0x15>
    nu = 4096;
 574:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 579:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	50                   	push   %eax
 584:	e8 c8 fc ff ff       	call   251 <sbrk>
  if(p == (char*)-1)
 589:	83 c4 10             	add    $0x10,%esp
 58c:	83 f8 ff             	cmp    $0xffffffff,%eax
 58f:	74 1c                	je     5ad <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 591:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 594:	83 c0 08             	add    $0x8,%eax
 597:	83 ec 0c             	sub    $0xc,%esp
 59a:	50                   	push   %eax
 59b:	e8 54 ff ff ff       	call   4f4 <free>
  return freep;
 5a0:	a1 50 09 00 00       	mov    0x950,%eax
 5a5:	83 c4 10             	add    $0x10,%esp
}
 5a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ab:	c9                   	leave  
 5ac:	c3                   	ret    
    return 0;
 5ad:	b8 00 00 00 00       	mov    $0x0,%eax
 5b2:	eb f4                	jmp    5a8 <morecore+0x44>

000005b4 <malloc>:

void*
malloc(uint nbytes)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	53                   	push   %ebx
 5b8:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	8d 58 07             	lea    0x7(%eax),%ebx
 5c1:	c1 eb 03             	shr    $0x3,%ebx
 5c4:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c7:	8b 0d 50 09 00 00    	mov    0x950,%ecx
 5cd:	85 c9                	test   %ecx,%ecx
 5cf:	74 04                	je     5d5 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d1:	8b 01                	mov    (%ecx),%eax
 5d3:	eb 4a                	jmp    61f <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5d5:	c7 05 50 09 00 00 54 	movl   $0x954,0x950
 5dc:	09 00 00 
 5df:	c7 05 54 09 00 00 54 	movl   $0x954,0x954
 5e6:	09 00 00 
    base.s.size = 0;
 5e9:	c7 05 58 09 00 00 00 	movl   $0x0,0x958
 5f0:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f3:	b9 54 09 00 00       	mov    $0x954,%ecx
 5f8:	eb d7                	jmp    5d1 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5fa:	74 19                	je     615 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5fc:	29 da                	sub    %ebx,%edx
 5fe:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 601:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 604:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 607:	89 0d 50 09 00 00    	mov    %ecx,0x950
      return (void*)(p + 1);
 60d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 613:	c9                   	leave  
 614:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 615:	8b 10                	mov    (%eax),%edx
 617:	89 11                	mov    %edx,(%ecx)
 619:	eb ec                	jmp    607 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61b:	89 c1                	mov    %eax,%ecx
 61d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 61f:	8b 50 04             	mov    0x4(%eax),%edx
 622:	39 da                	cmp    %ebx,%edx
 624:	73 d4                	jae    5fa <malloc+0x46>
    if(p == freep)
 626:	39 05 50 09 00 00    	cmp    %eax,0x950
 62c:	75 ed                	jne    61b <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 62e:	89 d8                	mov    %ebx,%eax
 630:	e8 2f ff ff ff       	call   564 <morecore>
 635:	85 c0                	test   %eax,%eax
 637:	75 e2                	jne    61b <malloc+0x67>
 639:	eb d5                	jmp    610 <malloc+0x5c>
