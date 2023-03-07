// #include <omp.h>
// #include <stdio.h>

// int main() {
//     int n = 10000000;
//     long long int sum = 0;
//     for (int i = 0; i < n; i++) {
//         sum += i;
//     }
//     printf("sum = %lld\n", sum);
//     return 0;
// }

#include <stdio.h>
#include <omp.h>

int main() {
    int n = 10000000;
    long long int sum = 0;
    double start_time, end_time;

    start_time = omp_get_wtime();

    #pragma omp parallel for reduction(+:sum)
    for (int i = 0; i < n; i++) {
        sum += i;
    }

    end_time = omp_get_wtime();

    printf("sum = %lld\n", sum);
    printf("Execution time = %f seconds\n", end_time - start_time);
    return 0;
}

// sum = 49999995000000
// Execution time = 0.032160 seconds
// $ gcc -fopenmp openmp.c