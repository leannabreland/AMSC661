function mesh2d_problem4

    hdata.hmax = 0.04; 

    figure(1); clf;
    [nodeL, edgeL] = shape_L_viaHole();
    [vertL, triL]  = refine2(nodeL, edgeL, [], hdata);
    triL = fallbackTri(vertL, triL);
    patch('Faces',triL,'Vertices',vertL,'FaceColor','none','EdgeColor','k');
    axis equal off;
    title('L-shape: top-right corner removed');

    figure(2); clf;
    [nodeP, edgeP] = shape_pentagon_starLines();
    [vertP, triP]  = refine2(nodeP, edgeP, [], hdata);
    triP = fallbackTri(vertP, triP);
    patch('Faces',triP,'Vertices',vertP,'FaceColor','none','EdgeColor','k');
    axis equal off;
    title('Pentagon with star lines');

    figure(3); clf;
    [nodeS, edgeS] = shape_halfcircle_top_holes();
    [vertS, triS]  = refine2(nodeS, edgeS, [], hdata);
    triS = fallbackTri(vertS, triS);
    patch('Faces',triS,'Vertices',vertS,'FaceColor','none','EdgeColor','k');
    axis equal off;
    title('Half-circle (flat at y=1) with two holes');
end

function tri = fallbackTri(vert, tri)
    if isempty(tri) || size(tri,2) ~= 3
        dt = delaunayTriangulation(vert);
        tri = dt.ConnectivityList;
    end
end

function [node, edge] = shape_L_viaHole()
    outer = [0,0; 1,0; 1,1; 0,1];
    nOut = size(outer,1);
    edgeOut = [(1:nOut-1)', (2:nOut)'; nOut,1]; 

    hole = [1,1; 0.5,1; 0.5,0.5; 1,0.5];
    hole = flipud(hole); 
    nHole = size(hole,1);
    off = nOut;
    edgeHole = [(off+1:off+nHole-1)', (off+2:off+nHole)'; off+nHole, off+1];

    node = [outer; hole];
    edge = [edgeOut; edgeHole];
end

function [node, edge] = shape_pentagon_starLines()
    c = [0.5,0.5];
    N = 5;
    angles = linspace(0,2*pi,N+1)'; 
    angles(end) = [];
    r = 0.4;
    poly = [c(1)+r*cos(angles), c(2)+r*sin(angles)];
    nP = size(poly,1);

    edgeOut = [(1:nP-1)', (2:nP)'; nP,1];

    starEdges = [1,3; 3,5; 5,2; 2,4; 4,1];

    node = poly;
    edge = [edgeOut; starEdges];
end

function [node, edge] = shape_halfcircle_top_holes()
    nArc = 16;
    center = [0.5,1];
    r = 0.5;
    theta = linspace(0,pi,nArc+1)';
    theta(end) = []; 
    arc = [center(1)+r*cos(theta), center(2)-r*sin(theta)];

    nodeOut = [0,1; 1,1; arc];
    nOut = size(nodeOut,1);
    edgeOut = [(1:nOut-1)', (2:nOut)'; nOut,1];

    cHole1 = [0.3,0.75];
    cHole2 = [0.7,0.75];
    rHole = 0.12;
    nSeg = 12;
    aHole = linspace(0,2*pi,nSeg+1)';
    aHole(end) = [];
    aHole = flipud(aHole);
    hole1 = [cHole1(1)+rHole*cos(aHole), cHole1(2)+rHole*sin(aHole)];
    hole2 = [cHole2(1)+rHole*cos(aHole), cHole2(2)+rHole*sin(aHole)];
    nH1 = size(hole1,1);
    nH2 = size(hole2,1);
    off1 = nOut;
    edgeH1 = [(off1+1:off1+nH1-1)', (off1+2:off1+nH1)'; off1+nH1, off1+1];
    off2 = nOut + nH1;
    edgeH2 = [(off2+1:off2+nH2-1)', (off2+2:off2+nH2)'; off2+nH2, off2+1];

    node = [nodeOut; hole1; hole2];
    edge = [edgeOut; edgeH1; edgeH2];
end
