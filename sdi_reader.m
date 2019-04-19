function sdi_reader(StreamName)

%esta función encuentra el primer 3FF. Hay que mejorarlo para ver si es un
%EAV o un SAV
close('all');

FileIDIn = fopen(StreamName,'r');
if FileIDIn <0
    fprintf('***** Error al abrir el Stream SDI %s *****\n', StreamName);
    fclose(FileIDIn);
    return;
end

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
else
    fprintf('\n- El Primer TRS encontrado esta a %d words \n', Count);
end

read_from_EAV(FileIDIn)

fclose(FileIDIn);

function read_from_EAV(FileIDIn)

%se tira el HANC y el SAV
for i = 1:285
    data_word = uint16(fread(FileIDIn, 1, 'uint16'));
 
end

%A partir de aquí, la siguiente muestra es video activo , con el orden Cb0,
%Y0, Cr0, Y1, Cb2, Y2


