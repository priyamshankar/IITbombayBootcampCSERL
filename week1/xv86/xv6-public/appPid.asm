
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
  23:	68 7c 06 00 00       	push   $0x67c
  28:	6a 01                	push   $0x1
  2a:	e8 9d 03 00 00       	call   3cc <printf>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	eb e2                	jmp    16 <main+0x16>
        printf(2, "usage: pname pid...\n");
  34:	83 ec 08             	sub    $0x8,%esp
  37:	68 98 06 00 00       	push   $0x698
  3c:	6a 02                	push   $0x2
  3e:	e8 89 03 00 00       	call   3cc <printf>
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
SYSCALL(display_count_2)
 2ff:	b8 25 00 00 00       	mov    $0x25,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <init_mylock>:
SYSCALL(init_mylock)
 307:	b8 26 00 00 00       	mov    $0x26,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <acquire_mylock>:
SYSCALL(acquire_mylock)
 30f:	b8 27 00 00 00       	mov    $0x27,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <release_mylock>:
SYSCALL(release_mylock)
 317:	b8 28 00 00 00       	mov    $0x28,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <holding_mylock>:
 31f:	b8 29 00 00 00       	mov    $0x29,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 1c             	sub    $0x1c,%esp
 32d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 330:	6a 01                	push   $0x1
 332:	8d 55 f4             	lea    -0xc(%ebp),%edx
 335:	52                   	push   %edx
 336:	50                   	push   %eax
 337:	e8 cb fe ff ff       	call   207 <write>
}
 33c:	83 c4 10             	add    $0x10,%esp
 33f:	c9                   	leave  
 340:	c3                   	ret    

00000341 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	57                   	push   %edi
 345:	56                   	push   %esi
 346:	53                   	push   %ebx
 347:	83 ec 2c             	sub    $0x2c,%esp
 34a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 34d:	89 d0                	mov    %edx,%eax
 34f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 355:	0f 95 c1             	setne  %cl
 358:	c1 ea 1f             	shr    $0x1f,%edx
 35b:	84 d1                	test   %dl,%cl
 35d:	74 44                	je     3a3 <printint+0x62>
    neg = 1;
    x = -xx;
 35f:	f7 d8                	neg    %eax
 361:	89 c1                	mov    %eax,%ecx
    neg = 1;
 363:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 36a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 36f:	89 c8                	mov    %ecx,%eax
 371:	ba 00 00 00 00       	mov    $0x0,%edx
 376:	f7 f6                	div    %esi
 378:	89 df                	mov    %ebx,%edi
 37a:	83 c3 01             	add    $0x1,%ebx
 37d:	0f b6 92 0c 07 00 00 	movzbl 0x70c(%edx),%edx
 384:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 388:	89 ca                	mov    %ecx,%edx
 38a:	89 c1                	mov    %eax,%ecx
 38c:	39 d6                	cmp    %edx,%esi
 38e:	76 df                	jbe    36f <printint+0x2e>
  if(neg)
 390:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 394:	74 31                	je     3c7 <printint+0x86>
    buf[i++] = '-';
 396:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 39b:	8d 5f 02             	lea    0x2(%edi),%ebx
 39e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3a1:	eb 17                	jmp    3ba <printint+0x79>
    x = xx;
 3a3:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3a5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3ac:	eb bc                	jmp    36a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ae:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3b3:	89 f0                	mov    %esi,%eax
 3b5:	e8 6d ff ff ff       	call   327 <putc>
  while(--i >= 0)
 3ba:	83 eb 01             	sub    $0x1,%ebx
 3bd:	79 ef                	jns    3ae <printint+0x6d>
}
 3bf:	83 c4 2c             	add    $0x2c,%esp
 3c2:	5b                   	pop    %ebx
 3c3:	5e                   	pop    %esi
 3c4:	5f                   	pop    %edi
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3ca:	eb ee                	jmp    3ba <printint+0x79>

000003cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	57                   	push   %edi
 3d0:	56                   	push   %esi
 3d1:	53                   	push   %ebx
 3d2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3d5:	8d 45 10             	lea    0x10(%ebp),%eax
 3d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3db:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3e0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3e5:	eb 14                	jmp    3fb <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3e7:	89 fa                	mov    %edi,%edx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	e8 36 ff ff ff       	call   327 <putc>
 3f1:	eb 05                	jmp    3f8 <printf+0x2c>
      }
    } else if(state == '%'){
 3f3:	83 fe 25             	cmp    $0x25,%esi
 3f6:	74 25                	je     41d <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3f8:	83 c3 01             	add    $0x1,%ebx
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 402:	84 c0                	test   %al,%al
 404:	0f 84 20 01 00 00    	je     52a <printf+0x15e>
    c = fmt[i] & 0xff;
 40a:	0f be f8             	movsbl %al,%edi
 40d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 410:	85 f6                	test   %esi,%esi
 412:	75 df                	jne    3f3 <printf+0x27>
      if(c == '%'){
 414:	83 f8 25             	cmp    $0x25,%eax
 417:	75 ce                	jne    3e7 <printf+0x1b>
        state = '%';
 419:	89 c6                	mov    %eax,%esi
 41b:	eb db                	jmp    3f8 <printf+0x2c>
      if(c == 'd'){
 41d:	83 f8 25             	cmp    $0x25,%eax
 420:	0f 84 cf 00 00 00    	je     4f5 <printf+0x129>
 426:	0f 8c dd 00 00 00    	jl     509 <printf+0x13d>
 42c:	83 f8 78             	cmp    $0x78,%eax
 42f:	0f 8f d4 00 00 00    	jg     509 <printf+0x13d>
 435:	83 f8 63             	cmp    $0x63,%eax
 438:	0f 8c cb 00 00 00    	jl     509 <printf+0x13d>
 43e:	83 e8 63             	sub    $0x63,%eax
 441:	83 f8 15             	cmp    $0x15,%eax
 444:	0f 87 bf 00 00 00    	ja     509 <printf+0x13d>
 44a:	ff 24 85 b4 06 00 00 	jmp    *0x6b4(,%eax,4)
        printint(fd, *ap, 10, 1);
 451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 454:	8b 17                	mov    (%edi),%edx
 456:	83 ec 0c             	sub    $0xc,%esp
 459:	6a 01                	push   $0x1
 45b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	e8 d9 fe ff ff       	call   341 <printint>
        ap++;
 468:	83 c7 04             	add    $0x4,%edi
 46b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 46e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 471:	be 00 00 00 00       	mov    $0x0,%esi
 476:	eb 80                	jmp    3f8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47b:	8b 17                	mov    (%edi),%edx
 47d:	83 ec 0c             	sub    $0xc,%esp
 480:	6a 00                	push   $0x0
 482:	b9 10 00 00 00       	mov    $0x10,%ecx
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	e8 b2 fe ff ff       	call   341 <printint>
        ap++;
 48f:	83 c7 04             	add    $0x4,%edi
 492:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 495:	83 c4 10             	add    $0x10,%esp
      state = 0;
 498:	be 00 00 00 00       	mov    $0x0,%esi
 49d:	e9 56 ff ff ff       	jmp    3f8 <printf+0x2c>
        s = (char*)*ap;
 4a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a5:	8b 30                	mov    (%eax),%esi
        ap++;
 4a7:	83 c0 04             	add    $0x4,%eax
 4aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4ad:	85 f6                	test   %esi,%esi
 4af:	75 15                	jne    4c6 <printf+0xfa>
          s = "(null)";
 4b1:	be ad 06 00 00       	mov    $0x6ad,%esi
 4b6:	eb 0e                	jmp    4c6 <printf+0xfa>
          putc(fd, *s);
 4b8:	0f be d2             	movsbl %dl,%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	e8 64 fe ff ff       	call   327 <putc>
          s++;
 4c3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4c6:	0f b6 16             	movzbl (%esi),%edx
 4c9:	84 d2                	test   %dl,%dl
 4cb:	75 eb                	jne    4b8 <printf+0xec>
      state = 0;
 4cd:	be 00 00 00 00       	mov    $0x0,%esi
 4d2:	e9 21 ff ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, *ap);
 4d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4da:	0f be 17             	movsbl (%edi),%edx
 4dd:	8b 45 08             	mov    0x8(%ebp),%eax
 4e0:	e8 42 fe ff ff       	call   327 <putc>
        ap++;
 4e5:	83 c7 04             	add    $0x4,%edi
 4e8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4eb:	be 00 00 00 00       	mov    $0x0,%esi
 4f0:	e9 03 ff ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, c);
 4f5:	89 fa                	mov    %edi,%edx
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	e8 28 fe ff ff       	call   327 <putc>
      state = 0;
 4ff:	be 00 00 00 00       	mov    $0x0,%esi
 504:	e9 ef fe ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, '%');
 509:	ba 25 00 00 00       	mov    $0x25,%edx
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	e8 11 fe ff ff       	call   327 <putc>
        putc(fd, c);
 516:	89 fa                	mov    %edi,%edx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	e8 07 fe ff ff       	call   327 <putc>
      state = 0;
 520:	be 00 00 00 00       	mov    $0x0,%esi
 525:	e9 ce fe ff ff       	jmp    3f8 <printf+0x2c>
    }
  }
}
 52a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52d:	5b                   	pop    %ebx
 52e:	5e                   	pop    %esi
 52f:	5f                   	pop    %edi
 530:	5d                   	pop    %ebp
 531:	c3                   	ret    

00000532 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 532:	55                   	push   %ebp
 533:	89 e5                	mov    %esp,%ebp
 535:	57                   	push   %edi
 536:	56                   	push   %esi
 537:	53                   	push   %ebx
 538:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 53b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 53e:	a1 b0 09 00 00       	mov    0x9b0,%eax
 543:	eb 02                	jmp    547 <free+0x15>
 545:	89 d0                	mov    %edx,%eax
 547:	39 c8                	cmp    %ecx,%eax
 549:	73 04                	jae    54f <free+0x1d>
 54b:	39 08                	cmp    %ecx,(%eax)
 54d:	77 12                	ja     561 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 54f:	8b 10                	mov    (%eax),%edx
 551:	39 c2                	cmp    %eax,%edx
 553:	77 f0                	ja     545 <free+0x13>
 555:	39 c8                	cmp    %ecx,%eax
 557:	72 08                	jb     561 <free+0x2f>
 559:	39 ca                	cmp    %ecx,%edx
 55b:	77 04                	ja     561 <free+0x2f>
 55d:	89 d0                	mov    %edx,%eax
 55f:	eb e6                	jmp    547 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 561:	8b 73 fc             	mov    -0x4(%ebx),%esi
 564:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 567:	8b 10                	mov    (%eax),%edx
 569:	39 d7                	cmp    %edx,%edi
 56b:	74 19                	je     586 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 56d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 570:	8b 50 04             	mov    0x4(%eax),%edx
 573:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 576:	39 ce                	cmp    %ecx,%esi
 578:	74 1b                	je     595 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 57a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 57c:	a3 b0 09 00 00       	mov    %eax,0x9b0
}
 581:	5b                   	pop    %ebx
 582:	5e                   	pop    %esi
 583:	5f                   	pop    %edi
 584:	5d                   	pop    %ebp
 585:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 586:	03 72 04             	add    0x4(%edx),%esi
 589:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 58c:	8b 10                	mov    (%eax),%edx
 58e:	8b 12                	mov    (%edx),%edx
 590:	89 53 f8             	mov    %edx,-0x8(%ebx)
 593:	eb db                	jmp    570 <free+0x3e>
    p->s.size += bp->s.size;
 595:	03 53 fc             	add    -0x4(%ebx),%edx
 598:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 59b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 59e:	89 10                	mov    %edx,(%eax)
 5a0:	eb da                	jmp    57c <free+0x4a>

000005a2 <morecore>:

static Header*
morecore(uint nu)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	53                   	push   %ebx
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5ab:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5b0:	77 05                	ja     5b7 <morecore+0x15>
    nu = 4096;
 5b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5b7:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5be:	83 ec 0c             	sub    $0xc,%esp
 5c1:	50                   	push   %eax
 5c2:	e8 a8 fc ff ff       	call   26f <sbrk>
  if(p == (char*)-1)
 5c7:	83 c4 10             	add    $0x10,%esp
 5ca:	83 f8 ff             	cmp    $0xffffffff,%eax
 5cd:	74 1c                	je     5eb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5cf:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5d2:	83 c0 08             	add    $0x8,%eax
 5d5:	83 ec 0c             	sub    $0xc,%esp
 5d8:	50                   	push   %eax
 5d9:	e8 54 ff ff ff       	call   532 <free>
  return freep;
 5de:	a1 b0 09 00 00       	mov    0x9b0,%eax
 5e3:	83 c4 10             	add    $0x10,%esp
}
 5e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e9:	c9                   	leave  
 5ea:	c3                   	ret    
    return 0;
 5eb:	b8 00 00 00 00       	mov    $0x0,%eax
 5f0:	eb f4                	jmp    5e6 <morecore+0x44>

000005f2 <malloc>:

void*
malloc(uint nbytes)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	53                   	push   %ebx
 5f6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	8d 58 07             	lea    0x7(%eax),%ebx
 5ff:	c1 eb 03             	shr    $0x3,%ebx
 602:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 605:	8b 0d b0 09 00 00    	mov    0x9b0,%ecx
 60b:	85 c9                	test   %ecx,%ecx
 60d:	74 04                	je     613 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60f:	8b 01                	mov    (%ecx),%eax
 611:	eb 4a                	jmp    65d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 613:	c7 05 b0 09 00 00 b4 	movl   $0x9b4,0x9b0
 61a:	09 00 00 
 61d:	c7 05 b4 09 00 00 b4 	movl   $0x9b4,0x9b4
 624:	09 00 00 
    base.s.size = 0;
 627:	c7 05 b8 09 00 00 00 	movl   $0x0,0x9b8
 62e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 631:	b9 b4 09 00 00       	mov    $0x9b4,%ecx
 636:	eb d7                	jmp    60f <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 638:	74 19                	je     653 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 63a:	29 da                	sub    %ebx,%edx
 63c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 63f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 642:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 645:	89 0d b0 09 00 00    	mov    %ecx,0x9b0
      return (void*)(p + 1);
 64b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 64e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 651:	c9                   	leave  
 652:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 653:	8b 10                	mov    (%eax),%edx
 655:	89 11                	mov    %edx,(%ecx)
 657:	eb ec                	jmp    645 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 659:	89 c1                	mov    %eax,%ecx
 65b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	39 da                	cmp    %ebx,%edx
 662:	73 d4                	jae    638 <malloc+0x46>
    if(p == freep)
 664:	39 05 b0 09 00 00    	cmp    %eax,0x9b0
 66a:	75 ed                	jne    659 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 66c:	89 d8                	mov    %ebx,%eax
 66e:	e8 2f ff ff ff       	call   5a2 <morecore>
 673:	85 c0                	test   %eax,%eax
 675:	75 e2                	jne    659 <malloc+0x67>
 677:	eb d5                	jmp    64e <malloc+0x5c>
