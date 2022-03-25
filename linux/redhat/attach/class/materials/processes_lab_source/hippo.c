#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

/* Philip Sweany (03/17/2014)
*  Generates a CPU workload sufficient to be noticeable in top(1),
*  will take one CPU core to saturation quickly.
*  Currently, student VMs in Universal Classroom Foundation have 1 CPU.
*  
*  In the Makefile, the hippo executable is copied to other names
*  that are appropriate for specific labs.
*
*  Original source code: George Hacker, Forrest Taylor
*/

int main (int argc, char *argv[])
{
	int pid;
	char *p, *buffer;

	/* CPU hog. */
	if ((pid = fork()) == 0) {
		while ( 1 )
			pid += 9;
	}
}
