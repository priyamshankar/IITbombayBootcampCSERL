#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{

  int ret = fork();
  int st = getpid();
  printf(1, "pid =%d", st);
  if (ret == 0)
  {
    printf(1, "In child\n");

    exit();
  }
  else
  {
    int reaped_pid = wait();
    printf(1, "Child with pid %d reaped\n", reaped_pid);
  }

  exit();
}
