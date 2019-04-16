import matlab.engine
import numpy as np
import matplotlib.pyplot as plt

video_width = 720
video_height = 576

#Function to map values from 0:1023 to -0.5:0.5 for chroma components
def map_value(x, in_min, in_max, out_min, out_max):

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;


eng = matlab.engine.start_matlab()

rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)

#Cr is the Y axis
#Cb is the X axis

x_axis = []
y_axis = []


for i in range(0, video_width):
    for x in range(0, video_height):
        x_axis.append(map_value(Cb4[x][i], 0, 1023, -0.5, 0.5))
        y_axis.append(map_value(Cr4[x][i], 0, 1023, -0.5, 0.5))


plt.scatter(x_axis, y_axis, c="#7266ff", alpha=0.5)
axes = plt.gca()
plt.axis([-0.5,0.5,-0.5, 0.5])
axes.set_xlabel("Cb Component")
axes.set_ylabel("Cr component")
plt.title("Vectorscope")
plt.show()
