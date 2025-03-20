function [ persistence_dip, persistence_dipdir ] = f_persistence( P, dipdir, dip )
% funci�n que calcula la dimensi�n m�xima de un cluster de puntos en 3D
% seg�n dos direcciones: direcci�n de buzamiento y direcci�n de plano
% Inputs: 
% P: nube de puntos 3D, en un SR cartesiano donde OY est� orientado al
% norte
% dipdir: direcci�n de buzamiento en radiantes
% dip: buzamiento en radiantes
% Adri�n Riquelme, diciembre 2015

% calculo la matriz de rotaci�n
[ R ] = f_dipdirdip2R( dipdir, dip );

% Calculo las coordenadas de los puntos en el nuevo SR, donde OX tiene la
% direcci�n del buzamiento, OY de la direcci�n del plano y el OZ del vector
% normal al plano

P1=P*R;

%% C�lculo de la persistencia en la direcci�n del vector de buzamiento


end

function [ R ] = f_dipdirdip2R( dipdir, dip )
% [ R ] = f_dipdirdip2R( dipdir, dip )
% Funci�n que calcula la matriz de rotaci�n de la base can�nica a un SR
% compuesto por tres vectores:
% v1: vector buzamiento, OX
% v2: vector direcci�n: OY
% v3: vector normal: OZ
% Inputs: dipdir, dip en radianes
% Adri�n Riquelme, diciembre 2015

R= [cos(dip)*cos(pi/2-dipdir) cos(pi-dipdir) sin(dip)*cos(pi/2-dipdir);
    cos(dip)*sin(pi/2-dipdir) sin(pi-dipdir) sin(dip)*sin(pi/2-dipdir);
    sin(dip) 0 cos(dip)];


end


