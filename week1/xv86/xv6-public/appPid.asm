
_appPid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 19                	mov    (%ecx),%ebx
    int i;
    if (argc <= 1)
  11:	83 fb 01             	cmp    $0x1,%ebx
  14:	7e 0a                	jle    20 <main+0x20>
    {
        printf(1, "enter any value at runtime\n");
    }

    if (argc < 2)
  16:	83 fb 01             	cmp    $0x1,%ebx
  19:	7e 19                	jle    34 <main+0x34>
        printf(2, "usage: pname pid...\n");
        exit();
    }
    for (i = 1; i < argc; i++)
        // getppid(atoi(argv[i]));
    exit();
  1b:	e8 c7 01 00 00       	call   1e7 <exit>
        printf(1, "enter any value at runtime\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 5c 06 00 00       	push   $0x65c
  28:	6a 01                	push   $0x1
  2a:	e8 7d 03 00 00       	call   3ac <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	eb e2                	jmp    16 <main+0x16>
        printf(2, "usage: pname pid...\n");
  34:	83 ec 08             	sub    $0x8,%esp
  37:	68 78 06 00 00       	push   $0x678
  3c:	6a 02                	push   $0x2
  3e:	e8 69 03 00 00       	call   3ac <printf>
        exit();
  43:	e8 9f 01 00 00       	call   1e7 <exit>

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	56                   	push   %esi
  4c:	53                   	push   %ebx
  4d:	8b 75 08             	mov    0x8(%ebp),%esi
  50:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  53:	89 f0                	mov    %esi,%eax
  55:	89 d1                	mov    %edx,%ecx
  57:	83 c2 01             	add    $0x1,%edx
  5a:	89 c3                	mov    %eax,%ebx
  5c:	83 c0 01             	add    $0x1,%eax
  5f:	0f b6 09             	movzbl (%ecx),%ecx
  62:	88 0b                	mov    %cl,(%ebx)
  64:	84 c9                	test   %cl,%cl
  66:	75 ed                	jne    55 <strcpy+0xd>
    ;
  return os;
}
  68:	89 f0                	mov    %esi,%eax
  6a:	5b                   	pop    %ebx
  6b:	5e                   	pop    %esi
  6c:	5d                   	pop    %ebp
  6d:	c3                   	ret    

0000006e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6e:	55                   	push   %ebp
  6f:	89 e5                	mov    %esp,%ebp
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  77:	eb 06                	jmp    7f <strcmp+0x11>
    p++, q++;
  79:	83 c1 01             	add    $0x1,%ecx
  7c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  7f:	0f b6 01             	movzbl (%ecx),%eax
  82:	84 c0                	test   %al,%al
  84:	74 04                	je     8a <strcmp+0x1c>
  86:	3a 02                	cmp    (%edx),%al
  88:	74 ef                	je     79 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8a:	0f b6 c0             	movzbl %al,%eax
  8d:	0f b6 12             	movzbl (%edx),%edx
  90:	29 d0                	sub    %edx,%eax
}
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    

00000094 <strlen>:

uint
strlen(const char *s)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  9a:	b8 00 00 00 00       	mov    $0x0,%eax
  9f:	eb 03                	jmp    a4 <strlen+0x10>
  a1:	83 c0 01             	add    $0x1,%eax
  a4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  a8:	75 f7                	jne    a1 <strlen+0xd>
    ;
  return n;
}
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b3:	89 d7                	mov    %edx,%edi
  b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	fc                   	cld    
  bc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  be:	89 d0                	mov    %edx,%eax
  c0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strchr>:

char*
strchr(const char *s, char c)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  cf:	eb 03                	jmp    d4 <strchr+0xf>
  d1:	83 c0 01             	add    $0x1,%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	84 d2                	test   %dl,%dl
  d9:	74 06                	je     e1 <strchr+0x1c>
    if(*s == c)
  db:	38 ca                	cmp    %cl,%dl
  dd:	75 f2                	jne    d1 <strchr+0xc>
  df:	eb 05                	jmp    e6 <strchr+0x21>
      return (char*)s;
  return 0;
  e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
  ec:	56                   	push   %esi
  ed:	53                   	push   %ebx
  ee:	83 ec 1c             	sub    $0x1c,%esp
  f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  f9:	89 de                	mov    %ebx,%esi
  fb:	83 c3 01             	add    $0x1,%ebx
  fe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 101:	7d 2e                	jge    131 <gets+0x49>
    cc = read(0, &c, 1);
 103:	83 ec 04             	sub    $0x4,%esp
 106:	6a 01                	push   $0x1
 108:	8d 45 e7             	lea    -0x19(%ebp),%eax
 10b:	50                   	push   %eax
 10c:	6a 00                	push   $0x0
 10e:	e8 ec 00 00 00       	call   1ff <read>
    if(cc < 1)
 113:	83 c4 10             	add    $0x10,%esp
 116:	85 c0                	test   %eax,%eax
 118:	7e 17                	jle    131 <gets+0x49>
      break;
    buf[i++] = c;
 11a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11e:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 121:	3c 0a                	cmp    $0xa,%al
 123:	0f 94 c2             	sete   %dl
 126:	3c 0d                	cmp    $0xd,%al
 128:	0f 94 c0             	sete   %al
 12b:	08 c2                	or     %al,%dl
 12d:	74 ca                	je     f9 <gets+0x11>
    buf[i++] = c;
 12f:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 131:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 135:	89 f8                	mov    %edi,%eax
 137:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13a:	5b                   	pop    %ebx
 13b:	5e                   	pop    %esi
 13c:	5f                   	pop    %edi
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    

0000013f <stat>:

int
stat(const char *n, struct stat *st)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	56                   	push   %esi
 143:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 144:	83 ec 08             	sub    $0x8,%esp
 147:	6a 00                	push   $0x0
 149:	ff 75 08             	push   0x8(%ebp)
 14c:	e8 d6 00 00 00       	call   227 <open>
  if(fd < 0)
 151:	83 c4 10             	add    $0x10,%esp
 154:	85 c0                	test   %eax,%eax
 156:	78 24                	js     17c <stat+0x3d>
 158:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15a:	83 ec 08             	sub    $0x8,%esp
 15d:	ff 75 0c             	push   0xc(%ebp)
 160:	50                   	push   %eax
 161:	e8 d9 00 00 00       	call   23f <fstat>
 166:	89 c6                	mov    %eax,%esi
  close(fd);
 168:	89 1c 24             	mov    %ebx,(%esp)
 16b:	e8 9f 00 00 00       	call   20f <close>
  return r;
 170:	83 c4 10             	add    $0x10,%esp
}
 173:	89 f0                	mov    %esi,%eax
 175:	8d 65 f8             	lea    -0x8(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret    
    return -1;
 17c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 181:	eb f0                	jmp    173 <stat+0x34>

00000183 <atoi>:

int
atoi(const char *s)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	53                   	push   %ebx
 187:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 18a:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 18f:	eb 10                	jmp    1a1 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 191:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 194:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 197:	83 c1 01             	add    $0x1,%ecx
 19a:	0f be c0             	movsbl %al,%eax
 19d:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a7:	80 fb 09             	cmp    $0x9,%bl
 1aa:	76 e5                	jbe    191 <atoi+0xe>
  return n;
}
 1ac:	89 d0                	mov    %edx,%eax
 1ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	8b 75 08             	mov    0x8(%ebp),%esi
 1bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1be:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1c1:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1c3:	eb 0d                	jmp    1d2 <memmove+0x1f>
    *dst++ = *src++;
 1c5:	0f b6 01             	movzbl (%ecx),%eax
 1c8:	88 02                	mov    %al,(%edx)
 1ca:	8d 49 01             	lea    0x1(%ecx),%ecx
 1cd:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1d0:	89 d8                	mov    %ebx,%eax
 1d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1d5:	85 c0                	test   %eax,%eax
 1d7:	7f ec                	jg     1c5 <memmove+0x12>
  return vdst;
}
 1d9:	89 f0                	mov    %esi,%eax
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1df:	b8 01 00 00 00       	mov    $0x1,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <exit>:
SYSCALL(exit)
 1e7:	b8 02 00 00 00       	mov    $0x2,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <wait>:
SYSCALL(wait)
 1ef:	b8 03 00 00 00       	mov    $0x3,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <pipe>:
SYSCALL(pipe)
 1f7:	b8 04 00 00 00       	mov    $0x4,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <read>:
SYSCALL(read)
 1ff:	b8 05 00 00 00       	mov    $0x5,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <write>:
SYSCALL(write)
 207:	b8 10 00 00 00       	mov    $0x10,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <close>:
SYSCALL(close)
 20f:	b8 15 00 00 00       	mov    $0x15,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <kill>:
SYSCALL(kill)
 217:	b8 06 00 00 00       	mov    $0x6,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <exec>:
SYSCALL(exec)
 21f:	b8 07 00 00 00       	mov    $0x7,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <open>:
SYSCALL(open)
 227:	b8 0f 00 00 00       	mov    $0xf,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <mknod>:
SYSCALL(mknod)
 22f:	b8 11 00 00 00       	mov    $0x11,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <unlink>:
SYSCALL(unlink)
 237:	b8 12 00 00 00       	mov    $0x12,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <fstat>:
SYSCALL(fstat)
 23f:	b8 08 00 00 00       	mov    $0x8,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <link>:
SYSCALL(link)
 247:	b8 13 00 00 00       	mov    $0x13,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <mkdir>:
SYSCALL(mkdir)
 24f:	b8 14 00 00 00       	mov    $0x14,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <chdir>:
SYSCALL(chdir)
 257:	b8 09 00 00 00       	mov    $0x9,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <dup>:
SYSCALL(dup)
 25f:	b8 0a 00 00 00       	mov    $0xa,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <getpid>:
SYSCALL(getpid)
 267:	b8 0b 00 00 00       	mov    $0xb,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <sbrk>:
SYSCALL(sbrk)
 26f:	b8 0c 00 00 00       	mov    $0xc,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <sleep>:
SYSCALL(sleep)
 277:	b8 0d 00 00 00       	mov    $0xd,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <uptime>:
SYSCALL(uptime)
 27f:	b8 0e 00 00 00       	mov    $0xe,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <hello>:
SYSCALL(hello)
 287:	b8 16 00 00 00       	mov    $0x16,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <helloYou>:
SYSCALL(helloYou)
 28f:	b8 17 00 00 00       	mov    $0x17,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <getppid>:
SYSCALL(getppid)
 297:	b8 18 00 00 00       	mov    $0x18,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <get_siblings_info>:
SYSCALL(get_siblings_info)
 29f:	b8 19 00 00 00       	mov    $0x19,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <signalProcess>:
SYSCALL(signalProcess)
 2a7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <numvp>:
SYSCALL(numvp)
 2af:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <numpp>:
SYSCALL(numpp)
 2b7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <init_counter>:

SYSCALL(init_counter)
 2bf:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <update_cnt>:
SYSCALL(update_cnt)
 2c7:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <display_count>:
SYSCALL(display_count)
 2cf:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <init_counter_1>:
SYSCALL(init_counter_1)
 2d7:	b8 20 00 00 00       	mov    $0x20,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <update_cnt_1>:
SYSCALL(update_cnt_1)
 2df:	b8 21 00 00 00       	mov    $0x21,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <display_count_1>:
SYSCALL(display_count_1)
 2e7:	b8 22 00 00 00       	mov    $0x22,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <init_counter_2>:
SYSCALL(init_counter_2)
 2ef:	b8 23 00 00 00       	mov    $0x23,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <update_cnt_2>:
SYSCALL(update_cnt_2)
 2f7:	b8 24 00 00 00       	mov    $0x24,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <display_count_2>:
 2ff:	b8 25 00 00 00       	mov    $0x25,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 1c             	sub    $0x1c,%esp
 30d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 310:	6a 01                	push   $0x1
 312:	8d 55 f4             	lea    -0xc(%ebp),%edx
 315:	52                   	push   %edx
 316:	50                   	push   %eax
 317:	e8 eb fe ff ff       	call   207 <write>
}
 31c:	83 c4 10             	add    $0x10,%esp
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	57                   	push   %edi
 325:	56                   	push   %esi
 326:	53                   	push   %ebx
 327:	83 ec 2c             	sub    $0x2c,%esp
 32a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 32d:	89 d0                	mov    %edx,%eax
 32f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 335:	0f 95 c1             	setne  %cl
 338:	c1 ea 1f             	shr    $0x1f,%edx
 33b:	84 d1                	test   %dl,%cl
 33d:	74 44                	je     383 <printint+0x62>
    neg = 1;
    x = -xx;
 33f:	f7 d8                	neg    %eax
 341:	89 c1                	mov    %eax,%ecx
    neg = 1;
 343:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 34a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 34f:	89 c8                	mov    %ecx,%eax
 351:	ba 00 00 00 00       	mov    $0x0,%edx
 356:	f7 f6                	div    %esi
 358:	89 df                	mov    %ebx,%edi
 35a:	83 c3 01             	add    $0x1,%ebx
 35d:	0f b6 92 ec 06 00 00 	movzbl 0x6ec(%edx),%edx
 364:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 368:	89 ca                	mov    %ecx,%edx
 36a:	89 c1                	mov    %eax,%ecx
 36c:	39 d6                	cmp    %edx,%esi
 36e:	76 df                	jbe    34f <printint+0x2e>
  if(neg)
 370:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 374:	74 31                	je     3a7 <printint+0x86>
    buf[i++] = '-';
 376:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 37b:	8d 5f 02             	lea    0x2(%edi),%ebx
 37e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 381:	eb 17                	jmp    39a <printint+0x79>
    x = xx;
 383:	89 c1                	mov    %eax,%ecx
  neg = 0;
 385:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 38c:	eb bc                	jmp    34a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 38e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 393:	89 f0                	mov    %esi,%eax
 395:	e8 6d ff ff ff       	call   307 <putc>
  while(--i >= 0)
 39a:	83 eb 01             	sub    $0x1,%ebx
 39d:	79 ef                	jns    38e <printint+0x6d>
}
 39f:	83 c4 2c             	add    $0x2c,%esp
 3a2:	5b                   	pop    %ebx
 3a3:	5e                   	pop    %esi
 3a4:	5f                   	pop    %edi
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3aa:	eb ee                	jmp    39a <printint+0x79>

000003ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3b5:	8d 45 10             	lea    0x10(%ebp),%eax
 3b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3bb:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3c5:	eb 14                	jmp    3db <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3c7:	89 fa                	mov    %edi,%edx
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	e8 36 ff ff ff       	call   307 <putc>
 3d1:	eb 05                	jmp    3d8 <printf+0x2c>
      }
    } else if(state == '%'){
 3d3:	83 fe 25             	cmp    $0x25,%esi
 3d6:	74 25                	je     3fd <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3d8:	83 c3 01             	add    $0x1,%ebx
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3e2:	84 c0                	test   %al,%al
 3e4:	0f 84 20 01 00 00    	je     50a <printf+0x15e>
    c = fmt[i] & 0xff;
 3ea:	0f be f8             	movsbl %al,%edi
 3ed:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3f0:	85 f6                	test   %esi,%esi
 3f2:	75 df                	jne    3d3 <printf+0x27>
      if(c == '%'){
 3f4:	83 f8 25             	cmp    $0x25,%eax
 3f7:	75 ce                	jne    3c7 <printf+0x1b>
        state = '%';
 3f9:	89 c6                	mov    %eax,%esi
 3fb:	eb db                	jmp    3d8 <printf+0x2c>
      if(c == 'd'){
 3fd:	83 f8 25             	cmp    $0x25,%eax
 400:	0f 84 cf 00 00 00    	je     4d5 <printf+0x129>
 406:	0f 8c dd 00 00 00    	jl     4e9 <printf+0x13d>
 40c:	83 f8 78             	cmp    $0x78,%eax
 40f:	0f 8f d4 00 00 00    	jg     4e9 <printf+0x13d>
 415:	83 f8 63             	cmp    $0x63,%eax
 418:	0f 8c cb 00 00 00    	jl     4e9 <printf+0x13d>
 41e:	83 e8 63             	sub    $0x63,%eax
 421:	83 f8 15             	cmp    $0x15,%eax
 424:	0f 87 bf 00 00 00    	ja     4e9 <printf+0x13d>
 42a:	ff 24 85 94 06 00 00 	jmp    *0x694(,%eax,4)
        printint(fd, *ap, 10, 1);
 431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 434:	8b 17                	mov    (%edi),%edx
 436:	83 ec 0c             	sub    $0xc,%esp
 439:	6a 01                	push   $0x1
 43b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	e8 d9 fe ff ff       	call   321 <printint>
        ap++;
 448:	83 c7 04             	add    $0x4,%edi
 44b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 44e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 451:	be 00 00 00 00       	mov    $0x0,%esi
 456:	eb 80                	jmp    3d8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 45b:	8b 17                	mov    (%edi),%edx
 45d:	83 ec 0c             	sub    $0xc,%esp
 460:	6a 00                	push   $0x0
 462:	b9 10 00 00 00       	mov    $0x10,%ecx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	e8 b2 fe ff ff       	call   321 <printint>
        ap++;
 46f:	83 c7 04             	add    $0x4,%edi
 472:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 475:	83 c4 10             	add    $0x10,%esp
      state = 0;
 478:	be 00 00 00 00       	mov    $0x0,%esi
 47d:	e9 56 ff ff ff       	jmp    3d8 <printf+0x2c>
        s = (char*)*ap;
 482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 485:	8b 30                	mov    (%eax),%esi
        ap++;
 487:	83 c0 04             	add    $0x4,%eax
 48a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 48d:	85 f6                	test   %esi,%esi
 48f:	75 15                	jne    4a6 <printf+0xfa>
          s = "(null)";
 491:	be 8d 06 00 00       	mov    $0x68d,%esi
 496:	eb 0e                	jmp    4a6 <printf+0xfa>
          putc(fd, *s);
 498:	0f be d2             	movsbl %dl,%edx
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	e8 64 fe ff ff       	call   307 <putc>
          s++;
 4a3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4a6:	0f b6 16             	movzbl (%esi),%edx
 4a9:	84 d2                	test   %dl,%dl
 4ab:	75 eb                	jne    498 <printf+0xec>
      state = 0;
 4ad:	be 00 00 00 00       	mov    $0x0,%esi
 4b2:	e9 21 ff ff ff       	jmp    3d8 <printf+0x2c>
        putc(fd, *ap);
 4b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ba:	0f be 17             	movsbl (%edi),%edx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 42 fe ff ff       	call   307 <putc>
        ap++;
 4c5:	83 c7 04             	add    $0x4,%edi
 4c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4cb:	be 00 00 00 00       	mov    $0x0,%esi
 4d0:	e9 03 ff ff ff       	jmp    3d8 <printf+0x2c>
        putc(fd, c);
 4d5:	89 fa                	mov    %edi,%edx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	e8 28 fe ff ff       	call   307 <putc>
      state = 0;
 4df:	be 00 00 00 00       	mov    $0x0,%esi
 4e4:	e9 ef fe ff ff       	jmp    3d8 <printf+0x2c>
        putc(fd, '%');
 4e9:	ba 25 00 00 00       	mov    $0x25,%edx
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	e8 11 fe ff ff       	call   307 <putc>
        putc(fd, c);
 4f6:	89 fa                	mov    %edi,%edx
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	e8 07 fe ff ff       	call   307 <putc>
      state = 0;
 500:	be 00 00 00 00       	mov    $0x0,%esi
 505:	e9 ce fe ff ff       	jmp    3d8 <printf+0x2c>
    }
  }
}
 50a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50d:	5b                   	pop    %ebx
 50e:	5e                   	pop    %esi
 50f:	5f                   	pop    %edi
 510:	5d                   	pop    %ebp
 511:	c3                   	ret    

00000512 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 512:	55                   	push   %ebp
 513:	89 e5                	mov    %esp,%ebp
 515:	57                   	push   %edi
 516:	56                   	push   %esi
 517:	53                   	push   %ebx
 518:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 51b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 51e:	a1 90 09 00 00       	mov    0x990,%eax
 523:	eb 02                	jmp    527 <free+0x15>
 525:	89 d0                	mov    %edx,%eax
 527:	39 c8                	cmp    %ecx,%eax
 529:	73 04                	jae    52f <free+0x1d>
 52b:	39 08                	cmp    %ecx,(%eax)
 52d:	77 12                	ja     541 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52f:	8b 10                	mov    (%eax),%edx
 531:	39 c2                	cmp    %eax,%edx
 533:	77 f0                	ja     525 <free+0x13>
 535:	39 c8                	cmp    %ecx,%eax
 537:	72 08                	jb     541 <free+0x2f>
 539:	39 ca                	cmp    %ecx,%edx
 53b:	77 04                	ja     541 <free+0x2f>
 53d:	89 d0                	mov    %edx,%eax
 53f:	eb e6                	jmp    527 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 541:	8b 73 fc             	mov    -0x4(%ebx),%esi
 544:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 547:	8b 10                	mov    (%eax),%edx
 549:	39 d7                	cmp    %edx,%edi
 54b:	74 19                	je     566 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 54d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 550:	8b 50 04             	mov    0x4(%eax),%edx
 553:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 556:	39 ce                	cmp    %ecx,%esi
 558:	74 1b                	je     575 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 55a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 55c:	a3 90 09 00 00       	mov    %eax,0x990
}
 561:	5b                   	pop    %ebx
 562:	5e                   	pop    %esi
 563:	5f                   	pop    %edi
 564:	5d                   	pop    %ebp
 565:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 566:	03 72 04             	add    0x4(%edx),%esi
 569:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 56c:	8b 10                	mov    (%eax),%edx
 56e:	8b 12                	mov    (%edx),%edx
 570:	89 53 f8             	mov    %edx,-0x8(%ebx)
 573:	eb db                	jmp    550 <free+0x3e>
    p->s.size += bp->s.size;
 575:	03 53 fc             	add    -0x4(%ebx),%edx
 578:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 57b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 57e:	89 10                	mov    %edx,(%eax)
 580:	eb da                	jmp    55c <free+0x4a>

00000582 <morecore>:

static Header*
morecore(uint nu)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	53                   	push   %ebx
 586:	83 ec 04             	sub    $0x4,%esp
 589:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 58b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 590:	77 05                	ja     597 <morecore+0x15>
    nu = 4096;
 592:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 597:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 59e:	83 ec 0c             	sub    $0xc,%esp
 5a1:	50                   	push   %eax
 5a2:	e8 c8 fc ff ff       	call   26f <sbrk>
  if(p == (char*)-1)
 5a7:	83 c4 10             	add    $0x10,%esp
 5aa:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ad:	74 1c                	je     5cb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5af:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b2:	83 c0 08             	add    $0x8,%eax
 5b5:	83 ec 0c             	sub    $0xc,%esp
 5b8:	50                   	push   %eax
 5b9:	e8 54 ff ff ff       	call   512 <free>
  return freep;
 5be:	a1 90 09 00 00       	mov    0x990,%eax
 5c3:	83 c4 10             	add    $0x10,%esp
}
 5c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c9:	c9                   	leave  
 5ca:	c3                   	ret    
    return 0;
 5cb:	b8 00 00 00 00       	mov    $0x0,%eax
 5d0:	eb f4                	jmp    5c6 <morecore+0x44>

000005d2 <malloc>:

void*
malloc(uint nbytes)
{
 5d2:	55                   	push   %ebp
 5d3:	89 e5                	mov    %esp,%ebp
 5d5:	53                   	push   %ebx
 5d6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	8d 58 07             	lea    0x7(%eax),%ebx
 5df:	c1 eb 03             	shr    $0x3,%ebx
 5e2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5e5:	8b 0d 90 09 00 00    	mov    0x990,%ecx
 5eb:	85 c9                	test   %ecx,%ecx
 5ed:	74 04                	je     5f3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ef:	8b 01                	mov    (%ecx),%eax
 5f1:	eb 4a                	jmp    63d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 5f3:	c7 05 90 09 00 00 94 	movl   $0x994,0x990
 5fa:	09 00 00 
 5fd:	c7 05 94 09 00 00 94 	movl   $0x994,0x994
 604:	09 00 00 
    base.s.size = 0;
 607:	c7 05 98 09 00 00 00 	movl   $0x0,0x998
 60e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 611:	b9 94 09 00 00       	mov    $0x994,%ecx
 616:	eb d7                	jmp    5ef <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 618:	74 19                	je     633 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 61a:	29 da                	sub    %ebx,%edx
 61c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 61f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 622:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 625:	89 0d 90 09 00 00    	mov    %ecx,0x990
      return (void*)(p + 1);
 62b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 62e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 631:	c9                   	leave  
 632:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 633:	8b 10                	mov    (%eax),%edx
 635:	89 11                	mov    %edx,(%ecx)
 637:	eb ec                	jmp    625 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 639:	89 c1                	mov    %eax,%ecx
 63b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	39 da                	cmp    %ebx,%edx
 642:	73 d4                	jae    618 <malloc+0x46>
    if(p == freep)
 644:	39 05 90 09 00 00    	cmp    %eax,0x990
 64a:	75 ed                	jne    639 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 64c:	89 d8                	mov    %ebx,%eax
 64e:	e8 2f ff ff ff       	call   582 <morecore>
 653:	85 c0                	test   %eax,%eax
 655:	75 e2                	jne    639 <malloc+0x67>
 657:	eb d5                	jmp    62e <malloc+0x5c>
