// System call numbers
#define SYS_fork    1
#define SYS_exit    2
#define SYS_wait    3
#define SYS_pipe    4
#define SYS_read    5
#define SYS_kill    6
#define SYS_exec    7
#define SYS_fstat   8
#define SYS_chdir   9
#define SYS_dup    10
#define SYS_getpid 11
#define SYS_sbrk   12
#define SYS_sleep  13
#define SYS_uptime 14
#define SYS_open   15
#define SYS_write  16
#define SYS_mknod  17
#define SYS_unlink 18
#define SYS_link   19
#define SYS_mkdir  20
#define SYS_close  21
#define SYS_hello  22  //user defined
#define SYS_helloYou  23  //user defined
#define SYS_getppid  24  //user defined
#define SYS_get_siblings_info 25//user defined
#define SYS_signalProcess 26 //user defined
#define SYS_numvp   27
#define SYS_numpp   28
// Assignment system calls for the global counter
#define SYS_init_counter    29
#define SYS_update_cnt      30
#define SYS_display_count   31
#define SYS_init_counter_1  32
#define SYS_update_cnt_1    33
#define SYS_display_count_1 34
#define SYS_init_counter_2  35
#define SYS_update_cnt_2    36
#define SYS_display_count_2 37
#define SYS_init_mylock     38
#define SYS_acquire_mylock  39
#define SYS_release_mylock  40
#define SYS_holding_mylock  41