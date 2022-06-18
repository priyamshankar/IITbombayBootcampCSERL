
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
   f:	e8 e3 01 00 00       	call   1f7 <fork>
  14:	89 c3                	mov    %eax,%ebx
  int st = getpid();
  16:	e8 64 02 00 00       	call   27f <getpid>
  printf(1, "pid =%d", st);
  1b:	83 ec 04             	sub    $0x4,%esp
  1e:	50                   	push   %eax
  1f:	68 94 06 00 00       	push   $0x694
  24:	6a 01                	push   $0x1
  26:	e8 b9 03 00 00       	call   3e4 <printf>
  if (ret == 0)
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	85 db                	test   %ebx,%ebx
  30:	75 14                	jne    46 <main+0x46>
  {
    printf(1, "In child\n");
  32:	83 ec 08             	sub    $0x8,%esp
  35:	68 9c 06 00 00       	push   $0x69c
  3a:	6a 01                	push   $0x1
  3c:	e8 a3 03 00 00       	call   3e4 <printf>

    exit();
  41:	e8 b9 01 00 00       	call   1ff <exit>
  }
  else
  {
    int reaped_pid = wait();
  46:	e8 bc 01 00 00       	call   207 <wait>
    printf(1, "Child with pid %d reaped\n", reaped_pid);
  4b:	83 ec 04             	sub    $0x4,%esp
  4e:	50                   	push   %eax
  4f:	68 a6 06 00 00       	push   $0x6a6
  54:	6a 01                	push   $0x1
  56:	e8 89 03 00 00       	call   3e4 <printf>
  }

  exit();
  5b:	e8 9f 01 00 00       	call   1ff <exit>

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6b:	89 f0                	mov    %esi,%eax
  6d:	89 d1                	mov    %edx,%ecx
  6f:	83 c2 01             	add    $0x1,%edx
  72:	89 c3                	mov    %eax,%ebx
  74:	83 c0 01             	add    $0x1,%eax
  77:	0f b6 09             	movzbl (%ecx),%ecx
  7a:	88 0b                	mov    %cl,(%ebx)
  7c:	84 c9                	test   %cl,%cl
  7e:	75 ed                	jne    6d <strcpy+0xd>
    ;
  return os;
}
  80:	89 f0                	mov    %esi,%eax
  82:	5b                   	pop    %ebx
  83:	5e                   	pop    %esi
  84:	5d                   	pop    %ebp
  85:	c3                   	ret    

00000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8f:	eb 06                	jmp    97 <strcmp+0x11>
    p++, q++;
  91:	83 c1 01             	add    $0x1,%ecx
  94:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  97:	0f b6 01             	movzbl (%ecx),%eax
  9a:	84 c0                	test   %al,%al
  9c:	74 04                	je     a2 <strcmp+0x1c>
  9e:	3a 02                	cmp    (%edx),%al
  a0:	74 ef                	je     91 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  a2:	0f b6 c0             	movzbl %al,%eax
  a5:	0f b6 12             	movzbl (%edx),%edx
  a8:	29 d0                	sub    %edx,%eax
}
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b2:	b8 00 00 00 00       	mov    $0x0,%eax
  b7:	eb 03                	jmp    bc <strlen+0x10>
  b9:	83 c0 01             	add    $0x1,%eax
  bc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c0:	75 f7                	jne    b9 <strlen+0xd>
    ;
  return n;
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  cb:	89 d7                	mov    %edx,%edi
  cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  d3:	fc                   	cld    
  d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d6:	89 d0                	mov    %edx,%eax
  d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  db:	c9                   	leave  
  dc:	c3                   	ret    

000000dd <strchr>:

char*
strchr(const char *s, char c)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  e7:	eb 03                	jmp    ec <strchr+0xf>
  e9:	83 c0 01             	add    $0x1,%eax
  ec:	0f b6 10             	movzbl (%eax),%edx
  ef:	84 d2                	test   %dl,%dl
  f1:	74 06                	je     f9 <strchr+0x1c>
    if(*s == c)
  f3:	38 ca                	cmp    %cl,%dl
  f5:	75 f2                	jne    e9 <strchr+0xc>
  f7:	eb 05                	jmp    fe <strchr+0x21>
      return (char*)s;
  return 0;
  f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <gets>:

char*
gets(char *buf, int max)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	83 ec 1c             	sub    $0x1c,%esp
 109:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10c:	bb 00 00 00 00       	mov    $0x0,%ebx
 111:	89 de                	mov    %ebx,%esi
 113:	83 c3 01             	add    $0x1,%ebx
 116:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 119:	7d 2e                	jge    149 <gets+0x49>
    cc = read(0, &c, 1);
 11b:	83 ec 04             	sub    $0x4,%esp
 11e:	6a 01                	push   $0x1
 120:	8d 45 e7             	lea    -0x19(%ebp),%eax
 123:	50                   	push   %eax
 124:	6a 00                	push   $0x0
 126:	e8 ec 00 00 00       	call   217 <read>
    if(cc < 1)
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	85 c0                	test   %eax,%eax
 130:	7e 17                	jle    149 <gets+0x49>
      break;
    buf[i++] = c;
 132:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 136:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 139:	3c 0a                	cmp    $0xa,%al
 13b:	0f 94 c2             	sete   %dl
 13e:	3c 0d                	cmp    $0xd,%al
 140:	0f 94 c0             	sete   %al
 143:	08 c2                	or     %al,%dl
 145:	74 ca                	je     111 <gets+0x11>
    buf[i++] = c;
 147:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 149:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 14d:	89 f8                	mov    %edi,%eax
 14f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 152:	5b                   	pop    %ebx
 153:	5e                   	pop    %esi
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <stat>:

int
stat(const char *n, struct stat *st)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	56                   	push   %esi
 15b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	6a 00                	push   $0x0
 161:	ff 75 08             	push   0x8(%ebp)
 164:	e8 d6 00 00 00       	call   23f <open>
  if(fd < 0)
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	78 24                	js     194 <stat+0x3d>
 170:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 172:	83 ec 08             	sub    $0x8,%esp
 175:	ff 75 0c             	push   0xc(%ebp)
 178:	50                   	push   %eax
 179:	e8 d9 00 00 00       	call   257 <fstat>
 17e:	89 c6                	mov    %eax,%esi
  close(fd);
 180:	89 1c 24             	mov    %ebx,(%esp)
 183:	e8 9f 00 00 00       	call   227 <close>
  return r;
 188:	83 c4 10             	add    $0x10,%esp
}
 18b:	89 f0                	mov    %esi,%eax
 18d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
    return -1;
 194:	be ff ff ff ff       	mov    $0xffffffff,%esi
 199:	eb f0                	jmp    18b <stat+0x34>

0000019b <atoi>:

int
atoi(const char *s)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	53                   	push   %ebx
 19f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1a2:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a7:	eb 10                	jmp    1b9 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1a9:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1ac:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1af:	83 c1 01             	add    $0x1,%ecx
 1b2:	0f be c0             	movsbl %al,%eax
 1b5:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1b9:	0f b6 01             	movzbl (%ecx),%eax
 1bc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1bf:	80 fb 09             	cmp    $0x9,%bl
 1c2:	76 e5                	jbe    1a9 <atoi+0xe>
  return n;
}
 1c4:	89 d0                	mov    %edx,%eax
 1c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1d9:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1db:	eb 0d                	jmp    1ea <memmove+0x1f>
    *dst++ = *src++;
 1dd:	0f b6 01             	movzbl (%ecx),%eax
 1e0:	88 02                	mov    %al,(%edx)
 1e2:	8d 49 01             	lea    0x1(%ecx),%ecx
 1e5:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1e8:	89 d8                	mov    %ebx,%eax
 1ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1ed:	85 c0                	test   %eax,%eax
 1ef:	7f ec                	jg     1dd <memmove+0x12>
  return vdst;
}
 1f1:	89 f0                	mov    %esi,%eax
 1f3:	5b                   	pop    %ebx
 1f4:	5e                   	pop    %esi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f7:	b8 01 00 00 00       	mov    $0x1,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <exit>:
SYSCALL(exit)
 1ff:	b8 02 00 00 00       	mov    $0x2,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <wait>:
SYSCALL(wait)
 207:	b8 03 00 00 00       	mov    $0x3,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <pipe>:
SYSCALL(pipe)
 20f:	b8 04 00 00 00       	mov    $0x4,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <read>:
SYSCALL(read)
 217:	b8 05 00 00 00       	mov    $0x5,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <write>:
SYSCALL(write)
 21f:	b8 10 00 00 00       	mov    $0x10,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <close>:
SYSCALL(close)
 227:	b8 15 00 00 00       	mov    $0x15,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <kill>:
SYSCALL(kill)
 22f:	b8 06 00 00 00       	mov    $0x6,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <exec>:
SYSCALL(exec)
 237:	b8 07 00 00 00       	mov    $0x7,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <open>:
SYSCALL(open)
 23f:	b8 0f 00 00 00       	mov    $0xf,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <mknod>:
SYSCALL(mknod)
 247:	b8 11 00 00 00       	mov    $0x11,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <unlink>:
SYSCALL(unlink)
 24f:	b8 12 00 00 00       	mov    $0x12,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <fstat>:
SYSCALL(fstat)
 257:	b8 08 00 00 00       	mov    $0x8,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <link>:
SYSCALL(link)
 25f:	b8 13 00 00 00       	mov    $0x13,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mkdir>:
SYSCALL(mkdir)
 267:	b8 14 00 00 00       	mov    $0x14,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <chdir>:
SYSCALL(chdir)
 26f:	b8 09 00 00 00       	mov    $0x9,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <dup>:
SYSCALL(dup)
 277:	b8 0a 00 00 00       	mov    $0xa,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <getpid>:
SYSCALL(getpid)
 27f:	b8 0b 00 00 00       	mov    $0xb,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <sbrk>:
SYSCALL(sbrk)
 287:	b8 0c 00 00 00       	mov    $0xc,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <sleep>:
SYSCALL(sleep)
 28f:	b8 0d 00 00 00       	mov    $0xd,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <uptime>:
SYSCALL(uptime)
 297:	b8 0e 00 00 00       	mov    $0xe,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <hello>:
SYSCALL(hello)
 29f:	b8 16 00 00 00       	mov    $0x16,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <helloYou>:
SYSCALL(helloYou)
 2a7:	b8 17 00 00 00       	mov    $0x17,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <getppid>:
SYSCALL(getppid)
 2af:	b8 18 00 00 00       	mov    $0x18,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2b7:	b8 19 00 00 00       	mov    $0x19,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <signalProcess>:
SYSCALL(signalProcess)
 2bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <numvp>:
SYSCALL(numvp)
 2c7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <numpp>:
SYSCALL(numpp)
 2cf:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <init_counter>:

SYSCALL(init_counter)
 2d7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <update_cnt>:
SYSCALL(update_cnt)
 2df:	b8 1e 00 00 00       	mov    $0x1e,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <display_count>:
SYSCALL(display_count)
 2e7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <init_counter_1>:
SYSCALL(init_counter_1)
 2ef:	b8 20 00 00 00       	mov    $0x20,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <update_cnt_1>:
SYSCALL(update_cnt_1)
 2f7:	b8 21 00 00 00       	mov    $0x21,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <display_count_1>:
SYSCALL(display_count_1)
 2ff:	b8 22 00 00 00       	mov    $0x22,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <init_counter_2>:
SYSCALL(init_counter_2)
 307:	b8 23 00 00 00       	mov    $0x23,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <update_cnt_2>:
SYSCALL(update_cnt_2)
 30f:	b8 24 00 00 00       	mov    $0x24,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <display_count_2>:
SYSCALL(display_count_2)
 317:	b8 25 00 00 00       	mov    $0x25,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <init_mylock>:
SYSCALL(init_mylock)
 31f:	b8 26 00 00 00       	mov    $0x26,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <acquire_mylock>:
SYSCALL(acquire_mylock)
 327:	b8 27 00 00 00       	mov    $0x27,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <release_mylock>:
SYSCALL(release_mylock)
 32f:	b8 28 00 00 00       	mov    $0x28,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <holding_mylock>:
 337:	b8 29 00 00 00       	mov    $0x29,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 1c             	sub    $0x1c,%esp
 345:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 348:	6a 01                	push   $0x1
 34a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 34d:	52                   	push   %edx
 34e:	50                   	push   %eax
 34f:	e8 cb fe ff ff       	call   21f <write>
}
 354:	83 c4 10             	add    $0x10,%esp
 357:	c9                   	leave  
 358:	c3                   	ret    

00000359 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	57                   	push   %edi
 35d:	56                   	push   %esi
 35e:	53                   	push   %ebx
 35f:	83 ec 2c             	sub    $0x2c,%esp
 362:	89 45 d0             	mov    %eax,-0x30(%ebp)
 365:	89 d0                	mov    %edx,%eax
 367:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 36d:	0f 95 c1             	setne  %cl
 370:	c1 ea 1f             	shr    $0x1f,%edx
 373:	84 d1                	test   %dl,%cl
 375:	74 44                	je     3bb <printint+0x62>
    neg = 1;
    x = -xx;
 377:	f7 d8                	neg    %eax
 379:	89 c1                	mov    %eax,%ecx
    neg = 1;
 37b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 382:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 387:	89 c8                	mov    %ecx,%eax
 389:	ba 00 00 00 00       	mov    $0x0,%edx
 38e:	f7 f6                	div    %esi
 390:	89 df                	mov    %ebx,%edi
 392:	83 c3 01             	add    $0x1,%ebx
 395:	0f b6 92 20 07 00 00 	movzbl 0x720(%edx),%edx
 39c:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a0:	89 ca                	mov    %ecx,%edx
 3a2:	89 c1                	mov    %eax,%ecx
 3a4:	39 d6                	cmp    %edx,%esi
 3a6:	76 df                	jbe    387 <printint+0x2e>
  if(neg)
 3a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3ac:	74 31                	je     3df <printint+0x86>
    buf[i++] = '-';
 3ae:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b3:	8d 5f 02             	lea    0x2(%edi),%ebx
 3b6:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b9:	eb 17                	jmp    3d2 <printint+0x79>
    x = xx;
 3bb:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c4:	eb bc                	jmp    382 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3c6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3cb:	89 f0                	mov    %esi,%eax
 3cd:	e8 6d ff ff ff       	call   33f <putc>
  while(--i >= 0)
 3d2:	83 eb 01             	sub    $0x1,%ebx
 3d5:	79 ef                	jns    3c6 <printint+0x6d>
}
 3d7:	83 c4 2c             	add    $0x2c,%esp
 3da:	5b                   	pop    %ebx
 3db:	5e                   	pop    %esi
 3dc:	5f                   	pop    %edi
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e2:	eb ee                	jmp    3d2 <printint+0x79>

000003e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ed:	8d 45 10             	lea    0x10(%ebp),%eax
 3f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f8:	bb 00 00 00 00       	mov    $0x0,%ebx
 3fd:	eb 14                	jmp    413 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3ff:	89 fa                	mov    %edi,%edx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	e8 36 ff ff ff       	call   33f <putc>
 409:	eb 05                	jmp    410 <printf+0x2c>
      }
    } else if(state == '%'){
 40b:	83 fe 25             	cmp    $0x25,%esi
 40e:	74 25                	je     435 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 410:	83 c3 01             	add    $0x1,%ebx
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 41a:	84 c0                	test   %al,%al
 41c:	0f 84 20 01 00 00    	je     542 <printf+0x15e>
    c = fmt[i] & 0xff;
 422:	0f be f8             	movsbl %al,%edi
 425:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 428:	85 f6                	test   %esi,%esi
 42a:	75 df                	jne    40b <printf+0x27>
      if(c == '%'){
 42c:	83 f8 25             	cmp    $0x25,%eax
 42f:	75 ce                	jne    3ff <printf+0x1b>
        state = '%';
 431:	89 c6                	mov    %eax,%esi
 433:	eb db                	jmp    410 <printf+0x2c>
      if(c == 'd'){
 435:	83 f8 25             	cmp    $0x25,%eax
 438:	0f 84 cf 00 00 00    	je     50d <printf+0x129>
 43e:	0f 8c dd 00 00 00    	jl     521 <printf+0x13d>
 444:	83 f8 78             	cmp    $0x78,%eax
 447:	0f 8f d4 00 00 00    	jg     521 <printf+0x13d>
 44d:	83 f8 63             	cmp    $0x63,%eax
 450:	0f 8c cb 00 00 00    	jl     521 <printf+0x13d>
 456:	83 e8 63             	sub    $0x63,%eax
 459:	83 f8 15             	cmp    $0x15,%eax
 45c:	0f 87 bf 00 00 00    	ja     521 <printf+0x13d>
 462:	ff 24 85 c8 06 00 00 	jmp    *0x6c8(,%eax,4)
        printint(fd, *ap, 10, 1);
 469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46c:	8b 17                	mov    (%edi),%edx
 46e:	83 ec 0c             	sub    $0xc,%esp
 471:	6a 01                	push   $0x1
 473:	b9 0a 00 00 00       	mov    $0xa,%ecx
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	e8 d9 fe ff ff       	call   359 <printint>
        ap++;
 480:	83 c7 04             	add    $0x4,%edi
 483:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 486:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 489:	be 00 00 00 00       	mov    $0x0,%esi
 48e:	eb 80                	jmp    410 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 493:	8b 17                	mov    (%edi),%edx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 00                	push   $0x0
 49a:	b9 10 00 00 00       	mov    $0x10,%ecx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	e8 b2 fe ff ff       	call   359 <printint>
        ap++;
 4a7:	83 c7 04             	add    $0x4,%edi
 4aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ad:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b0:	be 00 00 00 00       	mov    $0x0,%esi
 4b5:	e9 56 ff ff ff       	jmp    410 <printf+0x2c>
        s = (char*)*ap;
 4ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bd:	8b 30                	mov    (%eax),%esi
        ap++;
 4bf:	83 c0 04             	add    $0x4,%eax
 4c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c5:	85 f6                	test   %esi,%esi
 4c7:	75 15                	jne    4de <printf+0xfa>
          s = "(null)";
 4c9:	be c0 06 00 00       	mov    $0x6c0,%esi
 4ce:	eb 0e                	jmp    4de <printf+0xfa>
          putc(fd, *s);
 4d0:	0f be d2             	movsbl %dl,%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	e8 64 fe ff ff       	call   33f <putc>
          s++;
 4db:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4de:	0f b6 16             	movzbl (%esi),%edx
 4e1:	84 d2                	test   %dl,%dl
 4e3:	75 eb                	jne    4d0 <printf+0xec>
      state = 0;
 4e5:	be 00 00 00 00       	mov    $0x0,%esi
 4ea:	e9 21 ff ff ff       	jmp    410 <printf+0x2c>
        putc(fd, *ap);
 4ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f2:	0f be 17             	movsbl (%edi),%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 42 fe ff ff       	call   33f <putc>
        ap++;
 4fd:	83 c7 04             	add    $0x4,%edi
 500:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 503:	be 00 00 00 00       	mov    $0x0,%esi
 508:	e9 03 ff ff ff       	jmp    410 <printf+0x2c>
        putc(fd, c);
 50d:	89 fa                	mov    %edi,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 28 fe ff ff       	call   33f <putc>
      state = 0;
 517:	be 00 00 00 00       	mov    $0x0,%esi
 51c:	e9 ef fe ff ff       	jmp    410 <printf+0x2c>
        putc(fd, '%');
 521:	ba 25 00 00 00       	mov    $0x25,%edx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	e8 11 fe ff ff       	call   33f <putc>
        putc(fd, c);
 52e:	89 fa                	mov    %edi,%edx
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	e8 07 fe ff ff       	call   33f <putc>
      state = 0;
 538:	be 00 00 00 00       	mov    $0x0,%esi
 53d:	e9 ce fe ff ff       	jmp    410 <printf+0x2c>
    }
  }
}
 542:	8d 65 f4             	lea    -0xc(%ebp),%esp
 545:	5b                   	pop    %ebx
 546:	5e                   	pop    %esi
 547:	5f                   	pop    %edi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    

0000054a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	57                   	push   %edi
 54e:	56                   	push   %esi
 54f:	53                   	push   %ebx
 550:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 553:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 556:	a1 c4 09 00 00       	mov    0x9c4,%eax
 55b:	eb 02                	jmp    55f <free+0x15>
 55d:	89 d0                	mov    %edx,%eax
 55f:	39 c8                	cmp    %ecx,%eax
 561:	73 04                	jae    567 <free+0x1d>
 563:	39 08                	cmp    %ecx,(%eax)
 565:	77 12                	ja     579 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 567:	8b 10                	mov    (%eax),%edx
 569:	39 c2                	cmp    %eax,%edx
 56b:	77 f0                	ja     55d <free+0x13>
 56d:	39 c8                	cmp    %ecx,%eax
 56f:	72 08                	jb     579 <free+0x2f>
 571:	39 ca                	cmp    %ecx,%edx
 573:	77 04                	ja     579 <free+0x2f>
 575:	89 d0                	mov    %edx,%eax
 577:	eb e6                	jmp    55f <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 579:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57f:	8b 10                	mov    (%eax),%edx
 581:	39 d7                	cmp    %edx,%edi
 583:	74 19                	je     59e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 585:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 588:	8b 50 04             	mov    0x4(%eax),%edx
 58b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58e:	39 ce                	cmp    %ecx,%esi
 590:	74 1b                	je     5ad <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 592:	89 08                	mov    %ecx,(%eax)
  freep = p;
 594:	a3 c4 09 00 00       	mov    %eax,0x9c4
}
 599:	5b                   	pop    %ebx
 59a:	5e                   	pop    %esi
 59b:	5f                   	pop    %edi
 59c:	5d                   	pop    %ebp
 59d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59e:	03 72 04             	add    0x4(%edx),%esi
 5a1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a4:	8b 10                	mov    (%eax),%edx
 5a6:	8b 12                	mov    (%edx),%edx
 5a8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5ab:	eb db                	jmp    588 <free+0x3e>
    p->s.size += bp->s.size;
 5ad:	03 53 fc             	add    -0x4(%ebx),%edx
 5b0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b6:	89 10                	mov    %edx,(%eax)
 5b8:	eb da                	jmp    594 <free+0x4a>

000005ba <morecore>:

static Header*
morecore(uint nu)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	53                   	push   %ebx
 5be:	83 ec 04             	sub    $0x4,%esp
 5c1:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c8:	77 05                	ja     5cf <morecore+0x15>
    nu = 4096;
 5ca:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5cf:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d6:	83 ec 0c             	sub    $0xc,%esp
 5d9:	50                   	push   %eax
 5da:	e8 a8 fc ff ff       	call   287 <sbrk>
  if(p == (char*)-1)
 5df:	83 c4 10             	add    $0x10,%esp
 5e2:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e5:	74 1c                	je     603 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ea:	83 c0 08             	add    $0x8,%eax
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	50                   	push   %eax
 5f1:	e8 54 ff ff ff       	call   54a <free>
  return freep;
 5f6:	a1 c4 09 00 00       	mov    0x9c4,%eax
 5fb:	83 c4 10             	add    $0x10,%esp
}
 5fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 601:	c9                   	leave  
 602:	c3                   	ret    
    return 0;
 603:	b8 00 00 00 00       	mov    $0x0,%eax
 608:	eb f4                	jmp    5fe <morecore+0x44>

0000060a <malloc>:

void*
malloc(uint nbytes)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	53                   	push   %ebx
 60e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	8d 58 07             	lea    0x7(%eax),%ebx
 617:	c1 eb 03             	shr    $0x3,%ebx
 61a:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 61d:	8b 0d c4 09 00 00    	mov    0x9c4,%ecx
 623:	85 c9                	test   %ecx,%ecx
 625:	74 04                	je     62b <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 627:	8b 01                	mov    (%ecx),%eax
 629:	eb 4a                	jmp    675 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 62b:	c7 05 c4 09 00 00 c8 	movl   $0x9c8,0x9c4
 632:	09 00 00 
 635:	c7 05 c8 09 00 00 c8 	movl   $0x9c8,0x9c8
 63c:	09 00 00 
    base.s.size = 0;
 63f:	c7 05 cc 09 00 00 00 	movl   $0x0,0x9cc
 646:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 649:	b9 c8 09 00 00       	mov    $0x9c8,%ecx
 64e:	eb d7                	jmp    627 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 650:	74 19                	je     66b <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 652:	29 da                	sub    %ebx,%edx
 654:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 657:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 65a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 65d:	89 0d c4 09 00 00    	mov    %ecx,0x9c4
      return (void*)(p + 1);
 663:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 669:	c9                   	leave  
 66a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 66b:	8b 10                	mov    (%eax),%edx
 66d:	89 11                	mov    %edx,(%ecx)
 66f:	eb ec                	jmp    65d <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 671:	89 c1                	mov    %eax,%ecx
 673:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	39 da                	cmp    %ebx,%edx
 67a:	73 d4                	jae    650 <malloc+0x46>
    if(p == freep)
 67c:	39 05 c4 09 00 00    	cmp    %eax,0x9c4
 682:	75 ed                	jne    671 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 684:	89 d8                	mov    %ebx,%eax
 686:	e8 2f ff ff ff       	call   5ba <morecore>
 68b:	85 c0                	test   %eax,%eax
 68d:	75 e2                	jne    671 <malloc+0x67>
 68f:	eb d5                	jmp    666 <malloc+0x5c>
