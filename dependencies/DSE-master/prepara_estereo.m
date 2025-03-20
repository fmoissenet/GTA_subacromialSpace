function [planos_estereo]=prepara_estereo(planos)
% Partimos de que tenemos la matriz planos, con informaci�n de todos los
% vectores normales de los planos obtenidos
% w: direcci�n del vector buzamiento
% b: �ngulo del buzamiento respecto a la horizontal
% La salida ser�a la matriz planos_estereo, de dimensi�n n de puntos y dos
% columnas. En la primera columna se encuentra el valor de w y en la
% segunda el de b
% input
% - planos: matriz que contiene la ecuaci�n de cada plano, ABCD
% output
% - planos_estereo: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w y b
% w: �ngulo que forma la l�nea de m�xima pendiente con el norte OY
% b: �ngulo que forma la l�nea de m�xima pendiente con su proyecci�n
% horizontal
[np,~] = size ( planos );
planos_estereo = zeros (np,2);
for j=1:np
    [w,b]=vnor2vbuz(planos(j,1),planos(j,2),planos(j,3));
    planos_estereo(j,1)=w;
    planos_estereo(j,2)=b;
end
% guardamos en un archivo estereo.txt para el stereo32
% son los vectores buzamiento, luego son los planos
% fi = fopen('stereo.txt', 'w') ;
% for k=1:np
%     fprintf(fi,  '%f %f	P \n', planos_estereo(k,1)/pi*180,planos_estereo(k,2)/pi*180);
% end
% 
% fclose(fi);

end