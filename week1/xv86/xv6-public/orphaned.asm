
_orphaned:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main() 
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    // printf(1,"overall parent pid: %d\n",getpid());
	int ret = fork();
   f:	e8 07 03 00 00       	call   31b <fork>
	if (ret == 0) 
  14:	85 c0                	test   %eax,%eax
  16:	75 66                	jne    7e <main+0x7e>
	{
		printf(1, "\nchild: pid %d\n", getpid());
  18:	e8 86 03 00 00       	call   3a3 <getpid>
  1d:	52                   	push   %edx
  1e:	50                   	push   %eax
  1f:	68 48 08 00 00       	push   $0x848
  24:	6a 01                	push   $0x1
  26:	e8 f5 04 00 00       	call   520 <printf>
		printf(1, "child: parent pid %d\n", getppid());
  2b:	e8 a3 03 00 00       	call   3d3 <getppid>
  30:	83 c4 0c             	add    $0xc,%esp
  33:	50                   	push   %eax
  34:	68 58 08 00 00       	push   $0x858
  39:	6a 01                	push   $0x1
  3b:	e8 e0 04 00 00       	call   520 <printf>

		sleep(200);
  40:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  47:	e8 67 03 00 00       	call   3b3 <sleep>

		printf(1, "\nchild: pid %d\n", getpid());
  4c:	e8 52 03 00 00       	call   3a3 <getpid>
  51:	83 c4 0c             	add    $0xc,%esp
  54:	50                   	push   %eax
  55:	68 48 08 00 00       	push   $0x848
  5a:	6a 01                	push   $0x1
  5c:	e8 bf 04 00 00       	call   520 <printf>
		printf(1, "child: parent pid %d\n", getppid());
  61:	e8 6d 03 00 00       	call   3d3 <getppid>
  66:	83 c4 0c             	add    $0xc,%esp
  69:	50                   	push   %eax
  6a:	68 58 08 00 00       	push   $0x858
  6f:	6a 01                	push   $0x1
  71:	e8 aa 04 00 00       	call   520 <printf>
  76:	83 c4 10             	add    $0x10,%esp
		printf(1, "parent: parent pid %d \n", getppid());
		printf(1, "parent: child pid %d\n", ret);
	}
	// printf(1,"after the else\n");
	
	exit();
  79:	e8 a5 02 00 00       	call   323 <exit>
		sleep(100);
  7e:	83 ec 0c             	sub    $0xc,%esp
  81:	89 c3                	mov    %eax,%ebx
  83:	6a 64                	push   $0x64
  85:	e8 29 03 00 00       	call   3b3 <sleep>
		printf(1, "\nparent: pid %d\n", getpid());
  8a:	e8 14 03 00 00       	call   3a3 <getpid>
  8f:	83 c4 0c             	add    $0xc,%esp
  92:	50                   	push   %eax
  93:	68 6e 08 00 00       	push   $0x86e
  98:	6a 01                	push   $0x1
  9a:	e8 81 04 00 00       	call   520 <printf>
		printf(1, "parent: parent pid %d \n", getppid());
  9f:	e8 2f 03 00 00       	call   3d3 <getppid>
  a4:	83 c4 0c             	add    $0xc,%esp
  a7:	50                   	push   %eax
  a8:	68 7f 08 00 00       	push   $0x87f
  ad:	6a 01                	push   $0x1
  af:	e8 6c 04 00 00       	call   520 <printf>
		printf(1, "parent: child pid %d\n", ret);
  b4:	83 c4 0c             	add    $0xc,%esp
  b7:	53                   	push   %ebx
  b8:	68 97 08 00 00       	push   $0x897
  bd:	6a 01                	push   $0x1
  bf:	e8 5c 04 00 00       	call   520 <printf>
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	eb b0                	jmp    79 <main+0x79>
  c9:	66 90                	xchg   %ax,%ax
  cb:	66 90                	xchg   %ax,%ax
  cd:	66 90                	xchg   %ax,%ax
  cf:	90                   	nop

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d1:	31 c0                	xor    %eax,%eax
{
  d3:	89 e5                	mov    %esp,%ebp
  d5:	53                   	push   %ebx
  d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  e7:	83 c0 01             	add    $0x1,%eax
  ea:	84 d2                	test   %dl,%dl
  ec:	75 f2                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f1:	89 c8                	mov    %ecx,%eax
  f3:	c9                   	leave  
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 55 08             	mov    0x8(%ebp),%edx
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 10a:	0f b6 02             	movzbl (%edx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	75 17                	jne    128 <strcmp+0x28>
 111:	eb 3a                	jmp    14d <strcmp+0x4d>
 113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 117:	90                   	nop
 118:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 11c:	83 c2 01             	add    $0x1,%edx
 11f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 122:	84 c0                	test   %al,%al
 124:	74 1a                	je     140 <strcmp+0x40>
    p++, q++;
 126:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 128:	0f b6 19             	movzbl (%ecx),%ebx
 12b:	38 c3                	cmp    %al,%bl
 12d:	74 e9                	je     118 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 12f:	29 d8                	sub    %ebx,%eax
}
 131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 134:	c9                   	leave  
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 140:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 144:	31 c0                	xor    %eax,%eax
 146:	29 d8                	sub    %ebx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave  
 14c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 19             	movzbl (%ecx),%ebx
 150:	31 c0                	xor    %eax,%eax
 152:	eb db                	jmp    12f <strcmp+0x2f>
 154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 3a 00             	cmpb   $0x0,(%edx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 c0                	xor    %eax,%eax
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c0 01             	add    $0x1,%eax
 173:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 177:	89 c1                	mov    %eax,%ecx
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	89 c8                	mov    %ecx,%eax
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
 17f:	90                   	nop
  for(n = 0; s[n]; n++)
 180:	31 c9                	xor    %ecx,%ecx
}
 182:	5d                   	pop    %ebp
 183:	89 c8                	mov    %ecx,%eax
 185:	c3                   	ret    
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a5:	89 d0                	mov    %edx,%eax
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	75 12                	jne    1d3 <strchr+0x23>
 1c1:	eb 1d                	jmp    1e0 <strchr+0x30>
 1c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c7:	90                   	nop
 1c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1cc:	83 c0 01             	add    $0x1,%eax
 1cf:	84 d2                	test   %dl,%dl
 1d1:	74 0d                	je     1e0 <strchr+0x30>
    if(*s == c)
 1d3:	38 d1                	cmp    %dl,%cl
 1d5:	75 f1                	jne    1c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1e0:	31 c0                	xor    %eax,%eax
}
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1f9:	31 db                	xor    %ebx,%ebx
{
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1fe:	eb 27                	jmp    227 <gets+0x37>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	57                   	push   %edi
 206:	6a 00                	push   $0x0
 208:	e8 2e 01 00 00       	call   33b <read>
    if(cc < 1)
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	7e 1d                	jle    231 <gets+0x41>
      break;
    buf[i++] = c;
 214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 218:	8b 55 08             	mov    0x8(%ebp),%edx
 21b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 21f:	3c 0a                	cmp    $0xa,%al
 221:	74 1d                	je     240 <gets+0x50>
 223:	3c 0d                	cmp    $0xd,%al
 225:	74 19                	je     240 <gets+0x50>
  for(i=0; i+1 < max; ){
 227:	89 de                	mov    %ebx,%esi
 229:	83 c3 01             	add    $0x1,%ebx
 22c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22f:	7c cf                	jl     200 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 238:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    
  buf[i] = '\0';
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	89 de                	mov    %ebx,%esi
 245:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	push   0x8(%ebp)
 26d:	e8 f1 00 00 00       	call   363 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	push   0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 f4 00 00 00       	call   37b <fstat>
  close(fd);
 287:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 28a:	89 c6                	mov    %eax,%esi
  close(fd);
 28c:	e8 ba 00 00 00       	call   34b <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 02             	movsbl (%edx),%eax
 2ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2c5:	77 1e                	ja     2e5 <atoi+0x35>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2da:	0f be 02             	movsbl (%edx),%eax
 2dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2e0:	80 fb 09             	cmp    $0x9,%bl
 2e3:	76 eb                	jbe    2d0 <atoi+0x20>
  return n;
}
 2e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e8:	89 c8                	mov    %ecx,%eax
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8b 55 08             	mov    0x8(%ebp),%edx
 2fa:	56                   	push   %esi
 2fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	85 c0                	test   %eax,%eax
 300:	7e 13                	jle    315 <memmove+0x25>
 302:	01 d0                	add    %edx,%eax
  dst = vdst;
 304:	89 d7                	mov    %edx,%edi
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 310:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 311:	39 f8                	cmp    %edi,%eax
 313:	75 fb                	jne    310 <memmove+0x20>
  return vdst;
}
 315:	5e                   	pop    %esi
 316:	89 d0                	mov    %edx,%eax
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    

0000031b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31b:	b8 01 00 00 00       	mov    $0x1,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exit>:
SYSCALL(exit)
 323:	b8 02 00 00 00       	mov    $0x2,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <wait>:
SYSCALL(wait)
 32b:	b8 03 00 00 00       	mov    $0x3,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <pipe>:
SYSCALL(pipe)
 333:	b8 04 00 00 00       	mov    $0x4,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <read>:
SYSCALL(read)
 33b:	b8 05 00 00 00       	mov    $0x5,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <write>:
SYSCALL(write)
 343:	b8 10 00 00 00       	mov    $0x10,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <close>:
SYSCALL(close)
 34b:	b8 15 00 00 00       	mov    $0x15,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <kill>:
SYSCALL(kill)
 353:	b8 06 00 00 00       	mov    $0x6,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <exec>:
SYSCALL(exec)
 35b:	b8 07 00 00 00       	mov    $0x7,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <open>:
SYSCALL(open)
 363:	b8 0f 00 00 00       	mov    $0xf,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mknod>:
SYSCALL(mknod)
 36b:	b8 11 00 00 00       	mov    $0x11,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <unlink>:
SYSCALL(unlink)
 373:	b8 12 00 00 00       	mov    $0x12,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <fstat>:
SYSCALL(fstat)
 37b:	b8 08 00 00 00       	mov    $0x8,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <link>:
SYSCALL(link)
 383:	b8 13 00 00 00       	mov    $0x13,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mkdir>:
SYSCALL(mkdir)
 38b:	b8 14 00 00 00       	mov    $0x14,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <chdir>:
SYSCALL(chdir)
 393:	b8 09 00 00 00       	mov    $0x9,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <dup>:
SYSCALL(dup)
 39b:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getpid>:
SYSCALL(getpid)
 3a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <sbrk>:
SYSCALL(sbrk)
 3ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <sleep>:
SYSCALL(sleep)
 3b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <uptime>:
SYSCALL(uptime)
 3bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <hello>:
SYSCALL(hello)
 3c3:	b8 16 00 00 00       	mov    $0x16,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <helloYou>:
SYSCALL(helloYou)
 3cb:	b8 17 00 00 00       	mov    $0x17,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <getppid>:
SYSCALL(getppid)
 3d3:	b8 18 00 00 00       	mov    $0x18,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <get_siblings_info>:
SYSCALL(get_siblings_info)
 3db:	b8 19 00 00 00       	mov    $0x19,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <signalProcess>:
SYSCALL(signalProcess)
 3e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <numvp>:
SYSCALL(numvp)
 3eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <numpp>:
SYSCALL(numpp)
 3f3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <init_counter>:

SYSCALL(init_counter)
 3fb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <update_cnt>:
SYSCALL(update_cnt)
 403:	b8 1e 00 00 00       	mov    $0x1e,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <display_count>:
SYSCALL(display_count)
 40b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <init_counter_1>:
SYSCALL(init_counter_1)
 413:	b8 20 00 00 00       	mov    $0x20,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <update_cnt_1>:
SYSCALL(update_cnt_1)
 41b:	b8 21 00 00 00       	mov    $0x21,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <display_count_1>:
SYSCALL(display_count_1)
 423:	b8 22 00 00 00       	mov    $0x22,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <init_counter_2>:
SYSCALL(init_counter_2)
 42b:	b8 23 00 00 00       	mov    $0x23,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <update_cnt_2>:
SYSCALL(update_cnt_2)
 433:	b8 24 00 00 00       	mov    $0x24,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <display_count_2>:
SYSCALL(display_count_2)
 43b:	b8 25 00 00 00       	mov    $0x25,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <init_mylock>:
SYSCALL(init_mylock)
 443:	b8 26 00 00 00       	mov    $0x26,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <acquire_mylock>:
SYSCALL(acquire_mylock)
 44b:	b8 27 00 00 00       	mov    $0x27,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <release_mylock>:
SYSCALL(release_mylock)
 453:	b8 28 00 00 00       	mov    $0x28,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <holding_mylock>:
 45b:	b8 29 00 00 00       	mov    $0x29,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    
 463:	66 90                	xchg   %ax,%ax
 465:	66 90                	xchg   %ax,%ax
 467:	66 90                	xchg   %ax,%ax
 469:	66 90                	xchg   %ax,%ax
 46b:	66 90                	xchg   %ax,%ax
 46d:	66 90                	xchg   %ax,%ax
 46f:	90                   	nop

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
 479:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 47c:	89 d1                	mov    %edx,%ecx
{
 47e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 481:	85 d2                	test   %edx,%edx
 483:	0f 89 7f 00 00 00    	jns    508 <printint+0x98>
 489:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 48d:	74 79                	je     508 <printint+0x98>
    neg = 1;
 48f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 496:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 498:	31 db                	xor    %ebx,%ebx
 49a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 49d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4a0:	89 c8                	mov    %ecx,%eax
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	89 cf                	mov    %ecx,%edi
 4a6:	f7 75 c4             	divl   -0x3c(%ebp)
 4a9:	0f b6 92 0c 09 00 00 	movzbl 0x90c(%edx),%edx
 4b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4b3:	89 d8                	mov    %ebx,%eax
 4b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4c1:	76 dd                	jbe    4a0 <printint+0x30>
  if(neg)
 4c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4c6:	85 c9                	test   %ecx,%ecx
 4c8:	74 0c                	je     4d6 <printint+0x66>
    buf[i++] = '-';
 4ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4dd:	eb 07                	jmp    4e6 <printint+0x76>
 4df:	90                   	nop
    putc(fd, buf[i]);
 4e0:	0f b6 13             	movzbl (%ebx),%edx
 4e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4e6:	83 ec 04             	sub    $0x4,%esp
 4e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ec:	6a 01                	push   $0x1
 4ee:	56                   	push   %esi
 4ef:	57                   	push   %edi
 4f0:	e8 4e fe ff ff       	call   343 <write>
  while(--i >= 0)
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	39 de                	cmp    %ebx,%esi
 4fa:	75 e4                	jne    4e0 <printint+0x70>
}
 4fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 508:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 50f:	eb 87                	jmp    498 <printint+0x28>
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 529:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 52c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 52f:	0f b6 13             	movzbl (%ebx),%edx
 532:	84 d2                	test   %dl,%dl
 534:	74 6a                	je     5a0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 536:	8d 45 10             	lea    0x10(%ebp),%eax
 539:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 53c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 53f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 541:	89 45 d0             	mov    %eax,-0x30(%ebp)
 544:	eb 36                	jmp    57c <printf+0x5c>
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
 550:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 553:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 558:	83 f8 25             	cmp    $0x25,%eax
 55b:	74 15                	je     572 <printf+0x52>
  write(fd, &c, 1);
 55d:	83 ec 04             	sub    $0x4,%esp
 560:	88 55 e7             	mov    %dl,-0x19(%ebp)
 563:	6a 01                	push   $0x1
 565:	57                   	push   %edi
 566:	56                   	push   %esi
 567:	e8 d7 fd ff ff       	call   343 <write>
 56c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 56f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 572:	0f b6 13             	movzbl (%ebx),%edx
 575:	83 c3 01             	add    $0x1,%ebx
 578:	84 d2                	test   %dl,%dl
 57a:	74 24                	je     5a0 <printf+0x80>
    c = fmt[i] & 0xff;
 57c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 57f:	85 c9                	test   %ecx,%ecx
 581:	74 cd                	je     550 <printf+0x30>
      }
    } else if(state == '%'){
 583:	83 f9 25             	cmp    $0x25,%ecx
 586:	75 ea                	jne    572 <printf+0x52>
      if(c == 'd'){
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	0f 84 07 01 00 00    	je     698 <printf+0x178>
 591:	83 e8 63             	sub    $0x63,%eax
 594:	83 f8 15             	cmp    $0x15,%eax
 597:	77 17                	ja     5b0 <printf+0x90>
 599:	ff 24 85 b4 08 00 00 	jmp    *0x8b4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a3:	5b                   	pop    %ebx
 5a4:	5e                   	pop    %esi
 5a5:	5f                   	pop    %edi
 5a6:	5d                   	pop    %ebp
 5a7:	c3                   	ret    
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 5b6:	6a 01                	push   $0x1
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5be:	e8 80 fd ff ff       	call   343 <write>
        putc(fd, c);
 5c3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 5c7:	83 c4 0c             	add    $0xc,%esp
 5ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5cd:	6a 01                	push   $0x1
 5cf:	57                   	push   %edi
 5d0:	56                   	push   %esi
 5d1:	e8 6d fd ff ff       	call   343 <write>
        putc(fd, c);
 5d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d9:	31 c9                	xor    %ecx,%ecx
 5db:	eb 95                	jmp    572 <printf+0x52>
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5e8:	6a 00                	push   $0x0
 5ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5ed:	8b 10                	mov    (%eax),%edx
 5ef:	89 f0                	mov    %esi,%eax
 5f1:	e8 7a fe ff ff       	call   470 <printint>
        ap++;
 5f6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5fa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fd:	31 c9                	xor    %ecx,%ecx
 5ff:	e9 6e ff ff ff       	jmp    572 <printf+0x52>
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 608:	8b 45 d0             	mov    -0x30(%ebp),%eax
 60b:	8b 10                	mov    (%eax),%edx
        ap++;
 60d:	83 c0 04             	add    $0x4,%eax
 610:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 613:	85 d2                	test   %edx,%edx
 615:	0f 84 8d 00 00 00    	je     6a8 <printf+0x188>
        while(*s != 0){
 61b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 61e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 620:	84 c0                	test   %al,%al
 622:	0f 84 4a ff ff ff    	je     572 <printf+0x52>
 628:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 62b:	89 d3                	mov    %edx,%ebx
 62d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
          s++;
 633:	83 c3 01             	add    $0x1,%ebx
 636:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 639:	6a 01                	push   $0x1
 63b:	57                   	push   %edi
 63c:	56                   	push   %esi
 63d:	e8 01 fd ff ff       	call   343 <write>
        while(*s != 0){
 642:	0f b6 03             	movzbl (%ebx),%eax
 645:	83 c4 10             	add    $0x10,%esp
 648:	84 c0                	test   %al,%al
 64a:	75 e4                	jne    630 <printf+0x110>
      state = 0;
 64c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 64f:	31 c9                	xor    %ecx,%ecx
 651:	e9 1c ff ff ff       	jmp    572 <printf+0x52>
 656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	b9 0a 00 00 00       	mov    $0xa,%ecx
 668:	6a 01                	push   $0x1
 66a:	e9 7b ff ff ff       	jmp    5ea <printf+0xca>
 66f:	90                   	nop
        putc(fd, *ap);
 670:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 676:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 678:	6a 01                	push   $0x1
 67a:	57                   	push   %edi
 67b:	56                   	push   %esi
        putc(fd, *ap);
 67c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 67f:	e8 bf fc ff ff       	call   343 <write>
        ap++;
 684:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 688:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68b:	31 c9                	xor    %ecx,%ecx
 68d:	e9 e0 fe ff ff       	jmp    572 <printf+0x52>
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 698:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 69b:	83 ec 04             	sub    $0x4,%esp
 69e:	e9 2a ff ff ff       	jmp    5cd <printf+0xad>
 6a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6a7:	90                   	nop
          s = "(null)";
 6a8:	ba ad 08 00 00       	mov    $0x8ad,%edx
        while(*s != 0){
 6ad:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6b0:	b8 28 00 00 00       	mov    $0x28,%eax
 6b5:	89 d3                	mov    %edx,%ebx
 6b7:	e9 74 ff ff ff       	jmp    630 <printf+0x110>
 6bc:	66 90                	xchg   %ax,%ax
 6be:	66 90                	xchg   %ax,%ax

000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	a1 b8 0b 00 00       	mov    0xbb8,%eax
{
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	57                   	push   %edi
 6c9:	56                   	push   %esi
 6ca:	53                   	push   %ebx
 6cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6d8:	89 c2                	mov    %eax,%edx
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	39 ca                	cmp    %ecx,%edx
 6de:	73 30                	jae    710 <free+0x50>
 6e0:	39 c1                	cmp    %eax,%ecx
 6e2:	72 04                	jb     6e8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	39 c2                	cmp    %eax,%edx
 6e6:	72 f0                	jb     6d8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 f8                	cmp    %edi,%eax
 6f0:	74 30                	je     722 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6f5:	8b 42 04             	mov    0x4(%edx),%eax
 6f8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6fb:	39 f1                	cmp    %esi,%ecx
 6fd:	74 3a                	je     739 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6ff:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 701:	5b                   	pop    %ebx
  freep = p;
 702:	89 15 b8 0b 00 00    	mov    %edx,0xbb8
}
 708:	5e                   	pop    %esi
 709:	5f                   	pop    %edi
 70a:	5d                   	pop    %ebp
 70b:	c3                   	ret    
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	39 c2                	cmp    %eax,%edx
 712:	72 c4                	jb     6d8 <free+0x18>
 714:	39 c1                	cmp    %eax,%ecx
 716:	73 c0                	jae    6d8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 73 fc             	mov    -0x4(%ebx),%esi
 71b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 71e:	39 f8                	cmp    %edi,%eax
 720:	75 d0                	jne    6f2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 722:	03 70 04             	add    0x4(%eax),%esi
 725:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	8b 02                	mov    (%edx),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 72f:	8b 42 04             	mov    0x4(%edx),%eax
 732:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 735:	39 f1                	cmp    %esi,%ecx
 737:	75 c6                	jne    6ff <free+0x3f>
    p->s.size += bp->s.size;
 739:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 73c:	89 15 b8 0b 00 00    	mov    %edx,0xbb8
    p->s.size += bp->s.size;
 742:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 745:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 748:	89 0a                	mov    %ecx,(%edx)
}
 74a:	5b                   	pop    %ebx
 74b:	5e                   	pop    %esi
 74c:	5f                   	pop    %edi
 74d:	5d                   	pop    %ebp
 74e:	c3                   	ret    
 74f:	90                   	nop

00000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 75c:	8b 3d b8 0b 00 00    	mov    0xbb8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	8d 70 07             	lea    0x7(%eax),%esi
 765:	c1 ee 03             	shr    $0x3,%esi
 768:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 76b:	85 ff                	test   %edi,%edi
 76d:	0f 84 9d 00 00 00    	je     810 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 775:	8b 4a 04             	mov    0x4(%edx),%ecx
 778:	39 f1                	cmp    %esi,%ecx
 77a:	73 6a                	jae    7e6 <malloc+0x96>
 77c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 781:	39 de                	cmp    %ebx,%esi
 783:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 786:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 78d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 790:	eb 17                	jmp    7a9 <malloc+0x59>
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 79a:	8b 48 04             	mov    0x4(%eax),%ecx
 79d:	39 f1                	cmp    %esi,%ecx
 79f:	73 4f                	jae    7f0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a1:	8b 3d b8 0b 00 00    	mov    0xbb8,%edi
 7a7:	89 c2                	mov    %eax,%edx
 7a9:	39 d7                	cmp    %edx,%edi
 7ab:	75 eb                	jne    798 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7ad:	83 ec 0c             	sub    $0xc,%esp
 7b0:	ff 75 e4             	push   -0x1c(%ebp)
 7b3:	e8 f3 fb ff ff       	call   3ab <sbrk>
  if(p == (char*)-1)
 7b8:	83 c4 10             	add    $0x10,%esp
 7bb:	83 f8 ff             	cmp    $0xffffffff,%eax
 7be:	74 1c                	je     7dc <malloc+0x8c>
  hp->s.size = nu;
 7c0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	83 c0 08             	add    $0x8,%eax
 7c9:	50                   	push   %eax
 7ca:	e8 f1 fe ff ff       	call   6c0 <free>
  return freep;
 7cf:	8b 15 b8 0b 00 00    	mov    0xbb8,%edx
      if((p = morecore(nunits)) == 0)
 7d5:	83 c4 10             	add    $0x10,%esp
 7d8:	85 d2                	test   %edx,%edx
 7da:	75 bc                	jne    798 <malloc+0x48>
        return 0;
  }
}
 7dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7df:	31 c0                	xor    %eax,%eax
}
 7e1:	5b                   	pop    %ebx
 7e2:	5e                   	pop    %esi
 7e3:	5f                   	pop    %edi
 7e4:	5d                   	pop    %ebp
 7e5:	c3                   	ret    
    if(p->s.size >= nunits){
 7e6:	89 d0                	mov    %edx,%eax
 7e8:	89 fa                	mov    %edi,%edx
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7f0:	39 ce                	cmp    %ecx,%esi
 7f2:	74 4c                	je     840 <malloc+0xf0>
        p->s.size -= nunits;
 7f4:	29 f1                	sub    %esi,%ecx
 7f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7fc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7ff:	89 15 b8 0b 00 00    	mov    %edx,0xbb8
}
 805:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 808:	83 c0 08             	add    $0x8,%eax
}
 80b:	5b                   	pop    %ebx
 80c:	5e                   	pop    %esi
 80d:	5f                   	pop    %edi
 80e:	5d                   	pop    %ebp
 80f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 810:	c7 05 b8 0b 00 00 bc 	movl   $0xbbc,0xbb8
 817:	0b 00 00 
    base.s.size = 0;
 81a:	bf bc 0b 00 00       	mov    $0xbbc,%edi
    base.s.ptr = freep = prevp = &base;
 81f:	c7 05 bc 0b 00 00 bc 	movl   $0xbbc,0xbbc
 826:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 82b:	c7 05 c0 0b 00 00 00 	movl   $0x0,0xbc0
 832:	00 00 00 
    if(p->s.size >= nunits){
 835:	e9 42 ff ff ff       	jmp    77c <malloc+0x2c>
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 840:	8b 08                	mov    (%eax),%ecx
 842:	89 0a                	mov    %ecx,(%edx)
 844:	eb b9                	jmp    7ff <malloc+0xaf>
