#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"

int main(int argc, char **argv)
{
    if (argc <= 1)
    {
        printf(1, "not any argument exititng the program\n");
        printf(1, "manSyCall + any string to print the system call\n");
        exit();
    }
    hello();
    helloYou(argv[1]);
    //
    exit();
}