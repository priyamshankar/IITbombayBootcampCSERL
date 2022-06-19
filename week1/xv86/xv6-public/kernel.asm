
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 10 82 11 80       	mov    $0x80118210,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 31 10 80       	mov    $0x80103170,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb a4 b5 10 80       	mov    $0x8010b5a4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7b 10 80       	push   $0x80107b80
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 a5 48 00 00       	call   80104900 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 cc 05 11 80       	mov    $0x801105cc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 06 11 80 cc 	movl   $0x801105cc,0x8011066c
8010006a:	05 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 06 11 80 cc 	movl   $0x801105cc,0x80110670
80100074:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 83 a4 00 00 00    	mov    %eax,0xa4(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008e:	c7 83 a0 00 00 00 cc 	movl   $0x801105cc,0xa0(%ebx)
80100095:	05 11 80 
    initsleeplock(&b->lock, "buffer");
80100098:	68 87 7b 10 80       	push   $0x80107b87
8010009d:	50                   	push   %eax
8010009e:	e8 2d 47 00 00       	call   801047d0 <initsleeplock>
    bcache.head.next->prev = b;
801000a3:	a1 70 06 11 80       	mov    0x80110670,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a8:	8d 93 ac 02 00 00    	lea    0x2ac(%ebx),%edx
801000ae:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000b1:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
    bcache.head.next = b;
801000b7:	89 d8                	mov    %ebx,%eax
801000b9:	89 1d 70 06 11 80    	mov    %ebx,0x80110670
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000bf:	81 fb 20 03 11 80    	cmp    $0x80110320,%ebx
801000c5:	75 b9                	jne    80100080 <binit+0x40>
  }
}
801000c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000ca:	c9                   	leave  
801000cb:	c3                   	ret    
801000cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 e7 49 00 00       	call   80104ad0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 06 11 80    	mov    0x80110670,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb cc 05 11 80    	cmp    $0x801105cc,%ebx
801000f8:	75 14                	jne    8010010e <bread+0x3e>
801000fa:	eb 2c                	jmp    80100128 <bread+0x58>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 9b a4 00 00 00    	mov    0xa4(%ebx),%ebx
80100106:	81 fb cc 05 11 80    	cmp    $0x801105cc,%ebx
8010010c:	74 1a                	je     80100128 <bread+0x58>
    if(b->dev == dev && b->blockno == blockno){
8010010e:	3b 73 04             	cmp    0x4(%ebx),%esi
80100111:	75 ed                	jne    80100100 <bread+0x30>
80100113:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100116:	75 e8                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100118:	83 83 9c 00 00 00 01 	addl   $0x1,0x9c(%ebx)
      release(&bcache.lock);
8010011f:	eb 52                	jmp    80100173 <bread+0xa3>
80100121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100128:	8b 1d 6c 06 11 80    	mov    0x8011066c,%ebx
8010012e:	81 fb cc 05 11 80    	cmp    $0x801105cc,%ebx
80100134:	75 18                	jne    8010014e <bread+0x7e>
80100136:	eb 7e                	jmp    801001b6 <bread+0xe6>
80100138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010013f:	90                   	nop
80100140:	8b 9b a0 00 00 00    	mov    0xa0(%ebx),%ebx
80100146:	81 fb cc 05 11 80    	cmp    $0x801105cc,%ebx
8010014c:	74 68                	je     801001b6 <bread+0xe6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014e:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
80100154:	85 c0                	test   %eax,%eax
80100156:	75 e8                	jne    80100140 <bread+0x70>
80100158:	f6 03 04             	testb  $0x4,(%ebx)
8010015b:	75 e3                	jne    80100140 <bread+0x70>
      b->dev = dev;
8010015d:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100160:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100163:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100169:	c7 83 9c 00 00 00 01 	movl   $0x1,0x9c(%ebx)
80100170:	00 00 00 
      release(&bcache.lock);
80100173:	83 ec 0c             	sub    $0xc,%esp
80100176:	68 20 b5 10 80       	push   $0x8010b520
8010017b:	e8 f0 48 00 00       	call   80104a70 <release>
      acquiresleep(&b->lock);
80100180:	8d 43 0c             	lea    0xc(%ebx),%eax
80100183:	89 04 24             	mov    %eax,(%esp)
80100186:	e8 85 46 00 00       	call   80104810 <acquiresleep>
      return b;
8010018b:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
8010018e:	f6 03 02             	testb  $0x2,(%ebx)
80100191:	74 0d                	je     801001a0 <bread+0xd0>
    iderw(b);
  }
  return b;
}
80100193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100196:	89 d8                	mov    %ebx,%eax
80100198:	5b                   	pop    %ebx
80100199:	5e                   	pop    %esi
8010019a:	5f                   	pop    %edi
8010019b:	5d                   	pop    %ebp
8010019c:	c3                   	ret    
8010019d:	8d 76 00             	lea    0x0(%esi),%esi
    iderw(b);
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	53                   	push   %ebx
801001a4:	e8 27 22 00 00       	call   801023d0 <iderw>
801001a9:	83 c4 10             	add    $0x10,%esp
}
801001ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001af:	89 d8                	mov    %ebx,%eax
801001b1:	5b                   	pop    %ebx
801001b2:	5e                   	pop    %esi
801001b3:	5f                   	pop    %edi
801001b4:	5d                   	pop    %ebp
801001b5:	c3                   	ret    
  panic("bget: no buffers");
801001b6:	83 ec 0c             	sub    $0xc,%esp
801001b9:	68 8e 7b 10 80       	push   $0x80107b8e
801001be:	e8 0d 02 00 00       	call   801003d0 <panic>
801001c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 10             	sub    $0x10,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001da:	8d 43 0c             	lea    0xc(%ebx),%eax
801001dd:	50                   	push   %eax
801001de:	e8 cd 46 00 00       	call   801048b0 <holdingsleep>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	85 c0                	test   %eax,%eax
801001e8:	74 0f                	je     801001f9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ea:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001f3:	c9                   	leave  
  iderw(b);
801001f4:	e9 d7 21 00 00       	jmp    801023d0 <iderw>
    panic("bwrite");
801001f9:	83 ec 0c             	sub    $0xc,%esp
801001fc:	68 9f 7b 10 80       	push   $0x80107b9f
80100201:	e8 ca 01 00 00       	call   801003d0 <panic>
80100206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010020d:	8d 76 00             	lea    0x0(%esi),%esi

80100210 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100210:	55                   	push   %ebp
80100211:	89 e5                	mov    %esp,%ebp
80100213:	56                   	push   %esi
80100214:	53                   	push   %ebx
80100215:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100218:	8d 73 0c             	lea    0xc(%ebx),%esi
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 8c 46 00 00       	call   801048b0 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	0f 84 87 00 00 00    	je     801002b6 <brelse+0xa6>
    panic("brelse");

  releasesleep(&b->lock);
8010022f:	83 ec 0c             	sub    $0xc,%esp
80100232:	56                   	push   %esi
80100233:	e8 38 46 00 00       	call   80104870 <releasesleep>

  acquire(&bcache.lock);
80100238:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010023f:	e8 8c 48 00 00       	call   80104ad0 <acquire>
  b->refcnt--;
80100244:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
  if (b->refcnt == 0) {
8010024a:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010024d:	83 e8 01             	sub    $0x1,%eax
80100250:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
  if (b->refcnt == 0) {
80100256:	85 c0                	test   %eax,%eax
80100258:	75 4a                	jne    801002a4 <brelse+0x94>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010025a:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80100260:	8b 93 a0 00 00 00    	mov    0xa0(%ebx),%edx
80100266:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
    b->prev->next = b->next;
8010026c:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80100272:	8b 93 a4 00 00 00    	mov    0xa4(%ebx),%edx
80100278:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
    b->next = bcache.head.next;
8010027e:	a1 70 06 11 80       	mov    0x80110670,%eax
    b->prev = &bcache.head;
80100283:	c7 83 a0 00 00 00 cc 	movl   $0x801105cc,0xa0(%ebx)
8010028a:	05 11 80 
    b->next = bcache.head.next;
8010028d:	89 83 a4 00 00 00    	mov    %eax,0xa4(%ebx)
    bcache.head.next->prev = b;
80100293:	a1 70 06 11 80       	mov    0x80110670,%eax
80100298:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
    bcache.head.next = b;
8010029e:	89 1d 70 06 11 80    	mov    %ebx,0x80110670
  }
  
  release(&bcache.lock);
801002a4:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
801002ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
801002ae:	5b                   	pop    %ebx
801002af:	5e                   	pop    %esi
801002b0:	5d                   	pop    %ebp
  release(&bcache.lock);
801002b1:	e9 ba 47 00 00       	jmp    80104a70 <release>
    panic("brelse");
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 a6 7b 10 80       	push   $0x80107ba6
801002be:	e8 0d 01 00 00       	call   801003d0 <panic>
801002c3:	66 90                	xchg   %ax,%ax
801002c5:	66 90                	xchg   %ax,%ax
801002c7:	66 90                	xchg   %ax,%ax
801002c9:	66 90                	xchg   %ax,%ax
801002cb:	66 90                	xchg   %ax,%ax
801002cd:	66 90                	xchg   %ax,%ax
801002cf:	90                   	nop

801002d0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	57                   	push   %edi
801002d4:	56                   	push   %esi
801002d5:	53                   	push   %ebx
801002d6:	83 ec 18             	sub    $0x18,%esp
801002d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002df:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002e2:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002e4:	e8 f7 15 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
801002e9:	c7 04 24 20 09 11 80 	movl   $0x80110920,(%esp)
801002f0:	e8 db 47 00 00       	call   80104ad0 <acquire>
  while(n > 0){
801002f5:	83 c4 10             	add    $0x10,%esp
801002f8:	85 db                	test   %ebx,%ebx
801002fa:	0f 8e 94 00 00 00    	jle    80100394 <consoleread+0xc4>
    while(input.r == input.w){
80100300:	a1 00 09 11 80       	mov    0x80110900,%eax
80100305:	3b 05 04 09 11 80    	cmp    0x80110904,%eax
8010030b:	74 25                	je     80100332 <consoleread+0x62>
8010030d:	eb 59                	jmp    80100368 <consoleread+0x98>
8010030f:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100310:	83 ec 08             	sub    $0x8,%esp
80100313:	68 20 09 11 80       	push   $0x80110920
80100318:	68 00 09 11 80       	push   $0x80110900
8010031d:	e8 6e 3e 00 00       	call   80104190 <sleep>
    while(input.r == input.w){
80100322:	a1 00 09 11 80       	mov    0x80110900,%eax
80100327:	83 c4 10             	add    $0x10,%esp
8010032a:	3b 05 04 09 11 80    	cmp    0x80110904,%eax
80100330:	75 36                	jne    80100368 <consoleread+0x98>
      if(myproc()->killed){
80100332:	e8 a9 37 00 00       	call   80103ae0 <myproc>
80100337:	8b 48 24             	mov    0x24(%eax),%ecx
8010033a:	85 c9                	test   %ecx,%ecx
8010033c:	74 d2                	je     80100310 <consoleread+0x40>
        release(&cons.lock);
8010033e:	83 ec 0c             	sub    $0xc,%esp
80100341:	68 20 09 11 80       	push   $0x80110920
80100346:	e8 25 47 00 00       	call   80104a70 <release>
        ilock(ip);
8010034b:	5a                   	pop    %edx
8010034c:	ff 75 08             	push   0x8(%ebp)
8010034f:	e8 9c 14 00 00       	call   801017f0 <ilock>
        return -1;
80100354:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100357:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010035a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010035f:	5b                   	pop    %ebx
80100360:	5e                   	pop    %esi
80100361:	5f                   	pop    %edi
80100362:	5d                   	pop    %ebp
80100363:	c3                   	ret    
80100364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100368:	8d 50 01             	lea    0x1(%eax),%edx
8010036b:	89 15 00 09 11 80    	mov    %edx,0x80110900
80100371:	89 c2                	mov    %eax,%edx
80100373:	83 e2 7f             	and    $0x7f,%edx
80100376:	0f be 8a 80 08 11 80 	movsbl -0x7feef780(%edx),%ecx
    if(c == C('D')){  // EOF
8010037d:	80 f9 04             	cmp    $0x4,%cl
80100380:	74 37                	je     801003b9 <consoleread+0xe9>
    *dst++ = c;
80100382:	83 c6 01             	add    $0x1,%esi
    --n;
80100385:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100388:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010038b:	83 f9 0a             	cmp    $0xa,%ecx
8010038e:	0f 85 64 ff ff ff    	jne    801002f8 <consoleread+0x28>
  release(&cons.lock);
80100394:	83 ec 0c             	sub    $0xc,%esp
80100397:	68 20 09 11 80       	push   $0x80110920
8010039c:	e8 cf 46 00 00       	call   80104a70 <release>
  ilock(ip);
801003a1:	58                   	pop    %eax
801003a2:	ff 75 08             	push   0x8(%ebp)
801003a5:	e8 46 14 00 00       	call   801017f0 <ilock>
  return target - n;
801003aa:	89 f8                	mov    %edi,%eax
801003ac:	83 c4 10             	add    $0x10,%esp
}
801003af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
801003b2:	29 d8                	sub    %ebx,%eax
}
801003b4:	5b                   	pop    %ebx
801003b5:	5e                   	pop    %esi
801003b6:	5f                   	pop    %edi
801003b7:	5d                   	pop    %ebp
801003b8:	c3                   	ret    
      if(n < target){
801003b9:	39 fb                	cmp    %edi,%ebx
801003bb:	73 d7                	jae    80100394 <consoleread+0xc4>
        input.r--;
801003bd:	a3 00 09 11 80       	mov    %eax,0x80110900
801003c2:	eb d0                	jmp    80100394 <consoleread+0xc4>
801003c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003cf:	90                   	nop

801003d0 <panic>:
{
801003d0:	55                   	push   %ebp
801003d1:	89 e5                	mov    %esp,%ebp
801003d3:	56                   	push   %esi
801003d4:	53                   	push   %ebx
801003d5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003d8:	fa                   	cli    
  cons.locking = 0;
801003d9:	c7 05 a4 09 11 80 00 	movl   $0x0,0x801109a4
801003e0:	00 00 00 
  getcallerpcs(&s, pcs);
801003e3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003e6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003e9:	e8 02 26 00 00       	call   801029f0 <lapicid>
801003ee:	83 ec 08             	sub    $0x8,%esp
801003f1:	50                   	push   %eax
801003f2:	68 ad 7b 10 80       	push   $0x80107bad
801003f7:	e8 f4 02 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003fc:	58                   	pop    %eax
801003fd:	ff 75 08             	push   0x8(%ebp)
80100400:	e8 eb 02 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
80100405:	c7 04 24 f7 85 10 80 	movl   $0x801085f7,(%esp)
8010040c:	e8 df 02 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
80100411:	8d 45 08             	lea    0x8(%ebp),%eax
80100414:	5a                   	pop    %edx
80100415:	59                   	pop    %ecx
80100416:	53                   	push   %ebx
80100417:	50                   	push   %eax
80100418:	e8 03 45 00 00       	call   80104920 <getcallerpcs>
  for(i=0; i<10; i++)
8010041d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100420:	83 ec 08             	sub    $0x8,%esp
80100423:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
80100425:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100428:	68 c1 7b 10 80       	push   $0x80107bc1
8010042d:	e8 be 02 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
80100432:	83 c4 10             	add    $0x10,%esp
80100435:	39 f3                	cmp    %esi,%ebx
80100437:	75 e7                	jne    80100420 <panic+0x50>
  panicked = 1; // freeze other CPU
80100439:	c7 05 a8 09 11 80 01 	movl   $0x1,0x801109a8
80100440:	00 00 00 
  for(;;)
80100443:	eb fe                	jmp    80100443 <panic+0x73>
80100445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010044c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100450 <consputc.part.0>:
consputc(int c)
80100450:	55                   	push   %ebp
80100451:	89 e5                	mov    %esp,%ebp
80100453:	57                   	push   %edi
80100454:	56                   	push   %esi
80100455:	53                   	push   %ebx
80100456:	89 c3                	mov    %eax,%ebx
80100458:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010045b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100460:	0f 84 ea 00 00 00    	je     80100550 <consputc.part.0+0x100>
    uartputc(c);
80100466:	83 ec 0c             	sub    $0xc,%esp
80100469:	50                   	push   %eax
8010046a:	e8 61 61 00 00       	call   801065d0 <uartputc>
8010046f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100472:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100477:	b8 0e 00 00 00       	mov    $0xe,%eax
8010047c:	89 fa                	mov    %edi,%edx
8010047e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010047f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100484:	89 f2                	mov    %esi,%edx
80100486:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100487:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048a:	89 fa                	mov    %edi,%edx
8010048c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100491:	c1 e1 08             	shl    $0x8,%ecx
80100494:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100495:	89 f2                	mov    %esi,%edx
80100497:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100498:	0f b6 c0             	movzbl %al,%eax
8010049b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010049d:	83 fb 0a             	cmp    $0xa,%ebx
801004a0:	0f 84 92 00 00 00    	je     80100538 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
801004a6:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801004ac:	74 72                	je     80100520 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004ae:	0f b6 db             	movzbl %bl,%ebx
801004b1:	8d 70 01             	lea    0x1(%eax),%esi
801004b4:	80 cf 07             	or     $0x7,%bh
801004b7:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004be:	80 
  if(pos < 0 || pos > 25*80)
801004bf:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
801004c5:	0f 8f fb 00 00 00    	jg     801005c6 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
801004cb:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
801004d1:	0f 8f a9 00 00 00    	jg     80100580 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
801004d7:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
801004d9:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
801004e0:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
801004e3:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004e6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801004f0:	89 da                	mov    %ebx,%edx
801004f2:	ee                   	out    %al,(%dx)
801004f3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004f8:	89 f8                	mov    %edi,%eax
801004fa:	89 ca                	mov    %ecx,%edx
801004fc:	ee                   	out    %al,(%dx)
801004fd:	b8 0f 00 00 00       	mov    $0xf,%eax
80100502:	89 da                	mov    %ebx,%edx
80100504:	ee                   	out    %al,(%dx)
80100505:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100509:	89 ca                	mov    %ecx,%edx
8010050b:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010050c:	b8 20 07 00 00       	mov    $0x720,%eax
80100511:	66 89 06             	mov    %ax,(%esi)
}
80100514:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100517:	5b                   	pop    %ebx
80100518:	5e                   	pop    %esi
80100519:	5f                   	pop    %edi
8010051a:	5d                   	pop    %ebp
8010051b:	c3                   	ret    
8010051c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
80100520:	8d 70 ff             	lea    -0x1(%eax),%esi
80100523:	85 c0                	test   %eax,%eax
80100525:	75 98                	jne    801004bf <consputc.part.0+0x6f>
80100527:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
8010052b:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100530:	31 ff                	xor    %edi,%edi
80100532:	eb b2                	jmp    801004e6 <consputc.part.0+0x96>
80100534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100538:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010053d:	f7 e2                	mul    %edx
8010053f:	c1 ea 06             	shr    $0x6,%edx
80100542:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100545:	c1 e0 04             	shl    $0x4,%eax
80100548:	8d 70 50             	lea    0x50(%eax),%esi
8010054b:	e9 6f ff ff ff       	jmp    801004bf <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100550:	83 ec 0c             	sub    $0xc,%esp
80100553:	6a 08                	push   $0x8
80100555:	e8 76 60 00 00       	call   801065d0 <uartputc>
8010055a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100561:	e8 6a 60 00 00       	call   801065d0 <uartputc>
80100566:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010056d:	e8 5e 60 00 00       	call   801065d0 <uartputc>
80100572:	83 c4 10             	add    $0x10,%esp
80100575:	e9 f8 fe ff ff       	jmp    80100472 <consputc.part.0+0x22>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100580:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100583:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100586:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010058d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100592:	68 60 0e 00 00       	push   $0xe60
80100597:	68 a0 80 0b 80       	push   $0x800b80a0
8010059c:	68 00 80 0b 80       	push   $0x800b8000
801005a1:	e8 3a 48 00 00       	call   80104de0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005a6:	b8 80 07 00 00       	mov    $0x780,%eax
801005ab:	83 c4 0c             	add    $0xc,%esp
801005ae:	29 d8                	sub    %ebx,%eax
801005b0:	01 c0                	add    %eax,%eax
801005b2:	50                   	push   %eax
801005b3:	6a 00                	push   $0x0
801005b5:	56                   	push   %esi
801005b6:	e8 85 47 00 00       	call   80104d40 <memset>
  outb(CRTPORT+1, pos);
801005bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
801005be:	83 c4 10             	add    $0x10,%esp
801005c1:	e9 20 ff ff ff       	jmp    801004e6 <consputc.part.0+0x96>
    panic("pos under/overflow");
801005c6:	83 ec 0c             	sub    $0xc,%esp
801005c9:	68 c5 7b 10 80       	push   $0x80107bc5
801005ce:	e8 fd fd ff ff       	call   801003d0 <panic>
801005d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005e0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005e9:	ff 75 08             	push   0x8(%ebp)
{
801005ec:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ef:	e8 ec 12 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 09 11 80 	movl   $0x80110920,(%esp)
801005fb:	e8 d0 44 00 00       	call   80104ad0 <acquire>
  for(i = 0; i < n; i++)
80100600:	83 c4 10             	add    $0x10,%esp
80100603:	85 f6                	test   %esi,%esi
80100605:	7e 25                	jle    8010062c <consolewrite+0x4c>
80100607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010060a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010060d:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
    consputc(buf[i] & 0xff);
80100613:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100616:	85 d2                	test   %edx,%edx
80100618:	74 06                	je     80100620 <consolewrite+0x40>
  asm volatile("cli");
8010061a:	fa                   	cli    
    for(;;)
8010061b:	eb fe                	jmp    8010061b <consolewrite+0x3b>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
80100620:	e8 2b fe ff ff       	call   80100450 <consputc.part.0>
  for(i = 0; i < n; i++)
80100625:	83 c3 01             	add    $0x1,%ebx
80100628:	39 df                	cmp    %ebx,%edi
8010062a:	75 e1                	jne    8010060d <consolewrite+0x2d>
  release(&cons.lock);
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	68 20 09 11 80       	push   $0x80110920
80100634:	e8 37 44 00 00       	call   80104a70 <release>
  ilock(ip);
80100639:	58                   	pop    %eax
8010063a:	ff 75 08             	push   0x8(%ebp)
8010063d:	e8 ae 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100642:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100645:	89 f0                	mov    %esi,%eax
80100647:	5b                   	pop    %ebx
80100648:	5e                   	pop    %esi
80100649:	5f                   	pop    %edi
8010064a:	5d                   	pop    %ebp
8010064b:	c3                   	ret    
8010064c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100650 <printint>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 2c             	sub    $0x2c,%esp
80100659:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010065c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010065f:	85 c9                	test   %ecx,%ecx
80100661:	74 04                	je     80100667 <printint+0x17>
80100663:	85 c0                	test   %eax,%eax
80100665:	78 6d                	js     801006d4 <printint+0x84>
    x = xx;
80100667:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010066e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100670:	31 db                	xor    %ebx,%ebx
80100672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100678:	89 c8                	mov    %ecx,%eax
8010067a:	31 d2                	xor    %edx,%edx
8010067c:	89 de                	mov    %ebx,%esi
8010067e:	89 cf                	mov    %ecx,%edi
80100680:	f7 75 d4             	divl   -0x2c(%ebp)
80100683:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100686:	0f b6 92 f0 7b 10 80 	movzbl -0x7fef8410(%edx),%edx
  }while((x /= base) != 0);
8010068d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010068f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100693:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100696:	73 e0                	jae    80100678 <printint+0x28>
  if(sign)
80100698:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010069b:	85 c9                	test   %ecx,%ecx
8010069d:	74 0c                	je     801006ab <printint+0x5b>
    buf[i++] = '-';
8010069f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801006a4:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
801006a6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801006ab:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
801006af:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801006b2:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
801006b8:	85 d2                	test   %edx,%edx
801006ba:	74 04                	je     801006c0 <printint+0x70>
801006bc:	fa                   	cli    
    for(;;)
801006bd:	eb fe                	jmp    801006bd <printint+0x6d>
801006bf:	90                   	nop
801006c0:	e8 8b fd ff ff       	call   80100450 <consputc.part.0>
  while(--i >= 0)
801006c5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006c8:	39 c3                	cmp    %eax,%ebx
801006ca:	74 0e                	je     801006da <printint+0x8a>
    consputc(buf[i]);
801006cc:	0f be 03             	movsbl (%ebx),%eax
801006cf:	83 eb 01             	sub    $0x1,%ebx
801006d2:	eb de                	jmp    801006b2 <printint+0x62>
    x = -xx;
801006d4:	f7 d8                	neg    %eax
801006d6:	89 c1                	mov    %eax,%ecx
801006d8:	eb 96                	jmp    80100670 <printint+0x20>
}
801006da:	83 c4 2c             	add    $0x2c,%esp
801006dd:	5b                   	pop    %ebx
801006de:	5e                   	pop    %esi
801006df:	5f                   	pop    %edi
801006e0:	5d                   	pop    %ebp
801006e1:	c3                   	ret    
801006e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006f0 <cprintf>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006f9:	a1 a4 09 11 80       	mov    0x801109a4,%eax
801006fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100701:	85 c0                	test   %eax,%eax
80100703:	0f 85 27 01 00 00    	jne    80100830 <cprintf+0x140>
  if (fmt == 0)
80100709:	8b 75 08             	mov    0x8(%ebp),%esi
8010070c:	85 f6                	test   %esi,%esi
8010070e:	0f 84 ac 01 00 00    	je     801008c0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100714:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100717:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071a:	31 db                	xor    %ebx,%ebx
8010071c:	85 c0                	test   %eax,%eax
8010071e:	74 56                	je     80100776 <cprintf+0x86>
    if(c != '%'){
80100720:	83 f8 25             	cmp    $0x25,%eax
80100723:	0f 85 cf 00 00 00    	jne    801007f8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100729:	83 c3 01             	add    $0x1,%ebx
8010072c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100730:	85 d2                	test   %edx,%edx
80100732:	74 42                	je     80100776 <cprintf+0x86>
    switch(c){
80100734:	83 fa 70             	cmp    $0x70,%edx
80100737:	0f 84 90 00 00 00    	je     801007cd <cprintf+0xdd>
8010073d:	7f 51                	jg     80100790 <cprintf+0xa0>
8010073f:	83 fa 25             	cmp    $0x25,%edx
80100742:	0f 84 c0 00 00 00    	je     80100808 <cprintf+0x118>
80100748:	83 fa 64             	cmp    $0x64,%edx
8010074b:	0f 85 f4 00 00 00    	jne    80100845 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100751:	8d 47 04             	lea    0x4(%edi),%eax
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100761:	8b 07                	mov    (%edi),%eax
80100763:	e8 e8 fe ff ff       	call   80100650 <printint>
80100768:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
8010076e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100772:	85 c0                	test   %eax,%eax
80100774:	75 aa                	jne    80100720 <cprintf+0x30>
  if(locking)
80100776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100779:	85 c0                	test   %eax,%eax
8010077b:	0f 85 22 01 00 00    	jne    801008a3 <cprintf+0x1b3>
}
80100781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100784:	5b                   	pop    %ebx
80100785:	5e                   	pop    %esi
80100786:	5f                   	pop    %edi
80100787:	5d                   	pop    %ebp
80100788:	c3                   	ret    
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 fa 73             	cmp    $0x73,%edx
80100793:	75 33                	jne    801007c8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100795:	8d 47 04             	lea    0x4(%edi),%eax
80100798:	8b 3f                	mov    (%edi),%edi
8010079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010079d:	85 ff                	test   %edi,%edi
8010079f:	0f 84 e3 00 00 00    	je     80100888 <cprintf+0x198>
      for(; *s; s++)
801007a5:	0f be 07             	movsbl (%edi),%eax
801007a8:	84 c0                	test   %al,%al
801007aa:	0f 84 08 01 00 00    	je     801008b8 <cprintf+0x1c8>
  if(panicked){
801007b0:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
801007b6:	85 d2                	test   %edx,%edx
801007b8:	0f 84 b2 00 00 00    	je     80100870 <cprintf+0x180>
801007be:	fa                   	cli    
    for(;;)
801007bf:	eb fe                	jmp    801007bf <cprintf+0xcf>
801007c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007c8:	83 fa 78             	cmp    $0x78,%edx
801007cb:	75 78                	jne    80100845 <cprintf+0x155>
      printint(*argp++, 16, 0);
801007cd:	8d 47 04             	lea    0x4(%edi),%eax
801007d0:	31 c9                	xor    %ecx,%ecx
801007d2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007d7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007da:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007dd:	8b 07                	mov    (%edi),%eax
801007df:	e8 6c fe ff ff       	call   80100650 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 2d ff ff ff    	jne    80100720 <cprintf+0x30>
801007f3:	eb 81                	jmp    80100776 <cprintf+0x86>
801007f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007f8:	8b 0d a8 09 11 80    	mov    0x801109a8,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 14                	je     80100816 <cprintf+0x126>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x113>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100808:	a1 a8 09 11 80       	mov    0x801109a8,%eax
8010080d:	85 c0                	test   %eax,%eax
8010080f:	75 6c                	jne    8010087d <cprintf+0x18d>
80100811:	b8 25 00 00 00       	mov    $0x25,%eax
80100816:	e8 35 fc ff ff       	call   80100450 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010081b:	83 c3 01             	add    $0x1,%ebx
8010081e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100822:	85 c0                	test   %eax,%eax
80100824:	0f 85 f6 fe ff ff    	jne    80100720 <cprintf+0x30>
8010082a:	e9 47 ff ff ff       	jmp    80100776 <cprintf+0x86>
8010082f:	90                   	nop
    acquire(&cons.lock);
80100830:	83 ec 0c             	sub    $0xc,%esp
80100833:	68 20 09 11 80       	push   $0x80110920
80100838:	e8 93 42 00 00       	call   80104ad0 <acquire>
8010083d:	83 c4 10             	add    $0x10,%esp
80100840:	e9 c4 fe ff ff       	jmp    80100709 <cprintf+0x19>
  if(panicked){
80100845:	8b 0d a8 09 11 80    	mov    0x801109a8,%ecx
8010084b:	85 c9                	test   %ecx,%ecx
8010084d:	75 31                	jne    80100880 <cprintf+0x190>
8010084f:	b8 25 00 00 00       	mov    $0x25,%eax
80100854:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100857:	e8 f4 fb ff ff       	call   80100450 <consputc.part.0>
8010085c:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
80100862:	85 d2                	test   %edx,%edx
80100864:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100867:	74 2e                	je     80100897 <cprintf+0x1a7>
80100869:	fa                   	cli    
    for(;;)
8010086a:	eb fe                	jmp    8010086a <cprintf+0x17a>
8010086c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100870:	e8 db fb ff ff       	call   80100450 <consputc.part.0>
      for(; *s; s++)
80100875:	83 c7 01             	add    $0x1,%edi
80100878:	e9 28 ff ff ff       	jmp    801007a5 <cprintf+0xb5>
8010087d:	fa                   	cli    
    for(;;)
8010087e:	eb fe                	jmp    8010087e <cprintf+0x18e>
80100880:	fa                   	cli    
80100881:	eb fe                	jmp    80100881 <cprintf+0x191>
80100883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100887:	90                   	nop
        s = "(null)";
80100888:	bf d8 7b 10 80       	mov    $0x80107bd8,%edi
      for(; *s; s++)
8010088d:	b8 28 00 00 00       	mov    $0x28,%eax
80100892:	e9 19 ff ff ff       	jmp    801007b0 <cprintf+0xc0>
80100897:	89 d0                	mov    %edx,%eax
80100899:	e8 b2 fb ff ff       	call   80100450 <consputc.part.0>
8010089e:	e9 c8 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    release(&cons.lock);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 20 09 11 80       	push   $0x80110920
801008ab:	e8 c0 41 00 00       	call   80104a70 <release>
801008b0:	83 c4 10             	add    $0x10,%esp
}
801008b3:	e9 c9 fe ff ff       	jmp    80100781 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008bb:	e9 ab fe ff ff       	jmp    8010076b <cprintf+0x7b>
    panic("null fmt");
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	68 df 7b 10 80       	push   $0x80107bdf
801008c8:	e8 03 fb ff ff       	call   801003d0 <panic>
801008cd:	8d 76 00             	lea    0x0(%esi),%esi

801008d0 <consoleintr>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
801008d4:	56                   	push   %esi
  int c, doprocdump = 0;
801008d5:	31 f6                	xor    %esi,%esi
{
801008d7:	53                   	push   %ebx
801008d8:	83 ec 18             	sub    $0x18,%esp
801008db:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008de:	68 20 09 11 80       	push   $0x80110920
801008e3:	e8 e8 41 00 00       	call   80104ad0 <acquire>
  while((c = getc()) >= 0){
801008e8:	83 c4 10             	add    $0x10,%esp
801008eb:	eb 1a                	jmp    80100907 <consoleintr+0x37>
801008ed:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008f0:	83 fb 08             	cmp    $0x8,%ebx
801008f3:	0f 84 d7 00 00 00    	je     801009d0 <consoleintr+0x100>
801008f9:	83 fb 10             	cmp    $0x10,%ebx
801008fc:	0f 85 32 01 00 00    	jne    80100a34 <consoleintr+0x164>
80100902:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100907:	ff d7                	call   *%edi
80100909:	89 c3                	mov    %eax,%ebx
8010090b:	85 c0                	test   %eax,%eax
8010090d:	0f 88 05 01 00 00    	js     80100a18 <consoleintr+0x148>
    switch(c){
80100913:	83 fb 15             	cmp    $0x15,%ebx
80100916:	74 78                	je     80100990 <consoleintr+0xc0>
80100918:	7e d6                	jle    801008f0 <consoleintr+0x20>
8010091a:	83 fb 7f             	cmp    $0x7f,%ebx
8010091d:	0f 84 ad 00 00 00    	je     801009d0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100923:	a1 08 09 11 80       	mov    0x80110908,%eax
80100928:	89 c2                	mov    %eax,%edx
8010092a:	2b 15 00 09 11 80    	sub    0x80110900,%edx
80100930:	83 fa 7f             	cmp    $0x7f,%edx
80100933:	77 d2                	ja     80100907 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100935:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100938:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010093e:	83 e0 7f             	and    $0x7f,%eax
80100941:	89 0d 08 09 11 80    	mov    %ecx,0x80110908
        c = (c == '\r') ? '\n' : c;
80100947:	83 fb 0d             	cmp    $0xd,%ebx
8010094a:	0f 84 13 01 00 00    	je     80100a63 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100950:	88 98 80 08 11 80    	mov    %bl,-0x7feef780(%eax)
  if(panicked){
80100956:	85 d2                	test   %edx,%edx
80100958:	0f 85 10 01 00 00    	jne    80100a6e <consoleintr+0x19e>
8010095e:	89 d8                	mov    %ebx,%eax
80100960:	e8 eb fa ff ff       	call   80100450 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100965:	83 fb 0a             	cmp    $0xa,%ebx
80100968:	0f 84 14 01 00 00    	je     80100a82 <consoleintr+0x1b2>
8010096e:	83 fb 04             	cmp    $0x4,%ebx
80100971:	0f 84 0b 01 00 00    	je     80100a82 <consoleintr+0x1b2>
80100977:	a1 00 09 11 80       	mov    0x80110900,%eax
8010097c:	83 e8 80             	sub    $0xffffff80,%eax
8010097f:	39 05 08 09 11 80    	cmp    %eax,0x80110908
80100985:	75 80                	jne    80100907 <consoleintr+0x37>
80100987:	e9 fb 00 00 00       	jmp    80100a87 <consoleintr+0x1b7>
8010098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100990:	a1 08 09 11 80       	mov    0x80110908,%eax
80100995:	39 05 04 09 11 80    	cmp    %eax,0x80110904
8010099b:	0f 84 66 ff ff ff    	je     80100907 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009a1:	83 e8 01             	sub    $0x1,%eax
801009a4:	89 c2                	mov    %eax,%edx
801009a6:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009a9:	80 ba 80 08 11 80 0a 	cmpb   $0xa,-0x7feef780(%edx)
801009b0:	0f 84 51 ff ff ff    	je     80100907 <consoleintr+0x37>
  if(panicked){
801009b6:	8b 15 a8 09 11 80    	mov    0x801109a8,%edx
        input.e--;
801009bc:	a3 08 09 11 80       	mov    %eax,0x80110908
  if(panicked){
801009c1:	85 d2                	test   %edx,%edx
801009c3:	74 33                	je     801009f8 <consoleintr+0x128>
801009c5:	fa                   	cli    
    for(;;)
801009c6:	eb fe                	jmp    801009c6 <consoleintr+0xf6>
801009c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009cf:	90                   	nop
      if(input.e != input.w){
801009d0:	a1 08 09 11 80       	mov    0x80110908,%eax
801009d5:	3b 05 04 09 11 80    	cmp    0x80110904,%eax
801009db:	0f 84 26 ff ff ff    	je     80100907 <consoleintr+0x37>
        input.e--;
801009e1:	83 e8 01             	sub    $0x1,%eax
801009e4:	a3 08 09 11 80       	mov    %eax,0x80110908
  if(panicked){
801009e9:	a1 a8 09 11 80       	mov    0x801109a8,%eax
801009ee:	85 c0                	test   %eax,%eax
801009f0:	74 56                	je     80100a48 <consoleintr+0x178>
801009f2:	fa                   	cli    
    for(;;)
801009f3:	eb fe                	jmp    801009f3 <consoleintr+0x123>
801009f5:	8d 76 00             	lea    0x0(%esi),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 4e fa ff ff       	call   80100450 <consputc.part.0>
      while(input.e != input.w &&
80100a02:	a1 08 09 11 80       	mov    0x80110908,%eax
80100a07:	3b 05 04 09 11 80    	cmp    0x80110904,%eax
80100a0d:	75 92                	jne    801009a1 <consoleintr+0xd1>
80100a0f:	e9 f3 fe ff ff       	jmp    80100907 <consoleintr+0x37>
80100a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100a18:	83 ec 0c             	sub    $0xc,%esp
80100a1b:	68 20 09 11 80       	push   $0x80110920
80100a20:	e8 4b 40 00 00       	call   80104a70 <release>
  if(doprocdump) {
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	85 f6                	test   %esi,%esi
80100a2a:	75 2b                	jne    80100a57 <consoleintr+0x187>
}
80100a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a2f:	5b                   	pop    %ebx
80100a30:	5e                   	pop    %esi
80100a31:	5f                   	pop    %edi
80100a32:	5d                   	pop    %ebp
80100a33:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a34:	85 db                	test   %ebx,%ebx
80100a36:	0f 84 cb fe ff ff    	je     80100907 <consoleintr+0x37>
80100a3c:	e9 e2 fe ff ff       	jmp    80100923 <consoleintr+0x53>
80100a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a48:	b8 00 01 00 00       	mov    $0x100,%eax
80100a4d:	e8 fe f9 ff ff       	call   80100450 <consputc.part.0>
80100a52:	e9 b0 fe ff ff       	jmp    80100907 <consoleintr+0x37>
}
80100a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5a:	5b                   	pop    %ebx
80100a5b:	5e                   	pop    %esi
80100a5c:	5f                   	pop    %edi
80100a5d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a5e:	e9 cd 38 00 00       	jmp    80104330 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a63:	c6 80 80 08 11 80 0a 	movb   $0xa,-0x7feef780(%eax)
  if(panicked){
80100a6a:	85 d2                	test   %edx,%edx
80100a6c:	74 0a                	je     80100a78 <consoleintr+0x1a8>
80100a6e:	fa                   	cli    
    for(;;)
80100a6f:	eb fe                	jmp    80100a6f <consoleintr+0x19f>
80100a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a78:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a7d:	e8 ce f9 ff ff       	call   80100450 <consputc.part.0>
          input.w = input.e;
80100a82:	a1 08 09 11 80       	mov    0x80110908,%eax
          wakeup(&input.r);
80100a87:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a8a:	a3 04 09 11 80       	mov    %eax,0x80110904
          wakeup(&input.r);
80100a8f:	68 00 09 11 80       	push   $0x80110900
80100a94:	e8 b7 37 00 00       	call   80104250 <wakeup>
80100a99:	83 c4 10             	add    $0x10,%esp
80100a9c:	e9 66 fe ff ff       	jmp    80100907 <consoleintr+0x37>
80100aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aaf:	90                   	nop

80100ab0 <consoleinit>:

void
consoleinit(void)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ab6:	68 e8 7b 10 80       	push   $0x80107be8
80100abb:	68 20 09 11 80       	push   $0x80110920
80100ac0:	e8 3b 3e 00 00       	call   80104900 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ac5:	58                   	pop    %eax
80100ac6:	5a                   	pop    %edx
80100ac7:	6a 00                	push   $0x0
80100ac9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100acb:	c7 05 cc 13 11 80 e0 	movl   $0x801005e0,0x801113cc
80100ad2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad5:	c7 05 c8 13 11 80 d0 	movl   $0x801002d0,0x801113c8
80100adc:	02 10 80 
  cons.locking = 1;
80100adf:	c7 05 a4 09 11 80 01 	movl   $0x1,0x801109a4
80100ae6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ae9:	e8 92 1a 00 00       	call   80102580 <ioapicenable>
}
80100aee:	83 c4 10             	add    $0x10,%esp
80100af1:	c9                   	leave  
80100af2:	c3                   	ret    
80100af3:	66 90                	xchg   %ax,%ax
80100af5:	66 90                	xchg   %ax,%ax
80100af7:	66 90                	xchg   %ax,%ax
80100af9:	66 90                	xchg   %ax,%ax
80100afb:	66 90                	xchg   %ax,%ax
80100afd:	66 90                	xchg   %ax,%ax
80100aff:	90                   	nop

80100b00 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
80100b06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b0c:	e8 cf 2f 00 00       	call   80103ae0 <myproc>
80100b11:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b17:	e8 54 23 00 00       	call   80102e70 <begin_op>

  if((ip = namei(path)) == 0){
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	ff 75 08             	push   0x8(%ebp)
80100b22:	e8 69 16 00 00       	call   80102190 <namei>
80100b27:	83 c4 10             	add    $0x10,%esp
80100b2a:	85 c0                	test   %eax,%eax
80100b2c:	0f 84 02 03 00 00    	je     80100e34 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b32:	83 ec 0c             	sub    $0xc,%esp
80100b35:	89 c3                	mov    %eax,%ebx
80100b37:	50                   	push   %eax
80100b38:	e8 b3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b3d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b43:	6a 34                	push   $0x34
80100b45:	6a 00                	push   $0x0
80100b47:	50                   	push   %eax
80100b48:	53                   	push   %ebx
80100b49:	e8 f2 0f 00 00       	call   80101b40 <readi>
80100b4e:	83 c4 20             	add    $0x20,%esp
80100b51:	83 f8 34             	cmp    $0x34,%eax
80100b54:	74 22                	je     80100b78 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b56:	83 ec 0c             	sub    $0xc,%esp
80100b59:	53                   	push   %ebx
80100b5a:	e8 51 0f 00 00       	call   80101ab0 <iunlockput>
    end_op();
80100b5f:	e8 7c 23 00 00       	call   80102ee0 <end_op>
80100b64:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b6f:	5b                   	pop    %ebx
80100b70:	5e                   	pop    %esi
80100b71:	5f                   	pop    %edi
80100b72:	5d                   	pop    %ebp
80100b73:	c3                   	ret    
80100b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b78:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b7f:	45 4c 46 
80100b82:	75 d2                	jne    80100b56 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b84:	e8 d7 6b 00 00       	call   80107760 <setupkvm>
80100b89:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b8f:	85 c0                	test   %eax,%eax
80100b91:	74 c3                	je     80100b56 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b93:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b9a:	00 
80100b9b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ba1:	0f 84 ac 02 00 00    	je     80100e53 <exec+0x353>
  sz = 0;
80100ba7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bae:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb1:	31 ff                	xor    %edi,%edi
80100bb3:	e9 8e 00 00 00       	jmp    80100c46 <exec+0x146>
80100bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bbf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100bc0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bc7:	75 6c                	jne    80100c35 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100bc9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bcf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bd5:	0f 82 87 00 00 00    	jb     80100c62 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bdb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100be1:	72 7f                	jb     80100c62 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100be3:	83 ec 04             	sub    $0x4,%esp
80100be6:	50                   	push   %eax
80100be7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf3:	e8 88 69 00 00       	call   80107580 <allocuvm>
80100bf8:	83 c4 10             	add    $0x10,%esp
80100bfb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c01:	85 c0                	test   %eax,%eax
80100c03:	74 5d                	je     80100c62 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100c05:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c0b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c10:	75 50                	jne    80100c62 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c1b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c21:	53                   	push   %ebx
80100c22:	50                   	push   %eax
80100c23:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c29:	e8 62 68 00 00       	call   80107490 <loaduvm>
80100c2e:	83 c4 20             	add    $0x20,%esp
80100c31:	85 c0                	test   %eax,%eax
80100c33:	78 2d                	js     80100c62 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c35:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c3c:	83 c7 01             	add    $0x1,%edi
80100c3f:	83 c6 20             	add    $0x20,%esi
80100c42:	39 f8                	cmp    %edi,%eax
80100c44:	7e 3a                	jle    80100c80 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c46:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c4c:	6a 20                	push   $0x20
80100c4e:	56                   	push   %esi
80100c4f:	50                   	push   %eax
80100c50:	53                   	push   %ebx
80100c51:	e8 ea 0e 00 00       	call   80101b40 <readi>
80100c56:	83 c4 10             	add    $0x10,%esp
80100c59:	83 f8 20             	cmp    $0x20,%eax
80100c5c:	0f 84 5e ff ff ff    	je     80100bc0 <exec+0xc0>
    freevm(pgdir);
80100c62:	83 ec 0c             	sub    $0xc,%esp
80100c65:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c6b:	e8 70 6a 00 00       	call   801076e0 <freevm>
  if(ip){
80100c70:	83 c4 10             	add    $0x10,%esp
80100c73:	e9 de fe ff ff       	jmp    80100b56 <exec+0x56>
80100c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c7f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c80:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c86:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c8c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c92:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c98:	83 ec 0c             	sub    $0xc,%esp
80100c9b:	53                   	push   %ebx
80100c9c:	e8 0f 0e 00 00       	call   80101ab0 <iunlockput>
  end_op();
80100ca1:	e8 3a 22 00 00       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca6:	83 c4 0c             	add    $0xc,%esp
80100ca9:	56                   	push   %esi
80100caa:	57                   	push   %edi
80100cab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cb1:	57                   	push   %edi
80100cb2:	e8 c9 68 00 00       	call   80107580 <allocuvm>
80100cb7:	83 c4 10             	add    $0x10,%esp
80100cba:	89 c6                	mov    %eax,%esi
80100cbc:	85 c0                	test   %eax,%eax
80100cbe:	0f 84 94 00 00 00    	je     80100d58 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc4:	83 ec 08             	sub    $0x8,%esp
80100cc7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100ccd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ccf:	50                   	push   %eax
80100cd0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100cd1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	e8 28 6b 00 00       	call   80107800 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cdb:	83 c4 10             	add    $0x10,%esp
80100cde:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100ce4:	8b 00                	mov    (%eax),%eax
80100ce6:	85 c0                	test   %eax,%eax
80100ce8:	0f 84 8b 00 00 00    	je     80100d79 <exec+0x279>
80100cee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100cf4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cfa:	eb 23                	jmp    80100d1f <exec+0x21f>
80100cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d00:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d03:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d0a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d0d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d13:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d16:	85 c0                	test   %eax,%eax
80100d18:	74 59                	je     80100d73 <exec+0x273>
    if(argc >= MAXARG)
80100d1a:	83 ff 20             	cmp    $0x20,%edi
80100d1d:	74 39                	je     80100d58 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d1f:	83 ec 0c             	sub    $0xc,%esp
80100d22:	50                   	push   %eax
80100d23:	e8 18 42 00 00       	call   80104f40 <strlen>
80100d28:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2a:	58                   	pop    %eax
80100d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d31:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d34:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d37:	e8 04 42 00 00       	call   80104f40 <strlen>
80100d3c:	83 c0 01             	add    $0x1,%eax
80100d3f:	50                   	push   %eax
80100d40:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d43:	ff 34 b8             	push   (%eax,%edi,4)
80100d46:	53                   	push   %ebx
80100d47:	56                   	push   %esi
80100d48:	e8 83 6c 00 00       	call   801079d0 <copyout>
80100d4d:	83 c4 20             	add    $0x20,%esp
80100d50:	85 c0                	test   %eax,%eax
80100d52:	79 ac                	jns    80100d00 <exec+0x200>
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d58:	83 ec 0c             	sub    $0xc,%esp
80100d5b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d61:	e8 7a 69 00 00       	call   801076e0 <freevm>
80100d66:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d6e:	e9 f9 fd ff ff       	jmp    80100b6c <exec+0x6c>
80100d73:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d79:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d80:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d82:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d89:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d8f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d92:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d98:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d9a:	50                   	push   %eax
80100d9b:	52                   	push   %edx
80100d9c:	53                   	push   %ebx
80100d9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100da3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100daa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dad:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db3:	e8 18 6c 00 00       	call   801079d0 <copyout>
80100db8:	83 c4 10             	add    $0x10,%esp
80100dbb:	85 c0                	test   %eax,%eax
80100dbd:	78 99                	js     80100d58 <exec+0x258>
  for(last=s=path; *s; s++)
80100dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80100dc2:	8b 55 08             	mov    0x8(%ebp),%edx
80100dc5:	0f b6 00             	movzbl (%eax),%eax
80100dc8:	84 c0                	test   %al,%al
80100dca:	74 13                	je     80100ddf <exec+0x2df>
80100dcc:	89 d1                	mov    %edx,%ecx
80100dce:	66 90                	xchg   %ax,%ax
      last = s+1;
80100dd0:	83 c1 01             	add    $0x1,%ecx
80100dd3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100dd5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100dd8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100ddb:	84 c0                	test   %al,%al
80100ddd:	75 f1                	jne    80100dd0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ddf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100de5:	83 ec 04             	sub    $0x4,%esp
80100de8:	6a 10                	push   $0x10
80100dea:	89 f8                	mov    %edi,%eax
80100dec:	52                   	push   %edx
80100ded:	83 c0 6c             	add    $0x6c,%eax
80100df0:	50                   	push   %eax
80100df1:	e8 0a 41 00 00       	call   80104f00 <safestrcpy>
  curproc->pgdir = pgdir;
80100df6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dfc:	89 f8                	mov    %edi,%eax
80100dfe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100e01:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100e03:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e06:	89 c1                	mov    %eax,%ecx
80100e08:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e0e:	8b 40 18             	mov    0x18(%eax),%eax
80100e11:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e14:	8b 41 18             	mov    0x18(%ecx),%eax
80100e17:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e1a:	89 0c 24             	mov    %ecx,(%esp)
80100e1d:	e8 de 64 00 00       	call   80107300 <switchuvm>
  freevm(oldpgdir);
80100e22:	89 3c 24             	mov    %edi,(%esp)
80100e25:	e8 b6 68 00 00       	call   801076e0 <freevm>
  return 0;
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	31 c0                	xor    %eax,%eax
80100e2f:	e9 38 fd ff ff       	jmp    80100b6c <exec+0x6c>
    end_op();
80100e34:	e8 a7 20 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100e39:	83 ec 0c             	sub    $0xc,%esp
80100e3c:	68 01 7c 10 80       	push   $0x80107c01
80100e41:	e8 aa f8 ff ff       	call   801006f0 <cprintf>
    return -1;
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e4e:	e9 19 fd ff ff       	jmp    80100b6c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e53:	be 00 20 00 00       	mov    $0x2000,%esi
80100e58:	31 ff                	xor    %edi,%edi
80100e5a:	e9 39 fe ff ff       	jmp    80100c98 <exec+0x198>
80100e5f:	90                   	nop

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 0d 7c 10 80       	push   $0x80107c0d
80100e6b:	68 c0 09 11 80       	push   $0x801109c0
80100e70:	e8 8b 3a 00 00       	call   80104900 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave  
80100e79:	c3                   	ret    
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 44 0a 11 80       	mov    $0x80110a44,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 c0 09 11 80       	push   $0x801109c0
80100e91:	e8 3a 3c 00 00       	call   80104ad0 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb a4 13 11 80    	cmp    $0x801113a4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 c0 09 11 80       	push   $0x801109c0
80100ec1:	e8 aa 3b 00 00       	call   80104a70 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave  
80100ecf:	c3                   	ret    
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 c0 09 11 80       	push   $0x801109c0
80100eda:	e8 91 3b 00 00       	call   80104a70 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave  
80100ee8:	c3                   	ret    
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 c0 09 11 80       	push   $0x801109c0
80100eff:	e8 cc 3b 00 00       	call   80104ad0 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 c0 09 11 80       	push   $0x801109c0
80100f1c:	e8 4f 3b 00 00       	call   80104a70 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 14 7c 10 80       	push   $0x80107c14
80100f30:	e8 9b f4 ff ff       	call   801003d0 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 c0 09 11 80       	push   $0x801109c0
80100f51:	e8 7a 3b 00 00       	call   80104ad0 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f84:	68 c0 09 11 80       	push   $0x801109c0
  ff = *f;
80100f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f8c:	e8 df 3a 00 00       	call   80104a70 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret    
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 c0 09 11 80 	movl   $0x801109c0,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 ad 3a 00 00       	jmp    80104a70 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 a3 1e 00 00       	call   80102e70 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 58 09 00 00       	call   80101930 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 f9 1e 00 00       	jmp    80102ee0 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 42 26 00 00       	call   80103640 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret    
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 1c 7c 10 80       	push   $0x80107c1c
80101011:	e8 ba f3 ff ff       	call   801003d0 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 b6 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 b9 0a 00 00       	call   80101b00 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 90 08 00 00       	call   801018e0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave  
80101059:	c3                   	ret    
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 51 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 94 0a 00 00       	call   80101b40 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 1d 08 00 00       	call   801018e0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 0e 27 00 00       	jmp    801037f0 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 26 7c 10 80       	push   $0x80107c26
801010f7:	e8 d4 f2 ff ff       	call   801003d0 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bd 00 00 00    	je     801011df <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101151:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101154:	e8 87 07 00 00       	call   801018e0 <iunlock>
      end_op();
80101159:	e8 82 1d 00 00       	call   80102ee0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
80101177:	29 f7                	sub    %esi,%edi
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 ed 1c 00 00       	call   80102e70 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 62 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101191:	57                   	push   %edi
80101192:	ff 73 14             	push   0x14(%ebx)
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 b0 0a 00 00       	call   80101c50 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
      iunlock(f->ip);
801011a7:	83 ec 0c             	sub    $0xc,%esp
801011aa:	ff 73 10             	push   0x10(%ebx)
801011ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011b0:	e8 2b 07 00 00       	call   801018e0 <iunlock>
      end_op();
801011b5:	e8 26 1d 00 00       	call   80102ee0 <end_op>
      if(r < 0)
801011ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 1b                	jne    801011df <filewrite+0xdf>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 2f 7c 10 80       	push   $0x80107c2f
801011cc:	e8 ff f1 ff ff       	call   801003d0 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	89 f0                	mov    %esi,%eax
801011da:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011dd:	74 05                	je     801011e4 <filewrite+0xe4>
801011df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 e2 24 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 35 7c 10 80       	push   $0x80107c35
80101206:	e8 c5 f1 ff ff       	call   801003d0 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101210:	55                   	push   %ebp
80101211:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101213:	89 d0                	mov    %edx,%eax
80101215:	c1 e8 0c             	shr    $0xc,%eax
80101218:	03 05 7c 40 11 80    	add    0x8011407c,%eax
{
8010121e:	89 e5                	mov    %esp,%ebp
80101220:	56                   	push   %esi
80101221:	53                   	push   %ebx
80101222:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	50                   	push   %eax
80101228:	51                   	push   %ecx
80101229:	e8 a2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010122e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101230:	c1 fb 03             	sar    $0x3,%ebx
80101233:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101236:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101238:	83 e1 07             	and    $0x7,%ecx
8010123b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101240:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101246:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101248:	0f b6 8c 1e ac 00 00 	movzbl 0xac(%esi,%ebx,1),%ecx
8010124f:	00 
80101250:	85 c1                	test   %eax,%ecx
80101252:	74 26                	je     8010127a <bfree+0x6a>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101254:	f7 d0                	not    %eax
  log_write(bp);
80101256:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101259:	21 c8                	and    %ecx,%eax
8010125b:	88 84 1e ac 00 00 00 	mov    %al,0xac(%esi,%ebx,1)
  log_write(bp);
80101262:	56                   	push   %esi
80101263:	e8 e8 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
80101268:	89 34 24             	mov    %esi,(%esp)
8010126b:	e8 a0 ef ff ff       	call   80100210 <brelse>
}
80101270:	83 c4 10             	add    $0x10,%esp
80101273:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101276:	5b                   	pop    %ebx
80101277:	5e                   	pop    %esi
80101278:	5d                   	pop    %ebp
80101279:	c3                   	ret    
    panic("freeing free block");
8010127a:	83 ec 0c             	sub    $0xc,%esp
8010127d:	68 3f 7c 10 80       	push   $0x80107c3f
80101282:	e8 49 f1 ff ff       	call   801003d0 <panic>
80101287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128e:	66 90                	xchg   %ax,%ax

80101290 <balloc>:
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101299:	8b 0d 64 40 11 80    	mov    0x80114064,%ecx
{
8010129f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012a2:	85 c9                	test   %ecx,%ecx
801012a4:	0f 84 8e 00 00 00    	je     80101338 <balloc+0xa8>
801012aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012b4:	83 ec 08             	sub    $0x8,%esp
801012b7:	89 f0                	mov    %esi,%eax
801012b9:	c1 f8 0c             	sar    $0xc,%eax
801012bc:	03 05 7c 40 11 80    	add    0x8011407c,%eax
801012c2:	50                   	push   %eax
801012c3:	ff 75 d8             	push   -0x28(%ebp)
801012c6:	e8 05 ee ff ff       	call   801000d0 <bread>
801012cb:	83 c4 10             	add    $0x10,%esp
801012ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012d1:	a1 64 40 11 80       	mov    0x80114064,%eax
801012d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012d9:	31 c0                	xor    %eax,%eax
801012db:	eb 32                	jmp    8010130f <balloc+0x7f>
801012dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012e0:	89 c1                	mov    %eax,%ecx
801012e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ea:	83 e1 07             	and    $0x7,%ecx
801012ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ef:	89 c1                	mov    %eax,%ecx
801012f1:	c1 f9 03             	sar    $0x3,%ecx
801012f4:	0f b6 bc 0a ac 00 00 	movzbl 0xac(%edx,%ecx,1),%edi
801012fb:	00 
801012fc:	89 fa                	mov    %edi,%edx
801012fe:	85 df                	test   %ebx,%edi
80101300:	74 46                	je     80101348 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101302:	83 c0 01             	add    $0x1,%eax
80101305:	83 c6 01             	add    $0x1,%esi
80101308:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010130d:	74 05                	je     80101314 <balloc+0x84>
8010130f:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101312:	77 cc                	ja     801012e0 <balloc+0x50>
    brelse(bp);
80101314:	83 ec 0c             	sub    $0xc,%esp
80101317:	ff 75 e4             	push   -0x1c(%ebp)
8010131a:	e8 f1 ee ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010131f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101326:	83 c4 10             	add    $0x10,%esp
80101329:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010132c:	39 05 64 40 11 80    	cmp    %eax,0x80114064
80101332:	0f 87 79 ff ff ff    	ja     801012b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	68 52 7c 10 80       	push   $0x80107c52
80101340:	e8 8b f0 ff ff       	call   801003d0 <panic>
80101345:	8d 76 00             	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010134b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010134e:	09 da                	or     %ebx,%edx
80101350:	88 94 0f ac 00 00 00 	mov    %dl,0xac(%edi,%ecx,1)
        log_write(bp);
80101357:	57                   	push   %edi
80101358:	e8 f3 1c 00 00       	call   80103050 <log_write>
        brelse(bp);
8010135d:	89 3c 24             	mov    %edi,(%esp)
80101360:	e8 ab ee ff ff       	call   80100210 <brelse>
  bp = bread(dev, bno);
80101365:	58                   	pop    %eax
80101366:	5a                   	pop    %edx
80101367:	56                   	push   %esi
80101368:	ff 75 d8             	push   -0x28(%ebp)
8010136b:	e8 60 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101370:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101373:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101375:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
8010137b:	68 00 02 00 00       	push   $0x200
80101380:	6a 00                	push   $0x0
80101382:	50                   	push   %eax
80101383:	e8 b8 39 00 00       	call   80104d40 <memset>
  log_write(bp);
80101388:	89 1c 24             	mov    %ebx,(%esp)
8010138b:	e8 c0 1c 00 00       	call   80103050 <log_write>
  brelse(bp);
80101390:	89 1c 24             	mov    %ebx,(%esp)
80101393:	e8 78 ee ff ff       	call   80100210 <brelse>
}
80101398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139b:	89 f0                	mov    %esi,%eax
8010139d:	5b                   	pop    %ebx
8010139e:	5e                   	pop    %esi
8010139f:	5f                   	pop    %edi
801013a0:	5d                   	pop    %ebp
801013a1:	c3                   	ret    
801013a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	89 c7                	mov    %eax,%edi
801013b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013b7:	31 f6                	xor    %esi,%esi
{
801013b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ba:	bb a4 14 11 80       	mov    $0x801114a4,%ebx
{
801013bf:	83 ec 28             	sub    $0x28,%esp
801013c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013c5:	68 20 14 11 80       	push   $0x80111420
801013ca:	e8 01 37 00 00       	call   80104ad0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013d2:	83 c4 10             	add    $0x10,%esp
801013d5:	eb 1b                	jmp    801013f2 <iget+0x42>
801013d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 3b                	cmp    %edi,(%ebx)
801013e2:	74 6c                	je     80101450 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e4:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
801013ea:	81 fb 64 40 11 80    	cmp    $0x80114064,%ebx
801013f0:	73 26                	jae    80101418 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f2:	8b 43 08             	mov    0x8(%ebx),%eax
801013f5:	85 c0                	test   %eax,%eax
801013f7:	7f e7                	jg     801013e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013f9:	85 f6                	test   %esi,%esi
801013fb:	75 e7                	jne    801013e4 <iget+0x34>
801013fd:	85 c0                	test   %eax,%eax
801013ff:	75 76                	jne    80101477 <iget+0xc7>
80101401:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101403:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80101409:	81 fb 64 40 11 80    	cmp    $0x80114064,%ebx
8010140f:	72 e1                	jb     801013f2 <iget+0x42>
80101411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101418:	85 f6                	test   %esi,%esi
8010141a:	74 79                	je     80101495 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010141c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010141f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101421:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101424:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010142b:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
80101432:	00 00 00 
  release(&icache.lock);
80101435:	68 20 14 11 80       	push   $0x80111420
8010143a:	e8 31 36 00 00       	call   80104a70 <release>

  return ip;
8010143f:	83 c4 10             	add    $0x10,%esp
}
80101442:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101445:	89 f0                	mov    %esi,%eax
80101447:	5b                   	pop    %ebx
80101448:	5e                   	pop    %esi
80101449:	5f                   	pop    %edi
8010144a:	5d                   	pop    %ebp
8010144b:	c3                   	ret    
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101450:	39 53 04             	cmp    %edx,0x4(%ebx)
80101453:	75 8f                	jne    801013e4 <iget+0x34>
      release(&icache.lock);
80101455:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101458:	83 c0 01             	add    $0x1,%eax
      return ip;
8010145b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010145d:	68 20 14 11 80       	push   $0x80111420
      ip->ref++;
80101462:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101465:	e8 06 36 00 00       	call   80104a70 <release>
      return ip;
8010146a:	83 c4 10             	add    $0x10,%esp
}
8010146d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101470:	89 f0                	mov    %esi,%eax
80101472:	5b                   	pop    %ebx
80101473:	5e                   	pop    %esi
80101474:	5f                   	pop    %edi
80101475:	5d                   	pop    %ebp
80101476:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101477:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
8010147d:	81 fb 64 40 11 80    	cmp    $0x80114064,%ebx
80101483:	73 10                	jae    80101495 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101485:	8b 43 08             	mov    0x8(%ebx),%eax
80101488:	85 c0                	test   %eax,%eax
8010148a:	0f 8f 50 ff ff ff    	jg     801013e0 <iget+0x30>
80101490:	e9 68 ff ff ff       	jmp    801013fd <iget+0x4d>
    panic("iget: no inodes");
80101495:	83 ec 0c             	sub    $0xc,%esp
80101498:	68 68 7c 10 80       	push   $0x80107c68
8010149d:	e8 2e ef ff ff       	call   801003d0 <panic>
801014a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	89 c6                	mov    %eax,%esi
801014b7:	53                   	push   %ebx
801014b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014bb:	83 fa 0b             	cmp    $0xb,%edx
801014be:	0f 86 8c 00 00 00    	jbe    80101550 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014c7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ca:	0f 87 a2 00 00 00    	ja     80101572 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014d0:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	74 5e                	je     80101538 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014da:	83 ec 08             	sub    $0x8,%esp
801014dd:	50                   	push   %eax
801014de:	ff 36                	push   (%esi)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014e5:	83 c4 10             	add    $0x10,%esp
801014e8:	8d 9c 98 ac 00 00 00 	lea    0xac(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ef:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014f1:	8b 3b                	mov    (%ebx),%edi
801014f3:	85 ff                	test   %edi,%edi
801014f5:	74 19                	je     80101510 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014f7:	83 ec 0c             	sub    $0xc,%esp
801014fa:	52                   	push   %edx
801014fb:	e8 10 ed ff ff       	call   80100210 <brelse>
80101500:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101503:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101506:	89 f8                	mov    %edi,%eax
80101508:	5b                   	pop    %ebx
80101509:	5e                   	pop    %esi
8010150a:	5f                   	pop    %edi
8010150b:	5d                   	pop    %ebp
8010150c:	c3                   	ret    
8010150d:	8d 76 00             	lea    0x0(%esi),%esi
80101510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101513:	8b 06                	mov    (%esi),%eax
80101515:	e8 76 fd ff ff       	call   80101290 <balloc>
      log_write(bp);
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101520:	89 03                	mov    %eax,(%ebx)
80101522:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101524:	52                   	push   %edx
80101525:	e8 26 1b 00 00       	call   80103050 <log_write>
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 c4 10             	add    $0x10,%esp
80101530:	eb c5                	jmp    801014f7 <bmap+0x47>
80101532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101538:	8b 06                	mov    (%esi),%eax
8010153a:	e8 51 fd ff ff       	call   80101290 <balloc>
8010153f:	89 86 dc 00 00 00    	mov    %eax,0xdc(%esi)
80101545:	eb 93                	jmp    801014da <bmap+0x2a>
80101547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101550:	8d 5a 28             	lea    0x28(%edx),%ebx
80101553:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101557:	85 ff                	test   %edi,%edi
80101559:	75 a8                	jne    80101503 <bmap+0x53>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010155b:	8b 00                	mov    (%eax),%eax
8010155d:	e8 2e fd ff ff       	call   80101290 <balloc>
80101562:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101566:	89 c7                	mov    %eax,%edi
}
80101568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156b:	5b                   	pop    %ebx
8010156c:	89 f8                	mov    %edi,%eax
8010156e:	5e                   	pop    %esi
8010156f:	5f                   	pop    %edi
80101570:	5d                   	pop    %ebp
80101571:	c3                   	ret    
  panic("bmap: out of range");
80101572:	83 ec 0c             	sub    $0xc,%esp
80101575:	68 78 7c 10 80       	push   $0x80107c78
8010157a:	e8 51 ee ff ff       	call   801003d0 <panic>
8010157f:	90                   	nop

80101580 <readsb>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	6a 01                	push   $0x1
8010158d:	ff 75 08             	push   0x8(%ebp)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101595:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101598:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010159a:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
801015a0:	6a 1c                	push   $0x1c
801015a2:	50                   	push   %eax
801015a3:	56                   	push   %esi
801015a4:	e8 37 38 00 00       	call   80104de0 <memmove>
  brelse(bp);
801015a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015ac:	83 c4 10             	add    $0x10,%esp
}
801015af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015b2:	5b                   	pop    %ebx
801015b3:	5e                   	pop    %esi
801015b4:	5d                   	pop    %ebp
  brelse(bp);
801015b5:	e9 56 ec ff ff       	jmp    80100210 <brelse>
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	53                   	push   %ebx
801015c4:	bb b0 14 11 80       	mov    $0x801114b0,%ebx
801015c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015cc:	68 8b 7c 10 80       	push   $0x80107c8b
801015d1:	68 20 14 11 80       	push   $0x80111420
801015d6:	e8 25 33 00 00       	call   80104900 <initlock>
  for(i = 0; i < NINODE; i++) {
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	68 92 7c 10 80       	push   $0x80107c92
801015e8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015e9:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ef:	e8 dc 31 00 00       	call   801047d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	81 fb 70 40 11 80    	cmp    $0x80114070,%ebx
801015fd:	75 e1                	jne    801015e0 <iinit+0x20>
  bp = bread(dev, 1);
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	6a 01                	push   $0x1
80101604:	ff 75 08             	push   0x8(%ebp)
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010160c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010160f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101611:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
80101617:	6a 1c                	push   $0x1c
80101619:	50                   	push   %eax
8010161a:	68 64 40 11 80       	push   $0x80114064
8010161f:	e8 bc 37 00 00       	call   80104de0 <memmove>
  brelse(bp);
80101624:	89 1c 24             	mov    %ebx,(%esp)
80101627:	e8 e4 eb ff ff       	call   80100210 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010162c:	ff 35 7c 40 11 80    	push   0x8011407c
80101632:	ff 35 78 40 11 80    	push   0x80114078
80101638:	ff 35 74 40 11 80    	push   0x80114074
8010163e:	ff 35 70 40 11 80    	push   0x80114070
80101644:	ff 35 6c 40 11 80    	push   0x8011406c
8010164a:	ff 35 68 40 11 80    	push   0x80114068
80101650:	ff 35 64 40 11 80    	push   0x80114064
80101656:	68 f8 7c 10 80       	push   $0x80107cf8
8010165b:	e8 90 f0 ff ff       	call   801006f0 <cprintf>
}
80101660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101663:	83 c4 30             	add    $0x30,%esp
80101666:	c9                   	leave  
80101667:	c3                   	ret    
80101668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166f:	90                   	nop

80101670 <ialloc>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	57                   	push   %edi
80101674:	56                   	push   %esi
80101675:	53                   	push   %ebx
80101676:	83 ec 1c             	sub    $0x1c,%esp
80101679:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 3d 6c 40 11 80 01 	cmpl   $0x1,0x8011406c
{
80101683:	8b 75 08             	mov    0x8(%ebp),%esi
80101686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101689:	0f 86 94 00 00 00    	jbe    80101723 <ialloc+0xb3>
8010168f:	bf 01 00 00 00       	mov    $0x1,%edi
80101694:	eb 21                	jmp    801016b7 <ialloc+0x47>
80101696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016a3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016a6:	53                   	push   %ebx
801016a7:	e8 64 eb ff ff       	call   80100210 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	3b 3d 6c 40 11 80    	cmp    0x8011406c,%edi
801016b5:	73 6c                	jae    80101723 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
801016b7:	89 f8                	mov    %edi,%eax
801016b9:	83 ec 08             	sub    $0x8,%esp
801016bc:	c1 e8 03             	shr    $0x3,%eax
801016bf:	03 05 78 40 11 80    	add    0x80114078,%eax
801016c5:	50                   	push   %eax
801016c6:	56                   	push   %esi
801016c7:	e8 04 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016cc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016cf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016d1:	89 f8                	mov    %edi,%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 8c 03 ac 00 00 00 	lea    0xac(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016e0:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016e4:	75 ba                	jne    801016a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016e6:	83 ec 04             	sub    $0x4,%esp
801016e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ec:	6a 40                	push   $0x40
801016ee:	6a 00                	push   $0x0
801016f0:	51                   	push   %ecx
801016f1:	e8 4a 36 00 00       	call   80104d40 <memset>
      dip->type = type;
801016f6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016fd:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101700:	89 1c 24             	mov    %ebx,(%esp)
80101703:	e8 48 19 00 00       	call   80103050 <log_write>
      brelse(bp);
80101708:	89 1c 24             	mov    %ebx,(%esp)
8010170b:	e8 00 eb ff ff       	call   80100210 <brelse>
      return iget(dev, inum);
80101710:	83 c4 10             	add    $0x10,%esp
}
80101713:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101716:	89 fa                	mov    %edi,%edx
}
80101718:	5b                   	pop    %ebx
      return iget(dev, inum);
80101719:	89 f0                	mov    %esi,%eax
}
8010171b:	5e                   	pop    %esi
8010171c:	5f                   	pop    %edi
8010171d:	5d                   	pop    %ebp
      return iget(dev, inum);
8010171e:	e9 8d fc ff ff       	jmp    801013b0 <iget>
  panic("ialloc: no inodes");
80101723:	83 ec 0c             	sub    $0xc,%esp
80101726:	68 98 7c 10 80       	push   $0x80107c98
8010172b:	e8 a0 ec ff ff       	call   801003d0 <panic>

80101730 <iupdate>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173b:	81 c3 ac 00 00 00    	add    $0xac,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101741:	83 ec 08             	sub    $0x8,%esp
80101744:	c1 e8 03             	shr    $0x3,%eax
80101747:	03 05 78 40 11 80    	add    0x80114078,%eax
8010174d:	50                   	push   %eax
8010174e:	ff b3 54 ff ff ff    	push   -0xac(%ebx)
80101754:	e8 77 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101759:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101762:	8b 83 58 ff ff ff    	mov    -0xa8(%ebx),%eax
80101768:	83 e0 07             	and    $0x7,%eax
8010176b:	c1 e0 06             	shl    $0x6,%eax
8010176e:	8d 84 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%eax
  dip->type = ip->type;
80101775:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101778:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177c:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
8010177f:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101783:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101787:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178b:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
8010178f:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101793:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101796:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101799:	6a 34                	push   $0x34
8010179b:	53                   	push   %ebx
8010179c:	50                   	push   %eax
8010179d:	e8 3e 36 00 00       	call   80104de0 <memmove>
  log_write(bp);
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 a6 18 00 00       	call   80103050 <log_write>
  brelse(bp);
801017aa:	89 75 08             	mov    %esi,0x8(%ebp)
801017ad:	83 c4 10             	add    $0x10,%esp
}
801017b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b3:	5b                   	pop    %ebx
801017b4:	5e                   	pop    %esi
801017b5:	5d                   	pop    %ebp
  brelse(bp);
801017b6:	e9 55 ea ff ff       	jmp    80100210 <brelse>
801017bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 20 14 11 80       	push   $0x80111420
801017cf:	e8 fc 32 00 00       	call   80104ad0 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
801017df:	e8 8c 32 00 00       	call   80104a70 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave  
801017ea:	c3                   	ret    
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 d2 00 00 00    	je     801018d2 <ilock+0xe2>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e c7 00 00 00    	jle    801018d2 <ilock+0xe2>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 f9 2f 00 00       	call   80104810 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
8010181d:	83 c4 10             	add    $0x10,%esp
80101820:	85 c0                	test   %eax,%eax
80101822:	74 0c                	je     80101830 <ilock+0x40>
}
80101824:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5d                   	pop    %ebp
8010182a:	c3                   	ret    
8010182b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 78 40 11 80    	add    0x80114078,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 84 06 ac 00 00 00 	lea    0xac(%esi,%eax,1),%eax
    ip->type = dip->type;
8010185c:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185f:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101862:	66 89 93 a0 00 00 00 	mov    %dx,0xa0(%ebx)
    ip->major = dip->major;
80101869:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
8010186d:	66 89 93 a2 00 00 00 	mov    %dx,0xa2(%ebx)
    ip->minor = dip->minor;
80101874:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101878:	66 89 93 a4 00 00 00 	mov    %dx,0xa4(%ebx)
    ip->nlink = dip->nlink;
8010187f:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101883:	66 89 93 a6 00 00 00 	mov    %dx,0xa6(%ebx)
    ip->size = dip->size;
8010188a:	8b 50 fc             	mov    -0x4(%eax),%edx
8010188d:	89 93 a8 00 00 00    	mov    %edx,0xa8(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101893:	6a 34                	push   $0x34
80101895:	50                   	push   %eax
80101896:	8d 83 ac 00 00 00    	lea    0xac(%ebx),%eax
8010189c:	50                   	push   %eax
8010189d:	e8 3e 35 00 00       	call   80104de0 <memmove>
    brelse(bp);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 66 e9 ff ff       	call   80100210 <brelse>
    if(ip->type == 0)
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	66 83 bb a0 00 00 00 	cmpw   $0x0,0xa0(%ebx)
801018b4:	00 
    ip->valid = 1;
801018b5:	c7 83 9c 00 00 00 01 	movl   $0x1,0x9c(%ebx)
801018bc:	00 00 00 
    if(ip->type == 0)
801018bf:	0f 85 5f ff ff ff    	jne    80101824 <ilock+0x34>
      panic("ilock: no type");
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	68 b0 7c 10 80       	push   $0x80107cb0
801018cd:	e8 fe ea ff ff       	call   801003d0 <panic>
    panic("ilock");
801018d2:	83 ec 0c             	sub    $0xc,%esp
801018d5:	68 aa 7c 10 80       	push   $0x80107caa
801018da:	e8 f1 ea ff ff       	call   801003d0 <panic>
801018df:	90                   	nop

801018e0 <iunlock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018e8:	85 db                	test   %ebx,%ebx
801018ea:	74 28                	je     80101914 <iunlock+0x34>
801018ec:	83 ec 0c             	sub    $0xc,%esp
801018ef:	8d 73 0c             	lea    0xc(%ebx),%esi
801018f2:	56                   	push   %esi
801018f3:	e8 b8 2f 00 00       	call   801048b0 <holdingsleep>
801018f8:	83 c4 10             	add    $0x10,%esp
801018fb:	85 c0                	test   %eax,%eax
801018fd:	74 15                	je     80101914 <iunlock+0x34>
801018ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	7e 0e                	jle    80101914 <iunlock+0x34>
  releasesleep(&ip->lock);
80101906:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101909:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010190f:	e9 5c 2f 00 00       	jmp    80104870 <releasesleep>
    panic("iunlock");
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 bf 7c 10 80       	push   $0x80107cbf
8010191c:	e8 af ea ff ff       	call   801003d0 <panic>
80101921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192f:	90                   	nop

80101930 <iput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 28             	sub    $0x28,%esp
80101939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010193c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010193f:	57                   	push   %edi
80101940:	e8 cb 2e 00 00       	call   80104810 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101945:	8b 93 9c 00 00 00    	mov    0x9c(%ebx),%edx
8010194b:	83 c4 10             	add    $0x10,%esp
8010194e:	85 d2                	test   %edx,%edx
80101950:	74 0a                	je     8010195c <iput+0x2c>
80101952:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
80101959:	00 
8010195a:	74 34                	je     80101990 <iput+0x60>
  releasesleep(&ip->lock);
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	57                   	push   %edi
80101960:	e8 0b 2f 00 00       	call   80104870 <releasesleep>
  acquire(&icache.lock);
80101965:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
8010196c:	e8 5f 31 00 00       	call   80104ad0 <acquire>
  ip->ref--;
80101971:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101975:	83 c4 10             	add    $0x10,%esp
80101978:	c7 45 08 20 14 11 80 	movl   $0x80111420,0x8(%ebp)
}
8010197f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101982:	5b                   	pop    %ebx
80101983:	5e                   	pop    %esi
80101984:	5f                   	pop    %edi
80101985:	5d                   	pop    %ebp
  release(&icache.lock);
80101986:	e9 e5 30 00 00       	jmp    80104a70 <release>
8010198b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop
    acquire(&icache.lock);
80101990:	83 ec 0c             	sub    $0xc,%esp
80101993:	68 20 14 11 80       	push   $0x80111420
80101998:	e8 33 31 00 00       	call   80104ad0 <acquire>
    int r = ip->ref;
8010199d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019a0:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
801019a7:	e8 c4 30 00 00       	call   80104a70 <release>
    if(r == 1){
801019ac:	83 c4 10             	add    $0x10,%esp
801019af:	83 fe 01             	cmp    $0x1,%esi
801019b2:	75 a8                	jne    8010195c <iput+0x2c>
801019b4:	8d 8b dc 00 00 00    	lea    0xdc(%ebx),%ecx
801019ba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019bd:	8d b3 ac 00 00 00    	lea    0xac(%ebx),%esi
801019c3:	89 cf                	mov    %ecx,%edi
801019c5:	eb 10                	jmp    801019d7 <iput+0xa7>
801019c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ce:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 fe                	cmp    %edi,%esi
801019d5:	74 19                	je     801019f0 <iput+0xc0>
    if(ip->addrs[i]){
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0xa0>
      bfree(ip->dev, ip->addrs[i]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 2c f8 ff ff       	call   80101210 <bfree>
      ip->addrs[i] = 0;
801019e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ea:	eb e4                	jmp    801019d0 <iput+0xa0>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019f0:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
801019f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019f9:	85 c0                	test   %eax,%eax
801019fb:	75 36                	jne    80101a33 <iput+0x103>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801019fd:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80101a04:	00 00 00 
  iupdate(ip);
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	53                   	push   %ebx
80101a0b:	e8 20 fd ff ff       	call   80101730 <iupdate>
      ip->type = 0;
80101a10:	31 c0                	xor    %eax,%eax
80101a12:	66 89 83 a0 00 00 00 	mov    %ax,0xa0(%ebx)
      iupdate(ip);
80101a19:	89 1c 24             	mov    %ebx,(%esp)
80101a1c:	e8 0f fd ff ff       	call   80101730 <iupdate>
      ip->valid = 0;
80101a21:	83 c4 10             	add    $0x10,%esp
80101a24:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80101a2b:	00 00 00 
80101a2e:	e9 29 ff ff ff       	jmp    8010195c <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a33:	83 ec 08             	sub    $0x8,%esp
80101a36:	50                   	push   %eax
80101a37:	ff 33                	push   (%ebx)
80101a39:	e8 92 e6 ff ff       	call   801000d0 <bread>
80101a3e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a41:	83 c4 10             	add    $0x10,%esp
80101a44:	8d 88 ac 02 00 00    	lea    0x2ac(%eax),%ecx
80101a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a4d:	8d b0 ac 00 00 00    	lea    0xac(%eax),%esi
80101a53:	89 cf                	mov    %ecx,%edi
80101a55:	eb 10                	jmp    80101a67 <iput+0x137>
80101a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5e:	66 90                	xchg   %ax,%ax
80101a60:	83 c6 04             	add    $0x4,%esi
80101a63:	39 f7                	cmp    %esi,%edi
80101a65:	74 0f                	je     80101a76 <iput+0x146>
      if(a[j])
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	85 d2                	test   %edx,%edx
80101a6b:	74 f3                	je     80101a60 <iput+0x130>
        bfree(ip->dev, a[j]);
80101a6d:	8b 03                	mov    (%ebx),%eax
80101a6f:	e8 9c f7 ff ff       	call   80101210 <bfree>
80101a74:	eb ea                	jmp    80101a60 <iput+0x130>
    brelse(bp);
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	ff 75 e4             	push   -0x1c(%ebp)
80101a7c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a7f:	e8 8c e7 ff ff       	call   80100210 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a84:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
80101a8a:	8b 03                	mov    (%ebx),%eax
80101a8c:	e8 7f f7 ff ff       	call   80101210 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a91:	83 c4 10             	add    $0x10,%esp
80101a94:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
80101a9b:	00 00 00 
80101a9e:	e9 5a ff ff ff       	jmp    801019fd <iput+0xcd>
80101aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ab0 <iunlockput>:
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	56                   	push   %esi
80101ab4:	53                   	push   %ebx
80101ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ab8:	85 db                	test   %ebx,%ebx
80101aba:	74 34                	je     80101af0 <iunlockput+0x40>
80101abc:	83 ec 0c             	sub    $0xc,%esp
80101abf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ac2:	56                   	push   %esi
80101ac3:	e8 e8 2d 00 00       	call   801048b0 <holdingsleep>
80101ac8:	83 c4 10             	add    $0x10,%esp
80101acb:	85 c0                	test   %eax,%eax
80101acd:	74 21                	je     80101af0 <iunlockput+0x40>
80101acf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ad2:	85 c0                	test   %eax,%eax
80101ad4:	7e 1a                	jle    80101af0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ad6:	83 ec 0c             	sub    $0xc,%esp
80101ad9:	56                   	push   %esi
80101ada:	e8 91 2d 00 00       	call   80104870 <releasesleep>
  iput(ip);
80101adf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ae2:	83 c4 10             	add    $0x10,%esp
}
80101ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5d                   	pop    %ebp
  iput(ip);
80101aeb:	e9 40 fe ff ff       	jmp    80101930 <iput>
    panic("iunlock");
80101af0:	83 ec 0c             	sub    $0xc,%esp
80101af3:	68 bf 7c 10 80       	push   $0x80107cbf
80101af8:	e8 d3 e8 ff ff       	call   801003d0 <panic>
80101afd:	8d 76 00             	lea    0x0(%esi),%esi

80101b00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	8b 55 08             	mov    0x8(%ebp),%edx
80101b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b09:	8b 0a                	mov    (%edx),%ecx
80101b0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b14:	0f b7 8a a0 00 00 00 	movzwl 0xa0(%edx),%ecx
80101b1b:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b1e:	0f b7 8a a6 00 00 00 	movzwl 0xa6(%edx),%ecx
80101b25:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b29:	8b 92 a8 00 00 00    	mov    0xa8(%edx),%edx
80101b2f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b32:	5d                   	pop    %ebp
80101b33:	c3                   	ret    
80101b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b3f:	90                   	nop

80101b40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	57                   	push   %edi
80101b44:	56                   	push   %esi
80101b45:	53                   	push   %ebx
80101b46:	83 ec 1c             	sub    $0x1c,%esp
80101b49:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b52:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b55:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b58:	66 83 b8 a0 00 00 00 	cmpw   $0x3,0xa0(%eax)
80101b5f:	03 
{
80101b60:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b63:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b66:	0f 84 b4 00 00 00    	je     80101c20 <readi+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80101b75:	39 c6                	cmp    %eax,%esi
80101b77:	0f 87 c7 00 00 00    	ja     80101c44 <readi+0x104>
80101b7d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b80:	31 c9                	xor    %ecx,%ecx
80101b82:	89 da                	mov    %ebx,%edx
80101b84:	01 f2                	add    %esi,%edx
80101b86:	0f 92 c1             	setb   %cl
80101b89:	89 cf                	mov    %ecx,%edi
80101b8b:	0f 82 b3 00 00 00    	jb     80101c44 <readi+0x104>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b91:	89 c1                	mov    %eax,%ecx
80101b93:	29 f1                	sub    %esi,%ecx
80101b95:	39 d0                	cmp    %edx,%eax
80101b97:	0f 43 cb             	cmovae %ebx,%ecx
80101b9a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9d:	85 c9                	test   %ecx,%ecx
80101b9f:	74 6c                	je     80101c0d <readi+0xcd>
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bab:	89 f2                	mov    %esi,%edx
80101bad:	c1 ea 09             	shr    $0x9,%edx
80101bb0:	89 d8                	mov    %ebx,%eax
80101bb2:	e8 f9 f8 ff ff       	call   801014b0 <bmap>
80101bb7:	83 ec 08             	sub    $0x8,%esp
80101bba:	50                   	push   %eax
80101bbb:	ff 33                	push   (%ebx)
80101bbd:	e8 0e e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bc5:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bca:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bcc:	89 f0                	mov    %esi,%eax
80101bce:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bd3:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bd5:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd8:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bda:	8d 84 02 ac 00 00 00 	lea    0xac(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101be1:	39 d9                	cmp    %ebx,%ecx
80101be3:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101be6:	83 c4 0c             	add    $0xc,%esp
80101be9:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bea:	01 df                	add    %ebx,%edi
80101bec:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bee:	50                   	push   %eax
80101bef:	ff 75 e0             	push   -0x20(%ebp)
80101bf2:	e8 e9 31 00 00       	call   80104de0 <memmove>
    brelse(bp);
80101bf7:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bfa:	89 14 24             	mov    %edx,(%esp)
80101bfd:	e8 0e e6 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c02:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c05:	83 c4 10             	add    $0x10,%esp
80101c08:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c0b:	77 9b                	ja     80101ba8 <readi+0x68>
  }
  return n;
80101c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c13:	5b                   	pop    %ebx
80101c14:	5e                   	pop    %esi
80101c15:	5f                   	pop    %edi
80101c16:	5d                   	pop    %ebp
80101c17:	c3                   	ret    
80101c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c20:	0f bf 80 a2 00 00 00 	movswl 0xa2(%eax),%eax
80101c27:	66 83 f8 09          	cmp    $0x9,%ax
80101c2b:	77 17                	ja     80101c44 <readi+0x104>
80101c2d:	8b 04 c5 c0 13 11 80 	mov    -0x7feeec40(,%eax,8),%eax
80101c34:	85 c0                	test   %eax,%eax
80101c36:	74 0c                	je     80101c44 <readi+0x104>
    return devsw[ip->major].read(ip, dst, n);
80101c38:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3e:	5b                   	pop    %ebx
80101c3f:	5e                   	pop    %esi
80101c40:	5f                   	pop    %edi
80101c41:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c42:	ff e0                	jmp    *%eax
      return -1;
80101c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c49:	eb c5                	jmp    80101c10 <readi+0xd0>
80101c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c4f:	90                   	nop

80101c50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c5f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c62:	66 83 b8 a0 00 00 00 	cmpw   $0x3,0xa0(%eax)
80101c69:	03 
{
80101c6a:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c70:	8b 75 10             	mov    0x10(%ebp),%esi
80101c73:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c76:	0f 84 c4 00 00 00    	je     80101d40 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7f:	3b b0 a8 00 00 00    	cmp    0xa8(%eax),%esi
80101c85:	0f 87 f4 00 00 00    	ja     80101d7f <writei+0x12f>
80101c8b:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c8e:	31 d2                	xor    %edx,%edx
80101c90:	89 f8                	mov    %edi,%eax
80101c92:	01 f0                	add    %esi,%eax
80101c94:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c97:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c9c:	0f 87 dd 00 00 00    	ja     80101d7f <writei+0x12f>
80101ca2:	85 d2                	test   %edx,%edx
80101ca4:	0f 85 d5 00 00 00    	jne    80101d7f <writei+0x12f>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101caa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cb1:	85 ff                	test   %edi,%edi
80101cb3:	74 7a                	je     80101d2f <writei+0xdf>
80101cb5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101cbb:	89 f2                	mov    %esi,%edx
80101cbd:	c1 ea 09             	shr    $0x9,%edx
80101cc0:	89 f8                	mov    %edi,%eax
80101cc2:	e8 e9 f7 ff ff       	call   801014b0 <bmap>
80101cc7:	83 ec 08             	sub    $0x8,%esp
80101cca:	50                   	push   %eax
80101ccb:	ff 37                	push   (%edi)
80101ccd:	e8 fe e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd2:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cd7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cda:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cdd:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cdf:	89 f0                	mov    %esi,%eax
80101ce1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ce6:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ce8:	8d 84 07 ac 00 00 00 	lea    0xac(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cef:	39 d9                	cmp    %ebx,%ecx
80101cf1:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cf4:	83 c4 0c             	add    $0xc,%esp
80101cf7:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf8:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cfa:	ff 75 dc             	push   -0x24(%ebp)
80101cfd:	50                   	push   %eax
80101cfe:	e8 dd 30 00 00       	call   80104de0 <memmove>
    log_write(bp);
80101d03:	89 3c 24             	mov    %edi,(%esp)
80101d06:	e8 45 13 00 00       	call   80103050 <log_write>
    brelse(bp);
80101d0b:	89 3c 24             	mov    %edi,(%esp)
80101d0e:	e8 fd e4 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d13:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d16:	83 c4 10             	add    $0x10,%esp
80101d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d1c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d1f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d22:	77 94                	ja     80101cb8 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101d24:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d27:	3b b0 a8 00 00 00    	cmp    0xa8(%eax),%esi
80101d2d:	77 39                	ja     80101d68 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d35:	5b                   	pop    %ebx
80101d36:	5e                   	pop    %esi
80101d37:	5f                   	pop    %edi
80101d38:	5d                   	pop    %ebp
80101d39:	c3                   	ret    
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d40:	0f bf 80 a2 00 00 00 	movswl 0xa2(%eax),%eax
80101d47:	66 83 f8 09          	cmp    $0x9,%ax
80101d4b:	77 32                	ja     80101d7f <writei+0x12f>
80101d4d:	8b 04 c5 c4 13 11 80 	mov    -0x7feeec3c(,%eax,8),%eax
80101d54:	85 c0                	test   %eax,%eax
80101d56:	74 27                	je     80101d7f <writei+0x12f>
    return devsw[ip->major].write(ip, src, n);
80101d58:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5e:	5b                   	pop    %ebx
80101d5f:	5e                   	pop    %esi
80101d60:	5f                   	pop    %edi
80101d61:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d62:	ff e0                	jmp    *%eax
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d6e:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
    iupdate(ip);
80101d74:	50                   	push   %eax
80101d75:	e8 b6 f9 ff ff       	call   80101730 <iupdate>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	eb b0                	jmp    80101d2f <writei+0xdf>
      return -1;
80101d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d84:	eb ac                	jmp    80101d32 <writei+0xe2>
80101d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8d:	8d 76 00             	lea    0x0(%esi),%esi

80101d90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d96:	6a 0e                	push   $0xe
80101d98:	ff 75 0c             	push   0xc(%ebp)
80101d9b:	ff 75 08             	push   0x8(%ebp)
80101d9e:	e8 ad 30 00 00       	call   80104e50 <strncmp>
}
80101da3:	c9                   	leave  
80101da4:	c3                   	ret    
80101da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101db0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 1c             	sub    $0x1c,%esp
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dbc:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80101dc3:	01 
80101dc4:	0f 85 92 00 00 00    	jne    80101e5c <dirlookup+0xac>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101dca:	8b 93 a8 00 00 00    	mov    0xa8(%ebx),%edx
80101dd0:	31 ff                	xor    %edi,%edi
80101dd2:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dd5:	85 d2                	test   %edx,%edx
80101dd7:	74 43                	je     80101e1c <dirlookup+0x6c>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101de0:	6a 10                	push   $0x10
80101de2:	57                   	push   %edi
80101de3:	56                   	push   %esi
80101de4:	53                   	push   %ebx
80101de5:	e8 56 fd ff ff       	call   80101b40 <readi>
80101dea:	83 c4 10             	add    $0x10,%esp
80101ded:	83 f8 10             	cmp    $0x10,%eax
80101df0:	75 5d                	jne    80101e4f <dirlookup+0x9f>
      panic("dirlookup read");
    if(de.inum == 0)
80101df2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101df7:	74 18                	je     80101e11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101df9:	83 ec 04             	sub    $0x4,%esp
80101dfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101dff:	6a 0e                	push   $0xe
80101e01:	50                   	push   %eax
80101e02:	ff 75 0c             	push   0xc(%ebp)
80101e05:	e8 46 30 00 00       	call   80104e50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	74 1f                	je     80101e30 <dirlookup+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e11:	83 c7 10             	add    $0x10,%edi
80101e14:	3b bb a8 00 00 00    	cmp    0xa8(%ebx),%edi
80101e1a:	72 c4                	jb     80101de0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e1f:	31 c0                	xor    %eax,%eax
}
80101e21:	5b                   	pop    %ebx
80101e22:	5e                   	pop    %esi
80101e23:	5f                   	pop    %edi
80101e24:	5d                   	pop    %ebp
80101e25:	c3                   	ret    
80101e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e2d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101e30:	8b 45 10             	mov    0x10(%ebp),%eax
80101e33:	85 c0                	test   %eax,%eax
80101e35:	74 05                	je     80101e3c <dirlookup+0x8c>
        *poff = off;
80101e37:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e40:	8b 03                	mov    (%ebx),%eax
80101e42:	e8 69 f5 ff ff       	call   801013b0 <iget>
}
80101e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4a:	5b                   	pop    %ebx
80101e4b:	5e                   	pop    %esi
80101e4c:	5f                   	pop    %edi
80101e4d:	5d                   	pop    %ebp
80101e4e:	c3                   	ret    
      panic("dirlookup read");
80101e4f:	83 ec 0c             	sub    $0xc,%esp
80101e52:	68 d9 7c 10 80       	push   $0x80107cd9
80101e57:	e8 74 e5 ff ff       	call   801003d0 <panic>
    panic("dirlookup not DIR");
80101e5c:	83 ec 0c             	sub    $0xc,%esp
80101e5f:	68 c7 7c 10 80       	push   $0x80107cc7
80101e64:	e8 67 e5 ff ff       	call   801003d0 <panic>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	89 c3                	mov    %eax,%ebx
80101e78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e84:	0f 84 74 01 00 00    	je     80101ffe <namex+0x18e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e8a:	e8 51 1c 00 00       	call   80103ae0 <myproc>
  acquire(&icache.lock);
80101e8f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e92:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e95:	68 20 14 11 80       	push   $0x80111420
80101e9a:	e8 31 2c 00 00       	call   80104ad0 <acquire>
  ip->ref++;
80101e9f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ea3:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
80101eaa:	e8 c1 2b 00 00       	call   80104a70 <release>
80101eaf:	83 c4 10             	add    $0x10,%esp
80101eb2:	eb 07                	jmp    80101ebb <namex+0x4b>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	0f b6 03             	movzbl (%ebx),%eax
80101ebe:	3c 2f                	cmp    $0x2f,%al
80101ec0:	74 f6                	je     80101eb8 <namex+0x48>
  if(*path == 0)
80101ec2:	84 c0                	test   %al,%al
80101ec4:	0f 84 16 01 00 00    	je     80101fe0 <namex+0x170>
  while(*path != '/' && *path != 0)
80101eca:	0f b6 03             	movzbl (%ebx),%eax
80101ecd:	84 c0                	test   %al,%al
80101ecf:	0f 84 20 01 00 00    	je     80101ff5 <namex+0x185>
80101ed5:	89 df                	mov    %ebx,%edi
80101ed7:	3c 2f                	cmp    $0x2f,%al
80101ed9:	0f 84 16 01 00 00    	je     80101ff5 <namex+0x185>
80101edf:	90                   	nop
80101ee0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101ee4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101ee7:	3c 2f                	cmp    $0x2f,%al
80101ee9:	74 04                	je     80101eef <namex+0x7f>
80101eeb:	84 c0                	test   %al,%al
80101eed:	75 f1                	jne    80101ee0 <namex+0x70>
  len = path - s;
80101eef:	89 f8                	mov    %edi,%eax
80101ef1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101ef3:	83 f8 0d             	cmp    $0xd,%eax
80101ef6:	0f 8e b4 00 00 00    	jle    80101fb0 <namex+0x140>
    memmove(name, s, DIRSIZ);
80101efc:	83 ec 04             	sub    $0x4,%esp
80101eff:	6a 0e                	push   $0xe
80101f01:	53                   	push   %ebx
    path++;
80101f02:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f04:	ff 75 e4             	push   -0x1c(%ebp)
80101f07:	e8 d4 2e 00 00       	call   80104de0 <memmove>
80101f0c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f0f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f12:	75 0c                	jne    80101f20 <namex+0xb0>
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f1b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f1e:	74 f8                	je     80101f18 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f20:	83 ec 0c             	sub    $0xc,%esp
80101f23:	56                   	push   %esi
80101f24:	e8 c7 f8 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101f29:	83 c4 10             	add    $0x10,%esp
80101f2c:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80101f33:	01 
80101f34:	0f 85 da 00 00 00    	jne    80102014 <namex+0x1a4>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f3d:	85 c0                	test   %eax,%eax
80101f3f:	74 09                	je     80101f4a <namex+0xda>
80101f41:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f44:	0f 84 2f 01 00 00    	je     80102079 <namex+0x209>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f4a:	83 ec 04             	sub    $0x4,%esp
80101f4d:	6a 00                	push   $0x0
80101f4f:	ff 75 e4             	push   -0x1c(%ebp)
80101f52:	56                   	push   %esi
80101f53:	e8 58 fe ff ff       	call   80101db0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f58:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	89 c7                	mov    %eax,%edi
80101f60:	85 c0                	test   %eax,%eax
80101f62:	0f 84 ee 00 00 00    	je     80102056 <namex+0x1e6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f6e:	52                   	push   %edx
80101f6f:	e8 3c 29 00 00       	call   801048b0 <holdingsleep>
80101f74:	83 c4 10             	add    $0x10,%esp
80101f77:	85 c0                	test   %eax,%eax
80101f79:	0f 84 3d 01 00 00    	je     801020bc <namex+0x24c>
80101f7f:	8b 56 08             	mov    0x8(%esi),%edx
80101f82:	85 d2                	test   %edx,%edx
80101f84:	0f 8e 32 01 00 00    	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80101f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	52                   	push   %edx
80101f91:	e8 da 28 00 00       	call   80104870 <releasesleep>
  iput(ip);
80101f96:	89 34 24             	mov    %esi,(%esp)
80101f99:	89 fe                	mov    %edi,%esi
80101f9b:	e8 90 f9 ff ff       	call   80101930 <iput>
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	e9 13 ff ff ff       	jmp    80101ebb <namex+0x4b>
80101fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101faf:	90                   	nop
    name[len] = 0;
80101fb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fb3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101fb6:	83 ec 04             	sub    $0x4,%esp
80101fb9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fbc:	50                   	push   %eax
80101fbd:	53                   	push   %ebx
    name[len] = 0;
80101fbe:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fc0:	ff 75 e4             	push   -0x1c(%ebp)
80101fc3:	e8 18 2e 00 00       	call   80104de0 <memmove>
    name[len] = 0;
80101fc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	c6 02 00             	movb   $0x0,(%edx)
80101fd1:	e9 39 ff ff ff       	jmp    80101f0f <namex+0x9f>
80101fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	0f 85 be 00 00 00    	jne    801020a9 <namex+0x239>
    iput(ip);
    return 0;
  }
  return ip;
}
80101feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fee:	89 f0                	mov    %esi,%eax
80101ff0:	5b                   	pop    %ebx
80101ff1:	5e                   	pop    %esi
80101ff2:	5f                   	pop    %edi
80101ff3:	5d                   	pop    %ebp
80101ff4:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101ff5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff8:	89 df                	mov    %ebx,%edi
80101ffa:	31 c0                	xor    %eax,%eax
80101ffc:	eb b8                	jmp    80101fb6 <namex+0x146>
    ip = iget(ROOTDEV, ROOTINO);
80101ffe:	ba 01 00 00 00       	mov    $0x1,%edx
80102003:	b8 01 00 00 00       	mov    $0x1,%eax
80102008:	e8 a3 f3 ff ff       	call   801013b0 <iget>
8010200d:	89 c6                	mov    %eax,%esi
8010200f:	e9 a7 fe ff ff       	jmp    80101ebb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102014:	83 ec 0c             	sub    $0xc,%esp
80102017:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010201a:	53                   	push   %ebx
8010201b:	e8 90 28 00 00       	call   801048b0 <holdingsleep>
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 84 91 00 00 00    	je     801020bc <namex+0x24c>
8010202b:	8b 46 08             	mov    0x8(%esi),%eax
8010202e:	85 c0                	test   %eax,%eax
80102030:	0f 8e 86 00 00 00    	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	53                   	push   %ebx
8010203a:	e8 31 28 00 00       	call   80104870 <releasesleep>
  iput(ip);
8010203f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102042:	31 f6                	xor    %esi,%esi
  iput(ip);
80102044:	e8 e7 f8 ff ff       	call   80101930 <iput>
      return 0;
80102049:	83 c4 10             	add    $0x10,%esp
}
8010204c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010204f:	89 f0                	mov    %esi,%eax
80102051:	5b                   	pop    %ebx
80102052:	5e                   	pop    %esi
80102053:	5f                   	pop    %edi
80102054:	5d                   	pop    %ebp
80102055:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010205c:	52                   	push   %edx
8010205d:	e8 4e 28 00 00       	call   801048b0 <holdingsleep>
80102062:	83 c4 10             	add    $0x10,%esp
80102065:	85 c0                	test   %eax,%eax
80102067:	74 53                	je     801020bc <namex+0x24c>
80102069:	8b 4e 08             	mov    0x8(%esi),%ecx
8010206c:	85 c9                	test   %ecx,%ecx
8010206e:	7e 4c                	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80102070:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102073:	83 ec 0c             	sub    $0xc,%esp
80102076:	52                   	push   %edx
80102077:	eb c1                	jmp    8010203a <namex+0x1ca>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102079:	83 ec 0c             	sub    $0xc,%esp
8010207c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010207f:	53                   	push   %ebx
80102080:	e8 2b 28 00 00       	call   801048b0 <holdingsleep>
80102085:	83 c4 10             	add    $0x10,%esp
80102088:	85 c0                	test   %eax,%eax
8010208a:	74 30                	je     801020bc <namex+0x24c>
8010208c:	8b 7e 08             	mov    0x8(%esi),%edi
8010208f:	85 ff                	test   %edi,%edi
80102091:	7e 29                	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	53                   	push   %ebx
80102097:	e8 d4 27 00 00       	call   80104870 <releasesleep>
}
8010209c:	83 c4 10             	add    $0x10,%esp
}
8010209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a2:	89 f0                	mov    %esi,%eax
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
    iput(ip);
801020a9:	83 ec 0c             	sub    $0xc,%esp
801020ac:	56                   	push   %esi
    return 0;
801020ad:	31 f6                	xor    %esi,%esi
    iput(ip);
801020af:	e8 7c f8 ff ff       	call   80101930 <iput>
    return 0;
801020b4:	83 c4 10             	add    $0x10,%esp
801020b7:	e9 2f ff ff ff       	jmp    80101feb <namex+0x17b>
    panic("iunlock");
801020bc:	83 ec 0c             	sub    $0xc,%esp
801020bf:	68 bf 7c 10 80       	push   $0x80107cbf
801020c4:	e8 07 e3 ff ff       	call   801003d0 <panic>
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <dirlink>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 20             	sub    $0x20,%esp
801020d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020dc:	6a 00                	push   $0x0
801020de:	ff 75 0c             	push   0xc(%ebp)
801020e1:	53                   	push   %ebx
801020e2:	e8 c9 fc ff ff       	call   80101db0 <dirlookup>
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	85 c0                	test   %eax,%eax
801020ec:	75 72                	jne    80102160 <dirlink+0x90>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ee:	8b bb a8 00 00 00    	mov    0xa8(%ebx),%edi
801020f4:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020f7:	85 ff                	test   %edi,%edi
801020f9:	74 31                	je     8010212c <dirlink+0x5c>
801020fb:	31 ff                	xor    %edi,%edi
801020fd:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102100:	eb 11                	jmp    80102113 <dirlink+0x43>
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	83 c7 10             	add    $0x10,%edi
8010210b:	3b bb a8 00 00 00    	cmp    0xa8(%ebx),%edi
80102111:	73 19                	jae    8010212c <dirlink+0x5c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102113:	6a 10                	push   $0x10
80102115:	57                   	push   %edi
80102116:	56                   	push   %esi
80102117:	53                   	push   %ebx
80102118:	e8 23 fa ff ff       	call   80101b40 <readi>
8010211d:	83 c4 10             	add    $0x10,%esp
80102120:	83 f8 10             	cmp    $0x10,%eax
80102123:	75 4e                	jne    80102173 <dirlink+0xa3>
    if(de.inum == 0)
80102125:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010212a:	75 dc                	jne    80102108 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
8010212c:	83 ec 04             	sub    $0x4,%esp
8010212f:	8d 45 da             	lea    -0x26(%ebp),%eax
80102132:	6a 0e                	push   $0xe
80102134:	ff 75 0c             	push   0xc(%ebp)
80102137:	50                   	push   %eax
80102138:	e8 63 2d 00 00       	call   80104ea0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010213d:	6a 10                	push   $0x10
  de.inum = inum;
8010213f:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102142:	57                   	push   %edi
80102143:	56                   	push   %esi
80102144:	53                   	push   %ebx
  de.inum = inum;
80102145:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102149:	e8 02 fb ff ff       	call   80101c50 <writei>
8010214e:	83 c4 20             	add    $0x20,%esp
80102151:	83 f8 10             	cmp    $0x10,%eax
80102154:	75 2a                	jne    80102180 <dirlink+0xb0>
  return 0;
80102156:	31 c0                	xor    %eax,%eax
}
80102158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215b:	5b                   	pop    %ebx
8010215c:	5e                   	pop    %esi
8010215d:	5f                   	pop    %edi
8010215e:	5d                   	pop    %ebp
8010215f:	c3                   	ret    
    iput(ip);
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	50                   	push   %eax
80102164:	e8 c7 f7 ff ff       	call   80101930 <iput>
    return -1;
80102169:	83 c4 10             	add    $0x10,%esp
8010216c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102171:	eb e5                	jmp    80102158 <dirlink+0x88>
      panic("dirlink read");
80102173:	83 ec 0c             	sub    $0xc,%esp
80102176:	68 e8 7c 10 80       	push   $0x80107ce8
8010217b:	e8 50 e2 ff ff       	call   801003d0 <panic>
    panic("dirlink");
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 8e 83 10 80       	push   $0x8010838e
80102188:	e8 43 e2 ff ff       	call   801003d0 <panic>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi

80102190 <namei>:

struct inode*
namei(char *path)
{
80102190:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102191:	31 d2                	xor    %edx,%edx
{
80102193:	89 e5                	mov    %esp,%ebp
80102195:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102198:	8b 45 08             	mov    0x8(%ebp),%eax
8010219b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010219e:	e8 cd fc ff ff       	call   80101e70 <namex>
}
801021a3:	c9                   	leave  
801021a4:	c3                   	ret    
801021a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021b0:	55                   	push   %ebp
  return namex(path, 1, name);
801021b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021bf:	e9 ac fc ff ff       	jmp    80101e70 <namex>
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021d9:	85 c0                	test   %eax,%eax
801021db:	0f 84 b7 00 00 00    	je     80102298 <idestart+0xc8>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021e1:	8b 70 08             	mov    0x8(%eax),%esi
801021e4:	89 c3                	mov    %eax,%ebx
801021e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ec:	0f 87 99 00 00 00    	ja     8010228b <idestart+0xbb>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fe:	66 90                	xchg   %ax,%ax
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	31 ff                	xor    %edi,%edi
8010220c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102211:	89 f8                	mov    %edi,%eax
80102213:	ee                   	out    %al,(%dx)
80102214:	b8 01 00 00 00       	mov    $0x1,%eax
80102219:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010221e:	ee                   	out    %al,(%dx)
8010221f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102224:	89 f0                	mov    %esi,%eax
80102226:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102227:	89 f0                	mov    %esi,%eax
80102229:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010222e:	c1 f8 08             	sar    $0x8,%eax
80102231:	ee                   	out    %al,(%dx)
80102232:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102237:	89 f8                	mov    %edi,%eax
80102239:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010223a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010223e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102243:	c1 e0 04             	shl    $0x4,%eax
80102246:	83 e0 10             	and    $0x10,%eax
80102249:	83 c8 e0             	or     $0xffffffe0,%eax
8010224c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010224d:	f6 03 04             	testb  $0x4,(%ebx)
80102250:	75 16                	jne    80102268 <idestart+0x98>
80102252:	b8 20 00 00 00       	mov    $0x20,%eax
80102257:	89 ca                	mov    %ecx,%edx
80102259:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010225a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225d:	5b                   	pop    %ebx
8010225e:	5e                   	pop    %esi
8010225f:	5f                   	pop    %edi
80102260:	5d                   	pop    %ebp
80102261:	c3                   	ret    
80102262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102268:	b8 30 00 00 00       	mov    $0x30,%eax
8010226d:	89 ca                	mov    %ecx,%edx
8010226f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102270:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102275:	8d b3 ac 00 00 00    	lea    0xac(%ebx),%esi
8010227b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102280:	fc                   	cld    
80102281:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102286:	5b                   	pop    %ebx
80102287:	5e                   	pop    %esi
80102288:	5f                   	pop    %edi
80102289:	5d                   	pop    %ebp
8010228a:	c3                   	ret    
    panic("incorrect blockno");
8010228b:	83 ec 0c             	sub    $0xc,%esp
8010228e:	68 54 7d 10 80       	push   $0x80107d54
80102293:	e8 38 e1 ff ff       	call   801003d0 <panic>
    panic("idestart");
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	68 4b 7d 10 80       	push   $0x80107d4b
801022a0:	e8 2b e1 ff ff       	call   801003d0 <panic>
801022a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideinit>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022b6:	68 66 7d 10 80       	push   $0x80107d66
801022bb:	68 a0 40 11 80       	push   $0x801140a0
801022c0:	e8 3b 26 00 00       	call   80104900 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022c5:	58                   	pop    %eax
801022c6:	a1 04 43 11 80       	mov    0x80114304,%eax
801022cb:	5a                   	pop    %edx
801022cc:	83 e8 01             	sub    $0x1,%eax
801022cf:	50                   	push   %eax
801022d0:	6a 0e                	push   $0xe
801022d2:	e8 a9 02 00 00       	call   80102580 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
801022e1:	83 e0 c0             	and    $0xffffffc0,%eax
801022e4:	3c 40                	cmp    $0x40,%al
801022e6:	75 f8                	jne    801022e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f2:	ee                   	out    %al,(%dx)
801022f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022fd:	eb 06                	jmp    80102305 <ideinit+0x55>
801022ff:	90                   	nop
  for(i=0; i<1000; i++){
80102300:	83 e9 01             	sub    $0x1,%ecx
80102303:	74 0f                	je     80102314 <ideinit+0x64>
80102305:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102306:	84 c0                	test   %al,%al
80102308:	74 f6                	je     80102300 <ideinit+0x50>
      havedisk1 = 1;
8010230a:	c7 05 80 40 11 80 01 	movl   $0x1,0x80114080
80102311:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102314:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102319:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010231e:	ee                   	out    %al,(%dx)
}
8010231f:	c9                   	leave  
80102320:	c3                   	ret    
80102321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop

80102330 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102339:	68 a0 40 11 80       	push   $0x801140a0
8010233e:	e8 8d 27 00 00       	call   80104ad0 <acquire>

  if((b = idequeue) == 0){
80102343:	8b 1d 84 40 11 80    	mov    0x80114084,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 db                	test   %ebx,%ebx
8010234e:	74 66                	je     801023b6 <ideintr+0x86>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102350:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102356:	a3 84 40 11 80       	mov    %eax,0x80114084

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010235b:	8b 33                	mov    (%ebx),%esi
8010235d:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102363:	75 2f                	jne    80102394 <ideintr+0x64>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102365:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102370:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102371:	89 c1                	mov    %eax,%ecx
80102373:	83 e1 c0             	and    $0xffffffc0,%ecx
80102376:	80 f9 40             	cmp    $0x40,%cl
80102379:	75 f5                	jne    80102370 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010237b:	a8 21                	test   $0x21,%al
8010237d:	75 15                	jne    80102394 <ideintr+0x64>
    insl(0x1f0, b->data, BSIZE/4);
8010237f:	8d bb ac 00 00 00    	lea    0xac(%ebx),%edi
  asm volatile("cld; rep insl" :
80102385:	b9 80 00 00 00       	mov    $0x80,%ecx
8010238a:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010238f:	fc                   	cld    
80102390:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102392:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102394:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102397:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
8010239a:	83 ce 02             	or     $0x2,%esi
8010239d:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010239f:	53                   	push   %ebx
801023a0:	e8 ab 1e 00 00       	call   80104250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023a5:	a1 84 40 11 80       	mov    0x80114084,%eax
801023aa:	83 c4 10             	add    $0x10,%esp
801023ad:	85 c0                	test   %eax,%eax
801023af:	74 05                	je     801023b6 <ideintr+0x86>
    idestart(idequeue);
801023b1:	e8 1a fe ff ff       	call   801021d0 <idestart>
    release(&idelock);
801023b6:	83 ec 0c             	sub    $0xc,%esp
801023b9:	68 a0 40 11 80       	push   $0x801140a0
801023be:	e8 ad 26 00 00       	call   80104a70 <release>

  release(&idelock);
}
801023c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c6:	5b                   	pop    %ebx
801023c7:	5e                   	pop    %esi
801023c8:	5f                   	pop    %edi
801023c9:	5d                   	pop    %ebp
801023ca:	c3                   	ret    
801023cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 10             	sub    $0x10,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023da:	8d 43 0c             	lea    0xc(%ebx),%eax
801023dd:	50                   	push   %eax
801023de:	e8 cd 24 00 00       	call   801048b0 <holdingsleep>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	85 c0                	test   %eax,%eax
801023e8:	0f 84 d3 00 00 00    	je     801024c1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 e0 06             	and    $0x6,%eax
801023f3:	83 f8 02             	cmp    $0x2,%eax
801023f6:	0f 84 b8 00 00 00    	je     801024b4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023fc:	8b 53 04             	mov    0x4(%ebx),%edx
801023ff:	85 d2                	test   %edx,%edx
80102401:	74 0d                	je     80102410 <iderw+0x40>
80102403:	a1 80 40 11 80       	mov    0x80114080,%eax
80102408:	85 c0                	test   %eax,%eax
8010240a:	0f 84 97 00 00 00    	je     801024a7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	68 a0 40 11 80       	push   $0x801140a0
80102418:	e8 b3 26 00 00       	call   80104ad0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	a1 84 40 11 80       	mov    0x80114084,%eax
80102422:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102425:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
8010242c:	00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010242f:	85 c0                	test   %eax,%eax
80102431:	74 6d                	je     801024a0 <iderw+0xd0>
80102433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102437:	90                   	nop
80102438:	89 c2                	mov    %eax,%edx
8010243a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80102440:	85 c0                	test   %eax,%eax
80102442:	75 f4                	jne    80102438 <iderw+0x68>
80102444:	81 c2 a8 00 00 00    	add    $0xa8,%edx
    ;
  *pp = b;
8010244a:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010244c:	39 1d 84 40 11 80    	cmp    %ebx,0x80114084
80102452:	74 3c                	je     80102490 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102454:	8b 03                	mov    (%ebx),%eax
80102456:	83 e0 06             	and    $0x6,%eax
80102459:	83 f8 02             	cmp    $0x2,%eax
8010245c:	74 1d                	je     8010247b <iderw+0xab>
8010245e:	66 90                	xchg   %ax,%ax
    sleep(b, &idelock);
80102460:	83 ec 08             	sub    $0x8,%esp
80102463:	68 a0 40 11 80       	push   $0x801140a0
80102468:	53                   	push   %ebx
80102469:	e8 22 1d 00 00       	call   80104190 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010246e:	8b 03                	mov    (%ebx),%eax
80102470:	83 c4 10             	add    $0x10,%esp
80102473:	83 e0 06             	and    $0x6,%eax
80102476:	83 f8 02             	cmp    $0x2,%eax
80102479:	75 e5                	jne    80102460 <iderw+0x90>
  }


  release(&idelock);
8010247b:	c7 45 08 a0 40 11 80 	movl   $0x801140a0,0x8(%ebp)
}
80102482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102485:	c9                   	leave  
  release(&idelock);
80102486:	e9 e5 25 00 00       	jmp    80104a70 <release>
8010248b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010248f:	90                   	nop
    idestart(b);
80102490:	89 d8                	mov    %ebx,%eax
80102492:	e8 39 fd ff ff       	call   801021d0 <idestart>
80102497:	eb bb                	jmp    80102454 <iderw+0x84>
80102499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024a0:	ba 84 40 11 80       	mov    $0x80114084,%edx
801024a5:	eb a3                	jmp    8010244a <iderw+0x7a>
    panic("iderw: ide disk 1 not present");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 95 7d 10 80       	push   $0x80107d95
801024af:	e8 1c df ff ff       	call   801003d0 <panic>
    panic("iderw: nothing to do");
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	68 80 7d 10 80       	push   $0x80107d80
801024bc:	e8 0f df ff ff       	call   801003d0 <panic>
    panic("iderw: buf not locked");
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	68 6a 7d 10 80       	push   $0x80107d6a
801024c9:	e8 02 df ff ff       	call   801003d0 <panic>
801024ce:	66 90                	xchg   %ax,%ax

801024d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024d1:	c7 05 24 41 11 80 00 	movl   $0xfec00000,0x80114124
801024d8:	00 c0 fe 
{
801024db:	89 e5                	mov    %esp,%ebp
801024dd:	56                   	push   %esi
801024de:	53                   	push   %ebx
  ioapic->reg = reg;
801024df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024e6:	00 00 00 
  return ioapic->data;
801024e9:	8b 15 24 41 11 80    	mov    0x80114124,%edx
801024ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024f8:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024fe:	0f b6 15 00 43 11 80 	movzbl 0x80114300,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102505:	c1 ee 10             	shr    $0x10,%esi
80102508:	89 f0                	mov    %esi,%eax
8010250a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010250d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102510:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102513:	39 c2                	cmp    %eax,%edx
80102515:	74 16                	je     8010252d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102517:	83 ec 0c             	sub    $0xc,%esp
8010251a:	68 b4 7d 10 80       	push   $0x80107db4
8010251f:	e8 cc e1 ff ff       	call   801006f0 <cprintf>
  ioapic->reg = reg;
80102524:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
8010252a:	83 c4 10             	add    $0x10,%esp
8010252d:	83 c6 21             	add    $0x21,%esi
{
80102530:	ba 10 00 00 00       	mov    $0x10,%edx
80102535:	b8 20 00 00 00       	mov    $0x20,%eax
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102540:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102542:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102544:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
  for(i = 0; i <= maxintr; i++){
8010254a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010254d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102553:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102556:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102559:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010255c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010255e:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
80102564:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010256b:	39 f0                	cmp    %esi,%eax
8010256d:	75 d1                	jne    80102540 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010256f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102572:	5b                   	pop    %ebx
80102573:	5e                   	pop    %esi
80102574:	5d                   	pop    %ebp
80102575:	c3                   	ret    
80102576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257d:	8d 76 00             	lea    0x0(%esi),%esi

80102580 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102580:	55                   	push   %ebp
  ioapic->reg = reg;
80102581:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010258c:	8d 50 20             	lea    0x20(%eax),%edx
8010258f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102593:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102595:	8b 0d 24 41 11 80    	mov    0x80114124,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010259e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a6:	a1 24 41 11 80       	mov    0x80114124,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
801025c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025d0:	75 76                	jne    80102648 <kfree+0x88>
801025d2:	81 fb 10 82 11 80    	cmp    $0x80118210,%ebx
801025d8:	72 6e                	jb     80102648 <kfree+0x88>
801025da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025e5:	77 61                	ja     80102648 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025e7:	83 ec 04             	sub    $0x4,%esp
801025ea:	68 00 10 00 00       	push   $0x1000
801025ef:	6a 01                	push   $0x1
801025f1:	53                   	push   %ebx
801025f2:	e8 49 27 00 00       	call   80104d40 <memset>

  if(kmem.use_lock)
801025f7:	8b 15 c4 41 11 80    	mov    0x801141c4,%edx
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	85 d2                	test   %edx,%edx
80102602:	75 1c                	jne    80102620 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102604:	a1 c8 41 11 80       	mov    0x801141c8,%eax
80102609:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010260b:	a1 c4 41 11 80       	mov    0x801141c4,%eax
  kmem.freelist = r;
80102610:	89 1d c8 41 11 80    	mov    %ebx,0x801141c8
  if(kmem.use_lock)
80102616:	85 c0                	test   %eax,%eax
80102618:	75 1e                	jne    80102638 <kfree+0x78>
    release(&kmem.lock);
}
8010261a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261d:	c9                   	leave  
8010261e:	c3                   	ret    
8010261f:	90                   	nop
    acquire(&kmem.lock);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 40 41 11 80       	push   $0x80114140
80102628:	e8 a3 24 00 00       	call   80104ad0 <acquire>
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	eb d2                	jmp    80102604 <kfree+0x44>
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102638:	c7 45 08 40 41 11 80 	movl   $0x80114140,0x8(%ebp)
}
8010263f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102642:	c9                   	leave  
    release(&kmem.lock);
80102643:	e9 28 24 00 00       	jmp    80104a70 <release>
    panic("kfree");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 e6 7d 10 80       	push   $0x80107de6
80102650:	e8 7b dd ff ff       	call   801003d0 <panic>
80102655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102660 <freerange>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102667:	8b 75 0c             	mov    0xc(%ebp),%esi
8010266a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 23                	jb     801026a4 <freerange+0x44>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 23 ff ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 f3                	cmp    %esi,%ebx
801026a2:	76 e4                	jbe    80102688 <freerange+0x28>
}
801026a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a7:	5b                   	pop    %ebx
801026a8:	5e                   	pop    %esi
801026a9:	5d                   	pop    %ebp
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop

801026b0 <kinit2>:
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cd:	39 de                	cmp    %ebx,%esi
801026cf:	72 23                	jb     801026f4 <kinit2+0x44>
801026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026d8:	83 ec 0c             	sub    $0xc,%esp
801026db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026e7:	50                   	push   %eax
801026e8:	e8 d3 fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	39 de                	cmp    %ebx,%esi
801026f2:	73 e4                	jae    801026d8 <kinit2+0x28>
  kmem.use_lock = 1;
801026f4:	c7 05 c4 41 11 80 01 	movl   $0x1,0x801141c4
801026fb:	00 00 00 
}
801026fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102701:	5b                   	pop    %ebx
80102702:	5e                   	pop    %esi
80102703:	5d                   	pop    %ebp
80102704:	c3                   	ret    
80102705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <kinit1>:
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	56                   	push   %esi
80102714:	53                   	push   %ebx
80102715:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102718:	83 ec 08             	sub    $0x8,%esp
8010271b:	68 ec 7d 10 80       	push   $0x80107dec
80102720:	68 40 41 11 80       	push   $0x80114140
80102725:	e8 d6 21 00 00       	call   80104900 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010272a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010272d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102730:	c7 05 c4 41 11 80 00 	movl   $0x0,0x801141c4
80102737:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102740:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102746:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010274c:	39 de                	cmp    %ebx,%esi
8010274e:	72 1c                	jb     8010276c <kinit1+0x5c>
    kfree(p);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102759:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010275f:	50                   	push   %eax
80102760:	e8 5b fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102765:	83 c4 10             	add    $0x10,%esp
80102768:	39 de                	cmp    %ebx,%esi
8010276a:	73 e4                	jae    80102750 <kinit1+0x40>
}
8010276c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010276f:	5b                   	pop    %ebx
80102770:	5e                   	pop    %esi
80102771:	5d                   	pop    %ebp
80102772:	c3                   	ret    
80102773:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102780 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102780:	a1 c4 41 11 80       	mov    0x801141c4,%eax
80102785:	85 c0                	test   %eax,%eax
80102787:	75 1f                	jne    801027a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102789:	a1 c8 41 11 80       	mov    0x801141c8,%eax
  if(r)
8010278e:	85 c0                	test   %eax,%eax
80102790:	74 0e                	je     801027a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102792:	8b 10                	mov    (%eax),%edx
80102794:	89 15 c8 41 11 80    	mov    %edx,0x801141c8
  if(kmem.use_lock)
8010279a:	c3                   	ret    
8010279b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010279f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801027a0:	c3                   	ret    
801027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027a8:	55                   	push   %ebp
801027a9:	89 e5                	mov    %esp,%ebp
801027ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027ae:	68 40 41 11 80       	push   $0x80114140
801027b3:	e8 18 23 00 00       	call   80104ad0 <acquire>
  r = kmem.freelist;
801027b8:	a1 c8 41 11 80       	mov    0x801141c8,%eax
  if(kmem.use_lock)
801027bd:	8b 15 c4 41 11 80    	mov    0x801141c4,%edx
  if(r)
801027c3:	83 c4 10             	add    $0x10,%esp
801027c6:	85 c0                	test   %eax,%eax
801027c8:	74 08                	je     801027d2 <kalloc+0x52>
    kmem.freelist = r->next;
801027ca:	8b 08                	mov    (%eax),%ecx
801027cc:	89 0d c8 41 11 80    	mov    %ecx,0x801141c8
  if(kmem.use_lock)
801027d2:	85 d2                	test   %edx,%edx
801027d4:	74 16                	je     801027ec <kalloc+0x6c>
    release(&kmem.lock);
801027d6:	83 ec 0c             	sub    $0xc,%esp
801027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027dc:	68 40 41 11 80       	push   $0x80114140
801027e1:	e8 8a 22 00 00       	call   80104a70 <release>
  return (char*)r;
801027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027e9:	83 c4 10             	add    $0x10,%esp
}
801027ec:	c9                   	leave  
801027ed:	c3                   	ret    
801027ee:	66 90                	xchg   %ax,%ax

801027f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f0:	ba 64 00 00 00       	mov    $0x64,%edx
801027f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027f6:	a8 01                	test   $0x1,%al
801027f8:	0f 84 c2 00 00 00    	je     801028c0 <kbdgetc+0xd0>
{
801027fe:	55                   	push   %ebp
801027ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102804:	89 e5                	mov    %esp,%ebp
80102806:	53                   	push   %ebx
80102807:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102808:	8b 1d cc 41 11 80    	mov    0x801141cc,%ebx
  data = inb(KBDATAP);
8010280e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102811:	3c e0                	cmp    $0xe0,%al
80102813:	74 5b                	je     80102870 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102815:	89 da                	mov    %ebx,%edx
80102817:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010281a:	84 c0                	test   %al,%al
8010281c:	78 62                	js     80102880 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010281e:	85 d2                	test   %edx,%edx
80102820:	74 09                	je     8010282b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102822:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102825:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102828:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010282b:	0f b6 91 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%edx
  shift ^= togglecode[data];
80102832:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
  shift |= shiftcode[data];
80102839:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010283b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010283d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010283f:	89 15 cc 41 11 80    	mov    %edx,0x801141cc
  c = charcode[shift & (CTL | SHIFT)][data];
80102845:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102848:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010284b:	8b 04 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%eax
80102852:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102856:	74 0b                	je     80102863 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102858:	8d 50 9f             	lea    -0x61(%eax),%edx
8010285b:	83 fa 19             	cmp    $0x19,%edx
8010285e:	77 48                	ja     801028a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102860:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102863:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102866:	c9                   	leave  
80102867:	c3                   	ret    
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
    shift |= E0ESC;
80102870:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102873:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102875:	89 1d cc 41 11 80    	mov    %ebx,0x801141cc
}
8010287b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010287e:	c9                   	leave  
8010287f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102880:	83 e0 7f             	and    $0x7f,%eax
80102883:	85 d2                	test   %edx,%edx
80102885:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102888:	0f b6 81 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%eax
8010288f:	83 c8 40             	or     $0x40,%eax
80102892:	0f b6 c0             	movzbl %al,%eax
80102895:	f7 d0                	not    %eax
80102897:	21 d8                	and    %ebx,%eax
}
80102899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010289c:	a3 cc 41 11 80       	mov    %eax,0x801141cc
    return 0;
801028a1:	31 c0                	xor    %eax,%eax
}
801028a3:	c9                   	leave  
801028a4:	c3                   	ret    
801028a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801028ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b1:	c9                   	leave  
      c += 'a' - 'A';
801028b2:	83 f9 1a             	cmp    $0x1a,%ecx
801028b5:	0f 42 c2             	cmovb  %edx,%eax
}
801028b8:	c3                   	ret    
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028c5:	c3                   	ret    
801028c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cd:	8d 76 00             	lea    0x0(%esi),%esi

801028d0 <kbdintr>:

void
kbdintr(void)
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
801028d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028d6:	68 f0 27 10 80       	push   $0x801027f0
801028db:	e8 f0 df ff ff       	call   801008d0 <consoleintr>
}
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	c9                   	leave  
801028e4:	c3                   	ret    
801028e5:	66 90                	xchg   %ax,%ax
801028e7:	66 90                	xchg   %ax,%ax
801028e9:	66 90                	xchg   %ax,%ax
801028eb:	66 90                	xchg   %ax,%ax
801028ed:	66 90                	xchg   %ax,%ax
801028ef:	90                   	nop

801028f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028f0:	a1 d0 41 11 80       	mov    0x801141d0,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	0f 84 cb 00 00 00    	je     801029c8 <lapicinit+0xd8>
  lapic[index] = value;
801028fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102904:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102911:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102917:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010291e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102921:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102924:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010292b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010292e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102931:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102938:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010293b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102945:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102948:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010294b:	8b 50 30             	mov    0x30(%eax),%edx
8010294e:	c1 ea 10             	shr    $0x10,%edx
80102951:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102957:	75 77                	jne    801029d0 <lapicinit+0xe0>
  lapic[index] = value;
80102959:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102960:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102966:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010296d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102973:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102980:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102987:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102994:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102997:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029a4:	8b 50 20             	mov    0x20(%eax),%edx
801029a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029b6:	80 e6 10             	and    $0x10,%dh
801029b9:	75 f5                	jne    801029b0 <lapicinit+0xc0>
  lapic[index] = value;
801029bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029c8:	c3                   	ret    
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 50 20             	mov    0x20(%eax),%edx
}
801029dd:	e9 77 ff ff ff       	jmp    80102959 <lapicinit+0x69>
801029e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029f0:	a1 d0 41 11 80       	mov    0x801141d0,%eax
801029f5:	85 c0                	test   %eax,%eax
801029f7:	74 07                	je     80102a00 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029f9:	8b 40 20             	mov    0x20(%eax),%eax
801029fc:	c1 e8 18             	shr    $0x18,%eax
801029ff:	c3                   	ret    
    return 0;
80102a00:	31 c0                	xor    %eax,%eax
}
80102a02:	c3                   	ret    
80102a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a10:	a1 d0 41 11 80       	mov    0x801141d0,%eax
80102a15:	85 c0                	test   %eax,%eax
80102a17:	74 0d                	je     80102a26 <lapiceoi+0x16>
  lapic[index] = value;
80102a19:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a26:	c3                   	ret    
80102a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a30:	c3                   	ret    
80102a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop

80102a40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a46:	ba 70 00 00 00       	mov    $0x70,%edx
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	53                   	push   %ebx
80102a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a54:	ee                   	out    %al,(%dx)
80102a55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a5f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a60:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a62:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a6b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a6d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a70:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a72:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a75:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a7e:	a1 d0 41 11 80       	mov    0x801141d0,%eax
80102a83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a93:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a96:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102aa0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aaf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102abe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102acd:	c9                   	leave  
80102ace:	c3                   	ret    
80102acf:	90                   	nop

80102ad0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ad0:	55                   	push   %ebp
80102ad1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ad6:	ba 70 00 00 00       	mov    $0x70,%edx
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	57                   	push   %edi
80102ade:	56                   	push   %esi
80102adf:	53                   	push   %ebx
80102ae0:	83 ec 4c             	sub    $0x4c,%esp
80102ae3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ae9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102aea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aed:	bb 70 00 00 00       	mov    $0x70,%ebx
80102af2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102af5:	8d 76 00             	lea    0x0(%esi),%esi
80102af8:	31 c0                	xor    %eax,%eax
80102afa:	89 da                	mov    %ebx,%edx
80102afc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b02:	89 ca                	mov    %ecx,%edx
80102b04:	ec                   	in     (%dx),%al
80102b05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b08:	89 da                	mov    %ebx,%edx
80102b0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b10:	89 ca                	mov    %ecx,%edx
80102b12:	ec                   	in     (%dx),%al
80102b13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	89 da                	mov    %ebx,%edx
80102b18:	b8 04 00 00 00       	mov    $0x4,%eax
80102b1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1e:	89 ca                	mov    %ecx,%edx
80102b20:	ec                   	in     (%dx),%al
80102b21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b24:	89 da                	mov    %ebx,%edx
80102b26:	b8 07 00 00 00       	mov    $0x7,%eax
80102b2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2c:	89 ca                	mov    %ecx,%edx
80102b2e:	ec                   	in     (%dx),%al
80102b2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b32:	89 da                	mov    %ebx,%edx
80102b34:	b8 08 00 00 00       	mov    $0x8,%eax
80102b39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3a:	89 ca                	mov    %ecx,%edx
80102b3c:	ec                   	in     (%dx),%al
80102b3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3f:	89 da                	mov    %ebx,%edx
80102b41:	b8 09 00 00 00       	mov    $0x9,%eax
80102b46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b47:	89 ca                	mov    %ecx,%edx
80102b49:	ec                   	in     (%dx),%al
80102b4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4c:	89 da                	mov    %ebx,%edx
80102b4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b54:	89 ca                	mov    %ecx,%edx
80102b56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b57:	84 c0                	test   %al,%al
80102b59:	78 9d                	js     80102af8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b5f:	89 fa                	mov    %edi,%edx
80102b61:	0f b6 fa             	movzbl %dl,%edi
80102b64:	89 f2                	mov    %esi,%edx
80102b66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b70:	89 da                	mov    %ebx,%edx
80102b72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b89:	31 c0                	xor    %eax,%eax
80102b8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8c:	89 ca                	mov    %ecx,%edx
80102b8e:	ec                   	in     (%dx),%al
80102b8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b92:	89 da                	mov    %ebx,%edx
80102b94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b97:	b8 02 00 00 00       	mov    $0x2,%eax
80102b9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9d:	89 ca                	mov    %ecx,%edx
80102b9f:	ec                   	in     (%dx),%al
80102ba0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba3:	89 da                	mov    %ebx,%edx
80102ba5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ba8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bae:	89 ca                	mov    %ecx,%edx
80102bb0:	ec                   	in     (%dx),%al
80102bb1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb4:	89 da                	mov    %ebx,%edx
80102bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bb9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbf:	89 ca                	mov    %ecx,%edx
80102bc1:	ec                   	in     (%dx),%al
80102bc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc5:	89 da                	mov    %ebx,%edx
80102bc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bca:	b8 08 00 00 00       	mov    $0x8,%eax
80102bcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd0:	89 ca                	mov    %ecx,%edx
80102bd2:	ec                   	in     (%dx),%al
80102bd3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd6:	89 da                	mov    %ebx,%edx
80102bd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bdb:	b8 09 00 00 00       	mov    $0x9,%eax
80102be0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be1:	89 ca                	mov    %ecx,%edx
80102be3:	ec                   	in     (%dx),%al
80102be4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102be7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bf0:	6a 18                	push   $0x18
80102bf2:	50                   	push   %eax
80102bf3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bf6:	50                   	push   %eax
80102bf7:	e8 94 21 00 00       	call   80104d90 <memcmp>
80102bfc:	83 c4 10             	add    $0x10,%esp
80102bff:	85 c0                	test   %eax,%eax
80102c01:	0f 85 f1 fe ff ff    	jne    80102af8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c0b:	75 78                	jne    80102c85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c10:	89 c2                	mov    %eax,%edx
80102c12:	83 e0 0f             	and    $0xf,%eax
80102c15:	c1 ea 04             	shr    $0x4,%edx
80102c18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c24:	89 c2                	mov    %eax,%edx
80102c26:	83 e0 0f             	and    $0xf,%eax
80102c29:	c1 ea 04             	shr    $0x4,%edx
80102c2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c38:	89 c2                	mov    %eax,%edx
80102c3a:	83 e0 0f             	and    $0xf,%eax
80102c3d:	c1 ea 04             	shr    $0x4,%edx
80102c40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c4c:	89 c2                	mov    %eax,%edx
80102c4e:	83 e0 0f             	and    $0xf,%eax
80102c51:	c1 ea 04             	shr    $0x4,%edx
80102c54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c60:	89 c2                	mov    %eax,%edx
80102c62:	83 e0 0f             	and    $0xf,%eax
80102c65:	c1 ea 04             	shr    $0x4,%edx
80102c68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c74:	89 c2                	mov    %eax,%edx
80102c76:	83 e0 0f             	and    $0xf,%eax
80102c79:	c1 ea 04             	shr    $0x4,%edx
80102c7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c85:	8b 75 08             	mov    0x8(%ebp),%esi
80102c88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c8b:	89 06                	mov    %eax,(%esi)
80102c8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c90:	89 46 04             	mov    %eax,0x4(%esi)
80102c93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c96:	89 46 08             	mov    %eax,0x8(%esi)
80102c99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ca2:	89 46 10             	mov    %eax,0x10(%esi)
80102ca5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ca8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cb5:	5b                   	pop    %ebx
80102cb6:	5e                   	pop    %esi
80102cb7:	5f                   	pop    %edi
80102cb8:	5d                   	pop    %ebp
80102cb9:	c3                   	ret    
80102cba:	66 90                	xchg   %ax,%ax
80102cbc:	66 90                	xchg   %ax,%ax
80102cbe:	66 90                	xchg   %ax,%ax

80102cc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cc0:	8b 0d 78 42 11 80    	mov    0x80114278,%ecx
80102cc6:	85 c9                	test   %ecx,%ecx
80102cc8:	0f 8e 92 00 00 00    	jle    80102d60 <install_trans+0xa0>
{
80102cce:	55                   	push   %ebp
80102ccf:	89 e5                	mov    %esp,%ebp
80102cd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd2:	31 ff                	xor    %edi,%edi
{
80102cd4:	56                   	push   %esi
80102cd5:	53                   	push   %ebx
80102cd6:	83 ec 0c             	sub    $0xc,%esp
80102cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ce0:	a1 64 42 11 80       	mov    0x80114264,%eax
80102ce5:	83 ec 08             	sub    $0x8,%esp
80102ce8:	01 f8                	add    %edi,%eax
80102cea:	83 c0 01             	add    $0x1,%eax
80102ced:	50                   	push   %eax
80102cee:	ff 35 74 42 11 80    	push   0x80114274
80102cf4:	e8 d7 d3 ff ff       	call   801000d0 <bread>
80102cf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cfb:	58                   	pop    %eax
80102cfc:	5a                   	pop    %edx
80102cfd:	ff 34 bd 7c 42 11 80 	push   -0x7feebd84(,%edi,4)
80102d04:	ff 35 74 42 11 80    	push   0x80114274
  for (tail = 0; tail < log.lh.n; tail++) {
80102d0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d0d:	e8 be d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d17:	8d 86 ac 00 00 00    	lea    0xac(%esi),%eax
80102d1d:	68 00 02 00 00       	push   $0x200
80102d22:	50                   	push   %eax
80102d23:	8d 83 ac 00 00 00    	lea    0xac(%ebx),%eax
80102d29:	50                   	push   %eax
80102d2a:	e8 b1 20 00 00       	call   80104de0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d2f:	89 1c 24             	mov    %ebx,(%esp)
80102d32:	e8 99 d4 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80102d37:	89 34 24             	mov    %esi,(%esp)
80102d3a:	e8 d1 d4 ff ff       	call   80100210 <brelse>
    brelse(dbuf);
80102d3f:	89 1c 24             	mov    %ebx,(%esp)
80102d42:	e8 c9 d4 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d47:	83 c4 10             	add    $0x10,%esp
80102d4a:	39 3d 78 42 11 80    	cmp    %edi,0x80114278
80102d50:	7f 8e                	jg     80102ce0 <install_trans+0x20>
  }
}
80102d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d55:	5b                   	pop    %ebx
80102d56:	5e                   	pop    %esi
80102d57:	5f                   	pop    %edi
80102d58:	5d                   	pop    %ebp
80102d59:	c3                   	ret    
80102d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d60:	c3                   	ret    
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop

80102d70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d77:	ff 35 64 42 11 80    	push   0x80114264
80102d7d:	ff 35 74 42 11 80    	push   0x80114274
80102d83:	e8 48 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d8d:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d92:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d98:	85 c0                	test   %eax,%eax
80102d9a:	7e 19                	jle    80102db5 <write_head+0x45>
80102d9c:	31 d2                	xor    %edx,%edx
80102d9e:	66 90                	xchg   %ax,%ax
    hb->block[i] = log.lh.block[i];
80102da0:	8b 0c 95 7c 42 11 80 	mov    -0x7feebd84(,%edx,4),%ecx
80102da7:	89 8c 93 b0 00 00 00 	mov    %ecx,0xb0(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dae:	83 c2 01             	add    $0x1,%edx
80102db1:	39 d0                	cmp    %edx,%eax
80102db3:	75 eb                	jne    80102da0 <write_head+0x30>
  }
  bwrite(buf);
80102db5:	83 ec 0c             	sub    $0xc,%esp
80102db8:	53                   	push   %ebx
80102db9:	e8 12 d4 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80102dbe:	89 1c 24             	mov    %ebx,(%esp)
80102dc1:	e8 4a d4 ff ff       	call   80100210 <brelse>
}
80102dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	c9                   	leave  
80102dcd:	c3                   	ret    
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <initlog>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 2c             	sub    $0x2c,%esp
80102dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dda:	68 20 80 10 80       	push   $0x80108020
80102ddf:	68 e0 41 11 80       	push   $0x801141e0
80102de4:	e8 17 1b 00 00       	call   80104900 <initlock>
  readsb(dev, &sb);
80102de9:	58                   	pop    %eax
80102dea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 8b e7 ff ff       	call   80101580 <readsb>
  log.start = sb.logstart;
80102df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102df8:	59                   	pop    %ecx
  log.dev = dev;
80102df9:	89 1d 74 42 11 80    	mov    %ebx,0x80114274
  log.size = sb.nlog;
80102dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e02:	a3 64 42 11 80       	mov    %eax,0x80114264
  log.size = sb.nlog;
80102e07:	89 15 68 42 11 80    	mov    %edx,0x80114268
  struct buf *buf = bread(log.dev, log.start);
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 bb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e18:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80102e1e:	89 1d 78 42 11 80    	mov    %ebx,0x80114278
  for (i = 0; i < log.lh.n; i++) {
80102e24:	85 db                	test   %ebx,%ebx
80102e26:	7e 1d                	jle    80102e45 <initlog+0x75>
80102e28:	31 d2                	xor    %edx,%edx
80102e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e30:	8b 8c 90 b0 00 00 00 	mov    0xb0(%eax,%edx,4),%ecx
80102e37:	89 0c 95 7c 42 11 80 	mov    %ecx,-0x7feebd84(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3e:	83 c2 01             	add    $0x1,%edx
80102e41:	39 d3                	cmp    %edx,%ebx
80102e43:	75 eb                	jne    80102e30 <initlog+0x60>
  brelse(buf);
80102e45:	83 ec 0c             	sub    $0xc,%esp
80102e48:	50                   	push   %eax
80102e49:	e8 c2 d3 ff ff       	call   80100210 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e4e:	e8 6d fe ff ff       	call   80102cc0 <install_trans>
  log.lh.n = 0;
80102e53:	c7 05 78 42 11 80 00 	movl   $0x0,0x80114278
80102e5a:	00 00 00 
  write_head(); // clear the log
80102e5d:	e8 0e ff ff ff       	call   80102d70 <write_head>
}
80102e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e65:	83 c4 10             	add    $0x10,%esp
80102e68:	c9                   	leave  
80102e69:	c3                   	ret    
80102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e76:	68 e0 41 11 80       	push   $0x801141e0
80102e7b:	e8 50 1c 00 00       	call   80104ad0 <acquire>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	eb 18                	jmp    80102e9d <begin_op+0x2d>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	68 e0 41 11 80       	push   $0x801141e0
80102e90:	68 e0 41 11 80       	push   $0x801141e0
80102e95:	e8 f6 12 00 00       	call   80104190 <sleep>
80102e9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e9d:	a1 70 42 11 80       	mov    0x80114270,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 e2                	jne    80102e88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ea6:	a1 6c 42 11 80       	mov    0x8011426c,%eax
80102eab:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102eb1:	83 c0 01             	add    $0x1,%eax
80102eb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102eb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eba:	83 fa 1e             	cmp    $0x1e,%edx
80102ebd:	7f c9                	jg     80102e88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ebf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ec2:	a3 6c 42 11 80       	mov    %eax,0x8011426c
      release(&log.lock);
80102ec7:	68 e0 41 11 80       	push   $0x801141e0
80102ecc:	e8 9f 1b 00 00       	call   80104a70 <release>
      break;
    }
  }
}
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	c9                   	leave  
80102ed5:	c3                   	ret    
80102ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edd:	8d 76 00             	lea    0x0(%esi),%esi

80102ee0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ee9:	68 e0 41 11 80       	push   $0x801141e0
80102eee:	e8 dd 1b 00 00       	call   80104ad0 <acquire>
  log.outstanding -= 1;
80102ef3:	a1 6c 42 11 80       	mov    0x8011426c,%eax
  if(log.committing)
80102ef8:	8b 35 70 42 11 80    	mov    0x80114270,%esi
80102efe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f04:	89 1d 6c 42 11 80    	mov    %ebx,0x8011426c
  if(log.committing)
80102f0a:	85 f6                	test   %esi,%esi
80102f0c:	0f 85 22 01 00 00    	jne    80103034 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f12:	85 db                	test   %ebx,%ebx
80102f14:	0f 85 f6 00 00 00    	jne    80103010 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f1a:	c7 05 70 42 11 80 01 	movl   $0x1,0x80114270
80102f21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 e0 41 11 80       	push   $0x801141e0
80102f2c:	e8 3f 1b 00 00       	call   80104a70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f31:	8b 0d 78 42 11 80    	mov    0x80114278,%ecx
80102f37:	83 c4 10             	add    $0x10,%esp
80102f3a:	85 c9                	test   %ecx,%ecx
80102f3c:	7f 42                	jg     80102f80 <end_op+0xa0>
    acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 e0 41 11 80       	push   $0x801141e0
80102f46:	e8 85 1b 00 00       	call   80104ad0 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
    log.committing = 0;
80102f52:	c7 05 70 42 11 80 00 	movl   $0x0,0x80114270
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 ef 12 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
80102f68:	e8 03 1b 00 00       	call   80104a70 <release>
80102f6d:	83 c4 10             	add    $0x10,%esp
}
80102f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f73:	5b                   	pop    %ebx
80102f74:	5e                   	pop    %esi
80102f75:	5f                   	pop    %edi
80102f76:	5d                   	pop    %ebp
80102f77:	c3                   	ret    
80102f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f80:	a1 64 42 11 80       	mov    0x80114264,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 d8                	add    %ebx,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 74 42 11 80    	push   0x80114274
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 9d 7c 42 11 80 	push   -0x7feebd84(,%ebx,4)
80102fa4:	ff 35 74 42 11 80    	push   0x80114274
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb7:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
80102fbd:	68 00 02 00 00       	push   $0x200
80102fc2:	50                   	push   %eax
80102fc3:	8d 86 ac 00 00 00    	lea    0xac(%esi),%eax
80102fc9:	50                   	push   %eax
80102fca:	e8 11 1e 00 00       	call   80104de0 <memmove>
    bwrite(to);  // write the log
80102fcf:	89 34 24             	mov    %esi,(%esp)
80102fd2:	e8 f9 d1 ff ff       	call   801001d0 <bwrite>
    brelse(from);
80102fd7:	89 3c 24             	mov    %edi,(%esp)
80102fda:	e8 31 d2 ff ff       	call   80100210 <brelse>
    brelse(to);
80102fdf:	89 34 24             	mov    %esi,(%esp)
80102fe2:	e8 29 d2 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe7:	83 c4 10             	add    $0x10,%esp
80102fea:	3b 1d 78 42 11 80    	cmp    0x80114278,%ebx
80102ff0:	7c 8e                	jl     80102f80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ff2:	e8 79 fd ff ff       	call   80102d70 <write_head>
    install_trans(); // Now install writes to home locations
80102ff7:	e8 c4 fc ff ff       	call   80102cc0 <install_trans>
    log.lh.n = 0;
80102ffc:	c7 05 78 42 11 80 00 	movl   $0x0,0x80114278
80103003:	00 00 00 
    write_head();    // Erase the transaction from the log
80103006:	e8 65 fd ff ff       	call   80102d70 <write_head>
8010300b:	e9 2e ff ff ff       	jmp    80102f3e <end_op+0x5e>
    wakeup(&log);
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 e0 41 11 80       	push   $0x801141e0
80103018:	e8 33 12 00 00       	call   80104250 <wakeup>
  release(&log.lock);
8010301d:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
80103024:	e8 47 1a 00 00       	call   80104a70 <release>
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
    panic("log.committing");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 24 80 10 80       	push   $0x80108024
8010303c:	e8 8f d3 ff ff       	call   801003d0 <panic>
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop

80103050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103057:	8b 15 78 42 11 80    	mov    0x80114278,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 85 00 00 00    	jg     801030ee <log_write+0x9e>
80103069:	a1 68 42 11 80       	mov    0x80114268,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	7d 79                	jge    801030ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103075:	a1 6c 42 11 80       	mov    0x8011426c,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	7e 7d                	jle    801030fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010307e:	83 ec 0c             	sub    $0xc,%esp
80103081:	68 e0 41 11 80       	push   $0x801141e0
80103086:	e8 45 1a 00 00       	call   80104ad0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010308b:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	85 d2                	test   %edx,%edx
80103096:	7e 4a                	jle    801030e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103098:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010309b:	31 c0                	xor    %eax,%eax
8010309d:	eb 08                	jmp    801030a7 <log_write+0x57>
8010309f:	90                   	nop
801030a0:	83 c0 01             	add    $0x1,%eax
801030a3:	39 c2                	cmp    %eax,%edx
801030a5:	74 29                	je     801030d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	39 0c 85 7c 42 11 80 	cmp    %ecx,-0x7feebd84(,%eax,4)
801030ae:	75 f0                	jne    801030a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 85 7c 42 11 80 	mov    %ecx,-0x7feebd84(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030bd:	c7 45 08 e0 41 11 80 	movl   $0x801141e0,0x8(%ebp)
}
801030c4:	c9                   	leave  
  release(&log.lock);
801030c5:	e9 a6 19 00 00       	jmp    80104a70 <release>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 7c 42 11 80 	mov    %ecx,-0x7feebd84(,%edx,4)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 78 42 11 80    	mov    %edx,0x80114278
801030e0:	eb d5                	jmp    801030b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030e2:	8b 43 08             	mov    0x8(%ebx),%eax
801030e5:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  if (i == log.lh.n)
801030ea:	75 cb                	jne    801030b7 <log_write+0x67>
801030ec:	eb e9                	jmp    801030d7 <log_write+0x87>
    panic("too big a transaction");
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 33 80 10 80       	push   $0x80108033
801030f6:	e8 d5 d2 ff ff       	call   801003d0 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 49 80 10 80       	push   $0x80108049
80103103:	e8 c8 d2 ff ff       	call   801003d0 <panic>
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103117:	e8 a4 09 00 00       	call   80103ac0 <cpuid>
8010311c:	89 c3                	mov    %eax,%ebx
8010311e:	e8 9d 09 00 00       	call   80103ac0 <cpuid>
80103123:	83 ec 04             	sub    $0x4,%esp
80103126:	53                   	push   %ebx
80103127:	50                   	push   %eax
80103128:	68 64 80 10 80       	push   $0x80108064
8010312d:	e8 be d5 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
80103132:	e8 c9 30 00 00       	call   80106200 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103137:	e8 24 09 00 00       	call   80103a60 <mycpu>
8010313c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010313e:	b8 01 00 00 00       	mov    $0x1,%eax
80103143:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010314a:	e8 51 0c 00 00       	call   80103da0 <scheduler>
8010314f:	90                   	nop

80103150 <mpenter>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103156:	e8 95 41 00 00       	call   801072f0 <switchkvm>
  seginit();
8010315b:	e8 00 41 00 00       	call   80107260 <seginit>
  lapicinit();
80103160:	e8 8b f7 ff ff       	call   801028f0 <lapicinit>
  mpmain();
80103165:	e8 a6 ff ff ff       	call   80103110 <mpmain>
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <main>:
{
80103170:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103174:	83 e4 f0             	and    $0xfffffff0,%esp
80103177:	ff 71 fc             	push   -0x4(%ecx)
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	53                   	push   %ebx
8010317e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	68 00 00 40 80       	push   $0x80400000
80103187:	68 10 82 11 80       	push   $0x80118210
8010318c:	e8 7f f5 ff ff       	call   80102710 <kinit1>
  kvmalloc();      // kernel page table
80103191:	e8 4a 46 00 00       	call   801077e0 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 50 f7 ff ff       	call   801028f0 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 bb 40 00 00       	call   80107260 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 21 f3 ff ff       	call   801024d0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 fc d8 ff ff       	call   80100ab0 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 37 33 00 00       	call   801064f0 <uartinit>
  pinit();         // process table
801031b9:	e8 82 08 00 00       	call   80103a40 <pinit>
  tvinit();        // trap vectors
801031be:	e8 bd 2f 00 00       	call   80106180 <tvinit>
  binit();         // buffer cache
801031c3:	e8 78 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031c8:	e8 93 dc ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801031cd:	e8 de f0 ff ff       	call   801022b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031d2:	83 c4 0c             	add    $0xc,%esp
801031d5:	68 8a 00 00 00       	push   $0x8a
801031da:	68 8c b4 10 80       	push   $0x8010b48c
801031df:	68 00 70 00 80       	push   $0x80007000
801031e4:	e8 f7 1b 00 00       	call   80104de0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	69 05 04 43 11 80 b0 	imul   $0xb0,0x80114304,%eax
801031f3:	00 00 00 
801031f6:	05 20 43 11 80       	add    $0x80114320,%eax
801031fb:	3d 20 43 11 80       	cmp    $0x80114320,%eax
80103200:	76 7e                	jbe    80103280 <main+0x110>
80103202:	bb 20 43 11 80       	mov    $0x80114320,%ebx
80103207:	eb 20                	jmp    80103229 <main+0xb9>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	69 05 04 43 11 80 b0 	imul   $0xb0,0x80114304,%eax
80103217:	00 00 00 
8010321a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103220:	05 20 43 11 80       	add    $0x80114320,%eax
80103225:	39 c3                	cmp    %eax,%ebx
80103227:	73 57                	jae    80103280 <main+0x110>
    if(c == mycpu())  // We've started already.
80103229:	e8 32 08 00 00       	call   80103a60 <mycpu>
8010322e:	39 c3                	cmp    %eax,%ebx
80103230:	74 de                	je     80103210 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103232:	e8 49 f5 ff ff       	call   80102780 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103237:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010323a:	c7 05 f8 6f 00 80 50 	movl   $0x80103150,0x80006ff8
80103241:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103244:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010324b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010324e:	05 00 10 00 00       	add    $0x1000,%eax
80103253:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103258:	0f b6 03             	movzbl (%ebx),%eax
8010325b:	68 00 70 00 00       	push   $0x7000
80103260:	50                   	push   %eax
80103261:	e8 da f7 ff ff       	call   80102a40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103266:	83 c4 10             	add    $0x10,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0x100>
8010327a:	eb 94                	jmp    80103210 <main+0xa0>
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103280:	83 ec 08             	sub    $0x8,%esp
80103283:	68 00 00 00 8e       	push   $0x8e000000
80103288:	68 00 00 40 80       	push   $0x80400000
8010328d:	e8 1e f4 ff ff       	call   801026b0 <kinit2>
  userinit();      // first user process
80103292:	e8 79 08 00 00       	call   80103b10 <userinit>
  mpmain();        // finish this processor's setup
80103297:	e8 74 fe ff ff       	call   80103110 <mpmain>
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032ab:	53                   	push   %ebx
  e = addr+len;
801032ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032b2:	39 de                	cmp    %ebx,%esi
801032b4:	72 10                	jb     801032c6 <mpsearch1+0x26>
801032b6:	eb 50                	jmp    80103308 <mpsearch1+0x68>
801032b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
801032c0:	89 fe                	mov    %edi,%esi
801032c2:	39 fb                	cmp    %edi,%ebx
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 78 80 10 80       	push   $0x80108078
801032d3:	56                   	push   %esi
801032d4:	e8 b7 1a 00 00       	call   80104d90 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	85 c0                	test   %eax,%eax
801032de:	75 e0                	jne    801032c0 <mpsearch1+0x20>
801032e0:	89 f2                	mov    %esi,%edx
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032f0:	39 fa                	cmp    %edi,%edx
801032f2:	75 f4                	jne    801032e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f4:	84 c0                	test   %al,%al
801032f6:	75 c8                	jne    801032c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fb:	89 f0                	mov    %esi,%eax
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010330b:	31 f6                	xor    %esi,%esi
}
8010330d:	5b                   	pop    %ebx
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret    
80103314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103329:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103330:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103337:	c1 e0 08             	shl    $0x8,%eax
8010333a:	09 d0                	or     %edx,%eax
8010333c:	c1 e0 04             	shl    $0x4,%eax
8010333f:	75 1b                	jne    8010335c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103341:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103348:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010334f:	c1 e0 08             	shl    $0x8,%eax
80103352:	09 d0                	or     %edx,%eax
80103354:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103357:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335c:	ba 00 04 00 00       	mov    $0x400,%edx
80103361:	e8 3a ff ff ff       	call   801032a0 <mpsearch1>
80103366:	89 c3                	mov    %eax,%ebx
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 84 40 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103370:	8b 73 04             	mov    0x4(%ebx),%esi
80103373:	85 f6                	test   %esi,%esi
80103375:	0f 84 25 01 00 00    	je     801034a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010337b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010337e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103384:	6a 04                	push   $0x4
80103386:	68 7d 80 10 80       	push   $0x8010807d
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 fc 19 00 00       	call   80104d90 <memcmp>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 c0                	test   %eax,%eax
80103399:	0f 85 01 01 00 00    	jne    801034a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010339f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033a6:	3c 01                	cmp    $0x1,%al
801033a8:	74 08                	je     801033b2 <mpinit+0x92>
801033aa:	3c 04                	cmp    $0x4,%al
801033ac:	0f 85 ee 00 00 00    	jne    801034a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033b9:	66 85 d2             	test   %dx,%dx
801033bc:	74 22                	je     801033e0 <mpinit+0xc0>
801033be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033c3:	31 d2                	xor    %edx,%edx
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d4:	39 c7                	cmp    %eax,%edi
801033d6:	75 f0                	jne    801033c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033d8:	84 d2                	test   %dl,%dl
801033da:	0f 85 c0 00 00 00    	jne    801034a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033e6:	a3 d0 41 11 80       	mov    %eax,0x801141d0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103407:	90                   	nop
80103408:	39 d0                	cmp    %edx,%eax
8010340a:	73 15                	jae    80103421 <mpinit+0x101>
    switch(*p){
8010340c:	0f b6 08             	movzbl (%eax),%ecx
8010340f:	80 f9 02             	cmp    $0x2,%cl
80103412:	74 4c                	je     80103460 <mpinit+0x140>
80103414:	77 3a                	ja     80103450 <mpinit+0x130>
80103416:	84 c9                	test   %cl,%cl
80103418:	74 56                	je     80103470 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010341a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	39 d0                	cmp    %edx,%eax
8010341f:	72 eb                	jb     8010340c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103424:	85 f6                	test   %esi,%esi
80103426:	0f 84 d9 00 00 00    	je     80103505 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010342c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103430:	74 15                	je     80103447 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	b8 70 00 00 00       	mov    $0x70,%eax
80103437:	ba 22 00 00 00       	mov    $0x22,%edx
8010343c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010343d:	ba 23 00 00 00       	mov    $0x23,%edx
80103442:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103443:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103446:	ee                   	out    %al,(%dx)
  }
}
80103447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344a:	5b                   	pop    %ebx
8010344b:	5e                   	pop    %esi
8010344c:	5f                   	pop    %edi
8010344d:	5d                   	pop    %ebp
8010344e:	c3                   	ret    
8010344f:	90                   	nop
    switch(*p){
80103450:	83 e9 03             	sub    $0x3,%ecx
80103453:	80 f9 01             	cmp    $0x1,%cl
80103456:	76 c2                	jbe    8010341a <mpinit+0xfa>
80103458:	31 f6                	xor    %esi,%esi
8010345a:	eb ac                	jmp    80103408 <mpinit+0xe8>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103460:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103464:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103467:	88 0d 00 43 11 80    	mov    %cl,0x80114300
      continue;
8010346d:	eb 99                	jmp    80103408 <mpinit+0xe8>
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d 04 43 11 80    	mov    0x80114304,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 04 43 11 80    	mov    %ecx,0x80114304
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f 20 43 11 80    	mov    %bl,-0x7feebce0(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 6c ff ff ff       	jmp    80103408 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 82 80 10 80       	push   $0x80108082
801034a8:	e8 23 cf ff ff       	call   801003d0 <panic>
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801034b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034b5:	eb 13                	jmp    801034ca <mpinit+0x1aa>
801034b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034c0:	89 f3                	mov    %esi,%ebx
801034c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034c8:	74 d6                	je     801034a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ca:	83 ec 04             	sub    $0x4,%esp
801034cd:	8d 73 10             	lea    0x10(%ebx),%esi
801034d0:	6a 04                	push   $0x4
801034d2:	68 78 80 10 80       	push   $0x80108078
801034d7:	53                   	push   %ebx
801034d8:	e8 b3 18 00 00       	call   80104d90 <memcmp>
801034dd:	83 c4 10             	add    $0x10,%esp
801034e0:	85 c0                	test   %eax,%eax
801034e2:	75 dc                	jne    801034c0 <mpinit+0x1a0>
801034e4:	89 da                	mov    %ebx,%edx
801034e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034f8:	39 d6                	cmp    %edx,%esi
801034fa:	75 f4                	jne    801034f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034fc:	84 c0                	test   %al,%al
801034fe:	75 c0                	jne    801034c0 <mpinit+0x1a0>
80103500:	e9 6b fe ff ff       	jmp    80103370 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	68 9c 80 10 80       	push   $0x8010809c
8010350d:	e8 be ce ff ff       	call   801003d0 <panic>
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <picinit>:
80103520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103525:	ba 21 00 00 00       	mov    $0x21,%edx
8010352a:	ee                   	out    %al,(%dx)
8010352b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103530:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103531:	c3                   	ret    
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010354c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010354f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010355b:	e8 20 d9 ff ff       	call   80100e80 <filealloc>
80103560:	89 03                	mov    %eax,(%ebx)
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 a8 00 00 00    	je     80103612 <pipealloc+0xd2>
8010356a:	e8 11 d9 ff ff       	call   80100e80 <filealloc>
8010356f:	89 06                	mov    %eax,(%esi)
80103571:	85 c0                	test   %eax,%eax
80103573:	0f 84 87 00 00 00    	je     80103600 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103579:	e8 02 f2 ff ff       	call   80102780 <kalloc>
8010357e:	89 c7                	mov    %eax,%edi
80103580:	85 c0                	test   %eax,%eax
80103582:	0f 84 b0 00 00 00    	je     80103638 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103588:	c7 80 8c 02 00 00 01 	movl   $0x1,0x28c(%eax)
8010358f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103592:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103595:	c7 80 90 02 00 00 01 	movl   $0x1,0x290(%eax)
8010359c:	00 00 00 
  p->nwrite = 0;
8010359f:	c7 80 88 02 00 00 00 	movl   $0x0,0x288(%eax)
801035a6:	00 00 00 
  p->nread = 0;
801035a9:	c7 80 84 02 00 00 00 	movl   $0x0,0x284(%eax)
801035b0:	00 00 00 
  initlock(&p->lock, "pipe");
801035b3:	68 bb 80 10 80       	push   $0x801080bb
801035b8:	50                   	push   %eax
801035b9:	e8 42 13 00 00       	call   80104900 <initlock>
  (*f0)->type = FD_PIPE;
801035be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035cf:	8b 03                	mov    (%ebx),%eax
801035d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035d5:	8b 03                	mov    (%ebx),%eax
801035d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ee:	8b 06                	mov    (%esi),%eax
801035f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035f6:	31 c0                	xor    %eax,%eax
}
801035f8:	5b                   	pop    %ebx
801035f9:	5e                   	pop    %esi
801035fa:	5f                   	pop    %edi
801035fb:	5d                   	pop    %ebp
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	74 1e                	je     80103624 <pipealloc+0xe4>
    fileclose(*f0);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	50                   	push   %eax
8010360a:	e8 31 d9 ff ff       	call   80100f40 <fileclose>
8010360f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	74 0c                	je     80103624 <pipealloc+0xe4>
    fileclose(*f1);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	50                   	push   %eax
8010361c:	e8 1f d9 ff ff       	call   80100f40 <fileclose>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	85 c0                	test   %eax,%eax
8010363c:	75 c8                	jne    80103606 <pipealloc+0xc6>
8010363e:	eb d2                	jmp    80103612 <pipealloc+0xd2>

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103648:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	53                   	push   %ebx
8010364f:	e8 7c 14 00 00       	call   80104ad0 <acquire>
  if(writable){
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	85 f6                	test   %esi,%esi
80103659:	74 65                	je     801036c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
    p->writeopen = 0;
80103664:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
8010366b:	00 00 00 
    wakeup(&p->nread);
8010366e:	50                   	push   %eax
8010366f:	e8 dc 0b 00 00       	call   80104250 <wakeup>
80103674:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103677:	8b 93 8c 02 00 00    	mov    0x28c(%ebx),%edx
8010367d:	85 d2                	test   %edx,%edx
8010367f:	75 0a                	jne    8010368b <pipeclose+0x4b>
80103681:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80103687:	85 c0                	test   %eax,%eax
80103689:	74 15                	je     801036a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5d                   	pop    %ebp
    release(&p->lock);
80103694:	e9 d7 13 00 00       	jmp    80104a70 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 c7 13 00 00       	call   80104a70 <release>
    kfree((char*)p);
801036a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ac:	83 c4 10             	add    $0x10,%esp
}
801036af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b2:	5b                   	pop    %ebx
801036b3:	5e                   	pop    %esi
801036b4:	5d                   	pop    %ebp
    kfree((char*)p);
801036b5:	e9 06 ef ff ff       	jmp    801025c0 <kfree>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 88 02 00 00    	lea    0x288(%ebx),%eax
    p->readopen = 0;
801036c9:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 77 0b 00 00       	call   80104250 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb 99                	jmp    80103677 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 28             	sub    $0x28,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ec:	53                   	push   %ebx
801036ed:	e8 de 13 00 00       	call   80104ad0 <acquire>
  for(i = 0; i < n; i++){
801036f2:	8b 45 10             	mov    0x10(%ebp),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 8e c3 00 00 00    	jle    801037c3 <pipewrite+0xe3>
80103700:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	8b 8b 88 02 00 00    	mov    0x288(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103709:	8d bb 84 02 00 00    	lea    0x284(%ebx),%edi
8010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103712:	03 45 10             	add    0x10(%ebp),%eax
80103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103718:	8b 83 84 02 00 00    	mov    0x284(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371e:	8d b3 88 02 00 00    	lea    0x288(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103724:	89 ca                	mov    %ecx,%edx
80103726:	05 00 02 00 00       	add    $0x200,%eax
8010372b:	39 c1                	cmp    %eax,%ecx
8010372d:	74 3f                	je     8010376e <pipewrite+0x8e>
8010372f:	eb 67                	jmp    80103798 <pipewrite+0xb8>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 a3 03 00 00       	call   80103ae0 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 03 0b 00 00       	call   80104250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 3a 0a 00 00       	call   80104190 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 84 02 00 00    	mov    0x284(%ebx),%eax
8010375c:	8b 93 88 02 00 00    	mov    0x288(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 8c 02 00 00    	mov    0x28c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 ef 12 00 00       	call   80104a70 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 88 02 00 00    	mov    %ecx,0x288(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	88 84 13 84 00 00 00 	mov    %al,0x84(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037ba:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037bd:	0f 85 55 ff ff ff    	jne    80103718 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c3:	83 ec 0c             	sub    $0xc,%esp
801037c6:	8d 83 84 02 00 00    	lea    0x284(%ebx),%eax
801037cc:	50                   	push   %eax
801037cd:	e8 7e 0a 00 00       	call   80104250 <wakeup>
  release(&p->lock);
801037d2:	89 1c 24             	mov    %ebx,(%esp)
801037d5:	e8 96 12 00 00       	call   80104a70 <release>
  return n;
801037da:	8b 45 10             	mov    0x10(%ebp),%eax
801037dd:	83 c4 10             	add    $0x10,%esp
801037e0:	eb a7                	jmp    80103789 <pipewrite+0xa9>
801037e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 18             	sub    $0x18,%esp
801037f9:	8b 75 08             	mov    0x8(%ebp),%esi
801037fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ff:	56                   	push   %esi
80103800:	8d 9e 84 02 00 00    	lea    0x284(%esi),%ebx
80103806:	e8 c5 12 00 00       	call   80104ad0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010380b:	8b 86 84 02 00 00    	mov    0x284(%esi),%eax
80103811:	83 c4 10             	add    $0x10,%esp
80103814:	39 86 88 02 00 00    	cmp    %eax,0x288(%esi)
8010381a:	74 2f                	je     8010384b <piperead+0x5b>
8010381c:	eb 37                	jmp    80103855 <piperead+0x65>
8010381e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103820:	e8 bb 02 00 00       	call   80103ae0 <myproc>
80103825:	8b 48 24             	mov    0x24(%eax),%ecx
80103828:	85 c9                	test   %ecx,%ecx
8010382a:	0f 85 88 00 00 00    	jne    801038b8 <piperead+0xc8>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103830:	83 ec 08             	sub    $0x8,%esp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	e8 56 09 00 00       	call   80104190 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010383a:	8b 86 88 02 00 00    	mov    0x288(%esi),%eax
80103840:	83 c4 10             	add    $0x10,%esp
80103843:	39 86 84 02 00 00    	cmp    %eax,0x284(%esi)
80103849:	75 0a                	jne    80103855 <piperead+0x65>
8010384b:	8b 86 90 02 00 00    	mov    0x290(%esi),%eax
80103851:	85 c0                	test   %eax,%eax
80103853:	75 cb                	jne    80103820 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103855:	8b 55 10             	mov    0x10(%ebp),%edx
80103858:	31 db                	xor    %ebx,%ebx
8010385a:	85 d2                	test   %edx,%edx
8010385c:	7f 23                	jg     80103881 <piperead+0x91>
8010385e:	eb 2f                	jmp    8010388f <piperead+0x9f>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103860:	8d 48 01             	lea    0x1(%eax),%ecx
80103863:	25 ff 01 00 00       	and    $0x1ff,%eax
80103868:	89 8e 84 02 00 00    	mov    %ecx,0x284(%esi)
8010386e:	0f b6 84 06 84 00 00 	movzbl 0x84(%esi,%eax,1),%eax
80103875:	00 
80103876:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103879:	83 c3 01             	add    $0x1,%ebx
8010387c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010387f:	74 0e                	je     8010388f <piperead+0x9f>
    if(p->nread == p->nwrite)
80103881:	8b 86 84 02 00 00    	mov    0x284(%esi),%eax
80103887:	3b 86 88 02 00 00    	cmp    0x288(%esi),%eax
8010388d:	75 d1                	jne    80103860 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	8d 86 88 02 00 00    	lea    0x288(%esi),%eax
80103898:	50                   	push   %eax
80103899:	e8 b2 09 00 00       	call   80104250 <wakeup>
  release(&p->lock);
8010389e:	89 34 24             	mov    %esi,(%esp)
801038a1:	e8 ca 11 00 00       	call   80104a70 <release>
  return i;
801038a6:	83 c4 10             	add    $0x10,%esp
}
801038a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038ac:	89 d8                	mov    %ebx,%eax
801038ae:	5b                   	pop    %ebx
801038af:	5e                   	pop    %esi
801038b0:	5f                   	pop    %edi
801038b1:	5d                   	pop    %ebp
801038b2:	c3                   	ret    
801038b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b7:	90                   	nop
      release(&p->lock);
801038b8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038c0:	56                   	push   %esi
801038c1:	e8 aa 11 00 00       	call   80104a70 <release>
      return -1;
801038c6:	83 c4 10             	add    $0x10,%esp
}
801038c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038cc:	89 d8                	mov    %ebx,%eax
801038ce:	5b                   	pop    %ebx
801038cf:	5e                   	pop    %esi
801038d0:	5f                   	pop    %edi
801038d1:	5d                   	pop    %ebp
801038d2:	c3                   	ret    
801038d3:	66 90                	xchg   %ax,%ax
801038d5:	66 90                	xchg   %ax,%ax
801038d7:	66 90                	xchg   %ax,%ax
801038d9:	66 90                	xchg   %ax,%ax
801038db:	66 90                	xchg   %ax,%ax
801038dd:	66 90                	xchg   %ax,%ax
801038df:	90                   	nop

801038e0 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	ba 24 49 11 80       	mov    $0x80114924,%edx
801038e5:	eb 14                	jmp    801038fb <wakeup1+0x1b>
801038e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ee:	66 90                	xchg   %ax,%ax
801038f0:	83 ea 80             	sub    $0xffffff80,%edx
801038f3:	81 fa 24 69 11 80    	cmp    $0x80116924,%edx
801038f9:	74 1d                	je     80103918 <wakeup1+0x38>
    if (p->state == SLEEPING && p->chan == chan)
801038fb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801038ff:	75 ef                	jne    801038f0 <wakeup1+0x10>
80103901:	39 42 20             	cmp    %eax,0x20(%edx)
80103904:	75 ea                	jne    801038f0 <wakeup1+0x10>
      p->state = RUNNABLE;
80103906:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010390d:	83 ea 80             	sub    $0xffffff80,%edx
80103910:	81 fa 24 69 11 80    	cmp    $0x80116924,%edx
80103916:	75 e3                	jne    801038fb <wakeup1+0x1b>
}
80103918:	c3                   	ret    
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103920 <allocproc>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103924:	bb 24 49 11 80       	mov    $0x80114924,%ebx
{
80103929:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010392c:	68 a0 48 11 80       	push   $0x801148a0
80103931:	e8 9a 11 00 00       	call   80104ad0 <acquire>
80103936:	83 c4 10             	add    $0x10,%esp
80103939:	eb 10                	jmp    8010394b <allocproc+0x2b>
8010393b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103940:	83 eb 80             	sub    $0xffffff80,%ebx
80103943:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
80103949:	74 75                	je     801039c0 <allocproc+0xa0>
    if (p->state == UNUSED)
8010394b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010394e:	85 c0                	test   %eax,%eax
80103950:	75 ee                	jne    80103940 <allocproc+0x20>
  p->pid = nextpid++;
80103952:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
80103957:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010395a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103961:	89 43 10             	mov    %eax,0x10(%ebx)
80103964:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103967:	68 a0 48 11 80       	push   $0x801148a0
  p->pid = nextpid++;
8010396c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103972:	e8 f9 10 00 00       	call   80104a70 <release>
  if ((p->kstack = kalloc()) == 0)
80103977:	e8 04 ee ff ff       	call   80102780 <kalloc>
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	89 43 08             	mov    %eax,0x8(%ebx)
80103982:	85 c0                	test   %eax,%eax
80103984:	74 53                	je     801039d9 <allocproc+0xb9>
  sp -= sizeof *p->tf;
80103986:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
8010398c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010398f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103994:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103997:	c7 40 14 74 61 10 80 	movl   $0x80106174,0x14(%eax)
  p->context = (struct context *)sp;
8010399e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039a1:	6a 14                	push   $0x14
801039a3:	6a 00                	push   $0x0
801039a5:	50                   	push   %eax
801039a6:	e8 95 13 00 00       	call   80104d40 <memset>
  p->context->eip = (uint)forkret;
801039ab:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801039ae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039b1:	c7 40 10 f0 39 10 80 	movl   $0x801039f0,0x10(%eax)
}
801039b8:	89 d8                	mov    %ebx,%eax
801039ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039bd:	c9                   	leave  
801039be:	c3                   	ret    
801039bf:	90                   	nop
  release(&ptable.lock);
801039c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039c5:	68 a0 48 11 80       	push   $0x801148a0
801039ca:	e8 a1 10 00 00       	call   80104a70 <release>
}
801039cf:	89 d8                	mov    %ebx,%eax
  return 0;
801039d1:	83 c4 10             	add    $0x10,%esp
}
801039d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d7:	c9                   	leave  
801039d8:	c3                   	ret    
    p->state = UNUSED;
801039d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039e0:	31 db                	xor    %ebx,%ebx
}
801039e2:	89 d8                	mov    %ebx,%eax
801039e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e7:	c9                   	leave  
801039e8:	c3                   	ret    
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <forkret>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801039f6:	68 a0 48 11 80       	push   $0x801148a0
801039fb:	e8 70 10 00 00       	call   80104a70 <release>
  if (first)
80103a00:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	75 04                	jne    80103a10 <forkret+0x20>
}
80103a0c:	c9                   	leave  
80103a0d:	c3                   	ret    
80103a0e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a10:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a17:	00 00 00 
    iinit(ROOTDEV);
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	6a 01                	push   $0x1
80103a1f:	e8 9c db ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103a24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a2b:	e8 a0 f3 ff ff       	call   80102dd0 <initlog>
}
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	c9                   	leave  
80103a34:	c3                   	ret    
80103a35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a40 <pinit>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a46:	68 c0 80 10 80       	push   $0x801080c0
80103a4b:	68 a0 48 11 80       	push   $0x801148a0
80103a50:	e8 ab 0e 00 00       	call   80104900 <initlock>
}
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <mycpu>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a65:	9c                   	pushf  
80103a66:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103a67:	f6 c4 02             	test   $0x2,%ah
80103a6a:	75 46                	jne    80103ab2 <mycpu+0x52>
  apicid = lapicid();
80103a6c:	e8 7f ef ff ff       	call   801029f0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103a71:	8b 35 04 43 11 80    	mov    0x80114304,%esi
80103a77:	85 f6                	test   %esi,%esi
80103a79:	7e 2a                	jle    80103aa5 <mycpu+0x45>
80103a7b:	31 d2                	xor    %edx,%edx
80103a7d:	eb 08                	jmp    80103a87 <mycpu+0x27>
80103a7f:	90                   	nop
80103a80:	83 c2 01             	add    $0x1,%edx
80103a83:	39 f2                	cmp    %esi,%edx
80103a85:	74 1e                	je     80103aa5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a87:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a8d:	0f b6 99 20 43 11 80 	movzbl -0x7feebce0(%ecx),%ebx
80103a94:	39 c3                	cmp    %eax,%ebx
80103a96:	75 e8                	jne    80103a80 <mycpu+0x20>
}
80103a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a9b:	8d 81 20 43 11 80    	lea    -0x7feebce0(%ecx),%eax
}
80103aa1:	5b                   	pop    %ebx
80103aa2:	5e                   	pop    %esi
80103aa3:	5d                   	pop    %ebp
80103aa4:	c3                   	ret    
  panic("unknown apicid\n");
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	68 c7 80 10 80       	push   $0x801080c7
80103aad:	e8 1e c9 ff ff       	call   801003d0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	68 e8 81 10 80       	push   $0x801081e8
80103aba:	e8 11 c9 ff ff       	call   801003d0 <panic>
80103abf:	90                   	nop

80103ac0 <cpuid>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103ac6:	e8 95 ff ff ff       	call   80103a60 <mycpu>
}
80103acb:	c9                   	leave  
  return mycpu() - cpus;
80103acc:	2d 20 43 11 80       	sub    $0x80114320,%eax
80103ad1:	c1 f8 04             	sar    $0x4,%eax
80103ad4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ada:	c3                   	ret    
80103adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <myproc>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ae7:	e8 94 0e 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103aec:	e8 6f ff ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103af1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af7:	e8 d4 0e 00 00       	call   801049d0 <popcli>
}
80103afc:	89 d8                	mov    %ebx,%eax
80103afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b01:	c9                   	leave  
80103b02:	c3                   	ret    
80103b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <userinit>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b17:	e8 04 fe ff ff       	call   80103920 <allocproc>
80103b1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b1e:	a3 24 69 11 80       	mov    %eax,0x80116924
  if ((p->pgdir = setupkvm()) == 0)
80103b23:	e8 38 3c 00 00       	call   80107760 <setupkvm>
80103b28:	89 43 04             	mov    %eax,0x4(%ebx)
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	0f 84 bd 00 00 00    	je     80103bf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b33:	83 ec 04             	sub    $0x4,%esp
80103b36:	68 2c 00 00 00       	push   $0x2c
80103b3b:	68 60 b4 10 80       	push   $0x8010b460
80103b40:	50                   	push   %eax
80103b41:	e8 ca 38 00 00       	call   80107410 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b4f:	6a 4c                	push   $0x4c
80103b51:	6a 00                	push   $0x0
80103b53:	ff 73 18             	push   0x18(%ebx)
80103b56:	e8 e5 11 00 00       	call   80104d40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b81:	8b 43 18             	mov    0x18(%ebx),%eax
80103b84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b96:	8b 43 18             	mov    0x18(%ebx),%eax
80103b99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103ba0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103baa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bad:	6a 10                	push   $0x10
80103baf:	68 f0 80 10 80       	push   $0x801080f0
80103bb4:	50                   	push   %eax
80103bb5:	e8 46 13 00 00       	call   80104f00 <safestrcpy>
  p->cwd = namei("/");
80103bba:	c7 04 24 f9 80 10 80 	movl   $0x801080f9,(%esp)
80103bc1:	e8 ca e5 ff ff       	call   80102190 <namei>
80103bc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bc9:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103bd0:	e8 fb 0e 00 00       	call   80104ad0 <acquire>
  p->state = RUNNABLE;
80103bd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bdc:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103be3:	e8 88 0e 00 00       	call   80104a70 <release>
}
80103be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103beb:	83 c4 10             	add    $0x10,%esp
80103bee:	c9                   	leave  
80103bef:	c3                   	ret    
    panic("userinit: out of memory?");
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	68 d7 80 10 80       	push   $0x801080d7
80103bf8:	e8 d3 c7 ff ff       	call   801003d0 <panic>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi

80103c00 <growproc>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c08:	e8 73 0d 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103c0d:	e8 4e fe ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c18:	e8 b3 0d 00 00       	call   801049d0 <popcli>
  sz = curproc->sz;
80103c1d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103c1f:	85 f6                	test   %esi,%esi
80103c21:	7f 1d                	jg     80103c40 <growproc+0x40>
  else if (n < 0)
80103c23:	75 3b                	jne    80103c60 <growproc+0x60>
  switchuvm(curproc);
80103c25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c2a:	53                   	push   %ebx
80103c2b:	e8 d0 36 00 00       	call   80107300 <switchuvm>
  return 0;
80103c30:	83 c4 10             	add    $0x10,%esp
80103c33:	31 c0                	xor    %eax,%eax
}
80103c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c38:	5b                   	pop    %ebx
80103c39:	5e                   	pop    %esi
80103c3a:	5d                   	pop    %ebp
80103c3b:	c3                   	ret    
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	push   0x4(%ebx)
80103c4a:	e8 31 39 00 00       	call   80107580 <allocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 cf                	jne    80103c25 <growproc+0x25>
      return -1;
80103c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5b:	eb d8                	jmp    80103c35 <growproc+0x35>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c60:	83 ec 04             	sub    $0x4,%esp
80103c63:	01 c6                	add    %eax,%esi
80103c65:	56                   	push   %esi
80103c66:	50                   	push   %eax
80103c67:	ff 73 04             	push   0x4(%ebx)
80103c6a:	e8 41 3a 00 00       	call   801076b0 <deallocuvm>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 af                	jne    80103c25 <growproc+0x25>
80103c76:	eb de                	jmp    80103c56 <growproc+0x56>
80103c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <fork>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c89:	e8 f2 0c 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103c8e:	e8 cd fd ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 32 0d 00 00       	call   801049d0 <popcli>
  if ((np = allocproc()) == 0)
80103c9e:	e8 7d fc ff ff       	call   80103920 <allocproc>
80103ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ca6:	85 c0                	test   %eax,%eax
80103ca8:	0f 84 b7 00 00 00    	je     80103d65 <fork+0xe5>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103cae:	83 ec 08             	sub    $0x8,%esp
80103cb1:	ff 33                	push   (%ebx)
80103cb3:	89 c7                	mov    %eax,%edi
80103cb5:	ff 73 04             	push   0x4(%ebx)
80103cb8:	e8 93 3b 00 00       	call   80107850 <copyuvm>
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	89 47 04             	mov    %eax,0x4(%edi)
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	0f 84 a1 00 00 00    	je     80103d6c <fork+0xec>
  np->sz = curproc->sz;
80103ccb:	8b 03                	mov    (%ebx),%eax
80103ccd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cd2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cd5:	89 c8                	mov    %ecx,%eax
80103cd7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cda:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cdf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ce2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103ce4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ce6:	8b 40 18             	mov    0x18(%eax),%eax
80103ce9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103cf0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 13                	je     80103d0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	50                   	push   %eax
80103cfc:	e8 ef d1 ff ff       	call   80100ef0 <filedup>
80103d01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d04:	83 c4 10             	add    $0x10,%esp
80103d07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103d0b:	83 c6 01             	add    $0x1,%esi
80103d0e:	83 fe 10             	cmp    $0x10,%esi
80103d11:	75 dd                	jne    80103cf0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d1c:	e8 9f da ff ff       	call   801017c0 <idup>
80103d21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	53                   	push   %ebx
80103d30:	50                   	push   %eax
80103d31:	e8 ca 11 00 00       	call   80104f00 <safestrcpy>
  pid = np->pid;
80103d36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d39:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103d40:	e8 8b 0d 00 00       	call   80104ad0 <acquire>
  np->state = RUNNABLE;
80103d45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d4c:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103d53:	e8 18 0d 00 00       	call   80104a70 <release>
  return pid;
80103d58:	83 c4 10             	add    $0x10,%esp
}
80103d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d5e:	89 d8                	mov    %ebx,%eax
80103d60:	5b                   	pop    %ebx
80103d61:	5e                   	pop    %esi
80103d62:	5f                   	pop    %edi
80103d63:	5d                   	pop    %ebp
80103d64:	c3                   	ret    
    return -1;
80103d65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d6a:	eb ef                	jmp    80103d5b <fork+0xdb>
    kfree(np->kstack);
80103d6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d6f:	83 ec 0c             	sub    $0xc,%esp
80103d72:	ff 73 08             	push   0x8(%ebx)
80103d75:	e8 46 e8 ff ff       	call   801025c0 <kfree>
    np->kstack = 0;
80103d7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d81:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d84:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d90:	eb c9                	jmp    80103d5b <fork+0xdb>
80103d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <scheduler>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103da9:	e8 b2 fc ff ff       	call   80103a60 <mycpu>
  c->proc = 0;
80103dae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103db5:	00 00 00 
  struct cpu *c = mycpu();
80103db8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dba:	8d 78 04             	lea    0x4(%eax),%edi
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103dc0:	fb                   	sti    
    acquire(&ptable.lock);
80103dc1:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc4:	bb 24 49 11 80       	mov    $0x80114924,%ebx
    acquire(&ptable.lock);
80103dc9:	68 a0 48 11 80       	push   $0x801148a0
80103dce:	e8 fd 0c 00 00       	call   80104ad0 <acquire>
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE)
80103de0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103de4:	75 3a                	jne    80103e20 <scheduler+0x80>
      if(p->PAUSE!=0)
80103de6:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103de9:	85 c9                	test   %ecx,%ecx
80103deb:	75 33                	jne    80103e20 <scheduler+0x80>
      switchuvm(p);
80103ded:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103df0:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103df6:	53                   	push   %ebx
80103df7:	e8 04 35 00 00       	call   80107300 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dfc:	58                   	pop    %eax
80103dfd:	5a                   	pop    %edx
80103dfe:	ff 73 1c             	push   0x1c(%ebx)
80103e01:	57                   	push   %edi
      p->state = RUNNING;
80103e02:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e09:	e8 4d 11 00 00       	call   80104f5b <swtch>
      switchkvm();
80103e0e:	e8 dd 34 00 00       	call   801072f0 <switchkvm>
      c->proc = 0;
80103e13:	83 c4 10             	add    $0x10,%esp
80103e16:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e1d:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e20:	83 eb 80             	sub    $0xffffff80,%ebx
80103e23:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
80103e29:	75 b5                	jne    80103de0 <scheduler+0x40>
    release(&ptable.lock);
80103e2b:	83 ec 0c             	sub    $0xc,%esp
80103e2e:	68 a0 48 11 80       	push   $0x801148a0
80103e33:	e8 38 0c 00 00       	call   80104a70 <release>
    sti();
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	eb 83                	jmp    80103dc0 <scheduler+0x20>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi

80103e40 <sched>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	56                   	push   %esi
80103e44:	53                   	push   %ebx
  pushcli();
80103e45:	e8 36 0b 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103e4a:	e8 11 fc ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103e4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e55:	e8 76 0b 00 00       	call   801049d0 <popcli>
  if (!holding(&ptable.lock))
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 a0 48 11 80       	push   $0x801148a0
80103e62:	e8 c9 0b 00 00       	call   80104a30 <holding>
80103e67:	83 c4 10             	add    $0x10,%esp
80103e6a:	85 c0                	test   %eax,%eax
80103e6c:	74 4f                	je     80103ebd <sched+0x7d>
  if (mycpu()->ncli != 1)
80103e6e:	e8 ed fb ff ff       	call   80103a60 <mycpu>
80103e73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e7a:	75 68                	jne    80103ee4 <sched+0xa4>
  if (p->state == RUNNING)
80103e7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e80:	74 55                	je     80103ed7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e82:	9c                   	pushf  
80103e83:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103e84:	f6 c4 02             	test   $0x2,%ah
80103e87:	75 41                	jne    80103eca <sched+0x8a>
  intena = mycpu()->intena;
80103e89:	e8 d2 fb ff ff       	call   80103a60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e97:	e8 c4 fb ff ff       	call   80103a60 <mycpu>
80103e9c:	83 ec 08             	sub    $0x8,%esp
80103e9f:	ff 70 04             	push   0x4(%eax)
80103ea2:	53                   	push   %ebx
80103ea3:	e8 b3 10 00 00       	call   80104f5b <swtch>
  mycpu()->intena = intena;
80103ea8:	e8 b3 fb ff ff       	call   80103a60 <mycpu>
}
80103ead:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103eb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eb9:	5b                   	pop    %ebx
80103eba:	5e                   	pop    %esi
80103ebb:	5d                   	pop    %ebp
80103ebc:	c3                   	ret    
    panic("sched ptable.lock");
80103ebd:	83 ec 0c             	sub    $0xc,%esp
80103ec0:	68 fb 80 10 80       	push   $0x801080fb
80103ec5:	e8 06 c5 ff ff       	call   801003d0 <panic>
    panic("sched interruptible");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 27 81 10 80       	push   $0x80108127
80103ed2:	e8 f9 c4 ff ff       	call   801003d0 <panic>
    panic("sched running");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 19 81 10 80       	push   $0x80108119
80103edf:	e8 ec c4 ff ff       	call   801003d0 <panic>
    panic("sched locks");
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	68 0d 81 10 80       	push   $0x8010810d
80103eec:	e8 df c4 ff ff       	call   801003d0 <panic>
80103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eff:	90                   	nop

80103f00 <exit>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f09:	e8 d2 fb ff ff       	call   80103ae0 <myproc>
  if (curproc == initproc)
80103f0e:	39 05 24 69 11 80    	cmp    %eax,0x80116924
80103f14:	0f 84 e7 00 00 00    	je     80104001 <exit+0x101>
80103f1a:	89 c3                	mov    %eax,%ebx
80103f1c:	8d 70 28             	lea    0x28(%eax),%esi
80103f1f:	8d 78 68             	lea    0x68(%eax),%edi
80103f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80103f28:	8b 06                	mov    (%esi),%eax
80103f2a:	85 c0                	test   %eax,%eax
80103f2c:	74 12                	je     80103f40 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f2e:	83 ec 0c             	sub    $0xc,%esp
80103f31:	50                   	push   %eax
80103f32:	e8 09 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103f37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f3d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80103f40:	83 c6 04             	add    $0x4,%esi
80103f43:	39 fe                	cmp    %edi,%esi
80103f45:	75 e1                	jne    80103f28 <exit+0x28>
  begin_op();
80103f47:	e8 24 ef ff ff       	call   80102e70 <begin_op>
  iput(curproc->cwd);
80103f4c:	83 ec 0c             	sub    $0xc,%esp
80103f4f:	ff 73 68             	push   0x68(%ebx)
80103f52:	e8 d9 d9 ff ff       	call   80101930 <iput>
  end_op();
80103f57:	e8 84 ef ff ff       	call   80102ee0 <end_op>
  curproc->cwd = 0;
80103f5c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f63:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103f6a:	e8 61 0b 00 00       	call   80104ad0 <acquire>
   wakeup1(curproc->parent);
80103f6f:	8b 43 14             	mov    0x14(%ebx),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f72:	b9 24 49 11 80       	mov    $0x80114924,%ecx
   wakeup1(curproc->parent);
80103f77:	e8 64 f9 ff ff       	call   801038e0 <wakeup1>
80103f7c:	83 c4 10             	add    $0x10,%esp
80103f7f:	eb 12                	jmp    80103f93 <exit+0x93>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f88:	83 e9 80             	sub    $0xffffff80,%ecx
80103f8b:	81 f9 24 69 11 80    	cmp    $0x80116924,%ecx
80103f91:	74 55                	je     80103fe8 <exit+0xe8>
    if (p->parent == curproc)
80103f93:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103f96:	75 f0                	jne    80103f88 <exit+0x88>
      nproc->parent->killed=1;
80103f98:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      while(nproc->parent->killed!=0){
80103f9f:	8b 51 14             	mov    0x14(%ecx),%edx
80103fa2:	8b 7a 24             	mov    0x24(%edx),%edi
80103fa5:	85 ff                	test   %edi,%edi
80103fa7:	74 20                	je     80103fc9 <exit+0xc9>
80103fa9:	89 c8                	mov    %ecx,%eax
80103fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop
        nproc->parent=nproc->parent->parent;
80103fb0:	8b 52 14             	mov    0x14(%edx),%edx
        nproc--;
80103fb3:	83 c0 80             	add    $0xffffff80,%eax
        nproc->parent=nproc->parent->parent;
80103fb6:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        p->parent=nproc->parent;
80103fbc:	89 51 14             	mov    %edx,0x14(%ecx)
      while(nproc->parent->killed!=0){
80103fbf:	8b 50 14             	mov    0x14(%eax),%edx
80103fc2:	8b 72 24             	mov    0x24(%edx),%esi
80103fc5:	85 f6                	test   %esi,%esi
80103fc7:	75 e7                	jne    80103fb0 <exit+0xb0>
      if (p->state == ZOMBIE)
80103fc9:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
80103fcd:	75 b9                	jne    80103f88 <exit+0x88>
        wakeup1(initproc);
80103fcf:	a1 24 69 11 80       	mov    0x80116924,%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd4:	83 e9 80             	sub    $0xffffff80,%ecx
        wakeup1(initproc);
80103fd7:	e8 04 f9 ff ff       	call   801038e0 <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	81 f9 24 69 11 80    	cmp    $0x80116924,%ecx
80103fe2:	75 af                	jne    80103f93 <exit+0x93>
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80103fe8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fef:	e8 4c fe ff ff       	call   80103e40 <sched>
  panic("zombie exit");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 48 81 10 80       	push   $0x80108148
80103ffc:	e8 cf c3 ff ff       	call   801003d0 <panic>
    panic("init exiting");
80104001:	83 ec 0c             	sub    $0xc,%esp
80104004:	68 3b 81 10 80       	push   $0x8010813b
80104009:	e8 c2 c3 ff ff       	call   801003d0 <panic>
8010400e:	66 90                	xchg   %ax,%ax

80104010 <wait>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  pushcli();
80104015:	e8 66 09 00 00       	call   80104980 <pushcli>
  c = mycpu();
8010401a:	e8 41 fa ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010401f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104025:	e8 a6 09 00 00       	call   801049d0 <popcli>
  acquire(&ptable.lock);
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 a0 48 11 80       	push   $0x801148a0
80104032:	e8 99 0a 00 00       	call   80104ad0 <acquire>
80104037:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010403a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	bb 24 49 11 80       	mov    $0x80114924,%ebx
80104041:	eb 10                	jmp    80104053 <wait+0x43>
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
80104048:	83 eb 80             	sub    $0xffffff80,%ebx
8010404b:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
80104051:	74 1b                	je     8010406e <wait+0x5e>
      if (p->parent != curproc)
80104053:	39 73 14             	cmp    %esi,0x14(%ebx)
80104056:	75 f0                	jne    80104048 <wait+0x38>
      if (p->state == ZOMBIE)
80104058:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010405c:	74 62                	je     801040c0 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010405e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104061:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104066:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
8010406c:	75 e5                	jne    80104053 <wait+0x43>
    if (!havekids || curproc->killed)
8010406e:	85 c0                	test   %eax,%eax
80104070:	0f 84 a0 00 00 00    	je     80104116 <wait+0x106>
80104076:	8b 46 24             	mov    0x24(%esi),%eax
80104079:	85 c0                	test   %eax,%eax
8010407b:	0f 85 95 00 00 00    	jne    80104116 <wait+0x106>
  pushcli();
80104081:	e8 fa 08 00 00       	call   80104980 <pushcli>
  c = mycpu();
80104086:	e8 d5 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010408b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104091:	e8 3a 09 00 00       	call   801049d0 <popcli>
  if (p == 0)
80104096:	85 db                	test   %ebx,%ebx
80104098:	0f 84 8f 00 00 00    	je     8010412d <wait+0x11d>
  p->chan = chan;
8010409e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a8:	e8 93 fd ff ff       	call   80103e40 <sched>
  p->chan = 0;
801040ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040b4:	eb 84                	jmp    8010403a <wait+0x2a>
801040b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c6:	ff 73 08             	push   0x8(%ebx)
801040c9:	e8 f2 e4 ff ff       	call   801025c0 <kfree>
        p->kstack = 0;
801040ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040d5:	5a                   	pop    %edx
801040d6:	ff 73 04             	push   0x4(%ebx)
801040d9:	e8 02 36 00 00       	call   801076e0 <freevm>
        p->pid = 0;
801040de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040fe:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80104105:	e8 66 09 00 00       	call   80104a70 <release>
        return pid;
8010410a:	83 c4 10             	add    $0x10,%esp
}
8010410d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104110:	89 f0                	mov    %esi,%eax
80104112:	5b                   	pop    %ebx
80104113:	5e                   	pop    %esi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret    
      release(&ptable.lock);
80104116:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104119:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010411e:	68 a0 48 11 80       	push   $0x801148a0
80104123:	e8 48 09 00 00       	call   80104a70 <release>
      return -1;
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	eb e0                	jmp    8010410d <wait+0xfd>
    panic("sleep");
8010412d:	83 ec 0c             	sub    $0xc,%esp
80104130:	68 54 81 10 80       	push   $0x80108154
80104135:	e8 96 c2 ff ff       	call   801003d0 <panic>
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <yield>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104147:	68 a0 48 11 80       	push   $0x801148a0
8010414c:	e8 7f 09 00 00       	call   80104ad0 <acquire>
  pushcli();
80104151:	e8 2a 08 00 00       	call   80104980 <pushcli>
  c = mycpu();
80104156:	e8 05 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 6a 08 00 00       	call   801049d0 <popcli>
  myproc()->state = RUNNABLE;
80104166:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010416d:	e8 ce fc ff ff       	call   80103e40 <sched>
  release(&ptable.lock);
80104172:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80104179:	e8 f2 08 00 00       	call   80104a70 <release>
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	c9                   	leave  
80104185:	c3                   	ret    
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <sleep>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	8b 7d 08             	mov    0x8(%ebp),%edi
8010419c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010419f:	e8 dc 07 00 00       	call   80104980 <pushcli>
  c = mycpu();
801041a4:	e8 b7 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801041a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041af:	e8 1c 08 00 00       	call   801049d0 <popcli>
  if (p == 0)
801041b4:	85 db                	test   %ebx,%ebx
801041b6:	0f 84 87 00 00 00    	je     80104243 <sleep+0xb3>
  if (lk == 0)
801041bc:	85 f6                	test   %esi,%esi
801041be:	74 76                	je     80104236 <sleep+0xa6>
  if (lk != &ptable.lock)
801041c0:	81 fe a0 48 11 80    	cmp    $0x801148a0,%esi
801041c6:	74 50                	je     80104218 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 a0 48 11 80       	push   $0x801148a0
801041d0:	e8 fb 08 00 00       	call   80104ad0 <acquire>
    release(lk);
801041d5:	89 34 24             	mov    %esi,(%esp)
801041d8:	e8 93 08 00 00       	call   80104a70 <release>
  p->chan = chan;
801041dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041e7:	e8 54 fc ff ff       	call   80103e40 <sched>
  p->chan = 0;
801041ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041f3:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801041fa:	e8 71 08 00 00       	call   80104a70 <release>
    acquire(lk);
801041ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104202:	83 c4 10             	add    $0x10,%esp
}
80104205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104208:	5b                   	pop    %ebx
80104209:	5e                   	pop    %esi
8010420a:	5f                   	pop    %edi
8010420b:	5d                   	pop    %ebp
    acquire(lk);
8010420c:	e9 bf 08 00 00       	jmp    80104ad0 <acquire>
80104211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104218:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010421b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104222:	e8 19 fc ff ff       	call   80103e40 <sched>
  p->chan = 0;
80104227:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010422e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104231:	5b                   	pop    %ebx
80104232:	5e                   	pop    %esi
80104233:	5f                   	pop    %edi
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    
    panic("sleep without lk");
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	68 5a 81 10 80       	push   $0x8010815a
8010423e:	e8 8d c1 ff ff       	call   801003d0 <panic>
    panic("sleep");
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	68 54 81 10 80       	push   $0x80108154
8010424b:	e8 80 c1 ff ff       	call   801003d0 <panic>

80104250 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010425a:	68 a0 48 11 80       	push   $0x801148a0
8010425f:	e8 6c 08 00 00       	call   80104ad0 <acquire>
80104264:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104267:	b8 24 49 11 80       	mov    $0x80114924,%eax
8010426c:	eb 0c                	jmp    8010427a <wakeup+0x2a>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	83 e8 80             	sub    $0xffffff80,%eax
80104273:	3d 24 69 11 80       	cmp    $0x80116924,%eax
80104278:	74 1c                	je     80104296 <wakeup+0x46>
    if (p->state == SLEEPING && p->chan == chan)
8010427a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010427e:	75 f0                	jne    80104270 <wakeup+0x20>
80104280:	3b 58 20             	cmp    0x20(%eax),%ebx
80104283:	75 eb                	jne    80104270 <wakeup+0x20>
      p->state = RUNNABLE;
80104285:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010428c:	83 e8 80             	sub    $0xffffff80,%eax
8010428f:	3d 24 69 11 80       	cmp    $0x80116924,%eax
80104294:	75 e4                	jne    8010427a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104296:	c7 45 08 a0 48 11 80 	movl   $0x801148a0,0x8(%ebp)
}
8010429d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042a0:	c9                   	leave  
  release(&ptable.lock);
801042a1:	e9 ca 07 00 00       	jmp    80104a70 <release>
801042a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

801042b0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 10             	sub    $0x10,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ba:	68 a0 48 11 80       	push   $0x801148a0
801042bf:	e8 0c 08 00 00       	call   80104ad0 <acquire>
801042c4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c7:	b8 24 49 11 80       	mov    $0x80114924,%eax
801042cc:	eb 0c                	jmp    801042da <kill+0x2a>
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	83 e8 80             	sub    $0xffffff80,%eax
801042d3:	3d 24 69 11 80       	cmp    $0x80116924,%eax
801042d8:	74 36                	je     80104310 <kill+0x60>
  {
    if (p->pid == pid)
801042da:	39 58 10             	cmp    %ebx,0x10(%eax)
801042dd:	75 f1                	jne    801042d0 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
801042df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
801042ea:	75 07                	jne    801042f3 <kill+0x43>
        p->state = RUNNABLE;
801042ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 a0 48 11 80       	push   $0x801148a0
801042fb:	e8 70 07 00 00       	call   80104a70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104303:	83 c4 10             	add    $0x10,%esp
80104306:	31 c0                	xor    %eax,%eax
}
80104308:	c9                   	leave  
80104309:	c3                   	ret    
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 a0 48 11 80       	push   $0x801148a0
80104318:	e8 53 07 00 00       	call   80104a70 <release>
}
8010431d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104328:	c9                   	leave  
80104329:	c3                   	ret    
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104338:	53                   	push   %ebx
80104339:	bb 90 49 11 80       	mov    $0x80114990,%ebx
8010433e:	83 ec 3c             	sub    $0x3c,%esp
80104341:	eb 24                	jmp    80104367 <procdump+0x37>
80104343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104347:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	68 f7 85 10 80       	push   $0x801085f7
80104350:	e8 9b c3 ff ff       	call   801006f0 <cprintf>
80104355:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104358:	83 eb 80             	sub    $0xffffff80,%ebx
8010435b:	81 fb 90 69 11 80    	cmp    $0x80116990,%ebx
80104361:	0f 84 81 00 00 00    	je     801043e8 <procdump+0xb8>
    if (p->state == UNUSED)
80104367:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	74 ea                	je     80104358 <procdump+0x28>
      state = "???";
8010436e:	ba 6b 81 10 80       	mov    $0x8010816b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104373:	83 f8 05             	cmp    $0x5,%eax
80104376:	77 11                	ja     80104389 <procdump+0x59>
80104378:	8b 14 85 10 82 10 80 	mov    -0x7fef7df0(,%eax,4),%edx
      state = "???";
8010437f:	b8 6b 81 10 80       	mov    $0x8010816b,%eax
80104384:	85 d2                	test   %edx,%edx
80104386:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104389:	53                   	push   %ebx
8010438a:	52                   	push   %edx
8010438b:	ff 73 a4             	push   -0x5c(%ebx)
8010438e:	68 6f 81 10 80       	push   $0x8010816f
80104393:	e8 58 c3 ff ff       	call   801006f0 <cprintf>
    if (p->state == SLEEPING)
80104398:	83 c4 10             	add    $0x10,%esp
8010439b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010439f:	75 a7                	jne    80104348 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801043a1:	83 ec 08             	sub    $0x8,%esp
801043a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043aa:	50                   	push   %eax
801043ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043ae:	8b 40 0c             	mov    0xc(%eax),%eax
801043b1:	83 c0 08             	add    $0x8,%eax
801043b4:	50                   	push   %eax
801043b5:	e8 66 05 00 00       	call   80104920 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801043ba:	83 c4 10             	add    $0x10,%esp
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
801043c0:	8b 17                	mov    (%edi),%edx
801043c2:	85 d2                	test   %edx,%edx
801043c4:	74 82                	je     80104348 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043c6:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
801043c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043cc:	52                   	push   %edx
801043cd:	68 c1 7b 10 80       	push   $0x80107bc1
801043d2:	e8 19 c3 ff ff       	call   801006f0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	39 fe                	cmp    %edi,%esi
801043dc:	75 e2                	jne    801043c0 <procdump+0x90>
801043de:	e9 65 ff ff ff       	jmp    80104348 <procdump+0x18>
801043e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e7:	90                   	nop
  }
}
801043e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043eb:	5b                   	pop    %ebx
801043ec:	5e                   	pop    %esi
801043ed:	5f                   	pop    %edi
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <getppid>:

int getppid()
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
  struct proc *p;
  // p=ptable.proc;
  // int pid=myproc()->pid;
  // cprintf("\ncurrent process pid is %d\n",pid);
  // p=
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f6:	bb 24 49 11 80       	mov    $0x80114924,%ebx
{
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	eb 0b                	jmp    8010440b <getppid+0x1b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104400:	83 eb 80             	sub    $0xffffff80,%ebx
80104403:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
80104409:	74 35                	je     80104440 <getppid+0x50>
  {
    if (p->parent->pid == myproc()->parent->pid)
8010440b:	8b 43 14             	mov    0x14(%ebx),%eax
8010440e:	8b 70 10             	mov    0x10(%eax),%esi
  pushcli();
80104411:	e8 6a 05 00 00       	call   80104980 <pushcli>
  c = mycpu();
80104416:	e8 45 f6 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010441b:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104421:	e8 aa 05 00 00       	call   801049d0 <popcli>
    if (p->parent->pid == myproc()->parent->pid)
80104426:	8b 47 14             	mov    0x14(%edi),%eax
80104429:	3b 70 10             	cmp    0x10(%eax),%esi
8010442c:	75 d2                	jne    80104400 <getppid+0x10>
    {
      ppid = p->parent->pid;
8010442e:	8b 43 14             	mov    0x14(%ebx),%eax
80104431:	8b 40 10             	mov    0x10(%eax),%eax
      return ppid;
    }
  }
  return -1;
}
80104434:	83 c4 0c             	add    $0xc,%esp
80104437:	5b                   	pop    %ebx
80104438:	5e                   	pop    %esi
80104439:	5f                   	pop    %edi
8010443a:	5d                   	pop    %ebp
8010443b:	c3                   	ret    
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104440:	83 c4 0c             	add    $0xc,%esp
  return -1;
80104443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104448:	5b                   	pop    %ebx
80104449:	5e                   	pop    %esi
8010444a:	5f                   	pop    %edi
8010444b:	5d                   	pop    %ebp
8010444c:	c3                   	ret    
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <get_siblings_info>:

// static struct proc *
int get_siblings_info(int pid)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	56                   	push   %esi
80104455:	53                   	push   %ebx
80104456:	83 ec 28             	sub    $0x28,%esp
  // cprintf("in proc %d\n",pid);
  struct proc *p;
  // enum procstate;
  // struct proc *curproc = myproc();
  acquire(&ptable.lock);
80104459:	68 a0 48 11 80       	push   $0x801148a0
8010445e:	e8 6d 06 00 00       	call   80104ad0 <acquire>
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104463:	c7 45 e4 24 49 11 80 	movl   $0x80114924,-0x1c(%ebp)
  acquire(&ptable.lock);
8010446a:	83 c4 10             	add    $0x10,%esp
8010446d:	eb 13                	jmp    80104482 <get_siblings_info+0x32>
8010446f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104470:	83 6d e4 80          	subl   $0xffffff80,-0x1c(%ebp)
80104474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104477:	3d 24 69 11 80       	cmp    $0x80116924,%eax
8010447c:	0f 84 a5 00 00 00    	je     80104527 <get_siblings_info+0xd7>
  {
    if (p->parent->pid == pid)
80104482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104485:	8b 55 08             	mov    0x8(%ebp),%edx
80104488:	8b 40 14             	mov    0x14(%eax),%eax
8010448b:	39 50 10             	cmp    %edx,0x10(%eax)
8010448e:	75 e0                	jne    80104470 <get_siblings_info+0x20>
    {
      cprintf("%d %s\n", p->pid, states[p->state]);
80104490:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104493:	83 ec 04             	sub    $0x4,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104496:	bb 24 49 11 80       	mov    $0x80114924,%ebx
      cprintf("%d %s\n", p->pid, states[p->state]);
8010449b:	8b 46 0c             	mov    0xc(%esi),%eax
8010449e:	ff 34 85 10 82 10 80 	push   -0x7fef7df0(,%eax,4)
801044a5:	ff 76 10             	push   0x10(%esi)
801044a8:	68 78 81 10 80       	push   $0x80108178
801044ad:	e8 3e c2 ff ff       	call   801006f0 <cprintf>
      cprintf("ppid here%d\n", p->parent->pid);
801044b2:	58                   	pop    %eax
801044b3:	8b 46 14             	mov    0x14(%esi),%eax
801044b6:	5a                   	pop    %edx
801044b7:	ff 70 10             	push   0x10(%eax)
801044ba:	68 7f 81 10 80       	push   $0x8010817f
801044bf:	e8 2c c2 ff ff       	call   801006f0 <cprintf>
801044c4:	83 c4 10             	add    $0x10,%esp
801044c7:	eb 12                	jmp    801044db <get_siblings_info+0x8b>
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d0:	83 eb 80             	sub    $0xffffff80,%ebx
801044d3:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
801044d9:	74 65                	je     80104540 <get_siblings_info+0xf0>
    if (p->parent->pid == myproc()->parent->pid)
801044db:	8b 43 14             	mov    0x14(%ebx),%eax
801044de:	8b 78 10             	mov    0x10(%eax),%edi
  pushcli();
801044e1:	e8 9a 04 00 00       	call   80104980 <pushcli>
  c = mycpu();
801044e6:	e8 75 f5 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801044eb:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044f1:	e8 da 04 00 00       	call   801049d0 <popcli>
    if (p->parent->pid == myproc()->parent->pid)
801044f6:	8b 46 14             	mov    0x14(%esi),%eax
801044f9:	3b 78 10             	cmp    0x10(%eax),%edi
801044fc:	75 d2                	jne    801044d0 <get_siblings_info+0x80>
      ppid = p->parent->pid;
801044fe:	8b 43 14             	mov    0x14(%ebx),%eax
80104501:	8b 40 10             	mov    0x10(%eax),%eax
      cprintf("ppid func%d\n", getppid());
80104504:	83 ec 08             	sub    $0x8,%esp
80104507:	50                   	push   %eax
80104508:	68 8c 81 10 80       	push   $0x8010818c
8010450d:	e8 de c1 ff ff       	call   801006f0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104512:	83 6d e4 80          	subl   $0xffffff80,-0x1c(%ebp)
80104516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      cprintf("ppid func%d\n", getppid());
80104519:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010451c:	3d 24 69 11 80       	cmp    $0x80116924,%eax
80104521:	0f 85 5b ff ff ff    	jne    80104482 <get_siblings_info+0x32>
    // cprintf("%s\n", curproc->state);
    // cprintf("state is: %s\n", p->state);
  }

  // cprintf("this is the state%s\n",procstate[p->state]);
  release(&ptable.lock);
80104527:	83 ec 0c             	sub    $0xc,%esp
8010452a:	68 a0 48 11 80       	push   $0x801148a0
8010452f:	e8 3c 05 00 00       	call   80104a70 <release>
  return 0;
}
80104534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104537:	31 c0                	xor    %eax,%eax
80104539:	5b                   	pop    %ebx
8010453a:	5e                   	pop    %esi
8010453b:	5f                   	pop    %edi
8010453c:	5d                   	pop    %ebp
8010453d:	c3                   	ret    
8010453e:	66 90                	xchg   %ax,%ax
  return -1;
80104540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104545:	eb bd                	jmp    80104504 <get_siblings_info+0xb4>
80104547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454e:	66 90                	xchg   %ax,%ax

80104550 <compare>:

//program to compare two strings
int compare(char a[],char b[])  
{  
80104550:	55                   	push   %ebp
80104551:	31 c0                	xor    %eax,%eax
80104553:	89 e5                	mov    %esp,%ebp
80104555:	56                   	push   %esi
80104556:	53                   	push   %ebx
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010455a:	8b 75 0c             	mov    0xc(%ebp),%esi
    int flag=0,i=0;  // integer variables declaration  
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
8010455d:	0f b6 13             	movzbl (%ebx),%edx
80104560:	84 d2                	test   %dl,%dl
80104562:	75 1b                	jne    8010457f <compare+0x2f>
80104564:	eb 21                	jmp    80104587 <compare+0x37>
80104566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    {  
       if(a[i]!=b[i])  
80104570:	38 d1                	cmp    %dl,%cl
80104572:	75 1c                	jne    80104590 <compare+0x40>
       {  
           flag=1;  
           break;  
       }  
       i++;  
80104574:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104577:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
8010457b:	84 d2                	test   %dl,%dl
8010457d:	74 08                	je     80104587 <compare+0x37>
8010457f:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104583:	84 c9                	test   %cl,%cl
80104585:	75 e9                	jne    80104570 <compare+0x20>
    }  
    if(flag==0)  
    return 1;  
    else  
    return 0;  
}  
80104587:	5b                   	pop    %ebx
    return 1;  
80104588:	b8 01 00 00 00       	mov    $0x1,%eax
}  
8010458d:	5e                   	pop    %esi
8010458e:	5d                   	pop    %ebp
8010458f:	c3                   	ret    
80104590:	5b                   	pop    %ebx
    return 0;  
80104591:	31 c0                	xor    %eax,%eax
}  
80104593:	5e                   	pop    %esi
80104594:	5d                   	pop    %ebp
80104595:	c3                   	ret    
80104596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459d:	8d 76 00             	lea    0x0(%esi),%esi

801045a0 <signalProcess>:

void signalProcess(int pid, char type[]){
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
  // cprintf("%d\n%d\n",pid,myproc()->pid);

  struct proc *p;
  acquire(&ptable.lock);
  // char type1=type[0];
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
801045a5:	be 24 49 11 80       	mov    $0x80114924,%esi
void signalProcess(int pid, char type[]){
801045aa:	53                   	push   %ebx
801045ab:	83 ec 28             	sub    $0x28,%esp
801045ae:	8b 45 08             	mov    0x8(%ebp),%eax
801045b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  acquire(&ptable.lock);
801045b4:	68 a0 48 11 80       	push   $0x801148a0
void signalProcess(int pid, char type[]){
801045b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
801045bc:	e8 0f 05 00 00       	call   80104ad0 <acquire>
801045c1:	83 c4 10             	add    $0x10,%esp
801045c4:	eb 15                	jmp    801045db <signalProcess+0x3b>
801045c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
801045d0:	83 ee 80             	sub    $0xffffff80,%esi
801045d3:	81 fe 24 69 11 80    	cmp    $0x80116924,%esi
801045d9:	74 56                	je     80104631 <signalProcess+0x91>
    if(pid==p->pid){
801045db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801045de:	39 46 10             	cmp    %eax,0x10(%esi)
801045e1:	75 ed                	jne    801045d0 <signalProcess+0x30>
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801045e3:	0f b6 13             	movzbl (%ebx),%edx
801045e6:	84 d2                	test   %dl,%dl
801045e8:	74 30                	je     8010461a <signalProcess+0x7a>
801045ea:	89 d1                	mov    %edx,%ecx
801045ec:	bf 50 00 00 00       	mov    $0x50,%edi
801045f1:	88 55 e3             	mov    %dl,-0x1d(%ebp)
    int flag=0,i=0;  // integer variables declaration  
801045f4:	31 c0                	xor    %eax,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801045f6:	89 fa                	mov    %edi,%edx
801045f8:	89 cf                	mov    %ecx,%edi
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       if(a[i]!=b[i])  
80104600:	38 ca                	cmp    %cl,%dl
80104602:	75 44                	jne    80104648 <signalProcess+0xa8>
       i++;  
80104604:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104607:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
8010460b:	84 c9                	test   %cl,%cl
8010460d:	74 0b                	je     8010461a <signalProcess+0x7a>
8010460f:	0f b6 90 99 81 10 80 	movzbl -0x7fef7e67(%eax),%edx
80104616:	84 d2                	test   %dl,%dl
80104618:	75 e6                	jne    80104600 <signalProcess+0x60>
      // p->state=type1;
      if(compare(type,"PAUSE")){
        cprintf("pause");
8010461a:	83 ec 0c             	sub    $0xc,%esp
8010461d:	68 b6 81 10 80       	push   $0x801081b6
80104622:	e8 c9 c0 ff ff       	call   801006f0 <cprintf>
        p->PAUSE=1;
80104627:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
        break;
8010462e:	83 c4 10             	add    $0x10,%esp
        break;
      }

    }
  }
  release(&ptable.lock);
80104631:	c7 45 08 a0 48 11 80 	movl   $0x801148a0,0x8(%ebp)
  // sched();
}
80104638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010463b:	5b                   	pop    %ebx
8010463c:	5e                   	pop    %esi
8010463d:	5f                   	pop    %edi
8010463e:	5d                   	pop    %ebp
  release(&ptable.lock);
8010463f:	e9 2c 04 00 00       	jmp    80104a70 <release>
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104648:	89 fa                	mov    %edi,%edx
8010464a:	89 f9                	mov    %edi,%ecx
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
8010464c:	bf 43 00 00 00       	mov    $0x43,%edi
80104651:	31 c0                	xor    %eax,%eax
80104653:	88 55 e3             	mov    %dl,-0x1d(%ebp)
80104656:	89 fa                	mov    %edi,%edx
80104658:	89 cf                	mov    %ecx,%edi
8010465a:	eb 0f                	jmp    8010466b <signalProcess+0xcb>
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	0f b6 90 9f 81 10 80 	movzbl -0x7fef7e61(%eax),%edx
80104667:	84 d2                	test   %dl,%dl
80104669:	74 0f                	je     8010467a <signalProcess+0xda>
       if(a[i]!=b[i])  
8010466b:	38 ca                	cmp    %cl,%dl
8010466d:	75 29                	jne    80104698 <signalProcess+0xf8>
       i++;  
8010466f:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104672:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
80104676:	84 c9                	test   %cl,%cl
80104678:	75 e6                	jne    80104660 <signalProcess+0xc0>
        cprintf("continue");
8010467a:	83 ec 0c             	sub    $0xc,%esp
8010467d:	68 ad 81 10 80       	push   $0x801081ad
80104682:	e8 69 c0 ff ff       	call   801006f0 <cprintf>
        p->PAUSE=0;
80104687:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
        break;
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	eb 9e                	jmp    80104631 <signalProcess+0x91>
80104693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104697:	90                   	nop
80104698:	89 fa                	mov    %edi,%edx
8010469a:	31 c0                	xor    %eax,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
8010469c:	b9 4b 00 00 00       	mov    $0x4b,%ecx
801046a1:	eb 10                	jmp    801046b3 <signalProcess+0x113>
801046a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a7:	90                   	nop
801046a8:	0f b6 88 a8 81 10 80 	movzbl -0x7fef7e58(%eax),%ecx
801046af:	84 c9                	test   %cl,%cl
801046b1:	74 13                	je     801046c6 <signalProcess+0x126>
       if(a[i]!=b[i])  
801046b3:	38 d1                	cmp    %dl,%cl
801046b5:	0f 85 15 ff ff ff    	jne    801045d0 <signalProcess+0x30>
       i++;  
801046bb:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801046be:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
801046c2:	84 d2                	test   %dl,%dl
801046c4:	75 e2                	jne    801046a8 <signalProcess+0x108>
        p->state=ZOMBIE;
801046c6:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
        break;
801046cd:	e9 5f ff ff ff       	jmp    80104631 <signalProcess+0x91>
801046d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046e0 <numvp>:

int numvp(){
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801046e7:	e8 94 02 00 00       	call   80104980 <pushcli>
  c = mycpu();
801046ec:	e8 6f f3 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801046f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046f7:	e8 d4 02 00 00       	call   801049d0 <popcli>
  int x = myproc()->sz/PGSIZE;
801046fc:	8b 03                	mov    (%ebx),%eax
  // return retNumvp();
  return x;
}
801046fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104701:	c9                   	leave  
  int x = myproc()->sz/PGSIZE;
80104702:	c1 e8 0c             	shr    $0xc,%eax
}
80104705:	c3                   	ret    
80104706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470d:	8d 76 00             	lea    0x0(%esi),%esi

80104710 <numpp>:

int numpp(){
  return retNumpp();
80104710:	e9 8b 33 00 00       	jmp    80107aa0 <retNumpp>
80104715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <init_mylock>:
}

int init_mylock(){
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 14             	sub    $0x14,%esp
  return init_mylockLC(&ptable.lock);
80104726:	68 a0 48 11 80       	push   $0x801148a0
8010472b:	e8 60 04 00 00       	call   80104b90 <init_mylockLC>
  // return 0;
}
80104730:	c9                   	leave  
80104731:	c3                   	ret    
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104740 <acquire_mylock>:

int acquire_mylock(int id){
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80104746:	8d 45 08             	lea    0x8(%ebp),%eax
80104749:	50                   	push   %eax
8010474a:	6a 00                	push   $0x0
8010474c:	e8 af 08 00 00       	call   80105000 <argint>
  // return id;
  return acquire_mylockLC(&ptable.lock, id);
80104751:	58                   	pop    %eax
80104752:	5a                   	pop    %edx
80104753:	ff 75 08             	push   0x8(%ebp)
80104756:	68 a0 48 11 80       	push   $0x801148a0
8010475b:	e8 60 04 00 00       	call   80104bc0 <acquire_mylockLC>
  // acquire(&ptable.lock);
return 0;
}
80104760:	c9                   	leave  
80104761:	c3                   	ret    
80104762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104770 <release_mylock>:

int release_mylock(int id){
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80104776:	8d 45 08             	lea    0x8(%ebp),%eax
80104779:	50                   	push   %eax
8010477a:	6a 00                	push   $0x0
8010477c:	e8 7f 08 00 00       	call   80105000 <argint>
  return release_mylockLC(&ptable.lock, id);
80104781:	58                   	pop    %eax
80104782:	5a                   	pop    %edx
80104783:	ff 75 08             	push   0x8(%ebp)
80104786:	68 a0 48 11 80       	push   $0x801148a0
8010478b:	e8 20 05 00 00       	call   80104cb0 <release_mylockLC>
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <holding_mylock>:

int holding_mylock(int id){
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801047a6:	8d 45 08             	lea    0x8(%ebp),%eax
801047a9:	50                   	push   %eax
801047aa:	6a 00                	push   $0x0
801047ac:	e8 4f 08 00 00       	call   80105000 <argint>
  return holding_mylockLC(&ptable.lock, id);
801047b1:	58                   	pop    %eax
801047b2:	5a                   	pop    %edx
801047b3:	ff 75 08             	push   0x8(%ebp)
801047b6:	68 a0 48 11 80       	push   $0x801148a0
801047bb:	e8 50 05 00 00       	call   80104d10 <holding_mylockLC>
801047c0:	c9                   	leave  
801047c1:	c3                   	ret    
801047c2:	66 90                	xchg   %ax,%ax
801047c4:	66 90                	xchg   %ax,%ax
801047c6:	66 90                	xchg   %ax,%ax
801047c8:	66 90                	xchg   %ax,%ax
801047ca:	66 90                	xchg   %ax,%ax
801047cc:	66 90                	xchg   %ax,%ax
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047da:	68 28 82 10 80       	push   $0x80108228
801047df:	8d 43 04             	lea    0x4(%ebx),%eax
801047e2:	50                   	push   %eax
801047e3:	e8 18 01 00 00       	call   80104900 <initlock>
  lk->name = name;
801047e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801047f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801047fb:	00 00 00 
  lk->name = name;
801047fe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
}
80104804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104807:	c9                   	leave  
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104818:	8d 73 04             	lea    0x4(%ebx),%esi
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	56                   	push   %esi
8010481f:	e8 ac 02 00 00       	call   80104ad0 <acquire>
  while (lk->locked) {
80104824:	8b 13                	mov    (%ebx),%edx
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	85 d2                	test   %edx,%edx
8010482b:	74 16                	je     80104843 <acquiresleep+0x33>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104830:	83 ec 08             	sub    $0x8,%esp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	e8 56 f9 ff ff       	call   80104190 <sleep>
  while (lk->locked) {
8010483a:	8b 03                	mov    (%ebx),%eax
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	85 c0                	test   %eax,%eax
80104841:	75 ed                	jne    80104830 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104843:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104849:	e8 92 f2 ff ff       	call   80103ae0 <myproc>
8010484e:	8b 40 10             	mov    0x10(%eax),%eax
80104851:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  release(&lk->lk);
80104857:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010485a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010485d:	5b                   	pop    %ebx
8010485e:	5e                   	pop    %esi
8010485f:	5d                   	pop    %ebp
  release(&lk->lk);
80104860:	e9 0b 02 00 00       	jmp    80104a70 <release>
80104865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104878:	8d 73 04             	lea    0x4(%ebx),%esi
8010487b:	83 ec 0c             	sub    $0xc,%esp
8010487e:	56                   	push   %esi
8010487f:	e8 4c 02 00 00       	call   80104ad0 <acquire>
  lk->locked = 0;
80104884:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010488a:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104891:	00 00 00 
  wakeup(lk);
80104894:	89 1c 24             	mov    %ebx,(%esp)
80104897:	e8 b4 f9 ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
8010489c:	89 75 08             	mov    %esi,0x8(%ebp)
8010489f:	83 c4 10             	add    $0x10,%esp
}
801048a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a5:	5b                   	pop    %ebx
801048a6:	5e                   	pop    %esi
801048a7:	5d                   	pop    %ebp
  release(&lk->lk);
801048a8:	e9 c3 01 00 00       	jmp    80104a70 <release>
801048ad:	8d 76 00             	lea    0x0(%esi),%esi

801048b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	31 ff                	xor    %edi,%edi
801048b6:	56                   	push   %esi
801048b7:	53                   	push   %ebx
801048b8:	83 ec 18             	sub    $0x18,%esp
801048bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048be:	8d 73 04             	lea    0x4(%ebx),%esi
801048c1:	56                   	push   %esi
801048c2:	e8 09 02 00 00       	call   80104ad0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048c7:	8b 03                	mov    (%ebx),%eax
801048c9:	83 c4 10             	add    $0x10,%esp
801048cc:	85 c0                	test   %eax,%eax
801048ce:	75 18                	jne    801048e8 <holdingsleep+0x38>
  release(&lk->lk);
801048d0:	83 ec 0c             	sub    $0xc,%esp
801048d3:	56                   	push   %esi
801048d4:	e8 97 01 00 00       	call   80104a70 <release>
  return r;
}
801048d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048dc:	89 f8                	mov    %edi,%eax
801048de:	5b                   	pop    %ebx
801048df:	5e                   	pop    %esi
801048e0:	5f                   	pop    %edi
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret    
801048e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801048e8:	8b 9b 8c 00 00 00    	mov    0x8c(%ebx),%ebx
801048ee:	e8 ed f1 ff ff       	call   80103ae0 <myproc>
801048f3:	39 58 10             	cmp    %ebx,0x10(%eax)
801048f6:	0f 94 c0             	sete   %al
801048f9:	0f b6 c0             	movzbl %al,%eax
801048fc:	89 c7                	mov    %eax,%edi
801048fe:	eb d0                	jmp    801048d0 <holdingsleep+0x20>

80104900 <initlock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010490f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    
8010491b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop

80104920 <getcallerpcs>:
  popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[])
{
80104920:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint *)v - 2;
  for (i = 0; i < 10; i++)
80104921:	31 d2                	xor    %edx,%edx
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	53                   	push   %ebx
  ebp = (uint *)v - 2;
80104926:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint *)v - 2;
8010492c:	83 e8 08             	sub    $0x8,%eax
  for (i = 0; i < 10; i++)
8010492f:	90                   	nop
  {
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
80104930:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104936:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010493c:	77 1a                	ja     80104958 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];      // saved %eip
8010493e:	8b 58 04             	mov    0x4(%eax),%ebx
80104941:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for (i = 0; i < 10; i++)
80104944:	83 c2 01             	add    $0x1,%edx
    ebp = (uint *)ebp[0]; // saved %ebp
80104947:	8b 00                	mov    (%eax),%eax
  for (i = 0; i < 10; i++)
80104949:	83 fa 0a             	cmp    $0xa,%edx
8010494c:	75 e2                	jne    80104930 <getcallerpcs+0x10>
  }
  for (; i < 10; i++)
    pcs[i] = 0;
}
8010494e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104951:	c9                   	leave  
80104952:	c3                   	ret    
80104953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104957:	90                   	nop
  for (; i < 10; i++)
80104958:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010495b:	8d 51 28             	lea    0x28(%ecx),%edx
8010495e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; i < 10; i++)
80104966:	83 c0 04             	add    $0x4,%eax
80104969:	39 d0                	cmp    %edx,%eax
8010496b:	75 f3                	jne    80104960 <getcallerpcs+0x40>
}
8010496d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104970:	c9                   	leave  
80104971:	c3                   	ret    
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104980 <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
80104987:	9c                   	pushf  
80104988:	5b                   	pop    %ebx
  asm volatile("cli");
80104989:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if (mycpu()->ncli == 0)
8010498a:	e8 d1 f0 ff ff       	call   80103a60 <mycpu>
8010498f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104995:	85 c0                	test   %eax,%eax
80104997:	74 17                	je     801049b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104999:	e8 c2 f0 ff ff       	call   80103a60 <mycpu>
8010499e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a8:	c9                   	leave  
801049a9:	c3                   	ret    
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801049b0:	e8 ab f0 ff ff       	call   80103a60 <mycpu>
801049b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801049c1:	eb d6                	jmp    80104999 <pushcli+0x19>
801049c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049d0 <popcli>:

void popcli(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049d6:	9c                   	pushf  
801049d7:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801049d8:	f6 c4 02             	test   $0x2,%ah
801049db:	75 35                	jne    80104a12 <popcli+0x42>
    panic("popcli - interruptible");
  if (--mycpu()->ncli < 0)
801049dd:	e8 7e f0 ff ff       	call   80103a60 <mycpu>
801049e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049e9:	78 34                	js     80104a1f <popcli+0x4f>
    panic("popcli");
  if (mycpu()->ncli == 0 && mycpu()->intena)
801049eb:	e8 70 f0 ff ff       	call   80103a60 <mycpu>
801049f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049f6:	85 d2                	test   %edx,%edx
801049f8:	74 06                	je     80104a00 <popcli+0x30>
    sti();
}
801049fa:	c9                   	leave  
801049fb:	c3                   	ret    
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (mycpu()->ncli == 0 && mycpu()->intena)
80104a00:	e8 5b f0 ff ff       	call   80103a60 <mycpu>
80104a05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a0b:	85 c0                	test   %eax,%eax
80104a0d:	74 eb                	je     801049fa <popcli+0x2a>
  asm volatile("sti");
80104a0f:	fb                   	sti    
}
80104a10:	c9                   	leave  
80104a11:	c3                   	ret    
    panic("popcli - interruptible");
80104a12:	83 ec 0c             	sub    $0xc,%esp
80104a15:	68 33 82 10 80       	push   $0x80108233
80104a1a:	e8 b1 b9 ff ff       	call   801003d0 <panic>
    panic("popcli");
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	68 4a 82 10 80       	push   $0x8010824a
80104a27:	e8 a4 b9 ff ff       	call   801003d0 <panic>
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a30 <holding>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 75 08             	mov    0x8(%ebp),%esi
80104a38:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a3a:	e8 41 ff ff ff       	call   80104980 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a3f:	8b 06                	mov    (%esi),%eax
80104a41:	85 c0                	test   %eax,%eax
80104a43:	75 0b                	jne    80104a50 <holding+0x20>
  popcli();
80104a45:	e8 86 ff ff ff       	call   801049d0 <popcli>
}
80104a4a:	89 d8                	mov    %ebx,%eax
80104a4c:	5b                   	pop    %ebx
80104a4d:	5e                   	pop    %esi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104a50:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a53:	e8 08 f0 ff ff       	call   80103a60 <mycpu>
80104a58:	39 c3                	cmp    %eax,%ebx
80104a5a:	0f 94 c3             	sete   %bl
  popcli();
80104a5d:	e8 6e ff ff ff       	call   801049d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a62:	0f b6 db             	movzbl %bl,%ebx
}
80104a65:	89 d8                	mov    %ebx,%eax
80104a67:	5b                   	pop    %ebx
80104a68:	5e                   	pop    %esi
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    
80104a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop

80104a70 <release>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a78:	e8 03 ff ff ff       	call   80104980 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a7d:	8b 03                	mov    (%ebx),%eax
80104a7f:	85 c0                	test   %eax,%eax
80104a81:	75 15                	jne    80104a98 <release+0x28>
  popcli();
80104a83:	e8 48 ff ff ff       	call   801049d0 <popcli>
    panic("release");
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	68 51 82 10 80       	push   $0x80108251
80104a90:	e8 3b b9 ff ff       	call   801003d0 <panic>
80104a95:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a98:	8b 73 08             	mov    0x8(%ebx),%esi
80104a9b:	e8 c0 ef ff ff       	call   80103a60 <mycpu>
80104aa0:	39 c6                	cmp    %eax,%esi
80104aa2:	75 df                	jne    80104a83 <release+0x13>
  popcli();
80104aa4:	e8 27 ff ff ff       	call   801049d0 <popcli>
  lk->pcs[0] = 0;
80104aa9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ab0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ab7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0"
80104abc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac5:	5b                   	pop    %ebx
80104ac6:	5e                   	pop    %esi
80104ac7:	5d                   	pop    %ebp
  popcli();
80104ac8:	e9 03 ff ff ff       	jmp    801049d0 <popcli>
80104acd:	8d 76 00             	lea    0x0(%esi),%esi

80104ad0 <acquire>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ad7:	e8 a4 fe ff ff       	call   80104980 <pushcli>
  if (holding(lk))
80104adc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104adf:	e8 9c fe ff ff       	call   80104980 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ae4:	8b 03                	mov    (%ebx),%eax
80104ae6:	85 c0                	test   %eax,%eax
80104ae8:	75 7e                	jne    80104b68 <acquire+0x98>
  popcli();
80104aea:	e8 e1 fe ff ff       	call   801049d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104aef:	b9 01 00 00 00       	mov    $0x1,%ecx
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while (xchg(&lk->locked, 1) != 0)
80104af8:	8b 55 08             	mov    0x8(%ebp),%edx
80104afb:	89 c8                	mov    %ecx,%eax
80104afd:	f0 87 02             	lock xchg %eax,(%edx)
80104b00:	85 c0                	test   %eax,%eax
80104b02:	75 f4                	jne    80104af8 <acquire+0x28>
  __sync_synchronize();
80104b04:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b0c:	e8 4f ef ff ff       	call   80103a60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint *)v - 2;
80104b14:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104b16:	89 43 08             	mov    %eax,0x8(%ebx)
  for (i = 0; i < 10; i++)
80104b19:	31 c0                	xor    %eax,%eax
80104b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
80104b20:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b26:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b2c:	77 1a                	ja     80104b48 <acquire+0x78>
    pcs[i] = ebp[1];      // saved %eip
80104b2e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b31:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for (i = 0; i < 10; i++)
80104b35:	83 c0 01             	add    $0x1,%eax
    ebp = (uint *)ebp[0]; // saved %ebp
80104b38:	8b 12                	mov    (%edx),%edx
  for (i = 0; i < 10; i++)
80104b3a:	83 f8 0a             	cmp    $0xa,%eax
80104b3d:	75 e1                	jne    80104b20 <acquire+0x50>
}
80104b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (; i < 10; i++)
80104b48:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104b4c:	8d 51 34             	lea    0x34(%ecx),%edx
80104b4f:	90                   	nop
    pcs[i] = 0;
80104b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; i < 10; i++)
80104b56:	83 c0 04             	add    $0x4,%eax
80104b59:	39 c2                	cmp    %eax,%edx
80104b5b:	75 f3                	jne    80104b50 <acquire+0x80>
}
80104b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b60:	c9                   	leave  
80104b61:	c3                   	ret    
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b68:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b6b:	e8 f0 ee ff ff       	call   80103a60 <mycpu>
80104b70:	39 c3                	cmp    %eax,%ebx
80104b72:	0f 85 72 ff ff ff    	jne    80104aea <acquire+0x1a>
  popcli();
80104b78:	e8 53 fe ff ff       	call   801049d0 <popcli>
    panic("acquire");
80104b7d:	83 ec 0c             	sub    $0xc,%esp
80104b80:	68 59 82 10 80       	push   $0x80108259
80104b85:	e8 46 b8 ff ff       	call   801003d0 <panic>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <init_mylockLC>:

int init_mylockLC(struct spinlock *lk)
{
80104b90:	55                   	push   %ebp
  int counter = 0;
80104b91:	31 c0                	xor    %eax,%eax
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
  while (lk->exists[counter] == 1 && counter <= 10)
80104b98:	83 7a 34 01          	cmpl   $0x1,0x34(%edx)
80104b9c:	75 0c                	jne    80104baa <init_mylockLC+0x1a>
80104b9e:	66 90                	xchg   %ax,%ax
  {
    // cprintf("%d\n",lk->exists[0]);
    counter++;
80104ba0:	83 c0 01             	add    $0x1,%eax
  while (lk->exists[counter] == 1 && counter <= 10)
80104ba3:	83 7c 82 34 01       	cmpl   $0x1,0x34(%edx,%eax,4)
80104ba8:	74 f6                	je     80104ba0 <init_mylockLC+0x10>
  {
    return -1;
  }
  else
  {
    lk->exists[counter] = 1;
80104baa:	c7 44 82 34 01 00 00 	movl   $0x1,0x34(%edx,%eax,4)
80104bb1:	00 
    return counter;
  }
}
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
80104bb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop

80104bc0 <acquire_mylockLC>:

int acquire_mylockLC(struct spinlock *lk, int id)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
80104bc6:	83 ec 14             	sub    $0x14,%esp
80104bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("%d\n", lk->locked);
80104bcc:	ff 33                	push   (%ebx)
80104bce:	68 74 80 10 80       	push   $0x80108074
80104bd3:	e8 18 bb ff ff       	call   801006f0 <cprintf>
  cprintf("%d\n", lk->status[id]);
80104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bdb:	8d 34 83             	lea    (%ebx,%eax,4),%esi
80104bde:	58                   	pop    %eax
80104bdf:	5a                   	pop    %edx
80104be0:	ff 76 5c             	push   0x5c(%esi)
80104be3:	68 74 80 10 80       	push   $0x80108074
80104be8:	e8 03 bb ff ff       	call   801006f0 <cprintf>

  if (lk->exists[id] == 1)
80104bed:	83 c4 10             	add    $0x10,%esp
80104bf0:	83 7e 34 01          	cmpl   $0x1,0x34(%esi)
80104bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf9:	74 0d                	je     80104c08 <acquire_mylockLC+0x48>
  {
    return -1;
  }

  return 0;
}
80104bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bfe:	5b                   	pop    %ebx
80104bff:	5e                   	pop    %esi
80104c00:	5f                   	pop    %edi
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret    
80104c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c07:	90                   	nop
    pushcli();
80104c08:	e8 73 fd ff ff       	call   80104980 <pushcli>

int holding_mylockLC(struct spinlock *lk, int id)
{
  // return id;
  int r;
  pushcli();
80104c0d:	e8 6e fd ff ff       	call   80104980 <pushcli>
  r = lk->status[id] && lk->locked;
80104c12:	8b 7e 5c             	mov    0x5c(%esi),%edi
80104c15:	85 ff                	test   %edi,%edi
80104c17:	75 77                	jne    80104c90 <acquire_mylockLC+0xd0>
  popcli();
80104c19:	e8 b2 fd ff ff       	call   801049d0 <popcli>
    lk->status[id] = 1;
80104c1e:	c7 46 5c 01 00 00 00 	movl   $0x1,0x5c(%esi)
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0)
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	74 28                	je     80104c59 <acquire_mylockLC+0x99>
80104c31:	bf 01 00 00 00       	mov    $0x1,%edi
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("inside while 1\n");
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	68 69 82 10 80       	push   $0x80108269
80104c48:	e8 a3 ba ff ff       	call   801006f0 <cprintf>
80104c4d:	89 f8                	mov    %edi,%eax
80104c4f:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0)
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	85 c0                	test   %eax,%eax
80104c57:	75 e7                	jne    80104c40 <acquire_mylockLC+0x80>
    __sync_synchronize();
80104c59:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    cprintf("lock %d\n", lk->locked);
80104c5e:	83 ec 08             	sub    $0x8,%esp
80104c61:	ff 33                	push   (%ebx)
80104c63:	68 79 82 10 80       	push   $0x80108279
80104c68:	e8 83 ba ff ff       	call   801006f0 <cprintf>
    cprintf("status %d\n", lk->status[id]);
80104c6d:	58                   	pop    %eax
80104c6e:	5a                   	pop    %edx
80104c6f:	ff 76 5c             	push   0x5c(%esi)
80104c72:	68 82 82 10 80       	push   $0x80108282
80104c77:	e8 74 ba ff ff       	call   801006f0 <cprintf>
    return 1;
80104c7c:	83 c4 10             	add    $0x10,%esp
}
80104c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 1;
80104c82:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104c87:	5b                   	pop    %ebx
80104c88:	5e                   	pop    %esi
80104c89:	5f                   	pop    %edi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lk->status[id] && lk->locked;
80104c90:	8b 0b                	mov    (%ebx),%ecx
80104c92:	85 c9                	test   %ecx,%ecx
80104c94:	74 83                	je     80104c19 <acquire_mylockLC+0x59>
  popcli();
80104c96:	e8 35 fd ff ff       	call   801049d0 <popcli>
      panic("lcLocks");
80104c9b:	83 ec 0c             	sub    $0xc,%esp
80104c9e:	68 61 82 10 80       	push   $0x80108261
80104ca3:	e8 28 b7 ff ff       	call   801003d0 <panic>
80104ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop

80104cb0 <release_mylockLC>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 10             	sub    $0x10,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("relFnc\n");
80104cba:	68 8d 82 10 80       	push   $0x8010828d
80104cbf:	e8 2c ba ff ff       	call   801006f0 <cprintf>
  if (lk->status[id] == 1)
80104cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104ccf:	8d 04 83             	lea    (%ebx,%eax,4),%eax
80104cd2:	83 78 5c 01          	cmpl   $0x1,0x5c(%eax)
80104cd6:	74 08                	je     80104ce0 <release_mylockLC+0x30>
}
80104cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cdb:	89 d0                	mov    %edx,%eax
80104cdd:	c9                   	leave  
80104cde:	c3                   	ret    
80104cdf:	90                   	nop
    lk->status[id] = 0;
80104ce0:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
    __sync_synchronize();
80104ce7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->status[id] = 0;
80104cec:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
    asm volatile("movl $0, %0"
80104cf3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    return 1;
80104cf9:	ba 01 00 00 00       	mov    $0x1,%edx
}
80104cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d01:	c9                   	leave  
80104d02:	89 d0                	mov    %edx,%eax
80104d04:	c3                   	ret    
80104d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <holding_mylockLC>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	8b 75 08             	mov    0x8(%ebp),%esi
80104d18:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d1a:	e8 61 fc ff ff       	call   80104980 <pushcli>
  r = lk->status[id] && lk->locked;
80104d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d22:	8b 54 86 5c          	mov    0x5c(%esi,%eax,4),%edx
80104d26:	85 d2                	test   %edx,%edx
80104d28:	74 09                	je     80104d33 <holding_mylockLC+0x23>
80104d2a:	8b 06                	mov    (%esi),%eax
80104d2c:	31 db                	xor    %ebx,%ebx
80104d2e:	85 c0                	test   %eax,%eax
80104d30:	0f 95 c3             	setne  %bl
  popcli();
80104d33:	e8 98 fc ff ff       	call   801049d0 <popcli>
  return r;
80104d38:	89 d8                	mov    %ebx,%eax
80104d3a:	5b                   	pop    %ebx
80104d3b:	5e                   	pop    %esi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	8b 55 08             	mov    0x8(%ebp),%edx
80104d47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d4a:	53                   	push   %ebx
80104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104d4e:	89 d7                	mov    %edx,%edi
80104d50:	09 cf                	or     %ecx,%edi
80104d52:	83 e7 03             	and    $0x3,%edi
80104d55:	75 29                	jne    80104d80 <memset+0x40>
    c &= 0xFF;
80104d57:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d5a:	c1 e0 18             	shl    $0x18,%eax
80104d5d:	89 fb                	mov    %edi,%ebx
80104d5f:	c1 e9 02             	shr    $0x2,%ecx
80104d62:	c1 e3 10             	shl    $0x10,%ebx
80104d65:	09 d8                	or     %ebx,%eax
80104d67:	09 f8                	or     %edi,%eax
80104d69:	c1 e7 08             	shl    $0x8,%edi
80104d6c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d6e:	89 d7                	mov    %edx,%edi
80104d70:	fc                   	cld    
80104d71:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d73:	5b                   	pop    %ebx
80104d74:	89 d0                	mov    %edx,%eax
80104d76:	5f                   	pop    %edi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d80:	89 d7                	mov    %edx,%edi
80104d82:	fc                   	cld    
80104d83:	f3 aa                	rep stos %al,%es:(%edi)
80104d85:	5b                   	pop    %ebx
80104d86:	89 d0                	mov    %edx,%eax
80104d88:	5f                   	pop    %edi
80104d89:	5d                   	pop    %ebp
80104d8a:	c3                   	ret    
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop

80104d90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	8b 75 10             	mov    0x10(%ebp),%esi
80104d97:	8b 55 08             	mov    0x8(%ebp),%edx
80104d9a:	53                   	push   %ebx
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d9e:	85 f6                	test   %esi,%esi
80104da0:	74 2e                	je     80104dd0 <memcmp+0x40>
80104da2:	01 c6                	add    %eax,%esi
80104da4:	eb 14                	jmp    80104dba <memcmp+0x2a>
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104db0:	83 c0 01             	add    $0x1,%eax
80104db3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104db6:	39 f0                	cmp    %esi,%eax
80104db8:	74 16                	je     80104dd0 <memcmp+0x40>
    if(*s1 != *s2)
80104dba:	0f b6 0a             	movzbl (%edx),%ecx
80104dbd:	0f b6 18             	movzbl (%eax),%ebx
80104dc0:	38 d9                	cmp    %bl,%cl
80104dc2:	74 ec                	je     80104db0 <memcmp+0x20>
      return *s1 - *s2;
80104dc4:	0f b6 c1             	movzbl %cl,%eax
80104dc7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104dc9:	5b                   	pop    %ebx
80104dca:	5e                   	pop    %esi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
80104dd0:	5b                   	pop    %ebx
  return 0;
80104dd1:	31 c0                	xor    %eax,%eax
}
80104dd3:	5e                   	pop    %esi
80104dd4:	5d                   	pop    %ebp
80104dd5:	c3                   	ret    
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	8b 55 08             	mov    0x8(%ebp),%edx
80104de7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dea:	56                   	push   %esi
80104deb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dee:	39 d6                	cmp    %edx,%esi
80104df0:	73 26                	jae    80104e18 <memmove+0x38>
80104df2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104df5:	39 fa                	cmp    %edi,%edx
80104df7:	73 1f                	jae    80104e18 <memmove+0x38>
80104df9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104dfc:	85 c9                	test   %ecx,%ecx
80104dfe:	74 0c                	je     80104e0c <memmove+0x2c>
      *--d = *--s;
80104e00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e04:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e07:	83 e8 01             	sub    $0x1,%eax
80104e0a:	73 f4                	jae    80104e00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e0c:	5e                   	pop    %esi
80104e0d:	89 d0                	mov    %edx,%eax
80104e0f:	5f                   	pop    %edi
80104e10:	5d                   	pop    %ebp
80104e11:	c3                   	ret    
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e18:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e1b:	89 d7                	mov    %edx,%edi
80104e1d:	85 c9                	test   %ecx,%ecx
80104e1f:	74 eb                	je     80104e0c <memmove+0x2c>
80104e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e28:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e29:	39 c6                	cmp    %eax,%esi
80104e2b:	75 fb                	jne    80104e28 <memmove+0x48>
}
80104e2d:	5e                   	pop    %esi
80104e2e:	89 d0                	mov    %edx,%eax
80104e30:	5f                   	pop    %edi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e40:	eb 9e                	jmp    80104de0 <memmove>
80104e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	8b 75 10             	mov    0x10(%ebp),%esi
80104e57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e5a:	53                   	push   %ebx
80104e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104e5e:	85 f6                	test   %esi,%esi
80104e60:	74 2e                	je     80104e90 <strncmp+0x40>
80104e62:	01 d6                	add    %edx,%esi
80104e64:	eb 18                	jmp    80104e7e <strncmp+0x2e>
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
80104e70:	38 d8                	cmp    %bl,%al
80104e72:	75 14                	jne    80104e88 <strncmp+0x38>
    n--, p++, q++;
80104e74:	83 c2 01             	add    $0x1,%edx
80104e77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e7a:	39 f2                	cmp    %esi,%edx
80104e7c:	74 12                	je     80104e90 <strncmp+0x40>
80104e7e:	0f b6 01             	movzbl (%ecx),%eax
80104e81:	0f b6 1a             	movzbl (%edx),%ebx
80104e84:	84 c0                	test   %al,%al
80104e86:	75 e8                	jne    80104e70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e88:	29 d8                	sub    %ebx,%eax
}
80104e8a:	5b                   	pop    %ebx
80104e8b:	5e                   	pop    %esi
80104e8c:	5d                   	pop    %ebp
80104e8d:	c3                   	ret    
80104e8e:	66 90                	xchg   %ax,%ax
80104e90:	5b                   	pop    %ebx
    return 0;
80104e91:	31 c0                	xor    %eax,%eax
}
80104e93:	5e                   	pop    %esi
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ea8:	53                   	push   %ebx
80104ea9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104eac:	89 f0                	mov    %esi,%eax
80104eae:	eb 15                	jmp    80104ec5 <strncpy+0x25>
80104eb0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104eb4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104eb7:	83 c0 01             	add    $0x1,%eax
80104eba:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104ebe:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ec1:	84 d2                	test   %dl,%dl
80104ec3:	74 09                	je     80104ece <strncpy+0x2e>
80104ec5:	89 cb                	mov    %ecx,%ebx
80104ec7:	83 e9 01             	sub    $0x1,%ecx
80104eca:	85 db                	test   %ebx,%ebx
80104ecc:	7f e2                	jg     80104eb0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104ece:	89 c2                	mov    %eax,%edx
80104ed0:	85 c9                	test   %ecx,%ecx
80104ed2:	7e 17                	jle    80104eeb <strncpy+0x4b>
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ed8:	83 c2 01             	add    $0x1,%edx
80104edb:	89 c1                	mov    %eax,%ecx
80104edd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104ee1:	29 d1                	sub    %edx,%ecx
80104ee3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ee7:	85 c9                	test   %ecx,%ecx
80104ee9:	7f ed                	jg     80104ed8 <strncpy+0x38>
  return os;
}
80104eeb:	5b                   	pop    %ebx
80104eec:	89 f0                	mov    %esi,%eax
80104eee:	5e                   	pop    %esi
80104eef:	5f                   	pop    %edi
80104ef0:	5d                   	pop    %ebp
80104ef1:	c3                   	ret    
80104ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	8b 55 10             	mov    0x10(%ebp),%edx
80104f07:	8b 75 08             	mov    0x8(%ebp),%esi
80104f0a:	53                   	push   %ebx
80104f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f0e:	85 d2                	test   %edx,%edx
80104f10:	7e 25                	jle    80104f37 <safestrcpy+0x37>
80104f12:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f16:	89 f2                	mov    %esi,%edx
80104f18:	eb 16                	jmp    80104f30 <safestrcpy+0x30>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f20:	0f b6 08             	movzbl (%eax),%ecx
80104f23:	83 c0 01             	add    $0x1,%eax
80104f26:	83 c2 01             	add    $0x1,%edx
80104f29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f2c:	84 c9                	test   %cl,%cl
80104f2e:	74 04                	je     80104f34 <safestrcpy+0x34>
80104f30:	39 d8                	cmp    %ebx,%eax
80104f32:	75 ec                	jne    80104f20 <safestrcpy+0x20>
    ;
  *s = 0;
80104f34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f37:	89 f0                	mov    %esi,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <strlen>:

int
strlen(const char *s)
{
80104f40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f48:	80 3a 00             	cmpb   $0x0,(%edx)
80104f4b:	74 0c                	je     80104f59 <strlen+0x19>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	83 c0 01             	add    $0x1,%eax
80104f53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f57:	75 f7                	jne    80104f50 <strlen+0x10>
    ;
  return n;
}
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    

80104f5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f63:	55                   	push   %ebp
  pushl %ebx
80104f64:	53                   	push   %ebx
  pushl %esi
80104f65:	56                   	push   %esi
  pushl %edi
80104f66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f6b:	5f                   	pop    %edi
  popl %esi
80104f6c:	5e                   	pop    %esi
  popl %ebx
80104f6d:	5b                   	pop    %ebx
  popl %ebp
80104f6e:	5d                   	pop    %ebp
  ret
80104f6f:	c3                   	ret    

80104f70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
80104f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f7a:	e8 61 eb ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f7f:	8b 00                	mov    (%eax),%eax
80104f81:	39 d8                	cmp    %ebx,%eax
80104f83:	76 1b                	jbe    80104fa0 <fetchint+0x30>
80104f85:	8d 53 04             	lea    0x4(%ebx),%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	72 14                	jb     80104fa0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8f:	8b 13                	mov    (%ebx),%edx
80104f91:	89 10                	mov    %edx,(%eax)
  return 0;
80104f93:	31 c0                	xor    %eax,%eax
}
80104f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f98:	c9                   	leave  
80104f99:	c3                   	ret    
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa5:	eb ee                	jmp    80104f95 <fetchint+0x25>
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 04             	sub    $0x4,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fba:	e8 21 eb ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz)
80104fbf:	39 18                	cmp    %ebx,(%eax)
80104fc1:	76 2d                	jbe    80104ff0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fc6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fc8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104fca:	39 d3                	cmp    %edx,%ebx
80104fcc:	73 22                	jae    80104ff0 <fetchstr+0x40>
80104fce:	89 d8                	mov    %ebx,%eax
80104fd0:	eb 0d                	jmp    80104fdf <fetchstr+0x2f>
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fd8:	83 c0 01             	add    $0x1,%eax
80104fdb:	39 c2                	cmp    %eax,%edx
80104fdd:	76 11                	jbe    80104ff0 <fetchstr+0x40>
    if(*s == 0)
80104fdf:	80 38 00             	cmpb   $0x0,(%eax)
80104fe2:	75 f4                	jne    80104fd8 <fetchstr+0x28>
      return s - *pp;
80104fe4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe9:	c9                   	leave  
80104fea:	c3                   	ret    
80104feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop
80104ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	e8 d6 ea ff ff       	call   80103ae0 <myproc>
8010500a:	8b 55 08             	mov    0x8(%ebp),%edx
8010500d:	8b 40 18             	mov    0x18(%eax),%eax
80105010:	8b 40 44             	mov    0x44(%eax),%eax
80105013:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105016:	e8 c5 ea ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010501b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010501e:	8b 00                	mov    (%eax),%eax
80105020:	39 c6                	cmp    %eax,%esi
80105022:	73 1c                	jae    80105040 <argint+0x40>
80105024:	8d 53 08             	lea    0x8(%ebx),%edx
80105027:	39 d0                	cmp    %edx,%eax
80105029:	72 15                	jb     80105040 <argint+0x40>
  *ip = *(int*)(addr);
8010502b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502e:	8b 53 04             	mov    0x4(%ebx),%edx
80105031:	89 10                	mov    %edx,(%eax)
  return 0;
80105033:	31 c0                	xor    %eax,%eax
}
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105045:	eb ee                	jmp    80105035 <argint+0x35>
80105047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504e:	66 90                	xchg   %ax,%ax

80105050 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
80105055:	53                   	push   %ebx
80105056:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105059:	e8 82 ea ff ff       	call   80103ae0 <myproc>
8010505e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105060:	e8 7b ea ff ff       	call   80103ae0 <myproc>
80105065:	8b 55 08             	mov    0x8(%ebp),%edx
80105068:	8b 40 18             	mov    0x18(%eax),%eax
8010506b:	8b 40 44             	mov    0x44(%eax),%eax
8010506e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105071:	e8 6a ea ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105076:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105079:	8b 00                	mov    (%eax),%eax
8010507b:	39 c7                	cmp    %eax,%edi
8010507d:	73 31                	jae    801050b0 <argptr+0x60>
8010507f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105082:	39 c8                	cmp    %ecx,%eax
80105084:	72 2a                	jb     801050b0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105086:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105089:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010508c:	85 d2                	test   %edx,%edx
8010508e:	78 20                	js     801050b0 <argptr+0x60>
80105090:	8b 16                	mov    (%esi),%edx
80105092:	39 c2                	cmp    %eax,%edx
80105094:	76 1a                	jbe    801050b0 <argptr+0x60>
80105096:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105099:	01 c3                	add    %eax,%ebx
8010509b:	39 da                	cmp    %ebx,%edx
8010509d:	72 11                	jb     801050b0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010509f:	8b 55 0c             	mov    0xc(%ebp),%edx
801050a2:	89 02                	mov    %eax,(%edx)
  return 0;
801050a4:	31 c0                	xor    %eax,%eax
}
801050a6:	83 c4 0c             	add    $0xc,%esp
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5f                   	pop    %edi
801050ac:	5d                   	pop    %ebp
801050ad:	c3                   	ret    
801050ae:	66 90                	xchg   %ax,%ax
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb ef                	jmp    801050a6 <argptr+0x56>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050c5:	e8 16 ea ff ff       	call   80103ae0 <myproc>
801050ca:	8b 55 08             	mov    0x8(%ebp),%edx
801050cd:	8b 40 18             	mov    0x18(%eax),%eax
801050d0:	8b 40 44             	mov    0x44(%eax),%eax
801050d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050d6:	e8 05 ea ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050de:	8b 00                	mov    (%eax),%eax
801050e0:	39 c6                	cmp    %eax,%esi
801050e2:	73 44                	jae    80105128 <argstr+0x68>
801050e4:	8d 53 08             	lea    0x8(%ebx),%edx
801050e7:	39 d0                	cmp    %edx,%eax
801050e9:	72 3d                	jb     80105128 <argstr+0x68>
  *ip = *(int*)(addr);
801050eb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801050ee:	e8 ed e9 ff ff       	call   80103ae0 <myproc>
  if(addr >= curproc->sz)
801050f3:	3b 18                	cmp    (%eax),%ebx
801050f5:	73 31                	jae    80105128 <argstr+0x68>
  *pp = (char*)addr;
801050f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050fa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050fc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050fe:	39 d3                	cmp    %edx,%ebx
80105100:	73 26                	jae    80105128 <argstr+0x68>
80105102:	89 d8                	mov    %ebx,%eax
80105104:	eb 11                	jmp    80105117 <argstr+0x57>
80105106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
80105110:	83 c0 01             	add    $0x1,%eax
80105113:	39 c2                	cmp    %eax,%edx
80105115:	76 11                	jbe    80105128 <argstr+0x68>
    if(*s == 0)
80105117:	80 38 00             	cmpb   $0x0,(%eax)
8010511a:	75 f4                	jne    80105110 <argstr+0x50>
      return s - *pp;
8010511c:	29 d8                	sub    %ebx,%eax
             */
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010511e:	5b                   	pop    %ebx
8010511f:	5e                   	pop    %esi
80105120:	5d                   	pop    %ebp
80105121:	c3                   	ret    
80105122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105128:	5b                   	pop    %ebx
    return -1;
80105129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010512e:	5e                   	pop    %esi
8010512f:	5d                   	pop    %ebp
80105130:	c3                   	ret    
80105131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513f:	90                   	nop

80105140 <syscall>:
[SYS_holding_mylock]    sys_holding_mylock,
};

void
syscall(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	53                   	push   %ebx
80105144:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105147:	e8 94 e9 ff ff       	call   80103ae0 <myproc>
8010514c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010514e:	8b 40 18             	mov    0x18(%eax),%eax
80105151:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105154:	8d 50 ff             	lea    -0x1(%eax),%edx
80105157:	83 fa 28             	cmp    $0x28,%edx
8010515a:	77 24                	ja     80105180 <syscall+0x40>
8010515c:	8b 14 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%edx
80105163:	85 d2                	test   %edx,%edx
80105165:	74 19                	je     80105180 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105167:	ff d2                	call   *%edx
80105169:	89 c2                	mov    %eax,%edx
8010516b:	8b 43 18             	mov    0x18(%ebx),%eax
8010516e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105174:	c9                   	leave  
80105175:	c3                   	ret    
80105176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105180:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105181:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105184:	50                   	push   %eax
80105185:	ff 73 10             	push   0x10(%ebx)
80105188:	68 95 82 10 80       	push   $0x80108295
8010518d:	e8 5e b5 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
80105192:	8b 43 18             	mov    0x18(%ebx),%eax
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010519f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a2:	c9                   	leave  
801051a3:	c3                   	ret    
801051a4:	66 90                	xchg   %ax,%ax
801051a6:	66 90                	xchg   %ax,%ax
801051a8:	66 90                	xchg   %ax,%ax
801051aa:	66 90                	xchg   %ax,%ax
801051ac:	66 90                	xchg   %ax,%ax
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801051b5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051b8:	53                   	push   %ebx
801051b9:	83 ec 34             	sub    $0x34,%esp
801051bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
801051c2:	57                   	push   %edi
801051c3:	50                   	push   %eax
{
801051c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
801051ca:	e8 e1 cf ff ff       	call   801021b0 <nameiparent>
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	85 c0                	test   %eax,%eax
801051d4:	0f 84 56 01 00 00    	je     80105330 <create+0x180>
    return 0;
  ilock(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	89 c3                	mov    %eax,%ebx
801051df:	50                   	push   %eax
801051e0:	e8 0b c6 ff ff       	call   801017f0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801051e5:	83 c4 0c             	add    $0xc,%esp
801051e8:	6a 00                	push   $0x0
801051ea:	57                   	push   %edi
801051eb:	53                   	push   %ebx
801051ec:	e8 bf cb ff ff       	call   80101db0 <dirlookup>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	89 c6                	mov    %eax,%esi
801051f6:	85 c0                	test   %eax,%eax
801051f8:	74 56                	je     80105250 <create+0xa0>
  {
    iunlockput(dp);
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	53                   	push   %ebx
801051fe:	e8 ad c8 ff ff       	call   80101ab0 <iunlockput>
    ilock(ip);
80105203:	89 34 24             	mov    %esi,(%esp)
80105206:	e8 e5 c5 ff ff       	call   801017f0 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010520b:	83 c4 10             	add    $0x10,%esp
8010520e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105213:	75 1b                	jne    80105230 <create+0x80>
80105215:	66 83 be a0 00 00 00 	cmpw   $0x2,0xa0(%esi)
8010521c:	02 
8010521d:	75 11                	jne    80105230 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010521f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105222:	89 f0                	mov    %esi,%eax
80105224:	5b                   	pop    %ebx
80105225:	5e                   	pop    %esi
80105226:	5f                   	pop    %edi
80105227:	5d                   	pop    %ebp
80105228:	c3                   	ret    
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	56                   	push   %esi
    return 0;
80105234:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105236:	e8 75 c8 ff ff       	call   80101ab0 <iunlockput>
    return 0;
8010523b:	83 c4 10             	add    $0x10,%esp
}
8010523e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105241:	89 f0                	mov    %esi,%eax
80105243:	5b                   	pop    %ebx
80105244:	5e                   	pop    %esi
80105245:	5f                   	pop    %edi
80105246:	5d                   	pop    %ebp
80105247:	c3                   	ret    
80105248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105250:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105254:	83 ec 08             	sub    $0x8,%esp
80105257:	50                   	push   %eax
80105258:	ff 33                	push   (%ebx)
8010525a:	e8 11 c4 ff ff       	call   80101670 <ialloc>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	89 c6                	mov    %eax,%esi
80105264:	85 c0                	test   %eax,%eax
80105266:	0f 84 dd 00 00 00    	je     80105349 <create+0x199>
  ilock(ip);
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	50                   	push   %eax
80105270:	e8 7b c5 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80105275:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105279:	66 89 86 a2 00 00 00 	mov    %ax,0xa2(%esi)
  ip->minor = minor;
80105280:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105284:	66 89 86 a4 00 00 00 	mov    %ax,0xa4(%esi)
  ip->nlink = 1;
8010528b:	b8 01 00 00 00       	mov    $0x1,%eax
80105290:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
  iupdate(ip);
80105297:	89 34 24             	mov    %esi,(%esp)
8010529a:	e8 91 c4 ff ff       	call   80101730 <iupdate>
  if (type == T_DIR)
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052a7:	74 2f                	je     801052d8 <create+0x128>
  if (dirlink(dp, name, ip->inum) < 0)
801052a9:	83 ec 04             	sub    $0x4,%esp
801052ac:	ff 76 04             	push   0x4(%esi)
801052af:	57                   	push   %edi
801052b0:	53                   	push   %ebx
801052b1:	e8 1a ce ff ff       	call   801020d0 <dirlink>
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	85 c0                	test   %eax,%eax
801052bb:	78 7f                	js     8010533c <create+0x18c>
  iunlockput(dp);
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	53                   	push   %ebx
801052c1:	e8 ea c7 ff ff       	call   80101ab0 <iunlockput>
  return ip;
801052c6:	83 c4 10             	add    $0x10,%esp
}
801052c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052cc:	89 f0                	mov    %esi,%eax
801052ce:	5b                   	pop    %ebx
801052cf:	5e                   	pop    %esi
801052d0:	5f                   	pop    %edi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d7:	90                   	nop
    iupdate(dp);
801052d8:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
801052db:	66 83 83 a6 00 00 00 	addw   $0x1,0xa6(%ebx)
801052e2:	01 
    iupdate(dp);
801052e3:	53                   	push   %ebx
801052e4:	e8 47 c4 ff ff       	call   80101730 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052e9:	83 c4 0c             	add    $0xc,%esp
801052ec:	ff 76 04             	push   0x4(%esi)
801052ef:	68 84 83 10 80       	push   $0x80108384
801052f4:	56                   	push   %esi
801052f5:	e8 d6 cd ff ff       	call   801020d0 <dirlink>
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	85 c0                	test   %eax,%eax
801052ff:	78 18                	js     80105319 <create+0x169>
80105301:	83 ec 04             	sub    $0x4,%esp
80105304:	ff 73 04             	push   0x4(%ebx)
80105307:	68 83 83 10 80       	push   $0x80108383
8010530c:	56                   	push   %esi
8010530d:	e8 be cd ff ff       	call   801020d0 <dirlink>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	79 90                	jns    801052a9 <create+0xf9>
      panic("create dots");
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	68 77 83 10 80       	push   $0x80108377
80105321:	e8 aa b0 ff ff       	call   801003d0 <panic>
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
}
80105330:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105333:	31 f6                	xor    %esi,%esi
}
80105335:	5b                   	pop    %ebx
80105336:	89 f0                	mov    %esi,%eax
80105338:	5e                   	pop    %esi
80105339:	5f                   	pop    %edi
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    
    panic("create: dirlink");
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	68 86 83 10 80       	push   $0x80108386
80105344:	e8 87 b0 ff ff       	call   801003d0 <panic>
    panic("create: ialloc");
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	68 68 83 10 80       	push   $0x80108368
80105351:	e8 7a b0 ff ff       	call   801003d0 <panic>
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi

80105360 <sys_dup>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	56                   	push   %esi
80105364:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105365:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105368:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010536b:	50                   	push   %eax
8010536c:	6a 00                	push   $0x0
8010536e:	e8 8d fc ff ff       	call   80105000 <argint>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	78 36                	js     801053b0 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010537a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010537e:	77 30                	ja     801053b0 <sys_dup+0x50>
80105380:	e8 5b e7 ff ff       	call   80103ae0 <myproc>
80105385:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105388:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010538c:	85 f6                	test   %esi,%esi
8010538e:	74 20                	je     801053b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105390:	e8 4b e7 ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105395:	31 db                	xor    %ebx,%ebx
80105397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
801053a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053a4:	85 d2                	test   %edx,%edx
801053a6:	74 18                	je     801053c0 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
801053a8:	83 c3 01             	add    $0x1,%ebx
801053ab:	83 fb 10             	cmp    $0x10,%ebx
801053ae:	75 f0                	jne    801053a0 <sys_dup+0x40>
}
801053b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053b8:	89 d8                	mov    %ebx,%eax
801053ba:	5b                   	pop    %ebx
801053bb:	5e                   	pop    %esi
801053bc:	5d                   	pop    %ebp
801053bd:	c3                   	ret    
801053be:	66 90                	xchg   %ax,%ax
  filedup(f);
801053c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801053c7:	56                   	push   %esi
801053c8:	e8 23 bb ff ff       	call   80100ef0 <filedup>
  return fd;
801053cd:	83 c4 10             	add    $0x10,%esp
}
801053d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053d3:	89 d8                	mov    %ebx,%eax
801053d5:	5b                   	pop    %ebx
801053d6:	5e                   	pop    %esi
801053d7:	5d                   	pop    %ebp
801053d8:	c3                   	ret    
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_read>:
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801053e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053e8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801053eb:	53                   	push   %ebx
801053ec:	6a 00                	push   $0x0
801053ee:	e8 0d fc ff ff       	call   80105000 <argint>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 5e                	js     80105458 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801053fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053fe:	77 58                	ja     80105458 <sys_read+0x78>
80105400:	e8 db e6 ff ff       	call   80103ae0 <myproc>
80105405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105408:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010540c:	85 f6                	test   %esi,%esi
8010540e:	74 48                	je     80105458 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105416:	50                   	push   %eax
80105417:	6a 02                	push   $0x2
80105419:	e8 e2 fb ff ff       	call   80105000 <argint>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 33                	js     80105458 <sys_read+0x78>
80105425:	83 ec 04             	sub    $0x4,%esp
80105428:	ff 75 f0             	push   -0x10(%ebp)
8010542b:	53                   	push   %ebx
8010542c:	6a 01                	push   $0x1
8010542e:	e8 1d fc ff ff       	call   80105050 <argptr>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 1e                	js     80105458 <sys_read+0x78>
  return fileread(f, p, n);
8010543a:	83 ec 04             	sub    $0x4,%esp
8010543d:	ff 75 f0             	push   -0x10(%ebp)
80105440:	ff 75 f4             	push   -0xc(%ebp)
80105443:	56                   	push   %esi
80105444:	e8 27 bc ff ff       	call   80101070 <fileread>
80105449:	83 c4 10             	add    $0x10,%esp
}
8010544c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010544f:	5b                   	pop    %ebx
80105450:	5e                   	pop    %esi
80105451:	5d                   	pop    %ebp
80105452:	c3                   	ret    
80105453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105457:	90                   	nop
    return -1;
80105458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545d:	eb ed                	jmp    8010544c <sys_read+0x6c>
8010545f:	90                   	nop

80105460 <sys_write>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105465:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105468:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010546b:	53                   	push   %ebx
8010546c:	6a 00                	push   $0x0
8010546e:	e8 8d fb ff ff       	call   80105000 <argint>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 5e                	js     801054d8 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010547a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010547e:	77 58                	ja     801054d8 <sys_write+0x78>
80105480:	e8 5b e6 ff ff       	call   80103ae0 <myproc>
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010548c:	85 f6                	test   %esi,%esi
8010548e:	74 48                	je     801054d8 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105496:	50                   	push   %eax
80105497:	6a 02                	push   $0x2
80105499:	e8 62 fb ff ff       	call   80105000 <argint>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 33                	js     801054d8 <sys_write+0x78>
801054a5:	83 ec 04             	sub    $0x4,%esp
801054a8:	ff 75 f0             	push   -0x10(%ebp)
801054ab:	53                   	push   %ebx
801054ac:	6a 01                	push   $0x1
801054ae:	e8 9d fb ff ff       	call   80105050 <argptr>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 1e                	js     801054d8 <sys_write+0x78>
  return filewrite(f, p, n);
801054ba:	83 ec 04             	sub    $0x4,%esp
801054bd:	ff 75 f0             	push   -0x10(%ebp)
801054c0:	ff 75 f4             	push   -0xc(%ebp)
801054c3:	56                   	push   %esi
801054c4:	e8 37 bc ff ff       	call   80101100 <filewrite>
801054c9:	83 c4 10             	add    $0x10,%esp
}
801054cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054cf:	5b                   	pop    %ebx
801054d0:	5e                   	pop    %esi
801054d1:	5d                   	pop    %ebp
801054d2:	c3                   	ret    
801054d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d7:	90                   	nop
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ed                	jmp    801054cc <sys_write+0x6c>
801054df:	90                   	nop

801054e0 <sys_close>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801054e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054e8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801054eb:	50                   	push   %eax
801054ec:	6a 00                	push   $0x0
801054ee:	e8 0d fb ff ff       	call   80105000 <argint>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 3e                	js     80105538 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801054fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054fe:	77 38                	ja     80105538 <sys_close+0x58>
80105500:	e8 db e5 ff ff       	call   80103ae0 <myproc>
80105505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105508:	8d 5a 08             	lea    0x8(%edx),%ebx
8010550b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010550f:	85 f6                	test   %esi,%esi
80105511:	74 25                	je     80105538 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105513:	e8 c8 e5 ff ff       	call   80103ae0 <myproc>
  fileclose(f);
80105518:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010551b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105522:	00 
  fileclose(f);
80105523:	56                   	push   %esi
80105524:	e8 17 ba ff ff       	call   80100f40 <fileclose>
  return 0;
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	31 c0                	xor    %eax,%eax
}
8010552e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105531:	5b                   	pop    %ebx
80105532:	5e                   	pop    %esi
80105533:	5d                   	pop    %ebp
80105534:	c3                   	ret    
80105535:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553d:	eb ef                	jmp    8010552e <sys_close+0x4e>
8010553f:	90                   	nop

80105540 <sys_fstat>:
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105545:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105548:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010554b:	53                   	push   %ebx
8010554c:	6a 00                	push   $0x0
8010554e:	e8 ad fa ff ff       	call   80105000 <argint>
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	78 46                	js     801055a0 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010555a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010555e:	77 40                	ja     801055a0 <sys_fstat+0x60>
80105560:	e8 7b e5 ff ff       	call   80103ae0 <myproc>
80105565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105568:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010556c:	85 f6                	test   %esi,%esi
8010556e:	74 30                	je     801055a0 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105570:	83 ec 04             	sub    $0x4,%esp
80105573:	6a 14                	push   $0x14
80105575:	53                   	push   %ebx
80105576:	6a 01                	push   $0x1
80105578:	e8 d3 fa ff ff       	call   80105050 <argptr>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	78 1c                	js     801055a0 <sys_fstat+0x60>
  return filestat(f, st);
80105584:	83 ec 08             	sub    $0x8,%esp
80105587:	ff 75 f4             	push   -0xc(%ebp)
8010558a:	56                   	push   %esi
8010558b:	e8 90 ba ff ff       	call   80101020 <filestat>
80105590:	83 c4 10             	add    $0x10,%esp
}
80105593:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105596:	5b                   	pop    %ebx
80105597:	5e                   	pop    %esi
80105598:	5d                   	pop    %ebp
80105599:	c3                   	ret    
8010559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a5:	eb ec                	jmp    80105593 <sys_fstat+0x53>
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <sys_link>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055b8:	53                   	push   %ebx
801055b9:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055bc:	50                   	push   %eax
801055bd:	6a 00                	push   $0x0
801055bf:	e8 fc fa ff ff       	call   801050c0 <argstr>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	85 c0                	test   %eax,%eax
801055c9:	0f 88 06 01 00 00    	js     801056d5 <sys_link+0x125>
801055cf:	83 ec 08             	sub    $0x8,%esp
801055d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055d5:	50                   	push   %eax
801055d6:	6a 01                	push   $0x1
801055d8:	e8 e3 fa ff ff       	call   801050c0 <argstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	0f 88 ed 00 00 00    	js     801056d5 <sys_link+0x125>
  begin_op();
801055e8:	e8 83 d8 ff ff       	call   80102e70 <begin_op>
  if ((ip = namei(old)) == 0)
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	ff 75 d4             	push   -0x2c(%ebp)
801055f3:	e8 98 cb ff ff       	call   80102190 <namei>
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	89 c3                	mov    %eax,%ebx
801055fd:	85 c0                	test   %eax,%eax
801055ff:	0f 84 ef 00 00 00    	je     801056f4 <sys_link+0x144>
  ilock(ip);
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	50                   	push   %eax
80105609:	e8 e2 c1 ff ff       	call   801017f0 <ilock>
  if (ip->type == T_DIR)
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80105618:	01 
80105619:	0f 84 bd 00 00 00    	je     801056dc <sys_link+0x12c>
  iupdate(ip);
8010561f:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105622:	66 83 83 a6 00 00 00 	addw   $0x1,0xa6(%ebx)
80105629:	01 
  if ((dp = nameiparent(new, name)) == 0)
8010562a:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010562d:	53                   	push   %ebx
8010562e:	e8 fd c0 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
80105633:	89 1c 24             	mov    %ebx,(%esp)
80105636:	e8 a5 c2 ff ff       	call   801018e0 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
8010563b:	58                   	pop    %eax
8010563c:	5a                   	pop    %edx
8010563d:	57                   	push   %edi
8010563e:	ff 75 d0             	push   -0x30(%ebp)
80105641:	e8 6a cb ff ff       	call   801021b0 <nameiparent>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	89 c6                	mov    %eax,%esi
8010564b:	85 c0                	test   %eax,%eax
8010564d:	74 5d                	je     801056ac <sys_link+0xfc>
  ilock(dp);
8010564f:	83 ec 0c             	sub    $0xc,%esp
80105652:	50                   	push   %eax
80105653:	e8 98 c1 ff ff       	call   801017f0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105658:	8b 03                	mov    (%ebx),%eax
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	39 06                	cmp    %eax,(%esi)
8010565f:	75 3f                	jne    801056a0 <sys_link+0xf0>
80105661:	83 ec 04             	sub    $0x4,%esp
80105664:	ff 73 04             	push   0x4(%ebx)
80105667:	57                   	push   %edi
80105668:	56                   	push   %esi
80105669:	e8 62 ca ff ff       	call   801020d0 <dirlink>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 2b                	js     801056a0 <sys_link+0xf0>
  iunlockput(dp);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	56                   	push   %esi
80105679:	e8 32 c4 ff ff       	call   80101ab0 <iunlockput>
  iput(ip);
8010567e:	89 1c 24             	mov    %ebx,(%esp)
80105681:	e8 aa c2 ff ff       	call   80101930 <iput>
  end_op();
80105686:	e8 55 d8 ff ff       	call   80102ee0 <end_op>
  return 0;
8010568b:	83 c4 10             	add    $0x10,%esp
8010568e:	31 c0                	xor    %eax,%eax
}
80105690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105693:	5b                   	pop    %ebx
80105694:	5e                   	pop    %esi
80105695:	5f                   	pop    %edi
80105696:	5d                   	pop    %ebp
80105697:	c3                   	ret    
80105698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
    iunlockput(dp);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	56                   	push   %esi
801056a4:	e8 07 c4 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
801056a9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	53                   	push   %ebx
801056b0:	e8 3b c1 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
801056b5:	66 83 ab a6 00 00 00 	subw   $0x1,0xa6(%ebx)
801056bc:	01 
  iupdate(ip);
801056bd:	89 1c 24             	mov    %ebx,(%esp)
801056c0:	e8 6b c0 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
801056c5:	89 1c 24             	mov    %ebx,(%esp)
801056c8:	e8 e3 c3 ff ff       	call   80101ab0 <iunlockput>
  end_op();
801056cd:	e8 0e d8 ff ff       	call   80102ee0 <end_op>
  return -1;
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056da:	eb b4                	jmp    80105690 <sys_link+0xe0>
    iunlockput(ip);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	53                   	push   %ebx
801056e0:	e8 cb c3 ff ff       	call   80101ab0 <iunlockput>
    end_op();
801056e5:	e8 f6 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f2:	eb 9c                	jmp    80105690 <sys_link+0xe0>
    end_op();
801056f4:	e8 e7 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
801056f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fe:	eb 90                	jmp    80105690 <sys_link+0xe0>

80105700 <sys_unlink>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105705:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 ac f9 ff ff       	call   801050c0 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 95 01 00 00    	js     801058b4 <sys_unlink+0x1b4>
  begin_op();
8010571f:	e8 4c d7 ff ff       	call   80102e70 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105724:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	53                   	push   %ebx
8010572b:	ff 75 c0             	push   -0x40(%ebp)
8010572e:	e8 7d ca ff ff       	call   801021b0 <nameiparent>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105739:	85 c0                	test   %eax,%eax
8010573b:	0f 84 7d 01 00 00    	je     801058be <sys_unlink+0x1be>
  ilock(dp);
80105741:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	57                   	push   %edi
80105748:	e8 a3 c0 ff ff       	call   801017f0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010574d:	58                   	pop    %eax
8010574e:	5a                   	pop    %edx
8010574f:	68 84 83 10 80       	push   $0x80108384
80105754:	53                   	push   %ebx
80105755:	e8 36 c6 ff ff       	call   80101d90 <namecmp>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 84 13 01 00 00    	je     80105878 <sys_unlink+0x178>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	68 83 83 10 80       	push   $0x80108383
8010576d:	53                   	push   %ebx
8010576e:	e8 1d c6 ff ff       	call   80101d90 <namecmp>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	0f 84 fa 00 00 00    	je     80105878 <sys_unlink+0x178>
  if ((ip = dirlookup(dp, name, &off)) == 0)
8010577e:	83 ec 04             	sub    $0x4,%esp
80105781:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105784:	50                   	push   %eax
80105785:	53                   	push   %ebx
80105786:	57                   	push   %edi
80105787:	e8 24 c6 ff ff       	call   80101db0 <dirlookup>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	89 c3                	mov    %eax,%ebx
80105791:	85 c0                	test   %eax,%eax
80105793:	0f 84 df 00 00 00    	je     80105878 <sys_unlink+0x178>
  ilock(ip);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 4e c0 ff ff       	call   801017f0 <ilock>
  if (ip->nlink < 1)
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
801057ac:	00 
801057ad:	0f 8e 34 01 00 00    	jle    801058e7 <sys_unlink+0x1e7>
  if (ip->type == T_DIR && !isdirempty(ip))
801057b3:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
801057ba:	01 
801057bb:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057be:	74 70                	je     80105830 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801057c0:	83 ec 04             	sub    $0x4,%esp
801057c3:	6a 10                	push   $0x10
801057c5:	6a 00                	push   $0x0
801057c7:	57                   	push   %edi
801057c8:	e8 73 f5 ff ff       	call   80104d40 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801057cd:	6a 10                	push   $0x10
801057cf:	ff 75 c4             	push   -0x3c(%ebp)
801057d2:	57                   	push   %edi
801057d3:	ff 75 b4             	push   -0x4c(%ebp)
801057d6:	e8 75 c4 ff ff       	call   80101c50 <writei>
801057db:	83 c4 20             	add    $0x20,%esp
801057de:	83 f8 10             	cmp    $0x10,%eax
801057e1:	0f 85 f3 00 00 00    	jne    801058da <sys_unlink+0x1da>
  if (ip->type == T_DIR)
801057e7:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
801057ee:	01 
801057ef:	0f 84 a3 00 00 00    	je     80105898 <sys_unlink+0x198>
  iunlockput(dp);
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	ff 75 b4             	push   -0x4c(%ebp)
801057fb:	e8 b0 c2 ff ff       	call   80101ab0 <iunlockput>
  ip->nlink--;
80105800:	66 83 ab a6 00 00 00 	subw   $0x1,0xa6(%ebx)
80105807:	01 
  iupdate(ip);
80105808:	89 1c 24             	mov    %ebx,(%esp)
8010580b:	e8 20 bf ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105810:	89 1c 24             	mov    %ebx,(%esp)
80105813:	e8 98 c2 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105818:	e8 c3 d6 ff ff       	call   80102ee0 <end_op>
  return 0;
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	31 c0                	xor    %eax,%eax
}
80105822:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105825:	5b                   	pop    %ebx
80105826:	5e                   	pop    %esi
80105827:	5f                   	pop    %edi
80105828:	5d                   	pop    %ebp
80105829:	c3                   	ret    
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105830:	83 bb a8 00 00 00 20 	cmpl   $0x20,0xa8(%ebx)
80105837:	76 87                	jbe    801057c0 <sys_unlink+0xc0>
80105839:	be 20 00 00 00       	mov    $0x20,%esi
8010583e:	eb 0f                	jmp    8010584f <sys_unlink+0x14f>
80105840:	83 c6 10             	add    $0x10,%esi
80105843:	3b b3 a8 00 00 00    	cmp    0xa8(%ebx),%esi
80105849:	0f 83 71 ff ff ff    	jae    801057c0 <sys_unlink+0xc0>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
8010584f:	6a 10                	push   $0x10
80105851:	56                   	push   %esi
80105852:	57                   	push   %edi
80105853:	53                   	push   %ebx
80105854:	e8 e7 c2 ff ff       	call   80101b40 <readi>
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	83 f8 10             	cmp    $0x10,%eax
8010585f:	75 6c                	jne    801058cd <sys_unlink+0x1cd>
    if (de.inum != 0)
80105861:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105866:	74 d8                	je     80105840 <sys_unlink+0x140>
    iunlockput(ip);
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	53                   	push   %ebx
8010586c:	e8 3f c2 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	ff 75 b4             	push   -0x4c(%ebp)
8010587e:	e8 2d c2 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105883:	e8 58 d6 ff ff       	call   80102ee0 <end_op>
  return -1;
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105890:	eb 90                	jmp    80105822 <sys_unlink+0x122>
80105892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105898:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010589b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
8010589e:	66 83 a8 a6 00 00 00 	subw   $0x1,0xa6(%eax)
801058a5:	01 
    iupdate(dp);
801058a6:	50                   	push   %eax
801058a7:	e8 84 be ff ff       	call   80101730 <iupdate>
801058ac:	83 c4 10             	add    $0x10,%esp
801058af:	e9 41 ff ff ff       	jmp    801057f5 <sys_unlink+0xf5>
    return -1;
801058b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b9:	e9 64 ff ff ff       	jmp    80105822 <sys_unlink+0x122>
    end_op();
801058be:	e8 1d d6 ff ff       	call   80102ee0 <end_op>
    return -1;
801058c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c8:	e9 55 ff ff ff       	jmp    80105822 <sys_unlink+0x122>
      panic("isdirempty: readi");
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	68 a8 83 10 80       	push   $0x801083a8
801058d5:	e8 f6 aa ff ff       	call   801003d0 <panic>
    panic("unlink: writei");
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	68 ba 83 10 80       	push   $0x801083ba
801058e2:	e8 e9 aa ff ff       	call   801003d0 <panic>
    panic("unlink: nlink < 1");
801058e7:	83 ec 0c             	sub    $0xc,%esp
801058ea:	68 96 83 10 80       	push   $0x80108396
801058ef:	e8 dc aa ff ff       	call   801003d0 <panic>
801058f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop

80105900 <sys_open>:

int sys_open(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105905:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105908:	53                   	push   %ebx
80105909:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010590c:	50                   	push   %eax
8010590d:	6a 00                	push   $0x0
8010590f:	e8 ac f7 ff ff       	call   801050c0 <argstr>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	85 c0                	test   %eax,%eax
80105919:	0f 88 9e 00 00 00    	js     801059bd <sys_open+0xbd>
8010591f:	83 ec 08             	sub    $0x8,%esp
80105922:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105925:	50                   	push   %eax
80105926:	6a 01                	push   $0x1
80105928:	e8 d3 f6 ff ff       	call   80105000 <argint>
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	85 c0                	test   %eax,%eax
80105932:	0f 88 85 00 00 00    	js     801059bd <sys_open+0xbd>
    return -1;

  begin_op();
80105938:	e8 33 d5 ff ff       	call   80102e70 <begin_op>

  if (omode & O_CREATE)
8010593d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105941:	0f 85 81 00 00 00    	jne    801059c8 <sys_open+0xc8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	ff 75 e0             	push   -0x20(%ebp)
8010594d:	e8 3e c8 ff ff       	call   80102190 <namei>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	89 c6                	mov    %eax,%esi
80105957:	85 c0                	test   %eax,%eax
80105959:	0f 84 86 00 00 00    	je     801059e5 <sys_open+0xe5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
8010595f:	83 ec 0c             	sub    $0xc,%esp
80105962:	50                   	push   %eax
80105963:	e8 88 be ff ff       	call   801017f0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105968:	83 c4 10             	add    $0x10,%esp
8010596b:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
80105972:	01 
80105973:	0f 84 c7 00 00 00    	je     80105a40 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105979:	e8 02 b5 ff ff       	call   80100e80 <filealloc>
8010597e:	89 c7                	mov    %eax,%edi
80105980:	85 c0                	test   %eax,%eax
80105982:	74 28                	je     801059ac <sys_open+0xac>
  struct proc *curproc = myproc();
80105984:	e8 57 e1 ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105989:	31 db                	xor    %ebx,%ebx
8010598b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
    if (curproc->ofile[fd] == 0)
80105990:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105994:	85 d2                	test   %edx,%edx
80105996:	74 60                	je     801059f8 <sys_open+0xf8>
  for (fd = 0; fd < NOFILE; fd++)
80105998:	83 c3 01             	add    $0x1,%ebx
8010599b:	83 fb 10             	cmp    $0x10,%ebx
8010599e:	75 f0                	jne    80105990 <sys_open+0x90>
  {
    if (f)
      fileclose(f);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	57                   	push   %edi
801059a4:	e8 97 b5 ff ff       	call   80100f40 <fileclose>
801059a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059ac:	83 ec 0c             	sub    $0xc,%esp
801059af:	56                   	push   %esi
801059b0:	e8 fb c0 ff ff       	call   80101ab0 <iunlockput>
    end_op();
801059b5:	e8 26 d5 ff ff       	call   80102ee0 <end_op>
    return -1;
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059c2:	eb 6d                	jmp    80105a31 <sys_open+0x131>
801059c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059ce:	31 c9                	xor    %ecx,%ecx
801059d0:	ba 02 00 00 00       	mov    $0x2,%edx
801059d5:	6a 00                	push   $0x0
801059d7:	e8 d4 f7 ff ff       	call   801051b0 <create>
    if (ip == 0)
801059dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059df:	89 c6                	mov    %eax,%esi
    if (ip == 0)
801059e1:	85 c0                	test   %eax,%eax
801059e3:	75 94                	jne    80105979 <sys_open+0x79>
      end_op();
801059e5:	e8 f6 d4 ff ff       	call   80102ee0 <end_op>
      return -1;
801059ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059ef:	eb 40                	jmp    80105a31 <sys_open+0x131>
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059ff:	56                   	push   %esi
80105a00:	e8 db be ff ff       	call   801018e0 <iunlock>
  end_op();
80105a05:	e8 d6 d4 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
80105a0a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a13:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a16:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a19:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a1b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a22:	f7 d0                	not    %eax
80105a24:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a27:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a2a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a2d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	89 d8                	mov    %ebx,%eax
80105a36:	5b                   	pop    %ebx
80105a37:	5e                   	pop    %esi
80105a38:	5f                   	pop    %edi
80105a39:	5d                   	pop    %ebp
80105a3a:	c3                   	ret    
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105a40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a43:	85 c9                	test   %ecx,%ecx
80105a45:	0f 84 2e ff ff ff    	je     80105979 <sys_open+0x79>
80105a4b:	e9 5c ff ff ff       	jmp    801059ac <sys_open+0xac>

80105a50 <sys_mkdir>:

int sys_mkdir(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a56:	e8 15 d4 ff ff       	call   80102e70 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105a5b:	83 ec 08             	sub    $0x8,%esp
80105a5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 57 f6 ff ff       	call   801050c0 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 30                	js     80105aa0 <sys_mkdir+0x50>
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a76:	31 c9                	xor    %ecx,%ecx
80105a78:	ba 01 00 00 00       	mov    $0x1,%edx
80105a7d:	6a 00                	push   $0x0
80105a7f:	e8 2c f7 ff ff       	call   801051b0 <create>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	74 15                	je     80105aa0 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8b:	83 ec 0c             	sub    $0xc,%esp
80105a8e:	50                   	push   %eax
80105a8f:	e8 1c c0 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105a94:	e8 47 d4 ff ff       	call   80102ee0 <end_op>
  return 0;
80105a99:	83 c4 10             	add    $0x10,%esp
80105a9c:	31 c0                	xor    %eax,%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    
    end_op();
80105aa0:	e8 3b d4 ff ff       	call   80102ee0 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_mknod>:

int sys_mknod(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ab6:	e8 b5 d3 ff ff       	call   80102e70 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105abb:	83 ec 08             	sub    $0x8,%esp
80105abe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac1:	50                   	push   %eax
80105ac2:	6a 00                	push   $0x0
80105ac4:	e8 f7 f5 ff ff       	call   801050c0 <argstr>
80105ac9:	83 c4 10             	add    $0x10,%esp
80105acc:	85 c0                	test   %eax,%eax
80105ace:	78 60                	js     80105b30 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad6:	50                   	push   %eax
80105ad7:	6a 01                	push   $0x1
80105ad9:	e8 22 f5 ff ff       	call   80105000 <argint>
  if ((argstr(0, &path)) < 0 ||
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	85 c0                	test   %eax,%eax
80105ae3:	78 4b                	js     80105b30 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aeb:	50                   	push   %eax
80105aec:	6a 02                	push   $0x2
80105aee:	e8 0d f5 ff ff       	call   80105000 <argint>
      argint(1, &major) < 0 ||
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 36                	js     80105b30 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105afa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105afe:	83 ec 0c             	sub    $0xc,%esp
80105b01:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b05:	ba 03 00 00 00       	mov    $0x3,%edx
80105b0a:	50                   	push   %eax
80105b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b0e:	e8 9d f6 ff ff       	call   801051b0 <create>
      argint(2, &minor) < 0 ||
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 c0                	test   %eax,%eax
80105b18:	74 16                	je     80105b30 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b1a:	83 ec 0c             	sub    $0xc,%esp
80105b1d:	50                   	push   %eax
80105b1e:	e8 8d bf ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105b23:	e8 b8 d3 ff ff       	call   80102ee0 <end_op>
  return 0;
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	31 c0                	xor    %eax,%eax
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop
    end_op();
80105b30:	e8 ab d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b3a:	c9                   	leave  
80105b3b:	c3                   	ret    
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_chdir>:

int sys_chdir(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	56                   	push   %esi
80105b44:	53                   	push   %ebx
80105b45:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b48:	e8 93 df ff ff       	call   80103ae0 <myproc>
80105b4d:	89 c6                	mov    %eax,%esi

  begin_op();
80105b4f:	e8 1c d3 ff ff       	call   80102e70 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105b54:	83 ec 08             	sub    $0x8,%esp
80105b57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5a:	50                   	push   %eax
80105b5b:	6a 00                	push   $0x0
80105b5d:	e8 5e f5 ff ff       	call   801050c0 <argstr>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 77                	js     80105be0 <sys_chdir+0xa0>
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	ff 75 f4             	push   -0xc(%ebp)
80105b6f:	e8 1c c6 ff ff       	call   80102190 <namei>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	89 c3                	mov    %eax,%ebx
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 63                	je     80105be0 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	50                   	push   %eax
80105b81:	e8 6a bc ff ff       	call   801017f0 <ilock>
  if (ip->type != T_DIR)
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80105b90:	01 
80105b91:	75 2d                	jne    80105bc0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b93:	83 ec 0c             	sub    $0xc,%esp
80105b96:	53                   	push   %ebx
80105b97:	e8 44 bd ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105b9c:	58                   	pop    %eax
80105b9d:	ff 76 68             	push   0x68(%esi)
80105ba0:	e8 8b bd ff ff       	call   80101930 <iput>
  end_op();
80105ba5:	e8 36 d3 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105baa:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	31 c0                	xor    %eax,%eax
}
80105bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb5:	5b                   	pop    %ebx
80105bb6:	5e                   	pop    %esi
80105bb7:	5d                   	pop    %ebp
80105bb8:	c3                   	ret    
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	53                   	push   %ebx
80105bc4:	e8 e7 be ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105bc9:	e8 12 d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	eb da                	jmp    80105bb2 <sys_chdir+0x72>
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    end_op();
80105be0:	e8 fb d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bea:	eb c6                	jmp    80105bb2 <sys_chdir+0x72>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_exec>:

int sys_exec(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105bf5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bfb:	53                   	push   %ebx
80105bfc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105c02:	50                   	push   %eax
80105c03:	6a 00                	push   $0x0
80105c05:	e8 b6 f4 ff ff       	call   801050c0 <argstr>
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	0f 88 87 00 00 00    	js     80105c9c <sys_exec+0xac>
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c1e:	50                   	push   %eax
80105c1f:	6a 01                	push   $0x1
80105c21:	e8 da f3 ff ff       	call   80105000 <argint>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	78 6f                	js     80105c9c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c2d:	83 ec 04             	sub    $0x4,%esp
80105c30:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80105c36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c38:	68 80 00 00 00       	push   $0x80
80105c3d:	6a 00                	push   $0x0
80105c3f:	56                   	push   %esi
80105c40:	e8 fb f0 ff ff       	call   80104d40 <memset>
80105c45:	83 c4 10             	add    $0x10,%esp
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105c50:	83 ec 08             	sub    $0x8,%esp
80105c53:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105c59:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105c60:	50                   	push   %eax
80105c61:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c67:	01 f8                	add    %edi,%eax
80105c69:	50                   	push   %eax
80105c6a:	e8 01 f3 ff ff       	call   80104f70 <fetchint>
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	85 c0                	test   %eax,%eax
80105c74:	78 26                	js     80105c9c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80105c76:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	74 30                	je     80105cb0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c86:	52                   	push   %edx
80105c87:	50                   	push   %eax
80105c88:	e8 23 f3 ff ff       	call   80104fb0 <fetchstr>
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	85 c0                	test   %eax,%eax
80105c92:	78 08                	js     80105c9c <sys_exec+0xac>
  for (i = 0;; i++)
80105c94:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105c97:	83 fb 20             	cmp    $0x20,%ebx
80105c9a:	75 b4                	jne    80105c50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105cb0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cb7:	00 00 00 00 
  return exec(path, argv);
80105cbb:	83 ec 08             	sub    $0x8,%esp
80105cbe:	56                   	push   %esi
80105cbf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105cc5:	e8 36 ae ff ff       	call   80100b00 <exec>
80105cca:	83 c4 10             	add    $0x10,%esp
}
80105ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd0:	5b                   	pop    %ebx
80105cd1:	5e                   	pop    %esi
80105cd2:	5f                   	pop    %edi
80105cd3:	5d                   	pop    %ebp
80105cd4:	c3                   	ret    
80105cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_pipe>:

int sys_pipe(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105ce5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ce8:	53                   	push   %ebx
80105ce9:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105cec:	6a 08                	push   $0x8
80105cee:	50                   	push   %eax
80105cef:	6a 00                	push   $0x0
80105cf1:	e8 5a f3 ff ff       	call   80105050 <argptr>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 4a                	js     80105d47 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105cfd:	83 ec 08             	sub    $0x8,%esp
80105d00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d03:	50                   	push   %eax
80105d04:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d07:	50                   	push   %eax
80105d08:	e8 33 d8 ff ff       	call   80103540 <pipealloc>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	78 33                	js     80105d47 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105d14:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80105d17:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d19:	e8 c2 dd ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d1e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105d20:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d24:	85 f6                	test   %esi,%esi
80105d26:	74 28                	je     80105d50 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80105d28:	83 c3 01             	add    $0x1,%ebx
80105d2b:	83 fb 10             	cmp    $0x10,%ebx
80105d2e:	75 f0                	jne    80105d20 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	ff 75 e0             	push   -0x20(%ebp)
80105d36:	e8 05 b2 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105d3b:	58                   	pop    %eax
80105d3c:	ff 75 e4             	push   -0x1c(%ebp)
80105d3f:	e8 fc b1 ff ff       	call   80100f40 <fileclose>
    return -1;
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4c:	eb 53                	jmp    80105da1 <sys_pipe+0xc1>
80105d4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d50:	8d 73 08             	lea    0x8(%ebx),%esi
80105d53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d5a:	e8 81 dd ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d5f:	31 d2                	xor    %edx,%edx
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105d68:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d6c:	85 c9                	test   %ecx,%ecx
80105d6e:	74 20                	je     80105d90 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80105d70:	83 c2 01             	add    $0x1,%edx
80105d73:	83 fa 10             	cmp    $0x10,%edx
80105d76:	75 f0                	jne    80105d68 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d78:	e8 63 dd ff ff       	call   80103ae0 <myproc>
80105d7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d84:	00 
80105d85:	eb a9                	jmp    80105d30 <sys_pipe+0x50>
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d90:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d97:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d9f:	31 c0                	xor    %eax,%eax
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_hello>:

int sys_hello(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hi! Welcome to the world of xv6!\n");
80105db6:	68 cc 83 10 80       	push   $0x801083cc
80105dbb:	e8 30 a9 ff ff       	call   801006f0 <cprintf>
  return 0;
}
80105dc0:	31 c0                	xor    %eax,%eax
80105dc2:	c9                   	leave  
80105dc3:	c3                   	ret    
80105dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop

80105dd0 <sys_helloYou>:
int sys_helloYou(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 18             	sub    $0x18,%esp
  // char *argv[MAXARG];
  char *path;
  begin_op();
80105dd6:	e8 95 d0 ff ff       	call   80102e70 <begin_op>
  argstr(0, &path);
80105ddb:	83 ec 08             	sub    $0x8,%esp
80105dde:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de1:	50                   	push   %eax
80105de2:	6a 00                	push   $0x0
80105de4:	e8 d7 f2 ff ff       	call   801050c0 <argstr>
  cprintf("this is the helloYou syscall called %s\n", path);
80105de9:	58                   	pop    %eax
80105dea:	5a                   	pop    %edx
80105deb:	ff 75 f4             	push   -0xc(%ebp)
80105dee:	68 f0 83 10 80       	push   $0x801083f0
80105df3:	e8 f8 a8 ff ff       	call   801006f0 <cprintf>
  end_op();
80105df8:	e8 e3 d0 ff ff       	call   80102ee0 <end_op>
  return 0;
}
80105dfd:	31 c0                	xor    %eax,%eax
80105dff:	c9                   	leave  
80105e00:	c3                   	ret    
80105e01:	66 90                	xchg   %ax,%ax
80105e03:	66 90                	xchg   %ax,%ax
80105e05:	66 90                	xchg   %ax,%ax
80105e07:	66 90                	xchg   %ax,%ax
80105e09:	66 90                	xchg   %ax,%ax
80105e0b:	66 90                	xchg   %ax,%ax
80105e0d:	66 90                	xchg   %ax,%ax
80105e0f:	90                   	nop

80105e10 <sys_fork>:
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
  return fork();
80105e10:	e9 6b de ff ff       	jmp    80103c80 <fork>
80105e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_exit>:
}

int sys_exit(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e26:	e8 d5 e0 ff ff       	call   80103f00 <exit>
  return 0; // not reached
}
80105e2b:	31 c0                	xor    %eax,%eax
80105e2d:	c9                   	leave  
80105e2e:	c3                   	ret    
80105e2f:	90                   	nop

80105e30 <sys_wait>:

int sys_wait(void)
{
  return wait();
80105e30:	e9 db e1 ff ff       	jmp    80104010 <wait>
80105e35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e40 <sys_kill>:
}

int sys_kill(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e49:	50                   	push   %eax
80105e4a:	6a 00                	push   $0x0
80105e4c:	e8 af f1 ff ff       	call   80105000 <argint>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	85 c0                	test   %eax,%eax
80105e56:	78 18                	js     80105e70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	ff 75 f4             	push   -0xc(%ebp)
80105e5e:	e8 4d e4 ff ff       	call   801042b0 <kill>
80105e63:	83 c4 10             	add    $0x10,%esp
}
80105e66:	c9                   	leave  
80105e67:	c3                   	ret    
80105e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
80105e70:	c9                   	leave  
    return -1;
80105e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e76:	c3                   	ret    
80105e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7e:	66 90                	xchg   %ax,%ax

80105e80 <sys_getpid>:

int sys_getpid(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e86:	e8 55 dc ff ff       	call   80103ae0 <myproc>
80105e8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e8e:	c9                   	leave  
80105e8f:	c3                   	ret    

80105e90 <sys_sbrk>:

int sys_sbrk(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80105e94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e97:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105e9a:	50                   	push   %eax
80105e9b:	6a 00                	push   $0x0
80105e9d:	e8 5e f1 ff ff       	call   80105000 <argint>
80105ea2:	83 c4 10             	add    $0x10,%esp
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	78 27                	js     80105ed0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ea9:	e8 32 dc ff ff       	call   80103ae0 <myproc>
  if (growproc(n) < 0)
80105eae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105eb1:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105eb3:	ff 75 f4             	push   -0xc(%ebp)
80105eb6:	e8 45 dd ff ff       	call   80103c00 <growproc>
80105ebb:	83 c4 10             	add    $0x10,%esp
80105ebe:	85 c0                	test   %eax,%eax
80105ec0:	78 0e                	js     80105ed0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ec2:	89 d8                	mov    %ebx,%eax
80105ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ec7:	c9                   	leave  
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ed0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ed5:	eb eb                	jmp    80105ec2 <sys_sbrk+0x32>
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_sleep>:

int sys_sleep(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ee7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105eea:	50                   	push   %eax
80105eeb:	6a 00                	push   $0x0
80105eed:	e8 0e f1 ff ff       	call   80105000 <argint>
80105ef2:	83 c4 10             	add    $0x10,%esp
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	0f 88 8a 00 00 00    	js     80105f87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105efd:	83 ec 0c             	sub    $0xc,%esp
80105f00:	68 60 69 11 80       	push   $0x80116960
80105f05:	e8 c6 eb ff ff       	call   80104ad0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80105f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f0d:	8b 1d 40 69 11 80    	mov    0x80116940,%ebx
  while (ticks - ticks0 < n)
80105f13:	83 c4 10             	add    $0x10,%esp
80105f16:	85 d2                	test   %edx,%edx
80105f18:	75 27                	jne    80105f41 <sys_sleep+0x61>
80105f1a:	eb 54                	jmp    80105f70 <sys_sleep+0x90>
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	68 60 69 11 80       	push   $0x80116960
80105f28:	68 40 69 11 80       	push   $0x80116940
80105f2d:	e8 5e e2 ff ff       	call   80104190 <sleep>
  while (ticks - ticks0 < n)
80105f32:	a1 40 69 11 80       	mov    0x80116940,%eax
80105f37:	83 c4 10             	add    $0x10,%esp
80105f3a:	29 d8                	sub    %ebx,%eax
80105f3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f3f:	73 2f                	jae    80105f70 <sys_sleep+0x90>
    if (myproc()->killed)
80105f41:	e8 9a db ff ff       	call   80103ae0 <myproc>
80105f46:	8b 40 24             	mov    0x24(%eax),%eax
80105f49:	85 c0                	test   %eax,%eax
80105f4b:	74 d3                	je     80105f20 <sys_sleep+0x40>
      release(&tickslock);
80105f4d:	83 ec 0c             	sub    $0xc,%esp
80105f50:	68 60 69 11 80       	push   $0x80116960
80105f55:	e8 16 eb ff ff       	call   80104a70 <release>
  }
  release(&tickslock);
  return 0;
}
80105f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	68 60 69 11 80       	push   $0x80116960
80105f78:	e8 f3 ea ff ff       	call   80104a70 <release>
  return 0;
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	31 c0                	xor    %eax,%eax
}
80105f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
    return -1;
80105f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8c:	eb f4                	jmp    80105f82 <sys_sleep+0xa2>
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	53                   	push   %ebx
80105f94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f97:	68 60 69 11 80       	push   $0x80116960
80105f9c:	e8 2f eb ff ff       	call   80104ad0 <acquire>
  xticks = ticks;
80105fa1:	8b 1d 40 69 11 80    	mov    0x80116940,%ebx
  release(&tickslock);
80105fa7:	c7 04 24 60 69 11 80 	movl   $0x80116960,(%esp)
80105fae:	e8 bd ea ff ff       	call   80104a70 <release>
  return xticks;
}
80105fb3:	89 d8                	mov    %ebx,%eax
80105fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fb8:	c9                   	leave  
80105fb9:	c3                   	ret    
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fc0 <sys_getppid>:
// {
//   return 0;   //commenting this line resolved the error
// }            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 20             	sub    $0x20,%esp
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
80105fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc9:	50                   	push   %eax
80105fca:	6a 00                	push   $0x0
80105fcc:	e8 2f f0 ff ff       	call   80105000 <argint>
80105fd1:	83 c4 10             	add    $0x10,%esp
80105fd4:	85 c0                	test   %eax,%eax
80105fd6:	78 08                	js     80105fe0 <sys_getppid+0x20>
   return -1;
  }
  return getppid();
80105fd8:	e8 13 e4 ff ff       	call   801043f0 <getppid>
}
80105fdd:	c9                   	leave  
80105fde:	c3                   	ret    
80105fdf:	90                   	nop
80105fe0:	c9                   	leave  
   return -1;
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_get_siblings_info>:

int sys_get_siblings_info(int pid){
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ff6:	e8 e5 da ff ff       	call   80103ae0 <myproc>
  
  return get_siblings_info(sys_getpid());
80105ffb:	8b 40 10             	mov    0x10(%eax),%eax
80105ffe:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106001:	c9                   	leave  
  return get_siblings_info(sys_getpid());
80106002:	e9 49 e4 ff ff       	jmp    80104450 <get_siblings_info>
80106007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_signalProcess>:
void sys_signalProcess(int pid,char type[]){
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 10             	sub    $0x10,%esp
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
80106016:	8d 45 08             	lea    0x8(%ebp),%eax
80106019:	50                   	push   %eax
8010601a:	6a 00                	push   $0x0
8010601c:	e8 df ef ff ff       	call   80105000 <argint>
  char **type1=&type;
  argstr(1,type1); 
80106021:	58                   	pop    %eax
80106022:	8d 45 0c             	lea    0xc(%ebp),%eax
80106025:	5a                   	pop    %edx
80106026:	50                   	push   %eax
80106027:	6a 01                	push   $0x1
80106029:	e8 92 f0 ff ff       	call   801050c0 <argstr>
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
8010602e:	59                   	pop    %ecx
8010602f:	58                   	pop    %eax
80106030:	ff 75 0c             	push   0xc(%ebp)
80106033:	ff 75 08             	push   0x8(%ebp)
80106036:	e8 65 e5 ff ff       	call   801045a0 <signalProcess>
}
8010603b:	83 c4 10             	add    $0x10,%esp
8010603e:	c9                   	leave  
8010603f:	c3                   	ret    

80106040 <sys_numvp>:

int sys_numvp(){
  return numvp();
80106040:	e9 9b e6 ff ff       	jmp    801046e0 <numvp>
80106045:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_numpp>:
}

int sys_numpp(){
  return numpp();
80106050:	e9 bb e6 ff ff       	jmp    80104710 <numpp>
80106055:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106060 <sys_init_counter>:
/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
80106060:	c7 05 30 69 11 80 00 	movl   $0x0,0x80116930
80106067:	00 00 00 
}
8010606a:	c3                   	ret    
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <sys_update_cnt>:

void sys_update_cnt(void){
  // acquire_mylock(0);
  counter = counter + 1;
80106070:	83 05 30 69 11 80 01 	addl   $0x1,0x80116930
  // cprintf("%d\n",holding_mylock(3));
  // release_mylock(0);
}
80106077:	c3                   	ret    
80106078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607f:	90                   	nop

80106080 <sys_display_count>:

int sys_display_count(void){
  return counter;
}
80106080:	a1 30 69 11 80       	mov    0x80116930,%eax
80106085:	c3                   	ret    
80106086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608d:	8d 76 00             	lea    0x0(%esi),%esi

80106090 <sys_init_counter_1>:
/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
80106090:	c7 05 2c 69 11 80 00 	movl   $0x0,0x8011692c
80106097:	00 00 00 
}
8010609a:	c3                   	ret    
8010609b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010609f:	90                   	nop

801060a0 <sys_update_cnt_1>:

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
801060a0:	83 05 2c 69 11 80 01 	addl   $0x1,0x8011692c
}
801060a7:	c3                   	ret    
801060a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop

801060b0 <sys_display_count_1>:

int sys_display_count_1(void){
  return counter_1;
}
801060b0:	a1 2c 69 11 80       	mov    0x8011692c,%eax
801060b5:	c3                   	ret    
801060b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bd:	8d 76 00             	lea    0x0(%esi),%esi

801060c0 <sys_init_counter_2>:
/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
801060c0:	c7 05 28 69 11 80 00 	movl   $0x0,0x80116928
801060c7:	00 00 00 
}
801060ca:	c3                   	ret    
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop

801060d0 <sys_update_cnt_2>:

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
801060d0:	83 05 28 69 11 80 01 	addl   $0x1,0x80116928
}
801060d7:	c3                   	ret    
801060d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060df:	90                   	nop

801060e0 <sys_display_count_2>:

int sys_display_count_2(void){
  return counter_2;
}
801060e0:	a1 28 69 11 80       	mov    0x80116928,%eax
801060e5:	c3                   	ret    
801060e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ed:	8d 76 00             	lea    0x0(%esi),%esi

801060f0 <sys_init_mylock>:

int sys_init_mylock(){
  return init_mylock();
801060f0:	e9 2b e6 ff ff       	jmp    80104720 <init_mylock>
801060f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106100 <sys_acquire_mylock>:
}

int sys_acquire_mylock(int id){
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80106106:	8d 45 08             	lea    0x8(%ebp),%eax
80106109:	50                   	push   %eax
8010610a:	6a 00                	push   $0x0
8010610c:	e8 ef ee ff ff       	call   80105000 <argint>
  return acquire_mylock(id);
80106111:	58                   	pop    %eax
80106112:	ff 75 08             	push   0x8(%ebp)
80106115:	e8 26 e6 ff ff       	call   80104740 <acquire_mylock>
}
8010611a:	c9                   	leave  
8010611b:	c3                   	ret    
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106120 <sys_release_mylock>:

int sys_release_mylock(int id){
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80106126:	8d 45 08             	lea    0x8(%ebp),%eax
80106129:	50                   	push   %eax
8010612a:	6a 00                	push   $0x0
8010612c:	e8 cf ee ff ff       	call   80105000 <argint>
  return release_mylock(id);
80106131:	58                   	pop    %eax
80106132:	ff 75 08             	push   0x8(%ebp)
80106135:	e8 36 e6 ff ff       	call   80104770 <release_mylock>
}
8010613a:	c9                   	leave  
8010613b:	c3                   	ret    
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106140 <sys_holding_mylock>:

int sys_holding_mylock(int id){
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80106146:	8d 45 08             	lea    0x8(%ebp),%eax
80106149:	50                   	push   %eax
8010614a:	6a 00                	push   $0x0
8010614c:	e8 af ee ff ff       	call   80105000 <argint>
  return holding_mylock(id);
80106151:	58                   	pop    %eax
80106152:	ff 75 08             	push   0x8(%ebp)
80106155:	e8 46 e6 ff ff       	call   801047a0 <holding_mylock>
8010615a:	c9                   	leave  
8010615b:	c3                   	ret    

8010615c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010615c:	1e                   	push   %ds
  pushl %es
8010615d:	06                   	push   %es
  pushl %fs
8010615e:	0f a0                	push   %fs
  pushl %gs
80106160:	0f a8                	push   %gs
  pushal
80106162:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106163:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106167:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106169:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010616b:	54                   	push   %esp
  call trap
8010616c:	e8 bf 00 00 00       	call   80106230 <trap>
  addl $4, %esp
80106171:	83 c4 04             	add    $0x4,%esp

80106174 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106174:	61                   	popa   
  popl %gs
80106175:	0f a9                	pop    %gs
  popl %fs
80106177:	0f a1                	pop    %fs
  popl %es
80106179:	07                   	pop    %es
  popl %ds
8010617a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010617b:	83 c4 08             	add    $0x8,%esp
  iret
8010617e:	cf                   	iret   
8010617f:	90                   	nop

80106180 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106180:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106181:	31 c0                	xor    %eax,%eax
{
80106183:	89 e5                	mov    %esp,%ebp
80106185:	83 ec 08             	sub    $0x8,%esp
80106188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106190:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106197:	c7 04 c5 02 6a 11 80 	movl   $0x8e000008,-0x7fee95fe(,%eax,8)
8010619e:	08 00 00 8e 
801061a2:	66 89 14 c5 00 6a 11 	mov    %dx,-0x7fee9600(,%eax,8)
801061a9:	80 
801061aa:	c1 ea 10             	shr    $0x10,%edx
801061ad:	66 89 14 c5 06 6a 11 	mov    %dx,-0x7fee95fa(,%eax,8)
801061b4:	80 
  for(i = 0; i < 256; i++)
801061b5:	83 c0 01             	add    $0x1,%eax
801061b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061bd:	75 d1                	jne    80106190 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061c2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061c7:	c7 05 02 6c 11 80 08 	movl   $0xef000008,0x80116c02
801061ce:	00 00 ef 
  initlock(&tickslock, "time");
801061d1:	68 18 84 10 80       	push   $0x80108418
801061d6:	68 60 69 11 80       	push   $0x80116960
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061db:	66 a3 00 6c 11 80    	mov    %ax,0x80116c00
801061e1:	c1 e8 10             	shr    $0x10,%eax
801061e4:	66 a3 06 6c 11 80    	mov    %ax,0x80116c06
  initlock(&tickslock, "time");
801061ea:	e8 11 e7 ff ff       	call   80104900 <initlock>
}
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	c9                   	leave  
801061f3:	c3                   	ret    
801061f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ff:	90                   	nop

80106200 <idtinit>:

void
idtinit(void)
{
80106200:	55                   	push   %ebp
  pd[0] = size-1;
80106201:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106206:	89 e5                	mov    %esp,%ebp
80106208:	83 ec 10             	sub    $0x10,%esp
8010620b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010620f:	b8 00 6a 11 80       	mov    $0x80116a00,%eax
80106214:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106218:	c1 e8 10             	shr    $0x10,%eax
8010621b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010621f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106222:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106225:	c9                   	leave  
80106226:	c3                   	ret    
80106227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622e:	66 90                	xchg   %ax,%ax

80106230 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	56                   	push   %esi
80106235:	53                   	push   %ebx
80106236:	83 ec 1c             	sub    $0x1c,%esp
80106239:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010623c:	8b 43 30             	mov    0x30(%ebx),%eax
8010623f:	83 f8 40             	cmp    $0x40,%eax
80106242:	0f 84 68 01 00 00    	je     801063b0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106248:	83 e8 20             	sub    $0x20,%eax
8010624b:	83 f8 1f             	cmp    $0x1f,%eax
8010624e:	0f 87 8c 00 00 00    	ja     801062e0 <trap+0xb0>
80106254:	ff 24 85 c0 84 10 80 	jmp    *-0x7fef7b40(,%eax,4)
8010625b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010625f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106260:	e8 cb c0 ff ff       	call   80102330 <ideintr>
    lapiceoi();
80106265:	e8 a6 c7 ff ff       	call   80102a10 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010626a:	e8 71 d8 ff ff       	call   80103ae0 <myproc>
8010626f:	85 c0                	test   %eax,%eax
80106271:	74 1d                	je     80106290 <trap+0x60>
80106273:	e8 68 d8 ff ff       	call   80103ae0 <myproc>
80106278:	8b 50 24             	mov    0x24(%eax),%edx
8010627b:	85 d2                	test   %edx,%edx
8010627d:	74 11                	je     80106290 <trap+0x60>
8010627f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106283:	83 e0 03             	and    $0x3,%eax
80106286:	66 83 f8 03          	cmp    $0x3,%ax
8010628a:	0f 84 e8 01 00 00    	je     80106478 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106290:	e8 4b d8 ff ff       	call   80103ae0 <myproc>
80106295:	85 c0                	test   %eax,%eax
80106297:	74 0f                	je     801062a8 <trap+0x78>
80106299:	e8 42 d8 ff ff       	call   80103ae0 <myproc>
8010629e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062a2:	0f 84 b8 00 00 00    	je     80106360 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062a8:	e8 33 d8 ff ff       	call   80103ae0 <myproc>
801062ad:	85 c0                	test   %eax,%eax
801062af:	74 1d                	je     801062ce <trap+0x9e>
801062b1:	e8 2a d8 ff ff       	call   80103ae0 <myproc>
801062b6:	8b 40 24             	mov    0x24(%eax),%eax
801062b9:	85 c0                	test   %eax,%eax
801062bb:	74 11                	je     801062ce <trap+0x9e>
801062bd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062c1:	83 e0 03             	and    $0x3,%eax
801062c4:	66 83 f8 03          	cmp    $0x3,%ax
801062c8:	0f 84 0f 01 00 00    	je     801063dd <trap+0x1ad>
    exit();
}
801062ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d1:	5b                   	pop    %ebx
801062d2:	5e                   	pop    %esi
801062d3:	5f                   	pop    %edi
801062d4:	5d                   	pop    %ebp
801062d5:	c3                   	ret    
801062d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801062e0:	e8 fb d7 ff ff       	call   80103ae0 <myproc>
801062e5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062e8:	85 c0                	test   %eax,%eax
801062ea:	0f 84 a2 01 00 00    	je     80106492 <trap+0x262>
801062f0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062f4:	0f 84 98 01 00 00    	je     80106492 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062fa:	0f 20 d1             	mov    %cr2,%ecx
801062fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106300:	e8 bb d7 ff ff       	call   80103ac0 <cpuid>
80106305:	8b 73 30             	mov    0x30(%ebx),%esi
80106308:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010630b:	8b 43 34             	mov    0x34(%ebx),%eax
8010630e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106311:	e8 ca d7 ff ff       	call   80103ae0 <myproc>
80106316:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106319:	e8 c2 d7 ff ff       	call   80103ae0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010631e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106321:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106324:	51                   	push   %ecx
80106325:	57                   	push   %edi
80106326:	52                   	push   %edx
80106327:	ff 75 e4             	push   -0x1c(%ebp)
8010632a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010632b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010632e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106331:	56                   	push   %esi
80106332:	ff 70 10             	push   0x10(%eax)
80106335:	68 7c 84 10 80       	push   $0x8010847c
8010633a:	e8 b1 a3 ff ff       	call   801006f0 <cprintf>
    myproc()->killed = 1;
8010633f:	83 c4 20             	add    $0x20,%esp
80106342:	e8 99 d7 ff ff       	call   80103ae0 <myproc>
80106347:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010634e:	e8 8d d7 ff ff       	call   80103ae0 <myproc>
80106353:	85 c0                	test   %eax,%eax
80106355:	0f 85 18 ff ff ff    	jne    80106273 <trap+0x43>
8010635b:	e9 30 ff ff ff       	jmp    80106290 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106360:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106364:	0f 85 3e ff ff ff    	jne    801062a8 <trap+0x78>
    yield();
8010636a:	e8 d1 dd ff ff       	call   80104140 <yield>
8010636f:	e9 34 ff ff ff       	jmp    801062a8 <trap+0x78>
80106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106378:	8b 7b 38             	mov    0x38(%ebx),%edi
8010637b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010637f:	e8 3c d7 ff ff       	call   80103ac0 <cpuid>
80106384:	57                   	push   %edi
80106385:	56                   	push   %esi
80106386:	50                   	push   %eax
80106387:	68 24 84 10 80       	push   $0x80108424
8010638c:	e8 5f a3 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106391:	e8 7a c6 ff ff       	call   80102a10 <lapiceoi>
    break;
80106396:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106399:	e8 42 d7 ff ff       	call   80103ae0 <myproc>
8010639e:	85 c0                	test   %eax,%eax
801063a0:	0f 85 cd fe ff ff    	jne    80106273 <trap+0x43>
801063a6:	e9 e5 fe ff ff       	jmp    80106290 <trap+0x60>
801063ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063af:	90                   	nop
    if(myproc()->killed)
801063b0:	e8 2b d7 ff ff       	call   80103ae0 <myproc>
801063b5:	8b 70 24             	mov    0x24(%eax),%esi
801063b8:	85 f6                	test   %esi,%esi
801063ba:	0f 85 c8 00 00 00    	jne    80106488 <trap+0x258>
    myproc()->tf = tf;
801063c0:	e8 1b d7 ff ff       	call   80103ae0 <myproc>
801063c5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063c8:	e8 73 ed ff ff       	call   80105140 <syscall>
    if(myproc()->killed)
801063cd:	e8 0e d7 ff ff       	call   80103ae0 <myproc>
801063d2:	8b 48 24             	mov    0x24(%eax),%ecx
801063d5:	85 c9                	test   %ecx,%ecx
801063d7:	0f 84 f1 fe ff ff    	je     801062ce <trap+0x9e>
}
801063dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e0:	5b                   	pop    %ebx
801063e1:	5e                   	pop    %esi
801063e2:	5f                   	pop    %edi
801063e3:	5d                   	pop    %ebp
      exit();
801063e4:	e9 17 db ff ff       	jmp    80103f00 <exit>
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801063f0:	e8 3b 02 00 00       	call   80106630 <uartintr>
    lapiceoi();
801063f5:	e8 16 c6 ff ff       	call   80102a10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063fa:	e8 e1 d6 ff ff       	call   80103ae0 <myproc>
801063ff:	85 c0                	test   %eax,%eax
80106401:	0f 85 6c fe ff ff    	jne    80106273 <trap+0x43>
80106407:	e9 84 fe ff ff       	jmp    80106290 <trap+0x60>
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106410:	e8 bb c4 ff ff       	call   801028d0 <kbdintr>
    lapiceoi();
80106415:	e8 f6 c5 ff ff       	call   80102a10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010641a:	e8 c1 d6 ff ff       	call   80103ae0 <myproc>
8010641f:	85 c0                	test   %eax,%eax
80106421:	0f 85 4c fe ff ff    	jne    80106273 <trap+0x43>
80106427:	e9 64 fe ff ff       	jmp    80106290 <trap+0x60>
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106430:	e8 8b d6 ff ff       	call   80103ac0 <cpuid>
80106435:	85 c0                	test   %eax,%eax
80106437:	0f 85 28 fe ff ff    	jne    80106265 <trap+0x35>
      acquire(&tickslock);
8010643d:	83 ec 0c             	sub    $0xc,%esp
80106440:	68 60 69 11 80       	push   $0x80116960
80106445:	e8 86 e6 ff ff       	call   80104ad0 <acquire>
      wakeup(&ticks);
8010644a:	c7 04 24 40 69 11 80 	movl   $0x80116940,(%esp)
      ticks++;
80106451:	83 05 40 69 11 80 01 	addl   $0x1,0x80116940
      wakeup(&ticks);
80106458:	e8 f3 dd ff ff       	call   80104250 <wakeup>
      release(&tickslock);
8010645d:	c7 04 24 60 69 11 80 	movl   $0x80116960,(%esp)
80106464:	e8 07 e6 ff ff       	call   80104a70 <release>
80106469:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010646c:	e9 f4 fd ff ff       	jmp    80106265 <trap+0x35>
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106478:	e8 83 da ff ff       	call   80103f00 <exit>
8010647d:	e9 0e fe ff ff       	jmp    80106290 <trap+0x60>
80106482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106488:	e8 73 da ff ff       	call   80103f00 <exit>
8010648d:	e9 2e ff ff ff       	jmp    801063c0 <trap+0x190>
80106492:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106495:	e8 26 d6 ff ff       	call   80103ac0 <cpuid>
8010649a:	83 ec 0c             	sub    $0xc,%esp
8010649d:	56                   	push   %esi
8010649e:	57                   	push   %edi
8010649f:	50                   	push   %eax
801064a0:	ff 73 30             	push   0x30(%ebx)
801064a3:	68 48 84 10 80       	push   $0x80108448
801064a8:	e8 43 a2 ff ff       	call   801006f0 <cprintf>
      panic("trap");
801064ad:	83 c4 14             	add    $0x14,%esp
801064b0:	68 1d 84 10 80       	push   $0x8010841d
801064b5:	e8 16 9f ff ff       	call   801003d0 <panic>
801064ba:	66 90                	xchg   %ax,%ax
801064bc:	66 90                	xchg   %ax,%ax
801064be:	66 90                	xchg   %ax,%ax

801064c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064c0:	a1 00 72 11 80       	mov    0x80117200,%eax
801064c5:	85 c0                	test   %eax,%eax
801064c7:	74 17                	je     801064e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064c9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064ce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064cf:	a8 01                	test   $0x1,%al
801064d1:	74 0d                	je     801064e0 <uartgetc+0x20>
801064d3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064d9:	0f b6 c0             	movzbl %al,%eax
801064dc:	c3                   	ret    
801064dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064e5:	c3                   	ret    
801064e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ed:	8d 76 00             	lea    0x0(%esi),%esi

801064f0 <uartinit>:
{
801064f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064f1:	31 c9                	xor    %ecx,%ecx
801064f3:	89 c8                	mov    %ecx,%eax
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	57                   	push   %edi
801064f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801064fd:	56                   	push   %esi
801064fe:	89 fa                	mov    %edi,%edx
80106500:	53                   	push   %ebx
80106501:	83 ec 1c             	sub    $0x1c,%esp
80106504:	ee                   	out    %al,(%dx)
80106505:	be fb 03 00 00       	mov    $0x3fb,%esi
8010650a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010650f:	89 f2                	mov    %esi,%edx
80106511:	ee                   	out    %al,(%dx)
80106512:	b8 0c 00 00 00       	mov    $0xc,%eax
80106517:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010651c:	ee                   	out    %al,(%dx)
8010651d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106522:	89 c8                	mov    %ecx,%eax
80106524:	89 da                	mov    %ebx,%edx
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 03 00 00 00       	mov    $0x3,%eax
8010652c:	89 f2                	mov    %esi,%edx
8010652e:	ee                   	out    %al,(%dx)
8010652f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106534:	89 c8                	mov    %ecx,%eax
80106536:	ee                   	out    %al,(%dx)
80106537:	b8 01 00 00 00       	mov    $0x1,%eax
8010653c:	89 da                	mov    %ebx,%edx
8010653e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010653f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106544:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106545:	3c ff                	cmp    $0xff,%al
80106547:	74 78                	je     801065c1 <uartinit+0xd1>
  uart = 1;
80106549:	c7 05 00 72 11 80 01 	movl   $0x1,0x80117200
80106550:	00 00 00 
80106553:	89 fa                	mov    %edi,%edx
80106555:	ec                   	in     (%dx),%al
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010655c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010655f:	bf 40 85 10 80       	mov    $0x80108540,%edi
80106564:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106569:	6a 00                	push   $0x0
8010656b:	6a 04                	push   $0x4
8010656d:	e8 0e c0 ff ff       	call   80102580 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106572:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106576:	83 c4 10             	add    $0x10,%esp
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106580:	a1 00 72 11 80       	mov    0x80117200,%eax
80106585:	bb 80 00 00 00       	mov    $0x80,%ebx
8010658a:	85 c0                	test   %eax,%eax
8010658c:	75 14                	jne    801065a2 <uartinit+0xb2>
8010658e:	eb 23                	jmp    801065b3 <uartinit+0xc3>
    microdelay(10);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	6a 0a                	push   $0xa
80106595:	e8 96 c4 ff ff       	call   80102a30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	83 eb 01             	sub    $0x1,%ebx
801065a0:	74 07                	je     801065a9 <uartinit+0xb9>
801065a2:	89 f2                	mov    %esi,%edx
801065a4:	ec                   	in     (%dx),%al
801065a5:	a8 20                	test   $0x20,%al
801065a7:	74 e7                	je     80106590 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801065ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065b7:	83 c7 01             	add    $0x1,%edi
801065ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801065bd:	84 c0                	test   %al,%al
801065bf:	75 bf                	jne    80106580 <uartinit+0x90>
}
801065c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c4:	5b                   	pop    %ebx
801065c5:	5e                   	pop    %esi
801065c6:	5f                   	pop    %edi
801065c7:	5d                   	pop    %ebp
801065c8:	c3                   	ret    
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <uartputc>:
  if(!uart)
801065d0:	a1 00 72 11 80       	mov    0x80117200,%eax
801065d5:	85 c0                	test   %eax,%eax
801065d7:	74 47                	je     80106620 <uartputc+0x50>
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801065e2:	53                   	push   %ebx
801065e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801065e8:	eb 18                	jmp    80106602 <uartputc+0x32>
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	6a 0a                	push   $0xa
801065f5:	e8 36 c4 ff ff       	call   80102a30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065fa:	83 c4 10             	add    $0x10,%esp
801065fd:	83 eb 01             	sub    $0x1,%ebx
80106600:	74 07                	je     80106609 <uartputc+0x39>
80106602:	89 f2                	mov    %esi,%edx
80106604:	ec                   	in     (%dx),%al
80106605:	a8 20                	test   $0x20,%al
80106607:	74 e7                	je     801065f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106609:	8b 45 08             	mov    0x8(%ebp),%eax
8010660c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106611:	ee                   	out    %al,(%dx)
}
80106612:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106615:	5b                   	pop    %ebx
80106616:	5e                   	pop    %esi
80106617:	5d                   	pop    %ebp
80106618:	c3                   	ret    
80106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106620:	c3                   	ret    
80106621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop

80106630 <uartintr>:

void
uartintr(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106636:	68 c0 64 10 80       	push   $0x801064c0
8010663b:	e8 90 a2 ff ff       	call   801008d0 <consoleintr>
}
80106640:	83 c4 10             	add    $0x10,%esp
80106643:	c9                   	leave  
80106644:	c3                   	ret    

80106645 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $0
80106647:	6a 00                	push   $0x0
  jmp alltraps
80106649:	e9 0e fb ff ff       	jmp    8010615c <alltraps>

8010664e <vector1>:
.globl vector1
vector1:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $1
80106650:	6a 01                	push   $0x1
  jmp alltraps
80106652:	e9 05 fb ff ff       	jmp    8010615c <alltraps>

80106657 <vector2>:
.globl vector2
vector2:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $2
80106659:	6a 02                	push   $0x2
  jmp alltraps
8010665b:	e9 fc fa ff ff       	jmp    8010615c <alltraps>

80106660 <vector3>:
.globl vector3
vector3:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $3
80106662:	6a 03                	push   $0x3
  jmp alltraps
80106664:	e9 f3 fa ff ff       	jmp    8010615c <alltraps>

80106669 <vector4>:
.globl vector4
vector4:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $4
8010666b:	6a 04                	push   $0x4
  jmp alltraps
8010666d:	e9 ea fa ff ff       	jmp    8010615c <alltraps>

80106672 <vector5>:
.globl vector5
vector5:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $5
80106674:	6a 05                	push   $0x5
  jmp alltraps
80106676:	e9 e1 fa ff ff       	jmp    8010615c <alltraps>

8010667b <vector6>:
.globl vector6
vector6:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $6
8010667d:	6a 06                	push   $0x6
  jmp alltraps
8010667f:	e9 d8 fa ff ff       	jmp    8010615c <alltraps>

80106684 <vector7>:
.globl vector7
vector7:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $7
80106686:	6a 07                	push   $0x7
  jmp alltraps
80106688:	e9 cf fa ff ff       	jmp    8010615c <alltraps>

8010668d <vector8>:
.globl vector8
vector8:
  pushl $8
8010668d:	6a 08                	push   $0x8
  jmp alltraps
8010668f:	e9 c8 fa ff ff       	jmp    8010615c <alltraps>

80106694 <vector9>:
.globl vector9
vector9:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $9
80106696:	6a 09                	push   $0x9
  jmp alltraps
80106698:	e9 bf fa ff ff       	jmp    8010615c <alltraps>

8010669d <vector10>:
.globl vector10
vector10:
  pushl $10
8010669d:	6a 0a                	push   $0xa
  jmp alltraps
8010669f:	e9 b8 fa ff ff       	jmp    8010615c <alltraps>

801066a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066a4:	6a 0b                	push   $0xb
  jmp alltraps
801066a6:	e9 b1 fa ff ff       	jmp    8010615c <alltraps>

801066ab <vector12>:
.globl vector12
vector12:
  pushl $12
801066ab:	6a 0c                	push   $0xc
  jmp alltraps
801066ad:	e9 aa fa ff ff       	jmp    8010615c <alltraps>

801066b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066b2:	6a 0d                	push   $0xd
  jmp alltraps
801066b4:	e9 a3 fa ff ff       	jmp    8010615c <alltraps>

801066b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066b9:	6a 0e                	push   $0xe
  jmp alltraps
801066bb:	e9 9c fa ff ff       	jmp    8010615c <alltraps>

801066c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $15
801066c2:	6a 0f                	push   $0xf
  jmp alltraps
801066c4:	e9 93 fa ff ff       	jmp    8010615c <alltraps>

801066c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $16
801066cb:	6a 10                	push   $0x10
  jmp alltraps
801066cd:	e9 8a fa ff ff       	jmp    8010615c <alltraps>

801066d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066d2:	6a 11                	push   $0x11
  jmp alltraps
801066d4:	e9 83 fa ff ff       	jmp    8010615c <alltraps>

801066d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $18
801066db:	6a 12                	push   $0x12
  jmp alltraps
801066dd:	e9 7a fa ff ff       	jmp    8010615c <alltraps>

801066e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $19
801066e4:	6a 13                	push   $0x13
  jmp alltraps
801066e6:	e9 71 fa ff ff       	jmp    8010615c <alltraps>

801066eb <vector20>:
.globl vector20
vector20:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $20
801066ed:	6a 14                	push   $0x14
  jmp alltraps
801066ef:	e9 68 fa ff ff       	jmp    8010615c <alltraps>

801066f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $21
801066f6:	6a 15                	push   $0x15
  jmp alltraps
801066f8:	e9 5f fa ff ff       	jmp    8010615c <alltraps>

801066fd <vector22>:
.globl vector22
vector22:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $22
801066ff:	6a 16                	push   $0x16
  jmp alltraps
80106701:	e9 56 fa ff ff       	jmp    8010615c <alltraps>

80106706 <vector23>:
.globl vector23
vector23:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $23
80106708:	6a 17                	push   $0x17
  jmp alltraps
8010670a:	e9 4d fa ff ff       	jmp    8010615c <alltraps>

8010670f <vector24>:
.globl vector24
vector24:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $24
80106711:	6a 18                	push   $0x18
  jmp alltraps
80106713:	e9 44 fa ff ff       	jmp    8010615c <alltraps>

80106718 <vector25>:
.globl vector25
vector25:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $25
8010671a:	6a 19                	push   $0x19
  jmp alltraps
8010671c:	e9 3b fa ff ff       	jmp    8010615c <alltraps>

80106721 <vector26>:
.globl vector26
vector26:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $26
80106723:	6a 1a                	push   $0x1a
  jmp alltraps
80106725:	e9 32 fa ff ff       	jmp    8010615c <alltraps>

8010672a <vector27>:
.globl vector27
vector27:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $27
8010672c:	6a 1b                	push   $0x1b
  jmp alltraps
8010672e:	e9 29 fa ff ff       	jmp    8010615c <alltraps>

80106733 <vector28>:
.globl vector28
vector28:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $28
80106735:	6a 1c                	push   $0x1c
  jmp alltraps
80106737:	e9 20 fa ff ff       	jmp    8010615c <alltraps>

8010673c <vector29>:
.globl vector29
vector29:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $29
8010673e:	6a 1d                	push   $0x1d
  jmp alltraps
80106740:	e9 17 fa ff ff       	jmp    8010615c <alltraps>

80106745 <vector30>:
.globl vector30
vector30:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $30
80106747:	6a 1e                	push   $0x1e
  jmp alltraps
80106749:	e9 0e fa ff ff       	jmp    8010615c <alltraps>

8010674e <vector31>:
.globl vector31
vector31:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $31
80106750:	6a 1f                	push   $0x1f
  jmp alltraps
80106752:	e9 05 fa ff ff       	jmp    8010615c <alltraps>

80106757 <vector32>:
.globl vector32
vector32:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $32
80106759:	6a 20                	push   $0x20
  jmp alltraps
8010675b:	e9 fc f9 ff ff       	jmp    8010615c <alltraps>

80106760 <vector33>:
.globl vector33
vector33:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $33
80106762:	6a 21                	push   $0x21
  jmp alltraps
80106764:	e9 f3 f9 ff ff       	jmp    8010615c <alltraps>

80106769 <vector34>:
.globl vector34
vector34:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $34
8010676b:	6a 22                	push   $0x22
  jmp alltraps
8010676d:	e9 ea f9 ff ff       	jmp    8010615c <alltraps>

80106772 <vector35>:
.globl vector35
vector35:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $35
80106774:	6a 23                	push   $0x23
  jmp alltraps
80106776:	e9 e1 f9 ff ff       	jmp    8010615c <alltraps>

8010677b <vector36>:
.globl vector36
vector36:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $36
8010677d:	6a 24                	push   $0x24
  jmp alltraps
8010677f:	e9 d8 f9 ff ff       	jmp    8010615c <alltraps>

80106784 <vector37>:
.globl vector37
vector37:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $37
80106786:	6a 25                	push   $0x25
  jmp alltraps
80106788:	e9 cf f9 ff ff       	jmp    8010615c <alltraps>

8010678d <vector38>:
.globl vector38
vector38:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $38
8010678f:	6a 26                	push   $0x26
  jmp alltraps
80106791:	e9 c6 f9 ff ff       	jmp    8010615c <alltraps>

80106796 <vector39>:
.globl vector39
vector39:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $39
80106798:	6a 27                	push   $0x27
  jmp alltraps
8010679a:	e9 bd f9 ff ff       	jmp    8010615c <alltraps>

8010679f <vector40>:
.globl vector40
vector40:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $40
801067a1:	6a 28                	push   $0x28
  jmp alltraps
801067a3:	e9 b4 f9 ff ff       	jmp    8010615c <alltraps>

801067a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $41
801067aa:	6a 29                	push   $0x29
  jmp alltraps
801067ac:	e9 ab f9 ff ff       	jmp    8010615c <alltraps>

801067b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $42
801067b3:	6a 2a                	push   $0x2a
  jmp alltraps
801067b5:	e9 a2 f9 ff ff       	jmp    8010615c <alltraps>

801067ba <vector43>:
.globl vector43
vector43:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $43
801067bc:	6a 2b                	push   $0x2b
  jmp alltraps
801067be:	e9 99 f9 ff ff       	jmp    8010615c <alltraps>

801067c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $44
801067c5:	6a 2c                	push   $0x2c
  jmp alltraps
801067c7:	e9 90 f9 ff ff       	jmp    8010615c <alltraps>

801067cc <vector45>:
.globl vector45
vector45:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $45
801067ce:	6a 2d                	push   $0x2d
  jmp alltraps
801067d0:	e9 87 f9 ff ff       	jmp    8010615c <alltraps>

801067d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $46
801067d7:	6a 2e                	push   $0x2e
  jmp alltraps
801067d9:	e9 7e f9 ff ff       	jmp    8010615c <alltraps>

801067de <vector47>:
.globl vector47
vector47:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $47
801067e0:	6a 2f                	push   $0x2f
  jmp alltraps
801067e2:	e9 75 f9 ff ff       	jmp    8010615c <alltraps>

801067e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $48
801067e9:	6a 30                	push   $0x30
  jmp alltraps
801067eb:	e9 6c f9 ff ff       	jmp    8010615c <alltraps>

801067f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $49
801067f2:	6a 31                	push   $0x31
  jmp alltraps
801067f4:	e9 63 f9 ff ff       	jmp    8010615c <alltraps>

801067f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $50
801067fb:	6a 32                	push   $0x32
  jmp alltraps
801067fd:	e9 5a f9 ff ff       	jmp    8010615c <alltraps>

80106802 <vector51>:
.globl vector51
vector51:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $51
80106804:	6a 33                	push   $0x33
  jmp alltraps
80106806:	e9 51 f9 ff ff       	jmp    8010615c <alltraps>

8010680b <vector52>:
.globl vector52
vector52:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $52
8010680d:	6a 34                	push   $0x34
  jmp alltraps
8010680f:	e9 48 f9 ff ff       	jmp    8010615c <alltraps>

80106814 <vector53>:
.globl vector53
vector53:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $53
80106816:	6a 35                	push   $0x35
  jmp alltraps
80106818:	e9 3f f9 ff ff       	jmp    8010615c <alltraps>

8010681d <vector54>:
.globl vector54
vector54:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $54
8010681f:	6a 36                	push   $0x36
  jmp alltraps
80106821:	e9 36 f9 ff ff       	jmp    8010615c <alltraps>

80106826 <vector55>:
.globl vector55
vector55:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $55
80106828:	6a 37                	push   $0x37
  jmp alltraps
8010682a:	e9 2d f9 ff ff       	jmp    8010615c <alltraps>

8010682f <vector56>:
.globl vector56
vector56:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $56
80106831:	6a 38                	push   $0x38
  jmp alltraps
80106833:	e9 24 f9 ff ff       	jmp    8010615c <alltraps>

80106838 <vector57>:
.globl vector57
vector57:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $57
8010683a:	6a 39                	push   $0x39
  jmp alltraps
8010683c:	e9 1b f9 ff ff       	jmp    8010615c <alltraps>

80106841 <vector58>:
.globl vector58
vector58:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $58
80106843:	6a 3a                	push   $0x3a
  jmp alltraps
80106845:	e9 12 f9 ff ff       	jmp    8010615c <alltraps>

8010684a <vector59>:
.globl vector59
vector59:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $59
8010684c:	6a 3b                	push   $0x3b
  jmp alltraps
8010684e:	e9 09 f9 ff ff       	jmp    8010615c <alltraps>

80106853 <vector60>:
.globl vector60
vector60:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $60
80106855:	6a 3c                	push   $0x3c
  jmp alltraps
80106857:	e9 00 f9 ff ff       	jmp    8010615c <alltraps>

8010685c <vector61>:
.globl vector61
vector61:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $61
8010685e:	6a 3d                	push   $0x3d
  jmp alltraps
80106860:	e9 f7 f8 ff ff       	jmp    8010615c <alltraps>

80106865 <vector62>:
.globl vector62
vector62:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $62
80106867:	6a 3e                	push   $0x3e
  jmp alltraps
80106869:	e9 ee f8 ff ff       	jmp    8010615c <alltraps>

8010686e <vector63>:
.globl vector63
vector63:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $63
80106870:	6a 3f                	push   $0x3f
  jmp alltraps
80106872:	e9 e5 f8 ff ff       	jmp    8010615c <alltraps>

80106877 <vector64>:
.globl vector64
vector64:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $64
80106879:	6a 40                	push   $0x40
  jmp alltraps
8010687b:	e9 dc f8 ff ff       	jmp    8010615c <alltraps>

80106880 <vector65>:
.globl vector65
vector65:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $65
80106882:	6a 41                	push   $0x41
  jmp alltraps
80106884:	e9 d3 f8 ff ff       	jmp    8010615c <alltraps>

80106889 <vector66>:
.globl vector66
vector66:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $66
8010688b:	6a 42                	push   $0x42
  jmp alltraps
8010688d:	e9 ca f8 ff ff       	jmp    8010615c <alltraps>

80106892 <vector67>:
.globl vector67
vector67:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $67
80106894:	6a 43                	push   $0x43
  jmp alltraps
80106896:	e9 c1 f8 ff ff       	jmp    8010615c <alltraps>

8010689b <vector68>:
.globl vector68
vector68:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $68
8010689d:	6a 44                	push   $0x44
  jmp alltraps
8010689f:	e9 b8 f8 ff ff       	jmp    8010615c <alltraps>

801068a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $69
801068a6:	6a 45                	push   $0x45
  jmp alltraps
801068a8:	e9 af f8 ff ff       	jmp    8010615c <alltraps>

801068ad <vector70>:
.globl vector70
vector70:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $70
801068af:	6a 46                	push   $0x46
  jmp alltraps
801068b1:	e9 a6 f8 ff ff       	jmp    8010615c <alltraps>

801068b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $71
801068b8:	6a 47                	push   $0x47
  jmp alltraps
801068ba:	e9 9d f8 ff ff       	jmp    8010615c <alltraps>

801068bf <vector72>:
.globl vector72
vector72:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $72
801068c1:	6a 48                	push   $0x48
  jmp alltraps
801068c3:	e9 94 f8 ff ff       	jmp    8010615c <alltraps>

801068c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $73
801068ca:	6a 49                	push   $0x49
  jmp alltraps
801068cc:	e9 8b f8 ff ff       	jmp    8010615c <alltraps>

801068d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $74
801068d3:	6a 4a                	push   $0x4a
  jmp alltraps
801068d5:	e9 82 f8 ff ff       	jmp    8010615c <alltraps>

801068da <vector75>:
.globl vector75
vector75:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $75
801068dc:	6a 4b                	push   $0x4b
  jmp alltraps
801068de:	e9 79 f8 ff ff       	jmp    8010615c <alltraps>

801068e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $76
801068e5:	6a 4c                	push   $0x4c
  jmp alltraps
801068e7:	e9 70 f8 ff ff       	jmp    8010615c <alltraps>

801068ec <vector77>:
.globl vector77
vector77:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $77
801068ee:	6a 4d                	push   $0x4d
  jmp alltraps
801068f0:	e9 67 f8 ff ff       	jmp    8010615c <alltraps>

801068f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $78
801068f7:	6a 4e                	push   $0x4e
  jmp alltraps
801068f9:	e9 5e f8 ff ff       	jmp    8010615c <alltraps>

801068fe <vector79>:
.globl vector79
vector79:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $79
80106900:	6a 4f                	push   $0x4f
  jmp alltraps
80106902:	e9 55 f8 ff ff       	jmp    8010615c <alltraps>

80106907 <vector80>:
.globl vector80
vector80:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $80
80106909:	6a 50                	push   $0x50
  jmp alltraps
8010690b:	e9 4c f8 ff ff       	jmp    8010615c <alltraps>

80106910 <vector81>:
.globl vector81
vector81:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $81
80106912:	6a 51                	push   $0x51
  jmp alltraps
80106914:	e9 43 f8 ff ff       	jmp    8010615c <alltraps>

80106919 <vector82>:
.globl vector82
vector82:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $82
8010691b:	6a 52                	push   $0x52
  jmp alltraps
8010691d:	e9 3a f8 ff ff       	jmp    8010615c <alltraps>

80106922 <vector83>:
.globl vector83
vector83:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $83
80106924:	6a 53                	push   $0x53
  jmp alltraps
80106926:	e9 31 f8 ff ff       	jmp    8010615c <alltraps>

8010692b <vector84>:
.globl vector84
vector84:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $84
8010692d:	6a 54                	push   $0x54
  jmp alltraps
8010692f:	e9 28 f8 ff ff       	jmp    8010615c <alltraps>

80106934 <vector85>:
.globl vector85
vector85:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $85
80106936:	6a 55                	push   $0x55
  jmp alltraps
80106938:	e9 1f f8 ff ff       	jmp    8010615c <alltraps>

8010693d <vector86>:
.globl vector86
vector86:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $86
8010693f:	6a 56                	push   $0x56
  jmp alltraps
80106941:	e9 16 f8 ff ff       	jmp    8010615c <alltraps>

80106946 <vector87>:
.globl vector87
vector87:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $87
80106948:	6a 57                	push   $0x57
  jmp alltraps
8010694a:	e9 0d f8 ff ff       	jmp    8010615c <alltraps>

8010694f <vector88>:
.globl vector88
vector88:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $88
80106951:	6a 58                	push   $0x58
  jmp alltraps
80106953:	e9 04 f8 ff ff       	jmp    8010615c <alltraps>

80106958 <vector89>:
.globl vector89
vector89:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $89
8010695a:	6a 59                	push   $0x59
  jmp alltraps
8010695c:	e9 fb f7 ff ff       	jmp    8010615c <alltraps>

80106961 <vector90>:
.globl vector90
vector90:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $90
80106963:	6a 5a                	push   $0x5a
  jmp alltraps
80106965:	e9 f2 f7 ff ff       	jmp    8010615c <alltraps>

8010696a <vector91>:
.globl vector91
vector91:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $91
8010696c:	6a 5b                	push   $0x5b
  jmp alltraps
8010696e:	e9 e9 f7 ff ff       	jmp    8010615c <alltraps>

80106973 <vector92>:
.globl vector92
vector92:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $92
80106975:	6a 5c                	push   $0x5c
  jmp alltraps
80106977:	e9 e0 f7 ff ff       	jmp    8010615c <alltraps>

8010697c <vector93>:
.globl vector93
vector93:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $93
8010697e:	6a 5d                	push   $0x5d
  jmp alltraps
80106980:	e9 d7 f7 ff ff       	jmp    8010615c <alltraps>

80106985 <vector94>:
.globl vector94
vector94:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $94
80106987:	6a 5e                	push   $0x5e
  jmp alltraps
80106989:	e9 ce f7 ff ff       	jmp    8010615c <alltraps>

8010698e <vector95>:
.globl vector95
vector95:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $95
80106990:	6a 5f                	push   $0x5f
  jmp alltraps
80106992:	e9 c5 f7 ff ff       	jmp    8010615c <alltraps>

80106997 <vector96>:
.globl vector96
vector96:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $96
80106999:	6a 60                	push   $0x60
  jmp alltraps
8010699b:	e9 bc f7 ff ff       	jmp    8010615c <alltraps>

801069a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $97
801069a2:	6a 61                	push   $0x61
  jmp alltraps
801069a4:	e9 b3 f7 ff ff       	jmp    8010615c <alltraps>

801069a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $98
801069ab:	6a 62                	push   $0x62
  jmp alltraps
801069ad:	e9 aa f7 ff ff       	jmp    8010615c <alltraps>

801069b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $99
801069b4:	6a 63                	push   $0x63
  jmp alltraps
801069b6:	e9 a1 f7 ff ff       	jmp    8010615c <alltraps>

801069bb <vector100>:
.globl vector100
vector100:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $100
801069bd:	6a 64                	push   $0x64
  jmp alltraps
801069bf:	e9 98 f7 ff ff       	jmp    8010615c <alltraps>

801069c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $101
801069c6:	6a 65                	push   $0x65
  jmp alltraps
801069c8:	e9 8f f7 ff ff       	jmp    8010615c <alltraps>

801069cd <vector102>:
.globl vector102
vector102:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $102
801069cf:	6a 66                	push   $0x66
  jmp alltraps
801069d1:	e9 86 f7 ff ff       	jmp    8010615c <alltraps>

801069d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $103
801069d8:	6a 67                	push   $0x67
  jmp alltraps
801069da:	e9 7d f7 ff ff       	jmp    8010615c <alltraps>

801069df <vector104>:
.globl vector104
vector104:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $104
801069e1:	6a 68                	push   $0x68
  jmp alltraps
801069e3:	e9 74 f7 ff ff       	jmp    8010615c <alltraps>

801069e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $105
801069ea:	6a 69                	push   $0x69
  jmp alltraps
801069ec:	e9 6b f7 ff ff       	jmp    8010615c <alltraps>

801069f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $106
801069f3:	6a 6a                	push   $0x6a
  jmp alltraps
801069f5:	e9 62 f7 ff ff       	jmp    8010615c <alltraps>

801069fa <vector107>:
.globl vector107
vector107:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $107
801069fc:	6a 6b                	push   $0x6b
  jmp alltraps
801069fe:	e9 59 f7 ff ff       	jmp    8010615c <alltraps>

80106a03 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $108
80106a05:	6a 6c                	push   $0x6c
  jmp alltraps
80106a07:	e9 50 f7 ff ff       	jmp    8010615c <alltraps>

80106a0c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $109
80106a0e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a10:	e9 47 f7 ff ff       	jmp    8010615c <alltraps>

80106a15 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $110
80106a17:	6a 6e                	push   $0x6e
  jmp alltraps
80106a19:	e9 3e f7 ff ff       	jmp    8010615c <alltraps>

80106a1e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $111
80106a20:	6a 6f                	push   $0x6f
  jmp alltraps
80106a22:	e9 35 f7 ff ff       	jmp    8010615c <alltraps>

80106a27 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $112
80106a29:	6a 70                	push   $0x70
  jmp alltraps
80106a2b:	e9 2c f7 ff ff       	jmp    8010615c <alltraps>

80106a30 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $113
80106a32:	6a 71                	push   $0x71
  jmp alltraps
80106a34:	e9 23 f7 ff ff       	jmp    8010615c <alltraps>

80106a39 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $114
80106a3b:	6a 72                	push   $0x72
  jmp alltraps
80106a3d:	e9 1a f7 ff ff       	jmp    8010615c <alltraps>

80106a42 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $115
80106a44:	6a 73                	push   $0x73
  jmp alltraps
80106a46:	e9 11 f7 ff ff       	jmp    8010615c <alltraps>

80106a4b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $116
80106a4d:	6a 74                	push   $0x74
  jmp alltraps
80106a4f:	e9 08 f7 ff ff       	jmp    8010615c <alltraps>

80106a54 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $117
80106a56:	6a 75                	push   $0x75
  jmp alltraps
80106a58:	e9 ff f6 ff ff       	jmp    8010615c <alltraps>

80106a5d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $118
80106a5f:	6a 76                	push   $0x76
  jmp alltraps
80106a61:	e9 f6 f6 ff ff       	jmp    8010615c <alltraps>

80106a66 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $119
80106a68:	6a 77                	push   $0x77
  jmp alltraps
80106a6a:	e9 ed f6 ff ff       	jmp    8010615c <alltraps>

80106a6f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $120
80106a71:	6a 78                	push   $0x78
  jmp alltraps
80106a73:	e9 e4 f6 ff ff       	jmp    8010615c <alltraps>

80106a78 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $121
80106a7a:	6a 79                	push   $0x79
  jmp alltraps
80106a7c:	e9 db f6 ff ff       	jmp    8010615c <alltraps>

80106a81 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $122
80106a83:	6a 7a                	push   $0x7a
  jmp alltraps
80106a85:	e9 d2 f6 ff ff       	jmp    8010615c <alltraps>

80106a8a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $123
80106a8c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a8e:	e9 c9 f6 ff ff       	jmp    8010615c <alltraps>

80106a93 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $124
80106a95:	6a 7c                	push   $0x7c
  jmp alltraps
80106a97:	e9 c0 f6 ff ff       	jmp    8010615c <alltraps>

80106a9c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $125
80106a9e:	6a 7d                	push   $0x7d
  jmp alltraps
80106aa0:	e9 b7 f6 ff ff       	jmp    8010615c <alltraps>

80106aa5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $126
80106aa7:	6a 7e                	push   $0x7e
  jmp alltraps
80106aa9:	e9 ae f6 ff ff       	jmp    8010615c <alltraps>

80106aae <vector127>:
.globl vector127
vector127:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $127
80106ab0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ab2:	e9 a5 f6 ff ff       	jmp    8010615c <alltraps>

80106ab7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $128
80106ab9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106abe:	e9 99 f6 ff ff       	jmp    8010615c <alltraps>

80106ac3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $129
80106ac5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aca:	e9 8d f6 ff ff       	jmp    8010615c <alltraps>

80106acf <vector130>:
.globl vector130
vector130:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $130
80106ad1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ad6:	e9 81 f6 ff ff       	jmp    8010615c <alltraps>

80106adb <vector131>:
.globl vector131
vector131:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $131
80106add:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ae2:	e9 75 f6 ff ff       	jmp    8010615c <alltraps>

80106ae7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $132
80106ae9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106aee:	e9 69 f6 ff ff       	jmp    8010615c <alltraps>

80106af3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $133
80106af5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106afa:	e9 5d f6 ff ff       	jmp    8010615c <alltraps>

80106aff <vector134>:
.globl vector134
vector134:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $134
80106b01:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b06:	e9 51 f6 ff ff       	jmp    8010615c <alltraps>

80106b0b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $135
80106b0d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b12:	e9 45 f6 ff ff       	jmp    8010615c <alltraps>

80106b17 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $136
80106b19:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b1e:	e9 39 f6 ff ff       	jmp    8010615c <alltraps>

80106b23 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $137
80106b25:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b2a:	e9 2d f6 ff ff       	jmp    8010615c <alltraps>

80106b2f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $138
80106b31:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b36:	e9 21 f6 ff ff       	jmp    8010615c <alltraps>

80106b3b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $139
80106b3d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b42:	e9 15 f6 ff ff       	jmp    8010615c <alltraps>

80106b47 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $140
80106b49:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b4e:	e9 09 f6 ff ff       	jmp    8010615c <alltraps>

80106b53 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $141
80106b55:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b5a:	e9 fd f5 ff ff       	jmp    8010615c <alltraps>

80106b5f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $142
80106b61:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b66:	e9 f1 f5 ff ff       	jmp    8010615c <alltraps>

80106b6b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $143
80106b6d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b72:	e9 e5 f5 ff ff       	jmp    8010615c <alltraps>

80106b77 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $144
80106b79:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b7e:	e9 d9 f5 ff ff       	jmp    8010615c <alltraps>

80106b83 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $145
80106b85:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b8a:	e9 cd f5 ff ff       	jmp    8010615c <alltraps>

80106b8f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $146
80106b91:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b96:	e9 c1 f5 ff ff       	jmp    8010615c <alltraps>

80106b9b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $147
80106b9d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ba2:	e9 b5 f5 ff ff       	jmp    8010615c <alltraps>

80106ba7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $148
80106ba9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bae:	e9 a9 f5 ff ff       	jmp    8010615c <alltraps>

80106bb3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $149
80106bb5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bba:	e9 9d f5 ff ff       	jmp    8010615c <alltraps>

80106bbf <vector150>:
.globl vector150
vector150:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $150
80106bc1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bc6:	e9 91 f5 ff ff       	jmp    8010615c <alltraps>

80106bcb <vector151>:
.globl vector151
vector151:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $151
80106bcd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bd2:	e9 85 f5 ff ff       	jmp    8010615c <alltraps>

80106bd7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $152
80106bd9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bde:	e9 79 f5 ff ff       	jmp    8010615c <alltraps>

80106be3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $153
80106be5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bea:	e9 6d f5 ff ff       	jmp    8010615c <alltraps>

80106bef <vector154>:
.globl vector154
vector154:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $154
80106bf1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bf6:	e9 61 f5 ff ff       	jmp    8010615c <alltraps>

80106bfb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $155
80106bfd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c02:	e9 55 f5 ff ff       	jmp    8010615c <alltraps>

80106c07 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $156
80106c09:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c0e:	e9 49 f5 ff ff       	jmp    8010615c <alltraps>

80106c13 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $157
80106c15:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c1a:	e9 3d f5 ff ff       	jmp    8010615c <alltraps>

80106c1f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $158
80106c21:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c26:	e9 31 f5 ff ff       	jmp    8010615c <alltraps>

80106c2b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $159
80106c2d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c32:	e9 25 f5 ff ff       	jmp    8010615c <alltraps>

80106c37 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $160
80106c39:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c3e:	e9 19 f5 ff ff       	jmp    8010615c <alltraps>

80106c43 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $161
80106c45:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c4a:	e9 0d f5 ff ff       	jmp    8010615c <alltraps>

80106c4f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $162
80106c51:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c56:	e9 01 f5 ff ff       	jmp    8010615c <alltraps>

80106c5b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $163
80106c5d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c62:	e9 f5 f4 ff ff       	jmp    8010615c <alltraps>

80106c67 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $164
80106c69:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c6e:	e9 e9 f4 ff ff       	jmp    8010615c <alltraps>

80106c73 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $165
80106c75:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c7a:	e9 dd f4 ff ff       	jmp    8010615c <alltraps>

80106c7f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $166
80106c81:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c86:	e9 d1 f4 ff ff       	jmp    8010615c <alltraps>

80106c8b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $167
80106c8d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c92:	e9 c5 f4 ff ff       	jmp    8010615c <alltraps>

80106c97 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $168
80106c99:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c9e:	e9 b9 f4 ff ff       	jmp    8010615c <alltraps>

80106ca3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $169
80106ca5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106caa:	e9 ad f4 ff ff       	jmp    8010615c <alltraps>

80106caf <vector170>:
.globl vector170
vector170:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $170
80106cb1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cb6:	e9 a1 f4 ff ff       	jmp    8010615c <alltraps>

80106cbb <vector171>:
.globl vector171
vector171:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $171
80106cbd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cc2:	e9 95 f4 ff ff       	jmp    8010615c <alltraps>

80106cc7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $172
80106cc9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cce:	e9 89 f4 ff ff       	jmp    8010615c <alltraps>

80106cd3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $173
80106cd5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cda:	e9 7d f4 ff ff       	jmp    8010615c <alltraps>

80106cdf <vector174>:
.globl vector174
vector174:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $174
80106ce1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ce6:	e9 71 f4 ff ff       	jmp    8010615c <alltraps>

80106ceb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $175
80106ced:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cf2:	e9 65 f4 ff ff       	jmp    8010615c <alltraps>

80106cf7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $176
80106cf9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cfe:	e9 59 f4 ff ff       	jmp    8010615c <alltraps>

80106d03 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $177
80106d05:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d0a:	e9 4d f4 ff ff       	jmp    8010615c <alltraps>

80106d0f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $178
80106d11:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d16:	e9 41 f4 ff ff       	jmp    8010615c <alltraps>

80106d1b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $179
80106d1d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d22:	e9 35 f4 ff ff       	jmp    8010615c <alltraps>

80106d27 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $180
80106d29:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d2e:	e9 29 f4 ff ff       	jmp    8010615c <alltraps>

80106d33 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $181
80106d35:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d3a:	e9 1d f4 ff ff       	jmp    8010615c <alltraps>

80106d3f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $182
80106d41:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d46:	e9 11 f4 ff ff       	jmp    8010615c <alltraps>

80106d4b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $183
80106d4d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d52:	e9 05 f4 ff ff       	jmp    8010615c <alltraps>

80106d57 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $184
80106d59:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d5e:	e9 f9 f3 ff ff       	jmp    8010615c <alltraps>

80106d63 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $185
80106d65:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d6a:	e9 ed f3 ff ff       	jmp    8010615c <alltraps>

80106d6f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $186
80106d71:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d76:	e9 e1 f3 ff ff       	jmp    8010615c <alltraps>

80106d7b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $187
80106d7d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d82:	e9 d5 f3 ff ff       	jmp    8010615c <alltraps>

80106d87 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $188
80106d89:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d8e:	e9 c9 f3 ff ff       	jmp    8010615c <alltraps>

80106d93 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $189
80106d95:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d9a:	e9 bd f3 ff ff       	jmp    8010615c <alltraps>

80106d9f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $190
80106da1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106da6:	e9 b1 f3 ff ff       	jmp    8010615c <alltraps>

80106dab <vector191>:
.globl vector191
vector191:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $191
80106dad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106db2:	e9 a5 f3 ff ff       	jmp    8010615c <alltraps>

80106db7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $192
80106db9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dbe:	e9 99 f3 ff ff       	jmp    8010615c <alltraps>

80106dc3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $193
80106dc5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dca:	e9 8d f3 ff ff       	jmp    8010615c <alltraps>

80106dcf <vector194>:
.globl vector194
vector194:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $194
80106dd1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106dd6:	e9 81 f3 ff ff       	jmp    8010615c <alltraps>

80106ddb <vector195>:
.globl vector195
vector195:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $195
80106ddd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106de2:	e9 75 f3 ff ff       	jmp    8010615c <alltraps>

80106de7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $196
80106de9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dee:	e9 69 f3 ff ff       	jmp    8010615c <alltraps>

80106df3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $197
80106df5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dfa:	e9 5d f3 ff ff       	jmp    8010615c <alltraps>

80106dff <vector198>:
.globl vector198
vector198:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $198
80106e01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e06:	e9 51 f3 ff ff       	jmp    8010615c <alltraps>

80106e0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $199
80106e0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e12:	e9 45 f3 ff ff       	jmp    8010615c <alltraps>

80106e17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $200
80106e19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e1e:	e9 39 f3 ff ff       	jmp    8010615c <alltraps>

80106e23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $201
80106e25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e2a:	e9 2d f3 ff ff       	jmp    8010615c <alltraps>

80106e2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $202
80106e31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e36:	e9 21 f3 ff ff       	jmp    8010615c <alltraps>

80106e3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $203
80106e3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e42:	e9 15 f3 ff ff       	jmp    8010615c <alltraps>

80106e47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $204
80106e49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e4e:	e9 09 f3 ff ff       	jmp    8010615c <alltraps>

80106e53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $205
80106e55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e5a:	e9 fd f2 ff ff       	jmp    8010615c <alltraps>

80106e5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $206
80106e61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e66:	e9 f1 f2 ff ff       	jmp    8010615c <alltraps>

80106e6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $207
80106e6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e72:	e9 e5 f2 ff ff       	jmp    8010615c <alltraps>

80106e77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $208
80106e79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e7e:	e9 d9 f2 ff ff       	jmp    8010615c <alltraps>

80106e83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $209
80106e85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e8a:	e9 cd f2 ff ff       	jmp    8010615c <alltraps>

80106e8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $210
80106e91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e96:	e9 c1 f2 ff ff       	jmp    8010615c <alltraps>

80106e9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $211
80106e9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ea2:	e9 b5 f2 ff ff       	jmp    8010615c <alltraps>

80106ea7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $212
80106ea9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106eae:	e9 a9 f2 ff ff       	jmp    8010615c <alltraps>

80106eb3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $213
80106eb5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eba:	e9 9d f2 ff ff       	jmp    8010615c <alltraps>

80106ebf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $214
80106ec1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ec6:	e9 91 f2 ff ff       	jmp    8010615c <alltraps>

80106ecb <vector215>:
.globl vector215
vector215:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $215
80106ecd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ed2:	e9 85 f2 ff ff       	jmp    8010615c <alltraps>

80106ed7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $216
80106ed9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ede:	e9 79 f2 ff ff       	jmp    8010615c <alltraps>

80106ee3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $217
80106ee5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eea:	e9 6d f2 ff ff       	jmp    8010615c <alltraps>

80106eef <vector218>:
.globl vector218
vector218:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $218
80106ef1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ef6:	e9 61 f2 ff ff       	jmp    8010615c <alltraps>

80106efb <vector219>:
.globl vector219
vector219:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $219
80106efd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f02:	e9 55 f2 ff ff       	jmp    8010615c <alltraps>

80106f07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $220
80106f09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f0e:	e9 49 f2 ff ff       	jmp    8010615c <alltraps>

80106f13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $221
80106f15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f1a:	e9 3d f2 ff ff       	jmp    8010615c <alltraps>

80106f1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $222
80106f21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f26:	e9 31 f2 ff ff       	jmp    8010615c <alltraps>

80106f2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $223
80106f2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f32:	e9 25 f2 ff ff       	jmp    8010615c <alltraps>

80106f37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $224
80106f39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f3e:	e9 19 f2 ff ff       	jmp    8010615c <alltraps>

80106f43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $225
80106f45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f4a:	e9 0d f2 ff ff       	jmp    8010615c <alltraps>

80106f4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $226
80106f51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f56:	e9 01 f2 ff ff       	jmp    8010615c <alltraps>

80106f5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $227
80106f5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f62:	e9 f5 f1 ff ff       	jmp    8010615c <alltraps>

80106f67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $228
80106f69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f6e:	e9 e9 f1 ff ff       	jmp    8010615c <alltraps>

80106f73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $229
80106f75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f7a:	e9 dd f1 ff ff       	jmp    8010615c <alltraps>

80106f7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $230
80106f81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f86:	e9 d1 f1 ff ff       	jmp    8010615c <alltraps>

80106f8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $231
80106f8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f92:	e9 c5 f1 ff ff       	jmp    8010615c <alltraps>

80106f97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $232
80106f99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f9e:	e9 b9 f1 ff ff       	jmp    8010615c <alltraps>

80106fa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $233
80106fa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106faa:	e9 ad f1 ff ff       	jmp    8010615c <alltraps>

80106faf <vector234>:
.globl vector234
vector234:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $234
80106fb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fb6:	e9 a1 f1 ff ff       	jmp    8010615c <alltraps>

80106fbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $235
80106fbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fc2:	e9 95 f1 ff ff       	jmp    8010615c <alltraps>

80106fc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $236
80106fc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fce:	e9 89 f1 ff ff       	jmp    8010615c <alltraps>

80106fd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $237
80106fd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fda:	e9 7d f1 ff ff       	jmp    8010615c <alltraps>

80106fdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $238
80106fe1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fe6:	e9 71 f1 ff ff       	jmp    8010615c <alltraps>

80106feb <vector239>:
.globl vector239
vector239:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $239
80106fed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ff2:	e9 65 f1 ff ff       	jmp    8010615c <alltraps>

80106ff7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $240
80106ff9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ffe:	e9 59 f1 ff ff       	jmp    8010615c <alltraps>

80107003 <vector241>:
.globl vector241
vector241:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $241
80107005:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010700a:	e9 4d f1 ff ff       	jmp    8010615c <alltraps>

8010700f <vector242>:
.globl vector242
vector242:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $242
80107011:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107016:	e9 41 f1 ff ff       	jmp    8010615c <alltraps>

8010701b <vector243>:
.globl vector243
vector243:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $243
8010701d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107022:	e9 35 f1 ff ff       	jmp    8010615c <alltraps>

80107027 <vector244>:
.globl vector244
vector244:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $244
80107029:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010702e:	e9 29 f1 ff ff       	jmp    8010615c <alltraps>

80107033 <vector245>:
.globl vector245
vector245:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $245
80107035:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010703a:	e9 1d f1 ff ff       	jmp    8010615c <alltraps>

8010703f <vector246>:
.globl vector246
vector246:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $246
80107041:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107046:	e9 11 f1 ff ff       	jmp    8010615c <alltraps>

8010704b <vector247>:
.globl vector247
vector247:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $247
8010704d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107052:	e9 05 f1 ff ff       	jmp    8010615c <alltraps>

80107057 <vector248>:
.globl vector248
vector248:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $248
80107059:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010705e:	e9 f9 f0 ff ff       	jmp    8010615c <alltraps>

80107063 <vector249>:
.globl vector249
vector249:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $249
80107065:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010706a:	e9 ed f0 ff ff       	jmp    8010615c <alltraps>

8010706f <vector250>:
.globl vector250
vector250:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $250
80107071:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107076:	e9 e1 f0 ff ff       	jmp    8010615c <alltraps>

8010707b <vector251>:
.globl vector251
vector251:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $251
8010707d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107082:	e9 d5 f0 ff ff       	jmp    8010615c <alltraps>

80107087 <vector252>:
.globl vector252
vector252:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $252
80107089:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010708e:	e9 c9 f0 ff ff       	jmp    8010615c <alltraps>

80107093 <vector253>:
.globl vector253
vector253:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $253
80107095:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010709a:	e9 bd f0 ff ff       	jmp    8010615c <alltraps>

8010709f <vector254>:
.globl vector254
vector254:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $254
801070a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070a6:	e9 b1 f0 ff ff       	jmp    8010615c <alltraps>

801070ab <vector255>:
.globl vector255
vector255:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $255
801070ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070b2:	e9 a5 f0 ff ff       	jmp    8010615c <alltraps>
801070b7:	66 90                	xchg   %ax,%ax
801070b9:	66 90                	xchg   %ax,%ax
801070bb:	66 90                	xchg   %ax,%ax
801070bd:	66 90                	xchg   %ax,%ax
801070bf:	90                   	nop

801070c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070d2:	83 ec 1c             	sub    $0x1c,%esp
801070d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070d8:	39 d3                	cmp    %edx,%ebx
801070da:	73 49                	jae    80107125 <deallocuvm.part.0+0x65>
801070dc:	89 c7                	mov    %eax,%edi
801070de:	eb 0c                	jmp    801070ec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070e0:	83 c0 01             	add    $0x1,%eax
801070e3:	c1 e0 16             	shl    $0x16,%eax
801070e6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070e8:	39 da                	cmp    %ebx,%edx
801070ea:	76 39                	jbe    80107125 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801070ec:	89 d8                	mov    %ebx,%eax
801070ee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070f1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801070f4:	f6 c1 01             	test   $0x1,%cl
801070f7:	74 e7                	je     801070e0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801070f9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107101:	c1 ee 0a             	shr    $0xa,%esi
80107104:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010710a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107111:	85 f6                	test   %esi,%esi
80107113:	74 cb                	je     801070e0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107115:	8b 06                	mov    (%esi),%eax
80107117:	a8 01                	test   $0x1,%al
80107119:	75 15                	jne    80107130 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010711b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107121:	39 da                	cmp    %ebx,%edx
80107123:	77 c7                	ja     801070ec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107125:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010712b:	5b                   	pop    %ebx
8010712c:	5e                   	pop    %esi
8010712d:	5f                   	pop    %edi
8010712e:	5d                   	pop    %ebp
8010712f:	c3                   	ret    
      if(pa == 0)
80107130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107135:	74 25                	je     8010715c <deallocuvm.part.0+0x9c>
      kfree(v);
80107137:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010713a:	05 00 00 00 80       	add    $0x80000000,%eax
8010713f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107142:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107148:	50                   	push   %eax
80107149:	e8 72 b4 ff ff       	call   801025c0 <kfree>
      *pte = 0;
8010714e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107157:	83 c4 10             	add    $0x10,%esp
8010715a:	eb 8c                	jmp    801070e8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010715c:	83 ec 0c             	sub    $0xc,%esp
8010715f:	68 e6 7d 10 80       	push   $0x80107de6
80107164:	e8 67 92 ff ff       	call   801003d0 <panic>
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107170 <mappages>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107176:	89 d3                	mov    %edx,%ebx
80107178:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010717e:	83 ec 1c             	sub    $0x1c,%esp
80107181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107184:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010718d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107190:	8b 45 08             	mov    0x8(%ebp),%eax
80107193:	29 d8                	sub    %ebx,%eax
80107195:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107198:	eb 3d                	jmp    801071d7 <mappages+0x67>
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071a0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071a7:	c1 ea 0a             	shr    $0xa,%edx
801071aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071b7:	85 c0                	test   %eax,%eax
801071b9:	74 75                	je     80107230 <mappages+0xc0>
    if(*pte & PTE_P)
801071bb:	f6 00 01             	testb  $0x1,(%eax)
801071be:	0f 85 86 00 00 00    	jne    8010724a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071c4:	0b 75 0c             	or     0xc(%ebp),%esi
801071c7:	83 ce 01             	or     $0x1,%esi
801071ca:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071cc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071cf:	74 6f                	je     80107240 <mappages+0xd0>
    a += PGSIZE;
801071d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071dd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801071e0:	89 d8                	mov    %ebx,%eax
801071e2:	c1 e8 16             	shr    $0x16,%eax
801071e5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071e8:	8b 07                	mov    (%edi),%eax
801071ea:	a8 01                	test   $0x1,%al
801071ec:	75 b2                	jne    801071a0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071ee:	e8 8d b5 ff ff       	call   80102780 <kalloc>
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 39                	je     80107230 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071f7:	83 ec 04             	sub    $0x4,%esp
801071fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801071fd:	68 00 10 00 00       	push   $0x1000
80107202:	6a 00                	push   $0x0
80107204:	50                   	push   %eax
80107205:	e8 36 db ff ff       	call   80104d40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010720a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010720d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107210:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107216:	83 c8 07             	or     $0x7,%eax
80107219:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010721b:	89 d8                	mov    %ebx,%eax
8010721d:	c1 e8 0a             	shr    $0xa,%eax
80107220:	25 fc 0f 00 00       	and    $0xffc,%eax
80107225:	01 d0                	add    %edx,%eax
80107227:	eb 92                	jmp    801071bb <mappages+0x4b>
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
80107240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107243:	31 c0                	xor    %eax,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
      panic("remap");
8010724a:	83 ec 0c             	sub    $0xc,%esp
8010724d:	68 48 85 10 80       	push   $0x80108548
80107252:	e8 79 91 ff ff       	call   801003d0 <panic>
80107257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725e:	66 90                	xchg   %ax,%ax

80107260 <seginit>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107266:	e8 55 c8 ff ff       	call   80103ac0 <cpuid>
  pd[0] = size-1;
8010726b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107270:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107276:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727a:	c7 80 98 43 11 80 ff 	movl   $0xffff,-0x7feebc68(%eax)
80107281:	ff 00 00 
80107284:	c7 80 9c 43 11 80 00 	movl   $0xcf9a00,-0x7feebc64(%eax)
8010728b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010728e:	c7 80 a0 43 11 80 ff 	movl   $0xffff,-0x7feebc60(%eax)
80107295:	ff 00 00 
80107298:	c7 80 a4 43 11 80 00 	movl   $0xcf9200,-0x7feebc5c(%eax)
8010729f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072a2:	c7 80 a8 43 11 80 ff 	movl   $0xffff,-0x7feebc58(%eax)
801072a9:	ff 00 00 
801072ac:	c7 80 ac 43 11 80 00 	movl   $0xcffa00,-0x7feebc54(%eax)
801072b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072b6:	c7 80 b0 43 11 80 ff 	movl   $0xffff,-0x7feebc50(%eax)
801072bd:	ff 00 00 
801072c0:	c7 80 b4 43 11 80 00 	movl   $0xcff200,-0x7feebc4c(%eax)
801072c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ca:	05 90 43 11 80       	add    $0x80114390,%eax
  pd[1] = (uint)p;
801072cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072d3:	c1 e8 10             	shr    $0x10,%eax
801072d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072dd:	0f 01 10             	lgdtl  (%eax)
}
801072e0:	c9                   	leave  
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072f0:	a1 04 72 11 80       	mov    0x80117204,%eax
801072f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072fa:	0f 22 d8             	mov    %eax,%cr3
}
801072fd:	c3                   	ret    
801072fe:	66 90                	xchg   %ax,%ax

80107300 <switchuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
80107309:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010730c:	85 f6                	test   %esi,%esi
8010730e:	0f 84 cb 00 00 00    	je     801073df <switchuvm+0xdf>
  if(p->kstack == 0)
80107314:	8b 46 08             	mov    0x8(%esi),%eax
80107317:	85 c0                	test   %eax,%eax
80107319:	0f 84 da 00 00 00    	je     801073f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010731f:	8b 46 04             	mov    0x4(%esi),%eax
80107322:	85 c0                	test   %eax,%eax
80107324:	0f 84 c2 00 00 00    	je     801073ec <switchuvm+0xec>
  pushcli();
8010732a:	e8 51 d6 ff ff       	call   80104980 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010732f:	e8 2c c7 ff ff       	call   80103a60 <mycpu>
80107334:	89 c3                	mov    %eax,%ebx
80107336:	e8 25 c7 ff ff       	call   80103a60 <mycpu>
8010733b:	89 c7                	mov    %eax,%edi
8010733d:	e8 1e c7 ff ff       	call   80103a60 <mycpu>
80107342:	83 c7 08             	add    $0x8,%edi
80107345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107348:	e8 13 c7 ff ff       	call   80103a60 <mycpu>
8010734d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107350:	ba 67 00 00 00       	mov    $0x67,%edx
80107355:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010735c:	83 c0 08             	add    $0x8,%eax
8010735f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107366:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010736b:	83 c1 08             	add    $0x8,%ecx
8010736e:	c1 e8 18             	shr    $0x18,%eax
80107371:	c1 e9 10             	shr    $0x10,%ecx
80107374:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010737a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107380:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107385:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010738c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107391:	e8 ca c6 ff ff       	call   80103a60 <mycpu>
80107396:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010739d:	e8 be c6 ff ff       	call   80103a60 <mycpu>
801073a2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073a6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073af:	e8 ac c6 ff ff       	call   80103a60 <mycpu>
801073b4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073b7:	e8 a4 c6 ff ff       	call   80103a60 <mycpu>
801073bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073c0:	b8 28 00 00 00       	mov    $0x28,%eax
801073c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073c8:	8b 46 04             	mov    0x4(%esi),%eax
801073cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d0:	0f 22 d8             	mov    %eax,%cr3
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	5b                   	pop    %ebx
801073d7:	5e                   	pop    %esi
801073d8:	5f                   	pop    %edi
801073d9:	5d                   	pop    %ebp
  popcli();
801073da:	e9 f1 d5 ff ff       	jmp    801049d0 <popcli>
    panic("switchuvm: no process");
801073df:	83 ec 0c             	sub    $0xc,%esp
801073e2:	68 4e 85 10 80       	push   $0x8010854e
801073e7:	e8 e4 8f ff ff       	call   801003d0 <panic>
    panic("switchuvm: no pgdir");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 79 85 10 80       	push   $0x80108579
801073f4:	e8 d7 8f ff ff       	call   801003d0 <panic>
    panic("switchuvm: no kstack");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 64 85 10 80       	push   $0x80108564
80107401:	e8 ca 8f ff ff       	call   801003d0 <panic>
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi

80107410 <inituvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 45 0c             	mov    0xc(%ebp),%eax
8010741c:	8b 75 10             	mov    0x10(%ebp),%esi
8010741f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107425:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010742b:	77 4b                	ja     80107478 <inituvm+0x68>
  mem = kalloc();
8010742d:	e8 4e b3 ff ff       	call   80102780 <kalloc>
  memset(mem, 0, PGSIZE);
80107432:	83 ec 04             	sub    $0x4,%esp
80107435:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010743a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010743c:	6a 00                	push   $0x0
8010743e:	50                   	push   %eax
8010743f:	e8 fc d8 ff ff       	call   80104d40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107444:	58                   	pop    %eax
80107445:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744b:	5a                   	pop    %edx
8010744c:	6a 06                	push   $0x6
8010744e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107453:	31 d2                	xor    %edx,%edx
80107455:	50                   	push   %eax
80107456:	89 f8                	mov    %edi,%eax
80107458:	e8 13 fd ff ff       	call   80107170 <mappages>
  memmove(mem, init, sz);
8010745d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107460:	89 75 10             	mov    %esi,0x10(%ebp)
80107463:	83 c4 10             	add    $0x10,%esp
80107466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107469:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010746c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746f:	5b                   	pop    %ebx
80107470:	5e                   	pop    %esi
80107471:	5f                   	pop    %edi
80107472:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107473:	e9 68 d9 ff ff       	jmp    80104de0 <memmove>
    panic("inituvm: more than a page");
80107478:	83 ec 0c             	sub    $0xc,%esp
8010747b:	68 8d 85 10 80       	push   $0x8010858d
80107480:	e8 4b 8f ff ff       	call   801003d0 <panic>
80107485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107490 <loaduvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
80107499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010749c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010749f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074a4:	0f 85 bb 00 00 00    	jne    80107565 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074aa:	01 f0                	add    %esi,%eax
801074ac:	89 f3                	mov    %esi,%ebx
801074ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074b1:	8b 45 14             	mov    0x14(%ebp),%eax
801074b4:	01 f0                	add    %esi,%eax
801074b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074b9:	85 f6                	test   %esi,%esi
801074bb:	0f 84 87 00 00 00    	je     80107548 <loaduvm+0xb8>
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074ce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801074d0:	89 c2                	mov    %eax,%edx
801074d2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074d5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801074d8:	f6 c2 01             	test   $0x1,%dl
801074db:	75 13                	jne    801074f0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801074dd:	83 ec 0c             	sub    $0xc,%esp
801074e0:	68 a7 85 10 80       	push   $0x801085a7
801074e5:	e8 e6 8e ff ff       	call   801003d0 <panic>
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107505:	85 c0                	test   %eax,%eax
80107507:	74 d4                	je     801074dd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107509:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010750b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010750e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107518:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010751e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107521:	29 d9                	sub    %ebx,%ecx
80107523:	05 00 00 00 80       	add    $0x80000000,%eax
80107528:	57                   	push   %edi
80107529:	51                   	push   %ecx
8010752a:	50                   	push   %eax
8010752b:	ff 75 10             	push   0x10(%ebp)
8010752e:	e8 0d a6 ff ff       	call   80101b40 <readi>
80107533:	83 c4 10             	add    $0x10,%esp
80107536:	39 f8                	cmp    %edi,%eax
80107538:	75 1e                	jne    80107558 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010753a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107540:	89 f0                	mov    %esi,%eax
80107542:	29 d8                	sub    %ebx,%eax
80107544:	39 c6                	cmp    %eax,%esi
80107546:	77 80                	ja     801074c8 <loaduvm+0x38>
}
80107548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010754b:	31 c0                	xor    %eax,%eax
}
8010754d:	5b                   	pop    %ebx
8010754e:	5e                   	pop    %esi
8010754f:	5f                   	pop    %edi
80107550:	5d                   	pop    %ebp
80107551:	c3                   	ret    
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107558:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010755b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107560:	5b                   	pop    %ebx
80107561:	5e                   	pop    %esi
80107562:	5f                   	pop    %edi
80107563:	5d                   	pop    %ebp
80107564:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	68 48 86 10 80       	push   $0x80108648
8010756d:	e8 5e 8e ff ff       	call   801003d0 <panic>
80107572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107580 <allocuvm>:
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107589:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010758c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010758f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107592:	85 c0                	test   %eax,%eax
80107594:	0f 88 b6 00 00 00    	js     80107650 <allocuvm+0xd0>
  if(newsz < oldsz)
8010759a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010759d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075a0:	0f 82 9a 00 00 00    	jb     80107640 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075a6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075b5:	77 44                	ja     801075fb <allocuvm+0x7b>
801075b7:	e9 87 00 00 00       	jmp    80107643 <allocuvm+0xc3>
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
801075c3:	68 00 10 00 00       	push   $0x1000
801075c8:	6a 00                	push   $0x0
801075ca:	50                   	push   %eax
801075cb:	e8 70 d7 ff ff       	call   80104d40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075d0:	58                   	pop    %eax
801075d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075d7:	5a                   	pop    %edx
801075d8:	6a 06                	push   $0x6
801075da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075df:	89 f2                	mov    %esi,%edx
801075e1:	50                   	push   %eax
801075e2:	89 f8                	mov    %edi,%eax
801075e4:	e8 87 fb ff ff       	call   80107170 <mappages>
801075e9:	83 c4 10             	add    $0x10,%esp
801075ec:	85 c0                	test   %eax,%eax
801075ee:	78 78                	js     80107668 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075f9:	76 48                	jbe    80107643 <allocuvm+0xc3>
    mem = kalloc();
801075fb:	e8 80 b1 ff ff       	call   80102780 <kalloc>
80107600:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107602:	85 c0                	test   %eax,%eax
80107604:	75 ba                	jne    801075c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	68 c5 85 10 80       	push   $0x801085c5
8010760e:	e8 dd 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107613:	8b 45 0c             	mov    0xc(%ebp),%eax
80107616:	83 c4 10             	add    $0x10,%esp
80107619:	39 45 10             	cmp    %eax,0x10(%ebp)
8010761c:	74 32                	je     80107650 <allocuvm+0xd0>
8010761e:	8b 55 10             	mov    0x10(%ebp),%edx
80107621:	89 c1                	mov    %eax,%ecx
80107623:	89 f8                	mov    %edi,%eax
80107625:	e8 96 fa ff ff       	call   801070c0 <deallocuvm.part.0>
      return 0;
8010762a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107637:	5b                   	pop    %ebx
80107638:	5e                   	pop    %esi
80107639:	5f                   	pop    %edi
8010763a:	5d                   	pop    %ebp
8010763b:	c3                   	ret    
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107640:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107646:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107649:	5b                   	pop    %ebx
8010764a:	5e                   	pop    %esi
8010764b:	5f                   	pop    %edi
8010764c:	5d                   	pop    %ebp
8010764d:	c3                   	ret    
8010764e:	66 90                	xchg   %ax,%ax
    return 0;
80107650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010765a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
80107662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	68 dd 85 10 80       	push   $0x801085dd
80107670:	e8 7b 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107675:	8b 45 0c             	mov    0xc(%ebp),%eax
80107678:	83 c4 10             	add    $0x10,%esp
8010767b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010767e:	74 0c                	je     8010768c <allocuvm+0x10c>
80107680:	8b 55 10             	mov    0x10(%ebp),%edx
80107683:	89 c1                	mov    %eax,%ecx
80107685:	89 f8                	mov    %edi,%eax
80107687:	e8 34 fa ff ff       	call   801070c0 <deallocuvm.part.0>
      kfree(mem);
8010768c:	83 ec 0c             	sub    $0xc,%esp
8010768f:	53                   	push   %ebx
80107690:	e8 2b af ff ff       	call   801025c0 <kfree>
      return 0;
80107695:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010769c:	83 c4 10             	add    $0x10,%esp
}
8010769f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a5:	5b                   	pop    %ebx
801076a6:	5e                   	pop    %esi
801076a7:	5f                   	pop    %edi
801076a8:	5d                   	pop    %ebp
801076a9:	c3                   	ret    
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076b0 <deallocuvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076bc:	39 d1                	cmp    %edx,%ecx
801076be:	73 10                	jae    801076d0 <deallocuvm+0x20>
}
801076c0:	5d                   	pop    %ebp
801076c1:	e9 fa f9 ff ff       	jmp    801070c0 <deallocuvm.part.0>
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
801076d0:	89 d0                	mov    %edx,%eax
801076d2:	5d                   	pop    %ebp
801076d3:	c3                   	ret    
801076d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop

801076e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	83 ec 0c             	sub    $0xc,%esp
801076e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076ec:	85 f6                	test   %esi,%esi
801076ee:	74 59                	je     80107749 <freevm+0x69>
  if(newsz >= oldsz)
801076f0:	31 c9                	xor    %ecx,%ecx
801076f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076f7:	89 f0                	mov    %esi,%eax
801076f9:	89 f3                	mov    %esi,%ebx
801076fb:	e8 c0 f9 ff ff       	call   801070c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107700:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107706:	eb 0f                	jmp    80107717 <freevm+0x37>
80107708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop
80107710:	83 c3 04             	add    $0x4,%ebx
80107713:	39 df                	cmp    %ebx,%edi
80107715:	74 23                	je     8010773a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107717:	8b 03                	mov    (%ebx),%eax
80107719:	a8 01                	test   $0x1,%al
8010771b:	74 f3                	je     80107710 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010771d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107722:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107725:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107728:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010772d:	50                   	push   %eax
8010772e:	e8 8d ae ff ff       	call   801025c0 <kfree>
80107733:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107736:	39 df                	cmp    %ebx,%edi
80107738:	75 dd                	jne    80107717 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010773a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010773d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107740:	5b                   	pop    %ebx
80107741:	5e                   	pop    %esi
80107742:	5f                   	pop    %edi
80107743:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107744:	e9 77 ae ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
80107749:	83 ec 0c             	sub    $0xc,%esp
8010774c:	68 f9 85 10 80       	push   $0x801085f9
80107751:	e8 7a 8c ff ff       	call   801003d0 <panic>
80107756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775d:	8d 76 00             	lea    0x0(%esi),%esi

80107760 <setupkvm>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	56                   	push   %esi
80107764:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107765:	e8 16 b0 ff ff       	call   80102780 <kalloc>
8010776a:	89 c6                	mov    %eax,%esi
8010776c:	85 c0                	test   %eax,%eax
8010776e:	74 42                	je     801077b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107770:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107773:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107778:	68 00 10 00 00       	push   $0x1000
8010777d:	6a 00                	push   $0x0
8010777f:	50                   	push   %eax
80107780:	e8 bb d5 ff ff       	call   80104d40 <memset>
80107785:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107788:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010778b:	83 ec 08             	sub    $0x8,%esp
8010778e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107791:	ff 73 0c             	push   0xc(%ebx)
80107794:	8b 13                	mov    (%ebx),%edx
80107796:	50                   	push   %eax
80107797:	29 c1                	sub    %eax,%ecx
80107799:	89 f0                	mov    %esi,%eax
8010779b:	e8 d0 f9 ff ff       	call   80107170 <mappages>
801077a0:	83 c4 10             	add    $0x10,%esp
801077a3:	85 c0                	test   %eax,%eax
801077a5:	78 19                	js     801077c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a7:	83 c3 10             	add    $0x10,%ebx
801077aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077b0:	75 d6                	jne    80107788 <setupkvm+0x28>
}
801077b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077b5:	89 f0                	mov    %esi,%eax
801077b7:	5b                   	pop    %ebx
801077b8:	5e                   	pop    %esi
801077b9:	5d                   	pop    %ebp
801077ba:	c3                   	ret    
801077bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077bf:	90                   	nop
      freevm(pgdir);
801077c0:	83 ec 0c             	sub    $0xc,%esp
801077c3:	56                   	push   %esi
      return 0;
801077c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077c6:	e8 15 ff ff ff       	call   801076e0 <freevm>
      return 0;
801077cb:	83 c4 10             	add    $0x10,%esp
}
801077ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d1:	89 f0                	mov    %esi,%eax
801077d3:	5b                   	pop    %ebx
801077d4:	5e                   	pop    %esi
801077d5:	5d                   	pop    %ebp
801077d6:	c3                   	ret    
801077d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077de:	66 90                	xchg   %ax,%ax

801077e0 <kvmalloc>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077e6:	e8 75 ff ff ff       	call   80107760 <setupkvm>
801077eb:	a3 04 72 11 80       	mov    %eax,0x80117204
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077f0:	05 00 00 00 80       	add    $0x80000000,%eax
801077f5:	0f 22 d8             	mov    %eax,%cr3
}
801077f8:	c9                   	leave  
801077f9:	c3                   	ret    
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	83 ec 08             	sub    $0x8,%esp
80107806:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107809:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010780c:	89 c1                	mov    %eax,%ecx
8010780e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107811:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107814:	f6 c2 01             	test   $0x1,%dl
80107817:	75 17                	jne    80107830 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107819:	83 ec 0c             	sub    $0xc,%esp
8010781c:	68 0a 86 10 80       	push   $0x8010860a
80107821:	e8 aa 8b ff ff       	call   801003d0 <panic>
80107826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107830:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107833:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107839:	25 fc 0f 00 00       	and    $0xffc,%eax
8010783e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107845:	85 c0                	test   %eax,%eax
80107847:	74 d0                	je     80107819 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107849:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010784c:	c9                   	leave  
8010784d:	c3                   	ret    
8010784e:	66 90                	xchg   %ax,%ax

80107850 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107859:	e8 02 ff ff ff       	call   80107760 <setupkvm>
8010785e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107861:	85 c0                	test   %eax,%eax
80107863:	0f 84 bd 00 00 00    	je     80107926 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107869:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010786c:	85 c9                	test   %ecx,%ecx
8010786e:	0f 84 b2 00 00 00    	je     80107926 <copyuvm+0xd6>
80107874:	31 f6                	xor    %esi,%esi
80107876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107880:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107883:	89 f0                	mov    %esi,%eax
80107885:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107888:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010788b:	a8 01                	test   $0x1,%al
8010788d:	75 11                	jne    801078a0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010788f:	83 ec 0c             	sub    $0xc,%esp
80107892:	68 14 86 10 80       	push   $0x80108614
80107897:	e8 34 8b ff ff       	call   801003d0 <panic>
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078a0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078a7:	c1 ea 0a             	shr    $0xa,%edx
801078aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078b7:	85 c0                	test   %eax,%eax
801078b9:	74 d4                	je     8010788f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078bb:	8b 00                	mov    (%eax),%eax
801078bd:	a8 01                	test   $0x1,%al
801078bf:	0f 84 9f 00 00 00    	je     80107964 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078c5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078c7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078cf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078d5:	e8 a6 ae ff ff       	call   80102780 <kalloc>
801078da:	89 c3                	mov    %eax,%ebx
801078dc:	85 c0                	test   %eax,%eax
801078de:	74 64                	je     80107944 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078e0:	83 ec 04             	sub    $0x4,%esp
801078e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078e9:	68 00 10 00 00       	push   $0x1000
801078ee:	57                   	push   %edi
801078ef:	50                   	push   %eax
801078f0:	e8 eb d4 ff ff       	call   80104de0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078f5:	58                   	pop    %eax
801078f6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078fc:	5a                   	pop    %edx
801078fd:	ff 75 e4             	push   -0x1c(%ebp)
80107900:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107905:	89 f2                	mov    %esi,%edx
80107907:	50                   	push   %eax
80107908:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010790b:	e8 60 f8 ff ff       	call   80107170 <mappages>
80107910:	83 c4 10             	add    $0x10,%esp
80107913:	85 c0                	test   %eax,%eax
80107915:	78 21                	js     80107938 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107917:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010791d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107920:	0f 87 5a ff ff ff    	ja     80107880 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107926:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010792c:	5b                   	pop    %ebx
8010792d:	5e                   	pop    %esi
8010792e:	5f                   	pop    %edi
8010792f:	5d                   	pop    %ebp
80107930:	c3                   	ret    
80107931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107938:	83 ec 0c             	sub    $0xc,%esp
8010793b:	53                   	push   %ebx
8010793c:	e8 7f ac ff ff       	call   801025c0 <kfree>
      goto bad;
80107941:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107944:	83 ec 0c             	sub    $0xc,%esp
80107947:	ff 75 e0             	push   -0x20(%ebp)
8010794a:	e8 91 fd ff ff       	call   801076e0 <freevm>
  return 0;
8010794f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107956:	83 c4 10             	add    $0x10,%esp
}
80107959:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795f:	5b                   	pop    %ebx
80107960:	5e                   	pop    %esi
80107961:	5f                   	pop    %edi
80107962:	5d                   	pop    %ebp
80107963:	c3                   	ret    
      panic("copyuvm: page not present");
80107964:	83 ec 0c             	sub    $0xc,%esp
80107967:	68 2e 86 10 80       	push   $0x8010862e
8010796c:	e8 5f 8a ff ff       	call   801003d0 <panic>
80107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797f:	90                   	nop

80107980 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107986:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107989:	89 c1                	mov    %eax,%ecx
8010798b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010798e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107991:	f6 c2 01             	test   $0x1,%dl
80107994:	0f 84 c0 01 00 00    	je     80107b5a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010799a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010799d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079a3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079a9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079b0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079b7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ba:	05 00 00 00 80       	add    $0x80000000,%eax
801079bf:	83 fa 05             	cmp    $0x5,%edx
801079c2:	ba 00 00 00 00       	mov    $0x0,%edx
801079c7:	0f 45 c2             	cmovne %edx,%eax
}
801079ca:	c3                   	ret    
801079cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079cf:	90                   	nop

801079d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 0c             	sub    $0xc,%esp
801079d9:	8b 75 14             	mov    0x14(%ebp),%esi
801079dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801079df:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079e2:	85 f6                	test   %esi,%esi
801079e4:	75 51                	jne    80107a37 <copyout+0x67>
801079e6:	e9 a5 00 00 00       	jmp    80107a90 <copyout+0xc0>
801079eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801079f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801079f6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801079fc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a02:	74 75                	je     80107a79 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a04:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a06:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a09:	29 c3                	sub    %eax,%ebx
80107a0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a11:	39 f3                	cmp    %esi,%ebx
80107a13:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a16:	29 f8                	sub    %edi,%eax
80107a18:	83 ec 04             	sub    $0x4,%esp
80107a1b:	01 c1                	add    %eax,%ecx
80107a1d:	53                   	push   %ebx
80107a1e:	52                   	push   %edx
80107a1f:	51                   	push   %ecx
80107a20:	e8 bb d3 ff ff       	call   80104de0 <memmove>
    len -= n;
    buf += n;
80107a25:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a28:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a2e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a31:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a33:	29 de                	sub    %ebx,%esi
80107a35:	74 59                	je     80107a90 <copyout+0xc0>
  if(*pde & PTE_P){
80107a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a3a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a3c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a3e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a41:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a47:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a4a:	f6 c1 01             	test   $0x1,%cl
80107a4d:	0f 84 0e 01 00 00    	je     80107b61 <copyout.cold>
  return &pgtab[PTX(va)];
80107a53:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a55:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a5b:	c1 eb 0c             	shr    $0xc,%ebx
80107a5e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a64:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a6b:	89 d9                	mov    %ebx,%ecx
80107a6d:	83 e1 05             	and    $0x5,%ecx
80107a70:	83 f9 05             	cmp    $0x5,%ecx
80107a73:	0f 84 77 ff ff ff    	je     801079f0 <copyout+0x20>
  }
  return 0;
}
80107a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a81:	5b                   	pop    %ebx
80107a82:	5e                   	pop    %esi
80107a83:	5f                   	pop    %edi
80107a84:	5d                   	pop    %ebp
80107a85:	c3                   	ret    
80107a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a8d:	8d 76 00             	lea    0x0(%esi),%esi
80107a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a93:	31 c0                	xor    %eax,%eax
}
80107a95:	5b                   	pop    %ebx
80107a96:	5e                   	pop    %esi
80107a97:	5f                   	pop    %edi
80107a98:	5d                   	pop    %ebp
80107a99:	c3                   	ret    
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107aa0 <retNumpp>:

// int retNumvp(){
//   return 0;
// }

int retNumpp(){
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
80107aa6:	83 ec 0c             	sub    $0xc,%esp
  int ii=0;
  pde_t *pgdir=myproc()->pgdir;
80107aa9:	e8 32 c0 ff ff       	call   80103ae0 <myproc>
  k=kmap;
  // void *va = k->virt;
  uint size = k->phys_end - k->phys_start;
  uint pa = k->phys_start;
  // int perm
  a = (char*)PGROUNDDOWN((uint)pa);
80107aae:	8b 15 24 b4 10 80    	mov    0x8010b424,%edx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
      return -1;
80107ab4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107ab9:	8b 1d 28 b4 10 80    	mov    0x8010b428,%ebx
  pde_t *pgdir=myproc()->pgdir;
80107abf:	8b 70 04             	mov    0x4(%eax),%esi
  a = (char*)PGROUNDDOWN((uint)pa);
80107ac2:	89 d0                	mov    %edx,%eax
  pde = &pgdir[PDX(va)];
80107ac4:	c1 ea 16             	shr    $0x16,%edx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107ac7:	83 eb 01             	sub    $0x1,%ebx
  if(*pde & PTE_P){
80107aca:	8b 14 96             	mov    (%esi,%edx,4),%edx
  a = (char*)PGROUNDDOWN((uint)pa);
80107acd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107ad2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(*pde & PTE_P){
80107ad8:	f6 c2 01             	test   $0x1,%dl
80107adb:	74 45                	je     80107b22 <retNumpp+0x82>
  return &pgtab[PTX(va)];
80107add:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107adf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107ae5:	c1 ef 0a             	shr    $0xa,%edi
80107ae8:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80107aee:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80107af5:	85 d2                	test   %edx,%edx
80107af7:	74 29                	je     80107b22 <retNumpp+0x82>
  int ii=0;
80107af9:	31 c9                	xor    %ecx,%ecx
    // if(*pte & PTE_P)
      // panic("remap");
    // *pte = pa | perm | PTE_P;
    if(a == last)
80107afb:	39 d8                	cmp    %ebx,%eax
80107afd:	74 23                	je     80107b22 <retNumpp+0x82>
80107aff:	90                   	nop
      break;
    a += PGSIZE;
    pa += PGSIZE;
    if((PTE_P & *pte)!=0){
80107b00:	8b 12                	mov    (%edx),%edx
    a += PGSIZE;
80107b02:	05 00 10 00 00       	add    $0x1000,%eax
    if((PTE_P & *pte)!=0){
80107b07:	83 e2 01             	and    $0x1,%edx
      ii++;
80107b0a:	83 fa 01             	cmp    $0x1,%edx
  pde = &pgdir[PDX(va)];
80107b0d:	89 c2                	mov    %eax,%edx
      ii++;
80107b0f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  pde = &pgdir[PDX(va)];
80107b12:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107b15:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107b18:	f6 c2 01             	test   $0x1,%dl
80107b1b:	75 13                	jne    80107b30 <retNumpp+0x90>
      return -1;
80107b1d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
    }
  }

  return ii;
80107b22:	83 c4 0c             	add    $0xc,%esp
80107b25:	89 c8                	mov    %ecx,%eax
80107b27:	5b                   	pop    %ebx
80107b28:	5e                   	pop    %esi
80107b29:	5f                   	pop    %edi
80107b2a:	5d                   	pop    %ebp
80107b2b:	c3                   	ret    
80107b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107b30:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b32:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107b38:	c1 ef 0a             	shr    $0xa,%edi
80107b3b:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80107b41:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80107b48:	85 d2                	test   %edx,%edx
80107b4a:	74 d1                	je     80107b1d <retNumpp+0x7d>
    if(a == last)
80107b4c:	39 c3                	cmp    %eax,%ebx
80107b4e:	75 b0                	jne    80107b00 <retNumpp+0x60>
80107b50:	83 c4 0c             	add    $0xc,%esp
80107b53:	89 c8                	mov    %ecx,%eax
80107b55:	5b                   	pop    %ebx
80107b56:	5e                   	pop    %esi
80107b57:	5f                   	pop    %edi
80107b58:	5d                   	pop    %ebp
80107b59:	c3                   	ret    

80107b5a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107b5a:	a1 00 00 00 00       	mov    0x0,%eax
80107b5f:	0f 0b                	ud2    

80107b61 <copyout.cold>:
80107b61:	a1 00 00 00 00       	mov    0x0,%eax
80107b66:	0f 0b                	ud2    
