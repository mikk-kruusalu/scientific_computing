L = 1;
H = 0.1;
W = 0.5;

Nl = 100;
Nh = 10;
Nw = 50;
//+
SetFactory("OpenCASCADE");
Box(1) = {0, 0, 0, L, W, H};
//+
Transfinite Curve {2, 4, 6, 8} = Nw Using Progression 1;
//+
Transfinite Curve {10, 9, 11, 12} = Nl Using Progression 1;
//+
Transfinite Curve {5, 7, 3, 1} = Nh Using Progression 1;
//+
Transfinite Surface {3};
//+
Transfinite Surface {6};
//+
Transfinite Surface {4};
//+
Transfinite Surface {5};
//+
Transfinite Surface {2};
//+
Transfinite Surface {1};
//+
Recombine Surface {6, 5, 3, 1, 4, 2};

Transfinite Volume {1};

Mesh 3;
Save "cube.msh";