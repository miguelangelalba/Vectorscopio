import matlab.engine
import numpy as np
import matplotlib.pyplot as plt

#Function to map values from 0:1023 to -0.5:0.5 for chroma components
def map_value(x, in_min, in_max, out_min, out_max):

    #Esta función pasa los valores de croma a un rango de -0.5 a 0.5 para poder representarlos en el vectorscopio

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


def get_video_frame(video_width, video_height):

    #De momento, como el código de matlab solo devuelve un frame, esta función solo obtiene la información de un frame.
    #Lo ideal sería modificar el código de matlab para que devolviese la información de todos los frames y luego desde aquí
    #poder elergir el frame o línea que se quiere ver.

    eng = matlab.engine.start_matlab()

    #rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)
    Y, Cb4, Cr4, frames_array = eng.sdi_reader('Stream2_TypeA.sdi', nargout=4)

#Cr is the Y axis
#Cb is the X axis

    x_axis = []
    y_axis = []


    for i in range(0, video_width):
        for x in range(0, video_height):
            x_axis.append(map_value(Cb4[x][i], 0, 1023, -0.5, 0.5))
            y_axis.append(map_value(Cr4[x][i], 0, 1023, -0.5, 0.5))

    return x_axis, y_axis
    #x es cb e y es cr


def draw_vectorscope():

    #prepara el vectorscopio base

    color_coordinates_x = [-0.147, -0.289, 0.437, 0.290, 0.148, -0.436]
    color_coordinates_y = [0.5, -0.5, -0.100, 0.5, -0.5, 0.100]

    plt.scatter(color_coordinates_x, color_coordinates_y, s=[300], c=["#ff0000","#00ff00" ,"#0000ff", "#ff00ff", "#00ffff", "#ffff00"], alpha=1.0)
    plt.scatter(color_coordinates_x, color_coordinates_y, s=[20], c=["#000000","#000000" ,"#000000", "#000000", "#000000", "#000000"], alpha=1.0)
    axes = plt.gca()
    plt.axis([-0.6,0.6,-0.6, 0.6])
    plt.xticks(np.arange(-0.6, 0.6, step=0.1))
    plt.yticks(np.arange(-0.6, 0.6, step=0.1))
    axes.set_xlabel("Cb Component")
    axes.set_ylabel("Cr component")
    plt.title("Vectorscope")
    #plt.scatter(x_axis, y_axis, c="#7266ff", alpha=0.5)


def draw_video_info(x_axis, y_axis):

    #Dibuja el rayo de color

    plt.plot(x_axis, y_axis, c="#7266ff", alpha=0.5)
    plt.show()


def main():

    video_width = 720
    video_height = 576

    x_axis, y_axis = get_video_frame(video_width, video_height)
    draw_vectorscope()
    draw_video_info(x_axis, y_axis)


main()
