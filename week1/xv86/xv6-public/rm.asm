
_rm:     file format elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 41 04             	mov    0x4(%ecx),%eax
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  1c:	83 ff 01             	cmp    $0x1,%edi
  1f:	7e 07                	jle    28 <main+0x28>
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 17                	jmp    3f <main+0x3f>
    printf(2, "Usage: rm files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 a4 06 00 00       	push   $0x6a4
  30:	6a 02                	push   $0x2
  32:	e8 c0 03 00 00       	call   3f7 <printf>
    exit();
  37:	e8 d6 01 00 00       	call   212 <exit>
  for(i = 1; i < argc; i++){
  3c:	83 c3 01             	add    $0x1,%ebx
  3f:	39 fb                	cmp    %edi,%ebx
  41:	7d 2b                	jge    6e <main+0x6e>
    if(unlink(argv[i]) < 0){
  43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  46:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	ff 36                	push   (%esi)
  4e:	e8 0f 02 00 00       	call   262 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 e2                	jns    3c <main+0x3c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	ff 36                	push   (%esi)
  5f:	68 b8 06 00 00       	push   $0x6b8
  64:	6a 02                	push   $0x2
  66:	e8 8c 03 00 00       	call   3f7 <printf>
      break;
  6b:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  6e:	e8 9f 01 00 00       	call   212 <exit>

00000073 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	56                   	push   %esi
  77:	53                   	push   %ebx
  78:	8b 75 08             	mov    0x8(%ebp),%esi
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	89 f0                	mov    %esi,%eax
  80:	89 d1                	mov    %edx,%ecx
  82:	83 c2 01             	add    $0x1,%edx
  85:	89 c3                	mov    %eax,%ebx
  87:	83 c0 01             	add    $0x1,%eax
  8a:	0f b6 09             	movzbl (%ecx),%ecx
  8d:	88 0b                	mov    %cl,(%ebx)
  8f:	84 c9                	test   %cl,%cl
  91:	75 ed                	jne    80 <strcpy+0xd>
    ;
  return os;
}
  93:	89 f0                	mov    %esi,%eax
  95:	5b                   	pop    %ebx
  96:	5e                   	pop    %esi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  a2:	eb 06                	jmp    aa <strcmp+0x11>
    p++, q++;
  a4:	83 c1 01             	add    $0x1,%ecx
  a7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  aa:	0f b6 01             	movzbl (%ecx),%eax
  ad:	84 c0                	test   %al,%al
  af:	74 04                	je     b5 <strcmp+0x1c>
  b1:	3a 02                	cmp    (%edx),%al
  b3:	74 ef                	je     a4 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  b5:	0f b6 c0             	movzbl %al,%eax
  b8:	0f b6 12             	movzbl (%edx),%edx
  bb:	29 d0                	sub    %edx,%eax
}
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    

000000bf <strlen>:

uint
strlen(const char *s)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c5:	b8 00 00 00 00       	mov    $0x0,%eax
  ca:	eb 03                	jmp    cf <strlen+0x10>
  cc:	83 c0 01             	add    $0x1,%eax
  cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  d3:	75 f7                	jne    cc <strlen+0xd>
    ;
  return n;
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	57                   	push   %edi
  db:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  de:	89 d7                	mov    %edx,%edi
  e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	fc                   	cld    
  e7:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e9:	89 d0                	mov    %edx,%eax
  eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  ee:	c9                   	leave  
  ef:	c3                   	ret    

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  fa:	eb 03                	jmp    ff <strchr+0xf>
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	84 d2                	test   %dl,%dl
 104:	74 06                	je     10c <strchr+0x1c>
    if(*s == c)
 106:	38 ca                	cmp    %cl,%dl
 108:	75 f2                	jne    fc <strchr+0xc>
 10a:	eb 05                	jmp    111 <strchr+0x21>
      return (char*)s;
  return 0;
 10c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <gets>:

char*
gets(char *buf, int max)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x49>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 ec 00 00 00       	call   22a <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x49>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x11>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	56                   	push   %esi
 16e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16f:	83 ec 08             	sub    $0x8,%esp
 172:	6a 00                	push   $0x0
 174:	ff 75 08             	push   0x8(%ebp)
 177:	e8 d6 00 00 00       	call   252 <open>
  if(fd < 0)
 17c:	83 c4 10             	add    $0x10,%esp
 17f:	85 c0                	test   %eax,%eax
 181:	78 24                	js     1a7 <stat+0x3d>
 183:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 185:	83 ec 08             	sub    $0x8,%esp
 188:	ff 75 0c             	push   0xc(%ebp)
 18b:	50                   	push   %eax
 18c:	e8 d9 00 00 00       	call   26a <fstat>
 191:	89 c6                	mov    %eax,%esi
  close(fd);
 193:	89 1c 24             	mov    %ebx,(%esp)
 196:	e8 9f 00 00 00       	call   23a <close>
  return r;
 19b:	83 c4 10             	add    $0x10,%esp
}
 19e:	89 f0                	mov    %esi,%eax
 1a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a3:	5b                   	pop    %ebx
 1a4:	5e                   	pop    %esi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
    return -1;
 1a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ac:	eb f0                	jmp    19e <stat+0x34>

000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	53                   	push   %ebx
 1b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b5:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ba:	eb 10                	jmp    1cc <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1bc:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1bf:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c2:	83 c1 01             	add    $0x1,%ecx
 1c5:	0f be c0             	movsbl %al,%eax
 1c8:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1cc:	0f b6 01             	movzbl (%ecx),%eax
 1cf:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d2:	80 fb 09             	cmp    $0x9,%bl
 1d5:	76 e5                	jbe    1bc <atoi+0xe>
  return n;
}
 1d7:	89 d0                	mov    %edx,%eax
 1d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	8b 75 08             	mov    0x8(%ebp),%esi
 1e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1e9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ec:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ee:	eb 0d                	jmp    1fd <memmove+0x1f>
    *dst++ = *src++;
 1f0:	0f b6 01             	movzbl (%ecx),%eax
 1f3:	88 02                	mov    %al,(%edx)
 1f5:	8d 49 01             	lea    0x1(%ecx),%ecx
 1f8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1fb:	89 d8                	mov    %ebx,%eax
 1fd:	8d 58 ff             	lea    -0x1(%eax),%ebx
 200:	85 c0                	test   %eax,%eax
 202:	7f ec                	jg     1f0 <memmove+0x12>
  return vdst;
}
 204:	89 f0                	mov    %esi,%eax
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20a:	b8 01 00 00 00       	mov    $0x1,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <exit>:
SYSCALL(exit)
 212:	b8 02 00 00 00       	mov    $0x2,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <wait>:
SYSCALL(wait)
 21a:	b8 03 00 00 00       	mov    $0x3,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <pipe>:
SYSCALL(pipe)
 222:	b8 04 00 00 00       	mov    $0x4,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <read>:
SYSCALL(read)
 22a:	b8 05 00 00 00       	mov    $0x5,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <write>:
SYSCALL(write)
 232:	b8 10 00 00 00       	mov    $0x10,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <close>:
SYSCALL(close)
 23a:	b8 15 00 00 00       	mov    $0x15,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <kill>:
SYSCALL(kill)
 242:	b8 06 00 00 00       	mov    $0x6,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <exec>:
SYSCALL(exec)
 24a:	b8 07 00 00 00       	mov    $0x7,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <open>:
SYSCALL(open)
 252:	b8 0f 00 00 00       	mov    $0xf,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mknod>:
SYSCALL(mknod)
 25a:	b8 11 00 00 00       	mov    $0x11,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <unlink>:
SYSCALL(unlink)
 262:	b8 12 00 00 00       	mov    $0x12,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <fstat>:
SYSCALL(fstat)
 26a:	b8 08 00 00 00       	mov    $0x8,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <link>:
SYSCALL(link)
 272:	b8 13 00 00 00       	mov    $0x13,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <mkdir>:
SYSCALL(mkdir)
 27a:	b8 14 00 00 00       	mov    $0x14,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <chdir>:
SYSCALL(chdir)
 282:	b8 09 00 00 00       	mov    $0x9,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <dup>:
SYSCALL(dup)
 28a:	b8 0a 00 00 00       	mov    $0xa,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <getpid>:
SYSCALL(getpid)
 292:	b8 0b 00 00 00       	mov    $0xb,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <sbrk>:
SYSCALL(sbrk)
 29a:	b8 0c 00 00 00       	mov    $0xc,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <sleep>:
SYSCALL(sleep)
 2a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <uptime>:
SYSCALL(uptime)
 2aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <hello>:
SYSCALL(hello)
 2b2:	b8 16 00 00 00       	mov    $0x16,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <helloYou>:
SYSCALL(helloYou)
 2ba:	b8 17 00 00 00       	mov    $0x17,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <getppid>:
SYSCALL(getppid)
 2c2:	b8 18 00 00 00       	mov    $0x18,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <get_siblings_info>:
SYSCALL(get_siblings_info)
 2ca:	b8 19 00 00 00       	mov    $0x19,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <signalProcess>:
SYSCALL(signalProcess)
 2d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <numvp>:
SYSCALL(numvp)
 2da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <numpp>:
SYSCALL(numpp)
 2e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <init_counter>:

SYSCALL(init_counter)
 2ea:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <update_cnt>:
SYSCALL(update_cnt)
 2f2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <display_count>:
SYSCALL(display_count)
 2fa:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <init_counter_1>:
SYSCALL(init_counter_1)
 302:	b8 20 00 00 00       	mov    $0x20,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <update_cnt_1>:
SYSCALL(update_cnt_1)
 30a:	b8 21 00 00 00       	mov    $0x21,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <display_count_1>:
SYSCALL(display_count_1)
 312:	b8 22 00 00 00       	mov    $0x22,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <init_counter_2>:
SYSCALL(init_counter_2)
 31a:	b8 23 00 00 00       	mov    $0x23,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <update_cnt_2>:
SYSCALL(update_cnt_2)
 322:	b8 24 00 00 00       	mov    $0x24,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <display_count_2>:
SYSCALL(display_count_2)
 32a:	b8 25 00 00 00       	mov    $0x25,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <init_mylock>:
SYSCALL(init_mylock)
 332:	b8 26 00 00 00       	mov    $0x26,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <acquire_mylock>:
SYSCALL(acquire_mylock)
 33a:	b8 27 00 00 00       	mov    $0x27,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <release_mylock>:
SYSCALL(release_mylock)
 342:	b8 28 00 00 00       	mov    $0x28,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <holding_mylock>:
 34a:	b8 29 00 00 00       	mov    $0x29,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 1c             	sub    $0x1c,%esp
 358:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 35b:	6a 01                	push   $0x1
 35d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 360:	52                   	push   %edx
 361:	50                   	push   %eax
 362:	e8 cb fe ff ff       	call   232 <write>
}
 367:	83 c4 10             	add    $0x10,%esp
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	57                   	push   %edi
 370:	56                   	push   %esi
 371:	53                   	push   %ebx
 372:	83 ec 2c             	sub    $0x2c,%esp
 375:	89 45 d0             	mov    %eax,-0x30(%ebp)
 378:	89 d0                	mov    %edx,%eax
 37a:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 380:	0f 95 c1             	setne  %cl
 383:	c1 ea 1f             	shr    $0x1f,%edx
 386:	84 d1                	test   %dl,%cl
 388:	74 44                	je     3ce <printint+0x62>
    neg = 1;
    x = -xx;
 38a:	f7 d8                	neg    %eax
 38c:	89 c1                	mov    %eax,%ecx
    neg = 1;
 38e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 395:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 39a:	89 c8                	mov    %ecx,%eax
 39c:	ba 00 00 00 00       	mov    $0x0,%edx
 3a1:	f7 f6                	div    %esi
 3a3:	89 df                	mov    %ebx,%edi
 3a5:	83 c3 01             	add    $0x1,%ebx
 3a8:	0f b6 92 30 07 00 00 	movzbl 0x730(%edx),%edx
 3af:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3b3:	89 ca                	mov    %ecx,%edx
 3b5:	89 c1                	mov    %eax,%ecx
 3b7:	39 d6                	cmp    %edx,%esi
 3b9:	76 df                	jbe    39a <printint+0x2e>
  if(neg)
 3bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3bf:	74 31                	je     3f2 <printint+0x86>
    buf[i++] = '-';
 3c1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c6:	8d 5f 02             	lea    0x2(%edi),%ebx
 3c9:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3cc:	eb 17                	jmp    3e5 <printint+0x79>
    x = xx;
 3ce:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3d0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3d7:	eb bc                	jmp    395 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3d9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3de:	89 f0                	mov    %esi,%eax
 3e0:	e8 6d ff ff ff       	call   352 <putc>
  while(--i >= 0)
 3e5:	83 eb 01             	sub    $0x1,%ebx
 3e8:	79 ef                	jns    3d9 <printint+0x6d>
}
 3ea:	83 c4 2c             	add    $0x2c,%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5f                   	pop    %edi
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret    
 3f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f5:	eb ee                	jmp    3e5 <printint+0x79>

000003f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	57                   	push   %edi
 3fb:	56                   	push   %esi
 3fc:	53                   	push   %ebx
 3fd:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 400:	8d 45 10             	lea    0x10(%ebp),%eax
 403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 406:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 40b:	bb 00 00 00 00       	mov    $0x0,%ebx
 410:	eb 14                	jmp    426 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 412:	89 fa                	mov    %edi,%edx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	e8 36 ff ff ff       	call   352 <putc>
 41c:	eb 05                	jmp    423 <printf+0x2c>
      }
    } else if(state == '%'){
 41e:	83 fe 25             	cmp    $0x25,%esi
 421:	74 25                	je     448 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 423:	83 c3 01             	add    $0x1,%ebx
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 42d:	84 c0                	test   %al,%al
 42f:	0f 84 20 01 00 00    	je     555 <printf+0x15e>
    c = fmt[i] & 0xff;
 435:	0f be f8             	movsbl %al,%edi
 438:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 43b:	85 f6                	test   %esi,%esi
 43d:	75 df                	jne    41e <printf+0x27>
      if(c == '%'){
 43f:	83 f8 25             	cmp    $0x25,%eax
 442:	75 ce                	jne    412 <printf+0x1b>
        state = '%';
 444:	89 c6                	mov    %eax,%esi
 446:	eb db                	jmp    423 <printf+0x2c>
      if(c == 'd'){
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	0f 84 cf 00 00 00    	je     520 <printf+0x129>
 451:	0f 8c dd 00 00 00    	jl     534 <printf+0x13d>
 457:	83 f8 78             	cmp    $0x78,%eax
 45a:	0f 8f d4 00 00 00    	jg     534 <printf+0x13d>
 460:	83 f8 63             	cmp    $0x63,%eax
 463:	0f 8c cb 00 00 00    	jl     534 <printf+0x13d>
 469:	83 e8 63             	sub    $0x63,%eax
 46c:	83 f8 15             	cmp    $0x15,%eax
 46f:	0f 87 bf 00 00 00    	ja     534 <printf+0x13d>
 475:	ff 24 85 d8 06 00 00 	jmp    *0x6d8(,%eax,4)
        printint(fd, *ap, 10, 1);
 47c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47f:	8b 17                	mov    (%edi),%edx
 481:	83 ec 0c             	sub    $0xc,%esp
 484:	6a 01                	push   $0x1
 486:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 d9 fe ff ff       	call   36c <printint>
        ap++;
 493:	83 c7 04             	add    $0x4,%edi
 496:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 499:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 49c:	be 00 00 00 00       	mov    $0x0,%esi
 4a1:	eb 80                	jmp    423 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a6:	8b 17                	mov    (%edi),%edx
 4a8:	83 ec 0c             	sub    $0xc,%esp
 4ab:	6a 00                	push   $0x0
 4ad:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	e8 b2 fe ff ff       	call   36c <printint>
        ap++;
 4ba:	83 c7 04             	add    $0x4,%edi
 4bd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c3:	be 00 00 00 00       	mov    $0x0,%esi
 4c8:	e9 56 ff ff ff       	jmp    423 <printf+0x2c>
        s = (char*)*ap;
 4cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d0:	8b 30                	mov    (%eax),%esi
        ap++;
 4d2:	83 c0 04             	add    $0x4,%eax
 4d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4d8:	85 f6                	test   %esi,%esi
 4da:	75 15                	jne    4f1 <printf+0xfa>
          s = "(null)";
 4dc:	be d1 06 00 00       	mov    $0x6d1,%esi
 4e1:	eb 0e                	jmp    4f1 <printf+0xfa>
          putc(fd, *s);
 4e3:	0f be d2             	movsbl %dl,%edx
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	e8 64 fe ff ff       	call   352 <putc>
          s++;
 4ee:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f1:	0f b6 16             	movzbl (%esi),%edx
 4f4:	84 d2                	test   %dl,%dl
 4f6:	75 eb                	jne    4e3 <printf+0xec>
      state = 0;
 4f8:	be 00 00 00 00       	mov    $0x0,%esi
 4fd:	e9 21 ff ff ff       	jmp    423 <printf+0x2c>
        putc(fd, *ap);
 502:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 505:	0f be 17             	movsbl (%edi),%edx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	e8 42 fe ff ff       	call   352 <putc>
        ap++;
 510:	83 c7 04             	add    $0x4,%edi
 513:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 516:	be 00 00 00 00       	mov    $0x0,%esi
 51b:	e9 03 ff ff ff       	jmp    423 <printf+0x2c>
        putc(fd, c);
 520:	89 fa                	mov    %edi,%edx
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	e8 28 fe ff ff       	call   352 <putc>
      state = 0;
 52a:	be 00 00 00 00       	mov    $0x0,%esi
 52f:	e9 ef fe ff ff       	jmp    423 <printf+0x2c>
        putc(fd, '%');
 534:	ba 25 00 00 00       	mov    $0x25,%edx
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	e8 11 fe ff ff       	call   352 <putc>
        putc(fd, c);
 541:	89 fa                	mov    %edi,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 07 fe ff ff       	call   352 <putc>
      state = 0;
 54b:	be 00 00 00 00       	mov    $0x0,%esi
 550:	e9 ce fe ff ff       	jmp    423 <printf+0x2c>
    }
  }
}
 555:	8d 65 f4             	lea    -0xc(%ebp),%esp
 558:	5b                   	pop    %ebx
 559:	5e                   	pop    %esi
 55a:	5f                   	pop    %edi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    

0000055d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 55d:	55                   	push   %ebp
 55e:	89 e5                	mov    %esp,%ebp
 560:	57                   	push   %edi
 561:	56                   	push   %esi
 562:	53                   	push   %ebx
 563:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 566:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 569:	a1 dc 09 00 00       	mov    0x9dc,%eax
 56e:	eb 02                	jmp    572 <free+0x15>
 570:	89 d0                	mov    %edx,%eax
 572:	39 c8                	cmp    %ecx,%eax
 574:	73 04                	jae    57a <free+0x1d>
 576:	39 08                	cmp    %ecx,(%eax)
 578:	77 12                	ja     58c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57a:	8b 10                	mov    (%eax),%edx
 57c:	39 c2                	cmp    %eax,%edx
 57e:	77 f0                	ja     570 <free+0x13>
 580:	39 c8                	cmp    %ecx,%eax
 582:	72 08                	jb     58c <free+0x2f>
 584:	39 ca                	cmp    %ecx,%edx
 586:	77 04                	ja     58c <free+0x2f>
 588:	89 d0                	mov    %edx,%eax
 58a:	eb e6                	jmp    572 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 58c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 58f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 592:	8b 10                	mov    (%eax),%edx
 594:	39 d7                	cmp    %edx,%edi
 596:	74 19                	je     5b1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 598:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 59b:	8b 50 04             	mov    0x4(%eax),%edx
 59e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a1:	39 ce                	cmp    %ecx,%esi
 5a3:	74 1b                	je     5c0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a5:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a7:	a3 dc 09 00 00       	mov    %eax,0x9dc
}
 5ac:	5b                   	pop    %ebx
 5ad:	5e                   	pop    %esi
 5ae:	5f                   	pop    %edi
 5af:	5d                   	pop    %ebp
 5b0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b1:	03 72 04             	add    0x4(%edx),%esi
 5b4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b7:	8b 10                	mov    (%eax),%edx
 5b9:	8b 12                	mov    (%edx),%edx
 5bb:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5be:	eb db                	jmp    59b <free+0x3e>
    p->s.size += bp->s.size;
 5c0:	03 53 fc             	add    -0x4(%ebx),%edx
 5c3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5c6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5c9:	89 10                	mov    %edx,(%eax)
 5cb:	eb da                	jmp    5a7 <free+0x4a>

000005cd <morecore>:

static Header*
morecore(uint nu)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	53                   	push   %ebx
 5d1:	83 ec 04             	sub    $0x4,%esp
 5d4:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5d6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5db:	77 05                	ja     5e2 <morecore+0x15>
    nu = 4096;
 5dd:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5e2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5e9:	83 ec 0c             	sub    $0xc,%esp
 5ec:	50                   	push   %eax
 5ed:	e8 a8 fc ff ff       	call   29a <sbrk>
  if(p == (char*)-1)
 5f2:	83 c4 10             	add    $0x10,%esp
 5f5:	83 f8 ff             	cmp    $0xffffffff,%eax
 5f8:	74 1c                	je     616 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5fa:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5fd:	83 c0 08             	add    $0x8,%eax
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	50                   	push   %eax
 604:	e8 54 ff ff ff       	call   55d <free>
  return freep;
 609:	a1 dc 09 00 00       	mov    0x9dc,%eax
 60e:	83 c4 10             	add    $0x10,%esp
}
 611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 614:	c9                   	leave  
 615:	c3                   	ret    
    return 0;
 616:	b8 00 00 00 00       	mov    $0x0,%eax
 61b:	eb f4                	jmp    611 <morecore+0x44>

0000061d <malloc>:

void*
malloc(uint nbytes)
{
 61d:	55                   	push   %ebp
 61e:	89 e5                	mov    %esp,%ebp
 620:	53                   	push   %ebx
 621:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	8d 58 07             	lea    0x7(%eax),%ebx
 62a:	c1 eb 03             	shr    $0x3,%ebx
 62d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 630:	8b 0d dc 09 00 00    	mov    0x9dc,%ecx
 636:	85 c9                	test   %ecx,%ecx
 638:	74 04                	je     63e <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63a:	8b 01                	mov    (%ecx),%eax
 63c:	eb 4a                	jmp    688 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 63e:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 645:	09 00 00 
 648:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 64f:	09 00 00 
    base.s.size = 0;
 652:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 659:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 65c:	b9 e0 09 00 00       	mov    $0x9e0,%ecx
 661:	eb d7                	jmp    63a <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 663:	74 19                	je     67e <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 665:	29 da                	sub    %ebx,%edx
 667:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 66a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 66d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 670:	89 0d dc 09 00 00    	mov    %ecx,0x9dc
      return (void*)(p + 1);
 676:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67c:	c9                   	leave  
 67d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 67e:	8b 10                	mov    (%eax),%edx
 680:	89 11                	mov    %edx,(%ecx)
 682:	eb ec                	jmp    670 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 684:	89 c1                	mov    %eax,%ecx
 686:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 688:	8b 50 04             	mov    0x4(%eax),%edx
 68b:	39 da                	cmp    %ebx,%edx
 68d:	73 d4                	jae    663 <malloc+0x46>
    if(p == freep)
 68f:	39 05 dc 09 00 00    	cmp    %eax,0x9dc
 695:	75 ed                	jne    684 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 697:	89 d8                	mov    %ebx,%eax
 699:	e8 2f ff ff ff       	call   5cd <morecore>
 69e:	85 c0                	test   %eax,%eax
 6a0:	75 e2                	jne    684 <malloc+0x67>
 6a2:	eb d5                	jmp    679 <malloc+0x5c>
