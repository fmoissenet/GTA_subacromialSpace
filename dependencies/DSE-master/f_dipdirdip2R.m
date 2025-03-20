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
    -sin(dip) 0 cos(dip)];


end

