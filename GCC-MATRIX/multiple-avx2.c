#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <immintrin.h> // Required for AVX2 intrinsics

#define SIZE 256

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

int main() {
    FILE *fp = fopen("./input-matrix.csv", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return 1;
    }

    // Align arrays to 32 bytes for optimal AVX2 loads
    __attribute__((aligned(32))) int matrix1[SIZE][SIZE];
    __attribute__((aligned(32))) int matrix2[SIZE][SIZE];
    __attribute__((aligned(32))) int result[SIZE][SIZE];

    // Read first matrix
    read_matrix(fp, matrix1);
    
    // Read second matrix
    read_matrix(fp, matrix2);

    fclose(fp);

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    // Single-threaded AVX2 Matrix Multiplication
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            // Initialize sum vector to 0
            __m256i v_sum = _mm256_setzero_si256();
            
            // Loop unrolled by 8 since an AVX2 register holds eight 32-bit integers
            for (int k = 0; k < SIZE; k += 8) {
                // Load 8 integers from each matrix using 32-byte aligned load
                __m256i v_m1 = _mm256_load_si256((__m256i*)&matrix1[i][k]);
                __m256i v_m2 = _mm256_load_si256((__m256i*)&matrix2[j][k]);
                
                // Multiply the 8 integers together
                __m256i v_prod = _mm256_mullo_epi32(v_m1, v_m2);
                
                // Add the product to the running sum
                v_sum = _mm256_add_epi32(v_sum, v_prod);
            }
            
            // Fast Horizontal Add: Reduce the 8 integers in v_sum down to a single integer
            __m128i v_low = _mm256_castsi256_si128(v_sum);
            __m128i v_high = _mm256_extracti128_si256(v_sum, 1);
            __m128i v_sum128 = _mm_add_epi32(v_low, v_high);
            v_sum128 = _mm_hadd_epi32(v_sum128, v_sum128);
            v_sum128 = _mm_hadd_epi32(v_sum128, v_sum128);
            
            // Store the final integer scalar into the result matrix
            result[i][j] = _mm_cvtsi128_si32(v_sum128);
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    double time_taken = (end.tv_sec - start.tv_sec) + 
                        (end.tv_nsec - start.tv_nsec) / 1e9;

    save_matrix_to_csv("./output-matrix-avx2.csv", result);

    printf("\nCompute Time (AVX2 Single Thread): %.3f ms\n", time_taken * 1000);

    return 0;
}