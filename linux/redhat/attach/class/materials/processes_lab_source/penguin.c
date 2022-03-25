#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/prctl.h>

#define	PENGUIN_SZ	50*1024

/* Philip Sweany (03/17/2014)
*  Generates a  moderate memory and CPU workload.
*  Will use a consistent but minority share of cycles from one CPU.
*  Currently, appears to hover about 25-35% on an unsaturated VM.
*  
*  In the Makefile, the penguin executable is copied to other names
*  that are appropriate for specific labs.
*
*  Original source code: George Hacker, Forrest Taylor
*/

int main (int argc, char *argv[])
{
	int pid;
	char *p, *buffer;

	/* Moderate workload */
	if ((pid = fork()) == 0) {
		buffer = malloc(PENGUIN_SZ);
		if (buffer != NULL) {
			for (p = buffer; p < buffer + PENGUIN_SZ; p += 4096)
				*p = 'E';
		}
		while ( 1 ) {
			pid = 0;
			while (pid < 100000000)
				pid++;
			usleep(500000);
		}
	}

}
