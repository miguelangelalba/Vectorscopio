function [rgb_image, R, G, B, Y, Cb4, Cr4] = yuv_reader(StreamName)
% ETSI Telecomunicacion
% Universidad Rey Juan Carlos
% Lee una secuejncia de video YCbCr Planar
% Procesa_Video('Burger_720x576_P422_8b_25Hz.yuv');
% Procesa_Video('F1_720x576_P422_8b_25Hz.yuv');

close('all');

Rows= 576;% 576; % 486 %2160;   % 1080;
Cols= 720; %3840; % 1920;
Subsampling=422; % 422  420
BitDepth=8;  % 8; % 10;
FrameRate=25; % 25 % 50
NumFrames= 220; %220
BitDepth_Display = 10;


% Stream YCbCr de entrada
FileIDIn = fopen(StreamName,'r');
if FileIDIn <0
    fprintf('***** Error al abrir el Stream SDI %s *****\n', StreamName);
    fclose(FileIDIn);
    return;
end

% Calculo le tama�o del frame Y y de las componentes Cb y Cr en funcion del
% submuestreo de croma
if Subsampling==422
    YSize= Rows*Cols;
    CbCrSize=YSize/2;
end

% Leo el primer frame de video

[Y, Cb, Cr]=Read_YUV_422_10b(FileIDIn, Rows, Cols, YSize, CbCrSize, BitDepth);

% Visualizo la lY
%figure;
%imshow(Y,[0 2^(BitDepth)-1],'InitialMagnification','fit');
%title('Frame IN');
[Cb4, Cr4] = cbcr2tocbcr4(Cb,Cr);
%figure;
%imshow(Y,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
%figure;
%imshow(Cb4,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
%figure;
%imshow(Cr4,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
% Proceso el video

[rgb_image, R, G, B] = ycbcr_to_rgb(Y, Cb4, Cr4);

%imshow(R,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
%title('R COMPONENT');
%figure, imshow(G,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
%title('G COMPONENT');
%figure, imshow(B,[0 2^(BitDepth_Display)-1],'InitialMagnification','fit');
%title('B COMPONENT');

%imtool(rgb_image);

fclose(FileIDIn);
