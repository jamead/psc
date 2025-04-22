import numpy as np
import matplotlib.pyplot as plt

# Parameters
num_points = 8000
amplitude = 131072*3.9 

# Time base: 0 to 2π (full cosine period)
t = np.linspace(0, 2 * np.pi, num_points)

# Raised cosine full period: starts at 0, up to 1, down to 0
raised_cosine = 0.5 * (1 - np.cos(t))  # From 0 to 1 and back to 0
scaled_int_cosine = np.round(raised_cosine * amplitude).astype(int)

# Plot it
plt.figure(figsize=(10, 4))
plt.plot(scaled_int_cosine, label='Full Raised Cosine (int)')
plt.title('Raised Cosine Full Period (0 → 30000 → 0)')
plt.xlabel('Sample Index')
plt.ylabel('Amplitude')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

# Optional: Save to file
np.savetxt("raised_cosine_full_8000pts.txt", scaled_int_cosine, fmt='%d')



