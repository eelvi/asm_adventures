#include <unistd.h> //timer works on linux
#include <time.h> 
#include <stdio.h>
#include <stdbool.h>

#define timer_print() timer_fprint(stdout)
#define timer_eprint() timer_fprint(stderr)

struct timer_info{
       bool stopped;
       struct timespec tstart;
       struct timespec tend; 
};

static struct timer_info ctimer;

static void timer_begin(){
    clock_gettime(CLOCK_MONOTONIC, &ctimer.tstart);
    ctimer.stopped = false;
}
static void timer_stop(){
    clock_gettime(CLOCK_MONOTONIC, &ctimer.tend);
    ctimer.stopped = true;
}

static void timer_fprint(FILE *file)
{
    if (!ctimer.stopped)
        timer_stop();

    fprintf(stderr,"time: %.5f\n",
           ((double)ctimer.tend.tv_sec + 1.0e-9*ctimer.tend.tv_nsec) - 
           ((double)ctimer.tstart.tv_sec + 1.0e-9*ctimer.tstart.tv_nsec));
}

