
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 2c 00 00 00       	call   48 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 18                	jne    3b <matchstar+0x3b>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	0f b6 13             	movzbl (%ebx),%edx
  26:	84 d2                	test   %dl,%dl
  28:	74 16                	je     40 <matchstar+0x40>
  2a:	83 c3 01             	add    $0x1,%ebx
  2d:	0f be d2             	movsbl %dl,%edx
  30:	39 f2                	cmp    %esi,%edx
  32:	74 de                	je     12 <matchstar+0x12>
  34:	83 fe 2e             	cmp    $0x2e,%esi
  37:	74 d9                	je     12 <matchstar+0x12>
  39:	eb 05                	jmp    40 <matchstar+0x40>
      return 1;
  3b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <matchhere>:
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 08             	sub    $0x8,%esp
  4e:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  51:	0f b6 02             	movzbl (%edx),%eax
  54:	84 c0                	test   %al,%al
  56:	74 68                	je     c0 <matchhere+0x78>
  if(re[1] == '*')
  58:	0f b6 4a 01          	movzbl 0x1(%edx),%ecx
  5c:	80 f9 2a             	cmp    $0x2a,%cl
  5f:	74 1d                	je     7e <matchhere+0x36>
  if(re[0] == '$' && re[1] == '\0')
  61:	3c 24                	cmp    $0x24,%al
  63:	74 31                	je     96 <matchhere+0x4e>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  68:	0f b6 09             	movzbl (%ecx),%ecx
  6b:	84 c9                	test   %cl,%cl
  6d:	74 58                	je     c7 <matchhere+0x7f>
  6f:	3c 2e                	cmp    $0x2e,%al
  71:	74 35                	je     a8 <matchhere+0x60>
  73:	38 c8                	cmp    %cl,%al
  75:	74 31                	je     a8 <matchhere+0x60>
  return 0;
  77:	b8 00 00 00 00       	mov    $0x0,%eax
  7c:	eb 47                	jmp    c5 <matchhere+0x7d>
    return matchstar(re[0], re+2, text);
  7e:	83 ec 04             	sub    $0x4,%esp
  81:	ff 75 0c             	push   0xc(%ebp)
  84:	83 c2 02             	add    $0x2,%edx
  87:	52                   	push   %edx
  88:	0f be c0             	movsbl %al,%eax
  8b:	50                   	push   %eax
  8c:	e8 6f ff ff ff       	call   0 <matchstar>
  91:	83 c4 10             	add    $0x10,%esp
  94:	eb 2f                	jmp    c5 <matchhere+0x7d>
  if(re[0] == '$' && re[1] == '\0')
  96:	84 c9                	test   %cl,%cl
  98:	75 cb                	jne    65 <matchhere+0x1d>
    return *text == '\0';
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	80 38 00             	cmpb   $0x0,(%eax)
  a0:	0f 94 c0             	sete   %al
  a3:	0f b6 c0             	movzbl %al,%eax
  a6:	eb 1d                	jmp    c5 <matchhere+0x7d>
    return matchhere(re+1, text+1);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	83 c0 01             	add    $0x1,%eax
  b1:	50                   	push   %eax
  b2:	83 c2 01             	add    $0x1,%edx
  b5:	52                   	push   %edx
  b6:	e8 8d ff ff ff       	call   48 <matchhere>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 05                	jmp    c5 <matchhere+0x7d>
    return 1;
  c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    
  return 0;
  c7:	b8 00 00 00 00       	mov    $0x0,%eax
  cc:	eb f7                	jmp    c5 <matchhere+0x7d>

000000ce <match>:
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	56                   	push   %esi
  d2:	53                   	push   %ebx
  d3:	8b 75 08             	mov    0x8(%ebp),%esi
  d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  d9:	80 3e 5e             	cmpb   $0x5e,(%esi)
  dc:	75 14                	jne    f2 <match+0x24>
    return matchhere(re+1, text);
  de:	83 ec 08             	sub    $0x8,%esp
  e1:	53                   	push   %ebx
  e2:	83 c6 01             	add    $0x1,%esi
  e5:	56                   	push   %esi
  e6:	e8 5d ff ff ff       	call   48 <matchhere>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	eb 22                	jmp    112 <match+0x44>
  }while(*text++ != '\0');
  f0:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  f2:	83 ec 08             	sub    $0x8,%esp
  f5:	53                   	push   %ebx
  f6:	56                   	push   %esi
  f7:	e8 4c ff ff ff       	call   48 <matchhere>
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	85 c0                	test   %eax,%eax
 101:	75 0a                	jne    10d <match+0x3f>
  }while(*text++ != '\0');
 103:	8d 53 01             	lea    0x1(%ebx),%edx
 106:	80 3b 00             	cmpb   $0x0,(%ebx)
 109:	75 e5                	jne    f0 <match+0x22>
 10b:	eb 05                	jmp    112 <match+0x44>
      return 1;
 10d:	b8 01 00 00 00       	mov    $0x1,%eax
}
 112:	8d 65 f8             	lea    -0x8(%ebp),%esp
 115:	5b                   	pop    %ebx
 116:	5e                   	pop    %esi
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <grep>:
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	57                   	push   %edi
 11d:	56                   	push   %esi
 11e:	53                   	push   %ebx
 11f:	83 ec 1c             	sub    $0x1c,%esp
 122:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 125:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 12c:	eb 53                	jmp    181 <grep+0x68>
      p = q+1;
 12e:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 131:	83 ec 08             	sub    $0x8,%esp
 134:	6a 0a                	push   $0xa
 136:	56                   	push   %esi
 137:	e8 e1 01 00 00       	call   31d <strchr>
 13c:	89 c3                	mov    %eax,%ebx
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	74 2d                	je     172 <grep+0x59>
      *q = 0;
 145:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 148:	83 ec 08             	sub    $0x8,%esp
 14b:	56                   	push   %esi
 14c:	57                   	push   %edi
 14d:	e8 7c ff ff ff       	call   ce <match>
 152:	83 c4 10             	add    $0x10,%esp
 155:	85 c0                	test   %eax,%eax
 157:	74 d5                	je     12e <grep+0x15>
        *q = '\n';
 159:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 15c:	8d 43 01             	lea    0x1(%ebx),%eax
 15f:	83 ec 04             	sub    $0x4,%esp
 162:	29 f0                	sub    %esi,%eax
 164:	50                   	push   %eax
 165:	56                   	push   %esi
 166:	6a 01                	push   $0x1
 168:	e8 f2 02 00 00       	call   45f <write>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	eb bc                	jmp    12e <grep+0x15>
    if(p == buf)
 172:	81 fe 60 0c 00 00    	cmp    $0xc60,%esi
 178:	74 62                	je     1dc <grep+0xc3>
    if(m > 0){
 17a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 17d:	85 c9                	test   %ecx,%ecx
 17f:	7f 3b                	jg     1bc <grep+0xa3>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 181:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 186:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 189:	29 c8                	sub    %ecx,%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	50                   	push   %eax
 18f:	8d 81 60 0c 00 00    	lea    0xc60(%ecx),%eax
 195:	50                   	push   %eax
 196:	ff 75 0c             	push   0xc(%ebp)
 199:	e8 b9 02 00 00       	call   457 <read>
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	85 c0                	test   %eax,%eax
 1a3:	7e 40                	jle    1e5 <grep+0xcc>
    m += n;
 1a5:	01 45 e4             	add    %eax,-0x1c(%ebp)
 1a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 1ab:	c6 82 60 0c 00 00 00 	movb   $0x0,0xc60(%edx)
    p = buf;
 1b2:	be 60 0c 00 00       	mov    $0xc60,%esi
    while((q = strchr(p, '\n')) != 0){
 1b7:	e9 75 ff ff ff       	jmp    131 <grep+0x18>
      m -= p - buf;
 1bc:	89 f0                	mov    %esi,%eax
 1be:	2d 60 0c 00 00       	sub    $0xc60,%eax
 1c3:	29 c1                	sub    %eax,%ecx
 1c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 1c8:	83 ec 04             	sub    $0x4,%esp
 1cb:	51                   	push   %ecx
 1cc:	56                   	push   %esi
 1cd:	68 60 0c 00 00       	push   $0xc60
 1d2:	e8 34 02 00 00       	call   40b <memmove>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	eb a5                	jmp    181 <grep+0x68>
      m = 0;
 1dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1e3:	eb 9c                	jmp    181 <grep+0x68>
}
 1e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e8:	5b                   	pop    %ebx
 1e9:	5e                   	pop    %esi
 1ea:	5f                   	pop    %edi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    

000001ed <main>:
{
 1ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1f1:	83 e4 f0             	and    $0xfffffff0,%esp
 1f4:	ff 71 fc             	push   -0x4(%ecx)
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	57                   	push   %edi
 1fb:	56                   	push   %esi
 1fc:	53                   	push   %ebx
 1fd:	51                   	push   %ecx
 1fe:	83 ec 18             	sub    $0x18,%esp
 201:	8b 01                	mov    (%ecx),%eax
 203:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 206:	8b 51 04             	mov    0x4(%ecx),%edx
 209:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 20c:	83 f8 01             	cmp    $0x1,%eax
 20f:	7e 50                	jle    261 <main+0x74>
  pattern = argv[1];
 211:	8b 45 e0             	mov    -0x20(%ebp),%eax
 214:	8b 40 04             	mov    0x4(%eax),%eax
 217:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 21a:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 21e:	7e 55                	jle    275 <main+0x88>
  for(i = 2; i < argc; i++){
 220:	be 02 00 00 00       	mov    $0x2,%esi
 225:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 228:	7d 71                	jge    29b <main+0xae>
    if((fd = open(argv[i], 0)) < 0){
 22a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22d:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 230:	83 ec 08             	sub    $0x8,%esp
 233:	6a 00                	push   $0x0
 235:	ff 37                	push   (%edi)
 237:	e8 43 02 00 00       	call   47f <open>
 23c:	89 c3                	mov    %eax,%ebx
 23e:	83 c4 10             	add    $0x10,%esp
 241:	85 c0                	test   %eax,%eax
 243:	78 40                	js     285 <main+0x98>
    grep(pattern, fd);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	50                   	push   %eax
 249:	ff 75 dc             	push   -0x24(%ebp)
 24c:	e8 c8 fe ff ff       	call   119 <grep>
    close(fd);
 251:	89 1c 24             	mov    %ebx,(%esp)
 254:	e8 0e 02 00 00       	call   467 <close>
  for(i = 2; i < argc; i++){
 259:	83 c6 01             	add    $0x1,%esi
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	eb c4                	jmp    225 <main+0x38>
    printf(2, "usage: grep pattern [file ...]\n");
 261:	83 ec 08             	sub    $0x8,%esp
 264:	68 5c 08 00 00       	push   $0x85c
 269:	6a 02                	push   $0x2
 26b:	e8 3c 03 00 00       	call   5ac <printf>
    exit();
 270:	e8 ca 01 00 00       	call   43f <exit>
    grep(pattern, 0);
 275:	83 ec 08             	sub    $0x8,%esp
 278:	6a 00                	push   $0x0
 27a:	50                   	push   %eax
 27b:	e8 99 fe ff ff       	call   119 <grep>
    exit();
 280:	e8 ba 01 00 00       	call   43f <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 285:	83 ec 04             	sub    $0x4,%esp
 288:	ff 37                	push   (%edi)
 28a:	68 7c 08 00 00       	push   $0x87c
 28f:	6a 01                	push   $0x1
 291:	e8 16 03 00 00       	call   5ac <printf>
      exit();
 296:	e8 a4 01 00 00       	call   43f <exit>
  exit();
 29b:	e8 9f 01 00 00       	call   43f <exit>

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	8b 75 08             	mov    0x8(%ebp),%esi
 2a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ab:	89 f0                	mov    %esi,%eax
 2ad:	89 d1                	mov    %edx,%ecx
 2af:	83 c2 01             	add    $0x1,%edx
 2b2:	89 c3                	mov    %eax,%ebx
 2b4:	83 c0 01             	add    $0x1,%eax
 2b7:	0f b6 09             	movzbl (%ecx),%ecx
 2ba:	88 0b                	mov    %cl,(%ebx)
 2bc:	84 c9                	test   %cl,%cl
 2be:	75 ed                	jne    2ad <strcpy+0xd>
    ;
  return os;
}
 2c0:	89 f0                	mov    %esi,%eax
 2c2:	5b                   	pop    %ebx
 2c3:	5e                   	pop    %esi
 2c4:	5d                   	pop    %ebp
 2c5:	c3                   	ret    

000002c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2cf:	eb 06                	jmp    2d7 <strcmp+0x11>
    p++, q++;
 2d1:	83 c1 01             	add    $0x1,%ecx
 2d4:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2d7:	0f b6 01             	movzbl (%ecx),%eax
 2da:	84 c0                	test   %al,%al
 2dc:	74 04                	je     2e2 <strcmp+0x1c>
 2de:	3a 02                	cmp    (%edx),%al
 2e0:	74 ef                	je     2d1 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 2e2:	0f b6 c0             	movzbl %al,%eax
 2e5:	0f b6 12             	movzbl (%edx),%edx
 2e8:	29 d0                	sub    %edx,%eax
}
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    

000002ec <strlen>:

uint
strlen(const char *s)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
 2f7:	eb 03                	jmp    2fc <strlen+0x10>
 2f9:	83 c0 01             	add    $0x1,%eax
 2fc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 300:	75 f7                	jne    2f9 <strlen+0xd>
    ;
  return n;
}
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <memset>:

void*
memset(void *dst, int c, uint n)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 30b:	89 d7                	mov    %edx,%edi
 30d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 310:	8b 45 0c             	mov    0xc(%ebp),%eax
 313:	fc                   	cld    
 314:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 316:	89 d0                	mov    %edx,%eax
 318:	8b 7d fc             	mov    -0x4(%ebp),%edi
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <strchr>:

char*
strchr(const char *s, char c)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 327:	eb 03                	jmp    32c <strchr+0xf>
 329:	83 c0 01             	add    $0x1,%eax
 32c:	0f b6 10             	movzbl (%eax),%edx
 32f:	84 d2                	test   %dl,%dl
 331:	74 06                	je     339 <strchr+0x1c>
    if(*s == c)
 333:	38 ca                	cmp    %cl,%dl
 335:	75 f2                	jne    329 <strchr+0xc>
 337:	eb 05                	jmp    33e <strchr+0x21>
      return (char*)s;
  return 0;
 339:	b8 00 00 00 00       	mov    $0x0,%eax
}
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	83 ec 1c             	sub    $0x1c,%esp
 349:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	bb 00 00 00 00       	mov    $0x0,%ebx
 351:	89 de                	mov    %ebx,%esi
 353:	83 c3 01             	add    $0x1,%ebx
 356:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 359:	7d 2e                	jge    389 <gets+0x49>
    cc = read(0, &c, 1);
 35b:	83 ec 04             	sub    $0x4,%esp
 35e:	6a 01                	push   $0x1
 360:	8d 45 e7             	lea    -0x19(%ebp),%eax
 363:	50                   	push   %eax
 364:	6a 00                	push   $0x0
 366:	e8 ec 00 00 00       	call   457 <read>
    if(cc < 1)
 36b:	83 c4 10             	add    $0x10,%esp
 36e:	85 c0                	test   %eax,%eax
 370:	7e 17                	jle    389 <gets+0x49>
      break;
    buf[i++] = c;
 372:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 376:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 379:	3c 0a                	cmp    $0xa,%al
 37b:	0f 94 c2             	sete   %dl
 37e:	3c 0d                	cmp    $0xd,%al
 380:	0f 94 c0             	sete   %al
 383:	08 c2                	or     %al,%dl
 385:	74 ca                	je     351 <gets+0x11>
    buf[i++] = c;
 387:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 389:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 38d:	89 f8                	mov    %edi,%eax
 38f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 392:	5b                   	pop    %ebx
 393:	5e                   	pop    %esi
 394:	5f                   	pop    %edi
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    

00000397 <stat>:

int
stat(const char *n, struct stat *st)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	56                   	push   %esi
 39b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39c:	83 ec 08             	sub    $0x8,%esp
 39f:	6a 00                	push   $0x0
 3a1:	ff 75 08             	push   0x8(%ebp)
 3a4:	e8 d6 00 00 00       	call   47f <open>
  if(fd < 0)
 3a9:	83 c4 10             	add    $0x10,%esp
 3ac:	85 c0                	test   %eax,%eax
 3ae:	78 24                	js     3d4 <stat+0x3d>
 3b0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3b2:	83 ec 08             	sub    $0x8,%esp
 3b5:	ff 75 0c             	push   0xc(%ebp)
 3b8:	50                   	push   %eax
 3b9:	e8 d9 00 00 00       	call   497 <fstat>
 3be:	89 c6                	mov    %eax,%esi
  close(fd);
 3c0:	89 1c 24             	mov    %ebx,(%esp)
 3c3:	e8 9f 00 00 00       	call   467 <close>
  return r;
 3c8:	83 c4 10             	add    $0x10,%esp
}
 3cb:	89 f0                	mov    %esi,%eax
 3cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
    return -1;
 3d4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3d9:	eb f0                	jmp    3cb <stat+0x34>

000003db <atoi>:

int
atoi(const char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	53                   	push   %ebx
 3df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3e7:	eb 10                	jmp    3f9 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 3e9:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 3ec:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 3ef:	83 c1 01             	add    $0x1,%ecx
 3f2:	0f be c0             	movsbl %al,%eax
 3f5:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
 3f9:	0f b6 01             	movzbl (%ecx),%eax
 3fc:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3ff:	80 fb 09             	cmp    $0x9,%bl
 402:	76 e5                	jbe    3e9 <atoi+0xe>
  return n;
}
 404:	89 d0                	mov    %edx,%eax
 406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	56                   	push   %esi
 40f:	53                   	push   %ebx
 410:	8b 75 08             	mov    0x8(%ebp),%esi
 413:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 416:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 419:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 41b:	eb 0d                	jmp    42a <memmove+0x1f>
    *dst++ = *src++;
 41d:	0f b6 01             	movzbl (%ecx),%eax
 420:	88 02                	mov    %al,(%edx)
 422:	8d 49 01             	lea    0x1(%ecx),%ecx
 425:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 428:	89 d8                	mov    %ebx,%eax
 42a:	8d 58 ff             	lea    -0x1(%eax),%ebx
 42d:	85 c0                	test   %eax,%eax
 42f:	7f ec                	jg     41d <memmove+0x12>
  return vdst;
}
 431:	89 f0                	mov    %esi,%eax
 433:	5b                   	pop    %ebx
 434:	5e                   	pop    %esi
 435:	5d                   	pop    %ebp
 436:	c3                   	ret    

00000437 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 437:	b8 01 00 00 00       	mov    $0x1,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <exit>:
SYSCALL(exit)
 43f:	b8 02 00 00 00       	mov    $0x2,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <wait>:
SYSCALL(wait)
 447:	b8 03 00 00 00       	mov    $0x3,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <pipe>:
SYSCALL(pipe)
 44f:	b8 04 00 00 00       	mov    $0x4,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <read>:
SYSCALL(read)
 457:	b8 05 00 00 00       	mov    $0x5,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <write>:
SYSCALL(write)
 45f:	b8 10 00 00 00       	mov    $0x10,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <close>:
SYSCALL(close)
 467:	b8 15 00 00 00       	mov    $0x15,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <kill>:
SYSCALL(kill)
 46f:	b8 06 00 00 00       	mov    $0x6,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <exec>:
SYSCALL(exec)
 477:	b8 07 00 00 00       	mov    $0x7,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <open>:
SYSCALL(open)
 47f:	b8 0f 00 00 00       	mov    $0xf,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <mknod>:
SYSCALL(mknod)
 487:	b8 11 00 00 00       	mov    $0x11,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <unlink>:
SYSCALL(unlink)
 48f:	b8 12 00 00 00       	mov    $0x12,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <fstat>:
SYSCALL(fstat)
 497:	b8 08 00 00 00       	mov    $0x8,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <link>:
SYSCALL(link)
 49f:	b8 13 00 00 00       	mov    $0x13,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <mkdir>:
SYSCALL(mkdir)
 4a7:	b8 14 00 00 00       	mov    $0x14,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <chdir>:
SYSCALL(chdir)
 4af:	b8 09 00 00 00       	mov    $0x9,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <dup>:
SYSCALL(dup)
 4b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <getpid>:
SYSCALL(getpid)
 4bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <sbrk>:
SYSCALL(sbrk)
 4c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <sleep>:
SYSCALL(sleep)
 4cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <uptime>:
SYSCALL(uptime)
 4d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <hello>:
SYSCALL(hello)
 4df:	b8 16 00 00 00       	mov    $0x16,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <helloYou>:
SYSCALL(helloYou)
 4e7:	b8 17 00 00 00       	mov    $0x17,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <getppid>:
SYSCALL(getppid)
 4ef:	b8 18 00 00 00       	mov    $0x18,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <get_siblings_info>:
SYSCALL(get_siblings_info)
 4f7:	b8 19 00 00 00       	mov    $0x19,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <signalProcess>:
 4ff:	b8 1a 00 00 00       	mov    $0x1a,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	83 ec 1c             	sub    $0x1c,%esp
 50d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 510:	6a 01                	push   $0x1
 512:	8d 55 f4             	lea    -0xc(%ebp),%edx
 515:	52                   	push   %edx
 516:	50                   	push   %eax
 517:	e8 43 ff ff ff       	call   45f <write>
}
 51c:	83 c4 10             	add    $0x10,%esp
 51f:	c9                   	leave  
 520:	c3                   	ret    

00000521 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 521:	55                   	push   %ebp
 522:	89 e5                	mov    %esp,%ebp
 524:	57                   	push   %edi
 525:	56                   	push   %esi
 526:	53                   	push   %ebx
 527:	83 ec 2c             	sub    $0x2c,%esp
 52a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 52d:	89 d0                	mov    %edx,%eax
 52f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 531:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 535:	0f 95 c1             	setne  %cl
 538:	c1 ea 1f             	shr    $0x1f,%edx
 53b:	84 d1                	test   %dl,%cl
 53d:	74 44                	je     583 <printint+0x62>
    neg = 1;
    x = -xx;
 53f:	f7 d8                	neg    %eax
 541:	89 c1                	mov    %eax,%ecx
    neg = 1;
 543:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 54a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 54f:	89 c8                	mov    %ecx,%eax
 551:	ba 00 00 00 00       	mov    $0x0,%edx
 556:	f7 f6                	div    %esi
 558:	89 df                	mov    %ebx,%edi
 55a:	83 c3 01             	add    $0x1,%ebx
 55d:	0f b6 92 f4 08 00 00 	movzbl 0x8f4(%edx),%edx
 564:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 568:	89 ca                	mov    %ecx,%edx
 56a:	89 c1                	mov    %eax,%ecx
 56c:	39 d6                	cmp    %edx,%esi
 56e:	76 df                	jbe    54f <printint+0x2e>
  if(neg)
 570:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 574:	74 31                	je     5a7 <printint+0x86>
    buf[i++] = '-';
 576:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 57b:	8d 5f 02             	lea    0x2(%edi),%ebx
 57e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 581:	eb 17                	jmp    59a <printint+0x79>
    x = xx;
 583:	89 c1                	mov    %eax,%ecx
  neg = 0;
 585:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 58c:	eb bc                	jmp    54a <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
 58e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 593:	89 f0                	mov    %esi,%eax
 595:	e8 6d ff ff ff       	call   507 <putc>
  while(--i >= 0)
 59a:	83 eb 01             	sub    $0x1,%ebx
 59d:	79 ef                	jns    58e <printint+0x6d>
}
 59f:	83 c4 2c             	add    $0x2c,%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5aa:	eb ee                	jmp    59a <printint+0x79>

000005ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	53                   	push   %ebx
 5b2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5b5:	8d 45 10             	lea    0x10(%ebp),%eax
 5b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5bb:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5c0:	bb 00 00 00 00       	mov    $0x0,%ebx
 5c5:	eb 14                	jmp    5db <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5c7:	89 fa                	mov    %edi,%edx
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	e8 36 ff ff ff       	call   507 <putc>
 5d1:	eb 05                	jmp    5d8 <printf+0x2c>
      }
    } else if(state == '%'){
 5d3:	83 fe 25             	cmp    $0x25,%esi
 5d6:	74 25                	je     5fd <printf+0x51>
  for(i = 0; fmt[i]; i++){
 5d8:	83 c3 01             	add    $0x1,%ebx
 5db:	8b 45 0c             	mov    0xc(%ebp),%eax
 5de:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5e2:	84 c0                	test   %al,%al
 5e4:	0f 84 20 01 00 00    	je     70a <printf+0x15e>
    c = fmt[i] & 0xff;
 5ea:	0f be f8             	movsbl %al,%edi
 5ed:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5f0:	85 f6                	test   %esi,%esi
 5f2:	75 df                	jne    5d3 <printf+0x27>
      if(c == '%'){
 5f4:	83 f8 25             	cmp    $0x25,%eax
 5f7:	75 ce                	jne    5c7 <printf+0x1b>
        state = '%';
 5f9:	89 c6                	mov    %eax,%esi
 5fb:	eb db                	jmp    5d8 <printf+0x2c>
      if(c == 'd'){
 5fd:	83 f8 25             	cmp    $0x25,%eax
 600:	0f 84 cf 00 00 00    	je     6d5 <printf+0x129>
 606:	0f 8c dd 00 00 00    	jl     6e9 <printf+0x13d>
 60c:	83 f8 78             	cmp    $0x78,%eax
 60f:	0f 8f d4 00 00 00    	jg     6e9 <printf+0x13d>
 615:	83 f8 63             	cmp    $0x63,%eax
 618:	0f 8c cb 00 00 00    	jl     6e9 <printf+0x13d>
 61e:	83 e8 63             	sub    $0x63,%eax
 621:	83 f8 15             	cmp    $0x15,%eax
 624:	0f 87 bf 00 00 00    	ja     6e9 <printf+0x13d>
 62a:	ff 24 85 9c 08 00 00 	jmp    *0x89c(,%eax,4)
        printint(fd, *ap, 10, 1);
 631:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 634:	8b 17                	mov    (%edi),%edx
 636:	83 ec 0c             	sub    $0xc,%esp
 639:	6a 01                	push   $0x1
 63b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	e8 d9 fe ff ff       	call   521 <printint>
        ap++;
 648:	83 c7 04             	add    $0x4,%edi
 64b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 64e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 651:	be 00 00 00 00       	mov    $0x0,%esi
 656:	eb 80                	jmp    5d8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 658:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 65b:	8b 17                	mov    (%edi),%edx
 65d:	83 ec 0c             	sub    $0xc,%esp
 660:	6a 00                	push   $0x0
 662:	b9 10 00 00 00       	mov    $0x10,%ecx
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	e8 b2 fe ff ff       	call   521 <printint>
        ap++;
 66f:	83 c7 04             	add    $0x4,%edi
 672:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 675:	83 c4 10             	add    $0x10,%esp
      state = 0;
 678:	be 00 00 00 00       	mov    $0x0,%esi
 67d:	e9 56 ff ff ff       	jmp    5d8 <printf+0x2c>
        s = (char*)*ap;
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	8b 30                	mov    (%eax),%esi
        ap++;
 687:	83 c0 04             	add    $0x4,%eax
 68a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 68d:	85 f6                	test   %esi,%esi
 68f:	75 15                	jne    6a6 <printf+0xfa>
          s = "(null)";
 691:	be 92 08 00 00       	mov    $0x892,%esi
 696:	eb 0e                	jmp    6a6 <printf+0xfa>
          putc(fd, *s);
 698:	0f be d2             	movsbl %dl,%edx
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	e8 64 fe ff ff       	call   507 <putc>
          s++;
 6a3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6a6:	0f b6 16             	movzbl (%esi),%edx
 6a9:	84 d2                	test   %dl,%dl
 6ab:	75 eb                	jne    698 <printf+0xec>
      state = 0;
 6ad:	be 00 00 00 00       	mov    $0x0,%esi
 6b2:	e9 21 ff ff ff       	jmp    5d8 <printf+0x2c>
        putc(fd, *ap);
 6b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6ba:	0f be 17             	movsbl (%edi),%edx
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	e8 42 fe ff ff       	call   507 <putc>
        ap++;
 6c5:	83 c7 04             	add    $0x4,%edi
 6c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6cb:	be 00 00 00 00       	mov    $0x0,%esi
 6d0:	e9 03 ff ff ff       	jmp    5d8 <printf+0x2c>
        putc(fd, c);
 6d5:	89 fa                	mov    %edi,%edx
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	e8 28 fe ff ff       	call   507 <putc>
      state = 0;
 6df:	be 00 00 00 00       	mov    $0x0,%esi
 6e4:	e9 ef fe ff ff       	jmp    5d8 <printf+0x2c>
        putc(fd, '%');
 6e9:	ba 25 00 00 00       	mov    $0x25,%edx
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	e8 11 fe ff ff       	call   507 <putc>
        putc(fd, c);
 6f6:	89 fa                	mov    %edi,%edx
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	e8 07 fe ff ff       	call   507 <putc>
      state = 0;
 700:	be 00 00 00 00       	mov    $0x0,%esi
 705:	e9 ce fe ff ff       	jmp    5d8 <printf+0x2c>
    }
  }
}
 70a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    

00000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	57                   	push   %edi
 716:	56                   	push   %esi
 717:	53                   	push   %ebx
 718:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	a1 60 10 00 00       	mov    0x1060,%eax
 723:	eb 02                	jmp    727 <free+0x15>
 725:	89 d0                	mov    %edx,%eax
 727:	39 c8                	cmp    %ecx,%eax
 729:	73 04                	jae    72f <free+0x1d>
 72b:	39 08                	cmp    %ecx,(%eax)
 72d:	77 12                	ja     741 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72f:	8b 10                	mov    (%eax),%edx
 731:	39 c2                	cmp    %eax,%edx
 733:	77 f0                	ja     725 <free+0x13>
 735:	39 c8                	cmp    %ecx,%eax
 737:	72 08                	jb     741 <free+0x2f>
 739:	39 ca                	cmp    %ecx,%edx
 73b:	77 04                	ja     741 <free+0x2f>
 73d:	89 d0                	mov    %edx,%eax
 73f:	eb e6                	jmp    727 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 741:	8b 73 fc             	mov    -0x4(%ebx),%esi
 744:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 747:	8b 10                	mov    (%eax),%edx
 749:	39 d7                	cmp    %edx,%edi
 74b:	74 19                	je     766 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 74d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 756:	39 ce                	cmp    %ecx,%esi
 758:	74 1b                	je     775 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 75a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 75c:	a3 60 10 00 00       	mov    %eax,0x1060
}
 761:	5b                   	pop    %ebx
 762:	5e                   	pop    %esi
 763:	5f                   	pop    %edi
 764:	5d                   	pop    %ebp
 765:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 766:	03 72 04             	add    0x4(%edx),%esi
 769:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	8b 10                	mov    (%eax),%edx
 76e:	8b 12                	mov    (%edx),%edx
 770:	89 53 f8             	mov    %edx,-0x8(%ebx)
 773:	eb db                	jmp    750 <free+0x3e>
    p->s.size += bp->s.size;
 775:	03 53 fc             	add    -0x4(%ebx),%edx
 778:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb da                	jmp    75c <free+0x4a>

00000782 <morecore>:

static Header*
morecore(uint nu)
{
 782:	55                   	push   %ebp
 783:	89 e5                	mov    %esp,%ebp
 785:	53                   	push   %ebx
 786:	83 ec 04             	sub    $0x4,%esp
 789:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 78b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 790:	77 05                	ja     797 <morecore+0x15>
    nu = 4096;
 792:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 797:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 79e:	83 ec 0c             	sub    $0xc,%esp
 7a1:	50                   	push   %eax
 7a2:	e8 20 fd ff ff       	call   4c7 <sbrk>
  if(p == (char*)-1)
 7a7:	83 c4 10             	add    $0x10,%esp
 7aa:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ad:	74 1c                	je     7cb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7af:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7b2:	83 c0 08             	add    $0x8,%eax
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	50                   	push   %eax
 7b9:	e8 54 ff ff ff       	call   712 <free>
  return freep;
 7be:	a1 60 10 00 00       	mov    0x1060,%eax
 7c3:	83 c4 10             	add    $0x10,%esp
}
 7c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7c9:	c9                   	leave  
 7ca:	c3                   	ret    
    return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb f4                	jmp    7c6 <morecore+0x44>

000007d2 <malloc>:

void*
malloc(uint nbytes)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	53                   	push   %ebx
 7d6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	8d 58 07             	lea    0x7(%eax),%ebx
 7df:	c1 eb 03             	shr    $0x3,%ebx
 7e2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7e5:	8b 0d 60 10 00 00    	mov    0x1060,%ecx
 7eb:	85 c9                	test   %ecx,%ecx
 7ed:	74 04                	je     7f3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 01                	mov    (%ecx),%eax
 7f1:	eb 4a                	jmp    83d <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
 7f3:	c7 05 60 10 00 00 64 	movl   $0x1064,0x1060
 7fa:	10 00 00 
 7fd:	c7 05 64 10 00 00 64 	movl   $0x1064,0x1064
 804:	10 00 00 
    base.s.size = 0;
 807:	c7 05 68 10 00 00 00 	movl   $0x0,0x1068
 80e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 811:	b9 64 10 00 00       	mov    $0x1064,%ecx
 816:	eb d7                	jmp    7ef <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 818:	74 19                	je     833 <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 81a:	29 da                	sub    %ebx,%edx
 81c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 822:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 825:	89 0d 60 10 00 00    	mov    %ecx,0x1060
      return (void*)(p + 1);
 82b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 831:	c9                   	leave  
 832:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 833:	8b 10                	mov    (%eax),%edx
 835:	89 11                	mov    %edx,(%ecx)
 837:	eb ec                	jmp    825 <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	89 c1                	mov    %eax,%ecx
 83b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	39 da                	cmp    %ebx,%edx
 842:	73 d4                	jae    818 <malloc+0x46>
    if(p == freep)
 844:	39 05 60 10 00 00    	cmp    %eax,0x1060
 84a:	75 ed                	jne    839 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
 84c:	89 d8                	mov    %ebx,%eax
 84e:	e8 2f ff ff ff       	call   782 <morecore>
 853:	85 c0                	test   %eax,%eax
 855:	75 e2                	jne    839 <malloc+0x67>
 857:	eb d5                	jmp    82e <malloc+0x5c>
