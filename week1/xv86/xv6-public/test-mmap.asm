
_test-mmap:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  //   addr[8000] = 'a';

  //   printf(1, "After access of second page: memory usage in pages: virtual: %d, physical %d\n", numvp(), numpp());
  // }

  exit();
   6:	e8 9f 01 00 00       	call   1aa <exit>

0000000b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   b:	55                   	push   %ebp
   c:	89 e5                	mov    %esp,%ebp
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	8b 75 08             	mov    0x8(%ebp),%esi
  13:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  16:	89 f0                	mov    %esi,%eax
  18:	89 d1                	mov    %edx,%ecx
  1a:	83 c2 01             	add    $0x1,%edx
  1d:	89 c3                	mov    %eax,%ebx
  1f:	83 c0 01             	add    $0x1,%eax
  22:	0f b6 09             	movzbl (%ecx),%ecx
  25:	88 0b                	mov    %cl,(%ebx)
  27:	84 c9                	test   %cl,%cl
  29:	75 ed                	jne    18 <strcpy+0xd>
    ;
  return os;
}
  2b:	89 f0                	mov    %esi,%eax
  2d:	5b                   	pop    %ebx
  2e:	5e                   	pop    %esi
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    

00000031 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  37:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  3a:	eb 06                	jmp    42 <strcmp+0x11>
    p++, q++;
  3c:	83 c1 01             	add    $0x1,%ecx
  3f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  42:	0f b6 01             	movzbl (%ecx),%eax
  45:	84 c0                	test   %al,%al
  47:	74 04                	je     4d <strcmp+0x1c>
  49:	3a 02                	cmp    (%edx),%al
  4b:	74 ef                	je     3c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  4d:	0f b6 c0             	movzbl %al,%eax
  50:	0f b6 12             	movzbl (%edx),%edx
  53:	29 d0                	sub    %edx,%eax
}
  55:	5d                   	pop    %ebp
  56:	c3                   	ret    

00000057 <strlen>:

uint
strlen(const char *s)
{
  57:	55                   	push   %ebp
  58:	89 e5                	mov    %esp,%ebp
  5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  5d:	b8 00 00 00 00       	mov    $0x0,%eax
  62:	eb 03                	jmp    67 <strlen+0x10>
  64:	83 c0 01             	add    $0x1,%eax
  67:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  6b:	75 f7                	jne    64 <strlen+0xd>
    ;
  return n;
}
  6d:	5d                   	pop    %ebp
  6e:	c3                   	ret    

0000006f <memset>:

void*
memset(void *dst, int c, uint n)
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	57                   	push   %edi
  73:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  76:	89 d7                	mov    %edx,%edi
  78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  7e:	fc                   	cld    
  7f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  81:	89 d0                	mov    %edx,%eax
  83:	8b 7d fc             	mov    -0x4(%ebp),%edi
  86:	c9                   	leave  
  87:	c3                   	ret    

00000088 <strchr>:

char*
strchr(const char *s, char c)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  92:	eb 03                	jmp    97 <strchr+0xf>
  94:	83 c0 01             	add    $0x1,%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	84 d2                	test   %dl,%dl
  9c:	74 06                	je     a4 <strchr+0x1c>
    if(*s == c)
  9e:	38 ca                	cmp    %cl,%dl
  a0:	75 f2                	jne    94 <strchr+0xc>
  a2:	eb 05                	jmp    a9 <strchr+0x21>
      return (char*)s;
  return 0;
  a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <gets>:

char*
gets(char *buf, int max)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	57                   	push   %edi
  af:	56                   	push   %esi
  b0:	53                   	push   %ebx
  b1:	83 ec 1c             	sub    $0x1c,%esp
  b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  bc:	89 de                	mov    %ebx,%esi
  be:	83 c3 01             	add    $0x1,%ebx
  c1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  c4:	7d 2e                	jge    f4 <gets+0x49>
    cc = read(0, &c, 1);
  c6:	83 ec 04             	sub    $0x4,%esp
  c9:	6a 01                	push   $0x1
  cb:	8d 45 e7             	lea    -0x19(%ebp),%eax
  ce:	50                   	push   %eax
  cf:	6a 00                	push   $0x0
  d1:	e8 ec 00 00 00       	call   1c2 <read>
    if(cc < 1)
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	85 c0                	test   %eax,%eax
  db:	7e 17                	jle    f4 <gets+0x49>
      break;
    buf[i++] = c;
  dd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  e1:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
  e4:	3c 0a                	cmp    $0xa,%al
  e6:	0f 94 c2             	sete   %dl
  e9:	3c 0d                	cmp    $0xd,%al
  eb:	0f 94 c0             	sete   %al
  ee:	08 c2                	or     %al,%dl
  f0:	74 ca                	je     bc <gets+0x11>
    buf[i++] = c;
  f2:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
  f4:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
  f8:	89 f8                	mov    %edi,%eax
  fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  fd:	5b                   	pop    %ebx
  fe:	5e                   	pop    %esi
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <stat>:

int
stat(const char *n, struct stat *st)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	56                   	push   %esi
 106:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	6a 00                	push   $0x0
 10c:	ff 75 08             	push   0x8(%ebp)
 10f:	e8 d6 00 00 00       	call   1ea <open>
  if(fd < 0)
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	78 24                	js     13f <stat+0x3d>
 11b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	ff 75 0c             	push   0xc(%ebp)
 123:	50                   	push   %eax
 124:	e8 d9 00 00 00       	call   202 <fstat>
 129:	89 c6                	mov    %eax,%esi
  close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 9f 00 00 00       	call   1d2 <close>
  return r;
 133:	83 c4 10             	add    $0x10,%esp
}
 136:	89 f0                	mov    %esi,%eax
 138:	8d 65 f8             	lea    -0x8(%ebp),%esp
 13b:	5b                   	pop    %ebx
 13c:	5e                   	pop    %esi
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    
    return -1;
 13f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 144:	eb f0                	jmp    136 <stat+0x34>

00000146 <atoi>:

int
atoi(const char *s)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	53                   	push   %ebx
 14a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 14d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 152:	eb 10                	jmp    164 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 154:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 157:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 15a:	83 c1 01             	add    $0x1,%ecx
 15d:	0f be c0             	movsbl %al,%eax
 160:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 164:	0f b6 01             	movzbl (%ecx),%eax
 167:	8d 58 d0             	lea    -0x30(%eax),%ebx
 16a:	80 fb 09             	cmp    $0x9,%bl
 16d:	76 e5                	jbe    154 <atoi+0xe>
  return n;
}
 16f:	89 d0                	mov    %edx,%eax
 171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	56                   	push   %esi
 17a:	53                   	push   %ebx
 17b:	8b 75 08             	mov    0x8(%ebp),%esi
 17e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 181:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 184:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 186:	eb 0d                	jmp    195 <memmove+0x1f>
    *dst++ = *src++;
 188:	0f b6 01             	movzbl (%ecx),%eax
 18b:	88 02                	mov    %al,(%edx)
 18d:	8d 49 01             	lea    0x1(%ecx),%ecx
 190:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 193:	89 d8                	mov    %ebx,%eax
 195:	8d 58 ff             	lea    -0x1(%eax),%ebx
 198:	85 c0                	test   %eax,%eax
 19a:	7f ec                	jg     188 <memmove+0x12>
  return vdst;
}
 19c:	89 f0                	mov    %esi,%eax
 19e:	5b                   	pop    %ebx
 19f:	5e                   	pop    %esi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1a2:	b8 01 00 00 00       	mov    $0x1,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <exit>:
SYSCALL(exit)
 1aa:	b8 02 00 00 00       	mov    $0x2,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <wait>:
SYSCALL(wait)
 1b2:	b8 03 00 00 00       	mov    $0x3,%eax
 1b7:	cd 40                	int    $0x40
 1b9:	c3                   	ret    

000001ba <pipe>:
SYSCALL(pipe)
 1ba:	b8 04 00 00 00       	mov    $0x4,%eax
 1bf:	cd 40                	int    $0x40
 1c1:	c3                   	ret    

000001c2 <read>:
SYSCALL(read)
 1c2:	b8 05 00 00 00       	mov    $0x5,%eax
 1c7:	cd 40                	int    $0x40
 1c9:	c3                   	ret    

000001ca <write>:
SYSCALL(write)
 1ca:	b8 10 00 00 00       	mov    $0x10,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <close>:
SYSCALL(close)
 1d2:	b8 15 00 00 00       	mov    $0x15,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <kill>:
SYSCALL(kill)
 1da:	b8 06 00 00 00       	mov    $0x6,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <exec>:
SYSCALL(exec)
 1e2:	b8 07 00 00 00       	mov    $0x7,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <open>:
SYSCALL(open)
 1ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <mknod>:
SYSCALL(mknod)
 1f2:	b8 11 00 00 00       	mov    $0x11,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <unlink>:
SYSCALL(unlink)
 1fa:	b8 12 00 00 00       	mov    $0x12,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <fstat>:
SYSCALL(fstat)
 202:	b8 08 00 00 00       	mov    $0x8,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <link>:
SYSCALL(link)
 20a:	b8 13 00 00 00       	mov    $0x13,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <mkdir>:
SYSCALL(mkdir)
 212:	b8 14 00 00 00       	mov    $0x14,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <chdir>:
SYSCALL(chdir)
 21a:	b8 09 00 00 00       	mov    $0x9,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <dup>:
SYSCALL(dup)
 222:	b8 0a 00 00 00       	mov    $0xa,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <getpid>:
SYSCALL(getpid)
 22a:	b8 0b 00 00 00       	mov    $0xb,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <sbrk>:
SYSCALL(sbrk)
 232:	b8 0c 00 00 00       	mov    $0xc,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <sleep>:
SYSCALL(sleep)
 23a:	b8 0d 00 00 00       	mov    $0xd,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <uptime>:
SYSCALL(uptime)
 242:	b8 0e 00 00 00       	mov    $0xe,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <hello>:
SYSCALL(hello)
 24a:	b8 16 00 00 00       	mov    $0x16,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <helloYou>:
SYSCALL(helloYou)
 252:	b8 17 00 00 00       	mov    $0x17,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <getppid>:
SYSCALL(getppid)
 25a:	b8 18 00 00 00       	mov    $0x18,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <get_siblings_info>:
SYSCALL(get_siblings_info)
 262:	b8 19 00 00 00       	mov    $0x19,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <signalProcess>:
SYSCALL(signalProcess)
 26a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <numvp>:
SYSCALL(numvp)
 272:	b8 1b 00 00 00       	mov    $0x1b,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <numpp>:
SYSCALL(numpp)
 27a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <init_counter>:

SYSCALL(init_counter)
 282:	b8 1d 00 00 00       	mov    $0x1d,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <update_cnt>:
SYSCALL(update_cnt)
 28a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <display_count>:
SYSCALL(display_count)
 292:	b8 1f 00 00 00       	mov    $0x1f,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <init_counter_1>:
SYSCALL(init_counter_1)
 29a:	b8 20 00 00 00       	mov    $0x20,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2a2:	b8 21 00 00 00       	mov    $0x21,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <display_count_1>:
SYSCALL(display_count_1)
 2aa:	b8 22 00 00 00       	mov    $0x22,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <init_counter_2>:
SYSCALL(init_counter_2)
 2b2:	b8 23 00 00 00       	mov    $0x23,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <update_cnt_2>:
SYSCALL(update_cnt_2)
 2ba:	b8 24 00 00 00       	mov    $0x24,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <display_count_2>:
SYSCALL(display_count_2)
 2c2:	b8 25 00 00 00       	mov    $0x25,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <init_mylock>:
SYSCALL(init_mylock)
 2ca:	b8 26 00 00 00       	mov    $0x26,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <acquire_mylock>:
SYSCALL(acquire_mylock)
 2d2:	b8 27 00 00 00       	mov    $0x27,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <release_mylock>:
SYSCALL(release_mylock)
 2da:	b8 28 00 00 00       	mov    $0x28,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <holding_mylock>:
 2e2:	b8 29 00 00 00       	mov    $0x29,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 1c             	sub    $0x1c,%esp
 2f0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2f3:	6a 01                	push   $0x1
 2f5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2f8:	52                   	push   %edx
 2f9:	50                   	push   %eax
 2fa:	e8 cb fe ff ff       	call   1ca <write>
}
 2ff:	83 c4 10             	add    $0x10,%esp
 302:	c9                   	leave  
 303:	c3                   	ret    

00000304 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	56                   	push   %esi
 309:	53                   	push   %ebx
 30a:	83 ec 2c             	sub    $0x2c,%esp
 30d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 310:	89 d0                	mov    %edx,%eax
 312:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 318:	0f 95 c1             	setne  %cl
 31b:	c1 ea 1f             	shr    $0x1f,%edx
 31e:	84 d1                	test   %dl,%cl
 320:	74 44                	je     366 <printint+0x62>
    neg = 1;
    x = -xx;
 322:	f7 d8                	neg    %eax
 324:	89 c1                	mov    %eax,%ecx
    neg = 1;
 326:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 32d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 332:	89 c8                	mov    %ecx,%eax
 334:	ba 00 00 00 00       	mov    $0x0,%edx
 339:	f7 f6                	div    %esi
 33b:	89 df                	mov    %ebx,%edi
 33d:	83 c3 01             	add    $0x1,%ebx
 340:	0f b6 92 9c 06 00 00 	movzbl 0x69c(%edx),%edx
 347:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 34b:	89 ca                	mov    %ecx,%edx
 34d:	89 c1                	mov    %eax,%ecx
 34f:	39 d6                	cmp    %edx,%esi
 351:	76 df                	jbe    332 <printint+0x2e>
  if(neg)
 353:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 357:	74 31                	je     38a <printint+0x86>
    buf[i++] = '-';
 359:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 35e:	8d 5f 02             	lea    0x2(%edi),%ebx
 361:	8b 75 d0             	mov    -0x30(%ebp),%esi
 364:	eb 17                	jmp    37d <printint+0x79>
    x = xx;
 366:	89 c1                	mov    %eax,%ecx
  neg = 0;
 368:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 36f:	eb bc                	jmp    32d <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 371:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 376:	89 f0                	mov    %esi,%eax
 378:	e8 6d ff ff ff       	call   2ea <putc>
  while(--i >= 0)
 37d:	83 eb 01             	sub    $0x1,%ebx
 380:	79 ef                	jns    371 <printint+0x6d>
}
 382:	83 c4 2c             	add    $0x2c,%esp
 385:	5b                   	pop    %ebx
 386:	5e                   	pop    %esi
 387:	5f                   	pop    %edi
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 38d:	eb ee                	jmp    37d <printint+0x79>

0000038f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	57                   	push   %edi
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
 395:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 398:	8d 45 10             	lea    0x10(%ebp),%eax
 39b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 39e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3a3:	bb 00 00 00 00       	mov    $0x0,%ebx
 3a8:	eb 14                	jmp    3be <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3aa:	89 fa                	mov    %edi,%edx
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	e8 36 ff ff ff       	call   2ea <putc>
 3b4:	eb 05                	jmp    3bb <printf+0x2c>
      }
    } else if(state == '%'){
 3b6:	83 fe 25             	cmp    $0x25,%esi
 3b9:	74 25                	je     3e0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3bb:	83 c3 01             	add    $0x1,%ebx
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3c5:	84 c0                	test   %al,%al
 3c7:	0f 84 20 01 00 00    	je     4ed <printf+0x15e>
    c = fmt[i] & 0xff;
 3cd:	0f be f8             	movsbl %al,%edi
 3d0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3d3:	85 f6                	test   %esi,%esi
 3d5:	75 df                	jne    3b6 <printf+0x27>
      if(c == '%'){
 3d7:	83 f8 25             	cmp    $0x25,%eax
 3da:	75 ce                	jne    3aa <printf+0x1b>
        state = '%';
 3dc:	89 c6                	mov    %eax,%esi
 3de:	eb db                	jmp    3bb <printf+0x2c>
      if(c == 'd'){
 3e0:	83 f8 25             	cmp    $0x25,%eax
 3e3:	0f 84 cf 00 00 00    	je     4b8 <printf+0x129>
 3e9:	0f 8c dd 00 00 00    	jl     4cc <printf+0x13d>
 3ef:	83 f8 78             	cmp    $0x78,%eax
 3f2:	0f 8f d4 00 00 00    	jg     4cc <printf+0x13d>
 3f8:	83 f8 63             	cmp    $0x63,%eax
 3fb:	0f 8c cb 00 00 00    	jl     4cc <printf+0x13d>
 401:	83 e8 63             	sub    $0x63,%eax
 404:	83 f8 15             	cmp    $0x15,%eax
 407:	0f 87 bf 00 00 00    	ja     4cc <printf+0x13d>
 40d:	ff 24 85 44 06 00 00 	jmp    *0x644(,%eax,4)
        printint(fd, *ap, 10, 1);
 414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 417:	8b 17                	mov    (%edi),%edx
 419:	83 ec 0c             	sub    $0xc,%esp
 41c:	6a 01                	push   $0x1
 41e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	e8 d9 fe ff ff       	call   304 <printint>
        ap++;
 42b:	83 c7 04             	add    $0x4,%edi
 42e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 431:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 434:	be 00 00 00 00       	mov    $0x0,%esi
 439:	eb 80                	jmp    3bb <printf+0x2c>
        printint(fd, *ap, 16, 0);
 43b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43e:	8b 17                	mov    (%edi),%edx
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 00                	push   $0x0
 445:	b9 10 00 00 00       	mov    $0x10,%ecx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 b2 fe ff ff       	call   304 <printint>
        ap++;
 452:	83 c7 04             	add    $0x4,%edi
 455:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 458:	83 c4 10             	add    $0x10,%esp
      state = 0;
 45b:	be 00 00 00 00       	mov    $0x0,%esi
 460:	e9 56 ff ff ff       	jmp    3bb <printf+0x2c>
        s = (char*)*ap;
 465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 468:	8b 30                	mov    (%eax),%esi
        ap++;
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 470:	85 f6                	test   %esi,%esi
 472:	75 15                	jne    489 <printf+0xfa>
          s = "(null)";
 474:	be 3c 06 00 00       	mov    $0x63c,%esi
 479:	eb 0e                	jmp    489 <printf+0xfa>
          putc(fd, *s);
 47b:	0f be d2             	movsbl %dl,%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	e8 64 fe ff ff       	call   2ea <putc>
          s++;
 486:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 489:	0f b6 16             	movzbl (%esi),%edx
 48c:	84 d2                	test   %dl,%dl
 48e:	75 eb                	jne    47b <printf+0xec>
      state = 0;
 490:	be 00 00 00 00       	mov    $0x0,%esi
 495:	e9 21 ff ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, *ap);
 49a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49d:	0f be 17             	movsbl (%edi),%edx
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	e8 42 fe ff ff       	call   2ea <putc>
        ap++;
 4a8:	83 c7 04             	add    $0x4,%edi
 4ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ae:	be 00 00 00 00       	mov    $0x0,%esi
 4b3:	e9 03 ff ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, c);
 4b8:	89 fa                	mov    %edi,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 28 fe ff ff       	call   2ea <putc>
      state = 0;
 4c2:	be 00 00 00 00       	mov    $0x0,%esi
 4c7:	e9 ef fe ff ff       	jmp    3bb <printf+0x2c>
        putc(fd, '%');
 4cc:	ba 25 00 00 00       	mov    $0x25,%edx
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	e8 11 fe ff ff       	call   2ea <putc>
        putc(fd, c);
 4d9:	89 fa                	mov    %edi,%edx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 07 fe ff ff       	call   2ea <putc>
      state = 0;
 4e3:	be 00 00 00 00       	mov    $0x0,%esi
 4e8:	e9 ce fe ff ff       	jmp    3bb <printf+0x2c>
    }
  }
}
 4ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    

000004f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	57                   	push   %edi
 4f9:	56                   	push   %esi
 4fa:	53                   	push   %ebx
 4fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 501:	a1 34 09 00 00       	mov    0x934,%eax
 506:	eb 02                	jmp    50a <free+0x15>
 508:	89 d0                	mov    %edx,%eax
 50a:	39 c8                	cmp    %ecx,%eax
 50c:	73 04                	jae    512 <free+0x1d>
 50e:	39 08                	cmp    %ecx,(%eax)
 510:	77 12                	ja     524 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 512:	8b 10                	mov    (%eax),%edx
 514:	39 c2                	cmp    %eax,%edx
 516:	77 f0                	ja     508 <free+0x13>
 518:	39 c8                	cmp    %ecx,%eax
 51a:	72 08                	jb     524 <free+0x2f>
 51c:	39 ca                	cmp    %ecx,%edx
 51e:	77 04                	ja     524 <free+0x2f>
 520:	89 d0                	mov    %edx,%eax
 522:	eb e6                	jmp    50a <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 524:	8b 73 fc             	mov    -0x4(%ebx),%esi
 527:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 52a:	8b 10                	mov    (%eax),%edx
 52c:	39 d7                	cmp    %edx,%edi
 52e:	74 19                	je     549 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 530:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 533:	8b 50 04             	mov    0x4(%eax),%edx
 536:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 539:	39 ce                	cmp    %ecx,%esi
 53b:	74 1b                	je     558 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 53d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 53f:	a3 34 09 00 00       	mov    %eax,0x934
}
 544:	5b                   	pop    %ebx
 545:	5e                   	pop    %esi
 546:	5f                   	pop    %edi
 547:	5d                   	pop    %ebp
 548:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 549:	03 72 04             	add    0x4(%edx),%esi
 54c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54f:	8b 10                	mov    (%eax),%edx
 551:	8b 12                	mov    (%edx),%edx
 553:	89 53 f8             	mov    %edx,-0x8(%ebx)
 556:	eb db                	jmp    533 <free+0x3e>
    p->s.size += bp->s.size;
 558:	03 53 fc             	add    -0x4(%ebx),%edx
 55b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 561:	89 10                	mov    %edx,(%eax)
 563:	eb da                	jmp    53f <free+0x4a>

00000565 <morecore>:

static Header*
morecore(uint nu)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 04             	sub    $0x4,%esp
 56c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 56e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 573:	77 05                	ja     57a <morecore+0x15>
    nu = 4096;
 575:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 57a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 581:	83 ec 0c             	sub    $0xc,%esp
 584:	50                   	push   %eax
 585:	e8 a8 fc ff ff       	call   232 <sbrk>
  if(p == (char*)-1)
 58a:	83 c4 10             	add    $0x10,%esp
 58d:	83 f8 ff             	cmp    $0xffffffff,%eax
 590:	74 1c                	je     5ae <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 592:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 595:	83 c0 08             	add    $0x8,%eax
 598:	83 ec 0c             	sub    $0xc,%esp
 59b:	50                   	push   %eax
 59c:	e8 54 ff ff ff       	call   4f5 <free>
  return freep;
 5a1:	a1 34 09 00 00       	mov    0x934,%eax
 5a6:	83 c4 10             	add    $0x10,%esp
}
 5a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ac:	c9                   	leave  
 5ad:	c3                   	ret    
    return 0;
 5ae:	b8 00 00 00 00       	mov    $0x0,%eax
 5b3:	eb f4                	jmp    5a9 <morecore+0x44>

000005b5 <malloc>:

void*
malloc(uint nbytes)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	53                   	push   %ebx
 5b9:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	8d 58 07             	lea    0x7(%eax),%ebx
 5c2:	c1 eb 03             	shr    $0x3,%ebx
 5c5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c8:	8b 0d 34 09 00 00    	mov    0x934,%ecx
 5ce:	85 c9                	test   %ecx,%ecx
 5d0:	74 04                	je     5d6 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d2:	8b 01                	mov    (%ecx),%eax
 5d4:	eb 4a                	jmp    620 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5d6:	c7 05 34 09 00 00 38 	movl   $0x938,0x934
 5dd:	09 00 00 
 5e0:	c7 05 38 09 00 00 38 	movl   $0x938,0x938
 5e7:	09 00 00 
    base.s.size = 0;
 5ea:	c7 05 3c 09 00 00 00 	movl   $0x0,0x93c
 5f1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f4:	b9 38 09 00 00       	mov    $0x938,%ecx
 5f9:	eb d7                	jmp    5d2 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5fb:	74 19                	je     616 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5fd:	29 da                	sub    %ebx,%edx
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 602:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 605:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 608:	89 0d 34 09 00 00    	mov    %ecx,0x934
      return (void*)(p + 1);
 60e:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 614:	c9                   	leave  
 615:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 616:	8b 10                	mov    (%eax),%edx
 618:	89 11                	mov    %edx,(%ecx)
 61a:	eb ec                	jmp    608 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61c:	89 c1                	mov    %eax,%ecx
 61e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 620:	8b 50 04             	mov    0x4(%eax),%edx
 623:	39 da                	cmp    %ebx,%edx
 625:	73 d4                	jae    5fb <malloc+0x46>
    if(p == freep)
 627:	39 05 34 09 00 00    	cmp    %eax,0x934
 62d:	75 ed                	jne    61c <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 62f:	89 d8                	mov    %ebx,%eax
 631:	e8 2f ff ff ff       	call   565 <morecore>
 636:	85 c0                	test   %eax,%eax
 638:	75 e2                	jne    61c <malloc+0x67>
 63a:	eb d5                	jmp    611 <malloc+0x5c>
