function [rgb_image] = YCbCr_To_RGB(Y, Cb4, Cr4)
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
  end
  m = m+1;
end 

%aquí ya deberían estar las matrices RGB rellenas. Para conseguir la matriz combinada se hace esto siguiente

rgb_image = cat(3, R, G, B);