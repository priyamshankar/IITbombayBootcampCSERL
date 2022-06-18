
_test:     file format elf32-i386


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
    init_counter();
  13:	e8 ea 02 00 00       	call   302 <init_counter>
    int ret = fork();
  18:	e8 05 02 00 00       	call   222 <fork>
  1d:	89 c6                	mov    %eax,%esi
            1. Print lock id if the lock has been initialized.
            2. define and call the function 'int holding_mylock(int id)' to check the status of
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held. 
    */
    // printf(1,"init: %d\nacq: %d \nrel: %d \nhol: %d\n", init_mylock(),acquire_mylock(11), release_mylock(12),holding_mylock(13));
    printf(1,"%d\n",init_mylock());
  1f:	e8 26 03 00 00       	call   34a <init_mylock>
  24:	83 ec 04             	sub    $0x4,%esp
  27:	50                   	push   %eax
  28:	68 bc 06 00 00       	push   $0x6bc
  2d:	6a 01                	push   $0x1
  2f:	e8 db 03 00 00       	call   40f <printf>
    printf(1,"%d\n",init_mylock());
  34:	e8 11 03 00 00       	call   34a <init_mylock>
  39:	83 c4 0c             	add    $0xc,%esp
  3c:	50                   	push   %eax
  3d:	68 bc 06 00 00       	push   $0x6bc
  42:	6a 01                	push   $0x1
  44:	e8 c6 03 00 00       	call   40f <printf>

    
    for(int i=0; i<10000; i++){
  49:	83 c4 10             	add    $0x10,%esp
  4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  51:	eb 08                	jmp    5b <main+0x5b>
        update_cnt();
  53:	e8 b2 02 00 00       	call   30a <update_cnt>
    for(int i=0; i<10000; i++){
  58:	83 c3 01             	add    $0x1,%ebx
  5b:	81 fb 0f 27 00 00    	cmp    $0x270f,%ebx
  61:	7e f0                	jle    53 <main+0x53>
    }

    if(ret == 0)
  63:	85 f6                	test   %esi,%esi
  65:	75 05                	jne    6c <main+0x6c>
        exit();
  67:	e8 be 01 00 00       	call   22a <exit>
    else{
        wait();
  6c:	e8 c1 01 00 00       	call   232 <wait>
        printf(1, "%d\n", display_count());
  71:	e8 9c 02 00 00       	call   312 <display_count>
  76:	83 ec 04             	sub    $0x4,%esp
  79:	50                   	push   %eax
  7a:	68 bc 06 00 00       	push   $0x6bc
  7f:	6a 01                	push   $0x1
  81:	e8 89 03 00 00       	call   40f <printf>
        exit();
  86:	e8 9f 01 00 00       	call   22a <exit>

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	56                   	push   %esi
  8f:	53                   	push   %ebx
  90:	8b 75 08             	mov    0x8(%ebp),%esi
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	89 f0                	mov    %esi,%eax
  98:	89 d1                	mov    %edx,%ecx
  9a:	83 c2 01             	add    $0x1,%edx
  9d:	89 c3                	mov    %eax,%ebx
  9f:	83 c0 01             	add    $0x1,%eax
  a2:	0f b6 09             	movzbl (%ecx),%ecx
  a5:	88 0b                	mov    %cl,(%ebx)
  a7:	84 c9                	test   %cl,%cl
  a9:	75 ed                	jne    98 <strcpy+0xd>
    ;
  return os;
}
  ab:	89 f0                	mov    %esi,%eax
  ad:	5b                   	pop    %ebx
  ae:	5e                   	pop    %esi
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	eb 06                	jmp    c2 <strcmp+0x11>
    p++, q++;
  bc:	83 c1 01             	add    $0x1,%ecx
  bf:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  c2:	0f b6 01             	movzbl (%ecx),%eax
  c5:	84 c0                	test   %al,%al
  c7:	74 04                	je     cd <strcmp+0x1c>
  c9:	3a 02                	cmp    (%edx),%al
  cb:	74 ef                	je     bc <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  cd:	0f b6 c0             	movzbl %al,%eax
  d0:	0f b6 12             	movzbl (%edx),%edx
  d3:	29 d0                	sub    %edx,%eax
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <strlen>:

uint
strlen(const char *s)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  dd:	b8 00 00 00 00       	mov    $0x0,%eax
  e2:	eb 03                	jmp    e7 <strlen+0x10>
  e4:	83 c0 01             	add    $0x1,%eax
  e7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  eb:	75 f7                	jne    e4 <strlen+0xd>
    ;
  return n;
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <memset>:

void*
memset(void *dst, int c, uint n)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	57                   	push   %edi
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f6:	89 d7                	mov    %edx,%edi
  f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	fc                   	cld    
  ff:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 101:	89 d0                	mov    %edx,%eax
 103:	8b 7d fc             	mov    -0x4(%ebp),%edi
 106:	c9                   	leave  
 107:	c3                   	ret    

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 112:	eb 03                	jmp    117 <strchr+0xf>
 114:	83 c0 01             	add    $0x1,%eax
 117:	0f b6 10             	movzbl (%eax),%edx
 11a:	84 d2                	test   %dl,%dl
 11c:	74 06                	je     124 <strchr+0x1c>
    if(*s == c)
 11e:	38 ca                	cmp    %cl,%dl
 120:	75 f2                	jne    114 <strchr+0xc>
 122:	eb 05                	jmp    129 <strchr+0x21>
      return (char*)s;
  return 0;
 124:	b8 00 00 00 00       	mov    $0x0,%eax
}
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <gets>:

char*
gets(char *buf, int max)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	56                   	push   %esi
 130:	53                   	push   %ebx
 131:	83 ec 1c             	sub    $0x1c,%esp
 134:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	bb 00 00 00 00       	mov    $0x0,%ebx
 13c:	89 de                	mov    %ebx,%esi
 13e:	83 c3 01             	add    $0x1,%ebx
 141:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 144:	7d 2e                	jge    174 <gets+0x49>
    cc = read(0, &c, 1);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	6a 01                	push   $0x1
 14b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 14e:	50                   	push   %eax
 14f:	6a 00                	push   $0x0
 151:	e8 ec 00 00 00       	call   242 <read>
    if(cc < 1)
 156:	83 c4 10             	add    $0x10,%esp
 159:	85 c0                	test   %eax,%eax
 15b:	7e 17                	jle    174 <gets+0x49>
      break;
    buf[i++] = c;
 15d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 161:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 164:	3c 0a                	cmp    $0xa,%al
 166:	0f 94 c2             	sete   %dl
 169:	3c 0d                	cmp    $0xd,%al
 16b:	0f 94 c0             	sete   %al
 16e:	08 c2                	or     %al,%dl
 170:	74 ca                	je     13c <gets+0x11>
    buf[i++] = c;
 172:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 174:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 178:	89 f8                	mov    %edi,%eax
 17a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17d:	5b                   	pop    %ebx
 17e:	5e                   	pop    %esi
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <stat>:

int
stat(const char *n, struct stat *st)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	56                   	push   %esi
 186:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	6a 00                	push   $0x0
 18c:	ff 75 08             	push   0x8(%ebp)
 18f:	e8 d6 00 00 00       	call   26a <open>
  if(fd < 0)
 194:	83 c4 10             	add    $0x10,%esp
 197:	85 c0                	test   %eax,%eax
 199:	78 24                	js     1bf <stat+0x3d>
 19b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	ff 75 0c             	push   0xc(%ebp)
 1a3:	50                   	push   %eax
 1a4:	e8 d9 00 00 00       	call   282 <fstat>
 1a9:	89 c6                	mov    %eax,%esi
  close(fd);
 1ab:	89 1c 24             	mov    %ebx,(%esp)
 1ae:	e8 9f 00 00 00       	call   252 <close>
  return r;
 1b3:	83 c4 10             	add    $0x10,%esp
}
 1b6:	89 f0                	mov    %esi,%eax
 1b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    
    return -1;
 1bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c4:	eb f0                	jmp    1b6 <stat+0x34>

000001c6 <atoi>:

int
atoi(const char *s)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	53                   	push   %ebx
 1ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1cd:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d2:	eb 10                	jmp    1e4 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 1d4:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1d7:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1da:	83 c1 01             	add    $0x1,%ecx
 1dd:	0f be c0             	movsbl %al,%eax
 1e0:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 1e4:	0f b6 01             	movzbl (%ecx),%eax
 1e7:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ea:	80 fb 09             	cmp    $0x9,%bl
 1ed:	76 e5                	jbe    1d4 <atoi+0xe>
  return n;
}
 1ef:	89 d0                	mov    %edx,%eax
 1f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	56                   	push   %esi
 1fa:	53                   	push   %ebx
 1fb:	8b 75 08             	mov    0x8(%ebp),%esi
 1fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 201:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 204:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 206:	eb 0d                	jmp    215 <memmove+0x1f>
    *dst++ = *src++;
 208:	0f b6 01             	movzbl (%ecx),%eax
 20b:	88 02                	mov    %al,(%edx)
 20d:	8d 49 01             	lea    0x1(%ecx),%ecx
 210:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 213:	89 d8                	mov    %ebx,%eax
 215:	8d 58 ff             	lea    -0x1(%eax),%ebx
 218:	85 c0                	test   %eax,%eax
 21a:	7f ec                	jg     208 <memmove+0x12>
  return vdst;
}
 21c:	89 f0                	mov    %esi,%eax
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret    

00000222 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 222:	b8 01 00 00 00       	mov    $0x1,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <exit>:
SYSCALL(exit)
 22a:	b8 02 00 00 00       	mov    $0x2,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <wait>:
SYSCALL(wait)
 232:	b8 03 00 00 00       	mov    $0x3,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <pipe>:
SYSCALL(pipe)
 23a:	b8 04 00 00 00       	mov    $0x4,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <read>:
SYSCALL(read)
 242:	b8 05 00 00 00       	mov    $0x5,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <write>:
SYSCALL(write)
 24a:	b8 10 00 00 00       	mov    $0x10,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <close>:
SYSCALL(close)
 252:	b8 15 00 00 00       	mov    $0x15,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <kill>:
SYSCALL(kill)
 25a:	b8 06 00 00 00       	mov    $0x6,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <exec>:
SYSCALL(exec)
 262:	b8 07 00 00 00       	mov    $0x7,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <open>:
SYSCALL(open)
 26a:	b8 0f 00 00 00       	mov    $0xf,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <mknod>:
SYSCALL(mknod)
 272:	b8 11 00 00 00       	mov    $0x11,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <unlink>:
SYSCALL(unlink)
 27a:	b8 12 00 00 00       	mov    $0x12,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <fstat>:
SYSCALL(fstat)
 282:	b8 08 00 00 00       	mov    $0x8,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <link>:
SYSCALL(link)
 28a:	b8 13 00 00 00       	mov    $0x13,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <mkdir>:
SYSCALL(mkdir)
 292:	b8 14 00 00 00       	mov    $0x14,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <chdir>:
SYSCALL(chdir)
 29a:	b8 09 00 00 00       	mov    $0x9,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <dup>:
SYSCALL(dup)
 2a2:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <getpid>:
SYSCALL(getpid)
 2aa:	b8 0b 00 00 00       	mov    $0xb,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <sbrk>:
SYSCALL(sbrk)
 2b2:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <sleep>:
SYSCALL(sleep)
 2ba:	b8 0d 00 00 00       	mov    $0xd,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <uptime>:
SYSCALL(uptime)
 2c2:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <hello>:
SYSCALL(hello)
 2ca:	b8 16 00 00 00       	mov    $0x16,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <helloYou>:
SYSCALL(helloYou)
 2d2:	b8 17 00 00 00       	mov    $0x17,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <getppid>:
SYSCALL(getppid)
 2da:	b8 18 00 00 00       	mov    $0x18,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <get_siblings_info>:
SYSCALL(get_siblings_info)
 2e2:	b8 19 00 00 00       	mov    $0x19,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <signalProcess>:
SYSCALL(signalProcess)
 2ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <numvp>:
SYSCALL(numvp)
 2f2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <numpp>:
SYSCALL(numpp)
 2fa:	b8 1c 00 00 00       	mov    $0x1c,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <init_counter>:

SYSCALL(init_counter)
 302:	b8 1d 00 00 00       	mov    $0x1d,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <update_cnt>:
SYSCALL(update_cnt)
 30a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <display_count>:
SYSCALL(display_count)
 312:	b8 1f 00 00 00       	mov    $0x1f,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <init_counter_1>:
SYSCALL(init_counter_1)
 31a:	b8 20 00 00 00       	mov    $0x20,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <update_cnt_1>:
SYSCALL(update_cnt_1)
 322:	b8 21 00 00 00       	mov    $0x21,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <display_count_1>:
SYSCALL(display_count_1)
 32a:	b8 22 00 00 00       	mov    $0x22,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <init_counter_2>:
SYSCALL(init_counter_2)
 332:	b8 23 00 00 00       	mov    $0x23,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <update_cnt_2>:
SYSCALL(update_cnt_2)
 33a:	b8 24 00 00 00       	mov    $0x24,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <display_count_2>:
SYSCALL(display_count_2)
 342:	b8 25 00 00 00       	mov    $0x25,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <init_mylock>:
SYSCALL(init_mylock)
 34a:	b8 26 00 00 00       	mov    $0x26,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <acquire_mylock>:
SYSCALL(acquire_mylock)
 352:	b8 27 00 00 00       	mov    $0x27,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <release_mylock>:
SYSCALL(release_mylock)
 35a:	b8 28 00 00 00       	mov    $0x28,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <holding_mylock>:
 362:	b8 29 00 00 00       	mov    $0x29,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 1c             	sub    $0x1c,%esp
 370:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 373:	6a 01                	push   $0x1
 375:	8d 55 f4             	lea    -0xc(%ebp),%edx
 378:	52                   	push   %edx
 379:	50                   	push   %eax
 37a:	e8 cb fe ff ff       	call   24a <write>
}
 37f:	83 c4 10             	add    $0x10,%esp
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	56                   	push   %esi
 389:	53                   	push   %ebx
 38a:	83 ec 2c             	sub    $0x2c,%esp
 38d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 390:	89 d0                	mov    %edx,%eax
 392:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 398:	0f 95 c1             	setne  %cl
 39b:	c1 ea 1f             	shr    $0x1f,%edx
 39e:	84 d1                	test   %dl,%cl
 3a0:	74 44                	je     3e6 <printint+0x62>
    neg = 1;
    x = -xx;
 3a2:	f7 d8                	neg    %eax
 3a4:	89 c1                	mov    %eax,%ecx
    neg = 1;
 3a6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3b2:	89 c8                	mov    %ecx,%eax
 3b4:	ba 00 00 00 00       	mov    $0x0,%edx
 3b9:	f7 f6                	div    %esi
 3bb:	89 df                	mov    %ebx,%edi
 3bd:	83 c3 01             	add    $0x1,%ebx
 3c0:	0f b6 92 20 07 00 00 	movzbl 0x720(%edx),%edx
 3c7:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3cb:	89 ca                	mov    %ecx,%edx
 3cd:	89 c1                	mov    %eax,%ecx
 3cf:	39 d6                	cmp    %edx,%esi
 3d1:	76 df                	jbe    3b2 <printint+0x2e>
  if(neg)
 3d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3d7:	74 31                	je     40a <printint+0x86>
    buf[i++] = '-';
 3d9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3de:	8d 5f 02             	lea    0x2(%edi),%ebx
 3e1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3e4:	eb 17                	jmp    3fd <printint+0x79>
    x = xx;
 3e6:	89 c1                	mov    %eax,%ecx
  neg = 0;
 3e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3ef:	eb bc                	jmp    3ad <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 3f1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3f6:	89 f0                	mov    %esi,%eax
 3f8:	e8 6d ff ff ff       	call   36a <putc>
  while(--i >= 0)
 3fd:	83 eb 01             	sub    $0x1,%ebx
 400:	79 ef                	jns    3f1 <printint+0x6d>
}
 402:	83 c4 2c             	add    $0x2c,%esp
 405:	5b                   	pop    %ebx
 406:	5e                   	pop    %esi
 407:	5f                   	pop    %edi
 408:	5d                   	pop    %ebp
 409:	c3                   	ret    
 40a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 40d:	eb ee                	jmp    3fd <printint+0x79>

0000040f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	57                   	push   %edi
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
 415:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 418:	8d 45 10             	lea    0x10(%ebp),%eax
 41b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 41e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 423:	bb 00 00 00 00       	mov    $0x0,%ebx
 428:	eb 14                	jmp    43e <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 42a:	89 fa                	mov    %edi,%edx
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	e8 36 ff ff ff       	call   36a <putc>
 434:	eb 05                	jmp    43b <printf+0x2c>
      }
    } else if(state == '%'){
 436:	83 fe 25             	cmp    $0x25,%esi
 439:	74 25                	je     460 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 43b:	83 c3 01             	add    $0x1,%ebx
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 445:	84 c0                	test   %al,%al
 447:	0f 84 20 01 00 00    	je     56d <printf+0x15e>
    c = fmt[i] & 0xff;
 44d:	0f be f8             	movsbl %al,%edi
 450:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 453:	85 f6                	test   %esi,%esi
 455:	75 df                	jne    436 <printf+0x27>
      if(c == '%'){
 457:	83 f8 25             	cmp    $0x25,%eax
 45a:	75 ce                	jne    42a <printf+0x1b>
        state = '%';
 45c:	89 c6                	mov    %eax,%esi
 45e:	eb db                	jmp    43b <printf+0x2c>
      if(c == 'd'){
 460:	83 f8 25             	cmp    $0x25,%eax
 463:	0f 84 cf 00 00 00    	je     538 <printf+0x129>
 469:	0f 8c dd 00 00 00    	jl     54c <printf+0x13d>
 46f:	83 f8 78             	cmp    $0x78,%eax
 472:	0f 8f d4 00 00 00    	jg     54c <printf+0x13d>
 478:	83 f8 63             	cmp    $0x63,%eax
 47b:	0f 8c cb 00 00 00    	jl     54c <printf+0x13d>
 481:	83 e8 63             	sub    $0x63,%eax
 484:	83 f8 15             	cmp    $0x15,%eax
 487:	0f 87 bf 00 00 00    	ja     54c <printf+0x13d>
 48d:	ff 24 85 c8 06 00 00 	jmp    *0x6c8(,%eax,4)
        printint(fd, *ap, 10, 1);
 494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 497:	8b 17                	mov    (%edi),%edx
 499:	83 ec 0c             	sub    $0xc,%esp
 49c:	6a 01                	push   $0x1
 49e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	e8 d9 fe ff ff       	call   384 <printint>
        ap++;
 4ab:	83 c7 04             	add    $0x4,%edi
 4ae:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b4:	be 00 00 00 00       	mov    $0x0,%esi
 4b9:	eb 80                	jmp    43b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4be:	8b 17                	mov    (%edi),%edx
 4c0:	83 ec 0c             	sub    $0xc,%esp
 4c3:	6a 00                	push   $0x0
 4c5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	e8 b2 fe ff ff       	call   384 <printint>
        ap++;
 4d2:	83 c7 04             	add    $0x4,%edi
 4d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4db:	be 00 00 00 00       	mov    $0x0,%esi
 4e0:	e9 56 ff ff ff       	jmp    43b <printf+0x2c>
        s = (char*)*ap;
 4e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e8:	8b 30                	mov    (%eax),%esi
        ap++;
 4ea:	83 c0 04             	add    $0x4,%eax
 4ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4f0:	85 f6                	test   %esi,%esi
 4f2:	75 15                	jne    509 <printf+0xfa>
          s = "(null)";
 4f4:	be c0 06 00 00       	mov    $0x6c0,%esi
 4f9:	eb 0e                	jmp    509 <printf+0xfa>
          putc(fd, *s);
 4fb:	0f be d2             	movsbl %dl,%edx
 4fe:	8b 45 08             	mov    0x8(%ebp),%eax
 501:	e8 64 fe ff ff       	call   36a <putc>
          s++;
 506:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 509:	0f b6 16             	movzbl (%esi),%edx
 50c:	84 d2                	test   %dl,%dl
 50e:	75 eb                	jne    4fb <printf+0xec>
      state = 0;
 510:	be 00 00 00 00       	mov    $0x0,%esi
 515:	e9 21 ff ff ff       	jmp    43b <printf+0x2c>
        putc(fd, *ap);
 51a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 51d:	0f be 17             	movsbl (%edi),%edx
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	e8 42 fe ff ff       	call   36a <putc>
        ap++;
 528:	83 c7 04             	add    $0x4,%edi
 52b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 52e:	be 00 00 00 00       	mov    $0x0,%esi
 533:	e9 03 ff ff ff       	jmp    43b <printf+0x2c>
        putc(fd, c);
 538:	89 fa                	mov    %edi,%edx
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	e8 28 fe ff ff       	call   36a <putc>
      state = 0;
 542:	be 00 00 00 00       	mov    $0x0,%esi
 547:	e9 ef fe ff ff       	jmp    43b <printf+0x2c>
        putc(fd, '%');
 54c:	ba 25 00 00 00       	mov    $0x25,%edx
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	e8 11 fe ff ff       	call   36a <putc>
        putc(fd, c);
 559:	89 fa                	mov    %edi,%edx
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	e8 07 fe ff ff       	call   36a <putc>
      state = 0;
 563:	be 00 00 00 00       	mov    $0x0,%esi
 568:	e9 ce fe ff ff       	jmp    43b <printf+0x2c>
    }
  }
}
 56d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 570:	5b                   	pop    %ebx
 571:	5e                   	pop    %esi
 572:	5f                   	pop    %edi
 573:	5d                   	pop    %ebp
 574:	c3                   	ret    

00000575 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 575:	55                   	push   %ebp
 576:	89 e5                	mov    %esp,%ebp
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	53                   	push   %ebx
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 57e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	a1 c8 09 00 00       	mov    0x9c8,%eax
 586:	eb 02                	jmp    58a <free+0x15>
 588:	89 d0                	mov    %edx,%eax
 58a:	39 c8                	cmp    %ecx,%eax
 58c:	73 04                	jae    592 <free+0x1d>
 58e:	39 08                	cmp    %ecx,(%eax)
 590:	77 12                	ja     5a4 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 592:	8b 10                	mov    (%eax),%edx
 594:	39 c2                	cmp    %eax,%edx
 596:	77 f0                	ja     588 <free+0x13>
 598:	39 c8                	cmp    %ecx,%eax
 59a:	72 08                	jb     5a4 <free+0x2f>
 59c:	39 ca                	cmp    %ecx,%edx
 59e:	77 04                	ja     5a4 <free+0x2f>
 5a0:	89 d0                	mov    %edx,%eax
 5a2:	eb e6                	jmp    58a <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5aa:	8b 10                	mov    (%eax),%edx
 5ac:	39 d7                	cmp    %edx,%edi
 5ae:	74 19                	je     5c9 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b3:	8b 50 04             	mov    0x4(%eax),%edx
 5b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b9:	39 ce                	cmp    %ecx,%esi
 5bb:	74 1b                	je     5d8 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5bd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5bf:	a3 c8 09 00 00       	mov    %eax,0x9c8
}
 5c4:	5b                   	pop    %ebx
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5c9:	03 72 04             	add    0x4(%edx),%esi
 5cc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5cf:	8b 10                	mov    (%eax),%edx
 5d1:	8b 12                	mov    (%edx),%edx
 5d3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5d6:	eb db                	jmp    5b3 <free+0x3e>
    p->s.size += bp->s.size;
 5d8:	03 53 fc             	add    -0x4(%ebx),%edx
 5db:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5de:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5e1:	89 10                	mov    %edx,(%eax)
 5e3:	eb da                	jmp    5bf <free+0x4a>

000005e5 <morecore>:

static Header*
morecore(uint nu)
{
 5e5:	55                   	push   %ebp
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	53                   	push   %ebx
 5e9:	83 ec 04             	sub    $0x4,%esp
 5ec:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5ee:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5f3:	77 05                	ja     5fa <morecore+0x15>
    nu = 4096;
 5f5:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5fa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 601:	83 ec 0c             	sub    $0xc,%esp
 604:	50                   	push   %eax
 605:	e8 a8 fc ff ff       	call   2b2 <sbrk>
  if(p == (char*)-1)
 60a:	83 c4 10             	add    $0x10,%esp
 60d:	83 f8 ff             	cmp    $0xffffffff,%eax
 610:	74 1c                	je     62e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 612:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 615:	83 c0 08             	add    $0x8,%eax
 618:	83 ec 0c             	sub    $0xc,%esp
 61b:	50                   	push   %eax
 61c:	e8 54 ff ff ff       	call   575 <free>
  return freep;
 621:	a1 c8 09 00 00       	mov    0x9c8,%eax
 626:	83 c4 10             	add    $0x10,%esp
}
 629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 62c:	c9                   	leave  
 62d:	c3                   	ret    
    return 0;
 62e:	b8 00 00 00 00       	mov    $0x0,%eax
 633:	eb f4                	jmp    629 <morecore+0x44>

00000635 <malloc>:

void*
malloc(uint nbytes)
{
 635:	55                   	push   %ebp
 636:	89 e5                	mov    %esp,%ebp
 638:	53                   	push   %ebx
 639:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	8d 58 07             	lea    0x7(%eax),%ebx
 642:	c1 eb 03             	shr    $0x3,%ebx
 645:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 648:	8b 0d c8 09 00 00    	mov    0x9c8,%ecx
 64e:	85 c9                	test   %ecx,%ecx
 650:	74 04                	je     656 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 652:	8b 01                	mov    (%ecx),%eax
 654:	eb 4a                	jmp    6a0 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 656:	c7 05 c8 09 00 00 cc 	movl   $0x9cc,0x9c8
 65d:	09 00 00 
 660:	c7 05 cc 09 00 00 cc 	movl   $0x9cc,0x9cc
 667:	09 00 00 
    base.s.size = 0;
 66a:	c7 05 d0 09 00 00 00 	movl   $0x0,0x9d0
 671:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 674:	b9 cc 09 00 00       	mov    $0x9cc,%ecx
 679:	eb d7                	jmp    652 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 67b:	74 19                	je     696 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 67d:	29 da                	sub    %ebx,%edx
 67f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 682:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 685:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 688:	89 0d c8 09 00 00    	mov    %ecx,0x9c8
      return (void*)(p + 1);
 68e:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 694:	c9                   	leave  
 695:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 696:	8b 10                	mov    (%eax),%edx
 698:	89 11                	mov    %edx,(%ecx)
 69a:	eb ec                	jmp    688 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69c:	89 c1                	mov    %eax,%ecx
 69e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	39 da                	cmp    %ebx,%edx
 6a5:	73 d4                	jae    67b <malloc+0x46>
    if(p == freep)
 6a7:	39 05 c8 09 00 00    	cmp    %eax,0x9c8
 6ad:	75 ed                	jne    69c <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 6af:	89 d8                	mov    %ebx,%eax
 6b1:	e8 2f ff ff ff       	call   5e5 <morecore>
 6b6:	85 c0                	test   %eax,%eax
 6b8:	75 e2                	jne    69c <malloc+0x67>
 6ba:	eb d5                	jmp    691 <malloc+0x5c>
