function [rgb_image, R, G, B] = ycbcr_to_rgb(Y, Cb4, Cr4)

Cols = 720;
Rows = 576;
%Ahora tenemos los vectores de Y, Cb, Cr de dimensiones 720 columnas y 576 filas. Convertir a RGB
%Para SD, la conversión de YCbCr a RGB es una matriz específica
% [R] = [1  0      1.402] [Y]
% [G] = [1 -0.344 -0.714] [Cb - 512]
% [B] = [1  1.772  0    ] [Cr - 512]
Y = double(Y);
Cb4 = double(Cb4);
Cr4 = double(Cr4);

conversion_matrix = [1 0 1.402; 1 -0.344 -0.714; 1 1.772 0];
R = [];
G = [];
B = [];

rgb_result = [];

for m = 1:Cols %720
  for n = 1:Rows  %576

    rgb_result = conversion_matrix * [Y(n,m);Cb4(n,m)-512;Cr4(n,m)-512]; %Esto da una matriz [R; G; B]
    R(n,m) = uint16(rgb_result(1,1));
    G(n,m) = uint16(rgb_result(2,1));
    B(n,m) = uint16(rgb_result(3,1));
    n = n+1;
  end
  m = m+1;
end 

R = uint16(R);
G = uint16(G);
B = uint16(B);
%aquí ya deberían estar las matrices RGB rellenas. Para conseguir la matriz combinada se hace esto siguiente

rgb_image = cat(3, R, G, B);
