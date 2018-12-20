#define _BSD_SOURCE // readlink
#include <dlfcn.h>
#include <stdlib.h> // exit
#include <string.h> // strstr, memset
#include <link.h>   // ElfW
#include <errno.h>  // EPERM
#include <unistd.h> // readlink
#include <stdio.h>
#include "config.h"
#include "seccomp-bpf.h"
typedef int (*main_t)(int, char **, char **);
 
#ifndef __unbounded
# define __unbounded
#endif
static int install_syscall_filter(void)
{
	struct sock_filter filter[] = {
		/* Validate architecture. */
		VALIDATE_ARCHITECTURE,
		/* Grab the system call number. */
		EXAMINE_SYSCALL,
        ALLOW_SYSCALL(read),
        ALLOW_SYSCALL(write),
        ALLOW_SYSCALL(exit),
        ALLOW_SYSCALL(exit_group),

        KILL_PROCESS
	};
	struct sock_fprog prog = {
		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
		.filter = filter,
	};

	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		perror("prctl(NO_NEW_PRIVS)");
		goto failed;
	}
	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
		perror("prctl(SECCOMP)");
		goto failed;
	}
	return 0;

failed:
	if (errno == EINVAL)
		fprintf(stderr, "SECCOMP_FILTER is not available. :(\n");
	return 1;
}

 
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
    int i;
    ssize_t len;
    void *libc;
    int (*libc_start_main)(main_t main,
        int,
        char *__unbounded *__unbounded,
        ElfW(auxv_t) *,
        __typeof (main),
        void (*fini) (void),
        void (*rtld_fini) (void),
        void *__unbounded stack_end);
    // Get __libc_start_main entry point
    libc = dlopen("libc.so.6", RTLD_LOCAL  | RTLD_LAZY);
    if (!libc) {
        exit(1);
    }
    libc_start_main = dlsym(libc, "__libc_start_main");
    if (!libc_start_main) {
        exit(2);
    }
    if (install_syscall_filter())
		exit(3);
    return ((*libc_start_main)(main, argc, ubp_av, auxvec,
                 init, fini, rtld_fini, stack_end));
}

