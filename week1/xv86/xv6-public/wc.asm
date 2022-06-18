
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	be 00 00 00 00       	mov    $0x0,%esi
  15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	83 ec 04             	sub    $0x4,%esp
  26:	68 00 02 00 00       	push   $0x200
  2b:	68 20 0b 00 00       	push   $0xb20
  30:	ff 75 08             	push   0x8(%ebp)
  33:	e8 e1 02 00 00       	call   319 <read>
  38:	89 c7                	mov    %eax,%edi
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	7e 54                	jle    95 <wc+0x95>
    for(i=0; i<n; i++){
  41:	bb 00 00 00 00       	mov    $0x0,%ebx
  46:	eb 22                	jmp    6a <wc+0x6a>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	0f be c0             	movsbl %al,%eax
  4e:	50                   	push   %eax
  4f:	68 94 07 00 00       	push   $0x794
  54:	e8 86 01 00 00       	call   1df <strchr>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	74 22                	je     82 <wc+0x82>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  67:	83 c3 01             	add    $0x1,%ebx
  6a:	39 fb                	cmp    %edi,%ebx
  6c:	7d b5                	jge    23 <wc+0x23>
      c++;
  6e:	83 c6 01             	add    $0x1,%esi
      if(buf[i] == '\n')
  71:	0f b6 83 20 0b 00 00 	movzbl 0xb20(%ebx),%eax
  78:	3c 0a                	cmp    $0xa,%al
  7a:	75 cc                	jne    48 <wc+0x48>
        l++;
  7c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80:	eb c6                	jmp    48 <wc+0x48>
      else if(!inword){
  82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  86:	75 df                	jne    67 <wc+0x67>
        w++;
  88:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
        inword = 1;
  8c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  93:	eb d2                	jmp    67 <wc+0x67>
      }
    }
  }
  if(n < 0){
  95:	78 24                	js     bb <wc+0xbb>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  97:	83 ec 08             	sub    $0x8,%esp
  9a:	ff 75 0c             	push   0xc(%ebp)
  9d:	56                   	push   %esi
  9e:	ff 75 dc             	push   -0x24(%ebp)
  a1:	ff 75 e0             	push   -0x20(%ebp)
  a4:	68 aa 07 00 00       	push   $0x7aa
  a9:	6a 01                	push   $0x1
  ab:	e8 36 04 00 00       	call   4e6 <printf>
}
  b0:	83 c4 20             	add    $0x20,%esp
  b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b6:	5b                   	pop    %ebx
  b7:	5e                   	pop    %esi
  b8:	5f                   	pop    %edi
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    
    printf(1, "wc: read error\n");
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	68 9a 07 00 00       	push   $0x79a
  c3:	6a 01                	push   $0x1
  c5:	e8 1c 04 00 00       	call   4e6 <printf>
    exit();
  ca:	e8 32 02 00 00       	call   301 <exit>

000000cf <main>:

int
main(int argc, char *argv[])
{
  cf:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d3:	83 e4 f0             	and    $0xfffffff0,%esp
  d6:	ff 71 fc             	push   -0x4(%ecx)
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	57                   	push   %edi
  dd:	56                   	push   %esi
  de:	53                   	push   %ebx
  df:	51                   	push   %ecx
  e0:	83 ec 18             	sub    $0x18,%esp
  e3:	8b 01                	mov    (%ecx),%eax
  e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e8:	8b 51 04             	mov    0x4(%ecx),%edx
  eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  ee:	83 f8 01             	cmp    $0x1,%eax
  f1:	7e 07                	jle    fa <main+0x2b>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f3:	be 01 00 00 00       	mov    $0x1,%esi
  f8:	eb 2d                	jmp    127 <main+0x58>
    wc(0, "");
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	68 a9 07 00 00       	push   $0x7a9
 102:	6a 00                	push   $0x0
 104:	e8 f7 fe ff ff       	call   0 <wc>
    exit();
 109:	e8 f3 01 00 00       	call   301 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	ff 37                	push   (%edi)
 113:	50                   	push   %eax
 114:	e8 e7 fe ff ff       	call   0 <wc>
    close(fd);
 119:	89 1c 24             	mov    %ebx,(%esp)
 11c:	e8 08 02 00 00       	call   329 <close>
  for(i = 1; i < argc; i++){
 121:	83 c6 01             	add    $0x1,%esi
 124:	83 c4 10             	add    $0x10,%esp
 127:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 12a:	7d 31                	jge    15d <main+0x8e>
    if((fd = open(argv[i], 0)) < 0){
 12c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12f:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 132:	83 ec 08             	sub    $0x8,%esp
 135:	6a 00                	push   $0x0
 137:	ff 37                	push   (%edi)
 139:	e8 03 02 00 00       	call   341 <open>
 13e:	89 c3                	mov    %eax,%ebx
 140:	83 c4 10             	add    $0x10,%esp
 143:	85 c0                	test   %eax,%eax
 145:	79 c7                	jns    10e <main+0x3f>
      printf(1, "wc: cannot open %s\n", argv[i]);
 147:	83 ec 04             	sub    $0x4,%esp
 14a:	ff 37                	push   (%edi)
 14c:	68 b7 07 00 00       	push   $0x7b7
 151:	6a 01                	push   $0x1
 153:	e8 8e 03 00 00       	call   4e6 <printf>
      exit();
 158:	e8 a4 01 00 00       	call   301 <exit>
  }
  exit();
 15d:	e8 9f 01 00 00       	call   301 <exit>

00000162 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	56                   	push   %esi
 166:	53                   	push   %ebx
 167:	8b 75 08             	mov    0x8(%ebp),%esi
 16a:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16d:	89 f0                	mov    %esi,%eax
 16f:	89 d1                	mov    %edx,%ecx
 171:	83 c2 01             	add    $0x1,%edx
 174:	89 c3                	mov    %eax,%ebx
 176:	83 c0 01             	add    $0x1,%eax
 179:	0f b6 09             	movzbl (%ecx),%ecx
 17c:	88 0b                	mov    %cl,(%ebx)
 17e:	84 c9                	test   %cl,%cl
 180:	75 ed                	jne    16f <strcpy+0xd>
    ;
  return os;
}
 182:	89 f0                	mov    %esi,%eax
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    

00000188 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 191:	eb 06                	jmp    199 <strcmp+0x11>
    p++, q++;
 193:	83 c1 01             	add    $0x1,%ecx
 196:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 199:	0f b6 01             	movzbl (%ecx),%eax
 19c:	84 c0                	test   %al,%al
 19e:	74 04                	je     1a4 <strcmp+0x1c>
 1a0:	3a 02                	cmp    (%edx),%al
 1a2:	74 ef                	je     193 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 1a4:	0f b6 c0             	movzbl %al,%eax
 1a7:	0f b6 12             	movzbl (%edx),%edx
 1aa:	29 d0                	sub    %edx,%eax
}
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <strlen>:

uint
strlen(const char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b4:	b8 00 00 00 00       	mov    $0x0,%eax
 1b9:	eb 03                	jmp    1be <strlen+0x10>
 1bb:	83 c0 01             	add    $0x1,%eax
 1be:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1c2:	75 f7                	jne    1bb <strlen+0xd>
    ;
  return n;
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	57                   	push   %edi
 1ca:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d5:	fc                   	cld    
 1d6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d8:	89 d0                	mov    %edx,%eax
 1da:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <strchr>:

char*
strchr(const char *s, char c)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1e9:	eb 03                	jmp    1ee <strchr+0xf>
 1eb:	83 c0 01             	add    $0x1,%eax
 1ee:	0f b6 10             	movzbl (%eax),%edx
 1f1:	84 d2                	test   %dl,%dl
 1f3:	74 06                	je     1fb <strchr+0x1c>
    if(*s == c)
 1f5:	38 ca                	cmp    %cl,%dl
 1f7:	75 f2                	jne    1eb <strchr+0xc>
 1f9:	eb 05                	jmp    200 <strchr+0x21>
      return (char*)s;
  return 0;
 1fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 200:	5d                   	pop    %ebp
 201:	c3                   	ret    

00000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	57                   	push   %edi
 206:	56                   	push   %esi
 207:	53                   	push   %ebx
 208:	83 ec 1c             	sub    $0x1c,%esp
 20b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	bb 00 00 00 00       	mov    $0x0,%ebx
 213:	89 de                	mov    %ebx,%esi
 215:	83 c3 01             	add    $0x1,%ebx
 218:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21b:	7d 2e                	jge    24b <gets+0x49>
    cc = read(0, &c, 1);
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	6a 01                	push   $0x1
 222:	8d 45 e7             	lea    -0x19(%ebp),%eax
 225:	50                   	push   %eax
 226:	6a 00                	push   $0x0
 228:	e8 ec 00 00 00       	call   319 <read>
    if(cc < 1)
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	7e 17                	jle    24b <gets+0x49>
      break;
    buf[i++] = c;
 234:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 238:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 23b:	3c 0a                	cmp    $0xa,%al
 23d:	0f 94 c2             	sete   %dl
 240:	3c 0d                	cmp    $0xd,%al
 242:	0f 94 c0             	sete   %al
 245:	08 c2                	or     %al,%dl
 247:	74 ca                	je     213 <gets+0x11>
    buf[i++] = c;
 249:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 24b:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 24f:	89 f8                	mov    %edi,%eax
 251:	8d 65 f4             	lea    -0xc(%ebp),%esp
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5f                   	pop    %edi
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    

00000259 <stat>:

int
stat(const char *n, struct stat *st)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	56                   	push   %esi
 25d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	83 ec 08             	sub    $0x8,%esp
 261:	6a 00                	push   $0x0
 263:	ff 75 08             	push   0x8(%ebp)
 266:	e8 d6 00 00 00       	call   341 <open>
  if(fd < 0)
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	85 c0                	test   %eax,%eax
 270:	78 24                	js     296 <stat+0x3d>
 272:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	ff 75 0c             	push   0xc(%ebp)
 27a:	50                   	push   %eax
 27b:	e8 d9 00 00 00       	call   359 <fstat>
 280:	89 c6                	mov    %eax,%esi
  close(fd);
 282:	89 1c 24             	mov    %ebx,(%esp)
 285:	e8 9f 00 00 00       	call   329 <close>
  return r;
 28a:	83 c4 10             	add    $0x10,%esp
}
 28d:	89 f0                	mov    %esi,%eax
 28f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 292:	5b                   	pop    %ebx
 293:	5e                   	pop    %esi
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    
    return -1;
 296:	be ff ff ff ff       	mov    $0xffffffff,%esi
 29b:	eb f0                	jmp    28d <stat+0x34>

0000029d <atoi>:

int
atoi(const char *s)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	53                   	push   %ebx
 2a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2a4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2a9:	eb 10                	jmp    2bb <atoi+0x1e>
    n = n*10 + *s++ - '0';
 2ab:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2ae:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2b1:	83 c1 01             	add    $0x1,%ecx
 2b4:	0f be c0             	movsbl %al,%eax
 2b7:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 2bb:	0f b6 01             	movzbl (%ecx),%eax
 2be:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2c1:	80 fb 09             	cmp    $0x9,%bl
 2c4:	76 e5                	jbe    2ab <atoi+0xe>
  return n;
}
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	8b 75 08             	mov    0x8(%ebp),%esi
 2d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2d8:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2db:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2dd:	eb 0d                	jmp    2ec <memmove+0x1f>
    *dst++ = *src++;
 2df:	0f b6 01             	movzbl (%ecx),%eax
 2e2:	88 02                	mov    %al,(%edx)
 2e4:	8d 49 01             	lea    0x1(%ecx),%ecx
 2e7:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2ea:	89 d8                	mov    %ebx,%eax
 2ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2ef:	85 c0                	test   %eax,%eax
 2f1:	7f ec                	jg     2df <memmove+0x12>
  return vdst;
}
 2f3:	89 f0                	mov    %esi,%eax
 2f5:	5b                   	pop    %ebx
 2f6:	5e                   	pop    %esi
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret    

000002f9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exit>:
SYSCALL(exit)
 301:	b8 02 00 00 00       	mov    $0x2,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <wait>:
SYSCALL(wait)
 309:	b8 03 00 00 00       	mov    $0x3,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <pipe>:
SYSCALL(pipe)
 311:	b8 04 00 00 00       	mov    $0x4,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <read>:
SYSCALL(read)
 319:	b8 05 00 00 00       	mov    $0x5,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <write>:
SYSCALL(write)
 321:	b8 10 00 00 00       	mov    $0x10,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <close>:
SYSCALL(close)
 329:	b8 15 00 00 00       	mov    $0x15,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <kill>:
SYSCALL(kill)
 331:	b8 06 00 00 00       	mov    $0x6,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <exec>:
SYSCALL(exec)
 339:	b8 07 00 00 00       	mov    $0x7,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <open>:
SYSCALL(open)
 341:	b8 0f 00 00 00       	mov    $0xf,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <mknod>:
SYSCALL(mknod)
 349:	b8 11 00 00 00       	mov    $0x11,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <unlink>:
SYSCALL(unlink)
 351:	b8 12 00 00 00       	mov    $0x12,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <fstat>:
SYSCALL(fstat)
 359:	b8 08 00 00 00       	mov    $0x8,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <link>:
SYSCALL(link)
 361:	b8 13 00 00 00       	mov    $0x13,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mkdir>:
SYSCALL(mkdir)
 369:	b8 14 00 00 00       	mov    $0x14,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <chdir>:
SYSCALL(chdir)
 371:	b8 09 00 00 00       	mov    $0x9,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <dup>:
SYSCALL(dup)
 379:	b8 0a 00 00 00       	mov    $0xa,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <getpid>:
SYSCALL(getpid)
 381:	b8 0b 00 00 00       	mov    $0xb,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sbrk>:
SYSCALL(sbrk)
 389:	b8 0c 00 00 00       	mov    $0xc,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <sleep>:
SYSCALL(sleep)
 391:	b8 0d 00 00 00       	mov    $0xd,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <uptime>:
SYSCALL(uptime)
 399:	b8 0e 00 00 00       	mov    $0xe,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <hello>:
SYSCALL(hello)
 3a1:	b8 16 00 00 00       	mov    $0x16,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <helloYou>:
SYSCALL(helloYou)
 3a9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <getppid>:
SYSCALL(getppid)
 3b1:	b8 18 00 00 00       	mov    $0x18,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <get_siblings_info>:
SYSCALL(get_siblings_info)
 3b9:	b8 19 00 00 00       	mov    $0x19,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <signalProcess>:
SYSCALL(signalProcess)
 3c1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <numvp>:
SYSCALL(numvp)
 3c9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <numpp>:
SYSCALL(numpp)
 3d1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <init_counter>:

SYSCALL(init_counter)
 3d9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <update_cnt>:
SYSCALL(update_cnt)
 3e1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <display_count>:
SYSCALL(display_count)
 3e9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <init_counter_1>:
SYSCALL(init_counter_1)
 3f1:	b8 20 00 00 00       	mov    $0x20,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <update_cnt_1>:
SYSCALL(update_cnt_1)
 3f9:	b8 21 00 00 00       	mov    $0x21,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <display_count_1>:
SYSCALL(display_count_1)
 401:	b8 22 00 00 00       	mov    $0x22,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <init_counter_2>:
SYSCALL(init_counter_2)
 409:	b8 23 00 00 00       	mov    $0x23,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <update_cnt_2>:
SYSCALL(update_cnt_2)
 411:	b8 24 00 00 00       	mov    $0x24,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <display_count_2>:
SYSCALL(display_count_2)
 419:	b8 25 00 00 00       	mov    $0x25,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <init_mylock>:
SYSCALL(init_mylock)
 421:	b8 26 00 00 00       	mov    $0x26,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <acquire_mylock>:
SYSCALL(acquire_mylock)
 429:	b8 27 00 00 00       	mov    $0x27,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <release_mylock>:
SYSCALL(release_mylock)
 431:	b8 28 00 00 00       	mov    $0x28,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <holding_mylock>:
 439:	b8 29 00 00 00       	mov    $0x29,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	83 ec 1c             	sub    $0x1c,%esp
 447:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 44a:	6a 01                	push   $0x1
 44c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 44f:	52                   	push   %edx
 450:	50                   	push   %eax
 451:	e8 cb fe ff ff       	call   321 <write>
}
 456:	83 c4 10             	add    $0x10,%esp
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	57                   	push   %edi
 45f:	56                   	push   %esi
 460:	53                   	push   %ebx
 461:	83 ec 2c             	sub    $0x2c,%esp
 464:	89 45 d0             	mov    %eax,-0x30(%ebp)
 467:	89 d0                	mov    %edx,%eax
 469:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 46f:	0f 95 c1             	setne  %cl
 472:	c1 ea 1f             	shr    $0x1f,%edx
 475:	84 d1                	test   %dl,%cl
 477:	74 44                	je     4bd <printint+0x62>
    neg = 1;
    x = -xx;
 479:	f7 d8                	neg    %eax
 47b:	89 c1                	mov    %eax,%ecx
    neg = 1;
 47d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 484:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 489:	89 c8                	mov    %ecx,%eax
 48b:	ba 00 00 00 00       	mov    $0x0,%edx
 490:	f7 f6                	div    %esi
 492:	89 df                	mov    %ebx,%edi
 494:	83 c3 01             	add    $0x1,%ebx
 497:	0f b6 92 2c 08 00 00 	movzbl 0x82c(%edx),%edx
 49e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 4a2:	89 ca                	mov    %ecx,%edx
 4a4:	89 c1                	mov    %eax,%ecx
 4a6:	39 d6                	cmp    %edx,%esi
 4a8:	76 df                	jbe    489 <printint+0x2e>
  if(neg)
 4aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4ae:	74 31                	je     4e1 <printint+0x86>
    buf[i++] = '-';
 4b0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4b5:	8d 5f 02             	lea    0x2(%edi),%ebx
 4b8:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4bb:	eb 17                	jmp    4d4 <printint+0x79>
    x = xx;
 4bd:	89 c1                	mov    %eax,%ecx
  neg = 0;
 4bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4c6:	eb bc                	jmp    484 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 4c8:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4cd:	89 f0                	mov    %esi,%eax
 4cf:	e8 6d ff ff ff       	call   441 <putc>
  while(--i >= 0)
 4d4:	83 eb 01             	sub    $0x1,%ebx
 4d7:	79 ef                	jns    4c8 <printint+0x6d>
}
 4d9:	83 c4 2c             	add    $0x2c,%esp
 4dc:	5b                   	pop    %ebx
 4dd:	5e                   	pop    %esi
 4de:	5f                   	pop    %edi
 4df:	5d                   	pop    %ebp
 4e0:	c3                   	ret    
 4e1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4e4:	eb ee                	jmp    4d4 <printint+0x79>

000004e6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	57                   	push   %edi
 4ea:	56                   	push   %esi
 4eb:	53                   	push   %ebx
 4ec:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ef:	8d 45 10             	lea    0x10(%ebp),%eax
 4f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4f5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4fa:	bb 00 00 00 00       	mov    $0x0,%ebx
 4ff:	eb 14                	jmp    515 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 501:	89 fa                	mov    %edi,%edx
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	e8 36 ff ff ff       	call   441 <putc>
 50b:	eb 05                	jmp    512 <printf+0x2c>
      }
    } else if(state == '%'){
 50d:	83 fe 25             	cmp    $0x25,%esi
 510:	74 25                	je     537 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 512:	83 c3 01             	add    $0x1,%ebx
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 51c:	84 c0                	test   %al,%al
 51e:	0f 84 20 01 00 00    	je     644 <printf+0x15e>
    c = fmt[i] & 0xff;
 524:	0f be f8             	movsbl %al,%edi
 527:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 52a:	85 f6                	test   %esi,%esi
 52c:	75 df                	jne    50d <printf+0x27>
      if(c == '%'){
 52e:	83 f8 25             	cmp    $0x25,%eax
 531:	75 ce                	jne    501 <printf+0x1b>
        state = '%';
 533:	89 c6                	mov    %eax,%esi
 535:	eb db                	jmp    512 <printf+0x2c>
      if(c == 'd'){
 537:	83 f8 25             	cmp    $0x25,%eax
 53a:	0f 84 cf 00 00 00    	je     60f <printf+0x129>
 540:	0f 8c dd 00 00 00    	jl     623 <printf+0x13d>
 546:	83 f8 78             	cmp    $0x78,%eax
 549:	0f 8f d4 00 00 00    	jg     623 <printf+0x13d>
 54f:	83 f8 63             	cmp    $0x63,%eax
 552:	0f 8c cb 00 00 00    	jl     623 <printf+0x13d>
 558:	83 e8 63             	sub    $0x63,%eax
 55b:	83 f8 15             	cmp    $0x15,%eax
 55e:	0f 87 bf 00 00 00    	ja     623 <printf+0x13d>
 564:	ff 24 85 d4 07 00 00 	jmp    *0x7d4(,%eax,4)
        printint(fd, *ap, 10, 1);
 56b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 56e:	8b 17                	mov    (%edi),%edx
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	6a 01                	push   $0x1
 575:	b9 0a 00 00 00       	mov    $0xa,%ecx
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	e8 d9 fe ff ff       	call   45b <printint>
        ap++;
 582:	83 c7 04             	add    $0x4,%edi
 585:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 588:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58b:	be 00 00 00 00       	mov    $0x0,%esi
 590:	eb 80                	jmp    512 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 595:	8b 17                	mov    (%edi),%edx
 597:	83 ec 0c             	sub    $0xc,%esp
 59a:	6a 00                	push   $0x0
 59c:	b9 10 00 00 00       	mov    $0x10,%ecx
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	e8 b2 fe ff ff       	call   45b <printint>
        ap++;
 5a9:	83 c7 04             	add    $0x4,%edi
 5ac:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b2:	be 00 00 00 00       	mov    $0x0,%esi
 5b7:	e9 56 ff ff ff       	jmp    512 <printf+0x2c>
        s = (char*)*ap;
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	8b 30                	mov    (%eax),%esi
        ap++;
 5c1:	83 c0 04             	add    $0x4,%eax
 5c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5c7:	85 f6                	test   %esi,%esi
 5c9:	75 15                	jne    5e0 <printf+0xfa>
          s = "(null)";
 5cb:	be cb 07 00 00       	mov    $0x7cb,%esi
 5d0:	eb 0e                	jmp    5e0 <printf+0xfa>
          putc(fd, *s);
 5d2:	0f be d2             	movsbl %dl,%edx
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	e8 64 fe ff ff       	call   441 <putc>
          s++;
 5dd:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5e0:	0f b6 16             	movzbl (%esi),%edx
 5e3:	84 d2                	test   %dl,%dl
 5e5:	75 eb                	jne    5d2 <printf+0xec>
      state = 0;
 5e7:	be 00 00 00 00       	mov    $0x0,%esi
 5ec:	e9 21 ff ff ff       	jmp    512 <printf+0x2c>
        putc(fd, *ap);
 5f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5f4:	0f be 17             	movsbl (%edi),%edx
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	e8 42 fe ff ff       	call   441 <putc>
        ap++;
 5ff:	83 c7 04             	add    $0x4,%edi
 602:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 605:	be 00 00 00 00       	mov    $0x0,%esi
 60a:	e9 03 ff ff ff       	jmp    512 <printf+0x2c>
        putc(fd, c);
 60f:	89 fa                	mov    %edi,%edx
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	e8 28 fe ff ff       	call   441 <putc>
      state = 0;
 619:	be 00 00 00 00       	mov    $0x0,%esi
 61e:	e9 ef fe ff ff       	jmp    512 <printf+0x2c>
        putc(fd, '%');
 623:	ba 25 00 00 00       	mov    $0x25,%edx
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	e8 11 fe ff ff       	call   441 <putc>
        putc(fd, c);
 630:	89 fa                	mov    %edi,%edx
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	e8 07 fe ff ff       	call   441 <putc>
      state = 0;
 63a:	be 00 00 00 00       	mov    $0x0,%esi
 63f:	e9 ce fe ff ff       	jmp    512 <printf+0x2c>
    }
  }
}
 644:	8d 65 f4             	lea    -0xc(%ebp),%esp
 647:	5b                   	pop    %ebx
 648:	5e                   	pop    %esi
 649:	5f                   	pop    %edi
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret    

0000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	55                   	push   %ebp
 64d:	89 e5                	mov    %esp,%ebp
 64f:	57                   	push   %edi
 650:	56                   	push   %esi
 651:	53                   	push   %ebx
 652:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 655:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	a1 20 0d 00 00       	mov    0xd20,%eax
 65d:	eb 02                	jmp    661 <free+0x15>
 65f:	89 d0                	mov    %edx,%eax
 661:	39 c8                	cmp    %ecx,%eax
 663:	73 04                	jae    669 <free+0x1d>
 665:	39 08                	cmp    %ecx,(%eax)
 667:	77 12                	ja     67b <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 669:	8b 10                	mov    (%eax),%edx
 66b:	39 c2                	cmp    %eax,%edx
 66d:	77 f0                	ja     65f <free+0x13>
 66f:	39 c8                	cmp    %ecx,%eax
 671:	72 08                	jb     67b <free+0x2f>
 673:	39 ca                	cmp    %ecx,%edx
 675:	77 04                	ja     67b <free+0x2f>
 677:	89 d0                	mov    %edx,%eax
 679:	eb e6                	jmp    661 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 67b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 681:	8b 10                	mov    (%eax),%edx
 683:	39 d7                	cmp    %edx,%edi
 685:	74 19                	je     6a0 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 687:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 690:	39 ce                	cmp    %ecx,%esi
 692:	74 1b                	je     6af <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 694:	89 08                	mov    %ecx,(%eax)
  freep = p;
 696:	a3 20 0d 00 00       	mov    %eax,0xd20
}
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	5f                   	pop    %edi
 69e:	5d                   	pop    %ebp
 69f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6a0:	03 72 04             	add    0x4(%edx),%esi
 6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 12                	mov    (%edx),%edx
 6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6ad:	eb db                	jmp    68a <free+0x3e>
    p->s.size += bp->s.size;
 6af:	03 53 fc             	add    -0x4(%ebx),%edx
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b8:	89 10                	mov    %edx,(%eax)
 6ba:	eb da                	jmp    696 <free+0x4a>

000006bc <morecore>:

static Header*
morecore(uint nu)
{
 6bc:	55                   	push   %ebp
 6bd:	89 e5                	mov    %esp,%ebp
 6bf:	53                   	push   %ebx
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6c5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6ca:	77 05                	ja     6d1 <morecore+0x15>
    nu = 4096;
 6cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6d1:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6d8:	83 ec 0c             	sub    $0xc,%esp
 6db:	50                   	push   %eax
 6dc:	e8 a8 fc ff ff       	call   389 <sbrk>
  if(p == (char*)-1)
 6e1:	83 c4 10             	add    $0x10,%esp
 6e4:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e7:	74 1c                	je     705 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6e9:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ec:	83 c0 08             	add    $0x8,%eax
 6ef:	83 ec 0c             	sub    $0xc,%esp
 6f2:	50                   	push   %eax
 6f3:	e8 54 ff ff ff       	call   64c <free>
  return freep;
 6f8:	a1 20 0d 00 00       	mov    0xd20,%eax
 6fd:	83 c4 10             	add    $0x10,%esp
}
 700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 703:	c9                   	leave  
 704:	c3                   	ret    
    return 0;
 705:	b8 00 00 00 00       	mov    $0x0,%eax
 70a:	eb f4                	jmp    700 <morecore+0x44>

0000070c <malloc>:

void*
malloc(uint nbytes)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	53                   	push   %ebx
 710:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 713:	8b 45 08             	mov    0x8(%ebp),%eax
 716:	8d 58 07             	lea    0x7(%eax),%ebx
 719:	c1 eb 03             	shr    $0x3,%ebx
 71c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 71f:	8b 0d 20 0d 00 00    	mov    0xd20,%ecx
 725:	85 c9                	test   %ecx,%ecx
 727:	74 04                	je     72d <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 729:	8b 01                	mov    (%ecx),%eax
 72b:	eb 4a                	jmp    777 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 72d:	c7 05 20 0d 00 00 24 	movl   $0xd24,0xd20
 734:	0d 00 00 
 737:	c7 05 24 0d 00 00 24 	movl   $0xd24,0xd24
 73e:	0d 00 00 
    base.s.size = 0;
 741:	c7 05 28 0d 00 00 00 	movl   $0x0,0xd28
 748:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 74b:	b9 24 0d 00 00       	mov    $0xd24,%ecx
 750:	eb d7                	jmp    729 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 752:	74 19                	je     76d <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 754:	29 da                	sub    %ebx,%edx
 756:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 759:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 75c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 75f:	89 0d 20 0d 00 00    	mov    %ecx,0xd20
      return (void*)(p + 1);
 765:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 76b:	c9                   	leave  
 76c:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 76d:	8b 10                	mov    (%eax),%edx
 76f:	89 11                	mov    %edx,(%ecx)
 771:	eb ec                	jmp    75f <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	89 c1                	mov    %eax,%ecx
 775:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 777:	8b 50 04             	mov    0x4(%eax),%edx
 77a:	39 da                	cmp    %ebx,%edx
 77c:	73 d4                	jae    752 <malloc+0x46>
    if(p == freep)
 77e:	39 05 20 0d 00 00    	cmp    %eax,0xd20
 784:	75 ed                	jne    773 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 786:	89 d8                	mov    %ebx,%eax
 788:	e8 2f ff ff ff       	call   6bc <morecore>
 78d:	85 c0                	test   %eax,%eax
 78f:	75 e2                	jne    773 <malloc+0x67>
 791:	eb d5                	jmp    768 <malloc+0x5c>
