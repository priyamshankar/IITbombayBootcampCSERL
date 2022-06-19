
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
   f:	e8 17 03 00 00       	call   32b <fork>
	if(ret == 0) 
  14:	85 c0                	test   %eax,%eax
  16:	75 2d                	jne    45 <main+0x45>
  18:	bb 40 42 0f 00       	mov    $0xf4240,%ebx
  1d:	8d 76 00             	lea    0x0(%esi),%esi
	{ 
		for (int i = 0; i < MAX_SZ; ++i)
		{
			sleep(5e1);
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	6a 32                	push   $0x32
  25:	e8 99 03 00 00       	call   3c3 <sleep>
			printf(1, "child: Not_paused\n");
  2a:	59                   	pop    %ecx
  2b:	58                   	pop    %eax
  2c:	68 58 08 00 00       	push   $0x858
  31:	6a 01                	push   $0x1
  33:	e8 f8 04 00 00       	call   530 <printf>
		for (int i = 0; i < MAX_SZ; ++i)
  38:	83 c4 10             	add    $0x10,%esp
  3b:	83 eb 01             	sub    $0x1,%ebx
  3e:	75 e0                	jne    20 <main+0x20>
		}

		exit();
  40:	e8 ee 02 00 00       	call   333 <exit>
	}

	sleep(5e2);
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	89 c3                	mov    %eax,%ebx
  4a:	68 f4 01 00 00       	push   $0x1f4
  4f:	e8 6f 03 00 00       	call   3c3 <sleep>
	printf(1, "parent: sending pause signal to child \n");
  54:	58                   	pop    %eax
  55:	5a                   	pop    %edx
  56:	68 80 08 00 00       	push   $0x880
  5b:	6a 01                	push   $0x1
  5d:	e8 ce 04 00 00       	call   530 <printf>
	signalProcess(ret, SIGNAL_PAUSE);
  62:	59                   	pop    %ecx
  63:	58                   	pop    %eax
  64:	68 6b 08 00 00       	push   $0x86b
  69:	53                   	push   %ebx
  6a:	e8 84 03 00 00       	call   3f3 <signalProcess>
	
	sleep(5e2);
  6f:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  76:	e8 48 03 00 00       	call   3c3 <sleep>
	printf(1, "parent: sending continue signal to child \n");
  7b:	58                   	pop    %eax
  7c:	5a                   	pop    %edx
  7d:	68 a8 08 00 00       	push   $0x8a8
  82:	6a 01                	push   $0x1
  84:	e8 a7 04 00 00       	call   530 <printf>
	signalProcess(ret, SIGNAL_CONTINUE);
  89:	59                   	pop    %ecx
  8a:	58                   	pop    %eax
  8b:	68 71 08 00 00       	push   $0x871
  90:	53                   	push   %ebx
  91:	e8 5d 03 00 00       	call   3f3 <signalProcess>
	
	sleep(5e2);
  96:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  9d:	e8 21 03 00 00       	call   3c3 <sleep>
	printf(1, "parent: sending kill signal to child \n");
  a2:	58                   	pop    %eax
  a3:	5a                   	pop    %edx
  a4:	68 d4 08 00 00       	push   $0x8d4
  a9:	6a 01                	push   $0x1
  ab:	e8 80 04 00 00       	call   530 <printf>
	signalProcess(ret, SIGNAL_KILL);
  b0:	59                   	pop    %ecx
  b1:	58                   	pop    %eax
  b2:	68 7a 08 00 00       	push   $0x87a
  b7:	53                   	push   %ebx
  b8:	e8 36 03 00 00       	call   3f3 <signalProcess>
	
	wait();
  bd:	e8 79 02 00 00       	call   33b <wait>
	printf(1, "parent: child has terminated \n");
  c2:	58                   	pop    %eax
  c3:	5a                   	pop    %edx
  c4:	68 fc 08 00 00       	push   $0x8fc
  c9:	6a 01                	push   $0x1
  cb:	e8 60 04 00 00       	call   530 <printf>
	exit();
  d0:	e8 5e 02 00 00       	call   333 <exit>
  d5:	66 90                	xchg   %ax,%ax
  d7:	66 90                	xchg   %ax,%ax
  d9:	66 90                	xchg   %ax,%ax
  db:	66 90                	xchg   %ax,%ax
  dd:	66 90                	xchg   %ax,%ax
  df:	90                   	nop

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e1:	31 c0                	xor    %eax,%eax
{
  e3:	89 e5                	mov    %esp,%ebp
  e5:	53                   	push   %ebx
  e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f7:	83 c0 01             	add    $0x1,%eax
  fa:	84 d2                	test   %dl,%dl
  fc:	75 f2                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
  fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 101:	89 c8                	mov    %ecx,%eax
 103:	c9                   	leave  
 104:	c3                   	ret    
 105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 17                	jne    138 <strcmp+0x28>
 121:	eb 3a                	jmp    15d <strcmp+0x4d>
 123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 127:	90                   	nop
 128:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 12c:	83 c2 01             	add    $0x1,%edx
 12f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 132:	84 c0                	test   %al,%al
 134:	74 1a                	je     150 <strcmp+0x40>
    p++, q++;
 136:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 138:	0f b6 19             	movzbl (%ecx),%ebx
 13b:	38 c3                	cmp    %al,%bl
 13d:	74 e9                	je     128 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 13f:	29 d8                	sub    %ebx,%eax
}
 141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 144:	c9                   	leave  
 145:	c3                   	ret    
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 150:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 154:	31 c0                	xor    %eax,%eax
 156:	29 d8                	sub    %ebx,%eax
}
 158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 15b:	c9                   	leave  
 15c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 15d:	0f b6 19             	movzbl (%ecx),%ebx
 160:	31 c0                	xor    %eax,%eax
 162:	eb db                	jmp    13f <strcmp+0x2f>
 164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <strlen>:

uint
strlen(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 3a 00             	cmpb   $0x0,(%edx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 c0                	xor    %eax,%eax
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c0 01             	add    $0x1,%eax
 183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 187:	89 c1                	mov    %eax,%ecx
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	89 c8                	mov    %ecx,%eax
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    
 18f:	90                   	nop
  for(n = 0; s[n]; n++)
 190:	31 c9                	xor    %ecx,%ecx
}
 192:	5d                   	pop    %ebp
 193:	89 c8                	mov    %ecx,%eax
 195:	c3                   	ret    
 196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	75 12                	jne    1e3 <strchr+0x23>
 1d1:	eb 1d                	jmp    1f0 <strchr+0x30>
 1d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d7:	90                   	nop
 1d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	84 d2                	test   %dl,%dl
 1e1:	74 0d                	je     1f0 <strchr+0x30>
    if(*s == c)
 1e3:	38 d1                	cmp    %dl,%cl
 1e5:	75 f1                	jne    1d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1f0:	31 c0                	xor    %eax,%eax
}
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    
 1f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 205:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 208:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 209:	31 db                	xor    %ebx,%ebx
{
 20b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 20e:	eb 27                	jmp    237 <gets+0x37>
    cc = read(0, &c, 1);
 210:	83 ec 04             	sub    $0x4,%esp
 213:	6a 01                	push   $0x1
 215:	57                   	push   %edi
 216:	6a 00                	push   $0x0
 218:	e8 2e 01 00 00       	call   34b <read>
    if(cc < 1)
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	7e 1d                	jle    241 <gets+0x41>
      break;
    buf[i++] = c;
 224:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 228:	8b 55 08             	mov    0x8(%ebp),%edx
 22b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 22f:	3c 0a                	cmp    $0xa,%al
 231:	74 1d                	je     250 <gets+0x50>
 233:	3c 0d                	cmp    $0xd,%al
 235:	74 19                	je     250 <gets+0x50>
  for(i=0; i+1 < max; ){
 237:	89 de                	mov    %ebx,%esi
 239:	83 c3 01             	add    $0x1,%ebx
 23c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23f:	7c cf                	jl     210 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 248:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24b:	5b                   	pop    %ebx
 24c:	5e                   	pop    %esi
 24d:	5f                   	pop    %edi
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    
  buf[i] = '\0';
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	89 de                	mov    %ebx,%esi
 255:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 259:	8d 65 f4             	lea    -0xc(%ebp),%esp
 25c:	5b                   	pop    %ebx
 25d:	5e                   	pop    %esi
 25e:	5f                   	pop    %edi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop

00000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 275:	83 ec 08             	sub    $0x8,%esp
 278:	6a 00                	push   $0x0
 27a:	ff 75 08             	push   0x8(%ebp)
 27d:	e8 f1 00 00 00       	call   373 <open>
  if(fd < 0)
 282:	83 c4 10             	add    $0x10,%esp
 285:	85 c0                	test   %eax,%eax
 287:	78 27                	js     2b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	ff 75 0c             	push   0xc(%ebp)
 28f:	89 c3                	mov    %eax,%ebx
 291:	50                   	push   %eax
 292:	e8 f4 00 00 00       	call   38b <fstat>
  close(fd);
 297:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 29a:	89 c6                	mov    %eax,%esi
  close(fd);
 29c:	e8 ba 00 00 00       	call   35b <close>
  return r;
 2a1:	83 c4 10             	add    $0x10,%esp
}
 2a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a7:	89 f0                	mov    %esi,%eax
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b5:	eb ed                	jmp    2a4 <stat+0x34>
 2b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2be:	66 90                	xchg   %ax,%ax

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	0f be 02             	movsbl (%edx),%eax
 2ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2d5:	77 1e                	ja     2f5 <atoi+0x35>
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2ea:	0f be 02             	movsbl (%edx),%eax
 2ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2f0:	80 fb 09             	cmp    $0x9,%bl
 2f3:	76 eb                	jbe    2e0 <atoi+0x20>
  return n;
}
 2f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 45 10             	mov    0x10(%ebp),%eax
 307:	8b 55 08             	mov    0x8(%ebp),%edx
 30a:	56                   	push   %esi
 30b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 c0                	test   %eax,%eax
 310:	7e 13                	jle    325 <memmove+0x25>
 312:	01 d0                	add    %edx,%eax
  dst = vdst;
 314:	89 d7                	mov    %edx,%edi
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 320:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 321:	39 f8                	cmp    %edi,%eax
 323:	75 fb                	jne    320 <memmove+0x20>
  return vdst;
}
 325:	5e                   	pop    %esi
 326:	89 d0                	mov    %edx,%eax
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    

0000032b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32b:	b8 01 00 00 00       	mov    $0x1,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <exit>:
SYSCALL(exit)
 333:	b8 02 00 00 00       	mov    $0x2,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <wait>:
SYSCALL(wait)
 33b:	b8 03 00 00 00       	mov    $0x3,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <pipe>:
SYSCALL(pipe)
 343:	b8 04 00 00 00       	mov    $0x4,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <read>:
SYSCALL(read)
 34b:	b8 05 00 00 00       	mov    $0x5,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <write>:
SYSCALL(write)
 353:	b8 10 00 00 00       	mov    $0x10,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <close>:
SYSCALL(close)
 35b:	b8 15 00 00 00       	mov    $0x15,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <kill>:
SYSCALL(kill)
 363:	b8 06 00 00 00       	mov    $0x6,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <exec>:
SYSCALL(exec)
 36b:	b8 07 00 00 00       	mov    $0x7,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <open>:
SYSCALL(open)
 373:	b8 0f 00 00 00       	mov    $0xf,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <mknod>:
SYSCALL(mknod)
 37b:	b8 11 00 00 00       	mov    $0x11,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <unlink>:
SYSCALL(unlink)
 383:	b8 12 00 00 00       	mov    $0x12,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <fstat>:
SYSCALL(fstat)
 38b:	b8 08 00 00 00       	mov    $0x8,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <link>:
SYSCALL(link)
 393:	b8 13 00 00 00       	mov    $0x13,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <mkdir>:
SYSCALL(mkdir)
 39b:	b8 14 00 00 00       	mov    $0x14,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <chdir>:
SYSCALL(chdir)
 3a3:	b8 09 00 00 00       	mov    $0x9,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <dup>:
SYSCALL(dup)
 3ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <getpid>:
SYSCALL(getpid)
 3b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <sbrk>:
SYSCALL(sbrk)
 3bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <sleep>:
SYSCALL(sleep)
 3c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <uptime>:
SYSCALL(uptime)
 3cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <hello>:
SYSCALL(hello)
 3d3:	b8 16 00 00 00       	mov    $0x16,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <helloYou>:
SYSCALL(helloYou)
 3db:	b8 17 00 00 00       	mov    $0x17,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getppid>:
SYSCALL(getppid)
 3e3:	b8 18 00 00 00       	mov    $0x18,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <get_siblings_info>:
SYSCALL(get_siblings_info)
 3eb:	b8 19 00 00 00       	mov    $0x19,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <signalProcess>:
SYSCALL(signalProcess)
 3f3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <numvp>:
SYSCALL(numvp)
 3fb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <numpp>:
SYSCALL(numpp)
 403:	b8 1c 00 00 00       	mov    $0x1c,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <init_counter>:

SYSCALL(init_counter)
 40b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <update_cnt>:
SYSCALL(update_cnt)
 413:	b8 1e 00 00 00       	mov    $0x1e,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <display_count>:
SYSCALL(display_count)
 41b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <init_counter_1>:
SYSCALL(init_counter_1)
 423:	b8 20 00 00 00       	mov    $0x20,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <update_cnt_1>:
SYSCALL(update_cnt_1)
 42b:	b8 21 00 00 00       	mov    $0x21,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <display_count_1>:
SYSCALL(display_count_1)
 433:	b8 22 00 00 00       	mov    $0x22,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <init_counter_2>:
SYSCALL(init_counter_2)
 43b:	b8 23 00 00 00       	mov    $0x23,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <update_cnt_2>:
SYSCALL(update_cnt_2)
 443:	b8 24 00 00 00       	mov    $0x24,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <display_count_2>:
SYSCALL(display_count_2)
 44b:	b8 25 00 00 00       	mov    $0x25,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <init_mylock>:
SYSCALL(init_mylock)
 453:	b8 26 00 00 00       	mov    $0x26,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <acquire_mylock>:
SYSCALL(acquire_mylock)
 45b:	b8 27 00 00 00       	mov    $0x27,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <release_mylock>:
SYSCALL(release_mylock)
 463:	b8 28 00 00 00       	mov    $0x28,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <holding_mylock>:
 46b:	b8 29 00 00 00       	mov    $0x29,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    
 473:	66 90                	xchg   %ax,%ax
 475:	66 90                	xchg   %ax,%ax
 477:	66 90                	xchg   %ax,%ax
 479:	66 90                	xchg   %ax,%ax
 47b:	66 90                	xchg   %ax,%ax
 47d:	66 90                	xchg   %ax,%ax
 47f:	90                   	nop

00000480 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 3c             	sub    $0x3c,%esp
 489:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 48c:	89 d1                	mov    %edx,%ecx
{
 48e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 491:	85 d2                	test   %edx,%edx
 493:	0f 89 7f 00 00 00    	jns    518 <printint+0x98>
 499:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 49d:	74 79                	je     518 <printint+0x98>
    neg = 1;
 49f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4a8:	31 db                	xor    %ebx,%ebx
 4aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4b0:	89 c8                	mov    %ecx,%eax
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	89 cf                	mov    %ecx,%edi
 4b6:	f7 75 c4             	divl   -0x3c(%ebp)
 4b9:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
 4c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4c3:	89 d8                	mov    %ebx,%eax
 4c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4d1:	76 dd                	jbe    4b0 <printint+0x30>
  if(neg)
 4d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4d6:	85 c9                	test   %ecx,%ecx
 4d8:	74 0c                	je     4e6 <printint+0x66>
    buf[i++] = '-';
 4da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4ed:	eb 07                	jmp    4f6 <printint+0x76>
 4ef:	90                   	nop
    putc(fd, buf[i]);
 4f0:	0f b6 13             	movzbl (%ebx),%edx
 4f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4f6:	83 ec 04             	sub    $0x4,%esp
 4f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4fc:	6a 01                	push   $0x1
 4fe:	56                   	push   %esi
 4ff:	57                   	push   %edi
 500:	e8 4e fe ff ff       	call   353 <write>
  while(--i >= 0)
 505:	83 c4 10             	add    $0x10,%esp
 508:	39 de                	cmp    %ebx,%esi
 50a:	75 e4                	jne    4f0 <printint+0x70>
}
 50c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50f:	5b                   	pop    %ebx
 510:	5e                   	pop    %esi
 511:	5f                   	pop    %edi
 512:	5d                   	pop    %ebp
 513:	c3                   	ret    
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 518:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 51f:	eb 87                	jmp    4a8 <printint+0x28>
 521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop

00000530 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 539:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 53c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 53f:	0f b6 13             	movzbl (%ebx),%edx
 542:	84 d2                	test   %dl,%dl
 544:	74 6a                	je     5b0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 546:	8d 45 10             	lea    0x10(%ebp),%eax
 549:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 54c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 54f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 551:	89 45 d0             	mov    %eax,-0x30(%ebp)
 554:	eb 36                	jmp    58c <printf+0x5c>
 556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
 560:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 563:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	74 15                	je     582 <printf+0x52>
  write(fd, &c, 1);
 56d:	83 ec 04             	sub    $0x4,%esp
 570:	88 55 e7             	mov    %dl,-0x19(%ebp)
 573:	6a 01                	push   $0x1
 575:	57                   	push   %edi
 576:	56                   	push   %esi
 577:	e8 d7 fd ff ff       	call   353 <write>
 57c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 57f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 582:	0f b6 13             	movzbl (%ebx),%edx
 585:	83 c3 01             	add    $0x1,%ebx
 588:	84 d2                	test   %dl,%dl
 58a:	74 24                	je     5b0 <printf+0x80>
    c = fmt[i] & 0xff;
 58c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 58f:	85 c9                	test   %ecx,%ecx
 591:	74 cd                	je     560 <printf+0x30>
      }
    } else if(state == '%'){
 593:	83 f9 25             	cmp    $0x25,%ecx
 596:	75 ea                	jne    582 <printf+0x52>
      if(c == 'd'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	0f 84 07 01 00 00    	je     6a8 <printf+0x178>
 5a1:	83 e8 63             	sub    $0x63,%eax
 5a4:	83 f8 15             	cmp    $0x15,%eax
 5a7:	77 17                	ja     5c0 <printf+0x90>
 5a9:	ff 24 85 24 09 00 00 	jmp    *0x924(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b3:	5b                   	pop    %ebx
 5b4:	5e                   	pop    %esi
 5b5:	5f                   	pop    %edi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 5c6:	6a 01                	push   $0x1
 5c8:	57                   	push   %edi
 5c9:	56                   	push   %esi
 5ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ce:	e8 80 fd ff ff       	call   353 <write>
        putc(fd, c);
 5d3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 5d7:	83 c4 0c             	add    $0xc,%esp
 5da:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5dd:	6a 01                	push   $0x1
 5df:	57                   	push   %edi
 5e0:	56                   	push   %esi
 5e1:	e8 6d fd ff ff       	call   353 <write>
        putc(fd, c);
 5e6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e9:	31 c9                	xor    %ecx,%ecx
 5eb:	eb 95                	jmp    582 <printf+0x52>
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5f8:	6a 00                	push   $0x0
 5fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5fd:	8b 10                	mov    (%eax),%edx
 5ff:	89 f0                	mov    %esi,%eax
 601:	e8 7a fe ff ff       	call   480 <printint>
        ap++;
 606:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 60a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60d:	31 c9                	xor    %ecx,%ecx
 60f:	e9 6e ff ff ff       	jmp    582 <printf+0x52>
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 618:	8b 45 d0             	mov    -0x30(%ebp),%eax
 61b:	8b 10                	mov    (%eax),%edx
        ap++;
 61d:	83 c0 04             	add    $0x4,%eax
 620:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 623:	85 d2                	test   %edx,%edx
 625:	0f 84 8d 00 00 00    	je     6b8 <printf+0x188>
        while(*s != 0){
 62b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 62e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 630:	84 c0                	test   %al,%al
 632:	0f 84 4a ff ff ff    	je     582 <printf+0x52>
 638:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 63b:	89 d3                	mov    %edx,%ebx
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
          s++;
 643:	83 c3 01             	add    $0x1,%ebx
 646:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 649:	6a 01                	push   $0x1
 64b:	57                   	push   %edi
 64c:	56                   	push   %esi
 64d:	e8 01 fd ff ff       	call   353 <write>
        while(*s != 0){
 652:	0f b6 03             	movzbl (%ebx),%eax
 655:	83 c4 10             	add    $0x10,%esp
 658:	84 c0                	test   %al,%al
 65a:	75 e4                	jne    640 <printf+0x110>
      state = 0;
 65c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 65f:	31 c9                	xor    %ecx,%ecx
 661:	e9 1c ff ff ff       	jmp    582 <printf+0x52>
 666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 0a 00 00 00       	mov    $0xa,%ecx
 678:	6a 01                	push   $0x1
 67a:	e9 7b ff ff ff       	jmp    5fa <printf+0xca>
 67f:	90                   	nop
        putc(fd, *ap);
 680:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 683:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 686:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 688:	6a 01                	push   $0x1
 68a:	57                   	push   %edi
 68b:	56                   	push   %esi
        putc(fd, *ap);
 68c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 68f:	e8 bf fc ff ff       	call   353 <write>
        ap++;
 694:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 698:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69b:	31 c9                	xor    %ecx,%ecx
 69d:	e9 e0 fe ff ff       	jmp    582 <printf+0x52>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 6a8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6ab:	83 ec 04             	sub    $0x4,%esp
 6ae:	e9 2a ff ff ff       	jmp    5dd <printf+0xad>
 6b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b7:	90                   	nop
          s = "(null)";
 6b8:	ba 1b 09 00 00       	mov    $0x91b,%edx
        while(*s != 0){
 6bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6c0:	b8 28 00 00 00       	mov    $0x28,%eax
 6c5:	89 d3                	mov    %edx,%ebx
 6c7:	e9 74 ff ff ff       	jmp    640 <printf+0x110>
 6cc:	66 90                	xchg   %ax,%ax
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 28 0c 00 00       	mov    0xc28,%eax
{
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6e8:	89 c2                	mov    %eax,%edx
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	39 ca                	cmp    %ecx,%edx
 6ee:	73 30                	jae    720 <free+0x50>
 6f0:	39 c1                	cmp    %eax,%ecx
 6f2:	72 04                	jb     6f8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	39 c2                	cmp    %eax,%edx
 6f6:	72 f0                	jb     6e8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 f8                	cmp    %edi,%eax
 700:	74 30                	je     732 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 705:	8b 42 04             	mov    0x4(%edx),%eax
 708:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 70b:	39 f1                	cmp    %esi,%ecx
 70d:	74 3a                	je     749 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 70f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 711:	5b                   	pop    %ebx
  freep = p;
 712:	89 15 28 0c 00 00    	mov    %edx,0xc28
}
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 c2                	cmp    %eax,%edx
 722:	72 c4                	jb     6e8 <free+0x18>
 724:	39 c1                	cmp    %eax,%ecx
 726:	73 c0                	jae    6e8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72e:	39 f8                	cmp    %edi,%eax
 730:	75 d0                	jne    702 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 732:	03 70 04             	add    0x4(%eax),%esi
 735:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	8b 02                	mov    (%edx),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 73f:	8b 42 04             	mov    0x4(%edx),%eax
 742:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 745:	39 f1                	cmp    %esi,%ecx
 747:	75 c6                	jne    70f <free+0x3f>
    p->s.size += bp->s.size;
 749:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 74c:	89 15 28 0c 00 00    	mov    %edx,0xc28
    p->s.size += bp->s.size;
 752:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 755:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 758:	89 0a                	mov    %ecx,(%edx)
}
 75a:	5b                   	pop    %ebx
 75b:	5e                   	pop    %esi
 75c:	5f                   	pop    %edi
 75d:	5d                   	pop    %ebp
 75e:	c3                   	ret    
 75f:	90                   	nop

00000760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 76c:	8b 3d 28 0c 00 00    	mov    0xc28,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8d 70 07             	lea    0x7(%eax),%esi
 775:	c1 ee 03             	shr    $0x3,%esi
 778:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 77b:	85 ff                	test   %edi,%edi
 77d:	0f 84 9d 00 00 00    	je     820 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 785:	8b 4a 04             	mov    0x4(%edx),%ecx
 788:	39 f1                	cmp    %esi,%ecx
 78a:	73 6a                	jae    7f6 <malloc+0x96>
 78c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 791:	39 de                	cmp    %ebx,%esi
 793:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 796:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 79d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7a0:	eb 17                	jmp    7b9 <malloc+0x59>
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7aa:	8b 48 04             	mov    0x4(%eax),%ecx
 7ad:	39 f1                	cmp    %esi,%ecx
 7af:	73 4f                	jae    800 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b1:	8b 3d 28 0c 00 00    	mov    0xc28,%edi
 7b7:	89 c2                	mov    %eax,%edx
 7b9:	39 d7                	cmp    %edx,%edi
 7bb:	75 eb                	jne    7a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7bd:	83 ec 0c             	sub    $0xc,%esp
 7c0:	ff 75 e4             	push   -0x1c(%ebp)
 7c3:	e8 f3 fb ff ff       	call   3bb <sbrk>
  if(p == (char*)-1)
 7c8:	83 c4 10             	add    $0x10,%esp
 7cb:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ce:	74 1c                	je     7ec <malloc+0x8c>
  hp->s.size = nu;
 7d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7d3:	83 ec 0c             	sub    $0xc,%esp
 7d6:	83 c0 08             	add    $0x8,%eax
 7d9:	50                   	push   %eax
 7da:	e8 f1 fe ff ff       	call   6d0 <free>
  return freep;
 7df:	8b 15 28 0c 00 00    	mov    0xc28,%edx
      if((p = morecore(nunits)) == 0)
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	85 d2                	test   %edx,%edx
 7ea:	75 bc                	jne    7a8 <malloc+0x48>
        return 0;
  }
}
 7ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7ef:	31 c0                	xor    %eax,%eax
}
 7f1:	5b                   	pop    %ebx
 7f2:	5e                   	pop    %esi
 7f3:	5f                   	pop    %edi
 7f4:	5d                   	pop    %ebp
 7f5:	c3                   	ret    
    if(p->s.size >= nunits){
 7f6:	89 d0                	mov    %edx,%eax
 7f8:	89 fa                	mov    %edi,%edx
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 800:	39 ce                	cmp    %ecx,%esi
 802:	74 4c                	je     850 <malloc+0xf0>
        p->s.size -= nunits;
 804:	29 f1                	sub    %esi,%ecx
 806:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 809:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 80c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 80f:	89 15 28 0c 00 00    	mov    %edx,0xc28
}
 815:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 818:	83 c0 08             	add    $0x8,%eax
}
 81b:	5b                   	pop    %ebx
 81c:	5e                   	pop    %esi
 81d:	5f                   	pop    %edi
 81e:	5d                   	pop    %ebp
 81f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 820:	c7 05 28 0c 00 00 2c 	movl   $0xc2c,0xc28
 827:	0c 00 00 
    base.s.size = 0;
 82a:	bf 2c 0c 00 00       	mov    $0xc2c,%edi
    base.s.ptr = freep = prevp = &base;
 82f:	c7 05 2c 0c 00 00 2c 	movl   $0xc2c,0xc2c
 836:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 83b:	c7 05 30 0c 00 00 00 	movl   $0x0,0xc30
 842:	00 00 00 
    if(p->s.size >= nunits){
 845:	e9 42 ff ff ff       	jmp    78c <malloc+0x2c>
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 850:	8b 08                	mov    (%eax),%ecx
 852:	89 0a                	mov    %ecx,(%edx)
 854:	eb b9                	jmp    80f <malloc+0xaf>
