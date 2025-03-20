function [center, radius] = fitSphere(points)
    % Solve for the center and radius of the least squares fit sphere
    
    % Prepare the design matrix A and vector b
    A = [2*points(:,1), 2*points(:,2), 2*points(:,3), ones(size(points,1), 1)];
    b = sum(points.^2, 2);
    
    % Solve the linear system A * x = b for [xc, yc, zc, R^2]
    x = A\b;
    
    % Extract the center coordinates
    center = x(1:3);
    
    % Calculate the radius
    radius = sqrt(x(4) + sum(center.^2));
end