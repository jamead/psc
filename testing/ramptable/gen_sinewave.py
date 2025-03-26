import numpy as np
import math

# Parameters
frequency = 1  # Hz
sample_rate = 10000  # Hz
duration = 4.0  # seconds
amplitude = 32767  # Max integer value for signed 16-bit

# Time vector
t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)

# Generate sine wave
sine_wave = (amplitude * np.sin(2 * np.pi * frequency * t)).astype(int)

# Write to file
with open("sine_wave.txt", "w") as file:
    for sample in sine_wave:
        file.write(f"{sample}\n")

print("Sine wave file generated: sine_wave.txt")
