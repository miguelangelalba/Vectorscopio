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

% ---------------------------------------------------------------------------
function [Y, Cb, Cr] = Read_YUV(FileID, filas, columnas, YSize, CbCrSize, BitDepth)

    if BitDepth<9
        buffer = uint8(fread(FileID, YSize, 'uint8'));
        Y = reshape(buffer, columnas, filas);
        Y=Y';

        BCb = uint8(fread(FileID, CbCrSize, 'uint8'));
        % Solo 422
        Cb = reshape(BCb, columnas/2, filas);
        Cb=Cb';

        BCr = uint8(fread(FileID, CbCrSize, 'uint8'));
        % Solo 422
        Cr = reshape(BCr, columnas/2, filas);
        Cr=Cr';

    else
        buffer = uint16(fread(FileID, YSize, 'uint16'));
        Y = reshape(buffer, columnas, filas);
        Y=Y';

        BCb = uint16(fread(FileID, CbCrSize, 'uint16'));
        % Solo 422
        Cb = reshape(BCb, columnas/2, filas);
        Cb=Cb';

        BCr = uint16(fread(FileID, CbCrSize, 'uint16'));
        % Solo 422
        Cr = reshape(BCr, columnas/2, filas);
        Cr=Cr';
end
% --------------------------------------------------------------------------
function [Cb4,Cr4] = cbcr2tocbcr4(Cb,Cr,resize_matrix)
    Cb4 = [];
    Cr4 = [];
    for i=1:size(Cb,1)
        %Saco los vectores de la matriz y sonreescribo dicha variable
        Vlinecb = Cb(i,:);
        Vlinecr = Cr(i,:);
        Cb4 = [Cb4;interpola2to4(Vlinecb,resize_matrix)];
        Cr4 = [Cr4;interpola2to4(Vlinecr,resize_matrix)];
        i = i+1;
    end
    Cb4 = uint8(Cb4);
    Cr4 = uint8(Cr4);
    


    % Esto es para probar no tine nada que ver con el pg

% --------------------------------------------------------------------------

function Vline4 = interpola2to4(Vline,resize_matrix)
% line = vector que contiene los puntos de muestra 
% Metodo predeterminado "linear"
    [n_filas, n_columnas] = size(Vline);
    index = [1:n_columnas];
    disp(index);
    Vline4 = interp1(index,double(Vline),resize_matrix,'cubic');
    Vline4 = round(Vline4);
    disp(Vline4);

function [resize_matrix] = create_resize_matrix (size)
    resize_matrix = [];
    for i = 1:size
        if i ==1 
            resize_matrix(i) = i;
        else 
            resize_matrix(i) = resize_matrix(i-1) +0.5;

        end
        i = i+1;
    end
 







