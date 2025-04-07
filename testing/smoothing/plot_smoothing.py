import matplotlib.pyplot as plt

# Initialize lists to hold the data
ramp_steps = []
transition_values = []

# Open the output file and read the data
with open("smooth_output.txt", "r") as file:
    # Skip the header line
    next(file)
    
    # Read each line and parse the ramp step and transition value
    for line in file:
        ramp_step, transition = line.strip().split(", ")
        ramp_steps.append(int(ramp_step))
        transition_values.append(float(transition))

# Create the plot
plt.figure(figsize=(10, 6))
plt.plot(ramp_steps, transition_values, label='Smooth Transition', color='b')

# Add labels and title
plt.xlabel("Ramp Step")
plt.ylabel("Transition Value")
plt.title("Smooth Transition from s1 to s2")
plt.grid(True)
plt.legend()

# Show the plot
plt.show()

