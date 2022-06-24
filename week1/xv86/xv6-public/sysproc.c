#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
// #include "proc.c"

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_hello(void)
{
  
  return 0;   //commenting this line resolved the error
}            //seems like this file serves another purpose, need not to write every syscall init

int sys_getppid(void)
{
  // return myproc()->pid;
  /* get syscall argument */

  int pid;
  if (argint(0, &pid) < 0){
   return -1;
  }
  return getppid();
}

int sys_get_siblings_info(int pid){
  
  return get_siblings_info(sys_getpid());
}
void sys_signalProcess(int pid,char type[]){
  // return 0;

  // char **type2=&type1;
  argint(0,&pid);
  char **type1=&type;
  argstr(1,type1); 
  // cprintf("%s\n",*type1);

  signalProcess(pid,*type1);
}

int sys_numvp(){
  return numvp();
}

int sys_numpp(){
  return numpp();
}

/* New system calls for the global counter
*/
int counter;

void sys_init_counter(void){
  counter = 0;
}

void sys_update_cnt(void){
  // acquire_mylock(0);
  counter = counter + 1;
  // cprintf("%d\n",holding_mylock(3));
  // release_mylock(0);
}

int sys_display_count(void){
  return counter;
}

/* New system calls for the global counter 1
*/
int counter_1;

void sys_init_counter_1(void){
  counter_1 = 0;
}

void sys_update_cnt_1(void){
  counter_1 = counter_1 + 1;
}

int sys_display_count_1(void){
  return counter_1;
}

/* New system calls for the global counter 2
*/
int counter_2;

void sys_init_counter_2(void){
  counter_2 = 0;
}

void sys_update_cnt_2(void){
  counter_2 = counter_2 + 1;
}

int sys_display_count_2(void){
  return counter_2;
}

int sys_init_mylock(){
  return init_mylock();
}

int sys_acquire_mylock(int id){
  argint(0,&id);
  return acquire_mylock(id);
}

int sys_release_mylock(int id){
  argint(0,&id);
  return release_mylock(id);
}

int sys_holding_mylock(int id){
  argint(0,&id);
  return holding_mylock(id);
}