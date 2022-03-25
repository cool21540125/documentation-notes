
#  Philip Sweany (03/17/2014)
#  Modify this Makefile to include other file names if unique
#  executable names are necessary for a new exercise.
#  The current executables have been included in the
#  Universal Classroom Foundation student VM builds;
#  look in /usr/local/bin.
#
#  Original source code: George Hacker, Forrest Taylor

EXECS=elephant hippo penguin process_space process_cycles process_moderate 

all : $(EXECS)

# memory hogs
# elephant brain lobes have more foldings; excellent memory. 
process_space : elephant
	cp -p elephant process_space

# cpu hogs
# hippo "river horse" can run up to 30km/hour.
process_cycles : hippo
	cp -p hippo process_cycles

# moderate task
# penguin, symbolic of a ubiquitous "shared community" task.
process_moderate : penguin
	cp -p penguin process_moderate

clean:
	rm -f $(EXECS)
