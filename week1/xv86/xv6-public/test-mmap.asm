
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
 2c2:	b8 25 00 00 00       	mov    $0x25,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 1c             	sub    $0x1c,%esp
 2d0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2d3:	6a 01                	push   $0x1
 2d5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d8:	52                   	push   %edx
 2d9:	50                   	push   %eax
 2da:	e8 eb fe ff ff       	call   1ca <write>
}
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	56                   	push   %esi
 2e9:	53                   	push   %ebx
 2ea:	83 ec 2c             	sub    $0x2c,%esp
 2ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2f0:	89 d0                	mov    %edx,%eax
 2f2:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f8:	0f 95 c1             	setne  %cl
 2fb:	c1 ea 1f             	shr    $0x1f,%edx
 2fe:	84 d1                	test   %dl,%cl
 300:	74 44                	je     346 <printint+0x62>
    neg = 1;
    x = -xx;
 302:	f7 d8                	neg    %eax
 304:	89 c1                	mov    %eax,%ecx
    neg = 1;
 306:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 30d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 312:	89 c8                	mov    %ecx,%eax
 314:	ba 00 00 00 00       	mov    $0x0,%edx
 319:	f7 f6                	div    %esi
 31b:	89 df                	mov    %ebx,%edi
 31d:	83 c3 01             	add    $0x1,%ebx
 320:	0f b6 92 7c 06 00 00 	movzbl 0x67c(%edx),%edx
 327:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 32b:	89 ca                	mov    %ecx,%edx
 32d:	89 c1                	mov    %eax,%ecx
 32f:	39 d6                	cmp    %edx,%esi
 331:	76 df                	jbe    312 <printint+0x2e>
  if(neg)
 333:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 337:	74 31                	je     36a <printint+0x86>
    buf[i++] = '-';
 339:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33e:	8d 5f 02             	lea    0x2(%edi),%ebx
 341:	8b 75 d0             	mov    -0x30(%ebp),%esi
 344:	eb 17                	jmp    35d <printint+0x79>
    x = xx;
 346:	89 c1                	mov    %eax,%ecx
  neg = 0;
 348:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 34f:	eb bc                	jmp    30d <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 351:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 356:	89 f0                	mov    %esi,%eax
 358:	e8 6d ff ff ff       	call   2ca <putc>
  while(--i >= 0)
 35d:	83 eb 01             	sub    $0x1,%ebx
 360:	79 ef                	jns    351 <printint+0x6d>
}
 362:	83 c4 2c             	add    $0x2c,%esp
 365:	5b                   	pop    %ebx
 366:	5e                   	pop    %esi
 367:	5f                   	pop    %edi
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    
 36a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 36d:	eb ee                	jmp    35d <printint+0x79>

0000036f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	57                   	push   %edi
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
 375:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 378:	8d 45 10             	lea    0x10(%ebp),%eax
 37b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 37e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 383:	bb 00 00 00 00       	mov    $0x0,%ebx
 388:	eb 14                	jmp    39e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 38a:	89 fa                	mov    %edi,%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	e8 36 ff ff ff       	call   2ca <putc>
 394:	eb 05                	jmp    39b <printf+0x2c>
      }
    } else if(state == '%'){
 396:	83 fe 25             	cmp    $0x25,%esi
 399:	74 25                	je     3c0 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 39b:	83 c3 01             	add    $0x1,%ebx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3a5:	84 c0                	test   %al,%al
 3a7:	0f 84 20 01 00 00    	je     4cd <printf+0x15e>
    c = fmt[i] & 0xff;
 3ad:	0f be f8             	movsbl %al,%edi
 3b0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3b3:	85 f6                	test   %esi,%esi
 3b5:	75 df                	jne    396 <printf+0x27>
      if(c == '%'){
 3b7:	83 f8 25             	cmp    $0x25,%eax
 3ba:	75 ce                	jne    38a <printf+0x1b>
        state = '%';
 3bc:	89 c6                	mov    %eax,%esi
 3be:	eb db                	jmp    39b <printf+0x2c>
      if(c == 'd'){
 3c0:	83 f8 25             	cmp    $0x25,%eax
 3c3:	0f 84 cf 00 00 00    	je     498 <printf+0x129>
 3c9:	0f 8c dd 00 00 00    	jl     4ac <printf+0x13d>
 3cf:	83 f8 78             	cmp    $0x78,%eax
 3d2:	0f 8f d4 00 00 00    	jg     4ac <printf+0x13d>
 3d8:	83 f8 63             	cmp    $0x63,%eax
 3db:	0f 8c cb 00 00 00    	jl     4ac <printf+0x13d>
 3e1:	83 e8 63             	sub    $0x63,%eax
 3e4:	83 f8 15             	cmp    $0x15,%eax
 3e7:	0f 87 bf 00 00 00    	ja     4ac <printf+0x13d>
 3ed:	ff 24 85 24 06 00 00 	jmp    *0x624(,%eax,4)
        printint(fd, *ap, 10, 1);
 3f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f7:	8b 17                	mov    (%edi),%edx
 3f9:	83 ec 0c             	sub    $0xc,%esp
 3fc:	6a 01                	push   $0x1
 3fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	e8 d9 fe ff ff       	call   2e4 <printint>
        ap++;
 40b:	83 c7 04             	add    $0x4,%edi
 40e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 411:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 414:	be 00 00 00 00       	mov    $0x0,%esi
 419:	eb 80                	jmp    39b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 41b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41e:	8b 17                	mov    (%edi),%edx
 420:	83 ec 0c             	sub    $0xc,%esp
 423:	6a 00                	push   $0x0
 425:	b9 10 00 00 00       	mov    $0x10,%ecx
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	e8 b2 fe ff ff       	call   2e4 <printint>
        ap++;
 432:	83 c7 04             	add    $0x4,%edi
 435:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 438:	83 c4 10             	add    $0x10,%esp
      state = 0;
 43b:	be 00 00 00 00       	mov    $0x0,%esi
 440:	e9 56 ff ff ff       	jmp    39b <printf+0x2c>
        s = (char*)*ap;
 445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 448:	8b 30                	mov    (%eax),%esi
        ap++;
 44a:	83 c0 04             	add    $0x4,%eax
 44d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 450:	85 f6                	test   %esi,%esi
 452:	75 15                	jne    469 <printf+0xfa>
          s = "(null)";
 454:	be 1c 06 00 00       	mov    $0x61c,%esi
 459:	eb 0e                	jmp    469 <printf+0xfa>
          putc(fd, *s);
 45b:	0f be d2             	movsbl %dl,%edx
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	e8 64 fe ff ff       	call   2ca <putc>
          s++;
 466:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 469:	0f b6 16             	movzbl (%esi),%edx
 46c:	84 d2                	test   %dl,%dl
 46e:	75 eb                	jne    45b <printf+0xec>
      state = 0;
 470:	be 00 00 00 00       	mov    $0x0,%esi
 475:	e9 21 ff ff ff       	jmp    39b <printf+0x2c>
        putc(fd, *ap);
 47a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47d:	0f be 17             	movsbl (%edi),%edx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	e8 42 fe ff ff       	call   2ca <putc>
        ap++;
 488:	83 c7 04             	add    $0x4,%edi
 48b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 48e:	be 00 00 00 00       	mov    $0x0,%esi
 493:	e9 03 ff ff ff       	jmp    39b <printf+0x2c>
        putc(fd, c);
 498:	89 fa                	mov    %edi,%edx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	e8 28 fe ff ff       	call   2ca <putc>
      state = 0;
 4a2:	be 00 00 00 00       	mov    $0x0,%esi
 4a7:	e9 ef fe ff ff       	jmp    39b <printf+0x2c>
        putc(fd, '%');
 4ac:	ba 25 00 00 00       	mov    $0x25,%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	e8 11 fe ff ff       	call   2ca <putc>
        putc(fd, c);
 4b9:	89 fa                	mov    %edi,%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	e8 07 fe ff ff       	call   2ca <putc>
      state = 0;
 4c3:	be 00 00 00 00       	mov    $0x0,%esi
 4c8:	e9 ce fe ff ff       	jmp    39b <printf+0x2c>
    }
  }
}
 4cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d0:	5b                   	pop    %ebx
 4d1:	5e                   	pop    %esi
 4d2:	5f                   	pop    %edi
 4d3:	5d                   	pop    %ebp
 4d4:	c3                   	ret    

000004d5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	57                   	push   %edi
 4d9:	56                   	push   %esi
 4da:	53                   	push   %ebx
 4db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e1:	a1 14 09 00 00       	mov    0x914,%eax
 4e6:	eb 02                	jmp    4ea <free+0x15>
 4e8:	89 d0                	mov    %edx,%eax
 4ea:	39 c8                	cmp    %ecx,%eax
 4ec:	73 04                	jae    4f2 <free+0x1d>
 4ee:	39 08                	cmp    %ecx,(%eax)
 4f0:	77 12                	ja     504 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f2:	8b 10                	mov    (%eax),%edx
 4f4:	39 c2                	cmp    %eax,%edx
 4f6:	77 f0                	ja     4e8 <free+0x13>
 4f8:	39 c8                	cmp    %ecx,%eax
 4fa:	72 08                	jb     504 <free+0x2f>
 4fc:	39 ca                	cmp    %ecx,%edx
 4fe:	77 04                	ja     504 <free+0x2f>
 500:	89 d0                	mov    %edx,%eax
 502:	eb e6                	jmp    4ea <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 504:	8b 73 fc             	mov    -0x4(%ebx),%esi
 507:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 50a:	8b 10                	mov    (%eax),%edx
 50c:	39 d7                	cmp    %edx,%edi
 50e:	74 19                	je     529 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 510:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 513:	8b 50 04             	mov    0x4(%eax),%edx
 516:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 519:	39 ce                	cmp    %ecx,%esi
 51b:	74 1b                	je     538 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 51d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 51f:	a3 14 09 00 00       	mov    %eax,0x914
}
 524:	5b                   	pop    %ebx
 525:	5e                   	pop    %esi
 526:	5f                   	pop    %edi
 527:	5d                   	pop    %ebp
 528:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 529:	03 72 04             	add    0x4(%edx),%esi
 52c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 52f:	8b 10                	mov    (%eax),%edx
 531:	8b 12                	mov    (%edx),%edx
 533:	89 53 f8             	mov    %edx,-0x8(%ebx)
 536:	eb db                	jmp    513 <free+0x3e>
    p->s.size += bp->s.size;
 538:	03 53 fc             	add    -0x4(%ebx),%edx
 53b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 53e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 541:	89 10                	mov    %edx,(%eax)
 543:	eb da                	jmp    51f <free+0x4a>

00000545 <morecore>:

static Header*
morecore(uint nu)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	53                   	push   %ebx
 549:	83 ec 04             	sub    $0x4,%esp
 54c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 54e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 553:	77 05                	ja     55a <morecore+0x15>
    nu = 4096;
 555:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 55a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 561:	83 ec 0c             	sub    $0xc,%esp
 564:	50                   	push   %eax
 565:	e8 c8 fc ff ff       	call   232 <sbrk>
  if(p == (char*)-1)
 56a:	83 c4 10             	add    $0x10,%esp
 56d:	83 f8 ff             	cmp    $0xffffffff,%eax
 570:	74 1c                	je     58e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 572:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 575:	83 c0 08             	add    $0x8,%eax
 578:	83 ec 0c             	sub    $0xc,%esp
 57b:	50                   	push   %eax
 57c:	e8 54 ff ff ff       	call   4d5 <free>
  return freep;
 581:	a1 14 09 00 00       	mov    0x914,%eax
 586:	83 c4 10             	add    $0x10,%esp
}
 589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 58c:	c9                   	leave  
 58d:	c3                   	ret    
    return 0;
 58e:	b8 00 00 00 00       	mov    $0x0,%eax
 593:	eb f4                	jmp    589 <morecore+0x44>

00000595 <malloc>:

void*
malloc(uint nbytes)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	53                   	push   %ebx
 599:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	8d 58 07             	lea    0x7(%eax),%ebx
 5a2:	c1 eb 03             	shr    $0x3,%ebx
 5a5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a8:	8b 0d 14 09 00 00    	mov    0x914,%ecx
 5ae:	85 c9                	test   %ecx,%ecx
 5b0:	74 04                	je     5b6 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b2:	8b 01                	mov    (%ecx),%eax
 5b4:	eb 4a                	jmp    600 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5b6:	c7 05 14 09 00 00 18 	movl   $0x918,0x914
 5bd:	09 00 00 
 5c0:	c7 05 18 09 00 00 18 	movl   $0x918,0x918
 5c7:	09 00 00 
    base.s.size = 0;
 5ca:	c7 05 1c 09 00 00 00 	movl   $0x0,0x91c
 5d1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5d4:	b9 18 09 00 00       	mov    $0x918,%ecx
 5d9:	eb d7                	jmp    5b2 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5db:	74 19                	je     5f6 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5dd:	29 da                	sub    %ebx,%edx
 5df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5e2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5e5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e8:	89 0d 14 09 00 00    	mov    %ecx,0x914
      return (void*)(p + 1);
 5ee:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f4:	c9                   	leave  
 5f5:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f6:	8b 10                	mov    (%eax),%edx
 5f8:	89 11                	mov    %edx,(%ecx)
 5fa:	eb ec                	jmp    5e8 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fc:	89 c1                	mov    %eax,%ecx
 5fe:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 600:	8b 50 04             	mov    0x4(%eax),%edx
 603:	39 da                	cmp    %ebx,%edx
 605:	73 d4                	jae    5db <malloc+0x46>
    if(p == freep)
 607:	39 05 14 09 00 00    	cmp    %eax,0x914
 60d:	75 ed                	jne    5fc <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 60f:	89 d8                	mov    %ebx,%eax
 611:	e8 2f ff ff ff       	call   545 <morecore>
 616:	85 c0                	test   %eax,%eax
 618:	75 e2                	jne    5fc <malloc+0x67>
 61a:	eb d5                	jmp    5f1 <malloc+0x5c>
