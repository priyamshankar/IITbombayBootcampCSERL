
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 55 11 80       	mov    $0x801155f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 34 2a 10 80       	mov    $0x80102a34,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 74 3d 00 00       	call   80103dbf <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 20 a5 10 80       	push   $0x8010a520
8010007c:	e8 a3 3d 00 00       	call   80103e24 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 1f 3b 00 00       	call   80103bab <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 20 a5 10 80       	push   $0x8010a520
801000ca:	e8 55 3d 00 00       	call   80103e24 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 d1 3a 00 00       	call   80103bab <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 c0 69 10 80       	push   $0x801069c0
801000ef:	e8 54 02 00 00       	call   80100348 <panic>

801000f4 <binit>:
{
801000f4:	55                   	push   %ebp
801000f5:	89 e5                	mov    %esp,%ebp
801000f7:	53                   	push   %ebx
801000f8:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fb:	68 d1 69 10 80       	push   $0x801069d1
80100100:	68 20 a5 10 80       	push   $0x8010a520
80100105:	e8 79 3b 00 00       	call   80103c83 <initlock>
  bcache.head.prev = &bcache.head;
8010010a:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
80100111:	ec 10 80 
  bcache.head.next = &bcache.head;
80100114:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
8010011b:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011e:	83 c4 10             	add    $0x10,%esp
80100121:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100126:	eb 37                	jmp    8010015f <binit+0x6b>
    b->next = bcache.head.next;
80100128:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012d:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100130:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100137:	83 ec 08             	sub    $0x8,%esp
8010013a:	68 d8 69 10 80       	push   $0x801069d8
8010013f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100142:	50                   	push   %eax
80100143:	e8 30 3a 00 00       	call   80103b78 <initsleeplock>
    bcache.head.next->prev = b;
80100148:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014d:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100150:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100156:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015c:	83 c4 10             	add    $0x10,%esp
8010015f:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100165:	72 c1                	jb     80100128 <binit+0x34>
}
80100167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016a:	c9                   	leave  
8010016b:	c3                   	ret    

8010016c <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016c:	55                   	push   %ebp
8010016d:	89 e5                	mov    %esp,%ebp
8010016f:	53                   	push   %ebx
80100170:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100173:	8b 55 0c             	mov    0xc(%ebp),%edx
80100176:	8b 45 08             	mov    0x8(%ebp),%eax
80100179:	e8 b6 fe ff ff       	call   80100034 <bget>
8010017e:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100180:	f6 00 02             	testb  $0x2,(%eax)
80100183:	74 07                	je     8010018c <bread+0x20>
    iderw(b);
  }
  return b;
}
80100185:	89 d8                	mov    %ebx,%eax
80100187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010018a:	c9                   	leave  
8010018b:	c3                   	ret    
    iderw(b);
8010018c:	83 ec 0c             	sub    $0xc,%esp
8010018f:	50                   	push   %eax
80100190:	e8 62 1c 00 00       	call   80101df7 <iderw>
80100195:	83 c4 10             	add    $0x10,%esp
  return b;
80100198:	eb eb                	jmp    80100185 <bread+0x19>

8010019a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010019a:	55                   	push   %ebp
8010019b:	89 e5                	mov    %esp,%ebp
8010019d:	53                   	push   %ebx
8010019e:	83 ec 10             	sub    $0x10,%esp
801001a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a4:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a7:	50                   	push   %eax
801001a8:	e8 88 3a 00 00       	call   80103c35 <holdingsleep>
801001ad:	83 c4 10             	add    $0x10,%esp
801001b0:	85 c0                	test   %eax,%eax
801001b2:	74 14                	je     801001c8 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b4:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b7:	83 ec 0c             	sub    $0xc,%esp
801001ba:	53                   	push   %ebx
801001bb:	e8 37 1c 00 00       	call   80101df7 <iderw>
}
801001c0:	83 c4 10             	add    $0x10,%esp
801001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c6:	c9                   	leave  
801001c7:	c3                   	ret    
    panic("bwrite");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 df 69 10 80       	push   $0x801069df
801001d0:	e8 73 01 00 00       	call   80100348 <panic>

801001d5 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d5:	55                   	push   %ebp
801001d6:	89 e5                	mov    %esp,%ebp
801001d8:	56                   	push   %esi
801001d9:	53                   	push   %ebx
801001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001dd:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e0:	83 ec 0c             	sub    $0xc,%esp
801001e3:	56                   	push   %esi
801001e4:	e8 4c 3a 00 00       	call   80103c35 <holdingsleep>
801001e9:	83 c4 10             	add    $0x10,%esp
801001ec:	85 c0                	test   %eax,%eax
801001ee:	74 6b                	je     8010025b <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 01 3a 00 00       	call   80103bfa <releasesleep>

  acquire(&bcache.lock);
801001f9:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100200:	e8 ba 3b 00 00       	call   80103dbf <acquire>
  b->refcnt--;
80100205:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100208:	83 e8 01             	sub    $0x1,%eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2f                	jne    80100244 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 43 54             	mov    0x54(%ebx),%eax
80100218:	8b 53 50             	mov    0x50(%ebx),%edx
8010021b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021e:	8b 43 50             	mov    0x50(%ebx),%eax
80100221:	8b 53 54             	mov    0x54(%ebx),%edx
80100224:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100227:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010022c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022f:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100236:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010023b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100244:	83 ec 0c             	sub    $0xc,%esp
80100247:	68 20 a5 10 80       	push   $0x8010a520
8010024c:	e8 d3 3b 00 00       	call   80103e24 <release>
}
80100251:	83 c4 10             	add    $0x10,%esp
80100254:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100257:	5b                   	pop    %ebx
80100258:	5e                   	pop    %esi
80100259:	5d                   	pop    %ebp
8010025a:	c3                   	ret    
    panic("brelse");
8010025b:	83 ec 0c             	sub    $0xc,%esp
8010025e:	68 e6 69 10 80       	push   $0x801069e6
80100263:	e8 e0 00 00 00       	call   80100348 <panic>

80100268 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100268:	55                   	push   %ebp
80100269:	89 e5                	mov    %esp,%ebp
8010026b:	57                   	push   %edi
8010026c:	56                   	push   %esi
8010026d:	53                   	push   %ebx
8010026e:	83 ec 28             	sub    $0x28,%esp
80100271:	8b 7d 08             	mov    0x8(%ebp),%edi
80100274:	8b 75 0c             	mov    0xc(%ebp),%esi
80100277:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027a:	57                   	push   %edi
8010027b:	e8 b1 13 00 00       	call   80101631 <iunlock>
  target = n;
80100280:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100283:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010028a:	e8 30 3b 00 00       	call   80103dbf <acquire>
  while(n > 0){
8010028f:	83 c4 10             	add    $0x10,%esp
80100292:	85 db                	test   %ebx,%ebx
80100294:	0f 8e 8f 00 00 00    	jle    80100329 <consoleread+0xc1>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a5:	75 47                	jne    801002ee <consoleread+0x86>
      if(myproc()->killed){
801002a7:	e8 09 2f 00 00       	call   801031b5 <myproc>
801002ac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002b0:	75 17                	jne    801002c9 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b2:	83 ec 08             	sub    $0x8,%esp
801002b5:	68 20 ef 10 80       	push   $0x8010ef20
801002ba:	68 00 ef 10 80       	push   $0x8010ef00
801002bf:	e8 b8 33 00 00       	call   8010367c <sleep>
801002c4:	83 c4 10             	add    $0x10,%esp
801002c7:	eb d1                	jmp    8010029a <consoleread+0x32>
        release(&cons.lock);
801002c9:	83 ec 0c             	sub    $0xc,%esp
801002cc:	68 20 ef 10 80       	push   $0x8010ef20
801002d1:	e8 4e 3b 00 00       	call   80103e24 <release>
        ilock(ip);
801002d6:	89 3c 24             	mov    %edi,(%esp)
801002d9:	e8 91 12 00 00       	call   8010156f <ilock>
        return -1;
801002de:	83 c4 10             	add    $0x10,%esp
801002e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e9:	5b                   	pop    %ebx
801002ea:	5e                   	pop    %esi
801002eb:	5f                   	pop    %edi
801002ec:	5d                   	pop    %ebp
801002ed:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ee:	8d 50 01             	lea    0x1(%eax),%edx
801002f1:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f7:	89 c2                	mov    %eax,%edx
801002f9:	83 e2 7f             	and    $0x7f,%edx
801002fc:	0f b6 92 80 ee 10 80 	movzbl -0x7fef1180(%edx),%edx
80100303:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100306:	80 fa 04             	cmp    $0x4,%dl
80100309:	74 14                	je     8010031f <consoleread+0xb7>
    *dst++ = c;
8010030b:	8d 46 01             	lea    0x1(%esi),%eax
8010030e:	88 16                	mov    %dl,(%esi)
    --n;
80100310:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100313:	83 f9 0a             	cmp    $0xa,%ecx
80100316:	74 11                	je     80100329 <consoleread+0xc1>
    *dst++ = c;
80100318:	89 c6                	mov    %eax,%esi
8010031a:	e9 73 ff ff ff       	jmp    80100292 <consoleread+0x2a>
      if(n < target){
8010031f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100322:	73 05                	jae    80100329 <consoleread+0xc1>
        input.r--;
80100324:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100329:	83 ec 0c             	sub    $0xc,%esp
8010032c:	68 20 ef 10 80       	push   $0x8010ef20
80100331:	e8 ee 3a 00 00       	call   80103e24 <release>
  ilock(ip);
80100336:	89 3c 24             	mov    %edi,(%esp)
80100339:	e8 31 12 00 00       	call   8010156f <ilock>
  return target - n;
8010033e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100341:	29 d8                	sub    %ebx,%eax
80100343:	83 c4 10             	add    $0x10,%esp
80100346:	eb 9e                	jmp    801002e6 <consoleread+0x7e>

80100348 <panic>:
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	53                   	push   %ebx
8010034c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034f:	fa                   	cli    
  cons.locking = 0;
80100350:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100357:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010035a:	e8 01 20 00 00       	call   80102360 <lapicid>
8010035f:	83 ec 08             	sub    $0x8,%esp
80100362:	50                   	push   %eax
80100363:	68 ed 69 10 80       	push   $0x801069ed
80100368:	e8 9a 02 00 00       	call   80100607 <cprintf>
  cprintf(s);
8010036d:	83 c4 04             	add    $0x4,%esp
80100370:	ff 75 08             	push   0x8(%ebp)
80100373:	e8 8f 02 00 00       	call   80100607 <cprintf>
  cprintf("\n");
80100378:	c7 04 24 17 74 10 80 	movl   $0x80107417,(%esp)
8010037f:	e8 83 02 00 00       	call   80100607 <cprintf>
  getcallerpcs(&s, pcs);
80100384:	83 c4 08             	add    $0x8,%esp
80100387:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	8d 45 08             	lea    0x8(%ebp),%eax
8010038e:	50                   	push   %eax
8010038f:	e8 0a 39 00 00       	call   80103c9e <getcallerpcs>
  for(i=0; i<10; i++)
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	bb 00 00 00 00       	mov    $0x0,%ebx
8010039c:	eb 17                	jmp    801003b5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
801003a5:	68 01 6a 10 80       	push   $0x80106a01
801003aa:	e8 58 02 00 00       	call   80100607 <cprintf>
  for(i=0; i<10; i++)
801003af:	83 c3 01             	add    $0x1,%ebx
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	83 fb 09             	cmp    $0x9,%ebx
801003b8:	7e e4                	jle    8010039e <panic+0x56>
  panicked = 1; // freeze other CPU
801003ba:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003c1:	00 00 00 
  for(;;)
801003c4:	eb fe                	jmp    801003c4 <panic+0x7c>

801003c6 <cgaputc>:
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	57                   	push   %edi
801003ca:	56                   	push   %esi
801003cb:	53                   	push   %ebx
801003cc:	83 ec 0c             	sub    $0xc,%esp
801003cf:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d1:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003d6:	b8 0e 00 00 00       	mov    $0xe,%eax
801003db:	89 fa                	mov    %edi,%edx
801003dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003de:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003e3:	89 ca                	mov    %ecx,%edx
801003e5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003e6:	0f b6 f0             	movzbl %al,%esi
801003e9:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801003f1:	89 fa                	mov    %edi,%edx
801003f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f4:	89 ca                	mov    %ecx,%edx
801003f6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003f7:	0f b6 c8             	movzbl %al,%ecx
801003fa:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003fc:	83 fb 0a             	cmp    $0xa,%ebx
801003ff:	74 60                	je     80100461 <cgaputc+0x9b>
  else if(c == BACKSPACE){
80100401:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100407:	74 79                	je     80100482 <cgaputc+0xbc>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100409:	0f b6 c3             	movzbl %bl,%eax
8010040c:	8d 59 01             	lea    0x1(%ecx),%ebx
8010040f:	80 cc 07             	or     $0x7,%ah
80100412:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100419:	80 
  if(pos < 0 || pos > 25*80)
8010041a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100420:	77 6d                	ja     8010048f <cgaputc+0xc9>
  if((pos/80) >= 24){  // Scroll up.
80100422:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100428:	7f 72                	jg     8010049c <cgaputc+0xd6>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010042f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100434:	89 f2                	mov    %esi,%edx
80100436:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100437:	0f b6 c7             	movzbl %bh,%eax
8010043a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010043f:	89 ca                	mov    %ecx,%edx
80100441:	ee                   	out    %al,(%dx)
80100442:	b8 0f 00 00 00       	mov    $0xf,%eax
80100447:	89 f2                	mov    %esi,%edx
80100449:	ee                   	out    %al,(%dx)
8010044a:	89 d8                	mov    %ebx,%eax
8010044c:	89 ca                	mov    %ecx,%edx
8010044e:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010044f:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100456:	80 20 07 
}
80100459:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010045c:	5b                   	pop    %ebx
8010045d:	5e                   	pop    %esi
8010045e:	5f                   	pop    %edi
8010045f:	5d                   	pop    %ebp
80100460:	c3                   	ret    
    pos += 80 - pos%80;
80100461:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100466:	89 c8                	mov    %ecx,%eax
80100468:	f7 ea                	imul   %edx
8010046a:	c1 fa 05             	sar    $0x5,%edx
8010046d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100470:	c1 e0 04             	shl    $0x4,%eax
80100473:	89 ca                	mov    %ecx,%edx
80100475:	29 c2                	sub    %eax,%edx
80100477:	bb 50 00 00 00       	mov    $0x50,%ebx
8010047c:	29 d3                	sub    %edx,%ebx
8010047e:	01 cb                	add    %ecx,%ebx
80100480:	eb 98                	jmp    8010041a <cgaputc+0x54>
    if(pos > 0) --pos;
80100482:	85 c9                	test   %ecx,%ecx
80100484:	7e 05                	jle    8010048b <cgaputc+0xc5>
80100486:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100489:	eb 8f                	jmp    8010041a <cgaputc+0x54>
  pos |= inb(CRTPORT+1);
8010048b:	89 cb                	mov    %ecx,%ebx
8010048d:	eb 8b                	jmp    8010041a <cgaputc+0x54>
    panic("pos under/overflow");
8010048f:	83 ec 0c             	sub    $0xc,%esp
80100492:	68 05 6a 10 80       	push   $0x80106a05
80100497:	e8 ac fe ff ff       	call   80100348 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010049c:	83 ec 04             	sub    $0x4,%esp
8010049f:	68 60 0e 00 00       	push   $0xe60
801004a4:	68 a0 80 0b 80       	push   $0x800b80a0
801004a9:	68 00 80 0b 80       	push   $0x800b8000
801004ae:	e8 30 3a 00 00       	call   80103ee3 <memmove>
    pos -= 80;
801004b3:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004b6:	b8 80 07 00 00       	mov    $0x780,%eax
801004bb:	29 d8                	sub    %ebx,%eax
801004bd:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004c4:	83 c4 0c             	add    $0xc,%esp
801004c7:	01 c0                	add    %eax,%eax
801004c9:	50                   	push   %eax
801004ca:	6a 00                	push   $0x0
801004cc:	52                   	push   %edx
801004cd:	e8 99 39 00 00       	call   80103e6b <memset>
801004d2:	83 c4 10             	add    $0x10,%esp
801004d5:	e9 50 ff ff ff       	jmp    8010042a <cgaputc+0x64>

801004da <consputc>:
  if(panicked){
801004da:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004e1:	74 03                	je     801004e6 <consputc+0xc>
  asm volatile("cli");
801004e3:	fa                   	cli    
    for(;;)
801004e4:	eb fe                	jmp    801004e4 <consputc+0xa>
{
801004e6:	55                   	push   %ebp
801004e7:	89 e5                	mov    %esp,%ebp
801004e9:	53                   	push   %ebx
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004ef:	3d 00 01 00 00       	cmp    $0x100,%eax
801004f4:	74 18                	je     8010050e <consputc+0x34>
    uartputc(c);
801004f6:	83 ec 0c             	sub    $0xc,%esp
801004f9:	50                   	push   %eax
801004fa:	e8 d3 4e 00 00       	call   801053d2 <uartputc>
801004ff:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100502:	89 d8                	mov    %ebx,%eax
80100504:	e8 bd fe ff ff       	call   801003c6 <cgaputc>
}
80100509:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010050c:	c9                   	leave  
8010050d:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010050e:	83 ec 0c             	sub    $0xc,%esp
80100511:	6a 08                	push   $0x8
80100513:	e8 ba 4e 00 00       	call   801053d2 <uartputc>
80100518:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010051f:	e8 ae 4e 00 00       	call   801053d2 <uartputc>
80100524:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052b:	e8 a2 4e 00 00       	call   801053d2 <uartputc>
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	eb cd                	jmp    80100502 <consputc+0x28>

80100535 <printint>:
{
80100535:	55                   	push   %ebp
80100536:	89 e5                	mov    %esp,%ebp
80100538:	57                   	push   %edi
80100539:	56                   	push   %esi
8010053a:	53                   	push   %ebx
8010053b:	83 ec 2c             	sub    $0x2c,%esp
8010053e:	89 d6                	mov    %edx,%esi
80100540:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100543:	85 c9                	test   %ecx,%ecx
80100545:	74 0c                	je     80100553 <printint+0x1e>
80100547:	89 c7                	mov    %eax,%edi
80100549:	c1 ef 1f             	shr    $0x1f,%edi
8010054c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010054f:	85 c0                	test   %eax,%eax
80100551:	78 38                	js     8010058b <printint+0x56>
    x = xx;
80100553:	89 c1                	mov    %eax,%ecx
  i = 0;
80100555:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
8010055a:	89 c8                	mov    %ecx,%eax
8010055c:	ba 00 00 00 00       	mov    $0x0,%edx
80100561:	f7 f6                	div    %esi
80100563:	89 df                	mov    %ebx,%edi
80100565:	83 c3 01             	add    $0x1,%ebx
80100568:	0f b6 92 30 6a 10 80 	movzbl -0x7fef95d0(%edx),%edx
8010056f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100573:	89 ca                	mov    %ecx,%edx
80100575:	89 c1                	mov    %eax,%ecx
80100577:	39 d6                	cmp    %edx,%esi
80100579:	76 df                	jbe    8010055a <printint+0x25>
  if(sign)
8010057b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010057f:	74 1a                	je     8010059b <printint+0x66>
    buf[i++] = '-';
80100581:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100586:	8d 5f 02             	lea    0x2(%edi),%ebx
80100589:	eb 10                	jmp    8010059b <printint+0x66>
    x = -xx;
8010058b:	f7 d8                	neg    %eax
8010058d:	89 c1                	mov    %eax,%ecx
8010058f:	eb c4                	jmp    80100555 <printint+0x20>
    consputc(buf[i]);
80100591:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
80100596:	e8 3f ff ff ff       	call   801004da <consputc>
  while(--i >= 0)
8010059b:	83 eb 01             	sub    $0x1,%ebx
8010059e:	79 f1                	jns    80100591 <printint+0x5c>
}
801005a0:	83 c4 2c             	add    $0x2c,%esp
801005a3:	5b                   	pop    %ebx
801005a4:	5e                   	pop    %esi
801005a5:	5f                   	pop    %edi
801005a6:	5d                   	pop    %ebp
801005a7:	c3                   	ret    

801005a8 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005a8:	55                   	push   %ebp
801005a9:	89 e5                	mov    %esp,%ebp
801005ab:	57                   	push   %edi
801005ac:	56                   	push   %esi
801005ad:	53                   	push   %ebx
801005ae:	83 ec 18             	sub    $0x18,%esp
801005b1:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005b4:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005b7:	ff 75 08             	push   0x8(%ebp)
801005ba:	e8 72 10 00 00       	call   80101631 <iunlock>
  acquire(&cons.lock);
801005bf:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005c6:	e8 f4 37 00 00       	call   80103dbf <acquire>
  for(i = 0; i < n; i++)
801005cb:	83 c4 10             	add    $0x10,%esp
801005ce:	bb 00 00 00 00       	mov    $0x0,%ebx
801005d3:	eb 0c                	jmp    801005e1 <consolewrite+0x39>
    consputc(buf[i] & 0xff);
801005d5:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005d9:	e8 fc fe ff ff       	call   801004da <consputc>
  for(i = 0; i < n; i++)
801005de:	83 c3 01             	add    $0x1,%ebx
801005e1:	39 f3                	cmp    %esi,%ebx
801005e3:	7c f0                	jl     801005d5 <consolewrite+0x2d>
  release(&cons.lock);
801005e5:	83 ec 0c             	sub    $0xc,%esp
801005e8:	68 20 ef 10 80       	push   $0x8010ef20
801005ed:	e8 32 38 00 00       	call   80103e24 <release>
  ilock(ip);
801005f2:	83 c4 04             	add    $0x4,%esp
801005f5:	ff 75 08             	push   0x8(%ebp)
801005f8:	e8 72 0f 00 00       	call   8010156f <ilock>

  return n;
}
801005fd:	89 f0                	mov    %esi,%eax
801005ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100602:	5b                   	pop    %ebx
80100603:	5e                   	pop    %esi
80100604:	5f                   	pop    %edi
80100605:	5d                   	pop    %ebp
80100606:	c3                   	ret    

80100607 <cprintf>:
{
80100607:	55                   	push   %ebp
80100608:	89 e5                	mov    %esp,%ebp
8010060a:	57                   	push   %edi
8010060b:	56                   	push   %esi
8010060c:	53                   	push   %ebx
8010060d:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100610:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
80100615:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100618:	85 c0                	test   %eax,%eax
8010061a:	75 10                	jne    8010062c <cprintf+0x25>
  if (fmt == 0)
8010061c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100620:	74 1c                	je     8010063e <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
80100622:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100625:	be 00 00 00 00       	mov    $0x0,%esi
8010062a:	eb 27                	jmp    80100653 <cprintf+0x4c>
    acquire(&cons.lock);
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	68 20 ef 10 80       	push   $0x8010ef20
80100634:	e8 86 37 00 00       	call   80103dbf <acquire>
80100639:	83 c4 10             	add    $0x10,%esp
8010063c:	eb de                	jmp    8010061c <cprintf+0x15>
    panic("null fmt");
8010063e:	83 ec 0c             	sub    $0xc,%esp
80100641:	68 1f 6a 10 80       	push   $0x80106a1f
80100646:	e8 fd fc ff ff       	call   80100348 <panic>
      consputc(c);
8010064b:	e8 8a fe ff ff       	call   801004da <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100650:	83 c6 01             	add    $0x1,%esi
80100653:	8b 55 08             	mov    0x8(%ebp),%edx
80100656:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010065a:	85 c0                	test   %eax,%eax
8010065c:	0f 84 b1 00 00 00    	je     80100713 <cprintf+0x10c>
    if(c != '%'){
80100662:	83 f8 25             	cmp    $0x25,%eax
80100665:	75 e4                	jne    8010064b <cprintf+0x44>
    c = fmt[++i] & 0xff;
80100667:	83 c6 01             	add    $0x1,%esi
8010066a:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
8010066e:	85 db                	test   %ebx,%ebx
80100670:	0f 84 9d 00 00 00    	je     80100713 <cprintf+0x10c>
    switch(c){
80100676:	83 fb 70             	cmp    $0x70,%ebx
80100679:	74 2e                	je     801006a9 <cprintf+0xa2>
8010067b:	7f 22                	jg     8010069f <cprintf+0x98>
8010067d:	83 fb 25             	cmp    $0x25,%ebx
80100680:	74 6c                	je     801006ee <cprintf+0xe7>
80100682:	83 fb 64             	cmp    $0x64,%ebx
80100685:	75 76                	jne    801006fd <cprintf+0xf6>
      printint(*argp++, 10, 1);
80100687:	8d 5f 04             	lea    0x4(%edi),%ebx
8010068a:	8b 07                	mov    (%edi),%eax
8010068c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100691:	ba 0a 00 00 00       	mov    $0xa,%edx
80100696:	e8 9a fe ff ff       	call   80100535 <printint>
8010069b:	89 df                	mov    %ebx,%edi
      break;
8010069d:	eb b1                	jmp    80100650 <cprintf+0x49>
    switch(c){
8010069f:	83 fb 73             	cmp    $0x73,%ebx
801006a2:	74 1d                	je     801006c1 <cprintf+0xba>
801006a4:	83 fb 78             	cmp    $0x78,%ebx
801006a7:	75 54                	jne    801006fd <cprintf+0xf6>
      printint(*argp++, 16, 0);
801006a9:	8d 5f 04             	lea    0x4(%edi),%ebx
801006ac:	8b 07                	mov    (%edi),%eax
801006ae:	b9 00 00 00 00       	mov    $0x0,%ecx
801006b3:	ba 10 00 00 00       	mov    $0x10,%edx
801006b8:	e8 78 fe ff ff       	call   80100535 <printint>
801006bd:	89 df                	mov    %ebx,%edi
      break;
801006bf:	eb 8f                	jmp    80100650 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
801006c1:	8d 47 04             	lea    0x4(%edi),%eax
801006c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006c7:	8b 1f                	mov    (%edi),%ebx
801006c9:	85 db                	test   %ebx,%ebx
801006cb:	75 12                	jne    801006df <cprintf+0xd8>
        s = "(null)";
801006cd:	bb 18 6a 10 80       	mov    $0x80106a18,%ebx
801006d2:	eb 0b                	jmp    801006df <cprintf+0xd8>
        consputc(*s);
801006d4:	0f be c0             	movsbl %al,%eax
801006d7:	e8 fe fd ff ff       	call   801004da <consputc>
      for(; *s; s++)
801006dc:	83 c3 01             	add    $0x1,%ebx
801006df:	0f b6 03             	movzbl (%ebx),%eax
801006e2:	84 c0                	test   %al,%al
801006e4:	75 ee                	jne    801006d4 <cprintf+0xcd>
      if((s = (char*)*argp++) == 0)
801006e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006e9:	e9 62 ff ff ff       	jmp    80100650 <cprintf+0x49>
      consputc('%');
801006ee:	b8 25 00 00 00       	mov    $0x25,%eax
801006f3:	e8 e2 fd ff ff       	call   801004da <consputc>
      break;
801006f8:	e9 53 ff ff ff       	jmp    80100650 <cprintf+0x49>
      consputc('%');
801006fd:	b8 25 00 00 00       	mov    $0x25,%eax
80100702:	e8 d3 fd ff ff       	call   801004da <consputc>
      consputc(c);
80100707:	89 d8                	mov    %ebx,%eax
80100709:	e8 cc fd ff ff       	call   801004da <consputc>
      break;
8010070e:	e9 3d ff ff ff       	jmp    80100650 <cprintf+0x49>
  if(locking)
80100713:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100717:	75 08                	jne    80100721 <cprintf+0x11a>
}
80100719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071c:	5b                   	pop    %ebx
8010071d:	5e                   	pop    %esi
8010071e:	5f                   	pop    %edi
8010071f:	5d                   	pop    %ebp
80100720:	c3                   	ret    
    release(&cons.lock);
80100721:	83 ec 0c             	sub    $0xc,%esp
80100724:	68 20 ef 10 80       	push   $0x8010ef20
80100729:	e8 f6 36 00 00       	call   80103e24 <release>
8010072e:	83 c4 10             	add    $0x10,%esp
}
80100731:	eb e6                	jmp    80100719 <cprintf+0x112>

80100733 <consoleintr>:
{
80100733:	55                   	push   %ebp
80100734:	89 e5                	mov    %esp,%ebp
80100736:	57                   	push   %edi
80100737:	56                   	push   %esi
80100738:	53                   	push   %ebx
80100739:	83 ec 18             	sub    $0x18,%esp
8010073c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010073f:	68 20 ef 10 80       	push   $0x8010ef20
80100744:	e8 76 36 00 00       	call   80103dbf <acquire>
  while((c = getc()) >= 0){
80100749:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010074c:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100751:	eb 13                	jmp    80100766 <consoleintr+0x33>
    switch(c){
80100753:	83 ff 08             	cmp    $0x8,%edi
80100756:	0f 84 d9 00 00 00    	je     80100835 <consoleintr+0x102>
8010075c:	83 ff 10             	cmp    $0x10,%edi
8010075f:	75 25                	jne    80100786 <consoleintr+0x53>
80100761:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100766:	ff d3                	call   *%ebx
80100768:	89 c7                	mov    %eax,%edi
8010076a:	85 c0                	test   %eax,%eax
8010076c:	0f 88 f5 00 00 00    	js     80100867 <consoleintr+0x134>
    switch(c){
80100772:	83 ff 15             	cmp    $0x15,%edi
80100775:	0f 84 93 00 00 00    	je     8010080e <consoleintr+0xdb>
8010077b:	7e d6                	jle    80100753 <consoleintr+0x20>
8010077d:	83 ff 7f             	cmp    $0x7f,%edi
80100780:	0f 84 af 00 00 00    	je     80100835 <consoleintr+0x102>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100786:	85 ff                	test   %edi,%edi
80100788:	74 dc                	je     80100766 <consoleintr+0x33>
8010078a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010078f:	89 c2                	mov    %eax,%edx
80100791:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100797:	83 fa 7f             	cmp    $0x7f,%edx
8010079a:	77 ca                	ja     80100766 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010079c:	83 ff 0d             	cmp    $0xd,%edi
8010079f:	0f 84 b8 00 00 00    	je     8010085d <consoleintr+0x12a>
        input.buf[input.e++ % INPUT_BUF] = c;
801007a5:	8d 50 01             	lea    0x1(%eax),%edx
801007a8:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801007ae:	83 e0 7f             	and    $0x7f,%eax
801007b1:	89 f9                	mov    %edi,%ecx
801007b3:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
801007b9:	89 f8                	mov    %edi,%eax
801007bb:	e8 1a fd ff ff       	call   801004da <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007c0:	83 ff 0a             	cmp    $0xa,%edi
801007c3:	0f 94 c0             	sete   %al
801007c6:	83 ff 04             	cmp    $0x4,%edi
801007c9:	0f 94 c2             	sete   %dl
801007cc:	08 d0                	or     %dl,%al
801007ce:	75 10                	jne    801007e0 <consoleintr+0xad>
801007d0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801007d5:	83 e8 80             	sub    $0xffffff80,%eax
801007d8:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007de:	75 86                	jne    80100766 <consoleintr+0x33>
          input.w = input.e;
801007e0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007e5:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801007ea:	83 ec 0c             	sub    $0xc,%esp
801007ed:	68 00 ef 10 80       	push   $0x8010ef00
801007f2:	e8 ea 2f 00 00       	call   801037e1 <wakeup>
801007f7:	83 c4 10             	add    $0x10,%esp
801007fa:	e9 67 ff ff ff       	jmp    80100766 <consoleintr+0x33>
        input.e--;
801007ff:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
80100804:	b8 00 01 00 00       	mov    $0x100,%eax
80100809:	e8 cc fc ff ff       	call   801004da <consputc>
      while(input.e != input.w &&
8010080e:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100813:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100819:	0f 84 47 ff ff ff    	je     80100766 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	83 e8 01             	sub    $0x1,%eax
80100822:	89 c2                	mov    %eax,%edx
80100824:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100827:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010082e:	75 cf                	jne    801007ff <consoleintr+0xcc>
80100830:	e9 31 ff ff ff       	jmp    80100766 <consoleintr+0x33>
      if(input.e != input.w){
80100835:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010083a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100840:	0f 84 20 ff ff ff    	je     80100766 <consoleintr+0x33>
        input.e--;
80100846:	83 e8 01             	sub    $0x1,%eax
80100849:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
8010084e:	b8 00 01 00 00       	mov    $0x100,%eax
80100853:	e8 82 fc ff ff       	call   801004da <consputc>
80100858:	e9 09 ff ff ff       	jmp    80100766 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010085d:	bf 0a 00 00 00       	mov    $0xa,%edi
80100862:	e9 3e ff ff ff       	jmp    801007a5 <consoleintr+0x72>
  release(&cons.lock);
80100867:	83 ec 0c             	sub    $0xc,%esp
8010086a:	68 20 ef 10 80       	push   $0x8010ef20
8010086f:	e8 b0 35 00 00       	call   80103e24 <release>
  if(doprocdump) {
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	85 f6                	test   %esi,%esi
80100879:	75 08                	jne    80100883 <consoleintr+0x150>
}
8010087b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087e:	5b                   	pop    %ebx
8010087f:	5e                   	pop    %esi
80100880:	5f                   	pop    %edi
80100881:	5d                   	pop    %ebp
80100882:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100883:	e8 f6 2f 00 00       	call   8010387e <procdump>
}
80100888:	eb f1                	jmp    8010087b <consoleintr+0x148>

8010088a <consoleinit>:

void
consoleinit(void)
{
8010088a:	55                   	push   %ebp
8010088b:	89 e5                	mov    %esp,%ebp
8010088d:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100890:	68 28 6a 10 80       	push   $0x80106a28
80100895:	68 20 ef 10 80       	push   $0x8010ef20
8010089a:	e8 e4 33 00 00       	call   80103c83 <initlock>

  devsw[CONSOLE].write = consolewrite;
8010089f:	c7 05 0c f9 10 80 a8 	movl   $0x801005a8,0x8010f90c
801008a6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008a9:	c7 05 08 f9 10 80 68 	movl   $0x80100268,0x8010f908
801008b0:	02 10 80 
  cons.locking = 1;
801008b3:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
801008ba:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008bd:	83 c4 08             	add    $0x8,%esp
801008c0:	6a 00                	push   $0x0
801008c2:	6a 01                	push   $0x1
801008c4:	e8 98 16 00 00       	call   80101f61 <ioapicenable>
}
801008c9:	83 c4 10             	add    $0x10,%esp
801008cc:	c9                   	leave  
801008cd:	c3                   	ret    

801008ce <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008ce:	55                   	push   %ebp
801008cf:	89 e5                	mov    %esp,%ebp
801008d1:	57                   	push   %edi
801008d2:	56                   	push   %esi
801008d3:	53                   	push   %ebx
801008d4:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008da:	e8 d6 28 00 00       	call   801031b5 <myproc>
801008df:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008e5:	e8 94 1e 00 00       	call   8010277e <begin_op>

  if((ip = namei(path)) == 0){
801008ea:	83 ec 0c             	sub    $0xc,%esp
801008ed:	ff 75 08             	push   0x8(%ebp)
801008f0:	e8 d8 12 00 00       	call   80101bcd <namei>
801008f5:	83 c4 10             	add    $0x10,%esp
801008f8:	85 c0                	test   %eax,%eax
801008fa:	74 56                	je     80100952 <exec+0x84>
801008fc:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008fe:	83 ec 0c             	sub    $0xc,%esp
80100901:	50                   	push   %eax
80100902:	e8 68 0c 00 00       	call   8010156f <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100907:	6a 34                	push   $0x34
80100909:	6a 00                	push   $0x0
8010090b:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100911:	50                   	push   %eax
80100912:	53                   	push   %ebx
80100913:	e8 49 0e 00 00       	call   80101761 <readi>
80100918:	83 c4 20             	add    $0x20,%esp
8010091b:	83 f8 34             	cmp    $0x34,%eax
8010091e:	75 0c                	jne    8010092c <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100920:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100927:	45 4c 46 
8010092a:	74 42                	je     8010096e <exec+0xa0>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010092c:	85 db                	test   %ebx,%ebx
8010092e:	0f 84 c5 02 00 00    	je     80100bf9 <exec+0x32b>
    iunlockput(ip);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	53                   	push   %ebx
80100938:	e8 d9 0d 00 00       	call   80101716 <iunlockput>
    end_op();
8010093d:	e8 b6 1e 00 00       	call   801027f8 <end_op>
80100942:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010094a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010094d:	5b                   	pop    %ebx
8010094e:	5e                   	pop    %esi
8010094f:	5f                   	pop    %edi
80100950:	5d                   	pop    %ebp
80100951:	c3                   	ret    
    end_op();
80100952:	e8 a1 1e 00 00       	call   801027f8 <end_op>
    cprintf("exec: fail\n");
80100957:	83 ec 0c             	sub    $0xc,%esp
8010095a:	68 41 6a 10 80       	push   $0x80106a41
8010095f:	e8 a3 fc ff ff       	call   80100607 <cprintf>
    return -1;
80100964:	83 c4 10             	add    $0x10,%esp
80100967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096c:	eb dc                	jmp    8010094a <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
8010096e:	e8 87 5d 00 00       	call   801066fa <setupkvm>
80100973:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100979:	85 c0                	test   %eax,%eax
8010097b:	0f 84 09 01 00 00    	je     80100a8a <exec+0x1bc>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100981:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100987:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010098c:	be 00 00 00 00       	mov    $0x0,%esi
80100991:	eb 0c                	jmp    8010099f <exec+0xd1>
80100993:	83 c6 01             	add    $0x1,%esi
80100996:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
8010099c:	83 c0 20             	add    $0x20,%eax
8010099f:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009a6:	39 f2                	cmp    %esi,%edx
801009a8:	0f 8e 98 00 00 00    	jle    80100a46 <exec+0x178>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009ae:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b4:	6a 20                	push   $0x20
801009b6:	50                   	push   %eax
801009b7:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009bd:	50                   	push   %eax
801009be:	53                   	push   %ebx
801009bf:	e8 9d 0d 00 00       	call   80101761 <readi>
801009c4:	83 c4 10             	add    $0x10,%esp
801009c7:	83 f8 20             	cmp    $0x20,%eax
801009ca:	0f 85 ba 00 00 00    	jne    80100a8a <exec+0x1bc>
    if(ph.type != ELF_PROG_LOAD)
801009d0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009d7:	75 ba                	jne    80100993 <exec+0xc5>
    if(ph.memsz < ph.filesz)
801009d9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009df:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009e5:	0f 82 9f 00 00 00    	jb     80100a8a <exec+0x1bc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009eb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009f1:	0f 82 93 00 00 00    	jb     80100a8a <exec+0x1bc>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009f7:	83 ec 04             	sub    $0x4,%esp
801009fa:	50                   	push   %eax
801009fb:	57                   	push   %edi
801009fc:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a02:	e8 99 5b 00 00       	call   801065a0 <allocuvm>
80100a07:	89 c7                	mov    %eax,%edi
80100a09:	83 c4 10             	add    $0x10,%esp
80100a0c:	85 c0                	test   %eax,%eax
80100a0e:	74 7a                	je     80100a8a <exec+0x1bc>
    if(ph.vaddr % PGSIZE != 0)
80100a10:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a16:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a1b:	75 6d                	jne    80100a8a <exec+0x1bc>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a1d:	83 ec 0c             	sub    $0xc,%esp
80100a20:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100a26:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100a2c:	53                   	push   %ebx
80100a2d:	50                   	push   %eax
80100a2e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a34:	e8 3a 5a 00 00       	call   80106473 <loaduvm>
80100a39:	83 c4 20             	add    $0x20,%esp
80100a3c:	85 c0                	test   %eax,%eax
80100a3e:	0f 89 4f ff ff ff    	jns    80100993 <exec+0xc5>
80100a44:	eb 44                	jmp    80100a8a <exec+0x1bc>
  iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 c7 0c 00 00       	call   80101716 <iunlockput>
  end_op();
80100a4f:	e8 a4 1d 00 00       	call   801027f8 <end_op>
  sz = PGROUNDUP(sz);
80100a54:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a5f:	83 c4 0c             	add    $0xc,%esp
80100a62:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a68:	52                   	push   %edx
80100a69:	50                   	push   %eax
80100a6a:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100a70:	57                   	push   %edi
80100a71:	e8 2a 5b 00 00       	call   801065a0 <allocuvm>
80100a76:	89 c6                	mov    %eax,%esi
80100a78:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a7e:	83 c4 10             	add    $0x10,%esp
80100a81:	85 c0                	test   %eax,%eax
80100a83:	75 24                	jne    80100aa9 <exec+0x1db>
  ip = 0;
80100a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a8a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 84 94 fe ff ff    	je     8010092c <exec+0x5e>
    freevm(pgdir);
80100a98:	83 ec 0c             	sub    $0xc,%esp
80100a9b:	50                   	push   %eax
80100a9c:	e8 e9 5b 00 00       	call   8010668a <freevm>
80100aa1:	83 c4 10             	add    $0x10,%esp
80100aa4:	e9 83 fe ff ff       	jmp    8010092c <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100aa9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100aaf:	83 ec 08             	sub    $0x8,%esp
80100ab2:	50                   	push   %eax
80100ab3:	57                   	push   %edi
80100ab4:	e8 c6 5c 00 00       	call   8010677f <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ab9:	83 c4 10             	add    $0x10,%esp
80100abc:	bf 00 00 00 00       	mov    $0x0,%edi
80100ac1:	eb 0a                	jmp    80100acd <exec+0x1ff>
    ustack[3+argc] = sp;
80100ac3:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100aca:	83 c7 01             	add    $0x1,%edi
80100acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad0:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100ad3:	8b 03                	mov    (%ebx),%eax
80100ad5:	85 c0                	test   %eax,%eax
80100ad7:	74 47                	je     80100b20 <exec+0x252>
    if(argc >= MAXARG)
80100ad9:	83 ff 1f             	cmp    $0x1f,%edi
80100adc:	0f 87 0d 01 00 00    	ja     80100bef <exec+0x321>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	50                   	push   %eax
80100ae6:	e8 29 35 00 00       	call   80104014 <strlen>
80100aeb:	29 c6                	sub    %eax,%esi
80100aed:	83 ee 01             	sub    $0x1,%esi
80100af0:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100af3:	83 c4 04             	add    $0x4,%esp
80100af6:	ff 33                	push   (%ebx)
80100af8:	e8 17 35 00 00       	call   80104014 <strlen>
80100afd:	83 c0 01             	add    $0x1,%eax
80100b00:	50                   	push   %eax
80100b01:	ff 33                	push   (%ebx)
80100b03:	56                   	push   %esi
80100b04:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b0a:	e8 be 5d 00 00       	call   801068cd <copyout>
80100b0f:	83 c4 20             	add    $0x20,%esp
80100b12:	85 c0                	test   %eax,%eax
80100b14:	79 ad                	jns    80100ac3 <exec+0x1f5>
  ip = 0;
80100b16:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b1b:	e9 6a ff ff ff       	jmp    80100a8a <exec+0x1bc>
  ustack[3+argc] = 0;
80100b20:	89 f1                	mov    %esi,%ecx
80100b22:	89 c3                	mov    %eax,%ebx
80100b24:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b2b:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b2f:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b36:	ff ff ff 
  ustack[1] = argc;
80100b39:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b3f:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b46:	89 f0                	mov    %esi,%eax
80100b48:	29 d0                	sub    %edx,%eax
80100b4a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b50:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b57:	29 c1                	sub    %eax,%ecx
80100b59:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b5b:	50                   	push   %eax
80100b5c:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b62:	50                   	push   %eax
80100b63:	51                   	push   %ecx
80100b64:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b6a:	e8 5e 5d 00 00       	call   801068cd <copyout>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	85 c0                	test   %eax,%eax
80100b74:	0f 88 10 ff ff ff    	js     80100a8a <exec+0x1bc>
  for(last=s=path; *s; s++)
80100b7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100b7d:	89 d0                	mov    %edx,%eax
80100b7f:	eb 03                	jmp    80100b84 <exec+0x2b6>
80100b81:	83 c0 01             	add    $0x1,%eax
80100b84:	0f b6 08             	movzbl (%eax),%ecx
80100b87:	84 c9                	test   %cl,%cl
80100b89:	74 0a                	je     80100b95 <exec+0x2c7>
    if(*s == '/')
80100b8b:	80 f9 2f             	cmp    $0x2f,%cl
80100b8e:	75 f1                	jne    80100b81 <exec+0x2b3>
      last = s+1;
80100b90:	8d 50 01             	lea    0x1(%eax),%edx
80100b93:	eb ec                	jmp    80100b81 <exec+0x2b3>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b95:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b9b:	89 f8                	mov    %edi,%eax
80100b9d:	83 c0 6c             	add    $0x6c,%eax
80100ba0:	83 ec 04             	sub    $0x4,%esp
80100ba3:	6a 10                	push   $0x10
80100ba5:	52                   	push   %edx
80100ba6:	50                   	push   %eax
80100ba7:	e8 2b 34 00 00       	call   80103fd7 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bac:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100baf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bb5:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bb8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bbe:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bc0:	8b 47 18             	mov    0x18(%edi),%eax
80100bc3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bc9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bcc:	8b 47 18             	mov    0x18(%edi),%eax
80100bcf:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bd2:	89 3c 24             	mov    %edi,(%esp)
80100bd5:	e8 d0 56 00 00       	call   801062aa <switchuvm>
  freevm(oldpgdir);
80100bda:	89 1c 24             	mov    %ebx,(%esp)
80100bdd:	e8 a8 5a 00 00       	call   8010668a <freevm>
  return 0;
80100be2:	83 c4 10             	add    $0x10,%esp
80100be5:	b8 00 00 00 00       	mov    $0x0,%eax
80100bea:	e9 5b fd ff ff       	jmp    8010094a <exec+0x7c>
  ip = 0;
80100bef:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bf4:	e9 91 fe ff ff       	jmp    80100a8a <exec+0x1bc>
  return -1;
80100bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfe:	e9 47 fd ff ff       	jmp    8010094a <exec+0x7c>

80100c03 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c03:	55                   	push   %ebp
80100c04:	89 e5                	mov    %esp,%ebp
80100c06:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c09:	68 4d 6a 10 80       	push   $0x80106a4d
80100c0e:	68 60 ef 10 80       	push   $0x8010ef60
80100c13:	e8 6b 30 00 00       	call   80103c83 <initlock>
}
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	c9                   	leave  
80100c1c:	c3                   	ret    

80100c1d <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c1d:	55                   	push   %ebp
80100c1e:	89 e5                	mov    %esp,%ebp
80100c20:	53                   	push   %ebx
80100c21:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c24:	68 60 ef 10 80       	push   $0x8010ef60
80100c29:	e8 91 31 00 00       	call   80103dbf <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100c36:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c3c:	73 29                	jae    80100c67 <filealloc+0x4a>
    if(f->ref == 0){
80100c3e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c42:	74 05                	je     80100c49 <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c44:	83 c3 18             	add    $0x18,%ebx
80100c47:	eb ed                	jmp    80100c36 <filealloc+0x19>
      f->ref = 1;
80100c49:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c50:	83 ec 0c             	sub    $0xc,%esp
80100c53:	68 60 ef 10 80       	push   $0x8010ef60
80100c58:	e8 c7 31 00 00       	call   80103e24 <release>
      return f;
80100c5d:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c60:	89 d8                	mov    %ebx,%eax
80100c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c65:	c9                   	leave  
80100c66:	c3                   	ret    
  release(&ftable.lock);
80100c67:	83 ec 0c             	sub    $0xc,%esp
80100c6a:	68 60 ef 10 80       	push   $0x8010ef60
80100c6f:	e8 b0 31 00 00       	call   80103e24 <release>
  return 0;
80100c74:	83 c4 10             	add    $0x10,%esp
80100c77:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c7c:	eb e2                	jmp    80100c60 <filealloc+0x43>

80100c7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c7e:	55                   	push   %ebp
80100c7f:	89 e5                	mov    %esp,%ebp
80100c81:	53                   	push   %ebx
80100c82:	83 ec 10             	sub    $0x10,%esp
80100c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c88:	68 60 ef 10 80       	push   $0x8010ef60
80100c8d:	e8 2d 31 00 00       	call   80103dbf <acquire>
  if(f->ref < 1)
80100c92:	8b 43 04             	mov    0x4(%ebx),%eax
80100c95:	83 c4 10             	add    $0x10,%esp
80100c98:	85 c0                	test   %eax,%eax
80100c9a:	7e 1a                	jle    80100cb6 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100c9c:	83 c0 01             	add    $0x1,%eax
80100c9f:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ca2:	83 ec 0c             	sub    $0xc,%esp
80100ca5:	68 60 ef 10 80       	push   $0x8010ef60
80100caa:	e8 75 31 00 00       	call   80103e24 <release>
  return f;
}
80100caf:	89 d8                	mov    %ebx,%eax
80100cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb4:	c9                   	leave  
80100cb5:	c3                   	ret    
    panic("filedup");
80100cb6:	83 ec 0c             	sub    $0xc,%esp
80100cb9:	68 54 6a 10 80       	push   $0x80106a54
80100cbe:	e8 85 f6 ff ff       	call   80100348 <panic>

80100cc3 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100cc3:	55                   	push   %ebp
80100cc4:	89 e5                	mov    %esp,%ebp
80100cc6:	53                   	push   %ebx
80100cc7:	83 ec 30             	sub    $0x30,%esp
80100cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ccd:	68 60 ef 10 80       	push   $0x8010ef60
80100cd2:	e8 e8 30 00 00       	call   80103dbf <acquire>
  if(f->ref < 1)
80100cd7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cda:	83 c4 10             	add    $0x10,%esp
80100cdd:	85 c0                	test   %eax,%eax
80100cdf:	7e 71                	jle    80100d52 <fileclose+0x8f>
    panic("fileclose");
  if(--f->ref > 0){
80100ce1:	83 e8 01             	sub    $0x1,%eax
80100ce4:	89 43 04             	mov    %eax,0x4(%ebx)
80100ce7:	85 c0                	test   %eax,%eax
80100ce9:	7f 74                	jg     80100d5f <fileclose+0x9c>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ceb:	8b 03                	mov    (%ebx),%eax
80100ced:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf0:	8b 43 04             	mov    0x4(%ebx),%eax
80100cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cf6:	8b 43 08             	mov    0x8(%ebx),%eax
80100cf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cfc:	8b 43 0c             	mov    0xc(%ebx),%eax
80100cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d02:	8b 43 10             	mov    0x10(%ebx),%eax
80100d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100d08:	8b 43 14             	mov    0x14(%ebx),%eax
80100d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80100d0e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d1b:	83 ec 0c             	sub    $0xc,%esp
80100d1e:	68 60 ef 10 80       	push   $0x8010ef60
80100d23:	e8 fc 30 00 00       	call   80103e24 <release>

  if(ff.type == FD_PIPE)
80100d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2b:	83 c4 10             	add    $0x10,%esp
80100d2e:	83 f8 01             	cmp    $0x1,%eax
80100d31:	74 41                	je     80100d74 <fileclose+0xb1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d33:	83 f8 02             	cmp    $0x2,%eax
80100d36:	75 37                	jne    80100d6f <fileclose+0xac>
    begin_op();
80100d38:	e8 41 1a 00 00       	call   8010277e <begin_op>
    iput(ff.ip);
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	ff 75 f0             	push   -0x10(%ebp)
80100d43:	e8 2e 09 00 00       	call   80101676 <iput>
    end_op();
80100d48:	e8 ab 1a 00 00       	call   801027f8 <end_op>
80100d4d:	83 c4 10             	add    $0x10,%esp
80100d50:	eb 1d                	jmp    80100d6f <fileclose+0xac>
    panic("fileclose");
80100d52:	83 ec 0c             	sub    $0xc,%esp
80100d55:	68 5c 6a 10 80       	push   $0x80106a5c
80100d5a:	e8 e9 f5 ff ff       	call   80100348 <panic>
    release(&ftable.lock);
80100d5f:	83 ec 0c             	sub    $0xc,%esp
80100d62:	68 60 ef 10 80       	push   $0x8010ef60
80100d67:	e8 b8 30 00 00       	call   80103e24 <release>
    return;
80100d6c:	83 c4 10             	add    $0x10,%esp
  }
}
80100d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d72:	c9                   	leave  
80100d73:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d74:	83 ec 08             	sub    $0x8,%esp
80100d77:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100d7b:	50                   	push   %eax
80100d7c:	ff 75 ec             	push   -0x14(%ebp)
80100d7f:	e8 6d 20 00 00       	call   80102df1 <pipeclose>
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	eb e6                	jmp    80100d6f <fileclose+0xac>

80100d89 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d89:	55                   	push   %ebp
80100d8a:	89 e5                	mov    %esp,%ebp
80100d8c:	53                   	push   %ebx
80100d8d:	83 ec 04             	sub    $0x4,%esp
80100d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d93:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d96:	75 31                	jne    80100dc9 <filestat+0x40>
    ilock(f->ip);
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	ff 73 10             	push   0x10(%ebx)
80100d9e:	e8 cc 07 00 00       	call   8010156f <ilock>
    stati(f->ip, st);
80100da3:	83 c4 08             	add    $0x8,%esp
80100da6:	ff 75 0c             	push   0xc(%ebp)
80100da9:	ff 73 10             	push   0x10(%ebx)
80100dac:	e8 85 09 00 00       	call   80101736 <stati>
    iunlock(f->ip);
80100db1:	83 c4 04             	add    $0x4,%esp
80100db4:	ff 73 10             	push   0x10(%ebx)
80100db7:	e8 75 08 00 00       	call   80101631 <iunlock>
    return 0;
80100dbc:	83 c4 10             	add    $0x10,%esp
80100dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc7:	c9                   	leave  
80100dc8:	c3                   	ret    
  return -1;
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	eb f4                	jmp    80100dc4 <filestat+0x3b>

80100dd0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	56                   	push   %esi
80100dd4:	53                   	push   %ebx
80100dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dd8:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ddc:	74 70                	je     80100e4e <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100dde:	8b 03                	mov    (%ebx),%eax
80100de0:	83 f8 01             	cmp    $0x1,%eax
80100de3:	74 44                	je     80100e29 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100de5:	83 f8 02             	cmp    $0x2,%eax
80100de8:	75 57                	jne    80100e41 <fileread+0x71>
    ilock(f->ip);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff 73 10             	push   0x10(%ebx)
80100df0:	e8 7a 07 00 00       	call   8010156f <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100df5:	ff 75 10             	push   0x10(%ebp)
80100df8:	ff 73 14             	push   0x14(%ebx)
80100dfb:	ff 75 0c             	push   0xc(%ebp)
80100dfe:	ff 73 10             	push   0x10(%ebx)
80100e01:	e8 5b 09 00 00       	call   80101761 <readi>
80100e06:	89 c6                	mov    %eax,%esi
80100e08:	83 c4 20             	add    $0x20,%esp
80100e0b:	85 c0                	test   %eax,%eax
80100e0d:	7e 03                	jle    80100e12 <fileread+0x42>
      f->off += r;
80100e0f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e12:	83 ec 0c             	sub    $0xc,%esp
80100e15:	ff 73 10             	push   0x10(%ebx)
80100e18:	e8 14 08 00 00       	call   80101631 <iunlock>
    return r;
80100e1d:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e20:	89 f0                	mov    %esi,%eax
80100e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e25:	5b                   	pop    %ebx
80100e26:	5e                   	pop    %esi
80100e27:	5d                   	pop    %ebp
80100e28:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e29:	83 ec 04             	sub    $0x4,%esp
80100e2c:	ff 75 10             	push   0x10(%ebp)
80100e2f:	ff 75 0c             	push   0xc(%ebp)
80100e32:	ff 73 0c             	push   0xc(%ebx)
80100e35:	e8 08 21 00 00       	call   80102f42 <piperead>
80100e3a:	89 c6                	mov    %eax,%esi
80100e3c:	83 c4 10             	add    $0x10,%esp
80100e3f:	eb df                	jmp    80100e20 <fileread+0x50>
  panic("fileread");
80100e41:	83 ec 0c             	sub    $0xc,%esp
80100e44:	68 66 6a 10 80       	push   $0x80106a66
80100e49:	e8 fa f4 ff ff       	call   80100348 <panic>
    return -1;
80100e4e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e53:	eb cb                	jmp    80100e20 <fileread+0x50>

80100e55 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e55:	55                   	push   %ebp
80100e56:	89 e5                	mov    %esp,%ebp
80100e58:	57                   	push   %edi
80100e59:	56                   	push   %esi
80100e5a:	53                   	push   %ebx
80100e5b:	83 ec 1c             	sub    $0x1c,%esp
80100e5e:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e61:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e65:	0f 84 d0 00 00 00    	je     80100f3b <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e6b:	8b 06                	mov    (%esi),%eax
80100e6d:	83 f8 01             	cmp    $0x1,%eax
80100e70:	74 12                	je     80100e84 <filewrite+0x2f>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e72:	83 f8 02             	cmp    $0x2,%eax
80100e75:	0f 85 b3 00 00 00    	jne    80100f2e <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e7b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e82:	eb 66                	jmp    80100eea <filewrite+0x95>
    return pipewrite(f->pipe, addr, n);
80100e84:	83 ec 04             	sub    $0x4,%esp
80100e87:	ff 75 10             	push   0x10(%ebp)
80100e8a:	ff 75 0c             	push   0xc(%ebp)
80100e8d:	ff 76 0c             	push   0xc(%esi)
80100e90:	e8 e8 1f 00 00       	call   80102e7d <pipewrite>
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	e9 84 00 00 00       	jmp    80100f21 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100e9d:	e8 dc 18 00 00       	call   8010277e <begin_op>
      ilock(f->ip);
80100ea2:	83 ec 0c             	sub    $0xc,%esp
80100ea5:	ff 76 10             	push   0x10(%esi)
80100ea8:	e8 c2 06 00 00       	call   8010156f <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ead:	57                   	push   %edi
80100eae:	ff 76 14             	push   0x14(%esi)
80100eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb4:	03 45 0c             	add    0xc(%ebp),%eax
80100eb7:	50                   	push   %eax
80100eb8:	ff 76 10             	push   0x10(%esi)
80100ebb:	e8 9e 09 00 00       	call   8010185e <writei>
80100ec0:	89 c3                	mov    %eax,%ebx
80100ec2:	83 c4 20             	add    $0x20,%esp
80100ec5:	85 c0                	test   %eax,%eax
80100ec7:	7e 03                	jle    80100ecc <filewrite+0x77>
        f->off += r;
80100ec9:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ecc:	83 ec 0c             	sub    $0xc,%esp
80100ecf:	ff 76 10             	push   0x10(%esi)
80100ed2:	e8 5a 07 00 00       	call   80101631 <iunlock>
      end_op();
80100ed7:	e8 1c 19 00 00       	call   801027f8 <end_op>

      if(r < 0)
80100edc:	83 c4 10             	add    $0x10,%esp
80100edf:	85 db                	test   %ebx,%ebx
80100ee1:	78 31                	js     80100f14 <filewrite+0xbf>
        break;
      if(r != n1)
80100ee3:	39 df                	cmp    %ebx,%edi
80100ee5:	75 20                	jne    80100f07 <filewrite+0xb2>
        panic("short filewrite");
      i += r;
80100ee7:	01 5d e4             	add    %ebx,-0x1c(%ebp)
    while(i < n){
80100eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eed:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ef0:	7d 22                	jge    80100f14 <filewrite+0xbf>
      int n1 = n - i;
80100ef2:	8b 7d 10             	mov    0x10(%ebp),%edi
80100ef5:	2b 7d e4             	sub    -0x1c(%ebp),%edi
      if(n1 > max)
80100ef8:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80100efe:	7e 9d                	jle    80100e9d <filewrite+0x48>
        n1 = max;
80100f00:	bf 00 06 00 00       	mov    $0x600,%edi
80100f05:	eb 96                	jmp    80100e9d <filewrite+0x48>
        panic("short filewrite");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 6f 6a 10 80       	push   $0x80106a6f
80100f0f:	e8 34 f4 ff ff       	call   80100348 <panic>
    }
    return i == n ? n : -1;
80100f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f17:	3b 45 10             	cmp    0x10(%ebp),%eax
80100f1a:	74 0d                	je     80100f29 <filewrite+0xd4>
80100f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f24:	5b                   	pop    %ebx
80100f25:	5e                   	pop    %esi
80100f26:	5f                   	pop    %edi
80100f27:	5d                   	pop    %ebp
80100f28:	c3                   	ret    
    return i == n ? n : -1;
80100f29:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2c:	eb f3                	jmp    80100f21 <filewrite+0xcc>
  panic("filewrite");
80100f2e:	83 ec 0c             	sub    $0xc,%esp
80100f31:	68 75 6a 10 80       	push   $0x80106a75
80100f36:	e8 0d f4 ff ff       	call   80100348 <panic>
    return -1;
80100f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f40:	eb df                	jmp    80100f21 <filewrite+0xcc>

80100f42 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f42:	55                   	push   %ebp
80100f43:	89 e5                	mov    %esp,%ebp
80100f45:	57                   	push   %edi
80100f46:	56                   	push   %esi
80100f47:	53                   	push   %ebx
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f4d:	eb 03                	jmp    80100f52 <skipelem+0x10>
    path++;
80100f4f:	83 c0 01             	add    $0x1,%eax
  while(*path == '/')
80100f52:	0f b6 10             	movzbl (%eax),%edx
80100f55:	80 fa 2f             	cmp    $0x2f,%dl
80100f58:	74 f5                	je     80100f4f <skipelem+0xd>
  if(*path == 0)
80100f5a:	84 d2                	test   %dl,%dl
80100f5c:	74 53                	je     80100fb1 <skipelem+0x6f>
80100f5e:	89 c3                	mov    %eax,%ebx
80100f60:	eb 03                	jmp    80100f65 <skipelem+0x23>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f62:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80100f65:	0f b6 13             	movzbl (%ebx),%edx
80100f68:	80 fa 2f             	cmp    $0x2f,%dl
80100f6b:	74 04                	je     80100f71 <skipelem+0x2f>
80100f6d:	84 d2                	test   %dl,%dl
80100f6f:	75 f1                	jne    80100f62 <skipelem+0x20>
  len = path - s;
80100f71:	89 df                	mov    %ebx,%edi
80100f73:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f75:	83 ff 0d             	cmp    $0xd,%edi
80100f78:	7e 11                	jle    80100f8b <skipelem+0x49>
    memmove(name, s, DIRSIZ);
80100f7a:	83 ec 04             	sub    $0x4,%esp
80100f7d:	6a 0e                	push   $0xe
80100f7f:	50                   	push   %eax
80100f80:	56                   	push   %esi
80100f81:	e8 5d 2f 00 00       	call   80103ee3 <memmove>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb 17                	jmp    80100fa2 <skipelem+0x60>
  else {
    memmove(name, s, len);
80100f8b:	83 ec 04             	sub    $0x4,%esp
80100f8e:	57                   	push   %edi
80100f8f:	50                   	push   %eax
80100f90:	56                   	push   %esi
80100f91:	e8 4d 2f 00 00       	call   80103ee3 <memmove>
    name[len] = 0;
80100f96:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f9a:	83 c4 10             	add    $0x10,%esp
80100f9d:	eb 03                	jmp    80100fa2 <skipelem+0x60>
  }
  while(*path == '/')
    path++;
80100f9f:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fa2:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fa5:	74 f8                	je     80100f9f <skipelem+0x5d>
  return path;
}
80100fa7:	89 d8                	mov    %ebx,%eax
80100fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fac:	5b                   	pop    %ebx
80100fad:	5e                   	pop    %esi
80100fae:	5f                   	pop    %edi
80100faf:	5d                   	pop    %ebp
80100fb0:	c3                   	ret    
    return 0;
80100fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fb6:	eb ef                	jmp    80100fa7 <skipelem+0x65>

80100fb8 <bzero>:
{
80100fb8:	55                   	push   %ebp
80100fb9:	89 e5                	mov    %esp,%ebp
80100fbb:	53                   	push   %ebx
80100fbc:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fbf:	52                   	push   %edx
80100fc0:	50                   	push   %eax
80100fc1:	e8 a6 f1 ff ff       	call   8010016c <bread>
80100fc6:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fc8:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fcb:	83 c4 0c             	add    $0xc,%esp
80100fce:	68 00 02 00 00       	push   $0x200
80100fd3:	6a 00                	push   $0x0
80100fd5:	50                   	push   %eax
80100fd6:	e8 90 2e 00 00       	call   80103e6b <memset>
  log_write(bp);
80100fdb:	89 1c 24             	mov    %ebx,(%esp)
80100fde:	e8 c4 18 00 00       	call   801028a7 <log_write>
  brelse(bp);
80100fe3:	89 1c 24             	mov    %ebx,(%esp)
80100fe6:	e8 ea f1 ff ff       	call   801001d5 <brelse>
}
80100feb:	83 c4 10             	add    $0x10,%esp
80100fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff1:	c9                   	leave  
80100ff2:	c3                   	ret    

80100ff3 <bfree>:
{
80100ff3:	55                   	push   %ebp
80100ff4:	89 e5                	mov    %esp,%ebp
80100ff6:	56                   	push   %esi
80100ff7:	53                   	push   %ebx
80100ff8:	89 c3                	mov    %eax,%ebx
80100ffa:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80100ffc:	89 d0                	mov    %edx,%eax
80100ffe:	c1 e8 0c             	shr    $0xc,%eax
80101001:	83 ec 08             	sub    $0x8,%esp
80101004:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010100a:	50                   	push   %eax
8010100b:	53                   	push   %ebx
8010100c:	e8 5b f1 ff ff       	call   8010016c <bread>
80101011:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101013:	89 f2                	mov    %esi,%edx
80101015:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
8010101b:	89 f1                	mov    %esi,%ecx
8010101d:	83 e1 07             	and    $0x7,%ecx
80101020:	b8 01 00 00 00       	mov    $0x1,%eax
80101025:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	c1 fa 03             	sar    $0x3,%edx
8010102d:	0f b6 4c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ecx
80101032:	0f b6 f1             	movzbl %cl,%esi
80101035:	85 c6                	test   %eax,%esi
80101037:	74 23                	je     8010105c <bfree+0x69>
  bp->data[bi/8] &= ~m;
80101039:	f7 d0                	not    %eax
8010103b:	21 c8                	and    %ecx,%eax
8010103d:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
80101041:	83 ec 0c             	sub    $0xc,%esp
80101044:	53                   	push   %ebx
80101045:	e8 5d 18 00 00       	call   801028a7 <log_write>
  brelse(bp);
8010104a:	89 1c 24             	mov    %ebx,(%esp)
8010104d:	e8 83 f1 ff ff       	call   801001d5 <brelse>
}
80101052:	83 c4 10             	add    $0x10,%esp
80101055:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101058:	5b                   	pop    %ebx
80101059:	5e                   	pop    %esi
8010105a:	5d                   	pop    %ebp
8010105b:	c3                   	ret    
    panic("freeing free block");
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	68 7f 6a 10 80       	push   $0x80106a7f
80101064:	e8 df f2 ff ff       	call   80100348 <panic>

80101069 <balloc>:
{
80101069:	55                   	push   %ebp
8010106a:	89 e5                	mov    %esp,%ebp
8010106c:	57                   	push   %edi
8010106d:	56                   	push   %esi
8010106e:	53                   	push   %ebx
8010106f:	83 ec 1c             	sub    $0x1c,%esp
80101072:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101075:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010107c:	eb 15                	jmp    80101093 <balloc+0x2a>
    brelse(bp);
8010107e:	83 ec 0c             	sub    $0xc,%esp
80101081:	ff 75 e0             	push   -0x20(%ebp)
80101084:	e8 4c f1 ff ff       	call   801001d5 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101089:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
80101090:	83 c4 10             	add    $0x10,%esp
80101093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101096:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010109c:	76 75                	jbe    80101113 <balloc+0xaa>
    bp = bread(dev, BBLOCK(b, sb));
8010109e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010a1:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
801010a7:	85 db                	test   %ebx,%ebx
801010a9:	0f 49 c3             	cmovns %ebx,%eax
801010ac:	c1 f8 0c             	sar    $0xc,%eax
801010af:	83 ec 08             	sub    $0x8,%esp
801010b2:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801010b8:	50                   	push   %eax
801010b9:	ff 75 d8             	push   -0x28(%ebp)
801010bc:	e8 ab f0 ff ff       	call   8010016c <bread>
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010c4:	83 c4 10             	add    $0x10,%esp
801010c7:	b8 00 00 00 00       	mov    $0x0,%eax
801010cc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801010d1:	7f ab                	jg     8010107e <balloc+0x15>
801010d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010d6:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
801010d9:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
801010df:	73 9d                	jae    8010107e <balloc+0x15>
      m = 1 << (bi % 8);
801010e1:	89 c1                	mov    %eax,%ecx
801010e3:	83 e1 07             	and    $0x7,%ecx
801010e6:	ba 01 00 00 00       	mov    $0x1,%edx
801010eb:	d3 e2                	shl    %cl,%edx
801010ed:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010ef:	8d 50 07             	lea    0x7(%eax),%edx
801010f2:	85 c0                	test   %eax,%eax
801010f4:	0f 49 d0             	cmovns %eax,%edx
801010f7:	c1 fa 03             	sar    $0x3,%edx
801010fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
801010fd:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101100:	0f b6 74 16 5c       	movzbl 0x5c(%esi,%edx,1),%esi
80101105:	89 f2                	mov    %esi,%edx
80101107:	0f b6 fa             	movzbl %dl,%edi
8010110a:	85 cf                	test   %ecx,%edi
8010110c:	74 12                	je     80101120 <balloc+0xb7>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010110e:	83 c0 01             	add    $0x1,%eax
80101111:	eb b9                	jmp    801010cc <balloc+0x63>
  panic("balloc: out of blocks");
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	68 92 6a 10 80       	push   $0x80106a92
8010111b:	e8 28 f2 ff ff       	call   80100348 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101120:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101123:	09 f1                	or     %esi,%ecx
80101125:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101128:	88 4c 17 5c          	mov    %cl,0x5c(%edi,%edx,1)
        log_write(bp);
8010112c:	83 ec 0c             	sub    $0xc,%esp
8010112f:	57                   	push   %edi
80101130:	e8 72 17 00 00       	call   801028a7 <log_write>
        brelse(bp);
80101135:	89 3c 24             	mov    %edi,(%esp)
80101138:	e8 98 f0 ff ff       	call   801001d5 <brelse>
        bzero(dev, b + bi);
8010113d:	89 da                	mov    %ebx,%edx
8010113f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101142:	e8 71 fe ff ff       	call   80100fb8 <bzero>
}
80101147:	89 d8                	mov    %ebx,%eax
80101149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010114c:	5b                   	pop    %ebx
8010114d:	5e                   	pop    %esi
8010114e:	5f                   	pop    %edi
8010114f:	5d                   	pop    %ebp
80101150:	c3                   	ret    

80101151 <bmap>:
{
80101151:	55                   	push   %ebp
80101152:	89 e5                	mov    %esp,%ebp
80101154:	57                   	push   %edi
80101155:	56                   	push   %esi
80101156:	53                   	push   %ebx
80101157:	83 ec 1c             	sub    $0x1c,%esp
8010115a:	89 c3                	mov    %eax,%ebx
8010115c:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
8010115e:	83 fa 0b             	cmp    $0xb,%edx
80101161:	76 45                	jbe    801011a8 <bmap+0x57>
  bn -= NDIRECT;
80101163:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101166:	83 fe 7f             	cmp    $0x7f,%esi
80101169:	77 7f                	ja     801011ea <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010116b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	74 4a                	je     801011bf <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101175:	83 ec 08             	sub    $0x8,%esp
80101178:	50                   	push   %eax
80101179:	ff 33                	push   (%ebx)
8010117b:	e8 ec ef ff ff       	call   8010016c <bread>
80101180:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101182:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101189:	8b 30                	mov    (%eax),%esi
8010118b:	83 c4 10             	add    $0x10,%esp
8010118e:	85 f6                	test   %esi,%esi
80101190:	74 3c                	je     801011ce <bmap+0x7d>
    brelse(bp);
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	57                   	push   %edi
80101196:	e8 3a f0 ff ff       	call   801001d5 <brelse>
    return addr;
8010119b:	83 c4 10             	add    $0x10,%esp
}
8010119e:	89 f0                	mov    %esi,%eax
801011a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a3:	5b                   	pop    %ebx
801011a4:	5e                   	pop    %esi
801011a5:	5f                   	pop    %edi
801011a6:	5d                   	pop    %ebp
801011a7:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011a8:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011ac:	85 f6                	test   %esi,%esi
801011ae:	75 ee                	jne    8010119e <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011b0:	8b 00                	mov    (%eax),%eax
801011b2:	e8 b2 fe ff ff       	call   80101069 <balloc>
801011b7:	89 c6                	mov    %eax,%esi
801011b9:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
801011bd:	eb df                	jmp    8010119e <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011bf:	8b 03                	mov    (%ebx),%eax
801011c1:	e8 a3 fe ff ff       	call   80101069 <balloc>
801011c6:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801011cc:	eb a7                	jmp    80101175 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801011ce:	8b 03                	mov    (%ebx),%eax
801011d0:	e8 94 fe ff ff       	call   80101069 <balloc>
801011d5:	89 c6                	mov    %eax,%esi
801011d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011da:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801011dc:	83 ec 0c             	sub    $0xc,%esp
801011df:	57                   	push   %edi
801011e0:	e8 c2 16 00 00       	call   801028a7 <log_write>
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	eb a8                	jmp    80101192 <bmap+0x41>
  panic("bmap: out of range");
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	68 a8 6a 10 80       	push   $0x80106aa8
801011f2:	e8 51 f1 ff ff       	call   80100348 <panic>

801011f7 <iget>:
{
801011f7:	55                   	push   %ebp
801011f8:	89 e5                	mov    %esp,%ebp
801011fa:	57                   	push   %edi
801011fb:	56                   	push   %esi
801011fc:	53                   	push   %ebx
801011fd:	83 ec 28             	sub    $0x28,%esp
80101200:	89 c7                	mov    %eax,%edi
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101205:	68 60 f9 10 80       	push   $0x8010f960
8010120a:	e8 b0 2b 00 00       	call   80103dbf <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120f:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101212:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101217:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
8010121c:	eb 0a                	jmp    80101228 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010121e:	85 f6                	test   %esi,%esi
80101220:	74 3b                	je     8010125d <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101222:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101228:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010122e:	73 35                	jae    80101265 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101230:	8b 43 08             	mov    0x8(%ebx),%eax
80101233:	85 c0                	test   %eax,%eax
80101235:	7e e7                	jle    8010121e <iget+0x27>
80101237:	39 3b                	cmp    %edi,(%ebx)
80101239:	75 e3                	jne    8010121e <iget+0x27>
8010123b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010123e:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101241:	75 db                	jne    8010121e <iget+0x27>
      ip->ref++;
80101243:	83 c0 01             	add    $0x1,%eax
80101246:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101249:	83 ec 0c             	sub    $0xc,%esp
8010124c:	68 60 f9 10 80       	push   $0x8010f960
80101251:	e8 ce 2b 00 00       	call   80103e24 <release>
      return ip;
80101256:	83 c4 10             	add    $0x10,%esp
80101259:	89 de                	mov    %ebx,%esi
8010125b:	eb 32                	jmp    8010128f <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010125d:	85 c0                	test   %eax,%eax
8010125f:	75 c1                	jne    80101222 <iget+0x2b>
      empty = ip;
80101261:	89 de                	mov    %ebx,%esi
80101263:	eb bd                	jmp    80101222 <iget+0x2b>
  if(empty == 0)
80101265:	85 f6                	test   %esi,%esi
80101267:	74 30                	je     80101299 <iget+0xa2>
  ip->dev = dev;
80101269:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010126b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010126e:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101271:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101278:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	68 60 f9 10 80       	push   $0x8010f960
80101287:	e8 98 2b 00 00       	call   80103e24 <release>
  return ip;
8010128c:	83 c4 10             	add    $0x10,%esp
}
8010128f:	89 f0                	mov    %esi,%eax
80101291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101294:	5b                   	pop    %ebx
80101295:	5e                   	pop    %esi
80101296:	5f                   	pop    %edi
80101297:	5d                   	pop    %ebp
80101298:	c3                   	ret    
    panic("iget: no inodes");
80101299:	83 ec 0c             	sub    $0xc,%esp
8010129c:	68 bb 6a 10 80       	push   $0x80106abb
801012a1:	e8 a2 f0 ff ff       	call   80100348 <panic>

801012a6 <readsb>:
{
801012a6:	55                   	push   %ebp
801012a7:	89 e5                	mov    %esp,%ebp
801012a9:	53                   	push   %ebx
801012aa:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012ad:	6a 01                	push   $0x1
801012af:	ff 75 08             	push   0x8(%ebp)
801012b2:	e8 b5 ee ff ff       	call   8010016c <bread>
801012b7:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012b9:	8d 40 5c             	lea    0x5c(%eax),%eax
801012bc:	83 c4 0c             	add    $0xc,%esp
801012bf:	6a 1c                	push   $0x1c
801012c1:	50                   	push   %eax
801012c2:	ff 75 0c             	push   0xc(%ebp)
801012c5:	e8 19 2c 00 00       	call   80103ee3 <memmove>
  brelse(bp);
801012ca:	89 1c 24             	mov    %ebx,(%esp)
801012cd:	e8 03 ef ff ff       	call   801001d5 <brelse>
}
801012d2:	83 c4 10             	add    $0x10,%esp
801012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012d8:	c9                   	leave  
801012d9:	c3                   	ret    

801012da <iinit>:
{
801012da:	55                   	push   %ebp
801012db:	89 e5                	mov    %esp,%ebp
801012dd:	53                   	push   %ebx
801012de:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012e1:	68 cb 6a 10 80       	push   $0x80106acb
801012e6:	68 60 f9 10 80       	push   $0x8010f960
801012eb:	e8 93 29 00 00       	call   80103c83 <initlock>
  for(i = 0; i < NINODE; i++) {
801012f0:	83 c4 10             	add    $0x10,%esp
801012f3:	bb 00 00 00 00       	mov    $0x0,%ebx
801012f8:	eb 21                	jmp    8010131b <iinit+0x41>
    initsleeplock(&icache.inode[i].lock, "inode");
801012fa:	83 ec 08             	sub    $0x8,%esp
801012fd:	68 d2 6a 10 80       	push   $0x80106ad2
80101302:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101305:	89 d0                	mov    %edx,%eax
80101307:	c1 e0 04             	shl    $0x4,%eax
8010130a:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
8010130f:	50                   	push   %eax
80101310:	e8 63 28 00 00       	call   80103b78 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101315:	83 c3 01             	add    $0x1,%ebx
80101318:	83 c4 10             	add    $0x10,%esp
8010131b:	83 fb 31             	cmp    $0x31,%ebx
8010131e:	7e da                	jle    801012fa <iinit+0x20>
  readsb(dev, &sb);
80101320:	83 ec 08             	sub    $0x8,%esp
80101323:	68 b4 15 11 80       	push   $0x801115b4
80101328:	ff 75 08             	push   0x8(%ebp)
8010132b:	e8 76 ff ff ff       	call   801012a6 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101330:	ff 35 cc 15 11 80    	push   0x801115cc
80101336:	ff 35 c8 15 11 80    	push   0x801115c8
8010133c:	ff 35 c4 15 11 80    	push   0x801115c4
80101342:	ff 35 c0 15 11 80    	push   0x801115c0
80101348:	ff 35 bc 15 11 80    	push   0x801115bc
8010134e:	ff 35 b8 15 11 80    	push   0x801115b8
80101354:	ff 35 b4 15 11 80    	push   0x801115b4
8010135a:	68 38 6b 10 80       	push   $0x80106b38
8010135f:	e8 a3 f2 ff ff       	call   80100607 <cprintf>
}
80101364:	83 c4 30             	add    $0x30,%esp
80101367:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010136a:	c9                   	leave  
8010136b:	c3                   	ret    

8010136c <ialloc>:
{
8010136c:	55                   	push   %ebp
8010136d:	89 e5                	mov    %esp,%ebp
8010136f:	57                   	push   %edi
80101370:	56                   	push   %esi
80101371:	53                   	push   %ebx
80101372:	83 ec 1c             	sub    $0x1c,%esp
80101375:	8b 45 0c             	mov    0xc(%ebp),%eax
80101378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010137b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101380:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101383:	39 1d bc 15 11 80    	cmp    %ebx,0x801115bc
80101389:	76 3f                	jbe    801013ca <ialloc+0x5e>
    bp = bread(dev, IBLOCK(inum, sb));
8010138b:	89 d8                	mov    %ebx,%eax
8010138d:	c1 e8 03             	shr    $0x3,%eax
80101390:	83 ec 08             	sub    $0x8,%esp
80101393:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101399:	50                   	push   %eax
8010139a:	ff 75 08             	push   0x8(%ebp)
8010139d:	e8 ca ed ff ff       	call   8010016c <bread>
801013a2:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013a4:	89 d8                	mov    %ebx,%eax
801013a6:	83 e0 07             	and    $0x7,%eax
801013a9:	c1 e0 06             	shl    $0x6,%eax
801013ac:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013b0:	83 c4 10             	add    $0x10,%esp
801013b3:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013b7:	74 1e                	je     801013d7 <ialloc+0x6b>
    brelse(bp);
801013b9:	83 ec 0c             	sub    $0xc,%esp
801013bc:	56                   	push   %esi
801013bd:	e8 13 ee ff ff       	call   801001d5 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013c2:	83 c3 01             	add    $0x1,%ebx
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	eb b6                	jmp    80101380 <ialloc+0x14>
  panic("ialloc: no inodes");
801013ca:	83 ec 0c             	sub    $0xc,%esp
801013cd:	68 d8 6a 10 80       	push   $0x80106ad8
801013d2:	e8 71 ef ff ff       	call   80100348 <panic>
      memset(dip, 0, sizeof(*dip));
801013d7:	83 ec 04             	sub    $0x4,%esp
801013da:	6a 40                	push   $0x40
801013dc:	6a 00                	push   $0x0
801013de:	57                   	push   %edi
801013df:	e8 87 2a 00 00       	call   80103e6b <memset>
      dip->type = type;
801013e4:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801013e8:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013eb:	89 34 24             	mov    %esi,(%esp)
801013ee:	e8 b4 14 00 00       	call   801028a7 <log_write>
      brelse(bp);
801013f3:	89 34 24             	mov    %esi,(%esp)
801013f6:	e8 da ed ff ff       	call   801001d5 <brelse>
      return iget(dev, inum);
801013fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101401:	e8 f1 fd ff ff       	call   801011f7 <iget>
}
80101406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101409:	5b                   	pop    %ebx
8010140a:	5e                   	pop    %esi
8010140b:	5f                   	pop    %edi
8010140c:	5d                   	pop    %ebp
8010140d:	c3                   	ret    

8010140e <iupdate>:
{
8010140e:	55                   	push   %ebp
8010140f:	89 e5                	mov    %esp,%ebp
80101411:	56                   	push   %esi
80101412:	53                   	push   %ebx
80101413:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101416:	8b 43 04             	mov    0x4(%ebx),%eax
80101419:	c1 e8 03             	shr    $0x3,%eax
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101425:	50                   	push   %eax
80101426:	ff 33                	push   (%ebx)
80101428:	e8 3f ed ff ff       	call   8010016c <bread>
8010142d:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010142f:	8b 43 04             	mov    0x4(%ebx),%eax
80101432:	83 e0 07             	and    $0x7,%eax
80101435:	c1 e0 06             	shl    $0x6,%eax
80101438:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010143c:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101440:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101443:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101447:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010144b:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
8010144f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101453:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101457:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010145b:	8b 53 58             	mov    0x58(%ebx),%edx
8010145e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101461:	83 c3 5c             	add    $0x5c,%ebx
80101464:	83 c0 0c             	add    $0xc,%eax
80101467:	83 c4 0c             	add    $0xc,%esp
8010146a:	6a 34                	push   $0x34
8010146c:	53                   	push   %ebx
8010146d:	50                   	push   %eax
8010146e:	e8 70 2a 00 00       	call   80103ee3 <memmove>
  log_write(bp);
80101473:	89 34 24             	mov    %esi,(%esp)
80101476:	e8 2c 14 00 00       	call   801028a7 <log_write>
  brelse(bp);
8010147b:	89 34 24             	mov    %esi,(%esp)
8010147e:	e8 52 ed ff ff       	call   801001d5 <brelse>
}
80101483:	83 c4 10             	add    $0x10,%esp
80101486:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101489:	5b                   	pop    %ebx
8010148a:	5e                   	pop    %esi
8010148b:	5d                   	pop    %ebp
8010148c:	c3                   	ret    

8010148d <itrunc>:
{
8010148d:	55                   	push   %ebp
8010148e:	89 e5                	mov    %esp,%ebp
80101490:	57                   	push   %edi
80101491:	56                   	push   %esi
80101492:	53                   	push   %ebx
80101493:	83 ec 1c             	sub    $0x1c,%esp
80101496:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101498:	bb 00 00 00 00       	mov    $0x0,%ebx
8010149d:	eb 03                	jmp    801014a2 <itrunc+0x15>
8010149f:	83 c3 01             	add    $0x1,%ebx
801014a2:	83 fb 0b             	cmp    $0xb,%ebx
801014a5:	7f 19                	jg     801014c0 <itrunc+0x33>
    if(ip->addrs[i]){
801014a7:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014ab:	85 d2                	test   %edx,%edx
801014ad:	74 f0                	je     8010149f <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014af:	8b 06                	mov    (%esi),%eax
801014b1:	e8 3d fb ff ff       	call   80100ff3 <bfree>
      ip->addrs[i] = 0;
801014b6:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014bd:	00 
801014be:	eb df                	jmp    8010149f <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014c0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	75 1b                	jne    801014e5 <itrunc+0x58>
  ip->size = 0;
801014ca:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	56                   	push   %esi
801014d5:	e8 34 ff ff ff       	call   8010140e <iupdate>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5f                   	pop    %edi
801014e3:	5d                   	pop    %ebp
801014e4:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014e5:	83 ec 08             	sub    $0x8,%esp
801014e8:	50                   	push   %eax
801014e9:	ff 36                	push   (%esi)
801014eb:	e8 7c ec ff ff       	call   8010016c <bread>
801014f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801014f3:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801014f6:	83 c4 10             	add    $0x10,%esp
801014f9:	bb 00 00 00 00       	mov    $0x0,%ebx
801014fe:	eb 03                	jmp    80101503 <itrunc+0x76>
80101500:	83 c3 01             	add    $0x1,%ebx
80101503:	83 fb 7f             	cmp    $0x7f,%ebx
80101506:	77 10                	ja     80101518 <itrunc+0x8b>
      if(a[j])
80101508:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
8010150b:	85 d2                	test   %edx,%edx
8010150d:	74 f1                	je     80101500 <itrunc+0x73>
        bfree(ip->dev, a[j]);
8010150f:	8b 06                	mov    (%esi),%eax
80101511:	e8 dd fa ff ff       	call   80100ff3 <bfree>
80101516:	eb e8                	jmp    80101500 <itrunc+0x73>
    brelse(bp);
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	ff 75 e4             	push   -0x1c(%ebp)
8010151e:	e8 b2 ec ff ff       	call   801001d5 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
8010152b:	e8 c3 fa ff ff       	call   80100ff3 <bfree>
    ip->addrs[NDIRECT] = 0;
80101530:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101537:	00 00 00 
8010153a:	83 c4 10             	add    $0x10,%esp
8010153d:	eb 8b                	jmp    801014ca <itrunc+0x3d>

8010153f <idup>:
{
8010153f:	55                   	push   %ebp
80101540:	89 e5                	mov    %esp,%ebp
80101542:	53                   	push   %ebx
80101543:	83 ec 10             	sub    $0x10,%esp
80101546:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101549:	68 60 f9 10 80       	push   $0x8010f960
8010154e:	e8 6c 28 00 00       	call   80103dbf <acquire>
  ip->ref++;
80101553:	8b 43 08             	mov    0x8(%ebx),%eax
80101556:	83 c0 01             	add    $0x1,%eax
80101559:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010155c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101563:	e8 bc 28 00 00       	call   80103e24 <release>
}
80101568:	89 d8                	mov    %ebx,%eax
8010156a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010156d:	c9                   	leave  
8010156e:	c3                   	ret    

8010156f <ilock>:
{
8010156f:	55                   	push   %ebp
80101570:	89 e5                	mov    %esp,%ebp
80101572:	56                   	push   %esi
80101573:	53                   	push   %ebx
80101574:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101577:	85 db                	test   %ebx,%ebx
80101579:	74 22                	je     8010159d <ilock+0x2e>
8010157b:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010157f:	7e 1c                	jle    8010159d <ilock+0x2e>
  acquiresleep(&ip->lock);
80101581:	83 ec 0c             	sub    $0xc,%esp
80101584:	8d 43 0c             	lea    0xc(%ebx),%eax
80101587:	50                   	push   %eax
80101588:	e8 1e 26 00 00       	call   80103bab <acquiresleep>
  if(ip->valid == 0){
8010158d:	83 c4 10             	add    $0x10,%esp
80101590:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101594:	74 14                	je     801015aa <ilock+0x3b>
}
80101596:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101599:	5b                   	pop    %ebx
8010159a:	5e                   	pop    %esi
8010159b:	5d                   	pop    %ebp
8010159c:	c3                   	ret    
    panic("ilock");
8010159d:	83 ec 0c             	sub    $0xc,%esp
801015a0:	68 ea 6a 10 80       	push   $0x80106aea
801015a5:	e8 9e ed ff ff       	call   80100348 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015aa:	8b 43 04             	mov    0x4(%ebx),%eax
801015ad:	c1 e8 03             	shr    $0x3,%eax
801015b0:	83 ec 08             	sub    $0x8,%esp
801015b3:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801015b9:	50                   	push   %eax
801015ba:	ff 33                	push   (%ebx)
801015bc:	e8 ab eb ff ff       	call   8010016c <bread>
801015c1:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015c3:	8b 43 04             	mov    0x4(%ebx),%eax
801015c6:	83 e0 07             	and    $0x7,%eax
801015c9:	c1 e0 06             	shl    $0x6,%eax
801015cc:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015d0:	0f b7 10             	movzwl (%eax),%edx
801015d3:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015d7:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801015db:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015df:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801015e3:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015e7:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801015eb:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015ef:	8b 50 08             	mov    0x8(%eax),%edx
801015f2:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015f5:	83 c0 0c             	add    $0xc,%eax
801015f8:	8d 53 5c             	lea    0x5c(%ebx),%edx
801015fb:	83 c4 0c             	add    $0xc,%esp
801015fe:	6a 34                	push   $0x34
80101600:	50                   	push   %eax
80101601:	52                   	push   %edx
80101602:	e8 dc 28 00 00       	call   80103ee3 <memmove>
    brelse(bp);
80101607:	89 34 24             	mov    %esi,(%esp)
8010160a:	e8 c6 eb ff ff       	call   801001d5 <brelse>
    ip->valid = 1;
8010160f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101616:	83 c4 10             	add    $0x10,%esp
80101619:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010161e:	0f 85 72 ff ff ff    	jne    80101596 <ilock+0x27>
      panic("ilock: no type");
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	68 f0 6a 10 80       	push   $0x80106af0
8010162c:	e8 17 ed ff ff       	call   80100348 <panic>

80101631 <iunlock>:
{
80101631:	55                   	push   %ebp
80101632:	89 e5                	mov    %esp,%ebp
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101639:	85 db                	test   %ebx,%ebx
8010163b:	74 2c                	je     80101669 <iunlock+0x38>
8010163d:	8d 73 0c             	lea    0xc(%ebx),%esi
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	56                   	push   %esi
80101644:	e8 ec 25 00 00       	call   80103c35 <holdingsleep>
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	85 c0                	test   %eax,%eax
8010164e:	74 19                	je     80101669 <iunlock+0x38>
80101650:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101654:	7e 13                	jle    80101669 <iunlock+0x38>
  releasesleep(&ip->lock);
80101656:	83 ec 0c             	sub    $0xc,%esp
80101659:	56                   	push   %esi
8010165a:	e8 9b 25 00 00       	call   80103bfa <releasesleep>
}
8010165f:	83 c4 10             	add    $0x10,%esp
80101662:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101665:	5b                   	pop    %ebx
80101666:	5e                   	pop    %esi
80101667:	5d                   	pop    %ebp
80101668:	c3                   	ret    
    panic("iunlock");
80101669:	83 ec 0c             	sub    $0xc,%esp
8010166c:	68 ff 6a 10 80       	push   $0x80106aff
80101671:	e8 d2 ec ff ff       	call   80100348 <panic>

80101676 <iput>:
{
80101676:	55                   	push   %ebp
80101677:	89 e5                	mov    %esp,%ebp
80101679:	57                   	push   %edi
8010167a:	56                   	push   %esi
8010167b:	53                   	push   %ebx
8010167c:	83 ec 18             	sub    $0x18,%esp
8010167f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101682:	8d 73 0c             	lea    0xc(%ebx),%esi
80101685:	56                   	push   %esi
80101686:	e8 20 25 00 00       	call   80103bab <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101692:	74 07                	je     8010169b <iput+0x25>
80101694:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101699:	74 35                	je     801016d0 <iput+0x5a>
  releasesleep(&ip->lock);
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	56                   	push   %esi
8010169f:	e8 56 25 00 00       	call   80103bfa <releasesleep>
  acquire(&icache.lock);
801016a4:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016ab:	e8 0f 27 00 00       	call   80103dbf <acquire>
  ip->ref--;
801016b0:	8b 43 08             	mov    0x8(%ebx),%eax
801016b3:	83 e8 01             	sub    $0x1,%eax
801016b6:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016b9:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016c0:	e8 5f 27 00 00       	call   80103e24 <release>
}
801016c5:	83 c4 10             	add    $0x10,%esp
801016c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016cb:	5b                   	pop    %ebx
801016cc:	5e                   	pop    %esi
801016cd:	5f                   	pop    %edi
801016ce:	5d                   	pop    %ebp
801016cf:	c3                   	ret    
    acquire(&icache.lock);
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 60 f9 10 80       	push   $0x8010f960
801016d8:	e8 e2 26 00 00       	call   80103dbf <acquire>
    int r = ip->ref;
801016dd:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016e0:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016e7:	e8 38 27 00 00       	call   80103e24 <release>
    if(r == 1){
801016ec:	83 c4 10             	add    $0x10,%esp
801016ef:	83 ff 01             	cmp    $0x1,%edi
801016f2:	75 a7                	jne    8010169b <iput+0x25>
      itrunc(ip);
801016f4:	89 d8                	mov    %ebx,%eax
801016f6:	e8 92 fd ff ff       	call   8010148d <itrunc>
      ip->type = 0;
801016fb:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101701:	83 ec 0c             	sub    $0xc,%esp
80101704:	53                   	push   %ebx
80101705:	e8 04 fd ff ff       	call   8010140e <iupdate>
      ip->valid = 0;
8010170a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101711:	83 c4 10             	add    $0x10,%esp
80101714:	eb 85                	jmp    8010169b <iput+0x25>

80101716 <iunlockput>:
{
80101716:	55                   	push   %ebp
80101717:	89 e5                	mov    %esp,%ebp
80101719:	53                   	push   %ebx
8010171a:	83 ec 10             	sub    $0x10,%esp
8010171d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101720:	53                   	push   %ebx
80101721:	e8 0b ff ff ff       	call   80101631 <iunlock>
  iput(ip);
80101726:	89 1c 24             	mov    %ebx,(%esp)
80101729:	e8 48 ff ff ff       	call   80101676 <iput>
}
8010172e:	83 c4 10             	add    $0x10,%esp
80101731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101734:	c9                   	leave  
80101735:	c3                   	ret    

80101736 <stati>:
{
80101736:	55                   	push   %ebp
80101737:	89 e5                	mov    %esp,%ebp
80101739:	8b 55 08             	mov    0x8(%ebp),%edx
8010173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010173f:	8b 0a                	mov    (%edx),%ecx
80101741:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101744:	8b 4a 04             	mov    0x4(%edx),%ecx
80101747:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010174a:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
8010174e:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101751:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101755:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101759:	8b 52 58             	mov    0x58(%edx),%edx
8010175c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010175f:	5d                   	pop    %ebp
80101760:	c3                   	ret    

80101761 <readi>:
{
80101761:	55                   	push   %ebp
80101762:	89 e5                	mov    %esp,%ebp
80101764:	57                   	push   %edi
80101765:	56                   	push   %esi
80101766:	53                   	push   %ebx
80101767:	83 ec 1c             	sub    $0x1c,%esp
8010176a:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
8010176d:	8b 45 08             	mov    0x8(%ebp),%eax
80101770:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101775:	74 2c                	je     801017a3 <readi+0x42>
  if(off > ip->size || off + n < off)
80101777:	8b 45 08             	mov    0x8(%ebp),%eax
8010177a:	8b 40 58             	mov    0x58(%eax),%eax
8010177d:	39 f8                	cmp    %edi,%eax
8010177f:	0f 82 cb 00 00 00    	jb     80101850 <readi+0xef>
80101785:	89 fa                	mov    %edi,%edx
80101787:	03 55 14             	add    0x14(%ebp),%edx
8010178a:	0f 82 c7 00 00 00    	jb     80101857 <readi+0xf6>
  if(off + n > ip->size)
80101790:	39 d0                	cmp    %edx,%eax
80101792:	73 05                	jae    80101799 <readi+0x38>
    n = ip->size - off;
80101794:	29 f8                	sub    %edi,%eax
80101796:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101799:	be 00 00 00 00       	mov    $0x0,%esi
8010179e:	e9 8f 00 00 00       	jmp    80101832 <readi+0xd1>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017a3:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801017a7:	66 83 f8 09          	cmp    $0x9,%ax
801017ab:	0f 87 91 00 00 00    	ja     80101842 <readi+0xe1>
801017b1:	98                   	cwtl   
801017b2:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
801017b9:	85 c0                	test   %eax,%eax
801017bb:	0f 84 88 00 00 00    	je     80101849 <readi+0xe8>
    return devsw[ip->major].read(ip, dst, n);
801017c1:	83 ec 04             	sub    $0x4,%esp
801017c4:	ff 75 14             	push   0x14(%ebp)
801017c7:	ff 75 0c             	push   0xc(%ebp)
801017ca:	ff 75 08             	push   0x8(%ebp)
801017cd:	ff d0                	call   *%eax
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	eb 66                	jmp    8010183a <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017d4:	89 fa                	mov    %edi,%edx
801017d6:	c1 ea 09             	shr    $0x9,%edx
801017d9:	8b 45 08             	mov    0x8(%ebp),%eax
801017dc:	e8 70 f9 ff ff       	call   80101151 <bmap>
801017e1:	83 ec 08             	sub    $0x8,%esp
801017e4:	50                   	push   %eax
801017e5:	8b 45 08             	mov    0x8(%ebp),%eax
801017e8:	ff 30                	push   (%eax)
801017ea:	e8 7d e9 ff ff       	call   8010016c <bread>
801017ef:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801017f1:	89 f8                	mov    %edi,%eax
801017f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801017f8:	bb 00 02 00 00       	mov    $0x200,%ebx
801017fd:	29 c3                	sub    %eax,%ebx
801017ff:	8b 55 14             	mov    0x14(%ebp),%edx
80101802:	29 f2                	sub    %esi,%edx
80101804:	39 d3                	cmp    %edx,%ebx
80101806:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101809:	83 c4 0c             	add    $0xc,%esp
8010180c:	53                   	push   %ebx
8010180d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101810:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101814:	50                   	push   %eax
80101815:	ff 75 0c             	push   0xc(%ebp)
80101818:	e8 c6 26 00 00       	call   80103ee3 <memmove>
    brelse(bp);
8010181d:	83 c4 04             	add    $0x4,%esp
80101820:	ff 75 e4             	push   -0x1c(%ebp)
80101823:	e8 ad e9 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101828:	01 de                	add    %ebx,%esi
8010182a:	01 df                	add    %ebx,%edi
8010182c:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	39 75 14             	cmp    %esi,0x14(%ebp)
80101835:	77 9d                	ja     801017d4 <readi+0x73>
  return n;
80101837:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010183a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183d:	5b                   	pop    %ebx
8010183e:	5e                   	pop    %esi
8010183f:	5f                   	pop    %edi
80101840:	5d                   	pop    %ebp
80101841:	c3                   	ret    
      return -1;
80101842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101847:	eb f1                	jmp    8010183a <readi+0xd9>
80101849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010184e:	eb ea                	jmp    8010183a <readi+0xd9>
    return -1;
80101850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101855:	eb e3                	jmp    8010183a <readi+0xd9>
80101857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010185c:	eb dc                	jmp    8010183a <readi+0xd9>

8010185e <writei>:
{
8010185e:	55                   	push   %ebp
8010185f:	89 e5                	mov    %esp,%ebp
80101861:	57                   	push   %edi
80101862:	56                   	push   %esi
80101863:	53                   	push   %ebx
80101864:	83 ec 1c             	sub    $0x1c,%esp
80101867:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
8010186a:	8b 45 08             	mov    0x8(%ebp),%eax
8010186d:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101872:	74 2e                	je     801018a2 <writei+0x44>
  if(off > ip->size || off + n < off)
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	39 78 58             	cmp    %edi,0x58(%eax)
8010187a:	0f 82 f5 00 00 00    	jb     80101975 <writei+0x117>
80101880:	89 f8                	mov    %edi,%eax
80101882:	03 45 14             	add    0x14(%ebp),%eax
80101885:	0f 82 f1 00 00 00    	jb     8010197c <writei+0x11e>
  if(off + n > MAXFILE*BSIZE)
8010188b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101890:	0f 87 ed 00 00 00    	ja     80101983 <writei+0x125>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101896:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010189d:	e9 93 00 00 00       	jmp    80101935 <writei+0xd7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018a2:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018a6:	66 83 f8 09          	cmp    $0x9,%ax
801018aa:	0f 87 b7 00 00 00    	ja     80101967 <writei+0x109>
801018b0:	98                   	cwtl   
801018b1:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
801018b8:	85 c0                	test   %eax,%eax
801018ba:	0f 84 ae 00 00 00    	je     8010196e <writei+0x110>
    return devsw[ip->major].write(ip, src, n);
801018c0:	83 ec 04             	sub    $0x4,%esp
801018c3:	ff 75 14             	push   0x14(%ebp)
801018c6:	ff 75 0c             	push   0xc(%ebp)
801018c9:	ff 75 08             	push   0x8(%ebp)
801018cc:	ff d0                	call   *%eax
801018ce:	83 c4 10             	add    $0x10,%esp
801018d1:	eb 7b                	jmp    8010194e <writei+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018d3:	89 fa                	mov    %edi,%edx
801018d5:	c1 ea 09             	shr    $0x9,%edx
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	e8 71 f8 ff ff       	call   80101151 <bmap>
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	8b 45 08             	mov    0x8(%ebp),%eax
801018e7:	ff 30                	push   (%eax)
801018e9:	e8 7e e8 ff ff       	call   8010016c <bread>
801018ee:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801018f0:	89 f8                	mov    %edi,%eax
801018f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801018f7:	bb 00 02 00 00       	mov    $0x200,%ebx
801018fc:	29 c3                	sub    %eax,%ebx
801018fe:	8b 55 14             	mov    0x14(%ebp),%edx
80101901:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80101904:	39 d3                	cmp    %edx,%ebx
80101906:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101909:	83 c4 0c             	add    $0xc,%esp
8010190c:	53                   	push   %ebx
8010190d:	ff 75 0c             	push   0xc(%ebp)
80101910:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101914:	50                   	push   %eax
80101915:	e8 c9 25 00 00       	call   80103ee3 <memmove>
    log_write(bp);
8010191a:	89 34 24             	mov    %esi,(%esp)
8010191d:	e8 85 0f 00 00       	call   801028a7 <log_write>
    brelse(bp);
80101922:	89 34 24             	mov    %esi,(%esp)
80101925:	e8 ab e8 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010192a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010192d:	01 df                	add    %ebx,%edi
8010192f:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101938:	3b 45 14             	cmp    0x14(%ebp),%eax
8010193b:	72 96                	jb     801018d3 <writei+0x75>
  if(n > 0 && off > ip->size){
8010193d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101941:	74 08                	je     8010194b <writei+0xed>
80101943:	8b 45 08             	mov    0x8(%ebp),%eax
80101946:	39 78 58             	cmp    %edi,0x58(%eax)
80101949:	72 0b                	jb     80101956 <writei+0xf8>
  return n;
8010194b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010194e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101951:	5b                   	pop    %ebx
80101952:	5e                   	pop    %esi
80101953:	5f                   	pop    %edi
80101954:	5d                   	pop    %ebp
80101955:	c3                   	ret    
    ip->size = off;
80101956:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	50                   	push   %eax
8010195d:	e8 ac fa ff ff       	call   8010140e <iupdate>
80101962:	83 c4 10             	add    $0x10,%esp
80101965:	eb e4                	jmp    8010194b <writei+0xed>
      return -1;
80101967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010196c:	eb e0                	jmp    8010194e <writei+0xf0>
8010196e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101973:	eb d9                	jmp    8010194e <writei+0xf0>
    return -1;
80101975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010197a:	eb d2                	jmp    8010194e <writei+0xf0>
8010197c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101981:	eb cb                	jmp    8010194e <writei+0xf0>
    return -1;
80101983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101988:	eb c4                	jmp    8010194e <writei+0xf0>

8010198a <namecmp>:
{
8010198a:	55                   	push   %ebp
8010198b:	89 e5                	mov    %esp,%ebp
8010198d:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101990:	6a 0e                	push   $0xe
80101992:	ff 75 0c             	push   0xc(%ebp)
80101995:	ff 75 08             	push   0x8(%ebp)
80101998:	e8 b2 25 00 00       	call   80103f4f <strncmp>
}
8010199d:	c9                   	leave  
8010199e:	c3                   	ret    

8010199f <dirlookup>:
{
8010199f:	55                   	push   %ebp
801019a0:	89 e5                	mov    %esp,%ebp
801019a2:	57                   	push   %edi
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	83 ec 1c             	sub    $0x1c,%esp
801019a8:	8b 75 08             	mov    0x8(%ebp),%esi
801019ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ae:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019b3:	75 07                	jne    801019bc <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019b5:	bb 00 00 00 00       	mov    $0x0,%ebx
801019ba:	eb 1d                	jmp    801019d9 <dirlookup+0x3a>
    panic("dirlookup not DIR");
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	68 07 6b 10 80       	push   $0x80106b07
801019c4:	e8 7f e9 ff ff       	call   80100348 <panic>
      panic("dirlookup read");
801019c9:	83 ec 0c             	sub    $0xc,%esp
801019cc:	68 19 6b 10 80       	push   $0x80106b19
801019d1:	e8 72 e9 ff ff       	call   80100348 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019d6:	83 c3 10             	add    $0x10,%ebx
801019d9:	39 5e 58             	cmp    %ebx,0x58(%esi)
801019dc:	76 48                	jbe    80101a26 <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019de:	6a 10                	push   $0x10
801019e0:	53                   	push   %ebx
801019e1:	8d 45 d8             	lea    -0x28(%ebp),%eax
801019e4:	50                   	push   %eax
801019e5:	56                   	push   %esi
801019e6:	e8 76 fd ff ff       	call   80101761 <readi>
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	83 f8 10             	cmp    $0x10,%eax
801019f1:	75 d6                	jne    801019c9 <dirlookup+0x2a>
    if(de.inum == 0)
801019f3:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801019f8:	74 dc                	je     801019d6 <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
801019fa:	83 ec 08             	sub    $0x8,%esp
801019fd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a00:	50                   	push   %eax
80101a01:	57                   	push   %edi
80101a02:	e8 83 ff ff ff       	call   8010198a <namecmp>
80101a07:	83 c4 10             	add    $0x10,%esp
80101a0a:	85 c0                	test   %eax,%eax
80101a0c:	75 c8                	jne    801019d6 <dirlookup+0x37>
      if(poff)
80101a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a12:	74 05                	je     80101a19 <dirlookup+0x7a>
        *poff = off;
80101a14:	8b 45 10             	mov    0x10(%ebp),%eax
80101a17:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a19:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a1d:	8b 06                	mov    (%esi),%eax
80101a1f:	e8 d3 f7 ff ff       	call   801011f7 <iget>
80101a24:	eb 05                	jmp    80101a2b <dirlookup+0x8c>
  return 0;
80101a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
80101a32:	c3                   	ret    

80101a33 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a33:	55                   	push   %ebp
80101a34:	89 e5                	mov    %esp,%ebp
80101a36:	57                   	push   %edi
80101a37:	56                   	push   %esi
80101a38:	53                   	push   %ebx
80101a39:	83 ec 1c             	sub    $0x1c,%esp
80101a3c:	89 c3                	mov    %eax,%ebx
80101a3e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a44:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a47:	74 17                	je     80101a60 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a49:	e8 67 17 00 00       	call   801031b5 <myproc>
80101a4e:	83 ec 0c             	sub    $0xc,%esp
80101a51:	ff 70 68             	push   0x68(%eax)
80101a54:	e8 e6 fa ff ff       	call   8010153f <idup>
80101a59:	89 c6                	mov    %eax,%esi
80101a5b:	83 c4 10             	add    $0x10,%esp
80101a5e:	eb 53                	jmp    80101ab3 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101a60:	ba 01 00 00 00       	mov    $0x1,%edx
80101a65:	b8 01 00 00 00       	mov    $0x1,%eax
80101a6a:	e8 88 f7 ff ff       	call   801011f7 <iget>
80101a6f:	89 c6                	mov    %eax,%esi
80101a71:	eb 40                	jmp    80101ab3 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a73:	83 ec 0c             	sub    $0xc,%esp
80101a76:	56                   	push   %esi
80101a77:	e8 9a fc ff ff       	call   80101716 <iunlockput>
      return 0;
80101a7c:	83 c4 10             	add    $0x10,%esp
80101a7f:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a84:	89 f0                	mov    %esi,%eax
80101a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a89:	5b                   	pop    %ebx
80101a8a:	5e                   	pop    %esi
80101a8b:	5f                   	pop    %edi
80101a8c:	5d                   	pop    %ebp
80101a8d:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101a8e:	83 ec 04             	sub    $0x4,%esp
80101a91:	6a 00                	push   $0x0
80101a93:	ff 75 e4             	push   -0x1c(%ebp)
80101a96:	56                   	push   %esi
80101a97:	e8 03 ff ff ff       	call   8010199f <dirlookup>
80101a9c:	89 c7                	mov    %eax,%edi
80101a9e:	83 c4 10             	add    $0x10,%esp
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	74 4a                	je     80101aef <namex+0xbc>
    iunlockput(ip);
80101aa5:	83 ec 0c             	sub    $0xc,%esp
80101aa8:	56                   	push   %esi
80101aa9:	e8 68 fc ff ff       	call   80101716 <iunlockput>
80101aae:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101ab1:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ab6:	89 d8                	mov    %ebx,%eax
80101ab8:	e8 85 f4 ff ff       	call   80100f42 <skipelem>
80101abd:	89 c3                	mov    %eax,%ebx
80101abf:	85 c0                	test   %eax,%eax
80101ac1:	74 3c                	je     80101aff <namex+0xcc>
    ilock(ip);
80101ac3:	83 ec 0c             	sub    $0xc,%esp
80101ac6:	56                   	push   %esi
80101ac7:	e8 a3 fa ff ff       	call   8010156f <ilock>
    if(ip->type != T_DIR){
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ad4:	75 9d                	jne    80101a73 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101ada:	74 b2                	je     80101a8e <namex+0x5b>
80101adc:	80 3b 00             	cmpb   $0x0,(%ebx)
80101adf:	75 ad                	jne    80101a8e <namex+0x5b>
      iunlock(ip);
80101ae1:	83 ec 0c             	sub    $0xc,%esp
80101ae4:	56                   	push   %esi
80101ae5:	e8 47 fb ff ff       	call   80101631 <iunlock>
      return ip;
80101aea:	83 c4 10             	add    $0x10,%esp
80101aed:	eb 95                	jmp    80101a84 <namex+0x51>
      iunlockput(ip);
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	56                   	push   %esi
80101af3:	e8 1e fc ff ff       	call   80101716 <iunlockput>
      return 0;
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	89 fe                	mov    %edi,%esi
80101afd:	eb 85                	jmp    80101a84 <namex+0x51>
  if(nameiparent){
80101aff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b03:	0f 84 7b ff ff ff    	je     80101a84 <namex+0x51>
    iput(ip);
80101b09:	83 ec 0c             	sub    $0xc,%esp
80101b0c:	56                   	push   %esi
80101b0d:	e8 64 fb ff ff       	call   80101676 <iput>
    return 0;
80101b12:	83 c4 10             	add    $0x10,%esp
80101b15:	89 de                	mov    %ebx,%esi
80101b17:	e9 68 ff ff ff       	jmp    80101a84 <namex+0x51>

80101b1c <dirlink>:
{
80101b1c:	55                   	push   %ebp
80101b1d:	89 e5                	mov    %esp,%ebp
80101b1f:	57                   	push   %edi
80101b20:	56                   	push   %esi
80101b21:	53                   	push   %ebx
80101b22:	83 ec 20             	sub    $0x20,%esp
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b28:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b2b:	6a 00                	push   $0x0
80101b2d:	57                   	push   %edi
80101b2e:	53                   	push   %ebx
80101b2f:	e8 6b fe ff ff       	call   8010199f <dirlookup>
80101b34:	83 c4 10             	add    $0x10,%esp
80101b37:	85 c0                	test   %eax,%eax
80101b39:	75 2d                	jne    80101b68 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b3b:	b8 00 00 00 00       	mov    $0x0,%eax
80101b40:	89 c6                	mov    %eax,%esi
80101b42:	39 43 58             	cmp    %eax,0x58(%ebx)
80101b45:	76 41                	jbe    80101b88 <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b47:	6a 10                	push   $0x10
80101b49:	50                   	push   %eax
80101b4a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b4d:	50                   	push   %eax
80101b4e:	53                   	push   %ebx
80101b4f:	e8 0d fc ff ff       	call   80101761 <readi>
80101b54:	83 c4 10             	add    $0x10,%esp
80101b57:	83 f8 10             	cmp    $0x10,%eax
80101b5a:	75 1f                	jne    80101b7b <dirlink+0x5f>
    if(de.inum == 0)
80101b5c:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b61:	74 25                	je     80101b88 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b63:	8d 46 10             	lea    0x10(%esi),%eax
80101b66:	eb d8                	jmp    80101b40 <dirlink+0x24>
    iput(ip);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	50                   	push   %eax
80101b6c:	e8 05 fb ff ff       	call   80101676 <iput>
    return -1;
80101b71:	83 c4 10             	add    $0x10,%esp
80101b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b79:	eb 3d                	jmp    80101bb8 <dirlink+0x9c>
      panic("dirlink read");
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 28 6b 10 80       	push   $0x80106b28
80101b83:	e8 c0 e7 ff ff       	call   80100348 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b88:	83 ec 04             	sub    $0x4,%esp
80101b8b:	6a 0e                	push   $0xe
80101b8d:	57                   	push   %edi
80101b8e:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b94:	50                   	push   %eax
80101b95:	e8 f4 23 00 00       	call   80103f8e <strncpy>
  de.inum = inum;
80101b9a:	8b 45 10             	mov    0x10(%ebp),%eax
80101b9d:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba1:	6a 10                	push   $0x10
80101ba3:	56                   	push   %esi
80101ba4:	57                   	push   %edi
80101ba5:	53                   	push   %ebx
80101ba6:	e8 b3 fc ff ff       	call   8010185e <writei>
80101bab:	83 c4 20             	add    $0x20,%esp
80101bae:	83 f8 10             	cmp    $0x10,%eax
80101bb1:	75 0d                	jne    80101bc0 <dirlink+0xa4>
  return 0;
80101bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbb:	5b                   	pop    %ebx
80101bbc:	5e                   	pop    %esi
80101bbd:	5f                   	pop    %edi
80101bbe:	5d                   	pop    %ebp
80101bbf:	c3                   	ret    
    panic("dirlink");
80101bc0:	83 ec 0c             	sub    $0xc,%esp
80101bc3:	68 c0 71 10 80       	push   $0x801071c0
80101bc8:	e8 7b e7 ff ff       	call   80100348 <panic>

80101bcd <namei>:

struct inode*
namei(char *path)
{
80101bcd:	55                   	push   %ebp
80101bce:	89 e5                	mov    %esp,%ebp
80101bd0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101bd3:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101bd6:	ba 00 00 00 00       	mov    $0x0,%edx
80101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bde:	e8 50 fe ff ff       	call   80101a33 <namex>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    

80101be5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101be5:	55                   	push   %ebp
80101be6:	89 e5                	mov    %esp,%ebp
80101be8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101bee:	ba 01 00 00 00       	mov    $0x1,%edx
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	e8 38 fe ff ff       	call   80101a33 <namex>
}
80101bfb:	c9                   	leave  
80101bfc:	c3                   	ret    

80101bfd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101bfd:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101bff:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c04:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c05:	89 c2                	mov    %eax,%edx
80101c07:	83 e2 c0             	and    $0xffffffc0,%edx
80101c0a:	80 fa 40             	cmp    $0x40,%dl
80101c0d:	75 f0                	jne    80101bff <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c0f:	85 c9                	test   %ecx,%ecx
80101c11:	74 09                	je     80101c1c <idewait+0x1f>
80101c13:	a8 21                	test   $0x21,%al
80101c15:	75 08                	jne    80101c1f <idewait+0x22>
    return -1;
  return 0;
80101c17:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c1c:	89 c8                	mov    %ecx,%eax
80101c1e:	c3                   	ret    
    return -1;
80101c1f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c24:	eb f6                	jmp    80101c1c <idewait+0x1f>

80101c26 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c26:	55                   	push   %ebp
80101c27:	89 e5                	mov    %esp,%ebp
80101c29:	56                   	push   %esi
80101c2a:	53                   	push   %ebx
  if(b == 0)
80101c2b:	85 c0                	test   %eax,%eax
80101c2d:	0f 84 8f 00 00 00    	je     80101cc2 <idestart+0x9c>
80101c33:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c35:	8b 58 08             	mov    0x8(%eax),%ebx
80101c38:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c3e:	0f 87 8b 00 00 00    	ja     80101ccf <idestart+0xa9>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c44:	b8 00 00 00 00       	mov    $0x0,%eax
80101c49:	e8 af ff ff ff       	call   80101bfd <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c4e:	b8 00 00 00 00       	mov    $0x0,%eax
80101c53:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101c58:	ee                   	out    %al,(%dx)
80101c59:	b8 01 00 00 00       	mov    $0x1,%eax
80101c5e:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101c63:	ee                   	out    %al,(%dx)
80101c64:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c69:	89 d8                	mov    %ebx,%eax
80101c6b:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c6c:	0f b6 c7             	movzbl %bh,%eax
80101c6f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c74:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c75:	89 d8                	mov    %ebx,%eax
80101c77:	c1 f8 10             	sar    $0x10,%eax
80101c7a:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c7f:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c80:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101c84:	c1 e0 04             	shl    $0x4,%eax
80101c87:	83 e0 10             	and    $0x10,%eax
80101c8a:	c1 fb 18             	sar    $0x18,%ebx
80101c8d:	83 e3 0f             	and    $0xf,%ebx
80101c90:	09 d8                	or     %ebx,%eax
80101c92:	83 c8 e0             	or     $0xffffffe0,%eax
80101c95:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c9a:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101c9b:	f6 06 04             	testb  $0x4,(%esi)
80101c9e:	74 3c                	je     80101cdc <idestart+0xb6>
80101ca0:	b8 30 00 00 00       	mov    $0x30,%eax
80101ca5:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101caa:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cab:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101cae:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cb3:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cb8:	fc                   	cld    
80101cb9:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101cbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cbe:	5b                   	pop    %ebx
80101cbf:	5e                   	pop    %esi
80101cc0:	5d                   	pop    %ebp
80101cc1:	c3                   	ret    
    panic("idestart");
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 8b 6b 10 80       	push   $0x80106b8b
80101cca:	e8 79 e6 ff ff       	call   80100348 <panic>
    panic("incorrect blockno");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 94 6b 10 80       	push   $0x80106b94
80101cd7:	e8 6c e6 ff ff       	call   80100348 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cdc:	b8 20 00 00 00       	mov    $0x20,%eax
80101ce1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ce6:	ee                   	out    %al,(%dx)
}
80101ce7:	eb d2                	jmp    80101cbb <idestart+0x95>

80101ce9 <ideinit>:
{
80101ce9:	55                   	push   %ebp
80101cea:	89 e5                	mov    %esp,%ebp
80101cec:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101cef:	68 a6 6b 10 80       	push   $0x80106ba6
80101cf4:	68 00 16 11 80       	push   $0x80111600
80101cf9:	e8 85 1f 00 00       	call   80103c83 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101cfe:	83 c4 08             	add    $0x8,%esp
80101d01:	a1 84 17 11 80       	mov    0x80111784,%eax
80101d06:	83 e8 01             	sub    $0x1,%eax
80101d09:	50                   	push   %eax
80101d0a:	6a 0e                	push   $0xe
80101d0c:	e8 50 02 00 00       	call   80101f61 <ioapicenable>
  idewait(0);
80101d11:	b8 00 00 00 00       	mov    $0x0,%eax
80101d16:	e8 e2 fe ff ff       	call   80101bfd <idewait>
80101d1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101d20:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d25:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d26:	83 c4 10             	add    $0x10,%esp
80101d29:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d2e:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d34:	7f 19                	jg     80101d4f <ideinit+0x66>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d36:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3b:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d3c:	84 c0                	test   %al,%al
80101d3e:	75 05                	jne    80101d45 <ideinit+0x5c>
  for(i=0; i<1000; i++){
80101d40:	83 c1 01             	add    $0x1,%ecx
80101d43:	eb e9                	jmp    80101d2e <ideinit+0x45>
      havedisk1 = 1;
80101d45:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101d4c:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d4f:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101d54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d59:	ee                   	out    %al,(%dx)
}
80101d5a:	c9                   	leave  
80101d5b:	c3                   	ret    

80101d5c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d5c:	55                   	push   %ebp
80101d5d:	89 e5                	mov    %esp,%ebp
80101d5f:	57                   	push   %edi
80101d60:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101d61:	83 ec 0c             	sub    $0xc,%esp
80101d64:	68 00 16 11 80       	push   $0x80111600
80101d69:	e8 51 20 00 00       	call   80103dbf <acquire>

  if((b = idequeue) == 0){
80101d6e:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101d74:	83 c4 10             	add    $0x10,%esp
80101d77:	85 db                	test   %ebx,%ebx
80101d79:	74 4a                	je     80101dc5 <ideintr+0x69>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101d7e:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d83:	f6 03 04             	testb  $0x4,(%ebx)
80101d86:	74 4f                	je     80101dd7 <ideintr+0x7b>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d88:	8b 03                	mov    (%ebx),%eax
80101d8a:	83 c8 02             	or     $0x2,%eax
80101d8d:	89 03                	mov    %eax,(%ebx)
  b->flags &= ~B_DIRTY;
80101d8f:	83 e0 fb             	and    $0xfffffffb,%eax
80101d92:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	53                   	push   %ebx
80101d98:	e8 44 1a 00 00       	call   801037e1 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101d9d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 05                	je     80101dae <ideintr+0x52>
    idestart(idequeue);
80101da9:	e8 78 fe ff ff       	call   80101c26 <idestart>

  release(&idelock);
80101dae:	83 ec 0c             	sub    $0xc,%esp
80101db1:	68 00 16 11 80       	push   $0x80111600
80101db6:	e8 69 20 00 00       	call   80103e24 <release>
80101dbb:	83 c4 10             	add    $0x10,%esp
}
80101dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dc1:	5b                   	pop    %ebx
80101dc2:	5f                   	pop    %edi
80101dc3:	5d                   	pop    %ebp
80101dc4:	c3                   	ret    
    release(&idelock);
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	68 00 16 11 80       	push   $0x80111600
80101dcd:	e8 52 20 00 00       	call   80103e24 <release>
    return;
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	eb e7                	jmp    80101dbe <ideintr+0x62>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dd7:	b8 01 00 00 00       	mov    $0x1,%eax
80101ddc:	e8 1c fe ff ff       	call   80101bfd <idewait>
80101de1:	85 c0                	test   %eax,%eax
80101de3:	78 a3                	js     80101d88 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101de5:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101de8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101ded:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101df2:	fc                   	cld    
80101df3:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101df5:	eb 91                	jmp    80101d88 <ideintr+0x2c>

80101df7 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101df7:	55                   	push   %ebp
80101df8:	89 e5                	mov    %esp,%ebp
80101dfa:	53                   	push   %ebx
80101dfb:	83 ec 10             	sub    $0x10,%esp
80101dfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e01:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e04:	50                   	push   %eax
80101e05:	e8 2b 1e 00 00       	call   80103c35 <holdingsleep>
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	74 37                	je     80101e48 <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e11:	8b 03                	mov    (%ebx),%eax
80101e13:	83 e0 06             	and    $0x6,%eax
80101e16:	83 f8 02             	cmp    $0x2,%eax
80101e19:	74 3a                	je     80101e55 <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e1b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e1f:	74 09                	je     80101e2a <iderw+0x33>
80101e21:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101e28:	74 38                	je     80101e62 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e2a:	83 ec 0c             	sub    $0xc,%esp
80101e2d:	68 00 16 11 80       	push   $0x80111600
80101e32:	e8 88 1f 00 00       	call   80103dbf <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e37:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e3e:	83 c4 10             	add    $0x10,%esp
80101e41:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101e46:	eb 2a                	jmp    80101e72 <iderw+0x7b>
    panic("iderw: buf not locked");
80101e48:	83 ec 0c             	sub    $0xc,%esp
80101e4b:	68 aa 6b 10 80       	push   $0x80106baa
80101e50:	e8 f3 e4 ff ff       	call   80100348 <panic>
    panic("iderw: nothing to do");
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	68 c0 6b 10 80       	push   $0x80106bc0
80101e5d:	e8 e6 e4 ff ff       	call   80100348 <panic>
    panic("iderw: ide disk 1 not present");
80101e62:	83 ec 0c             	sub    $0xc,%esp
80101e65:	68 d5 6b 10 80       	push   $0x80106bd5
80101e6a:	e8 d9 e4 ff ff       	call   80100348 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e6f:	8d 50 58             	lea    0x58(%eax),%edx
80101e72:	8b 02                	mov    (%edx),%eax
80101e74:	85 c0                	test   %eax,%eax
80101e76:	75 f7                	jne    80101e6f <iderw+0x78>
    ;
  *pp = b;
80101e78:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e7a:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e80:	75 1a                	jne    80101e9c <iderw+0xa5>
    idestart(b);
80101e82:	89 d8                	mov    %ebx,%eax
80101e84:	e8 9d fd ff ff       	call   80101c26 <idestart>
80101e89:	eb 11                	jmp    80101e9c <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e8b:	83 ec 08             	sub    $0x8,%esp
80101e8e:	68 00 16 11 80       	push   $0x80111600
80101e93:	53                   	push   %ebx
80101e94:	e8 e3 17 00 00       	call   8010367c <sleep>
80101e99:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101e9c:	8b 03                	mov    (%ebx),%eax
80101e9e:	83 e0 06             	and    $0x6,%eax
80101ea1:	83 f8 02             	cmp    $0x2,%eax
80101ea4:	75 e5                	jne    80101e8b <iderw+0x94>
  }


  release(&idelock);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	68 00 16 11 80       	push   $0x80111600
80101eae:	e8 71 1f 00 00       	call   80103e24 <release>
}
80101eb3:	83 c4 10             	add    $0x10,%esp
80101eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101eb9:	c9                   	leave  
80101eba:	c3                   	ret    

80101ebb <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101ebb:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101ec1:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101ec3:	a1 34 16 11 80       	mov    0x80111634,%eax
80101ec8:	8b 40 10             	mov    0x10(%eax),%eax
}
80101ecb:	c3                   	ret    

80101ecc <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101ecc:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101ed2:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101ed4:	a1 34 16 11 80       	mov    0x80111634,%eax
80101ed9:	89 50 10             	mov    %edx,0x10(%eax)
}
80101edc:	c3                   	ret    

80101edd <ioapicinit>:

void
ioapicinit(void)
{
80101edd:	55                   	push   %ebp
80101ede:	89 e5                	mov    %esp,%ebp
80101ee0:	57                   	push   %edi
80101ee1:	56                   	push   %esi
80101ee2:	53                   	push   %ebx
80101ee3:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101ee6:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101eed:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ef0:	b8 01 00 00 00       	mov    $0x1,%eax
80101ef5:	e8 c1 ff ff ff       	call   80101ebb <ioapicread>
80101efa:	c1 e8 10             	shr    $0x10,%eax
80101efd:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f00:	b8 00 00 00 00       	mov    $0x0,%eax
80101f05:	e8 b1 ff ff ff       	call   80101ebb <ioapicread>
80101f0a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f0d:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101f14:	39 c2                	cmp    %eax,%edx
80101f16:	75 07                	jne    80101f1f <ioapicinit+0x42>
{
80101f18:	bb 00 00 00 00       	mov    $0x0,%ebx
80101f1d:	eb 36                	jmp    80101f55 <ioapicinit+0x78>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f1f:	83 ec 0c             	sub    $0xc,%esp
80101f22:	68 f4 6b 10 80       	push   $0x80106bf4
80101f27:	e8 db e6 ff ff       	call   80100607 <cprintf>
80101f2c:	83 c4 10             	add    $0x10,%esp
80101f2f:	eb e7                	jmp    80101f18 <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f31:	8d 53 20             	lea    0x20(%ebx),%edx
80101f34:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f3a:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f3e:	89 f0                	mov    %esi,%eax
80101f40:	e8 87 ff ff ff       	call   80101ecc <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f45:	8d 46 01             	lea    0x1(%esi),%eax
80101f48:	ba 00 00 00 00       	mov    $0x0,%edx
80101f4d:	e8 7a ff ff ff       	call   80101ecc <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f52:	83 c3 01             	add    $0x1,%ebx
80101f55:	39 fb                	cmp    %edi,%ebx
80101f57:	7e d8                	jle    80101f31 <ioapicinit+0x54>
  }
}
80101f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5c:	5b                   	pop    %ebx
80101f5d:	5e                   	pop    %esi
80101f5e:	5f                   	pop    %edi
80101f5f:	5d                   	pop    %ebp
80101f60:	c3                   	ret    

80101f61 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101f61:	55                   	push   %ebp
80101f62:	89 e5                	mov    %esp,%ebp
80101f64:	53                   	push   %ebx
80101f65:	83 ec 04             	sub    $0x4,%esp
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101f6b:	8d 50 20             	lea    0x20(%eax),%edx
80101f6e:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101f72:	89 d8                	mov    %ebx,%eax
80101f74:	e8 53 ff ff ff       	call   80101ecc <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101f79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f7c:	c1 e2 18             	shl    $0x18,%edx
80101f7f:	8d 43 01             	lea    0x1(%ebx),%eax
80101f82:	e8 45 ff ff ff       	call   80101ecc <ioapicwrite>
}
80101f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8a:	c9                   	leave  
80101f8b:	c3                   	ret    

80101f8c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f8c:	55                   	push   %ebp
80101f8d:	89 e5                	mov    %esp,%ebp
80101f8f:	53                   	push   %ebx
80101f90:	83 ec 04             	sub    $0x4,%esp
80101f93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f96:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f9c:	75 4c                	jne    80101fea <kfree+0x5e>
80101f9e:	81 fb f0 55 11 80    	cmp    $0x801155f0,%ebx
80101fa4:	72 44                	jb     80101fea <kfree+0x5e>
80101fa6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101fac:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101fb1:	77 37                	ja     80101fea <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101fb3:	83 ec 04             	sub    $0x4,%esp
80101fb6:	68 00 10 00 00       	push   $0x1000
80101fbb:	6a 01                	push   $0x1
80101fbd:	53                   	push   %ebx
80101fbe:	e8 a8 1e 00 00       	call   80103e6b <memset>

  if(kmem.use_lock)
80101fc3:	83 c4 10             	add    $0x10,%esp
80101fc6:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fcd:	75 28                	jne    80101ff7 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101fcf:	a1 78 16 11 80       	mov    0x80111678,%eax
80101fd4:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101fd6:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101fdc:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fe3:	75 24                	jne    80102009 <kfree+0x7d>
    release(&kmem.lock);
}
80101fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fe8:	c9                   	leave  
80101fe9:	c3                   	ret    
    panic("kfree");
80101fea:	83 ec 0c             	sub    $0xc,%esp
80101fed:	68 26 6c 10 80       	push   $0x80106c26
80101ff2:	e8 51 e3 ff ff       	call   80100348 <panic>
    acquire(&kmem.lock);
80101ff7:	83 ec 0c             	sub    $0xc,%esp
80101ffa:	68 40 16 11 80       	push   $0x80111640
80101fff:	e8 bb 1d 00 00       	call   80103dbf <acquire>
80102004:	83 c4 10             	add    $0x10,%esp
80102007:	eb c6                	jmp    80101fcf <kfree+0x43>
    release(&kmem.lock);
80102009:	83 ec 0c             	sub    $0xc,%esp
8010200c:	68 40 16 11 80       	push   $0x80111640
80102011:	e8 0e 1e 00 00       	call   80103e24 <release>
80102016:	83 c4 10             	add    $0x10,%esp
}
80102019:	eb ca                	jmp    80101fe5 <kfree+0x59>

8010201b <freerange>:
{
8010201b:	55                   	push   %ebp
8010201c:	89 e5                	mov    %esp,%ebp
8010201e:	56                   	push   %esi
8010201f:	53                   	push   %ebx
80102020:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102023:	8b 45 08             	mov    0x8(%ebp),%eax
80102026:	05 ff 0f 00 00       	add    $0xfff,%eax
8010202b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102030:	eb 0e                	jmp    80102040 <freerange+0x25>
    kfree(p);
80102032:	83 ec 0c             	sub    $0xc,%esp
80102035:	50                   	push   %eax
80102036:	e8 51 ff ff ff       	call   80101f8c <kfree>
8010203b:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010203e:	89 f0                	mov    %esi,%eax
80102040:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102046:	39 de                	cmp    %ebx,%esi
80102048:	76 e8                	jbe    80102032 <freerange+0x17>
}
8010204a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010204d:	5b                   	pop    %ebx
8010204e:	5e                   	pop    %esi
8010204f:	5d                   	pop    %ebp
80102050:	c3                   	ret    

80102051 <kinit1>:
{
80102051:	55                   	push   %ebp
80102052:	89 e5                	mov    %esp,%ebp
80102054:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102057:	68 2c 6c 10 80       	push   $0x80106c2c
8010205c:	68 40 16 11 80       	push   $0x80111640
80102061:	e8 1d 1c 00 00       	call   80103c83 <initlock>
  kmem.use_lock = 0;
80102066:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
8010206d:	00 00 00 
  freerange(vstart, vend);
80102070:	83 c4 08             	add    $0x8,%esp
80102073:	ff 75 0c             	push   0xc(%ebp)
80102076:	ff 75 08             	push   0x8(%ebp)
80102079:	e8 9d ff ff ff       	call   8010201b <freerange>
}
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	c9                   	leave  
80102082:	c3                   	ret    

80102083 <kinit2>:
{
80102083:	55                   	push   %ebp
80102084:	89 e5                	mov    %esp,%ebp
80102086:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	ff 75 08             	push   0x8(%ebp)
8010208f:	e8 87 ff ff ff       	call   8010201b <freerange>
  kmem.use_lock = 1;
80102094:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010209b:	00 00 00 
}
8010209e:	83 c4 10             	add    $0x10,%esp
801020a1:	c9                   	leave  
801020a2:	c3                   	ret    

801020a3 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020a3:	55                   	push   %ebp
801020a4:	89 e5                	mov    %esp,%ebp
801020a6:	53                   	push   %ebx
801020a7:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801020aa:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020b1:	75 21                	jne    801020d4 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801020b3:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801020b9:	85 db                	test   %ebx,%ebx
801020bb:	74 07                	je     801020c4 <kalloc+0x21>
    kmem.freelist = r->next;
801020bd:	8b 03                	mov    (%ebx),%eax
801020bf:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
801020c4:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020cb:	75 19                	jne    801020e6 <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
801020cd:	89 d8                	mov    %ebx,%eax
801020cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020d2:	c9                   	leave  
801020d3:	c3                   	ret    
    acquire(&kmem.lock);
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	68 40 16 11 80       	push   $0x80111640
801020dc:	e8 de 1c 00 00       	call   80103dbf <acquire>
801020e1:	83 c4 10             	add    $0x10,%esp
801020e4:	eb cd                	jmp    801020b3 <kalloc+0x10>
    release(&kmem.lock);
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	68 40 16 11 80       	push   $0x80111640
801020ee:	e8 31 1d 00 00       	call   80103e24 <release>
801020f3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801020f6:	eb d5                	jmp    801020cd <kalloc+0x2a>

801020f8 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba 64 00 00 00       	mov    $0x64,%edx
801020fd:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801020fe:	a8 01                	test   $0x1,%al
80102100:	0f 84 b4 00 00 00    	je     801021ba <kbdgetc+0xc2>
80102106:	ba 60 00 00 00       	mov    $0x60,%edx
8010210b:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010210c:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
8010210f:	3c e0                	cmp    $0xe0,%al
80102111:	74 61                	je     80102174 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102113:	84 c0                	test   %al,%al
80102115:	78 6a                	js     80102181 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102117:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010211d:	f6 c2 40             	test   $0x40,%dl
80102120:	74 0f                	je     80102131 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102122:	83 c8 80             	or     $0xffffff80,%eax
80102125:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
80102128:	83 e2 bf             	and    $0xffffffbf,%edx
8010212b:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
80102131:	0f b6 91 60 6d 10 80 	movzbl -0x7fef92a0(%ecx),%edx
80102138:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
8010213e:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
80102144:	0f b6 81 60 6c 10 80 	movzbl -0x7fef93a0(%ecx),%eax
8010214b:	31 c2                	xor    %eax,%edx
8010214d:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102153:	89 d0                	mov    %edx,%eax
80102155:	83 e0 03             	and    $0x3,%eax
80102158:	8b 04 85 40 6c 10 80 	mov    -0x7fef93c0(,%eax,4),%eax
8010215f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102163:	f6 c2 08             	test   $0x8,%dl
80102166:	74 57                	je     801021bf <kbdgetc+0xc7>
    if('a' <= c && c <= 'z')
80102168:	8d 50 9f             	lea    -0x61(%eax),%edx
8010216b:	83 fa 19             	cmp    $0x19,%edx
8010216e:	77 3e                	ja     801021ae <kbdgetc+0xb6>
      c += 'A' - 'a';
80102170:	83 e8 20             	sub    $0x20,%eax
80102173:	c3                   	ret    
    shift |= E0ESC;
80102174:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
8010217b:	b8 00 00 00 00       	mov    $0x0,%eax
80102180:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102181:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
80102187:	f6 c2 40             	test   $0x40,%dl
8010218a:	75 05                	jne    80102191 <kbdgetc+0x99>
8010218c:	89 c1                	mov    %eax,%ecx
8010218e:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102191:	0f b6 81 60 6d 10 80 	movzbl -0x7fef92a0(%ecx),%eax
80102198:	83 c8 40             	or     $0x40,%eax
8010219b:	0f b6 c0             	movzbl %al,%eax
8010219e:	f7 d0                	not    %eax
801021a0:	21 c2                	and    %eax,%edx
801021a2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
801021a8:	b8 00 00 00 00       	mov    $0x0,%eax
801021ad:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
801021ae:	8d 50 bf             	lea    -0x41(%eax),%edx
801021b1:	83 fa 19             	cmp    $0x19,%edx
801021b4:	77 09                	ja     801021bf <kbdgetc+0xc7>
      c += 'a' - 'A';
801021b6:	83 c0 20             	add    $0x20,%eax
  }
  return c;
801021b9:	c3                   	ret    
    return -1;
801021ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801021bf:	c3                   	ret    

801021c0 <kbdintr>:

void
kbdintr(void)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801021c6:	68 f8 20 10 80       	push   $0x801020f8
801021cb:	e8 63 e5 ff ff       	call   80100733 <consoleintr>
}
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	c9                   	leave  
801021d4:	c3                   	ret    

801021d5 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801021d5:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
801021db:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801021de:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801021e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801021e5:	8b 40 20             	mov    0x20(%eax),%eax
}
801021e8:	c3                   	ret    

801021e9 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e9:	ba 70 00 00 00       	mov    $0x70,%edx
801021ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ef:	ba 71 00 00 00       	mov    $0x71,%edx
801021f4:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801021f5:	0f b6 c0             	movzbl %al,%eax
}
801021f8:	c3                   	ret    

801021f9 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801021f9:	55                   	push   %ebp
801021fa:	89 e5                	mov    %esp,%ebp
801021fc:	53                   	push   %ebx
801021fd:	83 ec 04             	sub    $0x4,%esp
80102200:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102202:	b8 00 00 00 00       	mov    $0x0,%eax
80102207:	e8 dd ff ff ff       	call   801021e9 <cmos_read>
8010220c:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010220e:	b8 02 00 00 00       	mov    $0x2,%eax
80102213:	e8 d1 ff ff ff       	call   801021e9 <cmos_read>
80102218:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010221b:	b8 04 00 00 00       	mov    $0x4,%eax
80102220:	e8 c4 ff ff ff       	call   801021e9 <cmos_read>
80102225:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102228:	b8 07 00 00 00       	mov    $0x7,%eax
8010222d:	e8 b7 ff ff ff       	call   801021e9 <cmos_read>
80102232:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102235:	b8 08 00 00 00       	mov    $0x8,%eax
8010223a:	e8 aa ff ff ff       	call   801021e9 <cmos_read>
8010223f:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102242:	b8 09 00 00 00       	mov    $0x9,%eax
80102247:	e8 9d ff ff ff       	call   801021e9 <cmos_read>
8010224c:	89 43 14             	mov    %eax,0x14(%ebx)
}
8010224f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102252:	c9                   	leave  
80102253:	c3                   	ret    

80102254 <lapicinit>:
  if(!lapic)
80102254:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010225b:	0f 84 fe 00 00 00    	je     8010235f <lapicinit+0x10b>
{
80102261:	55                   	push   %ebp
80102262:	89 e5                	mov    %esp,%ebp
80102264:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102267:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010226c:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102271:	e8 5f ff ff ff       	call   801021d5 <lapicw>
  lapicw(TDCR, X1);
80102276:	ba 0b 00 00 00       	mov    $0xb,%edx
8010227b:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102280:	e8 50 ff ff ff       	call   801021d5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102285:	ba 20 00 02 00       	mov    $0x20020,%edx
8010228a:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010228f:	e8 41 ff ff ff       	call   801021d5 <lapicw>
  lapicw(TICR, 10000000);
80102294:	ba 80 96 98 00       	mov    $0x989680,%edx
80102299:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010229e:	e8 32 ff ff ff       	call   801021d5 <lapicw>
  lapicw(LINT0, MASKED);
801022a3:	ba 00 00 01 00       	mov    $0x10000,%edx
801022a8:	b8 d4 00 00 00       	mov    $0xd4,%eax
801022ad:	e8 23 ff ff ff       	call   801021d5 <lapicw>
  lapicw(LINT1, MASKED);
801022b2:	ba 00 00 01 00       	mov    $0x10000,%edx
801022b7:	b8 d8 00 00 00       	mov    $0xd8,%eax
801022bc:	e8 14 ff ff ff       	call   801021d5 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801022c1:	a1 80 16 11 80       	mov    0x80111680,%eax
801022c6:	8b 40 30             	mov    0x30(%eax),%eax
801022c9:	c1 e8 10             	shr    $0x10,%eax
801022cc:	a8 fc                	test   $0xfc,%al
801022ce:	75 7b                	jne    8010234b <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801022d0:	ba 33 00 00 00       	mov    $0x33,%edx
801022d5:	b8 dc 00 00 00       	mov    $0xdc,%eax
801022da:	e8 f6 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ESR, 0);
801022df:	ba 00 00 00 00       	mov    $0x0,%edx
801022e4:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022e9:	e8 e7 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ESR, 0);
801022ee:	ba 00 00 00 00       	mov    $0x0,%edx
801022f3:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022f8:	e8 d8 fe ff ff       	call   801021d5 <lapicw>
  lapicw(EOI, 0);
801022fd:	ba 00 00 00 00       	mov    $0x0,%edx
80102302:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102307:	e8 c9 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ICRHI, 0);
8010230c:	ba 00 00 00 00       	mov    $0x0,%edx
80102311:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102316:	e8 ba fe ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010231b:	ba 00 85 08 00       	mov    $0x88500,%edx
80102320:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102325:	e8 ab fe ff ff       	call   801021d5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010232a:	a1 80 16 11 80       	mov    0x80111680,%eax
8010232f:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102335:	f6 c4 10             	test   $0x10,%ah
80102338:	75 f0                	jne    8010232a <lapicinit+0xd6>
  lapicw(TPR, 0);
8010233a:	ba 00 00 00 00       	mov    $0x0,%edx
8010233f:	b8 20 00 00 00       	mov    $0x20,%eax
80102344:	e8 8c fe ff ff       	call   801021d5 <lapicw>
}
80102349:	c9                   	leave  
8010234a:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010234b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102350:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102355:	e8 7b fe ff ff       	call   801021d5 <lapicw>
8010235a:	e9 71 ff ff ff       	jmp    801022d0 <lapicinit+0x7c>
8010235f:	c3                   	ret    

80102360 <lapicid>:
  if (!lapic)
80102360:	a1 80 16 11 80       	mov    0x80111680,%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	74 07                	je     80102370 <lapicid+0x10>
  return lapic[ID] >> 24;
80102369:	8b 40 20             	mov    0x20(%eax),%eax
8010236c:	c1 e8 18             	shr    $0x18,%eax
8010236f:	c3                   	ret    
    return 0;
80102370:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102375:	c3                   	ret    

80102376 <lapiceoi>:
  if(lapic)
80102376:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010237d:	74 17                	je     80102396 <lapiceoi+0x20>
{
8010237f:	55                   	push   %ebp
80102380:	89 e5                	mov    %esp,%ebp
80102382:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102385:	ba 00 00 00 00       	mov    $0x0,%edx
8010238a:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010238f:	e8 41 fe ff ff       	call   801021d5 <lapicw>
}
80102394:	c9                   	leave  
80102395:	c3                   	ret    
80102396:	c3                   	ret    

80102397 <microdelay>:
}
80102397:	c3                   	ret    

80102398 <lapicstartap>:
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	57                   	push   %edi
8010239c:	56                   	push   %esi
8010239d:	53                   	push   %ebx
8010239e:	83 ec 0c             	sub    $0xc,%esp
801023a1:	8b 75 08             	mov    0x8(%ebp),%esi
801023a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a7:	b8 0f 00 00 00       	mov    $0xf,%eax
801023ac:	ba 70 00 00 00       	mov    $0x70,%edx
801023b1:	ee                   	out    %al,(%dx)
801023b2:	b8 0a 00 00 00       	mov    $0xa,%eax
801023b7:	ba 71 00 00 00       	mov    $0x71,%edx
801023bc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801023bd:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801023c4:	00 00 
  wrv[1] = addr >> 4;
801023c6:	89 f8                	mov    %edi,%eax
801023c8:	c1 e8 04             	shr    $0x4,%eax
801023cb:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801023d1:	c1 e6 18             	shl    $0x18,%esi
801023d4:	89 f2                	mov    %esi,%edx
801023d6:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023db:	e8 f5 fd ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801023e0:	ba 00 c5 00 00       	mov    $0xc500,%edx
801023e5:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023ea:	e8 e6 fd ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801023ef:	ba 00 85 00 00       	mov    $0x8500,%edx
801023f4:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023f9:	e8 d7 fd ff ff       	call   801021d5 <lapicw>
  for(i = 0; i < 2; i++){
801023fe:	bb 00 00 00 00       	mov    $0x0,%ebx
80102403:	eb 21                	jmp    80102426 <lapicstartap+0x8e>
    lapicw(ICRHI, apicid<<24);
80102405:	89 f2                	mov    %esi,%edx
80102407:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010240c:	e8 c4 fd ff ff       	call   801021d5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102411:	89 fa                	mov    %edi,%edx
80102413:	c1 ea 0c             	shr    $0xc,%edx
80102416:	80 ce 06             	or     $0x6,%dh
80102419:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241e:	e8 b2 fd ff ff       	call   801021d5 <lapicw>
  for(i = 0; i < 2; i++){
80102423:	83 c3 01             	add    $0x1,%ebx
80102426:	83 fb 01             	cmp    $0x1,%ebx
80102429:	7e da                	jle    80102405 <lapicstartap+0x6d>
}
8010242b:	83 c4 0c             	add    $0xc,%esp
8010242e:	5b                   	pop    %ebx
8010242f:	5e                   	pop    %esi
80102430:	5f                   	pop    %edi
80102431:	5d                   	pop    %ebp
80102432:	c3                   	ret    

80102433 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102433:	55                   	push   %ebp
80102434:	89 e5                	mov    %esp,%ebp
80102436:	57                   	push   %edi
80102437:	56                   	push   %esi
80102438:	53                   	push   %ebx
80102439:	83 ec 3c             	sub    $0x3c,%esp
8010243c:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010243f:	b8 0b 00 00 00       	mov    $0xb,%eax
80102444:	e8 a0 fd ff ff       	call   801021e9 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102449:	83 e0 04             	and    $0x4,%eax
8010244c:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010244e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102451:	e8 a3 fd ff ff       	call   801021f9 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102456:	b8 0a 00 00 00       	mov    $0xa,%eax
8010245b:	e8 89 fd ff ff       	call   801021e9 <cmos_read>
80102460:	a8 80                	test   $0x80,%al
80102462:	75 ea                	jne    8010244e <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
80102464:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102467:	89 d8                	mov    %ebx,%eax
80102469:	e8 8b fd ff ff       	call   801021f9 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010246e:	83 ec 04             	sub    $0x4,%esp
80102471:	6a 18                	push   $0x18
80102473:	53                   	push   %ebx
80102474:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102477:	50                   	push   %eax
80102478:	e8 31 1a 00 00       	call   80103eae <memcmp>
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	85 c0                	test   %eax,%eax
80102482:	75 ca                	jne    8010244e <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
80102484:	85 ff                	test   %edi,%edi
80102486:	75 78                	jne    80102500 <cmostime+0xcd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102488:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010248b:	89 c2                	mov    %eax,%edx
8010248d:	c1 ea 04             	shr    $0x4,%edx
80102490:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102493:	83 e0 0f             	and    $0xf,%eax
80102496:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102499:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010249c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010249f:	89 c2                	mov    %eax,%edx
801024a1:	c1 ea 04             	shr    $0x4,%edx
801024a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024a7:	83 e0 0f             	and    $0xf,%eax
801024aa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801024b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801024b3:	89 c2                	mov    %eax,%edx
801024b5:	c1 ea 04             	shr    $0x4,%edx
801024b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024bb:	83 e0 0f             	and    $0xf,%eax
801024be:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801024c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801024c7:	89 c2                	mov    %eax,%edx
801024c9:	c1 ea 04             	shr    $0x4,%edx
801024cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024cf:	83 e0 0f             	and    $0xf,%eax
801024d2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801024d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801024db:	89 c2                	mov    %eax,%edx
801024dd:	c1 ea 04             	shr    $0x4,%edx
801024e0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024e3:	83 e0 0f             	and    $0xf,%eax
801024e6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801024ef:	89 c2                	mov    %eax,%edx
801024f1:	c1 ea 04             	shr    $0x4,%edx
801024f4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024f7:	83 e0 0f             	and    $0xf,%eax
801024fa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102500:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102503:	89 06                	mov    %eax,(%esi)
80102505:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102508:	89 46 04             	mov    %eax,0x4(%esi)
8010250b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010250e:	89 46 08             	mov    %eax,0x8(%esi)
80102511:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102514:	89 46 0c             	mov    %eax,0xc(%esi)
80102517:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010251a:	89 46 10             	mov    %eax,0x10(%esi)
8010251d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102520:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102523:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010252a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252d:	5b                   	pop    %ebx
8010252e:	5e                   	pop    %esi
8010252f:	5f                   	pop    %edi
80102530:	5d                   	pop    %ebp
80102531:	c3                   	ret    

80102532 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102532:	55                   	push   %ebp
80102533:	89 e5                	mov    %esp,%ebp
80102535:	53                   	push   %ebx
80102536:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102539:	ff 35 d4 16 11 80    	push   0x801116d4
8010253f:	ff 35 e4 16 11 80    	push   0x801116e4
80102545:	e8 22 dc ff ff       	call   8010016c <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
8010254a:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010254d:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	ba 00 00 00 00       	mov    $0x0,%edx
8010255b:	eb 0e                	jmp    8010256b <read_head+0x39>
    log.lh.block[i] = lh->block[i];
8010255d:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102561:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102568:	83 c2 01             	add    $0x1,%edx
8010256b:	39 d3                	cmp    %edx,%ebx
8010256d:	7f ee                	jg     8010255d <read_head+0x2b>
  }
  brelse(buf);
8010256f:	83 ec 0c             	sub    $0xc,%esp
80102572:	50                   	push   %eax
80102573:	e8 5d dc ff ff       	call   801001d5 <brelse>
}
80102578:	83 c4 10             	add    $0x10,%esp
8010257b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257e:	c9                   	leave  
8010257f:	c3                   	ret    

80102580 <install_trans>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	57                   	push   %edi
80102584:	56                   	push   %esi
80102585:	53                   	push   %ebx
80102586:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102589:	be 00 00 00 00       	mov    $0x0,%esi
8010258e:	eb 66                	jmp    801025f6 <install_trans+0x76>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102590:	89 f0                	mov    %esi,%eax
80102592:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102598:	83 c0 01             	add    $0x1,%eax
8010259b:	83 ec 08             	sub    $0x8,%esp
8010259e:	50                   	push   %eax
8010259f:	ff 35 e4 16 11 80    	push   0x801116e4
801025a5:	e8 c2 db ff ff       	call   8010016c <bread>
801025aa:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801025ac:	83 c4 08             	add    $0x8,%esp
801025af:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
801025b6:	ff 35 e4 16 11 80    	push   0x801116e4
801025bc:	e8 ab db ff ff       	call   8010016c <bread>
801025c1:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801025c3:	8d 57 5c             	lea    0x5c(%edi),%edx
801025c6:	8d 40 5c             	lea    0x5c(%eax),%eax
801025c9:	83 c4 0c             	add    $0xc,%esp
801025cc:	68 00 02 00 00       	push   $0x200
801025d1:	52                   	push   %edx
801025d2:	50                   	push   %eax
801025d3:	e8 0b 19 00 00       	call   80103ee3 <memmove>
    bwrite(dbuf);  // write dst to disk
801025d8:	89 1c 24             	mov    %ebx,(%esp)
801025db:	e8 ba db ff ff       	call   8010019a <bwrite>
    brelse(lbuf);
801025e0:	89 3c 24             	mov    %edi,(%esp)
801025e3:	e8 ed db ff ff       	call   801001d5 <brelse>
    brelse(dbuf);
801025e8:	89 1c 24             	mov    %ebx,(%esp)
801025eb:	e8 e5 db ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801025f0:	83 c6 01             	add    $0x1,%esi
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801025fc:	7f 92                	jg     80102590 <install_trans+0x10>
}
801025fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5f                   	pop    %edi
80102604:	5d                   	pop    %ebp
80102605:	c3                   	ret    

80102606 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102606:	55                   	push   %ebp
80102607:	89 e5                	mov    %esp,%ebp
80102609:	53                   	push   %ebx
8010260a:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010260d:	ff 35 d4 16 11 80    	push   0x801116d4
80102613:	ff 35 e4 16 11 80    	push   0x801116e4
80102619:	e8 4e db ff ff       	call   8010016c <bread>
8010261e:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102620:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102626:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102629:	83 c4 10             	add    $0x10,%esp
8010262c:	b8 00 00 00 00       	mov    $0x0,%eax
80102631:	eb 0e                	jmp    80102641 <write_head+0x3b>
    hb->block[i] = log.lh.block[i];
80102633:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
8010263a:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
8010263e:	83 c0 01             	add    $0x1,%eax
80102641:	39 c1                	cmp    %eax,%ecx
80102643:	7f ee                	jg     80102633 <write_head+0x2d>
  }
  bwrite(buf);
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	53                   	push   %ebx
80102649:	e8 4c db ff ff       	call   8010019a <bwrite>
  brelse(buf);
8010264e:	89 1c 24             	mov    %ebx,(%esp)
80102651:	e8 7f db ff ff       	call   801001d5 <brelse>
}
80102656:	83 c4 10             	add    $0x10,%esp
80102659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010265c:	c9                   	leave  
8010265d:	c3                   	ret    

8010265e <recover_from_log>:

static void
recover_from_log(void)
{
8010265e:	55                   	push   %ebp
8010265f:	89 e5                	mov    %esp,%ebp
80102661:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102664:	e8 c9 fe ff ff       	call   80102532 <read_head>
  install_trans(); // if committed, copy from log to disk
80102669:	e8 12 ff ff ff       	call   80102580 <install_trans>
  log.lh.n = 0;
8010266e:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102675:	00 00 00 
  write_head(); // clear the log
80102678:	e8 89 ff ff ff       	call   80102606 <write_head>
}
8010267d:	c9                   	leave  
8010267e:	c3                   	ret    

8010267f <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010267f:	55                   	push   %ebp
80102680:	89 e5                	mov    %esp,%ebp
80102682:	57                   	push   %edi
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
80102685:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102688:	be 00 00 00 00       	mov    $0x0,%esi
8010268d:	eb 66                	jmp    801026f5 <write_log+0x76>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010268f:	89 f0                	mov    %esi,%eax
80102691:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102697:	83 c0 01             	add    $0x1,%eax
8010269a:	83 ec 08             	sub    $0x8,%esp
8010269d:	50                   	push   %eax
8010269e:	ff 35 e4 16 11 80    	push   0x801116e4
801026a4:	e8 c3 da ff ff       	call   8010016c <bread>
801026a9:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801026ab:	83 c4 08             	add    $0x8,%esp
801026ae:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
801026b5:	ff 35 e4 16 11 80    	push   0x801116e4
801026bb:	e8 ac da ff ff       	call   8010016c <bread>
801026c0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801026c2:	8d 50 5c             	lea    0x5c(%eax),%edx
801026c5:	8d 43 5c             	lea    0x5c(%ebx),%eax
801026c8:	83 c4 0c             	add    $0xc,%esp
801026cb:	68 00 02 00 00       	push   $0x200
801026d0:	52                   	push   %edx
801026d1:	50                   	push   %eax
801026d2:	e8 0c 18 00 00       	call   80103ee3 <memmove>
    bwrite(to);  // write the log
801026d7:	89 1c 24             	mov    %ebx,(%esp)
801026da:	e8 bb da ff ff       	call   8010019a <bwrite>
    brelse(from);
801026df:	89 3c 24             	mov    %edi,(%esp)
801026e2:	e8 ee da ff ff       	call   801001d5 <brelse>
    brelse(to);
801026e7:	89 1c 24             	mov    %ebx,(%esp)
801026ea:	e8 e6 da ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026ef:	83 c6 01             	add    $0x1,%esi
801026f2:	83 c4 10             	add    $0x10,%esp
801026f5:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801026fb:	7f 92                	jg     8010268f <write_log+0x10>
  }
}
801026fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102700:	5b                   	pop    %ebx
80102701:	5e                   	pop    %esi
80102702:	5f                   	pop    %edi
80102703:	5d                   	pop    %ebp
80102704:	c3                   	ret    

80102705 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102705:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
8010270c:	7f 01                	jg     8010270f <commit+0xa>
8010270e:	c3                   	ret    
{
8010270f:	55                   	push   %ebp
80102710:	89 e5                	mov    %esp,%ebp
80102712:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102715:	e8 65 ff ff ff       	call   8010267f <write_log>
    write_head();    // Write header to disk -- the real commit
8010271a:	e8 e7 fe ff ff       	call   80102606 <write_head>
    install_trans(); // Now install writes to home locations
8010271f:	e8 5c fe ff ff       	call   80102580 <install_trans>
    log.lh.n = 0;
80102724:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010272b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010272e:	e8 d3 fe ff ff       	call   80102606 <write_head>
  }
}
80102733:	c9                   	leave  
80102734:	c3                   	ret    

80102735 <initlog>:
{
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
80102738:	53                   	push   %ebx
80102739:	83 ec 2c             	sub    $0x2c,%esp
8010273c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010273f:	68 60 6e 10 80       	push   $0x80106e60
80102744:	68 a0 16 11 80       	push   $0x801116a0
80102749:	e8 35 15 00 00       	call   80103c83 <initlock>
  readsb(dev, &sb);
8010274e:	83 c4 08             	add    $0x8,%esp
80102751:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102754:	50                   	push   %eax
80102755:	53                   	push   %ebx
80102756:	e8 4b eb ff ff       	call   801012a6 <readsb>
  log.start = sb.logstart;
8010275b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010275e:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102763:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102766:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
8010276b:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
80102771:	e8 e8 fe ff ff       	call   8010265e <recover_from_log>
}
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277c:	c9                   	leave  
8010277d:	c3                   	ret    

8010277e <begin_op>:
{
8010277e:	55                   	push   %ebp
8010277f:	89 e5                	mov    %esp,%ebp
80102781:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102784:	68 a0 16 11 80       	push   $0x801116a0
80102789:	e8 31 16 00 00       	call   80103dbf <acquire>
8010278e:	83 c4 10             	add    $0x10,%esp
80102791:	eb 15                	jmp    801027a8 <begin_op+0x2a>
      sleep(&log, &log.lock);
80102793:	83 ec 08             	sub    $0x8,%esp
80102796:	68 a0 16 11 80       	push   $0x801116a0
8010279b:	68 a0 16 11 80       	push   $0x801116a0
801027a0:	e8 d7 0e 00 00       	call   8010367c <sleep>
801027a5:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027a8:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
801027af:	75 e2                	jne    80102793 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027b1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801027b6:	83 c0 01             	add    $0x1,%eax
801027b9:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027bc:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
801027bf:	03 15 e8 16 11 80    	add    0x801116e8,%edx
801027c5:	83 fa 1e             	cmp    $0x1e,%edx
801027c8:	7e 17                	jle    801027e1 <begin_op+0x63>
      sleep(&log, &log.lock);
801027ca:	83 ec 08             	sub    $0x8,%esp
801027cd:	68 a0 16 11 80       	push   $0x801116a0
801027d2:	68 a0 16 11 80       	push   $0x801116a0
801027d7:	e8 a0 0e 00 00       	call   8010367c <sleep>
801027dc:	83 c4 10             	add    $0x10,%esp
801027df:	eb c7                	jmp    801027a8 <begin_op+0x2a>
      log.outstanding += 1;
801027e1:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	68 a0 16 11 80       	push   $0x801116a0
801027ee:	e8 31 16 00 00       	call   80103e24 <release>
}
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	c9                   	leave  
801027f7:	c3                   	ret    

801027f8 <end_op>:
{
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	53                   	push   %ebx
801027fc:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027ff:	68 a0 16 11 80       	push   $0x801116a0
80102804:	e8 b6 15 00 00       	call   80103dbf <acquire>
  log.outstanding -= 1;
80102809:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010280e:	83 e8 01             	sub    $0x1,%eax
80102811:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
80102816:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
8010281c:	83 c4 10             	add    $0x10,%esp
8010281f:	85 db                	test   %ebx,%ebx
80102821:	75 2c                	jne    8010284f <end_op+0x57>
  if(log.outstanding == 0){
80102823:	85 c0                	test   %eax,%eax
80102825:	75 35                	jne    8010285c <end_op+0x64>
    log.committing = 1;
80102827:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
8010282e:	00 00 00 
    do_commit = 1;
80102831:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102836:	83 ec 0c             	sub    $0xc,%esp
80102839:	68 a0 16 11 80       	push   $0x801116a0
8010283e:	e8 e1 15 00 00       	call   80103e24 <release>
  if(do_commit){
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	85 db                	test   %ebx,%ebx
80102848:	75 24                	jne    8010286e <end_op+0x76>
}
8010284a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284d:	c9                   	leave  
8010284e:	c3                   	ret    
    panic("log.committing");
8010284f:	83 ec 0c             	sub    $0xc,%esp
80102852:	68 64 6e 10 80       	push   $0x80106e64
80102857:	e8 ec da ff ff       	call   80100348 <panic>
    wakeup(&log);
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 a0 16 11 80       	push   $0x801116a0
80102864:	e8 78 0f 00 00       	call   801037e1 <wakeup>
80102869:	83 c4 10             	add    $0x10,%esp
8010286c:	eb c8                	jmp    80102836 <end_op+0x3e>
    commit();
8010286e:	e8 92 fe ff ff       	call   80102705 <commit>
    acquire(&log.lock);
80102873:	83 ec 0c             	sub    $0xc,%esp
80102876:	68 a0 16 11 80       	push   $0x801116a0
8010287b:	e8 3f 15 00 00       	call   80103dbf <acquire>
    log.committing = 0;
80102880:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102887:	00 00 00 
    wakeup(&log);
8010288a:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102891:	e8 4b 0f 00 00       	call   801037e1 <wakeup>
    release(&log.lock);
80102896:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010289d:	e8 82 15 00 00       	call   80103e24 <release>
801028a2:	83 c4 10             	add    $0x10,%esp
}
801028a5:	eb a3                	jmp    8010284a <end_op+0x52>

801028a7 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801028a7:	55                   	push   %ebp
801028a8:	89 e5                	mov    %esp,%ebp
801028aa:	53                   	push   %ebx
801028ab:	83 ec 04             	sub    $0x4,%esp
801028ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801028b1:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801028b7:	83 fa 1d             	cmp    $0x1d,%edx
801028ba:	7f 2c                	jg     801028e8 <log_write+0x41>
801028bc:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801028c1:	83 e8 01             	sub    $0x1,%eax
801028c4:	39 c2                	cmp    %eax,%edx
801028c6:	7d 20                	jge    801028e8 <log_write+0x41>
    panic("too big a transaction");
  if (log.outstanding < 1)
801028c8:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
801028cf:	7e 24                	jle    801028f5 <log_write+0x4e>
    panic("log_write outside of trans");

  acquire(&log.lock);
801028d1:	83 ec 0c             	sub    $0xc,%esp
801028d4:	68 a0 16 11 80       	push   $0x801116a0
801028d9:	e8 e1 14 00 00       	call   80103dbf <acquire>
  for (i = 0; i < log.lh.n; i++) {
801028de:	83 c4 10             	add    $0x10,%esp
801028e1:	b8 00 00 00 00       	mov    $0x0,%eax
801028e6:	eb 1d                	jmp    80102905 <log_write+0x5e>
    panic("too big a transaction");
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 73 6e 10 80       	push   $0x80106e73
801028f0:	e8 53 da ff ff       	call   80100348 <panic>
    panic("log_write outside of trans");
801028f5:	83 ec 0c             	sub    $0xc,%esp
801028f8:	68 89 6e 10 80       	push   $0x80106e89
801028fd:	e8 46 da ff ff       	call   80100348 <panic>
  for (i = 0; i < log.lh.n; i++) {
80102902:	83 c0 01             	add    $0x1,%eax
80102905:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
8010290b:	39 c2                	cmp    %eax,%edx
8010290d:	7e 0c                	jle    8010291b <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010290f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102912:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102919:	75 e7                	jne    80102902 <log_write+0x5b>
      break;
  }
  log.lh.block[i] = b->blockno;
8010291b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010291e:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102925:	39 c2                	cmp    %eax,%edx
80102927:	74 18                	je     80102941 <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102929:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
8010292c:	83 ec 0c             	sub    $0xc,%esp
8010292f:	68 a0 16 11 80       	push   $0x801116a0
80102934:	e8 eb 14 00 00       	call   80103e24 <release>
}
80102939:	83 c4 10             	add    $0x10,%esp
8010293c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010293f:	c9                   	leave  
80102940:	c3                   	ret    
    log.lh.n++;
80102941:	83 c2 01             	add    $0x1,%edx
80102944:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
8010294a:	eb dd                	jmp    80102929 <log_write+0x82>

8010294c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010294c:	55                   	push   %ebp
8010294d:	89 e5                	mov    %esp,%ebp
8010294f:	53                   	push   %ebx
80102950:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102953:	68 8a 00 00 00       	push   $0x8a
80102958:	68 8c a4 10 80       	push   $0x8010a48c
8010295d:	68 00 70 00 80       	push   $0x80007000
80102962:	e8 7c 15 00 00       	call   80103ee3 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102967:	83 c4 10             	add    $0x10,%esp
8010296a:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
8010296f:	eb 06                	jmp    80102977 <startothers+0x2b>
80102971:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102977:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
8010297e:	00 00 00 
80102981:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102986:	39 d8                	cmp    %ebx,%eax
80102988:	76 4c                	jbe    801029d6 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
8010298a:	e8 af 07 00 00       	call   8010313e <mycpu>
8010298f:	39 c3                	cmp    %eax,%ebx
80102991:	74 de                	je     80102971 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102993:	e8 0b f7 ff ff       	call   801020a3 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102998:	05 00 10 00 00       	add    $0x1000,%eax
8010299d:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029a2:	c7 05 f8 6f 00 80 1a 	movl   $0x80102a1a,0x80006ff8
801029a9:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029ac:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029b3:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029b6:	83 ec 08             	sub    $0x8,%esp
801029b9:	68 00 70 00 00       	push   $0x7000
801029be:	0f b6 03             	movzbl (%ebx),%eax
801029c1:	50                   	push   %eax
801029c2:	e8 d1 f9 ff ff       	call   80102398 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801029c7:	83 c4 10             	add    $0x10,%esp
801029ca:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801029d0:	85 c0                	test   %eax,%eax
801029d2:	74 f6                	je     801029ca <startothers+0x7e>
801029d4:	eb 9b                	jmp    80102971 <startothers+0x25>
      ;
  }
}
801029d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d9:	c9                   	leave  
801029da:	c3                   	ret    

801029db <mpmain>:
{
801029db:	55                   	push   %ebp
801029dc:	89 e5                	mov    %esp,%ebp
801029de:	53                   	push   %ebx
801029df:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801029e2:	e8 b3 07 00 00       	call   8010319a <cpuid>
801029e7:	89 c3                	mov    %eax,%ebx
801029e9:	e8 ac 07 00 00       	call   8010319a <cpuid>
801029ee:	83 ec 04             	sub    $0x4,%esp
801029f1:	53                   	push   %ebx
801029f2:	50                   	push   %eax
801029f3:	68 a4 6e 10 80       	push   $0x80106ea4
801029f8:	e8 0a dc ff ff       	call   80100607 <cprintf>
  idtinit();       // load idt register
801029fd:	e8 6e 27 00 00       	call   80105170 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a02:	e8 37 07 00 00       	call   8010313e <mycpu>
80102a07:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a09:	b8 01 00 00 00       	mov    $0x1,%eax
80102a0e:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a15:	e8 18 0a 00 00       	call   80103432 <scheduler>

80102a1a <mpenter>:
{
80102a1a:	55                   	push   %ebp
80102a1b:	89 e5                	mov    %esp,%ebp
80102a1d:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a20:	e8 77 38 00 00       	call   8010629c <switchkvm>
  seginit();
80102a25:	e8 fd 35 00 00       	call   80106027 <seginit>
  lapicinit();
80102a2a:	e8 25 f8 ff ff       	call   80102254 <lapicinit>
  mpmain();
80102a2f:	e8 a7 ff ff ff       	call   801029db <mpmain>

80102a34 <main>:
{
80102a34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a38:	83 e4 f0             	and    $0xfffffff0,%esp
80102a3b:	ff 71 fc             	push   -0x4(%ecx)
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	51                   	push   %ecx
80102a42:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a45:	68 00 00 40 80       	push   $0x80400000
80102a4a:	68 f0 55 11 80       	push   $0x801155f0
80102a4f:	e8 fd f5 ff ff       	call   80102051 <kinit1>
  kvmalloc();      // kernel page table
80102a54:	e8 0f 3d 00 00       	call   80106768 <kvmalloc>
  mpinit();        // detect other processors
80102a59:	e8 c1 01 00 00       	call   80102c1f <mpinit>
  lapicinit();     // interrupt controller
80102a5e:	e8 f1 f7 ff ff       	call   80102254 <lapicinit>
  seginit();       // segment descriptors
80102a63:	e8 bf 35 00 00       	call   80106027 <seginit>
  picinit();       // disable pic
80102a68:	e8 88 02 00 00       	call   80102cf5 <picinit>
  ioapicinit();    // another interrupt controller
80102a6d:	e8 6b f4 ff ff       	call   80101edd <ioapicinit>
  consoleinit();   // console hardware
80102a72:	e8 13 de ff ff       	call   8010088a <consoleinit>
  uartinit();      // serial port
80102a77:	e8 9b 29 00 00       	call   80105417 <uartinit>
  pinit();         // process table
80102a7c:	e8 a3 06 00 00       	call   80103124 <pinit>
  tvinit();        // trap vectors
80102a81:	e8 e5 25 00 00       	call   8010506b <tvinit>
  binit();         // buffer cache
80102a86:	e8 69 d6 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102a8b:	e8 73 e1 ff ff       	call   80100c03 <fileinit>
  ideinit();       // disk 
80102a90:	e8 54 f2 ff ff       	call   80101ce9 <ideinit>
  startothers();   // start other processors
80102a95:	e8 b2 fe ff ff       	call   8010294c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102a9a:	83 c4 08             	add    $0x8,%esp
80102a9d:	68 00 00 00 8e       	push   $0x8e000000
80102aa2:	68 00 00 40 80       	push   $0x80400000
80102aa7:	e8 d7 f5 ff ff       	call   80102083 <kinit2>
  userinit();      // first user process
80102aac:	e8 27 07 00 00       	call   801031d8 <userinit>
  mpmain();        // finish this processor's setup
80102ab1:	e8 25 ff ff ff       	call   801029db <mpmain>

80102ab6 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102ab6:	55                   	push   %ebp
80102ab7:	89 e5                	mov    %esp,%ebp
80102ab9:	56                   	push   %esi
80102aba:	53                   	push   %ebx
80102abb:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102abd:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102ac2:	b9 00 00 00 00       	mov    $0x0,%ecx
80102ac7:	eb 09                	jmp    80102ad2 <sum+0x1c>
    sum += addr[i];
80102ac9:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102acd:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102acf:	83 c1 01             	add    $0x1,%ecx
80102ad2:	39 d1                	cmp    %edx,%ecx
80102ad4:	7c f3                	jl     80102ac9 <sum+0x13>
  return sum;
}
80102ad6:	5b                   	pop    %ebx
80102ad7:	5e                   	pop    %esi
80102ad8:	5d                   	pop    %ebp
80102ad9:	c3                   	ret    

80102ada <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	56                   	push   %esi
80102ade:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102adf:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102ae5:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102ae7:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102ae9:	eb 03                	jmp    80102aee <mpsearch1+0x14>
80102aeb:	83 c3 10             	add    $0x10,%ebx
80102aee:	39 f3                	cmp    %esi,%ebx
80102af0:	73 29                	jae    80102b1b <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102af2:	83 ec 04             	sub    $0x4,%esp
80102af5:	6a 04                	push   $0x4
80102af7:	68 b8 6e 10 80       	push   $0x80106eb8
80102afc:	53                   	push   %ebx
80102afd:	e8 ac 13 00 00       	call   80103eae <memcmp>
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	85 c0                	test   %eax,%eax
80102b07:	75 e2                	jne    80102aeb <mpsearch1+0x11>
80102b09:	ba 10 00 00 00       	mov    $0x10,%edx
80102b0e:	89 d8                	mov    %ebx,%eax
80102b10:	e8 a1 ff ff ff       	call   80102ab6 <sum>
80102b15:	84 c0                	test   %al,%al
80102b17:	75 d2                	jne    80102aeb <mpsearch1+0x11>
80102b19:	eb 05                	jmp    80102b20 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b1b:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b20:	89 d8                	mov    %ebx,%eax
80102b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b25:	5b                   	pop    %ebx
80102b26:	5e                   	pop    %esi
80102b27:	5d                   	pop    %ebp
80102b28:	c3                   	ret    

80102b29 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b29:	55                   	push   %ebp
80102b2a:	89 e5                	mov    %esp,%ebp
80102b2c:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b2f:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b36:	c1 e0 08             	shl    $0x8,%eax
80102b39:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102b40:	09 d0                	or     %edx,%eax
80102b42:	c1 e0 04             	shl    $0x4,%eax
80102b45:	74 1f                	je     80102b66 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102b47:	ba 00 04 00 00       	mov    $0x400,%edx
80102b4c:	e8 89 ff ff ff       	call   80102ada <mpsearch1>
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 0f                	jne    80102b64 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102b55:	ba 00 00 01 00       	mov    $0x10000,%edx
80102b5a:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102b5f:	e8 76 ff ff ff       	call   80102ada <mpsearch1>
}
80102b64:	c9                   	leave  
80102b65:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102b66:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102b6d:	c1 e0 08             	shl    $0x8,%eax
80102b70:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102b77:	09 d0                	or     %edx,%eax
80102b79:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102b7c:	2d 00 04 00 00       	sub    $0x400,%eax
80102b81:	ba 00 04 00 00       	mov    $0x400,%edx
80102b86:	e8 4f ff ff ff       	call   80102ada <mpsearch1>
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	75 d5                	jne    80102b64 <mpsearch+0x3b>
80102b8f:	eb c4                	jmp    80102b55 <mpsearch+0x2c>

80102b91 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102b91:	55                   	push   %ebp
80102b92:	89 e5                	mov    %esp,%ebp
80102b94:	57                   	push   %edi
80102b95:	56                   	push   %esi
80102b96:	53                   	push   %ebx
80102b97:	83 ec 1c             	sub    $0x1c,%esp
80102b9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102b9d:	e8 87 ff ff ff       	call   80102b29 <mpsearch>
80102ba2:	89 c3                	mov    %eax,%ebx
80102ba4:	85 c0                	test   %eax,%eax
80102ba6:	74 5a                	je     80102c02 <mpconfig+0x71>
80102ba8:	8b 70 04             	mov    0x4(%eax),%esi
80102bab:	85 f6                	test   %esi,%esi
80102bad:	74 57                	je     80102c06 <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102baf:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102bb5:	83 ec 04             	sub    $0x4,%esp
80102bb8:	6a 04                	push   $0x4
80102bba:	68 bd 6e 10 80       	push   $0x80106ebd
80102bbf:	57                   	push   %edi
80102bc0:	e8 e9 12 00 00       	call   80103eae <memcmp>
80102bc5:	83 c4 10             	add    $0x10,%esp
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	75 3e                	jne    80102c0a <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102bcc:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102bd3:	3c 01                	cmp    $0x1,%al
80102bd5:	0f 95 c2             	setne  %dl
80102bd8:	3c 04                	cmp    $0x4,%al
80102bda:	0f 95 c0             	setne  %al
80102bdd:	84 c2                	test   %al,%dl
80102bdf:	75 30                	jne    80102c11 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102be1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102be8:	89 f8                	mov    %edi,%eax
80102bea:	e8 c7 fe ff ff       	call   80102ab6 <sum>
80102bef:	84 c0                	test   %al,%al
80102bf1:	75 25                	jne    80102c18 <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102bf6:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102bf8:	89 f8                	mov    %edi,%eax
80102bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bfd:	5b                   	pop    %ebx
80102bfe:	5e                   	pop    %esi
80102bff:	5f                   	pop    %edi
80102c00:	5d                   	pop    %ebp
80102c01:	c3                   	ret    
    return 0;
80102c02:	89 c7                	mov    %eax,%edi
80102c04:	eb f2                	jmp    80102bf8 <mpconfig+0x67>
80102c06:	89 f7                	mov    %esi,%edi
80102c08:	eb ee                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c0a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c0f:	eb e7                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c11:	bf 00 00 00 00       	mov    $0x0,%edi
80102c16:	eb e0                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c18:	bf 00 00 00 00       	mov    $0x0,%edi
80102c1d:	eb d9                	jmp    80102bf8 <mpconfig+0x67>

80102c1f <mpinit>:

void
mpinit(void)
{
80102c1f:	55                   	push   %ebp
80102c20:	89 e5                	mov    %esp,%ebp
80102c22:	57                   	push   %edi
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
80102c25:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c28:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c2b:	e8 61 ff ff ff       	call   80102b91 <mpconfig>
80102c30:	85 c0                	test   %eax,%eax
80102c32:	74 19                	je     80102c4d <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c34:	8b 50 24             	mov    0x24(%eax),%edx
80102c37:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c3d:	8d 50 2c             	lea    0x2c(%eax),%edx
80102c40:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102c44:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102c46:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c4b:	eb 20                	jmp    80102c6d <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102c4d:	83 ec 0c             	sub    $0xc,%esp
80102c50:	68 c2 6e 10 80       	push   $0x80106ec2
80102c55:	e8 ee d6 ff ff       	call   80100348 <panic>
    switch(*p){
80102c5a:	bb 00 00 00 00       	mov    $0x0,%ebx
80102c5f:	eb 0c                	jmp    80102c6d <mpinit+0x4e>
80102c61:	83 e8 03             	sub    $0x3,%eax
80102c64:	3c 01                	cmp    $0x1,%al
80102c66:	76 1a                	jbe    80102c82 <mpinit+0x63>
80102c68:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c6d:	39 ca                	cmp    %ecx,%edx
80102c6f:	73 4d                	jae    80102cbe <mpinit+0x9f>
    switch(*p){
80102c71:	0f b6 02             	movzbl (%edx),%eax
80102c74:	3c 02                	cmp    $0x2,%al
80102c76:	74 38                	je     80102cb0 <mpinit+0x91>
80102c78:	77 e7                	ja     80102c61 <mpinit+0x42>
80102c7a:	84 c0                	test   %al,%al
80102c7c:	74 09                	je     80102c87 <mpinit+0x68>
80102c7e:	3c 01                	cmp    $0x1,%al
80102c80:	75 d8                	jne    80102c5a <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102c82:	83 c2 08             	add    $0x8,%edx
      continue;
80102c85:	eb e6                	jmp    80102c6d <mpinit+0x4e>
      if(ncpu < NCPU) {
80102c87:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80102c8d:	83 fe 07             	cmp    $0x7,%esi
80102c90:	7f 19                	jg     80102cab <mpinit+0x8c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102c92:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102c96:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102c9c:	88 87 a0 17 11 80    	mov    %al,-0x7feee860(%edi)
        ncpu++;
80102ca2:	83 c6 01             	add    $0x1,%esi
80102ca5:	89 35 84 17 11 80    	mov    %esi,0x80111784
      p += sizeof(struct mpproc);
80102cab:	83 c2 14             	add    $0x14,%edx
      continue;
80102cae:	eb bd                	jmp    80102c6d <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102cb0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102cb4:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102cb9:	83 c2 08             	add    $0x8,%edx
      continue;
80102cbc:	eb af                	jmp    80102c6d <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102cbe:	85 db                	test   %ebx,%ebx
80102cc0:	74 26                	je     80102ce8 <mpinit+0xc9>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102cc5:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102cc9:	74 15                	je     80102ce0 <mpinit+0xc1>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ccb:	b8 70 00 00 00       	mov    $0x70,%eax
80102cd0:	ba 22 00 00 00       	mov    $0x22,%edx
80102cd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd6:	ba 23 00 00 00       	mov    $0x23,%edx
80102cdb:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102cdc:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdf:	ee                   	out    %al,(%dx)
  }
}
80102ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce3:	5b                   	pop    %ebx
80102ce4:	5e                   	pop    %esi
80102ce5:	5f                   	pop    %edi
80102ce6:	5d                   	pop    %ebp
80102ce7:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102ce8:	83 ec 0c             	sub    $0xc,%esp
80102ceb:	68 dc 6e 10 80       	push   $0x80106edc
80102cf0:	e8 53 d6 ff ff       	call   80100348 <panic>

80102cf5 <picinit>:
80102cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cfa:	ba 21 00 00 00       	mov    $0x21,%edx
80102cff:	ee                   	out    %al,(%dx)
80102d00:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d05:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d06:	c3                   	ret    

80102d07 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d07:	55                   	push   %ebp
80102d08:	89 e5                	mov    %esp,%ebp
80102d0a:	57                   	push   %edi
80102d0b:	56                   	push   %esi
80102d0c:	53                   	push   %ebx
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d13:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d16:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d22:	e8 f6 de ff ff       	call   80100c1d <filealloc>
80102d27:	89 03                	mov    %eax,(%ebx)
80102d29:	85 c0                	test   %eax,%eax
80102d2b:	0f 84 88 00 00 00    	je     80102db9 <pipealloc+0xb2>
80102d31:	e8 e7 de ff ff       	call   80100c1d <filealloc>
80102d36:	89 06                	mov    %eax,(%esi)
80102d38:	85 c0                	test   %eax,%eax
80102d3a:	74 7d                	je     80102db9 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d3c:	e8 62 f3 ff ff       	call   801020a3 <kalloc>
80102d41:	89 c7                	mov    %eax,%edi
80102d43:	85 c0                	test   %eax,%eax
80102d45:	74 72                	je     80102db9 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102d47:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102d4e:	00 00 00 
  p->writeopen = 1;
80102d51:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102d58:	00 00 00 
  p->nwrite = 0;
80102d5b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102d62:	00 00 00 
  p->nread = 0;
80102d65:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102d6c:	00 00 00 
  initlock(&p->lock, "pipe");
80102d6f:	83 ec 08             	sub    $0x8,%esp
80102d72:	68 fb 6e 10 80       	push   $0x80106efb
80102d77:	50                   	push   %eax
80102d78:	e8 06 0f 00 00       	call   80103c83 <initlock>
  (*f0)->type = FD_PIPE;
80102d7d:	8b 03                	mov    (%ebx),%eax
80102d7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102d85:	8b 03                	mov    (%ebx),%eax
80102d87:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102d8b:	8b 03                	mov    (%ebx),%eax
80102d8d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102d91:	8b 03                	mov    (%ebx),%eax
80102d93:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102d96:	8b 06                	mov    (%esi),%eax
80102d98:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102d9e:	8b 06                	mov    (%esi),%eax
80102da0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102da4:	8b 06                	mov    (%esi),%eax
80102da6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102daa:	8b 06                	mov    (%esi),%eax
80102dac:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102daf:	83 c4 10             	add    $0x10,%esp
80102db2:	b8 00 00 00 00       	mov    $0x0,%eax
80102db7:	eb 29                	jmp    80102de2 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102db9:	8b 03                	mov    (%ebx),%eax
80102dbb:	85 c0                	test   %eax,%eax
80102dbd:	74 0c                	je     80102dcb <pipealloc+0xc4>
    fileclose(*f0);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
80102dc2:	50                   	push   %eax
80102dc3:	e8 fb de ff ff       	call   80100cc3 <fileclose>
80102dc8:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102dcb:	8b 06                	mov    (%esi),%eax
80102dcd:	85 c0                	test   %eax,%eax
80102dcf:	74 19                	je     80102dea <pipealloc+0xe3>
    fileclose(*f1);
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	50                   	push   %eax
80102dd5:	e8 e9 de ff ff       	call   80100cc3 <fileclose>
80102dda:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102de5:	5b                   	pop    %ebx
80102de6:	5e                   	pop    %esi
80102de7:	5f                   	pop    %edi
80102de8:	5d                   	pop    %ebp
80102de9:	c3                   	ret    
  return -1;
80102dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102def:	eb f1                	jmp    80102de2 <pipealloc+0xdb>

80102df1 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102df1:	55                   	push   %ebp
80102df2:	89 e5                	mov    %esp,%ebp
80102df4:	53                   	push   %ebx
80102df5:	83 ec 10             	sub    $0x10,%esp
80102df8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102dfb:	53                   	push   %ebx
80102dfc:	e8 be 0f 00 00       	call   80103dbf <acquire>
  if(writable){
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e08:	74 3f                	je     80102e49 <pipeclose+0x58>
    p->writeopen = 0;
80102e0a:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e11:	00 00 00 
    wakeup(&p->nread);
80102e14:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e1a:	83 ec 0c             	sub    $0xc,%esp
80102e1d:	50                   	push   %eax
80102e1e:	e8 be 09 00 00       	call   801037e1 <wakeup>
80102e23:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e26:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e2d:	75 09                	jne    80102e38 <pipeclose+0x47>
80102e2f:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e36:	74 2f                	je     80102e67 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e38:	83 ec 0c             	sub    $0xc,%esp
80102e3b:	53                   	push   %ebx
80102e3c:	e8 e3 0f 00 00       	call   80103e24 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e47:	c9                   	leave  
80102e48:	c3                   	ret    
    p->readopen = 0;
80102e49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102e50:	00 00 00 
    wakeup(&p->nwrite);
80102e53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e59:	83 ec 0c             	sub    $0xc,%esp
80102e5c:	50                   	push   %eax
80102e5d:	e8 7f 09 00 00       	call   801037e1 <wakeup>
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	eb bf                	jmp    80102e26 <pipeclose+0x35>
    release(&p->lock);
80102e67:	83 ec 0c             	sub    $0xc,%esp
80102e6a:	53                   	push   %ebx
80102e6b:	e8 b4 0f 00 00       	call   80103e24 <release>
    kfree((char*)p);
80102e70:	89 1c 24             	mov    %ebx,(%esp)
80102e73:	e8 14 f1 ff ff       	call   80101f8c <kfree>
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	eb c7                	jmp    80102e44 <pipeclose+0x53>

80102e7d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102e7d:	55                   	push   %ebp
80102e7e:	89 e5                	mov    %esp,%ebp
80102e80:	57                   	push   %edi
80102e81:	56                   	push   %esi
80102e82:	53                   	push   %ebx
80102e83:	83 ec 18             	sub    $0x18,%esp
80102e86:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e89:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  acquire(&p->lock);
80102e8c:	53                   	push   %ebx
80102e8d:	e8 2d 0f 00 00       	call   80103dbf <acquire>
  for(i = 0; i < n; i++){
80102e92:	83 c4 10             	add    $0x10,%esp
80102e95:	bf 00 00 00 00       	mov    $0x0,%edi
80102e9a:	39 f7                	cmp    %esi,%edi
80102e9c:	7c 40                	jl     80102ede <pipewrite+0x61>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102e9e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ea4:	83 ec 0c             	sub    $0xc,%esp
80102ea7:	50                   	push   %eax
80102ea8:	e8 34 09 00 00       	call   801037e1 <wakeup>
  release(&p->lock);
80102ead:	89 1c 24             	mov    %ebx,(%esp)
80102eb0:	e8 6f 0f 00 00       	call   80103e24 <release>
  return n;
80102eb5:	83 c4 10             	add    $0x10,%esp
80102eb8:	89 f0                	mov    %esi,%eax
80102eba:	eb 5c                	jmp    80102f18 <pipewrite+0x9b>
      wakeup(&p->nread);
80102ebc:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ec2:	83 ec 0c             	sub    $0xc,%esp
80102ec5:	50                   	push   %eax
80102ec6:	e8 16 09 00 00       	call   801037e1 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102ecb:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ed1:	83 c4 08             	add    $0x8,%esp
80102ed4:	53                   	push   %ebx
80102ed5:	50                   	push   %eax
80102ed6:	e8 a1 07 00 00       	call   8010367c <sleep>
80102edb:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102ede:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102ee4:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102eea:	05 00 02 00 00       	add    $0x200,%eax
80102eef:	39 c2                	cmp    %eax,%edx
80102ef1:	75 2d                	jne    80102f20 <pipewrite+0xa3>
      if(p->readopen == 0 || myproc()->killed){
80102ef3:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102efa:	74 0b                	je     80102f07 <pipewrite+0x8a>
80102efc:	e8 b4 02 00 00       	call   801031b5 <myproc>
80102f01:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f05:	74 b5                	je     80102ebc <pipewrite+0x3f>
        release(&p->lock);
80102f07:	83 ec 0c             	sub    $0xc,%esp
80102f0a:	53                   	push   %ebx
80102f0b:	e8 14 0f 00 00       	call   80103e24 <release>
        return -1;
80102f10:	83 c4 10             	add    $0x10,%esp
80102f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1b:	5b                   	pop    %ebx
80102f1c:	5e                   	pop    %esi
80102f1d:	5f                   	pop    %edi
80102f1e:	5d                   	pop    %ebp
80102f1f:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f20:	8d 42 01             	lea    0x1(%edx),%eax
80102f23:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f29:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f32:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80102f36:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102f3a:	83 c7 01             	add    $0x1,%edi
80102f3d:	e9 58 ff ff ff       	jmp    80102e9a <pipewrite+0x1d>

80102f42 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102f42:	55                   	push   %ebp
80102f43:	89 e5                	mov    %esp,%ebp
80102f45:	57                   	push   %edi
80102f46:	56                   	push   %esi
80102f47:	53                   	push   %ebx
80102f48:	83 ec 18             	sub    $0x18,%esp
80102f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f4e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80102f51:	53                   	push   %ebx
80102f52:	e8 68 0e 00 00       	call   80103dbf <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	eb 13                	jmp    80102f6f <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102f5c:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f62:	83 ec 08             	sub    $0x8,%esp
80102f65:	53                   	push   %ebx
80102f66:	50                   	push   %eax
80102f67:	e8 10 07 00 00       	call   8010367c <sleep>
80102f6c:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f6f:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f75:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102f7b:	75 78                	jne    80102ff5 <piperead+0xb3>
80102f7d:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102f83:	85 f6                	test   %esi,%esi
80102f85:	74 37                	je     80102fbe <piperead+0x7c>
    if(myproc()->killed){
80102f87:	e8 29 02 00 00       	call   801031b5 <myproc>
80102f8c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f90:	74 ca                	je     80102f5c <piperead+0x1a>
      release(&p->lock);
80102f92:	83 ec 0c             	sub    $0xc,%esp
80102f95:	53                   	push   %ebx
80102f96:	e8 89 0e 00 00       	call   80103e24 <release>
      return -1;
80102f9b:	83 c4 10             	add    $0x10,%esp
80102f9e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102fa3:	eb 46                	jmp    80102feb <piperead+0xa9>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102fa5:	8d 50 01             	lea    0x1(%eax),%edx
80102fa8:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102fae:	25 ff 01 00 00       	and    $0x1ff,%eax
80102fb3:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80102fb8:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102fbb:	83 c6 01             	add    $0x1,%esi
80102fbe:	3b 75 10             	cmp    0x10(%ebp),%esi
80102fc1:	7d 0e                	jge    80102fd1 <piperead+0x8f>
    if(p->nread == p->nwrite)
80102fc3:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fc9:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102fcf:	75 d4                	jne    80102fa5 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102fd1:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	50                   	push   %eax
80102fdb:	e8 01 08 00 00       	call   801037e1 <wakeup>
  release(&p->lock);
80102fe0:	89 1c 24             	mov    %ebx,(%esp)
80102fe3:	e8 3c 0e 00 00       	call   80103e24 <release>
  return i;
80102fe8:	83 c4 10             	add    $0x10,%esp
}
80102feb:	89 f0                	mov    %esi,%eax
80102fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ff0:	5b                   	pop    %ebx
80102ff1:	5e                   	pop    %esi
80102ff2:	5f                   	pop    %edi
80102ff3:	5d                   	pop    %ebp
80102ff4:	c3                   	ret    
80102ff5:	be 00 00 00 00       	mov    $0x0,%esi
80102ffa:	eb c2                	jmp    80102fbe <piperead+0x7c>

80102ffc <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102ffc:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103001:	eb 03                	jmp    80103006 <wakeup1+0xa>
80103003:	83 ea 80             	sub    $0xffffff80,%edx
80103006:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
8010300c:	73 14                	jae    80103022 <wakeup1+0x26>
    if (p->state == SLEEPING && p->chan == chan)
8010300e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103012:	75 ef                	jne    80103003 <wakeup1+0x7>
80103014:	39 42 20             	cmp    %eax,0x20(%edx)
80103017:	75 ea                	jne    80103003 <wakeup1+0x7>
      p->state = RUNNABLE;
80103019:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103020:	eb e1                	jmp    80103003 <wakeup1+0x7>
}
80103022:	c3                   	ret    

80103023 <allocproc>:
{
80103023:	55                   	push   %ebp
80103024:	89 e5                	mov    %esp,%ebp
80103026:	53                   	push   %ebx
80103027:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010302a:	68 20 1d 11 80       	push   $0x80111d20
8010302f:	e8 8b 0d 00 00       	call   80103dbf <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103034:	83 c4 10             	add    $0x10,%esp
80103037:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010303c:	eb 03                	jmp    80103041 <allocproc+0x1e>
8010303e:	83 eb 80             	sub    $0xffffff80,%ebx
80103041:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103047:	73 76                	jae    801030bf <allocproc+0x9c>
    if (p->state == UNUSED)
80103049:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
8010304d:	75 ef                	jne    8010303e <allocproc+0x1b>
  p->state = EMBRYO;
8010304f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103056:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010305b:	8d 50 01             	lea    0x1(%eax),%edx
8010305e:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103064:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103067:	83 ec 0c             	sub    $0xc,%esp
8010306a:	68 20 1d 11 80       	push   $0x80111d20
8010306f:	e8 b0 0d 00 00       	call   80103e24 <release>
  if ((p->kstack = kalloc()) == 0)
80103074:	e8 2a f0 ff ff       	call   801020a3 <kalloc>
80103079:	89 43 08             	mov    %eax,0x8(%ebx)
8010307c:	83 c4 10             	add    $0x10,%esp
8010307f:	85 c0                	test   %eax,%eax
80103081:	74 53                	je     801030d6 <allocproc+0xb3>
  sp -= sizeof *p->tf;
80103083:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe *)sp;
80103089:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010308c:	c7 80 b0 0f 00 00 60 	movl   $0x80105060,0xfb0(%eax)
80103093:	50 10 80 
  sp -= sizeof *p->context;
80103096:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context *)sp;
8010309b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010309e:	83 ec 04             	sub    $0x4,%esp
801030a1:	6a 14                	push   $0x14
801030a3:	6a 00                	push   $0x0
801030a5:	50                   	push   %eax
801030a6:	e8 c0 0d 00 00       	call   80103e6b <memset>
  p->context->eip = (uint)forkret;
801030ab:	8b 43 1c             	mov    0x1c(%ebx),%eax
801030ae:	c7 40 10 e1 30 10 80 	movl   $0x801030e1,0x10(%eax)
  return p;
801030b5:	83 c4 10             	add    $0x10,%esp
}
801030b8:	89 d8                	mov    %ebx,%eax
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030bd:	c9                   	leave  
801030be:	c3                   	ret    
  release(&ptable.lock);
801030bf:	83 ec 0c             	sub    $0xc,%esp
801030c2:	68 20 1d 11 80       	push   $0x80111d20
801030c7:	e8 58 0d 00 00       	call   80103e24 <release>
  return 0;
801030cc:	83 c4 10             	add    $0x10,%esp
801030cf:	bb 00 00 00 00       	mov    $0x0,%ebx
801030d4:	eb e2                	jmp    801030b8 <allocproc+0x95>
    p->state = UNUSED;
801030d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801030dd:	89 c3                	mov    %eax,%ebx
801030df:	eb d7                	jmp    801030b8 <allocproc+0x95>

801030e1 <forkret>:
{
801030e1:	55                   	push   %ebp
801030e2:	89 e5                	mov    %esp,%ebp
801030e4:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801030e7:	68 20 1d 11 80       	push   $0x80111d20
801030ec:	e8 33 0d 00 00       	call   80103e24 <release>
  if (first)
801030f1:	83 c4 10             	add    $0x10,%esp
801030f4:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
801030fb:	75 02                	jne    801030ff <forkret+0x1e>
}
801030fd:	c9                   	leave  
801030fe:	c3                   	ret    
    first = 0;
801030ff:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103106:	00 00 00 
    iinit(ROOTDEV);
80103109:	83 ec 0c             	sub    $0xc,%esp
8010310c:	6a 01                	push   $0x1
8010310e:	e8 c7 e1 ff ff       	call   801012da <iinit>
    initlog(ROOTDEV);
80103113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010311a:	e8 16 f6 ff ff       	call   80102735 <initlog>
8010311f:	83 c4 10             	add    $0x10,%esp
}
80103122:	eb d9                	jmp    801030fd <forkret+0x1c>

80103124 <pinit>:
{
80103124:	55                   	push   %ebp
80103125:	89 e5                	mov    %esp,%ebp
80103127:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010312a:	68 00 6f 10 80       	push   $0x80106f00
8010312f:	68 20 1d 11 80       	push   $0x80111d20
80103134:	e8 4a 0b 00 00       	call   80103c83 <initlock>
}
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	c9                   	leave  
8010313d:	c3                   	ret    

8010313e <mycpu>:
{
8010313e:	55                   	push   %ebp
8010313f:	89 e5                	mov    %esp,%ebp
80103141:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103144:	9c                   	pushf  
80103145:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103146:	f6 c4 02             	test   $0x2,%ah
80103149:	75 28                	jne    80103173 <mycpu+0x35>
  apicid = lapicid();
8010314b:	e8 10 f2 ff ff       	call   80102360 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103150:	ba 00 00 00 00       	mov    $0x0,%edx
80103155:	39 15 84 17 11 80    	cmp    %edx,0x80111784
8010315b:	7e 23                	jle    80103180 <mycpu+0x42>
    if (cpus[i].apicid == apicid)
8010315d:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103163:	0f b6 89 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ecx
8010316a:	39 c1                	cmp    %eax,%ecx
8010316c:	74 1f                	je     8010318d <mycpu+0x4f>
  for (i = 0; i < ncpu; ++i)
8010316e:	83 c2 01             	add    $0x1,%edx
80103171:	eb e2                	jmp    80103155 <mycpu+0x17>
    panic("mycpu called with interrupts enabled\n");
80103173:	83 ec 0c             	sub    $0xc,%esp
80103176:	68 28 70 10 80       	push   $0x80107028
8010317b:	e8 c8 d1 ff ff       	call   80100348 <panic>
  panic("unknown apicid\n");
80103180:	83 ec 0c             	sub    $0xc,%esp
80103183:	68 07 6f 10 80       	push   $0x80106f07
80103188:	e8 bb d1 ff ff       	call   80100348 <panic>
      return &cpus[i];
8010318d:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103193:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103198:	c9                   	leave  
80103199:	c3                   	ret    

8010319a <cpuid>:
{
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801031a0:	e8 99 ff ff ff       	call   8010313e <mycpu>
801031a5:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801031aa:	c1 f8 04             	sar    $0x4,%eax
801031ad:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801031b3:	c9                   	leave  
801031b4:	c3                   	ret    

801031b5 <myproc>:
{
801031b5:	55                   	push   %ebp
801031b6:	89 e5                	mov    %esp,%ebp
801031b8:	53                   	push   %ebx
801031b9:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801031bc:	e8 23 0b 00 00       	call   80103ce4 <pushcli>
  c = mycpu();
801031c1:	e8 78 ff ff ff       	call   8010313e <mycpu>
  p = c->proc;
801031c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801031cc:	e8 4f 0b 00 00       	call   80103d20 <popcli>
}
801031d1:	89 d8                	mov    %ebx,%eax
801031d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031d6:	c9                   	leave  
801031d7:	c3                   	ret    

801031d8 <userinit>:
{
801031d8:	55                   	push   %ebp
801031d9:	89 e5                	mov    %esp,%ebp
801031db:	53                   	push   %ebx
801031dc:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801031df:	e8 3f fe ff ff       	call   80103023 <allocproc>
801031e4:	89 c3                	mov    %eax,%ebx
  initproc = p;
801031e6:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if ((p->pgdir = setupkvm()) == 0)
801031eb:	e8 0a 35 00 00       	call   801066fa <setupkvm>
801031f0:	89 43 04             	mov    %eax,0x4(%ebx)
801031f3:	85 c0                	test   %eax,%eax
801031f5:	0f 84 b8 00 00 00    	je     801032b3 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801031fb:	83 ec 04             	sub    $0x4,%esp
801031fe:	68 2c 00 00 00       	push   $0x2c
80103203:	68 60 a4 10 80       	push   $0x8010a460
80103208:	50                   	push   %eax
80103209:	e8 fc 31 00 00       	call   8010640a <inituvm>
  p->sz = PGSIZE;
8010320e:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103214:	8b 43 18             	mov    0x18(%ebx),%eax
80103217:	83 c4 0c             	add    $0xc,%esp
8010321a:	6a 4c                	push   $0x4c
8010321c:	6a 00                	push   $0x0
8010321e:	50                   	push   %eax
8010321f:	e8 47 0c 00 00       	call   80103e6b <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103224:	8b 43 18             	mov    0x18(%ebx),%eax
80103227:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010322d:	8b 43 18             	mov    0x18(%ebx),%eax
80103230:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103236:	8b 43 18             	mov    0x18(%ebx),%eax
80103239:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010323d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103241:	8b 43 18             	mov    0x18(%ebx),%eax
80103244:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103248:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010324c:	8b 43 18             	mov    0x18(%ebx),%eax
8010324f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103256:	8b 43 18             	mov    0x18(%ebx),%eax
80103259:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103260:	8b 43 18             	mov    0x18(%ebx),%eax
80103263:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010326a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010326d:	83 c4 0c             	add    $0xc,%esp
80103270:	6a 10                	push   $0x10
80103272:	68 30 6f 10 80       	push   $0x80106f30
80103277:	50                   	push   %eax
80103278:	e8 5a 0d 00 00       	call   80103fd7 <safestrcpy>
  p->cwd = namei("/");
8010327d:	c7 04 24 39 6f 10 80 	movl   $0x80106f39,(%esp)
80103284:	e8 44 e9 ff ff       	call   80101bcd <namei>
80103289:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010328c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103293:	e8 27 0b 00 00       	call   80103dbf <acquire>
  p->state = RUNNABLE;
80103298:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010329f:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801032a6:	e8 79 0b 00 00       	call   80103e24 <release>
}
801032ab:	83 c4 10             	add    $0x10,%esp
801032ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032b1:	c9                   	leave  
801032b2:	c3                   	ret    
    panic("userinit: out of memory?");
801032b3:	83 ec 0c             	sub    $0xc,%esp
801032b6:	68 17 6f 10 80       	push   $0x80106f17
801032bb:	e8 88 d0 ff ff       	call   80100348 <panic>

801032c0 <growproc>:
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	56                   	push   %esi
801032c4:	53                   	push   %ebx
801032c5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801032c8:	e8 e8 fe ff ff       	call   801031b5 <myproc>
801032cd:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801032cf:	8b 00                	mov    (%eax),%eax
  if (n > 0)
801032d1:	85 f6                	test   %esi,%esi
801032d3:	7f 1c                	jg     801032f1 <growproc+0x31>
  else if (n < 0)
801032d5:	78 37                	js     8010330e <growproc+0x4e>
  curproc->sz = sz;
801032d7:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801032d9:	83 ec 0c             	sub    $0xc,%esp
801032dc:	53                   	push   %ebx
801032dd:	e8 c8 2f 00 00       	call   801062aa <switchuvm>
  return 0;
801032e2:	83 c4 10             	add    $0x10,%esp
801032e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801032ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032ed:	5b                   	pop    %ebx
801032ee:	5e                   	pop    %esi
801032ef:	5d                   	pop    %ebp
801032f0:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032f1:	83 ec 04             	sub    $0x4,%esp
801032f4:	01 c6                	add    %eax,%esi
801032f6:	56                   	push   %esi
801032f7:	50                   	push   %eax
801032f8:	ff 73 04             	push   0x4(%ebx)
801032fb:	e8 a0 32 00 00       	call   801065a0 <allocuvm>
80103300:	83 c4 10             	add    $0x10,%esp
80103303:	85 c0                	test   %eax,%eax
80103305:	75 d0                	jne    801032d7 <growproc+0x17>
      return -1;
80103307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010330c:	eb dc                	jmp    801032ea <growproc+0x2a>
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010330e:	83 ec 04             	sub    $0x4,%esp
80103311:	01 c6                	add    %eax,%esi
80103313:	56                   	push   %esi
80103314:	50                   	push   %eax
80103315:	ff 73 04             	push   0x4(%ebx)
80103318:	e8 f1 31 00 00       	call   8010650e <deallocuvm>
8010331d:	83 c4 10             	add    $0x10,%esp
80103320:	85 c0                	test   %eax,%eax
80103322:	75 b3                	jne    801032d7 <growproc+0x17>
      return -1;
80103324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103329:	eb bf                	jmp    801032ea <growproc+0x2a>

8010332b <fork>:
{
8010332b:	55                   	push   %ebp
8010332c:	89 e5                	mov    %esp,%ebp
8010332e:	57                   	push   %edi
8010332f:	56                   	push   %esi
80103330:	53                   	push   %ebx
80103331:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103334:	e8 7c fe ff ff       	call   801031b5 <myproc>
80103339:	89 c3                	mov    %eax,%ebx
  if ((np = allocproc()) == 0)
8010333b:	e8 e3 fc ff ff       	call   80103023 <allocproc>
80103340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103343:	85 c0                	test   %eax,%eax
80103345:	0f 84 e0 00 00 00    	je     8010342b <fork+0x100>
8010334b:	89 c7                	mov    %eax,%edi
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010334d:	83 ec 08             	sub    $0x8,%esp
80103350:	ff 33                	push   (%ebx)
80103352:	ff 73 04             	push   0x4(%ebx)
80103355:	e8 51 34 00 00       	call   801067ab <copyuvm>
8010335a:	89 47 04             	mov    %eax,0x4(%edi)
8010335d:	83 c4 10             	add    $0x10,%esp
80103360:	85 c0                	test   %eax,%eax
80103362:	74 2a                	je     8010338e <fork+0x63>
  np->sz = curproc->sz;
80103364:	8b 03                	mov    (%ebx),%eax
80103366:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103369:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010336b:	89 c8                	mov    %ecx,%eax
8010336d:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103370:	8b 73 18             	mov    0x18(%ebx),%esi
80103373:	8b 79 18             	mov    0x18(%ecx),%edi
80103376:	b9 13 00 00 00       	mov    $0x13,%ecx
8010337b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010337d:	8b 40 18             	mov    0x18(%eax),%eax
80103380:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80103387:	be 00 00 00 00       	mov    $0x0,%esi
8010338c:	eb 29                	jmp    801033b7 <fork+0x8c>
    kfree(np->kstack);
8010338e:	83 ec 0c             	sub    $0xc,%esp
80103391:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103394:	ff 73 08             	push   0x8(%ebx)
80103397:	e8 f0 eb ff ff       	call   80101f8c <kfree>
    np->kstack = 0;
8010339c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801033a3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801033aa:	83 c4 10             	add    $0x10,%esp
801033ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801033b2:	eb 6d                	jmp    80103421 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
801033b4:	83 c6 01             	add    $0x1,%esi
801033b7:	83 fe 0f             	cmp    $0xf,%esi
801033ba:	7f 1d                	jg     801033d9 <fork+0xae>
    if (curproc->ofile[i])
801033bc:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801033c0:	85 c0                	test   %eax,%eax
801033c2:	74 f0                	je     801033b4 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
801033c4:	83 ec 0c             	sub    $0xc,%esp
801033c7:	50                   	push   %eax
801033c8:	e8 b1 d8 ff ff       	call   80100c7e <filedup>
801033cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033d0:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	eb db                	jmp    801033b4 <fork+0x89>
  np->cwd = idup(curproc->cwd);
801033d9:	83 ec 0c             	sub    $0xc,%esp
801033dc:	ff 73 68             	push   0x68(%ebx)
801033df:	e8 5b e1 ff ff       	call   8010153f <idup>
801033e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801033e7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801033ea:	83 c3 6c             	add    $0x6c,%ebx
801033ed:	8d 47 6c             	lea    0x6c(%edi),%eax
801033f0:	83 c4 0c             	add    $0xc,%esp
801033f3:	6a 10                	push   $0x10
801033f5:	53                   	push   %ebx
801033f6:	50                   	push   %eax
801033f7:	e8 db 0b 00 00       	call   80103fd7 <safestrcpy>
  pid = np->pid;
801033fc:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801033ff:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103406:	e8 b4 09 00 00       	call   80103dbf <acquire>
  np->state = RUNNABLE;
8010340b:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103412:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103419:	e8 06 0a 00 00       	call   80103e24 <release>
  return pid;
8010341e:	83 c4 10             	add    $0x10,%esp
}
80103421:	89 d8                	mov    %ebx,%eax
80103423:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103426:	5b                   	pop    %ebx
80103427:	5e                   	pop    %esi
80103428:	5f                   	pop    %edi
80103429:	5d                   	pop    %ebp
8010342a:	c3                   	ret    
    return -1;
8010342b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103430:	eb ef                	jmp    80103421 <fork+0xf6>

80103432 <scheduler>:
{
80103432:	55                   	push   %ebp
80103433:	89 e5                	mov    %esp,%ebp
80103435:	56                   	push   %esi
80103436:	53                   	push   %ebx
  struct cpu *c = mycpu();
80103437:	e8 02 fd ff ff       	call   8010313e <mycpu>
8010343c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010343e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103445:	00 00 00 
80103448:	eb 60                	jmp    801034aa <scheduler+0x78>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010344a:	83 eb 80             	sub    $0xffffff80,%ebx
8010344d:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103453:	73 45                	jae    8010349a <scheduler+0x68>
      if (p->state != RUNNABLE)
80103455:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103459:	75 ef                	jne    8010344a <scheduler+0x18>
      if(p->PAUSE!=0)
8010345b:	83 7b 7c 00          	cmpl   $0x0,0x7c(%ebx)
8010345f:	75 e9                	jne    8010344a <scheduler+0x18>
      c->proc = p;
80103461:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103467:	83 ec 0c             	sub    $0xc,%esp
8010346a:	53                   	push   %ebx
8010346b:	e8 3a 2e 00 00       	call   801062aa <switchuvm>
      p->state = RUNNING;
80103470:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103477:	83 c4 08             	add    $0x8,%esp
8010347a:	ff 73 1c             	push   0x1c(%ebx)
8010347d:	8d 46 04             	lea    0x4(%esi),%eax
80103480:	50                   	push   %eax
80103481:	e8 a6 0b 00 00       	call   8010402c <swtch>
      switchkvm();
80103486:	e8 11 2e 00 00       	call   8010629c <switchkvm>
      c->proc = 0;
8010348b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103492:	00 00 00 
80103495:	83 c4 10             	add    $0x10,%esp
80103498:	eb b0                	jmp    8010344a <scheduler+0x18>
    release(&ptable.lock);
8010349a:	83 ec 0c             	sub    $0xc,%esp
8010349d:	68 20 1d 11 80       	push   $0x80111d20
801034a2:	e8 7d 09 00 00       	call   80103e24 <release>
    sti();
801034a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801034aa:	fb                   	sti    
    acquire(&ptable.lock);
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	68 20 1d 11 80       	push   $0x80111d20
801034b3:	e8 07 09 00 00       	call   80103dbf <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b8:	83 c4 10             	add    $0x10,%esp
801034bb:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801034c0:	eb 8b                	jmp    8010344d <scheduler+0x1b>

801034c2 <sched>:
{
801034c2:	55                   	push   %ebp
801034c3:	89 e5                	mov    %esp,%ebp
801034c5:	56                   	push   %esi
801034c6:	53                   	push   %ebx
  struct proc *p = myproc();
801034c7:	e8 e9 fc ff ff       	call   801031b5 <myproc>
801034cc:	89 c3                	mov    %eax,%ebx
  if (!holding(&ptable.lock))
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	68 20 1d 11 80       	push   $0x80111d20
801034d6:	e8 a5 08 00 00       	call   80103d80 <holding>
801034db:	83 c4 10             	add    $0x10,%esp
801034de:	85 c0                	test   %eax,%eax
801034e0:	74 4f                	je     80103531 <sched+0x6f>
  if (mycpu()->ncli != 1)
801034e2:	e8 57 fc ff ff       	call   8010313e <mycpu>
801034e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801034ee:	75 4e                	jne    8010353e <sched+0x7c>
  if (p->state == RUNNING)
801034f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801034f4:	74 55                	je     8010354b <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801034f6:	9c                   	pushf  
801034f7:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801034f8:	f6 c4 02             	test   $0x2,%ah
801034fb:	75 5b                	jne    80103558 <sched+0x96>
  intena = mycpu()->intena;
801034fd:	e8 3c fc ff ff       	call   8010313e <mycpu>
80103502:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103508:	e8 31 fc ff ff       	call   8010313e <mycpu>
8010350d:	83 ec 08             	sub    $0x8,%esp
80103510:	ff 70 04             	push   0x4(%eax)
80103513:	83 c3 1c             	add    $0x1c,%ebx
80103516:	53                   	push   %ebx
80103517:	e8 10 0b 00 00       	call   8010402c <swtch>
  mycpu()->intena = intena;
8010351c:	e8 1d fc ff ff       	call   8010313e <mycpu>
80103521:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103527:	83 c4 10             	add    $0x10,%esp
8010352a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010352d:	5b                   	pop    %ebx
8010352e:	5e                   	pop    %esi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
    panic("sched ptable.lock");
80103531:	83 ec 0c             	sub    $0xc,%esp
80103534:	68 3b 6f 10 80       	push   $0x80106f3b
80103539:	e8 0a ce ff ff       	call   80100348 <panic>
    panic("sched locks");
8010353e:	83 ec 0c             	sub    $0xc,%esp
80103541:	68 4d 6f 10 80       	push   $0x80106f4d
80103546:	e8 fd cd ff ff       	call   80100348 <panic>
    panic("sched running");
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	68 59 6f 10 80       	push   $0x80106f59
80103553:	e8 f0 cd ff ff       	call   80100348 <panic>
    panic("sched interruptible");
80103558:	83 ec 0c             	sub    $0xc,%esp
8010355b:	68 67 6f 10 80       	push   $0x80106f67
80103560:	e8 e3 cd ff ff       	call   80100348 <panic>

80103565 <exit>:
{
80103565:	55                   	push   %ebp
80103566:	89 e5                	mov    %esp,%ebp
80103568:	56                   	push   %esi
80103569:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010356a:	e8 46 fc ff ff       	call   801031b5 <myproc>
  if (curproc == initproc)
8010356f:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103575:	74 09                	je     80103580 <exit+0x1b>
80103577:	89 c6                	mov    %eax,%esi
  for (fd = 0; fd < NOFILE; fd++)
80103579:	bb 00 00 00 00       	mov    $0x0,%ebx
8010357e:	eb 10                	jmp    80103590 <exit+0x2b>
    panic("init exiting");
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	68 7b 6f 10 80       	push   $0x80106f7b
80103588:	e8 bb cd ff ff       	call   80100348 <panic>
  for (fd = 0; fd < NOFILE; fd++)
8010358d:	83 c3 01             	add    $0x1,%ebx
80103590:	83 fb 0f             	cmp    $0xf,%ebx
80103593:	7f 1e                	jg     801035b3 <exit+0x4e>
    if (curproc->ofile[fd])
80103595:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103599:	85 c0                	test   %eax,%eax
8010359b:	74 f0                	je     8010358d <exit+0x28>
      fileclose(curproc->ofile[fd]);
8010359d:	83 ec 0c             	sub    $0xc,%esp
801035a0:	50                   	push   %eax
801035a1:	e8 1d d7 ff ff       	call   80100cc3 <fileclose>
      curproc->ofile[fd] = 0;
801035a6:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801035ad:	00 
801035ae:	83 c4 10             	add    $0x10,%esp
801035b1:	eb da                	jmp    8010358d <exit+0x28>
  begin_op();
801035b3:	e8 c6 f1 ff ff       	call   8010277e <begin_op>
  iput(curproc->cwd);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	ff 76 68             	push   0x68(%esi)
801035be:	e8 b3 e0 ff ff       	call   80101676 <iput>
  end_op();
801035c3:	e8 30 f2 ff ff       	call   801027f8 <end_op>
  curproc->cwd = 0;
801035c8:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801035cf:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801035d6:	e8 e4 07 00 00       	call   80103dbf <acquire>
   wakeup1(curproc->parent);
801035db:	8b 46 14             	mov    0x14(%esi),%eax
801035de:	e8 19 fa ff ff       	call   80102ffc <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035e3:	83 c4 10             	add    $0x10,%esp
801035e6:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801035eb:	eb 1e                	jmp    8010360b <exit+0xa6>
        nproc->parent=nproc->parent->parent;
801035ed:	8b 52 14             	mov    0x14(%edx),%edx
801035f0:	89 50 14             	mov    %edx,0x14(%eax)
        p->parent=nproc->parent;
801035f3:	89 53 14             	mov    %edx,0x14(%ebx)
        nproc--;
801035f6:	83 c0 80             	add    $0xffffff80,%eax
      while(nproc->parent->killed!=0){
801035f9:	8b 50 14             	mov    0x14(%eax),%edx
801035fc:	83 7a 24 00          	cmpl   $0x0,0x24(%edx)
80103600:	75 eb                	jne    801035ed <exit+0x88>
      if (p->state == ZOMBIE)
80103602:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103606:	74 1d                	je     80103625 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103608:	83 eb 80             	sub    $0xffffff80,%ebx
8010360b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103611:	73 1e                	jae    80103631 <exit+0xcc>
    if (p->parent == curproc)
80103613:	8b 43 14             	mov    0x14(%ebx),%eax
80103616:	39 f0                	cmp    %esi,%eax
80103618:	75 ee                	jne    80103608 <exit+0xa3>
      nproc->parent->killed=1;
8010361a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      nproc=p;
80103621:	89 d8                	mov    %ebx,%eax
      while(nproc->parent->killed!=0){
80103623:	eb d4                	jmp    801035f9 <exit+0x94>
        wakeup1(initproc);
80103625:	a1 54 3d 11 80       	mov    0x80113d54,%eax
8010362a:	e8 cd f9 ff ff       	call   80102ffc <wakeup1>
8010362f:	eb d7                	jmp    80103608 <exit+0xa3>
  curproc->state = ZOMBIE;
80103631:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103638:	e8 85 fe ff ff       	call   801034c2 <sched>
  panic("zombie exit");
8010363d:	83 ec 0c             	sub    $0xc,%esp
80103640:	68 88 6f 10 80       	push   $0x80106f88
80103645:	e8 fe cc ff ff       	call   80100348 <panic>

8010364a <yield>:
{
8010364a:	55                   	push   %ebp
8010364b:	89 e5                	mov    %esp,%ebp
8010364d:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80103650:	68 20 1d 11 80       	push   $0x80111d20
80103655:	e8 65 07 00 00       	call   80103dbf <acquire>
  myproc()->state = RUNNABLE;
8010365a:	e8 56 fb ff ff       	call   801031b5 <myproc>
8010365f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103666:	e8 57 fe ff ff       	call   801034c2 <sched>
  release(&ptable.lock);
8010366b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103672:	e8 ad 07 00 00       	call   80103e24 <release>
}
80103677:	83 c4 10             	add    $0x10,%esp
8010367a:	c9                   	leave  
8010367b:	c3                   	ret    

8010367c <sleep>:
{
8010367c:	55                   	push   %ebp
8010367d:	89 e5                	mov    %esp,%ebp
8010367f:	56                   	push   %esi
80103680:	53                   	push   %ebx
80103681:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103684:	e8 2c fb ff ff       	call   801031b5 <myproc>
  if (p == 0)
80103689:	85 c0                	test   %eax,%eax
8010368b:	74 66                	je     801036f3 <sleep+0x77>
8010368d:	89 c3                	mov    %eax,%ebx
  if (lk == 0)
8010368f:	85 f6                	test   %esi,%esi
80103691:	74 6d                	je     80103700 <sleep+0x84>
  if (lk != &ptable.lock)
80103693:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103699:	74 18                	je     801036b3 <sleep+0x37>
    acquire(&ptable.lock); // DOC: sleeplock1
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	68 20 1d 11 80       	push   $0x80111d20
801036a3:	e8 17 07 00 00       	call   80103dbf <acquire>
    release(lk);
801036a8:	89 34 24             	mov    %esi,(%esp)
801036ab:	e8 74 07 00 00       	call   80103e24 <release>
801036b0:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801036b3:	8b 45 08             	mov    0x8(%ebp),%eax
801036b6:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801036b9:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801036c0:	e8 fd fd ff ff       	call   801034c2 <sched>
  p->chan = 0;
801036c5:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if (lk != &ptable.lock)
801036cc:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801036d2:	74 18                	je     801036ec <sleep+0x70>
    release(&ptable.lock);
801036d4:	83 ec 0c             	sub    $0xc,%esp
801036d7:	68 20 1d 11 80       	push   $0x80111d20
801036dc:	e8 43 07 00 00       	call   80103e24 <release>
    acquire(lk);
801036e1:	89 34 24             	mov    %esi,(%esp)
801036e4:	e8 d6 06 00 00       	call   80103dbf <acquire>
801036e9:	83 c4 10             	add    $0x10,%esp
}
801036ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036ef:	5b                   	pop    %ebx
801036f0:	5e                   	pop    %esi
801036f1:	5d                   	pop    %ebp
801036f2:	c3                   	ret    
    panic("sleep");
801036f3:	83 ec 0c             	sub    $0xc,%esp
801036f6:	68 94 6f 10 80       	push   $0x80106f94
801036fb:	e8 48 cc ff ff       	call   80100348 <panic>
    panic("sleep without lk");
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	68 9a 6f 10 80       	push   $0x80106f9a
80103708:	e8 3b cc ff ff       	call   80100348 <panic>

8010370d <wait>:
{
8010370d:	55                   	push   %ebp
8010370e:	89 e5                	mov    %esp,%ebp
80103710:	56                   	push   %esi
80103711:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103712:	e8 9e fa ff ff       	call   801031b5 <myproc>
80103717:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103719:	83 ec 0c             	sub    $0xc,%esp
8010371c:	68 20 1d 11 80       	push   $0x80111d20
80103721:	e8 99 06 00 00       	call   80103dbf <acquire>
80103726:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103729:	b8 00 00 00 00       	mov    $0x0,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010372e:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103733:	eb 5b                	jmp    80103790 <wait+0x83>
        pid = p->pid;
80103735:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103738:	83 ec 0c             	sub    $0xc,%esp
8010373b:	ff 73 08             	push   0x8(%ebx)
8010373e:	e8 49 e8 ff ff       	call   80101f8c <kfree>
        p->kstack = 0;
80103743:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010374a:	83 c4 04             	add    $0x4,%esp
8010374d:	ff 73 04             	push   0x4(%ebx)
80103750:	e8 35 2f 00 00       	call   8010668a <freevm>
        p->pid = 0;
80103755:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010375c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103763:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103767:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010376e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103775:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010377c:	e8 a3 06 00 00       	call   80103e24 <release>
        return pid;
80103781:	83 c4 10             	add    $0x10,%esp
}
80103784:	89 f0                	mov    %esi,%eax
80103786:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103789:	5b                   	pop    %ebx
8010378a:	5e                   	pop    %esi
8010378b:	5d                   	pop    %ebp
8010378c:	c3                   	ret    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010378d:	83 eb 80             	sub    $0xffffff80,%ebx
80103790:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103796:	73 12                	jae    801037aa <wait+0x9d>
      if (p->parent != curproc)
80103798:	39 73 14             	cmp    %esi,0x14(%ebx)
8010379b:	75 f0                	jne    8010378d <wait+0x80>
      if (p->state == ZOMBIE)
8010379d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037a1:	74 92                	je     80103735 <wait+0x28>
      havekids = 1;
801037a3:	b8 01 00 00 00       	mov    $0x1,%eax
801037a8:	eb e3                	jmp    8010378d <wait+0x80>
    if (!havekids || curproc->killed)
801037aa:	85 c0                	test   %eax,%eax
801037ac:	74 06                	je     801037b4 <wait+0xa7>
801037ae:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801037b2:	74 17                	je     801037cb <wait+0xbe>
      release(&ptable.lock);
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 20 1d 11 80       	push   $0x80111d20
801037bc:	e8 63 06 00 00       	call   80103e24 <release>
      return -1;
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	be ff ff ff ff       	mov    $0xffffffff,%esi
801037c9:	eb b9                	jmp    80103784 <wait+0x77>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801037cb:	83 ec 08             	sub    $0x8,%esp
801037ce:	68 20 1d 11 80       	push   $0x80111d20
801037d3:	56                   	push   %esi
801037d4:	e8 a3 fe ff ff       	call   8010367c <sleep>
    havekids = 0;
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	e9 48 ff ff ff       	jmp    80103729 <wait+0x1c>

801037e1 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801037e1:	55                   	push   %ebp
801037e2:	89 e5                	mov    %esp,%ebp
801037e4:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801037e7:	68 20 1d 11 80       	push   $0x80111d20
801037ec:	e8 ce 05 00 00       	call   80103dbf <acquire>
  wakeup1(chan);
801037f1:	8b 45 08             	mov    0x8(%ebp),%eax
801037f4:	e8 03 f8 ff ff       	call   80102ffc <wakeup1>
  release(&ptable.lock);
801037f9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103800:	e8 1f 06 00 00       	call   80103e24 <release>
}
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	c9                   	leave  
80103809:	c3                   	ret    

8010380a <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
8010380a:	55                   	push   %ebp
8010380b:	89 e5                	mov    %esp,%ebp
8010380d:	53                   	push   %ebx
8010380e:	83 ec 10             	sub    $0x10,%esp
80103811:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103814:	68 20 1d 11 80       	push   $0x80111d20
80103819:	e8 a1 05 00 00       	call   80103dbf <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010381e:	83 c4 10             	add    $0x10,%esp
80103821:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103826:	eb 0c                	jmp    80103834 <kill+0x2a>
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
80103828:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010382f:	eb 1c                	jmp    8010384d <kill+0x43>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103831:	83 e8 80             	sub    $0xffffff80,%eax
80103834:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103839:	73 2c                	jae    80103867 <kill+0x5d>
    if (p->pid == pid)
8010383b:	39 58 10             	cmp    %ebx,0x10(%eax)
8010383e:	75 f1                	jne    80103831 <kill+0x27>
      p->killed = 1;
80103840:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80103847:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010384b:	74 db                	je     80103828 <kill+0x1e>
      release(&ptable.lock);
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 20 1d 11 80       	push   $0x80111d20
80103855:	e8 ca 05 00 00       	call   80103e24 <release>
      return 0;
8010385a:	83 c4 10             	add    $0x10,%esp
8010385d:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103865:	c9                   	leave  
80103866:	c3                   	ret    
  release(&ptable.lock);
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 20 1d 11 80       	push   $0x80111d20
8010386f:	e8 b0 05 00 00       	call   80103e24 <release>
  return -1;
80103874:	83 c4 10             	add    $0x10,%esp
80103877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010387c:	eb e4                	jmp    80103862 <kill+0x58>

8010387e <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	56                   	push   %esi
80103882:	53                   	push   %ebx
80103883:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103886:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010388b:	eb 33                	jmp    801038c0 <procdump+0x42>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
8010388d:	b8 ab 6f 10 80       	mov    $0x80106fab,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103892:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103895:	52                   	push   %edx
80103896:	50                   	push   %eax
80103897:	ff 73 10             	push   0x10(%ebx)
8010389a:	68 af 6f 10 80       	push   $0x80106faf
8010389f:	e8 63 cd ff ff       	call   80100607 <cprintf>
    if (p->state == SLEEPING)
801038a4:	83 c4 10             	add    $0x10,%esp
801038a7:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801038ab:	74 39                	je     801038e6 <procdump+0x68>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 17 74 10 80       	push   $0x80107417
801038b5:	e8 4d cd ff ff       	call   80100607 <cprintf>
801038ba:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038bd:	83 eb 80             	sub    $0xffffff80,%ebx
801038c0:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801038c6:	73 61                	jae    80103929 <procdump+0xab>
    if (p->state == UNUSED)
801038c8:	8b 43 0c             	mov    0xc(%ebx),%eax
801038cb:	85 c0                	test   %eax,%eax
801038cd:	74 ee                	je     801038bd <procdump+0x3f>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801038cf:	83 f8 05             	cmp    $0x5,%eax
801038d2:	77 b9                	ja     8010388d <procdump+0xf>
801038d4:	8b 04 85 68 70 10 80 	mov    -0x7fef8f98(,%eax,4),%eax
801038db:	85 c0                	test   %eax,%eax
801038dd:	75 b3                	jne    80103892 <procdump+0x14>
      state = "???";
801038df:	b8 ab 6f 10 80       	mov    $0x80106fab,%eax
801038e4:	eb ac                	jmp    80103892 <procdump+0x14>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801038e6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801038e9:	8b 40 0c             	mov    0xc(%eax),%eax
801038ec:	83 c0 08             	add    $0x8,%eax
801038ef:	83 ec 08             	sub    $0x8,%esp
801038f2:	8d 55 d0             	lea    -0x30(%ebp),%edx
801038f5:	52                   	push   %edx
801038f6:	50                   	push   %eax
801038f7:	e8 a2 03 00 00       	call   80103c9e <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801038fc:	83 c4 10             	add    $0x10,%esp
801038ff:	be 00 00 00 00       	mov    $0x0,%esi
80103904:	eb 14                	jmp    8010391a <procdump+0x9c>
        cprintf(" %p", pc[i]);
80103906:	83 ec 08             	sub    $0x8,%esp
80103909:	50                   	push   %eax
8010390a:	68 01 6a 10 80       	push   $0x80106a01
8010390f:	e8 f3 cc ff ff       	call   80100607 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103914:	83 c6 01             	add    $0x1,%esi
80103917:	83 c4 10             	add    $0x10,%esp
8010391a:	83 fe 09             	cmp    $0x9,%esi
8010391d:	7f 8e                	jg     801038ad <procdump+0x2f>
8010391f:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103923:	85 c0                	test   %eax,%eax
80103925:	75 df                	jne    80103906 <procdump+0x88>
80103927:	eb 84                	jmp    801038ad <procdump+0x2f>
  }
}
80103929:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010392c:	5b                   	pop    %ebx
8010392d:	5e                   	pop    %esi
8010392e:	5d                   	pop    %ebp
8010392f:	c3                   	ret    

80103930 <getppid>:

int getppid()
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
  struct proc *p;
  // p=ptable.proc;
  // int pid=myproc()->pid;
  // cprintf("\ncurrent process pid is %d\n",pid);
  // p=
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103935:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010393a:	eb 03                	jmp    8010393f <getppid+0xf>
8010393c:	83 eb 80             	sub    $0xffffff80,%ebx
8010393f:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103945:	73 1d                	jae    80103964 <getppid+0x34>
  {
    if (p->parent->pid == myproc()->parent->pid)
80103947:	8b 43 14             	mov    0x14(%ebx),%eax
8010394a:	8b 70 10             	mov    0x10(%eax),%esi
8010394d:	e8 63 f8 ff ff       	call   801031b5 <myproc>
80103952:	8b 40 14             	mov    0x14(%eax),%eax
80103955:	3b 70 10             	cmp    0x10(%eax),%esi
80103958:	75 e2                	jne    8010393c <getppid+0xc>
    {
      ppid = p->parent->pid;
8010395a:	8b 43 14             	mov    0x14(%ebx),%eax
8010395d:	8b 40 10             	mov    0x10(%eax),%eax
      return ppid;
    }
  }
  return -1;
}
80103960:	5b                   	pop    %ebx
80103961:	5e                   	pop    %esi
80103962:	5d                   	pop    %ebp
80103963:	c3                   	ret    
  return -1;
80103964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103969:	eb f5                	jmp    80103960 <getppid+0x30>

8010396b <get_siblings_info>:

// static struct proc *
int get_siblings_info(int pid)
{
8010396b:	55                   	push   %ebp
8010396c:	89 e5                	mov    %esp,%ebp
8010396e:	56                   	push   %esi
8010396f:	53                   	push   %ebx
80103970:	8b 75 08             	mov    0x8(%ebp),%esi
  // cprintf("in proc %d\n",pid);
  struct proc *p;
  // enum procstate;
  // struct proc *curproc = myproc();
  acquire(&ptable.lock);
80103973:	83 ec 0c             	sub    $0xc,%esp
80103976:	68 20 1d 11 80       	push   $0x80111d20
8010397b:	e8 3f 04 00 00       	call   80103dbf <acquire>
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103988:	eb 03                	jmp    8010398d <get_siblings_info+0x22>
8010398a:	83 eb 80             	sub    $0xffffff80,%ebx
8010398d:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103993:	73 4d                	jae    801039e2 <get_siblings_info+0x77>
  {
    if (p->parent->pid == pid)
80103995:	8b 43 14             	mov    0x14(%ebx),%eax
80103998:	39 70 10             	cmp    %esi,0x10(%eax)
8010399b:	75 ed                	jne    8010398a <get_siblings_info+0x1f>
    {
      cprintf("%d %s\n", p->pid, states[p->state]);
8010399d:	8b 43 0c             	mov    0xc(%ebx),%eax
801039a0:	83 ec 04             	sub    $0x4,%esp
801039a3:	ff 34 85 50 70 10 80 	push   -0x7fef8fb0(,%eax,4)
801039aa:	ff 73 10             	push   0x10(%ebx)
801039ad:	68 b8 6f 10 80       	push   $0x80106fb8
801039b2:	e8 50 cc ff ff       	call   80100607 <cprintf>
      cprintf("ppid here%d\n", p->parent->pid);
801039b7:	8b 43 14             	mov    0x14(%ebx),%eax
801039ba:	83 c4 08             	add    $0x8,%esp
801039bd:	ff 70 10             	push   0x10(%eax)
801039c0:	68 bf 6f 10 80       	push   $0x80106fbf
801039c5:	e8 3d cc ff ff       	call   80100607 <cprintf>
      cprintf("ppid func%d\n", getppid());
801039ca:	e8 61 ff ff ff       	call   80103930 <getppid>
801039cf:	83 c4 08             	add    $0x8,%esp
801039d2:	50                   	push   %eax
801039d3:	68 cc 6f 10 80       	push   $0x80106fcc
801039d8:	e8 2a cc ff ff       	call   80100607 <cprintf>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	eb a8                	jmp    8010398a <get_siblings_info+0x1f>
    // cprintf("%s\n", curproc->state);
    // cprintf("state is: %s\n", p->state);
  }

  // cprintf("this is the state%s\n",procstate[p->state]);
  release(&ptable.lock);
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	68 20 1d 11 80       	push   $0x80111d20
801039ea:	e8 35 04 00 00       	call   80103e24 <release>
  return 0;
}
801039ef:	b8 00 00 00 00       	mov    $0x0,%eax
801039f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039f7:	5b                   	pop    %ebx
801039f8:	5e                   	pop    %esi
801039f9:	5d                   	pop    %ebp
801039fa:	c3                   	ret    

801039fb <compare>:

//program to compare two strings
int compare(char a[],char b[])  
{  
801039fb:	55                   	push   %ebp
801039fc:	89 e5                	mov    %esp,%ebp
801039fe:	56                   	push   %esi
801039ff:	53                   	push   %ebx
80103a00:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a03:	8b 75 0c             	mov    0xc(%ebp),%esi
    int flag=0,i=0;  // integer variables declaration  
80103a06:	b8 00 00 00 00       	mov    $0x0,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80103a0b:	eb 03                	jmp    80103a10 <compare+0x15>
       if(a[i]!=b[i])  
       {  
           flag=1;  
           break;  
       }  
       i++;  
80103a0d:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80103a10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80103a14:	84 d2                	test   %dl,%dl
80103a16:	74 1a                	je     80103a32 <compare+0x37>
80103a18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80103a1c:	84 c9                	test   %cl,%cl
80103a1e:	74 0b                	je     80103a2b <compare+0x30>
       if(a[i]!=b[i])  
80103a20:	38 ca                	cmp    %cl,%dl
80103a22:	74 e9                	je     80103a0d <compare+0x12>
           flag=1;  
80103a24:	b8 01 00 00 00       	mov    $0x1,%eax
80103a29:	eb 0c                	jmp    80103a37 <compare+0x3c>
    int flag=0,i=0;  // integer variables declaration  
80103a2b:	b8 00 00 00 00       	mov    $0x0,%eax
80103a30:	eb 05                	jmp    80103a37 <compare+0x3c>
80103a32:	b8 00 00 00 00       	mov    $0x0,%eax
    }  
    if(flag==0)  
80103a37:	85 c0                	test   %eax,%eax
80103a39:	75 09                	jne    80103a44 <compare+0x49>
    return 1;  
80103a3b:	b8 01 00 00 00       	mov    $0x1,%eax
    else  
    return 0;  
}  
80103a40:	5b                   	pop    %ebx
80103a41:	5e                   	pop    %esi
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    
    return 0;  
80103a44:	b8 00 00 00 00       	mov    $0x0,%eax
80103a49:	eb f5                	jmp    80103a40 <compare+0x45>

80103a4b <signalProcess>:

void signalProcess(int pid, char type[]){
80103a4b:	55                   	push   %ebp
80103a4c:	89 e5                	mov    %esp,%ebp
80103a4e:	57                   	push   %edi
80103a4f:	56                   	push   %esi
80103a50:	53                   	push   %ebx
80103a51:	83 ec 18             	sub    $0x18,%esp
80103a54:	8b 75 08             	mov    0x8(%ebp),%esi
80103a57:	8b 7d 0c             	mov    0xc(%ebp),%edi
  // cprintf("%d\n%d\n",pid,myproc()->pid);

  struct proc *p;
  acquire(&ptable.lock);
80103a5a:	68 20 1d 11 80       	push   $0x80111d20
80103a5f:	e8 5b 03 00 00       	call   80103dbf <acquire>
  // char type1=type[0];
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80103a64:	83 c4 10             	add    $0x10,%esp
80103a67:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103a6c:	eb 4b                	jmp    80103ab9 <signalProcess+0x6e>
    if(pid==p->pid){
      // p->state=type1;
      if(compare(type,"PAUSE")){
        cprintf("pause");
80103a6e:	83 ec 0c             	sub    $0xc,%esp
80103a71:	68 df 6f 10 80       	push   $0x80106fdf
80103a76:	e8 8c cb ff ff       	call   80100607 <cprintf>
        p->PAUSE=1;
80103a7b:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
        break;
80103a82:	83 c4 10             	add    $0x10,%esp
        break;
      }

    }
  }
  release(&ptable.lock);
80103a85:	83 ec 0c             	sub    $0xc,%esp
80103a88:	68 20 1d 11 80       	push   $0x80111d20
80103a8d:	e8 92 03 00 00       	call   80103e24 <release>
  // sched();
}
80103a92:	83 c4 10             	add    $0x10,%esp
80103a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a98:	5b                   	pop    %ebx
80103a99:	5e                   	pop    %esi
80103a9a:	5f                   	pop    %edi
80103a9b:	5d                   	pop    %ebp
80103a9c:	c3                   	ret    
        cprintf("continue");
80103a9d:	83 ec 0c             	sub    $0xc,%esp
80103aa0:	68 ee 6f 10 80       	push   $0x80106fee
80103aa5:	e8 5d cb ff ff       	call   80100607 <cprintf>
        p->PAUSE=0;
80103aaa:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        break;
80103ab1:	83 c4 10             	add    $0x10,%esp
80103ab4:	eb cf                	jmp    80103a85 <signalProcess+0x3a>
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80103ab6:	83 eb 80             	sub    $0xffffff80,%ebx
80103ab9:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103abf:	73 c4                	jae    80103a85 <signalProcess+0x3a>
    if(pid==p->pid){
80103ac1:	39 73 10             	cmp    %esi,0x10(%ebx)
80103ac4:	75 f0                	jne    80103ab6 <signalProcess+0x6b>
      if(compare(type,"PAUSE")){
80103ac6:	83 ec 08             	sub    $0x8,%esp
80103ac9:	68 d9 6f 10 80       	push   $0x80106fd9
80103ace:	57                   	push   %edi
80103acf:	e8 27 ff ff ff       	call   801039fb <compare>
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	85 c0                	test   %eax,%eax
80103ad9:	75 93                	jne    80103a6e <signalProcess+0x23>
      if(compare(type,"CONTINUE")){
80103adb:	83 ec 08             	sub    $0x8,%esp
80103ade:	68 e5 6f 10 80       	push   $0x80106fe5
80103ae3:	57                   	push   %edi
80103ae4:	e8 12 ff ff ff       	call   801039fb <compare>
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	85 c0                	test   %eax,%eax
80103aee:	75 ad                	jne    80103a9d <signalProcess+0x52>
      if(compare(type,"KILL")){
80103af0:	83 ec 08             	sub    $0x8,%esp
80103af3:	68 f7 6f 10 80       	push   $0x80106ff7
80103af8:	57                   	push   %edi
80103af9:	e8 fd fe ff ff       	call   801039fb <compare>
80103afe:	83 c4 10             	add    $0x10,%esp
80103b01:	85 c0                	test   %eax,%eax
80103b03:	74 b1                	je     80103ab6 <signalProcess+0x6b>
        p->state=ZOMBIE;
80103b05:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
        break;
80103b0c:	e9 74 ff ff ff       	jmp    80103a85 <signalProcess+0x3a>

80103b11 <numvp>:

int numvp(){
80103b11:	55                   	push   %ebp
80103b12:	89 e5                	mov    %esp,%ebp
80103b14:	83 ec 08             	sub    $0x8,%esp
  int x = myproc()->sz/PGSIZE;
80103b17:	e8 99 f6 ff ff       	call   801031b5 <myproc>
80103b1c:	8b 00                	mov    (%eax),%eax
80103b1e:	c1 e8 0c             	shr    $0xc,%eax
  // return retNumvp();
  return x;
}
80103b21:	c9                   	leave  
80103b22:	c3                   	ret    

80103b23 <numpp>:

int numpp(){
80103b23:	55                   	push   %ebp
80103b24:	89 e5                	mov    %esp,%ebp
80103b26:	83 ec 08             	sub    $0x8,%esp
  return retNumpp();
80103b29:	e8 19 2e 00 00       	call   80106947 <retNumpp>
}
80103b2e:	c9                   	leave  
80103b2f:	c3                   	ret    

80103b30 <init_mylock>:

int init_mylock(){
  return 0;
}
80103b30:	b8 00 00 00 00       	mov    $0x0,%eax
80103b35:	c3                   	ret    

80103b36 <acquire_mylock>:

int acquire_mylock(int id){
80103b36:	55                   	push   %ebp
80103b37:	89 e5                	mov    %esp,%ebp
80103b39:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103b3c:	8d 45 08             	lea    0x8(%ebp),%eax
80103b3f:	50                   	push   %eax
80103b40:	6a 00                	push   $0x0
80103b42:	e8 74 05 00 00       	call   801040bb <argint>
  return id;
}
80103b47:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4a:	c9                   	leave  
80103b4b:	c3                   	ret    

80103b4c <release_mylock>:

int release_mylock(int id){
80103b4c:	55                   	push   %ebp
80103b4d:	89 e5                	mov    %esp,%ebp
80103b4f:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103b52:	8d 45 08             	lea    0x8(%ebp),%eax
80103b55:	50                   	push   %eax
80103b56:	6a 00                	push   $0x0
80103b58:	e8 5e 05 00 00       	call   801040bb <argint>
  return id;
}
80103b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b60:	c9                   	leave  
80103b61:	c3                   	ret    

80103b62 <holding_mylock>:

int holding_mylock(int id){
80103b62:	55                   	push   %ebp
80103b63:	89 e5                	mov    %esp,%ebp
80103b65:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103b68:	8d 45 08             	lea    0x8(%ebp),%eax
80103b6b:	50                   	push   %eax
80103b6c:	6a 00                	push   $0x0
80103b6e:	e8 48 05 00 00       	call   801040bb <argint>
  return id;
80103b73:	8b 45 08             	mov    0x8(%ebp),%eax
80103b76:	c9                   	leave  
80103b77:	c3                   	ret    

80103b78 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b78:	55                   	push   %ebp
80103b79:	89 e5                	mov    %esp,%ebp
80103b7b:	53                   	push   %ebx
80103b7c:	83 ec 0c             	sub    $0xc,%esp
80103b7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b82:	68 80 70 10 80       	push   $0x80107080
80103b87:	8d 43 04             	lea    0x4(%ebx),%eax
80103b8a:	50                   	push   %eax
80103b8b:	e8 f3 00 00 00       	call   80103c83 <initlock>
  lk->name = name;
80103b90:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b93:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b9c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ba9:	c9                   	leave  
80103baa:	c3                   	ret    

80103bab <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103bab:	55                   	push   %ebp
80103bac:	89 e5                	mov    %esp,%ebp
80103bae:	56                   	push   %esi
80103baf:	53                   	push   %ebx
80103bb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103bb3:	8d 73 04             	lea    0x4(%ebx),%esi
80103bb6:	83 ec 0c             	sub    $0xc,%esp
80103bb9:	56                   	push   %esi
80103bba:	e8 00 02 00 00       	call   80103dbf <acquire>
  while (lk->locked) {
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	eb 0d                	jmp    80103bd1 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103bc4:	83 ec 08             	sub    $0x8,%esp
80103bc7:	56                   	push   %esi
80103bc8:	53                   	push   %ebx
80103bc9:	e8 ae fa ff ff       	call   8010367c <sleep>
80103bce:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103bd1:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bd4:	75 ee                	jne    80103bc4 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103bd6:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103bdc:	e8 d4 f5 ff ff       	call   801031b5 <myproc>
80103be1:	8b 40 10             	mov    0x10(%eax),%eax
80103be4:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103be7:	83 ec 0c             	sub    $0xc,%esp
80103bea:	56                   	push   %esi
80103beb:	e8 34 02 00 00       	call   80103e24 <release>
}
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf6:	5b                   	pop    %ebx
80103bf7:	5e                   	pop    %esi
80103bf8:	5d                   	pop    %ebp
80103bf9:	c3                   	ret    

80103bfa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103bfa:	55                   	push   %ebp
80103bfb:	89 e5                	mov    %esp,%ebp
80103bfd:	56                   	push   %esi
80103bfe:	53                   	push   %ebx
80103bff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103c02:	8d 73 04             	lea    0x4(%ebx),%esi
80103c05:	83 ec 0c             	sub    $0xc,%esp
80103c08:	56                   	push   %esi
80103c09:	e8 b1 01 00 00       	call   80103dbf <acquire>
  lk->locked = 0;
80103c0e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103c14:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103c1b:	89 1c 24             	mov    %ebx,(%esp)
80103c1e:	e8 be fb ff ff       	call   801037e1 <wakeup>
  release(&lk->lk);
80103c23:	89 34 24             	mov    %esi,(%esp)
80103c26:	e8 f9 01 00 00       	call   80103e24 <release>
}
80103c2b:	83 c4 10             	add    $0x10,%esp
80103c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c31:	5b                   	pop    %ebx
80103c32:	5e                   	pop    %esi
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    

80103c35 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
80103c38:	56                   	push   %esi
80103c39:	53                   	push   %ebx
80103c3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103c3d:	8d 73 04             	lea    0x4(%ebx),%esi
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	56                   	push   %esi
80103c44:	e8 76 01 00 00       	call   80103dbf <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c4f:	75 17                	jne    80103c68 <holdingsleep+0x33>
80103c51:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	56                   	push   %esi
80103c5a:	e8 c5 01 00 00       	call   80103e24 <release>
  return r;
}
80103c5f:	89 d8                	mov    %ebx,%eax
80103c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c64:	5b                   	pop    %ebx
80103c65:	5e                   	pop    %esi
80103c66:	5d                   	pop    %ebp
80103c67:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103c68:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103c6b:	e8 45 f5 ff ff       	call   801031b5 <myproc>
80103c70:	3b 58 10             	cmp    0x10(%eax),%ebx
80103c73:	74 07                	je     80103c7c <holdingsleep+0x47>
80103c75:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c7a:	eb da                	jmp    80103c56 <holdingsleep+0x21>
80103c7c:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c81:	eb d3                	jmp    80103c56 <holdingsleep+0x21>

80103c83 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c83:	55                   	push   %ebp
80103c84:	89 e5                	mov    %esp,%ebp
80103c86:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c89:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c8c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c9c:	5d                   	pop    %ebp
80103c9d:	c3                   	ret    

80103c9e <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c9e:	55                   	push   %ebp
80103c9f:	89 e5                	mov    %esp,%ebp
80103ca1:	53                   	push   %ebx
80103ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca8:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103cab:	b8 00 00 00 00       	mov    $0x0,%eax
80103cb0:	83 f8 09             	cmp    $0x9,%eax
80103cb3:	7f 25                	jg     80103cda <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103cb5:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103cbb:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103cc1:	77 17                	ja     80103cda <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103cc3:	8b 5a 04             	mov    0x4(%edx),%ebx
80103cc6:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103cc9:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103ccb:	83 c0 01             	add    $0x1,%eax
80103cce:	eb e0                	jmp    80103cb0 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103cd0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103cd7:	83 c0 01             	add    $0x1,%eax
80103cda:	83 f8 09             	cmp    $0x9,%eax
80103cdd:	7e f1                	jle    80103cd0 <getcallerpcs+0x32>
}
80103cdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ce2:	c9                   	leave  
80103ce3:	c3                   	ret    

80103ce4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	53                   	push   %ebx
80103ce8:	83 ec 04             	sub    $0x4,%esp
80103ceb:	9c                   	pushf  
80103cec:	5b                   	pop    %ebx
  asm volatile("cli");
80103ced:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103cee:	e8 4b f4 ff ff       	call   8010313e <mycpu>
80103cf3:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cfa:	74 11                	je     80103d0d <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103cfc:	e8 3d f4 ff ff       	call   8010313e <mycpu>
80103d01:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0b:	c9                   	leave  
80103d0c:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103d0d:	e8 2c f4 ff ff       	call   8010313e <mycpu>
80103d12:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103d18:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103d1e:	eb dc                	jmp    80103cfc <pushcli+0x18>

80103d20 <popcli>:

void
popcli(void)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d26:	9c                   	pushf  
80103d27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d28:	f6 c4 02             	test   $0x2,%ah
80103d2b:	75 28                	jne    80103d55 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103d2d:	e8 0c f4 ff ff       	call   8010313e <mycpu>
80103d32:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103d38:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103d3b:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103d41:	85 d2                	test   %edx,%edx
80103d43:	78 1d                	js     80103d62 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d45:	e8 f4 f3 ff ff       	call   8010313e <mycpu>
80103d4a:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d51:	74 1c                	je     80103d6f <popcli+0x4f>
    sti();
}
80103d53:	c9                   	leave  
80103d54:	c3                   	ret    
    panic("popcli - interruptible");
80103d55:	83 ec 0c             	sub    $0xc,%esp
80103d58:	68 8b 70 10 80       	push   $0x8010708b
80103d5d:	e8 e6 c5 ff ff       	call   80100348 <panic>
    panic("popcli");
80103d62:	83 ec 0c             	sub    $0xc,%esp
80103d65:	68 a2 70 10 80       	push   $0x801070a2
80103d6a:	e8 d9 c5 ff ff       	call   80100348 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d6f:	e8 ca f3 ff ff       	call   8010313e <mycpu>
80103d74:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d7b:	74 d6                	je     80103d53 <popcli+0x33>
  asm volatile("sti");
80103d7d:	fb                   	sti    
}
80103d7e:	eb d3                	jmp    80103d53 <popcli+0x33>

80103d80 <holding>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 04             	sub    $0x4,%esp
80103d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103d8a:	e8 55 ff ff ff       	call   80103ce4 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d8f:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d92:	75 11                	jne    80103da5 <holding+0x25>
80103d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103d99:	e8 82 ff ff ff       	call   80103d20 <popcli>
}
80103d9e:	89 d8                	mov    %ebx,%eax
80103da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da3:	c9                   	leave  
80103da4:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103da5:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103da8:	e8 91 f3 ff ff       	call   8010313e <mycpu>
80103dad:	39 c3                	cmp    %eax,%ebx
80103daf:	74 07                	je     80103db8 <holding+0x38>
80103db1:	bb 00 00 00 00       	mov    $0x0,%ebx
80103db6:	eb e1                	jmp    80103d99 <holding+0x19>
80103db8:	bb 01 00 00 00       	mov    $0x1,%ebx
80103dbd:	eb da                	jmp    80103d99 <holding+0x19>

80103dbf <acquire>:
{
80103dbf:	55                   	push   %ebp
80103dc0:	89 e5                	mov    %esp,%ebp
80103dc2:	53                   	push   %ebx
80103dc3:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103dc6:	e8 19 ff ff ff       	call   80103ce4 <pushcli>
  if(holding(lk))
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	ff 75 08             	push   0x8(%ebp)
80103dd1:	e8 aa ff ff ff       	call   80103d80 <holding>
80103dd6:	83 c4 10             	add    $0x10,%esp
80103dd9:	85 c0                	test   %eax,%eax
80103ddb:	75 3a                	jne    80103e17 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103de0:	b8 01 00 00 00       	mov    $0x1,%eax
80103de5:	f0 87 02             	lock xchg %eax,(%edx)
80103de8:	85 c0                	test   %eax,%eax
80103dea:	75 f1                	jne    80103ddd <acquire+0x1e>
  __sync_synchronize();
80103dec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103df1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103df4:	e8 45 f3 ff ff       	call   8010313e <mycpu>
80103df9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dff:	83 c0 0c             	add    $0xc,%eax
80103e02:	83 ec 08             	sub    $0x8,%esp
80103e05:	50                   	push   %eax
80103e06:	8d 45 08             	lea    0x8(%ebp),%eax
80103e09:	50                   	push   %eax
80103e0a:	e8 8f fe ff ff       	call   80103c9e <getcallerpcs>
}
80103e0f:	83 c4 10             	add    $0x10,%esp
80103e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e15:	c9                   	leave  
80103e16:	c3                   	ret    
    panic("acquire");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 a9 70 10 80       	push   $0x801070a9
80103e1f:	e8 24 c5 ff ff       	call   80100348 <panic>

80103e24 <release>:
{
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	53                   	push   %ebx
80103e28:	83 ec 10             	sub    $0x10,%esp
80103e2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103e2e:	53                   	push   %ebx
80103e2f:	e8 4c ff ff ff       	call   80103d80 <holding>
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	85 c0                	test   %eax,%eax
80103e39:	74 23                	je     80103e5e <release+0x3a>
  lk->pcs[0] = 0;
80103e3b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103e42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103e49:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103e4e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103e54:	e8 c7 fe ff ff       	call   80103d20 <popcli>
}
80103e59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e5c:	c9                   	leave  
80103e5d:	c3                   	ret    
    panic("release");
80103e5e:	83 ec 0c             	sub    $0xc,%esp
80103e61:	68 b1 70 10 80       	push   $0x801070b1
80103e66:	e8 dd c4 ff ff       	call   80100348 <panic>

80103e6b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103e6b:	55                   	push   %ebp
80103e6c:	89 e5                	mov    %esp,%ebp
80103e6e:	57                   	push   %edi
80103e6f:	53                   	push   %ebx
80103e70:	8b 55 08             	mov    0x8(%ebp),%edx
80103e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103e79:	f6 c2 03             	test   $0x3,%dl
80103e7c:	75 25                	jne    80103ea3 <memset+0x38>
80103e7e:	f6 c1 03             	test   $0x3,%cl
80103e81:	75 20                	jne    80103ea3 <memset+0x38>
    c &= 0xFF;
80103e83:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103e86:	c1 e9 02             	shr    $0x2,%ecx
80103e89:	c1 e0 18             	shl    $0x18,%eax
80103e8c:	89 fb                	mov    %edi,%ebx
80103e8e:	c1 e3 10             	shl    $0x10,%ebx
80103e91:	09 d8                	or     %ebx,%eax
80103e93:	89 fb                	mov    %edi,%ebx
80103e95:	c1 e3 08             	shl    $0x8,%ebx
80103e98:	09 d8                	or     %ebx,%eax
80103e9a:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e9c:	89 d7                	mov    %edx,%edi
80103e9e:	fc                   	cld    
80103e9f:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103ea1:	eb 05                	jmp    80103ea8 <memset+0x3d>
  asm volatile("cld; rep stosb" :
80103ea3:	89 d7                	mov    %edx,%edi
80103ea5:	fc                   	cld    
80103ea6:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103ea8:	89 d0                	mov    %edx,%eax
80103eaa:	5b                   	pop    %ebx
80103eab:	5f                   	pop    %edi
80103eac:	5d                   	pop    %ebp
80103ead:	c3                   	ret    

80103eae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103eae:	55                   	push   %ebp
80103eaf:	89 e5                	mov    %esp,%ebp
80103eb1:	56                   	push   %esi
80103eb2:	53                   	push   %ebx
80103eb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103ebc:	eb 08                	jmp    80103ec6 <memcmp+0x18>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80103ebe:	83 c1 01             	add    $0x1,%ecx
80103ec1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103ec4:	89 f0                	mov    %esi,%eax
80103ec6:	8d 70 ff             	lea    -0x1(%eax),%esi
80103ec9:	85 c0                	test   %eax,%eax
80103ecb:	74 12                	je     80103edf <memcmp+0x31>
    if(*s1 != *s2)
80103ecd:	0f b6 01             	movzbl (%ecx),%eax
80103ed0:	0f b6 1a             	movzbl (%edx),%ebx
80103ed3:	38 d8                	cmp    %bl,%al
80103ed5:	74 e7                	je     80103ebe <memcmp+0x10>
      return *s1 - *s2;
80103ed7:	0f b6 c0             	movzbl %al,%eax
80103eda:	0f b6 db             	movzbl %bl,%ebx
80103edd:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103edf:	5b                   	pop    %ebx
80103ee0:	5e                   	pop    %esi
80103ee1:	5d                   	pop    %ebp
80103ee2:	c3                   	ret    

80103ee3 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103ee3:	55                   	push   %ebp
80103ee4:	89 e5                	mov    %esp,%ebp
80103ee6:	56                   	push   %esi
80103ee7:	53                   	push   %ebx
80103ee8:	8b 75 08             	mov    0x8(%ebp),%esi
80103eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eee:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103ef1:	39 f2                	cmp    %esi,%edx
80103ef3:	73 3c                	jae    80103f31 <memmove+0x4e>
80103ef5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103ef8:	39 f1                	cmp    %esi,%ecx
80103efa:	76 39                	jbe    80103f35 <memmove+0x52>
    s += n;
    d += n;
80103efc:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103eff:	eb 0d                	jmp    80103f0e <memmove+0x2b>
      *--d = *--s;
80103f01:	83 e9 01             	sub    $0x1,%ecx
80103f04:	83 ea 01             	sub    $0x1,%edx
80103f07:	0f b6 01             	movzbl (%ecx),%eax
80103f0a:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103f0c:	89 d8                	mov    %ebx,%eax
80103f0e:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103f11:	85 c0                	test   %eax,%eax
80103f13:	75 ec                	jne    80103f01 <memmove+0x1e>
80103f15:	eb 14                	jmp    80103f2b <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103f17:	0f b6 02             	movzbl (%edx),%eax
80103f1a:	88 01                	mov    %al,(%ecx)
80103f1c:	8d 49 01             	lea    0x1(%ecx),%ecx
80103f1f:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103f22:	89 d8                	mov    %ebx,%eax
80103f24:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103f27:	85 c0                	test   %eax,%eax
80103f29:	75 ec                	jne    80103f17 <memmove+0x34>

  return dst;
}
80103f2b:	89 f0                	mov    %esi,%eax
80103f2d:	5b                   	pop    %ebx
80103f2e:	5e                   	pop    %esi
80103f2f:	5d                   	pop    %ebp
80103f30:	c3                   	ret    
80103f31:	89 f1                	mov    %esi,%ecx
80103f33:	eb ef                	jmp    80103f24 <memmove+0x41>
80103f35:	89 f1                	mov    %esi,%ecx
80103f37:	eb eb                	jmp    80103f24 <memmove+0x41>

80103f39 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103f39:	55                   	push   %ebp
80103f3a:	89 e5                	mov    %esp,%ebp
80103f3c:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103f3f:	ff 75 10             	push   0x10(%ebp)
80103f42:	ff 75 0c             	push   0xc(%ebp)
80103f45:	ff 75 08             	push   0x8(%ebp)
80103f48:	e8 96 ff ff ff       	call   80103ee3 <memmove>
}
80103f4d:	c9                   	leave  
80103f4e:	c3                   	ret    

80103f4f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103f4f:	55                   	push   %ebp
80103f50:	89 e5                	mov    %esp,%ebp
80103f52:	53                   	push   %ebx
80103f53:	8b 55 08             	mov    0x8(%ebp),%edx
80103f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f59:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103f5c:	eb 09                	jmp    80103f67 <strncmp+0x18>
    n--, p++, q++;
80103f5e:	83 e8 01             	sub    $0x1,%eax
80103f61:	83 c2 01             	add    $0x1,%edx
80103f64:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103f67:	85 c0                	test   %eax,%eax
80103f69:	74 0b                	je     80103f76 <strncmp+0x27>
80103f6b:	0f b6 1a             	movzbl (%edx),%ebx
80103f6e:	84 db                	test   %bl,%bl
80103f70:	74 04                	je     80103f76 <strncmp+0x27>
80103f72:	3a 19                	cmp    (%ecx),%bl
80103f74:	74 e8                	je     80103f5e <strncmp+0xf>
  if(n == 0)
80103f76:	85 c0                	test   %eax,%eax
80103f78:	74 0d                	je     80103f87 <strncmp+0x38>
    return 0;
  return (uchar)*p - (uchar)*q;
80103f7a:	0f b6 02             	movzbl (%edx),%eax
80103f7d:	0f b6 11             	movzbl (%ecx),%edx
80103f80:	29 d0                	sub    %edx,%eax
}
80103f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f85:	c9                   	leave  
80103f86:	c3                   	ret    
    return 0;
80103f87:	b8 00 00 00 00       	mov    $0x0,%eax
80103f8c:	eb f4                	jmp    80103f82 <strncmp+0x33>

80103f8e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103f8e:	55                   	push   %ebp
80103f8f:	89 e5                	mov    %esp,%ebp
80103f91:	57                   	push   %edi
80103f92:	56                   	push   %esi
80103f93:	53                   	push   %ebx
80103f94:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f9d:	89 fa                	mov    %edi,%edx
80103f9f:	eb 04                	jmp    80103fa5 <strncpy+0x17>
80103fa1:	89 f1                	mov    %esi,%ecx
80103fa3:	89 da                	mov    %ebx,%edx
80103fa5:	89 c3                	mov    %eax,%ebx
80103fa7:	83 e8 01             	sub    $0x1,%eax
80103faa:	85 db                	test   %ebx,%ebx
80103fac:	7e 11                	jle    80103fbf <strncpy+0x31>
80103fae:	8d 71 01             	lea    0x1(%ecx),%esi
80103fb1:	8d 5a 01             	lea    0x1(%edx),%ebx
80103fb4:	0f b6 09             	movzbl (%ecx),%ecx
80103fb7:	88 0a                	mov    %cl,(%edx)
80103fb9:	84 c9                	test   %cl,%cl
80103fbb:	75 e4                	jne    80103fa1 <strncpy+0x13>
80103fbd:	89 da                	mov    %ebx,%edx
    ;
  while(n-- > 0)
80103fbf:	8d 48 ff             	lea    -0x1(%eax),%ecx
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	7e 0a                	jle    80103fd0 <strncpy+0x42>
    *s++ = 0;
80103fc6:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80103fc9:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
80103fcb:	8d 52 01             	lea    0x1(%edx),%edx
80103fce:	eb ef                	jmp    80103fbf <strncpy+0x31>
  return os;
}
80103fd0:	89 f8                	mov    %edi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5f                   	pop    %edi
80103fd5:	5d                   	pop    %ebp
80103fd6:	c3                   	ret    

80103fd7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103fd7:	55                   	push   %ebp
80103fd8:	89 e5                	mov    %esp,%ebp
80103fda:	57                   	push   %edi
80103fdb:	56                   	push   %esi
80103fdc:	53                   	push   %ebx
80103fdd:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80103fe6:	85 c0                	test   %eax,%eax
80103fe8:	7e 23                	jle    8010400d <safestrcpy+0x36>
80103fea:	89 fa                	mov    %edi,%edx
80103fec:	eb 04                	jmp    80103ff2 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103fee:	89 f1                	mov    %esi,%ecx
80103ff0:	89 da                	mov    %ebx,%edx
80103ff2:	83 e8 01             	sub    $0x1,%eax
80103ff5:	85 c0                	test   %eax,%eax
80103ff7:	7e 11                	jle    8010400a <safestrcpy+0x33>
80103ff9:	8d 71 01             	lea    0x1(%ecx),%esi
80103ffc:	8d 5a 01             	lea    0x1(%edx),%ebx
80103fff:	0f b6 09             	movzbl (%ecx),%ecx
80104002:	88 0a                	mov    %cl,(%edx)
80104004:	84 c9                	test   %cl,%cl
80104006:	75 e6                	jne    80103fee <safestrcpy+0x17>
80104008:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
8010400a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
8010400d:	89 f8                	mov    %edi,%eax
8010400f:	5b                   	pop    %ebx
80104010:	5e                   	pop    %esi
80104011:	5f                   	pop    %edi
80104012:	5d                   	pop    %ebp
80104013:	c3                   	ret    

80104014 <strlen>:

int
strlen(const char *s)
{
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
8010401a:	b8 00 00 00 00       	mov    $0x0,%eax
8010401f:	eb 03                	jmp    80104024 <strlen+0x10>
80104021:	83 c0 01             	add    $0x1,%eax
80104024:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104028:	75 f7                	jne    80104021 <strlen+0xd>
    ;
  return n;
}
8010402a:	5d                   	pop    %ebp
8010402b:	c3                   	ret    

8010402c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010402c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104030:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104034:	55                   	push   %ebp
  pushl %ebx
80104035:	53                   	push   %ebx
  pushl %esi
80104036:	56                   	push   %esi
  pushl %edi
80104037:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104038:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010403a:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010403c:	5f                   	pop    %edi
  popl %esi
8010403d:	5e                   	pop    %esi
  popl %ebx
8010403e:	5b                   	pop    %ebx
  popl %ebp
8010403f:	5d                   	pop    %ebp
  ret
80104040:	c3                   	ret    

80104041 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104041:	55                   	push   %ebp
80104042:	89 e5                	mov    %esp,%ebp
80104044:	53                   	push   %ebx
80104045:	83 ec 04             	sub    $0x4,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010404b:	e8 65 f1 ff ff       	call   801031b5 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104050:	8b 00                	mov    (%eax),%eax
80104052:	39 d8                	cmp    %ebx,%eax
80104054:	76 18                	jbe    8010406e <fetchint+0x2d>
80104056:	8d 53 04             	lea    0x4(%ebx),%edx
80104059:	39 d0                	cmp    %edx,%eax
8010405b:	72 18                	jb     80104075 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
8010405d:	8b 13                	mov    (%ebx),%edx
8010405f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104062:	89 10                	mov    %edx,(%eax)
  return 0;
80104064:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104069:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010406c:	c9                   	leave  
8010406d:	c3                   	ret    
    return -1;
8010406e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104073:	eb f4                	jmp    80104069 <fetchint+0x28>
80104075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407a:	eb ed                	jmp    80104069 <fetchint+0x28>

8010407c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010407c:	55                   	push   %ebp
8010407d:	89 e5                	mov    %esp,%ebp
8010407f:	53                   	push   %ebx
80104080:	83 ec 04             	sub    $0x4,%esp
80104083:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104086:	e8 2a f1 ff ff       	call   801031b5 <myproc>

  if(addr >= curproc->sz)
8010408b:	39 18                	cmp    %ebx,(%eax)
8010408d:	76 25                	jbe    801040b4 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
8010408f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104092:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104094:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104096:	89 d8                	mov    %ebx,%eax
80104098:	eb 03                	jmp    8010409d <fetchstr+0x21>
8010409a:	83 c0 01             	add    $0x1,%eax
8010409d:	39 d0                	cmp    %edx,%eax
8010409f:	73 09                	jae    801040aa <fetchstr+0x2e>
    if(*s == 0)
801040a1:	80 38 00             	cmpb   $0x0,(%eax)
801040a4:	75 f4                	jne    8010409a <fetchstr+0x1e>
      return s - *pp;
801040a6:	29 d8                	sub    %ebx,%eax
801040a8:	eb 05                	jmp    801040af <fetchstr+0x33>
  }
  return -1;
801040aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b2:	c9                   	leave  
801040b3:	c3                   	ret    
    return -1;
801040b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040b9:	eb f4                	jmp    801040af <fetchstr+0x33>

801040bb <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801040bb:	55                   	push   %ebp
801040bc:	89 e5                	mov    %esp,%ebp
801040be:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801040c1:	e8 ef f0 ff ff       	call   801031b5 <myproc>
801040c6:	8b 50 18             	mov    0x18(%eax),%edx
801040c9:	8b 45 08             	mov    0x8(%ebp),%eax
801040cc:	c1 e0 02             	shl    $0x2,%eax
801040cf:	03 42 44             	add    0x44(%edx),%eax
801040d2:	83 ec 08             	sub    $0x8,%esp
801040d5:	ff 75 0c             	push   0xc(%ebp)
801040d8:	83 c0 04             	add    $0x4,%eax
801040db:	50                   	push   %eax
801040dc:	e8 60 ff ff ff       	call   80104041 <fetchint>
}
801040e1:	c9                   	leave  
801040e2:	c3                   	ret    

801040e3 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801040e3:	55                   	push   %ebp
801040e4:	89 e5                	mov    %esp,%ebp
801040e6:	56                   	push   %esi
801040e7:	53                   	push   %ebx
801040e8:	83 ec 10             	sub    $0x10,%esp
801040eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801040ee:	e8 c2 f0 ff ff       	call   801031b5 <myproc>
801040f3:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801040f5:	83 ec 08             	sub    $0x8,%esp
801040f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040fb:	50                   	push   %eax
801040fc:	ff 75 08             	push   0x8(%ebp)
801040ff:	e8 b7 ff ff ff       	call   801040bb <argint>
80104104:	83 c4 10             	add    $0x10,%esp
80104107:	85 c0                	test   %eax,%eax
80104109:	78 24                	js     8010412f <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010410b:	85 db                	test   %ebx,%ebx
8010410d:	78 27                	js     80104136 <argptr+0x53>
8010410f:	8b 16                	mov    (%esi),%edx
80104111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104114:	39 c2                	cmp    %eax,%edx
80104116:	76 25                	jbe    8010413d <argptr+0x5a>
80104118:	01 c3                	add    %eax,%ebx
8010411a:	39 da                	cmp    %ebx,%edx
8010411c:	72 26                	jb     80104144 <argptr+0x61>
    return -1;
  *pp = (char*)i;
8010411e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104121:	89 02                	mov    %eax,(%edx)
  return 0;
80104123:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104128:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010412b:	5b                   	pop    %ebx
8010412c:	5e                   	pop    %esi
8010412d:	5d                   	pop    %ebp
8010412e:	c3                   	ret    
    return -1;
8010412f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104134:	eb f2                	jmp    80104128 <argptr+0x45>
    return -1;
80104136:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010413b:	eb eb                	jmp    80104128 <argptr+0x45>
8010413d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104142:	eb e4                	jmp    80104128 <argptr+0x45>
80104144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104149:	eb dd                	jmp    80104128 <argptr+0x45>

8010414b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010414b:	55                   	push   %ebp
8010414c:	89 e5                	mov    %esp,%ebp
8010414e:	83 ec 20             	sub    $0x20,%esp
             * If none of the above movements works then
             * BACKTRACK: unmark x, y as part of solution
             * path
             */
  int addr;
  if(argint(n, &addr) < 0)
80104151:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104154:	50                   	push   %eax
80104155:	ff 75 08             	push   0x8(%ebp)
80104158:	e8 5e ff ff ff       	call   801040bb <argint>
8010415d:	83 c4 10             	add    $0x10,%esp
80104160:	85 c0                	test   %eax,%eax
80104162:	78 13                	js     80104177 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104164:	83 ec 08             	sub    $0x8,%esp
80104167:	ff 75 0c             	push   0xc(%ebp)
8010416a:	ff 75 f4             	push   -0xc(%ebp)
8010416d:	e8 0a ff ff ff       	call   8010407c <fetchstr>
80104172:	83 c4 10             	add    $0x10,%esp
}
80104175:	c9                   	leave  
80104176:	c3                   	ret    
    return -1;
80104177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010417c:	eb f7                	jmp    80104175 <argstr+0x2a>

8010417e <syscall>:
[SYS_holding_mylock]    sys_holding_mylock,
};

void
syscall(void)
{
8010417e:	55                   	push   %ebp
8010417f:	89 e5                	mov    %esp,%ebp
80104181:	53                   	push   %ebx
80104182:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104185:	e8 2b f0 ff ff       	call   801031b5 <myproc>
8010418a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010418c:	8b 40 18             	mov    0x18(%eax),%eax
8010418f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104192:	8d 50 ff             	lea    -0x1(%eax),%edx
80104195:	83 fa 28             	cmp    $0x28,%edx
80104198:	77 17                	ja     801041b1 <syscall+0x33>
8010419a:	8b 14 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%edx
801041a1:	85 d2                	test   %edx,%edx
801041a3:	74 0c                	je     801041b1 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
801041a5:	ff d2                	call   *%edx
801041a7:	89 c2                	mov    %eax,%edx
801041a9:	8b 43 18             	mov    0x18(%ebx),%eax
801041ac:	89 50 1c             	mov    %edx,0x1c(%eax)
801041af:	eb 1f                	jmp    801041d0 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801041b1:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
801041b4:	50                   	push   %eax
801041b5:	52                   	push   %edx
801041b6:	ff 73 10             	push   0x10(%ebx)
801041b9:	68 b9 70 10 80       	push   $0x801070b9
801041be:	e8 44 c4 ff ff       	call   80100607 <cprintf>
    curproc->tf->eax = -1;
801041c3:	8b 43 18             	mov    0x18(%ebx),%eax
801041c6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801041cd:	83 c4 10             	add    $0x10,%esp
  }
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d3:	c9                   	leave  
801041d4:	c3                   	ret    

801041d5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801041d5:	55                   	push   %ebp
801041d6:	89 e5                	mov    %esp,%ebp
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 18             	sub    $0x18,%esp
801041dd:	89 d6                	mov    %edx,%esi
801041df:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
801041e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
801041e4:	52                   	push   %edx
801041e5:	50                   	push   %eax
801041e6:	e8 d0 fe ff ff       	call   801040bb <argint>
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	85 c0                	test   %eax,%eax
801041f0:	78 35                	js     80104227 <argfd+0x52>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801041f2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801041f6:	77 28                	ja     80104220 <argfd+0x4b>
801041f8:	e8 b8 ef ff ff       	call   801031b5 <myproc>
801041fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104200:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104204:	85 c0                	test   %eax,%eax
80104206:	74 18                	je     80104220 <argfd+0x4b>
    return -1;
  if (pfd)
80104208:	85 f6                	test   %esi,%esi
8010420a:	74 02                	je     8010420e <argfd+0x39>
    *pfd = fd;
8010420c:	89 16                	mov    %edx,(%esi)
  if (pf)
8010420e:	85 db                	test   %ebx,%ebx
80104210:	74 1c                	je     8010422e <argfd+0x59>
    *pf = f;
80104212:	89 03                	mov    %eax,(%ebx)
  return 0;
80104214:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104219:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010421c:	5b                   	pop    %ebx
8010421d:	5e                   	pop    %esi
8010421e:	5d                   	pop    %ebp
8010421f:	c3                   	ret    
    return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	eb f2                	jmp    80104219 <argfd+0x44>
    return -1;
80104227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010422c:	eb eb                	jmp    80104219 <argfd+0x44>
  return 0;
8010422e:	b8 00 00 00 00       	mov    $0x0,%eax
80104233:	eb e4                	jmp    80104219 <argfd+0x44>

80104235 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104235:	55                   	push   %ebp
80104236:	89 e5                	mov    %esp,%ebp
80104238:	53                   	push   %ebx
80104239:	83 ec 04             	sub    $0x4,%esp
8010423c:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010423e:	e8 72 ef ff ff       	call   801031b5 <myproc>
80104243:	89 c2                	mov    %eax,%edx

  for (fd = 0; fd < NOFILE; fd++)
80104245:	b8 00 00 00 00       	mov    $0x0,%eax
8010424a:	83 f8 0f             	cmp    $0xf,%eax
8010424d:	7f 12                	jg     80104261 <fdalloc+0x2c>
  {
    if (curproc->ofile[fd] == 0)
8010424f:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104254:	74 05                	je     8010425b <fdalloc+0x26>
  for (fd = 0; fd < NOFILE; fd++)
80104256:	83 c0 01             	add    $0x1,%eax
80104259:	eb ef                	jmp    8010424a <fdalloc+0x15>
    {
      curproc->ofile[fd] = f;
8010425b:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
8010425f:	eb 05                	jmp    80104266 <fdalloc+0x31>
    }
  }
  return -1;
80104261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104269:	c9                   	leave  
8010426a:	c3                   	ret    

8010426b <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010426b:	55                   	push   %ebp
8010426c:	89 e5                	mov    %esp,%ebp
8010426e:	56                   	push   %esi
8010426f:	53                   	push   %ebx
80104270:	83 ec 10             	sub    $0x10,%esp
80104273:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80104275:	b8 20 00 00 00       	mov    $0x20,%eax
8010427a:	89 c6                	mov    %eax,%esi
8010427c:	39 43 58             	cmp    %eax,0x58(%ebx)
8010427f:	76 2e                	jbe    801042af <isdirempty+0x44>
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80104281:	6a 10                	push   $0x10
80104283:	50                   	push   %eax
80104284:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104287:	50                   	push   %eax
80104288:	53                   	push   %ebx
80104289:	e8 d3 d4 ff ff       	call   80101761 <readi>
8010428e:	83 c4 10             	add    $0x10,%esp
80104291:	83 f8 10             	cmp    $0x10,%eax
80104294:	75 0c                	jne    801042a2 <isdirempty+0x37>
      panic("isdirempty: readi");
    if (de.inum != 0)
80104296:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
8010429b:	75 1e                	jne    801042bb <isdirempty+0x50>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
8010429d:	8d 46 10             	lea    0x10(%esi),%eax
801042a0:	eb d8                	jmp    8010427a <isdirempty+0xf>
      panic("isdirempty: readi");
801042a2:	83 ec 0c             	sub    $0xc,%esp
801042a5:	68 88 71 10 80       	push   $0x80107188
801042aa:	e8 99 c0 ff ff       	call   80100348 <panic>
      return 0;
  }
  return 1;
801042af:	b8 01 00 00 00       	mov    $0x1,%eax
}
801042b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b7:	5b                   	pop    %ebx
801042b8:	5e                   	pop    %esi
801042b9:	5d                   	pop    %ebp
801042ba:	c3                   	ret    
      return 0;
801042bb:	b8 00 00 00 00       	mov    $0x0,%eax
801042c0:	eb f2                	jmp    801042b4 <isdirempty+0x49>

801042c2 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801042c2:	55                   	push   %ebp
801042c3:	89 e5                	mov    %esp,%ebp
801042c5:	57                   	push   %edi
801042c6:	56                   	push   %esi
801042c7:	53                   	push   %ebx
801042c8:	83 ec 34             	sub    $0x34,%esp
801042cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801042ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801042d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801042d4:	8d 55 da             	lea    -0x26(%ebp),%edx
801042d7:	52                   	push   %edx
801042d8:	50                   	push   %eax
801042d9:	e8 07 d9 ff ff       	call   80101be5 <nameiparent>
801042de:	89 c6                	mov    %eax,%esi
801042e0:	83 c4 10             	add    $0x10,%esp
801042e3:	85 c0                	test   %eax,%eax
801042e5:	0f 84 33 01 00 00    	je     8010441e <create+0x15c>
    return 0;
  ilock(dp);
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	50                   	push   %eax
801042ef:	e8 7b d2 ff ff       	call   8010156f <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801042f4:	83 c4 0c             	add    $0xc,%esp
801042f7:	6a 00                	push   $0x0
801042f9:	8d 45 da             	lea    -0x26(%ebp),%eax
801042fc:	50                   	push   %eax
801042fd:	56                   	push   %esi
801042fe:	e8 9c d6 ff ff       	call   8010199f <dirlookup>
80104303:	89 c3                	mov    %eax,%ebx
80104305:	83 c4 10             	add    $0x10,%esp
80104308:	85 c0                	test   %eax,%eax
8010430a:	74 3d                	je     80104349 <create+0x87>
  {
    iunlockput(dp);
8010430c:	83 ec 0c             	sub    $0xc,%esp
8010430f:	56                   	push   %esi
80104310:	e8 01 d4 ff ff       	call   80101716 <iunlockput>
    ilock(ip);
80104315:	89 1c 24             	mov    %ebx,(%esp)
80104318:	e8 52 d2 ff ff       	call   8010156f <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104325:	75 07                	jne    8010432e <create+0x6c>
80104327:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010432c:	74 11                	je     8010433f <create+0x7d>
      return ip;
    iunlockput(ip);
8010432e:	83 ec 0c             	sub    $0xc,%esp
80104331:	53                   	push   %ebx
80104332:	e8 df d3 ff ff       	call   80101716 <iunlockput>
    return 0;
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010433f:	89 d8                	mov    %ebx,%eax
80104341:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104344:	5b                   	pop    %ebx
80104345:	5e                   	pop    %esi
80104346:	5f                   	pop    %edi
80104347:	5d                   	pop    %ebp
80104348:	c3                   	ret    
  if ((ip = ialloc(dp->dev, type)) == 0)
80104349:	83 ec 08             	sub    $0x8,%esp
8010434c:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104350:	50                   	push   %eax
80104351:	ff 36                	push   (%esi)
80104353:	e8 14 d0 ff ff       	call   8010136c <ialloc>
80104358:	89 c3                	mov    %eax,%ebx
8010435a:	83 c4 10             	add    $0x10,%esp
8010435d:	85 c0                	test   %eax,%eax
8010435f:	74 52                	je     801043b3 <create+0xf1>
  ilock(ip);
80104361:	83 ec 0c             	sub    $0xc,%esp
80104364:	50                   	push   %eax
80104365:	e8 05 d2 ff ff       	call   8010156f <ilock>
  ip->major = major;
8010436a:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
8010436e:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104372:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104376:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010437c:	89 1c 24             	mov    %ebx,(%esp)
8010437f:	e8 8a d0 ff ff       	call   8010140e <iupdate>
  if (type == T_DIR)
80104384:	83 c4 10             	add    $0x10,%esp
80104387:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010438c:	74 32                	je     801043c0 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0)
8010438e:	83 ec 04             	sub    $0x4,%esp
80104391:	ff 73 04             	push   0x4(%ebx)
80104394:	8d 45 da             	lea    -0x26(%ebp),%eax
80104397:	50                   	push   %eax
80104398:	56                   	push   %esi
80104399:	e8 7e d7 ff ff       	call   80101b1c <dirlink>
8010439e:	83 c4 10             	add    $0x10,%esp
801043a1:	85 c0                	test   %eax,%eax
801043a3:	78 6c                	js     80104411 <create+0x14f>
  iunlockput(dp);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	56                   	push   %esi
801043a9:	e8 68 d3 ff ff       	call   80101716 <iunlockput>
  return ip;
801043ae:	83 c4 10             	add    $0x10,%esp
801043b1:	eb 8c                	jmp    8010433f <create+0x7d>
    panic("create: ialloc");
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 9a 71 10 80       	push   $0x8010719a
801043bb:	e8 88 bf ff ff       	call   80100348 <panic>
    dp->nlink++; // for ".."
801043c0:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801043c4:	83 c0 01             	add    $0x1,%eax
801043c7:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801043cb:	83 ec 0c             	sub    $0xc,%esp
801043ce:	56                   	push   %esi
801043cf:	e8 3a d0 ff ff       	call   8010140e <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801043d4:	83 c4 0c             	add    $0xc,%esp
801043d7:	ff 73 04             	push   0x4(%ebx)
801043da:	68 aa 71 10 80       	push   $0x801071aa
801043df:	53                   	push   %ebx
801043e0:	e8 37 d7 ff ff       	call   80101b1c <dirlink>
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	85 c0                	test   %eax,%eax
801043ea:	78 18                	js     80104404 <create+0x142>
801043ec:	83 ec 04             	sub    $0x4,%esp
801043ef:	ff 76 04             	push   0x4(%esi)
801043f2:	68 a9 71 10 80       	push   $0x801071a9
801043f7:	53                   	push   %ebx
801043f8:	e8 1f d7 ff ff       	call   80101b1c <dirlink>
801043fd:	83 c4 10             	add    $0x10,%esp
80104400:	85 c0                	test   %eax,%eax
80104402:	79 8a                	jns    8010438e <create+0xcc>
      panic("create dots");
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 ac 71 10 80       	push   $0x801071ac
8010440c:	e8 37 bf ff ff       	call   80100348 <panic>
    panic("create: dirlink");
80104411:	83 ec 0c             	sub    $0xc,%esp
80104414:	68 b8 71 10 80       	push   $0x801071b8
80104419:	e8 2a bf ff ff       	call   80100348 <panic>
    return 0;
8010441e:	89 c3                	mov    %eax,%ebx
80104420:	e9 1a ff ff ff       	jmp    8010433f <create+0x7d>

80104425 <sys_dup>:
{
80104425:	55                   	push   %ebp
80104426:	89 e5                	mov    %esp,%ebp
80104428:	53                   	push   %ebx
80104429:	83 ec 14             	sub    $0x14,%esp
  if (argfd(0, 0, &f) < 0)
8010442c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010442f:	ba 00 00 00 00       	mov    $0x0,%edx
80104434:	b8 00 00 00 00       	mov    $0x0,%eax
80104439:	e8 97 fd ff ff       	call   801041d5 <argfd>
8010443e:	85 c0                	test   %eax,%eax
80104440:	78 23                	js     80104465 <sys_dup+0x40>
  if ((fd = fdalloc(f)) < 0)
80104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104445:	e8 eb fd ff ff       	call   80104235 <fdalloc>
8010444a:	89 c3                	mov    %eax,%ebx
8010444c:	85 c0                	test   %eax,%eax
8010444e:	78 1c                	js     8010446c <sys_dup+0x47>
  filedup(f);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	ff 75 f4             	push   -0xc(%ebp)
80104456:	e8 23 c8 ff ff       	call   80100c7e <filedup>
  return fd;
8010445b:	83 c4 10             	add    $0x10,%esp
}
8010445e:	89 d8                	mov    %ebx,%eax
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104463:	c9                   	leave  
80104464:	c3                   	ret    
    return -1;
80104465:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010446a:	eb f2                	jmp    8010445e <sys_dup+0x39>
    return -1;
8010446c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104471:	eb eb                	jmp    8010445e <sys_dup+0x39>

80104473 <sys_read>:
{
80104473:	55                   	push   %ebp
80104474:	89 e5                	mov    %esp,%ebp
80104476:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104479:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010447c:	ba 00 00 00 00       	mov    $0x0,%edx
80104481:	b8 00 00 00 00       	mov    $0x0,%eax
80104486:	e8 4a fd ff ff       	call   801041d5 <argfd>
8010448b:	85 c0                	test   %eax,%eax
8010448d:	78 43                	js     801044d2 <sys_read+0x5f>
8010448f:	83 ec 08             	sub    $0x8,%esp
80104492:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104495:	50                   	push   %eax
80104496:	6a 02                	push   $0x2
80104498:	e8 1e fc ff ff       	call   801040bb <argint>
8010449d:	83 c4 10             	add    $0x10,%esp
801044a0:	85 c0                	test   %eax,%eax
801044a2:	78 2e                	js     801044d2 <sys_read+0x5f>
801044a4:	83 ec 04             	sub    $0x4,%esp
801044a7:	ff 75 f0             	push   -0x10(%ebp)
801044aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044ad:	50                   	push   %eax
801044ae:	6a 01                	push   $0x1
801044b0:	e8 2e fc ff ff       	call   801040e3 <argptr>
801044b5:	83 c4 10             	add    $0x10,%esp
801044b8:	85 c0                	test   %eax,%eax
801044ba:	78 16                	js     801044d2 <sys_read+0x5f>
  return fileread(f, p, n);
801044bc:	83 ec 04             	sub    $0x4,%esp
801044bf:	ff 75 f0             	push   -0x10(%ebp)
801044c2:	ff 75 ec             	push   -0x14(%ebp)
801044c5:	ff 75 f4             	push   -0xc(%ebp)
801044c8:	e8 03 c9 ff ff       	call   80100dd0 <fileread>
801044cd:	83 c4 10             	add    $0x10,%esp
}
801044d0:	c9                   	leave  
801044d1:	c3                   	ret    
    return -1;
801044d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d7:	eb f7                	jmp    801044d0 <sys_read+0x5d>

801044d9 <sys_write>:
{
801044d9:	55                   	push   %ebp
801044da:	89 e5                	mov    %esp,%ebp
801044dc:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801044df:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044e2:	ba 00 00 00 00       	mov    $0x0,%edx
801044e7:	b8 00 00 00 00       	mov    $0x0,%eax
801044ec:	e8 e4 fc ff ff       	call   801041d5 <argfd>
801044f1:	85 c0                	test   %eax,%eax
801044f3:	78 43                	js     80104538 <sys_write+0x5f>
801044f5:	83 ec 08             	sub    $0x8,%esp
801044f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044fb:	50                   	push   %eax
801044fc:	6a 02                	push   $0x2
801044fe:	e8 b8 fb ff ff       	call   801040bb <argint>
80104503:	83 c4 10             	add    $0x10,%esp
80104506:	85 c0                	test   %eax,%eax
80104508:	78 2e                	js     80104538 <sys_write+0x5f>
8010450a:	83 ec 04             	sub    $0x4,%esp
8010450d:	ff 75 f0             	push   -0x10(%ebp)
80104510:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104513:	50                   	push   %eax
80104514:	6a 01                	push   $0x1
80104516:	e8 c8 fb ff ff       	call   801040e3 <argptr>
8010451b:	83 c4 10             	add    $0x10,%esp
8010451e:	85 c0                	test   %eax,%eax
80104520:	78 16                	js     80104538 <sys_write+0x5f>
  return filewrite(f, p, n);
80104522:	83 ec 04             	sub    $0x4,%esp
80104525:	ff 75 f0             	push   -0x10(%ebp)
80104528:	ff 75 ec             	push   -0x14(%ebp)
8010452b:	ff 75 f4             	push   -0xc(%ebp)
8010452e:	e8 22 c9 ff ff       	call   80100e55 <filewrite>
80104533:	83 c4 10             	add    $0x10,%esp
}
80104536:	c9                   	leave  
80104537:	c3                   	ret    
    return -1;
80104538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453d:	eb f7                	jmp    80104536 <sys_write+0x5d>

8010453f <sys_close>:
{
8010453f:	55                   	push   %ebp
80104540:	89 e5                	mov    %esp,%ebp
80104542:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
80104545:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104548:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010454b:	b8 00 00 00 00       	mov    $0x0,%eax
80104550:	e8 80 fc ff ff       	call   801041d5 <argfd>
80104555:	85 c0                	test   %eax,%eax
80104557:	78 25                	js     8010457e <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104559:	e8 57 ec ff ff       	call   801031b5 <myproc>
8010455e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104561:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104568:	00 
  fileclose(f);
80104569:	83 ec 0c             	sub    $0xc,%esp
8010456c:	ff 75 f0             	push   -0x10(%ebp)
8010456f:	e8 4f c7 ff ff       	call   80100cc3 <fileclose>
  return 0;
80104574:	83 c4 10             	add    $0x10,%esp
80104577:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010457c:	c9                   	leave  
8010457d:	c3                   	ret    
    return -1;
8010457e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104583:	eb f7                	jmp    8010457c <sys_close+0x3d>

80104585 <sys_fstat>:
{
80104585:	55                   	push   %ebp
80104586:	89 e5                	mov    %esp,%ebp
80104588:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
8010458b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010458e:	ba 00 00 00 00       	mov    $0x0,%edx
80104593:	b8 00 00 00 00       	mov    $0x0,%eax
80104598:	e8 38 fc ff ff       	call   801041d5 <argfd>
8010459d:	85 c0                	test   %eax,%eax
8010459f:	78 2a                	js     801045cb <sys_fstat+0x46>
801045a1:	83 ec 04             	sub    $0x4,%esp
801045a4:	6a 14                	push   $0x14
801045a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801045a9:	50                   	push   %eax
801045aa:	6a 01                	push   $0x1
801045ac:	e8 32 fb ff ff       	call   801040e3 <argptr>
801045b1:	83 c4 10             	add    $0x10,%esp
801045b4:	85 c0                	test   %eax,%eax
801045b6:	78 13                	js     801045cb <sys_fstat+0x46>
  return filestat(f, st);
801045b8:	83 ec 08             	sub    $0x8,%esp
801045bb:	ff 75 f0             	push   -0x10(%ebp)
801045be:	ff 75 f4             	push   -0xc(%ebp)
801045c1:	e8 c3 c7 ff ff       	call   80100d89 <filestat>
801045c6:	83 c4 10             	add    $0x10,%esp
}
801045c9:	c9                   	leave  
801045ca:	c3                   	ret    
    return -1;
801045cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d0:	eb f7                	jmp    801045c9 <sys_fstat+0x44>

801045d2 <sys_link>:
{
801045d2:	55                   	push   %ebp
801045d3:	89 e5                	mov    %esp,%ebp
801045d5:	56                   	push   %esi
801045d6:	53                   	push   %ebx
801045d7:	83 ec 28             	sub    $0x28,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801045da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045dd:	50                   	push   %eax
801045de:	6a 00                	push   $0x0
801045e0:	e8 66 fb ff ff       	call   8010414b <argstr>
801045e5:	83 c4 10             	add    $0x10,%esp
801045e8:	85 c0                	test   %eax,%eax
801045ea:	0f 88 d3 00 00 00    	js     801046c3 <sys_link+0xf1>
801045f0:	83 ec 08             	sub    $0x8,%esp
801045f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045f6:	50                   	push   %eax
801045f7:	6a 01                	push   $0x1
801045f9:	e8 4d fb ff ff       	call   8010414b <argstr>
801045fe:	83 c4 10             	add    $0x10,%esp
80104601:	85 c0                	test   %eax,%eax
80104603:	0f 88 ba 00 00 00    	js     801046c3 <sys_link+0xf1>
  begin_op();
80104609:	e8 70 e1 ff ff       	call   8010277e <begin_op>
  if ((ip = namei(old)) == 0)
8010460e:	83 ec 0c             	sub    $0xc,%esp
80104611:	ff 75 e0             	push   -0x20(%ebp)
80104614:	e8 b4 d5 ff ff       	call   80101bcd <namei>
80104619:	89 c3                	mov    %eax,%ebx
8010461b:	83 c4 10             	add    $0x10,%esp
8010461e:	85 c0                	test   %eax,%eax
80104620:	0f 84 a4 00 00 00    	je     801046ca <sys_link+0xf8>
  ilock(ip);
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	50                   	push   %eax
8010462a:	e8 40 cf ff ff       	call   8010156f <ilock>
  if (ip->type == T_DIR)
8010462f:	83 c4 10             	add    $0x10,%esp
80104632:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104637:	0f 84 99 00 00 00    	je     801046d6 <sys_link+0x104>
  ip->nlink++;
8010463d:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104641:	83 c0 01             	add    $0x1,%eax
80104644:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	53                   	push   %ebx
8010464c:	e8 bd cd ff ff       	call   8010140e <iupdate>
  iunlock(ip);
80104651:	89 1c 24             	mov    %ebx,(%esp)
80104654:	e8 d8 cf ff ff       	call   80101631 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80104659:	83 c4 08             	add    $0x8,%esp
8010465c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010465f:	50                   	push   %eax
80104660:	ff 75 e4             	push   -0x1c(%ebp)
80104663:	e8 7d d5 ff ff       	call   80101be5 <nameiparent>
80104668:	89 c6                	mov    %eax,%esi
8010466a:	83 c4 10             	add    $0x10,%esp
8010466d:	85 c0                	test   %eax,%eax
8010466f:	0f 84 85 00 00 00    	je     801046fa <sys_link+0x128>
  ilock(dp);
80104675:	83 ec 0c             	sub    $0xc,%esp
80104678:	50                   	push   %eax
80104679:	e8 f1 ce ff ff       	call   8010156f <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
8010467e:	83 c4 10             	add    $0x10,%esp
80104681:	8b 03                	mov    (%ebx),%eax
80104683:	39 06                	cmp    %eax,(%esi)
80104685:	75 67                	jne    801046ee <sys_link+0x11c>
80104687:	83 ec 04             	sub    $0x4,%esp
8010468a:	ff 73 04             	push   0x4(%ebx)
8010468d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104690:	50                   	push   %eax
80104691:	56                   	push   %esi
80104692:	e8 85 d4 ff ff       	call   80101b1c <dirlink>
80104697:	83 c4 10             	add    $0x10,%esp
8010469a:	85 c0                	test   %eax,%eax
8010469c:	78 50                	js     801046ee <sys_link+0x11c>
  iunlockput(dp);
8010469e:	83 ec 0c             	sub    $0xc,%esp
801046a1:	56                   	push   %esi
801046a2:	e8 6f d0 ff ff       	call   80101716 <iunlockput>
  iput(ip);
801046a7:	89 1c 24             	mov    %ebx,(%esp)
801046aa:	e8 c7 cf ff ff       	call   80101676 <iput>
  end_op();
801046af:	e8 44 e1 ff ff       	call   801027f8 <end_op>
  return 0;
801046b4:	83 c4 10             	add    $0x10,%esp
801046b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046bf:	5b                   	pop    %ebx
801046c0:	5e                   	pop    %esi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
    return -1;
801046c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c8:	eb f2                	jmp    801046bc <sys_link+0xea>
    end_op();
801046ca:	e8 29 e1 ff ff       	call   801027f8 <end_op>
    return -1;
801046cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d4:	eb e6                	jmp    801046bc <sys_link+0xea>
    iunlockput(ip);
801046d6:	83 ec 0c             	sub    $0xc,%esp
801046d9:	53                   	push   %ebx
801046da:	e8 37 d0 ff ff       	call   80101716 <iunlockput>
    end_op();
801046df:	e8 14 e1 ff ff       	call   801027f8 <end_op>
    return -1;
801046e4:	83 c4 10             	add    $0x10,%esp
801046e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ec:	eb ce                	jmp    801046bc <sys_link+0xea>
    iunlockput(dp);
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	56                   	push   %esi
801046f2:	e8 1f d0 ff ff       	call   80101716 <iunlockput>
    goto bad;
801046f7:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046fa:	83 ec 0c             	sub    $0xc,%esp
801046fd:	53                   	push   %ebx
801046fe:	e8 6c ce ff ff       	call   8010156f <ilock>
  ip->nlink--;
80104703:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104707:	83 e8 01             	sub    $0x1,%eax
8010470a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010470e:	89 1c 24             	mov    %ebx,(%esp)
80104711:	e8 f8 cc ff ff       	call   8010140e <iupdate>
  iunlockput(ip);
80104716:	89 1c 24             	mov    %ebx,(%esp)
80104719:	e8 f8 cf ff ff       	call   80101716 <iunlockput>
  end_op();
8010471e:	e8 d5 e0 ff ff       	call   801027f8 <end_op>
  return -1;
80104723:	83 c4 10             	add    $0x10,%esp
80104726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472b:	eb 8f                	jmp    801046bc <sys_link+0xea>

8010472d <sys_unlink>:
{
8010472d:	55                   	push   %ebp
8010472e:	89 e5                	mov    %esp,%ebp
80104730:	57                   	push   %edi
80104731:	56                   	push   %esi
80104732:	53                   	push   %ebx
80104733:	83 ec 44             	sub    $0x44,%esp
  if (argstr(0, &path) < 0)
80104736:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104739:	50                   	push   %eax
8010473a:	6a 00                	push   $0x0
8010473c:	e8 0a fa ff ff       	call   8010414b <argstr>
80104741:	83 c4 10             	add    $0x10,%esp
80104744:	85 c0                	test   %eax,%eax
80104746:	0f 88 83 01 00 00    	js     801048cf <sys_unlink+0x1a2>
  begin_op();
8010474c:	e8 2d e0 ff ff       	call   8010277e <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80104751:	83 ec 08             	sub    $0x8,%esp
80104754:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104757:	50                   	push   %eax
80104758:	ff 75 c4             	push   -0x3c(%ebp)
8010475b:	e8 85 d4 ff ff       	call   80101be5 <nameiparent>
80104760:	89 c6                	mov    %eax,%esi
80104762:	83 c4 10             	add    $0x10,%esp
80104765:	85 c0                	test   %eax,%eax
80104767:	0f 84 ed 00 00 00    	je     8010485a <sys_unlink+0x12d>
  ilock(dp);
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	50                   	push   %eax
80104771:	e8 f9 cd ff ff       	call   8010156f <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104776:	83 c4 08             	add    $0x8,%esp
80104779:	68 aa 71 10 80       	push   $0x801071aa
8010477e:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104781:	50                   	push   %eax
80104782:	e8 03 d2 ff ff       	call   8010198a <namecmp>
80104787:	83 c4 10             	add    $0x10,%esp
8010478a:	85 c0                	test   %eax,%eax
8010478c:	0f 84 fc 00 00 00    	je     8010488e <sys_unlink+0x161>
80104792:	83 ec 08             	sub    $0x8,%esp
80104795:	68 a9 71 10 80       	push   $0x801071a9
8010479a:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010479d:	50                   	push   %eax
8010479e:	e8 e7 d1 ff ff       	call   8010198a <namecmp>
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	85 c0                	test   %eax,%eax
801047a8:	0f 84 e0 00 00 00    	je     8010488e <sys_unlink+0x161>
  if ((ip = dirlookup(dp, name, &off)) == 0)
801047ae:	83 ec 04             	sub    $0x4,%esp
801047b1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047b4:	50                   	push   %eax
801047b5:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047b8:	50                   	push   %eax
801047b9:	56                   	push   %esi
801047ba:	e8 e0 d1 ff ff       	call   8010199f <dirlookup>
801047bf:	89 c3                	mov    %eax,%ebx
801047c1:	83 c4 10             	add    $0x10,%esp
801047c4:	85 c0                	test   %eax,%eax
801047c6:	0f 84 c2 00 00 00    	je     8010488e <sys_unlink+0x161>
  ilock(ip);
801047cc:	83 ec 0c             	sub    $0xc,%esp
801047cf:	50                   	push   %eax
801047d0:	e8 9a cd ff ff       	call   8010156f <ilock>
  if (ip->nlink < 1)
801047d5:	83 c4 10             	add    $0x10,%esp
801047d8:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047dd:	0f 8e 83 00 00 00    	jle    80104866 <sys_unlink+0x139>
  if (ip->type == T_DIR && !isdirempty(ip))
801047e3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047e8:	0f 84 85 00 00 00    	je     80104873 <sys_unlink+0x146>
  memset(&de, 0, sizeof(de));
801047ee:	83 ec 04             	sub    $0x4,%esp
801047f1:	6a 10                	push   $0x10
801047f3:	6a 00                	push   $0x0
801047f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801047f8:	57                   	push   %edi
801047f9:	e8 6d f6 ff ff       	call   80103e6b <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801047fe:	6a 10                	push   $0x10
80104800:	ff 75 c0             	push   -0x40(%ebp)
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	e8 54 d0 ff ff       	call   8010185e <writei>
8010480a:	83 c4 20             	add    $0x20,%esp
8010480d:	83 f8 10             	cmp    $0x10,%eax
80104810:	0f 85 90 00 00 00    	jne    801048a6 <sys_unlink+0x179>
  if (ip->type == T_DIR)
80104816:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010481b:	0f 84 92 00 00 00    	je     801048b3 <sys_unlink+0x186>
  iunlockput(dp);
80104821:	83 ec 0c             	sub    $0xc,%esp
80104824:	56                   	push   %esi
80104825:	e8 ec ce ff ff       	call   80101716 <iunlockput>
  ip->nlink--;
8010482a:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
8010482e:	83 e8 01             	sub    $0x1,%eax
80104831:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104835:	89 1c 24             	mov    %ebx,(%esp)
80104838:	e8 d1 cb ff ff       	call   8010140e <iupdate>
  iunlockput(ip);
8010483d:	89 1c 24             	mov    %ebx,(%esp)
80104840:	e8 d1 ce ff ff       	call   80101716 <iunlockput>
  end_op();
80104845:	e8 ae df ff ff       	call   801027f8 <end_op>
  return 0;
8010484a:	83 c4 10             	add    $0x10,%esp
8010484d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104852:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104855:	5b                   	pop    %ebx
80104856:	5e                   	pop    %esi
80104857:	5f                   	pop    %edi
80104858:	5d                   	pop    %ebp
80104859:	c3                   	ret    
    end_op();
8010485a:	e8 99 df ff ff       	call   801027f8 <end_op>
    return -1;
8010485f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104864:	eb ec                	jmp    80104852 <sys_unlink+0x125>
    panic("unlink: nlink < 1");
80104866:	83 ec 0c             	sub    $0xc,%esp
80104869:	68 c8 71 10 80       	push   $0x801071c8
8010486e:	e8 d5 ba ff ff       	call   80100348 <panic>
  if (ip->type == T_DIR && !isdirempty(ip))
80104873:	89 d8                	mov    %ebx,%eax
80104875:	e8 f1 f9 ff ff       	call   8010426b <isdirempty>
8010487a:	85 c0                	test   %eax,%eax
8010487c:	0f 85 6c ff ff ff    	jne    801047ee <sys_unlink+0xc1>
    iunlockput(ip);
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	53                   	push   %ebx
80104886:	e8 8b ce ff ff       	call   80101716 <iunlockput>
    goto bad;
8010488b:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	56                   	push   %esi
80104892:	e8 7f ce ff ff       	call   80101716 <iunlockput>
  end_op();
80104897:	e8 5c df ff ff       	call   801027f8 <end_op>
  return -1;
8010489c:	83 c4 10             	add    $0x10,%esp
8010489f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a4:	eb ac                	jmp    80104852 <sys_unlink+0x125>
    panic("unlink: writei");
801048a6:	83 ec 0c             	sub    $0xc,%esp
801048a9:	68 da 71 10 80       	push   $0x801071da
801048ae:	e8 95 ba ff ff       	call   80100348 <panic>
    dp->nlink--;
801048b3:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801048b7:	83 e8 01             	sub    $0x1,%eax
801048ba:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	56                   	push   %esi
801048c2:	e8 47 cb ff ff       	call   8010140e <iupdate>
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	e9 52 ff ff ff       	jmp    80104821 <sys_unlink+0xf4>
    return -1;
801048cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d4:	e9 79 ff ff ff       	jmp    80104852 <sys_unlink+0x125>

801048d9 <sys_open>:

int sys_open(void)
{
801048d9:	55                   	push   %ebp
801048da:	89 e5                	mov    %esp,%ebp
801048dc:	57                   	push   %edi
801048dd:	56                   	push   %esi
801048de:	53                   	push   %ebx
801048df:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048e5:	50                   	push   %eax
801048e6:	6a 00                	push   $0x0
801048e8:	e8 5e f8 ff ff       	call   8010414b <argstr>
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	85 c0                	test   %eax,%eax
801048f2:	0f 88 a0 00 00 00    	js     80104998 <sys_open+0xbf>
801048f8:	83 ec 08             	sub    $0x8,%esp
801048fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048fe:	50                   	push   %eax
801048ff:	6a 01                	push   $0x1
80104901:	e8 b5 f7 ff ff       	call   801040bb <argint>
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	85 c0                	test   %eax,%eax
8010490b:	0f 88 87 00 00 00    	js     80104998 <sys_open+0xbf>
    return -1;

  begin_op();
80104911:	e8 68 de ff ff       	call   8010277e <begin_op>

  if (omode & O_CREATE)
80104916:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
8010491a:	0f 84 8b 00 00 00    	je     801049ab <sys_open+0xd2>
  {
    ip = create(path, T_FILE, 0, 0);
80104920:	83 ec 0c             	sub    $0xc,%esp
80104923:	6a 00                	push   $0x0
80104925:	b9 00 00 00 00       	mov    $0x0,%ecx
8010492a:	ba 02 00 00 00       	mov    $0x2,%edx
8010492f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104932:	e8 8b f9 ff ff       	call   801042c2 <create>
80104937:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80104939:	83 c4 10             	add    $0x10,%esp
8010493c:	85 c0                	test   %eax,%eax
8010493e:	74 5f                	je     8010499f <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80104940:	e8 d8 c2 ff ff       	call   80100c1d <filealloc>
80104945:	89 c3                	mov    %eax,%ebx
80104947:	85 c0                	test   %eax,%eax
80104949:	0f 84 b5 00 00 00    	je     80104a04 <sys_open+0x12b>
8010494f:	e8 e1 f8 ff ff       	call   80104235 <fdalloc>
80104954:	89 c7                	mov    %eax,%edi
80104956:	85 c0                	test   %eax,%eax
80104958:	0f 88 a6 00 00 00    	js     80104a04 <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010495e:	83 ec 0c             	sub    $0xc,%esp
80104961:	56                   	push   %esi
80104962:	e8 ca cc ff ff       	call   80101631 <iunlock>
  end_op();
80104967:	e8 8c de ff ff       	call   801027f8 <end_op>

  f->type = FD_INODE;
8010496c:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104972:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104975:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010497c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010497f:	83 c4 10             	add    $0x10,%esp
80104982:	a8 01                	test   $0x1,%al
80104984:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104988:	a8 03                	test   $0x3,%al
8010498a:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
8010498e:	89 f8                	mov    %edi,%eax
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	5b                   	pop    %ebx
80104994:	5e                   	pop    %esi
80104995:	5f                   	pop    %edi
80104996:	5d                   	pop    %ebp
80104997:	c3                   	ret    
    return -1;
80104998:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010499d:	eb ef                	jmp    8010498e <sys_open+0xb5>
      end_op();
8010499f:	e8 54 de ff ff       	call   801027f8 <end_op>
      return -1;
801049a4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a9:	eb e3                	jmp    8010498e <sys_open+0xb5>
    if ((ip = namei(path)) == 0)
801049ab:	83 ec 0c             	sub    $0xc,%esp
801049ae:	ff 75 e4             	push   -0x1c(%ebp)
801049b1:	e8 17 d2 ff ff       	call   80101bcd <namei>
801049b6:	89 c6                	mov    %eax,%esi
801049b8:	83 c4 10             	add    $0x10,%esp
801049bb:	85 c0                	test   %eax,%eax
801049bd:	74 39                	je     801049f8 <sys_open+0x11f>
    ilock(ip);
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	50                   	push   %eax
801049c3:	e8 a7 cb ff ff       	call   8010156f <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801049d0:	0f 85 6a ff ff ff    	jne    80104940 <sys_open+0x67>
801049d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049da:	0f 84 60 ff ff ff    	je     80104940 <sys_open+0x67>
      iunlockput(ip);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	56                   	push   %esi
801049e4:	e8 2d cd ff ff       	call   80101716 <iunlockput>
      end_op();
801049e9:	e8 0a de ff ff       	call   801027f8 <end_op>
      return -1;
801049ee:	83 c4 10             	add    $0x10,%esp
801049f1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049f6:	eb 96                	jmp    8010498e <sys_open+0xb5>
      end_op();
801049f8:	e8 fb dd ff ff       	call   801027f8 <end_op>
      return -1;
801049fd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a02:	eb 8a                	jmp    8010498e <sys_open+0xb5>
    if (f)
80104a04:	85 db                	test   %ebx,%ebx
80104a06:	74 0c                	je     80104a14 <sys_open+0x13b>
      fileclose(f);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	53                   	push   %ebx
80104a0c:	e8 b2 c2 ff ff       	call   80100cc3 <fileclose>
80104a11:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	56                   	push   %esi
80104a18:	e8 f9 cc ff ff       	call   80101716 <iunlockput>
    end_op();
80104a1d:	e8 d6 dd ff ff       	call   801027f8 <end_op>
    return -1;
80104a22:	83 c4 10             	add    $0x10,%esp
80104a25:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a2a:	e9 5f ff ff ff       	jmp    8010498e <sys_open+0xb5>

80104a2f <sys_mkdir>:

int sys_mkdir(void)
{
80104a2f:	55                   	push   %ebp
80104a30:	89 e5                	mov    %esp,%ebp
80104a32:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a35:	e8 44 dd ff ff       	call   8010277e <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80104a3a:	83 ec 08             	sub    $0x8,%esp
80104a3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a40:	50                   	push   %eax
80104a41:	6a 00                	push   $0x0
80104a43:	e8 03 f7 ff ff       	call   8010414b <argstr>
80104a48:	83 c4 10             	add    $0x10,%esp
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	78 36                	js     80104a85 <sys_mkdir+0x56>
80104a4f:	83 ec 0c             	sub    $0xc,%esp
80104a52:	6a 00                	push   $0x0
80104a54:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a59:	ba 01 00 00 00       	mov    $0x1,%edx
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	e8 5c f8 ff ff       	call   801042c2 <create>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 c0                	test   %eax,%eax
80104a6b:	74 18                	je     80104a85 <sys_mkdir+0x56>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a6d:	83 ec 0c             	sub    $0xc,%esp
80104a70:	50                   	push   %eax
80104a71:	e8 a0 cc ff ff       	call   80101716 <iunlockput>
  end_op();
80104a76:	e8 7d dd ff ff       	call   801027f8 <end_op>
  return 0;
80104a7b:	83 c4 10             	add    $0x10,%esp
80104a7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a83:	c9                   	leave  
80104a84:	c3                   	ret    
    end_op();
80104a85:	e8 6e dd ff ff       	call   801027f8 <end_op>
    return -1;
80104a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8f:	eb f2                	jmp    80104a83 <sys_mkdir+0x54>

80104a91 <sys_mknod>:

int sys_mknod(void)
{
80104a91:	55                   	push   %ebp
80104a92:	89 e5                	mov    %esp,%ebp
80104a94:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a97:	e8 e2 dc ff ff       	call   8010277e <begin_op>
  if ((argstr(0, &path)) < 0 ||
80104a9c:	83 ec 08             	sub    $0x8,%esp
80104a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa2:	50                   	push   %eax
80104aa3:	6a 00                	push   $0x0
80104aa5:	e8 a1 f6 ff ff       	call   8010414b <argstr>
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	85 c0                	test   %eax,%eax
80104aaf:	78 62                	js     80104b13 <sys_mknod+0x82>
      argint(1, &major) < 0 ||
80104ab1:	83 ec 08             	sub    $0x8,%esp
80104ab4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ab7:	50                   	push   %eax
80104ab8:	6a 01                	push   $0x1
80104aba:	e8 fc f5 ff ff       	call   801040bb <argint>
  if ((argstr(0, &path)) < 0 ||
80104abf:	83 c4 10             	add    $0x10,%esp
80104ac2:	85 c0                	test   %eax,%eax
80104ac4:	78 4d                	js     80104b13 <sys_mknod+0x82>
      argint(2, &minor) < 0 ||
80104ac6:	83 ec 08             	sub    $0x8,%esp
80104ac9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104acc:	50                   	push   %eax
80104acd:	6a 02                	push   $0x2
80104acf:	e8 e7 f5 ff ff       	call   801040bb <argint>
      argint(1, &major) < 0 ||
80104ad4:	83 c4 10             	add    $0x10,%esp
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	78 38                	js     80104b13 <sys_mknod+0x82>
      (ip = create(path, T_DEV, major, minor)) == 0)
80104adb:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104ae6:	50                   	push   %eax
80104ae7:	ba 03 00 00 00       	mov    $0x3,%edx
80104aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aef:	e8 ce f7 ff ff       	call   801042c2 <create>
      argint(2, &minor) < 0 ||
80104af4:	83 c4 10             	add    $0x10,%esp
80104af7:	85 c0                	test   %eax,%eax
80104af9:	74 18                	je     80104b13 <sys_mknod+0x82>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	50                   	push   %eax
80104aff:	e8 12 cc ff ff       	call   80101716 <iunlockput>
  end_op();
80104b04:	e8 ef dc ff ff       	call   801027f8 <end_op>
  return 0;
80104b09:	83 c4 10             	add    $0x10,%esp
80104b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b11:	c9                   	leave  
80104b12:	c3                   	ret    
    end_op();
80104b13:	e8 e0 dc ff ff       	call   801027f8 <end_op>
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1d:	eb f2                	jmp    80104b11 <sys_mknod+0x80>

80104b1f <sys_chdir>:

int sys_chdir(void)
{
80104b1f:	55                   	push   %ebp
80104b20:	89 e5                	mov    %esp,%ebp
80104b22:	56                   	push   %esi
80104b23:	53                   	push   %ebx
80104b24:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104b27:	e8 89 e6 ff ff       	call   801031b5 <myproc>
80104b2c:	89 c6                	mov    %eax,%esi

  begin_op();
80104b2e:	e8 4b dc ff ff       	call   8010277e <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104b33:	83 ec 08             	sub    $0x8,%esp
80104b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b39:	50                   	push   %eax
80104b3a:	6a 00                	push   $0x0
80104b3c:	e8 0a f6 ff ff       	call   8010414b <argstr>
80104b41:	83 c4 10             	add    $0x10,%esp
80104b44:	85 c0                	test   %eax,%eax
80104b46:	78 52                	js     80104b9a <sys_chdir+0x7b>
80104b48:	83 ec 0c             	sub    $0xc,%esp
80104b4b:	ff 75 f4             	push   -0xc(%ebp)
80104b4e:	e8 7a d0 ff ff       	call   80101bcd <namei>
80104b53:	89 c3                	mov    %eax,%ebx
80104b55:	83 c4 10             	add    $0x10,%esp
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	74 3e                	je     80104b9a <sys_chdir+0x7b>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80104b5c:	83 ec 0c             	sub    $0xc,%esp
80104b5f:	50                   	push   %eax
80104b60:	e8 0a ca ff ff       	call   8010156f <ilock>
  if (ip->type != T_DIR)
80104b65:	83 c4 10             	add    $0x10,%esp
80104b68:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b6d:	75 37                	jne    80104ba6 <sys_chdir+0x87>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	53                   	push   %ebx
80104b73:	e8 b9 ca ff ff       	call   80101631 <iunlock>
  iput(curproc->cwd);
80104b78:	83 c4 04             	add    $0x4,%esp
80104b7b:	ff 76 68             	push   0x68(%esi)
80104b7e:	e8 f3 ca ff ff       	call   80101676 <iput>
  end_op();
80104b83:	e8 70 dc ff ff       	call   801027f8 <end_op>
  curproc->cwd = ip;
80104b88:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b8b:	83 c4 10             	add    $0x10,%esp
80104b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b96:	5b                   	pop    %ebx
80104b97:	5e                   	pop    %esi
80104b98:	5d                   	pop    %ebp
80104b99:	c3                   	ret    
    end_op();
80104b9a:	e8 59 dc ff ff       	call   801027f8 <end_op>
    return -1;
80104b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba4:	eb ed                	jmp    80104b93 <sys_chdir+0x74>
    iunlockput(ip);
80104ba6:	83 ec 0c             	sub    $0xc,%esp
80104ba9:	53                   	push   %ebx
80104baa:	e8 67 cb ff ff       	call   80101716 <iunlockput>
    end_op();
80104baf:	e8 44 dc ff ff       	call   801027f8 <end_op>
    return -1;
80104bb4:	83 c4 10             	add    $0x10,%esp
80104bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bbc:	eb d5                	jmp    80104b93 <sys_chdir+0x74>

80104bbe <sys_exec>:

int sys_exec(void)
{
80104bbe:	55                   	push   %ebp
80104bbf:	89 e5                	mov    %esp,%ebp
80104bc1:	53                   	push   %ebx
80104bc2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104bc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcb:	50                   	push   %eax
80104bcc:	6a 00                	push   $0x0
80104bce:	e8 78 f5 ff ff       	call   8010414b <argstr>
80104bd3:	83 c4 10             	add    $0x10,%esp
80104bd6:	85 c0                	test   %eax,%eax
80104bd8:	78 38                	js     80104c12 <sys_exec+0x54>
80104bda:	83 ec 08             	sub    $0x8,%esp
80104bdd:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104be3:	50                   	push   %eax
80104be4:	6a 01                	push   $0x1
80104be6:	e8 d0 f4 ff ff       	call   801040bb <argint>
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	85 c0                	test   %eax,%eax
80104bf0:	78 20                	js     80104c12 <sys_exec+0x54>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bf2:	83 ec 04             	sub    $0x4,%esp
80104bf5:	68 80 00 00 00       	push   $0x80
80104bfa:	6a 00                	push   $0x0
80104bfc:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c02:	50                   	push   %eax
80104c03:	e8 63 f2 ff ff       	call   80103e6b <memset>
80104c08:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++)
80104c0b:	bb 00 00 00 00       	mov    $0x0,%ebx
80104c10:	eb 2c                	jmp    80104c3e <sys_exec+0x80>
    return -1;
80104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c17:	eb 78                	jmp    80104c91 <sys_exec+0xd3>
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
      return -1;
    if (uarg == 0)
    {
      argv[i] = 0;
80104c19:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104c20:	00 00 00 00 
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104c24:	83 ec 08             	sub    $0x8,%esp
80104c27:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104c2d:	50                   	push   %eax
80104c2e:	ff 75 f4             	push   -0xc(%ebp)
80104c31:	e8 98 bc ff ff       	call   801008ce <exec>
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	eb 56                	jmp    80104c91 <sys_exec+0xd3>
  for (i = 0;; i++)
80104c3b:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80104c3e:	83 fb 1f             	cmp    $0x1f,%ebx
80104c41:	77 49                	ja     80104c8c <sys_exec+0xce>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104c43:	83 ec 08             	sub    $0x8,%esp
80104c46:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104c4c:	50                   	push   %eax
80104c4d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104c53:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104c56:	50                   	push   %eax
80104c57:	e8 e5 f3 ff ff       	call   80104041 <fetchint>
80104c5c:	83 c4 10             	add    $0x10,%esp
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	78 33                	js     80104c96 <sys_exec+0xd8>
    if (uarg == 0)
80104c63:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	74 ac                	je     80104c19 <sys_exec+0x5b>
    if (fetchstr(uarg, &argv[i]) < 0)
80104c6d:	83 ec 08             	sub    $0x8,%esp
80104c70:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c77:	52                   	push   %edx
80104c78:	50                   	push   %eax
80104c79:	e8 fe f3 ff ff       	call   8010407c <fetchstr>
80104c7e:	83 c4 10             	add    $0x10,%esp
80104c81:	85 c0                	test   %eax,%eax
80104c83:	79 b6                	jns    80104c3b <sys_exec+0x7d>
      return -1;
80104c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8a:	eb 05                	jmp    80104c91 <sys_exec+0xd3>
      return -1;
80104c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c94:	c9                   	leave  
80104c95:	c3                   	ret    
      return -1;
80104c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9b:	eb f4                	jmp    80104c91 <sys_exec+0xd3>

80104c9d <sys_pipe>:

int sys_pipe(void)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	53                   	push   %ebx
80104ca1:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104ca4:	6a 08                	push   $0x8
80104ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca9:	50                   	push   %eax
80104caa:	6a 00                	push   $0x0
80104cac:	e8 32 f4 ff ff       	call   801040e3 <argptr>
80104cb1:	83 c4 10             	add    $0x10,%esp
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	78 79                	js     80104d31 <sys_pipe+0x94>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80104cb8:	83 ec 08             	sub    $0x8,%esp
80104cbb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cbe:	50                   	push   %eax
80104cbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cc2:	50                   	push   %eax
80104cc3:	e8 3f e0 ff ff       	call   80102d07 <pipealloc>
80104cc8:	83 c4 10             	add    $0x10,%esp
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	78 69                	js     80104d38 <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd2:	e8 5e f5 ff ff       	call   80104235 <fdalloc>
80104cd7:	89 c3                	mov    %eax,%ebx
80104cd9:	85 c0                	test   %eax,%eax
80104cdb:	78 21                	js     80104cfe <sys_pipe+0x61>
80104cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ce0:	e8 50 f5 ff ff       	call   80104235 <fdalloc>
80104ce5:	85 c0                	test   %eax,%eax
80104ce7:	78 15                	js     80104cfe <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cec:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf1:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cfc:	c9                   	leave  
80104cfd:	c3                   	ret    
    if (fd0 >= 0)
80104cfe:	85 db                	test   %ebx,%ebx
80104d00:	79 20                	jns    80104d22 <sys_pipe+0x85>
    fileclose(rf);
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	ff 75 f0             	push   -0x10(%ebp)
80104d08:	e8 b6 bf ff ff       	call   80100cc3 <fileclose>
    fileclose(wf);
80104d0d:	83 c4 04             	add    $0x4,%esp
80104d10:	ff 75 ec             	push   -0x14(%ebp)
80104d13:	e8 ab bf ff ff       	call   80100cc3 <fileclose>
    return -1;
80104d18:	83 c4 10             	add    $0x10,%esp
80104d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d20:	eb d7                	jmp    80104cf9 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104d22:	e8 8e e4 ff ff       	call   801031b5 <myproc>
80104d27:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d2e:	00 
80104d2f:	eb d1                	jmp    80104d02 <sys_pipe+0x65>
    return -1;
80104d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d36:	eb c1                	jmp    80104cf9 <sys_pipe+0x5c>
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3d:	eb ba                	jmp    80104cf9 <sys_pipe+0x5c>

80104d3f <sys_hello>:

int sys_hello(void)
{
80104d3f:	55                   	push   %ebp
80104d40:	89 e5                	mov    %esp,%ebp
80104d42:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hi! Welcome to the world of xv6!\n");
80104d45:	68 ec 71 10 80       	push   $0x801071ec
80104d4a:	e8 b8 b8 ff ff       	call   80100607 <cprintf>
  return 0;
}
80104d4f:	b8 00 00 00 00       	mov    $0x0,%eax
80104d54:	c9                   	leave  
80104d55:	c3                   	ret    

80104d56 <sys_helloYou>:
int sys_helloYou(void)
{
80104d56:	55                   	push   %ebp
80104d57:	89 e5                	mov    %esp,%ebp
80104d59:	83 ec 18             	sub    $0x18,%esp
  // char *argv[MAXARG];
  char *path;
  begin_op();
80104d5c:	e8 1d da ff ff       	call   8010277e <begin_op>
  argstr(0, &path);
80104d61:	83 ec 08             	sub    $0x8,%esp
80104d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d67:	50                   	push   %eax
80104d68:	6a 00                	push   $0x0
80104d6a:	e8 dc f3 ff ff       	call   8010414b <argstr>
  cprintf("this is the helloYou syscall called %s\n", path);
80104d6f:	83 c4 08             	add    $0x8,%esp
80104d72:	ff 75 f4             	push   -0xc(%ebp)
80104d75:	68 10 72 10 80       	push   $0x80107210
80104d7a:	e8 88 b8 ff ff       	call   80100607 <cprintf>
  end_op();
80104d7f:	e8 74 da ff ff       	call   801027f8 <end_op>
  return 0;
}
80104d84:	b8 00 00 00 00       	mov    $0x0,%eax
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    

80104d8b <sys_fork>:
#include "mmu.h"
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
80104d8b:	55                   	push   %ebp
80104d8c:	89 e5                	mov    %esp,%ebp
80104d8e:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d91:	e8 95 e5 ff ff       	call   8010332b <fork>
}
80104d96:	c9                   	leave  
80104d97:	c3                   	ret    

80104d98 <sys_exit>:

int sys_exit(void)
{
80104d98:	55                   	push   %ebp
80104d99:	89 e5                	mov    %esp,%ebp
80104d9b:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d9e:	e8 c2 e7 ff ff       	call   80103565 <exit>
  return 0; // not reached
}
80104da3:	b8 00 00 00 00       	mov    $0x0,%eax
80104da8:	c9                   	leave  
80104da9:	c3                   	ret    

80104daa <sys_wait>:

int sys_wait(void)
{
80104daa:	55                   	push   %ebp
80104dab:	89 e5                	mov    %esp,%ebp
80104dad:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104db0:	e8 58 e9 ff ff       	call   8010370d <wait>
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    

80104db7 <sys_kill>:

int sys_kill(void)
{
80104db7:	55                   	push   %ebp
80104db8:	89 e5                	mov    %esp,%ebp
80104dba:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80104dbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dc0:	50                   	push   %eax
80104dc1:	6a 00                	push   $0x0
80104dc3:	e8 f3 f2 ff ff       	call   801040bb <argint>
80104dc8:	83 c4 10             	add    $0x10,%esp
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	78 10                	js     80104ddf <sys_kill+0x28>
    return -1;
  return kill(pid);
80104dcf:	83 ec 0c             	sub    $0xc,%esp
80104dd2:	ff 75 f4             	push   -0xc(%ebp)
80104dd5:	e8 30 ea ff ff       	call   8010380a <kill>
80104dda:	83 c4 10             	add    $0x10,%esp
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    
    return -1;
80104ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de4:	eb f7                	jmp    80104ddd <sys_kill+0x26>

80104de6 <sys_getpid>:

int sys_getpid(void)
{
80104de6:	55                   	push   %ebp
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104dec:	e8 c4 e3 ff ff       	call   801031b5 <myproc>
80104df1:	8b 40 10             	mov    0x10(%eax),%eax
}
80104df4:	c9                   	leave  
80104df5:	c3                   	ret    

80104df6 <sys_sbrk>:

int sys_sbrk(void)
{
80104df6:	55                   	push   %ebp
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	53                   	push   %ebx
80104dfa:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80104dfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e00:	50                   	push   %eax
80104e01:	6a 00                	push   $0x0
80104e03:	e8 b3 f2 ff ff       	call   801040bb <argint>
80104e08:	83 c4 10             	add    $0x10,%esp
80104e0b:	85 c0                	test   %eax,%eax
80104e0d:	78 20                	js     80104e2f <sys_sbrk+0x39>
    return -1;
  addr = myproc()->sz;
80104e0f:	e8 a1 e3 ff ff       	call   801031b5 <myproc>
80104e14:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80104e16:	83 ec 0c             	sub    $0xc,%esp
80104e19:	ff 75 f4             	push   -0xc(%ebp)
80104e1c:	e8 9f e4 ff ff       	call   801032c0 <growproc>
80104e21:	83 c4 10             	add    $0x10,%esp
80104e24:	85 c0                	test   %eax,%eax
80104e26:	78 0e                	js     80104e36 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80104e28:	89 d8                	mov    %ebx,%eax
80104e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e2d:	c9                   	leave  
80104e2e:	c3                   	ret    
    return -1;
80104e2f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e34:	eb f2                	jmp    80104e28 <sys_sbrk+0x32>
    return -1;
80104e36:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e3b:	eb eb                	jmp    80104e28 <sys_sbrk+0x32>

80104e3d <sys_sleep>:

int sys_sleep(void)
{
80104e3d:	55                   	push   %ebp
80104e3e:	89 e5                	mov    %esp,%ebp
80104e40:	53                   	push   %ebx
80104e41:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80104e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e47:	50                   	push   %eax
80104e48:	6a 00                	push   $0x0
80104e4a:	e8 6c f2 ff ff       	call   801040bb <argint>
80104e4f:	83 c4 10             	add    $0x10,%esp
80104e52:	85 c0                	test   %eax,%eax
80104e54:	78 75                	js     80104ecb <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104e56:	83 ec 0c             	sub    $0xc,%esp
80104e59:	68 a0 3d 11 80       	push   $0x80113da0
80104e5e:	e8 5c ef ff ff       	call   80103dbf <acquire>
  ticks0 = ticks;
80104e63:	8b 1d 80 3d 11 80    	mov    0x80113d80,%ebx
  while (ticks - ticks0 < n)
80104e69:	83 c4 10             	add    $0x10,%esp
80104e6c:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80104e71:	29 d8                	sub    %ebx,%eax
80104e73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e76:	73 39                	jae    80104eb1 <sys_sleep+0x74>
  {
    if (myproc()->killed)
80104e78:	e8 38 e3 ff ff       	call   801031b5 <myproc>
80104e7d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e81:	75 17                	jne    80104e9a <sys_sleep+0x5d>
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e83:	83 ec 08             	sub    $0x8,%esp
80104e86:	68 a0 3d 11 80       	push   $0x80113da0
80104e8b:	68 80 3d 11 80       	push   $0x80113d80
80104e90:	e8 e7 e7 ff ff       	call   8010367c <sleep>
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	eb d2                	jmp    80104e6c <sys_sleep+0x2f>
      release(&tickslock);
80104e9a:	83 ec 0c             	sub    $0xc,%esp
80104e9d:	68 a0 3d 11 80       	push   $0x80113da0
80104ea2:	e8 7d ef ff ff       	call   80103e24 <release>
      return -1;
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eaf:	eb 15                	jmp    80104ec6 <sys_sleep+0x89>
  }
  release(&tickslock);
80104eb1:	83 ec 0c             	sub    $0xc,%esp
80104eb4:	68 a0 3d 11 80       	push   $0x80113da0
80104eb9:	e8 66 ef ff ff       	call   80103e24 <release>
  return 0;
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ec6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    
    return -1;
80104ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed0:	eb f4                	jmp    80104ec6 <sys_sleep+0x89>

80104ed2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80104ed2:	55                   	push   %ebp
80104ed3:	89 e5                	mov    %esp,%ebp
80104ed5:	53                   	push   %ebx
80104ed6:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104ed9:	68 a0 3d 11 80       	push   $0x80113da0
80104ede:	e8 dc ee ff ff       	call   80103dbf <acquire>
  xticks = ticks;
80104ee3:	8b 1d 80 3d 11 80    	mov    0x80113d80,%ebx
  release(&tickslock);
80104ee9:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104ef0:	e8 2f ef ff ff       	call   80103e24 <release>
  return xticks;
}
80104ef5:	89 d8                	mov    %ebx,%eax
80104ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    

80104efc <sys_getppid>:
// {
//   return 0;   //commenting this line resolved the error
// }            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
80104efc:	55                   	push   %ebp
80104efd:	89 e5                	mov    %esp,%ebp
80104eff:	83 ec 20             	sub    $0x20,%esp
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
80104f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f05:	50                   	push   %eax
80104f06:	6a 00                	push   $0x0
80104f08:	e8 ae f1 ff ff       	call   801040bb <argint>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 07                	js     80104f1b <sys_getppid+0x1f>
   return -1;
  }
  return getppid();
80104f14:	e8 17 ea ff ff       	call   80103930 <getppid>
}
80104f19:	c9                   	leave  
80104f1a:	c3                   	ret    
   return -1;
80104f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f20:	eb f7                	jmp    80104f19 <sys_getppid+0x1d>

80104f22 <sys_get_siblings_info>:

int sys_get_siblings_info(int pid){
80104f22:	55                   	push   %ebp
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	83 ec 08             	sub    $0x8,%esp
  
  return get_siblings_info(sys_getpid());
80104f28:	e8 b9 fe ff ff       	call   80104de6 <sys_getpid>
80104f2d:	83 ec 0c             	sub    $0xc,%esp
80104f30:	50                   	push   %eax
80104f31:	e8 35 ea ff ff       	call   8010396b <get_siblings_info>
}
80104f36:	c9                   	leave  
80104f37:	c3                   	ret    

80104f38 <sys_signalProcess>:
void sys_signalProcess(int pid,char type[]){
80104f38:	55                   	push   %ebp
80104f39:	89 e5                	mov    %esp,%ebp
80104f3b:	83 ec 10             	sub    $0x10,%esp
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
80104f3e:	8d 45 08             	lea    0x8(%ebp),%eax
80104f41:	50                   	push   %eax
80104f42:	6a 00                	push   $0x0
80104f44:	e8 72 f1 ff ff       	call   801040bb <argint>
  char **type1=&type;
  argstr(1,type1); 
80104f49:	83 c4 08             	add    $0x8,%esp
80104f4c:	8d 45 0c             	lea    0xc(%ebp),%eax
80104f4f:	50                   	push   %eax
80104f50:	6a 01                	push   $0x1
80104f52:	e8 f4 f1 ff ff       	call   8010414b <argstr>
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
80104f57:	83 c4 08             	add    $0x8,%esp
80104f5a:	ff 75 0c             	push   0xc(%ebp)
80104f5d:	ff 75 08             	push   0x8(%ebp)
80104f60:	e8 e6 ea ff ff       	call   80103a4b <signalProcess>
}
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	c9                   	leave  
80104f69:	c3                   	ret    

80104f6a <sys_numvp>:

int sys_numvp(){
80104f6a:	55                   	push   %ebp
80104f6b:	89 e5                	mov    %esp,%ebp
80104f6d:	83 ec 08             	sub    $0x8,%esp
  return numvp();
80104f70:	e8 9c eb ff ff       	call   80103b11 <numvp>
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    

80104f77 <sys_numpp>:

int sys_numpp(){
80104f77:	55                   	push   %ebp
80104f78:	89 e5                	mov    %esp,%ebp
80104f7a:	83 ec 08             	sub    $0x8,%esp
  return numpp();
80104f7d:	e8 a1 eb ff ff       	call   80103b23 <numpp>
}
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    

80104f84 <sys_init_counter>:
/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
80104f84:	c7 05 60 3d 11 80 00 	movl   $0x0,0x80113d60
80104f8b:	00 00 00 
}
80104f8e:	c3                   	ret    

80104f8f <sys_update_cnt>:

void sys_update_cnt(void){
  counter = counter + 1;
80104f8f:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80104f94:	83 c0 01             	add    $0x1,%eax
80104f97:	a3 60 3d 11 80       	mov    %eax,0x80113d60
}
80104f9c:	c3                   	ret    

80104f9d <sys_display_count>:

int sys_display_count(void){
  return counter;
}
80104f9d:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80104fa2:	c3                   	ret    

80104fa3 <sys_init_counter_1>:
/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
80104fa3:	c7 05 5c 3d 11 80 00 	movl   $0x0,0x80113d5c
80104faa:	00 00 00 
}
80104fad:	c3                   	ret    

80104fae <sys_update_cnt_1>:

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
80104fae:	a1 5c 3d 11 80       	mov    0x80113d5c,%eax
80104fb3:	83 c0 01             	add    $0x1,%eax
80104fb6:	a3 5c 3d 11 80       	mov    %eax,0x80113d5c
}
80104fbb:	c3                   	ret    

80104fbc <sys_display_count_1>:

int sys_display_count_1(void){
  return counter_1;
}
80104fbc:	a1 5c 3d 11 80       	mov    0x80113d5c,%eax
80104fc1:	c3                   	ret    

80104fc2 <sys_init_counter_2>:
/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
80104fc2:	c7 05 58 3d 11 80 00 	movl   $0x0,0x80113d58
80104fc9:	00 00 00 
}
80104fcc:	c3                   	ret    

80104fcd <sys_update_cnt_2>:

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
80104fcd:	a1 58 3d 11 80       	mov    0x80113d58,%eax
80104fd2:	83 c0 01             	add    $0x1,%eax
80104fd5:	a3 58 3d 11 80       	mov    %eax,0x80113d58
}
80104fda:	c3                   	ret    

80104fdb <sys_display_count_2>:

int sys_display_count_2(void){
  return counter_2;
}
80104fdb:	a1 58 3d 11 80       	mov    0x80113d58,%eax
80104fe0:	c3                   	ret    

80104fe1 <sys_init_mylock>:

int sys_init_mylock(){
80104fe1:	55                   	push   %ebp
80104fe2:	89 e5                	mov    %esp,%ebp
80104fe4:	83 ec 08             	sub    $0x8,%esp
  return init_mylock();
80104fe7:	e8 44 eb ff ff       	call   80103b30 <init_mylock>
}
80104fec:	c9                   	leave  
80104fed:	c3                   	ret    

80104fee <sys_acquire_mylock>:

int sys_acquire_mylock(int id){
80104fee:	55                   	push   %ebp
80104fef:	89 e5                	mov    %esp,%ebp
80104ff1:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80104ff4:	8d 45 08             	lea    0x8(%ebp),%eax
80104ff7:	50                   	push   %eax
80104ff8:	6a 00                	push   $0x0
80104ffa:	e8 bc f0 ff ff       	call   801040bb <argint>
  return acquire_mylock(id);
80104fff:	83 c4 04             	add    $0x4,%esp
80105002:	ff 75 08             	push   0x8(%ebp)
80105005:	e8 2c eb ff ff       	call   80103b36 <acquire_mylock>
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    

8010500c <sys_release_mylock>:

int sys_release_mylock(int id){
8010500c:	55                   	push   %ebp
8010500d:	89 e5                	mov    %esp,%ebp
8010500f:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105012:	8d 45 08             	lea    0x8(%ebp),%eax
80105015:	50                   	push   %eax
80105016:	6a 00                	push   $0x0
80105018:	e8 9e f0 ff ff       	call   801040bb <argint>
  return release_mylock(id);
8010501d:	83 c4 04             	add    $0x4,%esp
80105020:	ff 75 08             	push   0x8(%ebp)
80105023:	e8 24 eb ff ff       	call   80103b4c <release_mylock>
}
80105028:	c9                   	leave  
80105029:	c3                   	ret    

8010502a <sys_holding_mylock>:

int sys_holding_mylock(int id){
8010502a:	55                   	push   %ebp
8010502b:	89 e5                	mov    %esp,%ebp
8010502d:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105030:	8d 45 08             	lea    0x8(%ebp),%eax
80105033:	50                   	push   %eax
80105034:	6a 00                	push   $0x0
80105036:	e8 80 f0 ff ff       	call   801040bb <argint>
  return holding_mylock(id);
8010503b:	83 c4 04             	add    $0x4,%esp
8010503e:	ff 75 08             	push   0x8(%ebp)
80105041:	e8 1c eb ff ff       	call   80103b62 <holding_mylock>
80105046:	c9                   	leave  
80105047:	c3                   	ret    

80105048 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105048:	1e                   	push   %ds
  pushl %es
80105049:	06                   	push   %es
  pushl %fs
8010504a:	0f a0                	push   %fs
  pushl %gs
8010504c:	0f a8                	push   %gs
  pushal
8010504e:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010504f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105053:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105055:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105057:	54                   	push   %esp
  call trap
80105058:	e8 37 01 00 00       	call   80105194 <trap>
  addl $4, %esp
8010505d:	83 c4 04             	add    $0x4,%esp

80105060 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105060:	61                   	popa   
  popl %gs
80105061:	0f a9                	pop    %gs
  popl %fs
80105063:	0f a1                	pop    %fs
  popl %es
80105065:	07                   	pop    %es
  popl %ds
80105066:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105067:	83 c4 08             	add    $0x8,%esp
  iret
8010506a:	cf                   	iret   

8010506b <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010506b:	55                   	push   %ebp
8010506c:	89 e5                	mov    %esp,%ebp
8010506e:	53                   	push   %ebx
8010506f:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80105072:	b8 00 00 00 00       	mov    $0x0,%eax
80105077:	eb 76                	jmp    801050ef <tvinit+0x84>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105079:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80105080:	66 89 0c c5 e0 3d 11 	mov    %cx,-0x7feec220(,%eax,8)
80105087:	80 
80105088:	66 c7 04 c5 e2 3d 11 	movw   $0x8,-0x7feec21e(,%eax,8)
8010508f:	80 08 00 
80105092:	0f b6 14 c5 e4 3d 11 	movzbl -0x7feec21c(,%eax,8),%edx
80105099:	80 
8010509a:	83 e2 e0             	and    $0xffffffe0,%edx
8010509d:	88 14 c5 e4 3d 11 80 	mov    %dl,-0x7feec21c(,%eax,8)
801050a4:	c6 04 c5 e4 3d 11 80 	movb   $0x0,-0x7feec21c(,%eax,8)
801050ab:	00 
801050ac:	0f b6 14 c5 e5 3d 11 	movzbl -0x7feec21b(,%eax,8),%edx
801050b3:	80 
801050b4:	83 e2 f0             	and    $0xfffffff0,%edx
801050b7:	83 ca 0e             	or     $0xe,%edx
801050ba:	88 14 c5 e5 3d 11 80 	mov    %dl,-0x7feec21b(,%eax,8)
801050c1:	89 d3                	mov    %edx,%ebx
801050c3:	83 e3 ef             	and    $0xffffffef,%ebx
801050c6:	88 1c c5 e5 3d 11 80 	mov    %bl,-0x7feec21b(,%eax,8)
801050cd:	83 e2 8f             	and    $0xffffff8f,%edx
801050d0:	88 14 c5 e5 3d 11 80 	mov    %dl,-0x7feec21b(,%eax,8)
801050d7:	83 ca 80             	or     $0xffffff80,%edx
801050da:	88 14 c5 e5 3d 11 80 	mov    %dl,-0x7feec21b(,%eax,8)
801050e1:	c1 e9 10             	shr    $0x10,%ecx
801050e4:	66 89 0c c5 e6 3d 11 	mov    %cx,-0x7feec21a(,%eax,8)
801050eb:	80 
  for(i = 0; i < 256; i++)
801050ec:	83 c0 01             	add    $0x1,%eax
801050ef:	3d ff 00 00 00       	cmp    $0xff,%eax
801050f4:	7e 83                	jle    80105079 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801050f6:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
801050fc:	66 89 15 e0 3f 11 80 	mov    %dx,0x80113fe0
80105103:	66 c7 05 e2 3f 11 80 	movw   $0x8,0x80113fe2
8010510a:	08 00 
8010510c:	0f b6 05 e4 3f 11 80 	movzbl 0x80113fe4,%eax
80105113:	83 e0 e0             	and    $0xffffffe0,%eax
80105116:	a2 e4 3f 11 80       	mov    %al,0x80113fe4
8010511b:	c6 05 e4 3f 11 80 00 	movb   $0x0,0x80113fe4
80105122:	0f b6 05 e5 3f 11 80 	movzbl 0x80113fe5,%eax
80105129:	83 c8 0f             	or     $0xf,%eax
8010512c:	a2 e5 3f 11 80       	mov    %al,0x80113fe5
80105131:	83 e0 ef             	and    $0xffffffef,%eax
80105134:	a2 e5 3f 11 80       	mov    %al,0x80113fe5
80105139:	89 c1                	mov    %eax,%ecx
8010513b:	83 c9 60             	or     $0x60,%ecx
8010513e:	88 0d e5 3f 11 80    	mov    %cl,0x80113fe5
80105144:	83 c8 e0             	or     $0xffffffe0,%eax
80105147:	a2 e5 3f 11 80       	mov    %al,0x80113fe5
8010514c:	c1 ea 10             	shr    $0x10,%edx
8010514f:	66 89 15 e6 3f 11 80 	mov    %dx,0x80113fe6

  initlock(&tickslock, "time");
80105156:	83 ec 08             	sub    $0x8,%esp
80105159:	68 38 72 10 80       	push   $0x80107238
8010515e:	68 a0 3d 11 80       	push   $0x80113da0
80105163:	e8 1b eb ff ff       	call   80103c83 <initlock>
}
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010516e:	c9                   	leave  
8010516f:	c3                   	ret    

80105170 <idtinit>:

void
idtinit(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105176:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010517c:	b8 e0 3d 11 80       	mov    $0x80113de0,%eax
80105181:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105185:	c1 e8 10             	shr    $0x10,%eax
80105188:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010518c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010518f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105192:	c9                   	leave  
80105193:	c3                   	ret    

80105194 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	57                   	push   %edi
80105198:	56                   	push   %esi
80105199:	53                   	push   %ebx
8010519a:	83 ec 1c             	sub    $0x1c,%esp
8010519d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801051a0:	8b 43 30             	mov    0x30(%ebx),%eax
801051a3:	83 f8 40             	cmp    $0x40,%eax
801051a6:	74 13                	je     801051bb <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801051a8:	83 e8 20             	sub    $0x20,%eax
801051ab:	83 f8 1f             	cmp    $0x1f,%eax
801051ae:	0f 87 3a 01 00 00    	ja     801052ee <trap+0x15a>
801051b4:	ff 24 85 e0 72 10 80 	jmp    *-0x7fef8d20(,%eax,4)
    if(myproc()->killed)
801051bb:	e8 f5 df ff ff       	call   801031b5 <myproc>
801051c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051c4:	75 1f                	jne    801051e5 <trap+0x51>
    myproc()->tf = tf;
801051c6:	e8 ea df ff ff       	call   801031b5 <myproc>
801051cb:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801051ce:	e8 ab ef ff ff       	call   8010417e <syscall>
    if(myproc()->killed)
801051d3:	e8 dd df ff ff       	call   801031b5 <myproc>
801051d8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801051dc:	74 7e                	je     8010525c <trap+0xc8>
      exit();
801051de:	e8 82 e3 ff ff       	call   80103565 <exit>
    return;
801051e3:	eb 77                	jmp    8010525c <trap+0xc8>
      exit();
801051e5:	e8 7b e3 ff ff       	call   80103565 <exit>
801051ea:	eb da                	jmp    801051c6 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801051ec:	e8 a9 df ff ff       	call   8010319a <cpuid>
801051f1:	85 c0                	test   %eax,%eax
801051f3:	74 6f                	je     80105264 <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801051f5:	e8 7c d1 ff ff       	call   80102376 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801051fa:	e8 b6 df ff ff       	call   801031b5 <myproc>
801051ff:	85 c0                	test   %eax,%eax
80105201:	74 1c                	je     8010521f <trap+0x8b>
80105203:	e8 ad df ff ff       	call   801031b5 <myproc>
80105208:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010520c:	74 11                	je     8010521f <trap+0x8b>
8010520e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105212:	83 e0 03             	and    $0x3,%eax
80105215:	66 83 f8 03          	cmp    $0x3,%ax
80105219:	0f 84 62 01 00 00    	je     80105381 <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010521f:	e8 91 df ff ff       	call   801031b5 <myproc>
80105224:	85 c0                	test   %eax,%eax
80105226:	74 0f                	je     80105237 <trap+0xa3>
80105228:	e8 88 df ff ff       	call   801031b5 <myproc>
8010522d:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105231:	0f 84 54 01 00 00    	je     8010538b <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105237:	e8 79 df ff ff       	call   801031b5 <myproc>
8010523c:	85 c0                	test   %eax,%eax
8010523e:	74 1c                	je     8010525c <trap+0xc8>
80105240:	e8 70 df ff ff       	call   801031b5 <myproc>
80105245:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105249:	74 11                	je     8010525c <trap+0xc8>
8010524b:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010524f:	83 e0 03             	and    $0x3,%eax
80105252:	66 83 f8 03          	cmp    $0x3,%ax
80105256:	0f 84 43 01 00 00    	je     8010539f <trap+0x20b>
    exit();
}
8010525c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010525f:	5b                   	pop    %ebx
80105260:	5e                   	pop    %esi
80105261:	5f                   	pop    %edi
80105262:	5d                   	pop    %ebp
80105263:	c3                   	ret    
      acquire(&tickslock);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	68 a0 3d 11 80       	push   $0x80113da0
8010526c:	e8 4e eb ff ff       	call   80103dbf <acquire>
      ticks++;
80105271:	83 05 80 3d 11 80 01 	addl   $0x1,0x80113d80
      wakeup(&ticks);
80105278:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
8010527f:	e8 5d e5 ff ff       	call   801037e1 <wakeup>
      release(&tickslock);
80105284:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010528b:	e8 94 eb ff ff       	call   80103e24 <release>
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	e9 5d ff ff ff       	jmp    801051f5 <trap+0x61>
    ideintr();
80105298:	e8 bf ca ff ff       	call   80101d5c <ideintr>
    lapiceoi();
8010529d:	e8 d4 d0 ff ff       	call   80102376 <lapiceoi>
    break;
801052a2:	e9 53 ff ff ff       	jmp    801051fa <trap+0x66>
    kbdintr();
801052a7:	e8 14 cf ff ff       	call   801021c0 <kbdintr>
    lapiceoi();
801052ac:	e8 c5 d0 ff ff       	call   80102376 <lapiceoi>
    break;
801052b1:	e9 44 ff ff ff       	jmp    801051fa <trap+0x66>
    uartintr();
801052b6:	e8 fe 01 00 00       	call   801054b9 <uartintr>
    lapiceoi();
801052bb:	e8 b6 d0 ff ff       	call   80102376 <lapiceoi>
    break;
801052c0:	e9 35 ff ff ff       	jmp    801051fa <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801052c5:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801052c8:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801052cc:	e8 c9 de ff ff       	call   8010319a <cpuid>
801052d1:	57                   	push   %edi
801052d2:	0f b7 f6             	movzwl %si,%esi
801052d5:	56                   	push   %esi
801052d6:	50                   	push   %eax
801052d7:	68 44 72 10 80       	push   $0x80107244
801052dc:	e8 26 b3 ff ff       	call   80100607 <cprintf>
    lapiceoi();
801052e1:	e8 90 d0 ff ff       	call   80102376 <lapiceoi>
    break;
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	e9 0c ff ff ff       	jmp    801051fa <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801052ee:	e8 c2 de ff ff       	call   801031b5 <myproc>
801052f3:	85 c0                	test   %eax,%eax
801052f5:	74 5f                	je     80105356 <trap+0x1c2>
801052f7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801052fb:	74 59                	je     80105356 <trap+0x1c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801052fd:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105300:	8b 43 38             	mov    0x38(%ebx),%eax
80105303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105306:	e8 8f de ff ff       	call   8010319a <cpuid>
8010530b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010530e:	8b 53 34             	mov    0x34(%ebx),%edx
80105311:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105314:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105317:	e8 99 de ff ff       	call   801031b5 <myproc>
8010531c:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010531f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105322:	e8 8e de ff ff       	call   801031b5 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105327:	57                   	push   %edi
80105328:	ff 75 e4             	push   -0x1c(%ebp)
8010532b:	ff 75 e0             	push   -0x20(%ebp)
8010532e:	ff 75 dc             	push   -0x24(%ebp)
80105331:	56                   	push   %esi
80105332:	ff 75 d8             	push   -0x28(%ebp)
80105335:	ff 70 10             	push   0x10(%eax)
80105338:	68 9c 72 10 80       	push   $0x8010729c
8010533d:	e8 c5 b2 ff ff       	call   80100607 <cprintf>
    myproc()->killed = 1;
80105342:	83 c4 20             	add    $0x20,%esp
80105345:	e8 6b de ff ff       	call   801031b5 <myproc>
8010534a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105351:	e9 a4 fe ff ff       	jmp    801051fa <trap+0x66>
80105356:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105359:	8b 73 38             	mov    0x38(%ebx),%esi
8010535c:	e8 39 de ff ff       	call   8010319a <cpuid>
80105361:	83 ec 0c             	sub    $0xc,%esp
80105364:	57                   	push   %edi
80105365:	56                   	push   %esi
80105366:	50                   	push   %eax
80105367:	ff 73 30             	push   0x30(%ebx)
8010536a:	68 68 72 10 80       	push   $0x80107268
8010536f:	e8 93 b2 ff ff       	call   80100607 <cprintf>
      panic("trap");
80105374:	83 c4 14             	add    $0x14,%esp
80105377:	68 3d 72 10 80       	push   $0x8010723d
8010537c:	e8 c7 af ff ff       	call   80100348 <panic>
    exit();
80105381:	e8 df e1 ff ff       	call   80103565 <exit>
80105386:	e9 94 fe ff ff       	jmp    8010521f <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
8010538b:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010538f:	0f 85 a2 fe ff ff    	jne    80105237 <trap+0xa3>
    yield();
80105395:	e8 b0 e2 ff ff       	call   8010364a <yield>
8010539a:	e9 98 fe ff ff       	jmp    80105237 <trap+0xa3>
    exit();
8010539f:	e8 c1 e1 ff ff       	call   80103565 <exit>
801053a4:	e9 b3 fe ff ff       	jmp    8010525c <trap+0xc8>

801053a9 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801053a9:	83 3d e0 45 11 80 00 	cmpl   $0x0,0x801145e0
801053b0:	74 14                	je     801053c6 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801053b2:	ba fd 03 00 00       	mov    $0x3fd,%edx
801053b7:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801053b8:	a8 01                	test   $0x1,%al
801053ba:	74 10                	je     801053cc <uartgetc+0x23>
801053bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053c1:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801053c2:	0f b6 c0             	movzbl %al,%eax
801053c5:	c3                   	ret    
    return -1;
801053c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cb:	c3                   	ret    
    return -1;
801053cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d1:	c3                   	ret    

801053d2 <uartputc>:
  if(!uart)
801053d2:	83 3d e0 45 11 80 00 	cmpl   $0x0,0x801145e0
801053d9:	74 3b                	je     80105416 <uartputc+0x44>
{
801053db:	55                   	push   %ebp
801053dc:	89 e5                	mov    %esp,%ebp
801053de:	53                   	push   %ebx
801053df:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053e2:	bb 00 00 00 00       	mov    $0x0,%ebx
801053e7:	eb 10                	jmp    801053f9 <uartputc+0x27>
    microdelay(10);
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	6a 0a                	push   $0xa
801053ee:	e8 a4 cf ff ff       	call   80102397 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053f3:	83 c3 01             	add    $0x1,%ebx
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	83 fb 7f             	cmp    $0x7f,%ebx
801053fc:	7f 0a                	jg     80105408 <uartputc+0x36>
801053fe:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105403:	ec                   	in     (%dx),%al
80105404:	a8 20                	test   $0x20,%al
80105406:	74 e1                	je     801053e9 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105408:	8b 45 08             	mov    0x8(%ebp),%eax
8010540b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105410:	ee                   	out    %al,(%dx)
}
80105411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105414:	c9                   	leave  
80105415:	c3                   	ret    
80105416:	c3                   	ret    

80105417 <uartinit>:
{
80105417:	55                   	push   %ebp
80105418:	89 e5                	mov    %esp,%ebp
8010541a:	56                   	push   %esi
8010541b:	53                   	push   %ebx
8010541c:	b9 00 00 00 00       	mov    $0x0,%ecx
80105421:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105426:	89 c8                	mov    %ecx,%eax
80105428:	ee                   	out    %al,(%dx)
80105429:	be fb 03 00 00       	mov    $0x3fb,%esi
8010542e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105433:	89 f2                	mov    %esi,%edx
80105435:	ee                   	out    %al,(%dx)
80105436:	b8 0c 00 00 00       	mov    $0xc,%eax
8010543b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105440:	ee                   	out    %al,(%dx)
80105441:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105446:	89 c8                	mov    %ecx,%eax
80105448:	89 da                	mov    %ebx,%edx
8010544a:	ee                   	out    %al,(%dx)
8010544b:	b8 03 00 00 00       	mov    $0x3,%eax
80105450:	89 f2                	mov    %esi,%edx
80105452:	ee                   	out    %al,(%dx)
80105453:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105458:	89 c8                	mov    %ecx,%eax
8010545a:	ee                   	out    %al,(%dx)
8010545b:	b8 01 00 00 00       	mov    $0x1,%eax
80105460:	89 da                	mov    %ebx,%edx
80105462:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105463:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105468:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105469:	3c ff                	cmp    $0xff,%al
8010546b:	74 45                	je     801054b2 <uartinit+0x9b>
  uart = 1;
8010546d:	c7 05 e0 45 11 80 01 	movl   $0x1,0x801145e0
80105474:	00 00 00 
80105477:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010547c:	ec                   	in     (%dx),%al
8010547d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105482:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105483:	83 ec 08             	sub    $0x8,%esp
80105486:	6a 00                	push   $0x0
80105488:	6a 04                	push   $0x4
8010548a:	e8 d2 ca ff ff       	call   80101f61 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010548f:	83 c4 10             	add    $0x10,%esp
80105492:	bb 60 73 10 80       	mov    $0x80107360,%ebx
80105497:	eb 12                	jmp    801054ab <uartinit+0x94>
    uartputc(*p);
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	0f be c0             	movsbl %al,%eax
8010549f:	50                   	push   %eax
801054a0:	e8 2d ff ff ff       	call   801053d2 <uartputc>
  for(p="xv6...\n"; *p; p++)
801054a5:	83 c3 01             	add    $0x1,%ebx
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	0f b6 03             	movzbl (%ebx),%eax
801054ae:	84 c0                	test   %al,%al
801054b0:	75 e7                	jne    80105499 <uartinit+0x82>
}
801054b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b5:	5b                   	pop    %ebx
801054b6:	5e                   	pop    %esi
801054b7:	5d                   	pop    %ebp
801054b8:	c3                   	ret    

801054b9 <uartintr>:

void
uartintr(void)
{
801054b9:	55                   	push   %ebp
801054ba:	89 e5                	mov    %esp,%ebp
801054bc:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801054bf:	68 a9 53 10 80       	push   $0x801053a9
801054c4:	e8 6a b2 ff ff       	call   80100733 <consoleintr>
}
801054c9:	83 c4 10             	add    $0x10,%esp
801054cc:	c9                   	leave  
801054cd:	c3                   	ret    

801054ce <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801054ce:	6a 00                	push   $0x0
  pushl $0
801054d0:	6a 00                	push   $0x0
  jmp alltraps
801054d2:	e9 71 fb ff ff       	jmp    80105048 <alltraps>

801054d7 <vector1>:
.globl vector1
vector1:
  pushl $0
801054d7:	6a 00                	push   $0x0
  pushl $1
801054d9:	6a 01                	push   $0x1
  jmp alltraps
801054db:	e9 68 fb ff ff       	jmp    80105048 <alltraps>

801054e0 <vector2>:
.globl vector2
vector2:
  pushl $0
801054e0:	6a 00                	push   $0x0
  pushl $2
801054e2:	6a 02                	push   $0x2
  jmp alltraps
801054e4:	e9 5f fb ff ff       	jmp    80105048 <alltraps>

801054e9 <vector3>:
.globl vector3
vector3:
  pushl $0
801054e9:	6a 00                	push   $0x0
  pushl $3
801054eb:	6a 03                	push   $0x3
  jmp alltraps
801054ed:	e9 56 fb ff ff       	jmp    80105048 <alltraps>

801054f2 <vector4>:
.globl vector4
vector4:
  pushl $0
801054f2:	6a 00                	push   $0x0
  pushl $4
801054f4:	6a 04                	push   $0x4
  jmp alltraps
801054f6:	e9 4d fb ff ff       	jmp    80105048 <alltraps>

801054fb <vector5>:
.globl vector5
vector5:
  pushl $0
801054fb:	6a 00                	push   $0x0
  pushl $5
801054fd:	6a 05                	push   $0x5
  jmp alltraps
801054ff:	e9 44 fb ff ff       	jmp    80105048 <alltraps>

80105504 <vector6>:
.globl vector6
vector6:
  pushl $0
80105504:	6a 00                	push   $0x0
  pushl $6
80105506:	6a 06                	push   $0x6
  jmp alltraps
80105508:	e9 3b fb ff ff       	jmp    80105048 <alltraps>

8010550d <vector7>:
.globl vector7
vector7:
  pushl $0
8010550d:	6a 00                	push   $0x0
  pushl $7
8010550f:	6a 07                	push   $0x7
  jmp alltraps
80105511:	e9 32 fb ff ff       	jmp    80105048 <alltraps>

80105516 <vector8>:
.globl vector8
vector8:
  pushl $8
80105516:	6a 08                	push   $0x8
  jmp alltraps
80105518:	e9 2b fb ff ff       	jmp    80105048 <alltraps>

8010551d <vector9>:
.globl vector9
vector9:
  pushl $0
8010551d:	6a 00                	push   $0x0
  pushl $9
8010551f:	6a 09                	push   $0x9
  jmp alltraps
80105521:	e9 22 fb ff ff       	jmp    80105048 <alltraps>

80105526 <vector10>:
.globl vector10
vector10:
  pushl $10
80105526:	6a 0a                	push   $0xa
  jmp alltraps
80105528:	e9 1b fb ff ff       	jmp    80105048 <alltraps>

8010552d <vector11>:
.globl vector11
vector11:
  pushl $11
8010552d:	6a 0b                	push   $0xb
  jmp alltraps
8010552f:	e9 14 fb ff ff       	jmp    80105048 <alltraps>

80105534 <vector12>:
.globl vector12
vector12:
  pushl $12
80105534:	6a 0c                	push   $0xc
  jmp alltraps
80105536:	e9 0d fb ff ff       	jmp    80105048 <alltraps>

8010553b <vector13>:
.globl vector13
vector13:
  pushl $13
8010553b:	6a 0d                	push   $0xd
  jmp alltraps
8010553d:	e9 06 fb ff ff       	jmp    80105048 <alltraps>

80105542 <vector14>:
.globl vector14
vector14:
  pushl $14
80105542:	6a 0e                	push   $0xe
  jmp alltraps
80105544:	e9 ff fa ff ff       	jmp    80105048 <alltraps>

80105549 <vector15>:
.globl vector15
vector15:
  pushl $0
80105549:	6a 00                	push   $0x0
  pushl $15
8010554b:	6a 0f                	push   $0xf
  jmp alltraps
8010554d:	e9 f6 fa ff ff       	jmp    80105048 <alltraps>

80105552 <vector16>:
.globl vector16
vector16:
  pushl $0
80105552:	6a 00                	push   $0x0
  pushl $16
80105554:	6a 10                	push   $0x10
  jmp alltraps
80105556:	e9 ed fa ff ff       	jmp    80105048 <alltraps>

8010555b <vector17>:
.globl vector17
vector17:
  pushl $17
8010555b:	6a 11                	push   $0x11
  jmp alltraps
8010555d:	e9 e6 fa ff ff       	jmp    80105048 <alltraps>

80105562 <vector18>:
.globl vector18
vector18:
  pushl $0
80105562:	6a 00                	push   $0x0
  pushl $18
80105564:	6a 12                	push   $0x12
  jmp alltraps
80105566:	e9 dd fa ff ff       	jmp    80105048 <alltraps>

8010556b <vector19>:
.globl vector19
vector19:
  pushl $0
8010556b:	6a 00                	push   $0x0
  pushl $19
8010556d:	6a 13                	push   $0x13
  jmp alltraps
8010556f:	e9 d4 fa ff ff       	jmp    80105048 <alltraps>

80105574 <vector20>:
.globl vector20
vector20:
  pushl $0
80105574:	6a 00                	push   $0x0
  pushl $20
80105576:	6a 14                	push   $0x14
  jmp alltraps
80105578:	e9 cb fa ff ff       	jmp    80105048 <alltraps>

8010557d <vector21>:
.globl vector21
vector21:
  pushl $0
8010557d:	6a 00                	push   $0x0
  pushl $21
8010557f:	6a 15                	push   $0x15
  jmp alltraps
80105581:	e9 c2 fa ff ff       	jmp    80105048 <alltraps>

80105586 <vector22>:
.globl vector22
vector22:
  pushl $0
80105586:	6a 00                	push   $0x0
  pushl $22
80105588:	6a 16                	push   $0x16
  jmp alltraps
8010558a:	e9 b9 fa ff ff       	jmp    80105048 <alltraps>

8010558f <vector23>:
.globl vector23
vector23:
  pushl $0
8010558f:	6a 00                	push   $0x0
  pushl $23
80105591:	6a 17                	push   $0x17
  jmp alltraps
80105593:	e9 b0 fa ff ff       	jmp    80105048 <alltraps>

80105598 <vector24>:
.globl vector24
vector24:
  pushl $0
80105598:	6a 00                	push   $0x0
  pushl $24
8010559a:	6a 18                	push   $0x18
  jmp alltraps
8010559c:	e9 a7 fa ff ff       	jmp    80105048 <alltraps>

801055a1 <vector25>:
.globl vector25
vector25:
  pushl $0
801055a1:	6a 00                	push   $0x0
  pushl $25
801055a3:	6a 19                	push   $0x19
  jmp alltraps
801055a5:	e9 9e fa ff ff       	jmp    80105048 <alltraps>

801055aa <vector26>:
.globl vector26
vector26:
  pushl $0
801055aa:	6a 00                	push   $0x0
  pushl $26
801055ac:	6a 1a                	push   $0x1a
  jmp alltraps
801055ae:	e9 95 fa ff ff       	jmp    80105048 <alltraps>

801055b3 <vector27>:
.globl vector27
vector27:
  pushl $0
801055b3:	6a 00                	push   $0x0
  pushl $27
801055b5:	6a 1b                	push   $0x1b
  jmp alltraps
801055b7:	e9 8c fa ff ff       	jmp    80105048 <alltraps>

801055bc <vector28>:
.globl vector28
vector28:
  pushl $0
801055bc:	6a 00                	push   $0x0
  pushl $28
801055be:	6a 1c                	push   $0x1c
  jmp alltraps
801055c0:	e9 83 fa ff ff       	jmp    80105048 <alltraps>

801055c5 <vector29>:
.globl vector29
vector29:
  pushl $0
801055c5:	6a 00                	push   $0x0
  pushl $29
801055c7:	6a 1d                	push   $0x1d
  jmp alltraps
801055c9:	e9 7a fa ff ff       	jmp    80105048 <alltraps>

801055ce <vector30>:
.globl vector30
vector30:
  pushl $0
801055ce:	6a 00                	push   $0x0
  pushl $30
801055d0:	6a 1e                	push   $0x1e
  jmp alltraps
801055d2:	e9 71 fa ff ff       	jmp    80105048 <alltraps>

801055d7 <vector31>:
.globl vector31
vector31:
  pushl $0
801055d7:	6a 00                	push   $0x0
  pushl $31
801055d9:	6a 1f                	push   $0x1f
  jmp alltraps
801055db:	e9 68 fa ff ff       	jmp    80105048 <alltraps>

801055e0 <vector32>:
.globl vector32
vector32:
  pushl $0
801055e0:	6a 00                	push   $0x0
  pushl $32
801055e2:	6a 20                	push   $0x20
  jmp alltraps
801055e4:	e9 5f fa ff ff       	jmp    80105048 <alltraps>

801055e9 <vector33>:
.globl vector33
vector33:
  pushl $0
801055e9:	6a 00                	push   $0x0
  pushl $33
801055eb:	6a 21                	push   $0x21
  jmp alltraps
801055ed:	e9 56 fa ff ff       	jmp    80105048 <alltraps>

801055f2 <vector34>:
.globl vector34
vector34:
  pushl $0
801055f2:	6a 00                	push   $0x0
  pushl $34
801055f4:	6a 22                	push   $0x22
  jmp alltraps
801055f6:	e9 4d fa ff ff       	jmp    80105048 <alltraps>

801055fb <vector35>:
.globl vector35
vector35:
  pushl $0
801055fb:	6a 00                	push   $0x0
  pushl $35
801055fd:	6a 23                	push   $0x23
  jmp alltraps
801055ff:	e9 44 fa ff ff       	jmp    80105048 <alltraps>

80105604 <vector36>:
.globl vector36
vector36:
  pushl $0
80105604:	6a 00                	push   $0x0
  pushl $36
80105606:	6a 24                	push   $0x24
  jmp alltraps
80105608:	e9 3b fa ff ff       	jmp    80105048 <alltraps>

8010560d <vector37>:
.globl vector37
vector37:
  pushl $0
8010560d:	6a 00                	push   $0x0
  pushl $37
8010560f:	6a 25                	push   $0x25
  jmp alltraps
80105611:	e9 32 fa ff ff       	jmp    80105048 <alltraps>

80105616 <vector38>:
.globl vector38
vector38:
  pushl $0
80105616:	6a 00                	push   $0x0
  pushl $38
80105618:	6a 26                	push   $0x26
  jmp alltraps
8010561a:	e9 29 fa ff ff       	jmp    80105048 <alltraps>

8010561f <vector39>:
.globl vector39
vector39:
  pushl $0
8010561f:	6a 00                	push   $0x0
  pushl $39
80105621:	6a 27                	push   $0x27
  jmp alltraps
80105623:	e9 20 fa ff ff       	jmp    80105048 <alltraps>

80105628 <vector40>:
.globl vector40
vector40:
  pushl $0
80105628:	6a 00                	push   $0x0
  pushl $40
8010562a:	6a 28                	push   $0x28
  jmp alltraps
8010562c:	e9 17 fa ff ff       	jmp    80105048 <alltraps>

80105631 <vector41>:
.globl vector41
vector41:
  pushl $0
80105631:	6a 00                	push   $0x0
  pushl $41
80105633:	6a 29                	push   $0x29
  jmp alltraps
80105635:	e9 0e fa ff ff       	jmp    80105048 <alltraps>

8010563a <vector42>:
.globl vector42
vector42:
  pushl $0
8010563a:	6a 00                	push   $0x0
  pushl $42
8010563c:	6a 2a                	push   $0x2a
  jmp alltraps
8010563e:	e9 05 fa ff ff       	jmp    80105048 <alltraps>

80105643 <vector43>:
.globl vector43
vector43:
  pushl $0
80105643:	6a 00                	push   $0x0
  pushl $43
80105645:	6a 2b                	push   $0x2b
  jmp alltraps
80105647:	e9 fc f9 ff ff       	jmp    80105048 <alltraps>

8010564c <vector44>:
.globl vector44
vector44:
  pushl $0
8010564c:	6a 00                	push   $0x0
  pushl $44
8010564e:	6a 2c                	push   $0x2c
  jmp alltraps
80105650:	e9 f3 f9 ff ff       	jmp    80105048 <alltraps>

80105655 <vector45>:
.globl vector45
vector45:
  pushl $0
80105655:	6a 00                	push   $0x0
  pushl $45
80105657:	6a 2d                	push   $0x2d
  jmp alltraps
80105659:	e9 ea f9 ff ff       	jmp    80105048 <alltraps>

8010565e <vector46>:
.globl vector46
vector46:
  pushl $0
8010565e:	6a 00                	push   $0x0
  pushl $46
80105660:	6a 2e                	push   $0x2e
  jmp alltraps
80105662:	e9 e1 f9 ff ff       	jmp    80105048 <alltraps>

80105667 <vector47>:
.globl vector47
vector47:
  pushl $0
80105667:	6a 00                	push   $0x0
  pushl $47
80105669:	6a 2f                	push   $0x2f
  jmp alltraps
8010566b:	e9 d8 f9 ff ff       	jmp    80105048 <alltraps>

80105670 <vector48>:
.globl vector48
vector48:
  pushl $0
80105670:	6a 00                	push   $0x0
  pushl $48
80105672:	6a 30                	push   $0x30
  jmp alltraps
80105674:	e9 cf f9 ff ff       	jmp    80105048 <alltraps>

80105679 <vector49>:
.globl vector49
vector49:
  pushl $0
80105679:	6a 00                	push   $0x0
  pushl $49
8010567b:	6a 31                	push   $0x31
  jmp alltraps
8010567d:	e9 c6 f9 ff ff       	jmp    80105048 <alltraps>

80105682 <vector50>:
.globl vector50
vector50:
  pushl $0
80105682:	6a 00                	push   $0x0
  pushl $50
80105684:	6a 32                	push   $0x32
  jmp alltraps
80105686:	e9 bd f9 ff ff       	jmp    80105048 <alltraps>

8010568b <vector51>:
.globl vector51
vector51:
  pushl $0
8010568b:	6a 00                	push   $0x0
  pushl $51
8010568d:	6a 33                	push   $0x33
  jmp alltraps
8010568f:	e9 b4 f9 ff ff       	jmp    80105048 <alltraps>

80105694 <vector52>:
.globl vector52
vector52:
  pushl $0
80105694:	6a 00                	push   $0x0
  pushl $52
80105696:	6a 34                	push   $0x34
  jmp alltraps
80105698:	e9 ab f9 ff ff       	jmp    80105048 <alltraps>

8010569d <vector53>:
.globl vector53
vector53:
  pushl $0
8010569d:	6a 00                	push   $0x0
  pushl $53
8010569f:	6a 35                	push   $0x35
  jmp alltraps
801056a1:	e9 a2 f9 ff ff       	jmp    80105048 <alltraps>

801056a6 <vector54>:
.globl vector54
vector54:
  pushl $0
801056a6:	6a 00                	push   $0x0
  pushl $54
801056a8:	6a 36                	push   $0x36
  jmp alltraps
801056aa:	e9 99 f9 ff ff       	jmp    80105048 <alltraps>

801056af <vector55>:
.globl vector55
vector55:
  pushl $0
801056af:	6a 00                	push   $0x0
  pushl $55
801056b1:	6a 37                	push   $0x37
  jmp alltraps
801056b3:	e9 90 f9 ff ff       	jmp    80105048 <alltraps>

801056b8 <vector56>:
.globl vector56
vector56:
  pushl $0
801056b8:	6a 00                	push   $0x0
  pushl $56
801056ba:	6a 38                	push   $0x38
  jmp alltraps
801056bc:	e9 87 f9 ff ff       	jmp    80105048 <alltraps>

801056c1 <vector57>:
.globl vector57
vector57:
  pushl $0
801056c1:	6a 00                	push   $0x0
  pushl $57
801056c3:	6a 39                	push   $0x39
  jmp alltraps
801056c5:	e9 7e f9 ff ff       	jmp    80105048 <alltraps>

801056ca <vector58>:
.globl vector58
vector58:
  pushl $0
801056ca:	6a 00                	push   $0x0
  pushl $58
801056cc:	6a 3a                	push   $0x3a
  jmp alltraps
801056ce:	e9 75 f9 ff ff       	jmp    80105048 <alltraps>

801056d3 <vector59>:
.globl vector59
vector59:
  pushl $0
801056d3:	6a 00                	push   $0x0
  pushl $59
801056d5:	6a 3b                	push   $0x3b
  jmp alltraps
801056d7:	e9 6c f9 ff ff       	jmp    80105048 <alltraps>

801056dc <vector60>:
.globl vector60
vector60:
  pushl $0
801056dc:	6a 00                	push   $0x0
  pushl $60
801056de:	6a 3c                	push   $0x3c
  jmp alltraps
801056e0:	e9 63 f9 ff ff       	jmp    80105048 <alltraps>

801056e5 <vector61>:
.globl vector61
vector61:
  pushl $0
801056e5:	6a 00                	push   $0x0
  pushl $61
801056e7:	6a 3d                	push   $0x3d
  jmp alltraps
801056e9:	e9 5a f9 ff ff       	jmp    80105048 <alltraps>

801056ee <vector62>:
.globl vector62
vector62:
  pushl $0
801056ee:	6a 00                	push   $0x0
  pushl $62
801056f0:	6a 3e                	push   $0x3e
  jmp alltraps
801056f2:	e9 51 f9 ff ff       	jmp    80105048 <alltraps>

801056f7 <vector63>:
.globl vector63
vector63:
  pushl $0
801056f7:	6a 00                	push   $0x0
  pushl $63
801056f9:	6a 3f                	push   $0x3f
  jmp alltraps
801056fb:	e9 48 f9 ff ff       	jmp    80105048 <alltraps>

80105700 <vector64>:
.globl vector64
vector64:
  pushl $0
80105700:	6a 00                	push   $0x0
  pushl $64
80105702:	6a 40                	push   $0x40
  jmp alltraps
80105704:	e9 3f f9 ff ff       	jmp    80105048 <alltraps>

80105709 <vector65>:
.globl vector65
vector65:
  pushl $0
80105709:	6a 00                	push   $0x0
  pushl $65
8010570b:	6a 41                	push   $0x41
  jmp alltraps
8010570d:	e9 36 f9 ff ff       	jmp    80105048 <alltraps>

80105712 <vector66>:
.globl vector66
vector66:
  pushl $0
80105712:	6a 00                	push   $0x0
  pushl $66
80105714:	6a 42                	push   $0x42
  jmp alltraps
80105716:	e9 2d f9 ff ff       	jmp    80105048 <alltraps>

8010571b <vector67>:
.globl vector67
vector67:
  pushl $0
8010571b:	6a 00                	push   $0x0
  pushl $67
8010571d:	6a 43                	push   $0x43
  jmp alltraps
8010571f:	e9 24 f9 ff ff       	jmp    80105048 <alltraps>

80105724 <vector68>:
.globl vector68
vector68:
  pushl $0
80105724:	6a 00                	push   $0x0
  pushl $68
80105726:	6a 44                	push   $0x44
  jmp alltraps
80105728:	e9 1b f9 ff ff       	jmp    80105048 <alltraps>

8010572d <vector69>:
.globl vector69
vector69:
  pushl $0
8010572d:	6a 00                	push   $0x0
  pushl $69
8010572f:	6a 45                	push   $0x45
  jmp alltraps
80105731:	e9 12 f9 ff ff       	jmp    80105048 <alltraps>

80105736 <vector70>:
.globl vector70
vector70:
  pushl $0
80105736:	6a 00                	push   $0x0
  pushl $70
80105738:	6a 46                	push   $0x46
  jmp alltraps
8010573a:	e9 09 f9 ff ff       	jmp    80105048 <alltraps>

8010573f <vector71>:
.globl vector71
vector71:
  pushl $0
8010573f:	6a 00                	push   $0x0
  pushl $71
80105741:	6a 47                	push   $0x47
  jmp alltraps
80105743:	e9 00 f9 ff ff       	jmp    80105048 <alltraps>

80105748 <vector72>:
.globl vector72
vector72:
  pushl $0
80105748:	6a 00                	push   $0x0
  pushl $72
8010574a:	6a 48                	push   $0x48
  jmp alltraps
8010574c:	e9 f7 f8 ff ff       	jmp    80105048 <alltraps>

80105751 <vector73>:
.globl vector73
vector73:
  pushl $0
80105751:	6a 00                	push   $0x0
  pushl $73
80105753:	6a 49                	push   $0x49
  jmp alltraps
80105755:	e9 ee f8 ff ff       	jmp    80105048 <alltraps>

8010575a <vector74>:
.globl vector74
vector74:
  pushl $0
8010575a:	6a 00                	push   $0x0
  pushl $74
8010575c:	6a 4a                	push   $0x4a
  jmp alltraps
8010575e:	e9 e5 f8 ff ff       	jmp    80105048 <alltraps>

80105763 <vector75>:
.globl vector75
vector75:
  pushl $0
80105763:	6a 00                	push   $0x0
  pushl $75
80105765:	6a 4b                	push   $0x4b
  jmp alltraps
80105767:	e9 dc f8 ff ff       	jmp    80105048 <alltraps>

8010576c <vector76>:
.globl vector76
vector76:
  pushl $0
8010576c:	6a 00                	push   $0x0
  pushl $76
8010576e:	6a 4c                	push   $0x4c
  jmp alltraps
80105770:	e9 d3 f8 ff ff       	jmp    80105048 <alltraps>

80105775 <vector77>:
.globl vector77
vector77:
  pushl $0
80105775:	6a 00                	push   $0x0
  pushl $77
80105777:	6a 4d                	push   $0x4d
  jmp alltraps
80105779:	e9 ca f8 ff ff       	jmp    80105048 <alltraps>

8010577e <vector78>:
.globl vector78
vector78:
  pushl $0
8010577e:	6a 00                	push   $0x0
  pushl $78
80105780:	6a 4e                	push   $0x4e
  jmp alltraps
80105782:	e9 c1 f8 ff ff       	jmp    80105048 <alltraps>

80105787 <vector79>:
.globl vector79
vector79:
  pushl $0
80105787:	6a 00                	push   $0x0
  pushl $79
80105789:	6a 4f                	push   $0x4f
  jmp alltraps
8010578b:	e9 b8 f8 ff ff       	jmp    80105048 <alltraps>

80105790 <vector80>:
.globl vector80
vector80:
  pushl $0
80105790:	6a 00                	push   $0x0
  pushl $80
80105792:	6a 50                	push   $0x50
  jmp alltraps
80105794:	e9 af f8 ff ff       	jmp    80105048 <alltraps>

80105799 <vector81>:
.globl vector81
vector81:
  pushl $0
80105799:	6a 00                	push   $0x0
  pushl $81
8010579b:	6a 51                	push   $0x51
  jmp alltraps
8010579d:	e9 a6 f8 ff ff       	jmp    80105048 <alltraps>

801057a2 <vector82>:
.globl vector82
vector82:
  pushl $0
801057a2:	6a 00                	push   $0x0
  pushl $82
801057a4:	6a 52                	push   $0x52
  jmp alltraps
801057a6:	e9 9d f8 ff ff       	jmp    80105048 <alltraps>

801057ab <vector83>:
.globl vector83
vector83:
  pushl $0
801057ab:	6a 00                	push   $0x0
  pushl $83
801057ad:	6a 53                	push   $0x53
  jmp alltraps
801057af:	e9 94 f8 ff ff       	jmp    80105048 <alltraps>

801057b4 <vector84>:
.globl vector84
vector84:
  pushl $0
801057b4:	6a 00                	push   $0x0
  pushl $84
801057b6:	6a 54                	push   $0x54
  jmp alltraps
801057b8:	e9 8b f8 ff ff       	jmp    80105048 <alltraps>

801057bd <vector85>:
.globl vector85
vector85:
  pushl $0
801057bd:	6a 00                	push   $0x0
  pushl $85
801057bf:	6a 55                	push   $0x55
  jmp alltraps
801057c1:	e9 82 f8 ff ff       	jmp    80105048 <alltraps>

801057c6 <vector86>:
.globl vector86
vector86:
  pushl $0
801057c6:	6a 00                	push   $0x0
  pushl $86
801057c8:	6a 56                	push   $0x56
  jmp alltraps
801057ca:	e9 79 f8 ff ff       	jmp    80105048 <alltraps>

801057cf <vector87>:
.globl vector87
vector87:
  pushl $0
801057cf:	6a 00                	push   $0x0
  pushl $87
801057d1:	6a 57                	push   $0x57
  jmp alltraps
801057d3:	e9 70 f8 ff ff       	jmp    80105048 <alltraps>

801057d8 <vector88>:
.globl vector88
vector88:
  pushl $0
801057d8:	6a 00                	push   $0x0
  pushl $88
801057da:	6a 58                	push   $0x58
  jmp alltraps
801057dc:	e9 67 f8 ff ff       	jmp    80105048 <alltraps>

801057e1 <vector89>:
.globl vector89
vector89:
  pushl $0
801057e1:	6a 00                	push   $0x0
  pushl $89
801057e3:	6a 59                	push   $0x59
  jmp alltraps
801057e5:	e9 5e f8 ff ff       	jmp    80105048 <alltraps>

801057ea <vector90>:
.globl vector90
vector90:
  pushl $0
801057ea:	6a 00                	push   $0x0
  pushl $90
801057ec:	6a 5a                	push   $0x5a
  jmp alltraps
801057ee:	e9 55 f8 ff ff       	jmp    80105048 <alltraps>

801057f3 <vector91>:
.globl vector91
vector91:
  pushl $0
801057f3:	6a 00                	push   $0x0
  pushl $91
801057f5:	6a 5b                	push   $0x5b
  jmp alltraps
801057f7:	e9 4c f8 ff ff       	jmp    80105048 <alltraps>

801057fc <vector92>:
.globl vector92
vector92:
  pushl $0
801057fc:	6a 00                	push   $0x0
  pushl $92
801057fe:	6a 5c                	push   $0x5c
  jmp alltraps
80105800:	e9 43 f8 ff ff       	jmp    80105048 <alltraps>

80105805 <vector93>:
.globl vector93
vector93:
  pushl $0
80105805:	6a 00                	push   $0x0
  pushl $93
80105807:	6a 5d                	push   $0x5d
  jmp alltraps
80105809:	e9 3a f8 ff ff       	jmp    80105048 <alltraps>

8010580e <vector94>:
.globl vector94
vector94:
  pushl $0
8010580e:	6a 00                	push   $0x0
  pushl $94
80105810:	6a 5e                	push   $0x5e
  jmp alltraps
80105812:	e9 31 f8 ff ff       	jmp    80105048 <alltraps>

80105817 <vector95>:
.globl vector95
vector95:
  pushl $0
80105817:	6a 00                	push   $0x0
  pushl $95
80105819:	6a 5f                	push   $0x5f
  jmp alltraps
8010581b:	e9 28 f8 ff ff       	jmp    80105048 <alltraps>

80105820 <vector96>:
.globl vector96
vector96:
  pushl $0
80105820:	6a 00                	push   $0x0
  pushl $96
80105822:	6a 60                	push   $0x60
  jmp alltraps
80105824:	e9 1f f8 ff ff       	jmp    80105048 <alltraps>

80105829 <vector97>:
.globl vector97
vector97:
  pushl $0
80105829:	6a 00                	push   $0x0
  pushl $97
8010582b:	6a 61                	push   $0x61
  jmp alltraps
8010582d:	e9 16 f8 ff ff       	jmp    80105048 <alltraps>

80105832 <vector98>:
.globl vector98
vector98:
  pushl $0
80105832:	6a 00                	push   $0x0
  pushl $98
80105834:	6a 62                	push   $0x62
  jmp alltraps
80105836:	e9 0d f8 ff ff       	jmp    80105048 <alltraps>

8010583b <vector99>:
.globl vector99
vector99:
  pushl $0
8010583b:	6a 00                	push   $0x0
  pushl $99
8010583d:	6a 63                	push   $0x63
  jmp alltraps
8010583f:	e9 04 f8 ff ff       	jmp    80105048 <alltraps>

80105844 <vector100>:
.globl vector100
vector100:
  pushl $0
80105844:	6a 00                	push   $0x0
  pushl $100
80105846:	6a 64                	push   $0x64
  jmp alltraps
80105848:	e9 fb f7 ff ff       	jmp    80105048 <alltraps>

8010584d <vector101>:
.globl vector101
vector101:
  pushl $0
8010584d:	6a 00                	push   $0x0
  pushl $101
8010584f:	6a 65                	push   $0x65
  jmp alltraps
80105851:	e9 f2 f7 ff ff       	jmp    80105048 <alltraps>

80105856 <vector102>:
.globl vector102
vector102:
  pushl $0
80105856:	6a 00                	push   $0x0
  pushl $102
80105858:	6a 66                	push   $0x66
  jmp alltraps
8010585a:	e9 e9 f7 ff ff       	jmp    80105048 <alltraps>

8010585f <vector103>:
.globl vector103
vector103:
  pushl $0
8010585f:	6a 00                	push   $0x0
  pushl $103
80105861:	6a 67                	push   $0x67
  jmp alltraps
80105863:	e9 e0 f7 ff ff       	jmp    80105048 <alltraps>

80105868 <vector104>:
.globl vector104
vector104:
  pushl $0
80105868:	6a 00                	push   $0x0
  pushl $104
8010586a:	6a 68                	push   $0x68
  jmp alltraps
8010586c:	e9 d7 f7 ff ff       	jmp    80105048 <alltraps>

80105871 <vector105>:
.globl vector105
vector105:
  pushl $0
80105871:	6a 00                	push   $0x0
  pushl $105
80105873:	6a 69                	push   $0x69
  jmp alltraps
80105875:	e9 ce f7 ff ff       	jmp    80105048 <alltraps>

8010587a <vector106>:
.globl vector106
vector106:
  pushl $0
8010587a:	6a 00                	push   $0x0
  pushl $106
8010587c:	6a 6a                	push   $0x6a
  jmp alltraps
8010587e:	e9 c5 f7 ff ff       	jmp    80105048 <alltraps>

80105883 <vector107>:
.globl vector107
vector107:
  pushl $0
80105883:	6a 00                	push   $0x0
  pushl $107
80105885:	6a 6b                	push   $0x6b
  jmp alltraps
80105887:	e9 bc f7 ff ff       	jmp    80105048 <alltraps>

8010588c <vector108>:
.globl vector108
vector108:
  pushl $0
8010588c:	6a 00                	push   $0x0
  pushl $108
8010588e:	6a 6c                	push   $0x6c
  jmp alltraps
80105890:	e9 b3 f7 ff ff       	jmp    80105048 <alltraps>

80105895 <vector109>:
.globl vector109
vector109:
  pushl $0
80105895:	6a 00                	push   $0x0
  pushl $109
80105897:	6a 6d                	push   $0x6d
  jmp alltraps
80105899:	e9 aa f7 ff ff       	jmp    80105048 <alltraps>

8010589e <vector110>:
.globl vector110
vector110:
  pushl $0
8010589e:	6a 00                	push   $0x0
  pushl $110
801058a0:	6a 6e                	push   $0x6e
  jmp alltraps
801058a2:	e9 a1 f7 ff ff       	jmp    80105048 <alltraps>

801058a7 <vector111>:
.globl vector111
vector111:
  pushl $0
801058a7:	6a 00                	push   $0x0
  pushl $111
801058a9:	6a 6f                	push   $0x6f
  jmp alltraps
801058ab:	e9 98 f7 ff ff       	jmp    80105048 <alltraps>

801058b0 <vector112>:
.globl vector112
vector112:
  pushl $0
801058b0:	6a 00                	push   $0x0
  pushl $112
801058b2:	6a 70                	push   $0x70
  jmp alltraps
801058b4:	e9 8f f7 ff ff       	jmp    80105048 <alltraps>

801058b9 <vector113>:
.globl vector113
vector113:
  pushl $0
801058b9:	6a 00                	push   $0x0
  pushl $113
801058bb:	6a 71                	push   $0x71
  jmp alltraps
801058bd:	e9 86 f7 ff ff       	jmp    80105048 <alltraps>

801058c2 <vector114>:
.globl vector114
vector114:
  pushl $0
801058c2:	6a 00                	push   $0x0
  pushl $114
801058c4:	6a 72                	push   $0x72
  jmp alltraps
801058c6:	e9 7d f7 ff ff       	jmp    80105048 <alltraps>

801058cb <vector115>:
.globl vector115
vector115:
  pushl $0
801058cb:	6a 00                	push   $0x0
  pushl $115
801058cd:	6a 73                	push   $0x73
  jmp alltraps
801058cf:	e9 74 f7 ff ff       	jmp    80105048 <alltraps>

801058d4 <vector116>:
.globl vector116
vector116:
  pushl $0
801058d4:	6a 00                	push   $0x0
  pushl $116
801058d6:	6a 74                	push   $0x74
  jmp alltraps
801058d8:	e9 6b f7 ff ff       	jmp    80105048 <alltraps>

801058dd <vector117>:
.globl vector117
vector117:
  pushl $0
801058dd:	6a 00                	push   $0x0
  pushl $117
801058df:	6a 75                	push   $0x75
  jmp alltraps
801058e1:	e9 62 f7 ff ff       	jmp    80105048 <alltraps>

801058e6 <vector118>:
.globl vector118
vector118:
  pushl $0
801058e6:	6a 00                	push   $0x0
  pushl $118
801058e8:	6a 76                	push   $0x76
  jmp alltraps
801058ea:	e9 59 f7 ff ff       	jmp    80105048 <alltraps>

801058ef <vector119>:
.globl vector119
vector119:
  pushl $0
801058ef:	6a 00                	push   $0x0
  pushl $119
801058f1:	6a 77                	push   $0x77
  jmp alltraps
801058f3:	e9 50 f7 ff ff       	jmp    80105048 <alltraps>

801058f8 <vector120>:
.globl vector120
vector120:
  pushl $0
801058f8:	6a 00                	push   $0x0
  pushl $120
801058fa:	6a 78                	push   $0x78
  jmp alltraps
801058fc:	e9 47 f7 ff ff       	jmp    80105048 <alltraps>

80105901 <vector121>:
.globl vector121
vector121:
  pushl $0
80105901:	6a 00                	push   $0x0
  pushl $121
80105903:	6a 79                	push   $0x79
  jmp alltraps
80105905:	e9 3e f7 ff ff       	jmp    80105048 <alltraps>

8010590a <vector122>:
.globl vector122
vector122:
  pushl $0
8010590a:	6a 00                	push   $0x0
  pushl $122
8010590c:	6a 7a                	push   $0x7a
  jmp alltraps
8010590e:	e9 35 f7 ff ff       	jmp    80105048 <alltraps>

80105913 <vector123>:
.globl vector123
vector123:
  pushl $0
80105913:	6a 00                	push   $0x0
  pushl $123
80105915:	6a 7b                	push   $0x7b
  jmp alltraps
80105917:	e9 2c f7 ff ff       	jmp    80105048 <alltraps>

8010591c <vector124>:
.globl vector124
vector124:
  pushl $0
8010591c:	6a 00                	push   $0x0
  pushl $124
8010591e:	6a 7c                	push   $0x7c
  jmp alltraps
80105920:	e9 23 f7 ff ff       	jmp    80105048 <alltraps>

80105925 <vector125>:
.globl vector125
vector125:
  pushl $0
80105925:	6a 00                	push   $0x0
  pushl $125
80105927:	6a 7d                	push   $0x7d
  jmp alltraps
80105929:	e9 1a f7 ff ff       	jmp    80105048 <alltraps>

8010592e <vector126>:
.globl vector126
vector126:
  pushl $0
8010592e:	6a 00                	push   $0x0
  pushl $126
80105930:	6a 7e                	push   $0x7e
  jmp alltraps
80105932:	e9 11 f7 ff ff       	jmp    80105048 <alltraps>

80105937 <vector127>:
.globl vector127
vector127:
  pushl $0
80105937:	6a 00                	push   $0x0
  pushl $127
80105939:	6a 7f                	push   $0x7f
  jmp alltraps
8010593b:	e9 08 f7 ff ff       	jmp    80105048 <alltraps>

80105940 <vector128>:
.globl vector128
vector128:
  pushl $0
80105940:	6a 00                	push   $0x0
  pushl $128
80105942:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105947:	e9 fc f6 ff ff       	jmp    80105048 <alltraps>

8010594c <vector129>:
.globl vector129
vector129:
  pushl $0
8010594c:	6a 00                	push   $0x0
  pushl $129
8010594e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105953:	e9 f0 f6 ff ff       	jmp    80105048 <alltraps>

80105958 <vector130>:
.globl vector130
vector130:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $130
8010595a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010595f:	e9 e4 f6 ff ff       	jmp    80105048 <alltraps>

80105964 <vector131>:
.globl vector131
vector131:
  pushl $0
80105964:	6a 00                	push   $0x0
  pushl $131
80105966:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010596b:	e9 d8 f6 ff ff       	jmp    80105048 <alltraps>

80105970 <vector132>:
.globl vector132
vector132:
  pushl $0
80105970:	6a 00                	push   $0x0
  pushl $132
80105972:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105977:	e9 cc f6 ff ff       	jmp    80105048 <alltraps>

8010597c <vector133>:
.globl vector133
vector133:
  pushl $0
8010597c:	6a 00                	push   $0x0
  pushl $133
8010597e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105983:	e9 c0 f6 ff ff       	jmp    80105048 <alltraps>

80105988 <vector134>:
.globl vector134
vector134:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $134
8010598a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010598f:	e9 b4 f6 ff ff       	jmp    80105048 <alltraps>

80105994 <vector135>:
.globl vector135
vector135:
  pushl $0
80105994:	6a 00                	push   $0x0
  pushl $135
80105996:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010599b:	e9 a8 f6 ff ff       	jmp    80105048 <alltraps>

801059a0 <vector136>:
.globl vector136
vector136:
  pushl $0
801059a0:	6a 00                	push   $0x0
  pushl $136
801059a2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801059a7:	e9 9c f6 ff ff       	jmp    80105048 <alltraps>

801059ac <vector137>:
.globl vector137
vector137:
  pushl $0
801059ac:	6a 00                	push   $0x0
  pushl $137
801059ae:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801059b3:	e9 90 f6 ff ff       	jmp    80105048 <alltraps>

801059b8 <vector138>:
.globl vector138
vector138:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $138
801059ba:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801059bf:	e9 84 f6 ff ff       	jmp    80105048 <alltraps>

801059c4 <vector139>:
.globl vector139
vector139:
  pushl $0
801059c4:	6a 00                	push   $0x0
  pushl $139
801059c6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801059cb:	e9 78 f6 ff ff       	jmp    80105048 <alltraps>

801059d0 <vector140>:
.globl vector140
vector140:
  pushl $0
801059d0:	6a 00                	push   $0x0
  pushl $140
801059d2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801059d7:	e9 6c f6 ff ff       	jmp    80105048 <alltraps>

801059dc <vector141>:
.globl vector141
vector141:
  pushl $0
801059dc:	6a 00                	push   $0x0
  pushl $141
801059de:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801059e3:	e9 60 f6 ff ff       	jmp    80105048 <alltraps>

801059e8 <vector142>:
.globl vector142
vector142:
  pushl $0
801059e8:	6a 00                	push   $0x0
  pushl $142
801059ea:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801059ef:	e9 54 f6 ff ff       	jmp    80105048 <alltraps>

801059f4 <vector143>:
.globl vector143
vector143:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $143
801059f6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801059fb:	e9 48 f6 ff ff       	jmp    80105048 <alltraps>

80105a00 <vector144>:
.globl vector144
vector144:
  pushl $0
80105a00:	6a 00                	push   $0x0
  pushl $144
80105a02:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105a07:	e9 3c f6 ff ff       	jmp    80105048 <alltraps>

80105a0c <vector145>:
.globl vector145
vector145:
  pushl $0
80105a0c:	6a 00                	push   $0x0
  pushl $145
80105a0e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105a13:	e9 30 f6 ff ff       	jmp    80105048 <alltraps>

80105a18 <vector146>:
.globl vector146
vector146:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $146
80105a1a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105a1f:	e9 24 f6 ff ff       	jmp    80105048 <alltraps>

80105a24 <vector147>:
.globl vector147
vector147:
  pushl $0
80105a24:	6a 00                	push   $0x0
  pushl $147
80105a26:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105a2b:	e9 18 f6 ff ff       	jmp    80105048 <alltraps>

80105a30 <vector148>:
.globl vector148
vector148:
  pushl $0
80105a30:	6a 00                	push   $0x0
  pushl $148
80105a32:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105a37:	e9 0c f6 ff ff       	jmp    80105048 <alltraps>

80105a3c <vector149>:
.globl vector149
vector149:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $149
80105a3e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105a43:	e9 00 f6 ff ff       	jmp    80105048 <alltraps>

80105a48 <vector150>:
.globl vector150
vector150:
  pushl $0
80105a48:	6a 00                	push   $0x0
  pushl $150
80105a4a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105a4f:	e9 f4 f5 ff ff       	jmp    80105048 <alltraps>

80105a54 <vector151>:
.globl vector151
vector151:
  pushl $0
80105a54:	6a 00                	push   $0x0
  pushl $151
80105a56:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105a5b:	e9 e8 f5 ff ff       	jmp    80105048 <alltraps>

80105a60 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $152
80105a62:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a67:	e9 dc f5 ff ff       	jmp    80105048 <alltraps>

80105a6c <vector153>:
.globl vector153
vector153:
  pushl $0
80105a6c:	6a 00                	push   $0x0
  pushl $153
80105a6e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a73:	e9 d0 f5 ff ff       	jmp    80105048 <alltraps>

80105a78 <vector154>:
.globl vector154
vector154:
  pushl $0
80105a78:	6a 00                	push   $0x0
  pushl $154
80105a7a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a7f:	e9 c4 f5 ff ff       	jmp    80105048 <alltraps>

80105a84 <vector155>:
.globl vector155
vector155:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $155
80105a86:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105a8b:	e9 b8 f5 ff ff       	jmp    80105048 <alltraps>

80105a90 <vector156>:
.globl vector156
vector156:
  pushl $0
80105a90:	6a 00                	push   $0x0
  pushl $156
80105a92:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105a97:	e9 ac f5 ff ff       	jmp    80105048 <alltraps>

80105a9c <vector157>:
.globl vector157
vector157:
  pushl $0
80105a9c:	6a 00                	push   $0x0
  pushl $157
80105a9e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105aa3:	e9 a0 f5 ff ff       	jmp    80105048 <alltraps>

80105aa8 <vector158>:
.globl vector158
vector158:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $158
80105aaa:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105aaf:	e9 94 f5 ff ff       	jmp    80105048 <alltraps>

80105ab4 <vector159>:
.globl vector159
vector159:
  pushl $0
80105ab4:	6a 00                	push   $0x0
  pushl $159
80105ab6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105abb:	e9 88 f5 ff ff       	jmp    80105048 <alltraps>

80105ac0 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ac0:	6a 00                	push   $0x0
  pushl $160
80105ac2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105ac7:	e9 7c f5 ff ff       	jmp    80105048 <alltraps>

80105acc <vector161>:
.globl vector161
vector161:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $161
80105ace:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ad3:	e9 70 f5 ff ff       	jmp    80105048 <alltraps>

80105ad8 <vector162>:
.globl vector162
vector162:
  pushl $0
80105ad8:	6a 00                	push   $0x0
  pushl $162
80105ada:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105adf:	e9 64 f5 ff ff       	jmp    80105048 <alltraps>

80105ae4 <vector163>:
.globl vector163
vector163:
  pushl $0
80105ae4:	6a 00                	push   $0x0
  pushl $163
80105ae6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105aeb:	e9 58 f5 ff ff       	jmp    80105048 <alltraps>

80105af0 <vector164>:
.globl vector164
vector164:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $164
80105af2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105af7:	e9 4c f5 ff ff       	jmp    80105048 <alltraps>

80105afc <vector165>:
.globl vector165
vector165:
  pushl $0
80105afc:	6a 00                	push   $0x0
  pushl $165
80105afe:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105b03:	e9 40 f5 ff ff       	jmp    80105048 <alltraps>

80105b08 <vector166>:
.globl vector166
vector166:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $166
80105b0a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105b0f:	e9 34 f5 ff ff       	jmp    80105048 <alltraps>

80105b14 <vector167>:
.globl vector167
vector167:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $167
80105b16:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105b1b:	e9 28 f5 ff ff       	jmp    80105048 <alltraps>

80105b20 <vector168>:
.globl vector168
vector168:
  pushl $0
80105b20:	6a 00                	push   $0x0
  pushl $168
80105b22:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105b27:	e9 1c f5 ff ff       	jmp    80105048 <alltraps>

80105b2c <vector169>:
.globl vector169
vector169:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $169
80105b2e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105b33:	e9 10 f5 ff ff       	jmp    80105048 <alltraps>

80105b38 <vector170>:
.globl vector170
vector170:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $170
80105b3a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105b3f:	e9 04 f5 ff ff       	jmp    80105048 <alltraps>

80105b44 <vector171>:
.globl vector171
vector171:
  pushl $0
80105b44:	6a 00                	push   $0x0
  pushl $171
80105b46:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105b4b:	e9 f8 f4 ff ff       	jmp    80105048 <alltraps>

80105b50 <vector172>:
.globl vector172
vector172:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $172
80105b52:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105b57:	e9 ec f4 ff ff       	jmp    80105048 <alltraps>

80105b5c <vector173>:
.globl vector173
vector173:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $173
80105b5e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b63:	e9 e0 f4 ff ff       	jmp    80105048 <alltraps>

80105b68 <vector174>:
.globl vector174
vector174:
  pushl $0
80105b68:	6a 00                	push   $0x0
  pushl $174
80105b6a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b6f:	e9 d4 f4 ff ff       	jmp    80105048 <alltraps>

80105b74 <vector175>:
.globl vector175
vector175:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $175
80105b76:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b7b:	e9 c8 f4 ff ff       	jmp    80105048 <alltraps>

80105b80 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $176
80105b82:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b87:	e9 bc f4 ff ff       	jmp    80105048 <alltraps>

80105b8c <vector177>:
.globl vector177
vector177:
  pushl $0
80105b8c:	6a 00                	push   $0x0
  pushl $177
80105b8e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105b93:	e9 b0 f4 ff ff       	jmp    80105048 <alltraps>

80105b98 <vector178>:
.globl vector178
vector178:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $178
80105b9a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105b9f:	e9 a4 f4 ff ff       	jmp    80105048 <alltraps>

80105ba4 <vector179>:
.globl vector179
vector179:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $179
80105ba6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105bab:	e9 98 f4 ff ff       	jmp    80105048 <alltraps>

80105bb0 <vector180>:
.globl vector180
vector180:
  pushl $0
80105bb0:	6a 00                	push   $0x0
  pushl $180
80105bb2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105bb7:	e9 8c f4 ff ff       	jmp    80105048 <alltraps>

80105bbc <vector181>:
.globl vector181
vector181:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $181
80105bbe:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105bc3:	e9 80 f4 ff ff       	jmp    80105048 <alltraps>

80105bc8 <vector182>:
.globl vector182
vector182:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $182
80105bca:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105bcf:	e9 74 f4 ff ff       	jmp    80105048 <alltraps>

80105bd4 <vector183>:
.globl vector183
vector183:
  pushl $0
80105bd4:	6a 00                	push   $0x0
  pushl $183
80105bd6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105bdb:	e9 68 f4 ff ff       	jmp    80105048 <alltraps>

80105be0 <vector184>:
.globl vector184
vector184:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $184
80105be2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105be7:	e9 5c f4 ff ff       	jmp    80105048 <alltraps>

80105bec <vector185>:
.globl vector185
vector185:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $185
80105bee:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105bf3:	e9 50 f4 ff ff       	jmp    80105048 <alltraps>

80105bf8 <vector186>:
.globl vector186
vector186:
  pushl $0
80105bf8:	6a 00                	push   $0x0
  pushl $186
80105bfa:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105bff:	e9 44 f4 ff ff       	jmp    80105048 <alltraps>

80105c04 <vector187>:
.globl vector187
vector187:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $187
80105c06:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105c0b:	e9 38 f4 ff ff       	jmp    80105048 <alltraps>

80105c10 <vector188>:
.globl vector188
vector188:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $188
80105c12:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105c17:	e9 2c f4 ff ff       	jmp    80105048 <alltraps>

80105c1c <vector189>:
.globl vector189
vector189:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $189
80105c1e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105c23:	e9 20 f4 ff ff       	jmp    80105048 <alltraps>

80105c28 <vector190>:
.globl vector190
vector190:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $190
80105c2a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105c2f:	e9 14 f4 ff ff       	jmp    80105048 <alltraps>

80105c34 <vector191>:
.globl vector191
vector191:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $191
80105c36:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105c3b:	e9 08 f4 ff ff       	jmp    80105048 <alltraps>

80105c40 <vector192>:
.globl vector192
vector192:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $192
80105c42:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105c47:	e9 fc f3 ff ff       	jmp    80105048 <alltraps>

80105c4c <vector193>:
.globl vector193
vector193:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $193
80105c4e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105c53:	e9 f0 f3 ff ff       	jmp    80105048 <alltraps>

80105c58 <vector194>:
.globl vector194
vector194:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $194
80105c5a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c5f:	e9 e4 f3 ff ff       	jmp    80105048 <alltraps>

80105c64 <vector195>:
.globl vector195
vector195:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $195
80105c66:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c6b:	e9 d8 f3 ff ff       	jmp    80105048 <alltraps>

80105c70 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $196
80105c72:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c77:	e9 cc f3 ff ff       	jmp    80105048 <alltraps>

80105c7c <vector197>:
.globl vector197
vector197:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $197
80105c7e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c83:	e9 c0 f3 ff ff       	jmp    80105048 <alltraps>

80105c88 <vector198>:
.globl vector198
vector198:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $198
80105c8a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105c8f:	e9 b4 f3 ff ff       	jmp    80105048 <alltraps>

80105c94 <vector199>:
.globl vector199
vector199:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $199
80105c96:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105c9b:	e9 a8 f3 ff ff       	jmp    80105048 <alltraps>

80105ca0 <vector200>:
.globl vector200
vector200:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $200
80105ca2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105ca7:	e9 9c f3 ff ff       	jmp    80105048 <alltraps>

80105cac <vector201>:
.globl vector201
vector201:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $201
80105cae:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105cb3:	e9 90 f3 ff ff       	jmp    80105048 <alltraps>

80105cb8 <vector202>:
.globl vector202
vector202:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $202
80105cba:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105cbf:	e9 84 f3 ff ff       	jmp    80105048 <alltraps>

80105cc4 <vector203>:
.globl vector203
vector203:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $203
80105cc6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105ccb:	e9 78 f3 ff ff       	jmp    80105048 <alltraps>

80105cd0 <vector204>:
.globl vector204
vector204:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $204
80105cd2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105cd7:	e9 6c f3 ff ff       	jmp    80105048 <alltraps>

80105cdc <vector205>:
.globl vector205
vector205:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $205
80105cde:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105ce3:	e9 60 f3 ff ff       	jmp    80105048 <alltraps>

80105ce8 <vector206>:
.globl vector206
vector206:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $206
80105cea:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105cef:	e9 54 f3 ff ff       	jmp    80105048 <alltraps>

80105cf4 <vector207>:
.globl vector207
vector207:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $207
80105cf6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105cfb:	e9 48 f3 ff ff       	jmp    80105048 <alltraps>

80105d00 <vector208>:
.globl vector208
vector208:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $208
80105d02:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105d07:	e9 3c f3 ff ff       	jmp    80105048 <alltraps>

80105d0c <vector209>:
.globl vector209
vector209:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $209
80105d0e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105d13:	e9 30 f3 ff ff       	jmp    80105048 <alltraps>

80105d18 <vector210>:
.globl vector210
vector210:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $210
80105d1a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105d1f:	e9 24 f3 ff ff       	jmp    80105048 <alltraps>

80105d24 <vector211>:
.globl vector211
vector211:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $211
80105d26:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105d2b:	e9 18 f3 ff ff       	jmp    80105048 <alltraps>

80105d30 <vector212>:
.globl vector212
vector212:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $212
80105d32:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105d37:	e9 0c f3 ff ff       	jmp    80105048 <alltraps>

80105d3c <vector213>:
.globl vector213
vector213:
  pushl $0
80105d3c:	6a 00                	push   $0x0
  pushl $213
80105d3e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105d43:	e9 00 f3 ff ff       	jmp    80105048 <alltraps>

80105d48 <vector214>:
.globl vector214
vector214:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $214
80105d4a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105d4f:	e9 f4 f2 ff ff       	jmp    80105048 <alltraps>

80105d54 <vector215>:
.globl vector215
vector215:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $215
80105d56:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105d5b:	e9 e8 f2 ff ff       	jmp    80105048 <alltraps>

80105d60 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $216
80105d62:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d67:	e9 dc f2 ff ff       	jmp    80105048 <alltraps>

80105d6c <vector217>:
.globl vector217
vector217:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $217
80105d6e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d73:	e9 d0 f2 ff ff       	jmp    80105048 <alltraps>

80105d78 <vector218>:
.globl vector218
vector218:
  pushl $0
80105d78:	6a 00                	push   $0x0
  pushl $218
80105d7a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d7f:	e9 c4 f2 ff ff       	jmp    80105048 <alltraps>

80105d84 <vector219>:
.globl vector219
vector219:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $219
80105d86:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105d8b:	e9 b8 f2 ff ff       	jmp    80105048 <alltraps>

80105d90 <vector220>:
.globl vector220
vector220:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $220
80105d92:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105d97:	e9 ac f2 ff ff       	jmp    80105048 <alltraps>

80105d9c <vector221>:
.globl vector221
vector221:
  pushl $0
80105d9c:	6a 00                	push   $0x0
  pushl $221
80105d9e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105da3:	e9 a0 f2 ff ff       	jmp    80105048 <alltraps>

80105da8 <vector222>:
.globl vector222
vector222:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $222
80105daa:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105daf:	e9 94 f2 ff ff       	jmp    80105048 <alltraps>

80105db4 <vector223>:
.globl vector223
vector223:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $223
80105db6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105dbb:	e9 88 f2 ff ff       	jmp    80105048 <alltraps>

80105dc0 <vector224>:
.globl vector224
vector224:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $224
80105dc2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105dc7:	e9 7c f2 ff ff       	jmp    80105048 <alltraps>

80105dcc <vector225>:
.globl vector225
vector225:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $225
80105dce:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105dd3:	e9 70 f2 ff ff       	jmp    80105048 <alltraps>

80105dd8 <vector226>:
.globl vector226
vector226:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $226
80105dda:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105ddf:	e9 64 f2 ff ff       	jmp    80105048 <alltraps>

80105de4 <vector227>:
.globl vector227
vector227:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $227
80105de6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105deb:	e9 58 f2 ff ff       	jmp    80105048 <alltraps>

80105df0 <vector228>:
.globl vector228
vector228:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $228
80105df2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105df7:	e9 4c f2 ff ff       	jmp    80105048 <alltraps>

80105dfc <vector229>:
.globl vector229
vector229:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $229
80105dfe:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105e03:	e9 40 f2 ff ff       	jmp    80105048 <alltraps>

80105e08 <vector230>:
.globl vector230
vector230:
  pushl $0
80105e08:	6a 00                	push   $0x0
  pushl $230
80105e0a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105e0f:	e9 34 f2 ff ff       	jmp    80105048 <alltraps>

80105e14 <vector231>:
.globl vector231
vector231:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $231
80105e16:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105e1b:	e9 28 f2 ff ff       	jmp    80105048 <alltraps>

80105e20 <vector232>:
.globl vector232
vector232:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $232
80105e22:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105e27:	e9 1c f2 ff ff       	jmp    80105048 <alltraps>

80105e2c <vector233>:
.globl vector233
vector233:
  pushl $0
80105e2c:	6a 00                	push   $0x0
  pushl $233
80105e2e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105e33:	e9 10 f2 ff ff       	jmp    80105048 <alltraps>

80105e38 <vector234>:
.globl vector234
vector234:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $234
80105e3a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105e3f:	e9 04 f2 ff ff       	jmp    80105048 <alltraps>

80105e44 <vector235>:
.globl vector235
vector235:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $235
80105e46:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105e4b:	e9 f8 f1 ff ff       	jmp    80105048 <alltraps>

80105e50 <vector236>:
.globl vector236
vector236:
  pushl $0
80105e50:	6a 00                	push   $0x0
  pushl $236
80105e52:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105e57:	e9 ec f1 ff ff       	jmp    80105048 <alltraps>

80105e5c <vector237>:
.globl vector237
vector237:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $237
80105e5e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e63:	e9 e0 f1 ff ff       	jmp    80105048 <alltraps>

80105e68 <vector238>:
.globl vector238
vector238:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $238
80105e6a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e6f:	e9 d4 f1 ff ff       	jmp    80105048 <alltraps>

80105e74 <vector239>:
.globl vector239
vector239:
  pushl $0
80105e74:	6a 00                	push   $0x0
  pushl $239
80105e76:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e7b:	e9 c8 f1 ff ff       	jmp    80105048 <alltraps>

80105e80 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $240
80105e82:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e87:	e9 bc f1 ff ff       	jmp    80105048 <alltraps>

80105e8c <vector241>:
.globl vector241
vector241:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $241
80105e8e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105e93:	e9 b0 f1 ff ff       	jmp    80105048 <alltraps>

80105e98 <vector242>:
.globl vector242
vector242:
  pushl $0
80105e98:	6a 00                	push   $0x0
  pushl $242
80105e9a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105e9f:	e9 a4 f1 ff ff       	jmp    80105048 <alltraps>

80105ea4 <vector243>:
.globl vector243
vector243:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $243
80105ea6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105eab:	e9 98 f1 ff ff       	jmp    80105048 <alltraps>

80105eb0 <vector244>:
.globl vector244
vector244:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $244
80105eb2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105eb7:	e9 8c f1 ff ff       	jmp    80105048 <alltraps>

80105ebc <vector245>:
.globl vector245
vector245:
  pushl $0
80105ebc:	6a 00                	push   $0x0
  pushl $245
80105ebe:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105ec3:	e9 80 f1 ff ff       	jmp    80105048 <alltraps>

80105ec8 <vector246>:
.globl vector246
vector246:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $246
80105eca:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105ecf:	e9 74 f1 ff ff       	jmp    80105048 <alltraps>

80105ed4 <vector247>:
.globl vector247
vector247:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $247
80105ed6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105edb:	e9 68 f1 ff ff       	jmp    80105048 <alltraps>

80105ee0 <vector248>:
.globl vector248
vector248:
  pushl $0
80105ee0:	6a 00                	push   $0x0
  pushl $248
80105ee2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105ee7:	e9 5c f1 ff ff       	jmp    80105048 <alltraps>

80105eec <vector249>:
.globl vector249
vector249:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $249
80105eee:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105ef3:	e9 50 f1 ff ff       	jmp    80105048 <alltraps>

80105ef8 <vector250>:
.globl vector250
vector250:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $250
80105efa:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105eff:	e9 44 f1 ff ff       	jmp    80105048 <alltraps>

80105f04 <vector251>:
.globl vector251
vector251:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $251
80105f06:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105f0b:	e9 38 f1 ff ff       	jmp    80105048 <alltraps>

80105f10 <vector252>:
.globl vector252
vector252:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $252
80105f12:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105f17:	e9 2c f1 ff ff       	jmp    80105048 <alltraps>

80105f1c <vector253>:
.globl vector253
vector253:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $253
80105f1e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105f23:	e9 20 f1 ff ff       	jmp    80105048 <alltraps>

80105f28 <vector254>:
.globl vector254
vector254:
  pushl $0
80105f28:	6a 00                	push   $0x0
  pushl $254
80105f2a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105f2f:	e9 14 f1 ff ff       	jmp    80105048 <alltraps>

80105f34 <vector255>:
.globl vector255
vector255:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $255
80105f36:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105f3b:	e9 08 f1 ff ff       	jmp    80105048 <alltraps>

80105f40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
80105f46:	83 ec 0c             	sub    $0xc,%esp
80105f49:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105f4b:	c1 ea 16             	shr    $0x16,%edx
80105f4e:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105f51:	8b 37                	mov    (%edi),%esi
80105f53:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105f59:	74 20                	je     80105f7b <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105f5b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105f61:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105f67:	c1 eb 0c             	shr    $0xc,%ebx
80105f6a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105f70:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f76:	5b                   	pop    %ebx
80105f77:	5e                   	pop    %esi
80105f78:	5f                   	pop    %edi
80105f79:	5d                   	pop    %ebp
80105f7a:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105f7b:	85 c9                	test   %ecx,%ecx
80105f7d:	74 2b                	je     80105faa <walkpgdir+0x6a>
80105f7f:	e8 1f c1 ff ff       	call   801020a3 <kalloc>
80105f84:	89 c6                	mov    %eax,%esi
80105f86:	85 c0                	test   %eax,%eax
80105f88:	74 20                	je     80105faa <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105f8a:	83 ec 04             	sub    $0x4,%esp
80105f8d:	68 00 10 00 00       	push   $0x1000
80105f92:	6a 00                	push   $0x0
80105f94:	50                   	push   %eax
80105f95:	e8 d1 de ff ff       	call   80103e6b <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105f9a:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105fa0:	83 c8 07             	or     $0x7,%eax
80105fa3:	89 07                	mov    %eax,(%edi)
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	eb bd                	jmp    80105f67 <walkpgdir+0x27>
      return 0;
80105faa:	b8 00 00 00 00       	mov    $0x0,%eax
80105faf:	eb c2                	jmp    80105f73 <walkpgdir+0x33>

80105fb1 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105fb1:	55                   	push   %ebp
80105fb2:	89 e5                	mov    %esp,%ebp
80105fb4:	57                   	push   %edi
80105fb5:	56                   	push   %esi
80105fb6:	53                   	push   %ebx
80105fb7:	83 ec 1c             	sub    $0x1c,%esp
80105fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105fbd:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105fc0:	89 d3                	mov    %edx,%ebx
80105fc2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105fc8:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105fcc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105fd2:	b9 01 00 00 00       	mov    $0x1,%ecx
80105fd7:	89 da                	mov    %ebx,%edx
80105fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fdc:	e8 5f ff ff ff       	call   80105f40 <walkpgdir>
80105fe1:	85 c0                	test   %eax,%eax
80105fe3:	74 2e                	je     80106013 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105fe5:	f6 00 01             	testb  $0x1,(%eax)
80105fe8:	75 1c                	jne    80106006 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105fea:	89 f2                	mov    %esi,%edx
80105fec:	0b 55 0c             	or     0xc(%ebp),%edx
80105fef:	83 ca 01             	or     $0x1,%edx
80105ff2:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105ff4:	39 fb                	cmp    %edi,%ebx
80105ff6:	74 28                	je     80106020 <mappages+0x6f>
      break;
    a += PGSIZE;
80105ff8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105ffe:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106004:	eb cc                	jmp    80105fd2 <mappages+0x21>
      panic("remap");
80106006:	83 ec 0c             	sub    $0xc,%esp
80106009:	68 68 73 10 80       	push   $0x80107368
8010600e:	e8 35 a3 ff ff       	call   80100348 <panic>
      return -1;
80106013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010601b:	5b                   	pop    %ebx
8010601c:	5e                   	pop    %esi
8010601d:	5f                   	pop    %edi
8010601e:	5d                   	pop    %ebp
8010601f:	c3                   	ret    
  return 0;
80106020:	b8 00 00 00 00       	mov    $0x0,%eax
80106025:	eb f1                	jmp    80106018 <mappages+0x67>

80106027 <seginit>:
{
80106027:	55                   	push   %ebp
80106028:	89 e5                	mov    %esp,%ebp
8010602a:	57                   	push   %edi
8010602b:	56                   	push   %esi
8010602c:	53                   	push   %ebx
8010602d:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80106030:	e8 65 d1 ff ff       	call   8010319a <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106035:	69 f8 b0 00 00 00    	imul   $0xb0,%eax,%edi
8010603b:	66 c7 87 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%edi)
80106042:	ff ff 
80106044:	66 c7 87 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%edi)
8010604b:	00 00 
8010604d:	c6 87 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%edi)
80106054:	0f b6 8f 1d 18 11 80 	movzbl -0x7feee7e3(%edi),%ecx
8010605b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010605e:	89 ce                	mov    %ecx,%esi
80106060:	83 ce 0a             	or     $0xa,%esi
80106063:	89 f2                	mov    %esi,%edx
80106065:	88 97 1d 18 11 80    	mov    %dl,-0x7feee7e3(%edi)
8010606b:	83 c9 1a             	or     $0x1a,%ecx
8010606e:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
80106074:	83 e1 9f             	and    $0xffffff9f,%ecx
80106077:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
8010607d:	83 c9 80             	or     $0xffffff80,%ecx
80106080:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
80106086:	0f b6 8f 1e 18 11 80 	movzbl -0x7feee7e2(%edi),%ecx
8010608d:	83 c9 0f             	or     $0xf,%ecx
80106090:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
80106096:	89 ce                	mov    %ecx,%esi
80106098:	83 e6 ef             	and    $0xffffffef,%esi
8010609b:	89 f2                	mov    %esi,%edx
8010609d:	88 97 1e 18 11 80    	mov    %dl,-0x7feee7e2(%edi)
801060a3:	83 e1 cf             	and    $0xffffffcf,%ecx
801060a6:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
801060ac:	89 ce                	mov    %ecx,%esi
801060ae:	83 ce 40             	or     $0x40,%esi
801060b1:	89 f2                	mov    %esi,%edx
801060b3:	88 97 1e 18 11 80    	mov    %dl,-0x7feee7e2(%edi)
801060b9:	83 c9 c0             	or     $0xffffffc0,%ecx
801060bc:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
801060c2:	c6 87 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%edi)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801060c9:	66 c7 87 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%edi)
801060d0:	ff ff 
801060d2:	66 c7 87 22 18 11 80 	movw   $0x0,-0x7feee7de(%edi)
801060d9:	00 00 
801060db:	c6 87 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%edi)
801060e2:	0f b6 8f 25 18 11 80 	movzbl -0x7feee7db(%edi),%ecx
801060e9:	83 e1 f0             	and    $0xfffffff0,%ecx
801060ec:	89 ce                	mov    %ecx,%esi
801060ee:	83 ce 02             	or     $0x2,%esi
801060f1:	89 f2                	mov    %esi,%edx
801060f3:	88 97 25 18 11 80    	mov    %dl,-0x7feee7db(%edi)
801060f9:	83 c9 12             	or     $0x12,%ecx
801060fc:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
80106102:	83 e1 9f             	and    $0xffffff9f,%ecx
80106105:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
8010610b:	83 c9 80             	or     $0xffffff80,%ecx
8010610e:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
80106114:	0f b6 8f 26 18 11 80 	movzbl -0x7feee7da(%edi),%ecx
8010611b:	83 c9 0f             	or     $0xf,%ecx
8010611e:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
80106124:	89 ce                	mov    %ecx,%esi
80106126:	83 e6 ef             	and    $0xffffffef,%esi
80106129:	89 f2                	mov    %esi,%edx
8010612b:	88 97 26 18 11 80    	mov    %dl,-0x7feee7da(%edi)
80106131:	83 e1 cf             	and    $0xffffffcf,%ecx
80106134:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
8010613a:	89 ce                	mov    %ecx,%esi
8010613c:	83 ce 40             	or     $0x40,%esi
8010613f:	89 f2                	mov    %esi,%edx
80106141:	88 97 26 18 11 80    	mov    %dl,-0x7feee7da(%edi)
80106147:	83 c9 c0             	or     $0xffffffc0,%ecx
8010614a:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
80106150:	c6 87 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%edi)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106157:	66 c7 87 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%edi)
8010615e:	ff ff 
80106160:	66 c7 87 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%edi)
80106167:	00 00 
80106169:	c6 87 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%edi)
80106170:	0f b6 9f 2d 18 11 80 	movzbl -0x7feee7d3(%edi),%ebx
80106177:	83 e3 f0             	and    $0xfffffff0,%ebx
8010617a:	89 de                	mov    %ebx,%esi
8010617c:	83 ce 0a             	or     $0xa,%esi
8010617f:	89 f2                	mov    %esi,%edx
80106181:	88 97 2d 18 11 80    	mov    %dl,-0x7feee7d3(%edi)
80106187:	89 de                	mov    %ebx,%esi
80106189:	83 ce 1a             	or     $0x1a,%esi
8010618c:	89 f2                	mov    %esi,%edx
8010618e:	88 97 2d 18 11 80    	mov    %dl,-0x7feee7d3(%edi)
80106194:	83 cb 7a             	or     $0x7a,%ebx
80106197:	88 9f 2d 18 11 80    	mov    %bl,-0x7feee7d3(%edi)
8010619d:	c6 87 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%edi)
801061a4:	0f b6 9f 2e 18 11 80 	movzbl -0x7feee7d2(%edi),%ebx
801061ab:	83 cb 0f             	or     $0xf,%ebx
801061ae:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
801061b4:	89 de                	mov    %ebx,%esi
801061b6:	83 e6 ef             	and    $0xffffffef,%esi
801061b9:	89 f2                	mov    %esi,%edx
801061bb:	88 97 2e 18 11 80    	mov    %dl,-0x7feee7d2(%edi)
801061c1:	83 e3 cf             	and    $0xffffffcf,%ebx
801061c4:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
801061ca:	89 de                	mov    %ebx,%esi
801061cc:	83 ce 40             	or     $0x40,%esi
801061cf:	89 f2                	mov    %esi,%edx
801061d1:	88 97 2e 18 11 80    	mov    %dl,-0x7feee7d2(%edi)
801061d7:	83 cb c0             	or     $0xffffffc0,%ebx
801061da:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
801061e0:	c6 87 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%edi)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801061e7:	66 c7 87 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%edi)
801061ee:	ff ff 
801061f0:	66 c7 87 32 18 11 80 	movw   $0x0,-0x7feee7ce(%edi)
801061f7:	00 00 
801061f9:	c6 87 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%edi)
80106200:	0f b6 9f 35 18 11 80 	movzbl -0x7feee7cb(%edi),%ebx
80106207:	83 e3 f0             	and    $0xfffffff0,%ebx
8010620a:	89 de                	mov    %ebx,%esi
8010620c:	83 ce 02             	or     $0x2,%esi
8010620f:	89 f2                	mov    %esi,%edx
80106211:	88 97 35 18 11 80    	mov    %dl,-0x7feee7cb(%edi)
80106217:	89 de                	mov    %ebx,%esi
80106219:	83 ce 12             	or     $0x12,%esi
8010621c:	89 f2                	mov    %esi,%edx
8010621e:	88 97 35 18 11 80    	mov    %dl,-0x7feee7cb(%edi)
80106224:	83 cb 72             	or     $0x72,%ebx
80106227:	88 9f 35 18 11 80    	mov    %bl,-0x7feee7cb(%edi)
8010622d:	c6 87 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%edi)
80106234:	0f b6 9f 36 18 11 80 	movzbl -0x7feee7ca(%edi),%ebx
8010623b:	83 cb 0f             	or     $0xf,%ebx
8010623e:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
80106244:	89 de                	mov    %ebx,%esi
80106246:	83 e6 ef             	and    $0xffffffef,%esi
80106249:	89 f2                	mov    %esi,%edx
8010624b:	88 97 36 18 11 80    	mov    %dl,-0x7feee7ca(%edi)
80106251:	83 e3 cf             	and    $0xffffffcf,%ebx
80106254:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
8010625a:	89 de                	mov    %ebx,%esi
8010625c:	83 ce 40             	or     $0x40,%esi
8010625f:	89 f2                	mov    %esi,%edx
80106261:	88 97 36 18 11 80    	mov    %dl,-0x7feee7ca(%edi)
80106267:	83 cb c0             	or     $0xffffffc0,%ebx
8010626a:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
80106270:	c6 87 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%edi)
  lgdt(c->gdt, sizeof(c->gdt));
80106277:	8d 97 10 18 11 80    	lea    -0x7feee7f0(%edi),%edx
  pd[0] = size-1;
8010627d:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106283:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80106287:	c1 ea 10             	shr    $0x10,%edx
8010628a:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010628e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106291:	0f 01 10             	lgdtl  (%eax)
}
80106294:	83 c4 1c             	add    $0x1c,%esp
80106297:	5b                   	pop    %ebx
80106298:	5e                   	pop    %esi
80106299:	5f                   	pop    %edi
8010629a:	5d                   	pop    %ebp
8010629b:	c3                   	ret    

8010629c <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010629c:	a1 e4 45 11 80       	mov    0x801145e4,%eax
801062a1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801062a6:	0f 22 d8             	mov    %eax,%cr3
}
801062a9:	c3                   	ret    

801062aa <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801062aa:	55                   	push   %ebp
801062ab:	89 e5                	mov    %esp,%ebp
801062ad:	57                   	push   %edi
801062ae:	56                   	push   %esi
801062af:	53                   	push   %ebx
801062b0:	83 ec 1c             	sub    $0x1c,%esp
801062b3:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801062b6:	85 f6                	test   %esi,%esi
801062b8:	0f 84 25 01 00 00    	je     801063e3 <switchuvm+0x139>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801062be:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801062c2:	0f 84 28 01 00 00    	je     801063f0 <switchuvm+0x146>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801062c8:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801062cc:	0f 84 2b 01 00 00    	je     801063fd <switchuvm+0x153>
    panic("switchuvm: no pgdir");

  pushcli();
801062d2:	e8 0d da ff ff       	call   80103ce4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801062d7:	e8 62 ce ff ff       	call   8010313e <mycpu>
801062dc:	89 c3                	mov    %eax,%ebx
801062de:	e8 5b ce ff ff       	call   8010313e <mycpu>
801062e3:	8d 78 08             	lea    0x8(%eax),%edi
801062e6:	e8 53 ce ff ff       	call   8010313e <mycpu>
801062eb:	83 c0 08             	add    $0x8,%eax
801062ee:	c1 e8 10             	shr    $0x10,%eax
801062f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062f4:	e8 45 ce ff ff       	call   8010313e <mycpu>
801062f9:	83 c0 08             	add    $0x8,%eax
801062fc:	c1 e8 18             	shr    $0x18,%eax
801062ff:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106306:	67 00 
80106308:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010630f:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80106313:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106319:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80106320:	83 e2 f0             	and    $0xfffffff0,%edx
80106323:	89 d1                	mov    %edx,%ecx
80106325:	83 c9 09             	or     $0x9,%ecx
80106328:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
8010632e:	83 ca 19             	or     $0x19,%edx
80106331:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106337:	83 e2 9f             	and    $0xffffff9f,%edx
8010633a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106340:	83 ca 80             	or     $0xffffff80,%edx
80106343:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106349:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80106350:	89 d1                	mov    %edx,%ecx
80106352:	83 e1 f0             	and    $0xfffffff0,%ecx
80106355:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010635b:	89 d1                	mov    %edx,%ecx
8010635d:	83 e1 e0             	and    $0xffffffe0,%ecx
80106360:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106366:	83 e2 c0             	and    $0xffffffc0,%edx
80106369:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010636f:	83 ca 40             	or     $0x40,%edx
80106372:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106378:	83 e2 7f             	and    $0x7f,%edx
8010637b:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106381:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106387:	e8 b2 cd ff ff       	call   8010313e <mycpu>
8010638c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80106393:	83 e2 ef             	and    $0xffffffef,%edx
80106396:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010639c:	e8 9d cd ff ff       	call   8010313e <mycpu>
801063a1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801063a7:	8b 5e 08             	mov    0x8(%esi),%ebx
801063aa:	e8 8f cd ff ff       	call   8010313e <mycpu>
801063af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063b5:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801063b8:	e8 81 cd ff ff       	call   8010313e <mycpu>
801063bd:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801063c3:	b8 28 00 00 00       	mov    $0x28,%eax
801063c8:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801063cb:	8b 46 04             	mov    0x4(%esi),%eax
801063ce:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801063d3:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801063d6:	e8 45 d9 ff ff       	call   80103d20 <popcli>
}
801063db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063de:	5b                   	pop    %ebx
801063df:	5e                   	pop    %esi
801063e0:	5f                   	pop    %edi
801063e1:	5d                   	pop    %ebp
801063e2:	c3                   	ret    
    panic("switchuvm: no process");
801063e3:	83 ec 0c             	sub    $0xc,%esp
801063e6:	68 6e 73 10 80       	push   $0x8010736e
801063eb:	e8 58 9f ff ff       	call   80100348 <panic>
    panic("switchuvm: no kstack");
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 84 73 10 80       	push   $0x80107384
801063f8:	e8 4b 9f ff ff       	call   80100348 <panic>
    panic("switchuvm: no pgdir");
801063fd:	83 ec 0c             	sub    $0xc,%esp
80106400:	68 99 73 10 80       	push   $0x80107399
80106405:	e8 3e 9f ff ff       	call   80100348 <panic>

8010640a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010640a:	55                   	push   %ebp
8010640b:	89 e5                	mov    %esp,%ebp
8010640d:	56                   	push   %esi
8010640e:	53                   	push   %ebx
8010640f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106412:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106418:	77 4c                	ja     80106466 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
8010641a:	e8 84 bc ff ff       	call   801020a3 <kalloc>
8010641f:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106421:	83 ec 04             	sub    $0x4,%esp
80106424:	68 00 10 00 00       	push   $0x1000
80106429:	6a 00                	push   $0x0
8010642b:	50                   	push   %eax
8010642c:	e8 3a da ff ff       	call   80103e6b <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106431:	83 c4 08             	add    $0x8,%esp
80106434:	6a 06                	push   $0x6
80106436:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010643c:	50                   	push   %eax
8010643d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106442:	ba 00 00 00 00       	mov    $0x0,%edx
80106447:	8b 45 08             	mov    0x8(%ebp),%eax
8010644a:	e8 62 fb ff ff       	call   80105fb1 <mappages>
  memmove(mem, init, sz);
8010644f:	83 c4 0c             	add    $0xc,%esp
80106452:	56                   	push   %esi
80106453:	ff 75 0c             	push   0xc(%ebp)
80106456:	53                   	push   %ebx
80106457:	e8 87 da ff ff       	call   80103ee3 <memmove>
}
8010645c:	83 c4 10             	add    $0x10,%esp
8010645f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106462:	5b                   	pop    %ebx
80106463:	5e                   	pop    %esi
80106464:	5d                   	pop    %ebp
80106465:	c3                   	ret    
    panic("inituvm: more than a page");
80106466:	83 ec 0c             	sub    $0xc,%esp
80106469:	68 ad 73 10 80       	push   $0x801073ad
8010646e:	e8 d5 9e ff ff       	call   80100348 <panic>

80106473 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106473:	55                   	push   %ebp
80106474:	89 e5                	mov    %esp,%ebp
80106476:	57                   	push   %edi
80106477:	56                   	push   %esi
80106478:	53                   	push   %ebx
80106479:	83 ec 0c             	sub    $0xc,%esp
8010647c:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010647f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106482:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106488:	74 3c                	je     801064c6 <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
8010648a:	83 ec 0c             	sub    $0xc,%esp
8010648d:	68 68 74 10 80       	push   $0x80107468
80106492:	e8 b1 9e ff ff       	call   80100348 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106497:	83 ec 0c             	sub    $0xc,%esp
8010649a:	68 c7 73 10 80       	push   $0x801073c7
8010649f:	e8 a4 9e ff ff       	call   80100348 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801064a4:	05 00 00 00 80       	add    $0x80000000,%eax
801064a9:	56                   	push   %esi
801064aa:	89 da                	mov    %ebx,%edx
801064ac:	03 55 14             	add    0x14(%ebp),%edx
801064af:	52                   	push   %edx
801064b0:	50                   	push   %eax
801064b1:	ff 75 10             	push   0x10(%ebp)
801064b4:	e8 a8 b2 ff ff       	call   80101761 <readi>
801064b9:	83 c4 10             	add    $0x10,%esp
801064bc:	39 f0                	cmp    %esi,%eax
801064be:	75 47                	jne    80106507 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
801064c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064c6:	39 fb                	cmp    %edi,%ebx
801064c8:	73 30                	jae    801064fa <loaduvm+0x87>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801064ca:	89 da                	mov    %ebx,%edx
801064cc:	03 55 0c             	add    0xc(%ebp),%edx
801064cf:	b9 00 00 00 00       	mov    $0x0,%ecx
801064d4:	8b 45 08             	mov    0x8(%ebp),%eax
801064d7:	e8 64 fa ff ff       	call   80105f40 <walkpgdir>
801064dc:	85 c0                	test   %eax,%eax
801064de:	74 b7                	je     80106497 <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
801064e0:	8b 00                	mov    (%eax),%eax
801064e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801064e7:	89 fe                	mov    %edi,%esi
801064e9:	29 de                	sub    %ebx,%esi
801064eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801064f1:	76 b1                	jbe    801064a4 <loaduvm+0x31>
      n = PGSIZE;
801064f3:	be 00 10 00 00       	mov    $0x1000,%esi
801064f8:	eb aa                	jmp    801064a4 <loaduvm+0x31>
      return -1;
  }
  return 0;
801064fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106502:	5b                   	pop    %ebx
80106503:	5e                   	pop    %esi
80106504:	5f                   	pop    %edi
80106505:	5d                   	pop    %ebp
80106506:	c3                   	ret    
      return -1;
80106507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650c:	eb f1                	jmp    801064ff <loaduvm+0x8c>

8010650e <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010650e:	55                   	push   %ebp
8010650f:	89 e5                	mov    %esp,%ebp
80106511:	57                   	push   %edi
80106512:	56                   	push   %esi
80106513:	53                   	push   %ebx
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010651a:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010651d:	73 11                	jae    80106530 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
8010651f:	8b 45 10             	mov    0x10(%ebp),%eax
80106522:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106528:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010652e:	eb 19                	jmp    80106549 <deallocuvm+0x3b>
    return oldsz;
80106530:	89 f8                	mov    %edi,%eax
80106532:	eb 64                	jmp    80106598 <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106534:	c1 eb 16             	shr    $0x16,%ebx
80106537:	83 c3 01             	add    $0x1,%ebx
8010653a:	c1 e3 16             	shl    $0x16,%ebx
8010653d:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106543:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106549:	39 fb                	cmp    %edi,%ebx
8010654b:	73 48                	jae    80106595 <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010654d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106552:	89 da                	mov    %ebx,%edx
80106554:	8b 45 08             	mov    0x8(%ebp),%eax
80106557:	e8 e4 f9 ff ff       	call   80105f40 <walkpgdir>
8010655c:	89 c6                	mov    %eax,%esi
    if(!pte)
8010655e:	85 c0                	test   %eax,%eax
80106560:	74 d2                	je     80106534 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
80106562:	8b 00                	mov    (%eax),%eax
80106564:	a8 01                	test   $0x1,%al
80106566:	74 db                	je     80106543 <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106568:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010656d:	74 19                	je     80106588 <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
8010656f:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106574:	83 ec 0c             	sub    $0xc,%esp
80106577:	50                   	push   %eax
80106578:	e8 0f ba ff ff       	call   80101f8c <kfree>
      *pte = 0;
8010657d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106583:	83 c4 10             	add    $0x10,%esp
80106586:	eb bb                	jmp    80106543 <deallocuvm+0x35>
        panic("kfree");
80106588:	83 ec 0c             	sub    $0xc,%esp
8010658b:	68 26 6c 10 80       	push   $0x80106c26
80106590:	e8 b3 9d ff ff       	call   80100348 <panic>
    }
  }
  return newsz;
80106595:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010659b:	5b                   	pop    %ebx
8010659c:	5e                   	pop    %esi
8010659d:	5f                   	pop    %edi
8010659e:	5d                   	pop    %ebp
8010659f:	c3                   	ret    

801065a0 <allocuvm>:
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
801065a6:	83 ec 1c             	sub    $0x1c,%esp
801065a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801065ac:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801065af:	85 ff                	test   %edi,%edi
801065b1:	0f 88 c1 00 00 00    	js     80106678 <allocuvm+0xd8>
  if(newsz < oldsz)
801065b7:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801065ba:	72 5c                	jb     80106618 <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
801065bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801065bf:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801065c5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801065cb:	39 fe                	cmp    %edi,%esi
801065cd:	0f 83 ac 00 00 00    	jae    8010667f <allocuvm+0xdf>
    mem = kalloc();
801065d3:	e8 cb ba ff ff       	call   801020a3 <kalloc>
801065d8:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801065da:	85 c0                	test   %eax,%eax
801065dc:	74 42                	je     80106620 <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
801065de:	83 ec 04             	sub    $0x4,%esp
801065e1:	68 00 10 00 00       	push   $0x1000
801065e6:	6a 00                	push   $0x0
801065e8:	50                   	push   %eax
801065e9:	e8 7d d8 ff ff       	call   80103e6b <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801065ee:	83 c4 08             	add    $0x8,%esp
801065f1:	6a 06                	push   $0x6
801065f3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801065f9:	50                   	push   %eax
801065fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801065ff:	89 f2                	mov    %esi,%edx
80106601:	8b 45 08             	mov    0x8(%ebp),%eax
80106604:	e8 a8 f9 ff ff       	call   80105fb1 <mappages>
80106609:	83 c4 10             	add    $0x10,%esp
8010660c:	85 c0                	test   %eax,%eax
8010660e:	78 38                	js     80106648 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106610:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106616:	eb b3                	jmp    801065cb <allocuvm+0x2b>
    return oldsz;
80106618:	8b 45 0c             	mov    0xc(%ebp),%eax
8010661b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010661e:	eb 5f                	jmp    8010667f <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	68 e5 73 10 80       	push   $0x801073e5
80106628:	e8 da 9f ff ff       	call   80100607 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010662d:	83 c4 0c             	add    $0xc,%esp
80106630:	ff 75 0c             	push   0xc(%ebp)
80106633:	57                   	push   %edi
80106634:	ff 75 08             	push   0x8(%ebp)
80106637:	e8 d2 fe ff ff       	call   8010650e <deallocuvm>
      return 0;
8010663c:	83 c4 10             	add    $0x10,%esp
8010663f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106646:	eb 37                	jmp    8010667f <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
80106648:	83 ec 0c             	sub    $0xc,%esp
8010664b:	68 fd 73 10 80       	push   $0x801073fd
80106650:	e8 b2 9f ff ff       	call   80100607 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106655:	83 c4 0c             	add    $0xc,%esp
80106658:	ff 75 0c             	push   0xc(%ebp)
8010665b:	57                   	push   %edi
8010665c:	ff 75 08             	push   0x8(%ebp)
8010665f:	e8 aa fe ff ff       	call   8010650e <deallocuvm>
      kfree(mem);
80106664:	89 1c 24             	mov    %ebx,(%esp)
80106667:	e8 20 b9 ff ff       	call   80101f8c <kfree>
      return 0;
8010666c:	83 c4 10             	add    $0x10,%esp
8010666f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106676:	eb 07                	jmp    8010667f <allocuvm+0xdf>
    return 0;
80106678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010667f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106682:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106685:	5b                   	pop    %ebx
80106686:	5e                   	pop    %esi
80106687:	5f                   	pop    %edi
80106688:	5d                   	pop    %ebp
80106689:	c3                   	ret    

8010668a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010668a:	55                   	push   %ebp
8010668b:	89 e5                	mov    %esp,%ebp
8010668d:	56                   	push   %esi
8010668e:	53                   	push   %ebx
8010668f:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106692:	85 f6                	test   %esi,%esi
80106694:	74 1a                	je     801066b0 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106696:	83 ec 04             	sub    $0x4,%esp
80106699:	6a 00                	push   $0x0
8010669b:	68 00 00 00 80       	push   $0x80000000
801066a0:	56                   	push   %esi
801066a1:	e8 68 fe ff ff       	call   8010650e <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801066a6:	83 c4 10             	add    $0x10,%esp
801066a9:	bb 00 00 00 00       	mov    $0x0,%ebx
801066ae:	eb 10                	jmp    801066c0 <freevm+0x36>
    panic("freevm: no pgdir");
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	68 19 74 10 80       	push   $0x80107419
801066b8:	e8 8b 9c ff ff       	call   80100348 <panic>
  for(i = 0; i < NPDENTRIES; i++){
801066bd:	83 c3 01             	add    $0x1,%ebx
801066c0:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801066c6:	77 1f                	ja     801066e7 <freevm+0x5d>
    if(pgdir[i] & PTE_P){
801066c8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801066cb:	a8 01                	test   $0x1,%al
801066cd:	74 ee                	je     801066bd <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801066cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066d4:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801066d9:	83 ec 0c             	sub    $0xc,%esp
801066dc:	50                   	push   %eax
801066dd:	e8 aa b8 ff ff       	call   80101f8c <kfree>
801066e2:	83 c4 10             	add    $0x10,%esp
801066e5:	eb d6                	jmp    801066bd <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801066e7:	83 ec 0c             	sub    $0xc,%esp
801066ea:	56                   	push   %esi
801066eb:	e8 9c b8 ff ff       	call   80101f8c <kfree>
}
801066f0:	83 c4 10             	add    $0x10,%esp
801066f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801066f6:	5b                   	pop    %ebx
801066f7:	5e                   	pop    %esi
801066f8:	5d                   	pop    %ebp
801066f9:	c3                   	ret    

801066fa <setupkvm>:
{
801066fa:	55                   	push   %ebp
801066fb:	89 e5                	mov    %esp,%ebp
801066fd:	56                   	push   %esi
801066fe:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801066ff:	e8 9f b9 ff ff       	call   801020a3 <kalloc>
80106704:	89 c6                	mov    %eax,%esi
80106706:	85 c0                	test   %eax,%eax
80106708:	74 55                	je     8010675f <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
8010670a:	83 ec 04             	sub    $0x4,%esp
8010670d:	68 00 10 00 00       	push   $0x1000
80106712:	6a 00                	push   $0x0
80106714:	50                   	push   %eax
80106715:	e8 51 d7 ff ff       	call   80103e6b <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010671a:	83 c4 10             	add    $0x10,%esp
8010671d:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106722:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106728:	73 35                	jae    8010675f <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
8010672a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010672d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106730:	29 c1                	sub    %eax,%ecx
80106732:	83 ec 08             	sub    $0x8,%esp
80106735:	ff 73 0c             	push   0xc(%ebx)
80106738:	50                   	push   %eax
80106739:	8b 13                	mov    (%ebx),%edx
8010673b:	89 f0                	mov    %esi,%eax
8010673d:	e8 6f f8 ff ff       	call   80105fb1 <mappages>
80106742:	83 c4 10             	add    $0x10,%esp
80106745:	85 c0                	test   %eax,%eax
80106747:	78 05                	js     8010674e <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106749:	83 c3 10             	add    $0x10,%ebx
8010674c:	eb d4                	jmp    80106722 <setupkvm+0x28>
      freevm(pgdir);
8010674e:	83 ec 0c             	sub    $0xc,%esp
80106751:	56                   	push   %esi
80106752:	e8 33 ff ff ff       	call   8010668a <freevm>
      return 0;
80106757:	83 c4 10             	add    $0x10,%esp
8010675a:	be 00 00 00 00       	mov    $0x0,%esi
}
8010675f:	89 f0                	mov    %esi,%eax
80106761:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106764:	5b                   	pop    %ebx
80106765:	5e                   	pop    %esi
80106766:	5d                   	pop    %ebp
80106767:	c3                   	ret    

80106768 <kvmalloc>:
{
80106768:	55                   	push   %ebp
80106769:	89 e5                	mov    %esp,%ebp
8010676b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010676e:	e8 87 ff ff ff       	call   801066fa <setupkvm>
80106773:	a3 e4 45 11 80       	mov    %eax,0x801145e4
  switchkvm();
80106778:	e8 1f fb ff ff       	call   8010629c <switchkvm>
}
8010677d:	c9                   	leave  
8010677e:	c3                   	ret    

8010677f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010677f:	55                   	push   %ebp
80106780:	89 e5                	mov    %esp,%ebp
80106782:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106785:	b9 00 00 00 00       	mov    $0x0,%ecx
8010678a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010678d:	8b 45 08             	mov    0x8(%ebp),%eax
80106790:	e8 ab f7 ff ff       	call   80105f40 <walkpgdir>
  if(pte == 0)
80106795:	85 c0                	test   %eax,%eax
80106797:	74 05                	je     8010679e <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106799:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010679c:	c9                   	leave  
8010679d:	c3                   	ret    
    panic("clearpteu");
8010679e:	83 ec 0c             	sub    $0xc,%esp
801067a1:	68 2a 74 10 80       	push   $0x8010742a
801067a6:	e8 9d 9b ff ff       	call   80100348 <panic>

801067ab <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801067ab:	55                   	push   %ebp
801067ac:	89 e5                	mov    %esp,%ebp
801067ae:	57                   	push   %edi
801067af:	56                   	push   %esi
801067b0:	53                   	push   %ebx
801067b1:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801067b4:	e8 41 ff ff ff       	call   801066fa <setupkvm>
801067b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067bc:	85 c0                	test   %eax,%eax
801067be:	0f 84 c4 00 00 00    	je     80106888 <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801067c4:	bf 00 00 00 00       	mov    $0x0,%edi
801067c9:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801067cc:	0f 83 b6 00 00 00    	jae    80106888 <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801067d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801067d5:	b9 00 00 00 00       	mov    $0x0,%ecx
801067da:	89 fa                	mov    %edi,%edx
801067dc:	8b 45 08             	mov    0x8(%ebp),%eax
801067df:	e8 5c f7 ff ff       	call   80105f40 <walkpgdir>
801067e4:	85 c0                	test   %eax,%eax
801067e6:	74 65                	je     8010684d <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801067e8:	8b 00                	mov    (%eax),%eax
801067ea:	a8 01                	test   $0x1,%al
801067ec:	74 6c                	je     8010685a <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801067ee:	89 c6                	mov    %eax,%esi
801067f0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801067f6:	25 ff 0f 00 00       	and    $0xfff,%eax
801067fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801067fe:	e8 a0 b8 ff ff       	call   801020a3 <kalloc>
80106803:	89 c3                	mov    %eax,%ebx
80106805:	85 c0                	test   %eax,%eax
80106807:	74 6a                	je     80106873 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106809:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010680f:	83 ec 04             	sub    $0x4,%esp
80106812:	68 00 10 00 00       	push   $0x1000
80106817:	56                   	push   %esi
80106818:	50                   	push   %eax
80106819:	e8 c5 d6 ff ff       	call   80103ee3 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010681e:	83 c4 08             	add    $0x8,%esp
80106821:	ff 75 e0             	push   -0x20(%ebp)
80106824:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010682a:	50                   	push   %eax
8010682b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106830:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106833:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106836:	e8 76 f7 ff ff       	call   80105fb1 <mappages>
8010683b:	83 c4 10             	add    $0x10,%esp
8010683e:	85 c0                	test   %eax,%eax
80106840:	78 25                	js     80106867 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106842:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106848:	e9 7c ff ff ff       	jmp    801067c9 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
8010684d:	83 ec 0c             	sub    $0xc,%esp
80106850:	68 34 74 10 80       	push   $0x80107434
80106855:	e8 ee 9a ff ff       	call   80100348 <panic>
      panic("copyuvm: page not present");
8010685a:	83 ec 0c             	sub    $0xc,%esp
8010685d:	68 4e 74 10 80       	push   $0x8010744e
80106862:	e8 e1 9a ff ff       	call   80100348 <panic>
      kfree(mem);
80106867:	83 ec 0c             	sub    $0xc,%esp
8010686a:	53                   	push   %ebx
8010686b:	e8 1c b7 ff ff       	call   80101f8c <kfree>
      goto bad;
80106870:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
80106873:	83 ec 0c             	sub    $0xc,%esp
80106876:	ff 75 dc             	push   -0x24(%ebp)
80106879:	e8 0c fe ff ff       	call   8010668a <freevm>
  return 0;
8010687e:	83 c4 10             	add    $0x10,%esp
80106881:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106888:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010688b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010688e:	5b                   	pop    %ebx
8010688f:	5e                   	pop    %esi
80106890:	5f                   	pop    %edi
80106891:	5d                   	pop    %ebp
80106892:	c3                   	ret    

80106893 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106893:	55                   	push   %ebp
80106894:	89 e5                	mov    %esp,%ebp
80106896:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106899:	b9 00 00 00 00       	mov    $0x0,%ecx
8010689e:	8b 55 0c             	mov    0xc(%ebp),%edx
801068a1:	8b 45 08             	mov    0x8(%ebp),%eax
801068a4:	e8 97 f6 ff ff       	call   80105f40 <walkpgdir>
  if((*pte & PTE_P) == 0)
801068a9:	8b 00                	mov    (%eax),%eax
801068ab:	a8 01                	test   $0x1,%al
801068ad:	74 10                	je     801068bf <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
801068af:	a8 04                	test   $0x4,%al
801068b1:	74 13                	je     801068c6 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801068b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068b8:	05 00 00 00 80       	add    $0x80000000,%eax
}
801068bd:	c9                   	leave  
801068be:	c3                   	ret    
    return 0;
801068bf:	b8 00 00 00 00       	mov    $0x0,%eax
801068c4:	eb f7                	jmp    801068bd <uva2ka+0x2a>
    return 0;
801068c6:	b8 00 00 00 00       	mov    $0x0,%eax
801068cb:	eb f0                	jmp    801068bd <uva2ka+0x2a>

801068cd <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801068cd:	55                   	push   %ebp
801068ce:	89 e5                	mov    %esp,%ebp
801068d0:	57                   	push   %edi
801068d1:	56                   	push   %esi
801068d2:	53                   	push   %ebx
801068d3:	83 ec 0c             	sub    $0xc,%esp
801068d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801068d9:	eb 25                	jmp    80106900 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801068db:	8b 55 0c             	mov    0xc(%ebp),%edx
801068de:	29 f2                	sub    %esi,%edx
801068e0:	01 d0                	add    %edx,%eax
801068e2:	83 ec 04             	sub    $0x4,%esp
801068e5:	53                   	push   %ebx
801068e6:	ff 75 10             	push   0x10(%ebp)
801068e9:	50                   	push   %eax
801068ea:	e8 f4 d5 ff ff       	call   80103ee3 <memmove>
    len -= n;
801068ef:	29 df                	sub    %ebx,%edi
    buf += n;
801068f1:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801068f4:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801068fa:	89 45 0c             	mov    %eax,0xc(%ebp)
801068fd:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106900:	85 ff                	test   %edi,%edi
80106902:	74 2f                	je     80106933 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106904:	8b 75 0c             	mov    0xc(%ebp),%esi
80106907:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010690d:	83 ec 08             	sub    $0x8,%esp
80106910:	56                   	push   %esi
80106911:	ff 75 08             	push   0x8(%ebp)
80106914:	e8 7a ff ff ff       	call   80106893 <uva2ka>
    if(pa0 == 0)
80106919:	83 c4 10             	add    $0x10,%esp
8010691c:	85 c0                	test   %eax,%eax
8010691e:	74 20                	je     80106940 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106920:	89 f3                	mov    %esi,%ebx
80106922:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106925:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010692b:	39 df                	cmp    %ebx,%edi
8010692d:	73 ac                	jae    801068db <copyout+0xe>
      n = len;
8010692f:	89 fb                	mov    %edi,%ebx
80106931:	eb a8                	jmp    801068db <copyout+0xe>
  }
  return 0;
80106933:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106938:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010693b:	5b                   	pop    %ebx
8010693c:	5e                   	pop    %esi
8010693d:	5f                   	pop    %edi
8010693e:	5d                   	pop    %ebp
8010693f:	c3                   	ret    
      return -1;
80106940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106945:	eb f1                	jmp    80106938 <copyout+0x6b>

80106947 <retNumpp>:

// int retNumvp(){
//   return 0;
// }

int retNumpp(){
80106947:	55                   	push   %ebp
80106948:	89 e5                	mov    %esp,%ebp
8010694a:	57                   	push   %edi
8010694b:	56                   	push   %esi
8010694c:	53                   	push   %ebx
8010694d:	83 ec 1c             	sub    $0x1c,%esp
  int ii=0;
  pde_t *pgdir=myproc()->pgdir;
80106950:	e8 60 c8 ff ff       	call   801031b5 <myproc>
80106955:	8b 40 04             	mov    0x4(%eax),%eax
80106958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  k=kmap;
  // void *va = k->virt;
  uint size = k->phys_end - k->phys_start;
  uint pa = k->phys_start;
  // int perm
  a = (char*)PGROUNDDOWN((uint)pa);
8010695b:	8b 1d 24 a4 10 80    	mov    0x8010a424,%ebx
80106961:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80106967:	a1 28 a4 10 80       	mov    0x8010a428,%eax
8010696c:	8d 70 ff             	lea    -0x1(%eax),%esi
8010696f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  int ii=0;
80106975:	bf 00 00 00 00       	mov    $0x0,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
8010697a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010697f:	89 da                	mov    %ebx,%edx
80106981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106984:	e8 b7 f5 ff ff       	call   80105f40 <walkpgdir>
80106989:	85 c0                	test   %eax,%eax
8010698b:	74 14                	je     801069a1 <retNumpp+0x5a>
      return -1;
    // if(*pte & PTE_P)
      // panic("remap");
    // *pte = pa | perm | PTE_P;
    if(a == last)
8010698d:	39 f3                	cmp    %esi,%ebx
8010698f:	74 15                	je     801069a6 <retNumpp+0x5f>
      break;
    a += PGSIZE;
80106991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
    if((PTE_P & *pte)!=0){
80106997:	f6 00 01             	testb  $0x1,(%eax)
8010699a:	74 de                	je     8010697a <retNumpp+0x33>
      ii++;
8010699c:	83 c7 01             	add    $0x1,%edi
8010699f:	eb d9                	jmp    8010697a <retNumpp+0x33>
      return -1;
801069a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    }
  }

  return ii;
801069a6:	89 f8                	mov    %edi,%eax
801069a8:	83 c4 1c             	add    $0x1c,%esp
801069ab:	5b                   	pop    %ebx
801069ac:	5e                   	pop    %esi
801069ad:	5f                   	pop    %edi
801069ae:	5d                   	pop    %ebp
801069af:	c3                   	ret    
