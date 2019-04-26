# Vectorscopio

Vectorscopio para archivos .yuv y archivos provenientes de tramas SDI .sdi

para ejecutarlo:

python3 Vectorscope.py archivo_SDi_de_entrada Número_de_frames_a_leer

Para ello, se necesita tener instalado:

Matlab engine for python: navegar hasta la carpeta donde Matlab está instalado:

cd "matlabroot\extern\engines\python"

python setup.py install

Matplotlib:

python -m pip install -U pip

python -m pip install -U matplotlib

Ir a la carpeta donde Python está instalado y copiar todos los contenidos de la carpeta tcl
en la carpeta Lib
