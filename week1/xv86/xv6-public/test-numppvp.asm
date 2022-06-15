
_test-numppvp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  int vpages = numvp();
  13:	e8 cf 02 00 00       	call   2e7 <numvp>
  18:	89 c6                	mov    %eax,%esi
  int ppages = numpp();
  1a:	e8 d0 02 00 00       	call   2ef <numpp>
  1f:	89 c3                	mov    %eax,%ebx
  printf(1, "Total user virtual pages: %d \n", vpages);
  21:	83 ec 04             	sub    $0x4,%esp
  24:	56                   	push   %esi
  25:	68 94 06 00 00       	push   $0x694
  2a:	6a 01                	push   $0x1
  2c:	e8 b3 03 00 00       	call   3e4 <printf>
  printf(1, "Total user physical pages: %d \n", ppages);
  31:	83 c4 0c             	add    $0xc,%esp
  34:	53                   	push   %ebx
  35:	68 b4 06 00 00       	push   $0x6b4
  3a:	6a 01                	push   $0x1
  3c:	e8 a3 03 00 00       	call   3e4 <printf>
  sbrk(8192);
  41:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
  48:	e8 5a 02 00 00       	call   2a7 <sbrk>
  int nvpages = numvp();
  4d:	e8 95 02 00 00       	call   2e7 <numvp>
  52:	89 c6                	mov    %eax,%esi
  int nppages = numpp();
  54:	e8 96 02 00 00       	call   2ef <numpp>
  59:	89 c3                	mov    %eax,%ebx
  printf(1, "Total user virtual pages now: %d \n", nvpages);
  5b:	83 c4 0c             	add    $0xc,%esp
  5e:	56                   	push   %esi
  5f:	68 d4 06 00 00       	push   $0x6d4
  64:	6a 01                	push   $0x1
  66:	e8 79 03 00 00       	call   3e4 <printf>
  printf(1, "Total user physical pages now: %d \n", nppages);
  6b:	83 c4 0c             	add    $0xc,%esp
  6e:	53                   	push   %ebx
  6f:	68 f8 06 00 00       	push   $0x6f8
  74:	6a 01                	push   $0x1
  76:	e8 69 03 00 00       	call   3e4 <printf>
  exit();
  7b:	e8 9f 01 00 00       	call   21f <exit>

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	56                   	push   %esi
  84:	53                   	push   %ebx
  85:	8b 75 08             	mov    0x8(%ebp),%esi
  88:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8b:	89 f0                	mov    %esi,%eax
  8d:	89 d1                	mov    %edx,%ecx
  8f:	83 c2 01             	add    $0x1,%edx
  92:	89 c3                	mov    %eax,%ebx
  94:	83 c0 01             	add    $0x1,%eax
  97:	0f b6 09             	movzbl (%ecx),%ecx
  9a:	88 0b                	mov    %cl,(%ebx)
  9c:	84 c9                	test   %cl,%cl
  9e:	75 ed                	jne    8d <strcpy+0xd>
    ;
  return os;
}
  a0:	89 f0                	mov    %esi,%eax
  a2:	5b                   	pop    %ebx
  a3:	5e                   	pop    %esi
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    

000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  af:	eb 06                	jmp    b7 <strcmp+0x11>
    p++, q++;
  b1:	83 c1 01             	add    $0x1,%ecx
  b4:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b7:	0f b6 01             	movzbl (%ecx),%eax
  ba:	84 c0                	test   %al,%al
  bc:	74 04                	je     c2 <strcmp+0x1c>
  be:	3a 02                	cmp    (%edx),%al
  c0:	74 ef                	je     b1 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  c2:	0f b6 c0             	movzbl %al,%eax
  c5:	0f b6 12             	movzbl (%edx),%edx
  c8:	29 d0                	sub    %edx,%eax
}
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d2:	b8 00 00 00 00       	mov    $0x0,%eax
  d7:	eb 03                	jmp    dc <strlen+0x10>
  d9:	83 c0 01             	add    $0x1,%eax
  dc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  e0:	75 f7                	jne    d9 <strlen+0xd>
    ;
  return n;
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
  e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  eb:	89 d7                	mov    %edx,%edi
  ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	fc                   	cld    
  f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f6:	89 d0                	mov    %edx,%eax
  f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <strchr>:

char*
strchr(const char *s, char c)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 107:	eb 03                	jmp    10c <strchr+0xf>
 109:	83 c0 01             	add    $0x1,%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	84 d2                	test   %dl,%dl
 111:	74 06                	je     119 <strchr+0x1c>
    if(*s == c)
 113:	38 ca                	cmp    %cl,%dl
 115:	75 f2                	jne    109 <strchr+0xc>
 117:	eb 05                	jmp    11e <strchr+0x21>
      return (char*)s;
  return 0;
 119:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
 125:	53                   	push   %ebx
 126:	83 ec 1c             	sub    $0x1c,%esp
 129:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	bb 00 00 00 00       	mov    $0x0,%ebx
 131:	89 de                	mov    %ebx,%esi
 133:	83 c3 01             	add    $0x1,%ebx
 136:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 139:	7d 2e                	jge    169 <gets+0x49>
    cc = read(0, &c, 1);
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	6a 01                	push   $0x1
 140:	8d 45 e7             	lea    -0x19(%ebp),%eax
 143:	50                   	push   %eax
 144:	6a 00                	push   $0x0
 146:	e8 ec 00 00 00       	call   237 <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 17                	jle    169 <gets+0x49>
      break;
    buf[i++] = c;
 152:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 156:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 159:	3c 0a                	cmp    $0xa,%al
 15b:	0f 94 c2             	sete   %dl
 15e:	3c 0d                	cmp    $0xd,%al
 160:	0f 94 c0             	sete   %al
 163:	08 c2                	or     %al,%dl
 165:	74 ca                	je     131 <gets+0x11>
    buf[i++] = c;
 167:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 169:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 16d:	89 f8                	mov    %edi,%eax
 16f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 172:	5b                   	pop    %ebx
 173:	5e                   	pop    %esi
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    

00000177 <stat>:

int
stat(const char *n, struct stat *st)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
 17a:	56                   	push   %esi
 17b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	6a 00                	push   $0x0
 181:	ff 75 08             	push   0x8(%ebp)
 184:	e8 d6 00 00 00       	call   25f <open>
  if(fd < 0)
 189:	83 c4 10             	add    $0x10,%esp
 18c:	85 c0                	test   %eax,%eax
 18e:	78 24                	js     1b4 <stat+0x3d>
 190:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 192:	83 ec 08             	sub    $0x8,%esp
 195:	ff 75 0c             	push   0xc(%ebp)
 198:	50                   	push   %eax
 199:	e8 d9 00 00 00       	call   277 <fstat>
 19e:	89 c6                	mov    %eax,%esi
  close(fd);
 1a0:	89 1c 24             	mov    %ebx,(%esp)
 1a3:	e8 9f 00 00 00       	call   247 <close>
  return r;
 1a8:	83 c4 10             	add    $0x10,%esp
}
 1ab:	89 f0                	mov    %esi,%eax
 1ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
    return -1;
 1b4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b9:	eb f0                	jmp    1ab <stat+0x34>

000001bb <atoi>:

int
atoi(const char *s)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	53                   	push   %ebx
 1bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1c2:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c7:	eb 10                	jmp    1d9 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1c9:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1cc:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1cf:	83 c1 01             	add    $0x1,%ecx
 1d2:	0f be c0             	movsbl %al,%eax
 1d5:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1d9:	0f b6 01             	movzbl (%ecx),%eax
 1dc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1df:	80 fb 09             	cmp    $0x9,%bl
 1e2:	76 e5                	jbe    1c9 <atoi+0xe>
  return n;
}
 1e4:	89 d0                	mov    %edx,%eax
 1e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	8b 75 08             	mov    0x8(%ebp),%esi
 1f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1fb:	eb 0d                	jmp    20a <memmove+0x1f>
    *dst++ = *src++;
 1fd:	0f b6 01             	movzbl (%ecx),%eax
 200:	88 02                	mov    %al,(%edx)
 202:	8d 49 01             	lea    0x1(%ecx),%ecx
 205:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 208:	89 d8                	mov    %ebx,%eax
 20a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 20d:	85 c0                	test   %eax,%eax
 20f:	7f ec                	jg     1fd <memmove+0x12>
  return vdst;
}
 211:	89 f0                	mov    %esi,%eax
 213:	5b                   	pop    %ebx
 214:	5e                   	pop    %esi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    

00000217 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <exit>:
SYSCALL(exit)
 21f:	b8 02 00 00 00       	mov    $0x2,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <wait>:
SYSCALL(wait)
 227:	b8 03 00 00 00       	mov    $0x3,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <pipe>:
SYSCALL(pipe)
 22f:	b8 04 00 00 00       	mov    $0x4,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <read>:
SYSCALL(read)
 237:	b8 05 00 00 00       	mov    $0x5,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <write>:
SYSCALL(write)
 23f:	b8 10 00 00 00       	mov    $0x10,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <close>:
SYSCALL(close)
 247:	b8 15 00 00 00       	mov    $0x15,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <kill>:
SYSCALL(kill)
 24f:	b8 06 00 00 00       	mov    $0x6,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <exec>:
SYSCALL(exec)
 257:	b8 07 00 00 00       	mov    $0x7,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <open>:
SYSCALL(open)
 25f:	b8 0f 00 00 00       	mov    $0xf,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mknod>:
SYSCALL(mknod)
 267:	b8 11 00 00 00       	mov    $0x11,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <unlink>:
SYSCALL(unlink)
 26f:	b8 12 00 00 00       	mov    $0x12,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <fstat>:
SYSCALL(fstat)
 277:	b8 08 00 00 00       	mov    $0x8,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <link>:
SYSCALL(link)
 27f:	b8 13 00 00 00       	mov    $0x13,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <mkdir>:
SYSCALL(mkdir)
 287:	b8 14 00 00 00       	mov    $0x14,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <chdir>:
SYSCALL(chdir)
 28f:	b8 09 00 00 00       	mov    $0x9,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <dup>:
SYSCALL(dup)
 297:	b8 0a 00 00 00       	mov    $0xa,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <getpid>:
SYSCALL(getpid)
 29f:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <sbrk>:
SYSCALL(sbrk)
 2a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <sleep>:
SYSCALL(sleep)
 2af:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <uptime>:
SYSCALL(uptime)
 2b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <hello>:
SYSCALL(hello)
 2bf:	b8 16 00 00 00       	mov    $0x16,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <helloYou>:
SYSCALL(helloYou)
 2c7:	b8 17 00 00 00       	mov    $0x17,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <getppid>:
SYSCALL(getppid)
 2cf:	b8 18 00 00 00       	mov    $0x18,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2d7:	b8 19 00 00 00       	mov    $0x19,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <signalProcess>:
SYSCALL(signalProcess)
 2df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <numvp>:
SYSCALL(numvp)
 2e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <numpp>:
SYSCALL(numpp)
 2ef:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <init_counter>:

SYSCALL(init_counter)
 2f7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <update_cnt>:
SYSCALL(update_cnt)
 2ff:	b8 1e 00 00 00       	mov    $0x1e,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <display_count>:
SYSCALL(display_count)
 307:	b8 1f 00 00 00       	mov    $0x1f,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <init_counter_1>:
SYSCALL(init_counter_1)
 30f:	b8 20 00 00 00       	mov    $0x20,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <update_cnt_1>:
SYSCALL(update_cnt_1)
 317:	b8 21 00 00 00       	mov    $0x21,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <display_count_1>:
SYSCALL(display_count_1)
 31f:	b8 22 00 00 00       	mov    $0x22,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <init_counter_2>:
SYSCALL(init_counter_2)
 327:	b8 23 00 00 00       	mov    $0x23,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <update_cnt_2>:
SYSCALL(update_cnt_2)
 32f:	b8 24 00 00 00       	mov    $0x24,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <display_count_2>:
 337:	b8 25 00 00 00       	mov    $0x25,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 1c             	sub    $0x1c,%esp
 345:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 348:	6a 01                	push   $0x1
 34a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 34d:	52                   	push   %edx
 34e:	50                   	push   %eax
 34f:	e8 eb fe ff ff       	call   23f <write>
}
 354:	83 c4 10             	add    $0x10,%esp
 357:	c9                   	leave  
 358:	c3                   	ret    

00000359 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	57                   	push   %edi
 35d:	56                   	push   %esi
 35e:	53                   	push   %ebx
 35f:	83 ec 2c             	sub    $0x2c,%esp
 362:	89 45 d0             	mov    %eax,-0x30(%ebp)
 365:	89 d0                	mov    %edx,%eax
 367:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 36d:	0f 95 c1             	setne  %cl
 370:	c1 ea 1f             	shr    $0x1f,%edx
 373:	84 d1                	test   %dl,%cl
 375:	74 44                	je     3bb <printint+0x62>
    neg = 1;
    x = -xx;
 377:	f7 d8                	neg    %eax
 379:	89 c1                	mov    %eax,%ecx
    neg = 1;
 37b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 382:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 387:	89 c8                	mov    %ecx,%eax
 389:	ba 00 00 00 00       	mov    $0x0,%edx
 38e:	f7 f6                	div    %esi
 390:	89 df                	mov    %ebx,%edi
 392:	83 c3 01             	add    $0x1,%ebx
 395:	0f b6 92 7c 07 00 00 	movzbl 0x77c(%edx),%edx
 39c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a0:	89 ca                	mov    %ecx,%edx
 3a2:	89 c1                	mov    %eax,%ecx
 3a4:	39 d6                	cmp    %edx,%esi
 3a6:	76 df                	jbe    387 <printint+0x2e>
  if(neg)
 3a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3ac:	74 31                	je     3df <printint+0x86>
    buf[i++] = '-';
 3ae:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b3:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b6:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b9:	eb 17                	jmp    3d2 <printint+0x79>
    x = xx;
 3bb:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c4:	eb bc                	jmp    382 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3cb:	89 f0                	mov    %esi,%eax
 3cd:	e8 6d ff ff ff       	call   33f <putc>
  while(--i >= 0)
 3d2:	83 eb 01             	sub    $0x1,%ebx
 3d5:	79 ef                	jns    3c6 <printint+0x6d>
}
 3d7:	83 c4 2c             	add    $0x2c,%esp
 3da:	5b                   	pop    %ebx
 3db:	5e                   	pop    %esi
 3dc:	5f                   	pop    %edi
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e2:	eb ee                	jmp    3d2 <printint+0x79>

000003e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ed:	8d 45 10             	lea    0x10(%ebp),%eax
 3f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f8:	bb 00 00 00 00       	mov    $0x0,%ebx
 3fd:	eb 14                	jmp    413 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3ff:	89 fa                	mov    %edi,%edx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	e8 36 ff ff ff       	call   33f <putc>
 409:	eb 05                	jmp    410 <printf+0x2c>
      }
    } else if(state == '%'){
 40b:	83 fe 25             	cmp    $0x25,%esi
 40e:	74 25                	je     435 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 410:	83 c3 01             	add    $0x1,%ebx
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 41a:	84 c0                	test   %al,%al
 41c:	0f 84 20 01 00 00    	je     542 <printf+0x15e>
    c = fmt[i] & 0xff;
 422:	0f be f8             	movsbl %al,%edi
 425:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 428:	85 f6                	test   %esi,%esi
 42a:	75 df                	jne    40b <printf+0x27>
      if(c == '%'){
 42c:	83 f8 25             	cmp    $0x25,%eax
 42f:	75 ce                	jne    3ff <printf+0x1b>
        state = '%';
 431:	89 c6                	mov    %eax,%esi
 433:	eb db                	jmp    410 <printf+0x2c>
      if(c == 'd'){
 435:	83 f8 25             	cmp    $0x25,%eax
 438:	0f 84 cf 00 00 00    	je     50d <printf+0x129>
 43e:	0f 8c dd 00 00 00    	jl     521 <printf+0x13d>
 444:	83 f8 78             	cmp    $0x78,%eax
 447:	0f 8f d4 00 00 00    	jg     521 <printf+0x13d>
 44d:	83 f8 63             	cmp    $0x63,%eax
 450:	0f 8c cb 00 00 00    	jl     521 <printf+0x13d>
 456:	83 e8 63             	sub    $0x63,%eax
 459:	83 f8 15             	cmp    $0x15,%eax
 45c:	0f 87 bf 00 00 00    	ja     521 <printf+0x13d>
 462:	ff 24 85 24 07 00 00 	jmp    *0x724(,%eax,4)
        printint(fd, *ap, 10, 1);
 469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46c:	8b 17                	mov    (%edi),%edx
 46e:	83 ec 0c             	sub    $0xc,%esp
 471:	6a 01                	push   $0x1
 473:	b9 0a 00 00 00       	mov    $0xa,%ecx
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	e8 d9 fe ff ff       	call   359 <printint>
        ap++;
 480:	83 c7 04             	add    $0x4,%edi
 483:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 486:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 489:	be 00 00 00 00       	mov    $0x0,%esi
 48e:	eb 80                	jmp    410 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 493:	8b 17                	mov    (%edi),%edx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 00                	push   $0x0
 49a:	b9 10 00 00 00       	mov    $0x10,%ecx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 b2 fe ff ff       	call   359 <printint>
        ap++;
 4a7:	83 c7 04             	add    $0x4,%edi
 4aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ad:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b0:	be 00 00 00 00       	mov    $0x0,%esi
 4b5:	e9 56 ff ff ff       	jmp    410 <printf+0x2c>
        s = (char*)*ap;
 4ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bd:	8b 30                	mov    (%eax),%esi
        ap++;
 4bf:	83 c0 04             	add    $0x4,%eax
 4c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c5:	85 f6                	test   %esi,%esi
 4c7:	75 15                	jne    4de <printf+0xfa>
          s = "(null)";
 4c9:	be 1c 07 00 00       	mov    $0x71c,%esi
 4ce:	eb 0e                	jmp    4de <printf+0xfa>
          putc(fd, *s);
 4d0:	0f be d2             	movsbl %dl,%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	e8 64 fe ff ff       	call   33f <putc>
          s++;
 4db:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4de:	0f b6 16             	movzbl (%esi),%edx
 4e1:	84 d2                	test   %dl,%dl
 4e3:	75 eb                	jne    4d0 <printf+0xec>
      state = 0;
 4e5:	be 00 00 00 00       	mov    $0x0,%esi
 4ea:	e9 21 ff ff ff       	jmp    410 <printf+0x2c>
        putc(fd, *ap);
 4ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f2:	0f be 17             	movsbl (%edi),%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 42 fe ff ff       	call   33f <putc>
        ap++;
 4fd:	83 c7 04             	add    $0x4,%edi
 500:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 503:	be 00 00 00 00       	mov    $0x0,%esi
 508:	e9 03 ff ff ff       	jmp    410 <printf+0x2c>
        putc(fd, c);
 50d:	89 fa                	mov    %edi,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 28 fe ff ff       	call   33f <putc>
      state = 0;
 517:	be 00 00 00 00       	mov    $0x0,%esi
 51c:	e9 ef fe ff ff       	jmp    410 <printf+0x2c>
        putc(fd, '%');
 521:	ba 25 00 00 00       	mov    $0x25,%edx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	e8 11 fe ff ff       	call   33f <putc>
        putc(fd, c);
 52e:	89 fa                	mov    %edi,%edx
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	e8 07 fe ff ff       	call   33f <putc>
      state = 0;
 538:	be 00 00 00 00       	mov    $0x0,%esi
 53d:	e9 ce fe ff ff       	jmp    410 <printf+0x2c>
    }
  }
}
 542:	8d 65 f4             	lea    -0xc(%ebp),%esp
 545:	5b                   	pop    %ebx
 546:	5e                   	pop    %esi
 547:	5f                   	pop    %edi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    

0000054a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	57                   	push   %edi
 54e:	56                   	push   %esi
 54f:	53                   	push   %ebx
 550:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 553:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 556:	a1 24 0a 00 00       	mov    0xa24,%eax
 55b:	eb 02                	jmp    55f <free+0x15>
 55d:	89 d0                	mov    %edx,%eax
 55f:	39 c8                	cmp    %ecx,%eax
 561:	73 04                	jae    567 <free+0x1d>
 563:	39 08                	cmp    %ecx,(%eax)
 565:	77 12                	ja     579 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 567:	8b 10                	mov    (%eax),%edx
 569:	39 c2                	cmp    %eax,%edx
 56b:	77 f0                	ja     55d <free+0x13>
 56d:	39 c8                	cmp    %ecx,%eax
 56f:	72 08                	jb     579 <free+0x2f>
 571:	39 ca                	cmp    %ecx,%edx
 573:	77 04                	ja     579 <free+0x2f>
 575:	89 d0                	mov    %edx,%eax
 577:	eb e6                	jmp    55f <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 579:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57f:	8b 10                	mov    (%eax),%edx
 581:	39 d7                	cmp    %edx,%edi
 583:	74 19                	je     59e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 585:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 588:	8b 50 04             	mov    0x4(%eax),%edx
 58b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58e:	39 ce                	cmp    %ecx,%esi
 590:	74 1b                	je     5ad <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 592:	89 08                	mov    %ecx,(%eax)
  freep = p;
 594:	a3 24 0a 00 00       	mov    %eax,0xa24
}
 599:	5b                   	pop    %ebx
 59a:	5e                   	pop    %esi
 59b:	5f                   	pop    %edi
 59c:	5d                   	pop    %ebp
 59d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59e:	03 72 04             	add    0x4(%edx),%esi
 5a1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a4:	8b 10                	mov    (%eax),%edx
 5a6:	8b 12                	mov    (%edx),%edx
 5a8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5ab:	eb db                	jmp    588 <free+0x3e>
    p->s.size += bp->s.size;
 5ad:	03 53 fc             	add    -0x4(%ebx),%edx
 5b0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b6:	89 10                	mov    %edx,(%eax)
 5b8:	eb da                	jmp    594 <free+0x4a>

000005ba <morecore>:

static Header*
morecore(uint nu)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	53                   	push   %ebx
 5be:	83 ec 04             	sub    $0x4,%esp
 5c1:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c8:	77 05                	ja     5cf <morecore+0x15>
    nu = 4096;
 5ca:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5cf:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d6:	83 ec 0c             	sub    $0xc,%esp
 5d9:	50                   	push   %eax
 5da:	e8 c8 fc ff ff       	call   2a7 <sbrk>
  if(p == (char*)-1)
 5df:	83 c4 10             	add    $0x10,%esp
 5e2:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e5:	74 1c                	je     603 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ea:	83 c0 08             	add    $0x8,%eax
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	50                   	push   %eax
 5f1:	e8 54 ff ff ff       	call   54a <free>
  return freep;
 5f6:	a1 24 0a 00 00       	mov    0xa24,%eax
 5fb:	83 c4 10             	add    $0x10,%esp
}
 5fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 601:	c9                   	leave  
 602:	c3                   	ret    
    return 0;
 603:	b8 00 00 00 00       	mov    $0x0,%eax
 608:	eb f4                	jmp    5fe <morecore+0x44>

0000060a <malloc>:

void*
malloc(uint nbytes)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	53                   	push   %ebx
 60e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	8d 58 07             	lea    0x7(%eax),%ebx
 617:	c1 eb 03             	shr    $0x3,%ebx
 61a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 61d:	8b 0d 24 0a 00 00    	mov    0xa24,%ecx
 623:	85 c9                	test   %ecx,%ecx
 625:	74 04                	je     62b <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 627:	8b 01                	mov    (%ecx),%eax
 629:	eb 4a                	jmp    675 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 62b:	c7 05 24 0a 00 00 28 	movl   $0xa28,0xa24
 632:	0a 00 00 
 635:	c7 05 28 0a 00 00 28 	movl   $0xa28,0xa28
 63c:	0a 00 00 
    base.s.size = 0;
 63f:	c7 05 2c 0a 00 00 00 	movl   $0x0,0xa2c
 646:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 649:	b9 28 0a 00 00       	mov    $0xa28,%ecx
 64e:	eb d7                	jmp    627 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 650:	74 19                	je     66b <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 652:	29 da                	sub    %ebx,%edx
 654:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 657:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 65a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 65d:	89 0d 24 0a 00 00    	mov    %ecx,0xa24
      return (void*)(p + 1);
 663:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 669:	c9                   	leave  
 66a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 66b:	8b 10                	mov    (%eax),%edx
 66d:	89 11                	mov    %edx,(%ecx)
 66f:	eb ec                	jmp    65d <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 671:	89 c1                	mov    %eax,%ecx
 673:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	39 da                	cmp    %ebx,%edx
 67a:	73 d4                	jae    650 <malloc+0x46>
    if(p == freep)
 67c:	39 05 24 0a 00 00    	cmp    %eax,0xa24
 682:	75 ed                	jne    671 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 684:	89 d8                	mov    %ebx,%eax
 686:	e8 2f ff ff ff       	call   5ba <morecore>
 68b:	85 c0                	test   %eax,%eax
 68d:	75 e2                	jne    671 <malloc+0x67>
 68f:	eb d5                	jmp    666 <malloc+0x5c>
