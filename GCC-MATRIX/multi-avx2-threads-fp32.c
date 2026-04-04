#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <immintrin.h> // Required for AVX2 and FMA intrinsics

#define SIZE 256
#define NUM_THREADS 8

// Structure to pass arguments to each thread
typedef struct {
    int start_row;
    int end_row;
    float (*m1)[SIZE];
    float (*m2)[SIZE];
    float (*result)[SIZE];
} ThreadData;

// Function to read a matrix from the file pointer
void read_matrix(FILE *fp, float matrix[SIZE][SIZE]) {
    char line[4096]; // Buffer large enough for a line of 32 floats
    int row = 0;
    
    while (row < SIZE) {
        if (fgets(line, sizeof(line), fp) == NULL) break;
        
        // Skip empty lines (handling \n and \r\n)
        if (line[0] == '\n' || line[0] == '\r') continue;

        char *token = strtok(line, ", \n\r");
        int col = 0;
        while (token != NULL && col < SIZE) {
            matrix[row][col] = strtof(token, NULL); // Convert to FP32
            token = strtok(NULL, ", \n\r");
            col++;
        }
        
        // Only increment row if we actually read some data
        if (col > 0) {
            row++;
        }
    }
}

// Thread function to compute a chunk of rows
void* compute_rows(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    
    int start = data->start_row;
    int end = data->end_row;

    // Process assigned rows
    for (int i = start; i < end; i++) {
        for (int j = 0; j < SIZE; j++) {
            // Initialize sum vector to 0 (FP32)
            __m256 v_sum = _mm256_setzero_ps();
            
            // Loop unrolled by 8 since an AVX register holds eight 32-bit floats
            for (int k = 0; k < SIZE; k += 8) {
                // Load 8 floats from each matrix using 32-byte aligned load
                __m256 v_m1 = _mm256_load_ps(&data->m1[i][k]);
                __m256 v_m2 = _mm256_load_ps(&data->m2[j][k]);
                
                // Fused Multiply-Add (FMA): v_sum = (v_m1 * v_m2) + v_sum
                // This is faster and more precise than separate multiply and add instructions
                v_sum = _mm256_fmadd_ps(v_m1, v_m2, v_sum);
            }
            
            // Fast Horizontal Add: Reduce the 8 floats in v_sum down to a single float
            __m128 v_low = _mm256_castps256_ps128(v_sum);
            __m128 v_high = _mm256_extractf128_ps(v_sum, 1);
            __m128 v_sum128 = _mm_add_ps(v_low, v_high);
            v_sum128 = _mm_hadd_ps(v_sum128, v_sum128);
            v_sum128 = _mm_hadd_ps(v_sum128, v_sum128);
            
            // Store the final float scalar into the result matrix
            data->result[i][j] = _mm_cvtss_f32(v_sum128);
        }
    }
    
    pthread_exit(NULL);
}

void save_matrix_to_csv(const char *filename, float matrix[SIZE][SIZE]) {
    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        perror("Error opening output file");
        return;
    }
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            fprintf(fp, "%.4f", matrix[i][j]); // Save with 4 decimal places
            if (j < SIZE - 1) fprintf(fp, ",");
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
    printf("Result saved to %s\n", filename);
}

int main() {
    FILE *fp = fopen("./input-matrix.csv", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return 1;
    }

    // Align arrays to 32 bytes for optimal AVX loads
    __attribute__((aligned(32))) float matrix1[SIZE][SIZE];
    __attribute__((aligned(32))) float matrix2[SIZE][SIZE];
    __attribute__((aligned(32))) float result[SIZE][SIZE];

    // Read first matrix
    read_matrix(fp, matrix1);
    
    // Read second matrix
    read_matrix(fp, matrix2);

    fclose(fp);

    struct timespec start, end;
    
    // Start measuring time
    clock_gettime(CLOCK_MONOTONIC, &start);

    // Create threads
    pthread_t threads[NUM_THREADS];
    ThreadData thread_args[NUM_THREADS];
    
    int rows_per_thread = SIZE / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; i++) {
        thread_args[i].start_row = i * rows_per_thread;
        // Assign the remaining rows to the last thread to be safe
        thread_args[i].end_row = (i == NUM_THREADS - 1) ? SIZE : (i + 1) * rows_per_thread;
        
        thread_args[i].m1 = matrix1;
        thread_args[i].m2 = matrix2;
        thread_args[i].result = result;
        
        int rc = pthread_create(&threads[i], NULL, compute_rows, (void*)&thread_args[i]);
        if (rc) {
            fprintf(stderr, "Error: unable to create thread, %d\n", rc);
            exit(-1);
        }
    }

    // Wait for all threads to complete
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    // Stop measuring time
    clock_gettime(CLOCK_MONOTONIC, &end);

    double time_taken = (end.tv_sec - start.tv_sec) + 
                        (end.tv_nsec - start.tv_nsec) / 1e9;

    save_matrix_to_csv("./output-matrix-fp32-avx2.csv", result);

    printf("\nCompute Time (FP32 AVX2 with 8 Threads): %.3f ms\n", time_taken * 1000);

    return 0;
}