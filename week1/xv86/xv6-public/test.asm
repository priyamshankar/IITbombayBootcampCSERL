
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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
    init_counter();
  13:	e8 ee 02 00 00       	call   306 <init_counter>
    int ret = fork();
  18:	e8 09 02 00 00       	call   226 <fork>
  1d:	89 c6                	mov    %eax,%esi
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held. 
    */
    // printf(1,"init: %d\nacq: %d \nrel: %d \nhol: %d\n", init_mylock(),acquire_mylock(11), release_mylock(12),holding_mylock(13));

    // printf(1,"%d\n",init_mylock());
    init_mylock();
  1f:	e8 2a 03 00 00       	call   34e <init_mylock>
    printf(1,"%d\n",acquire_mylock(0));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	6a 00                	push   $0x0
  29:	e8 28 03 00 00       	call   356 <acquire_mylock>
  2e:	83 c4 0c             	add    $0xc,%esp
  31:	50                   	push   %eax
  32:	68 c0 06 00 00       	push   $0x6c0
  37:	6a 01                	push   $0x1
  39:	e8 d5 03 00 00       	call   413 <printf>

    printf(1,"hello spinlocks");
  3e:	83 c4 08             	add    $0x8,%esp
  41:	68 c4 06 00 00       	push   $0x6c4
  46:	6a 01                	push   $0x1
  48:	e8 c6 03 00 00       	call   413 <printf>
    for(int i=0; i<10000; i++){
  4d:	83 c4 10             	add    $0x10,%esp
  50:	bb 00 00 00 00       	mov    $0x0,%ebx
  55:	eb 08                	jmp    5f <main+0x5f>
        update_cnt();
  57:	e8 b2 02 00 00       	call   30e <update_cnt>
    for(int i=0; i<10000; i++){
  5c:	83 c3 01             	add    $0x1,%ebx
  5f:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  65:	7e f0                	jle    57 <main+0x57>
    }

    if(ret == 0)
  67:	85 f6                	test   %esi,%esi
  69:	75 05                	jne    70 <main+0x70>
        exit();
  6b:	e8 be 01 00 00       	call   22e <exit>
    else{
        wait();
  70:	e8 c1 01 00 00       	call   236 <wait>
        printf(1, "%d\n", display_count());
  75:	e8 9c 02 00 00       	call   316 <display_count>
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	50                   	push   %eax
  7e:	68 c0 06 00 00       	push   $0x6c0
  83:	6a 01                	push   $0x1
  85:	e8 89 03 00 00       	call   413 <printf>
        exit();
  8a:	e8 9f 01 00 00       	call   22e <exit>

0000008f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	56                   	push   %esi
  93:	53                   	push   %ebx
  94:	8b 75 08             	mov    0x8(%ebp),%esi
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	89 f0                	mov    %esi,%eax
  9c:	89 d1                	mov    %edx,%ecx
  9e:	83 c2 01             	add    $0x1,%edx
  a1:	89 c3                	mov    %eax,%ebx
  a3:	83 c0 01             	add    $0x1,%eax
  a6:	0f b6 09             	movzbl (%ecx),%ecx
  a9:	88 0b                	mov    %cl,(%ebx)
  ab:	84 c9                	test   %cl,%cl
  ad:	75 ed                	jne    9c <strcpy+0xd>
    ;
  return os;
}
  af:	89 f0                	mov    %esi,%eax
  b1:	5b                   	pop    %ebx
  b2:	5e                   	pop    %esi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  be:	eb 06                	jmp    c6 <strcmp+0x11>
    p++, q++;
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  c6:	0f b6 01             	movzbl (%ecx),%eax
  c9:	84 c0                	test   %al,%al
  cb:	74 04                	je     d1 <strcmp+0x1c>
  cd:	3a 02                	cmp    (%edx),%al
  cf:	74 ef                	je     c0 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  d1:	0f b6 c0             	movzbl %al,%eax
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	29 d0                	sub    %edx,%eax
}
  d9:	5d                   	pop    %ebp
  da:	c3                   	ret    

000000db <strlen>:

uint
strlen(const char *s)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e1:	b8 00 00 00 00       	mov    $0x0,%eax
  e6:	eb 03                	jmp    eb <strlen+0x10>
  e8:	83 c0 01             	add    $0x1,%eax
  eb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  ef:	75 f7                	jne    e8 <strlen+0xd>
    ;
  return n;
}
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    

000000f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  f6:	57                   	push   %edi
  f7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  fa:	89 d7                	mov    %edx,%edi
  fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 102:	fc                   	cld    
 103:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 105:	89 d0                	mov    %edx,%eax
 107:	8b 7d fc             	mov    -0x4(%ebp),%edi
 10a:	c9                   	leave  
 10b:	c3                   	ret    

0000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 116:	eb 03                	jmp    11b <strchr+0xf>
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 10             	movzbl (%eax),%edx
 11e:	84 d2                	test   %dl,%dl
 120:	74 06                	je     128 <strchr+0x1c>
    if(*s == c)
 122:	38 ca                	cmp    %cl,%dl
 124:	75 f2                	jne    118 <strchr+0xc>
 126:	eb 05                	jmp    12d <strchr+0x21>
      return (char*)s;
  return 0;
 128:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    

0000012f <gets>:

char*
gets(char *buf, int max)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	57                   	push   %edi
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	83 ec 1c             	sub    $0x1c,%esp
 138:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	bb 00 00 00 00       	mov    $0x0,%ebx
 140:	89 de                	mov    %ebx,%esi
 142:	83 c3 01             	add    $0x1,%ebx
 145:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 148:	7d 2e                	jge    178 <gets+0x49>
    cc = read(0, &c, 1);
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	6a 01                	push   $0x1
 14f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 152:	50                   	push   %eax
 153:	6a 00                	push   $0x0
 155:	e8 ec 00 00 00       	call   246 <read>
    if(cc < 1)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	85 c0                	test   %eax,%eax
 15f:	7e 17                	jle    178 <gets+0x49>
      break;
    buf[i++] = c;
 161:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 165:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 168:	3c 0a                	cmp    $0xa,%al
 16a:	0f 94 c2             	sete   %dl
 16d:	3c 0d                	cmp    $0xd,%al
 16f:	0f 94 c0             	sete   %al
 172:	08 c2                	or     %al,%dl
 174:	74 ca                	je     140 <gets+0x11>
    buf[i++] = c;
 176:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 178:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 17c:	89 f8                	mov    %edi,%eax
 17e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 181:	5b                   	pop    %ebx
 182:	5e                   	pop    %esi
 183:	5f                   	pop    %edi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	56                   	push   %esi
 18a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	6a 00                	push   $0x0
 190:	ff 75 08             	push   0x8(%ebp)
 193:	e8 d6 00 00 00       	call   26e <open>
  if(fd < 0)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	78 24                	js     1c3 <stat+0x3d>
 19f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	ff 75 0c             	push   0xc(%ebp)
 1a7:	50                   	push   %eax
 1a8:	e8 d9 00 00 00       	call   286 <fstat>
 1ad:	89 c6                	mov    %eax,%esi
  close(fd);
 1af:	89 1c 24             	mov    %ebx,(%esp)
 1b2:	e8 9f 00 00 00       	call   256 <close>
  return r;
 1b7:	83 c4 10             	add    $0x10,%esp
}
 1ba:	89 f0                	mov    %esi,%eax
 1bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
    return -1;
 1c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c8:	eb f0                	jmp    1ba <stat+0x34>

000001ca <atoi>:

int
atoi(const char *s)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	53                   	push   %ebx
 1ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1d1:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d6:	eb 10                	jmp    1e8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1d8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1db:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1de:	83 c1 01             	add    $0x1,%ecx
 1e1:	0f be c0             	movsbl %al,%eax
 1e4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1e8:	0f b6 01             	movzbl (%ecx),%eax
 1eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ee:	80 fb 09             	cmp    $0x9,%bl
 1f1:	76 e5                	jbe    1d8 <atoi+0xe>
  return n;
}
 1f3:	89 d0                	mov    %edx,%eax
 1f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	56                   	push   %esi
 1fe:	53                   	push   %ebx
 1ff:	8b 75 08             	mov    0x8(%ebp),%esi
 202:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 205:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 208:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 20a:	eb 0d                	jmp    219 <memmove+0x1f>
    *dst++ = *src++;
 20c:	0f b6 01             	movzbl (%ecx),%eax
 20f:	88 02                	mov    %al,(%edx)
 211:	8d 49 01             	lea    0x1(%ecx),%ecx
 214:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 217:	89 d8                	mov    %ebx,%eax
 219:	8d 58 ff             	lea    -0x1(%eax),%ebx
 21c:	85 c0                	test   %eax,%eax
 21e:	7f ec                	jg     20c <memmove+0x12>
  return vdst;
}
 220:	89 f0                	mov    %esi,%eax
 222:	5b                   	pop    %ebx
 223:	5e                   	pop    %esi
 224:	5d                   	pop    %ebp
 225:	c3                   	ret    

00000226 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 226:	b8 01 00 00 00       	mov    $0x1,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <exit>:
SYSCALL(exit)
 22e:	b8 02 00 00 00       	mov    $0x2,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <wait>:
SYSCALL(wait)
 236:	b8 03 00 00 00       	mov    $0x3,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <pipe>:
SYSCALL(pipe)
 23e:	b8 04 00 00 00       	mov    $0x4,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <read>:
SYSCALL(read)
 246:	b8 05 00 00 00       	mov    $0x5,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <write>:
SYSCALL(write)
 24e:	b8 10 00 00 00       	mov    $0x10,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <close>:
SYSCALL(close)
 256:	b8 15 00 00 00       	mov    $0x15,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <kill>:
SYSCALL(kill)
 25e:	b8 06 00 00 00       	mov    $0x6,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <exec>:
SYSCALL(exec)
 266:	b8 07 00 00 00       	mov    $0x7,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <open>:
SYSCALL(open)
 26e:	b8 0f 00 00 00       	mov    $0xf,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <mknod>:
SYSCALL(mknod)
 276:	b8 11 00 00 00       	mov    $0x11,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <unlink>:
SYSCALL(unlink)
 27e:	b8 12 00 00 00       	mov    $0x12,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <fstat>:
SYSCALL(fstat)
 286:	b8 08 00 00 00       	mov    $0x8,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <link>:
SYSCALL(link)
 28e:	b8 13 00 00 00       	mov    $0x13,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <mkdir>:
SYSCALL(mkdir)
 296:	b8 14 00 00 00       	mov    $0x14,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <chdir>:
SYSCALL(chdir)
 29e:	b8 09 00 00 00       	mov    $0x9,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <dup>:
SYSCALL(dup)
 2a6:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <getpid>:
SYSCALL(getpid)
 2ae:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <sbrk>:
SYSCALL(sbrk)
 2b6:	b8 0c 00 00 00       	mov    $0xc,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <sleep>:
SYSCALL(sleep)
 2be:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <uptime>:
SYSCALL(uptime)
 2c6:	b8 0e 00 00 00       	mov    $0xe,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <hello>:
SYSCALL(hello)
 2ce:	b8 16 00 00 00       	mov    $0x16,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <helloYou>:
SYSCALL(helloYou)
 2d6:	b8 17 00 00 00       	mov    $0x17,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <getppid>:
SYSCALL(getppid)
 2de:	b8 18 00 00 00       	mov    $0x18,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2e6:	b8 19 00 00 00       	mov    $0x19,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <signalProcess>:
SYSCALL(signalProcess)
 2ee:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <numvp>:
SYSCALL(numvp)
 2f6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <numpp>:
SYSCALL(numpp)
 2fe:	b8 1c 00 00 00       	mov    $0x1c,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <init_counter>:

SYSCALL(init_counter)
 306:	b8 1d 00 00 00       	mov    $0x1d,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <update_cnt>:
SYSCALL(update_cnt)
 30e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <display_count>:
SYSCALL(display_count)
 316:	b8 1f 00 00 00       	mov    $0x1f,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <init_counter_1>:
SYSCALL(init_counter_1)
 31e:	b8 20 00 00 00       	mov    $0x20,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <update_cnt_1>:
SYSCALL(update_cnt_1)
 326:	b8 21 00 00 00       	mov    $0x21,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <display_count_1>:
SYSCALL(display_count_1)
 32e:	b8 22 00 00 00       	mov    $0x22,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <init_counter_2>:
SYSCALL(init_counter_2)
 336:	b8 23 00 00 00       	mov    $0x23,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <update_cnt_2>:
SYSCALL(update_cnt_2)
 33e:	b8 24 00 00 00       	mov    $0x24,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <display_count_2>:
SYSCALL(display_count_2)
 346:	b8 25 00 00 00       	mov    $0x25,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <init_mylock>:
SYSCALL(init_mylock)
 34e:	b8 26 00 00 00       	mov    $0x26,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <acquire_mylock>:
SYSCALL(acquire_mylock)
 356:	b8 27 00 00 00       	mov    $0x27,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <release_mylock>:
SYSCALL(release_mylock)
 35e:	b8 28 00 00 00       	mov    $0x28,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <holding_mylock>:
 366:	b8 29 00 00 00       	mov    $0x29,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 1c             	sub    $0x1c,%esp
 374:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 377:	6a 01                	push   $0x1
 379:	8d 55 f4             	lea    -0xc(%ebp),%edx
 37c:	52                   	push   %edx
 37d:	50                   	push   %eax
 37e:	e8 cb fe ff ff       	call   24e <write>
}
 383:	83 c4 10             	add    $0x10,%esp
 386:	c9                   	leave  
 387:	c3                   	ret    

00000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	57                   	push   %edi
 38c:	56                   	push   %esi
 38d:	53                   	push   %ebx
 38e:	83 ec 2c             	sub    $0x2c,%esp
 391:	89 45 d0             	mov    %eax,-0x30(%ebp)
 394:	89 d0                	mov    %edx,%eax
 396:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 39c:	0f 95 c1             	setne  %cl
 39f:	c1 ea 1f             	shr    $0x1f,%edx
 3a2:	84 d1                	test   %dl,%cl
 3a4:	74 44                	je     3ea <printint+0x62>
    neg = 1;
    x = -xx;
 3a6:	f7 d8                	neg    %eax
 3a8:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3aa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3b6:	89 c8                	mov    %ecx,%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 f6                	div    %esi
 3bf:	89 df                	mov    %ebx,%edi
 3c1:	83 c3 01             	add    $0x1,%ebx
 3c4:	0f b6 92 34 07 00 00 	movzbl 0x734(%edx),%edx
 3cb:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3cf:	89 ca                	mov    %ecx,%edx
 3d1:	89 c1                	mov    %eax,%ecx
 3d3:	39 d6                	cmp    %edx,%esi
 3d5:	76 df                	jbe    3b6 <printint+0x2e>
  if(neg)
 3d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3db:	74 31                	je     40e <printint+0x86>
    buf[i++] = '-';
 3dd:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3e2:	8d 5f 02             	lea    0x2(%edi),%ebx
 3e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e8:	eb 17                	jmp    401 <printint+0x79>
    x = xx;
 3ea:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3f3:	eb bc                	jmp    3b1 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3f5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3fa:	89 f0                	mov    %esi,%eax
 3fc:	e8 6d ff ff ff       	call   36e <putc>
  while(--i >= 0)
 401:	83 eb 01             	sub    $0x1,%ebx
 404:	79 ef                	jns    3f5 <printint+0x6d>
}
 406:	83 c4 2c             	add    $0x2c,%esp
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5f                   	pop    %edi
 40c:	5d                   	pop    %ebp
 40d:	c3                   	ret    
 40e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 411:	eb ee                	jmp    401 <printint+0x79>

00000413 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	57                   	push   %edi
 417:	56                   	push   %esi
 418:	53                   	push   %ebx
 419:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 41c:	8d 45 10             	lea    0x10(%ebp),%eax
 41f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 422:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 427:	bb 00 00 00 00       	mov    $0x0,%ebx
 42c:	eb 14                	jmp    442 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 42e:	89 fa                	mov    %edi,%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	e8 36 ff ff ff       	call   36e <putc>
 438:	eb 05                	jmp    43f <printf+0x2c>
      }
    } else if(state == '%'){
 43a:	83 fe 25             	cmp    $0x25,%esi
 43d:	74 25                	je     464 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 43f:	83 c3 01             	add    $0x1,%ebx
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 449:	84 c0                	test   %al,%al
 44b:	0f 84 20 01 00 00    	je     571 <printf+0x15e>
    c = fmt[i] & 0xff;
 451:	0f be f8             	movsbl %al,%edi
 454:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 457:	85 f6                	test   %esi,%esi
 459:	75 df                	jne    43a <printf+0x27>
      if(c == '%'){
 45b:	83 f8 25             	cmp    $0x25,%eax
 45e:	75 ce                	jne    42e <printf+0x1b>
        state = '%';
 460:	89 c6                	mov    %eax,%esi
 462:	eb db                	jmp    43f <printf+0x2c>
      if(c == 'd'){
 464:	83 f8 25             	cmp    $0x25,%eax
 467:	0f 84 cf 00 00 00    	je     53c <printf+0x129>
 46d:	0f 8c dd 00 00 00    	jl     550 <printf+0x13d>
 473:	83 f8 78             	cmp    $0x78,%eax
 476:	0f 8f d4 00 00 00    	jg     550 <printf+0x13d>
 47c:	83 f8 63             	cmp    $0x63,%eax
 47f:	0f 8c cb 00 00 00    	jl     550 <printf+0x13d>
 485:	83 e8 63             	sub    $0x63,%eax
 488:	83 f8 15             	cmp    $0x15,%eax
 48b:	0f 87 bf 00 00 00    	ja     550 <printf+0x13d>
 491:	ff 24 85 dc 06 00 00 	jmp    *0x6dc(,%eax,4)
        printint(fd, *ap, 10, 1);
 498:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49b:	8b 17                	mov    (%edi),%edx
 49d:	83 ec 0c             	sub    $0xc,%esp
 4a0:	6a 01                	push   $0x1
 4a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	e8 d9 fe ff ff       	call   388 <printint>
        ap++;
 4af:	83 c7 04             	add    $0x4,%edi
 4b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b5:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b8:	be 00 00 00 00       	mov    $0x0,%esi
 4bd:	eb 80                	jmp    43f <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c2:	8b 17                	mov    (%edi),%edx
 4c4:	83 ec 0c             	sub    $0xc,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	e8 b2 fe ff ff       	call   388 <printint>
        ap++;
 4d6:	83 c7 04             	add    $0x4,%edi
 4d9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4df:	be 00 00 00 00       	mov    $0x0,%esi
 4e4:	e9 56 ff ff ff       	jmp    43f <printf+0x2c>
        s = (char*)*ap;
 4e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ec:	8b 30                	mov    (%eax),%esi
        ap++;
 4ee:	83 c0 04             	add    $0x4,%eax
 4f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4f4:	85 f6                	test   %esi,%esi
 4f6:	75 15                	jne    50d <printf+0xfa>
          s = "(null)";
 4f8:	be d4 06 00 00       	mov    $0x6d4,%esi
 4fd:	eb 0e                	jmp    50d <printf+0xfa>
          putc(fd, *s);
 4ff:	0f be d2             	movsbl %dl,%edx
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	e8 64 fe ff ff       	call   36e <putc>
          s++;
 50a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 50d:	0f b6 16             	movzbl (%esi),%edx
 510:	84 d2                	test   %dl,%dl
 512:	75 eb                	jne    4ff <printf+0xec>
      state = 0;
 514:	be 00 00 00 00       	mov    $0x0,%esi
 519:	e9 21 ff ff ff       	jmp    43f <printf+0x2c>
        putc(fd, *ap);
 51e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 521:	0f be 17             	movsbl (%edi),%edx
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	e8 42 fe ff ff       	call   36e <putc>
        ap++;
 52c:	83 c7 04             	add    $0x4,%edi
 52f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 532:	be 00 00 00 00       	mov    $0x0,%esi
 537:	e9 03 ff ff ff       	jmp    43f <printf+0x2c>
        putc(fd, c);
 53c:	89 fa                	mov    %edi,%edx
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	e8 28 fe ff ff       	call   36e <putc>
      state = 0;
 546:	be 00 00 00 00       	mov    $0x0,%esi
 54b:	e9 ef fe ff ff       	jmp    43f <printf+0x2c>
        putc(fd, '%');
 550:	ba 25 00 00 00       	mov    $0x25,%edx
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	e8 11 fe ff ff       	call   36e <putc>
        putc(fd, c);
 55d:	89 fa                	mov    %edi,%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	e8 07 fe ff ff       	call   36e <putc>
      state = 0;
 567:	be 00 00 00 00       	mov    $0x0,%esi
 56c:	e9 ce fe ff ff       	jmp    43f <printf+0x2c>
    }
  }
}
 571:	8d 65 f4             	lea    -0xc(%ebp),%esp
 574:	5b                   	pop    %ebx
 575:	5e                   	pop    %esi
 576:	5f                   	pop    %edi
 577:	5d                   	pop    %ebp
 578:	c3                   	ret    

00000579 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	57                   	push   %edi
 57d:	56                   	push   %esi
 57e:	53                   	push   %ebx
 57f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 582:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 585:	a1 dc 09 00 00       	mov    0x9dc,%eax
 58a:	eb 02                	jmp    58e <free+0x15>
 58c:	89 d0                	mov    %edx,%eax
 58e:	39 c8                	cmp    %ecx,%eax
 590:	73 04                	jae    596 <free+0x1d>
 592:	39 08                	cmp    %ecx,(%eax)
 594:	77 12                	ja     5a8 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 596:	8b 10                	mov    (%eax),%edx
 598:	39 c2                	cmp    %eax,%edx
 59a:	77 f0                	ja     58c <free+0x13>
 59c:	39 c8                	cmp    %ecx,%eax
 59e:	72 08                	jb     5a8 <free+0x2f>
 5a0:	39 ca                	cmp    %ecx,%edx
 5a2:	77 04                	ja     5a8 <free+0x2f>
 5a4:	89 d0                	mov    %edx,%eax
 5a6:	eb e6                	jmp    58e <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ae:	8b 10                	mov    (%eax),%edx
 5b0:	39 d7                	cmp    %edx,%edi
 5b2:	74 19                	je     5cd <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5b4:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b7:	8b 50 04             	mov    0x4(%eax),%edx
 5ba:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5bd:	39 ce                	cmp    %ecx,%esi
 5bf:	74 1b                	je     5dc <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5c1:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5c3:	a3 dc 09 00 00       	mov    %eax,0x9dc
}
 5c8:	5b                   	pop    %ebx
 5c9:	5e                   	pop    %esi
 5ca:	5f                   	pop    %edi
 5cb:	5d                   	pop    %ebp
 5cc:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5cd:	03 72 04             	add    0x4(%edx),%esi
 5d0:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d3:	8b 10                	mov    (%eax),%edx
 5d5:	8b 12                	mov    (%edx),%edx
 5d7:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5da:	eb db                	jmp    5b7 <free+0x3e>
    p->s.size += bp->s.size;
 5dc:	03 53 fc             	add    -0x4(%ebx),%edx
 5df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5e5:	89 10                	mov    %edx,(%eax)
 5e7:	eb da                	jmp    5c3 <free+0x4a>

000005e9 <morecore>:

static Header*
morecore(uint nu)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	53                   	push   %ebx
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5f2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5f7:	77 05                	ja     5fe <morecore+0x15>
    nu = 4096;
 5f9:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5fe:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 605:	83 ec 0c             	sub    $0xc,%esp
 608:	50                   	push   %eax
 609:	e8 a8 fc ff ff       	call   2b6 <sbrk>
  if(p == (char*)-1)
 60e:	83 c4 10             	add    $0x10,%esp
 611:	83 f8 ff             	cmp    $0xffffffff,%eax
 614:	74 1c                	je     632 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 616:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 619:	83 c0 08             	add    $0x8,%eax
 61c:	83 ec 0c             	sub    $0xc,%esp
 61f:	50                   	push   %eax
 620:	e8 54 ff ff ff       	call   579 <free>
  return freep;
 625:	a1 dc 09 00 00       	mov    0x9dc,%eax
 62a:	83 c4 10             	add    $0x10,%esp
}
 62d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 630:	c9                   	leave  
 631:	c3                   	ret    
    return 0;
 632:	b8 00 00 00 00       	mov    $0x0,%eax
 637:	eb f4                	jmp    62d <morecore+0x44>

00000639 <malloc>:

void*
malloc(uint nbytes)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	53                   	push   %ebx
 63d:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	8d 58 07             	lea    0x7(%eax),%ebx
 646:	c1 eb 03             	shr    $0x3,%ebx
 649:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 64c:	8b 0d dc 09 00 00    	mov    0x9dc,%ecx
 652:	85 c9                	test   %ecx,%ecx
 654:	74 04                	je     65a <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 656:	8b 01                	mov    (%ecx),%eax
 658:	eb 4a                	jmp    6a4 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 65a:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 661:	09 00 00 
 664:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 66b:	09 00 00 
    base.s.size = 0;
 66e:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 675:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 678:	b9 e0 09 00 00       	mov    $0x9e0,%ecx
 67d:	eb d7                	jmp    656 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 67f:	74 19                	je     69a <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 681:	29 da                	sub    %ebx,%edx
 683:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 686:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 689:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 68c:	89 0d dc 09 00 00    	mov    %ecx,0x9dc
      return (void*)(p + 1);
 692:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 698:	c9                   	leave  
 699:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 69a:	8b 10                	mov    (%eax),%edx
 69c:	89 11                	mov    %edx,(%ecx)
 69e:	eb ec                	jmp    68c <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a0:	89 c1                	mov    %eax,%ecx
 6a2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	39 da                	cmp    %ebx,%edx
 6a9:	73 d4                	jae    67f <malloc+0x46>
    if(p == freep)
 6ab:	39 05 dc 09 00 00    	cmp    %eax,0x9dc
 6b1:	75 ed                	jne    6a0 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6b3:	89 d8                	mov    %ebx,%eax
 6b5:	e8 2f ff ff ff       	call   5e9 <morecore>
 6ba:	85 c0                	test   %eax,%eax
 6bc:	75 e2                	jne    6a0 <malloc+0x67>
 6be:	eb d5                	jmp    695 <malloc+0x5c>
