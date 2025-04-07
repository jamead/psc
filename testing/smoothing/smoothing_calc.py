import numpy as np
import matplotlib.pyplot as plt
import argparse

# Function to calculate the smooth transition (based on the original C expression)
def smooth_transition(s1, s2, ramp_step, T):
    return s1 + ((s2 - s1) * 0.5 * (1.0 - np.cos(ramp_step * np.pi / T)))

# Main function
def main():
    # Argument parser for command-line parameters
    parser = argparse.ArgumentParser(description="Plot smooth transition between s1 and s2.")
    parser.add_argument('s1', type=float, help="Starting value (s1)")
    parser.add_argument('s2', type=float, help="Ending value (s2)")
    parser.add_argument('T', type=int, help="T value (total number of steps)")
    
    # Parse the arguments
    args = parser.parse_args()
    
    s1 = args.s1
    s2 = args.s2
    T = args.T
    
    # Generate values for ramp_step from 0 to T
    ramp_steps = np.arange(0, T+1)
    
    # Calculate the smooth transition for each ramp step
    transitions = [smooth_transition(s1, s2, step, T) for step in ramp_steps]
    
    # Plot the results
    plt.plot(ramp_steps, transitions, label=f'Smooth transition from {s1} to {s2}')
    plt.xlabel('Ramp Step')
    plt.ylabel('Transition Value')
    plt.title(f'Smooth Transition: {s1} to {s2}')
    plt.grid(True)
    plt.legend()
    plt.show()

# Execute the script
if __name__ == "__main__":
    main()

