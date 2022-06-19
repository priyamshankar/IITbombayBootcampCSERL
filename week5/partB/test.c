#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{

    init_counter();
    // printf(1,"count lock\n");

    int ret = fork();
    // printf(1,"fork lock\n");


    /* This is where we increment the global counter
       Modify this to ensure race conditions do not mess up final value
       Without locking, the output would be a random value less than 20000
    */

    /*
        Tescases:
            1. Print lock id if the lock has been initialized.
            2. define and call the function 'int holding_mylock(int id)' to check the status of
               the lock in two scenarios - i) when the lock is held and ii) when the lock is not held.
    */
    int id = init_mylock();
    id=0;
    // printf(1,"before lock\n");
    // printf(1,"acq%d\n",acquire_mylock(id));
    acquire_mylock(id);
    // printf(1,"after lock\n");
    for (int i = 0; i < 10000; i++)
    {
        update_cnt();
    }
    printf(1,"hold check: %d\n",holding_mylock(id));
    release_mylock(id);

    if (ret == 0)
    {
        // int id;
        // printf(1, "init: %d\nacq: %d \nrel: %d \nhol: %d\n", id = init_mylock(), acquire_mylock(0), release_mylock(0), holding_mylock(0));

        // int id = init_mylock();
        // // id = 2;
        // printf(1, "%d\n", acquire_mylock(id));
        // printf(1, "%d \n", holding_mylock(id));
        // printf(1, "%d\n", release_mylock(id));
        // printf(1, "%d \n", holding_mylock(id));
        exit();
    }
    else
    {
        wait();
        // acquire_mylock(id);
        printf(1, "%d\n", display_count());
        // release_mylock(id);
        exit();
    }
}