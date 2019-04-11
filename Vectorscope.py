import matlab.engine
eng = matlab.engine.start_matlab()
rgb_image, R, G, B = eng.Vectorscope('F1_720x576_P422_8b_25Hz.yuv', nargout=4)
