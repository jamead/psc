#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Function to calculate the smooth transition (based on the original C expression)
double smooth_transition(double s1, double s2, int ramp_step, int T) {
    return s1 + ((s2 - s1) * 0.5 * (1.0 - cos(ramp_step * M_PI / T)));
}

int main(int argc, char *argv[]) {
    // Check that the correct number of command-line arguments is provided
    if (argc != 4) {
        printf("Usage: %s <s1> <s2> <T>\n", argv[0]);
        return 1;
    }

    // Parse command-line arguments
    double s1 = atof(argv[1]);  // Starting value
    double s2 = atof(argv[2]);  // Ending value
    int T = atoi(argv[3]);     // Number of steps

    printf("S1=%f  S2=%f  T=%d\n",s1,s2,T);
    // Open the output file for writing
    FILE *file = fopen("smooth_output.txt", "w");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    // Write the header to the file
    fprintf(file, "Ramp Step, Transition Value\n");

    // Calculate the smooth transition for each ramp step and write to the file
    for (int ramp_step = 0; ramp_step <= T; ramp_step++) {
        double transition = smooth_transition(s1, s2, ramp_step, T);
        fprintf(file, "%d, %.6f\n", ramp_step, transition);
    }

    // Close the file
    fclose(file);

    printf("Output written to smooth_output.txt\n");

    return 0;
}

