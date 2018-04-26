#include <stdio.h>
#include <stdlib.h>

#include "timer.h"

int read_data_from_file(const char *, int * , int);
void print_array(int* , int, int);



//c_decl asm procdure
extern int insertion_sort(int *, int);

#define errormsg(...) fprintf(stderr, __VA_ARGS__)

int main(int argc, const char **argv){

    if (argc<2){
        errormsg("not enough args, provide the name of the file.\n");
        errormsg("./%s [filename]\n", argv[0]);
        exit(1);
    }

    int length = read_data_from_file(argv[1], NULL, NULL);
    if (length <= 0){
        errormsg("invalid file \"%s\"\n", argv[1]);
        exit(1);
    }
    int *array = (int*) malloc(length * sizeof(int));
    if (!array){
        errormsg("not enough memory.\n");
        exit(1);
    }

    length = read_data_from_file(argv[1], array, length);

    timer_begin();
    int status = insertion_sort(array, length);
    timer_stop();


    if (status)
        errormsg("insertion_sort returned %d", status);
    else
        print_array(array, length, argc>2);

    timer_eprint();

    return 0;
}



//returns how many integers were read, which may be less than the no. integers assigned
int read_data_from_file(const char *filename, int *data, int length)
{
    FILE *input = fopen(filename, "r");
    if (!input)
        return -1;
    int last_rv, count = 0;
    int dummy;

    do {
        if (data && (count < length))
            last_rv = fscanf(input, "%d,", data++);
        else
            last_rv = fscanf(input, "%d,", &dummy);
    } while (last_rv != EOF && last_rv != 0 && ++count);

    fclose(input);
    return count;
}

void print_array(int *data, int data_len, int verbose)
{
    if (verbose)
        for (int i = 0; i < data_len; i++) {
            printf("data[%d] = %d\n", i, data[i]);
        }
    else
        for (int i = 0; i < data_len; i++) {
            printf("%d,\n", data[i]);
        }
}

