
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 07                	jle    25 <main+0x25>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 2d                	jmp    52 <main+0x52>
    printf(2, "usage: kill pid...\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 8c 06 00 00       	push   $0x68c
  2d:	6a 02                	push   $0x2
  2f:	e8 ab 03 00 00       	call   3df <printf>
    exit();
  34:	e8 c1 01 00 00       	call   1fa <exit>
    kill(atoi(argv[i]));
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 34 9f             	push   (%edi,%ebx,4)
  3f:	e8 52 01 00 00       	call   196 <atoi>
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 de 01 00 00       	call   22a <kill>
  for(i=1; i<argc; i++)
  4c:	83 c3 01             	add    $0x1,%ebx
  4f:	83 c4 10             	add    $0x10,%esp
  52:	39 f3                	cmp    %esi,%ebx
  54:	7c e3                	jl     39 <main+0x39>
  exit();
  56:	e8 9f 01 00 00       	call   1fa <exit>

0000005b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5b:	55                   	push   %ebp
  5c:	89 e5                	mov    %esp,%ebp
  5e:	56                   	push   %esi
  5f:	53                   	push   %ebx
  60:	8b 75 08             	mov    0x8(%ebp),%esi
  63:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	89 f0                	mov    %esi,%eax
  68:	89 d1                	mov    %edx,%ecx
  6a:	83 c2 01             	add    $0x1,%edx
  6d:	89 c3                	mov    %eax,%ebx
  6f:	83 c0 01             	add    $0x1,%eax
  72:	0f b6 09             	movzbl (%ecx),%ecx
  75:	88 0b                	mov    %cl,(%ebx)
  77:	84 c9                	test   %cl,%cl
  79:	75 ed                	jne    68 <strcpy+0xd>
    ;
  return os;
}
  7b:	89 f0                	mov    %esi,%eax
  7d:	5b                   	pop    %ebx
  7e:	5e                   	pop    %esi
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  87:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8a:	eb 06                	jmp    92 <strcmp+0x11>
    p++, q++;
  8c:	83 c1 01             	add    $0x1,%ecx
  8f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  92:	0f b6 01             	movzbl (%ecx),%eax
  95:	84 c0                	test   %al,%al
  97:	74 04                	je     9d <strcmp+0x1c>
  99:	3a 02                	cmp    (%edx),%al
  9b:	74 ef                	je     8c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  9d:	0f b6 c0             	movzbl %al,%eax
  a0:	0f b6 12             	movzbl (%edx),%edx
  a3:	29 d0                	sub    %edx,%eax
}
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    

000000a7 <strlen>:

uint
strlen(const char *s)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ad:	b8 00 00 00 00       	mov    $0x0,%eax
  b2:	eb 03                	jmp    b7 <strlen+0x10>
  b4:	83 c0 01             	add    $0x1,%eax
  b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  bb:	75 f7                	jne    b4 <strlen+0xd>
    ;
  return n;
}
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    

000000bf <memset>:

void*
memset(void *dst, int c, uint n)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	57                   	push   %edi
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c6:	89 d7                	mov    %edx,%edi
  c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	fc                   	cld    
  cf:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d1:	89 d0                	mov    %edx,%eax
  d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d6:	c9                   	leave  
  d7:	c3                   	ret    

000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e2:	eb 03                	jmp    e7 <strchr+0xf>
  e4:	83 c0 01             	add    $0x1,%eax
  e7:	0f b6 10             	movzbl (%eax),%edx
  ea:	84 d2                	test   %dl,%dl
  ec:	74 06                	je     f4 <strchr+0x1c>
    if(*s == c)
  ee:	38 ca                	cmp    %cl,%dl
  f0:	75 f2                	jne    e4 <strchr+0xc>
  f2:	eb 05                	jmp    f9 <strchr+0x21>
      return (char*)s;
  return 0;
  f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <gets>:

char*
gets(char *buf, int max)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	57                   	push   %edi
  ff:	56                   	push   %esi
 100:	53                   	push   %ebx
 101:	83 ec 1c             	sub    $0x1c,%esp
 104:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 107:	bb 00 00 00 00       	mov    $0x0,%ebx
 10c:	89 de                	mov    %ebx,%esi
 10e:	83 c3 01             	add    $0x1,%ebx
 111:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 114:	7d 2e                	jge    144 <gets+0x49>
    cc = read(0, &c, 1);
 116:	83 ec 04             	sub    $0x4,%esp
 119:	6a 01                	push   $0x1
 11b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 11e:	50                   	push   %eax
 11f:	6a 00                	push   $0x0
 121:	e8 ec 00 00 00       	call   212 <read>
    if(cc < 1)
 126:	83 c4 10             	add    $0x10,%esp
 129:	85 c0                	test   %eax,%eax
 12b:	7e 17                	jle    144 <gets+0x49>
      break;
    buf[i++] = c;
 12d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 131:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 134:	3c 0a                	cmp    $0xa,%al
 136:	0f 94 c2             	sete   %dl
 139:	3c 0d                	cmp    $0xd,%al
 13b:	0f 94 c0             	sete   %al
 13e:	08 c2                	or     %al,%dl
 140:	74 ca                	je     10c <gets+0x11>
    buf[i++] = c;
 142:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 144:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 148:	89 f8                	mov    %edi,%eax
 14a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14d:	5b                   	pop    %ebx
 14e:	5e                   	pop    %esi
 14f:	5f                   	pop    %edi
 150:	5d                   	pop    %ebp
 151:	c3                   	ret    

00000152 <stat>:

int
stat(const char *n, struct stat *st)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	56                   	push   %esi
 156:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	6a 00                	push   $0x0
 15c:	ff 75 08             	push   0x8(%ebp)
 15f:	e8 d6 00 00 00       	call   23a <open>
  if(fd < 0)
 164:	83 c4 10             	add    $0x10,%esp
 167:	85 c0                	test   %eax,%eax
 169:	78 24                	js     18f <stat+0x3d>
 16b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16d:	83 ec 08             	sub    $0x8,%esp
 170:	ff 75 0c             	push   0xc(%ebp)
 173:	50                   	push   %eax
 174:	e8 d9 00 00 00       	call   252 <fstat>
 179:	89 c6                	mov    %eax,%esi
  close(fd);
 17b:	89 1c 24             	mov    %ebx,(%esp)
 17e:	e8 9f 00 00 00       	call   222 <close>
  return r;
 183:	83 c4 10             	add    $0x10,%esp
}
 186:	89 f0                	mov    %esi,%eax
 188:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18b:	5b                   	pop    %ebx
 18c:	5e                   	pop    %esi
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    
    return -1;
 18f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 194:	eb f0                	jmp    186 <stat+0x34>

00000196 <atoi>:

int
atoi(const char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	53                   	push   %ebx
 19a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 19d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a2:	eb 10                	jmp    1b4 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a4:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1a7:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1aa:	83 c1 01             	add    $0x1,%ecx
 1ad:	0f be c0             	movsbl %al,%eax
 1b0:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b4:	0f b6 01             	movzbl (%ecx),%eax
 1b7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ba:	80 fb 09             	cmp    $0x9,%bl
 1bd:	76 e5                	jbe    1a4 <atoi+0xe>
  return n;
}
 1bf:	89 d0                	mov    %edx,%eax
 1c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    

000001c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	56                   	push   %esi
 1ca:	53                   	push   %ebx
 1cb:	8b 75 08             	mov    0x8(%ebp),%esi
 1ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d1:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d4:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1d6:	eb 0d                	jmp    1e5 <memmove+0x1f>
    *dst++ = *src++;
 1d8:	0f b6 01             	movzbl (%ecx),%eax
 1db:	88 02                	mov    %al,(%edx)
 1dd:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e3:	89 d8                	mov    %ebx,%eax
 1e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1e8:	85 c0                	test   %eax,%eax
 1ea:	7f ec                	jg     1d8 <memmove+0x12>
  return vdst;
}
 1ec:	89 f0                	mov    %esi,%eax
 1ee:	5b                   	pop    %ebx
 1ef:	5e                   	pop    %esi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f2:	b8 01 00 00 00       	mov    $0x1,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <exit>:
SYSCALL(exit)
 1fa:	b8 02 00 00 00       	mov    $0x2,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <wait>:
SYSCALL(wait)
 202:	b8 03 00 00 00       	mov    $0x3,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <pipe>:
SYSCALL(pipe)
 20a:	b8 04 00 00 00       	mov    $0x4,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <read>:
SYSCALL(read)
 212:	b8 05 00 00 00       	mov    $0x5,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <write>:
SYSCALL(write)
 21a:	b8 10 00 00 00       	mov    $0x10,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <close>:
SYSCALL(close)
 222:	b8 15 00 00 00       	mov    $0x15,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <kill>:
SYSCALL(kill)
 22a:	b8 06 00 00 00       	mov    $0x6,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <exec>:
SYSCALL(exec)
 232:	b8 07 00 00 00       	mov    $0x7,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <open>:
SYSCALL(open)
 23a:	b8 0f 00 00 00       	mov    $0xf,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <mknod>:
SYSCALL(mknod)
 242:	b8 11 00 00 00       	mov    $0x11,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <unlink>:
SYSCALL(unlink)
 24a:	b8 12 00 00 00       	mov    $0x12,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <fstat>:
SYSCALL(fstat)
 252:	b8 08 00 00 00       	mov    $0x8,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <link>:
SYSCALL(link)
 25a:	b8 13 00 00 00       	mov    $0x13,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <mkdir>:
SYSCALL(mkdir)
 262:	b8 14 00 00 00       	mov    $0x14,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <chdir>:
SYSCALL(chdir)
 26a:	b8 09 00 00 00       	mov    $0x9,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <dup>:
SYSCALL(dup)
 272:	b8 0a 00 00 00       	mov    $0xa,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <getpid>:
SYSCALL(getpid)
 27a:	b8 0b 00 00 00       	mov    $0xb,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <sbrk>:
SYSCALL(sbrk)
 282:	b8 0c 00 00 00       	mov    $0xc,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <sleep>:
SYSCALL(sleep)
 28a:	b8 0d 00 00 00       	mov    $0xd,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <uptime>:
SYSCALL(uptime)
 292:	b8 0e 00 00 00       	mov    $0xe,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <hello>:
SYSCALL(hello)
 29a:	b8 16 00 00 00       	mov    $0x16,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <helloYou>:
SYSCALL(helloYou)
 2a2:	b8 17 00 00 00       	mov    $0x17,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <getppid>:
SYSCALL(getppid)
 2aa:	b8 18 00 00 00       	mov    $0x18,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b2:	b8 19 00 00 00       	mov    $0x19,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <signalProcess>:
SYSCALL(signalProcess)
 2ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <numvp>:
SYSCALL(numvp)
 2c2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <numpp>:
SYSCALL(numpp)
 2ca:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <init_counter>:

SYSCALL(init_counter)
 2d2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <update_cnt>:
SYSCALL(update_cnt)
 2da:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <display_count>:
SYSCALL(display_count)
 2e2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <init_counter_1>:
SYSCALL(init_counter_1)
 2ea:	b8 20 00 00 00       	mov    $0x20,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2f2:	b8 21 00 00 00       	mov    $0x21,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <display_count_1>:
SYSCALL(display_count_1)
 2fa:	b8 22 00 00 00       	mov    $0x22,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <init_counter_2>:
SYSCALL(init_counter_2)
 302:	b8 23 00 00 00       	mov    $0x23,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <update_cnt_2>:
SYSCALL(update_cnt_2)
 30a:	b8 24 00 00 00       	mov    $0x24,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <display_count_2>:
SYSCALL(display_count_2)
 312:	b8 25 00 00 00       	mov    $0x25,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <init_mylock>:
SYSCALL(init_mylock)
 31a:	b8 26 00 00 00       	mov    $0x26,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <acquire_mylock>:
SYSCALL(acquire_mylock)
 322:	b8 27 00 00 00       	mov    $0x27,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <release_mylock>:
SYSCALL(release_mylock)
 32a:	b8 28 00 00 00       	mov    $0x28,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <holding_mylock>:
 332:	b8 29 00 00 00       	mov    $0x29,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 1c             	sub    $0x1c,%esp
 340:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 343:	6a 01                	push   $0x1
 345:	8d 55 f4             	lea    -0xc(%ebp),%edx
 348:	52                   	push   %edx
 349:	50                   	push   %eax
 34a:	e8 cb fe ff ff       	call   21a <write>
}
 34f:	83 c4 10             	add    $0x10,%esp
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 2c             	sub    $0x2c,%esp
 35d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 360:	89 d0                	mov    %edx,%eax
 362:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 368:	0f 95 c1             	setne  %cl
 36b:	c1 ea 1f             	shr    $0x1f,%edx
 36e:	84 d1                	test   %dl,%cl
 370:	74 44                	je     3b6 <printint+0x62>
    neg = 1;
    x = -xx;
 372:	f7 d8                	neg    %eax
 374:	89 c1                	mov    %eax,%ecx
    neg = 1;
 376:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 382:	89 c8                	mov    %ecx,%eax
 384:	ba 00 00 00 00       	mov    $0x0,%edx
 389:	f7 f6                	div    %esi
 38b:	89 df                	mov    %ebx,%edi
 38d:	83 c3 01             	add    $0x1,%ebx
 390:	0f b6 92 00 07 00 00 	movzbl 0x700(%edx),%edx
 397:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 39b:	89 ca                	mov    %ecx,%edx
 39d:	89 c1                	mov    %eax,%ecx
 39f:	39 d6                	cmp    %edx,%esi
 3a1:	76 df                	jbe    382 <printint+0x2e>
  if(neg)
 3a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3a7:	74 31                	je     3da <printint+0x86>
    buf[i++] = '-';
 3a9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ae:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b4:	eb 17                	jmp    3cd <printint+0x79>
    x = xx;
 3b6:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3b8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3bf:	eb bc                	jmp    37d <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3c6:	89 f0                	mov    %esi,%eax
 3c8:	e8 6d ff ff ff       	call   33a <putc>
  while(--i >= 0)
 3cd:	83 eb 01             	sub    $0x1,%ebx
 3d0:	79 ef                	jns    3c1 <printint+0x6d>
}
 3d2:	83 c4 2c             	add    $0x2c,%esp
 3d5:	5b                   	pop    %ebx
 3d6:	5e                   	pop    %esi
 3d7:	5f                   	pop    %edi
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    
 3da:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3dd:	eb ee                	jmp    3cd <printint+0x79>

000003df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
 3e2:	57                   	push   %edi
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
 3e5:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3e8:	8d 45 10             	lea    0x10(%ebp),%eax
 3eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3ee:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f3:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f8:	eb 14                	jmp    40e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3fa:	89 fa                	mov    %edi,%edx
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	e8 36 ff ff ff       	call   33a <putc>
 404:	eb 05                	jmp    40b <printf+0x2c>
      }
    } else if(state == '%'){
 406:	83 fe 25             	cmp    $0x25,%esi
 409:	74 25                	je     430 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 40b:	83 c3 01             	add    $0x1,%ebx
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 415:	84 c0                	test   %al,%al
 417:	0f 84 20 01 00 00    	je     53d <printf+0x15e>
    c = fmt[i] & 0xff;
 41d:	0f be f8             	movsbl %al,%edi
 420:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 423:	85 f6                	test   %esi,%esi
 425:	75 df                	jne    406 <printf+0x27>
      if(c == '%'){
 427:	83 f8 25             	cmp    $0x25,%eax
 42a:	75 ce                	jne    3fa <printf+0x1b>
        state = '%';
 42c:	89 c6                	mov    %eax,%esi
 42e:	eb db                	jmp    40b <printf+0x2c>
      if(c == 'd'){
 430:	83 f8 25             	cmp    $0x25,%eax
 433:	0f 84 cf 00 00 00    	je     508 <printf+0x129>
 439:	0f 8c dd 00 00 00    	jl     51c <printf+0x13d>
 43f:	83 f8 78             	cmp    $0x78,%eax
 442:	0f 8f d4 00 00 00    	jg     51c <printf+0x13d>
 448:	83 f8 63             	cmp    $0x63,%eax
 44b:	0f 8c cb 00 00 00    	jl     51c <printf+0x13d>
 451:	83 e8 63             	sub    $0x63,%eax
 454:	83 f8 15             	cmp    $0x15,%eax
 457:	0f 87 bf 00 00 00    	ja     51c <printf+0x13d>
 45d:	ff 24 85 a8 06 00 00 	jmp    *0x6a8(,%eax,4)
        printint(fd, *ap, 10, 1);
 464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 467:	8b 17                	mov    (%edi),%edx
 469:	83 ec 0c             	sub    $0xc,%esp
 46c:	6a 01                	push   $0x1
 46e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	e8 d9 fe ff ff       	call   354 <printint>
        ap++;
 47b:	83 c7 04             	add    $0x4,%edi
 47e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 481:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 484:	be 00 00 00 00       	mov    $0x0,%esi
 489:	eb 80                	jmp    40b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 48b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48e:	8b 17                	mov    (%edi),%edx
 490:	83 ec 0c             	sub    $0xc,%esp
 493:	6a 00                	push   $0x0
 495:	b9 10 00 00 00       	mov    $0x10,%ecx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	e8 b2 fe ff ff       	call   354 <printint>
        ap++;
 4a2:	83 c7 04             	add    $0x4,%edi
 4a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ab:	be 00 00 00 00       	mov    $0x0,%esi
 4b0:	e9 56 ff ff ff       	jmp    40b <printf+0x2c>
        s = (char*)*ap;
 4b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b8:	8b 30                	mov    (%eax),%esi
        ap++;
 4ba:	83 c0 04             	add    $0x4,%eax
 4bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c0:	85 f6                	test   %esi,%esi
 4c2:	75 15                	jne    4d9 <printf+0xfa>
          s = "(null)";
 4c4:	be a0 06 00 00       	mov    $0x6a0,%esi
 4c9:	eb 0e                	jmp    4d9 <printf+0xfa>
          putc(fd, *s);
 4cb:	0f be d2             	movsbl %dl,%edx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	e8 64 fe ff ff       	call   33a <putc>
          s++;
 4d6:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4d9:	0f b6 16             	movzbl (%esi),%edx
 4dc:	84 d2                	test   %dl,%dl
 4de:	75 eb                	jne    4cb <printf+0xec>
      state = 0;
 4e0:	be 00 00 00 00       	mov    $0x0,%esi
 4e5:	e9 21 ff ff ff       	jmp    40b <printf+0x2c>
        putc(fd, *ap);
 4ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ed:	0f be 17             	movsbl (%edi),%edx
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	e8 42 fe ff ff       	call   33a <putc>
        ap++;
 4f8:	83 c7 04             	add    $0x4,%edi
 4fb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4fe:	be 00 00 00 00       	mov    $0x0,%esi
 503:	e9 03 ff ff ff       	jmp    40b <printf+0x2c>
        putc(fd, c);
 508:	89 fa                	mov    %edi,%edx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	e8 28 fe ff ff       	call   33a <putc>
      state = 0;
 512:	be 00 00 00 00       	mov    $0x0,%esi
 517:	e9 ef fe ff ff       	jmp    40b <printf+0x2c>
        putc(fd, '%');
 51c:	ba 25 00 00 00       	mov    $0x25,%edx
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	e8 11 fe ff ff       	call   33a <putc>
        putc(fd, c);
 529:	89 fa                	mov    %edi,%edx
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	e8 07 fe ff ff       	call   33a <putc>
      state = 0;
 533:	be 00 00 00 00       	mov    $0x0,%esi
 538:	e9 ce fe ff ff       	jmp    40b <printf+0x2c>
    }
  }
}
 53d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 540:	5b                   	pop    %ebx
 541:	5e                   	pop    %esi
 542:	5f                   	pop    %edi
 543:	5d                   	pop    %ebp
 544:	c3                   	ret    

00000545 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	57                   	push   %edi
 549:	56                   	push   %esi
 54a:	53                   	push   %ebx
 54b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 551:	a1 ac 09 00 00       	mov    0x9ac,%eax
 556:	eb 02                	jmp    55a <free+0x15>
 558:	89 d0                	mov    %edx,%eax
 55a:	39 c8                	cmp    %ecx,%eax
 55c:	73 04                	jae    562 <free+0x1d>
 55e:	39 08                	cmp    %ecx,(%eax)
 560:	77 12                	ja     574 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 562:	8b 10                	mov    (%eax),%edx
 564:	39 c2                	cmp    %eax,%edx
 566:	77 f0                	ja     558 <free+0x13>
 568:	39 c8                	cmp    %ecx,%eax
 56a:	72 08                	jb     574 <free+0x2f>
 56c:	39 ca                	cmp    %ecx,%edx
 56e:	77 04                	ja     574 <free+0x2f>
 570:	89 d0                	mov    %edx,%eax
 572:	eb e6                	jmp    55a <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 574:	8b 73 fc             	mov    -0x4(%ebx),%esi
 577:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57a:	8b 10                	mov    (%eax),%edx
 57c:	39 d7                	cmp    %edx,%edi
 57e:	74 19                	je     599 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 580:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 583:	8b 50 04             	mov    0x4(%eax),%edx
 586:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 589:	39 ce                	cmp    %ecx,%esi
 58b:	74 1b                	je     5a8 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 58d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 58f:	a3 ac 09 00 00       	mov    %eax,0x9ac
}
 594:	5b                   	pop    %ebx
 595:	5e                   	pop    %esi
 596:	5f                   	pop    %edi
 597:	5d                   	pop    %ebp
 598:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 599:	03 72 04             	add    0x4(%edx),%esi
 59c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 59f:	8b 10                	mov    (%eax),%edx
 5a1:	8b 12                	mov    (%edx),%edx
 5a3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a6:	eb db                	jmp    583 <free+0x3e>
    p->s.size += bp->s.size;
 5a8:	03 53 fc             	add    -0x4(%ebx),%edx
 5ab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ae:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b1:	89 10                	mov    %edx,(%eax)
 5b3:	eb da                	jmp    58f <free+0x4a>

000005b5 <morecore>:

static Header*
morecore(uint nu)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	53                   	push   %ebx
 5b9:	83 ec 04             	sub    $0x4,%esp
 5bc:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5be:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c3:	77 05                	ja     5ca <morecore+0x15>
    nu = 4096;
 5c5:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5ca:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d1:	83 ec 0c             	sub    $0xc,%esp
 5d4:	50                   	push   %eax
 5d5:	e8 a8 fc ff ff       	call   282 <sbrk>
  if(p == (char*)-1)
 5da:	83 c4 10             	add    $0x10,%esp
 5dd:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e0:	74 1c                	je     5fe <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e2:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5e5:	83 c0 08             	add    $0x8,%eax
 5e8:	83 ec 0c             	sub    $0xc,%esp
 5eb:	50                   	push   %eax
 5ec:	e8 54 ff ff ff       	call   545 <free>
  return freep;
 5f1:	a1 ac 09 00 00       	mov    0x9ac,%eax
 5f6:	83 c4 10             	add    $0x10,%esp
}
 5f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fc:	c9                   	leave  
 5fd:	c3                   	ret    
    return 0;
 5fe:	b8 00 00 00 00       	mov    $0x0,%eax
 603:	eb f4                	jmp    5f9 <morecore+0x44>

00000605 <malloc>:

void*
malloc(uint nbytes)
{
 605:	55                   	push   %ebp
 606:	89 e5                	mov    %esp,%ebp
 608:	53                   	push   %ebx
 609:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	8d 58 07             	lea    0x7(%eax),%ebx
 612:	c1 eb 03             	shr    $0x3,%ebx
 615:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 618:	8b 0d ac 09 00 00    	mov    0x9ac,%ecx
 61e:	85 c9                	test   %ecx,%ecx
 620:	74 04                	je     626 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 622:	8b 01                	mov    (%ecx),%eax
 624:	eb 4a                	jmp    670 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 626:	c7 05 ac 09 00 00 b0 	movl   $0x9b0,0x9ac
 62d:	09 00 00 
 630:	c7 05 b0 09 00 00 b0 	movl   $0x9b0,0x9b0
 637:	09 00 00 
    base.s.size = 0;
 63a:	c7 05 b4 09 00 00 00 	movl   $0x0,0x9b4
 641:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 644:	b9 b0 09 00 00       	mov    $0x9b0,%ecx
 649:	eb d7                	jmp    622 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 64b:	74 19                	je     666 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64d:	29 da                	sub    %ebx,%edx
 64f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 652:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 655:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 658:	89 0d ac 09 00 00    	mov    %ecx,0x9ac
      return (void*)(p + 1);
 65e:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 664:	c9                   	leave  
 665:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 666:	8b 10                	mov    (%eax),%edx
 668:	89 11                	mov    %edx,(%ecx)
 66a:	eb ec                	jmp    658 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66c:	89 c1                	mov    %eax,%ecx
 66e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 670:	8b 50 04             	mov    0x4(%eax),%edx
 673:	39 da                	cmp    %ebx,%edx
 675:	73 d4                	jae    64b <malloc+0x46>
    if(p == freep)
 677:	39 05 ac 09 00 00    	cmp    %eax,0x9ac
 67d:	75 ed                	jne    66c <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 67f:	89 d8                	mov    %ebx,%eax
 681:	e8 2f ff ff ff       	call   5b5 <morecore>
 686:	85 c0                	test   %eax,%eax
 688:	75 e2                	jne    66c <malloc+0x67>
 68a:	eb d5                	jmp    661 <malloc+0x5c>
