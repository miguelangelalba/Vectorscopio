
function [Cb4,Cr4] = cbcr2tocbcr4(Cb,Cr)
    Cols= 720;
    resize_matrix = create_resize_matrix(Cols);
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
    Cb4 = uint16(Cb4);
    Cr4 = uint16(Cr4);
end

function Vline4 = interpola2to4(Vline,resize_matrix)
Cols= 720;
% line = vector que contiene los puntos de muestra
% Metodo predeterminado "linear"
    [n_filas, n_columnas] = size(Vline);
    index = [1:n_columnas];
    %disp(index);
    Vline4 = interp1(index,double(Vline),resize_matrix,'pchip');
    Vline4 = round(Vline4);
    %disp(Vline4);
end


function [resize_matrix] = create_resize_matrix (size)
    Cols= 720;
    resize_matrix = [];
    for i = 1:size
        if i ==1
            resize_matrix(i) = i;
        else
            resize_matrix(i) = resize_matrix(i-1) +0.5;

        end
        i = i+1;
    end
end
