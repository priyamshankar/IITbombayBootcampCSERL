
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
8010004c:	68 00 7b 10 80       	push   $0x80107b00
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 48 00 00       	call   80104880 <initlock>
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
80100098:	68 07 7b 10 80       	push   $0x80107b07
8010009d:	50                   	push   %eax
8010009e:	e8 ad 46 00 00       	call   80104750 <initsleeplock>
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
801000e4:	e8 67 49 00 00       	call   80104a50 <acquire>
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
8010017b:	e8 70 48 00 00       	call   801049f0 <release>
      acquiresleep(&b->lock);
80100180:	8d 43 0c             	lea    0xc(%ebx),%eax
80100183:	89 04 24             	mov    %eax,(%esp)
80100186:	e8 05 46 00 00       	call   80104790 <acquiresleep>
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
801001b9:	68 0e 7b 10 80       	push   $0x80107b0e
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
801001de:	e8 4d 46 00 00       	call   80104830 <holdingsleep>
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
801001fc:	68 1f 7b 10 80       	push   $0x80107b1f
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
8010021f:	e8 0c 46 00 00       	call   80104830 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	0f 84 87 00 00 00    	je     801002b6 <brelse+0xa6>
    panic("brelse");

  releasesleep(&b->lock);
8010022f:	83 ec 0c             	sub    $0xc,%esp
80100232:	56                   	push   %esi
80100233:	e8 b8 45 00 00       	call   801047f0 <releasesleep>

  acquire(&bcache.lock);
80100238:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010023f:	e8 0c 48 00 00       	call   80104a50 <acquire>
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
801002b1:	e9 3a 47 00 00       	jmp    801049f0 <release>
    panic("brelse");
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 26 7b 10 80       	push   $0x80107b26
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
801002f0:	e8 5b 47 00 00       	call   80104a50 <acquire>
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
80100346:	e8 a5 46 00 00       	call   801049f0 <release>
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
8010039c:	e8 4f 46 00 00       	call   801049f0 <release>
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
801003f2:	68 2d 7b 10 80       	push   $0x80107b2d
801003f7:	e8 f4 02 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003fc:	58                   	pop    %eax
801003fd:	ff 75 08             	push   0x8(%ebp)
80100400:	e8 eb 02 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
80100405:	c7 04 24 57 85 10 80 	movl   $0x80108557,(%esp)
8010040c:	e8 df 02 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
80100411:	8d 45 08             	lea    0x8(%ebp),%eax
80100414:	5a                   	pop    %edx
80100415:	59                   	pop    %ecx
80100416:	53                   	push   %ebx
80100417:	50                   	push   %eax
80100418:	e8 83 44 00 00       	call   801048a0 <getcallerpcs>
  for(i=0; i<10; i++)
8010041d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100420:	83 ec 08             	sub    $0x8,%esp
80100423:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
80100425:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100428:	68 41 7b 10 80       	push   $0x80107b41
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
8010046a:	e8 e1 60 00 00       	call   80106550 <uartputc>
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
80100555:	e8 f6 5f 00 00       	call   80106550 <uartputc>
8010055a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100561:	e8 ea 5f 00 00       	call   80106550 <uartputc>
80100566:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010056d:	e8 de 5f 00 00       	call   80106550 <uartputc>
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
801005a1:	e8 ba 47 00 00       	call   80104d60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005a6:	b8 80 07 00 00       	mov    $0x780,%eax
801005ab:	83 c4 0c             	add    $0xc,%esp
801005ae:	29 d8                	sub    %ebx,%eax
801005b0:	01 c0                	add    %eax,%eax
801005b2:	50                   	push   %eax
801005b3:	6a 00                	push   $0x0
801005b5:	56                   	push   %esi
801005b6:	e8 05 47 00 00       	call   80104cc0 <memset>
  outb(CRTPORT+1, pos);
801005bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
801005be:	83 c4 10             	add    $0x10,%esp
801005c1:	e9 20 ff ff ff       	jmp    801004e6 <consputc.part.0+0x96>
    panic("pos under/overflow");
801005c6:	83 ec 0c             	sub    $0xc,%esp
801005c9:	68 45 7b 10 80       	push   $0x80107b45
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
801005fb:	e8 50 44 00 00       	call   80104a50 <acquire>
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
80100634:	e8 b7 43 00 00       	call   801049f0 <release>
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
80100686:	0f b6 92 70 7b 10 80 	movzbl -0x7fef8490(%edx),%edx
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
80100838:	e8 13 42 00 00       	call   80104a50 <acquire>
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
80100888:	bf 58 7b 10 80       	mov    $0x80107b58,%edi
      for(; *s; s++)
8010088d:	b8 28 00 00 00       	mov    $0x28,%eax
80100892:	e9 19 ff ff ff       	jmp    801007b0 <cprintf+0xc0>
80100897:	89 d0                	mov    %edx,%eax
80100899:	e8 b2 fb ff ff       	call   80100450 <consputc.part.0>
8010089e:	e9 c8 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    release(&cons.lock);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 20 09 11 80       	push   $0x80110920
801008ab:	e8 40 41 00 00       	call   801049f0 <release>
801008b0:	83 c4 10             	add    $0x10,%esp
}
801008b3:	e9 c9 fe ff ff       	jmp    80100781 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008bb:	e9 ab fe ff ff       	jmp    8010076b <cprintf+0x7b>
    panic("null fmt");
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	68 5f 7b 10 80       	push   $0x80107b5f
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
801008e3:	e8 68 41 00 00       	call   80104a50 <acquire>
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
80100a20:	e8 cb 3f 00 00       	call   801049f0 <release>
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
80100ab6:	68 68 7b 10 80       	push   $0x80107b68
80100abb:	68 20 09 11 80       	push   $0x80110920
80100ac0:	e8 bb 3d 00 00       	call   80104880 <initlock>

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
80100b84:	e8 57 6b 00 00       	call   801076e0 <setupkvm>
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
80100bf3:	e8 08 69 00 00       	call   80107500 <allocuvm>
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
80100c29:	e8 e2 67 00 00       	call   80107410 <loaduvm>
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
80100c6b:	e8 f0 69 00 00       	call   80107660 <freevm>
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
80100cb2:	e8 49 68 00 00       	call   80107500 <allocuvm>
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
80100cd3:	e8 a8 6a 00 00       	call   80107780 <clearpteu>
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
80100d23:	e8 98 41 00 00       	call   80104ec0 <strlen>
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
80100d37:	e8 84 41 00 00       	call   80104ec0 <strlen>
80100d3c:	83 c0 01             	add    $0x1,%eax
80100d3f:	50                   	push   %eax
80100d40:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d43:	ff 34 b8             	push   (%eax,%edi,4)
80100d46:	53                   	push   %ebx
80100d47:	56                   	push   %esi
80100d48:	e8 03 6c 00 00       	call   80107950 <copyout>
80100d4d:	83 c4 20             	add    $0x20,%esp
80100d50:	85 c0                	test   %eax,%eax
80100d52:	79 ac                	jns    80100d00 <exec+0x200>
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d58:	83 ec 0c             	sub    $0xc,%esp
80100d5b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d61:	e8 fa 68 00 00       	call   80107660 <freevm>
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
80100db3:	e8 98 6b 00 00       	call   80107950 <copyout>
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
80100df1:	e8 8a 40 00 00       	call   80104e80 <safestrcpy>
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
80100e1d:	e8 5e 64 00 00       	call   80107280 <switchuvm>
  freevm(oldpgdir);
80100e22:	89 3c 24             	mov    %edi,(%esp)
80100e25:	e8 36 68 00 00       	call   80107660 <freevm>
  return 0;
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	31 c0                	xor    %eax,%eax
80100e2f:	e9 38 fd ff ff       	jmp    80100b6c <exec+0x6c>
    end_op();
80100e34:	e8 a7 20 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100e39:	83 ec 0c             	sub    $0xc,%esp
80100e3c:	68 81 7b 10 80       	push   $0x80107b81
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
80100e66:	68 8d 7b 10 80       	push   $0x80107b8d
80100e6b:	68 c0 09 11 80       	push   $0x801109c0
80100e70:	e8 0b 3a 00 00       	call   80104880 <initlock>
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
80100e91:	e8 ba 3b 00 00       	call   80104a50 <acquire>
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
80100ec1:	e8 2a 3b 00 00       	call   801049f0 <release>
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
80100eda:	e8 11 3b 00 00       	call   801049f0 <release>
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
80100eff:	e8 4c 3b 00 00       	call   80104a50 <acquire>
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
80100f1c:	e8 cf 3a 00 00       	call   801049f0 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 94 7b 10 80       	push   $0x80107b94
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
80100f51:	e8 fa 3a 00 00       	call   80104a50 <acquire>
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
80100f8c:	e8 5f 3a 00 00       	call   801049f0 <release>

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
80100fbe:	e9 2d 3a 00 00       	jmp    801049f0 <release>
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
8010100c:	68 9c 7b 10 80       	push   $0x80107b9c
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
801010f2:	68 a6 7b 10 80       	push   $0x80107ba6
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
801011c7:	68 af 7b 10 80       	push   $0x80107baf
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
80101201:	68 b5 7b 10 80       	push   $0x80107bb5
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
8010127d:	68 bf 7b 10 80       	push   $0x80107bbf
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
8010133b:	68 d2 7b 10 80       	push   $0x80107bd2
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
80101383:	e8 38 39 00 00       	call   80104cc0 <memset>
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
801013ca:	e8 81 36 00 00       	call   80104a50 <acquire>
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
8010143a:	e8 b1 35 00 00       	call   801049f0 <release>

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
80101465:	e8 86 35 00 00       	call   801049f0 <release>
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
80101498:	68 e8 7b 10 80       	push   $0x80107be8
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
80101575:	68 f8 7b 10 80       	push   $0x80107bf8
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
801015a4:	e8 b7 37 00 00       	call   80104d60 <memmove>
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
801015cc:	68 0b 7c 10 80       	push   $0x80107c0b
801015d1:	68 20 14 11 80       	push   $0x80111420
801015d6:	e8 a5 32 00 00       	call   80104880 <initlock>
  for(i = 0; i < NINODE; i++) {
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	68 12 7c 10 80       	push   $0x80107c12
801015e8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015e9:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ef:	e8 5c 31 00 00       	call   80104750 <initsleeplock>
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
8010161f:	e8 3c 37 00 00       	call   80104d60 <memmove>
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
80101656:	68 78 7c 10 80       	push   $0x80107c78
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
801016f1:	e8 ca 35 00 00       	call   80104cc0 <memset>
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
80101726:	68 18 7c 10 80       	push   $0x80107c18
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
8010179d:	e8 be 35 00 00       	call   80104d60 <memmove>
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
801017cf:	e8 7c 32 00 00       	call   80104a50 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
801017df:	e8 0c 32 00 00       	call   801049f0 <release>
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
80101812:	e8 79 2f 00 00       	call   80104790 <acquiresleep>
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
8010189d:	e8 be 34 00 00       	call   80104d60 <memmove>
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
801018c8:	68 30 7c 10 80       	push   $0x80107c30
801018cd:	e8 fe ea ff ff       	call   801003d0 <panic>
    panic("ilock");
801018d2:	83 ec 0c             	sub    $0xc,%esp
801018d5:	68 2a 7c 10 80       	push   $0x80107c2a
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
801018f3:	e8 38 2f 00 00       	call   80104830 <holdingsleep>
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
8010190f:	e9 dc 2e 00 00       	jmp    801047f0 <releasesleep>
    panic("iunlock");
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 3f 7c 10 80       	push   $0x80107c3f
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
80101940:	e8 4b 2e 00 00       	call   80104790 <acquiresleep>
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
80101960:	e8 8b 2e 00 00       	call   801047f0 <releasesleep>
  acquire(&icache.lock);
80101965:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
8010196c:	e8 df 30 00 00       	call   80104a50 <acquire>
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
80101986:	e9 65 30 00 00       	jmp    801049f0 <release>
8010198b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop
    acquire(&icache.lock);
80101990:	83 ec 0c             	sub    $0xc,%esp
80101993:	68 20 14 11 80       	push   $0x80111420
80101998:	e8 b3 30 00 00       	call   80104a50 <acquire>
    int r = ip->ref;
8010199d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019a0:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
801019a7:	e8 44 30 00 00       	call   801049f0 <release>
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
80101ac3:	e8 68 2d 00 00       	call   80104830 <holdingsleep>
80101ac8:	83 c4 10             	add    $0x10,%esp
80101acb:	85 c0                	test   %eax,%eax
80101acd:	74 21                	je     80101af0 <iunlockput+0x40>
80101acf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ad2:	85 c0                	test   %eax,%eax
80101ad4:	7e 1a                	jle    80101af0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ad6:	83 ec 0c             	sub    $0xc,%esp
80101ad9:	56                   	push   %esi
80101ada:	e8 11 2d 00 00       	call   801047f0 <releasesleep>
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
80101af3:	68 3f 7c 10 80       	push   $0x80107c3f
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
80101bf2:	e8 69 31 00 00       	call   80104d60 <memmove>
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
80101cfe:	e8 5d 30 00 00       	call   80104d60 <memmove>
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
80101d9e:	e8 2d 30 00 00       	call   80104dd0 <strncmp>
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
80101e05:	e8 c6 2f 00 00       	call   80104dd0 <strncmp>
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
80101e52:	68 59 7c 10 80       	push   $0x80107c59
80101e57:	e8 74 e5 ff ff       	call   801003d0 <panic>
    panic("dirlookup not DIR");
80101e5c:	83 ec 0c             	sub    $0xc,%esp
80101e5f:	68 47 7c 10 80       	push   $0x80107c47
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
80101e9a:	e8 b1 2b 00 00       	call   80104a50 <acquire>
  ip->ref++;
80101e9f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ea3:	c7 04 24 20 14 11 80 	movl   $0x80111420,(%esp)
80101eaa:	e8 41 2b 00 00       	call   801049f0 <release>
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
80101f07:	e8 54 2e 00 00       	call   80104d60 <memmove>
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
80101f6f:	e8 bc 28 00 00       	call   80104830 <holdingsleep>
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
80101f91:	e8 5a 28 00 00       	call   801047f0 <releasesleep>
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
80101fc3:	e8 98 2d 00 00       	call   80104d60 <memmove>
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
8010201b:	e8 10 28 00 00       	call   80104830 <holdingsleep>
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 84 91 00 00 00    	je     801020bc <namex+0x24c>
8010202b:	8b 46 08             	mov    0x8(%esi),%eax
8010202e:	85 c0                	test   %eax,%eax
80102030:	0f 8e 86 00 00 00    	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	53                   	push   %ebx
8010203a:	e8 b1 27 00 00       	call   801047f0 <releasesleep>
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
8010205d:	e8 ce 27 00 00       	call   80104830 <holdingsleep>
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
80102080:	e8 ab 27 00 00       	call   80104830 <holdingsleep>
80102085:	83 c4 10             	add    $0x10,%esp
80102088:	85 c0                	test   %eax,%eax
8010208a:	74 30                	je     801020bc <namex+0x24c>
8010208c:	8b 7e 08             	mov    0x8(%esi),%edi
8010208f:	85 ff                	test   %edi,%edi
80102091:	7e 29                	jle    801020bc <namex+0x24c>
  releasesleep(&ip->lock);
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	53                   	push   %ebx
80102097:	e8 54 27 00 00       	call   801047f0 <releasesleep>
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
801020bf:	68 3f 7c 10 80       	push   $0x80107c3f
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
80102138:	e8 e3 2c 00 00       	call   80104e20 <strncpy>
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
80102176:	68 68 7c 10 80       	push   $0x80107c68
8010217b:	e8 50 e2 ff ff       	call   801003d0 <panic>
    panic("dirlink");
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 ee 82 10 80       	push   $0x801082ee
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
8010228e:	68 d4 7c 10 80       	push   $0x80107cd4
80102293:	e8 38 e1 ff ff       	call   801003d0 <panic>
    panic("idestart");
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	68 cb 7c 10 80       	push   $0x80107ccb
801022a0:	e8 2b e1 ff ff       	call   801003d0 <panic>
801022a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideinit>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022b6:	68 e6 7c 10 80       	push   $0x80107ce6
801022bb:	68 a0 40 11 80       	push   $0x801140a0
801022c0:	e8 bb 25 00 00       	call   80104880 <initlock>
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
8010233e:	e8 0d 27 00 00       	call   80104a50 <acquire>

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
801023be:	e8 2d 26 00 00       	call   801049f0 <release>

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
801023de:	e8 4d 24 00 00       	call   80104830 <holdingsleep>
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
80102418:	e8 33 26 00 00       	call   80104a50 <acquire>

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
80102486:	e9 65 25 00 00       	jmp    801049f0 <release>
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
801024aa:	68 15 7d 10 80       	push   $0x80107d15
801024af:	e8 1c df ff ff       	call   801003d0 <panic>
    panic("iderw: nothing to do");
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	68 00 7d 10 80       	push   $0x80107d00
801024bc:	e8 0f df ff ff       	call   801003d0 <panic>
    panic("iderw: buf not locked");
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	68 ea 7c 10 80       	push   $0x80107cea
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
8010251a:	68 34 7d 10 80       	push   $0x80107d34
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
801025f2:	e8 c9 26 00 00       	call   80104cc0 <memset>

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
80102628:	e8 23 24 00 00       	call   80104a50 <acquire>
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	eb d2                	jmp    80102604 <kfree+0x44>
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102638:	c7 45 08 40 41 11 80 	movl   $0x80114140,0x8(%ebp)
}
8010263f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102642:	c9                   	leave  
    release(&kmem.lock);
80102643:	e9 a8 23 00 00       	jmp    801049f0 <release>
    panic("kfree");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 66 7d 10 80       	push   $0x80107d66
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
8010271b:	68 6c 7d 10 80       	push   $0x80107d6c
80102720:	68 40 41 11 80       	push   $0x80114140
80102725:	e8 56 21 00 00       	call   80104880 <initlock>
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
801027b3:	e8 98 22 00 00       	call   80104a50 <acquire>
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
801027e1:	e8 0a 22 00 00       	call   801049f0 <release>
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
8010282b:	0f b6 91 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%edx
  shift ^= togglecode[data];
80102832:	0f b6 81 a0 7d 10 80 	movzbl -0x7fef8260(%ecx),%eax
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
8010284b:	8b 04 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%eax
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
80102888:	0f b6 81 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%eax
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
80102bf7:	e8 14 21 00 00       	call   80104d10 <memcmp>
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
80102d2a:	e8 31 20 00 00       	call   80104d60 <memmove>
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
80102dda:	68 a0 7f 10 80       	push   $0x80107fa0
80102ddf:	68 e0 41 11 80       	push   $0x801141e0
80102de4:	e8 97 1a 00 00       	call   80104880 <initlock>
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
80102e7b:	e8 d0 1b 00 00       	call   80104a50 <acquire>
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
80102ecc:	e8 1f 1b 00 00       	call   801049f0 <release>
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
80102eee:	e8 5d 1b 00 00       	call   80104a50 <acquire>
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
80102f2c:	e8 bf 1a 00 00       	call   801049f0 <release>
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
80102f46:	e8 05 1b 00 00       	call   80104a50 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
    log.committing = 0;
80102f52:	c7 05 70 42 11 80 00 	movl   $0x0,0x80114270
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 ef 12 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 e0 41 11 80 	movl   $0x801141e0,(%esp)
80102f68:	e8 83 1a 00 00       	call   801049f0 <release>
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
80102fca:	e8 91 1d 00 00       	call   80104d60 <memmove>
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
80103024:	e8 c7 19 00 00       	call   801049f0 <release>
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
80103037:	68 a4 7f 10 80       	push   $0x80107fa4
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
80103086:	e8 c5 19 00 00       	call   80104a50 <acquire>
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
801030c5:	e9 26 19 00 00       	jmp    801049f0 <release>
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
801030f1:	68 b3 7f 10 80       	push   $0x80107fb3
801030f6:	e8 d5 d2 ff ff       	call   801003d0 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 c9 7f 10 80       	push   $0x80107fc9
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
80103128:	68 e4 7f 10 80       	push   $0x80107fe4
8010312d:	e8 be d5 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
80103132:	e8 49 30 00 00       	call   80106180 <idtinit>
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
80103156:	e8 15 41 00 00       	call   80107270 <switchkvm>
  seginit();
8010315b:	e8 80 40 00 00       	call   801071e0 <seginit>
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
80103191:	e8 ca 45 00 00       	call   80107760 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 50 f7 ff ff       	call   801028f0 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 3b 40 00 00       	call   801071e0 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 21 f3 ff ff       	call   801024d0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 fc d8 ff ff       	call   80100ab0 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 b7 32 00 00       	call   80106470 <uartinit>
  pinit();         // process table
801031b9:	e8 82 08 00 00       	call   80103a40 <pinit>
  tvinit();        // trap vectors
801031be:	e8 3d 2f 00 00       	call   80106100 <tvinit>
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
801031e4:	e8 77 1b 00 00       	call   80104d60 <memmove>

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
801032ce:	68 f8 7f 10 80       	push   $0x80107ff8
801032d3:	56                   	push   %esi
801032d4:	e8 37 1a 00 00       	call   80104d10 <memcmp>
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
80103386:	68 fd 7f 10 80       	push   $0x80107ffd
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 7c 19 00 00       	call   80104d10 <memcmp>
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
801034a3:	68 02 80 10 80       	push   $0x80108002
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
801034d2:	68 f8 7f 10 80       	push   $0x80107ff8
801034d7:	53                   	push   %ebx
801034d8:	e8 33 18 00 00       	call   80104d10 <memcmp>
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
80103508:	68 1c 80 10 80       	push   $0x8010801c
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
801035b3:	68 3b 80 10 80       	push   $0x8010803b
801035b8:	50                   	push   %eax
801035b9:	e8 c2 12 00 00       	call   80104880 <initlock>
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
8010364f:	e8 fc 13 00 00       	call   80104a50 <acquire>
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
80103694:	e9 57 13 00 00       	jmp    801049f0 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 47 13 00 00       	call   801049f0 <release>
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
801036ed:	e8 5e 13 00 00       	call   80104a50 <acquire>
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
8010377c:	e8 6f 12 00 00       	call   801049f0 <release>
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
801037d5:	e8 16 12 00 00       	call   801049f0 <release>
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
80103806:	e8 45 12 00 00       	call   80104a50 <acquire>
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
801038a1:	e8 4a 11 00 00       	call   801049f0 <release>
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
801038c1:	e8 2a 11 00 00       	call   801049f0 <release>
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
80103931:	e8 1a 11 00 00       	call   80104a50 <acquire>
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
80103972:	e8 79 10 00 00       	call   801049f0 <release>
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
80103997:	c7 40 14 f4 60 10 80 	movl   $0x801060f4,0x14(%eax)
  p->context = (struct context *)sp;
8010399e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039a1:	6a 14                	push   $0x14
801039a3:	6a 00                	push   $0x0
801039a5:	50                   	push   %eax
801039a6:	e8 15 13 00 00       	call   80104cc0 <memset>
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
801039ca:	e8 21 10 00 00       	call   801049f0 <release>
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
801039fb:	e8 f0 0f 00 00       	call   801049f0 <release>
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
80103a46:	68 40 80 10 80       	push   $0x80108040
80103a4b:	68 a0 48 11 80       	push   $0x801148a0
80103a50:	e8 2b 0e 00 00       	call   80104880 <initlock>
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
80103aa8:	68 47 80 10 80       	push   $0x80108047
80103aad:	e8 1e c9 ff ff       	call   801003d0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	68 4c 81 10 80       	push   $0x8010814c
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
80103ae7:	e8 14 0e 00 00       	call   80104900 <pushcli>
  c = mycpu();
80103aec:	e8 6f ff ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103af1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af7:	e8 54 0e 00 00       	call   80104950 <popcli>
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
80103b23:	e8 b8 3b 00 00       	call   801076e0 <setupkvm>
80103b28:	89 43 04             	mov    %eax,0x4(%ebx)
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	0f 84 bd 00 00 00    	je     80103bf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b33:	83 ec 04             	sub    $0x4,%esp
80103b36:	68 2c 00 00 00       	push   $0x2c
80103b3b:	68 60 b4 10 80       	push   $0x8010b460
80103b40:	50                   	push   %eax
80103b41:	e8 4a 38 00 00       	call   80107390 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b4f:	6a 4c                	push   $0x4c
80103b51:	6a 00                	push   $0x0
80103b53:	ff 73 18             	push   0x18(%ebx)
80103b56:	e8 65 11 00 00       	call   80104cc0 <memset>
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
80103baf:	68 70 80 10 80       	push   $0x80108070
80103bb4:	50                   	push   %eax
80103bb5:	e8 c6 12 00 00       	call   80104e80 <safestrcpy>
  p->cwd = namei("/");
80103bba:	c7 04 24 79 80 10 80 	movl   $0x80108079,(%esp)
80103bc1:	e8 ca e5 ff ff       	call   80102190 <namei>
80103bc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bc9:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103bd0:	e8 7b 0e 00 00       	call   80104a50 <acquire>
  p->state = RUNNABLE;
80103bd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bdc:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103be3:	e8 08 0e 00 00       	call   801049f0 <release>
}
80103be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103beb:	83 c4 10             	add    $0x10,%esp
80103bee:	c9                   	leave  
80103bef:	c3                   	ret    
    panic("userinit: out of memory?");
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	68 57 80 10 80       	push   $0x80108057
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
80103c08:	e8 f3 0c 00 00       	call   80104900 <pushcli>
  c = mycpu();
80103c0d:	e8 4e fe ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c18:	e8 33 0d 00 00       	call   80104950 <popcli>
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
80103c2b:	e8 50 36 00 00       	call   80107280 <switchuvm>
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
80103c4a:	e8 b1 38 00 00       	call   80107500 <allocuvm>
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
80103c6a:	e8 c1 39 00 00       	call   80107630 <deallocuvm>
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
80103c89:	e8 72 0c 00 00       	call   80104900 <pushcli>
  c = mycpu();
80103c8e:	e8 cd fd ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 b2 0c 00 00       	call   80104950 <popcli>
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
80103cb8:	e8 13 3b 00 00       	call   801077d0 <copyuvm>
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
80103d31:	e8 4a 11 00 00       	call   80104e80 <safestrcpy>
  pid = np->pid;
80103d36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d39:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103d40:	e8 0b 0d 00 00       	call   80104a50 <acquire>
  np->state = RUNNABLE;
80103d45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d4c:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80103d53:	e8 98 0c 00 00       	call   801049f0 <release>
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
80103dce:	e8 7d 0c 00 00       	call   80104a50 <acquire>
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
80103df7:	e8 84 34 00 00       	call   80107280 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dfc:	58                   	pop    %eax
80103dfd:	5a                   	pop    %edx
80103dfe:	ff 73 1c             	push   0x1c(%ebx)
80103e01:	57                   	push   %edi
      p->state = RUNNING;
80103e02:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e09:	e8 cd 10 00 00       	call   80104edb <swtch>
      switchkvm();
80103e0e:	e8 5d 34 00 00       	call   80107270 <switchkvm>
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
80103e33:	e8 b8 0b 00 00       	call   801049f0 <release>
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
80103e45:	e8 b6 0a 00 00       	call   80104900 <pushcli>
  c = mycpu();
80103e4a:	e8 11 fc ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103e4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e55:	e8 f6 0a 00 00       	call   80104950 <popcli>
  if (!holding(&ptable.lock))
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 a0 48 11 80       	push   $0x801148a0
80103e62:	e8 49 0b 00 00       	call   801049b0 <holding>
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
80103ea3:	e8 33 10 00 00       	call   80104edb <swtch>
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
80103ec0:	68 7b 80 10 80       	push   $0x8010807b
80103ec5:	e8 06 c5 ff ff       	call   801003d0 <panic>
    panic("sched interruptible");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 a7 80 10 80       	push   $0x801080a7
80103ed2:	e8 f9 c4 ff ff       	call   801003d0 <panic>
    panic("sched running");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 99 80 10 80       	push   $0x80108099
80103edf:	e8 ec c4 ff ff       	call   801003d0 <panic>
    panic("sched locks");
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	68 8d 80 10 80       	push   $0x8010808d
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
80103f6a:	e8 e1 0a 00 00       	call   80104a50 <acquire>
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
80103ff7:	68 c8 80 10 80       	push   $0x801080c8
80103ffc:	e8 cf c3 ff ff       	call   801003d0 <panic>
    panic("init exiting");
80104001:	83 ec 0c             	sub    $0xc,%esp
80104004:	68 bb 80 10 80       	push   $0x801080bb
80104009:	e8 c2 c3 ff ff       	call   801003d0 <panic>
8010400e:	66 90                	xchg   %ax,%ax

80104010 <wait>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  pushcli();
80104015:	e8 e6 08 00 00       	call   80104900 <pushcli>
  c = mycpu();
8010401a:	e8 41 fa ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010401f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104025:	e8 26 09 00 00       	call   80104950 <popcli>
  acquire(&ptable.lock);
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 a0 48 11 80       	push   $0x801148a0
80104032:	e8 19 0a 00 00       	call   80104a50 <acquire>
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
80104081:	e8 7a 08 00 00       	call   80104900 <pushcli>
  c = mycpu();
80104086:	e8 d5 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010408b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104091:	e8 ba 08 00 00       	call   80104950 <popcli>
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
801040d9:	e8 82 35 00 00       	call   80107660 <freevm>
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
80104105:	e8 e6 08 00 00       	call   801049f0 <release>
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
80104123:	e8 c8 08 00 00       	call   801049f0 <release>
      return -1;
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	eb e0                	jmp    8010410d <wait+0xfd>
    panic("sleep");
8010412d:	83 ec 0c             	sub    $0xc,%esp
80104130:	68 d4 80 10 80       	push   $0x801080d4
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
8010414c:	e8 ff 08 00 00       	call   80104a50 <acquire>
  pushcli();
80104151:	e8 aa 07 00 00       	call   80104900 <pushcli>
  c = mycpu();
80104156:	e8 05 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 ea 07 00 00       	call   80104950 <popcli>
  myproc()->state = RUNNABLE;
80104166:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010416d:	e8 ce fc ff ff       	call   80103e40 <sched>
  release(&ptable.lock);
80104172:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80104179:	e8 72 08 00 00       	call   801049f0 <release>
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
8010419f:	e8 5c 07 00 00       	call   80104900 <pushcli>
  c = mycpu();
801041a4:	e8 b7 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801041a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041af:	e8 9c 07 00 00       	call   80104950 <popcli>
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
801041d0:	e8 7b 08 00 00       	call   80104a50 <acquire>
    release(lk);
801041d5:	89 34 24             	mov    %esi,(%esp)
801041d8:	e8 13 08 00 00       	call   801049f0 <release>
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
801041fa:	e8 f1 07 00 00       	call   801049f0 <release>
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
8010420c:	e9 3f 08 00 00       	jmp    80104a50 <acquire>
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
80104239:	68 da 80 10 80       	push   $0x801080da
8010423e:	e8 8d c1 ff ff       	call   801003d0 <panic>
    panic("sleep");
80104243:	83 ec 0c             	sub    $0xc,%esp
80104246:	68 d4 80 10 80       	push   $0x801080d4
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
8010425f:	e8 ec 07 00 00       	call   80104a50 <acquire>
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
801042a1:	e9 4a 07 00 00       	jmp    801049f0 <release>
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
801042bf:	e8 8c 07 00 00       	call   80104a50 <acquire>
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
801042fb:	e8 f0 06 00 00       	call   801049f0 <release>
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
80104318:	e8 d3 06 00 00       	call   801049f0 <release>
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
8010434b:	68 57 85 10 80       	push   $0x80108557
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
8010436e:	ba eb 80 10 80       	mov    $0x801080eb,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104373:	83 f8 05             	cmp    $0x5,%eax
80104376:	77 11                	ja     80104389 <procdump+0x59>
80104378:	8b 14 85 74 81 10 80 	mov    -0x7fef7e8c(,%eax,4),%edx
      state = "???";
8010437f:	b8 eb 80 10 80       	mov    $0x801080eb,%eax
80104384:	85 d2                	test   %edx,%edx
80104386:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104389:	53                   	push   %ebx
8010438a:	52                   	push   %edx
8010438b:	ff 73 a4             	push   -0x5c(%ebx)
8010438e:	68 ef 80 10 80       	push   $0x801080ef
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
801043b5:	e8 e6 04 00 00       	call   801048a0 <getcallerpcs>
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
801043cd:	68 41 7b 10 80       	push   $0x80107b41
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
80104411:	e8 ea 04 00 00       	call   80104900 <pushcli>
  c = mycpu();
80104416:	e8 45 f6 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010441b:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104421:	e8 2a 05 00 00       	call   80104950 <popcli>
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
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 75 08             	mov    0x8(%ebp),%esi
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104458:	bb 24 49 11 80       	mov    $0x80114924,%ebx
  acquire(&ptable.lock);
8010445d:	83 ec 0c             	sub    $0xc,%esp
80104460:	68 a0 48 11 80       	push   $0x801148a0
80104465:	e8 e6 05 00 00       	call   80104a50 <acquire>
8010446a:	83 c4 10             	add    $0x10,%esp
8010446d:	eb 0c                	jmp    8010447b <get_siblings_info+0x2b>
8010446f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104470:	83 eb 80             	sub    $0xffffff80,%ebx
80104473:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
80104479:	74 30                	je     801044ab <get_siblings_info+0x5b>
  {
    if (p->parent->pid == pid)
8010447b:	8b 43 14             	mov    0x14(%ebx),%eax
8010447e:	39 70 10             	cmp    %esi,0x10(%eax)
80104481:	75 ed                	jne    80104470 <get_siblings_info+0x20>
    {
      cprintf("%d %s\n", p->pid, states[p->state]);//p->states return integer
80104483:	8b 43 0c             	mov    0xc(%ebx),%eax
80104486:	83 ec 04             	sub    $0x4,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104489:	83 eb 80             	sub    $0xffffff80,%ebx
      cprintf("%d %s\n", p->pid, states[p->state]);//p->states return integer
8010448c:	ff 34 85 74 81 10 80 	push   -0x7fef7e8c(,%eax,4)
80104493:	ff 73 90             	push   -0x70(%ebx)
80104496:	68 f8 80 10 80       	push   $0x801080f8
8010449b:	e8 50 c2 ff ff       	call   801006f0 <cprintf>
801044a0:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a3:	81 fb 24 69 11 80    	cmp    $0x80116924,%ebx
801044a9:	75 d0                	jne    8010447b <get_siblings_info+0x2b>
    // cprintf("%s\n", curproc->state);
    // cprintf("state is: %s\n", p->state);
  }

  // cprintf("this is the state%s\n",procstate[p->state]);
  release(&ptable.lock);
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	68 a0 48 11 80       	push   $0x801148a0
801044b3:	e8 38 05 00 00       	call   801049f0 <release>
  return 0;
}
801044b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044bb:	31 c0                	xor    %eax,%eax
801044bd:	5b                   	pop    %ebx
801044be:	5e                   	pop    %esi
801044bf:	5d                   	pop    %ebp
801044c0:	c3                   	ret    
801044c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cf:	90                   	nop

801044d0 <compare>:

//program to compare two strings
int compare(char a[],char b[])  
{  
801044d0:	55                   	push   %ebp
801044d1:	31 c0                	xor    %eax,%eax
801044d3:	89 e5                	mov    %esp,%ebp
801044d5:	56                   	push   %esi
801044d6:	53                   	push   %ebx
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044da:	8b 75 0c             	mov    0xc(%ebp),%esi
    int flag=0,i=0;  // integer variables declaration  
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801044dd:	0f b6 13             	movzbl (%ebx),%edx
801044e0:	84 d2                	test   %dl,%dl
801044e2:	75 1b                	jne    801044ff <compare+0x2f>
801044e4:	eb 21                	jmp    80104507 <compare+0x37>
801044e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    {  
       if(a[i]!=b[i])  
801044f0:	38 d1                	cmp    %dl,%cl
801044f2:	75 1c                	jne    80104510 <compare+0x40>
       {  
           flag=1;  
           break;  
       }  
       i++;  
801044f4:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801044f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
801044fb:	84 d2                	test   %dl,%dl
801044fd:	74 08                	je     80104507 <compare+0x37>
801044ff:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104503:	84 c9                	test   %cl,%cl
80104505:	75 e9                	jne    801044f0 <compare+0x20>
    }  
    if(flag==0)  
    return 1;  
    else  
    return 0;  
}  
80104507:	5b                   	pop    %ebx
    return 1;  
80104508:	b8 01 00 00 00       	mov    $0x1,%eax
}  
8010450d:	5e                   	pop    %esi
8010450e:	5d                   	pop    %ebp
8010450f:	c3                   	ret    
80104510:	5b                   	pop    %ebx
    return 0;  
80104511:	31 c0                	xor    %eax,%eax
}  
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451d:	8d 76 00             	lea    0x0(%esi),%esi

80104520 <signalProcess>:

void signalProcess(int pid, char type[]){
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
  // cprintf("%d\n%d\n",pid,myproc()->pid);

  struct proc *p;
  acquire(&ptable.lock);
  // char type1=type[0];
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80104525:	be 24 49 11 80       	mov    $0x80114924,%esi
void signalProcess(int pid, char type[]){
8010452a:	53                   	push   %ebx
8010452b:	83 ec 28             	sub    $0x28,%esp
8010452e:	8b 45 08             	mov    0x8(%ebp),%eax
80104531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  acquire(&ptable.lock);
80104534:	68 a0 48 11 80       	push   $0x801148a0
void signalProcess(int pid, char type[]){
80104539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
8010453c:	e8 0f 05 00 00       	call   80104a50 <acquire>
80104541:	83 c4 10             	add    $0x10,%esp
80104544:	eb 15                	jmp    8010455b <signalProcess+0x3b>
80104546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p=ptable.proc; p<&ptable.proc[NPROC];p++){
80104550:	83 ee 80             	sub    $0xffffff80,%esi
80104553:	81 fe 24 69 11 80    	cmp    $0x80116924,%esi
80104559:	74 56                	je     801045b1 <signalProcess+0x91>
    if(pid==p->pid){
8010455b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010455e:	39 46 10             	cmp    %eax,0x10(%esi)
80104561:	75 ed                	jne    80104550 <signalProcess+0x30>
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104563:	0f b6 13             	movzbl (%ebx),%edx
80104566:	84 d2                	test   %dl,%dl
80104568:	74 30                	je     8010459a <signalProcess+0x7a>
8010456a:	89 d1                	mov    %edx,%ecx
8010456c:	bf 50 00 00 00       	mov    $0x50,%edi
80104571:	88 55 e3             	mov    %dl,-0x1d(%ebp)
    int flag=0,i=0;  // integer variables declaration  
80104574:	31 c0                	xor    %eax,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104576:	89 fa                	mov    %edi,%edx
80104578:	89 cf                	mov    %ecx,%edi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       if(a[i]!=b[i])  
80104580:	38 ca                	cmp    %cl,%dl
80104582:	75 44                	jne    801045c8 <signalProcess+0xa8>
       i++;  
80104584:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
80104587:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
8010458b:	84 c9                	test   %cl,%cl
8010458d:	74 0b                	je     8010459a <signalProcess+0x7a>
8010458f:	0f b6 90 ff 80 10 80 	movzbl -0x7fef7f01(%eax),%edx
80104596:	84 d2                	test   %dl,%dl
80104598:	75 e6                	jne    80104580 <signalProcess+0x60>
      // p->state=type1;
      if(compare(type,"PAUSE")){
        cprintf("pause");
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	68 1c 81 10 80       	push   $0x8010811c
801045a2:	e8 49 c1 ff ff       	call   801006f0 <cprintf>
        p->PAUSE=1;
801045a7:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
        break;
801045ae:	83 c4 10             	add    $0x10,%esp
        break;
      }

    }
  }
  release(&ptable.lock);
801045b1:	c7 45 08 a0 48 11 80 	movl   $0x801148a0,0x8(%ebp)
  // sched();
}
801045b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045bb:	5b                   	pop    %ebx
801045bc:	5e                   	pop    %esi
801045bd:	5f                   	pop    %edi
801045be:	5d                   	pop    %ebp
  release(&ptable.lock);
801045bf:	e9 2c 04 00 00       	jmp    801049f0 <release>
801045c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c8:	89 fa                	mov    %edi,%edx
801045ca:	89 f9                	mov    %edi,%ecx
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801045cc:	bf 43 00 00 00       	mov    $0x43,%edi
801045d1:	31 c0                	xor    %eax,%eax
801045d3:	88 55 e3             	mov    %dl,-0x1d(%ebp)
801045d6:	89 fa                	mov    %edi,%edx
801045d8:	89 cf                	mov    %ecx,%edi
801045da:	eb 0f                	jmp    801045eb <signalProcess+0xcb>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e0:	0f b6 90 05 81 10 80 	movzbl -0x7fef7efb(%eax),%edx
801045e7:	84 d2                	test   %dl,%dl
801045e9:	74 0f                	je     801045fa <signalProcess+0xda>
       if(a[i]!=b[i])  
801045eb:	38 ca                	cmp    %cl,%dl
801045ed:	75 29                	jne    80104618 <signalProcess+0xf8>
       i++;  
801045ef:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
801045f2:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801045f6:	84 c9                	test   %cl,%cl
801045f8:	75 e6                	jne    801045e0 <signalProcess+0xc0>
        cprintf("continue");
801045fa:	83 ec 0c             	sub    $0xc,%esp
801045fd:	68 13 81 10 80       	push   $0x80108113
80104602:	e8 e9 c0 ff ff       	call   801006f0 <cprintf>
        p->PAUSE=0;
80104607:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
        break;
8010460e:	83 c4 10             	add    $0x10,%esp
80104611:	eb 9e                	jmp    801045b1 <signalProcess+0x91>
80104613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104617:	90                   	nop
80104618:	89 fa                	mov    %edi,%edx
8010461a:	31 c0                	xor    %eax,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
8010461c:	b9 4b 00 00 00       	mov    $0x4b,%ecx
80104621:	eb 10                	jmp    80104633 <signalProcess+0x113>
80104623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104627:	90                   	nop
80104628:	0f b6 88 0e 81 10 80 	movzbl -0x7fef7ef2(%eax),%ecx
8010462f:	84 c9                	test   %cl,%cl
80104631:	74 13                	je     80104646 <signalProcess+0x126>
       if(a[i]!=b[i])  
80104633:	38 d1                	cmp    %dl,%cl
80104635:	0f 85 15 ff ff ff    	jne    80104550 <signalProcess+0x30>
       i++;  
8010463b:	83 c0 01             	add    $0x1,%eax
    while(a[i]!='\0' &&b[i]!='\0')  // while loop  
8010463e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80104642:	84 d2                	test   %dl,%dl
80104644:	75 e2                	jne    80104628 <signalProcess+0x108>
        p->state=ZOMBIE;
80104646:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
        break;
8010464d:	e9 5f ff ff ff       	jmp    801045b1 <signalProcess+0x91>
80104652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <numvp>:

int numvp(){
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104667:	e8 94 02 00 00       	call   80104900 <pushcli>
  c = mycpu();
8010466c:	e8 ef f3 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80104671:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104677:	e8 d4 02 00 00       	call   80104950 <popcli>
  int x = myproc()->sz/PGSIZE;
8010467c:	8b 03                	mov    (%ebx),%eax
  // return retNumvp();
  return x;
}
8010467e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104681:	c9                   	leave  
  int x = myproc()->sz/PGSIZE;
80104682:	c1 e8 0c             	shr    $0xc,%eax
}
80104685:	c3                   	ret    
80104686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <numpp>:

int numpp(){
  return retNumpp();
80104690:	e9 8b 33 00 00       	jmp    80107a20 <retNumpp>
80104695:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <init_mylock>:
}

int init_mylock(){
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	83 ec 14             	sub    $0x14,%esp
  return init_mylockLC(&ptable.lock);
801046a6:	68 a0 48 11 80       	push   $0x801148a0
801046ab:	e8 60 04 00 00       	call   80104b10 <init_mylockLC>
  // return 0;
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <acquire_mylock>:

int acquire_mylock(int id){
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801046c6:	8d 45 08             	lea    0x8(%ebp),%eax
801046c9:	50                   	push   %eax
801046ca:	6a 00                	push   $0x0
801046cc:	e8 af 08 00 00       	call   80104f80 <argint>
  // return id;
  return acquire_mylockLC(&ptable.lock, id);
801046d1:	58                   	pop    %eax
801046d2:	5a                   	pop    %edx
801046d3:	ff 75 08             	push   0x8(%ebp)
801046d6:	68 a0 48 11 80       	push   $0x801148a0
801046db:	e8 60 04 00 00       	call   80104b40 <acquire_mylockLC>
  // acquire(&ptable.lock);
return 0;
}
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <release_mylock>:

int release_mylock(int id){
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801046f6:	8d 45 08             	lea    0x8(%ebp),%eax
801046f9:	50                   	push   %eax
801046fa:	6a 00                	push   $0x0
801046fc:	e8 7f 08 00 00       	call   80104f80 <argint>
  return release_mylockLC(&ptable.lock, id);
80104701:	58                   	pop    %eax
80104702:	5a                   	pop    %edx
80104703:	ff 75 08             	push   0x8(%ebp)
80104706:	68 a0 48 11 80       	push   $0x801148a0
8010470b:	e8 20 05 00 00       	call   80104c30 <release_mylockLC>
}
80104710:	c9                   	leave  
80104711:	c3                   	ret    
80104712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104720 <holding_mylock>:

int holding_mylock(int id){
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80104726:	8d 45 08             	lea    0x8(%ebp),%eax
80104729:	50                   	push   %eax
8010472a:	6a 00                	push   $0x0
8010472c:	e8 4f 08 00 00       	call   80104f80 <argint>
  return holding_mylockLC(&ptable.lock, id);
80104731:	58                   	pop    %eax
80104732:	5a                   	pop    %edx
80104733:	ff 75 08             	push   0x8(%ebp)
80104736:	68 a0 48 11 80       	push   $0x801148a0
8010473b:	e8 50 05 00 00       	call   80104c90 <holding_mylockLC>
80104740:	c9                   	leave  
80104741:	c3                   	ret    
80104742:	66 90                	xchg   %ax,%ax
80104744:	66 90                	xchg   %ax,%ax
80104746:	66 90                	xchg   %ax,%ax
80104748:	66 90                	xchg   %ax,%ax
8010474a:	66 90                	xchg   %ax,%ax
8010474c:	66 90                	xchg   %ax,%ax
8010474e:	66 90                	xchg   %ax,%ax

80104750 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010475a:	68 8c 81 10 80       	push   $0x8010818c
8010475f:	8d 43 04             	lea    0x4(%ebx),%eax
80104762:	50                   	push   %eax
80104763:	e8 18 01 00 00       	call   80104880 <initlock>
  lk->name = name;
80104768:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010476b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104771:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104774:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010477b:	00 00 00 
  lk->name = name;
8010477e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
}
80104784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104787:	c9                   	leave  
80104788:	c3                   	ret    
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104798:	8d 73 04             	lea    0x4(%ebx),%esi
8010479b:	83 ec 0c             	sub    $0xc,%esp
8010479e:	56                   	push   %esi
8010479f:	e8 ac 02 00 00       	call   80104a50 <acquire>
  while (lk->locked) {
801047a4:	8b 13                	mov    (%ebx),%edx
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	85 d2                	test   %edx,%edx
801047ab:	74 16                	je     801047c3 <acquiresleep+0x33>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047b0:	83 ec 08             	sub    $0x8,%esp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	e8 d6 f9 ff ff       	call   80104190 <sleep>
  while (lk->locked) {
801047ba:	8b 03                	mov    (%ebx),%eax
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	85 c0                	test   %eax,%eax
801047c1:	75 ed                	jne    801047b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047c9:	e8 12 f3 ff ff       	call   80103ae0 <myproc>
801047ce:	8b 40 10             	mov    0x10(%eax),%eax
801047d1:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  release(&lk->lk);
801047d7:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047dd:	5b                   	pop    %ebx
801047de:	5e                   	pop    %esi
801047df:	5d                   	pop    %ebp
  release(&lk->lk);
801047e0:	e9 0b 02 00 00       	jmp    801049f0 <release>
801047e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047f8:	8d 73 04             	lea    0x4(%ebx),%esi
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	56                   	push   %esi
801047ff:	e8 4c 02 00 00       	call   80104a50 <acquire>
  lk->locked = 0;
80104804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010480a:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104811:	00 00 00 
  wakeup(lk);
80104814:	89 1c 24             	mov    %ebx,(%esp)
80104817:	e8 34 fa ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
8010481c:	89 75 08             	mov    %esi,0x8(%ebp)
8010481f:	83 c4 10             	add    $0x10,%esp
}
80104822:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104825:	5b                   	pop    %ebx
80104826:	5e                   	pop    %esi
80104827:	5d                   	pop    %ebp
  release(&lk->lk);
80104828:	e9 c3 01 00 00       	jmp    801049f0 <release>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	31 ff                	xor    %edi,%edi
80104836:	56                   	push   %esi
80104837:	53                   	push   %ebx
80104838:	83 ec 18             	sub    $0x18,%esp
8010483b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010483e:	8d 73 04             	lea    0x4(%ebx),%esi
80104841:	56                   	push   %esi
80104842:	e8 09 02 00 00       	call   80104a50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104847:	8b 03                	mov    (%ebx),%eax
80104849:	83 c4 10             	add    $0x10,%esp
8010484c:	85 c0                	test   %eax,%eax
8010484e:	75 18                	jne    80104868 <holdingsleep+0x38>
  release(&lk->lk);
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	56                   	push   %esi
80104854:	e8 97 01 00 00       	call   801049f0 <release>
  return r;
}
80104859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485c:	89 f8                	mov    %edi,%eax
8010485e:	5b                   	pop    %ebx
8010485f:	5e                   	pop    %esi
80104860:	5f                   	pop    %edi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104867:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104868:	8b 9b 8c 00 00 00    	mov    0x8c(%ebx),%ebx
8010486e:	e8 6d f2 ff ff       	call   80103ae0 <myproc>
80104873:	39 58 10             	cmp    %ebx,0x10(%eax)
80104876:	0f 94 c0             	sete   %al
80104879:	0f b6 c0             	movzbl %al,%eax
8010487c:	89 c7                	mov    %eax,%edi
8010487e:	eb d0                	jmp    80104850 <holdingsleep+0x20>

80104880 <initlock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104886:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010488f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104892:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <getcallerpcs>:
  popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[])
{
801048a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint *)v - 2;
  for (i = 0; i < 10; i++)
801048a1:	31 d2                	xor    %edx,%edx
{
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	53                   	push   %ebx
  ebp = (uint *)v - 2;
801048a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801048a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint *)v - 2;
801048ac:	83 e8 08             	sub    $0x8,%eax
  for (i = 0; i < 10; i++)
801048af:	90                   	nop
  {
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
801048b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801048b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048bc:	77 1a                	ja     801048d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];      // saved %eip
801048be:	8b 58 04             	mov    0x4(%eax),%ebx
801048c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for (i = 0; i < 10; i++)
801048c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint *)ebp[0]; // saved %ebp
801048c7:	8b 00                	mov    (%eax),%eax
  for (i = 0; i < 10; i++)
801048c9:	83 fa 0a             	cmp    $0xa,%edx
801048cc:	75 e2                	jne    801048b0 <getcallerpcs+0x10>
  }
  for (; i < 10; i++)
    pcs[i] = 0;
}
801048ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d1:	c9                   	leave  
801048d2:	c3                   	ret    
801048d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048d7:	90                   	nop
  for (; i < 10; i++)
801048d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801048db:	8d 51 28             	lea    0x28(%ecx),%edx
801048de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; i < 10; i++)
801048e6:	83 c0 04             	add    $0x4,%eax
801048e9:	39 d0                	cmp    %edx,%eax
801048eb:	75 f3                	jne    801048e0 <getcallerpcs+0x40>
}
801048ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f0:	c9                   	leave  
801048f1:	c3                   	ret    
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104900 <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	9c                   	pushf  
80104908:	5b                   	pop    %ebx
  asm volatile("cli");
80104909:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if (mycpu()->ncli == 0)
8010490a:	e8 51 f1 ff ff       	call   80103a60 <mycpu>
8010490f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104915:	85 c0                	test   %eax,%eax
80104917:	74 17                	je     80104930 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104919:	e8 42 f1 ff ff       	call   80103a60 <mycpu>
8010491e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104928:	c9                   	leave  
80104929:	c3                   	ret    
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104930:	e8 2b f1 ff ff       	call   80103a60 <mycpu>
80104935:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010493b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104941:	eb d6                	jmp    80104919 <pushcli+0x19>
80104943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <popcli>:

void popcli(void)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104956:	9c                   	pushf  
80104957:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104958:	f6 c4 02             	test   $0x2,%ah
8010495b:	75 35                	jne    80104992 <popcli+0x42>
    panic("popcli - interruptible");
  if (--mycpu()->ncli < 0)
8010495d:	e8 fe f0 ff ff       	call   80103a60 <mycpu>
80104962:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104969:	78 34                	js     8010499f <popcli+0x4f>
    panic("popcli");
  if (mycpu()->ncli == 0 && mycpu()->intena)
8010496b:	e8 f0 f0 ff ff       	call   80103a60 <mycpu>
80104970:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104976:	85 d2                	test   %edx,%edx
80104978:	74 06                	je     80104980 <popcli+0x30>
    sti();
}
8010497a:	c9                   	leave  
8010497b:	c3                   	ret    
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (mycpu()->ncli == 0 && mycpu()->intena)
80104980:	e8 db f0 ff ff       	call   80103a60 <mycpu>
80104985:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010498b:	85 c0                	test   %eax,%eax
8010498d:	74 eb                	je     8010497a <popcli+0x2a>
  asm volatile("sti");
8010498f:	fb                   	sti    
}
80104990:	c9                   	leave  
80104991:	c3                   	ret    
    panic("popcli - interruptible");
80104992:	83 ec 0c             	sub    $0xc,%esp
80104995:	68 97 81 10 80       	push   $0x80108197
8010499a:	e8 31 ba ff ff       	call   801003d0 <panic>
    panic("popcli");
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	68 ae 81 10 80       	push   $0x801081ae
801049a7:	e8 24 ba ff ff       	call   801003d0 <panic>
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049b0 <holding>:
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 75 08             	mov    0x8(%ebp),%esi
801049b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801049ba:	e8 41 ff ff ff       	call   80104900 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049bf:	8b 06                	mov    (%esi),%eax
801049c1:	85 c0                	test   %eax,%eax
801049c3:	75 0b                	jne    801049d0 <holding+0x20>
  popcli();
801049c5:	e8 86 ff ff ff       	call   80104950 <popcli>
}
801049ca:	89 d8                	mov    %ebx,%eax
801049cc:	5b                   	pop    %ebx
801049cd:	5e                   	pop    %esi
801049ce:	5d                   	pop    %ebp
801049cf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801049d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801049d3:	e8 88 f0 ff ff       	call   80103a60 <mycpu>
801049d8:	39 c3                	cmp    %eax,%ebx
801049da:	0f 94 c3             	sete   %bl
  popcli();
801049dd:	e8 6e ff ff ff       	call   80104950 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801049e2:	0f b6 db             	movzbl %bl,%ebx
}
801049e5:	89 d8                	mov    %ebx,%eax
801049e7:	5b                   	pop    %ebx
801049e8:	5e                   	pop    %esi
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    
801049eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ef:	90                   	nop

801049f0 <release>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801049f8:	e8 03 ff ff ff       	call   80104900 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049fd:	8b 03                	mov    (%ebx),%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	75 15                	jne    80104a18 <release+0x28>
  popcli();
80104a03:	e8 48 ff ff ff       	call   80104950 <popcli>
    panic("release");
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	68 b5 81 10 80       	push   $0x801081b5
80104a10:	e8 bb b9 ff ff       	call   801003d0 <panic>
80104a15:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a18:	8b 73 08             	mov    0x8(%ebx),%esi
80104a1b:	e8 40 f0 ff ff       	call   80103a60 <mycpu>
80104a20:	39 c6                	cmp    %eax,%esi
80104a22:	75 df                	jne    80104a03 <release+0x13>
  popcli();
80104a24:	e8 27 ff ff ff       	call   80104950 <popcli>
  lk->pcs[0] = 0;
80104a29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a30:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a37:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0"
80104a3c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a45:	5b                   	pop    %ebx
80104a46:	5e                   	pop    %esi
80104a47:	5d                   	pop    %ebp
  popcli();
80104a48:	e9 03 ff ff ff       	jmp    80104950 <popcli>
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <acquire>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a57:	e8 a4 fe ff ff       	call   80104900 <pushcli>
  if (holding(lk))
80104a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a5f:	e8 9c fe ff ff       	call   80104900 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a64:	8b 03                	mov    (%ebx),%eax
80104a66:	85 c0                	test   %eax,%eax
80104a68:	75 7e                	jne    80104ae8 <acquire+0x98>
  popcli();
80104a6a:	e8 e1 fe ff ff       	call   80104950 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a6f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while (xchg(&lk->locked, 1) != 0)
80104a78:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7b:	89 c8                	mov    %ecx,%eax
80104a7d:	f0 87 02             	lock xchg %eax,(%edx)
80104a80:	85 c0                	test   %eax,%eax
80104a82:	75 f4                	jne    80104a78 <acquire+0x28>
  __sync_synchronize();
80104a84:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a8c:	e8 cf ef ff ff       	call   80103a60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint *)v - 2;
80104a94:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104a96:	89 43 08             	mov    %eax,0x8(%ebx)
  for (i = 0; i < 10; i++)
80104a99:	31 c0                	xor    %eax,%eax
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
80104aa0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104aa6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aac:	77 1a                	ja     80104ac8 <acquire+0x78>
    pcs[i] = ebp[1];      // saved %eip
80104aae:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ab1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for (i = 0; i < 10; i++)
80104ab5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint *)ebp[0]; // saved %ebp
80104ab8:	8b 12                	mov    (%edx),%edx
  for (i = 0; i < 10; i++)
80104aba:	83 f8 0a             	cmp    $0xa,%eax
80104abd:	75 e1                	jne    80104aa0 <acquire+0x50>
}
80104abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (; i < 10; i++)
80104ac8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104acc:	8d 51 34             	lea    0x34(%ecx),%edx
80104acf:	90                   	nop
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; i < 10; i++)
80104ad6:	83 c0 04             	add    $0x4,%eax
80104ad9:	39 c2                	cmp    %eax,%edx
80104adb:	75 f3                	jne    80104ad0 <acquire+0x80>
}
80104add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae0:	c9                   	leave  
80104ae1:	c3                   	ret    
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ae8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104aeb:	e8 70 ef ff ff       	call   80103a60 <mycpu>
80104af0:	39 c3                	cmp    %eax,%ebx
80104af2:	0f 85 72 ff ff ff    	jne    80104a6a <acquire+0x1a>
  popcli();
80104af8:	e8 53 fe ff ff       	call   80104950 <popcli>
    panic("acquire");
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	68 bd 81 10 80       	push   $0x801081bd
80104b05:	e8 c6 b8 ff ff       	call   801003d0 <panic>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <init_mylockLC>:

int init_mylockLC(struct spinlock *lk)
{
80104b10:	55                   	push   %ebp
  int counter = 0;
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
  while (lk->exists[counter] == 1 && counter <= 10)
80104b18:	83 7a 34 01          	cmpl   $0x1,0x34(%edx)
80104b1c:	75 0c                	jne    80104b2a <init_mylockLC+0x1a>
80104b1e:	66 90                	xchg   %ax,%ax
  {
    // cprintf("%d\n",lk->exists[0]);
    counter++;
80104b20:	83 c0 01             	add    $0x1,%eax
  while (lk->exists[counter] == 1 && counter <= 10)
80104b23:	83 7c 82 34 01       	cmpl   $0x1,0x34(%edx,%eax,4)
80104b28:	74 f6                	je     80104b20 <init_mylockLC+0x10>
  {
    return -1;
  }
  else
  {
    lk->exists[counter] = 1;
80104b2a:	c7 44 82 34 01 00 00 	movl   $0x1,0x34(%edx,%eax,4)
80104b31:	00 
    return counter;
  }
}
80104b32:	5d                   	pop    %ebp
80104b33:	c3                   	ret    
80104b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop

80104b40 <acquire_mylockLC>:

int acquire_mylockLC(struct spinlock *lk, int id)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 14             	sub    $0x14,%esp
80104b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("%d\n", lk->locked);
80104b4c:	ff 33                	push   (%ebx)
80104b4e:	68 f4 7f 10 80       	push   $0x80107ff4
80104b53:	e8 98 bb ff ff       	call   801006f0 <cprintf>
  cprintf("%d\n", lk->status[id]);
80104b58:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5b:	8d 34 83             	lea    (%ebx,%eax,4),%esi
80104b5e:	58                   	pop    %eax
80104b5f:	5a                   	pop    %edx
80104b60:	ff 76 5c             	push   0x5c(%esi)
80104b63:	68 f4 7f 10 80       	push   $0x80107ff4
80104b68:	e8 83 bb ff ff       	call   801006f0 <cprintf>

  if (lk->exists[id] == 1)
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	83 7e 34 01          	cmpl   $0x1,0x34(%esi)
80104b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b79:	74 0d                	je     80104b88 <acquire_mylockLC+0x48>
  {
    return -1;
  }

  return 0;
}
80104b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7e:	5b                   	pop    %ebx
80104b7f:	5e                   	pop    %esi
80104b80:	5f                   	pop    %edi
80104b81:	5d                   	pop    %ebp
80104b82:	c3                   	ret    
80104b83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b87:	90                   	nop
    pushcli();
80104b88:	e8 73 fd ff ff       	call   80104900 <pushcli>

int holding_mylockLC(struct spinlock *lk, int id)
{
  // return id;
  int r;
  pushcli();
80104b8d:	e8 6e fd ff ff       	call   80104900 <pushcli>
  r = lk->status[id] && lk->locked;
80104b92:	8b 7e 5c             	mov    0x5c(%esi),%edi
80104b95:	85 ff                	test   %edi,%edi
80104b97:	75 77                	jne    80104c10 <acquire_mylockLC+0xd0>
  popcli();
80104b99:	e8 b2 fd ff ff       	call   80104950 <popcli>
    lk->status[id] = 1;
80104b9e:	c7 46 5c 01 00 00 00 	movl   $0x1,0x5c(%esi)
80104ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80104baa:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0)
80104bad:	85 c0                	test   %eax,%eax
80104baf:	74 28                	je     80104bd9 <acquire_mylockLC+0x99>
80104bb1:	bf 01 00 00 00       	mov    $0x1,%edi
80104bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("inside while 1\n");
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	68 cd 81 10 80       	push   $0x801081cd
80104bc8:	e8 23 bb ff ff       	call   801006f0 <cprintf>
80104bcd:	89 f8                	mov    %edi,%eax
80104bcf:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0)
80104bd2:	83 c4 10             	add    $0x10,%esp
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	75 e7                	jne    80104bc0 <acquire_mylockLC+0x80>
    __sync_synchronize();
80104bd9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    cprintf("lock %d\n", lk->locked);
80104bde:	83 ec 08             	sub    $0x8,%esp
80104be1:	ff 33                	push   (%ebx)
80104be3:	68 dd 81 10 80       	push   $0x801081dd
80104be8:	e8 03 bb ff ff       	call   801006f0 <cprintf>
    cprintf("status %d\n", lk->status[id]);
80104bed:	58                   	pop    %eax
80104bee:	5a                   	pop    %edx
80104bef:	ff 76 5c             	push   0x5c(%esi)
80104bf2:	68 e6 81 10 80       	push   $0x801081e6
80104bf7:	e8 f4 ba ff ff       	call   801006f0 <cprintf>
    return 1;
80104bfc:	83 c4 10             	add    $0x10,%esp
}
80104bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 1;
80104c02:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104c07:	5b                   	pop    %ebx
80104c08:	5e                   	pop    %esi
80104c09:	5f                   	pop    %edi
80104c0a:	5d                   	pop    %ebp
80104c0b:	c3                   	ret    
80104c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lk->status[id] && lk->locked;
80104c10:	8b 0b                	mov    (%ebx),%ecx
80104c12:	85 c9                	test   %ecx,%ecx
80104c14:	74 83                	je     80104b99 <acquire_mylockLC+0x59>
  popcli();
80104c16:	e8 35 fd ff ff       	call   80104950 <popcli>
      panic("lcLocks");
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	68 c5 81 10 80       	push   $0x801081c5
80104c23:	e8 a8 b7 ff ff       	call   801003d0 <panic>
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <release_mylockLC>:
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 10             	sub    $0x10,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("relFnc\n");
80104c3a:	68 f1 81 10 80       	push   $0x801081f1
80104c3f:	e8 ac ba ff ff       	call   801006f0 <cprintf>
  if (lk->status[id] == 1)
80104c44:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c47:	83 c4 10             	add    $0x10,%esp
80104c4a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104c4f:	8d 04 83             	lea    (%ebx,%eax,4),%eax
80104c52:	83 78 5c 01          	cmpl   $0x1,0x5c(%eax)
80104c56:	74 08                	je     80104c60 <release_mylockLC+0x30>
}
80104c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5b:	89 d0                	mov    %edx,%eax
80104c5d:	c9                   	leave  
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop
    lk->status[id] = 0;
80104c60:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
    __sync_synchronize();
80104c67:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->status[id] = 0;
80104c6c:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
    asm volatile("movl $0, %0"
80104c73:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    return 1;
80104c79:	ba 01 00 00 00       	mov    $0x1,%edx
}
80104c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c81:	c9                   	leave  
80104c82:	89 d0                	mov    %edx,%eax
80104c84:	c3                   	ret    
80104c85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <holding_mylockLC>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 75 08             	mov    0x8(%ebp),%esi
80104c98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c9a:	e8 61 fc ff ff       	call   80104900 <pushcli>
  r = lk->status[id] && lk->locked;
80104c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ca2:	8b 54 86 5c          	mov    0x5c(%esi,%eax,4),%edx
80104ca6:	85 d2                	test   %edx,%edx
80104ca8:	74 09                	je     80104cb3 <holding_mylockLC+0x23>
80104caa:	8b 06                	mov    (%esi),%eax
80104cac:	31 db                	xor    %ebx,%ebx
80104cae:	85 c0                	test   %eax,%eax
80104cb0:	0f 95 c3             	setne  %bl
  popcli();
80104cb3:	e8 98 fc ff ff       	call   80104950 <popcli>
  return r;
80104cb8:	89 d8                	mov    %ebx,%eax
80104cba:	5b                   	pop    %ebx
80104cbb:	5e                   	pop    %esi
80104cbc:	5d                   	pop    %ebp
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cca:	53                   	push   %ebx
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cce:	89 d7                	mov    %edx,%edi
80104cd0:	09 cf                	or     %ecx,%edi
80104cd2:	83 e7 03             	and    $0x3,%edi
80104cd5:	75 29                	jne    80104d00 <memset+0x40>
    c &= 0xFF;
80104cd7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cda:	c1 e0 18             	shl    $0x18,%eax
80104cdd:	89 fb                	mov    %edi,%ebx
80104cdf:	c1 e9 02             	shr    $0x2,%ecx
80104ce2:	c1 e3 10             	shl    $0x10,%ebx
80104ce5:	09 d8                	or     %ebx,%eax
80104ce7:	09 f8                	or     %edi,%eax
80104ce9:	c1 e7 08             	shl    $0x8,%edi
80104cec:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cee:	89 d7                	mov    %edx,%edi
80104cf0:	fc                   	cld    
80104cf1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104cf3:	5b                   	pop    %ebx
80104cf4:	89 d0                	mov    %edx,%eax
80104cf6:	5f                   	pop    %edi
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d00:	89 d7                	mov    %edx,%edi
80104d02:	fc                   	cld    
80104d03:	f3 aa                	rep stos %al,%es:(%edi)
80104d05:	5b                   	pop    %ebx
80104d06:	89 d0                	mov    %edx,%eax
80104d08:	5f                   	pop    %edi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	8b 75 10             	mov    0x10(%ebp),%esi
80104d17:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1a:	53                   	push   %ebx
80104d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1e:	85 f6                	test   %esi,%esi
80104d20:	74 2e                	je     80104d50 <memcmp+0x40>
80104d22:	01 c6                	add    %eax,%esi
80104d24:	eb 14                	jmp    80104d3a <memcmp+0x2a>
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d36:	39 f0                	cmp    %esi,%eax
80104d38:	74 16                	je     80104d50 <memcmp+0x40>
    if(*s1 != *s2)
80104d3a:	0f b6 0a             	movzbl (%edx),%ecx
80104d3d:	0f b6 18             	movzbl (%eax),%ebx
80104d40:	38 d9                	cmp    %bl,%cl
80104d42:	74 ec                	je     80104d30 <memcmp+0x20>
      return *s1 - *s2;
80104d44:	0f b6 c1             	movzbl %cl,%eax
80104d47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	5b                   	pop    %ebx
  return 0;
80104d51:	31 c0                	xor    %eax,%eax
}
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	8b 55 08             	mov    0x8(%ebp),%edx
80104d67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d6a:	56                   	push   %esi
80104d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d6e:	39 d6                	cmp    %edx,%esi
80104d70:	73 26                	jae    80104d98 <memmove+0x38>
80104d72:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d75:	39 fa                	cmp    %edi,%edx
80104d77:	73 1f                	jae    80104d98 <memmove+0x38>
80104d79:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d7c:	85 c9                	test   %ecx,%ecx
80104d7e:	74 0c                	je     80104d8c <memmove+0x2c>
      *--d = *--s;
80104d80:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d84:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d87:	83 e8 01             	sub    $0x1,%eax
80104d8a:	73 f4                	jae    80104d80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d8c:	5e                   	pop    %esi
80104d8d:	89 d0                	mov    %edx,%eax
80104d8f:	5f                   	pop    %edi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104d98:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104d9b:	89 d7                	mov    %edx,%edi
80104d9d:	85 c9                	test   %ecx,%ecx
80104d9f:	74 eb                	je     80104d8c <memmove+0x2c>
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104da8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104da9:	39 c6                	cmp    %eax,%esi
80104dab:	75 fb                	jne    80104da8 <memmove+0x48>
}
80104dad:	5e                   	pop    %esi
80104dae:	89 d0                	mov    %edx,%eax
80104db0:	5f                   	pop    %edi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104dc0:	eb 9e                	jmp    80104d60 <memmove>
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	8b 75 10             	mov    0x10(%ebp),%esi
80104dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dda:	53                   	push   %ebx
80104ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104dde:	85 f6                	test   %esi,%esi
80104de0:	74 2e                	je     80104e10 <strncmp+0x40>
80104de2:	01 d6                	add    %edx,%esi
80104de4:	eb 18                	jmp    80104dfe <strncmp+0x2e>
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
80104df0:	38 d8                	cmp    %bl,%al
80104df2:	75 14                	jne    80104e08 <strncmp+0x38>
    n--, p++, q++;
80104df4:	83 c2 01             	add    $0x1,%edx
80104df7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dfa:	39 f2                	cmp    %esi,%edx
80104dfc:	74 12                	je     80104e10 <strncmp+0x40>
80104dfe:	0f b6 01             	movzbl (%ecx),%eax
80104e01:	0f b6 1a             	movzbl (%edx),%ebx
80104e04:	84 c0                	test   %al,%al
80104e06:	75 e8                	jne    80104df0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e08:	29 d8                	sub    %ebx,%eax
}
80104e0a:	5b                   	pop    %ebx
80104e0b:	5e                   	pop    %esi
80104e0c:	5d                   	pop    %ebp
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	5b                   	pop    %ebx
    return 0;
80104e11:	31 c0                	xor    %eax,%eax
}
80104e13:	5e                   	pop    %esi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	8b 75 08             	mov    0x8(%ebp),%esi
80104e28:	53                   	push   %ebx
80104e29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e2c:	89 f0                	mov    %esi,%eax
80104e2e:	eb 15                	jmp    80104e45 <strncpy+0x25>
80104e30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e34:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e37:	83 c0 01             	add    $0x1,%eax
80104e3a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e3e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e41:	84 d2                	test   %dl,%dl
80104e43:	74 09                	je     80104e4e <strncpy+0x2e>
80104e45:	89 cb                	mov    %ecx,%ebx
80104e47:	83 e9 01             	sub    $0x1,%ecx
80104e4a:	85 db                	test   %ebx,%ebx
80104e4c:	7f e2                	jg     80104e30 <strncpy+0x10>
    ;
  while(n-- > 0)
80104e4e:	89 c2                	mov    %eax,%edx
80104e50:	85 c9                	test   %ecx,%ecx
80104e52:	7e 17                	jle    80104e6b <strncpy+0x4b>
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e58:	83 c2 01             	add    $0x1,%edx
80104e5b:	89 c1                	mov    %eax,%ecx
80104e5d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104e61:	29 d1                	sub    %edx,%ecx
80104e63:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104e67:	85 c9                	test   %ecx,%ecx
80104e69:	7f ed                	jg     80104e58 <strncpy+0x38>
  return os;
}
80104e6b:	5b                   	pop    %ebx
80104e6c:	89 f0                	mov    %esi,%eax
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret    
80104e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	8b 55 10             	mov    0x10(%ebp),%edx
80104e87:	8b 75 08             	mov    0x8(%ebp),%esi
80104e8a:	53                   	push   %ebx
80104e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e8e:	85 d2                	test   %edx,%edx
80104e90:	7e 25                	jle    80104eb7 <safestrcpy+0x37>
80104e92:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e96:	89 f2                	mov    %esi,%edx
80104e98:	eb 16                	jmp    80104eb0 <safestrcpy+0x30>
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ea0:	0f b6 08             	movzbl (%eax),%ecx
80104ea3:	83 c0 01             	add    $0x1,%eax
80104ea6:	83 c2 01             	add    $0x1,%edx
80104ea9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104eac:	84 c9                	test   %cl,%cl
80104eae:	74 04                	je     80104eb4 <safestrcpy+0x34>
80104eb0:	39 d8                	cmp    %ebx,%eax
80104eb2:	75 ec                	jne    80104ea0 <safestrcpy+0x20>
    ;
  *s = 0;
80104eb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104eb7:	89 f0                	mov    %esi,%eax
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <strlen>:

int
strlen(const char *s)
{
80104ec0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ec8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ecb:	74 0c                	je     80104ed9 <strlen+0x19>
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c0 01             	add    $0x1,%eax
80104ed3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ed7:	75 f7                	jne    80104ed0 <strlen+0x10>
    ;
  return n;
}
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    

80104edb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104edb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104edf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ee3:	55                   	push   %ebp
  pushl %ebx
80104ee4:	53                   	push   %ebx
  pushl %esi
80104ee5:	56                   	push   %esi
  pushl %edi
80104ee6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ee7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ee9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104eeb:	5f                   	pop    %edi
  popl %esi
80104eec:	5e                   	pop    %esi
  popl %ebx
80104eed:	5b                   	pop    %ebx
  popl %ebp
80104eee:	5d                   	pop    %ebp
  ret
80104eef:	c3                   	ret    

80104ef0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104efa:	e8 e1 eb ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eff:	8b 00                	mov    (%eax),%eax
80104f01:	39 d8                	cmp    %ebx,%eax
80104f03:	76 1b                	jbe    80104f20 <fetchint+0x30>
80104f05:	8d 53 04             	lea    0x4(%ebx),%edx
80104f08:	39 d0                	cmp    %edx,%eax
80104f0a:	72 14                	jb     80104f20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f0f:	8b 13                	mov    (%ebx),%edx
80104f11:	89 10                	mov    %edx,(%eax)
  return 0;
80104f13:	31 c0                	xor    %eax,%eax
}
80104f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f18:	c9                   	leave  
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f25:	eb ee                	jmp    80104f15 <fetchint+0x25>
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f3a:	e8 a1 eb ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz)
80104f3f:	39 18                	cmp    %ebx,(%eax)
80104f41:	76 2d                	jbe    80104f70 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104f43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f48:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f4a:	39 d3                	cmp    %edx,%ebx
80104f4c:	73 22                	jae    80104f70 <fetchstr+0x40>
80104f4e:	89 d8                	mov    %ebx,%eax
80104f50:	eb 0d                	jmp    80104f5f <fetchstr+0x2f>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f58:	83 c0 01             	add    $0x1,%eax
80104f5b:	39 c2                	cmp    %eax,%edx
80104f5d:	76 11                	jbe    80104f70 <fetchstr+0x40>
    if(*s == 0)
80104f5f:	80 38 00             	cmpb   $0x0,(%eax)
80104f62:	75 f4                	jne    80104f58 <fetchstr+0x28>
      return s - *pp;
80104f64:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
80104f70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f78:	c9                   	leave  
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f85:	e8 56 eb ff ff       	call   80103ae0 <myproc>
80104f8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f8d:	8b 40 18             	mov    0x18(%eax),%eax
80104f90:	8b 40 44             	mov    0x44(%eax),%eax
80104f93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f96:	e8 45 eb ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f9e:	8b 00                	mov    (%eax),%eax
80104fa0:	39 c6                	cmp    %eax,%esi
80104fa2:	73 1c                	jae    80104fc0 <argint+0x40>
80104fa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fa7:	39 d0                	cmp    %edx,%eax
80104fa9:	72 15                	jb     80104fc0 <argint+0x40>
  *ip = *(int*)(addr);
80104fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fae:	8b 53 04             	mov    0x4(%ebx),%edx
80104fb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fb3:	31 c0                	xor    %eax,%eax
}
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fc5:	eb ee                	jmp    80104fb5 <argint+0x35>
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
80104fd5:	53                   	push   %ebx
80104fd6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104fd9:	e8 02 eb ff ff       	call   80103ae0 <myproc>
80104fde:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fe0:	e8 fb ea ff ff       	call   80103ae0 <myproc>
80104fe5:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe8:	8b 40 18             	mov    0x18(%eax),%eax
80104feb:	8b 40 44             	mov    0x44(%eax),%eax
80104fee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ff1:	e8 ea ea ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ff6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ff9:	8b 00                	mov    (%eax),%eax
80104ffb:	39 c7                	cmp    %eax,%edi
80104ffd:	73 31                	jae    80105030 <argptr+0x60>
80104fff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105002:	39 c8                	cmp    %ecx,%eax
80105004:	72 2a                	jb     80105030 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105006:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105009:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010500c:	85 d2                	test   %edx,%edx
8010500e:	78 20                	js     80105030 <argptr+0x60>
80105010:	8b 16                	mov    (%esi),%edx
80105012:	39 c2                	cmp    %eax,%edx
80105014:	76 1a                	jbe    80105030 <argptr+0x60>
80105016:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105019:	01 c3                	add    %eax,%ebx
8010501b:	39 da                	cmp    %ebx,%edx
8010501d:	72 11                	jb     80105030 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010501f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105022:	89 02                	mov    %eax,(%edx)
  return 0;
80105024:	31 c0                	xor    %eax,%eax
}
80105026:	83 c4 0c             	add    $0xc,%esp
80105029:	5b                   	pop    %ebx
8010502a:	5e                   	pop    %esi
8010502b:	5f                   	pop    %edi
8010502c:	5d                   	pop    %ebp
8010502d:	c3                   	ret    
8010502e:	66 90                	xchg   %ax,%ax
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb ef                	jmp    80105026 <argptr+0x56>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105045:	e8 96 ea ff ff       	call   80103ae0 <myproc>
8010504a:	8b 55 08             	mov    0x8(%ebp),%edx
8010504d:	8b 40 18             	mov    0x18(%eax),%eax
80105050:	8b 40 44             	mov    0x44(%eax),%eax
80105053:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105056:	e8 85 ea ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010505b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010505e:	8b 00                	mov    (%eax),%eax
80105060:	39 c6                	cmp    %eax,%esi
80105062:	73 44                	jae    801050a8 <argstr+0x68>
80105064:	8d 53 08             	lea    0x8(%ebx),%edx
80105067:	39 d0                	cmp    %edx,%eax
80105069:	72 3d                	jb     801050a8 <argstr+0x68>
  *ip = *(int*)(addr);
8010506b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010506e:	e8 6d ea ff ff       	call   80103ae0 <myproc>
  if(addr >= curproc->sz)
80105073:	3b 18                	cmp    (%eax),%ebx
80105075:	73 31                	jae    801050a8 <argstr+0x68>
  *pp = (char*)addr;
80105077:	8b 55 0c             	mov    0xc(%ebp),%edx
8010507a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010507c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010507e:	39 d3                	cmp    %edx,%ebx
80105080:	73 26                	jae    801050a8 <argstr+0x68>
80105082:	89 d8                	mov    %ebx,%eax
80105084:	eb 11                	jmp    80105097 <argstr+0x57>
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
80105090:	83 c0 01             	add    $0x1,%eax
80105093:	39 c2                	cmp    %eax,%edx
80105095:	76 11                	jbe    801050a8 <argstr+0x68>
    if(*s == 0)
80105097:	80 38 00             	cmpb   $0x0,(%eax)
8010509a:	75 f4                	jne    80105090 <argstr+0x50>
      return s - *pp;
8010509c:	29 d8                	sub    %ebx,%eax
             */
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010509e:	5b                   	pop    %ebx
8010509f:	5e                   	pop    %esi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a8:	5b                   	pop    %ebx
    return -1;
801050a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ae:	5e                   	pop    %esi
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop

801050c0 <syscall>:
[SYS_holding_mylock]    sys_holding_mylock,
};

void
syscall(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050c7:	e8 14 ea ff ff       	call   80103ae0 <myproc>
801050cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050ce:	8b 40 18             	mov    0x18(%eax),%eax
801050d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050d7:	83 fa 28             	cmp    $0x28,%edx
801050da:	77 24                	ja     80105100 <syscall+0x40>
801050dc:	8b 14 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%edx
801050e3:	85 d2                	test   %edx,%edx
801050e5:	74 19                	je     80105100 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801050e7:	ff d2                	call   *%edx
801050e9:	89 c2                	mov    %eax,%edx
801050eb:	8b 43 18             	mov    0x18(%ebx),%eax
801050ee:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f4:	c9                   	leave  
801050f5:	c3                   	ret    
801050f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105100:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105101:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105104:	50                   	push   %eax
80105105:	ff 73 10             	push   0x10(%ebx)
80105108:	68 f9 81 10 80       	push   $0x801081f9
8010510d:	e8 de b5 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
80105112:	8b 43 18             	mov    0x18(%ebx),%eax
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010511f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105122:	c9                   	leave  
80105123:	c3                   	ret    
80105124:	66 90                	xchg   %ax,%ax
80105126:	66 90                	xchg   %ax,%ax
80105128:	66 90                	xchg   %ax,%ax
8010512a:	66 90                	xchg   %ax,%ax
8010512c:	66 90                	xchg   %ax,%ax
8010512e:	66 90                	xchg   %ax,%ax

80105130 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80105135:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105138:	53                   	push   %ebx
80105139:	83 ec 34             	sub    $0x34,%esp
8010513c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010513f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105142:	57                   	push   %edi
80105143:	50                   	push   %eax
{
80105144:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105147:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010514a:	e8 61 d0 ff ff       	call   801021b0 <nameiparent>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 56 01 00 00    	je     801052b0 <create+0x180>
    return 0;
  ilock(dp);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	89 c3                	mov    %eax,%ebx
8010515f:	50                   	push   %eax
80105160:	e8 8b c6 ff ff       	call   801017f0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105165:	83 c4 0c             	add    $0xc,%esp
80105168:	6a 00                	push   $0x0
8010516a:	57                   	push   %edi
8010516b:	53                   	push   %ebx
8010516c:	e8 3f cc ff ff       	call   80101db0 <dirlookup>
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	89 c6                	mov    %eax,%esi
80105176:	85 c0                	test   %eax,%eax
80105178:	74 56                	je     801051d0 <create+0xa0>
  {
    iunlockput(dp);
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	53                   	push   %ebx
8010517e:	e8 2d c9 ff ff       	call   80101ab0 <iunlockput>
    ilock(ip);
80105183:	89 34 24             	mov    %esi,(%esp)
80105186:	e8 65 c6 ff ff       	call   801017f0 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010518b:	83 c4 10             	add    $0x10,%esp
8010518e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105193:	75 1b                	jne    801051b0 <create+0x80>
80105195:	66 83 be a0 00 00 00 	cmpw   $0x2,0xa0(%esi)
8010519c:	02 
8010519d:	75 11                	jne    801051b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010519f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051a2:	89 f0                	mov    %esi,%eax
801051a4:	5b                   	pop    %ebx
801051a5:	5e                   	pop    %esi
801051a6:	5f                   	pop    %edi
801051a7:	5d                   	pop    %ebp
801051a8:	c3                   	ret    
801051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	56                   	push   %esi
    return 0;
801051b4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801051b6:	e8 f5 c8 ff ff       	call   80101ab0 <iunlockput>
    return 0;
801051bb:	83 c4 10             	add    $0x10,%esp
}
801051be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c1:	89 f0                	mov    %esi,%eax
801051c3:	5b                   	pop    %ebx
801051c4:	5e                   	pop    %esi
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    
801051c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
801051d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	50                   	push   %eax
801051d8:	ff 33                	push   (%ebx)
801051da:	e8 91 c4 ff ff       	call   80101670 <ialloc>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	89 c6                	mov    %eax,%esi
801051e4:	85 c0                	test   %eax,%eax
801051e6:	0f 84 dd 00 00 00    	je     801052c9 <create+0x199>
  ilock(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	50                   	push   %eax
801051f0:	e8 fb c5 ff ff       	call   801017f0 <ilock>
  ip->major = major;
801051f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051f9:	66 89 86 a2 00 00 00 	mov    %ax,0xa2(%esi)
  ip->minor = minor;
80105200:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105204:	66 89 86 a4 00 00 00 	mov    %ax,0xa4(%esi)
  ip->nlink = 1;
8010520b:	b8 01 00 00 00       	mov    $0x1,%eax
80105210:	66 89 86 a6 00 00 00 	mov    %ax,0xa6(%esi)
  iupdate(ip);
80105217:	89 34 24             	mov    %esi,(%esp)
8010521a:	e8 11 c5 ff ff       	call   80101730 <iupdate>
  if (type == T_DIR)
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105227:	74 2f                	je     80105258 <create+0x128>
  if (dirlink(dp, name, ip->inum) < 0)
80105229:	83 ec 04             	sub    $0x4,%esp
8010522c:	ff 76 04             	push   0x4(%esi)
8010522f:	57                   	push   %edi
80105230:	53                   	push   %ebx
80105231:	e8 9a ce ff ff       	call   801020d0 <dirlink>
80105236:	83 c4 10             	add    $0x10,%esp
80105239:	85 c0                	test   %eax,%eax
8010523b:	78 7f                	js     801052bc <create+0x18c>
  iunlockput(dp);
8010523d:	83 ec 0c             	sub    $0xc,%esp
80105240:	53                   	push   %ebx
80105241:	e8 6a c8 ff ff       	call   80101ab0 <iunlockput>
  return ip;
80105246:	83 c4 10             	add    $0x10,%esp
}
80105249:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524c:	89 f0                	mov    %esi,%eax
8010524e:	5b                   	pop    %ebx
8010524f:	5e                   	pop    %esi
80105250:	5f                   	pop    %edi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret    
80105253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105257:	90                   	nop
    iupdate(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
8010525b:	66 83 83 a6 00 00 00 	addw   $0x1,0xa6(%ebx)
80105262:	01 
    iupdate(dp);
80105263:	53                   	push   %ebx
80105264:	e8 c7 c4 ff ff       	call   80101730 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105269:	83 c4 0c             	add    $0xc,%esp
8010526c:	ff 76 04             	push   0x4(%esi)
8010526f:	68 e4 82 10 80       	push   $0x801082e4
80105274:	56                   	push   %esi
80105275:	e8 56 ce ff ff       	call   801020d0 <dirlink>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	78 18                	js     80105299 <create+0x169>
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	ff 73 04             	push   0x4(%ebx)
80105287:	68 e3 82 10 80       	push   $0x801082e3
8010528c:	56                   	push   %esi
8010528d:	e8 3e ce ff ff       	call   801020d0 <dirlink>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	79 90                	jns    80105229 <create+0xf9>
      panic("create dots");
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	68 d7 82 10 80       	push   $0x801082d7
801052a1:	e8 2a b1 ff ff       	call   801003d0 <panic>
801052a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
}
801052b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801052b3:	31 f6                	xor    %esi,%esi
}
801052b5:	5b                   	pop    %ebx
801052b6:	89 f0                	mov    %esi,%eax
801052b8:	5e                   	pop    %esi
801052b9:	5f                   	pop    %edi
801052ba:	5d                   	pop    %ebp
801052bb:	c3                   	ret    
    panic("create: dirlink");
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	68 e6 82 10 80       	push   $0x801082e6
801052c4:	e8 07 b1 ff ff       	call   801003d0 <panic>
    panic("create: ialloc");
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	68 c8 82 10 80       	push   $0x801082c8
801052d1:	e8 fa b0 ff ff       	call   801003d0 <panic>
801052d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052dd:	8d 76 00             	lea    0x0(%esi),%esi

801052e0 <sys_dup>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801052e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801052e8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801052eb:	50                   	push   %eax
801052ec:	6a 00                	push   $0x0
801052ee:	e8 8d fc ff ff       	call   80104f80 <argint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 36                	js     80105330 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801052fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052fe:	77 30                	ja     80105330 <sys_dup+0x50>
80105300:	e8 db e7 ff ff       	call   80103ae0 <myproc>
80105305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105308:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010530c:	85 f6                	test   %esi,%esi
8010530e:	74 20                	je     80105330 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105310:	e8 cb e7 ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105315:	31 db                	xor    %ebx,%ebx
80105317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105320:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105324:	85 d2                	test   %edx,%edx
80105326:	74 18                	je     80105340 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
80105328:	83 c3 01             	add    $0x1,%ebx
8010532b:	83 fb 10             	cmp    $0x10,%ebx
8010532e:	75 f0                	jne    80105320 <sys_dup+0x40>
}
80105330:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105333:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105338:	89 d8                	mov    %ebx,%eax
8010533a:	5b                   	pop    %ebx
8010533b:	5e                   	pop    %esi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105340:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105343:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105347:	56                   	push   %esi
80105348:	e8 a3 bb ff ff       	call   80100ef0 <filedup>
  return fd;
8010534d:	83 c4 10             	add    $0x10,%esp
}
80105350:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105353:	89 d8                	mov    %ebx,%eax
80105355:	5b                   	pop    %ebx
80105356:	5e                   	pop    %esi
80105357:	5d                   	pop    %ebp
80105358:	c3                   	ret    
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_read>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	56                   	push   %esi
80105364:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105365:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105368:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010536b:	53                   	push   %ebx
8010536c:	6a 00                	push   $0x0
8010536e:	e8 0d fc ff ff       	call   80104f80 <argint>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	78 5e                	js     801053d8 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010537a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010537e:	77 58                	ja     801053d8 <sys_read+0x78>
80105380:	e8 5b e7 ff ff       	call   80103ae0 <myproc>
80105385:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105388:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010538c:	85 f6                	test   %esi,%esi
8010538e:	74 48                	je     801053d8 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105390:	83 ec 08             	sub    $0x8,%esp
80105393:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105396:	50                   	push   %eax
80105397:	6a 02                	push   $0x2
80105399:	e8 e2 fb ff ff       	call   80104f80 <argint>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	85 c0                	test   %eax,%eax
801053a3:	78 33                	js     801053d8 <sys_read+0x78>
801053a5:	83 ec 04             	sub    $0x4,%esp
801053a8:	ff 75 f0             	push   -0x10(%ebp)
801053ab:	53                   	push   %ebx
801053ac:	6a 01                	push   $0x1
801053ae:	e8 1d fc ff ff       	call   80104fd0 <argptr>
801053b3:	83 c4 10             	add    $0x10,%esp
801053b6:	85 c0                	test   %eax,%eax
801053b8:	78 1e                	js     801053d8 <sys_read+0x78>
  return fileread(f, p, n);
801053ba:	83 ec 04             	sub    $0x4,%esp
801053bd:	ff 75 f0             	push   -0x10(%ebp)
801053c0:	ff 75 f4             	push   -0xc(%ebp)
801053c3:	56                   	push   %esi
801053c4:	e8 a7 bc ff ff       	call   80101070 <fileread>
801053c9:	83 c4 10             	add    $0x10,%esp
}
801053cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053cf:	5b                   	pop    %ebx
801053d0:	5e                   	pop    %esi
801053d1:	5d                   	pop    %ebp
801053d2:	c3                   	ret    
801053d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d7:	90                   	nop
    return -1;
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dd:	eb ed                	jmp    801053cc <sys_read+0x6c>
801053df:	90                   	nop

801053e0 <sys_write>:
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
801053ee:	e8 8d fb ff ff       	call   80104f80 <argint>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 5e                	js     80105458 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801053fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053fe:	77 58                	ja     80105458 <sys_write+0x78>
80105400:	e8 db e6 ff ff       	call   80103ae0 <myproc>
80105405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105408:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010540c:	85 f6                	test   %esi,%esi
8010540e:	74 48                	je     80105458 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105416:	50                   	push   %eax
80105417:	6a 02                	push   $0x2
80105419:	e8 62 fb ff ff       	call   80104f80 <argint>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 33                	js     80105458 <sys_write+0x78>
80105425:	83 ec 04             	sub    $0x4,%esp
80105428:	ff 75 f0             	push   -0x10(%ebp)
8010542b:	53                   	push   %ebx
8010542c:	6a 01                	push   $0x1
8010542e:	e8 9d fb ff ff       	call   80104fd0 <argptr>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 1e                	js     80105458 <sys_write+0x78>
  return filewrite(f, p, n);
8010543a:	83 ec 04             	sub    $0x4,%esp
8010543d:	ff 75 f0             	push   -0x10(%ebp)
80105440:	ff 75 f4             	push   -0xc(%ebp)
80105443:	56                   	push   %esi
80105444:	e8 b7 bc ff ff       	call   80101100 <filewrite>
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
8010545d:	eb ed                	jmp    8010544c <sys_write+0x6c>
8010545f:	90                   	nop

80105460 <sys_close>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105465:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105468:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010546b:	50                   	push   %eax
8010546c:	6a 00                	push   $0x0
8010546e:	e8 0d fb ff ff       	call   80104f80 <argint>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 3e                	js     801054b8 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010547a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010547e:	77 38                	ja     801054b8 <sys_close+0x58>
80105480:	e8 5b e6 ff ff       	call   80103ae0 <myproc>
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	8d 5a 08             	lea    0x8(%edx),%ebx
8010548b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010548f:	85 f6                	test   %esi,%esi
80105491:	74 25                	je     801054b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105493:	e8 48 e6 ff ff       	call   80103ae0 <myproc>
  fileclose(f);
80105498:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010549b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801054a2:	00 
  fileclose(f);
801054a3:	56                   	push   %esi
801054a4:	e8 97 ba ff ff       	call   80100f40 <fileclose>
  return 0;
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	31 c0                	xor    %eax,%eax
}
801054ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b1:	5b                   	pop    %ebx
801054b2:	5e                   	pop    %esi
801054b3:	5d                   	pop    %ebp
801054b4:	c3                   	ret    
801054b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb ef                	jmp    801054ae <sys_close+0x4e>
801054bf:	90                   	nop

801054c0 <sys_fstat>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801054c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054c8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801054cb:	53                   	push   %ebx
801054cc:	6a 00                	push   $0x0
801054ce:	e8 ad fa ff ff       	call   80104f80 <argint>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	78 46                	js     80105520 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801054da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054de:	77 40                	ja     80105520 <sys_fstat+0x60>
801054e0:	e8 fb e5 ff ff       	call   80103ae0 <myproc>
801054e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054ec:	85 f6                	test   %esi,%esi
801054ee:	74 30                	je     80105520 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
801054f0:	83 ec 04             	sub    $0x4,%esp
801054f3:	6a 14                	push   $0x14
801054f5:	53                   	push   %ebx
801054f6:	6a 01                	push   $0x1
801054f8:	e8 d3 fa ff ff       	call   80104fd0 <argptr>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	78 1c                	js     80105520 <sys_fstat+0x60>
  return filestat(f, st);
80105504:	83 ec 08             	sub    $0x8,%esp
80105507:	ff 75 f4             	push   -0xc(%ebp)
8010550a:	56                   	push   %esi
8010550b:	e8 10 bb ff ff       	call   80101020 <filestat>
80105510:	83 c4 10             	add    $0x10,%esp
}
80105513:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5d                   	pop    %ebp
80105519:	c3                   	ret    
8010551a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105525:	eb ec                	jmp    80105513 <sys_fstat+0x53>
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <sys_link>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105535:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105538:	53                   	push   %ebx
80105539:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010553c:	50                   	push   %eax
8010553d:	6a 00                	push   $0x0
8010553f:	e8 fc fa ff ff       	call   80105040 <argstr>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	0f 88 06 01 00 00    	js     80105655 <sys_link+0x125>
8010554f:	83 ec 08             	sub    $0x8,%esp
80105552:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105555:	50                   	push   %eax
80105556:	6a 01                	push   $0x1
80105558:	e8 e3 fa ff ff       	call   80105040 <argstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	0f 88 ed 00 00 00    	js     80105655 <sys_link+0x125>
  begin_op();
80105568:	e8 03 d9 ff ff       	call   80102e70 <begin_op>
  if ((ip = namei(old)) == 0)
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	ff 75 d4             	push   -0x2c(%ebp)
80105573:	e8 18 cc ff ff       	call   80102190 <namei>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	89 c3                	mov    %eax,%ebx
8010557d:	85 c0                	test   %eax,%eax
8010557f:	0f 84 ef 00 00 00    	je     80105674 <sys_link+0x144>
  ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 62 c2 ff ff       	call   801017f0 <ilock>
  if (ip->type == T_DIR)
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80105598:	01 
80105599:	0f 84 bd 00 00 00    	je     8010565c <sys_link+0x12c>
  iupdate(ip);
8010559f:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055a2:	66 83 83 a6 00 00 00 	addw   $0x1,0xa6(%ebx)
801055a9:	01 
  if ((dp = nameiparent(new, name)) == 0)
801055aa:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055ad:	53                   	push   %ebx
801055ae:	e8 7d c1 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
801055b3:	89 1c 24             	mov    %ebx,(%esp)
801055b6:	e8 25 c3 ff ff       	call   801018e0 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
801055bb:	58                   	pop    %eax
801055bc:	5a                   	pop    %edx
801055bd:	57                   	push   %edi
801055be:	ff 75 d0             	push   -0x30(%ebp)
801055c1:	e8 ea cb ff ff       	call   801021b0 <nameiparent>
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	89 c6                	mov    %eax,%esi
801055cb:	85 c0                	test   %eax,%eax
801055cd:	74 5d                	je     8010562c <sys_link+0xfc>
  ilock(dp);
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	50                   	push   %eax
801055d3:	e8 18 c2 ff ff       	call   801017f0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
801055d8:	8b 03                	mov    (%ebx),%eax
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	39 06                	cmp    %eax,(%esi)
801055df:	75 3f                	jne    80105620 <sys_link+0xf0>
801055e1:	83 ec 04             	sub    $0x4,%esp
801055e4:	ff 73 04             	push   0x4(%ebx)
801055e7:	57                   	push   %edi
801055e8:	56                   	push   %esi
801055e9:	e8 e2 ca ff ff       	call   801020d0 <dirlink>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 2b                	js     80105620 <sys_link+0xf0>
  iunlockput(dp);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	56                   	push   %esi
801055f9:	e8 b2 c4 ff ff       	call   80101ab0 <iunlockput>
  iput(ip);
801055fe:	89 1c 24             	mov    %ebx,(%esp)
80105601:	e8 2a c3 ff ff       	call   80101930 <iput>
  end_op();
80105606:	e8 d5 d8 ff ff       	call   80102ee0 <end_op>
  return 0;
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	31 c0                	xor    %eax,%eax
}
80105610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105613:	5b                   	pop    %ebx
80105614:	5e                   	pop    %esi
80105615:	5f                   	pop    %edi
80105616:	5d                   	pop    %ebp
80105617:	c3                   	ret    
80105618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
    iunlockput(dp);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	56                   	push   %esi
80105624:	e8 87 c4 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
80105629:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	53                   	push   %ebx
80105630:	e8 bb c1 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
80105635:	66 83 ab a6 00 00 00 	subw   $0x1,0xa6(%ebx)
8010563c:	01 
  iupdate(ip);
8010563d:	89 1c 24             	mov    %ebx,(%esp)
80105640:	e8 eb c0 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105645:	89 1c 24             	mov    %ebx,(%esp)
80105648:	e8 63 c4 ff ff       	call   80101ab0 <iunlockput>
  end_op();
8010564d:	e8 8e d8 ff ff       	call   80102ee0 <end_op>
  return -1;
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565a:	eb b4                	jmp    80105610 <sys_link+0xe0>
    iunlockput(ip);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	53                   	push   %ebx
80105660:	e8 4b c4 ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105665:	e8 76 d8 ff ff       	call   80102ee0 <end_op>
    return -1;
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105672:	eb 9c                	jmp    80105610 <sys_link+0xe0>
    end_op();
80105674:	e8 67 d8 ff ff       	call   80102ee0 <end_op>
    return -1;
80105679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567e:	eb 90                	jmp    80105610 <sys_link+0xe0>

80105680 <sys_unlink>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105685:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105688:	53                   	push   %ebx
80105689:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
8010568c:	50                   	push   %eax
8010568d:	6a 00                	push   $0x0
8010568f:	e8 ac f9 ff ff       	call   80105040 <argstr>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	0f 88 95 01 00 00    	js     80105834 <sys_unlink+0x1b4>
  begin_op();
8010569f:	e8 cc d7 ff ff       	call   80102e70 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
801056a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056a7:	83 ec 08             	sub    $0x8,%esp
801056aa:	53                   	push   %ebx
801056ab:	ff 75 c0             	push   -0x40(%ebp)
801056ae:	e8 fd ca ff ff       	call   801021b0 <nameiparent>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056b9:	85 c0                	test   %eax,%eax
801056bb:	0f 84 7d 01 00 00    	je     8010583e <sys_unlink+0x1be>
  ilock(dp);
801056c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	57                   	push   %edi
801056c8:	e8 23 c1 ff ff       	call   801017f0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056cd:	58                   	pop    %eax
801056ce:	5a                   	pop    %edx
801056cf:	68 e4 82 10 80       	push   $0x801082e4
801056d4:	53                   	push   %ebx
801056d5:	e8 b6 c6 ff ff       	call   80101d90 <namecmp>
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	85 c0                	test   %eax,%eax
801056df:	0f 84 13 01 00 00    	je     801057f8 <sys_unlink+0x178>
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	68 e3 82 10 80       	push   $0x801082e3
801056ed:	53                   	push   %ebx
801056ee:	e8 9d c6 ff ff       	call   80101d90 <namecmp>
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	0f 84 fa 00 00 00    	je     801057f8 <sys_unlink+0x178>
  if ((ip = dirlookup(dp, name, &off)) == 0)
801056fe:	83 ec 04             	sub    $0x4,%esp
80105701:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105704:	50                   	push   %eax
80105705:	53                   	push   %ebx
80105706:	57                   	push   %edi
80105707:	e8 a4 c6 ff ff       	call   80101db0 <dirlookup>
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	89 c3                	mov    %eax,%ebx
80105711:	85 c0                	test   %eax,%eax
80105713:	0f 84 df 00 00 00    	je     801057f8 <sys_unlink+0x178>
  ilock(ip);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	50                   	push   %eax
8010571d:	e8 ce c0 ff ff       	call   801017f0 <ilock>
  if (ip->nlink < 1)
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	66 83 bb a6 00 00 00 	cmpw   $0x0,0xa6(%ebx)
8010572c:	00 
8010572d:	0f 8e 34 01 00 00    	jle    80105867 <sys_unlink+0x1e7>
  if (ip->type == T_DIR && !isdirempty(ip))
80105733:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
8010573a:	01 
8010573b:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010573e:	74 70                	je     801057b0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
80105740:	83 ec 04             	sub    $0x4,%esp
80105743:	6a 10                	push   $0x10
80105745:	6a 00                	push   $0x0
80105747:	57                   	push   %edi
80105748:	e8 73 f5 ff ff       	call   80104cc0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
8010574d:	6a 10                	push   $0x10
8010574f:	ff 75 c4             	push   -0x3c(%ebp)
80105752:	57                   	push   %edi
80105753:	ff 75 b4             	push   -0x4c(%ebp)
80105756:	e8 f5 c4 ff ff       	call   80101c50 <writei>
8010575b:	83 c4 20             	add    $0x20,%esp
8010575e:	83 f8 10             	cmp    $0x10,%eax
80105761:	0f 85 f3 00 00 00    	jne    8010585a <sys_unlink+0x1da>
  if (ip->type == T_DIR)
80105767:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
8010576e:	01 
8010576f:	0f 84 a3 00 00 00    	je     80105818 <sys_unlink+0x198>
  iunlockput(dp);
80105775:	83 ec 0c             	sub    $0xc,%esp
80105778:	ff 75 b4             	push   -0x4c(%ebp)
8010577b:	e8 30 c3 ff ff       	call   80101ab0 <iunlockput>
  ip->nlink--;
80105780:	66 83 ab a6 00 00 00 	subw   $0x1,0xa6(%ebx)
80105787:	01 
  iupdate(ip);
80105788:	89 1c 24             	mov    %ebx,(%esp)
8010578b:	e8 a0 bf ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105790:	89 1c 24             	mov    %ebx,(%esp)
80105793:	e8 18 c3 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105798:	e8 43 d7 ff ff       	call   80102ee0 <end_op>
  return 0;
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	31 c0                	xor    %eax,%eax
}
801057a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a5:	5b                   	pop    %ebx
801057a6:	5e                   	pop    %esi
801057a7:	5f                   	pop    %edi
801057a8:	5d                   	pop    %ebp
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801057b0:	83 bb a8 00 00 00 20 	cmpl   $0x20,0xa8(%ebx)
801057b7:	76 87                	jbe    80105740 <sys_unlink+0xc0>
801057b9:	be 20 00 00 00       	mov    $0x20,%esi
801057be:	eb 0f                	jmp    801057cf <sys_unlink+0x14f>
801057c0:	83 c6 10             	add    $0x10,%esi
801057c3:	3b b3 a8 00 00 00    	cmp    0xa8(%ebx),%esi
801057c9:	0f 83 71 ff ff ff    	jae    80105740 <sys_unlink+0xc0>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801057cf:	6a 10                	push   $0x10
801057d1:	56                   	push   %esi
801057d2:	57                   	push   %edi
801057d3:	53                   	push   %ebx
801057d4:	e8 67 c3 ff ff       	call   80101b40 <readi>
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	83 f8 10             	cmp    $0x10,%eax
801057df:	75 6c                	jne    8010584d <sys_unlink+0x1cd>
    if (de.inum != 0)
801057e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057e6:	74 d8                	je     801057c0 <sys_unlink+0x140>
    iunlockput(ip);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	53                   	push   %ebx
801057ec:	e8 bf c2 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	ff 75 b4             	push   -0x4c(%ebp)
801057fe:	e8 ad c2 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105803:	e8 d8 d6 ff ff       	call   80102ee0 <end_op>
  return -1;
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105810:	eb 90                	jmp    801057a2 <sys_unlink+0x122>
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105818:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010581b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
8010581e:	66 83 a8 a6 00 00 00 	subw   $0x1,0xa6(%eax)
80105825:	01 
    iupdate(dp);
80105826:	50                   	push   %eax
80105827:	e8 04 bf ff ff       	call   80101730 <iupdate>
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	e9 41 ff ff ff       	jmp    80105775 <sys_unlink+0xf5>
    return -1;
80105834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105839:	e9 64 ff ff ff       	jmp    801057a2 <sys_unlink+0x122>
    end_op();
8010583e:	e8 9d d6 ff ff       	call   80102ee0 <end_op>
    return -1;
80105843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105848:	e9 55 ff ff ff       	jmp    801057a2 <sys_unlink+0x122>
      panic("isdirempty: readi");
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 08 83 10 80       	push   $0x80108308
80105855:	e8 76 ab ff ff       	call   801003d0 <panic>
    panic("unlink: writei");
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	68 1a 83 10 80       	push   $0x8010831a
80105862:	e8 69 ab ff ff       	call   801003d0 <panic>
    panic("unlink: nlink < 1");
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	68 f6 82 10 80       	push   $0x801082f6
8010586f:	e8 5c ab ff ff       	call   801003d0 <panic>
80105874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop

80105880 <sys_open>:

int sys_open(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105885:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105888:	53                   	push   %ebx
80105889:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010588c:	50                   	push   %eax
8010588d:	6a 00                	push   $0x0
8010588f:	e8 ac f7 ff ff       	call   80105040 <argstr>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	0f 88 9e 00 00 00    	js     8010593d <sys_open+0xbd>
8010589f:	83 ec 08             	sub    $0x8,%esp
801058a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a5:	50                   	push   %eax
801058a6:	6a 01                	push   $0x1
801058a8:	e8 d3 f6 ff ff       	call   80104f80 <argint>
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	85 c0                	test   %eax,%eax
801058b2:	0f 88 85 00 00 00    	js     8010593d <sys_open+0xbd>
    return -1;

  begin_op();
801058b8:	e8 b3 d5 ff ff       	call   80102e70 <begin_op>

  if (omode & O_CREATE)
801058bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058c1:	0f 85 81 00 00 00    	jne    80105948 <sys_open+0xc8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	ff 75 e0             	push   -0x20(%ebp)
801058cd:	e8 be c8 ff ff       	call   80102190 <namei>
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	89 c6                	mov    %eax,%esi
801058d7:	85 c0                	test   %eax,%eax
801058d9:	0f 84 86 00 00 00    	je     80105965 <sys_open+0xe5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
801058df:	83 ec 0c             	sub    $0xc,%esp
801058e2:	50                   	push   %eax
801058e3:	e8 08 bf ff ff       	call   801017f0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	66 83 be a0 00 00 00 	cmpw   $0x1,0xa0(%esi)
801058f2:	01 
801058f3:	0f 84 c7 00 00 00    	je     801059c0 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
801058f9:	e8 82 b5 ff ff       	call   80100e80 <filealloc>
801058fe:	89 c7                	mov    %eax,%edi
80105900:	85 c0                	test   %eax,%eax
80105902:	74 28                	je     8010592c <sys_open+0xac>
  struct proc *curproc = myproc();
80105904:	e8 d7 e1 ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105909:	31 db                	xor    %ebx,%ebx
8010590b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010590f:	90                   	nop
    if (curproc->ofile[fd] == 0)
80105910:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105914:	85 d2                	test   %edx,%edx
80105916:	74 60                	je     80105978 <sys_open+0xf8>
  for (fd = 0; fd < NOFILE; fd++)
80105918:	83 c3 01             	add    $0x1,%ebx
8010591b:	83 fb 10             	cmp    $0x10,%ebx
8010591e:	75 f0                	jne    80105910 <sys_open+0x90>
  {
    if (f)
      fileclose(f);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	57                   	push   %edi
80105924:	e8 17 b6 ff ff       	call   80100f40 <fileclose>
80105929:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010592c:	83 ec 0c             	sub    $0xc,%esp
8010592f:	56                   	push   %esi
80105930:	e8 7b c1 ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105935:	e8 a6 d5 ff ff       	call   80102ee0 <end_op>
    return -1;
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105942:	eb 6d                	jmp    801059b1 <sys_open+0x131>
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010594e:	31 c9                	xor    %ecx,%ecx
80105950:	ba 02 00 00 00       	mov    $0x2,%edx
80105955:	6a 00                	push   $0x0
80105957:	e8 d4 f7 ff ff       	call   80105130 <create>
    if (ip == 0)
8010595c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010595f:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105961:	85 c0                	test   %eax,%eax
80105963:	75 94                	jne    801058f9 <sys_open+0x79>
      end_op();
80105965:	e8 76 d5 ff ff       	call   80102ee0 <end_op>
      return -1;
8010596a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010596f:	eb 40                	jmp    801059b1 <sys_open+0x131>
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105978:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010597b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010597f:	56                   	push   %esi
80105980:	e8 5b bf ff ff       	call   801018e0 <iunlock>
  end_op();
80105985:	e8 56 d5 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
8010598a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105993:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105996:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105999:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010599b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059a2:	f7 d0                	not    %eax
801059a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b4:	89 d8                	mov    %ebx,%eax
801059b6:	5b                   	pop    %ebx
801059b7:	5e                   	pop    %esi
801059b8:	5f                   	pop    %edi
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
801059c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059c3:	85 c9                	test   %ecx,%ecx
801059c5:	0f 84 2e ff ff ff    	je     801058f9 <sys_open+0x79>
801059cb:	e9 5c ff ff ff       	jmp    8010592c <sys_open+0xac>

801059d0 <sys_mkdir>:

int sys_mkdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059d6:	e8 95 d4 ff ff       	call   80102e70 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
801059db:	83 ec 08             	sub    $0x8,%esp
801059de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e1:	50                   	push   %eax
801059e2:	6a 00                	push   $0x0
801059e4:	e8 57 f6 ff ff       	call   80105040 <argstr>
801059e9:	83 c4 10             	add    $0x10,%esp
801059ec:	85 c0                	test   %eax,%eax
801059ee:	78 30                	js     80105a20 <sys_mkdir+0x50>
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f6:	31 c9                	xor    %ecx,%ecx
801059f8:	ba 01 00 00 00       	mov    $0x1,%edx
801059fd:	6a 00                	push   $0x0
801059ff:	e8 2c f7 ff ff       	call   80105130 <create>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	74 15                	je     80105a20 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a0b:	83 ec 0c             	sub    $0xc,%esp
80105a0e:	50                   	push   %eax
80105a0f:	e8 9c c0 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105a14:	e8 c7 d4 ff ff       	call   80102ee0 <end_op>
  return 0;
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	31 c0                	xor    %eax,%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    
    end_op();
80105a20:	e8 bb d4 ff ff       	call   80102ee0 <end_op>
    return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_mknod>:

int sys_mknod(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a36:	e8 35 d4 ff ff       	call   80102e70 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105a3b:	83 ec 08             	sub    $0x8,%esp
80105a3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a41:	50                   	push   %eax
80105a42:	6a 00                	push   $0x0
80105a44:	e8 f7 f5 ff ff       	call   80105040 <argstr>
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	85 c0                	test   %eax,%eax
80105a4e:	78 60                	js     80105ab0 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a56:	50                   	push   %eax
80105a57:	6a 01                	push   $0x1
80105a59:	e8 22 f5 ff ff       	call   80104f80 <argint>
  if ((argstr(0, &path)) < 0 ||
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	78 4b                	js     80105ab0 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a6b:	50                   	push   %eax
80105a6c:	6a 02                	push   $0x2
80105a6e:	e8 0d f5 ff ff       	call   80104f80 <argint>
      argint(1, &major) < 0 ||
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 36                	js     80105ab0 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105a7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a7e:	83 ec 0c             	sub    $0xc,%esp
80105a81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a85:	ba 03 00 00 00       	mov    $0x3,%edx
80105a8a:	50                   	push   %eax
80105a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a8e:	e8 9d f6 ff ff       	call   80105130 <create>
      argint(2, &minor) < 0 ||
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	74 16                	je     80105ab0 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a9a:	83 ec 0c             	sub    $0xc,%esp
80105a9d:	50                   	push   %eax
80105a9e:	e8 0d c0 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105aa3:	e8 38 d4 ff ff       	call   80102ee0 <end_op>
  return 0;
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	31 c0                	xor    %eax,%eax
}
80105aad:	c9                   	leave  
80105aae:	c3                   	ret    
80105aaf:	90                   	nop
    end_op();
80105ab0:	e8 2b d4 ff ff       	call   80102ee0 <end_op>
    return -1;
80105ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aba:	c9                   	leave  
80105abb:	c3                   	ret    
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_chdir>:

int sys_chdir(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	56                   	push   %esi
80105ac4:	53                   	push   %ebx
80105ac5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ac8:	e8 13 e0 ff ff       	call   80103ae0 <myproc>
80105acd:	89 c6                	mov    %eax,%esi

  begin_op();
80105acf:	e8 9c d3 ff ff       	call   80102e70 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ada:	50                   	push   %eax
80105adb:	6a 00                	push   $0x0
80105add:	e8 5e f5 ff ff       	call   80105040 <argstr>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 77                	js     80105b60 <sys_chdir+0xa0>
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	ff 75 f4             	push   -0xc(%ebp)
80105aef:	e8 9c c6 ff ff       	call   80102190 <namei>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	89 c3                	mov    %eax,%ebx
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 63                	je     80105b60 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	50                   	push   %eax
80105b01:	e8 ea bc ff ff       	call   801017f0 <ilock>
  if (ip->type != T_DIR)
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	66 83 bb a0 00 00 00 	cmpw   $0x1,0xa0(%ebx)
80105b10:	01 
80105b11:	75 2d                	jne    80105b40 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b13:	83 ec 0c             	sub    $0xc,%esp
80105b16:	53                   	push   %ebx
80105b17:	e8 c4 bd ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105b1c:	58                   	pop    %eax
80105b1d:	ff 76 68             	push   0x68(%esi)
80105b20:	e8 0b be ff ff       	call   80101930 <iput>
  end_op();
80105b25:	e8 b6 d3 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105b2a:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	31 c0                	xor    %eax,%eax
}
80105b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b35:	5b                   	pop    %ebx
80105b36:	5e                   	pop    %esi
80105b37:	5d                   	pop    %ebp
80105b38:	c3                   	ret    
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	53                   	push   %ebx
80105b44:	e8 67 bf ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105b49:	e8 92 d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	eb da                	jmp    80105b32 <sys_chdir+0x72>
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    end_op();
80105b60:	e8 7b d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6a:	eb c6                	jmp    80105b32 <sys_chdir+0x72>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_exec>:

int sys_exec(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105b75:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b7b:	53                   	push   %ebx
80105b7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 b6 f4 ff ff       	call   80105040 <argstr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	0f 88 87 00 00 00    	js     80105c1c <sys_exec+0xac>
80105b95:	83 ec 08             	sub    $0x8,%esp
80105b98:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b9e:	50                   	push   %eax
80105b9f:	6a 01                	push   $0x1
80105ba1:	e8 da f3 ff ff       	call   80104f80 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 6f                	js     80105c1c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bad:	83 ec 04             	sub    $0x4,%esp
80105bb0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80105bb6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bb8:	68 80 00 00 00       	push   $0x80
80105bbd:	6a 00                	push   $0x0
80105bbf:	56                   	push   %esi
80105bc0:	e8 fb f0 ff ff       	call   80104cc0 <memset>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105bd9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105be0:	50                   	push   %eax
80105be1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105be7:	01 f8                	add    %edi,%eax
80105be9:	50                   	push   %eax
80105bea:	e8 01 f3 ff ff       	call   80104ef0 <fetchint>
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	85 c0                	test   %eax,%eax
80105bf4:	78 26                	js     80105c1c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80105bf6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bfc:	85 c0                	test   %eax,%eax
80105bfe:	74 30                	je     80105c30 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c06:	52                   	push   %edx
80105c07:	50                   	push   %eax
80105c08:	e8 23 f3 ff ff       	call   80104f30 <fetchstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 08                	js     80105c1c <sys_exec+0xac>
  for (i = 0;; i++)
80105c14:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105c17:	83 fb 20             	cmp    $0x20,%ebx
80105c1a:	75 b4                	jne    80105bd0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c24:	5b                   	pop    %ebx
80105c25:	5e                   	pop    %esi
80105c26:	5f                   	pop    %edi
80105c27:	5d                   	pop    %ebp
80105c28:	c3                   	ret    
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c30:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c37:	00 00 00 00 
  return exec(path, argv);
80105c3b:	83 ec 08             	sub    $0x8,%esp
80105c3e:	56                   	push   %esi
80105c3f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c45:	e8 b6 ae ff ff       	call   80100b00 <exec>
80105c4a:	83 c4 10             	add    $0x10,%esp
}
80105c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c50:	5b                   	pop    %ebx
80105c51:	5e                   	pop    %esi
80105c52:	5f                   	pop    %edi
80105c53:	5d                   	pop    %ebp
80105c54:	c3                   	ret    
80105c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_pipe>:

int sys_pipe(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105c65:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c68:	53                   	push   %ebx
80105c69:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105c6c:	6a 08                	push   $0x8
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 5a f3 ff ff       	call   80104fd0 <argptr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 4a                	js     80105cc7 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105c7d:	83 ec 08             	sub    $0x8,%esp
80105c80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c83:	50                   	push   %eax
80105c84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c87:	50                   	push   %eax
80105c88:	e8 b3 d8 ff ff       	call   80103540 <pipealloc>
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	85 c0                	test   %eax,%eax
80105c92:	78 33                	js     80105cc7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105c94:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80105c97:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c99:	e8 42 de ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105c9e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105ca0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ca4:	85 f6                	test   %esi,%esi
80105ca6:	74 28                	je     80105cd0 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80105ca8:	83 c3 01             	add    $0x1,%ebx
80105cab:	83 fb 10             	cmp    $0x10,%ebx
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	ff 75 e0             	push   -0x20(%ebp)
80105cb6:	e8 85 b2 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105cbb:	58                   	pop    %eax
80105cbc:	ff 75 e4             	push   -0x1c(%ebp)
80105cbf:	e8 7c b2 ff ff       	call   80100f40 <fileclose>
    return -1;
80105cc4:	83 c4 10             	add    $0x10,%esp
80105cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ccc:	eb 53                	jmp    80105d21 <sys_pipe+0xc1>
80105cce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105cd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105cd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cda:	e8 01 de ff ff       	call   80103ae0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105cdf:	31 d2                	xor    %edx,%edx
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105ce8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cec:	85 c9                	test   %ecx,%ecx
80105cee:	74 20                	je     80105d10 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80105cf0:	83 c2 01             	add    $0x1,%edx
80105cf3:	83 fa 10             	cmp    $0x10,%edx
80105cf6:	75 f0                	jne    80105ce8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105cf8:	e8 e3 dd ff ff       	call   80103ae0 <myproc>
80105cfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d04:	00 
80105d05:	eb a9                	jmp    80105cb0 <sys_pipe+0x50>
80105d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d1f:	31 c0                	xor    %eax,%eax
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_hello>:

int sys_hello(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hi! Welcome to the world of xv6!\n");
80105d36:	68 2c 83 10 80       	push   $0x8010832c
80105d3b:	e8 b0 a9 ff ff       	call   801006f0 <cprintf>
  return 0;
}
80105d40:	31 c0                	xor    %eax,%eax
80105d42:	c9                   	leave  
80105d43:	c3                   	ret    
80105d44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop

80105d50 <sys_helloYou>:
int sys_helloYou(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 18             	sub    $0x18,%esp
  // char *argv[MAXARG];
  char *path;
  begin_op();
80105d56:	e8 15 d1 ff ff       	call   80102e70 <begin_op>
  argstr(0, &path);
80105d5b:	83 ec 08             	sub    $0x8,%esp
80105d5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d61:	50                   	push   %eax
80105d62:	6a 00                	push   $0x0
80105d64:	e8 d7 f2 ff ff       	call   80105040 <argstr>
  cprintf("this is the helloYou syscall called %s\n", path);
80105d69:	58                   	pop    %eax
80105d6a:	5a                   	pop    %edx
80105d6b:	ff 75 f4             	push   -0xc(%ebp)
80105d6e:	68 50 83 10 80       	push   $0x80108350
80105d73:	e8 78 a9 ff ff       	call   801006f0 <cprintf>
  end_op();
80105d78:	e8 63 d1 ff ff       	call   80102ee0 <end_op>
  return 0;
}
80105d7d:	31 c0                	xor    %eax,%eax
80105d7f:	c9                   	leave  
80105d80:	c3                   	ret    
80105d81:	66 90                	xchg   %ax,%ax
80105d83:	66 90                	xchg   %ax,%ax
80105d85:	66 90                	xchg   %ax,%ax
80105d87:	66 90                	xchg   %ax,%ax
80105d89:	66 90                	xchg   %ax,%ax
80105d8b:	66 90                	xchg   %ax,%ax
80105d8d:	66 90                	xchg   %ax,%ax
80105d8f:	90                   	nop

80105d90 <sys_fork>:
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
  return fork();
80105d90:	e9 eb de ff ff       	jmp    80103c80 <fork>
80105d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_exit>:
}

int sys_exit(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105da6:	e8 55 e1 ff ff       	call   80103f00 <exit>
  return 0; // not reached
}
80105dab:	31 c0                	xor    %eax,%eax
80105dad:	c9                   	leave  
80105dae:	c3                   	ret    
80105daf:	90                   	nop

80105db0 <sys_wait>:

int sys_wait(void)
{
  return wait();
80105db0:	e9 5b e2 ff ff       	jmp    80104010 <wait>
80105db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <sys_kill>:
}

int sys_kill(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105dc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc9:	50                   	push   %eax
80105dca:	6a 00                	push   $0x0
80105dcc:	e8 af f1 ff ff       	call   80104f80 <argint>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	85 c0                	test   %eax,%eax
80105dd6:	78 18                	js     80105df0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105dd8:	83 ec 0c             	sub    $0xc,%esp
80105ddb:	ff 75 f4             	push   -0xc(%ebp)
80105dde:	e8 cd e4 ff ff       	call   801042b0 <kill>
80105de3:	83 c4 10             	add    $0x10,%esp
}
80105de6:	c9                   	leave  
80105de7:	c3                   	ret    
80105de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
80105df0:	c9                   	leave  
    return -1;
80105df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df6:	c3                   	ret    
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <sys_getpid>:

int sys_getpid(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e06:	e8 d5 dc ff ff       	call   80103ae0 <myproc>
80105e0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e0e:	c9                   	leave  
80105e0f:	c3                   	ret    

80105e10 <sys_sbrk>:

int sys_sbrk(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80105e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e17:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105e1a:	50                   	push   %eax
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 5e f1 ff ff       	call   80104f80 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	78 27                	js     80105e50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e29:	e8 b2 dc ff ff       	call   80103ae0 <myproc>
  if (growproc(n) < 0)
80105e2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e31:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105e33:	ff 75 f4             	push   -0xc(%ebp)
80105e36:	e8 c5 dd ff ff       	call   80103c00 <growproc>
80105e3b:	83 c4 10             	add    $0x10,%esp
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	78 0e                	js     80105e50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e42:	89 d8                	mov    %ebx,%eax
80105e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e47:	c9                   	leave  
80105e48:	c3                   	ret    
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e55:	eb eb                	jmp    80105e42 <sys_sbrk+0x32>
80105e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <sys_sleep>:

int sys_sleep(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105e64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e67:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105e6a:	50                   	push   %eax
80105e6b:	6a 00                	push   $0x0
80105e6d:	e8 0e f1 ff ff       	call   80104f80 <argint>
80105e72:	83 c4 10             	add    $0x10,%esp
80105e75:	85 c0                	test   %eax,%eax
80105e77:	0f 88 8a 00 00 00    	js     80105f07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 60 69 11 80       	push   $0x80116960
80105e85:	e8 c6 eb ff ff       	call   80104a50 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80105e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e8d:	8b 1d 40 69 11 80    	mov    0x80116940,%ebx
  while (ticks - ticks0 < n)
80105e93:	83 c4 10             	add    $0x10,%esp
80105e96:	85 d2                	test   %edx,%edx
80105e98:	75 27                	jne    80105ec1 <sys_sleep+0x61>
80105e9a:	eb 54                	jmp    80105ef0 <sys_sleep+0x90>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ea0:	83 ec 08             	sub    $0x8,%esp
80105ea3:	68 60 69 11 80       	push   $0x80116960
80105ea8:	68 40 69 11 80       	push   $0x80116940
80105ead:	e8 de e2 ff ff       	call   80104190 <sleep>
  while (ticks - ticks0 < n)
80105eb2:	a1 40 69 11 80       	mov    0x80116940,%eax
80105eb7:	83 c4 10             	add    $0x10,%esp
80105eba:	29 d8                	sub    %ebx,%eax
80105ebc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ebf:	73 2f                	jae    80105ef0 <sys_sleep+0x90>
    if (myproc()->killed)
80105ec1:	e8 1a dc ff ff       	call   80103ae0 <myproc>
80105ec6:	8b 40 24             	mov    0x24(%eax),%eax
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	74 d3                	je     80105ea0 <sys_sleep+0x40>
      release(&tickslock);
80105ecd:	83 ec 0c             	sub    $0xc,%esp
80105ed0:	68 60 69 11 80       	push   $0x80116960
80105ed5:	e8 16 eb ff ff       	call   801049f0 <release>
  }
  release(&tickslock);
  return 0;
}
80105eda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
80105ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	68 60 69 11 80       	push   $0x80116960
80105ef8:	e8 f3 ea ff ff       	call   801049f0 <release>
  return 0;
80105efd:	83 c4 10             	add    $0x10,%esp
80105f00:	31 c0                	xor    %eax,%eax
}
80105f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f05:	c9                   	leave  
80105f06:	c3                   	ret    
    return -1;
80105f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0c:	eb f4                	jmp    80105f02 <sys_sleep+0xa2>
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	53                   	push   %ebx
80105f14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f17:	68 60 69 11 80       	push   $0x80116960
80105f1c:	e8 2f eb ff ff       	call   80104a50 <acquire>
  xticks = ticks;
80105f21:	8b 1d 40 69 11 80    	mov    0x80116940,%ebx
  release(&tickslock);
80105f27:	c7 04 24 60 69 11 80 	movl   $0x80116960,(%esp)
80105f2e:	e8 bd ea ff ff       	call   801049f0 <release>
  return xticks;
}
80105f33:	89 d8                	mov    %ebx,%eax
80105f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f38:	c9                   	leave  
80105f39:	c3                   	ret    
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f40 <sys_getppid>:
// {
//   return 0;   //commenting this line resolved the error
// }            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 20             	sub    $0x20,%esp
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
80105f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f49:	50                   	push   %eax
80105f4a:	6a 00                	push   $0x0
80105f4c:	e8 2f f0 ff ff       	call   80104f80 <argint>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	85 c0                	test   %eax,%eax
80105f56:	78 08                	js     80105f60 <sys_getppid+0x20>
   return -1;
  }
  return getppid();
80105f58:	e8 93 e4 ff ff       	call   801043f0 <getppid>
}
80105f5d:	c9                   	leave  
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop
80105f60:	c9                   	leave  
   return -1;
80105f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f66:	c3                   	ret    
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <sys_get_siblings_info>:

int sys_get_siblings_info(int pid){
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f76:	e8 65 db ff ff       	call   80103ae0 <myproc>
  
  return get_siblings_info(sys_getpid());
80105f7b:	8b 40 10             	mov    0x10(%eax),%eax
80105f7e:	89 45 08             	mov    %eax,0x8(%ebp)
}
80105f81:	c9                   	leave  
  return get_siblings_info(sys_getpid());
80105f82:	e9 c9 e4 ff ff       	jmp    80104450 <get_siblings_info>
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_signalProcess>:
void sys_signalProcess(int pid,char type[]){
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 10             	sub    $0x10,%esp
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
80105f96:	8d 45 08             	lea    0x8(%ebp),%eax
80105f99:	50                   	push   %eax
80105f9a:	6a 00                	push   $0x0
80105f9c:	e8 df ef ff ff       	call   80104f80 <argint>
  char **type1=&type;
  argstr(1,type1); 
80105fa1:	58                   	pop    %eax
80105fa2:	8d 45 0c             	lea    0xc(%ebp),%eax
80105fa5:	5a                   	pop    %edx
80105fa6:	50                   	push   %eax
80105fa7:	6a 01                	push   $0x1
80105fa9:	e8 92 f0 ff ff       	call   80105040 <argstr>
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
80105fae:	59                   	pop    %ecx
80105faf:	58                   	pop    %eax
80105fb0:	ff 75 0c             	push   0xc(%ebp)
80105fb3:	ff 75 08             	push   0x8(%ebp)
80105fb6:	e8 65 e5 ff ff       	call   80104520 <signalProcess>
}
80105fbb:	83 c4 10             	add    $0x10,%esp
80105fbe:	c9                   	leave  
80105fbf:	c3                   	ret    

80105fc0 <sys_numvp>:

int sys_numvp(){
  return numvp();
80105fc0:	e9 9b e6 ff ff       	jmp    80104660 <numvp>
80105fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_numpp>:
}

int sys_numpp(){
  return numpp();
80105fd0:	e9 bb e6 ff ff       	jmp    80104690 <numpp>
80105fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_init_counter>:
/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
80105fe0:	c7 05 30 69 11 80 00 	movl   $0x0,0x80116930
80105fe7:	00 00 00 
}
80105fea:	c3                   	ret    
80105feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop

80105ff0 <sys_update_cnt>:

void sys_update_cnt(void){
  // acquire_mylock(0);
  counter = counter + 1;
80105ff0:	83 05 30 69 11 80 01 	addl   $0x1,0x80116930
  // cprintf("%d\n",holding_mylock(3));
  // release_mylock(0);
}
80105ff7:	c3                   	ret    
80105ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <sys_display_count>:

int sys_display_count(void){
  return counter;
}
80106000:	a1 30 69 11 80       	mov    0x80116930,%eax
80106005:	c3                   	ret    
80106006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600d:	8d 76 00             	lea    0x0(%esi),%esi

80106010 <sys_init_counter_1>:
/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
80106010:	c7 05 2c 69 11 80 00 	movl   $0x0,0x8011692c
80106017:	00 00 00 
}
8010601a:	c3                   	ret    
8010601b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop

80106020 <sys_update_cnt_1>:

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
80106020:	83 05 2c 69 11 80 01 	addl   $0x1,0x8011692c
}
80106027:	c3                   	ret    
80106028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <sys_display_count_1>:

int sys_display_count_1(void){
  return counter_1;
}
80106030:	a1 2c 69 11 80       	mov    0x8011692c,%eax
80106035:	c3                   	ret    
80106036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603d:	8d 76 00             	lea    0x0(%esi),%esi

80106040 <sys_init_counter_2>:
/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
80106040:	c7 05 28 69 11 80 00 	movl   $0x0,0x80116928
80106047:	00 00 00 
}
8010604a:	c3                   	ret    
8010604b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop

80106050 <sys_update_cnt_2>:

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
80106050:	83 05 28 69 11 80 01 	addl   $0x1,0x80116928
}
80106057:	c3                   	ret    
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop

80106060 <sys_display_count_2>:

int sys_display_count_2(void){
  return counter_2;
}
80106060:	a1 28 69 11 80       	mov    0x80116928,%eax
80106065:	c3                   	ret    
80106066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606d:	8d 76 00             	lea    0x0(%esi),%esi

80106070 <sys_init_mylock>:

int sys_init_mylock(){
  return init_mylock();
80106070:	e9 2b e6 ff ff       	jmp    801046a0 <init_mylock>
80106075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106080 <sys_acquire_mylock>:
}

int sys_acquire_mylock(int id){
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
80106086:	8d 45 08             	lea    0x8(%ebp),%eax
80106089:	50                   	push   %eax
8010608a:	6a 00                	push   $0x0
8010608c:	e8 ef ee ff ff       	call   80104f80 <argint>
  return acquire_mylock(id);
80106091:	58                   	pop    %eax
80106092:	ff 75 08             	push   0x8(%ebp)
80106095:	e8 26 e6 ff ff       	call   801046c0 <acquire_mylock>
}
8010609a:	c9                   	leave  
8010609b:	c3                   	ret    
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_release_mylock>:

int sys_release_mylock(int id){
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801060a6:	8d 45 08             	lea    0x8(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	6a 00                	push   $0x0
801060ac:	e8 cf ee ff ff       	call   80104f80 <argint>
  return release_mylock(id);
801060b1:	58                   	pop    %eax
801060b2:	ff 75 08             	push   0x8(%ebp)
801060b5:	e8 36 e6 ff ff       	call   801046f0 <release_mylock>
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_holding_mylock>:

int sys_holding_mylock(int id){
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 10             	sub    $0x10,%esp
  argint(0,&id);
801060c6:	8d 45 08             	lea    0x8(%ebp),%eax
801060c9:	50                   	push   %eax
801060ca:	6a 00                	push   $0x0
801060cc:	e8 af ee ff ff       	call   80104f80 <argint>
  return holding_mylock(id);
801060d1:	58                   	pop    %eax
801060d2:	ff 75 08             	push   0x8(%ebp)
801060d5:	e8 46 e6 ff ff       	call   80104720 <holding_mylock>
801060da:	c9                   	leave  
801060db:	c3                   	ret    

801060dc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060dc:	1e                   	push   %ds
  pushl %es
801060dd:	06                   	push   %es
  pushl %fs
801060de:	0f a0                	push   %fs
  pushl %gs
801060e0:	0f a8                	push   %gs
  pushal
801060e2:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060e3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060e7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060e9:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060eb:	54                   	push   %esp
  call trap
801060ec:	e8 bf 00 00 00       	call   801061b0 <trap>
  addl $4, %esp
801060f1:	83 c4 04             	add    $0x4,%esp

801060f4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801060f4:	61                   	popa   
  popl %gs
801060f5:	0f a9                	pop    %gs
  popl %fs
801060f7:	0f a1                	pop    %fs
  popl %es
801060f9:	07                   	pop    %es
  popl %ds
801060fa:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060fb:	83 c4 08             	add    $0x8,%esp
  iret
801060fe:	cf                   	iret   
801060ff:	90                   	nop

80106100 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106100:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106101:	31 c0                	xor    %eax,%eax
{
80106103:	89 e5                	mov    %esp,%ebp
80106105:	83 ec 08             	sub    $0x8,%esp
80106108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106110:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106117:	c7 04 c5 02 6a 11 80 	movl   $0x8e000008,-0x7fee95fe(,%eax,8)
8010611e:	08 00 00 8e 
80106122:	66 89 14 c5 00 6a 11 	mov    %dx,-0x7fee9600(,%eax,8)
80106129:	80 
8010612a:	c1 ea 10             	shr    $0x10,%edx
8010612d:	66 89 14 c5 06 6a 11 	mov    %dx,-0x7fee95fa(,%eax,8)
80106134:	80 
  for(i = 0; i < 256; i++)
80106135:	83 c0 01             	add    $0x1,%eax
80106138:	3d 00 01 00 00       	cmp    $0x100,%eax
8010613d:	75 d1                	jne    80106110 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010613f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106142:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106147:	c7 05 02 6c 11 80 08 	movl   $0xef000008,0x80116c02
8010614e:	00 00 ef 
  initlock(&tickslock, "time");
80106151:	68 78 83 10 80       	push   $0x80108378
80106156:	68 60 69 11 80       	push   $0x80116960
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010615b:	66 a3 00 6c 11 80    	mov    %ax,0x80116c00
80106161:	c1 e8 10             	shr    $0x10,%eax
80106164:	66 a3 06 6c 11 80    	mov    %ax,0x80116c06
  initlock(&tickslock, "time");
8010616a:	e8 11 e7 ff ff       	call   80104880 <initlock>
}
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	c9                   	leave  
80106173:	c3                   	ret    
80106174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010617f:	90                   	nop

80106180 <idtinit>:

void
idtinit(void)
{
80106180:	55                   	push   %ebp
  pd[0] = size-1;
80106181:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106186:	89 e5                	mov    %esp,%ebp
80106188:	83 ec 10             	sub    $0x10,%esp
8010618b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010618f:	b8 00 6a 11 80       	mov    $0x80116a00,%eax
80106194:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106198:	c1 e8 10             	shr    $0x10,%eax
8010619b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010619f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061a5:	c9                   	leave  
801061a6:	c3                   	ret    
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	57                   	push   %edi
801061b4:	56                   	push   %esi
801061b5:	53                   	push   %ebx
801061b6:	83 ec 1c             	sub    $0x1c,%esp
801061b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801061bc:	8b 43 30             	mov    0x30(%ebx),%eax
801061bf:	83 f8 40             	cmp    $0x40,%eax
801061c2:	0f 84 68 01 00 00    	je     80106330 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061c8:	83 e8 20             	sub    $0x20,%eax
801061cb:	83 f8 1f             	cmp    $0x1f,%eax
801061ce:	0f 87 8c 00 00 00    	ja     80106260 <trap+0xb0>
801061d4:	ff 24 85 20 84 10 80 	jmp    *-0x7fef7be0(,%eax,4)
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801061e0:	e8 4b c1 ff ff       	call   80102330 <ideintr>
    lapiceoi();
801061e5:	e8 26 c8 ff ff       	call   80102a10 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ea:	e8 f1 d8 ff ff       	call   80103ae0 <myproc>
801061ef:	85 c0                	test   %eax,%eax
801061f1:	74 1d                	je     80106210 <trap+0x60>
801061f3:	e8 e8 d8 ff ff       	call   80103ae0 <myproc>
801061f8:	8b 50 24             	mov    0x24(%eax),%edx
801061fb:	85 d2                	test   %edx,%edx
801061fd:	74 11                	je     80106210 <trap+0x60>
801061ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106203:	83 e0 03             	and    $0x3,%eax
80106206:	66 83 f8 03          	cmp    $0x3,%ax
8010620a:	0f 84 e8 01 00 00    	je     801063f8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106210:	e8 cb d8 ff ff       	call   80103ae0 <myproc>
80106215:	85 c0                	test   %eax,%eax
80106217:	74 0f                	je     80106228 <trap+0x78>
80106219:	e8 c2 d8 ff ff       	call   80103ae0 <myproc>
8010621e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106222:	0f 84 b8 00 00 00    	je     801062e0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106228:	e8 b3 d8 ff ff       	call   80103ae0 <myproc>
8010622d:	85 c0                	test   %eax,%eax
8010622f:	74 1d                	je     8010624e <trap+0x9e>
80106231:	e8 aa d8 ff ff       	call   80103ae0 <myproc>
80106236:	8b 40 24             	mov    0x24(%eax),%eax
80106239:	85 c0                	test   %eax,%eax
8010623b:	74 11                	je     8010624e <trap+0x9e>
8010623d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106241:	83 e0 03             	and    $0x3,%eax
80106244:	66 83 f8 03          	cmp    $0x3,%ax
80106248:	0f 84 0f 01 00 00    	je     8010635d <trap+0x1ad>
    exit();
}
8010624e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106251:	5b                   	pop    %ebx
80106252:	5e                   	pop    %esi
80106253:	5f                   	pop    %edi
80106254:	5d                   	pop    %ebp
80106255:	c3                   	ret    
80106256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106260:	e8 7b d8 ff ff       	call   80103ae0 <myproc>
80106265:	8b 7b 38             	mov    0x38(%ebx),%edi
80106268:	85 c0                	test   %eax,%eax
8010626a:	0f 84 a2 01 00 00    	je     80106412 <trap+0x262>
80106270:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106274:	0f 84 98 01 00 00    	je     80106412 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010627a:	0f 20 d1             	mov    %cr2,%ecx
8010627d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106280:	e8 3b d8 ff ff       	call   80103ac0 <cpuid>
80106285:	8b 73 30             	mov    0x30(%ebx),%esi
80106288:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010628b:	8b 43 34             	mov    0x34(%ebx),%eax
8010628e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106291:	e8 4a d8 ff ff       	call   80103ae0 <myproc>
80106296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106299:	e8 42 d8 ff ff       	call   80103ae0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062a4:	51                   	push   %ecx
801062a5:	57                   	push   %edi
801062a6:	52                   	push   %edx
801062a7:	ff 75 e4             	push   -0x1c(%ebp)
801062aa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
801062ae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062b1:	56                   	push   %esi
801062b2:	ff 70 10             	push   0x10(%eax)
801062b5:	68 dc 83 10 80       	push   $0x801083dc
801062ba:	e8 31 a4 ff ff       	call   801006f0 <cprintf>
    myproc()->killed = 1;
801062bf:	83 c4 20             	add    $0x20,%esp
801062c2:	e8 19 d8 ff ff       	call   80103ae0 <myproc>
801062c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ce:	e8 0d d8 ff ff       	call   80103ae0 <myproc>
801062d3:	85 c0                	test   %eax,%eax
801062d5:	0f 85 18 ff ff ff    	jne    801061f3 <trap+0x43>
801062db:	e9 30 ff ff ff       	jmp    80106210 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801062e0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801062e4:	0f 85 3e ff ff ff    	jne    80106228 <trap+0x78>
    yield();
801062ea:	e8 51 de ff ff       	call   80104140 <yield>
801062ef:	e9 34 ff ff ff       	jmp    80106228 <trap+0x78>
801062f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062f8:	8b 7b 38             	mov    0x38(%ebx),%edi
801062fb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801062ff:	e8 bc d7 ff ff       	call   80103ac0 <cpuid>
80106304:	57                   	push   %edi
80106305:	56                   	push   %esi
80106306:	50                   	push   %eax
80106307:	68 84 83 10 80       	push   $0x80108384
8010630c:	e8 df a3 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106311:	e8 fa c6 ff ff       	call   80102a10 <lapiceoi>
    break;
80106316:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106319:	e8 c2 d7 ff ff       	call   80103ae0 <myproc>
8010631e:	85 c0                	test   %eax,%eax
80106320:	0f 85 cd fe ff ff    	jne    801061f3 <trap+0x43>
80106326:	e9 e5 fe ff ff       	jmp    80106210 <trap+0x60>
8010632b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010632f:	90                   	nop
    if(myproc()->killed)
80106330:	e8 ab d7 ff ff       	call   80103ae0 <myproc>
80106335:	8b 70 24             	mov    0x24(%eax),%esi
80106338:	85 f6                	test   %esi,%esi
8010633a:	0f 85 c8 00 00 00    	jne    80106408 <trap+0x258>
    myproc()->tf = tf;
80106340:	e8 9b d7 ff ff       	call   80103ae0 <myproc>
80106345:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106348:	e8 73 ed ff ff       	call   801050c0 <syscall>
    if(myproc()->killed)
8010634d:	e8 8e d7 ff ff       	call   80103ae0 <myproc>
80106352:	8b 48 24             	mov    0x24(%eax),%ecx
80106355:	85 c9                	test   %ecx,%ecx
80106357:	0f 84 f1 fe ff ff    	je     8010624e <trap+0x9e>
}
8010635d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106360:	5b                   	pop    %ebx
80106361:	5e                   	pop    %esi
80106362:	5f                   	pop    %edi
80106363:	5d                   	pop    %ebp
      exit();
80106364:	e9 97 db ff ff       	jmp    80103f00 <exit>
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106370:	e8 3b 02 00 00       	call   801065b0 <uartintr>
    lapiceoi();
80106375:	e8 96 c6 ff ff       	call   80102a10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010637a:	e8 61 d7 ff ff       	call   80103ae0 <myproc>
8010637f:	85 c0                	test   %eax,%eax
80106381:	0f 85 6c fe ff ff    	jne    801061f3 <trap+0x43>
80106387:	e9 84 fe ff ff       	jmp    80106210 <trap+0x60>
8010638c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106390:	e8 3b c5 ff ff       	call   801028d0 <kbdintr>
    lapiceoi();
80106395:	e8 76 c6 ff ff       	call   80102a10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010639a:	e8 41 d7 ff ff       	call   80103ae0 <myproc>
8010639f:	85 c0                	test   %eax,%eax
801063a1:	0f 85 4c fe ff ff    	jne    801061f3 <trap+0x43>
801063a7:	e9 64 fe ff ff       	jmp    80106210 <trap+0x60>
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801063b0:	e8 0b d7 ff ff       	call   80103ac0 <cpuid>
801063b5:	85 c0                	test   %eax,%eax
801063b7:	0f 85 28 fe ff ff    	jne    801061e5 <trap+0x35>
      acquire(&tickslock);
801063bd:	83 ec 0c             	sub    $0xc,%esp
801063c0:	68 60 69 11 80       	push   $0x80116960
801063c5:	e8 86 e6 ff ff       	call   80104a50 <acquire>
      wakeup(&ticks);
801063ca:	c7 04 24 40 69 11 80 	movl   $0x80116940,(%esp)
      ticks++;
801063d1:	83 05 40 69 11 80 01 	addl   $0x1,0x80116940
      wakeup(&ticks);
801063d8:	e8 73 de ff ff       	call   80104250 <wakeup>
      release(&tickslock);
801063dd:	c7 04 24 60 69 11 80 	movl   $0x80116960,(%esp)
801063e4:	e8 07 e6 ff ff       	call   801049f0 <release>
801063e9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801063ec:	e9 f4 fd ff ff       	jmp    801061e5 <trap+0x35>
801063f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801063f8:	e8 03 db ff ff       	call   80103f00 <exit>
801063fd:	e9 0e fe ff ff       	jmp    80106210 <trap+0x60>
80106402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106408:	e8 f3 da ff ff       	call   80103f00 <exit>
8010640d:	e9 2e ff ff ff       	jmp    80106340 <trap+0x190>
80106412:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106415:	e8 a6 d6 ff ff       	call   80103ac0 <cpuid>
8010641a:	83 ec 0c             	sub    $0xc,%esp
8010641d:	56                   	push   %esi
8010641e:	57                   	push   %edi
8010641f:	50                   	push   %eax
80106420:	ff 73 30             	push   0x30(%ebx)
80106423:	68 a8 83 10 80       	push   $0x801083a8
80106428:	e8 c3 a2 ff ff       	call   801006f0 <cprintf>
      panic("trap");
8010642d:	83 c4 14             	add    $0x14,%esp
80106430:	68 7d 83 10 80       	push   $0x8010837d
80106435:	e8 96 9f ff ff       	call   801003d0 <panic>
8010643a:	66 90                	xchg   %ax,%ax
8010643c:	66 90                	xchg   %ax,%ax
8010643e:	66 90                	xchg   %ax,%ax

80106440 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106440:	a1 00 72 11 80       	mov    0x80117200,%eax
80106445:	85 c0                	test   %eax,%eax
80106447:	74 17                	je     80106460 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106449:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010644e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010644f:	a8 01                	test   $0x1,%al
80106451:	74 0d                	je     80106460 <uartgetc+0x20>
80106453:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106458:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106459:	0f b6 c0             	movzbl %al,%eax
8010645c:	c3                   	ret    
8010645d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	c3                   	ret    
80106466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010646d:	8d 76 00             	lea    0x0(%esi),%esi

80106470 <uartinit>:
{
80106470:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106471:	31 c9                	xor    %ecx,%ecx
80106473:	89 c8                	mov    %ecx,%eax
80106475:	89 e5                	mov    %esp,%ebp
80106477:	57                   	push   %edi
80106478:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010647d:	56                   	push   %esi
8010647e:	89 fa                	mov    %edi,%edx
80106480:	53                   	push   %ebx
80106481:	83 ec 1c             	sub    $0x1c,%esp
80106484:	ee                   	out    %al,(%dx)
80106485:	be fb 03 00 00       	mov    $0x3fb,%esi
8010648a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010648f:	89 f2                	mov    %esi,%edx
80106491:	ee                   	out    %al,(%dx)
80106492:	b8 0c 00 00 00       	mov    $0xc,%eax
80106497:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010649c:	ee                   	out    %al,(%dx)
8010649d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801064a2:	89 c8                	mov    %ecx,%eax
801064a4:	89 da                	mov    %ebx,%edx
801064a6:	ee                   	out    %al,(%dx)
801064a7:	b8 03 00 00 00       	mov    $0x3,%eax
801064ac:	89 f2                	mov    %esi,%edx
801064ae:	ee                   	out    %al,(%dx)
801064af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064b4:	89 c8                	mov    %ecx,%eax
801064b6:	ee                   	out    %al,(%dx)
801064b7:	b8 01 00 00 00       	mov    $0x1,%eax
801064bc:	89 da                	mov    %ebx,%edx
801064be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064c5:	3c ff                	cmp    $0xff,%al
801064c7:	74 78                	je     80106541 <uartinit+0xd1>
  uart = 1;
801064c9:	c7 05 00 72 11 80 01 	movl   $0x1,0x80117200
801064d0:	00 00 00 
801064d3:	89 fa                	mov    %edi,%edx
801064d5:	ec                   	in     (%dx),%al
801064d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064df:	bf a0 84 10 80       	mov    $0x801084a0,%edi
801064e4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801064e9:	6a 00                	push   $0x0
801064eb:	6a 04                	push   $0x4
801064ed:	e8 8e c0 ff ff       	call   80102580 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801064f2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801064f6:	83 c4 10             	add    $0x10,%esp
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106500:	a1 00 72 11 80       	mov    0x80117200,%eax
80106505:	bb 80 00 00 00       	mov    $0x80,%ebx
8010650a:	85 c0                	test   %eax,%eax
8010650c:	75 14                	jne    80106522 <uartinit+0xb2>
8010650e:	eb 23                	jmp    80106533 <uartinit+0xc3>
    microdelay(10);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	6a 0a                	push   $0xa
80106515:	e8 16 c5 ff ff       	call   80102a30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	83 eb 01             	sub    $0x1,%ebx
80106520:	74 07                	je     80106529 <uartinit+0xb9>
80106522:	89 f2                	mov    %esi,%edx
80106524:	ec                   	in     (%dx),%al
80106525:	a8 20                	test   $0x20,%al
80106527:	74 e7                	je     80106510 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106529:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010652d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106532:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106533:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106537:	83 c7 01             	add    $0x1,%edi
8010653a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010653d:	84 c0                	test   %al,%al
8010653f:	75 bf                	jne    80106500 <uartinit+0x90>
}
80106541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106544:	5b                   	pop    %ebx
80106545:	5e                   	pop    %esi
80106546:	5f                   	pop    %edi
80106547:	5d                   	pop    %ebp
80106548:	c3                   	ret    
80106549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106550 <uartputc>:
  if(!uart)
80106550:	a1 00 72 11 80       	mov    0x80117200,%eax
80106555:	85 c0                	test   %eax,%eax
80106557:	74 47                	je     801065a0 <uartputc+0x50>
{
80106559:	55                   	push   %ebp
8010655a:	89 e5                	mov    %esp,%ebp
8010655c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010655d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106562:	53                   	push   %ebx
80106563:	bb 80 00 00 00       	mov    $0x80,%ebx
80106568:	eb 18                	jmp    80106582 <uartputc+0x32>
8010656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	6a 0a                	push   $0xa
80106575:	e8 b6 c4 ff ff       	call   80102a30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	83 eb 01             	sub    $0x1,%ebx
80106580:	74 07                	je     80106589 <uartputc+0x39>
80106582:	89 f2                	mov    %esi,%edx
80106584:	ec                   	in     (%dx),%al
80106585:	a8 20                	test   $0x20,%al
80106587:	74 e7                	je     80106570 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106589:	8b 45 08             	mov    0x8(%ebp),%eax
8010658c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106591:	ee                   	out    %al,(%dx)
}
80106592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106595:	5b                   	pop    %ebx
80106596:	5e                   	pop    %esi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065a0:	c3                   	ret    
801065a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065af:	90                   	nop

801065b0 <uartintr>:

void
uartintr(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065b6:	68 40 64 10 80       	push   $0x80106440
801065bb:	e8 10 a3 ff ff       	call   801008d0 <consoleintr>
}
801065c0:	83 c4 10             	add    $0x10,%esp
801065c3:	c9                   	leave  
801065c4:	c3                   	ret    

801065c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $0
801065c7:	6a 00                	push   $0x0
  jmp alltraps
801065c9:	e9 0e fb ff ff       	jmp    801060dc <alltraps>

801065ce <vector1>:
.globl vector1
vector1:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $1
801065d0:	6a 01                	push   $0x1
  jmp alltraps
801065d2:	e9 05 fb ff ff       	jmp    801060dc <alltraps>

801065d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $2
801065d9:	6a 02                	push   $0x2
  jmp alltraps
801065db:	e9 fc fa ff ff       	jmp    801060dc <alltraps>

801065e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $3
801065e2:	6a 03                	push   $0x3
  jmp alltraps
801065e4:	e9 f3 fa ff ff       	jmp    801060dc <alltraps>

801065e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $4
801065eb:	6a 04                	push   $0x4
  jmp alltraps
801065ed:	e9 ea fa ff ff       	jmp    801060dc <alltraps>

801065f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $5
801065f4:	6a 05                	push   $0x5
  jmp alltraps
801065f6:	e9 e1 fa ff ff       	jmp    801060dc <alltraps>

801065fb <vector6>:
.globl vector6
vector6:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $6
801065fd:	6a 06                	push   $0x6
  jmp alltraps
801065ff:	e9 d8 fa ff ff       	jmp    801060dc <alltraps>

80106604 <vector7>:
.globl vector7
vector7:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $7
80106606:	6a 07                	push   $0x7
  jmp alltraps
80106608:	e9 cf fa ff ff       	jmp    801060dc <alltraps>

8010660d <vector8>:
.globl vector8
vector8:
  pushl $8
8010660d:	6a 08                	push   $0x8
  jmp alltraps
8010660f:	e9 c8 fa ff ff       	jmp    801060dc <alltraps>

80106614 <vector9>:
.globl vector9
vector9:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $9
80106616:	6a 09                	push   $0x9
  jmp alltraps
80106618:	e9 bf fa ff ff       	jmp    801060dc <alltraps>

8010661d <vector10>:
.globl vector10
vector10:
  pushl $10
8010661d:	6a 0a                	push   $0xa
  jmp alltraps
8010661f:	e9 b8 fa ff ff       	jmp    801060dc <alltraps>

80106624 <vector11>:
.globl vector11
vector11:
  pushl $11
80106624:	6a 0b                	push   $0xb
  jmp alltraps
80106626:	e9 b1 fa ff ff       	jmp    801060dc <alltraps>

8010662b <vector12>:
.globl vector12
vector12:
  pushl $12
8010662b:	6a 0c                	push   $0xc
  jmp alltraps
8010662d:	e9 aa fa ff ff       	jmp    801060dc <alltraps>

80106632 <vector13>:
.globl vector13
vector13:
  pushl $13
80106632:	6a 0d                	push   $0xd
  jmp alltraps
80106634:	e9 a3 fa ff ff       	jmp    801060dc <alltraps>

80106639 <vector14>:
.globl vector14
vector14:
  pushl $14
80106639:	6a 0e                	push   $0xe
  jmp alltraps
8010663b:	e9 9c fa ff ff       	jmp    801060dc <alltraps>

80106640 <vector15>:
.globl vector15
vector15:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $15
80106642:	6a 0f                	push   $0xf
  jmp alltraps
80106644:	e9 93 fa ff ff       	jmp    801060dc <alltraps>

80106649 <vector16>:
.globl vector16
vector16:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $16
8010664b:	6a 10                	push   $0x10
  jmp alltraps
8010664d:	e9 8a fa ff ff       	jmp    801060dc <alltraps>

80106652 <vector17>:
.globl vector17
vector17:
  pushl $17
80106652:	6a 11                	push   $0x11
  jmp alltraps
80106654:	e9 83 fa ff ff       	jmp    801060dc <alltraps>

80106659 <vector18>:
.globl vector18
vector18:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $18
8010665b:	6a 12                	push   $0x12
  jmp alltraps
8010665d:	e9 7a fa ff ff       	jmp    801060dc <alltraps>

80106662 <vector19>:
.globl vector19
vector19:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $19
80106664:	6a 13                	push   $0x13
  jmp alltraps
80106666:	e9 71 fa ff ff       	jmp    801060dc <alltraps>

8010666b <vector20>:
.globl vector20
vector20:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $20
8010666d:	6a 14                	push   $0x14
  jmp alltraps
8010666f:	e9 68 fa ff ff       	jmp    801060dc <alltraps>

80106674 <vector21>:
.globl vector21
vector21:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $21
80106676:	6a 15                	push   $0x15
  jmp alltraps
80106678:	e9 5f fa ff ff       	jmp    801060dc <alltraps>

8010667d <vector22>:
.globl vector22
vector22:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $22
8010667f:	6a 16                	push   $0x16
  jmp alltraps
80106681:	e9 56 fa ff ff       	jmp    801060dc <alltraps>

80106686 <vector23>:
.globl vector23
vector23:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $23
80106688:	6a 17                	push   $0x17
  jmp alltraps
8010668a:	e9 4d fa ff ff       	jmp    801060dc <alltraps>

8010668f <vector24>:
.globl vector24
vector24:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $24
80106691:	6a 18                	push   $0x18
  jmp alltraps
80106693:	e9 44 fa ff ff       	jmp    801060dc <alltraps>

80106698 <vector25>:
.globl vector25
vector25:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $25
8010669a:	6a 19                	push   $0x19
  jmp alltraps
8010669c:	e9 3b fa ff ff       	jmp    801060dc <alltraps>

801066a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $26
801066a3:	6a 1a                	push   $0x1a
  jmp alltraps
801066a5:	e9 32 fa ff ff       	jmp    801060dc <alltraps>

801066aa <vector27>:
.globl vector27
vector27:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $27
801066ac:	6a 1b                	push   $0x1b
  jmp alltraps
801066ae:	e9 29 fa ff ff       	jmp    801060dc <alltraps>

801066b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $28
801066b5:	6a 1c                	push   $0x1c
  jmp alltraps
801066b7:	e9 20 fa ff ff       	jmp    801060dc <alltraps>

801066bc <vector29>:
.globl vector29
vector29:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $29
801066be:	6a 1d                	push   $0x1d
  jmp alltraps
801066c0:	e9 17 fa ff ff       	jmp    801060dc <alltraps>

801066c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $30
801066c7:	6a 1e                	push   $0x1e
  jmp alltraps
801066c9:	e9 0e fa ff ff       	jmp    801060dc <alltraps>

801066ce <vector31>:
.globl vector31
vector31:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $31
801066d0:	6a 1f                	push   $0x1f
  jmp alltraps
801066d2:	e9 05 fa ff ff       	jmp    801060dc <alltraps>

801066d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $32
801066d9:	6a 20                	push   $0x20
  jmp alltraps
801066db:	e9 fc f9 ff ff       	jmp    801060dc <alltraps>

801066e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $33
801066e2:	6a 21                	push   $0x21
  jmp alltraps
801066e4:	e9 f3 f9 ff ff       	jmp    801060dc <alltraps>

801066e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $34
801066eb:	6a 22                	push   $0x22
  jmp alltraps
801066ed:	e9 ea f9 ff ff       	jmp    801060dc <alltraps>

801066f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $35
801066f4:	6a 23                	push   $0x23
  jmp alltraps
801066f6:	e9 e1 f9 ff ff       	jmp    801060dc <alltraps>

801066fb <vector36>:
.globl vector36
vector36:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $36
801066fd:	6a 24                	push   $0x24
  jmp alltraps
801066ff:	e9 d8 f9 ff ff       	jmp    801060dc <alltraps>

80106704 <vector37>:
.globl vector37
vector37:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $37
80106706:	6a 25                	push   $0x25
  jmp alltraps
80106708:	e9 cf f9 ff ff       	jmp    801060dc <alltraps>

8010670d <vector38>:
.globl vector38
vector38:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $38
8010670f:	6a 26                	push   $0x26
  jmp alltraps
80106711:	e9 c6 f9 ff ff       	jmp    801060dc <alltraps>

80106716 <vector39>:
.globl vector39
vector39:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $39
80106718:	6a 27                	push   $0x27
  jmp alltraps
8010671a:	e9 bd f9 ff ff       	jmp    801060dc <alltraps>

8010671f <vector40>:
.globl vector40
vector40:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $40
80106721:	6a 28                	push   $0x28
  jmp alltraps
80106723:	e9 b4 f9 ff ff       	jmp    801060dc <alltraps>

80106728 <vector41>:
.globl vector41
vector41:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $41
8010672a:	6a 29                	push   $0x29
  jmp alltraps
8010672c:	e9 ab f9 ff ff       	jmp    801060dc <alltraps>

80106731 <vector42>:
.globl vector42
vector42:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $42
80106733:	6a 2a                	push   $0x2a
  jmp alltraps
80106735:	e9 a2 f9 ff ff       	jmp    801060dc <alltraps>

8010673a <vector43>:
.globl vector43
vector43:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $43
8010673c:	6a 2b                	push   $0x2b
  jmp alltraps
8010673e:	e9 99 f9 ff ff       	jmp    801060dc <alltraps>

80106743 <vector44>:
.globl vector44
vector44:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $44
80106745:	6a 2c                	push   $0x2c
  jmp alltraps
80106747:	e9 90 f9 ff ff       	jmp    801060dc <alltraps>

8010674c <vector45>:
.globl vector45
vector45:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $45
8010674e:	6a 2d                	push   $0x2d
  jmp alltraps
80106750:	e9 87 f9 ff ff       	jmp    801060dc <alltraps>

80106755 <vector46>:
.globl vector46
vector46:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $46
80106757:	6a 2e                	push   $0x2e
  jmp alltraps
80106759:	e9 7e f9 ff ff       	jmp    801060dc <alltraps>

8010675e <vector47>:
.globl vector47
vector47:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $47
80106760:	6a 2f                	push   $0x2f
  jmp alltraps
80106762:	e9 75 f9 ff ff       	jmp    801060dc <alltraps>

80106767 <vector48>:
.globl vector48
vector48:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $48
80106769:	6a 30                	push   $0x30
  jmp alltraps
8010676b:	e9 6c f9 ff ff       	jmp    801060dc <alltraps>

80106770 <vector49>:
.globl vector49
vector49:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $49
80106772:	6a 31                	push   $0x31
  jmp alltraps
80106774:	e9 63 f9 ff ff       	jmp    801060dc <alltraps>

80106779 <vector50>:
.globl vector50
vector50:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $50
8010677b:	6a 32                	push   $0x32
  jmp alltraps
8010677d:	e9 5a f9 ff ff       	jmp    801060dc <alltraps>

80106782 <vector51>:
.globl vector51
vector51:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $51
80106784:	6a 33                	push   $0x33
  jmp alltraps
80106786:	e9 51 f9 ff ff       	jmp    801060dc <alltraps>

8010678b <vector52>:
.globl vector52
vector52:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $52
8010678d:	6a 34                	push   $0x34
  jmp alltraps
8010678f:	e9 48 f9 ff ff       	jmp    801060dc <alltraps>

80106794 <vector53>:
.globl vector53
vector53:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $53
80106796:	6a 35                	push   $0x35
  jmp alltraps
80106798:	e9 3f f9 ff ff       	jmp    801060dc <alltraps>

8010679d <vector54>:
.globl vector54
vector54:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $54
8010679f:	6a 36                	push   $0x36
  jmp alltraps
801067a1:	e9 36 f9 ff ff       	jmp    801060dc <alltraps>

801067a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $55
801067a8:	6a 37                	push   $0x37
  jmp alltraps
801067aa:	e9 2d f9 ff ff       	jmp    801060dc <alltraps>

801067af <vector56>:
.globl vector56
vector56:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $56
801067b1:	6a 38                	push   $0x38
  jmp alltraps
801067b3:	e9 24 f9 ff ff       	jmp    801060dc <alltraps>

801067b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $57
801067ba:	6a 39                	push   $0x39
  jmp alltraps
801067bc:	e9 1b f9 ff ff       	jmp    801060dc <alltraps>

801067c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $58
801067c3:	6a 3a                	push   $0x3a
  jmp alltraps
801067c5:	e9 12 f9 ff ff       	jmp    801060dc <alltraps>

801067ca <vector59>:
.globl vector59
vector59:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $59
801067cc:	6a 3b                	push   $0x3b
  jmp alltraps
801067ce:	e9 09 f9 ff ff       	jmp    801060dc <alltraps>

801067d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $60
801067d5:	6a 3c                	push   $0x3c
  jmp alltraps
801067d7:	e9 00 f9 ff ff       	jmp    801060dc <alltraps>

801067dc <vector61>:
.globl vector61
vector61:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $61
801067de:	6a 3d                	push   $0x3d
  jmp alltraps
801067e0:	e9 f7 f8 ff ff       	jmp    801060dc <alltraps>

801067e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $62
801067e7:	6a 3e                	push   $0x3e
  jmp alltraps
801067e9:	e9 ee f8 ff ff       	jmp    801060dc <alltraps>

801067ee <vector63>:
.globl vector63
vector63:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $63
801067f0:	6a 3f                	push   $0x3f
  jmp alltraps
801067f2:	e9 e5 f8 ff ff       	jmp    801060dc <alltraps>

801067f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $64
801067f9:	6a 40                	push   $0x40
  jmp alltraps
801067fb:	e9 dc f8 ff ff       	jmp    801060dc <alltraps>

80106800 <vector65>:
.globl vector65
vector65:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $65
80106802:	6a 41                	push   $0x41
  jmp alltraps
80106804:	e9 d3 f8 ff ff       	jmp    801060dc <alltraps>

80106809 <vector66>:
.globl vector66
vector66:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $66
8010680b:	6a 42                	push   $0x42
  jmp alltraps
8010680d:	e9 ca f8 ff ff       	jmp    801060dc <alltraps>

80106812 <vector67>:
.globl vector67
vector67:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $67
80106814:	6a 43                	push   $0x43
  jmp alltraps
80106816:	e9 c1 f8 ff ff       	jmp    801060dc <alltraps>

8010681b <vector68>:
.globl vector68
vector68:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $68
8010681d:	6a 44                	push   $0x44
  jmp alltraps
8010681f:	e9 b8 f8 ff ff       	jmp    801060dc <alltraps>

80106824 <vector69>:
.globl vector69
vector69:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $69
80106826:	6a 45                	push   $0x45
  jmp alltraps
80106828:	e9 af f8 ff ff       	jmp    801060dc <alltraps>

8010682d <vector70>:
.globl vector70
vector70:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $70
8010682f:	6a 46                	push   $0x46
  jmp alltraps
80106831:	e9 a6 f8 ff ff       	jmp    801060dc <alltraps>

80106836 <vector71>:
.globl vector71
vector71:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $71
80106838:	6a 47                	push   $0x47
  jmp alltraps
8010683a:	e9 9d f8 ff ff       	jmp    801060dc <alltraps>

8010683f <vector72>:
.globl vector72
vector72:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $72
80106841:	6a 48                	push   $0x48
  jmp alltraps
80106843:	e9 94 f8 ff ff       	jmp    801060dc <alltraps>

80106848 <vector73>:
.globl vector73
vector73:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $73
8010684a:	6a 49                	push   $0x49
  jmp alltraps
8010684c:	e9 8b f8 ff ff       	jmp    801060dc <alltraps>

80106851 <vector74>:
.globl vector74
vector74:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $74
80106853:	6a 4a                	push   $0x4a
  jmp alltraps
80106855:	e9 82 f8 ff ff       	jmp    801060dc <alltraps>

8010685a <vector75>:
.globl vector75
vector75:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $75
8010685c:	6a 4b                	push   $0x4b
  jmp alltraps
8010685e:	e9 79 f8 ff ff       	jmp    801060dc <alltraps>

80106863 <vector76>:
.globl vector76
vector76:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $76
80106865:	6a 4c                	push   $0x4c
  jmp alltraps
80106867:	e9 70 f8 ff ff       	jmp    801060dc <alltraps>

8010686c <vector77>:
.globl vector77
vector77:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $77
8010686e:	6a 4d                	push   $0x4d
  jmp alltraps
80106870:	e9 67 f8 ff ff       	jmp    801060dc <alltraps>

80106875 <vector78>:
.globl vector78
vector78:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $78
80106877:	6a 4e                	push   $0x4e
  jmp alltraps
80106879:	e9 5e f8 ff ff       	jmp    801060dc <alltraps>

8010687e <vector79>:
.globl vector79
vector79:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $79
80106880:	6a 4f                	push   $0x4f
  jmp alltraps
80106882:	e9 55 f8 ff ff       	jmp    801060dc <alltraps>

80106887 <vector80>:
.globl vector80
vector80:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $80
80106889:	6a 50                	push   $0x50
  jmp alltraps
8010688b:	e9 4c f8 ff ff       	jmp    801060dc <alltraps>

80106890 <vector81>:
.globl vector81
vector81:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $81
80106892:	6a 51                	push   $0x51
  jmp alltraps
80106894:	e9 43 f8 ff ff       	jmp    801060dc <alltraps>

80106899 <vector82>:
.globl vector82
vector82:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $82
8010689b:	6a 52                	push   $0x52
  jmp alltraps
8010689d:	e9 3a f8 ff ff       	jmp    801060dc <alltraps>

801068a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $83
801068a4:	6a 53                	push   $0x53
  jmp alltraps
801068a6:	e9 31 f8 ff ff       	jmp    801060dc <alltraps>

801068ab <vector84>:
.globl vector84
vector84:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $84
801068ad:	6a 54                	push   $0x54
  jmp alltraps
801068af:	e9 28 f8 ff ff       	jmp    801060dc <alltraps>

801068b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $85
801068b6:	6a 55                	push   $0x55
  jmp alltraps
801068b8:	e9 1f f8 ff ff       	jmp    801060dc <alltraps>

801068bd <vector86>:
.globl vector86
vector86:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $86
801068bf:	6a 56                	push   $0x56
  jmp alltraps
801068c1:	e9 16 f8 ff ff       	jmp    801060dc <alltraps>

801068c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $87
801068c8:	6a 57                	push   $0x57
  jmp alltraps
801068ca:	e9 0d f8 ff ff       	jmp    801060dc <alltraps>

801068cf <vector88>:
.globl vector88
vector88:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $88
801068d1:	6a 58                	push   $0x58
  jmp alltraps
801068d3:	e9 04 f8 ff ff       	jmp    801060dc <alltraps>

801068d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $89
801068da:	6a 59                	push   $0x59
  jmp alltraps
801068dc:	e9 fb f7 ff ff       	jmp    801060dc <alltraps>

801068e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $90
801068e3:	6a 5a                	push   $0x5a
  jmp alltraps
801068e5:	e9 f2 f7 ff ff       	jmp    801060dc <alltraps>

801068ea <vector91>:
.globl vector91
vector91:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $91
801068ec:	6a 5b                	push   $0x5b
  jmp alltraps
801068ee:	e9 e9 f7 ff ff       	jmp    801060dc <alltraps>

801068f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $92
801068f5:	6a 5c                	push   $0x5c
  jmp alltraps
801068f7:	e9 e0 f7 ff ff       	jmp    801060dc <alltraps>

801068fc <vector93>:
.globl vector93
vector93:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $93
801068fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106900:	e9 d7 f7 ff ff       	jmp    801060dc <alltraps>

80106905 <vector94>:
.globl vector94
vector94:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $94
80106907:	6a 5e                	push   $0x5e
  jmp alltraps
80106909:	e9 ce f7 ff ff       	jmp    801060dc <alltraps>

8010690e <vector95>:
.globl vector95
vector95:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $95
80106910:	6a 5f                	push   $0x5f
  jmp alltraps
80106912:	e9 c5 f7 ff ff       	jmp    801060dc <alltraps>

80106917 <vector96>:
.globl vector96
vector96:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $96
80106919:	6a 60                	push   $0x60
  jmp alltraps
8010691b:	e9 bc f7 ff ff       	jmp    801060dc <alltraps>

80106920 <vector97>:
.globl vector97
vector97:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $97
80106922:	6a 61                	push   $0x61
  jmp alltraps
80106924:	e9 b3 f7 ff ff       	jmp    801060dc <alltraps>

80106929 <vector98>:
.globl vector98
vector98:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $98
8010692b:	6a 62                	push   $0x62
  jmp alltraps
8010692d:	e9 aa f7 ff ff       	jmp    801060dc <alltraps>

80106932 <vector99>:
.globl vector99
vector99:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $99
80106934:	6a 63                	push   $0x63
  jmp alltraps
80106936:	e9 a1 f7 ff ff       	jmp    801060dc <alltraps>

8010693b <vector100>:
.globl vector100
vector100:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $100
8010693d:	6a 64                	push   $0x64
  jmp alltraps
8010693f:	e9 98 f7 ff ff       	jmp    801060dc <alltraps>

80106944 <vector101>:
.globl vector101
vector101:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $101
80106946:	6a 65                	push   $0x65
  jmp alltraps
80106948:	e9 8f f7 ff ff       	jmp    801060dc <alltraps>

8010694d <vector102>:
.globl vector102
vector102:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $102
8010694f:	6a 66                	push   $0x66
  jmp alltraps
80106951:	e9 86 f7 ff ff       	jmp    801060dc <alltraps>

80106956 <vector103>:
.globl vector103
vector103:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $103
80106958:	6a 67                	push   $0x67
  jmp alltraps
8010695a:	e9 7d f7 ff ff       	jmp    801060dc <alltraps>

8010695f <vector104>:
.globl vector104
vector104:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $104
80106961:	6a 68                	push   $0x68
  jmp alltraps
80106963:	e9 74 f7 ff ff       	jmp    801060dc <alltraps>

80106968 <vector105>:
.globl vector105
vector105:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $105
8010696a:	6a 69                	push   $0x69
  jmp alltraps
8010696c:	e9 6b f7 ff ff       	jmp    801060dc <alltraps>

80106971 <vector106>:
.globl vector106
vector106:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $106
80106973:	6a 6a                	push   $0x6a
  jmp alltraps
80106975:	e9 62 f7 ff ff       	jmp    801060dc <alltraps>

8010697a <vector107>:
.globl vector107
vector107:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $107
8010697c:	6a 6b                	push   $0x6b
  jmp alltraps
8010697e:	e9 59 f7 ff ff       	jmp    801060dc <alltraps>

80106983 <vector108>:
.globl vector108
vector108:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $108
80106985:	6a 6c                	push   $0x6c
  jmp alltraps
80106987:	e9 50 f7 ff ff       	jmp    801060dc <alltraps>

8010698c <vector109>:
.globl vector109
vector109:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $109
8010698e:	6a 6d                	push   $0x6d
  jmp alltraps
80106990:	e9 47 f7 ff ff       	jmp    801060dc <alltraps>

80106995 <vector110>:
.globl vector110
vector110:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $110
80106997:	6a 6e                	push   $0x6e
  jmp alltraps
80106999:	e9 3e f7 ff ff       	jmp    801060dc <alltraps>

8010699e <vector111>:
.globl vector111
vector111:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $111
801069a0:	6a 6f                	push   $0x6f
  jmp alltraps
801069a2:	e9 35 f7 ff ff       	jmp    801060dc <alltraps>

801069a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $112
801069a9:	6a 70                	push   $0x70
  jmp alltraps
801069ab:	e9 2c f7 ff ff       	jmp    801060dc <alltraps>

801069b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $113
801069b2:	6a 71                	push   $0x71
  jmp alltraps
801069b4:	e9 23 f7 ff ff       	jmp    801060dc <alltraps>

801069b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $114
801069bb:	6a 72                	push   $0x72
  jmp alltraps
801069bd:	e9 1a f7 ff ff       	jmp    801060dc <alltraps>

801069c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $115
801069c4:	6a 73                	push   $0x73
  jmp alltraps
801069c6:	e9 11 f7 ff ff       	jmp    801060dc <alltraps>

801069cb <vector116>:
.globl vector116
vector116:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $116
801069cd:	6a 74                	push   $0x74
  jmp alltraps
801069cf:	e9 08 f7 ff ff       	jmp    801060dc <alltraps>

801069d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $117
801069d6:	6a 75                	push   $0x75
  jmp alltraps
801069d8:	e9 ff f6 ff ff       	jmp    801060dc <alltraps>

801069dd <vector118>:
.globl vector118
vector118:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $118
801069df:	6a 76                	push   $0x76
  jmp alltraps
801069e1:	e9 f6 f6 ff ff       	jmp    801060dc <alltraps>

801069e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $119
801069e8:	6a 77                	push   $0x77
  jmp alltraps
801069ea:	e9 ed f6 ff ff       	jmp    801060dc <alltraps>

801069ef <vector120>:
.globl vector120
vector120:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $120
801069f1:	6a 78                	push   $0x78
  jmp alltraps
801069f3:	e9 e4 f6 ff ff       	jmp    801060dc <alltraps>

801069f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $121
801069fa:	6a 79                	push   $0x79
  jmp alltraps
801069fc:	e9 db f6 ff ff       	jmp    801060dc <alltraps>

80106a01 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $122
80106a03:	6a 7a                	push   $0x7a
  jmp alltraps
80106a05:	e9 d2 f6 ff ff       	jmp    801060dc <alltraps>

80106a0a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $123
80106a0c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a0e:	e9 c9 f6 ff ff       	jmp    801060dc <alltraps>

80106a13 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $124
80106a15:	6a 7c                	push   $0x7c
  jmp alltraps
80106a17:	e9 c0 f6 ff ff       	jmp    801060dc <alltraps>

80106a1c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $125
80106a1e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a20:	e9 b7 f6 ff ff       	jmp    801060dc <alltraps>

80106a25 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $126
80106a27:	6a 7e                	push   $0x7e
  jmp alltraps
80106a29:	e9 ae f6 ff ff       	jmp    801060dc <alltraps>

80106a2e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $127
80106a30:	6a 7f                	push   $0x7f
  jmp alltraps
80106a32:	e9 a5 f6 ff ff       	jmp    801060dc <alltraps>

80106a37 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $128
80106a39:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a3e:	e9 99 f6 ff ff       	jmp    801060dc <alltraps>

80106a43 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $129
80106a45:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a4a:	e9 8d f6 ff ff       	jmp    801060dc <alltraps>

80106a4f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $130
80106a51:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a56:	e9 81 f6 ff ff       	jmp    801060dc <alltraps>

80106a5b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $131
80106a5d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a62:	e9 75 f6 ff ff       	jmp    801060dc <alltraps>

80106a67 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $132
80106a69:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a6e:	e9 69 f6 ff ff       	jmp    801060dc <alltraps>

80106a73 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $133
80106a75:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a7a:	e9 5d f6 ff ff       	jmp    801060dc <alltraps>

80106a7f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $134
80106a81:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a86:	e9 51 f6 ff ff       	jmp    801060dc <alltraps>

80106a8b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $135
80106a8d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a92:	e9 45 f6 ff ff       	jmp    801060dc <alltraps>

80106a97 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $136
80106a99:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a9e:	e9 39 f6 ff ff       	jmp    801060dc <alltraps>

80106aa3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $137
80106aa5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aaa:	e9 2d f6 ff ff       	jmp    801060dc <alltraps>

80106aaf <vector138>:
.globl vector138
vector138:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $138
80106ab1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ab6:	e9 21 f6 ff ff       	jmp    801060dc <alltraps>

80106abb <vector139>:
.globl vector139
vector139:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $139
80106abd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ac2:	e9 15 f6 ff ff       	jmp    801060dc <alltraps>

80106ac7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $140
80106ac9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ace:	e9 09 f6 ff ff       	jmp    801060dc <alltraps>

80106ad3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $141
80106ad5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ada:	e9 fd f5 ff ff       	jmp    801060dc <alltraps>

80106adf <vector142>:
.globl vector142
vector142:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $142
80106ae1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ae6:	e9 f1 f5 ff ff       	jmp    801060dc <alltraps>

80106aeb <vector143>:
.globl vector143
vector143:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $143
80106aed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106af2:	e9 e5 f5 ff ff       	jmp    801060dc <alltraps>

80106af7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $144
80106af9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106afe:	e9 d9 f5 ff ff       	jmp    801060dc <alltraps>

80106b03 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $145
80106b05:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b0a:	e9 cd f5 ff ff       	jmp    801060dc <alltraps>

80106b0f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $146
80106b11:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b16:	e9 c1 f5 ff ff       	jmp    801060dc <alltraps>

80106b1b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $147
80106b1d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b22:	e9 b5 f5 ff ff       	jmp    801060dc <alltraps>

80106b27 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $148
80106b29:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b2e:	e9 a9 f5 ff ff       	jmp    801060dc <alltraps>

80106b33 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $149
80106b35:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b3a:	e9 9d f5 ff ff       	jmp    801060dc <alltraps>

80106b3f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $150
80106b41:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b46:	e9 91 f5 ff ff       	jmp    801060dc <alltraps>

80106b4b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $151
80106b4d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b52:	e9 85 f5 ff ff       	jmp    801060dc <alltraps>

80106b57 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $152
80106b59:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b5e:	e9 79 f5 ff ff       	jmp    801060dc <alltraps>

80106b63 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $153
80106b65:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b6a:	e9 6d f5 ff ff       	jmp    801060dc <alltraps>

80106b6f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $154
80106b71:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b76:	e9 61 f5 ff ff       	jmp    801060dc <alltraps>

80106b7b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $155
80106b7d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b82:	e9 55 f5 ff ff       	jmp    801060dc <alltraps>

80106b87 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $156
80106b89:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b8e:	e9 49 f5 ff ff       	jmp    801060dc <alltraps>

80106b93 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $157
80106b95:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b9a:	e9 3d f5 ff ff       	jmp    801060dc <alltraps>

80106b9f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $158
80106ba1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ba6:	e9 31 f5 ff ff       	jmp    801060dc <alltraps>

80106bab <vector159>:
.globl vector159
vector159:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $159
80106bad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bb2:	e9 25 f5 ff ff       	jmp    801060dc <alltraps>

80106bb7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $160
80106bb9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bbe:	e9 19 f5 ff ff       	jmp    801060dc <alltraps>

80106bc3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $161
80106bc5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bca:	e9 0d f5 ff ff       	jmp    801060dc <alltraps>

80106bcf <vector162>:
.globl vector162
vector162:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $162
80106bd1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bd6:	e9 01 f5 ff ff       	jmp    801060dc <alltraps>

80106bdb <vector163>:
.globl vector163
vector163:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $163
80106bdd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106be2:	e9 f5 f4 ff ff       	jmp    801060dc <alltraps>

80106be7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $164
80106be9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bee:	e9 e9 f4 ff ff       	jmp    801060dc <alltraps>

80106bf3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $165
80106bf5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bfa:	e9 dd f4 ff ff       	jmp    801060dc <alltraps>

80106bff <vector166>:
.globl vector166
vector166:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $166
80106c01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c06:	e9 d1 f4 ff ff       	jmp    801060dc <alltraps>

80106c0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $167
80106c0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c12:	e9 c5 f4 ff ff       	jmp    801060dc <alltraps>

80106c17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $168
80106c19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c1e:	e9 b9 f4 ff ff       	jmp    801060dc <alltraps>

80106c23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $169
80106c25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c2a:	e9 ad f4 ff ff       	jmp    801060dc <alltraps>

80106c2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $170
80106c31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c36:	e9 a1 f4 ff ff       	jmp    801060dc <alltraps>

80106c3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $171
80106c3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c42:	e9 95 f4 ff ff       	jmp    801060dc <alltraps>

80106c47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $172
80106c49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c4e:	e9 89 f4 ff ff       	jmp    801060dc <alltraps>

80106c53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $173
80106c55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c5a:	e9 7d f4 ff ff       	jmp    801060dc <alltraps>

80106c5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $174
80106c61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c66:	e9 71 f4 ff ff       	jmp    801060dc <alltraps>

80106c6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $175
80106c6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c72:	e9 65 f4 ff ff       	jmp    801060dc <alltraps>

80106c77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $176
80106c79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c7e:	e9 59 f4 ff ff       	jmp    801060dc <alltraps>

80106c83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $177
80106c85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c8a:	e9 4d f4 ff ff       	jmp    801060dc <alltraps>

80106c8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $178
80106c91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c96:	e9 41 f4 ff ff       	jmp    801060dc <alltraps>

80106c9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $179
80106c9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ca2:	e9 35 f4 ff ff       	jmp    801060dc <alltraps>

80106ca7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $180
80106ca9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cae:	e9 29 f4 ff ff       	jmp    801060dc <alltraps>

80106cb3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $181
80106cb5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cba:	e9 1d f4 ff ff       	jmp    801060dc <alltraps>

80106cbf <vector182>:
.globl vector182
vector182:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $182
80106cc1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cc6:	e9 11 f4 ff ff       	jmp    801060dc <alltraps>

80106ccb <vector183>:
.globl vector183
vector183:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $183
80106ccd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cd2:	e9 05 f4 ff ff       	jmp    801060dc <alltraps>

80106cd7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $184
80106cd9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cde:	e9 f9 f3 ff ff       	jmp    801060dc <alltraps>

80106ce3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $185
80106ce5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cea:	e9 ed f3 ff ff       	jmp    801060dc <alltraps>

80106cef <vector186>:
.globl vector186
vector186:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $186
80106cf1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cf6:	e9 e1 f3 ff ff       	jmp    801060dc <alltraps>

80106cfb <vector187>:
.globl vector187
vector187:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $187
80106cfd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d02:	e9 d5 f3 ff ff       	jmp    801060dc <alltraps>

80106d07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $188
80106d09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d0e:	e9 c9 f3 ff ff       	jmp    801060dc <alltraps>

80106d13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $189
80106d15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d1a:	e9 bd f3 ff ff       	jmp    801060dc <alltraps>

80106d1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $190
80106d21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d26:	e9 b1 f3 ff ff       	jmp    801060dc <alltraps>

80106d2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $191
80106d2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d32:	e9 a5 f3 ff ff       	jmp    801060dc <alltraps>

80106d37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $192
80106d39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d3e:	e9 99 f3 ff ff       	jmp    801060dc <alltraps>

80106d43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $193
80106d45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d4a:	e9 8d f3 ff ff       	jmp    801060dc <alltraps>

80106d4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $194
80106d51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d56:	e9 81 f3 ff ff       	jmp    801060dc <alltraps>

80106d5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $195
80106d5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d62:	e9 75 f3 ff ff       	jmp    801060dc <alltraps>

80106d67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $196
80106d69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d6e:	e9 69 f3 ff ff       	jmp    801060dc <alltraps>

80106d73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $197
80106d75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d7a:	e9 5d f3 ff ff       	jmp    801060dc <alltraps>

80106d7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $198
80106d81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d86:	e9 51 f3 ff ff       	jmp    801060dc <alltraps>

80106d8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $199
80106d8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d92:	e9 45 f3 ff ff       	jmp    801060dc <alltraps>

80106d97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $200
80106d99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d9e:	e9 39 f3 ff ff       	jmp    801060dc <alltraps>

80106da3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $201
80106da5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106daa:	e9 2d f3 ff ff       	jmp    801060dc <alltraps>

80106daf <vector202>:
.globl vector202
vector202:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $202
80106db1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106db6:	e9 21 f3 ff ff       	jmp    801060dc <alltraps>

80106dbb <vector203>:
.globl vector203
vector203:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $203
80106dbd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dc2:	e9 15 f3 ff ff       	jmp    801060dc <alltraps>

80106dc7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $204
80106dc9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dce:	e9 09 f3 ff ff       	jmp    801060dc <alltraps>

80106dd3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $205
80106dd5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dda:	e9 fd f2 ff ff       	jmp    801060dc <alltraps>

80106ddf <vector206>:
.globl vector206
vector206:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $206
80106de1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106de6:	e9 f1 f2 ff ff       	jmp    801060dc <alltraps>

80106deb <vector207>:
.globl vector207
vector207:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $207
80106ded:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106df2:	e9 e5 f2 ff ff       	jmp    801060dc <alltraps>

80106df7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $208
80106df9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dfe:	e9 d9 f2 ff ff       	jmp    801060dc <alltraps>

80106e03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $209
80106e05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e0a:	e9 cd f2 ff ff       	jmp    801060dc <alltraps>

80106e0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $210
80106e11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e16:	e9 c1 f2 ff ff       	jmp    801060dc <alltraps>

80106e1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $211
80106e1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e22:	e9 b5 f2 ff ff       	jmp    801060dc <alltraps>

80106e27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $212
80106e29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e2e:	e9 a9 f2 ff ff       	jmp    801060dc <alltraps>

80106e33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $213
80106e35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e3a:	e9 9d f2 ff ff       	jmp    801060dc <alltraps>

80106e3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $214
80106e41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e46:	e9 91 f2 ff ff       	jmp    801060dc <alltraps>

80106e4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $215
80106e4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e52:	e9 85 f2 ff ff       	jmp    801060dc <alltraps>

80106e57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $216
80106e59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e5e:	e9 79 f2 ff ff       	jmp    801060dc <alltraps>

80106e63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $217
80106e65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e6a:	e9 6d f2 ff ff       	jmp    801060dc <alltraps>

80106e6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $218
80106e71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e76:	e9 61 f2 ff ff       	jmp    801060dc <alltraps>

80106e7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $219
80106e7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e82:	e9 55 f2 ff ff       	jmp    801060dc <alltraps>

80106e87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $220
80106e89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e8e:	e9 49 f2 ff ff       	jmp    801060dc <alltraps>

80106e93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $221
80106e95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e9a:	e9 3d f2 ff ff       	jmp    801060dc <alltraps>

80106e9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $222
80106ea1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ea6:	e9 31 f2 ff ff       	jmp    801060dc <alltraps>

80106eab <vector223>:
.globl vector223
vector223:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $223
80106ead:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106eb2:	e9 25 f2 ff ff       	jmp    801060dc <alltraps>

80106eb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $224
80106eb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ebe:	e9 19 f2 ff ff       	jmp    801060dc <alltraps>

80106ec3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $225
80106ec5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eca:	e9 0d f2 ff ff       	jmp    801060dc <alltraps>

80106ecf <vector226>:
.globl vector226
vector226:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $226
80106ed1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ed6:	e9 01 f2 ff ff       	jmp    801060dc <alltraps>

80106edb <vector227>:
.globl vector227
vector227:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $227
80106edd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ee2:	e9 f5 f1 ff ff       	jmp    801060dc <alltraps>

80106ee7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $228
80106ee9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106eee:	e9 e9 f1 ff ff       	jmp    801060dc <alltraps>

80106ef3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $229
80106ef5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106efa:	e9 dd f1 ff ff       	jmp    801060dc <alltraps>

80106eff <vector230>:
.globl vector230
vector230:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $230
80106f01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f06:	e9 d1 f1 ff ff       	jmp    801060dc <alltraps>

80106f0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $231
80106f0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f12:	e9 c5 f1 ff ff       	jmp    801060dc <alltraps>

80106f17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $232
80106f19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f1e:	e9 b9 f1 ff ff       	jmp    801060dc <alltraps>

80106f23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $233
80106f25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f2a:	e9 ad f1 ff ff       	jmp    801060dc <alltraps>

80106f2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $234
80106f31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f36:	e9 a1 f1 ff ff       	jmp    801060dc <alltraps>

80106f3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $235
80106f3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f42:	e9 95 f1 ff ff       	jmp    801060dc <alltraps>

80106f47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $236
80106f49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f4e:	e9 89 f1 ff ff       	jmp    801060dc <alltraps>

80106f53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $237
80106f55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f5a:	e9 7d f1 ff ff       	jmp    801060dc <alltraps>

80106f5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $238
80106f61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f66:	e9 71 f1 ff ff       	jmp    801060dc <alltraps>

80106f6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $239
80106f6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f72:	e9 65 f1 ff ff       	jmp    801060dc <alltraps>

80106f77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $240
80106f79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f7e:	e9 59 f1 ff ff       	jmp    801060dc <alltraps>

80106f83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $241
80106f85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f8a:	e9 4d f1 ff ff       	jmp    801060dc <alltraps>

80106f8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $242
80106f91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f96:	e9 41 f1 ff ff       	jmp    801060dc <alltraps>

80106f9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $243
80106f9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fa2:	e9 35 f1 ff ff       	jmp    801060dc <alltraps>

80106fa7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $244
80106fa9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fae:	e9 29 f1 ff ff       	jmp    801060dc <alltraps>

80106fb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $245
80106fb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fba:	e9 1d f1 ff ff       	jmp    801060dc <alltraps>

80106fbf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $246
80106fc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fc6:	e9 11 f1 ff ff       	jmp    801060dc <alltraps>

80106fcb <vector247>:
.globl vector247
vector247:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $247
80106fcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fd2:	e9 05 f1 ff ff       	jmp    801060dc <alltraps>

80106fd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $248
80106fd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fde:	e9 f9 f0 ff ff       	jmp    801060dc <alltraps>

80106fe3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $249
80106fe5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fea:	e9 ed f0 ff ff       	jmp    801060dc <alltraps>

80106fef <vector250>:
.globl vector250
vector250:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $250
80106ff1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ff6:	e9 e1 f0 ff ff       	jmp    801060dc <alltraps>

80106ffb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $251
80106ffd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107002:	e9 d5 f0 ff ff       	jmp    801060dc <alltraps>

80107007 <vector252>:
.globl vector252
vector252:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $252
80107009:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010700e:	e9 c9 f0 ff ff       	jmp    801060dc <alltraps>

80107013 <vector253>:
.globl vector253
vector253:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $253
80107015:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010701a:	e9 bd f0 ff ff       	jmp    801060dc <alltraps>

8010701f <vector254>:
.globl vector254
vector254:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $254
80107021:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107026:	e9 b1 f0 ff ff       	jmp    801060dc <alltraps>

8010702b <vector255>:
.globl vector255
vector255:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $255
8010702d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107032:	e9 a5 f0 ff ff       	jmp    801060dc <alltraps>
80107037:	66 90                	xchg   %ax,%ax
80107039:	66 90                	xchg   %ax,%ax
8010703b:	66 90                	xchg   %ax,%ax
8010703d:	66 90                	xchg   %ax,%ax
8010703f:	90                   	nop

80107040 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107046:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010704c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107052:	83 ec 1c             	sub    $0x1c,%esp
80107055:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107058:	39 d3                	cmp    %edx,%ebx
8010705a:	73 49                	jae    801070a5 <deallocuvm.part.0+0x65>
8010705c:	89 c7                	mov    %eax,%edi
8010705e:	eb 0c                	jmp    8010706c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107060:	83 c0 01             	add    $0x1,%eax
80107063:	c1 e0 16             	shl    $0x16,%eax
80107066:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107068:	39 da                	cmp    %ebx,%edx
8010706a:	76 39                	jbe    801070a5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010706c:	89 d8                	mov    %ebx,%eax
8010706e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107071:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107074:	f6 c1 01             	test   $0x1,%cl
80107077:	74 e7                	je     80107060 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107079:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010707b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107081:	c1 ee 0a             	shr    $0xa,%esi
80107084:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010708a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107091:	85 f6                	test   %esi,%esi
80107093:	74 cb                	je     80107060 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107095:	8b 06                	mov    (%esi),%eax
80107097:	a8 01                	test   $0x1,%al
80107099:	75 15                	jne    801070b0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010709b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070a1:	39 da                	cmp    %ebx,%edx
801070a3:	77 c7                	ja     8010706c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801070a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ab:	5b                   	pop    %ebx
801070ac:	5e                   	pop    %esi
801070ad:	5f                   	pop    %edi
801070ae:	5d                   	pop    %ebp
801070af:	c3                   	ret    
      if(pa == 0)
801070b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070b5:	74 25                	je     801070dc <deallocuvm.part.0+0x9c>
      kfree(v);
801070b7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801070ba:	05 00 00 00 80       	add    $0x80000000,%eax
801070bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801070c8:	50                   	push   %eax
801070c9:	e8 f2 b4 ff ff       	call   801025c0 <kfree>
      *pte = 0;
801070ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801070d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070d7:	83 c4 10             	add    $0x10,%esp
801070da:	eb 8c                	jmp    80107068 <deallocuvm.part.0+0x28>
        panic("kfree");
801070dc:	83 ec 0c             	sub    $0xc,%esp
801070df:	68 66 7d 10 80       	push   $0x80107d66
801070e4:	e8 e7 92 ff ff       	call   801003d0 <panic>
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070f0 <mappages>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070f6:	89 d3                	mov    %edx,%ebx
801070f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801070fe:	83 ec 1c             	sub    $0x1c,%esp
80107101:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107104:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010710d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107110:	8b 45 08             	mov    0x8(%ebp),%eax
80107113:	29 d8                	sub    %ebx,%eax
80107115:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107118:	eb 3d                	jmp    80107157 <mappages+0x67>
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107120:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107127:	c1 ea 0a             	shr    $0xa,%edx
8010712a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107130:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107137:	85 c0                	test   %eax,%eax
80107139:	74 75                	je     801071b0 <mappages+0xc0>
    if(*pte & PTE_P)
8010713b:	f6 00 01             	testb  $0x1,(%eax)
8010713e:	0f 85 86 00 00 00    	jne    801071ca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107144:	0b 75 0c             	or     0xc(%ebp),%esi
80107147:	83 ce 01             	or     $0x1,%esi
8010714a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010714c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010714f:	74 6f                	je     801071c0 <mappages+0xd0>
    a += PGSIZE;
80107151:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010715a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010715d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107160:	89 d8                	mov    %ebx,%eax
80107162:	c1 e8 16             	shr    $0x16,%eax
80107165:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107168:	8b 07                	mov    (%edi),%eax
8010716a:	a8 01                	test   $0x1,%al
8010716c:	75 b2                	jne    80107120 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010716e:	e8 0d b6 ff ff       	call   80102780 <kalloc>
80107173:	85 c0                	test   %eax,%eax
80107175:	74 39                	je     801071b0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107177:	83 ec 04             	sub    $0x4,%esp
8010717a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010717d:	68 00 10 00 00       	push   $0x1000
80107182:	6a 00                	push   $0x0
80107184:	50                   	push   %eax
80107185:	e8 36 db ff ff       	call   80104cc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010718a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010718d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107190:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107196:	83 c8 07             	or     $0x7,%eax
80107199:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010719b:	89 d8                	mov    %ebx,%eax
8010719d:	c1 e8 0a             	shr    $0xa,%eax
801071a0:	25 fc 0f 00 00       	and    $0xffc,%eax
801071a5:	01 d0                	add    %edx,%eax
801071a7:	eb 92                	jmp    8010713b <mappages+0x4b>
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071b8:	5b                   	pop    %ebx
801071b9:	5e                   	pop    %esi
801071ba:	5f                   	pop    %edi
801071bb:	5d                   	pop    %ebp
801071bc:	c3                   	ret    
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
801071c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071c3:	31 c0                	xor    %eax,%eax
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
      panic("remap");
801071ca:	83 ec 0c             	sub    $0xc,%esp
801071cd:	68 a8 84 10 80       	push   $0x801084a8
801071d2:	e8 f9 91 ff ff       	call   801003d0 <panic>
801071d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071de:	66 90                	xchg   %ax,%ax

801071e0 <seginit>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071e6:	e8 d5 c8 ff ff       	call   80103ac0 <cpuid>
  pd[0] = size-1;
801071eb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071fa:	c7 80 98 43 11 80 ff 	movl   $0xffff,-0x7feebc68(%eax)
80107201:	ff 00 00 
80107204:	c7 80 9c 43 11 80 00 	movl   $0xcf9a00,-0x7feebc64(%eax)
8010720b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010720e:	c7 80 a0 43 11 80 ff 	movl   $0xffff,-0x7feebc60(%eax)
80107215:	ff 00 00 
80107218:	c7 80 a4 43 11 80 00 	movl   $0xcf9200,-0x7feebc5c(%eax)
8010721f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107222:	c7 80 a8 43 11 80 ff 	movl   $0xffff,-0x7feebc58(%eax)
80107229:	ff 00 00 
8010722c:	c7 80 ac 43 11 80 00 	movl   $0xcffa00,-0x7feebc54(%eax)
80107233:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107236:	c7 80 b0 43 11 80 ff 	movl   $0xffff,-0x7feebc50(%eax)
8010723d:	ff 00 00 
80107240:	c7 80 b4 43 11 80 00 	movl   $0xcff200,-0x7feebc4c(%eax)
80107247:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010724a:	05 90 43 11 80       	add    $0x80114390,%eax
  pd[1] = (uint)p;
8010724f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107253:	c1 e8 10             	shr    $0x10,%eax
80107256:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010725a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010725d:	0f 01 10             	lgdtl  (%eax)
}
80107260:	c9                   	leave  
80107261:	c3                   	ret    
80107262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107270 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107270:	a1 04 72 11 80       	mov    0x80117204,%eax
80107275:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010727a:	0f 22 d8             	mov    %eax,%cr3
}
8010727d:	c3                   	ret    
8010727e:	66 90                	xchg   %ax,%ax

80107280 <switchuvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 1c             	sub    $0x1c,%esp
80107289:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010728c:	85 f6                	test   %esi,%esi
8010728e:	0f 84 cb 00 00 00    	je     8010735f <switchuvm+0xdf>
  if(p->kstack == 0)
80107294:	8b 46 08             	mov    0x8(%esi),%eax
80107297:	85 c0                	test   %eax,%eax
80107299:	0f 84 da 00 00 00    	je     80107379 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010729f:	8b 46 04             	mov    0x4(%esi),%eax
801072a2:	85 c0                	test   %eax,%eax
801072a4:	0f 84 c2 00 00 00    	je     8010736c <switchuvm+0xec>
  pushcli();
801072aa:	e8 51 d6 ff ff       	call   80104900 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072af:	e8 ac c7 ff ff       	call   80103a60 <mycpu>
801072b4:	89 c3                	mov    %eax,%ebx
801072b6:	e8 a5 c7 ff ff       	call   80103a60 <mycpu>
801072bb:	89 c7                	mov    %eax,%edi
801072bd:	e8 9e c7 ff ff       	call   80103a60 <mycpu>
801072c2:	83 c7 08             	add    $0x8,%edi
801072c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072c8:	e8 93 c7 ff ff       	call   80103a60 <mycpu>
801072cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072d0:	ba 67 00 00 00       	mov    $0x67,%edx
801072d5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072dc:	83 c0 08             	add    $0x8,%eax
801072df:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072e6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072eb:	83 c1 08             	add    $0x8,%ecx
801072ee:	c1 e8 18             	shr    $0x18,%eax
801072f1:	c1 e9 10             	shr    $0x10,%ecx
801072f4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072fa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107300:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107305:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010730c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107311:	e8 4a c7 ff ff       	call   80103a60 <mycpu>
80107316:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010731d:	e8 3e c7 ff ff       	call   80103a60 <mycpu>
80107322:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107326:	8b 5e 08             	mov    0x8(%esi),%ebx
80107329:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010732f:	e8 2c c7 ff ff       	call   80103a60 <mycpu>
80107334:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107337:	e8 24 c7 ff ff       	call   80103a60 <mycpu>
8010733c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107340:	b8 28 00 00 00       	mov    $0x28,%eax
80107345:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107348:	8b 46 04             	mov    0x4(%esi),%eax
8010734b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107350:	0f 22 d8             	mov    %eax,%cr3
}
80107353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107356:	5b                   	pop    %ebx
80107357:	5e                   	pop    %esi
80107358:	5f                   	pop    %edi
80107359:	5d                   	pop    %ebp
  popcli();
8010735a:	e9 f1 d5 ff ff       	jmp    80104950 <popcli>
    panic("switchuvm: no process");
8010735f:	83 ec 0c             	sub    $0xc,%esp
80107362:	68 ae 84 10 80       	push   $0x801084ae
80107367:	e8 64 90 ff ff       	call   801003d0 <panic>
    panic("switchuvm: no pgdir");
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	68 d9 84 10 80       	push   $0x801084d9
80107374:	e8 57 90 ff ff       	call   801003d0 <panic>
    panic("switchuvm: no kstack");
80107379:	83 ec 0c             	sub    $0xc,%esp
8010737c:	68 c4 84 10 80       	push   $0x801084c4
80107381:	e8 4a 90 ff ff       	call   801003d0 <panic>
80107386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738d:	8d 76 00             	lea    0x0(%esi),%esi

80107390 <inituvm>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
80107399:	8b 45 0c             	mov    0xc(%ebp),%eax
8010739c:	8b 75 10             	mov    0x10(%ebp),%esi
8010739f:	8b 7d 08             	mov    0x8(%ebp),%edi
801073a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073a5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073ab:	77 4b                	ja     801073f8 <inituvm+0x68>
  mem = kalloc();
801073ad:	e8 ce b3 ff ff       	call   80102780 <kalloc>
  memset(mem, 0, PGSIZE);
801073b2:	83 ec 04             	sub    $0x4,%esp
801073b5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073ba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073bc:	6a 00                	push   $0x0
801073be:	50                   	push   %eax
801073bf:	e8 fc d8 ff ff       	call   80104cc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073c4:	58                   	pop    %eax
801073c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073cb:	5a                   	pop    %edx
801073cc:	6a 06                	push   $0x6
801073ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073d3:	31 d2                	xor    %edx,%edx
801073d5:	50                   	push   %eax
801073d6:	89 f8                	mov    %edi,%eax
801073d8:	e8 13 fd ff ff       	call   801070f0 <mappages>
  memmove(mem, init, sz);
801073dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073e0:	89 75 10             	mov    %esi,0x10(%ebp)
801073e3:	83 c4 10             	add    $0x10,%esp
801073e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073e9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ef:	5b                   	pop    %ebx
801073f0:	5e                   	pop    %esi
801073f1:	5f                   	pop    %edi
801073f2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073f3:	e9 68 d9 ff ff       	jmp    80104d60 <memmove>
    panic("inituvm: more than a page");
801073f8:	83 ec 0c             	sub    $0xc,%esp
801073fb:	68 ed 84 10 80       	push   $0x801084ed
80107400:	e8 cb 8f ff ff       	call   801003d0 <panic>
80107405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107410 <loaduvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 45 0c             	mov    0xc(%ebp),%eax
8010741c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010741f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107424:	0f 85 bb 00 00 00    	jne    801074e5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010742a:	01 f0                	add    %esi,%eax
8010742c:	89 f3                	mov    %esi,%ebx
8010742e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107431:	8b 45 14             	mov    0x14(%ebp),%eax
80107434:	01 f0                	add    %esi,%eax
80107436:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107439:	85 f6                	test   %esi,%esi
8010743b:	0f 84 87 00 00 00    	je     801074c8 <loaduvm+0xb8>
80107441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010744b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010744e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107450:	89 c2                	mov    %eax,%edx
80107452:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107455:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107458:	f6 c2 01             	test   $0x1,%dl
8010745b:	75 13                	jne    80107470 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010745d:	83 ec 0c             	sub    $0xc,%esp
80107460:	68 07 85 10 80       	push   $0x80108507
80107465:	e8 66 8f ff ff       	call   801003d0 <panic>
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107470:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107473:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107479:	25 fc 0f 00 00       	and    $0xffc,%eax
8010747e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107485:	85 c0                	test   %eax,%eax
80107487:	74 d4                	je     8010745d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107489:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010748b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010748e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107493:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107498:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010749e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074a1:	29 d9                	sub    %ebx,%ecx
801074a3:	05 00 00 00 80       	add    $0x80000000,%eax
801074a8:	57                   	push   %edi
801074a9:	51                   	push   %ecx
801074aa:	50                   	push   %eax
801074ab:	ff 75 10             	push   0x10(%ebp)
801074ae:	e8 8d a6 ff ff       	call   80101b40 <readi>
801074b3:	83 c4 10             	add    $0x10,%esp
801074b6:	39 f8                	cmp    %edi,%eax
801074b8:	75 1e                	jne    801074d8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801074ba:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074c0:	89 f0                	mov    %esi,%eax
801074c2:	29 d8                	sub    %ebx,%eax
801074c4:	39 c6                	cmp    %eax,%esi
801074c6:	77 80                	ja     80107448 <loaduvm+0x38>
}
801074c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074cb:	31 c0                	xor    %eax,%eax
}
801074cd:	5b                   	pop    %ebx
801074ce:	5e                   	pop    %esi
801074cf:	5f                   	pop    %edi
801074d0:	5d                   	pop    %ebp
801074d1:	c3                   	ret    
801074d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074e0:	5b                   	pop    %ebx
801074e1:	5e                   	pop    %esi
801074e2:	5f                   	pop    %edi
801074e3:	5d                   	pop    %ebp
801074e4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801074e5:	83 ec 0c             	sub    $0xc,%esp
801074e8:	68 a8 85 10 80       	push   $0x801085a8
801074ed:	e8 de 8e ff ff       	call   801003d0 <panic>
801074f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107500 <allocuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107509:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010750c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010750f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107512:	85 c0                	test   %eax,%eax
80107514:	0f 88 b6 00 00 00    	js     801075d0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010751a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010751d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107520:	0f 82 9a 00 00 00    	jb     801075c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107526:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010752c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107532:	39 75 10             	cmp    %esi,0x10(%ebp)
80107535:	77 44                	ja     8010757b <allocuvm+0x7b>
80107537:	e9 87 00 00 00       	jmp    801075c3 <allocuvm+0xc3>
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	68 00 10 00 00       	push   $0x1000
80107548:	6a 00                	push   $0x0
8010754a:	50                   	push   %eax
8010754b:	e8 70 d7 ff ff       	call   80104cc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107550:	58                   	pop    %eax
80107551:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107557:	5a                   	pop    %edx
80107558:	6a 06                	push   $0x6
8010755a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010755f:	89 f2                	mov    %esi,%edx
80107561:	50                   	push   %eax
80107562:	89 f8                	mov    %edi,%eax
80107564:	e8 87 fb ff ff       	call   801070f0 <mappages>
80107569:	83 c4 10             	add    $0x10,%esp
8010756c:	85 c0                	test   %eax,%eax
8010756e:	78 78                	js     801075e8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107570:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107576:	39 75 10             	cmp    %esi,0x10(%ebp)
80107579:	76 48                	jbe    801075c3 <allocuvm+0xc3>
    mem = kalloc();
8010757b:	e8 00 b2 ff ff       	call   80102780 <kalloc>
80107580:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107582:	85 c0                	test   %eax,%eax
80107584:	75 ba                	jne    80107540 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	68 25 85 10 80       	push   $0x80108525
8010758e:	e8 5d 91 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107593:	8b 45 0c             	mov    0xc(%ebp),%eax
80107596:	83 c4 10             	add    $0x10,%esp
80107599:	39 45 10             	cmp    %eax,0x10(%ebp)
8010759c:	74 32                	je     801075d0 <allocuvm+0xd0>
8010759e:	8b 55 10             	mov    0x10(%ebp),%edx
801075a1:	89 c1                	mov    %eax,%ecx
801075a3:	89 f8                	mov    %edi,%eax
801075a5:	e8 96 fa ff ff       	call   80107040 <deallocuvm.part.0>
      return 0;
801075aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b7:	5b                   	pop    %ebx
801075b8:	5e                   	pop    %esi
801075b9:	5f                   	pop    %edi
801075ba:	5d                   	pop    %ebp
801075bb:	c3                   	ret    
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801075c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801075c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c9:	5b                   	pop    %ebx
801075ca:	5e                   	pop    %esi
801075cb:	5f                   	pop    %edi
801075cc:	5d                   	pop    %ebp
801075cd:	c3                   	ret    
801075ce:	66 90                	xchg   %ax,%ax
    return 0;
801075d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret    
801075e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075e8:	83 ec 0c             	sub    $0xc,%esp
801075eb:	68 3d 85 10 80       	push   $0x8010853d
801075f0:	e8 fb 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
801075f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075f8:	83 c4 10             	add    $0x10,%esp
801075fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075fe:	74 0c                	je     8010760c <allocuvm+0x10c>
80107600:	8b 55 10             	mov    0x10(%ebp),%edx
80107603:	89 c1                	mov    %eax,%ecx
80107605:	89 f8                	mov    %edi,%eax
80107607:	e8 34 fa ff ff       	call   80107040 <deallocuvm.part.0>
      kfree(mem);
8010760c:	83 ec 0c             	sub    $0xc,%esp
8010760f:	53                   	push   %ebx
80107610:	e8 ab af ff ff       	call   801025c0 <kfree>
      return 0;
80107615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010761c:	83 c4 10             	add    $0x10,%esp
}
8010761f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107622:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107625:	5b                   	pop    %ebx
80107626:	5e                   	pop    %esi
80107627:	5f                   	pop    %edi
80107628:	5d                   	pop    %ebp
80107629:	c3                   	ret    
8010762a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107630 <deallocuvm>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	8b 55 0c             	mov    0xc(%ebp),%edx
80107636:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107639:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010763c:	39 d1                	cmp    %edx,%ecx
8010763e:	73 10                	jae    80107650 <deallocuvm+0x20>
}
80107640:	5d                   	pop    %ebp
80107641:	e9 fa f9 ff ff       	jmp    80107040 <deallocuvm.part.0>
80107646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764d:	8d 76 00             	lea    0x0(%esi),%esi
80107650:	89 d0                	mov    %edx,%eax
80107652:	5d                   	pop    %ebp
80107653:	c3                   	ret    
80107654:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010765f:	90                   	nop

80107660 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010766c:	85 f6                	test   %esi,%esi
8010766e:	74 59                	je     801076c9 <freevm+0x69>
  if(newsz >= oldsz)
80107670:	31 c9                	xor    %ecx,%ecx
80107672:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107677:	89 f0                	mov    %esi,%eax
80107679:	89 f3                	mov    %esi,%ebx
8010767b:	e8 c0 f9 ff ff       	call   80107040 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107680:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107686:	eb 0f                	jmp    80107697 <freevm+0x37>
80107688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop
80107690:	83 c3 04             	add    $0x4,%ebx
80107693:	39 df                	cmp    %ebx,%edi
80107695:	74 23                	je     801076ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107697:	8b 03                	mov    (%ebx),%eax
80107699:	a8 01                	test   $0x1,%al
8010769b:	74 f3                	je     80107690 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010769d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076a2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076ad:	50                   	push   %eax
801076ae:	e8 0d af ff ff       	call   801025c0 <kfree>
801076b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076b6:	39 df                	cmp    %ebx,%edi
801076b8:	75 dd                	jne    80107697 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c0:	5b                   	pop    %ebx
801076c1:	5e                   	pop    %esi
801076c2:	5f                   	pop    %edi
801076c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076c4:	e9 f7 ae ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
801076c9:	83 ec 0c             	sub    $0xc,%esp
801076cc:	68 59 85 10 80       	push   $0x80108559
801076d1:	e8 fa 8c ff ff       	call   801003d0 <panic>
801076d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076dd:	8d 76 00             	lea    0x0(%esi),%esi

801076e0 <setupkvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	56                   	push   %esi
801076e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076e5:	e8 96 b0 ff ff       	call   80102780 <kalloc>
801076ea:	89 c6                	mov    %eax,%esi
801076ec:	85 c0                	test   %eax,%eax
801076ee:	74 42                	je     80107732 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076f8:	68 00 10 00 00       	push   $0x1000
801076fd:	6a 00                	push   $0x0
801076ff:	50                   	push   %eax
80107700:	e8 bb d5 ff ff       	call   80104cc0 <memset>
80107705:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107708:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010770b:	83 ec 08             	sub    $0x8,%esp
8010770e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107711:	ff 73 0c             	push   0xc(%ebx)
80107714:	8b 13                	mov    (%ebx),%edx
80107716:	50                   	push   %eax
80107717:	29 c1                	sub    %eax,%ecx
80107719:	89 f0                	mov    %esi,%eax
8010771b:	e8 d0 f9 ff ff       	call   801070f0 <mappages>
80107720:	83 c4 10             	add    $0x10,%esp
80107723:	85 c0                	test   %eax,%eax
80107725:	78 19                	js     80107740 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107727:	83 c3 10             	add    $0x10,%ebx
8010772a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107730:	75 d6                	jne    80107708 <setupkvm+0x28>
}
80107732:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107735:	89 f0                	mov    %esi,%eax
80107737:	5b                   	pop    %ebx
80107738:	5e                   	pop    %esi
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    
8010773b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop
      freevm(pgdir);
80107740:	83 ec 0c             	sub    $0xc,%esp
80107743:	56                   	push   %esi
      return 0;
80107744:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107746:	e8 15 ff ff ff       	call   80107660 <freevm>
      return 0;
8010774b:	83 c4 10             	add    $0x10,%esp
}
8010774e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107751:	89 f0                	mov    %esi,%eax
80107753:	5b                   	pop    %ebx
80107754:	5e                   	pop    %esi
80107755:	5d                   	pop    %ebp
80107756:	c3                   	ret    
80107757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775e:	66 90                	xchg   %ax,%ax

80107760 <kvmalloc>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107766:	e8 75 ff ff ff       	call   801076e0 <setupkvm>
8010776b:	a3 04 72 11 80       	mov    %eax,0x80117204
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107770:	05 00 00 00 80       	add    $0x80000000,%eax
80107775:	0f 22 d8             	mov    %eax,%cr3
}
80107778:	c9                   	leave  
80107779:	c3                   	ret    
8010777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107780 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	83 ec 08             	sub    $0x8,%esp
80107786:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107789:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010778c:	89 c1                	mov    %eax,%ecx
8010778e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107791:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107794:	f6 c2 01             	test   $0x1,%dl
80107797:	75 17                	jne    801077b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107799:	83 ec 0c             	sub    $0xc,%esp
8010779c:	68 6a 85 10 80       	push   $0x8010856a
801077a1:	e8 2a 8c ff ff       	call   801003d0 <panic>
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801077b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801077b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801077be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801077c5:	85 c0                	test   %eax,%eax
801077c7:	74 d0                	je     80107799 <clearpteu+0x19>
  *pte &= ~PTE_U;
801077c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077cc:	c9                   	leave  
801077cd:	c3                   	ret    
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	57                   	push   %edi
801077d4:	56                   	push   %esi
801077d5:	53                   	push   %ebx
801077d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077d9:	e8 02 ff ff ff       	call   801076e0 <setupkvm>
801077de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077e1:	85 c0                	test   %eax,%eax
801077e3:	0f 84 bd 00 00 00    	je     801078a6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077ec:	85 c9                	test   %ecx,%ecx
801077ee:	0f 84 b2 00 00 00    	je     801078a6 <copyuvm+0xd6>
801077f4:	31 f6                	xor    %esi,%esi
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107800:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107803:	89 f0                	mov    %esi,%eax
80107805:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107808:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010780b:	a8 01                	test   $0x1,%al
8010780d:	75 11                	jne    80107820 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010780f:	83 ec 0c             	sub    $0xc,%esp
80107812:	68 74 85 10 80       	push   $0x80108574
80107817:	e8 b4 8b ff ff       	call   801003d0 <panic>
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107820:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107822:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107827:	c1 ea 0a             	shr    $0xa,%edx
8010782a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107830:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107837:	85 c0                	test   %eax,%eax
80107839:	74 d4                	je     8010780f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010783b:	8b 00                	mov    (%eax),%eax
8010783d:	a8 01                	test   $0x1,%al
8010783f:	0f 84 9f 00 00 00    	je     801078e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107845:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107847:	25 ff 0f 00 00       	and    $0xfff,%eax
8010784c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010784f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107855:	e8 26 af ff ff       	call   80102780 <kalloc>
8010785a:	89 c3                	mov    %eax,%ebx
8010785c:	85 c0                	test   %eax,%eax
8010785e:	74 64                	je     801078c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107860:	83 ec 04             	sub    $0x4,%esp
80107863:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107869:	68 00 10 00 00       	push   $0x1000
8010786e:	57                   	push   %edi
8010786f:	50                   	push   %eax
80107870:	e8 eb d4 ff ff       	call   80104d60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107875:	58                   	pop    %eax
80107876:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010787c:	5a                   	pop    %edx
8010787d:	ff 75 e4             	push   -0x1c(%ebp)
80107880:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107885:	89 f2                	mov    %esi,%edx
80107887:	50                   	push   %eax
80107888:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010788b:	e8 60 f8 ff ff       	call   801070f0 <mappages>
80107890:	83 c4 10             	add    $0x10,%esp
80107893:	85 c0                	test   %eax,%eax
80107895:	78 21                	js     801078b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107897:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010789d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801078a0:	0f 87 5a ff ff ff    	ja     80107800 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801078a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ac:	5b                   	pop    %ebx
801078ad:	5e                   	pop    %esi
801078ae:	5f                   	pop    %edi
801078af:	5d                   	pop    %ebp
801078b0:	c3                   	ret    
801078b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801078b8:	83 ec 0c             	sub    $0xc,%esp
801078bb:	53                   	push   %ebx
801078bc:	e8 ff ac ff ff       	call   801025c0 <kfree>
      goto bad;
801078c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801078c4:	83 ec 0c             	sub    $0xc,%esp
801078c7:	ff 75 e0             	push   -0x20(%ebp)
801078ca:	e8 91 fd ff ff       	call   80107660 <freevm>
  return 0;
801078cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078d6:	83 c4 10             	add    $0x10,%esp
}
801078d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078df:	5b                   	pop    %ebx
801078e0:	5e                   	pop    %esi
801078e1:	5f                   	pop    %edi
801078e2:	5d                   	pop    %ebp
801078e3:	c3                   	ret    
      panic("copyuvm: page not present");
801078e4:	83 ec 0c             	sub    $0xc,%esp
801078e7:	68 8e 85 10 80       	push   $0x8010858e
801078ec:	e8 df 8a ff ff       	call   801003d0 <panic>
801078f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ff:	90                   	nop

80107900 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107906:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107909:	89 c1                	mov    %eax,%ecx
8010790b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010790e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107911:	f6 c2 01             	test   $0x1,%dl
80107914:	0f 84 c0 01 00 00    	je     80107ada <uva2ka.cold>
  return &pgtab[PTX(va)];
8010791a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010791d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107923:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107924:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107929:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107930:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107937:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010793a:	05 00 00 00 80       	add    $0x80000000,%eax
8010793f:	83 fa 05             	cmp    $0x5,%edx
80107942:	ba 00 00 00 00       	mov    $0x0,%edx
80107947:	0f 45 c2             	cmovne %edx,%eax
}
8010794a:	c3                   	ret    
8010794b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop

80107950 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 0c             	sub    $0xc,%esp
80107959:	8b 75 14             	mov    0x14(%ebp),%esi
8010795c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010795f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107962:	85 f6                	test   %esi,%esi
80107964:	75 51                	jne    801079b7 <copyout+0x67>
80107966:	e9 a5 00 00 00       	jmp    80107a10 <copyout+0xc0>
8010796b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107970:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107976:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010797c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107982:	74 75                	je     801079f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107984:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107986:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107989:	29 c3                	sub    %eax,%ebx
8010798b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107991:	39 f3                	cmp    %esi,%ebx
80107993:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107996:	29 f8                	sub    %edi,%eax
80107998:	83 ec 04             	sub    $0x4,%esp
8010799b:	01 c1                	add    %eax,%ecx
8010799d:	53                   	push   %ebx
8010799e:	52                   	push   %edx
8010799f:	51                   	push   %ecx
801079a0:	e8 bb d3 ff ff       	call   80104d60 <memmove>
    len -= n;
    buf += n;
801079a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801079a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801079ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801079b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801079b3:	29 de                	sub    %ebx,%esi
801079b5:	74 59                	je     80107a10 <copyout+0xc0>
  if(*pde & PTE_P){
801079b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801079ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801079be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801079c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801079ca:	f6 c1 01             	test   $0x1,%cl
801079cd:	0f 84 0e 01 00 00    	je     80107ae1 <copyout.cold>
  return &pgtab[PTX(va)];
801079d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079db:	c1 eb 0c             	shr    $0xc,%ebx
801079de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801079e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801079eb:	89 d9                	mov    %ebx,%ecx
801079ed:	83 e1 05             	and    $0x5,%ecx
801079f0:	83 f9 05             	cmp    $0x5,%ecx
801079f3:	0f 84 77 ff ff ff    	je     80107970 <copyout+0x20>
  }
  return 0;
}
801079f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a01:	5b                   	pop    %ebx
80107a02:	5e                   	pop    %esi
80107a03:	5f                   	pop    %edi
80107a04:	5d                   	pop    %ebp
80107a05:	c3                   	ret    
80107a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi
80107a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a13:	31 c0                	xor    %eax,%eax
}
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a20 <retNumpp>:

// int retNumvp(){
//   return 0;
// }

int retNumpp(){
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 0c             	sub    $0xc,%esp
  int ii=0;
  pde_t *pgdir=myproc()->pgdir;
80107a29:	e8 b2 c0 ff ff       	call   80103ae0 <myproc>
  k=kmap;
  // void *va = k->virt;
  uint size = k->phys_end - k->phys_start;
  uint pa = k->phys_start;
  // int perm
  a = (char*)PGROUNDDOWN((uint)pa);
80107a2e:	8b 15 24 b4 10 80    	mov    0x8010b424,%edx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
      return -1;
80107a34:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107a39:	8b 1d 28 b4 10 80    	mov    0x8010b428,%ebx
  pde_t *pgdir=myproc()->pgdir;
80107a3f:	8b 70 04             	mov    0x4(%eax),%esi
  a = (char*)PGROUNDDOWN((uint)pa);
80107a42:	89 d0                	mov    %edx,%eax
  pde = &pgdir[PDX(va)];
80107a44:	c1 ea 16             	shr    $0x16,%edx
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107a47:	83 eb 01             	sub    $0x1,%ebx
  if(*pde & PTE_P){
80107a4a:	8b 14 96             	mov    (%esi,%edx,4),%edx
  a = (char*)PGROUNDDOWN((uint)pa);
80107a4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  last=(char*)PGROUNDDOWN(((uint)pa)+size -1);
80107a52:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(*pde & PTE_P){
80107a58:	f6 c2 01             	test   $0x1,%dl
80107a5b:	74 45                	je     80107aa2 <retNumpp+0x82>
  return &pgtab[PTX(va)];
80107a5d:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a5f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107a65:	c1 ef 0a             	shr    $0xa,%edi
80107a68:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80107a6e:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80107a75:	85 d2                	test   %edx,%edx
80107a77:	74 29                	je     80107aa2 <retNumpp+0x82>
  int ii=0;
80107a79:	31 c9                	xor    %ecx,%ecx
    // if(*pte & PTE_P)
      // panic("remap");
    // *pte = pa | perm | PTE_P;
    if(a == last)
80107a7b:	39 d8                	cmp    %ebx,%eax
80107a7d:	74 23                	je     80107aa2 <retNumpp+0x82>
80107a7f:	90                   	nop
      break;
    a += PGSIZE;
    pa += PGSIZE;
    if((PTE_P & *pte)!=0){
80107a80:	8b 12                	mov    (%edx),%edx
    a += PGSIZE;
80107a82:	05 00 10 00 00       	add    $0x1000,%eax
    if((PTE_P & *pte)!=0){
80107a87:	83 e2 01             	and    $0x1,%edx
      ii++;
80107a8a:	83 fa 01             	cmp    $0x1,%edx
  pde = &pgdir[PDX(va)];
80107a8d:	89 c2                	mov    %eax,%edx
      ii++;
80107a8f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  pde = &pgdir[PDX(va)];
80107a92:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107a95:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107a98:	f6 c2 01             	test   $0x1,%dl
80107a9b:	75 13                	jne    80107ab0 <retNumpp+0x90>
      return -1;
80107a9d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
    }
  }

  return ii;
80107aa2:	83 c4 0c             	add    $0xc,%esp
80107aa5:	89 c8                	mov    %ecx,%eax
80107aa7:	5b                   	pop    %ebx
80107aa8:	5e                   	pop    %esi
80107aa9:	5f                   	pop    %edi
80107aaa:	5d                   	pop    %ebp
80107aab:	c3                   	ret    
80107aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107ab0:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ab2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107ab8:	c1 ef 0a             	shr    $0xa,%edi
80107abb:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80107ac1:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, a, 0)) == 0)
80107ac8:	85 d2                	test   %edx,%edx
80107aca:	74 d1                	je     80107a9d <retNumpp+0x7d>
    if(a == last)
80107acc:	39 c3                	cmp    %eax,%ebx
80107ace:	75 b0                	jne    80107a80 <retNumpp+0x60>
80107ad0:	83 c4 0c             	add    $0xc,%esp
80107ad3:	89 c8                	mov    %ecx,%eax
80107ad5:	5b                   	pop    %ebx
80107ad6:	5e                   	pop    %esi
80107ad7:	5f                   	pop    %edi
80107ad8:	5d                   	pop    %ebp
80107ad9:	c3                   	ret    

80107ada <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107ada:	a1 00 00 00 00       	mov    0x0,%eax
80107adf:	0f 0b                	ud2    

80107ae1 <copyout.cold>:
80107ae1:	a1 00 00 00 00       	mov    0x0,%eax
80107ae6:	0f 0b                	ud2    
