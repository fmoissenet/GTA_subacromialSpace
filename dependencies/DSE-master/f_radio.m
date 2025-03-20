function [radio]=f_radio(beta)
% Funci�n que calcula el radio del c�rculo en funci�n del �ngulo de
% buzamiento
radio = sin(beta)/(1+cos(beta));
end