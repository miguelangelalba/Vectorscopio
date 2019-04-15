import matlab.engine
import numpy as np
import matplotlib.pyplot as plt


def map_value(x, in_min, in_max, out_min, out_max):

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;



eng = matlab.engine.start_matlab()

rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)


mapped_Cb = [[0], [0]]
mapped_Cr = [[0], [0]]


for i in range(0, 720):
    for x in range(0, 576):
        print(x, i)
        mapped_Cb[x][i] = map_value(Cb4[x][i], 0, 1023, -0.5, 0.5)
        mapped_Cr[x][i] = map_value(Cr4[x][i], 0, 1023, -0.5, 0.5)

#Cr is the Y axis
#Cb is the X axis

x = []
y = []
colors = np.random.rand(3)

plt.scatter(x, y, c=colors, alpha=0.5)
plt.show()
