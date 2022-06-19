
_debug:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx

  int ret = fork();
   f:	e8 97 02 00 00       	call   2ab <fork>
  14:	89 c3                	mov    %eax,%ebx
  int st = getpid();
  16:	e8 18 03 00 00       	call   333 <getpid>
  printf(1, "pid =%d", st);
  1b:	83 ec 04             	sub    $0x4,%esp
  1e:	50                   	push   %eax
  1f:	68 d8 07 00 00       	push   $0x7d8
  24:	6a 01                	push   $0x1
  26:	e8 85 04 00 00       	call   4b0 <printf>
  if (ret == 0)
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	85 db                	test   %ebx,%ebx
  30:	75 13                	jne    45 <main+0x45>
  {
    printf(1, "In child\n");
  32:	51                   	push   %ecx
  33:	51                   	push   %ecx
  34:	68 e0 07 00 00       	push   $0x7e0
  39:	6a 01                	push   $0x1
  3b:	e8 70 04 00 00       	call   4b0 <printf>

    exit();
  40:	e8 6e 02 00 00       	call   2b3 <exit>
  }
  else
  {
    int reaped_pid = wait();
  45:	e8 71 02 00 00       	call   2bb <wait>
    printf(1, "Child with pid %d reaped\n", reaped_pid);
  4a:	52                   	push   %edx
  4b:	50                   	push   %eax
  4c:	68 ea 07 00 00       	push   $0x7ea
  51:	6a 01                	push   $0x1
  53:	e8 58 04 00 00       	call   4b0 <printf>
  }

  exit();
  58:	e8 56 02 00 00       	call   2b3 <exit>
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	83 c0 01             	add    $0x1,%eax
  7a:	84 d2                	test   %dl,%dl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  81:	89 c8                	mov    %ecx,%eax
  83:	c9                   	leave  
  84:	c3                   	ret    
  85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 17                	jne    b8 <strcmp+0x28>
  a1:	eb 3a                	jmp    dd <strcmp+0x4d>
  a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a7:	90                   	nop
  a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ac:	83 c2 01             	add    $0x1,%edx
  af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  b2:	84 c0                	test   %al,%al
  b4:	74 1a                	je     d0 <strcmp+0x40>
    p++, q++;
  b6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  b8:	0f b6 19             	movzbl (%ecx),%ebx
  bb:	38 c3                	cmp    %al,%bl
  bd:	74 e9                	je     a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  bf:	29 d8                	sub    %ebx,%eax
}
  c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c4:	c9                   	leave  
  c5:	c3                   	ret    
  c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  d4:	31 c0                	xor    %eax,%eax
  d6:	29 d8                	sub    %ebx,%eax
}
  d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  db:	c9                   	leave  
  dc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  dd:	0f b6 19             	movzbl (%ecx),%ebx
  e0:	31 c0                	xor    %eax,%eax
  e2:	eb db                	jmp    bf <strcmp+0x2f>
  e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 3a 00             	cmpb   $0x0,(%edx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 c0                	xor    %eax,%eax
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c0 01             	add    $0x1,%eax
 103:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 107:	89 c1                	mov    %eax,%ecx
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	89 c8                	mov    %ecx,%eax
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop
  for(n = 0; s[n]; n++)
 110:	31 c9                	xor    %ecx,%ecx
}
 112:	5d                   	pop    %ebp
 113:	89 c8                	mov    %ecx,%eax
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	8b 7d fc             	mov    -0x4(%ebp),%edi
 135:	89 d0                	mov    %edx,%eax
 137:	c9                   	leave  
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 12                	jne    163 <strchr+0x23>
 151:	eb 1d                	jmp    170 <strchr+0x30>
 153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 157:	90                   	nop
 158:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	84 d2                	test   %dl,%dl
 161:	74 0d                	je     170 <strchr+0x30>
    if(*s == c)
 163:	38 d1                	cmp    %dl,%cl
 165:	75 f1                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 185:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 188:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 189:	31 db                	xor    %ebx,%ebx
{
 18b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 18e:	eb 27                	jmp    1b7 <gets+0x37>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	57                   	push   %edi
 196:	6a 00                	push   $0x0
 198:	e8 2e 01 00 00       	call   2cb <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 1d                	jle    1c1 <gets+0x41>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1af:	3c 0a                	cmp    $0xa,%al
 1b1:	74 1d                	je     1d0 <gets+0x50>
 1b3:	3c 0d                	cmp    $0xd,%al
 1b5:	74 19                	je     1d0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1b7:	89 de                	mov    %ebx,%esi
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7c cf                	jl     190 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cb:	5b                   	pop    %ebx
 1cc:	5e                   	pop    %esi
 1cd:	5f                   	pop    %edi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    
  buf[i] = '\0';
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	89 de                	mov    %ebx,%esi
 1d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	push   0x8(%ebp)
 1fd:	e8 f1 00 00 00       	call   2f3 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	push   0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f4 00 00 00       	call   30b <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 ba 00 00 00       	call   2db <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 02             	movsbl (%edx),%eax
 24a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 24d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 250:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 255:	77 1e                	ja     275 <atoi+0x35>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 260:	83 c2 01             	add    $0x1,%edx
 263:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 266:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 26a:	0f be 02             	movsbl (%edx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 278:	89 c8                	mov    %ecx,%eax
 27a:	c9                   	leave  
 27b:	c3                   	ret    
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8b 55 08             	mov    0x8(%ebp),%edx
 28a:	56                   	push   %esi
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c0                	test   %eax,%eax
 290:	7e 13                	jle    2a5 <memmove+0x25>
 292:	01 d0                	add    %edx,%eax
  dst = vdst;
 294:	89 d7                	mov    %edx,%edi
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
  return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <hello>:
SYSCALL(hello)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <helloYou>:
SYSCALL(helloYou)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <getppid>:
SYSCALL(getppid)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <get_siblings_info>:
SYSCALL(get_siblings_info)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <signalProcess>:
SYSCALL(signalProcess)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <numvp>:
SYSCALL(numvp)
 37b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <numpp>:
SYSCALL(numpp)
 383:	b8 1c 00 00 00       	mov    $0x1c,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <init_counter>:

SYSCALL(init_counter)
 38b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <update_cnt>:
SYSCALL(update_cnt)
 393:	b8 1e 00 00 00       	mov    $0x1e,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <display_count>:
SYSCALL(display_count)
 39b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <init_counter_1>:
SYSCALL(init_counter_1)
 3a3:	b8 20 00 00 00       	mov    $0x20,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <update_cnt_1>:
SYSCALL(update_cnt_1)
 3ab:	b8 21 00 00 00       	mov    $0x21,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <display_count_1>:
SYSCALL(display_count_1)
 3b3:	b8 22 00 00 00       	mov    $0x22,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <init_counter_2>:
SYSCALL(init_counter_2)
 3bb:	b8 23 00 00 00       	mov    $0x23,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <update_cnt_2>:
SYSCALL(update_cnt_2)
 3c3:	b8 24 00 00 00       	mov    $0x24,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <display_count_2>:
SYSCALL(display_count_2)
 3cb:	b8 25 00 00 00       	mov    $0x25,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <init_mylock>:
SYSCALL(init_mylock)
 3d3:	b8 26 00 00 00       	mov    $0x26,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <acquire_mylock>:
SYSCALL(acquire_mylock)
 3db:	b8 27 00 00 00       	mov    $0x27,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <release_mylock>:
SYSCALL(release_mylock)
 3e3:	b8 28 00 00 00       	mov    $0x28,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <holding_mylock>:
 3eb:	b8 29 00 00 00       	mov    $0x29,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    
 3f3:	66 90                	xchg   %ax,%ax
 3f5:	66 90                	xchg   %ax,%ax
 3f7:	66 90                	xchg   %ax,%ax
 3f9:	66 90                	xchg   %ax,%ax
 3fb:	66 90                	xchg   %ax,%ax
 3fd:	66 90                	xchg   %ax,%ax
 3ff:	90                   	nop

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
 409:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 40c:	89 d1                	mov    %edx,%ecx
{
 40e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 411:	85 d2                	test   %edx,%edx
 413:	0f 89 7f 00 00 00    	jns    498 <printint+0x98>
 419:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 41d:	74 79                	je     498 <printint+0x98>
    neg = 1;
 41f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 426:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 428:	31 db                	xor    %ebx,%ebx
 42a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 430:	89 c8                	mov    %ecx,%eax
 432:	31 d2                	xor    %edx,%edx
 434:	89 cf                	mov    %ecx,%edi
 436:	f7 75 c4             	divl   -0x3c(%ebp)
 439:	0f b6 92 64 08 00 00 	movzbl 0x864(%edx),%edx
 440:	89 45 c0             	mov    %eax,-0x40(%ebp)
 443:	89 d8                	mov    %ebx,%eax
 445:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 448:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 44b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 44e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 451:	76 dd                	jbe    430 <printint+0x30>
  if(neg)
 453:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 456:	85 c9                	test   %ecx,%ecx
 458:	74 0c                	je     466 <printint+0x66>
    buf[i++] = '-';
 45a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 45f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 461:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 466:	8b 7d b8             	mov    -0x48(%ebp),%edi
 469:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 46d:	eb 07                	jmp    476 <printint+0x76>
 46f:	90                   	nop
    putc(fd, buf[i]);
 470:	0f b6 13             	movzbl (%ebx),%edx
 473:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 476:	83 ec 04             	sub    $0x4,%esp
 479:	88 55 d7             	mov    %dl,-0x29(%ebp)
 47c:	6a 01                	push   $0x1
 47e:	56                   	push   %esi
 47f:	57                   	push   %edi
 480:	e8 4e fe ff ff       	call   2d3 <write>
  while(--i >= 0)
 485:	83 c4 10             	add    $0x10,%esp
 488:	39 de                	cmp    %ebx,%esi
 48a:	75 e4                	jne    470 <printint+0x70>
}
 48c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5f                   	pop    %edi
 492:	5d                   	pop    %ebp
 493:	c3                   	ret    
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 498:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 49f:	eb 87                	jmp    428 <printint+0x28>
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4bc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4bf:	0f b6 13             	movzbl (%ebx),%edx
 4c2:	84 d2                	test   %dl,%dl
 4c4:	74 6a                	je     530 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4c6:	8d 45 10             	lea    0x10(%ebp),%eax
 4c9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4cc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4cf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d4:	eb 36                	jmp    50c <printf+0x5c>
 4d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
 4e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4e3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	74 15                	je     502 <printf+0x52>
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4f3:	6a 01                	push   $0x1
 4f5:	57                   	push   %edi
 4f6:	56                   	push   %esi
 4f7:	e8 d7 fd ff ff       	call   2d3 <write>
 4fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 502:	0f b6 13             	movzbl (%ebx),%edx
 505:	83 c3 01             	add    $0x1,%ebx
 508:	84 d2                	test   %dl,%dl
 50a:	74 24                	je     530 <printf+0x80>
    c = fmt[i] & 0xff;
 50c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 50f:	85 c9                	test   %ecx,%ecx
 511:	74 cd                	je     4e0 <printf+0x30>
      }
    } else if(state == '%'){
 513:	83 f9 25             	cmp    $0x25,%ecx
 516:	75 ea                	jne    502 <printf+0x52>
      if(c == 'd'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	0f 84 07 01 00 00    	je     628 <printf+0x178>
 521:	83 e8 63             	sub    $0x63,%eax
 524:	83 f8 15             	cmp    $0x15,%eax
 527:	77 17                	ja     540 <printf+0x90>
 529:	ff 24 85 0c 08 00 00 	jmp    *0x80c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 530:	8d 65 f4             	lea    -0xc(%ebp),%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
 538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop
  write(fd, &c, 1);
 540:	83 ec 04             	sub    $0x4,%esp
 543:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 546:	6a 01                	push   $0x1
 548:	57                   	push   %edi
 549:	56                   	push   %esi
 54a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 54e:	e8 80 fd ff ff       	call   2d3 <write>
        putc(fd, c);
 553:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 557:	83 c4 0c             	add    $0xc,%esp
 55a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 55d:	6a 01                	push   $0x1
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	e8 6d fd ff ff       	call   2d3 <write>
        putc(fd, c);
 566:	83 c4 10             	add    $0x10,%esp
      state = 0;
 569:	31 c9                	xor    %ecx,%ecx
 56b:	eb 95                	jmp    502 <printf+0x52>
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
 578:	6a 00                	push   $0x0
 57a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 57d:	8b 10                	mov    (%eax),%edx
 57f:	89 f0                	mov    %esi,%eax
 581:	e8 7a fe ff ff       	call   400 <printint>
        ap++;
 586:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 58a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58d:	31 c9                	xor    %ecx,%ecx
 58f:	e9 6e ff ff ff       	jmp    502 <printf+0x52>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 598:	8b 45 d0             	mov    -0x30(%ebp),%eax
 59b:	8b 10                	mov    (%eax),%edx
        ap++;
 59d:	83 c0 04             	add    $0x4,%eax
 5a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5a3:	85 d2                	test   %edx,%edx
 5a5:	0f 84 8d 00 00 00    	je     638 <printf+0x188>
        while(*s != 0){
 5ab:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5ae:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5b0:	84 c0                	test   %al,%al
 5b2:	0f 84 4a ff ff ff    	je     502 <printf+0x52>
 5b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5bb:	89 d3                	mov    %edx,%ebx
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5c3:	83 c3 01             	add    $0x1,%ebx
 5c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5c9:	6a 01                	push   $0x1
 5cb:	57                   	push   %edi
 5cc:	56                   	push   %esi
 5cd:	e8 01 fd ff ff       	call   2d3 <write>
        while(*s != 0){
 5d2:	0f b6 03             	movzbl (%ebx),%eax
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	84 c0                	test   %al,%al
 5da:	75 e4                	jne    5c0 <printf+0x110>
      state = 0;
 5dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5df:	31 c9                	xor    %ecx,%ecx
 5e1:	e9 1c ff ff ff       	jmp    502 <printf+0x52>
 5e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f8:	6a 01                	push   $0x1
 5fa:	e9 7b ff ff ff       	jmp    57a <printf+0xca>
 5ff:	90                   	nop
        putc(fd, *ap);
 600:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 606:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 608:	6a 01                	push   $0x1
 60a:	57                   	push   %edi
 60b:	56                   	push   %esi
        putc(fd, *ap);
 60c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 60f:	e8 bf fc ff ff       	call   2d3 <write>
        ap++;
 614:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 618:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61b:	31 c9                	xor    %ecx,%ecx
 61d:	e9 e0 fe ff ff       	jmp    502 <printf+0x52>
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 628:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 62b:	83 ec 04             	sub    $0x4,%esp
 62e:	e9 2a ff ff ff       	jmp    55d <printf+0xad>
 633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 637:	90                   	nop
          s = "(null)";
 638:	ba 04 08 00 00       	mov    $0x804,%edx
        while(*s != 0){
 63d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 640:	b8 28 00 00 00       	mov    $0x28,%eax
 645:	89 d3                	mov    %edx,%ebx
 647:	e9 74 ff ff ff       	jmp    5c0 <printf+0x110>
 64c:	66 90                	xchg   %ax,%ax
 64e:	66 90                	xchg   %ax,%ax

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 10 0b 00 00       	mov    0xb10,%eax
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 65e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 668:	89 c2                	mov    %eax,%edx
 66a:	8b 00                	mov    (%eax),%eax
 66c:	39 ca                	cmp    %ecx,%edx
 66e:	73 30                	jae    6a0 <free+0x50>
 670:	39 c1                	cmp    %eax,%ecx
 672:	72 04                	jb     678 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	39 c2                	cmp    %eax,%edx
 676:	72 f0                	jb     668 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67e:	39 f8                	cmp    %edi,%eax
 680:	74 30                	je     6b2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 682:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 685:	8b 42 04             	mov    0x4(%edx),%eax
 688:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 68b:	39 f1                	cmp    %esi,%ecx
 68d:	74 3a                	je     6c9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 68f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 691:	5b                   	pop    %ebx
  freep = p;
 692:	89 15 10 0b 00 00    	mov    %edx,0xb10
}
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	39 c2                	cmp    %eax,%edx
 6a2:	72 c4                	jb     668 <free+0x18>
 6a4:	39 c1                	cmp    %eax,%ecx
 6a6:	73 c0                	jae    668 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 f8                	cmp    %edi,%eax
 6b0:	75 d0                	jne    682 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6b2:	03 70 04             	add    0x4(%eax),%esi
 6b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	8b 02                	mov    (%edx),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6bf:	8b 42 04             	mov    0x4(%edx),%eax
 6c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6c5:	39 f1                	cmp    %esi,%ecx
 6c7:	75 c6                	jne    68f <free+0x3f>
    p->s.size += bp->s.size;
 6c9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6cc:	89 15 10 0b 00 00    	mov    %edx,0xb10
    p->s.size += bp->s.size;
 6d2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6d8:	89 0a                	mov    %ecx,(%edx)
}
 6da:	5b                   	pop    %ebx
 6db:	5e                   	pop    %esi
 6dc:	5f                   	pop    %edi
 6dd:	5d                   	pop    %ebp
 6de:	c3                   	ret    
 6df:	90                   	nop

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 3d 10 0b 00 00    	mov    0xb10,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 70 07             	lea    0x7(%eax),%esi
 6f5:	c1 ee 03             	shr    $0x3,%esi
 6f8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6fb:	85 ff                	test   %edi,%edi
 6fd:	0f 84 9d 00 00 00    	je     7a0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 703:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 705:	8b 4a 04             	mov    0x4(%edx),%ecx
 708:	39 f1                	cmp    %esi,%ecx
 70a:	73 6a                	jae    776 <malloc+0x96>
 70c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 711:	39 de                	cmp    %ebx,%esi
 713:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 716:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 71d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 720:	eb 17                	jmp    739 <malloc+0x59>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 72a:	8b 48 04             	mov    0x4(%eax),%ecx
 72d:	39 f1                	cmp    %esi,%ecx
 72f:	73 4f                	jae    780 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 731:	8b 3d 10 0b 00 00    	mov    0xb10,%edi
 737:	89 c2                	mov    %eax,%edx
 739:	39 d7                	cmp    %edx,%edi
 73b:	75 eb                	jne    728 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 73d:	83 ec 0c             	sub    $0xc,%esp
 740:	ff 75 e4             	push   -0x1c(%ebp)
 743:	e8 f3 fb ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 748:	83 c4 10             	add    $0x10,%esp
 74b:	83 f8 ff             	cmp    $0xffffffff,%eax
 74e:	74 1c                	je     76c <malloc+0x8c>
  hp->s.size = nu;
 750:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 753:	83 ec 0c             	sub    $0xc,%esp
 756:	83 c0 08             	add    $0x8,%eax
 759:	50                   	push   %eax
 75a:	e8 f1 fe ff ff       	call   650 <free>
  return freep;
 75f:	8b 15 10 0b 00 00    	mov    0xb10,%edx
      if((p = morecore(nunits)) == 0)
 765:	83 c4 10             	add    $0x10,%esp
 768:	85 d2                	test   %edx,%edx
 76a:	75 bc                	jne    728 <malloc+0x48>
        return 0;
  }
}
 76c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 76f:	31 c0                	xor    %eax,%eax
}
 771:	5b                   	pop    %ebx
 772:	5e                   	pop    %esi
 773:	5f                   	pop    %edi
 774:	5d                   	pop    %ebp
 775:	c3                   	ret    
    if(p->s.size >= nunits){
 776:	89 d0                	mov    %edx,%eax
 778:	89 fa                	mov    %edi,%edx
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 780:	39 ce                	cmp    %ecx,%esi
 782:	74 4c                	je     7d0 <malloc+0xf0>
        p->s.size -= nunits;
 784:	29 f1                	sub    %esi,%ecx
 786:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 789:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 78c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 78f:	89 15 10 0b 00 00    	mov    %edx,0xb10
}
 795:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 798:	83 c0 08             	add    $0x8,%eax
}
 79b:	5b                   	pop    %ebx
 79c:	5e                   	pop    %esi
 79d:	5f                   	pop    %edi
 79e:	5d                   	pop    %ebp
 79f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7a0:	c7 05 10 0b 00 00 14 	movl   $0xb14,0xb10
 7a7:	0b 00 00 
    base.s.size = 0;
 7aa:	bf 14 0b 00 00       	mov    $0xb14,%edi
    base.s.ptr = freep = prevp = &base;
 7af:	c7 05 14 0b 00 00 14 	movl   $0xb14,0xb14
 7b6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7bb:	c7 05 18 0b 00 00 00 	movl   $0x0,0xb18
 7c2:	00 00 00 
    if(p->s.size >= nunits){
 7c5:	e9 42 ff ff ff       	jmp    70c <malloc+0x2c>
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb b9                	jmp    78f <malloc+0xaf>
