// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15809 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15809
//
// <-- Short Description -->
// HDF5 load/save was super slow for nested lists


N = 4;
n = 1000;
filters_sys = list();
filters_vec = list();
for i=1:n
    G=syslin("c", rand(N,N), rand(N,1), rand(1,N), rand(1,1));
    filters_sys($+1) = G;
    filters_vec($+1) = [G.a G.b;G.c G.d];
end

timer();
save("TMPDIR/filters_sys.sod", "filters_sys");
sys = timer()

save("TMPDIR/filters_vec.sod", "filters_vec");
vec = timer()

assert_checkfalse(sys > 15 * vec);


