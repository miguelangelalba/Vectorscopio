function [frames_array] = sdi_reader(StreamName)

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

frames_array = [];

%lee un frame de la trama SDI e interpola sus componentes
for x = 1:2
    
    [Y, Cb, Cr] = read_video_frame(FileIDIn);
    [Cb4, Cr4] = cbcr2tocbcr4(Cb,Cr);
    frames_array{x}.Y = Y;
    frames_array{x}.Cb4 = Cb4;
    frames_array{x}.Cr4 = Cr4;
end
%Muestra la Y, Cb, Cr
%figure;
%imshow(frames_array{1,1}(1,1).Y,[0 2^(10)-1],'InitialMagnification','fit');

%figure;
%imshow(frames_array{1,1}(1,1).Cb4,[0 2^(10)-1],'InitialMagnification','fit');

%figure;
%imshow(frames_array{1,1}(1,1).Cr4,[0 2^(10)-1],'InitialMagnification','fit');

fclose(FileIDIn);


function [Y, Cb, Cr] = read_video_frame(FileIDIn)
total_lines_video = 0;
total_lines_vsync = 0;

Y = [];
Cb = [];
Cr = [];

%Lee las 625 lineas de un frame completo. Si es video activo, añade la
%línea al array de y, cb, cr. Si no, lo tira.
for x = 1:625
    
    [video, vsync, new_Y, new_Cb, new_Cr] = read_line_from_SDI(FileIDIn);
    total_lines_video = total_lines_video + video;
    total_lines_vsync = total_lines_vsync + vsync;
    if isempty(new_Y) ~= 1
        Y = [Y;new_Y];
        Cb = [Cb;new_Cb];
        Cr = [Cr;new_Cr];
    end
end
%fprintf("Finished reading video frame");



function [video, vsync, Y, Cb, Cr] = read_line_from_SDI(FileIDIn)

%esta funcion lee una linea de video SDI desde el unicio de un EAV
video = 0;
vsync = 0;

Y = [];
Cb = [];
Cr = [];

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

%if XYZ_bin(2) == 1
 %   fprintf("Field 1\n");
%else
 %   fprintf("Field 0\n");
%end

if XYZ_bin(3) == 1
    %fprintf("Vertical Sync\n");
    vsync = 1;
else
    %fprintf("Active Video\n");
    video = 1;
end

%if XYZ_bin(4) == 1
 %   fprintf("EAV\n");
%else
 %   fprintf("SAV\n");
%end

fprintf("\n");

%El formato de video nativo de SD-SDI es 4:2:2
%Tira el HANC y el SAV
for i = 1:284
    word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
 
end

%Desde aqui, se lee la informacion de luma y croma o se tira el vanc
[Y, Cb, Cr] = read_payload(FileIDIn, video);


function [Y, Cb, Cr] = read_payload(FileIDIn, is_active)

%Según el tipo de payload, lo tira o lo guarda porque es vídeo activo

Y = [];
Cb = [];
Cr = [];

if is_active == 1
    for counter = 1:360
    
        Cb0 = uint16(fread(FileIDIn, 1, 'uint16'));
        Cb0 = map_value_10b(Cb0, 16, 240, 64, 960);
        Cb = [Cb, Cb0];
        
        Y0 = uint16(fread(FileIDIn, 1, 'uint16'));
        Y0 = map_value_10b(Y0, 16, 235, 64, 940);
        Y = [Y, Y0];
        
        Cr0 = uint16(fread(FileIDIn, 1, 'uint16'));
        Cr0 = map_value_10b(Cr0, 16, 240, 64, 960);
        Cr = [Cr, Cr0];
        
        Y1 = uint16(fread(FileIDIn, 1, 'uint16'));
        Y1 = map_value_10b(Y1, 16, 235, 64, 940);
        Y = [Y, Y1];
    
    end
else
    
    for counter = 1:360
        %Tiro las words porque es VANC
        word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
        word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
        word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
        word_to_discard = uint16(fread(FileIDIn, 1, 'uint16'));
    
    end
end


function output = map_value_10b(value,fromLow,fromHigh,toLow,toHigh)

   A = value-fromLow;
   B = toHigh - toLow;
   C = fromHigh - fromLow;
   D = double(A)*B;
   E = D/C;
   output = uint16(E + toLow);




