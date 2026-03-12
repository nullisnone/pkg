import csv

def generate_csv():
    filename = 'input-matrix.csv'
    # Pattern: 1, 2, 3, 4 repeated to fill 128 columns (32 repetitions)
    row_data = [1, 2, 3, 4] * 32 
    
    with open(filename, 'w', newline='') as f:
        writer = csv.writer(f)
        
        # Write Matrix A (128 rows)
        for _ in range(128):
            writer.writerow(row_data)
            
        # Write Matrix B (128 rows)
        for _ in range(128):
            writer.writerow(row_data)

    print(f"Generated {filename} with two 128x128 matrices (256 rows, 128 columns).")

if __name__ == "__main__":
    generate_csv()