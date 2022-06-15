
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
  13:	e8 bd 02 00 00       	call   2d5 <init_counter>
    int ret = fork();
  18:	e8 d8 01 00 00       	call   1f5 <fork>
  1d:	89 c6                	mov    %eax,%esi
            1. Print lock id if the lock has been initialized.
            2. define and call the function 'int holding_mylock(int id)' to check the status of
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held. 
    */

    for(int i=0; i<10000; i++){
  1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  24:	eb 08                	jmp    2e <main+0x2e>
        update_cnt();
  26:	e8 b2 02 00 00       	call   2dd <update_cnt>
    for(int i=0; i<10000; i++){
  2b:	83 c3 01             	add    $0x1,%ebx
  2e:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  34:	7e f0                	jle    26 <main+0x26>
    }

    if(ret == 0)
  36:	85 f6                	test   %esi,%esi
  38:	75 05                	jne    3f <main+0x3f>
        exit();
  3a:	e8 be 01 00 00       	call   1fd <exit>
    else{
        wait();
  3f:	e8 c1 01 00 00       	call   205 <wait>
        printf(1, "%d\n", display_count());
  44:	e8 9c 02 00 00       	call   2e5 <display_count>
  49:	83 ec 04             	sub    $0x4,%esp
  4c:	50                   	push   %eax
  4d:	68 70 06 00 00       	push   $0x670
  52:	6a 01                	push   $0x1
  54:	e8 69 03 00 00       	call   3c2 <printf>
        exit();
  59:	e8 9f 01 00 00       	call   1fd <exit>

0000005e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5e:	55                   	push   %ebp
  5f:	89 e5                	mov    %esp,%ebp
  61:	56                   	push   %esi
  62:	53                   	push   %ebx
  63:	8b 75 08             	mov    0x8(%ebp),%esi
  66:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  69:	89 f0                	mov    %esi,%eax
  6b:	89 d1                	mov    %edx,%ecx
  6d:	83 c2 01             	add    $0x1,%edx
  70:	89 c3                	mov    %eax,%ebx
  72:	83 c0 01             	add    $0x1,%eax
  75:	0f b6 09             	movzbl (%ecx),%ecx
  78:	88 0b                	mov    %cl,(%ebx)
  7a:	84 c9                	test   %cl,%cl
  7c:	75 ed                	jne    6b <strcpy+0xd>
    ;
  return os;
}
  7e:	89 f0                	mov    %esi,%eax
  80:	5b                   	pop    %ebx
  81:	5e                   	pop    %esi
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    

00000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8d:	eb 06                	jmp    95 <strcmp+0x11>
    p++, q++;
  8f:	83 c1 01             	add    $0x1,%ecx
  92:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  95:	0f b6 01             	movzbl (%ecx),%eax
  98:	84 c0                	test   %al,%al
  9a:	74 04                	je     a0 <strcmp+0x1c>
  9c:	3a 02                	cmp    (%edx),%al
  9e:	74 ef                	je     8f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  a0:	0f b6 c0             	movzbl %al,%eax
  a3:	0f b6 12             	movzbl (%edx),%edx
  a6:	29 d0                	sub    %edx,%eax
}
  a8:	5d                   	pop    %ebp
  a9:	c3                   	ret    

000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	55                   	push   %ebp
  ab:	89 e5                	mov    %esp,%ebp
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b0:	b8 00 00 00 00       	mov    $0x0,%eax
  b5:	eb 03                	jmp    ba <strlen+0x10>
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  be:	75 f7                	jne    b7 <strlen+0xd>
    ;
  return n;
}
  c0:	5d                   	pop    %ebp
  c1:	c3                   	ret    

000000c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	57                   	push   %edi
  c6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c9:	89 d7                	mov    %edx,%edi
  cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  d1:	fc                   	cld    
  d2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d4:	89 d0                	mov    %edx,%eax
  d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d9:	c9                   	leave  
  da:	c3                   	ret    

000000db <strchr>:

char*
strchr(const char *s, char c)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e5:	eb 03                	jmp    ea <strchr+0xf>
  e7:	83 c0 01             	add    $0x1,%eax
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	74 06                	je     f7 <strchr+0x1c>
    if(*s == c)
  f1:	38 ca                	cmp    %cl,%dl
  f3:	75 f2                	jne    e7 <strchr+0xc>
  f5:	eb 05                	jmp    fc <strchr+0x21>
      return (char*)s;
  return 0;
  f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    

000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	57                   	push   %edi
 102:	56                   	push   %esi
 103:	53                   	push   %ebx
 104:	83 ec 1c             	sub    $0x1c,%esp
 107:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10a:	bb 00 00 00 00       	mov    $0x0,%ebx
 10f:	89 de                	mov    %ebx,%esi
 111:	83 c3 01             	add    $0x1,%ebx
 114:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 117:	7d 2e                	jge    147 <gets+0x49>
    cc = read(0, &c, 1);
 119:	83 ec 04             	sub    $0x4,%esp
 11c:	6a 01                	push   $0x1
 11e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 121:	50                   	push   %eax
 122:	6a 00                	push   $0x0
 124:	e8 ec 00 00 00       	call   215 <read>
    if(cc < 1)
 129:	83 c4 10             	add    $0x10,%esp
 12c:	85 c0                	test   %eax,%eax
 12e:	7e 17                	jle    147 <gets+0x49>
      break;
    buf[i++] = c;
 130:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 134:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 137:	3c 0a                	cmp    $0xa,%al
 139:	0f 94 c2             	sete   %dl
 13c:	3c 0d                	cmp    $0xd,%al
 13e:	0f 94 c0             	sete   %al
 141:	08 c2                	or     %al,%dl
 143:	74 ca                	je     10f <gets+0x11>
    buf[i++] = c;
 145:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 147:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 14b:	89 f8                	mov    %edi,%eax
 14d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 150:	5b                   	pop    %ebx
 151:	5e                   	pop    %esi
 152:	5f                   	pop    %edi
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    

00000155 <stat>:

int
stat(const char *n, struct stat *st)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	56                   	push   %esi
 159:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15a:	83 ec 08             	sub    $0x8,%esp
 15d:	6a 00                	push   $0x0
 15f:	ff 75 08             	push   0x8(%ebp)
 162:	e8 d6 00 00 00       	call   23d <open>
  if(fd < 0)
 167:	83 c4 10             	add    $0x10,%esp
 16a:	85 c0                	test   %eax,%eax
 16c:	78 24                	js     192 <stat+0x3d>
 16e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 170:	83 ec 08             	sub    $0x8,%esp
 173:	ff 75 0c             	push   0xc(%ebp)
 176:	50                   	push   %eax
 177:	e8 d9 00 00 00       	call   255 <fstat>
 17c:	89 c6                	mov    %eax,%esi
  close(fd);
 17e:	89 1c 24             	mov    %ebx,(%esp)
 181:	e8 9f 00 00 00       	call   225 <close>
  return r;
 186:	83 c4 10             	add    $0x10,%esp
}
 189:	89 f0                	mov    %esi,%eax
 18b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18e:	5b                   	pop    %ebx
 18f:	5e                   	pop    %esi
 190:	5d                   	pop    %ebp
 191:	c3                   	ret    
    return -1;
 192:	be ff ff ff ff       	mov    $0xffffffff,%esi
 197:	eb f0                	jmp    189 <stat+0x34>

00000199 <atoi>:

int
atoi(const char *s)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	53                   	push   %ebx
 19d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1a0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a5:	eb 10                	jmp    1b7 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a7:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1aa:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1ad:	83 c1 01             	add    $0x1,%ecx
 1b0:	0f be c0             	movsbl %al,%eax
 1b3:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b7:	0f b6 01             	movzbl (%ecx),%eax
 1ba:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bd:	80 fb 09             	cmp    $0x9,%bl
 1c0:	76 e5                	jbe    1a7 <atoi+0xe>
  return n;
}
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	56                   	push   %esi
 1cd:	53                   	push   %ebx
 1ce:	8b 75 08             	mov    0x8(%ebp),%esi
 1d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1d9:	eb 0d                	jmp    1e8 <memmove+0x1f>
    *dst++ = *src++;
 1db:	0f b6 01             	movzbl (%ecx),%eax
 1de:	88 02                	mov    %al,(%edx)
 1e0:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e3:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e6:	89 d8                	mov    %ebx,%eax
 1e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1eb:	85 c0                	test   %eax,%eax
 1ed:	7f ec                	jg     1db <memmove+0x12>
  return vdst;
}
 1ef:	89 f0                	mov    %esi,%eax
 1f1:	5b                   	pop    %ebx
 1f2:	5e                   	pop    %esi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f5:	b8 01 00 00 00       	mov    $0x1,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <exit>:
SYSCALL(exit)
 1fd:	b8 02 00 00 00       	mov    $0x2,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <wait>:
SYSCALL(wait)
 205:	b8 03 00 00 00       	mov    $0x3,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <pipe>:
SYSCALL(pipe)
 20d:	b8 04 00 00 00       	mov    $0x4,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <read>:
SYSCALL(read)
 215:	b8 05 00 00 00       	mov    $0x5,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <write>:
SYSCALL(write)
 21d:	b8 10 00 00 00       	mov    $0x10,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <close>:
SYSCALL(close)
 225:	b8 15 00 00 00       	mov    $0x15,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <kill>:
SYSCALL(kill)
 22d:	b8 06 00 00 00       	mov    $0x6,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <exec>:
SYSCALL(exec)
 235:	b8 07 00 00 00       	mov    $0x7,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <open>:
SYSCALL(open)
 23d:	b8 0f 00 00 00       	mov    $0xf,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <mknod>:
SYSCALL(mknod)
 245:	b8 11 00 00 00       	mov    $0x11,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <unlink>:
SYSCALL(unlink)
 24d:	b8 12 00 00 00       	mov    $0x12,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <fstat>:
SYSCALL(fstat)
 255:	b8 08 00 00 00       	mov    $0x8,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <link>:
SYSCALL(link)
 25d:	b8 13 00 00 00       	mov    $0x13,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <mkdir>:
SYSCALL(mkdir)
 265:	b8 14 00 00 00       	mov    $0x14,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <chdir>:
SYSCALL(chdir)
 26d:	b8 09 00 00 00       	mov    $0x9,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <dup>:
SYSCALL(dup)
 275:	b8 0a 00 00 00       	mov    $0xa,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <getpid>:
SYSCALL(getpid)
 27d:	b8 0b 00 00 00       	mov    $0xb,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <sbrk>:
SYSCALL(sbrk)
 285:	b8 0c 00 00 00       	mov    $0xc,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <sleep>:
SYSCALL(sleep)
 28d:	b8 0d 00 00 00       	mov    $0xd,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <uptime>:
SYSCALL(uptime)
 295:	b8 0e 00 00 00       	mov    $0xe,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <hello>:

SYSCALL(hello)
 29d:	b8 16 00 00 00       	mov    $0x16,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <helloYou>:
SYSCALL(helloYou)
 2a5:	b8 17 00 00 00       	mov    $0x17,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <getppid>:
SYSCALL(getppid)
 2ad:	b8 18 00 00 00       	mov    $0x18,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b5:	b8 19 00 00 00       	mov    $0x19,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <signalProcess>:
SYSCALL(signalProcess)
 2bd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <numvp>:
SYSCALL(numvp)
 2c5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <numpp>:
SYSCALL(numpp)
 2cd:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <init_counter>:

SYSCALL(init_counter)
 2d5:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <update_cnt>:
SYSCALL(update_cnt)
 2dd:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <display_count>:
SYSCALL(display_count)
 2e5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <init_counter_1>:
SYSCALL(init_counter_1)
 2ed:	b8 20 00 00 00       	mov    $0x20,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2f5:	b8 21 00 00 00       	mov    $0x21,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <display_count_1>:
SYSCALL(display_count_1)
 2fd:	b8 22 00 00 00       	mov    $0x22,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <init_counter_2>:
SYSCALL(init_counter_2)
 305:	b8 23 00 00 00       	mov    $0x23,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <update_cnt_2>:
SYSCALL(update_cnt_2)
 30d:	b8 24 00 00 00       	mov    $0x24,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <display_count_2>:
 315:	b8 25 00 00 00       	mov    $0x25,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	83 ec 1c             	sub    $0x1c,%esp
 323:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 326:	6a 01                	push   $0x1
 328:	8d 55 f4             	lea    -0xc(%ebp),%edx
 32b:	52                   	push   %edx
 32c:	50                   	push   %eax
 32d:	e8 eb fe ff ff       	call   21d <write>
}
 332:	83 c4 10             	add    $0x10,%esp
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 337:	55                   	push   %ebp
 338:	89 e5                	mov    %esp,%ebp
 33a:	57                   	push   %edi
 33b:	56                   	push   %esi
 33c:	53                   	push   %ebx
 33d:	83 ec 2c             	sub    $0x2c,%esp
 340:	89 45 d0             	mov    %eax,-0x30(%ebp)
 343:	89 d0                	mov    %edx,%eax
 345:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 34b:	0f 95 c1             	setne  %cl
 34e:	c1 ea 1f             	shr    $0x1f,%edx
 351:	84 d1                	test   %dl,%cl
 353:	74 44                	je     399 <printint+0x62>
    neg = 1;
    x = -xx;
 355:	f7 d8                	neg    %eax
 357:	89 c1                	mov    %eax,%ecx
    neg = 1;
 359:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 360:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 365:	89 c8                	mov    %ecx,%eax
 367:	ba 00 00 00 00       	mov    $0x0,%edx
 36c:	f7 f6                	div    %esi
 36e:	89 df                	mov    %ebx,%edi
 370:	83 c3 01             	add    $0x1,%ebx
 373:	0f b6 92 d4 06 00 00 	movzbl 0x6d4(%edx),%edx
 37a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 37e:	89 ca                	mov    %ecx,%edx
 380:	89 c1                	mov    %eax,%ecx
 382:	39 d6                	cmp    %edx,%esi
 384:	76 df                	jbe    365 <printint+0x2e>
  if(neg)
 386:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 38a:	74 31                	je     3bd <printint+0x86>
    buf[i++] = '-';
 38c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 391:	8d 5f 02             	lea    0x2(%edi),%ebx
 394:	8b 75 d0             	mov    -0x30(%ebp),%esi
 397:	eb 17                	jmp    3b0 <printint+0x79>
    x = xx;
 399:	89 c1                	mov    %eax,%ecx
  neg = 0;
 39b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3a2:	eb bc                	jmp    360 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3a4:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3a9:	89 f0                	mov    %esi,%eax
 3ab:	e8 6d ff ff ff       	call   31d <putc>
  while(--i >= 0)
 3b0:	83 eb 01             	sub    $0x1,%ebx
 3b3:	79 ef                	jns    3a4 <printint+0x6d>
}
 3b5:	83 c4 2c             	add    $0x2c,%esp
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5f                   	pop    %edi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3c0:	eb ee                	jmp    3b0 <printint+0x79>

000003c2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	57                   	push   %edi
 3c6:	56                   	push   %esi
 3c7:	53                   	push   %ebx
 3c8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3cb:	8d 45 10             	lea    0x10(%ebp),%eax
 3ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3d1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3d6:	bb 00 00 00 00       	mov    $0x0,%ebx
 3db:	eb 14                	jmp    3f1 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3dd:	89 fa                	mov    %edi,%edx
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	e8 36 ff ff ff       	call   31d <putc>
 3e7:	eb 05                	jmp    3ee <printf+0x2c>
      }
    } else if(state == '%'){
 3e9:	83 fe 25             	cmp    $0x25,%esi
 3ec:	74 25                	je     413 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3ee:	83 c3 01             	add    $0x1,%ebx
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3f8:	84 c0                	test   %al,%al
 3fa:	0f 84 20 01 00 00    	je     520 <printf+0x15e>
    c = fmt[i] & 0xff;
 400:	0f be f8             	movsbl %al,%edi
 403:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 406:	85 f6                	test   %esi,%esi
 408:	75 df                	jne    3e9 <printf+0x27>
      if(c == '%'){
 40a:	83 f8 25             	cmp    $0x25,%eax
 40d:	75 ce                	jne    3dd <printf+0x1b>
        state = '%';
 40f:	89 c6                	mov    %eax,%esi
 411:	eb db                	jmp    3ee <printf+0x2c>
      if(c == 'd'){
 413:	83 f8 25             	cmp    $0x25,%eax
 416:	0f 84 cf 00 00 00    	je     4eb <printf+0x129>
 41c:	0f 8c dd 00 00 00    	jl     4ff <printf+0x13d>
 422:	83 f8 78             	cmp    $0x78,%eax
 425:	0f 8f d4 00 00 00    	jg     4ff <printf+0x13d>
 42b:	83 f8 63             	cmp    $0x63,%eax
 42e:	0f 8c cb 00 00 00    	jl     4ff <printf+0x13d>
 434:	83 e8 63             	sub    $0x63,%eax
 437:	83 f8 15             	cmp    $0x15,%eax
 43a:	0f 87 bf 00 00 00    	ja     4ff <printf+0x13d>
 440:	ff 24 85 7c 06 00 00 	jmp    *0x67c(,%eax,4)
        printint(fd, *ap, 10, 1);
 447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 44a:	8b 17                	mov    (%edi),%edx
 44c:	83 ec 0c             	sub    $0xc,%esp
 44f:	6a 01                	push   $0x1
 451:	b9 0a 00 00 00       	mov    $0xa,%ecx
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	e8 d9 fe ff ff       	call   337 <printint>
        ap++;
 45e:	83 c7 04             	add    $0x4,%edi
 461:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 464:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 467:	be 00 00 00 00       	mov    $0x0,%esi
 46c:	eb 80                	jmp    3ee <printf+0x2c>
        printint(fd, *ap, 16, 0);
 46e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 471:	8b 17                	mov    (%edi),%edx
 473:	83 ec 0c             	sub    $0xc,%esp
 476:	6a 00                	push   $0x0
 478:	b9 10 00 00 00       	mov    $0x10,%ecx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	e8 b2 fe ff ff       	call   337 <printint>
        ap++;
 485:	83 c7 04             	add    $0x4,%edi
 488:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 48b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48e:	be 00 00 00 00       	mov    $0x0,%esi
 493:	e9 56 ff ff ff       	jmp    3ee <printf+0x2c>
        s = (char*)*ap;
 498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49b:	8b 30                	mov    (%eax),%esi
        ap++;
 49d:	83 c0 04             	add    $0x4,%eax
 4a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4a3:	85 f6                	test   %esi,%esi
 4a5:	75 15                	jne    4bc <printf+0xfa>
          s = "(null)";
 4a7:	be 74 06 00 00       	mov    $0x674,%esi
 4ac:	eb 0e                	jmp    4bc <printf+0xfa>
          putc(fd, *s);
 4ae:	0f be d2             	movsbl %dl,%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	e8 64 fe ff ff       	call   31d <putc>
          s++;
 4b9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4bc:	0f b6 16             	movzbl (%esi),%edx
 4bf:	84 d2                	test   %dl,%dl
 4c1:	75 eb                	jne    4ae <printf+0xec>
      state = 0;
 4c3:	be 00 00 00 00       	mov    $0x0,%esi
 4c8:	e9 21 ff ff ff       	jmp    3ee <printf+0x2c>
        putc(fd, *ap);
 4cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d0:	0f be 17             	movsbl (%edi),%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	e8 42 fe ff ff       	call   31d <putc>
        ap++;
 4db:	83 c7 04             	add    $0x4,%edi
 4de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4e1:	be 00 00 00 00       	mov    $0x0,%esi
 4e6:	e9 03 ff ff ff       	jmp    3ee <printf+0x2c>
        putc(fd, c);
 4eb:	89 fa                	mov    %edi,%edx
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	e8 28 fe ff ff       	call   31d <putc>
      state = 0;
 4f5:	be 00 00 00 00       	mov    $0x0,%esi
 4fa:	e9 ef fe ff ff       	jmp    3ee <printf+0x2c>
        putc(fd, '%');
 4ff:	ba 25 00 00 00       	mov    $0x25,%edx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	e8 11 fe ff ff       	call   31d <putc>
        putc(fd, c);
 50c:	89 fa                	mov    %edi,%edx
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	e8 07 fe ff ff       	call   31d <putc>
      state = 0;
 516:	be 00 00 00 00       	mov    $0x0,%esi
 51b:	e9 ce fe ff ff       	jmp    3ee <printf+0x2c>
    }
  }
}
 520:	8d 65 f4             	lea    -0xc(%ebp),%esp
 523:	5b                   	pop    %ebx
 524:	5e                   	pop    %esi
 525:	5f                   	pop    %edi
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    

00000528 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	53                   	push   %ebx
 52e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 531:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 534:	a1 7c 09 00 00       	mov    0x97c,%eax
 539:	eb 02                	jmp    53d <free+0x15>
 53b:	89 d0                	mov    %edx,%eax
 53d:	39 c8                	cmp    %ecx,%eax
 53f:	73 04                	jae    545 <free+0x1d>
 541:	39 08                	cmp    %ecx,(%eax)
 543:	77 12                	ja     557 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 545:	8b 10                	mov    (%eax),%edx
 547:	39 c2                	cmp    %eax,%edx
 549:	77 f0                	ja     53b <free+0x13>
 54b:	39 c8                	cmp    %ecx,%eax
 54d:	72 08                	jb     557 <free+0x2f>
 54f:	39 ca                	cmp    %ecx,%edx
 551:	77 04                	ja     557 <free+0x2f>
 553:	89 d0                	mov    %edx,%eax
 555:	eb e6                	jmp    53d <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 557:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55d:	8b 10                	mov    (%eax),%edx
 55f:	39 d7                	cmp    %edx,%edi
 561:	74 19                	je     57c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 563:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 566:	8b 50 04             	mov    0x4(%eax),%edx
 569:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56c:	39 ce                	cmp    %ecx,%esi
 56e:	74 1b                	je     58b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 570:	89 08                	mov    %ecx,(%eax)
  freep = p;
 572:	a3 7c 09 00 00       	mov    %eax,0x97c
}
 577:	5b                   	pop    %ebx
 578:	5e                   	pop    %esi
 579:	5f                   	pop    %edi
 57a:	5d                   	pop    %ebp
 57b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 57c:	03 72 04             	add    0x4(%edx),%esi
 57f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 582:	8b 10                	mov    (%eax),%edx
 584:	8b 12                	mov    (%edx),%edx
 586:	89 53 f8             	mov    %edx,-0x8(%ebx)
 589:	eb db                	jmp    566 <free+0x3e>
    p->s.size += bp->s.size;
 58b:	03 53 fc             	add    -0x4(%ebx),%edx
 58e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 591:	8b 53 f8             	mov    -0x8(%ebx),%edx
 594:	89 10                	mov    %edx,(%eax)
 596:	eb da                	jmp    572 <free+0x4a>

00000598 <morecore>:

static Header*
morecore(uint nu)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	53                   	push   %ebx
 59c:	83 ec 04             	sub    $0x4,%esp
 59f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5a1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5a6:	77 05                	ja     5ad <morecore+0x15>
    nu = 4096;
 5a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5ad:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5b4:	83 ec 0c             	sub    $0xc,%esp
 5b7:	50                   	push   %eax
 5b8:	e8 c8 fc ff ff       	call   285 <sbrk>
  if(p == (char*)-1)
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c3:	74 1c                	je     5e1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5c5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5c8:	83 c0 08             	add    $0x8,%eax
 5cb:	83 ec 0c             	sub    $0xc,%esp
 5ce:	50                   	push   %eax
 5cf:	e8 54 ff ff ff       	call   528 <free>
  return freep;
 5d4:	a1 7c 09 00 00       	mov    0x97c,%eax
 5d9:	83 c4 10             	add    $0x10,%esp
}
 5dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5df:	c9                   	leave  
 5e0:	c3                   	ret    
    return 0;
 5e1:	b8 00 00 00 00       	mov    $0x0,%eax
 5e6:	eb f4                	jmp    5dc <morecore+0x44>

000005e8 <malloc>:

void*
malloc(uint nbytes)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	53                   	push   %ebx
 5ec:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	8d 58 07             	lea    0x7(%eax),%ebx
 5f5:	c1 eb 03             	shr    $0x3,%ebx
 5f8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5fb:	8b 0d 7c 09 00 00    	mov    0x97c,%ecx
 601:	85 c9                	test   %ecx,%ecx
 603:	74 04                	je     609 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 605:	8b 01                	mov    (%ecx),%eax
 607:	eb 4a                	jmp    653 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 609:	c7 05 7c 09 00 00 80 	movl   $0x980,0x97c
 610:	09 00 00 
 613:	c7 05 80 09 00 00 80 	movl   $0x980,0x980
 61a:	09 00 00 
    base.s.size = 0;
 61d:	c7 05 84 09 00 00 00 	movl   $0x0,0x984
 624:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 627:	b9 80 09 00 00       	mov    $0x980,%ecx
 62c:	eb d7                	jmp    605 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 62e:	74 19                	je     649 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 630:	29 da                	sub    %ebx,%edx
 632:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 635:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 638:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 63b:	89 0d 7c 09 00 00    	mov    %ecx,0x97c
      return (void*)(p + 1);
 641:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 647:	c9                   	leave  
 648:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 649:	8b 10                	mov    (%eax),%edx
 64b:	89 11                	mov    %edx,(%ecx)
 64d:	eb ec                	jmp    63b <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64f:	89 c1                	mov    %eax,%ecx
 651:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 653:	8b 50 04             	mov    0x4(%eax),%edx
 656:	39 da                	cmp    %ebx,%edx
 658:	73 d4                	jae    62e <malloc+0x46>
    if(p == freep)
 65a:	39 05 7c 09 00 00    	cmp    %eax,0x97c
 660:	75 ed                	jne    64f <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 662:	89 d8                	mov    %ebx,%eax
 664:	e8 2f ff ff ff       	call   598 <morecore>
 669:	85 c0                	test   %eax,%eax
 66b:	75 e2                	jne    64f <malloc+0x67>
 66d:	eb d5                	jmp    644 <malloc+0x5c>
