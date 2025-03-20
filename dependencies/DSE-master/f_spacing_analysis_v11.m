function [ optimalbandwidth, Smean] = f_spacing_analysis_v11( Base, js, bandwidth, pathname)
% Funci�n que calcula el espaciado seg�n varios m�todos
% representados cobran importancia frente a los menos representados.
% Input:
% - Base xyz-js-c-abcd 
% - js: n�mero del joint set que quiere que calculemos
% - bandwidth: ancho del kernel, si no decimos nada se pone el optimo
% - pathname: ruta donde generar los archivos de salida
% Output
% - optimalbandwidth: ancho del kernel optimizado para los valores
% - spacing: valor del espaciado propuesto
% Configuraci�n
% - espaciadominimo: tama�o m�nimo entre dos clusters para que se considere
% en el c�lculo
% - reducci�n del n�mero de cl�sters para la b�squeda de vecinos 
% Los estad�sticos de los espaciados calculados son
% - min
% - max
% - mean: media
% - mode: moda
% - mas density: valor m�ximo de la densidad
% - std dev: desviaci�n t�pica
% knnfast 0 si se reducen los puntos del cl�ster un 90%, 1 si se calcula con todos
% comments
% la matriz espaciado tiene las siguientes columnas:
% columna 1: DS
% columna 2: cluster inicial
% columna 3: cluster final
% columna 4: |Di - Dj|
% columna 5: Di
% columna 6: Dj

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

 
% Configuraci�n
espaciadominimo=0.01; % establecemos un valor de espaciado m�nimo
knnfast=1; % 1 no se reduce nada, 0 si reducimos los puntos un 90% 

% iniciamos la barra de avance


ii=js;
puntos=Base(Base(:,4)==js,:); %puntos del js de entrada
clusters=unique(puntos(:,5));

% calculamos las posiciones de cada cluster
D = zeros(size(clusters)); % aqu� pondr� la posici�n del plano de cada cl
[nclusters,~]=size(clusters);
for i=1:nclusters
    I = find(puntos(:,5)==clusters(i));
    % D(i)=puntos(I(i),9);
    D(i)=puntos(I(1),9); % valor D del plano de cada cluster
end

[ncs,~]=size(clusters); % n�mero de clusters

% si el n�mero de clusters es mayor que 1, podemos calcular alg�n
% espaciado, en caso contrario no hago nada
if ncs > 1 && max(D)~=min(D)
    % inicio el waitbar para ver c�mo avanza el tema
    h=waitbar(0,'Calculating spacings. Please wait');
    % ordenamos los clusters seg�n su valor de D
    [ ~ , Disortedindex ]=sort(D);

    % calculo la distancia entre los puntos m�s cercanos
    espaciado=zeros(ncs-1,6);
    espaciado2D=zeros(ncs-1,6);

    %iniciamos los puntos del cluster no i, al principio son todos
    pcni=Base(Base(:,4)==js,:); 

    % C�lculo de los espaciados
    for i=1:(ncs-1) % recorremos todos los clusters del joint set estudiado
        % el �ltimo cluster ya no se compara con ninguno
        cluster = clusters(Disortedindex(i)); % cluster i, empezando por menor Di a mayor Di
        pci=Base(Base(:,4)==js & Base(:,5)==cluster,:); %pci puntos del cluster i
        D1=Base(Base(:,4)==js & Base(:,5)==cluster,9); 
        D1=D1(1);% posici�n del plano del cluster i
        [npci,~]=size(pci); % npci n�mero de puntos del cluster i
        pcni=pcni(pcni(:,5)~=cluster,:); % puntos del cl no i, quitamos los del cl i
        % reducimos el n�mero de puntos del cl�ster
        if knnfast==0 
            if npci>10
                n=npci*0.1;
            else
                n=npci;
            end
            I=unique(floor(rand(floor(n),1)*n)); I=I(I>0);
            pci=pci(I,:); % puntos del cluster i reduciendo el n de puntos

            % pcni puntos que no son del cluster i, con posici�n dif al cl i
            % la reducci�n hay que hacerla para cada cluster, para no perderlos
            auxclni=unique(pcni(:,5)); % clusters no i
            [auxnclni,~]=size(auxclni); % n�mero de clusters no i
            for j=1:auxnclni
                auxpcni=pci(pci(:,5)==auxclni(j),:);
                [auxnpcni,~]=size(auxpcni);
                if auxnpcni>10
                    n=auxnpcni*0.1;
                else
                    n=auxnpcni;
                end
                I=unique(floor(rand(floor(n),1)*n)); I=I(I>0);
                auxpcni=auxpcni(I,:); % hemos reducido el n�mero de puntos a buscar el siguiente cluster
            end

            pcni=[pcni, auxpcni];
        else
            % no hacemos nada
        end
        [~,distancias]=knnsearch(pci(:,1:3),pcni(:,1:3),'NSMethod','kdtree','distance','euclidean','k',1);
        % idx es la posici�n en pcni donde se ha encontrado el punto m�s
        % cercano para el punto en cuest�on de pci
        % distancias es la distancia del punto al punto m�s cercano de pcni
        [~,I] = min(distancias); % I es el �ndice donde se ha encontrado la m�nima distancia de
        clusternoi=pcni(I,5);
        D2=Base(Base(:,4)==js & Base(:,5)==clusternoi,9); D2=D2(1); %posici�n del cluster m�s cercano
        espaciado(i,1)=js; 
        espaciado(i,2)=cluster;
        espaciado(i,3)=clusternoi;
        espaciado(i,4)=abs(D1-D2);
        espaciado(i,5)=D1;
        espaciado(i,6)=D2;

        % calculo el espaciado seg�n el m�todo persistencia infinita en full
        % persistence
        cluster2d = clusters(Disortedindex(i+1));
        D2=Base(Base(:,4)==js & Base(:,5)==cluster2d,9); D2=D2(1); %posici�n del cluster m�s cercano
        espaciado2D(i,1)=js; 
        espaciado2D(i,2)=cluster;
        espaciado2D(i,3)=cluster2d;
        espaciado2D(i,4)=abs(D1-D2);
        espaciado2D(i,5)=D1;
        espaciado2D(i,6)=D2;    
        waitbar(i/ncs,h);
    end
    close(h);

    %% c�lculos para el m�todo de espaciados non-persistence

    % Quitamos los valores inferiores al espaciado m�nimo
    espaciadobruto=espaciado; % guardo los valores del espaciado para la salida
    espaciado=espaciado(espaciado(:,4)>espaciadominimo,:);

    % eliminamos aquellos valores en los que los clusters tienen la misma
    % posici�n
    [~,ia]=unique(espaciado(:,4));
    espaciado=espaciado(ia,:);
    [~,ia]=unique(espaciado2D(:,4));
    espaciado2D=espaciado2D(ia,:);
    
    % calculamos la funci�n de densidad con el kde
    if bandwidth == 0
        [fdensidad, xgrid, optimalbandwidth]=ksdensity(espaciado(:,4));
        ancho=optimalbandwidth;
    else
        [fdensidad, xgrid]=ksdensity(espaciado(:,4),'width',bandwidth);
        optimalbandwidth=0; ancho=bandwidth;
    end

    % calculo los estad�sticos del espaciado:
    % Smin, Smax, Smean, Smode, Smaxdensity, Sstddev
    Smin  = min(espaciado(:,4));
    Smax  = max(espaciado(:,4));
    Smean = mean(espaciado(:,4));
    Sstddev = std(espaciado(:,4));

    % calculo la moda
    X = sort(espaciado(:,4));
    indices   =  find(diff([X; realmax]) > 0); % indices where repeated values change
    [~,i] =  max (diff([0; indices]));     % longest persistence length of repeated values
    Smode=X(indices(i));

    % calculo el valor m�ximo de los espaciados
    [~,I] = max(fdensidad);
    Smaxdensity=xgrid(I);

    % hacemos el test de contraste de hip�tesis
    [nespaciadosnonulos,~]=size(unique(espaciado(:,4)));
    if nespaciadosnonulos>=4
        h = lillietest(espaciado(:,4),'Distr','exp');
    else
        h=1;
    end

    % escribimos la salida del test de contraste de hip�tesis

    archivo=[pathname,'js-',num2str(js),'-nfp-cl1-cl2-s-D1-D2.txt'];
    fileID=fopen(archivo,'w');
    fprintf(fileID,'Test for the exponential distribution. Ho: null hypothesis, the data follows an exponential distribution. \n');
    if h==0
        fprintf(fileID,'Ho is not rejected. lillietest does not reject the null hypothesis at the default 5 percent significance level. \n \n');
    else
        if nespaciadosnonulos>=4
            fprintf(fileID,'Ho is rejected. lillietest rejects the null hypothesis at the default 5 percent significance level. \n \n');
        else
            fprintf(fileID,'There are not enough number of spacings to carry out the test. \n \n');
        end
    end

    % escribimos la salida de los espaciados
    fprintf(fileID,['Spacings. J_',num2str(ii),'. Bandwidth = ',num2str(ancho),char(10),'Min=',num2str(Smin),'; Max=',num2str(Smax),'; Max density=',num2str(Smaxdensity),'; Mode=',num2str(Smode),'; Mean=',num2str(Smean),'; Std dev = ', num2str(Sstddev),'\n']);
    fprintf(fileID,'JointSet InitialCluster FinalCluster Spacing D1 D2\n'); % el \n es para l�nea nueva
    fclose(fileID);
    dlmwrite([pathname,'js-',num2str(js),'-nfp-cl1-cl2-s-D1-D2.txt'],espaciadobruto,  'delimiter', '\t','-append');

    %% C�lculos del espaciado con persistencia infinita full persistence

    espaciadobruto2D=espaciado2D; % guardo los valores del espaciado para la salida
    espaciado2D=espaciado2D(espaciado2D(:,4)>espaciadominimo,:);

    % calculo la funci�n de densidad no param�trica
    [fdensidad2D, xgrid2D, ancho2D]=ksdensity(espaciado2D(:,4));

    % calculo los estad�sticos del espaciado 2D:
    % Smin, Smax, Smean, Smode, Smaxdensity, Sstddev
    Smin2D  = min(espaciado2D(:,4));
    Smax2D  = max(espaciado2D(:,4));
    Smean2D = mean(espaciado2D(:,4));
    Sstddev2D = std(espaciado2D(:,4));

    % calculo la moda
    X = sort(espaciado2D(:,4));
    indices   =  find(diff([X; realmax]) > 0); % indices where repeated values change
    [~,i] =  max (diff([0; indices]));     % longest persistence length of repeated values
    Smode2D=X(indices(i));

    % calculo el valor m�ximo de los espaciados
    [~,I] = max(fdensidad2D);
    Smaxdensity2D=xgrid2D(I);

    % represento los espaciados 3d y 2d superpuestos
    figure('name',['Joint spacing: non and full persistence. Joint set number ',num2str(ii)],'Position', [100, 100, 400, 300]); 
    plot(xgrid, fdensidad, 'b--', xgrid2D, fdensidad2D, 'g-');
    xlabel('Spacing'); 
    ylabel('Density function'); 
    title(['Spacings. J_',num2str(ii),'. S: (1) = ',num2str(Smean),'; (2) = ',num2str(Smean2D),'; ',num2str(nclusters),' clusters']);
    % title(['Spacings. J_',num2str(ii),'. Bandwidth: 3D = ',num2str(ancho),'; 2D = ',num2str(ancho2D),'; ',num2str(nclusters),' clusters',char(10),'3D -- Min=',num2str(Smin),'; Max=',num2str(Smax),'; Max dens=',num2str(Smaxdensity),'; Mode=',num2str(Smode),'; Mean=',num2str(Smean),char(10),'2D -- Min=',num2str(Smin2D),'; Max=',num2str(Smax2D),'; Max dens=',num2str(Smaxdensity2D),'; Mode=',num2str(Smode2D),'; Mean=',num2str(Smean2D)]);
    legend('(1) Non-persistent','(2) Full persistent');

    % hacemos el test de contraste de hip�tesis
    [nespaciados2Dnonulos,~]=size(unique(espaciado2D(:,4)));
    if nespaciados2Dnonulos>=4
        h = lillietest(espaciado2D(:,4),'Distr','exp');
    else
        h=1;
    end

    archivo=[pathname,'js-',num2str(js),'-fp-cl1-cl2-s-D1-D2.txt'];
    fileID=fopen(archivo,'w');
    fprintf(fileID,'Test for the exponential distribution. Ho: null hypothesis, the data follows an exponential distribution. \n');
    if h==0
        fprintf(fileID,'Ho is not rejected. lillietest does not reject the null hypothesis at the default 5 percent significance level. \n \n');
    else
        if nespaciados2Dnonulos>=4
            fprintf(fileID,'Ho is rejected. lillietest rejects the null hypothesis at the default 5 percent significance level. \n \n');
        else
            fprintf(fileID,'There are not enough number of spacings to carry out the test. \n \n');
        end
    end

    % escribimos la salida de los espaciados
    fprintf(fileID,['Spacings 2D. J_',num2str(ii),'. Bandwidth = ',num2str(ancho2D),char(10),'Min=',num2str(Smin2D),'; Max=',num2str(Smax2D),'; Max density=',num2str(Smaxdensity2D),'; Mode=',num2str(Smode2D),'; Mean=',num2str(Smean2D), '; Std dev = ', num2str(Sstddev2D),'\n']);
    fprintf(fileID,'JointSet InitialCluster FinalCluster Spacing D1 D2\n'); % el \n es para l�nea nueva
    fclose(fileID);
    dlmwrite([pathname,'js-',num2str(js),'-fp-cl1-cl2-s-D1-D2.txt'],espaciadobruto2D,  'delimiter', '\t','-append');

    % guardamos la imagen
    name_png = [pathname,'figure-spacings-js',num2str(js),'.png'];
    name_pdf = [pathname,'figure-spacings-js',num2str(js),'.pdf'];
    % export_fig(name, '-m2.5', '-transparent');
    fig = gcf; fig.PaperPositionMode = 'auto'; % Para forzar a que mantenga el aspecto
    saveas(gcf, name_png);
    saveas(gcf, name_pdf);
else
    optimalbandwidth = 0;
    Smean = 0;
    h = msgbox('I could not calculate the spacing. Please, check the clusters','Error');
end
end
