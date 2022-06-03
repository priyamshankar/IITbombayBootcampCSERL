
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  16:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1d:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  24:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 d8 06 00 00       	push   $0x6d8
  2f:	6a 01                	push   $0x1
  31:	e8 f2 03 00 00       	call   428 <printf>
  memset(data, 'a', sizeof(data));
  36:	83 c4 0c             	add    $0xc,%esp
  39:	68 00 02 00 00       	push   $0x200
  3e:	6a 61                	push   $0x61
  40:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  46:	50                   	push   %eax
  47:	e8 34 01 00 00       	call   180 <memset>

  for(i = 0; i < 4; i++)
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  54:	83 fb 03             	cmp    $0x3,%ebx
  57:	7f 0e                	jg     67 <main+0x67>
    if(fork() > 0)
  59:	e8 55 02 00 00       	call   2b3 <fork>
  5e:	85 c0                	test   %eax,%eax
  60:	7f 05                	jg     67 <main+0x67>
  for(i = 0; i < 4; i++)
  62:	83 c3 01             	add    $0x1,%ebx
  65:	eb ed                	jmp    54 <main+0x54>
      break;

  printf(1, "write %d\n", i);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	53                   	push   %ebx
  6b:	68 eb 06 00 00       	push   $0x6eb
  70:	6a 01                	push   $0x1
  72:	e8 b1 03 00 00       	call   428 <printf>

  path[8] += i;
  77:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	83 c4 08             	add    $0x8,%esp
  7d:	68 02 02 00 00       	push   $0x202
  82:	8d 45 de             	lea    -0x22(%ebp),%eax
  85:	50                   	push   %eax
  86:	e8 70 02 00 00       	call   2fb <open>
  8b:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  8d:	83 c4 10             	add    $0x10,%esp
  90:	bb 00 00 00 00       	mov    $0x0,%ebx
  95:	eb 1b                	jmp    b2 <main+0xb2>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  97:	83 ec 04             	sub    $0x4,%esp
  9a:	68 00 02 00 00       	push   $0x200
  9f:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a5:	50                   	push   %eax
  a6:	56                   	push   %esi
  a7:	e8 2f 02 00 00       	call   2db <write>
  for(i = 0; i < 20; i++)
  ac:	83 c3 01             	add    $0x1,%ebx
  af:	83 c4 10             	add    $0x10,%esp
  b2:	83 fb 13             	cmp    $0x13,%ebx
  b5:	7e e0                	jle    97 <main+0x97>
  close(fd);
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	56                   	push   %esi
  bb:	e8 23 02 00 00       	call   2e3 <close>

  printf(1, "read\n");
  c0:	83 c4 08             	add    $0x8,%esp
  c3:	68 f5 06 00 00       	push   $0x6f5
  c8:	6a 01                	push   $0x1
  ca:	e8 59 03 00 00       	call   428 <printf>

  fd = open(path, O_RDONLY);
  cf:	83 c4 08             	add    $0x8,%esp
  d2:	6a 00                	push   $0x0
  d4:	8d 45 de             	lea    -0x22(%ebp),%eax
  d7:	50                   	push   %eax
  d8:	e8 1e 02 00 00       	call   2fb <open>
  dd:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  df:	83 c4 10             	add    $0x10,%esp
  e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  e7:	eb 1b                	jmp    104 <main+0x104>
    read(fd, data, sizeof(data));
  e9:	83 ec 04             	sub    $0x4,%esp
  ec:	68 00 02 00 00       	push   $0x200
  f1:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  f7:	50                   	push   %eax
  f8:	56                   	push   %esi
  f9:	e8 d5 01 00 00       	call   2d3 <read>
  for (i = 0; i < 20; i++)
  fe:	83 c3 01             	add    $0x1,%ebx
 101:	83 c4 10             	add    $0x10,%esp
 104:	83 fb 13             	cmp    $0x13,%ebx
 107:	7e e0                	jle    e9 <main+0xe9>
  close(fd);
 109:	83 ec 0c             	sub    $0xc,%esp
 10c:	56                   	push   %esi
 10d:	e8 d1 01 00 00       	call   2e3 <close>

  wait();
 112:	e8 ac 01 00 00       	call   2c3 <wait>

  exit();
 117:	e8 9f 01 00 00       	call   2bb <exit>

0000011c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	56                   	push   %esi
 120:	53                   	push   %ebx
 121:	8b 75 08             	mov    0x8(%ebp),%esi
 124:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 127:	89 f0                	mov    %esi,%eax
 129:	89 d1                	mov    %edx,%ecx
 12b:	83 c2 01             	add    $0x1,%edx
 12e:	89 c3                	mov    %eax,%ebx
 130:	83 c0 01             	add    $0x1,%eax
 133:	0f b6 09             	movzbl (%ecx),%ecx
 136:	88 0b                	mov    %cl,(%ebx)
 138:	84 c9                	test   %cl,%cl
 13a:	75 ed                	jne    129 <strcpy+0xd>
    ;
  return os;
}
 13c:	89 f0                	mov    %esi,%eax
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	8b 4d 08             	mov    0x8(%ebp),%ecx
 148:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14b:	eb 06                	jmp    153 <strcmp+0x11>
    p++, q++;
 14d:	83 c1 01             	add    $0x1,%ecx
 150:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 153:	0f b6 01             	movzbl (%ecx),%eax
 156:	84 c0                	test   %al,%al
 158:	74 04                	je     15e <strcmp+0x1c>
 15a:	3a 02                	cmp    (%edx),%al
 15c:	74 ef                	je     14d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 15e:	0f b6 c0             	movzbl %al,%eax
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	29 d0                	sub    %edx,%eax
}
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    

00000168 <strlen>:

uint
strlen(const char *s)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 16e:	b8 00 00 00 00       	mov    $0x0,%eax
 173:	eb 03                	jmp    178 <strlen+0x10>
 175:	83 c0 01             	add    $0x1,%eax
 178:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 17c:	75 f7                	jne    175 <strlen+0xd>
    ;
  return n;
}
 17e:	5d                   	pop    %ebp
 17f:	c3                   	ret    

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 187:	89 d7                	mov    %edx,%edi
 189:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18c:	8b 45 0c             	mov    0xc(%ebp),%eax
 18f:	fc                   	cld    
 190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 192:	89 d0                	mov    %edx,%eax
 194:	8b 7d fc             	mov    -0x4(%ebp),%edi
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <strchr>:

char*
strchr(const char *s, char c)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1a3:	eb 03                	jmp    1a8 <strchr+0xf>
 1a5:	83 c0 01             	add    $0x1,%eax
 1a8:	0f b6 10             	movzbl (%eax),%edx
 1ab:	84 d2                	test   %dl,%dl
 1ad:	74 06                	je     1b5 <strchr+0x1c>
    if(*s == c)
 1af:	38 ca                	cmp    %cl,%dl
 1b1:	75 f2                	jne    1a5 <strchr+0xc>
 1b3:	eb 05                	jmp    1ba <strchr+0x21>
      return (char*)s;
  return 0;
 1b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret    

000001bc <gets>:

char*
gets(char *buf, int max)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	83 ec 1c             	sub    $0x1c,%esp
 1c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	bb 00 00 00 00       	mov    $0x0,%ebx
 1cd:	89 de                	mov    %ebx,%esi
 1cf:	83 c3 01             	add    $0x1,%ebx
 1d2:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d5:	7d 2e                	jge    205 <gets+0x49>
    cc = read(0, &c, 1);
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	6a 01                	push   $0x1
 1dc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1df:	50                   	push   %eax
 1e0:	6a 00                	push   $0x0
 1e2:	e8 ec 00 00 00       	call   2d3 <read>
    if(cc < 1)
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	85 c0                	test   %eax,%eax
 1ec:	7e 17                	jle    205 <gets+0x49>
      break;
    buf[i++] = c;
 1ee:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f2:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1f5:	3c 0a                	cmp    $0xa,%al
 1f7:	0f 94 c2             	sete   %dl
 1fa:	3c 0d                	cmp    $0xd,%al
 1fc:	0f 94 c0             	sete   %al
 1ff:	08 c2                	or     %al,%dl
 201:	74 ca                	je     1cd <gets+0x11>
    buf[i++] = c;
 203:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 205:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 209:	89 f8                	mov    %edi,%eax
 20b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20e:	5b                   	pop    %ebx
 20f:	5e                   	pop    %esi
 210:	5f                   	pop    %edi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    

00000213 <stat>:

int
stat(const char *n, struct stat *st)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
 216:	56                   	push   %esi
 217:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	83 ec 08             	sub    $0x8,%esp
 21b:	6a 00                	push   $0x0
 21d:	ff 75 08             	push   0x8(%ebp)
 220:	e8 d6 00 00 00       	call   2fb <open>
  if(fd < 0)
 225:	83 c4 10             	add    $0x10,%esp
 228:	85 c0                	test   %eax,%eax
 22a:	78 24                	js     250 <stat+0x3d>
 22c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	push   0xc(%ebp)
 234:	50                   	push   %eax
 235:	e8 d9 00 00 00       	call   313 <fstat>
 23a:	89 c6                	mov    %eax,%esi
  close(fd);
 23c:	89 1c 24             	mov    %ebx,(%esp)
 23f:	e8 9f 00 00 00       	call   2e3 <close>
  return r;
 244:	83 c4 10             	add    $0x10,%esp
}
 247:	89 f0                	mov    %esi,%eax
 249:	8d 65 f8             	lea    -0x8(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb f0                	jmp    247 <stat+0x34>

00000257 <atoi>:

int
atoi(const char *s)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	53                   	push   %ebx
 25b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 25e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 263:	eb 10                	jmp    275 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 265:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 268:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 26b:	83 c1 01             	add    $0x1,%ecx
 26e:	0f be c0             	movsbl %al,%eax
 271:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 275:	0f b6 01             	movzbl (%ecx),%eax
 278:	8d 58 d0             	lea    -0x30(%eax),%ebx
 27b:	80 fb 09             	cmp    $0x9,%bl
 27e:	76 e5                	jbe    265 <atoi+0xe>
  return n;
}
 280:	89 d0                	mov    %edx,%eax
 282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	56                   	push   %esi
 28b:	53                   	push   %ebx
 28c:	8b 75 08             	mov    0x8(%ebp),%esi
 28f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 292:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 295:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 297:	eb 0d                	jmp    2a6 <memmove+0x1f>
    *dst++ = *src++;
 299:	0f b6 01             	movzbl (%ecx),%eax
 29c:	88 02                	mov    %al,(%edx)
 29e:	8d 49 01             	lea    0x1(%ecx),%ecx
 2a1:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2a4:	89 d8                	mov    %ebx,%eax
 2a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7f ec                	jg     299 <memmove+0x12>
  return vdst;
}
 2ad:	89 f0                	mov    %esi,%eax
 2af:	5b                   	pop    %ebx
 2b0:	5e                   	pop    %esi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b3:	b8 01 00 00 00       	mov    $0x1,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exit>:
SYSCALL(exit)
 2bb:	b8 02 00 00 00       	mov    $0x2,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <wait>:
SYSCALL(wait)
 2c3:	b8 03 00 00 00       	mov    $0x3,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <pipe>:
SYSCALL(pipe)
 2cb:	b8 04 00 00 00       	mov    $0x4,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <read>:
SYSCALL(read)
 2d3:	b8 05 00 00 00       	mov    $0x5,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <write>:
SYSCALL(write)
 2db:	b8 10 00 00 00       	mov    $0x10,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <close>:
SYSCALL(close)
 2e3:	b8 15 00 00 00       	mov    $0x15,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <kill>:
SYSCALL(kill)
 2eb:	b8 06 00 00 00       	mov    $0x6,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exec>:
SYSCALL(exec)
 2f3:	b8 07 00 00 00       	mov    $0x7,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <open>:
SYSCALL(open)
 2fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <mknod>:
SYSCALL(mknod)
 303:	b8 11 00 00 00       	mov    $0x11,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <unlink>:
SYSCALL(unlink)
 30b:	b8 12 00 00 00       	mov    $0x12,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <fstat>:
SYSCALL(fstat)
 313:	b8 08 00 00 00       	mov    $0x8,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <link>:
SYSCALL(link)
 31b:	b8 13 00 00 00       	mov    $0x13,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <mkdir>:
SYSCALL(mkdir)
 323:	b8 14 00 00 00       	mov    $0x14,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <chdir>:
SYSCALL(chdir)
 32b:	b8 09 00 00 00       	mov    $0x9,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <dup>:
SYSCALL(dup)
 333:	b8 0a 00 00 00       	mov    $0xa,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getpid>:
SYSCALL(getpid)
 33b:	b8 0b 00 00 00       	mov    $0xb,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sbrk>:
SYSCALL(sbrk)
 343:	b8 0c 00 00 00       	mov    $0xc,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sleep>:
SYSCALL(sleep)
 34b:	b8 0d 00 00 00       	mov    $0xd,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <uptime>:
SYSCALL(uptime)
 353:	b8 0e 00 00 00       	mov    $0xe,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <hello>:
SYSCALL(hello)
 35b:	b8 16 00 00 00       	mov    $0x16,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <helloYou>:
SYSCALL(helloYou)
 363:	b8 17 00 00 00       	mov    $0x17,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <getppid>:
SYSCALL(getppid)
 36b:	b8 18 00 00 00       	mov    $0x18,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <get_siblings_info>:
SYSCALL(get_siblings_info)
 373:	b8 19 00 00 00       	mov    $0x19,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <signalProcess>:
 37b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 1c             	sub    $0x1c,%esp
 389:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 38c:	6a 01                	push   $0x1
 38e:	8d 55 f4             	lea    -0xc(%ebp),%edx
 391:	52                   	push   %edx
 392:	50                   	push   %eax
 393:	e8 43 ff ff ff       	call   2db <write>
}
 398:	83 c4 10             	add    $0x10,%esp
 39b:	c9                   	leave  
 39c:	c3                   	ret    

0000039d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
 3a0:	57                   	push   %edi
 3a1:	56                   	push   %esi
 3a2:	53                   	push   %ebx
 3a3:	83 ec 2c             	sub    $0x2c,%esp
 3a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b1:	0f 95 c1             	setne  %cl
 3b4:	c1 ea 1f             	shr    $0x1f,%edx
 3b7:	84 d1                	test   %dl,%cl
 3b9:	74 44                	je     3ff <printint+0x62>
    neg = 1;
    x = -xx;
 3bb:	f7 d8                	neg    %eax
 3bd:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3bf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3cb:	89 c8                	mov    %ecx,%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f6                	div    %esi
 3d4:	89 df                	mov    %ebx,%edi
 3d6:	83 c3 01             	add    $0x1,%ebx
 3d9:	0f b6 92 5c 07 00 00 	movzbl 0x75c(%edx),%edx
 3e0:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3e4:	89 ca                	mov    %ecx,%edx
 3e6:	89 c1                	mov    %eax,%ecx
 3e8:	39 d6                	cmp    %edx,%esi
 3ea:	76 df                	jbe    3cb <printint+0x2e>
  if(neg)
 3ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3f0:	74 31                	je     423 <printint+0x86>
    buf[i++] = '-';
 3f2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3f7:	8d 5f 02             	lea    0x2(%edi),%ebx
 3fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3fd:	eb 17                	jmp    416 <printint+0x79>
    x = xx;
 3ff:	89 c1                	mov    %eax,%ecx
  neg = 0;
 401:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 408:	eb bc                	jmp    3c6 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 40a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 40f:	89 f0                	mov    %esi,%eax
 411:	e8 6d ff ff ff       	call   383 <putc>
  while(--i >= 0)
 416:	83 eb 01             	sub    $0x1,%ebx
 419:	79 ef                	jns    40a <printint+0x6d>
}
 41b:	83 c4 2c             	add    $0x2c,%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    
 423:	8b 75 d0             	mov    -0x30(%ebp),%esi
 426:	eb ee                	jmp    416 <printint+0x79>

00000428 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	57                   	push   %edi
 42c:	56                   	push   %esi
 42d:	53                   	push   %ebx
 42e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 431:	8d 45 10             	lea    0x10(%ebp),%eax
 434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 437:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 43c:	bb 00 00 00 00       	mov    $0x0,%ebx
 441:	eb 14                	jmp    457 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 443:	89 fa                	mov    %edi,%edx
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	e8 36 ff ff ff       	call   383 <putc>
 44d:	eb 05                	jmp    454 <printf+0x2c>
      }
    } else if(state == '%'){
 44f:	83 fe 25             	cmp    $0x25,%esi
 452:	74 25                	je     479 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 454:	83 c3 01             	add    $0x1,%ebx
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 45e:	84 c0                	test   %al,%al
 460:	0f 84 20 01 00 00    	je     586 <printf+0x15e>
    c = fmt[i] & 0xff;
 466:	0f be f8             	movsbl %al,%edi
 469:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 46c:	85 f6                	test   %esi,%esi
 46e:	75 df                	jne    44f <printf+0x27>
      if(c == '%'){
 470:	83 f8 25             	cmp    $0x25,%eax
 473:	75 ce                	jne    443 <printf+0x1b>
        state = '%';
 475:	89 c6                	mov    %eax,%esi
 477:	eb db                	jmp    454 <printf+0x2c>
      if(c == 'd'){
 479:	83 f8 25             	cmp    $0x25,%eax
 47c:	0f 84 cf 00 00 00    	je     551 <printf+0x129>
 482:	0f 8c dd 00 00 00    	jl     565 <printf+0x13d>
 488:	83 f8 78             	cmp    $0x78,%eax
 48b:	0f 8f d4 00 00 00    	jg     565 <printf+0x13d>
 491:	83 f8 63             	cmp    $0x63,%eax
 494:	0f 8c cb 00 00 00    	jl     565 <printf+0x13d>
 49a:	83 e8 63             	sub    $0x63,%eax
 49d:	83 f8 15             	cmp    $0x15,%eax
 4a0:	0f 87 bf 00 00 00    	ja     565 <printf+0x13d>
 4a6:	ff 24 85 04 07 00 00 	jmp    *0x704(,%eax,4)
        printint(fd, *ap, 10, 1);
 4ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b0:	8b 17                	mov    (%edi),%edx
 4b2:	83 ec 0c             	sub    $0xc,%esp
 4b5:	6a 01                	push   $0x1
 4b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	e8 d9 fe ff ff       	call   39d <printint>
        ap++;
 4c4:	83 c7 04             	add    $0x4,%edi
 4c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ca:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4cd:	be 00 00 00 00       	mov    $0x0,%esi
 4d2:	eb 80                	jmp    454 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d7:	8b 17                	mov    (%edi),%edx
 4d9:	83 ec 0c             	sub    $0xc,%esp
 4dc:	6a 00                	push   $0x0
 4de:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 b2 fe ff ff       	call   39d <printint>
        ap++;
 4eb:	83 c7 04             	add    $0x4,%edi
 4ee:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f4:	be 00 00 00 00       	mov    $0x0,%esi
 4f9:	e9 56 ff ff ff       	jmp    454 <printf+0x2c>
        s = (char*)*ap;
 4fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 501:	8b 30                	mov    (%eax),%esi
        ap++;
 503:	83 c0 04             	add    $0x4,%eax
 506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 509:	85 f6                	test   %esi,%esi
 50b:	75 15                	jne    522 <printf+0xfa>
          s = "(null)";
 50d:	be fb 06 00 00       	mov    $0x6fb,%esi
 512:	eb 0e                	jmp    522 <printf+0xfa>
          putc(fd, *s);
 514:	0f be d2             	movsbl %dl,%edx
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	e8 64 fe ff ff       	call   383 <putc>
          s++;
 51f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 522:	0f b6 16             	movzbl (%esi),%edx
 525:	84 d2                	test   %dl,%dl
 527:	75 eb                	jne    514 <printf+0xec>
      state = 0;
 529:	be 00 00 00 00       	mov    $0x0,%esi
 52e:	e9 21 ff ff ff       	jmp    454 <printf+0x2c>
        putc(fd, *ap);
 533:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 536:	0f be 17             	movsbl (%edi),%edx
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	e8 42 fe ff ff       	call   383 <putc>
        ap++;
 541:	83 c7 04             	add    $0x4,%edi
 544:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 547:	be 00 00 00 00       	mov    $0x0,%esi
 54c:	e9 03 ff ff ff       	jmp    454 <printf+0x2c>
        putc(fd, c);
 551:	89 fa                	mov    %edi,%edx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	e8 28 fe ff ff       	call   383 <putc>
      state = 0;
 55b:	be 00 00 00 00       	mov    $0x0,%esi
 560:	e9 ef fe ff ff       	jmp    454 <printf+0x2c>
        putc(fd, '%');
 565:	ba 25 00 00 00       	mov    $0x25,%edx
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	e8 11 fe ff ff       	call   383 <putc>
        putc(fd, c);
 572:	89 fa                	mov    %edi,%edx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 07 fe ff ff       	call   383 <putc>
      state = 0;
 57c:	be 00 00 00 00       	mov    $0x0,%esi
 581:	e9 ce fe ff ff       	jmp    454 <printf+0x2c>
    }
  }
}
 586:	8d 65 f4             	lea    -0xc(%ebp),%esp
 589:	5b                   	pop    %ebx
 58a:	5e                   	pop    %esi
 58b:	5f                   	pop    %edi
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	57                   	push   %edi
 592:	56                   	push   %esi
 593:	53                   	push   %ebx
 594:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 597:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59a:	a1 04 0a 00 00       	mov    0xa04,%eax
 59f:	eb 02                	jmp    5a3 <free+0x15>
 5a1:	89 d0                	mov    %edx,%eax
 5a3:	39 c8                	cmp    %ecx,%eax
 5a5:	73 04                	jae    5ab <free+0x1d>
 5a7:	39 08                	cmp    %ecx,(%eax)
 5a9:	77 12                	ja     5bd <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ab:	8b 10                	mov    (%eax),%edx
 5ad:	39 c2                	cmp    %eax,%edx
 5af:	77 f0                	ja     5a1 <free+0x13>
 5b1:	39 c8                	cmp    %ecx,%eax
 5b3:	72 08                	jb     5bd <free+0x2f>
 5b5:	39 ca                	cmp    %ecx,%edx
 5b7:	77 04                	ja     5bd <free+0x2f>
 5b9:	89 d0                	mov    %edx,%eax
 5bb:	eb e6                	jmp    5a3 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5bd:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c0:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5c3:	8b 10                	mov    (%eax),%edx
 5c5:	39 d7                	cmp    %edx,%edi
 5c7:	74 19                	je     5e2 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5c9:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5cc:	8b 50 04             	mov    0x4(%eax),%edx
 5cf:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d2:	39 ce                	cmp    %ecx,%esi
 5d4:	74 1b                	je     5f1 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d6:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5d8:	a3 04 0a 00 00       	mov    %eax,0xa04
}
 5dd:	5b                   	pop    %ebx
 5de:	5e                   	pop    %esi
 5df:	5f                   	pop    %edi
 5e0:	5d                   	pop    %ebp
 5e1:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5e2:	03 72 04             	add    0x4(%edx),%esi
 5e5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e8:	8b 10                	mov    (%eax),%edx
 5ea:	8b 12                	mov    (%edx),%edx
 5ec:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5ef:	eb db                	jmp    5cc <free+0x3e>
    p->s.size += bp->s.size;
 5f1:	03 53 fc             	add    -0x4(%ebx),%edx
 5f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5f7:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5fa:	89 10                	mov    %edx,(%eax)
 5fc:	eb da                	jmp    5d8 <free+0x4a>

000005fe <morecore>:

static Header*
morecore(uint nu)
{
 5fe:	55                   	push   %ebp
 5ff:	89 e5                	mov    %esp,%ebp
 601:	53                   	push   %ebx
 602:	83 ec 04             	sub    $0x4,%esp
 605:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 607:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 60c:	77 05                	ja     613 <morecore+0x15>
    nu = 4096;
 60e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 613:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 61a:	83 ec 0c             	sub    $0xc,%esp
 61d:	50                   	push   %eax
 61e:	e8 20 fd ff ff       	call   343 <sbrk>
  if(p == (char*)-1)
 623:	83 c4 10             	add    $0x10,%esp
 626:	83 f8 ff             	cmp    $0xffffffff,%eax
 629:	74 1c                	je     647 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 62b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 62e:	83 c0 08             	add    $0x8,%eax
 631:	83 ec 0c             	sub    $0xc,%esp
 634:	50                   	push   %eax
 635:	e8 54 ff ff ff       	call   58e <free>
  return freep;
 63a:	a1 04 0a 00 00       	mov    0xa04,%eax
 63f:	83 c4 10             	add    $0x10,%esp
}
 642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 645:	c9                   	leave  
 646:	c3                   	ret    
    return 0;
 647:	b8 00 00 00 00       	mov    $0x0,%eax
 64c:	eb f4                	jmp    642 <morecore+0x44>

0000064e <malloc>:

void*
malloc(uint nbytes)
{
 64e:	55                   	push   %ebp
 64f:	89 e5                	mov    %esp,%ebp
 651:	53                   	push   %ebx
 652:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	8d 58 07             	lea    0x7(%eax),%ebx
 65b:	c1 eb 03             	shr    $0x3,%ebx
 65e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 661:	8b 0d 04 0a 00 00    	mov    0xa04,%ecx
 667:	85 c9                	test   %ecx,%ecx
 669:	74 04                	je     66f <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66b:	8b 01                	mov    (%ecx),%eax
 66d:	eb 4a                	jmp    6b9 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 66f:	c7 05 04 0a 00 00 08 	movl   $0xa08,0xa04
 676:	0a 00 00 
 679:	c7 05 08 0a 00 00 08 	movl   $0xa08,0xa08
 680:	0a 00 00 
    base.s.size = 0;
 683:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 68a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 68d:	b9 08 0a 00 00       	mov    $0xa08,%ecx
 692:	eb d7                	jmp    66b <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 694:	74 19                	je     6af <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 696:	29 da                	sub    %ebx,%edx
 698:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 69b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 69e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a1:	89 0d 04 0a 00 00    	mov    %ecx,0xa04
      return (void*)(p + 1);
 6a7:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	89 11                	mov    %edx,(%ecx)
 6b3:	eb ec                	jmp    6a1 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b5:	89 c1                	mov    %eax,%ecx
 6b7:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6b9:	8b 50 04             	mov    0x4(%eax),%edx
 6bc:	39 da                	cmp    %ebx,%edx
 6be:	73 d4                	jae    694 <malloc+0x46>
    if(p == freep)
 6c0:	39 05 04 0a 00 00    	cmp    %eax,0xa04
 6c6:	75 ed                	jne    6b5 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6c8:	89 d8                	mov    %ebx,%eax
 6ca:	e8 2f ff ff ff       	call   5fe <morecore>
 6cf:	85 c0                	test   %eax,%eax
 6d1:	75 e2                	jne    6b5 <malloc+0x67>
 6d3:	eb d5                	jmp    6aa <malloc+0x5c>
