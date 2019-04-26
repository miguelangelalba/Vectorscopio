import matlab.engine
import numpy as np
import matplotlib.pyplot as plt
import pickle
from matplotlib.widgets import Button
from itertools import islice
import sys

video_width = 720
video_height = 576

class frame_to_show:

    value = 0

class line_to_show:

    value = 0

class mode:
    value = 0
#Function to map values from 0:1023 to -0.5:0.5 for chroma components
def map_value(x, in_min, in_max, out_min, out_max):

    #Esta función pasa los valores de croma a un rango de -0.5 a 0.5 para poder representarlos en el vectorscopio

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


def get_video_frame(frame_to_show):


    #De momento, como el código de matlab solo devuelve un frame, esta función solo obtiene la información de un frame.
    #Lo ideal sería modificar el código de matlab para que devolviese la información de todos los frames y luego desde aquí
    #poder elergir el frame o línea que se quiere ver.

    #eng = matlab.engine.start_matlab()

    #rgb_image, R, G, B, Y, Cb4, Cr4 = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=7)
    #frames_array = eng.sdi_reader('Stream2_TypeA.sdi', nargout=1)

    #with open('frames.txt', 'wb') as fp:
        #pickle.dump(frames_array, fp)

    #with open("frames.txt", "rb") as fp:   # Unpickling
        #frames_array = pickle.load(fp)

#Cr is the Y axis
#Cb is the X axis
    #El primer índice de la Y es la altura y el segundo es el ancho
    #print(frames_array[0]['Y'][300][300])
    #Esto imprime, del primer frame, el primer valor de la Y
    x_axis = []
    y_axis = []


    for x in range(0, video_height):
        for i in range(0, video_width):
            if(i % 2 == 0):
                x_axis.append(map_value(frames_array[frame_to_show]['Cb4'][x][i], 0, 1023, -0.5, 0.5))
                y_axis.append(map_value(frames_array[frame_to_show]['Cr4'][x][i], 0, 1023, -0.5, 0.5))

    #x_axis = decimate(x_axis, 0.05)
    #y_axis = decimate(y_axis, 0.05)
    #print(len(x_axis))
    return x_axis, y_axis
    #x es cb e y es cr


def decimate(cols, proportion=1):

    return list(islice(cols, 0, len(cols), int(1/proportion)))

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
    video_info, = plt.plot(x_axis, y_axis, c="white", alpha=0.5)
    return video_info

def next_frame(event):

    if(frame_to_show.value+1 <= len(frames_array)-1):
        frame_to_show.value += 1
        #print(frame_to_show.value)
        x_axis, y_axis = get_video_frame(frame_to_show.value)
        video_info.set_xdata(x_axis)
        video_info.set_ydata(y_axis)
        plt.title("Frame: " + str(frame_to_show.value))
        line_to_show.value = 0
        #print(frame_to_show.value)
        plt.draw()

def change_mode(event):

    mode.value ^= 1
    x_axis, y_axis = get_video_frame(frame_to_show.value)

    if(mode.value == 1):
        #print("Line mode activated")
        video_info.set_xdata(x_axis[line_to_show.value:line_to_show.value+720])
        video_info.set_ydata(y_axis[line_to_show.value:line_to_show.value+720])
        plt.title("Line: " + str(line_to_show.value) + "\n" + "Frame:" + str(frame_to_show.value))
        plt.draw()

    else:
        #print("Frame mode activated")
        video_info.set_xdata(x_axis)
        video_info.set_ydata(y_axis)
        plt.title("Frame: " + str(frame_to_show.value))
        plt.draw()


def next_line(event):

    if(line_to_show.value+1 <= video_width-1):
        line_to_show.value += 1
        x_axis, y_axis = get_video_frame(frame_to_show.value)
        video_info.set_xdata(x_axis[line_to_show.value:line_to_show.value+720])
        video_info.set_ydata(y_axis[line_to_show.value:line_to_show.value+720])
        plt.title("Line: " + str(line_to_show.value) + "\n" + "Frame:" + str(frame_to_show.value))
        plt.draw()


def previous_line(event):

    if(line_to_show.value-1 >= 0):
        line_to_show.value -= 1
        x_axis, y_axis = get_video_frame(frame_to_show.value)
        video_info.set_xdata(x_axis[line_to_show.value:line_to_show.value+720])
        video_info.set_ydata(y_axis[line_to_show.value:line_to_show.value+720])
        plt.title("Line: " + str(line_to_show.value) + "\n" + "Frame:" + str(frame_to_show.value))
        plt.draw()


def previous_frame(event):

    if(frame_to_show.value-1 >= 0):
        frame_to_show.value -= 1
        #print(frame_to_show.value)
        x_axis, y_axis = get_video_frame(frame_to_show.value)
        video_info.set_xdata(x_axis)
        video_info.set_ydata(y_axis)
        plt.title("Frame: " + str(frame_to_show.value))
        line_to_show.value = 0
        #print(frame_to_show.value)
        plt.draw()


def main():

    global frames_array
    eng = matlab.engine.start_matlab()
    stream_in = sys.argv[1]
    frames_to_read = int(sys.argv[2])
    frames_array = eng.sdi_reader(stream_in, frames_to_read, nargout=1)
    #with open('frames.txt', 'wb') as fp:
        #pickle.dump(frames_array, fp)

    with plt.style.context(('dark_background')):

        #with open("frames.txt", "rb") as fp:   # Unpickling
            #frames_array = pickle.load(fp)

        x_axis, y_axis = get_video_frame(frame_to_show.value)
        draw_vectorscope()

        global video_info
        video_info = draw_video_info(x_axis, y_axis)
        #next frame button
        next_frame_axes = plt.axes([0.9, 0.8, 0.1, 0.065])
        next_frame_button = Button(next_frame_axes, 'Next frame.', color='0.5', hovercolor='green')
        next_frame_button.on_clicked(next_frame)

        #previous frame button
        previous_frame_axes = plt.axes([0.9, 0.7, 0.1, 0.065])
        previous_frame_button = Button(previous_frame_axes, 'Previous frame.', color='0.5', hovercolor='green')
        previous_frame_button.on_clicked(previous_frame)

        #next line button
        next_line_axes = plt.axes([0.9, 0.6, 0.1, 0.065])
        next_line_button = Button(next_line_axes, 'Next line.', color='0.5', hovercolor='green')
        next_line_button.on_clicked(next_line)

        previous_line_axes = plt.axes([0.9, 0.5, 0.1, 0.065])
        previous_line_button = Button(previous_line_axes, 'Previous line.', color='0.5', hovercolor='green')
        previous_line_button.on_clicked(previous_line)


        #change mode button
        change_mode_axes = plt.axes([0.9, 0.4, 0.1, 0.065])
        change_button = Button(change_mode_axes, 'Change Mode.', color='0.5', hovercolor='green')
        change_button.on_clicked(change_mode)

        plt.axes([0.9, 0.2, 0.1, 0.065])
        plt.title("Frame: " + str(frame_to_show.value))
        plt.axis('off')
        plt.show()




main()
