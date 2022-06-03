#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
    // int ret =fork();
    // printf(1, "hello pid is %d\n", getpid());
    int ret = fork();
    get_siblings_info(getpid());
    if (ret == 0)
    {
        printf(1, "child's parent pid %d\n", getppid());
        printf(1, "child's pid %d\n", getpid());
        while (1)
        {
        }
    }
    else if (ret < 0)
    {
        exit();
    }
    else
    {
        printf(1, "parent %d\n", getpid());
        wait();
    }
    // printf(1,"fork no.: %d\n",ret);
    // get_siblings_info();
    // printf(1, "pid= %d and ppid is = %d\n", getpid(), getppid());
    // printf(1, "fork ret = %d", ret);
    // wait();
    exit();
    return 0;
}
