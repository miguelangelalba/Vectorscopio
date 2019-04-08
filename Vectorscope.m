function Procesa_Video(StreamName)
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
resize_matrix = create_resize_matrix(Cols);


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
[Y, Cb, Cr]=Read_YUV(FileIDIn, Rows, Cols, YSize, CbCrSize, BitDepth);

% Visualizo la lY
%figure;
%imshow(Y,[0 2^(BitDepth)-1],'InitialMagnification','fit');
title('Frame IN');
[Cb4, Cr4] = cbcr2tocbcr4(Cb,Cr,resize_matrix);
figure;
imshow(Y,[0 2^(BitDepth)-1],'InitialMagnification','fit');
figure;
imshow(Cb4,[0 2^(BitDepth)-1],'InitialMagnification','fit');
figure;
imshow(Cr4,[0 2^(BitDepth)-1],'InitialMagnification','fit');

% Proceso el video

fclose(FileIDIn);

%Ahora tenemos los vectores de Y, Cb, Cr de dimensiones 720 columnas y 576 filas. Convertir a RGB
%Para SD, la conversión de YCbCr a RGB es una matriz específica
% [R] = [1  0      1.402]
% [G] = [1 -0.344 -0.714]
% [B] = [1  1.772  0    ]

conversion_matrix = [1 0 1.402; 1 -0.344 -0.714; 1 1.772 0];
R = [];
G = [];
B = [];

rgb_result = [];

for m = 1:Cols %720
  for n = 1:Rows  %576

    rgb_result = conversion_matrix * [Y(n,m);Cb4(n,m);Cr4(n,m)]; %Esto da una matriz [R; G; B]
    R(n,m) = rgb_result(1,1);
    G(n,m) = rgb_result(2,1);
    B(n,m) = rgb_result(3,1);
    n = n+1;

  m = m+1;

%aquí ya deberían estar las matrices RGB rellenas. Para conseguir la matriz combinada se hace esto siguiente

rgb_image = cat(3, R, G, B);
figure;
imshow(rgb_image);
