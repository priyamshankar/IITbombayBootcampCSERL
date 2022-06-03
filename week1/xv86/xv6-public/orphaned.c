#include "types.h"
#include "stat.h"
#include "user.h"

int main() 
{
    // printf(1,"overall parent pid: %d\n",getpid());
	int ret = fork();
	if (ret == 0) 
	{
		printf(1, "\nchild: pid %d\n", getpid());
		printf(1, "child: parent pid %d\n", getppid());

		sleep(200);

		printf(1, "\nchild: pid %d\n", getpid());
		printf(1, "child: parent pid %d\n", getppid());
	}
	else 
	{
		sleep(100);

		printf(1, "\nparent: pid %d\n", getpid());
		printf(1, "parent: parent pid %d \n", getppid());
		printf(1, "parent: child pid %d\n", ret);
	}
	// printf(1,"after the else\n");
	
	exit();
}
