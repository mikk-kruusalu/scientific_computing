L = 1;
H = 0.1;
W = 0.5;

Nl = 100;
Nh = 10;
Nw = 50;

SetFactory("OpenCASCADE");
Box(1) = {0, 0, 0, L, W, H};

// Cylinder parameters (radius=0.05, height=0.1)
r = 0.03;

// Create 5 cylinders along x-axis
For i In {1:5}
    y_pos = i * 0.1 - 0.05; // Spaced by 0.2 units
    Cylinder(i+1) = {0, y_pos, H/2, L, 0, 0, r, 2*Pi};
EndFor

BooleanDifference{ Volume{1}; Delete;}{ Volume{2:6}; }

tol = L/1000;
Mesh.CharacteristicLengthMin = L/50;
Mesh.CharacteristicLengthMax = L/50 + tol;

//Physical Surface("Load", 40) = {27};
//Physical Surface("Fixed", 41) = {22};
//Physical Surface("Cylinder", 42) = {7, 10, 13, 16, 19};

//Physical Volume("Matrix", 43) = {1};
//Physical Volume("Fibres", 44) = {2, 3, 4, 5, 6};

Mesh 3;
Save "cube_50.msh";
