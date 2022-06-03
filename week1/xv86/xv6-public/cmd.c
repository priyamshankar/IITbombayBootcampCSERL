#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"

int main(int argc, char **argv)
{
    if (argc <= 1)
    {
        printf(1, "not any argument exititng the program\n");
        printf(1, "please enter any existing argument like ls , echo and wc etc\n");
        printf(1, "example cmd ls or cmd echo priyam or cmd wc ls\n");
        exit();
    }
    char **args = argv;
    for (int i = 1; i < argc; i++)
    {
        args[i - 1] = argv[i];
    }
    args[argc - 1] = NULL;

    // Implement your code here
    for (int i = 0; i < argc; i++)
    {

        int ret = fork();

        if (ret <= 0)
        {
            exit();
        }
        else
        {
            int reaped_pid = wait();
            exec(argv[i], args);
            printf(1, "%d", reaped_pid);
        }
    }
    //
    // getppid(7);
    exit();
}