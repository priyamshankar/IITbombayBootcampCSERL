
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
  2e:	68 c0 06 00 00       	push   $0x6c0
  33:	6a 01                	push   $0x1
  35:	e8 b1 03 00 00       	call   3eb <printf>
	signalProcess(ret, SIGNAL_PAUSE);
  3a:	83 c4 08             	add    $0x8,%esp
  3d:	68 ab 06 00 00       	push   $0x6ab
  42:	53                   	push   %ebx
  43:	e8 f6 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  48:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  4f:	e8 ba 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending continue signal to child \n");
  54:	83 c4 08             	add    $0x8,%esp
  57:	68 e8 06 00 00       	push   $0x6e8
  5c:	6a 01                	push   $0x1
  5e:	e8 88 03 00 00       	call   3eb <printf>
	signalProcess(ret, SIGNAL_CONTINUE);
  63:	83 c4 08             	add    $0x8,%esp
  66:	68 b1 06 00 00       	push   $0x6b1
  6b:	53                   	push   %ebx
  6c:	e8 cd 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  71:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  78:	e8 91 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending kill signal to child \n");
  7d:	83 c4 08             	add    $0x8,%esp
  80:	68 14 07 00 00       	push   $0x714
  85:	6a 01                	push   $0x1
  87:	e8 5f 03 00 00       	call   3eb <printf>
	signalProcess(ret, SIGNAL_KILL);
  8c:	83 c4 08             	add    $0x8,%esp
  8f:	68 ba 06 00 00       	push   $0x6ba
  94:	53                   	push   %ebx
  95:	e8 a4 02 00 00       	call   33e <signalProcess>
	
	wait();
  9a:	e8 e7 01 00 00       	call   286 <wait>
	printf(1, "parent: child has terminated \n");
  9f:	83 c4 08             	add    $0x8,%esp
  a2:	68 3c 07 00 00       	push   $0x73c
  a7:	6a 01                	push   $0x1
  a9:	e8 3d 03 00 00       	call   3eb <printf>
	exit();
  ae:	e8 cb 01 00 00       	call   27e <exit>
			sleep(5e1);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	6a 32                	push   $0x32
  b8:	e8 51 02 00 00       	call   30e <sleep>
			printf(1, "child: Not_paused\n");
  bd:	83 c4 08             	add    $0x8,%esp
  c0:	68 98 06 00 00       	push   $0x698
  c5:	6a 01                	push   $0x1
  c7:	e8 1f 03 00 00       	call   3eb <printf>
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
 33e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 1c             	sub    $0x1c,%esp
 34c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 34f:	6a 01                	push   $0x1
 351:	8d 55 f4             	lea    -0xc(%ebp),%edx
 354:	52                   	push   %edx
 355:	50                   	push   %eax
 356:	e8 43 ff ff ff       	call   29e <write>
}
 35b:	83 c4 10             	add    $0x10,%esp
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 2c             	sub    $0x2c,%esp
 369:	89 45 d0             	mov    %eax,-0x30(%ebp)
 36c:	89 d0                	mov    %edx,%eax
 36e:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 370:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 374:	0f 95 c1             	setne  %cl
 377:	c1 ea 1f             	shr    $0x1f,%edx
 37a:	84 d1                	test   %dl,%cl
 37c:	74 44                	je     3c2 <printint+0x62>
    neg = 1;
    x = -xx;
 37e:	f7 d8                	neg    %eax
 380:	89 c1                	mov    %eax,%ecx
    neg = 1;
 382:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 389:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 38e:	89 c8                	mov    %ecx,%eax
 390:	ba 00 00 00 00       	mov    $0x0,%edx
 395:	f7 f6                	div    %esi
 397:	89 df                	mov    %ebx,%edi
 399:	83 c3 01             	add    $0x1,%ebx
 39c:	0f b6 92 bc 07 00 00 	movzbl 0x7bc(%edx),%edx
 3a3:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a7:	89 ca                	mov    %ecx,%edx
 3a9:	89 c1                	mov    %eax,%ecx
 3ab:	39 d6                	cmp    %edx,%esi
 3ad:	76 df                	jbe    38e <printint+0x2e>
  if(neg)
 3af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3b3:	74 31                	je     3e6 <printint+0x86>
    buf[i++] = '-';
 3b5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ba:	8d 5f 02             	lea    0x2(%edi),%ebx
 3bd:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3c0:	eb 17                	jmp    3d9 <printint+0x79>
    x = xx;
 3c2:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3cb:	eb bc                	jmp    389 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3cd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3d2:	89 f0                	mov    %esi,%eax
 3d4:	e8 6d ff ff ff       	call   346 <putc>
  while(--i >= 0)
 3d9:	83 eb 01             	sub    $0x1,%ebx
 3dc:	79 ef                	jns    3cd <printint+0x6d>
}
 3de:	83 c4 2c             	add    $0x2c,%esp
 3e1:	5b                   	pop    %ebx
 3e2:	5e                   	pop    %esi
 3e3:	5f                   	pop    %edi
 3e4:	5d                   	pop    %ebp
 3e5:	c3                   	ret    
 3e6:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e9:	eb ee                	jmp    3d9 <printint+0x79>

000003eb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3eb:	55                   	push   %ebp
 3ec:	89 e5                	mov    %esp,%ebp
 3ee:	57                   	push   %edi
 3ef:	56                   	push   %esi
 3f0:	53                   	push   %ebx
 3f1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f4:	8d 45 10             	lea    0x10(%ebp),%eax
 3f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3fa:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3ff:	bb 00 00 00 00       	mov    $0x0,%ebx
 404:	eb 14                	jmp    41a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 406:	89 fa                	mov    %edi,%edx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	e8 36 ff ff ff       	call   346 <putc>
 410:	eb 05                	jmp    417 <printf+0x2c>
      }
    } else if(state == '%'){
 412:	83 fe 25             	cmp    $0x25,%esi
 415:	74 25                	je     43c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 417:	83 c3 01             	add    $0x1,%ebx
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 421:	84 c0                	test   %al,%al
 423:	0f 84 20 01 00 00    	je     549 <printf+0x15e>
    c = fmt[i] & 0xff;
 429:	0f be f8             	movsbl %al,%edi
 42c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 42f:	85 f6                	test   %esi,%esi
 431:	75 df                	jne    412 <printf+0x27>
      if(c == '%'){
 433:	83 f8 25             	cmp    $0x25,%eax
 436:	75 ce                	jne    406 <printf+0x1b>
        state = '%';
 438:	89 c6                	mov    %eax,%esi
 43a:	eb db                	jmp    417 <printf+0x2c>
      if(c == 'd'){
 43c:	83 f8 25             	cmp    $0x25,%eax
 43f:	0f 84 cf 00 00 00    	je     514 <printf+0x129>
 445:	0f 8c dd 00 00 00    	jl     528 <printf+0x13d>
 44b:	83 f8 78             	cmp    $0x78,%eax
 44e:	0f 8f d4 00 00 00    	jg     528 <printf+0x13d>
 454:	83 f8 63             	cmp    $0x63,%eax
 457:	0f 8c cb 00 00 00    	jl     528 <printf+0x13d>
 45d:	83 e8 63             	sub    $0x63,%eax
 460:	83 f8 15             	cmp    $0x15,%eax
 463:	0f 87 bf 00 00 00    	ja     528 <printf+0x13d>
 469:	ff 24 85 64 07 00 00 	jmp    *0x764(,%eax,4)
        printint(fd, *ap, 10, 1);
 470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 473:	8b 17                	mov    (%edi),%edx
 475:	83 ec 0c             	sub    $0xc,%esp
 478:	6a 01                	push   $0x1
 47a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	e8 d9 fe ff ff       	call   360 <printint>
        ap++;
 487:	83 c7 04             	add    $0x4,%edi
 48a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 48d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 490:	be 00 00 00 00       	mov    $0x0,%esi
 495:	eb 80                	jmp    417 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49a:	8b 17                	mov    (%edi),%edx
 49c:	83 ec 0c             	sub    $0xc,%esp
 49f:	6a 00                	push   $0x0
 4a1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	e8 b2 fe ff ff       	call   360 <printint>
        ap++;
 4ae:	83 c7 04             	add    $0x4,%edi
 4b1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b7:	be 00 00 00 00       	mov    $0x0,%esi
 4bc:	e9 56 ff ff ff       	jmp    417 <printf+0x2c>
        s = (char*)*ap;
 4c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c4:	8b 30                	mov    (%eax),%esi
        ap++;
 4c6:	83 c0 04             	add    $0x4,%eax
 4c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4cc:	85 f6                	test   %esi,%esi
 4ce:	75 15                	jne    4e5 <printf+0xfa>
          s = "(null)";
 4d0:	be 5b 07 00 00       	mov    $0x75b,%esi
 4d5:	eb 0e                	jmp    4e5 <printf+0xfa>
          putc(fd, *s);
 4d7:	0f be d2             	movsbl %dl,%edx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	e8 64 fe ff ff       	call   346 <putc>
          s++;
 4e2:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4e5:	0f b6 16             	movzbl (%esi),%edx
 4e8:	84 d2                	test   %dl,%dl
 4ea:	75 eb                	jne    4d7 <printf+0xec>
      state = 0;
 4ec:	be 00 00 00 00       	mov    $0x0,%esi
 4f1:	e9 21 ff ff ff       	jmp    417 <printf+0x2c>
        putc(fd, *ap);
 4f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f9:	0f be 17             	movsbl (%edi),%edx
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	e8 42 fe ff ff       	call   346 <putc>
        ap++;
 504:	83 c7 04             	add    $0x4,%edi
 507:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 50a:	be 00 00 00 00       	mov    $0x0,%esi
 50f:	e9 03 ff ff ff       	jmp    417 <printf+0x2c>
        putc(fd, c);
 514:	89 fa                	mov    %edi,%edx
 516:	8b 45 08             	mov    0x8(%ebp),%eax
 519:	e8 28 fe ff ff       	call   346 <putc>
      state = 0;
 51e:	be 00 00 00 00       	mov    $0x0,%esi
 523:	e9 ef fe ff ff       	jmp    417 <printf+0x2c>
        putc(fd, '%');
 528:	ba 25 00 00 00       	mov    $0x25,%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 11 fe ff ff       	call   346 <putc>
        putc(fd, c);
 535:	89 fa                	mov    %edi,%edx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	e8 07 fe ff ff       	call   346 <putc>
      state = 0;
 53f:	be 00 00 00 00       	mov    $0x0,%esi
 544:	e9 ce fe ff ff       	jmp    417 <printf+0x2c>
    }
  }
}
 549:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54c:	5b                   	pop    %ebx
 54d:	5e                   	pop    %esi
 54e:	5f                   	pop    %edi
 54f:	5d                   	pop    %ebp
 550:	c3                   	ret    

00000551 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 551:	55                   	push   %ebp
 552:	89 e5                	mov    %esp,%ebp
 554:	57                   	push   %edi
 555:	56                   	push   %esi
 556:	53                   	push   %ebx
 557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 55a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55d:	a1 60 0a 00 00       	mov    0xa60,%eax
 562:	eb 02                	jmp    566 <free+0x15>
 564:	89 d0                	mov    %edx,%eax
 566:	39 c8                	cmp    %ecx,%eax
 568:	73 04                	jae    56e <free+0x1d>
 56a:	39 08                	cmp    %ecx,(%eax)
 56c:	77 12                	ja     580 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56e:	8b 10                	mov    (%eax),%edx
 570:	39 c2                	cmp    %eax,%edx
 572:	77 f0                	ja     564 <free+0x13>
 574:	39 c8                	cmp    %ecx,%eax
 576:	72 08                	jb     580 <free+0x2f>
 578:	39 ca                	cmp    %ecx,%edx
 57a:	77 04                	ja     580 <free+0x2f>
 57c:	89 d0                	mov    %edx,%eax
 57e:	eb e6                	jmp    566 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 580:	8b 73 fc             	mov    -0x4(%ebx),%esi
 583:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 586:	8b 10                	mov    (%eax),%edx
 588:	39 d7                	cmp    %edx,%edi
 58a:	74 19                	je     5a5 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 58c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 58f:	8b 50 04             	mov    0x4(%eax),%edx
 592:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 595:	39 ce                	cmp    %ecx,%esi
 597:	74 1b                	je     5b4 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 599:	89 08                	mov    %ecx,(%eax)
  freep = p;
 59b:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 5a0:	5b                   	pop    %ebx
 5a1:	5e                   	pop    %esi
 5a2:	5f                   	pop    %edi
 5a3:	5d                   	pop    %ebp
 5a4:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5a5:	03 72 04             	add    0x4(%edx),%esi
 5a8:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ab:	8b 10                	mov    (%eax),%edx
 5ad:	8b 12                	mov    (%edx),%edx
 5af:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5b2:	eb db                	jmp    58f <free+0x3e>
    p->s.size += bp->s.size;
 5b4:	03 53 fc             	add    -0x4(%ebx),%edx
 5b7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ba:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5bd:	89 10                	mov    %edx,(%eax)
 5bf:	eb da                	jmp    59b <free+0x4a>

000005c1 <morecore>:

static Header*
morecore(uint nu)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	53                   	push   %ebx
 5c5:	83 ec 04             	sub    $0x4,%esp
 5c8:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5ca:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5cf:	77 05                	ja     5d6 <morecore+0x15>
    nu = 4096;
 5d1:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5dd:	83 ec 0c             	sub    $0xc,%esp
 5e0:	50                   	push   %eax
 5e1:	e8 20 fd ff ff       	call   306 <sbrk>
  if(p == (char*)-1)
 5e6:	83 c4 10             	add    $0x10,%esp
 5e9:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ec:	74 1c                	je     60a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5ee:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5f1:	83 c0 08             	add    $0x8,%eax
 5f4:	83 ec 0c             	sub    $0xc,%esp
 5f7:	50                   	push   %eax
 5f8:	e8 54 ff ff ff       	call   551 <free>
  return freep;
 5fd:	a1 60 0a 00 00       	mov    0xa60,%eax
 602:	83 c4 10             	add    $0x10,%esp
}
 605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 608:	c9                   	leave  
 609:	c3                   	ret    
    return 0;
 60a:	b8 00 00 00 00       	mov    $0x0,%eax
 60f:	eb f4                	jmp    605 <morecore+0x44>

00000611 <malloc>:

void*
malloc(uint nbytes)
{
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	53                   	push   %ebx
 615:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	8d 58 07             	lea    0x7(%eax),%ebx
 61e:	c1 eb 03             	shr    $0x3,%ebx
 621:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 624:	8b 0d 60 0a 00 00    	mov    0xa60,%ecx
 62a:	85 c9                	test   %ecx,%ecx
 62c:	74 04                	je     632 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62e:	8b 01                	mov    (%ecx),%eax
 630:	eb 4a                	jmp    67c <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 632:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 639:	0a 00 00 
 63c:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 643:	0a 00 00 
    base.s.size = 0;
 646:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 64d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 650:	b9 64 0a 00 00       	mov    $0xa64,%ecx
 655:	eb d7                	jmp    62e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 657:	74 19                	je     672 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 659:	29 da                	sub    %ebx,%edx
 65b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 65e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 661:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 664:	89 0d 60 0a 00 00    	mov    %ecx,0xa60
      return (void*)(p + 1);
 66a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 66d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 670:	c9                   	leave  
 671:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 672:	8b 10                	mov    (%eax),%edx
 674:	89 11                	mov    %edx,(%ecx)
 676:	eb ec                	jmp    664 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 678:	89 c1                	mov    %eax,%ecx
 67a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 67c:	8b 50 04             	mov    0x4(%eax),%edx
 67f:	39 da                	cmp    %ebx,%edx
 681:	73 d4                	jae    657 <malloc+0x46>
    if(p == freep)
 683:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 689:	75 ed                	jne    678 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 68b:	89 d8                	mov    %ebx,%eax
 68d:	e8 2f ff ff ff       	call   5c1 <morecore>
 692:	85 c0                	test   %eax,%eax
 694:	75 e2                	jne    678 <malloc+0x67>
 696:	eb d5                	jmp    66d <malloc+0x5c>
