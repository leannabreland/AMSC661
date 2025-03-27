function mesh2d_problem4
% mesh2d_problem4 Triangulate three shapes using Darren Engwirda's MESH2D package.
% Make sure the MESH2D package is added to your MATLAB path.

    % Triangulate L-shape
    figure;
    [vert, tri] = triangulate_L_shape;
    patch('Faces', tri, 'Vertices', vert, 'FaceColor', 'none', 'EdgeColor', 'k');
    axis equal off;
    title('L-shape Triangulation');

    % Triangulate Pentagon with a Pentagon Hole
    figure;
    [vert, tri] = triangulate_pentagon;
    patch('Faces', tri, 'Vertices', vert, 'FaceColor', 'none', 'EdgeColor', 'k');
    axis equal off;
    title('Pentagon with a Pentagon Hole Triangulation');

    % Triangulate Semicircle Bowl with Two Holes
    figure;
    [vert, tri] = triangulate_semicircle;
    patch('Faces', tri, 'Vertices', vert, 'FaceColor', 'none', 'EdgeColor', 'k');
    axis equal off;
    title('Semicircle Bowl with Two Holes Triangulation');
end

function [vert, tri] = triangulate_L_shape
    % Define an L-shape as the unit square with the top-right quarter removed.
    node = [0, 0;
            1, 0;
            1, 0.5;
            0.5, 0.5;
            0.5, 1;
            0, 1;
            0, 0];  % Closing the loop
    edge = [1 2; 2 3; 3 4; 4 5; 5 6; 6 7];
    [vert, tri] = refine2(node, edge);
end

function [vert, tri] = triangulate_pentagon
    % Define an outer regular pentagon and a smaller, concentric inner pentagon.
    center = [0.5, 0.5];
    theta = linspace(0, 2*pi, 6); theta(end) = [];
    R_outer = 0.4;
    R_inner = 0.2;
    outer = [center(1) + R_outer*cos(theta)', center(2) + R_outer*sin(theta)'];
    inner = [center(1) + R_inner*cos(theta)', center(2) + R_inner*sin(theta)'];
    
    % Concatenate nodes: first outer boundary, then inner boundary.
    node = [outer; inner];
    nOuter = size(outer,1);
    nInner = size(inner,1);
    edgeOuter = [(1:nOuter)', [2:nOuter, 1]'];
    edgeInner = [((nOuter+1):(nOuter+nInner))', [((nOuter+2):(nOuter+nInner)), nOuter+1]'];
    edge = [edgeOuter; edgeInner];
    [vert, tri] = refine2(node, edge);
end

function [vert, tri] = triangulate_semicircle
    % Define a semicircle (approximated by an arc and a straight diameter)
    % and two circular holes approximated by polygons.
    nArc = 50;
    theta_arc = linspace(0, pi, nArc)';
    R = 0.5;
    center_arc = [0.5, 0];
    arc = [center_arc(1) + R*cos(theta_arc), center_arc(2) + R*sin(theta_arc)];
    diameter = [1, 0; 0, 0];
    outerBoundary = [arc; diameter];
    
    % Hole 1: centered at (0.3, 0.25) with radius 0.1
    nHole = 30;
    theta_hole = linspace(0, 2*pi, nHole+1)'; 
    theta_hole(end) = [];
    hole1 = [0.3 + 0.1*cos(theta_hole), 0.25 + 0.1*sin(theta_hole)];
    
    % Hole 2: centered at (0.7, 0.25) with radius 0.1
    hole2 = [0.7 + 0.1*cos(theta_hole), 0.25 + 0.1*sin(theta_hole)];
    
    % Combine boundaries: outer boundary first, then holes.
    node = [outerBoundary; hole1; hole2];
    nOuter = size(outerBoundary,1);
    nHole1 = size(hole1,1);
    nHole2 = size(hole2,1);
    edgeOuter = [(1:nOuter)', [2:nOuter, 1]'];
    edgeHole1 = [(nOuter+1:nOuter+nHole1)', [nOuter+2:nOuter+nHole1, nOuter+1]'];
    edgeHole2 = [(nOuter+nHole1+1:nOuter+nHole1+nHole2)', [nOuter+nHole1+2:nOuter+nHole1+nHole2, nOuter+nHole1+1]'];
    edge = [edgeOuter; edgeHole1; edgeHole2];
    [vert, tri] = refine2(node, edge);
end
