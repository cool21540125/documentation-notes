#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define	ELEPHANT_SZ	128*1024*1024

/* Philip Sweany (03/17/2014)
*  Generates a memory workload sufficient to be noticeable in top(1),
*  but not enough to debilitate a student virtual machine.
*  Currently, student VMs in Universal Classroom Foundation are 1GB RAM.
*  
*  In the Makefile, the elephant executable is copied to other names
*  that are appropriate for specific labs.
*
*  Original source code: George Hacker, Forrest Taylor
*/

int main (int argc, char *argv[])
{
	int pid;
	char *p, *buffer;

	/* memory hog. */
	if ((pid = fork()) == 0) {
		buffer = malloc(ELEPHANT_SZ);
		if (buffer != NULL) {
			for (p = buffer; p < buffer + ELEPHANT_SZ; p += 4096)
				*p = 'E';
		}
		sleep(4*3600);
	}
}
