#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char **argv)
{
    int i;
    if (argc <= 1)
    {
        printf(1, "enter any value at runtime\n");
    }

    if (argc < 2)
    {
        printf(2, "usage: pname pid...\n");
        exit();
    }
    for (i = 1; i < argc; i++)
        // getppid(atoi(argv[i]));
    exit();
}
