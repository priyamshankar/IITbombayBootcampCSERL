
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
80100028:	bc 10 72 11 80       	mov    $0x80117210,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 42 2b 10 80       	mov    $0x80102b42,%eax
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
80100046:	e8 b0 3e 00 00       	call   80103efb <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 f6 10 80    	mov    0x8010f670,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 06                	jmp    8010005c <bget+0x28>
80100056:	8b 9b a4 00 00 00    	mov    0xa4(%ebx),%ebx
8010005c:	81 fb cc f5 10 80    	cmp    $0x8010f5cc,%ebx
80100062:	74 36                	je     8010009a <bget+0x66>
    if(b->dev == dev && b->blockno == blockno){
80100064:	39 73 04             	cmp    %esi,0x4(%ebx)
80100067:	75 ed                	jne    80100056 <bget+0x22>
80100069:	39 7b 08             	cmp    %edi,0x8(%ebx)
8010006c:	75 e8                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006e:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
80100074:	83 c0 01             	add    $0x1,%eax
80100077:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
      release(&bcache.lock);
8010007d:	83 ec 0c             	sub    $0xc,%esp
80100080:	68 20 a5 10 80       	push   $0x8010a520
80100085:	e8 d6 3e 00 00       	call   80103f60 <release>
      acquiresleep(&b->lock);
8010008a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010008d:	89 04 24             	mov    %eax,(%esp)
80100090:	e8 49 3c 00 00       	call   80103cde <acquiresleep>
      return b;
80100095:	83 c4 10             	add    $0x10,%esp
80100098:	eb 55                	jmp    801000ef <bget+0xbb>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010009a:	8b 1d 6c f6 10 80    	mov    0x8010f66c,%ebx
801000a0:	eb 06                	jmp    801000a8 <bget+0x74>
801000a2:	8b 9b a0 00 00 00    	mov    0xa0(%ebx),%ebx
801000a8:	81 fb cc f5 10 80    	cmp    $0x8010f5cc,%ebx
801000ae:	74 49                	je     801000f9 <bget+0xc5>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000b0:	83 bb 9c 00 00 00 00 	cmpl   $0x0,0x9c(%ebx)
801000b7:	75 e9                	jne    801000a2 <bget+0x6e>
801000b9:	f6 03 04             	testb  $0x4,(%ebx)
801000bc:	75 e4                	jne    801000a2 <bget+0x6e>
      b->dev = dev;
801000be:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000c1:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000ca:	c7 83 9c 00 00 00 01 	movl   $0x1,0x9c(%ebx)
801000d1:	00 00 00 
      release(&bcache.lock);
801000d4:	83 ec 0c             	sub    $0xc,%esp
801000d7:	68 20 a5 10 80       	push   $0x8010a520
801000dc:	e8 7f 3e 00 00       	call   80103f60 <release>
      acquiresleep(&b->lock);
801000e1:	8d 43 0c             	lea    0xc(%ebx),%eax
801000e4:	89 04 24             	mov    %eax,(%esp)
801000e7:	e8 f2 3b 00 00       	call   80103cde <acquiresleep>
      return b;
801000ec:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000ef:	89 d8                	mov    %ebx,%eax
801000f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000f4:	5b                   	pop    %ebx
801000f5:	5e                   	pop    %esi
801000f6:	5f                   	pop    %edi
801000f7:	5d                   	pop    %ebp
801000f8:	c3                   	ret    
  panic("bget: no buffers");
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 c0 6b 10 80       	push   $0x80106bc0
80100101:	e8 82 02 00 00       	call   80100388 <panic>

80100106 <binit>:
{
80100106:	55                   	push   %ebp
80100107:	89 e5                	mov    %esp,%ebp
80100109:	53                   	push   %ebx
8010010a:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010010d:	68 d1 6b 10 80       	push   $0x80106bd1
80100112:	68 20 a5 10 80       	push   $0x8010a520
80100117:	e8 a3 3c 00 00       	call   80103dbf <initlock>
  bcache.head.prev = &bcache.head;
8010011c:	c7 05 6c f6 10 80 cc 	movl   $0x8010f5cc,0x8010f66c
80100123:	f5 10 80 
  bcache.head.next = &bcache.head;
80100126:	c7 05 70 f6 10 80 cc 	movl   $0x8010f5cc,0x8010f670
8010012d:	f5 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100130:	83 c4 10             	add    $0x10,%esp
80100133:	bb a4 a5 10 80       	mov    $0x8010a5a4,%ebx
80100138:	eb 40                	jmp    8010017a <binit+0x74>
    b->next = bcache.head.next;
8010013a:	a1 70 f6 10 80       	mov    0x8010f670,%eax
8010013f:	89 83 a4 00 00 00    	mov    %eax,0xa4(%ebx)
    b->prev = &bcache.head;
80100145:	c7 83 a0 00 00 00 cc 	movl   $0x8010f5cc,0xa0(%ebx)
8010014c:	f5 10 80 
    initsleeplock(&b->lock, "buffer");
8010014f:	83 ec 08             	sub    $0x8,%esp
80100152:	68 d8 6b 10 80       	push   $0x80106bd8
80100157:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015a:	50                   	push   %eax
8010015b:	e8 45 3b 00 00       	call   80103ca5 <initsleeplock>
    bcache.head.next->prev = b;
80100160:	a1 70 f6 10 80       	mov    0x8010f670,%eax
80100165:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
    bcache.head.next = b;
8010016b:	89 1d 70 f6 10 80    	mov    %ebx,0x8010f670
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100171:	81 c3 ac 02 00 00    	add    $0x2ac,%ebx
80100177:	83 c4 10             	add    $0x10,%esp
8010017a:	81 fb cc f5 10 80    	cmp    $0x8010f5cc,%ebx
80100180:	72 b8                	jb     8010013a <binit+0x34>
}
80100182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100185:	c9                   	leave  
80100186:	c3                   	ret    

80100187 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100187:	55                   	push   %ebp
80100188:	89 e5                	mov    %esp,%ebp
8010018a:	53                   	push   %ebx
8010018b:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010018e:	8b 55 0c             	mov    0xc(%ebp),%edx
80100191:	8b 45 08             	mov    0x8(%ebp),%eax
80100194:	e8 9b fe ff ff       	call   80100034 <bget>
80100199:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
8010019b:	f6 00 02             	testb  $0x2,(%eax)
8010019e:	74 07                	je     801001a7 <bread+0x20>
    iderw(b);
  }
  return b;
}
801001a0:	89 d8                	mov    %ebx,%eax
801001a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    
    iderw(b);
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	50                   	push   %eax
801001ab:	e8 37 1d 00 00       	call   80101ee7 <iderw>
801001b0:	83 c4 10             	add    $0x10,%esp
  return b;
801001b3:	eb eb                	jmp    801001a0 <bread+0x19>

801001b5 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	53                   	push   %ebx
801001b9:	83 ec 10             	sub    $0x10,%esp
801001bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001bf:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c2:	50                   	push   %eax
801001c3:	e8 a6 3b 00 00       	call   80103d6e <holdingsleep>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	85 c0                	test   %eax,%eax
801001cd:	74 14                	je     801001e3 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001cf:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d2:	83 ec 0c             	sub    $0xc,%esp
801001d5:	53                   	push   %ebx
801001d6:	e8 0c 1d 00 00       	call   80101ee7 <iderw>
}
801001db:	83 c4 10             	add    $0x10,%esp
801001de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001e1:	c9                   	leave  
801001e2:	c3                   	ret    
    panic("bwrite");
801001e3:	83 ec 0c             	sub    $0xc,%esp
801001e6:	68 df 6b 10 80       	push   $0x80106bdf
801001eb:	e8 98 01 00 00       	call   80100388 <panic>

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6a 3b 00 00       	call   80103d6e <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	0f 84 8c 00 00 00    	je     8010029b <brelse+0xab>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 18 3b 00 00       	call   80103d30 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021f:	e8 d7 3c 00 00       	call   80103efb <acquire>
  b->refcnt--;
80100224:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
  if (b->refcnt == 0) {
80100233:	83 c4 10             	add    $0x10,%esp
80100236:	85 c0                	test   %eax,%eax
80100238:	75 4a                	jne    80100284 <brelse+0x94>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010023a:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80100240:	8b 93 a0 00 00 00    	mov    0xa0(%ebx),%edx
80100246:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
    b->prev->next = b->next;
8010024c:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80100252:	8b 93 a4 00 00 00    	mov    0xa4(%ebx),%edx
80100258:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
    b->next = bcache.head.next;
8010025e:	a1 70 f6 10 80       	mov    0x8010f670,%eax
80100263:	89 83 a4 00 00 00    	mov    %eax,0xa4(%ebx)
    b->prev = &bcache.head;
80100269:	c7 83 a0 00 00 00 cc 	movl   $0x8010f5cc,0xa0(%ebx)
80100270:	f5 10 80 
    bcache.head.next->prev = b;
80100273:	a1 70 f6 10 80       	mov    0x8010f670,%eax
80100278:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
    bcache.head.next = b;
8010027e:	89 1d 70 f6 10 80    	mov    %ebx,0x8010f670
  }
  
  release(&bcache.lock);
80100284:	83 ec 0c             	sub    $0xc,%esp
80100287:	68 20 a5 10 80       	push   $0x8010a520
8010028c:	e8 cf 3c 00 00       	call   80103f60 <release>
}
80100291:	83 c4 10             	add    $0x10,%esp
80100294:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100297:	5b                   	pop    %ebx
80100298:	5e                   	pop    %esi
80100299:	5d                   	pop    %ebp
8010029a:	c3                   	ret    
    panic("brelse");
8010029b:	83 ec 0c             	sub    $0xc,%esp
8010029e:	68 e6 6b 10 80       	push   $0x80106be6
801002a3:	e8 e0 00 00 00       	call   80100388 <panic>

801002a8 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002a8:	55                   	push   %ebp
801002a9:	89 e5                	mov    %esp,%ebp
801002ab:	57                   	push   %edi
801002ac:	56                   	push   %esi
801002ad:	53                   	push   %ebx
801002ae:	83 ec 28             	sub    $0x28,%esp
801002b1:	8b 7d 08             	mov    0x8(%ebp),%edi
801002b4:	8b 75 0c             	mov    0xc(%ebp),%esi
801002b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
801002ba:	57                   	push   %edi
801002bb:	e8 13 14 00 00       	call   801016d3 <iunlock>
  target = n;
801002c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
801002c3:	c7 04 24 20 f9 10 80 	movl   $0x8010f920,(%esp)
801002ca:	e8 2c 3c 00 00       	call   80103efb <acquire>
  while(n > 0){
801002cf:	83 c4 10             	add    $0x10,%esp
801002d2:	85 db                	test   %ebx,%ebx
801002d4:	0f 8e 8f 00 00 00    	jle    80100369 <consoleread+0xc1>
    while(input.r == input.w){
801002da:	a1 00 f9 10 80       	mov    0x8010f900,%eax
801002df:	3b 05 04 f9 10 80    	cmp    0x8010f904,%eax
801002e5:	75 47                	jne    8010032e <consoleread+0x86>
      if(myproc()->killed){
801002e7:	e8 dd 2f 00 00       	call   801032c9 <myproc>
801002ec:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002f0:	75 17                	jne    80100309 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002f2:	83 ec 08             	sub    $0x8,%esp
801002f5:	68 20 f9 10 80       	push   $0x8010f920
801002fa:	68 00 f9 10 80       	push   $0x8010f900
801002ff:	e8 8c 34 00 00       	call   80103790 <sleep>
80100304:	83 c4 10             	add    $0x10,%esp
80100307:	eb d1                	jmp    801002da <consoleread+0x32>
        release(&cons.lock);
80100309:	83 ec 0c             	sub    $0xc,%esp
8010030c:	68 20 f9 10 80       	push   $0x8010f920
80100311:	e8 4a 3c 00 00       	call   80103f60 <release>
        ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 d5 12 00 00       	call   801015f3 <ilock>
        return -1;
8010031e:	83 c4 10             	add    $0x10,%esp
80100321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100329:	5b                   	pop    %ebx
8010032a:	5e                   	pop    %esi
8010032b:	5f                   	pop    %edi
8010032c:	5d                   	pop    %ebp
8010032d:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
8010032e:	8d 50 01             	lea    0x1(%eax),%edx
80100331:	89 15 00 f9 10 80    	mov    %edx,0x8010f900
80100337:	89 c2                	mov    %eax,%edx
80100339:	83 e2 7f             	and    $0x7f,%edx
8010033c:	0f b6 92 80 f8 10 80 	movzbl -0x7fef0780(%edx),%edx
80100343:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100346:	80 fa 04             	cmp    $0x4,%dl
80100349:	74 14                	je     8010035f <consoleread+0xb7>
    *dst++ = c;
8010034b:	8d 46 01             	lea    0x1(%esi),%eax
8010034e:	88 16                	mov    %dl,(%esi)
    --n;
80100350:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100353:	83 f9 0a             	cmp    $0xa,%ecx
80100356:	74 11                	je     80100369 <consoleread+0xc1>
    *dst++ = c;
80100358:	89 c6                	mov    %eax,%esi
8010035a:	e9 73 ff ff ff       	jmp    801002d2 <consoleread+0x2a>
      if(n < target){
8010035f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100362:	73 05                	jae    80100369 <consoleread+0xc1>
        input.r--;
80100364:	a3 00 f9 10 80       	mov    %eax,0x8010f900
  release(&cons.lock);
80100369:	83 ec 0c             	sub    $0xc,%esp
8010036c:	68 20 f9 10 80       	push   $0x8010f920
80100371:	e8 ea 3b 00 00       	call   80103f60 <release>
  ilock(ip);
80100376:	89 3c 24             	mov    %edi,(%esp)
80100379:	e8 75 12 00 00       	call   801015f3 <ilock>
  return target - n;
8010037e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	83 c4 10             	add    $0x10,%esp
80100386:	eb 9e                	jmp    80100326 <consoleread+0x7e>

80100388 <panic>:
{
80100388:	55                   	push   %ebp
80100389:	89 e5                	mov    %esp,%ebp
8010038b:	53                   	push   %ebx
8010038c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010038f:	fa                   	cli    
  cons.locking = 0;
80100390:	c7 05 a4 f9 10 80 00 	movl   $0x0,0x8010f9a4
80100397:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010039a:	e8 b7 20 00 00       	call   80102456 <lapicid>
8010039f:	83 ec 08             	sub    $0x8,%esp
801003a2:	50                   	push   %eax
801003a3:	68 ed 6b 10 80       	push   $0x80106bed
801003a8:	e8 9a 02 00 00       	call   80100647 <cprintf>
  cprintf(s);
801003ad:	83 c4 04             	add    $0x4,%esp
801003b0:	ff 75 08             	push   0x8(%ebp)
801003b3:	e8 8f 02 00 00       	call   80100647 <cprintf>
  cprintf("\n");
801003b8:	c7 04 24 17 76 10 80 	movl   $0x80107617,(%esp)
801003bf:	e8 83 02 00 00       	call   80100647 <cprintf>
  getcallerpcs(&s, pcs);
801003c4:	83 c4 08             	add    $0x8,%esp
801003c7:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003ca:	50                   	push   %eax
801003cb:	8d 45 08             	lea    0x8(%ebp),%eax
801003ce:	50                   	push   %eax
801003cf:	e8 06 3a 00 00       	call   80103dda <getcallerpcs>
  for(i=0; i<10; i++)
801003d4:	83 c4 10             	add    $0x10,%esp
801003d7:	bb 00 00 00 00       	mov    $0x0,%ebx
801003dc:	eb 17                	jmp    801003f5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
801003de:	83 ec 08             	sub    $0x8,%esp
801003e1:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
801003e5:	68 01 6c 10 80       	push   $0x80106c01
801003ea:	e8 58 02 00 00       	call   80100647 <cprintf>
  for(i=0; i<10; i++)
801003ef:	83 c3 01             	add    $0x1,%ebx
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	83 fb 09             	cmp    $0x9,%ebx
801003f8:	7e e4                	jle    801003de <panic+0x56>
  panicked = 1; // freeze other CPU
801003fa:	c7 05 a8 f9 10 80 01 	movl   $0x1,0x8010f9a8
80100401:	00 00 00 
  for(;;)
80100404:	eb fe                	jmp    80100404 <panic+0x7c>

80100406 <cgaputc>:
{
80100406:	55                   	push   %ebp
80100407:	89 e5                	mov    %esp,%ebp
80100409:	57                   	push   %edi
8010040a:	56                   	push   %esi
8010040b:	53                   	push   %ebx
8010040c:	83 ec 0c             	sub    $0xc,%esp
8010040f:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100411:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100416:	b8 0e 00 00 00       	mov    $0xe,%eax
8010041b:	89 fa                	mov    %edi,%edx
8010041d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100423:	89 ca                	mov    %ecx,%edx
80100425:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100426:	0f b6 f0             	movzbl %al,%esi
80100429:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100431:	89 fa                	mov    %edi,%edx
80100433:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100437:	0f b6 c8             	movzbl %al,%ecx
8010043a:	09 f1                	or     %esi,%ecx
  if(c == '\n')
8010043c:	83 fb 0a             	cmp    $0xa,%ebx
8010043f:	74 60                	je     801004a1 <cgaputc+0x9b>
  else if(c == BACKSPACE){
80100441:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100447:	74 79                	je     801004c2 <cgaputc+0xbc>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c3             	movzbl %bl,%eax
8010044c:	8d 59 01             	lea    0x1(%ecx),%ebx
8010044f:	80 cc 07             	or     $0x7,%ah
80100452:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	77 6d                	ja     801004cf <cgaputc+0xc9>
  if((pos/80) >= 24){  // Scroll up.
80100462:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100468:	7f 72                	jg     801004dc <cgaputc+0xd6>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010046f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100474:	89 f2                	mov    %esi,%edx
80100476:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100477:	0f b6 c7             	movzbl %bh,%eax
8010047a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010047f:	89 ca                	mov    %ecx,%edx
80100481:	ee                   	out    %al,(%dx)
80100482:	b8 0f 00 00 00       	mov    $0xf,%eax
80100487:	89 f2                	mov    %esi,%edx
80100489:	ee                   	out    %al,(%dx)
8010048a:	89 d8                	mov    %ebx,%eax
8010048c:	89 ca                	mov    %ecx,%edx
8010048e:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010048f:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100496:	80 20 07 
}
80100499:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010049c:	5b                   	pop    %ebx
8010049d:	5e                   	pop    %esi
8010049e:	5f                   	pop    %edi
8010049f:	5d                   	pop    %ebp
801004a0:	c3                   	ret    
    pos += 80 - pos%80;
801004a1:	ba 67 66 66 66       	mov    $0x66666667,%edx
801004a6:	89 c8                	mov    %ecx,%eax
801004a8:	f7 ea                	imul   %edx
801004aa:	c1 fa 05             	sar    $0x5,%edx
801004ad:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004b0:	c1 e0 04             	shl    $0x4,%eax
801004b3:	89 ca                	mov    %ecx,%edx
801004b5:	29 c2                	sub    %eax,%edx
801004b7:	bb 50 00 00 00       	mov    $0x50,%ebx
801004bc:	29 d3                	sub    %edx,%ebx
801004be:	01 cb                	add    %ecx,%ebx
801004c0:	eb 98                	jmp    8010045a <cgaputc+0x54>
    if(pos > 0) --pos;
801004c2:	85 c9                	test   %ecx,%ecx
801004c4:	7e 05                	jle    801004cb <cgaputc+0xc5>
801004c6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004c9:	eb 8f                	jmp    8010045a <cgaputc+0x54>
  pos |= inb(CRTPORT+1);
801004cb:	89 cb                	mov    %ecx,%ebx
801004cd:	eb 8b                	jmp    8010045a <cgaputc+0x54>
    panic("pos under/overflow");
801004cf:	83 ec 0c             	sub    $0xc,%esp
801004d2:	68 05 6c 10 80       	push   $0x80106c05
801004d7:	e8 ac fe ff ff       	call   80100388 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004dc:	83 ec 04             	sub    $0x4,%esp
801004df:	68 60 0e 00 00       	push   $0xe60
801004e4:	68 a0 80 0b 80       	push   $0x800b80a0
801004e9:	68 00 80 0b 80       	push   $0x800b8000
801004ee:	e8 a4 3b 00 00       	call   80104097 <memmove>
    pos -= 80;
801004f3:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	b8 80 07 00 00       	mov    $0x780,%eax
801004fb:	29 d8                	sub    %ebx,%eax
801004fd:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
80100504:	83 c4 0c             	add    $0xc,%esp
80100507:	01 c0                	add    %eax,%eax
80100509:	50                   	push   %eax
8010050a:	6a 00                	push   $0x0
8010050c:	52                   	push   %edx
8010050d:	e8 0d 3b 00 00       	call   8010401f <memset>
80100512:	83 c4 10             	add    $0x10,%esp
80100515:	e9 50 ff ff ff       	jmp    8010046a <cgaputc+0x64>

8010051a <consputc>:
  if(panicked){
8010051a:	83 3d a8 f9 10 80 00 	cmpl   $0x0,0x8010f9a8
80100521:	74 03                	je     80100526 <consputc+0xc>
  asm volatile("cli");
80100523:	fa                   	cli    
    for(;;)
80100524:	eb fe                	jmp    80100524 <consputc+0xa>
{
80100526:	55                   	push   %ebp
80100527:	89 e5                	mov    %esp,%ebp
80100529:	53                   	push   %ebx
8010052a:	83 ec 04             	sub    $0x4,%esp
8010052d:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010052f:	3d 00 01 00 00       	cmp    $0x100,%eax
80100534:	74 18                	je     8010054e <consputc+0x34>
    uartputc(c);
80100536:	83 ec 0c             	sub    $0xc,%esp
80100539:	50                   	push   %eax
8010053a:	e8 86 50 00 00       	call   801055c5 <uartputc>
8010053f:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100542:	89 d8                	mov    %ebx,%eax
80100544:	e8 bd fe ff ff       	call   80100406 <cgaputc>
}
80100549:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010054c:	c9                   	leave  
8010054d:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	6a 08                	push   $0x8
80100553:	e8 6d 50 00 00       	call   801055c5 <uartputc>
80100558:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010055f:	e8 61 50 00 00       	call   801055c5 <uartputc>
80100564:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010056b:	e8 55 50 00 00       	call   801055c5 <uartputc>
80100570:	83 c4 10             	add    $0x10,%esp
80100573:	eb cd                	jmp    80100542 <consputc+0x28>

80100575 <printint>:
{
80100575:	55                   	push   %ebp
80100576:	89 e5                	mov    %esp,%ebp
80100578:	57                   	push   %edi
80100579:	56                   	push   %esi
8010057a:	53                   	push   %ebx
8010057b:	83 ec 2c             	sub    $0x2c,%esp
8010057e:	89 d6                	mov    %edx,%esi
80100580:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100583:	85 c9                	test   %ecx,%ecx
80100585:	74 0c                	je     80100593 <printint+0x1e>
80100587:	89 c7                	mov    %eax,%edi
80100589:	c1 ef 1f             	shr    $0x1f,%edi
8010058c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010058f:	85 c0                	test   %eax,%eax
80100591:	78 38                	js     801005cb <printint+0x56>
    x = xx;
80100593:	89 c1                	mov    %eax,%ecx
  i = 0;
80100595:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
8010059a:	89 c8                	mov    %ecx,%eax
8010059c:	ba 00 00 00 00       	mov    $0x0,%edx
801005a1:	f7 f6                	div    %esi
801005a3:	89 df                	mov    %ebx,%edi
801005a5:	83 c3 01             	add    $0x1,%ebx
801005a8:	0f b6 92 30 6c 10 80 	movzbl -0x7fef93d0(%edx),%edx
801005af:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
801005b3:	89 ca                	mov    %ecx,%edx
801005b5:	89 c1                	mov    %eax,%ecx
801005b7:	39 d6                	cmp    %edx,%esi
801005b9:	76 df                	jbe    8010059a <printint+0x25>
  if(sign)
801005bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801005bf:	74 1a                	je     801005db <printint+0x66>
    buf[i++] = '-';
801005c1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005c6:	8d 5f 02             	lea    0x2(%edi),%ebx
801005c9:	eb 10                	jmp    801005db <printint+0x66>
    x = -xx;
801005cb:	f7 d8                	neg    %eax
801005cd:	89 c1                	mov    %eax,%ecx
801005cf:	eb c4                	jmp    80100595 <printint+0x20>
    consputc(buf[i]);
801005d1:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005d6:	e8 3f ff ff ff       	call   8010051a <consputc>
  while(--i >= 0)
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	79 f1                	jns    801005d1 <printint+0x5c>
}
801005e0:	83 c4 2c             	add    $0x2c,%esp
801005e3:	5b                   	pop    %ebx
801005e4:	5e                   	pop    %esi
801005e5:	5f                   	pop    %edi
801005e6:	5d                   	pop    %ebp
801005e7:	c3                   	ret    

801005e8 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e8:	55                   	push   %ebp
801005e9:	89 e5                	mov    %esp,%ebp
801005eb:	57                   	push   %edi
801005ec:	56                   	push   %esi
801005ed:	53                   	push   %ebx
801005ee:	83 ec 18             	sub    $0x18,%esp
801005f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005f4:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005f7:	ff 75 08             	push   0x8(%ebp)
801005fa:	e8 d4 10 00 00       	call   801016d3 <iunlock>
  acquire(&cons.lock);
801005ff:	c7 04 24 20 f9 10 80 	movl   $0x8010f920,(%esp)
80100606:	e8 f0 38 00 00       	call   80103efb <acquire>
  for(i = 0; i < n; i++)
8010060b:	83 c4 10             	add    $0x10,%esp
8010060e:	bb 00 00 00 00       	mov    $0x0,%ebx
80100613:	eb 0c                	jmp    80100621 <consolewrite+0x39>
    consputc(buf[i] & 0xff);
80100615:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
80100619:	e8 fc fe ff ff       	call   8010051a <consputc>
  for(i = 0; i < n; i++)
8010061e:	83 c3 01             	add    $0x1,%ebx
80100621:	39 f3                	cmp    %esi,%ebx
80100623:	7c f0                	jl     80100615 <consolewrite+0x2d>
  release(&cons.lock);
80100625:	83 ec 0c             	sub    $0xc,%esp
80100628:	68 20 f9 10 80       	push   $0x8010f920
8010062d:	e8 2e 39 00 00       	call   80103f60 <release>
  ilock(ip);
80100632:	83 c4 04             	add    $0x4,%esp
80100635:	ff 75 08             	push   0x8(%ebp)
80100638:	e8 b6 0f 00 00       	call   801015f3 <ilock>

  return n;
}
8010063d:	89 f0                	mov    %esi,%eax
8010063f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100642:	5b                   	pop    %ebx
80100643:	5e                   	pop    %esi
80100644:	5f                   	pop    %edi
80100645:	5d                   	pop    %ebp
80100646:	c3                   	ret    

80100647 <cprintf>:
{
80100647:	55                   	push   %ebp
80100648:	89 e5                	mov    %esp,%ebp
8010064a:	57                   	push   %edi
8010064b:	56                   	push   %esi
8010064c:	53                   	push   %ebx
8010064d:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100650:	a1 a4 f9 10 80       	mov    0x8010f9a4,%eax
80100655:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100658:	85 c0                	test   %eax,%eax
8010065a:	75 10                	jne    8010066c <cprintf+0x25>
  if (fmt == 0)
8010065c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100660:	74 1c                	je     8010067e <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
80100662:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100665:	be 00 00 00 00       	mov    $0x0,%esi
8010066a:	eb 27                	jmp    80100693 <cprintf+0x4c>
    acquire(&cons.lock);
8010066c:	83 ec 0c             	sub    $0xc,%esp
8010066f:	68 20 f9 10 80       	push   $0x8010f920
80100674:	e8 82 38 00 00       	call   80103efb <acquire>
80100679:	83 c4 10             	add    $0x10,%esp
8010067c:	eb de                	jmp    8010065c <cprintf+0x15>
    panic("null fmt");
8010067e:	83 ec 0c             	sub    $0xc,%esp
80100681:	68 1f 6c 10 80       	push   $0x80106c1f
80100686:	e8 fd fc ff ff       	call   80100388 <panic>
      consputc(c);
8010068b:	e8 8a fe ff ff       	call   8010051a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100690:	83 c6 01             	add    $0x1,%esi
80100693:	8b 55 08             	mov    0x8(%ebp),%edx
80100696:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010069a:	85 c0                	test   %eax,%eax
8010069c:	0f 84 b1 00 00 00    	je     80100753 <cprintf+0x10c>
    if(c != '%'){
801006a2:	83 f8 25             	cmp    $0x25,%eax
801006a5:	75 e4                	jne    8010068b <cprintf+0x44>
    c = fmt[++i] & 0xff;
801006a7:	83 c6 01             	add    $0x1,%esi
801006aa:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
801006ae:	85 db                	test   %ebx,%ebx
801006b0:	0f 84 9d 00 00 00    	je     80100753 <cprintf+0x10c>
    switch(c){
801006b6:	83 fb 70             	cmp    $0x70,%ebx
801006b9:	74 2e                	je     801006e9 <cprintf+0xa2>
801006bb:	7f 22                	jg     801006df <cprintf+0x98>
801006bd:	83 fb 25             	cmp    $0x25,%ebx
801006c0:	74 6c                	je     8010072e <cprintf+0xe7>
801006c2:	83 fb 64             	cmp    $0x64,%ebx
801006c5:	75 76                	jne    8010073d <cprintf+0xf6>
      printint(*argp++, 10, 1);
801006c7:	8d 5f 04             	lea    0x4(%edi),%ebx
801006ca:	8b 07                	mov    (%edi),%eax
801006cc:	b9 01 00 00 00       	mov    $0x1,%ecx
801006d1:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d6:	e8 9a fe ff ff       	call   80100575 <printint>
801006db:	89 df                	mov    %ebx,%edi
      break;
801006dd:	eb b1                	jmp    80100690 <cprintf+0x49>
    switch(c){
801006df:	83 fb 73             	cmp    $0x73,%ebx
801006e2:	74 1d                	je     80100701 <cprintf+0xba>
801006e4:	83 fb 78             	cmp    $0x78,%ebx
801006e7:	75 54                	jne    8010073d <cprintf+0xf6>
      printint(*argp++, 16, 0);
801006e9:	8d 5f 04             	lea    0x4(%edi),%ebx
801006ec:	8b 07                	mov    (%edi),%eax
801006ee:	b9 00 00 00 00       	mov    $0x0,%ecx
801006f3:	ba 10 00 00 00       	mov    $0x10,%edx
801006f8:	e8 78 fe ff ff       	call   80100575 <printint>
801006fd:	89 df                	mov    %ebx,%edi
      break;
801006ff:	eb 8f                	jmp    80100690 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100707:	8b 1f                	mov    (%edi),%ebx
80100709:	85 db                	test   %ebx,%ebx
8010070b:	75 12                	jne    8010071f <cprintf+0xd8>
        s = "(null)";
8010070d:	bb 18 6c 10 80       	mov    $0x80106c18,%ebx
80100712:	eb 0b                	jmp    8010071f <cprintf+0xd8>
        consputc(*s);
80100714:	0f be c0             	movsbl %al,%eax
80100717:	e8 fe fd ff ff       	call   8010051a <consputc>
      for(; *s; s++)
8010071c:	83 c3 01             	add    $0x1,%ebx
8010071f:	0f b6 03             	movzbl (%ebx),%eax
80100722:	84 c0                	test   %al,%al
80100724:	75 ee                	jne    80100714 <cprintf+0xcd>
      if((s = (char*)*argp++) == 0)
80100726:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100729:	e9 62 ff ff ff       	jmp    80100690 <cprintf+0x49>
      consputc('%');
8010072e:	b8 25 00 00 00       	mov    $0x25,%eax
80100733:	e8 e2 fd ff ff       	call   8010051a <consputc>
      break;
80100738:	e9 53 ff ff ff       	jmp    80100690 <cprintf+0x49>
      consputc('%');
8010073d:	b8 25 00 00 00       	mov    $0x25,%eax
80100742:	e8 d3 fd ff ff       	call   8010051a <consputc>
      consputc(c);
80100747:	89 d8                	mov    %ebx,%eax
80100749:	e8 cc fd ff ff       	call   8010051a <consputc>
      break;
8010074e:	e9 3d ff ff ff       	jmp    80100690 <cprintf+0x49>
  if(locking)
80100753:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100757:	75 08                	jne    80100761 <cprintf+0x11a>
}
80100759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010075c:	5b                   	pop    %ebx
8010075d:	5e                   	pop    %esi
8010075e:	5f                   	pop    %edi
8010075f:	5d                   	pop    %ebp
80100760:	c3                   	ret    
    release(&cons.lock);
80100761:	83 ec 0c             	sub    $0xc,%esp
80100764:	68 20 f9 10 80       	push   $0x8010f920
80100769:	e8 f2 37 00 00       	call   80103f60 <release>
8010076e:	83 c4 10             	add    $0x10,%esp
}
80100771:	eb e6                	jmp    80100759 <cprintf+0x112>

80100773 <consoleintr>:
{
80100773:	55                   	push   %ebp
80100774:	89 e5                	mov    %esp,%ebp
80100776:	57                   	push   %edi
80100777:	56                   	push   %esi
80100778:	53                   	push   %ebx
80100779:	83 ec 18             	sub    $0x18,%esp
8010077c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010077f:	68 20 f9 10 80       	push   $0x8010f920
80100784:	e8 72 37 00 00       	call   80103efb <acquire>
  while((c = getc()) >= 0){
80100789:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010078c:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100791:	eb 13                	jmp    801007a6 <consoleintr+0x33>
    switch(c){
80100793:	83 ff 08             	cmp    $0x8,%edi
80100796:	0f 84 d9 00 00 00    	je     80100875 <consoleintr+0x102>
8010079c:	83 ff 10             	cmp    $0x10,%edi
8010079f:	75 25                	jne    801007c6 <consoleintr+0x53>
801007a1:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801007a6:	ff d3                	call   *%ebx
801007a8:	89 c7                	mov    %eax,%edi
801007aa:	85 c0                	test   %eax,%eax
801007ac:	0f 88 f5 00 00 00    	js     801008a7 <consoleintr+0x134>
    switch(c){
801007b2:	83 ff 15             	cmp    $0x15,%edi
801007b5:	0f 84 93 00 00 00    	je     8010084e <consoleintr+0xdb>
801007bb:	7e d6                	jle    80100793 <consoleintr+0x20>
801007bd:	83 ff 7f             	cmp    $0x7f,%edi
801007c0:	0f 84 af 00 00 00    	je     80100875 <consoleintr+0x102>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007c6:	85 ff                	test   %edi,%edi
801007c8:	74 dc                	je     801007a6 <consoleintr+0x33>
801007ca:	a1 08 f9 10 80       	mov    0x8010f908,%eax
801007cf:	89 c2                	mov    %eax,%edx
801007d1:	2b 15 00 f9 10 80    	sub    0x8010f900,%edx
801007d7:	83 fa 7f             	cmp    $0x7f,%edx
801007da:	77 ca                	ja     801007a6 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
801007dc:	83 ff 0d             	cmp    $0xd,%edi
801007df:	0f 84 b8 00 00 00    	je     8010089d <consoleintr+0x12a>
        input.buf[input.e++ % INPUT_BUF] = c;
801007e5:	8d 50 01             	lea    0x1(%eax),%edx
801007e8:	89 15 08 f9 10 80    	mov    %edx,0x8010f908
801007ee:	83 e0 7f             	and    $0x7f,%eax
801007f1:	89 f9                	mov    %edi,%ecx
801007f3:	88 88 80 f8 10 80    	mov    %cl,-0x7fef0780(%eax)
        consputc(c);
801007f9:	89 f8                	mov    %edi,%eax
801007fb:	e8 1a fd ff ff       	call   8010051a <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100800:	83 ff 0a             	cmp    $0xa,%edi
80100803:	0f 94 c0             	sete   %al
80100806:	83 ff 04             	cmp    $0x4,%edi
80100809:	0f 94 c2             	sete   %dl
8010080c:	08 d0                	or     %dl,%al
8010080e:	75 10                	jne    80100820 <consoleintr+0xad>
80100810:	a1 00 f9 10 80       	mov    0x8010f900,%eax
80100815:	83 e8 80             	sub    $0xffffff80,%eax
80100818:	39 05 08 f9 10 80    	cmp    %eax,0x8010f908
8010081e:	75 86                	jne    801007a6 <consoleintr+0x33>
          input.w = input.e;
80100820:	a1 08 f9 10 80       	mov    0x8010f908,%eax
80100825:	a3 04 f9 10 80       	mov    %eax,0x8010f904
          wakeup(&input.r);
8010082a:	83 ec 0c             	sub    $0xc,%esp
8010082d:	68 00 f9 10 80       	push   $0x8010f900
80100832:	e8 be 30 00 00       	call   801038f5 <wakeup>
80100837:	83 c4 10             	add    $0x10,%esp
8010083a:	e9 67 ff ff ff       	jmp    801007a6 <consoleintr+0x33>
        input.e--;
8010083f:	a3 08 f9 10 80       	mov    %eax,0x8010f908
        consputc(BACKSPACE);
80100844:	b8 00 01 00 00       	mov    $0x100,%eax
80100849:	e8 cc fc ff ff       	call   8010051a <consputc>
      while(input.e != input.w &&
8010084e:	a1 08 f9 10 80       	mov    0x8010f908,%eax
80100853:	3b 05 04 f9 10 80    	cmp    0x8010f904,%eax
80100859:	0f 84 47 ff ff ff    	je     801007a6 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	89 c2                	mov    %eax,%edx
80100864:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100867:	80 ba 80 f8 10 80 0a 	cmpb   $0xa,-0x7fef0780(%edx)
8010086e:	75 cf                	jne    8010083f <consoleintr+0xcc>
80100870:	e9 31 ff ff ff       	jmp    801007a6 <consoleintr+0x33>
      if(input.e != input.w){
80100875:	a1 08 f9 10 80       	mov    0x8010f908,%eax
8010087a:	3b 05 04 f9 10 80    	cmp    0x8010f904,%eax
80100880:	0f 84 20 ff ff ff    	je     801007a6 <consoleintr+0x33>
        input.e--;
80100886:	83 e8 01             	sub    $0x1,%eax
80100889:	a3 08 f9 10 80       	mov    %eax,0x8010f908
        consputc(BACKSPACE);
8010088e:	b8 00 01 00 00       	mov    $0x100,%eax
80100893:	e8 82 fc ff ff       	call   8010051a <consputc>
80100898:	e9 09 ff ff ff       	jmp    801007a6 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010089d:	bf 0a 00 00 00       	mov    $0xa,%edi
801008a2:	e9 3e ff ff ff       	jmp    801007e5 <consoleintr+0x72>
  release(&cons.lock);
801008a7:	83 ec 0c             	sub    $0xc,%esp
801008aa:	68 20 f9 10 80       	push   $0x8010f920
801008af:	e8 ac 36 00 00       	call   80103f60 <release>
  if(doprocdump) {
801008b4:	83 c4 10             	add    $0x10,%esp
801008b7:	85 f6                	test   %esi,%esi
801008b9:	75 08                	jne    801008c3 <consoleintr+0x150>
}
801008bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008be:	5b                   	pop    %ebx
801008bf:	5e                   	pop    %esi
801008c0:	5f                   	pop    %edi
801008c1:	5d                   	pop    %ebp
801008c2:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008c3:	e8 ca 30 00 00       	call   80103992 <procdump>
}
801008c8:	eb f1                	jmp    801008bb <consoleintr+0x148>

801008ca <consoleinit>:

void
consoleinit(void)
{
801008ca:	55                   	push   %ebp
801008cb:	89 e5                	mov    %esp,%ebp
801008cd:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008d0:	68 28 6c 10 80       	push   $0x80106c28
801008d5:	68 20 f9 10 80       	push   $0x8010f920
801008da:	e8 e0 34 00 00       	call   80103dbf <initlock>

  devsw[CONSOLE].write = consolewrite;
801008df:	c7 05 cc 03 11 80 e8 	movl   $0x801005e8,0x801103cc
801008e6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008e9:	c7 05 c8 03 11 80 a8 	movl   $0x801002a8,0x801103c8
801008f0:	02 10 80 
  cons.locking = 1;
801008f3:	c7 05 a4 f9 10 80 01 	movl   $0x1,0x8010f9a4
801008fa:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008fd:	83 c4 08             	add    $0x8,%esp
80100900:	6a 00                	push   $0x0
80100902:	6a 01                	push   $0x1
80100904:	e8 4e 17 00 00       	call   80102057 <ioapicenable>
}
80100909:	83 c4 10             	add    $0x10,%esp
8010090c:	c9                   	leave  
8010090d:	c3                   	ret    

8010090e <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
8010090e:	55                   	push   %ebp
8010090f:	89 e5                	mov    %esp,%ebp
80100911:	57                   	push   %edi
80100912:	56                   	push   %esi
80100913:	53                   	push   %ebx
80100914:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010091a:	e8 aa 29 00 00       	call   801032c9 <myproc>
8010091f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100925:	e8 62 1f 00 00       	call   8010288c <begin_op>

  if((ip = namei(path)) == 0){
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	ff 75 08             	push   0x8(%ebp)
80100930:	e8 7f 13 00 00       	call   80101cb4 <namei>
80100935:	83 c4 10             	add    $0x10,%esp
80100938:	85 c0                	test   %eax,%eax
8010093a:	74 56                	je     80100992 <exec+0x84>
8010093c:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
8010093e:	83 ec 0c             	sub    $0xc,%esp
80100941:	50                   	push   %eax
80100942:	e8 ac 0c 00 00       	call   801015f3 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100947:	6a 34                	push   $0x34
80100949:	6a 00                	push   $0x0
8010094b:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100951:	50                   	push   %eax
80100952:	53                   	push   %ebx
80100953:	e8 c3 0e 00 00       	call   8010181b <readi>
80100958:	83 c4 20             	add    $0x20,%esp
8010095b:	83 f8 34             	cmp    $0x34,%eax
8010095e:	75 0c                	jne    8010096c <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100960:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100967:	45 4c 46 
8010096a:	74 42                	je     801009ae <exec+0xa0>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010096c:	85 db                	test   %ebx,%ebx
8010096e:	0f 84 c5 02 00 00    	je     80100c39 <exec+0x32b>
    iunlockput(ip);
80100974:	83 ec 0c             	sub    $0xc,%esp
80100977:	53                   	push   %ebx
80100978:	e8 4a 0e 00 00       	call   801017c7 <iunlockput>
    end_op();
8010097d:	e8 84 1f 00 00       	call   80102906 <end_op>
80100982:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010098a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010098d:	5b                   	pop    %ebx
8010098e:	5e                   	pop    %esi
8010098f:	5f                   	pop    %edi
80100990:	5d                   	pop    %ebp
80100991:	c3                   	ret    
    end_op();
80100992:	e8 6f 1f 00 00       	call   80102906 <end_op>
    cprintf("exec: fail\n");
80100997:	83 ec 0c             	sub    $0xc,%esp
8010099a:	68 41 6c 10 80       	push   $0x80106c41
8010099f:	e8 a3 fc ff ff       	call   80100647 <cprintf>
    return -1;
801009a4:	83 c4 10             	add    $0x10,%esp
801009a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ac:	eb dc                	jmp    8010098a <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
801009ae:	e8 3a 5f 00 00       	call   801068ed <setupkvm>
801009b3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009b9:	85 c0                	test   %eax,%eax
801009bb:	0f 84 09 01 00 00    	je     80100aca <exec+0x1bc>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009c1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009c7:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009cc:	be 00 00 00 00       	mov    $0x0,%esi
801009d1:	eb 0c                	jmp    801009df <exec+0xd1>
801009d3:	83 c6 01             	add    $0x1,%esi
801009d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801009dc:	83 c0 20             	add    $0x20,%eax
801009df:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009e6:	39 f2                	cmp    %esi,%edx
801009e8:	0f 8e 98 00 00 00    	jle    80100a86 <exec+0x178>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009ee:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009f4:	6a 20                	push   $0x20
801009f6:	50                   	push   %eax
801009f7:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009fd:	50                   	push   %eax
801009fe:	53                   	push   %ebx
801009ff:	e8 17 0e 00 00       	call   8010181b <readi>
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	83 f8 20             	cmp    $0x20,%eax
80100a0a:	0f 85 ba 00 00 00    	jne    80100aca <exec+0x1bc>
    if(ph.type != ELF_PROG_LOAD)
80100a10:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a17:	75 ba                	jne    801009d3 <exec+0xc5>
    if(ph.memsz < ph.filesz)
80100a19:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a1f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a25:	0f 82 9f 00 00 00    	jb     80100aca <exec+0x1bc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a2b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a31:	0f 82 93 00 00 00    	jb     80100aca <exec+0x1bc>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a37:	83 ec 04             	sub    $0x4,%esp
80100a3a:	50                   	push   %eax
80100a3b:	57                   	push   %edi
80100a3c:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a42:	e8 4c 5d 00 00       	call   80106793 <allocuvm>
80100a47:	89 c7                	mov    %eax,%edi
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	85 c0                	test   %eax,%eax
80100a4e:	74 7a                	je     80100aca <exec+0x1bc>
    if(ph.vaddr % PGSIZE != 0)
80100a50:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a56:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a5b:	75 6d                	jne    80100aca <exec+0x1bc>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a5d:	83 ec 0c             	sub    $0xc,%esp
80100a60:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100a66:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100a6c:	53                   	push   %ebx
80100a6d:	50                   	push   %eax
80100a6e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a74:	e8 ed 5b 00 00       	call   80106666 <loaduvm>
80100a79:	83 c4 20             	add    $0x20,%esp
80100a7c:	85 c0                	test   %eax,%eax
80100a7e:	0f 89 4f ff ff ff    	jns    801009d3 <exec+0xc5>
80100a84:	eb 44                	jmp    80100aca <exec+0x1bc>
  iunlockput(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	53                   	push   %ebx
80100a8a:	e8 38 0d 00 00       	call   801017c7 <iunlockput>
  end_op();
80100a8f:	e8 72 1e 00 00       	call   80102906 <end_op>
  sz = PGROUNDUP(sz);
80100a94:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a9f:	83 c4 0c             	add    $0xc,%esp
80100aa2:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100aa8:	52                   	push   %edx
80100aa9:	50                   	push   %eax
80100aaa:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ab0:	57                   	push   %edi
80100ab1:	e8 dd 5c 00 00       	call   80106793 <allocuvm>
80100ab6:	89 c6                	mov    %eax,%esi
80100ab8:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100abe:	83 c4 10             	add    $0x10,%esp
80100ac1:	85 c0                	test   %eax,%eax
80100ac3:	75 24                	jne    80100ae9 <exec+0x1db>
  ip = 0;
80100ac5:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100aca:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ad0:	85 c0                	test   %eax,%eax
80100ad2:	0f 84 94 fe ff ff    	je     8010096c <exec+0x5e>
    freevm(pgdir);
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	50                   	push   %eax
80100adc:	e8 9c 5d 00 00       	call   8010687d <freevm>
80100ae1:	83 c4 10             	add    $0x10,%esp
80100ae4:	e9 83 fe ff ff       	jmp    8010096c <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ae9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	50                   	push   %eax
80100af3:	57                   	push   %edi
80100af4:	e8 79 5e 00 00       	call   80106972 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100af9:	83 c4 10             	add    $0x10,%esp
80100afc:	bf 00 00 00 00       	mov    $0x0,%edi
80100b01:	eb 0a                	jmp    80100b0d <exec+0x1ff>
    ustack[3+argc] = sp;
80100b03:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b0a:	83 c7 01             	add    $0x1,%edi
80100b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b10:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100b13:	8b 03                	mov    (%ebx),%eax
80100b15:	85 c0                	test   %eax,%eax
80100b17:	74 47                	je     80100b60 <exec+0x252>
    if(argc >= MAXARG)
80100b19:	83 ff 1f             	cmp    $0x1f,%edi
80100b1c:	0f 87 0d 01 00 00    	ja     80100c2f <exec+0x321>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b22:	83 ec 0c             	sub    $0xc,%esp
80100b25:	50                   	push   %eax
80100b26:	e8 9d 36 00 00       	call   801041c8 <strlen>
80100b2b:	29 c6                	sub    %eax,%esi
80100b2d:	83 ee 01             	sub    $0x1,%esi
80100b30:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b33:	83 c4 04             	add    $0x4,%esp
80100b36:	ff 33                	push   (%ebx)
80100b38:	e8 8b 36 00 00       	call   801041c8 <strlen>
80100b3d:	83 c0 01             	add    $0x1,%eax
80100b40:	50                   	push   %eax
80100b41:	ff 33                	push   (%ebx)
80100b43:	56                   	push   %esi
80100b44:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b4a:	e8 71 5f 00 00       	call   80106ac0 <copyout>
80100b4f:	83 c4 20             	add    $0x20,%esp
80100b52:	85 c0                	test   %eax,%eax
80100b54:	79 ad                	jns    80100b03 <exec+0x1f5>
  ip = 0;
80100b56:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b5b:	e9 6a ff ff ff       	jmp    80100aca <exec+0x1bc>
  ustack[3+argc] = 0;
80100b60:	89 f1                	mov    %esi,%ecx
80100b62:	89 c3                	mov    %eax,%ebx
80100b64:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b6b:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b6f:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b76:	ff ff ff 
  ustack[1] = argc;
80100b79:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b7f:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b86:	89 f0                	mov    %esi,%eax
80100b88:	29 d0                	sub    %edx,%eax
80100b8a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b90:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b97:	29 c1                	sub    %eax,%ecx
80100b99:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b9b:	50                   	push   %eax
80100b9c:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100ba2:	50                   	push   %eax
80100ba3:	51                   	push   %ecx
80100ba4:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100baa:	e8 11 5f 00 00       	call   80106ac0 <copyout>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	0f 88 10 ff ff ff    	js     80100aca <exec+0x1bc>
  for(last=s=path; *s; s++)
80100bba:	8b 55 08             	mov    0x8(%ebp),%edx
80100bbd:	89 d0                	mov    %edx,%eax
80100bbf:	eb 03                	jmp    80100bc4 <exec+0x2b6>
80100bc1:	83 c0 01             	add    $0x1,%eax
80100bc4:	0f b6 08             	movzbl (%eax),%ecx
80100bc7:	84 c9                	test   %cl,%cl
80100bc9:	74 0a                	je     80100bd5 <exec+0x2c7>
    if(*s == '/')
80100bcb:	80 f9 2f             	cmp    $0x2f,%cl
80100bce:	75 f1                	jne    80100bc1 <exec+0x2b3>
      last = s+1;
80100bd0:	8d 50 01             	lea    0x1(%eax),%edx
80100bd3:	eb ec                	jmp    80100bc1 <exec+0x2b3>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bd5:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bdb:	89 f8                	mov    %edi,%eax
80100bdd:	83 c0 6c             	add    $0x6c,%eax
80100be0:	83 ec 04             	sub    $0x4,%esp
80100be3:	6a 10                	push   $0x10
80100be5:	52                   	push   %edx
80100be6:	50                   	push   %eax
80100be7:	e8 9f 35 00 00       	call   8010418b <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bec:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bef:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bf5:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bf8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bfe:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100c00:	8b 47 18             	mov    0x18(%edi),%eax
80100c03:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c09:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c0c:	8b 47 18             	mov    0x18(%edi),%eax
80100c0f:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c12:	89 3c 24             	mov    %edi,(%esp)
80100c15:	e8 83 58 00 00       	call   8010649d <switchuvm>
  freevm(oldpgdir);
80100c1a:	89 1c 24             	mov    %ebx,(%esp)
80100c1d:	e8 5b 5c 00 00       	call   8010687d <freevm>
  return 0;
80100c22:	83 c4 10             	add    $0x10,%esp
80100c25:	b8 00 00 00 00       	mov    $0x0,%eax
80100c2a:	e9 5b fd ff ff       	jmp    8010098a <exec+0x7c>
  ip = 0;
80100c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c34:	e9 91 fe ff ff       	jmp    80100aca <exec+0x1bc>
  return -1;
80100c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3e:	e9 47 fd ff ff       	jmp    8010098a <exec+0x7c>

80100c43 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c43:	55                   	push   %ebp
80100c44:	89 e5                	mov    %esp,%ebp
80100c46:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c49:	68 4d 6c 10 80       	push   $0x80106c4d
80100c4e:	68 c0 f9 10 80       	push   $0x8010f9c0
80100c53:	e8 67 31 00 00       	call   80103dbf <initlock>
}
80100c58:	83 c4 10             	add    $0x10,%esp
80100c5b:	c9                   	leave  
80100c5c:	c3                   	ret    

80100c5d <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c5d:	55                   	push   %ebp
80100c5e:	89 e5                	mov    %esp,%ebp
80100c60:	53                   	push   %ebx
80100c61:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c64:	68 c0 f9 10 80       	push   $0x8010f9c0
80100c69:	e8 8d 32 00 00       	call   80103efb <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c6e:	83 c4 10             	add    $0x10,%esp
80100c71:	bb 44 fa 10 80       	mov    $0x8010fa44,%ebx
80100c76:	81 fb a4 03 11 80    	cmp    $0x801103a4,%ebx
80100c7c:	73 29                	jae    80100ca7 <filealloc+0x4a>
    if(f->ref == 0){
80100c7e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c82:	74 05                	je     80100c89 <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c84:	83 c3 18             	add    $0x18,%ebx
80100c87:	eb ed                	jmp    80100c76 <filealloc+0x19>
      f->ref = 1;
80100c89:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c90:	83 ec 0c             	sub    $0xc,%esp
80100c93:	68 c0 f9 10 80       	push   $0x8010f9c0
80100c98:	e8 c3 32 00 00       	call   80103f60 <release>
      return f;
80100c9d:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ca0:	89 d8                	mov    %ebx,%eax
80100ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ca5:	c9                   	leave  
80100ca6:	c3                   	ret    
  release(&ftable.lock);
80100ca7:	83 ec 0c             	sub    $0xc,%esp
80100caa:	68 c0 f9 10 80       	push   $0x8010f9c0
80100caf:	e8 ac 32 00 00       	call   80103f60 <release>
  return 0;
80100cb4:	83 c4 10             	add    $0x10,%esp
80100cb7:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cbc:	eb e2                	jmp    80100ca0 <filealloc+0x43>

80100cbe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cbe:	55                   	push   %ebp
80100cbf:	89 e5                	mov    %esp,%ebp
80100cc1:	53                   	push   %ebx
80100cc2:	83 ec 10             	sub    $0x10,%esp
80100cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cc8:	68 c0 f9 10 80       	push   $0x8010f9c0
80100ccd:	e8 29 32 00 00       	call   80103efb <acquire>
  if(f->ref < 1)
80100cd2:	8b 43 04             	mov    0x4(%ebx),%eax
80100cd5:	83 c4 10             	add    $0x10,%esp
80100cd8:	85 c0                	test   %eax,%eax
80100cda:	7e 1a                	jle    80100cf6 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100cdc:	83 c0 01             	add    $0x1,%eax
80100cdf:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce2:	83 ec 0c             	sub    $0xc,%esp
80100ce5:	68 c0 f9 10 80       	push   $0x8010f9c0
80100cea:	e8 71 32 00 00       	call   80103f60 <release>
  return f;
}
80100cef:	89 d8                	mov    %ebx,%eax
80100cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf4:	c9                   	leave  
80100cf5:	c3                   	ret    
    panic("filedup");
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	68 54 6c 10 80       	push   $0x80106c54
80100cfe:	e8 85 f6 ff ff       	call   80100388 <panic>

80100d03 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d03:	55                   	push   %ebp
80100d04:	89 e5                	mov    %esp,%ebp
80100d06:	53                   	push   %ebx
80100d07:	83 ec 30             	sub    $0x30,%esp
80100d0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d0d:	68 c0 f9 10 80       	push   $0x8010f9c0
80100d12:	e8 e4 31 00 00       	call   80103efb <acquire>
  if(f->ref < 1)
80100d17:	8b 43 04             	mov    0x4(%ebx),%eax
80100d1a:	83 c4 10             	add    $0x10,%esp
80100d1d:	85 c0                	test   %eax,%eax
80100d1f:	7e 71                	jle    80100d92 <fileclose+0x8f>
    panic("fileclose");
  if(--f->ref > 0){
80100d21:	83 e8 01             	sub    $0x1,%eax
80100d24:	89 43 04             	mov    %eax,0x4(%ebx)
80100d27:	85 c0                	test   %eax,%eax
80100d29:	7f 74                	jg     80100d9f <fileclose+0x9c>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d2b:	8b 03                	mov    (%ebx),%eax
80100d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d30:	8b 43 04             	mov    0x4(%ebx),%eax
80100d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100d36:	8b 43 08             	mov    0x8(%ebx),%eax
80100d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3c:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d42:	8b 43 10             	mov    0x10(%ebx),%eax
80100d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100d48:	8b 43 14             	mov    0x14(%ebx),%eax
80100d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80100d4e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d55:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d5b:	83 ec 0c             	sub    $0xc,%esp
80100d5e:	68 c0 f9 10 80       	push   $0x8010f9c0
80100d63:	e8 f8 31 00 00       	call   80103f60 <release>

  if(ff.type == FD_PIPE)
80100d68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6b:	83 c4 10             	add    $0x10,%esp
80100d6e:	83 f8 01             	cmp    $0x1,%eax
80100d71:	74 41                	je     80100db4 <fileclose+0xb1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d73:	83 f8 02             	cmp    $0x2,%eax
80100d76:	75 37                	jne    80100daf <fileclose+0xac>
    begin_op();
80100d78:	e8 0f 1b 00 00       	call   8010288c <begin_op>
    iput(ff.ip);
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	ff 75 f0             	push   -0x10(%ebp)
80100d83:	e8 90 09 00 00       	call   80101718 <iput>
    end_op();
80100d88:	e8 79 1b 00 00       	call   80102906 <end_op>
80100d8d:	83 c4 10             	add    $0x10,%esp
80100d90:	eb 1d                	jmp    80100daf <fileclose+0xac>
    panic("fileclose");
80100d92:	83 ec 0c             	sub    $0xc,%esp
80100d95:	68 5c 6c 10 80       	push   $0x80106c5c
80100d9a:	e8 e9 f5 ff ff       	call   80100388 <panic>
    release(&ftable.lock);
80100d9f:	83 ec 0c             	sub    $0xc,%esp
80100da2:	68 c0 f9 10 80       	push   $0x8010f9c0
80100da7:	e8 b4 31 00 00       	call   80103f60 <release>
    return;
80100dac:	83 c4 10             	add    $0x10,%esp
  }
}
80100daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db2:	c9                   	leave  
80100db3:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100db4:	83 ec 08             	sub    $0x8,%esp
80100db7:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100dbb:	50                   	push   %eax
80100dbc:	ff 75 ec             	push   -0x14(%ebp)
80100dbf:	e8 3b 21 00 00       	call   80102eff <pipeclose>
80100dc4:	83 c4 10             	add    $0x10,%esp
80100dc7:	eb e6                	jmp    80100daf <fileclose+0xac>

80100dc9 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc9:	55                   	push   %ebp
80100dca:	89 e5                	mov    %esp,%ebp
80100dcc:	53                   	push   %ebx
80100dcd:	83 ec 04             	sub    $0x4,%esp
80100dd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dd3:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd6:	75 31                	jne    80100e09 <filestat+0x40>
    ilock(f->ip);
80100dd8:	83 ec 0c             	sub    $0xc,%esp
80100ddb:	ff 73 10             	push   0x10(%ebx)
80100dde:	e8 10 08 00 00       	call   801015f3 <ilock>
    stati(f->ip, st);
80100de3:	83 c4 08             	add    $0x8,%esp
80100de6:	ff 75 0c             	push   0xc(%ebp)
80100de9:	ff 73 10             	push   0x10(%ebx)
80100dec:	e8 f6 09 00 00       	call   801017e7 <stati>
    iunlock(f->ip);
80100df1:	83 c4 04             	add    $0x4,%esp
80100df4:	ff 73 10             	push   0x10(%ebx)
80100df7:	e8 d7 08 00 00       	call   801016d3 <iunlock>
    return 0;
80100dfc:	83 c4 10             	add    $0x10,%esp
80100dff:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e07:	c9                   	leave  
80100e08:	c3                   	ret    
  return -1;
80100e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0e:	eb f4                	jmp    80100e04 <filestat+0x3b>

80100e10 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	56                   	push   %esi
80100e14:	53                   	push   %ebx
80100e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e18:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e1c:	74 70                	je     80100e8e <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e1e:	8b 03                	mov    (%ebx),%eax
80100e20:	83 f8 01             	cmp    $0x1,%eax
80100e23:	74 44                	je     80100e69 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e25:	83 f8 02             	cmp    $0x2,%eax
80100e28:	75 57                	jne    80100e81 <fileread+0x71>
    ilock(f->ip);
80100e2a:	83 ec 0c             	sub    $0xc,%esp
80100e2d:	ff 73 10             	push   0x10(%ebx)
80100e30:	e8 be 07 00 00       	call   801015f3 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e35:	ff 75 10             	push   0x10(%ebp)
80100e38:	ff 73 14             	push   0x14(%ebx)
80100e3b:	ff 75 0c             	push   0xc(%ebp)
80100e3e:	ff 73 10             	push   0x10(%ebx)
80100e41:	e8 d5 09 00 00       	call   8010181b <readi>
80100e46:	89 c6                	mov    %eax,%esi
80100e48:	83 c4 20             	add    $0x20,%esp
80100e4b:	85 c0                	test   %eax,%eax
80100e4d:	7e 03                	jle    80100e52 <fileread+0x42>
      f->off += r;
80100e4f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e52:	83 ec 0c             	sub    $0xc,%esp
80100e55:	ff 73 10             	push   0x10(%ebx)
80100e58:	e8 76 08 00 00       	call   801016d3 <iunlock>
    return r;
80100e5d:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e60:	89 f0                	mov    %esi,%eax
80100e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e65:	5b                   	pop    %ebx
80100e66:	5e                   	pop    %esi
80100e67:	5d                   	pop    %ebp
80100e68:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e69:	83 ec 04             	sub    $0x4,%esp
80100e6c:	ff 75 10             	push   0x10(%ebp)
80100e6f:	ff 75 0c             	push   0xc(%ebp)
80100e72:	ff 73 0c             	push   0xc(%ebx)
80100e75:	e8 d9 21 00 00       	call   80103053 <piperead>
80100e7a:	89 c6                	mov    %eax,%esi
80100e7c:	83 c4 10             	add    $0x10,%esp
80100e7f:	eb df                	jmp    80100e60 <fileread+0x50>
  panic("fileread");
80100e81:	83 ec 0c             	sub    $0xc,%esp
80100e84:	68 66 6c 10 80       	push   $0x80106c66
80100e89:	e8 fa f4 ff ff       	call   80100388 <panic>
    return -1;
80100e8e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e93:	eb cb                	jmp    80100e60 <fileread+0x50>

80100e95 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e95:	55                   	push   %ebp
80100e96:	89 e5                	mov    %esp,%ebp
80100e98:	57                   	push   %edi
80100e99:	56                   	push   %esi
80100e9a:	53                   	push   %ebx
80100e9b:	83 ec 1c             	sub    $0x1c,%esp
80100e9e:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ea1:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100ea5:	0f 84 d0 00 00 00    	je     80100f7b <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100eab:	8b 06                	mov    (%esi),%eax
80100ead:	83 f8 01             	cmp    $0x1,%eax
80100eb0:	74 12                	je     80100ec4 <filewrite+0x2f>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eb2:	83 f8 02             	cmp    $0x2,%eax
80100eb5:	0f 85 b3 00 00 00    	jne    80100f6e <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100ebb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ec2:	eb 66                	jmp    80100f2a <filewrite+0x95>
    return pipewrite(f->pipe, addr, n);
80100ec4:	83 ec 04             	sub    $0x4,%esp
80100ec7:	ff 75 10             	push   0x10(%ebp)
80100eca:	ff 75 0c             	push   0xc(%ebp)
80100ecd:	ff 76 0c             	push   0xc(%esi)
80100ed0:	e8 b6 20 00 00       	call   80102f8b <pipewrite>
80100ed5:	83 c4 10             	add    $0x10,%esp
80100ed8:	e9 84 00 00 00       	jmp    80100f61 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100edd:	e8 aa 19 00 00       	call   8010288c <begin_op>
      ilock(f->ip);
80100ee2:	83 ec 0c             	sub    $0xc,%esp
80100ee5:	ff 76 10             	push   0x10(%esi)
80100ee8:	e8 06 07 00 00       	call   801015f3 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100eed:	57                   	push   %edi
80100eee:	ff 76 14             	push   0x14(%esi)
80100ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef4:	03 45 0c             	add    0xc(%ebp),%eax
80100ef7:	50                   	push   %eax
80100ef8:	ff 76 10             	push   0x10(%esi)
80100efb:	e8 24 0a 00 00       	call   80101924 <writei>
80100f00:	89 c3                	mov    %eax,%ebx
80100f02:	83 c4 20             	add    $0x20,%esp
80100f05:	85 c0                	test   %eax,%eax
80100f07:	7e 03                	jle    80100f0c <filewrite+0x77>
        f->off += r;
80100f09:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	ff 76 10             	push   0x10(%esi)
80100f12:	e8 bc 07 00 00       	call   801016d3 <iunlock>
      end_op();
80100f17:	e8 ea 19 00 00       	call   80102906 <end_op>

      if(r < 0)
80100f1c:	83 c4 10             	add    $0x10,%esp
80100f1f:	85 db                	test   %ebx,%ebx
80100f21:	78 31                	js     80100f54 <filewrite+0xbf>
        break;
      if(r != n1)
80100f23:	39 df                	cmp    %ebx,%edi
80100f25:	75 20                	jne    80100f47 <filewrite+0xb2>
        panic("short filewrite");
      i += r;
80100f27:	01 5d e4             	add    %ebx,-0x1c(%ebp)
    while(i < n){
80100f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2d:	3b 45 10             	cmp    0x10(%ebp),%eax
80100f30:	7d 22                	jge    80100f54 <filewrite+0xbf>
      int n1 = n - i;
80100f32:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f35:	2b 7d e4             	sub    -0x1c(%ebp),%edi
      if(n1 > max)
80100f38:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80100f3e:	7e 9d                	jle    80100edd <filewrite+0x48>
        n1 = max;
80100f40:	bf 00 06 00 00       	mov    $0x600,%edi
80100f45:	eb 96                	jmp    80100edd <filewrite+0x48>
        panic("short filewrite");
80100f47:	83 ec 0c             	sub    $0xc,%esp
80100f4a:	68 6f 6c 10 80       	push   $0x80106c6f
80100f4f:	e8 34 f4 ff ff       	call   80100388 <panic>
    }
    return i == n ? n : -1;
80100f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f57:	3b 45 10             	cmp    0x10(%ebp),%eax
80100f5a:	74 0d                	je     80100f69 <filewrite+0xd4>
80100f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f64:	5b                   	pop    %ebx
80100f65:	5e                   	pop    %esi
80100f66:	5f                   	pop    %edi
80100f67:	5d                   	pop    %ebp
80100f68:	c3                   	ret    
    return i == n ? n : -1;
80100f69:	8b 45 10             	mov    0x10(%ebp),%eax
80100f6c:	eb f3                	jmp    80100f61 <filewrite+0xcc>
  panic("filewrite");
80100f6e:	83 ec 0c             	sub    $0xc,%esp
80100f71:	68 75 6c 10 80       	push   $0x80106c75
80100f76:	e8 0d f4 ff ff       	call   80100388 <panic>
    return -1;
80100f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f80:	eb df                	jmp    80100f61 <filewrite+0xcc>

80100f82 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f82:	55                   	push   %ebp
80100f83:	89 e5                	mov    %esp,%ebp
80100f85:	57                   	push   %edi
80100f86:	56                   	push   %esi
80100f87:	53                   	push   %ebx
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f8d:	eb 03                	jmp    80100f92 <skipelem+0x10>
    path++;
80100f8f:	83 c0 01             	add    $0x1,%eax
  while(*path == '/')
80100f92:	0f b6 10             	movzbl (%eax),%edx
80100f95:	80 fa 2f             	cmp    $0x2f,%dl
80100f98:	74 f5                	je     80100f8f <skipelem+0xd>
  if(*path == 0)
80100f9a:	84 d2                	test   %dl,%dl
80100f9c:	74 53                	je     80100ff1 <skipelem+0x6f>
80100f9e:	89 c3                	mov    %eax,%ebx
80100fa0:	eb 03                	jmp    80100fa5 <skipelem+0x23>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100fa2:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80100fa5:	0f b6 13             	movzbl (%ebx),%edx
80100fa8:	80 fa 2f             	cmp    $0x2f,%dl
80100fab:	74 04                	je     80100fb1 <skipelem+0x2f>
80100fad:	84 d2                	test   %dl,%dl
80100faf:	75 f1                	jne    80100fa2 <skipelem+0x20>
  len = path - s;
80100fb1:	89 df                	mov    %ebx,%edi
80100fb3:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100fb5:	83 ff 0d             	cmp    $0xd,%edi
80100fb8:	7e 11                	jle    80100fcb <skipelem+0x49>
    memmove(name, s, DIRSIZ);
80100fba:	83 ec 04             	sub    $0x4,%esp
80100fbd:	6a 0e                	push   $0xe
80100fbf:	50                   	push   %eax
80100fc0:	56                   	push   %esi
80100fc1:	e8 d1 30 00 00       	call   80104097 <memmove>
80100fc6:	83 c4 10             	add    $0x10,%esp
80100fc9:	eb 17                	jmp    80100fe2 <skipelem+0x60>
  else {
    memmove(name, s, len);
80100fcb:	83 ec 04             	sub    $0x4,%esp
80100fce:	57                   	push   %edi
80100fcf:	50                   	push   %eax
80100fd0:	56                   	push   %esi
80100fd1:	e8 c1 30 00 00       	call   80104097 <memmove>
    name[len] = 0;
80100fd6:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fda:	83 c4 10             	add    $0x10,%esp
80100fdd:	eb 03                	jmp    80100fe2 <skipelem+0x60>
  }
  while(*path == '/')
    path++;
80100fdf:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fe2:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fe5:	74 f8                	je     80100fdf <skipelem+0x5d>
  return path;
}
80100fe7:	89 d8                	mov    %ebx,%eax
80100fe9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fec:	5b                   	pop    %ebx
80100fed:	5e                   	pop    %esi
80100fee:	5f                   	pop    %edi
80100fef:	5d                   	pop    %ebp
80100ff0:	c3                   	ret    
    return 0;
80100ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ff6:	eb ef                	jmp    80100fe7 <skipelem+0x65>

80100ff8 <bzero>:
{
80100ff8:	55                   	push   %ebp
80100ff9:	89 e5                	mov    %esp,%ebp
80100ffb:	53                   	push   %ebx
80100ffc:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fff:	52                   	push   %edx
80101000:	50                   	push   %eax
80101001:	e8 81 f1 ff ff       	call   80100187 <bread>
80101006:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101008:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
8010100e:	83 c4 0c             	add    $0xc,%esp
80101011:	68 00 02 00 00       	push   $0x200
80101016:	6a 00                	push   $0x0
80101018:	50                   	push   %eax
80101019:	e8 01 30 00 00       	call   8010401f <memset>
  log_write(bp);
8010101e:	89 1c 24             	mov    %ebx,(%esp)
80101021:	e8 8f 19 00 00       	call   801029b5 <log_write>
  brelse(bp);
80101026:	89 1c 24             	mov    %ebx,(%esp)
80101029:	e8 c2 f1 ff ff       	call   801001f0 <brelse>
}
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101034:	c9                   	leave  
80101035:	c3                   	ret    

80101036 <bfree>:
{
80101036:	55                   	push   %ebp
80101037:	89 e5                	mov    %esp,%ebp
80101039:	56                   	push   %esi
8010103a:	53                   	push   %ebx
8010103b:	89 c3                	mov    %eax,%ebx
8010103d:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
8010103f:	89 d0                	mov    %edx,%eax
80101041:	c1 e8 0c             	shr    $0xc,%eax
80101044:	83 ec 08             	sub    $0x8,%esp
80101047:	03 05 7c 30 11 80    	add    0x8011307c,%eax
8010104d:	50                   	push   %eax
8010104e:	53                   	push   %ebx
8010104f:	e8 33 f1 ff ff       	call   80100187 <bread>
80101054:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101056:	89 f2                	mov    %esi,%edx
80101058:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
8010105e:	89 f1                	mov    %esi,%ecx
80101060:	83 e1 07             	and    $0x7,%ecx
80101063:	b8 01 00 00 00       	mov    $0x1,%eax
80101068:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
8010106a:	83 c4 10             	add    $0x10,%esp
8010106d:	c1 fa 03             	sar    $0x3,%edx
80101070:	0f b6 8c 13 ac 00 00 	movzbl 0xac(%ebx,%edx,1),%ecx
80101077:	00 
80101078:	0f b6 f1             	movzbl %cl,%esi
8010107b:	85 c6                	test   %eax,%esi
8010107d:	74 26                	je     801010a5 <bfree+0x6f>
  bp->data[bi/8] &= ~m;
8010107f:	f7 d0                	not    %eax
80101081:	21 c8                	and    %ecx,%eax
80101083:	88 84 13 ac 00 00 00 	mov    %al,0xac(%ebx,%edx,1)
  log_write(bp);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	53                   	push   %ebx
8010108e:	e8 22 19 00 00       	call   801029b5 <log_write>
  brelse(bp);
80101093:	89 1c 24             	mov    %ebx,(%esp)
80101096:	e8 55 f1 ff ff       	call   801001f0 <brelse>
}
8010109b:	83 c4 10             	add    $0x10,%esp
8010109e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5d                   	pop    %ebp
801010a4:	c3                   	ret    
    panic("freeing free block");
801010a5:	83 ec 0c             	sub    $0xc,%esp
801010a8:	68 7f 6c 10 80       	push   $0x80106c7f
801010ad:	e8 d6 f2 ff ff       	call   80100388 <panic>

801010b2 <balloc>:
{
801010b2:	55                   	push   %ebp
801010b3:	89 e5                	mov    %esp,%ebp
801010b5:	57                   	push   %edi
801010b6:	56                   	push   %esi
801010b7:	53                   	push   %ebx
801010b8:	83 ec 1c             	sub    $0x1c,%esp
801010bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801010c5:	eb 15                	jmp    801010dc <balloc+0x2a>
    brelse(bp);
801010c7:	83 ec 0c             	sub    $0xc,%esp
801010ca:	ff 75 e0             	push   -0x20(%ebp)
801010cd:	e8 1e f1 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010d2:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
801010d9:	83 c4 10             	add    $0x10,%esp
801010dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010df:	39 05 64 30 11 80    	cmp    %eax,0x80113064
801010e5:	76 78                	jbe    8010115f <balloc+0xad>
    bp = bread(dev, BBLOCK(b, sb));
801010e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010ea:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
801010f0:	85 db                	test   %ebx,%ebx
801010f2:	0f 49 c3             	cmovns %ebx,%eax
801010f5:	c1 f8 0c             	sar    $0xc,%eax
801010f8:	83 ec 08             	sub    $0x8,%esp
801010fb:	03 05 7c 30 11 80    	add    0x8011307c,%eax
80101101:	50                   	push   %eax
80101102:	ff 75 d8             	push   -0x28(%ebp)
80101105:	e8 7d f0 ff ff       	call   80100187 <bread>
8010110a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010110d:	83 c4 10             	add    $0x10,%esp
80101110:	b8 00 00 00 00       	mov    $0x0,%eax
80101115:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010111a:	7f ab                	jg     801010c7 <balloc+0x15>
8010111c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010111f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80101122:	3b 1d 64 30 11 80    	cmp    0x80113064,%ebx
80101128:	73 9d                	jae    801010c7 <balloc+0x15>
      m = 1 << (bi % 8);
8010112a:	89 c1                	mov    %eax,%ecx
8010112c:	83 e1 07             	and    $0x7,%ecx
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	d3 e2                	shl    %cl,%edx
80101136:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101138:	8d 50 07             	lea    0x7(%eax),%edx
8010113b:	85 c0                	test   %eax,%eax
8010113d:	0f 49 d0             	cmovns %eax,%edx
80101140:	c1 fa 03             	sar    $0x3,%edx
80101143:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101146:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101149:	0f b6 b4 16 ac 00 00 	movzbl 0xac(%esi,%edx,1),%esi
80101150:	00 
80101151:	89 f2                	mov    %esi,%edx
80101153:	0f b6 fa             	movzbl %dl,%edi
80101156:	85 cf                	test   %ecx,%edi
80101158:	74 12                	je     8010116c <balloc+0xba>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010115a:	83 c0 01             	add    $0x1,%eax
8010115d:	eb b6                	jmp    80101115 <balloc+0x63>
  panic("balloc: out of blocks");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 92 6c 10 80       	push   $0x80106c92
80101167:	e8 1c f2 ff ff       	call   80100388 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
8010116c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010116f:	09 f1                	or     %esi,%ecx
80101171:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101174:	88 8c 17 ac 00 00 00 	mov    %cl,0xac(%edi,%edx,1)
        log_write(bp);
8010117b:	83 ec 0c             	sub    $0xc,%esp
8010117e:	57                   	push   %edi
8010117f:	e8 31 18 00 00       	call   801029b5 <log_write>
        brelse(bp);
80101184:	89 3c 24             	mov    %edi,(%esp)
80101187:	e8 64 f0 ff ff       	call   801001f0 <brelse>
        bzero(dev, b + bi);
8010118c:	89 da                	mov    %ebx,%edx
8010118e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101191:	e8 62 fe ff ff       	call   80100ff8 <bzero>
}
80101196:	89 d8                	mov    %ebx,%eax
80101198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119b:	5b                   	pop    %ebx
8010119c:	5e                   	pop    %esi
8010119d:	5f                   	pop    %edi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    

801011a0 <bmap>:
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
801011a9:	89 c3                	mov    %eax,%ebx
801011ab:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801011ad:	83 fa 0b             	cmp    $0xb,%edx
801011b0:	76 4c                	jbe    801011fe <bmap+0x5e>
  bn -= NDIRECT;
801011b2:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801011b5:	83 fe 7f             	cmp    $0x7f,%esi
801011b8:	0f 87 88 00 00 00    	ja     80101246 <bmap+0xa6>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011be:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801011c4:	85 c0                	test   %eax,%eax
801011c6:	74 53                	je     8010121b <bmap+0x7b>
    bp = bread(ip->dev, addr);
801011c8:	83 ec 08             	sub    $0x8,%esp
801011cb:	50                   	push   %eax
801011cc:	ff 33                	push   (%ebx)
801011ce:	e8 b4 ef ff ff       	call   80100187 <bread>
801011d3:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011d5:	8d 84 b0 ac 00 00 00 	lea    0xac(%eax,%esi,4),%eax
801011dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011df:	8b 30                	mov    (%eax),%esi
801011e1:	83 c4 10             	add    $0x10,%esp
801011e4:	85 f6                	test   %esi,%esi
801011e6:	74 42                	je     8010122a <bmap+0x8a>
    brelse(bp);
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	57                   	push   %edi
801011ec:	e8 ff ef ff ff       	call   801001f0 <brelse>
    return addr;
801011f1:	83 c4 10             	add    $0x10,%esp
}
801011f4:	89 f0                	mov    %esi,%eax
801011f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f9:	5b                   	pop    %ebx
801011fa:	5e                   	pop    %esi
801011fb:	5f                   	pop    %edi
801011fc:	5d                   	pop    %ebp
801011fd:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011fe:	8b b4 90 ac 00 00 00 	mov    0xac(%eax,%edx,4),%esi
80101205:	85 f6                	test   %esi,%esi
80101207:	75 eb                	jne    801011f4 <bmap+0x54>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101209:	8b 00                	mov    (%eax),%eax
8010120b:	e8 a2 fe ff ff       	call   801010b2 <balloc>
80101210:	89 c6                	mov    %eax,%esi
80101212:	89 84 bb ac 00 00 00 	mov    %eax,0xac(%ebx,%edi,4)
    return addr;
80101219:	eb d9                	jmp    801011f4 <bmap+0x54>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010121b:	8b 03                	mov    (%ebx),%eax
8010121d:	e8 90 fe ff ff       	call   801010b2 <balloc>
80101222:	89 83 dc 00 00 00    	mov    %eax,0xdc(%ebx)
80101228:	eb 9e                	jmp    801011c8 <bmap+0x28>
      a[bn] = addr = balloc(ip->dev);
8010122a:	8b 03                	mov    (%ebx),%eax
8010122c:	e8 81 fe ff ff       	call   801010b2 <balloc>
80101231:	89 c6                	mov    %eax,%esi
80101233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101236:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101238:	83 ec 0c             	sub    $0xc,%esp
8010123b:	57                   	push   %edi
8010123c:	e8 74 17 00 00       	call   801029b5 <log_write>
80101241:	83 c4 10             	add    $0x10,%esp
80101244:	eb a2                	jmp    801011e8 <bmap+0x48>
  panic("bmap: out of range");
80101246:	83 ec 0c             	sub    $0xc,%esp
80101249:	68 a8 6c 10 80       	push   $0x80106ca8
8010124e:	e8 35 f1 ff ff       	call   80100388 <panic>

80101253 <iget>:
{
80101253:	55                   	push   %ebp
80101254:	89 e5                	mov    %esp,%ebp
80101256:	57                   	push   %edi
80101257:	56                   	push   %esi
80101258:	53                   	push   %ebx
80101259:	83 ec 28             	sub    $0x28,%esp
8010125c:	89 c7                	mov    %eax,%edi
8010125e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101261:	68 20 04 11 80       	push   $0x80110420
80101266:	e8 90 2c 00 00       	call   80103efb <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126b:	83 c4 10             	add    $0x10,%esp
  empty = 0;
8010126e:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101273:	bb a4 04 11 80       	mov    $0x801104a4,%ebx
80101278:	eb 0a                	jmp    80101284 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010127a:	85 f6                	test   %esi,%esi
8010127c:	74 3b                	je     801012b9 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127e:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80101284:	81 fb 64 30 11 80    	cmp    $0x80113064,%ebx
8010128a:	73 35                	jae    801012c1 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010128c:	8b 43 08             	mov    0x8(%ebx),%eax
8010128f:	85 c0                	test   %eax,%eax
80101291:	7e e7                	jle    8010127a <iget+0x27>
80101293:	39 3b                	cmp    %edi,(%ebx)
80101295:	75 e3                	jne    8010127a <iget+0x27>
80101297:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010129a:	39 4b 04             	cmp    %ecx,0x4(%ebx)
8010129d:	75 db                	jne    8010127a <iget+0x27>
      ip->ref++;
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801012a5:	83 ec 0c             	sub    $0xc,%esp
801012a8:	68 20 04 11 80       	push   $0x80110420
801012ad:	e8 ae 2c 00 00       	call   80103f60 <release>
      return ip;
801012b2:	83 c4 10             	add    $0x10,%esp
801012b5:	89 de                	mov    %ebx,%esi
801012b7:	eb 35                	jmp    801012ee <iget+0x9b>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b9:	85 c0                	test   %eax,%eax
801012bb:	75 c1                	jne    8010127e <iget+0x2b>
      empty = ip;
801012bd:	89 de                	mov    %ebx,%esi
801012bf:	eb bd                	jmp    8010127e <iget+0x2b>
  if(empty == 0)
801012c1:	85 f6                	test   %esi,%esi
801012c3:	74 33                	je     801012f8 <iget+0xa5>
  ip->dev = dev;
801012c5:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012ca:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012cd:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d4:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
801012db:	00 00 00 
  release(&icache.lock);
801012de:	83 ec 0c             	sub    $0xc,%esp
801012e1:	68 20 04 11 80       	push   $0x80110420
801012e6:	e8 75 2c 00 00       	call   80103f60 <release>
  return ip;
801012eb:	83 c4 10             	add    $0x10,%esp
}
801012ee:	89 f0                	mov    %esi,%eax
801012f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f3:	5b                   	pop    %ebx
801012f4:	5e                   	pop    %esi
801012f5:	5f                   	pop    %edi
801012f6:	5d                   	pop    %ebp
801012f7:	c3                   	ret    
    panic("iget: no inodes");
801012f8:	83 ec 0c             	sub    $0xc,%esp
801012fb:	68 bb 6c 10 80       	push   $0x80106cbb
80101300:	e8 83 f0 ff ff       	call   80100388 <panic>

80101305 <readsb>:
{
80101305:	55                   	push   %ebp
80101306:	89 e5                	mov    %esp,%ebp
80101308:	53                   	push   %ebx
80101309:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010130c:	6a 01                	push   $0x1
8010130e:	ff 75 08             	push   0x8(%ebp)
80101311:	e8 71 ee ff ff       	call   80100187 <bread>
80101316:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101318:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
8010131e:	83 c4 0c             	add    $0xc,%esp
80101321:	6a 1c                	push   $0x1c
80101323:	50                   	push   %eax
80101324:	ff 75 0c             	push   0xc(%ebp)
80101327:	e8 6b 2d 00 00       	call   80104097 <memmove>
  brelse(bp);
8010132c:	89 1c 24             	mov    %ebx,(%esp)
8010132f:	e8 bc ee ff ff       	call   801001f0 <brelse>
}
80101334:	83 c4 10             	add    $0x10,%esp
80101337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133a:	c9                   	leave  
8010133b:	c3                   	ret    

8010133c <iinit>:
{
8010133c:	55                   	push   %ebp
8010133d:	89 e5                	mov    %esp,%ebp
8010133f:	53                   	push   %ebx
80101340:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101343:	68 cb 6c 10 80       	push   $0x80106ccb
80101348:	68 20 04 11 80       	push   $0x80110420
8010134d:	e8 6d 2a 00 00       	call   80103dbf <initlock>
  for(i = 0; i < NINODE; i++) {
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	bb 00 00 00 00       	mov    $0x0,%ebx
8010135a:	eb 1f                	jmp    8010137b <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010135c:	83 ec 08             	sub    $0x8,%esp
8010135f:	68 d2 6c 10 80       	push   $0x80106cd2
80101364:	69 c3 e0 00 00 00    	imul   $0xe0,%ebx,%eax
8010136a:	05 b0 04 11 80       	add    $0x801104b0,%eax
8010136f:	50                   	push   %eax
80101370:	e8 30 29 00 00       	call   80103ca5 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101375:	83 c3 01             	add    $0x1,%ebx
80101378:	83 c4 10             	add    $0x10,%esp
8010137b:	83 fb 31             	cmp    $0x31,%ebx
8010137e:	7e dc                	jle    8010135c <iinit+0x20>
  readsb(dev, &sb);
80101380:	83 ec 08             	sub    $0x8,%esp
80101383:	68 64 30 11 80       	push   $0x80113064
80101388:	ff 75 08             	push   0x8(%ebp)
8010138b:	e8 75 ff ff ff       	call   80101305 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101390:	ff 35 7c 30 11 80    	push   0x8011307c
80101396:	ff 35 78 30 11 80    	push   0x80113078
8010139c:	ff 35 74 30 11 80    	push   0x80113074
801013a2:	ff 35 70 30 11 80    	push   0x80113070
801013a8:	ff 35 6c 30 11 80    	push   0x8011306c
801013ae:	ff 35 68 30 11 80    	push   0x80113068
801013b4:	ff 35 64 30 11 80    	push   0x80113064
801013ba:	68 38 6d 10 80       	push   $0x80106d38
801013bf:	e8 83 f2 ff ff       	call   80100647 <cprintf>
}
801013c4:	83 c4 30             	add    $0x30,%esp
801013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013ca:	c9                   	leave  
801013cb:	c3                   	ret    

801013cc <ialloc>:
{
801013cc:	55                   	push   %ebp
801013cd:	89 e5                	mov    %esp,%ebp
801013cf:	57                   	push   %edi
801013d0:	56                   	push   %esi
801013d1:	53                   	push   %ebx
801013d2:	83 ec 1c             	sub    $0x1c,%esp
801013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801013d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013db:	bb 01 00 00 00       	mov    $0x1,%ebx
801013e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013e3:	39 1d 6c 30 11 80    	cmp    %ebx,0x8011306c
801013e9:	76 42                	jbe    8010142d <ialloc+0x61>
    bp = bread(dev, IBLOCK(inum, sb));
801013eb:	89 d8                	mov    %ebx,%eax
801013ed:	c1 e8 03             	shr    $0x3,%eax
801013f0:	83 ec 08             	sub    $0x8,%esp
801013f3:	03 05 78 30 11 80    	add    0x80113078,%eax
801013f9:	50                   	push   %eax
801013fa:	ff 75 08             	push   0x8(%ebp)
801013fd:	e8 85 ed ff ff       	call   80100187 <bread>
80101402:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101404:	89 d8                	mov    %ebx,%eax
80101406:	83 e0 07             	and    $0x7,%eax
80101409:	c1 e0 06             	shl    $0x6,%eax
8010140c:	8d bc 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101413:	83 c4 10             	add    $0x10,%esp
80101416:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010141a:	74 1e                	je     8010143a <ialloc+0x6e>
    brelse(bp);
8010141c:	83 ec 0c             	sub    $0xc,%esp
8010141f:	56                   	push   %esi
80101420:	e8 cb ed ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101425:	83 c3 01             	add    $0x1,%ebx
80101428:	83 c4 10             	add    $0x10,%esp
8010142b:	eb b3                	jmp    801013e0 <ialloc+0x14>
  panic("ialloc: no inodes");
8010142d:	83 ec 0c             	sub    $0xc,%esp
80101430:	68 d8 6c 10 80       	push   $0x80106cd8
80101435:	e8 4e ef ff ff       	call   80100388 <panic>
      memset(dip, 0, sizeof(*dip));
8010143a:	83 ec 04             	sub    $0x4,%esp
8010143d:	6a 40                	push   $0x40
8010143f:	6a 00                	push   $0x0
80101441:	57                   	push   %edi
80101442:	e8 d8 2b 00 00       	call   8010401f <memset>
      dip->type = type;
80101447:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010144b:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010144e:	89 34 24             	mov    %esi,(%esp)
80101451:	e8 5f 15 00 00       	call   801029b5 <log_write>
      brelse(bp);
80101456:	89 34 24             	mov    %esi,(%esp)
80101459:	e8 92 ed ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010145e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101461:	8b 45 08             	mov    0x8(%ebp),%eax
80101464:	e8 ea fd ff ff       	call   80101253 <iget>
}
80101469:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146c:	5b                   	pop    %ebx
8010146d:	5e                   	pop    %esi
8010146e:	5f                   	pop    %edi
8010146f:	5d                   	pop    %ebp
80101470:	c3                   	ret    

80101471 <iupdate>:
{
80101471:	55                   	push   %ebp
80101472:	89 e5                	mov    %esp,%ebp
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101479:	8b 43 04             	mov    0x4(%ebx),%eax
8010147c:	c1 e8 03             	shr    $0x3,%eax
8010147f:	83 ec 08             	sub    $0x8,%esp
80101482:	03 05 78 30 11 80    	add    0x80113078,%eax
80101488:	50                   	push   %eax
80101489:	ff 33                	push   (%ebx)
8010148b:	e8 f7 ec ff ff       	call   80100187 <bread>
80101490:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101492:	8b 43 04             	mov    0x4(%ebx),%eax
80101495:	83 e0 07             	and    $0x7,%eax
80101498:	c1 e0 06             	shl    $0x6,%eax
8010149b:	8d 84 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%eax
  dip->type = ip->type;
801014a2:	0f b7 93 a0 00 00 00 	movzwl 0xa0(%ebx),%edx
801014a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014ac:	0f b7 93 a2 00 00 00 	movzwl 0xa2(%ebx),%edx
801014b3:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014b7:	0f b7 93 a4 00 00 00 	movzwl 0xa4(%ebx),%edx
801014be:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014c2:	0f b7 93 a6 00 00 00 	movzwl 0xa6(%ebx),%edx
801014c9:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014cd:	8b 93 a8 00 00 00    	mov    0xa8(%ebx),%edx
801014d3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014d6:	81 c3 ac 00 00 00    	add    $0xac,%ebx
801014dc:	83 c0 0c             	add    $0xc,%eax
801014df:	83 c4 0c             	add    $0xc,%esp
801014e2:	6a 34                	push   $0x34
801014e4:	53                   	push   %ebx
801014e5:	50                   	push   %eax
801014e6:	e8 ac 2b 00 00       	call   80104097 <memmove>
  log_write(bp);
801014eb:	89 34 24             	mov    %esi,(%esp)
801014ee:	e8 c2 14 00 00       	call   801029b5 <log_write>
  brelse(bp);
801014f3:	89 34 24             	mov    %esi,(%esp)
801014f6:	e8 f5 ec ff ff       	call   801001f0 <brelse>
}
801014fb:	83 c4 10             	add    $0x10,%esp
801014fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101501:	5b                   	pop    %ebx
80101502:	5e                   	pop    %esi
80101503:	5d                   	pop    %ebp
80101504:	c3                   	ret    

80101505 <itrunc>:
{
80101505:	55                   	push   %ebp
80101506:	89 e5                	mov    %esp,%ebp
80101508:	57                   	push   %edi
80101509:	56                   	push   %esi
8010150a:	53                   	push   %ebx
8010150b:	83 ec 1c             	sub    $0x1c,%esp
8010150e:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101510:	bb 00 00 00 00       	mov    $0x0,%ebx
80101515:	eb 03                	jmp    8010151a <itrunc+0x15>
80101517:	83 c3 01             	add    $0x1,%ebx
8010151a:	83 fb 0b             	cmp    $0xb,%ebx
8010151d:	7f 1f                	jg     8010153e <itrunc+0x39>
    if(ip->addrs[i]){
8010151f:	8b 94 9e ac 00 00 00 	mov    0xac(%esi,%ebx,4),%edx
80101526:	85 d2                	test   %edx,%edx
80101528:	74 ed                	je     80101517 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
8010152a:	8b 06                	mov    (%esi),%eax
8010152c:	e8 05 fb ff ff       	call   80101036 <bfree>
      ip->addrs[i] = 0;
80101531:	c7 84 9e ac 00 00 00 	movl   $0x0,0xac(%esi,%ebx,4)
80101538:	00 00 00 00 
8010153c:	eb d9                	jmp    80101517 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
8010153e:	8b 86 dc 00 00 00    	mov    0xdc(%esi),%eax
80101544:	85 c0                	test   %eax,%eax
80101546:	75 1e                	jne    80101566 <itrunc+0x61>
  ip->size = 0;
80101548:	c7 86 a8 00 00 00 00 	movl   $0x0,0xa8(%esi)
8010154f:	00 00 00 
  iupdate(ip);
80101552:	83 ec 0c             	sub    $0xc,%esp
80101555:	56                   	push   %esi
80101556:	e8 16 ff ff ff       	call   80101471 <iupdate>
}
8010155b:	83 c4 10             	add    $0x10,%esp
8010155e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101561:	5b                   	pop    %ebx
80101562:	5e                   	pop    %esi
80101563:	5f                   	pop    %edi
80101564:	5d                   	pop    %ebp
80101565:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101566:	83 ec 08             	sub    $0x8,%esp
80101569:	50                   	push   %eax
8010156a:	ff 36                	push   (%esi)
8010156c:	e8 16 ec ff ff       	call   80100187 <bread>
80101571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101574:	8d b8 ac 00 00 00    	lea    0xac(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010157a:	83 c4 10             	add    $0x10,%esp
8010157d:	bb 00 00 00 00       	mov    $0x0,%ebx
80101582:	eb 03                	jmp    80101587 <itrunc+0x82>
80101584:	83 c3 01             	add    $0x1,%ebx
80101587:	83 fb 7f             	cmp    $0x7f,%ebx
8010158a:	77 10                	ja     8010159c <itrunc+0x97>
      if(a[j])
8010158c:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
8010158f:	85 d2                	test   %edx,%edx
80101591:	74 f1                	je     80101584 <itrunc+0x7f>
        bfree(ip->dev, a[j]);
80101593:	8b 06                	mov    (%esi),%eax
80101595:	e8 9c fa ff ff       	call   80101036 <bfree>
8010159a:	eb e8                	jmp    80101584 <itrunc+0x7f>
    brelse(bp);
8010159c:	83 ec 0c             	sub    $0xc,%esp
8010159f:	ff 75 e4             	push   -0x1c(%ebp)
801015a2:	e8 49 ec ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801015a7:	8b 06                	mov    (%esi),%eax
801015a9:	8b 96 dc 00 00 00    	mov    0xdc(%esi),%edx
801015af:	e8 82 fa ff ff       	call   80101036 <bfree>
    ip->addrs[NDIRECT] = 0;
801015b4:	c7 86 dc 00 00 00 00 	movl   $0x0,0xdc(%esi)
801015bb:	00 00 00 
801015be:	83 c4 10             	add    $0x10,%esp
801015c1:	eb 85                	jmp    80101548 <itrunc+0x43>

801015c3 <idup>:
{
801015c3:	55                   	push   %ebp
801015c4:	89 e5                	mov    %esp,%ebp
801015c6:	53                   	push   %ebx
801015c7:	83 ec 10             	sub    $0x10,%esp
801015ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015cd:	68 20 04 11 80       	push   $0x80110420
801015d2:	e8 24 29 00 00       	call   80103efb <acquire>
  ip->ref++;
801015d7:	8b 43 08             	mov    0x8(%ebx),%eax
801015da:	83 c0 01             	add    $0x1,%eax
801015dd:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015e0:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
801015e7:	e8 74 29 00 00       	call   80103f60 <release>
}
801015ec:	89 d8                	mov    %ebx,%eax
801015ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015f1:	c9                   	leave  
801015f2:	c3                   	ret    

801015f3 <ilock>:
{
801015f3:	55                   	push   %ebp
801015f4:	89 e5                	mov    %esp,%ebp
801015f6:	56                   	push   %esi
801015f7:	53                   	push   %ebx
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015fb:	85 db                	test   %ebx,%ebx
801015fd:	74 25                	je     80101624 <ilock+0x31>
801015ff:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101603:	7e 1f                	jle    80101624 <ilock+0x31>
  acquiresleep(&ip->lock);
80101605:	83 ec 0c             	sub    $0xc,%esp
80101608:	8d 43 0c             	lea    0xc(%ebx),%eax
8010160b:	50                   	push   %eax
8010160c:	e8 cd 26 00 00       	call   80103cde <acquiresleep>
  if(ip->valid == 0){
80101611:	83 c4 10             	add    $0x10,%esp
80101614:	83 bb 9c 00 00 00 00 	cmpl   $0x0,0x9c(%ebx)
8010161b:	74 14                	je     80101631 <ilock+0x3e>
}
8010161d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101620:	5b                   	pop    %ebx
80101621:	5e                   	pop    %esi
80101622:	5d                   	pop    %ebp
80101623:	c3                   	ret    
    panic("ilock");
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	68 ea 6c 10 80       	push   $0x80106cea
8010162c:	e8 57 ed ff ff       	call   80100388 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101631:	8b 43 04             	mov    0x4(%ebx),%eax
80101634:	c1 e8 03             	shr    $0x3,%eax
80101637:	83 ec 08             	sub    $0x8,%esp
8010163a:	03 05 78 30 11 80    	add    0x80113078,%eax
80101640:	50                   	push   %eax
80101641:	ff 33                	push   (%ebx)
80101643:	e8 3f eb ff ff       	call   80100187 <bread>
80101648:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010164a:	8b 43 04             	mov    0x4(%ebx),%eax
8010164d:	83 e0 07             	and    $0x7,%eax
80101650:	c1 e0 06             	shl    $0x6,%eax
80101653:	8d 84 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%eax
    ip->type = dip->type;
8010165a:	0f b7 10             	movzwl (%eax),%edx
8010165d:	66 89 93 a0 00 00 00 	mov    %dx,0xa0(%ebx)
    ip->major = dip->major;
80101664:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101668:	66 89 93 a2 00 00 00 	mov    %dx,0xa2(%ebx)
    ip->minor = dip->minor;
8010166f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101673:	66 89 93 a4 00 00 00 	mov    %dx,0xa4(%ebx)
    ip->nlink = dip->nlink;
8010167a:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010167e:	66 89 93 a6 00 00 00 	mov    %dx,0xa6(%ebx)
    ip->size = dip->size;
80101685:	8b 50 08             	mov    0x8(%eax),%edx
80101688:	89 93 a8 00 00 00    	mov    %edx,0xa8(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010168e:	83 c0 0c             	add    $0xc,%eax
80101691:	8d 93 ac 00 00 00    	lea    0xac(%ebx),%edx
80101697:	83 c4 0c             	add    $0xc,%esp
8010169a:	6a 34                	push   $0x34
8010169c:	50                   	push   %eax
8010169d:	52                   	push   %edx
8010169e:	e8 f4 29 00 00       	call   80104097 <memmove>
    brelse(bp);
801016a3:	89 34 24             	mov    %esi,(%esp)
801016a6:	e8 45 eb ff ff       	call   801001f0 <brelse>
    ip->valid = 1;
801016ab:	c7 83 9c 00 00 00 01 	movl   $0x1,0x9c(%ebx)
801016b2:	00 00 00 
    if(ip->type == 0)
801016b5:	83 c4 10             	add    $0x10,%esp
801016b8:	66 83 bb a0 00 00 00 	cmpw   $0x0,0xa0(%ebx)
801016bf:	00 
801016c0:	0f 85 57 ff ff ff    	jne    8010161d <ilock+0x2a>
      panic("ilock: no type");
801016c6:	83 ec 0c             	sub    $0xc,%esp
801016c9:	68 f0 6c 10 80       	push   $0x80106cf0
801016ce:	e8 b5 ec ff ff       	call   80100388 <panic>

801016d3 <iunlock>:
{
801016d3:	55                   	push   %ebp
801016d4:	89 e5                	mov    %esp,%ebp
801016d6:	56                   	push   %esi
801016d7:	53                   	push   %ebx
801016d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801016db:	85 db                	test   %ebx,%ebx
801016dd:	74 2c                	je     8010170b <iunlock+0x38>
801016df:	8d 73 0c             	lea    0xc(%ebx),%esi
801016e2:	83 ec 0c             	sub    $0xc,%esp
801016e5:	56                   	push   %esi
801016e6:	e8 83 26 00 00       	call   80103d6e <holdingsleep>
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	85 c0                	test   %eax,%eax
801016f0:	74 19                	je     8010170b <iunlock+0x38>
801016f2:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016f6:	7e 13                	jle    8010170b <iunlock+0x38>
  releasesleep(&ip->lock);
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	56                   	push   %esi
801016fc:	e8 2f 26 00 00       	call   80103d30 <releasesleep>
}
80101701:	83 c4 10             	add    $0x10,%esp
80101704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101707:	5b                   	pop    %ebx
80101708:	5e                   	pop    %esi
80101709:	5d                   	pop    %ebp
8010170a:	c3                   	ret    
    panic("iunlock");
8010170b:	83 ec 0c             	sub    $0xc,%esp
8010170e:	68 ff 6c 10 80       	push   $0x80106cff
80101713:	e8 70 ec ff ff       	call   80100388 <panic>

80101718 <iput>:
{
80101718:	55                   	push   %ebp
80101719:	89 e5                	mov    %esp,%ebp
8010171b:	57                   	push   %edi
8010171c:	56                   	push   %esi
8010171d:	53                   	push   %ebx
8010171e:	83 ec 18             	sub    $0x18,%esp
80101721:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101724:	8d 73 0c             	lea    0xc(%ebx),%esi
80101727:	56                   	push   %esi
80101728:	e8 b1 25 00 00       	call   80103cde <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010172d:	83 c4 10             	add    $0x10,%esp
80101730:	83 bb 9c 00 00 00 00 	cmpl   $0x0,0x9c(%ebx)
80101737:	74 0a                	je     80101743 <iput+0x2b>
80101739:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
80101740:	00 
80101741:	74 35                	je     80101778 <iput+0x60>
  releasesleep(&ip->lock);
80101743:	83 ec 0c             	sub    $0xc,%esp
80101746:	56                   	push   %esi
80101747:	e8 e4 25 00 00       	call   80103d30 <releasesleep>
  acquire(&icache.lock);
8010174c:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
80101753:	e8 a3 27 00 00       	call   80103efb <acquire>
  ip->ref--;
80101758:	8b 43 08             	mov    0x8(%ebx),%eax
8010175b:	83 e8 01             	sub    $0x1,%eax
8010175e:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101761:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
80101768:	e8 f3 27 00 00       	call   80103f60 <release>
}
8010176d:	83 c4 10             	add    $0x10,%esp
80101770:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101773:	5b                   	pop    %ebx
80101774:	5e                   	pop    %esi
80101775:	5f                   	pop    %edi
80101776:	5d                   	pop    %ebp
80101777:	c3                   	ret    
    acquire(&icache.lock);
80101778:	83 ec 0c             	sub    $0xc,%esp
8010177b:	68 20 04 11 80       	push   $0x80110420
80101780:	e8 76 27 00 00       	call   80103efb <acquire>
    int r = ip->ref;
80101785:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101788:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
8010178f:	e8 cc 27 00 00       	call   80103f60 <release>
    if(r == 1){
80101794:	83 c4 10             	add    $0x10,%esp
80101797:	83 ff 01             	cmp    $0x1,%edi
8010179a:	75 a7                	jne    80101743 <iput+0x2b>
      itrunc(ip);
8010179c:	89 d8                	mov    %ebx,%eax
8010179e:	e8 62 fd ff ff       	call   80101505 <itrunc>
      ip->type = 0;
801017a3:	66 c7 83 a0 00 00 00 	movw   $0x0,0xa0(%ebx)
801017aa:	00 00 
      iupdate(ip);
801017ac:	83 ec 0c             	sub    $0xc,%esp
801017af:	53                   	push   %ebx
801017b0:	e8 bc fc ff ff       	call   80101471 <iupdate>
      ip->valid = 0;
801017b5:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801017bc:	00 00 00 
801017bf:	83 c4 10             	add    $0x10,%esp
801017c2:	e9 7c ff ff ff       	jmp    80101743 <iput+0x2b>

801017c7 <iunlockput>:
{
801017c7:	55                   	push   %ebp
801017c8:	89 e5                	mov    %esp,%ebp
801017ca:	53                   	push   %ebx
801017cb:	83 ec 10             	sub    $0x10,%esp
801017ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017d1:	53                   	push   %ebx
801017d2:	e8 fc fe ff ff       	call   801016d3 <iunlock>
  iput(ip);
801017d7:	89 1c 24             	mov    %ebx,(%esp)
801017da:	e8 39 ff ff ff       	call   80101718 <iput>
}
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e5:	c9                   	leave  
801017e6:	c3                   	ret    

801017e7 <stati>:
{
801017e7:	55                   	push   %ebp
801017e8:	89 e5                	mov    %esp,%ebp
801017ea:	8b 55 08             	mov    0x8(%ebp),%edx
801017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017f0:	8b 0a                	mov    (%edx),%ecx
801017f2:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017f5:	8b 4a 04             	mov    0x4(%edx),%ecx
801017f8:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017fb:	0f b7 8a a0 00 00 00 	movzwl 0xa0(%edx),%ecx
80101802:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101805:	0f b7 8a a6 00 00 00 	movzwl 0xa6(%edx),%ecx
8010180c:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101810:	8b 92 a8 00 00 00    	mov    0xa8(%edx),%edx
80101816:	89 50 10             	mov    %edx,0x10(%eax)
}
80101819:	5d                   	pop    %ebp
8010181a:	c3                   	ret    

8010181b <readi>:
{
8010181b:	55                   	push   %ebp
8010181c:	89 e5                	mov    %esp,%ebp
8010181e:	57                   	push   %edi
8010181f:	56                   	push   %esi
80101820:	53                   	push   %ebx
80101821:	83 ec 1c             	sub    $0x1c,%esp
80101824:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101827:	8b 45 08             	mov    0x8(%ebp),%eax
8010182a:	66 83 b8 a0 00 00 00 	cmpw   $0x3,0xa0(%eax)
80101831:	03 
80101832:	74 2f                	je     80101863 <readi+0x48>
  if(off > ip->size || off + n < off)
80101834:	8b 45 08             	mov    0x8(%ebp),%eax
80101837:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010183d:	39 f8                	cmp    %edi,%eax
8010183f:	0f 82 d1 00 00 00    	jb     80101916 <readi+0xfb>
80101845:	89 fa                	mov    %edi,%edx
80101847:	03 55 14             	add    0x14(%ebp),%edx
8010184a:	0f 82 cd 00 00 00    	jb     8010191d <readi+0x102>
  if(off + n > ip->size)
80101850:	39 d0                	cmp    %edx,%eax
80101852:	73 05                	jae    80101859 <readi+0x3e>
    n = ip->size - off;
80101854:	29 f8                	sub    %edi,%eax
80101856:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101859:	be 00 00 00 00       	mov    $0x0,%esi
8010185e:	e9 95 00 00 00       	jmp    801018f8 <readi+0xdd>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101863:	0f b7 80 a2 00 00 00 	movzwl 0xa2(%eax),%eax
8010186a:	66 83 f8 09          	cmp    $0x9,%ax
8010186e:	0f 87 94 00 00 00    	ja     80101908 <readi+0xed>
80101874:	98                   	cwtl   
80101875:	8b 04 c5 c0 03 11 80 	mov    -0x7feefc40(,%eax,8),%eax
8010187c:	85 c0                	test   %eax,%eax
8010187e:	0f 84 8b 00 00 00    	je     8010190f <readi+0xf4>
    return devsw[ip->major].read(ip, dst, n);
80101884:	83 ec 04             	sub    $0x4,%esp
80101887:	ff 75 14             	push   0x14(%ebp)
8010188a:	ff 75 0c             	push   0xc(%ebp)
8010188d:	ff 75 08             	push   0x8(%ebp)
80101890:	ff d0                	call   *%eax
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	eb 69                	jmp    80101900 <readi+0xe5>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101897:	89 fa                	mov    %edi,%edx
80101899:	c1 ea 09             	shr    $0x9,%edx
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
8010189f:	e8 fc f8 ff ff       	call   801011a0 <bmap>
801018a4:	83 ec 08             	sub    $0x8,%esp
801018a7:	50                   	push   %eax
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	ff 30                	push   (%eax)
801018ad:	e8 d5 e8 ff ff       	call   80100187 <bread>
801018b2:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801018b4:	89 f8                	mov    %edi,%eax
801018b6:	25 ff 01 00 00       	and    $0x1ff,%eax
801018bb:	bb 00 02 00 00       	mov    $0x200,%ebx
801018c0:	29 c3                	sub    %eax,%ebx
801018c2:	8b 55 14             	mov    0x14(%ebp),%edx
801018c5:	29 f2                	sub    %esi,%edx
801018c7:	39 d3                	cmp    %edx,%ebx
801018c9:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801018cc:	83 c4 0c             	add    $0xc,%esp
801018cf:	53                   	push   %ebx
801018d0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801018d3:	8d 84 01 ac 00 00 00 	lea    0xac(%ecx,%eax,1),%eax
801018da:	50                   	push   %eax
801018db:	ff 75 0c             	push   0xc(%ebp)
801018de:	e8 b4 27 00 00       	call   80104097 <memmove>
    brelse(bp);
801018e3:	83 c4 04             	add    $0x4,%esp
801018e6:	ff 75 e4             	push   -0x1c(%ebp)
801018e9:	e8 02 e9 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018ee:	01 de                	add    %ebx,%esi
801018f0:	01 df                	add    %ebx,%edi
801018f2:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018f5:	83 c4 10             	add    $0x10,%esp
801018f8:	39 75 14             	cmp    %esi,0x14(%ebp)
801018fb:	77 9a                	ja     80101897 <readi+0x7c>
  return n;
801018fd:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101903:	5b                   	pop    %ebx
80101904:	5e                   	pop    %esi
80101905:	5f                   	pop    %edi
80101906:	5d                   	pop    %ebp
80101907:	c3                   	ret    
      return -1;
80101908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010190d:	eb f1                	jmp    80101900 <readi+0xe5>
8010190f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101914:	eb ea                	jmp    80101900 <readi+0xe5>
    return -1;
80101916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010191b:	eb e3                	jmp    80101900 <readi+0xe5>
8010191d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101922:	eb dc                	jmp    80101900 <readi+0xe5>

80101924 <writei>:
{
80101924:	55                   	push   %ebp
80101925:	89 e5                	mov    %esp,%ebp
80101927:	57                   	push   %edi
80101928:	56                   	push   %esi
80101929:	53                   	push   %ebx
8010192a:	83 ec 1c             	sub    $0x1c,%esp
8010192d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101930:	8b 45 08             	mov    0x8(%ebp),%eax
80101933:	66 83 b8 a0 00 00 00 	cmpw   $0x3,0xa0(%eax)
8010193a:	03 
8010193b:	74 31                	je     8010196e <writei+0x4a>
  if(off > ip->size || off + n < off)
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	39 b8 a8 00 00 00    	cmp    %edi,0xa8(%eax)
80101946:	0f 82 04 01 00 00    	jb     80101a50 <writei+0x12c>
8010194c:	89 f8                	mov    %edi,%eax
8010194e:	03 45 14             	add    0x14(%ebp),%eax
80101951:	0f 82 00 01 00 00    	jb     80101a57 <writei+0x133>
  if(off + n > MAXFILE*BSIZE)
80101957:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010195c:	0f 87 fc 00 00 00    	ja     80101a5e <writei+0x13a>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101962:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101969:	e9 9c 00 00 00       	jmp    80101a0a <writei+0xe6>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010196e:	0f b7 80 a2 00 00 00 	movzwl 0xa2(%eax),%eax
80101975:	66 83 f8 09          	cmp    $0x9,%ax
80101979:	0f 87 c3 00 00 00    	ja     80101a42 <writei+0x11e>
8010197f:	98                   	cwtl   
80101980:	8b 04 c5 c4 03 11 80 	mov    -0x7feefc3c(,%eax,8),%eax
80101987:	85 c0                	test   %eax,%eax
80101989:	0f 84 ba 00 00 00    	je     80101a49 <writei+0x125>
    return devsw[ip->major].write(ip, src, n);
8010198f:	83 ec 04             	sub    $0x4,%esp
80101992:	ff 75 14             	push   0x14(%ebp)
80101995:	ff 75 0c             	push   0xc(%ebp)
80101998:	ff 75 08             	push   0x8(%ebp)
8010199b:	ff d0                	call   *%eax
8010199d:	83 c4 10             	add    $0x10,%esp
801019a0:	e9 81 00 00 00       	jmp    80101a26 <writei+0x102>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a5:	89 fa                	mov    %edi,%edx
801019a7:	c1 ea 09             	shr    $0x9,%edx
801019aa:	8b 45 08             	mov    0x8(%ebp),%eax
801019ad:	e8 ee f7 ff ff       	call   801011a0 <bmap>
801019b2:	83 ec 08             	sub    $0x8,%esp
801019b5:	50                   	push   %eax
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	ff 30                	push   (%eax)
801019bb:	e8 c7 e7 ff ff       	call   80100187 <bread>
801019c0:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801019c2:	89 f8                	mov    %edi,%eax
801019c4:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c9:	bb 00 02 00 00       	mov    $0x200,%ebx
801019ce:	29 c3                	sub    %eax,%ebx
801019d0:	8b 55 14             	mov    0x14(%ebp),%edx
801019d3:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801019d6:	39 d3                	cmp    %edx,%ebx
801019d8:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801019db:	83 c4 0c             	add    $0xc,%esp
801019de:	53                   	push   %ebx
801019df:	ff 75 0c             	push   0xc(%ebp)
801019e2:	8d 84 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%eax
801019e9:	50                   	push   %eax
801019ea:	e8 a8 26 00 00       	call   80104097 <memmove>
    log_write(bp);
801019ef:	89 34 24             	mov    %esi,(%esp)
801019f2:	e8 be 0f 00 00       	call   801029b5 <log_write>
    brelse(bp);
801019f7:	89 34 24             	mov    %esi,(%esp)
801019fa:	e8 f1 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019ff:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101a02:	01 df                	add    %ebx,%edi
80101a04:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101a07:	83 c4 10             	add    $0x10,%esp
80101a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a0d:	3b 45 14             	cmp    0x14(%ebp),%eax
80101a10:	72 93                	jb     801019a5 <writei+0x81>
  if(n > 0 && off > ip->size){
80101a12:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101a16:	74 0b                	je     80101a23 <writei+0xff>
80101a18:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1b:	39 b8 a8 00 00 00    	cmp    %edi,0xa8(%eax)
80101a21:	72 0b                	jb     80101a2e <writei+0x10a>
  return n;
80101a23:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101a26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a29:	5b                   	pop    %ebx
80101a2a:	5e                   	pop    %esi
80101a2b:	5f                   	pop    %edi
80101a2c:	5d                   	pop    %ebp
80101a2d:	c3                   	ret    
    ip->size = off;
80101a2e:	89 b8 a8 00 00 00    	mov    %edi,0xa8(%eax)
    iupdate(ip);
80101a34:	83 ec 0c             	sub    $0xc,%esp
80101a37:	50                   	push   %eax
80101a38:	e8 34 fa ff ff       	call   80101471 <iupdate>
80101a3d:	83 c4 10             	add    $0x10,%esp
80101a40:	eb e1                	jmp    80101a23 <writei+0xff>
      return -1;
80101a42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a47:	eb dd                	jmp    80101a26 <writei+0x102>
80101a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4e:	eb d6                	jmp    80101a26 <writei+0x102>
    return -1;
80101a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a55:	eb cf                	jmp    80101a26 <writei+0x102>
80101a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5c:	eb c8                	jmp    80101a26 <writei+0x102>
    return -1;
80101a5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a63:	eb c1                	jmp    80101a26 <writei+0x102>

80101a65 <namecmp>:
{
80101a65:	55                   	push   %ebp
80101a66:	89 e5                	mov    %esp,%ebp
80101a68:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a6b:	6a 0e                	push   $0xe
80101a6d:	ff 75 0c             	push   0xc(%ebp)
80101a70:	ff 75 08             	push   0x8(%ebp)
80101a73:	e8 8b 26 00 00       	call   80104103 <strncmp>
}
80101a78:	c9                   	leave  
80101a79:	c3                   	ret    

80101a7a <dirlookup>:
{
80101a7a:	55                   	push   %ebp
80101a7b:	89 e5                	mov    %esp,%ebp
80101a7d:	57                   	push   %edi
80101a7e:	56                   	push   %esi
80101a7f:	53                   	push   %ebx
80101a80:	83 ec 1c             	sub    $0x1c,%esp
80101a83:	8b 75 08             	mov    0x8(%ebp),%esi
80101a86:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101a89:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80101a90:	01 
80101a91:	75 07                	jne    80101a9a <dirlookup+0x20>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a93:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a98:	eb 1d                	jmp    80101ab7 <dirlookup+0x3d>
    panic("dirlookup not DIR");
80101a9a:	83 ec 0c             	sub    $0xc,%esp
80101a9d:	68 07 6d 10 80       	push   $0x80106d07
80101aa2:	e8 e1 e8 ff ff       	call   80100388 <panic>
      panic("dirlookup read");
80101aa7:	83 ec 0c             	sub    $0xc,%esp
80101aaa:	68 19 6d 10 80       	push   $0x80106d19
80101aaf:	e8 d4 e8 ff ff       	call   80100388 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ab4:	83 c3 10             	add    $0x10,%ebx
80101ab7:	39 9e a8 00 00 00    	cmp    %ebx,0xa8(%esi)
80101abd:	76 48                	jbe    80101b07 <dirlookup+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101abf:	6a 10                	push   $0x10
80101ac1:	53                   	push   %ebx
80101ac2:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101ac5:	50                   	push   %eax
80101ac6:	56                   	push   %esi
80101ac7:	e8 4f fd ff ff       	call   8010181b <readi>
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	83 f8 10             	cmp    $0x10,%eax
80101ad2:	75 d3                	jne    80101aa7 <dirlookup+0x2d>
    if(de.inum == 0)
80101ad4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ad9:	74 d9                	je     80101ab4 <dirlookup+0x3a>
    if(namecmp(name, de.name) == 0){
80101adb:	83 ec 08             	sub    $0x8,%esp
80101ade:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ae1:	50                   	push   %eax
80101ae2:	57                   	push   %edi
80101ae3:	e8 7d ff ff ff       	call   80101a65 <namecmp>
80101ae8:	83 c4 10             	add    $0x10,%esp
80101aeb:	85 c0                	test   %eax,%eax
80101aed:	75 c5                	jne    80101ab4 <dirlookup+0x3a>
      if(poff)
80101aef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101af3:	74 05                	je     80101afa <dirlookup+0x80>
        *poff = off;
80101af5:	8b 45 10             	mov    0x10(%ebp),%eax
80101af8:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101afa:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101afe:	8b 06                	mov    (%esi),%eax
80101b00:	e8 4e f7 ff ff       	call   80101253 <iget>
80101b05:	eb 05                	jmp    80101b0c <dirlookup+0x92>
  return 0;
80101b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0f:	5b                   	pop    %ebx
80101b10:	5e                   	pop    %esi
80101b11:	5f                   	pop    %edi
80101b12:	5d                   	pop    %ebp
80101b13:	c3                   	ret    

80101b14 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101b14:	55                   	push   %ebp
80101b15:	89 e5                	mov    %esp,%ebp
80101b17:	57                   	push   %edi
80101b18:	56                   	push   %esi
80101b19:	53                   	push   %ebx
80101b1a:	83 ec 1c             	sub    $0x1c,%esp
80101b1d:	89 c3                	mov    %eax,%ebx
80101b1f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101b22:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101b25:	80 38 2f             	cmpb   $0x2f,(%eax)
80101b28:	74 17                	je     80101b41 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b2a:	e8 9a 17 00 00       	call   801032c9 <myproc>
80101b2f:	83 ec 0c             	sub    $0xc,%esp
80101b32:	ff 70 68             	push   0x68(%eax)
80101b35:	e8 89 fa ff ff       	call   801015c3 <idup>
80101b3a:	89 c6                	mov    %eax,%esi
80101b3c:	83 c4 10             	add    $0x10,%esp
80101b3f:	eb 53                	jmp    80101b94 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101b41:	ba 01 00 00 00       	mov    $0x1,%edx
80101b46:	b8 01 00 00 00       	mov    $0x1,%eax
80101b4b:	e8 03 f7 ff ff       	call   80101253 <iget>
80101b50:	89 c6                	mov    %eax,%esi
80101b52:	eb 40                	jmp    80101b94 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101b54:	83 ec 0c             	sub    $0xc,%esp
80101b57:	56                   	push   %esi
80101b58:	e8 6a fc ff ff       	call   801017c7 <iunlockput>
      return 0;
80101b5d:	83 c4 10             	add    $0x10,%esp
80101b60:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b65:	89 f0                	mov    %esi,%eax
80101b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6a:	5b                   	pop    %ebx
80101b6b:	5e                   	pop    %esi
80101b6c:	5f                   	pop    %edi
80101b6d:	5d                   	pop    %ebp
80101b6e:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101b6f:	83 ec 04             	sub    $0x4,%esp
80101b72:	6a 00                	push   $0x0
80101b74:	ff 75 e4             	push   -0x1c(%ebp)
80101b77:	56                   	push   %esi
80101b78:	e8 fd fe ff ff       	call   80101a7a <dirlookup>
80101b7d:	89 c7                	mov    %eax,%edi
80101b7f:	83 c4 10             	add    $0x10,%esp
80101b82:	85 c0                	test   %eax,%eax
80101b84:	74 4d                	je     80101bd3 <namex+0xbf>
    iunlockput(ip);
80101b86:	83 ec 0c             	sub    $0xc,%esp
80101b89:	56                   	push   %esi
80101b8a:	e8 38 fc ff ff       	call   801017c7 <iunlockput>
80101b8f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b92:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b97:	89 d8                	mov    %ebx,%eax
80101b99:	e8 e4 f3 ff ff       	call   80100f82 <skipelem>
80101b9e:	89 c3                	mov    %eax,%ebx
80101ba0:	85 c0                	test   %eax,%eax
80101ba2:	74 3f                	je     80101be3 <namex+0xcf>
    ilock(ip);
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	56                   	push   %esi
80101ba8:	e8 46 fa ff ff       	call   801015f3 <ilock>
    if(ip->type != T_DIR){
80101bad:	83 c4 10             	add    $0x10,%esp
80101bb0:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80101bb7:	01 
80101bb8:	75 9a                	jne    80101b54 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101bbe:	74 af                	je     80101b6f <namex+0x5b>
80101bc0:	80 3b 00             	cmpb   $0x0,(%ebx)
80101bc3:	75 aa                	jne    80101b6f <namex+0x5b>
      iunlock(ip);
80101bc5:	83 ec 0c             	sub    $0xc,%esp
80101bc8:	56                   	push   %esi
80101bc9:	e8 05 fb ff ff       	call   801016d3 <iunlock>
      return ip;
80101bce:	83 c4 10             	add    $0x10,%esp
80101bd1:	eb 92                	jmp    80101b65 <namex+0x51>
      iunlockput(ip);
80101bd3:	83 ec 0c             	sub    $0xc,%esp
80101bd6:	56                   	push   %esi
80101bd7:	e8 eb fb ff ff       	call   801017c7 <iunlockput>
      return 0;
80101bdc:	83 c4 10             	add    $0x10,%esp
80101bdf:	89 fe                	mov    %edi,%esi
80101be1:	eb 82                	jmp    80101b65 <namex+0x51>
  if(nameiparent){
80101be3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101be7:	0f 84 78 ff ff ff    	je     80101b65 <namex+0x51>
    iput(ip);
80101bed:	83 ec 0c             	sub    $0xc,%esp
80101bf0:	56                   	push   %esi
80101bf1:	e8 22 fb ff ff       	call   80101718 <iput>
    return 0;
80101bf6:	83 c4 10             	add    $0x10,%esp
80101bf9:	89 de                	mov    %ebx,%esi
80101bfb:	e9 65 ff ff ff       	jmp    80101b65 <namex+0x51>

80101c00 <dirlink>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 20             	sub    $0x20,%esp
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c0f:	6a 00                	push   $0x0
80101c11:	57                   	push   %edi
80101c12:	53                   	push   %ebx
80101c13:	e8 62 fe ff ff       	call   80101a7a <dirlookup>
80101c18:	83 c4 10             	add    $0x10,%esp
80101c1b:	85 c0                	test   %eax,%eax
80101c1d:	75 30                	jne    80101c4f <dirlink+0x4f>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c1f:	b8 00 00 00 00       	mov    $0x0,%eax
80101c24:	89 c6                	mov    %eax,%esi
80101c26:	39 83 a8 00 00 00    	cmp    %eax,0xa8(%ebx)
80101c2c:	76 41                	jbe    80101c6f <dirlink+0x6f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c2e:	6a 10                	push   $0x10
80101c30:	50                   	push   %eax
80101c31:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101c34:	50                   	push   %eax
80101c35:	53                   	push   %ebx
80101c36:	e8 e0 fb ff ff       	call   8010181b <readi>
80101c3b:	83 c4 10             	add    $0x10,%esp
80101c3e:	83 f8 10             	cmp    $0x10,%eax
80101c41:	75 1f                	jne    80101c62 <dirlink+0x62>
    if(de.inum == 0)
80101c43:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c48:	74 25                	je     80101c6f <dirlink+0x6f>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c4a:	8d 46 10             	lea    0x10(%esi),%eax
80101c4d:	eb d5                	jmp    80101c24 <dirlink+0x24>
    iput(ip);
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	50                   	push   %eax
80101c53:	e8 c0 fa ff ff       	call   80101718 <iput>
    return -1;
80101c58:	83 c4 10             	add    $0x10,%esp
80101c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c60:	eb 3d                	jmp    80101c9f <dirlink+0x9f>
      panic("dirlink read");
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 28 6d 10 80       	push   $0x80106d28
80101c6a:	e8 19 e7 ff ff       	call   80100388 <panic>
  strncpy(de.name, name, DIRSIZ);
80101c6f:	83 ec 04             	sub    $0x4,%esp
80101c72:	6a 0e                	push   $0xe
80101c74:	57                   	push   %edi
80101c75:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c78:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c7b:	50                   	push   %eax
80101c7c:	e8 c1 24 00 00       	call   80104142 <strncpy>
  de.inum = inum;
80101c81:	8b 45 10             	mov    0x10(%ebp),%eax
80101c84:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c88:	6a 10                	push   $0x10
80101c8a:	56                   	push   %esi
80101c8b:	57                   	push   %edi
80101c8c:	53                   	push   %ebx
80101c8d:	e8 92 fc ff ff       	call   80101924 <writei>
80101c92:	83 c4 20             	add    $0x20,%esp
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 0d                	jne    80101ca7 <dirlink+0xa7>
  return 0;
80101c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca2:	5b                   	pop    %ebx
80101ca3:	5e                   	pop    %esi
80101ca4:	5f                   	pop    %edi
80101ca5:	5d                   	pop    %ebp
80101ca6:	c3                   	ret    
    panic("dirlink");
80101ca7:	83 ec 0c             	sub    $0xc,%esp
80101caa:	68 c0 73 10 80       	push   $0x801073c0
80101caf:	e8 d4 e6 ff ff       	call   80100388 <panic>

80101cb4 <namei>:

struct inode*
namei(char *path)
{
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101cba:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101cbd:	ba 00 00 00 00       	mov    $0x0,%edx
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	e8 4a fe ff ff       	call   80101b14 <namex>
}
80101cca:	c9                   	leave  
80101ccb:	c3                   	ret    

80101ccc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ccc:	55                   	push   %ebp
80101ccd:	89 e5                	mov    %esp,%ebp
80101ccf:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101cd5:	ba 01 00 00 00       	mov    $0x1,%edx
80101cda:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdd:	e8 32 fe ff ff       	call   80101b14 <namex>
}
80101ce2:	c9                   	leave  
80101ce3:	c3                   	ret    

80101ce4 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101ce4:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ce6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ceb:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101cec:	89 c2                	mov    %eax,%edx
80101cee:	83 e2 c0             	and    $0xffffffc0,%edx
80101cf1:	80 fa 40             	cmp    $0x40,%dl
80101cf4:	75 f0                	jne    80101ce6 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101cf6:	85 c9                	test   %ecx,%ecx
80101cf8:	74 09                	je     80101d03 <idewait+0x1f>
80101cfa:	a8 21                	test   $0x21,%al
80101cfc:	75 08                	jne    80101d06 <idewait+0x22>
    return -1;
  return 0;
80101cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101d03:	89 c8                	mov    %ecx,%eax
80101d05:	c3                   	ret    
    return -1;
80101d06:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101d0b:	eb f6                	jmp    80101d03 <idewait+0x1f>

80101d0d <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d0d:	55                   	push   %ebp
80101d0e:	89 e5                	mov    %esp,%ebp
80101d10:	56                   	push   %esi
80101d11:	53                   	push   %ebx
  if(b == 0)
80101d12:	85 c0                	test   %eax,%eax
80101d14:	0f 84 92 00 00 00    	je     80101dac <idestart+0x9f>
80101d1a:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d1c:	8b 58 08             	mov    0x8(%eax),%ebx
80101d1f:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101d25:	0f 87 8e 00 00 00    	ja     80101db9 <idestart+0xac>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101d2b:	b8 00 00 00 00       	mov    $0x0,%eax
80101d30:	e8 af ff ff ff       	call   80101ce4 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d35:	b8 00 00 00 00       	mov    $0x0,%eax
80101d3a:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d3f:	ee                   	out    %al,(%dx)
80101d40:	b8 01 00 00 00       	mov    $0x1,%eax
80101d45:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d4a:	ee                   	out    %al,(%dx)
80101d4b:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d50:	89 d8                	mov    %ebx,%eax
80101d52:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d53:	0f b6 c7             	movzbl %bh,%eax
80101d56:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d5b:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d5c:	89 d8                	mov    %ebx,%eax
80101d5e:	c1 f8 10             	sar    $0x10,%eax
80101d61:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d66:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d67:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d6b:	c1 e0 04             	shl    $0x4,%eax
80101d6e:	83 e0 10             	and    $0x10,%eax
80101d71:	c1 fb 18             	sar    $0x18,%ebx
80101d74:	83 e3 0f             	and    $0xf,%ebx
80101d77:	09 d8                	or     %ebx,%eax
80101d79:	83 c8 e0             	or     $0xffffffe0,%eax
80101d7c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d81:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d82:	f6 06 04             	testb  $0x4,(%esi)
80101d85:	74 3f                	je     80101dc6 <idestart+0xb9>
80101d87:	b8 30 00 00 00       	mov    $0x30,%eax
80101d8c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d91:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d92:	81 c6 ac 00 00 00    	add    $0xac,%esi
  asm volatile("cld; rep outsl" :
80101d98:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d9d:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101da2:	fc                   	cld    
80101da3:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101da8:	5b                   	pop    %ebx
80101da9:	5e                   	pop    %esi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
    panic("idestart");
80101dac:	83 ec 0c             	sub    $0xc,%esp
80101daf:	68 8b 6d 10 80       	push   $0x80106d8b
80101db4:	e8 cf e5 ff ff       	call   80100388 <panic>
    panic("incorrect blockno");
80101db9:	83 ec 0c             	sub    $0xc,%esp
80101dbc:	68 94 6d 10 80       	push   $0x80106d94
80101dc1:	e8 c2 e5 ff ff       	call   80100388 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101dc6:	b8 20 00 00 00       	mov    $0x20,%eax
80101dcb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dd0:	ee                   	out    %al,(%dx)
}
80101dd1:	eb d2                	jmp    80101da5 <idestart+0x98>

80101dd3 <ideinit>:
{
80101dd3:	55                   	push   %ebp
80101dd4:	89 e5                	mov    %esp,%ebp
80101dd6:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101dd9:	68 a6 6d 10 80       	push   $0x80106da6
80101dde:	68 a0 30 11 80       	push   $0x801130a0
80101de3:	e8 d7 1f 00 00       	call   80103dbf <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101de8:	83 c4 08             	add    $0x8,%esp
80101deb:	a1 04 33 11 80       	mov    0x80113304,%eax
80101df0:	83 e8 01             	sub    $0x1,%eax
80101df3:	50                   	push   %eax
80101df4:	6a 0e                	push   $0xe
80101df6:	e8 5c 02 00 00       	call   80102057 <ioapicenable>
  idewait(0);
80101dfb:	b8 00 00 00 00       	mov    $0x0,%eax
80101e00:	e8 df fe ff ff       	call   80101ce4 <idewait>
80101e05:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101e0a:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e0f:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101e10:	83 c4 10             	add    $0x10,%esp
80101e13:	b9 00 00 00 00       	mov    $0x0,%ecx
80101e18:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101e1e:	7f 19                	jg     80101e39 <ideinit+0x66>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e20:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e25:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e26:	84 c0                	test   %al,%al
80101e28:	75 05                	jne    80101e2f <ideinit+0x5c>
  for(i=0; i<1000; i++){
80101e2a:	83 c1 01             	add    $0x1,%ecx
80101e2d:	eb e9                	jmp    80101e18 <ideinit+0x45>
      havedisk1 = 1;
80101e2f:	c7 05 80 30 11 80 01 	movl   $0x1,0x80113080
80101e36:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e39:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e3e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e43:	ee                   	out    %al,(%dx)
}
80101e44:	c9                   	leave  
80101e45:	c3                   	ret    

80101e46 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e46:	55                   	push   %ebp
80101e47:	89 e5                	mov    %esp,%ebp
80101e49:	57                   	push   %edi
80101e4a:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e4b:	83 ec 0c             	sub    $0xc,%esp
80101e4e:	68 a0 30 11 80       	push   $0x801130a0
80101e53:	e8 a3 20 00 00       	call   80103efb <acquire>

  if((b = idequeue) == 0){
80101e58:	8b 1d 84 30 11 80    	mov    0x80113084,%ebx
80101e5e:	83 c4 10             	add    $0x10,%esp
80101e61:	85 db                	test   %ebx,%ebx
80101e63:	74 4d                	je     80101eb2 <ideintr+0x6c>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e65:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80101e6b:	a3 84 30 11 80       	mov    %eax,0x80113084

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e70:	f6 03 04             	testb  $0x4,(%ebx)
80101e73:	74 4f                	je     80101ec4 <ideintr+0x7e>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101e75:	8b 03                	mov    (%ebx),%eax
80101e77:	83 c8 02             	or     $0x2,%eax
80101e7a:	89 03                	mov    %eax,(%ebx)
  b->flags &= ~B_DIRTY;
80101e7c:	83 e0 fb             	and    $0xfffffffb,%eax
80101e7f:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e81:	83 ec 0c             	sub    $0xc,%esp
80101e84:	53                   	push   %ebx
80101e85:	e8 6b 1a 00 00       	call   801038f5 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e8a:	a1 84 30 11 80       	mov    0x80113084,%eax
80101e8f:	83 c4 10             	add    $0x10,%esp
80101e92:	85 c0                	test   %eax,%eax
80101e94:	74 05                	je     80101e9b <ideintr+0x55>
    idestart(idequeue);
80101e96:	e8 72 fe ff ff       	call   80101d0d <idestart>

  release(&idelock);
80101e9b:	83 ec 0c             	sub    $0xc,%esp
80101e9e:	68 a0 30 11 80       	push   $0x801130a0
80101ea3:	e8 b8 20 00 00       	call   80103f60 <release>
80101ea8:	83 c4 10             	add    $0x10,%esp
}
80101eab:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101eae:	5b                   	pop    %ebx
80101eaf:	5f                   	pop    %edi
80101eb0:	5d                   	pop    %ebp
80101eb1:	c3                   	ret    
    release(&idelock);
80101eb2:	83 ec 0c             	sub    $0xc,%esp
80101eb5:	68 a0 30 11 80       	push   $0x801130a0
80101eba:	e8 a1 20 00 00       	call   80103f60 <release>
    return;
80101ebf:	83 c4 10             	add    $0x10,%esp
80101ec2:	eb e7                	jmp    80101eab <ideintr+0x65>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101ec4:	b8 01 00 00 00       	mov    $0x1,%eax
80101ec9:	e8 16 fe ff ff       	call   80101ce4 <idewait>
80101ece:	85 c0                	test   %eax,%eax
80101ed0:	78 a3                	js     80101e75 <ideintr+0x2f>
    insl(0x1f0, b->data, BSIZE/4);
80101ed2:	8d bb ac 00 00 00    	lea    0xac(%ebx),%edi
  asm volatile("cld; rep insl" :
80101ed8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101edd:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ee2:	fc                   	cld    
80101ee3:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101ee5:	eb 8e                	jmp    80101e75 <ideintr+0x2f>

80101ee7 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101ee7:	55                   	push   %ebp
80101ee8:	89 e5                	mov    %esp,%ebp
80101eea:	53                   	push   %ebx
80101eeb:	83 ec 10             	sub    $0x10,%esp
80101eee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101ef1:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ef4:	50                   	push   %eax
80101ef5:	e8 74 1e 00 00       	call   80103d6e <holdingsleep>
80101efa:	83 c4 10             	add    $0x10,%esp
80101efd:	85 c0                	test   %eax,%eax
80101eff:	74 3a                	je     80101f3b <iderw+0x54>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f01:	8b 03                	mov    (%ebx),%eax
80101f03:	83 e0 06             	and    $0x6,%eax
80101f06:	83 f8 02             	cmp    $0x2,%eax
80101f09:	74 3d                	je     80101f48 <iderw+0x61>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f0b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101f0f:	74 09                	je     80101f1a <iderw+0x33>
80101f11:	83 3d 80 30 11 80 00 	cmpl   $0x0,0x80113080
80101f18:	74 3b                	je     80101f55 <iderw+0x6e>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	68 a0 30 11 80       	push   $0x801130a0
80101f22:	e8 d4 1f 00 00       	call   80103efb <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f27:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80101f2e:	00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f31:	83 c4 10             	add    $0x10,%esp
80101f34:	ba 84 30 11 80       	mov    $0x80113084,%edx
80101f39:	eb 2d                	jmp    80101f68 <iderw+0x81>
    panic("iderw: buf not locked");
80101f3b:	83 ec 0c             	sub    $0xc,%esp
80101f3e:	68 aa 6d 10 80       	push   $0x80106daa
80101f43:	e8 40 e4 ff ff       	call   80100388 <panic>
    panic("iderw: nothing to do");
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	68 c0 6d 10 80       	push   $0x80106dc0
80101f50:	e8 33 e4 ff ff       	call   80100388 <panic>
    panic("iderw: ide disk 1 not present");
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	68 d5 6d 10 80       	push   $0x80106dd5
80101f5d:	e8 26 e4 ff ff       	call   80100388 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f62:	8d 90 a8 00 00 00    	lea    0xa8(%eax),%edx
80101f68:	8b 02                	mov    (%edx),%eax
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	75 f4                	jne    80101f62 <iderw+0x7b>
    ;
  *pp = b;
80101f6e:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f70:	39 1d 84 30 11 80    	cmp    %ebx,0x80113084
80101f76:	75 1a                	jne    80101f92 <iderw+0xab>
    idestart(b);
80101f78:	89 d8                	mov    %ebx,%eax
80101f7a:	e8 8e fd ff ff       	call   80101d0d <idestart>
80101f7f:	eb 11                	jmp    80101f92 <iderw+0xab>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101f81:	83 ec 08             	sub    $0x8,%esp
80101f84:	68 a0 30 11 80       	push   $0x801130a0
80101f89:	53                   	push   %ebx
80101f8a:	e8 01 18 00 00       	call   80103790 <sleep>
80101f8f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f92:	8b 03                	mov    (%ebx),%eax
80101f94:	83 e0 06             	and    $0x6,%eax
80101f97:	83 f8 02             	cmp    $0x2,%eax
80101f9a:	75 e5                	jne    80101f81 <iderw+0x9a>
  }


  release(&idelock);
80101f9c:	83 ec 0c             	sub    $0xc,%esp
80101f9f:	68 a0 30 11 80       	push   $0x801130a0
80101fa4:	e8 b7 1f 00 00       	call   80103f60 <release>
}
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101faf:	c9                   	leave  
80101fb0:	c3                   	ret    

80101fb1 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101fb1:	8b 15 24 31 11 80    	mov    0x80113124,%edx
80101fb7:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101fb9:	a1 24 31 11 80       	mov    0x80113124,%eax
80101fbe:	8b 40 10             	mov    0x10(%eax),%eax
}
80101fc1:	c3                   	ret    

80101fc2 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101fc2:	8b 0d 24 31 11 80    	mov    0x80113124,%ecx
80101fc8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101fca:	a1 24 31 11 80       	mov    0x80113124,%eax
80101fcf:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fd2:	c3                   	ret    

80101fd3 <ioapicinit>:

void
ioapicinit(void)
{
80101fd3:	55                   	push   %ebp
80101fd4:	89 e5                	mov    %esp,%ebp
80101fd6:	57                   	push   %edi
80101fd7:	56                   	push   %esi
80101fd8:	53                   	push   %ebx
80101fd9:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fdc:	c7 05 24 31 11 80 00 	movl   $0xfec00000,0x80113124
80101fe3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101fe6:	b8 01 00 00 00       	mov    $0x1,%eax
80101feb:	e8 c1 ff ff ff       	call   80101fb1 <ioapicread>
80101ff0:	c1 e8 10             	shr    $0x10,%eax
80101ff3:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101ff6:	b8 00 00 00 00       	mov    $0x0,%eax
80101ffb:	e8 b1 ff ff ff       	call   80101fb1 <ioapicread>
80102000:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102003:	0f b6 15 00 33 11 80 	movzbl 0x80113300,%edx
8010200a:	39 c2                	cmp    %eax,%edx
8010200c:	75 07                	jne    80102015 <ioapicinit+0x42>
{
8010200e:	bb 00 00 00 00       	mov    $0x0,%ebx
80102013:	eb 36                	jmp    8010204b <ioapicinit+0x78>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 f4 6d 10 80       	push   $0x80106df4
8010201d:	e8 25 e6 ff ff       	call   80100647 <cprintf>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	eb e7                	jmp    8010200e <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102027:	8d 53 20             	lea    0x20(%ebx),%edx
8010202a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80102030:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80102034:	89 f0                	mov    %esi,%eax
80102036:	e8 87 ff ff ff       	call   80101fc2 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010203b:	8d 46 01             	lea    0x1(%esi),%eax
8010203e:	ba 00 00 00 00       	mov    $0x0,%edx
80102043:	e8 7a ff ff ff       	call   80101fc2 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80102048:	83 c3 01             	add    $0x1,%ebx
8010204b:	39 fb                	cmp    %edi,%ebx
8010204d:	7e d8                	jle    80102027 <ioapicinit+0x54>
  }
}
8010204f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102052:	5b                   	pop    %ebx
80102053:	5e                   	pop    %esi
80102054:	5f                   	pop    %edi
80102055:	5d                   	pop    %ebp
80102056:	c3                   	ret    

80102057 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102057:	55                   	push   %ebp
80102058:	89 e5                	mov    %esp,%ebp
8010205a:	53                   	push   %ebx
8010205b:	83 ec 04             	sub    $0x4,%esp
8010205e:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102061:	8d 50 20             	lea    0x20(%eax),%edx
80102064:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80102068:	89 d8                	mov    %ebx,%eax
8010206a:	e8 53 ff ff ff       	call   80101fc2 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010206f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102072:	c1 e2 18             	shl    $0x18,%edx
80102075:	8d 43 01             	lea    0x1(%ebx),%eax
80102078:	e8 45 ff ff ff       	call   80101fc2 <ioapicwrite>
}
8010207d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102080:	c9                   	leave  
80102081:	c3                   	ret    

80102082 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102082:	55                   	push   %ebp
80102083:	89 e5                	mov    %esp,%ebp
80102085:	53                   	push   %ebx
80102086:	83 ec 04             	sub    $0x4,%esp
80102089:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010208c:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102092:	75 4c                	jne    801020e0 <kfree+0x5e>
80102094:	81 fb 10 72 11 80    	cmp    $0x80117210,%ebx
8010209a:	72 44                	jb     801020e0 <kfree+0x5e>
8010209c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801020a2:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801020a7:	77 37                	ja     801020e0 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801020a9:	83 ec 04             	sub    $0x4,%esp
801020ac:	68 00 10 00 00       	push   $0x1000
801020b1:	6a 01                	push   $0x1
801020b3:	53                   	push   %ebx
801020b4:	e8 66 1f 00 00       	call   8010401f <memset>

  if(kmem.use_lock)
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	83 3d c4 31 11 80 00 	cmpl   $0x0,0x801131c4
801020c3:	75 28                	jne    801020ed <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020c5:	a1 c8 31 11 80       	mov    0x801131c8,%eax
801020ca:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020cc:	89 1d c8 31 11 80    	mov    %ebx,0x801131c8
  if(kmem.use_lock)
801020d2:	83 3d c4 31 11 80 00 	cmpl   $0x0,0x801131c4
801020d9:	75 24                	jne    801020ff <kfree+0x7d>
    release(&kmem.lock);
}
801020db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020de:	c9                   	leave  
801020df:	c3                   	ret    
    panic("kfree");
801020e0:	83 ec 0c             	sub    $0xc,%esp
801020e3:	68 26 6e 10 80       	push   $0x80106e26
801020e8:	e8 9b e2 ff ff       	call   80100388 <panic>
    acquire(&kmem.lock);
801020ed:	83 ec 0c             	sub    $0xc,%esp
801020f0:	68 40 31 11 80       	push   $0x80113140
801020f5:	e8 01 1e 00 00       	call   80103efb <acquire>
801020fa:	83 c4 10             	add    $0x10,%esp
801020fd:	eb c6                	jmp    801020c5 <kfree+0x43>
    release(&kmem.lock);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	68 40 31 11 80       	push   $0x80113140
80102107:	e8 54 1e 00 00       	call   80103f60 <release>
8010210c:	83 c4 10             	add    $0x10,%esp
}
8010210f:	eb ca                	jmp    801020db <kfree+0x59>

80102111 <freerange>:
{
80102111:	55                   	push   %ebp
80102112:	89 e5                	mov    %esp,%ebp
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102119:	8b 45 08             	mov    0x8(%ebp),%eax
8010211c:	05 ff 0f 00 00       	add    $0xfff,%eax
80102121:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102126:	eb 0e                	jmp    80102136 <freerange+0x25>
    kfree(p);
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	50                   	push   %eax
8010212c:	e8 51 ff ff ff       	call   80102082 <kfree>
80102131:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102134:	89 f0                	mov    %esi,%eax
80102136:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
8010213c:	39 de                	cmp    %ebx,%esi
8010213e:	76 e8                	jbe    80102128 <freerange+0x17>
}
80102140:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102143:	5b                   	pop    %ebx
80102144:	5e                   	pop    %esi
80102145:	5d                   	pop    %ebp
80102146:	c3                   	ret    

80102147 <kinit1>:
{
80102147:	55                   	push   %ebp
80102148:	89 e5                	mov    %esp,%ebp
8010214a:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010214d:	68 2c 6e 10 80       	push   $0x80106e2c
80102152:	68 40 31 11 80       	push   $0x80113140
80102157:	e8 63 1c 00 00       	call   80103dbf <initlock>
  kmem.use_lock = 0;
8010215c:	c7 05 c4 31 11 80 00 	movl   $0x0,0x801131c4
80102163:	00 00 00 
  freerange(vstart, vend);
80102166:	83 c4 08             	add    $0x8,%esp
80102169:	ff 75 0c             	push   0xc(%ebp)
8010216c:	ff 75 08             	push   0x8(%ebp)
8010216f:	e8 9d ff ff ff       	call   80102111 <freerange>
}
80102174:	83 c4 10             	add    $0x10,%esp
80102177:	c9                   	leave  
80102178:	c3                   	ret    

80102179 <kinit2>:
{
80102179:	55                   	push   %ebp
8010217a:	89 e5                	mov    %esp,%ebp
8010217c:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
8010217f:	ff 75 0c             	push   0xc(%ebp)
80102182:	ff 75 08             	push   0x8(%ebp)
80102185:	e8 87 ff ff ff       	call   80102111 <freerange>
  kmem.use_lock = 1;
8010218a:	c7 05 c4 31 11 80 01 	movl   $0x1,0x801131c4
80102191:	00 00 00 
}
80102194:	83 c4 10             	add    $0x10,%esp
80102197:	c9                   	leave  
80102198:	c3                   	ret    

80102199 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102199:	55                   	push   %ebp
8010219a:	89 e5                	mov    %esp,%ebp
8010219c:	53                   	push   %ebx
8010219d:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801021a0:	83 3d c4 31 11 80 00 	cmpl   $0x0,0x801131c4
801021a7:	75 21                	jne    801021ca <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801021a9:	8b 1d c8 31 11 80    	mov    0x801131c8,%ebx
  if(r)
801021af:	85 db                	test   %ebx,%ebx
801021b1:	74 07                	je     801021ba <kalloc+0x21>
    kmem.freelist = r->next;
801021b3:	8b 03                	mov    (%ebx),%eax
801021b5:	a3 c8 31 11 80       	mov    %eax,0x801131c8
  if(kmem.use_lock)
801021ba:	83 3d c4 31 11 80 00 	cmpl   $0x0,0x801131c4
801021c1:	75 19                	jne    801021dc <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
801021c3:	89 d8                	mov    %ebx,%eax
801021c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021c8:	c9                   	leave  
801021c9:	c3                   	ret    
    acquire(&kmem.lock);
801021ca:	83 ec 0c             	sub    $0xc,%esp
801021cd:	68 40 31 11 80       	push   $0x80113140
801021d2:	e8 24 1d 00 00       	call   80103efb <acquire>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	eb cd                	jmp    801021a9 <kalloc+0x10>
    release(&kmem.lock);
801021dc:	83 ec 0c             	sub    $0xc,%esp
801021df:	68 40 31 11 80       	push   $0x80113140
801021e4:	e8 77 1d 00 00       	call   80103f60 <release>
801021e9:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021ec:	eb d5                	jmp    801021c3 <kalloc+0x2a>

801021ee <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ee:	ba 64 00 00 00       	mov    $0x64,%edx
801021f3:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021f4:	a8 01                	test   $0x1,%al
801021f6:	0f 84 b4 00 00 00    	je     801022b0 <kbdgetc+0xc2>
801021fc:	ba 60 00 00 00       	mov    $0x60,%edx
80102201:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102202:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102205:	3c e0                	cmp    $0xe0,%al
80102207:	74 61                	je     8010226a <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102209:	84 c0                	test   %al,%al
8010220b:	78 6a                	js     80102277 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010220d:	8b 15 cc 31 11 80    	mov    0x801131cc,%edx
80102213:	f6 c2 40             	test   $0x40,%dl
80102216:	74 0f                	je     80102227 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102218:	83 c8 80             	or     $0xffffff80,%eax
8010221b:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
8010221e:	83 e2 bf             	and    $0xffffffbf,%edx
80102221:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
  }

  shift |= shiftcode[data];
80102227:	0f b6 91 60 6f 10 80 	movzbl -0x7fef90a0(%ecx),%edx
8010222e:	0b 15 cc 31 11 80    	or     0x801131cc,%edx
80102234:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
  shift ^= togglecode[data];
8010223a:	0f b6 81 60 6e 10 80 	movzbl -0x7fef91a0(%ecx),%eax
80102241:	31 c2                	xor    %eax,%edx
80102243:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
  c = charcode[shift & (CTL | SHIFT)][data];
80102249:	89 d0                	mov    %edx,%eax
8010224b:	83 e0 03             	and    $0x3,%eax
8010224e:	8b 04 85 40 6e 10 80 	mov    -0x7fef91c0(,%eax,4),%eax
80102255:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102259:	f6 c2 08             	test   $0x8,%dl
8010225c:	74 57                	je     801022b5 <kbdgetc+0xc7>
    if('a' <= c && c <= 'z')
8010225e:	8d 50 9f             	lea    -0x61(%eax),%edx
80102261:	83 fa 19             	cmp    $0x19,%edx
80102264:	77 3e                	ja     801022a4 <kbdgetc+0xb6>
      c += 'A' - 'a';
80102266:	83 e8 20             	sub    $0x20,%eax
80102269:	c3                   	ret    
    shift |= E0ESC;
8010226a:	83 0d cc 31 11 80 40 	orl    $0x40,0x801131cc
    return 0;
80102271:	b8 00 00 00 00       	mov    $0x0,%eax
80102276:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102277:	8b 15 cc 31 11 80    	mov    0x801131cc,%edx
8010227d:	f6 c2 40             	test   $0x40,%dl
80102280:	75 05                	jne    80102287 <kbdgetc+0x99>
80102282:	89 c1                	mov    %eax,%ecx
80102284:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102287:	0f b6 81 60 6f 10 80 	movzbl -0x7fef90a0(%ecx),%eax
8010228e:	83 c8 40             	or     $0x40,%eax
80102291:	0f b6 c0             	movzbl %al,%eax
80102294:	f7 d0                	not    %eax
80102296:	21 c2                	and    %eax,%edx
80102298:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
    return 0;
8010229e:	b8 00 00 00 00       	mov    $0x0,%eax
801022a3:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
801022a4:	8d 50 bf             	lea    -0x41(%eax),%edx
801022a7:	83 fa 19             	cmp    $0x19,%edx
801022aa:	77 09                	ja     801022b5 <kbdgetc+0xc7>
      c += 'a' - 'A';
801022ac:	83 c0 20             	add    $0x20,%eax
  }
  return c;
801022af:	c3                   	ret    
    return -1;
801022b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801022b5:	c3                   	ret    

801022b6 <kbdintr>:

void
kbdintr(void)
{
801022b6:	55                   	push   %ebp
801022b7:	89 e5                	mov    %esp,%ebp
801022b9:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801022bc:	68 ee 21 10 80       	push   $0x801021ee
801022c1:	e8 ad e4 ff ff       	call   80100773 <consoleintr>
}
801022c6:	83 c4 10             	add    $0x10,%esp
801022c9:	c9                   	leave  
801022ca:	c3                   	ret    

801022cb <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801022cb:	8b 0d d0 31 11 80    	mov    0x801131d0,%ecx
801022d1:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022d4:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022d6:	a1 d0 31 11 80       	mov    0x801131d0,%eax
801022db:	8b 40 20             	mov    0x20(%eax),%eax
}
801022de:	c3                   	ret    

801022df <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022df:	ba 70 00 00 00       	mov    $0x70,%edx
801022e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e5:	ba 71 00 00 00       	mov    $0x71,%edx
801022ea:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801022eb:	0f b6 c0             	movzbl %al,%eax
}
801022ee:	c3                   	ret    

801022ef <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801022ef:	55                   	push   %ebp
801022f0:	89 e5                	mov    %esp,%ebp
801022f2:	53                   	push   %ebx
801022f3:	83 ec 04             	sub    $0x4,%esp
801022f6:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801022f8:	b8 00 00 00 00       	mov    $0x0,%eax
801022fd:	e8 dd ff ff ff       	call   801022df <cmos_read>
80102302:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102304:	b8 02 00 00 00       	mov    $0x2,%eax
80102309:	e8 d1 ff ff ff       	call   801022df <cmos_read>
8010230e:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102311:	b8 04 00 00 00       	mov    $0x4,%eax
80102316:	e8 c4 ff ff ff       	call   801022df <cmos_read>
8010231b:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
8010231e:	b8 07 00 00 00       	mov    $0x7,%eax
80102323:	e8 b7 ff ff ff       	call   801022df <cmos_read>
80102328:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
8010232b:	b8 08 00 00 00       	mov    $0x8,%eax
80102330:	e8 aa ff ff ff       	call   801022df <cmos_read>
80102335:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102338:	b8 09 00 00 00       	mov    $0x9,%eax
8010233d:	e8 9d ff ff ff       	call   801022df <cmos_read>
80102342:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102348:	c9                   	leave  
80102349:	c3                   	ret    

8010234a <lapicinit>:
  if(!lapic)
8010234a:	83 3d d0 31 11 80 00 	cmpl   $0x0,0x801131d0
80102351:	0f 84 fe 00 00 00    	je     80102455 <lapicinit+0x10b>
{
80102357:	55                   	push   %ebp
80102358:	89 e5                	mov    %esp,%ebp
8010235a:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010235d:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102362:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102367:	e8 5f ff ff ff       	call   801022cb <lapicw>
  lapicw(TDCR, X1);
8010236c:	ba 0b 00 00 00       	mov    $0xb,%edx
80102371:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102376:	e8 50 ff ff ff       	call   801022cb <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010237b:	ba 20 00 02 00       	mov    $0x20020,%edx
80102380:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102385:	e8 41 ff ff ff       	call   801022cb <lapicw>
  lapicw(TICR, 10000000);
8010238a:	ba 80 96 98 00       	mov    $0x989680,%edx
8010238f:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102394:	e8 32 ff ff ff       	call   801022cb <lapicw>
  lapicw(LINT0, MASKED);
80102399:	ba 00 00 01 00       	mov    $0x10000,%edx
8010239e:	b8 d4 00 00 00       	mov    $0xd4,%eax
801023a3:	e8 23 ff ff ff       	call   801022cb <lapicw>
  lapicw(LINT1, MASKED);
801023a8:	ba 00 00 01 00       	mov    $0x10000,%edx
801023ad:	b8 d8 00 00 00       	mov    $0xd8,%eax
801023b2:	e8 14 ff ff ff       	call   801022cb <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023b7:	a1 d0 31 11 80       	mov    0x801131d0,%eax
801023bc:	8b 40 30             	mov    0x30(%eax),%eax
801023bf:	c1 e8 10             	shr    $0x10,%eax
801023c2:	a8 fc                	test   $0xfc,%al
801023c4:	75 7b                	jne    80102441 <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023c6:	ba 33 00 00 00       	mov    $0x33,%edx
801023cb:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023d0:	e8 f6 fe ff ff       	call   801022cb <lapicw>
  lapicw(ESR, 0);
801023d5:	ba 00 00 00 00       	mov    $0x0,%edx
801023da:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023df:	e8 e7 fe ff ff       	call   801022cb <lapicw>
  lapicw(ESR, 0);
801023e4:	ba 00 00 00 00       	mov    $0x0,%edx
801023e9:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023ee:	e8 d8 fe ff ff       	call   801022cb <lapicw>
  lapicw(EOI, 0);
801023f3:	ba 00 00 00 00       	mov    $0x0,%edx
801023f8:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023fd:	e8 c9 fe ff ff       	call   801022cb <lapicw>
  lapicw(ICRHI, 0);
80102402:	ba 00 00 00 00       	mov    $0x0,%edx
80102407:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010240c:	e8 ba fe ff ff       	call   801022cb <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102411:	ba 00 85 08 00       	mov    $0x88500,%edx
80102416:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241b:	e8 ab fe ff ff       	call   801022cb <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102420:	a1 d0 31 11 80       	mov    0x801131d0,%eax
80102425:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
8010242b:	f6 c4 10             	test   $0x10,%ah
8010242e:	75 f0                	jne    80102420 <lapicinit+0xd6>
  lapicw(TPR, 0);
80102430:	ba 00 00 00 00       	mov    $0x0,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	e8 8c fe ff ff       	call   801022cb <lapicw>
}
8010243f:	c9                   	leave  
80102440:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102441:	ba 00 00 01 00       	mov    $0x10000,%edx
80102446:	b8 d0 00 00 00       	mov    $0xd0,%eax
8010244b:	e8 7b fe ff ff       	call   801022cb <lapicw>
80102450:	e9 71 ff ff ff       	jmp    801023c6 <lapicinit+0x7c>
80102455:	c3                   	ret    

80102456 <lapicid>:
  if (!lapic)
80102456:	a1 d0 31 11 80       	mov    0x801131d0,%eax
8010245b:	85 c0                	test   %eax,%eax
8010245d:	74 07                	je     80102466 <lapicid+0x10>
  return lapic[ID] >> 24;
8010245f:	8b 40 20             	mov    0x20(%eax),%eax
80102462:	c1 e8 18             	shr    $0x18,%eax
80102465:	c3                   	ret    
    return 0;
80102466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010246b:	c3                   	ret    

8010246c <lapiceoi>:
  if(lapic)
8010246c:	83 3d d0 31 11 80 00 	cmpl   $0x0,0x801131d0
80102473:	74 17                	je     8010248c <lapiceoi+0x20>
{
80102475:	55                   	push   %ebp
80102476:	89 e5                	mov    %esp,%ebp
80102478:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
8010247b:	ba 00 00 00 00       	mov    $0x0,%edx
80102480:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102485:	e8 41 fe ff ff       	call   801022cb <lapicw>
}
8010248a:	c9                   	leave  
8010248b:	c3                   	ret    
8010248c:	c3                   	ret    

8010248d <microdelay>:
}
8010248d:	c3                   	ret    

8010248e <lapicstartap>:
{
8010248e:	55                   	push   %ebp
8010248f:	89 e5                	mov    %esp,%ebp
80102491:	57                   	push   %edi
80102492:	56                   	push   %esi
80102493:	53                   	push   %ebx
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	8b 75 08             	mov    0x8(%ebp),%esi
8010249a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010249d:	b8 0f 00 00 00       	mov    $0xf,%eax
801024a2:	ba 70 00 00 00       	mov    $0x70,%edx
801024a7:	ee                   	out    %al,(%dx)
801024a8:	b8 0a 00 00 00       	mov    $0xa,%eax
801024ad:	ba 71 00 00 00       	mov    $0x71,%edx
801024b2:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024b3:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024ba:	00 00 
  wrv[1] = addr >> 4;
801024bc:	89 f8                	mov    %edi,%eax
801024be:	c1 e8 04             	shr    $0x4,%eax
801024c1:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024c7:	c1 e6 18             	shl    $0x18,%esi
801024ca:	89 f2                	mov    %esi,%edx
801024cc:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024d1:	e8 f5 fd ff ff       	call   801022cb <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024d6:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024db:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024e0:	e8 e6 fd ff ff       	call   801022cb <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024e5:	ba 00 85 00 00       	mov    $0x8500,%edx
801024ea:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024ef:	e8 d7 fd ff ff       	call   801022cb <lapicw>
  for(i = 0; i < 2; i++){
801024f4:	bb 00 00 00 00       	mov    $0x0,%ebx
801024f9:	eb 21                	jmp    8010251c <lapicstartap+0x8e>
    lapicw(ICRHI, apicid<<24);
801024fb:	89 f2                	mov    %esi,%edx
801024fd:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102502:	e8 c4 fd ff ff       	call   801022cb <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102507:	89 fa                	mov    %edi,%edx
80102509:	c1 ea 0c             	shr    $0xc,%edx
8010250c:	80 ce 06             	or     $0x6,%dh
8010250f:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102514:	e8 b2 fd ff ff       	call   801022cb <lapicw>
  for(i = 0; i < 2; i++){
80102519:	83 c3 01             	add    $0x1,%ebx
8010251c:	83 fb 01             	cmp    $0x1,%ebx
8010251f:	7e da                	jle    801024fb <lapicstartap+0x6d>
}
80102521:	83 c4 0c             	add    $0xc,%esp
80102524:	5b                   	pop    %ebx
80102525:	5e                   	pop    %esi
80102526:	5f                   	pop    %edi
80102527:	5d                   	pop    %ebp
80102528:	c3                   	ret    

80102529 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102529:	55                   	push   %ebp
8010252a:	89 e5                	mov    %esp,%ebp
8010252c:	57                   	push   %edi
8010252d:	56                   	push   %esi
8010252e:	53                   	push   %ebx
8010252f:	83 ec 3c             	sub    $0x3c,%esp
80102532:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102535:	b8 0b 00 00 00       	mov    $0xb,%eax
8010253a:	e8 a0 fd ff ff       	call   801022df <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
8010253f:	83 e0 04             	and    $0x4,%eax
80102542:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102544:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102547:	e8 a3 fd ff ff       	call   801022ef <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010254c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102551:	e8 89 fd ff ff       	call   801022df <cmos_read>
80102556:	a8 80                	test   $0x80,%al
80102558:	75 ea                	jne    80102544 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
8010255a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010255d:	89 d8                	mov    %ebx,%eax
8010255f:	e8 8b fd ff ff       	call   801022ef <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102564:	83 ec 04             	sub    $0x4,%esp
80102567:	6a 18                	push   $0x18
80102569:	53                   	push   %ebx
8010256a:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010256d:	50                   	push   %eax
8010256e:	e8 ef 1a 00 00       	call   80104062 <memcmp>
80102573:	83 c4 10             	add    $0x10,%esp
80102576:	85 c0                	test   %eax,%eax
80102578:	75 ca                	jne    80102544 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
8010257a:	85 ff                	test   %edi,%edi
8010257c:	75 78                	jne    801025f6 <cmostime+0xcd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010257e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102581:	89 c2                	mov    %eax,%edx
80102583:	c1 ea 04             	shr    $0x4,%edx
80102586:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102589:	83 e0 0f             	and    $0xf,%eax
8010258c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010258f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102595:	89 c2                	mov    %eax,%edx
80102597:	c1 ea 04             	shr    $0x4,%edx
8010259a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259d:	83 e0 0f             	and    $0xf,%eax
801025a0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025a9:	89 c2                	mov    %eax,%edx
801025ab:	c1 ea 04             	shr    $0x4,%edx
801025ae:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b1:	83 e0 0f             	and    $0xf,%eax
801025b4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025bd:	89 c2                	mov    %eax,%edx
801025bf:	c1 ea 04             	shr    $0x4,%edx
801025c2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c5:	83 e0 0f             	and    $0xf,%eax
801025c8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025d1:	89 c2                	mov    %eax,%edx
801025d3:	c1 ea 04             	shr    $0x4,%edx
801025d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025d9:	83 e0 0f             	and    $0xf,%eax
801025dc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025df:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025e5:	89 c2                	mov    %eax,%edx
801025e7:	c1 ea 04             	shr    $0x4,%edx
801025ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ed:	83 e0 0f             	and    $0xf,%eax
801025f0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025f9:	89 06                	mov    %eax,(%esi)
801025fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025fe:	89 46 04             	mov    %eax,0x4(%esi)
80102601:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102604:	89 46 08             	mov    %eax,0x8(%esi)
80102607:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010260a:	89 46 0c             	mov    %eax,0xc(%esi)
8010260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102610:	89 46 10             	mov    %eax,0x10(%esi)
80102613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102616:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102619:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102623:	5b                   	pop    %ebx
80102624:	5e                   	pop    %esi
80102625:	5f                   	pop    %edi
80102626:	5d                   	pop    %ebp
80102627:	c3                   	ret    

80102628 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102628:	55                   	push   %ebp
80102629:	89 e5                	mov    %esp,%ebp
8010262b:	53                   	push   %ebx
8010262c:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010262f:	ff 35 64 32 11 80    	push   0x80113264
80102635:	ff 35 74 32 11 80    	push   0x80113274
8010263b:	e8 47 db ff ff       	call   80100187 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102640:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80102646:	89 1d 78 32 11 80    	mov    %ebx,0x80113278
  for (i = 0; i < log.lh.n; i++) {
8010264c:	83 c4 10             	add    $0x10,%esp
8010264f:	ba 00 00 00 00       	mov    $0x0,%edx
80102654:	eb 11                	jmp    80102667 <read_head+0x3f>
    log.lh.block[i] = lh->block[i];
80102656:	8b 8c 90 b0 00 00 00 	mov    0xb0(%eax,%edx,4),%ecx
8010265d:	89 0c 95 7c 32 11 80 	mov    %ecx,-0x7feecd84(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102664:	83 c2 01             	add    $0x1,%edx
80102667:	39 d3                	cmp    %edx,%ebx
80102669:	7f eb                	jg     80102656 <read_head+0x2e>
  }
  brelse(buf);
8010266b:	83 ec 0c             	sub    $0xc,%esp
8010266e:	50                   	push   %eax
8010266f:	e8 7c db ff ff       	call   801001f0 <brelse>
}
80102674:	83 c4 10             	add    $0x10,%esp
80102677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010267a:	c9                   	leave  
8010267b:	c3                   	ret    

8010267c <install_trans>:
{
8010267c:	55                   	push   %ebp
8010267d:	89 e5                	mov    %esp,%ebp
8010267f:	57                   	push   %edi
80102680:	56                   	push   %esi
80102681:	53                   	push   %ebx
80102682:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102685:	be 00 00 00 00       	mov    $0x0,%esi
8010268a:	eb 6c                	jmp    801026f8 <install_trans+0x7c>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010268c:	89 f0                	mov    %esi,%eax
8010268e:	03 05 64 32 11 80    	add    0x80113264,%eax
80102694:	83 c0 01             	add    $0x1,%eax
80102697:	83 ec 08             	sub    $0x8,%esp
8010269a:	50                   	push   %eax
8010269b:	ff 35 74 32 11 80    	push   0x80113274
801026a1:	e8 e1 da ff ff       	call   80100187 <bread>
801026a6:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801026a8:	83 c4 08             	add    $0x8,%esp
801026ab:	ff 34 b5 7c 32 11 80 	push   -0x7feecd84(,%esi,4)
801026b2:	ff 35 74 32 11 80    	push   0x80113274
801026b8:	e8 ca da ff ff       	call   80100187 <bread>
801026bd:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801026bf:	8d 97 ac 00 00 00    	lea    0xac(%edi),%edx
801026c5:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
801026cb:	83 c4 0c             	add    $0xc,%esp
801026ce:	68 00 02 00 00       	push   $0x200
801026d3:	52                   	push   %edx
801026d4:	50                   	push   %eax
801026d5:	e8 bd 19 00 00       	call   80104097 <memmove>
    bwrite(dbuf);  // write dst to disk
801026da:	89 1c 24             	mov    %ebx,(%esp)
801026dd:	e8 d3 da ff ff       	call   801001b5 <bwrite>
    brelse(lbuf);
801026e2:	89 3c 24             	mov    %edi,(%esp)
801026e5:	e8 06 db ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801026ea:	89 1c 24             	mov    %ebx,(%esp)
801026ed:	e8 fe da ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026f2:	83 c6 01             	add    $0x1,%esi
801026f5:	83 c4 10             	add    $0x10,%esp
801026f8:	39 35 78 32 11 80    	cmp    %esi,0x80113278
801026fe:	7f 8c                	jg     8010268c <install_trans+0x10>
}
80102700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102703:	5b                   	pop    %ebx
80102704:	5e                   	pop    %esi
80102705:	5f                   	pop    %edi
80102706:	5d                   	pop    %ebp
80102707:	c3                   	ret    

80102708 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102708:	55                   	push   %ebp
80102709:	89 e5                	mov    %esp,%ebp
8010270b:	53                   	push   %ebx
8010270c:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010270f:	ff 35 64 32 11 80    	push   0x80113264
80102715:	ff 35 74 32 11 80    	push   0x80113274
8010271b:	e8 67 da ff ff       	call   80100187 <bread>
80102720:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102722:	8b 0d 78 32 11 80    	mov    0x80113278,%ecx
80102728:	89 88 ac 00 00 00    	mov    %ecx,0xac(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010272e:	83 c4 10             	add    $0x10,%esp
80102731:	b8 00 00 00 00       	mov    $0x0,%eax
80102736:	eb 11                	jmp    80102749 <write_head+0x41>
    hb->block[i] = log.lh.block[i];
80102738:	8b 14 85 7c 32 11 80 	mov    -0x7feecd84(,%eax,4),%edx
8010273f:	89 94 83 b0 00 00 00 	mov    %edx,0xb0(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102746:	83 c0 01             	add    $0x1,%eax
80102749:	39 c1                	cmp    %eax,%ecx
8010274b:	7f eb                	jg     80102738 <write_head+0x30>
  }
  bwrite(buf);
8010274d:	83 ec 0c             	sub    $0xc,%esp
80102750:	53                   	push   %ebx
80102751:	e8 5f da ff ff       	call   801001b5 <bwrite>
  brelse(buf);
80102756:	89 1c 24             	mov    %ebx,(%esp)
80102759:	e8 92 da ff ff       	call   801001f0 <brelse>
}
8010275e:	83 c4 10             	add    $0x10,%esp
80102761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102764:	c9                   	leave  
80102765:	c3                   	ret    

80102766 <recover_from_log>:

static void
recover_from_log(void)
{
80102766:	55                   	push   %ebp
80102767:	89 e5                	mov    %esp,%ebp
80102769:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010276c:	e8 b7 fe ff ff       	call   80102628 <read_head>
  install_trans(); // if committed, copy from log to disk
80102771:	e8 06 ff ff ff       	call   8010267c <install_trans>
  log.lh.n = 0;
80102776:	c7 05 78 32 11 80 00 	movl   $0x0,0x80113278
8010277d:	00 00 00 
  write_head(); // clear the log
80102780:	e8 83 ff ff ff       	call   80102708 <write_head>
}
80102785:	c9                   	leave  
80102786:	c3                   	ret    

80102787 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80102787:	55                   	push   %ebp
80102788:	89 e5                	mov    %esp,%ebp
8010278a:	57                   	push   %edi
8010278b:	56                   	push   %esi
8010278c:	53                   	push   %ebx
8010278d:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102790:	be 00 00 00 00       	mov    $0x0,%esi
80102795:	eb 6c                	jmp    80102803 <write_log+0x7c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102797:	89 f0                	mov    %esi,%eax
80102799:	03 05 64 32 11 80    	add    0x80113264,%eax
8010279f:	83 c0 01             	add    $0x1,%eax
801027a2:	83 ec 08             	sub    $0x8,%esp
801027a5:	50                   	push   %eax
801027a6:	ff 35 74 32 11 80    	push   0x80113274
801027ac:	e8 d6 d9 ff ff       	call   80100187 <bread>
801027b1:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801027b3:	83 c4 08             	add    $0x8,%esp
801027b6:	ff 34 b5 7c 32 11 80 	push   -0x7feecd84(,%esi,4)
801027bd:	ff 35 74 32 11 80    	push   0x80113274
801027c3:	e8 bf d9 ff ff       	call   80100187 <bread>
801027c8:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801027ca:	8d 90 ac 00 00 00    	lea    0xac(%eax),%edx
801027d0:	8d 83 ac 00 00 00    	lea    0xac(%ebx),%eax
801027d6:	83 c4 0c             	add    $0xc,%esp
801027d9:	68 00 02 00 00       	push   $0x200
801027de:	52                   	push   %edx
801027df:	50                   	push   %eax
801027e0:	e8 b2 18 00 00       	call   80104097 <memmove>
    bwrite(to);  // write the log
801027e5:	89 1c 24             	mov    %ebx,(%esp)
801027e8:	e8 c8 d9 ff ff       	call   801001b5 <bwrite>
    brelse(from);
801027ed:	89 3c 24             	mov    %edi,(%esp)
801027f0:	e8 fb d9 ff ff       	call   801001f0 <brelse>
    brelse(to);
801027f5:	89 1c 24             	mov    %ebx,(%esp)
801027f8:	e8 f3 d9 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801027fd:	83 c6 01             	add    $0x1,%esi
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	39 35 78 32 11 80    	cmp    %esi,0x80113278
80102809:	7f 8c                	jg     80102797 <write_log+0x10>
  }
}
8010280b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010280e:	5b                   	pop    %ebx
8010280f:	5e                   	pop    %esi
80102810:	5f                   	pop    %edi
80102811:	5d                   	pop    %ebp
80102812:	c3                   	ret    

80102813 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102813:	83 3d 78 32 11 80 00 	cmpl   $0x0,0x80113278
8010281a:	7f 01                	jg     8010281d <commit+0xa>
8010281c:	c3                   	ret    
{
8010281d:	55                   	push   %ebp
8010281e:	89 e5                	mov    %esp,%ebp
80102820:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102823:	e8 5f ff ff ff       	call   80102787 <write_log>
    write_head();    // Write header to disk -- the real commit
80102828:	e8 db fe ff ff       	call   80102708 <write_head>
    install_trans(); // Now install writes to home locations
8010282d:	e8 4a fe ff ff       	call   8010267c <install_trans>
    log.lh.n = 0;
80102832:	c7 05 78 32 11 80 00 	movl   $0x0,0x80113278
80102839:	00 00 00 
    write_head();    // Erase the transaction from the log
8010283c:	e8 c7 fe ff ff       	call   80102708 <write_head>
  }
}
80102841:	c9                   	leave  
80102842:	c3                   	ret    

80102843 <initlog>:
{
80102843:	55                   	push   %ebp
80102844:	89 e5                	mov    %esp,%ebp
80102846:	53                   	push   %ebx
80102847:	83 ec 2c             	sub    $0x2c,%esp
8010284a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010284d:	68 60 70 10 80       	push   $0x80107060
80102852:	68 e0 31 11 80       	push   $0x801131e0
80102857:	e8 63 15 00 00       	call   80103dbf <initlock>
  readsb(dev, &sb);
8010285c:	83 c4 08             	add    $0x8,%esp
8010285f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102862:	50                   	push   %eax
80102863:	53                   	push   %ebx
80102864:	e8 9c ea ff ff       	call   80101305 <readsb>
  log.start = sb.logstart;
80102869:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010286c:	a3 64 32 11 80       	mov    %eax,0x80113264
  log.size = sb.nlog;
80102871:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102874:	a3 68 32 11 80       	mov    %eax,0x80113268
  log.dev = dev;
80102879:	89 1d 74 32 11 80    	mov    %ebx,0x80113274
  recover_from_log();
8010287f:	e8 e2 fe ff ff       	call   80102766 <recover_from_log>
}
80102884:	83 c4 10             	add    $0x10,%esp
80102887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288a:	c9                   	leave  
8010288b:	c3                   	ret    

8010288c <begin_op>:
{
8010288c:	55                   	push   %ebp
8010288d:	89 e5                	mov    %esp,%ebp
8010288f:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102892:	68 e0 31 11 80       	push   $0x801131e0
80102897:	e8 5f 16 00 00       	call   80103efb <acquire>
8010289c:	83 c4 10             	add    $0x10,%esp
8010289f:	eb 15                	jmp    801028b6 <begin_op+0x2a>
      sleep(&log, &log.lock);
801028a1:	83 ec 08             	sub    $0x8,%esp
801028a4:	68 e0 31 11 80       	push   $0x801131e0
801028a9:	68 e0 31 11 80       	push   $0x801131e0
801028ae:	e8 dd 0e 00 00       	call   80103790 <sleep>
801028b3:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801028b6:	83 3d 70 32 11 80 00 	cmpl   $0x0,0x80113270
801028bd:	75 e2                	jne    801028a1 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801028bf:	a1 6c 32 11 80       	mov    0x8011326c,%eax
801028c4:	83 c0 01             	add    $0x1,%eax
801028c7:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801028ca:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
801028cd:	03 15 78 32 11 80    	add    0x80113278,%edx
801028d3:	83 fa 1e             	cmp    $0x1e,%edx
801028d6:	7e 17                	jle    801028ef <begin_op+0x63>
      sleep(&log, &log.lock);
801028d8:	83 ec 08             	sub    $0x8,%esp
801028db:	68 e0 31 11 80       	push   $0x801131e0
801028e0:	68 e0 31 11 80       	push   $0x801131e0
801028e5:	e8 a6 0e 00 00       	call   80103790 <sleep>
801028ea:	83 c4 10             	add    $0x10,%esp
801028ed:	eb c7                	jmp    801028b6 <begin_op+0x2a>
      log.outstanding += 1;
801028ef:	a3 6c 32 11 80       	mov    %eax,0x8011326c
      release(&log.lock);
801028f4:	83 ec 0c             	sub    $0xc,%esp
801028f7:	68 e0 31 11 80       	push   $0x801131e0
801028fc:	e8 5f 16 00 00       	call   80103f60 <release>
}
80102901:	83 c4 10             	add    $0x10,%esp
80102904:	c9                   	leave  
80102905:	c3                   	ret    

80102906 <end_op>:
{
80102906:	55                   	push   %ebp
80102907:	89 e5                	mov    %esp,%ebp
80102909:	53                   	push   %ebx
8010290a:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010290d:	68 e0 31 11 80       	push   $0x801131e0
80102912:	e8 e4 15 00 00       	call   80103efb <acquire>
  log.outstanding -= 1;
80102917:	a1 6c 32 11 80       	mov    0x8011326c,%eax
8010291c:	83 e8 01             	sub    $0x1,%eax
8010291f:	a3 6c 32 11 80       	mov    %eax,0x8011326c
  if(log.committing)
80102924:	8b 1d 70 32 11 80    	mov    0x80113270,%ebx
8010292a:	83 c4 10             	add    $0x10,%esp
8010292d:	85 db                	test   %ebx,%ebx
8010292f:	75 2c                	jne    8010295d <end_op+0x57>
  if(log.outstanding == 0){
80102931:	85 c0                	test   %eax,%eax
80102933:	75 35                	jne    8010296a <end_op+0x64>
    log.committing = 1;
80102935:	c7 05 70 32 11 80 01 	movl   $0x1,0x80113270
8010293c:	00 00 00 
    do_commit = 1;
8010293f:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 e0 31 11 80       	push   $0x801131e0
8010294c:	e8 0f 16 00 00       	call   80103f60 <release>
  if(do_commit){
80102951:	83 c4 10             	add    $0x10,%esp
80102954:	85 db                	test   %ebx,%ebx
80102956:	75 24                	jne    8010297c <end_op+0x76>
}
80102958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010295b:	c9                   	leave  
8010295c:	c3                   	ret    
    panic("log.committing");
8010295d:	83 ec 0c             	sub    $0xc,%esp
80102960:	68 64 70 10 80       	push   $0x80107064
80102965:	e8 1e da ff ff       	call   80100388 <panic>
    wakeup(&log);
8010296a:	83 ec 0c             	sub    $0xc,%esp
8010296d:	68 e0 31 11 80       	push   $0x801131e0
80102972:	e8 7e 0f 00 00       	call   801038f5 <wakeup>
80102977:	83 c4 10             	add    $0x10,%esp
8010297a:	eb c8                	jmp    80102944 <end_op+0x3e>
    commit();
8010297c:	e8 92 fe ff ff       	call   80102813 <commit>
    acquire(&log.lock);
80102981:	83 ec 0c             	sub    $0xc,%esp
80102984:	68 e0 31 11 80       	push   $0x801131e0
80102989:	e8 6d 15 00 00       	call   80103efb <acquire>
    log.committing = 0;
8010298e:	c7 05 70 32 11 80 00 	movl   $0x0,0x80113270
80102995:	00 00 00 
    wakeup(&log);
80102998:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
8010299f:	e8 51 0f 00 00       	call   801038f5 <wakeup>
    release(&log.lock);
801029a4:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
801029ab:	e8 b0 15 00 00       	call   80103f60 <release>
801029b0:	83 c4 10             	add    $0x10,%esp
}
801029b3:	eb a3                	jmp    80102958 <end_op+0x52>

801029b5 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029b5:	55                   	push   %ebp
801029b6:	89 e5                	mov    %esp,%ebp
801029b8:	53                   	push   %ebx
801029b9:	83 ec 04             	sub    $0x4,%esp
801029bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801029bf:	8b 15 78 32 11 80    	mov    0x80113278,%edx
801029c5:	83 fa 1d             	cmp    $0x1d,%edx
801029c8:	7f 2c                	jg     801029f6 <log_write+0x41>
801029ca:	a1 68 32 11 80       	mov    0x80113268,%eax
801029cf:	83 e8 01             	sub    $0x1,%eax
801029d2:	39 c2                	cmp    %eax,%edx
801029d4:	7d 20                	jge    801029f6 <log_write+0x41>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029d6:	83 3d 6c 32 11 80 00 	cmpl   $0x0,0x8011326c
801029dd:	7e 24                	jle    80102a03 <log_write+0x4e>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 e0 31 11 80       	push   $0x801131e0
801029e7:	e8 0f 15 00 00       	call   80103efb <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029ec:	83 c4 10             	add    $0x10,%esp
801029ef:	b8 00 00 00 00       	mov    $0x0,%eax
801029f4:	eb 1d                	jmp    80102a13 <log_write+0x5e>
    panic("too big a transaction");
801029f6:	83 ec 0c             	sub    $0xc,%esp
801029f9:	68 73 70 10 80       	push   $0x80107073
801029fe:	e8 85 d9 ff ff       	call   80100388 <panic>
    panic("log_write outside of trans");
80102a03:	83 ec 0c             	sub    $0xc,%esp
80102a06:	68 89 70 10 80       	push   $0x80107089
80102a0b:	e8 78 d9 ff ff       	call   80100388 <panic>
  for (i = 0; i < log.lh.n; i++) {
80102a10:	83 c0 01             	add    $0x1,%eax
80102a13:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102a19:	39 c2                	cmp    %eax,%edx
80102a1b:	7e 0c                	jle    80102a29 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a1d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a20:	39 0c 85 7c 32 11 80 	cmp    %ecx,-0x7feecd84(,%eax,4)
80102a27:	75 e7                	jne    80102a10 <log_write+0x5b>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a29:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a2c:	89 0c 85 7c 32 11 80 	mov    %ecx,-0x7feecd84(,%eax,4)
  if (i == log.lh.n)
80102a33:	39 c2                	cmp    %eax,%edx
80102a35:	74 18                	je     80102a4f <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a37:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a3a:	83 ec 0c             	sub    $0xc,%esp
80102a3d:	68 e0 31 11 80       	push   $0x801131e0
80102a42:	e8 19 15 00 00       	call   80103f60 <release>
}
80102a47:	83 c4 10             	add    $0x10,%esp
80102a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a4d:	c9                   	leave  
80102a4e:	c3                   	ret    
    log.lh.n++;
80102a4f:	83 c2 01             	add    $0x1,%edx
80102a52:	89 15 78 32 11 80    	mov    %edx,0x80113278
80102a58:	eb dd                	jmp    80102a37 <log_write+0x82>

80102a5a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102a5a:	55                   	push   %ebp
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	53                   	push   %ebx
80102a5e:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a61:	68 8a 00 00 00       	push   $0x8a
80102a66:	68 8c a4 10 80       	push   $0x8010a48c
80102a6b:	68 00 70 00 80       	push   $0x80007000
80102a70:	e8 22 16 00 00       	call   80104097 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102a75:	83 c4 10             	add    $0x10,%esp
80102a78:	bb 20 33 11 80       	mov    $0x80113320,%ebx
80102a7d:	eb 06                	jmp    80102a85 <startothers+0x2b>
80102a7f:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a85:	69 05 04 33 11 80 b0 	imul   $0xb0,0x80113304,%eax
80102a8c:	00 00 00 
80102a8f:	05 20 33 11 80       	add    $0x80113320,%eax
80102a94:	39 d8                	cmp    %ebx,%eax
80102a96:	76 4c                	jbe    80102ae4 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
80102a98:	e8 b5 07 00 00       	call   80103252 <mycpu>
80102a9d:	39 c3                	cmp    %eax,%ebx
80102a9f:	74 de                	je     80102a7f <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102aa1:	e8 f3 f6 ff ff       	call   80102199 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102aa6:	05 00 10 00 00       	add    $0x1000,%eax
80102aab:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102ab0:	c7 05 f8 6f 00 80 28 	movl   $0x80102b28,0x80006ff8
80102ab7:	2b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102aba:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ac1:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102ac4:	83 ec 08             	sub    $0x8,%esp
80102ac7:	68 00 70 00 00       	push   $0x7000
80102acc:	0f b6 03             	movzbl (%ebx),%eax
80102acf:	50                   	push   %eax
80102ad0:	e8 b9 f9 ff ff       	call   8010248e <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ad5:	83 c4 10             	add    $0x10,%esp
80102ad8:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ade:	85 c0                	test   %eax,%eax
80102ae0:	74 f6                	je     80102ad8 <startothers+0x7e>
80102ae2:	eb 9b                	jmp    80102a7f <startothers+0x25>
      ;
  }
}
80102ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ae7:	c9                   	leave  
80102ae8:	c3                   	ret    

80102ae9 <mpmain>:
{
80102ae9:	55                   	push   %ebp
80102aea:	89 e5                	mov    %esp,%ebp
80102aec:	53                   	push   %ebx
80102aed:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102af0:	e8 b9 07 00 00       	call   801032ae <cpuid>
80102af5:	89 c3                	mov    %eax,%ebx
80102af7:	e8 b2 07 00 00       	call   801032ae <cpuid>
80102afc:	83 ec 04             	sub    $0x4,%esp
80102aff:	53                   	push   %ebx
80102b00:	50                   	push   %eax
80102b01:	68 a4 70 10 80       	push   $0x801070a4
80102b06:	e8 3c db ff ff       	call   80100647 <cprintf>
  idtinit();       // load idt register
80102b0b:	e8 53 28 00 00       	call   80105363 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102b10:	e8 3d 07 00 00       	call   80103252 <mycpu>
80102b15:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b17:	b8 01 00 00 00       	mov    $0x1,%eax
80102b1c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102b23:	e8 1e 0a 00 00       	call   80103546 <scheduler>

80102b28 <mpenter>:
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b2e:	e8 5c 39 00 00       	call   8010648f <switchkvm>
  seginit();
80102b33:	e8 e2 36 00 00       	call   8010621a <seginit>
  lapicinit();
80102b38:	e8 0d f8 ff ff       	call   8010234a <lapicinit>
  mpmain();
80102b3d:	e8 a7 ff ff ff       	call   80102ae9 <mpmain>

80102b42 <main>:
{
80102b42:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b46:	83 e4 f0             	and    $0xfffffff0,%esp
80102b49:	ff 71 fc             	push   -0x4(%ecx)
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	51                   	push   %ecx
80102b50:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b53:	68 00 00 40 80       	push   $0x80400000
80102b58:	68 10 72 11 80       	push   $0x80117210
80102b5d:	e8 e5 f5 ff ff       	call   80102147 <kinit1>
  kvmalloc();      // kernel page table
80102b62:	e8 f4 3d 00 00       	call   8010695b <kvmalloc>
  mpinit();        // detect other processors
80102b67:	e8 c1 01 00 00       	call   80102d2d <mpinit>
  lapicinit();     // interrupt controller
80102b6c:	e8 d9 f7 ff ff       	call   8010234a <lapicinit>
  seginit();       // segment descriptors
80102b71:	e8 a4 36 00 00       	call   8010621a <seginit>
  picinit();       // disable pic
80102b76:	e8 88 02 00 00       	call   80102e03 <picinit>
  ioapicinit();    // another interrupt controller
80102b7b:	e8 53 f4 ff ff       	call   80101fd3 <ioapicinit>
  consoleinit();   // console hardware
80102b80:	e8 45 dd ff ff       	call   801008ca <consoleinit>
  uartinit();      // serial port
80102b85:	e8 80 2a 00 00       	call   8010560a <uartinit>
  pinit();         // process table
80102b8a:	e8 a9 06 00 00       	call   80103238 <pinit>
  tvinit();        // trap vectors
80102b8f:	e8 ca 26 00 00       	call   8010525e <tvinit>
  binit();         // buffer cache
80102b94:	e8 6d d5 ff ff       	call   80100106 <binit>
  fileinit();      // file table
80102b99:	e8 a5 e0 ff ff       	call   80100c43 <fileinit>
  ideinit();       // disk 
80102b9e:	e8 30 f2 ff ff       	call   80101dd3 <ideinit>
  startothers();   // start other processors
80102ba3:	e8 b2 fe ff ff       	call   80102a5a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ba8:	83 c4 08             	add    $0x8,%esp
80102bab:	68 00 00 00 8e       	push   $0x8e000000
80102bb0:	68 00 00 40 80       	push   $0x80400000
80102bb5:	e8 bf f5 ff ff       	call   80102179 <kinit2>
  userinit();      // first user process
80102bba:	e8 2d 07 00 00       	call   801032ec <userinit>
  mpmain();        // finish this processor's setup
80102bbf:	e8 25 ff ff ff       	call   80102ae9 <mpmain>

80102bc4 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102bc4:	55                   	push   %ebp
80102bc5:	89 e5                	mov    %esp,%ebp
80102bc7:	56                   	push   %esi
80102bc8:	53                   	push   %ebx
80102bc9:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102bd0:	b9 00 00 00 00       	mov    $0x0,%ecx
80102bd5:	eb 09                	jmp    80102be0 <sum+0x1c>
    sum += addr[i];
80102bd7:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102bdb:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102bdd:	83 c1 01             	add    $0x1,%ecx
80102be0:	39 d1                	cmp    %edx,%ecx
80102be2:	7c f3                	jl     80102bd7 <sum+0x13>
  return sum;
}
80102be4:	5b                   	pop    %ebx
80102be5:	5e                   	pop    %esi
80102be6:	5d                   	pop    %ebp
80102be7:	c3                   	ret    

80102be8 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102be8:	55                   	push   %ebp
80102be9:	89 e5                	mov    %esp,%ebp
80102beb:	56                   	push   %esi
80102bec:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bed:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102bf3:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102bf5:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bf7:	eb 03                	jmp    80102bfc <mpsearch1+0x14>
80102bf9:	83 c3 10             	add    $0x10,%ebx
80102bfc:	39 f3                	cmp    %esi,%ebx
80102bfe:	73 29                	jae    80102c29 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c00:	83 ec 04             	sub    $0x4,%esp
80102c03:	6a 04                	push   $0x4
80102c05:	68 b8 70 10 80       	push   $0x801070b8
80102c0a:	53                   	push   %ebx
80102c0b:	e8 52 14 00 00       	call   80104062 <memcmp>
80102c10:	83 c4 10             	add    $0x10,%esp
80102c13:	85 c0                	test   %eax,%eax
80102c15:	75 e2                	jne    80102bf9 <mpsearch1+0x11>
80102c17:	ba 10 00 00 00       	mov    $0x10,%edx
80102c1c:	89 d8                	mov    %ebx,%eax
80102c1e:	e8 a1 ff ff ff       	call   80102bc4 <sum>
80102c23:	84 c0                	test   %al,%al
80102c25:	75 d2                	jne    80102bf9 <mpsearch1+0x11>
80102c27:	eb 05                	jmp    80102c2e <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102c29:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c2e:	89 d8                	mov    %ebx,%eax
80102c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c33:	5b                   	pop    %ebx
80102c34:	5e                   	pop    %esi
80102c35:	5d                   	pop    %ebp
80102c36:	c3                   	ret    

80102c37 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102c37:	55                   	push   %ebp
80102c38:	89 e5                	mov    %esp,%ebp
80102c3a:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c3d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c44:	c1 e0 08             	shl    $0x8,%eax
80102c47:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c4e:	09 d0                	or     %edx,%eax
80102c50:	c1 e0 04             	shl    $0x4,%eax
80102c53:	74 1f                	je     80102c74 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102c55:	ba 00 04 00 00       	mov    $0x400,%edx
80102c5a:	e8 89 ff ff ff       	call   80102be8 <mpsearch1>
80102c5f:	85 c0                	test   %eax,%eax
80102c61:	75 0f                	jne    80102c72 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c63:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c68:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c6d:	e8 76 ff ff ff       	call   80102be8 <mpsearch1>
}
80102c72:	c9                   	leave  
80102c73:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102c74:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102c7b:	c1 e0 08             	shl    $0x8,%eax
80102c7e:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102c85:	09 d0                	or     %edx,%eax
80102c87:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102c8a:	2d 00 04 00 00       	sub    $0x400,%eax
80102c8f:	ba 00 04 00 00       	mov    $0x400,%edx
80102c94:	e8 4f ff ff ff       	call   80102be8 <mpsearch1>
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	75 d5                	jne    80102c72 <mpsearch+0x3b>
80102c9d:	eb c4                	jmp    80102c63 <mpsearch+0x2c>

80102c9f <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102c9f:	55                   	push   %ebp
80102ca0:	89 e5                	mov    %esp,%ebp
80102ca2:	57                   	push   %edi
80102ca3:	56                   	push   %esi
80102ca4:	53                   	push   %ebx
80102ca5:	83 ec 1c             	sub    $0x1c,%esp
80102ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102cab:	e8 87 ff ff ff       	call   80102c37 <mpsearch>
80102cb0:	89 c3                	mov    %eax,%ebx
80102cb2:	85 c0                	test   %eax,%eax
80102cb4:	74 5a                	je     80102d10 <mpconfig+0x71>
80102cb6:	8b 70 04             	mov    0x4(%eax),%esi
80102cb9:	85 f6                	test   %esi,%esi
80102cbb:	74 57                	je     80102d14 <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102cbd:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102cc3:	83 ec 04             	sub    $0x4,%esp
80102cc6:	6a 04                	push   $0x4
80102cc8:	68 bd 70 10 80       	push   $0x801070bd
80102ccd:	57                   	push   %edi
80102cce:	e8 8f 13 00 00       	call   80104062 <memcmp>
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	85 c0                	test   %eax,%eax
80102cd8:	75 3e                	jne    80102d18 <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102cda:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102ce1:	3c 01                	cmp    $0x1,%al
80102ce3:	0f 95 c2             	setne  %dl
80102ce6:	3c 04                	cmp    $0x4,%al
80102ce8:	0f 95 c0             	setne  %al
80102ceb:	84 c2                	test   %al,%dl
80102ced:	75 30                	jne    80102d1f <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102cef:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102cf6:	89 f8                	mov    %edi,%eax
80102cf8:	e8 c7 fe ff ff       	call   80102bc4 <sum>
80102cfd:	84 c0                	test   %al,%al
80102cff:	75 25                	jne    80102d26 <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d04:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102d06:	89 f8                	mov    %edi,%eax
80102d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0b:	5b                   	pop    %ebx
80102d0c:	5e                   	pop    %esi
80102d0d:	5f                   	pop    %edi
80102d0e:	5d                   	pop    %ebp
80102d0f:	c3                   	ret    
    return 0;
80102d10:	89 c7                	mov    %eax,%edi
80102d12:	eb f2                	jmp    80102d06 <mpconfig+0x67>
80102d14:	89 f7                	mov    %esi,%edi
80102d16:	eb ee                	jmp    80102d06 <mpconfig+0x67>
    return 0;
80102d18:	bf 00 00 00 00       	mov    $0x0,%edi
80102d1d:	eb e7                	jmp    80102d06 <mpconfig+0x67>
    return 0;
80102d1f:	bf 00 00 00 00       	mov    $0x0,%edi
80102d24:	eb e0                	jmp    80102d06 <mpconfig+0x67>
    return 0;
80102d26:	bf 00 00 00 00       	mov    $0x0,%edi
80102d2b:	eb d9                	jmp    80102d06 <mpconfig+0x67>

80102d2d <mpinit>:

void
mpinit(void)
{
80102d2d:	55                   	push   %ebp
80102d2e:	89 e5                	mov    %esp,%ebp
80102d30:	57                   	push   %edi
80102d31:	56                   	push   %esi
80102d32:	53                   	push   %ebx
80102d33:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102d39:	e8 61 ff ff ff       	call   80102c9f <mpconfig>
80102d3e:	85 c0                	test   %eax,%eax
80102d40:	74 19                	je     80102d5b <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d42:	8b 50 24             	mov    0x24(%eax),%edx
80102d45:	89 15 d0 31 11 80    	mov    %edx,0x801131d0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d4b:	8d 50 2c             	lea    0x2c(%eax),%edx
80102d4e:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102d52:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102d54:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d59:	eb 20                	jmp    80102d7b <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102d5b:	83 ec 0c             	sub    $0xc,%esp
80102d5e:	68 c2 70 10 80       	push   $0x801070c2
80102d63:	e8 20 d6 ff ff       	call   80100388 <panic>
    switch(*p){
80102d68:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d6d:	eb 0c                	jmp    80102d7b <mpinit+0x4e>
80102d6f:	83 e8 03             	sub    $0x3,%eax
80102d72:	3c 01                	cmp    $0x1,%al
80102d74:	76 1a                	jbe    80102d90 <mpinit+0x63>
80102d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d7b:	39 ca                	cmp    %ecx,%edx
80102d7d:	73 4d                	jae    80102dcc <mpinit+0x9f>
    switch(*p){
80102d7f:	0f b6 02             	movzbl (%edx),%eax
80102d82:	3c 02                	cmp    $0x2,%al
80102d84:	74 38                	je     80102dbe <mpinit+0x91>
80102d86:	77 e7                	ja     80102d6f <mpinit+0x42>
80102d88:	84 c0                	test   %al,%al
80102d8a:	74 09                	je     80102d95 <mpinit+0x68>
80102d8c:	3c 01                	cmp    $0x1,%al
80102d8e:	75 d8                	jne    80102d68 <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d90:	83 c2 08             	add    $0x8,%edx
      continue;
80102d93:	eb e6                	jmp    80102d7b <mpinit+0x4e>
      if(ncpu < NCPU) {
80102d95:	8b 35 04 33 11 80    	mov    0x80113304,%esi
80102d9b:	83 fe 07             	cmp    $0x7,%esi
80102d9e:	7f 19                	jg     80102db9 <mpinit+0x8c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102da0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102da4:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102daa:	88 87 20 33 11 80    	mov    %al,-0x7feecce0(%edi)
        ncpu++;
80102db0:	83 c6 01             	add    $0x1,%esi
80102db3:	89 35 04 33 11 80    	mov    %esi,0x80113304
      p += sizeof(struct mpproc);
80102db9:	83 c2 14             	add    $0x14,%edx
      continue;
80102dbc:	eb bd                	jmp    80102d7b <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102dbe:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102dc2:	a2 00 33 11 80       	mov    %al,0x80113300
      p += sizeof(struct mpioapic);
80102dc7:	83 c2 08             	add    $0x8,%edx
      continue;
80102dca:	eb af                	jmp    80102d7b <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102dcc:	85 db                	test   %ebx,%ebx
80102dce:	74 26                	je     80102df6 <mpinit+0xc9>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102dd3:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102dd7:	74 15                	je     80102dee <mpinit+0xc1>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd9:	b8 70 00 00 00       	mov    $0x70,%eax
80102dde:	ba 22 00 00 00       	mov    $0x22,%edx
80102de3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de4:	ba 23 00 00 00       	mov    $0x23,%edx
80102de9:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102dea:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ded:	ee                   	out    %al,(%dx)
  }
}
80102dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df1:	5b                   	pop    %ebx
80102df2:	5e                   	pop    %esi
80102df3:	5f                   	pop    %edi
80102df4:	5d                   	pop    %ebp
80102df5:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102df6:	83 ec 0c             	sub    $0xc,%esp
80102df9:	68 dc 70 10 80       	push   $0x801070dc
80102dfe:	e8 85 d5 ff ff       	call   80100388 <panic>

80102e03 <picinit>:
80102e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e08:	ba 21 00 00 00       	mov    $0x21,%edx
80102e0d:	ee                   	out    %al,(%dx)
80102e0e:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e13:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e14:	c3                   	ret    

80102e15 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e15:	55                   	push   %ebp
80102e16:	89 e5                	mov    %esp,%ebp
80102e18:	57                   	push   %edi
80102e19:	56                   	push   %esi
80102e1a:	53                   	push   %ebx
80102e1b:	83 ec 0c             	sub    $0xc,%esp
80102e1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e21:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e30:	e8 28 de ff ff       	call   80100c5d <filealloc>
80102e35:	89 03                	mov    %eax,(%ebx)
80102e37:	85 c0                	test   %eax,%eax
80102e39:	0f 84 88 00 00 00    	je     80102ec7 <pipealloc+0xb2>
80102e3f:	e8 19 de ff ff       	call   80100c5d <filealloc>
80102e44:	89 06                	mov    %eax,(%esi)
80102e46:	85 c0                	test   %eax,%eax
80102e48:	74 7d                	je     80102ec7 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e4a:	e8 4a f3 ff ff       	call   80102199 <kalloc>
80102e4f:	89 c7                	mov    %eax,%edi
80102e51:	85 c0                	test   %eax,%eax
80102e53:	74 72                	je     80102ec7 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102e55:	c7 80 8c 02 00 00 01 	movl   $0x1,0x28c(%eax)
80102e5c:	00 00 00 
  p->writeopen = 1;
80102e5f:	c7 80 90 02 00 00 01 	movl   $0x1,0x290(%eax)
80102e66:	00 00 00 
  p->nwrite = 0;
80102e69:	c7 80 88 02 00 00 00 	movl   $0x0,0x288(%eax)
80102e70:	00 00 00 
  p->nread = 0;
80102e73:	c7 80 84 02 00 00 00 	movl   $0x0,0x284(%eax)
80102e7a:	00 00 00 
  initlock(&p->lock, "pipe");
80102e7d:	83 ec 08             	sub    $0x8,%esp
80102e80:	68 fb 70 10 80       	push   $0x801070fb
80102e85:	50                   	push   %eax
80102e86:	e8 34 0f 00 00       	call   80103dbf <initlock>
  (*f0)->type = FD_PIPE;
80102e8b:	8b 03                	mov    (%ebx),%eax
80102e8d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e93:	8b 03                	mov    (%ebx),%eax
80102e95:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e99:	8b 03                	mov    (%ebx),%eax
80102e9b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e9f:	8b 03                	mov    (%ebx),%eax
80102ea1:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ea4:	8b 06                	mov    (%esi),%eax
80102ea6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102eac:	8b 06                	mov    (%esi),%eax
80102eae:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102eb2:	8b 06                	mov    (%esi),%eax
80102eb4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102eb8:	8b 06                	mov    (%esi),%eax
80102eba:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ebd:	83 c4 10             	add    $0x10,%esp
80102ec0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ec5:	eb 29                	jmp    80102ef0 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102ec7:	8b 03                	mov    (%ebx),%eax
80102ec9:	85 c0                	test   %eax,%eax
80102ecb:	74 0c                	je     80102ed9 <pipealloc+0xc4>
    fileclose(*f0);
80102ecd:	83 ec 0c             	sub    $0xc,%esp
80102ed0:	50                   	push   %eax
80102ed1:	e8 2d de ff ff       	call   80100d03 <fileclose>
80102ed6:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102ed9:	8b 06                	mov    (%esi),%eax
80102edb:	85 c0                	test   %eax,%eax
80102edd:	74 19                	je     80102ef8 <pipealloc+0xe3>
    fileclose(*f1);
80102edf:	83 ec 0c             	sub    $0xc,%esp
80102ee2:	50                   	push   %eax
80102ee3:	e8 1b de ff ff       	call   80100d03 <fileclose>
80102ee8:	83 c4 10             	add    $0x10,%esp
  return -1;
80102eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef3:	5b                   	pop    %ebx
80102ef4:	5e                   	pop    %esi
80102ef5:	5f                   	pop    %edi
80102ef6:	5d                   	pop    %ebp
80102ef7:	c3                   	ret    
  return -1;
80102ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102efd:	eb f1                	jmp    80102ef0 <pipealloc+0xdb>

80102eff <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102eff:	55                   	push   %ebp
80102f00:	89 e5                	mov    %esp,%ebp
80102f02:	53                   	push   %ebx
80102f03:	83 ec 10             	sub    $0x10,%esp
80102f06:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102f09:	53                   	push   %ebx
80102f0a:	e8 ec 0f 00 00       	call   80103efb <acquire>
  if(writable){
80102f0f:	83 c4 10             	add    $0x10,%esp
80102f12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102f16:	74 3f                	je     80102f57 <pipeclose+0x58>
    p->writeopen = 0;
80102f18:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
80102f1f:	00 00 00 
    wakeup(&p->nread);
80102f22:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
80102f28:	83 ec 0c             	sub    $0xc,%esp
80102f2b:	50                   	push   %eax
80102f2c:	e8 c4 09 00 00       	call   801038f5 <wakeup>
80102f31:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f34:	83 bb 8c 02 00 00 00 	cmpl   $0x0,0x28c(%ebx)
80102f3b:	75 09                	jne    80102f46 <pipeclose+0x47>
80102f3d:	83 bb 90 02 00 00 00 	cmpl   $0x0,0x290(%ebx)
80102f44:	74 2f                	je     80102f75 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	53                   	push   %ebx
80102f4a:	e8 11 10 00 00       	call   80103f60 <release>
80102f4f:	83 c4 10             	add    $0x10,%esp
}
80102f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f55:	c9                   	leave  
80102f56:	c3                   	ret    
    p->readopen = 0;
80102f57:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80102f5e:	00 00 00 
    wakeup(&p->nwrite);
80102f61:	8d 83 88 02 00 00    	lea    0x288(%ebx),%eax
80102f67:	83 ec 0c             	sub    $0xc,%esp
80102f6a:	50                   	push   %eax
80102f6b:	e8 85 09 00 00       	call   801038f5 <wakeup>
80102f70:	83 c4 10             	add    $0x10,%esp
80102f73:	eb bf                	jmp    80102f34 <pipeclose+0x35>
    release(&p->lock);
80102f75:	83 ec 0c             	sub    $0xc,%esp
80102f78:	53                   	push   %ebx
80102f79:	e8 e2 0f 00 00       	call   80103f60 <release>
    kfree((char*)p);
80102f7e:	89 1c 24             	mov    %ebx,(%esp)
80102f81:	e8 fc f0 ff ff       	call   80102082 <kfree>
80102f86:	83 c4 10             	add    $0x10,%esp
80102f89:	eb c7                	jmp    80102f52 <pipeclose+0x53>

80102f8b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f8b:	55                   	push   %ebp
80102f8c:	89 e5                	mov    %esp,%ebp
80102f8e:	57                   	push   %edi
80102f8f:	56                   	push   %esi
80102f90:	53                   	push   %ebx
80102f91:	83 ec 18             	sub    $0x18,%esp
80102f94:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f97:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  acquire(&p->lock);
80102f9a:	53                   	push   %ebx
80102f9b:	e8 5b 0f 00 00       	call   80103efb <acquire>
  for(i = 0; i < n; i++){
80102fa0:	83 c4 10             	add    $0x10,%esp
80102fa3:	bf 00 00 00 00       	mov    $0x0,%edi
80102fa8:	39 f7                	cmp    %esi,%edi
80102faa:	7c 40                	jl     80102fec <pipewrite+0x61>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102fac:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	50                   	push   %eax
80102fb6:	e8 3a 09 00 00       	call   801038f5 <wakeup>
  release(&p->lock);
80102fbb:	89 1c 24             	mov    %ebx,(%esp)
80102fbe:	e8 9d 0f 00 00       	call   80103f60 <release>
  return n;
80102fc3:	83 c4 10             	add    $0x10,%esp
80102fc6:	89 f0                	mov    %esi,%eax
80102fc8:	eb 5c                	jmp    80103026 <pipewrite+0x9b>
      wakeup(&p->nread);
80102fca:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
80102fd0:	83 ec 0c             	sub    $0xc,%esp
80102fd3:	50                   	push   %eax
80102fd4:	e8 1c 09 00 00       	call   801038f5 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fd9:	8d 83 88 02 00 00    	lea    0x288(%ebx),%eax
80102fdf:	83 c4 08             	add    $0x8,%esp
80102fe2:	53                   	push   %ebx
80102fe3:	50                   	push   %eax
80102fe4:	e8 a7 07 00 00       	call   80103790 <sleep>
80102fe9:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fec:	8b 93 88 02 00 00    	mov    0x288(%ebx),%edx
80102ff2:	8b 83 84 02 00 00    	mov    0x284(%ebx),%eax
80102ff8:	05 00 02 00 00       	add    $0x200,%eax
80102ffd:	39 c2                	cmp    %eax,%edx
80102fff:	75 2d                	jne    8010302e <pipewrite+0xa3>
      if(p->readopen == 0 || myproc()->killed){
80103001:	83 bb 8c 02 00 00 00 	cmpl   $0x0,0x28c(%ebx)
80103008:	74 0b                	je     80103015 <pipewrite+0x8a>
8010300a:	e8 ba 02 00 00       	call   801032c9 <myproc>
8010300f:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103013:	74 b5                	je     80102fca <pipewrite+0x3f>
        release(&p->lock);
80103015:	83 ec 0c             	sub    $0xc,%esp
80103018:	53                   	push   %ebx
80103019:	e8 42 0f 00 00       	call   80103f60 <release>
        return -1;
8010301e:	83 c4 10             	add    $0x10,%esp
80103021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103029:	5b                   	pop    %ebx
8010302a:	5e                   	pop    %esi
8010302b:	5f                   	pop    %edi
8010302c:	5d                   	pop    %ebp
8010302d:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010302e:	8d 42 01             	lea    0x1(%edx),%eax
80103031:	89 83 88 02 00 00    	mov    %eax,0x288(%ebx)
80103037:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010303d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103040:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80103044:	88 84 13 84 00 00 00 	mov    %al,0x84(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010304b:	83 c7 01             	add    $0x1,%edi
8010304e:	e9 55 ff ff ff       	jmp    80102fa8 <pipewrite+0x1d>

80103053 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103053:	55                   	push   %ebp
80103054:	89 e5                	mov    %esp,%ebp
80103056:	57                   	push   %edi
80103057:	56                   	push   %esi
80103058:	53                   	push   %ebx
80103059:	83 ec 18             	sub    $0x18,%esp
8010305c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010305f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103062:	53                   	push   %ebx
80103063:	e8 93 0e 00 00       	call   80103efb <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103068:	83 c4 10             	add    $0x10,%esp
8010306b:	eb 13                	jmp    80103080 <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010306d:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
80103073:	83 ec 08             	sub    $0x8,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	e8 13 07 00 00       	call   80103790 <sleep>
8010307d:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103080:	8b 83 88 02 00 00    	mov    0x288(%ebx),%eax
80103086:	39 83 84 02 00 00    	cmp    %eax,0x284(%ebx)
8010308c:	75 7b                	jne    80103109 <piperead+0xb6>
8010308e:	8b b3 90 02 00 00    	mov    0x290(%ebx),%esi
80103094:	85 f6                	test   %esi,%esi
80103096:	74 3a                	je     801030d2 <piperead+0x7f>
    if(myproc()->killed){
80103098:	e8 2c 02 00 00       	call   801032c9 <myproc>
8010309d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030a1:	74 ca                	je     8010306d <piperead+0x1a>
      release(&p->lock);
801030a3:	83 ec 0c             	sub    $0xc,%esp
801030a6:	53                   	push   %ebx
801030a7:	e8 b4 0e 00 00       	call   80103f60 <release>
      return -1;
801030ac:	83 c4 10             	add    $0x10,%esp
801030af:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030b4:	eb 49                	jmp    801030ff <piperead+0xac>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801030b6:	8d 50 01             	lea    0x1(%eax),%edx
801030b9:	89 93 84 02 00 00    	mov    %edx,0x284(%ebx)
801030bf:	25 ff 01 00 00       	and    $0x1ff,%eax
801030c4:	0f b6 84 03 84 00 00 	movzbl 0x84(%ebx,%eax,1),%eax
801030cb:	00 
801030cc:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030cf:	83 c6 01             	add    $0x1,%esi
801030d2:	3b 75 10             	cmp    0x10(%ebp),%esi
801030d5:	7d 0e                	jge    801030e5 <piperead+0x92>
    if(p->nread == p->nwrite)
801030d7:	8b 83 84 02 00 00    	mov    0x284(%ebx),%eax
801030dd:	3b 83 88 02 00 00    	cmp    0x288(%ebx),%eax
801030e3:	75 d1                	jne    801030b6 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030e5:	8d 83 88 02 00 00    	lea    0x288(%ebx),%eax
801030eb:	83 ec 0c             	sub    $0xc,%esp
801030ee:	50                   	push   %eax
801030ef:	e8 01 08 00 00       	call   801038f5 <wakeup>
  release(&p->lock);
801030f4:	89 1c 24             	mov    %ebx,(%esp)
801030f7:	e8 64 0e 00 00       	call   80103f60 <release>
  return i;
801030fc:	83 c4 10             	add    $0x10,%esp
}
801030ff:	89 f0                	mov    %esi,%eax
80103101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103104:	5b                   	pop    %ebx
80103105:	5e                   	pop    %esi
80103106:	5f                   	pop    %edi
80103107:	5d                   	pop    %ebp
80103108:	c3                   	ret    
80103109:	be 00 00 00 00       	mov    $0x0,%esi
8010310e:	eb c2                	jmp    801030d2 <piperead+0x7f>

80103110 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103110:	ba 24 39 11 80       	mov    $0x80113924,%edx
80103115:	eb 03                	jmp    8010311a <wakeup1+0xa>
80103117:	83 ea 80             	sub    $0xffffff80,%edx
8010311a:	81 fa 24 59 11 80    	cmp    $0x80115924,%edx
80103120:	73 14                	jae    80103136 <wakeup1+0x26>
    if (p->state == SLEEPING && p->chan == chan)
80103122:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103126:	75 ef                	jne    80103117 <wakeup1+0x7>
80103128:	39 42 20             	cmp    %eax,0x20(%edx)
8010312b:	75 ea                	jne    80103117 <wakeup1+0x7>
      p->state = RUNNABLE;
8010312d:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103134:	eb e1                	jmp    80103117 <wakeup1+0x7>
}
80103136:	c3                   	ret    

80103137 <allocproc>:
{
80103137:	55                   	push   %ebp
80103138:	89 e5                	mov    %esp,%ebp
8010313a:	53                   	push   %ebx
8010313b:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010313e:	68 a0 38 11 80       	push   $0x801138a0
80103143:	e8 b3 0d 00 00       	call   80103efb <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103148:	83 c4 10             	add    $0x10,%esp
8010314b:	bb 24 39 11 80       	mov    $0x80113924,%ebx
80103150:	eb 03                	jmp    80103155 <allocproc+0x1e>
80103152:	83 eb 80             	sub    $0xffffff80,%ebx
80103155:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
8010315b:	73 76                	jae    801031d3 <allocproc+0x9c>
    if (p->state == UNUSED)
8010315d:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103161:	75 ef                	jne    80103152 <allocproc+0x1b>
  p->state = EMBRYO;
80103163:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010316a:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010316f:	8d 50 01             	lea    0x1(%eax),%edx
80103172:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103178:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 a0 38 11 80       	push   $0x801138a0
80103183:	e8 d8 0d 00 00       	call   80103f60 <release>
  if ((p->kstack = kalloc()) == 0)
80103188:	e8 0c f0 ff ff       	call   80102199 <kalloc>
8010318d:	89 43 08             	mov    %eax,0x8(%ebx)
80103190:	83 c4 10             	add    $0x10,%esp
80103193:	85 c0                	test   %eax,%eax
80103195:	74 53                	je     801031ea <allocproc+0xb3>
  sp -= sizeof *p->tf;
80103197:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe *)sp;
8010319d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801031a0:	c7 80 b0 0f 00 00 53 	movl   $0x80105253,0xfb0(%eax)
801031a7:	52 10 80 
  sp -= sizeof *p->context;
801031aa:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context *)sp;
801031af:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801031b2:	83 ec 04             	sub    $0x4,%esp
801031b5:	6a 14                	push   $0x14
801031b7:	6a 00                	push   $0x0
801031b9:	50                   	push   %eax
801031ba:	e8 60 0e 00 00       	call   8010401f <memset>
  p->context->eip = (uint)forkret;
801031bf:	8b 43 1c             	mov    0x1c(%ebx),%eax
801031c2:	c7 40 10 f5 31 10 80 	movl   $0x801031f5,0x10(%eax)
  return p;
801031c9:	83 c4 10             	add    $0x10,%esp
}
801031cc:	89 d8                	mov    %ebx,%eax
801031ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031d1:	c9                   	leave  
801031d2:	c3                   	ret    
  release(&ptable.lock);
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	68 a0 38 11 80       	push   $0x801138a0
801031db:	e8 80 0d 00 00       	call   80103f60 <release>
  return 0;
801031e0:	83 c4 10             	add    $0x10,%esp
801031e3:	bb 00 00 00 00       	mov    $0x0,%ebx
801031e8:	eb e2                	jmp    801031cc <allocproc+0x95>
    p->state = UNUSED;
801031ea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801031f1:	89 c3                	mov    %eax,%ebx
801031f3:	eb d7                	jmp    801031cc <allocproc+0x95>

801031f5 <forkret>:
{
801031f5:	55                   	push   %ebp
801031f6:	89 e5                	mov    %esp,%ebp
801031f8:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801031fb:	68 a0 38 11 80       	push   $0x801138a0
80103200:	e8 5b 0d 00 00       	call   80103f60 <release>
  if (first)
80103205:	83 c4 10             	add    $0x10,%esp
80103208:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010320f:	75 02                	jne    80103213 <forkret+0x1e>
}
80103211:	c9                   	leave  
80103212:	c3                   	ret    
    first = 0;
80103213:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010321a:	00 00 00 
    iinit(ROOTDEV);
8010321d:	83 ec 0c             	sub    $0xc,%esp
80103220:	6a 01                	push   $0x1
80103222:	e8 15 e1 ff ff       	call   8010133c <iinit>
    initlog(ROOTDEV);
80103227:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010322e:	e8 10 f6 ff ff       	call   80102843 <initlog>
80103233:	83 c4 10             	add    $0x10,%esp
}
80103236:	eb d9                	jmp    80103211 <forkret+0x1c>

80103238 <pinit>:
{
80103238:	55                   	push   %ebp
80103239:	89 e5                	mov    %esp,%ebp
8010323b:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010323e:	68 00 71 10 80       	push   $0x80107100
80103243:	68 a0 38 11 80       	push   $0x801138a0
80103248:	e8 72 0b 00 00       	call   80103dbf <initlock>
}
8010324d:	83 c4 10             	add    $0x10,%esp
80103250:	c9                   	leave  
80103251:	c3                   	ret    

80103252 <mycpu>:
{
80103252:	55                   	push   %ebp
80103253:	89 e5                	mov    %esp,%ebp
80103255:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103258:	9c                   	pushf  
80103259:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010325a:	f6 c4 02             	test   $0x2,%ah
8010325d:	75 28                	jne    80103287 <mycpu+0x35>
  apicid = lapicid();
8010325f:	e8 f2 f1 ff ff       	call   80102456 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103264:	ba 00 00 00 00       	mov    $0x0,%edx
80103269:	39 15 04 33 11 80    	cmp    %edx,0x80113304
8010326f:	7e 23                	jle    80103294 <mycpu+0x42>
    if (cpus[i].apicid == apicid)
80103271:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103277:	0f b6 89 20 33 11 80 	movzbl -0x7feecce0(%ecx),%ecx
8010327e:	39 c1                	cmp    %eax,%ecx
80103280:	74 1f                	je     801032a1 <mycpu+0x4f>
  for (i = 0; i < ncpu; ++i)
80103282:	83 c2 01             	add    $0x1,%edx
80103285:	eb e2                	jmp    80103269 <mycpu+0x17>
    panic("mycpu called with interrupts enabled\n");
80103287:	83 ec 0c             	sub    $0xc,%esp
8010328a:	68 28 72 10 80       	push   $0x80107228
8010328f:	e8 f4 d0 ff ff       	call   80100388 <panic>
  panic("unknown apicid\n");
80103294:	83 ec 0c             	sub    $0xc,%esp
80103297:	68 07 71 10 80       	push   $0x80107107
8010329c:	e8 e7 d0 ff ff       	call   80100388 <panic>
      return &cpus[i];
801032a1:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801032a7:	05 20 33 11 80       	add    $0x80113320,%eax
}
801032ac:	c9                   	leave  
801032ad:	c3                   	ret    

801032ae <cpuid>:
{
801032ae:	55                   	push   %ebp
801032af:	89 e5                	mov    %esp,%ebp
801032b1:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801032b4:	e8 99 ff ff ff       	call   80103252 <mycpu>
801032b9:	2d 20 33 11 80       	sub    $0x80113320,%eax
801032be:	c1 f8 04             	sar    $0x4,%eax
801032c1:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801032c7:	c9                   	leave  
801032c8:	c3                   	ret    

801032c9 <myproc>:
{
801032c9:	55                   	push   %ebp
801032ca:	89 e5                	mov    %esp,%ebp
801032cc:	53                   	push   %ebx
801032cd:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801032d0:	e8 4b 0b 00 00       	call   80103e20 <pushcli>
  c = mycpu();
801032d5:	e8 78 ff ff ff       	call   80103252 <mycpu>
  p = c->proc;
801032da:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032e0:	e8 77 0b 00 00       	call   80103e5c <popcli>
}
801032e5:	89 d8                	mov    %ebx,%eax
801032e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032ea:	c9                   	leave  
801032eb:	c3                   	ret    

801032ec <userinit>:
{
801032ec:	55                   	push   %ebp
801032ed:	89 e5                	mov    %esp,%ebp
801032ef:	53                   	push   %ebx
801032f0:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032f3:	e8 3f fe ff ff       	call   80103137 <allocproc>
801032f8:	89 c3                	mov    %eax,%ebx
  initproc = p;
801032fa:	a3 24 59 11 80       	mov    %eax,0x80115924
  if ((p->pgdir = setupkvm()) == 0)
801032ff:	e8 e9 35 00 00       	call   801068ed <setupkvm>
80103304:	89 43 04             	mov    %eax,0x4(%ebx)
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 84 b8 00 00 00    	je     801033c7 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010330f:	83 ec 04             	sub    $0x4,%esp
80103312:	68 2c 00 00 00       	push   $0x2c
80103317:	68 60 a4 10 80       	push   $0x8010a460
8010331c:	50                   	push   %eax
8010331d:	e8 db 32 00 00       	call   801065fd <inituvm>
  p->sz = PGSIZE;
80103322:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103328:	8b 43 18             	mov    0x18(%ebx),%eax
8010332b:	83 c4 0c             	add    $0xc,%esp
8010332e:	6a 4c                	push   $0x4c
80103330:	6a 00                	push   $0x0
80103332:	50                   	push   %eax
80103333:	e8 e7 0c 00 00       	call   8010401f <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103338:	8b 43 18             	mov    0x18(%ebx),%eax
8010333b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103341:	8b 43 18             	mov    0x18(%ebx),%eax
80103344:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010334a:	8b 43 18             	mov    0x18(%ebx),%eax
8010334d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103351:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103355:	8b 43 18             	mov    0x18(%ebx),%eax
80103358:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010335c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103360:	8b 43 18             	mov    0x18(%ebx),%eax
80103363:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010336a:	8b 43 18             	mov    0x18(%ebx),%eax
8010336d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103374:	8b 43 18             	mov    0x18(%ebx),%eax
80103377:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010337e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103381:	83 c4 0c             	add    $0xc,%esp
80103384:	6a 10                	push   $0x10
80103386:	68 30 71 10 80       	push   $0x80107130
8010338b:	50                   	push   %eax
8010338c:	e8 fa 0d 00 00       	call   8010418b <safestrcpy>
  p->cwd = namei("/");
80103391:	c7 04 24 39 71 10 80 	movl   $0x80107139,(%esp)
80103398:	e8 17 e9 ff ff       	call   80101cb4 <namei>
8010339d:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033a0:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801033a7:	e8 4f 0b 00 00       	call   80103efb <acquire>
  p->state = RUNNABLE;
801033ac:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801033b3:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801033ba:	e8 a1 0b 00 00       	call   80103f60 <release>
}
801033bf:	83 c4 10             	add    $0x10,%esp
801033c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    
    panic("userinit: out of memory?");
801033c7:	83 ec 0c             	sub    $0xc,%esp
801033ca:	68 17 71 10 80       	push   $0x80107117
801033cf:	e8 b4 cf ff ff       	call   80100388 <panic>

801033d4 <growproc>:
{
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	56                   	push   %esi
801033d8:	53                   	push   %ebx
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033dc:	e8 e8 fe ff ff       	call   801032c9 <myproc>
801033e1:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801033e3:	8b 00                	mov    (%eax),%eax
  if (n > 0)
801033e5:	85 f6                	test   %esi,%esi
801033e7:	7f 1c                	jg     80103405 <growproc+0x31>
  else if (n < 0)
801033e9:	78 37                	js     80103422 <growproc+0x4e>
  curproc->sz = sz;
801033eb:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	53                   	push   %ebx
801033f1:	e8 a7 30 00 00       	call   8010649d <switchuvm>
  return 0;
801033f6:	83 c4 10             	add    $0x10,%esp
801033f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103401:	5b                   	pop    %ebx
80103402:	5e                   	pop    %esi
80103403:	5d                   	pop    %ebp
80103404:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103405:	83 ec 04             	sub    $0x4,%esp
80103408:	01 c6                	add    %eax,%esi
8010340a:	56                   	push   %esi
8010340b:	50                   	push   %eax
8010340c:	ff 73 04             	push   0x4(%ebx)
8010340f:	e8 7f 33 00 00       	call   80106793 <allocuvm>
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 c0                	test   %eax,%eax
80103419:	75 d0                	jne    801033eb <growproc+0x17>
      return -1;
8010341b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103420:	eb dc                	jmp    801033fe <growproc+0x2a>
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103422:	83 ec 04             	sub    $0x4,%esp
80103425:	01 c6                	add    %eax,%esi
80103427:	56                   	push   %esi
80103428:	50                   	push   %eax
80103429:	ff 73 04             	push   0x4(%ebx)
8010342c:	e8 d0 32 00 00       	call   80106701 <deallocuvm>
80103431:	83 c4 10             	add    $0x10,%esp
80103434:	85 c0                	test   %eax,%eax
80103436:	75 b3                	jne    801033eb <growproc+0x17>
      return -1;
80103438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010343d:	eb bf                	jmp    801033fe <growproc+0x2a>

8010343f <fork>:
{
8010343f:	55                   	push   %ebp
80103440:	89 e5                	mov    %esp,%ebp
80103442:	57                   	push   %edi
80103443:	56                   	push   %esi
80103444:	53                   	push   %ebx
80103445:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103448:	e8 7c fe ff ff       	call   801032c9 <myproc>
8010344d:	89 c3                	mov    %eax,%ebx
  if ((np = allocproc()) == 0)
8010344f:	e8 e3 fc ff ff       	call   80103137 <allocproc>
80103454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 84 e0 00 00 00    	je     8010353f <fork+0x100>
8010345f:	89 c7                	mov    %eax,%edi
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103461:	83 ec 08             	sub    $0x8,%esp
80103464:	ff 33                	push   (%ebx)
80103466:	ff 73 04             	push   0x4(%ebx)
80103469:	e8 30 35 00 00       	call   8010699e <copyuvm>
8010346e:	89 47 04             	mov    %eax,0x4(%edi)
80103471:	83 c4 10             	add    $0x10,%esp
80103474:	85 c0                	test   %eax,%eax
80103476:	74 2a                	je     801034a2 <fork+0x63>
  np->sz = curproc->sz;
80103478:	8b 03                	mov    (%ebx),%eax
8010347a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010347d:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010347f:	89 c8                	mov    %ecx,%eax
80103481:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103484:	8b 73 18             	mov    0x18(%ebx),%esi
80103487:	8b 79 18             	mov    0x18(%ecx),%edi
8010348a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010348f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103491:	8b 40 18             	mov    0x18(%eax),%eax
80103494:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
8010349b:	be 00 00 00 00       	mov    $0x0,%esi
801034a0:	eb 29                	jmp    801034cb <fork+0x8c>
    kfree(np->kstack);
801034a2:	83 ec 0c             	sub    $0xc,%esp
801034a5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034a8:	ff 73 08             	push   0x8(%ebx)
801034ab:	e8 d2 eb ff ff       	call   80102082 <kfree>
    np->kstack = 0;
801034b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801034b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801034be:	83 c4 10             	add    $0x10,%esp
801034c1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034c6:	eb 6d                	jmp    80103535 <fork+0xf6>
  for (i = 0; i < NOFILE; i++)
801034c8:	83 c6 01             	add    $0x1,%esi
801034cb:	83 fe 0f             	cmp    $0xf,%esi
801034ce:	7f 1d                	jg     801034ed <fork+0xae>
    if (curproc->ofile[i])
801034d0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034d4:	85 c0                	test   %eax,%eax
801034d6:	74 f0                	je     801034c8 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
801034d8:	83 ec 0c             	sub    $0xc,%esp
801034db:	50                   	push   %eax
801034dc:	e8 dd d7 ff ff       	call   80100cbe <filedup>
801034e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034e4:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801034e8:	83 c4 10             	add    $0x10,%esp
801034eb:	eb db                	jmp    801034c8 <fork+0x89>
  np->cwd = idup(curproc->cwd);
801034ed:	83 ec 0c             	sub    $0xc,%esp
801034f0:	ff 73 68             	push   0x68(%ebx)
801034f3:	e8 cb e0 ff ff       	call   801015c3 <idup>
801034f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034fb:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801034fe:	83 c3 6c             	add    $0x6c,%ebx
80103501:	8d 47 6c             	lea    0x6c(%edi),%eax
80103504:	83 c4 0c             	add    $0xc,%esp
80103507:	6a 10                	push   $0x10
80103509:	53                   	push   %ebx
8010350a:	50                   	push   %eax
8010350b:	e8 7b 0c 00 00       	call   8010418b <safestrcpy>
  pid = np->pid;
80103510:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103513:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010351a:	e8 dc 09 00 00       	call   80103efb <acquire>
  np->state = RUNNABLE;
8010351f:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103526:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010352d:	e8 2e 0a 00 00       	call   80103f60 <release>
  return pid;
80103532:	83 c4 10             	add    $0x10,%esp
}
80103535:	89 d8                	mov    %ebx,%eax
80103537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353a:	5b                   	pop    %ebx
8010353b:	5e                   	pop    %esi
8010353c:	5f                   	pop    %edi
8010353d:	5d                   	pop    %ebp
8010353e:	c3                   	ret    
    return -1;
8010353f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103544:	eb ef                	jmp    80103535 <fork+0xf6>

80103546 <scheduler>:
{
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
80103549:	56                   	push   %esi
8010354a:	53                   	push   %ebx
  struct cpu *c = mycpu();
8010354b:	e8 02 fd ff ff       	call   80103252 <mycpu>
80103550:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103552:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103559:	00 00 00 
8010355c:	eb 60                	jmp    801035be <scheduler+0x78>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010355e:	83 eb 80             	sub    $0xffffff80,%ebx
80103561:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80103567:	73 45                	jae    801035ae <scheduler+0x68>
      if (p->state != RUNNABLE)
80103569:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010356d:	75 ef                	jne    8010355e <scheduler+0x18>
      if(p->PAUSE!=0)
8010356f:	83 7b 7c 00          	cmpl   $0x0,0x7c(%ebx)
80103573:	75 e9                	jne    8010355e <scheduler+0x18>
      c->proc = p;
80103575:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 19 2f 00 00       	call   8010649d <switchuvm>
      p->state = RUNNING;
80103584:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010358b:	83 c4 08             	add    $0x8,%esp
8010358e:	ff 73 1c             	push   0x1c(%ebx)
80103591:	8d 46 04             	lea    0x4(%esi),%eax
80103594:	50                   	push   %eax
80103595:	e8 46 0c 00 00       	call   801041e0 <swtch>
      switchkvm();
8010359a:	e8 f0 2e 00 00       	call   8010648f <switchkvm>
      c->proc = 0;
8010359f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801035a6:	00 00 00 
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb b0                	jmp    8010355e <scheduler+0x18>
    release(&ptable.lock);
801035ae:	83 ec 0c             	sub    $0xc,%esp
801035b1:	68 a0 38 11 80       	push   $0x801138a0
801035b6:	e8 a5 09 00 00       	call   80103f60 <release>
    sti();
801035bb:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801035be:	fb                   	sti    
    acquire(&ptable.lock);
801035bf:	83 ec 0c             	sub    $0xc,%esp
801035c2:	68 a0 38 11 80       	push   $0x801138a0
801035c7:	e8 2f 09 00 00       	call   80103efb <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035cc:	83 c4 10             	add    $0x10,%esp
801035cf:	bb 24 39 11 80       	mov    $0x80113924,%ebx
801035d4:	eb 8b                	jmp    80103561 <scheduler+0x1b>

801035d6 <sched>:
{
801035d6:	55                   	push   %ebp
801035d7:	89 e5                	mov    %esp,%ebp
801035d9:	56                   	push   %esi
801035da:	53                   	push   %ebx
  struct proc *p = myproc();
801035db:	e8 e9 fc ff ff       	call   801032c9 <myproc>
801035e0:	89 c3                	mov    %eax,%ebx
  if (!holding(&ptable.lock))
801035e2:	83 ec 0c             	sub    $0xc,%esp
801035e5:	68 a0 38 11 80       	push   $0x801138a0
801035ea:	e8 cd 08 00 00       	call   80103ebc <holding>
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	85 c0                	test   %eax,%eax
801035f4:	74 4f                	je     80103645 <sched+0x6f>
  if (mycpu()->ncli != 1)
801035f6:	e8 57 fc ff ff       	call   80103252 <mycpu>
801035fb:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103602:	75 4e                	jne    80103652 <sched+0x7c>
  if (p->state == RUNNING)
80103604:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103608:	74 55                	je     8010365f <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010360a:	9c                   	pushf  
8010360b:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010360c:	f6 c4 02             	test   $0x2,%ah
8010360f:	75 5b                	jne    8010366c <sched+0x96>
  intena = mycpu()->intena;
80103611:	e8 3c fc ff ff       	call   80103252 <mycpu>
80103616:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010361c:	e8 31 fc ff ff       	call   80103252 <mycpu>
80103621:	83 ec 08             	sub    $0x8,%esp
80103624:	ff 70 04             	push   0x4(%eax)
80103627:	83 c3 1c             	add    $0x1c,%ebx
8010362a:	53                   	push   %ebx
8010362b:	e8 b0 0b 00 00       	call   801041e0 <swtch>
  mycpu()->intena = intena;
80103630:	e8 1d fc ff ff       	call   80103252 <mycpu>
80103635:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010363b:	83 c4 10             	add    $0x10,%esp
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
80103644:	c3                   	ret    
    panic("sched ptable.lock");
80103645:	83 ec 0c             	sub    $0xc,%esp
80103648:	68 3b 71 10 80       	push   $0x8010713b
8010364d:	e8 36 cd ff ff       	call   80100388 <panic>
    panic("sched locks");
80103652:	83 ec 0c             	sub    $0xc,%esp
80103655:	68 4d 71 10 80       	push   $0x8010714d
8010365a:	e8 29 cd ff ff       	call   80100388 <panic>
    panic("sched running");
8010365f:	83 ec 0c             	sub    $0xc,%esp
80103662:	68 59 71 10 80       	push   $0x80107159
80103667:	e8 1c cd ff ff       	call   80100388 <panic>
    panic("sched interruptible");
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 67 71 10 80       	push   $0x80107167
80103674:	e8 0f cd ff ff       	call   80100388 <panic>

80103679 <exit>:
{
80103679:	55                   	push   %ebp
8010367a:	89 e5                	mov    %esp,%ebp
8010367c:	56                   	push   %esi
8010367d:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010367e:	e8 46 fc ff ff       	call   801032c9 <myproc>
  if (curproc == initproc)
80103683:	39 05 24 59 11 80    	cmp    %eax,0x80115924
80103689:	74 09                	je     80103694 <exit+0x1b>
8010368b:	89 c6                	mov    %eax,%esi
  for (fd = 0; fd < NOFILE; fd++)
8010368d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103692:	eb 10                	jmp    801036a4 <exit+0x2b>
    panic("init exiting");
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	68 7b 71 10 80       	push   $0x8010717b
8010369c:	e8 e7 cc ff ff       	call   80100388 <panic>
  for (fd = 0; fd < NOFILE; fd++)
801036a1:	83 c3 01             	add    $0x1,%ebx
801036a4:	83 fb 0f             	cmp    $0xf,%ebx
801036a7:	7f 1e                	jg     801036c7 <exit+0x4e>
    if (curproc->ofile[fd])
801036a9:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801036ad:	85 c0                	test   %eax,%eax
801036af:	74 f0                	je     801036a1 <exit+0x28>
      fileclose(curproc->ofile[fd]);
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	50                   	push   %eax
801036b5:	e8 49 d6 ff ff       	call   80100d03 <fileclose>
      curproc->ofile[fd] = 0;
801036ba:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801036c1:	00 
801036c2:	83 c4 10             	add    $0x10,%esp
801036c5:	eb da                	jmp    801036a1 <exit+0x28>
  begin_op();
801036c7:	e8 c0 f1 ff ff       	call   8010288c <begin_op>
  iput(curproc->cwd);
801036cc:	83 ec 0c             	sub    $0xc,%esp
801036cf:	ff 76 68             	push   0x68(%esi)
801036d2:	e8 41 e0 ff ff       	call   80101718 <iput>
  end_op();
801036d7:	e8 2a f2 ff ff       	call   80102906 <end_op>
  curproc->cwd = 0;
801036dc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036e3:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801036ea:	e8 0c 08 00 00       	call   80103efb <acquire>
   wakeup1(curproc->parent);
801036ef:	8b 46 14             	mov    0x14(%esi),%eax
801036f2:	e8 19 fa ff ff       	call   80103110 <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036f7:	83 c4 10             	add    $0x10,%esp
801036fa:	bb 24 39 11 80       	mov    $0x80113924,%ebx
801036ff:	eb 1e                	jmp    8010371f <exit+0xa6>
        nproc->parent=nproc->parent->parent;
80103701:	8b 52 14             	mov    0x14(%edx),%edx
80103704:	89 50 14             	mov    %edx,0x14(%eax)
        p->parent=nproc->parent;
80103707:	89 53 14             	mov    %edx,0x14(%ebx)
        nproc--;
8010370a:	83 c0 80             	add    $0xffffff80,%eax
      while(nproc->parent->killed!=0){
8010370d:	8b 50 14             	mov    0x14(%eax),%edx
80103710:	83 7a 24 00          	cmpl   $0x0,0x24(%edx)
80103714:	75 eb                	jne    80103701 <exit+0x88>
      if (p->state == ZOMBIE)
80103716:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010371a:	74 1d                	je     80103739 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010371c:	83 eb 80             	sub    $0xffffff80,%ebx
8010371f:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80103725:	73 1e                	jae    80103745 <exit+0xcc>
    if (p->parent == curproc)
80103727:	8b 43 14             	mov    0x14(%ebx),%eax
8010372a:	39 f0                	cmp    %esi,%eax
8010372c:	75 ee                	jne    8010371c <exit+0xa3>
      nproc->parent->killed=1;
8010372e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      nproc=p;
80103735:	89 d8                	mov    %ebx,%eax
      while(nproc->parent->killed!=0){
80103737:	eb d4                	jmp    8010370d <exit+0x94>
        wakeup1(initproc);
80103739:	a1 24 59 11 80       	mov    0x80115924,%eax
8010373e:	e8 cd f9 ff ff       	call   80103110 <wakeup1>
80103743:	eb d7                	jmp    8010371c <exit+0xa3>
  curproc->state = ZOMBIE;
80103745:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010374c:	e8 85 fe ff ff       	call   801035d6 <sched>
  panic("zombie exit");
80103751:	83 ec 0c             	sub    $0xc,%esp
80103754:	68 88 71 10 80       	push   $0x80107188
80103759:	e8 2a cc ff ff       	call   80100388 <panic>

8010375e <yield>:
{
8010375e:	55                   	push   %ebp
8010375f:	89 e5                	mov    %esp,%ebp
80103761:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80103764:	68 a0 38 11 80       	push   $0x801138a0
80103769:	e8 8d 07 00 00       	call   80103efb <acquire>
  myproc()->state = RUNNABLE;
8010376e:	e8 56 fb ff ff       	call   801032c9 <myproc>
80103773:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010377a:	e8 57 fe ff ff       	call   801035d6 <sched>
  release(&ptable.lock);
8010377f:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103786:	e8 d5 07 00 00       	call   80103f60 <release>
}
8010378b:	83 c4 10             	add    $0x10,%esp
8010378e:	c9                   	leave  
8010378f:	c3                   	ret    

80103790 <sleep>:
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103798:	e8 2c fb ff ff       	call   801032c9 <myproc>
  if (p == 0)
8010379d:	85 c0                	test   %eax,%eax
8010379f:	74 66                	je     80103807 <sleep+0x77>
801037a1:	89 c3                	mov    %eax,%ebx
  if (lk == 0)
801037a3:	85 f6                	test   %esi,%esi
801037a5:	74 6d                	je     80103814 <sleep+0x84>
  if (lk != &ptable.lock)
801037a7:	81 fe a0 38 11 80    	cmp    $0x801138a0,%esi
801037ad:	74 18                	je     801037c7 <sleep+0x37>
    acquire(&ptable.lock); // DOC: sleeplock1
801037af:	83 ec 0c             	sub    $0xc,%esp
801037b2:	68 a0 38 11 80       	push   $0x801138a0
801037b7:	e8 3f 07 00 00       	call   80103efb <acquire>
    release(lk);
801037bc:	89 34 24             	mov    %esi,(%esp)
801037bf:	e8 9c 07 00 00       	call   80103f60 <release>
801037c4:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801037c7:	8b 45 08             	mov    0x8(%ebp),%eax
801037ca:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037cd:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037d4:	e8 fd fd ff ff       	call   801035d6 <sched>
  p->chan = 0;
801037d9:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if (lk != &ptable.lock)
801037e0:	81 fe a0 38 11 80    	cmp    $0x801138a0,%esi
801037e6:	74 18                	je     80103800 <sleep+0x70>
    release(&ptable.lock);
801037e8:	83 ec 0c             	sub    $0xc,%esp
801037eb:	68 a0 38 11 80       	push   $0x801138a0
801037f0:	e8 6b 07 00 00       	call   80103f60 <release>
    acquire(lk);
801037f5:	89 34 24             	mov    %esi,(%esp)
801037f8:	e8 fe 06 00 00       	call   80103efb <acquire>
801037fd:	83 c4 10             	add    $0x10,%esp
}
80103800:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103803:	5b                   	pop    %ebx
80103804:	5e                   	pop    %esi
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
    panic("sleep");
80103807:	83 ec 0c             	sub    $0xc,%esp
8010380a:	68 94 71 10 80       	push   $0x80107194
8010380f:	e8 74 cb ff ff       	call   80100388 <panic>
    panic("sleep without lk");
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 9a 71 10 80       	push   $0x8010719a
8010381c:	e8 67 cb ff ff       	call   80100388 <panic>

80103821 <wait>:
{
80103821:	55                   	push   %ebp
80103822:	89 e5                	mov    %esp,%ebp
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103826:	e8 9e fa ff ff       	call   801032c9 <myproc>
8010382b:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 a0 38 11 80       	push   $0x801138a0
80103835:	e8 c1 06 00 00       	call   80103efb <acquire>
8010383a:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010383d:	b8 00 00 00 00       	mov    $0x0,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103842:	bb 24 39 11 80       	mov    $0x80113924,%ebx
80103847:	eb 5b                	jmp    801038a4 <wait+0x83>
        pid = p->pid;
80103849:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	ff 73 08             	push   0x8(%ebx)
80103852:	e8 2b e8 ff ff       	call   80102082 <kfree>
        p->kstack = 0;
80103857:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010385e:	83 c4 04             	add    $0x4,%esp
80103861:	ff 73 04             	push   0x4(%ebx)
80103864:	e8 14 30 00 00       	call   8010687d <freevm>
        p->pid = 0;
80103869:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103870:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103877:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010387b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103882:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103889:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103890:	e8 cb 06 00 00       	call   80103f60 <release>
        return pid;
80103895:	83 c4 10             	add    $0x10,%esp
}
80103898:	89 f0                	mov    %esi,%eax
8010389a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010389d:	5b                   	pop    %ebx
8010389e:	5e                   	pop    %esi
8010389f:	5d                   	pop    %ebp
801038a0:	c3                   	ret    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038a1:	83 eb 80             	sub    $0xffffff80,%ebx
801038a4:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
801038aa:	73 12                	jae    801038be <wait+0x9d>
      if (p->parent != curproc)
801038ac:	39 73 14             	cmp    %esi,0x14(%ebx)
801038af:	75 f0                	jne    801038a1 <wait+0x80>
      if (p->state == ZOMBIE)
801038b1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038b5:	74 92                	je     80103849 <wait+0x28>
      havekids = 1;
801038b7:	b8 01 00 00 00       	mov    $0x1,%eax
801038bc:	eb e3                	jmp    801038a1 <wait+0x80>
    if (!havekids || curproc->killed)
801038be:	85 c0                	test   %eax,%eax
801038c0:	74 06                	je     801038c8 <wait+0xa7>
801038c2:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038c6:	74 17                	je     801038df <wait+0xbe>
      release(&ptable.lock);
801038c8:	83 ec 0c             	sub    $0xc,%esp
801038cb:	68 a0 38 11 80       	push   $0x801138a0
801038d0:	e8 8b 06 00 00       	call   80103f60 <release>
      return -1;
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038dd:	eb b9                	jmp    80103898 <wait+0x77>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801038df:	83 ec 08             	sub    $0x8,%esp
801038e2:	68 a0 38 11 80       	push   $0x801138a0
801038e7:	56                   	push   %esi
801038e8:	e8 a3 fe ff ff       	call   80103790 <sleep>
    havekids = 0;
801038ed:	83 c4 10             	add    $0x10,%esp
801038f0:	e9 48 ff ff ff       	jmp    8010383d <wait+0x1c>

801038f5 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801038f5:	55                   	push   %ebp
801038f6:	89 e5                	mov    %esp,%ebp
801038f8:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038fb:	68 a0 38 11 80       	push   $0x801138a0
80103900:	e8 f6 05 00 00       	call   80103efb <acquire>
  wakeup1(chan);
80103905:	8b 45 08             	mov    0x8(%ebp),%eax
80103908:	e8 03 f8 ff ff       	call   80103110 <wakeup1>
  release(&ptable.lock);
8010390d:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103914:	e8 47 06 00 00       	call   80103f60 <release>
}
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    

8010391e <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
8010391e:	55                   	push   %ebp
8010391f:	89 e5                	mov    %esp,%ebp
80103921:	53                   	push   %ebx
80103922:	83 ec 10             	sub    $0x10,%esp
80103925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103928:	68 a0 38 11 80       	push   $0x801138a0
8010392d:	e8 c9 05 00 00       	call   80103efb <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103932:	83 c4 10             	add    $0x10,%esp
80103935:	b8 24 39 11 80       	mov    $0x80113924,%eax
8010393a:	eb 0c                	jmp    80103948 <kill+0x2a>
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
8010393c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103943:	eb 1c                	jmp    80103961 <kill+0x43>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103945:	83 e8 80             	sub    $0xffffff80,%eax
80103948:	3d 24 59 11 80       	cmp    $0x80115924,%eax
8010394d:	73 2c                	jae    8010397b <kill+0x5d>
    if (p->pid == pid)
8010394f:	39 58 10             	cmp    %ebx,0x10(%eax)
80103952:	75 f1                	jne    80103945 <kill+0x27>
      p->killed = 1;
80103954:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
8010395b:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010395f:	74 db                	je     8010393c <kill+0x1e>
      release(&ptable.lock);
80103961:	83 ec 0c             	sub    $0xc,%esp
80103964:	68 a0 38 11 80       	push   $0x801138a0
80103969:	e8 f2 05 00 00       	call   80103f60 <release>
      return 0;
8010396e:	83 c4 10             	add    $0x10,%esp
80103971:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103979:	c9                   	leave  
8010397a:	c3                   	ret    
  release(&ptable.lock);
8010397b:	83 ec 0c             	sub    $0xc,%esp
8010397e:	68 a0 38 11 80       	push   $0x801138a0
80103983:	e8 d8 05 00 00       	call   80103f60 <release>
  return -1;
80103988:	83 c4 10             	add    $0x10,%esp
8010398b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103990:	eb e4                	jmp    80103976 <kill+0x58>

80103992 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80103992:	55                   	push   %ebp
80103993:	89 e5                	mov    %esp,%ebp
80103995:	56                   	push   %esi
80103996:	53                   	push   %ebx
80103997:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010399a:	bb 24 39 11 80       	mov    $0x80113924,%ebx
8010399f:	eb 33                	jmp    801039d4 <procdump+0x42>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801039a1:	b8 ab 71 10 80       	mov    $0x801071ab,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039a6:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039a9:	52                   	push   %edx
801039aa:	50                   	push   %eax
801039ab:	ff 73 10             	push   0x10(%ebx)
801039ae:	68 af 71 10 80       	push   $0x801071af
801039b3:	e8 8f cc ff ff       	call   80100647 <cprintf>
    if (p->state == SLEEPING)
801039b8:	83 c4 10             	add    $0x10,%esp
801039bb:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801039bf:	74 39                	je     801039fa <procdump+0x68>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039c1:	83 ec 0c             	sub    $0xc,%esp
801039c4:	68 17 76 10 80       	push   $0x80107617
801039c9:	e8 79 cc ff ff       	call   80100647 <cprintf>
801039ce:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d1:	83 eb 80             	sub    $0xffffff80,%ebx
801039d4:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
801039da:	73 61                	jae    80103a3d <procdump+0xab>
    if (p->state == UNUSED)
801039dc:	8b 43 0c             	mov    0xc(%ebx),%eax
801039df:	85 c0                	test   %eax,%eax
801039e1:	74 ee                	je     801039d1 <procdump+0x3f>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801039e3:	83 f8 05             	cmp    $0x5,%eax
801039e6:	77 b9                	ja     801039a1 <procdump+0xf>
801039e8:	8b 04 85 68 72 10 80 	mov    -0x7fef8d98(,%eax,4),%eax
801039ef:	85 c0                	test   %eax,%eax
801039f1:	75 b3                	jne    801039a6 <procdump+0x14>
      state = "???";
801039f3:	b8 ab 71 10 80       	mov    $0x801071ab,%eax
801039f8:	eb ac                	jmp    801039a6 <procdump+0x14>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801039fa:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039fd:	8b 40 0c             	mov    0xc(%eax),%eax
80103a00:	83 c0 08             	add    $0x8,%eax
80103a03:	83 ec 08             	sub    $0x8,%esp
80103a06:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a09:	52                   	push   %edx
80103a0a:	50                   	push   %eax
80103a0b:	e8 ca 03 00 00       	call   80103dda <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	be 00 00 00 00       	mov    $0x0,%esi
80103a18:	eb 14                	jmp    80103a2e <procdump+0x9c>
        cprintf(" %p", pc[i]);
80103a1a:	83 ec 08             	sub    $0x8,%esp
80103a1d:	50                   	push   %eax
80103a1e:	68 01 6c 10 80       	push   $0x80106c01
80103a23:	e8 1f cc ff ff       	call   80100647 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103a28:	83 c6 01             	add    $0x1,%esi
80103a2b:	83 c4 10             	add    $0x10,%esp
80103a2e:	83 fe 09             	cmp    $0x9,%esi
80103a31:	7f 8e                	jg     801039c1 <procdump+0x2f>
80103a33:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103a37:	85 c0                	test   %eax,%eax
80103a39:	75 df                	jne    80103a1a <procdump+0x88>
80103a3b:	eb 84                	jmp    801039c1 <procdump+0x2f>
  }
}
80103a3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a40:	5b                   	pop    %ebx
80103a41:	5e                   	pop    %esi
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    

80103a44 <getppid>:

int getppid()
{
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	56                   	push   %esi
80103a48:	53                   	push   %ebx
  struct proc *p;
  // p=ptable.proc;
  // int pid=myproc()->pid;
  // cprintf("\ncurrent process pid is %d\n",pid);
  // p=
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a49:	bb 24 39 11 80       	mov    $0x80113924,%ebx
80103a4e:	eb 03                	jmp    80103a53 <getppid+0xf>
80103a50:	83 eb 80             	sub    $0xffffff80,%ebx
80103a53:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80103a59:	73 1d                	jae    80103a78 <getppid+0x34>
  {
    if (p->parent->pid == myproc()->parent->pid)
80103a5b:	8b 43 14             	mov    0x14(%ebx),%eax
80103a5e:	8b 70 10             	mov    0x10(%eax),%esi
80103a61:	e8 63 f8 ff ff       	call   801032c9 <myproc>
80103a66:	8b 40 14             	mov    0x14(%eax),%eax
80103a69:	3b 70 10             	cmp    0x10(%eax),%esi
80103a6c:	75 e2                	jne    80103a50 <getppid+0xc>
    {
      ppid = p->parent->pid;
80103a6e:	8b 43 14             	mov    0x14(%ebx),%eax
80103a71:	8b 40 10             	mov    0x10(%eax),%eax
      return ppid;
    }
  }
  return -1;
}
80103a74:	5b                   	pop    %ebx
80103a75:	5e                   	pop    %esi
80103a76:	5d                   	pop    %ebp
80103a77:	c3                   	ret    
  return -1;
80103a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a7d:	eb f5                	jmp    80103a74 <getppid+0x30>

80103a7f <get_siblings_info>:

// static struct proc *
int get_siblings_info(int pid)
{
80103a7f:	55                   	push   %ebp
80103a80:	89 e5                	mov    %esp,%ebp
80103a82:	56                   	push   %esi
80103a83:	53                   	push   %ebx
80103a84:	8b 75 08             	mov    0x8(%ebp),%esi
  // cprintf("in proc %d\n",pid);
  struct proc *p;
  // enum procstate;
  // struct proc *curproc = myproc();
  acquire(&ptable.lock);
80103a87:	83 ec 0c             	sub    $0xc,%esp
80103a8a:	68 a0 38 11 80       	push   $0x801138a0
80103a8f:	e8 67 04 00 00       	call   80103efb <acquire>
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a94:	83 c4 10             	add    $0x10,%esp
80103a97:	bb 24 39 11 80       	mov    $0x80113924,%ebx
80103a9c:	eb 03                	jmp    80103aa1 <get_siblings_info+0x22>
80103a9e:	83 eb 80             	sub    $0xffffff80,%ebx
80103aa1:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80103aa7:	73 4d                	jae    80103af6 <get_siblings_info+0x77>
  {
    if (p->parent->pid == pid)
80103aa9:	8b 43 14             	mov    0x14(%ebx),%eax
80103aac:	39 70 10             	cmp    %esi,0x10(%eax)
80103aaf:	75 ed                	jne    80103a9e <get_siblings_info+0x1f>
    {
      cprintf("%d %s\n", p->pid, states[p->state]);
80103ab1:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ab4:	83 ec 04             	sub    $0x4,%esp
80103ab7:	ff 34 85 50 72 10 80 	push   -0x7fef8db0(,%eax,4)
80103abe:	ff 73 10             	push   0x10(%ebx)
80103ac1:	68 b8 71 10 80       	push   $0x801071b8
80103ac6:	e8 7c cb ff ff       	call   80100647 <cprintf>
      cprintf("ppid here%d\n", p->parent->pid);
80103acb:	8b 43 14             	mov    0x14(%ebx),%eax
80103ace:	83 c4 08             	add    $0x8,%esp
80103ad1:	ff 70 10             	push   0x10(%eax)
80103ad4:	68 bf 71 10 80       	push   $0x801071bf
80103ad9:	e8 69 cb ff ff       	call   80100647 <cprintf>
      cprintf("ppid func%d\n", getppid());
80103ade:	e8 61 ff ff ff       	call   80103a44 <getppid>
80103ae3:	83 c4 08             	add    $0x8,%esp
80103ae6:	50                   	push   %eax
80103ae7:	68 cc 71 10 80       	push   $0x801071cc
80103aec:	e8 56 cb ff ff       	call   80100647 <cprintf>
80103af1:	83 c4 10             	add    $0x10,%esp
80103af4:	eb a8                	jmp    80103a9e <get_siblings_info+0x1f>
    // cprintf("%s\n", curproc->state);
    // cprintf("state is: %s\n", p->state);
  }

  // cprintf("this is the state%s\n",procstate[p->state]);
  release(&ptable.lock);
80103af6:	83 ec 0c             	sub    $0xc,%esp
80103af9:	68 a0 38 11 80       	push   $0x801138a0
80103afe:	e8 5d 04 00 00       	call   80103f60 <release>
  return 0;
}
80103b03:	b8 00 00 00 00       	mov    $0x0,%eax
80103b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b0b:	5b                   	pop    %ebx
80103b0c:	5e                   	pop    %esi
80103b0d:	5d                   	pop    %ebp
80103b0e:	c3                   	ret    

80103b0f <compare>:

//program to compare two strings
int compare(char a[],char b[])  
{  
80103b0f:	55                   	push   %ebp
80103b10:	89 e5                	mov    %esp,%ebp
80103b12:	56                   	push   %esi
80103b13:	53                   	push   %ebx
80103b14:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b17:	8b 75 0c             	mov    0xc(%ebp),%esi
    int flag=0,i=0;  // integer variables declaration  
80103b1a:	b8 00 00 00 00       	mov    $0x0,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80103b1f:	eb 03                	jmp    80103b24 <compare+0x15>
       if(a[i]!=b[i])  
       {  
           flag=1;  
           break;  
       }  
       i++;  
80103b21:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80103b24:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80103b28:	84 d2                	test   %dl,%dl
80103b2a:	74 1a                	je     80103b46 <compare+0x37>
80103b2c:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80103b30:	84 c9                	test   %cl,%cl
80103b32:	74 0b                	je     80103b3f <compare+0x30>
       if(a[i]!=b[i])  
80103b34:	38 ca                	cmp    %cl,%dl
80103b36:	74 e9                	je     80103b21 <compare+0x12>
           flag=1;  
80103b38:	b8 01 00 00 00       	mov    $0x1,%eax
80103b3d:	eb 0c                	jmp    80103b4b <compare+0x3c>
    int flag=0,i=0;  // integer variables declaration  
80103b3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103b44:	eb 05                	jmp    80103b4b <compare+0x3c>
80103b46:	b8 00 00 00 00       	mov    $0x0,%eax
    }  
    if(flag==0)  
80103b4b:	85 c0                	test   %eax,%eax
80103b4d:	75 09                	jne    80103b58 <compare+0x49>
    return 1;  
80103b4f:	b8 01 00 00 00       	mov    $0x1,%eax
    else  
    return 0;  
}  
80103b54:	5b                   	pop    %ebx
80103b55:	5e                   	pop    %esi
80103b56:	5d                   	pop    %ebp
80103b57:	c3                   	ret    
    return 0;  
80103b58:	b8 00 00 00 00       	mov    $0x0,%eax
80103b5d:	eb f5                	jmp    80103b54 <compare+0x45>

80103b5f <signalProcess>:

void signalProcess(int pid, char type[]){
80103b5f:	55                   	push   %ebp
80103b60:	89 e5                	mov    %esp,%ebp
80103b62:	57                   	push   %edi
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	83 ec 18             	sub    $0x18,%esp
80103b68:	8b 75 08             	mov    0x8(%ebp),%esi
80103b6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  // cprintf("%d\n%d\n",pid,myproc()->pid);

  struct proc *p;
  acquire(&ptable.lock);
80103b6e:	68 a0 38 11 80       	push   $0x801138a0
80103b73:	e8 83 03 00 00       	call   80103efb <acquire>
  // char type1=type[0];
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80103b78:	83 c4 10             	add    $0x10,%esp
80103b7b:	bb 24 39 11 80       	mov    $0x80113924,%ebx
80103b80:	eb 4b                	jmp    80103bcd <signalProcess+0x6e>
    if(pid==p->pid){
      // p->state=type1;
      if(compare(type,"PAUSE")){
        cprintf("pause");
80103b82:	83 ec 0c             	sub    $0xc,%esp
80103b85:	68 df 71 10 80       	push   $0x801071df
80103b8a:	e8 b8 ca ff ff       	call   80100647 <cprintf>
        p->PAUSE=1;
80103b8f:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
        break;
80103b96:	83 c4 10             	add    $0x10,%esp
        break;
      }

    }
  }
  release(&ptable.lock);
80103b99:	83 ec 0c             	sub    $0xc,%esp
80103b9c:	68 a0 38 11 80       	push   $0x801138a0
80103ba1:	e8 ba 03 00 00       	call   80103f60 <release>
  // sched();
}
80103ba6:	83 c4 10             	add    $0x10,%esp
80103ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bac:	5b                   	pop    %ebx
80103bad:	5e                   	pop    %esi
80103bae:	5f                   	pop    %edi
80103baf:	5d                   	pop    %ebp
80103bb0:	c3                   	ret    
        cprintf("continue");
80103bb1:	83 ec 0c             	sub    $0xc,%esp
80103bb4:	68 ee 71 10 80       	push   $0x801071ee
80103bb9:	e8 89 ca ff ff       	call   80100647 <cprintf>
        p->PAUSE=0;
80103bbe:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        break;
80103bc5:	83 c4 10             	add    $0x10,%esp
80103bc8:	eb cf                	jmp    80103b99 <signalProcess+0x3a>
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80103bca:	83 eb 80             	sub    $0xffffff80,%ebx
80103bcd:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80103bd3:	73 c4                	jae    80103b99 <signalProcess+0x3a>
    if(pid==p->pid){
80103bd5:	39 73 10             	cmp    %esi,0x10(%ebx)
80103bd8:	75 f0                	jne    80103bca <signalProcess+0x6b>
      if(compare(type,"PAUSE")){
80103bda:	83 ec 08             	sub    $0x8,%esp
80103bdd:	68 d9 71 10 80       	push   $0x801071d9
80103be2:	57                   	push   %edi
80103be3:	e8 27 ff ff ff       	call   80103b0f <compare>
80103be8:	83 c4 10             	add    $0x10,%esp
80103beb:	85 c0                	test   %eax,%eax
80103bed:	75 93                	jne    80103b82 <signalProcess+0x23>
      if(compare(type,"CONTINUE")){
80103bef:	83 ec 08             	sub    $0x8,%esp
80103bf2:	68 e5 71 10 80       	push   $0x801071e5
80103bf7:	57                   	push   %edi
80103bf8:	e8 12 ff ff ff       	call   80103b0f <compare>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	85 c0                	test   %eax,%eax
80103c02:	75 ad                	jne    80103bb1 <signalProcess+0x52>
      if(compare(type,"KILL")){
80103c04:	83 ec 08             	sub    $0x8,%esp
80103c07:	68 f7 71 10 80       	push   $0x801071f7
80103c0c:	57                   	push   %edi
80103c0d:	e8 fd fe ff ff       	call   80103b0f <compare>
80103c12:	83 c4 10             	add    $0x10,%esp
80103c15:	85 c0                	test   %eax,%eax
80103c17:	74 b1                	je     80103bca <signalProcess+0x6b>
        p->state=ZOMBIE;
80103c19:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
        break;
80103c20:	e9 74 ff ff ff       	jmp    80103b99 <signalProcess+0x3a>

80103c25 <numvp>:

int numvp(){
80103c25:	55                   	push   %ebp
80103c26:	89 e5                	mov    %esp,%ebp
80103c28:	83 ec 08             	sub    $0x8,%esp
  int x = myproc()->sz/PGSIZE;
80103c2b:	e8 99 f6 ff ff       	call   801032c9 <myproc>
80103c30:	8b 00                	mov    (%eax),%eax
80103c32:	c1 e8 0c             	shr    $0xc,%eax
  // return retNumvp();
  return x;
}
80103c35:	c9                   	leave  
80103c36:	c3                   	ret    

80103c37 <numpp>:

int numpp(){
80103c37:	55                   	push   %ebp
80103c38:	89 e5                	mov    %esp,%ebp
80103c3a:	83 ec 08             	sub    $0x8,%esp
  return retNumpp();
80103c3d:	e8 f8 2e 00 00       	call   80106b3a <retNumpp>
}
80103c42:	c9                   	leave  
80103c43:	c3                   	ret    

80103c44 <init_mylock>:

int init_mylock(){
80103c44:	55                   	push   %ebp
80103c45:	89 e5                	mov    %esp,%ebp
80103c47:	83 ec 14             	sub    $0x14,%esp
  return init_mylockLC(&ptable.lock);
80103c4a:	68 a0 38 11 80       	push   $0x801138a0
80103c4f:	e8 53 03 00 00       	call   80103fa7 <init_mylockLC>
  // return 0;
}
80103c54:	c9                   	leave  
80103c55:	c3                   	ret    

80103c56 <acquire_mylock>:

int acquire_mylock(int id){
80103c56:	55                   	push   %ebp
80103c57:	89 e5                	mov    %esp,%ebp
80103c59:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103c5c:	8d 45 08             	lea    0x8(%ebp),%eax
80103c5f:	50                   	push   %eax
80103c60:	6a 00                	push   $0x0
80103c62:	e8 08 06 00 00       	call   8010426f <argint>
  // return id;
  return acquire_mylockLC(&ptable.lock, id);
80103c67:	83 c4 08             	add    $0x8,%esp
80103c6a:	ff 75 08             	push   0x8(%ebp)
80103c6d:	68 a0 38 11 80       	push   $0x801138a0
80103c72:	e8 62 03 00 00       	call   80103fd9 <acquire_mylockLC>
}
80103c77:	c9                   	leave  
80103c78:	c3                   	ret    

80103c79 <release_mylock>:

int release_mylock(int id){
80103c79:	55                   	push   %ebp
80103c7a:	89 e5                	mov    %esp,%ebp
80103c7c:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103c7f:	8d 45 08             	lea    0x8(%ebp),%eax
80103c82:	50                   	push   %eax
80103c83:	6a 00                	push   $0x0
80103c85:	e8 e5 05 00 00       	call   8010426f <argint>
  return id;
}
80103c8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8d:	c9                   	leave  
80103c8e:	c3                   	ret    

80103c8f <holding_mylock>:

int holding_mylock(int id){
80103c8f:	55                   	push   %ebp
80103c90:	89 e5                	mov    %esp,%ebp
80103c92:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103c95:	8d 45 08             	lea    0x8(%ebp),%eax
80103c98:	50                   	push   %eax
80103c99:	6a 00                	push   $0x0
80103c9b:	e8 cf 05 00 00       	call   8010426f <argint>
  return id;
80103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca3:	c9                   	leave  
80103ca4:	c3                   	ret    

80103ca5 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ca5:	55                   	push   %ebp
80103ca6:	89 e5                	mov    %esp,%ebp
80103ca8:	53                   	push   %ebx
80103ca9:	83 ec 0c             	sub    $0xc,%esp
80103cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103caf:	68 80 72 10 80       	push   $0x80107280
80103cb4:	8d 43 04             	lea    0x4(%ebx),%eax
80103cb7:	50                   	push   %eax
80103cb8:	e8 02 01 00 00       	call   80103dbf <initlock>
  lk->name = name;
80103cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  lk->locked = 0;
80103cc6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ccc:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103cd3:	00 00 00 
}
80103cd6:	83 c4 10             	add    $0x10,%esp
80103cd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cdc:	c9                   	leave  
80103cdd:	c3                   	ret    

80103cde <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103cde:	55                   	push   %ebp
80103cdf:	89 e5                	mov    %esp,%ebp
80103ce1:	56                   	push   %esi
80103ce2:	53                   	push   %ebx
80103ce3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ce6:	8d 73 04             	lea    0x4(%ebx),%esi
80103ce9:	83 ec 0c             	sub    $0xc,%esp
80103cec:	56                   	push   %esi
80103ced:	e8 09 02 00 00       	call   80103efb <acquire>
  while (lk->locked) {
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	eb 0d                	jmp    80103d04 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103cf7:	83 ec 08             	sub    $0x8,%esp
80103cfa:	56                   	push   %esi
80103cfb:	53                   	push   %ebx
80103cfc:	e8 8f fa ff ff       	call   80103790 <sleep>
80103d01:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103d04:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d07:	75 ee                	jne    80103cf7 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103d09:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103d0f:	e8 b5 f5 ff ff       	call   801032c9 <myproc>
80103d14:	8b 40 10             	mov    0x10(%eax),%eax
80103d17:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  release(&lk->lk);
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	56                   	push   %esi
80103d21:	e8 3a 02 00 00       	call   80103f60 <release>
}
80103d26:	83 c4 10             	add    $0x10,%esp
80103d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d2c:	5b                   	pop    %ebx
80103d2d:	5e                   	pop    %esi
80103d2e:	5d                   	pop    %ebp
80103d2f:	c3                   	ret    

80103d30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103d38:	8d 73 04             	lea    0x4(%ebx),%esi
80103d3b:	83 ec 0c             	sub    $0xc,%esp
80103d3e:	56                   	push   %esi
80103d3f:	e8 b7 01 00 00       	call   80103efb <acquire>
  lk->locked = 0;
80103d44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103d4a:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103d51:	00 00 00 
  wakeup(lk);
80103d54:	89 1c 24             	mov    %ebx,(%esp)
80103d57:	e8 99 fb ff ff       	call   801038f5 <wakeup>
  release(&lk->lk);
80103d5c:	89 34 24             	mov    %esi,(%esp)
80103d5f:	e8 fc 01 00 00       	call   80103f60 <release>
}
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6a:	5b                   	pop    %ebx
80103d6b:	5e                   	pop    %esi
80103d6c:	5d                   	pop    %ebp
80103d6d:	c3                   	ret    

80103d6e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103d6e:	55                   	push   %ebp
80103d6f:	89 e5                	mov    %esp,%ebp
80103d71:	56                   	push   %esi
80103d72:	53                   	push   %ebx
80103d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103d76:	8d 73 04             	lea    0x4(%ebx),%esi
80103d79:	83 ec 0c             	sub    $0xc,%esp
80103d7c:	56                   	push   %esi
80103d7d:	e8 79 01 00 00       	call   80103efb <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103d82:	83 c4 10             	add    $0x10,%esp
80103d85:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d88:	75 17                	jne    80103da1 <holdingsleep+0x33>
80103d8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103d8f:	83 ec 0c             	sub    $0xc,%esp
80103d92:	56                   	push   %esi
80103d93:	e8 c8 01 00 00       	call   80103f60 <release>
  return r;
}
80103d98:	89 d8                	mov    %ebx,%eax
80103d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d9d:	5b                   	pop    %ebx
80103d9e:	5e                   	pop    %esi
80103d9f:	5d                   	pop    %ebp
80103da0:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103da1:	8b 9b 8c 00 00 00    	mov    0x8c(%ebx),%ebx
80103da7:	e8 1d f5 ff ff       	call   801032c9 <myproc>
80103dac:	3b 58 10             	cmp    0x10(%eax),%ebx
80103daf:	74 07                	je     80103db8 <holdingsleep+0x4a>
80103db1:	bb 00 00 00 00       	mov    $0x0,%ebx
80103db6:	eb d7                	jmp    80103d8f <holdingsleep+0x21>
80103db8:	bb 01 00 00 00       	mov    $0x1,%ebx
80103dbd:	eb d0                	jmp    80103d8f <holdingsleep+0x21>

80103dbf <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103dbf:	55                   	push   %ebp
80103dc0:	89 e5                	mov    %esp,%ebp
80103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dc8:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103dd8:	5d                   	pop    %ebp
80103dd9:	c3                   	ret    

80103dda <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103dda:	55                   	push   %ebp
80103ddb:	89 e5                	mov    %esp,%ebp
80103ddd:	53                   	push   %ebx
80103dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103de1:	8b 45 08             	mov    0x8(%ebp),%eax
80103de4:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103de7:	b8 00 00 00 00       	mov    $0x0,%eax
80103dec:	83 f8 09             	cmp    $0x9,%eax
80103def:	7f 25                	jg     80103e16 <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103df1:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103df7:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103dfd:	77 17                	ja     80103e16 <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103dff:	8b 5a 04             	mov    0x4(%edx),%ebx
80103e02:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103e05:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103e07:	83 c0 01             	add    $0x1,%eax
80103e0a:	eb e0                	jmp    80103dec <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103e0c:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103e13:	83 c0 01             	add    $0x1,%eax
80103e16:	83 f8 09             	cmp    $0x9,%eax
80103e19:	7e f1                	jle    80103e0c <getcallerpcs+0x32>
}
80103e1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e1e:	c9                   	leave  
80103e1f:	c3                   	ret    

80103e20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
80103e24:	83 ec 04             	sub    $0x4,%esp
80103e27:	9c                   	pushf  
80103e28:	5b                   	pop    %ebx
  asm volatile("cli");
80103e29:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103e2a:	e8 23 f4 ff ff       	call   80103252 <mycpu>
80103e2f:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103e36:	74 11                	je     80103e49 <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103e38:	e8 15 f4 ff ff       	call   80103252 <mycpu>
80103e3d:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e47:	c9                   	leave  
80103e48:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103e49:	e8 04 f4 ff ff       	call   80103252 <mycpu>
80103e4e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103e54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103e5a:	eb dc                	jmp    80103e38 <pushcli+0x18>

80103e5c <popcli>:

void
popcli(void)
{
80103e5c:	55                   	push   %ebp
80103e5d:	89 e5                	mov    %esp,%ebp
80103e5f:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e62:	9c                   	pushf  
80103e63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e64:	f6 c4 02             	test   $0x2,%ah
80103e67:	75 28                	jne    80103e91 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103e69:	e8 e4 f3 ff ff       	call   80103252 <mycpu>
80103e6e:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103e74:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103e77:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103e7d:	85 d2                	test   %edx,%edx
80103e7f:	78 1d                	js     80103e9e <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103e81:	e8 cc f3 ff ff       	call   80103252 <mycpu>
80103e86:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103e8d:	74 1c                	je     80103eab <popcli+0x4f>
    sti();
}
80103e8f:	c9                   	leave  
80103e90:	c3                   	ret    
    panic("popcli - interruptible");
80103e91:	83 ec 0c             	sub    $0xc,%esp
80103e94:	68 8b 72 10 80       	push   $0x8010728b
80103e99:	e8 ea c4 ff ff       	call   80100388 <panic>
    panic("popcli");
80103e9e:	83 ec 0c             	sub    $0xc,%esp
80103ea1:	68 a2 72 10 80       	push   $0x801072a2
80103ea6:	e8 dd c4 ff ff       	call   80100388 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103eab:	e8 a2 f3 ff ff       	call   80103252 <mycpu>
80103eb0:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103eb7:	74 d6                	je     80103e8f <popcli+0x33>
  asm volatile("sti");
80103eb9:	fb                   	sti    
}
80103eba:	eb d3                	jmp    80103e8f <popcli+0x33>

80103ebc <holding>:
{
80103ebc:	55                   	push   %ebp
80103ebd:	89 e5                	mov    %esp,%ebp
80103ebf:	53                   	push   %ebx
80103ec0:	83 ec 04             	sub    $0x4,%esp
80103ec3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103ec6:	e8 55 ff ff ff       	call   80103e20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103ecb:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ece:	75 11                	jne    80103ee1 <holding+0x25>
80103ed0:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103ed5:	e8 82 ff ff ff       	call   80103e5c <popcli>
}
80103eda:	89 d8                	mov    %ebx,%eax
80103edc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103edf:	c9                   	leave  
80103ee0:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103ee1:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103ee4:	e8 69 f3 ff ff       	call   80103252 <mycpu>
80103ee9:	39 c3                	cmp    %eax,%ebx
80103eeb:	74 07                	je     80103ef4 <holding+0x38>
80103eed:	bb 00 00 00 00       	mov    $0x0,%ebx
80103ef2:	eb e1                	jmp    80103ed5 <holding+0x19>
80103ef4:	bb 01 00 00 00       	mov    $0x1,%ebx
80103ef9:	eb da                	jmp    80103ed5 <holding+0x19>

80103efb <acquire>:
{
80103efb:	55                   	push   %ebp
80103efc:	89 e5                	mov    %esp,%ebp
80103efe:	53                   	push   %ebx
80103eff:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103f02:	e8 19 ff ff ff       	call   80103e20 <pushcli>
  if(holding(lk))
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	ff 75 08             	push   0x8(%ebp)
80103f0d:	e8 aa ff ff ff       	call   80103ebc <holding>
80103f12:	83 c4 10             	add    $0x10,%esp
80103f15:	85 c0                	test   %eax,%eax
80103f17:	75 3a                	jne    80103f53 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103f19:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103f1c:	b8 01 00 00 00       	mov    $0x1,%eax
80103f21:	f0 87 02             	lock xchg %eax,(%edx)
80103f24:	85 c0                	test   %eax,%eax
80103f26:	75 f1                	jne    80103f19 <acquire+0x1e>
  __sync_synchronize();
80103f28:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f30:	e8 1d f3 ff ff       	call   80103252 <mycpu>
80103f35:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103f38:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3b:	83 c0 0c             	add    $0xc,%eax
80103f3e:	83 ec 08             	sub    $0x8,%esp
80103f41:	50                   	push   %eax
80103f42:	8d 45 08             	lea    0x8(%ebp),%eax
80103f45:	50                   	push   %eax
80103f46:	e8 8f fe ff ff       	call   80103dda <getcallerpcs>
}
80103f4b:	83 c4 10             	add    $0x10,%esp
80103f4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f51:	c9                   	leave  
80103f52:	c3                   	ret    
    panic("acquire");
80103f53:	83 ec 0c             	sub    $0xc,%esp
80103f56:	68 a9 72 10 80       	push   $0x801072a9
80103f5b:	e8 28 c4 ff ff       	call   80100388 <panic>

80103f60 <release>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 10             	sub    $0x10,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103f6a:	53                   	push   %ebx
80103f6b:	e8 4c ff ff ff       	call   80103ebc <holding>
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	85 c0                	test   %eax,%eax
80103f75:	74 23                	je     80103f9a <release+0x3a>
  lk->pcs[0] = 0;
80103f77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103f7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103f85:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103f8a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103f90:	e8 c7 fe ff ff       	call   80103e5c <popcli>
}
80103f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f98:	c9                   	leave  
80103f99:	c3                   	ret    
    panic("release");
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 b1 72 10 80       	push   $0x801072b1
80103fa2:	e8 e1 c3 ff ff       	call   80100388 <panic>

80103fa7 <init_mylockLC>:

int init_mylockLC(struct spinlock *lk){
80103fa7:	55                   	push   %ebp
80103fa8:	89 e5                	mov    %esp,%ebp
80103faa:	8b 55 08             	mov    0x8(%ebp),%edx
  int counter=0;
80103fad:	b8 00 00 00 00       	mov    $0x0,%eax
  while( lk->exists[counter]==1 && counter<=10){
80103fb2:	eb 03                	jmp    80103fb7 <init_mylockLC+0x10>
    // cprintf("%d\n",lk->exists[0]);
    counter++;
80103fb4:	83 c0 01             	add    $0x1,%eax
  while( lk->exists[counter]==1 && counter<=10){
80103fb7:	83 7c 82 34 01       	cmpl   $0x1,0x34(%edx,%eax,4)
80103fbc:	75 05                	jne    80103fc3 <init_mylockLC+0x1c>
80103fbe:	83 f8 0a             	cmp    $0xa,%eax
80103fc1:	7e f1                	jle    80103fb4 <init_mylockLC+0xd>
  }
  if(counter==11){
80103fc3:	83 f8 0b             	cmp    $0xb,%eax
80103fc6:	74 0a                	je     80103fd2 <init_mylockLC+0x2b>
    return -1;
  }
  else{
    lk->exists[counter]=1;
80103fc8:	c7 44 82 34 01 00 00 	movl   $0x1,0x34(%edx,%eax,4)
80103fcf:	00 
    return counter;
  }

}
80103fd0:	5d                   	pop    %ebp
80103fd1:	c3                   	ret    
    return -1;
80103fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd7:	eb f7                	jmp    80103fd0 <init_mylockLC+0x29>

80103fd9 <acquire_mylockLC>:

int acquire_mylockLC(struct spinlock *lk,int id){
80103fd9:	55                   	push   %ebp
80103fda:	89 e5                	mov    %esp,%ebp
80103fdc:	56                   	push   %esi
80103fdd:	53                   	push   %ebx
80103fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fe1:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fe4:	e8 37 fe ff ff       	call   80103e20 <pushcli>
  if(lk->status[id]==0 && lk->exists[id]==1){
80103fe9:	83 7c b3 5c 00       	cmpl   $0x0,0x5c(%ebx,%esi,4)
80103fee:	75 07                	jne    80103ff7 <acquire_mylockLC+0x1e>
80103ff0:	83 7c b3 34 01       	cmpl   $0x1,0x34(%ebx,%esi,4)
80103ff5:	74 09                	je     80104000 <acquire_mylockLC+0x27>
      ;
  }
  
  // __sync_synchronize();
  return 0;
80103ff7:	b8 00 00 00 00       	mov    $0x0,%eax
80103ffc:	5b                   	pop    %ebx
80103ffd:	5e                   	pop    %esi
80103ffe:	5d                   	pop    %ebp
80103fff:	c3                   	ret    
80104000:	b8 01 00 00 00       	mov    $0x1,%eax
80104005:	f0 87 03             	lock xchg %eax,(%ebx)
    while(xchg(&lk->locked, 1) != 0 && xchg(&lk->status[id], 1) != 0)
80104008:	85 c0                	test   %eax,%eax
8010400a:	74 eb                	je     80103ff7 <acquire_mylockLC+0x1e>
8010400c:	8d 54 b3 50          	lea    0x50(%ebx,%esi,4),%edx
80104010:	b8 01 00 00 00       	mov    $0x1,%eax
80104015:	f0 87 42 0c          	lock xchg %eax,0xc(%edx)
80104019:	85 c0                	test   %eax,%eax
8010401b:	75 e3                	jne    80104000 <acquire_mylockLC+0x27>
8010401d:	eb d8                	jmp    80103ff7 <acquire_mylockLC+0x1e>

8010401f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010401f:	55                   	push   %ebp
80104020:	89 e5                	mov    %esp,%ebp
80104022:	57                   	push   %edi
80104023:	53                   	push   %ebx
80104024:	8b 55 08             	mov    0x8(%ebp),%edx
80104027:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010402d:	f6 c2 03             	test   $0x3,%dl
80104030:	75 25                	jne    80104057 <memset+0x38>
80104032:	f6 c1 03             	test   $0x3,%cl
80104035:	75 20                	jne    80104057 <memset+0x38>
    c &= 0xFF;
80104037:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010403a:	c1 e9 02             	shr    $0x2,%ecx
8010403d:	c1 e0 18             	shl    $0x18,%eax
80104040:	89 fb                	mov    %edi,%ebx
80104042:	c1 e3 10             	shl    $0x10,%ebx
80104045:	09 d8                	or     %ebx,%eax
80104047:	89 fb                	mov    %edi,%ebx
80104049:	c1 e3 08             	shl    $0x8,%ebx
8010404c:	09 d8                	or     %ebx,%eax
8010404e:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104050:	89 d7                	mov    %edx,%edi
80104052:	fc                   	cld    
80104053:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104055:	eb 05                	jmp    8010405c <memset+0x3d>
  asm volatile("cld; rep stosb" :
80104057:	89 d7                	mov    %edx,%edi
80104059:	fc                   	cld    
8010405a:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
8010405c:	89 d0                	mov    %edx,%eax
8010405e:	5b                   	pop    %ebx
8010405f:	5f                   	pop    %edi
80104060:	5d                   	pop    %ebp
80104061:	c3                   	ret    

80104062 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104062:	55                   	push   %ebp
80104063:	89 e5                	mov    %esp,%ebp
80104065:	56                   	push   %esi
80104066:	53                   	push   %ebx
80104067:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010406a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010406d:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104070:	eb 08                	jmp    8010407a <memcmp+0x18>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104072:	83 c1 01             	add    $0x1,%ecx
80104075:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104078:	89 f0                	mov    %esi,%eax
8010407a:	8d 70 ff             	lea    -0x1(%eax),%esi
8010407d:	85 c0                	test   %eax,%eax
8010407f:	74 12                	je     80104093 <memcmp+0x31>
    if(*s1 != *s2)
80104081:	0f b6 01             	movzbl (%ecx),%eax
80104084:	0f b6 1a             	movzbl (%edx),%ebx
80104087:	38 d8                	cmp    %bl,%al
80104089:	74 e7                	je     80104072 <memcmp+0x10>
      return *s1 - *s2;
8010408b:	0f b6 c0             	movzbl %al,%eax
8010408e:	0f b6 db             	movzbl %bl,%ebx
80104091:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104093:	5b                   	pop    %ebx
80104094:	5e                   	pop    %esi
80104095:	5d                   	pop    %ebp
80104096:	c3                   	ret    

80104097 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104097:	55                   	push   %ebp
80104098:	89 e5                	mov    %esp,%ebp
8010409a:	56                   	push   %esi
8010409b:	53                   	push   %ebx
8010409c:	8b 75 08             	mov    0x8(%ebp),%esi
8010409f:	8b 55 0c             	mov    0xc(%ebp),%edx
801040a2:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801040a5:	39 f2                	cmp    %esi,%edx
801040a7:	73 3c                	jae    801040e5 <memmove+0x4e>
801040a9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801040ac:	39 f1                	cmp    %esi,%ecx
801040ae:	76 39                	jbe    801040e9 <memmove+0x52>
    s += n;
    d += n;
801040b0:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
801040b3:	eb 0d                	jmp    801040c2 <memmove+0x2b>
      *--d = *--s;
801040b5:	83 e9 01             	sub    $0x1,%ecx
801040b8:	83 ea 01             	sub    $0x1,%edx
801040bb:	0f b6 01             	movzbl (%ecx),%eax
801040be:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
801040c0:	89 d8                	mov    %ebx,%eax
801040c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040c5:	85 c0                	test   %eax,%eax
801040c7:	75 ec                	jne    801040b5 <memmove+0x1e>
801040c9:	eb 14                	jmp    801040df <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
801040cb:	0f b6 02             	movzbl (%edx),%eax
801040ce:	88 01                	mov    %al,(%ecx)
801040d0:	8d 49 01             	lea    0x1(%ecx),%ecx
801040d3:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
801040d6:	89 d8                	mov    %ebx,%eax
801040d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040db:	85 c0                	test   %eax,%eax
801040dd:	75 ec                	jne    801040cb <memmove+0x34>

  return dst;
}
801040df:	89 f0                	mov    %esi,%eax
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5d                   	pop    %ebp
801040e4:	c3                   	ret    
801040e5:	89 f1                	mov    %esi,%ecx
801040e7:	eb ef                	jmp    801040d8 <memmove+0x41>
801040e9:	89 f1                	mov    %esi,%ecx
801040eb:	eb eb                	jmp    801040d8 <memmove+0x41>

801040ed <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801040ed:	55                   	push   %ebp
801040ee:	89 e5                	mov    %esp,%ebp
801040f0:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801040f3:	ff 75 10             	push   0x10(%ebp)
801040f6:	ff 75 0c             	push   0xc(%ebp)
801040f9:	ff 75 08             	push   0x8(%ebp)
801040fc:	e8 96 ff ff ff       	call   80104097 <memmove>
}
80104101:	c9                   	leave  
80104102:	c3                   	ret    

80104103 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104103:	55                   	push   %ebp
80104104:	89 e5                	mov    %esp,%ebp
80104106:	53                   	push   %ebx
80104107:	8b 55 08             	mov    0x8(%ebp),%edx
8010410a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010410d:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104110:	eb 09                	jmp    8010411b <strncmp+0x18>
    n--, p++, q++;
80104112:	83 e8 01             	sub    $0x1,%eax
80104115:	83 c2 01             	add    $0x1,%edx
80104118:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010411b:	85 c0                	test   %eax,%eax
8010411d:	74 0b                	je     8010412a <strncmp+0x27>
8010411f:	0f b6 1a             	movzbl (%edx),%ebx
80104122:	84 db                	test   %bl,%bl
80104124:	74 04                	je     8010412a <strncmp+0x27>
80104126:	3a 19                	cmp    (%ecx),%bl
80104128:	74 e8                	je     80104112 <strncmp+0xf>
  if(n == 0)
8010412a:	85 c0                	test   %eax,%eax
8010412c:	74 0d                	je     8010413b <strncmp+0x38>
    return 0;
  return (uchar)*p - (uchar)*q;
8010412e:	0f b6 02             	movzbl (%edx),%eax
80104131:	0f b6 11             	movzbl (%ecx),%edx
80104134:	29 d0                	sub    %edx,%eax
}
80104136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104139:	c9                   	leave  
8010413a:	c3                   	ret    
    return 0;
8010413b:	b8 00 00 00 00       	mov    $0x0,%eax
80104140:	eb f4                	jmp    80104136 <strncmp+0x33>

80104142 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104142:	55                   	push   %ebp
80104143:	89 e5                	mov    %esp,%ebp
80104145:	57                   	push   %edi
80104146:	56                   	push   %esi
80104147:	53                   	push   %ebx
80104148:	8b 7d 08             	mov    0x8(%ebp),%edi
8010414b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010414e:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104151:	89 fa                	mov    %edi,%edx
80104153:	eb 04                	jmp    80104159 <strncpy+0x17>
80104155:	89 f1                	mov    %esi,%ecx
80104157:	89 da                	mov    %ebx,%edx
80104159:	89 c3                	mov    %eax,%ebx
8010415b:	83 e8 01             	sub    $0x1,%eax
8010415e:	85 db                	test   %ebx,%ebx
80104160:	7e 11                	jle    80104173 <strncpy+0x31>
80104162:	8d 71 01             	lea    0x1(%ecx),%esi
80104165:	8d 5a 01             	lea    0x1(%edx),%ebx
80104168:	0f b6 09             	movzbl (%ecx),%ecx
8010416b:	88 0a                	mov    %cl,(%edx)
8010416d:	84 c9                	test   %cl,%cl
8010416f:	75 e4                	jne    80104155 <strncpy+0x13>
80104171:	89 da                	mov    %ebx,%edx
    ;
  while(n-- > 0)
80104173:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104176:	85 c0                	test   %eax,%eax
80104178:	7e 0a                	jle    80104184 <strncpy+0x42>
    *s++ = 0;
8010417a:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
8010417d:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
8010417f:	8d 52 01             	lea    0x1(%edx),%edx
80104182:	eb ef                	jmp    80104173 <strncpy+0x31>
  return os;
}
80104184:	89 f8                	mov    %edi,%eax
80104186:	5b                   	pop    %ebx
80104187:	5e                   	pop    %esi
80104188:	5f                   	pop    %edi
80104189:	5d                   	pop    %ebp
8010418a:	c3                   	ret    

8010418b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010418b:	55                   	push   %ebp
8010418c:	89 e5                	mov    %esp,%ebp
8010418e:	57                   	push   %edi
8010418f:	56                   	push   %esi
80104190:	53                   	push   %ebx
80104191:	8b 7d 08             	mov    0x8(%ebp),%edi
80104194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104197:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010419a:	85 c0                	test   %eax,%eax
8010419c:	7e 23                	jle    801041c1 <safestrcpy+0x36>
8010419e:	89 fa                	mov    %edi,%edx
801041a0:	eb 04                	jmp    801041a6 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801041a2:	89 f1                	mov    %esi,%ecx
801041a4:	89 da                	mov    %ebx,%edx
801041a6:	83 e8 01             	sub    $0x1,%eax
801041a9:	85 c0                	test   %eax,%eax
801041ab:	7e 11                	jle    801041be <safestrcpy+0x33>
801041ad:	8d 71 01             	lea    0x1(%ecx),%esi
801041b0:	8d 5a 01             	lea    0x1(%edx),%ebx
801041b3:	0f b6 09             	movzbl (%ecx),%ecx
801041b6:	88 0a                	mov    %cl,(%edx)
801041b8:	84 c9                	test   %cl,%cl
801041ba:	75 e6                	jne    801041a2 <safestrcpy+0x17>
801041bc:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
801041be:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801041c1:	89 f8                	mov    %edi,%eax
801041c3:	5b                   	pop    %ebx
801041c4:	5e                   	pop    %esi
801041c5:	5f                   	pop    %edi
801041c6:	5d                   	pop    %ebp
801041c7:	c3                   	ret    

801041c8 <strlen>:

int
strlen(const char *s)
{
801041c8:	55                   	push   %ebp
801041c9:	89 e5                	mov    %esp,%ebp
801041cb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801041ce:	b8 00 00 00 00       	mov    $0x0,%eax
801041d3:	eb 03                	jmp    801041d8 <strlen+0x10>
801041d5:	83 c0 01             	add    $0x1,%eax
801041d8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801041dc:	75 f7                	jne    801041d5 <strlen+0xd>
    ;
  return n;
}
801041de:	5d                   	pop    %ebp
801041df:	c3                   	ret    

801041e0 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801041e0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801041e4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801041e8:	55                   	push   %ebp
  pushl %ebx
801041e9:	53                   	push   %ebx
  pushl %esi
801041ea:	56                   	push   %esi
  pushl %edi
801041eb:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801041ec:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801041ee:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801041f0:	5f                   	pop    %edi
  popl %esi
801041f1:	5e                   	pop    %esi
  popl %ebx
801041f2:	5b                   	pop    %ebx
  popl %ebp
801041f3:	5d                   	pop    %ebp
  ret
801041f4:	c3                   	ret    

801041f5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801041f5:	55                   	push   %ebp
801041f6:	89 e5                	mov    %esp,%ebp
801041f8:	53                   	push   %ebx
801041f9:	83 ec 04             	sub    $0x4,%esp
801041fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801041ff:	e8 c5 f0 ff ff       	call   801032c9 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104204:	8b 00                	mov    (%eax),%eax
80104206:	39 d8                	cmp    %ebx,%eax
80104208:	76 18                	jbe    80104222 <fetchint+0x2d>
8010420a:	8d 53 04             	lea    0x4(%ebx),%edx
8010420d:	39 d0                	cmp    %edx,%eax
8010420f:	72 18                	jb     80104229 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80104211:	8b 13                	mov    (%ebx),%edx
80104213:	8b 45 0c             	mov    0xc(%ebp),%eax
80104216:	89 10                	mov    %edx,(%eax)
  return 0;
80104218:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104220:	c9                   	leave  
80104221:	c3                   	ret    
    return -1;
80104222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104227:	eb f4                	jmp    8010421d <fetchint+0x28>
80104229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010422e:	eb ed                	jmp    8010421d <fetchint+0x28>

80104230 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 04             	sub    $0x4,%esp
80104237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010423a:	e8 8a f0 ff ff       	call   801032c9 <myproc>

  if(addr >= curproc->sz)
8010423f:	39 18                	cmp    %ebx,(%eax)
80104241:	76 25                	jbe    80104268 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
80104243:	8b 55 0c             	mov    0xc(%ebp),%edx
80104246:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104248:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010424a:	89 d8                	mov    %ebx,%eax
8010424c:	eb 03                	jmp    80104251 <fetchstr+0x21>
8010424e:	83 c0 01             	add    $0x1,%eax
80104251:	39 d0                	cmp    %edx,%eax
80104253:	73 09                	jae    8010425e <fetchstr+0x2e>
    if(*s == 0)
80104255:	80 38 00             	cmpb   $0x0,(%eax)
80104258:	75 f4                	jne    8010424e <fetchstr+0x1e>
      return s - *pp;
8010425a:	29 d8                	sub    %ebx,%eax
8010425c:	eb 05                	jmp    80104263 <fetchstr+0x33>
  }
  return -1;
8010425e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104266:	c9                   	leave  
80104267:	c3                   	ret    
    return -1;
80104268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010426d:	eb f4                	jmp    80104263 <fetchstr+0x33>

8010426f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010426f:	55                   	push   %ebp
80104270:	89 e5                	mov    %esp,%ebp
80104272:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104275:	e8 4f f0 ff ff       	call   801032c9 <myproc>
8010427a:	8b 50 18             	mov    0x18(%eax),%edx
8010427d:	8b 45 08             	mov    0x8(%ebp),%eax
80104280:	c1 e0 02             	shl    $0x2,%eax
80104283:	03 42 44             	add    0x44(%edx),%eax
80104286:	83 ec 08             	sub    $0x8,%esp
80104289:	ff 75 0c             	push   0xc(%ebp)
8010428c:	83 c0 04             	add    $0x4,%eax
8010428f:	50                   	push   %eax
80104290:	e8 60 ff ff ff       	call   801041f5 <fetchint>
}
80104295:	c9                   	leave  
80104296:	c3                   	ret    

80104297 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104297:	55                   	push   %ebp
80104298:	89 e5                	mov    %esp,%ebp
8010429a:	56                   	push   %esi
8010429b:	53                   	push   %ebx
8010429c:	83 ec 10             	sub    $0x10,%esp
8010429f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801042a2:	e8 22 f0 ff ff       	call   801032c9 <myproc>
801042a7:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801042a9:	83 ec 08             	sub    $0x8,%esp
801042ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801042af:	50                   	push   %eax
801042b0:	ff 75 08             	push   0x8(%ebp)
801042b3:	e8 b7 ff ff ff       	call   8010426f <argint>
801042b8:	83 c4 10             	add    $0x10,%esp
801042bb:	85 c0                	test   %eax,%eax
801042bd:	78 24                	js     801042e3 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801042bf:	85 db                	test   %ebx,%ebx
801042c1:	78 27                	js     801042ea <argptr+0x53>
801042c3:	8b 16                	mov    (%esi),%edx
801042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c8:	39 c2                	cmp    %eax,%edx
801042ca:	76 25                	jbe    801042f1 <argptr+0x5a>
801042cc:	01 c3                	add    %eax,%ebx
801042ce:	39 da                	cmp    %ebx,%edx
801042d0:	72 26                	jb     801042f8 <argptr+0x61>
    return -1;
  *pp = (char*)i;
801042d2:	8b 55 0c             	mov    0xc(%ebp),%edx
801042d5:	89 02                	mov    %eax,(%edx)
  return 0;
801042d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042df:	5b                   	pop    %ebx
801042e0:	5e                   	pop    %esi
801042e1:	5d                   	pop    %ebp
801042e2:	c3                   	ret    
    return -1;
801042e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042e8:	eb f2                	jmp    801042dc <argptr+0x45>
    return -1;
801042ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ef:	eb eb                	jmp    801042dc <argptr+0x45>
801042f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042f6:	eb e4                	jmp    801042dc <argptr+0x45>
801042f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fd:	eb dd                	jmp    801042dc <argptr+0x45>

801042ff <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801042ff:	55                   	push   %ebp
80104300:	89 e5                	mov    %esp,%ebp
80104302:	83 ec 20             	sub    $0x20,%esp
             * If none of the above movements works then
             * BACKTRACK: unmark x, y as part of solution
             * path
             */
  int addr;
  if(argint(n, &addr) < 0)
80104305:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104308:	50                   	push   %eax
80104309:	ff 75 08             	push   0x8(%ebp)
8010430c:	e8 5e ff ff ff       	call   8010426f <argint>
80104311:	83 c4 10             	add    $0x10,%esp
80104314:	85 c0                	test   %eax,%eax
80104316:	78 13                	js     8010432b <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104318:	83 ec 08             	sub    $0x8,%esp
8010431b:	ff 75 0c             	push   0xc(%ebp)
8010431e:	ff 75 f4             	push   -0xc(%ebp)
80104321:	e8 0a ff ff ff       	call   80104230 <fetchstr>
80104326:	83 c4 10             	add    $0x10,%esp
}
80104329:	c9                   	leave  
8010432a:	c3                   	ret    
    return -1;
8010432b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104330:	eb f7                	jmp    80104329 <argstr+0x2a>

80104332 <syscall>:
[SYS_holding_mylock]    sys_holding_mylock,
};

void
syscall(void)
{
80104332:	55                   	push   %ebp
80104333:	89 e5                	mov    %esp,%ebp
80104335:	53                   	push   %ebx
80104336:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104339:	e8 8b ef ff ff       	call   801032c9 <myproc>
8010433e:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104340:	8b 40 18             	mov    0x18(%eax),%eax
80104343:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104346:	8d 50 ff             	lea    -0x1(%eax),%edx
80104349:	83 fa 28             	cmp    $0x28,%edx
8010434c:	77 17                	ja     80104365 <syscall+0x33>
8010434e:	8b 14 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%edx
80104355:	85 d2                	test   %edx,%edx
80104357:	74 0c                	je     80104365 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
80104359:	ff d2                	call   *%edx
8010435b:	89 c2                	mov    %eax,%edx
8010435d:	8b 43 18             	mov    0x18(%ebx),%eax
80104360:	89 50 1c             	mov    %edx,0x1c(%eax)
80104363:	eb 1f                	jmp    80104384 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104365:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104368:	50                   	push   %eax
80104369:	52                   	push   %edx
8010436a:	ff 73 10             	push   0x10(%ebx)
8010436d:	68 b9 72 10 80       	push   $0x801072b9
80104372:	e8 d0 c2 ff ff       	call   80100647 <cprintf>
    curproc->tf->eax = -1;
80104377:	8b 43 18             	mov    0x18(%ebx),%eax
8010437a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104381:	83 c4 10             	add    $0x10,%esp
  }
}
80104384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104387:	c9                   	leave  
80104388:	c3                   	ret    

80104389 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104389:	55                   	push   %ebp
8010438a:	89 e5                	mov    %esp,%ebp
8010438c:	56                   	push   %esi
8010438d:	53                   	push   %ebx
8010438e:	83 ec 18             	sub    $0x18,%esp
80104391:	89 d6                	mov    %edx,%esi
80104393:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
80104395:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104398:	52                   	push   %edx
80104399:	50                   	push   %eax
8010439a:	e8 d0 fe ff ff       	call   8010426f <argint>
8010439f:	83 c4 10             	add    $0x10,%esp
801043a2:	85 c0                	test   %eax,%eax
801043a4:	78 35                	js     801043db <argfd+0x52>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801043a6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801043aa:	77 28                	ja     801043d4 <argfd+0x4b>
801043ac:	e8 18 ef ff ff       	call   801032c9 <myproc>
801043b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043b4:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801043b8:	85 c0                	test   %eax,%eax
801043ba:	74 18                	je     801043d4 <argfd+0x4b>
    return -1;
  if (pfd)
801043bc:	85 f6                	test   %esi,%esi
801043be:	74 02                	je     801043c2 <argfd+0x39>
    *pfd = fd;
801043c0:	89 16                	mov    %edx,(%esi)
  if (pf)
801043c2:	85 db                	test   %ebx,%ebx
801043c4:	74 1c                	je     801043e2 <argfd+0x59>
    *pf = f;
801043c6:	89 03                	mov    %eax,(%ebx)
  return 0;
801043c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d0:	5b                   	pop    %ebx
801043d1:	5e                   	pop    %esi
801043d2:	5d                   	pop    %ebp
801043d3:	c3                   	ret    
    return -1;
801043d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d9:	eb f2                	jmp    801043cd <argfd+0x44>
    return -1;
801043db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e0:	eb eb                	jmp    801043cd <argfd+0x44>
  return 0;
801043e2:	b8 00 00 00 00       	mov    $0x0,%eax
801043e7:	eb e4                	jmp    801043cd <argfd+0x44>

801043e9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801043e9:	55                   	push   %ebp
801043ea:	89 e5                	mov    %esp,%ebp
801043ec:	53                   	push   %ebx
801043ed:	83 ec 04             	sub    $0x4,%esp
801043f0:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801043f2:	e8 d2 ee ff ff       	call   801032c9 <myproc>
801043f7:	89 c2                	mov    %eax,%edx

  for (fd = 0; fd < NOFILE; fd++)
801043f9:	b8 00 00 00 00       	mov    $0x0,%eax
801043fe:	83 f8 0f             	cmp    $0xf,%eax
80104401:	7f 12                	jg     80104415 <fdalloc+0x2c>
  {
    if (curproc->ofile[fd] == 0)
80104403:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104408:	74 05                	je     8010440f <fdalloc+0x26>
  for (fd = 0; fd < NOFILE; fd++)
8010440a:	83 c0 01             	add    $0x1,%eax
8010440d:	eb ef                	jmp    801043fe <fdalloc+0x15>
    {
      curproc->ofile[fd] = f;
8010440f:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104413:	eb 05                	jmp    8010441a <fdalloc+0x31>
    }
  }
  return -1;
80104415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010441a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010441d:	c9                   	leave  
8010441e:	c3                   	ret    

8010441f <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010441f:	55                   	push   %ebp
80104420:	89 e5                	mov    %esp,%ebp
80104422:	56                   	push   %esi
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
80104427:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80104429:	b8 20 00 00 00       	mov    $0x20,%eax
8010442e:	89 c6                	mov    %eax,%esi
80104430:	39 83 a8 00 00 00    	cmp    %eax,0xa8(%ebx)
80104436:	76 2e                	jbe    80104466 <isdirempty+0x47>
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80104438:	6a 10                	push   $0x10
8010443a:	50                   	push   %eax
8010443b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010443e:	50                   	push   %eax
8010443f:	53                   	push   %ebx
80104440:	e8 d6 d3 ff ff       	call   8010181b <readi>
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	83 f8 10             	cmp    $0x10,%eax
8010444b:	75 0c                	jne    80104459 <isdirempty+0x3a>
      panic("isdirempty: readi");
    if (de.inum != 0)
8010444d:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104452:	75 1e                	jne    80104472 <isdirempty+0x53>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80104454:	8d 46 10             	lea    0x10(%esi),%eax
80104457:	eb d5                	jmp    8010442e <isdirempty+0xf>
      panic("isdirempty: readi");
80104459:	83 ec 0c             	sub    $0xc,%esp
8010445c:	68 88 73 10 80       	push   $0x80107388
80104461:	e8 22 bf ff ff       	call   80100388 <panic>
      return 0;
  }
  return 1;
80104466:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010446b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010446e:	5b                   	pop    %ebx
8010446f:	5e                   	pop    %esi
80104470:	5d                   	pop    %ebp
80104471:	c3                   	ret    
      return 0;
80104472:	b8 00 00 00 00       	mov    $0x0,%eax
80104477:	eb f2                	jmp    8010446b <isdirempty+0x4c>

80104479 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80104479:	55                   	push   %ebp
8010447a:	89 e5                	mov    %esp,%ebp
8010447c:	57                   	push   %edi
8010447d:	56                   	push   %esi
8010447e:	53                   	push   %ebx
8010447f:	83 ec 34             	sub    $0x34,%esp
80104482:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104485:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104488:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
8010448b:	8d 55 da             	lea    -0x26(%ebp),%edx
8010448e:	52                   	push   %edx
8010448f:	50                   	push   %eax
80104490:	e8 37 d8 ff ff       	call   80101ccc <nameiparent>
80104495:	89 c6                	mov    %eax,%esi
80104497:	83 c4 10             	add    $0x10,%esp
8010449a:	85 c0                	test   %eax,%eax
8010449c:	0f 84 45 01 00 00    	je     801045e7 <create+0x16e>
    return 0;
  ilock(dp);
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	50                   	push   %eax
801044a6:	e8 48 d1 ff ff       	call   801015f3 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801044ab:	83 c4 0c             	add    $0xc,%esp
801044ae:	6a 00                	push   $0x0
801044b0:	8d 45 da             	lea    -0x26(%ebp),%eax
801044b3:	50                   	push   %eax
801044b4:	56                   	push   %esi
801044b5:	e8 c0 d5 ff ff       	call   80101a7a <dirlookup>
801044ba:	89 c3                	mov    %eax,%ebx
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	85 c0                	test   %eax,%eax
801044c1:	74 40                	je     80104503 <create+0x8a>
  {
    iunlockput(dp);
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	56                   	push   %esi
801044c7:	e8 fb d2 ff ff       	call   801017c7 <iunlockput>
    ilock(ip);
801044cc:	89 1c 24             	mov    %ebx,(%esp)
801044cf:	e8 1f d1 ff ff       	call   801015f3 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
801044d4:	83 c4 10             	add    $0x10,%esp
801044d7:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801044dc:	75 0a                	jne    801044e8 <create+0x6f>
801044de:	66 83 bb a0 00 00 00 	cmpw   $0x2,0xa0(%ebx)
801044e5:	02 
801044e6:	74 11                	je     801044f9 <create+0x80>
      return ip;
    iunlockput(ip);
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	53                   	push   %ebx
801044ec:	e8 d6 d2 ff ff       	call   801017c7 <iunlockput>
    return 0;
801044f1:	83 c4 10             	add    $0x10,%esp
801044f4:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801044f9:	89 d8                	mov    %ebx,%eax
801044fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fe:	5b                   	pop    %ebx
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
  if ((ip = ialloc(dp->dev, type)) == 0)
80104503:	83 ec 08             	sub    $0x8,%esp
80104506:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010450a:	50                   	push   %eax
8010450b:	ff 36                	push   (%esi)
8010450d:	e8 ba ce ff ff       	call   801013cc <ialloc>
80104512:	89 c3                	mov    %eax,%ebx
80104514:	83 c4 10             	add    $0x10,%esp
80104517:	85 c0                	test   %eax,%eax
80104519:	74 5b                	je     80104576 <create+0xfd>
  ilock(ip);
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	50                   	push   %eax
8010451f:	e8 cf d0 ff ff       	call   801015f3 <ilock>
  ip->major = major;
80104524:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104528:	66 89 83 a2 00 00 00 	mov    %ax,0xa2(%ebx)
  ip->minor = minor;
8010452f:	66 89 bb a4 00 00 00 	mov    %di,0xa4(%ebx)
  ip->nlink = 1;
80104536:	66 c7 83 a6 00 00 00 	movw   $0x1,0xa6(%ebx)
8010453d:	01 00 
  iupdate(ip);
8010453f:	89 1c 24             	mov    %ebx,(%esp)
80104542:	e8 2a cf ff ff       	call   80101471 <iupdate>
  if (type == T_DIR)
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010454f:	74 32                	je     80104583 <create+0x10a>
  if (dirlink(dp, name, ip->inum) < 0)
80104551:	83 ec 04             	sub    $0x4,%esp
80104554:	ff 73 04             	push   0x4(%ebx)
80104557:	8d 45 da             	lea    -0x26(%ebp),%eax
8010455a:	50                   	push   %eax
8010455b:	56                   	push   %esi
8010455c:	e8 9f d6 ff ff       	call   80101c00 <dirlink>
80104561:	83 c4 10             	add    $0x10,%esp
80104564:	85 c0                	test   %eax,%eax
80104566:	78 72                	js     801045da <create+0x161>
  iunlockput(dp);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	56                   	push   %esi
8010456c:	e8 56 d2 ff ff       	call   801017c7 <iunlockput>
  return ip;
80104571:	83 c4 10             	add    $0x10,%esp
80104574:	eb 83                	jmp    801044f9 <create+0x80>
    panic("create: ialloc");
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	68 9a 73 10 80       	push   $0x8010739a
8010457e:	e8 05 be ff ff       	call   80100388 <panic>
    dp->nlink++; // for ".."
80104583:	0f b7 86 a6 00 00 00 	movzwl 0xa6(%esi),%eax
8010458a:	83 c0 01             	add    $0x1,%eax
8010458d:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
    iupdate(dp);
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	56                   	push   %esi
80104598:	e8 d4 ce ff ff       	call   80101471 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010459d:	83 c4 0c             	add    $0xc,%esp
801045a0:	ff 73 04             	push   0x4(%ebx)
801045a3:	68 aa 73 10 80       	push   $0x801073aa
801045a8:	53                   	push   %ebx
801045a9:	e8 52 d6 ff ff       	call   80101c00 <dirlink>
801045ae:	83 c4 10             	add    $0x10,%esp
801045b1:	85 c0                	test   %eax,%eax
801045b3:	78 18                	js     801045cd <create+0x154>
801045b5:	83 ec 04             	sub    $0x4,%esp
801045b8:	ff 76 04             	push   0x4(%esi)
801045bb:	68 a9 73 10 80       	push   $0x801073a9
801045c0:	53                   	push   %ebx
801045c1:	e8 3a d6 ff ff       	call   80101c00 <dirlink>
801045c6:	83 c4 10             	add    $0x10,%esp
801045c9:	85 c0                	test   %eax,%eax
801045cb:	79 84                	jns    80104551 <create+0xd8>
      panic("create dots");
801045cd:	83 ec 0c             	sub    $0xc,%esp
801045d0:	68 ac 73 10 80       	push   $0x801073ac
801045d5:	e8 ae bd ff ff       	call   80100388 <panic>
    panic("create: dirlink");
801045da:	83 ec 0c             	sub    $0xc,%esp
801045dd:	68 b8 73 10 80       	push   $0x801073b8
801045e2:	e8 a1 bd ff ff       	call   80100388 <panic>
    return 0;
801045e7:	89 c3                	mov    %eax,%ebx
801045e9:	e9 0b ff ff ff       	jmp    801044f9 <create+0x80>

801045ee <sys_dup>:
{
801045ee:	55                   	push   %ebp
801045ef:	89 e5                	mov    %esp,%ebp
801045f1:	53                   	push   %ebx
801045f2:	83 ec 14             	sub    $0x14,%esp
  if (argfd(0, 0, &f) < 0)
801045f5:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801045f8:	ba 00 00 00 00       	mov    $0x0,%edx
801045fd:	b8 00 00 00 00       	mov    $0x0,%eax
80104602:	e8 82 fd ff ff       	call   80104389 <argfd>
80104607:	85 c0                	test   %eax,%eax
80104609:	78 23                	js     8010462e <sys_dup+0x40>
  if ((fd = fdalloc(f)) < 0)
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	e8 d6 fd ff ff       	call   801043e9 <fdalloc>
80104613:	89 c3                	mov    %eax,%ebx
80104615:	85 c0                	test   %eax,%eax
80104617:	78 1c                	js     80104635 <sys_dup+0x47>
  filedup(f);
80104619:	83 ec 0c             	sub    $0xc,%esp
8010461c:	ff 75 f4             	push   -0xc(%ebp)
8010461f:	e8 9a c6 ff ff       	call   80100cbe <filedup>
  return fd;
80104624:	83 c4 10             	add    $0x10,%esp
}
80104627:	89 d8                	mov    %ebx,%eax
80104629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010462c:	c9                   	leave  
8010462d:	c3                   	ret    
    return -1;
8010462e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104633:	eb f2                	jmp    80104627 <sys_dup+0x39>
    return -1;
80104635:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010463a:	eb eb                	jmp    80104627 <sys_dup+0x39>

8010463c <sys_read>:
{
8010463c:	55                   	push   %ebp
8010463d:	89 e5                	mov    %esp,%ebp
8010463f:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104642:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104645:	ba 00 00 00 00       	mov    $0x0,%edx
8010464a:	b8 00 00 00 00       	mov    $0x0,%eax
8010464f:	e8 35 fd ff ff       	call   80104389 <argfd>
80104654:	85 c0                	test   %eax,%eax
80104656:	78 43                	js     8010469b <sys_read+0x5f>
80104658:	83 ec 08             	sub    $0x8,%esp
8010465b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010465e:	50                   	push   %eax
8010465f:	6a 02                	push   $0x2
80104661:	e8 09 fc ff ff       	call   8010426f <argint>
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	85 c0                	test   %eax,%eax
8010466b:	78 2e                	js     8010469b <sys_read+0x5f>
8010466d:	83 ec 04             	sub    $0x4,%esp
80104670:	ff 75 f0             	push   -0x10(%ebp)
80104673:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104676:	50                   	push   %eax
80104677:	6a 01                	push   $0x1
80104679:	e8 19 fc ff ff       	call   80104297 <argptr>
8010467e:	83 c4 10             	add    $0x10,%esp
80104681:	85 c0                	test   %eax,%eax
80104683:	78 16                	js     8010469b <sys_read+0x5f>
  return fileread(f, p, n);
80104685:	83 ec 04             	sub    $0x4,%esp
80104688:	ff 75 f0             	push   -0x10(%ebp)
8010468b:	ff 75 ec             	push   -0x14(%ebp)
8010468e:	ff 75 f4             	push   -0xc(%ebp)
80104691:	e8 7a c7 ff ff       	call   80100e10 <fileread>
80104696:	83 c4 10             	add    $0x10,%esp
}
80104699:	c9                   	leave  
8010469a:	c3                   	ret    
    return -1;
8010469b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a0:	eb f7                	jmp    80104699 <sys_read+0x5d>

801046a2 <sys_write>:
{
801046a2:	55                   	push   %ebp
801046a3:	89 e5                	mov    %esp,%ebp
801046a5:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801046a8:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801046ab:	ba 00 00 00 00       	mov    $0x0,%edx
801046b0:	b8 00 00 00 00       	mov    $0x0,%eax
801046b5:	e8 cf fc ff ff       	call   80104389 <argfd>
801046ba:	85 c0                	test   %eax,%eax
801046bc:	78 43                	js     80104701 <sys_write+0x5f>
801046be:	83 ec 08             	sub    $0x8,%esp
801046c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046c4:	50                   	push   %eax
801046c5:	6a 02                	push   $0x2
801046c7:	e8 a3 fb ff ff       	call   8010426f <argint>
801046cc:	83 c4 10             	add    $0x10,%esp
801046cf:	85 c0                	test   %eax,%eax
801046d1:	78 2e                	js     80104701 <sys_write+0x5f>
801046d3:	83 ec 04             	sub    $0x4,%esp
801046d6:	ff 75 f0             	push   -0x10(%ebp)
801046d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801046dc:	50                   	push   %eax
801046dd:	6a 01                	push   $0x1
801046df:	e8 b3 fb ff ff       	call   80104297 <argptr>
801046e4:	83 c4 10             	add    $0x10,%esp
801046e7:	85 c0                	test   %eax,%eax
801046e9:	78 16                	js     80104701 <sys_write+0x5f>
  return filewrite(f, p, n);
801046eb:	83 ec 04             	sub    $0x4,%esp
801046ee:	ff 75 f0             	push   -0x10(%ebp)
801046f1:	ff 75 ec             	push   -0x14(%ebp)
801046f4:	ff 75 f4             	push   -0xc(%ebp)
801046f7:	e8 99 c7 ff ff       	call   80100e95 <filewrite>
801046fc:	83 c4 10             	add    $0x10,%esp
}
801046ff:	c9                   	leave  
80104700:	c3                   	ret    
    return -1;
80104701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104706:	eb f7                	jmp    801046ff <sys_write+0x5d>

80104708 <sys_close>:
{
80104708:	55                   	push   %ebp
80104709:	89 e5                	mov    %esp,%ebp
8010470b:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
8010470e:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104711:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104714:	b8 00 00 00 00       	mov    $0x0,%eax
80104719:	e8 6b fc ff ff       	call   80104389 <argfd>
8010471e:	85 c0                	test   %eax,%eax
80104720:	78 25                	js     80104747 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104722:	e8 a2 eb ff ff       	call   801032c9 <myproc>
80104727:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010472a:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104731:	00 
  fileclose(f);
80104732:	83 ec 0c             	sub    $0xc,%esp
80104735:	ff 75 f0             	push   -0x10(%ebp)
80104738:	e8 c6 c5 ff ff       	call   80100d03 <fileclose>
  return 0;
8010473d:	83 c4 10             	add    $0x10,%esp
80104740:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104745:	c9                   	leave  
80104746:	c3                   	ret    
    return -1;
80104747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010474c:	eb f7                	jmp    80104745 <sys_close+0x3d>

8010474e <sys_fstat>:
{
8010474e:	55                   	push   %ebp
8010474f:	89 e5                	mov    %esp,%ebp
80104751:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80104754:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104757:	ba 00 00 00 00       	mov    $0x0,%edx
8010475c:	b8 00 00 00 00       	mov    $0x0,%eax
80104761:	e8 23 fc ff ff       	call   80104389 <argfd>
80104766:	85 c0                	test   %eax,%eax
80104768:	78 2a                	js     80104794 <sys_fstat+0x46>
8010476a:	83 ec 04             	sub    $0x4,%esp
8010476d:	6a 14                	push   $0x14
8010476f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104772:	50                   	push   %eax
80104773:	6a 01                	push   $0x1
80104775:	e8 1d fb ff ff       	call   80104297 <argptr>
8010477a:	83 c4 10             	add    $0x10,%esp
8010477d:	85 c0                	test   %eax,%eax
8010477f:	78 13                	js     80104794 <sys_fstat+0x46>
  return filestat(f, st);
80104781:	83 ec 08             	sub    $0x8,%esp
80104784:	ff 75 f0             	push   -0x10(%ebp)
80104787:	ff 75 f4             	push   -0xc(%ebp)
8010478a:	e8 3a c6 ff ff       	call   80100dc9 <filestat>
8010478f:	83 c4 10             	add    $0x10,%esp
}
80104792:	c9                   	leave  
80104793:	c3                   	ret    
    return -1;
80104794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104799:	eb f7                	jmp    80104792 <sys_fstat+0x44>

8010479b <sys_link>:
{
8010479b:	55                   	push   %ebp
8010479c:	89 e5                	mov    %esp,%ebp
8010479e:	56                   	push   %esi
8010479f:	53                   	push   %ebx
801047a0:	83 ec 28             	sub    $0x28,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801047a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801047a6:	50                   	push   %eax
801047a7:	6a 00                	push   $0x0
801047a9:	e8 51 fb ff ff       	call   801042ff <argstr>
801047ae:	83 c4 10             	add    $0x10,%esp
801047b1:	85 c0                	test   %eax,%eax
801047b3:	0f 88 dc 00 00 00    	js     80104895 <sys_link+0xfa>
801047b9:	83 ec 08             	sub    $0x8,%esp
801047bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801047bf:	50                   	push   %eax
801047c0:	6a 01                	push   $0x1
801047c2:	e8 38 fb ff ff       	call   801042ff <argstr>
801047c7:	83 c4 10             	add    $0x10,%esp
801047ca:	85 c0                	test   %eax,%eax
801047cc:	0f 88 c3 00 00 00    	js     80104895 <sys_link+0xfa>
  begin_op();
801047d2:	e8 b5 e0 ff ff       	call   8010288c <begin_op>
  if ((ip = namei(old)) == 0)
801047d7:	83 ec 0c             	sub    $0xc,%esp
801047da:	ff 75 e0             	push   -0x20(%ebp)
801047dd:	e8 d2 d4 ff ff       	call   80101cb4 <namei>
801047e2:	89 c3                	mov    %eax,%ebx
801047e4:	83 c4 10             	add    $0x10,%esp
801047e7:	85 c0                	test   %eax,%eax
801047e9:	0f 84 ad 00 00 00    	je     8010489c <sys_link+0x101>
  ilock(ip);
801047ef:	83 ec 0c             	sub    $0xc,%esp
801047f2:	50                   	push   %eax
801047f3:	e8 fb cd ff ff       	call   801015f3 <ilock>
  if (ip->type == T_DIR)
801047f8:	83 c4 10             	add    $0x10,%esp
801047fb:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80104802:	01 
80104803:	0f 84 9f 00 00 00    	je     801048a8 <sys_link+0x10d>
  ip->nlink++;
80104809:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
80104810:	83 c0 01             	add    $0x1,%eax
80104813:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
8010481a:	83 ec 0c             	sub    $0xc,%esp
8010481d:	53                   	push   %ebx
8010481e:	e8 4e cc ff ff       	call   80101471 <iupdate>
  iunlock(ip);
80104823:	89 1c 24             	mov    %ebx,(%esp)
80104826:	e8 a8 ce ff ff       	call   801016d3 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
8010482b:	83 c4 08             	add    $0x8,%esp
8010482e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104831:	50                   	push   %eax
80104832:	ff 75 e4             	push   -0x1c(%ebp)
80104835:	e8 92 d4 ff ff       	call   80101ccc <nameiparent>
8010483a:	89 c6                	mov    %eax,%esi
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	85 c0                	test   %eax,%eax
80104841:	0f 84 85 00 00 00    	je     801048cc <sys_link+0x131>
  ilock(dp);
80104847:	83 ec 0c             	sub    $0xc,%esp
8010484a:	50                   	push   %eax
8010484b:	e8 a3 cd ff ff       	call   801015f3 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80104850:	83 c4 10             	add    $0x10,%esp
80104853:	8b 03                	mov    (%ebx),%eax
80104855:	39 06                	cmp    %eax,(%esi)
80104857:	75 67                	jne    801048c0 <sys_link+0x125>
80104859:	83 ec 04             	sub    $0x4,%esp
8010485c:	ff 73 04             	push   0x4(%ebx)
8010485f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104862:	50                   	push   %eax
80104863:	56                   	push   %esi
80104864:	e8 97 d3 ff ff       	call   80101c00 <dirlink>
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	85 c0                	test   %eax,%eax
8010486e:	78 50                	js     801048c0 <sys_link+0x125>
  iunlockput(dp);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	56                   	push   %esi
80104874:	e8 4e cf ff ff       	call   801017c7 <iunlockput>
  iput(ip);
80104879:	89 1c 24             	mov    %ebx,(%esp)
8010487c:	e8 97 ce ff ff       	call   80101718 <iput>
  end_op();
80104881:	e8 80 e0 ff ff       	call   80102906 <end_op>
  return 0;
80104886:	83 c4 10             	add    $0x10,%esp
80104889:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010488e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104891:	5b                   	pop    %ebx
80104892:	5e                   	pop    %esi
80104893:	5d                   	pop    %ebp
80104894:	c3                   	ret    
    return -1;
80104895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010489a:	eb f2                	jmp    8010488e <sys_link+0xf3>
    end_op();
8010489c:	e8 65 e0 ff ff       	call   80102906 <end_op>
    return -1;
801048a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a6:	eb e6                	jmp    8010488e <sys_link+0xf3>
    iunlockput(ip);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	53                   	push   %ebx
801048ac:	e8 16 cf ff ff       	call   801017c7 <iunlockput>
    end_op();
801048b1:	e8 50 e0 ff ff       	call   80102906 <end_op>
    return -1;
801048b6:	83 c4 10             	add    $0x10,%esp
801048b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048be:	eb ce                	jmp    8010488e <sys_link+0xf3>
    iunlockput(dp);
801048c0:	83 ec 0c             	sub    $0xc,%esp
801048c3:	56                   	push   %esi
801048c4:	e8 fe ce ff ff       	call   801017c7 <iunlockput>
    goto bad;
801048c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801048cc:	83 ec 0c             	sub    $0xc,%esp
801048cf:	53                   	push   %ebx
801048d0:	e8 1e cd ff ff       	call   801015f3 <ilock>
  ip->nlink--;
801048d5:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
801048dc:	83 e8 01             	sub    $0x1,%eax
801048df:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
801048e6:	89 1c 24             	mov    %ebx,(%esp)
801048e9:	e8 83 cb ff ff       	call   80101471 <iupdate>
  iunlockput(ip);
801048ee:	89 1c 24             	mov    %ebx,(%esp)
801048f1:	e8 d1 ce ff ff       	call   801017c7 <iunlockput>
  end_op();
801048f6:	e8 0b e0 ff ff       	call   80102906 <end_op>
  return -1;
801048fb:	83 c4 10             	add    $0x10,%esp
801048fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104903:	eb 89                	jmp    8010488e <sys_link+0xf3>

80104905 <sys_unlink>:
{
80104905:	55                   	push   %ebp
80104906:	89 e5                	mov    %esp,%ebp
80104908:	57                   	push   %edi
80104909:	56                   	push   %esi
8010490a:	53                   	push   %ebx
8010490b:	83 ec 44             	sub    $0x44,%esp
  if (argstr(0, &path) < 0)
8010490e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104911:	50                   	push   %eax
80104912:	6a 00                	push   $0x0
80104914:	e8 e6 f9 ff ff       	call   801042ff <argstr>
80104919:	83 c4 10             	add    $0x10,%esp
8010491c:	85 c0                	test   %eax,%eax
8010491e:	0f 88 98 01 00 00    	js     80104abc <sys_unlink+0x1b7>
  begin_op();
80104924:	e8 63 df ff ff       	call   8010288c <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80104929:	83 ec 08             	sub    $0x8,%esp
8010492c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010492f:	50                   	push   %eax
80104930:	ff 75 c4             	push   -0x3c(%ebp)
80104933:	e8 94 d3 ff ff       	call   80101ccc <nameiparent>
80104938:	89 c6                	mov    %eax,%esi
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	85 c0                	test   %eax,%eax
8010493f:	0f 84 fc 00 00 00    	je     80104a41 <sys_unlink+0x13c>
  ilock(dp);
80104945:	83 ec 0c             	sub    $0xc,%esp
80104948:	50                   	push   %eax
80104949:	e8 a5 cc ff ff       	call   801015f3 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010494e:	83 c4 08             	add    $0x8,%esp
80104951:	68 aa 73 10 80       	push   $0x801073aa
80104956:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104959:	50                   	push   %eax
8010495a:	e8 06 d1 ff ff       	call   80101a65 <namecmp>
8010495f:	83 c4 10             	add    $0x10,%esp
80104962:	85 c0                	test   %eax,%eax
80104964:	0f 84 0b 01 00 00    	je     80104a75 <sys_unlink+0x170>
8010496a:	83 ec 08             	sub    $0x8,%esp
8010496d:	68 a9 73 10 80       	push   $0x801073a9
80104972:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104975:	50                   	push   %eax
80104976:	e8 ea d0 ff ff       	call   80101a65 <namecmp>
8010497b:	83 c4 10             	add    $0x10,%esp
8010497e:	85 c0                	test   %eax,%eax
80104980:	0f 84 ef 00 00 00    	je     80104a75 <sys_unlink+0x170>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80104986:	83 ec 04             	sub    $0x4,%esp
80104989:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010498c:	50                   	push   %eax
8010498d:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104990:	50                   	push   %eax
80104991:	56                   	push   %esi
80104992:	e8 e3 d0 ff ff       	call   80101a7a <dirlookup>
80104997:	89 c3                	mov    %eax,%ebx
80104999:	83 c4 10             	add    $0x10,%esp
8010499c:	85 c0                	test   %eax,%eax
8010499e:	0f 84 d1 00 00 00    	je     80104a75 <sys_unlink+0x170>
  ilock(ip);
801049a4:	83 ec 0c             	sub    $0xc,%esp
801049a7:	50                   	push   %eax
801049a8:	e8 46 cc ff ff       	call   801015f3 <ilock>
  if (ip->nlink < 1)
801049ad:	83 c4 10             	add    $0x10,%esp
801049b0:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
801049b7:	00 
801049b8:	0f 8e 8f 00 00 00    	jle    80104a4d <sys_unlink+0x148>
  if (ip->type == T_DIR && !isdirempty(ip))
801049be:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
801049c5:	01 
801049c6:	0f 84 8e 00 00 00    	je     80104a5a <sys_unlink+0x155>
  memset(&de, 0, sizeof(de));
801049cc:	83 ec 04             	sub    $0x4,%esp
801049cf:	6a 10                	push   $0x10
801049d1:	6a 00                	push   $0x0
801049d3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801049d6:	57                   	push   %edi
801049d7:	e8 43 f6 ff ff       	call   8010401f <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801049dc:	6a 10                	push   $0x10
801049de:	ff 75 c0             	push   -0x40(%ebp)
801049e1:	57                   	push   %edi
801049e2:	56                   	push   %esi
801049e3:	e8 3c cf ff ff       	call   80101924 <writei>
801049e8:	83 c4 20             	add    $0x20,%esp
801049eb:	83 f8 10             	cmp    $0x10,%eax
801049ee:	0f 85 99 00 00 00    	jne    80104a8d <sys_unlink+0x188>
  if (ip->type == T_DIR)
801049f4:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
801049fb:	01 
801049fc:	0f 84 98 00 00 00    	je     80104a9a <sys_unlink+0x195>
  iunlockput(dp);
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	56                   	push   %esi
80104a06:	e8 bc cd ff ff       	call   801017c7 <iunlockput>
  ip->nlink--;
80104a0b:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
80104a12:	83 e8 01             	sub    $0x1,%eax
80104a15:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
80104a1c:	89 1c 24             	mov    %ebx,(%esp)
80104a1f:	e8 4d ca ff ff       	call   80101471 <iupdate>
  iunlockput(ip);
80104a24:	89 1c 24             	mov    %ebx,(%esp)
80104a27:	e8 9b cd ff ff       	call   801017c7 <iunlockput>
  end_op();
80104a2c:	e8 d5 de ff ff       	call   80102906 <end_op>
  return 0;
80104a31:	83 c4 10             	add    $0x10,%esp
80104a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a3c:	5b                   	pop    %ebx
80104a3d:	5e                   	pop    %esi
80104a3e:	5f                   	pop    %edi
80104a3f:	5d                   	pop    %ebp
80104a40:	c3                   	ret    
    end_op();
80104a41:	e8 c0 de ff ff       	call   80102906 <end_op>
    return -1;
80104a46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4b:	eb ec                	jmp    80104a39 <sys_unlink+0x134>
    panic("unlink: nlink < 1");
80104a4d:	83 ec 0c             	sub    $0xc,%esp
80104a50:	68 c8 73 10 80       	push   $0x801073c8
80104a55:	e8 2e b9 ff ff       	call   80100388 <panic>
  if (ip->type == T_DIR && !isdirempty(ip))
80104a5a:	89 d8                	mov    %ebx,%eax
80104a5c:	e8 be f9 ff ff       	call   8010441f <isdirempty>
80104a61:	85 c0                	test   %eax,%eax
80104a63:	0f 85 63 ff ff ff    	jne    801049cc <sys_unlink+0xc7>
    iunlockput(ip);
80104a69:	83 ec 0c             	sub    $0xc,%esp
80104a6c:	53                   	push   %ebx
80104a6d:	e8 55 cd ff ff       	call   801017c7 <iunlockput>
    goto bad;
80104a72:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	56                   	push   %esi
80104a79:	e8 49 cd ff ff       	call   801017c7 <iunlockput>
  end_op();
80104a7e:	e8 83 de ff ff       	call   80102906 <end_op>
  return -1;
80104a83:	83 c4 10             	add    $0x10,%esp
80104a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8b:	eb ac                	jmp    80104a39 <sys_unlink+0x134>
    panic("unlink: writei");
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	68 da 73 10 80       	push   $0x801073da
80104a95:	e8 ee b8 ff ff       	call   80100388 <panic>
    dp->nlink--;
80104a9a:	0f b7 86 a6 00 00 00 	movzwl 0xa6(%esi),%eax
80104aa1:	83 e8 01             	sub    $0x1,%eax
80104aa4:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
    iupdate(dp);
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	56                   	push   %esi
80104aaf:	e8 bd c9 ff ff       	call   80101471 <iupdate>
80104ab4:	83 c4 10             	add    $0x10,%esp
80104ab7:	e9 46 ff ff ff       	jmp    80104a02 <sys_unlink+0xfd>
    return -1;
80104abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac1:	e9 73 ff ff ff       	jmp    80104a39 <sys_unlink+0x134>

80104ac6 <sys_open>:

int sys_open(void)
{
80104ac6:	55                   	push   %ebp
80104ac7:	89 e5                	mov    %esp,%ebp
80104ac9:	57                   	push   %edi
80104aca:	56                   	push   %esi
80104acb:	53                   	push   %ebx
80104acc:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104acf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ad2:	50                   	push   %eax
80104ad3:	6a 00                	push   $0x0
80104ad5:	e8 25 f8 ff ff       	call   801042ff <argstr>
80104ada:	83 c4 10             	add    $0x10,%esp
80104add:	85 c0                	test   %eax,%eax
80104adf:	0f 88 a0 00 00 00    	js     80104b85 <sys_open+0xbf>
80104ae5:	83 ec 08             	sub    $0x8,%esp
80104ae8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104aeb:	50                   	push   %eax
80104aec:	6a 01                	push   $0x1
80104aee:	e8 7c f7 ff ff       	call   8010426f <argint>
80104af3:	83 c4 10             	add    $0x10,%esp
80104af6:	85 c0                	test   %eax,%eax
80104af8:	0f 88 87 00 00 00    	js     80104b85 <sys_open+0xbf>
    return -1;

  begin_op();
80104afe:	e8 89 dd ff ff       	call   8010288c <begin_op>

  if (omode & O_CREATE)
80104b03:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104b07:	0f 84 8b 00 00 00    	je     80104b98 <sys_open+0xd2>
  {
    ip = create(path, T_FILE, 0, 0);
80104b0d:	83 ec 0c             	sub    $0xc,%esp
80104b10:	6a 00                	push   $0x0
80104b12:	b9 00 00 00 00       	mov    $0x0,%ecx
80104b17:	ba 02 00 00 00       	mov    $0x2,%edx
80104b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b1f:	e8 55 f9 ff ff       	call   80104479 <create>
80104b24:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80104b26:	83 c4 10             	add    $0x10,%esp
80104b29:	85 c0                	test   %eax,%eax
80104b2b:	74 5f                	je     80104b8c <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80104b2d:	e8 2b c1 ff ff       	call   80100c5d <filealloc>
80104b32:	89 c3                	mov    %eax,%ebx
80104b34:	85 c0                	test   %eax,%eax
80104b36:	0f 84 b8 00 00 00    	je     80104bf4 <sys_open+0x12e>
80104b3c:	e8 a8 f8 ff ff       	call   801043e9 <fdalloc>
80104b41:	89 c7                	mov    %eax,%edi
80104b43:	85 c0                	test   %eax,%eax
80104b45:	0f 88 a9 00 00 00    	js     80104bf4 <sys_open+0x12e>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b4b:	83 ec 0c             	sub    $0xc,%esp
80104b4e:	56                   	push   %esi
80104b4f:	e8 7f cb ff ff       	call   801016d3 <iunlock>
  end_op();
80104b54:	e8 ad dd ff ff       	call   80102906 <end_op>

  f->type = FD_INODE;
80104b59:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104b5f:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104b62:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104b69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b6c:	83 c4 10             	add    $0x10,%esp
80104b6f:	a8 01                	test   $0x1,%al
80104b71:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104b75:	a8 03                	test   $0x3,%al
80104b77:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104b7b:	89 f8                	mov    %edi,%eax
80104b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b80:	5b                   	pop    %ebx
80104b81:	5e                   	pop    %esi
80104b82:	5f                   	pop    %edi
80104b83:	5d                   	pop    %ebp
80104b84:	c3                   	ret    
    return -1;
80104b85:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b8a:	eb ef                	jmp    80104b7b <sys_open+0xb5>
      end_op();
80104b8c:	e8 75 dd ff ff       	call   80102906 <end_op>
      return -1;
80104b91:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b96:	eb e3                	jmp    80104b7b <sys_open+0xb5>
    if ((ip = namei(path)) == 0)
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	ff 75 e4             	push   -0x1c(%ebp)
80104b9e:	e8 11 d1 ff ff       	call   80101cb4 <namei>
80104ba3:	89 c6                	mov    %eax,%esi
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	74 3c                	je     80104be8 <sys_open+0x122>
    ilock(ip);
80104bac:	83 ec 0c             	sub    $0xc,%esp
80104baf:	50                   	push   %eax
80104bb0:	e8 3e ca ff ff       	call   801015f3 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80104bb5:	83 c4 10             	add    $0x10,%esp
80104bb8:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80104bbf:	01 
80104bc0:	0f 85 67 ff ff ff    	jne    80104b2d <sys_open+0x67>
80104bc6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104bca:	0f 84 5d ff ff ff    	je     80104b2d <sys_open+0x67>
      iunlockput(ip);
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	56                   	push   %esi
80104bd4:	e8 ee cb ff ff       	call   801017c7 <iunlockput>
      end_op();
80104bd9:	e8 28 dd ff ff       	call   80102906 <end_op>
      return -1;
80104bde:	83 c4 10             	add    $0x10,%esp
80104be1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104be6:	eb 93                	jmp    80104b7b <sys_open+0xb5>
      end_op();
80104be8:	e8 19 dd ff ff       	call   80102906 <end_op>
      return -1;
80104bed:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104bf2:	eb 87                	jmp    80104b7b <sys_open+0xb5>
    if (f)
80104bf4:	85 db                	test   %ebx,%ebx
80104bf6:	74 0c                	je     80104c04 <sys_open+0x13e>
      fileclose(f);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	53                   	push   %ebx
80104bfc:	e8 02 c1 ff ff       	call   80100d03 <fileclose>
80104c01:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	56                   	push   %esi
80104c08:	e8 ba cb ff ff       	call   801017c7 <iunlockput>
    end_op();
80104c0d:	e8 f4 dc ff ff       	call   80102906 <end_op>
    return -1;
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c1a:	e9 5c ff ff ff       	jmp    80104b7b <sys_open+0xb5>

80104c1f <sys_mkdir>:

int sys_mkdir(void)
{
80104c1f:	55                   	push   %ebp
80104c20:	89 e5                	mov    %esp,%ebp
80104c22:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104c25:	e8 62 dc ff ff       	call   8010288c <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80104c2a:	83 ec 08             	sub    $0x8,%esp
80104c2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c30:	50                   	push   %eax
80104c31:	6a 00                	push   $0x0
80104c33:	e8 c7 f6 ff ff       	call   801042ff <argstr>
80104c38:	83 c4 10             	add    $0x10,%esp
80104c3b:	85 c0                	test   %eax,%eax
80104c3d:	78 36                	js     80104c75 <sys_mkdir+0x56>
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	6a 00                	push   $0x0
80104c44:	b9 00 00 00 00       	mov    $0x0,%ecx
80104c49:	ba 01 00 00 00       	mov    $0x1,%edx
80104c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c51:	e8 23 f8 ff ff       	call   80104479 <create>
80104c56:	83 c4 10             	add    $0x10,%esp
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	74 18                	je     80104c75 <sys_mkdir+0x56>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	50                   	push   %eax
80104c61:	e8 61 cb ff ff       	call   801017c7 <iunlockput>
  end_op();
80104c66:	e8 9b dc ff ff       	call   80102906 <end_op>
  return 0;
80104c6b:	83 c4 10             	add    $0x10,%esp
80104c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c73:	c9                   	leave  
80104c74:	c3                   	ret    
    end_op();
80104c75:	e8 8c dc ff ff       	call   80102906 <end_op>
    return -1;
80104c7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7f:	eb f2                	jmp    80104c73 <sys_mkdir+0x54>

80104c81 <sys_mknod>:

int sys_mknod(void)
{
80104c81:	55                   	push   %ebp
80104c82:	89 e5                	mov    %esp,%ebp
80104c84:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104c87:	e8 00 dc ff ff       	call   8010288c <begin_op>
  if ((argstr(0, &path)) < 0 ||
80104c8c:	83 ec 08             	sub    $0x8,%esp
80104c8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c92:	50                   	push   %eax
80104c93:	6a 00                	push   $0x0
80104c95:	e8 65 f6 ff ff       	call   801042ff <argstr>
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	78 62                	js     80104d03 <sys_mknod+0x82>
      argint(1, &major) < 0 ||
80104ca1:	83 ec 08             	sub    $0x8,%esp
80104ca4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ca7:	50                   	push   %eax
80104ca8:	6a 01                	push   $0x1
80104caa:	e8 c0 f5 ff ff       	call   8010426f <argint>
  if ((argstr(0, &path)) < 0 ||
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	78 4d                	js     80104d03 <sys_mknod+0x82>
      argint(2, &minor) < 0 ||
80104cb6:	83 ec 08             	sub    $0x8,%esp
80104cb9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cbc:	50                   	push   %eax
80104cbd:	6a 02                	push   $0x2
80104cbf:	e8 ab f5 ff ff       	call   8010426f <argint>
      argint(1, &major) < 0 ||
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	78 38                	js     80104d03 <sys_mknod+0x82>
      (ip = create(path, T_DEV, major, minor)) == 0)
80104ccb:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104cd6:	50                   	push   %eax
80104cd7:	ba 03 00 00 00       	mov    $0x3,%edx
80104cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdf:	e8 95 f7 ff ff       	call   80104479 <create>
      argint(2, &minor) < 0 ||
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	74 18                	je     80104d03 <sys_mknod+0x82>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ceb:	83 ec 0c             	sub    $0xc,%esp
80104cee:	50                   	push   %eax
80104cef:	e8 d3 ca ff ff       	call   801017c7 <iunlockput>
  end_op();
80104cf4:	e8 0d dc ff ff       	call   80102906 <end_op>
  return 0;
80104cf9:	83 c4 10             	add    $0x10,%esp
80104cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d01:	c9                   	leave  
80104d02:	c3                   	ret    
    end_op();
80104d03:	e8 fe db ff ff       	call   80102906 <end_op>
    return -1;
80104d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0d:	eb f2                	jmp    80104d01 <sys_mknod+0x80>

80104d0f <sys_chdir>:

int sys_chdir(void)
{
80104d0f:	55                   	push   %ebp
80104d10:	89 e5                	mov    %esp,%ebp
80104d12:	56                   	push   %esi
80104d13:	53                   	push   %ebx
80104d14:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104d17:	e8 ad e5 ff ff       	call   801032c9 <myproc>
80104d1c:	89 c6                	mov    %eax,%esi

  begin_op();
80104d1e:	e8 69 db ff ff       	call   8010288c <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104d23:	83 ec 08             	sub    $0x8,%esp
80104d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d29:	50                   	push   %eax
80104d2a:	6a 00                	push   $0x0
80104d2c:	e8 ce f5 ff ff       	call   801042ff <argstr>
80104d31:	83 c4 10             	add    $0x10,%esp
80104d34:	85 c0                	test   %eax,%eax
80104d36:	78 55                	js     80104d8d <sys_chdir+0x7e>
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	ff 75 f4             	push   -0xc(%ebp)
80104d3e:	e8 71 cf ff ff       	call   80101cb4 <namei>
80104d43:	89 c3                	mov    %eax,%ebx
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	85 c0                	test   %eax,%eax
80104d4a:	74 41                	je     80104d8d <sys_chdir+0x7e>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	50                   	push   %eax
80104d50:	e8 9e c8 ff ff       	call   801015f3 <ilock>
  if (ip->type != T_DIR)
80104d55:	83 c4 10             	add    $0x10,%esp
80104d58:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80104d5f:	01 
80104d60:	75 37                	jne    80104d99 <sys_chdir+0x8a>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104d62:	83 ec 0c             	sub    $0xc,%esp
80104d65:	53                   	push   %ebx
80104d66:	e8 68 c9 ff ff       	call   801016d3 <iunlock>
  iput(curproc->cwd);
80104d6b:	83 c4 04             	add    $0x4,%esp
80104d6e:	ff 76 68             	push   0x68(%esi)
80104d71:	e8 a2 c9 ff ff       	call   80101718 <iput>
  end_op();
80104d76:	e8 8b db ff ff       	call   80102906 <end_op>
  curproc->cwd = ip;
80104d7b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d89:	5b                   	pop    %ebx
80104d8a:	5e                   	pop    %esi
80104d8b:	5d                   	pop    %ebp
80104d8c:	c3                   	ret    
    end_op();
80104d8d:	e8 74 db ff ff       	call   80102906 <end_op>
    return -1;
80104d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d97:	eb ed                	jmp    80104d86 <sys_chdir+0x77>
    iunlockput(ip);
80104d99:	83 ec 0c             	sub    $0xc,%esp
80104d9c:	53                   	push   %ebx
80104d9d:	e8 25 ca ff ff       	call   801017c7 <iunlockput>
    end_op();
80104da2:	e8 5f db ff ff       	call   80102906 <end_op>
    return -1;
80104da7:	83 c4 10             	add    $0x10,%esp
80104daa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104daf:	eb d5                	jmp    80104d86 <sys_chdir+0x77>

80104db1 <sys_exec>:

int sys_exec(void)
{
80104db1:	55                   	push   %ebp
80104db2:	89 e5                	mov    %esp,%ebp
80104db4:	53                   	push   %ebx
80104db5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104dbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dbe:	50                   	push   %eax
80104dbf:	6a 00                	push   $0x0
80104dc1:	e8 39 f5 ff ff       	call   801042ff <argstr>
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	78 38                	js     80104e05 <sys_exec+0x54>
80104dcd:	83 ec 08             	sub    $0x8,%esp
80104dd0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104dd6:	50                   	push   %eax
80104dd7:	6a 01                	push   $0x1
80104dd9:	e8 91 f4 ff ff       	call   8010426f <argint>
80104dde:	83 c4 10             	add    $0x10,%esp
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 20                	js     80104e05 <sys_exec+0x54>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104de5:	83 ec 04             	sub    $0x4,%esp
80104de8:	68 80 00 00 00       	push   $0x80
80104ded:	6a 00                	push   $0x0
80104def:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104df5:	50                   	push   %eax
80104df6:	e8 24 f2 ff ff       	call   8010401f <memset>
80104dfb:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++)
80104dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
80104e03:	eb 2c                	jmp    80104e31 <sys_exec+0x80>
    return -1;
80104e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0a:	eb 78                	jmp    80104e84 <sys_exec+0xd3>
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
      return -1;
    if (uarg == 0)
    {
      argv[i] = 0;
80104e0c:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104e13:	00 00 00 00 
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104e17:	83 ec 08             	sub    $0x8,%esp
80104e1a:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104e20:	50                   	push   %eax
80104e21:	ff 75 f4             	push   -0xc(%ebp)
80104e24:	e8 e5 ba ff ff       	call   8010090e <exec>
80104e29:	83 c4 10             	add    $0x10,%esp
80104e2c:	eb 56                	jmp    80104e84 <sys_exec+0xd3>
  for (i = 0;; i++)
80104e2e:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80104e31:	83 fb 1f             	cmp    $0x1f,%ebx
80104e34:	77 49                	ja     80104e7f <sys_exec+0xce>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104e36:	83 ec 08             	sub    $0x8,%esp
80104e39:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104e3f:	50                   	push   %eax
80104e40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104e46:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104e49:	50                   	push   %eax
80104e4a:	e8 a6 f3 ff ff       	call   801041f5 <fetchint>
80104e4f:	83 c4 10             	add    $0x10,%esp
80104e52:	85 c0                	test   %eax,%eax
80104e54:	78 33                	js     80104e89 <sys_exec+0xd8>
    if (uarg == 0)
80104e56:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104e5c:	85 c0                	test   %eax,%eax
80104e5e:	74 ac                	je     80104e0c <sys_exec+0x5b>
    if (fetchstr(uarg, &argv[i]) < 0)
80104e60:	83 ec 08             	sub    $0x8,%esp
80104e63:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104e6a:	52                   	push   %edx
80104e6b:	50                   	push   %eax
80104e6c:	e8 bf f3 ff ff       	call   80104230 <fetchstr>
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	85 c0                	test   %eax,%eax
80104e76:	79 b6                	jns    80104e2e <sys_exec+0x7d>
      return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7d:	eb 05                	jmp    80104e84 <sys_exec+0xd3>
      return -1;
80104e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e87:	c9                   	leave  
80104e88:	c3                   	ret    
      return -1;
80104e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8e:	eb f4                	jmp    80104e84 <sys_exec+0xd3>

80104e90 <sys_pipe>:

int sys_pipe(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104e97:	6a 08                	push   $0x8
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	50                   	push   %eax
80104e9d:	6a 00                	push   $0x0
80104e9f:	e8 f3 f3 ff ff       	call   80104297 <argptr>
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	78 79                	js     80104f24 <sys_pipe+0x94>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80104eab:	83 ec 08             	sub    $0x8,%esp
80104eae:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104eb1:	50                   	push   %eax
80104eb2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eb5:	50                   	push   %eax
80104eb6:	e8 5a df ff ff       	call   80102e15 <pipealloc>
80104ebb:	83 c4 10             	add    $0x10,%esp
80104ebe:	85 c0                	test   %eax,%eax
80104ec0:	78 69                	js     80104f2b <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ec5:	e8 1f f5 ff ff       	call   801043e9 <fdalloc>
80104eca:	89 c3                	mov    %eax,%ebx
80104ecc:	85 c0                	test   %eax,%eax
80104ece:	78 21                	js     80104ef1 <sys_pipe+0x61>
80104ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ed3:	e8 11 f5 ff ff       	call   801043e9 <fdalloc>
80104ed8:	85 c0                	test   %eax,%eax
80104eda:	78 15                	js     80104ef1 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104edf:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee4:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eef:	c9                   	leave  
80104ef0:	c3                   	ret    
    if (fd0 >= 0)
80104ef1:	85 db                	test   %ebx,%ebx
80104ef3:	79 20                	jns    80104f15 <sys_pipe+0x85>
    fileclose(rf);
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	ff 75 f0             	push   -0x10(%ebp)
80104efb:	e8 03 be ff ff       	call   80100d03 <fileclose>
    fileclose(wf);
80104f00:	83 c4 04             	add    $0x4,%esp
80104f03:	ff 75 ec             	push   -0x14(%ebp)
80104f06:	e8 f8 bd ff ff       	call   80100d03 <fileclose>
    return -1;
80104f0b:	83 c4 10             	add    $0x10,%esp
80104f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f13:	eb d7                	jmp    80104eec <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104f15:	e8 af e3 ff ff       	call   801032c9 <myproc>
80104f1a:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104f21:	00 
80104f22:	eb d1                	jmp    80104ef5 <sys_pipe+0x65>
    return -1;
80104f24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f29:	eb c1                	jmp    80104eec <sys_pipe+0x5c>
    return -1;
80104f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f30:	eb ba                	jmp    80104eec <sys_pipe+0x5c>

80104f32 <sys_hello>:

int sys_hello(void)
{
80104f32:	55                   	push   %ebp
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hi! Welcome to the world of xv6!\n");
80104f38:	68 ec 73 10 80       	push   $0x801073ec
80104f3d:	e8 05 b7 ff ff       	call   80100647 <cprintf>
  return 0;
}
80104f42:	b8 00 00 00 00       	mov    $0x0,%eax
80104f47:	c9                   	leave  
80104f48:	c3                   	ret    

80104f49 <sys_helloYou>:
int sys_helloYou(void)
{
80104f49:	55                   	push   %ebp
80104f4a:	89 e5                	mov    %esp,%ebp
80104f4c:	83 ec 18             	sub    $0x18,%esp
  // char *argv[MAXARG];
  char *path;
  begin_op();
80104f4f:	e8 38 d9 ff ff       	call   8010288c <begin_op>
  argstr(0, &path);
80104f54:	83 ec 08             	sub    $0x8,%esp
80104f57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5a:	50                   	push   %eax
80104f5b:	6a 00                	push   $0x0
80104f5d:	e8 9d f3 ff ff       	call   801042ff <argstr>
  cprintf("this is the helloYou syscall called %s\n", path);
80104f62:	83 c4 08             	add    $0x8,%esp
80104f65:	ff 75 f4             	push   -0xc(%ebp)
80104f68:	68 10 74 10 80       	push   $0x80107410
80104f6d:	e8 d5 b6 ff ff       	call   80100647 <cprintf>
  end_op();
80104f72:	e8 8f d9 ff ff       	call   80102906 <end_op>
  return 0;
}
80104f77:	b8 00 00 00 00       	mov    $0x0,%eax
80104f7c:	c9                   	leave  
80104f7d:	c3                   	ret    

80104f7e <sys_fork>:
#include "mmu.h"
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
80104f7e:	55                   	push   %ebp
80104f7f:	89 e5                	mov    %esp,%ebp
80104f81:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104f84:	e8 b6 e4 ff ff       	call   8010343f <fork>
}
80104f89:	c9                   	leave  
80104f8a:	c3                   	ret    

80104f8b <sys_exit>:

int sys_exit(void)
{
80104f8b:	55                   	push   %ebp
80104f8c:	89 e5                	mov    %esp,%ebp
80104f8e:	83 ec 08             	sub    $0x8,%esp
  exit();
80104f91:	e8 e3 e6 ff ff       	call   80103679 <exit>
  return 0; // not reached
}
80104f96:	b8 00 00 00 00       	mov    $0x0,%eax
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    

80104f9d <sys_wait>:

int sys_wait(void)
{
80104f9d:	55                   	push   %ebp
80104f9e:	89 e5                	mov    %esp,%ebp
80104fa0:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104fa3:	e8 79 e8 ff ff       	call   80103821 <wait>
}
80104fa8:	c9                   	leave  
80104fa9:	c3                   	ret    

80104faa <sys_kill>:

int sys_kill(void)
{
80104faa:	55                   	push   %ebp
80104fab:	89 e5                	mov    %esp,%ebp
80104fad:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80104fb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb3:	50                   	push   %eax
80104fb4:	6a 00                	push   $0x0
80104fb6:	e8 b4 f2 ff ff       	call   8010426f <argint>
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	85 c0                	test   %eax,%eax
80104fc0:	78 10                	js     80104fd2 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104fc2:	83 ec 0c             	sub    $0xc,%esp
80104fc5:	ff 75 f4             	push   -0xc(%ebp)
80104fc8:	e8 51 e9 ff ff       	call   8010391e <kill>
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	c9                   	leave  
80104fd1:	c3                   	ret    
    return -1;
80104fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd7:	eb f7                	jmp    80104fd0 <sys_kill+0x26>

80104fd9 <sys_getpid>:

int sys_getpid(void)
{
80104fd9:	55                   	push   %ebp
80104fda:	89 e5                	mov    %esp,%ebp
80104fdc:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104fdf:	e8 e5 e2 ff ff       	call   801032c9 <myproc>
80104fe4:	8b 40 10             	mov    0x10(%eax),%eax
}
80104fe7:	c9                   	leave  
80104fe8:	c3                   	ret    

80104fe9 <sys_sbrk>:

int sys_sbrk(void)
{
80104fe9:	55                   	push   %ebp
80104fea:	89 e5                	mov    %esp,%ebp
80104fec:	53                   	push   %ebx
80104fed:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80104ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff3:	50                   	push   %eax
80104ff4:	6a 00                	push   $0x0
80104ff6:	e8 74 f2 ff ff       	call   8010426f <argint>
80104ffb:	83 c4 10             	add    $0x10,%esp
80104ffe:	85 c0                	test   %eax,%eax
80105000:	78 20                	js     80105022 <sys_sbrk+0x39>
    return -1;
  addr = myproc()->sz;
80105002:	e8 c2 e2 ff ff       	call   801032c9 <myproc>
80105007:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	ff 75 f4             	push   -0xc(%ebp)
8010500f:	e8 c0 e3 ff ff       	call   801033d4 <growproc>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	78 0e                	js     80105029 <sys_sbrk+0x40>
    return -1;
  return addr;
}
8010501b:	89 d8                	mov    %ebx,%eax
8010501d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105020:	c9                   	leave  
80105021:	c3                   	ret    
    return -1;
80105022:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105027:	eb f2                	jmp    8010501b <sys_sbrk+0x32>
    return -1;
80105029:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010502e:	eb eb                	jmp    8010501b <sys_sbrk+0x32>

80105030 <sys_sleep>:

int sys_sleep(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105037:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503a:	50                   	push   %eax
8010503b:	6a 00                	push   $0x0
8010503d:	e8 2d f2 ff ff       	call   8010426f <argint>
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	85 c0                	test   %eax,%eax
80105047:	78 75                	js     801050be <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	68 60 59 11 80       	push   $0x80115960
80105051:	e8 a5 ee ff ff       	call   80103efb <acquire>
  ticks0 = ticks;
80105056:	8b 1d 40 59 11 80    	mov    0x80115940,%ebx
  while (ticks - ticks0 < n)
8010505c:	83 c4 10             	add    $0x10,%esp
8010505f:	a1 40 59 11 80       	mov    0x80115940,%eax
80105064:	29 d8                	sub    %ebx,%eax
80105066:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105069:	73 39                	jae    801050a4 <sys_sleep+0x74>
  {
    if (myproc()->killed)
8010506b:	e8 59 e2 ff ff       	call   801032c9 <myproc>
80105070:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105074:	75 17                	jne    8010508d <sys_sleep+0x5d>
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105076:	83 ec 08             	sub    $0x8,%esp
80105079:	68 60 59 11 80       	push   $0x80115960
8010507e:	68 40 59 11 80       	push   $0x80115940
80105083:	e8 08 e7 ff ff       	call   80103790 <sleep>
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	eb d2                	jmp    8010505f <sys_sleep+0x2f>
      release(&tickslock);
8010508d:	83 ec 0c             	sub    $0xc,%esp
80105090:	68 60 59 11 80       	push   $0x80115960
80105095:	e8 c6 ee ff ff       	call   80103f60 <release>
      return -1;
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a2:	eb 15                	jmp    801050b9 <sys_sleep+0x89>
  }
  release(&tickslock);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	68 60 59 11 80       	push   $0x80115960
801050ac:	e8 af ee ff ff       	call   80103f60 <release>
  return 0;
801050b1:	83 c4 10             	add    $0x10,%esp
801050b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050bc:	c9                   	leave  
801050bd:	c3                   	ret    
    return -1;
801050be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c3:	eb f4                	jmp    801050b9 <sys_sleep+0x89>

801050c5 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801050c5:	55                   	push   %ebp
801050c6:	89 e5                	mov    %esp,%ebp
801050c8:	53                   	push   %ebx
801050c9:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801050cc:	68 60 59 11 80       	push   $0x80115960
801050d1:	e8 25 ee ff ff       	call   80103efb <acquire>
  xticks = ticks;
801050d6:	8b 1d 40 59 11 80    	mov    0x80115940,%ebx
  release(&tickslock);
801050dc:	c7 04 24 60 59 11 80 	movl   $0x80115960,(%esp)
801050e3:	e8 78 ee ff ff       	call   80103f60 <release>
  return xticks;
}
801050e8:	89 d8                	mov    %ebx,%eax
801050ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050ed:	c9                   	leave  
801050ee:	c3                   	ret    

801050ef <sys_getppid>:
// {
//   return 0;   //commenting this line resolved the error
// }            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
801050ef:	55                   	push   %ebp
801050f0:	89 e5                	mov    %esp,%ebp
801050f2:	83 ec 20             	sub    $0x20,%esp
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
801050f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050f8:	50                   	push   %eax
801050f9:	6a 00                	push   $0x0
801050fb:	e8 6f f1 ff ff       	call   8010426f <argint>
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	85 c0                	test   %eax,%eax
80105105:	78 07                	js     8010510e <sys_getppid+0x1f>
   return -1;
  }
  return getppid();
80105107:	e8 38 e9 ff ff       	call   80103a44 <getppid>
}
8010510c:	c9                   	leave  
8010510d:	c3                   	ret    
   return -1;
8010510e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105113:	eb f7                	jmp    8010510c <sys_getppid+0x1d>

80105115 <sys_get_siblings_info>:

int sys_get_siblings_info(int pid){
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	83 ec 08             	sub    $0x8,%esp
  
  return get_siblings_info(sys_getpid());
8010511b:	e8 b9 fe ff ff       	call   80104fd9 <sys_getpid>
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	50                   	push   %eax
80105124:	e8 56 e9 ff ff       	call   80103a7f <get_siblings_info>
}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    

8010512b <sys_signalProcess>:
void sys_signalProcess(int pid,char type[]){
8010512b:	55                   	push   %ebp
8010512c:	89 e5                	mov    %esp,%ebp
8010512e:	83 ec 10             	sub    $0x10,%esp
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
80105131:	8d 45 08             	lea    0x8(%ebp),%eax
80105134:	50                   	push   %eax
80105135:	6a 00                	push   $0x0
80105137:	e8 33 f1 ff ff       	call   8010426f <argint>
  char **type1=&type;
  argstr(1,type1); 
8010513c:	83 c4 08             	add    $0x8,%esp
8010513f:	8d 45 0c             	lea    0xc(%ebp),%eax
80105142:	50                   	push   %eax
80105143:	6a 01                	push   $0x1
80105145:	e8 b5 f1 ff ff       	call   801042ff <argstr>
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
8010514a:	83 c4 08             	add    $0x8,%esp
8010514d:	ff 75 0c             	push   0xc(%ebp)
80105150:	ff 75 08             	push   0x8(%ebp)
80105153:	e8 07 ea ff ff       	call   80103b5f <signalProcess>
}
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	c9                   	leave  
8010515c:	c3                   	ret    

8010515d <sys_numvp>:

int sys_numvp(){
8010515d:	55                   	push   %ebp
8010515e:	89 e5                	mov    %esp,%ebp
80105160:	83 ec 08             	sub    $0x8,%esp
  return numvp();
80105163:	e8 bd ea ff ff       	call   80103c25 <numvp>
}
80105168:	c9                   	leave  
80105169:	c3                   	ret    

8010516a <sys_numpp>:

int sys_numpp(){
8010516a:	55                   	push   %ebp
8010516b:	89 e5                	mov    %esp,%ebp
8010516d:	83 ec 08             	sub    $0x8,%esp
  return numpp();
80105170:	e8 c2 ea ff ff       	call   80103c37 <numpp>
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    

80105177 <sys_init_counter>:
/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
80105177:	c7 05 30 59 11 80 00 	movl   $0x0,0x80115930
8010517e:	00 00 00 
}
80105181:	c3                   	ret    

80105182 <sys_update_cnt>:

void sys_update_cnt(void){
  counter = counter + 1;
80105182:	a1 30 59 11 80       	mov    0x80115930,%eax
80105187:	83 c0 01             	add    $0x1,%eax
8010518a:	a3 30 59 11 80       	mov    %eax,0x80115930
}
8010518f:	c3                   	ret    

80105190 <sys_display_count>:

int sys_display_count(void){
  return counter;
}
80105190:	a1 30 59 11 80       	mov    0x80115930,%eax
80105195:	c3                   	ret    

80105196 <sys_init_counter_1>:
/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
80105196:	c7 05 2c 59 11 80 00 	movl   $0x0,0x8011592c
8010519d:	00 00 00 
}
801051a0:	c3                   	ret    

801051a1 <sys_update_cnt_1>:

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
801051a1:	a1 2c 59 11 80       	mov    0x8011592c,%eax
801051a6:	83 c0 01             	add    $0x1,%eax
801051a9:	a3 2c 59 11 80       	mov    %eax,0x8011592c
}
801051ae:	c3                   	ret    

801051af <sys_display_count_1>:

int sys_display_count_1(void){
  return counter_1;
}
801051af:	a1 2c 59 11 80       	mov    0x8011592c,%eax
801051b4:	c3                   	ret    

801051b5 <sys_init_counter_2>:
/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
801051b5:	c7 05 28 59 11 80 00 	movl   $0x0,0x80115928
801051bc:	00 00 00 
}
801051bf:	c3                   	ret    

801051c0 <sys_update_cnt_2>:

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
801051c0:	a1 28 59 11 80       	mov    0x80115928,%eax
801051c5:	83 c0 01             	add    $0x1,%eax
801051c8:	a3 28 59 11 80       	mov    %eax,0x80115928
}
801051cd:	c3                   	ret    

801051ce <sys_display_count_2>:

int sys_display_count_2(void){
  return counter_2;
}
801051ce:	a1 28 59 11 80       	mov    0x80115928,%eax
801051d3:	c3                   	ret    

801051d4 <sys_init_mylock>:

int sys_init_mylock(){
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	83 ec 08             	sub    $0x8,%esp
  return init_mylock();
801051da:	e8 65 ea ff ff       	call   80103c44 <init_mylock>
}
801051df:	c9                   	leave  
801051e0:	c3                   	ret    

801051e1 <sys_acquire_mylock>:

int sys_acquire_mylock(int id){
801051e1:	55                   	push   %ebp
801051e2:	89 e5                	mov    %esp,%ebp
801051e4:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801051e7:	8d 45 08             	lea    0x8(%ebp),%eax
801051ea:	50                   	push   %eax
801051eb:	6a 00                	push   $0x0
801051ed:	e8 7d f0 ff ff       	call   8010426f <argint>
  return acquire_mylock(id);
801051f2:	83 c4 04             	add    $0x4,%esp
801051f5:	ff 75 08             	push   0x8(%ebp)
801051f8:	e8 59 ea ff ff       	call   80103c56 <acquire_mylock>
}
801051fd:	c9                   	leave  
801051fe:	c3                   	ret    

801051ff <sys_release_mylock>:

int sys_release_mylock(int id){
801051ff:	55                   	push   %ebp
80105200:	89 e5                	mov    %esp,%ebp
80105202:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105205:	8d 45 08             	lea    0x8(%ebp),%eax
80105208:	50                   	push   %eax
80105209:	6a 00                	push   $0x0
8010520b:	e8 5f f0 ff ff       	call   8010426f <argint>
  return release_mylock(id);
80105210:	83 c4 04             	add    $0x4,%esp
80105213:	ff 75 08             	push   0x8(%ebp)
80105216:	e8 5e ea ff ff       	call   80103c79 <release_mylock>
}
8010521b:	c9                   	leave  
8010521c:	c3                   	ret    

8010521d <sys_holding_mylock>:

int sys_holding_mylock(int id){
8010521d:	55                   	push   %ebp
8010521e:	89 e5                	mov    %esp,%ebp
80105220:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105223:	8d 45 08             	lea    0x8(%ebp),%eax
80105226:	50                   	push   %eax
80105227:	6a 00                	push   $0x0
80105229:	e8 41 f0 ff ff       	call   8010426f <argint>
  return holding_mylock(id);
8010522e:	83 c4 04             	add    $0x4,%esp
80105231:	ff 75 08             	push   0x8(%ebp)
80105234:	e8 56 ea ff ff       	call   80103c8f <holding_mylock>
80105239:	c9                   	leave  
8010523a:	c3                   	ret    

8010523b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010523b:	1e                   	push   %ds
  pushl %es
8010523c:	06                   	push   %es
  pushl %fs
8010523d:	0f a0                	push   %fs
  pushl %gs
8010523f:	0f a8                	push   %gs
  pushal
80105241:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105242:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105246:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105248:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010524a:	54                   	push   %esp
  call trap
8010524b:	e8 37 01 00 00       	call   80105387 <trap>
  addl $4, %esp
80105250:	83 c4 04             	add    $0x4,%esp

80105253 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105253:	61                   	popa   
  popl %gs
80105254:	0f a9                	pop    %gs
  popl %fs
80105256:	0f a1                	pop    %fs
  popl %es
80105258:	07                   	pop    %es
  popl %ds
80105259:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010525a:	83 c4 08             	add    $0x8,%esp
  iret
8010525d:	cf                   	iret   

8010525e <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010525e:	55                   	push   %ebp
8010525f:	89 e5                	mov    %esp,%ebp
80105261:	53                   	push   %ebx
80105262:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80105265:	b8 00 00 00 00       	mov    $0x0,%eax
8010526a:	eb 76                	jmp    801052e2 <tvinit+0x84>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010526c:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80105273:	66 89 0c c5 00 5a 11 	mov    %cx,-0x7feea600(,%eax,8)
8010527a:	80 
8010527b:	66 c7 04 c5 02 5a 11 	movw   $0x8,-0x7feea5fe(,%eax,8)
80105282:	80 08 00 
80105285:	0f b6 14 c5 04 5a 11 	movzbl -0x7feea5fc(,%eax,8),%edx
8010528c:	80 
8010528d:	83 e2 e0             	and    $0xffffffe0,%edx
80105290:	88 14 c5 04 5a 11 80 	mov    %dl,-0x7feea5fc(,%eax,8)
80105297:	c6 04 c5 04 5a 11 80 	movb   $0x0,-0x7feea5fc(,%eax,8)
8010529e:	00 
8010529f:	0f b6 14 c5 05 5a 11 	movzbl -0x7feea5fb(,%eax,8),%edx
801052a6:	80 
801052a7:	83 e2 f0             	and    $0xfffffff0,%edx
801052aa:	83 ca 0e             	or     $0xe,%edx
801052ad:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
801052b4:	89 d3                	mov    %edx,%ebx
801052b6:	83 e3 ef             	and    $0xffffffef,%ebx
801052b9:	88 1c c5 05 5a 11 80 	mov    %bl,-0x7feea5fb(,%eax,8)
801052c0:	83 e2 8f             	and    $0xffffff8f,%edx
801052c3:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
801052ca:	83 ca 80             	or     $0xffffff80,%edx
801052cd:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
801052d4:	c1 e9 10             	shr    $0x10,%ecx
801052d7:	66 89 0c c5 06 5a 11 	mov    %cx,-0x7feea5fa(,%eax,8)
801052de:	80 
  for(i = 0; i < 256; i++)
801052df:	83 c0 01             	add    $0x1,%eax
801052e2:	3d ff 00 00 00       	cmp    $0xff,%eax
801052e7:	7e 83                	jle    8010526c <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801052e9:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
801052ef:	66 89 15 00 5c 11 80 	mov    %dx,0x80115c00
801052f6:	66 c7 05 02 5c 11 80 	movw   $0x8,0x80115c02
801052fd:	08 00 
801052ff:	0f b6 05 04 5c 11 80 	movzbl 0x80115c04,%eax
80105306:	83 e0 e0             	and    $0xffffffe0,%eax
80105309:	a2 04 5c 11 80       	mov    %al,0x80115c04
8010530e:	c6 05 04 5c 11 80 00 	movb   $0x0,0x80115c04
80105315:	0f b6 05 05 5c 11 80 	movzbl 0x80115c05,%eax
8010531c:	83 c8 0f             	or     $0xf,%eax
8010531f:	a2 05 5c 11 80       	mov    %al,0x80115c05
80105324:	83 e0 ef             	and    $0xffffffef,%eax
80105327:	a2 05 5c 11 80       	mov    %al,0x80115c05
8010532c:	89 c1                	mov    %eax,%ecx
8010532e:	83 c9 60             	or     $0x60,%ecx
80105331:	88 0d 05 5c 11 80    	mov    %cl,0x80115c05
80105337:	83 c8 e0             	or     $0xffffffe0,%eax
8010533a:	a2 05 5c 11 80       	mov    %al,0x80115c05
8010533f:	c1 ea 10             	shr    $0x10,%edx
80105342:	66 89 15 06 5c 11 80 	mov    %dx,0x80115c06

  initlock(&tickslock, "time");
80105349:	83 ec 08             	sub    $0x8,%esp
8010534c:	68 38 74 10 80       	push   $0x80107438
80105351:	68 60 59 11 80       	push   $0x80115960
80105356:	e8 64 ea ff ff       	call   80103dbf <initlock>
}
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105361:	c9                   	leave  
80105362:	c3                   	ret    

80105363 <idtinit>:

void
idtinit(void)
{
80105363:	55                   	push   %ebp
80105364:	89 e5                	mov    %esp,%ebp
80105366:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105369:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
8010536f:	b8 00 5a 11 80       	mov    $0x80115a00,%eax
80105374:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105378:	c1 e8 10             	shr    $0x10,%eax
8010537b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010537f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105382:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    

80105387 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105387:	55                   	push   %ebp
80105388:	89 e5                	mov    %esp,%ebp
8010538a:	57                   	push   %edi
8010538b:	56                   	push   %esi
8010538c:	53                   	push   %ebx
8010538d:	83 ec 1c             	sub    $0x1c,%esp
80105390:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105393:	8b 43 30             	mov    0x30(%ebx),%eax
80105396:	83 f8 40             	cmp    $0x40,%eax
80105399:	74 13                	je     801053ae <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010539b:	83 e8 20             	sub    $0x20,%eax
8010539e:	83 f8 1f             	cmp    $0x1f,%eax
801053a1:	0f 87 3a 01 00 00    	ja     801054e1 <trap+0x15a>
801053a7:	ff 24 85 e0 74 10 80 	jmp    *-0x7fef8b20(,%eax,4)
    if(myproc()->killed)
801053ae:	e8 16 df ff ff       	call   801032c9 <myproc>
801053b3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801053b7:	75 1f                	jne    801053d8 <trap+0x51>
    myproc()->tf = tf;
801053b9:	e8 0b df ff ff       	call   801032c9 <myproc>
801053be:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801053c1:	e8 6c ef ff ff       	call   80104332 <syscall>
    if(myproc()->killed)
801053c6:	e8 fe de ff ff       	call   801032c9 <myproc>
801053cb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801053cf:	74 7e                	je     8010544f <trap+0xc8>
      exit();
801053d1:	e8 a3 e2 ff ff       	call   80103679 <exit>
    return;
801053d6:	eb 77                	jmp    8010544f <trap+0xc8>
      exit();
801053d8:	e8 9c e2 ff ff       	call   80103679 <exit>
801053dd:	eb da                	jmp    801053b9 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801053df:	e8 ca de ff ff       	call   801032ae <cpuid>
801053e4:	85 c0                	test   %eax,%eax
801053e6:	74 6f                	je     80105457 <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801053e8:	e8 7f d0 ff ff       	call   8010246c <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801053ed:	e8 d7 de ff ff       	call   801032c9 <myproc>
801053f2:	85 c0                	test   %eax,%eax
801053f4:	74 1c                	je     80105412 <trap+0x8b>
801053f6:	e8 ce de ff ff       	call   801032c9 <myproc>
801053fb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801053ff:	74 11                	je     80105412 <trap+0x8b>
80105401:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105405:	83 e0 03             	and    $0x3,%eax
80105408:	66 83 f8 03          	cmp    $0x3,%ax
8010540c:	0f 84 62 01 00 00    	je     80105574 <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105412:	e8 b2 de ff ff       	call   801032c9 <myproc>
80105417:	85 c0                	test   %eax,%eax
80105419:	74 0f                	je     8010542a <trap+0xa3>
8010541b:	e8 a9 de ff ff       	call   801032c9 <myproc>
80105420:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105424:	0f 84 54 01 00 00    	je     8010557e <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010542a:	e8 9a de ff ff       	call   801032c9 <myproc>
8010542f:	85 c0                	test   %eax,%eax
80105431:	74 1c                	je     8010544f <trap+0xc8>
80105433:	e8 91 de ff ff       	call   801032c9 <myproc>
80105438:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010543c:	74 11                	je     8010544f <trap+0xc8>
8010543e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105442:	83 e0 03             	and    $0x3,%eax
80105445:	66 83 f8 03          	cmp    $0x3,%ax
80105449:	0f 84 43 01 00 00    	je     80105592 <trap+0x20b>
    exit();
}
8010544f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5f                   	pop    %edi
80105455:	5d                   	pop    %ebp
80105456:	c3                   	ret    
      acquire(&tickslock);
80105457:	83 ec 0c             	sub    $0xc,%esp
8010545a:	68 60 59 11 80       	push   $0x80115960
8010545f:	e8 97 ea ff ff       	call   80103efb <acquire>
      ticks++;
80105464:	83 05 40 59 11 80 01 	addl   $0x1,0x80115940
      wakeup(&ticks);
8010546b:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
80105472:	e8 7e e4 ff ff       	call   801038f5 <wakeup>
      release(&tickslock);
80105477:	c7 04 24 60 59 11 80 	movl   $0x80115960,(%esp)
8010547e:	e8 dd ea ff ff       	call   80103f60 <release>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	e9 5d ff ff ff       	jmp    801053e8 <trap+0x61>
    ideintr();
8010548b:	e8 b6 c9 ff ff       	call   80101e46 <ideintr>
    lapiceoi();
80105490:	e8 d7 cf ff ff       	call   8010246c <lapiceoi>
    break;
80105495:	e9 53 ff ff ff       	jmp    801053ed <trap+0x66>
    kbdintr();
8010549a:	e8 17 ce ff ff       	call   801022b6 <kbdintr>
    lapiceoi();
8010549f:	e8 c8 cf ff ff       	call   8010246c <lapiceoi>
    break;
801054a4:	e9 44 ff ff ff       	jmp    801053ed <trap+0x66>
    uartintr();
801054a9:	e8 fe 01 00 00       	call   801056ac <uartintr>
    lapiceoi();
801054ae:	e8 b9 cf ff ff       	call   8010246c <lapiceoi>
    break;
801054b3:	e9 35 ff ff ff       	jmp    801053ed <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801054b8:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801054bb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801054bf:	e8 ea dd ff ff       	call   801032ae <cpuid>
801054c4:	57                   	push   %edi
801054c5:	0f b7 f6             	movzwl %si,%esi
801054c8:	56                   	push   %esi
801054c9:	50                   	push   %eax
801054ca:	68 44 74 10 80       	push   $0x80107444
801054cf:	e8 73 b1 ff ff       	call   80100647 <cprintf>
    lapiceoi();
801054d4:	e8 93 cf ff ff       	call   8010246c <lapiceoi>
    break;
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	e9 0c ff ff ff       	jmp    801053ed <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801054e1:	e8 e3 dd ff ff       	call   801032c9 <myproc>
801054e6:	85 c0                	test   %eax,%eax
801054e8:	74 5f                	je     80105549 <trap+0x1c2>
801054ea:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801054ee:	74 59                	je     80105549 <trap+0x1c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801054f0:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054f3:	8b 43 38             	mov    0x38(%ebx),%eax
801054f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054f9:	e8 b0 dd ff ff       	call   801032ae <cpuid>
801054fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105501:	8b 53 34             	mov    0x34(%ebx),%edx
80105504:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105507:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
8010550a:	e8 ba dd ff ff       	call   801032c9 <myproc>
8010550f:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105512:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105515:	e8 af dd ff ff       	call   801032c9 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010551a:	57                   	push   %edi
8010551b:	ff 75 e4             	push   -0x1c(%ebp)
8010551e:	ff 75 e0             	push   -0x20(%ebp)
80105521:	ff 75 dc             	push   -0x24(%ebp)
80105524:	56                   	push   %esi
80105525:	ff 75 d8             	push   -0x28(%ebp)
80105528:	ff 70 10             	push   0x10(%eax)
8010552b:	68 9c 74 10 80       	push   $0x8010749c
80105530:	e8 12 b1 ff ff       	call   80100647 <cprintf>
    myproc()->killed = 1;
80105535:	83 c4 20             	add    $0x20,%esp
80105538:	e8 8c dd ff ff       	call   801032c9 <myproc>
8010553d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105544:	e9 a4 fe ff ff       	jmp    801053ed <trap+0x66>
80105549:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010554c:	8b 73 38             	mov    0x38(%ebx),%esi
8010554f:	e8 5a dd ff ff       	call   801032ae <cpuid>
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	57                   	push   %edi
80105558:	56                   	push   %esi
80105559:	50                   	push   %eax
8010555a:	ff 73 30             	push   0x30(%ebx)
8010555d:	68 68 74 10 80       	push   $0x80107468
80105562:	e8 e0 b0 ff ff       	call   80100647 <cprintf>
      panic("trap");
80105567:	83 c4 14             	add    $0x14,%esp
8010556a:	68 3d 74 10 80       	push   $0x8010743d
8010556f:	e8 14 ae ff ff       	call   80100388 <panic>
    exit();
80105574:	e8 00 e1 ff ff       	call   80103679 <exit>
80105579:	e9 94 fe ff ff       	jmp    80105412 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
8010557e:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105582:	0f 85 a2 fe ff ff    	jne    8010542a <trap+0xa3>
    yield();
80105588:	e8 d1 e1 ff ff       	call   8010375e <yield>
8010558d:	e9 98 fe ff ff       	jmp    8010542a <trap+0xa3>
    exit();
80105592:	e8 e2 e0 ff ff       	call   80103679 <exit>
80105597:	e9 b3 fe ff ff       	jmp    8010544f <trap+0xc8>

8010559c <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
8010559c:	83 3d 00 62 11 80 00 	cmpl   $0x0,0x80116200
801055a3:	74 14                	je     801055b9 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801055a5:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055aa:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801055ab:	a8 01                	test   $0x1,%al
801055ad:	74 10                	je     801055bf <uartgetc+0x23>
801055af:	ba f8 03 00 00       	mov    $0x3f8,%edx
801055b4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801055b5:	0f b6 c0             	movzbl %al,%eax
801055b8:	c3                   	ret    
    return -1;
801055b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055be:	c3                   	ret    
    return -1;
801055bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055c4:	c3                   	ret    

801055c5 <uartputc>:
  if(!uart)
801055c5:	83 3d 00 62 11 80 00 	cmpl   $0x0,0x80116200
801055cc:	74 3b                	je     80105609 <uartputc+0x44>
{
801055ce:	55                   	push   %ebp
801055cf:	89 e5                	mov    %esp,%ebp
801055d1:	53                   	push   %ebx
801055d2:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801055d5:	bb 00 00 00 00       	mov    $0x0,%ebx
801055da:	eb 10                	jmp    801055ec <uartputc+0x27>
    microdelay(10);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	6a 0a                	push   $0xa
801055e1:	e8 a7 ce ff ff       	call   8010248d <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801055e6:	83 c3 01             	add    $0x1,%ebx
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	83 fb 7f             	cmp    $0x7f,%ebx
801055ef:	7f 0a                	jg     801055fb <uartputc+0x36>
801055f1:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055f6:	ec                   	in     (%dx),%al
801055f7:	a8 20                	test   $0x20,%al
801055f9:	74 e1                	je     801055dc <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801055fb:	8b 45 08             	mov    0x8(%ebp),%eax
801055fe:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105603:	ee                   	out    %al,(%dx)
}
80105604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105607:	c9                   	leave  
80105608:	c3                   	ret    
80105609:	c3                   	ret    

8010560a <uartinit>:
{
8010560a:	55                   	push   %ebp
8010560b:	89 e5                	mov    %esp,%ebp
8010560d:	56                   	push   %esi
8010560e:	53                   	push   %ebx
8010560f:	b9 00 00 00 00       	mov    $0x0,%ecx
80105614:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105619:	89 c8                	mov    %ecx,%eax
8010561b:	ee                   	out    %al,(%dx)
8010561c:	be fb 03 00 00       	mov    $0x3fb,%esi
80105621:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105626:	89 f2                	mov    %esi,%edx
80105628:	ee                   	out    %al,(%dx)
80105629:	b8 0c 00 00 00       	mov    $0xc,%eax
8010562e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105633:	ee                   	out    %al,(%dx)
80105634:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105639:	89 c8                	mov    %ecx,%eax
8010563b:	89 da                	mov    %ebx,%edx
8010563d:	ee                   	out    %al,(%dx)
8010563e:	b8 03 00 00 00       	mov    $0x3,%eax
80105643:	89 f2                	mov    %esi,%edx
80105645:	ee                   	out    %al,(%dx)
80105646:	ba fc 03 00 00       	mov    $0x3fc,%edx
8010564b:	89 c8                	mov    %ecx,%eax
8010564d:	ee                   	out    %al,(%dx)
8010564e:	b8 01 00 00 00       	mov    $0x1,%eax
80105653:	89 da                	mov    %ebx,%edx
80105655:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105656:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010565b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010565c:	3c ff                	cmp    $0xff,%al
8010565e:	74 45                	je     801056a5 <uartinit+0x9b>
  uart = 1;
80105660:	c7 05 00 62 11 80 01 	movl   $0x1,0x80116200
80105667:	00 00 00 
8010566a:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010566f:	ec                   	in     (%dx),%al
80105670:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105675:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105676:	83 ec 08             	sub    $0x8,%esp
80105679:	6a 00                	push   $0x0
8010567b:	6a 04                	push   $0x4
8010567d:	e8 d5 c9 ff ff       	call   80102057 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	bb 60 75 10 80       	mov    $0x80107560,%ebx
8010568a:	eb 12                	jmp    8010569e <uartinit+0x94>
    uartputc(*p);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	0f be c0             	movsbl %al,%eax
80105692:	50                   	push   %eax
80105693:	e8 2d ff ff ff       	call   801055c5 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105698:	83 c3 01             	add    $0x1,%ebx
8010569b:	83 c4 10             	add    $0x10,%esp
8010569e:	0f b6 03             	movzbl (%ebx),%eax
801056a1:	84 c0                	test   %al,%al
801056a3:	75 e7                	jne    8010568c <uartinit+0x82>
}
801056a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056a8:	5b                   	pop    %ebx
801056a9:	5e                   	pop    %esi
801056aa:	5d                   	pop    %ebp
801056ab:	c3                   	ret    

801056ac <uartintr>:

void
uartintr(void)
{
801056ac:	55                   	push   %ebp
801056ad:	89 e5                	mov    %esp,%ebp
801056af:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801056b2:	68 9c 55 10 80       	push   $0x8010559c
801056b7:	e8 b7 b0 ff ff       	call   80100773 <consoleintr>
}
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	c9                   	leave  
801056c0:	c3                   	ret    

801056c1 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801056c1:	6a 00                	push   $0x0
  pushl $0
801056c3:	6a 00                	push   $0x0
  jmp alltraps
801056c5:	e9 71 fb ff ff       	jmp    8010523b <alltraps>

801056ca <vector1>:
.globl vector1
vector1:
  pushl $0
801056ca:	6a 00                	push   $0x0
  pushl $1
801056cc:	6a 01                	push   $0x1
  jmp alltraps
801056ce:	e9 68 fb ff ff       	jmp    8010523b <alltraps>

801056d3 <vector2>:
.globl vector2
vector2:
  pushl $0
801056d3:	6a 00                	push   $0x0
  pushl $2
801056d5:	6a 02                	push   $0x2
  jmp alltraps
801056d7:	e9 5f fb ff ff       	jmp    8010523b <alltraps>

801056dc <vector3>:
.globl vector3
vector3:
  pushl $0
801056dc:	6a 00                	push   $0x0
  pushl $3
801056de:	6a 03                	push   $0x3
  jmp alltraps
801056e0:	e9 56 fb ff ff       	jmp    8010523b <alltraps>

801056e5 <vector4>:
.globl vector4
vector4:
  pushl $0
801056e5:	6a 00                	push   $0x0
  pushl $4
801056e7:	6a 04                	push   $0x4
  jmp alltraps
801056e9:	e9 4d fb ff ff       	jmp    8010523b <alltraps>

801056ee <vector5>:
.globl vector5
vector5:
  pushl $0
801056ee:	6a 00                	push   $0x0
  pushl $5
801056f0:	6a 05                	push   $0x5
  jmp alltraps
801056f2:	e9 44 fb ff ff       	jmp    8010523b <alltraps>

801056f7 <vector6>:
.globl vector6
vector6:
  pushl $0
801056f7:	6a 00                	push   $0x0
  pushl $6
801056f9:	6a 06                	push   $0x6
  jmp alltraps
801056fb:	e9 3b fb ff ff       	jmp    8010523b <alltraps>

80105700 <vector7>:
.globl vector7
vector7:
  pushl $0
80105700:	6a 00                	push   $0x0
  pushl $7
80105702:	6a 07                	push   $0x7
  jmp alltraps
80105704:	e9 32 fb ff ff       	jmp    8010523b <alltraps>

80105709 <vector8>:
.globl vector8
vector8:
  pushl $8
80105709:	6a 08                	push   $0x8
  jmp alltraps
8010570b:	e9 2b fb ff ff       	jmp    8010523b <alltraps>

80105710 <vector9>:
.globl vector9
vector9:
  pushl $0
80105710:	6a 00                	push   $0x0
  pushl $9
80105712:	6a 09                	push   $0x9
  jmp alltraps
80105714:	e9 22 fb ff ff       	jmp    8010523b <alltraps>

80105719 <vector10>:
.globl vector10
vector10:
  pushl $10
80105719:	6a 0a                	push   $0xa
  jmp alltraps
8010571b:	e9 1b fb ff ff       	jmp    8010523b <alltraps>

80105720 <vector11>:
.globl vector11
vector11:
  pushl $11
80105720:	6a 0b                	push   $0xb
  jmp alltraps
80105722:	e9 14 fb ff ff       	jmp    8010523b <alltraps>

80105727 <vector12>:
.globl vector12
vector12:
  pushl $12
80105727:	6a 0c                	push   $0xc
  jmp alltraps
80105729:	e9 0d fb ff ff       	jmp    8010523b <alltraps>

8010572e <vector13>:
.globl vector13
vector13:
  pushl $13
8010572e:	6a 0d                	push   $0xd
  jmp alltraps
80105730:	e9 06 fb ff ff       	jmp    8010523b <alltraps>

80105735 <vector14>:
.globl vector14
vector14:
  pushl $14
80105735:	6a 0e                	push   $0xe
  jmp alltraps
80105737:	e9 ff fa ff ff       	jmp    8010523b <alltraps>

8010573c <vector15>:
.globl vector15
vector15:
  pushl $0
8010573c:	6a 00                	push   $0x0
  pushl $15
8010573e:	6a 0f                	push   $0xf
  jmp alltraps
80105740:	e9 f6 fa ff ff       	jmp    8010523b <alltraps>

80105745 <vector16>:
.globl vector16
vector16:
  pushl $0
80105745:	6a 00                	push   $0x0
  pushl $16
80105747:	6a 10                	push   $0x10
  jmp alltraps
80105749:	e9 ed fa ff ff       	jmp    8010523b <alltraps>

8010574e <vector17>:
.globl vector17
vector17:
  pushl $17
8010574e:	6a 11                	push   $0x11
  jmp alltraps
80105750:	e9 e6 fa ff ff       	jmp    8010523b <alltraps>

80105755 <vector18>:
.globl vector18
vector18:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $18
80105757:	6a 12                	push   $0x12
  jmp alltraps
80105759:	e9 dd fa ff ff       	jmp    8010523b <alltraps>

8010575e <vector19>:
.globl vector19
vector19:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $19
80105760:	6a 13                	push   $0x13
  jmp alltraps
80105762:	e9 d4 fa ff ff       	jmp    8010523b <alltraps>

80105767 <vector20>:
.globl vector20
vector20:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $20
80105769:	6a 14                	push   $0x14
  jmp alltraps
8010576b:	e9 cb fa ff ff       	jmp    8010523b <alltraps>

80105770 <vector21>:
.globl vector21
vector21:
  pushl $0
80105770:	6a 00                	push   $0x0
  pushl $21
80105772:	6a 15                	push   $0x15
  jmp alltraps
80105774:	e9 c2 fa ff ff       	jmp    8010523b <alltraps>

80105779 <vector22>:
.globl vector22
vector22:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $22
8010577b:	6a 16                	push   $0x16
  jmp alltraps
8010577d:	e9 b9 fa ff ff       	jmp    8010523b <alltraps>

80105782 <vector23>:
.globl vector23
vector23:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $23
80105784:	6a 17                	push   $0x17
  jmp alltraps
80105786:	e9 b0 fa ff ff       	jmp    8010523b <alltraps>

8010578b <vector24>:
.globl vector24
vector24:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $24
8010578d:	6a 18                	push   $0x18
  jmp alltraps
8010578f:	e9 a7 fa ff ff       	jmp    8010523b <alltraps>

80105794 <vector25>:
.globl vector25
vector25:
  pushl $0
80105794:	6a 00                	push   $0x0
  pushl $25
80105796:	6a 19                	push   $0x19
  jmp alltraps
80105798:	e9 9e fa ff ff       	jmp    8010523b <alltraps>

8010579d <vector26>:
.globl vector26
vector26:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $26
8010579f:	6a 1a                	push   $0x1a
  jmp alltraps
801057a1:	e9 95 fa ff ff       	jmp    8010523b <alltraps>

801057a6 <vector27>:
.globl vector27
vector27:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $27
801057a8:	6a 1b                	push   $0x1b
  jmp alltraps
801057aa:	e9 8c fa ff ff       	jmp    8010523b <alltraps>

801057af <vector28>:
.globl vector28
vector28:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $28
801057b1:	6a 1c                	push   $0x1c
  jmp alltraps
801057b3:	e9 83 fa ff ff       	jmp    8010523b <alltraps>

801057b8 <vector29>:
.globl vector29
vector29:
  pushl $0
801057b8:	6a 00                	push   $0x0
  pushl $29
801057ba:	6a 1d                	push   $0x1d
  jmp alltraps
801057bc:	e9 7a fa ff ff       	jmp    8010523b <alltraps>

801057c1 <vector30>:
.globl vector30
vector30:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $30
801057c3:	6a 1e                	push   $0x1e
  jmp alltraps
801057c5:	e9 71 fa ff ff       	jmp    8010523b <alltraps>

801057ca <vector31>:
.globl vector31
vector31:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $31
801057cc:	6a 1f                	push   $0x1f
  jmp alltraps
801057ce:	e9 68 fa ff ff       	jmp    8010523b <alltraps>

801057d3 <vector32>:
.globl vector32
vector32:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $32
801057d5:	6a 20                	push   $0x20
  jmp alltraps
801057d7:	e9 5f fa ff ff       	jmp    8010523b <alltraps>

801057dc <vector33>:
.globl vector33
vector33:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $33
801057de:	6a 21                	push   $0x21
  jmp alltraps
801057e0:	e9 56 fa ff ff       	jmp    8010523b <alltraps>

801057e5 <vector34>:
.globl vector34
vector34:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $34
801057e7:	6a 22                	push   $0x22
  jmp alltraps
801057e9:	e9 4d fa ff ff       	jmp    8010523b <alltraps>

801057ee <vector35>:
.globl vector35
vector35:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $35
801057f0:	6a 23                	push   $0x23
  jmp alltraps
801057f2:	e9 44 fa ff ff       	jmp    8010523b <alltraps>

801057f7 <vector36>:
.globl vector36
vector36:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $36
801057f9:	6a 24                	push   $0x24
  jmp alltraps
801057fb:	e9 3b fa ff ff       	jmp    8010523b <alltraps>

80105800 <vector37>:
.globl vector37
vector37:
  pushl $0
80105800:	6a 00                	push   $0x0
  pushl $37
80105802:	6a 25                	push   $0x25
  jmp alltraps
80105804:	e9 32 fa ff ff       	jmp    8010523b <alltraps>

80105809 <vector38>:
.globl vector38
vector38:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $38
8010580b:	6a 26                	push   $0x26
  jmp alltraps
8010580d:	e9 29 fa ff ff       	jmp    8010523b <alltraps>

80105812 <vector39>:
.globl vector39
vector39:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $39
80105814:	6a 27                	push   $0x27
  jmp alltraps
80105816:	e9 20 fa ff ff       	jmp    8010523b <alltraps>

8010581b <vector40>:
.globl vector40
vector40:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $40
8010581d:	6a 28                	push   $0x28
  jmp alltraps
8010581f:	e9 17 fa ff ff       	jmp    8010523b <alltraps>

80105824 <vector41>:
.globl vector41
vector41:
  pushl $0
80105824:	6a 00                	push   $0x0
  pushl $41
80105826:	6a 29                	push   $0x29
  jmp alltraps
80105828:	e9 0e fa ff ff       	jmp    8010523b <alltraps>

8010582d <vector42>:
.globl vector42
vector42:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $42
8010582f:	6a 2a                	push   $0x2a
  jmp alltraps
80105831:	e9 05 fa ff ff       	jmp    8010523b <alltraps>

80105836 <vector43>:
.globl vector43
vector43:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $43
80105838:	6a 2b                	push   $0x2b
  jmp alltraps
8010583a:	e9 fc f9 ff ff       	jmp    8010523b <alltraps>

8010583f <vector44>:
.globl vector44
vector44:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $44
80105841:	6a 2c                	push   $0x2c
  jmp alltraps
80105843:	e9 f3 f9 ff ff       	jmp    8010523b <alltraps>

80105848 <vector45>:
.globl vector45
vector45:
  pushl $0
80105848:	6a 00                	push   $0x0
  pushl $45
8010584a:	6a 2d                	push   $0x2d
  jmp alltraps
8010584c:	e9 ea f9 ff ff       	jmp    8010523b <alltraps>

80105851 <vector46>:
.globl vector46
vector46:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $46
80105853:	6a 2e                	push   $0x2e
  jmp alltraps
80105855:	e9 e1 f9 ff ff       	jmp    8010523b <alltraps>

8010585a <vector47>:
.globl vector47
vector47:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $47
8010585c:	6a 2f                	push   $0x2f
  jmp alltraps
8010585e:	e9 d8 f9 ff ff       	jmp    8010523b <alltraps>

80105863 <vector48>:
.globl vector48
vector48:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $48
80105865:	6a 30                	push   $0x30
  jmp alltraps
80105867:	e9 cf f9 ff ff       	jmp    8010523b <alltraps>

8010586c <vector49>:
.globl vector49
vector49:
  pushl $0
8010586c:	6a 00                	push   $0x0
  pushl $49
8010586e:	6a 31                	push   $0x31
  jmp alltraps
80105870:	e9 c6 f9 ff ff       	jmp    8010523b <alltraps>

80105875 <vector50>:
.globl vector50
vector50:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $50
80105877:	6a 32                	push   $0x32
  jmp alltraps
80105879:	e9 bd f9 ff ff       	jmp    8010523b <alltraps>

8010587e <vector51>:
.globl vector51
vector51:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $51
80105880:	6a 33                	push   $0x33
  jmp alltraps
80105882:	e9 b4 f9 ff ff       	jmp    8010523b <alltraps>

80105887 <vector52>:
.globl vector52
vector52:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $52
80105889:	6a 34                	push   $0x34
  jmp alltraps
8010588b:	e9 ab f9 ff ff       	jmp    8010523b <alltraps>

80105890 <vector53>:
.globl vector53
vector53:
  pushl $0
80105890:	6a 00                	push   $0x0
  pushl $53
80105892:	6a 35                	push   $0x35
  jmp alltraps
80105894:	e9 a2 f9 ff ff       	jmp    8010523b <alltraps>

80105899 <vector54>:
.globl vector54
vector54:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $54
8010589b:	6a 36                	push   $0x36
  jmp alltraps
8010589d:	e9 99 f9 ff ff       	jmp    8010523b <alltraps>

801058a2 <vector55>:
.globl vector55
vector55:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $55
801058a4:	6a 37                	push   $0x37
  jmp alltraps
801058a6:	e9 90 f9 ff ff       	jmp    8010523b <alltraps>

801058ab <vector56>:
.globl vector56
vector56:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $56
801058ad:	6a 38                	push   $0x38
  jmp alltraps
801058af:	e9 87 f9 ff ff       	jmp    8010523b <alltraps>

801058b4 <vector57>:
.globl vector57
vector57:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $57
801058b6:	6a 39                	push   $0x39
  jmp alltraps
801058b8:	e9 7e f9 ff ff       	jmp    8010523b <alltraps>

801058bd <vector58>:
.globl vector58
vector58:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $58
801058bf:	6a 3a                	push   $0x3a
  jmp alltraps
801058c1:	e9 75 f9 ff ff       	jmp    8010523b <alltraps>

801058c6 <vector59>:
.globl vector59
vector59:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $59
801058c8:	6a 3b                	push   $0x3b
  jmp alltraps
801058ca:	e9 6c f9 ff ff       	jmp    8010523b <alltraps>

801058cf <vector60>:
.globl vector60
vector60:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $60
801058d1:	6a 3c                	push   $0x3c
  jmp alltraps
801058d3:	e9 63 f9 ff ff       	jmp    8010523b <alltraps>

801058d8 <vector61>:
.globl vector61
vector61:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $61
801058da:	6a 3d                	push   $0x3d
  jmp alltraps
801058dc:	e9 5a f9 ff ff       	jmp    8010523b <alltraps>

801058e1 <vector62>:
.globl vector62
vector62:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $62
801058e3:	6a 3e                	push   $0x3e
  jmp alltraps
801058e5:	e9 51 f9 ff ff       	jmp    8010523b <alltraps>

801058ea <vector63>:
.globl vector63
vector63:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $63
801058ec:	6a 3f                	push   $0x3f
  jmp alltraps
801058ee:	e9 48 f9 ff ff       	jmp    8010523b <alltraps>

801058f3 <vector64>:
.globl vector64
vector64:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $64
801058f5:	6a 40                	push   $0x40
  jmp alltraps
801058f7:	e9 3f f9 ff ff       	jmp    8010523b <alltraps>

801058fc <vector65>:
.globl vector65
vector65:
  pushl $0
801058fc:	6a 00                	push   $0x0
  pushl $65
801058fe:	6a 41                	push   $0x41
  jmp alltraps
80105900:	e9 36 f9 ff ff       	jmp    8010523b <alltraps>

80105905 <vector66>:
.globl vector66
vector66:
  pushl $0
80105905:	6a 00                	push   $0x0
  pushl $66
80105907:	6a 42                	push   $0x42
  jmp alltraps
80105909:	e9 2d f9 ff ff       	jmp    8010523b <alltraps>

8010590e <vector67>:
.globl vector67
vector67:
  pushl $0
8010590e:	6a 00                	push   $0x0
  pushl $67
80105910:	6a 43                	push   $0x43
  jmp alltraps
80105912:	e9 24 f9 ff ff       	jmp    8010523b <alltraps>

80105917 <vector68>:
.globl vector68
vector68:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $68
80105919:	6a 44                	push   $0x44
  jmp alltraps
8010591b:	e9 1b f9 ff ff       	jmp    8010523b <alltraps>

80105920 <vector69>:
.globl vector69
vector69:
  pushl $0
80105920:	6a 00                	push   $0x0
  pushl $69
80105922:	6a 45                	push   $0x45
  jmp alltraps
80105924:	e9 12 f9 ff ff       	jmp    8010523b <alltraps>

80105929 <vector70>:
.globl vector70
vector70:
  pushl $0
80105929:	6a 00                	push   $0x0
  pushl $70
8010592b:	6a 46                	push   $0x46
  jmp alltraps
8010592d:	e9 09 f9 ff ff       	jmp    8010523b <alltraps>

80105932 <vector71>:
.globl vector71
vector71:
  pushl $0
80105932:	6a 00                	push   $0x0
  pushl $71
80105934:	6a 47                	push   $0x47
  jmp alltraps
80105936:	e9 00 f9 ff ff       	jmp    8010523b <alltraps>

8010593b <vector72>:
.globl vector72
vector72:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $72
8010593d:	6a 48                	push   $0x48
  jmp alltraps
8010593f:	e9 f7 f8 ff ff       	jmp    8010523b <alltraps>

80105944 <vector73>:
.globl vector73
vector73:
  pushl $0
80105944:	6a 00                	push   $0x0
  pushl $73
80105946:	6a 49                	push   $0x49
  jmp alltraps
80105948:	e9 ee f8 ff ff       	jmp    8010523b <alltraps>

8010594d <vector74>:
.globl vector74
vector74:
  pushl $0
8010594d:	6a 00                	push   $0x0
  pushl $74
8010594f:	6a 4a                	push   $0x4a
  jmp alltraps
80105951:	e9 e5 f8 ff ff       	jmp    8010523b <alltraps>

80105956 <vector75>:
.globl vector75
vector75:
  pushl $0
80105956:	6a 00                	push   $0x0
  pushl $75
80105958:	6a 4b                	push   $0x4b
  jmp alltraps
8010595a:	e9 dc f8 ff ff       	jmp    8010523b <alltraps>

8010595f <vector76>:
.globl vector76
vector76:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $76
80105961:	6a 4c                	push   $0x4c
  jmp alltraps
80105963:	e9 d3 f8 ff ff       	jmp    8010523b <alltraps>

80105968 <vector77>:
.globl vector77
vector77:
  pushl $0
80105968:	6a 00                	push   $0x0
  pushl $77
8010596a:	6a 4d                	push   $0x4d
  jmp alltraps
8010596c:	e9 ca f8 ff ff       	jmp    8010523b <alltraps>

80105971 <vector78>:
.globl vector78
vector78:
  pushl $0
80105971:	6a 00                	push   $0x0
  pushl $78
80105973:	6a 4e                	push   $0x4e
  jmp alltraps
80105975:	e9 c1 f8 ff ff       	jmp    8010523b <alltraps>

8010597a <vector79>:
.globl vector79
vector79:
  pushl $0
8010597a:	6a 00                	push   $0x0
  pushl $79
8010597c:	6a 4f                	push   $0x4f
  jmp alltraps
8010597e:	e9 b8 f8 ff ff       	jmp    8010523b <alltraps>

80105983 <vector80>:
.globl vector80
vector80:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $80
80105985:	6a 50                	push   $0x50
  jmp alltraps
80105987:	e9 af f8 ff ff       	jmp    8010523b <alltraps>

8010598c <vector81>:
.globl vector81
vector81:
  pushl $0
8010598c:	6a 00                	push   $0x0
  pushl $81
8010598e:	6a 51                	push   $0x51
  jmp alltraps
80105990:	e9 a6 f8 ff ff       	jmp    8010523b <alltraps>

80105995 <vector82>:
.globl vector82
vector82:
  pushl $0
80105995:	6a 00                	push   $0x0
  pushl $82
80105997:	6a 52                	push   $0x52
  jmp alltraps
80105999:	e9 9d f8 ff ff       	jmp    8010523b <alltraps>

8010599e <vector83>:
.globl vector83
vector83:
  pushl $0
8010599e:	6a 00                	push   $0x0
  pushl $83
801059a0:	6a 53                	push   $0x53
  jmp alltraps
801059a2:	e9 94 f8 ff ff       	jmp    8010523b <alltraps>

801059a7 <vector84>:
.globl vector84
vector84:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $84
801059a9:	6a 54                	push   $0x54
  jmp alltraps
801059ab:	e9 8b f8 ff ff       	jmp    8010523b <alltraps>

801059b0 <vector85>:
.globl vector85
vector85:
  pushl $0
801059b0:	6a 00                	push   $0x0
  pushl $85
801059b2:	6a 55                	push   $0x55
  jmp alltraps
801059b4:	e9 82 f8 ff ff       	jmp    8010523b <alltraps>

801059b9 <vector86>:
.globl vector86
vector86:
  pushl $0
801059b9:	6a 00                	push   $0x0
  pushl $86
801059bb:	6a 56                	push   $0x56
  jmp alltraps
801059bd:	e9 79 f8 ff ff       	jmp    8010523b <alltraps>

801059c2 <vector87>:
.globl vector87
vector87:
  pushl $0
801059c2:	6a 00                	push   $0x0
  pushl $87
801059c4:	6a 57                	push   $0x57
  jmp alltraps
801059c6:	e9 70 f8 ff ff       	jmp    8010523b <alltraps>

801059cb <vector88>:
.globl vector88
vector88:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $88
801059cd:	6a 58                	push   $0x58
  jmp alltraps
801059cf:	e9 67 f8 ff ff       	jmp    8010523b <alltraps>

801059d4 <vector89>:
.globl vector89
vector89:
  pushl $0
801059d4:	6a 00                	push   $0x0
  pushl $89
801059d6:	6a 59                	push   $0x59
  jmp alltraps
801059d8:	e9 5e f8 ff ff       	jmp    8010523b <alltraps>

801059dd <vector90>:
.globl vector90
vector90:
  pushl $0
801059dd:	6a 00                	push   $0x0
  pushl $90
801059df:	6a 5a                	push   $0x5a
  jmp alltraps
801059e1:	e9 55 f8 ff ff       	jmp    8010523b <alltraps>

801059e6 <vector91>:
.globl vector91
vector91:
  pushl $0
801059e6:	6a 00                	push   $0x0
  pushl $91
801059e8:	6a 5b                	push   $0x5b
  jmp alltraps
801059ea:	e9 4c f8 ff ff       	jmp    8010523b <alltraps>

801059ef <vector92>:
.globl vector92
vector92:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $92
801059f1:	6a 5c                	push   $0x5c
  jmp alltraps
801059f3:	e9 43 f8 ff ff       	jmp    8010523b <alltraps>

801059f8 <vector93>:
.globl vector93
vector93:
  pushl $0
801059f8:	6a 00                	push   $0x0
  pushl $93
801059fa:	6a 5d                	push   $0x5d
  jmp alltraps
801059fc:	e9 3a f8 ff ff       	jmp    8010523b <alltraps>

80105a01 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a01:	6a 00                	push   $0x0
  pushl $94
80105a03:	6a 5e                	push   $0x5e
  jmp alltraps
80105a05:	e9 31 f8 ff ff       	jmp    8010523b <alltraps>

80105a0a <vector95>:
.globl vector95
vector95:
  pushl $0
80105a0a:	6a 00                	push   $0x0
  pushl $95
80105a0c:	6a 5f                	push   $0x5f
  jmp alltraps
80105a0e:	e9 28 f8 ff ff       	jmp    8010523b <alltraps>

80105a13 <vector96>:
.globl vector96
vector96:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $96
80105a15:	6a 60                	push   $0x60
  jmp alltraps
80105a17:	e9 1f f8 ff ff       	jmp    8010523b <alltraps>

80105a1c <vector97>:
.globl vector97
vector97:
  pushl $0
80105a1c:	6a 00                	push   $0x0
  pushl $97
80105a1e:	6a 61                	push   $0x61
  jmp alltraps
80105a20:	e9 16 f8 ff ff       	jmp    8010523b <alltraps>

80105a25 <vector98>:
.globl vector98
vector98:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $98
80105a27:	6a 62                	push   $0x62
  jmp alltraps
80105a29:	e9 0d f8 ff ff       	jmp    8010523b <alltraps>

80105a2e <vector99>:
.globl vector99
vector99:
  pushl $0
80105a2e:	6a 00                	push   $0x0
  pushl $99
80105a30:	6a 63                	push   $0x63
  jmp alltraps
80105a32:	e9 04 f8 ff ff       	jmp    8010523b <alltraps>

80105a37 <vector100>:
.globl vector100
vector100:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $100
80105a39:	6a 64                	push   $0x64
  jmp alltraps
80105a3b:	e9 fb f7 ff ff       	jmp    8010523b <alltraps>

80105a40 <vector101>:
.globl vector101
vector101:
  pushl $0
80105a40:	6a 00                	push   $0x0
  pushl $101
80105a42:	6a 65                	push   $0x65
  jmp alltraps
80105a44:	e9 f2 f7 ff ff       	jmp    8010523b <alltraps>

80105a49 <vector102>:
.globl vector102
vector102:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $102
80105a4b:	6a 66                	push   $0x66
  jmp alltraps
80105a4d:	e9 e9 f7 ff ff       	jmp    8010523b <alltraps>

80105a52 <vector103>:
.globl vector103
vector103:
  pushl $0
80105a52:	6a 00                	push   $0x0
  pushl $103
80105a54:	6a 67                	push   $0x67
  jmp alltraps
80105a56:	e9 e0 f7 ff ff       	jmp    8010523b <alltraps>

80105a5b <vector104>:
.globl vector104
vector104:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $104
80105a5d:	6a 68                	push   $0x68
  jmp alltraps
80105a5f:	e9 d7 f7 ff ff       	jmp    8010523b <alltraps>

80105a64 <vector105>:
.globl vector105
vector105:
  pushl $0
80105a64:	6a 00                	push   $0x0
  pushl $105
80105a66:	6a 69                	push   $0x69
  jmp alltraps
80105a68:	e9 ce f7 ff ff       	jmp    8010523b <alltraps>

80105a6d <vector106>:
.globl vector106
vector106:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $106
80105a6f:	6a 6a                	push   $0x6a
  jmp alltraps
80105a71:	e9 c5 f7 ff ff       	jmp    8010523b <alltraps>

80105a76 <vector107>:
.globl vector107
vector107:
  pushl $0
80105a76:	6a 00                	push   $0x0
  pushl $107
80105a78:	6a 6b                	push   $0x6b
  jmp alltraps
80105a7a:	e9 bc f7 ff ff       	jmp    8010523b <alltraps>

80105a7f <vector108>:
.globl vector108
vector108:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $108
80105a81:	6a 6c                	push   $0x6c
  jmp alltraps
80105a83:	e9 b3 f7 ff ff       	jmp    8010523b <alltraps>

80105a88 <vector109>:
.globl vector109
vector109:
  pushl $0
80105a88:	6a 00                	push   $0x0
  pushl $109
80105a8a:	6a 6d                	push   $0x6d
  jmp alltraps
80105a8c:	e9 aa f7 ff ff       	jmp    8010523b <alltraps>

80105a91 <vector110>:
.globl vector110
vector110:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $110
80105a93:	6a 6e                	push   $0x6e
  jmp alltraps
80105a95:	e9 a1 f7 ff ff       	jmp    8010523b <alltraps>

80105a9a <vector111>:
.globl vector111
vector111:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $111
80105a9c:	6a 6f                	push   $0x6f
  jmp alltraps
80105a9e:	e9 98 f7 ff ff       	jmp    8010523b <alltraps>

80105aa3 <vector112>:
.globl vector112
vector112:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $112
80105aa5:	6a 70                	push   $0x70
  jmp alltraps
80105aa7:	e9 8f f7 ff ff       	jmp    8010523b <alltraps>

80105aac <vector113>:
.globl vector113
vector113:
  pushl $0
80105aac:	6a 00                	push   $0x0
  pushl $113
80105aae:	6a 71                	push   $0x71
  jmp alltraps
80105ab0:	e9 86 f7 ff ff       	jmp    8010523b <alltraps>

80105ab5 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $114
80105ab7:	6a 72                	push   $0x72
  jmp alltraps
80105ab9:	e9 7d f7 ff ff       	jmp    8010523b <alltraps>

80105abe <vector115>:
.globl vector115
vector115:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $115
80105ac0:	6a 73                	push   $0x73
  jmp alltraps
80105ac2:	e9 74 f7 ff ff       	jmp    8010523b <alltraps>

80105ac7 <vector116>:
.globl vector116
vector116:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $116
80105ac9:	6a 74                	push   $0x74
  jmp alltraps
80105acb:	e9 6b f7 ff ff       	jmp    8010523b <alltraps>

80105ad0 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ad0:	6a 00                	push   $0x0
  pushl $117
80105ad2:	6a 75                	push   $0x75
  jmp alltraps
80105ad4:	e9 62 f7 ff ff       	jmp    8010523b <alltraps>

80105ad9 <vector118>:
.globl vector118
vector118:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $118
80105adb:	6a 76                	push   $0x76
  jmp alltraps
80105add:	e9 59 f7 ff ff       	jmp    8010523b <alltraps>

80105ae2 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $119
80105ae4:	6a 77                	push   $0x77
  jmp alltraps
80105ae6:	e9 50 f7 ff ff       	jmp    8010523b <alltraps>

80105aeb <vector120>:
.globl vector120
vector120:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $120
80105aed:	6a 78                	push   $0x78
  jmp alltraps
80105aef:	e9 47 f7 ff ff       	jmp    8010523b <alltraps>

80105af4 <vector121>:
.globl vector121
vector121:
  pushl $0
80105af4:	6a 00                	push   $0x0
  pushl $121
80105af6:	6a 79                	push   $0x79
  jmp alltraps
80105af8:	e9 3e f7 ff ff       	jmp    8010523b <alltraps>

80105afd <vector122>:
.globl vector122
vector122:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $122
80105aff:	6a 7a                	push   $0x7a
  jmp alltraps
80105b01:	e9 35 f7 ff ff       	jmp    8010523b <alltraps>

80105b06 <vector123>:
.globl vector123
vector123:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $123
80105b08:	6a 7b                	push   $0x7b
  jmp alltraps
80105b0a:	e9 2c f7 ff ff       	jmp    8010523b <alltraps>

80105b0f <vector124>:
.globl vector124
vector124:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $124
80105b11:	6a 7c                	push   $0x7c
  jmp alltraps
80105b13:	e9 23 f7 ff ff       	jmp    8010523b <alltraps>

80105b18 <vector125>:
.globl vector125
vector125:
  pushl $0
80105b18:	6a 00                	push   $0x0
  pushl $125
80105b1a:	6a 7d                	push   $0x7d
  jmp alltraps
80105b1c:	e9 1a f7 ff ff       	jmp    8010523b <alltraps>

80105b21 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $126
80105b23:	6a 7e                	push   $0x7e
  jmp alltraps
80105b25:	e9 11 f7 ff ff       	jmp    8010523b <alltraps>

80105b2a <vector127>:
.globl vector127
vector127:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $127
80105b2c:	6a 7f                	push   $0x7f
  jmp alltraps
80105b2e:	e9 08 f7 ff ff       	jmp    8010523b <alltraps>

80105b33 <vector128>:
.globl vector128
vector128:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $128
80105b35:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105b3a:	e9 fc f6 ff ff       	jmp    8010523b <alltraps>

80105b3f <vector129>:
.globl vector129
vector129:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $129
80105b41:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105b46:	e9 f0 f6 ff ff       	jmp    8010523b <alltraps>

80105b4b <vector130>:
.globl vector130
vector130:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $130
80105b4d:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105b52:	e9 e4 f6 ff ff       	jmp    8010523b <alltraps>

80105b57 <vector131>:
.globl vector131
vector131:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $131
80105b59:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105b5e:	e9 d8 f6 ff ff       	jmp    8010523b <alltraps>

80105b63 <vector132>:
.globl vector132
vector132:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $132
80105b65:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105b6a:	e9 cc f6 ff ff       	jmp    8010523b <alltraps>

80105b6f <vector133>:
.globl vector133
vector133:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $133
80105b71:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105b76:	e9 c0 f6 ff ff       	jmp    8010523b <alltraps>

80105b7b <vector134>:
.globl vector134
vector134:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $134
80105b7d:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105b82:	e9 b4 f6 ff ff       	jmp    8010523b <alltraps>

80105b87 <vector135>:
.globl vector135
vector135:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $135
80105b89:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105b8e:	e9 a8 f6 ff ff       	jmp    8010523b <alltraps>

80105b93 <vector136>:
.globl vector136
vector136:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $136
80105b95:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105b9a:	e9 9c f6 ff ff       	jmp    8010523b <alltraps>

80105b9f <vector137>:
.globl vector137
vector137:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $137
80105ba1:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105ba6:	e9 90 f6 ff ff       	jmp    8010523b <alltraps>

80105bab <vector138>:
.globl vector138
vector138:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $138
80105bad:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105bb2:	e9 84 f6 ff ff       	jmp    8010523b <alltraps>

80105bb7 <vector139>:
.globl vector139
vector139:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $139
80105bb9:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105bbe:	e9 78 f6 ff ff       	jmp    8010523b <alltraps>

80105bc3 <vector140>:
.globl vector140
vector140:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $140
80105bc5:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105bca:	e9 6c f6 ff ff       	jmp    8010523b <alltraps>

80105bcf <vector141>:
.globl vector141
vector141:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $141
80105bd1:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105bd6:	e9 60 f6 ff ff       	jmp    8010523b <alltraps>

80105bdb <vector142>:
.globl vector142
vector142:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $142
80105bdd:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105be2:	e9 54 f6 ff ff       	jmp    8010523b <alltraps>

80105be7 <vector143>:
.globl vector143
vector143:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $143
80105be9:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105bee:	e9 48 f6 ff ff       	jmp    8010523b <alltraps>

80105bf3 <vector144>:
.globl vector144
vector144:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $144
80105bf5:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105bfa:	e9 3c f6 ff ff       	jmp    8010523b <alltraps>

80105bff <vector145>:
.globl vector145
vector145:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $145
80105c01:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c06:	e9 30 f6 ff ff       	jmp    8010523b <alltraps>

80105c0b <vector146>:
.globl vector146
vector146:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $146
80105c0d:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c12:	e9 24 f6 ff ff       	jmp    8010523b <alltraps>

80105c17 <vector147>:
.globl vector147
vector147:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $147
80105c19:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c1e:	e9 18 f6 ff ff       	jmp    8010523b <alltraps>

80105c23 <vector148>:
.globl vector148
vector148:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $148
80105c25:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c2a:	e9 0c f6 ff ff       	jmp    8010523b <alltraps>

80105c2f <vector149>:
.globl vector149
vector149:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $149
80105c31:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105c36:	e9 00 f6 ff ff       	jmp    8010523b <alltraps>

80105c3b <vector150>:
.globl vector150
vector150:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $150
80105c3d:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105c42:	e9 f4 f5 ff ff       	jmp    8010523b <alltraps>

80105c47 <vector151>:
.globl vector151
vector151:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $151
80105c49:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105c4e:	e9 e8 f5 ff ff       	jmp    8010523b <alltraps>

80105c53 <vector152>:
.globl vector152
vector152:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $152
80105c55:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105c5a:	e9 dc f5 ff ff       	jmp    8010523b <alltraps>

80105c5f <vector153>:
.globl vector153
vector153:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $153
80105c61:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105c66:	e9 d0 f5 ff ff       	jmp    8010523b <alltraps>

80105c6b <vector154>:
.globl vector154
vector154:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $154
80105c6d:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105c72:	e9 c4 f5 ff ff       	jmp    8010523b <alltraps>

80105c77 <vector155>:
.globl vector155
vector155:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $155
80105c79:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105c7e:	e9 b8 f5 ff ff       	jmp    8010523b <alltraps>

80105c83 <vector156>:
.globl vector156
vector156:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $156
80105c85:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105c8a:	e9 ac f5 ff ff       	jmp    8010523b <alltraps>

80105c8f <vector157>:
.globl vector157
vector157:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $157
80105c91:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105c96:	e9 a0 f5 ff ff       	jmp    8010523b <alltraps>

80105c9b <vector158>:
.globl vector158
vector158:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $158
80105c9d:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ca2:	e9 94 f5 ff ff       	jmp    8010523b <alltraps>

80105ca7 <vector159>:
.globl vector159
vector159:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $159
80105ca9:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105cae:	e9 88 f5 ff ff       	jmp    8010523b <alltraps>

80105cb3 <vector160>:
.globl vector160
vector160:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $160
80105cb5:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105cba:	e9 7c f5 ff ff       	jmp    8010523b <alltraps>

80105cbf <vector161>:
.globl vector161
vector161:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $161
80105cc1:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105cc6:	e9 70 f5 ff ff       	jmp    8010523b <alltraps>

80105ccb <vector162>:
.globl vector162
vector162:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $162
80105ccd:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105cd2:	e9 64 f5 ff ff       	jmp    8010523b <alltraps>

80105cd7 <vector163>:
.globl vector163
vector163:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $163
80105cd9:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105cde:	e9 58 f5 ff ff       	jmp    8010523b <alltraps>

80105ce3 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $164
80105ce5:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105cea:	e9 4c f5 ff ff       	jmp    8010523b <alltraps>

80105cef <vector165>:
.globl vector165
vector165:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $165
80105cf1:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105cf6:	e9 40 f5 ff ff       	jmp    8010523b <alltraps>

80105cfb <vector166>:
.globl vector166
vector166:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $166
80105cfd:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d02:	e9 34 f5 ff ff       	jmp    8010523b <alltraps>

80105d07 <vector167>:
.globl vector167
vector167:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $167
80105d09:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d0e:	e9 28 f5 ff ff       	jmp    8010523b <alltraps>

80105d13 <vector168>:
.globl vector168
vector168:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $168
80105d15:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d1a:	e9 1c f5 ff ff       	jmp    8010523b <alltraps>

80105d1f <vector169>:
.globl vector169
vector169:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $169
80105d21:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d26:	e9 10 f5 ff ff       	jmp    8010523b <alltraps>

80105d2b <vector170>:
.globl vector170
vector170:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $170
80105d2d:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105d32:	e9 04 f5 ff ff       	jmp    8010523b <alltraps>

80105d37 <vector171>:
.globl vector171
vector171:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $171
80105d39:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105d3e:	e9 f8 f4 ff ff       	jmp    8010523b <alltraps>

80105d43 <vector172>:
.globl vector172
vector172:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $172
80105d45:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105d4a:	e9 ec f4 ff ff       	jmp    8010523b <alltraps>

80105d4f <vector173>:
.globl vector173
vector173:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $173
80105d51:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105d56:	e9 e0 f4 ff ff       	jmp    8010523b <alltraps>

80105d5b <vector174>:
.globl vector174
vector174:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $174
80105d5d:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105d62:	e9 d4 f4 ff ff       	jmp    8010523b <alltraps>

80105d67 <vector175>:
.globl vector175
vector175:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $175
80105d69:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105d6e:	e9 c8 f4 ff ff       	jmp    8010523b <alltraps>

80105d73 <vector176>:
.globl vector176
vector176:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $176
80105d75:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105d7a:	e9 bc f4 ff ff       	jmp    8010523b <alltraps>

80105d7f <vector177>:
.globl vector177
vector177:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $177
80105d81:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105d86:	e9 b0 f4 ff ff       	jmp    8010523b <alltraps>

80105d8b <vector178>:
.globl vector178
vector178:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $178
80105d8d:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105d92:	e9 a4 f4 ff ff       	jmp    8010523b <alltraps>

80105d97 <vector179>:
.globl vector179
vector179:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $179
80105d99:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105d9e:	e9 98 f4 ff ff       	jmp    8010523b <alltraps>

80105da3 <vector180>:
.globl vector180
vector180:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $180
80105da5:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105daa:	e9 8c f4 ff ff       	jmp    8010523b <alltraps>

80105daf <vector181>:
.globl vector181
vector181:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $181
80105db1:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105db6:	e9 80 f4 ff ff       	jmp    8010523b <alltraps>

80105dbb <vector182>:
.globl vector182
vector182:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $182
80105dbd:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105dc2:	e9 74 f4 ff ff       	jmp    8010523b <alltraps>

80105dc7 <vector183>:
.globl vector183
vector183:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $183
80105dc9:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105dce:	e9 68 f4 ff ff       	jmp    8010523b <alltraps>

80105dd3 <vector184>:
.globl vector184
vector184:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $184
80105dd5:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105dda:	e9 5c f4 ff ff       	jmp    8010523b <alltraps>

80105ddf <vector185>:
.globl vector185
vector185:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $185
80105de1:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105de6:	e9 50 f4 ff ff       	jmp    8010523b <alltraps>

80105deb <vector186>:
.globl vector186
vector186:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $186
80105ded:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105df2:	e9 44 f4 ff ff       	jmp    8010523b <alltraps>

80105df7 <vector187>:
.globl vector187
vector187:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $187
80105df9:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105dfe:	e9 38 f4 ff ff       	jmp    8010523b <alltraps>

80105e03 <vector188>:
.globl vector188
vector188:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $188
80105e05:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e0a:	e9 2c f4 ff ff       	jmp    8010523b <alltraps>

80105e0f <vector189>:
.globl vector189
vector189:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $189
80105e11:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e16:	e9 20 f4 ff ff       	jmp    8010523b <alltraps>

80105e1b <vector190>:
.globl vector190
vector190:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $190
80105e1d:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e22:	e9 14 f4 ff ff       	jmp    8010523b <alltraps>

80105e27 <vector191>:
.globl vector191
vector191:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $191
80105e29:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105e2e:	e9 08 f4 ff ff       	jmp    8010523b <alltraps>

80105e33 <vector192>:
.globl vector192
vector192:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $192
80105e35:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105e3a:	e9 fc f3 ff ff       	jmp    8010523b <alltraps>

80105e3f <vector193>:
.globl vector193
vector193:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $193
80105e41:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105e46:	e9 f0 f3 ff ff       	jmp    8010523b <alltraps>

80105e4b <vector194>:
.globl vector194
vector194:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $194
80105e4d:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105e52:	e9 e4 f3 ff ff       	jmp    8010523b <alltraps>

80105e57 <vector195>:
.globl vector195
vector195:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $195
80105e59:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105e5e:	e9 d8 f3 ff ff       	jmp    8010523b <alltraps>

80105e63 <vector196>:
.globl vector196
vector196:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $196
80105e65:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105e6a:	e9 cc f3 ff ff       	jmp    8010523b <alltraps>

80105e6f <vector197>:
.globl vector197
vector197:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $197
80105e71:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105e76:	e9 c0 f3 ff ff       	jmp    8010523b <alltraps>

80105e7b <vector198>:
.globl vector198
vector198:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $198
80105e7d:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105e82:	e9 b4 f3 ff ff       	jmp    8010523b <alltraps>

80105e87 <vector199>:
.globl vector199
vector199:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $199
80105e89:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105e8e:	e9 a8 f3 ff ff       	jmp    8010523b <alltraps>

80105e93 <vector200>:
.globl vector200
vector200:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $200
80105e95:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105e9a:	e9 9c f3 ff ff       	jmp    8010523b <alltraps>

80105e9f <vector201>:
.globl vector201
vector201:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $201
80105ea1:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105ea6:	e9 90 f3 ff ff       	jmp    8010523b <alltraps>

80105eab <vector202>:
.globl vector202
vector202:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $202
80105ead:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105eb2:	e9 84 f3 ff ff       	jmp    8010523b <alltraps>

80105eb7 <vector203>:
.globl vector203
vector203:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $203
80105eb9:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105ebe:	e9 78 f3 ff ff       	jmp    8010523b <alltraps>

80105ec3 <vector204>:
.globl vector204
vector204:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $204
80105ec5:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105eca:	e9 6c f3 ff ff       	jmp    8010523b <alltraps>

80105ecf <vector205>:
.globl vector205
vector205:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $205
80105ed1:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105ed6:	e9 60 f3 ff ff       	jmp    8010523b <alltraps>

80105edb <vector206>:
.globl vector206
vector206:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $206
80105edd:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105ee2:	e9 54 f3 ff ff       	jmp    8010523b <alltraps>

80105ee7 <vector207>:
.globl vector207
vector207:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $207
80105ee9:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105eee:	e9 48 f3 ff ff       	jmp    8010523b <alltraps>

80105ef3 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $208
80105ef5:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105efa:	e9 3c f3 ff ff       	jmp    8010523b <alltraps>

80105eff <vector209>:
.globl vector209
vector209:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $209
80105f01:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f06:	e9 30 f3 ff ff       	jmp    8010523b <alltraps>

80105f0b <vector210>:
.globl vector210
vector210:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $210
80105f0d:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f12:	e9 24 f3 ff ff       	jmp    8010523b <alltraps>

80105f17 <vector211>:
.globl vector211
vector211:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $211
80105f19:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f1e:	e9 18 f3 ff ff       	jmp    8010523b <alltraps>

80105f23 <vector212>:
.globl vector212
vector212:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $212
80105f25:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f2a:	e9 0c f3 ff ff       	jmp    8010523b <alltraps>

80105f2f <vector213>:
.globl vector213
vector213:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $213
80105f31:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105f36:	e9 00 f3 ff ff       	jmp    8010523b <alltraps>

80105f3b <vector214>:
.globl vector214
vector214:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $214
80105f3d:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105f42:	e9 f4 f2 ff ff       	jmp    8010523b <alltraps>

80105f47 <vector215>:
.globl vector215
vector215:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $215
80105f49:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105f4e:	e9 e8 f2 ff ff       	jmp    8010523b <alltraps>

80105f53 <vector216>:
.globl vector216
vector216:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $216
80105f55:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105f5a:	e9 dc f2 ff ff       	jmp    8010523b <alltraps>

80105f5f <vector217>:
.globl vector217
vector217:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $217
80105f61:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105f66:	e9 d0 f2 ff ff       	jmp    8010523b <alltraps>

80105f6b <vector218>:
.globl vector218
vector218:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $218
80105f6d:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105f72:	e9 c4 f2 ff ff       	jmp    8010523b <alltraps>

80105f77 <vector219>:
.globl vector219
vector219:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $219
80105f79:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105f7e:	e9 b8 f2 ff ff       	jmp    8010523b <alltraps>

80105f83 <vector220>:
.globl vector220
vector220:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $220
80105f85:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105f8a:	e9 ac f2 ff ff       	jmp    8010523b <alltraps>

80105f8f <vector221>:
.globl vector221
vector221:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $221
80105f91:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105f96:	e9 a0 f2 ff ff       	jmp    8010523b <alltraps>

80105f9b <vector222>:
.globl vector222
vector222:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $222
80105f9d:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105fa2:	e9 94 f2 ff ff       	jmp    8010523b <alltraps>

80105fa7 <vector223>:
.globl vector223
vector223:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $223
80105fa9:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105fae:	e9 88 f2 ff ff       	jmp    8010523b <alltraps>

80105fb3 <vector224>:
.globl vector224
vector224:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $224
80105fb5:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105fba:	e9 7c f2 ff ff       	jmp    8010523b <alltraps>

80105fbf <vector225>:
.globl vector225
vector225:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $225
80105fc1:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105fc6:	e9 70 f2 ff ff       	jmp    8010523b <alltraps>

80105fcb <vector226>:
.globl vector226
vector226:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $226
80105fcd:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105fd2:	e9 64 f2 ff ff       	jmp    8010523b <alltraps>

80105fd7 <vector227>:
.globl vector227
vector227:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $227
80105fd9:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105fde:	e9 58 f2 ff ff       	jmp    8010523b <alltraps>

80105fe3 <vector228>:
.globl vector228
vector228:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $228
80105fe5:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105fea:	e9 4c f2 ff ff       	jmp    8010523b <alltraps>

80105fef <vector229>:
.globl vector229
vector229:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $229
80105ff1:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105ff6:	e9 40 f2 ff ff       	jmp    8010523b <alltraps>

80105ffb <vector230>:
.globl vector230
vector230:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $230
80105ffd:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106002:	e9 34 f2 ff ff       	jmp    8010523b <alltraps>

80106007 <vector231>:
.globl vector231
vector231:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $231
80106009:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010600e:	e9 28 f2 ff ff       	jmp    8010523b <alltraps>

80106013 <vector232>:
.globl vector232
vector232:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $232
80106015:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010601a:	e9 1c f2 ff ff       	jmp    8010523b <alltraps>

8010601f <vector233>:
.globl vector233
vector233:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $233
80106021:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106026:	e9 10 f2 ff ff       	jmp    8010523b <alltraps>

8010602b <vector234>:
.globl vector234
vector234:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $234
8010602d:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106032:	e9 04 f2 ff ff       	jmp    8010523b <alltraps>

80106037 <vector235>:
.globl vector235
vector235:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $235
80106039:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010603e:	e9 f8 f1 ff ff       	jmp    8010523b <alltraps>

80106043 <vector236>:
.globl vector236
vector236:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $236
80106045:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010604a:	e9 ec f1 ff ff       	jmp    8010523b <alltraps>

8010604f <vector237>:
.globl vector237
vector237:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $237
80106051:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106056:	e9 e0 f1 ff ff       	jmp    8010523b <alltraps>

8010605b <vector238>:
.globl vector238
vector238:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $238
8010605d:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106062:	e9 d4 f1 ff ff       	jmp    8010523b <alltraps>

80106067 <vector239>:
.globl vector239
vector239:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $239
80106069:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010606e:	e9 c8 f1 ff ff       	jmp    8010523b <alltraps>

80106073 <vector240>:
.globl vector240
vector240:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $240
80106075:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010607a:	e9 bc f1 ff ff       	jmp    8010523b <alltraps>

8010607f <vector241>:
.globl vector241
vector241:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $241
80106081:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106086:	e9 b0 f1 ff ff       	jmp    8010523b <alltraps>

8010608b <vector242>:
.globl vector242
vector242:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $242
8010608d:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106092:	e9 a4 f1 ff ff       	jmp    8010523b <alltraps>

80106097 <vector243>:
.globl vector243
vector243:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $243
80106099:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010609e:	e9 98 f1 ff ff       	jmp    8010523b <alltraps>

801060a3 <vector244>:
.globl vector244
vector244:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $244
801060a5:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801060aa:	e9 8c f1 ff ff       	jmp    8010523b <alltraps>

801060af <vector245>:
.globl vector245
vector245:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $245
801060b1:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801060b6:	e9 80 f1 ff ff       	jmp    8010523b <alltraps>

801060bb <vector246>:
.globl vector246
vector246:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $246
801060bd:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801060c2:	e9 74 f1 ff ff       	jmp    8010523b <alltraps>

801060c7 <vector247>:
.globl vector247
vector247:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $247
801060c9:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801060ce:	e9 68 f1 ff ff       	jmp    8010523b <alltraps>

801060d3 <vector248>:
.globl vector248
vector248:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $248
801060d5:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801060da:	e9 5c f1 ff ff       	jmp    8010523b <alltraps>

801060df <vector249>:
.globl vector249
vector249:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $249
801060e1:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801060e6:	e9 50 f1 ff ff       	jmp    8010523b <alltraps>

801060eb <vector250>:
.globl vector250
vector250:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $250
801060ed:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801060f2:	e9 44 f1 ff ff       	jmp    8010523b <alltraps>

801060f7 <vector251>:
.globl vector251
vector251:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $251
801060f9:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801060fe:	e9 38 f1 ff ff       	jmp    8010523b <alltraps>

80106103 <vector252>:
.globl vector252
vector252:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $252
80106105:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010610a:	e9 2c f1 ff ff       	jmp    8010523b <alltraps>

8010610f <vector253>:
.globl vector253
vector253:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $253
80106111:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106116:	e9 20 f1 ff ff       	jmp    8010523b <alltraps>

8010611b <vector254>:
.globl vector254
vector254:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $254
8010611d:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106122:	e9 14 f1 ff ff       	jmp    8010523b <alltraps>

80106127 <vector255>:
.globl vector255
vector255:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $255
80106129:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010612e:	e9 08 f1 ff ff       	jmp    8010523b <alltraps>

80106133 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106133:	55                   	push   %ebp
80106134:	89 e5                	mov    %esp,%ebp
80106136:	57                   	push   %edi
80106137:	56                   	push   %esi
80106138:	53                   	push   %ebx
80106139:	83 ec 0c             	sub    $0xc,%esp
8010613c:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010613e:	c1 ea 16             	shr    $0x16,%edx
80106141:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80106144:	8b 37                	mov    (%edi),%esi
80106146:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010614c:	74 20                	je     8010616e <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010614e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106154:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010615a:	c1 eb 0c             	shr    $0xc,%ebx
8010615d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80106163:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80106166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
8010616d:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010616e:	85 c9                	test   %ecx,%ecx
80106170:	74 2b                	je     8010619d <walkpgdir+0x6a>
80106172:	e8 22 c0 ff ff       	call   80102199 <kalloc>
80106177:	89 c6                	mov    %eax,%esi
80106179:	85 c0                	test   %eax,%eax
8010617b:	74 20                	je     8010619d <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
8010617d:	83 ec 04             	sub    $0x4,%esp
80106180:	68 00 10 00 00       	push   $0x1000
80106185:	6a 00                	push   $0x0
80106187:	50                   	push   %eax
80106188:	e8 92 de ff ff       	call   8010401f <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010618d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106193:	83 c8 07             	or     $0x7,%eax
80106196:	89 07                	mov    %eax,(%edi)
80106198:	83 c4 10             	add    $0x10,%esp
8010619b:	eb bd                	jmp    8010615a <walkpgdir+0x27>
      return 0;
8010619d:	b8 00 00 00 00       	mov    $0x0,%eax
801061a2:	eb c2                	jmp    80106166 <walkpgdir+0x33>

801061a4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	57                   	push   %edi
801061a8:	56                   	push   %esi
801061a9:	53                   	push   %ebx
801061aa:	83 ec 1c             	sub    $0x1c,%esp
801061ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061b0:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801061b3:	89 d3                	mov    %edx,%ebx
801061b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801061bb:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
801061bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801061c5:	b9 01 00 00 00       	mov    $0x1,%ecx
801061ca:	89 da                	mov    %ebx,%edx
801061cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061cf:	e8 5f ff ff ff       	call   80106133 <walkpgdir>
801061d4:	85 c0                	test   %eax,%eax
801061d6:	74 2e                	je     80106206 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
801061d8:	f6 00 01             	testb  $0x1,(%eax)
801061db:	75 1c                	jne    801061f9 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
801061dd:	89 f2                	mov    %esi,%edx
801061df:	0b 55 0c             	or     0xc(%ebp),%edx
801061e2:	83 ca 01             	or     $0x1,%edx
801061e5:	89 10                	mov    %edx,(%eax)
    if(a == last)
801061e7:	39 fb                	cmp    %edi,%ebx
801061e9:	74 28                	je     80106213 <mappages+0x6f>
      break;
    a += PGSIZE;
801061eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801061f1:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801061f7:	eb cc                	jmp    801061c5 <mappages+0x21>
      panic("remap");
801061f9:	83 ec 0c             	sub    $0xc,%esp
801061fc:	68 68 75 10 80       	push   $0x80107568
80106201:	e8 82 a1 ff ff       	call   80100388 <panic>
      return -1;
80106206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010620b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010620e:	5b                   	pop    %ebx
8010620f:	5e                   	pop    %esi
80106210:	5f                   	pop    %edi
80106211:	5d                   	pop    %ebp
80106212:	c3                   	ret    
  return 0;
80106213:	b8 00 00 00 00       	mov    $0x0,%eax
80106218:	eb f1                	jmp    8010620b <mappages+0x67>

8010621a <seginit>:
{
8010621a:	55                   	push   %ebp
8010621b:	89 e5                	mov    %esp,%ebp
8010621d:	57                   	push   %edi
8010621e:	56                   	push   %esi
8010621f:	53                   	push   %ebx
80106220:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80106223:	e8 86 d0 ff ff       	call   801032ae <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106228:	69 f8 b0 00 00 00    	imul   $0xb0,%eax,%edi
8010622e:	66 c7 87 98 33 11 80 	movw   $0xffff,-0x7feecc68(%edi)
80106235:	ff ff 
80106237:	66 c7 87 9a 33 11 80 	movw   $0x0,-0x7feecc66(%edi)
8010623e:	00 00 
80106240:	c6 87 9c 33 11 80 00 	movb   $0x0,-0x7feecc64(%edi)
80106247:	0f b6 8f 9d 33 11 80 	movzbl -0x7feecc63(%edi),%ecx
8010624e:	83 e1 f0             	and    $0xfffffff0,%ecx
80106251:	89 ce                	mov    %ecx,%esi
80106253:	83 ce 0a             	or     $0xa,%esi
80106256:	89 f2                	mov    %esi,%edx
80106258:	88 97 9d 33 11 80    	mov    %dl,-0x7feecc63(%edi)
8010625e:	83 c9 1a             	or     $0x1a,%ecx
80106261:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
80106267:	83 e1 9f             	and    $0xffffff9f,%ecx
8010626a:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
80106270:	83 c9 80             	or     $0xffffff80,%ecx
80106273:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
80106279:	0f b6 8f 9e 33 11 80 	movzbl -0x7feecc62(%edi),%ecx
80106280:	83 c9 0f             	or     $0xf,%ecx
80106283:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
80106289:	89 ce                	mov    %ecx,%esi
8010628b:	83 e6 ef             	and    $0xffffffef,%esi
8010628e:	89 f2                	mov    %esi,%edx
80106290:	88 97 9e 33 11 80    	mov    %dl,-0x7feecc62(%edi)
80106296:	83 e1 cf             	and    $0xffffffcf,%ecx
80106299:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
8010629f:	89 ce                	mov    %ecx,%esi
801062a1:	83 ce 40             	or     $0x40,%esi
801062a4:	89 f2                	mov    %esi,%edx
801062a6:	88 97 9e 33 11 80    	mov    %dl,-0x7feecc62(%edi)
801062ac:	83 c9 c0             	or     $0xffffffc0,%ecx
801062af:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
801062b5:	c6 87 9f 33 11 80 00 	movb   $0x0,-0x7feecc61(%edi)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801062bc:	66 c7 87 a0 33 11 80 	movw   $0xffff,-0x7feecc60(%edi)
801062c3:	ff ff 
801062c5:	66 c7 87 a2 33 11 80 	movw   $0x0,-0x7feecc5e(%edi)
801062cc:	00 00 
801062ce:	c6 87 a4 33 11 80 00 	movb   $0x0,-0x7feecc5c(%edi)
801062d5:	0f b6 8f a5 33 11 80 	movzbl -0x7feecc5b(%edi),%ecx
801062dc:	83 e1 f0             	and    $0xfffffff0,%ecx
801062df:	89 ce                	mov    %ecx,%esi
801062e1:	83 ce 02             	or     $0x2,%esi
801062e4:	89 f2                	mov    %esi,%edx
801062e6:	88 97 a5 33 11 80    	mov    %dl,-0x7feecc5b(%edi)
801062ec:	83 c9 12             	or     $0x12,%ecx
801062ef:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
801062f5:	83 e1 9f             	and    $0xffffff9f,%ecx
801062f8:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
801062fe:	83 c9 80             	or     $0xffffff80,%ecx
80106301:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
80106307:	0f b6 8f a6 33 11 80 	movzbl -0x7feecc5a(%edi),%ecx
8010630e:	83 c9 0f             	or     $0xf,%ecx
80106311:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
80106317:	89 ce                	mov    %ecx,%esi
80106319:	83 e6 ef             	and    $0xffffffef,%esi
8010631c:	89 f2                	mov    %esi,%edx
8010631e:	88 97 a6 33 11 80    	mov    %dl,-0x7feecc5a(%edi)
80106324:	83 e1 cf             	and    $0xffffffcf,%ecx
80106327:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
8010632d:	89 ce                	mov    %ecx,%esi
8010632f:	83 ce 40             	or     $0x40,%esi
80106332:	89 f2                	mov    %esi,%edx
80106334:	88 97 a6 33 11 80    	mov    %dl,-0x7feecc5a(%edi)
8010633a:	83 c9 c0             	or     $0xffffffc0,%ecx
8010633d:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
80106343:	c6 87 a7 33 11 80 00 	movb   $0x0,-0x7feecc59(%edi)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010634a:	66 c7 87 a8 33 11 80 	movw   $0xffff,-0x7feecc58(%edi)
80106351:	ff ff 
80106353:	66 c7 87 aa 33 11 80 	movw   $0x0,-0x7feecc56(%edi)
8010635a:	00 00 
8010635c:	c6 87 ac 33 11 80 00 	movb   $0x0,-0x7feecc54(%edi)
80106363:	0f b6 9f ad 33 11 80 	movzbl -0x7feecc53(%edi),%ebx
8010636a:	83 e3 f0             	and    $0xfffffff0,%ebx
8010636d:	89 de                	mov    %ebx,%esi
8010636f:	83 ce 0a             	or     $0xa,%esi
80106372:	89 f2                	mov    %esi,%edx
80106374:	88 97 ad 33 11 80    	mov    %dl,-0x7feecc53(%edi)
8010637a:	89 de                	mov    %ebx,%esi
8010637c:	83 ce 1a             	or     $0x1a,%esi
8010637f:	89 f2                	mov    %esi,%edx
80106381:	88 97 ad 33 11 80    	mov    %dl,-0x7feecc53(%edi)
80106387:	83 cb 7a             	or     $0x7a,%ebx
8010638a:	88 9f ad 33 11 80    	mov    %bl,-0x7feecc53(%edi)
80106390:	c6 87 ad 33 11 80 fa 	movb   $0xfa,-0x7feecc53(%edi)
80106397:	0f b6 9f ae 33 11 80 	movzbl -0x7feecc52(%edi),%ebx
8010639e:	83 cb 0f             	or     $0xf,%ebx
801063a1:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
801063a7:	89 de                	mov    %ebx,%esi
801063a9:	83 e6 ef             	and    $0xffffffef,%esi
801063ac:	89 f2                	mov    %esi,%edx
801063ae:	88 97 ae 33 11 80    	mov    %dl,-0x7feecc52(%edi)
801063b4:	83 e3 cf             	and    $0xffffffcf,%ebx
801063b7:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
801063bd:	89 de                	mov    %ebx,%esi
801063bf:	83 ce 40             	or     $0x40,%esi
801063c2:	89 f2                	mov    %esi,%edx
801063c4:	88 97 ae 33 11 80    	mov    %dl,-0x7feecc52(%edi)
801063ca:	83 cb c0             	or     $0xffffffc0,%ebx
801063cd:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
801063d3:	c6 87 af 33 11 80 00 	movb   $0x0,-0x7feecc51(%edi)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801063da:	66 c7 87 b0 33 11 80 	movw   $0xffff,-0x7feecc50(%edi)
801063e1:	ff ff 
801063e3:	66 c7 87 b2 33 11 80 	movw   $0x0,-0x7feecc4e(%edi)
801063ea:	00 00 
801063ec:	c6 87 b4 33 11 80 00 	movb   $0x0,-0x7feecc4c(%edi)
801063f3:	0f b6 9f b5 33 11 80 	movzbl -0x7feecc4b(%edi),%ebx
801063fa:	83 e3 f0             	and    $0xfffffff0,%ebx
801063fd:	89 de                	mov    %ebx,%esi
801063ff:	83 ce 02             	or     $0x2,%esi
80106402:	89 f2                	mov    %esi,%edx
80106404:	88 97 b5 33 11 80    	mov    %dl,-0x7feecc4b(%edi)
8010640a:	89 de                	mov    %ebx,%esi
8010640c:	83 ce 12             	or     $0x12,%esi
8010640f:	89 f2                	mov    %esi,%edx
80106411:	88 97 b5 33 11 80    	mov    %dl,-0x7feecc4b(%edi)
80106417:	83 cb 72             	or     $0x72,%ebx
8010641a:	88 9f b5 33 11 80    	mov    %bl,-0x7feecc4b(%edi)
80106420:	c6 87 b5 33 11 80 f2 	movb   $0xf2,-0x7feecc4b(%edi)
80106427:	0f b6 9f b6 33 11 80 	movzbl -0x7feecc4a(%edi),%ebx
8010642e:	83 cb 0f             	or     $0xf,%ebx
80106431:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
80106437:	89 de                	mov    %ebx,%esi
80106439:	83 e6 ef             	and    $0xffffffef,%esi
8010643c:	89 f2                	mov    %esi,%edx
8010643e:	88 97 b6 33 11 80    	mov    %dl,-0x7feecc4a(%edi)
80106444:	83 e3 cf             	and    $0xffffffcf,%ebx
80106447:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
8010644d:	89 de                	mov    %ebx,%esi
8010644f:	83 ce 40             	or     $0x40,%esi
80106452:	89 f2                	mov    %esi,%edx
80106454:	88 97 b6 33 11 80    	mov    %dl,-0x7feecc4a(%edi)
8010645a:	83 cb c0             	or     $0xffffffc0,%ebx
8010645d:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
80106463:	c6 87 b7 33 11 80 00 	movb   $0x0,-0x7feecc49(%edi)
  lgdt(c->gdt, sizeof(c->gdt));
8010646a:	8d 97 90 33 11 80    	lea    -0x7feecc70(%edi),%edx
  pd[0] = size-1;
80106470:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106476:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
8010647a:	c1 ea 10             	shr    $0x10,%edx
8010647d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106481:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106484:	0f 01 10             	lgdtl  (%eax)
}
80106487:	83 c4 1c             	add    $0x1c,%esp
8010648a:	5b                   	pop    %ebx
8010648b:	5e                   	pop    %esi
8010648c:	5f                   	pop    %edi
8010648d:	5d                   	pop    %ebp
8010648e:	c3                   	ret    

8010648f <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010648f:	a1 04 62 11 80       	mov    0x80116204,%eax
80106494:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106499:	0f 22 d8             	mov    %eax,%cr3
}
8010649c:	c3                   	ret    

8010649d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010649d:	55                   	push   %ebp
8010649e:	89 e5                	mov    %esp,%ebp
801064a0:	57                   	push   %edi
801064a1:	56                   	push   %esi
801064a2:	53                   	push   %ebx
801064a3:	83 ec 1c             	sub    $0x1c,%esp
801064a6:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801064a9:	85 f6                	test   %esi,%esi
801064ab:	0f 84 25 01 00 00    	je     801065d6 <switchuvm+0x139>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801064b1:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801064b5:	0f 84 28 01 00 00    	je     801065e3 <switchuvm+0x146>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801064bb:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801064bf:	0f 84 2b 01 00 00    	je     801065f0 <switchuvm+0x153>
    panic("switchuvm: no pgdir");

  pushcli();
801064c5:	e8 56 d9 ff ff       	call   80103e20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801064ca:	e8 83 cd ff ff       	call   80103252 <mycpu>
801064cf:	89 c3                	mov    %eax,%ebx
801064d1:	e8 7c cd ff ff       	call   80103252 <mycpu>
801064d6:	8d 78 08             	lea    0x8(%eax),%edi
801064d9:	e8 74 cd ff ff       	call   80103252 <mycpu>
801064de:	83 c0 08             	add    $0x8,%eax
801064e1:	c1 e8 10             	shr    $0x10,%eax
801064e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064e7:	e8 66 cd ff ff       	call   80103252 <mycpu>
801064ec:	83 c0 08             	add    $0x8,%eax
801064ef:	c1 e8 18             	shr    $0x18,%eax
801064f2:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801064f9:	67 00 
801064fb:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106502:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80106506:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010650c:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80106513:	83 e2 f0             	and    $0xfffffff0,%edx
80106516:	89 d1                	mov    %edx,%ecx
80106518:	83 c9 09             	or     $0x9,%ecx
8010651b:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
80106521:	83 ca 19             	or     $0x19,%edx
80106524:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010652a:	83 e2 9f             	and    $0xffffff9f,%edx
8010652d:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106533:	83 ca 80             	or     $0xffffff80,%edx
80106536:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010653c:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80106543:	89 d1                	mov    %edx,%ecx
80106545:	83 e1 f0             	and    $0xfffffff0,%ecx
80106548:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010654e:	89 d1                	mov    %edx,%ecx
80106550:	83 e1 e0             	and    $0xffffffe0,%ecx
80106553:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106559:	83 e2 c0             	and    $0xffffffc0,%edx
8010655c:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106562:	83 ca 40             	or     $0x40,%edx
80106565:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010656b:	83 e2 7f             	and    $0x7f,%edx
8010656e:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106574:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010657a:	e8 d3 cc ff ff       	call   80103252 <mycpu>
8010657f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80106586:	83 e2 ef             	and    $0xffffffef,%edx
80106589:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010658f:	e8 be cc ff ff       	call   80103252 <mycpu>
80106594:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010659a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010659d:	e8 b0 cc ff ff       	call   80103252 <mycpu>
801065a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801065ab:	e8 a2 cc ff ff       	call   80103252 <mycpu>
801065b0:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801065b6:	b8 28 00 00 00       	mov    $0x28,%eax
801065bb:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801065be:	8b 46 04             	mov    0x4(%esi),%eax
801065c1:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065c6:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801065c9:	e8 8e d8 ff ff       	call   80103e5c <popcli>
}
801065ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d1:	5b                   	pop    %ebx
801065d2:	5e                   	pop    %esi
801065d3:	5f                   	pop    %edi
801065d4:	5d                   	pop    %ebp
801065d5:	c3                   	ret    
    panic("switchuvm: no process");
801065d6:	83 ec 0c             	sub    $0xc,%esp
801065d9:	68 6e 75 10 80       	push   $0x8010756e
801065de:	e8 a5 9d ff ff       	call   80100388 <panic>
    panic("switchuvm: no kstack");
801065e3:	83 ec 0c             	sub    $0xc,%esp
801065e6:	68 84 75 10 80       	push   $0x80107584
801065eb:	e8 98 9d ff ff       	call   80100388 <panic>
    panic("switchuvm: no pgdir");
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	68 99 75 10 80       	push   $0x80107599
801065f8:	e8 8b 9d ff ff       	call   80100388 <panic>

801065fd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801065fd:	55                   	push   %ebp
801065fe:	89 e5                	mov    %esp,%ebp
80106600:	56                   	push   %esi
80106601:	53                   	push   %ebx
80106602:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106605:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010660b:	77 4c                	ja     80106659 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
8010660d:	e8 87 bb ff ff       	call   80102199 <kalloc>
80106612:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106614:	83 ec 04             	sub    $0x4,%esp
80106617:	68 00 10 00 00       	push   $0x1000
8010661c:	6a 00                	push   $0x0
8010661e:	50                   	push   %eax
8010661f:	e8 fb d9 ff ff       	call   8010401f <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106624:	83 c4 08             	add    $0x8,%esp
80106627:	6a 06                	push   $0x6
80106629:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010662f:	50                   	push   %eax
80106630:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106635:	ba 00 00 00 00       	mov    $0x0,%edx
8010663a:	8b 45 08             	mov    0x8(%ebp),%eax
8010663d:	e8 62 fb ff ff       	call   801061a4 <mappages>
  memmove(mem, init, sz);
80106642:	83 c4 0c             	add    $0xc,%esp
80106645:	56                   	push   %esi
80106646:	ff 75 0c             	push   0xc(%ebp)
80106649:	53                   	push   %ebx
8010664a:	e8 48 da ff ff       	call   80104097 <memmove>
}
8010664f:	83 c4 10             	add    $0x10,%esp
80106652:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106655:	5b                   	pop    %ebx
80106656:	5e                   	pop    %esi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret    
    panic("inituvm: more than a page");
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 ad 75 10 80       	push   $0x801075ad
80106661:	e8 22 9d ff ff       	call   80100388 <panic>

80106666 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106666:	55                   	push   %ebp
80106667:	89 e5                	mov    %esp,%ebp
80106669:	57                   	push   %edi
8010666a:	56                   	push   %esi
8010666b:	53                   	push   %ebx
8010666c:	83 ec 0c             	sub    $0xc,%esp
8010666f:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106672:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106675:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010667b:	74 3c                	je     801066b9 <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
8010667d:	83 ec 0c             	sub    $0xc,%esp
80106680:	68 68 76 10 80       	push   $0x80107668
80106685:	e8 fe 9c ff ff       	call   80100388 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	68 c7 75 10 80       	push   $0x801075c7
80106692:	e8 f1 9c ff ff       	call   80100388 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106697:	05 00 00 00 80       	add    $0x80000000,%eax
8010669c:	56                   	push   %esi
8010669d:	89 da                	mov    %ebx,%edx
8010669f:	03 55 14             	add    0x14(%ebp),%edx
801066a2:	52                   	push   %edx
801066a3:	50                   	push   %eax
801066a4:	ff 75 10             	push   0x10(%ebp)
801066a7:	e8 6f b1 ff ff       	call   8010181b <readi>
801066ac:	83 c4 10             	add    $0x10,%esp
801066af:	39 f0                	cmp    %esi,%eax
801066b1:	75 47                	jne    801066fa <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
801066b3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066b9:	39 fb                	cmp    %edi,%ebx
801066bb:	73 30                	jae    801066ed <loaduvm+0x87>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801066bd:	89 da                	mov    %ebx,%edx
801066bf:	03 55 0c             	add    0xc(%ebp),%edx
801066c2:	b9 00 00 00 00       	mov    $0x0,%ecx
801066c7:	8b 45 08             	mov    0x8(%ebp),%eax
801066ca:	e8 64 fa ff ff       	call   80106133 <walkpgdir>
801066cf:	85 c0                	test   %eax,%eax
801066d1:	74 b7                	je     8010668a <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
801066d3:	8b 00                	mov    (%eax),%eax
801066d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801066da:	89 fe                	mov    %edi,%esi
801066dc:	29 de                	sub    %ebx,%esi
801066de:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066e4:	76 b1                	jbe    80106697 <loaduvm+0x31>
      n = PGSIZE;
801066e6:	be 00 10 00 00       	mov    $0x1000,%esi
801066eb:	eb aa                	jmp    80106697 <loaduvm+0x31>
      return -1;
  }
  return 0;
801066ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f5:	5b                   	pop    %ebx
801066f6:	5e                   	pop    %esi
801066f7:	5f                   	pop    %edi
801066f8:	5d                   	pop    %ebp
801066f9:	c3                   	ret    
      return -1;
801066fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ff:	eb f1                	jmp    801066f2 <loaduvm+0x8c>

80106701 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106701:	55                   	push   %ebp
80106702:	89 e5                	mov    %esp,%ebp
80106704:	57                   	push   %edi
80106705:	56                   	push   %esi
80106706:	53                   	push   %ebx
80106707:	83 ec 0c             	sub    $0xc,%esp
8010670a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010670d:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106710:	73 11                	jae    80106723 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
80106712:	8b 45 10             	mov    0x10(%ebp),%eax
80106715:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010671b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106721:	eb 19                	jmp    8010673c <deallocuvm+0x3b>
    return oldsz;
80106723:	89 f8                	mov    %edi,%eax
80106725:	eb 64                	jmp    8010678b <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106727:	c1 eb 16             	shr    $0x16,%ebx
8010672a:	83 c3 01             	add    $0x1,%ebx
8010672d:	c1 e3 16             	shl    $0x16,%ebx
80106730:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106736:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010673c:	39 fb                	cmp    %edi,%ebx
8010673e:	73 48                	jae    80106788 <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106740:	b9 00 00 00 00       	mov    $0x0,%ecx
80106745:	89 da                	mov    %ebx,%edx
80106747:	8b 45 08             	mov    0x8(%ebp),%eax
8010674a:	e8 e4 f9 ff ff       	call   80106133 <walkpgdir>
8010674f:	89 c6                	mov    %eax,%esi
    if(!pte)
80106751:	85 c0                	test   %eax,%eax
80106753:	74 d2                	je     80106727 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
80106755:	8b 00                	mov    (%eax),%eax
80106757:	a8 01                	test   $0x1,%al
80106759:	74 db                	je     80106736 <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010675b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106760:	74 19                	je     8010677b <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
80106762:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106767:	83 ec 0c             	sub    $0xc,%esp
8010676a:	50                   	push   %eax
8010676b:	e8 12 b9 ff ff       	call   80102082 <kfree>
      *pte = 0;
80106770:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106776:	83 c4 10             	add    $0x10,%esp
80106779:	eb bb                	jmp    80106736 <deallocuvm+0x35>
        panic("kfree");
8010677b:	83 ec 0c             	sub    $0xc,%esp
8010677e:	68 26 6e 10 80       	push   $0x80106e26
80106783:	e8 00 9c ff ff       	call   80100388 <panic>
    }
  }
  return newsz;
80106788:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010678b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678e:	5b                   	pop    %ebx
8010678f:	5e                   	pop    %esi
80106790:	5f                   	pop    %edi
80106791:	5d                   	pop    %ebp
80106792:	c3                   	ret    

80106793 <allocuvm>:
{
80106793:	55                   	push   %ebp
80106794:	89 e5                	mov    %esp,%ebp
80106796:	57                   	push   %edi
80106797:	56                   	push   %esi
80106798:	53                   	push   %ebx
80106799:	83 ec 1c             	sub    $0x1c,%esp
8010679c:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010679f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801067a2:	85 ff                	test   %edi,%edi
801067a4:	0f 88 c1 00 00 00    	js     8010686b <allocuvm+0xd8>
  if(newsz < oldsz)
801067aa:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801067ad:	72 5c                	jb     8010680b <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
801067af:	8b 45 0c             	mov    0xc(%ebp),%eax
801067b2:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801067b8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801067be:	39 fe                	cmp    %edi,%esi
801067c0:	0f 83 ac 00 00 00    	jae    80106872 <allocuvm+0xdf>
    mem = kalloc();
801067c6:	e8 ce b9 ff ff       	call   80102199 <kalloc>
801067cb:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801067cd:	85 c0                	test   %eax,%eax
801067cf:	74 42                	je     80106813 <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
801067d1:	83 ec 04             	sub    $0x4,%esp
801067d4:	68 00 10 00 00       	push   $0x1000
801067d9:	6a 00                	push   $0x0
801067db:	50                   	push   %eax
801067dc:	e8 3e d8 ff ff       	call   8010401f <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801067e1:	83 c4 08             	add    $0x8,%esp
801067e4:	6a 06                	push   $0x6
801067e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067ec:	50                   	push   %eax
801067ed:	b9 00 10 00 00       	mov    $0x1000,%ecx
801067f2:	89 f2                	mov    %esi,%edx
801067f4:	8b 45 08             	mov    0x8(%ebp),%eax
801067f7:	e8 a8 f9 ff ff       	call   801061a4 <mappages>
801067fc:	83 c4 10             	add    $0x10,%esp
801067ff:	85 c0                	test   %eax,%eax
80106801:	78 38                	js     8010683b <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106803:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106809:	eb b3                	jmp    801067be <allocuvm+0x2b>
    return oldsz;
8010680b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010680e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106811:	eb 5f                	jmp    80106872 <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
80106813:	83 ec 0c             	sub    $0xc,%esp
80106816:	68 e5 75 10 80       	push   $0x801075e5
8010681b:	e8 27 9e ff ff       	call   80100647 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106820:	83 c4 0c             	add    $0xc,%esp
80106823:	ff 75 0c             	push   0xc(%ebp)
80106826:	57                   	push   %edi
80106827:	ff 75 08             	push   0x8(%ebp)
8010682a:	e8 d2 fe ff ff       	call   80106701 <deallocuvm>
      return 0;
8010682f:	83 c4 10             	add    $0x10,%esp
80106832:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106839:	eb 37                	jmp    80106872 <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
8010683b:	83 ec 0c             	sub    $0xc,%esp
8010683e:	68 fd 75 10 80       	push   $0x801075fd
80106843:	e8 ff 9d ff ff       	call   80100647 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106848:	83 c4 0c             	add    $0xc,%esp
8010684b:	ff 75 0c             	push   0xc(%ebp)
8010684e:	57                   	push   %edi
8010684f:	ff 75 08             	push   0x8(%ebp)
80106852:	e8 aa fe ff ff       	call   80106701 <deallocuvm>
      kfree(mem);
80106857:	89 1c 24             	mov    %ebx,(%esp)
8010685a:	e8 23 b8 ff ff       	call   80102082 <kfree>
      return 0;
8010685f:	83 c4 10             	add    $0x10,%esp
80106862:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106869:	eb 07                	jmp    80106872 <allocuvm+0xdf>
    return 0;
8010686b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106875:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106878:	5b                   	pop    %ebx
80106879:	5e                   	pop    %esi
8010687a:	5f                   	pop    %edi
8010687b:	5d                   	pop    %ebp
8010687c:	c3                   	ret    

8010687d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010687d:	55                   	push   %ebp
8010687e:	89 e5                	mov    %esp,%ebp
80106880:	56                   	push   %esi
80106881:	53                   	push   %ebx
80106882:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106885:	85 f6                	test   %esi,%esi
80106887:	74 1a                	je     801068a3 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106889:	83 ec 04             	sub    $0x4,%esp
8010688c:	6a 00                	push   $0x0
8010688e:	68 00 00 00 80       	push   $0x80000000
80106893:	56                   	push   %esi
80106894:	e8 68 fe ff ff       	call   80106701 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80106899:	83 c4 10             	add    $0x10,%esp
8010689c:	bb 00 00 00 00       	mov    $0x0,%ebx
801068a1:	eb 10                	jmp    801068b3 <freevm+0x36>
    panic("freevm: no pgdir");
801068a3:	83 ec 0c             	sub    $0xc,%esp
801068a6:	68 19 76 10 80       	push   $0x80107619
801068ab:	e8 d8 9a ff ff       	call   80100388 <panic>
  for(i = 0; i < NPDENTRIES; i++){
801068b0:	83 c3 01             	add    $0x1,%ebx
801068b3:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801068b9:	77 1f                	ja     801068da <freevm+0x5d>
    if(pgdir[i] & PTE_P){
801068bb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801068be:	a8 01                	test   $0x1,%al
801068c0:	74 ee                	je     801068b0 <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801068c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068c7:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801068cc:	83 ec 0c             	sub    $0xc,%esp
801068cf:	50                   	push   %eax
801068d0:	e8 ad b7 ff ff       	call   80102082 <kfree>
801068d5:	83 c4 10             	add    $0x10,%esp
801068d8:	eb d6                	jmp    801068b0 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801068da:	83 ec 0c             	sub    $0xc,%esp
801068dd:	56                   	push   %esi
801068de:	e8 9f b7 ff ff       	call   80102082 <kfree>
}
801068e3:	83 c4 10             	add    $0x10,%esp
801068e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068e9:	5b                   	pop    %ebx
801068ea:	5e                   	pop    %esi
801068eb:	5d                   	pop    %ebp
801068ec:	c3                   	ret    

801068ed <setupkvm>:
{
801068ed:	55                   	push   %ebp
801068ee:	89 e5                	mov    %esp,%ebp
801068f0:	56                   	push   %esi
801068f1:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801068f2:	e8 a2 b8 ff ff       	call   80102199 <kalloc>
801068f7:	89 c6                	mov    %eax,%esi
801068f9:	85 c0                	test   %eax,%eax
801068fb:	74 55                	je     80106952 <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
801068fd:	83 ec 04             	sub    $0x4,%esp
80106900:	68 00 10 00 00       	push   $0x1000
80106905:	6a 00                	push   $0x0
80106907:	50                   	push   %eax
80106908:	e8 12 d7 ff ff       	call   8010401f <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010690d:	83 c4 10             	add    $0x10,%esp
80106910:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106915:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010691b:	73 35                	jae    80106952 <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
8010691d:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106920:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106923:	29 c1                	sub    %eax,%ecx
80106925:	83 ec 08             	sub    $0x8,%esp
80106928:	ff 73 0c             	push   0xc(%ebx)
8010692b:	50                   	push   %eax
8010692c:	8b 13                	mov    (%ebx),%edx
8010692e:	89 f0                	mov    %esi,%eax
80106930:	e8 6f f8 ff ff       	call   801061a4 <mappages>
80106935:	83 c4 10             	add    $0x10,%esp
80106938:	85 c0                	test   %eax,%eax
8010693a:	78 05                	js     80106941 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010693c:	83 c3 10             	add    $0x10,%ebx
8010693f:	eb d4                	jmp    80106915 <setupkvm+0x28>
      freevm(pgdir);
80106941:	83 ec 0c             	sub    $0xc,%esp
80106944:	56                   	push   %esi
80106945:	e8 33 ff ff ff       	call   8010687d <freevm>
      return 0;
8010694a:	83 c4 10             	add    $0x10,%esp
8010694d:	be 00 00 00 00       	mov    $0x0,%esi
}
80106952:	89 f0                	mov    %esi,%eax
80106954:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106957:	5b                   	pop    %ebx
80106958:	5e                   	pop    %esi
80106959:	5d                   	pop    %ebp
8010695a:	c3                   	ret    

8010695b <kvmalloc>:
{
8010695b:	55                   	push   %ebp
8010695c:	89 e5                	mov    %esp,%ebp
8010695e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106961:	e8 87 ff ff ff       	call   801068ed <setupkvm>
80106966:	a3 04 62 11 80       	mov    %eax,0x80116204
  switchkvm();
8010696b:	e8 1f fb ff ff       	call   8010648f <switchkvm>
}
80106970:	c9                   	leave  
80106971:	c3                   	ret    

80106972 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106972:	55                   	push   %ebp
80106973:	89 e5                	mov    %esp,%ebp
80106975:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106978:	b9 00 00 00 00       	mov    $0x0,%ecx
8010697d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106980:	8b 45 08             	mov    0x8(%ebp),%eax
80106983:	e8 ab f7 ff ff       	call   80106133 <walkpgdir>
  if(pte == 0)
80106988:	85 c0                	test   %eax,%eax
8010698a:	74 05                	je     80106991 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010698c:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010698f:	c9                   	leave  
80106990:	c3                   	ret    
    panic("clearpteu");
80106991:	83 ec 0c             	sub    $0xc,%esp
80106994:	68 2a 76 10 80       	push   $0x8010762a
80106999:	e8 ea 99 ff ff       	call   80100388 <panic>

8010699e <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010699e:	55                   	push   %ebp
8010699f:	89 e5                	mov    %esp,%ebp
801069a1:	57                   	push   %edi
801069a2:	56                   	push   %esi
801069a3:	53                   	push   %ebx
801069a4:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801069a7:	e8 41 ff ff ff       	call   801068ed <setupkvm>
801069ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069af:	85 c0                	test   %eax,%eax
801069b1:	0f 84 c4 00 00 00    	je     80106a7b <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801069b7:	bf 00 00 00 00       	mov    $0x0,%edi
801069bc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069bf:	0f 83 b6 00 00 00    	jae    80106a7b <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801069c5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801069c8:	b9 00 00 00 00       	mov    $0x0,%ecx
801069cd:	89 fa                	mov    %edi,%edx
801069cf:	8b 45 08             	mov    0x8(%ebp),%eax
801069d2:	e8 5c f7 ff ff       	call   80106133 <walkpgdir>
801069d7:	85 c0                	test   %eax,%eax
801069d9:	74 65                	je     80106a40 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801069db:	8b 00                	mov    (%eax),%eax
801069dd:	a8 01                	test   $0x1,%al
801069df:	74 6c                	je     80106a4d <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801069e1:	89 c6                	mov    %eax,%esi
801069e3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801069e9:	25 ff 0f 00 00       	and    $0xfff,%eax
801069ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801069f1:	e8 a3 b7 ff ff       	call   80102199 <kalloc>
801069f6:	89 c3                	mov    %eax,%ebx
801069f8:	85 c0                	test   %eax,%eax
801069fa:	74 6a                	je     80106a66 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801069fc:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106a02:	83 ec 04             	sub    $0x4,%esp
80106a05:	68 00 10 00 00       	push   $0x1000
80106a0a:	56                   	push   %esi
80106a0b:	50                   	push   %eax
80106a0c:	e8 86 d6 ff ff       	call   80104097 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106a11:	83 c4 08             	add    $0x8,%esp
80106a14:	ff 75 e0             	push   -0x20(%ebp)
80106a17:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a1d:	50                   	push   %eax
80106a1e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a29:	e8 76 f7 ff ff       	call   801061a4 <mappages>
80106a2e:	83 c4 10             	add    $0x10,%esp
80106a31:	85 c0                	test   %eax,%eax
80106a33:	78 25                	js     80106a5a <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106a35:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106a3b:	e9 7c ff ff ff       	jmp    801069bc <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
80106a40:	83 ec 0c             	sub    $0xc,%esp
80106a43:	68 34 76 10 80       	push   $0x80107634
80106a48:	e8 3b 99 ff ff       	call   80100388 <panic>
      panic("copyuvm: page not present");
80106a4d:	83 ec 0c             	sub    $0xc,%esp
80106a50:	68 4e 76 10 80       	push   $0x8010764e
80106a55:	e8 2e 99 ff ff       	call   80100388 <panic>
      kfree(mem);
80106a5a:	83 ec 0c             	sub    $0xc,%esp
80106a5d:	53                   	push   %ebx
80106a5e:	e8 1f b6 ff ff       	call   80102082 <kfree>
      goto bad;
80106a63:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
80106a66:	83 ec 0c             	sub    $0xc,%esp
80106a69:	ff 75 dc             	push   -0x24(%ebp)
80106a6c:	e8 0c fe ff ff       	call   8010687d <freevm>
  return 0;
80106a71:	83 c4 10             	add    $0x10,%esp
80106a74:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a81:	5b                   	pop    %ebx
80106a82:	5e                   	pop    %esi
80106a83:	5f                   	pop    %edi
80106a84:	5d                   	pop    %ebp
80106a85:	c3                   	ret    

80106a86 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106a86:	55                   	push   %ebp
80106a87:	89 e5                	mov    %esp,%ebp
80106a89:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a8c:	b9 00 00 00 00       	mov    $0x0,%ecx
80106a91:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a94:	8b 45 08             	mov    0x8(%ebp),%eax
80106a97:	e8 97 f6 ff ff       	call   80106133 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106a9c:	8b 00                	mov    (%eax),%eax
80106a9e:	a8 01                	test   $0x1,%al
80106aa0:	74 10                	je     80106ab2 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106aa2:	a8 04                	test   $0x4,%al
80106aa4:	74 13                	je     80106ab9 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106aa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aab:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106ab0:	c9                   	leave  
80106ab1:	c3                   	ret    
    return 0;
80106ab2:	b8 00 00 00 00       	mov    $0x0,%eax
80106ab7:	eb f7                	jmp    80106ab0 <uva2ka+0x2a>
    return 0;
80106ab9:	b8 00 00 00 00       	mov    $0x0,%eax
80106abe:	eb f0                	jmp    80106ab0 <uva2ka+0x2a>

80106ac0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 0c             	sub    $0xc,%esp
80106ac9:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106acc:	eb 25                	jmp    80106af3 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ace:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ad1:	29 f2                	sub    %esi,%edx
80106ad3:	01 d0                	add    %edx,%eax
80106ad5:	83 ec 04             	sub    $0x4,%esp
80106ad8:	53                   	push   %ebx
80106ad9:	ff 75 10             	push   0x10(%ebp)
80106adc:	50                   	push   %eax
80106add:	e8 b5 d5 ff ff       	call   80104097 <memmove>
    len -= n;
80106ae2:	29 df                	sub    %ebx,%edi
    buf += n;
80106ae4:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106ae7:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106aed:	89 45 0c             	mov    %eax,0xc(%ebp)
80106af0:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106af3:	85 ff                	test   %edi,%edi
80106af5:	74 2f                	je     80106b26 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106af7:	8b 75 0c             	mov    0xc(%ebp),%esi
80106afa:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106b00:	83 ec 08             	sub    $0x8,%esp
80106b03:	56                   	push   %esi
80106b04:	ff 75 08             	push   0x8(%ebp)
80106b07:	e8 7a ff ff ff       	call   80106a86 <uva2ka>
    if(pa0 == 0)
80106b0c:	83 c4 10             	add    $0x10,%esp
80106b0f:	85 c0                	test   %eax,%eax
80106b11:	74 20                	je     80106b33 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106b13:	89 f3                	mov    %esi,%ebx
80106b15:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106b18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106b1e:	39 df                	cmp    %ebx,%edi
80106b20:	73 ac                	jae    80106ace <copyout+0xe>
      n = len;
80106b22:	89 fb                	mov    %edi,%ebx
80106b24:	eb a8                	jmp    80106ace <copyout+0xe>
  }
  return 0;
80106b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b2e:	5b                   	pop    %ebx
80106b2f:	5e                   	pop    %esi
80106b30:	5f                   	pop    %edi
80106b31:	5d                   	pop    %ebp
80106b32:	c3                   	ret    
      return -1;
80106b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b38:	eb f1                	jmp    80106b2b <copyout+0x6b>

80106b3a <retNumpp>:

// int retNumvp(){
//   return 0;
// }

int retNumpp(){
80106b3a:	55                   	push   %ebp
80106b3b:	89 e5                	mov    %esp,%ebp
80106b3d:	57                   	push   %edi
80106b3e:	56                   	push   %esi
80106b3f:	53                   	push   %ebx
80106b40:	83 ec 1c             	sub    $0x1c,%esp
  int ii=0;
  pde_t *pgdir=myproc()->pgdir;
80106b43:	e8 81 c7 ff ff       	call   801032c9 <myproc>
80106b48:	8b 40 04             	mov    0x4(%eax),%eax
80106b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  k=kmap;
  // void *va = k->virt;
  uint size = k->phys_end - k->phys_start;
  uint pa = k->phys_start;
  // int perm
  a = (char*)PGROUNDDOWN((uint)pa);
80106b4e:	8b 1d 24 a4 10 80    	mov    0x8010a424,%ebx
80106b54:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80106b5a:	a1 28 a4 10 80       	mov    0x8010a428,%eax
80106b5f:	8d 70 ff             	lea    -0x1(%eax),%esi
80106b62:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  int ii=0;
80106b68:	bf 00 00 00 00       	mov    $0x0,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80106b6d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106b72:	89 da                	mov    %ebx,%edx
80106b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b77:	e8 b7 f5 ff ff       	call   80106133 <walkpgdir>
80106b7c:	85 c0                	test   %eax,%eax
80106b7e:	74 14                	je     80106b94 <retNumpp+0x5a>
      return -1;
    // if(*pte & PTE_P)
      // panic("remap");
    // *pte = pa | perm | PTE_P;
    if(a == last)
80106b80:	39 f3                	cmp    %esi,%ebx
80106b82:	74 15                	je     80106b99 <retNumpp+0x5f>
      break;
    a += PGSIZE;
80106b84:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
    if((PTE_P & *pte)!=0){
80106b8a:	f6 00 01             	testb  $0x1,(%eax)
80106b8d:	74 de                	je     80106b6d <retNumpp+0x33>
      ii++;
80106b8f:	83 c7 01             	add    $0x1,%edi
80106b92:	eb d9                	jmp    80106b6d <retNumpp+0x33>
      return -1;
80106b94:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    }
  }

  return ii;
80106b99:	89 f8                	mov    %edi,%eax
80106b9b:	83 c4 1c             	add    $0x1c,%esp
80106b9e:	5b                   	pop    %ebx
80106b9f:	5e                   	pop    %esi
80106ba0:	5f                   	pop    %edi
80106ba1:	5d                   	pop    %ebp
80106ba2:	c3                   	ret    
