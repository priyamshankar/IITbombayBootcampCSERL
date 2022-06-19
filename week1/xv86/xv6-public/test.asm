
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
  13:	e8 fb 02 00 00       	call   313 <init_counter>
    int ret = fork();
  18:	e8 16 02 00 00       	call   233 <fork>
  1d:	89 c6                	mov    %eax,%esi
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held. 
    */
    // printf(1,"init: %d\nacq: %d \nrel: %d \nhol: %d\n", init_mylock(),acquire_mylock(11), release_mylock(12),holding_mylock(13));

    // printf(1,"%d\n",init_mylock());
    init_mylock();
  1f:	e8 37 03 00 00       	call   35b <init_mylock>
    printf(1,"%d\n",acquire_mylock(0));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	6a 00                	push   $0x0
  29:	e8 35 03 00 00       	call   363 <acquire_mylock>
  2e:	83 c4 0c             	add    $0xc,%esp
  31:	50                   	push   %eax
  32:	68 d0 06 00 00       	push   $0x6d0
  37:	6a 01                	push   $0x1
  39:	e8 e2 03 00 00       	call   420 <printf>
    printf(1,"%d\n",release_mylock(0));
  3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  45:	e8 21 03 00 00       	call   36b <release_mylock>
  4a:	83 c4 0c             	add    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	68 d0 06 00 00       	push   $0x6d0
  53:	6a 01                	push   $0x1
  55:	e8 c6 03 00 00       	call   420 <printf>
    // printf(1,"hello spinlocks");


    for(int i=0; i<10000; i++){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  62:	eb 08                	jmp    6c <main+0x6c>
        update_cnt();
  64:	e8 b2 02 00 00       	call   31b <update_cnt>
    for(int i=0; i<10000; i++){
  69:	83 c3 01             	add    $0x1,%ebx
  6c:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  72:	7e f0                	jle    64 <main+0x64>
    }

    if(ret == 0)
  74:	85 f6                	test   %esi,%esi
  76:	75 05                	jne    7d <main+0x7d>
        exit();
  78:	e8 be 01 00 00       	call   23b <exit>
    else{
        wait();
  7d:	e8 c1 01 00 00       	call   243 <wait>
        printf(1, "%d\n", display_count());
  82:	e8 9c 02 00 00       	call   323 <display_count>
  87:	83 ec 04             	sub    $0x4,%esp
  8a:	50                   	push   %eax
  8b:	68 d0 06 00 00       	push   $0x6d0
  90:	6a 01                	push   $0x1
  92:	e8 89 03 00 00       	call   420 <printf>
        exit();
  97:	e8 9f 01 00 00       	call   23b <exit>

0000009c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	56                   	push   %esi
  a0:	53                   	push   %ebx
  a1:	8b 75 08             	mov    0x8(%ebp),%esi
  a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a7:	89 f0                	mov    %esi,%eax
  a9:	89 d1                	mov    %edx,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
  ae:	89 c3                	mov    %eax,%ebx
  b0:	83 c0 01             	add    $0x1,%eax
  b3:	0f b6 09             	movzbl (%ecx),%ecx
  b6:	88 0b                	mov    %cl,(%ebx)
  b8:	84 c9                	test   %cl,%cl
  ba:	75 ed                	jne    a9 <strcpy+0xd>
    ;
  return os;
}
  bc:	89 f0                	mov    %esi,%eax
  be:	5b                   	pop    %ebx
  bf:	5e                   	pop    %esi
  c0:	5d                   	pop    %ebp
  c1:	c3                   	ret    

000000c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  cb:	eb 06                	jmp    d3 <strcmp+0x11>
    p++, q++;
  cd:	83 c1 01             	add    $0x1,%ecx
  d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  d3:	0f b6 01             	movzbl (%ecx),%eax
  d6:	84 c0                	test   %al,%al
  d8:	74 04                	je     de <strcmp+0x1c>
  da:	3a 02                	cmp    (%edx),%al
  dc:	74 ef                	je     cd <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  de:	0f b6 c0             	movzbl %al,%eax
  e1:	0f b6 12             	movzbl (%edx),%edx
  e4:	29 d0                	sub    %edx,%eax
}
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strlen>:

uint
strlen(const char *s)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ee:	b8 00 00 00 00       	mov    $0x0,%eax
  f3:	eb 03                	jmp    f8 <strlen+0x10>
  f5:	83 c0 01             	add    $0x1,%eax
  f8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  fc:	75 f7                	jne    f5 <strlen+0xd>
    ;
  return n;
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	89 d7                	mov    %edx,%edi
 109:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	8b 7d fc             	mov    -0x4(%ebp),%edi
 117:	c9                   	leave  
 118:	c3                   	ret    

00000119 <strchr>:

char*
strchr(const char *s, char c)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 123:	eb 03                	jmp    128 <strchr+0xf>
 125:	83 c0 01             	add    $0x1,%eax
 128:	0f b6 10             	movzbl (%eax),%edx
 12b:	84 d2                	test   %dl,%dl
 12d:	74 06                	je     135 <strchr+0x1c>
    if(*s == c)
 12f:	38 ca                	cmp    %cl,%dl
 131:	75 f2                	jne    125 <strchr+0xc>
 133:	eb 05                	jmp    13a <strchr+0x21>
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	56                   	push   %esi
 141:	53                   	push   %ebx
 142:	83 ec 1c             	sub    $0x1c,%esp
 145:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 148:	bb 00 00 00 00       	mov    $0x0,%ebx
 14d:	89 de                	mov    %ebx,%esi
 14f:	83 c3 01             	add    $0x1,%ebx
 152:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 155:	7d 2e                	jge    185 <gets+0x49>
    cc = read(0, &c, 1);
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	6a 01                	push   $0x1
 15c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 15f:	50                   	push   %eax
 160:	6a 00                	push   $0x0
 162:	e8 ec 00 00 00       	call   253 <read>
    if(cc < 1)
 167:	83 c4 10             	add    $0x10,%esp
 16a:	85 c0                	test   %eax,%eax
 16c:	7e 17                	jle    185 <gets+0x49>
      break;
    buf[i++] = c;
 16e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 172:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 175:	3c 0a                	cmp    $0xa,%al
 177:	0f 94 c2             	sete   %dl
 17a:	3c 0d                	cmp    $0xd,%al
 17c:	0f 94 c0             	sete   %al
 17f:	08 c2                	or     %al,%dl
 181:	74 ca                	je     14d <gets+0x11>
    buf[i++] = c;
 183:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 185:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 189:	89 f8                	mov    %edi,%eax
 18b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18e:	5b                   	pop    %ebx
 18f:	5e                   	pop    %esi
 190:	5f                   	pop    %edi
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <stat>:

int
stat(const char *n, struct stat *st)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	56                   	push   %esi
 197:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	83 ec 08             	sub    $0x8,%esp
 19b:	6a 00                	push   $0x0
 19d:	ff 75 08             	push   0x8(%ebp)
 1a0:	e8 d6 00 00 00       	call   27b <open>
  if(fd < 0)
 1a5:	83 c4 10             	add    $0x10,%esp
 1a8:	85 c0                	test   %eax,%eax
 1aa:	78 24                	js     1d0 <stat+0x3d>
 1ac:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1ae:	83 ec 08             	sub    $0x8,%esp
 1b1:	ff 75 0c             	push   0xc(%ebp)
 1b4:	50                   	push   %eax
 1b5:	e8 d9 00 00 00       	call   293 <fstat>
 1ba:	89 c6                	mov    %eax,%esi
  close(fd);
 1bc:	89 1c 24             	mov    %ebx,(%esp)
 1bf:	e8 9f 00 00 00       	call   263 <close>
  return r;
 1c4:	83 c4 10             	add    $0x10,%esp
}
 1c7:	89 f0                	mov    %esi,%eax
 1c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1cc:	5b                   	pop    %ebx
 1cd:	5e                   	pop    %esi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    
    return -1;
 1d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d5:	eb f0                	jmp    1c7 <stat+0x34>

000001d7 <atoi>:

int
atoi(const char *s)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	53                   	push   %ebx
 1db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1de:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1e3:	eb 10                	jmp    1f5 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1e5:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1e8:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1eb:	83 c1 01             	add    $0x1,%ecx
 1ee:	0f be c0             	movsbl %al,%eax
 1f1:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1f5:	0f b6 01             	movzbl (%ecx),%eax
 1f8:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1fb:	80 fb 09             	cmp    $0x9,%bl
 1fe:	76 e5                	jbe    1e5 <atoi+0xe>
  return n;
}
 200:	89 d0                	mov    %edx,%eax
 202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	56                   	push   %esi
 20b:	53                   	push   %ebx
 20c:	8b 75 08             	mov    0x8(%ebp),%esi
 20f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 212:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 215:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 217:	eb 0d                	jmp    226 <memmove+0x1f>
    *dst++ = *src++;
 219:	0f b6 01             	movzbl (%ecx),%eax
 21c:	88 02                	mov    %al,(%edx)
 21e:	8d 49 01             	lea    0x1(%ecx),%ecx
 221:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 224:	89 d8                	mov    %ebx,%eax
 226:	8d 58 ff             	lea    -0x1(%eax),%ebx
 229:	85 c0                	test   %eax,%eax
 22b:	7f ec                	jg     219 <memmove+0x12>
  return vdst;
}
 22d:	89 f0                	mov    %esi,%eax
 22f:	5b                   	pop    %ebx
 230:	5e                   	pop    %esi
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 233:	b8 01 00 00 00       	mov    $0x1,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <exit>:
SYSCALL(exit)
 23b:	b8 02 00 00 00       	mov    $0x2,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <wait>:
SYSCALL(wait)
 243:	b8 03 00 00 00       	mov    $0x3,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <pipe>:
SYSCALL(pipe)
 24b:	b8 04 00 00 00       	mov    $0x4,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <read>:
SYSCALL(read)
 253:	b8 05 00 00 00       	mov    $0x5,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <write>:
SYSCALL(write)
 25b:	b8 10 00 00 00       	mov    $0x10,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <close>:
SYSCALL(close)
 263:	b8 15 00 00 00       	mov    $0x15,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <kill>:
SYSCALL(kill)
 26b:	b8 06 00 00 00       	mov    $0x6,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exec>:
SYSCALL(exec)
 273:	b8 07 00 00 00       	mov    $0x7,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <open>:
SYSCALL(open)
 27b:	b8 0f 00 00 00       	mov    $0xf,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <mknod>:
SYSCALL(mknod)
 283:	b8 11 00 00 00       	mov    $0x11,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <unlink>:
SYSCALL(unlink)
 28b:	b8 12 00 00 00       	mov    $0x12,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <fstat>:
SYSCALL(fstat)
 293:	b8 08 00 00 00       	mov    $0x8,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <link>:
SYSCALL(link)
 29b:	b8 13 00 00 00       	mov    $0x13,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <mkdir>:
SYSCALL(mkdir)
 2a3:	b8 14 00 00 00       	mov    $0x14,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <chdir>:
SYSCALL(chdir)
 2ab:	b8 09 00 00 00       	mov    $0x9,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <dup>:
SYSCALL(dup)
 2b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <getpid>:
SYSCALL(getpid)
 2bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <sbrk>:
SYSCALL(sbrk)
 2c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <sleep>:
SYSCALL(sleep)
 2cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <uptime>:
SYSCALL(uptime)
 2d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <hello>:
SYSCALL(hello)
 2db:	b8 16 00 00 00       	mov    $0x16,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <helloYou>:
SYSCALL(helloYou)
 2e3:	b8 17 00 00 00       	mov    $0x17,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <getppid>:
SYSCALL(getppid)
 2eb:	b8 18 00 00 00       	mov    $0x18,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2f3:	b8 19 00 00 00       	mov    $0x19,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <signalProcess>:
SYSCALL(signalProcess)
 2fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <numvp>:
SYSCALL(numvp)
 303:	b8 1b 00 00 00       	mov    $0x1b,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <numpp>:
SYSCALL(numpp)
 30b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <init_counter>:

SYSCALL(init_counter)
 313:	b8 1d 00 00 00       	mov    $0x1d,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <update_cnt>:
SYSCALL(update_cnt)
 31b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <display_count>:
SYSCALL(display_count)
 323:	b8 1f 00 00 00       	mov    $0x1f,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <init_counter_1>:
SYSCALL(init_counter_1)
 32b:	b8 20 00 00 00       	mov    $0x20,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <update_cnt_1>:
SYSCALL(update_cnt_1)
 333:	b8 21 00 00 00       	mov    $0x21,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <display_count_1>:
SYSCALL(display_count_1)
 33b:	b8 22 00 00 00       	mov    $0x22,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <init_counter_2>:
SYSCALL(init_counter_2)
 343:	b8 23 00 00 00       	mov    $0x23,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <update_cnt_2>:
SYSCALL(update_cnt_2)
 34b:	b8 24 00 00 00       	mov    $0x24,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <display_count_2>:
SYSCALL(display_count_2)
 353:	b8 25 00 00 00       	mov    $0x25,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <init_mylock>:
SYSCALL(init_mylock)
 35b:	b8 26 00 00 00       	mov    $0x26,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <acquire_mylock>:
SYSCALL(acquire_mylock)
 363:	b8 27 00 00 00       	mov    $0x27,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <release_mylock>:
SYSCALL(release_mylock)
 36b:	b8 28 00 00 00       	mov    $0x28,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <holding_mylock>:
 373:	b8 29 00 00 00       	mov    $0x29,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 1c             	sub    $0x1c,%esp
 381:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 384:	6a 01                	push   $0x1
 386:	8d 55 f4             	lea    -0xc(%ebp),%edx
 389:	52                   	push   %edx
 38a:	50                   	push   %eax
 38b:	e8 cb fe ff ff       	call   25b <write>
}
 390:	83 c4 10             	add    $0x10,%esp
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	57                   	push   %edi
 399:	56                   	push   %esi
 39a:	53                   	push   %ebx
 39b:	83 ec 2c             	sub    $0x2c,%esp
 39e:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3a1:	89 d0                	mov    %edx,%eax
 3a3:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a9:	0f 95 c1             	setne  %cl
 3ac:	c1 ea 1f             	shr    $0x1f,%edx
 3af:	84 d1                	test   %dl,%cl
 3b1:	74 44                	je     3f7 <printint+0x62>
    neg = 1;
    x = -xx;
 3b3:	f7 d8                	neg    %eax
 3b5:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3b7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3be:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ca:	f7 f6                	div    %esi
 3cc:	89 df                	mov    %ebx,%edi
 3ce:	83 c3 01             	add    $0x1,%ebx
 3d1:	0f b6 92 34 07 00 00 	movzbl 0x734(%edx),%edx
 3d8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3dc:	89 ca                	mov    %ecx,%edx
 3de:	89 c1                	mov    %eax,%ecx
 3e0:	39 d6                	cmp    %edx,%esi
 3e2:	76 df                	jbe    3c3 <printint+0x2e>
  if(neg)
 3e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3e8:	74 31                	je     41b <printint+0x86>
    buf[i++] = '-';
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ef:	8d 5f 02             	lea    0x2(%edi),%ebx
 3f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f5:	eb 17                	jmp    40e <printint+0x79>
    x = xx;
 3f7:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3f9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 400:	eb bc                	jmp    3be <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 402:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 407:	89 f0                	mov    %esi,%eax
 409:	e8 6d ff ff ff       	call   37b <putc>
  while(--i >= 0)
 40e:	83 eb 01             	sub    $0x1,%ebx
 411:	79 ef                	jns    402 <printint+0x6d>
}
 413:	83 c4 2c             	add    $0x2c,%esp
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    
 41b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 41e:	eb ee                	jmp    40e <printint+0x79>

00000420 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 429:	8d 45 10             	lea    0x10(%ebp),%eax
 42c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 42f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 434:	bb 00 00 00 00       	mov    $0x0,%ebx
 439:	eb 14                	jmp    44f <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 43b:	89 fa                	mov    %edi,%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	e8 36 ff ff ff       	call   37b <putc>
 445:	eb 05                	jmp    44c <printf+0x2c>
      }
    } else if(state == '%'){
 447:	83 fe 25             	cmp    $0x25,%esi
 44a:	74 25                	je     471 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 44c:	83 c3 01             	add    $0x1,%ebx
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 456:	84 c0                	test   %al,%al
 458:	0f 84 20 01 00 00    	je     57e <printf+0x15e>
    c = fmt[i] & 0xff;
 45e:	0f be f8             	movsbl %al,%edi
 461:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 464:	85 f6                	test   %esi,%esi
 466:	75 df                	jne    447 <printf+0x27>
      if(c == '%'){
 468:	83 f8 25             	cmp    $0x25,%eax
 46b:	75 ce                	jne    43b <printf+0x1b>
        state = '%';
 46d:	89 c6                	mov    %eax,%esi
 46f:	eb db                	jmp    44c <printf+0x2c>
      if(c == 'd'){
 471:	83 f8 25             	cmp    $0x25,%eax
 474:	0f 84 cf 00 00 00    	je     549 <printf+0x129>
 47a:	0f 8c dd 00 00 00    	jl     55d <printf+0x13d>
 480:	83 f8 78             	cmp    $0x78,%eax
 483:	0f 8f d4 00 00 00    	jg     55d <printf+0x13d>
 489:	83 f8 63             	cmp    $0x63,%eax
 48c:	0f 8c cb 00 00 00    	jl     55d <printf+0x13d>
 492:	83 e8 63             	sub    $0x63,%eax
 495:	83 f8 15             	cmp    $0x15,%eax
 498:	0f 87 bf 00 00 00    	ja     55d <printf+0x13d>
 49e:	ff 24 85 dc 06 00 00 	jmp    *0x6dc(,%eax,4)
        printint(fd, *ap, 10, 1);
 4a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a8:	8b 17                	mov    (%edi),%edx
 4aa:	83 ec 0c             	sub    $0xc,%esp
 4ad:	6a 01                	push   $0x1
 4af:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	e8 d9 fe ff ff       	call   395 <printint>
        ap++;
 4bc:	83 c7 04             	add    $0x4,%edi
 4bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c2:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c5:	be 00 00 00 00       	mov    $0x0,%esi
 4ca:	eb 80                	jmp    44c <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4cf:	8b 17                	mov    (%edi),%edx
 4d1:	83 ec 0c             	sub    $0xc,%esp
 4d4:	6a 00                	push   $0x0
 4d6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 b2 fe ff ff       	call   395 <printint>
        ap++;
 4e3:	83 c7 04             	add    $0x4,%edi
 4e6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ec:	be 00 00 00 00       	mov    $0x0,%esi
 4f1:	e9 56 ff ff ff       	jmp    44c <printf+0x2c>
        s = (char*)*ap;
 4f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f9:	8b 30                	mov    (%eax),%esi
        ap++;
 4fb:	83 c0 04             	add    $0x4,%eax
 4fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 501:	85 f6                	test   %esi,%esi
 503:	75 15                	jne    51a <printf+0xfa>
          s = "(null)";
 505:	be d4 06 00 00       	mov    $0x6d4,%esi
 50a:	eb 0e                	jmp    51a <printf+0xfa>
          putc(fd, *s);
 50c:	0f be d2             	movsbl %dl,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 64 fe ff ff       	call   37b <putc>
          s++;
 517:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 51a:	0f b6 16             	movzbl (%esi),%edx
 51d:	84 d2                	test   %dl,%dl
 51f:	75 eb                	jne    50c <printf+0xec>
      state = 0;
 521:	be 00 00 00 00       	mov    $0x0,%esi
 526:	e9 21 ff ff ff       	jmp    44c <printf+0x2c>
        putc(fd, *ap);
 52b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52e:	0f be 17             	movsbl (%edi),%edx
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	e8 42 fe ff ff       	call   37b <putc>
        ap++;
 539:	83 c7 04             	add    $0x4,%edi
 53c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 53f:	be 00 00 00 00       	mov    $0x0,%esi
 544:	e9 03 ff ff ff       	jmp    44c <printf+0x2c>
        putc(fd, c);
 549:	89 fa                	mov    %edi,%edx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	e8 28 fe ff ff       	call   37b <putc>
      state = 0;
 553:	be 00 00 00 00       	mov    $0x0,%esi
 558:	e9 ef fe ff ff       	jmp    44c <printf+0x2c>
        putc(fd, '%');
 55d:	ba 25 00 00 00       	mov    $0x25,%edx
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	e8 11 fe ff ff       	call   37b <putc>
        putc(fd, c);
 56a:	89 fa                	mov    %edi,%edx
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	e8 07 fe ff ff       	call   37b <putc>
      state = 0;
 574:	be 00 00 00 00       	mov    $0x0,%esi
 579:	e9 ce fe ff ff       	jmp    44c <printf+0x2c>
    }
  }
}
 57e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 581:	5b                   	pop    %ebx
 582:	5e                   	pop    %esi
 583:	5f                   	pop    %edi
 584:	5d                   	pop    %ebp
 585:	c3                   	ret    

00000586 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 586:	55                   	push   %ebp
 587:	89 e5                	mov    %esp,%ebp
 589:	57                   	push   %edi
 58a:	56                   	push   %esi
 58b:	53                   	push   %ebx
 58c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 58f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 592:	a1 dc 09 00 00       	mov    0x9dc,%eax
 597:	eb 02                	jmp    59b <free+0x15>
 599:	89 d0                	mov    %edx,%eax
 59b:	39 c8                	cmp    %ecx,%eax
 59d:	73 04                	jae    5a3 <free+0x1d>
 59f:	39 08                	cmp    %ecx,(%eax)
 5a1:	77 12                	ja     5b5 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a3:	8b 10                	mov    (%eax),%edx
 5a5:	39 c2                	cmp    %eax,%edx
 5a7:	77 f0                	ja     599 <free+0x13>
 5a9:	39 c8                	cmp    %ecx,%eax
 5ab:	72 08                	jb     5b5 <free+0x2f>
 5ad:	39 ca                	cmp    %ecx,%edx
 5af:	77 04                	ja     5b5 <free+0x2f>
 5b1:	89 d0                	mov    %edx,%eax
 5b3:	eb e6                	jmp    59b <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b5:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b8:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5bb:	8b 10                	mov    (%eax),%edx
 5bd:	39 d7                	cmp    %edx,%edi
 5bf:	74 19                	je     5da <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5c1:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c4:	8b 50 04             	mov    0x4(%eax),%edx
 5c7:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5ca:	39 ce                	cmp    %ecx,%esi
 5cc:	74 1b                	je     5e9 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ce:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5d0:	a3 dc 09 00 00       	mov    %eax,0x9dc
}
 5d5:	5b                   	pop    %ebx
 5d6:	5e                   	pop    %esi
 5d7:	5f                   	pop    %edi
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5da:	03 72 04             	add    0x4(%edx),%esi
 5dd:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e0:	8b 10                	mov    (%eax),%edx
 5e2:	8b 12                	mov    (%edx),%edx
 5e4:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5e7:	eb db                	jmp    5c4 <free+0x3e>
    p->s.size += bp->s.size;
 5e9:	03 53 fc             	add    -0x4(%ebx),%edx
 5ec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ef:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5f2:	89 10                	mov    %edx,(%eax)
 5f4:	eb da                	jmp    5d0 <free+0x4a>

000005f6 <morecore>:

static Header*
morecore(uint nu)
{
 5f6:	55                   	push   %ebp
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	53                   	push   %ebx
 5fa:	83 ec 04             	sub    $0x4,%esp
 5fd:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5ff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 604:	77 05                	ja     60b <morecore+0x15>
    nu = 4096;
 606:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 60b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 612:	83 ec 0c             	sub    $0xc,%esp
 615:	50                   	push   %eax
 616:	e8 a8 fc ff ff       	call   2c3 <sbrk>
  if(p == (char*)-1)
 61b:	83 c4 10             	add    $0x10,%esp
 61e:	83 f8 ff             	cmp    $0xffffffff,%eax
 621:	74 1c                	je     63f <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 623:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 626:	83 c0 08             	add    $0x8,%eax
 629:	83 ec 0c             	sub    $0xc,%esp
 62c:	50                   	push   %eax
 62d:	e8 54 ff ff ff       	call   586 <free>
  return freep;
 632:	a1 dc 09 00 00       	mov    0x9dc,%eax
 637:	83 c4 10             	add    $0x10,%esp
}
 63a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 63d:	c9                   	leave  
 63e:	c3                   	ret    
    return 0;
 63f:	b8 00 00 00 00       	mov    $0x0,%eax
 644:	eb f4                	jmp    63a <morecore+0x44>

00000646 <malloc>:

void*
malloc(uint nbytes)
{
 646:	55                   	push   %ebp
 647:	89 e5                	mov    %esp,%ebp
 649:	53                   	push   %ebx
 64a:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	8d 58 07             	lea    0x7(%eax),%ebx
 653:	c1 eb 03             	shr    $0x3,%ebx
 656:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 659:	8b 0d dc 09 00 00    	mov    0x9dc,%ecx
 65f:	85 c9                	test   %ecx,%ecx
 661:	74 04                	je     667 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 663:	8b 01                	mov    (%ecx),%eax
 665:	eb 4a                	jmp    6b1 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 667:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 66e:	09 00 00 
 671:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 678:	09 00 00 
    base.s.size = 0;
 67b:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 682:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 685:	b9 e0 09 00 00       	mov    $0x9e0,%ecx
 68a:	eb d7                	jmp    663 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 68c:	74 19                	je     6a7 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 68e:	29 da                	sub    %ebx,%edx
 690:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 693:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 696:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 699:	89 0d dc 09 00 00    	mov    %ecx,0x9dc
      return (void*)(p + 1);
 69f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a5:	c9                   	leave  
 6a6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6a7:	8b 10                	mov    (%eax),%edx
 6a9:	89 11                	mov    %edx,(%ecx)
 6ab:	eb ec                	jmp    699 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ad:	89 c1                	mov    %eax,%ecx
 6af:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6b1:	8b 50 04             	mov    0x4(%eax),%edx
 6b4:	39 da                	cmp    %ebx,%edx
 6b6:	73 d4                	jae    68c <malloc+0x46>
    if(p == freep)
 6b8:	39 05 dc 09 00 00    	cmp    %eax,0x9dc
 6be:	75 ed                	jne    6ad <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6c0:	89 d8                	mov    %ebx,%eax
 6c2:	e8 2f ff ff ff       	call   5f6 <morecore>
 6c7:	85 c0                	test   %eax,%eax
 6c9:	75 e2                	jne    6ad <malloc+0x67>
 6cb:	eb d5                	jmp    6a2 <malloc+0x5c>
