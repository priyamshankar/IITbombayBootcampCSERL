#include "types.h"
#include "stat.h"
#include "user.h"
#define MAX_SZ 1000000
#define SIGNAL_PAUSE "PAUSE"
#define SIGNAL_CONTINUE "CONTINUE"
#define SIGNAL_KILL "KILL"
int main(int argc, char **argv)
{
    // int ret =fork();
    // printf(1, "hello pid is %d\n", getpid());
    // int ret = fork();
    // get_siblings_info(getpid());
    // if (ret == 0)
    // {
    //     printf(1, "child's parent pid %d\n", getppid());
    //     printf(1, "child's pid %d\n", getpid());
    //     while (1)
    //     {
    //     }
    // }
    // else if (ret < 0)
    // {
    //     exit();
    // }
    // else
    // {
    //     printf(1, "parent %d\n", getpid());
    //     wait();
    // }

	// signalProcess(ret, SIGNAL_PAUSE);
    int ret = fork();
	if(ret == 0) 
	{ 
		// for (int i = 0; i < MAX_SZ; ++i)
		// {
		// 	sleep(5e1);
		// 	printf(1, "child: Not_paused\n");
		// }
	signalProcess(ret, SIGNAL_PAUSE);

		exit();
	}
	signalProcess(ret, SIGNAL_KILL);
    // printf(1,"signal %s",SIGNAL_KILL);


    // printf(1,"fork no.: %d\n",ret);
    // get_siblings_info();
    // printf(1, "pid= %d and ppid is = %d\n", getpid(), getppid());
    // printf(1, "fork ret = %d", ret);
    // wait();
    exit();
    return 0;
}
