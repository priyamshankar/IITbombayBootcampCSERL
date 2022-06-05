
_signal_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define SIGNAL_PAUSE "PAUSE"
#define SIGNAL_CONTINUE "CONTINUE"
#define SIGNAL_KILL "KILL"

int main(int argc, const char **argv) 
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
	int ret = fork();
   f:	e8 62 02 00 00       	call   276 <fork>
  14:	89 c3                	mov    %eax,%ebx
	if(ret == 0) 
  16:	85 c0                	test   %eax,%eax
  18:	0f 84 b4 00 00 00    	je     d2 <main+0xd2>
		}

		exit();
	}

	sleep(5e2);
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	68 f4 01 00 00       	push   $0x1f4
  26:	e8 e3 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending pause signal to child \n");
  2b:	83 c4 08             	add    $0x8,%esp
  2e:	68 d0 06 00 00       	push   $0x6d0
  33:	6a 01                	push   $0x1
  35:	e8 c1 03 00 00       	call   3fb <printf>
	signalProcess(ret, SIGNAL_PAUSE);
  3a:	83 c4 08             	add    $0x8,%esp
  3d:	68 bb 06 00 00       	push   $0x6bb
  42:	53                   	push   %ebx
  43:	e8 f6 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  48:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  4f:	e8 ba 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending continue signal to child \n");
  54:	83 c4 08             	add    $0x8,%esp
  57:	68 f8 06 00 00       	push   $0x6f8
  5c:	6a 01                	push   $0x1
  5e:	e8 98 03 00 00       	call   3fb <printf>
	signalProcess(ret, SIGNAL_CONTINUE);
  63:	83 c4 08             	add    $0x8,%esp
  66:	68 c1 06 00 00       	push   $0x6c1
  6b:	53                   	push   %ebx
  6c:	e8 cd 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  71:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  78:	e8 91 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending kill signal to child \n");
  7d:	83 c4 08             	add    $0x8,%esp
  80:	68 24 07 00 00       	push   $0x724
  85:	6a 01                	push   $0x1
  87:	e8 6f 03 00 00       	call   3fb <printf>
	signalProcess(ret, SIGNAL_KILL);
  8c:	83 c4 08             	add    $0x8,%esp
  8f:	68 ca 06 00 00       	push   $0x6ca
  94:	53                   	push   %ebx
  95:	e8 a4 02 00 00       	call   33e <signalProcess>
	
	wait();
  9a:	e8 e7 01 00 00       	call   286 <wait>
	printf(1, "parent: child has terminated \n");
  9f:	83 c4 08             	add    $0x8,%esp
  a2:	68 4c 07 00 00       	push   $0x74c
  a7:	6a 01                	push   $0x1
  a9:	e8 4d 03 00 00       	call   3fb <printf>
	exit();
  ae:	e8 cb 01 00 00       	call   27e <exit>
			sleep(5e1);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	6a 32                	push   $0x32
  b8:	e8 51 02 00 00       	call   30e <sleep>
			printf(1, "child: Not_paused\n");
  bd:	83 c4 08             	add    $0x8,%esp
  c0:	68 a8 06 00 00       	push   $0x6a8
  c5:	6a 01                	push   $0x1
  c7:	e8 2f 03 00 00       	call   3fb <printf>
		for (int i = 0; i < MAX_SZ; ++i)
  cc:	83 c3 01             	add    $0x1,%ebx
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	81 fb 3f 42 0f 00    	cmp    $0xf423f,%ebx
  d8:	7e d9                	jle    b3 <main+0xb3>
		exit();
  da:	e8 9f 01 00 00       	call   27e <exit>

000000df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	56                   	push   %esi
  e3:	53                   	push   %ebx
  e4:	8b 75 08             	mov    0x8(%ebp),%esi
  e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 f0                	mov    %esi,%eax
  ec:	89 d1                	mov    %edx,%ecx
  ee:	83 c2 01             	add    $0x1,%edx
  f1:	89 c3                	mov    %eax,%ebx
  f3:	83 c0 01             	add    $0x1,%eax
  f6:	0f b6 09             	movzbl (%ecx),%ecx
  f9:	88 0b                	mov    %cl,(%ebx)
  fb:	84 c9                	test   %cl,%cl
  fd:	75 ed                	jne    ec <strcpy+0xd>
    ;
  return os;
}
  ff:	89 f0                	mov    %esi,%eax
 101:	5b                   	pop    %ebx
 102:	5e                   	pop    %esi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10e:	eb 06                	jmp    116 <strcmp+0x11>
    p++, q++;
 110:	83 c1 01             	add    $0x1,%ecx
 113:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 116:	0f b6 01             	movzbl (%ecx),%eax
 119:	84 c0                	test   %al,%al
 11b:	74 04                	je     121 <strcmp+0x1c>
 11d:	3a 02                	cmp    (%edx),%al
 11f:	74 ef                	je     110 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 121:	0f b6 c0             	movzbl %al,%eax
 124:	0f b6 12             	movzbl (%edx),%edx
 127:	29 d0                	sub    %edx,%eax
}
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <strlen>:

uint
strlen(const char *s)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 131:	b8 00 00 00 00       	mov    $0x0,%eax
 136:	eb 03                	jmp    13b <strlen+0x10>
 138:	83 c0 01             	add    $0x1,%eax
 13b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 13f:	75 f7                	jne    138 <strlen+0xd>
    ;
  return n;
}
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <memset>:

void*
memset(void *dst, int c, uint n)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	57                   	push   %edi
 147:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 14a:	89 d7                	mov    %edx,%edi
 14c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	fc                   	cld    
 153:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 155:	89 d0                	mov    %edx,%eax
 157:	8b 7d fc             	mov    -0x4(%ebp),%edi
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <strchr>:

char*
strchr(const char *s, char c)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 166:	eb 03                	jmp    16b <strchr+0xf>
 168:	83 c0 01             	add    $0x1,%eax
 16b:	0f b6 10             	movzbl (%eax),%edx
 16e:	84 d2                	test   %dl,%dl
 170:	74 06                	je     178 <strchr+0x1c>
    if(*s == c)
 172:	38 ca                	cmp    %cl,%dl
 174:	75 f2                	jne    168 <strchr+0xc>
 176:	eb 05                	jmp    17d <strchr+0x21>
      return (char*)s;
  return 0;
 178:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    

0000017f <gets>:

char*
gets(char *buf, int max)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	57                   	push   %edi
 183:	56                   	push   %esi
 184:	53                   	push   %ebx
 185:	83 ec 1c             	sub    $0x1c,%esp
 188:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18b:	bb 00 00 00 00       	mov    $0x0,%ebx
 190:	89 de                	mov    %ebx,%esi
 192:	83 c3 01             	add    $0x1,%ebx
 195:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 198:	7d 2e                	jge    1c8 <gets+0x49>
    cc = read(0, &c, 1);
 19a:	83 ec 04             	sub    $0x4,%esp
 19d:	6a 01                	push   $0x1
 19f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1a2:	50                   	push   %eax
 1a3:	6a 00                	push   $0x0
 1a5:	e8 ec 00 00 00       	call   296 <read>
    if(cc < 1)
 1aa:	83 c4 10             	add    $0x10,%esp
 1ad:	85 c0                	test   %eax,%eax
 1af:	7e 17                	jle    1c8 <gets+0x49>
      break;
    buf[i++] = c;
 1b1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b5:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1b8:	3c 0a                	cmp    $0xa,%al
 1ba:	0f 94 c2             	sete   %dl
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	0f 94 c0             	sete   %al
 1c2:	08 c2                	or     %al,%dl
 1c4:	74 ca                	je     190 <gets+0x11>
    buf[i++] = c;
 1c6:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1c8:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1cc:	89 f8                	mov    %edi,%eax
 1ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d1:	5b                   	pop    %ebx
 1d2:	5e                   	pop    %esi
 1d3:	5f                   	pop    %edi
 1d4:	5d                   	pop    %ebp
 1d5:	c3                   	ret    

000001d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	56                   	push   %esi
 1da:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1db:	83 ec 08             	sub    $0x8,%esp
 1de:	6a 00                	push   $0x0
 1e0:	ff 75 08             	push   0x8(%ebp)
 1e3:	e8 d6 00 00 00       	call   2be <open>
  if(fd < 0)
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	85 c0                	test   %eax,%eax
 1ed:	78 24                	js     213 <stat+0x3d>
 1ef:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	ff 75 0c             	push   0xc(%ebp)
 1f7:	50                   	push   %eax
 1f8:	e8 d9 00 00 00       	call   2d6 <fstat>
 1fd:	89 c6                	mov    %eax,%esi
  close(fd);
 1ff:	89 1c 24             	mov    %ebx,(%esp)
 202:	e8 9f 00 00 00       	call   2a6 <close>
  return r;
 207:	83 c4 10             	add    $0x10,%esp
}
 20a:	89 f0                	mov    %esi,%eax
 20c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 20f:	5b                   	pop    %ebx
 210:	5e                   	pop    %esi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
    return -1;
 213:	be ff ff ff ff       	mov    $0xffffffff,%esi
 218:	eb f0                	jmp    20a <stat+0x34>

0000021a <atoi>:

int
atoi(const char *s)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	53                   	push   %ebx
 21e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 221:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 226:	eb 10                	jmp    238 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 228:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 22b:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 22e:	83 c1 01             	add    $0x1,%ecx
 231:	0f be c0             	movsbl %al,%eax
 234:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 238:	0f b6 01             	movzbl (%ecx),%eax
 23b:	8d 58 d0             	lea    -0x30(%eax),%ebx
 23e:	80 fb 09             	cmp    $0x9,%bl
 241:	76 e5                	jbe    228 <atoi+0xe>
  return n;
}
 243:	89 d0                	mov    %edx,%eax
 245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	56                   	push   %esi
 24e:	53                   	push   %ebx
 24f:	8b 75 08             	mov    0x8(%ebp),%esi
 252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 255:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 258:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 25a:	eb 0d                	jmp    269 <memmove+0x1f>
    *dst++ = *src++;
 25c:	0f b6 01             	movzbl (%ecx),%eax
 25f:	88 02                	mov    %al,(%edx)
 261:	8d 49 01             	lea    0x1(%ecx),%ecx
 264:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 267:	89 d8                	mov    %ebx,%eax
 269:	8d 58 ff             	lea    -0x1(%eax),%ebx
 26c:	85 c0                	test   %eax,%eax
 26e:	7f ec                	jg     25c <memmove+0x12>
  return vdst;
}
 270:	89 f0                	mov    %esi,%eax
 272:	5b                   	pop    %ebx
 273:	5e                   	pop    %esi
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    

00000276 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 276:	b8 01 00 00 00       	mov    $0x1,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <exit>:
SYSCALL(exit)
 27e:	b8 02 00 00 00       	mov    $0x2,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <wait>:
SYSCALL(wait)
 286:	b8 03 00 00 00       	mov    $0x3,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <pipe>:
SYSCALL(pipe)
 28e:	b8 04 00 00 00       	mov    $0x4,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <read>:
SYSCALL(read)
 296:	b8 05 00 00 00       	mov    $0x5,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <write>:
SYSCALL(write)
 29e:	b8 10 00 00 00       	mov    $0x10,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <close>:
SYSCALL(close)
 2a6:	b8 15 00 00 00       	mov    $0x15,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <kill>:
SYSCALL(kill)
 2ae:	b8 06 00 00 00       	mov    $0x6,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <exec>:
SYSCALL(exec)
 2b6:	b8 07 00 00 00       	mov    $0x7,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <open>:
SYSCALL(open)
 2be:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <mknod>:
SYSCALL(mknod)
 2c6:	b8 11 00 00 00       	mov    $0x11,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <unlink>:
SYSCALL(unlink)
 2ce:	b8 12 00 00 00       	mov    $0x12,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <fstat>:
SYSCALL(fstat)
 2d6:	b8 08 00 00 00       	mov    $0x8,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <link>:
SYSCALL(link)
 2de:	b8 13 00 00 00       	mov    $0x13,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <mkdir>:
SYSCALL(mkdir)
 2e6:	b8 14 00 00 00       	mov    $0x14,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <chdir>:
SYSCALL(chdir)
 2ee:	b8 09 00 00 00       	mov    $0x9,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <dup>:
SYSCALL(dup)
 2f6:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <getpid>:
SYSCALL(getpid)
 2fe:	b8 0b 00 00 00       	mov    $0xb,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <sbrk>:
SYSCALL(sbrk)
 306:	b8 0c 00 00 00       	mov    $0xc,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <sleep>:
SYSCALL(sleep)
 30e:	b8 0d 00 00 00       	mov    $0xd,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <uptime>:
SYSCALL(uptime)
 316:	b8 0e 00 00 00       	mov    $0xe,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <hello>:
SYSCALL(hello)
 31e:	b8 16 00 00 00       	mov    $0x16,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <helloYou>:
SYSCALL(helloYou)
 326:	b8 17 00 00 00       	mov    $0x17,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <getppid>:
SYSCALL(getppid)
 32e:	b8 18 00 00 00       	mov    $0x18,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <get_siblings_info>:
SYSCALL(get_siblings_info)
 336:	b8 19 00 00 00       	mov    $0x19,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <signalProcess>:
SYSCALL(signalProcess)
 33e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <numvp>:
SYSCALL(numvp)
 346:	b8 1b 00 00 00       	mov    $0x1b,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <numpp>:
 34e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 1c             	sub    $0x1c,%esp
 35c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 35f:	6a 01                	push   $0x1
 361:	8d 55 f4             	lea    -0xc(%ebp),%edx
 364:	52                   	push   %edx
 365:	50                   	push   %eax
 366:	e8 33 ff ff ff       	call   29e <write>
}
 36b:	83 c4 10             	add    $0x10,%esp
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
 376:	83 ec 2c             	sub    $0x2c,%esp
 379:	89 45 d0             	mov    %eax,-0x30(%ebp)
 37c:	89 d0                	mov    %edx,%eax
 37e:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 380:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 384:	0f 95 c1             	setne  %cl
 387:	c1 ea 1f             	shr    $0x1f,%edx
 38a:	84 d1                	test   %dl,%cl
 38c:	74 44                	je     3d2 <printint+0x62>
    neg = 1;
    x = -xx;
 38e:	f7 d8                	neg    %eax
 390:	89 c1                	mov    %eax,%ecx
    neg = 1;
 392:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 399:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 39e:	89 c8                	mov    %ecx,%eax
 3a0:	ba 00 00 00 00       	mov    $0x0,%edx
 3a5:	f7 f6                	div    %esi
 3a7:	89 df                	mov    %ebx,%edi
 3a9:	83 c3 01             	add    $0x1,%ebx
 3ac:	0f b6 92 cc 07 00 00 	movzbl 0x7cc(%edx),%edx
 3b3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3b7:	89 ca                	mov    %ecx,%edx
 3b9:	89 c1                	mov    %eax,%ecx
 3bb:	39 d6                	cmp    %edx,%esi
 3bd:	76 df                	jbe    39e <printint+0x2e>
  if(neg)
 3bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3c3:	74 31                	je     3f6 <printint+0x86>
    buf[i++] = '-';
 3c5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ca:	8d 5f 02             	lea    0x2(%edi),%ebx
 3cd:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3d0:	eb 17                	jmp    3e9 <printint+0x79>
    x = xx;
 3d2:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3d4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3db:	eb bc                	jmp    399 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3dd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e2:	89 f0                	mov    %esi,%eax
 3e4:	e8 6d ff ff ff       	call   356 <putc>
  while(--i >= 0)
 3e9:	83 eb 01             	sub    $0x1,%ebx
 3ec:	79 ef                	jns    3dd <printint+0x6d>
}
 3ee:	83 c4 2c             	add    $0x2c,%esp
 3f1:	5b                   	pop    %ebx
 3f2:	5e                   	pop    %esi
 3f3:	5f                   	pop    %edi
 3f4:	5d                   	pop    %ebp
 3f5:	c3                   	ret    
 3f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3f9:	eb ee                	jmp    3e9 <printint+0x79>

000003fb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	57                   	push   %edi
 3ff:	56                   	push   %esi
 400:	53                   	push   %ebx
 401:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 404:	8d 45 10             	lea    0x10(%ebp),%eax
 407:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 40a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 40f:	bb 00 00 00 00       	mov    $0x0,%ebx
 414:	eb 14                	jmp    42a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 416:	89 fa                	mov    %edi,%edx
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	e8 36 ff ff ff       	call   356 <putc>
 420:	eb 05                	jmp    427 <printf+0x2c>
      }
    } else if(state == '%'){
 422:	83 fe 25             	cmp    $0x25,%esi
 425:	74 25                	je     44c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 427:	83 c3 01             	add    $0x1,%ebx
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 431:	84 c0                	test   %al,%al
 433:	0f 84 20 01 00 00    	je     559 <printf+0x15e>
    c = fmt[i] & 0xff;
 439:	0f be f8             	movsbl %al,%edi
 43c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 43f:	85 f6                	test   %esi,%esi
 441:	75 df                	jne    422 <printf+0x27>
      if(c == '%'){
 443:	83 f8 25             	cmp    $0x25,%eax
 446:	75 ce                	jne    416 <printf+0x1b>
        state = '%';
 448:	89 c6                	mov    %eax,%esi
 44a:	eb db                	jmp    427 <printf+0x2c>
      if(c == 'd'){
 44c:	83 f8 25             	cmp    $0x25,%eax
 44f:	0f 84 cf 00 00 00    	je     524 <printf+0x129>
 455:	0f 8c dd 00 00 00    	jl     538 <printf+0x13d>
 45b:	83 f8 78             	cmp    $0x78,%eax
 45e:	0f 8f d4 00 00 00    	jg     538 <printf+0x13d>
 464:	83 f8 63             	cmp    $0x63,%eax
 467:	0f 8c cb 00 00 00    	jl     538 <printf+0x13d>
 46d:	83 e8 63             	sub    $0x63,%eax
 470:	83 f8 15             	cmp    $0x15,%eax
 473:	0f 87 bf 00 00 00    	ja     538 <printf+0x13d>
 479:	ff 24 85 74 07 00 00 	jmp    *0x774(,%eax,4)
        printint(fd, *ap, 10, 1);
 480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 483:	8b 17                	mov    (%edi),%edx
 485:	83 ec 0c             	sub    $0xc,%esp
 488:	6a 01                	push   $0x1
 48a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	e8 d9 fe ff ff       	call   370 <printint>
        ap++;
 497:	83 c7 04             	add    $0x4,%edi
 49a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 49d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a0:	be 00 00 00 00       	mov    $0x0,%esi
 4a5:	eb 80                	jmp    427 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4aa:	8b 17                	mov    (%edi),%edx
 4ac:	83 ec 0c             	sub    $0xc,%esp
 4af:	6a 00                	push   $0x0
 4b1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	e8 b2 fe ff ff       	call   370 <printint>
        ap++;
 4be:	83 c7 04             	add    $0x4,%edi
 4c1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c7:	be 00 00 00 00       	mov    $0x0,%esi
 4cc:	e9 56 ff ff ff       	jmp    427 <printf+0x2c>
        s = (char*)*ap;
 4d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d4:	8b 30                	mov    (%eax),%esi
        ap++;
 4d6:	83 c0 04             	add    $0x4,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4dc:	85 f6                	test   %esi,%esi
 4de:	75 15                	jne    4f5 <printf+0xfa>
          s = "(null)";
 4e0:	be 6b 07 00 00       	mov    $0x76b,%esi
 4e5:	eb 0e                	jmp    4f5 <printf+0xfa>
          putc(fd, *s);
 4e7:	0f be d2             	movsbl %dl,%edx
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	e8 64 fe ff ff       	call   356 <putc>
          s++;
 4f2:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f5:	0f b6 16             	movzbl (%esi),%edx
 4f8:	84 d2                	test   %dl,%dl
 4fa:	75 eb                	jne    4e7 <printf+0xec>
      state = 0;
 4fc:	be 00 00 00 00       	mov    $0x0,%esi
 501:	e9 21 ff ff ff       	jmp    427 <printf+0x2c>
        putc(fd, *ap);
 506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 509:	0f be 17             	movsbl (%edi),%edx
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	e8 42 fe ff ff       	call   356 <putc>
        ap++;
 514:	83 c7 04             	add    $0x4,%edi
 517:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 51a:	be 00 00 00 00       	mov    $0x0,%esi
 51f:	e9 03 ff ff ff       	jmp    427 <printf+0x2c>
        putc(fd, c);
 524:	89 fa                	mov    %edi,%edx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	e8 28 fe ff ff       	call   356 <putc>
      state = 0;
 52e:	be 00 00 00 00       	mov    $0x0,%esi
 533:	e9 ef fe ff ff       	jmp    427 <printf+0x2c>
        putc(fd, '%');
 538:	ba 25 00 00 00       	mov    $0x25,%edx
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	e8 11 fe ff ff       	call   356 <putc>
        putc(fd, c);
 545:	89 fa                	mov    %edi,%edx
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	e8 07 fe ff ff       	call   356 <putc>
      state = 0;
 54f:	be 00 00 00 00       	mov    $0x0,%esi
 554:	e9 ce fe ff ff       	jmp    427 <printf+0x2c>
    }
  }
}
 559:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55c:	5b                   	pop    %ebx
 55d:	5e                   	pop    %esi
 55e:	5f                   	pop    %edi
 55f:	5d                   	pop    %ebp
 560:	c3                   	ret    

00000561 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	57                   	push   %edi
 565:	56                   	push   %esi
 566:	53                   	push   %ebx
 567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 56a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56d:	a1 70 0a 00 00       	mov    0xa70,%eax
 572:	eb 02                	jmp    576 <free+0x15>
 574:	89 d0                	mov    %edx,%eax
 576:	39 c8                	cmp    %ecx,%eax
 578:	73 04                	jae    57e <free+0x1d>
 57a:	39 08                	cmp    %ecx,(%eax)
 57c:	77 12                	ja     590 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57e:	8b 10                	mov    (%eax),%edx
 580:	39 c2                	cmp    %eax,%edx
 582:	77 f0                	ja     574 <free+0x13>
 584:	39 c8                	cmp    %ecx,%eax
 586:	72 08                	jb     590 <free+0x2f>
 588:	39 ca                	cmp    %ecx,%edx
 58a:	77 04                	ja     590 <free+0x2f>
 58c:	89 d0                	mov    %edx,%eax
 58e:	eb e6                	jmp    576 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 590:	8b 73 fc             	mov    -0x4(%ebx),%esi
 593:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 596:	8b 10                	mov    (%eax),%edx
 598:	39 d7                	cmp    %edx,%edi
 59a:	74 19                	je     5b5 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 59f:	8b 50 04             	mov    0x4(%eax),%edx
 5a2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a5:	39 ce                	cmp    %ecx,%esi
 5a7:	74 1b                	je     5c4 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a9:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ab:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5f                   	pop    %edi
 5b3:	5d                   	pop    %ebp
 5b4:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b5:	03 72 04             	add    0x4(%edx),%esi
 5b8:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5bb:	8b 10                	mov    (%eax),%edx
 5bd:	8b 12                	mov    (%edx),%edx
 5bf:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c2:	eb db                	jmp    59f <free+0x3e>
    p->s.size += bp->s.size;
 5c4:	03 53 fc             	add    -0x4(%ebx),%edx
 5c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ca:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5cd:	89 10                	mov    %edx,(%eax)
 5cf:	eb da                	jmp    5ab <free+0x4a>

000005d1 <morecore>:

static Header*
morecore(uint nu)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	53                   	push   %ebx
 5d5:	83 ec 04             	sub    $0x4,%esp
 5d8:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5da:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5df:	77 05                	ja     5e6 <morecore+0x15>
    nu = 4096;
 5e1:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5e6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	50                   	push   %eax
 5f1:	e8 10 fd ff ff       	call   306 <sbrk>
  if(p == (char*)-1)
 5f6:	83 c4 10             	add    $0x10,%esp
 5f9:	83 f8 ff             	cmp    $0xffffffff,%eax
 5fc:	74 1c                	je     61a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5fe:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 601:	83 c0 08             	add    $0x8,%eax
 604:	83 ec 0c             	sub    $0xc,%esp
 607:	50                   	push   %eax
 608:	e8 54 ff ff ff       	call   561 <free>
  return freep;
 60d:	a1 70 0a 00 00       	mov    0xa70,%eax
 612:	83 c4 10             	add    $0x10,%esp
}
 615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 618:	c9                   	leave  
 619:	c3                   	ret    
    return 0;
 61a:	b8 00 00 00 00       	mov    $0x0,%eax
 61f:	eb f4                	jmp    615 <morecore+0x44>

00000621 <malloc>:

void*
malloc(uint nbytes)
{
 621:	55                   	push   %ebp
 622:	89 e5                	mov    %esp,%ebp
 624:	53                   	push   %ebx
 625:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	8d 58 07             	lea    0x7(%eax),%ebx
 62e:	c1 eb 03             	shr    $0x3,%ebx
 631:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 634:	8b 0d 70 0a 00 00    	mov    0xa70,%ecx
 63a:	85 c9                	test   %ecx,%ecx
 63c:	74 04                	je     642 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63e:	8b 01                	mov    (%ecx),%eax
 640:	eb 4a                	jmp    68c <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 642:	c7 05 70 0a 00 00 74 	movl   $0xa74,0xa70
 649:	0a 00 00 
 64c:	c7 05 74 0a 00 00 74 	movl   $0xa74,0xa74
 653:	0a 00 00 
    base.s.size = 0;
 656:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 65d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 660:	b9 74 0a 00 00       	mov    $0xa74,%ecx
 665:	eb d7                	jmp    63e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 667:	74 19                	je     682 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 669:	29 da                	sub    %ebx,%edx
 66b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 66e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 671:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 674:	89 0d 70 0a 00 00    	mov    %ecx,0xa70
      return (void*)(p + 1);
 67a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 67d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 680:	c9                   	leave  
 681:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 682:	8b 10                	mov    (%eax),%edx
 684:	89 11                	mov    %edx,(%ecx)
 686:	eb ec                	jmp    674 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 688:	89 c1                	mov    %eax,%ecx
 68a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 68c:	8b 50 04             	mov    0x4(%eax),%edx
 68f:	39 da                	cmp    %ebx,%edx
 691:	73 d4                	jae    667 <malloc+0x46>
    if(p == freep)
 693:	39 05 70 0a 00 00    	cmp    %eax,0xa70
 699:	75 ed                	jne    688 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 69b:	89 d8                	mov    %ebx,%eax
 69d:	e8 2f ff ff ff       	call   5d1 <morecore>
 6a2:	85 c0                	test   %eax,%eax
 6a4:	75 e2                	jne    688 <malloc+0x67>
 6a6:	eb d5                	jmp    67d <malloc+0x5c>
