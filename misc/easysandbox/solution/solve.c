#define _GNU_SOURCE
#undef _POSIX_SOURCE
#include <fcntl.h>
#include <sys/stat.h>
#include<stdio.h>
#include<stdlib.h>
#include<dlfcn.h>
#include<unistd.h>
#include<errno.h>
#include<string.h>
#include<link.h>
#include<sched.h>
typedef int (*main_t)(int, char **, char **);
#ifndef __unbounded
# define __unbounded
#endif


int __libc_start_main(
    main_t main,
    int argc,
    char *__unbounded *__unbounded ubp_av,
    ElfW(auxv_t) *__unbounded auxvec,
    __typeof (main) init,
    void (*fini) (void),
    void (*rtld_fini) (void),
    void *__unbounded stack_end)
{
    return main(0,0,0);
}

int main() {
    char buf[50]={0};
    int fd=open("./flag",O_RDONLY);
    read(fd,buf,50);
    write(1,buf,50);
    exit(0);
}
