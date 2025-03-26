import sys

import gmsh

gmsh.initialize()

L = 1.0  # Cube side length
H = 0.1
W = 1
Nl = 100  # Elements per edge
Nh = 10
Nw = 100
gmsh.model.occ.addBox(0, 0, 0, L, H, W)  # Create cube

# Synchronize OCC geometry
gmsh.model.occ.synchronize()

# Get all geometric entities
curves = gmsh.model.getEntities(dim=1)
surfaces = gmsh.model.getEntities(dim=2)
volumes = gmsh.model.getEntities(dim=3)

# Set transfinite curves
gmsh.model.mesh.setTransfiniteCurve(1, Nw)
gmsh.model.mesh.setTransfiniteCurve(3, Nw)
gmsh.model.mesh.setTransfiniteCurve(5, Nw)
gmsh.model.mesh.setTransfiniteCurve(7, Nw)

gmsh.model.mesh.setTransfiniteCurve(2, Nh)
gmsh.model.mesh.setTransfiniteCurve(4, Nh)
gmsh.model.mesh.setTransfiniteCurve(6, Nh)
gmsh.model.mesh.setTransfiniteCurve(8, Nh)

gmsh.model.mesh.setTransfiniteCurve(9, Nl)
gmsh.model.mesh.setTransfiniteCurve(10, Nl)
gmsh.model.mesh.setTransfiniteCurve(11, Nl)
gmsh.model.mesh.setTransfiniteCurve(12, Nl)

# Set transfinite surfaces and recombination
for surface in surfaces:
    gmsh.model.mesh.setTransfiniteSurface(surface[1])
    gmsh.model.mesh.setRecombine(*surface)

# Set transfinite volume and recombination
for volume in volumes:
    gmsh.model.mesh.setTransfiniteVolume(volume[1])
    gmsh.model.mesh.setRecombine(*volume)

# Generate 3D mesh
gmsh.model.mesh.generate(3)

# Write and display
gmsh.write("cube.msh")
if "-nopopup" not in sys.argv:
    gmsh.fltk.run()

gmsh.finalize()
