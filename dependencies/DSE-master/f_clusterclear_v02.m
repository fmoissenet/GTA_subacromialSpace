function [ puntos_familia_cluster, familia_cluster_plano, polos_estereoppalasignados_limpio ] = f_clusterclear_v02( puntos_familia_cluster_fullclusters, familia_cluster_plano_fullclusters , ds, ppcluster, polos_estereoppalasignados_fullclusters)
% [ puntos_familia_cluster, familia_cluster_plano, polos_estereoppalasignados ] = f_clusterclear_v02( puntos_familia_cluster_fullclusters, familia_cluster_plano_fullclusters , ds, ppcluster, polos_estereoppalasignados)
% Funci�n cluster clear: limpieza de clusters
% puntos_familia_cluster_fullclusters: xyz ds c
% familia_cluster_plano_fullclusters: ds, cluster, n puntos cluster, abcd
% ds: famila sobre la que se va a actuar
% ppcluster: n�mero m�nimo de puntos por cluster que va a tener esa DS
% polos_estereoppalasignados: los polos que van junto con los puntos, se
% modifican con estos cambios
% Si ds=0 se asume que se aplica el filtro sobre todos los clusters
%    Copyright (C) {2015}  {Adri�n Riquelme Guill, adririquelme@gmail.com}
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%   with this program; if not, write to the Free Software Foundation, Inc.,
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%    Discontinuity Set Extractor, Copyright (C) 2015 Adri�n Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

% renombro las variables para que sea m�s f�cil programar
A=puntos_familia_cluster_fullclusters;
B=familia_cluster_plano_fullclusters;
C=polos_estereoppalasignados_fullclusters;


% iniciamos la matriz con los puntos filtrados
puntos_salida = zeros(size(A));
polos_salida=zeros(size(C));
contador_puntos_salida=1;


% busco los clusters del ds que cumplen con el m�nimo n�mero de pts p
% cluster
if ds == 0
    % se aplica el filtro sobre todas las familias
    I = find(B(:,3)>=ppcluster);
    familia_cluster_plano = B(I,:);
    
    % familias que han superado el filtro
    familiasok=unique(familia_cluster_plano(:,1));
    [nfamiliasok,~]=size(familiasok); % n�mero de familias que superan el filtro
    for i=1:nfamiliasok
        familia = familiasok(i);
        % busco los clusters de esa familia
        I=find(familia_cluster_plano(:,1)==familia);
        clusters=unique(familia_cluster_plano(I,2)); % clusters que han superado el filtro, familia estudiada
        % en los puntos, busco aquellos de las familias y clusters que han
        % superado el filtro
        I=find(A(:,4)==familia);
        puntos_auxiliar = A(I,:);
        polos_auxiliar = C(I,:);
        [indice]=f_findarray (puntos_auxiliar(:,5), clusters);
        puntos_auxiliar=puntos_auxiliar(indice,:);
        polos_auxiliar=polos_auxiliar(indice,:);
        [npuntos_auxiliar,~]=size(puntos_auxiliar);
        posicion_inicial=contador_puntos_salida;
        posicion_final=contador_puntos_salida+npuntos_auxiliar-1;
        puntos_salida(posicion_inicial:posicion_final,:)=puntos_auxiliar;
        polos_salida(posicion_inicial:posicion_final,:)=polos_auxiliar;
        contador_puntos_salida=posicion_final+1;
        
    end
    % redimensiono puntos_salida a su tama�o final
    puntos_familia_cluster=puntos_salida(1:posicion_final,:);
    polos_estereoppalasignados_limpio=polos_estereoppalasignados_fullclusters(1:posicion_final,:);
else
    % el filtro se aplica s�lo en la familia seleccionada
    I = find(B(:,3)>=ppcluster & B(:,1)==ds);
    familia_cluster_plano = B(I,:);
    
    % familias que han superado el filtro
    familiasok=unique(familia_cluster_plano(:,1));
    [nfamiliasok,~]=size(familiasok); % n�mero de familias que superan el filtro
    for i=1:nfamiliasok
        familia = familiasok(i);
        % busco los clusters de esa familia
        I=find(familia_cluster_plano(:,1)==familia);
        clusters=unique(familia_cluster_plano(I,2)); % clusters que han superado el filtro, familia estudiada
        % en los puntos, busco aquellos de las familias y clusters que han
        % superado el filtro
        I=find(A(:,4)==familia);
        puntos_auxiliar = A(I,:);
        polos_auxiliar=C(I,:);
        [indice]=f_findarray (puntos_auxiliar(:,5), clusters);
        puntos_auxiliar=puntos_auxiliar(indice,:);
        polos_auxiliar=polos_auxiliar(indice,:);
        [npuntos_auxiliar,~]=size(puntos_auxiliar);
        posicion_inicial=contador_puntos_salida;
        posicion_final=contador_puntos_salida+npuntos_auxiliar-1;
        puntos_salida(posicion_inicial:posicion_final,:)=puntos_auxiliar;
        polos_salida(posicion_inicial:posicion_final,:)=polos_auxiliar;
        contador_puntos_salida=posicion_final+1;
        
    end
    % redimensiono puntos_salida a su tama�o final
    puntos_salida=puntos_salida(1:posicion_final,:);
    polos_salida=polos_salida(1:posicion_final,:);
    % puntos salida tiene �nicamente el DS seleccionado, hay que reordenar
    % el conjunto de puntos salida
    I=find(A(:,4)~=ds);
    puntos_salida2=A(I,:);
    polos_salida2=C(I,:);
    puntos_familia_cluster=[puntos_salida; puntos_salida2];
    polos_estereoppalasignados_limpio=[polos_salida; polos_salida2];
    % preparo la salida de familia_cluster_plano
    I = find(B(:,1)~=ds);
    familia_cluster_plano2 = B(I,:);
    familia_cluster_plano=[familia_cluster_plano; familia_cluster_plano2];
    familia_cluster_plano = sortrows(familia_cluster_plano);
end


end




