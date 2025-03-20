% -------------------------------------------------------------------------
% INIT THE WORKSPACE
% -------------------------------------------------------------------------
clearvars;
% close all;
warning off;
clc;

% -------------------------------------------------------------------------
% SET FOLDERS
% -------------------------------------------------------------------------
Folder.toolbox      = 'C:\Users\Florent\OneDrive - Université de Genève\_VALORISATION\articles\1- en cours\GTA\GTA_subacromialSpace\';
Folder.data         = Folder.toolbox;
Folder.export       = Folder.toolbox;
Folder.dependencies = [Folder.toolbox,'dependencies\'];
addpath(Folder.toolbox);
addpath(genpath(Folder.dependencies));
cd(Folder.data);

% -------------------------------------------------------------------------
% SET SUBJECT INFO
% -------------------------------------------------------------------------
Subject.id   = 'MODEL';
Subject.side = 'R'; % R or L

% -------------------------------------------------------------------------
% LOAD BONE GEOMETRY
% -------------------------------------------------------------------------
% Initialise bones
Bone(1).label = 'Humerus';
Bone(2).label = 'Scapula';
% Humerus
stlFile                      = 'humerus_anybody.stl';
Bone(1).label                = [Subject.side,'Humerus'];
temp                         = stlread(stlFile);
Bone(1).Static.Mesh.vertices = permute(temp.Points,[2,1,3]); % mm
Bone(1).Static.Mesh.faces    = permute(temp.ConnectivityList,[2,1,3]);
clear stlFile temp;
% Humerus region
stlFile                      = 'humerus_anybody_region.stl';
temp                         = stlread(stlFile);
Bone(1).Static.Mesh.vertices2 = permute(temp.Points,[2,1,3]); % mm
Bone(1).Static.Mesh.faces2    = permute(temp.ConnectivityList,[2,1,3]);
clear stlFile temp;
% Scapula
stlFile                      = 'scapula_anybody.stl';
Bone(2).label                = [Subject.side,'Scapula'];
temp                         = stlread(stlFile);
Bone(2).Static.Mesh.vertices = permute(temp.Points,[2,1,3]); % mm
Bone(2).Static.Mesh.faces    = permute(temp.ConnectivityList,[2,1,3]);
clear stlFile temp;
% Scapula region
stlFile                      = 'scapula_anybody_region.stl';
temp                         = stlread(stlFile);
Bone(2).Static.Mesh.vertices2 = permute(temp.Points,[2,1,3]); % mm
Bone(2).Static.Mesh.faces2    = permute(temp.ConnectivityList,[2,1,3]);
clear stlFile temp;

% -------------------------------------------------------------------------
% LOAD MOTION FILE
% -------------------------------------------------------------------------
GTA                         = 'GTA110';
xlsFile                     = 'humerusMotion.xlsx';
humerusMotion               = readmatrix(xlsFile,'Sheet',GTA);
xlsFile                     = 'scapulaMotion.xlsx';
scapulaMotion               = readmatrix(xlsFile,'Sheet',GTA);

% -------------------------------------------------------------------------
% APPLY MOTION
% -------------------------------------------------------------------------
for iframe = 1:size(humerusMotion,1)
    % Apply motion
    hrotation               = [humerusMotion(iframe,1) humerusMotion(iframe,2) humerusMotion(iframe,3); ...
                               humerusMotion(iframe,4) humerusMotion(iframe,5) humerusMotion(iframe,6); ...
                               humerusMotion(iframe,7) humerusMotion(iframe,8) humerusMotion(iframe,9)];
    htranslation            = [humerusMotion(iframe,10); humerusMotion(iframe,11); humerusMotion(iframe,12)];
    Bone(1).Motion.Mesh.vertices(:,:,iframe) = hrotation*Bone(1).Static.Mesh.vertices+htranslation;
    Bone(1).Motion.Mesh.vertices2(:,:,iframe) = hrotation*Bone(1).Static.Mesh.vertices2+htranslation;
    srotation               = [scapulaMotion(iframe,1) scapulaMotion(iframe,2) scapulaMotion(iframe,3); ...
                               scapulaMotion(iframe,4) scapulaMotion(iframe,5) scapulaMotion(iframe,6); ...
                               scapulaMotion(iframe,7) scapulaMotion(iframe,8) scapulaMotion(iframe,9)];
    stranslation            = [scapulaMotion(iframe,10); scapulaMotion(iframe,11); scapulaMotion(iframe,12)];
    Bone(2).Motion.Mesh.vertices(:,:,iframe) = srotation*Bone(2).Static.Mesh.vertices+stranslation;
    Bone(2).Motion.Mesh.vertices2(:,:,iframe) = srotation*Bone(2).Static.Mesh.vertices2+stranslation;
    % Compute distances
    X(:,:,iframe) = Bone(1).Motion.Mesh.vertices2(:,:,iframe)';
    Y(:,:,iframe) = Bone(2).Motion.Mesh.vertices2(:,:,iframe)';
    D(:,:,iframe) = pdist2(X(:,:,iframe),Y(:,:,iframe),'euclidean','Smallest',1);
end

% -------------------------------------------------------------------------
% PLOT
% -------------------------------------------------------------------------
figure(1);
for iframe = 1:size(humerusMotion,1)
    patch_array3(Bone(2).Static.Mesh.faces, ...
        [-Bone(2).Motion.Mesh.vertices(3, :, iframe); Bone(2).Motion.Mesh.vertices(2, :, iframe); Bone(2).Motion.Mesh.vertices(1, :, iframe)], ...
        [0.7 0.7 0.7], 'none', 'gouraud', 0.2);
    hold on; axis equal; camlight headlight;
    patch_array3(Bone(1).Static.Mesh.faces, ...
        [-Bone(1).Motion.Mesh.vertices(3, :, iframe); Bone(1).Motion.Mesh.vertices(2, :, iframe); Bone(1).Motion.Mesh.vertices(1, :, iframe)], ...
        [0.7 0.7 0.7], 'none', 'gouraud', 0.2);
    scatter3(-Bone(2).Motion.Mesh.vertices2(3,:,iframe),...
             Bone(2).Motion.Mesh.vertices2(2,:,iframe),...
             Bone(2).Motion.Mesh.vertices2(1,:,iframe),...
             5,D(:,:,iframe));
    patch_array3(Bone(1).Static.Mesh.faces2, ...
        [-Bone(1).Motion.Mesh.vertices2(3, :, iframe); Bone(1).Motion.Mesh.vertices2(2, :, iframe); Bone(1).Motion.Mesh.vertices2(1, :, iframe)], ...
        [0.0 0.1 0.0], 'none', 'gouraud', 0.8);
    patch_array3(Bone(2).Static.Mesh.faces2, ...
        [-Bone(2).Motion.Mesh.vertices2(3, :, iframe); Bone(2).Motion.Mesh.vertices2(2, :, iframe); Bone(2).Motion.Mesh.vertices2(1, :, iframe)], ...
        [0.0 1.0 0.0], 'none', 'gouraud', 0.8);
    pause(0.001);
    cla;
    hold off;
end
figure(2); hold on;
subplot(1,3,1); 
plot(squeeze(D)'); xlabel('Elevation angle (°)'); ylabel('All distances (mm)');
subplot(1,3,2);
plot(squeeze(mean(D,2))); xlabel('Elevation angle (°)'); ylabel('Mean distance (mm)');
subplot(1,3,3);
plot(squeeze(min(D,[],2))); xlabel('Elevation angle (°)'); ylabel('Min distance (mm)');