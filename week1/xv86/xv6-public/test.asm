
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) 
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
    init_counter();
  14:	e8 03 03 00 00       	call   31c <init_counter>
    int ret = fork();
  19:	e8 1e 02 00 00       	call   23c <fork>
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        Tescases:
            1. Print lock id if the lock has been initialized.
            2. define and call the function 'int holding_mylock(int id)' to check the status of
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held. 
    */
    printf(1,"init: %d\nacq: %d \nrel: %d \nhol: %d\n", init_mylock(),acquire_mylock(11), release_mylock(12),holding_mylock(13));
  21:	83 ec 0c             	sub    $0xc,%esp
  24:	6a 0d                	push   $0xd
  26:	e8 51 03 00 00       	call   37c <holding_mylock>
  2b:	89 c7                	mov    %eax,%edi
  2d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  34:	e8 3b 03 00 00       	call   374 <release_mylock>
  39:	89 c6                	mov    %eax,%esi
  3b:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  42:	e8 25 03 00 00       	call   36c <acquire_mylock>
  47:	89 c3                	mov    %eax,%ebx
  49:	e8 16 03 00 00       	call   364 <init_mylock>
  4e:	83 c4 08             	add    $0x8,%esp
  51:	57                   	push   %edi
  52:	56                   	push   %esi
  53:	53                   	push   %ebx
  54:	50                   	push   %eax
  55:	68 d8 06 00 00       	push   $0x6d8
  5a:	6a 01                	push   $0x1
  5c:	e8 c8 03 00 00       	call   429 <printf>
    for(int i=0; i<10000; i++){
  61:	83 c4 20             	add    $0x20,%esp
  64:	bb 00 00 00 00       	mov    $0x0,%ebx
  69:	eb 08                	jmp    73 <main+0x73>
        update_cnt();
  6b:	e8 b4 02 00 00       	call   324 <update_cnt>
    for(int i=0; i<10000; i++){
  70:	83 c3 01             	add    $0x1,%ebx
  73:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  79:	7e f0                	jle    6b <main+0x6b>
    }

    if(ret == 0)
  7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  7f:	75 05                	jne    86 <main+0x86>
        exit();
  81:	e8 be 01 00 00       	call   244 <exit>
    else{
        wait();
  86:	e8 c1 01 00 00       	call   24c <wait>
        printf(1, "%d\n", display_count());
  8b:	e8 9c 02 00 00       	call   32c <display_count>
  90:	83 ec 04             	sub    $0x4,%esp
  93:	50                   	push   %eax
  94:	68 fc 06 00 00       	push   $0x6fc
  99:	6a 01                	push   $0x1
  9b:	e8 89 03 00 00       	call   429 <printf>
        exit();
  a0:	e8 9f 01 00 00       	call   244 <exit>

000000a5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	56                   	push   %esi
  a9:	53                   	push   %ebx
  aa:	8b 75 08             	mov    0x8(%ebp),%esi
  ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	89 f0                	mov    %esi,%eax
  b2:	89 d1                	mov    %edx,%ecx
  b4:	83 c2 01             	add    $0x1,%edx
  b7:	89 c3                	mov    %eax,%ebx
  b9:	83 c0 01             	add    $0x1,%eax
  bc:	0f b6 09             	movzbl (%ecx),%ecx
  bf:	88 0b                	mov    %cl,(%ebx)
  c1:	84 c9                	test   %cl,%cl
  c3:	75 ed                	jne    b2 <strcpy+0xd>
    ;
  return os;
}
  c5:	89 f0                	mov    %esi,%eax
  c7:	5b                   	pop    %ebx
  c8:	5e                   	pop    %esi
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    

000000cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  d4:	eb 06                	jmp    dc <strcmp+0x11>
    p++, q++;
  d6:	83 c1 01             	add    $0x1,%ecx
  d9:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  dc:	0f b6 01             	movzbl (%ecx),%eax
  df:	84 c0                	test   %al,%al
  e1:	74 04                	je     e7 <strcmp+0x1c>
  e3:	3a 02                	cmp    (%edx),%al
  e5:	74 ef                	je     d6 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  e7:	0f b6 c0             	movzbl %al,%eax
  ea:	0f b6 12             	movzbl (%edx),%edx
  ed:	29 d0                	sub    %edx,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strlen>:

uint
strlen(const char *s)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f7:	b8 00 00 00 00       	mov    $0x0,%eax
  fc:	eb 03                	jmp    101 <strlen+0x10>
  fe:	83 c0 01             	add    $0x1,%eax
 101:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 105:	75 f7                	jne    fe <strlen+0xd>
    ;
  return n;
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <memset>:

void*
memset(void *dst, int c, uint n)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	57                   	push   %edi
 10d:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 110:	89 d7                	mov    %edx,%edi
 112:	8b 4d 10             	mov    0x10(%ebp),%ecx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	fc                   	cld    
 119:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 11b:	89 d0                	mov    %edx,%eax
 11d:	8b 7d fc             	mov    -0x4(%ebp),%edi
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <strchr>:

char*
strchr(const char *s, char c)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 12c:	eb 03                	jmp    131 <strchr+0xf>
 12e:	83 c0 01             	add    $0x1,%eax
 131:	0f b6 10             	movzbl (%eax),%edx
 134:	84 d2                	test   %dl,%dl
 136:	74 06                	je     13e <strchr+0x1c>
    if(*s == c)
 138:	38 ca                	cmp    %cl,%dl
 13a:	75 f2                	jne    12e <strchr+0xc>
 13c:	eb 05                	jmp    143 <strchr+0x21>
      return (char*)s;
  return 0;
 13e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <gets>:

char*
gets(char *buf, int max)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	57                   	push   %edi
 149:	56                   	push   %esi
 14a:	53                   	push   %ebx
 14b:	83 ec 1c             	sub    $0x1c,%esp
 14e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 151:	bb 00 00 00 00       	mov    $0x0,%ebx
 156:	89 de                	mov    %ebx,%esi
 158:	83 c3 01             	add    $0x1,%ebx
 15b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15e:	7d 2e                	jge    18e <gets+0x49>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	8d 45 e7             	lea    -0x19(%ebp),%eax
 168:	50                   	push   %eax
 169:	6a 00                	push   $0x0
 16b:	e8 ec 00 00 00       	call   25c <read>
    if(cc < 1)
 170:	83 c4 10             	add    $0x10,%esp
 173:	85 c0                	test   %eax,%eax
 175:	7e 17                	jle    18e <gets+0x49>
      break;
    buf[i++] = c;
 177:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 17b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 17e:	3c 0a                	cmp    $0xa,%al
 180:	0f 94 c2             	sete   %dl
 183:	3c 0d                	cmp    $0xd,%al
 185:	0f 94 c0             	sete   %al
 188:	08 c2                	or     %al,%dl
 18a:	74 ca                	je     156 <gets+0x11>
    buf[i++] = c;
 18c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 18e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 192:	89 f8                	mov    %edi,%eax
 194:	8d 65 f4             	lea    -0xc(%ebp),%esp
 197:	5b                   	pop    %ebx
 198:	5e                   	pop    %esi
 199:	5f                   	pop    %edi
 19a:	5d                   	pop    %ebp
 19b:	c3                   	ret    

0000019c <stat>:

int
stat(const char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	56                   	push   %esi
 1a0:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	6a 00                	push   $0x0
 1a6:	ff 75 08             	push   0x8(%ebp)
 1a9:	e8 d6 00 00 00       	call   284 <open>
  if(fd < 0)
 1ae:	83 c4 10             	add    $0x10,%esp
 1b1:	85 c0                	test   %eax,%eax
 1b3:	78 24                	js     1d9 <stat+0x3d>
 1b5:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	ff 75 0c             	push   0xc(%ebp)
 1bd:	50                   	push   %eax
 1be:	e8 d9 00 00 00       	call   29c <fstat>
 1c3:	89 c6                	mov    %eax,%esi
  close(fd);
 1c5:	89 1c 24             	mov    %ebx,(%esp)
 1c8:	e8 9f 00 00 00       	call   26c <close>
  return r;
 1cd:	83 c4 10             	add    $0x10,%esp
}
 1d0:	89 f0                	mov    %esi,%eax
 1d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d5:	5b                   	pop    %ebx
 1d6:	5e                   	pop    %esi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
    return -1;
 1d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1de:	eb f0                	jmp    1d0 <stat+0x34>

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1e7:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ec:	eb 10                	jmp    1fe <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1ee:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1f1:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1f4:	83 c1 01             	add    $0x1,%ecx
 1f7:	0f be c0             	movsbl %al,%eax
 1fa:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1fe:	0f b6 01             	movzbl (%ecx),%eax
 201:	8d 58 d0             	lea    -0x30(%eax),%ebx
 204:	80 fb 09             	cmp    $0x9,%bl
 207:	76 e5                	jbe    1ee <atoi+0xe>
  return n;
}
 209:	89 d0                	mov    %edx,%eax
 20b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
 215:	8b 75 08             	mov    0x8(%ebp),%esi
 218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 21b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 21e:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 220:	eb 0d                	jmp    22f <memmove+0x1f>
    *dst++ = *src++;
 222:	0f b6 01             	movzbl (%ecx),%eax
 225:	88 02                	mov    %al,(%edx)
 227:	8d 49 01             	lea    0x1(%ecx),%ecx
 22a:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 22d:	89 d8                	mov    %ebx,%eax
 22f:	8d 58 ff             	lea    -0x1(%eax),%ebx
 232:	85 c0                	test   %eax,%eax
 234:	7f ec                	jg     222 <memmove+0x12>
  return vdst;
}
 236:	89 f0                	mov    %esi,%eax
 238:	5b                   	pop    %ebx
 239:	5e                   	pop    %esi
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    

0000023c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23c:	b8 01 00 00 00       	mov    $0x1,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <exit>:
SYSCALL(exit)
 244:	b8 02 00 00 00       	mov    $0x2,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <wait>:
SYSCALL(wait)
 24c:	b8 03 00 00 00       	mov    $0x3,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <pipe>:
SYSCALL(pipe)
 254:	b8 04 00 00 00       	mov    $0x4,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <read>:
SYSCALL(read)
 25c:	b8 05 00 00 00       	mov    $0x5,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <write>:
SYSCALL(write)
 264:	b8 10 00 00 00       	mov    $0x10,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <close>:
SYSCALL(close)
 26c:	b8 15 00 00 00       	mov    $0x15,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <kill>:
SYSCALL(kill)
 274:	b8 06 00 00 00       	mov    $0x6,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <exec>:
SYSCALL(exec)
 27c:	b8 07 00 00 00       	mov    $0x7,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <open>:
SYSCALL(open)
 284:	b8 0f 00 00 00       	mov    $0xf,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <mknod>:
SYSCALL(mknod)
 28c:	b8 11 00 00 00       	mov    $0x11,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <unlink>:
SYSCALL(unlink)
 294:	b8 12 00 00 00       	mov    $0x12,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <fstat>:
SYSCALL(fstat)
 29c:	b8 08 00 00 00       	mov    $0x8,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <link>:
SYSCALL(link)
 2a4:	b8 13 00 00 00       	mov    $0x13,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <mkdir>:
SYSCALL(mkdir)
 2ac:	b8 14 00 00 00       	mov    $0x14,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <chdir>:
SYSCALL(chdir)
 2b4:	b8 09 00 00 00       	mov    $0x9,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <dup>:
SYSCALL(dup)
 2bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <getpid>:
SYSCALL(getpid)
 2c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <sbrk>:
SYSCALL(sbrk)
 2cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <sleep>:
SYSCALL(sleep)
 2d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <uptime>:
SYSCALL(uptime)
 2dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <hello>:
SYSCALL(hello)
 2e4:	b8 16 00 00 00       	mov    $0x16,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <helloYou>:
SYSCALL(helloYou)
 2ec:	b8 17 00 00 00       	mov    $0x17,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <getppid>:
SYSCALL(getppid)
 2f4:	b8 18 00 00 00       	mov    $0x18,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <get_siblings_info>:
SYSCALL(get_siblings_info)
 2fc:	b8 19 00 00 00       	mov    $0x19,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <signalProcess>:
SYSCALL(signalProcess)
 304:	b8 1a 00 00 00       	mov    $0x1a,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <numvp>:
SYSCALL(numvp)
 30c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <numpp>:
SYSCALL(numpp)
 314:	b8 1c 00 00 00       	mov    $0x1c,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <init_counter>:

SYSCALL(init_counter)
 31c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <update_cnt>:
SYSCALL(update_cnt)
 324:	b8 1e 00 00 00       	mov    $0x1e,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <display_count>:
SYSCALL(display_count)
 32c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <init_counter_1>:
SYSCALL(init_counter_1)
 334:	b8 20 00 00 00       	mov    $0x20,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <update_cnt_1>:
SYSCALL(update_cnt_1)
 33c:	b8 21 00 00 00       	mov    $0x21,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <display_count_1>:
SYSCALL(display_count_1)
 344:	b8 22 00 00 00       	mov    $0x22,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <init_counter_2>:
SYSCALL(init_counter_2)
 34c:	b8 23 00 00 00       	mov    $0x23,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <update_cnt_2>:
SYSCALL(update_cnt_2)
 354:	b8 24 00 00 00       	mov    $0x24,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <display_count_2>:
SYSCALL(display_count_2)
 35c:	b8 25 00 00 00       	mov    $0x25,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <init_mylock>:
SYSCALL(init_mylock)
 364:	b8 26 00 00 00       	mov    $0x26,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <acquire_mylock>:
SYSCALL(acquire_mylock)
 36c:	b8 27 00 00 00       	mov    $0x27,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <release_mylock>:
SYSCALL(release_mylock)
 374:	b8 28 00 00 00       	mov    $0x28,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <holding_mylock>:
 37c:	b8 29 00 00 00       	mov    $0x29,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	83 ec 1c             	sub    $0x1c,%esp
 38a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 38d:	6a 01                	push   $0x1
 38f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 392:	52                   	push   %edx
 393:	50                   	push   %eax
 394:	e8 cb fe ff ff       	call   264 <write>
}
 399:	83 c4 10             	add    $0x10,%esp
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	57                   	push   %edi
 3a2:	56                   	push   %esi
 3a3:	53                   	push   %ebx
 3a4:	83 ec 2c             	sub    $0x2c,%esp
 3a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3aa:	89 d0                	mov    %edx,%eax
 3ac:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b2:	0f 95 c1             	setne  %cl
 3b5:	c1 ea 1f             	shr    $0x1f,%edx
 3b8:	84 d1                	test   %dl,%cl
 3ba:	74 44                	je     400 <printint+0x62>
    neg = 1;
    x = -xx;
 3bc:	f7 d8                	neg    %eax
 3be:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3c0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3cc:	89 c8                	mov    %ecx,%eax
 3ce:	ba 00 00 00 00       	mov    $0x0,%edx
 3d3:	f7 f6                	div    %esi
 3d5:	89 df                	mov    %ebx,%edi
 3d7:	83 c3 01             	add    $0x1,%ebx
 3da:	0f b6 92 60 07 00 00 	movzbl 0x760(%edx),%edx
 3e1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3e5:	89 ca                	mov    %ecx,%edx
 3e7:	89 c1                	mov    %eax,%ecx
 3e9:	39 d6                	cmp    %edx,%esi
 3eb:	76 df                	jbe    3cc <printint+0x2e>
  if(neg)
 3ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3f1:	74 31                	je     424 <printint+0x86>
    buf[i++] = '-';
 3f3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3f8:	8d 5f 02             	lea    0x2(%edi),%ebx
 3fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3fe:	eb 17                	jmp    417 <printint+0x79>
    x = xx;
 400:	89 c1                	mov    %eax,%ecx
  neg = 0;
 402:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 409:	eb bc                	jmp    3c7 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 40b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 410:	89 f0                	mov    %esi,%eax
 412:	e8 6d ff ff ff       	call   384 <putc>
  while(--i >= 0)
 417:	83 eb 01             	sub    $0x1,%ebx
 41a:	79 ef                	jns    40b <printint+0x6d>
}
 41c:	83 c4 2c             	add    $0x2c,%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8b 75 d0             	mov    -0x30(%ebp),%esi
 427:	eb ee                	jmp    417 <printint+0x79>

00000429 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	57                   	push   %edi
 42d:	56                   	push   %esi
 42e:	53                   	push   %ebx
 42f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 432:	8d 45 10             	lea    0x10(%ebp),%eax
 435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 438:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 43d:	bb 00 00 00 00       	mov    $0x0,%ebx
 442:	eb 14                	jmp    458 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 444:	89 fa                	mov    %edi,%edx
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	e8 36 ff ff ff       	call   384 <putc>
 44e:	eb 05                	jmp    455 <printf+0x2c>
      }
    } else if(state == '%'){
 450:	83 fe 25             	cmp    $0x25,%esi
 453:	74 25                	je     47a <printf+0x51>
  for(i = 0; fmt[i]; i++){
 455:	83 c3 01             	add    $0x1,%ebx
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 45f:	84 c0                	test   %al,%al
 461:	0f 84 20 01 00 00    	je     587 <printf+0x15e>
    c = fmt[i] & 0xff;
 467:	0f be f8             	movsbl %al,%edi
 46a:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 46d:	85 f6                	test   %esi,%esi
 46f:	75 df                	jne    450 <printf+0x27>
      if(c == '%'){
 471:	83 f8 25             	cmp    $0x25,%eax
 474:	75 ce                	jne    444 <printf+0x1b>
        state = '%';
 476:	89 c6                	mov    %eax,%esi
 478:	eb db                	jmp    455 <printf+0x2c>
      if(c == 'd'){
 47a:	83 f8 25             	cmp    $0x25,%eax
 47d:	0f 84 cf 00 00 00    	je     552 <printf+0x129>
 483:	0f 8c dd 00 00 00    	jl     566 <printf+0x13d>
 489:	83 f8 78             	cmp    $0x78,%eax
 48c:	0f 8f d4 00 00 00    	jg     566 <printf+0x13d>
 492:	83 f8 63             	cmp    $0x63,%eax
 495:	0f 8c cb 00 00 00    	jl     566 <printf+0x13d>
 49b:	83 e8 63             	sub    $0x63,%eax
 49e:	83 f8 15             	cmp    $0x15,%eax
 4a1:	0f 87 bf 00 00 00    	ja     566 <printf+0x13d>
 4a7:	ff 24 85 08 07 00 00 	jmp    *0x708(,%eax,4)
        printint(fd, *ap, 10, 1);
 4ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b1:	8b 17                	mov    (%edi),%edx
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	6a 01                	push   $0x1
 4b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	e8 d9 fe ff ff       	call   39e <printint>
        ap++;
 4c5:	83 c7 04             	add    $0x4,%edi
 4c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4cb:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ce:	be 00 00 00 00       	mov    $0x0,%esi
 4d3:	eb 80                	jmp    455 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d8:	8b 17                	mov    (%edi),%edx
 4da:	83 ec 0c             	sub    $0xc,%esp
 4dd:	6a 00                	push   $0x0
 4df:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	e8 b2 fe ff ff       	call   39e <printint>
        ap++;
 4ec:	83 c7 04             	add    $0x4,%edi
 4ef:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f5:	be 00 00 00 00       	mov    $0x0,%esi
 4fa:	e9 56 ff ff ff       	jmp    455 <printf+0x2c>
        s = (char*)*ap;
 4ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 502:	8b 30                	mov    (%eax),%esi
        ap++;
 504:	83 c0 04             	add    $0x4,%eax
 507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 50a:	85 f6                	test   %esi,%esi
 50c:	75 15                	jne    523 <printf+0xfa>
          s = "(null)";
 50e:	be 00 07 00 00       	mov    $0x700,%esi
 513:	eb 0e                	jmp    523 <printf+0xfa>
          putc(fd, *s);
 515:	0f be d2             	movsbl %dl,%edx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	e8 64 fe ff ff       	call   384 <putc>
          s++;
 520:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 523:	0f b6 16             	movzbl (%esi),%edx
 526:	84 d2                	test   %dl,%dl
 528:	75 eb                	jne    515 <printf+0xec>
      state = 0;
 52a:	be 00 00 00 00       	mov    $0x0,%esi
 52f:	e9 21 ff ff ff       	jmp    455 <printf+0x2c>
        putc(fd, *ap);
 534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 537:	0f be 17             	movsbl (%edi),%edx
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	e8 42 fe ff ff       	call   384 <putc>
        ap++;
 542:	83 c7 04             	add    $0x4,%edi
 545:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 548:	be 00 00 00 00       	mov    $0x0,%esi
 54d:	e9 03 ff ff ff       	jmp    455 <printf+0x2c>
        putc(fd, c);
 552:	89 fa                	mov    %edi,%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	e8 28 fe ff ff       	call   384 <putc>
      state = 0;
 55c:	be 00 00 00 00       	mov    $0x0,%esi
 561:	e9 ef fe ff ff       	jmp    455 <printf+0x2c>
        putc(fd, '%');
 566:	ba 25 00 00 00       	mov    $0x25,%edx
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	e8 11 fe ff ff       	call   384 <putc>
        putc(fd, c);
 573:	89 fa                	mov    %edi,%edx
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	e8 07 fe ff ff       	call   384 <putc>
      state = 0;
 57d:	be 00 00 00 00       	mov    $0x0,%esi
 582:	e9 ce fe ff ff       	jmp    455 <printf+0x2c>
    }
  }
}
 587:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58a:	5b                   	pop    %ebx
 58b:	5e                   	pop    %esi
 58c:	5f                   	pop    %edi
 58d:	5d                   	pop    %ebp
 58e:	c3                   	ret    

0000058f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	57                   	push   %edi
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 598:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59b:	a1 0c 0a 00 00       	mov    0xa0c,%eax
 5a0:	eb 02                	jmp    5a4 <free+0x15>
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	39 c8                	cmp    %ecx,%eax
 5a6:	73 04                	jae    5ac <free+0x1d>
 5a8:	39 08                	cmp    %ecx,(%eax)
 5aa:	77 12                	ja     5be <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ac:	8b 10                	mov    (%eax),%edx
 5ae:	39 c2                	cmp    %eax,%edx
 5b0:	77 f0                	ja     5a2 <free+0x13>
 5b2:	39 c8                	cmp    %ecx,%eax
 5b4:	72 08                	jb     5be <free+0x2f>
 5b6:	39 ca                	cmp    %ecx,%edx
 5b8:	77 04                	ja     5be <free+0x2f>
 5ba:	89 d0                	mov    %edx,%eax
 5bc:	eb e6                	jmp    5a4 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5be:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	39 d7                	cmp    %edx,%edi
 5c8:	74 19                	je     5e3 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5cd:	8b 50 04             	mov    0x4(%eax),%edx
 5d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d3:	39 ce                	cmp    %ecx,%esi
 5d5:	74 1b                	je     5f2 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5d9:	a3 0c 0a 00 00       	mov    %eax,0xa0c
}
 5de:	5b                   	pop    %ebx
 5df:	5e                   	pop    %esi
 5e0:	5f                   	pop    %edi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5e3:	03 72 04             	add    0x4(%edx),%esi
 5e6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	8b 12                	mov    (%edx),%edx
 5ed:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5f0:	eb db                	jmp    5cd <free+0x3e>
    p->s.size += bp->s.size;
 5f2:	03 53 fc             	add    -0x4(%ebx),%edx
 5f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5f8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5fb:	89 10                	mov    %edx,(%eax)
 5fd:	eb da                	jmp    5d9 <free+0x4a>

000005ff <morecore>:

static Header*
morecore(uint nu)
{
 5ff:	55                   	push   %ebp
 600:	89 e5                	mov    %esp,%ebp
 602:	53                   	push   %ebx
 603:	83 ec 04             	sub    $0x4,%esp
 606:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 608:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 60d:	77 05                	ja     614 <morecore+0x15>
    nu = 4096;
 60f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 614:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 61b:	83 ec 0c             	sub    $0xc,%esp
 61e:	50                   	push   %eax
 61f:	e8 a8 fc ff ff       	call   2cc <sbrk>
  if(p == (char*)-1)
 624:	83 c4 10             	add    $0x10,%esp
 627:	83 f8 ff             	cmp    $0xffffffff,%eax
 62a:	74 1c                	je     648 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 62c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 62f:	83 c0 08             	add    $0x8,%eax
 632:	83 ec 0c             	sub    $0xc,%esp
 635:	50                   	push   %eax
 636:	e8 54 ff ff ff       	call   58f <free>
  return freep;
 63b:	a1 0c 0a 00 00       	mov    0xa0c,%eax
 640:	83 c4 10             	add    $0x10,%esp
}
 643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 646:	c9                   	leave  
 647:	c3                   	ret    
    return 0;
 648:	b8 00 00 00 00       	mov    $0x0,%eax
 64d:	eb f4                	jmp    643 <morecore+0x44>

0000064f <malloc>:

void*
malloc(uint nbytes)
{
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	53                   	push   %ebx
 653:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	8d 58 07             	lea    0x7(%eax),%ebx
 65c:	c1 eb 03             	shr    $0x3,%ebx
 65f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 662:	8b 0d 0c 0a 00 00    	mov    0xa0c,%ecx
 668:	85 c9                	test   %ecx,%ecx
 66a:	74 04                	je     670 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66c:	8b 01                	mov    (%ecx),%eax
 66e:	eb 4a                	jmp    6ba <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 670:	c7 05 0c 0a 00 00 10 	movl   $0xa10,0xa0c
 677:	0a 00 00 
 67a:	c7 05 10 0a 00 00 10 	movl   $0xa10,0xa10
 681:	0a 00 00 
    base.s.size = 0;
 684:	c7 05 14 0a 00 00 00 	movl   $0x0,0xa14
 68b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 68e:	b9 10 0a 00 00       	mov    $0xa10,%ecx
 693:	eb d7                	jmp    66c <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 695:	74 19                	je     6b0 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 697:	29 da                	sub    %ebx,%edx
 699:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 69c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 69f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a2:	89 0d 0c 0a 00 00    	mov    %ecx,0xa0c
      return (void*)(p + 1);
 6a8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ae:	c9                   	leave  
 6af:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	89 11                	mov    %edx,(%ecx)
 6b4:	eb ec                	jmp    6a2 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b6:	89 c1                	mov    %eax,%ecx
 6b8:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	39 da                	cmp    %ebx,%edx
 6bf:	73 d4                	jae    695 <malloc+0x46>
    if(p == freep)
 6c1:	39 05 0c 0a 00 00    	cmp    %eax,0xa0c
 6c7:	75 ed                	jne    6b6 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6c9:	89 d8                	mov    %ebx,%eax
 6cb:	e8 2f ff ff ff       	call   5ff <morecore>
 6d0:	85 c0                	test   %eax,%eax
 6d2:	75 e2                	jne    6b6 <malloc+0x67>
 6d4:	eb d5                	jmp    6ab <malloc+0x5c>
