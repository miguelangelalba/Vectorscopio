import matlab.engine
import numpy as np
import matplotlib.pyplot as plt


eng = matlab.engine.start_matlab()

rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)

# Fixing random state for reproducibility
np.random.seed(19680801)

# Compute areas and colors
N = 150
r = 2 * np.random.rand(N)
theta = 2 * np.pi * np.random.rand(N)
area = 200 * r**2
colors = theta

fig = plt.figure()
ax = fig.add_subplot(111, projection='polar')
c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)
plt.show()
