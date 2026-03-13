#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <sched.h>

#define SIZE 256

// Structure to pass arguments to each thread
typedef struct {
    int row_idx;
    int (*m1)[SIZE];
    int (*m2)[SIZE];
    int (*result)[SIZE];
} ThreadData;

// Function to read a matrix from the file pointer
void read_matrix(FILE *fp, int matrix[SIZE][SIZE]) {
    char line[4096]; // Buffer large enough for a line of 32 integers
    int row = 0;
    
    while (row < SIZE) {
        if (fgets(line, sizeof(line), fp) == NULL) break;
        
        // Skip empty lines (handling \n and \r\n)
        if (line[0] == '\n' || line[0] == '\r') continue;

        char *token = strtok(line, ", \n\r");
        int col = 0;
        while (token != NULL && col < SIZE) {
            matrix[row][col] = atoi(token);
            token = strtok(NULL, ", \n\r");
            col++;
        }
        
        // Only increment row if we actually read some data
        if (col > 0) {
            row++;
        }
    }
}

void* compute_row(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    int i = data->row_idx;

    int cpu = sched_getcpu();
    printf("Thread processing Row %d on CPU Core %d\n", i, cpu);

    // Calculate row i
    for (int j = 0; j < SIZE; j++) {
        int sum = 0;
        for (int k = 0; k < SIZE; k++) {
            sum += data->m1[i][k] * data->m2[j][k];
        }
        data->result[i][j] = sum;
    }
    pthread_exit(NULL);
}

void save_matrix_to_csv(const char *filename, int matrix[SIZE][SIZE]) {
    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        perror("Error opening output file");
        return;
    }
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            fprintf(fp, "%d", matrix[i][j]);
            if (j < SIZE - 1) fprintf(fp, ",");
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
    printf("Result saved to %s\n", filename);
}

void print_matrix(int matrix[SIZE][SIZE]) {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d", matrix[i][j]);
            if (j < SIZE - 1) printf(",");
        }
        printf("\n");
    }
}

int main() {
    FILE *fp = fopen("./input-matrix.csv", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return 1;
    }

    int matrix1[SIZE][SIZE];
    int matrix2[SIZE][SIZE];
    int result[SIZE][SIZE];

    // Read first matrix
    read_matrix(fp, matrix1);
    
    // Read second matrix
    read_matrix(fp, matrix2);

    fclose(fp);

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    // Create 256 threads, each handling one row
    pthread_t threads[SIZE];
    ThreadData thread_args[SIZE];

    for (int i = 0; i < SIZE; i++) {
        thread_args[i].row_idx = i;
        thread_args[i].m1 = matrix1;
        thread_args[i].m2 = matrix2;
        thread_args[i].result = result;
        
        int rc = pthread_create(&threads[i], NULL, compute_row, (void*)&thread_args[i]);
        if (rc) {
            fprintf(stderr, "Error: unable to create thread, %d\n", rc);
            exit(-1);
        }
    }

    // Wait for all threads to complete
    for (int i = 0; i < SIZE; i++) {
        pthread_join(threads[i], NULL);
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    double time_taken = (end.tv_sec - start.tv_sec) + 
                        (end.tv_nsec - start.tv_nsec) / 1e9;

    //printf("Result Matrix:\n");
    //print_matrix(result);

    save_matrix_to_csv("./output-matrix.csv", result);

    printf("\nCompute Time: %.3f ms\n", time_taken*1000);

    return 0;
}