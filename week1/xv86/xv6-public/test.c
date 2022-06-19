#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) 
{
    init_counter();
    int ret = fork();

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
    // printf(1,"init: %d\nacq: %d \nrel: %d \nhol: %d\n", init_mylock(),acquire_mylock(11), release_mylock(12),holding_mylock(13));

    // printf(1,"%d\n",init_mylock());
    init_mylock();
    printf(1,"%d\n",acquire_mylock(0));
    printf(1,"%d\n",release_mylock(0));
    // printf(1,"hello spinlocks");


    for(int i=0; i<10000; i++){
        update_cnt();
    }

    if(ret == 0)
        exit();
    else{
        wait();
        printf(1, "%d\n", display_count());
        exit();
    }

} 