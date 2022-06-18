
_test-multiprocess:     file format elf32-i386


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
    init_counter_1();
  13:	e8 34 03 00 00       	call   34c <init_counter_1>
    int ret1 = fork(); // creates child process 1
  18:	e8 37 02 00 00       	call   254 <fork>
  1d:	89 c6                	mov    %eax,%esi
               to be 20000.
    */

    // Hint: Implement one locking system for this counter variable
    
    for(int i=0; i<10000; i++){
  1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  24:	eb 17                	jmp    3d <main+0x3d>
        update_cnt_1(display_count()+1);
  26:	e8 19 03 00 00       	call   344 <display_count>
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	83 c0 01             	add    $0x1,%eax
  31:	50                   	push   %eax
  32:	e8 1d 03 00 00       	call   354 <update_cnt_1>
    for(int i=0; i<10000; i++){
  37:	83 c3 01             	add    $0x1,%ebx
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  43:	7e e1                	jle    26 <main+0x26>
    }

    if(ret1 == 0){
  45:	85 f6                	test   %esi,%esi
  47:	75 55                	jne    9e <main+0x9e>
        // Hint: Implement one locking system for this counter variable

        init_counter_2();
  49:	e8 16 03 00 00       	call   364 <init_counter_2>
        int ret2 = fork(); //creates child process 2
  4e:	e8 01 02 00 00       	call   254 <fork>
  53:	89 c3                	mov    %eax,%ebx

        for(int j=0; j<10000; j++){
  55:	81 fe 0f 27 00 00    	cmp    $0x270f,%esi
  5b:	7f 19                	jg     76 <main+0x76>
            update_cnt_2(display_count_2()+1);
  5d:	e8 12 03 00 00       	call   374 <display_count_2>
  62:	83 ec 0c             	sub    $0xc,%esp
  65:	83 c0 01             	add    $0x1,%eax
  68:	50                   	push   %eax
  69:	e8 fe 02 00 00       	call   36c <update_cnt_2>
        for(int j=0; j<10000; j++){
  6e:	83 c6 01             	add    $0x1,%esi
  71:	83 c4 10             	add    $0x10,%esp
  74:	eb df                	jmp    55 <main+0x55>
        }

        if(ret2==0)
  76:	85 db                	test   %ebx,%ebx
  78:	75 05                	jne    7f <main+0x7f>
            exit();
  7a:	e8 dd 01 00 00       	call   25c <exit>
        else{
            wait();
  7f:	e8 e0 01 00 00       	call   264 <wait>
            printf(1, "counter_2: %d\n", display_count_2());
  84:	e8 eb 02 00 00       	call   374 <display_count_2>
  89:	83 ec 04             	sub    $0x4,%esp
  8c:	50                   	push   %eax
  8d:	68 f0 06 00 00       	push   $0x6f0
  92:	6a 01                	push   $0x1
  94:	e8 a8 03 00 00       	call   441 <printf>
            exit();
  99:	e8 be 01 00 00       	call   25c <exit>
        }
    }
    else{
        wait();
  9e:	e8 c1 01 00 00       	call   264 <wait>
        printf(1, "counter_1: %d\n", display_count_1());
  a3:	e8 b4 02 00 00       	call   35c <display_count_1>
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	50                   	push   %eax
  ac:	68 ff 06 00 00       	push   $0x6ff
  b1:	6a 01                	push   $0x1
  b3:	e8 89 03 00 00       	call   441 <printf>
        exit();
  b8:	e8 9f 01 00 00       	call   25c <exit>

000000bd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	56                   	push   %esi
  c1:	53                   	push   %ebx
  c2:	8b 75 08             	mov    0x8(%ebp),%esi
  c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c8:	89 f0                	mov    %esi,%eax
  ca:	89 d1                	mov    %edx,%ecx
  cc:	83 c2 01             	add    $0x1,%edx
  cf:	89 c3                	mov    %eax,%ebx
  d1:	83 c0 01             	add    $0x1,%eax
  d4:	0f b6 09             	movzbl (%ecx),%ecx
  d7:	88 0b                	mov    %cl,(%ebx)
  d9:	84 c9                	test   %cl,%cl
  db:	75 ed                	jne    ca <strcpy+0xd>
    ;
  return os;
}
  dd:	89 f0                	mov    %esi,%eax
  df:	5b                   	pop    %ebx
  e0:	5e                   	pop    %esi
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    

000000e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ec:	eb 06                	jmp    f4 <strcmp+0x11>
    p++, q++;
  ee:	83 c1 01             	add    $0x1,%ecx
  f1:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  f4:	0f b6 01             	movzbl (%ecx),%eax
  f7:	84 c0                	test   %al,%al
  f9:	74 04                	je     ff <strcmp+0x1c>
  fb:	3a 02                	cmp    (%edx),%al
  fd:	74 ef                	je     ee <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  ff:	0f b6 c0             	movzbl %al,%eax
 102:	0f b6 12             	movzbl (%edx),%edx
 105:	29 d0                	sub    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(const char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10f:	b8 00 00 00 00       	mov    $0x0,%eax
 114:	eb 03                	jmp    119 <strlen+0x10>
 116:	83 c0 01             	add    $0x1,%eax
 119:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 11d:	75 f7                	jne    116 <strlen+0xd>
    ;
  return n;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	57                   	push   %edi
 125:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 128:	89 d7                	mov    %edx,%edi
 12a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 133:	89 d0                	mov    %edx,%eax
 135:	8b 7d fc             	mov    -0x4(%ebp),%edi
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 144:	eb 03                	jmp    149 <strchr+0xf>
 146:	83 c0 01             	add    $0x1,%eax
 149:	0f b6 10             	movzbl (%eax),%edx
 14c:	84 d2                	test   %dl,%dl
 14e:	74 06                	je     156 <strchr+0x1c>
    if(*s == c)
 150:	38 ca                	cmp    %cl,%dl
 152:	75 f2                	jne    146 <strchr+0xc>
 154:	eb 05                	jmp    15b <strchr+0x21>
      return (char*)s;
  return 0;
 156:	b8 00 00 00 00       	mov    $0x0,%eax
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <gets>:

char*
gets(char *buf, int max)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	56                   	push   %esi
 162:	53                   	push   %ebx
 163:	83 ec 1c             	sub    $0x1c,%esp
 166:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 169:	bb 00 00 00 00       	mov    $0x0,%ebx
 16e:	89 de                	mov    %ebx,%esi
 170:	83 c3 01             	add    $0x1,%ebx
 173:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 176:	7d 2e                	jge    1a6 <gets+0x49>
    cc = read(0, &c, 1);
 178:	83 ec 04             	sub    $0x4,%esp
 17b:	6a 01                	push   $0x1
 17d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 180:	50                   	push   %eax
 181:	6a 00                	push   $0x0
 183:	e8 ec 00 00 00       	call   274 <read>
    if(cc < 1)
 188:	83 c4 10             	add    $0x10,%esp
 18b:	85 c0                	test   %eax,%eax
 18d:	7e 17                	jle    1a6 <gets+0x49>
      break;
    buf[i++] = c;
 18f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 193:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 196:	3c 0a                	cmp    $0xa,%al
 198:	0f 94 c2             	sete   %dl
 19b:	3c 0d                	cmp    $0xd,%al
 19d:	0f 94 c0             	sete   %al
 1a0:	08 c2                	or     %al,%dl
 1a2:	74 ca                	je     16e <gets+0x11>
    buf[i++] = c;
 1a4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1a6:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1aa:	89 f8                	mov    %edi,%eax
 1ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1af:	5b                   	pop    %ebx
 1b0:	5e                   	pop    %esi
 1b1:	5f                   	pop    %edi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	56                   	push   %esi
 1b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	6a 00                	push   $0x0
 1be:	ff 75 08             	push   0x8(%ebp)
 1c1:	e8 d6 00 00 00       	call   29c <open>
  if(fd < 0)
 1c6:	83 c4 10             	add    $0x10,%esp
 1c9:	85 c0                	test   %eax,%eax
 1cb:	78 24                	js     1f1 <stat+0x3d>
 1cd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1cf:	83 ec 08             	sub    $0x8,%esp
 1d2:	ff 75 0c             	push   0xc(%ebp)
 1d5:	50                   	push   %eax
 1d6:	e8 d9 00 00 00       	call   2b4 <fstat>
 1db:	89 c6                	mov    %eax,%esi
  close(fd);
 1dd:	89 1c 24             	mov    %ebx,(%esp)
 1e0:	e8 9f 00 00 00       	call   284 <close>
  return r;
 1e5:	83 c4 10             	add    $0x10,%esp
}
 1e8:	89 f0                	mov    %esi,%eax
 1ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
    return -1;
 1f1:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f6:	eb f0                	jmp    1e8 <stat+0x34>

000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	53                   	push   %ebx
 1fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1ff:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 204:	eb 10                	jmp    216 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 206:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 209:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 20c:	83 c1 01             	add    $0x1,%ecx
 20f:	0f be c0             	movsbl %al,%eax
 212:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 216:	0f b6 01             	movzbl (%ecx),%eax
 219:	8d 58 d0             	lea    -0x30(%eax),%ebx
 21c:	80 fb 09             	cmp    $0x9,%bl
 21f:	76 e5                	jbe    206 <atoi+0xe>
  return n;
}
 221:	89 d0                	mov    %edx,%eax
 223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
 22d:	8b 75 08             	mov    0x8(%ebp),%esi
 230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 233:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 236:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 238:	eb 0d                	jmp    247 <memmove+0x1f>
    *dst++ = *src++;
 23a:	0f b6 01             	movzbl (%ecx),%eax
 23d:	88 02                	mov    %al,(%edx)
 23f:	8d 49 01             	lea    0x1(%ecx),%ecx
 242:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 245:	89 d8                	mov    %ebx,%eax
 247:	8d 58 ff             	lea    -0x1(%eax),%ebx
 24a:	85 c0                	test   %eax,%eax
 24c:	7f ec                	jg     23a <memmove+0x12>
  return vdst;
}
 24e:	89 f0                	mov    %esi,%eax
 250:	5b                   	pop    %ebx
 251:	5e                   	pop    %esi
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    

00000254 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 254:	b8 01 00 00 00       	mov    $0x1,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <exit>:
SYSCALL(exit)
 25c:	b8 02 00 00 00       	mov    $0x2,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <wait>:
SYSCALL(wait)
 264:	b8 03 00 00 00       	mov    $0x3,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <pipe>:
SYSCALL(pipe)
 26c:	b8 04 00 00 00       	mov    $0x4,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <read>:
SYSCALL(read)
 274:	b8 05 00 00 00       	mov    $0x5,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <write>:
SYSCALL(write)
 27c:	b8 10 00 00 00       	mov    $0x10,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <close>:
SYSCALL(close)
 284:	b8 15 00 00 00       	mov    $0x15,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <kill>:
SYSCALL(kill)
 28c:	b8 06 00 00 00       	mov    $0x6,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <exec>:
SYSCALL(exec)
 294:	b8 07 00 00 00       	mov    $0x7,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <open>:
SYSCALL(open)
 29c:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <mknod>:
SYSCALL(mknod)
 2a4:	b8 11 00 00 00       	mov    $0x11,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <unlink>:
SYSCALL(unlink)
 2ac:	b8 12 00 00 00       	mov    $0x12,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <fstat>:
SYSCALL(fstat)
 2b4:	b8 08 00 00 00       	mov    $0x8,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <link>:
SYSCALL(link)
 2bc:	b8 13 00 00 00       	mov    $0x13,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <mkdir>:
SYSCALL(mkdir)
 2c4:	b8 14 00 00 00       	mov    $0x14,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <chdir>:
SYSCALL(chdir)
 2cc:	b8 09 00 00 00       	mov    $0x9,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <dup>:
SYSCALL(dup)
 2d4:	b8 0a 00 00 00       	mov    $0xa,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <getpid>:
SYSCALL(getpid)
 2dc:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <sbrk>:
SYSCALL(sbrk)
 2e4:	b8 0c 00 00 00       	mov    $0xc,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <sleep>:
SYSCALL(sleep)
 2ec:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <uptime>:
SYSCALL(uptime)
 2f4:	b8 0e 00 00 00       	mov    $0xe,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <hello>:
SYSCALL(hello)
 2fc:	b8 16 00 00 00       	mov    $0x16,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <helloYou>:
SYSCALL(helloYou)
 304:	b8 17 00 00 00       	mov    $0x17,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <getppid>:
SYSCALL(getppid)
 30c:	b8 18 00 00 00       	mov    $0x18,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <get_siblings_info>:
SYSCALL(get_siblings_info)
 314:	b8 19 00 00 00       	mov    $0x19,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <signalProcess>:
SYSCALL(signalProcess)
 31c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <numvp>:
SYSCALL(numvp)
 324:	b8 1b 00 00 00       	mov    $0x1b,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <numpp>:
SYSCALL(numpp)
 32c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <init_counter>:

SYSCALL(init_counter)
 334:	b8 1d 00 00 00       	mov    $0x1d,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <update_cnt>:
SYSCALL(update_cnt)
 33c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <display_count>:
SYSCALL(display_count)
 344:	b8 1f 00 00 00       	mov    $0x1f,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <init_counter_1>:
SYSCALL(init_counter_1)
 34c:	b8 20 00 00 00       	mov    $0x20,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <update_cnt_1>:
SYSCALL(update_cnt_1)
 354:	b8 21 00 00 00       	mov    $0x21,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <display_count_1>:
SYSCALL(display_count_1)
 35c:	b8 22 00 00 00       	mov    $0x22,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <init_counter_2>:
SYSCALL(init_counter_2)
 364:	b8 23 00 00 00       	mov    $0x23,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <update_cnt_2>:
SYSCALL(update_cnt_2)
 36c:	b8 24 00 00 00       	mov    $0x24,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <display_count_2>:
SYSCALL(display_count_2)
 374:	b8 25 00 00 00       	mov    $0x25,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <init_mylock>:
SYSCALL(init_mylock)
 37c:	b8 26 00 00 00       	mov    $0x26,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <acquire_mylock>:
SYSCALL(acquire_mylock)
 384:	b8 27 00 00 00       	mov    $0x27,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <release_mylock>:
SYSCALL(release_mylock)
 38c:	b8 28 00 00 00       	mov    $0x28,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <holding_mylock>:
 394:	b8 29 00 00 00       	mov    $0x29,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 1c             	sub    $0x1c,%esp
 3a2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3a5:	6a 01                	push   $0x1
 3a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3aa:	52                   	push   %edx
 3ab:	50                   	push   %eax
 3ac:	e8 cb fe ff ff       	call   27c <write>
}
 3b1:	83 c4 10             	add    $0x10,%esp
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	57                   	push   %edi
 3ba:	56                   	push   %esi
 3bb:	53                   	push   %ebx
 3bc:	83 ec 2c             	sub    $0x2c,%esp
 3bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ca:	0f 95 c1             	setne  %cl
 3cd:	c1 ea 1f             	shr    $0x1f,%edx
 3d0:	84 d1                	test   %dl,%cl
 3d2:	74 44                	je     418 <printint+0x62>
    neg = 1;
    x = -xx;
 3d4:	f7 d8                	neg    %eax
 3d6:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3d8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3df:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3e4:	89 c8                	mov    %ecx,%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 f6                	div    %esi
 3ed:	89 df                	mov    %ebx,%edi
 3ef:	83 c3 01             	add    $0x1,%ebx
 3f2:	0f b6 92 70 07 00 00 	movzbl 0x770(%edx),%edx
 3f9:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3fd:	89 ca                	mov    %ecx,%edx
 3ff:	89 c1                	mov    %eax,%ecx
 401:	39 d6                	cmp    %edx,%esi
 403:	76 df                	jbe    3e4 <printint+0x2e>
  if(neg)
 405:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 409:	74 31                	je     43c <printint+0x86>
    buf[i++] = '-';
 40b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 410:	8d 5f 02             	lea    0x2(%edi),%ebx
 413:	8b 75 d0             	mov    -0x30(%ebp),%esi
 416:	eb 17                	jmp    42f <printint+0x79>
    x = xx;
 418:	89 c1                	mov    %eax,%ecx
  neg = 0;
 41a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 421:	eb bc                	jmp    3df <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 423:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 428:	89 f0                	mov    %esi,%eax
 42a:	e8 6d ff ff ff       	call   39c <putc>
  while(--i >= 0)
 42f:	83 eb 01             	sub    $0x1,%ebx
 432:	79 ef                	jns    423 <printint+0x6d>
}
 434:	83 c4 2c             	add    $0x2c,%esp
 437:	5b                   	pop    %ebx
 438:	5e                   	pop    %esi
 439:	5f                   	pop    %edi
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    
 43c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 43f:	eb ee                	jmp    42f <printint+0x79>

00000441 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	57                   	push   %edi
 445:	56                   	push   %esi
 446:	53                   	push   %ebx
 447:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 44a:	8d 45 10             	lea    0x10(%ebp),%eax
 44d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 450:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 455:	bb 00 00 00 00       	mov    $0x0,%ebx
 45a:	eb 14                	jmp    470 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 45c:	89 fa                	mov    %edi,%edx
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	e8 36 ff ff ff       	call   39c <putc>
 466:	eb 05                	jmp    46d <printf+0x2c>
      }
    } else if(state == '%'){
 468:	83 fe 25             	cmp    $0x25,%esi
 46b:	74 25                	je     492 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 46d:	83 c3 01             	add    $0x1,%ebx
 470:	8b 45 0c             	mov    0xc(%ebp),%eax
 473:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 477:	84 c0                	test   %al,%al
 479:	0f 84 20 01 00 00    	je     59f <printf+0x15e>
    c = fmt[i] & 0xff;
 47f:	0f be f8             	movsbl %al,%edi
 482:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 485:	85 f6                	test   %esi,%esi
 487:	75 df                	jne    468 <printf+0x27>
      if(c == '%'){
 489:	83 f8 25             	cmp    $0x25,%eax
 48c:	75 ce                	jne    45c <printf+0x1b>
        state = '%';
 48e:	89 c6                	mov    %eax,%esi
 490:	eb db                	jmp    46d <printf+0x2c>
      if(c == 'd'){
 492:	83 f8 25             	cmp    $0x25,%eax
 495:	0f 84 cf 00 00 00    	je     56a <printf+0x129>
 49b:	0f 8c dd 00 00 00    	jl     57e <printf+0x13d>
 4a1:	83 f8 78             	cmp    $0x78,%eax
 4a4:	0f 8f d4 00 00 00    	jg     57e <printf+0x13d>
 4aa:	83 f8 63             	cmp    $0x63,%eax
 4ad:	0f 8c cb 00 00 00    	jl     57e <printf+0x13d>
 4b3:	83 e8 63             	sub    $0x63,%eax
 4b6:	83 f8 15             	cmp    $0x15,%eax
 4b9:	0f 87 bf 00 00 00    	ja     57e <printf+0x13d>
 4bf:	ff 24 85 18 07 00 00 	jmp    *0x718(,%eax,4)
        printint(fd, *ap, 10, 1);
 4c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c9:	8b 17                	mov    (%edi),%edx
 4cb:	83 ec 0c             	sub    $0xc,%esp
 4ce:	6a 01                	push   $0x1
 4d0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	e8 d9 fe ff ff       	call   3b6 <printint>
        ap++;
 4dd:	83 c7 04             	add    $0x4,%edi
 4e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e6:	be 00 00 00 00       	mov    $0x0,%esi
 4eb:	eb 80                	jmp    46d <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f0:	8b 17                	mov    (%edi),%edx
 4f2:	83 ec 0c             	sub    $0xc,%esp
 4f5:	6a 00                	push   $0x0
 4f7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	e8 b2 fe ff ff       	call   3b6 <printint>
        ap++;
 504:	83 c7 04             	add    $0x4,%edi
 507:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 50a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50d:	be 00 00 00 00       	mov    $0x0,%esi
 512:	e9 56 ff ff ff       	jmp    46d <printf+0x2c>
        s = (char*)*ap;
 517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51a:	8b 30                	mov    (%eax),%esi
        ap++;
 51c:	83 c0 04             	add    $0x4,%eax
 51f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 522:	85 f6                	test   %esi,%esi
 524:	75 15                	jne    53b <printf+0xfa>
          s = "(null)";
 526:	be 0e 07 00 00       	mov    $0x70e,%esi
 52b:	eb 0e                	jmp    53b <printf+0xfa>
          putc(fd, *s);
 52d:	0f be d2             	movsbl %dl,%edx
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	e8 64 fe ff ff       	call   39c <putc>
          s++;
 538:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 53b:	0f b6 16             	movzbl (%esi),%edx
 53e:	84 d2                	test   %dl,%dl
 540:	75 eb                	jne    52d <printf+0xec>
      state = 0;
 542:	be 00 00 00 00       	mov    $0x0,%esi
 547:	e9 21 ff ff ff       	jmp    46d <printf+0x2c>
        putc(fd, *ap);
 54c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54f:	0f be 17             	movsbl (%edi),%edx
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	e8 42 fe ff ff       	call   39c <putc>
        ap++;
 55a:	83 c7 04             	add    $0x4,%edi
 55d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 560:	be 00 00 00 00       	mov    $0x0,%esi
 565:	e9 03 ff ff ff       	jmp    46d <printf+0x2c>
        putc(fd, c);
 56a:	89 fa                	mov    %edi,%edx
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	e8 28 fe ff ff       	call   39c <putc>
      state = 0;
 574:	be 00 00 00 00       	mov    $0x0,%esi
 579:	e9 ef fe ff ff       	jmp    46d <printf+0x2c>
        putc(fd, '%');
 57e:	ba 25 00 00 00       	mov    $0x25,%edx
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	e8 11 fe ff ff       	call   39c <putc>
        putc(fd, c);
 58b:	89 fa                	mov    %edi,%edx
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	e8 07 fe ff ff       	call   39c <putc>
      state = 0;
 595:	be 00 00 00 00       	mov    $0x0,%esi
 59a:	e9 ce fe ff ff       	jmp    46d <printf+0x2c>
    }
  }
}
 59f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    

000005a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp
 5aa:	57                   	push   %edi
 5ab:	56                   	push   %esi
 5ac:	53                   	push   %ebx
 5ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	a1 18 0a 00 00       	mov    0xa18,%eax
 5b8:	eb 02                	jmp    5bc <free+0x15>
 5ba:	89 d0                	mov    %edx,%eax
 5bc:	39 c8                	cmp    %ecx,%eax
 5be:	73 04                	jae    5c4 <free+0x1d>
 5c0:	39 08                	cmp    %ecx,(%eax)
 5c2:	77 12                	ja     5d6 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	39 c2                	cmp    %eax,%edx
 5c8:	77 f0                	ja     5ba <free+0x13>
 5ca:	39 c8                	cmp    %ecx,%eax
 5cc:	72 08                	jb     5d6 <free+0x2f>
 5ce:	39 ca                	cmp    %ecx,%edx
 5d0:	77 04                	ja     5d6 <free+0x2f>
 5d2:	89 d0                	mov    %edx,%eax
 5d4:	eb e6                	jmp    5bc <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5dc:	8b 10                	mov    (%eax),%edx
 5de:	39 d7                	cmp    %edx,%edi
 5e0:	74 19                	je     5fb <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e5:	8b 50 04             	mov    0x4(%eax),%edx
 5e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5eb:	39 ce                	cmp    %ecx,%esi
 5ed:	74 1b                	je     60a <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5f1:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 5f6:	5b                   	pop    %ebx
 5f7:	5e                   	pop    %esi
 5f8:	5f                   	pop    %edi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5fb:	03 72 04             	add    0x4(%edx),%esi
 5fe:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 601:	8b 10                	mov    (%eax),%edx
 603:	8b 12                	mov    (%edx),%edx
 605:	89 53 f8             	mov    %edx,-0x8(%ebx)
 608:	eb db                	jmp    5e5 <free+0x3e>
    p->s.size += bp->s.size;
 60a:	03 53 fc             	add    -0x4(%ebx),%edx
 60d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 610:	8b 53 f8             	mov    -0x8(%ebx),%edx
 613:	89 10                	mov    %edx,(%eax)
 615:	eb da                	jmp    5f1 <free+0x4a>

00000617 <morecore>:

static Header*
morecore(uint nu)
{
 617:	55                   	push   %ebp
 618:	89 e5                	mov    %esp,%ebp
 61a:	53                   	push   %ebx
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 620:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 625:	77 05                	ja     62c <morecore+0x15>
    nu = 4096;
 627:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 62c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	50                   	push   %eax
 637:	e8 a8 fc ff ff       	call   2e4 <sbrk>
  if(p == (char*)-1)
 63c:	83 c4 10             	add    $0x10,%esp
 63f:	83 f8 ff             	cmp    $0xffffffff,%eax
 642:	74 1c                	je     660 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 644:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 647:	83 c0 08             	add    $0x8,%eax
 64a:	83 ec 0c             	sub    $0xc,%esp
 64d:	50                   	push   %eax
 64e:	e8 54 ff ff ff       	call   5a7 <free>
  return freep;
 653:	a1 18 0a 00 00       	mov    0xa18,%eax
 658:	83 c4 10             	add    $0x10,%esp
}
 65b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 65e:	c9                   	leave  
 65f:	c3                   	ret    
    return 0;
 660:	b8 00 00 00 00       	mov    $0x0,%eax
 665:	eb f4                	jmp    65b <morecore+0x44>

00000667 <malloc>:

void*
malloc(uint nbytes)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	53                   	push   %ebx
 66b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	8d 58 07             	lea    0x7(%eax),%ebx
 674:	c1 eb 03             	shr    $0x3,%ebx
 677:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67a:	8b 0d 18 0a 00 00    	mov    0xa18,%ecx
 680:	85 c9                	test   %ecx,%ecx
 682:	74 04                	je     688 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 684:	8b 01                	mov    (%ecx),%eax
 686:	eb 4a                	jmp    6d2 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 688:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 68f:	0a 00 00 
 692:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 699:	0a 00 00 
    base.s.size = 0;
 69c:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 6a3:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6a6:	b9 1c 0a 00 00       	mov    $0xa1c,%ecx
 6ab:	eb d7                	jmp    684 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6ad:	74 19                	je     6c8 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6af:	29 da                	sub    %ebx,%edx
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6b4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6b7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6ba:	89 0d 18 0a 00 00    	mov    %ecx,0xa18
      return (void*)(p + 1);
 6c0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c6:	c9                   	leave  
 6c7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	89 11                	mov    %edx,(%ecx)
 6cc:	eb ec                	jmp    6ba <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ce:	89 c1                	mov    %eax,%ecx
 6d0:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6d2:	8b 50 04             	mov    0x4(%eax),%edx
 6d5:	39 da                	cmp    %ebx,%edx
 6d7:	73 d4                	jae    6ad <malloc+0x46>
    if(p == freep)
 6d9:	39 05 18 0a 00 00    	cmp    %eax,0xa18
 6df:	75 ed                	jne    6ce <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6e1:	89 d8                	mov    %ebx,%eax
 6e3:	e8 2f ff ff ff       	call   617 <morecore>
 6e8:	85 c0                	test   %eax,%eax
 6ea:	75 e2                	jne    6ce <malloc+0x67>
 6ec:	eb d5                	jmp    6c3 <malloc+0x5c>
