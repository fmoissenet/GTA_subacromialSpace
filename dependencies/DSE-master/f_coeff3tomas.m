function [ coeff3tomas ] = f_coeff3tomas( alphas, alphaj, betas, betaj )
%UNTITLED5 Summary of this function goes here
% ' C�lculo del factor F2 para el SMR de Romana seg�n las funciones cont�nuas de Roberto Tom�s et al 2007
% ' Adri�n Riquelme, Enero 2014
% ' alphas: azimuth of dip vector of slope, in degrees
% ' alphaj: azimith of dip vector of discontinuity in degrees
% ' betas: value of dip vector of the discontinuity, in degrees
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
%    SMRTool, Copyright (C) 2015 Adri�n Riquelme Guill
%    SMRTool comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.
aux = abs(alphas - alphaj);
coeff3tomas=zeros(size(aux));
I=find(aux>180); aux(I)=360-aux(I);
I=find(aux>=90); coeff3tomas(I) = -13 - 1 / 7 * atan(betas + betaj(I) - 120) * 180 / pi;
I=find(aux<90); coeff3tomas(I) = -30 + 1 / 3 * atan(betaj(I) - betas) * 180 / pi;
% if aux > 180 
%     aux = 360 - aux;
% % end
% if aux >= 90 
%     %rotura vuelco
%     coeff3tomas = -13 - 1 / 7 * atan(betas + betaj - 120) * 180 / pi;
%     else
%     %rotura Cu�a/Plana
%     coeff3tomas = -30 + 1 / 3 * atan(betaj - betas) * 180 / pi;
% end


end

