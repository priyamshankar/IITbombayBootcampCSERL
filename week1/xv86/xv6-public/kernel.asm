
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
80100046:	e8 ca 3e 00 00       	call   80103f15 <acquire>

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
80100085:	e8 f0 3e 00 00       	call   80103f7a <release>
      acquiresleep(&b->lock);
8010008a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010008d:	89 04 24             	mov    %eax,(%esp)
80100090:	e8 63 3c 00 00       	call   80103cf8 <acquiresleep>
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
801000dc:	e8 99 3e 00 00       	call   80103f7a <release>
      acquiresleep(&b->lock);
801000e1:	8d 43 0c             	lea    0xc(%ebx),%eax
801000e4:	89 04 24             	mov    %eax,(%esp)
801000e7:	e8 0c 3c 00 00       	call   80103cf8 <acquiresleep>
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
801000fc:	68 40 6c 10 80       	push   $0x80106c40
80100101:	e8 82 02 00 00       	call   80100388 <panic>

80100106 <binit>:
{
80100106:	55                   	push   %ebp
80100107:	89 e5                	mov    %esp,%ebp
80100109:	53                   	push   %ebx
8010010a:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010010d:	68 51 6c 10 80       	push   $0x80106c51
80100112:	68 20 a5 10 80       	push   $0x8010a520
80100117:	e8 bd 3c 00 00       	call   80103dd9 <initlock>
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
80100152:	68 58 6c 10 80       	push   $0x80106c58
80100157:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015a:	50                   	push   %eax
8010015b:	e8 5f 3b 00 00       	call   80103cbf <initsleeplock>
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
801001c3:	e8 c0 3b 00 00       	call   80103d88 <holdingsleep>
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
801001e6:	68 5f 6c 10 80       	push   $0x80106c5f
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
801001ff:	e8 84 3b 00 00       	call   80103d88 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	0f 84 8c 00 00 00    	je     8010029b <brelse+0xab>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 32 3b 00 00       	call   80103d4a <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021f:	e8 f1 3c 00 00       	call   80103f15 <acquire>
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
8010028c:	e8 e9 3c 00 00       	call   80103f7a <release>
}
80100291:	83 c4 10             	add    $0x10,%esp
80100294:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100297:	5b                   	pop    %ebx
80100298:	5e                   	pop    %esi
80100299:	5d                   	pop    %ebp
8010029a:	c3                   	ret    
    panic("brelse");
8010029b:	83 ec 0c             	sub    $0xc,%esp
8010029e:	68 66 6c 10 80       	push   $0x80106c66
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
801002ca:	e8 46 3c 00 00       	call   80103f15 <acquire>
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
80100311:	e8 64 3c 00 00       	call   80103f7a <release>
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
80100371:	e8 04 3c 00 00       	call   80103f7a <release>
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
801003a3:	68 6d 6c 10 80       	push   $0x80106c6d
801003a8:	e8 9a 02 00 00       	call   80100647 <cprintf>
  cprintf(s);
801003ad:	83 c4 04             	add    $0x4,%esp
801003b0:	ff 75 08             	push   0x8(%ebp)
801003b3:	e8 8f 02 00 00       	call   80100647 <cprintf>
  cprintf("\n");
801003b8:	c7 04 24 97 76 10 80 	movl   $0x80107697,(%esp)
801003bf:	e8 83 02 00 00       	call   80100647 <cprintf>
  getcallerpcs(&s, pcs);
801003c4:	83 c4 08             	add    $0x8,%esp
801003c7:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003ca:	50                   	push   %eax
801003cb:	8d 45 08             	lea    0x8(%ebp),%eax
801003ce:	50                   	push   %eax
801003cf:	e8 20 3a 00 00       	call   80103df4 <getcallerpcs>
  for(i=0; i<10; i++)
801003d4:	83 c4 10             	add    $0x10,%esp
801003d7:	bb 00 00 00 00       	mov    $0x0,%ebx
801003dc:	eb 17                	jmp    801003f5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
801003de:	83 ec 08             	sub    $0x8,%esp
801003e1:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
801003e5:	68 81 6c 10 80       	push   $0x80106c81
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
801004d2:	68 85 6c 10 80       	push   $0x80106c85
801004d7:	e8 ac fe ff ff       	call   80100388 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004dc:	83 ec 04             	sub    $0x4,%esp
801004df:	68 60 0e 00 00       	push   $0xe60
801004e4:	68 a0 80 0b 80       	push   $0x800b80a0
801004e9:	68 00 80 0b 80       	push   $0x800b8000
801004ee:	e8 2f 3c 00 00       	call   80104122 <memmove>
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
8010050d:	e8 98 3b 00 00       	call   801040aa <memset>
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
8010053a:	e8 11 51 00 00       	call   80105650 <uartputc>
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
80100553:	e8 f8 50 00 00       	call   80105650 <uartputc>
80100558:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010055f:	e8 ec 50 00 00       	call   80105650 <uartputc>
80100564:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010056b:	e8 e0 50 00 00       	call   80105650 <uartputc>
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
801005a8:	0f b6 92 b0 6c 10 80 	movzbl -0x7fef9350(%edx),%edx
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
80100606:	e8 0a 39 00 00       	call   80103f15 <acquire>
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
8010062d:	e8 48 39 00 00       	call   80103f7a <release>
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
80100674:	e8 9c 38 00 00       	call   80103f15 <acquire>
80100679:	83 c4 10             	add    $0x10,%esp
8010067c:	eb de                	jmp    8010065c <cprintf+0x15>
    panic("null fmt");
8010067e:	83 ec 0c             	sub    $0xc,%esp
80100681:	68 9f 6c 10 80       	push   $0x80106c9f
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
8010070d:	bb 98 6c 10 80       	mov    $0x80106c98,%ebx
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
80100769:	e8 0c 38 00 00       	call   80103f7a <release>
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
80100784:	e8 8c 37 00 00       	call   80103f15 <acquire>
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
801008af:	e8 c6 36 00 00       	call   80103f7a <release>
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
801008d0:	68 a8 6c 10 80       	push   $0x80106ca8
801008d5:	68 20 f9 10 80       	push   $0x8010f920
801008da:	e8 fa 34 00 00       	call   80103dd9 <initlock>

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
8010099a:	68 c1 6c 10 80       	push   $0x80106cc1
8010099f:	e8 a3 fc ff ff       	call   80100647 <cprintf>
    return -1;
801009a4:	83 c4 10             	add    $0x10,%esp
801009a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ac:	eb dc                	jmp    8010098a <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
801009ae:	e8 c5 5f 00 00       	call   80106978 <setupkvm>
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
80100a42:	e8 d7 5d 00 00       	call   8010681e <allocuvm>
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
80100a74:	e8 78 5c 00 00       	call   801066f1 <loaduvm>
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
80100ab1:	e8 68 5d 00 00       	call   8010681e <allocuvm>
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
80100adc:	e8 27 5e 00 00       	call   80106908 <freevm>
80100ae1:	83 c4 10             	add    $0x10,%esp
80100ae4:	e9 83 fe ff ff       	jmp    8010096c <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ae9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100aef:	83 ec 08             	sub    $0x8,%esp
80100af2:	50                   	push   %eax
80100af3:	57                   	push   %edi
80100af4:	e8 04 5f 00 00       	call   801069fd <clearpteu>
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
80100b26:	e8 28 37 00 00       	call   80104253 <strlen>
80100b2b:	29 c6                	sub    %eax,%esi
80100b2d:	83 ee 01             	sub    $0x1,%esi
80100b30:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b33:	83 c4 04             	add    $0x4,%esp
80100b36:	ff 33                	push   (%ebx)
80100b38:	e8 16 37 00 00       	call   80104253 <strlen>
80100b3d:	83 c0 01             	add    $0x1,%eax
80100b40:	50                   	push   %eax
80100b41:	ff 33                	push   (%ebx)
80100b43:	56                   	push   %esi
80100b44:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b4a:	e8 fc 5f 00 00       	call   80106b4b <copyout>
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
80100baa:	e8 9c 5f 00 00       	call   80106b4b <copyout>
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
80100be7:	e8 2a 36 00 00       	call   80104216 <safestrcpy>
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
80100c15:	e8 0e 59 00 00       	call   80106528 <switchuvm>
  freevm(oldpgdir);
80100c1a:	89 1c 24             	mov    %ebx,(%esp)
80100c1d:	e8 e6 5c 00 00       	call   80106908 <freevm>
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
80100c49:	68 cd 6c 10 80       	push   $0x80106ccd
80100c4e:	68 c0 f9 10 80       	push   $0x8010f9c0
80100c53:	e8 81 31 00 00       	call   80103dd9 <initlock>
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
80100c69:	e8 a7 32 00 00       	call   80103f15 <acquire>
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
80100c98:	e8 dd 32 00 00       	call   80103f7a <release>
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
80100caf:	e8 c6 32 00 00       	call   80103f7a <release>
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
80100ccd:	e8 43 32 00 00       	call   80103f15 <acquire>
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
80100cea:	e8 8b 32 00 00       	call   80103f7a <release>
  return f;
}
80100cef:	89 d8                	mov    %ebx,%eax
80100cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf4:	c9                   	leave  
80100cf5:	c3                   	ret    
    panic("filedup");
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	68 d4 6c 10 80       	push   $0x80106cd4
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
80100d12:	e8 fe 31 00 00       	call   80103f15 <acquire>
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
80100d63:	e8 12 32 00 00       	call   80103f7a <release>

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
80100d95:	68 dc 6c 10 80       	push   $0x80106cdc
80100d9a:	e8 e9 f5 ff ff       	call   80100388 <panic>
    release(&ftable.lock);
80100d9f:	83 ec 0c             	sub    $0xc,%esp
80100da2:	68 c0 f9 10 80       	push   $0x8010f9c0
80100da7:	e8 ce 31 00 00       	call   80103f7a <release>
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
80100e84:	68 e6 6c 10 80       	push   $0x80106ce6
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
80100f4a:	68 ef 6c 10 80       	push   $0x80106cef
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
80100f71:	68 f5 6c 10 80       	push   $0x80106cf5
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
80100fc1:	e8 5c 31 00 00       	call   80104122 <memmove>
80100fc6:	83 c4 10             	add    $0x10,%esp
80100fc9:	eb 17                	jmp    80100fe2 <skipelem+0x60>
  else {
    memmove(name, s, len);
80100fcb:	83 ec 04             	sub    $0x4,%esp
80100fce:	57                   	push   %edi
80100fcf:	50                   	push   %eax
80100fd0:	56                   	push   %esi
80100fd1:	e8 4c 31 00 00       	call   80104122 <memmove>
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
80101019:	e8 8c 30 00 00       	call   801040aa <memset>
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
801010a8:	68 ff 6c 10 80       	push   $0x80106cff
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
80101162:	68 12 6d 10 80       	push   $0x80106d12
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
80101249:	68 28 6d 10 80       	push   $0x80106d28
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
80101266:	e8 aa 2c 00 00       	call   80103f15 <acquire>
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
801012ad:	e8 c8 2c 00 00       	call   80103f7a <release>
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
801012e6:	e8 8f 2c 00 00       	call   80103f7a <release>
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
801012fb:	68 3b 6d 10 80       	push   $0x80106d3b
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
80101327:	e8 f6 2d 00 00       	call   80104122 <memmove>
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
80101343:	68 4b 6d 10 80       	push   $0x80106d4b
80101348:	68 20 04 11 80       	push   $0x80110420
8010134d:	e8 87 2a 00 00       	call   80103dd9 <initlock>
  for(i = 0; i < NINODE; i++) {
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	bb 00 00 00 00       	mov    $0x0,%ebx
8010135a:	eb 1f                	jmp    8010137b <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010135c:	83 ec 08             	sub    $0x8,%esp
8010135f:	68 52 6d 10 80       	push   $0x80106d52
80101364:	69 c3 e0 00 00 00    	imul   $0xe0,%ebx,%eax
8010136a:	05 b0 04 11 80       	add    $0x801104b0,%eax
8010136f:	50                   	push   %eax
80101370:	e8 4a 29 00 00       	call   80103cbf <initsleeplock>
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
801013ba:	68 b8 6d 10 80       	push   $0x80106db8
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
80101430:	68 58 6d 10 80       	push   $0x80106d58
80101435:	e8 4e ef ff ff       	call   80100388 <panic>
      memset(dip, 0, sizeof(*dip));
8010143a:	83 ec 04             	sub    $0x4,%esp
8010143d:	6a 40                	push   $0x40
8010143f:	6a 00                	push   $0x0
80101441:	57                   	push   %edi
80101442:	e8 63 2c 00 00       	call   801040aa <memset>
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
801014e6:	e8 37 2c 00 00       	call   80104122 <memmove>
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
801015d2:	e8 3e 29 00 00       	call   80103f15 <acquire>
  ip->ref++;
801015d7:	8b 43 08             	mov    0x8(%ebx),%eax
801015da:	83 c0 01             	add    $0x1,%eax
801015dd:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015e0:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
801015e7:	e8 8e 29 00 00       	call   80103f7a <release>
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
8010160c:	e8 e7 26 00 00       	call   80103cf8 <acquiresleep>
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
80101627:	68 6a 6d 10 80       	push   $0x80106d6a
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
8010169e:	e8 7f 2a 00 00       	call   80104122 <memmove>
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
801016c9:	68 70 6d 10 80       	push   $0x80106d70
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
801016e6:	e8 9d 26 00 00       	call   80103d88 <holdingsleep>
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	85 c0                	test   %eax,%eax
801016f0:	74 19                	je     8010170b <iunlock+0x38>
801016f2:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016f6:	7e 13                	jle    8010170b <iunlock+0x38>
  releasesleep(&ip->lock);
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	56                   	push   %esi
801016fc:	e8 49 26 00 00       	call   80103d4a <releasesleep>
}
80101701:	83 c4 10             	add    $0x10,%esp
80101704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101707:	5b                   	pop    %ebx
80101708:	5e                   	pop    %esi
80101709:	5d                   	pop    %ebp
8010170a:	c3                   	ret    
    panic("iunlock");
8010170b:	83 ec 0c             	sub    $0xc,%esp
8010170e:	68 7f 6d 10 80       	push   $0x80106d7f
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
80101728:	e8 cb 25 00 00       	call   80103cf8 <acquiresleep>
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
80101747:	e8 fe 25 00 00       	call   80103d4a <releasesleep>
  acquire(&icache.lock);
8010174c:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
80101753:	e8 bd 27 00 00       	call   80103f15 <acquire>
  ip->ref--;
80101758:	8b 43 08             	mov    0x8(%ebx),%eax
8010175b:	83 e8 01             	sub    $0x1,%eax
8010175e:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101761:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
80101768:	e8 0d 28 00 00       	call   80103f7a <release>
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
80101780:	e8 90 27 00 00       	call   80103f15 <acquire>
    int r = ip->ref;
80101785:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101788:	c7 04 24 20 04 11 80 	movl   $0x80110420,(%esp)
8010178f:	e8 e6 27 00 00       	call   80103f7a <release>
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
801018de:	e8 3f 28 00 00       	call   80104122 <memmove>
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
801019ea:	e8 33 27 00 00       	call   80104122 <memmove>
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
80101a73:	e8 16 27 00 00       	call   8010418e <strncmp>
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
80101a9d:	68 87 6d 10 80       	push   $0x80106d87
80101aa2:	e8 e1 e8 ff ff       	call   80100388 <panic>
      panic("dirlookup read");
80101aa7:	83 ec 0c             	sub    $0xc,%esp
80101aaa:	68 99 6d 10 80       	push   $0x80106d99
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
80101c65:	68 a8 6d 10 80       	push   $0x80106da8
80101c6a:	e8 19 e7 ff ff       	call   80100388 <panic>
  strncpy(de.name, name, DIRSIZ);
80101c6f:	83 ec 04             	sub    $0x4,%esp
80101c72:	6a 0e                	push   $0xe
80101c74:	57                   	push   %edi
80101c75:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c78:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c7b:	50                   	push   %eax
80101c7c:	e8 4c 25 00 00       	call   801041cd <strncpy>
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
80101caa:	68 40 74 10 80       	push   $0x80107440
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
80101daf:	68 0b 6e 10 80       	push   $0x80106e0b
80101db4:	e8 cf e5 ff ff       	call   80100388 <panic>
    panic("incorrect blockno");
80101db9:	83 ec 0c             	sub    $0xc,%esp
80101dbc:	68 14 6e 10 80       	push   $0x80106e14
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
80101dd9:	68 26 6e 10 80       	push   $0x80106e26
80101dde:	68 a0 30 11 80       	push   $0x801130a0
80101de3:	e8 f1 1f 00 00       	call   80103dd9 <initlock>
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
80101e53:	e8 bd 20 00 00       	call   80103f15 <acquire>

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
80101ea3:	e8 d2 20 00 00       	call   80103f7a <release>
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
80101eba:	e8 bb 20 00 00       	call   80103f7a <release>
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
80101ef5:	e8 8e 1e 00 00       	call   80103d88 <holdingsleep>
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
80101f22:	e8 ee 1f 00 00       	call   80103f15 <acquire>

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
80101f3e:	68 2a 6e 10 80       	push   $0x80106e2a
80101f43:	e8 40 e4 ff ff       	call   80100388 <panic>
    panic("iderw: nothing to do");
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	68 40 6e 10 80       	push   $0x80106e40
80101f50:	e8 33 e4 ff ff       	call   80100388 <panic>
    panic("iderw: ide disk 1 not present");
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	68 55 6e 10 80       	push   $0x80106e55
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
80101fa4:	e8 d1 1f 00 00       	call   80103f7a <release>
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
80102018:	68 74 6e 10 80       	push   $0x80106e74
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
801020b4:	e8 f1 1f 00 00       	call   801040aa <memset>

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
801020e3:	68 a6 6e 10 80       	push   $0x80106ea6
801020e8:	e8 9b e2 ff ff       	call   80100388 <panic>
    acquire(&kmem.lock);
801020ed:	83 ec 0c             	sub    $0xc,%esp
801020f0:	68 40 31 11 80       	push   $0x80113140
801020f5:	e8 1b 1e 00 00       	call   80103f15 <acquire>
801020fa:	83 c4 10             	add    $0x10,%esp
801020fd:	eb c6                	jmp    801020c5 <kfree+0x43>
    release(&kmem.lock);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	68 40 31 11 80       	push   $0x80113140
80102107:	e8 6e 1e 00 00       	call   80103f7a <release>
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
8010214d:	68 ac 6e 10 80       	push   $0x80106eac
80102152:	68 40 31 11 80       	push   $0x80113140
80102157:	e8 7d 1c 00 00       	call   80103dd9 <initlock>
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
801021d2:	e8 3e 1d 00 00       	call   80103f15 <acquire>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	eb cd                	jmp    801021a9 <kalloc+0x10>
    release(&kmem.lock);
801021dc:	83 ec 0c             	sub    $0xc,%esp
801021df:	68 40 31 11 80       	push   $0x80113140
801021e4:	e8 91 1d 00 00       	call   80103f7a <release>
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
80102227:	0f b6 91 e0 6f 10 80 	movzbl -0x7fef9020(%ecx),%edx
8010222e:	0b 15 cc 31 11 80    	or     0x801131cc,%edx
80102234:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
  shift ^= togglecode[data];
8010223a:	0f b6 81 e0 6e 10 80 	movzbl -0x7fef9120(%ecx),%eax
80102241:	31 c2                	xor    %eax,%edx
80102243:	89 15 cc 31 11 80    	mov    %edx,0x801131cc
  c = charcode[shift & (CTL | SHIFT)][data];
80102249:	89 d0                	mov    %edx,%eax
8010224b:	83 e0 03             	and    $0x3,%eax
8010224e:	8b 04 85 c0 6e 10 80 	mov    -0x7fef9140(,%eax,4),%eax
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
80102287:	0f b6 81 e0 6f 10 80 	movzbl -0x7fef9020(%ecx),%eax
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
8010256e:	e8 7a 1b 00 00       	call   801040ed <memcmp>
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
801026d5:	e8 48 1a 00 00       	call   80104122 <memmove>
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
801027e0:	e8 3d 19 00 00       	call   80104122 <memmove>
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
8010284d:	68 e0 70 10 80       	push   $0x801070e0
80102852:	68 e0 31 11 80       	push   $0x801131e0
80102857:	e8 7d 15 00 00       	call   80103dd9 <initlock>
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
80102897:	e8 79 16 00 00       	call   80103f15 <acquire>
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
801028fc:	e8 79 16 00 00       	call   80103f7a <release>
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
80102912:	e8 fe 15 00 00       	call   80103f15 <acquire>
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
8010294c:	e8 29 16 00 00       	call   80103f7a <release>
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
80102960:	68 e4 70 10 80       	push   $0x801070e4
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
80102989:	e8 87 15 00 00       	call   80103f15 <acquire>
    log.committing = 0;
8010298e:	c7 05 70 32 11 80 00 	movl   $0x0,0x80113270
80102995:	00 00 00 
    wakeup(&log);
80102998:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
8010299f:	e8 51 0f 00 00       	call   801038f5 <wakeup>
    release(&log.lock);
801029a4:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
801029ab:	e8 ca 15 00 00       	call   80103f7a <release>
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
801029e7:	e8 29 15 00 00       	call   80103f15 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029ec:	83 c4 10             	add    $0x10,%esp
801029ef:	b8 00 00 00 00       	mov    $0x0,%eax
801029f4:	eb 1d                	jmp    80102a13 <log_write+0x5e>
    panic("too big a transaction");
801029f6:	83 ec 0c             	sub    $0xc,%esp
801029f9:	68 f3 70 10 80       	push   $0x801070f3
801029fe:	e8 85 d9 ff ff       	call   80100388 <panic>
    panic("log_write outside of trans");
80102a03:	83 ec 0c             	sub    $0xc,%esp
80102a06:	68 09 71 10 80       	push   $0x80107109
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
80102a42:	e8 33 15 00 00       	call   80103f7a <release>
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
80102a70:	e8 ad 16 00 00       	call   80104122 <memmove>

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
80102b01:	68 24 71 10 80       	push   $0x80107124
80102b06:	e8 3c db ff ff       	call   80100647 <cprintf>
  idtinit();       // load idt register
80102b0b:	e8 de 28 00 00       	call   801053ee <idtinit>
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
80102b2e:	e8 e7 39 00 00       	call   8010651a <switchkvm>
  seginit();
80102b33:	e8 6d 37 00 00       	call   801062a5 <seginit>
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
80102b62:	e8 7f 3e 00 00       	call   801069e6 <kvmalloc>
  mpinit();        // detect other processors
80102b67:	e8 c1 01 00 00       	call   80102d2d <mpinit>
  lapicinit();     // interrupt controller
80102b6c:	e8 d9 f7 ff ff       	call   8010234a <lapicinit>
  seginit();       // segment descriptors
80102b71:	e8 2f 37 00 00       	call   801062a5 <seginit>
  picinit();       // disable pic
80102b76:	e8 88 02 00 00       	call   80102e03 <picinit>
  ioapicinit();    // another interrupt controller
80102b7b:	e8 53 f4 ff ff       	call   80101fd3 <ioapicinit>
  consoleinit();   // console hardware
80102b80:	e8 45 dd ff ff       	call   801008ca <consoleinit>
  uartinit();      // serial port
80102b85:	e8 0b 2b 00 00       	call   80105695 <uartinit>
  pinit();         // process table
80102b8a:	e8 a9 06 00 00       	call   80103238 <pinit>
  tvinit();        // trap vectors
80102b8f:	e8 55 27 00 00       	call   801052e9 <tvinit>
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
80102c05:	68 38 71 10 80       	push   $0x80107138
80102c0a:	53                   	push   %ebx
80102c0b:	e8 dd 14 00 00       	call   801040ed <memcmp>
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
80102cc8:	68 3d 71 10 80       	push   $0x8010713d
80102ccd:	57                   	push   %edi
80102cce:	e8 1a 14 00 00       	call   801040ed <memcmp>
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
80102d5e:	68 42 71 10 80       	push   $0x80107142
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
80102df9:	68 5c 71 10 80       	push   $0x8010715c
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
80102e80:	68 7b 71 10 80       	push   $0x8010717b
80102e85:	50                   	push   %eax
80102e86:	e8 4e 0f 00 00       	call   80103dd9 <initlock>
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
80102f0a:	e8 06 10 00 00       	call   80103f15 <acquire>
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
80102f4a:	e8 2b 10 00 00       	call   80103f7a <release>
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
80102f79:	e8 fc 0f 00 00       	call   80103f7a <release>
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
80102f9b:	e8 75 0f 00 00       	call   80103f15 <acquire>
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
80102fbe:	e8 b7 0f 00 00       	call   80103f7a <release>
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
80103019:	e8 5c 0f 00 00       	call   80103f7a <release>
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
80103063:	e8 ad 0e 00 00       	call   80103f15 <acquire>
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
801030a7:	e8 ce 0e 00 00       	call   80103f7a <release>
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
801030f7:	e8 7e 0e 00 00       	call   80103f7a <release>
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
80103143:	e8 cd 0d 00 00       	call   80103f15 <acquire>
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
80103183:	e8 f2 0d 00 00       	call   80103f7a <release>
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
801031a0:	c7 80 b0 0f 00 00 de 	movl   $0x801052de,0xfb0(%eax)
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
801031ba:	e8 eb 0e 00 00       	call   801040aa <memset>
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
801031db:	e8 9a 0d 00 00       	call   80103f7a <release>
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
80103200:	e8 75 0d 00 00       	call   80103f7a <release>
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
8010323e:	68 80 71 10 80       	push   $0x80107180
80103243:	68 a0 38 11 80       	push   $0x801138a0
80103248:	e8 8c 0b 00 00       	call   80103dd9 <initlock>
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
8010328a:	68 a8 72 10 80       	push   $0x801072a8
8010328f:	e8 f4 d0 ff ff       	call   80100388 <panic>
  panic("unknown apicid\n");
80103294:	83 ec 0c             	sub    $0xc,%esp
80103297:	68 87 71 10 80       	push   $0x80107187
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
801032d0:	e8 65 0b 00 00       	call   80103e3a <pushcli>
  c = mycpu();
801032d5:	e8 78 ff ff ff       	call   80103252 <mycpu>
  p = c->proc;
801032da:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032e0:	e8 91 0b 00 00       	call   80103e76 <popcli>
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
801032ff:	e8 74 36 00 00       	call   80106978 <setupkvm>
80103304:	89 43 04             	mov    %eax,0x4(%ebx)
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 84 b8 00 00 00    	je     801033c7 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010330f:	83 ec 04             	sub    $0x4,%esp
80103312:	68 2c 00 00 00       	push   $0x2c
80103317:	68 60 a4 10 80       	push   $0x8010a460
8010331c:	50                   	push   %eax
8010331d:	e8 66 33 00 00       	call   80106688 <inituvm>
  p->sz = PGSIZE;
80103322:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103328:	8b 43 18             	mov    0x18(%ebx),%eax
8010332b:	83 c4 0c             	add    $0xc,%esp
8010332e:	6a 4c                	push   $0x4c
80103330:	6a 00                	push   $0x0
80103332:	50                   	push   %eax
80103333:	e8 72 0d 00 00       	call   801040aa <memset>
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
80103386:	68 b0 71 10 80       	push   $0x801071b0
8010338b:	50                   	push   %eax
8010338c:	e8 85 0e 00 00       	call   80104216 <safestrcpy>
  p->cwd = namei("/");
80103391:	c7 04 24 b9 71 10 80 	movl   $0x801071b9,(%esp)
80103398:	e8 17 e9 ff ff       	call   80101cb4 <namei>
8010339d:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033a0:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801033a7:	e8 69 0b 00 00       	call   80103f15 <acquire>
  p->state = RUNNABLE;
801033ac:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801033b3:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
801033ba:	e8 bb 0b 00 00       	call   80103f7a <release>
}
801033bf:	83 c4 10             	add    $0x10,%esp
801033c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    
    panic("userinit: out of memory?");
801033c7:	83 ec 0c             	sub    $0xc,%esp
801033ca:	68 97 71 10 80       	push   $0x80107197
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
801033f1:	e8 32 31 00 00       	call   80106528 <switchuvm>
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
8010340f:	e8 0a 34 00 00       	call   8010681e <allocuvm>
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
8010342c:	e8 5b 33 00 00       	call   8010678c <deallocuvm>
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
80103469:	e8 bb 35 00 00       	call   80106a29 <copyuvm>
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
8010350b:	e8 06 0d 00 00       	call   80104216 <safestrcpy>
  pid = np->pid;
80103510:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103513:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010351a:	e8 f6 09 00 00       	call   80103f15 <acquire>
  np->state = RUNNABLE;
8010351f:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103526:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
8010352d:	e8 48 0a 00 00       	call   80103f7a <release>
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
8010357f:	e8 a4 2f 00 00       	call   80106528 <switchuvm>
      p->state = RUNNING;
80103584:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010358b:	83 c4 08             	add    $0x8,%esp
8010358e:	ff 73 1c             	push   0x1c(%ebx)
80103591:	8d 46 04             	lea    0x4(%esi),%eax
80103594:	50                   	push   %eax
80103595:	e8 d1 0c 00 00       	call   8010426b <swtch>
      switchkvm();
8010359a:	e8 7b 2f 00 00       	call   8010651a <switchkvm>
      c->proc = 0;
8010359f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801035a6:	00 00 00 
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb b0                	jmp    8010355e <scheduler+0x18>
    release(&ptable.lock);
801035ae:	83 ec 0c             	sub    $0xc,%esp
801035b1:	68 a0 38 11 80       	push   $0x801138a0
801035b6:	e8 bf 09 00 00       	call   80103f7a <release>
    sti();
801035bb:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801035be:	fb                   	sti    
    acquire(&ptable.lock);
801035bf:	83 ec 0c             	sub    $0xc,%esp
801035c2:	68 a0 38 11 80       	push   $0x801138a0
801035c7:	e8 49 09 00 00       	call   80103f15 <acquire>
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
801035ea:	e8 e7 08 00 00       	call   80103ed6 <holding>
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
8010362b:	e8 3b 0c 00 00       	call   8010426b <swtch>
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
80103648:	68 bb 71 10 80       	push   $0x801071bb
8010364d:	e8 36 cd ff ff       	call   80100388 <panic>
    panic("sched locks");
80103652:	83 ec 0c             	sub    $0xc,%esp
80103655:	68 cd 71 10 80       	push   $0x801071cd
8010365a:	e8 29 cd ff ff       	call   80100388 <panic>
    panic("sched running");
8010365f:	83 ec 0c             	sub    $0xc,%esp
80103662:	68 d9 71 10 80       	push   $0x801071d9
80103667:	e8 1c cd ff ff       	call   80100388 <panic>
    panic("sched interruptible");
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 e7 71 10 80       	push   $0x801071e7
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
80103697:	68 fb 71 10 80       	push   $0x801071fb
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
801036ea:	e8 26 08 00 00       	call   80103f15 <acquire>
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
80103754:	68 08 72 10 80       	push   $0x80107208
80103759:	e8 2a cc ff ff       	call   80100388 <panic>

8010375e <yield>:
{
8010375e:	55                   	push   %ebp
8010375f:	89 e5                	mov    %esp,%ebp
80103761:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80103764:	68 a0 38 11 80       	push   $0x801138a0
80103769:	e8 a7 07 00 00       	call   80103f15 <acquire>
  myproc()->state = RUNNABLE;
8010376e:	e8 56 fb ff ff       	call   801032c9 <myproc>
80103773:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010377a:	e8 57 fe ff ff       	call   801035d6 <sched>
  release(&ptable.lock);
8010377f:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103786:	e8 ef 07 00 00       	call   80103f7a <release>
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
801037b7:	e8 59 07 00 00       	call   80103f15 <acquire>
    release(lk);
801037bc:	89 34 24             	mov    %esi,(%esp)
801037bf:	e8 b6 07 00 00       	call   80103f7a <release>
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
801037f0:	e8 85 07 00 00       	call   80103f7a <release>
    acquire(lk);
801037f5:	89 34 24             	mov    %esi,(%esp)
801037f8:	e8 18 07 00 00       	call   80103f15 <acquire>
801037fd:	83 c4 10             	add    $0x10,%esp
}
80103800:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103803:	5b                   	pop    %ebx
80103804:	5e                   	pop    %esi
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
    panic("sleep");
80103807:	83 ec 0c             	sub    $0xc,%esp
8010380a:	68 14 72 10 80       	push   $0x80107214
8010380f:	e8 74 cb ff ff       	call   80100388 <panic>
    panic("sleep without lk");
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 1a 72 10 80       	push   $0x8010721a
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
80103835:	e8 db 06 00 00       	call   80103f15 <acquire>
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
80103864:	e8 9f 30 00 00       	call   80106908 <freevm>
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
80103890:	e8 e5 06 00 00       	call   80103f7a <release>
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
801038d0:	e8 a5 06 00 00       	call   80103f7a <release>
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
80103900:	e8 10 06 00 00       	call   80103f15 <acquire>
  wakeup1(chan);
80103905:	8b 45 08             	mov    0x8(%ebp),%eax
80103908:	e8 03 f8 ff ff       	call   80103110 <wakeup1>
  release(&ptable.lock);
8010390d:	c7 04 24 a0 38 11 80 	movl   $0x801138a0,(%esp)
80103914:	e8 61 06 00 00       	call   80103f7a <release>
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
8010392d:	e8 e3 05 00 00       	call   80103f15 <acquire>
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
80103969:	e8 0c 06 00 00       	call   80103f7a <release>
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
80103983:	e8 f2 05 00 00       	call   80103f7a <release>
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
801039a1:	b8 2b 72 10 80       	mov    $0x8010722b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039a6:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039a9:	52                   	push   %edx
801039aa:	50                   	push   %eax
801039ab:	ff 73 10             	push   0x10(%ebx)
801039ae:	68 2f 72 10 80       	push   $0x8010722f
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
801039c4:	68 97 76 10 80       	push   $0x80107697
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
801039e8:	8b 04 85 e8 72 10 80 	mov    -0x7fef8d18(,%eax,4),%eax
801039ef:	85 c0                	test   %eax,%eax
801039f1:	75 b3                	jne    801039a6 <procdump+0x14>
      state = "???";
801039f3:	b8 2b 72 10 80       	mov    $0x8010722b,%eax
801039f8:	eb ac                	jmp    801039a6 <procdump+0x14>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801039fa:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039fd:	8b 40 0c             	mov    0xc(%eax),%eax
80103a00:	83 c0 08             	add    $0x8,%eax
80103a03:	83 ec 08             	sub    $0x8,%esp
80103a06:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a09:	52                   	push   %edx
80103a0a:	50                   	push   %eax
80103a0b:	e8 e4 03 00 00       	call   80103df4 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	be 00 00 00 00       	mov    $0x0,%esi
80103a18:	eb 14                	jmp    80103a2e <procdump+0x9c>
        cprintf(" %p", pc[i]);
80103a1a:	83 ec 08             	sub    $0x8,%esp
80103a1d:	50                   	push   %eax
80103a1e:	68 81 6c 10 80       	push   $0x80106c81
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
80103a8f:	e8 81 04 00 00       	call   80103f15 <acquire>
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
80103ab7:	ff 34 85 d0 72 10 80 	push   -0x7fef8d30(,%eax,4)
80103abe:	ff 73 10             	push   0x10(%ebx)
80103ac1:	68 38 72 10 80       	push   $0x80107238
80103ac6:	e8 7c cb ff ff       	call   80100647 <cprintf>
      cprintf("ppid here%d\n", p->parent->pid);
80103acb:	8b 43 14             	mov    0x14(%ebx),%eax
80103ace:	83 c4 08             	add    $0x8,%esp
80103ad1:	ff 70 10             	push   0x10(%eax)
80103ad4:	68 3f 72 10 80       	push   $0x8010723f
80103ad9:	e8 69 cb ff ff       	call   80100647 <cprintf>
      cprintf("ppid func%d\n", getppid());
80103ade:	e8 61 ff ff ff       	call   80103a44 <getppid>
80103ae3:	83 c4 08             	add    $0x8,%esp
80103ae6:	50                   	push   %eax
80103ae7:	68 4c 72 10 80       	push   $0x8010724c
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
80103afe:	e8 77 04 00 00       	call   80103f7a <release>
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
80103b73:	e8 9d 03 00 00       	call   80103f15 <acquire>
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
80103b85:	68 5f 72 10 80       	push   $0x8010725f
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
80103ba1:	e8 d4 03 00 00       	call   80103f7a <release>
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
80103bb4:	68 6e 72 10 80       	push   $0x8010726e
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
80103bdd:	68 59 72 10 80       	push   $0x80107259
80103be2:	57                   	push   %edi
80103be3:	e8 27 ff ff ff       	call   80103b0f <compare>
80103be8:	83 c4 10             	add    $0x10,%esp
80103beb:	85 c0                	test   %eax,%eax
80103bed:	75 93                	jne    80103b82 <signalProcess+0x23>
      if(compare(type,"CONTINUE")){
80103bef:	83 ec 08             	sub    $0x8,%esp
80103bf2:	68 65 72 10 80       	push   $0x80107265
80103bf7:	57                   	push   %edi
80103bf8:	e8 12 ff ff ff       	call   80103b0f <compare>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	85 c0                	test   %eax,%eax
80103c02:	75 ad                	jne    80103bb1 <signalProcess+0x52>
      if(compare(type,"KILL")){
80103c04:	83 ec 08             	sub    $0x8,%esp
80103c07:	68 77 72 10 80       	push   $0x80107277
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
80103c3d:	e8 83 2f 00 00       	call   80106bc5 <retNumpp>
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
80103c4f:	e8 6d 03 00 00       	call   80103fc1 <init_mylockLC>
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
80103c62:	e8 93 06 00 00       	call   801042fa <argint>
  // return id;
  return acquire_mylockLC(&ptable.lock, id);
80103c67:	83 c4 08             	add    $0x8,%esp
80103c6a:	ff 75 08             	push   0x8(%ebp)
80103c6d:	68 a0 38 11 80       	push   $0x801138a0
80103c72:	e8 7c 03 00 00       	call   80103ff3 <acquire_mylockLC>
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
80103c85:	e8 70 06 00 00       	call   801042fa <argint>
  return release_mylockLC(&ptable.lock, id);
80103c8a:	83 c4 08             	add    $0x8,%esp
80103c8d:	ff 75 08             	push   0x8(%ebp)
80103c90:	68 a0 38 11 80       	push   $0x801138a0
80103c95:	e8 d7 03 00 00       	call   80104071 <release_mylockLC>
}
80103c9a:	c9                   	leave  
80103c9b:	c3                   	ret    

80103c9c <holding_mylock>:

int holding_mylock(int id){
80103c9c:	55                   	push   %ebp
80103c9d:	89 e5                	mov    %esp,%ebp
80103c9f:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80103ca2:	8d 45 08             	lea    0x8(%ebp),%eax
80103ca5:	50                   	push   %eax
80103ca6:	6a 00                	push   $0x0
80103ca8:	e8 4d 06 00 00       	call   801042fa <argint>
  return holding_mylockLC(&ptable.lock, id);
80103cad:	83 c4 08             	add    $0x8,%esp
80103cb0:	ff 75 08             	push   0x8(%ebp)
80103cb3:	68 a0 38 11 80       	push   $0x801138a0
80103cb8:	e8 e5 03 00 00       	call   801040a2 <holding_mylockLC>
80103cbd:	c9                   	leave  
80103cbe:	c3                   	ret    

80103cbf <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103cbf:	55                   	push   %ebp
80103cc0:	89 e5                	mov    %esp,%ebp
80103cc2:	53                   	push   %ebx
80103cc3:	83 ec 0c             	sub    $0xc,%esp
80103cc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103cc9:	68 00 73 10 80       	push   $0x80107300
80103cce:	8d 43 04             	lea    0x4(%ebx),%eax
80103cd1:	50                   	push   %eax
80103cd2:	e8 02 01 00 00       	call   80103dd9 <initlock>
  lk->name = name;
80103cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cda:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  lk->locked = 0;
80103ce0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ce6:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103ced:	00 00 00 
}
80103cf0:	83 c4 10             	add    $0x10,%esp
80103cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf6:	c9                   	leave  
80103cf7:	c3                   	ret    

80103cf8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103cf8:	55                   	push   %ebp
80103cf9:	89 e5                	mov    %esp,%ebp
80103cfb:	56                   	push   %esi
80103cfc:	53                   	push   %ebx
80103cfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103d00:	8d 73 04             	lea    0x4(%ebx),%esi
80103d03:	83 ec 0c             	sub    $0xc,%esp
80103d06:	56                   	push   %esi
80103d07:	e8 09 02 00 00       	call   80103f15 <acquire>
  while (lk->locked) {
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	eb 0d                	jmp    80103d1e <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103d11:	83 ec 08             	sub    $0x8,%esp
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	e8 75 fa ff ff       	call   80103790 <sleep>
80103d1b:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103d1e:	83 3b 00             	cmpl   $0x0,(%ebx)
80103d21:	75 ee                	jne    80103d11 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103d23:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103d29:	e8 9b f5 ff ff       	call   801032c9 <myproc>
80103d2e:	8b 40 10             	mov    0x10(%eax),%eax
80103d31:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  release(&lk->lk);
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	56                   	push   %esi
80103d3b:	e8 3a 02 00 00       	call   80103f7a <release>
}
80103d40:	83 c4 10             	add    $0x10,%esp
80103d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d46:	5b                   	pop    %ebx
80103d47:	5e                   	pop    %esi
80103d48:	5d                   	pop    %ebp
80103d49:	c3                   	ret    

80103d4a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103d4a:	55                   	push   %ebp
80103d4b:	89 e5                	mov    %esp,%ebp
80103d4d:	56                   	push   %esi
80103d4e:	53                   	push   %ebx
80103d4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103d52:	8d 73 04             	lea    0x4(%ebx),%esi
80103d55:	83 ec 0c             	sub    $0xc,%esp
80103d58:	56                   	push   %esi
80103d59:	e8 b7 01 00 00       	call   80103f15 <acquire>
  lk->locked = 0;
80103d5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103d64:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103d6b:	00 00 00 
  wakeup(lk);
80103d6e:	89 1c 24             	mov    %ebx,(%esp)
80103d71:	e8 7f fb ff ff       	call   801038f5 <wakeup>
  release(&lk->lk);
80103d76:	89 34 24             	mov    %esi,(%esp)
80103d79:	e8 fc 01 00 00       	call   80103f7a <release>
}
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d84:	5b                   	pop    %ebx
80103d85:	5e                   	pop    %esi
80103d86:	5d                   	pop    %ebp
80103d87:	c3                   	ret    

80103d88 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103d88:	55                   	push   %ebp
80103d89:	89 e5                	mov    %esp,%ebp
80103d8b:	56                   	push   %esi
80103d8c:	53                   	push   %ebx
80103d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103d90:	8d 73 04             	lea    0x4(%ebx),%esi
80103d93:	83 ec 0c             	sub    $0xc,%esp
80103d96:	56                   	push   %esi
80103d97:	e8 79 01 00 00       	call   80103f15 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103d9c:	83 c4 10             	add    $0x10,%esp
80103d9f:	83 3b 00             	cmpl   $0x0,(%ebx)
80103da2:	75 17                	jne    80103dbb <holdingsleep+0x33>
80103da4:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103da9:	83 ec 0c             	sub    $0xc,%esp
80103dac:	56                   	push   %esi
80103dad:	e8 c8 01 00 00       	call   80103f7a <release>
  return r;
}
80103db2:	89 d8                	mov    %ebx,%eax
80103db4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db7:	5b                   	pop    %ebx
80103db8:	5e                   	pop    %esi
80103db9:	5d                   	pop    %ebp
80103dba:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103dbb:	8b 9b 8c 00 00 00    	mov    0x8c(%ebx),%ebx
80103dc1:	e8 03 f5 ff ff       	call   801032c9 <myproc>
80103dc6:	3b 58 10             	cmp    0x10(%eax),%ebx
80103dc9:	74 07                	je     80103dd2 <holdingsleep+0x4a>
80103dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
80103dd0:	eb d7                	jmp    80103da9 <holdingsleep+0x21>
80103dd2:	bb 01 00 00 00       	mov    $0x1,%ebx
80103dd7:	eb d0                	jmp    80103da9 <holdingsleep+0x21>

80103dd9 <initlock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name)
{
80103dd9:	55                   	push   %ebp
80103dda:	89 e5                	mov    %esp,%ebp
80103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
80103de2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103deb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103df2:	5d                   	pop    %ebp
80103df3:	c3                   	ret    

80103df4 <getcallerpcs>:
  popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[])
{
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	53                   	push   %ebx
80103df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint *)v - 2;
80103dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfe:	8d 50 f8             	lea    -0x8(%eax),%edx
  for (i = 0; i < 10; i++)
80103e01:	b8 00 00 00 00       	mov    $0x0,%eax
80103e06:	83 f8 09             	cmp    $0x9,%eax
80103e09:	7f 25                	jg     80103e30 <getcallerpcs+0x3c>
  {
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
80103e0b:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103e11:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103e17:	77 17                	ja     80103e30 <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];      // saved %eip
80103e19:	8b 5a 04             	mov    0x4(%edx),%ebx
80103e1c:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint *)ebp[0]; // saved %ebp
80103e1f:	8b 12                	mov    (%edx),%edx
  for (i = 0; i < 10; i++)
80103e21:	83 c0 01             	add    $0x1,%eax
80103e24:	eb e0                	jmp    80103e06 <getcallerpcs+0x12>
  }
  for (; i < 10; i++)
    pcs[i] = 0;
80103e26:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for (; i < 10; i++)
80103e2d:	83 c0 01             	add    $0x1,%eax
80103e30:	83 f8 09             	cmp    $0x9,%eax
80103e33:	7e f1                	jle    80103e26 <getcallerpcs+0x32>
}
80103e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e38:	c9                   	leave  
80103e39:	c3                   	ret    

80103e3a <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)
{
80103e3a:	55                   	push   %ebp
80103e3b:	89 e5                	mov    %esp,%ebp
80103e3d:	53                   	push   %ebx
80103e3e:	83 ec 04             	sub    $0x4,%esp
80103e41:	9c                   	pushf  
80103e42:	5b                   	pop    %ebx
  asm volatile("cli");
80103e43:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if (mycpu()->ncli == 0)
80103e44:	e8 09 f4 ff ff       	call   80103252 <mycpu>
80103e49:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103e50:	74 11                	je     80103e63 <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103e52:	e8 fb f3 ff ff       	call   80103252 <mycpu>
80103e57:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e61:	c9                   	leave  
80103e62:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103e63:	e8 ea f3 ff ff       	call   80103252 <mycpu>
80103e68:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103e6e:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103e74:	eb dc                	jmp    80103e52 <pushcli+0x18>

80103e76 <popcli>:

void popcli(void)
{
80103e76:	55                   	push   %ebp
80103e77:	89 e5                	mov    %esp,%ebp
80103e79:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e7c:	9c                   	pushf  
80103e7d:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103e7e:	f6 c4 02             	test   $0x2,%ah
80103e81:	75 28                	jne    80103eab <popcli+0x35>
    panic("popcli - interruptible");
  if (--mycpu()->ncli < 0)
80103e83:	e8 ca f3 ff ff       	call   80103252 <mycpu>
80103e88:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103e8e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103e91:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103e97:	85 d2                	test   %edx,%edx
80103e99:	78 1d                	js     80103eb8 <popcli+0x42>
    panic("popcli");
  if (mycpu()->ncli == 0 && mycpu()->intena)
80103e9b:	e8 b2 f3 ff ff       	call   80103252 <mycpu>
80103ea0:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103ea7:	74 1c                	je     80103ec5 <popcli+0x4f>
    sti();
}
80103ea9:	c9                   	leave  
80103eaa:	c3                   	ret    
    panic("popcli - interruptible");
80103eab:	83 ec 0c             	sub    $0xc,%esp
80103eae:	68 0b 73 10 80       	push   $0x8010730b
80103eb3:	e8 d0 c4 ff ff       	call   80100388 <panic>
    panic("popcli");
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 22 73 10 80       	push   $0x80107322
80103ec0:	e8 c3 c4 ff ff       	call   80100388 <panic>
  if (mycpu()->ncli == 0 && mycpu()->intena)
80103ec5:	e8 88 f3 ff ff       	call   80103252 <mycpu>
80103eca:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103ed1:	74 d6                	je     80103ea9 <popcli+0x33>
  asm volatile("sti");
80103ed3:	fb                   	sti    
}
80103ed4:	eb d3                	jmp    80103ea9 <popcli+0x33>

80103ed6 <holding>:
{
80103ed6:	55                   	push   %ebp
80103ed7:	89 e5                	mov    %esp,%ebp
80103ed9:	53                   	push   %ebx
80103eda:	83 ec 04             	sub    $0x4,%esp
80103edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103ee0:	e8 55 ff ff ff       	call   80103e3a <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103ee5:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ee8:	75 11                	jne    80103efb <holding+0x25>
80103eea:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103eef:	e8 82 ff ff ff       	call   80103e76 <popcli>
}
80103ef4:	89 d8                	mov    %ebx,%eax
80103ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef9:	c9                   	leave  
80103efa:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103efb:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103efe:	e8 4f f3 ff ff       	call   80103252 <mycpu>
80103f03:	39 c3                	cmp    %eax,%ebx
80103f05:	74 07                	je     80103f0e <holding+0x38>
80103f07:	bb 00 00 00 00       	mov    $0x0,%ebx
80103f0c:	eb e1                	jmp    80103eef <holding+0x19>
80103f0e:	bb 01 00 00 00       	mov    $0x1,%ebx
80103f13:	eb da                	jmp    80103eef <holding+0x19>

80103f15 <acquire>:
{
80103f15:	55                   	push   %ebp
80103f16:	89 e5                	mov    %esp,%ebp
80103f18:	53                   	push   %ebx
80103f19:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103f1c:	e8 19 ff ff ff       	call   80103e3a <pushcli>
  if (holding(lk))
80103f21:	83 ec 0c             	sub    $0xc,%esp
80103f24:	ff 75 08             	push   0x8(%ebp)
80103f27:	e8 aa ff ff ff       	call   80103ed6 <holding>
80103f2c:	83 c4 10             	add    $0x10,%esp
80103f2f:	85 c0                	test   %eax,%eax
80103f31:	75 3a                	jne    80103f6d <acquire+0x58>
  while (xchg(&lk->locked, 1) != 0)
80103f33:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103f36:	b8 01 00 00 00       	mov    $0x1,%eax
80103f3b:	f0 87 02             	lock xchg %eax,(%edx)
80103f3e:	85 c0                	test   %eax,%eax
80103f40:	75 f1                	jne    80103f33 <acquire+0x1e>
  __sync_synchronize();
80103f42:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f4a:	e8 03 f3 ff ff       	call   80103252 <mycpu>
80103f4f:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103f52:	8b 45 08             	mov    0x8(%ebp),%eax
80103f55:	83 c0 0c             	add    $0xc,%eax
80103f58:	83 ec 08             	sub    $0x8,%esp
80103f5b:	50                   	push   %eax
80103f5c:	8d 45 08             	lea    0x8(%ebp),%eax
80103f5f:	50                   	push   %eax
80103f60:	e8 8f fe ff ff       	call   80103df4 <getcallerpcs>
}
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f6b:	c9                   	leave  
80103f6c:	c3                   	ret    
    panic("acquire");
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	68 29 73 10 80       	push   $0x80107329
80103f75:	e8 0e c4 ff ff       	call   80100388 <panic>

80103f7a <release>:
{
80103f7a:	55                   	push   %ebp
80103f7b:	89 e5                	mov    %esp,%ebp
80103f7d:	53                   	push   %ebx
80103f7e:	83 ec 10             	sub    $0x10,%esp
80103f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (!holding(lk))
80103f84:	53                   	push   %ebx
80103f85:	e8 4c ff ff ff       	call   80103ed6 <holding>
80103f8a:	83 c4 10             	add    $0x10,%esp
80103f8d:	85 c0                	test   %eax,%eax
80103f8f:	74 23                	je     80103fb4 <release+0x3a>
  lk->pcs[0] = 0;
80103f91:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103f98:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103f9f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0"
80103fa4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103faa:	e8 c7 fe ff ff       	call   80103e76 <popcli>
}
80103faf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb2:	c9                   	leave  
80103fb3:	c3                   	ret    
    panic("release");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 31 73 10 80       	push   $0x80107331
80103fbc:	e8 c7 c3 ff ff       	call   80100388 <panic>

80103fc1 <init_mylockLC>:

int init_mylockLC(struct spinlock *lk)
{
80103fc1:	55                   	push   %ebp
80103fc2:	89 e5                	mov    %esp,%ebp
80103fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  int counter = 0;
80103fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  while (lk->exists[counter] == 1 && counter <= 10)
80103fcc:	eb 03                	jmp    80103fd1 <init_mylockLC+0x10>
  {
    // cprintf("%d\n",lk->exists[0]);
    counter++;
80103fce:	83 c0 01             	add    $0x1,%eax
  while (lk->exists[counter] == 1 && counter <= 10)
80103fd1:	83 7c 82 34 01       	cmpl   $0x1,0x34(%edx,%eax,4)
80103fd6:	75 05                	jne    80103fdd <init_mylockLC+0x1c>
80103fd8:	83 f8 0a             	cmp    $0xa,%eax
80103fdb:	7e f1                	jle    80103fce <init_mylockLC+0xd>
  }
  if (counter == 11)
80103fdd:	83 f8 0b             	cmp    $0xb,%eax
80103fe0:	74 0a                	je     80103fec <init_mylockLC+0x2b>
  {
    return -1;
  }
  else
  {
    lk->exists[counter] = 1;
80103fe2:	c7 44 82 34 01 00 00 	movl   $0x1,0x34(%edx,%eax,4)
80103fe9:	00 
    return counter;
  }
}
80103fea:	5d                   	pop    %ebp
80103feb:	c3                   	ret    
    return -1;
80103fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ff1:	eb f7                	jmp    80103fea <init_mylockLC+0x29>

80103ff3 <acquire_mylockLC>:

int acquire_mylockLC(struct spinlock *lk, int id)
{
80103ff3:	55                   	push   %ebp
80103ff4:	89 e5                	mov    %esp,%ebp
80103ff6:	56                   	push   %esi
80103ff7:	53                   	push   %ebx
80103ff8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ffb:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ffe:	e8 37 fe ff ff       	call   80103e3a <pushcli>
  if (lk->exists[id] == 1)
80104003:	83 7c b3 34 01       	cmpl   $0x1,0x34(%ebx,%esi,4)
80104008:	75 60                	jne    8010406a <acquire_mylockLC+0x77>
  {
    cprintf("111\n");
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 39 73 10 80       	push   $0x80107339
80104012:	e8 30 c6 ff ff       	call   80100647 <cprintf>

    while (xchg(&lk->locked, 1) != 0 && xchg(&lk->status[id], 1) != 0)
80104017:	83 c4 10             	add    $0x10,%esp
8010401a:	b8 01 00 00 00       	mov    $0x1,%eax
8010401f:	f0 87 03             	lock xchg %eax,(%ebx)
80104022:	85 c0                	test   %eax,%eax
80104024:	74 23                	je     80104049 <acquire_mylockLC+0x56>
80104026:	8d 54 b3 50          	lea    0x50(%ebx,%esi,4),%edx
8010402a:	b8 01 00 00 00       	mov    $0x1,%eax
8010402f:	f0 87 42 0c          	lock xchg %eax,0xc(%edx)
80104033:	85 c0                	test   %eax,%eax
80104035:	74 12                	je     80104049 <acquire_mylockLC+0x56>
      // while(1)
      cprintf("1");
80104037:	83 ec 0c             	sub    $0xc,%esp
8010403a:	68 58 74 10 80       	push   $0x80107458
8010403f:	e8 03 c6 ff ff       	call   80100647 <cprintf>
80104044:	83 c4 10             	add    $0x10,%esp
80104047:	eb d1                	jmp    8010401a <acquire_mylockLC+0x27>
    ;
    // return id;
    cprintf("112\n");
80104049:	83 ec 0c             	sub    $0xc,%esp
8010404c:	68 3e 73 10 80       	push   $0x8010733e
80104051:	e8 f1 c5 ff ff       	call   80100647 <cprintf>
  }
  else {
    return -1;
  }
 
  __sync_synchronize();
80104056:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  return 0;
8010405b:	83 c4 10             	add    $0x10,%esp
8010405e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104063:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104066:	5b                   	pop    %ebx
80104067:	5e                   	pop    %esi
80104068:	5d                   	pop    %ebp
80104069:	c3                   	ret    
    return -1;
8010406a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406f:	eb f2                	jmp    80104063 <acquire_mylockLC+0x70>

80104071 <release_mylockLC>:

int release_mylockLC(struct spinlock *lk, int id)
{
80104071:	55                   	push   %ebp
80104072:	89 e5                	mov    %esp,%ebp
80104074:	8b 45 08             	mov    0x8(%ebp),%eax
80104077:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(lk->status[id]==1){
8010407a:	83 7c 90 5c 01       	cmpl   $0x1,0x5c(%eax,%edx,4)
8010407f:	74 07                	je     80104088 <release_mylockLC+0x17>
               :);
               
  return 1;
  }
  else{
    return -1;
80104081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80104086:	5d                   	pop    %ebp
80104087:	c3                   	ret    
  lk->status[id]=0;
80104088:	c7 44 90 5c 00 00 00 	movl   $0x0,0x5c(%eax,%edx,4)
8010408f:	00 
  __sync_synchronize();
80104090:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0"
80104095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return 1;
8010409b:	b8 01 00 00 00       	mov    $0x1,%eax
801040a0:	eb e4                	jmp    80104086 <release_mylockLC+0x15>

801040a2 <holding_mylockLC>:

int holding_mylockLC(struct spinlock *lk, int id){
801040a2:	55                   	push   %ebp
801040a3:	89 e5                	mov    %esp,%ebp
  return id;
801040a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a8:	5d                   	pop    %ebp
801040a9:	c3                   	ret    

801040aa <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801040aa:	55                   	push   %ebp
801040ab:	89 e5                	mov    %esp,%ebp
801040ad:	57                   	push   %edi
801040ae:	53                   	push   %ebx
801040af:	8b 55 08             	mov    0x8(%ebp),%edx
801040b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801040b8:	f6 c2 03             	test   $0x3,%dl
801040bb:	75 25                	jne    801040e2 <memset+0x38>
801040bd:	f6 c1 03             	test   $0x3,%cl
801040c0:	75 20                	jne    801040e2 <memset+0x38>
    c &= 0xFF;
801040c2:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801040c5:	c1 e9 02             	shr    $0x2,%ecx
801040c8:	c1 e0 18             	shl    $0x18,%eax
801040cb:	89 fb                	mov    %edi,%ebx
801040cd:	c1 e3 10             	shl    $0x10,%ebx
801040d0:	09 d8                	or     %ebx,%eax
801040d2:	89 fb                	mov    %edi,%ebx
801040d4:	c1 e3 08             	shl    $0x8,%ebx
801040d7:	09 d8                	or     %ebx,%eax
801040d9:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801040db:	89 d7                	mov    %edx,%edi
801040dd:	fc                   	cld    
801040de:	f3 ab                	rep stos %eax,%es:(%edi)
}
801040e0:	eb 05                	jmp    801040e7 <memset+0x3d>
  asm volatile("cld; rep stosb" :
801040e2:	89 d7                	mov    %edx,%edi
801040e4:	fc                   	cld    
801040e5:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801040e7:	89 d0                	mov    %edx,%eax
801040e9:	5b                   	pop    %ebx
801040ea:	5f                   	pop    %edi
801040eb:	5d                   	pop    %ebp
801040ec:	c3                   	ret    

801040ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801040ed:	55                   	push   %ebp
801040ee:	89 e5                	mov    %esp,%ebp
801040f0:	56                   	push   %esi
801040f1:	53                   	push   %ebx
801040f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801040f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801040f8:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801040fb:	eb 08                	jmp    80104105 <memcmp+0x18>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801040fd:	83 c1 01             	add    $0x1,%ecx
80104100:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104103:	89 f0                	mov    %esi,%eax
80104105:	8d 70 ff             	lea    -0x1(%eax),%esi
80104108:	85 c0                	test   %eax,%eax
8010410a:	74 12                	je     8010411e <memcmp+0x31>
    if(*s1 != *s2)
8010410c:	0f b6 01             	movzbl (%ecx),%eax
8010410f:	0f b6 1a             	movzbl (%edx),%ebx
80104112:	38 d8                	cmp    %bl,%al
80104114:	74 e7                	je     801040fd <memcmp+0x10>
      return *s1 - *s2;
80104116:	0f b6 c0             	movzbl %al,%eax
80104119:	0f b6 db             	movzbl %bl,%ebx
8010411c:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
8010411e:	5b                   	pop    %ebx
8010411f:	5e                   	pop    %esi
80104120:	5d                   	pop    %ebp
80104121:	c3                   	ret    

80104122 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104122:	55                   	push   %ebp
80104123:	89 e5                	mov    %esp,%ebp
80104125:	56                   	push   %esi
80104126:	53                   	push   %ebx
80104127:	8b 75 08             	mov    0x8(%ebp),%esi
8010412a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010412d:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104130:	39 f2                	cmp    %esi,%edx
80104132:	73 3c                	jae    80104170 <memmove+0x4e>
80104134:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80104137:	39 f1                	cmp    %esi,%ecx
80104139:	76 39                	jbe    80104174 <memmove+0x52>
    s += n;
    d += n;
8010413b:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
8010413e:	eb 0d                	jmp    8010414d <memmove+0x2b>
      *--d = *--s;
80104140:	83 e9 01             	sub    $0x1,%ecx
80104143:	83 ea 01             	sub    $0x1,%edx
80104146:	0f b6 01             	movzbl (%ecx),%eax
80104149:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
8010414b:	89 d8                	mov    %ebx,%eax
8010414d:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104150:	85 c0                	test   %eax,%eax
80104152:	75 ec                	jne    80104140 <memmove+0x1e>
80104154:	eb 14                	jmp    8010416a <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104156:	0f b6 02             	movzbl (%edx),%eax
80104159:	88 01                	mov    %al,(%ecx)
8010415b:	8d 49 01             	lea    0x1(%ecx),%ecx
8010415e:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80104161:	89 d8                	mov    %ebx,%eax
80104163:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104166:	85 c0                	test   %eax,%eax
80104168:	75 ec                	jne    80104156 <memmove+0x34>

  return dst;
}
8010416a:	89 f0                	mov    %esi,%eax
8010416c:	5b                   	pop    %ebx
8010416d:	5e                   	pop    %esi
8010416e:	5d                   	pop    %ebp
8010416f:	c3                   	ret    
80104170:	89 f1                	mov    %esi,%ecx
80104172:	eb ef                	jmp    80104163 <memmove+0x41>
80104174:	89 f1                	mov    %esi,%ecx
80104176:	eb eb                	jmp    80104163 <memmove+0x41>

80104178 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010417e:	ff 75 10             	push   0x10(%ebp)
80104181:	ff 75 0c             	push   0xc(%ebp)
80104184:	ff 75 08             	push   0x8(%ebp)
80104187:	e8 96 ff ff ff       	call   80104122 <memmove>
}
8010418c:	c9                   	leave  
8010418d:	c3                   	ret    

8010418e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010418e:	55                   	push   %ebp
8010418f:	89 e5                	mov    %esp,%ebp
80104191:	53                   	push   %ebx
80104192:	8b 55 08             	mov    0x8(%ebp),%edx
80104195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104198:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010419b:	eb 09                	jmp    801041a6 <strncmp+0x18>
    n--, p++, q++;
8010419d:	83 e8 01             	sub    $0x1,%eax
801041a0:	83 c2 01             	add    $0x1,%edx
801041a3:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801041a6:	85 c0                	test   %eax,%eax
801041a8:	74 0b                	je     801041b5 <strncmp+0x27>
801041aa:	0f b6 1a             	movzbl (%edx),%ebx
801041ad:	84 db                	test   %bl,%bl
801041af:	74 04                	je     801041b5 <strncmp+0x27>
801041b1:	3a 19                	cmp    (%ecx),%bl
801041b3:	74 e8                	je     8010419d <strncmp+0xf>
  if(n == 0)
801041b5:	85 c0                	test   %eax,%eax
801041b7:	74 0d                	je     801041c6 <strncmp+0x38>
    return 0;
  return (uchar)*p - (uchar)*q;
801041b9:	0f b6 02             	movzbl (%edx),%eax
801041bc:	0f b6 11             	movzbl (%ecx),%edx
801041bf:	29 d0                	sub    %edx,%eax
}
801041c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    
    return 0;
801041c6:	b8 00 00 00 00       	mov    $0x0,%eax
801041cb:	eb f4                	jmp    801041c1 <strncmp+0x33>

801041cd <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801041cd:	55                   	push   %ebp
801041ce:	89 e5                	mov    %esp,%ebp
801041d0:	57                   	push   %edi
801041d1:	56                   	push   %esi
801041d2:	53                   	push   %ebx
801041d3:	8b 7d 08             	mov    0x8(%ebp),%edi
801041d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041d9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801041dc:	89 fa                	mov    %edi,%edx
801041de:	eb 04                	jmp    801041e4 <strncpy+0x17>
801041e0:	89 f1                	mov    %esi,%ecx
801041e2:	89 da                	mov    %ebx,%edx
801041e4:	89 c3                	mov    %eax,%ebx
801041e6:	83 e8 01             	sub    $0x1,%eax
801041e9:	85 db                	test   %ebx,%ebx
801041eb:	7e 11                	jle    801041fe <strncpy+0x31>
801041ed:	8d 71 01             	lea    0x1(%ecx),%esi
801041f0:	8d 5a 01             	lea    0x1(%edx),%ebx
801041f3:	0f b6 09             	movzbl (%ecx),%ecx
801041f6:	88 0a                	mov    %cl,(%edx)
801041f8:	84 c9                	test   %cl,%cl
801041fa:	75 e4                	jne    801041e0 <strncpy+0x13>
801041fc:	89 da                	mov    %ebx,%edx
    ;
  while(n-- > 0)
801041fe:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104201:	85 c0                	test   %eax,%eax
80104203:	7e 0a                	jle    8010420f <strncpy+0x42>
    *s++ = 0;
80104205:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80104208:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
8010420a:	8d 52 01             	lea    0x1(%edx),%edx
8010420d:	eb ef                	jmp    801041fe <strncpy+0x31>
  return os;
}
8010420f:	89 f8                	mov    %edi,%eax
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5f                   	pop    %edi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret    

80104216 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104216:	55                   	push   %ebp
80104217:	89 e5                	mov    %esp,%ebp
80104219:	57                   	push   %edi
8010421a:	56                   	push   %esi
8010421b:	53                   	push   %ebx
8010421c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010421f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104222:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104225:	85 c0                	test   %eax,%eax
80104227:	7e 23                	jle    8010424c <safestrcpy+0x36>
80104229:	89 fa                	mov    %edi,%edx
8010422b:	eb 04                	jmp    80104231 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
8010422d:	89 f1                	mov    %esi,%ecx
8010422f:	89 da                	mov    %ebx,%edx
80104231:	83 e8 01             	sub    $0x1,%eax
80104234:	85 c0                	test   %eax,%eax
80104236:	7e 11                	jle    80104249 <safestrcpy+0x33>
80104238:	8d 71 01             	lea    0x1(%ecx),%esi
8010423b:	8d 5a 01             	lea    0x1(%edx),%ebx
8010423e:	0f b6 09             	movzbl (%ecx),%ecx
80104241:	88 0a                	mov    %cl,(%edx)
80104243:	84 c9                	test   %cl,%cl
80104245:	75 e6                	jne    8010422d <safestrcpy+0x17>
80104247:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80104249:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
8010424c:	89 f8                	mov    %edi,%eax
8010424e:	5b                   	pop    %ebx
8010424f:	5e                   	pop    %esi
80104250:	5f                   	pop    %edi
80104251:	5d                   	pop    %ebp
80104252:	c3                   	ret    

80104253 <strlen>:

int
strlen(const char *s)
{
80104253:	55                   	push   %ebp
80104254:	89 e5                	mov    %esp,%ebp
80104256:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104259:	b8 00 00 00 00       	mov    $0x0,%eax
8010425e:	eb 03                	jmp    80104263 <strlen+0x10>
80104260:	83 c0 01             	add    $0x1,%eax
80104263:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104267:	75 f7                	jne    80104260 <strlen+0xd>
    ;
  return n;
}
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    

8010426b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010426b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010426f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104273:	55                   	push   %ebp
  pushl %ebx
80104274:	53                   	push   %ebx
  pushl %esi
80104275:	56                   	push   %esi
  pushl %edi
80104276:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104277:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104279:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010427b:	5f                   	pop    %edi
  popl %esi
8010427c:	5e                   	pop    %esi
  popl %ebx
8010427d:	5b                   	pop    %ebx
  popl %ebp
8010427e:	5d                   	pop    %ebp
  ret
8010427f:	c3                   	ret    

80104280 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 04             	sub    $0x4,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010428a:	e8 3a f0 ff ff       	call   801032c9 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010428f:	8b 00                	mov    (%eax),%eax
80104291:	39 d8                	cmp    %ebx,%eax
80104293:	76 18                	jbe    801042ad <fetchint+0x2d>
80104295:	8d 53 04             	lea    0x4(%ebx),%edx
80104298:	39 d0                	cmp    %edx,%eax
8010429a:	72 18                	jb     801042b4 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
8010429c:	8b 13                	mov    (%ebx),%edx
8010429e:	8b 45 0c             	mov    0xc(%ebp),%eax
801042a1:	89 10                	mov    %edx,(%eax)
  return 0;
801042a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ab:	c9                   	leave  
801042ac:	c3                   	ret    
    return -1;
801042ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b2:	eb f4                	jmp    801042a8 <fetchint+0x28>
801042b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b9:	eb ed                	jmp    801042a8 <fetchint+0x28>

801042bb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801042bb:	55                   	push   %ebp
801042bc:	89 e5                	mov    %esp,%ebp
801042be:	53                   	push   %ebx
801042bf:	83 ec 04             	sub    $0x4,%esp
801042c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801042c5:	e8 ff ef ff ff       	call   801032c9 <myproc>

  if(addr >= curproc->sz)
801042ca:	39 18                	cmp    %ebx,(%eax)
801042cc:	76 25                	jbe    801042f3 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
801042ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801042d1:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801042d3:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801042d5:	89 d8                	mov    %ebx,%eax
801042d7:	eb 03                	jmp    801042dc <fetchstr+0x21>
801042d9:	83 c0 01             	add    $0x1,%eax
801042dc:	39 d0                	cmp    %edx,%eax
801042de:	73 09                	jae    801042e9 <fetchstr+0x2e>
    if(*s == 0)
801042e0:	80 38 00             	cmpb   $0x0,(%eax)
801042e3:	75 f4                	jne    801042d9 <fetchstr+0x1e>
      return s - *pp;
801042e5:	29 d8                	sub    %ebx,%eax
801042e7:	eb 05                	jmp    801042ee <fetchstr+0x33>
  }
  return -1;
801042e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f1:	c9                   	leave  
801042f2:	c3                   	ret    
    return -1;
801042f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042f8:	eb f4                	jmp    801042ee <fetchstr+0x33>

801042fa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801042fa:	55                   	push   %ebp
801042fb:	89 e5                	mov    %esp,%ebp
801042fd:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104300:	e8 c4 ef ff ff       	call   801032c9 <myproc>
80104305:	8b 50 18             	mov    0x18(%eax),%edx
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	c1 e0 02             	shl    $0x2,%eax
8010430e:	03 42 44             	add    0x44(%edx),%eax
80104311:	83 ec 08             	sub    $0x8,%esp
80104314:	ff 75 0c             	push   0xc(%ebp)
80104317:	83 c0 04             	add    $0x4,%eax
8010431a:	50                   	push   %eax
8010431b:	e8 60 ff ff ff       	call   80104280 <fetchint>
}
80104320:	c9                   	leave  
80104321:	c3                   	ret    

80104322 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104322:	55                   	push   %ebp
80104323:	89 e5                	mov    %esp,%ebp
80104325:	56                   	push   %esi
80104326:	53                   	push   %ebx
80104327:	83 ec 10             	sub    $0x10,%esp
8010432a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010432d:	e8 97 ef ff ff       	call   801032c9 <myproc>
80104332:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104334:	83 ec 08             	sub    $0x8,%esp
80104337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010433a:	50                   	push   %eax
8010433b:	ff 75 08             	push   0x8(%ebp)
8010433e:	e8 b7 ff ff ff       	call   801042fa <argint>
80104343:	83 c4 10             	add    $0x10,%esp
80104346:	85 c0                	test   %eax,%eax
80104348:	78 24                	js     8010436e <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010434a:	85 db                	test   %ebx,%ebx
8010434c:	78 27                	js     80104375 <argptr+0x53>
8010434e:	8b 16                	mov    (%esi),%edx
80104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104353:	39 c2                	cmp    %eax,%edx
80104355:	76 25                	jbe    8010437c <argptr+0x5a>
80104357:	01 c3                	add    %eax,%ebx
80104359:	39 da                	cmp    %ebx,%edx
8010435b:	72 26                	jb     80104383 <argptr+0x61>
    return -1;
  *pp = (char*)i;
8010435d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104360:	89 02                	mov    %eax,(%edx)
  return 0;
80104362:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104367:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5d                   	pop    %ebp
8010436d:	c3                   	ret    
    return -1;
8010436e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104373:	eb f2                	jmp    80104367 <argptr+0x45>
    return -1;
80104375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437a:	eb eb                	jmp    80104367 <argptr+0x45>
8010437c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104381:	eb e4                	jmp    80104367 <argptr+0x45>
80104383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104388:	eb dd                	jmp    80104367 <argptr+0x45>

8010438a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010438a:	55                   	push   %ebp
8010438b:	89 e5                	mov    %esp,%ebp
8010438d:	83 ec 20             	sub    $0x20,%esp
             * If none of the above movements works then
             * BACKTRACK: unmark x, y as part of solution
             * path
             */
  int addr;
  if(argint(n, &addr) < 0)
80104390:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104393:	50                   	push   %eax
80104394:	ff 75 08             	push   0x8(%ebp)
80104397:	e8 5e ff ff ff       	call   801042fa <argint>
8010439c:	83 c4 10             	add    $0x10,%esp
8010439f:	85 c0                	test   %eax,%eax
801043a1:	78 13                	js     801043b6 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
801043a3:	83 ec 08             	sub    $0x8,%esp
801043a6:	ff 75 0c             	push   0xc(%ebp)
801043a9:	ff 75 f4             	push   -0xc(%ebp)
801043ac:	e8 0a ff ff ff       	call   801042bb <fetchstr>
801043b1:	83 c4 10             	add    $0x10,%esp
}
801043b4:	c9                   	leave  
801043b5:	c3                   	ret    
    return -1;
801043b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043bb:	eb f7                	jmp    801043b4 <argstr+0x2a>

801043bd <syscall>:
[SYS_holding_mylock]    sys_holding_mylock,
};

void
syscall(void)
{
801043bd:	55                   	push   %ebp
801043be:	89 e5                	mov    %esp,%ebp
801043c0:	53                   	push   %ebx
801043c1:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801043c4:	e8 00 ef ff ff       	call   801032c9 <myproc>
801043c9:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801043cb:	8b 40 18             	mov    0x18(%eax),%eax
801043ce:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801043d1:	8d 50 ff             	lea    -0x1(%eax),%edx
801043d4:	83 fa 28             	cmp    $0x28,%edx
801043d7:	77 17                	ja     801043f0 <syscall+0x33>
801043d9:	8b 14 85 60 73 10 80 	mov    -0x7fef8ca0(,%eax,4),%edx
801043e0:	85 d2                	test   %edx,%edx
801043e2:	74 0c                	je     801043f0 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
801043e4:	ff d2                	call   *%edx
801043e6:	89 c2                	mov    %eax,%edx
801043e8:	8b 43 18             	mov    0x18(%ebx),%eax
801043eb:	89 50 1c             	mov    %edx,0x1c(%eax)
801043ee:	eb 1f                	jmp    8010440f <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801043f0:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
801043f3:	50                   	push   %eax
801043f4:	52                   	push   %edx
801043f5:	ff 73 10             	push   0x10(%ebx)
801043f8:	68 43 73 10 80       	push   $0x80107343
801043fd:	e8 45 c2 ff ff       	call   80100647 <cprintf>
    curproc->tf->eax = -1;
80104402:	8b 43 18             	mov    0x18(%ebx),%eax
80104405:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010440c:	83 c4 10             	add    $0x10,%esp
  }
}
8010440f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104412:	c9                   	leave  
80104413:	c3                   	ret    

80104414 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	56                   	push   %esi
80104418:	53                   	push   %ebx
80104419:	83 ec 18             	sub    $0x18,%esp
8010441c:	89 d6                	mov    %edx,%esi
8010441e:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
80104420:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104423:	52                   	push   %edx
80104424:	50                   	push   %eax
80104425:	e8 d0 fe ff ff       	call   801042fa <argint>
8010442a:	83 c4 10             	add    $0x10,%esp
8010442d:	85 c0                	test   %eax,%eax
8010442f:	78 35                	js     80104466 <argfd+0x52>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80104431:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104435:	77 28                	ja     8010445f <argfd+0x4b>
80104437:	e8 8d ee ff ff       	call   801032c9 <myproc>
8010443c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010443f:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104443:	85 c0                	test   %eax,%eax
80104445:	74 18                	je     8010445f <argfd+0x4b>
    return -1;
  if (pfd)
80104447:	85 f6                	test   %esi,%esi
80104449:	74 02                	je     8010444d <argfd+0x39>
    *pfd = fd;
8010444b:	89 16                	mov    %edx,(%esi)
  if (pf)
8010444d:	85 db                	test   %ebx,%ebx
8010444f:	74 1c                	je     8010446d <argfd+0x59>
    *pf = f;
80104451:	89 03                	mov    %eax,(%ebx)
  return 0;
80104453:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445b:	5b                   	pop    %ebx
8010445c:	5e                   	pop    %esi
8010445d:	5d                   	pop    %ebp
8010445e:	c3                   	ret    
    return -1;
8010445f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104464:	eb f2                	jmp    80104458 <argfd+0x44>
    return -1;
80104466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010446b:	eb eb                	jmp    80104458 <argfd+0x44>
  return 0;
8010446d:	b8 00 00 00 00       	mov    $0x0,%eax
80104472:	eb e4                	jmp    80104458 <argfd+0x44>

80104474 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	53                   	push   %ebx
80104478:	83 ec 04             	sub    $0x4,%esp
8010447b:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010447d:	e8 47 ee ff ff       	call   801032c9 <myproc>
80104482:	89 c2                	mov    %eax,%edx

  for (fd = 0; fd < NOFILE; fd++)
80104484:	b8 00 00 00 00       	mov    $0x0,%eax
80104489:	83 f8 0f             	cmp    $0xf,%eax
8010448c:	7f 12                	jg     801044a0 <fdalloc+0x2c>
  {
    if (curproc->ofile[fd] == 0)
8010448e:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104493:	74 05                	je     8010449a <fdalloc+0x26>
  for (fd = 0; fd < NOFILE; fd++)
80104495:	83 c0 01             	add    $0x1,%eax
80104498:	eb ef                	jmp    80104489 <fdalloc+0x15>
    {
      curproc->ofile[fd] = f;
8010449a:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
8010449e:	eb 05                	jmp    801044a5 <fdalloc+0x31>
    }
  }
  return -1;
801044a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a8:	c9                   	leave  
801044a9:	c3                   	ret    

801044aa <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801044aa:	55                   	push   %ebp
801044ab:	89 e5                	mov    %esp,%ebp
801044ad:	56                   	push   %esi
801044ae:	53                   	push   %ebx
801044af:	83 ec 10             	sub    $0x10,%esp
801044b2:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801044b4:	b8 20 00 00 00       	mov    $0x20,%eax
801044b9:	89 c6                	mov    %eax,%esi
801044bb:	39 83 a8 00 00 00    	cmp    %eax,0xa8(%ebx)
801044c1:	76 2e                	jbe    801044f1 <isdirempty+0x47>
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801044c3:	6a 10                	push   $0x10
801044c5:	50                   	push   %eax
801044c6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801044c9:	50                   	push   %eax
801044ca:	53                   	push   %ebx
801044cb:	e8 4b d3 ff ff       	call   8010181b <readi>
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	83 f8 10             	cmp    $0x10,%eax
801044d6:	75 0c                	jne    801044e4 <isdirempty+0x3a>
      panic("isdirempty: readi");
    if (de.inum != 0)
801044d8:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801044dd:	75 1e                	jne    801044fd <isdirempty+0x53>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801044df:	8d 46 10             	lea    0x10(%esi),%eax
801044e2:	eb d5                	jmp    801044b9 <isdirempty+0xf>
      panic("isdirempty: readi");
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	68 08 74 10 80       	push   $0x80107408
801044ec:	e8 97 be ff ff       	call   80100388 <panic>
      return 0;
  }
  return 1;
801044f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801044f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044f9:	5b                   	pop    %ebx
801044fa:	5e                   	pop    %esi
801044fb:	5d                   	pop    %ebp
801044fc:	c3                   	ret    
      return 0;
801044fd:	b8 00 00 00 00       	mov    $0x0,%eax
80104502:	eb f2                	jmp    801044f6 <isdirempty+0x4c>

80104504 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	57                   	push   %edi
80104508:	56                   	push   %esi
80104509:	53                   	push   %ebx
8010450a:	83 ec 34             	sub    $0x34,%esp
8010450d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104510:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104513:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80104516:	8d 55 da             	lea    -0x26(%ebp),%edx
80104519:	52                   	push   %edx
8010451a:	50                   	push   %eax
8010451b:	e8 ac d7 ff ff       	call   80101ccc <nameiparent>
80104520:	89 c6                	mov    %eax,%esi
80104522:	83 c4 10             	add    $0x10,%esp
80104525:	85 c0                	test   %eax,%eax
80104527:	0f 84 45 01 00 00    	je     80104672 <create+0x16e>
    return 0;
  ilock(dp);
8010452d:	83 ec 0c             	sub    $0xc,%esp
80104530:	50                   	push   %eax
80104531:	e8 bd d0 ff ff       	call   801015f3 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80104536:	83 c4 0c             	add    $0xc,%esp
80104539:	6a 00                	push   $0x0
8010453b:	8d 45 da             	lea    -0x26(%ebp),%eax
8010453e:	50                   	push   %eax
8010453f:	56                   	push   %esi
80104540:	e8 35 d5 ff ff       	call   80101a7a <dirlookup>
80104545:	89 c3                	mov    %eax,%ebx
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	85 c0                	test   %eax,%eax
8010454c:	74 40                	je     8010458e <create+0x8a>
  {
    iunlockput(dp);
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	56                   	push   %esi
80104552:	e8 70 d2 ff ff       	call   801017c7 <iunlockput>
    ilock(ip);
80104557:	89 1c 24             	mov    %ebx,(%esp)
8010455a:	e8 94 d0 ff ff       	call   801015f3 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010455f:	83 c4 10             	add    $0x10,%esp
80104562:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104567:	75 0a                	jne    80104573 <create+0x6f>
80104569:	66 83 bb a0 00 00 00 	cmpw   $0x2,0xa0(%ebx)
80104570:	02 
80104571:	74 11                	je     80104584 <create+0x80>
      return ip;
    iunlockput(ip);
80104573:	83 ec 0c             	sub    $0xc,%esp
80104576:	53                   	push   %ebx
80104577:	e8 4b d2 ff ff       	call   801017c7 <iunlockput>
    return 0;
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104584:	89 d8                	mov    %ebx,%eax
80104586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5f                   	pop    %edi
8010458c:	5d                   	pop    %ebp
8010458d:	c3                   	ret    
  if ((ip = ialloc(dp->dev, type)) == 0)
8010458e:	83 ec 08             	sub    $0x8,%esp
80104591:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104595:	50                   	push   %eax
80104596:	ff 36                	push   (%esi)
80104598:	e8 2f ce ff ff       	call   801013cc <ialloc>
8010459d:	89 c3                	mov    %eax,%ebx
8010459f:	83 c4 10             	add    $0x10,%esp
801045a2:	85 c0                	test   %eax,%eax
801045a4:	74 5b                	je     80104601 <create+0xfd>
  ilock(ip);
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	50                   	push   %eax
801045aa:	e8 44 d0 ff ff       	call   801015f3 <ilock>
  ip->major = major;
801045af:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801045b3:	66 89 83 a2 00 00 00 	mov    %ax,0xa2(%ebx)
  ip->minor = minor;
801045ba:	66 89 bb a4 00 00 00 	mov    %di,0xa4(%ebx)
  ip->nlink = 1;
801045c1:	66 c7 83 a6 00 00 00 	movw   $0x1,0xa6(%ebx)
801045c8:	01 00 
  iupdate(ip);
801045ca:	89 1c 24             	mov    %ebx,(%esp)
801045cd:	e8 9f ce ff ff       	call   80101471 <iupdate>
  if (type == T_DIR)
801045d2:	83 c4 10             	add    $0x10,%esp
801045d5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801045da:	74 32                	je     8010460e <create+0x10a>
  if (dirlink(dp, name, ip->inum) < 0)
801045dc:	83 ec 04             	sub    $0x4,%esp
801045df:	ff 73 04             	push   0x4(%ebx)
801045e2:	8d 45 da             	lea    -0x26(%ebp),%eax
801045e5:	50                   	push   %eax
801045e6:	56                   	push   %esi
801045e7:	e8 14 d6 ff ff       	call   80101c00 <dirlink>
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	85 c0                	test   %eax,%eax
801045f1:	78 72                	js     80104665 <create+0x161>
  iunlockput(dp);
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	56                   	push   %esi
801045f7:	e8 cb d1 ff ff       	call   801017c7 <iunlockput>
  return ip;
801045fc:	83 c4 10             	add    $0x10,%esp
801045ff:	eb 83                	jmp    80104584 <create+0x80>
    panic("create: ialloc");
80104601:	83 ec 0c             	sub    $0xc,%esp
80104604:	68 1a 74 10 80       	push   $0x8010741a
80104609:	e8 7a bd ff ff       	call   80100388 <panic>
    dp->nlink++; // for ".."
8010460e:	0f b7 86 a6 00 00 00 	movzwl 0xa6(%esi),%eax
80104615:	83 c0 01             	add    $0x1,%eax
80104618:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
    iupdate(dp);
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	56                   	push   %esi
80104623:	e8 49 ce ff ff       	call   80101471 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104628:	83 c4 0c             	add    $0xc,%esp
8010462b:	ff 73 04             	push   0x4(%ebx)
8010462e:	68 2a 74 10 80       	push   $0x8010742a
80104633:	53                   	push   %ebx
80104634:	e8 c7 d5 ff ff       	call   80101c00 <dirlink>
80104639:	83 c4 10             	add    $0x10,%esp
8010463c:	85 c0                	test   %eax,%eax
8010463e:	78 18                	js     80104658 <create+0x154>
80104640:	83 ec 04             	sub    $0x4,%esp
80104643:	ff 76 04             	push   0x4(%esi)
80104646:	68 29 74 10 80       	push   $0x80107429
8010464b:	53                   	push   %ebx
8010464c:	e8 af d5 ff ff       	call   80101c00 <dirlink>
80104651:	83 c4 10             	add    $0x10,%esp
80104654:	85 c0                	test   %eax,%eax
80104656:	79 84                	jns    801045dc <create+0xd8>
      panic("create dots");
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 2c 74 10 80       	push   $0x8010742c
80104660:	e8 23 bd ff ff       	call   80100388 <panic>
    panic("create: dirlink");
80104665:	83 ec 0c             	sub    $0xc,%esp
80104668:	68 38 74 10 80       	push   $0x80107438
8010466d:	e8 16 bd ff ff       	call   80100388 <panic>
    return 0;
80104672:	89 c3                	mov    %eax,%ebx
80104674:	e9 0b ff ff ff       	jmp    80104584 <create+0x80>

80104679 <sys_dup>:
{
80104679:	55                   	push   %ebp
8010467a:	89 e5                	mov    %esp,%ebp
8010467c:	53                   	push   %ebx
8010467d:	83 ec 14             	sub    $0x14,%esp
  if (argfd(0, 0, &f) < 0)
80104680:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104683:	ba 00 00 00 00       	mov    $0x0,%edx
80104688:	b8 00 00 00 00       	mov    $0x0,%eax
8010468d:	e8 82 fd ff ff       	call   80104414 <argfd>
80104692:	85 c0                	test   %eax,%eax
80104694:	78 23                	js     801046b9 <sys_dup+0x40>
  if ((fd = fdalloc(f)) < 0)
80104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104699:	e8 d6 fd ff ff       	call   80104474 <fdalloc>
8010469e:	89 c3                	mov    %eax,%ebx
801046a0:	85 c0                	test   %eax,%eax
801046a2:	78 1c                	js     801046c0 <sys_dup+0x47>
  filedup(f);
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	ff 75 f4             	push   -0xc(%ebp)
801046aa:	e8 0f c6 ff ff       	call   80100cbe <filedup>
  return fd;
801046af:	83 c4 10             	add    $0x10,%esp
}
801046b2:	89 d8                	mov    %ebx,%eax
801046b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b7:	c9                   	leave  
801046b8:	c3                   	ret    
    return -1;
801046b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046be:	eb f2                	jmp    801046b2 <sys_dup+0x39>
    return -1;
801046c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046c5:	eb eb                	jmp    801046b2 <sys_dup+0x39>

801046c7 <sys_read>:
{
801046c7:	55                   	push   %ebp
801046c8:	89 e5                	mov    %esp,%ebp
801046ca:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801046cd:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801046d0:	ba 00 00 00 00       	mov    $0x0,%edx
801046d5:	b8 00 00 00 00       	mov    $0x0,%eax
801046da:	e8 35 fd ff ff       	call   80104414 <argfd>
801046df:	85 c0                	test   %eax,%eax
801046e1:	78 43                	js     80104726 <sys_read+0x5f>
801046e3:	83 ec 08             	sub    $0x8,%esp
801046e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046e9:	50                   	push   %eax
801046ea:	6a 02                	push   $0x2
801046ec:	e8 09 fc ff ff       	call   801042fa <argint>
801046f1:	83 c4 10             	add    $0x10,%esp
801046f4:	85 c0                	test   %eax,%eax
801046f6:	78 2e                	js     80104726 <sys_read+0x5f>
801046f8:	83 ec 04             	sub    $0x4,%esp
801046fb:	ff 75 f0             	push   -0x10(%ebp)
801046fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104701:	50                   	push   %eax
80104702:	6a 01                	push   $0x1
80104704:	e8 19 fc ff ff       	call   80104322 <argptr>
80104709:	83 c4 10             	add    $0x10,%esp
8010470c:	85 c0                	test   %eax,%eax
8010470e:	78 16                	js     80104726 <sys_read+0x5f>
  return fileread(f, p, n);
80104710:	83 ec 04             	sub    $0x4,%esp
80104713:	ff 75 f0             	push   -0x10(%ebp)
80104716:	ff 75 ec             	push   -0x14(%ebp)
80104719:	ff 75 f4             	push   -0xc(%ebp)
8010471c:	e8 ef c6 ff ff       	call   80100e10 <fileread>
80104721:	83 c4 10             	add    $0x10,%esp
}
80104724:	c9                   	leave  
80104725:	c3                   	ret    
    return -1;
80104726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472b:	eb f7                	jmp    80104724 <sys_read+0x5d>

8010472d <sys_write>:
{
8010472d:	55                   	push   %ebp
8010472e:	89 e5                	mov    %esp,%ebp
80104730:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104733:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104736:	ba 00 00 00 00       	mov    $0x0,%edx
8010473b:	b8 00 00 00 00       	mov    $0x0,%eax
80104740:	e8 cf fc ff ff       	call   80104414 <argfd>
80104745:	85 c0                	test   %eax,%eax
80104747:	78 43                	js     8010478c <sys_write+0x5f>
80104749:	83 ec 08             	sub    $0x8,%esp
8010474c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010474f:	50                   	push   %eax
80104750:	6a 02                	push   $0x2
80104752:	e8 a3 fb ff ff       	call   801042fa <argint>
80104757:	83 c4 10             	add    $0x10,%esp
8010475a:	85 c0                	test   %eax,%eax
8010475c:	78 2e                	js     8010478c <sys_write+0x5f>
8010475e:	83 ec 04             	sub    $0x4,%esp
80104761:	ff 75 f0             	push   -0x10(%ebp)
80104764:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104767:	50                   	push   %eax
80104768:	6a 01                	push   $0x1
8010476a:	e8 b3 fb ff ff       	call   80104322 <argptr>
8010476f:	83 c4 10             	add    $0x10,%esp
80104772:	85 c0                	test   %eax,%eax
80104774:	78 16                	js     8010478c <sys_write+0x5f>
  return filewrite(f, p, n);
80104776:	83 ec 04             	sub    $0x4,%esp
80104779:	ff 75 f0             	push   -0x10(%ebp)
8010477c:	ff 75 ec             	push   -0x14(%ebp)
8010477f:	ff 75 f4             	push   -0xc(%ebp)
80104782:	e8 0e c7 ff ff       	call   80100e95 <filewrite>
80104787:	83 c4 10             	add    $0x10,%esp
}
8010478a:	c9                   	leave  
8010478b:	c3                   	ret    
    return -1;
8010478c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104791:	eb f7                	jmp    8010478a <sys_write+0x5d>

80104793 <sys_close>:
{
80104793:	55                   	push   %ebp
80104794:	89 e5                	mov    %esp,%ebp
80104796:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
80104799:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010479c:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010479f:	b8 00 00 00 00       	mov    $0x0,%eax
801047a4:	e8 6b fc ff ff       	call   80104414 <argfd>
801047a9:	85 c0                	test   %eax,%eax
801047ab:	78 25                	js     801047d2 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801047ad:	e8 17 eb ff ff       	call   801032c9 <myproc>
801047b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047b5:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801047bc:	00 
  fileclose(f);
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	ff 75 f0             	push   -0x10(%ebp)
801047c3:	e8 3b c5 ff ff       	call   80100d03 <fileclose>
  return 0;
801047c8:	83 c4 10             	add    $0x10,%esp
801047cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047d0:	c9                   	leave  
801047d1:	c3                   	ret    
    return -1;
801047d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d7:	eb f7                	jmp    801047d0 <sys_close+0x3d>

801047d9 <sys_fstat>:
{
801047d9:	55                   	push   %ebp
801047da:	89 e5                	mov    %esp,%ebp
801047dc:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
801047df:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801047e2:	ba 00 00 00 00       	mov    $0x0,%edx
801047e7:	b8 00 00 00 00       	mov    $0x0,%eax
801047ec:	e8 23 fc ff ff       	call   80104414 <argfd>
801047f1:	85 c0                	test   %eax,%eax
801047f3:	78 2a                	js     8010481f <sys_fstat+0x46>
801047f5:	83 ec 04             	sub    $0x4,%esp
801047f8:	6a 14                	push   $0x14
801047fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047fd:	50                   	push   %eax
801047fe:	6a 01                	push   $0x1
80104800:	e8 1d fb ff ff       	call   80104322 <argptr>
80104805:	83 c4 10             	add    $0x10,%esp
80104808:	85 c0                	test   %eax,%eax
8010480a:	78 13                	js     8010481f <sys_fstat+0x46>
  return filestat(f, st);
8010480c:	83 ec 08             	sub    $0x8,%esp
8010480f:	ff 75 f0             	push   -0x10(%ebp)
80104812:	ff 75 f4             	push   -0xc(%ebp)
80104815:	e8 af c5 ff ff       	call   80100dc9 <filestat>
8010481a:	83 c4 10             	add    $0x10,%esp
}
8010481d:	c9                   	leave  
8010481e:	c3                   	ret    
    return -1;
8010481f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104824:	eb f7                	jmp    8010481d <sys_fstat+0x44>

80104826 <sys_link>:
{
80104826:	55                   	push   %ebp
80104827:	89 e5                	mov    %esp,%ebp
80104829:	56                   	push   %esi
8010482a:	53                   	push   %ebx
8010482b:	83 ec 28             	sub    $0x28,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010482e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104831:	50                   	push   %eax
80104832:	6a 00                	push   $0x0
80104834:	e8 51 fb ff ff       	call   8010438a <argstr>
80104839:	83 c4 10             	add    $0x10,%esp
8010483c:	85 c0                	test   %eax,%eax
8010483e:	0f 88 dc 00 00 00    	js     80104920 <sys_link+0xfa>
80104844:	83 ec 08             	sub    $0x8,%esp
80104847:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010484a:	50                   	push   %eax
8010484b:	6a 01                	push   $0x1
8010484d:	e8 38 fb ff ff       	call   8010438a <argstr>
80104852:	83 c4 10             	add    $0x10,%esp
80104855:	85 c0                	test   %eax,%eax
80104857:	0f 88 c3 00 00 00    	js     80104920 <sys_link+0xfa>
  begin_op();
8010485d:	e8 2a e0 ff ff       	call   8010288c <begin_op>
  if ((ip = namei(old)) == 0)
80104862:	83 ec 0c             	sub    $0xc,%esp
80104865:	ff 75 e0             	push   -0x20(%ebp)
80104868:	e8 47 d4 ff ff       	call   80101cb4 <namei>
8010486d:	89 c3                	mov    %eax,%ebx
8010486f:	83 c4 10             	add    $0x10,%esp
80104872:	85 c0                	test   %eax,%eax
80104874:	0f 84 ad 00 00 00    	je     80104927 <sys_link+0x101>
  ilock(ip);
8010487a:	83 ec 0c             	sub    $0xc,%esp
8010487d:	50                   	push   %eax
8010487e:	e8 70 cd ff ff       	call   801015f3 <ilock>
  if (ip->type == T_DIR)
80104883:	83 c4 10             	add    $0x10,%esp
80104886:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
8010488d:	01 
8010488e:	0f 84 9f 00 00 00    	je     80104933 <sys_link+0x10d>
  ip->nlink++;
80104894:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
8010489b:	83 c0 01             	add    $0x1,%eax
8010489e:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
801048a5:	83 ec 0c             	sub    $0xc,%esp
801048a8:	53                   	push   %ebx
801048a9:	e8 c3 cb ff ff       	call   80101471 <iupdate>
  iunlock(ip);
801048ae:	89 1c 24             	mov    %ebx,(%esp)
801048b1:	e8 1d ce ff ff       	call   801016d3 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
801048b6:	83 c4 08             	add    $0x8,%esp
801048b9:	8d 45 ea             	lea    -0x16(%ebp),%eax
801048bc:	50                   	push   %eax
801048bd:	ff 75 e4             	push   -0x1c(%ebp)
801048c0:	e8 07 d4 ff ff       	call   80101ccc <nameiparent>
801048c5:	89 c6                	mov    %eax,%esi
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	85 c0                	test   %eax,%eax
801048cc:	0f 84 85 00 00 00    	je     80104957 <sys_link+0x131>
  ilock(dp);
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	50                   	push   %eax
801048d6:	e8 18 cd ff ff       	call   801015f3 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
801048db:	83 c4 10             	add    $0x10,%esp
801048de:	8b 03                	mov    (%ebx),%eax
801048e0:	39 06                	cmp    %eax,(%esi)
801048e2:	75 67                	jne    8010494b <sys_link+0x125>
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	ff 73 04             	push   0x4(%ebx)
801048ea:	8d 45 ea             	lea    -0x16(%ebp),%eax
801048ed:	50                   	push   %eax
801048ee:	56                   	push   %esi
801048ef:	e8 0c d3 ff ff       	call   80101c00 <dirlink>
801048f4:	83 c4 10             	add    $0x10,%esp
801048f7:	85 c0                	test   %eax,%eax
801048f9:	78 50                	js     8010494b <sys_link+0x125>
  iunlockput(dp);
801048fb:	83 ec 0c             	sub    $0xc,%esp
801048fe:	56                   	push   %esi
801048ff:	e8 c3 ce ff ff       	call   801017c7 <iunlockput>
  iput(ip);
80104904:	89 1c 24             	mov    %ebx,(%esp)
80104907:	e8 0c ce ff ff       	call   80101718 <iput>
  end_op();
8010490c:	e8 f5 df ff ff       	call   80102906 <end_op>
  return 0;
80104911:	83 c4 10             	add    $0x10,%esp
80104914:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010491c:	5b                   	pop    %ebx
8010491d:	5e                   	pop    %esi
8010491e:	5d                   	pop    %ebp
8010491f:	c3                   	ret    
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104925:	eb f2                	jmp    80104919 <sys_link+0xf3>
    end_op();
80104927:	e8 da df ff ff       	call   80102906 <end_op>
    return -1;
8010492c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104931:	eb e6                	jmp    80104919 <sys_link+0xf3>
    iunlockput(ip);
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	53                   	push   %ebx
80104937:	e8 8b ce ff ff       	call   801017c7 <iunlockput>
    end_op();
8010493c:	e8 c5 df ff ff       	call   80102906 <end_op>
    return -1;
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104949:	eb ce                	jmp    80104919 <sys_link+0xf3>
    iunlockput(dp);
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	56                   	push   %esi
8010494f:	e8 73 ce ff ff       	call   801017c7 <iunlockput>
    goto bad;
80104954:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104957:	83 ec 0c             	sub    $0xc,%esp
8010495a:	53                   	push   %ebx
8010495b:	e8 93 cc ff ff       	call   801015f3 <ilock>
  ip->nlink--;
80104960:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
80104967:	83 e8 01             	sub    $0x1,%eax
8010496a:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
80104971:	89 1c 24             	mov    %ebx,(%esp)
80104974:	e8 f8 ca ff ff       	call   80101471 <iupdate>
  iunlockput(ip);
80104979:	89 1c 24             	mov    %ebx,(%esp)
8010497c:	e8 46 ce ff ff       	call   801017c7 <iunlockput>
  end_op();
80104981:	e8 80 df ff ff       	call   80102906 <end_op>
  return -1;
80104986:	83 c4 10             	add    $0x10,%esp
80104989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010498e:	eb 89                	jmp    80104919 <sys_link+0xf3>

80104990 <sys_unlink>:
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	83 ec 44             	sub    $0x44,%esp
  if (argstr(0, &path) < 0)
80104999:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010499c:	50                   	push   %eax
8010499d:	6a 00                	push   $0x0
8010499f:	e8 e6 f9 ff ff       	call   8010438a <argstr>
801049a4:	83 c4 10             	add    $0x10,%esp
801049a7:	85 c0                	test   %eax,%eax
801049a9:	0f 88 98 01 00 00    	js     80104b47 <sys_unlink+0x1b7>
  begin_op();
801049af:	e8 d8 de ff ff       	call   8010288c <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
801049b4:	83 ec 08             	sub    $0x8,%esp
801049b7:	8d 45 ca             	lea    -0x36(%ebp),%eax
801049ba:	50                   	push   %eax
801049bb:	ff 75 c4             	push   -0x3c(%ebp)
801049be:	e8 09 d3 ff ff       	call   80101ccc <nameiparent>
801049c3:	89 c6                	mov    %eax,%esi
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	85 c0                	test   %eax,%eax
801049ca:	0f 84 fc 00 00 00    	je     80104acc <sys_unlink+0x13c>
  ilock(dp);
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	50                   	push   %eax
801049d4:	e8 1a cc ff ff       	call   801015f3 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801049d9:	83 c4 08             	add    $0x8,%esp
801049dc:	68 2a 74 10 80       	push   $0x8010742a
801049e1:	8d 45 ca             	lea    -0x36(%ebp),%eax
801049e4:	50                   	push   %eax
801049e5:	e8 7b d0 ff ff       	call   80101a65 <namecmp>
801049ea:	83 c4 10             	add    $0x10,%esp
801049ed:	85 c0                	test   %eax,%eax
801049ef:	0f 84 0b 01 00 00    	je     80104b00 <sys_unlink+0x170>
801049f5:	83 ec 08             	sub    $0x8,%esp
801049f8:	68 29 74 10 80       	push   $0x80107429
801049fd:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a00:	50                   	push   %eax
80104a01:	e8 5f d0 ff ff       	call   80101a65 <namecmp>
80104a06:	83 c4 10             	add    $0x10,%esp
80104a09:	85 c0                	test   %eax,%eax
80104a0b:	0f 84 ef 00 00 00    	je     80104b00 <sys_unlink+0x170>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80104a11:	83 ec 04             	sub    $0x4,%esp
80104a14:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a17:	50                   	push   %eax
80104a18:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104a1b:	50                   	push   %eax
80104a1c:	56                   	push   %esi
80104a1d:	e8 58 d0 ff ff       	call   80101a7a <dirlookup>
80104a22:	89 c3                	mov    %eax,%ebx
80104a24:	83 c4 10             	add    $0x10,%esp
80104a27:	85 c0                	test   %eax,%eax
80104a29:	0f 84 d1 00 00 00    	je     80104b00 <sys_unlink+0x170>
  ilock(ip);
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	50                   	push   %eax
80104a33:	e8 bb cb ff ff       	call   801015f3 <ilock>
  if (ip->nlink < 1)
80104a38:	83 c4 10             	add    $0x10,%esp
80104a3b:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
80104a42:	00 
80104a43:	0f 8e 8f 00 00 00    	jle    80104ad8 <sys_unlink+0x148>
  if (ip->type == T_DIR && !isdirempty(ip))
80104a49:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80104a50:	01 
80104a51:	0f 84 8e 00 00 00    	je     80104ae5 <sys_unlink+0x155>
  memset(&de, 0, sizeof(de));
80104a57:	83 ec 04             	sub    $0x4,%esp
80104a5a:	6a 10                	push   $0x10
80104a5c:	6a 00                	push   $0x0
80104a5e:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104a61:	57                   	push   %edi
80104a62:	e8 43 f6 ff ff       	call   801040aa <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80104a67:	6a 10                	push   $0x10
80104a69:	ff 75 c0             	push   -0x40(%ebp)
80104a6c:	57                   	push   %edi
80104a6d:	56                   	push   %esi
80104a6e:	e8 b1 ce ff ff       	call   80101924 <writei>
80104a73:	83 c4 20             	add    $0x20,%esp
80104a76:	83 f8 10             	cmp    $0x10,%eax
80104a79:	0f 85 99 00 00 00    	jne    80104b18 <sys_unlink+0x188>
  if (ip->type == T_DIR)
80104a7f:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80104a86:	01 
80104a87:	0f 84 98 00 00 00    	je     80104b25 <sys_unlink+0x195>
  iunlockput(dp);
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	56                   	push   %esi
80104a91:	e8 31 cd ff ff       	call   801017c7 <iunlockput>
  ip->nlink--;
80104a96:	0f b7 83 a6 00 00 00 	movzwl 0xa6(%ebx),%eax
80104a9d:	83 e8 01             	sub    $0x1,%eax
80104aa0:	66 89 83 a6 00 00 00 	mov    %ax,0xa6(%ebx)
  iupdate(ip);
80104aa7:	89 1c 24             	mov    %ebx,(%esp)
80104aaa:	e8 c2 c9 ff ff       	call   80101471 <iupdate>
  iunlockput(ip);
80104aaf:	89 1c 24             	mov    %ebx,(%esp)
80104ab2:	e8 10 cd ff ff       	call   801017c7 <iunlockput>
  end_op();
80104ab7:	e8 4a de ff ff       	call   80102906 <end_op>
  return 0;
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac7:	5b                   	pop    %ebx
80104ac8:	5e                   	pop    %esi
80104ac9:	5f                   	pop    %edi
80104aca:	5d                   	pop    %ebp
80104acb:	c3                   	ret    
    end_op();
80104acc:	e8 35 de ff ff       	call   80102906 <end_op>
    return -1;
80104ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad6:	eb ec                	jmp    80104ac4 <sys_unlink+0x134>
    panic("unlink: nlink < 1");
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	68 48 74 10 80       	push   $0x80107448
80104ae0:	e8 a3 b8 ff ff       	call   80100388 <panic>
  if (ip->type == T_DIR && !isdirempty(ip))
80104ae5:	89 d8                	mov    %ebx,%eax
80104ae7:	e8 be f9 ff ff       	call   801044aa <isdirempty>
80104aec:	85 c0                	test   %eax,%eax
80104aee:	0f 85 63 ff ff ff    	jne    80104a57 <sys_unlink+0xc7>
    iunlockput(ip);
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	53                   	push   %ebx
80104af8:	e8 ca cc ff ff       	call   801017c7 <iunlockput>
    goto bad;
80104afd:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	56                   	push   %esi
80104b04:	e8 be cc ff ff       	call   801017c7 <iunlockput>
  end_op();
80104b09:	e8 f8 dd ff ff       	call   80102906 <end_op>
  return -1;
80104b0e:	83 c4 10             	add    $0x10,%esp
80104b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b16:	eb ac                	jmp    80104ac4 <sys_unlink+0x134>
    panic("unlink: writei");
80104b18:	83 ec 0c             	sub    $0xc,%esp
80104b1b:	68 5a 74 10 80       	push   $0x8010745a
80104b20:	e8 63 b8 ff ff       	call   80100388 <panic>
    dp->nlink--;
80104b25:	0f b7 86 a6 00 00 00 	movzwl 0xa6(%esi),%eax
80104b2c:	83 e8 01             	sub    $0x1,%eax
80104b2f:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
    iupdate(dp);
80104b36:	83 ec 0c             	sub    $0xc,%esp
80104b39:	56                   	push   %esi
80104b3a:	e8 32 c9 ff ff       	call   80101471 <iupdate>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	e9 46 ff ff ff       	jmp    80104a8d <sys_unlink+0xfd>
    return -1;
80104b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b4c:	e9 73 ff ff ff       	jmp    80104ac4 <sys_unlink+0x134>

80104b51 <sys_open>:

int sys_open(void)
{
80104b51:	55                   	push   %ebp
80104b52:	89 e5                	mov    %esp,%ebp
80104b54:	57                   	push   %edi
80104b55:	56                   	push   %esi
80104b56:	53                   	push   %ebx
80104b57:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104b5a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104b5d:	50                   	push   %eax
80104b5e:	6a 00                	push   $0x0
80104b60:	e8 25 f8 ff ff       	call   8010438a <argstr>
80104b65:	83 c4 10             	add    $0x10,%esp
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	0f 88 a0 00 00 00    	js     80104c10 <sys_open+0xbf>
80104b70:	83 ec 08             	sub    $0x8,%esp
80104b73:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104b76:	50                   	push   %eax
80104b77:	6a 01                	push   $0x1
80104b79:	e8 7c f7 ff ff       	call   801042fa <argint>
80104b7e:	83 c4 10             	add    $0x10,%esp
80104b81:	85 c0                	test   %eax,%eax
80104b83:	0f 88 87 00 00 00    	js     80104c10 <sys_open+0xbf>
    return -1;

  begin_op();
80104b89:	e8 fe dc ff ff       	call   8010288c <begin_op>

  if (omode & O_CREATE)
80104b8e:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104b92:	0f 84 8b 00 00 00    	je     80104c23 <sys_open+0xd2>
  {
    ip = create(path, T_FILE, 0, 0);
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	6a 00                	push   $0x0
80104b9d:	b9 00 00 00 00       	mov    $0x0,%ecx
80104ba2:	ba 02 00 00 00       	mov    $0x2,%edx
80104ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104baa:	e8 55 f9 ff ff       	call   80104504 <create>
80104baf:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80104bb1:	83 c4 10             	add    $0x10,%esp
80104bb4:	85 c0                	test   %eax,%eax
80104bb6:	74 5f                	je     80104c17 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80104bb8:	e8 a0 c0 ff ff       	call   80100c5d <filealloc>
80104bbd:	89 c3                	mov    %eax,%ebx
80104bbf:	85 c0                	test   %eax,%eax
80104bc1:	0f 84 b8 00 00 00    	je     80104c7f <sys_open+0x12e>
80104bc7:	e8 a8 f8 ff ff       	call   80104474 <fdalloc>
80104bcc:	89 c7                	mov    %eax,%edi
80104bce:	85 c0                	test   %eax,%eax
80104bd0:	0f 88 a9 00 00 00    	js     80104c7f <sys_open+0x12e>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104bd6:	83 ec 0c             	sub    $0xc,%esp
80104bd9:	56                   	push   %esi
80104bda:	e8 f4 ca ff ff       	call   801016d3 <iunlock>
  end_op();
80104bdf:	e8 22 dd ff ff       	call   80102906 <end_op>

  f->type = FD_INODE;
80104be4:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104bea:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104bed:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bf7:	83 c4 10             	add    $0x10,%esp
80104bfa:	a8 01                	test   $0x1,%al
80104bfc:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104c00:	a8 03                	test   $0x3,%al
80104c02:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104c06:	89 f8                	mov    %edi,%eax
80104c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c0b:	5b                   	pop    %ebx
80104c0c:	5e                   	pop    %esi
80104c0d:	5f                   	pop    %edi
80104c0e:	5d                   	pop    %ebp
80104c0f:	c3                   	ret    
    return -1;
80104c10:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c15:	eb ef                	jmp    80104c06 <sys_open+0xb5>
      end_op();
80104c17:	e8 ea dc ff ff       	call   80102906 <end_op>
      return -1;
80104c1c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c21:	eb e3                	jmp    80104c06 <sys_open+0xb5>
    if ((ip = namei(path)) == 0)
80104c23:	83 ec 0c             	sub    $0xc,%esp
80104c26:	ff 75 e4             	push   -0x1c(%ebp)
80104c29:	e8 86 d0 ff ff       	call   80101cb4 <namei>
80104c2e:	89 c6                	mov    %eax,%esi
80104c30:	83 c4 10             	add    $0x10,%esp
80104c33:	85 c0                	test   %eax,%eax
80104c35:	74 3c                	je     80104c73 <sys_open+0x122>
    ilock(ip);
80104c37:	83 ec 0c             	sub    $0xc,%esp
80104c3a:	50                   	push   %eax
80104c3b:	e8 b3 c9 ff ff       	call   801015f3 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80104c40:	83 c4 10             	add    $0x10,%esp
80104c43:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80104c4a:	01 
80104c4b:	0f 85 67 ff ff ff    	jne    80104bb8 <sys_open+0x67>
80104c51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104c55:	0f 84 5d ff ff ff    	je     80104bb8 <sys_open+0x67>
      iunlockput(ip);
80104c5b:	83 ec 0c             	sub    $0xc,%esp
80104c5e:	56                   	push   %esi
80104c5f:	e8 63 cb ff ff       	call   801017c7 <iunlockput>
      end_op();
80104c64:	e8 9d dc ff ff       	call   80102906 <end_op>
      return -1;
80104c69:	83 c4 10             	add    $0x10,%esp
80104c6c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c71:	eb 93                	jmp    80104c06 <sys_open+0xb5>
      end_op();
80104c73:	e8 8e dc ff ff       	call   80102906 <end_op>
      return -1;
80104c78:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104c7d:	eb 87                	jmp    80104c06 <sys_open+0xb5>
    if (f)
80104c7f:	85 db                	test   %ebx,%ebx
80104c81:	74 0c                	je     80104c8f <sys_open+0x13e>
      fileclose(f);
80104c83:	83 ec 0c             	sub    $0xc,%esp
80104c86:	53                   	push   %ebx
80104c87:	e8 77 c0 ff ff       	call   80100d03 <fileclose>
80104c8c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	56                   	push   %esi
80104c93:	e8 2f cb ff ff       	call   801017c7 <iunlockput>
    end_op();
80104c98:	e8 69 dc ff ff       	call   80102906 <end_op>
    return -1;
80104c9d:	83 c4 10             	add    $0x10,%esp
80104ca0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ca5:	e9 5c ff ff ff       	jmp    80104c06 <sys_open+0xb5>

80104caa <sys_mkdir>:

int sys_mkdir(void)
{
80104caa:	55                   	push   %ebp
80104cab:	89 e5                	mov    %esp,%ebp
80104cad:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104cb0:	e8 d7 db ff ff       	call   8010288c <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80104cb5:	83 ec 08             	sub    $0x8,%esp
80104cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cbb:	50                   	push   %eax
80104cbc:	6a 00                	push   $0x0
80104cbe:	e8 c7 f6 ff ff       	call   8010438a <argstr>
80104cc3:	83 c4 10             	add    $0x10,%esp
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	78 36                	js     80104d00 <sys_mkdir+0x56>
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	6a 00                	push   $0x0
80104ccf:	b9 00 00 00 00       	mov    $0x0,%ecx
80104cd4:	ba 01 00 00 00       	mov    $0x1,%edx
80104cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdc:	e8 23 f8 ff ff       	call   80104504 <create>
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	74 18                	je     80104d00 <sys_mkdir+0x56>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ce8:	83 ec 0c             	sub    $0xc,%esp
80104ceb:	50                   	push   %eax
80104cec:	e8 d6 ca ff ff       	call   801017c7 <iunlockput>
  end_op();
80104cf1:	e8 10 dc ff ff       	call   80102906 <end_op>
  return 0;
80104cf6:	83 c4 10             	add    $0x10,%esp
80104cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cfe:	c9                   	leave  
80104cff:	c3                   	ret    
    end_op();
80104d00:	e8 01 dc ff ff       	call   80102906 <end_op>
    return -1;
80104d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0a:	eb f2                	jmp    80104cfe <sys_mkdir+0x54>

80104d0c <sys_mknod>:

int sys_mknod(void)
{
80104d0c:	55                   	push   %ebp
80104d0d:	89 e5                	mov    %esp,%ebp
80104d0f:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104d12:	e8 75 db ff ff       	call   8010288c <begin_op>
  if ((argstr(0, &path)) < 0 ||
80104d17:	83 ec 08             	sub    $0x8,%esp
80104d1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d1d:	50                   	push   %eax
80104d1e:	6a 00                	push   $0x0
80104d20:	e8 65 f6 ff ff       	call   8010438a <argstr>
80104d25:	83 c4 10             	add    $0x10,%esp
80104d28:	85 c0                	test   %eax,%eax
80104d2a:	78 62                	js     80104d8e <sys_mknod+0x82>
      argint(1, &major) < 0 ||
80104d2c:	83 ec 08             	sub    $0x8,%esp
80104d2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d32:	50                   	push   %eax
80104d33:	6a 01                	push   $0x1
80104d35:	e8 c0 f5 ff ff       	call   801042fa <argint>
  if ((argstr(0, &path)) < 0 ||
80104d3a:	83 c4 10             	add    $0x10,%esp
80104d3d:	85 c0                	test   %eax,%eax
80104d3f:	78 4d                	js     80104d8e <sys_mknod+0x82>
      argint(2, &minor) < 0 ||
80104d41:	83 ec 08             	sub    $0x8,%esp
80104d44:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104d47:	50                   	push   %eax
80104d48:	6a 02                	push   $0x2
80104d4a:	e8 ab f5 ff ff       	call   801042fa <argint>
      argint(1, &major) < 0 ||
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 38                	js     80104d8e <sys_mknod+0x82>
      (ip = create(path, T_DEV, major, minor)) == 0)
80104d56:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104d61:	50                   	push   %eax
80104d62:	ba 03 00 00 00       	mov    $0x3,%edx
80104d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6a:	e8 95 f7 ff ff       	call   80104504 <create>
      argint(2, &minor) < 0 ||
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	85 c0                	test   %eax,%eax
80104d74:	74 18                	je     80104d8e <sys_mknod+0x82>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104d76:	83 ec 0c             	sub    $0xc,%esp
80104d79:	50                   	push   %eax
80104d7a:	e8 48 ca ff ff       	call   801017c7 <iunlockput>
  end_op();
80104d7f:	e8 82 db ff ff       	call   80102906 <end_op>
  return 0;
80104d84:	83 c4 10             	add    $0x10,%esp
80104d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d8c:	c9                   	leave  
80104d8d:	c3                   	ret    
    end_op();
80104d8e:	e8 73 db ff ff       	call   80102906 <end_op>
    return -1;
80104d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d98:	eb f2                	jmp    80104d8c <sys_mknod+0x80>

80104d9a <sys_chdir>:

int sys_chdir(void)
{
80104d9a:	55                   	push   %ebp
80104d9b:	89 e5                	mov    %esp,%ebp
80104d9d:	56                   	push   %esi
80104d9e:	53                   	push   %ebx
80104d9f:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104da2:	e8 22 e5 ff ff       	call   801032c9 <myproc>
80104da7:	89 c6                	mov    %eax,%esi

  begin_op();
80104da9:	e8 de da ff ff       	call   8010288c <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104dae:	83 ec 08             	sub    $0x8,%esp
80104db1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104db4:	50                   	push   %eax
80104db5:	6a 00                	push   $0x0
80104db7:	e8 ce f5 ff ff       	call   8010438a <argstr>
80104dbc:	83 c4 10             	add    $0x10,%esp
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	78 55                	js     80104e18 <sys_chdir+0x7e>
80104dc3:	83 ec 0c             	sub    $0xc,%esp
80104dc6:	ff 75 f4             	push   -0xc(%ebp)
80104dc9:	e8 e6 ce ff ff       	call   80101cb4 <namei>
80104dce:	89 c3                	mov    %eax,%ebx
80104dd0:	83 c4 10             	add    $0x10,%esp
80104dd3:	85 c0                	test   %eax,%eax
80104dd5:	74 41                	je     80104e18 <sys_chdir+0x7e>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80104dd7:	83 ec 0c             	sub    $0xc,%esp
80104dda:	50                   	push   %eax
80104ddb:	e8 13 c8 ff ff       	call   801015f3 <ilock>
  if (ip->type != T_DIR)
80104de0:	83 c4 10             	add    $0x10,%esp
80104de3:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80104dea:	01 
80104deb:	75 37                	jne    80104e24 <sys_chdir+0x8a>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ded:	83 ec 0c             	sub    $0xc,%esp
80104df0:	53                   	push   %ebx
80104df1:	e8 dd c8 ff ff       	call   801016d3 <iunlock>
  iput(curproc->cwd);
80104df6:	83 c4 04             	add    $0x4,%esp
80104df9:	ff 76 68             	push   0x68(%esi)
80104dfc:	e8 17 c9 ff ff       	call   80101718 <iput>
  end_op();
80104e01:	e8 00 db ff ff       	call   80102906 <end_op>
  curproc->cwd = ip;
80104e06:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104e09:	83 c4 10             	add    $0x10,%esp
80104e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e14:	5b                   	pop    %ebx
80104e15:	5e                   	pop    %esi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret    
    end_op();
80104e18:	e8 e9 da ff ff       	call   80102906 <end_op>
    return -1;
80104e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e22:	eb ed                	jmp    80104e11 <sys_chdir+0x77>
    iunlockput(ip);
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	53                   	push   %ebx
80104e28:	e8 9a c9 ff ff       	call   801017c7 <iunlockput>
    end_op();
80104e2d:	e8 d4 da ff ff       	call   80102906 <end_op>
    return -1;
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3a:	eb d5                	jmp    80104e11 <sys_chdir+0x77>

80104e3c <sys_exec>:

int sys_exec(void)
{
80104e3c:	55                   	push   %ebp
80104e3d:	89 e5                	mov    %esp,%ebp
80104e3f:	53                   	push   %ebx
80104e40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e49:	50                   	push   %eax
80104e4a:	6a 00                	push   $0x0
80104e4c:	e8 39 f5 ff ff       	call   8010438a <argstr>
80104e51:	83 c4 10             	add    $0x10,%esp
80104e54:	85 c0                	test   %eax,%eax
80104e56:	78 38                	js     80104e90 <sys_exec+0x54>
80104e58:	83 ec 08             	sub    $0x8,%esp
80104e5b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104e61:	50                   	push   %eax
80104e62:	6a 01                	push   $0x1
80104e64:	e8 91 f4 ff ff       	call   801042fa <argint>
80104e69:	83 c4 10             	add    $0x10,%esp
80104e6c:	85 c0                	test   %eax,%eax
80104e6e:	78 20                	js     80104e90 <sys_exec+0x54>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	68 80 00 00 00       	push   $0x80
80104e78:	6a 00                	push   $0x0
80104e7a:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104e80:	50                   	push   %eax
80104e81:	e8 24 f2 ff ff       	call   801040aa <memset>
80104e86:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++)
80104e89:	bb 00 00 00 00       	mov    $0x0,%ebx
80104e8e:	eb 2c                	jmp    80104ebc <sys_exec+0x80>
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb 78                	jmp    80104f0f <sys_exec+0xd3>
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
      return -1;
    if (uarg == 0)
    {
      argv[i] = 0;
80104e97:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104e9e:	00 00 00 00 
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104ea2:	83 ec 08             	sub    $0x8,%esp
80104ea5:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104eab:	50                   	push   %eax
80104eac:	ff 75 f4             	push   -0xc(%ebp)
80104eaf:	e8 5a ba ff ff       	call   8010090e <exec>
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	eb 56                	jmp    80104f0f <sys_exec+0xd3>
  for (i = 0;; i++)
80104eb9:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80104ebc:	83 fb 1f             	cmp    $0x1f,%ebx
80104ebf:	77 49                	ja     80104f0a <sys_exec+0xce>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104ec1:	83 ec 08             	sub    $0x8,%esp
80104ec4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104eca:	50                   	push   %eax
80104ecb:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104ed1:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104ed4:	50                   	push   %eax
80104ed5:	e8 a6 f3 ff ff       	call   80104280 <fetchint>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	85 c0                	test   %eax,%eax
80104edf:	78 33                	js     80104f14 <sys_exec+0xd8>
    if (uarg == 0)
80104ee1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	74 ac                	je     80104e97 <sys_exec+0x5b>
    if (fetchstr(uarg, &argv[i]) < 0)
80104eeb:	83 ec 08             	sub    $0x8,%esp
80104eee:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104ef5:	52                   	push   %edx
80104ef6:	50                   	push   %eax
80104ef7:	e8 bf f3 ff ff       	call   801042bb <fetchstr>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	79 b6                	jns    80104eb9 <sys_exec+0x7d>
      return -1;
80104f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f08:	eb 05                	jmp    80104f0f <sys_exec+0xd3>
      return -1;
80104f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f12:	c9                   	leave  
80104f13:	c3                   	ret    
      return -1;
80104f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f19:	eb f4                	jmp    80104f0f <sys_exec+0xd3>

80104f1b <sys_pipe>:

int sys_pipe(void)
{
80104f1b:	55                   	push   %ebp
80104f1c:	89 e5                	mov    %esp,%ebp
80104f1e:	53                   	push   %ebx
80104f1f:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104f22:	6a 08                	push   $0x8
80104f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f27:	50                   	push   %eax
80104f28:	6a 00                	push   $0x0
80104f2a:	e8 f3 f3 ff ff       	call   80104322 <argptr>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	78 79                	js     80104faf <sys_pipe+0x94>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80104f36:	83 ec 08             	sub    $0x8,%esp
80104f39:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f3c:	50                   	push   %eax
80104f3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f40:	50                   	push   %eax
80104f41:	e8 cf de ff ff       	call   80102e15 <pipealloc>
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	78 69                	js     80104fb6 <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f50:	e8 1f f5 ff ff       	call   80104474 <fdalloc>
80104f55:	89 c3                	mov    %eax,%ebx
80104f57:	85 c0                	test   %eax,%eax
80104f59:	78 21                	js     80104f7c <sys_pipe+0x61>
80104f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f5e:	e8 11 f5 ff ff       	call   80104474 <fdalloc>
80104f63:	85 c0                	test   %eax,%eax
80104f65:	78 15                	js     80104f7c <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f6a:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f6f:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    
    if (fd0 >= 0)
80104f7c:	85 db                	test   %ebx,%ebx
80104f7e:	79 20                	jns    80104fa0 <sys_pipe+0x85>
    fileclose(rf);
80104f80:	83 ec 0c             	sub    $0xc,%esp
80104f83:	ff 75 f0             	push   -0x10(%ebp)
80104f86:	e8 78 bd ff ff       	call   80100d03 <fileclose>
    fileclose(wf);
80104f8b:	83 c4 04             	add    $0x4,%esp
80104f8e:	ff 75 ec             	push   -0x14(%ebp)
80104f91:	e8 6d bd ff ff       	call   80100d03 <fileclose>
    return -1;
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9e:	eb d7                	jmp    80104f77 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104fa0:	e8 24 e3 ff ff       	call   801032c9 <myproc>
80104fa5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104fac:	00 
80104fad:	eb d1                	jmp    80104f80 <sys_pipe+0x65>
    return -1;
80104faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb4:	eb c1                	jmp    80104f77 <sys_pipe+0x5c>
    return -1;
80104fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbb:	eb ba                	jmp    80104f77 <sys_pipe+0x5c>

80104fbd <sys_hello>:

int sys_hello(void)
{
80104fbd:	55                   	push   %ebp
80104fbe:	89 e5                	mov    %esp,%ebp
80104fc0:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hi! Welcome to the world of xv6!\n");
80104fc3:	68 6c 74 10 80       	push   $0x8010746c
80104fc8:	e8 7a b6 ff ff       	call   80100647 <cprintf>
  return 0;
}
80104fcd:	b8 00 00 00 00       	mov    $0x0,%eax
80104fd2:	c9                   	leave  
80104fd3:	c3                   	ret    

80104fd4 <sys_helloYou>:
int sys_helloYou(void)
{
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	83 ec 18             	sub    $0x18,%esp
  // char *argv[MAXARG];
  char *path;
  begin_op();
80104fda:	e8 ad d8 ff ff       	call   8010288c <begin_op>
  argstr(0, &path);
80104fdf:	83 ec 08             	sub    $0x8,%esp
80104fe2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe5:	50                   	push   %eax
80104fe6:	6a 00                	push   $0x0
80104fe8:	e8 9d f3 ff ff       	call   8010438a <argstr>
  cprintf("this is the helloYou syscall called %s\n", path);
80104fed:	83 c4 08             	add    $0x8,%esp
80104ff0:	ff 75 f4             	push   -0xc(%ebp)
80104ff3:	68 90 74 10 80       	push   $0x80107490
80104ff8:	e8 4a b6 ff ff       	call   80100647 <cprintf>
  end_op();
80104ffd:	e8 04 d9 ff ff       	call   80102906 <end_op>
  return 0;
}
80105002:	b8 00 00 00 00       	mov    $0x0,%eax
80105007:	c9                   	leave  
80105008:	c3                   	ret    

80105009 <sys_fork>:
#include "mmu.h"
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
80105009:	55                   	push   %ebp
8010500a:	89 e5                	mov    %esp,%ebp
8010500c:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010500f:	e8 2b e4 ff ff       	call   8010343f <fork>
}
80105014:	c9                   	leave  
80105015:	c3                   	ret    

80105016 <sys_exit>:

int sys_exit(void)
{
80105016:	55                   	push   %ebp
80105017:	89 e5                	mov    %esp,%ebp
80105019:	83 ec 08             	sub    $0x8,%esp
  exit();
8010501c:	e8 58 e6 ff ff       	call   80103679 <exit>
  return 0; // not reached
}
80105021:	b8 00 00 00 00       	mov    $0x0,%eax
80105026:	c9                   	leave  
80105027:	c3                   	ret    

80105028 <sys_wait>:

int sys_wait(void)
{
80105028:	55                   	push   %ebp
80105029:	89 e5                	mov    %esp,%ebp
8010502b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010502e:	e8 ee e7 ff ff       	call   80103821 <wait>
}
80105033:	c9                   	leave  
80105034:	c3                   	ret    

80105035 <sys_kill>:

int sys_kill(void)
{
80105035:	55                   	push   %ebp
80105036:	89 e5                	mov    %esp,%ebp
80105038:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
8010503b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503e:	50                   	push   %eax
8010503f:	6a 00                	push   $0x0
80105041:	e8 b4 f2 ff ff       	call   801042fa <argint>
80105046:	83 c4 10             	add    $0x10,%esp
80105049:	85 c0                	test   %eax,%eax
8010504b:	78 10                	js     8010505d <sys_kill+0x28>
    return -1;
  return kill(pid);
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	ff 75 f4             	push   -0xc(%ebp)
80105053:	e8 c6 e8 ff ff       	call   8010391e <kill>
80105058:	83 c4 10             	add    $0x10,%esp
}
8010505b:	c9                   	leave  
8010505c:	c3                   	ret    
    return -1;
8010505d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105062:	eb f7                	jmp    8010505b <sys_kill+0x26>

80105064 <sys_getpid>:

int sys_getpid(void)
{
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010506a:	e8 5a e2 ff ff       	call   801032c9 <myproc>
8010506f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105072:	c9                   	leave  
80105073:	c3                   	ret    

80105074 <sys_sbrk>:

int sys_sbrk(void)
{
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	53                   	push   %ebx
80105078:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
8010507b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507e:	50                   	push   %eax
8010507f:	6a 00                	push   $0x0
80105081:	e8 74 f2 ff ff       	call   801042fa <argint>
80105086:	83 c4 10             	add    $0x10,%esp
80105089:	85 c0                	test   %eax,%eax
8010508b:	78 20                	js     801050ad <sys_sbrk+0x39>
    return -1;
  addr = myproc()->sz;
8010508d:	e8 37 e2 ff ff       	call   801032c9 <myproc>
80105092:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	ff 75 f4             	push   -0xc(%ebp)
8010509a:	e8 35 e3 ff ff       	call   801033d4 <growproc>
8010509f:	83 c4 10             	add    $0x10,%esp
801050a2:	85 c0                	test   %eax,%eax
801050a4:	78 0e                	js     801050b4 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801050a6:	89 d8                	mov    %ebx,%eax
801050a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050ab:	c9                   	leave  
801050ac:	c3                   	ret    
    return -1;
801050ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050b2:	eb f2                	jmp    801050a6 <sys_sbrk+0x32>
    return -1;
801050b4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050b9:	eb eb                	jmp    801050a6 <sys_sbrk+0x32>

801050bb <sys_sleep>:

int sys_sleep(void)
{
801050bb:	55                   	push   %ebp
801050bc:	89 e5                	mov    %esp,%ebp
801050be:	53                   	push   %ebx
801050bf:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
801050c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050c5:	50                   	push   %eax
801050c6:	6a 00                	push   $0x0
801050c8:	e8 2d f2 ff ff       	call   801042fa <argint>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 75                	js     80105149 <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
801050d4:	83 ec 0c             	sub    $0xc,%esp
801050d7:	68 60 59 11 80       	push   $0x80115960
801050dc:	e8 34 ee ff ff       	call   80103f15 <acquire>
  ticks0 = ticks;
801050e1:	8b 1d 40 59 11 80    	mov    0x80115940,%ebx
  while (ticks - ticks0 < n)
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	a1 40 59 11 80       	mov    0x80115940,%eax
801050ef:	29 d8                	sub    %ebx,%eax
801050f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801050f4:	73 39                	jae    8010512f <sys_sleep+0x74>
  {
    if (myproc()->killed)
801050f6:	e8 ce e1 ff ff       	call   801032c9 <myproc>
801050fb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050ff:	75 17                	jne    80105118 <sys_sleep+0x5d>
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105101:	83 ec 08             	sub    $0x8,%esp
80105104:	68 60 59 11 80       	push   $0x80115960
80105109:	68 40 59 11 80       	push   $0x80115940
8010510e:	e8 7d e6 ff ff       	call   80103790 <sleep>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	eb d2                	jmp    801050ea <sys_sleep+0x2f>
      release(&tickslock);
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	68 60 59 11 80       	push   $0x80115960
80105120:	e8 55 ee ff ff       	call   80103f7a <release>
      return -1;
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb 15                	jmp    80105144 <sys_sleep+0x89>
  }
  release(&tickslock);
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	68 60 59 11 80       	push   $0x80115960
80105137:	e8 3e ee ff ff       	call   80103f7a <release>
  return 0;
8010513c:	83 c4 10             	add    $0x10,%esp
8010513f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105147:	c9                   	leave  
80105148:	c3                   	ret    
    return -1;
80105149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514e:	eb f4                	jmp    80105144 <sys_sleep+0x89>

80105150 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	53                   	push   %ebx
80105154:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105157:	68 60 59 11 80       	push   $0x80115960
8010515c:	e8 b4 ed ff ff       	call   80103f15 <acquire>
  xticks = ticks;
80105161:	8b 1d 40 59 11 80    	mov    0x80115940,%ebx
  release(&tickslock);
80105167:	c7 04 24 60 59 11 80 	movl   $0x80115960,(%esp)
8010516e:	e8 07 ee ff ff       	call   80103f7a <release>
  return xticks;
}
80105173:	89 d8                	mov    %ebx,%eax
80105175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105178:	c9                   	leave  
80105179:	c3                   	ret    

8010517a <sys_getppid>:
// {
//   return 0;   //commenting this line resolved the error
// }            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
8010517a:	55                   	push   %ebp
8010517b:	89 e5                	mov    %esp,%ebp
8010517d:	83 ec 20             	sub    $0x20,%esp
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
80105180:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105183:	50                   	push   %eax
80105184:	6a 00                	push   $0x0
80105186:	e8 6f f1 ff ff       	call   801042fa <argint>
8010518b:	83 c4 10             	add    $0x10,%esp
8010518e:	85 c0                	test   %eax,%eax
80105190:	78 07                	js     80105199 <sys_getppid+0x1f>
   return -1;
  }
  return getppid();
80105192:	e8 ad e8 ff ff       	call   80103a44 <getppid>
}
80105197:	c9                   	leave  
80105198:	c3                   	ret    
   return -1;
80105199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519e:	eb f7                	jmp    80105197 <sys_getppid+0x1d>

801051a0 <sys_get_siblings_info>:

int sys_get_siblings_info(int pid){
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 08             	sub    $0x8,%esp
  
  return get_siblings_info(sys_getpid());
801051a6:	e8 b9 fe ff ff       	call   80105064 <sys_getpid>
801051ab:	83 ec 0c             	sub    $0xc,%esp
801051ae:	50                   	push   %eax
801051af:	e8 cb e8 ff ff       	call   80103a7f <get_siblings_info>
}
801051b4:	c9                   	leave  
801051b5:	c3                   	ret    

801051b6 <sys_signalProcess>:
void sys_signalProcess(int pid,char type[]){
801051b6:	55                   	push   %ebp
801051b7:	89 e5                	mov    %esp,%ebp
801051b9:	83 ec 10             	sub    $0x10,%esp
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
801051bc:	8d 45 08             	lea    0x8(%ebp),%eax
801051bf:	50                   	push   %eax
801051c0:	6a 00                	push   $0x0
801051c2:	e8 33 f1 ff ff       	call   801042fa <argint>
  char **type1=&type;
  argstr(1,type1); 
801051c7:	83 c4 08             	add    $0x8,%esp
801051ca:	8d 45 0c             	lea    0xc(%ebp),%eax
801051cd:	50                   	push   %eax
801051ce:	6a 01                	push   $0x1
801051d0:	e8 b5 f1 ff ff       	call   8010438a <argstr>
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
801051d5:	83 c4 08             	add    $0x8,%esp
801051d8:	ff 75 0c             	push   0xc(%ebp)
801051db:	ff 75 08             	push   0x8(%ebp)
801051de:	e8 7c e9 ff ff       	call   80103b5f <signalProcess>
}
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	c9                   	leave  
801051e7:	c3                   	ret    

801051e8 <sys_numvp>:

int sys_numvp(){
801051e8:	55                   	push   %ebp
801051e9:	89 e5                	mov    %esp,%ebp
801051eb:	83 ec 08             	sub    $0x8,%esp
  return numvp();
801051ee:	e8 32 ea ff ff       	call   80103c25 <numvp>
}
801051f3:	c9                   	leave  
801051f4:	c3                   	ret    

801051f5 <sys_numpp>:

int sys_numpp(){
801051f5:	55                   	push   %ebp
801051f6:	89 e5                	mov    %esp,%ebp
801051f8:	83 ec 08             	sub    $0x8,%esp
  return numpp();
801051fb:	e8 37 ea ff ff       	call   80103c37 <numpp>
}
80105200:	c9                   	leave  
80105201:	c3                   	ret    

80105202 <sys_init_counter>:
/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
80105202:	c7 05 30 59 11 80 00 	movl   $0x0,0x80115930
80105209:	00 00 00 
}
8010520c:	c3                   	ret    

8010520d <sys_update_cnt>:

void sys_update_cnt(void){
  counter = counter + 1;
8010520d:	a1 30 59 11 80       	mov    0x80115930,%eax
80105212:	83 c0 01             	add    $0x1,%eax
80105215:	a3 30 59 11 80       	mov    %eax,0x80115930
}
8010521a:	c3                   	ret    

8010521b <sys_display_count>:

int sys_display_count(void){
  return counter;
}
8010521b:	a1 30 59 11 80       	mov    0x80115930,%eax
80105220:	c3                   	ret    

80105221 <sys_init_counter_1>:
/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
80105221:	c7 05 2c 59 11 80 00 	movl   $0x0,0x8011592c
80105228:	00 00 00 
}
8010522b:	c3                   	ret    

8010522c <sys_update_cnt_1>:

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
8010522c:	a1 2c 59 11 80       	mov    0x8011592c,%eax
80105231:	83 c0 01             	add    $0x1,%eax
80105234:	a3 2c 59 11 80       	mov    %eax,0x8011592c
}
80105239:	c3                   	ret    

8010523a <sys_display_count_1>:

int sys_display_count_1(void){
  return counter_1;
}
8010523a:	a1 2c 59 11 80       	mov    0x8011592c,%eax
8010523f:	c3                   	ret    

80105240 <sys_init_counter_2>:
/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
80105240:	c7 05 28 59 11 80 00 	movl   $0x0,0x80115928
80105247:	00 00 00 
}
8010524a:	c3                   	ret    

8010524b <sys_update_cnt_2>:

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
8010524b:	a1 28 59 11 80       	mov    0x80115928,%eax
80105250:	83 c0 01             	add    $0x1,%eax
80105253:	a3 28 59 11 80       	mov    %eax,0x80115928
}
80105258:	c3                   	ret    

80105259 <sys_display_count_2>:

int sys_display_count_2(void){
  return counter_2;
}
80105259:	a1 28 59 11 80       	mov    0x80115928,%eax
8010525e:	c3                   	ret    

8010525f <sys_init_mylock>:

int sys_init_mylock(){
8010525f:	55                   	push   %ebp
80105260:	89 e5                	mov    %esp,%ebp
80105262:	83 ec 08             	sub    $0x8,%esp
  return init_mylock();
80105265:	e8 da e9 ff ff       	call   80103c44 <init_mylock>
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    

8010526c <sys_acquire_mylock>:

int sys_acquire_mylock(int id){
8010526c:	55                   	push   %ebp
8010526d:	89 e5                	mov    %esp,%ebp
8010526f:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105272:	8d 45 08             	lea    0x8(%ebp),%eax
80105275:	50                   	push   %eax
80105276:	6a 00                	push   $0x0
80105278:	e8 7d f0 ff ff       	call   801042fa <argint>
  return acquire_mylock(id);
8010527d:	83 c4 04             	add    $0x4,%esp
80105280:	ff 75 08             	push   0x8(%ebp)
80105283:	e8 ce e9 ff ff       	call   80103c56 <acquire_mylock>
}
80105288:	c9                   	leave  
80105289:	c3                   	ret    

8010528a <sys_release_mylock>:

int sys_release_mylock(int id){
8010528a:	55                   	push   %ebp
8010528b:	89 e5                	mov    %esp,%ebp
8010528d:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80105290:	8d 45 08             	lea    0x8(%ebp),%eax
80105293:	50                   	push   %eax
80105294:	6a 00                	push   $0x0
80105296:	e8 5f f0 ff ff       	call   801042fa <argint>
  return release_mylock(id);
8010529b:	83 c4 04             	add    $0x4,%esp
8010529e:	ff 75 08             	push   0x8(%ebp)
801052a1:	e8 d3 e9 ff ff       	call   80103c79 <release_mylock>
}
801052a6:	c9                   	leave  
801052a7:	c3                   	ret    

801052a8 <sys_holding_mylock>:

int sys_holding_mylock(int id){
801052a8:	55                   	push   %ebp
801052a9:	89 e5                	mov    %esp,%ebp
801052ab:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801052ae:	8d 45 08             	lea    0x8(%ebp),%eax
801052b1:	50                   	push   %eax
801052b2:	6a 00                	push   $0x0
801052b4:	e8 41 f0 ff ff       	call   801042fa <argint>
  return holding_mylock(id);
801052b9:	83 c4 04             	add    $0x4,%esp
801052bc:	ff 75 08             	push   0x8(%ebp)
801052bf:	e8 d8 e9 ff ff       	call   80103c9c <holding_mylock>
801052c4:	c9                   	leave  
801052c5:	c3                   	ret    

801052c6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801052c6:	1e                   	push   %ds
  pushl %es
801052c7:	06                   	push   %es
  pushl %fs
801052c8:	0f a0                	push   %fs
  pushl %gs
801052ca:	0f a8                	push   %gs
  pushal
801052cc:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801052cd:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801052d1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801052d3:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801052d5:	54                   	push   %esp
  call trap
801052d6:	e8 37 01 00 00       	call   80105412 <trap>
  addl $4, %esp
801052db:	83 c4 04             	add    $0x4,%esp

801052de <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801052de:	61                   	popa   
  popl %gs
801052df:	0f a9                	pop    %gs
  popl %fs
801052e1:	0f a1                	pop    %fs
  popl %es
801052e3:	07                   	pop    %es
  popl %ds
801052e4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801052e5:	83 c4 08             	add    $0x8,%esp
  iret
801052e8:	cf                   	iret   

801052e9 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801052e9:	55                   	push   %ebp
801052ea:	89 e5                	mov    %esp,%ebp
801052ec:	53                   	push   %ebx
801052ed:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
801052f0:	b8 00 00 00 00       	mov    $0x0,%eax
801052f5:	eb 76                	jmp    8010536d <tvinit+0x84>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801052f7:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
801052fe:	66 89 0c c5 00 5a 11 	mov    %cx,-0x7feea600(,%eax,8)
80105305:	80 
80105306:	66 c7 04 c5 02 5a 11 	movw   $0x8,-0x7feea5fe(,%eax,8)
8010530d:	80 08 00 
80105310:	0f b6 14 c5 04 5a 11 	movzbl -0x7feea5fc(,%eax,8),%edx
80105317:	80 
80105318:	83 e2 e0             	and    $0xffffffe0,%edx
8010531b:	88 14 c5 04 5a 11 80 	mov    %dl,-0x7feea5fc(,%eax,8)
80105322:	c6 04 c5 04 5a 11 80 	movb   $0x0,-0x7feea5fc(,%eax,8)
80105329:	00 
8010532a:	0f b6 14 c5 05 5a 11 	movzbl -0x7feea5fb(,%eax,8),%edx
80105331:	80 
80105332:	83 e2 f0             	and    $0xfffffff0,%edx
80105335:	83 ca 0e             	or     $0xe,%edx
80105338:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
8010533f:	89 d3                	mov    %edx,%ebx
80105341:	83 e3 ef             	and    $0xffffffef,%ebx
80105344:	88 1c c5 05 5a 11 80 	mov    %bl,-0x7feea5fb(,%eax,8)
8010534b:	83 e2 8f             	and    $0xffffff8f,%edx
8010534e:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
80105355:	83 ca 80             	or     $0xffffff80,%edx
80105358:	88 14 c5 05 5a 11 80 	mov    %dl,-0x7feea5fb(,%eax,8)
8010535f:	c1 e9 10             	shr    $0x10,%ecx
80105362:	66 89 0c c5 06 5a 11 	mov    %cx,-0x7feea5fa(,%eax,8)
80105369:	80 
  for(i = 0; i < 256; i++)
8010536a:	83 c0 01             	add    $0x1,%eax
8010536d:	3d ff 00 00 00       	cmp    $0xff,%eax
80105372:	7e 83                	jle    801052f7 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105374:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
8010537a:	66 89 15 00 5c 11 80 	mov    %dx,0x80115c00
80105381:	66 c7 05 02 5c 11 80 	movw   $0x8,0x80115c02
80105388:	08 00 
8010538a:	0f b6 05 04 5c 11 80 	movzbl 0x80115c04,%eax
80105391:	83 e0 e0             	and    $0xffffffe0,%eax
80105394:	a2 04 5c 11 80       	mov    %al,0x80115c04
80105399:	c6 05 04 5c 11 80 00 	movb   $0x0,0x80115c04
801053a0:	0f b6 05 05 5c 11 80 	movzbl 0x80115c05,%eax
801053a7:	83 c8 0f             	or     $0xf,%eax
801053aa:	a2 05 5c 11 80       	mov    %al,0x80115c05
801053af:	83 e0 ef             	and    $0xffffffef,%eax
801053b2:	a2 05 5c 11 80       	mov    %al,0x80115c05
801053b7:	89 c1                	mov    %eax,%ecx
801053b9:	83 c9 60             	or     $0x60,%ecx
801053bc:	88 0d 05 5c 11 80    	mov    %cl,0x80115c05
801053c2:	83 c8 e0             	or     $0xffffffe0,%eax
801053c5:	a2 05 5c 11 80       	mov    %al,0x80115c05
801053ca:	c1 ea 10             	shr    $0x10,%edx
801053cd:	66 89 15 06 5c 11 80 	mov    %dx,0x80115c06

  initlock(&tickslock, "time");
801053d4:	83 ec 08             	sub    $0x8,%esp
801053d7:	68 b8 74 10 80       	push   $0x801074b8
801053dc:	68 60 59 11 80       	push   $0x80115960
801053e1:	e8 f3 e9 ff ff       	call   80103dd9 <initlock>
}
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ec:	c9                   	leave  
801053ed:	c3                   	ret    

801053ee <idtinit>:

void
idtinit(void)
{
801053ee:	55                   	push   %ebp
801053ef:	89 e5                	mov    %esp,%ebp
801053f1:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801053f4:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801053fa:	b8 00 5a 11 80       	mov    $0x80115a00,%eax
801053ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105403:	c1 e8 10             	shr    $0x10,%eax
80105406:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010540a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010540d:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105410:	c9                   	leave  
80105411:	c3                   	ret    

80105412 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105412:	55                   	push   %ebp
80105413:	89 e5                	mov    %esp,%ebp
80105415:	57                   	push   %edi
80105416:	56                   	push   %esi
80105417:	53                   	push   %ebx
80105418:	83 ec 1c             	sub    $0x1c,%esp
8010541b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010541e:	8b 43 30             	mov    0x30(%ebx),%eax
80105421:	83 f8 40             	cmp    $0x40,%eax
80105424:	74 13                	je     80105439 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105426:	83 e8 20             	sub    $0x20,%eax
80105429:	83 f8 1f             	cmp    $0x1f,%eax
8010542c:	0f 87 3a 01 00 00    	ja     8010556c <trap+0x15a>
80105432:	ff 24 85 60 75 10 80 	jmp    *-0x7fef8aa0(,%eax,4)
    if(myproc()->killed)
80105439:	e8 8b de ff ff       	call   801032c9 <myproc>
8010543e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105442:	75 1f                	jne    80105463 <trap+0x51>
    myproc()->tf = tf;
80105444:	e8 80 de ff ff       	call   801032c9 <myproc>
80105449:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010544c:	e8 6c ef ff ff       	call   801043bd <syscall>
    if(myproc()->killed)
80105451:	e8 73 de ff ff       	call   801032c9 <myproc>
80105456:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010545a:	74 7e                	je     801054da <trap+0xc8>
      exit();
8010545c:	e8 18 e2 ff ff       	call   80103679 <exit>
    return;
80105461:	eb 77                	jmp    801054da <trap+0xc8>
      exit();
80105463:	e8 11 e2 ff ff       	call   80103679 <exit>
80105468:	eb da                	jmp    80105444 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010546a:	e8 3f de ff ff       	call   801032ae <cpuid>
8010546f:	85 c0                	test   %eax,%eax
80105471:	74 6f                	je     801054e2 <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105473:	e8 f4 cf ff ff       	call   8010246c <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105478:	e8 4c de ff ff       	call   801032c9 <myproc>
8010547d:	85 c0                	test   %eax,%eax
8010547f:	74 1c                	je     8010549d <trap+0x8b>
80105481:	e8 43 de ff ff       	call   801032c9 <myproc>
80105486:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010548a:	74 11                	je     8010549d <trap+0x8b>
8010548c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105490:	83 e0 03             	and    $0x3,%eax
80105493:	66 83 f8 03          	cmp    $0x3,%ax
80105497:	0f 84 62 01 00 00    	je     801055ff <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010549d:	e8 27 de ff ff       	call   801032c9 <myproc>
801054a2:	85 c0                	test   %eax,%eax
801054a4:	74 0f                	je     801054b5 <trap+0xa3>
801054a6:	e8 1e de ff ff       	call   801032c9 <myproc>
801054ab:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801054af:	0f 84 54 01 00 00    	je     80105609 <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054b5:	e8 0f de ff ff       	call   801032c9 <myproc>
801054ba:	85 c0                	test   %eax,%eax
801054bc:	74 1c                	je     801054da <trap+0xc8>
801054be:	e8 06 de ff ff       	call   801032c9 <myproc>
801054c3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801054c7:	74 11                	je     801054da <trap+0xc8>
801054c9:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801054cd:	83 e0 03             	and    $0x3,%eax
801054d0:	66 83 f8 03          	cmp    $0x3,%ax
801054d4:	0f 84 43 01 00 00    	je     8010561d <trap+0x20b>
    exit();
}
801054da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054dd:	5b                   	pop    %ebx
801054de:	5e                   	pop    %esi
801054df:	5f                   	pop    %edi
801054e0:	5d                   	pop    %ebp
801054e1:	c3                   	ret    
      acquire(&tickslock);
801054e2:	83 ec 0c             	sub    $0xc,%esp
801054e5:	68 60 59 11 80       	push   $0x80115960
801054ea:	e8 26 ea ff ff       	call   80103f15 <acquire>
      ticks++;
801054ef:	83 05 40 59 11 80 01 	addl   $0x1,0x80115940
      wakeup(&ticks);
801054f6:	c7 04 24 40 59 11 80 	movl   $0x80115940,(%esp)
801054fd:	e8 f3 e3 ff ff       	call   801038f5 <wakeup>
      release(&tickslock);
80105502:	c7 04 24 60 59 11 80 	movl   $0x80115960,(%esp)
80105509:	e8 6c ea ff ff       	call   80103f7a <release>
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	e9 5d ff ff ff       	jmp    80105473 <trap+0x61>
    ideintr();
80105516:	e8 2b c9 ff ff       	call   80101e46 <ideintr>
    lapiceoi();
8010551b:	e8 4c cf ff ff       	call   8010246c <lapiceoi>
    break;
80105520:	e9 53 ff ff ff       	jmp    80105478 <trap+0x66>
    kbdintr();
80105525:	e8 8c cd ff ff       	call   801022b6 <kbdintr>
    lapiceoi();
8010552a:	e8 3d cf ff ff       	call   8010246c <lapiceoi>
    break;
8010552f:	e9 44 ff ff ff       	jmp    80105478 <trap+0x66>
    uartintr();
80105534:	e8 fe 01 00 00       	call   80105737 <uartintr>
    lapiceoi();
80105539:	e8 2e cf ff ff       	call   8010246c <lapiceoi>
    break;
8010553e:	e9 35 ff ff ff       	jmp    80105478 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105543:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105546:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010554a:	e8 5f dd ff ff       	call   801032ae <cpuid>
8010554f:	57                   	push   %edi
80105550:	0f b7 f6             	movzwl %si,%esi
80105553:	56                   	push   %esi
80105554:	50                   	push   %eax
80105555:	68 c4 74 10 80       	push   $0x801074c4
8010555a:	e8 e8 b0 ff ff       	call   80100647 <cprintf>
    lapiceoi();
8010555f:	e8 08 cf ff ff       	call   8010246c <lapiceoi>
    break;
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	e9 0c ff ff ff       	jmp    80105478 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010556c:	e8 58 dd ff ff       	call   801032c9 <myproc>
80105571:	85 c0                	test   %eax,%eax
80105573:	74 5f                	je     801055d4 <trap+0x1c2>
80105575:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105579:	74 59                	je     801055d4 <trap+0x1c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010557b:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010557e:	8b 43 38             	mov    0x38(%ebx),%eax
80105581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105584:	e8 25 dd ff ff       	call   801032ae <cpuid>
80105589:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010558c:	8b 53 34             	mov    0x34(%ebx),%edx
8010558f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105592:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105595:	e8 2f dd ff ff       	call   801032c9 <myproc>
8010559a:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010559d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055a0:	e8 24 dd ff ff       	call   801032c9 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055a5:	57                   	push   %edi
801055a6:	ff 75 e4             	push   -0x1c(%ebp)
801055a9:	ff 75 e0             	push   -0x20(%ebp)
801055ac:	ff 75 dc             	push   -0x24(%ebp)
801055af:	56                   	push   %esi
801055b0:	ff 75 d8             	push   -0x28(%ebp)
801055b3:	ff 70 10             	push   0x10(%eax)
801055b6:	68 1c 75 10 80       	push   $0x8010751c
801055bb:	e8 87 b0 ff ff       	call   80100647 <cprintf>
    myproc()->killed = 1;
801055c0:	83 c4 20             	add    $0x20,%esp
801055c3:	e8 01 dd ff ff       	call   801032c9 <myproc>
801055c8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055cf:	e9 a4 fe ff ff       	jmp    80105478 <trap+0x66>
801055d4:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801055d7:	8b 73 38             	mov    0x38(%ebx),%esi
801055da:	e8 cf dc ff ff       	call   801032ae <cpuid>
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	57                   	push   %edi
801055e3:	56                   	push   %esi
801055e4:	50                   	push   %eax
801055e5:	ff 73 30             	push   0x30(%ebx)
801055e8:	68 e8 74 10 80       	push   $0x801074e8
801055ed:	e8 55 b0 ff ff       	call   80100647 <cprintf>
      panic("trap");
801055f2:	83 c4 14             	add    $0x14,%esp
801055f5:	68 bd 74 10 80       	push   $0x801074bd
801055fa:	e8 89 ad ff ff       	call   80100388 <panic>
    exit();
801055ff:	e8 75 e0 ff ff       	call   80103679 <exit>
80105604:	e9 94 fe ff ff       	jmp    8010549d <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105609:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010560d:	0f 85 a2 fe ff ff    	jne    801054b5 <trap+0xa3>
    yield();
80105613:	e8 46 e1 ff ff       	call   8010375e <yield>
80105618:	e9 98 fe ff ff       	jmp    801054b5 <trap+0xa3>
    exit();
8010561d:	e8 57 e0 ff ff       	call   80103679 <exit>
80105622:	e9 b3 fe ff ff       	jmp    801054da <trap+0xc8>

80105627 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105627:	83 3d 00 62 11 80 00 	cmpl   $0x0,0x80116200
8010562e:	74 14                	je     80105644 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105630:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105635:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105636:	a8 01                	test   $0x1,%al
80105638:	74 10                	je     8010564a <uartgetc+0x23>
8010563a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010563f:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105640:	0f b6 c0             	movzbl %al,%eax
80105643:	c3                   	ret    
    return -1;
80105644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105649:	c3                   	ret    
    return -1;
8010564a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564f:	c3                   	ret    

80105650 <uartputc>:
  if(!uart)
80105650:	83 3d 00 62 11 80 00 	cmpl   $0x0,0x80116200
80105657:	74 3b                	je     80105694 <uartputc+0x44>
{
80105659:	55                   	push   %ebp
8010565a:	89 e5                	mov    %esp,%ebp
8010565c:	53                   	push   %ebx
8010565d:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105660:	bb 00 00 00 00       	mov    $0x0,%ebx
80105665:	eb 10                	jmp    80105677 <uartputc+0x27>
    microdelay(10);
80105667:	83 ec 0c             	sub    $0xc,%esp
8010566a:	6a 0a                	push   $0xa
8010566c:	e8 1c ce ff ff       	call   8010248d <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105671:	83 c3 01             	add    $0x1,%ebx
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	83 fb 7f             	cmp    $0x7f,%ebx
8010567a:	7f 0a                	jg     80105686 <uartputc+0x36>
8010567c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105681:	ec                   	in     (%dx),%al
80105682:	a8 20                	test   $0x20,%al
80105684:	74 e1                	je     80105667 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105686:	8b 45 08             	mov    0x8(%ebp),%eax
80105689:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010568e:	ee                   	out    %al,(%dx)
}
8010568f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105692:	c9                   	leave  
80105693:	c3                   	ret    
80105694:	c3                   	ret    

80105695 <uartinit>:
{
80105695:	55                   	push   %ebp
80105696:	89 e5                	mov    %esp,%ebp
80105698:	56                   	push   %esi
80105699:	53                   	push   %ebx
8010569a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010569f:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056a4:	89 c8                	mov    %ecx,%eax
801056a6:	ee                   	out    %al,(%dx)
801056a7:	be fb 03 00 00       	mov    $0x3fb,%esi
801056ac:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801056b1:	89 f2                	mov    %esi,%edx
801056b3:	ee                   	out    %al,(%dx)
801056b4:	b8 0c 00 00 00       	mov    $0xc,%eax
801056b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056be:	ee                   	out    %al,(%dx)
801056bf:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801056c4:	89 c8                	mov    %ecx,%eax
801056c6:	89 da                	mov    %ebx,%edx
801056c8:	ee                   	out    %al,(%dx)
801056c9:	b8 03 00 00 00       	mov    $0x3,%eax
801056ce:	89 f2                	mov    %esi,%edx
801056d0:	ee                   	out    %al,(%dx)
801056d1:	ba fc 03 00 00       	mov    $0x3fc,%edx
801056d6:	89 c8                	mov    %ecx,%eax
801056d8:	ee                   	out    %al,(%dx)
801056d9:	b8 01 00 00 00       	mov    $0x1,%eax
801056de:	89 da                	mov    %ebx,%edx
801056e0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056e1:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056e6:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801056e7:	3c ff                	cmp    $0xff,%al
801056e9:	74 45                	je     80105730 <uartinit+0x9b>
  uart = 1;
801056eb:	c7 05 00 62 11 80 01 	movl   $0x1,0x80116200
801056f2:	00 00 00 
801056f5:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056fa:	ec                   	in     (%dx),%al
801056fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105700:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105701:	83 ec 08             	sub    $0x8,%esp
80105704:	6a 00                	push   $0x0
80105706:	6a 04                	push   $0x4
80105708:	e8 4a c9 ff ff       	call   80102057 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	bb e0 75 10 80       	mov    $0x801075e0,%ebx
80105715:	eb 12                	jmp    80105729 <uartinit+0x94>
    uartputc(*p);
80105717:	83 ec 0c             	sub    $0xc,%esp
8010571a:	0f be c0             	movsbl %al,%eax
8010571d:	50                   	push   %eax
8010571e:	e8 2d ff ff ff       	call   80105650 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105723:	83 c3 01             	add    $0x1,%ebx
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	0f b6 03             	movzbl (%ebx),%eax
8010572c:	84 c0                	test   %al,%al
8010572e:	75 e7                	jne    80105717 <uartinit+0x82>
}
80105730:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105733:	5b                   	pop    %ebx
80105734:	5e                   	pop    %esi
80105735:	5d                   	pop    %ebp
80105736:	c3                   	ret    

80105737 <uartintr>:

void
uartintr(void)
{
80105737:	55                   	push   %ebp
80105738:	89 e5                	mov    %esp,%ebp
8010573a:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010573d:	68 27 56 10 80       	push   $0x80105627
80105742:	e8 2c b0 ff ff       	call   80100773 <consoleintr>
}
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	c9                   	leave  
8010574b:	c3                   	ret    

8010574c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010574c:	6a 00                	push   $0x0
  pushl $0
8010574e:	6a 00                	push   $0x0
  jmp alltraps
80105750:	e9 71 fb ff ff       	jmp    801052c6 <alltraps>

80105755 <vector1>:
.globl vector1
vector1:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $1
80105757:	6a 01                	push   $0x1
  jmp alltraps
80105759:	e9 68 fb ff ff       	jmp    801052c6 <alltraps>

8010575e <vector2>:
.globl vector2
vector2:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $2
80105760:	6a 02                	push   $0x2
  jmp alltraps
80105762:	e9 5f fb ff ff       	jmp    801052c6 <alltraps>

80105767 <vector3>:
.globl vector3
vector3:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $3
80105769:	6a 03                	push   $0x3
  jmp alltraps
8010576b:	e9 56 fb ff ff       	jmp    801052c6 <alltraps>

80105770 <vector4>:
.globl vector4
vector4:
  pushl $0
80105770:	6a 00                	push   $0x0
  pushl $4
80105772:	6a 04                	push   $0x4
  jmp alltraps
80105774:	e9 4d fb ff ff       	jmp    801052c6 <alltraps>

80105779 <vector5>:
.globl vector5
vector5:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $5
8010577b:	6a 05                	push   $0x5
  jmp alltraps
8010577d:	e9 44 fb ff ff       	jmp    801052c6 <alltraps>

80105782 <vector6>:
.globl vector6
vector6:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $6
80105784:	6a 06                	push   $0x6
  jmp alltraps
80105786:	e9 3b fb ff ff       	jmp    801052c6 <alltraps>

8010578b <vector7>:
.globl vector7
vector7:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $7
8010578d:	6a 07                	push   $0x7
  jmp alltraps
8010578f:	e9 32 fb ff ff       	jmp    801052c6 <alltraps>

80105794 <vector8>:
.globl vector8
vector8:
  pushl $8
80105794:	6a 08                	push   $0x8
  jmp alltraps
80105796:	e9 2b fb ff ff       	jmp    801052c6 <alltraps>

8010579b <vector9>:
.globl vector9
vector9:
  pushl $0
8010579b:	6a 00                	push   $0x0
  pushl $9
8010579d:	6a 09                	push   $0x9
  jmp alltraps
8010579f:	e9 22 fb ff ff       	jmp    801052c6 <alltraps>

801057a4 <vector10>:
.globl vector10
vector10:
  pushl $10
801057a4:	6a 0a                	push   $0xa
  jmp alltraps
801057a6:	e9 1b fb ff ff       	jmp    801052c6 <alltraps>

801057ab <vector11>:
.globl vector11
vector11:
  pushl $11
801057ab:	6a 0b                	push   $0xb
  jmp alltraps
801057ad:	e9 14 fb ff ff       	jmp    801052c6 <alltraps>

801057b2 <vector12>:
.globl vector12
vector12:
  pushl $12
801057b2:	6a 0c                	push   $0xc
  jmp alltraps
801057b4:	e9 0d fb ff ff       	jmp    801052c6 <alltraps>

801057b9 <vector13>:
.globl vector13
vector13:
  pushl $13
801057b9:	6a 0d                	push   $0xd
  jmp alltraps
801057bb:	e9 06 fb ff ff       	jmp    801052c6 <alltraps>

801057c0 <vector14>:
.globl vector14
vector14:
  pushl $14
801057c0:	6a 0e                	push   $0xe
  jmp alltraps
801057c2:	e9 ff fa ff ff       	jmp    801052c6 <alltraps>

801057c7 <vector15>:
.globl vector15
vector15:
  pushl $0
801057c7:	6a 00                	push   $0x0
  pushl $15
801057c9:	6a 0f                	push   $0xf
  jmp alltraps
801057cb:	e9 f6 fa ff ff       	jmp    801052c6 <alltraps>

801057d0 <vector16>:
.globl vector16
vector16:
  pushl $0
801057d0:	6a 00                	push   $0x0
  pushl $16
801057d2:	6a 10                	push   $0x10
  jmp alltraps
801057d4:	e9 ed fa ff ff       	jmp    801052c6 <alltraps>

801057d9 <vector17>:
.globl vector17
vector17:
  pushl $17
801057d9:	6a 11                	push   $0x11
  jmp alltraps
801057db:	e9 e6 fa ff ff       	jmp    801052c6 <alltraps>

801057e0 <vector18>:
.globl vector18
vector18:
  pushl $0
801057e0:	6a 00                	push   $0x0
  pushl $18
801057e2:	6a 12                	push   $0x12
  jmp alltraps
801057e4:	e9 dd fa ff ff       	jmp    801052c6 <alltraps>

801057e9 <vector19>:
.globl vector19
vector19:
  pushl $0
801057e9:	6a 00                	push   $0x0
  pushl $19
801057eb:	6a 13                	push   $0x13
  jmp alltraps
801057ed:	e9 d4 fa ff ff       	jmp    801052c6 <alltraps>

801057f2 <vector20>:
.globl vector20
vector20:
  pushl $0
801057f2:	6a 00                	push   $0x0
  pushl $20
801057f4:	6a 14                	push   $0x14
  jmp alltraps
801057f6:	e9 cb fa ff ff       	jmp    801052c6 <alltraps>

801057fb <vector21>:
.globl vector21
vector21:
  pushl $0
801057fb:	6a 00                	push   $0x0
  pushl $21
801057fd:	6a 15                	push   $0x15
  jmp alltraps
801057ff:	e9 c2 fa ff ff       	jmp    801052c6 <alltraps>

80105804 <vector22>:
.globl vector22
vector22:
  pushl $0
80105804:	6a 00                	push   $0x0
  pushl $22
80105806:	6a 16                	push   $0x16
  jmp alltraps
80105808:	e9 b9 fa ff ff       	jmp    801052c6 <alltraps>

8010580d <vector23>:
.globl vector23
vector23:
  pushl $0
8010580d:	6a 00                	push   $0x0
  pushl $23
8010580f:	6a 17                	push   $0x17
  jmp alltraps
80105811:	e9 b0 fa ff ff       	jmp    801052c6 <alltraps>

80105816 <vector24>:
.globl vector24
vector24:
  pushl $0
80105816:	6a 00                	push   $0x0
  pushl $24
80105818:	6a 18                	push   $0x18
  jmp alltraps
8010581a:	e9 a7 fa ff ff       	jmp    801052c6 <alltraps>

8010581f <vector25>:
.globl vector25
vector25:
  pushl $0
8010581f:	6a 00                	push   $0x0
  pushl $25
80105821:	6a 19                	push   $0x19
  jmp alltraps
80105823:	e9 9e fa ff ff       	jmp    801052c6 <alltraps>

80105828 <vector26>:
.globl vector26
vector26:
  pushl $0
80105828:	6a 00                	push   $0x0
  pushl $26
8010582a:	6a 1a                	push   $0x1a
  jmp alltraps
8010582c:	e9 95 fa ff ff       	jmp    801052c6 <alltraps>

80105831 <vector27>:
.globl vector27
vector27:
  pushl $0
80105831:	6a 00                	push   $0x0
  pushl $27
80105833:	6a 1b                	push   $0x1b
  jmp alltraps
80105835:	e9 8c fa ff ff       	jmp    801052c6 <alltraps>

8010583a <vector28>:
.globl vector28
vector28:
  pushl $0
8010583a:	6a 00                	push   $0x0
  pushl $28
8010583c:	6a 1c                	push   $0x1c
  jmp alltraps
8010583e:	e9 83 fa ff ff       	jmp    801052c6 <alltraps>

80105843 <vector29>:
.globl vector29
vector29:
  pushl $0
80105843:	6a 00                	push   $0x0
  pushl $29
80105845:	6a 1d                	push   $0x1d
  jmp alltraps
80105847:	e9 7a fa ff ff       	jmp    801052c6 <alltraps>

8010584c <vector30>:
.globl vector30
vector30:
  pushl $0
8010584c:	6a 00                	push   $0x0
  pushl $30
8010584e:	6a 1e                	push   $0x1e
  jmp alltraps
80105850:	e9 71 fa ff ff       	jmp    801052c6 <alltraps>

80105855 <vector31>:
.globl vector31
vector31:
  pushl $0
80105855:	6a 00                	push   $0x0
  pushl $31
80105857:	6a 1f                	push   $0x1f
  jmp alltraps
80105859:	e9 68 fa ff ff       	jmp    801052c6 <alltraps>

8010585e <vector32>:
.globl vector32
vector32:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $32
80105860:	6a 20                	push   $0x20
  jmp alltraps
80105862:	e9 5f fa ff ff       	jmp    801052c6 <alltraps>

80105867 <vector33>:
.globl vector33
vector33:
  pushl $0
80105867:	6a 00                	push   $0x0
  pushl $33
80105869:	6a 21                	push   $0x21
  jmp alltraps
8010586b:	e9 56 fa ff ff       	jmp    801052c6 <alltraps>

80105870 <vector34>:
.globl vector34
vector34:
  pushl $0
80105870:	6a 00                	push   $0x0
  pushl $34
80105872:	6a 22                	push   $0x22
  jmp alltraps
80105874:	e9 4d fa ff ff       	jmp    801052c6 <alltraps>

80105879 <vector35>:
.globl vector35
vector35:
  pushl $0
80105879:	6a 00                	push   $0x0
  pushl $35
8010587b:	6a 23                	push   $0x23
  jmp alltraps
8010587d:	e9 44 fa ff ff       	jmp    801052c6 <alltraps>

80105882 <vector36>:
.globl vector36
vector36:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $36
80105884:	6a 24                	push   $0x24
  jmp alltraps
80105886:	e9 3b fa ff ff       	jmp    801052c6 <alltraps>

8010588b <vector37>:
.globl vector37
vector37:
  pushl $0
8010588b:	6a 00                	push   $0x0
  pushl $37
8010588d:	6a 25                	push   $0x25
  jmp alltraps
8010588f:	e9 32 fa ff ff       	jmp    801052c6 <alltraps>

80105894 <vector38>:
.globl vector38
vector38:
  pushl $0
80105894:	6a 00                	push   $0x0
  pushl $38
80105896:	6a 26                	push   $0x26
  jmp alltraps
80105898:	e9 29 fa ff ff       	jmp    801052c6 <alltraps>

8010589d <vector39>:
.globl vector39
vector39:
  pushl $0
8010589d:	6a 00                	push   $0x0
  pushl $39
8010589f:	6a 27                	push   $0x27
  jmp alltraps
801058a1:	e9 20 fa ff ff       	jmp    801052c6 <alltraps>

801058a6 <vector40>:
.globl vector40
vector40:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $40
801058a8:	6a 28                	push   $0x28
  jmp alltraps
801058aa:	e9 17 fa ff ff       	jmp    801052c6 <alltraps>

801058af <vector41>:
.globl vector41
vector41:
  pushl $0
801058af:	6a 00                	push   $0x0
  pushl $41
801058b1:	6a 29                	push   $0x29
  jmp alltraps
801058b3:	e9 0e fa ff ff       	jmp    801052c6 <alltraps>

801058b8 <vector42>:
.globl vector42
vector42:
  pushl $0
801058b8:	6a 00                	push   $0x0
  pushl $42
801058ba:	6a 2a                	push   $0x2a
  jmp alltraps
801058bc:	e9 05 fa ff ff       	jmp    801052c6 <alltraps>

801058c1 <vector43>:
.globl vector43
vector43:
  pushl $0
801058c1:	6a 00                	push   $0x0
  pushl $43
801058c3:	6a 2b                	push   $0x2b
  jmp alltraps
801058c5:	e9 fc f9 ff ff       	jmp    801052c6 <alltraps>

801058ca <vector44>:
.globl vector44
vector44:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $44
801058cc:	6a 2c                	push   $0x2c
  jmp alltraps
801058ce:	e9 f3 f9 ff ff       	jmp    801052c6 <alltraps>

801058d3 <vector45>:
.globl vector45
vector45:
  pushl $0
801058d3:	6a 00                	push   $0x0
  pushl $45
801058d5:	6a 2d                	push   $0x2d
  jmp alltraps
801058d7:	e9 ea f9 ff ff       	jmp    801052c6 <alltraps>

801058dc <vector46>:
.globl vector46
vector46:
  pushl $0
801058dc:	6a 00                	push   $0x0
  pushl $46
801058de:	6a 2e                	push   $0x2e
  jmp alltraps
801058e0:	e9 e1 f9 ff ff       	jmp    801052c6 <alltraps>

801058e5 <vector47>:
.globl vector47
vector47:
  pushl $0
801058e5:	6a 00                	push   $0x0
  pushl $47
801058e7:	6a 2f                	push   $0x2f
  jmp alltraps
801058e9:	e9 d8 f9 ff ff       	jmp    801052c6 <alltraps>

801058ee <vector48>:
.globl vector48
vector48:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $48
801058f0:	6a 30                	push   $0x30
  jmp alltraps
801058f2:	e9 cf f9 ff ff       	jmp    801052c6 <alltraps>

801058f7 <vector49>:
.globl vector49
vector49:
  pushl $0
801058f7:	6a 00                	push   $0x0
  pushl $49
801058f9:	6a 31                	push   $0x31
  jmp alltraps
801058fb:	e9 c6 f9 ff ff       	jmp    801052c6 <alltraps>

80105900 <vector50>:
.globl vector50
vector50:
  pushl $0
80105900:	6a 00                	push   $0x0
  pushl $50
80105902:	6a 32                	push   $0x32
  jmp alltraps
80105904:	e9 bd f9 ff ff       	jmp    801052c6 <alltraps>

80105909 <vector51>:
.globl vector51
vector51:
  pushl $0
80105909:	6a 00                	push   $0x0
  pushl $51
8010590b:	6a 33                	push   $0x33
  jmp alltraps
8010590d:	e9 b4 f9 ff ff       	jmp    801052c6 <alltraps>

80105912 <vector52>:
.globl vector52
vector52:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $52
80105914:	6a 34                	push   $0x34
  jmp alltraps
80105916:	e9 ab f9 ff ff       	jmp    801052c6 <alltraps>

8010591b <vector53>:
.globl vector53
vector53:
  pushl $0
8010591b:	6a 00                	push   $0x0
  pushl $53
8010591d:	6a 35                	push   $0x35
  jmp alltraps
8010591f:	e9 a2 f9 ff ff       	jmp    801052c6 <alltraps>

80105924 <vector54>:
.globl vector54
vector54:
  pushl $0
80105924:	6a 00                	push   $0x0
  pushl $54
80105926:	6a 36                	push   $0x36
  jmp alltraps
80105928:	e9 99 f9 ff ff       	jmp    801052c6 <alltraps>

8010592d <vector55>:
.globl vector55
vector55:
  pushl $0
8010592d:	6a 00                	push   $0x0
  pushl $55
8010592f:	6a 37                	push   $0x37
  jmp alltraps
80105931:	e9 90 f9 ff ff       	jmp    801052c6 <alltraps>

80105936 <vector56>:
.globl vector56
vector56:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $56
80105938:	6a 38                	push   $0x38
  jmp alltraps
8010593a:	e9 87 f9 ff ff       	jmp    801052c6 <alltraps>

8010593f <vector57>:
.globl vector57
vector57:
  pushl $0
8010593f:	6a 00                	push   $0x0
  pushl $57
80105941:	6a 39                	push   $0x39
  jmp alltraps
80105943:	e9 7e f9 ff ff       	jmp    801052c6 <alltraps>

80105948 <vector58>:
.globl vector58
vector58:
  pushl $0
80105948:	6a 00                	push   $0x0
  pushl $58
8010594a:	6a 3a                	push   $0x3a
  jmp alltraps
8010594c:	e9 75 f9 ff ff       	jmp    801052c6 <alltraps>

80105951 <vector59>:
.globl vector59
vector59:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $59
80105953:	6a 3b                	push   $0x3b
  jmp alltraps
80105955:	e9 6c f9 ff ff       	jmp    801052c6 <alltraps>

8010595a <vector60>:
.globl vector60
vector60:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $60
8010595c:	6a 3c                	push   $0x3c
  jmp alltraps
8010595e:	e9 63 f9 ff ff       	jmp    801052c6 <alltraps>

80105963 <vector61>:
.globl vector61
vector61:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $61
80105965:	6a 3d                	push   $0x3d
  jmp alltraps
80105967:	e9 5a f9 ff ff       	jmp    801052c6 <alltraps>

8010596c <vector62>:
.globl vector62
vector62:
  pushl $0
8010596c:	6a 00                	push   $0x0
  pushl $62
8010596e:	6a 3e                	push   $0x3e
  jmp alltraps
80105970:	e9 51 f9 ff ff       	jmp    801052c6 <alltraps>

80105975 <vector63>:
.globl vector63
vector63:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $63
80105977:	6a 3f                	push   $0x3f
  jmp alltraps
80105979:	e9 48 f9 ff ff       	jmp    801052c6 <alltraps>

8010597e <vector64>:
.globl vector64
vector64:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $64
80105980:	6a 40                	push   $0x40
  jmp alltraps
80105982:	e9 3f f9 ff ff       	jmp    801052c6 <alltraps>

80105987 <vector65>:
.globl vector65
vector65:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $65
80105989:	6a 41                	push   $0x41
  jmp alltraps
8010598b:	e9 36 f9 ff ff       	jmp    801052c6 <alltraps>

80105990 <vector66>:
.globl vector66
vector66:
  pushl $0
80105990:	6a 00                	push   $0x0
  pushl $66
80105992:	6a 42                	push   $0x42
  jmp alltraps
80105994:	e9 2d f9 ff ff       	jmp    801052c6 <alltraps>

80105999 <vector67>:
.globl vector67
vector67:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $67
8010599b:	6a 43                	push   $0x43
  jmp alltraps
8010599d:	e9 24 f9 ff ff       	jmp    801052c6 <alltraps>

801059a2 <vector68>:
.globl vector68
vector68:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $68
801059a4:	6a 44                	push   $0x44
  jmp alltraps
801059a6:	e9 1b f9 ff ff       	jmp    801052c6 <alltraps>

801059ab <vector69>:
.globl vector69
vector69:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $69
801059ad:	6a 45                	push   $0x45
  jmp alltraps
801059af:	e9 12 f9 ff ff       	jmp    801052c6 <alltraps>

801059b4 <vector70>:
.globl vector70
vector70:
  pushl $0
801059b4:	6a 00                	push   $0x0
  pushl $70
801059b6:	6a 46                	push   $0x46
  jmp alltraps
801059b8:	e9 09 f9 ff ff       	jmp    801052c6 <alltraps>

801059bd <vector71>:
.globl vector71
vector71:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $71
801059bf:	6a 47                	push   $0x47
  jmp alltraps
801059c1:	e9 00 f9 ff ff       	jmp    801052c6 <alltraps>

801059c6 <vector72>:
.globl vector72
vector72:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $72
801059c8:	6a 48                	push   $0x48
  jmp alltraps
801059ca:	e9 f7 f8 ff ff       	jmp    801052c6 <alltraps>

801059cf <vector73>:
.globl vector73
vector73:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $73
801059d1:	6a 49                	push   $0x49
  jmp alltraps
801059d3:	e9 ee f8 ff ff       	jmp    801052c6 <alltraps>

801059d8 <vector74>:
.globl vector74
vector74:
  pushl $0
801059d8:	6a 00                	push   $0x0
  pushl $74
801059da:	6a 4a                	push   $0x4a
  jmp alltraps
801059dc:	e9 e5 f8 ff ff       	jmp    801052c6 <alltraps>

801059e1 <vector75>:
.globl vector75
vector75:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $75
801059e3:	6a 4b                	push   $0x4b
  jmp alltraps
801059e5:	e9 dc f8 ff ff       	jmp    801052c6 <alltraps>

801059ea <vector76>:
.globl vector76
vector76:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $76
801059ec:	6a 4c                	push   $0x4c
  jmp alltraps
801059ee:	e9 d3 f8 ff ff       	jmp    801052c6 <alltraps>

801059f3 <vector77>:
.globl vector77
vector77:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $77
801059f5:	6a 4d                	push   $0x4d
  jmp alltraps
801059f7:	e9 ca f8 ff ff       	jmp    801052c6 <alltraps>

801059fc <vector78>:
.globl vector78
vector78:
  pushl $0
801059fc:	6a 00                	push   $0x0
  pushl $78
801059fe:	6a 4e                	push   $0x4e
  jmp alltraps
80105a00:	e9 c1 f8 ff ff       	jmp    801052c6 <alltraps>

80105a05 <vector79>:
.globl vector79
vector79:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $79
80105a07:	6a 4f                	push   $0x4f
  jmp alltraps
80105a09:	e9 b8 f8 ff ff       	jmp    801052c6 <alltraps>

80105a0e <vector80>:
.globl vector80
vector80:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $80
80105a10:	6a 50                	push   $0x50
  jmp alltraps
80105a12:	e9 af f8 ff ff       	jmp    801052c6 <alltraps>

80105a17 <vector81>:
.globl vector81
vector81:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $81
80105a19:	6a 51                	push   $0x51
  jmp alltraps
80105a1b:	e9 a6 f8 ff ff       	jmp    801052c6 <alltraps>

80105a20 <vector82>:
.globl vector82
vector82:
  pushl $0
80105a20:	6a 00                	push   $0x0
  pushl $82
80105a22:	6a 52                	push   $0x52
  jmp alltraps
80105a24:	e9 9d f8 ff ff       	jmp    801052c6 <alltraps>

80105a29 <vector83>:
.globl vector83
vector83:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $83
80105a2b:	6a 53                	push   $0x53
  jmp alltraps
80105a2d:	e9 94 f8 ff ff       	jmp    801052c6 <alltraps>

80105a32 <vector84>:
.globl vector84
vector84:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $84
80105a34:	6a 54                	push   $0x54
  jmp alltraps
80105a36:	e9 8b f8 ff ff       	jmp    801052c6 <alltraps>

80105a3b <vector85>:
.globl vector85
vector85:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $85
80105a3d:	6a 55                	push   $0x55
  jmp alltraps
80105a3f:	e9 82 f8 ff ff       	jmp    801052c6 <alltraps>

80105a44 <vector86>:
.globl vector86
vector86:
  pushl $0
80105a44:	6a 00                	push   $0x0
  pushl $86
80105a46:	6a 56                	push   $0x56
  jmp alltraps
80105a48:	e9 79 f8 ff ff       	jmp    801052c6 <alltraps>

80105a4d <vector87>:
.globl vector87
vector87:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $87
80105a4f:	6a 57                	push   $0x57
  jmp alltraps
80105a51:	e9 70 f8 ff ff       	jmp    801052c6 <alltraps>

80105a56 <vector88>:
.globl vector88
vector88:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $88
80105a58:	6a 58                	push   $0x58
  jmp alltraps
80105a5a:	e9 67 f8 ff ff       	jmp    801052c6 <alltraps>

80105a5f <vector89>:
.globl vector89
vector89:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $89
80105a61:	6a 59                	push   $0x59
  jmp alltraps
80105a63:	e9 5e f8 ff ff       	jmp    801052c6 <alltraps>

80105a68 <vector90>:
.globl vector90
vector90:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $90
80105a6a:	6a 5a                	push   $0x5a
  jmp alltraps
80105a6c:	e9 55 f8 ff ff       	jmp    801052c6 <alltraps>

80105a71 <vector91>:
.globl vector91
vector91:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $91
80105a73:	6a 5b                	push   $0x5b
  jmp alltraps
80105a75:	e9 4c f8 ff ff       	jmp    801052c6 <alltraps>

80105a7a <vector92>:
.globl vector92
vector92:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $92
80105a7c:	6a 5c                	push   $0x5c
  jmp alltraps
80105a7e:	e9 43 f8 ff ff       	jmp    801052c6 <alltraps>

80105a83 <vector93>:
.globl vector93
vector93:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $93
80105a85:	6a 5d                	push   $0x5d
  jmp alltraps
80105a87:	e9 3a f8 ff ff       	jmp    801052c6 <alltraps>

80105a8c <vector94>:
.globl vector94
vector94:
  pushl $0
80105a8c:	6a 00                	push   $0x0
  pushl $94
80105a8e:	6a 5e                	push   $0x5e
  jmp alltraps
80105a90:	e9 31 f8 ff ff       	jmp    801052c6 <alltraps>

80105a95 <vector95>:
.globl vector95
vector95:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $95
80105a97:	6a 5f                	push   $0x5f
  jmp alltraps
80105a99:	e9 28 f8 ff ff       	jmp    801052c6 <alltraps>

80105a9e <vector96>:
.globl vector96
vector96:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $96
80105aa0:	6a 60                	push   $0x60
  jmp alltraps
80105aa2:	e9 1f f8 ff ff       	jmp    801052c6 <alltraps>

80105aa7 <vector97>:
.globl vector97
vector97:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $97
80105aa9:	6a 61                	push   $0x61
  jmp alltraps
80105aab:	e9 16 f8 ff ff       	jmp    801052c6 <alltraps>

80105ab0 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $98
80105ab2:	6a 62                	push   $0x62
  jmp alltraps
80105ab4:	e9 0d f8 ff ff       	jmp    801052c6 <alltraps>

80105ab9 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $99
80105abb:	6a 63                	push   $0x63
  jmp alltraps
80105abd:	e9 04 f8 ff ff       	jmp    801052c6 <alltraps>

80105ac2 <vector100>:
.globl vector100
vector100:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $100
80105ac4:	6a 64                	push   $0x64
  jmp alltraps
80105ac6:	e9 fb f7 ff ff       	jmp    801052c6 <alltraps>

80105acb <vector101>:
.globl vector101
vector101:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $101
80105acd:	6a 65                	push   $0x65
  jmp alltraps
80105acf:	e9 f2 f7 ff ff       	jmp    801052c6 <alltraps>

80105ad4 <vector102>:
.globl vector102
vector102:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $102
80105ad6:	6a 66                	push   $0x66
  jmp alltraps
80105ad8:	e9 e9 f7 ff ff       	jmp    801052c6 <alltraps>

80105add <vector103>:
.globl vector103
vector103:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $103
80105adf:	6a 67                	push   $0x67
  jmp alltraps
80105ae1:	e9 e0 f7 ff ff       	jmp    801052c6 <alltraps>

80105ae6 <vector104>:
.globl vector104
vector104:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $104
80105ae8:	6a 68                	push   $0x68
  jmp alltraps
80105aea:	e9 d7 f7 ff ff       	jmp    801052c6 <alltraps>

80105aef <vector105>:
.globl vector105
vector105:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $105
80105af1:	6a 69                	push   $0x69
  jmp alltraps
80105af3:	e9 ce f7 ff ff       	jmp    801052c6 <alltraps>

80105af8 <vector106>:
.globl vector106
vector106:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $106
80105afa:	6a 6a                	push   $0x6a
  jmp alltraps
80105afc:	e9 c5 f7 ff ff       	jmp    801052c6 <alltraps>

80105b01 <vector107>:
.globl vector107
vector107:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $107
80105b03:	6a 6b                	push   $0x6b
  jmp alltraps
80105b05:	e9 bc f7 ff ff       	jmp    801052c6 <alltraps>

80105b0a <vector108>:
.globl vector108
vector108:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $108
80105b0c:	6a 6c                	push   $0x6c
  jmp alltraps
80105b0e:	e9 b3 f7 ff ff       	jmp    801052c6 <alltraps>

80105b13 <vector109>:
.globl vector109
vector109:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $109
80105b15:	6a 6d                	push   $0x6d
  jmp alltraps
80105b17:	e9 aa f7 ff ff       	jmp    801052c6 <alltraps>

80105b1c <vector110>:
.globl vector110
vector110:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $110
80105b1e:	6a 6e                	push   $0x6e
  jmp alltraps
80105b20:	e9 a1 f7 ff ff       	jmp    801052c6 <alltraps>

80105b25 <vector111>:
.globl vector111
vector111:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $111
80105b27:	6a 6f                	push   $0x6f
  jmp alltraps
80105b29:	e9 98 f7 ff ff       	jmp    801052c6 <alltraps>

80105b2e <vector112>:
.globl vector112
vector112:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $112
80105b30:	6a 70                	push   $0x70
  jmp alltraps
80105b32:	e9 8f f7 ff ff       	jmp    801052c6 <alltraps>

80105b37 <vector113>:
.globl vector113
vector113:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $113
80105b39:	6a 71                	push   $0x71
  jmp alltraps
80105b3b:	e9 86 f7 ff ff       	jmp    801052c6 <alltraps>

80105b40 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $114
80105b42:	6a 72                	push   $0x72
  jmp alltraps
80105b44:	e9 7d f7 ff ff       	jmp    801052c6 <alltraps>

80105b49 <vector115>:
.globl vector115
vector115:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $115
80105b4b:	6a 73                	push   $0x73
  jmp alltraps
80105b4d:	e9 74 f7 ff ff       	jmp    801052c6 <alltraps>

80105b52 <vector116>:
.globl vector116
vector116:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $116
80105b54:	6a 74                	push   $0x74
  jmp alltraps
80105b56:	e9 6b f7 ff ff       	jmp    801052c6 <alltraps>

80105b5b <vector117>:
.globl vector117
vector117:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $117
80105b5d:	6a 75                	push   $0x75
  jmp alltraps
80105b5f:	e9 62 f7 ff ff       	jmp    801052c6 <alltraps>

80105b64 <vector118>:
.globl vector118
vector118:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $118
80105b66:	6a 76                	push   $0x76
  jmp alltraps
80105b68:	e9 59 f7 ff ff       	jmp    801052c6 <alltraps>

80105b6d <vector119>:
.globl vector119
vector119:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $119
80105b6f:	6a 77                	push   $0x77
  jmp alltraps
80105b71:	e9 50 f7 ff ff       	jmp    801052c6 <alltraps>

80105b76 <vector120>:
.globl vector120
vector120:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $120
80105b78:	6a 78                	push   $0x78
  jmp alltraps
80105b7a:	e9 47 f7 ff ff       	jmp    801052c6 <alltraps>

80105b7f <vector121>:
.globl vector121
vector121:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $121
80105b81:	6a 79                	push   $0x79
  jmp alltraps
80105b83:	e9 3e f7 ff ff       	jmp    801052c6 <alltraps>

80105b88 <vector122>:
.globl vector122
vector122:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $122
80105b8a:	6a 7a                	push   $0x7a
  jmp alltraps
80105b8c:	e9 35 f7 ff ff       	jmp    801052c6 <alltraps>

80105b91 <vector123>:
.globl vector123
vector123:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $123
80105b93:	6a 7b                	push   $0x7b
  jmp alltraps
80105b95:	e9 2c f7 ff ff       	jmp    801052c6 <alltraps>

80105b9a <vector124>:
.globl vector124
vector124:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $124
80105b9c:	6a 7c                	push   $0x7c
  jmp alltraps
80105b9e:	e9 23 f7 ff ff       	jmp    801052c6 <alltraps>

80105ba3 <vector125>:
.globl vector125
vector125:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $125
80105ba5:	6a 7d                	push   $0x7d
  jmp alltraps
80105ba7:	e9 1a f7 ff ff       	jmp    801052c6 <alltraps>

80105bac <vector126>:
.globl vector126
vector126:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $126
80105bae:	6a 7e                	push   $0x7e
  jmp alltraps
80105bb0:	e9 11 f7 ff ff       	jmp    801052c6 <alltraps>

80105bb5 <vector127>:
.globl vector127
vector127:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $127
80105bb7:	6a 7f                	push   $0x7f
  jmp alltraps
80105bb9:	e9 08 f7 ff ff       	jmp    801052c6 <alltraps>

80105bbe <vector128>:
.globl vector128
vector128:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $128
80105bc0:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105bc5:	e9 fc f6 ff ff       	jmp    801052c6 <alltraps>

80105bca <vector129>:
.globl vector129
vector129:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $129
80105bcc:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105bd1:	e9 f0 f6 ff ff       	jmp    801052c6 <alltraps>

80105bd6 <vector130>:
.globl vector130
vector130:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $130
80105bd8:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105bdd:	e9 e4 f6 ff ff       	jmp    801052c6 <alltraps>

80105be2 <vector131>:
.globl vector131
vector131:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $131
80105be4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105be9:	e9 d8 f6 ff ff       	jmp    801052c6 <alltraps>

80105bee <vector132>:
.globl vector132
vector132:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $132
80105bf0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105bf5:	e9 cc f6 ff ff       	jmp    801052c6 <alltraps>

80105bfa <vector133>:
.globl vector133
vector133:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $133
80105bfc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105c01:	e9 c0 f6 ff ff       	jmp    801052c6 <alltraps>

80105c06 <vector134>:
.globl vector134
vector134:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $134
80105c08:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105c0d:	e9 b4 f6 ff ff       	jmp    801052c6 <alltraps>

80105c12 <vector135>:
.globl vector135
vector135:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $135
80105c14:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105c19:	e9 a8 f6 ff ff       	jmp    801052c6 <alltraps>

80105c1e <vector136>:
.globl vector136
vector136:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $136
80105c20:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c25:	e9 9c f6 ff ff       	jmp    801052c6 <alltraps>

80105c2a <vector137>:
.globl vector137
vector137:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $137
80105c2c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105c31:	e9 90 f6 ff ff       	jmp    801052c6 <alltraps>

80105c36 <vector138>:
.globl vector138
vector138:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $138
80105c38:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c3d:	e9 84 f6 ff ff       	jmp    801052c6 <alltraps>

80105c42 <vector139>:
.globl vector139
vector139:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $139
80105c44:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c49:	e9 78 f6 ff ff       	jmp    801052c6 <alltraps>

80105c4e <vector140>:
.globl vector140
vector140:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $140
80105c50:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c55:	e9 6c f6 ff ff       	jmp    801052c6 <alltraps>

80105c5a <vector141>:
.globl vector141
vector141:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $141
80105c5c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c61:	e9 60 f6 ff ff       	jmp    801052c6 <alltraps>

80105c66 <vector142>:
.globl vector142
vector142:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $142
80105c68:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c6d:	e9 54 f6 ff ff       	jmp    801052c6 <alltraps>

80105c72 <vector143>:
.globl vector143
vector143:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $143
80105c74:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c79:	e9 48 f6 ff ff       	jmp    801052c6 <alltraps>

80105c7e <vector144>:
.globl vector144
vector144:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $144
80105c80:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c85:	e9 3c f6 ff ff       	jmp    801052c6 <alltraps>

80105c8a <vector145>:
.globl vector145
vector145:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $145
80105c8c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c91:	e9 30 f6 ff ff       	jmp    801052c6 <alltraps>

80105c96 <vector146>:
.globl vector146
vector146:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $146
80105c98:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c9d:	e9 24 f6 ff ff       	jmp    801052c6 <alltraps>

80105ca2 <vector147>:
.globl vector147
vector147:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $147
80105ca4:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ca9:	e9 18 f6 ff ff       	jmp    801052c6 <alltraps>

80105cae <vector148>:
.globl vector148
vector148:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $148
80105cb0:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105cb5:	e9 0c f6 ff ff       	jmp    801052c6 <alltraps>

80105cba <vector149>:
.globl vector149
vector149:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $149
80105cbc:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105cc1:	e9 00 f6 ff ff       	jmp    801052c6 <alltraps>

80105cc6 <vector150>:
.globl vector150
vector150:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $150
80105cc8:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105ccd:	e9 f4 f5 ff ff       	jmp    801052c6 <alltraps>

80105cd2 <vector151>:
.globl vector151
vector151:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $151
80105cd4:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105cd9:	e9 e8 f5 ff ff       	jmp    801052c6 <alltraps>

80105cde <vector152>:
.globl vector152
vector152:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $152
80105ce0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ce5:	e9 dc f5 ff ff       	jmp    801052c6 <alltraps>

80105cea <vector153>:
.globl vector153
vector153:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $153
80105cec:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105cf1:	e9 d0 f5 ff ff       	jmp    801052c6 <alltraps>

80105cf6 <vector154>:
.globl vector154
vector154:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $154
80105cf8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105cfd:	e9 c4 f5 ff ff       	jmp    801052c6 <alltraps>

80105d02 <vector155>:
.globl vector155
vector155:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $155
80105d04:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105d09:	e9 b8 f5 ff ff       	jmp    801052c6 <alltraps>

80105d0e <vector156>:
.globl vector156
vector156:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $156
80105d10:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105d15:	e9 ac f5 ff ff       	jmp    801052c6 <alltraps>

80105d1a <vector157>:
.globl vector157
vector157:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $157
80105d1c:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d21:	e9 a0 f5 ff ff       	jmp    801052c6 <alltraps>

80105d26 <vector158>:
.globl vector158
vector158:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $158
80105d28:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105d2d:	e9 94 f5 ff ff       	jmp    801052c6 <alltraps>

80105d32 <vector159>:
.globl vector159
vector159:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $159
80105d34:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d39:	e9 88 f5 ff ff       	jmp    801052c6 <alltraps>

80105d3e <vector160>:
.globl vector160
vector160:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $160
80105d40:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d45:	e9 7c f5 ff ff       	jmp    801052c6 <alltraps>

80105d4a <vector161>:
.globl vector161
vector161:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $161
80105d4c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d51:	e9 70 f5 ff ff       	jmp    801052c6 <alltraps>

80105d56 <vector162>:
.globl vector162
vector162:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $162
80105d58:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d5d:	e9 64 f5 ff ff       	jmp    801052c6 <alltraps>

80105d62 <vector163>:
.globl vector163
vector163:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $163
80105d64:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d69:	e9 58 f5 ff ff       	jmp    801052c6 <alltraps>

80105d6e <vector164>:
.globl vector164
vector164:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $164
80105d70:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d75:	e9 4c f5 ff ff       	jmp    801052c6 <alltraps>

80105d7a <vector165>:
.globl vector165
vector165:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $165
80105d7c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d81:	e9 40 f5 ff ff       	jmp    801052c6 <alltraps>

80105d86 <vector166>:
.globl vector166
vector166:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $166
80105d88:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d8d:	e9 34 f5 ff ff       	jmp    801052c6 <alltraps>

80105d92 <vector167>:
.globl vector167
vector167:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $167
80105d94:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d99:	e9 28 f5 ff ff       	jmp    801052c6 <alltraps>

80105d9e <vector168>:
.globl vector168
vector168:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $168
80105da0:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105da5:	e9 1c f5 ff ff       	jmp    801052c6 <alltraps>

80105daa <vector169>:
.globl vector169
vector169:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $169
80105dac:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105db1:	e9 10 f5 ff ff       	jmp    801052c6 <alltraps>

80105db6 <vector170>:
.globl vector170
vector170:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $170
80105db8:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105dbd:	e9 04 f5 ff ff       	jmp    801052c6 <alltraps>

80105dc2 <vector171>:
.globl vector171
vector171:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $171
80105dc4:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105dc9:	e9 f8 f4 ff ff       	jmp    801052c6 <alltraps>

80105dce <vector172>:
.globl vector172
vector172:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $172
80105dd0:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105dd5:	e9 ec f4 ff ff       	jmp    801052c6 <alltraps>

80105dda <vector173>:
.globl vector173
vector173:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $173
80105ddc:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105de1:	e9 e0 f4 ff ff       	jmp    801052c6 <alltraps>

80105de6 <vector174>:
.globl vector174
vector174:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $174
80105de8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105ded:	e9 d4 f4 ff ff       	jmp    801052c6 <alltraps>

80105df2 <vector175>:
.globl vector175
vector175:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $175
80105df4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105df9:	e9 c8 f4 ff ff       	jmp    801052c6 <alltraps>

80105dfe <vector176>:
.globl vector176
vector176:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $176
80105e00:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105e05:	e9 bc f4 ff ff       	jmp    801052c6 <alltraps>

80105e0a <vector177>:
.globl vector177
vector177:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $177
80105e0c:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105e11:	e9 b0 f4 ff ff       	jmp    801052c6 <alltraps>

80105e16 <vector178>:
.globl vector178
vector178:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $178
80105e18:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e1d:	e9 a4 f4 ff ff       	jmp    801052c6 <alltraps>

80105e22 <vector179>:
.globl vector179
vector179:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $179
80105e24:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e29:	e9 98 f4 ff ff       	jmp    801052c6 <alltraps>

80105e2e <vector180>:
.globl vector180
vector180:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $180
80105e30:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105e35:	e9 8c f4 ff ff       	jmp    801052c6 <alltraps>

80105e3a <vector181>:
.globl vector181
vector181:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $181
80105e3c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e41:	e9 80 f4 ff ff       	jmp    801052c6 <alltraps>

80105e46 <vector182>:
.globl vector182
vector182:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $182
80105e48:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e4d:	e9 74 f4 ff ff       	jmp    801052c6 <alltraps>

80105e52 <vector183>:
.globl vector183
vector183:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $183
80105e54:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e59:	e9 68 f4 ff ff       	jmp    801052c6 <alltraps>

80105e5e <vector184>:
.globl vector184
vector184:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $184
80105e60:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e65:	e9 5c f4 ff ff       	jmp    801052c6 <alltraps>

80105e6a <vector185>:
.globl vector185
vector185:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $185
80105e6c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e71:	e9 50 f4 ff ff       	jmp    801052c6 <alltraps>

80105e76 <vector186>:
.globl vector186
vector186:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $186
80105e78:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e7d:	e9 44 f4 ff ff       	jmp    801052c6 <alltraps>

80105e82 <vector187>:
.globl vector187
vector187:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $187
80105e84:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e89:	e9 38 f4 ff ff       	jmp    801052c6 <alltraps>

80105e8e <vector188>:
.globl vector188
vector188:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $188
80105e90:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e95:	e9 2c f4 ff ff       	jmp    801052c6 <alltraps>

80105e9a <vector189>:
.globl vector189
vector189:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $189
80105e9c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ea1:	e9 20 f4 ff ff       	jmp    801052c6 <alltraps>

80105ea6 <vector190>:
.globl vector190
vector190:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $190
80105ea8:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105ead:	e9 14 f4 ff ff       	jmp    801052c6 <alltraps>

80105eb2 <vector191>:
.globl vector191
vector191:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $191
80105eb4:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105eb9:	e9 08 f4 ff ff       	jmp    801052c6 <alltraps>

80105ebe <vector192>:
.globl vector192
vector192:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $192
80105ec0:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105ec5:	e9 fc f3 ff ff       	jmp    801052c6 <alltraps>

80105eca <vector193>:
.globl vector193
vector193:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $193
80105ecc:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105ed1:	e9 f0 f3 ff ff       	jmp    801052c6 <alltraps>

80105ed6 <vector194>:
.globl vector194
vector194:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $194
80105ed8:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105edd:	e9 e4 f3 ff ff       	jmp    801052c6 <alltraps>

80105ee2 <vector195>:
.globl vector195
vector195:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $195
80105ee4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ee9:	e9 d8 f3 ff ff       	jmp    801052c6 <alltraps>

80105eee <vector196>:
.globl vector196
vector196:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $196
80105ef0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ef5:	e9 cc f3 ff ff       	jmp    801052c6 <alltraps>

80105efa <vector197>:
.globl vector197
vector197:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $197
80105efc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105f01:	e9 c0 f3 ff ff       	jmp    801052c6 <alltraps>

80105f06 <vector198>:
.globl vector198
vector198:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $198
80105f08:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105f0d:	e9 b4 f3 ff ff       	jmp    801052c6 <alltraps>

80105f12 <vector199>:
.globl vector199
vector199:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $199
80105f14:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105f19:	e9 a8 f3 ff ff       	jmp    801052c6 <alltraps>

80105f1e <vector200>:
.globl vector200
vector200:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $200
80105f20:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f25:	e9 9c f3 ff ff       	jmp    801052c6 <alltraps>

80105f2a <vector201>:
.globl vector201
vector201:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $201
80105f2c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105f31:	e9 90 f3 ff ff       	jmp    801052c6 <alltraps>

80105f36 <vector202>:
.globl vector202
vector202:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $202
80105f38:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f3d:	e9 84 f3 ff ff       	jmp    801052c6 <alltraps>

80105f42 <vector203>:
.globl vector203
vector203:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $203
80105f44:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f49:	e9 78 f3 ff ff       	jmp    801052c6 <alltraps>

80105f4e <vector204>:
.globl vector204
vector204:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $204
80105f50:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f55:	e9 6c f3 ff ff       	jmp    801052c6 <alltraps>

80105f5a <vector205>:
.globl vector205
vector205:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $205
80105f5c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f61:	e9 60 f3 ff ff       	jmp    801052c6 <alltraps>

80105f66 <vector206>:
.globl vector206
vector206:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $206
80105f68:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f6d:	e9 54 f3 ff ff       	jmp    801052c6 <alltraps>

80105f72 <vector207>:
.globl vector207
vector207:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $207
80105f74:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f79:	e9 48 f3 ff ff       	jmp    801052c6 <alltraps>

80105f7e <vector208>:
.globl vector208
vector208:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $208
80105f80:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f85:	e9 3c f3 ff ff       	jmp    801052c6 <alltraps>

80105f8a <vector209>:
.globl vector209
vector209:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $209
80105f8c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f91:	e9 30 f3 ff ff       	jmp    801052c6 <alltraps>

80105f96 <vector210>:
.globl vector210
vector210:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $210
80105f98:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f9d:	e9 24 f3 ff ff       	jmp    801052c6 <alltraps>

80105fa2 <vector211>:
.globl vector211
vector211:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $211
80105fa4:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105fa9:	e9 18 f3 ff ff       	jmp    801052c6 <alltraps>

80105fae <vector212>:
.globl vector212
vector212:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $212
80105fb0:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105fb5:	e9 0c f3 ff ff       	jmp    801052c6 <alltraps>

80105fba <vector213>:
.globl vector213
vector213:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $213
80105fbc:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105fc1:	e9 00 f3 ff ff       	jmp    801052c6 <alltraps>

80105fc6 <vector214>:
.globl vector214
vector214:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $214
80105fc8:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105fcd:	e9 f4 f2 ff ff       	jmp    801052c6 <alltraps>

80105fd2 <vector215>:
.globl vector215
vector215:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $215
80105fd4:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105fd9:	e9 e8 f2 ff ff       	jmp    801052c6 <alltraps>

80105fde <vector216>:
.globl vector216
vector216:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $216
80105fe0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105fe5:	e9 dc f2 ff ff       	jmp    801052c6 <alltraps>

80105fea <vector217>:
.globl vector217
vector217:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $217
80105fec:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105ff1:	e9 d0 f2 ff ff       	jmp    801052c6 <alltraps>

80105ff6 <vector218>:
.globl vector218
vector218:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $218
80105ff8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105ffd:	e9 c4 f2 ff ff       	jmp    801052c6 <alltraps>

80106002 <vector219>:
.globl vector219
vector219:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $219
80106004:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106009:	e9 b8 f2 ff ff       	jmp    801052c6 <alltraps>

8010600e <vector220>:
.globl vector220
vector220:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $220
80106010:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106015:	e9 ac f2 ff ff       	jmp    801052c6 <alltraps>

8010601a <vector221>:
.globl vector221
vector221:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $221
8010601c:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106021:	e9 a0 f2 ff ff       	jmp    801052c6 <alltraps>

80106026 <vector222>:
.globl vector222
vector222:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $222
80106028:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010602d:	e9 94 f2 ff ff       	jmp    801052c6 <alltraps>

80106032 <vector223>:
.globl vector223
vector223:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $223
80106034:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106039:	e9 88 f2 ff ff       	jmp    801052c6 <alltraps>

8010603e <vector224>:
.globl vector224
vector224:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $224
80106040:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106045:	e9 7c f2 ff ff       	jmp    801052c6 <alltraps>

8010604a <vector225>:
.globl vector225
vector225:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $225
8010604c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106051:	e9 70 f2 ff ff       	jmp    801052c6 <alltraps>

80106056 <vector226>:
.globl vector226
vector226:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $226
80106058:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010605d:	e9 64 f2 ff ff       	jmp    801052c6 <alltraps>

80106062 <vector227>:
.globl vector227
vector227:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $227
80106064:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106069:	e9 58 f2 ff ff       	jmp    801052c6 <alltraps>

8010606e <vector228>:
.globl vector228
vector228:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $228
80106070:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106075:	e9 4c f2 ff ff       	jmp    801052c6 <alltraps>

8010607a <vector229>:
.globl vector229
vector229:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $229
8010607c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106081:	e9 40 f2 ff ff       	jmp    801052c6 <alltraps>

80106086 <vector230>:
.globl vector230
vector230:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $230
80106088:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010608d:	e9 34 f2 ff ff       	jmp    801052c6 <alltraps>

80106092 <vector231>:
.globl vector231
vector231:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $231
80106094:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106099:	e9 28 f2 ff ff       	jmp    801052c6 <alltraps>

8010609e <vector232>:
.globl vector232
vector232:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $232
801060a0:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801060a5:	e9 1c f2 ff ff       	jmp    801052c6 <alltraps>

801060aa <vector233>:
.globl vector233
vector233:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $233
801060ac:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801060b1:	e9 10 f2 ff ff       	jmp    801052c6 <alltraps>

801060b6 <vector234>:
.globl vector234
vector234:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $234
801060b8:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801060bd:	e9 04 f2 ff ff       	jmp    801052c6 <alltraps>

801060c2 <vector235>:
.globl vector235
vector235:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $235
801060c4:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801060c9:	e9 f8 f1 ff ff       	jmp    801052c6 <alltraps>

801060ce <vector236>:
.globl vector236
vector236:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $236
801060d0:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801060d5:	e9 ec f1 ff ff       	jmp    801052c6 <alltraps>

801060da <vector237>:
.globl vector237
vector237:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $237
801060dc:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801060e1:	e9 e0 f1 ff ff       	jmp    801052c6 <alltraps>

801060e6 <vector238>:
.globl vector238
vector238:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $238
801060e8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801060ed:	e9 d4 f1 ff ff       	jmp    801052c6 <alltraps>

801060f2 <vector239>:
.globl vector239
vector239:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $239
801060f4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060f9:	e9 c8 f1 ff ff       	jmp    801052c6 <alltraps>

801060fe <vector240>:
.globl vector240
vector240:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $240
80106100:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106105:	e9 bc f1 ff ff       	jmp    801052c6 <alltraps>

8010610a <vector241>:
.globl vector241
vector241:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $241
8010610c:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106111:	e9 b0 f1 ff ff       	jmp    801052c6 <alltraps>

80106116 <vector242>:
.globl vector242
vector242:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $242
80106118:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010611d:	e9 a4 f1 ff ff       	jmp    801052c6 <alltraps>

80106122 <vector243>:
.globl vector243
vector243:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $243
80106124:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106129:	e9 98 f1 ff ff       	jmp    801052c6 <alltraps>

8010612e <vector244>:
.globl vector244
vector244:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $244
80106130:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106135:	e9 8c f1 ff ff       	jmp    801052c6 <alltraps>

8010613a <vector245>:
.globl vector245
vector245:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $245
8010613c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106141:	e9 80 f1 ff ff       	jmp    801052c6 <alltraps>

80106146 <vector246>:
.globl vector246
vector246:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $246
80106148:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010614d:	e9 74 f1 ff ff       	jmp    801052c6 <alltraps>

80106152 <vector247>:
.globl vector247
vector247:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $247
80106154:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106159:	e9 68 f1 ff ff       	jmp    801052c6 <alltraps>

8010615e <vector248>:
.globl vector248
vector248:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $248
80106160:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106165:	e9 5c f1 ff ff       	jmp    801052c6 <alltraps>

8010616a <vector249>:
.globl vector249
vector249:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $249
8010616c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106171:	e9 50 f1 ff ff       	jmp    801052c6 <alltraps>

80106176 <vector250>:
.globl vector250
vector250:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $250
80106178:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010617d:	e9 44 f1 ff ff       	jmp    801052c6 <alltraps>

80106182 <vector251>:
.globl vector251
vector251:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $251
80106184:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106189:	e9 38 f1 ff ff       	jmp    801052c6 <alltraps>

8010618e <vector252>:
.globl vector252
vector252:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $252
80106190:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106195:	e9 2c f1 ff ff       	jmp    801052c6 <alltraps>

8010619a <vector253>:
.globl vector253
vector253:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $253
8010619c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801061a1:	e9 20 f1 ff ff       	jmp    801052c6 <alltraps>

801061a6 <vector254>:
.globl vector254
vector254:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $254
801061a8:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801061ad:	e9 14 f1 ff ff       	jmp    801052c6 <alltraps>

801061b2 <vector255>:
.globl vector255
vector255:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $255
801061b4:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801061b9:	e9 08 f1 ff ff       	jmp    801052c6 <alltraps>

801061be <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061be:	55                   	push   %ebp
801061bf:	89 e5                	mov    %esp,%ebp
801061c1:	57                   	push   %edi
801061c2:	56                   	push   %esi
801061c3:	53                   	push   %ebx
801061c4:	83 ec 0c             	sub    $0xc,%esp
801061c7:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801061c9:	c1 ea 16             	shr    $0x16,%edx
801061cc:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801061cf:	8b 37                	mov    (%edi),%esi
801061d1:	f7 c6 01 00 00 00    	test   $0x1,%esi
801061d7:	74 20                	je     801061f9 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801061d9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801061df:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801061e5:	c1 eb 0c             	shr    $0xc,%ebx
801061e8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
801061ee:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
801061f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f4:	5b                   	pop    %ebx
801061f5:	5e                   	pop    %esi
801061f6:	5f                   	pop    %edi
801061f7:	5d                   	pop    %ebp
801061f8:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061f9:	85 c9                	test   %ecx,%ecx
801061fb:	74 2b                	je     80106228 <walkpgdir+0x6a>
801061fd:	e8 97 bf ff ff       	call   80102199 <kalloc>
80106202:	89 c6                	mov    %eax,%esi
80106204:	85 c0                	test   %eax,%eax
80106206:	74 20                	je     80106228 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80106208:	83 ec 04             	sub    $0x4,%esp
8010620b:	68 00 10 00 00       	push   $0x1000
80106210:	6a 00                	push   $0x0
80106212:	50                   	push   %eax
80106213:	e8 92 de ff ff       	call   801040aa <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106218:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010621e:	83 c8 07             	or     $0x7,%eax
80106221:	89 07                	mov    %eax,(%edi)
80106223:	83 c4 10             	add    $0x10,%esp
80106226:	eb bd                	jmp    801061e5 <walkpgdir+0x27>
      return 0;
80106228:	b8 00 00 00 00       	mov    $0x0,%eax
8010622d:	eb c2                	jmp    801061f1 <walkpgdir+0x33>

8010622f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010622f:	55                   	push   %ebp
80106230:	89 e5                	mov    %esp,%ebp
80106232:	57                   	push   %edi
80106233:	56                   	push   %esi
80106234:	53                   	push   %ebx
80106235:	83 ec 1c             	sub    $0x1c,%esp
80106238:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010623b:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010623e:	89 d3                	mov    %edx,%ebx
80106240:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106246:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
8010624a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106250:	b9 01 00 00 00       	mov    $0x1,%ecx
80106255:	89 da                	mov    %ebx,%edx
80106257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010625a:	e8 5f ff ff ff       	call   801061be <walkpgdir>
8010625f:	85 c0                	test   %eax,%eax
80106261:	74 2e                	je     80106291 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80106263:	f6 00 01             	testb  $0x1,(%eax)
80106266:	75 1c                	jne    80106284 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106268:	89 f2                	mov    %esi,%edx
8010626a:	0b 55 0c             	or     0xc(%ebp),%edx
8010626d:	83 ca 01             	or     $0x1,%edx
80106270:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106272:	39 fb                	cmp    %edi,%ebx
80106274:	74 28                	je     8010629e <mappages+0x6f>
      break;
    a += PGSIZE;
80106276:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
8010627c:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106282:	eb cc                	jmp    80106250 <mappages+0x21>
      panic("remap");
80106284:	83 ec 0c             	sub    $0xc,%esp
80106287:	68 e8 75 10 80       	push   $0x801075e8
8010628c:	e8 f7 a0 ff ff       	call   80100388 <panic>
      return -1;
80106291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106299:	5b                   	pop    %ebx
8010629a:	5e                   	pop    %esi
8010629b:	5f                   	pop    %edi
8010629c:	5d                   	pop    %ebp
8010629d:	c3                   	ret    
  return 0;
8010629e:	b8 00 00 00 00       	mov    $0x0,%eax
801062a3:	eb f1                	jmp    80106296 <mappages+0x67>

801062a5 <seginit>:
{
801062a5:	55                   	push   %ebp
801062a6:	89 e5                	mov    %esp,%ebp
801062a8:	57                   	push   %edi
801062a9:	56                   	push   %esi
801062aa:	53                   	push   %ebx
801062ab:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
801062ae:	e8 fb cf ff ff       	call   801032ae <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801062b3:	69 f8 b0 00 00 00    	imul   $0xb0,%eax,%edi
801062b9:	66 c7 87 98 33 11 80 	movw   $0xffff,-0x7feecc68(%edi)
801062c0:	ff ff 
801062c2:	66 c7 87 9a 33 11 80 	movw   $0x0,-0x7feecc66(%edi)
801062c9:	00 00 
801062cb:	c6 87 9c 33 11 80 00 	movb   $0x0,-0x7feecc64(%edi)
801062d2:	0f b6 8f 9d 33 11 80 	movzbl -0x7feecc63(%edi),%ecx
801062d9:	83 e1 f0             	and    $0xfffffff0,%ecx
801062dc:	89 ce                	mov    %ecx,%esi
801062de:	83 ce 0a             	or     $0xa,%esi
801062e1:	89 f2                	mov    %esi,%edx
801062e3:	88 97 9d 33 11 80    	mov    %dl,-0x7feecc63(%edi)
801062e9:	83 c9 1a             	or     $0x1a,%ecx
801062ec:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
801062f2:	83 e1 9f             	and    $0xffffff9f,%ecx
801062f5:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
801062fb:	83 c9 80             	or     $0xffffff80,%ecx
801062fe:	88 8f 9d 33 11 80    	mov    %cl,-0x7feecc63(%edi)
80106304:	0f b6 8f 9e 33 11 80 	movzbl -0x7feecc62(%edi),%ecx
8010630b:	83 c9 0f             	or     $0xf,%ecx
8010630e:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
80106314:	89 ce                	mov    %ecx,%esi
80106316:	83 e6 ef             	and    $0xffffffef,%esi
80106319:	89 f2                	mov    %esi,%edx
8010631b:	88 97 9e 33 11 80    	mov    %dl,-0x7feecc62(%edi)
80106321:	83 e1 cf             	and    $0xffffffcf,%ecx
80106324:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
8010632a:	89 ce                	mov    %ecx,%esi
8010632c:	83 ce 40             	or     $0x40,%esi
8010632f:	89 f2                	mov    %esi,%edx
80106331:	88 97 9e 33 11 80    	mov    %dl,-0x7feecc62(%edi)
80106337:	83 c9 c0             	or     $0xffffffc0,%ecx
8010633a:	88 8f 9e 33 11 80    	mov    %cl,-0x7feecc62(%edi)
80106340:	c6 87 9f 33 11 80 00 	movb   $0x0,-0x7feecc61(%edi)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106347:	66 c7 87 a0 33 11 80 	movw   $0xffff,-0x7feecc60(%edi)
8010634e:	ff ff 
80106350:	66 c7 87 a2 33 11 80 	movw   $0x0,-0x7feecc5e(%edi)
80106357:	00 00 
80106359:	c6 87 a4 33 11 80 00 	movb   $0x0,-0x7feecc5c(%edi)
80106360:	0f b6 8f a5 33 11 80 	movzbl -0x7feecc5b(%edi),%ecx
80106367:	83 e1 f0             	and    $0xfffffff0,%ecx
8010636a:	89 ce                	mov    %ecx,%esi
8010636c:	83 ce 02             	or     $0x2,%esi
8010636f:	89 f2                	mov    %esi,%edx
80106371:	88 97 a5 33 11 80    	mov    %dl,-0x7feecc5b(%edi)
80106377:	83 c9 12             	or     $0x12,%ecx
8010637a:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
80106380:	83 e1 9f             	and    $0xffffff9f,%ecx
80106383:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
80106389:	83 c9 80             	or     $0xffffff80,%ecx
8010638c:	88 8f a5 33 11 80    	mov    %cl,-0x7feecc5b(%edi)
80106392:	0f b6 8f a6 33 11 80 	movzbl -0x7feecc5a(%edi),%ecx
80106399:	83 c9 0f             	or     $0xf,%ecx
8010639c:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
801063a2:	89 ce                	mov    %ecx,%esi
801063a4:	83 e6 ef             	and    $0xffffffef,%esi
801063a7:	89 f2                	mov    %esi,%edx
801063a9:	88 97 a6 33 11 80    	mov    %dl,-0x7feecc5a(%edi)
801063af:	83 e1 cf             	and    $0xffffffcf,%ecx
801063b2:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
801063b8:	89 ce                	mov    %ecx,%esi
801063ba:	83 ce 40             	or     $0x40,%esi
801063bd:	89 f2                	mov    %esi,%edx
801063bf:	88 97 a6 33 11 80    	mov    %dl,-0x7feecc5a(%edi)
801063c5:	83 c9 c0             	or     $0xffffffc0,%ecx
801063c8:	88 8f a6 33 11 80    	mov    %cl,-0x7feecc5a(%edi)
801063ce:	c6 87 a7 33 11 80 00 	movb   $0x0,-0x7feecc59(%edi)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801063d5:	66 c7 87 a8 33 11 80 	movw   $0xffff,-0x7feecc58(%edi)
801063dc:	ff ff 
801063de:	66 c7 87 aa 33 11 80 	movw   $0x0,-0x7feecc56(%edi)
801063e5:	00 00 
801063e7:	c6 87 ac 33 11 80 00 	movb   $0x0,-0x7feecc54(%edi)
801063ee:	0f b6 9f ad 33 11 80 	movzbl -0x7feecc53(%edi),%ebx
801063f5:	83 e3 f0             	and    $0xfffffff0,%ebx
801063f8:	89 de                	mov    %ebx,%esi
801063fa:	83 ce 0a             	or     $0xa,%esi
801063fd:	89 f2                	mov    %esi,%edx
801063ff:	88 97 ad 33 11 80    	mov    %dl,-0x7feecc53(%edi)
80106405:	89 de                	mov    %ebx,%esi
80106407:	83 ce 1a             	or     $0x1a,%esi
8010640a:	89 f2                	mov    %esi,%edx
8010640c:	88 97 ad 33 11 80    	mov    %dl,-0x7feecc53(%edi)
80106412:	83 cb 7a             	or     $0x7a,%ebx
80106415:	88 9f ad 33 11 80    	mov    %bl,-0x7feecc53(%edi)
8010641b:	c6 87 ad 33 11 80 fa 	movb   $0xfa,-0x7feecc53(%edi)
80106422:	0f b6 9f ae 33 11 80 	movzbl -0x7feecc52(%edi),%ebx
80106429:	83 cb 0f             	or     $0xf,%ebx
8010642c:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
80106432:	89 de                	mov    %ebx,%esi
80106434:	83 e6 ef             	and    $0xffffffef,%esi
80106437:	89 f2                	mov    %esi,%edx
80106439:	88 97 ae 33 11 80    	mov    %dl,-0x7feecc52(%edi)
8010643f:	83 e3 cf             	and    $0xffffffcf,%ebx
80106442:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
80106448:	89 de                	mov    %ebx,%esi
8010644a:	83 ce 40             	or     $0x40,%esi
8010644d:	89 f2                	mov    %esi,%edx
8010644f:	88 97 ae 33 11 80    	mov    %dl,-0x7feecc52(%edi)
80106455:	83 cb c0             	or     $0xffffffc0,%ebx
80106458:	88 9f ae 33 11 80    	mov    %bl,-0x7feecc52(%edi)
8010645e:	c6 87 af 33 11 80 00 	movb   $0x0,-0x7feecc51(%edi)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106465:	66 c7 87 b0 33 11 80 	movw   $0xffff,-0x7feecc50(%edi)
8010646c:	ff ff 
8010646e:	66 c7 87 b2 33 11 80 	movw   $0x0,-0x7feecc4e(%edi)
80106475:	00 00 
80106477:	c6 87 b4 33 11 80 00 	movb   $0x0,-0x7feecc4c(%edi)
8010647e:	0f b6 9f b5 33 11 80 	movzbl -0x7feecc4b(%edi),%ebx
80106485:	83 e3 f0             	and    $0xfffffff0,%ebx
80106488:	89 de                	mov    %ebx,%esi
8010648a:	83 ce 02             	or     $0x2,%esi
8010648d:	89 f2                	mov    %esi,%edx
8010648f:	88 97 b5 33 11 80    	mov    %dl,-0x7feecc4b(%edi)
80106495:	89 de                	mov    %ebx,%esi
80106497:	83 ce 12             	or     $0x12,%esi
8010649a:	89 f2                	mov    %esi,%edx
8010649c:	88 97 b5 33 11 80    	mov    %dl,-0x7feecc4b(%edi)
801064a2:	83 cb 72             	or     $0x72,%ebx
801064a5:	88 9f b5 33 11 80    	mov    %bl,-0x7feecc4b(%edi)
801064ab:	c6 87 b5 33 11 80 f2 	movb   $0xf2,-0x7feecc4b(%edi)
801064b2:	0f b6 9f b6 33 11 80 	movzbl -0x7feecc4a(%edi),%ebx
801064b9:	83 cb 0f             	or     $0xf,%ebx
801064bc:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
801064c2:	89 de                	mov    %ebx,%esi
801064c4:	83 e6 ef             	and    $0xffffffef,%esi
801064c7:	89 f2                	mov    %esi,%edx
801064c9:	88 97 b6 33 11 80    	mov    %dl,-0x7feecc4a(%edi)
801064cf:	83 e3 cf             	and    $0xffffffcf,%ebx
801064d2:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
801064d8:	89 de                	mov    %ebx,%esi
801064da:	83 ce 40             	or     $0x40,%esi
801064dd:	89 f2                	mov    %esi,%edx
801064df:	88 97 b6 33 11 80    	mov    %dl,-0x7feecc4a(%edi)
801064e5:	83 cb c0             	or     $0xffffffc0,%ebx
801064e8:	88 9f b6 33 11 80    	mov    %bl,-0x7feecc4a(%edi)
801064ee:	c6 87 b7 33 11 80 00 	movb   $0x0,-0x7feecc49(%edi)
  lgdt(c->gdt, sizeof(c->gdt));
801064f5:	8d 97 90 33 11 80    	lea    -0x7feecc70(%edi),%edx
  pd[0] = size-1;
801064fb:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106501:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80106505:	c1 ea 10             	shr    $0x10,%edx
80106508:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010650c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010650f:	0f 01 10             	lgdtl  (%eax)
}
80106512:	83 c4 1c             	add    $0x1c,%esp
80106515:	5b                   	pop    %ebx
80106516:	5e                   	pop    %esi
80106517:	5f                   	pop    %edi
80106518:	5d                   	pop    %ebp
80106519:	c3                   	ret    

8010651a <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010651a:	a1 04 62 11 80       	mov    0x80116204,%eax
8010651f:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106524:	0f 22 d8             	mov    %eax,%cr3
}
80106527:	c3                   	ret    

80106528 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106528:	55                   	push   %ebp
80106529:	89 e5                	mov    %esp,%ebp
8010652b:	57                   	push   %edi
8010652c:	56                   	push   %esi
8010652d:	53                   	push   %ebx
8010652e:	83 ec 1c             	sub    $0x1c,%esp
80106531:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106534:	85 f6                	test   %esi,%esi
80106536:	0f 84 25 01 00 00    	je     80106661 <switchuvm+0x139>
    panic("switchuvm: no process");
  if(p->kstack == 0)
8010653c:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106540:	0f 84 28 01 00 00    	je     8010666e <switchuvm+0x146>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106546:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010654a:	0f 84 2b 01 00 00    	je     8010667b <switchuvm+0x153>
    panic("switchuvm: no pgdir");

  pushcli();
80106550:	e8 e5 d8 ff ff       	call   80103e3a <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106555:	e8 f8 cc ff ff       	call   80103252 <mycpu>
8010655a:	89 c3                	mov    %eax,%ebx
8010655c:	e8 f1 cc ff ff       	call   80103252 <mycpu>
80106561:	8d 78 08             	lea    0x8(%eax),%edi
80106564:	e8 e9 cc ff ff       	call   80103252 <mycpu>
80106569:	83 c0 08             	add    $0x8,%eax
8010656c:	c1 e8 10             	shr    $0x10,%eax
8010656f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106572:	e8 db cc ff ff       	call   80103252 <mycpu>
80106577:	83 c0 08             	add    $0x8,%eax
8010657a:	c1 e8 18             	shr    $0x18,%eax
8010657d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106584:	67 00 
80106586:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010658d:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80106591:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106597:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
8010659e:	83 e2 f0             	and    $0xfffffff0,%edx
801065a1:	89 d1                	mov    %edx,%ecx
801065a3:	83 c9 09             	or     $0x9,%ecx
801065a6:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
801065ac:	83 ca 19             	or     $0x19,%edx
801065af:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801065b5:	83 e2 9f             	and    $0xffffff9f,%edx
801065b8:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801065be:	83 ca 80             	or     $0xffffff80,%edx
801065c1:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801065c7:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
801065ce:	89 d1                	mov    %edx,%ecx
801065d0:	83 e1 f0             	and    $0xfffffff0,%ecx
801065d3:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
801065d9:	89 d1                	mov    %edx,%ecx
801065db:	83 e1 e0             	and    $0xffffffe0,%ecx
801065de:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
801065e4:	83 e2 c0             	and    $0xffffffc0,%edx
801065e7:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801065ed:	83 ca 40             	or     $0x40,%edx
801065f0:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801065f6:	83 e2 7f             	and    $0x7f,%edx
801065f9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
801065ff:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106605:	e8 48 cc ff ff       	call   80103252 <mycpu>
8010660a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80106611:	83 e2 ef             	and    $0xffffffef,%edx
80106614:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010661a:	e8 33 cc ff ff       	call   80103252 <mycpu>
8010661f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106625:	8b 5e 08             	mov    0x8(%esi),%ebx
80106628:	e8 25 cc ff ff       	call   80103252 <mycpu>
8010662d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106633:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106636:	e8 17 cc ff ff       	call   80103252 <mycpu>
8010663b:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106641:	b8 28 00 00 00       	mov    $0x28,%eax
80106646:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106649:	8b 46 04             	mov    0x4(%esi),%eax
8010664c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106651:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106654:	e8 1d d8 ff ff       	call   80103e76 <popcli>
}
80106659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010665c:	5b                   	pop    %ebx
8010665d:	5e                   	pop    %esi
8010665e:	5f                   	pop    %edi
8010665f:	5d                   	pop    %ebp
80106660:	c3                   	ret    
    panic("switchuvm: no process");
80106661:	83 ec 0c             	sub    $0xc,%esp
80106664:	68 ee 75 10 80       	push   $0x801075ee
80106669:	e8 1a 9d ff ff       	call   80100388 <panic>
    panic("switchuvm: no kstack");
8010666e:	83 ec 0c             	sub    $0xc,%esp
80106671:	68 04 76 10 80       	push   $0x80107604
80106676:	e8 0d 9d ff ff       	call   80100388 <panic>
    panic("switchuvm: no pgdir");
8010667b:	83 ec 0c             	sub    $0xc,%esp
8010667e:	68 19 76 10 80       	push   $0x80107619
80106683:	e8 00 9d ff ff       	call   80100388 <panic>

80106688 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106688:	55                   	push   %ebp
80106689:	89 e5                	mov    %esp,%ebp
8010668b:	56                   	push   %esi
8010668c:	53                   	push   %ebx
8010668d:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106690:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106696:	77 4c                	ja     801066e4 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106698:	e8 fc ba ff ff       	call   80102199 <kalloc>
8010669d:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010669f:	83 ec 04             	sub    $0x4,%esp
801066a2:	68 00 10 00 00       	push   $0x1000
801066a7:	6a 00                	push   $0x0
801066a9:	50                   	push   %eax
801066aa:	e8 fb d9 ff ff       	call   801040aa <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801066af:	83 c4 08             	add    $0x8,%esp
801066b2:	6a 06                	push   $0x6
801066b4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066ba:	50                   	push   %eax
801066bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066c0:	ba 00 00 00 00       	mov    $0x0,%edx
801066c5:	8b 45 08             	mov    0x8(%ebp),%eax
801066c8:	e8 62 fb ff ff       	call   8010622f <mappages>
  memmove(mem, init, sz);
801066cd:	83 c4 0c             	add    $0xc,%esp
801066d0:	56                   	push   %esi
801066d1:	ff 75 0c             	push   0xc(%ebp)
801066d4:	53                   	push   %ebx
801066d5:	e8 48 da ff ff       	call   80104122 <memmove>
}
801066da:	83 c4 10             	add    $0x10,%esp
801066dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801066e0:	5b                   	pop    %ebx
801066e1:	5e                   	pop    %esi
801066e2:	5d                   	pop    %ebp
801066e3:	c3                   	ret    
    panic("inituvm: more than a page");
801066e4:	83 ec 0c             	sub    $0xc,%esp
801066e7:	68 2d 76 10 80       	push   $0x8010762d
801066ec:	e8 97 9c ff ff       	call   80100388 <panic>

801066f1 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801066f1:	55                   	push   %ebp
801066f2:	89 e5                	mov    %esp,%ebp
801066f4:	57                   	push   %edi
801066f5:	56                   	push   %esi
801066f6:	53                   	push   %ebx
801066f7:	83 ec 0c             	sub    $0xc,%esp
801066fa:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801066fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106700:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106706:	74 3c                	je     80106744 <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
80106708:	83 ec 0c             	sub    $0xc,%esp
8010670b:	68 e8 76 10 80       	push   $0x801076e8
80106710:	e8 73 9c ff ff       	call   80100388 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106715:	83 ec 0c             	sub    $0xc,%esp
80106718:	68 47 76 10 80       	push   $0x80107647
8010671d:	e8 66 9c ff ff       	call   80100388 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106722:	05 00 00 00 80       	add    $0x80000000,%eax
80106727:	56                   	push   %esi
80106728:	89 da                	mov    %ebx,%edx
8010672a:	03 55 14             	add    0x14(%ebp),%edx
8010672d:	52                   	push   %edx
8010672e:	50                   	push   %eax
8010672f:	ff 75 10             	push   0x10(%ebp)
80106732:	e8 e4 b0 ff ff       	call   8010181b <readi>
80106737:	83 c4 10             	add    $0x10,%esp
8010673a:	39 f0                	cmp    %esi,%eax
8010673c:	75 47                	jne    80106785 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
8010673e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106744:	39 fb                	cmp    %edi,%ebx
80106746:	73 30                	jae    80106778 <loaduvm+0x87>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106748:	89 da                	mov    %ebx,%edx
8010674a:	03 55 0c             	add    0xc(%ebp),%edx
8010674d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106752:	8b 45 08             	mov    0x8(%ebp),%eax
80106755:	e8 64 fa ff ff       	call   801061be <walkpgdir>
8010675a:	85 c0                	test   %eax,%eax
8010675c:	74 b7                	je     80106715 <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
8010675e:	8b 00                	mov    (%eax),%eax
80106760:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106765:	89 fe                	mov    %edi,%esi
80106767:	29 de                	sub    %ebx,%esi
80106769:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010676f:	76 b1                	jbe    80106722 <loaduvm+0x31>
      n = PGSIZE;
80106771:	be 00 10 00 00       	mov    $0x1000,%esi
80106776:	eb aa                	jmp    80106722 <loaduvm+0x31>
      return -1;
  }
  return 0;
80106778:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010677d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106780:	5b                   	pop    %ebx
80106781:	5e                   	pop    %esi
80106782:	5f                   	pop    %edi
80106783:	5d                   	pop    %ebp
80106784:	c3                   	ret    
      return -1;
80106785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010678a:	eb f1                	jmp    8010677d <loaduvm+0x8c>

8010678c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010678c:	55                   	push   %ebp
8010678d:	89 e5                	mov    %esp,%ebp
8010678f:	57                   	push   %edi
80106790:	56                   	push   %esi
80106791:	53                   	push   %ebx
80106792:	83 ec 0c             	sub    $0xc,%esp
80106795:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106798:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010679b:	73 11                	jae    801067ae <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
8010679d:	8b 45 10             	mov    0x10(%ebp),%eax
801067a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801067a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801067ac:	eb 19                	jmp    801067c7 <deallocuvm+0x3b>
    return oldsz;
801067ae:	89 f8                	mov    %edi,%eax
801067b0:	eb 64                	jmp    80106816 <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067b2:	c1 eb 16             	shr    $0x16,%ebx
801067b5:	83 c3 01             	add    $0x1,%ebx
801067b8:	c1 e3 16             	shl    $0x16,%ebx
801067bb:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801067c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067c7:	39 fb                	cmp    %edi,%ebx
801067c9:	73 48                	jae    80106813 <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067cb:	b9 00 00 00 00       	mov    $0x0,%ecx
801067d0:	89 da                	mov    %ebx,%edx
801067d2:	8b 45 08             	mov    0x8(%ebp),%eax
801067d5:	e8 e4 f9 ff ff       	call   801061be <walkpgdir>
801067da:	89 c6                	mov    %eax,%esi
    if(!pte)
801067dc:	85 c0                	test   %eax,%eax
801067de:	74 d2                	je     801067b2 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
801067e0:	8b 00                	mov    (%eax),%eax
801067e2:	a8 01                	test   $0x1,%al
801067e4:	74 db                	je     801067c1 <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067eb:	74 19                	je     80106806 <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
801067ed:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801067f2:	83 ec 0c             	sub    $0xc,%esp
801067f5:	50                   	push   %eax
801067f6:	e8 87 b8 ff ff       	call   80102082 <kfree>
      *pte = 0;
801067fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106801:	83 c4 10             	add    $0x10,%esp
80106804:	eb bb                	jmp    801067c1 <deallocuvm+0x35>
        panic("kfree");
80106806:	83 ec 0c             	sub    $0xc,%esp
80106809:	68 a6 6e 10 80       	push   $0x80106ea6
8010680e:	e8 75 9b ff ff       	call   80100388 <panic>
    }
  }
  return newsz;
80106813:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106816:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106819:	5b                   	pop    %ebx
8010681a:	5e                   	pop    %esi
8010681b:	5f                   	pop    %edi
8010681c:	5d                   	pop    %ebp
8010681d:	c3                   	ret    

8010681e <allocuvm>:
{
8010681e:	55                   	push   %ebp
8010681f:	89 e5                	mov    %esp,%ebp
80106821:	57                   	push   %edi
80106822:	56                   	push   %esi
80106823:	53                   	push   %ebx
80106824:	83 ec 1c             	sub    $0x1c,%esp
80106827:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010682a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010682d:	85 ff                	test   %edi,%edi
8010682f:	0f 88 c1 00 00 00    	js     801068f6 <allocuvm+0xd8>
  if(newsz < oldsz)
80106835:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106838:	72 5c                	jb     80106896 <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
8010683a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010683d:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106843:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106849:	39 fe                	cmp    %edi,%esi
8010684b:	0f 83 ac 00 00 00    	jae    801068fd <allocuvm+0xdf>
    mem = kalloc();
80106851:	e8 43 b9 ff ff       	call   80102199 <kalloc>
80106856:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106858:	85 c0                	test   %eax,%eax
8010685a:	74 42                	je     8010689e <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
8010685c:	83 ec 04             	sub    $0x4,%esp
8010685f:	68 00 10 00 00       	push   $0x1000
80106864:	6a 00                	push   $0x0
80106866:	50                   	push   %eax
80106867:	e8 3e d8 ff ff       	call   801040aa <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010686c:	83 c4 08             	add    $0x8,%esp
8010686f:	6a 06                	push   $0x6
80106871:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106877:	50                   	push   %eax
80106878:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010687d:	89 f2                	mov    %esi,%edx
8010687f:	8b 45 08             	mov    0x8(%ebp),%eax
80106882:	e8 a8 f9 ff ff       	call   8010622f <mappages>
80106887:	83 c4 10             	add    $0x10,%esp
8010688a:	85 c0                	test   %eax,%eax
8010688c:	78 38                	js     801068c6 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
8010688e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106894:	eb b3                	jmp    80106849 <allocuvm+0x2b>
    return oldsz;
80106896:	8b 45 0c             	mov    0xc(%ebp),%eax
80106899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010689c:	eb 5f                	jmp    801068fd <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
8010689e:	83 ec 0c             	sub    $0xc,%esp
801068a1:	68 65 76 10 80       	push   $0x80107665
801068a6:	e8 9c 9d ff ff       	call   80100647 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801068ab:	83 c4 0c             	add    $0xc,%esp
801068ae:	ff 75 0c             	push   0xc(%ebp)
801068b1:	57                   	push   %edi
801068b2:	ff 75 08             	push   0x8(%ebp)
801068b5:	e8 d2 fe ff ff       	call   8010678c <deallocuvm>
      return 0;
801068ba:	83 c4 10             	add    $0x10,%esp
801068bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801068c4:	eb 37                	jmp    801068fd <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
801068c6:	83 ec 0c             	sub    $0xc,%esp
801068c9:	68 7d 76 10 80       	push   $0x8010767d
801068ce:	e8 74 9d ff ff       	call   80100647 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801068d3:	83 c4 0c             	add    $0xc,%esp
801068d6:	ff 75 0c             	push   0xc(%ebp)
801068d9:	57                   	push   %edi
801068da:	ff 75 08             	push   0x8(%ebp)
801068dd:	e8 aa fe ff ff       	call   8010678c <deallocuvm>
      kfree(mem);
801068e2:	89 1c 24             	mov    %ebx,(%esp)
801068e5:	e8 98 b7 ff ff       	call   80102082 <kfree>
      return 0;
801068ea:	83 c4 10             	add    $0x10,%esp
801068ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801068f4:	eb 07                	jmp    801068fd <allocuvm+0xdf>
    return 0;
801068f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801068fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106903:	5b                   	pop    %ebx
80106904:	5e                   	pop    %esi
80106905:	5f                   	pop    %edi
80106906:	5d                   	pop    %ebp
80106907:	c3                   	ret    

80106908 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106908:	55                   	push   %ebp
80106909:	89 e5                	mov    %esp,%ebp
8010690b:	56                   	push   %esi
8010690c:	53                   	push   %ebx
8010690d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106910:	85 f6                	test   %esi,%esi
80106912:	74 1a                	je     8010692e <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106914:	83 ec 04             	sub    $0x4,%esp
80106917:	6a 00                	push   $0x0
80106919:	68 00 00 00 80       	push   $0x80000000
8010691e:	56                   	push   %esi
8010691f:	e8 68 fe ff ff       	call   8010678c <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80106924:	83 c4 10             	add    $0x10,%esp
80106927:	bb 00 00 00 00       	mov    $0x0,%ebx
8010692c:	eb 10                	jmp    8010693e <freevm+0x36>
    panic("freevm: no pgdir");
8010692e:	83 ec 0c             	sub    $0xc,%esp
80106931:	68 99 76 10 80       	push   $0x80107699
80106936:	e8 4d 9a ff ff       	call   80100388 <panic>
  for(i = 0; i < NPDENTRIES; i++){
8010693b:	83 c3 01             	add    $0x1,%ebx
8010693e:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
80106944:	77 1f                	ja     80106965 <freevm+0x5d>
    if(pgdir[i] & PTE_P){
80106946:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106949:	a8 01                	test   $0x1,%al
8010694b:	74 ee                	je     8010693b <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010694d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106952:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106957:	83 ec 0c             	sub    $0xc,%esp
8010695a:	50                   	push   %eax
8010695b:	e8 22 b7 ff ff       	call   80102082 <kfree>
80106960:	83 c4 10             	add    $0x10,%esp
80106963:	eb d6                	jmp    8010693b <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106965:	83 ec 0c             	sub    $0xc,%esp
80106968:	56                   	push   %esi
80106969:	e8 14 b7 ff ff       	call   80102082 <kfree>
}
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106974:	5b                   	pop    %ebx
80106975:	5e                   	pop    %esi
80106976:	5d                   	pop    %ebp
80106977:	c3                   	ret    

80106978 <setupkvm>:
{
80106978:	55                   	push   %ebp
80106979:	89 e5                	mov    %esp,%ebp
8010697b:	56                   	push   %esi
8010697c:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
8010697d:	e8 17 b8 ff ff       	call   80102199 <kalloc>
80106982:	89 c6                	mov    %eax,%esi
80106984:	85 c0                	test   %eax,%eax
80106986:	74 55                	je     801069dd <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
80106988:	83 ec 04             	sub    $0x4,%esp
8010698b:	68 00 10 00 00       	push   $0x1000
80106990:	6a 00                	push   $0x0
80106992:	50                   	push   %eax
80106993:	e8 12 d7 ff ff       	call   801040aa <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106998:	83 c4 10             	add    $0x10,%esp
8010699b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801069a0:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069a6:	73 35                	jae    801069dd <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
801069a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801069ae:	29 c1                	sub    %eax,%ecx
801069b0:	83 ec 08             	sub    $0x8,%esp
801069b3:	ff 73 0c             	push   0xc(%ebx)
801069b6:	50                   	push   %eax
801069b7:	8b 13                	mov    (%ebx),%edx
801069b9:	89 f0                	mov    %esi,%eax
801069bb:	e8 6f f8 ff ff       	call   8010622f <mappages>
801069c0:	83 c4 10             	add    $0x10,%esp
801069c3:	85 c0                	test   %eax,%eax
801069c5:	78 05                	js     801069cc <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069c7:	83 c3 10             	add    $0x10,%ebx
801069ca:	eb d4                	jmp    801069a0 <setupkvm+0x28>
      freevm(pgdir);
801069cc:	83 ec 0c             	sub    $0xc,%esp
801069cf:	56                   	push   %esi
801069d0:	e8 33 ff ff ff       	call   80106908 <freevm>
      return 0;
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	be 00 00 00 00       	mov    $0x0,%esi
}
801069dd:	89 f0                	mov    %esi,%eax
801069df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069e2:	5b                   	pop    %ebx
801069e3:	5e                   	pop    %esi
801069e4:	5d                   	pop    %ebp
801069e5:	c3                   	ret    

801069e6 <kvmalloc>:
{
801069e6:	55                   	push   %ebp
801069e7:	89 e5                	mov    %esp,%ebp
801069e9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801069ec:	e8 87 ff ff ff       	call   80106978 <setupkvm>
801069f1:	a3 04 62 11 80       	mov    %eax,0x80116204
  switchkvm();
801069f6:	e8 1f fb ff ff       	call   8010651a <switchkvm>
}
801069fb:	c9                   	leave  
801069fc:	c3                   	ret    

801069fd <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801069fd:	55                   	push   %ebp
801069fe:	89 e5                	mov    %esp,%ebp
80106a00:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a03:	b9 00 00 00 00       	mov    $0x0,%ecx
80106a08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0e:	e8 ab f7 ff ff       	call   801061be <walkpgdir>
  if(pte == 0)
80106a13:	85 c0                	test   %eax,%eax
80106a15:	74 05                	je     80106a1c <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106a17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106a1a:	c9                   	leave  
80106a1b:	c3                   	ret    
    panic("clearpteu");
80106a1c:	83 ec 0c             	sub    $0xc,%esp
80106a1f:	68 aa 76 10 80       	push   $0x801076aa
80106a24:	e8 5f 99 ff ff       	call   80100388 <panic>

80106a29 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106a29:	55                   	push   %ebp
80106a2a:	89 e5                	mov    %esp,%ebp
80106a2c:	57                   	push   %edi
80106a2d:	56                   	push   %esi
80106a2e:	53                   	push   %ebx
80106a2f:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106a32:	e8 41 ff ff ff       	call   80106978 <setupkvm>
80106a37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a3a:	85 c0                	test   %eax,%eax
80106a3c:	0f 84 c4 00 00 00    	je     80106b06 <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106a42:	bf 00 00 00 00       	mov    $0x0,%edi
80106a47:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a4a:	0f 83 b6 00 00 00    	jae    80106b06 <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106a50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106a53:	b9 00 00 00 00       	mov    $0x0,%ecx
80106a58:	89 fa                	mov    %edi,%edx
80106a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5d:	e8 5c f7 ff ff       	call   801061be <walkpgdir>
80106a62:	85 c0                	test   %eax,%eax
80106a64:	74 65                	je     80106acb <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106a66:	8b 00                	mov    (%eax),%eax
80106a68:	a8 01                	test   $0x1,%al
80106a6a:	74 6c                	je     80106ad8 <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106a6c:	89 c6                	mov    %eax,%esi
80106a6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106a74:	25 ff 0f 00 00       	and    $0xfff,%eax
80106a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106a7c:	e8 18 b7 ff ff       	call   80102199 <kalloc>
80106a81:	89 c3                	mov    %eax,%ebx
80106a83:	85 c0                	test   %eax,%eax
80106a85:	74 6a                	je     80106af1 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106a87:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106a8d:	83 ec 04             	sub    $0x4,%esp
80106a90:	68 00 10 00 00       	push   $0x1000
80106a95:	56                   	push   %esi
80106a96:	50                   	push   %eax
80106a97:	e8 86 d6 ff ff       	call   80104122 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106a9c:	83 c4 08             	add    $0x8,%esp
80106a9f:	ff 75 e0             	push   -0x20(%ebp)
80106aa2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106aa8:	50                   	push   %eax
80106aa9:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106ab4:	e8 76 f7 ff ff       	call   8010622f <mappages>
80106ab9:	83 c4 10             	add    $0x10,%esp
80106abc:	85 c0                	test   %eax,%eax
80106abe:	78 25                	js     80106ae5 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106ac0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ac6:	e9 7c ff ff ff       	jmp    80106a47 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
80106acb:	83 ec 0c             	sub    $0xc,%esp
80106ace:	68 b4 76 10 80       	push   $0x801076b4
80106ad3:	e8 b0 98 ff ff       	call   80100388 <panic>
      panic("copyuvm: page not present");
80106ad8:	83 ec 0c             	sub    $0xc,%esp
80106adb:	68 ce 76 10 80       	push   $0x801076ce
80106ae0:	e8 a3 98 ff ff       	call   80100388 <panic>
      kfree(mem);
80106ae5:	83 ec 0c             	sub    $0xc,%esp
80106ae8:	53                   	push   %ebx
80106ae9:	e8 94 b5 ff ff       	call   80102082 <kfree>
      goto bad;
80106aee:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
80106af1:	83 ec 0c             	sub    $0xc,%esp
80106af4:	ff 75 dc             	push   -0x24(%ebp)
80106af7:	e8 0c fe ff ff       	call   80106908 <freevm>
  return 0;
80106afc:	83 c4 10             	add    $0x10,%esp
80106aff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106b06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b0c:	5b                   	pop    %ebx
80106b0d:	5e                   	pop    %esi
80106b0e:	5f                   	pop    %edi
80106b0f:	5d                   	pop    %ebp
80106b10:	c3                   	ret    

80106b11 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106b11:	55                   	push   %ebp
80106b12:	89 e5                	mov    %esp,%ebp
80106b14:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b17:	b9 00 00 00 00       	mov    $0x0,%ecx
80106b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b22:	e8 97 f6 ff ff       	call   801061be <walkpgdir>
  if((*pte & PTE_P) == 0)
80106b27:	8b 00                	mov    (%eax),%eax
80106b29:	a8 01                	test   $0x1,%al
80106b2b:	74 10                	je     80106b3d <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106b2d:	a8 04                	test   $0x4,%al
80106b2f:	74 13                	je     80106b44 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106b31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b36:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106b3b:	c9                   	leave  
80106b3c:	c3                   	ret    
    return 0;
80106b3d:	b8 00 00 00 00       	mov    $0x0,%eax
80106b42:	eb f7                	jmp    80106b3b <uva2ka+0x2a>
    return 0;
80106b44:	b8 00 00 00 00       	mov    $0x0,%eax
80106b49:	eb f0                	jmp    80106b3b <uva2ka+0x2a>

80106b4b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106b4b:	55                   	push   %ebp
80106b4c:	89 e5                	mov    %esp,%ebp
80106b4e:	57                   	push   %edi
80106b4f:	56                   	push   %esi
80106b50:	53                   	push   %ebx
80106b51:	83 ec 0c             	sub    $0xc,%esp
80106b54:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106b57:	eb 25                	jmp    80106b7e <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5c:	29 f2                	sub    %esi,%edx
80106b5e:	01 d0                	add    %edx,%eax
80106b60:	83 ec 04             	sub    $0x4,%esp
80106b63:	53                   	push   %ebx
80106b64:	ff 75 10             	push   0x10(%ebp)
80106b67:	50                   	push   %eax
80106b68:	e8 b5 d5 ff ff       	call   80104122 <memmove>
    len -= n;
80106b6d:	29 df                	sub    %ebx,%edi
    buf += n;
80106b6f:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106b72:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106b78:	89 45 0c             	mov    %eax,0xc(%ebp)
80106b7b:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106b7e:	85 ff                	test   %edi,%edi
80106b80:	74 2f                	je     80106bb1 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106b82:	8b 75 0c             	mov    0xc(%ebp),%esi
80106b85:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106b8b:	83 ec 08             	sub    $0x8,%esp
80106b8e:	56                   	push   %esi
80106b8f:	ff 75 08             	push   0x8(%ebp)
80106b92:	e8 7a ff ff ff       	call   80106b11 <uva2ka>
    if(pa0 == 0)
80106b97:	83 c4 10             	add    $0x10,%esp
80106b9a:	85 c0                	test   %eax,%eax
80106b9c:	74 20                	je     80106bbe <copyout+0x73>
    n = PGSIZE - (va - va0);
80106b9e:	89 f3                	mov    %esi,%ebx
80106ba0:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106ba3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106ba9:	39 df                	cmp    %ebx,%edi
80106bab:	73 ac                	jae    80106b59 <copyout+0xe>
      n = len;
80106bad:	89 fb                	mov    %edi,%ebx
80106baf:	eb a8                	jmp    80106b59 <copyout+0xe>
  }
  return 0;
80106bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb9:	5b                   	pop    %ebx
80106bba:	5e                   	pop    %esi
80106bbb:	5f                   	pop    %edi
80106bbc:	5d                   	pop    %ebp
80106bbd:	c3                   	ret    
      return -1;
80106bbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc3:	eb f1                	jmp    80106bb6 <copyout+0x6b>

80106bc5 <retNumpp>:

// int retNumvp(){
//   return 0;
// }

int retNumpp(){
80106bc5:	55                   	push   %ebp
80106bc6:	89 e5                	mov    %esp,%ebp
80106bc8:	57                   	push   %edi
80106bc9:	56                   	push   %esi
80106bca:	53                   	push   %ebx
80106bcb:	83 ec 1c             	sub    $0x1c,%esp
  int ii=0;
  pde_t *pgdir=myproc()->pgdir;
80106bce:	e8 f6 c6 ff ff       	call   801032c9 <myproc>
80106bd3:	8b 40 04             	mov    0x4(%eax),%eax
80106bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  k=kmap;
  // void *va = k->virt;
  uint size = k->phys_end - k->phys_start;
  uint pa = k->phys_start;
  // int perm
  a = (char*)PGROUNDDOWN((uint)pa);
80106bd9:	8b 1d 24 a4 10 80    	mov    0x8010a424,%ebx
80106bdf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80106be5:	a1 28 a4 10 80       	mov    0x8010a428,%eax
80106bea:	8d 70 ff             	lea    -0x1(%eax),%esi
80106bed:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  int ii=0;
80106bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80106bf8:	b9 00 00 00 00       	mov    $0x0,%ecx
80106bfd:	89 da                	mov    %ebx,%edx
80106bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c02:	e8 b7 f5 ff ff       	call   801061be <walkpgdir>
80106c07:	85 c0                	test   %eax,%eax
80106c09:	74 14                	je     80106c1f <retNumpp+0x5a>
      return -1;
    // if(*pte & PTE_P)
      // panic("remap");
    // *pte = pa | perm | PTE_P;
    if(a == last)
80106c0b:	39 f3                	cmp    %esi,%ebx
80106c0d:	74 15                	je     80106c24 <retNumpp+0x5f>
      break;
    a += PGSIZE;
80106c0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
    if((PTE_P & *pte)!=0){
80106c15:	f6 00 01             	testb  $0x1,(%eax)
80106c18:	74 de                	je     80106bf8 <retNumpp+0x33>
      ii++;
80106c1a:	83 c7 01             	add    $0x1,%edi
80106c1d:	eb d9                	jmp    80106bf8 <retNumpp+0x33>
      return -1;
80106c1f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    }
  }

  return ii;
80106c24:	89 f8                	mov    %edi,%eax
80106c26:	83 c4 1c             	add    $0x1c,%esp
80106c29:	5b                   	pop    %ebx
80106c2a:	5e                   	pop    %esi
80106c2b:	5f                   	pop    %edi
80106c2c:	5d                   	pop    %ebp
80106c2d:	c3                   	ret    
