import matlab.engine
import numpy as np
import matplotlib.pyplot as plt

OldMax = 1023
OldMin = 0
NewMax_Cb = 1
NewMax_Cr = 2*np.pi
NewMin_Cb = 0
NewMin_Cr = 0

eng = matlab.engine.start_matlab()

rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)

fig = plt.figure()
ax = fig.add_subplot(111, projection='polar')
c = ax.scatter(theta_array, r)
plt.show()
