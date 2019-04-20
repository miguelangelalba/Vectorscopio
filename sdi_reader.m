function [Y, Cb, Cr] = sdi_reader(StreamName)

%abre el fichero e invoca a leer linea de video todas las veces necesarias
close('all');

FileIDIn = fopen(StreamName,'r');
if FileIDIn <0
    fprintf('***** Error al abrir el Stream SDI %s *****\n', StreamName);
    fclose(FileIDIn);
    return;
end

Y = [];
Cb = [];
Cr = [];
%esto obtiene las 576 lineas de video en SD
for x = 1:576
    [new_Y, new_Cb, new_Cr] = read_line_from_SDI(FileIDIn);
    Y = [Y;new_Y];
    Cb = [Cb;new_Cb];
    Cr = [Cr;new_Cr];
end

%en este punto, se tienen las matrices de Y, Cb y Cr, sin interpolar

fclose(FileIDIn);

function [Y, Cb, Cr] = read_line_from_SDI(FileIDIn)

%esta funcion lee una linea de video SDI

Count=0;
DataWord=0;
TRS=uint16(zeros(1,4));
TRSHeader =uint16([1023, 0, 0]);

while (DataWord~=1023)
    DataWord = uint16(fread(FileIDIn, 1, 'uint16'));
    Count=Count+1;
end

TRS(1,1)=DataWord;
TRS(1,2)=uint16(fread(FileIDIn, 1, 'uint16'));
TRS(1,3)=uint16(fread(FileIDIn, 1, 'uint16'));
if TRS(1,1:3)~= TRSHeader
    error('\n***** Stream corrompido. Encontrado un patron distitno a 0x3FF 0x000 0x000 *****\n');
%else
    %fprintf('\n- El Primer TRS encontrado esta a %d words \n', Count);
end

%del XYZ, hay que comprobar que la linea es de video activo.
%se convierte el XYZ a binario para inspeccionar si la linea es video
%activo o si vien es borrado vertical
XYZ = uint16(fread(FileIDIn, 1, 'uint16'));
XYZ_bin = de2bi(XYZ, 'left-msb');

%El formato de video nativo de SD-SDI es 4:2:2
%se tira el HANC y el SAV
for i = 1:284
    word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
 
end

%Desde aqui, se lee la informacion de luma y croma
[Y, Cb, Cr] = read_ycbcr(FileIDIn);


function [Y, Cb, Cr] = read_ycbcr(FileIDIn)

Y = [];
Cb = [];
Cr = [];

for counter = 1:360
    
    Cb0 = uint16(fread(FileIDIn, 1, 'uint16'));
    Cb = [Cb, Cb0];
    Y0 = uint16(fread(FileIDIn, 1, 'uint16'));
    Y = [Y, Y0];
    Cr0 = uint16(fread(FileIDIn, 1, 'uint16'));
    Cr = [Cr, Cr0];
    Y1 = uint16(fread(FileIDIn, 1, 'uint16'));
    Y = [Y, Y1];
    
end






