function WriteSDI(StreamName)
% ETSI Telecomunicacion
% Universidad Rey Juan Carlos
% Lee una trama de Video igital Serie SDI
% ReadSDI('Stream1_TypeA.sdi');

close('all');

% Stream SDI de entrada
FileIDIn = fopen(StreamName,'r');
if FileIDIn <0
    fprintf('***** Error al abrir el Stream SDI %s *****\n', StreamName);
    fclose(FileIDIn);
    return;
end

%inicializo las variables
Count=0;
DataWord=0;
TRS=uint16(zeros(1,4));
TRSHeader =uint16([1023, 0, 0]);

while (DataWord~=1023)
    DataWord = uint16(fread(FileIDIn, 1, 'uint16'));
    Count=Count+1;
end

% Compruebo que es un TRS
TRS(1,1)=DataWord;
TRS(1,2)=uint16(fread(FileIDIn, 1, 'uint16'));
TRS(1,3)=uint16(fread(FileIDIn, 1, 'uint16'));
if TRS(1,1:3)~= TRSHeader
    error('\n***** Stream corrompido. Encontrado un patron distitno a 0x3FF 0x000 0x000 *****\n');
else
    fprintf('\n- El Primer TRS encontrado esta a %d words \n', Count);
end

% Compruebo si es un EAV o un SAV


% Si es un EAV me pongo a buscar de nuevo TRS

% Si es un SAV leo la primera linea de video, pero no se su longitud
% Leo hasta encontrarme un TRS




fclose(FileIDIn);

% figure;
% imshow(CbYCrY,[0 1023],'InitialMagnification','fit');
% title('Frame IN');
