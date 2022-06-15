
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
  2e:	68 18 07 00 00       	push   $0x718
  33:	6a 01                	push   $0x1
  35:	e8 09 04 00 00       	call   443 <printf>
	signalProcess(ret, SIGNAL_PAUSE);
  3a:	83 c4 08             	add    $0x8,%esp
  3d:	68 03 07 00 00       	push   $0x703
  42:	53                   	push   %ebx
  43:	e8 f6 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  48:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  4f:	e8 ba 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending continue signal to child \n");
  54:	83 c4 08             	add    $0x8,%esp
  57:	68 40 07 00 00       	push   $0x740
  5c:	6a 01                	push   $0x1
  5e:	e8 e0 03 00 00       	call   443 <printf>
	signalProcess(ret, SIGNAL_CONTINUE);
  63:	83 c4 08             	add    $0x8,%esp
  66:	68 09 07 00 00       	push   $0x709
  6b:	53                   	push   %ebx
  6c:	e8 cd 02 00 00       	call   33e <signalProcess>
	
	sleep(5e2);
  71:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  78:	e8 91 02 00 00       	call   30e <sleep>
	printf(1, "parent: sending kill signal to child \n");
  7d:	83 c4 08             	add    $0x8,%esp
  80:	68 6c 07 00 00       	push   $0x76c
  85:	6a 01                	push   $0x1
  87:	e8 b7 03 00 00       	call   443 <printf>
	signalProcess(ret, SIGNAL_KILL);
  8c:	83 c4 08             	add    $0x8,%esp
  8f:	68 12 07 00 00       	push   $0x712
  94:	53                   	push   %ebx
  95:	e8 a4 02 00 00       	call   33e <signalProcess>
	
	wait();
  9a:	e8 e7 01 00 00       	call   286 <wait>
	printf(1, "parent: child has terminated \n");
  9f:	83 c4 08             	add    $0x8,%esp
  a2:	68 94 07 00 00       	push   $0x794
  a7:	6a 01                	push   $0x1
  a9:	e8 95 03 00 00       	call   443 <printf>
	exit();
  ae:	e8 cb 01 00 00       	call   27e <exit>
			sleep(5e1);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	6a 32                	push   $0x32
  b8:	e8 51 02 00 00       	call   30e <sleep>
			printf(1, "child: Not_paused\n");
  bd:	83 c4 08             	add    $0x8,%esp
  c0:	68 f0 06 00 00       	push   $0x6f0
  c5:	6a 01                	push   $0x1
  c7:	e8 77 03 00 00       	call   443 <printf>
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
SYSCALL(numpp)
 34e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <init_counter>:

SYSCALL(init_counter)
 356:	b8 1d 00 00 00       	mov    $0x1d,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <update_cnt>:
SYSCALL(update_cnt)
 35e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <display_count>:
SYSCALL(display_count)
 366:	b8 1f 00 00 00       	mov    $0x1f,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <init_counter_1>:
SYSCALL(init_counter_1)
 36e:	b8 20 00 00 00       	mov    $0x20,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <update_cnt_1>:
SYSCALL(update_cnt_1)
 376:	b8 21 00 00 00       	mov    $0x21,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <display_count_1>:
SYSCALL(display_count_1)
 37e:	b8 22 00 00 00       	mov    $0x22,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <init_counter_2>:
SYSCALL(init_counter_2)
 386:	b8 23 00 00 00       	mov    $0x23,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <update_cnt_2>:
SYSCALL(update_cnt_2)
 38e:	b8 24 00 00 00       	mov    $0x24,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <display_count_2>:
 396:	b8 25 00 00 00       	mov    $0x25,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 1c             	sub    $0x1c,%esp
 3a4:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3a7:	6a 01                	push   $0x1
 3a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3ac:	52                   	push   %edx
 3ad:	50                   	push   %eax
 3ae:	e8 eb fe ff ff       	call   29e <write>
}
 3b3:	83 c4 10             	add    $0x10,%esp
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    

000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	57                   	push   %edi
 3bc:	56                   	push   %esi
 3bd:	53                   	push   %ebx
 3be:	83 ec 2c             	sub    $0x2c,%esp
 3c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3cc:	0f 95 c1             	setne  %cl
 3cf:	c1 ea 1f             	shr    $0x1f,%edx
 3d2:	84 d1                	test   %dl,%cl
 3d4:	74 44                	je     41a <printint+0x62>
    neg = 1;
    x = -xx;
 3d6:	f7 d8                	neg    %eax
 3d8:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3e6:	89 c8                	mov    %ecx,%eax
 3e8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ed:	f7 f6                	div    %esi
 3ef:	89 df                	mov    %ebx,%edi
 3f1:	83 c3 01             	add    $0x1,%ebx
 3f4:	0f b6 92 14 08 00 00 	movzbl 0x814(%edx),%edx
 3fb:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3ff:	89 ca                	mov    %ecx,%edx
 401:	89 c1                	mov    %eax,%ecx
 403:	39 d6                	cmp    %edx,%esi
 405:	76 df                	jbe    3e6 <printint+0x2e>
  if(neg)
 407:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 40b:	74 31                	je     43e <printint+0x86>
    buf[i++] = '-';
 40d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 412:	8d 5f 02             	lea    0x2(%edi),%ebx
 415:	8b 75 d0             	mov    -0x30(%ebp),%esi
 418:	eb 17                	jmp    431 <printint+0x79>
    x = xx;
 41a:	89 c1                	mov    %eax,%ecx
  neg = 0;
 41c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 423:	eb bc                	jmp    3e1 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 425:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 42a:	89 f0                	mov    %esi,%eax
 42c:	e8 6d ff ff ff       	call   39e <putc>
  while(--i >= 0)
 431:	83 eb 01             	sub    $0x1,%ebx
 434:	79 ef                	jns    425 <printint+0x6d>
}
 436:	83 c4 2c             	add    $0x2c,%esp
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5f                   	pop    %edi
 43c:	5d                   	pop    %ebp
 43d:	c3                   	ret    
 43e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 441:	eb ee                	jmp    431 <printint+0x79>

00000443 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	57                   	push   %edi
 447:	56                   	push   %esi
 448:	53                   	push   %ebx
 449:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 44c:	8d 45 10             	lea    0x10(%ebp),%eax
 44f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 452:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 457:	bb 00 00 00 00       	mov    $0x0,%ebx
 45c:	eb 14                	jmp    472 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 45e:	89 fa                	mov    %edi,%edx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	e8 36 ff ff ff       	call   39e <putc>
 468:	eb 05                	jmp    46f <printf+0x2c>
      }
    } else if(state == '%'){
 46a:	83 fe 25             	cmp    $0x25,%esi
 46d:	74 25                	je     494 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 46f:	83 c3 01             	add    $0x1,%ebx
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 479:	84 c0                	test   %al,%al
 47b:	0f 84 20 01 00 00    	je     5a1 <printf+0x15e>
    c = fmt[i] & 0xff;
 481:	0f be f8             	movsbl %al,%edi
 484:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 487:	85 f6                	test   %esi,%esi
 489:	75 df                	jne    46a <printf+0x27>
      if(c == '%'){
 48b:	83 f8 25             	cmp    $0x25,%eax
 48e:	75 ce                	jne    45e <printf+0x1b>
        state = '%';
 490:	89 c6                	mov    %eax,%esi
 492:	eb db                	jmp    46f <printf+0x2c>
      if(c == 'd'){
 494:	83 f8 25             	cmp    $0x25,%eax
 497:	0f 84 cf 00 00 00    	je     56c <printf+0x129>
 49d:	0f 8c dd 00 00 00    	jl     580 <printf+0x13d>
 4a3:	83 f8 78             	cmp    $0x78,%eax
 4a6:	0f 8f d4 00 00 00    	jg     580 <printf+0x13d>
 4ac:	83 f8 63             	cmp    $0x63,%eax
 4af:	0f 8c cb 00 00 00    	jl     580 <printf+0x13d>
 4b5:	83 e8 63             	sub    $0x63,%eax
 4b8:	83 f8 15             	cmp    $0x15,%eax
 4bb:	0f 87 bf 00 00 00    	ja     580 <printf+0x13d>
 4c1:	ff 24 85 bc 07 00 00 	jmp    *0x7bc(,%eax,4)
        printint(fd, *ap, 10, 1);
 4c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4cb:	8b 17                	mov    (%edi),%edx
 4cd:	83 ec 0c             	sub    $0xc,%esp
 4d0:	6a 01                	push   $0x1
 4d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	e8 d9 fe ff ff       	call   3b8 <printint>
        ap++;
 4df:	83 c7 04             	add    $0x4,%edi
 4e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e5:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e8:	be 00 00 00 00       	mov    $0x0,%esi
 4ed:	eb 80                	jmp    46f <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f2:	8b 17                	mov    (%edi),%edx
 4f4:	83 ec 0c             	sub    $0xc,%esp
 4f7:	6a 00                	push   $0x0
 4f9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fe:	8b 45 08             	mov    0x8(%ebp),%eax
 501:	e8 b2 fe ff ff       	call   3b8 <printint>
        ap++;
 506:	83 c7 04             	add    $0x4,%edi
 509:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 50c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50f:	be 00 00 00 00       	mov    $0x0,%esi
 514:	e9 56 ff ff ff       	jmp    46f <printf+0x2c>
        s = (char*)*ap;
 519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51c:	8b 30                	mov    (%eax),%esi
        ap++;
 51e:	83 c0 04             	add    $0x4,%eax
 521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 524:	85 f6                	test   %esi,%esi
 526:	75 15                	jne    53d <printf+0xfa>
          s = "(null)";
 528:	be b3 07 00 00       	mov    $0x7b3,%esi
 52d:	eb 0e                	jmp    53d <printf+0xfa>
          putc(fd, *s);
 52f:	0f be d2             	movsbl %dl,%edx
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	e8 64 fe ff ff       	call   39e <putc>
          s++;
 53a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 53d:	0f b6 16             	movzbl (%esi),%edx
 540:	84 d2                	test   %dl,%dl
 542:	75 eb                	jne    52f <printf+0xec>
      state = 0;
 544:	be 00 00 00 00       	mov    $0x0,%esi
 549:	e9 21 ff ff ff       	jmp    46f <printf+0x2c>
        putc(fd, *ap);
 54e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 551:	0f be 17             	movsbl (%edi),%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	e8 42 fe ff ff       	call   39e <putc>
        ap++;
 55c:	83 c7 04             	add    $0x4,%edi
 55f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 562:	be 00 00 00 00       	mov    $0x0,%esi
 567:	e9 03 ff ff ff       	jmp    46f <printf+0x2c>
        putc(fd, c);
 56c:	89 fa                	mov    %edi,%edx
 56e:	8b 45 08             	mov    0x8(%ebp),%eax
 571:	e8 28 fe ff ff       	call   39e <putc>
      state = 0;
 576:	be 00 00 00 00       	mov    $0x0,%esi
 57b:	e9 ef fe ff ff       	jmp    46f <printf+0x2c>
        putc(fd, '%');
 580:	ba 25 00 00 00       	mov    $0x25,%edx
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	e8 11 fe ff ff       	call   39e <putc>
        putc(fd, c);
 58d:	89 fa                	mov    %edi,%edx
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	e8 07 fe ff ff       	call   39e <putc>
      state = 0;
 597:	be 00 00 00 00       	mov    $0x0,%esi
 59c:	e9 ce fe ff ff       	jmp    46f <printf+0x2c>
    }
  }
}
 5a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a4:	5b                   	pop    %ebx
 5a5:	5e                   	pop    %esi
 5a6:	5f                   	pop    %edi
 5a7:	5d                   	pop    %ebp
 5a8:	c3                   	ret    

000005a9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	57                   	push   %edi
 5ad:	56                   	push   %esi
 5ae:	53                   	push   %ebx
 5af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b5:	a1 b8 0a 00 00       	mov    0xab8,%eax
 5ba:	eb 02                	jmp    5be <free+0x15>
 5bc:	89 d0                	mov    %edx,%eax
 5be:	39 c8                	cmp    %ecx,%eax
 5c0:	73 04                	jae    5c6 <free+0x1d>
 5c2:	39 08                	cmp    %ecx,(%eax)
 5c4:	77 12                	ja     5d8 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c6:	8b 10                	mov    (%eax),%edx
 5c8:	39 c2                	cmp    %eax,%edx
 5ca:	77 f0                	ja     5bc <free+0x13>
 5cc:	39 c8                	cmp    %ecx,%eax
 5ce:	72 08                	jb     5d8 <free+0x2f>
 5d0:	39 ca                	cmp    %ecx,%edx
 5d2:	77 04                	ja     5d8 <free+0x2f>
 5d4:	89 d0                	mov    %edx,%eax
 5d6:	eb e6                	jmp    5be <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5de:	8b 10                	mov    (%eax),%edx
 5e0:	39 d7                	cmp    %edx,%edi
 5e2:	74 19                	je     5fd <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5e4:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e7:	8b 50 04             	mov    0x4(%eax),%edx
 5ea:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5ed:	39 ce                	cmp    %ecx,%esi
 5ef:	74 1b                	je     60c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5f1:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5f3:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 5f8:	5b                   	pop    %ebx
 5f9:	5e                   	pop    %esi
 5fa:	5f                   	pop    %edi
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5fd:	03 72 04             	add    0x4(%edx),%esi
 600:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 603:	8b 10                	mov    (%eax),%edx
 605:	8b 12                	mov    (%edx),%edx
 607:	89 53 f8             	mov    %edx,-0x8(%ebx)
 60a:	eb db                	jmp    5e7 <free+0x3e>
    p->s.size += bp->s.size;
 60c:	03 53 fc             	add    -0x4(%ebx),%edx
 60f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 612:	8b 53 f8             	mov    -0x8(%ebx),%edx
 615:	89 10                	mov    %edx,(%eax)
 617:	eb da                	jmp    5f3 <free+0x4a>

00000619 <morecore>:

static Header*
morecore(uint nu)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	53                   	push   %ebx
 61d:	83 ec 04             	sub    $0x4,%esp
 620:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 622:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 627:	77 05                	ja     62e <morecore+0x15>
    nu = 4096;
 629:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 62e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 635:	83 ec 0c             	sub    $0xc,%esp
 638:	50                   	push   %eax
 639:	e8 c8 fc ff ff       	call   306 <sbrk>
  if(p == (char*)-1)
 63e:	83 c4 10             	add    $0x10,%esp
 641:	83 f8 ff             	cmp    $0xffffffff,%eax
 644:	74 1c                	je     662 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 646:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 649:	83 c0 08             	add    $0x8,%eax
 64c:	83 ec 0c             	sub    $0xc,%esp
 64f:	50                   	push   %eax
 650:	e8 54 ff ff ff       	call   5a9 <free>
  return freep;
 655:	a1 b8 0a 00 00       	mov    0xab8,%eax
 65a:	83 c4 10             	add    $0x10,%esp
}
 65d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 660:	c9                   	leave  
 661:	c3                   	ret    
    return 0;
 662:	b8 00 00 00 00       	mov    $0x0,%eax
 667:	eb f4                	jmp    65d <morecore+0x44>

00000669 <malloc>:

void*
malloc(uint nbytes)
{
 669:	55                   	push   %ebp
 66a:	89 e5                	mov    %esp,%ebp
 66c:	53                   	push   %ebx
 66d:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	8d 58 07             	lea    0x7(%eax),%ebx
 676:	c1 eb 03             	shr    $0x3,%ebx
 679:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67c:	8b 0d b8 0a 00 00    	mov    0xab8,%ecx
 682:	85 c9                	test   %ecx,%ecx
 684:	74 04                	je     68a <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 686:	8b 01                	mov    (%ecx),%eax
 688:	eb 4a                	jmp    6d4 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 68a:	c7 05 b8 0a 00 00 bc 	movl   $0xabc,0xab8
 691:	0a 00 00 
 694:	c7 05 bc 0a 00 00 bc 	movl   $0xabc,0xabc
 69b:	0a 00 00 
    base.s.size = 0;
 69e:	c7 05 c0 0a 00 00 00 	movl   $0x0,0xac0
 6a5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6a8:	b9 bc 0a 00 00       	mov    $0xabc,%ecx
 6ad:	eb d7                	jmp    686 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6af:	74 19                	je     6ca <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b1:	29 da                	sub    %ebx,%edx
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6b6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6b9:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6bc:	89 0d b8 0a 00 00    	mov    %ecx,0xab8
      return (void*)(p + 1);
 6c2:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	89 11                	mov    %edx,(%ecx)
 6ce:	eb ec                	jmp    6bc <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d0:	89 c1                	mov    %eax,%ecx
 6d2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6d4:	8b 50 04             	mov    0x4(%eax),%edx
 6d7:	39 da                	cmp    %ebx,%edx
 6d9:	73 d4                	jae    6af <malloc+0x46>
    if(p == freep)
 6db:	39 05 b8 0a 00 00    	cmp    %eax,0xab8
 6e1:	75 ed                	jne    6d0 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6e3:	89 d8                	mov    %ebx,%eax
 6e5:	e8 2f ff ff ff       	call   619 <morecore>
 6ea:	85 c0                	test   %eax,%eax
 6ec:	75 e2                	jne    6d0 <malloc+0x67>
 6ee:	eb d5                	jmp    6c5 <malloc+0x5c>
