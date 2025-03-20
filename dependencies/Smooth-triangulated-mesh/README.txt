For those with the error "Undefined function or variable 'smoothpatch_curvature_double'.", you first need to compile the 'c' code using mex:
mex smoothpatch_curvature_double.c -v
mex smoothpatch_inversedistance_double.c -v
mex vertex_neighbours_double.c -v